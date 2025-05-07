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

	property PathFollower Path
	{
		public get()
		{
			return g_BossPathFollower[this.Index];
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

	public static SF2NPC_BaseNPC FromUniqueId(int uniqueID)
	{
		return SF2NPC_BaseNPC(NPCGetFromUniqueID(uniqueID));
	}

	public static SF2NPC_BaseNPC FromEntity(int entity)
	{
		return SF2NPC_BaseNPC(NPCGetFromEntIndex(entity));
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

	public SF2BossProfileData GetProfileData()
	{
		return NPCGetProfileData(this.Index);
	}

	property int Difficulty
	{
		public get()
		{
			return GetLocalGlobalDifficulty(this.Index);
		}

		public set(int value)
		{
			NPCChaserSetBoxingDifficulty(this.Index, value);
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

	public bool GetModel(int modelState = 0, char[] buffer, int bufferLen)
	{
		return GetSlenderModel(this.Index, modelState, buffer, bufferLen);
	}

	public int GetMaxCopies(int difficulty)
	{
		return g_SlenderMaxCopies[this.Index][difficulty];
	}

	property bool RaidHitbox
	{
		public get()
		{
			return NPCGetRaidHitbox(this.Index);
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

	property SF2NPC_BaseNPC CopyMaster
	{
		public get()
		{
			return NPCGetCopyMaster(this);
		}

		public set(SF2NPC_BaseNPC value)
		{
			g_SlenderCopyMaster[this.Index] = value.Index;
		}
	}

	property bool IsCopy
	{
		public get()
		{
			return this.CopyMaster.IsValid();
		}
	}

	property SF2NPC_BaseNPC CompanionMaster
	{
		public get()
		{
			return NPCGetCompanionMaster(this);
		}

		public set(SF2NPC_BaseNPC value)
		{
			g_SlenderCompanionMaster[this.Index] = value.Index;
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

	public void UnSpawn(bool instant = false)
	{
		if (IsValidEntity(this.EntIndex))
		{
			SF2_ChaserEntity chaser = SF2_ChaserEntity(this.EntIndex);
			if (chaser.IsValid() && !instant)
			{
				chaser.ShouldDespawn = true;
			}
			else
			{
				RemoveEntity(this.EntIndex);
			}
		}
	}

	public void Remove()
	{
		NPCRemove(this.Index);
	}

	property bool CanRemove
	{
		public get()
		{
			return SlenderCanRemove(this.Index);
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

	public void GetName(char[] buffer, int bufferLen)
	{
		NPCGetBossName(this.Index, buffer, bufferLen);
	}

	public void RemoveFromGame()
	{
		RemoveProfile(this.Index);
	}

	public float GetDistanceFrom(int entity)
	{
		NPCGetDistanceFromEntity(this.Index, entity);
	}

	public float GetAddSpeed()
	{
		return NPCGetAddSpeed(this.Index);
	}

	public void SetAddSpeed(float value)
	{
		NPCSetAddSpeed(this.Index, value);
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

	public bool CanBeSeen(bool fov = true, bool blink = false, bool checkEliminated = true)
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

	public bool IsAffectedBySight()
	{
		return NPCGetAffectedBySightState(this.Index);
	}

	public void SetAffectedBySight(bool state)
	{
		NPCSetAffectedBySightState(this.Index, state);
	}

	property int DefaultTeam
	{
		public get()
		{
			return NPCGetDefaultTeam(this.Index);
		}

		public set(int value)
		{
			NPCSetDefaultTeam(this.Index, value);
		}
	}

	property bool WasKilled
	{
		public get()
		{
			return NPCGetWasKilled(this.Index);
		}

		public set(bool state)
		{
			NPCSetWasKilled(this.Index, state);
		}
	}
}

methodmap SF2_BasePlayer < CBaseCombatCharacter
{
	public SF2_BasePlayer(int client)
	{
		if (client <= 0)
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
			return IsClientInGameEx(this.index);
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
			return GetEntProp(this.index, Prop_Send, "m_nForceTauntCam") != 0;
		}
	}

	property int Buttons
	{
		public get()
		{
			return GetClientButtons(this.index);
		}
	}

	public bool IsMoving()
	{
		int buttons = this.Buttons;
		return buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_RIGHT ||
			buttons & IN_LEFT || buttons & IN_MOVERIGHT || buttons & IN_MOVELEFT ||
			buttons & IN_JUMP;
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

	public bool IsCritBoosted()
	{
		return IsClientCritBoosted(this.index);
	}

	public bool IsMiniCritBoosted()
	{
		return TF2_IsMiniCritBuffed(this.index);
	}

	public void Ignite(bool self = false, int attacker = 0, float duration = 10.0)
	{
		TF2_IgnitePlayer(this.index, !self && attacker > 0 ? attacker : this.index, duration);
	}

	public void Bleed(bool self = false, int attacker = 0, float duration = 5.0)
	{
		TF2_MakeBleed(this.index, !self && attacker > 0 ? attacker : this.index, duration);
	}

	public void Stun(float duration, float slowdown = 0.0, int stunflags, int attacker = 0)
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

	public void SetDataVector(int offset, const float buffer[3], bool state = false)
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

	public void SwitchToWeaponSlot(int slot)
	{
		ClientSwitchToWeaponSlot(this.index, slot);
	}

	public void RemoveWeaponSlot(int slot)
	{
		TF2_RemoveWeaponSlot(this.index, slot);
	}

	public void ScreenShake(float amp, float duration, float freq)
	{
		UTIL_ClientScreenShake(this.index, amp, duration, freq);
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

	property bool IsParticipating
	{
		public get()
		{
			return IsClientParticipating(this.index);
		}
	}

	public bool GetName(char[] name, int length)
	{
		return GetClientName(this.index, name, length);
	}

	property int LastButtons
	{
		public get()
		{
			return g_PlayerLastButtons[this.index];
		}

		public set(int value)
		{
			g_PlayerLastButtons[this.index] = value;
		}
	}

	public void ScreenFade(int duration, int time, int flags, int r, int g, int b, int a)
	{
		UTIL_ScreenFade(this.index, duration, time, flags, r, g, b, a);
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

	property bool IsInPvE
	{
		public get()
		{
			return IsClientInPvE(this.index);
		}
	}

	property bool IsInDeathCam
	{
		public get()
		{
			return IsClientInDeathCam(this.index);
		}
	}

	public void StartDeathCam(int bossIndex, const float lookPos[3], bool antiCamp = false, bool staticDeath = false)
	{
		ClientStartDeathCam(this.index, bossIndex, lookPos, antiCamp, staticDeath);
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

	public float GetFlashlightNextInputTime()
	{
		return ClientGetFlashlightNextInputTime(this.index);
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

	public void HandleSprint(bool sprint)
	{
		ClientHandleSprint(this.index, sprint);
	}

	property float Stamina
	{
		public get()
		{
			return ClientGetStamina(this.index);
		}

		public set(float value)
		{
			ClientSetStamina(this.index, value);
		}
	}

	public void SetStaminaRechargeTime(float time, bool checkTime = true)
	{
		SetPlayerStaminaRechargeTime(this, time, checkTime);
	}

	property bool HasStartedBlinking
	{
		public get()
		{
			return ClientHasStartedBlinking(this.index);
		}
	}

	property bool IsBlinking
	{
		public get()
		{
			return IsClientBlinking(this.index);
		}
	}

	public bool IsHoldingBlink()
	{
		return IsClientHoldingBlink(this.index);
	}

	public void SetHoldingBlink(bool value)
	{
		ClientSetHoldingBlink(this.index, value);
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

	public void Blink()
	{
		ClientBlink(this.index);
	}

	public bool StartPeeking()
	{
		return ClientStartPeeking(this.index);
	}

	public void EndPeeking()
	{
		ClientEndPeeking(this.index);
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

	public bool HasHint(int hint)
	{
		return ClientHasHint(this.index, hint);
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

	property bool IsLatched
	{
		public get()
		{
			return g_PlayerLatchedByTongue[this.index];
		}

		public set(bool state)
		{
			g_PlayerLatchedByTongue[this.index] = state;
		}
	}

	property int LatchCount
	{
		public get()
		{
			return g_PlayerLatchCount[this.index];
		}

		public set(int amount)
		{
			g_PlayerLatchCount[this.index] = amount;
		}
	}

	property int Latcher
	{
		public get()
		{
			return g_PlayerLatcher[this.index];
		}

		public set(int value)
		{
			g_PlayerLatcher[this.index] = value;
		}
	}

	public void UpdateMusicSystem(bool initialize = false)
	{
		ClientUpdateMusicSystem(this.index, initialize);
	}

	public void SetPlayState(bool state, bool enablePlay = true)
	{
		SetClientPlayState(this.index, state, enablePlay);
	}

	public bool CanSeeSlender(int bossIndex, bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true)
	{
		return PlayerCanSeeSlender(this.index, bossIndex, checkFOV, checkBlink, checkEliminated);
	}

	public void SetAFKTime(bool reset = true)
	{
		AFK_SetTime(this.index);
	}

	public void SetAFKState()
	{
		AFK_SetAFK(this.index);
	}

	public void CheckAFKTime()
	{
		AFK_CheckTime(this.index);
	}

	public bool ShouldBeForceChased(SF2NPC_BaseNPC controller)
	{
		return ShouldClientBeForceChased(controller, this);
	}

	public void SetForceChaseState(SF2NPC_BaseNPC controller, bool value)
	{
		SetClientForceChaseState(controller, this, value);
	}

	public bool IsLookingAtBoss(SF2NPC_BaseNPC controller)
	{
		return g_PlayerSeesSlender[this.index][controller.Index];
	}
}

methodmap SF2NPC_Chaser < SF2NPC_BaseNPC
{
	public SF2ChaserBossProfileData GetProfileData()
	{
		return NPCChaserGetProfileData(this.Index);
	}

	public float GetInitialDeathHealth(int difficulty)
	{
		return NPCChaserGetDeathInitialHealth(this.Index, difficulty);
	}

	public float GetDeathHealth(int difficulty)
	{
		return NPCChaserGetDeathHealth(this.Index, difficulty);
	}

	public void SetDeathHealth(int difficulty, float amount)
	{
		NPCChaserSetDeathHealth(this.Index, difficulty, amount);
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

	property ArrayList ChaseOnLookTargets
	{
		public get()
		{
			return NPCChaserGetAutoChaseTargets(this.Index);
		}
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

	public SF2StatueBossProfileData GetProfileData()
	{
		return NPCStatueGetProfileData(this.Index);
	}

	public float GetIdleLifetime(int difficulty)
	{
		return NPCStatueGetIdleLifetime(this.Index, difficulty);
	}
}

void SetupMethodmapAPI()
{
	CreateNative("SF2_Player.UserID.get", Native_GetClientUserID);
	CreateNative("SF2_Player.IsValid.get", Native_GetIsValidClient);
	CreateNative("SF2_Player.IsAlive.get", Native_GetIsClientAlive);
	CreateNative("SF2_Player.IsInGame.get", Native_GetIsClientInGame);
	CreateNative("SF2_Player.IsBot.get", Native_GetIsClientBot);
	CreateNative("SF2_Player.IsSourceTV.get", Native_GetIsClientSourceTV);
	CreateNative("SF2_Player.IsReplay.get", Native_GetIsClientReplay);
	CreateNative("SF2_Player.InThirdPerson.get", Native_GetIsClientInThirdPerson);
	CreateNative("SF2_Player.Buttons.get", Native_GetClientButtons);
	CreateNative("SF2_Player.IsMoving", Native_GetIsClientMoving);
	CreateNative("SF2_Player.Health.get", Native_GetClientHealth);
	CreateNative("SF2_Player.MaxHealth.get", Native_GetClientMaxHealth);
	CreateNative("SF2_Player.Ducking.get", Native_GetIsClientDucking);
	CreateNative("SF2_Player.Ducked.get", Native_GetIsClientDucked);
	CreateNative("SF2_Player.GetDataEnt", Native_GetClientDataEnt);
	CreateNative("SF2_Player.Class.get", Native_GetClientClass);
	CreateNative("SF2_Player.Team.get", Native_GetClientTeam);
	CreateNative("SF2_Player.HasRegenItem.get", Native_GetClientHasRegenItem);
	CreateNative("SF2_Player.HasRegenItem.set", Native_SetClientHasRegenItem);
	CreateNative("SF2_Player.InCondition", Native_GetClientInCondition);
	CreateNative("SF2_Player.ChangeCondition", Native_ClientChangeCondition);
	CreateNative("SF2_Player.IsCritBoosted", Native_GetClientIsCritBoosted);
	CreateNative("SF2_Player.IsMiniCritBoosted", Native_GetClientIsMiniCritBoosted);
	CreateNative("SF2_Player.Ignite", Native_ClientIgnite);
	CreateNative("SF2_Player.Bleed", Native_ClientBleed);
	CreateNative("SF2_Player.Stun", Native_ClientStun);
	CreateNative("SF2_Player.Regenerate", Native_ClientRegenerate);
	CreateNative("SF2_Player.SetClass", Native_ClientSetClass);
	CreateNative("SF2_Player.GetEyePosition", Native_GetClientEyePosition);
	CreateNative("SF2_Player.GetEyeAngles", Native_GetClientEyeAngles);
	CreateNative("SF2_Player.GetDataVector", Native_GetClientDataVector);
	CreateNative("SF2_Player.SetDataVector", Native_SetClientDataVector);
	CreateNative("SF2_Player.GetDistanceFromEntity", Native_GetClientDistanceFromEntity);
	CreateNative("SF2_Player.GetWeaponSlot", Native_GetClientWeaponSlot);
	CreateNative("SF2_Player.SwitchToWeaponSlot", Native_ClientSwitchToWeaponSlot);
	CreateNative("SF2_Player.RemoveWeaponSlot", Native_ClientRemoveWeaponSlot);
	CreateNative("SF2_Player.ScreenShake", Native_ClientScreenShake);
	CreateNative("SF2_Player.ViewPunch", Native_ClientViewPunch);
	CreateNative("SF2_Player.TakeDamage", Native_ClientTakeDamage);
	CreateNative("SF2_Player.Respawn", Native_ClientRespawn);
	CreateNative("SF2_Player.UpdateListeningFlags", Native_ClientUpdateListeningFlags);
	CreateNative("SF2_Player.IsParticipating.get", Native_GetClientIsParticipating);
	CreateNative("SF2_Player.GetName", Native_GetClientName);
	CreateNative("SF2_Player.LastButtons.get", Native_GetClientLastButtons);
	CreateNative("SF2_Player.LastButtons.set", Native_SetClientLastButtons);
	CreateNative("SF2_Player.ScreenFade", Native_ClientScreenFade);
	CreateNative("SF2_Player.IsEliminated.get", Native_GetClientIsEliminated);
	CreateNative("SF2_Player.IsEliminated.set", Native_SetClientIsEliminated);
	CreateNative("SF2_Player.IsInGhostMode.get", Native_GetClientIsInGhostMode);
	CreateNative("SF2_Player.SetGhostState", Native_SetClientGhostState);
	CreateNative("SF2_Player.IsProxy.get", Native_GetClientIsProxy);
	CreateNative("SF2_Player.IsProxy.set", Native_SetClientIsProxy);
	CreateNative("SF2_Player.ProxyControl.get", Native_GetClientProxyControl);
	CreateNative("SF2_Player.ProxyControl.set", Native_SetClientProxyControl);
	CreateNative("SF2_Player.ProxyMaster.get", Native_GetClientProxyMaster);
	CreateNative("SF2_Player.ProxyMaster.set", Native_SetClientProxyMaster);
	CreateNative("SF2_Player.IsInPvP.get", Native_GetClientIsInPvP);
	CreateNative("SF2_Player.IsInPvE.get", Native_GetClientIsInPvE);
	CreateNative("SF2_Player.IsInDeathCam.get", Native_GetClientIsInDeathCam);
	CreateNative("SF2_Player.StartDeathCam", Native_ClientStartDeathCam);
	CreateNative("SF2_Player.HasEscaped.get", Native_GetClientHasEscaped);
	CreateNative("SF2_Player.Escape", Native_ClientEscape);
	CreateNative("SF2_Player.TeleportToEscapePoint", Native_ClientTeleportToEscapePoint);
	CreateNative("SF2_Player.ForceEscape", Native_ClientForceEscape);
	CreateNative("SF2_Player.UsingFlashlight.get", Native_GetClientUsingFlashlight);
	CreateNative("SF2_Player.HandleFlashlight", Native_ClientHandleFlashlight);
	CreateNative("SF2_Player.FlashlightBatteryLife.get", Native_GetClientFlashlightBatteryLife);
	CreateNative("SF2_Player.FlashlightBatteryLife.set", Native_SetClientFlashlightBatteryLife);
	CreateNative("SF2_Player.ResetFlashlight", Native_ClientResetFlashlight);
	CreateNative("SF2_Player.GetFlashlightNextInputTime", Native_GetClientFlashlightNextInputTime);
	CreateNative("SF2_Player.IsSprinting.get", Native_GetClientIsSprinting);
	CreateNative("SF2_Player.IsReallySprinting.get", Native_GetClientIsReallySprinting);
	CreateNative("SF2_Player.HandleSprint", Native_ClientHandleSprint);
	CreateNative("SF2_Player.Stamina.get", Native_GetClientSprintPoints);
	CreateNative("SF2_Player.Stamina.set", Native_SetClientSprintPoints);
	CreateNative("SF2_Player.SetStaminaRechargeTime", Native_SetClientStaminaRechargeTime);
	CreateNative("SF2_Player.HasStartedBlinking.get", Native_GetClientHasStartedBlinking);
	CreateNative("SF2_Player.IsBlinking.get", Native_GetClientIsBlinking);
	CreateNative("SF2_Player.IsHoldingBlink", Native_GetClientIsHoldingBlink);
	CreateNative("SF2_Player.SetHoldingBlink", Native_SetClientIsHoldingBlink);
	CreateNative("SF2_Player.BlinkMeter.get", Native_GetClientBlinkMeter);
	CreateNative("SF2_Player.BlinkMeter.set", Native_SetClientBlinkMeter);
	CreateNative("SF2_Player.BlinkCount.get", Native_GetClientBlinkCount);
	CreateNative("SF2_Player.Blink", Native_ClientBlink);
	CreateNative("SF2_Player.StartPeeking", Native_ClientStartPeeking);
	CreateNative("SF2_Player.EndPeeking", Native_ClientEndPeeking);
	CreateNative("SF2_Player.PageCount.get", Native_GetClientPageCount);
	CreateNative("SF2_Player.PageCount.set", Native_SetClientPageCount);
	CreateNative("SF2_Player.ShowHint", Native_ClientShowHint);
	CreateNative("SF2_Player.IsTrapped.get", Native_GetClientIsTrapped);
	CreateNative("SF2_Player.IsTrapped.set", Native_SetClientIsTrapped);
	CreateNative("SF2_Player.TrapCount.get", Native_GetClientTrapCount);
	CreateNative("SF2_Player.TrapCount.set", Native_SetClientTrapCount);
	CreateNative("SF2_Player.IsLatched.get", Native_GetClientIsLatched);
	CreateNative("SF2_Player.IsLatched.set", Native_SetClientIsLatched);
	CreateNative("SF2_Player.LatchCount.get", Native_GetClientLatchCount);
	CreateNative("SF2_Player.LatchCount.set", Native_SetClientLatchCount);
	CreateNative("SF2_Player.Latcher.get", Native_GetClientLatcher);
	CreateNative("SF2_Player.Latcher.set", Native_SetClientLatcher);
	CreateNative("SF2_Player.UpdateMusicSystem", Native_ClientUpdateMusicSystem);
	CreateNative("SF2_Player.HasConstantGlow.get", Native_GetClientHasConstantGlow);
	CreateNative("SF2_Player.SetPlayState", Native_SetClientPlayState);
	CreateNative("SF2_Player.CanSeeSlender", Native_GetClientCanSeeSlender);
	CreateNative("SF2_Player.SetAFKTime", Native_SetClientAFKTime);
	CreateNative("SF2_Player.SetAFKState", Native_SetClientAFKState);
	CreateNative("SF2_Player.CheckAFKTime", Native_CheckClientAFKTime);
	CreateNative("SF2_Player.ShouldBeForceChased", Native_GetClientShouldBeForceChased);
	CreateNative("SF2_Player.SetForceChaseState", Native_SetClientForceChaseState);
	CreateNative("SF2_Player.IsLookingAtBoss", Native_GetClientIsLookingAtBoss);
}

static any Native_GetClientUserID(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.UserID;
}

static any Native_GetIsValidClient(Handle plugin, int numParams)
{
	// WOW, the one instance where I don't check if the client is valid but we return it
	SF2_BasePlayer player = SF2_BasePlayer(GetNativeCell(1));
	return player.IsValid;
}

static any Native_GetIsClientAlive(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsAlive;
}

static any Native_GetIsClientInGame(Handle plugin, int numParams)
{
	SF2_BasePlayer player = SF2_BasePlayer(GetNativeCell(1));
	return player.IsInGame;
}

static any Native_GetIsClientBot(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsBot;
}

static any Native_GetIsClientSourceTV(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsSourceTV;
}

static any Native_GetIsClientReplay(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsReplay;
}

static any Native_GetIsClientInThirdPerson(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.InThirdPerson;
}

static any Native_GetClientButtons(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Buttons;
}

static any Native_GetIsClientMoving(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsMoving();
}

static any Native_GetClientHealth(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Health;
}

static any Native_GetClientMaxHealth(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.MaxHealth;
}

static any Native_GetIsClientDucking(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Ducking;
}

static any Native_GetIsClientDucked(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Ducked;
}

static any Native_GetClientDataEnt(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.GetDataEnt(GetNativeCell(2));
}

static any Native_GetClientClass(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Class;
}

static any Native_GetClientTeam(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Team;
}

static any Native_GetClientHasRegenItem(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.HasRegenItem;
}

static any Native_SetClientHasRegenItem(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.HasRegenItem = GetNativeCell(2);
	return 0;
}

static any Native_GetClientInCondition(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.InCondition(GetNativeCell(2));
}

static any Native_ClientChangeCondition(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ChangeCondition(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5));
	return 0;
}

static any Native_GetClientIsCritBoosted(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsCritBoosted();
}

static any Native_GetClientIsMiniCritBoosted(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsMiniCritBoosted();
}

static any Native_ClientIgnite(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Ignite(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
	return 0;
}

static any Native_ClientBleed(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Bleed(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
	return 0;
}

static any Native_ClientStun(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Stun(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5));
	return 0;
}

static any Native_ClientRegenerate(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Regenerate();
	return 0;
}

static any Native_ClientSetClass(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetClass(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
	return 0;
}

static any Native_GetClientEyePosition(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	player.GetEyePosition(buffer);
	SetNativeArray(2, buffer, 3);
	return 0;
}

static any Native_GetClientEyeAngles(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	player.GetEyeAngles(buffer);
	SetNativeArray(2, buffer, 3);
	return 0;
}

static any Native_GetClientDataVector(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	player.GetDataVector(GetNativeCell(2), buffer);
	SetNativeArray(3, buffer, 3);
	return 0;
}

static any Native_SetClientDataVector(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	GetNativeArray(3, buffer, 3);
	player.SetDataVector(GetNativeCell(2), buffer);
	return 0;
}

static any Native_GetClientDistanceFromEntity(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.GetDistanceFromEntity(GetNativeCell(2));
}

static any Native_GetClientWeaponSlot(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.GetWeaponSlot(GetNativeCell(2));
}

static any Native_ClientSwitchToWeaponSlot(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SwitchToWeaponSlot(GetNativeCell(2));
	return 0;
}

static any Native_ClientRemoveWeaponSlot(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.RemoveWeaponSlot(GetNativeCell(2));
	return 0;
}

static any Native_ClientScreenShake(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ScreenShake(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
	return 0;
}

static any Native_ClientViewPunch(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	GetNativeArray(2, buffer, 3);
	player.ViewPunch(buffer);
	return 0;
}

static any Native_ClientTakeDamage(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	float force[3], position[3];
	GetNativeArray(8, force, 3);
	GetNativeArray(9, position, 3);
	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.TakeDamage(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5), GetNativeCell(6),
					GetNativeCell(7), force, position, GetNativeCell(10));
	return 0;
}

static any Native_ClientRespawn(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Respawn();
	return 0;
}

static any Native_ClientUpdateListeningFlags(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.UpdateListeningFlags(GetNativeCell(2));
	return 0;
}

static any Native_GetClientIsParticipating(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsParticipating;
}

static any Native_GetClientName(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	int size;
	GetNativeStringLength(2, size);
	size++;
	char[] buffer = new char[size];
	GetNativeString(2, buffer, size);
	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.GetName(buffer, size);
	SetNativeString(2, buffer, size);
	return player.IsParticipating;
}

static any Native_GetClientLastButtons(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.LastButtons;
}

static any Native_SetClientLastButtons(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.LastButtons = GetNativeCell(2);
	return 0;
}

static any Native_ClientScreenFade(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ScreenFade(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), GetNativeCell(7), GetNativeCell(8));
	return 0;
}

static any Native_GetClientIsEliminated(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsEliminated;
}

static any Native_SetClientIsEliminated(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.IsEliminated = GetNativeCell(2);
	return 0;
}

static any Native_GetClientIsInGhostMode(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsInGhostMode;
}

static any Native_SetClientGhostState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetGhostState(GetNativeCell(2));
	return 0;
}

static any Native_GetClientIsProxy(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsProxy;
}

static any Native_SetClientIsProxy(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.IsProxy = GetNativeCell(2);
	return 0;
}

static any Native_GetClientProxyControl(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.ProxyControl;
}

static any Native_SetClientProxyControl(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ProxyControl = GetNativeCell(2);
	return 0;
}

static any Native_GetClientProxyMaster(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.ProxyMaster;
}

static any Native_SetClientProxyMaster(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ProxyMaster = GetNativeCell(2);
	return 0;
}

static any Native_GetClientIsInPvP(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsInPvP;
}

static any Native_GetClientIsInPvE(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsInPvE;
}

static any Native_GetClientIsInDeathCam(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsInDeathCam;
}

static any Native_ClientStartDeathCam(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float buffer[3];
	GetNativeArray(3, buffer, 3);
	player.StartDeathCam(GetNativeCell(2), buffer, GetNativeCell(4), GetNativeArray(5));
	return 0;
}

static any Native_GetClientHasEscaped(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.HasEscaped;
}

static any Native_ClientEscape(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Escape();
	return 0;
}

static any Native_ClientTeleportToEscapePoint(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.TeleportToEscapePoint();
	return 0;
}

static any Native_ClientForceEscape(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Escape();
	player.TeleportToEscapePoint();
	return 0;
}

static any Native_GetClientUsingFlashlight(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.UsingFlashlight;
}

static any Native_ClientHandleFlashlight(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.HandleFlashlight();
	return 0;
}

static any Native_GetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.FlashlightBatteryLife;
}

static any Native_SetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.FlashlightBatteryLife = GetNativeCell(2);
	return 0;
}

static any Native_ClientResetFlashlight(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.ResetFlashlight();
	return 0;
}

static any Native_GetClientFlashlightNextInputTime(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.GetFlashlightNextInputTime();
}

static any Native_GetClientIsSprinting(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsSprinting;
}

static any Native_GetClientIsReallySprinting(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsReallySprinting;
}

static any Native_ClientHandleSprint(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.HandleSprint(GetNativeCell(2));
	return 0;
}

static any Native_GetClientSprintPoints(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Stamina;
}

static any Native_SetClientSprintPoints(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Stamina = GetNativeCell(2);
	return 0;
}

static any Native_SetClientStaminaRechargeTime(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetStaminaRechargeTime(GetNativeCell(2), GetNativeCell(3));
	return 0;
}

static any Native_GetClientHasStartedBlinking(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.HasStartedBlinking;
}

static any Native_GetClientIsBlinking(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsBlinking;
}

static any Native_GetClientIsHoldingBlink(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsHoldingBlink();
}

static any Native_SetClientIsHoldingBlink(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetHoldingBlink(GetNativeCell(2));
	return 0;
}

static any Native_GetClientBlinkMeter(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.BlinkMeter;
}

static any Native_SetClientBlinkMeter(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.BlinkMeter = GetNativeCell(2);
	return 0;
}

static any Native_GetClientBlinkCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.BlinkCount;
}

static any Native_ClientBlink(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Blink();
	return 0;
}

static any Native_ClientStartPeeking(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.StartPeeking();
	return 0;
}

static any Native_ClientEndPeeking(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.EndPeeking();
	return 0;
}

static any Native_GetClientPageCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.PageCount;
}

static any Native_SetClientPageCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.PageCount = GetNativeCell(2);
	return 0;
}

static any Native_ClientShowHint(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.EndPeeking();
	return 0;
}

static any Native_GetClientIsTrapped(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsTrapped;
}

static any Native_SetClientIsTrapped(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.IsTrapped = GetNativeCell(2);
	return 0;
}

static any Native_GetClientTrapCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.TrapCount;
}

static any Native_SetClientTrapCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.TrapCount = GetNativeCell(2);
	return 0;
}

static any Native_GetClientIsLatched(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.IsLatched;
}

static any Native_SetClientIsLatched(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.IsLatched = GetNativeCell(2);
	return 0;
}

static any Native_GetClientLatchCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.LatchCount;
}

static any Native_SetClientLatchCount(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.LatchCount = GetNativeCell(2);
	return 0;
}

static any Native_GetClientLatcher(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.Latcher;
}

static any Native_SetClientLatcher(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.Latcher = GetNativeCell(2);
	return 0;
}

static any Native_ClientUpdateMusicSystem(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.UpdateMusicSystem(GetNativeCell(2));
	return 0;
}

static any Native_GetClientHasConstantGlow(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	return DoesEntityHaveGlow(client);
}

static any Native_SetClientPlayState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetPlayState(GetNativeCell(2), GetNativeCell(3));
	return 0;
}

static any Native_GetClientCanSeeSlender(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.CanSeeSlender(GetNativeCell(2), GetNativeCell(3), GetNativeCell(4), GetNativeCell(5));
}

static any Native_SetClientAFKTime(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetPlayState(GetNativeCell(2));
	return 0;
}

static any Native_SetClientAFKState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	player.SetPlayState(GetNativeCell(2), GetNativeCell(3));
	return 0;
}

static any Native_CheckClientAFKTime(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	return player.CheckAFKTime();
}

static any Native_GetClientShouldBeForceChased(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(GetNativeCell(2));
	return player.ShouldBeForceChased(npc);
}

static any Native_SetClientForceChaseState(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(GetNativeCell(2));
	player.SetForceChaseState(npc, GetNativeCell(3));
	return 0;
}

static any Native_GetClientIsLookingAtBoss(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	if (!IsValidClient(client))
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid client index %d", client);
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(GetNativeCell(2));
	return player.IsLookingAtBoss(npc);
}
