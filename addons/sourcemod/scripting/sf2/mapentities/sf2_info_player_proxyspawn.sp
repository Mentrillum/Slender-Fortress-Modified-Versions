// sf2_info_player_proxyspawn

static const char g_sEntityClassname[] = "sf2_info_player_proxyspawn"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

enum struct SF2PlayerProxySpawnEntityData
{
	int EntRef;
	bool Enabled;
	bool IgnoreVisibility;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.Enabled = true;
		this.IgnoreVisibility = false;
	}

	void Destroy()
	{
	}
}

methodmap SF2PlayerProxySpawnEntity < SF2MapEntity
{
	public SF2PlayerProxySpawnEntity(int entIndex) { return view_as<SF2PlayerProxySpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2PlayerProxySpawnEntityData entData;
		return (SF2PlayerProxySpawnEntityData_Get(this.EntRef, entData) != -1);
	}

	property bool Enabled
	{
		public get() 
		{
			SF2PlayerProxySpawnEntityData entData; SF2PlayerProxySpawnEntityData_Get(this.EntRef, entData); return entData.Enabled;
		}
	}

	property bool IgnoreVisibility
	{
		public get() 
		{
			SF2PlayerProxySpawnEntityData entData; SF2PlayerProxySpawnEntityData_Get(this.EntRef, entData); return entData.IgnoreVisibility;
		}
	}
}

void SF2PlayerProxySpawnEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2PlayerProxySpawnEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2PlayerProxySpawnEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2PlayerProxySpawnEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2PlayerProxySpawnEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2PlayerProxySpawnEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2PlayerProxySpawnEntity_OnEntityKeyValue);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2PlayerProxySpawnEntity_OnLevelInit);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2PlayerProxySpawnEntity_OnMapStart);
}

/*
static void SF2PlayerProxySpawnEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2PlayerProxySpawnEntity_OnMapStart() 
{
}
*/

static void SF2PlayerProxySpawnEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2PlayerProxySpawnEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	//SDKHook(entity, SDKHook_SpawnPost, SF2PlayerProxySpawnEntity_SpawnPost);
}

static Action SF2PlayerProxySpawnEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PlayerProxySpawnEntityData entData;
	if (SF2PlayerProxySpawnEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;

	SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(entity);
	
	if (strcmp(szKeyName, "startdisabled", false) == 0)
	{
		entData.Enabled = StringToInt(szValue) == 0;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "ignorevisibility", false) == 0)
	{
		entData.IgnoreVisibility = StringToInt(szValue) != 0;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnSpawn", false) == 0)
	{
		spawnPoint.AddOutput(szKeyName, szValue);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2PlayerProxySpawnEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PlayerProxySpawnEntityData entData;
	if (SF2PlayerProxySpawnEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;

	if (strcmp(szInputName, "Enable", false) == 0)
	{
		entData.Enabled = true;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "Disable", false) == 0)
	{
		entData.Enabled = false;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EnableIgnoreVisibility", false) == 0)
	{
		entData.IgnoreVisibility = true;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DisableIgnoreVisibility", false) == 0)
	{
		entData.IgnoreVisibility = false;
		SF2PlayerProxySpawnEntityData_Update(entData);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

/*
static void SF2PlayerProxySpawnEntity_SpawnPost(int entity) 
{
}
*/

static void SF2PlayerProxySpawnEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2PlayerProxySpawnEntityData entData;
	int iIndex = SF2PlayerProxySpawnEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2PlayerProxySpawnEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2PlayerProxySpawnEntityData_Get(int entIndex, SF2PlayerProxySpawnEntityData entData)
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

static int SF2PlayerProxySpawnEntityData_Update(SF2PlayerProxySpawnEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}