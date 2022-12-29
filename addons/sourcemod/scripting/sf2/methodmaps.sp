#if defined _sf2_methodmaps_included
 #endinput
#endif

#define _sf2_methodmaps_included

#pragma semicolon 1

const SF2NPC_BaseNPC SF2_INVALID_NPC = view_as<SF2NPC_BaseNPC>(-1);
const SF2_BasePlayer SF2_INVALID_PLAYER = view_as<SF2_BasePlayer>(-1);
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

	public float GetAddSpeed()
	{
		return NPCGetAddSpeed(this.Index);
	}

	public void SetAddSpeed(float value)
	{
		NPCSetAddSpeed(this.Index, value);
	}

	public float GetMaxSpeed(int difficulty)
	{
		return NPCGetMaxSpeed(this.Index, difficulty);
	}

	public float GetAddMaxSpeed()
	{
		return NPCGetAddMaxSpeed(this.Index);
	}

	public void SetAddMaxSpeed(float value)
	{
		NPCSetAddMaxSpeed(this.Index, value);
	}

	public bool GetAbsOrigin(float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 })
	{
		return SlenderGetAbsOrigin(this.Index, buffer, defaultValue);
	}

	public float GetAcceleration(int difficulty)
	{
		return NPCGetAcceleration(this.Index, difficulty);
	}

	public float GetAddAcceleration()
	{
		return NPCGetAddAcceleration(this.Index);
	}

	public void SetAddAcceleration(float value)
	{
		NPCSetAddAcceleration(this.Index, value);
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

	public bool HasAttribute(int attributeIndex)
	{
		return NPCHasAttribute(this.Index, attributeIndex);
	}

	public float GetAttributeValue(int attributeIndex)
	{
		return NPCGetAttributeValue(this.Index, attributeIndex);
	}

	public bool CanBeSeen(bool fov = true, bool blink = false)
	{
		return PeopleCanSeeSlender(this.Index, fov, blink);
	}

	public bool PlayerCanSee(int client, bool fov = true, bool blink = false, bool eliminated = false)
	{
		return PlayerCanSeeSlender(client, this.Index, fov, blink, eliminated);
	}

	public void AddCompanions()
	{
		NPCAddCompanions(this);
	}
}

