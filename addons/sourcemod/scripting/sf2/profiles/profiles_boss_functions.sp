#if defined _sf2_profiles_precache_included
 #endinput
#endif
#define _sf2_profiles_precache_included

methodmap SF2BaseBossProfile
{
	property int Index
	{
		public get() { return view_as<int>(this); }
	}
	
	property int UniqueProfileIndex
	{
		public get() { return GetBossProfileUniqueProfileIndex(this.Index); }
	}

	property int Skin
	{
		public get() { return GetBossProfileSkin(this.Index); }
	}
	
	property int SkinMax
	{
		public get() { return GetBossProfileSkinMax(this.Index); }
	}
	
	property int BodyGroups
	{
		public get() { return GetBossProfileBodyGroups(this.Index); }
	}
	
	property int BodyGroupsMax
	{
		public get() { return GetBossProfileBodyGroupsMax(this.Index); }
	}
	
	property float ModelScale
	{
		public get() { return GetBossProfileModelScale(this.Index); }
	}
	
	property int Type
	{
		public get() { return GetBossProfileType(this.Index); }
	}
	
	property int Flags
	{
		public get() { return GetBossProfileFlags(this.Index); }
	}
	
	property int UseRaidHitbox
	{
		public get() { return GetBossProfileRaidHitbox(this.Index); }
	}
	
	property int OutlineColorR
	{
		public get() { return GetBossProfileOutlineColorR(this.Index); }
	}
	
	property int OutlineColorG
	{
		public get() { return GetBossProfileOutlineColorG(this.Index); }
	}
	
	property int OutlineColorB
	{
		public get() { return GetBossProfileOutlineColorB(this.Index); }
	}
	
	property int OutlineTransparency
	{
		public get() { return GetBossProfileOutlineTransparency(this.Index); }
	}

	property float FOV
	{
		public get() { return GetBossProfileFOV(this.Index); }
	}
	
	property float TurnRate
	{
		public get() { return GetBossProfileTurnRate(this.Index); }
	}
	
	property float AngerStart
	{
		public get() { return GetBossProfileAngerStart(this.Index); }
	}
	
	property float AngerAddOnPageGrab
	{
		public get() { return GetBossProfileAngerAddOnPageGrab(this.Index); }
	}
	
	property float AngerAddOnPageGrabTimeDiff
	{
		public get() { return GetBossProfileAngerPageGrabTimeDiff(this.Index); }
	}
	
	property float InstantKillRadius
	{
		public get() { return GetBossProfileInstantKillRadius(this.Index); }
	}
	
	property float ScareRadius
	{
		public get() { return GetBossProfileScareRadius(this.Index); }
	}
	
	property float ScareCooldown
	{
		public get() { return GetBossProfileScareCooldown(this.Index); }
	}
	
	property int TeleportType
	{
		public get() { return GetBossProfileTeleportType(this.Index); }
	}
	
	public float GetSpeed(int difficulty)
	{
		return GetBossProfileSpeed(this.Index, difficulty);
	}
	
	public float GetMaxSpeed(int difficulty)
	{
		return GetBossProfileMaxSpeed(this.Index, difficulty);
	}
	
	public void GetEyePositionOffset(float buffer[3])
	{
		GetBossProfileEyePositionOffset(this.Index, buffer);
	}
	
	public void GetEyeAngleOffset(float buffer[3])
	{
		GetBossProfileEyeAngleOffset(this.Index, buffer);
	}

}

enum
{
	BossProfileData_UniqueProfileIndex,
	BossProfileData_Type,
	BossProfileData_ModelScale,
	BossProfileData_Health,
	BossProfileData_Skin,
	BossProfileData_SkinEasy,
	BossProfileData_SkinHard,
	BossProfileData_SkinInsane,
	BossProfileData_SkinNightmare,
	BossProfileData_SkinApollyon,
	BossProfileData_SkinMax,
	BossProfileData_Body,
	BossProfileData_BodyEasy,
	BossProfileData_BodyHard,
	BossProfileData_BodyInsane,
	BossProfileData_BodyNightmare,
	BossProfileData_BodyApollyon,
	BossProfileData_BodyMax,
	BossProfileData_Flags,
	BossProfileData_UseRaidHitbox,
	BossProfileData_IgnoreNavPrefer,

	BossProfileData_BlinkLookRateMultipler,
	BossProfileData_BlinkStaticRateMultiplier,

	BossProfileData_SoundMusicLoopEasy,
	BossProfileData_SoundMusicLoopNormal,
	BossProfileData_SoundMusicLoopHard,
	BossProfileData_SoundMusicLoopInsane,
	BossProfileData_SoundMusicLoopNightmare,
	BossProfileData_SoundMusicLoopApollyon,

	BossProfileData_HasDeathCam,
	BossProfileData_DeathCamPlayScareSound,
	BossProfileData_PublicDeathCam,
	BossProfileData_PublicDeathCamSpeed,
	BossProfileData_PublicDeathCamAcceleration,
	BossProfileData_PublicDeathCamDeceleration,
	BossProfileData_PublicDeathCamBackwardOffset,
	BossProfileData_PublicDeathCamDownwardOffset,
	BossProfileData_DeathCamOverlay,
	BossProfileData_DeathCamOverlayStartTime,
	BossProfileData_DeathCamTime,

	BossProfileData_CopyEasy,
	BossProfileData_CopyNormal,
	BossProfileData_CopyHard,
	BossProfileData_CopyInsane,
	BossProfileData_CopyNightmare,
	BossProfileData_CopyApollyon,
	
	BossProfileData_SpeedEasy,
	BossProfileData_SpeedNormal,
	BossProfileData_SpeedHard,
	BossProfileData_SpeedInsane,
	BossProfileData_SpeedNightmare,
	BossProfileData_SpeedApollyon,

	BossProfileData_MaxSpeedEasy,
	BossProfileData_MaxSpeedNormal,
	BossProfileData_MaxSpeedHard,
	BossProfileData_MaxSpeedInsane,
	BossProfileData_MaxSpeedNightmare,
	BossProfileData_MaxSpeedApollyon,

	BossProfileData_AccelerationEasy,
	BossProfileData_AccelerationNormal,
	BossProfileData_AccelerationHard,
	BossProfileData_AccelerationInsane,
	BossProfileData_AccelerationNightmare,
	BossProfileData_AccelerationApollyon,
	
	BossProfileData_IdleLifetimeEasy,
	BossProfileData_IdleLifetimeNormal,
	BossProfileData_IdleLifetimeHard,
	BossProfileData_IdleLifetimeInsane,
	BossProfileData_IdleLifetimeNightmare,
	BossProfileData_IdleLifetimeApollyon,

	BossProfileData_SearchRange,
	BossProfileData_SearchRangeEasy,
	BossProfileData_SearchRangeHard,
	BossProfileData_SearchRangeInsane,
	BossProfileData_SearchRangeNightmare,
	BossProfileData_SearchRangeApollyon,

	BossProfileData_SearchSoundRange,
	BossProfileData_SearchSoundRangeEasy,
	BossProfileData_SearchSoundRangeHard,
	BossProfileData_SearchSoundRangeInsane,
	BossProfileData_SearchSoundRangeNightmare,
	BossProfileData_SearchSoundRangeApollyon,
	
	BossProfileData_FieldOfView,
	BossProfileData_TurnRate,
	BossProfileData_EyePosOffsetX,
	BossProfileData_EyePosOffsetY,
	BossProfileData_EyePosOffsetZ,
	BossProfileData_EyeAngOffsetX,
	BossProfileData_EyeAngOffsetY,
	BossProfileData_EyeAngOffsetZ,
	BossProfileData_AngerStart,
	BossProfileData_AngerAddOnPageGrab,
	BossProfileData_AngerPageGrabTimeDiffReq,
	BossProfileData_InstantKillRadius,

	BossProfileData_InstantKillCooldownEasy,
	BossProfileData_InstantKillCooldownNormal,
	BossProfileData_InstantKillCooldownHard,
	BossProfileData_InstantKillCooldownInsane,
	BossProfileData_InstantKillCooldownNightmare,
	BossProfileData_InstantKillCooldownApollyon,
	
	BossProfileData_EnableCustomizableOutlines,
	BossProfileData_OutlineColorR,
	BossProfileData_OutlineColorG,
	BossProfileData_OutlineColorB,
	BossProfileData_OutlineColorTrans,
	BossProfileData_RainbowOutline,
	BossProfileData_RainbowOutlineCycle,

	BossProfileData_ScareRadius,
	BossProfileData_ScareCooldown,

	BossProfileData_SpeedBoostOnScare,
	BossProfileData_ScareSpeedBoostDuration,

	BossProfileData_ScareReaction,
	BossProfileData_ScareReactionType,

	BossProfileData_ScareReplenishSprint,
	BossProfileData_ScareReplenishSprintAmount,

	BossProfileData_StaticRadiusEasy,
	BossProfileData_StaticRadiusNormal,
	BossProfileData_StaticRadiusHard,
	BossProfileData_StaticRadiusInsane,
	BossProfileData_StaticRadiusNightmare,
	BossProfileData_StaticRadiusApollyon,

	BossProfileData_StaticRateEasy,
	BossProfileData_StaticRateNormal,
	BossProfileData_StaticRateHard,
	BossProfileData_StaticRateInsane,
	BossProfileData_StaticRateNightmare,
	BossProfileData_StaticRateApollyon,

	BossProfileData_StaticRateDecayEasy,
	BossProfileData_StaticRateDecayNormal,
	BossProfileData_StaticRateDecayHard,
	BossProfileData_StaticRateDecayInsane,
	BossProfileData_StaticRateDecayNightmare,
	BossProfileData_StaticRateDecayApollyon,

	BossProfileData_StaticGraceTimeEasy,
	BossProfileData_StaticGraceTimeNormal,
	BossProfileData_StaticGraceTimeHard,
	BossProfileData_StaticGraceTimeInsane,
	BossProfileData_StaticGraceTimeNightmare,
	BossProfileData_StaticGraceTimeApollyon,

	BossProfileData_TeleportRangeMinEasy,
	BossProfileData_TeleportRangeMinNormal,
	BossProfileData_TeleportRangeMinHard,
	BossProfileData_TeleportRangeMinInsane,
	BossProfileData_TeleportRangeMinNightmare,
	BossProfileData_TeleportRangeMinApollyon,

	BossProfileData_TeleportRangeMaxEasy,
	BossProfileData_TeleportRangeMaxNormal,
	BossProfileData_TeleportRangeMaxHard,
	BossProfileData_TeleportRangeMaxInsane,
	BossProfileData_TeleportRangeMaxNightmare,
	BossProfileData_TeleportRangeMaxApollyon,

	BossProfileData_TeleportTimeMinEasy,
	BossProfileData_TeleportTimeMinNormal,
	BossProfileData_TeleportTimeMinHard,
	BossProfileData_TeleportTimeMinInsane,
	BossProfileData_TeleportTimeMinNightmare,
	BossProfileData_TeleportTimeMinApollyon,
	
	BossProfileData_TeleportTimeMaxEasy,
	BossProfileData_TeleportTimeMaxNormal,
	BossProfileData_TeleportTimeMaxHard,
	BossProfileData_TeleportTimeMaxInsane,
	BossProfileData_TeleportTimeMaxNightmare,
	BossProfileData_TeleportTimeMaxApollyon,

	BossProfileData_TeleportRestPeriodEasy,
	BossProfileData_TeleportRestPeriodNormal,
	BossProfileData_TeleportRestPeriodHard,
	BossProfileData_TeleportRestPeriodInsane,
	BossProfileData_TeleportRestPeriodNightmare,
	BossProfileData_TeleportRestPeriodApollyon,

	BossProfileData_TeleportStressMinEasy,
	BossProfileData_TeleportStressMinNormal,
	BossProfileData_TeleportStressMinHard,
	BossProfileData_TeleportStressMinInsane,
	BossProfileData_TeleportStressMinNightmare,
	BossProfileData_TeleportStressMinApollyon,

	BossProfileData_TeleportStressMaxEasy,
	BossProfileData_TeleportStressMaxNormal,
	BossProfileData_TeleportStressMaxHard,
	BossProfileData_TeleportStressMaxInsane,
	BossProfileData_TeleportStressMaxNightmare,
	BossProfileData_TeleportStressMaxApollyon,

	BossProfileData_TeleportPersistencyPeriodEasy,
	BossProfileData_TeleportPersistencyPeriodNormal,
	BossProfileData_TeleportPersistencyPeriodHard,
	BossProfileData_TeleportPersistencyPeriodInsane,
	BossProfileData_TeleportPersistencyPeriodNightmare,
	BossProfileData_TeleportPersistencyPeriodApollyon,

	BossProfileData_JumpscareDistanceEasy,
	BossProfileData_JumpscareDistanceNormal,
	BossProfileData_JumpscareDistanceHard,
	BossProfileData_JumpscareDistanceInsane,
	BossProfileData_JumpscareDistanceNightmare,
	BossProfileData_JumpscareDistanceApollyon,

	BossProfileData_JumpscareDurationEasy,
	BossProfileData_JumpscareDurationNormal,
	BossProfileData_JumpscareDurationHard,
	BossProfileData_JumpscareDurationInsane,
	BossProfileData_JumpscareDurationNightmare,
	BossProfileData_JumpscareDurationApollyon,

	BossProfileData_JumpscareCooldownEasy,
	BossProfileData_JumpscareCooldownNormal,
	BossProfileData_JumpscareCooldownHard,
	BossProfileData_JumpscareCooldownInsane,
	BossProfileData_JumpscareCooldownNightmare,
	BossProfileData_JumpscareCooldownApollyon,

	BossProfileData_JumpscareOnScare,

	BossProfileData_ProxyDamageVsEnemyEasy,
	BossProfileData_ProxyDamageVsEnemyNormal,
	BossProfileData_ProxyDamageVsEnemyHard,
	BossProfileData_ProxyDamageVsEnemyInsane,
	BossProfileData_ProxyDamageVsEnemyNightmare,
	BossProfileData_ProxyDamageVsEnemyApollyon,

	BossProfileData_ProxyDamageVsBackstabEasy,
	BossProfileData_ProxyDamageVsBackstabNormal,
	BossProfileData_ProxyDamageVsBackstabHard,
	BossProfileData_ProxyDamageVsBackstabInsane,
	BossProfileData_ProxyDamageVsBackstabNightmare,
	BossProfileData_ProxyDamageVsBackstabApollyon,

	BossProfileData_ProxyDamageVsSelfEasy,
	BossProfileData_ProxyDamageVsSelfNormal,
	BossProfileData_ProxyDamageVsSelfHard,
	BossProfileData_ProxyDamageVsSelfInsane,
	BossProfileData_ProxyDamageVsSelfNightmare,
	BossProfileData_ProxyDamageVsSelfApollyon,

	BossProfileData_ProxyControlGainHitEnemyEasy,
	BossProfileData_ProxyControlGainHitEnemyNormal,
	BossProfileData_ProxyControlGainHitEnemyHard,
	BossProfileData_ProxyControlGainHitEnemyInsane,
	BossProfileData_ProxyControlGainHitEnemyNightmare,
	BossProfileData_ProxyControlGainHitEnemyApollyon,
	
	BossProfileData_ProxyControlGainHitByEnemyEasy,
	BossProfileData_ProxyControlGainHitByEnemyNormal,
	BossProfileData_ProxyControlGainHitByEnemyHard,
	BossProfileData_ProxyControlGainHitByEnemyInsane,
	BossProfileData_ProxyControlGainHitByEnemyNightmare,
	BossProfileData_ProxyControlGainHitByEnemyApollyon,

