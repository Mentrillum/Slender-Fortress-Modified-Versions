#pragma semicolon 1
#pragma newdecls required

enum KeyMapKeyType
{
	Key_Type_Invalid = -1,
	Key_Type_Value = 0,
	Key_Type_Section
};

methodmap KeyMap < StringMap
{
	public KeyMap()
	{
		return view_as<KeyMap>(new StringMap());
	}

	property StringMap Super
	{
		public get()
		{
			return view_as<StringMap>(this);
		}
	}

	property KeyMap Parent
	{
		public get()
		{
			KeyMap obj = null;
			this.GetValue("__parent", obj);
			return obj;
		}

		public set(KeyMap val)
		{
			this.SetValue("__parent", val);
		}
	}

	property bool IsArray
	{
		public get()
		{
			bool value = false;
			this.GetValue("__is_array", value);
			return value;
		}

		public set(bool value)
		{
			this.SetValue("__is_array", value);
		}
	}

	property int KeyLength
	{
		public get()
		{
			int value = 0;
			this.GetValue("__key_length", value);
			return value;
		}

		public set(int value)
		{
			this.SetValue("__key_length", value);
		}
	}

	property int SectionLength
	{
		public get()
		{
			int value = 0;
			this.GetValue("__section_length", value);
			return value;
		}

		public set(int value)
		{
			this.SetValue("__section_length", value);
		}
	}

	public KeyMapKeyType GetType(const char[] key)
	{
		int size = strlen(key) + 11 + 1;
		char type[16];
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keytype", key);
		if (!this.Super.GetString(formatter, type, sizeof(type)))
		{
			return Key_Type_Invalid;
		}
		if (strcmp(type, "value") == 0)
		{
			return Key_Type_Value;
		}
		else if (strcmp(type, "section") == 0)
		{
			return Key_Type_Section;
		}
		return Key_Type_Invalid;
	}

	public void SetType(const char[] key, KeyMapKeyType value)
	{
		int size = strlen(key) + 11 + 1;
		char type[16];
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keytype", key);
		switch (value)
		{
			case Key_Type_Value:
			{
				strcopy(type, sizeof(type), "value");
			}

			case Key_Type_Section:
			{
				strcopy(type, sizeof(type), "section");
			}

			case Key_Type_Invalid:
			{
				strcopy(type, sizeof(type), "invalid");
			}
		}
		this.Super.SetString(formatter, type);
	}

	public int GetInt(const char[] key, int def = -1)
	{
		char string[32];
		bool state = this.Super.GetString(key, string, sizeof(string));
		if (!state)
		{
			return def;
		}
		return StringToInt(string);
	}

	public float GetFloat(const char[] key, float def = -1.0)
	{
		char string[32];
		bool state = this.Super.GetString(key, string, sizeof(string));
		if (!state)
		{
			return def;
		}
		return StringToFloat(string);
	}

	public bool GetBool(const char[] key, bool def = false)
	{
		char string[32];
		bool state = this.Super.GetString(key, string, sizeof(string));
		if (!state)
		{
			return def;
		}
		return StringToBool(string);
	}

	public void GetString(const char[] key, char[] buffer, int bufferSize, const char[] def = "")
	{
		bool status = this.Super.GetString(key, buffer, bufferSize);
		if (!status)
		{
			strcopy(buffer, bufferSize, def);
		}
	}

	public KeyMap GetSection(const char[] key, KeyMap def = null)
	{
		if (this.GetType(key) != Key_Type_Section)
		{
			return def;
		}

		KeyMap obj = def;
		this.GetValue(key, obj);
		return obj;
	}

	public void SetKeyIndex(const char[] key, int value)
	{
		int size = strlen(key) + 16 + 1;
		char[] formatter = new char[size];
		if (this.GetType(key) == Key_Type_Section)
		{
			FormatEx(formatter, size, "%i||__sectionindex", value);
		}
		else
		{
			FormatEx(formatter, size, "%i||__keyindex", value);
		}
		this.Super.SetString(formatter, key);
	}

	public bool GetKeyNameFromIndex(int key, char[] buffer, int bufferSize)
	{
		char formatter[128];
		FormatEx(formatter, sizeof(formatter), "%i||__keyindex", key);
		return this.Super.GetString(formatter, buffer, bufferSize);
	}

	public bool GetSectionNameFromIndex(int key, char[] buffer, int bufferSize)
	{
		char formatter[128];
		FormatEx(formatter, sizeof(formatter), "%i||__sectionindex", key);
		return this.Super.GetString(formatter, buffer, bufferSize);
	}

	public void SetIndexKey(const char[] key, int value)
	{
		int size = strlen(key) + 21 + 1;
		char[] formatter = new char[size];
		if (this.GetType(key) == Key_Type_Section)
		{
			FormatEx(formatter, size, "%s||__sectionindexvalue", key);
		}
		else
		{
			FormatEx(formatter, size, "%s||__keyindexvalue", key);
		}
		this.Super.SetValue(formatter, value);
	}

	public int GetIndexFromKey(const char[] key)
	{
		int size = strlen(key) + 17 + 1;
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keyindexvalue", key);
		int value = -1;
		this.Super.GetValue(formatter, value);
		return value;
	}

	public int GetIndexFromSection(const char[] key)
	{
		int size = strlen(key) + 21 + 1;
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__sectionindexvalue", key);
		int value = -1;
		this.Super.GetValue(formatter, value);
		return value;
	}

	public void SetKeyValueLength(const char[] key, int value)
	{
		if (this.GetType(key) == Key_Type_Section)
		{
			return;
		}
		int size = strlen(key) + 12 + 1;
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keyvaluesize", key);
		this.Super.SetValue(formatter, value);
	}

	public int GetKeyValueLength(const char[] key)
	{
		if (this.GetType(key) == Key_Type_Section)
		{
			return -1;
		}
		int size = strlen(key) + 12 + 1;
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keyvaluesize", key);
		this.Super.GetValue(formatter, size);
		return size;
	}

	public void SetKeyValue(const char[] key, const char[] value)
	{
		this.SetType(key, Key_Type_Value);
		this.Super.SetString(key, value);
		this.SetKeyIndex(key, this.KeyLength);
		this.SetIndexKey(key, this.KeyLength);
		this.KeyLength++;
		this.SetKeyValueLength(key, strlen(value) + 1);
	}

	public KeyMap SetKeySection(const char[] key)
	{
		KeyMap newValue = new KeyMap();
		this.SetSection(key, newValue);
		this.SetType(key, Key_Type_Section);
		newValue.SetSectionName(key);
		newValue.Parent = this;
		this.SetKeyIndex(key, this.SectionLength);
		this.SetIndexKey(key, this.SectionLength);
		this.SectionLength++;

		/*
					KeyMap child = obj.GetSection(key);
			if (child == null)
			{
				child = new KeyMap();
				obj.SetSection(key, child);
				child.SetSectionName(key);
				child.Parent = obj;
				obj.SetKeyIndex(key, obj.SectionLength);
				obj.SectionLength++;
			}

			if (kv.GotoFirstSubKey(false))
			{
				IterateKeyValues(kv, child);
				kv.GoBack();
			}
		}
		else
		{
			obj.SetType(key, Key_Type_Value);
			kv.GetString(NULL_STRING, value, sizeof(value));
			obj.SetString(key, value);
			obj.SetKeyIndex(key, obj.KeyLength);
			obj.KeyLength++;
		}
		*/
		return newValue;
	}

	public void RemoveKey(const char[] key)
	{
		int index = -1, currentIndex = -1, size;
		if (this.GetType(key) == Key_Type_Section)
		{
			KeyMap section = this.GetSection(key);
			index = this.GetIndexFromSection(key);
			currentIndex = index + 1;
			size = strlen(key) + 21 + 1;
			char[] formatter3 = new char[size];
			FormatEx(formatter3, size, "%s||__sectionindexvalue", key);
			this.Super.Remove(formatter3);

			while (index >= 0 && currentIndex < this.SectionLength)
			{
				char hiddenKey[512];
				this.GetSectionNameFromIndex(currentIndex, hiddenKey, sizeof(hiddenKey));
				this.SetKeyIndex(hiddenKey, currentIndex - 1);
				this.SetIndexKey(hiddenKey, currentIndex - 1);
				currentIndex++;
			}

			CleanupKeyMap(section);
			char formatter4[128];
			FormatEx(formatter4, sizeof(formatter4), "%i||__keyindex", currentIndex - 1);
			this.Super.Remove(formatter4);
			this.SectionLength--;
		}
		else
		{
			index = this.GetIndexFromKey(key);
			currentIndex = index + 1;
			size = strlen(key) + 17 + 1;
			char[] formatter2 = new char[size];
			FormatEx(formatter2, size, "%s||__keyindexvalue", key);
			this.Super.Remove(formatter2);

			char[] formatter3 = new char[size];
			FormatEx(formatter3, size, "%s||__keyvaluesize", key);
			this.Super.Remove(formatter3);
			while (index >= 0 && currentIndex < this.KeyLength)
			{
				char hiddenKey[512];
				this.GetKeyNameFromIndex(currentIndex, hiddenKey, sizeof(hiddenKey));
				this.SetKeyIndex(hiddenKey, currentIndex - 1);
				this.SetIndexKey(hiddenKey, currentIndex - 1);
				currentIndex++;
			}

			char formatter4[128];
			FormatEx(formatter4, sizeof(formatter4), "%i||__keyindex", currentIndex - 1);
			this.Super.Remove(formatter4);
			this.KeyLength--;
		}

		this.Super.Remove(key);

		size = strlen(key) + 11 + 1;
		char[] formatter = new char[size];
		FormatEx(formatter, size, "%s||__keytype", key);
		this.Super.Remove(formatter);
	}

	public void RenameKey(const char[] key, const char[] newKey)
	{
		KeyMapKeyType type = this.GetType(key);
		int index = 0;
		if (type == Key_Type_Section)
		{
			KeyMap section = this.GetSection(key);
			this.SetSection(newKey, section);
			section.SetSectionName(newKey);
			index = this.GetIndexFromSection(key);
		}
		else
		{
			this.SetType(newKey, Key_Type_Value);
			int valueSize = this.GetKeyValueLength(key);
			char[] value = new char[valueSize];
			this.Super.GetString(key, value, valueSize);
			this.Super.SetString(newKey, value);
			index = this.GetIndexFromKey(key);
		}
		this.RemoveKey(key);

		this.SetKeyIndex(newKey, index);
		this.SetIndexKey(newKey, index);
	}

	public void SetSection(const char[] key, KeyMap value)
	{
		this.Super.SetValue(key, value);
		this.SetType(key, Key_Type_Section);
	}

	public KeyMap Clone()
	{
		KeyMap clone = CloneKeyMap(this);
		clone.Parent = null;
		KeyMap section = clone.GetSection("execution");
		if (section != null)
		{
			section.GetSection("paths");
		}
		return clone;
	}

	public void GetSectionName(char[] buffer, int bufferSize)
	{
		this.GetString("__section_name", buffer, bufferSize);
	}

	public bool SetSectionName(const char[] buffer)
	{
		return this.Super.SetString("__section_name", buffer);
	}

	public bool SetInt(const char[] key, int value)
	{
		char stringValue[128];
		IntToString(value, stringValue, sizeof(stringValue));
		this.SetString(key, stringValue);
		return false;
	}

	public bool SetFloat(const char[] key, float value)
	{
		char stringValue[128];
		FloatToString(value, stringValue, sizeof(stringValue));
		this.SetString(key, stringValue);
		return false;
	}

	public bool SetBool(const char[] key, bool value)
	{
		char stringValue[6];
		BoolToString(value, stringValue, sizeof(stringValue));
		this.SetString(key, stringValue);
		return false;
	}

	public int IndexOfSection(KeyMap value)
	{
		int length = this.Size;
		for (int i = 0; i < length; i++)
		{
			char keyName[512];
			this.GetKeyNameFromIndex(i, keyName, sizeof(keyName));
			if (this.GetType(keyName) != Key_Type_Section)
			{
				continue;
			}

			KeyMap current = this.GetSection(keyName);
			if (value == current)
			{
				return i;
			}
		}

		return -1;
	}

	public int IndexOfString(const char[] value)
	{
		int length = this.Size;
		for (int i = 0; i < length; i++)
		{
			char keyName[512];
			this.GetKeyNameFromIndex(i, keyName, sizeof(keyName));
			if (this.GetType(keyName) != Key_Type_Value)
			{
				continue;
			}

			char current[512];
			this.GetString(keyName, current, sizeof(current));
			if (strcmp(value, current) == 0)
			{
				return i;
			}
		}

		return -1;
	}

	public bool ContainsString(const char[] value)
	{
		return this.IndexOfString(value) != -1;
	}

	public void ConvertValuesSectionToArray(const char[] name)
	{
		KeyMap obj = this.GetSection(name);
		if (obj == null)
		{
			return;
		}

		KeyMap_Array array = new KeyMap_Array(Key_Type_Value);

		for (int i = 0; i < obj.KeyLength; i++)
		{
			char key[512];
			obj.GetKeyNameFromIndex(i, key, sizeof(key));

			KeyMapKeyType type = obj.GetType(key);
			if (!IsHiddenKey(key) && type == Key_Type_Value)
			{
				int size = obj.GetKeyValueLength(key);
				char[] value = new char[size];
				obj.GetString(key, value, size);
				array.PushString(value);
			}
		}

		delete obj;

		this.Remove(name);
		this.SetSection(name, array);
		array.SetSectionName(name);
		array.Parent = this;
	}

	public void ConvertSectionsSectionToArray(const char[] name)
	{
		KeyMap obj = this.GetSection(name);
		if (obj == null)
		{
			return;
		}

		KeyMap_Array array = new KeyMap_Array(Key_Type_Section);

		for (int i = 0; i < obj.SectionLength; i++)
		{
			char key[512];
			obj.GetSectionNameFromIndex(i, key, sizeof(key));

			KeyMap section = obj.GetSection(key);
			if (!IsHiddenKey(key) && section != null)
			{
				array.PushSection(section);
			}
		}

		delete obj;

		this.Remove(name);
		this.SetSection(name, array);
		array.SetSectionName(name);
		array.Parent = this;
	}
}

