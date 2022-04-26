// sf2_boss_maker

static const char g_EntityClassname[] = "sf2_boss_maker"; // The custom classname of the entity. Should be prefixed with "sf2_"

#define SF_SF2_BOSS_MAKER_NODROP 1
#define SF_SF2_BOSS_MAKER_ADDONLY 2
#define SF_SF2_BOSS_MAKER_FAKE 4
#define SF_SF2_BOSS_MAKER_NOTELEPORT 8
#define SF_SF2_BOSS_MAKER_ATTACKWAITERS 16
#define SF_SF2_BOSS_MAKER_NOCOMPANIONS 32
#define SF_SF2_BOSS_MAKER_NOSPAWNSOUND 64
#define SF_SF2_BOSS_MAKER_NOCOPIES 128

static CEntityFactory g_EntityFactory;

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

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public void GetBossProfile(char[] buffer, int bufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szBossProfile", buffer, bufferLen);
	}

	public void SetBossProfile(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_szBossProfile", buffer);
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

	public void GetSpawnDestinationName(char[] buffer, int bufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szDestinationName", buffer, bufferLen);
	}

	public void SetSpawnDestinationName(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_szDestinationName", buffer);
	}

	public void GetSpawnAnimation(char[] buffer, int bufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szSpawnAnim", buffer, bufferLen);
	}

	public void SetSpawnAnimation(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_szSpawnAnim", buffer);
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
				int bossID = this.Bosses.Get(i);
				int bossIndex = NPCGetFromUniqueID(bossID);
				if (!NPCIsValid(bossIndex))
				{
					this.Bosses.Erase(i);
				}
			}

			return this.Bosses.Length; 
		}
	}

	public void SpawnBoss(int bossIndex)
	{
		if (!NPCIsValid(bossIndex))
		{
			return;
		}
		
		float pos[3]; float ang[3];

		CBaseEntity spawnDestination = CBaseEntity(this.SpawnDestination);
		if (spawnDestination.IsValid())
		{
			spawnDestination.GetAbsOrigin(pos);
			spawnDestination.GetAbsAngles(ang);
		}
		else 
		{
			this.GetAbsOrigin(pos);
			this.GetAbsAngles(ang);
		}

		int spawnFlags = this.GetProp(Prop_Data, "m_spawnflags");

		float spawnRadius = this.SpawnRadius;
		if (spawnRadius > 0.0)
		{
			float rad = GetRandomFloat(0.0, 2.0 * FLOAT_PI);
			float radius = GetRandomFloat(0.0, spawnRadius);
			float vec[3];
			vec[0] = Cosine(rad) * radius; 
			vec[1] = Sine(rad) * radius;

			pos[0] += vec[0];
			pos[1] += vec[1];
		}

		SpawnSlender(view_as<SF2NPC_BaseNPC>(bossIndex), pos);

		CBaseAnimating bossEntity = CBaseAnimating(NPCGetEntIndex(bossIndex));
		if (bossEntity.IsValid())
		{
			if (!(spawnFlags & SF_SF2_BOSS_MAKER_NODROP))
			{
				// Drop (teleport) it to the ground.

				float mins[3]; float maxs[3];
				bossEntity.GetAbsOrigin(pos);
				bossEntity.GetPropVector(Prop_Send, "m_vecMins", mins);
				bossEntity.GetPropVector(Prop_Send, "m_vecMaxs", maxs);

				float endPos[3];
				endPos[0] = pos[0];
				endPos[1] = pos[1];
				endPos[2] = pos[2] - 1024.0;

				TR_TraceHullFilter(pos, endPos, mins, maxs, MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitEntity, bossEntity.index);
				bool traceHit = TR_DidHit();
				TR_GetEndPosition(endPos);

				if (traceHit)
				{
					bossEntity.Teleport(endPos, NULL_VECTOR, NULL_VECTOR);
				}
			}

			if (NPCGetType(bossIndex) == SF2BossType_Chaser)
			{
				char spawnAnim[64];
				this.GetSpawnAnimation(spawnAnim, sizeof(spawnAnim));

				if (spawnAnim[0] != '\0')
				{
					float playbackRate = this.SpawnAnimationPlaybackRate;
					float duration = this.SpawnAnimationDuration;

					EntitySetAnimation(bossEntity.index, spawnAnim, playbackRate);
					EntitySetAnimation(bossEntity.index, spawnAnim, playbackRate); //Fix an issue where an anim could start on the wrong frame.

					g_SlenderSpawning[bossIndex] = true;
					g_SlenderSpawnTimer[bossIndex] = CreateTimer(duration, Timer_SlenderSpawnTimer, EntIndexToEntRef(bossEntity.index), TIMER_FLAG_NO_MAPCHANGE);
					g_SlenderEntityThink[bossIndex] = null;
				}
			}

			this.FireOutput("OnSpawn", bossEntity.index);
		}
	}

	public void RespawnAllChildren()
	{ 
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int bossID = this.Bosses.Get(i);
			int bossIndex = NPCGetFromUniqueID(bossID);
			if (!NPCIsValid(bossIndex))
			{
				this.Bosses.Erase(i);
				continue;
			}

			this.SpawnBoss(bossIndex);
		}
	}

	public void DespawnAllChildren()
	{
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int bossID = this.Bosses.Get(i);
			int bossIndex = NPCGetFromUniqueID(bossID);
			if (!NPCIsValid(bossIndex))
			{
				this.Bosses.Erase(i);
				continue;
			}

			RemoveSlender(bossIndex);
		}
	}

	public void RemoveAllChildren()
	{
		for (int i = this.Bosses.Length - 1; i >= 0; i--)
		{
			int bossID = this.Bosses.Get(i);
			int bossIndex = NPCGetFromUniqueID(bossID);
			if (!NPCIsValid(bossIndex))
			{
				continue;
			}

			RemoveProfile(bossIndex);
		}

		this.Bosses.Clear();
	}

	public void Spawn()
	{
		char targetProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		this.GetBossProfile(targetProfile, sizeof(targetProfile));
		if (targetProfile[0] == '\0')
		{
			PrintToServer("%s tried to spawn with blank profile", g_EntityClassname);
			return;
		}

		int liveCount = this.LiveCount;

		if (this.MaxLiveBosses != -1 && liveCount >= this.MaxLiveBosses)
		{
			return; // Hit limit; don't spawn.
		}

		int spawnFlags = this.GetProp(Prop_Data, "m_spawnflags");

		// Calculate the spawn destination.
		if (!(spawnFlags & SF_SF2_BOSS_MAKER_ADDONLY))
		{
			char spawnDestinationName[64];
			this.GetSpawnDestinationName(spawnDestinationName, sizeof(spawnDestinationName));
			if (spawnDestinationName[0] != '\0')
			{
				int spawnDestination = this.SpawnDestination;
				if (!IsValidEntity(spawnDestination))
				{
					// Find the spawn destination entity and cache it.
					int target = -1;
					while ((target = SF2MapEntity_FindEntityByTargetname(target, spawnDestinationName, this.index, this.index, this.index)) != -1)
					{
						if (!IsValidEntity(target))
						{
							continue;
						}
						
						this.SpawnDestination = target;

						break;
					}
				}
			}
		}

		int maxCount = this.SpawnCount;
		if (this.MaxLiveBosses != -1)
		{
			int maxCanSpawnCount = this.MaxLiveBosses - liveCount;
			maxCount = maxCount > maxCanSpawnCount ? maxCanSpawnCount : maxCount;
		}

		int bossFlags = 0;
		if (spawnFlags & SF_SF2_BOSS_MAKER_FAKE)
		{
			bossFlags |= SFF_FAKE;
		}
		if (spawnFlags & SF_SF2_BOSS_MAKER_NOTELEPORT)
		{
			bossFlags |= SFF_NOTELEPORT;
		}
		if (spawnFlags & SF_SF2_BOSS_MAKER_ATTACKWAITERS)
		{
			bossFlags |= SFF_ATTACKWAITERS;
		}

		bool spawnCompanions = true;
		bool playSpawnSound = true;
		if (spawnFlags & SF_SF2_BOSS_MAKER_NOCOMPANIONS)
		{
			spawnCompanions = false;
		}
		if (spawnFlags & SF_SF2_BOSS_MAKER_NOSPAWNSOUND)
		{
			playSpawnSound = false;
		}

		for (int i = 0; i < maxCount; i++)
		{
			int bossIndex = view_as<int>(AddProfile(targetProfile, bossFlags, _, spawnCompanions, playSpawnSound));
			if (!NPCIsValid(bossIndex))
			{
				continue;
			}

			this.Bosses.Push(NPCGetUniqueID(bossIndex));

			if ((spawnFlags & SF_SF2_BOSS_MAKER_NOCOPIES))
			{
				NPCSetFlags(bossIndex, NPCGetFlags(bossIndex) & ~SFF_COPIES);
			}

			if (!(spawnFlags & SF_SF2_BOSS_MAKER_ADDONLY))
			{
				this.SpawnBoss(bossIndex);
			}
		}
	}
}

static void Initialize() 
{
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreated, OnRemoved);
	g_EntityFactory.DeriveFromFactory(SF2BossMakerEntity.GetBaseFactory());
	g_EntityFactory.BeginDataMapDesc()
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
	g_EntityFactory.Install();
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