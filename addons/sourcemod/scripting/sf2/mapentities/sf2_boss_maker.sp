// sf2_boss_maker

static const char g_sEntityClassname[] = "sf2_boss_maker"; // The custom classname of the entity. Should be prefixed with "sf2_"
static const char g_sEntityTranslatedClassname[] = "info_target"; // The actual, underlying game entity that exists, like "info_target" or "game_text".

static ArrayList g_EntityData;

#define SF_SF2_BOSS_MAKER_NODROP 1
#define SF_SF2_BOSS_MAKER_ADDONLY 2
#define SF_SF2_BOSS_MAKER_FAKE 4
#define SF_SF2_BOSS_MAKER_NOTELEPORT 8
#define SF_SF2_BOSS_MAKER_ATTACKWAITERS 16
#define SF_SF2_BOSS_MAKER_NOCOMPANIONS 32
#define SF_SF2_BOSS_MAKER_NOSPAWNSOUND 64
#define SF_SF2_BOSS_MAKER_NOCOPIES 128

/**
 *	Internal data stored for the entity.
 */
enum struct SF2BossMakerEntityData
{
	int EntRef;
	char BossProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	int SpawnCount;
	float SpawnRadius;
	int MaxLiveBosses;
	int SpawnDestination;
	char SpawnDestinationName[64];
	char SpawnAnimation[64];
	float SpawnAnimationPlaybackRate;
	float SpawnAnimationDuration;
	ArrayList Bosses;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.BossProfile[0] = '\0';
		this.SpawnCount = 1;
		this.SpawnRadius = 0.0;
		this.MaxLiveBosses = -1;
		this.SpawnDestination = INVALID_ENT_REFERENCE;
		this.SpawnDestinationName[0] = '\0';
		this.SpawnAnimation[0] = '\0';
		this.SpawnAnimationPlaybackRate = 1.0;
		this.SpawnAnimationDuration = 0.0;

