// base

// Not an actual entity; use this as a template for creating new entities.
// Replace "SF2MapEntityBase" with the identifier you want.

// To initialize, call the SF2MapEntityBase.Initialize() function from SetupCustomMapEntities().

static const char g_sEntityClassname[] = ""; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2MapEntityBase < CBaseEntity
{
	public SF2MapEntityBase(int entIndex) { return view_as<SF2MapEntityBase>(CBaseEntity(entIndex)); }

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
	g_entityFactory = new CEntityFactory(g_sEntityClassname, OnCreated, OnRemoved);
	g_entityFactory.DeriveFromBaseEntity(true);
	/*
	g_entityFactory.BeginDataMapDesc()
		.EndDataMapDesc();
	*/
	g_entityFactory.Install();
}

static void OnCreated(int entity)
{
}

static void OnRemoved(int entity)
{
}