#include <sdktools_sound>

static const char g_SoundModifiers[][] = {
	"*",
	"#",
	"@",
	">",
	"<",
	"^",
	")",
	"}",
	"$",
	"!",
	"?"
};

// ======================================
// FUNCTIONS
// ======================================

stock void PrecacheSound2(const char[] path, bool checkFile, bool replace = true)
{
	char tempPath[PLATFORM_MAX_PATH];
	strcopy(tempPath, sizeof(tempPath), path);
	PrecacheSound(tempPath, true);
	if (replace)
	{
		for (int i = 0; i < sizeof(g_SoundModifiers); i++)
		{
			ReplaceStringEx(tempPath, sizeof(tempPath), g_SoundModifiers[i], "");
		}
	}
	char buffer[PLATFORM_MAX_PATH];
	FormatEx(buffer, sizeof(buffer), "sound/%s", tempPath);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}
}

/**
 * Attempts to precache a sound path, a path relative to sound/ folder.
 *
 * If the sound file exists within the server files, the file is added to the downloads table.
 *
 * @param soundPath		Path to sound, relative to sound/ folder.
 * @param disableWarning	Disables the warning if a file doesn't exist.
 * @param checkFile		Determines if missing files should be checked.
 */
stock void TryPrecacheBossProfileSoundPath(const char[] soundPath, bool checkFile)
{
	if (soundPath[0] == '\0')
	{
		return;
	}

	char fullPath[PLATFORM_MAX_PATH], tempPath[PLATFORM_MAX_PATH];
	strcopy(tempPath, sizeof(tempPath), soundPath);
	PrecacheSound(tempPath);
	for (int i = 0; i < sizeof(g_SoundModifiers); i++)
	{
		ReplaceStringEx(tempPath, sizeof(tempPath), g_SoundModifiers[i], "");
	}
	FormatEx(fullPath, sizeof(fullPath), "sound/%s", tempPath);

	if (checkFile)
	{
		if (FileExists(fullPath, false) || FileExists(fullPath, true))
		{
			PrecacheSound2(tempPath, checkFile, false);
		}
		else
		{
			PrintToServer("[SF2] Sound file %s does not exist, excluding from downloads!", fullPath);
			PrecacheSound(tempPath);
		}
	}
	else
	{
		PrecacheSound2(tempPath, checkFile, false);
	}
}

/**
 * Precaches a model path relative to models/ and adds it to the downloads table if valid.
 *
 * @param path		Path to model, relative to models/ folder.
 * @param phy	Determines if the .phy file extension should be checked.
 * @param xbox	Determines if the .xbox file extension should be checked.
 * @param checkFile		Determines if missing files should be checked.
 */
stock int PrecacheModel2(const char[] path, bool phy = true, bool xbox = false, bool checkFile)
{
	if (path[0] == '\0')
	{
		return -1;
	}

	char fixedPath[PLATFORM_MAX_PATH];

	if (strncmp(path, "models/", 7, false) == 0 || strncmp(path, "models\\", 7, false) == 0)
	{
		strcopy(fixedPath, sizeof(fixedPath), path[7]);
	}
	else
	{
		strcopy(fixedPath, sizeof(fixedPath), path);
	}

	ReplaceString(fixedPath, sizeof(fixedPath), ".mdl", "", false);

	char buffer[PLATFORM_MAX_PATH];
	FormatEx(buffer, sizeof(buffer), "models/%s.dx80.vtx", fixedPath);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}

	FormatEx(buffer, sizeof(buffer), "models/%s.dx90.vtx", fixedPath);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}

	FormatEx(buffer, sizeof(buffer), "models/%s.mdl", fixedPath);
	int returnValue = -1;
	if (!IsModelPrecached(buffer))
	{
		returnValue = PrecacheModel(buffer);
	}

	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}

	if (phy)
	{
		// Some models do not have phy, so we can make this optional.
		// No really, some players get fussy over missing downloads.

		FormatEx(buffer, sizeof(buffer), "models/%s.phy", fixedPath);

		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
	}

	FormatEx(buffer, sizeof(buffer), "models/%s.sw.vtx", fixedPath);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}

	FormatEx(buffer, sizeof(buffer), "models/%s.vvd", fixedPath);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}

	if (xbox)
	{
		// Due to some super old legacy thingy, some really old models were compiled with a setup for xbox.
		// So just to keep everyone happy, incase this is magically a problem, we'll include xbox files if set.
		// I mean it really shouldn't be an issue but, better safe than sorry...
		FormatEx(buffer, sizeof(buffer), "models/%s.xbox", fixedPath);
		if (checkFile)
		{
			if (FileExists(buffer, true))
			{
				AddFileToDownloadsTable(buffer);
			}
			else
			{
				PrintToServer("[SF2] File %s is missing from the server files!", buffer);
			}
		}
		else
		{
			AddFileToDownloadsTable(buffer);
		}
	}

	return returnValue;
}

/**
 * Adds a material and texture path relative to materials/ to the download list.
 *
 * @param path		Path to the material and texture, relative to materials/ folder.
 * @param checkFile		Determines if missing files should be checked.
 */
stock void PrecacheMaterial2(const char[] path, bool checkFile)
{
	char buffer[PLATFORM_MAX_PATH];
	FormatEx(buffer, sizeof(buffer), "materials/%s.vmt", path);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}
	FormatEx(buffer, sizeof(buffer), "materials/%s.vtf", path);
	if (checkFile)
	{
		if (FileExists(buffer, true))
		{
			AddFileToDownloadsTable(buffer);
		}
		else
		{
			PrintToServer("[SF2] File %s is missing from the server files!", buffer);
		}
	}
	else
	{
		AddFileToDownloadsTable(buffer);
	}
}

/**
 * Precaches a particle system found in the string table ParticleEffectNames
 *
 * @param particleSystem		Particle name
 */
stock int PrecacheParticleSystem(const char[] particleSystem)
{
	static int particleEffectNames = -1;

	if (particleEffectNames == -1)
	{
		if ((particleEffectNames = FindStringTable("ParticleEffectNames")) == -1)
		{
			return -1;
		}
	}

	int index = FindStringIndex2(particleEffectNames, particleSystem);
	if (index == -1)
	{
		int numStrings = GetStringTableNumStrings(particleEffectNames);
		if (numStrings >= GetStringTableMaxStrings(particleEffectNames))
		{
			return -1;
		}

		AddToStringTable(particleEffectNames, particleSystem);
		index = numStrings;
	}

	return index;
}

int FindStringIndex2(int tableidx, const char[] str)
{
	char buf[1024];

	int numStrings = GetStringTableNumStrings(tableidx);
	for (int i=0; i < numStrings; i++)
	{
		ReadStringTable(tableidx, i, buf, sizeof(buf));

		if (strcmp(buf, str) == 0)
		{
			return i;
		}
	}

	return -1;
}

/**
 * Appends a key with a difficulty suffix.
 *
 * @param key          Name of key.
 * @param difficulty   Difficulty number.
 * @param buffer       Buffer to store key value in.
 * @param bufferLen   Size of buffer.
 * @return              True if successful, false otherwise.
 */
stock bool GetProfileKeyWithDifficultySuffix(const char[] key, int difficulty, char[] buffer, int bufferLen)
{
	if (difficulty < 0 || difficulty >= Difficulty_Max)
	{
		return false;
	}

	static const char difficultySuffixes[][] =
	{
		"easy",
		"normal",
		"hard",
		"insane",
		"nightmare",
		"apollyon",
	};

	if (difficulty != 1)
	{
		FormatEx(buffer, bufferLen, "%s_%s", key, difficultySuffixes[difficulty]);
	}
	else
	{
		FormatEx(buffer, bufferLen, "%s", key);
	}
	return true;
}

/**
 * Retrieves integer difficulty-based keys from the KeyValues's current position.
 *
 * @note                    Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                KeyValues object to read from
 * @param baseKeyName      Key name without difficulty suffix
 * @param buffer           Array to store evaluated values
 * @param defaultValue     Array of default values if no key with the base key name is found
 */
stock void GetProfileDifficultyNumValues(KeyValues kv, const char[] baseKeyName, int buffer[Difficulty_Max], const int defaultValues[Difficulty_Max] = { 0, ... })
{
	buffer = defaultValues;

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		int defaultValue = kv.GetNum(baseKeyName);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			buffer[i] = defaultValue;
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			int value = kv.GetNum(key, buffer[i]);
			for (int j = i; j < Difficulty_Max; j++)
			{
				buffer[j] = value;
			}
		}
		else
		{
			if (defaultValues[i] != 0)
			{
				buffer[i] = defaultValues[i];
			}
			else
			{
				if (i > 0)
				{
					buffer[i] = buffer[i - 1];
				}
			}
		}
	}
}

/**
 * Retrieves boolean difficulty-based keys from the KeyValues's current position.
 *
 * @note                     Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                 KeyValues object to read from
 * @param baseKeyName       Key name without difficulty suffix
 * @param buffer            Array to store evaluated values
 * @param defaultValues     Array of default values if no key with the base key name is found
 */
stock void GetProfileDifficultyBoolValues(KeyValues kv, const char[] baseKeyName, bool buffer[Difficulty_Max], const bool defaultValues[Difficulty_Max] = { false, ... })
{
	buffer = defaultValues;

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		bool defaultValue = kv.GetNum(baseKeyName) != 0;
		for (int i = 0; i < Difficulty_Max; i++)
		{
			buffer[i] = defaultValue;
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			bool value = kv.GetNum(key, buffer[i]) != 0;
			for (int j = i; j < Difficulty_Max; j++)
			{
				buffer[j] = value;
			}
		}
		else
		{
			if (defaultValues[i])
			{
				buffer[i] = defaultValues[i];
			}
			else
			{
				if (i > 0)
				{
					buffer[i] = buffer[i - 1];
				}
			}
		}
	}
}

/**
 * Retrieves float difficulty-based keys from the KeyValues's current position.
 *
 * @note                      Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                  KeyValues object to read from
 * @param baseKeyName        Key name without difficulty suffix
 * @param buffer            Array to store evaluated values
 * @param defaultValues     Array of default values if no key with the base key name is found
 */
stock void GetProfileDifficultyFloatValues(KeyValues kv, const char[] baseKeyName, float buffer[Difficulty_Max], const float defaultValues[Difficulty_Max] = { 0.0, ... })
{
	buffer = defaultValues;

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		float defaultValue = kv.GetFloat(baseKeyName);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			buffer[i] = defaultValue;
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			float value = kv.GetFloat(key, buffer[i]);
			for (int j = i; j < Difficulty_Max; j++)
			{
				buffer[j] = value;
			}
		}
		else
		{
			if (defaultValues[i] != 0.0)
			{
				buffer[i] = defaultValues[i];
			}
			else
			{
				if (i > 0)
				{
					buffer[i] = buffer[i - 1];
				}
			}
		}
	}
}

static const float g_DifficultyDefaultVectorValues[Difficulty_Max][3] =
{
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 }
};

// TODO: Actually use this somewhere
/**
 * Retrieves Vector difficulty-based keys from the KeyValues's current position.
 *
 * @note                          Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                      KeyValues object to read from
 * @param baseKeyName             Key name without difficulty suffix
 * @param buffer                  Array to store evaluated values
 * @param defaultValueVectors     Array of default values if no key with the base key name is found
 */
stock void GetProfileDifficultyVectorValues(KeyValues kv, const char[] baseKeyName, float buffer[Difficulty_Max][3], const float defaultValueVectors[Difficulty_Max][3] = g_DifficultyDefaultVectorValues)
{
	for (int i = 0; i < Difficulty_Max; i++)
	{
		buffer[i] = defaultValueVectors[i];
	}

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		float defaultValue[3];
		kv.GetVector(baseKeyName, defaultValue);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			buffer[i] = defaultValue;
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			float value[3];
			kv.GetVector(key, value, buffer[i]);
			for (int j = i; j < Difficulty_Max; j++)
			{
				buffer[j] = value;
			}
		}
		else
		{
			bool def = false;
			for (int k = 0; k < 3; k++)
			{
				if (defaultValueVectors[i][k] != 0.0)
				{
					def = true;
				}
			}
			if (def)
			{
				buffer[i] = defaultValueVectors[i];
			}
			else
			{
				if (i > 0)
				{
					buffer[i] = buffer[i - 1];
				}
			}
		}
	}
}

