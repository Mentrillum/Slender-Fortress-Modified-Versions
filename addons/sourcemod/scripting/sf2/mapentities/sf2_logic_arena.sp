// sf2_logic_arena

#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_logic_arena"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicRenevantEntity < CBaseEntity
{
	public SF2LogicRenevantEntity(int entIndex) { return view_as<SF2LogicRenevantEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	property int FinaleTime
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iFinaleTime"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iFinaleTime", value); }
	}

	public static void Initialize()
	{
		Initialize();
	}
}

SF2LogicRenevantEntity FindLogicRenevantEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, g_EntityClassname)) != -1)
	{
		SF2LogicRenevantEntity renevantLogic = SF2LogicRenevantEntity(ent);
		if (!renevantLogic.IsValid())
		{
			continue;
		}

		return renevantLogic;
	}

	return SF2LogicRenevantEntity(-1);
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreate);
	g_EntityFactory.DeriveFromBaseEntity(true);
	g_EntityFactory.BeginDataMapDesc()
		.DefineIntField("sf2_iFinaleTime", _, "finaletime")
		.DefineInputFunc("SetWave", InputFuncValueType_Integer, InputSetWave)
		.DefineInputFunc("SetWaveResetTimer", InputFuncValueType_Integer, InputSetWaveResetTimer)
		.DefineInputFunc("RequestWave", InputFuncValueType_Void, InputRequestWave)
		.DefineOutput("OnRequestWave")
		.DefineOutput("OnWaveTriggered")
	.EndDataMapDesc();

	g_EntityFactory.Install();

	SF2MapEntity_AddHook(SF2MapEntityHook_OnRenevantWaveTriggered, OnRenevantWaveTriggered);
}

static void OnCreate(int entity)
{
	SF2LogicRenevantEntity thisEnt = SF2LogicRenevantEntity(entity);
	thisEnt.FinaleTime = 60;
}

static void OnRenevantWaveTriggered(int wave)
{
	SF2LogicRenevantEntity logicEnt = FindLogicRenevantEntity();
	if (!logicEnt.IsValid())
	{
		return;
	}

	SetVariantInt(wave);
	logicEnt.FireOutput("OnWaveTriggered");
}

static void InputSetWave(int entity, int activator, int caller, int wave)
{
	if (wave < 0)
	{
		wave = 0;
	}
	if (wave > RENEVANT_MAXWAVES)
	{
		wave = RENEVANT_MAXWAVES;
	}

	Renevant_SetWave(wave);
}

static void InputSetWaveResetTimer(int entity, int activator, int caller, int wave)
{
	if (wave < 0)
	{
		wave = 0;
	}
	if (wave > RENEVANT_MAXWAVES)
	{
		wave = RENEVANT_MAXWAVES;
	}

	Renevant_SetWave(wave, true);
}

static void InputRequestWave(int entity, int activator, int caller)
{
	SetVariantInt(g_RenevantWaveNumber);
	SF2LogicRenevantEntity(entity).FireOutput("OnRequestWave", activator);
}