// sf2_info_player_proxyspawn

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

methodmap SF2PlayerProxySpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2PlayerProxySpawnEntity(int entIndex)
	{
		return view_as<SF2PlayerProxySpawnEntity>(SF2SpawnPointBaseEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	property bool Enabled
	{
		public get()
		{
			return !this.GetProp(Prop_Data, "sf2_bDisabled");
		}
		public set(bool value)
		{
			this.SetProp(Prop_Data, "sf2_bDisabled", !value);
		}
	}

	property bool IgnoreVisibility
	{
		public get()
		{
			return !!this.GetProp(Prop_Data, "sf2_bIgnoreVisibility");
		}
		public set(bool value)
		{
			this.SetProp(Prop_Data, "sf2_bIgnoreVisibility", value);
		}
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_info_player_proxyspawn", OnCreate);
	g_EntityFactory.DeriveFromFactory(SF2PlayerProxySpawnEntity.GetBaseFactory());
	g_EntityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bDisabled", _, "startdisabled")
		.DefineBoolField("sf2_bIgnoreVisibility", _, "ignorevisibility")
		.DefineInputFunc("Enable", InputFuncValueType_Void, InputEnable)
		.DefineInputFunc("Disable", InputFuncValueType_Void, InputDisable)
		.DefineInputFunc("EnableIgnoreVisibility", InputFuncValueType_Void, InputEnableIgnoreVisibility)
		.DefineInputFunc("DisableIgnoreVisibility", InputFuncValueType_Void, InputDisableIgnoreVisibility)
	.EndDataMapDesc();

	g_EntityFactory.Install();
}

static void OnCreate(int entity)
{
	SF2PlayerProxySpawnEntity thisEnt = SF2PlayerProxySpawnEntity(entity);

	thisEnt.Enabled = true;
	thisEnt.IgnoreVisibility = false;
}

static void InputEnable(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerProxySpawnEntity(entity).Enabled = true;
}

static void InputDisable(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerProxySpawnEntity(entity).Enabled = false;
}

static void InputEnableIgnoreVisibility(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerProxySpawnEntity(entity).IgnoreVisibility = true;
}

static void InputDisableIgnoreVisibility(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerProxySpawnEntity(entity).IgnoreVisibility = false;
}