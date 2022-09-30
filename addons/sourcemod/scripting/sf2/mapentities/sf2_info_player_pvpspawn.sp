// sf2_info_player_pvpspawn

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

methodmap SF2PlayerPvPSpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2PlayerPvPSpawnEntity(int entIndex) { return view_as<SF2PlayerPvPSpawnEntity>(SF2SpawnPointBaseEntity(entIndex)); }

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
	g_EntityFactory = new CEntityFactory("sf2_info_player_pvpspawn", OnCreate);
	g_EntityFactory.DeriveFromFactory(SF2PlayerPvPSpawnEntity.GetBaseFactory());
	g_EntityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bDisabled", _, "startdisabled")
		.DefineInputFunc("Enable", InputFuncValueType_Void, InputEnable)
		.DefineInputFunc("Disable", InputFuncValueType_Void, InputDisable)
	.EndDataMapDesc();

	g_EntityFactory.Install();
}

static void OnCreate(int entity)
{
	SF2PlayerPvPSpawnEntity(entity).Enabled = true;
}

static void InputEnable(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerPvPSpawnEntity(entity).Enabled = true;
}

static void InputDisable(int entity, int activator, int caller)
{
	// Suppress warnings
	activator = caller;
	caller = activator;
	SF2PlayerPvPSpawnEntity(entity).Enabled = false;
}