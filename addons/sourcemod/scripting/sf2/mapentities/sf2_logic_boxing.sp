// sf2_logic_boxing

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicBoxingEntity < CBaseEntity
{
	public SF2LogicBoxingEntity(int entIndex) { return view_as<SF2LogicBoxingEntity>(CBaseEntity(entIndex)); }

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

SF2LogicBoxingEntity FindLogicBoxingEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_logic_boxing")) != -1)
	{
		SF2LogicBoxingEntity logicEnt = SF2LogicBoxingEntity(ent);
		if (!logicEnt.IsValid())
		{
			continue;
		}

		return logicEnt;
	}

	return SF2LogicBoxingEntity(-1);
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_logic_boxing");
	g_EntityFactory.DeriveFromBaseEntity(true);

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
}