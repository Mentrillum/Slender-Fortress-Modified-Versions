// sf2_logic_slaughter

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicSlaughterEntity < CBaseEntity
{
	public SF2LogicSlaughterEntity(int entIndex) { return view_as<SF2LogicSlaughterEntity>(CBaseEntity(entIndex)); }

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

SF2LogicSlaughterEntity FindLogicSlaughterEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_logic_slaughter")) != -1)
	{
		SF2LogicSlaughterEntity logicEnt = SF2LogicSlaughterEntity(ent);
		if (!logicEnt.IsValid())
		{
			continue;
		}

		return logicEnt;
	}

	return SF2LogicSlaughterEntity(-1);
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory("sf2_logic_slaughter");
	g_EntityFactory.DeriveFromBaseEntity(true);

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
}