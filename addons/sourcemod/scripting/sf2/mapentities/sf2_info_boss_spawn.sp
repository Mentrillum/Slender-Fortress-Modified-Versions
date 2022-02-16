// sf2_info_boss_spawn

static const char g_sEntityClassname[] = "sf2_info_boss_spawn"; // The custom classname of the entity. Should be prefixed with "sf2_"

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2BossSpawnEntity < SF2SpawnPointBaseEntity
{
	public SF2BossSpawnEntity(int entIndex) { return view_as<SF2BossSpawnEntity>(SF2SpawnPointBaseEntity(entIndex)); }

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

	property int MaxBosses
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iMaxBosses"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iMaxBosses", value); }
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
		this.GetAbsOrigin(flPos);
		this.GetAbsAngles(flAng);

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
					this.FireOutput("OnSpawn", iBossEntIndex);
				}
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
	g_entityFactory.DeriveFromFactory(SF2BossSpawnEntity.GetBaseFactory());
	g_entityFactory.BeginDataMapDesc()
		.DefineStringField("sf2_szBossProfile", _, "profile")
		.DefineIntField("sf2_iMaxBosses", _, "max")
		.DefineInputFunc("Spawn", InputFuncValueType_Void, InputSpawn)
		.DefineInputFunc("SetBossProfile", InputFuncValueType_String, InputSetBossProfile)
		.EndDataMapDesc();
	g_entityFactory.Install();
}

static void OnCreated(int entity)
{
	SF2BossSpawnEntity thisEnt = SF2BossSpawnEntity(entity);
	thisEnt.SetBossProfile("");
	thisEnt.MaxBosses = 1;
}

static void OnRemoved(int entity)
{
}

static void InputSpawn(int entity, int activator, int caller)
{
	SF2BossSpawnEntity thisEnt = SF2BossSpawnEntity(entity);
	thisEnt.Spawn();
}

static void InputSetBossProfile(int entity, int activator, int caller, const char[] value)
{
	SF2BossSpawnEntity(entity).SetBossProfile(value);
}