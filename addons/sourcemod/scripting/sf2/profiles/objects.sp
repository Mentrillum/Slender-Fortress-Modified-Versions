#pragma semicolon 1
#pragma newdecls required

methodmap ProfileObject < KeyMap
{
	property KeyMap Super
	{
		public get()
		{
			return view_as<KeyMap>(this);
		}
	}

	public bool ContainsDifficultyKey(const char[] key, int difficulty)
	{
		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		return this.ContainsKey(diffKey);
	}

	public bool ContainsAnyKey(ArrayList keys)
	{
		if (keys == null)
		{
			return false;
		}
		for (int i = 0; i < keys.Length; i++)
		{
			char key[256];
			keys.GetString(i, key, sizeof(key));
			if (this.ContainsKey(key))
			{
				return true;
			}
		}
		return false;
	}

	public bool ContainsAnyDifficultyKey(ArrayList keys, int specified = -1)
	{
		if (keys == null)
		{
			return false;
		}
		if (specified == -1)
		{
			for (int i = 0; i < keys.Length; i++)
			{
				char key[256];
				keys.GetString(i, key, sizeof(key));
				for (int i2 = 0; i2 < Difficulty_Max; i2++)
				{
					if (this.ContainsDifficultyKey(key, i2))
					{
						return true;
					}
				}
			}
		}
		else
		{
			for (int i = 0; i < keys.Length; i++)
			{
				char key[256];
				keys.GetString(i, key, sizeof(key));
				if (this.ContainsDifficultyKey(key, specified))
				{
					return true;
				}
			}
		}
		return false;
	}

	public void RemoveDifficultyKey(const char[] key, int difficulty)
	{
		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.RemoveKey(diffKey);
	}

	public ProfileObject GetSection(const char[] key, ProfileObject def = null)
	{
		if (this == null)
		{
			return def;
		}

		ProfileObject obj = view_as<ProfileObject>(this.Super.GetSection(key));
		if (obj == null)
		{
			return def;
		}

		return obj;
	}

	public bool GetRandomValues(const char[] key, float buffer[2])
	{
		if (!this.ContainsKey(key))
		{
			return false;
		}

		char string[64];
		if (!view_as<StringMap>(this).GetString(key, string, sizeof(string)))
		{
			return false;
		}

		int contains = StrContains(string, "<random ", false);
		if (contains == -1)
		{
			return false;
		}

		int index = contains + strlen("<random ");
		char[] val1 = new char[16];
		char[] val2 = new char[16];
		int stringIndex = 0, endIndex = 0;

		for (int i = index; i < sizeof(string); i++)
		{
			endIndex = i;
			if (string[i] == '\0')
			{
				break;
			}

			if (string[i] == ' ')
			{
				break;
			}

			if (string[i] != '.' && string[i] != '0' && string[i] != '1' && string[i] != '2' && string[i] != '3' &&
				string[i] != '4' && string[i] != '5' && string[i] != '6' && string[i] != '7' && string[i] != '8' && string[i] != '9')
			{
				continue;
			}

			val1[stringIndex] = string[i];
			stringIndex++;
		}

		stringIndex = 0;

		for (int i = endIndex + 1; i < sizeof(string); i++)
		{
			if (string[i] == '\0')
			{
				break;
			}

			if (string[i] == ' ')
			{
				break;
			}

			if (string[i] != '.' && string[i] != '0' && string[i] != '1' && string[i] != '2' && string[i] != '3' &&
				string[i] != '4' && string[i] != '5' && string[i] != '6' && string[i] != '7' && string[i] != '8' && string[i] != '9')
			{
				continue;
			}

			val2[stringIndex] = string[i];
			stringIndex++;
		}

		buffer[0] = StringToFloat(val1);
		buffer[1] = StringToFloat(val2);

		return true;
	}

	public int GetRandomInt(const char[] key, int def = 0)
	{
		float buffer[2];
		if (!this.GetRandomValues(key, buffer))
		{
			return def;
		}

		int newVal1 = RoundToNearest(buffer[0]);
		int newVal2 = RoundToNearest(buffer[1]);

		return GetRandomInt(newVal1, newVal2);
	}

	public int GetInt(const char[] key, int def = 0)
	{
		if (this == null)
		{
			return def;
		}
		int val = def;
		if (!this.ContainsKey(key))
		{
			return def;
		}
		if ((val = this.GetRandomInt(key, def)) == def)
		{
			val = this.Super.GetInt(key, def);
		}
		return val;
	}

	public void SetInt(const char[] key, int value, bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		this.Super.SetInt(key, value);
	}

	public float GetRandomFloat(const char[] key, float def = 0.0)
	{
		float buffer[2];
		if (!this.GetRandomValues(key, buffer))
		{
			return def;
		}

		float val = GetRandomFloat(buffer[0], buffer[1]);
		return val;
	}

	public float GetFloat(const char[] key, float def = 0.0)
	{
		if (this == null)
		{
			return def;
		}
		float val = def;
		if (!this.ContainsKey(key))
		{
			return def;
		}
		if ((val = this.GetRandomFloat(key, def)) == def)
		{
			val = this.Super.GetFloat(key, def);
		}
		return val;
	}

	public void SetFloat(const char[] key, float value, bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		this.Super.SetFloat(key, value);
	}

	public bool GetBool(const char[] key, bool def = false)
	{
		if (this == null)
		{
			return def;
		}
		bool val = def;
		if (!this.ContainsKey(key))
		{
			return def;
		}
		if ((val = this.GetRandomInt(key, view_as<int>(val)) != 0) == def)
		{
			val = this.Super.GetBool(key, def);
		}
		return val;
	}

	public void SetBool(const char[] key, bool value, bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		this.Super.SetBool(key, value);
	}

	public void GetString(const char[] key, char[] buffer, int bufferSize, const char[] def = "")
	{
		if (this == null)
		{
			strcopy(buffer, bufferSize, def);
			return;
		}

		this.Super.GetString(key, buffer, bufferSize, def);
	}

	public bool SetString(const char[] key, const char[] value, bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		this.Super.SetString(key, value);
	}

	public void GetVector(const char[] key, float buffer[3], const float def[3] = { 0.0, 0.0, 0.0 })
	{
		if (this == null)
		{
			buffer = def;
			return;
		}

		if (!this.ContainsKey(key))
		{
			buffer = def;
			return;
		}

		char vecString[64];
		this.GetString(key, vecString, sizeof(vecString));
		StringToVector(vecString, buffer);
	}

	public void SetVector(const char[] key, float value[3], bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		char vecString[64];
		VectorToString(value, vecString, sizeof(vecString));
		this.SetString(key, vecString);
	}

	public void GetColor(const char[] key, int buffer[4], const int def[4] = { 255, 255, 255, 255 })
	{
		if (this == null)
		{
			buffer = def;
			return;
		}

		if (!this.ContainsKey(key))
		{
			buffer = def;
			return;
		}

		char vecString[64];
		this.GetString(key, vecString, sizeof(vecString));
		StringToColor(vecString, buffer);
	}

	public void SetColor(const char[] key, int value[4], bool check = false)
	{
		if (check && this.ContainsString(key))
		{
			return;
		}
		char vecString[64];
		ColorToString(value, vecString, sizeof(vecString));
		this.SetString(key, vecString);
	}

	public KeyMap_Array GetArray(const char[] key, KeyMap_Array def = view_as<KeyMap_Array>(INVALID_HANDLE))
	{
		if (this.GetType(key) != Key_Type_Section)
		{
			return def;
		}

		KeyMap_Array value = view_as<KeyMap_Array>(this.Super.GetSection(key));
		if (value == null || !value.IsArray)
		{
			return def;
		}

		return value;
	}

	public ProfileObject GetDifficultySection(const char[] key, int difficulty, ProfileObject def = null)
	{
		if (this == null)
		{
			return def;
		}
		ProfileObject value = def;

		if (this.ContainsKey(key))
		{
			value = this.GetSection(key, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			value = this.GetSection(diffKey, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetSection(diffKey, def);
						return value;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetSection(diffKey, def);
						return value;
					}
				}
			}
		}

		return value;
	}

	public void SetDifficultySection(const char[] key, int difficulty, ProfileObject value)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetSection(diffKey, value);
	}

	public int GetDifficultyInt(const char[] key, int difficulty, int def = 0)
	{
		if (this == null)
		{
			return def;
		}
		int value = def;

		if (this.ContainsKey(key))
		{
			value = this.GetInt(key, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			value = this.GetInt(diffKey, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetInt(diffKey, def);
						return value;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetInt(diffKey, def);
						return value;
					}
				}
			}
		}

		return value;
	}

	public void SetDifficultyInt(const char[] key, int difficulty, int value, bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetInt(diffKey, value, check);
	}

	public float GetDifficultyFloat(const char[] key, int difficulty, float def = 0.0)
	{
		if (this == null)
		{
			return def;
		}
		float value = def;

		if (this.ContainsKey(key))
		{
			value = this.GetFloat(key, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			value = this.GetFloat(diffKey, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetFloat(diffKey, def);
						return value;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetFloat(diffKey, def);
						return value;
					}
				}
			}
		}

		return value;
	}

	public void SetDifficultyFloat(const char[] key, int difficulty, float value, bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetFloat(diffKey, value, check);
	}

	public bool GetDifficultyBool(const char[] key, int difficulty, bool def = false)
	{
		if (this == null)
		{
			return def;
		}
		bool value = def;

		if (this.ContainsKey(key))
		{
			value = this.GetBool(key, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			value = this.GetBool(diffKey, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetBool(diffKey, def);
						return value;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						value = this.GetBool(diffKey, def);
						return value;
					}
				}
			}
		}

		return value;
	}

	public void SetDifficultyBool(const char[] key, int difficulty, bool value, bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetBool(diffKey, value, check);
	}

	public void GetDifficultyVector(const char[] key, int difficulty, float buffer[3], const float def[3] = { 0.0, 0.0, 0.0 })
	{
		buffer = def;

		if (this.ContainsKey(key))
		{
			this.GetVector(key, buffer, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			this.GetVector(diffKey, buffer, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetVector(diffKey, buffer, def);
						return;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetVector(diffKey, buffer, def);
						return;
					}
				}
			}
		}
	}

	public void SetDifficultyVector(const char[] key, int difficulty, float value[3], bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetVector(diffKey, value, check);
	}

	public void GetDifficultyColor(const char[] key, int difficulty, int buffer[4], const int def[4] = { 255, 255, 255, 255 })
	{
		buffer = def;

		if (this.ContainsKey(key))
		{
			this.GetColor(key, buffer, def);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			this.GetColor(diffKey, buffer, def);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetColor(diffKey, buffer, def);
						return;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetColor(diffKey, buffer, def);
						return;
					}
				}
			}
		}
	}

	public void SetDifficultyColor(const char[] key, int difficulty, int value[4], bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetColor(diffKey, value, check);
	}

	public void GetDifficultyString(const char[] key, int difficulty, char[] buffer, int bufferSize, const char[] def = "")
	{
		strcopy(buffer, bufferSize, def);

		if (this.ContainsKey(key))
		{
			this.GetString(key, buffer, bufferSize);
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		if (this.ContainsKey(diffKey))
		{
			this.GetString(diffKey, buffer, bufferSize, buffer);
		}
		else
		{
			if (difficulty > 0)
			{
				for (int i2 = difficulty; i2 >= 0; i2--)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetString(diffKey, buffer, bufferSize, buffer);
						return;
					}
				}
			}
			else
			{
				for (int i2 = 0; i2 < difficulty; i2++)
				{
					GetProfileKeyWithDifficultySuffix(key, i2, diffKey, diffKeySize);
					if (this.ContainsKey(diffKey))
					{
						this.GetString(diffKey, buffer, bufferSize, buffer);
						return;
					}
				}
			}
		}
	}

	public void SetDifficultyString(const char[] key, int difficulty, const char[] value, bool check = false)
	{
		if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
		{
			return;
		}

		int diffKeySize = strlen(key) + GetMaxProfileDifficultySuffixSize();
		char[] diffKey = new char[diffKeySize];
		GetProfileKeyWithDifficultySuffix(key, difficulty, diffKey, diffKeySize);
		this.SetString(diffKey, value, check);
	}

	public ProfileObject InsertNewSection(const char[] name)
	{
		if (this.GetSection(name) != null)
		{
			return this.GetSection(name);
		}
		ProfileObject newObj = view_as<ProfileObject>(new KeyMap());
		this.SetType(name, Key_Type_Section);
		this.SetSection(name, newObj);
		newObj.SetSectionName(name);
		newObj.Parent = this;
		this.SetKeyIndex(name, this.SectionLength);
		this.SectionLength++;
		return newObj;
	}

	public void AddExistingSection(ProfileObject newObj)
	{
		if (newObj == null)
		{
			return;
		}
		char sectionName[512];
		newObj.GetSectionName(sectionName, sizeof(sectionName));
		this.SetSection(sectionName, newObj);
		this.SetType(sectionName, Key_Type_Section);
		newObj.Parent = this;
		this.SetKeyIndex(sectionName, this.SectionLength);
		this.SetIndexKey(sectionName, this.SectionLength);
		this.SectionLength++;
	}

	public void TransferKey(ProfileObject origin, const char[] oldKey, const char[] newKey)
	{
		char keyValue[2048];
		if (!origin.Super.Super.GetString(oldKey, keyValue, sizeof(keyValue)))
		{
			return;
		}
		this.SetKeyValue(newKey, keyValue);
	}

	public void TransferDifficultyKey(ProfileObject target, const char[] oldKey, const char[] newKey, int difficulty)
	{
		int oldDiffKeySize = strlen(oldKey) + GetMaxProfileDifficultySuffixSize();
		char[] oldDiffKey = new char[oldDiffKeySize];
		GetProfileKeyWithDifficultySuffix(oldKey, difficulty, oldDiffKey, oldDiffKeySize);

		int newDiffKeySize = strlen(newKey) + GetMaxProfileDifficultySuffixSize();
		char[] newDiffKey = new char[newDiffKeySize];
		GetProfileKeyWithDifficultySuffix(newKey, difficulty, newDiffKey, newDiffKeySize);

		char keyValue[2048];
		if (!this.Super.GetString(oldDiffKey, keyValue, sizeof(keyValue)))
		{
			return;
		}
		target.SetKeyValue(newDiffKey, keyValue);
	}
}

