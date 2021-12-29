// sf2_logic_proxy

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicProxyEntity < CBaseEntity
{
	public SF2LogicProxyEntity(int entIndex) { return view_as<SF2LogicProxyEntity>(CBaseEntity(entIndex)); }

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
	g_entityFactory = new CEntityFactory("sf2_logic_proxy");
	g_entityFactory.DeriveFromBaseEntity(true);

	//g_entityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_entityFactory.Install();
}

SF2LogicProxyEntity FindLogicProxyEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_logic_proxy")) != -1)
	{
		SF2LogicProxyEntity raidLogic = SF2LogicProxyEntity(ent);
		if (!raidLogic.IsValid())
			continue;

		return raidLogic;
	}

	return SF2LogicProxyEntity(-1);
}