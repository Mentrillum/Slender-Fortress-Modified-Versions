#if defined _sf2_methodmaps_included
 #endinput
#endif

#define _sf2_methodmaps_included

const SF2NPC_BaseNPC SF2_INVALID_NPC = view_as<SF2NPC_BaseNPC>(-1);
const SF2NPC_Chaser SF2_INVALID_NPC_CHASER = view_as<SF2NPC_Chaser>(-1);
const SF2NPC_Statue SF2_INVALID_NPC_STATUE = view_as<SF2NPC_Statue>(-1);

methodmap SF2NPC_BaseNPC
{
	property int Index
	{
		public get()
		{
			return view_as<int>(this);
		}
	}

	property int Type
	{
		public get()
		{
			return NPCGetType(this.Index);
		}
	}

	property int ProfileIndex
	{
		public get()
		{
			return NPCGetProfileIndex(this.Index);
		}
	}

	property int uniqueProfileIndex
	{
		public get()
		{
			return NPCGetUniqueProfileIndex(this.Index);
		}
	}

	property int UniqueID
	{
		public get()
		{
			return NPCGetUniqueID(this.Index);
		}
	}

	property int EntRef
	{
		public get()
		{
			return NPCGetEntRef(this.Index);
		}
	}

	property int EntIndex
	{
		public get()
		{
			return NPCGetEntIndex(this.Index);
		}
	}

	property int Flags
	{
		public get()
        {
            return NPCGetFlags(this.Index);
        }
		public set(int flags)
		{
			NPCSetFlags(this.Index, flags);
		}
	}

	property float ModelScale
	{
		public get()
        {
            return NPCGetModelScale(this.Index);
        }
	}

	property int Skin
	{
		public get()
		{
			return NPCGetModelSkin(this.Index);
		}
	}

	property int RaidHitbox
	{
		public get()
		{
			return NPCGetRaidHitbox(this.Index);
		}
	}

	property float TurnRate
	{
		public get()
		{
			return NPCGetTurnRate(this.Index);
		}
	}

	property float FOV
	{
		public get()
		{
			return NPCGetFOV(this.Index);
		}
	}

	property float Anger
	{
		public get()
		{
			return NPCGetAnger(this.Index);
		}
		public set(float amount)
		{
			NPCSetAnger(this.Index, amount);
		}
	}

	property float AngerAddOnPageGrab
	{
		public get()
		{
			return NPCGetAngerAddOnPageGrab(this.Index);
		}
	}

	property float AngerAddOnPageGrabTimeDiff
	{
		public get()
		{
			return NPCGetAngerAddOnPageGrabTimeDiff(this.Index);
		}
	}

	property float ScareRadius
	{
		public get()
		{
			return NPCGetScareRadius(this.Index);
		}
	}

	property float ScareCooldown
	{
		public get()
		{
			return NPCGetScareCooldown(this.Index);
		}
	}

	property float InstantKillRadius
	{
		public get()
		{
			return NPCGetInstantKillRadius(this.Index);
		}
	}

	property int TeleportType
	{
		public get()
		{
			return NPCGetTeleportType(this.Index);
		}
	}

	public float GetTeleportRestPeriod(int difficulty)
	{
		return NPCGetTeleportRestPeriod(this.Index, difficulty);
	}

	public float GetTeleportStressMin(int difficulty)
	{
		return NPCGetTeleportStressMin(this.Index, difficulty);
	}

	public float GetTeleportStressMax(int difficulty)
	{
		return NPCGetTeleportStressMax(this.Index, difficulty);
	}

	public float GetTeleportPersistencyPeriod(int difficulty)
	{
		return NPCGetTeleportPersistencyPeriod(this.Index, difficulty);
	}

	public int GetTeleporter(int teleporterNumber)
	{
		return NPCGetTeleporter(this.Index, teleporterNumber);
	}

	public void SetTeleporter(int teleporterNumber, int entity)
	{
		NPCSetTeleporter(this.Index, teleporterNumber, entity);
	}

	property bool DeathCamEnabled
	{
		public get()
		{
			return NPCHasDeathCamEnabled(this.Index);
		}
		public set(bool state)
		{
			NPCSetDeathCamEnabled(this.Index, state);
		}
	}

	public SF2NPC_BaseNPC(int index)
	{
		return view_as<SF2NPC_BaseNPC>(index);
	}

	public void Spawn(float pos[3])
	{
		SpawnSlender(this, pos);
	}

	public void UnSpawn()
	{
		RemoveSlender(this.Index);
	}

	public void Remove()
	{
		NPCRemove(this.Index);
	}

	property bool CanRemove
	{
		public get()
		{
			SlenderCanRemove(this.Index);
		}
	}

    public void MarkAsFake()
    {
        SlenderMarkAsFake(this.Index);
    }

	public bool IsValid()
	{
		return NPCIsValid(this.Index);
	}

	public void GetProfile(char[] buffer, int bufferLen)
	{
		NPCGetProfile(this.Index, buffer, bufferLen);
	}

	public void SetProfile(const char[] profileName)
	{
		NPCSetProfile(this.Index, profileName);
	}

	public void RemoveFromGame()
	{
		RemoveProfile(this.Index);
	}

	public float GetDistanceFrom(int entity)
	{
		NPCGetDistanceFromEntity(this.Index, entity);
	}

	public float GetSpeed(int difficulty)
	{
		return NPCGetSpeed(this.Index, difficulty);
	}

	public float GetMaxSpeed(int difficulty)
	{
		return NPCGetMaxSpeed(this.Index, difficulty);
	}

	public float GetAddSpeed()
	{
		return NPCGetAddSpeed(this.Index);
	}

	property float AddSpeed
	{
		public get()
		{
			NPCGetAddSpeed(this.Index);
		}
		public set(float amount)
		{
			NPCSetAddSpeed(this.Index, amount);
		}
	}

	property float AddMaxSpeed
	{
		public get()
		{
			NPCGetAddMaxSpeed(this.Index);
		}
		public set(float amount)
		{
			NPCSetAddMaxSpeed(this.Index, amount);
		}
	}

	public float GetAcceleration(int difficulty)
	{
		return NPCGetAcceleration(this.Index, difficulty);
	}

	property float AddAcceleration
	{
		public get()
		{
			NPCGetAddAcceleration(this.Index);
		}
		public set(float amount)
		{
			NPCSetAddAcceleration(this.Index, amount);
		}
	}

	public void GetEyePosition(float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 })
	{
		NPCGetEyePosition(this.Index, buffer, defaultValue);
	}

	public void GetEyePositionOffset(float buffer[3])
	{
		NPCGetEyePositionOffset(this.Index, buffer);
	}

    public int GetRenderColor(int cell)
    {
        return g_SlenderRenderColor[this.Index][cell];
    }

    property int GetRenderMode
    {
        public get()
        {
            return g_SlenderRenderMode[this.Index];
        }
    }

    property int GetRenderFX
    {
        public get()
        {
            return g_SlenderRenderFX[this.Index];
        }
    }

	public void AddAnger(float amount)
	{
		NPCAddAnger(this.Index, amount);
	}

	public bool HasAttribute(const char[] attributeName)
	{
		return NPCHasAttribute(this.Index, attributeName);
	}

	public float GetAttributeValue(const char[] attributeName, float defaultValue = 0.0)
	{
		return NPCGetAttributeValue(this.Index, attributeName, defaultValue);
	}

	public bool CanBeSeen(bool fov = true, bool blink = false)
	{
		return PeopleCanSeeSlender(this.Index, fov, blink);
	}

	public bool PlayerCanSee(int client, bool fov = true, bool blink = false, bool eliminated = false)
	{
		return PlayerCanSeeSlender(client, this.Index, fov, blink, eliminated);
	}
}