methodmap ProfileSound < ProfileObject
{
	property KeyMap_Array Paths
	{
		public get()
		{
			return this.GetArray("paths");
		}
	}

	public int GetChannel(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("channel", difficulty, this.Super.GetInt("__channel", SNDCHAN_AUTO));
	}

	public float GetVolume(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("volume", difficulty, SNDVOL_NORMAL);
	}

	public int GetFlags(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("flags", difficulty, this.Super.GetInt("__flags", SND_NOFLAGS));
	}

	public int GetLevel(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("level", difficulty, SNDLEVEL_SCREAMING);
	}

	public int GetPitch(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("pitch", difficulty, SNDPITCH_NORMAL);
	}

	public float GetCooldownMin(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("cooldown_min", difficulty, this.Super.GetFloat("__cooldown_min", 1.5));
	}

	public float GetCooldownMax(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("cooldown_max", difficulty, this.Super.GetFloat("__cooldown_max", 1.5));
	}

	public float GetHurtCooldownMin(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("hurt_cooldown_min", difficulty, this.Super.GetFloat("__cooldown_min", 1.5));
	}

	public float GetHurtCooldownMax(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("hurt_cooldown_max", difficulty, this.Super.GetFloat("__cooldown_max", 1.5));
	}

	public int GetPitchRandomMin(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("pitch_random_min", difficulty, this.GetPitch(difficulty));
	}

	public int GetPitchRandomMax(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyInt("pitch_random_max", difficulty, this.GetPitch(difficulty));
	}

	public float GetChance(int difficulty = Difficulty_Normal)
	{
		return this.GetDifficultyFloat("chance", difficulty, 1.0);
	}

	public void SetDefaultChannel(int channel)
	{
		this.SetInt("__channel", channel);
	}

	public void SetDefaultFlags(int flags)
	{
		this.SetInt("__flags", flags);
	}

	public void SetDefaultCooldownMin(float cooldown)
	{
		this.SetFloat("__cooldown_min", cooldown);
	}

	public void SetDefaultCooldownMax(float cooldown)
	{
		this.SetFloat("__cooldown_max", cooldown);
	}

	public void SetDefaultLevel(int level)
	{
		this.SetInt("__level", level);
	}

	public void Precache()
	{
		KeyMap obj = this.GetSection("paths");
		if (obj == null)
		{
			obj = this;
		}
		bool doDelete = this.GetSection("paths") != null;

		KeyMap_Array paths = new KeyMap_Array(Key_Type_Value);
		char path[PLATFORM_MAX_PATH];
		for (int i2 = 1;; i2++)
		{
			char num[16];
			IntToString(i2, num, sizeof(num));
			obj.GetString(num, path, sizeof(path));
			if (path[0] == '\0')
			{
				break;
			}

			TryPrecacheBossProfileSoundPath(path, g_FileCheckConVar.BoolValue);
			paths.PushString(path);
			obj.RemoveKey(num);
		}
		if (doDelete)
		{
			this.RemoveKey("paths");
		}
		this.SetType("paths", Key_Type_Section);
		this.SetSection("paths", paths);
		paths.SetSectionName("paths");
		paths.Parent = this;

		ProfileObject parent = view_as<ProfileObject>(this.Parent);
		char section[64], formatter[90];
		this.GetSectionName(section, sizeof(section));
		for (int i = 0; i < Difficulty_Max; i++)
		{
			FormatEx(formatter, sizeof(formatter), "%s_channel", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyInt("channel", i, parent.GetDifficultyInt(formatter, i, this.Super.GetInt("__channel", SNDCHAN_AUTO)));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_volume", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyFloat("volume", i, parent.GetDifficultyFloat(formatter, i, SNDVOL_NORMAL));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_flags", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyInt("flags", i, parent.GetDifficultyInt(formatter, i, this.Super.GetInt("__flags", SND_NOFLAGS)));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_level", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyInt("level", i, parent.GetDifficultyInt(formatter, i, SNDLEVEL_SCREAMING));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_pitch", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyInt("pitch", i, parent.GetDifficultyInt(formatter, i, SNDPITCH_NORMAL));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_cooldown_min", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyFloat("cooldown_min", i, parent.GetDifficultyFloat(formatter, i, this.Super.GetFloat("__cooldown_min", 1.5)));
				parent.RemoveDifficultyKey(formatter, i);
			}

			FormatEx(formatter, sizeof(formatter), "%s_cooldown_max", section);
			if (parent.ContainsDifficultyKey(formatter, i))
			{
				this.SetDifficultyFloat("cooldown_max", i, parent.GetDifficultyFloat(formatter, i, this.Super.GetFloat("__cooldown_max", 1.5)));
				parent.RemoveDifficultyKey(formatter, i);
			}
		}
	}

	public void StopAllSounds(int entity, int difficulty = Difficulty_Normal)
	{
		if (this == null)
		{
			return;
		}

		KeyMap_Array paths = this.Paths;
		if (paths == null)
		{
			return;
		}

		char path[PLATFORM_MAX_PATH];
		for (int i = 0; i < paths.Length; i++)
		{
			paths.GetString(i, path, sizeof(path));
			if (path[0] == '\0')
			{
				continue;
			}

			if (StrContains(path, ".mp3", true) == -1 && StrContains(path, ".wav", true) == -1)
			{
				continue;
			}

			StopSound(entity, this.GetChannel(difficulty), path);
		}
	}

	public bool EmitSound(bool toClient = false, int entity = -1, int emitter = SOUND_FROM_PLAYER, float origin[3] = NULL_VECTOR, int addPitch = 0, char returnSound[PLATFORM_MAX_PATH] = "", int definedIndex = -1, int difficulty = Difficulty_Normal, float fixedChance = -1.0)
	{
		if (this == null)
		{
			return false;
		}

		KeyMap_Array paths = this.Paths;
		if (paths == null)
		{
			return false;
		}

		char path[PLATFORM_MAX_PATH];
		if (definedIndex != -1)
		{
			paths.GetString(definedIndex, path, sizeof(path));
		}
		else
		{
			paths.GetString(GetRandomInt(0, paths.Length - 1), path, sizeof(path));
		}

		returnSound = path;

		if (path[0] == '\0')
		{
			return false;
		}

		float threshold = GetRandomFloat(0.0, 1.0);
		if (fixedChance >= 0.0)
		{
			threshold = fixedChance;
		}
		if (threshold > this.GetChance(difficulty))
		{
			return false;
		}

		if (StrContains(path, ".mp3", true) == -1 && StrContains(path, ".wav", true) == -1)
		{
			if (!toClient)
			{
				EmitGameSoundToAll(path, entity, this.GetFlags(difficulty));
			}
			else
			{
				EmitGameSoundToClient(entity, path, emitter, this.GetFlags(difficulty));
			}
			return true;
		}

		int pitch = GetRandomInt(this.GetPitchRandomMin(difficulty), this.GetPitchRandomMax(difficulty));
		int volumeCount = RoundToCeil(this.GetVolume(difficulty));
		for (int i = 0; i < volumeCount; i++)
		{
			float finalVolume = this.GetVolume(difficulty);
			if (i + 1 != volumeCount)
			{
				if (!toClient)
				{
					EmitSoundToAll(path, entity, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), 1.0,
					((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
					_, origin);
				}
				else
				{
					EmitSoundToClient(entity, path, emitter, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), 1.0,
					((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
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
						EmitSoundToAll(path, entity, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), finalVolume,
						((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
						_, origin);
					}
					else
					{
						EmitSoundToClient(entity, path, emitter, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), finalVolume,
						((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
						_, origin);
					}
				}
				else
				{
					if (!toClient)
					{
						EmitSoundToAll(path, entity, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), this.GetVolume(difficulty),
						((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
						_, origin);
					}
					else
					{
						EmitSoundToClient(entity, path, emitter, this.GetChannel(difficulty), this.GetLevel(difficulty), this.GetFlags(difficulty), this.GetVolume(difficulty),
						((this.GetPitchRandomMin(difficulty) == this.GetPitch(difficulty) && this.GetPitchRandomMax(difficulty) == this.GetPitch(difficulty)) ? this.GetPitch(difficulty) : pitch) + addPitch,
						_, origin);
					}
				}
			}
		}
		return true;
	}

	public bool EmitToAllPlayers()
	{
		float threshold = GetRandomFloat(0.0, 1.0);
		bool ret = true;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i))
			{
				continue;
			}
			bool value = this.EmitSound(true, i, .fixedChance = threshold);
			if (!value)
			{
				ret = false;
			}
		}
		return ret;
	}
}

methodmap ProfileAnimation < ProfileObject // This covers each animation index in each animation section
{
	public void GetAnimationName(int difficulty, char[] buffer, int bufferSize, bool legacy = false, const char[] legacyName = "")
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "animation_%s", legacyName);
		this.GetDifficultyString(formatter, difficulty, buffer, bufferSize);
		if (!legacy)
		{
			this.GetDifficultyString("name", difficulty, buffer, bufferSize);
		}
	}

	public void GetGestureName(int difficulty, char[] buffer, int bufferSize, bool legacy = false)
	{
		if (legacy)
		{
			return;
		}
		this.GetDifficultyString("gesture_name", difficulty, buffer, bufferSize);
	}

	public float GetAnimationPlaybackRate(int difficulty, bool legacy = false, const char[] legacyName = "")
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "animation_%s_playbackrate", legacyName);
		float val = this.GetDifficultyFloat(formatter, difficulty, 1.0);
		if (!legacy)
		{
			val = this.GetDifficultyFloat("playbackrate", difficulty, val);
		}
		if (val < -12.0)
		{
			val = -12.0;
		}
		else if (val > 12.0)
		{
			val = 12.0;
		}

		return val;
	}

	public float GetGesturePlaybackRate(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return 1.0;
		}
		float val = this.GetDifficultyFloat("gesture_playbackrate", difficulty, 1.0);
		if (val < -12.0)
		{
			val = -12.0;
		}
		else if (val > 12.0)
		{
			val = 12.0;
		}

		return val;
	}

	public float GetDuration(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return 0.0;
		}
		return this.GetDifficultyFloat("duration", difficulty);
	}

	public float GetAnimationCycle(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return 0.0;
		}
		return this.GetDifficultyFloat("cycle", difficulty);
	}

	public float GetGestureCycle(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return 0.0;
		}
		return this.GetDifficultyFloat("gesture_cycle", difficulty);
	}

	public float GetFootstepInterval(int difficulty, bool legacy = false, const char[] legacyName = "")
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "animation_%s_footstepinterval", legacyName);
		float val = this.GetDifficultyFloat(formatter, difficulty, 0.0);
		if (!legacy)
		{
			val = this.GetDifficultyFloat("footstepinterval", difficulty, val);
		}
		return val;
	}

	public bool CanOverrideLoop(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return false;
		}
		return this.GetDifficultyBool("override_loop", difficulty);
	}

	public bool GetLoopState(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return false;
		}
		return this.GetDifficultyBool("loop", difficulty);
	}

	public bool ShouldSyncWithGround(int difficulty, bool legacy = false)
	{
		if (legacy)
		{
			return false;
		}
		return this.GetDifficultyBool("ground_sync", difficulty);
	}

	public bool PlayAnimation(CBaseAnimating actor, int difficulty, bool loops = false)
	{
		int sequence;
		char animation[64];
		this.GetAnimationName(difficulty, animation, sizeof(animation));

		sequence = LookupProfileAnimation(actor.index, animation);

		if (sequence == -1)
		{
			return false;
		}

		if (sequence != actor.GetProp(Prop_Send, "m_nSequence"))
		{
			actor.ResetSequence(sequence);
		}
		actor.SetPropFloat(Prop_Send, "m_flCycle", this.GetAnimationCycle(difficulty));
		actor.SetPropFloat(Prop_Send, "m_flPlaybackRate", this.GetAnimationPlaybackRate(difficulty));
		actor.SetProp(Prop_Data, "m_bSequenceLoops", loops);

		return true;
	}

	public bool PlayGesture(CBaseAnimatingOverlay actor, int difficulty, bool loops = false, int& layer = -1)
	{
		int sequence;
		char animation[64];
		this.GetGestureName(difficulty, animation, sizeof(animation));

		sequence = LookupProfileAnimation(actor.index, animation);

		if (sequence == -1)
		{
			return false;
		}

		layer = actor.AddLayeredSequence(sequence, 1);
		if (layer == -1)
		{
			return false;
		}

		actor.SetLayerCycle(layer, this.GetGestureCycle(difficulty));
		actor.SetLayerPlaybackRate(layer, this.GetGesturePlaybackRate(difficulty));
		actor.SetLayerLooping(layer, loops);
		actor.SetLayerAutokill(layer, true);

		return true;
	}
}