static const char g_DifficultyDefaultStringValues[Difficulty_Max][] =
{
	"",
	"",
	"",
	"",
	"",
	""
};

/**
 * Retrieves string difficulty-based keys from the KeyValues's current position.
 *
 * @note                          Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                      KeyValues object to read from
 * @param baseKeyName             Key name without difficulty suffix
 * @param bufferArray             Array to store evaluated values
 * @param maxStringLen            Maximum length of strings in buffer array
 * @param defaultValueStrings     Array of default values if no key with the base key name is found
 */
void GetProfileDifficultyStringValues(KeyValues kv, const char[] baseKeyName, char[][] bufferArray, int maxStringLen, const char[][] defaultValueStrings = g_DifficultyDefaultStringValues)
{
	for (int i = 0; i < Difficulty_Max; i++)
	{
		strcopy(bufferArray[i], maxStringLen, defaultValueStrings[i]);
	}

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		char[] defaultValue = new char[maxStringLen];
		kv.GetString(baseKeyName, defaultValue, maxStringLen);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			strcopy(bufferArray[i], maxStringLen, defaultValue);
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			char[] value = new char[maxStringLen];
			kv.GetString(key, value, maxStringLen, bufferArray[i]);
			for (int j = i; j < Difficulty_Max; j++)
			{
				strcopy(bufferArray[j], maxStringLen, value);
			}
		}
		else
		{
			if (defaultValueStrings[i][0] != '\0')
			{
				strcopy(bufferArray[i], maxStringLen, defaultValueStrings[i]);
			}
			else
			{
				if (i > 0)
				{
					strcopy(bufferArray[i], maxStringLen, bufferArray[i - 1]);
				}
			}
		}
	}
}

stock void SetProfileDifficultyStringArrayValues(KeyValues kv, const char[] baseKeyName, ArrayList array, bool models = false)
{
	char key[64];
	char temporaryKeys[PLATFORM_MAX_PATH];
	char[] value = new char[PLATFORM_MAX_PATH];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i == 0 ? 1 : i, key, sizeof(key));
		kv.GetString(key, value, PLATFORM_MAX_PATH, value);
		if (models && strncmp(value, "models/", 7, false) != 0 && strncmp(value, "models\\", 7, false) != 0 && value[0] != '\0')
		{
			Format(value, PLATFORM_MAX_PATH, "models/%s", value);
		}
		if (value[0] != '\0')
		{
			strcopy(temporaryKeys, sizeof(temporaryKeys), value);
		}
		array.PushString(value);
	}
}

bool GetProfileColorNoBacks(KeyValues kv,
	const char[] keyValue,
	int &r,
	int &g,
	int &b,
	int &a,
	int dr = 255,
	int dg = 255,
	int db = 255,
	int da = 255)
{
	r = dr;
	g = dg;
	b = db;
	a = da;

	char value[64];
	kv.GetString(keyValue, value, sizeof(value));

	if (value[0] != '\0')
	{
		kv.GetColor(keyValue, r, g, b, a);
	}

	return true;
}

static const int g_DifficultyDefaultColorValues[Difficulty_Max][4] =
{
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 },
	{ 0, 0, 0, 0 }
};
/**
 * Retrieves color difficulty-based keys from the KeyValues's current position.
 *
 * @note                          Buffer values are initialized to the default values. Afterwards, any defined difficulty-specific keys will cascade down to harder difficulties.
 * @param kv                      KeyValues object to read from
 * @param baseKeyName             Key name without difficulty suffix
 * @param buffer				  Array to store evaluated values
 * @param defaultValueStrings     Array of default values if no key with the base key name is found
 */
void GetProfileDifficultyColorValues(KeyValues kv, const char[] baseKeyName, int buffer[Difficulty_Max][4], const int defaultColorValues[Difficulty_Max][4] = g_DifficultyDefaultColorValues)
{
	for (int i = 0; i < Difficulty_Max; i++)
	{
		buffer[i] = defaultColorValues[i];
	}

	if (kv.GetDataType(baseKeyName) != KvData_None)
	{
		int defaultValue[4];
		kv.GetColor4(baseKeyName, defaultValue);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			buffer[i] = defaultValue;
		}
	}

	char key[64];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i, key, sizeof(key));
		if (kv.GetDataType(key) != KvData_None)
		{
			int value[4];
			GetProfileColorNoBacks(kv, key, value[0], value[1], value[2], value[3],
									buffer[i][0], buffer[i][1], buffer[i][2], buffer[i][3]);
			for (int j = i; j < Difficulty_Max; j++)
			{
				buffer[j] = value;
			}
		}
		else
		{
			if (i > 0)
			{
				buffer[i] = buffer[i - 1];
			}
		}
	}
}

// ======================================
// ENUM STRUCTS
// ======================================

enum struct SF2BossProfileSoundInfo
{
	char SectionName[64];
	int Channel;
	float Volume;
	int Flags;
	int Level;
	int Pitch;
	float CooldownMin;
	float CooldownMax;
	int PitchRandomMin;
	int PitchRandomMax;
	ArrayList Paths;
	float Radius;
	bool Loaded;
	float Chance;

	void Init()
	{
		this.SectionName[0] = '\0';
		this.Channel = SNDCHAN_AUTO;
		this.Volume = SNDVOL_NORMAL;
		this.Flags = SND_NOFLAGS;
		this.Level = SNDLEVEL_SCREAMING;
		this.Pitch = SNDPITCH_NORMAL;
		this.CooldownMin = 1.5;
		this.CooldownMax = 1.5;
		this.PitchRandomMin = this.Pitch;
		this.PitchRandomMax = this.Pitch;
		this.Radius = 850.0;
		this.Chance = 1.0;

		this.Paths = null;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		kv.GetSectionName(this.SectionName, sizeof(this.SectionName));
		if (kv.JumpToKey("paths"))
		{
			this.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
			char soundPath[PLATFORM_MAX_PATH], section[64];
			for (int i = 1;; i++)
			{
				FormatEx(section, sizeof(section), "%d", i);
				kv.GetString(section, soundPath, sizeof(soundPath));
				if (soundPath[0] == '\0')
				{
					break;
				}

				TryPrecacheBossProfileSoundPath(soundPath, checkFile);

				this.Paths.PushString(soundPath);
			}

			kv.GoBack();
			this.Channel = kv.GetNum("channel", this.Channel);
			this.Level = kv.GetNum("level", this.Level);
			this.Flags = kv.GetNum("flags", this.Flags);
			this.Volume = kv.GetFloat("volume", this.Volume);
			this.Pitch = kv.GetNum("pitch", this.Pitch);
			this.PitchRandomMin = this.Pitch;
			this.PitchRandomMax = this.Pitch;
			this.CooldownMin = kv.GetFloat("cooldown_min", this.CooldownMin);
			this.CooldownMax = kv.GetFloat("cooldown_max", this.CooldownMax);
			this.PitchRandomMin = kv.GetNum("pitch_random_min", this.PitchRandomMin);
			this.PitchRandomMax = kv.GetNum("pitch_random_max", this.PitchRandomMax);
			this.Radius = kv.GetFloat("radius", this.Radius);
			this.Chance = kv.GetFloat("chance", this.Chance);
			if (this.Chance < 0.0)
			{
				this.Chance = 0.0;
			}
			if (this.Chance > 1.0)
			{
				this.Chance = 1.0;
			}
		}
		else
		{
			this.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
			char soundPath[PLATFORM_MAX_PATH], section[64], formatter[90];
			for (int i = 1;; i++)
			{
				FormatEx(section, sizeof(section), "%d", i);
				kv.GetString(section, soundPath, sizeof(soundPath));
				if (soundPath[0] == '\0')
				{
					break;
				}

				TryPrecacheBossProfileSoundPath(soundPath, checkFile);

				this.Paths.PushString(soundPath);
			}
			kv.GoBack();
			FormatEx(formatter, sizeof(formatter), "%s_channel", this.SectionName);
			this.Channel = kv.GetNum(formatter, this.Channel);
			FormatEx(formatter, sizeof(formatter), "%s_level", this.SectionName);
			this.Level = kv.GetNum(formatter, this.Level);
			FormatEx(formatter, sizeof(formatter), "%s_flags", this.SectionName);
			this.Flags = kv.GetNum(formatter, this.Flags);
			FormatEx(formatter, sizeof(formatter), "%s_volume", this.SectionName);
			this.Volume = kv.GetFloat(formatter, this.Volume);
			FormatEx(formatter, sizeof(formatter), "%s_pitch", this.SectionName);
			this.Pitch = kv.GetNum(formatter, this.Pitch);
			this.PitchRandomMin = this.Pitch;
			this.PitchRandomMax = this.Pitch;
			FormatEx(formatter, sizeof(formatter), "%s_cooldown_min", this.SectionName);
			this.CooldownMin = kv.GetFloat(formatter, this.CooldownMin);
			FormatEx(formatter, sizeof(formatter), "%s_cooldown_max", this.SectionName);
			this.CooldownMax = kv.GetFloat(formatter, this.CooldownMax);
			FormatEx(formatter, sizeof(formatter), "%s_pitch_random_min", this.SectionName);
			this.PitchRandomMin = kv.GetNum(formatter, this.PitchRandomMin);
			FormatEx(formatter, sizeof(formatter), "%s_pitch_random_max", this.SectionName);
			this.PitchRandomMax = kv.GetNum(formatter, this.PitchRandomMax);
			FormatEx(formatter, sizeof(formatter), "%s_radius", this.SectionName);
			this.Radius = kv.GetFloat(formatter, this.Radius);
			FormatEx(formatter, sizeof(formatter), "%s_chance", this.SectionName);
			this.Chance = kv.GetFloat(formatter, this.Chance);
			if (this.Chance < 0.0)
			{
				this.Chance = 0.0;
			}
			if (this.Chance > 1.0)
			{
				this.Chance = 1.0;
			}

			kv.JumpToKey(this.SectionName);
		}
	}

	void PostLoad()
	{
		if (this.Paths != null && this.Paths.Length <= 0)
		{
			delete this.Paths;
		}
	}

	void Destroy()
	{
		if (this.Paths != null)
		{
			delete this.Paths;
		}
	}

	void StopAllSounds(int entity)
	{
		if (this.Paths == null || this.Paths.Length <= 0)
		{
			return;
		}
		char buffer[PLATFORM_MAX_PATH];
		for (int i = 0; i < this.Paths.Length; i++)
		{
			this.Paths.GetString(i, buffer, sizeof(buffer));
			if (buffer[0] == '\0')
			{
				break;
			}

			StopSound(entity, this.Channel, buffer);
		}
	}

