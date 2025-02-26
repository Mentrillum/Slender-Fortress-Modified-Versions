#pragma semicolon 1
#pragma newdecls required

enum struct SF2GlowData
{
	int Ref;
	int Color[4];
	bool VisibleTo[MAXTF2PLAYERS];

	void Init()
	{
		this.Ref = INVALID_ENT_REFERENCE;
		for (int i = 0; i < 4; i++)
		{
			this.Color[i] = 255;
		}

		for (int i = 1; i <= MaxClients; i++)
		{
			this.VisibleTo[i] = false;
		}
	}

	bool IsVisibleTo(int client)
	{
		return this.VisibleTo[client];
	}

	void SetVisibleTo(int client, bool state)
	{
		this.VisibleTo[client] = state;
	}
}

static StringMap g_GlowMap;

void SetupGlows()
{
	g_GlowMap = new StringMap();

	g_OnGamemodeEndPFwd.AddFunction(null, OnGamemodeEnd);
	g_OnMapEndPFwd.AddFunction(null, MapEnd);

	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
}

static void OnGamemodeEnd()
{
	StringMapSnapshot snapshot = g_GlowMap.Snapshot();

	SF2GlowData data;
	char value[32];
	for (int i = 0; i < snapshot.Length; i++)
	{
		snapshot.GetKey(i, value, sizeof(value));

		if (!g_GlowMap.GetArray(value, data, sizeof(data)))
		{
			continue;
		}

		CBaseEntity entity = CBaseEntity(EntRefToEntIndex(data.Ref));
		if (entity.IsValid())
		{
			RemoveEntity(entity.index);
		}
	}

	delete snapshot;
}

static void MapEnd()
{
	g_GlowMap.Clear();
}

static void OnDisconnected(SF2_BasePlayer client)
{
	StringMapSnapshot snapshot = g_GlowMap.Snapshot();

	SF2GlowData data;
	char value[32];
	for (int i = 0; i < snapshot.Length; i++)
	{
		snapshot.GetKey(i, value, sizeof(value));

		if (!g_GlowMap.GetArray(value, data, sizeof(data)))
		{
			continue;
		}

		data.SetVisibleTo(client.index, false);

		g_GlowMap.SetArray(value, data, sizeof(data));
	}

	delete snapshot;
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	DestroyGlowEntity(ent.index);
}

bool DoesEntityHaveGlow(int ent)
{
	SF2GlowData data;
	return GetGlowData(ent, data);
}

static bool GetGlowData(int ent, SF2GlowData data, bool create = false)
{
	if (!IsValidEntity(ent))
	{
		return false;
	}

	char key[32];
	IntToString(EnsureEntRef(ent), key, sizeof(key));

	if (g_GlowMap.GetArray(key, data, sizeof(data)))
	{
		return true;
	}

	if (create)
	{
		data.Init();

		if (g_GlowMap.SetArray(key, data, sizeof(data)))
		{
			return true;
		}
	}

	return false;
}

static bool SetGlowData(int ent, const SF2GlowData data)
{
	if (!IsValidEntity(ent))
	{
		return false;
	}

	char key[32];
	IntToString(EnsureEntRef(ent), key, sizeof(key));

	return g_GlowMap.SetArray(key, data, sizeof(data));
}

static bool RemoveGlowData(int ent)
{
	if (!IsValidEntity(ent))
	{
		return false;
	}

	char key[32];
	IntToString(EnsureEntRef(ent), key, sizeof(key));

	return g_GlowMap.Remove(key);
}

void CreateGlowEntity(int ent, const int color[4] = { 255, 255, 255, 255 }, bool preserveColor = false)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidEntity(ent))
	{
		return;
	}

	SF2GlowData data;
	if (!GetGlowData(ent, data, true))
	{
		return;
	}

	if (!preserveColor)
	{
		for (int i = 0; i < 4; i++)
		{
			data.Color[i] = color[i];
		}
	}

	CBaseEntity glow = CBaseEntity(EntRefToEntIndex(data.Ref));
	if (glow.IsValid())
	{
		RemoveEntity(glow.index);
	}

	glow = CBaseEntity(TF2_CreateGlow(ent));
	SDKHook(glow.index, SDKHook_SetTransmit, SetTransmit);
	data.Ref = EnsureEntRef(glow.index);
	SetEntityTransmitState(glow.index, FL_EDICT_FULLCHECK);

	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, glow.index, UpdateTransmitState);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, glow.index, ShouldTransmit);

	SetVariantColor(data.Color);
	glow.AcceptInput("SetGlowColor");
	glow.AcceptInput("Enable");

	SetGlowData(ent, data);
}

