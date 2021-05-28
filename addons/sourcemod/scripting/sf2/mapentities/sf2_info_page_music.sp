// base

// Not an actual entity; use this as a template for creating new entities.
// Replace "SF2PageMusicEntity" with the identifier you want.

// To initialize, call the SF2PageMusicEntity_Initialize() function from SF2MapEntity_Initialize().

static const char g_sEntityClassname[] = "sf2_info_page_music"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

#define SF2MAPENTITES_PAGE_MUSIC_MAXRANGES 16

enum struct SF2PageMusicEntityRangeData
{
	int Min;
	int Max;
	char Music[PLATFORM_MAX_PATH];
}

/**
 *	Internal data stored for the entity.
 */
enum struct SF2PageMusicEntityData
{
	int EntRef;
	ArrayList Ranges;
	bool Layered;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.Ranges = new ArrayList(sizeof(SF2PageMusicEntityRangeData));
		this.Ranges.Resize(SF2MAPENTITES_PAGE_MUSIC_MAXRANGES);
		this.Layered = false;

		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			this.Ranges.GetArray(i, rangeData, sizeof(rangeData));
			rangeData.Min = 0;
			rangeData.Max = 0;
			rangeData.Music[0] = '\0';
			this.Ranges.SetArray(i, rangeData, sizeof(rangeData));
		}
	}

	void GetRange(int index, SF2PageMusicEntityRangeData rangeData)
	{
		this.Ranges.GetArray(index, rangeData, sizeof(rangeData));
	}

	void SetRange(int index, SF2PageMusicEntityRangeData rangeData)
	{
		this.Ranges.SetArray(index, rangeData, sizeof(rangeData));
	}

	bool IsRangeSet(int index)
	{
		SF2PageMusicEntityRangeData rangeData;
		this.GetRange(index, rangeData);
		return rangeData.Music[0] != '\0';
	}

	bool GetRangeMusic(int num, char[] sBuffer, int iBufferLen)
	{
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			if (!this.IsRangeSet(i))
				continue;

			this.GetRange(i, rangeData);
			if (num >= rangeData.Min && num <= rangeData.Max)
			{
				strcopy(sBuffer, iBufferLen, rangeData.Music);
				return true;
			}
		}

		return false;
	}

	bool GetRangeBounds(int num, int &min, int &max)
	{
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			if (!this.IsRangeSet(i))
				continue;

			this.GetRange(i, rangeData);
			if (num >= rangeData.Min && num <= rangeData.Max)
			{
				min = rangeData.Min;
				max = rangeData.Max;
				return true;
			}
		}

		return false;
	}

	void Destroy()
	{
		if (this.Ranges != null)
			delete this.Ranges;
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2PageMusicEntity < SF2MapEntity
{
	public SF2PageMusicEntity(int entIndex) { return view_as<SF2PageMusicEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2PageMusicEntityData entData;
		return (SF2PageMusicEntityData_Get(this.EntRef, entData) != -1);
	}

	property bool Layered
	{
		public get() { SF2PageMusicEntityData entData; SF2PageMusicEntityData_Get(this.EntRef, entData); return entData.Layered; }
	}

	public bool GetRangeMusic(int num, char[] sBuffer, int iBufferLen)
	{
		SF2PageMusicEntityData entData; SF2PageMusicEntityData_Get(this.EntRef, entData);
		return entData.GetRangeMusic(num, sBuffer, iBufferLen);
	}

	public bool GetRangeBounds(int num, int &min, int &max)
	{
		SF2PageMusicEntityData entData; SF2PageMusicEntityData_Get(this.EntRef, entData);
		return entData.GetRangeBounds(num, min, max);
	}

	public void InsertRanges(ArrayList hRanges)
	{
		SF2PageMusicEntityData entData; SF2PageMusicEntityData_Get(this.EntRef, entData);
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < entData.Ranges.Length; i++)
		{
			entData.GetRange(i, rangeData);
			if (rangeData.Music[0] != '\0')
			{
				int index = hRanges.Push(this.EntRef);
				hRanges.Set(index, rangeData.Min, 1);
				hRanges.Set(index, rangeData.Max, 2);
			}
		}
	}
}

