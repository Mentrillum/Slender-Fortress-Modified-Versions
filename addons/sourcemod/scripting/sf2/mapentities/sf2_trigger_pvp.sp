// sf2_trigger_pvp

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerPvPEntity < SF2TriggerMapEntity
{
	public SF2TriggerPvPEntity(int entIndex)
	{
		return view_as<SF2TriggerPvPEntity>(SF2TriggerMapEntity(entIndex));
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
	g_EntityFactory = new CEntityFactory("sf2_trigger_pvp", OnCreate);
	g_EntityFactory.DeriveFromClass("trigger_multiple");

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
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
	PvP_OnTriggerStartTouch(entity, toucher);
}

static void OnEndTouchPost(int entity, int toucher)
{
	PvP_OnTriggerEndTouch(entity, toucher);
}