methodmap ProfileMasterAnimations < ProfileObject // This covers the whole "animations" section
{
	property bool IsLegacy
	{
		public get()
		{
			char section[64];
			this.GetSectionName(section, sizeof(section));
			return strcmp(section, "animations") != 0;
		}
	}

	public bool HasAnimationSection(const char[] animType, bool checkLegacy = false)
	{
		if (this.IsLegacy)
		{
			if (checkLegacy)
			{
				if (strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Smell]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Rage]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_ChaseInitial]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Spawn]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_FleeInitial]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Heal]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_DeathCam]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Death]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_TauntKill]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_AttackBegin]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_AttackEnd]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_ProjectileShoot]) == 0 ||
					strcmp(animType, g_SlenderAnimationsList[SF2BossAnimation_Despawn]) == 0)
				{
					return false;
				}
			}
			char formatter[64];
			FormatEx(formatter, sizeof(formatter), "animation_%s", animType);
			return this.ContainsKey(formatter);
		}
		return this.GetSection(animType) != null;
	}

	public ProfileAnimation GetAnimation(const char[] animType, int preDefinedIndex = -1, const char[] preDefinedName = "", int& index = -1)
	{
		if (this.IsLegacy)
		{
			if (!this.HasAnimationSection(animType))
			{
				return null;
			}
			ProfileAnimation animObj = view_as<ProfileAnimation>(this);
			return animObj;
		}

		ProfileObject obj = this.GetSection(animType);
		if (obj == null || obj.Size <= 0)
		{
			return null;
		}

		ArrayList valids = new ArrayList(ByteCountToCells(64));
		for (int i = 0; i < obj.SectionLength; i++)
		{
			char key[64];
			obj.GetSectionNameFromIndex(i, key, sizeof(key));
			ProfileAnimation animObj = view_as<ProfileAnimation>(obj.GetSection(key));
			if (animObj != null)
			{
				valids.PushString(key);
			}
		}

		if (preDefinedIndex > -1)
		{
			if (preDefinedIndex >= valids.Length)
			{
				preDefinedIndex = valids.Length - 1;
			}
			index = preDefinedIndex;
		}
		else
		{
			index = GetRandomInt(0, valids.Length - 1);
		}

		ProfileAnimation animObj;
		if (preDefinedName[0] != '\0')
		{
			animObj = view_as<ProfileAnimation>(obj.GetSection(preDefinedName));
		}
		else
		{
			char animName[64];
			valids.GetString(index, animName, sizeof(animName));
			animObj = view_as<ProfileAnimation>(obj.GetSection(animName));
		}

		delete valids;

		if (animObj == null)
		{
			return null;
		}

		return animObj;
	}
}