void SF2PageMusicEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2PageMusicEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2PageMusicEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2PageMusicEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2PageMusicEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2PageMusicEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2PageMusicEntity_OnEntityKeyValue);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2PageMusicEntity_OnLevelInit);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2PageMusicEntity_OnMapStart);
}

/*
static void SF2PageMusicEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2PageMusicEntity_OnMapStart() 
{
}
*/

static void SF2PageMusicEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2PageMusicEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2PageMusicEntity_SpawnPost);
}

static Action SF2PageMusicEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2PageMusicEntityData entData;
	if (SF2PageMusicEntityData_Get(entity, entData) == -1)
		return Plugin_Continue;
	
	if (StrContains(szKeyName, "range", false) == 0)
	{
		if (szValue[0] == '\0')
			return Plugin_Continue;

		char sBuffer[256];
		strcopy(sBuffer, sizeof(sBuffer), szKeyName);
		ReplaceStringEx(sBuffer, sizeof(sBuffer), "range", "", _, _, false);
		
		int rangeId = StringToInt(sBuffer) - 1;
		if (rangeId < 0 || rangeId >= SF2MAPENTITES_PAGE_MUSIC_MAXRANGES)
			return Plugin_Continue;

		char sTokens[2][16];
		int iNumTokens = ExplodeString(szValue, ",", sTokens, 2, 16);

		SF2PageMusicEntityRangeData rangeData;
		entData.GetRange(rangeId, rangeData);
		
		if (iNumTokens == 1)
		{
			rangeData.Min = StringToInt(sTokens[0]);
			rangeData.Max = rangeData.Min;
		}
		else
		{
			rangeData.Min = StringToInt(sTokens[0]);
			rangeData.Max = StringToInt(sTokens[1]);
		}

		entData.SetRange(rangeId, rangeData);

		return Plugin_Handled;
	}
	else if (StrContains(szKeyName, "music", false) == 0)
	{
		char sBuffer[256];
		strcopy(sBuffer, sizeof(sBuffer), szKeyName);
		ReplaceStringEx(sBuffer, sizeof(sBuffer), "music", "", _, _, false);
		
		int rangeId = StringToInt(sBuffer) - 1;
		if (rangeId < 0 || rangeId >= SF2MAPENTITES_PAGE_MUSIC_MAXRANGES)
			return Plugin_Continue;
		
		SF2PageMusicEntityRangeData rangeData;
		entData.GetRange(rangeId, rangeData);
		strcopy(rangeData.Music, PLATFORM_MAX_PATH, szValue);
		entData.SetRange(rangeId, rangeData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "layered", false) == 0)
	{
		entData.Layered = StringToInt(szValue) != 0;
		SF2PageMusicEntityData_Update(entData);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2PageMusicEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	return Plugin_Continue;
}

static void SF2PageMusicEntity_SpawnPost(int entity) 
{
	SF2PageMusicEntityData entData;
	if (SF2PageMusicEntityData_Get(entity, entData) == -1)
		return;

	// Precache, or else...
	SF2PageMusicEntityRangeData rangeData;

	for (int i = 0; i < SF2MAPENTITES_PAGE_MUSIC_MAXRANGES; i++)
	{
		entData.GetRange(i, rangeData);
		
		if (rangeData.Music[0] != '\0')
			PrecacheSound(rangeData.Music);
	}
}

static void SF2PageMusicEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2PageMusicEntityData entData;
	int iIndex = SF2PageMusicEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2PageMusicEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2PageMusicEntityData_Get(int entIndex, SF2PageMusicEntityData entData)
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

static int SF2PageMusicEntityData_Update(SF2PageMusicEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}