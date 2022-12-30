#include <sdktools_sound>

// ======================================
// FUNCTIONS
// ======================================

stock void PrecacheSound2(const char[] path, bool checkFile)
{
	PrecacheSound(path, true);
	char buffer[PLATFORM_MAX_PATH];
	FormatEx(buffer, sizeof(buffer), "sound/%s", path);
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
stock void TryPrecacheBossProfileSoundPath(const char[] soundPath, bool disableWarning = false, bool checkFile)
{
	if (soundPath[0] == '\0')
	{
		return;
	}

	char fullPath[PLATFORM_MAX_PATH];
	FormatEx(fullPath, sizeof(fullPath), "sound/%s", soundPath);

	if (checkFile)
	{
		if (FileExists(fullPath, false) || FileExists(fullPath, true))
		{
			PrecacheSound2(soundPath, checkFile);
		}
		else
		{
			if (!disableWarning)
			{
				PrintToServer("[SF2] Sound file %s does not exist, excluding from downloads!", fullPath);
			}
			PrecacheSound(soundPath);
		}
	}
	else
	{
		PrecacheSound2(soundPath, checkFile);
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
stock void PrecacheModel2(const char[] path, bool phy = true, bool xbox = false, bool checkFile)
{
	if (path[0] == '\0')
	{
		return;
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
	if (!IsModelPrecached(buffer))
	{
		PrecacheModel(buffer);
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
	}
}

stock void SetProfileDifficultyStringArrayValues(KeyValues kv, const char[] baseKeyName, ArrayList array, bool models = false)
{
	char key[64];
	char temporaryKeys[PLATFORM_MAX_PATH];

	for (int i = 0; i < Difficulty_Max; i++)
	{
		GetProfileKeyWithDifficultySuffix(baseKeyName, i == 0 ? 1 : i, key, sizeof(key));
		char[] value = new char[PLATFORM_MAX_PATH];
		kv.GetString(key, value, PLATFORM_MAX_PATH, temporaryKeys);
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
	int dr=255,
	int dg=255,
	int db=255,
	int da=255)
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
	}
}

// ======================================
// ENUM STRUCTS
// ======================================

enum struct SF2BossProfileSoundInfo
{
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

		this.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	}

	void Load(KeyValues kv, bool checkFile)
	{
		if (kv.JumpToKey("paths"))
		{
			char soundPath[PLATFORM_MAX_PATH], section[64];
			for (int i = 1;; i++)
			{
				FormatEx(section, sizeof(section), "%d", i);
				kv.GetString(section, soundPath, sizeof(soundPath));
				if (soundPath[0] == '\0')
				{
					break;
				}

				TryPrecacheBossProfileSoundPath(soundPath, _, checkFile);

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

	void EmitSound(bool toClient = false, int entity = -1, int emitter = SOUND_FROM_PLAYER, float origin[3] = NULL_VECTOR, int addPitch = 0)
	{
		if (this.Paths == null || this.Paths.Length <= 0)
		{
			return;
		}
		char buffer[PLATFORM_MAX_PATH];
		this.Paths.GetString(GetRandomInt(0, this.Paths.Length - 1), buffer, sizeof(buffer));
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
	EffectType_Sprite
};

enum struct SF2BossProfileBaseEffectInfo
{
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

	char SpriteName[PLATFORM_MAX_PATH];
	float SpriteScale;

	void Init()
	{
		this.Event = EffectEvent_Invalid;
		this.Type = EffectType_Invalid;
		for (int i = 0; i < 3; i++)
		{
			this.Origin[i] = 0.0;
			this.Angles[i] = 0.0;
		}
		this.RenderModes = RENDER_NORMAL;
		this.RenderEffects = RENDERFX_NONE;
		this.SpawnFlags = 0;
		this.FadeAlpha = 255;
		this.EntRef = INVALID_ENT_REFERENCE;
		this.LifeTime = -1.0;
		this.Colors = null;
		this.DifficultyIndexes = 123456;

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

		this.SpriteName[0] = '\0';
		this.SpriteScale = 1.0;
	}

	void Load(KeyValues kv)
	{
		char effectTypeString[64];
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
		if (strcmp(effectTypeString, "dynamiclight", false) == 0)
		{
			this.Type = EffectType_DynamicLight;
			this.LightBrightness = kv.GetNum("brightness", this.LightBrightness);
			this.LightMaxDistance = kv.GetFloat("distance", this.LightMaxDistance);
			this.LightCone = kv.GetNum("cone", this.LightCone);
			this.LightStyle = kv.GetNum("lightstyle", this.LightStyle);

			this.SetupColors(kv);
		}
		if (strcmp(effectTypeString, "particle", false) == 0)
		{
			this.Type = EffectType_Particle;
			kv.GetString("particlename", this.ParticleName, sizeof(this.ParticleName), this.ParticleName);
		}
		if (strcmp(effectTypeString, "trail", false) == 0)
		{
			this.Type = EffectType_Trail;
			this.TrailTime = kv.GetFloat("trailtime", this.TrailTime);
			this.TrailStartWidth = kv.GetFloat("startwidth", this.TrailStartWidth);
			this.TrailEndWidth = kv.GetFloat("endwidth", this.TrailEndWidth);
			kv.GetString("spritename", this.TrailName, sizeof(this.TrailName), this.TrailName);

			this.SetupColors(kv);
		}
		if (strcmp(effectTypeString, "propdynamic", false) == 0)
		{
			this.Type = EffectType_PropDynamic;
			kv.GetString("modelname", this.ModelName, sizeof(this.ModelName), this.ModelName);
			this.ModelScale = kv.GetFloat("modelscale", this.ModelScale);
			this.ModelSkin = kv.GetNum("modelskin", this.ModelSkin);
			kv.GetString("modelanimation", this.ModelAnimation, sizeof(this.ModelAnimation), this.ModelAnimation);

			this.SetupColors(kv);
		}
		if (strcmp(effectTypeString, "pointspotlight", false) == 0)
		{
			this.Type = EffectType_PointSpotlight;
			this.RenderModes = RENDER_TRANSTEXTURE;
			this.SpotlightWidth = kv.GetFloat("spotlightwidth", this.SpotlightWidth);
			this.SpotlightLength = kv.GetFloat("spotlightlength", this.SpotlightLength);

			this.SetupColors(kv);
		}
		if (strcmp(effectTypeString, "sprite", false) == 0)
		{
			this.Type = EffectType_Sprite;
			kv.GetString("spritename", this.SpriteName, sizeof(this.SpriteName), this.SpriteName);
			this.SpriteScale = kv.GetFloat("spritescale", this.SpriteScale);

			this.SetupColors(kv);
		}

		kv.GetString("event", effectTypeString, sizeof(effectTypeString));
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
		this.Attachment = view_as<bool>(kv.GetNum("attach_point", this.Attachment));
		kv.GetString("attachment_point", this.AttachmentName, sizeof(this.AttachmentName), this.AttachmentName);
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

	void Destroy()
	{
		if (this.Colors != null)
		{
			delete this.Colors;
		}
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
			this.Weight[difficulty] = difficulty > 0 ? this.Weight[difficulty - 1] : 1.0;
		}
		this.Bosses = new ArrayList(ByteCountToCells(SF2_MAX_PROFILE_NAME_LENGTH));
	}

	void Load(KeyValues kv)
	{
		char compProfile[SF2_MAX_PROFILE_NAME_LENGTH], num[32];
		kv.JumpToKey("bosses");
		for (int i = 1;;i++)
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
	char SectionName[64];

	void Init(char optionalSectionName[64] = "")
	{
		this.Sequences = new ArrayList(ByteCountToCells(64));
		this.Sequences.Resize(Difficulty_Max);
		if (optionalSectionName[0] != '\0')
		{
			this.SectionName[0] = '\0';
		}
		else
		{
			this.SectionName = optionalSectionName;
		}

		for (int i = 0; i < Difficulty_Max; i++)
		{
			if (strcmp(optionalSectionName, "stun") == 0)
			{
				this.Duration[i] = this.Duration[i] = i > 0 ? this.Duration[i - 1] : 3.5;
			}
			else
			{
				this.Duration[i] = this.Duration[i] = i > 0 ? this.Duration[i - 1] : 0.0;
			}
			this.Playbackrate[i] = this.Playbackrate[i] = i > 0 ? this.Playbackrate[i - 1] : 1.0;
			this.Cycle[i] = this.Cycle[i] = i > 0 ? this.Cycle[i - 1] : 0.0;
			this.FootstepInterval[i] = this.FootstepInterval[i] = i > 0 ? this.FootstepInterval[i - 1] : 0.0;
		}
	}

	void Load(KeyValues kv)
	{
		char animNames[Difficulty_Max][64];

		GetProfileDifficultyStringValues(kv, "name", animNames, sizeof(animNames[]), animNames);
		GetProfileDifficultyFloatValues(kv, "playbackrate", this.Playbackrate, this.Playbackrate);
		GetProfileDifficultyFloatValues(kv, "duration", this.Duration, this.Duration);
		GetProfileDifficultyFloatValues(kv, "cycle", this.Cycle, this.Cycle);
		GetProfileDifficultyFloatValues(kv, "footstepinterval", this.FootstepInterval, this.FootstepInterval);

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

	void Init()
	{
		this.Animations = new StringMap();
		this.Gestures = new StringMap();
	}

	void Load(KeyValues kv)
	{
		if (kv.JumpToKey("animations"))
		{
			char animType[64];
			SF2BossProfileAnimationSectionNameData animData;
			SF2BossProfileAttackGestureData gestureData;

			if (kv.GotoFirstSubKey()) // Find the animation name
			{
				do
				{
					kv.GetSectionName(animType, sizeof(animType));
					if (strcmp(animType, "attack") == 0)
					{
						ArrayList gestureDataArray = new ArrayList(sizeof(gestureData));

						if (kv.GotoFirstSubKey())
						{
							do
							{
								gestureData.Init();
								gestureData.Load(kv);
								gestureDataArray.PushArray(gestureData);
							}
							while (kv.GotoNextKey());

							kv.GoBack();
						}
						this.Gestures.SetValue(animType, gestureDataArray);
					}

					ArrayList animDataArray = new ArrayList(sizeof(animData));
					bool doResize = false;
					if (strcmp(animType, "shoot") == 0)
					{
						doResize = true;
						animDataArray.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
						for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
						{
							SF2BossProfileAnimationSectionNameData tempData;
							animDataArray.SetArray(i, tempData, sizeof(tempData));
						}
					}

					if (kv.GotoFirstSubKey()) // Find the indexes
					{
						do
						{
							char animType2[64];
							kv.GetSectionName(animType2, sizeof(animType2));
							animData.Init(animType);
							animData.Load(kv);
							if (!doResize)
							{
								animDataArray.PushArray(animData);
							}
							else
							{
								int index = StringToInt(animType2);
								if (index > -1)
								{
									animDataArray.SetArray(index - 1, animData, sizeof(animData));
								}
							}
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
	}

	void Destroy()
	{
		StringMapSnapshot snapshot = this.Animations.Snapshot();
		StringMapSnapshot gestureSnapshot = this.Gestures.Snapshot();

		char animType[64];
		ArrayList animDataArray;
		SF2BossProfileAnimationSectionNameData animData;
		SF2BossProfileAttackGestureData gestureData;

		for (int i = 0; i < snapshot.Length; i++)
		{
			snapshot.GetKey(i, animType, sizeof(animType));
			this.Animations.GetValue(animType, animDataArray);

			for (int j = 0; j < animDataArray.Length; j++)
			{
				animDataArray.GetArray(j, animData, sizeof(animData));
				animData.Destroy();
			}
		}

		for (int i = 0; i < gestureSnapshot.Length; i++)
		{
			gestureSnapshot.GetKey(i, animType, sizeof(animType));
			this.Gestures.GetValue(animType, animDataArray);

			for (int j = 0; j < animDataArray.Length; j++)
			{
				animDataArray.GetArray(j, gestureData, sizeof(gestureData));
				gestureData.Destroy();
			}
		}

		if (animDataArray != null)
		{
			delete animDataArray;
		}

		delete snapshot;
		delete this.Animations;
		delete this.Gestures;
	}

	bool GetAnimation(const char[] animType, int difficulty, char[] buffer, int bufferLen, float &rate = 1.0, float &duration = 0.0, float &cycle = 0.0, float &footstepinterval = 0.0, int &index = 0, int preDefinedIndex = -1)
	{
		ArrayList animDataArray;

		if (this.Animations.GetValue(animType, animDataArray))
		{
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
			SF2BossProfileAnimationSectionNameData animData;
			animDataArray.GetArray(randomAnimation, animData, sizeof(animData));

			animData.GetSequence(difficulty, buffer, bufferLen);
			rate = animData.Playbackrate[difficulty];
			duration = animData.Duration[difficulty];
			cycle = animData.Cycle[difficulty];
			footstepinterval = animData.FootstepInterval[difficulty];
			index = randomAnimation;

			return true;
		}

		return false;
	}

	bool GetGesture(int definedIndex, const char[] animType, int difficulty, char[] buffer, int bufferLen, float &rate = 1.0, float &cycle = 0.0)
	{
		ArrayList gestureDataArray;

		if (this.Gestures.GetValue(animType, gestureDataArray))
		{
			SF2BossProfileAttackGestureData gestureData;
			gestureDataArray.GetArray(definedIndex, gestureData, sizeof(gestureData));

			gestureData.GetGesture(difficulty, buffer, bufferLen);
			rate = gestureData.Playbackrate[difficulty];
			cycle = gestureData.Cycle[difficulty];

			return true;
		}

		return false;
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

	bool EnableSpawnParticles;
	char SpawnParticle[PLATFORM_MAX_PATH];
	char SpawnParticleSound[PLATFORM_MAX_PATH];
	float SpawnParticleSoundVolume;
	int SpawnParticleSoundPitch;
	float SpawnParticleOrigin[3];

	bool EnableDespawnParticles;
	char DespawnParticle[PLATFORM_MAX_PATH];
	char DespawnParticleSound[PLATFORM_MAX_PATH];
	float DespawnParticleSoundVolume;
	int DespawnParticleSoundPitch;

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

	int Copies[Difficulty_Max];

	float RunSpeed[Difficulty_Max];
	float MaxRunSpeed[Difficulty_Max];
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
	int ScareReplenishSprintAmount;

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
	float TeleportCopyDistance;

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
	bool ProxyDifficultyModels;
	ArrayList ProxyModels[10];
	ArrayList ProxyModelsHard[10];
	ArrayList ProxyModelsInsane[10];
	ArrayList ProxyModelsNightmare[10];
	ArrayList ProxyModelsApollyon[10];

	bool FakeCopies;

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

	char CloakOnSound[PLATFORM_MAX_PATH];
	char CloakOffSound[PLATFORM_MAX_PATH];
	char JarateHitSound[PLATFORM_MAX_PATH];
	char MilkHitSound[PLATFORM_MAX_PATH];
	char GasHitSound[PLATFORM_MAX_PATH];
	char StunHitSound[PLATFORM_MAX_PATH];
	char FireballExplodeSound[PLATFORM_MAX_PATH];
	char FireballShootSound[PLATFORM_MAX_PATH];
	char FireballTrail[PLATFORM_MAX_PATH];
	char RocketTrail[PLATFORM_MAX_PATH];
	char RocketExplodeParticle[PLATFORM_MAX_PATH];
	char IceballSlowSound[PLATFORM_MAX_PATH];
	char IceballTrail[PLATFORM_MAX_PATH];
	char RocketExplodeSound[PLATFORM_MAX_PATH];
	char RocketShootSound[PLATFORM_MAX_PATH];
	char GrenadeShootSound[PLATFORM_MAX_PATH];
	char SentryRocketShootSound[PLATFORM_MAX_PATH];
	char ArrowShootSound[PLATFORM_MAX_PATH];
	char ManglerShootSound[PLATFORM_MAX_PATH];
	char BaseballShootSound[PLATFORM_MAX_PATH];
	char EngineSound[PLATFORM_MAX_PATH];
	int EngineSoundLevel;
	float EngineSoundVolume;
	char SpawnEffectSound[PLATFORM_MAX_PATH];
	char DespawnEffectSound[PLATFORM_MAX_PATH];
	char SmiteHitSound[PLATFORM_MAX_PATH];
	char RocketModel[PLATFORM_MAX_PATH];

	char TrapModel[PLATFORM_MAX_PATH];
	char TrapDeploySound[PLATFORM_MAX_PATH];
	char TrapMissSound[PLATFORM_MAX_PATH];
	char TrapCatchSound[PLATFORM_MAX_PATH];
	char TrapAnimIdle[PLATFORM_MAX_PATH];
	char TrapAnimClose[PLATFORM_MAX_PATH];
	char TrapAnimOpen[PLATFORM_MAX_PATH];

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

	SF2BossProfileAttributesInfo AttributesInfo;

	SF2BossProfileMasterAnimationsData AnimationData;

	ArrayList EffectsArray;

	void Init()
	{
		this.Models = null;
		this.Names = null;
		this.Type = SF2BossType_Unknown;
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

		this.EnableSpawnParticles = false;
		this.SpawnParticle[0] = '\0';
		this.SpawnParticleSound[0] = '\0';
		this.SpawnParticleSoundVolume = 1.0;
		this.SpawnParticleSoundPitch = 100;

		this.EnableDespawnParticles = false;
		this.DespawnParticle[0] = '\0';
		this.DespawnParticleSound[0] = '\0';
		this.DespawnParticleSoundVolume = 1.0;
		this.DespawnParticleSoundPitch = 100;

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
		this.ScareReplenishSprintAmount = 0;

		this.StaticScareAmount = 0.0;

		this.TeleportType = 0;
		this.TeleportIgnoreChases = false;
		this.TeleportIgnoreVis = false;
		this.TeleportCopyDistance = 800.0;

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
		this.ProxyDifficultyModels = false;

		this.FakeCopies = false;

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

		this.CloakOnSound = DEFAULT_CLOAKONSOUND;
		this.CloakOffSound = DEFAULT_CLOAKOFFSOUND;
		this.JarateHitSound = JARATE_HITPLAYER;
		this.MilkHitSound = JARATE_HITPLAYER;
		this.GasHitSound = JARATE_HITPLAYER;
		this.StunHitSound = STUN_HITPLAYER;
		this.FireballExplodeSound = FIREBALL_IMPACT;
		this.FireballShootSound = FIREBALL_SHOOT;
		this.FireballTrail = FIREBALL_TRAIL;
		this.RocketTrail = ROCKET_TRAIL;
		this.RocketExplodeParticle = ROCKET_EXPLODE_PARTICLE;
		this.IceballSlowSound = ICEBALL_IMPACT;
		this.IceballTrail = ICEBALL_TRAIL;
		this.RocketExplodeSound = ROCKET_IMPACT;
		this.RocketShootSound = ROCKET_SHOOT;
		this.GrenadeShootSound = GRENADE_SHOOT;
		this.SentryRocketShootSound = SENTRYROCKET_SHOOT;
		this.ArrowShootSound = ARROW_SHOOT;
		this.ManglerShootSound = MANGLER_SHOOT;
		this.BaseballShootSound = BASEBALL_SHOOT;
		this.EngineSound[0] = '\0';
		this.EngineSoundLevel = 83;
		this.EngineSoundVolume = 0.8;
		this.SpawnEffectSound[0] = '\0';
		this.DespawnEffectSound[0] = '\0';
		this.SmiteHitSound = SOUND_THUNDER;
		this.RocketModel = ROCKET_MODEL;

		this.TrapModel = TRAP_MODEL;
		this.TrapDeploySound = TRAP_DEPLOY;
		this.TrapMissSound = TRAP_CLOSE;
		this.TrapCatchSound = TRAP_CLOSE;
		this.TrapAnimIdle = "trapopenend";
		this.TrapAnimClose = "trapclosed";
		this.TrapAnimOpen[0] = '\0';

		this.LocalDeathCamSounds.Init();
		this.ClientDeathCamSounds.Init();
		this.GlobalDeathCamSounds.Init();
		this.ScareSounds.Init();
		this.ScareSounds.Channel = MUSIC_CHAN;
		this.ScareSounds.Level = SNDLEVEL_NONE;
		this.SightSounds.Init();
		this.SightSounds.CooldownMin = 8.0;
		this.SightSounds.CooldownMax = 14.0;
		this.SightSounds.Channel = MUSIC_CHAN;
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

		this.AttributesInfo.Init();

		this.AnimationData.Init(); // Save this here whenever I do statue boss animations

		this.EffectsArray = null;

		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Skin[difficulty] = difficulty > 0 ? this.Skin[difficulty - 1] : 0;
			this.Body[difficulty] = difficulty > 0 ? this.Body[difficulty - 1] : 0;

			this.SoundMusicLoop[difficulty] = difficulty > 0 ? this.SoundMusicLoop[difficulty - 1] : 0.0;

			this.Copies[difficulty] = difficulty > 0 ? this.Copies[difficulty - 1] : 1;

			this.RunSpeed[difficulty] = difficulty > 0 ? this.RunSpeed[difficulty - 1] : 150.0;
			this.MaxRunSpeed[difficulty] = difficulty > 0 ? this.MaxRunSpeed[difficulty - 1] : 150.0;
			this.Acceleration[difficulty] = difficulty > 0 ? this.Acceleration[difficulty - 1] : 4000.0;

			this.IdleLifeTime[difficulty] = difficulty > 0 ? this.IdleLifeTime[difficulty - 1] : 10.0;

			this.SearchRange[difficulty] = difficulty > 0 ? this.SearchRange[difficulty - 1] : 1024.0;
			this.SearchSoundRange[difficulty] = difficulty > 0 ? this.SearchSoundRange[difficulty - 1] : 1024.0;
			this.TauntAlertRange[difficulty] = difficulty > 0 ? this.TauntAlertRange[difficulty - 1] : 512.0;

			this.InstantKillCooldown[difficulty] = difficulty > 0 ? this.InstantKillCooldown[difficulty - 1] : 0.0;

			this.StaticRadius[difficulty] = difficulty > 0 ? this.StaticRadius[difficulty - 1] : 0.0;
			this.StaticRate[difficulty] = difficulty > 0 ? this.StaticRate[difficulty - 1] : 0.0;
			this.StaticRateDecay[difficulty] = difficulty > 0 ? this.StaticRateDecay[difficulty - 1] : 0.0;
			this.StaticGraceTime[difficulty] = difficulty > 0 ? this.StaticGraceTime[difficulty - 1] : 1.0;

			this.TeleportAllowed[difficulty] = difficulty > 0 ? this.TeleportAllowed[difficulty - 1] : true;
			this.TeleportRangeMin[difficulty] = difficulty > 0 ? this.TeleportRangeMin[difficulty - 1] : 325.0;
			this.TeleportRangeMax[difficulty] = difficulty > 0 ? this.TeleportRangeMax[difficulty - 1] : 1024.0;
			this.TeleportTimeMin[difficulty] = difficulty > 0 ? this.TeleportTimeMin[difficulty - 1] : 5.0;
			this.TeleportTimeMax[difficulty] = difficulty > 0 ? this.TeleportTimeMax[difficulty - 1] : 9.0;
			this.TeleportRestPeriod[difficulty] = difficulty > 0 ? this.TeleportRestPeriod[difficulty - 1] : 15.0;
			this.TeleportStressMin[difficulty] = difficulty > 0 ? this.TeleportStressMin[difficulty - 1] : 0.2;
			this.TeleportStressMax[difficulty] = difficulty > 0 ? this.TeleportStressMax[difficulty - 1] : 0.9;
			this.TeleportPersistencyPeriod[difficulty] = difficulty > 0 ? this.TeleportPersistencyPeriod[difficulty - 1] : 13.0;

			this.JumpscareDistance[difficulty] = difficulty > 0 ? this.JumpscareDistance[difficulty - 1] : 0.0;
			this.JumpscareDuration[difficulty] = difficulty > 0 ? this.JumpscareDuration[difficulty - 1] : 0.0;
			this.JumpscareCooldown[difficulty] = difficulty > 0 ? this.JumpscareCooldown[difficulty - 1] : 0.0;

			this.ProxyDamageVsEnemy[difficulty] = difficulty > 0 ? this.ProxyDamageVsEnemy[difficulty - 1] : 1.0;
			this.ProxyDamageVsBackstab[difficulty] = difficulty > 0 ? this.ProxyDamageVsBackstab[difficulty - 1] : 0.25;
			this.ProxyDamageVsSelf[difficulty] = difficulty > 0 ? this.ProxyDamageVsSelf[difficulty - 1] : 1.0;
			this.ProxyControlGainHitEnemy[difficulty] = difficulty > 0 ? this.ProxyControlGainHitEnemy[difficulty - 1] : 0;
			this.ProxyControlGainHitByEnemy[difficulty] = difficulty > 0 ? this.ProxyControlGainHitByEnemy[difficulty - 1] : 0;
			this.ProxyControlDrainRate[difficulty] = difficulty > 0 ? this.ProxyControlDrainRate[difficulty - 1] : 0.0;
			this.MaxProxies[difficulty] = difficulty > 0 ? this.MaxProxies[difficulty - 1] : 0;
			this.ProxySpawnChanceMin[difficulty] = difficulty > 0 ? this.ProxySpawnChanceMin[difficulty - 1] : 0.0;
			this.ProxySpawnChaceMax[difficulty] = difficulty > 0 ? this.ProxySpawnChaceMax[difficulty - 1] : 0.0;
			this.ProxySpawnChanceThreshold[difficulty] = difficulty > 0 ? this.ProxySpawnChanceThreshold[difficulty - 1] : 0.0;
			this.ProxySpawnNumMin[difficulty] = difficulty > 0 ? this.ProxySpawnNumMin[difficulty - 1] : 0;
			this.ProxySpawnNumMax[difficulty] = difficulty > 0 ? this.ProxySpawnNumMax[difficulty - 1] : 0;
			this.ProxySpawnCooldownMin[difficulty] = difficulty > 0 ? this.ProxySpawnCooldownMin[difficulty - 1] : 0.0;
			this.ProxySpawnCooldownMax[difficulty] = difficulty > 0 ? this.ProxySpawnCooldownMax[difficulty - 1] : 0.0;
			this.ProxyTeleportRangeMin[difficulty] = difficulty > 0 ? this.ProxyTeleportRangeMin[difficulty - 1] : 500.0;
			this.ProxyTeleportRangeMax[difficulty] = difficulty > 0 ? this.ProxyTeleportRangeMax[difficulty - 1] : 3200.0;

			this.DrainCreditAmount[difficulty] = difficulty > 0 ? this.DrainCreditAmount[difficulty - 1] : 50;
		}

		for (int i = 0; i < 3; i++)
		{
			this.Mins[i] = 0.0;
			this.Maxs[i] = 0.0;

			this.DiscoPos[i] = 0.0;

			this.FestiveLightPos[i] = 0.0;
			this.FestiveLightAng[i] = 0.0;

			this.SpawnParticleOrigin[i] = 0.0;

			this.DeathCamPos[i] = 0.0;

			this.PushRagdollForce[i] = 0.0;

			this.EyePosOffset[i] = 0.0;
			this.EyeAngOffset[i] = 0.0;
		}
	}

	void PostLoad()
	{
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
	}

	void Destroy()
	{
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