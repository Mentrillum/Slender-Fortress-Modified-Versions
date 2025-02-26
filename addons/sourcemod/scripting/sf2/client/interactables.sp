#pragma semicolon 1
#pragma newdecls required

static int g_PlayerInteractiveGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerInteractiveGlowTargetEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static float g_NextInteractiveThink[MAXPLAYERS + 1] = { 0.0, ... };

static const char g_InteractableClasses[][64] = {
	"prop_dynamic_override",
	"func_button"
};

static StringMap g_Interactables;

void SetupInteractables()
{
	g_Interactables = new StringMap();

	g_OnMapEndPFwd.AddFunction(null, MapEnd);
	g_OnGamemodeEndPFwd.AddFunction(null, OnGamemodeEnd);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnEntityCreatedPFwd.AddFunction(null, EntityCreated);
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
}

static void MapEnd()
{
	g_Interactables.Clear();
}

static void OnGamemodeEnd()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid)
		{
			continue;
		}

		RemoveInteractiveGlow(player);
	}
}

static void OnPutInServer(SF2_BasePlayer client)
{
	g_PlayerInteractiveGlowTargetEntity[client.index] = INVALID_ENT_REFERENCE;
	g_PlayerInteractiveGlowEntity[client.index] = INVALID_ENT_REFERENCE;
	g_NextInteractiveThink[client.index] = 0.0;

	SDKHook(client.index, SDKHook_PreThinkPost, PreThinkPost);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	RemoveInteractiveGlow(client);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	g_PlayerInteractiveGlowTargetEntity[client.index] = INVALID_ENT_REFERENCE;
	g_NextInteractiveThink[client.index] = 0.0;

	RemoveInteractiveGlow(client);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		g_PlayerInteractiveGlowTargetEntity[client.index] = INVALID_ENT_REFERENCE;
		RemoveInteractiveGlow(client);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	g_PlayerInteractiveGlowTargetEntity[client.index] = INVALID_ENT_REFERENCE;
	RemoveInteractiveGlow(client);
}

static void EntityCreated(CBaseEntity ent, const char[] classname)
{
	for (int i = 0; i < sizeof(g_InteractableClasses); i++)
	{
		if (g_InteractableClasses[i][0] == classname[0] && strcmp(classname, g_InteractableClasses[i]) == 0)
		{
			// Possible interactable. Wait until it spawns.
			SDKHook(ent.index, SDKHook_SpawnPost, CheckIfInteractableSpawnPost);
			break;
		}
	}
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	int entRef = EnsureEntRef(ent.index);

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid)
		{
			continue;
		}

		if (g_PlayerInteractiveGlowTargetEntity[player.index] == entRef)
		{
			g_PlayerInteractiveGlowTargetEntity[player.index] = INVALID_ENT_REFERENCE;
			RemoveInteractiveGlow(player);
		}
	}

	char key[32];
	IntToString(entRef, key, sizeof(key));
	g_Interactables.Remove(key);
}

static void CheckIfInteractableSpawnPost(int entity)
{
	if (IsValidEdict(entity))
	{
		char className[64];
		GetEntityClassname(entity, className, sizeof(className));

		bool isInteractable = false;

		if (strncmp(className, "prop_dynamic", 12) == 0)
		{
			char targetName[64];
			GetEntPropString(entity, Prop_Data, "m_iName", targetName, sizeof(targetName));

			if (targetName[0] && (strncmp(targetName, "sf2_page", 8) == 0 || strncmp(targetName, "sf2_interact", 12) == 0))
			{
				isInteractable = true;
			}
		}
		else if (strncmp(className, "func_button", 11) == 0)
		{
			isInteractable = true;
		}

		if (isInteractable)
		{
			char key[32];
			IntToString(EnsureEntRef(entity), key, sizeof(key));
			g_Interactables.SetValue(key, true);
		}
	}
}

bool IsEntityInteractable(int ent)
{
	if (!IsValidEdict(ent))
	{
		return false;
	}

	bool value;
	char key[32];
	IntToString(EnsureEntRef(ent), key, sizeof(key));
	return g_Interactables.GetValue(key, value);
}

static void PreThinkPost(int clientIndex)
{
	SF2_BasePlayer client = SF2_BasePlayer(clientIndex);

	if (!client.IsEliminated && !client.HasEscaped && client.IsAlive)
	{
		float gameTime = GetGameTime();
		if (gameTime >= g_NextInteractiveThink[clientIndex])
		{
			g_NextInteractiveThink[clientIndex] = gameTime + 0.1;
			UpdateInteractiveGlow(client);
		}
	}
}

static void UpdateInteractiveGlow(SF2_BasePlayer client)
{
	float startPos[3], endPos[3];
	client.GetEyePosition(startPos);
	client.GetEyeAngles(endPos);

	static const float maxRange = 2000.0;
	GetAngleVectors(endPos, endPos, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(endPos, maxRange);
	AddVectors(startPos, endPos, endPos);

	Handle trace = TR_TraceRayFilterEx(startPos, endPos, MASK_VISIBLE, RayType_EndPoint, TraceRayDontHitPlayers, -1);
	int oldTargetEnt = EntRefToEntIndex(g_PlayerInteractiveGlowTargetEntity[client.index]);
	int targetEnt = TR_GetEntityIndex(trace);
	delete trace;
	if (!IsEntityInteractable(targetEnt))
	{
		targetEnt = -1;
	}

	g_PlayerInteractiveGlowTargetEntity[client.index] = targetEnt != -1 ? EntIndexToEntRef(targetEnt) : INVALID_ENT_REFERENCE;

	if (targetEnt != oldTargetEnt)
	{
		RemoveInteractiveGlow(client);

		if (IsValidEntity(targetEnt))
		{
			CBaseEntity glow = CBaseEntity(CreateGlowEntityDataless(targetEnt));
			SDKHook(glow.index, SDKHook_SetTransmit, InteractableSetTransmit);
			glow.SetPropEnt(Prop_Data, "m_hOwnerEntity", client.index);
			g_PlayerInteractiveGlowEntity[client.index] = EntIndexToEntRef(glow.index);
		}
	}

	if (targetEnt == -1)
	{
		RemoveInteractiveGlow(client);
	}
}

static Action InteractableSetTransmit(int ent, int other)
{
	return GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity") == other ? Plugin_Continue : Plugin_Handled;
}

static void RemoveInteractiveGlow(SF2_BasePlayer player)
{
	int glow = EntRefToEntIndex(g_PlayerInteractiveGlowEntity[player.index]);
	if (IsValidEntity(glow))
	{
		RemoveEntity(glow);
	}

	g_PlayerInteractiveGlowEntity[player.index] = INVALID_ENT_REFERENCE;
}