// sf2_info_player_escapespawn

static const char g_sEntityClassname[] = "sf2_info_player_escapespawn"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

enum struct SF2PlayerEscapeSpawnEntityData
{
	int EntRef;
	bool Enabled;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.Enabled = true;
	}

	void Destroy()
	{
	}
}

methodmap SF2PlayerEscapeSpawnEntity < SF2MapEntity
{
	public SF2PlayerEscapeSpawnEntity(int entIndex) { return view_as<SF2PlayerEscapeSpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2PlayerEscapeSpawnEntityData entData;
		return (SF2PlayerEscapeSpawnEntityData_Get(this.EntRef, entData) != -1);
	}

	property bool Enabled
	{
		public get() 
		{
			SF2PlayerEscapeSpawnEntityData entData; SF2PlayerEscapeSpawnEntityData_Get(this.EntRef, entData); return entData.Enabled;
		}
	}
}

void SF2PlayerEscapeSpawnEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2PlayerEscapeSpawnEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2PlayerEscapeSpawnEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2PlayerEscapeSpawnEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2PlayerEscapeSpawnEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2PlayerEscapeSpawnEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2PlayerEscapeSpawnEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2PlayerEscapeSpawnEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2PlayerEscapeSpawnEntity_OnMapStart);
}

static void SF2PlayerEscapeSpawnEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2PlayerEscapeSpawnEntity_OnMapStart() 
{
}

static void SF2PlayerEscapeSpawnEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2PlayerEscapeSpawnEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2PlayerEscapeSpawnEntity_SpawnPost);
}

static Action SF2PlayerEscapeSpawnEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PlayerEscapeSpawnEntityData entData;
	if (SF2PlayerEscapeSpawnEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;

	SF2PlayerEscapeSpawnEntity spawnPoint = SF2PlayerEscapeSpawnEntity(entity);
	
	if (strcmp(szKeyName, "startdisabled", false) == 0)
	{
		entData.Enabled = StringToInt(szValue) == 0;
		SF2PlayerEscapeSpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnSpawn", false) == 0)
	{
		spawnPoint.AddOutput(szKeyName, szValue);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2PlayerEscapeSpawnEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PlayerEscapeSpawnEntityData entData;
	if (SF2PlayerEscapeSpawnEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;

	if (strcmp(szInputName, "Enable", false) == 0)
	{
		entData.Enabled = true;
		SF2PlayerEscapeSpawnEntityData_Update(entData);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "Disable", false) == 0)
	{
		entData.Enabled = false;
		SF2PlayerEscapeSpawnEntityData_Update(entData);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void SF2PlayerEscapeSpawnEntity_SpawnPost(int entity) 
{
}

static void SF2PlayerEscapeSpawnEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2PlayerEscapeSpawnEntityData entData;
	int iIndex = SF2PlayerEscapeSpawnEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2PlayerEscapeSpawnEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2PlayerEscapeSpawnEntityData_Get(int entIndex, SF2PlayerEscapeSpawnEntityData entData)
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

static int SF2PlayerEscapeSpawnEntityData_Update(SF2PlayerEscapeSpawnEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}