		this.Bosses = new ArrayList();
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for this.Bosses in SF2BossMakerEntityData.", this.Bosses);
		#endif
	}

	void Destroy()
	{
		if (this.Bosses != null)
		{
			delete this.Bosses;
			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for this.Bosses in SF2BossMakerEntityData.", this.Bosses);
			#endif
		}
	}

	void SetBossProfile(const char[] sProfile)
	{
		strcopy(this.BossProfile, SF2_MAX_PROFILE_NAME_LENGTH, sProfile);
	}

	void SetSpawnDestinationName(const char[] sTargetName)
	{
		strcopy(this.SpawnDestinationName, 64, sTargetName);
	}

	void SetSpawnAnimation(const char[] sAnimation)
	{
		strcopy(this.SpawnAnimation, 64, sAnimation);
	}
}

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2BossMakerEntity < SF2MapEntity
{
	public SF2BossMakerEntity(int entIndex) { return view_as<SF2BossMakerEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2BossMakerEntityData entData;
		return (SF2BossMakerEntityData_Get(this.EntRef, entData) != -1);
	}

	public void GetBossProfile(char[] sBuffer, int iBufferLen)
	{
		SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); 
		strcopy(sBuffer, iBufferLen, entData.BossProfile);
	}

	property int SpawnCount
	{
		public get() { SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); return entData.SpawnCount; }
	}

	property float SpawnRadius
	{
		public get() { SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); return entData.SpawnRadius; }
	}

	property int MaxLiveBosses
	{
		public get() { SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); return entData.MaxLiveBosses; }
	}

	property int SpawnDestination
	{
		public get() { SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); return entData.SpawnDestination; }
		public set(int entity)
		{ 
			SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData);
			if (!IsValidEntity(entity)) 
			{
				entData.SpawnDestination = INVALID_ENT_REFERENCE;
				SF2BossMakerEntityData_Update(entData);
				return;
			}

			entData.SpawnDestination = EnsureEntRef(entity);
			SF2BossMakerEntityData_Update(entData);
		}
	}

	public void GetSpawnDestinationName(char[] sBuffer, int iBufferLen)
	{
		SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); 
		strcopy(sBuffer, iBufferLen, entData.SpawnDestinationName);
	}

	public void GetSpawnAnimation(char[] sBuffer, int iBufferLen)
	{
		SF2BossMakerEntityData entData; SF2BossMakerEntityData_Get(this.EntRef, entData); 
		strcopy(sBuffer, iBufferLen, entData.SpawnAnimation);
	}

	property int LiveCount
	{
		public get() 
		{ 
			SF2BossMakerEntityData entData; 
			SF2BossMakerEntityData_Get(this.EntRef, entData);
			
			// Prune the list of invalid IDs.
			ArrayList bossIds = entData.Bosses;
			for (int i = bossIds.Length - 1; i >= 0; i--)
			{
				int iBossID = bossIds.Get(i);
				int iBossIndex = NPCGetFromUniqueID(iBossID);
				if (!NPCIsValid(iBossIndex))
					bossIds.Erase(i);
			}

			return bossIds.Length; 
		}
	}

	public void SpawnBoss(int iBossIndex)
	{
		if (!NPCIsValid(iBossIndex))
			return;
		
		SF2BossMakerEntityData entData; 
		SF2BossMakerEntityData_Get(this.EntRef, entData);

		float flPos[3]; float flAng[3];

		int iSpawnDestination = entData.SpawnDestination;
		if (IsValidEntity(iSpawnDestination))
		{
			GetEntPropVector(iSpawnDestination, Prop_Data, "m_vecAbsOrigin", flPos);
			GetEntPropVector(iSpawnDestination, Prop_Data, "m_angAbsRotation", flAng);
		}
		else 
		{
			GetEntPropVector(this.EntRef, Prop_Data, "m_vecAbsOrigin", flPos);
			GetEntPropVector(this.EntRef, Prop_Data, "m_angAbsRotation", flAng);
		}

		int iSpawnFlags = GetEntProp(this.EntRef, Prop_Data, "m_spawnflags");

		float flSpawnRadius = this.SpawnRadius;
		if (flSpawnRadius > 0.0)
		{
			float flRad = GetRandomFloat(0.0, 2.0 * FLOAT_PI);
			float flRadius = GetRandomFloat(0.0, flSpawnRadius);
			float flVec[3];
			flVec[0] = Cosine(flRad) * flRadius; 
			flVec[1] = Sine(flRad) * flRadius;

			flPos[0] += flVec[0];
			flPos[1] += flVec[1];
		}

		SpawnSlender(view_as<SF2NPC_BaseNPC>(iBossIndex), flPos);

		int iBossEntIndex = NPCGetEntIndex(iBossIndex);
		if (IsValidEntity(iBossEntIndex))
		{
			TeleportEntity(iBossEntIndex, NULL_VECTOR, flAng, NULL_VECTOR);

			if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_NODROP))
			{
				// Drop (teleport) it to the ground.

				float flMins[3]; float flMaxs[3];
				GetEntPropVector(iBossEntIndex, Prop_Data, "m_vecAbsOrigin", flPos);
				GetEntPropVector(iBossEntIndex, Prop_Send, "m_vecMins", flMins);
				GetEntPropVector(iBossEntIndex, Prop_Send, "m_vecMaxs", flMaxs);

				float flEndPos[3];
				flEndPos[0] = flPos[0];
				flEndPos[1] = flPos[1];
				flEndPos[2] = flPos[2] - 1024.0;

				Handle hTrace = TR_TraceHullFilterEx(flPos, flEndPos, flMins, flMaxs, MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitEntity, iBossEntIndex);
				bool bTraceHit = TR_DidHit(hTrace);
				TR_GetEndPosition(flEndPos, hTrace);
				delete hTrace;

				if (bTraceHit)
				{
					TeleportEntity(iBossEntIndex, flEndPos, NULL_VECTOR, NULL_VECTOR);
				}
			}

			if (NPCGetType(iBossIndex) == SF2BossType_Chaser && entData.SpawnAnimation[0] != '\0')
			{
				float flPlaybackRate = entData.SpawnAnimationPlaybackRate;
				float flDuration = entData.SpawnAnimationDuration;

				EntitySetAnimation(iBossEntIndex, entData.SpawnAnimation, flPlaybackRate);
				EntitySetAnimation(iBossEntIndex, entData.SpawnAnimation, flPlaybackRate); //Fix an issue where an anim could start on the wrong frame.

				g_bSlenderSpawning[iBossIndex] = true;
				g_hSlenderSpawnTimer[iBossIndex] = CreateTimer(flDuration, Timer_SlenderSpawnTimer, EntIndexToEntRef(iBossEntIndex), TIMER_FLAG_NO_MAPCHANGE);
				g_hSlenderEntityThink[iBossIndex] = null;
			}

			this.FireOutputNoVariant("OnSpawn", iBossEntIndex, this.EntRef);
		}
	}

	public void RespawnAllChildren()
	{
		SF2BossMakerEntityData entData; 
		SF2BossMakerEntityData_Get(this.EntRef, entData);

		ArrayList bossIds = entData.Bosses; 
		for (int i = bossIds.Length - 1; i >= 0; i--)
		{
			int iBossID = bossIds.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
			{
				bossIds.Erase(i);
				continue;
			}

			this.SpawnBoss(iBossIndex);
		}
	}

	public void DespawnAllChildren()
	{
		SF2BossMakerEntityData entData; 
		SF2BossMakerEntityData_Get(this.EntRef, entData);

		ArrayList bossIds = entData.Bosses; 
		for (int i = bossIds.Length - 1; i >= 0; i--)
		{
			int iBossID = bossIds.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
			{
				bossIds.Erase(i);
				continue;
			}

			RemoveSlender(iBossIndex);
		}
	}

	public void RemoveAllChildren()
	{
		SF2BossMakerEntityData entData; 
		SF2BossMakerEntityData_Get(this.EntRef, entData);

		ArrayList bossIds = entData.Bosses; 
		for (int i = bossIds.Length - 1; i >= 0; i--)
		{
			int iBossID = bossIds.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
				continue;

			RemoveProfile(iBossIndex);
		}

		bossIds.Clear();
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

		int iLiveCount = this.LiveCount;

		if (this.MaxLiveBosses != -1 && iLiveCount >= this.MaxLiveBosses)
			return; // Hit limit; don't spawn.

		SF2BossMakerEntityData entData; 
		SF2BossMakerEntityData_Get(this.EntRef, entData);

		int iSpawnFlags = GetEntProp(this.EntRef, Prop_Data, "m_spawnflags");

		// Calculate the spawn destination.
		if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_ADDONLY) && entData.SpawnDestinationName[0] != '\0')
		{
			int iSpawnDestination = entData.SpawnDestination;
			if (!IsValidEntity(iSpawnDestination))
			{
				// Find the spawn destination entity and cache it.
				int target = -1;
				while ((target = SF2MapEntity_FindEntityByTargetname(target, entData.SpawnDestinationName, this.EntRef, this.EntRef, this.EntRef)) != -1)
				{
					if (!IsValidEntity(target))
						continue;
					
					iSpawnDestination = EnsureEntRef(target);
					entData.SpawnDestination = target;
					SF2BossMakerEntityData_Update(entData);

					break;
				}
			}
		}

		int iMaxCount = this.SpawnCount;
		if (this.MaxLiveBosses != -1)
		{
			int iMaxCanSpawnCount = this.MaxLiveBosses - iLiveCount;
			iMaxCount = iMaxCount > iMaxCanSpawnCount ? iMaxCanSpawnCount : iMaxCount;
		}

		int iBossFlags = 0;
		if (iSpawnFlags & SF_SF2_BOSS_MAKER_FAKE)
			iBossFlags |= SFF_FAKE;
		if (iSpawnFlags & SF_SF2_BOSS_MAKER_NOTELEPORT)
			iBossFlags |= SFF_NOTELEPORT;
		if (iSpawnFlags & SF_SF2_BOSS_MAKER_ATTACKWAITERS)
			iBossFlags |= SFF_ATTACKWAITERS;

		bool bSpawnCompanions = true;
		bool bPlaySpawnSound = true;
		if (iSpawnFlags & SF_SF2_BOSS_MAKER_NOCOMPANIONS)
			bSpawnCompanions = false;
		if (iSpawnFlags & SF_SF2_BOSS_MAKER_NOSPAWNSOUND)
			bPlaySpawnSound = false;

		for (int i = 0; i < iMaxCount; i++)
		{
			int iBossIndex = view_as<int>(AddProfile(sTargetProfile, iBossFlags, _, bSpawnCompanions, bPlaySpawnSound));
			if (!NPCIsValid(iBossIndex))
				continue;

			entData.Bosses.Push(NPCGetUniqueID(iBossIndex));

			if ((iSpawnFlags & SF_SF2_BOSS_MAKER_NOCOPIES))
				NPCSetFlags(iBossIndex, NPCGetFlags(iBossIndex) & ~SFF_COPIES);

			if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_ADDONLY))
			{
				this.SpawnBoss(iBossIndex);
			}
		}
	}
}

