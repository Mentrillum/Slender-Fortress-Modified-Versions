// sf2_info_player_proxyspawn

static CEntityFactory g_entityFactory;

methodmap SF2PlayerProxySpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2PlayerProxySpawnEntity(int entIndex) { return view_as<SF2PlayerProxySpawnEntity>(SF2SpawnPointBaseEntity(entIndex)); }
	
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

	property bool IgnoreVisibility
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bIgnoreVisibility"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bIgnoreVisibility", value); }
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("sf2_info_player_proxyspawn", OnCreate);
	g_entityFactory.DeriveFromFactory(SF2PlayerProxySpawnEntity.GetBaseFactory());
	g_entityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bDisabled", _, "startdisabled")
		.DefineBoolField("sf2_bIgnoreVisibility", _, "ignorevisibility")
		.DefineInputFunc("Enable", InputFuncValueType_Void, InputEnable)
		.DefineInputFunc("Disable", InputFuncValueType_Void, InputDisable)
		.DefineInputFunc("EnableIgnoreVisibility", InputFuncValueType_Void, InputEnableIgnoreVisibility)
		.DefineInputFunc("DisableIgnoreVisibility", InputFuncValueType_Void, InputDisableIgnoreVisibility)
	.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SF2PlayerProxySpawnEntity thisEnt = SF2PlayerProxySpawnEntity(iEntity);

	thisEnt.Enabled = true;
	thisEnt.IgnoreVisibility = false;
}

static void InputEnable(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerProxySpawnEntity(iEntity).Enabled = true;
}

static void InputDisable(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerProxySpawnEntity(iEntity).Enabled = false;
}

static void InputEnableIgnoreVisibility(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerProxySpawnEntity(iEntity).IgnoreVisibility = true;
}

static void InputDisableIgnoreVisibility(int iEntity, int iActivator, int iCaller)
{
	// Suppress warnings
	iActivator = iCaller;
	iCaller = iActivator;
	SF2PlayerProxySpawnEntity(iEntity).IgnoreVisibility = false;
}