	void EmitSound(bool toClient = false, int entity = -1, int emitter = SOUND_FROM_PLAYER, float origin[3] = NULL_VECTOR, int addPitch = 0, char returnSound[PLATFORM_MAX_PATH] = "", int definedIndex = -1)
	{
		if (this.Paths == null || this.Paths.Length <= 0)
		{
			return;
		}
		char buffer[PLATFORM_MAX_PATH];
		if (definedIndex != -1)
		{
			this.Paths.GetString(definedIndex, buffer, sizeof(buffer));
		}
		else
		{
			this.Paths.GetString(GetRandomInt(0, this.Paths.Length - 1), buffer, sizeof(buffer));
		}
		returnSound = buffer;
		if (StrContains(buffer, ".mp3", true) == -1 && StrContains(buffer, ".wav", true) == -1)
		{
			if (!toClient)
			{
				EmitGameSoundToAll(buffer, entity, this.Flags);
			}
			else
			{
				EmitGameSoundToClient(entity, buffer, emitter, this.Flags);
			}
			return;
		}
		int pitch = GetRandomInt(this.PitchRandomMin, this.PitchRandomMax);
		int volumeCount = RoundToCeil(this.Volume);
		for (int i = 0; i < volumeCount; i++)
		{
			float finalVolume = this.Volume;
			if (i + 1 != volumeCount)
			{
				if (!toClient)
				{
					EmitSoundToAll(buffer, entity, this.Channel, this.Level, this.Flags, 1.0,
					((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
					_, origin);
				}
				else
				{
					EmitSoundToClient(entity, buffer, emitter, this.Channel, this.Level, this.Flags, 1.0,
					((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
					_, origin);
				}
			}
			else
			{
				if (finalVolume > 1.0)
				{
					while (finalVolume > 1.0)
					{
						finalVolume -= 1.0;
					}
					if (!toClient)
					{
						EmitSoundToAll(buffer, entity, this.Channel, this.Level, this.Flags, finalVolume,
						((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
						_, origin);
					}
					else
					{
						EmitSoundToClient(entity, buffer, emitter, this.Channel, this.Level, this.Flags, finalVolume,
						((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
						_, origin);
					}
				}
				else
				{
					if (!toClient)
					{
						EmitSoundToAll(buffer, entity, this.Channel, this.Level, this.Flags, this.Volume,
						((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
						_, origin);
					}
					else
					{
						EmitSoundToClient(entity, buffer, emitter, this.Channel, this.Level, this.Flags, this.Volume,
						((this.PitchRandomMin == this.Pitch && this.PitchRandomMax == this.Pitch) ? this.Pitch : pitch) + addPitch,
						_, origin);
					}
				}
			}
		}
	}
}

enum struct SF2ParticleData
{
	char ParticleName[128];
	bool AttachParticles;
	bool BeamParticles;
	ParticleAttachment Type;
	char Attachment[64];

	void Init()
	{
		this.ParticleName[0] = '\0';
		this.AttachParticles = true;
		this.BeamParticles = false;
		this.Type = PATTACH_CUSTOMORIGIN;
		this.Attachment[0] = '\0';
	}

	void Load(KeyValues kv)
	{
		kv.GetString("particle", this.ParticleName, sizeof(this.ParticleName), this.ParticleName);
		this.AttachParticles = kv.GetNum("attach", this.AttachParticles) != 0;
		this.BeamParticles = kv.GetNum("beam", this.BeamParticles) != 0;
		this.Type = view_as<ParticleAttachment>(kv.GetNum("attach_type", view_as<int>(this.Type)));
		kv.GetString("attachment", this.Attachment, sizeof(this.Attachment), this.Attachment);
	}

	void Apply(CBaseAnimating player, CBaseAnimating caster)
	{
		CBaseAnimating castTo;
		float myPos[3], myAng[3], targetPos[3];
		if (!this.AttachParticles || this.BeamParticles)
		{
			caster.WorldSpaceCenter(myPos);
			caster.GetAbsAngles(myAng);
			player.WorldSpaceCenter(targetPos);
			if (this.AttachParticles)
			{
				castTo = caster;
			}
		}
		else
		{
			player.WorldSpaceCenter(myPos);
			player.GetAbsAngles(myAng);
			castTo = player;
		}

		int attachment = 0;
		if (this.Attachment[0] != '\0')
		{
			attachment = castTo.LookupAttachment(this.Attachment);
		}
		if (attachment != 0)
		{
			castTo.GetAttachment(attachment, myPos, myAng);
		}

		if (this.Type == PATTACH_ROOTBONE_FOLLOW)
		{
			myPos = NULL_VECTOR;
			myAng = NULL_VECTOR;
		}

		if (this.BeamParticles)
		{
			DispatchParticleEffectBeam(castTo.index, this.ParticleName, myPos, myAng, targetPos, attachment, this.Type, true);
		}
		else
		{
			if (!DispatchParticleEffect(castTo.index, this.ParticleName, myPos, myAng, myPos, attachment, this.Type, true))
			{
				if (this.Type == PATTACH_ROOTBONE_FOLLOW)
				{
					castTo.WorldSpaceCenter(myPos);
					castTo.GetAbsAngles(myAng);
				}
				CBaseEntity particleEnt = CBaseEntity(CreateEntityByName("info_particle_system"));
				if (particleEnt.IsValid())
				{
					particleEnt.Teleport(myPos, myAng, NULL_VECTOR);

					particleEnt.KeyValue("effect_name", this.ParticleName);
					particleEnt.Spawn();
					particleEnt.Activate();
					particleEnt.AcceptInput("start");
					RemoveEntity(particleEnt.index);
				}
			}
		}
	}
}

enum EffectEvent
{
	EffectEvent_Invalid = -1,
	EffectEvent_Constant = 0,
	EffectEvent_HitPlayer,
	EffectEvent_PlayerSeesBoss
};

enum EffectType
{
	EffectType_Invalid = -1,
	EffectType_Steam = 0,
	EffectType_DynamicLight,
	EffectType_Particle,
	EffectType_Trail,
	EffectType_PropDynamic,
	EffectType_PointSpotlight,
	EffectType_Sprite,
	EffectType_TempEntBeamRing,
	EffectType_TempEntParticle,
	EffectType_Sound
};

enum struct SF2BossProfileBaseEffectInfo
{
	char SectionName[64];
	EffectEvent Event;
	EffectType Type;
	float Origin[3];
	float Angles[3];
	RenderMode RenderModes;
	RenderFx RenderEffects;
	int SpawnFlags;
	int FadeAlpha;
	int EntRef;
	float LifeTime;
	bool Attachment;
	char AttachmentName[PLATFORM_MAX_PATH];
	ArrayList Colors;
	int DifficultyIndexes;
	float Delay;
	bool AttachPlayer;

	int SteamSpreadSpeed;
	int SteamSpeed;
	int SteamStartSize;
	int SteamEndSize;
	int SteamRate;
	int SteamJetLength;
	float SteamRollSpeed;
	int SteamType;

	int LightBrightness;
	float LightMaxDistance;
	int LightCone;
	int LightStyle;

	char ParticleName[PLATFORM_MAX_PATH];

	float TrailTime;
	float TrailStartWidth;
	float TrailEndWidth;
	char TrailName[PLATFORM_MAX_PATH];

	char ModelName[PLATFORM_MAX_PATH];
	float ModelScale;
	int ModelSkin;
	char ModelAnimation[64];

	float SpotlightWidth;
	float SpotlightLength;
	float SpotlightHaloScale;

	char SpriteName[PLATFORM_MAX_PATH];
	float SpriteScale;

	float BeamRingStartRadius;
	float BeamRingEndRadius;
	int BeamRingStartFrame;
	int BeamRingFrameRate;
	float BeamRingWidth;
	float BeamRingAmplitude;
	int BeamRingSpeed;
	int BeamRingFlags;
	char BeamRingColor[32];
	char BeamRingBeamSprite[PLATFORM_MAX_PATH];
	int BeamRingBeamModel;
	char BeamRingHaloSprite[PLATFORM_MAX_PATH];
	int BeamRingHaloModel;

	float TEParticleStartPos[3];
	int TEParticleAttachType;
	bool TEParticleReset;
	bool TEParticleHasControlPoint;
	int TEParticleControlPointAttachType;
	float TEParticleControlPointOffset[3];

	SF2BossProfileSoundInfo SoundSounds;

	void Init()
	{
		this.SectionName[0] = '\0';
		this.Event = EffectEvent_Invalid;
		this.Type = EffectType_Invalid;
		for (int i = 0; i < 3; i++)
		{
			this.Origin[i] = 0.0;
			this.Angles[i] = 0.0;
			this.TEParticleStartPos[i] = 0.0;
			this.TEParticleControlPointOffset[i] = 0.0;
		}
		this.RenderModes = RENDER_NORMAL;
		this.RenderEffects = RENDERFX_NONE;
		this.SpawnFlags = 0;
		this.FadeAlpha = 255;
		this.EntRef = INVALID_ENT_REFERENCE;
		this.LifeTime = -1.0;
		this.Colors = null;
		this.DifficultyIndexes = 123456;
		this.Delay = 0.0;

		this.SteamSpreadSpeed = 0;
		this.SteamSpeed = 0;
		this.SteamStartSize = 0;
		this.SteamEndSize = 0;
		this.SteamRate = 0;
		this.SteamJetLength = 0;
		this.SteamRollSpeed = 0.0;
		this.SteamType = 0;

		this.LightBrightness = 0;
		this.LightMaxDistance = 0.0;
		this.LightCone = 0;
		this.LightStyle = 0;

		this.ParticleName[0] = '\0';

		this.TrailTime = 1.0;
		this.TrailStartWidth = 6.0;
		this.TrailEndWidth = 15.0;
		this.TrailName[0] = '\0';

		this.ModelName[0] = '\0';
		this.ModelScale = 1.0;
		this.ModelSkin = 0;
		this.ModelAnimation[0] = '\0';

		this.SpotlightWidth = 40.0;
		this.SpotlightLength = 512.0;
		this.SpotlightHaloScale = 40.0;

		this.SpriteName[0] = '\0';
		this.SpriteScale = 1.0;

		this.BeamRingStartRadius = 5.0;
		this.BeamRingEndRadius = 10.0;
		this.BeamRingStartFrame = 0;
		this.BeamRingFrameRate = 12;
		this.BeamRingWidth = 100.0;
		this.BeamRingAmplitude = 1.0;
		this.BeamRingSpeed = 5;
		this.BeamRingFlags = 0;
		this.BeamRingColor = "255 255 255 255";
		this.BeamRingBeamSprite = "sprites/laser.vmt";
		this.BeamRingBeamModel = -1;
		this.BeamRingHaloSprite = "sprites/halo01.vmt";
		this.BeamRingHaloModel = -1;

		this.TEParticleAttachType = 0;
		this.TEParticleReset = true;
		this.TEParticleHasControlPoint = false;
		this.TEParticleControlPointAttachType = 0;

		this.SoundSounds.Init();
	}

	void Load(KeyValues kv, bool checkFile)
	{
		kv.GetSectionName(this.SectionName, sizeof(this.SectionName));
		char effectTypeString[64], buffer[PLATFORM_MAX_PATH];
		kv.GetString("type", effectTypeString, sizeof(effectTypeString));
		if (strcmp(effectTypeString, "steam", false) == 0)
		{
			this.Type = EffectType_Steam;
			this.SteamSpreadSpeed = kv.GetNum("spreadspeed", this.SteamSpreadSpeed);
			this.SteamSpeed = kv.GetNum("speed", this.SteamSpeed);
			this.SteamStartSize = kv.GetNum("startsize", this.SteamStartSize);
			this.SteamEndSize = kv.GetNum("endsize", this.SteamEndSize);
			this.SteamRate = kv.GetNum("rate", this.SteamRate);
			this.SteamJetLength = kv.GetNum("jetlength", this.SteamJetLength);
			this.SteamRollSpeed = kv.GetFloat("rollspeed", this.SteamRollSpeed);
			this.SteamType = kv.GetNum("particletype", this.SteamType);
		}
		else if (strcmp(effectTypeString, "dynamiclight", false) == 0)
		{
			this.Type = EffectType_DynamicLight;
			this.LightBrightness = kv.GetNum("brightness", this.LightBrightness);
			this.LightMaxDistance = kv.GetFloat("distance", this.LightMaxDistance);
			this.LightCone = kv.GetNum("cone", this.LightCone);
			this.LightStyle = kv.GetNum("lightstyle", this.LightStyle);

			this.SetupColors(kv);
		}
		else if (strcmp(effectTypeString, "particle", false) == 0)
		{
			this.Type = EffectType_Particle;
			kv.GetString("particlename", this.ParticleName, sizeof(this.ParticleName), this.ParticleName);
		}
		else if (strcmp(effectTypeString, "trail", false) == 0)
		{
			this.Type = EffectType_Trail;
			this.TrailTime = kv.GetFloat("trailtime", this.TrailTime);
			this.TrailStartWidth = kv.GetFloat("startwidth", this.TrailStartWidth);
			this.TrailEndWidth = kv.GetFloat("endwidth", this.TrailEndWidth);
			kv.GetString("spritename", this.TrailName, sizeof(this.TrailName), this.TrailName);

			this.SetupColors(kv);
		}
		else if (strcmp(effectTypeString, "propdynamic", false) == 0)
		{
			this.Type = EffectType_PropDynamic;
			kv.GetString("modelname", this.ModelName, sizeof(this.ModelName), this.ModelName);
			this.ModelScale = kv.GetFloat("modelscale", this.ModelScale);
			this.ModelSkin = kv.GetNum("modelskin", this.ModelSkin);
			kv.GetString("modelanimation", this.ModelAnimation, sizeof(this.ModelAnimation), this.ModelAnimation);

			this.SetupColors(kv);
		}
		else if (strcmp(effectTypeString, "pointspotlight", false) == 0)
		{
			this.Type = EffectType_PointSpotlight;
			this.RenderModes = RENDER_TRANSTEXTURE;
			this.SpotlightWidth = kv.GetFloat("spotlightwidth", this.SpotlightWidth);
			this.SpotlightLength = kv.GetFloat("spotlightlength", this.SpotlightLength);
			this.SpotlightHaloScale = kv.GetFloat("halo_scale", this.SpotlightHaloScale);
			this.LightBrightness = kv.GetNum("brightness", this.LightBrightness);
			this.LightMaxDistance = kv.GetFloat("distance", this.LightMaxDistance);
			this.LightCone = kv.GetNum("cone", this.LightCone);

			this.SetupColors(kv);
		}
		else if (strcmp(effectTypeString, "sprite", false) == 0)
		{
			this.Type = EffectType_Sprite;
			kv.GetString("spritename", this.SpriteName, sizeof(this.SpriteName), this.SpriteName);
			this.SpriteScale = kv.GetFloat("spritescale", this.SpriteScale);

			this.SetupColors(kv);
		}
		else if (strcmp(effectTypeString, "te_beamring", false) == 0)
		{
			this.Type = EffectType_TempEntBeamRing;
			this.BeamRingStartRadius = kv.GetFloat("start_radius", this.BeamRingStartRadius);
			this.BeamRingEndRadius = kv.GetFloat("end_radius", this.BeamRingEndRadius);
			this.BeamRingStartFrame = kv.GetNum("start_frame", this.BeamRingStartFrame);
			this.BeamRingFrameRate = kv.GetNum("framerate", this.BeamRingFrameRate);
			this.BeamRingWidth = kv.GetFloat("width", this.BeamRingWidth);
			this.BeamRingAmplitude = kv.GetFloat("amplitude", this.BeamRingAmplitude);
			this.BeamRingSpeed = kv.GetNum("speed", this.BeamRingSpeed);
			this.BeamRingFlags = kv.GetNum("flags", this.BeamRingFlags);
			kv.GetString("color", this.BeamRingColor, sizeof(this.BeamRingColor), this.BeamRingColor);
			kv.GetString("beam_sprite", this.BeamRingBeamSprite, sizeof(this.BeamRingBeamSprite), this.BeamRingBeamSprite);
			if (this.BeamRingBeamSprite[0] != '\0')
			{
				this.BeamRingBeamModel = PrecacheModel(this.BeamRingBeamSprite, true);
				FormatEx(buffer, sizeof(buffer), "materials/%s", this.BeamRingBeamSprite);
				AddFileToDownloadsTable(buffer);
			}
			kv.GetString("halo_sprite", this.BeamRingHaloSprite, sizeof(this.BeamRingHaloSprite), this.BeamRingHaloSprite);
			if (this.BeamRingHaloSprite[0] != '\0')
			{
				this.BeamRingHaloModel = PrecacheModel(this.BeamRingHaloSprite, true);
				FormatEx(buffer, sizeof(buffer), "materials/%s", this.BeamRingHaloSprite);
				AddFileToDownloadsTable(buffer);
			}
		}
		else if (strcmp(effectTypeString, "te_particle", false) == 0)
		{
			this.Type = EffectType_TempEntParticle;
			kv.GetString("particlename", this.ParticleName, sizeof(this.ParticleName), this.ParticleName);
			kv.GetVector("start", this.TEParticleStartPos, this.TEParticleStartPos);

			char attachType[64];
			kv.GetString("attach_type", attachType, sizeof(attachType));
			if (strcmp(attachType, "follow_origin", false) == 0)
			{
				this.TEParticleAttachType = 1;
			}
			else if (strcmp(attachType, "start_at_customorigin", false) == 0)
			{
				this.TEParticleAttachType = 2;
			}
			else if (strcmp(attachType, "start_at_attachment", false) == 0)
			{
				this.TEParticleAttachType = 3;
			}
			else if (strcmp(attachType, "follow_attachment", false) == 0)
			{
				this.TEParticleAttachType = 4;
			}
			else if (strcmp(attachType, "start_at_worldorigin", false) == 0)
			{
				this.TEParticleAttachType = 5;
			}
			else if (strcmp(attachType, "follow_rootbone", false) == 0)
			{
				this.TEParticleAttachType = 6;
			}

			this.TEParticleReset = kv.GetNum("reset_particles", this.TEParticleReset) != 0;
			this.TEParticleHasControlPoint = kv.GetNum("control_point", this.TEParticleHasControlPoint) != 0;
			this.TEParticleControlPointAttachType = kv.GetNum("control_point_attach_type", this.TEParticleControlPointAttachType);
			kv.GetVector("control_point_offset", this.TEParticleControlPointOffset, this.TEParticleControlPointOffset);
		}
		else if (strcmp(effectTypeString, "sound", false) == 0)
		{
			this.Type = EffectType_Sound;
			this.SoundSounds.Load(kv, checkFile);
		}

		kv.GetString("event", effectTypeString, sizeof(effectTypeString), "constant");
		if (strcmp(effectTypeString, "constant", false) == 0)
		{
			this.Event = EffectEvent_Constant;
		}
		if (strcmp(effectTypeString, "boss_hitplayer", false) == 0)
		{
			this.Event = EffectEvent_HitPlayer;
		}
		if (strcmp(effectTypeString, "boss_seenbyplayer", false) == 0)
		{
			this.Event = EffectEvent_PlayerSeesBoss;
		}

		this.DifficultyIndexes = kv.GetNum("difficulty_indexes", this.DifficultyIndexes);
		this.RenderModes = view_as<RenderMode>(kv.GetNum("rendermode", view_as<int>(this.RenderModes)));
		this.RenderEffects = view_as<RenderFx>(kv.GetNum("renderfx", view_as<int>(this.RenderEffects)));
		this.SpawnFlags = kv.GetNum("spawnflags", this.SpawnFlags);
		kv.GetVector("origin", this.Origin, this.Origin);
		kv.GetVector("angles", this.Angles, this.Angles);
		this.FadeAlpha = kv.GetNum("renderamt", this.FadeAlpha);
		this.Attachment = kv.GetNum("attach_point", this.Attachment) != 0;
		kv.GetString("attachment_point", this.AttachmentName, sizeof(this.AttachmentName), this.AttachmentName);
		this.LifeTime = kv.GetFloat("lifetime", this.LifeTime);
		this.Delay = kv.GetFloat("delay", this.Delay);
		this.AttachPlayer = kv.GetNum("attach_player", this.AttachPlayer) != 0;
	}

	void SetupColors(KeyValues kv)
	{
		this.Colors = new ArrayList(4);
		int renderColor[Difficulty_Max][4];
		GetProfileDifficultyColorValues(kv, "rendercolor", renderColor, renderColor);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Colors.PushArray(renderColor[i]);
		}
	}

	void PostLoad()
	{
		this.SoundSounds.PostLoad();
	}

	void Destroy()
	{
		if (this.Colors != null)
		{
			delete this.Colors;
		}
		this.SoundSounds.Destroy();
	}
}

enum struct SF2BossProfileCompanionsInfo
{
	float Weight[Difficulty_Max];
	ArrayList Bosses;

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Weight[difficulty] = 1.0;
		}
		this.Bosses = null;
	}

	void Load(KeyValues kv)
	{
		char compProfile[SF2_MAX_PROFILE_NAME_LENGTH], num[32];
		if (!kv.JumpToKey("bosses"))
		{
			return;
		}
		this.Bosses = new ArrayList(ByteCountToCells(SF2_MAX_PROFILE_NAME_LENGTH));
		for (int i = 1;; i++)
		{
			FormatEx(num, sizeof(num), "%d", i);
			kv.GetString(num, compProfile, sizeof(compProfile));
			if (compProfile[0] == '\0')
			{
				break;
			}
			this.Bosses.PushString(compProfile);
		}
		kv.GoBack();
		GetProfileDifficultyFloatValues(kv, "weight", this.Weight, this.Weight);
	}

	void PostLoad()
	{
		if (this.Bosses != null && this.Bosses.Length <= 0)
		{
			delete this.Bosses;
		}
	}

	void Destroy()
	{
		if (this.Bosses != null)
		{
			delete this.Bosses;
		}
	}
}

enum struct SF2BossProfileAttributesInfo
{
	float Value[SF2Attribute_Max];
	void Init()
	{
		for (int i = 0; i < SF2Attribute_Max; i++)
		{
			this.Value[i] = -1.0;
		}
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < SF2Attribute_Max; i++)
		{
			if (!kv.JumpToKey(g_AttributesList[i]))
			{
				continue;
			}
			this.Value[i] = kv.GetFloat("value", this.Value[i]);
			kv.GoBack();
		}
		kv.GoBack();
	}
}

enum struct SF2BossProfileAnimationSectionNameData // This does NOT cover the entire "animations" section
{
	ArrayList Sequences;
	float Duration[Difficulty_Max];
	float Playbackrate[Difficulty_Max];
	float Cycle[Difficulty_Max];
	float FootstepInterval[Difficulty_Max];
	bool OverrideLoop[Difficulty_Max];
	bool Loop[Difficulty_Max];
	char SectionName[64];
	char SubSectionName[64];

	void Init(char optionalSectionName[64] = "", char optionalSubSection[64] = "")
	{
		this.Sequences = null;
		if (optionalSectionName[0] == '\0')
		{
			this.SectionName[0] = '\0';
		}
		else
		{
			strcopy(this.SectionName, sizeof(this.SectionName), optionalSectionName);
		}
		strcopy(this.SubSectionName, sizeof(this.SubSectionName), optionalSubSection);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Duration[i] = 0.0;
			this.Playbackrate[i] = 1.0;
			this.Cycle[i] = 0.0;
			this.FootstepInterval[i] = -1.0;
			this.OverrideLoop[i] = false;
			this.Loop[i] = false;
		}
	}

	void Load(KeyValues kv, bool newStuff = true)
	{
		char animNames[Difficulty_Max][64], formatter[90];
		this.Sequences = new ArrayList(ByteCountToCells(64));
		this.Sequences.Resize(Difficulty_Max);

		if (newStuff)
		{
			GetProfileDifficultyStringValues(kv, "name", animNames, sizeof(animNames[]), animNames);
			GetProfileDifficultyFloatValues(kv, "playbackrate", this.Playbackrate, this.Playbackrate);
			GetProfileDifficultyFloatValues(kv, "duration", this.Duration, this.Duration);
			GetProfileDifficultyFloatValues(kv, "cycle", this.Cycle, this.Cycle);
			GetProfileDifficultyFloatValues(kv, "footstepinterval", this.FootstepInterval, this.FootstepInterval);
			GetProfileDifficultyBoolValues(kv, "override_loop", this.OverrideLoop, this.OverrideLoop);
			GetProfileDifficultyBoolValues(kv, "loop", this.Loop, this.Loop);
		}

		FormatEx(formatter, sizeof(formatter), "animation_%s", this.SectionName);
		GetProfileDifficultyStringValues(kv, formatter, animNames, sizeof(animNames[]), animNames);

		FormatEx(formatter, sizeof(formatter), "animation_%s_playbackrate", this.SectionName);
		GetProfileDifficultyFloatValues(kv, formatter, this.Playbackrate, this.Playbackrate);

		FormatEx(formatter, sizeof(formatter), "animation_%s_duration", this.SectionName);
		GetProfileDifficultyFloatValues(kv, formatter, this.Duration, this.Duration);

		FormatEx(formatter, sizeof(formatter), "animation_%s_cycle", this.SectionName);
		GetProfileDifficultyFloatValues(kv, formatter, this.Cycle, this.Cycle);

		FormatEx(formatter, sizeof(formatter), "animation_%s_cycle", this.SectionName);
		GetProfileDifficultyFloatValues(kv, formatter, this.FootstepInterval, this.FootstepInterval);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.SetSequence(i, animNames[i]);
		}
	}

	void Destroy()
	{
		if (this.Sequences != null)
		{
			delete this.Sequences;
		}
	}

	void GetSequence(int difficulty, char[] buffer, int bufferLen)
	{
		this.Sequences.GetString(difficulty, buffer, bufferLen);
	}

	void SetSequence(int difficulty, const char[] name)
	{
		this.Sequences.SetString(difficulty, name);
	}
}

enum struct SF2BossProfileMasterAnimationsData // This one DOES cover the "animations" section
{
	StringMap Animations;
	StringMap Gestures;
	bool Classic;

	void Init()
	{
		this.Animations = null;
		this.Gestures = null;
		this.Classic = false;
	}

	void Load(KeyValues kv, bool newStuff = false)
	{
		SF2BossProfileAnimationSectionNameData animData;
		this.Animations = null;
		if (kv.JumpToKey("animations"))
		{
			this.Gestures = new StringMap();
			char animType[64];
			SF2BossProfileAttackGestureData gestureData;

			if (kv.GotoFirstSubKey()) // Find the animation name
			{
				if (this.Animations == null)
				{
					this.Animations = new StringMap();
				}
				do
				{
					kv.GetSectionName(animType, sizeof(animType));
					if (strcmp(animType, "attack") == 0)
					{
						ArrayList gestureDataArray = new ArrayList(sizeof(gestureData));

						if (kv.GotoFirstSubKey())
						{
							if (this.Gestures == null)
							{
								this.Gestures = new StringMap();
							}
							do
							{
								char animType2[64];
								kv.GetSectionName(animType2, sizeof(animType2));
								gestureData.Init(animType2);
								gestureData.Load(kv);
								gestureDataArray.PushArray(gestureData);
							}
							while (kv.GotoNextKey());

							kv.GoBack();
						}
						this.Gestures.SetValue(animType, gestureDataArray);
					}

					ArrayList animDataArray = new ArrayList(sizeof(animData));
					if (kv.GotoFirstSubKey()) // Find the indexes
					{
						do
						{
							char animType2[64];
							kv.GetSectionName(animType2, sizeof(animType2));
							animData.Init(animType, animType2);
							animData.Load(kv);
							animDataArray.PushArray(animData);
						}
						while (kv.GotoNextKey());

						kv.GoBack();
					}
					this.Animations.SetValue(animType, animDataArray);
				}
				while (kv.GotoNextKey());

				kv.GoBack();
			}

			kv.GoBack();
		}
		else
		{
			if (!newStuff)
			{
				return;
			}
			for (int i = 0; i < SF2BossAnimation_MaxAnimations; i++)
			{
				char formatter[90], section[64];
				FormatEx(formatter, sizeof(formatter), "animation_%s", g_SlenderAnimationsList[i]);
				if (kv.GetDataType(formatter) == KvData_None)
				{
					continue;
				}
				if (this.Animations == null)
				{
					this.Animations = new StringMap();
				}
				ArrayList animDataArray = new ArrayList(sizeof(animData));
				strcopy(section, sizeof(section), g_SlenderAnimationsList[i]);
				animData.Init(section);
				animData.Load(kv, false);
				animDataArray.PushArray(animData);
				this.Animations.SetValue(section, animDataArray);
				this.Classic = true;
			}
		}
	}

	void Destroy()
	{
		char animType[64];
		ArrayList animDataArray;
		SF2BossProfileAnimationSectionNameData animData;
		SF2BossProfileAttackGestureData gestureData;
		if (this.Animations != null)
		{
			StringMapSnapshot snapshot = this.Animations.Snapshot();
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, animType, sizeof(animType));
				this.Animations.GetValue(animType, animDataArray);

				for (int j = 0; j < animDataArray.Length; j++)
				{
					animDataArray.GetArray(j, animData, sizeof(animData));
					animData.Destroy();
				}
				if (animDataArray != null)
				{
					delete animDataArray;
				}
			}
			delete snapshot;
			delete this.Animations;
		}

		if (this.Gestures != null)
		{
			StringMapSnapshot gestureSnapshot = this.Gestures.Snapshot();
			for (int i = 0; i < gestureSnapshot.Length; i++)
			{
				gestureSnapshot.GetKey(i, animType, sizeof(animType));
				this.Gestures.GetValue(animType, animDataArray);

				for (int j = 0; j < animDataArray.Length; j++)
				{
					animDataArray.GetArray(j, gestureData, sizeof(gestureData));
					gestureData.Destroy();
				}
				if (animDataArray != null)
				{
					delete animDataArray;
				}
			}
			delete gestureSnapshot;
			delete this.Gestures;
		}
	}

	bool HasAnimationSection(const char[] animType)
	{
		if (this.Animations == null)
		{
			return false;
		}
		ArrayList tempArray;

		return this.Animations.GetValue(animType, tempArray);
	}

	bool GetAnimation(const char[] animType, int difficulty, char[] buffer, int bufferLen, float &rate = 1.0, float &duration = 0.0, float &cycle = 0.0, float &footstepinterval = 0.0, int &index = 0, int preDefinedIndex = -1, const char[] preDefinedName = "", bool &overrideLoop = false, bool &loop = false, int findIndex = -1)
	{
		if (this.Animations == null)
		{
			return false;
		}
		ArrayList animDataArray;

		if (this.Animations.GetValue(animType, animDataArray))
		{
			if (findIndex >= 0)
			{
				preDefinedIndex = animDataArray.FindValue(findIndex);
			}
			int randomAnimation;
			if (preDefinedIndex <= -1)
			{
				randomAnimation = GetRandomInt(0, animDataArray.Length - 1);
			}
			else
			{
				if (preDefinedIndex >= animDataArray.Length)
				{
					preDefinedIndex = animDataArray.Length - 1;
				}
				randomAnimation = preDefinedIndex;
			}

			if (animDataArray == null || animDataArray.Length <= 0)
			{
				return false;
			}

			SF2BossProfileAnimationSectionNameData animData;
			if (!this.Classic && preDefinedName[0] != '\0')
			{
				bool found = false;
				for (int i = 0; i < animDataArray.Length; i++)
				{
					animDataArray.GetArray(i, animData, sizeof(animData));
					if (strcmp(animData.SubSectionName, preDefinedName) == 0)
					{
						found = true;
						break;
					}
				}
				if (!found)
				{
					return false;
				}
			}
			else
			{
				animDataArray.GetArray(randomAnimation, animData, sizeof(animData));
			}

			animData.GetSequence(difficulty, buffer, bufferLen);
			rate = animData.Playbackrate[difficulty];
			duration = animData.Duration[difficulty];
			cycle = animData.Cycle[difficulty];
			footstepinterval = animData.FootstepInterval[difficulty];
			overrideLoop = animData.OverrideLoop[difficulty];
			loop = animData.Loop[difficulty];
			index = randomAnimation;

			return true;
		}

		return false;
	}

	bool GetGesture(int definedIndex, const char[] definedName = "", const char[] animType, int difficulty, char[] buffer, int bufferLen, float &rate = 1.0, float &cycle = 0.0)
	{
		if (this.Gestures == null)
		{
			return false;
		}
		ArrayList gestureDataArray;

		if (this.Gestures.GetValue(animType, gestureDataArray))
		{
			SF2BossProfileAttackGestureData gestureData;
			if (definedName[0] != '\0')
			{
				bool found = false;
				for (int i = 0; i < gestureDataArray.Length; i++)
				{
					gestureDataArray.GetArray(i, gestureData, sizeof(gestureData));
					if (strcmp(gestureData.SectionName, definedName) == 0)
					{
						found = true;
						break;
					}
				}
				if (!found)
				{
					return false;
				}
			}
			else
			{
				gestureDataArray.GetArray(definedIndex, gestureData, sizeof(gestureData));
			}

			gestureData.GetGesture(difficulty, buffer, bufferLen);
			rate = gestureData.Playbackrate[difficulty];
			cycle = gestureData.Cycle[difficulty];

			return true;
		}

		return false;
	}
}

enum struct SF2BossProfileCopiesInfo
{
	bool Enabled[Difficulty_Max];
	int MinCopies[Difficulty_Max];
	int MaxCopies[Difficulty_Max];
	float TeleportDistanceSpacing[Difficulty_Max];
	bool Fakes[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.MinCopies[difficulty] = 0;
			this.MaxCopies[difficulty] = 1;
			this.TeleportDistanceSpacing[difficulty] = 800.0;
			this.Fakes[difficulty] = false;
		}
	}

	void Load(KeyValues kv)
	{
		if (!kv.JumpToKey("copies"))
		{
			GetProfileDifficultyBoolValues(kv, "copy", this.Enabled, this.Enabled);
			GetProfileDifficultyNumValues(kv, "copy_max", this.MaxCopies, this.MaxCopies);
			GetProfileDifficultyFloatValues(kv, "copy_teleport_dist_from_others", this.TeleportDistanceSpacing, this.TeleportDistanceSpacing);
			GetProfileDifficultyBoolValues(kv, "fake_copies", this.Fakes, this.Fakes);
		}
		else
		{
			GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
			GetProfileDifficultyNumValues(kv, "min", this.MinCopies, this.MinCopies);
			GetProfileDifficultyNumValues(kv, "max", this.MaxCopies, this.MaxCopies);
			GetProfileDifficultyFloatValues(kv, "teleport_spacing_between", this.TeleportDistanceSpacing, this.TeleportDistanceSpacing);
			GetProfileDifficultyBoolValues(kv, "fakes", this.Fakes, this.Fakes);
			kv.GoBack();
		}
	}
}

enum struct SF2BossProfilePublicDeathCamData
{
	bool Enabled;
	bool Blackout;
	SF2BossProfileSoundInfo ExecutionSounds;
	char Attachment[64];
	char TargetAttachment[64];
	float DownwardOffset;
	float BackwardOffset;