methodmap ProfileEntityInputObject < ProfileObject
{
	public void GetInput(char[] buffer, int bufferSize)
	{
		this.GetString("input", buffer, bufferSize);
	}

	public void GetParameter(char[] buffer, int bufferSize)
	{
		this.GetString("parameter", buffer, bufferSize);
	}

	public int GetParameterSize()
	{
		return this.GetKeyValueLength("parameter");
	}

	public bool AcceptInput(int entity, int activator = -1, int caller = -1)
	{
		char input[64];
		this.GetInput(input, sizeof(input));

		bool result = false;

		int size = this.GetParameterSize();
		char[] parameter = new char[size];
		this.GetParameter(parameter, size);

		SetVariantString(parameter);
		result = AcceptEntityInput(entity, input, activator, caller);

		return result;
	}
}

methodmap ProfileEntityInputsArray < ProfileObject
{
	public void AcceptInputs(int entity, int activator = -1, int caller = -1)
	{
		for (int i = 0; i < this.SectionLength; i++)
		{
			char section[64];
			this.GetSectionNameFromIndex(i, section, sizeof(section));
			ProfileEntityInputObject output = view_as<ProfileEntityInputObject>(this.GetSection(section));
			if (output == null)
			{
				continue;
			}

			output.AcceptInput(entity, activator, caller);
		}
	}
}