	BossProfileData_ProxyControlDrainRateEasy,
	BossProfileData_ProxyControlDrainRateNormal,
	BossProfileData_ProxyControlDrainRateHard,
	BossProfileData_ProxyControlDrainRateInsane,
	BossProfileData_ProxyControlDrainRateNightmare,
	BossProfileData_ProxyControlDrainRateApollyon,

	BossProfileData_ProxyMaxEasy,
	BossProfileData_ProxyMaxNormal,
	BossProfileData_ProxyMaxHard,
	BossProfileData_ProxyMaxInsane,
	BossProfileData_ProxyMaxNightmare,
	BossProfileData_ProxyMaxApollyon,

	BossProfileData_ProxySpawnChanceMinEasy,
	BossProfileData_ProxySpawnChanceMinNormal,
	BossProfileData_ProxySpawnChanceMinHard,
	BossProfileData_ProxySpawnChanceMinInsane,
	BossProfileData_ProxySpawnChanceMinNightmare,
	BossProfileData_ProxySpawnChanceMinApollyon,

	BossProfileData_ProxySpawnChanceMaxEasy,
	BossProfileData_ProxySpawnChanceMaxNormal,
	BossProfileData_ProxySpawnChanceMaxHard,
	BossProfileData_ProxySpawnChanceMaxInsane,
	BossProfileData_ProxySpawnChanceMaxNightmare,
	BossProfileData_ProxySpawnChanceMaxApollyon,

	BossProfileData_ProxySpawnChanceThresholdEasy,
	BossProfileData_ProxySpawnChanceThresholdNormal,
	BossProfileData_ProxySpawnChanceThresholdHard,
	BossProfileData_ProxySpawnChanceThresholdInsane,
	BossProfileData_ProxySpawnChanceThresholdNightmare,
	BossProfileData_ProxySpawnChanceThresholdApollyon,

	BossProfileData_ProxySpawnNumMinEasy,
	BossProfileData_ProxySpawnNumMinNormal,
	BossProfileData_ProxySpawnNumMinHard,
	BossProfileData_ProxySpawnNumMinInsane,
	BossProfileData_ProxySpawnNumMinNightmare,
	BossProfileData_ProxySpawnNumMinApollyon,

	BossProfileData_ProxySpawnNumMaxEasy,
	BossProfileData_ProxySpawnNumMaxNormal,
	BossProfileData_ProxySpawnNumMaxHard,
	BossProfileData_ProxySpawnNumMaxInsane,
	BossProfileData_ProxySpawnNumMaxNightmare,
	BossProfileData_ProxySpawnNumMaxApollyon,

	BossProfileData_ProxySpawnCooldownMinEasy,
	BossProfileData_ProxySpawnCooldownMinNormal,
	BossProfileData_ProxySpawnCooldownMinHard,
	BossProfileData_ProxySpawnCooldownMinInsane,
	BossProfileData_ProxySpawnCooldownMinNightmare,
	BossProfileData_ProxySpawnCooldownMinApollyon,

	BossProfileData_ProxySpawnCooldownMaxEasy,
	BossProfileData_ProxySpawnCooldownMaxNormal,
	BossProfileData_ProxySpawnCooldownMaxHard,
	BossProfileData_ProxySpawnCooldownMaxInsane,
	BossProfileData_ProxySpawnCooldownMaxNightmare,
	BossProfileData_ProxySpawnCooldownMaxApollyon,

	BossProfileData_ProxyTeleportRangeMinEasy,
	BossProfileData_ProxyTeleportRangeMinNormal,
	BossProfileData_ProxyTeleportRangeMinHard,
	BossProfileData_ProxyTeleportRangeMinInsane,
	BossProfileData_ProxyTeleportRangeMinNightmare,
	BossProfileData_ProxyTeleportRangeMinApollyon,

	BossProfileData_ProxyTeleportRangeMaxEasy,
	BossProfileData_ProxyTeleportRangeMaxNormal,
	BossProfileData_ProxyTeleportRangeMaxHard,
	BossProfileData_ProxyTeleportRangeMaxInsane,
	BossProfileData_ProxyTeleportRangeMaxNightmare,
	BossProfileData_ProxyTeleportRangeMaxApollyon,

	BossProfileData_ProxyAllowNormalVoices,

	BossProfileData_ProxyWeapons,

	BossProfileData_ProxyHurtChannel,
	BossProfileData_ProxyHurtLevel,
	BossProfileData_ProxyHurtFlags,
	BossProfileData_ProxyHurtVolume,
	BossProfileData_ProxyHurtPitch,

	BossProfileData_ProxyDeathChannel,
	BossProfileData_ProxyDeathLevel,
	BossProfileData_ProxyDeathFlags,
	BossProfileData_ProxyDeathVolume,
	BossProfileData_ProxyDeathPitch,

	BossProfileData_ProxyIdleChannel,
	BossProfileData_ProxyIdleLevel,
	BossProfileData_ProxyIdleFlags,
	BossProfileData_ProxyIdleVolume,
	BossProfileData_ProxyIdlePitch,
	BossProfileData_ProxyIdleCooldownMin,
	BossProfileData_ProxyIdleCooldownMax,

	BossProfileData_ProxySpawnChannel,
	BossProfileData_ProxySpawnLevel,
	BossProfileData_ProxySpawnFlags,
	BossProfileData_ProxySpawnVolume,
	BossProfileData_ProxySpawnPitch,

	BossProfileData_ProxySpawnEffectEnabled,
	BossProfileData_ProxySpawnEffectLifetime,
	BossProfileData_ProxySpawnEffectZPosOffset,

	BossProfileData_FakeCopyEnabled,

	BossProfileData_DrainCreditEnabled,
	BossProfileData_DrainCreditAmountEasy,
	BossProfileData_DrainCreditAmountNormal,
	BossProfileData_DrainCreditAmountHard,
	BossProfileData_DrainCreditAmountInsane,
	BossProfileData_DrainCreditAmountNightmare,
	BossProfileData_DrainCreditAmountApollyon,

	BossProfileData_TeleportType,

	BossProfileData_UseHealthbar,

	BossProfileData_DeathMessageDifficultyIndexes,

	//Gaben stuff
	BossProfileData_BurnRagdoll,
	BossProfileData_CloakRagdoll,
	BossProfileData_DecapRagdoll,
	BossProfileData_GibRagdoll,
	BossProfileData_IceRagdoll,
	BossProfileData_GoldRagdoll,
	BossProfileData_ElectrocuteRagdoll,
	BossProfileData_AshRagdoll,
	BossProfileData_DeleteRagdoll,
	BossProfileData_PushRagdoll,
	BossProfileData_DissolveRagdoll,
	BossProfileData_DissolveKillType,
	BossProfileData_PlasmaRagdoll,
	BossProfileData_ResizeRagdoll,
	BossProfileData_ResizeRagdollHead,
	BossProfileData_ResizeRagdollHands,
	BossProfileData_ResizeRagdollTorso,
	BossProfileData_DecapOrGipRagdoll,
	BossProfileData_SilentKill,
	BossProfileData_MultieffectRagdoll,
	BossProfileData_CustomDeathFlag,
	BossProfileData_CustomDeathFlagType,
	BossProfileData_OutroMusicEnabled,

	BossProfileData_MaxStats
};

/**
 *	Loads a profile in the current KeyValues position in kv.
 */
