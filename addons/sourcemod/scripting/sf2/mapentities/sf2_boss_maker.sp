// sf2_boss_maker

static const char g_sEntityClassname[] = "sf2_boss_maker"; // The custom classname of the entity. Should be prefixed with "sf2_"

#define SF_SF2_BOSS_MAKER_NODROP 1
#define SF_SF2_BOSS_MAKER_ADDONLY 2
#define SF_SF2_BOSS_MAKER_FAKE 4
#define SF_SF2_BOSS_MAKER_NOTELEPORT 8
#define SF_SF2_BOSS_MAKER_ATTACKWAITERS 16
#define SF_SF2_BOSS_MAKER_NOCOMPANIONS 32
#define SF_SF2_BOSS_MAKER_NOSPAWNSOUND 64
#define SF_SF2_BOSS_MAKER_NOCOPIES 128

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2BossMakerEntity < SF2SpawnPointBaseEntity
{
	public SF2BossMakerEntity(int entIndex) { return view_as<SF2BossMakerEntity>(CBaseEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	public void GetBossProfile(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szBossProfile", sBuffer, iBufferLen);
	}

	public void SetBossProfile(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szBossProfile", sBuffer);
	}

	public static void Initialize()
	{
		Initialize();
	}

	property ArrayList Bosses
	{
		public get() { return view_as<ArrayList>(this.GetProp(Prop_Data, "sf2_hBosses")); }
		public set(ArrayList value) { this.SetProp(Prop_Data, "sf2_hBosses", value); } 
	}

	property int SpawnCount
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iSpawnCount"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iSpawnCount", value); }
	}

	property float SpawnRadius
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flSpawnRadius"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flSpawnRadius", value); }
	}

	property int MaxLiveBosses
	{
		public get() { return this.GetProp(Prop_Data, "sf2_nMaxLiveChildren"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_nMaxLiveChildren", value); }
	}

	property int SpawnDestination
	{
		public get() { return this.GetPropEnt(Prop_Data, "sf2_iDestinationEntity"); }
		public set(int entity) { this.SetPropEnt(Prop_Data, "sf2_iDestinationEntity", IsValidEntity(entity) ? entity : INVALID_ENT_REFERENCE); }
	}

	public void GetSpawnDestinationName(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szDestinationName", sBuffer, iBufferLen);
	}

	public void SetSpawnDestinationName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szDestinationName", sBuffer);
	}

	public void GetSpawnAnimation(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szSpawnAnim", sBuffer, iBufferLen);
	}

	public void SetSpawnAnimation(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szSpawnAnim", sBuffer);
	}

	property float SpawnAnimationPlaybackRate
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flSpawnAnimRate"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flSpawnAnimRate", value); }
	}

	property float SpawnAnimationDuration
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flSpawnAnimDuration"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flSpawnAnimDuration", value); }
	}

	property int LiveCount
	{
		public get() 
		{ 
			// Prune the list of invalid IDs.
			for (int i = this.Bosses.Length - 1; i >= 0; i--)
			{
				int iBossID = this.Bosses.Get(i);
				int iBossIndex = NPCGetFromUniqueID(iBossID);
				if (!NPCIsValid(iBossIndex))
					this.Bosses.Erase(i);
			}

			return this.Bosses.Length; 
		}
	}

	public void SpawnBoss(int iBossIndex)
	{
		if (!NPCIsValid(iBossIndex))
			return;
		
		float flPos[3]; float flAng[3];

		CBaseEntity spawnDestination = CBaseEntity(this.SpawnDestination);
		if (spawnDestination.IsValid())
		{
			spawnDestination.GetAbsOrigin(flPos);
			spawnDestination.GetAbsAngles(flAng);
		}
		else 
		{
			this.GetAbsOrigin(flPos);
			this.GetAbsAngles(flAng);
		}

		int iSpawnFlags = this.GetProp(Prop_Data, "m_spawnflags");

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

		CBaseAnimating bossEntity = CBaseAnimating(NPCGetEntIndex(iBossIndex));
		if (bossEntity.IsValid())
		{
			if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_NODROP))
			{
				// Drop (teleport) it to the ground.

				float flMins[3]; float flMaxs[3];
				bossEntity.GetAbsOrigin(flPos);
				bossEntity.GetPropVector(Prop_Send, "m_vecMins", flMins);
				bossEntity.GetPropVector(Prop_Send, "m_vecMaxs", flMaxs);

				float flEndPos[3];
				flEndPos[0] = flPos[0];
				flEndPos[1] = flPos[1];
				flEndPos[2] = flPos[2] - 1024.0;

				TR_TraceHullFilter(flPos, flEndPos, flMins, flMaxs, MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitEntity, bossEntity.index);
				bool bTraceHit = TR_DidHit();
				TR_GetEndPosition(flEndPos);

				if (bTraceHit)
				{
					bossEntity.Teleport(flEndPos, NULL_VECTOR, NULL_VECTOR);
				}
			}

			if (NPCGetType(iBossIndex) == SF2BossType_Chaser)
			{
				char sSpawnAnim[64];
				this.GetSpawnAnimation(sSpawnAnim, sizeof(sSpawnAnim));

				if (sSpawnAnim[0] != '\0')
				{
					float flPlaybackRate = this.SpawnAnimationPlaybackRate;
					float flDuration = this.SpawnAnimationDuration;

					EntitySetAnimation(bossEntity.index, sSpawnAnim, flPlaybackRate);
					EntitySetAnimation(bossEntity.index, sSpawnAnim, flPlaybackRate); //Fix an issue where an anim could start on the wrong frame.

					g_bSlenderSpawning[iBossIndex] = true;
					g_hSlenderSpawnTimer[iBossIndex] = CreateTimer(flDuration, Timer_SlenderSpawnTimer, EntIndexToEntRef(bossEntity.index), TIMER_FLAG_NO_MAPCHANGE);
					g_hSlenderEntityThink[iBossIndex] = null;
				}
			}

			this.FireOutput("OnSpawn", bossEntity.index);
		}
	}

	public void RespawnAllChildren()
	{ 
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int iBossID = this.Bosses.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
			{
				this.Bosses.Erase(i);
				continue;
			}

			this.SpawnBoss(iBossIndex);
		}
	}

	public void DespawnAllChildren()
	{
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int iBossID = this.Bosses.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
			{
				this.Bosses.Erase(i);
				continue;
			}

			RemoveSlender(iBossIndex);
		}
	}

	public void RemoveAllChildren()
	{
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int iBossID = this.Bosses.Get(i);
			int iBossIndex = NPCGetFromUniqueID(iBossID);
			if (!NPCIsValid(iBossIndex))
				continue;

			RemoveProfile(iBossIndex);
		}

		this.Bosses.Clear();
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

		int iSpawnFlags = this.GetProp(Prop_Data, "m_spawnflags");

		// Calculate the spawn destination.
		if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_ADDONLY))
		{
			char sSpawnDestinationName[64];
			this.GetSpawnDestinationName(sSpawnDestinationName, sizeof(sSpawnDestinationName));
			if (sSpawnDestinationName[0] != '\0')
			{
				int iSpawnDestination = this.SpawnDestination;
				if (!IsValidEntity(iSpawnDestination))
				{
					// Find the spawn destination entity and cache it.
					int target = -1;
					while ((target = SF2MapEntity_FindEntityByTargetname(target, sSpawnDestinationName, this.index, this.index, this.index)) != -1)
					{
						if (!IsValidEntity(target))
							continue;
						
						this.SpawnDestination = target;

						break;
					}
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

			this.Bosses.Push(NPCGetUniqueID(iBossIndex));

			if ((iSpawnFlags & SF_SF2_BOSS_MAKER_NOCOPIES))
				NPCSetFlags(iBossIndex, NPCGetFlags(iBossIndex) & ~SFF_COPIES);

			if (!(iSpawnFlags & SF_SF2_BOSS_MAKER_ADDONLY))
			{
				this.SpawnBoss(iBossIndex);
			}
		}
	}
}

