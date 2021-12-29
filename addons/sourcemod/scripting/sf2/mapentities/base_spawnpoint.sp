
static CEntityFactory g_entityFactory;

methodmap SF2SpawnPointBaseEntity < CBaseEntity
{
	public SF2SpawnPointBaseEntity(int entIndex) { return view_as<SF2SpawnPointBaseEntity>(CBaseEntity(entIndex)); }

	public static CEntityFactory GetBaseFactory()
	{
		return g_entityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("SF2SpawnPointBaseEntity");
	g_entityFactory.IsAbstract = true;
	g_entityFactory.DeriveFromBaseEntity(true);
	g_entityFactory.BeginDataMapDesc()
		.DefineOutput("OnSpawn")
		.EndDataMapDesc();
	g_entityFactory.Install();
}