public bool LoadBossProfile(KeyValues kv, const char[] sProfile, char[] sLoadFailReasonBuffer, int iLoadFailReasonBufferLen)
{
	int iBossType = kv.GetNum("type", SF2BossType_Unknown);
	if (iBossType == SF2BossType_Unknown || iBossType >= SF2BossType_MaxTypes) 
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "boss type is unknown!");
		return false;
	}
	
	float flBossModelScale = kv.GetFloat("model_scale", 1.0);
	if (flBossModelScale <= 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "model_scale must be a value greater than 0!");
		return false;
	}
	
	int iBossHealth = kv.GetNum("health", 30000);
	if (iBossHealth < 1)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "health must be a value that is at least 1!");
		return false;
	}
	
	int iBossSkin = kv.GetNum("skin", 0);
	if (iBossSkin < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "skin must be a value that is at least 0!");
		return false;
	}
	int iBossSkinEasy = kv.GetNum("skin_easy", iBossSkin);
	int iBossSkinHard = kv.GetNum("skin_hard", iBossSkin);
	int iBossSkinInsane = kv.GetNum("skin_insane", iBossSkinHard);
	int iBossSkinNightmare = kv.GetNum("skin_nightmare", iBossSkinInsane);
	int iBossSkinApollyon = kv.GetNum("skin_apollyon", iBossSkinNightmare);
	
	int iBossSkinMax = kv.GetNum("skin_max", 0);
	if (iBossSkinMax < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "skin_max must be a value that is at least 0!");
		return false;
	}
	
	int iBossBodyGroups = kv.GetNum("body");
	if (iBossBodyGroups < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "body must be a value that is at least 0!");
		return false;
	}

	int iBossBodyGroupsEasy = kv.GetNum("body_easy", iBossBodyGroups);
	int iBossBodyGroupsHard = kv.GetNum("body_hard", iBossBodyGroups);
	int iBossBodyGroupsInsane = kv.GetNum("body_insane", iBossBodyGroupsHard);
	int iBossBodyGroupsNightmare = kv.GetNum("body_nightmare", iBossBodyGroupsInsane);
	int iBossBodyGroupsApollyon = kv.GetNum("body_apollyon", iBossBodyGroupsNightmare);

	int iBossBodyGroupsMax = kv.GetNum("body_max", 0);
	if (iBossBodyGroupsMax < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "body_max must be a value that is at least 0!");
		return false;
	}
	
	int iUseRaidHitbox = kv.GetNum("use_raid_hitbox");
	if (iUseRaidHitbox < 0)
	{
		iUseRaidHitbox = 0;
	}
	else if (iUseRaidHitbox > 1)
	{
		iUseRaidHitbox = 1;
	}

	float flBossAngerStart = kv.GetFloat("anger_start", 1.0);
	if (flBossAngerStart < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "anger_start must be a value that is at least 0!");
		return false;
	}
	
	float flBossInstantKillRadius = kv.GetFloat("kill_radius");
	if (flBossInstantKillRadius < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "kill_radius must be a value that is at least 0!");
		return false;
	}
	
	float flBossScareRadius = kv.GetFloat("scare_radius");
	if (flBossScareRadius < 0.0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "scare_radius must be a value that is at least 0!");
		return false;
	}

	int iBossTeleportType = kv.GetNum("teleport_type");
	if (iBossTeleportType < 0)
	{
		FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown teleport type!");
		return false;
	}
	
	FormatEx(sLoadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown!");
	
	float flBossFOV = kv.GetFloat("fov", 90.0);
	if (flBossFOV < 0.0)
	{
		flBossFOV = 0.0;
	}
	else if (flBossFOV > 360.0)
	{
		flBossFOV = 360.0;
	}
	
	float flBossMaxTurnRate = kv.GetFloat("turnrate", 90.0);
	if (flBossMaxTurnRate < 0.0)
	{
		flBossMaxTurnRate = 0.0;
	}
	
	float flBossScareCooldown = kv.GetFloat("scare_cooldown");
	if (flBossScareCooldown < 0.0)
	{
		// clamp value 
		flBossScareCooldown = 0.0;
	}
	
	float flBossAngerAddOnPageGrab = kv.GetFloat("anger_add_on_page_grab", -1.0);
	if (flBossAngerAddOnPageGrab < 0.0)
	{
		flBossAngerAddOnPageGrab = kv.GetFloat("anger_page_add", -1.0);		// backwards compatibility
		if (flBossAngerAddOnPageGrab < 0.0)
		{
			flBossAngerAddOnPageGrab = 0.0;
		}
	}
	
	float flBossAngerPageGrabTimeDiffReq = kv.GetFloat("anger_req_page_grab_time_diff", -1.0);
	if (flBossAngerPageGrabTimeDiffReq < 0.0)
	{
		flBossAngerPageGrabTimeDiffReq = kv.GetFloat("anger_page_time_diff", -1.0);		// backwards compatibility
		if (flBossAngerPageGrabTimeDiffReq < 0.0)
		{
			flBossAngerPageGrabTimeDiffReq = 0.0;
		}
	}

	float flBlinkLookRateMultiplier = kv.GetFloat("blink_look_rate_multiply", 1.0);
	float flBlinkStaticRateMultiplier = kv.GetFloat("blink_static_rate_multiply", 1.0);
	
	bool bDeathCam = view_as<bool>(kv.GetNum("death_cam"));
	bool bDeathCamScareSound = view_as<bool>(kv.GetNum("death_cam_play_scare_sound"));
	bool bDeathCamPublic = view_as<bool>(kv.GetNum("death_cam_public"));
	float flDeathCamPublicSpeed = kv.GetFloat("death_cam_speed", 1000.0);
	float flDeathCamPublicAcceleration = kv.GetFloat("death_cam_acceleration", 1000.0);
	float flDeathCamPublicDeceleration = kv.GetFloat("death_cam_deceleration", 1000.0);
	float flDeathCamBackwardOffset = kv.GetFloat("deathcam_death_backward_offset");
	float flDeathCamDownwardOffset = kv.GetFloat("deathcam_death_downward_offset");
	bool bDeathCamOverlay = view_as<bool>(kv.GetNum("death_cam_overlay"));
	float flDeathCamOverlayTimeStart = kv.GetFloat("death_cam_time_overlay_start");
	if (flDeathCamOverlayTimeStart < 0.0) flDeathCamOverlayTimeStart = 0.0;
	float flDeathCamTime = kv.GetFloat("death_cam_time_death");
	if (flDeathCamTime < 0.0) flDeathCamTime = 0.0;

	float flSoundMusicLoop = kv.GetFloat("sound_music_loop", 0.0);
	float flSoundMusicLoopEasy = kv.GetFloat("sound_music_loop_easy", flSoundMusicLoop);
	float flSoundMusicLoopHard = kv.GetFloat("sound_music_loop_hard", flSoundMusicLoop);
	float flSoundMusicLoopInsane = kv.GetFloat("sound_music_loop_insane", flSoundMusicLoopHard);
	float flSoundMusicLoopNightmare = kv.GetFloat("sound_music_loop_nightmare", flSoundMusicLoopNightmare);
	float flSoundMusicLoopApollyon = kv.GetFloat("sound_music_loop_apollyon", flSoundMusicLoopApollyon);

	float flInstantKillCooldown = kv.GetFloat("kill_cooldown");
	float flInstantKillCooldownEasy = kv.GetFloat("kill_cooldown_easy", flInstantKillCooldown);
	float flInstantKillCooldownHard = kv.GetFloat("kill_cooldown_hard", flInstantKillCooldown);
	float flInstantKillCooldownInsane = kv.GetFloat("kill_cooldown_insane", flInstantKillCooldownHard);
	float flInstantKillCooldownNightmare = kv.GetFloat("kill_cooldown_nightmare", flInstantKillCooldownInsane);
	float flInstantKillCooldownApollyon = kv.GetFloat("kill_cooldown_apollyon", flInstantKillCooldownNightmare);

	int iCopyMax = kv.GetNum("copy_max", 10);
	int iCopyMaxEasy = kv.GetNum("copy_max_easy", iCopyMax);
	int iCopyMaxHard = kv.GetNum("copy_max_hard", iCopyMax);
	int iCopyMaxInsane = kv.GetNum("copy_max_insane", iCopyMaxHard);
	int iCopyMaxNightmare = kv.GetNum("copy_max_nightmare", iCopyMaxInsane);
	int iCopyMaxApollyon = kv.GetNum("copy_max_apollyon", iCopyMaxNightmare);
	
	float flBossSearchRadius = kv.GetFloat("search_range", 1024.0);
	float flBossSearchRadiusEasy = kv.GetFloat("search_range_easy", flBossSearchRadius);
	float flBossSearchRadiusHard = kv.GetFloat("search_range_hard", flBossSearchRadius);
	float flBossSearchRadiusInsane = kv.GetFloat("search_range_insane", flBossSearchRadiusHard);
	float flBossSearchRadiusNightmare = kv.GetFloat("search_range_nightmare", flBossSearchRadiusInsane);
	float flBossSearchRadiusApollyon = kv.GetFloat("search_range_apollyon", flBossSearchRadiusNightmare);

	float flBossSearchSoundRadius = kv.GetFloat("search_sound_range", 1024.0);
	float flBossSearchSoundRadiusEasy = kv.GetFloat("search_sound_range_easy", flBossSearchSoundRadius);
	float flBossSearchSoundRadiusHard = kv.GetFloat("search_sound_range_hard", flBossSearchSoundRadius);
	float flBossSearchSoundRadiusInsane = kv.GetFloat("search_sound_range_insane", flBossSearchSoundRadiusHard);
	float flBossSearchSoundRadiusNightmare = kv.GetFloat("search_sound_range_nightmare", flBossSearchSoundRadiusInsane);
	float flBossSearchSoundRadiusApollyon = kv.GetFloat("search_sound_range_apollyon", flBossSearchSoundRadiusNightmare);

	float flBossTeleportRangeMin = kv.GetFloat("teleport_range_min", 325.0);
	float flBossTeleportRangeMinEasy = kv.GetFloat("teleport_range_min_easy", flBossTeleportRangeMin);
	float flBossTeleportRangeMinHard = kv.GetFloat("teleport_range_min_hard", flBossTeleportRangeMin);
	float flBossTeleportRangeMinInsane = kv.GetFloat("teleport_range_min_insane", flBossTeleportRangeMinHard);
	float flBossTeleportRangeMinNightmare = kv.GetFloat("teleport_range_min_nightmare", flBossTeleportRangeMinInsane);
	float flBossTeleportRangeMinApollyon = kv.GetFloat("teleport_range_min_apollyon", flBossTeleportRangeMinNightmare);

	float flBossTeleportRangeMax = kv.GetFloat("teleport_range_max", 1024.0);
	float flBossTeleportRangeMaxEasy = kv.GetFloat("teleport_range_max_easy", flBossTeleportRangeMax);
	float flBossTeleportRangeMaxHard = kv.GetFloat("teleport_range_max_hard", flBossTeleportRangeMax);
	float flBossTeleportRangeMaxInsane = kv.GetFloat("teleport_range_max_insane", flBossTeleportRangeMaxHard);
	float flBossTeleportRangeMaxNightmare = kv.GetFloat("teleport_range_max_nightmare", flBossTeleportRangeMaxInsane);
	float flBossTeleportRangeMaxApollyon = kv.GetFloat("teleport_range_max_apollyon", flBossTeleportRangeMaxNightmare);

	float flBossTeleportTimeMin = kv.GetFloat("teleport_time_min", 5.0);
	float flBossTeleportTimeMinEasy = kv.GetFloat("teleport_time_min_easy", flBossTeleportTimeMin);
	float flBossTeleportTimeMinHard = kv.GetFloat("teleport_time_min_hard", flBossTeleportTimeMin);
	float flBossTeleportTimeMinInsane = kv.GetFloat("teleport_time_min_insane", flBossTeleportTimeMinHard);
	float flBossTeleportTimeMinNightmare = kv.GetFloat("teleport_time_min_nightmare", flBossTeleportTimeMinInsane);
	float flBossTeleportTimeMinApollyon = kv.GetFloat("teleport_time_min_apollyon", flBossTeleportTimeMinNightmare);

	float flBossTeleportTimeMax = kv.GetFloat("teleport_time_max", 9.0);
	float flBossTeleportTimeMaxEasy = kv.GetFloat("teleport_time_max_easy", flBossTeleportTimeMax);
	float flBossTeleportTimeMaxHard = kv.GetFloat("teleport_time_max_hard", flBossTeleportTimeMax);
	float flBossTeleportTimeMaxInsane = kv.GetFloat("teleport_time_max_insane", flBossTeleportTimeMaxHard);
	float flBossTeleportTimeMaxNightmare = kv.GetFloat("teleport_time_max_nightmare", flBossTeleportTimeMaxInsane);
	float flBossTeleportTimeMaxApollyon = kv.GetFloat("teleport_time_max_apollyon", flBossTeleportTimeMaxNightmare);

	float flBossTeleportRestPeriod = kv.GetFloat("teleport_target_rest_period", 15.0);
	float flBossTeleportRestPeriodEasy = kv.GetFloat("teleport_target_rest_period_easy", flBossTeleportRestPeriod);
	float flBossTeleportRestPeriodHard = kv.GetFloat("teleport_target_rest_period_hard", flBossTeleportRestPeriod);
	float flBossTeleportRestPeriodInsane = kv.GetFloat("teleport_target_rest_period_insane", flBossTeleportRestPeriodHard);
	float flBossTeleportRestPeriodNightmare = kv.GetFloat("teleport_target_rest_period_nightmare", flBossTeleportRestPeriodInsane);
	float flBossTeleportRestPeriodApollyon = kv.GetFloat("teleport_target_rest_period_apollyon", flBossTeleportRestPeriodNightmare);

	float flBossTeleportStressMin = kv.GetFloat("teleport_target_stress_min", 0.2);
	float flBossTeleportStressMinEasy = kv.GetFloat("teleport_target_stress_min_easy", flBossTeleportStressMin);
	float flBossTeleportStressMinHard = kv.GetFloat("teleport_target_stress_min_hard", flBossTeleportStressMin);
	float flBossTeleportStressMinInsane = kv.GetFloat("teleport_target_stress_min_insane", flBossTeleportStressMinHard);
	float flBossTeleportStressMinNightmare = kv.GetFloat("teleport_target_stress_min_nightmare", flBossTeleportStressMinInsane);
	float flBossTeleportStressMinApollyon = kv.GetFloat("teleport_target_stress_min_apollyon", flBossTeleportStressMinNightmare);

	float flBossTeleportStressMax = kv.GetFloat("teleport_target_stress_max", 0.9);
	float flBossTeleportStressMaxEasy = kv.GetFloat("teleport_target_stress_max_easy", flBossTeleportStressMax);
	float flBossTeleportStressMaxHard = kv.GetFloat("teleport_target_stress_max_hard", flBossTeleportStressMax);
	float flBossTeleportStressMaxInsane = kv.GetFloat("teleport_target_stress_max_insane", flBossTeleportStressMaxHard);
	float flBossTeleportStressMaxNightmare = kv.GetFloat("teleport_target_stress_max_nightmare", flBossTeleportStressMaxInsane);
	float flBossTeleportStressMaxApollyon = kv.GetFloat("teleport_target_stress_max_apollyon", flBossTeleportStressMaxNightmare);

	float flBossTeleportPersistencyPeriod = kv.GetFloat("teleport_target_persistency_period", 13.0);
	float flBossTeleportPersistencyPeriodEasy = kv.GetFloat("teleport_target_persistency_period_easy", flBossTeleportPersistencyPeriod);
	float flBossTeleportPersistencyPeriodHard = kv.GetFloat("teleport_target_persistency_period_hard", flBossTeleportPersistencyPeriod);
	float flBossTeleportPersistencyPeriodInsane = kv.GetFloat("teleport_target_persistency_period_insane", flBossTeleportPersistencyPeriodHard);
	float flBossTeleportPersistencyPeriodNightmare = kv.GetFloat("teleport_target_persistency_period_nightmare", flBossTeleportPersistencyPeriodInsane);
	float flBossTeleportPersistencyPeriodApollyon = kv.GetFloat("teleport_target_persistency_period_apollyon", flBossTeleportPersistencyPeriodNightmare);

	float flBossJumpscareDistance = kv.GetFloat("jumpscare_distance");
	float flBossJumpscareDistanceEasy = kv.GetFloat("jumpscare_distance_easy", flBossJumpscareDistance);
	float flBossJumpscareDistanceHard = kv.GetFloat("jumpscare_distance_hard", flBossJumpscareDistance);
	float flBossJumpscareDistanceInsane = kv.GetFloat("jumpscare_distance_insane", flBossJumpscareDistanceHard);
	float flBossJumpscareDistanceNightmare = kv.GetFloat("jumpscare_distance_nightmare", flBossJumpscareDistanceInsane);
	float flBossJumpscareDistanceApollyon = kv.GetFloat("jumpscare_distance_apollyon", flBossJumpscareDistanceNightmare);

	float flBossJumpscareDuration = kv.GetFloat("jumpscare_duration", 0.0);
	float flBossJumpscareDurationEasy = kv.GetFloat("jumpscare_duration_easy", flBossJumpscareDuration);
	float flBossJumpscareDurationHard = kv.GetFloat("jumpscare_duration_hard", flBossJumpscareDuration);
	float flBossJumpscareDurationInsane = kv.GetFloat("jumpscare_duration_insane", flBossJumpscareDurationHard);
	float flBossJumpscareDurationNightmare = kv.GetFloat("jumpscare_duration_nightmare", flBossJumpscareDurationInsane);
	float flBossJumpscareDurationApollyon = kv.GetFloat("jumpscare_duration_apollyon", flBossJumpscareDurationNightmare);

	float flBossJumpscareCooldown = kv.GetFloat("jumpscare_cooldown");
	float flBossJumpscareCooldownEasy = kv.GetFloat("jumpscare_cooldown_easy", flBossJumpscareCooldown);
	float flBossJumpscareCooldownHard = kv.GetFloat("jumpscare_cooldown_hard", flBossJumpscareCooldown);
	float flBossJumpscareCooldownInsane = kv.GetFloat("jumpscare_cooldown_insane", flBossJumpscareCooldownHard);
	float flBossJumpscareCooldownNightmare = kv.GetFloat("jumpscare_cooldown_nightmare", flBossJumpscareCooldownInsane);
	float flBossJumpscareCooldownApollyon = kv.GetFloat("jumpscare_cooldown_apollyon", flBossJumpscareCooldownNightmare);

	float flBossDefaultSpeed = kv.GetFloat("speed", 150.0);
	float flBossSpeedEasy = kv.GetFloat("speed_easy", flBossDefaultSpeed);
	float flBossSpeedHard = kv.GetFloat("speed_hard", flBossDefaultSpeed);
	float flBossSpeedInsane = kv.GetFloat("speed_insane", flBossSpeedHard);
	float flBossSpeedNightmare = kv.GetFloat("speed_nightmare", flBossSpeedInsane);
	float flBossSpeedApollyon = kv.GetFloat("speed_apollyon", flBossSpeedNightmare);
	
	float flBossDefaultMaxSpeed = kv.GetFloat("speed_max", 150.0);
	float flBossMaxSpeedEasy = kv.GetFloat("speed_max_easy", flBossDefaultMaxSpeed);
	float flBossMaxSpeedHard = kv.GetFloat("speed_max_hard", flBossDefaultMaxSpeed);
	float flBossMaxSpeedInsane = kv.GetFloat("speed_max_insane", flBossMaxSpeedHard);
	float flBossMaxSpeedNightmare = kv.GetFloat("speed_max_nightmare", flBossMaxSpeedInsane);
	float flBossMaxSpeedApollyon = kv.GetFloat("speed_max_apollyon", flBossMaxSpeedNightmare);

	float flBossDefaultAcceleration = kv.GetFloat("acceleration",150.0);
	float flBossAccelerationEasy = kv.GetFloat("acceleration_easy",flBossDefaultAcceleration);
	float flBossAccelerationHard = kv.GetFloat("acceleration_hard",flBossDefaultAcceleration);
	float flBossAccelerationInsane = kv.GetFloat("acceleration_insane",flBossAccelerationHard);
	float flBossAccelerationNightmare = kv.GetFloat("acceleration_nightmare",flBossAccelerationInsane);
	float flBossAccelerationApollyon = kv.GetFloat("acceleration_apollyon",flBossAccelerationNightmare);
	
	float flBossDefaultIdleLifetime = kv.GetFloat("idle_lifetime", 10.0);
	float flBossIdleLifetimeEasy = kv.GetFloat("idle_lifetime_easy", flBossDefaultIdleLifetime);
	float flBossIdleLifetimeHard = kv.GetFloat("idle_lifetime_hard", flBossDefaultIdleLifetime);
	float flBossIdleLifetimeInsane = kv.GetFloat("idle_lifetime_insane", flBossIdleLifetimeHard);
	float flBossIdleLifetimeNightmare = kv.GetFloat("idle_lifetime_nightmare", flBossIdleLifetimeInsane);
	float flBossIdleLifetimeApollyon = kv.GetFloat("idle_lifetime_apollyon", flBossIdleLifetimeNightmare);
	
	bool bUseCustomOutlines = view_as<bool>(kv.GetNum("customizable_outlines"));
	int iOutlineColorR = kv.GetNum("outline_color_r", 255);
	int iOutlineColorG = kv.GetNum("outline_color_g", 255);
	int iOutlineColorB = kv.GetNum("outline_color_b", 255);
	int iOutlineColorTrans = kv.GetNum("outline_color_transparency", 255);
	bool bRainbowOutline = view_as<bool>(kv.GetNum("enable_rainbow_outline"));
	float flRainbowCycleTime = kv.GetFloat("rainbow_outline_cycle_rate", 1.0);
	if (flRainbowCycleTime < 0.0) flRainbowCycleTime = 0.0;

	bool bSpeedBoostOnScare = view_as<bool>(kv.GetNum("scare_player_speed_boost"));
	float flScareSpeedBoostDuration = kv.GetFloat("scare_player_speed_boost_duration");

	bool bScareReaction = view_as<bool>(kv.GetNum("scare_player_reaction"));
	int iScareReactionType = kv.GetNum("scare_player_reaction_type", 1);
	if (iScareReactionType < 1) iScareReactionType = 1;
	if (iScareReactionType > 3) iScareReactionType = 3;
	
	bool bScareReplenishSprint = view_as<bool>(kv.GetNum("scare_player_replenish_sprint"));
	int iScareReplenishSprintAmount = kv.GetNum("scare_player_replenish_sprint_amount");

	float flStaticRadius = kv.GetFloat("static_radius", 0.0);
	float flStaticRadiusEasy = kv.GetFloat("static_radius_easy", flStaticRadius);
	float flStaticRadiusHard = kv.GetFloat("static_radius_hard", flStaticRadius);
	float flStaticRadiusInsane = kv.GetFloat("static_radius_insane", flStaticRadiusHard);
	float flStaticRadiusNightmare = kv.GetFloat("static_radius_nightmare", flStaticRadiusInsane);
	float flStaticRadiusApollyon = kv.GetFloat("static_radius_apollyon", flStaticRadiusNightmare);

	float flStaticRate = kv.GetFloat("static_rate");
	float flStaticRateEasy = kv.GetFloat("static_rate_easy", flStaticRate);
	float flStaticRateHard = kv.GetFloat("static_rate_hard", flStaticRate);
	float flStaticRateInsane = kv.GetFloat("static_rate_insane", flStaticRateHard);
	float flStaticRateNightmare = kv.GetFloat("static_rate_nightmare", flStaticRateInsane);
	float flStaticRateApollyon = kv.GetFloat("static_rate_apollyon", flStaticRateNightmare);

	float flStaticRateDecay = kv.GetFloat("static_rate_decay");
	float flStaticRateDecayEasy = kv.GetFloat("static_rate_decay_easy", flStaticRateDecay);
	float flStaticRateDecayHard = kv.GetFloat("static_rate_decay_hard", flStaticRateDecay);
	float flStaticRateDecayInsane = kv.GetFloat("static_rate_decay_insane", flStaticRateDecayHard);
	float flStaticRateDecayNightmare = kv.GetFloat("static_rate_decay_nightmare", flStaticRateDecayInsane);
	float flStaticRateDecayApollyon = kv.GetFloat("static_rate_decay_apollyon", flStaticRateDecayNightmare);

	float flStaticGraceTime = kv.GetFloat("static_on_look_gracetime", 1.0);
	float flStaticGraceTimeEasy = kv.GetFloat("static_on_look_gracetime_easy", flStaticGraceTime);
	float flStaticGraceTimeHard = kv.GetFloat("static_on_look_gracetime_hard", flStaticGraceTime);
	float flStaticGraceTimeInsane = kv.GetFloat("static_on_look_gracetime_insane", flStaticGraceTimeHard);
	float flStaticGraceTimeNightmare = kv.GetFloat("static_on_look_gracetime_nightmare", flStaticGraceTimeInsane);
	float flStaticGraceTimeApollyon = kv.GetFloat("static_on_look_gracetime_apollyon", flStaticGraceTimeNightmare);

	float flProxyDamageVsEnemy = kv.GetFloat("proxies_damage_scale_vs_enemy", 1.0);
	float flProxyDamageVsEnemyEasy = kv.GetFloat("proxies_damage_scale_vs_enemy_easy", flProxyDamageVsEnemy);
	float flProxyDamageVsEnemyHard = kv.GetFloat("proxies_damage_scale_vs_enemy_hard", flProxyDamageVsEnemy);
	float flProxyDamageVsEnemyInsane = kv.GetFloat("proxies_damage_scale_vs_enemy_insane", flProxyDamageVsEnemyHard);
	float flProxyDamageVsEnemyNightmare = kv.GetFloat("proxies_damage_scale_vs_enemy_nightmare", flProxyDamageVsEnemyInsane);
	float flProxyDamageVsEnemyApollyon = kv.GetFloat("proxies_damage_scale_vs_enemy_apollyon", flProxyDamageVsEnemyNightmare);

	float flProxyDamageVsBackstab = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab", 0.25);
	float flProxyDamageVsBackstabEasy = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_easy", flProxyDamageVsBackstab);
	float flProxyDamageVsBackstabHard = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_hard", flProxyDamageVsBackstab);
	float flProxyDamageVsBackstabInsane = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_insane", flProxyDamageVsBackstabHard);
	float flProxyDamageVsBackstabNightmare = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_nightmare", flProxyDamageVsBackstabInsane);
	float flProxyDamageVsBackstabApollyon = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_apollyon", flProxyDamageVsBackstabNightmare);

	float flProxyDamageVsSelf = kv.GetFloat("proxies_damage_scale_vs_self", 1.0);
	float flProxyDamageVsSelfEasy = kv.GetFloat("proxies_damage_scale_vs_self_easy", flProxyDamageVsSelf);
	float flProxyDamageVsSelfHard = kv.GetFloat("proxies_damage_scale_vs_self_hard", flProxyDamageVsSelf);
	float flProxyDamageVsSelfInsane = kv.GetFloat("proxies_damage_scale_vs_self_insane", flProxyDamageVsSelfHard);
	float flProxyDamageVsSelfNightmare = kv.GetFloat("proxies_damage_scale_vs_self_nightmare", flProxyDamageVsSelfInsane);
	float flProxyDamageVsSelfApollyon = kv.GetFloat("proxies_damage_scale_vs_self_apollyon", flProxyDamageVsSelfNightmare);

	int iProxyControlGainHitEnemy = kv.GetNum("proxies_controlgain_hitenemy");
	int iProxyControlGainHitEnemyEasy = kv.GetNum("proxies_controlgain_hitenemy_easy", iProxyControlGainHitEnemy);
	int iProxyControlGainHitEnemyHard = kv.GetNum("proxies_controlgain_hitenemy_hard", iProxyControlGainHitEnemy);
	int iProxyControlGainHitEnemyInsane = kv.GetNum("proxies_controlgain_hitenemy_insane", iProxyControlGainHitEnemyHard);
	int iProxyControlGainHitEnemyNightmare = kv.GetNum("proxies_controlgain_hitenemy_nightmare", iProxyControlGainHitEnemyInsane);
	int iProxyControlGainHitEnemyApollyon = kv.GetNum("proxies_controlgain_hitenemy_apollyon", iProxyControlGainHitEnemyNightmare);

	int iProxyControlGainHitByEnemy = kv.GetNum("proxies_controlgain_hitbyenemy");
	int iProxyControlGainHitByEnemyEasy = kv.GetNum("proxies_controlgain_hitbyenemy_easy", iProxyControlGainHitByEnemy);
	int iProxyControlGainHitByEnemyHard = kv.GetNum("proxies_controlgain_hitbyenemy_hard", iProxyControlGainHitByEnemy);
	int iProxyControlGainHitByEnemyInsane = kv.GetNum("proxies_controlgain_hitbyenemy_insane", iProxyControlGainHitByEnemyHard);
	int iProxyControlGainHitByEnemyNightmare = kv.GetNum("proxies_controlgain_hitbyenemy_nightmare", iProxyControlGainHitByEnemyInsane);
	int iProxyControlGainHitByEnemyApollyon = kv.GetNum("proxies_controlgain_hitbyenemy_apollyon", iProxyControlGainHitByEnemyNightmare);

	float flProxyControlDrainRate = kv.GetFloat("proxies_controldrainrate");
	float flProxyControlDrainRateEasy = kv.GetFloat("proxies_controldrainrate_easy", flProxyControlDrainRate);
	float flProxyControlDrainRateHard = kv.GetFloat("proxies_controldrainrate_hard", flProxyControlDrainRate);
	float flProxyControlDrainRateInsane = kv.GetFloat("proxies_controldrainrate_insane", flProxyControlDrainRateHard);
	float flProxyControlDrainRateNightmare = kv.GetFloat("proxies_controldrainrate_nightmare", flProxyControlDrainRateInsane);
	float flProxyControlDrainRateApollyon = kv.GetFloat("proxies_controldrainrate_apollyon", flProxyControlDrainRateNightmare);

	float flProxySpawnChanceMin = kv.GetFloat("proxies_spawn_chance_min");
	float flProxySpawnChanceMinEasy = kv.GetFloat("proxies_spawn_chance_min_easy", flProxySpawnChanceMin);
	float flProxySpawnChanceMinHard = kv.GetFloat("proxies_spawn_chance_min_hard", flProxySpawnChanceMin);
	float flProxySpawnChanceMinInsane = kv.GetFloat("proxies_spawn_chance_min_insane", flProxySpawnChanceMinHard);
	float flProxySpawnChanceMinNightmare = kv.GetFloat("proxies_spawn_chance_min_nightmare", flProxySpawnChanceMinInsane);
	float flProxySpawnChanceMinApollyon = kv.GetFloat("proxies_spawn_chance_min_apollyon", flProxySpawnChanceMinNightmare);

	float flProxySpawnChanceMax = kv.GetFloat("proxies_spawn_chance_max");
	float flProxySpawnChanceMaxEasy = kv.GetFloat("proxies_spawn_chance_max_easy", flProxySpawnChanceMax);
	float flProxySpawnChanceMaxHard = kv.GetFloat("proxies_spawn_chance_max_hard", flProxySpawnChanceMax);
	float flProxySpawnChanceMaxInsane = kv.GetFloat("proxies_spawn_chance_max_insane", flProxySpawnChanceMaxHard);
	float flProxySpawnChanceMaxNightmare = kv.GetFloat("proxies_spawn_chance_max_nightmare", flProxySpawnChanceMaxInsane);
	float flProxySpawnChanceMaxApollyon = kv.GetFloat("proxies_spawn_chance_max_apollyon", flProxySpawnChanceMaxNightmare);

	float flProxySpawnChanceThreshold = kv.GetFloat("proxies_spawn_chance_threshold");
	float flProxySpawnChanceThresholdEasy = kv.GetFloat("proxies_spawn_chance_threshold_easy", flProxySpawnChanceThreshold);
	float flProxySpawnChanceThresholdHard = kv.GetFloat("proxies_spawn_chance_threshold_hard", flProxySpawnChanceThreshold);
	float flProxySpawnChanceThresholdInsane = kv.GetFloat("proxies_spawn_chance_threshold_insane", flProxySpawnChanceThresholdHard);
	float flProxySpawnChanceThresholdNightmare = kv.GetFloat("proxies_spawn_chance_threshold_nightmare", flProxySpawnChanceThresholdInsane);
	float flProxySpawnChanceThresholdApollyon = kv.GetFloat("proxies_spawn_chance_threshold_apollyon", flProxySpawnChanceThresholdNightmare);

	int iProxySpawnNumMin = kv.GetNum("proxies_spawn_num_min");
	int iProxySpawnNumMinEasy = kv.GetNum("proxies_spawn_num_min_easy", iProxySpawnNumMin);
	int iProxySpawnNumMinHard = kv.GetNum("proxies_spawn_num_min_hard", iProxySpawnNumMin);
	int iProxySpawnNumMinInsane = kv.GetNum("proxies_spawn_num_min_insane", iProxySpawnNumMinHard);
	int iProxySpawnNumMinNightmare = kv.GetNum("proxies_spawn_num_min_nightmare", iProxySpawnNumMinInsane);
	int iProxySpawnNumMinApollyon = kv.GetNum("proxies_spawn_num_min_apollyon", iProxySpawnNumMinNightmare);

	int iProxySpawnNumMax = kv.GetNum("proxies_spawn_num_max");
	int iProxySpawnNumMaxEasy = kv.GetNum("proxies_spawn_num_max_easy", iProxySpawnNumMax);
	int iProxySpawnNumMaxHard = kv.GetNum("proxies_spawn_num_max_hard", iProxySpawnNumMax);
	int iProxySpawnNumMaxInsane = kv.GetNum("proxies_spawn_num_max_insane", iProxySpawnNumMaxHard);
	int iProxySpawnNumMaxNightmare = kv.GetNum("proxies_spawn_num_max_nightmare", iProxySpawnNumMaxInsane);
	int iProxySpawnNumMaxApollyon = kv.GetNum("proxies_spawn_num_max_apollyon", iProxySpawnNumMaxNightmare);

	float flProxySpawnCooldownMin = kv.GetFloat("proxies_spawn_cooldown_min");
	float flProxySpawnCooldownMinEasy = kv.GetFloat("proxies_spawn_cooldown_min_easy", flProxySpawnCooldownMin);
	float flProxySpawnCooldownMinHard = kv.GetFloat("proxies_spawn_cooldown_min_hard", flProxySpawnCooldownMin);
	float flProxySpawnCooldownMinInsane = kv.GetFloat("proxies_spawn_cooldown_min_insane", flProxySpawnCooldownMinHard);
	float flProxySpawnCooldownMinNightmare = kv.GetFloat("proxies_spawn_cooldown_min_nightmare", flProxySpawnCooldownMinInsane);
	float flProxySpawnCooldownMinApollyon = kv.GetFloat("proxies_spawn_cooldown_min_apollyon", flProxySpawnCooldownMinNightmare);

	float flProxySpawnCooldownMax = kv.GetFloat("proxies_spawn_cooldown_max");
	float flProxySpawnCooldownMaxEasy = kv.GetFloat("proxies_spawn_cooldown_max_easy", flProxySpawnCooldownMax);
	float flProxySpawnCooldownMaxHard = kv.GetFloat("proxies_spawn_cooldown_max_hard", flProxySpawnCooldownMax);
	float flProxySpawnCooldownMaxInsane = kv.GetFloat("proxies_spawn_cooldown_max_insane", flProxySpawnCooldownMaxHard);
	float flProxySpawnCooldownMaxNightmare = kv.GetFloat("proxies_spawn_cooldown_max_nightmare", flProxySpawnCooldownMaxInsane);
	float flProxySpawnCooldownMaxApollyon = kv.GetFloat("proxies_spawn_cooldown_max_apollyon", flProxySpawnCooldownMaxNightmare);

	int iProxyMax = kv.GetNum("proxies_max");
	int iProxyMaxEasy = kv.GetNum("proxies_max_easy", iProxyMax);
	int iProxyMaxHard = kv.GetNum("proxies_max_hard", iProxyMax);
	int iProxyMaxInsane = kv.GetNum("proxies_max_insane", iProxyMaxHard);
	int iProxyMaxNightmare = kv.GetNum("proxies_max_nightmare", iProxyMaxInsane);
	int iProxyMaxApollyon = kv.GetNum("proxies_max_apollyon", iProxyMaxNightmare);

	float flProxyTeleportRangeMin = kv.GetFloat("proxies_teleport_range_min", 500.0);
	float flProxyTeleportRangeMinEasy = kv.GetFloat("proxies_teleport_range_min_easy", flProxyTeleportRangeMin);
	float flProxyTeleportRangeMinHard = kv.GetFloat("proxies_teleport_range_min_hard", flProxyTeleportRangeMin);
	float flProxyTeleportRangeMinInsane = kv.GetFloat("proxies_teleport_range_min_insane", flProxyTeleportRangeMinHard);
	float flProxyTeleportRangeMinNightmare = kv.GetFloat("proxies_teleport_range_min_nightmare", flProxyTeleportRangeMinInsane);
	float flProxyTeleportRangeMinApollyon = kv.GetFloat("proxies_teleport_range_min_apollyon", flProxyTeleportRangeMinNightmare);

	float flProxyTeleportRangeMax = kv.GetFloat("proxies_teleport_range_max", 3200.0);
	float flProxyTeleportRangeMaxEasy = kv.GetFloat("proxies_teleport_range_max_easy", flProxyTeleportRangeMax);
	float flProxyTeleportRangeMaxHard = kv.GetFloat("proxies_teleport_range_max_hard", flProxyTeleportRangeMax);
	float flProxyTeleportRangeMaxInsane = kv.GetFloat("proxies_teleport_range_max_insane", flProxyTeleportRangeMaxHard);
	float flProxyTeleportRangeMaxNightmare = kv.GetFloat("proxies_teleport_range_max_nightmare", flProxyTeleportRangeMaxInsane);
	float flProxyTeleportRangeMaxApollyon = kv.GetFloat("proxies_teleport_range_max_apollyon", flProxyTeleportRangeMaxNightmare);

	int iProxyHurtChannel = kv.GetNum("sound_proxy_hurt_channel", SNDCHAN_AUTO);
	int iProxyHurtLevel = kv.GetNum("sound_proxy_hurt_level", SNDLEVEL_NORMAL);
	int iProxyHurtFlags = kv.GetNum("sound_proxy_hurt_flags", SND_NOFLAGS);
	float flProxyHurtVolume = kv.GetFloat("sound_proxy_hurt_volume", SNDVOL_NORMAL);
	int iProxyHurtPitch = kv.GetNum("sound_proxy_hurt_pitch", SNDPITCH_NORMAL);

	int iProxyDeathChannel = kv.GetNum("sound_proxy_death_channel", SNDCHAN_AUTO);
	int iProxyDeathLevel = kv.GetNum("sound_proxy_death_level", SNDLEVEL_NORMAL);
	int iProxyDeathFlags = kv.GetNum("sound_proxy_death_flags", SND_NOFLAGS);
	float flProxyDeathVolume = kv.GetFloat("sound_proxy_death_volume", SNDVOL_NORMAL);
	int iProxyDeathPitch = kv.GetNum("sound_proxy_death_pitch", SNDPITCH_NORMAL);

	int iProxyIdleChannel = kv.GetNum("sound_proxy_idle_channel", SNDCHAN_AUTO);
	int iProxyIdleLevel = kv.GetNum("sound_proxy_idle_level", SNDLEVEL_NORMAL);
	int iProxyIdleFlags = kv.GetNum("sound_proxy_idle_flags", SND_NOFLAGS);
	float flProxyIdleVolume = kv.GetFloat("sound_proxy_idle_volume", SNDVOL_NORMAL);
	int iProxyIdlePitch = kv.GetNum("sound_proxy_idle_pitch", SNDPITCH_NORMAL);
	float flProxyIdleCooldownMin = kv.GetFloat("sound_proxy_idle_cooldown_min", 1.5);
	float flProxyIdleCooldownMax = kv.GetFloat("sound_proxy_idle_cooldown_max", 3.0);

	int iProxySpawnChannel = kv.GetNum("sound_proxy_spawn_channel", SNDCHAN_AUTO);
	int iProxySpawnLevel = kv.GetNum("sound_proxy_spawn_level", SNDLEVEL_NORMAL);
	int iProxySpawnFlags = kv.GetNum("sound_proxy_spawn_flags", SND_NOFLAGS);
	float flProxySpawnVolume = kv.GetFloat("sound_proxy_spawn_volume", SNDVOL_NORMAL);
	int iProxySpawnPitch = kv.GetNum("sound_proxy_spawn_pitch", SNDPITCH_NORMAL);

	bool bProxySpawnEffects = view_as<bool>(kv.GetNum("proxies_spawn_effect_enabled"));
	float flProxySpawnEffectLifetime = kv.GetFloat("proxies_spawn_effect_lifetime", 0.1);
	float flProxySpawnEffectZOffset = kv.GetFloat("proxies_spawn_effect_z_offset");

	bool bProxyWeaponsEnabled = view_as<bool>(kv.GetNum("proxies_weapon", 0));

	bool bFakeCopies = view_as<bool>(kv.GetNum("fake_copies"));

	bool bDrainCreditsOnKill = view_as<bool>(kv.GetNum("drain_credits_on_kill"));
	int iCreditDrainAmount = kv.GetNum("drain_credits_amount", 50);
	int iCreditDrainAmountEasy = kv.GetNum("drain_credits_amount_easy", iCreditDrainAmount);
	int iCreditDrainAmountHard = kv.GetNum("drain_credits_amount_hard", iCreditDrainAmount);
	int iCreditDrainAmountInsane = kv.GetNum("drain_credits_amount_insane", iCreditDrainAmountHard);
	int iCreditDrainAmountNightmare = kv.GetNum("drain_credits_amount_nightmare", iCreditDrainAmountInsane);
	int iCreditDrainAmountApollyon = kv.GetNum("drain_credits_amount_apollyon", iCreditDrainAmountNightmare);

	bool bAshRagdoll = view_as<bool>(kv.GetNum("ash_ragdoll_on_kill"));
	if (!bAshRagdoll)
	{
		bAshRagdoll = view_as<bool>(kv.GetNum("disintegrate_ragdoll_on_kill"));
	}

	float flBossEyePosOffset[3];
	kv.GetVector("eye_pos", flBossEyePosOffset);
	
	float flBossEyeAngOffset[3];
	kv.GetVector("eye_ang_offset", flBossEyeAngOffset);

	// Parse through flags.
	int iBossFlags = 0;
	if (kv.GetNum("static_shake")) iBossFlags |= SFF_HASSTATICSHAKE;
	if (kv.GetNum("static_on_look")) iBossFlags |= SFF_STATICONLOOK;
	if (kv.GetNum("static_on_radius")) iBossFlags |= SFF_STATICONRADIUS;
	if (kv.GetNum("proxies")) iBossFlags |= SFF_PROXIES;
	if (kv.GetNum("jumpscare")) iBossFlags |= SFF_HASJUMPSCARE;
	if (kv.GetNum("sound_sight_enabled")) iBossFlags |= SFF_HASSIGHTSOUNDS;
	if (kv.GetNum("sound_static_loop_local_enabled")) iBossFlags |= SFF_HASSTATICLOOPLOCALSOUND;
	if (kv.GetNum("view_shake", 1)) iBossFlags |= SFF_HASVIEWSHAKE;
	if (kv.GetNum("copy")) iBossFlags |= SFF_COPIES;
	if (kv.GetNum("wander_move", 1)) iBossFlags |= SFF_WANDERMOVE;
	if (kv.GetNum("attack_props", 0)) iBossFlags |= SFF_ATTACKPROPS;
	if (kv.GetNum("attack_weaponsenable", 0)) iBossFlags |= SFF_WEAPONKILLS;
	if (kv.GetNum("kill_weaponsenable", 0)) iBossFlags |= SFF_WEAPONKILLSONRADIUS;
	if (kv.GetNum("random_attacks", 0)) iBossFlags |= SFF_RANDOMATTACKS;
	
	// Try validating unique profile type.
	// The unique profile index specifies the location of a boss's type-specific data in another array.

	int iUniqueProfileIndex = -1;
	
	switch (iBossType)
	{
		case SF2BossType_Chaser:
		{
			if (!LoadChaserBossProfile(kv, sProfile, iUniqueProfileIndex, sLoadFailReasonBuffer))
			{
				return false;
			}
		}
	}
	
	// Add the section to our config.
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile, true);
	KvCopySubkeys(kv, g_hConfig);
	
	bool createNewBoss = false;
	int iIndex = GetBossProfileList().FindString(sProfile);
	if (iIndex == -1)
	{
		createNewBoss = true;
	}
	
	// Add to/Modify our array.
	// Cache values into g_hBossProfileData, because traversing a KeyValues object is expensive.

	if (createNewBoss)
	{
		iIndex = g_hBossProfileData.Push(-1);
		g_hBossProfileNames.SetValue(sProfile, iIndex);
		
		// Add to the boss list since it's not there already.
		GetBossProfileList().PushString(sProfile);
	}

	g_hBossProfileData.Set(iIndex, iUniqueProfileIndex, BossProfileData_UniqueProfileIndex);
	g_hBossProfileData.Set(iIndex, iBossType, BossProfileData_Type);
	g_hBossProfileData.Set(iIndex, flBossModelScale, BossProfileData_ModelScale);
	g_hBossProfileData.Set(iIndex, iBossHealth, BossProfileData_Health);
	g_hBossProfileData.Set(iIndex, iBossSkin, BossProfileData_Skin);
	g_hBossProfileData.Set(iIndex, iBossSkinEasy, BossProfileData_SkinEasy);
	g_hBossProfileData.Set(iIndex, iBossSkinHard, BossProfileData_SkinHard);
	g_hBossProfileData.Set(iIndex, iBossSkinInsane, BossProfileData_SkinInsane);
	g_hBossProfileData.Set(iIndex, iBossSkinNightmare, BossProfileData_SkinNightmare);
	g_hBossProfileData.Set(iIndex, iBossSkinApollyon, BossProfileData_SkinApollyon);
	g_hBossProfileData.Set(iIndex, iBossSkinMax, BossProfileData_SkinMax);
	g_hBossProfileData.Set(iIndex, iBossBodyGroups, BossProfileData_Body);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsEasy, BossProfileData_BodyEasy);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsHard, BossProfileData_BodyHard);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsInsane, BossProfileData_BodyInsane);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsNightmare, BossProfileData_BodyNightmare);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsApollyon, BossProfileData_BodyApollyon);
	g_hBossProfileData.Set(iIndex, iBossBodyGroupsMax, BossProfileData_BodyMax);
	g_hBossProfileData.Set(iIndex, iUseRaidHitbox, BossProfileData_UseRaidHitbox);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("ignore_nav_prefer", 1)), BossProfileData_IgnoreNavPrefer);
	g_hBossProfileData.Set(iIndex, flBlinkLookRateMultiplier, BossProfileData_BlinkLookRateMultipler);
	g_hBossProfileData.Set(iIndex, flBlinkStaticRateMultiplier, BossProfileData_BlinkStaticRateMultiplier);

	g_hBossProfileData.Set(iIndex, bDeathCam, BossProfileData_HasDeathCam);
	g_hBossProfileData.Set(iIndex, bDeathCamScareSound, BossProfileData_DeathCamPlayScareSound);
	g_hBossProfileData.Set(iIndex, bDeathCamPublic, BossProfileData_PublicDeathCam);
	g_hBossProfileData.Set(iIndex, flDeathCamPublicSpeed, BossProfileData_PublicDeathCamSpeed);
	g_hBossProfileData.Set(iIndex, flDeathCamPublicAcceleration, BossProfileData_PublicDeathCamAcceleration);
	g_hBossProfileData.Set(iIndex, flDeathCamPublicDeceleration, BossProfileData_PublicDeathCamDeceleration);
	g_hBossProfileData.Set(iIndex, flDeathCamBackwardOffset, BossProfileData_PublicDeathCamBackwardOffset);
	g_hBossProfileData.Set(iIndex, flDeathCamDownwardOffset, BossProfileData_PublicDeathCamDownwardOffset);
	g_hBossProfileData.Set(iIndex, bDeathCamOverlay, BossProfileData_DeathCamOverlay);
	g_hBossProfileData.Set(iIndex, flDeathCamOverlayTimeStart, BossProfileData_DeathCamOverlayStartTime);
	g_hBossProfileData.Set(iIndex, flDeathCamTime, BossProfileData_DeathCamTime);

	g_hBossProfileData.Set(iIndex, flSoundMusicLoop, BossProfileData_SoundMusicLoopNormal);
	g_hBossProfileData.Set(iIndex, flSoundMusicLoopEasy, BossProfileData_SoundMusicLoopEasy);
	g_hBossProfileData.Set(iIndex, flSoundMusicLoopHard, BossProfileData_SoundMusicLoopHard);
	g_hBossProfileData.Set(iIndex, flSoundMusicLoopInsane, BossProfileData_SoundMusicLoopInsane);
	g_hBossProfileData.Set(iIndex, flSoundMusicLoopNightmare, BossProfileData_SoundMusicLoopNightmare);
	g_hBossProfileData.Set(iIndex, flSoundMusicLoopApollyon, BossProfileData_SoundMusicLoopApollyon);
	
	g_hBossProfileData.Set(iIndex, iCopyMax, BossProfileData_CopyNormal);
	g_hBossProfileData.Set(iIndex, iCopyMaxEasy, BossProfileData_CopyEasy);
	g_hBossProfileData.Set(iIndex, iCopyMaxHard, BossProfileData_CopyHard);
	g_hBossProfileData.Set(iIndex, iCopyMaxInsane, BossProfileData_CopyInsane);
	g_hBossProfileData.Set(iIndex, iCopyMaxNightmare, BossProfileData_CopyNightmare);
	g_hBossProfileData.Set(iIndex, iCopyMaxApollyon, BossProfileData_CopyApollyon);
	
	g_hBossProfileData.Set(iIndex, iBossFlags, BossProfileData_Flags);
	
	g_hBossProfileData.Set(iIndex, flBossDefaultSpeed, BossProfileData_SpeedNormal);
	g_hBossProfileData.Set(iIndex, flBossSpeedEasy, BossProfileData_SpeedEasy);
	g_hBossProfileData.Set(iIndex, flBossSpeedHard, BossProfileData_SpeedHard);
	g_hBossProfileData.Set(iIndex, flBossSpeedInsane, BossProfileData_SpeedInsane);
	g_hBossProfileData.Set(iIndex, flBossSpeedNightmare, BossProfileData_SpeedNightmare);
	g_hBossProfileData.Set(iIndex, flBossSpeedApollyon, BossProfileData_SpeedApollyon);
	
	g_hBossProfileData.Set(iIndex, flBossDefaultMaxSpeed, BossProfileData_MaxSpeedNormal);
	g_hBossProfileData.Set(iIndex, flBossMaxSpeedEasy, BossProfileData_MaxSpeedEasy);
	g_hBossProfileData.Set(iIndex, flBossMaxSpeedHard, BossProfileData_MaxSpeedHard);
	g_hBossProfileData.Set(iIndex, flBossMaxSpeedInsane, BossProfileData_MaxSpeedInsane);
	g_hBossProfileData.Set(iIndex, flBossMaxSpeedNightmare, BossProfileData_MaxSpeedNightmare);
	g_hBossProfileData.Set(iIndex, flBossMaxSpeedApollyon, BossProfileData_MaxSpeedApollyon);

	g_hBossProfileData.Set(iIndex, flBossDefaultAcceleration, BossProfileData_AccelerationNormal);
	g_hBossProfileData.Set(iIndex, flBossAccelerationEasy, BossProfileData_AccelerationEasy);
	g_hBossProfileData.Set(iIndex, flBossAccelerationHard, BossProfileData_AccelerationHard);
	g_hBossProfileData.Set(iIndex, flBossAccelerationInsane, BossProfileData_AccelerationInsane);
	g_hBossProfileData.Set(iIndex, flBossAccelerationNightmare, BossProfileData_AccelerationNightmare);
	g_hBossProfileData.Set(iIndex, flBossAccelerationApollyon, BossProfileData_AccelerationApollyon);

	g_hBossProfileData.Set(iIndex, flBossDefaultIdleLifetime, BossProfileData_IdleLifetimeNormal);
	g_hBossProfileData.Set(iIndex, flBossIdleLifetimeEasy, BossProfileData_IdleLifetimeEasy);
	g_hBossProfileData.Set(iIndex, flBossIdleLifetimeHard, BossProfileData_IdleLifetimeHard);
	g_hBossProfileData.Set(iIndex, flBossIdleLifetimeInsane, BossProfileData_IdleLifetimeInsane);
	g_hBossProfileData.Set(iIndex, flBossIdleLifetimeNightmare, BossProfileData_IdleLifetimeNightmare);
	g_hBossProfileData.Set(iIndex, flBossIdleLifetimeApollyon, BossProfileData_IdleLifetimeApollyon);
	
	g_hBossProfileData.Set(iIndex, flBossEyePosOffset[0], BossProfileData_EyePosOffsetX);
	g_hBossProfileData.Set(iIndex, flBossEyePosOffset[1], BossProfileData_EyePosOffsetY);
	g_hBossProfileData.Set(iIndex, flBossEyePosOffset[2], BossProfileData_EyePosOffsetZ);
	
	g_hBossProfileData.Set(iIndex, flBossEyeAngOffset[0], BossProfileData_EyeAngOffsetX);
	g_hBossProfileData.Set(iIndex, flBossEyeAngOffset[1], BossProfileData_EyeAngOffsetY);
	g_hBossProfileData.Set(iIndex, flBossEyeAngOffset[2], BossProfileData_EyeAngOffsetZ);
	
	g_hBossProfileData.Set(iIndex, flBossAngerStart, BossProfileData_AngerStart);
	g_hBossProfileData.Set(iIndex, flBossAngerAddOnPageGrab, BossProfileData_AngerAddOnPageGrab);
	g_hBossProfileData.Set(iIndex, flBossAngerPageGrabTimeDiffReq, BossProfileData_AngerPageGrabTimeDiffReq);
	
	g_hBossProfileData.Set(iIndex, flBossInstantKillRadius, BossProfileData_InstantKillRadius);

	g_hBossProfileData.Set(iIndex, flInstantKillCooldown, BossProfileData_InstantKillCooldownNormal);
	g_hBossProfileData.Set(iIndex, flInstantKillCooldownEasy, BossProfileData_InstantKillCooldownEasy);
	g_hBossProfileData.Set(iIndex, flInstantKillCooldownHard, BossProfileData_InstantKillCooldownHard);
	g_hBossProfileData.Set(iIndex, flInstantKillCooldownInsane, BossProfileData_InstantKillCooldownInsane);
	g_hBossProfileData.Set(iIndex, flInstantKillCooldownNightmare, BossProfileData_InstantKillCooldownNightmare);
	g_hBossProfileData.Set(iIndex, flInstantKillCooldownApollyon, BossProfileData_InstantKillCooldownApollyon);
	
	g_hBossProfileData.Set(iIndex, flBossScareRadius, BossProfileData_ScareRadius);
	g_hBossProfileData.Set(iIndex, flBossScareCooldown, BossProfileData_ScareCooldown);

	g_hBossProfileData.Set(iIndex, bSpeedBoostOnScare, BossProfileData_SpeedBoostOnScare);
	g_hBossProfileData.Set(iIndex, flScareSpeedBoostDuration, BossProfileData_ScareSpeedBoostDuration);

	g_hBossProfileData.Set(iIndex, bScareReaction, BossProfileData_ScareReaction);
	g_hBossProfileData.Set(iIndex, iScareReactionType, BossProfileData_ScareReactionType);

	g_hBossProfileData.Set(iIndex, bScareReplenishSprint, BossProfileData_ScareReplenishSprint);
	g_hBossProfileData.Set(iIndex, iScareReplenishSprintAmount, BossProfileData_ScareReplenishSprintAmount);
	
	g_hBossProfileData.Set(iIndex, iBossTeleportType, BossProfileData_TeleportType);
	
	g_hBossProfileData.Set(iIndex, bUseCustomOutlines, BossProfileData_EnableCustomizableOutlines);
	g_hBossProfileData.Set(iIndex, iOutlineColorR, BossProfileData_OutlineColorR);
	g_hBossProfileData.Set(iIndex, iOutlineColorG, BossProfileData_OutlineColorG);
	g_hBossProfileData.Set(iIndex, iOutlineColorB, BossProfileData_OutlineColorB);
	g_hBossProfileData.Set(iIndex, iOutlineColorTrans, BossProfileData_OutlineColorTrans);
	g_hBossProfileData.Set(iIndex, bRainbowOutline, BossProfileData_RainbowOutline);
	g_hBossProfileData.Set(iIndex, flRainbowCycleTime, BossProfileData_RainbowOutlineCycle);

	g_hBossProfileData.Set(iIndex, flStaticRadius, BossProfileData_StaticRadiusNormal);
	g_hBossProfileData.Set(iIndex, flStaticRadiusEasy, BossProfileData_StaticRadiusEasy);
	g_hBossProfileData.Set(iIndex, flStaticRadiusHard, BossProfileData_StaticRadiusHard);
	g_hBossProfileData.Set(iIndex, flStaticRadiusInsane, BossProfileData_StaticRadiusInsane);
	g_hBossProfileData.Set(iIndex, flStaticRadiusNightmare, BossProfileData_StaticRadiusNightmare);
	g_hBossProfileData.Set(iIndex, flStaticRadiusApollyon, BossProfileData_StaticRadiusApollyon);

	g_hBossProfileData.Set(iIndex, flStaticRate, BossProfileData_StaticRateNormal);
	g_hBossProfileData.Set(iIndex, flStaticRateEasy, BossProfileData_StaticRateEasy);
	g_hBossProfileData.Set(iIndex, flStaticRateHard, BossProfileData_StaticRateHard);
	g_hBossProfileData.Set(iIndex, flStaticRateInsane, BossProfileData_StaticRateInsane);
	g_hBossProfileData.Set(iIndex, flStaticRateNightmare, BossProfileData_StaticRateNightmare);
	g_hBossProfileData.Set(iIndex, flStaticRateApollyon, BossProfileData_StaticRateApollyon);

	g_hBossProfileData.Set(iIndex, flStaticRateDecay, BossProfileData_StaticRateDecayNormal);
	g_hBossProfileData.Set(iIndex, flStaticRateDecayEasy, BossProfileData_StaticRateDecayEasy);
	g_hBossProfileData.Set(iIndex, flStaticRateDecayHard, BossProfileData_StaticRateDecayHard);
	g_hBossProfileData.Set(iIndex, flStaticRateDecayInsane, BossProfileData_StaticRateDecayInsane);
	g_hBossProfileData.Set(iIndex, flStaticRateDecayNightmare, BossProfileData_StaticRateDecayNightmare);
	g_hBossProfileData.Set(iIndex, flStaticRateDecayApollyon, BossProfileData_StaticRateDecayApollyon);

	g_hBossProfileData.Set(iIndex, flStaticGraceTime, BossProfileData_StaticGraceTimeNormal);
	g_hBossProfileData.Set(iIndex, flStaticGraceTimeEasy, BossProfileData_StaticGraceTimeEasy);
	g_hBossProfileData.Set(iIndex, flStaticGraceTimeHard, BossProfileData_StaticGraceTimeHard);
	g_hBossProfileData.Set(iIndex, flStaticGraceTimeInsane, BossProfileData_StaticGraceTimeInsane);
	g_hBossProfileData.Set(iIndex, flStaticGraceTimeNightmare, BossProfileData_StaticGraceTimeNightmare);
	g_hBossProfileData.Set(iIndex, flStaticGraceTimeApollyon, BossProfileData_StaticGraceTimeApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMin, BossProfileData_TeleportTimeMinNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMinEasy, BossProfileData_TeleportTimeMinEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMinHard, BossProfileData_TeleportTimeMinHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMinInsane, BossProfileData_TeleportTimeMinInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMinNightmare, BossProfileData_TeleportTimeMinNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMinApollyon, BossProfileData_TeleportTimeMinApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMax, BossProfileData_TeleportTimeMaxNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMaxEasy, BossProfileData_TeleportTimeMaxEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMaxHard, BossProfileData_TeleportTimeMaxHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMaxInsane, BossProfileData_TeleportTimeMaxInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMaxNightmare, BossProfileData_TeleportTimeMaxNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportTimeMaxApollyon, BossProfileData_TeleportTimeMaxApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriod, BossProfileData_TeleportRestPeriodNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriodEasy, BossProfileData_TeleportRestPeriodEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriodHard, BossProfileData_TeleportRestPeriodHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriodInsane, BossProfileData_TeleportRestPeriodInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriodNightmare, BossProfileData_TeleportRestPeriodNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportRestPeriodApollyon, BossProfileData_TeleportRestPeriodApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportStressMin, BossProfileData_TeleportStressMinNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMinEasy, BossProfileData_TeleportStressMinEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMinHard, BossProfileData_TeleportStressMinHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMinInsane, BossProfileData_TeleportStressMinInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMinNightmare, BossProfileData_TeleportStressMinNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMinApollyon, BossProfileData_TeleportStressMinApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportStressMax, BossProfileData_TeleportStressMaxNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMaxEasy, BossProfileData_TeleportStressMaxEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMaxHard, BossProfileData_TeleportStressMaxHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMaxInsane, BossProfileData_TeleportStressMaxInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMaxNightmare, BossProfileData_TeleportStressMaxNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportStressMaxApollyon, BossProfileData_TeleportStressMaxApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriod, BossProfileData_TeleportPersistencyPeriodNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriodEasy, BossProfileData_TeleportPersistencyPeriodEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriodHard, BossProfileData_TeleportPersistencyPeriodHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriodInsane, BossProfileData_TeleportPersistencyPeriodInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriodNightmare, BossProfileData_TeleportPersistencyPeriodNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportPersistencyPeriodApollyon, BossProfileData_TeleportPersistencyPeriodApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMin, BossProfileData_TeleportRangeMinNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMinEasy, BossProfileData_TeleportRangeMinEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMinHard, BossProfileData_TeleportRangeMinHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMinInsane, BossProfileData_TeleportRangeMinInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMinNightmare, BossProfileData_TeleportRangeMinNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMinApollyon, BossProfileData_TeleportRangeMinApollyon);

	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMax, BossProfileData_TeleportRangeMaxNormal);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMaxEasy, BossProfileData_TeleportRangeMaxEasy);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMaxHard, BossProfileData_TeleportRangeMaxHard);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMaxInsane, BossProfileData_TeleportRangeMaxInsane);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMaxNightmare, BossProfileData_TeleportRangeMaxNightmare);
	g_hBossProfileData.Set(iIndex, flBossTeleportRangeMaxApollyon, BossProfileData_TeleportRangeMaxApollyon);

	g_hBossProfileData.Set(iIndex, flBossJumpscareDistance, BossProfileData_JumpscareDistanceNormal);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDistanceEasy, BossProfileData_JumpscareDistanceEasy);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDistanceHard, BossProfileData_JumpscareDistanceHard);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDistanceInsane, BossProfileData_JumpscareDistanceInsane);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDistanceNightmare, BossProfileData_JumpscareDistanceNightmare);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDistanceApollyon, BossProfileData_JumpscareDistanceApollyon);

	g_hBossProfileData.Set(iIndex, flBossJumpscareDuration, BossProfileData_JumpscareDurationNormal);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDurationEasy, BossProfileData_JumpscareDurationEasy);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDurationHard, BossProfileData_JumpscareDurationHard);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDurationInsane, BossProfileData_JumpscareDurationInsane);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDurationNightmare, BossProfileData_JumpscareDurationNightmare);
	g_hBossProfileData.Set(iIndex, flBossJumpscareDurationApollyon, BossProfileData_JumpscareDurationApollyon);

	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldown, BossProfileData_JumpscareCooldownNormal);
	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldownEasy, BossProfileData_JumpscareCooldownEasy);
	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldownHard, BossProfileData_JumpscareCooldownHard);
	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldownInsane, BossProfileData_JumpscareCooldownInsane);
	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldownNightmare, BossProfileData_JumpscareCooldownNightmare);
	g_hBossProfileData.Set(iIndex, flBossJumpscareCooldownApollyon, BossProfileData_JumpscareCooldownApollyon);

	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("jumpscare_on_scare")), BossProfileData_JumpscareOnScare);

	g_hBossProfileData.Set(iIndex, flBossSearchRadius, BossProfileData_SearchRange);
	g_hBossProfileData.Set(iIndex, flBossSearchRadiusEasy, BossProfileData_SearchRangeEasy);
	g_hBossProfileData.Set(iIndex, flBossSearchRadiusHard, BossProfileData_SearchRangeHard);
	g_hBossProfileData.Set(iIndex, flBossSearchRadiusInsane, BossProfileData_SearchRangeInsane);
	g_hBossProfileData.Set(iIndex, flBossSearchRadiusNightmare, BossProfileData_SearchRangeNightmare);
	g_hBossProfileData.Set(iIndex, flBossSearchRadiusApollyon, BossProfileData_SearchRangeApollyon);

	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadius, BossProfileData_SearchSoundRange);
	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadiusEasy, BossProfileData_SearchSoundRangeEasy);
	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadiusHard, BossProfileData_SearchSoundRangeHard);
	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadiusInsane, BossProfileData_SearchSoundRangeInsane);
	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadiusNightmare, BossProfileData_SearchSoundRangeNightmare);
	g_hBossProfileData.Set(iIndex, flBossSearchSoundRadiusApollyon, BossProfileData_SearchSoundRangeApollyon);

	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("healthbar")), BossProfileData_UseHealthbar);

	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemy, BossProfileData_ProxyDamageVsEnemyNormal);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemyEasy, BossProfileData_ProxyDamageVsEnemyEasy);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemyHard, BossProfileData_ProxyDamageVsEnemyHard);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemyInsane, BossProfileData_ProxyDamageVsEnemyInsane);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemyNightmare, BossProfileData_ProxyDamageVsEnemyNightmare);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsEnemyApollyon, BossProfileData_ProxyDamageVsEnemyApollyon);

	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstab, BossProfileData_ProxyDamageVsBackstabNormal);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstabEasy, BossProfileData_ProxyDamageVsBackstabEasy);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstabHard, BossProfileData_ProxyDamageVsBackstabHard);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstabInsane, BossProfileData_ProxyDamageVsBackstabInsane);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstabNightmare, BossProfileData_ProxyDamageVsBackstabNightmare);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsBackstabApollyon, BossProfileData_ProxyDamageVsBackstabApollyon);

	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelf, BossProfileData_ProxyDamageVsSelfNormal);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelfEasy, BossProfileData_ProxyDamageVsSelfEasy);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelfHard, BossProfileData_ProxyDamageVsSelfHard);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelfInsane, BossProfileData_ProxyDamageVsSelfInsane);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelfNightmare, BossProfileData_ProxyDamageVsSelfNightmare);
	g_hBossProfileData.Set(iIndex, flProxyDamageVsSelfApollyon, BossProfileData_ProxyDamageVsSelfApollyon);

	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemy, BossProfileData_ProxyControlGainHitEnemyNormal);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemyEasy, BossProfileData_ProxyControlGainHitEnemyEasy);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemyHard, BossProfileData_ProxyControlGainHitEnemyHard);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemyInsane, BossProfileData_ProxyControlGainHitEnemyInsane);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemyNightmare, BossProfileData_ProxyControlGainHitEnemyNightmare);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitEnemyApollyon, BossProfileData_ProxyControlGainHitEnemyApollyon);

	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemy, BossProfileData_ProxyControlGainHitByEnemyNormal);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemyEasy, BossProfileData_ProxyControlGainHitByEnemyEasy);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemyHard, BossProfileData_ProxyControlGainHitByEnemyHard);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemyInsane, BossProfileData_ProxyControlGainHitByEnemyInsane);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemyNightmare, BossProfileData_ProxyControlGainHitByEnemyNightmare);
	g_hBossProfileData.Set(iIndex, iProxyControlGainHitByEnemyApollyon, BossProfileData_ProxyControlGainHitByEnemyApollyon);
	
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRate, BossProfileData_ProxyControlDrainRateNormal);
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRateEasy, BossProfileData_ProxyControlDrainRateEasy);
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRateHard, BossProfileData_ProxyControlDrainRateHard);
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRateInsane, BossProfileData_ProxyControlDrainRateInsane);
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRateNightmare, BossProfileData_ProxyControlDrainRateNightmare);
	g_hBossProfileData.Set(iIndex, flProxyControlDrainRateApollyon, BossProfileData_ProxyControlDrainRateApollyon);

	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMin, BossProfileData_ProxySpawnChanceMinNormal);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMinEasy, BossProfileData_ProxySpawnChanceMinEasy);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMinHard, BossProfileData_ProxySpawnChanceMinHard);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMinInsane, BossProfileData_ProxySpawnChanceMinInsane);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMinNightmare, BossProfileData_ProxySpawnChanceMinNightmare);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMinApollyon, BossProfileData_ProxySpawnChanceMinApollyon);

	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMax, BossProfileData_ProxySpawnChanceMaxNormal);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMaxEasy, BossProfileData_ProxySpawnChanceMaxEasy);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMaxHard, BossProfileData_ProxySpawnChanceMaxHard);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMaxInsane, BossProfileData_ProxySpawnChanceMaxInsane);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMaxNightmare, BossProfileData_ProxySpawnChanceMaxNightmare);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceMaxApollyon, BossProfileData_ProxySpawnChanceMaxApollyon);

	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThreshold, BossProfileData_ProxySpawnChanceThresholdNormal);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThresholdEasy, BossProfileData_ProxySpawnChanceThresholdEasy);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThresholdHard, BossProfileData_ProxySpawnChanceThresholdHard);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThresholdInsane, BossProfileData_ProxySpawnChanceThresholdInsane);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThresholdNightmare, BossProfileData_ProxySpawnChanceThresholdNightmare);
	g_hBossProfileData.Set(iIndex, flProxySpawnChanceThresholdApollyon, BossProfileData_ProxySpawnChanceThresholdApollyon);

	g_hBossProfileData.Set(iIndex, iProxySpawnNumMin, BossProfileData_ProxySpawnNumMinNormal);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMinEasy, BossProfileData_ProxySpawnNumMinEasy);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMinHard, BossProfileData_ProxySpawnNumMinHard);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMinInsane, BossProfileData_ProxySpawnNumMinInsane);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMinNightmare, BossProfileData_ProxySpawnNumMinNightmare);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMinApollyon, BossProfileData_ProxySpawnNumMinApollyon);

	g_hBossProfileData.Set(iIndex, iProxySpawnNumMax, BossProfileData_ProxySpawnNumMaxNormal);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMaxEasy, BossProfileData_ProxySpawnNumMaxEasy);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMaxHard, BossProfileData_ProxySpawnNumMaxHard);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMaxInsane, BossProfileData_ProxySpawnNumMaxInsane);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMaxNightmare, BossProfileData_ProxySpawnNumMaxNightmare);
	g_hBossProfileData.Set(iIndex, iProxySpawnNumMaxApollyon, BossProfileData_ProxySpawnNumMaxApollyon);

	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMin, BossProfileData_ProxySpawnCooldownMinNormal);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMinEasy, BossProfileData_ProxySpawnCooldownMinEasy);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMinHard, BossProfileData_ProxySpawnCooldownMinHard);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMinInsane, BossProfileData_ProxySpawnCooldownMinInsane);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMinNightmare, BossProfileData_ProxySpawnCooldownMinNightmare);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMinApollyon, BossProfileData_ProxySpawnCooldownMinApollyon);

	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMax, BossProfileData_ProxySpawnCooldownMaxNormal);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMaxEasy, BossProfileData_ProxySpawnCooldownMaxEasy);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMaxHard, BossProfileData_ProxySpawnCooldownMaxHard);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMaxInsane, BossProfileData_ProxySpawnCooldownMaxInsane);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMaxNightmare, BossProfileData_ProxySpawnCooldownMaxNightmare);
	g_hBossProfileData.Set(iIndex, flProxySpawnCooldownMaxApollyon, BossProfileData_ProxySpawnCooldownMaxApollyon);

	g_hBossProfileData.Set(iIndex, iProxyMax, BossProfileData_ProxyMaxNormal);
	g_hBossProfileData.Set(iIndex, iProxyMaxEasy, BossProfileData_ProxyMaxEasy);
	g_hBossProfileData.Set(iIndex, iProxyMaxHard, BossProfileData_ProxyMaxHard);
	g_hBossProfileData.Set(iIndex, iProxyMaxInsane, BossProfileData_ProxyMaxInsane);
	g_hBossProfileData.Set(iIndex, iProxyMaxNightmare, BossProfileData_ProxyMaxNightmare);
	g_hBossProfileData.Set(iIndex, iProxyMaxApollyon, BossProfileData_ProxyMaxApollyon);

	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMin, BossProfileData_ProxyTeleportRangeMinNormal);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMinEasy, BossProfileData_ProxyTeleportRangeMinEasy);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMinHard, BossProfileData_ProxyTeleportRangeMinHard);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMinInsane, BossProfileData_ProxyTeleportRangeMinInsane);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMinNightmare, BossProfileData_ProxyTeleportRangeMinNightmare);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMinApollyon, BossProfileData_ProxyTeleportRangeMinApollyon);

	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMax, BossProfileData_ProxyTeleportRangeMaxNormal);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMaxEasy, BossProfileData_ProxyTeleportRangeMaxEasy);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMaxHard, BossProfileData_ProxyTeleportRangeMaxHard);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMaxInsane, BossProfileData_ProxyTeleportRangeMaxInsane);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMaxNightmare, BossProfileData_ProxyTeleportRangeMaxNightmare);
	g_hBossProfileData.Set(iIndex, flProxyTeleportRangeMaxApollyon, BossProfileData_ProxyTeleportRangeMaxApollyon);
	
	g_hBossProfileData.Set(iIndex, iProxyHurtChannel, BossProfileData_ProxyHurtChannel);
	g_hBossProfileData.Set(iIndex, iProxyHurtLevel, BossProfileData_ProxyHurtLevel);
	g_hBossProfileData.Set(iIndex, iProxyHurtFlags, BossProfileData_ProxyHurtFlags);
	g_hBossProfileData.Set(iIndex, flProxyHurtVolume, BossProfileData_ProxyHurtVolume);
	g_hBossProfileData.Set(iIndex, iProxyHurtPitch, BossProfileData_ProxyHurtPitch);

	g_hBossProfileData.Set(iIndex, iProxyDeathChannel, BossProfileData_ProxyDeathChannel);
	g_hBossProfileData.Set(iIndex, iProxyDeathLevel, BossProfileData_ProxyDeathLevel);
	g_hBossProfileData.Set(iIndex, iProxyDeathFlags, BossProfileData_ProxyDeathFlags);
	g_hBossProfileData.Set(iIndex, flProxyDeathVolume, BossProfileData_ProxyDeathVolume);
	g_hBossProfileData.Set(iIndex, iProxyDeathPitch, BossProfileData_ProxyDeathPitch);

	g_hBossProfileData.Set(iIndex, iProxyIdleChannel, BossProfileData_ProxyIdleChannel);
	g_hBossProfileData.Set(iIndex, iProxyIdleLevel, BossProfileData_ProxyIdleLevel);
	g_hBossProfileData.Set(iIndex, iProxyIdleFlags, BossProfileData_ProxyIdleFlags);
	g_hBossProfileData.Set(iIndex, flProxyIdleVolume, BossProfileData_ProxyIdleVolume);
	g_hBossProfileData.Set(iIndex, iProxyIdlePitch, BossProfileData_ProxyIdlePitch);
	g_hBossProfileData.Set(iIndex, flProxyIdleCooldownMin, BossProfileData_ProxyIdleCooldownMin);
	g_hBossProfileData.Set(iIndex, flProxyIdleCooldownMax, BossProfileData_ProxyIdleCooldownMax);

	g_hBossProfileData.Set(iIndex, iProxySpawnChannel, BossProfileData_ProxySpawnChannel);
	g_hBossProfileData.Set(iIndex, iProxySpawnLevel, BossProfileData_ProxySpawnLevel);
	g_hBossProfileData.Set(iIndex, iProxySpawnFlags, BossProfileData_ProxySpawnFlags);
	g_hBossProfileData.Set(iIndex, flProxySpawnVolume, BossProfileData_ProxySpawnVolume);
	g_hBossProfileData.Set(iIndex, iProxySpawnPitch, BossProfileData_ProxySpawnPitch);

	g_hBossProfileData.Set(iIndex, bFakeCopies, BossProfileData_FakeCopyEnabled);

	g_hBossProfileData.Set(iIndex, bDrainCreditsOnKill, BossProfileData_DrainCreditEnabled);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmountEasy, BossProfileData_DrainCreditAmountEasy);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmount, BossProfileData_DrainCreditAmountNormal);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmountHard, BossProfileData_DrainCreditAmountHard);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmountInsane, BossProfileData_DrainCreditAmountInsane);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmountNightmare, BossProfileData_DrainCreditAmountNightmare);
	g_hBossProfileData.Set(iIndex, iCreditDrainAmountApollyon, BossProfileData_DrainCreditAmountApollyon);

	g_hBossProfileData.Set(iIndex, bProxySpawnEffects, BossProfileData_ProxySpawnEffectEnabled);
	g_hBossProfileData.Set(iIndex, flProxySpawnEffectLifetime, BossProfileData_ProxySpawnEffectLifetime);
	g_hBossProfileData.Set(iIndex, flProxySpawnEffectZOffset, BossProfileData_ProxySpawnEffectZPosOffset);

	g_hBossProfileData.Set(iIndex, bProxyWeaponsEnabled, BossProfileData_ProxyWeapons);

	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("proxies_allownormalvoices", 1)), BossProfileData_ProxyAllowNormalVoices);

	g_hBossProfileData.Set(iIndex, kv.GetNum("chat_message_upon_death_difficulty_indexes", 123456), BossProfileData_DeathMessageDifficultyIndexes);

	g_hBossProfileData.Set(iIndex, flBossFOV, BossProfileData_FieldOfView);
	g_hBossProfileData.Set(iIndex, flBossMaxTurnRate, BossProfileData_TurnRate);

	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("burn_ragdoll_on_kill")), BossProfileData_BurnRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("cloak_ragdoll_on_kill")), BossProfileData_CloakRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("decap_ragdoll_on_kill")), BossProfileData_DecapRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("gib_ragdoll_on_kill")), BossProfileData_GibRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("gold_ragdoll_on_kill")), BossProfileData_GoldRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("ice_ragdoll_on_kill")), BossProfileData_IceRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("electrocute_ragdoll_on_kill")), BossProfileData_ElectrocuteRagdoll);
	g_hBossProfileData.Set(iIndex, bAshRagdoll, BossProfileData_AshRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("delete_ragdoll_on_kill")), BossProfileData_DeleteRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("push_ragdoll_on_kill")), BossProfileData_PushRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("dissolve_ragdoll_on_kill")), BossProfileData_DissolveRagdoll);
	g_hBossProfileData.Set(iIndex, kv.GetNum("dissolve_ragdoll_type"), BossProfileData_DissolveKillType);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("plasma_ragdoll_on_kill")), BossProfileData_PlasmaRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("resize_ragdoll_on_kill")), BossProfileData_ResizeRagdoll);
	g_hBossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_head", 1.0), BossProfileData_ResizeRagdollHead);
	g_hBossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_hands", 1.0), BossProfileData_ResizeRagdollHands);
	g_hBossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_torso", 1.0), BossProfileData_ResizeRagdollTorso);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("decap_or_gib_ragdoll_on_kill")), BossProfileData_DecapOrGipRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("silent_kill")), BossProfileData_SilentKill);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("multieffect_ragdoll_on_kill")), BossProfileData_MultieffectRagdoll);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("attack_custom_deathflag_enabled")), BossProfileData_CustomDeathFlag);
	g_hBossProfileData.Set(iIndex, kv.GetNum("attack_custom_deathflag"), BossProfileData_CustomDeathFlagType);
	g_hBossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("sound_music_outro_enabled")), BossProfileData_OutroMusicEnabled);
	
	char sCOn[PLATFORM_MAX_PATH], sCOff[PLATFORM_MAX_PATH], sJ[PLATFORM_MAX_PATH], sM[PLATFORM_MAX_PATH], sG[PLATFORM_MAX_PATH], sS[PLATFORM_MAX_PATH], sFE[PLATFORM_MAX_PATH], sFS[PLATFORM_MAX_PATH], sFIS[PLATFORM_MAX_PATH], sRE[PLATFORM_MAX_PATH], sRS[PLATFORM_MAX_PATH], sEngineSound[PLATFORM_MAX_PATH], sGrenadeShoot[PLATFORM_MAX_PATH], sSentryrocketShoot[PLATFORM_MAX_PATH], sArrowShoot[PLATFORM_MAX_PATH], sManglerShoot[PLATFORM_MAX_PATH], sBaseballShoot[PLATFORM_MAX_PATH], sSpawnParticleSound[PLATFORM_MAX_PATH], sDespawnParticleSound[PLATFORM_MAX_PATH];
	char sOutroSound[PLATFORM_MAX_PATH];
	kv.GetString("cloak_on_sound", sCOn, sizeof(sCOn), DEFAULT_CLOAKONSOUND);
	kv.GetString("cloak_off_sound", sCOff, sizeof(sCOff), DEFAULT_CLOAKOFFSOUND);
	kv.GetString("player_jarate_sound", sJ, sizeof(sJ), JARATE_HITPLAYER);
	kv.GetString("player_milk_sound", sM, sizeof(sM), JARATE_HITPLAYER);
	kv.GetString("player_gas_sound", sG, sizeof(sG), JARATE_HITPLAYER);
	kv.GetString("player_stun_sound", sS, sizeof(sS), STUN_HITPLAYER);
	kv.GetString("fire_explode_sound", sFE, sizeof(sFE), FIREBALL_IMPACT);
	kv.GetString("fire_shoot_sound", sFS, sizeof(sFS), FIREBALL_SHOOT);
	kv.GetString("fire_iceball_slow_sound", sFIS, sizeof(sFIS), ICEBALL_IMPACT);
	kv.GetString("rocket_explode_sound", sRE, sizeof(sRE), ROCKET_IMPACT);
	kv.GetString("rocket_shoot_sound", sRS, sizeof(sRS), ROCKET_SHOOT);
	kv.GetString("grenade_shoot_sound", sGrenadeShoot, sizeof(sGrenadeShoot), GRENADE_SHOOT);
	kv.GetString("sentryrocket_shoot_sound", sSentryrocketShoot, sizeof(sSentryrocketShoot), SENTRYROCKET_SHOOT);
	kv.GetString("arrow_shoot_sound", sArrowShoot, sizeof(sArrowShoot), ARROW_SHOOT);
	kv.GetString("mangler_shoot_sound", sManglerShoot, sizeof(sManglerShoot), MANGLER_SHOOT);
	kv.GetString("baseball_shoot_sound", sBaseballShoot, sizeof(sBaseballShoot), BASEBALL_SHOOT);
	kv.GetString("engine_sound", sEngineSound, sizeof(sEngineSound));
	kv.GetString("tp_effect_spawn_sound", sSpawnParticleSound, sizeof(sSpawnParticleSound));
	kv.GetString("tp_effect_despawn_sound", sDespawnParticleSound, sizeof(sDespawnParticleSound));
	kv.GetString("sound_music_outro", sOutroSound, sizeof(sOutroSound));

	TryPrecacheBossProfileSoundPath(sCOn);
	TryPrecacheBossProfileSoundPath(sCOff);
	TryPrecacheBossProfileSoundPath(sJ);
	TryPrecacheBossProfileSoundPath(sM);
	TryPrecacheBossProfileSoundPath(sG);
	TryPrecacheBossProfileSoundPath(sS);
	TryPrecacheBossProfileSoundPath(sFE);
	TryPrecacheBossProfileSoundPath(sFS);
	TryPrecacheBossProfileSoundPath(sFIS);
	TryPrecacheBossProfileSoundPath(sRE);
	TryPrecacheBossProfileSoundPath(sRS);
	TryPrecacheBossProfileSoundPath(sGrenadeShoot);
	TryPrecacheBossProfileSoundPath(sSentryrocketShoot);
	TryPrecacheBossProfileSoundPath(sArrowShoot);
	TryPrecacheBossProfileSoundPath(sManglerShoot);
	TryPrecacheBossProfileSoundPath(sBaseballShoot);
	TryPrecacheBossProfileSoundPath(sEngineSound);
	TryPrecacheBossProfileSoundPath(sSpawnParticleSound);
	TryPrecacheBossProfileSoundPath(sDespawnParticleSound);
	TryPrecacheBossProfileSoundPath(sOutroSound);
	
	if (view_as<bool>(kv.GetNum("enable_random_selection", 1)))
	{
		if (GetSelectableBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableBossProfileList().Erase(selectIndex);
		}	
	}
	
	if (view_as<bool>(kv.GetNum("admin_only", 0)))
	{
		if (GetSelectableAdminBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableAdminBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableAdminBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableAdminBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection_boxing", 0)))
	{
		if (GetSelectableBoxingBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBoxingBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBoxingBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableBoxingBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection_renevant", 0)))
	{
		if (GetSelectableRenevantBossProfileList().FindString(sProfile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossProfileList().PushString(sProfile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossProfileList().FindString(sProfile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossProfileList().Erase(selectIndex);
		}
	}
	
	if (KvGotoFirstSubKey(kv)) //Special thanks to Fire for modifying the code for download errors.
	{
		char s2[64], s3[64], s4[PLATFORM_MAX_PATH], s5[PLATFORM_MAX_PATH];
		
		do
		{
			kv.GetSectionName(s2, sizeof(s2));
			
			if (!StrContains(s2, "sound_"))
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0') break;

					TryPrecacheBossProfileSoundPath(s4);
				}
			}
			else if (strcmp(s2, "download") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0') break;
					
					if(FileExists(s4) || FileExists(s4, true))
					{
						AddFileToDownloadsTable(s4);
					}
					else
					{
						LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s4);
					}
				}
			}
			else if (strcmp(s2, "mod_precache") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0') break;
					
					if(!PrecacheModel(s4, true))
					{
						LogSF2Message("Model file %s failed to be precached, likely does not exist.", s4);
					}
				}
			}
			else if (strcmp(s2, "mat_download") == 0)
			{	
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0') break;
					
					FormatEx(s5, sizeof(s5), "%s.vtf", s4);
					if(FileExists(s5) || FileExists(s5, true))
					{
						AddFileToDownloadsTable(s5);
					}
					else
					{
						LogSF2Message("Texture file %s does not exist, please fix this download or remove it from the array.", s5);
					}

					FormatEx(s5, sizeof(s5), "%s.vmt", s4);
					if(FileExists(s5) || FileExists(s5, true))
					{
						AddFileToDownloadsTable(s5);
					}
					else
					{
						LogSF2Message("Material file %s does not exist, please fix this download or remove it from the array.", s5);
					}
				}
			}
			else if (strcmp(s2, "mod_download") == 0)
			{
				static const char extensions[][] = { ".mdl", ".phy", ".dx80.vtx", ".dx90.vtx", ".sw.vtx", ".vvd" };
				
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0') break;
					
					for (int is = 0; is < sizeof(extensions); is++)
					{
						FormatEx(s5, sizeof(s5), "%s%s", s4, extensions[is]);
						if(FileExists(s5) || FileExists(s5, true))
						{
							AddFileToDownloadsTable(s5);
						}
						else
						{
							LogSF2Message("Model file %s does not exist, please fix this download or remove it from the array.", s5);
						}
					}
				}
			}
		}
		while (kv.GotoNextKey());
		
		kv.GoBack();
	}
	
	return true;
}