	void Init()
	{
		this.Enabled = false;
		this.Blackout = false;
		this.ExecutionSounds.Init();
		this.Attachment[0] = '\0';
		this.TargetAttachment[0] = '\0';
		this.DownwardOffset = 0.0;
		this.BackwardOffset = 0.0;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		this.Enabled = true;
		this.Blackout = kv.GetNum("blackout", this.Blackout) != 0;
		if (kv.JumpToKey("sounds"))
		{
			if (kv.JumpToKey("execution"))
			{
				this.ExecutionSounds.Load(kv, checkFile);
				kv.GoBack();
			}
			kv.GoBack();
		}
		kv.GetString("attachment", this.Attachment, sizeof(this.Attachment), this.Attachment);
		kv.GetString("target_attachment", this.TargetAttachment, sizeof(this.TargetAttachment), this.TargetAttachment);
		if (kv.JumpToKey("offset"))
		{
			this.DownwardOffset = kv.GetFloat("downward", this.DownwardOffset);
			this.BackwardOffset = kv.GetFloat("backward", this.BackwardOffset);
			kv.GoBack();
		}
	}

	void PostLoad()
	{
		this.ExecutionSounds.PostLoad();
	}

	void Destroy()
	{
		this.ExecutionSounds.Destroy();
	}
}

enum struct SF2BossProfileEyeData
{
	int Type;
	float OffsetPos[3];
	float OffsetAng[3];
	char Bone[128];

