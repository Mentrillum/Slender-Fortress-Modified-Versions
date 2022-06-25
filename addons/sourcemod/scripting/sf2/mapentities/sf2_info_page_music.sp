// sf2_info_page_music

static const char g_EntityClassname[] = "sf2_info_page_music"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_EntityFactory;

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
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
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

	public void GetRangeKeyValue(int index, char[] buffer, int iBufferLen)
	{
		char fieldName[64];
		FormatEx(fieldName, sizeof(fieldName), "sf2_szRange%d", index);

		this.GetPropString(Prop_Data, fieldName, buffer, iBufferLen);
	}

	public void GetRangeMusicKeyValue(int index, char[] buffer, int iBufferLen)
	{
		char fieldName[64];
		FormatEx(fieldName, sizeof(fieldName), "sf2_szRangeMusic%d", index);

		this.GetPropString(Prop_Data, fieldName, buffer, iBufferLen);
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

	public bool GetRangeMusic(int num, char[] buffer, int iBufferLen)
	{
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			if (!this.IsRangeSet(i))
			{
				continue;
			}

			this.GetRange(i, rangeData);
			if (num >= rangeData.Min && num <= rangeData.Max)
			{
				strcopy(buffer, iBufferLen, rangeData.Music);
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
			{
				continue;
			}

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

	public void InsertRanges(ArrayList ranges)
	{
		SF2PageMusicEntityRangeData rangeData;

		for (int i = 0; i < this.Ranges.Length; i++)
		{
			this.GetRange(i, rangeData);
			if (rangeData.Music[0] != '\0')
			{
				int index = ranges.Push(EnsureEntRef(this.index));
				ranges.Set(index, rangeData.Min, 1);
				ranges.Set(index, rangeData.Max, 2);
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
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreated, OnRemoved);
	g_EntityFactory.DeriveFromBaseEntity(true);
	g_EntityFactory.BeginDataMapDesc()
		.DefineBoolField("sf2_bLayered", _, "layered")
		.DefineIntField("sf2_hRanges");

	char fieldName[64];
	char keyName[64];

	for (int i = 0; i < SF2MAPENTITES_PAGE_MUSIC_MAXRANGES; i++)
	{
		FormatEx(fieldName, sizeof(fieldName), "sf2_szRange%d", (i + 1));
		FormatEx(keyName, sizeof(keyName), "range%d", (i + 1));
		g_EntityFactory.DefineStringField(fieldName, _, keyName);

		FormatEx(fieldName, sizeof(fieldName), "sf2_szRangeMusic%d", (i + 1));
		FormatEx(keyName, sizeof(keyName), "music%d", (i + 1));
		g_EntityFactory.DefineStringField(fieldName, _, keyName);
	}

	g_EntityFactory.EndDataMapDesc();
	g_EntityFactory.Install();
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

	ArrayList ranges = thisEnt.Ranges;
	if (ranges != null)
	{
		delete ranges;
	}

	SDKUnhook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int entity)
{
	SF2PageMusicEntity thisEnt = SF2PageMusicEntity(entity);

	char buffer[PLATFORM_MAX_PATH];
	char tokens[2][16];

	for (int i = 0; i < SF2MAPENTITES_PAGE_MUSIC_MAXRANGES; i++)
	{
		SF2PageMusicEntityRangeData rangeData;
		thisEnt.GetRange(i, rangeData);

		// Get the range from keyvalue.
		thisEnt.GetRangeKeyValue((i + 1), buffer, sizeof(buffer));
		int numTokens = ExplodeString(buffer, ",", tokens, 2, 16);

		if (numTokens == 1)
		{
			rangeData.Min = StringToInt(tokens[0]);
			rangeData.Max = rangeData.Min;
		}
		else
		{
			rangeData.Min = StringToInt(tokens[0]);
			rangeData.Max = StringToInt(tokens[1]);
		}

		// Get the range music from keyvalue.
		thisEnt.GetRangeMusicKeyValue((i + 1), buffer, sizeof(buffer));
		strcopy(rangeData.Music, PLATFORM_MAX_PATH, buffer);

		// Precache, or else...
		if (rangeData.Music[0] != '\0')
		{
			PrecacheSound(rangeData.Music);
		}

		thisEnt.SetRange(i, rangeData);
	}
}