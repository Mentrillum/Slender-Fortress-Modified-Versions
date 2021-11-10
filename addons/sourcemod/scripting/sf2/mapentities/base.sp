// base

// Not an actual entity; use this as a template for creating new entities.
// Replace "SF2MapEntityBase" with the identifier you want.

// To initialize, call the SF2MapEntityBase_Initialize() function from SF2MapEntity_Initialize().

static const char g_sEntityClassname[] = ""; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = ""; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2MapEntityBaseData
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
methodmap SF2MapEntityBase < SF2MapEntity
{
	public SF2MapEntityBase(int entIndex) { return view_as<SF2MapEntityBase>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2MapEntityBaseData entData;
		return (SF2MapEntityBaseData_Get(this.EntRef, entData) != -1);
	}
}

void SF2MapEntityBase_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2MapEntityBaseData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2MapEntityBase_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2MapEntityBase_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2MapEntityBase_OnEntityDestroyed);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2MapEntityBase_OnAcceptEntityInput);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2MapEntityBase_OnEntityKeyValue);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2MapEntityBase_OnLevelInit);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2MapEntityBase_OnMapStart);
}

static void SF2MapEntityBase_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2MapEntityBaseData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	//SDKHook(entity, SDKHook_SpawnPost, SF2MapEntityBase_SpawnPost);
}

static Action SF2MapEntityBase_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static Action SF2MapEntityBase_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static void SF2MapEntityBase_SpawnPost(int entity) 
{
}

static void SF2MapEntityBase_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2MapEntityBaseData entData;
	int iIndex = SF2MapEntityBaseData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2MapEntityBase_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2MapEntityBaseData_Get(int entIndex, SF2MapEntityBaseData entData)
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

static int SF2MapEntityBaseData_Update(SF2MapEntityBaseData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}