	void Init()
	{
		this.Type = 0;
		for (int i = 0; i < 3; i++)
		{
			this.OffsetPos[i] = 0.0;
			this.OffsetAng[i] = 0.0;
		}

		this.OffsetPos[2] = 45.0;
		this.Bone[0] = '\0';
	}

	void Load(KeyValues kv)
	{
		char type[64];
		kv.GetString("mode", type, sizeof(type), "default");
		if (strcmp(type, "bone") == 0)
		{
			this.Type = 1;
			kv.GetString("bone", this.Bone, sizeof(this.Bone), this.Bone);
			this.OffsetPos[2] = 0.0;
		}
		kv.GetVector("offset_pos", this.OffsetPos, this.OffsetPos);
		kv.GetVector("offset_ang", this.OffsetAng, this.OffsetAng);
	}
}

enum struct SF2BossProfileDescriptionData
{
	bool Hidden;
	char Type[32];
	char Information[128];

	void Init()
	{
		this.Hidden = false;
		this.Type[0] = '\0';
		this.Information = "No description provided.";
	}

	void Load(KeyValues kv)
	{
		this.Hidden = kv.GetNum("hidden", this.Hidden) != 0;
		kv.GetString("type", this.Type, sizeof(this.Type), this.Type);
		kv.GetString("description", this.Information, sizeof(this.Information), this.Information);
	}
}

enum struct SF2BossProfileSlaughterRunData
{
	bool CustomMinimumSpeed[Difficulty_Max];
	float SpawnTime[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.CustomMinimumSpeed[i] = false;
			this.SpawnTime[i] = -1.0;
		}
	}