int GetBossProfileIndexFromName(const char[] sProfile)
{
	int iReturn = -1;
	g_hBossProfileNames.GetValue(sProfile, iReturn);
	return iReturn;
}

int GetBossProfileUniqueProfileIndex(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_UniqueProfileIndex);
}

int GetBossProfileSkin(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Skin);
}

int GetBossProfileSkinDifficulty(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Skin);
}

int GetBossProfileSkinMax(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SkinMax);
}

int GetBossProfileBodyGroups(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Body);
}

int GetBossProfileBodyGroupsDifficulty(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Body);
}

int GetBossProfileBodyGroupsMax(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_BodyMax);
}

int GetBossProfileRaidHitbox(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_UseRaidHitbox);
}

bool GetBossProfileIgnoreNavPrefer(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_IgnoreNavPrefer));
}

float GetBossProfileSoundMusicLoop(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SoundMusicLoopNormal));
}

int GetBossProfileMaxCopies(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_CopyNormal);
}

float GetBossProfileModelScale(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ModelScale));
}

int GetBossProfileHealth(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Health);
}

int GetBossProfileType(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Type);
}

int GetBossProfileFlags(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_Flags);
}

float GetBossProfileBlinkLookRate(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_BlinkLookRateMultipler));
}

float GetBossProfileBlinkStaticRate(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_BlinkStaticRateMultiplier));
}