void SF2BossMakerEntity_Initialize() 
{
	g_EntityData = new ArrayList(sizeof(SF2BossMakerEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2BossMakerEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2BossMakerEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2BossMakerEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2BossMakerEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2BossMakerEntity_OnEntityKeyValue);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2BossMakerEntity_OnLevelInit);
	//SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2BossMakerEntity_OnMapStart);
}

/*
static void SF2BossMakerEntity_OnLevelInit(const char[] sMapName) 
{
}

static void SF2BossMakerEntity_OnMapStart() 
{
}
*/

static void SF2BossMakerEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2BossMakerEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	//SDKHook(entity, SDKHook_SpawnPost, SF2BossMakerEntity_SpawnPost);
}

static Action SF2BossMakerEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2BossMakerEntityData entData;
	int iIndex = SF2BossMakerEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;
	
	SF2BossMakerEntity spawnPoint = SF2BossMakerEntity(entity);

	if (strcmp(szKeyName, "profile", false) == 0)
	{
		entData.SetBossProfile(szValue);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawncount", false) == 0)
	{
		int iValue = StringToInt(szValue);
		if (iValue < 0)
			iValue = 0;

		entData.SpawnCount = iValue;
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawnradius", false) == 0)
	{
		float flValue = StringToFloat(szValue);
		if (flValue < 0.0)
			flValue = 0.0;

		entData.SpawnRadius = flValue;
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "maxlive", false) == 0)
	{
		entData.MaxLiveBosses = StringToInt(szValue);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawndestination", false) == 0)
	{
		entData.SetSpawnDestinationName(szValue);
		entData.SpawnDestination = INVALID_ENT_REFERENCE; // mark as dirty.
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawnanim", false) == 0)
	{
		entData.SetSpawnAnimation(szValue);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawnanimrate", false) == 0)
	{
		entData.SpawnAnimationPlaybackRate = StringToFloat(szValue);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "spawnanimtime", false) == 0)
	{
		entData.SpawnAnimationDuration = StringToFloat(szValue);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnSpawn", false) == 0)
	{
		spawnPoint.AddOutput(szKeyName, szValue);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2BossMakerEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2BossMakerEntityData entData;
	int iIndex = SF2BossMakerEntityData_Get(entity, entData);
	if (iIndex == -1)
		return Plugin_Continue;
	
	SF2BossMakerEntity spawnPoint = SF2BossMakerEntity(entity);

	if (strcmp(szInputName, "Spawn", false) == 0)
	{
		spawnPoint.Spawn();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "RespawnAll", false) == 0)
	{
		spawnPoint.RespawnAllChildren();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DespawnAll", false) == 0)
	{
		spawnPoint.DespawnAllChildren();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "RemoveAll", false) == 0)
	{
		spawnPoint.RemoveAllChildren();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetSpawnRadius", false) == 0)
	{
		entData.SpawnRadius = SF2MapEntity_GetFloatFromVariant();
		if (entData.SpawnRadius < 0.0) entData.SpawnRadius = 0.0;
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetMaxLiveChildren", false) == 0)
	{
		entData.MaxLiveBosses = SF2MapEntity_GetIntFromVariant();
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetSpawnDestination", false) == 0)
	{
		char sDestinationName[64];
		SF2MapEntity_GetStringFromVariant(sDestinationName, sizeof(sDestinationName));

		entData.SetSpawnDestinationName(sDestinationName);
		entData.SpawnDestination = INVALID_ENT_REFERENCE; // mark as dirty.
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetBossProfile", false) == 0)
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		SF2MapEntity_GetStringFromVariant(sProfile, sizeof(sProfile));

		entData.SetBossProfile(sProfile);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetSpawnAnimation", false) == 0)
	{
		char sAnimation[64];
		SF2MapEntity_GetStringFromVariant(sAnimation, sizeof(sAnimation));

		entData.SetSpawnAnimation(sAnimation);
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetSpawnAnimationPlaybackRate", false) == 0)
	{
		entData.SpawnAnimationPlaybackRate = SF2MapEntity_GetFloatFromVariant();
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetSpawnAnimationDuration", false) == 0)
	{
		entData.SpawnAnimationDuration = SF2MapEntity_GetFloatFromVariant();
		SF2BossMakerEntityData_Update(entData);

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

/*
static void SF2BossMakerEntity_SpawnPost(int entity) 
{
}
*/

static void SF2BossMakerEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2BossMakerEntityData entData;
	int iIndex = SF2BossMakerEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2BossMakerEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2BossMakerEntityData_Get(int entIndex, SF2BossMakerEntityData entData)
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

static int SF2BossMakerEntityData_Update(SF2BossMakerEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}