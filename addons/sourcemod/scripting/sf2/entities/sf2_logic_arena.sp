// sf2_logic_arena

static const char g_sEntityClassname[] = "sf2_logic_arena"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2LogicRenevantEntityData
{
	int EntRef;
	int FinaleTime;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.FinaleTime = 60;
	}

	void Destroy()
	{
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicRenevantEntity < SF2MapEntity
{
	public SF2LogicRenevantEntity(int entIndex) { return view_as<SF2LogicRenevantEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2LogicRenevantEntityData entData;
		return (SF2LogicRenevantEntityData_Get(this.EntRef, entData) != -1);
	}

	property int FinaleTime
	{
		public get() 
		{
			SF2LogicRenevantEntityData entData; SF2LogicRenevantEntityData_Get(this.EntRef, entData); return entData.FinaleTime;
		}
	}
}

SF2LogicRenevantEntity FindLogicRenevantEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, g_sEntityClassname)) != -1)
	{
		SF2LogicRenevantEntity renevantLogic = SF2LogicRenevantEntity(ent);
		if (!renevantLogic.IsValid())
			continue;

		return renevantLogic;
	}

	return SF2LogicRenevantEntity(-1);
}

void SF2LogicRenevantEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2LogicRenevantEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2LogicRenevantEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2LogicRenevantEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2LogicRenevantEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2LogicRenevantEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2LogicRenevantEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2LogicRenevantEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2LogicRenevantEntity_OnMapStart);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnRenevantWaveTriggered, SF2LogicRenevantEntity_OnRenevantWaveTriggered);
}

static void SF2LogicRenevantEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2LogicRenevantEntity_OnMapStart() 
{
}

static void SF2LogicRenevantEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2LogicRenevantEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2LogicRenevantEntity_SpawnPost);
}

static Action SF2LogicRenevantEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2LogicRenevantEntityData entData;
	int iIndex = SF2LogicRenevantEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;

	SF2LogicRenevantEntity logicEnt = SF2LogicRenevantEntity(entity);

	if (strcmp(szKeyName, "finaletime", false) == 0)
	{
		int iFinaleTime = StringToInt(szValue);
		if (iFinaleTime < 0) iFinaleTime = 0;

		entData.FinaleTime = iFinaleTime;
		SF2LogicRenevantEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnRequestWave", false) == 0 ||
		strcmp(szKeyName, "OnWaveTriggered", false) == 0)
	{
		logicEnt.AddOutput(szKeyName, szValue);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void SF2LogicRenevantEntity_OnRenevantWaveTriggered(int iWave)
{
	SF2MapEntityVariant inputVariant;
	inputVariant.Init();
	inputVariant.SetInt(iWave);

	for (int i = 0; i < g_EntityData.Length; i++) 
	{
		SF2LogicRenevantEntityData entData;
		g_EntityData.GetArray(i, entData, sizeof(entData));

		if (!IsValidEntity(entData.EntRef))
			continue;

		SF2LogicRenevantEntity logicEnt = SF2LogicRenevantEntity(entData.EntRef);

		logicEnt.FireOutput("OnWaveTriggered", entData.EntRef, entData.EntRef, inputVariant);
	}
}

static Action SF2LogicRenevantEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2LogicRenevantEntityData entData;
	int iIndex = SF2LogicRenevantEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;
	
	SF2LogicRenevantEntity logicEnt = SF2LogicRenevantEntity(entity);

	if (strcmp(szInputName, "SetWave", false) == 0)
	{
		int iWave = SF2MapEntity_GetIntFromVariant();
		if (iWave < 0)
			iWave = 0;
		if (iWave > RENEVANT_MAXWAVES)
			iWave = RENEVANT_MAXWAVES;
		
		Renevant_SetWave(iWave);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetWaveResetTimer", false) == 0)
	{
		int iWave = SF2MapEntity_GetIntFromVariant();
		if (iWave < 0)
			iWave = 0;
		if (iWave > RENEVANT_MAXWAVES)
			iWave = RENEVANT_MAXWAVES;
		
		Renevant_SetWave(iWave, true);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "RequestWave", false) == 0)
	{
		SF2MapEntityVariant inputVariant;
		inputVariant.Init();
		inputVariant.SetInt(g_iRenevantWaveNumber);
		logicEnt.FireOutput("OnRequestWave", activator, caller, inputVariant);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void SF2LogicRenevantEntity_SpawnPost(int entity) 
{
}

static void SF2LogicRenevantEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2LogicRenevantEntityData entData;
	int iIndex = SF2LogicRenevantEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2LogicRenevantEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2LogicRenevantEntityData_Get(int entIndex, SF2LogicRenevantEntityData entData)
{
	entData.EntRef = EnsureEntRef(entIndex);
	if (entData.EntRef == INVALID_ENT_REFERENCE)
		return -1;

	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return -1;
	
	g_EntityData.GetArray(iIndex, entData, sizeof(entData));
	return iIndex;
}

static int SF2LogicRenevantEntityData_Update(SF2LogicRenevantEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}