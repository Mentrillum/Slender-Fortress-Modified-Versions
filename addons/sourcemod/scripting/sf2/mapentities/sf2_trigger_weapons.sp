// sf2_trigger_weapons

#pragma semicolon 1
#pragma newdecls required

static CEntityFactory g_EntityFactory;

static bool g_PlayerInWeaponsTrigger[MAXTF2PLAYERS];
static ArrayList g_PlayerEnteredWeaponTriggers[MAXTF2PLAYERS] = { null, ... };

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerWeaponsEntity < SF2TriggerMapEntity
{
	public SF2TriggerWeaponsEntity(int entIndex)
	{
		return view_as<SF2TriggerWeaponsEntity>(SF2TriggerMapEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_trigger_weapons", OnCreate);
	g_EntityFactory.DeriveFromClass("trigger_multiple");

	g_EntityFactory.Install();

	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	g_PlayerEnteredWeaponTriggers[client.index] = new ArrayList();
	g_PlayerInWeaponsTrigger[client.index] = false;
}

static void OnDisconnected(SF2_BasePlayer client)
{
	SetWeaponsState(client.index, false, false);

	if (g_PlayerEnteredWeaponTriggers[client.index] != null)
	{
		delete g_PlayerEnteredWeaponTriggers[client.index];
		g_PlayerEnteredWeaponTriggers[client.index] = null;
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (IsRoundInWarmup() || GameRules_GetProp("m_bInWaitingForPlayers"))
	{
		return;
	}

	SetWeaponsState(client.index, false, false);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		SetWeaponsState(client.index, false, false);
	}
}

static void OnCreate(int entity)
{
	SDKHook(entity, SDKHook_SpawnPost, OnSpawn);
	SDKHook(entity, SDKHook_StartTouchPost, OnStartTouchPost);
	SDKHook(entity, SDKHook_EndTouchPost, OnEndTouchPost);
}

static void OnSpawn(int entity)
{
	int spawnFlags = GetEntProp(entity, Prop_Data, "m_spawnflags");
	SetEntProp(entity, Prop_Data, "m_spawnflags", spawnFlags | TRIGGER_CLIENTS);
}

static void OnStartTouchPost(int entity, int toucher)
{
	if (!IsValidClient(toucher) || !IsPlayerAlive(toucher) || IsClientInGhostMode(toucher))
	{
		return;
	}

	if (!g_PlayerEliminated[toucher] && !DidClientEscape(toucher))
	{
		return;
	}

	int entRef = EnsureEntRef(entity);
	if (g_PlayerEnteredWeaponTriggers[toucher].FindValue(entRef) == -1)
	{
		g_PlayerEnteredWeaponTriggers[toucher].Push(entRef);
	}

	SetWeaponsState(toucher, true);
}

static void OnEndTouchPost(int entity, int toucher)
{
	if (!IsValidClient(toucher))
	{
		return;
	}

	if (g_PlayerEnteredWeaponTriggers[toucher] != null)
	{
		int triggerEntRef = EnsureEntRef(entity);
		for (int i = g_PlayerEnteredWeaponTriggers[toucher].Length - 1; i >= 0; i--)
		{
			int entRef = g_PlayerEnteredWeaponTriggers[toucher].Get(i);
			if (entRef == triggerEntRef)
			{
				g_PlayerEnteredWeaponTriggers[toucher].Erase(i);
			}
			else if (EntRefToEntIndex(entRef) == INVALID_ENT_REFERENCE)
			{
				g_PlayerEnteredWeaponTriggers[toucher].Erase(i);
			}
		}
	}

	if (IsClientInWeaponsTrigger(toucher) && g_PlayerEnteredWeaponTriggers[toucher].Length == 0)
	{
		SetWeaponsState(toucher, false);
	}
}

static void SetWeaponsState(int client, bool status, bool regenerate = true)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid)
	{
		return;
	}

	bool old = g_PlayerInWeaponsTrigger[player.index];
	if (status == old)
	{
		return;
	}

	g_PlayerInWeaponsTrigger[player.index] = status;

	if (regenerate)
	{
		int health = player.GetProp(Prop_Send, "m_iHealth");
		player.RemoveWeaponSlot(TFWeaponSlot_Primary);
		player.RemoveWeaponSlot(TFWeaponSlot_Secondary);
		player.Regenerate();
		player.SetProp(Prop_Data, "m_iHealth", health);
		player.SetProp(Prop_Send, "m_iHealth", health);
	}
}

bool IsClientInWeaponsTrigger(int client)
{
	return g_PlayerInWeaponsTrigger[client];
}