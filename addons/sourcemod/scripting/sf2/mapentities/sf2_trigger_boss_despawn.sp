// sf2_trigger_boss_despawn

// A trigger that when touched by a boss will despawn the boss from the map.

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2TriggerBossDespawnEntity < SF2TriggerMapEntity
{
	public SF2TriggerBossDespawnEntity(int entIndex) { return view_as<SF2TriggerBossDespawnEntity>(SF2TriggerMapEntity(entIndex)); }

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
	g_entityFactory = new CEntityFactory("sf2_trigger_boss_despawn", OnCreate);
	g_entityFactory.DeriveFromClass("trigger_multiple");

	g_entityFactory.BeginDataMapDesc()
		.DefineOutput("OnDespawn")
	.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SDKHook(iEntity, SDKHook_SpawnPost, OnSpawn);
	SDKHook(iEntity, SDKHook_StartTouchPost, OnStartTouchPost);
}

static void OnSpawn(int iEntity) 
{
	int iSpawnFlags = GetEntProp(iEntity, Prop_Data, "m_spawnflags");
	SetEntProp(iEntity, Prop_Data, "m_spawnflags", iSpawnFlags | TRIGGER_NPCS);
}

static void OnStartTouchPost(int iEntity, int iToucher)
{
	if (!g_bEnabled) return;

	SF2TriggerBossDespawnEntity thisEnt = SF2TriggerBossDespawnEntity(iEntity);

	if (thisEnt.PassesTriggerFilters(iToucher))
	{
		int iBossIndex = NPCGetFromEntIndex(iToucher);
		if (iBossIndex != -1) 
		{
			thisEnt.FireOutput("OnDespawn", iToucher);
			RemoveSlender(iBossIndex);
		}
	}
}