bool GetBossProfileDeathCamState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_HasDeathCam));
}

bool GetBossProfileDeathCamScareSound(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_DeathCamPlayScareSound));
}

bool GetBossProfilePublicDeathCamState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCam));
}

float GetBossProfilePublicDeathCamSpeed(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCamSpeed);
}

float GetBossProfilePublicDeathCamAcceleration(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCamAcceleration);
}

float GetBossProfilePublicDeathCamDeceleration(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCamDeceleration);
}

float GetBossProfilePublicDeathCamBackwardOffset(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCamBackwardOffset);
}

float GetBossProfilePublicDeathCamDownwardOffset(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_PublicDeathCamDownwardOffset);
}

bool GetBossProfileDeathCamOverlayState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_DeathCamOverlay));
}

float GetBossProfileDeathCamOverlayStartTime(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DeathCamOverlayStartTime);
}

float GetBossProfileDeathCamTime(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DeathCamTime);
}

float GetBossProfileSpeed(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedNormal);
}

float GetBossProfileMaxSpeed(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_MaxSpeedNormal);
}

float GetBossProfileAcceleration(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_AccelerationNormal);
}

float GetBossProfileIdleLifetime(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_IdleLifetimeNormal);
}

float GetBossProfileStaticRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRadiusNormal));
}

