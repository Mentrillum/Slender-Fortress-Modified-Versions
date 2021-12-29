// sf2_info_page_music

static const char g_sEntityClassname[] = "sf2_info_page_music"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_entityFactory;

#define SF2MAPENTITES_PAGE_MUSIC_MAXRANGES 16

enum struct SF2PageMusicEntityRangeData
{
	int Min;
	int Max;
	char Music[PLATFORM_MAX_PATH];
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2PageMusicEntity < CBaseEntity
{
	public SF2PageMusicEntity(int entIndex) { return view_as<SF2PageMusicEntity>(CBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	property bool Layered
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bLayered"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bLayered", value); }
	}

	property ArrayList Ranges
	{
		public get() { return view_as<ArrayList>(this.GetProp(Prop_Data, "sf2_hRanges")); }
		public set(ArrayList value) { this.SetProp(Prop_Data, "sf2_hRanges", value); }
	}

	public void GetRangeKeyValue(int index, char[] sBuffer, int iBufferLen)
	{
		char sFieldName[64];
		FormatEx(sFieldName, sizeof(sFieldName), "sf2_szRange%d", index);

		this.GetPropString(Prop_Data, sFieldName, sBuffer, iBufferLen);
	}

	public void GetRangeMusicKeyValue(int index, char[] sBuffer, int iBufferLen)
	{
		char sFieldName[64];
		FormatEx(sFieldName, sizeof(sFieldName), "sf2_szRangeMusic%d", index);

		this.GetPropString(Prop_Data, sFieldName, sBuffer, iBufferLen);
	}

	public void GetRange(int index, SF2PageMusicEntityRangeData rangeData)
	{
		this.Ranges.GetArray(index, rangeData, sizeof(rangeData));
	}

	public void SetRange(int index, SF2PageMusicEntityRangeData rangeData)
	{
		this.Ranges.SetArray(index, rangeData, sizeof(rangeData));
	}

	public bool IsRangeSet(int index)
	{
		SF2PageMusicEntityRangeData rangeData;
		this.GetRange(index, rangeData);
		return rangeData.Music[0] != '\0';
	}

	public bool GetRangeMusic(int num, char[] sBuffer, int iBufferLen)
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

	public bool GetRangeBounds(int num, int &min, int &max)
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

	public void InsertRanges(ArrayList hRanges)
	{
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			this.GetRange(i, rangeData);
			if (rangeData.Music[0] != '\0')
			{
				int index = hRanges.Push(EnsureEntRef(this.index));
				hRanges.Set(index, rangeData.Min, 1);
				hRanges.Set(index, rangeData.Max, 2);
			}
		}
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
	g_entityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bLayered", _, "layered")
		.DefineIntField("sf2_hRanges");

	char sFieldName[64];
	char sKeyName[64];

	for (int i = 0; i < SF2MAPENTITES_PAGE_MUSIC_MAXRANGES; i++)
	{
		FormatEx(sFieldName, sizeof(sFieldName), "sf2_szRange%d", (i + 1));
		FormatEx(sKeyName, sizeof(sKeyName), "range%d", (i + 1));
		g_entityFactory.DefineStringField(sFieldName, _, sKeyName);

		FormatEx(sFieldName, sizeof(sFieldName), "sf2_szRangeMusic%d", (i + 1));
		FormatEx(sKeyName, sizeof(sKeyName), "music%d", (i + 1));
		g_entityFactory.DefineStringField(sFieldName, _, sKeyName);
	}

	g_entityFactory.EndDataMapDesc();
	g_entityFactory.Install();
}

static void OnCreated(int entity)
{
	SF2PageMusicEntity thisEnt = SF2PageMusicEntity(entity);

	thisEnt.Ranges = new ArrayList(sizeof(SF2PageMusicEntityRangeData));
	thisEnt.Ranges.Resize(SF2MAPENTITES_PAGE_MUSIC_MAXRANGES);
	thisEnt.Layered = false;

	SF2PageMusicEntityRangeData rangeData;

	for (int i = 0; i < thisEnt.Ranges.Length; i++)
	{
		thisEnt.Ranges.GetArray(i, rangeData, sizeof(rangeData));
		rangeData.Min = 0;
		rangeData.Max = 0;
		rangeData.Music[0] = '\0';
		thisEnt.Ranges.SetArray(i, rangeData, sizeof(rangeData));
	}

	SDKHook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnRemoved(int entity)
{
	SF2PageMusicEntity thisEnt = SF2PageMusicEntity(entity);

	ArrayList hRanges = thisEnt.Ranges;
	if (hRanges != null)
	{
		delete hRanges;
	}

	SDKUnhook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int entity)
{
	SF2PageMusicEntity thisEnt = SF2PageMusicEntity(entity);

	char sBuffer[PLATFORM_MAX_PATH];
	char sTokens[2][16];

	for (int i = 0; i < SF2MAPENTITES_PAGE_MUSIC_MAXRANGES; i++)
	{
		SF2PageMusicEntityRangeData rangeData;
		thisEnt.GetRange(i, rangeData);

		// Get the range from keyvalue.
		thisEnt.GetRangeKeyValue((i + 1), sBuffer, sizeof(sBuffer));
		int iNumTokens = ExplodeString(sBuffer, ",", sTokens, 2, 16);

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

		// Get the range music from keyvalue.
		thisEnt.GetRangeMusicKeyValue((i + 1), sBuffer, sizeof(sBuffer));
		strcopy(rangeData.Music, PLATFORM_MAX_PATH, sBuffer);

		// Precache, or else...
		if (rangeData.Music[0] != '\0')
			PrecacheSound(rangeData.Music);

		thisEnt.SetRange(i, rangeData);
	}
}