	void Load(KeyValues kv)
	{
		GetProfileDifficultyBoolValues(kv, "custom_minimum_speed", this.CustomMinimumSpeed, this.CustomMinimumSpeed);
		GetProfileDifficultyFloatValues(kv, "spawn_time", this.SpawnTime, this.SpawnTime);
	}
}

enum struct SF2BossProfileData
{
	ArrayList Models;
	ArrayList Names;
	int Type;
	float ModelScale;
	int Skin[Difficulty_Max];
	int SkinMax;
	bool SkinDifficultiesOn;
	int Body[Difficulty_Max];
	int BodyMax;
	bool BodyDifficultiesOn;
	int Flags;
	bool RaidHitbox;
	bool IgnoreNavPrefer;
	float StepSize;
	float Mins[3];
	float Maxs[3];
	float NodeDistanceLookAhead;
	int RenderFX;
	int RenderMode;

	SF2BossProfileDescriptionData Description;

	char WeaponString[PLATFORM_MAX_PATH];
	int WeaponInt;

	int RenderColor[4];

	bool DiscoMode;
	float DiscoDistanceMin;
	float DiscoDistanceMax;
	float DiscoPos[3];

	bool FestiveLights;
	int FestiveLightBrightness;
	float FestiveLightDistance;
	float FestiveLightRadius;
	float FestiveLightPos[3];
	float FestiveLightAng[3];

	float BlinkLookRate;
	float BlinkStaticRate;

	float SoundMusicLoop[Difficulty_Max];

	bool DeathCam;
	bool DeathCamScareSound;
	bool PublicDeathCam;
	float PublicDeathCamSpeed;
	float PublicDeathCamAcceleration;
	float PublicDeathCamDeceleration;
	float PublicDeathCamBackwardOffset;
	float PublicDeathCamDownwardOffset;
	char PublicDeathCamAttachmentTarget[PLATFORM_MAX_PATH];
	char PublicDeathCamAttachment[PLATFORM_MAX_PATH];
	bool DeathCamOverlay;
	float DeathCamOverlayStartTime;
	float DeathCamTime;
	float DeathCamPos[3];

	SF2BossProfilePublicDeathCamData DeathCamData;

	float RunSpeed[Difficulty_Max];
	float Acceleration[Difficulty_Max];

	float IdleLifeTime[Difficulty_Max];

	float SearchRange[Difficulty_Max];
	float SearchSoundRange[Difficulty_Max];
	float TauntAlertRange[Difficulty_Max];

	float FOV;
	float TurnRate;
	float EyePosOffset[3];
	float EyeAngOffset[3];

	float InstantKillRadius;
	float InstantKillCooldown[Difficulty_Max];

	bool CustomOutlines;
	int OutlineColor[4];
	bool RainbowOutline;
	float RainbowOutlineCycle;

	float ScareRadius;
	float ScareCooldown;

	bool SpeedBoostOnScare;
	float ScareSpeedBoostDuration;

	bool ScareReaction;
	int ScareReactionType;
	char ScareReactionCustom[PLATFORM_MAX_PATH];

	bool ScareReplenishSprint;
	float ScareReplenishSprintAmount;

	float StaticRadius[Difficulty_Max];
	float StaticRate[Difficulty_Max];
	float StaticRateDecay[Difficulty_Max];
	float StaticGraceTime[Difficulty_Max];
	float StaticScareAmount;

	int TeleportType;
	bool TeleportAllowed[Difficulty_Max];
	float TeleportRangeMin[Difficulty_Max];
	float TeleportRangeMax[Difficulty_Max];
	float TeleportTimeMin[Difficulty_Max];
	float TeleportTimeMax[Difficulty_Max];
	float TeleportRestPeriod[Difficulty_Max];
	float TeleportStressMin[Difficulty_Max];
	float TeleportStressMax[Difficulty_Max];
	float TeleportPersistencyPeriod[Difficulty_Max];
	bool TeleportIgnoreChases;
	bool TeleportIgnoreVis;

	float JumpscareDistance[Difficulty_Max];
	float JumpscareDuration[Difficulty_Max];
	float JumpscareCooldown[Difficulty_Max];
	bool JumpscareOnScare;
	bool JumpscareNoSight;

	char ProxyClasses[512];
	float ProxyDamageVsEnemy[Difficulty_Max];
	float ProxyDamageVsBackstab[Difficulty_Max];
	float ProxyDamageVsSelf[Difficulty_Max];
	int ProxyControlGainHitEnemy[Difficulty_Max];
	int ProxyControlGainHitByEnemy[Difficulty_Max];
	float ProxyControlDrainRate[Difficulty_Max];
	int MaxProxies[Difficulty_Max];
	float ProxySpawnChanceMin[Difficulty_Max];
	float ProxySpawnChaceMax[Difficulty_Max];
	float ProxySpawnChanceThreshold[Difficulty_Max];
	int ProxySpawnNumMin[Difficulty_Max];
	int ProxySpawnNumMax[Difficulty_Max];
	float ProxySpawnCooldownMin[Difficulty_Max];
	float ProxySpawnCooldownMax[Difficulty_Max];
	float ProxyTeleportRangeMin[Difficulty_Max];
	float ProxyTeleportRangeMax[Difficulty_Max];
	bool ProxyAllowVoices;
	bool ProxyWeapons;
	ArrayList ProxyWeaponClassNames;
	ArrayList ProxyWeaponStats;
	int ProxyWeaponIndexes[10];
	int ProxyWeaponSlots[10];
	bool ProxySpawnEffect;
	char ProxySpawnEffectName[PLATFORM_MAX_PATH];
	float ProxySpawnEffectZOffset;
	ArrayList ProxyDeathAnimations;
	int ProxyDeathAnimFrames[10];
	bool ProxyZombies;
	bool ProxyRobots;
	bool ProxyDifficultyModels;
	ArrayList ProxyModels[10];
	ArrayList ProxyModelsHard[10];
	ArrayList ProxyModelsInsane[10];
	ArrayList ProxyModelsNightmare[10];
	ArrayList ProxyModelsApollyon[10];
	bool ProxyOverrideMaxSpeed;
	float ProxyMaxSpeed[Difficulty_Max];

	bool DrainCredits;
	int DrainCreditAmount[Difficulty_Max];

	bool Healthbar;

	int DeathMessageDifficultyIndexes;
	ArrayList DeathMessagesArray;
	char DeathMessagePrefix[PLATFORM_MAX_PATH];

	bool BurnRagdoll;
	bool CloakRagdoll;
	bool DecapRagdoll;
	bool GibRagdoll;
	bool IceRagdoll;
	bool GoldRagdoll;
	bool ElectrocuteRagdoll;
	bool AshRagdoll;
	bool DeleteRagdoll;
	bool PushRagdoll;
	float PushRagdollForce[3];
	bool DissolveRagdoll;
	int DissolveKillType;
	bool PlasmaRagdoll;
	bool ResizeRagdoll;
	float ResizeRagdollHead;
	float ResizeRagdollHands;
	float ResizeRagdollTorso;
	bool DecapOrGibRagdoll;
	bool SilentKill;
	bool MultiEffectRagdoll;
	bool CustomDeathFlag;
	int CustomDeathFlagType;

	bool OutroMusic;

	char EngineSound[PLATFORM_MAX_PATH];
	int EngineSoundLevel;
	float EngineSoundVolume;

	bool IsPvEBoss;
	ArrayList PvESpawnMessagesArray;
	char PvESpawnMessagePrefix[PLATFORM_MAX_PATH];
	bool DisplayPvEHealth;
	float PvETeleportEndTimer;

