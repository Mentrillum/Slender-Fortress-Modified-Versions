// sf2_info_boss_spawn

static const char g_sEntityClassname[] = "sf2_info_boss_spawn"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

/**
 *	Internal data stored for the entity.
 */
enum struct SF2BossSpawnEntityData
{
	int EntRef;
	char BossProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	int MaxBosses;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.BossProfile[0] = '\0';
		this.MaxBosses = 1;
	}

	void Destroy()
	{
	}

	void SetBossProfile(const char[] sProfile)
	{
		strcopy(this.BossProfile, SF2_MAX_PROFILE_NAME_LENGTH, sProfile);
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2BossSpawnEntity < SF2MapEntity
{
	public SF2BossSpawnEntity(int entIndex) { return view_as<SF2BossSpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2BossSpawnEntityData entData;
		return (SF2BossSpawnEntityData_Get(this.EntRef, entData) != -1);
	}

	public void GetBossProfile(char[] sBuffer, int iBufferLen)
	{
		SF2BossSpawnEntityData entData; SF2BossSpawnEntityData_Get(this.EntRef, entData); 
		strcopy(sBuffer, iBufferLen, entData.BossProfile);
	}

	property int MaxBosses
	{
		public get() { SF2BossSpawnEntityData entData; SF2BossSpawnEntityData_Get(this.EntRef, entData); return entData.MaxBosses; }
	}

	public void Spawn()
	{
		char sTargetProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		this.GetBossProfile(sTargetProfile, sizeof(sTargetProfile));
		if (sTargetProfile[0] == '\0')
		{
			PrintToServer("%s tried to spawn with blank profile", g_sEntityClassname);
			return;
		}

		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];

		float flPos[3]; float flAng[3];
		GetEntPropVector(this.EntRef, Prop_Data, "m_vecAbsOrigin", flPos);
		GetEntPropVector(this.EntRef, Prop_Data, "m_angAbsRotation", flAng);

		int iCount = 0;
		int iMaxCount = this.MaxBosses;

		for (int iBossIndex = 0; iBossIndex < MAX_BOSSES && iCount < iMaxCount; iBossIndex++)
		{
			if (!NPCIsValid(iBossIndex))
				continue;

			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
			if (strcmp(sProfile, sTargetProfile) == 0)
			{
				SpawnSlender(view_as<SF2NPC_BaseNPC>(iBossIndex), flPos);
				iCount++;

				int iBossEntIndex = NPCGetEntIndex(iBossIndex);
				if (IsValidEntity(iBossEntIndex))
				{
					TeleportEntity(iBossEntIndex, NULL_VECTOR, flAng, NULL_VECTOR);
					this.FireOutputNoVariant("OnSpawn", iBossEntIndex, this.EntRef);
				}
			}
		}
	}
}

void SF2BossSpawnEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2BossSpawnEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2BossSpawnEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2BossSpawnEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2BossSpawnEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2BossSpawnEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2BossSpawnEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2BossSpawnEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2BossSpawnEntity_OnMapStart);
}

static void SF2BossSpawnEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2BossSpawnEntity_OnMapStart() 
{
}

static void SF2BossSpawnEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2BossSpawnEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2BossSpawnEntity_SpawnPost);
}

static Action SF2BossSpawnEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2BossSpawnEntityData entData;
	int iIndex = SF2BossSpawnEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;
	
	SF2BossSpawnEntity spawnPoint = SF2BossSpawnEntity(entity);

	if (strcmp(szKeyName, "profile", false) == 0)
	{
		entData.SetBossProfile(szValue);
		SF2BossSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "max", false) == 0)
	{
		int iValue = StringToInt(szValue);
		if (iValue < 0)
			iValue = 0;

		entData.MaxBosses = iValue;
		SF2BossSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnSpawn", false) == 0)
	{
		spawnPoint.AddOutput(szKeyName, szValue);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2BossSpawnEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2BossSpawnEntityData entData;
	int iIndex = SF2BossSpawnEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;
	
	SF2BossSpawnEntity spawnPoint = SF2BossSpawnEntity(entity);

	if (strcmp(szInputName, "Spawn", false) == 0)
	{
		spawnPoint.Spawn();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetBossProfile", false) == 0)
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		SF2MapEntity_GetStringFromVariant(sProfile, sizeof(sProfile));

		entData.SetBossProfile(sProfile);
		SF2BossSpawnEntityData_Update(entData);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void SF2BossSpawnEntity_SpawnPost(int entity) 
{
}

static void SF2BossSpawnEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2BossSpawnEntityData entData;
	int iIndex = SF2BossSpawnEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2BossSpawnEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2BossSpawnEntityData_Get(int entIndex, SF2BossSpawnEntityData entData)
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

static int SF2BossSpawnEntityData_Update(SF2BossSpawnEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}