int CreateGlowEntityDataless(int ent, const int color[4] = { 255, 255, 255, 255 })
{
	CBaseEntity glow = CBaseEntity(TF2_CreateGlow(ent));
	SetEntityTransmitState(glow.index, FL_EDICT_FULLCHECK);

	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, glow.index, UpdateTransmitState);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, glow.index, ShouldTransmit);

	SetVariantColor(color);
	glow.AcceptInput("SetGlowColor");
	glow.AcceptInput("Enable");

	return glow.index;
}

void DestroyGlowEntity(int ent)
{
	if (!IsValidEntity(ent))
	{
		return;
	}

	SF2GlowData data;
	if (!GetGlowData(ent, data))
	{
		return;
	}

	CBaseEntity glow = CBaseEntity(EntRefToEntIndex(data.Ref));
	if (glow.IsValid())
	{
		RemoveEntity(glow.index);
	}

	RemoveGlowData(ent);
}

void SetGlowVisibility(int ent, const int[] clients, int numClients, const bool[] visibleStates)
{
	if (numClients == 0 || !IsValidEntity(ent))
	{
		return;
	}

	SF2GlowData data;
	if (!GetGlowData(ent, data))
	{
		return;
	}

	bool update = false;
	CBaseEntity glow = CBaseEntity(EntRefToEntIndex(data.Ref));

	if (!glow.IsValid())
	{
		update = true;
	}

	for (int i = 0; i < numClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(clients[i]);

		bool oldVisible = data.IsVisibleTo(player.index);
		bool visible = visibleStates[i];
		if (oldVisible == visible)
		{
			continue;
		}

		data.SetVisibleTo(player.index, visible);

		if (!update)
		{
			if (!visible && player.IsValid && !player.IsBot)
			{
				update = true;
			}
		}
	}

	SetGlowData(ent, data);

	if (update)
	{
		CreateGlowEntity(ent, .preserveColor = true);
	}
}

void SetGlowVisibilityForClient(int ent, int client, bool visible)
{
	int clients[1];
	clients[0] = client;
	bool visibleStates[1];
	visibleStates[0] = visible;

	SetGlowVisibility(ent, clients, 1, visibleStates);
}

bool SetGlowColor(int ent, const int color[4])
{
	if (!IsValidEntity(ent))
	{
		return false;
	}

	SF2GlowData data;
	if (!GetGlowData(ent, data))
	{
		return false;
	}

	for (int i = 0; i < 4; i++)
	{
		data.Color[i] = color[i];
	}

	SetGlowData(ent, data);

	CBaseEntity glow = CBaseEntity(EntRefToEntIndex(data.Ref));
	if (glow.IsValid())
	{
		SetVariantColor(color);
		glow.AcceptInput("SetGlowColor");
	}

	return true;
}

void SetGlowModel(int ent, const char[] model)
{
	if (!IsValidEntity(ent))
	{
		return;
	}

	SF2GlowData data;
	if (!GetGlowData(ent, data))
	{
		return;
	}

	CBaseEntity glow = CBaseEntity(EntRefToEntIndex(data.Ref));
	if (glow.IsValid())
	{
		glow.SetModel(model);
	}
}

static Action SetTransmit(int ent, int other)
{
	CBaseEntity glow = CBaseEntity(ent);
	CBaseEntity target = CBaseEntity(glow.GetPropEnt(Prop_Send, "m_hTarget"));
	if (!target.IsValid())
	{
		return Plugin_Handled;
	}

	SF2GlowData data;
	if (!GetGlowData(target.index, data))
	{
		return Plugin_Handled;
	}

	if (glow.GetProp(Prop_Send, "m_bDisabled"))
	{
		return Plugin_Continue;
	}

	return data.IsVisibleTo(other) ? Plugin_Continue : Plugin_Handled;
}

static MRESReturn UpdateTransmitState(int glow, DHookReturn returnHook)
{
	returnHook.Value = SetEntityTransmitState(glow, FL_EDICT_FULLCHECK);
	return MRES_Supercede;
}

static MRESReturn ShouldTransmit(int glow, DHookReturn returnHook, DHookParam param)
{
	returnHook.Value = FL_EDICT_ALWAYS;
	return MRES_Supercede;
}
