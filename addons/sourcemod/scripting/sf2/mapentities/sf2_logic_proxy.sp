// sf2_logic_proxy

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicProxyEntity < CBaseEntity
{
	public SF2LogicProxyEntity(int entIndex) { return view_as<SF2LogicProxyEntity>(CBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_logic_proxy");
	g_EntityFactory.DeriveFromBaseEntity(true);

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
}

SF2LogicProxyEntity FindLogicProxyEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_logic_proxy")) != -1)
	{
		SF2LogicProxyEntity raidLogic = SF2LogicProxyEntity(ent);
		if (!raidLogic.IsValid())
		{
			continue;
		}

		return raidLogic;
	}

	return SF2LogicProxyEntity(-1);
}