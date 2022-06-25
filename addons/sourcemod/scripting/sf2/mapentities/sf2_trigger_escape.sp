// sf2_trigger_escape

// A trigger that when touched by a player on RED will let the player escape.
// Escaping can only occur during the Escape phase.

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerEscapeEntity < SF2TriggerMapEntity
{
	public SF2TriggerEscapeEntity(int entIndex) { return view_as<SF2TriggerEscapeEntity>(SF2TriggerMapEntity(entIndex)); }

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
	g_EntityFactory = new CEntityFactory("sf2_trigger_escape", OnCreate);
	g_EntityFactory.DeriveFromClass("trigger_multiple");

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
}

static void OnCreate(int entity)
{
	SDKHook(entity, SDKHook_SpawnPost, OnSpawn);
	SDKHook(entity, SDKHook_StartTouchPost, OnStartTouchPost);
}

static void OnSpawn(int entity)
{
	int spawnFlags = GetEntProp(entity, Prop_Data, "m_spawnflags");
	SetEntProp(entity, Prop_Data, "m_spawnflags", spawnFlags | TRIGGER_CLIENTS);
}

static void OnStartTouchPost(int entity, int toucher)
{
	if (!g_Enabled)
	{
		return;
	}

	SF2TriggerMapEntity trigger = SF2TriggerMapEntity(entity);

	if (IsRoundInEscapeObjective() && trigger.PassesTriggerFilters(toucher))
	{
		if (IsValidClient(toucher) && IsPlayerAlive(toucher) && !IsClientInDeathCam(toucher) && !g_PlayerEliminated[toucher] && !DidClientEscape(toucher))
		{
			ClientEscape(toucher);
			TeleportClientToEscapePoint(toucher);
		}
	}
}