methodmap ProfileEntityOutputObject < ProfileObject
{
	public void GetTarget(char[] buffer, int bufferSize)
	{
		this.GetString("target", buffer, bufferSize);
	}

	public int GetTargetSize()
	{
		return this.GetKeyValueLength("target");
	}

	public void GetInput(char[] buffer, int bufferSize)
	{
		this.GetString("input", buffer, bufferSize);
	}

	public int GetInputSize()
	{
		return this.GetKeyValueLength("input");
	}

	public void GetParameter(char[] buffer, int bufferSize)
	{
		this.GetString("parameter", buffer, bufferSize);
	}

	public int GetParameterSize()
	{
		return this.GetKeyValueLength("parameter");
	}

	public float GetDelay()
	{
		return this.GetFloat("delay");
	}

	public int GetTimesToFire()
	{
		return this.GetInt("times_to_fire", -1);
	}

	public void AddOutput(int entity, const char[] output)
	{
		int size = this.GetTargetSize();
		char[] target = new char[size];
		this.GetTarget(target, size);

		size = this.GetInputSize();
		char[] input = new char[size];
		this.GetInput(input, size);

		size = this.GetParameterSize();
		char[] parameter = new char[size];
		this.GetParameter(parameter, size);

		size = 98 + strlen(output) + strlen(target) + strlen(input) + strlen(parameter);
		char[] addOutput = new char[size];
		FormatEx(addOutput, size, "EntityOutputs.AddOutput(self, `%s`, `%s`, `%s`, `%s`, %0.3f, %d)", output, target, input, parameter, this.GetDelay(), this.GetTimesToFire());

		PrintToChatAll("%s", addOutput);

		SetVariantString(addOutput);
		AcceptEntityInput(entity, "RunScriptCode");
	}
}

methodmap ProfileEntityOutputsArray < ProfileObject
{
	public void AddOutputs(int entity)
	{
		for (int i = 0; i < this.SectionLength; i++)
		{
			char section[64];
			this.GetSectionNameFromIndex(i, section, sizeof(section));
			ProfileObject obj = this.GetSection(section);
			if (obj == null)
			{
				continue;
			}

			for (int i2 = 0; i2 < obj.SectionLength; i2++)
			{
				char subSection[64];
				obj.GetSectionNameFromIndex(i2, subSection, sizeof(subSection));
				ProfileEntityOutputObject output = view_as<ProfileEntityOutputObject>(obj.GetSection(subSection));
				if (output == null)
				{
					continue;
				}

				output.AddOutput(entity, section);
			}
		}
	}
}

int ColorToString(int buffer[4], char[] string, int maxlength)
{
	char value[32], num[4];
	for (int i = 0; i < 4; i++)
	{
		IntToString(buffer[i], num, sizeof(num));
		StrCat(value, sizeof(value), num);
		if (i < 3)
		{
			StrCat(value, sizeof(value), " ");
		}
	}
	return strcopy(string, maxlength, value);
}

int VectorToString(float buffer[3], char[] string, int maxlength)
{
	char value[64], num[16];
	for (int i = 0; i < 3; i++)
	{
		FloatToString(buffer[i], num, sizeof(num));
		StrCat(value, sizeof(value), num);
		if (i < 2)
		{
			StrCat(value, sizeof(value), " ");
		}
	}
	return strcopy(string, maxlength, value);
}

void StringToVector(const char[] string, float buffer[3])
{
	buffer[0] = 0.0;
	buffer[1] = 0.0;
	buffer[2] = 0.0;

	char num[3][16];
	int numStrings = ExplodeString(string, " ", num, sizeof(num), sizeof(num[]));

	for (int i = 0; i < numStrings; i++)
	{
		buffer[i] = StringToFloat(num[i]);
	}
}