methodmap KeyMap_Array < KeyMap
{
	public KeyMap_Array(KeyMapKeyType type = Key_Type_Invalid)
	{
		KeyMap_Array self = view_as<KeyMap_Array>(new KeyMap());
		self.IsArray = true;
		self.SetType(type);

		return self;
	}

	property KeyMap Super
	{
		public get()
		{
			return view_as<KeyMap>(this);
		}
	}

	property int Length
	{
		public get()
		{
			return this.Super.GetInt("__length", 0);
		}

		public set(int value)
		{
			this.Super.SetInt("__length", value);
		}
	}

	public bool CanUseType(KeyMapKeyType type)
	{
		return this.GetType() == Key_Type_Invalid || this.GetType() == type;
	}

	public KeyMapKeyType GetType()
	{
		char key[64], type[16], formatter[128];
		this.GetSectionName(key, sizeof(key));
		FormatEx(formatter, sizeof(formatter), "%s||__arraytype", key);
		if (this.Super.Super.GetString(formatter, type, sizeof(type)))
		{
			return Key_Type_Invalid;
		}
		if (strcmp(type, "value") == 0)
		{
			return Key_Type_Value;
		}
		else if (strcmp(type, "section") == 0)
		{
			return Key_Type_Section;
		}
		return Key_Type_Invalid;
	}

	public void SetType(KeyMapKeyType value)
	{
		char key[64], type[16], formatter[128];
		this.GetSectionName(key, sizeof(key));
		FormatEx(formatter, sizeof(formatter), "%s||__arraytype", key);
		switch (value)
		{
			case Key_Type_Value:
			{
				strcopy(type, sizeof(type), "value");
			}

			case Key_Type_Section:
			{
				strcopy(type, sizeof(type), "section");
			}

			case Key_Type_Invalid:
			{
				strcopy(type, sizeof(type), "invalid");
			}
		}
		this.Super.Super.SetString(formatter, type);
	}

	public void SetKeyType(int key, KeyMapKeyType value)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		this.Super.SetType(keyName, value);
	}

	public void GetString(int key, char[] buffer, int bufferSize, const char[] def = "")
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		this.Super.GetString(keyName, buffer, bufferSize, def);
	}

	public int GetInt(int key, int def = -1)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		return this.Super.GetInt(keyName, def);
	}

	public float GetFloat(int key, float def = -1.0)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		return this.Super.GetFloat(keyName, def);
	}

	public bool GetBool(int key, bool def = false)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		return this.Super.GetBool(keyName, def);
	}

	public KeyMap GetSection(int key, KeyMap def = null)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		return this.Super.GetSection(keyName, def);
	}

	public KeyMapKeyType GetTypeFromKey(int key)
	{
		char keyName[16];
		IntToString(key, keyName, sizeof(keyName));

		return this.Super.GetType(keyName);
	}

	public bool SetString(int index, const char[] value)
	{
		if (!this.CanUseType(Key_Type_Value))
		{
			return false;
		}

		char key[16];
		IntToString(index, key, sizeof(key));

		return this.Super.SetString(key, value);
	}

	public bool SetSection(int index, KeyMap value)
	{
		if (!this.CanUseType(Key_Type_Section))
		{
			return false;
		}

		char key[16];
		IntToString(index, key, sizeof(key));

		return this.Super.SetValue(key, value);
	}

	public int PushString(const char[] value)
	{
		int index = this.Length;
		this.SetKeyType(index, Key_Type_Value);
		if (!this.SetString(index, value))
		{
			return -1;
		}
		this.Length++;
		return index;
	}

	public int PushSection(KeyMap value)
	{
		int index = this.Length;
		this.SetKeyType(index, Key_Type_Section);
		if (!this.SetSection(index, value))
		{
			return -1;
		}
		this.Length++;
		return index;
	}

	public int IndexOf(const char[] value)
	{
		for (int i = 0; i < this.Length; i++)
		{
			if (this.GetTypeFromKey(i) != Key_Type_Value)
			{
				continue;
			}

			char current[128];
			this.GetString(i, current, sizeof(current));
			if (strcmp(value, current) == 0)
			{
				return i;
			}
		}

		return -1;
	}
}