float GetBossProfileStaticRate(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateNormal));
}

float GetBossProfileStaticRateDecay(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticRateDecayNormal));
}

float GetBossProfileStaticGraceTime(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_StaticGraceTimeNormal));
}

float GetBossProfileSearchRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRangeEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRangeHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRangeInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRangeNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRangeApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchRange));
}

float GetBossProfileHearRadius(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRangeEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRangeHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRangeInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRangeNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRangeApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SearchSoundRange));
}

float GetBossProfileTeleportTimeMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMinNormal));
}

float GetBossProfileTeleportTimeMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportTimeMaxNormal));
}

float GetBossProfileTeleportTargetRestPeriod(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRestPeriodNormal));
}

float GetBossProfileTeleportTargetStressMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMinNormal));
}

float GetBossProfileTeleportTargetStressMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportStressMaxNormal));
}

float GetBossProfileTeleportTargetPersistencyPeriod(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportPersistencyPeriodNormal));
}

float GetBossProfileTeleportRangeMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMinNormal));
}

float GetBossProfileTeleportRangeMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportRangeMaxNormal));
}

float GetBossProfileJumpscareDistance(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDistanceNormal));
}

float GetBossProfileJumpscareDuration(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareDurationNormal));
}

float GetBossProfileJumpscareCooldown(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareCooldownNormal));
}