void StringToColor(const char[] string, int buffer[4])
{
	buffer[0] = 0;
	buffer[1] = 0;
	buffer[2] = 0;
	buffer[3] = 0;

	char num[4][16];
	int numStrings = ExplodeString(string, " ", num, sizeof(num), sizeof(num[]));

	for (int i = 0; i < numStrings; i++)
	{
		buffer[i] = StringToInt(num[i]);
	}
}

bool StringToBool(const char[] string)
{
	return strcmp(string, "1", false) == 0;
}

int BoolToString(bool value, char[] buffer, int bufferSize)
{
	return FormatEx(buffer, bufferSize, "%b", value);
}

void RunScriptCode(int entity, int activator, int caller, const char[] format, any ...)
{
	if (!IsValidEntity(entity))
	{
		return;
	}

	static char buffer[1024];
	VFormat(buffer, sizeof(buffer), format, 5);

	SetVariantString(buffer);
	AcceptEntityInput(entity, "RunScriptCode", activator, caller);
}

void SetupProfileObjectNatives()
{
	CreateNative("SF2_ProfileObject.Parent.get", Native_GetObjectParent);
	CreateNative("SF2_ProfileObject.KeyLength.get", Native_GetObjectKeyLength);
	CreateNative("SF2_ProfileObject.SectionLength.get", Native_GetObjectSectionLength);
	CreateNative("SF2_ProfileObject.GetInt", Native_GetObjectInt);
	CreateNative("SF2_ProfileObject.SetInt", Native_SetObjectInt);
	CreateNative("SF2_ProfileObject.GetBool", Native_GetObjectBool);
	CreateNative("SF2_ProfileObject.SetBool", Native_SetObjectBool);
	CreateNative("SF2_ProfileObject.GetFloat", Native_GetObjectFloat);
	CreateNative("SF2_ProfileObject.SetFloat", Native_SetObjectFloat);
	CreateNative("SF2_ProfileObject.GetSection", Native_GetObjectSection);
	CreateNative("SF2_ProfileObject.GetArray", Native_GetObjectArray);
	CreateNative("SF2_ProfileObject.GetString", Native_GetObjectString);
	CreateNative("SF2_ProfileObject.SetString", Native_SetObjectString);
	CreateNative("SF2_ProfileObject.GetVector", Native_GetObjectVector);
	CreateNative("SF2_ProfileObject.SetVector", Native_SetObjectVector);
	CreateNative("SF2_ProfileObject.GetColor", Native_GetObjectColor);
	CreateNative("SF2_ProfileObject.SetColor", Native_SetObjectColor);
	CreateNative("SF2_ProfileObject.GetDifficultyInt", Native_GetObjectDifficultyInt);
	CreateNative("SF2_ProfileObject.SetDifficultyInt", Native_SetObjectDifficultyInt);
	CreateNative("SF2_ProfileObject.GetDifficultyBool", Native_GetObjectDifficultyBool);
	CreateNative("SF2_ProfileObject.SetDifficultyBool", Native_SetObjectDifficultyBool);
	CreateNative("SF2_ProfileObject.GetDifficultyFloat", Native_GetObjectDifficultyFloat);
	CreateNative("SF2_ProfileObject.SetDifficultyFloat", Native_SetObjectDifficultyFloat);
	CreateNative("SF2_ProfileObject.GetDifficultySection", Native_GetObjectDifficultySection);
	CreateNative("SF2_ProfileObject.GetDifficultyString", Native_GetObjectDifficultyString);
	CreateNative("SF2_ProfileObject.SetDifficultyString", Native_SetObjectDifficultyString);
	CreateNative("SF2_ProfileObject.GetDifficultyVector", Native_GetObjectDifficultyVector);
	CreateNative("SF2_ProfileObject.SetDifficultyVector", Native_SetObjectDifficultyVector);
	CreateNative("SF2_ProfileObject.GetDifficultyColor", Native_GetObjectDifficultyColor);
	CreateNative("SF2_ProfileObject.SetDifficultyColor", Native_SetObjectDifficultyColor);
	CreateNative("SF2_ProfileObject.ConvertValuesSectionToArray", Native_ConvertValuesSectionToArray);
	CreateNative("SF2_ProfileObject.ConvertSectionsSectionToArray", Native_ConvertSectionsSectionToArray);

	CreateNative("SF2_ProfileArray.Length.get", Native_GetArrayLength);
	CreateNative("SF2_ProfileArray.GetInt", Native_GetArrayInt);
	CreateNative("SF2_ProfileArray.GetBool", Native_GetArrayBool);
	CreateNative("SF2_ProfileArray.GetFloat", Native_GetArrayFloat);
	CreateNative("SF2_ProfileArray.GetSection", Native_GetArraySection);
	CreateNative("SF2_ProfileArray.GetString", Native_GetArrayString);

	CreateNative("SF2_ProfileSound.Paths.get", Native_GetSoundPaths);
	CreateNative("SF2_ProfileSound.SetDefaultChannel", Native_SetSoundDefaultChannel);
	CreateNative("SF2_ProfileSound.SetDefaultLevel", Native_SetSoundDefaultLevel);
	CreateNative("SF2_ProfileSound.SetDefaultFlags", Native_SetSoundDefaultFlags);
	CreateNative("SF2_ProfileSound.SetDefaultCooldownMin", Native_SetSoundDefaultCooldownMin);
	CreateNative("SF2_ProfileSound.SetDefaultCooldownMax", Native_SetSoundDefaultCooldownMax);
	CreateNative("SF2_ProfileSound.GetChannel", Native_GetSoundChannel);
	CreateNative("SF2_ProfileSound.GetVolume", Native_GetSoundVolume);
	CreateNative("SF2_ProfileSound.GetFlags", Native_GetSoundFlags);
	CreateNative("SF2_ProfileSound.GetLevel", Native_GetSoundLevel);
	CreateNative("SF2_ProfileSound.GetPitch", Native_GetSoundPitch);
	CreateNative("SF2_ProfileSound.GetCooldownMin", Native_GetSoundCooldownMin);
	CreateNative("SF2_ProfileSound.GetCooldownMax", Native_GetSoundCooldownMax);
	CreateNative("SF2_ProfileSound.Precache", Native_SoundPrecache);
	CreateNative("SF2_ProfileSound.EmitToAll", Native_SoundEmitToAll);
	CreateNative("SF2_ProfileSound.EmitToClient", Native_SoundEmitToClient);
	CreateNative("SF2_ProfileSound.StopAllSounds", Native_SoundStopAllSounds);

	CreateNative("SF2_ProfileAnimation.GetAnimationName", Native_AnimationGetAnimationName);
	CreateNative("SF2_ProfileAnimation.GetGestureName", Native_AnimationGetGestureName);
	CreateNative("SF2_ProfileAnimation.GetAnimationPlaybackRate", Native_AnimationGetAnimationRate);
	CreateNative("SF2_ProfileAnimation.GetGesturePlaybackRate", Native_AnimationGetGestureRate);
	CreateNative("SF2_ProfileAnimation.GetDuration", Native_AnimationGetDuration);
	CreateNative("SF2_ProfileAnimation.GetAnimationCycle", Native_AnimationGetAnimationCycle);
	CreateNative("SF2_ProfileAnimation.GetGestureCycle", Native_AnimationGetGestureCycle);
	CreateNative("SF2_ProfileAnimation.PlayAnimation", Native_AnimationPlayAnimation);
	CreateNative("SF2_ProfileAnimation.PlayGesture", Native_AnimationPlayGesture);

	CreateNative("SF2_ProfileMasterAnimation.HasAnimationSection", Native_MasterAnimationHasSection);
	CreateNative("SF2_ProfileMasterAnimation.GetAnimation", Native_MasterAnimationGetAnimation);
}

