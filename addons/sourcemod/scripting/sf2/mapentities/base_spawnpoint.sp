#pragma semicolon 1

static CEntityFactory g_EntityFactory;

methodmap SF2SpawnPointBaseEntity < CBaseEntity
{
	public SF2SpawnPointBaseEntity(int entIndex)
	{
		return view_as<SF2SpawnPointBaseEntity>(CBaseEntity(entIndex));
	}

	public static CEntityFactory GetBaseFactory()
	{
		return g_EntityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("SF2SpawnPointBaseEntity");
	g_EntityFactory.IsAbstract = true;
	g_EntityFactory.DeriveFromBaseEntity(true);
	g_EntityFactory.BeginDataMapDesc()
		.DefineOutput("OnSpawn")
		.EndDataMapDesc();
	g_EntityFactory.Install();
}