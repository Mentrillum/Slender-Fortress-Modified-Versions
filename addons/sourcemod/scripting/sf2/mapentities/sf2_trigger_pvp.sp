// sf2_trigger_pvp

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerPvPEntity < SF2TriggerMapEntity
{
	public SF2TriggerPvPEntity(int entIndex) { return view_as<SF2TriggerPvPEntity>(SF2TriggerMapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("sf2_trigger_pvp", OnCreate);
	g_entityFactory.DeriveFromClass("trigger_multiple");

	//g_entityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SDKHook(iEntity, SDKHook_SpawnPost, OnSpawn);
	SDKHook(iEntity, SDKHook_StartTouchPost, OnStartTouchPost);
	SDKHook(iEntity, SDKHook_EndTouchPost, OnEndTouchPost);
}

static void OnSpawn(int iEntity)
{
	int iSpawnFlags = GetEntProp(iEntity, Prop_Data, "m_spawnflags");
	SetEntProp(iEntity, Prop_Data, "m_spawnflags", iSpawnFlags | TRIGGER_CLIENTS);
}

static void OnStartTouchPost(int iEntity, int iToucher)
{
	PvP_OnTriggerStartTouch(iEntity, iToucher);
}

static void OnEndTouchPost(int iEntity, int iToucher)
{
	PvP_OnTriggerEndTouch(iEntity, iToucher);
}