	// Sounds
	SF2BossProfileSoundInfo LocalDeathCamSounds;
	SF2BossProfileSoundInfo ClientDeathCamSounds;
	SF2BossProfileSoundInfo GlobalDeathCamSounds;
	SF2BossProfileSoundInfo MusicSoundsNormal;
	SF2BossProfileSoundInfo MusicSoundsHard;
	SF2BossProfileSoundInfo MusicSoundsInsane;
	SF2BossProfileSoundInfo MusicSoundsNightmare;
	SF2BossProfileSoundInfo MusicSoundsApollyon;
	SF2BossProfileSoundInfo ScareSounds;
	SF2BossProfileSoundInfo SightSounds;
	SF2BossProfileSoundInfo IntroSounds;
	SF2BossProfileSoundInfo SpawnLocalSounds;
	char JumpscareSound[PLATFORM_MAX_PATH];
	char StaticSound[PLATFORM_MAX_PATH];
	char StaticLocalSound[PLATFORM_MAX_PATH];
	char StaticShakeLocal[PLATFORM_MAX_PATH];
	float StaticShakeVolumeMin;
	float StaticShakeVolumeMax;
	int StaticShakeLocalLevel;
	char OverlayJumpscare[PLATFORM_MAX_PATH];
	char OverlayPlayerDeath[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo PlayerDeathCamOverlaySounds;
	SF2BossProfileSoundInfo OutroMusics;

	ArrayList FootstepEventSounds;
	ArrayList FootstepEventIndexes;
	ArrayList EventSounds;
	ArrayList EventIndexes;

	SF2BossProfileSoundInfo ProxySpawnSounds;
	SF2BossProfileSoundInfo ProxyIdleSounds;
	SF2BossProfileSoundInfo ProxyHurtSounds;
	SF2BossProfileSoundInfo ProxyDeathSounds;

	ArrayList CompanionsArray;
	char CompanionSpawnType[64];

	SF2BossProfileCopiesInfo CopiesInfo;

	SF2BossProfileAttributesInfo AttributesInfo;

	SF2BossProfileMasterAnimationsData AnimationData;

	ArrayList EffectsArray;

	StringMap SpawnEffects;
	StringMap DespawnEffects;
	bool HideDespawnEffectsOnDeath;

	SF2BossProfileEyeData EyeData;

	SF2BossProfileSlaughterRunData SlaughterRunData;

	void Init()
	{
		this.Models = null;
		this.Names = null;
		this.Type = SF2BossType_Chaser;
		this.ModelScale = 1.0;
		this.SkinMax = 0;
		this.SkinDifficultiesOn = false;
		this.BodyMax = 0;
		this.BodyDifficultiesOn = false;
		this.Flags = 0;
		this.RaidHitbox = false;
		this.IgnoreNavPrefer = true;
		this.StepSize = 18.0;
		this.NodeDistanceLookAhead = 128.0;
		this.RenderFX = view_as<int>(RENDERFX_NONE);
		this.RenderMode = view_as<int>(RENDER_NORMAL);

		this.Description.Init();

		this.WeaponString[0] = '\0';
		this.WeaponInt = 0;

		this.RenderColor[0] = 255;
		this.RenderColor[1] = 255;
		this.RenderColor[2] = 255;
		this.RenderColor[3] = 255;

		this.DiscoMode = false;
		this.DiscoDistanceMin = 420.0;
		this.DiscoDistanceMax = 750.0;

		this.FestiveLights = false;
		this.FestiveLightBrightness = 0;
		this.FestiveLightDistance = 0.0;
		this.FestiveLightRadius = 0.0;

		this.BlinkLookRate = 1.0;
		this.BlinkStaticRate = 1.0;

		this.DeathCam = false;
		this.DeathCamScareSound = false;
		this.PublicDeathCam = false;
		this.PublicDeathCamSpeed = 1000.0;
		this.PublicDeathCamAcceleration = 1000.0;
		this.PublicDeathCamDeceleration = 1000.0;
		this.PublicDeathCamBackwardOffset = 0.0;
		this.PublicDeathCamDownwardOffset = 0.0;
		this.PublicDeathCamAttachmentTarget[0] = '\0';
		this.PublicDeathCamAttachment[0] = '\0';
		this.DeathCamOverlay = false;
		this.DeathCamOverlayStartTime = 0.0;
		this.DeathCamTime = 0.0;

		this.DeathCamData.Init();

		this.FOV = 90.0;
		this.TurnRate = 250.0;

		this.InstantKillRadius = -1.0;

		this.CustomOutlines = false;
		this.OutlineColor[0] = 255;
		this.OutlineColor[1] = 255;
		this.OutlineColor[2] = 255;
		this.OutlineColor[3] = 255;
		this.RainbowOutline = false;
		this.RainbowOutlineCycle = 1.0;

		this.ScareRadius = 0.0;
		this.ScareCooldown = 0.0;

		this.SpeedBoostOnScare = false;
		this.ScareSpeedBoostDuration = 0.0;

		this.ScareReaction = false;
		this.ScareReactionType = 1;
		this.ScareReactionCustom[0] = '\0';

		this.ScareReplenishSprint = false;
		this.ScareReplenishSprintAmount = 0.0;

		this.StaticScareAmount = 0.0;

		this.TeleportType = 2;
		this.TeleportIgnoreChases = false;
		this.TeleportIgnoreVis = false;

		this.JumpscareOnScare = false;
		this.JumpscareNoSight = false;

		this.ProxyClasses[0] = '\0';
		this.ProxyAllowVoices = false;
		this.ProxyWeapons = false;
		this.ProxyWeaponClassNames = null;
		this.ProxyWeaponStats = null;
		for (int i = 0; i < 10; i++)
		{
			this.ProxyWeaponIndexes[i] = 0;
			this.ProxyWeaponSlots[i] = 0;
			this.ProxyDeathAnimFrames[i] = 0;
			this.ProxyModels[i] = null;
			this.ProxyModelsHard[i] = null;
			this.ProxyModelsInsane[i] = null;
			this.ProxyModelsNightmare[i] = null;
			this.ProxyModelsApollyon[i] = null;
		}
		this.ProxySpawnEffect = false;
		this.ProxySpawnEffectName[0] = '\0';
		this.ProxySpawnEffectZOffset = 0.0;
		this.ProxyDeathAnimations = null;
		this.ProxyZombies = false;
		this.ProxyRobots = false;
		this.ProxyDifficultyModels = false;
		this.ProxyOverrideMaxSpeed = false;

		this.DrainCredits = false;

		this.Healthbar = false;

		this.DeathMessageDifficultyIndexes = 123456;
		this.DeathMessagesArray = null;
		this.DeathMessagePrefix[0] = '\0';

		this.BurnRagdoll = false;
		this.CloakRagdoll = false;
		this.DecapRagdoll = false;
		this.GibRagdoll = false;
		this.IceRagdoll = false;
		this.GoldRagdoll = false;
		this.ElectrocuteRagdoll = false;
		this.AshRagdoll = false;
		this.DeleteRagdoll = false;
		this.PushRagdoll = false;
		this.DissolveRagdoll = false;
		this.DissolveKillType = 0;
		this.PlasmaRagdoll = false;
		this.ResizeRagdoll = false;
		this.ResizeRagdollHead = 1.0;
		this.ResizeRagdollHands = 1.0;
		this.ResizeRagdollTorso = 1.0;
		this.DecapOrGibRagdoll = false;
		this.SilentKill = false;
		this.MultiEffectRagdoll = false;
		this.CustomDeathFlag = false;
		this.CustomDeathFlagType = 0;

		this.OutroMusic = false;

		this.IsPvEBoss = false;
		this.PvESpawnMessagesArray = null;
		this.PvESpawnMessagePrefix[0] = '\0';
		this.DisplayPvEHealth = true;
		this.PvETeleportEndTimer = 5.0;

		this.EngineSound[0] = '\0';
		this.EngineSoundLevel = 83;
		this.EngineSoundVolume = 0.8;

		this.LocalDeathCamSounds.Init();
		this.ClientDeathCamSounds.Init();
		this.ClientDeathCamSounds.Channel = SNDCHAN_STATIC;
		this.ClientDeathCamSounds.Level = SNDLEVEL_NONE;
		this.GlobalDeathCamSounds.Init();
		this.ScareSounds.Init();
		this.ScareSounds.Channel = SNDCHAN_STATIC;
		this.ScareSounds.Level = SNDLEVEL_NONE;
		this.SightSounds.Init();
		this.SightSounds.CooldownMin = 8.0;
		this.SightSounds.CooldownMax = 14.0;
		this.SightSounds.Channel = SNDCHAN_STATIC;
		this.SightSounds.Level = SNDLEVEL_NONE;
		this.IntroSounds.Init();
		this.IntroSounds.Channel = SNDCHAN_STATIC;
		this.IntroSounds.Level = SNDLEVEL_HELICOPTER;
		this.SpawnLocalSounds.Init();
		this.SpawnLocalSounds.CooldownMin = 0.0;
		this.SpawnLocalSounds.CooldownMax = 0.0;
		this.MusicSoundsNormal.Init();
		this.MusicSoundsHard.Init();
		this.MusicSoundsInsane.Init();
		this.MusicSoundsNightmare.Init();
		this.MusicSoundsApollyon.Init();
		this.OutroMusics.Init();
		this.JumpscareSound[0] = '\0';
		this.StaticSound[0] = '\0';
		this.StaticLocalSound[0] = '\0';
		this.StaticShakeLocal[0] = '\0';
		this.StaticShakeLocalLevel = SNDLEVEL_NORMAL;
		this.StaticShakeVolumeMin = 0.0;
		this.StaticShakeVolumeMax = 0.0;
		this.OverlayJumpscare[0] = '\0';
		this.OverlayPlayerDeath[0] = '\0';
		this.PlayerDeathCamOverlaySounds.Init();
		this.PlayerDeathCamOverlaySounds.Channel = SNDCHAN_STATIC;
		this.PlayerDeathCamOverlaySounds.Level = SNDLEVEL_NONE;

		this.FootstepEventSounds = null;
		this.FootstepEventIndexes = null;
		this.EventSounds = null;
		this.EventIndexes = null;

		this.ProxySpawnSounds.Init();
		this.ProxyIdleSounds.Init();
		this.ProxyHurtSounds.Init();
		this.ProxyDeathSounds.Init();
		this.ProxySpawnSounds.Level = SNDLEVEL_NORMAL;
		this.ProxyIdleSounds.Level = SNDLEVEL_NORMAL;
		this.ProxyIdleSounds.CooldownMax = 3.0;
		this.ProxyHurtSounds.Level = SNDLEVEL_NORMAL;
		this.ProxyDeathSounds.Level = SNDLEVEL_NORMAL;

		this.CompanionsArray = null;
		this.CompanionSpawnType = "on_spawn on_difficulty_change";

		this.CopiesInfo.Init();
		this.AttributesInfo.Init();

		this.AnimationData.Init(); // Save this here whenever I do statue boss animations

		this.EffectsArray = null;

		this.SpawnEffects = null;
		this.DespawnEffects = null;
		this.HideDespawnEffectsOnDeath = false;

		this.EyeData.Init();

		this.SlaughterRunData.Init();

		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Skin[difficulty] = 0;
			this.Body[difficulty] = 0;

			this.SoundMusicLoop[difficulty] = 0.0;

			this.RunSpeed[difficulty] = 150.0;
			this.Acceleration[difficulty] = 6000.0;

			this.IdleLifeTime[difficulty] = 10.0;

			this.SearchRange[difficulty] = 1024.0;
			this.SearchSoundRange[difficulty] = 1024.0;
			this.TauntAlertRange[difficulty] = 512.0;

			this.InstantKillCooldown[difficulty] = 0.0;

			this.StaticRadius[difficulty] = 150.0;
			this.StaticRate[difficulty] = 0.65;
			this.StaticRateDecay[difficulty] = 0.2;
			this.StaticGraceTime[difficulty] = 1.0;

			this.TeleportAllowed[difficulty] = true;
			this.TeleportRangeMin[difficulty] = 450.0;
			this.TeleportRangeMax[difficulty] = 1500.0;
			this.TeleportTimeMin[difficulty] = 5.0;
			this.TeleportTimeMax[difficulty] = 9.0;
			this.TeleportRestPeriod[difficulty] = 15.0;
			this.TeleportStressMin[difficulty] = 0.2;
			this.TeleportStressMax[difficulty] = 1.0;
			this.TeleportPersistencyPeriod[difficulty] = 13.0;

			this.JumpscareDistance[difficulty] = 0.0;
			this.JumpscareDuration[difficulty] = 0.0;
			this.JumpscareCooldown[difficulty] = 0.0;

			this.ProxyDamageVsEnemy[difficulty] = 1.0;
			this.ProxyDamageVsBackstab[difficulty] = 0.25;
			this.ProxyDamageVsSelf[difficulty] = 1.0;
			this.ProxyControlGainHitEnemy[difficulty] = 0;
			this.ProxyControlGainHitByEnemy[difficulty] = 0;
			this.ProxyControlDrainRate[difficulty] = 0.0;
			this.MaxProxies[difficulty] = 0;
			this.ProxySpawnChanceMin[difficulty] = 0.0;
			this.ProxySpawnChaceMax[difficulty] = 0.0;
			this.ProxySpawnChanceThreshold[difficulty] = 0.0;
			this.ProxySpawnNumMin[difficulty] = 0;
			this.ProxySpawnNumMax[difficulty] = 0;
			this.ProxySpawnCooldownMin[difficulty] = 0.0;
			this.ProxySpawnCooldownMax[difficulty] = 0.0;
			this.ProxyTeleportRangeMin[difficulty] = 500.0;
			this.ProxyTeleportRangeMax[difficulty] = 3200.0;
			this.ProxyMaxSpeed[difficulty] = 230.0;

			this.DrainCreditAmount[difficulty] = 50;
		}

		for (int i = 0; i < 3; i++)
		{
			this.Mins[i] = 0.0;
			this.Maxs[i] = 0.0;

			this.DiscoPos[i] = 0.0;

			this.FestiveLightPos[i] = 0.0;
			this.FestiveLightAng[i] = 0.0;

			this.DeathCamPos[i] = 0.0;

			this.PushRagdollForce[i] = 0.0;

			this.EyePosOffset[i] = 0.0;
			this.EyeAngOffset[i] = 0.0;
		}
		this.EyePosOffset[2] = 45.0;
	}