static void Initialize() 
{
	g_entityFactory = new CEntityFactory(g_sEntityClassname, OnCreated, OnRemoved);
	g_entityFactory.DeriveFromFactory(SF2BossMakerEntity.GetBaseFactory());
	g_entityFactory.BeginDataMapDesc()
		.DefineStringField("sf2_szBossProfile", _, "profile")
		.DefineIntField("sf2_iSpawnCount", _, "spawncount")
		.DefineFloatField("sf2_flSpawnRadius", _, "spawnradius")
		.DefineIntField("sf2_nMaxLiveChildren", _, "maxlive")
		.DefineEntityField("sf2_iDestinationEntity")
		.DefineStringField("sf2_szDestinationName", _, "spawndestination")
		.DefineStringField("sf2_szSpawnAnim", _, "spawnanim")
		.DefineFloatField("sf2_flSpawnAnimRate", _, "spawnanimrate")
		.DefineFloatField("sf2_flSpawnAnimDuration", _, "spawnanimtime")
		.DefineIntField("sf2_hBosses")
		.DefineInputFunc("Spawn", InputFuncValueType_Void, InputSpawn)
		.DefineInputFunc("SetBossProfile", InputFuncValueType_String, InputSetBossProfile)
		.DefineInputFunc("SetSpawnRadius", InputFuncValueType_Float, InputSetSpawnRadius)
		.DefineInputFunc("SetMaxLiveChildren", InputFuncValueType_Integer, InputSetMaxLiveChildren)
		.DefineInputFunc("SetSpawnDestination", InputFuncValueType_String, InputSetSpawnDestination)
		.DefineInputFunc("RespawnAll", InputFuncValueType_Void, InputRespawnAll)
		.DefineInputFunc("DespawnAll", InputFuncValueType_Void, InputDespawnAll)
		.DefineInputFunc("RemoveAll", InputFuncValueType_Void, InputRemoveAll)
		.DefineInputFunc("SetSpawnAnimation", InputFuncValueType_String, InputSetSpawnAnimation)
		.DefineInputFunc("SetSpawnAnimationPlaybackRate", InputFuncValueType_Float, InputSetSpawnAnimationPlaybackRate)
		.DefineInputFunc("SetSpawnAnimationDuration", InputFuncValueType_Float, InputSetSpawnAnimationDuration)
		.EndDataMapDesc();
	g_entityFactory.Install();
}

