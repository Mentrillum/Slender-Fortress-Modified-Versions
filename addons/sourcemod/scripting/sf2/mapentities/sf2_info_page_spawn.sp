// sf2_info_page_spawn

static const char g_sEntityClassname[] = "sf2_info_page_spawn"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2PageSpawnEntityData
{
	int EntRef;
	char Model[PLATFORM_MAX_PATH];
	int Skin;
	int Bodygroup;
	float ModelScale;
	char Group[64];
	char Animation[64];
	char CollectSound[PLATFORM_MAX_PATH];
	int CollectSoundPitch;

	// renderamt, rendermode, and rendercolor are properties of CBaseEntity and
	// thus do not need to be saved here.

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		strcopy(this.Model, PLATFORM_MAX_PATH, PAGE_MODEL);
		this.Skin = -1;
		this.Bodygroup = 0;
		this.ModelScale = 1.0;
		this.Group[0] = '\0';
		this.Animation[0] = '\0';
		this.CollectSound[0] = '\0';
		this.CollectSoundPitch = 0;
	}

	void SetModel(const char[] sModel)
	{
		strcopy(this.Model, PLATFORM_MAX_PATH, sModel);
	}

	void SetGroup(const char[] sGroupName)
	{
		strcopy(this.Group, 64, sGroupName);
	}

	void SetAnimation(const char[] sAnimation)
	{
		strcopy(this.Animation, 64, sAnimation);
	}

	void SetCollectSound(const char[] sSound)
	{
		strcopy(this.CollectSound, PLATFORM_MAX_PATH, sSound);
	}

	void Destroy()
	{
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2PageSpawnEntity < SF2MapEntity
{
	public SF2PageSpawnEntity(int entIndex) { return view_as<SF2PageSpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2PageSpawnEntityData entData;
		return (SF2PageSpawnEntityData_Get(this.EntRef, entData) != -1);
	}

	public void GetModel(char[] sBuffer, int iBufferLen)
	{
		SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.Model);
	}

	property int Skin
	{
		public get() { SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData); return entData.Skin; }
	}

	property float ModelScale
	{
		public get() { SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData); return entData.ModelScale; }
	}

	property int Bodygroup
	{
		public get() { SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData); return entData.Bodygroup; }
	}

	public void GetGroup(char[] sBuffer, int iBufferLen)
	{
		SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.Group);
	}

	public void GetAnimation(char[] sBuffer, int iBufferLen)
	{
		SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.Animation);
	}

	public void GetCollectSound(char[] sBuffer, int iBufferLen)
	{
		SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.CollectSound);
	}

	property int CollectSoundPitch
	{
		public get() { SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(this.EntRef, entData); return entData.CollectSoundPitch; }
	}

	public void GetRenderColor(int& r, int& g, int& b, int& a)
	{
		GetEntityRenderColor(this.EntRef, r, g, b, a);
	}

	property RenderFx RenderFx
	{
		public get() { return GetEntityRenderFx(this.EntRef); }
	}

	property RenderMode RenderMode
	{
		public get() { return GetEntityRenderMode(this.EntRef); }
	}
}

void SF2PageSpawnEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2PageSpawnEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2PageSpawnEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2PageSpawnEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2PageSpawnEntity_OnEntityDestroyed);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2PageSpawnEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2PageSpawnEntity_OnEntityKeyValue);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2PageSpawnEntity_OnLevelInit);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2PageSpawnEntity_OnMapStart);
}

/*
static void SF2PageSpawnEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2PageSpawnEntity_OnMapStart() 
{
}
*/

static void SF2PageSpawnEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2PageSpawnEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2PageSpawnEntity_SpawnPost);

	SetEntityRenderColor(entity, 255, 255, 255, 255);
}

static Action SF2PageSpawnEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PageSpawnEntityData entData;
	if (SF2PageSpawnEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;
	
	if (strcmp(szKeyName, "model", false) == 0)
	{
		entData.SetModel(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "skin", false) == 0)
	{
		entData.Skin = StringToInt(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "setbodygroup", false) == 0)
	{
		entData.Bodygroup = StringToInt(szValue);
		SF2PageSpawnEntityData_Update(entData);
	}
	else if (strcmp(szKeyName, "modelscale", false) == 0)
	{
		entData.ModelScale = StringToFloat(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "group", false) == 0)
	{
		entData.SetGroup(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "animation", false) == 0)
	{
		entData.SetAnimation(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "collectsound", false) == 0)
	{
		entData.SetCollectSound(szValue);
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "collectsoundpitch", false) == 0)
	{
		int iPitch = StringToInt(szValue);
		if (iPitch < 0)
			iPitch = 0;
		else if (iPitch > 255)
			iPitch = 255;

		entData.CollectSoundPitch = iPitch;
		SF2PageSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

/*
static Action SF2PageSpawnEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}
*/

static void SF2PageSpawnEntity_SpawnPost(int entity) 
{
	SF2PageSpawnEntityData entData; SF2PageSpawnEntityData_Get(entity, entData);

	if (entData.Model[0] != '\0')
		PrecacheModel(entData.Model); // Precache, or else...

	if (entData.CollectSound[0] != '\0')
		PrecacheSound(entData.CollectSound); // Precache, or else...
}

static void SF2PageSpawnEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2PageSpawnEntityData entData;
	int iIndex = SF2PageSpawnEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2PageSpawnEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2PageSpawnEntityData_Get(int entIndex, SF2PageSpawnEntityData entData)
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

static int SF2PageSpawnEntityData_Update(SF2PageSpawnEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}