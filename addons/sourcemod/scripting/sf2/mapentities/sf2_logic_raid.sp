// sf2_logic_raid

#pragma semicolon 1

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicRaidEntity < CBaseEntity
{
	public SF2LogicRaidEntity(int entIndex)
	{
		return view_as<SF2LogicRaidEntity>(CBaseEntity(entIndex));
	}

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
	g_EntityFactory = new CEntityFactory("sf2_logic_raid");
	g_EntityFactory.DeriveFromBaseEntity(true);

	//g_EntityFactory.BeginDataMapDesc()
	//.EndDataMapDesc();

	g_EntityFactory.Install();
}

SF2LogicRaidEntity FindLogicRaidEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_logic_raid")) != -1)
	{
		SF2LogicRaidEntity raidLogic = SF2LogicRaidEntity(ent);
		if (!raidLogic.IsValid())
		{
			continue;
		}

		return raidLogic;
	}

	return SF2LogicRaidEntity(-1);
}