static any Native_GetObjectParent(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.Parent;
}

static any Native_GetObjectKeyLength(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.KeyLength;
}

static any Native_GetObjectSectionLength(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.SectionLength;
}

static any Native_GetObjectInt(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int def = GetNativeCell(3);

	return obj.GetInt(key, def);
}

static any Native_SetObjectInt(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int def = GetNativeCell(3);

	obj.SetInt(key, def);

	return 0;
}

static any Native_GetObjectBool(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	bool def = GetNativeCell(3);

	return obj.GetBool(key, def);
}

static any Native_SetObjectBool(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	bool def = GetNativeCell(3);

	obj.SetBool(key, def);

	return 0;
}

static any Native_GetObjectFloat(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	float def = GetNativeCell(3);

	return obj.GetFloat(key, def);
}

static any Native_SetObjectFloat(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	float def = GetNativeCell(3);

	obj.SetFloat(key, def);

	return 0;
}

static any Native_GetObjectSection(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	ProfileObject def = GetNativeCell(3);

	return obj.GetSection(key, def);
}

static any Native_GetObjectArray(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	KeyMap_Array def = GetNativeCell(3);

	return obj.GetArray(key, def);
}

static any Native_GetObjectString(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int bufferSize = GetNativeCell(4);
	char[] buffer = new char[bufferSize];

	int defSize;
	GetNativeStringLength(5, defSize);
	defSize++;
	char[] def = new char[defSize];
	GetNativeString(5, def, defSize);

	obj.GetString(key, buffer, bufferSize, def);

	SetNativeString(3, buffer, bufferSize);
	return 0;
}

static any Native_SetObjectString(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int valueSize;
	GetNativeStringLength(3, valueSize);
	valueSize++;
	char[] value = new char[valueSize];
	GetNativeString(3, value, valueSize);

	obj.SetString(key, value);

	return 0;
}

static any Native_GetObjectVector(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	float def[3];
	GetNativeArray(4, def, 3);
	float vec[3];

	obj.GetVector(key, vec, def);

	SetNativeArray(3, vec, 3);
	return 0;
}

static any Native_SetObjectVector(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	float value[3];
	GetNativeArray(3, value, 3);

	obj.SetVector(key, value);
	return 0;
}

static any Native_GetObjectColor(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int def[4];
	GetNativeArray(4, def, 4);
	int vec[4];

	obj.GetColor(key, vec, def);

	SetNativeArray(3, vec, 4);
	return 0;
}

static any Native_SetObjectColor(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int value[4];
	GetNativeArray(3, value, 4);

	obj.SetColor(key, value);
	return 0;
}

static any Native_GetObjectDifficultyInt(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	int def = GetNativeCell(4);

	return obj.GetDifficultyInt(key, difficulty, def);
}

static any Native_SetObjectDifficultyInt(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	int def = GetNativeCell(4);

	obj.SetDifficultyInt(key, difficulty, def);
	return 0;
}

static any Native_GetObjectDifficultyBool(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	bool def = GetNativeCell(4);

	return obj.GetDifficultyBool(key, difficulty, def);
}

static any Native_SetObjectDifficultyBool(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	bool def = GetNativeCell(4);

	obj.SetDifficultyBool(key, difficulty, def);
	return 0;
}

static any Native_GetObjectDifficultyFloat(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	float def = GetNativeCell(4);

	return obj.GetDifficultyFloat(key, difficulty, def);
}

static any Native_SetObjectDifficultyFloat(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	float def = GetNativeCell(4);

	obj.SetDifficultyFloat(key, difficulty, def);
	return 0;
}

static any Native_GetObjectDifficultySection(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);
	ProfileObject def = GetNativeCell(4);

	return obj.GetDifficultySection(key, difficulty, def);
}

static any Native_GetObjectDifficultyString(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	int bufferSize = GetNativeCell(5);
	char[] buffer = new char[bufferSize];

	int defSize;
	GetNativeStringLength(6, defSize);
	defSize++;
	char[] def = new char[defSize];
	GetNativeString(6, def, defSize);

	obj.GetDifficultyString(key, difficulty, buffer, bufferSize, def);
	SetNativeString(4, buffer, bufferSize);
	return 0;
}

static any Native_SetObjectDifficultyString(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	int valueSize;
	GetNativeStringLength(4, valueSize);
	valueSize++;
	char[] value = new char[valueSize];
	GetNativeString(4, value, valueSize);

	obj.SetDifficultyString(key, difficulty, value);
	return 0;
}

static any Native_GetObjectDifficultyVector(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	float buffer[3];

	float def[3];
	GetNativeArray(5, def, 3);

	obj.GetDifficultyVector(key, difficulty, buffer, def);
	SetNativeArray(4, buffer, 3);
	return 0;
}

static any Native_SetObjectDifficultyVector(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	float value[3];
	GetNativeArray(4, value, 3);

	obj.SetDifficultyVector(key, difficulty, value);
	return 0;
}

static any Native_GetObjectDifficultyColor(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	int buffer[4];

	int def[4];
	GetNativeArray(5, def, 4);

	obj.GetDifficultyColor(key, difficulty, buffer, def);
	SetNativeArray(4, buffer, 4);
	return 0;
}

static any Native_SetObjectDifficultyColor(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	int difficulty = GetNativeCell(3);

	int value[4];
	GetNativeArray(4, value, 4);

	obj.SetDifficultyColor(key, difficulty, value);
	return 0;
}

static any Native_ConvertValuesSectionToArray(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	obj.ConvertValuesSectionToArray(key);
	return 0;
}

static any Native_ConvertSectionsSectionToArray(Handle plugin, int numParams)
{
	ProfileObject obj = view_as<ProfileObject>(GetNativeCell(1));
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	obj.ConvertSectionsSectionToArray(key);
	return 0;
}

static any Native_GetArrayLength(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	return obj.Length;
}

static any Native_GetArrayInt(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	return obj.GetInt(GetNativeCell(2), GetNativeCell(3));
}

static any Native_GetArrayBool(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	return obj.GetBool(GetNativeCell(2), GetNativeCell(3));
}

