// sf2_info_player_pvpspawn

static CEntityFactory g_entityFactory;

methodmap SF2PlayerPvPSpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2PlayerPvPSpawnEntity(int entIndex) { return view_as<SF2PlayerPvPSpawnEntity>(SF2SpawnPointBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	property bool Enabled
	{
		public get() { return !this.GetProp(Prop_Data, "sf2_bDisabled"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bDisabled", !value); }
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("sf2_info_player_pvpspawn", OnCreate);
	g_entityFactory.DeriveFromFactory(SF2PlayerPvPSpawnEntity.GetBaseFactory());
	g_entityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bDisabled", _, "startdisabled")
		.DefineInputFunc("Enable", InputFuncValueType_Void, InputEnable)
		.DefineInputFunc("Disable", InputFuncValueType_Void, InputDisable)
	.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SF2PlayerPvPSpawnEntity(iEntity).Enabled = true;
}

static void InputEnable(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerPvPSpawnEntity(iEntity).Enabled = true;
}

static void InputDisable(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerPvPSpawnEntity(iEntity).Enabled = false;
}