KeyMap KeyValuesToKeyMap(KeyValues kv, KeyMap obj = null)
{
	if (obj == null)
	{
		obj = new KeyMap();
	}

	if (kv.GotoFirstSubKey(false))
	{
		IterateKeyValues(kv, obj);
		kv.GoBack();
	}

	return obj;
}

static void IterateKeyValues(KeyValues kv, KeyMap obj)
{
	char key[512], value[2048];

	do
	{
		kv.GetSectionName(key, sizeof(key));

		int keyLen = strlen(key);
		for (int i = 0; i < keyLen; i++)
		{
			key[i] = CharToLower(key[i]);
		}

		bool isSection = ((kv.NodesInStack() == 0) || (kv.GetDataType(NULL_STRING) == KvData_None && kv.NodesInStack() > 0));

		if (isSection)
		{
			KeyMap child = obj.GetSection(key);
			if (child == null)
			{
				child = obj.SetKeySection(key);
			}

			if (kv.GotoFirstSubKey(false))
			{
				IterateKeyValues(kv, child);
				kv.GoBack();
			}
		}
		else
		{
			kv.GetString(NULL_STRING, value, sizeof(value));
			obj.SetKeyValue(key, value);
		}
	}
	while (kv.GotoNextKey(false));
}

static KeyMap CloneKeyMap(KeyMap obj)
{
	if (obj == null)
	{
		return null;
	}

	StringMap temp = view_as<StringMap>(obj).Clone();
	KeyMap clone = view_as<KeyMap>(temp);

	for (int i = 0; i < clone.SectionLength; i++)
	{
		char key[512];
		clone.GetSectionNameFromIndex(i, key, sizeof(key));

		KeyMap value = clone.GetSection(key);
		if (value != null)
		{
			value = CloneKeyMap(value);
			clone.SetSection(key, value);
			value.Parent = clone;
		}
	}

	return clone;
}

bool IsHiddenKey(const char[] key)
{
	return !strncmp(key, "__", 2);
}

void CleanupKeyMap(KeyMap obj)
{
	if (obj == null)
	{
		return;
	}

	StringMapSnapshot snapshot = obj.Snapshot();
	for (int i = 0; i < snapshot.Length; i += 1)
	{
		char key[512];
		snapshot.GetKey(i, key, sizeof(key));

		KeyMap value = obj.GetSection(key);
		if (value != null)
		{
			CleanupKeyMap(value);
		}
	}

	delete snapshot;

	delete obj;
}