float GetBossProfileProxyDamageVsEnemy(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsEnemyNormal));
}

float GetBossProfileProxyDamageVsBackstab(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsBackstabNormal));
}

float GetBossProfileProxyDamageVsSelf(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDamageVsSelfNormal));
}

int GetBossProfileProxyControlGainHitEnemy(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitEnemyNormal);
}

int GetBossProfileProxyControlGainHitByEnemy(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyEasy);
		case Difficulty_Hard: g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyHard);
		case Difficulty_Insane: g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyInsane);
		case Difficulty_Nightmare: g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyNightmare);
		case Difficulty_Apollyon: g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlGainHitByEnemyNormal);
}

float GetBossProfileProxyControlDrainRate(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyControlDrainRateNormal));
}

float GetBossProfileProxySpawnChanceMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMinNormal));
}

float GetBossProfileProxySpawnChanceMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceMaxNormal));
}

float GetBossProfileProxySpawnChanceThreshold(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChanceThresholdNormal));
}

int GetBossProfileProxySpawnNumberMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMinNormal);
}

int GetBossProfileProxySpawnNumberMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnNumMaxNormal);
}

float GetBossProfileProxySpawnCooldownMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMinNormal));
}

float GetBossProfileProxySpawnCooldownMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnCooldownMaxNormal));
}