methodmap SF2_BasePlayer < CBaseCombatCharacter
{
	public SF2_BasePlayer(int client)
	{
		if (!IsValidClient(client))
		{
			return view_as<SF2_BasePlayer>(SF2_INVALID_PLAYER);
		}
		return view_as<SF2_BasePlayer>(client);
	}

	property int UserID
	{
		public get()
		{
			return GetClientUserId(this.index);
		}
	}

	property bool IsValid
	{
		public get()
		{
			return IsValidClient(this.index);
		}
	}

	property bool IsAlive
	{
		public get()
		{
			return IsPlayerAlive(this.index);
		}
	}

	property bool IsInGame
	{
		public get()
		{
			return IsClientInGame(this.index);
		}
	}

	property bool IsBot
	{
		public get()
		{
			return IsFakeClient(this.index);
		}
	}

	property bool IsSourceTV
	{
		public get()
		{
			return IsClientSourceTV(this.index);
		}
	}

	property bool IsReplay
	{
		public get()
		{
			return IsClientReplay(this.index);
		}
	}

	property bool InThirdPerson
	{
		public get()
		{
			return !!GetEntProp(this.index, Prop_Send, "m_nForceTauntCam");
		}
	}

	property int Buttons
	{
		public get()
		{
			return GetClientButtons(this.index);
		}
	}

	property int Health
	{
		public get()
		{
			return this.GetProp(Prop_Send, "m_iHealth");
		}

		public set(int value)
		{
			this.SetProp(Prop_Send, "m_iHealth", value);
		}
	}

	property int MaxHealth
	{
		public get()
		{
			return SDKCall(g_SDKGetMaxHealth, this.index);
		}
	}

	property bool Ducking
	{
		public get()
		{
			return this.GetProp(Prop_Send, "m_bDucking") != 0;
		}
	}

	property bool Ducked
	{
		public get()
		{
			return this.GetProp(Prop_Send, "m_bDucked") != 0;
		}
	}

	public int GetDataEnt(int offset)
	{
		return GetEntDataEnt2(this.index, offset);
	}

	property TFClassType Class
	{
		public get()
		{
			return TF2_GetPlayerClass(this.index);
		}
	}

	property int Team
	{
		public get()
		{
			return GetClientTeam(this.index);
		}
	}

	property bool HasRegenItem
	{
		public get()
		{
			return g_PlayerHasRegenerationItem[this.index];
		}
		public set(bool state)
		{
			g_PlayerHasRegenerationItem[this.index] = state;
		}
	}

	public bool InCondition(TFCond condition)
	{
		return TF2_IsPlayerInCondition(this.index, condition);
	}

	public bool ChangeCondition(TFCond condition, bool remove = false, float duration = TFCondDuration_Infinite, int inflictor = 0)
	{
		if (remove)
		{
			TF2_RemoveCondition(this.index, condition);
		}
		else
		{
			TF2_AddCondition(this.index, condition, duration, inflictor);
		}
	}

	public void Ignite(bool self = false, int attacker = 0, float duration = 10.0)
	{
		TF2_IgnitePlayer(this.index, !self && attacker > 0 ? attacker : this.index, duration);
	}

	public void Bleed(bool self = false, int attacker = 0, float duration = 5.0)
	{
		TF2_MakeBleed(this.index, !self && attacker > 0 ? attacker : this.index, duration);
	}

	public void Stun(float duration, float slowdown, int stunflags, int attacker = 0)
	{
		TF2_StunPlayer(this.index, duration, slowdown, stunflags, attacker);
	}

	public void Regenerate()
	{
		TF2_RegeneratePlayer(this.index);
	}

	public void SetClass(TFClassType classType, bool weapons = true, bool persistent = true)
	{
		TF2_SetPlayerClass(this.index, classType, weapons, persistent);
	}

	public void GetEyePosition(float vector[3])
	{
		GetClientEyePosition(this.index, vector);
	}

	public void GetEyeAngles(float vector[3])
	{
		GetClientEyeAngles(this.index, vector);
	}

	public void GetDataVector(int offset, float buffer[3])
	{
		GetEntDataVector(this.index, offset, buffer);
	}

	public void SetDataVector(int offset, const float buffer[3], bool state=false)
	{
		SetEntDataVector(this.index, offset, buffer, state);
	}

	public float GetDistanceFromEntity(int ent)
	{
		return ClientGetDistanceFromEntity(this.index, ent);
	}

	public int GetWeaponSlot(int slot)
	{
		return GetPlayerWeaponSlot(this.index, slot);
	}

	public void ScreenShake(float amp, float duration, float freq)
	{
		UTIL_ClientScreenShake(this.index, amp, duration, freq);
	}

	public int ShowHudText(Handle hudSync, const char[] buffer)
	{
		return ShowSyncHudText(this.index, hudSync, buffer);
	}

	public any SDK_Call(Handle handle)
	{
		return SDKCall(handle, this.index);
	}

	public void ViewPunch(const float punchVel[3])
	{
		ClientViewPunch(this.index, punchVel);
	}

	public void TakeDamage(bool self = false, int inflictor = 0, int attacker = 0, float damage, int damageType = DMG_GENERIC, int weapon = -1,
		const float damageForce[3] = NULL_VECTOR, const float damagePosition[3] = NULL_VECTOR, bool bypassHooks = true)
	{
		SDKHooks_TakeDamage(this.index, !self && inflictor > 0 ? inflictor : this.index, !self && attacker > 0 ? attacker : this.index,
		damage, damageType, weapon, damageForce, damagePosition, bypassHooks);
	}

	public void Respawn()
	{
		TF2_RespawnPlayer(this.index);
	}

	public void UpdateListeningFlags(bool reset = false)
	{
		ClientUpdateListeningFlags(this.index, false);
	}

	property bool IsEliminated
	{
		public get()
		{
			return g_PlayerEliminated[this.index];
		}
		public set(bool state)
		{
			g_PlayerEliminated[this.index] = state;
		}
	}

	property bool IsInGhostMode
	{
		public get()
		{
			return IsClientInGhostMode(this.index);
		}
	}

	public void SetGhostState(bool state)
	{
		ClientSetGhostModeState(this.index, state);
	}

	property bool IsProxy
	{
		public get()
		{
			return g_PlayerProxy[this.index];
		}
		public set(bool state)
		{
			g_PlayerProxy[this.index] = state;
		}
	}

	property int ProxyControl
	{
		public get()
		{
			return g_PlayerProxyControl[this.index];
		}
		public set(int value)
		{
			if (value < 0)
			{
				value = 0;
			}
			if (value > 100)
			{
				value = 100;
			}
			g_PlayerProxyControl[this.index] = value;
		}
	}

	property int ProxyMaster
	{
		public get()
		{
			return g_PlayerProxyMaster[this.index];
		}
		public set(int value)
		{
			g_PlayerProxyMaster[this.index] = value;
		}
	}

	property bool IsInPvP
	{
		public get()
		{
			return IsClientInPvP(this.index);
		}
	}

	property bool IsInDeathCam
	{
		public get()
		{
			return IsClientInDeathCam(this.index);
		}
	}

	public void StartDeathCam(int bossIndex, const float vecLookPos[3], bool antiCamp = false)
	{
		ClientStartDeathCam(this.index, bossIndex, vecLookPos, antiCamp);
	}

	property bool HasEscaped
	{
		public get()
		{
			return DidClientEscape(this.index);
		}
	}

	public void Escape()
	{
		ClientEscape(this.index);
	}

	public void TeleportToEscapePoint()
	{
		TeleportClientToEscapePoint(this.index);
	}

	property bool UsingFlashlight
	{
		public get()
		{
			return IsClientUsingFlashlight(this.index);
		}
	}

	public void HandleFlashlight()
	{
		ClientHandleFlashlight(this.index);
	}

	property float FlashlightBatteryLife
	{
		public get()
		{
			return ClientGetFlashlightBatteryLife(this.index);
		}
		public set(float value)
		{
			ClientSetFlashlightBatteryLife(this.index, value);
		}
	}

	public void ResetFlashlight()
	{
		ClientResetFlashlight(this.index);
	}

	property bool IsSprinting
	{
		public get()
		{
			return IsClientSprinting(this.index);
		}
	}

	property bool IsReallySprinting
	{
		public get()
		{
			return IsClientReallySprinting(this.index);
		}
	}

	property bool IsBlinking
	{
		public get()
		{
			return IsClientBlinking(this.index);
		}
	}

	property float BlinkMeter
	{
		public get()
		{
			return ClientGetBlinkMeter(this.index);
		}
		public set(float amount)
		{
			ClientSetBlinkMeter(this.index, amount);
		}
	}

	property int BlinkCount
	{
		public get()
		{
			return ClientGetBlinkCount(this.index);
		}
	}

	public void ResetBlink()
	{
		ClientResetBlink(this.index);
	}

	public bool StartPeeking()
	{
		return ClientStartPeeking(this.index);
	}

	property int PageCount
	{
		public get()
		{
			return g_PlayerPageCount[this.index];
		}
		public set(int amount)
		{
			g_PlayerPageCount[this.index] = amount;
		}
	}

	public void ResetHints()
	{
		ClientResetHints(this.index);
	}

	public void ShowHint(int hint)
	{
		ClientShowHint(this.index, hint);
	}

	property bool IsTrapped
	{
		public get()
		{
			return g_PlayerTrapped[this.index];
		}
		public set(bool state)
		{
			g_PlayerTrapped[this.index] = state;
		}
	}

	property int TrapCount
	{
		public get()
		{
			return g_PlayerTrapCount[this.index];
		}
		public set(int amount)
		{
			g_PlayerTrapCount[this.index] = amount;
		}
	}

	public void UpdateMusicSystem(bool initialize = false)
	{
		ClientUpdateMusicSystem(this.index, initialize);
	}

	property bool HasConstantGlow
	{
		public get()
		{
			return DoesClientHaveConstantGlow(this.index);
		}
	}

	public void SetPlayState(bool state, bool enablePlay = true)
	{
		SetClientPlayState(this.index, state, enablePlay);
	}

	public bool CanSeeSlender(int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
	{
		return PlayerCanSeeSlender(this.index, bossIndex, checkFOV, checkBlink, checkEliminated);
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

	property float InitialStunHealth
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

	public float GetDecloakRange(int difficulty)
	{
		return NPCChaserGetDecloakRange(this.Index, difficulty);
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

	property float StunHealthAdd
	{
		public get()
		{
			return NPCChaserGetAddStunHealth(this.Index);
		}
		public set(float value)
		{
			NPCChaserSetAddStunHealth(this.Index, value);
		}
	}

	public void AddStunHealth(float amount)
	{
		NPCChaserAddStunHealth(this.Index, amount);
	}

	public bool CanDisappearOnStun()
	{
		return NPCChaserCanDisappearOnStun(this.Index);
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
