// sf2_logic_raid

static const char g_sEntityClassname[] = "sf2_logic_raid"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2LogicRaidEntityData
{
	int EntRef;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
	}

	void Destroy()
	{
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2LogicRaidEntity < SF2MapEntity
{
	public SF2LogicRaidEntity(int entIndex) { return view_as<SF2LogicRaidEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2LogicRaidEntityData entData;
		return (SF2LogicRaidEntityData_Get(this.EntRef, entData) != -1);
	}
}

SF2LogicRaidEntity FindLogicRaidEntity()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, g_sEntityClassname)) != -1)
	{
		SF2LogicRaidEntity raidLogic = SF2LogicRaidEntity(ent);
		if (!raidLogic.IsValid())
			continue;

		return raidLogic;
	}

	return SF2LogicRaidEntity(-1);
}

void SF2LogicRaidEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2LogicRaidEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2LogicRaidEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2LogicRaidEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2LogicRaidEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2LogicRaidEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2LogicRaidEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2LogicRaidEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2LogicRaidEntity_OnMapStart);
}

static void SF2LogicRaidEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2LogicRaidEntity_OnMapStart() 
{
}

static void SF2LogicRaidEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2LogicRaidEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2LogicRaidEntity_SpawnPost);
}

static Action SF2LogicRaidEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static Action SF2LogicRaidEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static void SF2LogicRaidEntity_SpawnPost(int entity) 
{
}

static void SF2LogicRaidEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2LogicRaidEntityData entData;
	int iIndex = SF2LogicRaidEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2LogicRaidEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2LogicRaidEntityData_Get(int entIndex, SF2LogicRaidEntityData entData)
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

/*
static int SF2LogicRaidEntityData_Update(SF2LogicRaidEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}
*/