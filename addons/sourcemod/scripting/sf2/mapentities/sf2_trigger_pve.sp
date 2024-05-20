// sf2_trigger_pve

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerPvEEntity < SF2TriggerMapEntity
{
	public SF2TriggerPvEEntity(int entIndex)
	{
		return view_as<SF2TriggerPvEEntity>(SF2TriggerMapEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	property bool IsBossPvE
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsBossPvE") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsBossPvE", value);
		}
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_trigger_pve", OnCreate);
	g_EntityFactory.DeriveFromClass("trigger_multiple");
	g_EntityFactory.BeginDataMapDesc()
		.DefineBoolField("m_IsBossPvE", _, "bosspve")
		.EndDataMapDesc();

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
	PvE_OnTriggerStartTouch(entity, toucher);
}

static void OnEndTouchPost(int entity, int toucher)
{
	PvE_OnTriggerEndTouch(entity, toucher);
}