static void OnCreated(int entity)
{
	SF2BossMakerEntity thisEnt = SF2BossMakerEntity(entity);
	thisEnt.Bosses = new ArrayList();
	thisEnt.SetBossProfile("");
	thisEnt.SpawnCount = 1;
	thisEnt.SpawnRadius = 0.0;
	thisEnt.MaxLiveBosses = -1;
	thisEnt.SpawnDestination = INVALID_ENT_REFERENCE;
	thisEnt.SetSpawnDestinationName("");
	thisEnt.SetSpawnAnimation("");
	thisEnt.SpawnAnimationPlaybackRate = 1.0;
	thisEnt.SpawnAnimationDuration = 0.0;
}

static void OnRemoved(int entity)
{
	SF2BossMakerEntity thisEnt = SF2BossMakerEntity(entity);
	if (thisEnt.Bosses != null)
	{
		delete thisEnt.Bosses;
	}
}

static void InputSpawn(int entity, int activator, int caller)
{
	SF2BossMakerEntity(entity).Spawn();
}

static void InputSetBossProfile(int entity, int activator, int caller, const char[] value)
{
	SF2BossMakerEntity(entity).SetBossProfile(value);
}

static void InputSetSpawnRadius(int entity, int activator, int caller, float value)
{
	SF2BossMakerEntity(entity).SpawnRadius = value;
}

static void InputSetMaxLiveChildren(int entity, int activator, int caller, int value)
{
	SF2BossMakerEntity(entity).MaxLiveBosses = value;
}

static void InputSetSpawnDestination(int _entity, int activator, int caller, const char[] value)
{
	SF2BossMakerEntity entity = SF2BossMakerEntity(_entity);
	entity.SetSpawnAnimation(value);
	entity.SpawnDestination = INVALID_ENT_REFERENCE; // mark as dirty.
}

static void InputRespawnAll(int entity, int activator, int caller)
{
	SF2BossMakerEntity(entity).RespawnAllChildren();
}

static void InputDespawnAll(int entity, int activator, int caller)
{
	SF2BossMakerEntity(entity).DespawnAllChildren();
}

static void InputRemoveAll(int entity, int activator, int caller)
{
	SF2BossMakerEntity(entity).RemoveAllChildren();
}

static void InputSetSpawnAnimation(int entity, int activator, int caller, const char[] value)
{
	SF2BossMakerEntity(entity).SetSpawnAnimation(value);
}

static void InputSetSpawnAnimationPlaybackRate(int entity, int activator, int caller, float value)
{
	SF2BossMakerEntity(entity).SpawnAnimationPlaybackRate = value;
}

static void InputSetSpawnAnimationDuration(int entity, int activator, int caller, float value)
{
	SF2BossMakerEntity(entity).SpawnAnimationDuration = value;
}