static any Native_GetArrayFloat(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	return obj.GetFloat(GetNativeCell(2), GetNativeCell(3));
}

static any Native_GetArraySection(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	return obj.GetSection(GetNativeCell(2), GetNativeCell(3));
}

static any Native_GetArrayString(Handle plugin, int numParams)
{
	KeyMap_Array obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile array handle %x", obj);
	}

	int index = GetNativeCell(2);

	int bufferSize = GetNativeCell(4);
	char[] buffer = new char[bufferSize];

	int defaultValueSize;
	GetNativeStringLength(5, defaultValueSize);
	defaultValueSize++;
	char[] defaultValue = new char[defaultValueSize];
	GetNativeString(5, defaultValue, defaultValueSize);

	obj.GetString(index, buffer, bufferSize, defaultValue);

	SetNativeString(3, buffer, bufferSize);
	return 0;
}

static any Native_GetSoundPaths(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.Paths;
}

static any Native_SetSoundDefaultChannel(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int channel = GetNativeCell(2);

	obj.SetDefaultChannel(channel);
	return 0;
}

static any Native_SetSoundDefaultLevel(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int level = GetNativeCell(2);

	obj.SetDefaultLevel(level);
	return 0;
}

static any Native_SetSoundDefaultFlags(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int flags = GetNativeCell(2);

	obj.SetDefaultFlags(flags);
	return 0;
}

static any Native_SetSoundDefaultCooldownMin(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	float cooldown = GetNativeCell(2);

	obj.SetDefaultCooldownMin(cooldown);
	return 0;
}

static any Native_SetSoundDefaultCooldownMax(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	float cooldown = GetNativeCell(2);

	obj.SetDefaultCooldownMax(cooldown);
	return 0;
}

static any Native_GetSoundChannel(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetChannel(GetNativeCell(2));
}

static any Native_GetSoundVolume(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetVolume(GetNativeCell(2));
}

static any Native_GetSoundFlags(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetFlags(GetNativeCell(2));
}

static any Native_GetSoundLevel(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetLevel(GetNativeCell(2));
}

static any Native_GetSoundPitch(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetPitch(GetNativeCell(2));
}

static any Native_GetSoundCooldownMin(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetCooldownMin(GetNativeCell(2));
}

static any Native_GetSoundCooldownMax(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetCooldownMax(GetNativeCell(2));
}

static any Native_SoundPrecache(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	obj.Precache();
	return 0;
}

static any Native_SoundEmitToAll(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	obj.EmitSound(false, GetNativeCell(2), .difficulty = GetNativeCell(3));
	return 0;
}

static any Native_SoundEmitToClient(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	obj.EmitSound(true, GetNativeCell(2), GetNativeCell(3), .difficulty = GetNativeCell(4));
	return 0;
}

static any Native_SoundStopAllSounds(Handle plugin, int numParams)
{
	ProfileSound obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	obj.StopAllSounds(.entity = GetNativeCell(2));
	return 0;
}

static any Native_AnimationGetAnimationName(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int difficulty = GetNativeCell(2);
	int bufferSize = GetNativeCell(4);
	char[] buffer = new char[bufferSize];

	obj.GetAnimationName(difficulty, buffer, bufferSize);
	SetNativeString(3, buffer, bufferSize);
	return 0;
}

static any Native_AnimationGetGestureName(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int difficulty = GetNativeCell(2);
	int bufferSize = GetNativeCell(4);
	char[] buffer = new char[bufferSize];

	obj.GetGestureName(difficulty, buffer, bufferSize);
	SetNativeString(3, buffer, bufferSize);
	return 0;
}

static any Native_AnimationGetAnimationRate(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetAnimationPlaybackRate(GetNativeCell(2));
}

static any Native_AnimationGetGestureRate(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetGesturePlaybackRate(GetNativeCell(2));
}

static any Native_AnimationGetDuration(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetDuration(GetNativeCell(2));
}

static any Native_AnimationGetAnimationCycle(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetAnimationCycle(GetNativeCell(2));
}

static any Native_AnimationGetGestureCycle(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	return obj.GetGestureCycle(GetNativeCell(2));
}

static any Native_AnimationPlayAnimation(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	CBaseAnimating entity = CBaseAnimating(GetNativeCell(2));
	int difficulty = GetNativeCell(3);

	char name[64];
	obj.GetAnimationName(difficulty, name, sizeof(name));
	int sequence = LookupProfileAnimation(entity.index, name);
	if (sequence == -1)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid animation name %s", name);
	}

	float rate = obj.GetAnimationPlaybackRate(difficulty);
	float cycle = obj.GetAnimationCycle(difficulty);

	entity.ResetSequence(sequence);
	entity.SetPropFloat(Prop_Send, "m_flCycle", cycle);
	entity.SetPropFloat(Prop_Send, "m_flPlaybackRate", rate);
	entity.SetProp(Prop_Data, "m_bSequenceLoops", GetNativeCell(4));

	return 0;
}

static any Native_AnimationPlayGesture(Handle plugin, int numParams)
{
	ProfileAnimation obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	CBaseAnimatingOverlay entity = CBaseAnimatingOverlay(GetNativeCell(2));
	int difficulty = GetNativeCell(3);
	bool loop = GetNativeCell(4);

	char name[64];
	obj.GetGestureName(difficulty, name, sizeof(name));
	int sequence = LookupProfileAnimation(entity.index, name);
	if (sequence == -1)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid gesture name %s", name);
	}

	float rate = obj.GetGesturePlaybackRate(difficulty);
	float cycle = obj.GetGestureCycle(difficulty);
	float duration = entity.SequenceDuration(sequence);
	int layer = entity.AddLayeredSequence(sequence, 1);
	entity.SetLayerDuration(layer, duration);
	entity.SetLayerPlaybackRate(layer, rate);
	entity.SetLayerCycle(layer, cycle);
	entity.SetLayerLooping(layer, loop);
	entity.SetLayerAutokill(layer, true);
	SetNativeCellRef(5, layer);
	return 0;
}

static any Native_MasterAnimationHasSection(Handle plugin, int numParams)
{
	ProfileMasterAnimations obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize;
	GetNativeStringLength(2, keySize);
	keySize++;
	char[] key = new char[keySize];
	GetNativeString(2, key, keySize);

	return obj.HasAnimationSection(key);
}

static any Native_MasterAnimationGetAnimation(Handle plugin, int numParams)
{
	ProfileMasterAnimations obj = GetNativeCell(1);
	if (obj == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", obj);
	}

	int keySize, nameSize;
	GetNativeStringLength(2, keySize);
	GetNativeStringLength(4, nameSize);
	keySize++;
	nameSize++;
	char[] key = new char[keySize];
	char[] name = new char[nameSize];
	GetNativeString(2, key, keySize);
	GetNativeString(4, name, nameSize);
	int index = GetNativeCell(5);

	ProfileAnimation animation = obj.GetAnimation(key, GetNativeCell(3), name, index);
	SetNativeCellRef(5, index);
	return animation;
}