methodmap SF2NPC_Chaser < SF2NPC_BaseNPC
{
	property float WakeRadius
	{
		public get()
		{
			return NPCChaserGetWakeRadius(this.Index);
		}
	}

	property bool StunEnabled
	{
		public get()
		{
			return NPCChaserIsStunEnabled(this.Index);
		}
	}

	property bool StunByFlashlightEnabled
	{
		public get()
		{
			return NPCChaserIsStunByFlashlightEnabled(this.Index);
		}
	}

	property float StunFlashlightDamage
	{
		public get()
		{
			return NPCChaserGetStunFlashlightDamage(this.Index);
		}
	}

	property float StunDuration
	{
		public get()
		{
			return NPCChaserGetStunDuration(this.Index);
		}
	}

	property float StunCooldown
	{
		public get()
		{
			return NPCChaserGetStunCooldown(this.Index);
		}
	}

	property float StunHealth
	{
		public get()
		{
			return NPCChaserGetStunHealth(this.Index);
		}
		public set(float amount)
		{
			NPCChaserSetStunHealth(this.Index, amount);
		}
	}

	property float StunInitialHealth
	{
		public get()
		{
			return NPCChaserGetStunInitialHealth(this.Index);
		}
		public set(float amount)
		{
			NPCChaserSetStunInitialHealth(this.Index, amount);
		}
	}

	public void TriggerStun(int entity, char profile[SF2_MAX_PROFILE_NAME_LENGTH], float pos[3])
	{
		NPCBossTriggerStun(this.Index, entity, profile, pos);
	}

	property bool HasDamageParticles
	{
		public get()
		{
			return NPCChaserDamageParticlesEnabled(this.Index);
		}
	}

	property bool UseShootGesture
	{
		public get()
		{
			return NPCChaserUseShootGesture(this.Index);
		}
	}

	property bool CloakEnabled
	{
		public get()
		{
			return NPCChaserIsCloakEnabled(this.Index);
		}
	}

	public float GetCloakCooldown(int difficulty)
	{
		return NPCChaserGetCloakCooldown(this.Index, difficulty);
	}

	public float GetCloakRange(int difficulty)
	{
		return NPCChaserGetCloakRange(this.Index, difficulty);
	}

	public float GetCloakSpeedMultiplier(int difficulty)
	{
		return NPCChaserGetCloakSpeedMultiplier(this.Index, difficulty);
	}

	public float GetCrawlSpeedMultiplier(int difficulty)
	{
		return NPCChaserGetCrawlSpeedMultiplier(this.Index, difficulty);
	}

	property bool HasKeyDrop
	{
		public get()
		{
			return NPCChaseHasKeyDrop(this.Index);
		}
	}

	property bool ProjectileEnabled
	{
		public get()
		{
			return NPCChaserIsProjectileEnabled(this.Index);
		}
	}

	property bool ProjectileUsesAmmo
	{
		public get()
		{
			return NPCChaserUseProjectileAmmo(this.Index);
		}
	}

	property int ProjectileType
	{
		public get()
		{
			return NPCChaserGetProjectileType(this.Index);
		}
	}

	public float GetProjectileCooldownMin(int difficulty)
	{
		return NPCChaserGetProjectileCooldownMin(this.Index, difficulty);
	}

	public float GetProjectileCooldownMax(int difficulty)
	{
		return NPCChaserGetProjectileCooldownMax(this.Index, difficulty);
	}

	public float GetProjectileSpeed(int difficulty)
	{
		return NPCChaserGetProjectileSpeed(this.Index, difficulty);
	}

	public float GetProjectileDamage(int difficulty)
	{
		return NPCChaserGetProjectileDamage(this.Index, difficulty);
	}

	public float GetProjectileRadius(int difficulty)
	{
		return NPCChaserGetProjectileRadius(this.Index, difficulty);
	}

	public float GetProjectileReloadTime(int difficulty)
	{
		return NPCChaserGetProjectileReloadTime(this.Index, difficulty);
	}

	property bool AdvancedDamageEffectsEnabled
	{
		public get()
		{
			return NPCChaserUseAdvancedDamageEffects(this.Index);
		}
	}

	property bool AttachDamageEffectsParticle
	{
		public get()
		{
			return NPCChaserAttachDamageParticle(this.Index);
		}
	}

	property bool JaratePlayerOnHit
	{
		public get()
		{
			return NPCChaserJaratePlayerOnHit(this.Index);
		}
	}

	public float GetJarateDuration(int difficulty)
	{
		return NPCChaserGetJarateDuration(this.Index, difficulty);
	}

	property bool MilkPlayerOnHit
	{
		public get()
		{
			return NPCChaserMilkPlayerOnHit(this.Index);
		}
	}

	public float GetMilkDuration(int difficulty)
	{
		return NPCChaserGetMilkDuration(this.Index, difficulty);
	}

	property bool GasPlayerOnHit
	{
		public get()
		{
			return NPCChaserGasPlayerOnHit(this.Index);
		}
	}

	public float GetGasDuration(int difficulty)
	{
		return NPCChaserGetGasDuration(this.Index, difficulty);
	}

	property bool MarkPlayerOnHit
	{
		public get()
		{
			return NPCChaserMarkPlayerOnHit(this.Index);
		}
	}

	public float GetMarkDuration(int difficulty)
	{
		return NPCChaserGetMarkDuration(this.Index, difficulty);
	}

	property bool IgnitePlayerOnHit
	{
		public get()
		{
			return NPCChaserIgnitePlayerOnHit(this.Index);
		}
	}

	public float GetIgniteDelay(int difficulty)
	{
		return NPCChaserGetIgniteDelay(this.Index, difficulty);
	}

	property bool StunPlayerOnHit
	{
		public get()
		{
			return NPCChaserStunPlayerOnHit(this.Index);
		}
	}

	public float GetStunAttackDuration(int difficulty)
	{
		return NPCChaserGetStunAttackDuration(this.Index, difficulty);
	}

	public float GetStunAttackSlowdown(int difficulty)
	{
		return NPCChaserGetStunAttackSlowdown(this.Index, difficulty);
	}

	property bool BleedPlayerOnHit
	{
		public get()
		{
			return NPCChaserBleedPlayerOnHit(this.Index);
		}
	}

	public float GetBleedDuration(int difficulty)
	{
		return NPCChaserGetBleedDuration(this.Index, difficulty);
	}

	property bool ElectricPlayerOnHit
	{
		public get()
		{
			return NPCChaserElectricPlayerOnHit(this.Index);
		}
	}

	public float GetElectricDuration(int difficulty)
	{
		return NPCChaserGetElectricDuration(this.Index, difficulty);
	}

	public float GetElectricSlowdown(int difficulty)
	{
		return NPCChaserGetElectricSlowdown(this.Index, difficulty);
	}

	property bool SmitePlayerOnHit
	{
		public get()
		{
			return NPCChaserSmitePlayerOnHit(this.Index);
		}
	}

	property int State
	{
		public get()
		{
			return NPCChaserGetState(this.Index);
		}
		public set(int state)
		{
			NPCChaserSetState(this.Index, state);
		}
	}

	property bool HasTraps
	{
		public get()
		{
			return NPCChaserGetTrapState(this.Index);
		}
	}

	property int TrapType
	{
		public get()
		{
			return NPCChaserGetTrapType(this.Index);
		}
	}

	public float GetTrapCooldown(int difficulty)
	{
		return NPCChaserGetTrapSpawnTime(this.Index, difficulty);
	}

	property bool HasCriticalRockets
	{
		public get()
		{
			return NPCChaserHasCriticalRockets(this.Index);
		}
	}

	public float GetWalkSpeed(int difficulty)
	{
		return NPCChaserGetWalkSpeed(this.Index, difficulty);
	}

	public float GetMaxWalkSpeed(int difficulty)
	{
		return NPCChaserGetMaxWalkSpeed(this.Index, difficulty);
	}

	public void AddStunHealth(float amount)
	{
		NPCChaserAddStunHealth(this.Index, amount);
	}

	property bool AutoChaseEnabled
	{
		public get()
		{
			return g_SlenderHasAutoChaseEnabled[this.Index];
		}
		public set(bool autoChase)
		{
			g_SlenderHasAutoChaseEnabled[this.Index] = autoChase;
		}
	}

	property bool ChasesEndlessly
	{
		public get()
		{
			return g_SlenderChasesEndlessly[this.Index];
		}
		public set(bool chaseEndlessly)
		{
			g_SlenderChasesEndlessly[this.Index] = chaseEndlessly;
		}
	}

	public void SetGoalPos(float newPos[3])
	{
		CopyVector(newPos, g_SlenderGoalPos[this.Index]);
	}

	public void GetGoalPos(float dest[3])
	{
		CopyVector(g_SlenderGoalPos[this.Index], dest);
	}

    public void UpdateAnimation(int entity, int state)
    {
        NPCChaserUpdateBossAnimation(this.Index, entity, state);
    }

	public SF2NPC_Chaser(int index)
	{
		return view_as<SF2NPC_Chaser>(SF2NPC_BaseNPC(index));
	}
}

methodmap SF2NPC_Statue < SF2NPC_BaseNPC
{
	public SF2NPC_Statue(int index)
	{
		return view_as<SF2NPC_Statue>(SF2NPC_BaseNPC(index));
	}
}