	void PostLoad()
	{
		this.DeathCamData.PostLoad();
		this.ClientDeathCamSounds.PostLoad();
		this.GlobalDeathCamSounds.PostLoad();
		this.LocalDeathCamSounds.PostLoad();
		this.ScareSounds.PostLoad();
		this.SightSounds.PostLoad();
		this.IntroSounds.PostLoad();
		this.SpawnLocalSounds.PostLoad();
		this.MusicSoundsNormal.PostLoad();
		this.MusicSoundsHard.PostLoad();
		this.MusicSoundsInsane.PostLoad();
		this.MusicSoundsNightmare.PostLoad();
		this.MusicSoundsApollyon.PostLoad();
		this.ProxySpawnSounds.PostLoad();
		this.ProxyIdleSounds.PostLoad();
		this.ProxyHurtSounds.PostLoad();
		this.ProxyDeathSounds.PostLoad();
		this.PlayerDeathCamOverlaySounds.PostLoad();
		this.OutroMusics.PostLoad();

		if (this.CompanionsArray != null && this.CompanionsArray.Length <= 0)
		{
			delete this.CompanionsArray;
		}
		else if (this.CompanionsArray != null && this.CompanionsArray.Length > 0)
		{
			for (int i = 0; i < this.CompanionsArray.Length; i++)
			{
				SF2BossProfileCompanionsInfo companions;
				this.CompanionsArray.GetArray(i, companions, sizeof(companions));
				companions.PostLoad();
				this.CompanionsArray.SetArray(i, companions, sizeof(companions));
			}
		}

		if (this.EffectsArray != null && this.EffectsArray.Length <= 0)
		{
			delete this.EffectsArray;
		}

		if (this.EffectsArray != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.EffectsArray.Length; i++)
			{
				this.EffectsArray.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.SpawnEffects != null)
		{
			StringMapSnapshot snapshot = this.SpawnEffects.Snapshot();
			SF2BossProfileBaseEffectInfo effects;
			ArrayList arrayEffects;

			char effectSection[128];
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, effectSection, sizeof(effectSection));
				this.SpawnEffects.GetValue(effectSection, arrayEffects);
				for (int i2 = 0; i2 < arrayEffects.Length; i2++)
				{
					arrayEffects.GetArray(i2, effects, sizeof(effects));
					effects.PostLoad();
				}
			}

			delete snapshot;
		}

		if (this.DespawnEffects != null)
		{
			StringMapSnapshot snapshot = this.DespawnEffects.Snapshot();
			SF2BossProfileBaseEffectInfo effects;
			ArrayList arrayEffects;

			char effectSection[128];
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, effectSection, sizeof(effectSection));
				this.DespawnEffects.GetValue(effectSection, arrayEffects);
				for (int i2 = 0; i2 < arrayEffects.Length; i2++)
				{
					arrayEffects.GetArray(i2, effects, sizeof(effects));
					effects.PostLoad();
				}
			}

			delete snapshot;
		}

		for (int i = 0; i < 10; i++)
		{
			if (this.ProxyModels[i] != null && this.ProxyModels[i].Length <= 0)
			{
				delete this.ProxyModels[i];
			}
			if (this.ProxyModelsHard[i] != null && this.ProxyModelsHard[i].Length <= 0)
			{
				delete this.ProxyModelsHard[i];
			}
			if (this.ProxyModelsInsane[i] != null && this.ProxyModelsInsane[i].Length <= 0)
			{
				delete this.ProxyModelsInsane[i];
			}
			if (this.ProxyModelsNightmare[i] != null && this.ProxyModelsNightmare[i].Length <= 0)
			{
				delete this.ProxyModelsNightmare[i];
			}
			if (this.ProxyModelsApollyon[i] != null && this.ProxyModelsApollyon[i].Length <= 0)
			{
				delete this.ProxyModelsApollyon[i];
			}
		}

		if (this.FootstepEventSounds != null && this.FootstepEventSounds.Length <= 0)
		{
			delete this.FootstepEventSounds;
		}

		if (this.FootstepEventIndexes != null && this.FootstepEventIndexes.Length <= 0)
		{
			delete this.FootstepEventIndexes;
		}

		if (this.EventSounds != null && this.EventSounds.Length <= 0)
		{
			delete this.EventSounds;
		}

		if (this.EventIndexes != null && this.EventIndexes.Length <= 0)
		{
			delete this.EventIndexes;
		}

		if (this.ProxyWeaponClassNames != null && this.ProxyWeaponClassNames.Length <= 0)
		{
			delete this.ProxyWeaponClassNames;
		}

		if (this.ProxyWeaponStats != null && this.ProxyWeaponStats.Length <= 0)
		{
			delete this.ProxyWeaponStats;
		}

		if (this.ProxyDeathAnimations != null && this.ProxyDeathAnimations.Length <= 0)
		{
			delete this.ProxyDeathAnimations;
		}

		if (this.DeathMessagesArray != null && this.DeathMessagesArray.Length <= 0)
		{
			delete this.DeathMessagesArray;
		}

		if (this.PvESpawnMessagesArray != null && this.PvESpawnMessagesArray.Length <= 0)
		{
			delete this.PvESpawnMessagesArray;
		}
	}

	void Destroy()
	{
		this.DeathCamData.Destroy();
		// Sounds
		this.LocalDeathCamSounds.Destroy();
		this.ClientDeathCamSounds.Destroy();
		this.GlobalDeathCamSounds.Destroy();
		this.ScareSounds.Destroy();
		this.SightSounds.Destroy();
		this.IntroSounds.Destroy();
		this.SpawnLocalSounds.Destroy();
		this.MusicSoundsNormal.Destroy();
		this.MusicSoundsHard.Destroy();
		this.MusicSoundsInsane.Destroy();
		this.MusicSoundsNightmare.Destroy();
		this.MusicSoundsApollyon.Destroy();
		this.ProxySpawnSounds.Destroy();
		this.ProxyIdleSounds.Destroy();
		this.ProxyHurtSounds.Destroy();
		this.ProxyDeathSounds.Destroy();
		this.PlayerDeathCamOverlaySounds.Destroy();
		this.OutroMusics.Destroy();
		this.AnimationData.Destroy();

		if (this.CompanionsArray != null)
		{
			SF2BossProfileCompanionsInfo companions;

			for (int i = 0; i < this.CompanionsArray.Length; i++)
			{
				this.CompanionsArray.GetArray(i, companions, sizeof(companions));
				companions.Destroy();
			}
			delete this.CompanionsArray;
		}

		if (this.EffectsArray != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.EffectsArray.Length; i++)
			{
				this.EffectsArray.GetArray(i, effects, sizeof(effects));
				effects.Destroy();
			}
			delete this.EffectsArray;
		}

		if (this.SpawnEffects != null)
		{
			StringMapSnapshot snapshot = this.SpawnEffects.Snapshot();
			SF2BossProfileBaseEffectInfo effects;
			ArrayList arrayEffects;

			char effectSection[128];
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, effectSection, sizeof(effectSection));
				this.SpawnEffects.GetValue(effectSection, arrayEffects);
				for (int i2 = 0; i2 < arrayEffects.Length; i2++)
				{
					arrayEffects.GetArray(i2, effects, sizeof(effects));
					effects.Destroy();
				}
				delete arrayEffects;
			}

			delete snapshot;
			delete this.SpawnEffects;
		}

		if (this.DespawnEffects != null)
		{
			StringMapSnapshot snapshot = this.DespawnEffects.Snapshot();
			SF2BossProfileBaseEffectInfo effects;
			ArrayList arrayEffects;

			char effectSection[128];
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, effectSection, sizeof(effectSection));
				this.DespawnEffects.GetValue(effectSection, arrayEffects);
				for (int i2 = 0; i2 < arrayEffects.Length; i2++)
				{
					arrayEffects.GetArray(i2, effects, sizeof(effects));
					effects.Destroy();
				}
				delete arrayEffects;
			}

			delete snapshot;
			delete this.DespawnEffects;
		}

		if (this.Models != null)
		{
			delete this.Models;
		}

		if (this.Names != null)
		{
			delete this.Names;
		}

		if (this.DeathMessagesArray != null)
		{
			delete this.DeathMessagesArray;
		}

		if (this.PvESpawnMessagesArray != null)
		{
			delete this.PvESpawnMessagesArray;
		}

		if (this.ProxyWeaponClassNames != null)
		{
			delete this.ProxyWeaponClassNames;
		}

		if (this.ProxyWeaponStats != null)
		{
			delete this.ProxyWeaponStats;
		}

		if (this.ProxyDeathAnimations != null)
		{
			delete this.ProxyDeathAnimations;
		}

		if (this.FootstepEventSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.FootstepEventSounds.Length; i++)
			{
				this.FootstepEventSounds.GetArray(i, soundInfo, sizeof(soundInfo));
				soundInfo.Destroy();
			}
			delete this.FootstepEventSounds;
		}

		if (this.FootstepEventIndexes != null)
		{
			delete this.FootstepEventIndexes;
		}

		if (this.EventSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.EventSounds.Length; i++)
			{
				this.EventSounds.GetArray(i, soundInfo, sizeof(soundInfo));
				soundInfo.Destroy();
			}
			delete this.EventSounds;
		}

		if (this.EventIndexes != null)
		{
			delete this.EventIndexes;
		}

		for (int i = 0; i < 10; i++)
		{
			if (this.ProxyModels[i] != null)
			{
				delete this.ProxyModels[i];
			}
			if (this.ProxyModelsHard[i] != null)
			{
				delete this.ProxyModelsHard[i];
			}
			if (this.ProxyModelsInsane[i] != null)
			{
				delete this.ProxyModelsInsane[i];
			}
			if (this.ProxyModelsNightmare[i] != null)
			{
				delete this.ProxyModelsNightmare[i];
			}
			if (this.ProxyModelsApollyon[i] != null)
			{
				delete this.ProxyModelsApollyon[i];
			}
		}
	}

	void SortSoundSections(KeyValues kv, const char[] sectionName, bool checkFile)
	{
		if (strcmp(sectionName, "sound_player_deathcam_local") == 0)
		{
			this.LocalDeathCamSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_player_deathcam") == 0)
		{
			this.ClientDeathCamSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_player_deathcam_all") == 0)
		{
			this.GlobalDeathCamSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_scare_player") == 0)
		{
			this.ScareSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music") == 0)
		{
			this.MusicSoundsNormal.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music_hard") == 0)
		{
			this.MusicSoundsHard.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music_insane") == 0)
		{
			this.MusicSoundsInsane.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music_nightmare") == 0)
		{
			this.MusicSoundsNightmare.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music_apollyon") == 0)
		{
			this.MusicSoundsApollyon.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_spawn_all") == 0)
		{
			this.IntroSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_spawn_local") == 0)
		{
			this.SpawnLocalSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_player_deathcam_overlay") == 0)
		{
			this.PlayerDeathCamOverlaySounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_proxy_spawn") == 0)
		{
			this.ProxySpawnSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_proxy_idle") == 0)
		{
			this.ProxyIdleSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_proxy_hurt") == 0)
		{
			this.ProxyHurtSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_proxy_death") == 0)
		{
			this.ProxyDeathSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_music_outro") == 0)
		{
			this.OutroMusics.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_sight") == 0)
		{
			this.SightSounds.Load(kv, checkFile);
		}
	}
}

#include <sf2/profiles/profiles_chaser>
#include <sf2/profiles/profiles_statue>