float GetBossProfileProxyTeleportRangeMin(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMinNormal));
}

float GetBossProfileProxyTeleportRangeMax(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyTeleportRangeMaxNormal));
}

int GetBossProfileSoundProxyHurtChannel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyHurtChannel);
}

int GetBossProfileSoundProxyHurtLevel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyHurtLevel);
}

int GetBossProfileSoundProxyHurtFlags(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyHurtFlags);
}

float GetBossProfileSoundProxyHurtVolume(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyHurtVolume));
}

int GetBossProfileSoundProxyHurtPitch(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyHurtPitch);
}

int GetBossProfileSoundProxyDeathChannel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDeathChannel);
}

int GetBossProfileSoundProxyDeathLevel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDeathLevel);
}

int GetBossProfileSoundProxyDeathFlags(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDeathFlags);
}

float GetBossProfileSoundProxyDeathVolume(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDeathVolume));
}

int GetBossProfileSoundProxyDeathPitch(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyDeathPitch);
}

int GetBossProfileSoundProxyIdleChannel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleChannel);
}

int GetBossProfileSoundProxyIdleLevel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleLevel);
}

int GetBossProfileSoundProxyIdleFlags(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleFlags);
}

float GetBossProfileSoundProxyIdleVolume(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleVolume));
}

int GetBossProfileSoundProxyIdlePitch(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdlePitch);
}

float GetBossProfileSoundProxyIdleCooldownMin(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleCooldownMin);
}

float GetBossProfileSoundProxyIdleCooldownMax(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyIdleCooldownMax);
}

int GetBossProfileSoundProxySpawnChannel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnChannel);
}

int GetBossProfileSoundProxySpawnLevel(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnLevel);
}

int GetBossProfileSoundProxySpawnFlags(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnFlags);
}

float GetBossProfileSoundProxySpawnVolume(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnVolume));
}

int GetBossProfileSoundProxySpawnPitch(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnPitch);
}

int GetBossProfileMaxProxies(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyMaxNormal);
}

bool GetBossProfileFakeCopies(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_FakeCopyEnabled));
}

bool GetBossProfileDrainCreditState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditEnabled));
}

int GetBossProfileDrainCreditAmount(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountEasy);
		case Difficulty_Hard: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountHard);
		case Difficulty_Insane: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountInsane);
		case Difficulty_Nightmare: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountNightmare);
		case Difficulty_Apollyon: return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountApollyon);
	}
	
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_DrainCreditAmountNormal);
}

bool GetBossProfileProxySpawnEffectState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnEffectEnabled));
}

float GetBossProfileProxySpawnEffectLifetime(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnEffectLifetime));
}

float GetBossProfileProxySpawnEffectZOffset(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxySpawnEffectZPosOffset));
}

float GetBossProfileFOV(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_FieldOfView));
}

float GetBossProfileTurnRate(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_TurnRate));
}

void GetBossProfileEyePositionOffset(int iProfileIndex, float buffer[3])
{
	buffer[0] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyePosOffsetX));
	buffer[1] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyePosOffsetY));
	buffer[2] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyePosOffsetZ));
}

void GetBossProfileEyeAngleOffset(int iProfileIndex, float buffer[3])
{
	buffer[0] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyeAngOffsetX));
	buffer[1] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyeAngOffsetY));
	buffer[2] = view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EyeAngOffsetZ));
}

float GetBossProfileAngerStart(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_AngerStart));
}

float GetBossProfileAngerAddOnPageGrab(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_AngerAddOnPageGrab));
}

float GetBossProfileAngerPageGrabTimeDiff(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_AngerPageGrabTimeDiffReq));
}

float GetBossProfileInstantKillRadius(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillRadius));
}

float GetBossProfileInstantKillCooldown(int iProfileIndex, int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownEasy));
		case Difficulty_Hard: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownHard));
		case Difficulty_Insane: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownInsane));
		case Difficulty_Nightmare: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownNightmare));
		case Difficulty_Apollyon: return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownApollyon));
	}
	
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_InstantKillCooldownNormal));
}

float GetBossProfileScareRadius(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareRadius));
}

float GetBossProfileScareCooldown(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareCooldown));
}

bool GetBossProfileSpeedBoostOnScare(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_SpeedBoostOnScare));
}

bool GetBossProfileJumpscareOnScare(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_JumpscareOnScare));
}

float GetBossProfileScareSpeedBoostDuration(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareSpeedBoostDuration));
}

bool GetBossProfileScareReactionState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareReaction));
}

int GetBossProfileScareReactionType(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareReactionType);
}

bool GetBossProfileScareReplenishState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareReplenishSprint));
}

int GetBossProfileScareReplenishAmount(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_ScareReplenishSprintAmount);
}

int GetBossProfileTeleportType(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_TeleportType);
}

bool GetBossProfileCustomOutlinesState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_EnableCustomizableOutlines));
}

int GetBossProfileOutlineColorR(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_OutlineColorR);
}

int GetBossProfileOutlineColorG(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_OutlineColorG);
}

int GetBossProfileOutlineColorB(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_OutlineColorB);
}

int GetBossProfileOutlineTransparency(int iProfileIndex)
{
	return g_hBossProfileData.Get(iProfileIndex, BossProfileData_OutlineColorTrans);
}

bool GetBossProfileRainbowOutlineState(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_RainbowOutline));
}

float GetBossProfileRainbowCycleRate(int iProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_RainbowOutlineCycle));
}

bool GetBossProfileProxyWeapons(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyWeapons));
}

bool GetBossProfileProxyAllowNormalVoices(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_ProxyAllowNormalVoices));
}

int GetBossProfileChatDeathMessageDifficultyIndexes(int iProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iProfileIndex, BossProfileData_DeathMessageDifficultyIndexes));
}

bool GetBossProfileHealthbarState(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_UseHealthbar));
}

bool GetBossProfileBurnRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_BurnRagdoll));
}

bool GetBossProfileCloakRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_CloakRagdoll));
}

bool GetBossProfileDecapRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_DecapRagdoll));
}

bool GetBossProfileGibRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_GibRagdoll));
}

bool GetBossProfileGoldRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_GoldRagdoll));
}

bool GetBossProfileIceRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_IceRagdoll));
}

bool GetBossProfileElectrocuteRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_ElectrocuteRagdoll));
}

bool GetBossProfileAshRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_AshRagdoll));
}

bool GetBossProfileDeleteRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_DeleteRagdoll));
}

bool GetBossProfilePushRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_PushRagdoll));
}

bool GetBossProfileDissolveRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_DissolveRagdoll));
}

int GetBossProfileDissolveRagdollType(int iChaserProfileIndex)
{
	return g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_DissolveKillType);
}

bool GetBossProfilePlasmaRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_PlasmaRagdoll));
}

bool GetBossProfileResizeRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_ResizeRagdoll));
}

float GetBossProfileResizeRagdollHead(int iChaserProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_ResizeRagdollHead));
}

float GetBossProfileResizeRagdollHands(int iChaserProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_ResizeRagdollHands));
}

float GetBossProfileResizeRagdollTorso(int iChaserProfileIndex)
{
	return view_as<float>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_ResizeRagdollTorso));
}

bool GetBossProfileDecapOrGibRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_DecapOrGipRagdoll));
}

bool GetBossProfileSilentKill(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_SilentKill));
}

bool GetBossProfileMultieffectRagdoll(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_MultieffectRagdoll));
}

bool GetBossProfileCustomDeathFlag(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_CustomDeathFlag));
}

int GetBossProfileCustomDeathFlagType(int iChaserProfileIndex)
{
	return g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_CustomDeathFlagType);
}

bool GetBossProfileOutroMusicState(int iChaserProfileIndex)
{
	return view_as<bool>(g_hBossProfileData.Get(iChaserProfileIndex, BossProfileData_OutroMusicEnabled));
}
