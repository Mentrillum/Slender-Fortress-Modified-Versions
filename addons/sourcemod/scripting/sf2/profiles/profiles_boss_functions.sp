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
	
	property int uniqueProfileIndex
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
	BossProfileData_StepSize,

	BossProfileData_DiscoMode,
	BossProfileData_DiscoDistanceMin,
	BossProfileData_DiscoDistanceMax,

	BossProfileData_FestiveLights,
	BossProfileData_FestiveLightBrightness,
	BossProfileData_FestiveLightDistance,
	BossProfileData_FestiveLightRadius,

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

	BossProfileData_TauntAlertRange,
	BossProfileData_TauntAlertRangeEasy,
	BossProfileData_TauntAlertRangeHard,
	BossProfileData_TauntAlertRangeInsane,
	BossProfileData_TauntAlertRangeNightmare,
	BossProfileData_TauntAlertRangeApollyon,	
	
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

	BossProfileData_TeleportAllowedEasy,
	BossProfileData_TeleportAllowedNormal,
	BossProfileData_TeleportAllowedHard,
	BossProfileData_TeleportAllowedInsane,
	BossProfileData_TeleportAllowedNightmare,
	BossProfileData_TeleportAllowedApollyon,

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

	BossProfileData_TeleportIgnoreChases,
	
	BossProfileData_TeleportIgnoreVis,

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
public bool LoadBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int iLoadFailReasonBufferLen)
{
	int bossType = kv.GetNum("type", SF2BossType_Unknown);
	if (bossType == SF2BossType_Unknown || bossType >= SF2BossType_MaxTypes) 
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "boss type is unknown!");
		return false;
	}
	
	float bossModelScale = kv.GetFloat("model_scale", 1.0);
	if (bossModelScale <= 0.0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "model_scale must be a value greater than 0!");
		return false;
	}
	
	int bossHealth = kv.GetNum("health", 30000);
	if (bossHealth < 1)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "health must be a value that is at least 1!");
		return false;
	}
	
	int bossSkin = kv.GetNum("skin", 0);
	if (bossSkin < 0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "skin must be a value that is at least 0!");
		return false;
	}
	int bossSkinEasy = kv.GetNum("skin_easy", bossSkin);
	int bossSkinHard = kv.GetNum("skin_hard", bossSkin);
	int bossSkinInsane = kv.GetNum("skin_insane", bossSkinHard);
	int bossSkinNightmare = kv.GetNum("skin_nightmare", bossSkinInsane);
	int bossSkinApollyon = kv.GetNum("skin_apollyon", bossSkinNightmare);
	
	int bossSkinMax = kv.GetNum("skin_max", 0);
	if (bossSkinMax < 0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "skin_max must be a value that is at least 0!");
		return false;
	}
	
	int bossBodyGroups = kv.GetNum("body");
	if (bossBodyGroups < 0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "body must be a value that is at least 0!");
		return false;
	}

	int bossBodyGroupsEasy = kv.GetNum("body_easy", bossBodyGroups);
	int bossBodyGroupsHard = kv.GetNum("body_hard", bossBodyGroups);
	int bossBodyGroupsInsane = kv.GetNum("body_insane", bossBodyGroupsHard);
	int bossBodyGroupsNightmare = kv.GetNum("body_nightmare", bossBodyGroupsInsane);
	int bossBodyGroupsApollyon = kv.GetNum("body_apollyon", bossBodyGroupsNightmare);

	int bossBodyGroupsMax = kv.GetNum("body_max", 0);
	if (bossBodyGroupsMax < 0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "body_max must be a value that is at least 0!");
		return false;
	}
	
	int useRaidHitbox = kv.GetNum("use_raid_hitbox");
	if (useRaidHitbox < 0)
	{
		useRaidHitbox = 0;
	}
	else if (useRaidHitbox > 1)
	{
		useRaidHitbox = 1;
	}

	float bossAngerStart = kv.GetFloat("anger_start", 1.0);
	if (bossAngerStart < 0.0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "anger_start must be a value that is at least 0!");
		return false;
	}
	
	float bossInstantKillRadius = kv.GetFloat("kill_radius");
	if (bossInstantKillRadius < 0.0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "kill_radius must be a value that is at least 0!");
		return false;
	}
	
	float bossScareRadius = kv.GetFloat("scare_radius");
	if (bossScareRadius < 0.0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "scare_radius must be a value that is at least 0!");
		return false;
	}

	int bossTeleportType = kv.GetNum("teleport_type");
	if (bossTeleportType < 0)
	{
		FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown teleport type!");
		return false;
	}
	
	FormatEx(loadFailReasonBuffer, iLoadFailReasonBufferLen, "unknown!");
	
	float bossFOV = kv.GetFloat("fov", 90.0);
	if (bossFOV < 0.0)
	{
		bossFOV = 0.0;
	}
	else if (bossFOV > 360.0)
	{
		bossFOV = 360.0;
	}
	
	float bossMaxTurnRate = kv.GetFloat("maxyawrate", 250.0);

	float bossScareCooldown = kv.GetFloat("scare_cooldown");
	if (bossScareCooldown < 0.0)
	{
		// clamp value 
		bossScareCooldown = 0.0;
	}
	
	float bossAngerAddOnPageGrab = kv.GetFloat("anger_add_on_page_grab", -1.0);
	if (bossAngerAddOnPageGrab < 0.0)
	{
		bossAngerAddOnPageGrab = kv.GetFloat("anger_page_add", -1.0);		// backwards compatibility
		if (bossAngerAddOnPageGrab < 0.0)
		{
			bossAngerAddOnPageGrab = 0.0;
		}
	}
	
	float bossAngerPageGrabTimeDiffReq = kv.GetFloat("anger_req_page_grab_time_diff", -1.0);
	if (bossAngerPageGrabTimeDiffReq < 0.0)
	{
		bossAngerPageGrabTimeDiffReq = kv.GetFloat("anger_page_time_diff", -1.0);		// backwards compatibility
		if (bossAngerPageGrabTimeDiffReq < 0.0)
		{
			bossAngerPageGrabTimeDiffReq = 0.0;
		}
	}

	float bossStepSize = kv.GetFloat("stepsize", 18.0);

	bool discoMode = view_as<bool>(kv.GetNum("disco_mode"));
	float discoModeRangeMin = kv.GetFloat("disco_mode_rng_distance_min", 420.0);
	float discoModeRangeMax = kv.GetFloat("disco_mode_rng_distance_max", 750.0);

	bool festiveLights = view_as<bool>(kv.GetNum("festive_lights"));
	int festiveLightBrightness = kv.GetNum("festive_light_brightness");
	float festiveLightDistance = kv.GetFloat("festive_light_distance");
	float festiveLightRadius = kv.GetFloat("festive_light_radius");

	float blinkLookRateMultiplier = kv.GetFloat("blink_look_rate_multiply", 1.0);
	float blinkStaticRateMultiplier = kv.GetFloat("blink_static_rate_multiply", 1.0);
	
	bool deathCam = view_as<bool>(kv.GetNum("death_cam"));
	bool deathCamScareSound = view_as<bool>(kv.GetNum("death_cam_play_scare_sound"));
	bool deathCamPublic = view_as<bool>(kv.GetNum("death_cam_public"));
	float deathCamPublicSpeed = kv.GetFloat("death_cam_speed", 1000.0);
	float deathCamPublicAcceleration = kv.GetFloat("death_cam_acceleration", 1000.0);
	float deathCamPublicDeceleration = kv.GetFloat("death_cam_deceleration", 1000.0);
	float deathCamBackwardOffset = kv.GetFloat("deathcam_death_backward_offset");
	float deathCamDownwardOffset = kv.GetFloat("deathcam_death_downward_offset");
	bool deathCamOverlay = view_as<bool>(kv.GetNum("death_cam_overlay"));
	float deathCamOverlayTimeStart = kv.GetFloat("death_cam_time_overlay_start");
	if (deathCamOverlayTimeStart < 0.0)
	{
		deathCamOverlayTimeStart = 0.0;
	}
	float deathCamTime = kv.GetFloat("death_cam_time_death");
	if (deathCamTime < 0.0)
	{
		deathCamTime = 0.0;
	}

	float soundMusicLoop = kv.GetFloat("sound_music_loop", 0.0);
	float soundMusicLoopEasy = kv.GetFloat("sound_music_loop_easy", soundMusicLoop);
	float soundMusicLoopHard = kv.GetFloat("sound_music_loop_hard", soundMusicLoop);
	float soundMusicLoopInsane = kv.GetFloat("sound_music_loop_insane", soundMusicLoopHard);
	float soundMusicLoopNightmare = kv.GetFloat("sound_music_loop_nightmare", soundMusicLoopInsane);
	float soundMusicLoopApollyon = kv.GetFloat("sound_music_loop_apollyon", soundMusicLoopNightmare);

	float instantKillCooldown = kv.GetFloat("kill_cooldown");
	float instantKillCooldownEasy = kv.GetFloat("kill_cooldown_easy", instantKillCooldown);
	float instantKillCooldownHard = kv.GetFloat("kill_cooldown_hard", instantKillCooldown);
	float instantKillCooldownInsane = kv.GetFloat("kill_cooldown_insane", instantKillCooldownHard);
	float instantKillCooldownNightmare = kv.GetFloat("kill_cooldown_nightmare", instantKillCooldownInsane);
	float instantKillCooldownApollyon = kv.GetFloat("kill_cooldown_apollyon", instantKillCooldownNightmare);

	int copyMax = kv.GetNum("copy_max", 10);
	int copyMaxEasy = kv.GetNum("copy_max_easy", copyMax);
	int copyMaxHard = kv.GetNum("copy_max_hard", copyMax);
	int copyMaxInsane = kv.GetNum("copy_max_insane", copyMaxHard);
	int copyMaxNightmare = kv.GetNum("copy_max_nightmare", copyMaxInsane);
	int copyMaxApollyon = kv.GetNum("copy_max_apollyon", copyMaxNightmare);
	
	float bossSearchRadius = kv.GetFloat("search_range", 1024.0);
	float bossSearchRadiusEasy = kv.GetFloat("search_range_easy", bossSearchRadius);
	float bossSearchRadiusHard = kv.GetFloat("search_range_hard", bossSearchRadius);
	float bossSearchRadiusInsane = kv.GetFloat("search_range_insane", bossSearchRadiusHard);
	float bossSearchRadiusNightmare = kv.GetFloat("search_range_nightmare", bossSearchRadiusInsane);
	float bossSearchRadiusApollyon = kv.GetFloat("search_range_apollyon", bossSearchRadiusNightmare);

	float bossSearchSoundRadius = kv.GetFloat("search_sound_range", 1024.0);
	float bossSearchSoundRadiusEasy = kv.GetFloat("search_sound_range_easy", bossSearchSoundRadius);
	float bossSearchSoundRadiusHard = kv.GetFloat("search_sound_range_hard", bossSearchSoundRadius);
	float bossSearchSoundRadiusInsane = kv.GetFloat("search_sound_range_insane", bossSearchSoundRadiusHard);
	float bossSearchSoundRadiusNightmare = kv.GetFloat("search_sound_range_nightmare", bossSearchSoundRadiusInsane);
	float bossSearchSoundRadiusApollyon = kv.GetFloat("search_sound_range_apollyon", bossSearchSoundRadiusNightmare);

	float flTauntAlertRange = kv.GetFloat("taunt_alert_range", 512.0);
	float flTauntAlertRangeEasy = kv.GetFloat("taunt_alert_range_easy", flTauntAlertRange);
	float flTauntAlertRangeHard = kv.GetFloat("taunt_alert_range_hard", flTauntAlertRange);
	float flTauntAlertRangeInsane = kv.GetFloat("taunt_alert_range_insane", flTauntAlertRangeHard);
	float flTauntAlertRangeNightmare = kv.GetFloat("taunt_alert_range_nightmare", flTauntAlertRangeInsane);
	float flTauntAlertRangeApollyon = kv.GetFloat("taunt_alert_range_apollyon", flTauntAlertRangeNightmare);

	bool bBossTeleportAllowed = kv.GetNum("teleport_allowed", 1) != 0;
	bool bBossTeleportAllowedEasy = kv.GetNum("teleport_allowed_easy", bBossTeleportAllowed) != 0;
	bool bBossTeleportAllowedHard = kv.GetNum("teleport_allowed_hard", bBossTeleportAllowed) != 0;
	bool bBossTeleportAllowedInsane = kv.GetNum("teleport_allowed_insane", bBossTeleportAllowedHard) != 0;
	bool bBossTeleportAllowedNightmare = kv.GetNum("teleport_allowed_nightmare", bBossTeleportAllowedInsane) != 0;
	bool bBossTeleportAllowedApollyon = kv.GetNum("teleport_allowed_apollyon", bBossTeleportAllowedNightmare) != 0;

	float bossTeleportRangeMin = kv.GetFloat("teleport_range_min", 325.0);
	float bossTeleportRangeMinEasy = kv.GetFloat("teleport_range_min_easy", bossTeleportRangeMin);
	float bossTeleportRangeMinHard = kv.GetFloat("teleport_range_min_hard", bossTeleportRangeMin);
	float bossTeleportRangeMinInsane = kv.GetFloat("teleport_range_min_insane", bossTeleportRangeMinHard);
	float bossTeleportRangeMinNightmare = kv.GetFloat("teleport_range_min_nightmare", bossTeleportRangeMinInsane);
	float bossTeleportRangeMinApollyon = kv.GetFloat("teleport_range_min_apollyon", bossTeleportRangeMinNightmare);

	float bossTeleportRangeMax = kv.GetFloat("teleport_range_max", 1024.0);
	float bossTeleportRangeMaxEasy = kv.GetFloat("teleport_range_max_easy", bossTeleportRangeMax);
	float bossTeleportRangeMaxHard = kv.GetFloat("teleport_range_max_hard", bossTeleportRangeMax);
	float bossTeleportRangeMaxInsane = kv.GetFloat("teleport_range_max_insane", bossTeleportRangeMaxHard);
	float bossTeleportRangeMaxNightmare = kv.GetFloat("teleport_range_max_nightmare", bossTeleportRangeMaxInsane);
	float bossTeleportRangeMaxApollyon = kv.GetFloat("teleport_range_max_apollyon", bossTeleportRangeMaxNightmare);

	float bossTeleportTimeMin = kv.GetFloat("teleport_time_min", 5.0);
	float bossTeleportTimeMinEasy = kv.GetFloat("teleport_time_min_easy", bossTeleportTimeMin);
	float bossTeleportTimeMinHard = kv.GetFloat("teleport_time_min_hard", bossTeleportTimeMin);
	float bossTeleportTimeMinInsane = kv.GetFloat("teleport_time_min_insane", bossTeleportTimeMinHard);
	float bossTeleportTimeMinNightmare = kv.GetFloat("teleport_time_min_nightmare", bossTeleportTimeMinInsane);
	float bossTeleportTimeMinApollyon = kv.GetFloat("teleport_time_min_apollyon", bossTeleportTimeMinNightmare);

	float bossTeleportTimeMax = kv.GetFloat("teleport_time_max", 9.0);
	float bossTeleportTimeMaxEasy = kv.GetFloat("teleport_time_max_easy", bossTeleportTimeMax);
	float bossTeleportTimeMaxHard = kv.GetFloat("teleport_time_max_hard", bossTeleportTimeMax);
	float bossTeleportTimeMaxInsane = kv.GetFloat("teleport_time_max_insane", bossTeleportTimeMaxHard);
	float bossTeleportTimeMaxNightmare = kv.GetFloat("teleport_time_max_nightmare", bossTeleportTimeMaxInsane);
	float bossTeleportTimeMaxApollyon = kv.GetFloat("teleport_time_max_apollyon", bossTeleportTimeMaxNightmare);

	float bossTeleportRestPeriod = kv.GetFloat("teleport_target_rest_period", 15.0);
	float bossTeleportRestPeriodEasy = kv.GetFloat("teleport_target_rest_period_easy", bossTeleportRestPeriod);
	float bossTeleportRestPeriodHard = kv.GetFloat("teleport_target_rest_period_hard", bossTeleportRestPeriod);
	float bossTeleportRestPeriodInsane = kv.GetFloat("teleport_target_rest_period_insane", bossTeleportRestPeriodHard);
	float bossTeleportRestPeriodNightmare = kv.GetFloat("teleport_target_rest_period_nightmare", bossTeleportRestPeriodInsane);
	float bossTeleportRestPeriodApollyon = kv.GetFloat("teleport_target_rest_period_apollyon", bossTeleportRestPeriodNightmare);

	float bossTeleportStressMin = kv.GetFloat("teleport_target_stress_min", 0.2);
	float bossTeleportStressMinEasy = kv.GetFloat("teleport_target_stress_min_easy", bossTeleportStressMin);
	float bossTeleportStressMinHard = kv.GetFloat("teleport_target_stress_min_hard", bossTeleportStressMin);
	float bossTeleportStressMinInsane = kv.GetFloat("teleport_target_stress_min_insane", bossTeleportStressMinHard);
	float bossTeleportStressMinNightmare = kv.GetFloat("teleport_target_stress_min_nightmare", bossTeleportStressMinInsane);
	float bossTeleportStressMinApollyon = kv.GetFloat("teleport_target_stress_min_apollyon", bossTeleportStressMinNightmare);

	float bossTeleportStressMax = kv.GetFloat("teleport_target_stress_max", 0.9);
	float bossTeleportStressMaxEasy = kv.GetFloat("teleport_target_stress_max_easy", bossTeleportStressMax);
	float bossTeleportStressMaxHard = kv.GetFloat("teleport_target_stress_max_hard", bossTeleportStressMax);
	float bossTeleportStressMaxInsane = kv.GetFloat("teleport_target_stress_max_insane", bossTeleportStressMaxHard);
	float bossTeleportStressMaxNightmare = kv.GetFloat("teleport_target_stress_max_nightmare", bossTeleportStressMaxInsane);
	float bossTeleportStressMaxApollyon = kv.GetFloat("teleport_target_stress_max_apollyon", bossTeleportStressMaxNightmare);

	float bossTeleportPersistencyPeriod = kv.GetFloat("teleport_target_persistency_period", 13.0);
	float bossTeleportPersistencyPeriodEasy = kv.GetFloat("teleport_target_persistency_period_easy", bossTeleportPersistencyPeriod);
	float bossTeleportPersistencyPeriodHard = kv.GetFloat("teleport_target_persistency_period_hard", bossTeleportPersistencyPeriod);
	float bossTeleportPersistencyPeriodInsane = kv.GetFloat("teleport_target_persistency_period_insane", bossTeleportPersistencyPeriodHard);
	float bossTeleportPersistencyPeriodNightmare = kv.GetFloat("teleport_target_persistency_period_nightmare", bossTeleportPersistencyPeriodInsane);
	float bossTeleportPersistencyPeriodApollyon = kv.GetFloat("teleport_target_persistency_period_apollyon", bossTeleportPersistencyPeriodNightmare);

	float bossJumpscareDistance = kv.GetFloat("jumpscare_distance");
	float bossJumpscareDistanceEasy = kv.GetFloat("jumpscare_distance_easy", bossJumpscareDistance);
	float bossJumpscareDistanceHard = kv.GetFloat("jumpscare_distance_hard", bossJumpscareDistance);
	float bossJumpscareDistanceInsane = kv.GetFloat("jumpscare_distance_insane", bossJumpscareDistanceHard);
	float bossJumpscareDistanceNightmare = kv.GetFloat("jumpscare_distance_nightmare", bossJumpscareDistanceInsane);
	float bossJumpscareDistanceApollyon = kv.GetFloat("jumpscare_distance_apollyon", bossJumpscareDistanceNightmare);

	float bossJumpscareDuration = kv.GetFloat("jumpscare_duration", 0.0);
	float bossJumpscareDurationEasy = kv.GetFloat("jumpscare_duration_easy", bossJumpscareDuration);
	float bossJumpscareDurationHard = kv.GetFloat("jumpscare_duration_hard", bossJumpscareDuration);
	float bossJumpscareDurationInsane = kv.GetFloat("jumpscare_duration_insane", bossJumpscareDurationHard);
	float bossJumpscareDurationNightmare = kv.GetFloat("jumpscare_duration_nightmare", bossJumpscareDurationInsane);
	float bossJumpscareDurationApollyon = kv.GetFloat("jumpscare_duration_apollyon", bossJumpscareDurationNightmare);

	float bossJumpscareCooldown = kv.GetFloat("jumpscare_cooldown");
	float bossJumpscareCooldownEasy = kv.GetFloat("jumpscare_cooldown_easy", bossJumpscareCooldown);
	float bossJumpscareCooldownHard = kv.GetFloat("jumpscare_cooldown_hard", bossJumpscareCooldown);
	float bossJumpscareCooldownInsane = kv.GetFloat("jumpscare_cooldown_insane", bossJumpscareCooldownHard);
	float bossJumpscareCooldownNightmare = kv.GetFloat("jumpscare_cooldown_nightmare", bossJumpscareCooldownInsane);
	float bossJumpscareCooldownApollyon = kv.GetFloat("jumpscare_cooldown_apollyon", bossJumpscareCooldownNightmare);

	float bossDefaultSpeed = kv.GetFloat("speed", 150.0);
	float bossSpeedEasy = kv.GetFloat("speed_easy", bossDefaultSpeed);
	float bossSpeedHard = kv.GetFloat("speed_hard", bossDefaultSpeed);
	float bossSpeedInsane = kv.GetFloat("speed_insane", bossSpeedHard);
	float bossSpeedNightmare = kv.GetFloat("speed_nightmare", bossSpeedInsane);
	float bossSpeedApollyon = kv.GetFloat("speed_apollyon", bossSpeedNightmare);
	
	float bossDefaultMaxSpeed = kv.GetFloat("speed_max", 150.0);
	float bossMaxSpeedEasy = kv.GetFloat("speed_max_easy", bossDefaultMaxSpeed);
	float bossMaxSpeedHard = kv.GetFloat("speed_max_hard", bossDefaultMaxSpeed);
	float bossMaxSpeedInsane = kv.GetFloat("speed_max_insane", bossMaxSpeedHard);
	float bossMaxSpeedNightmare = kv.GetFloat("speed_max_nightmare", bossMaxSpeedInsane);
	float bossMaxSpeedApollyon = kv.GetFloat("speed_max_apollyon", bossMaxSpeedNightmare);

	float bossDefaultAcceleration = kv.GetFloat("acceleration",150.0);
	float bossAccelerationEasy = kv.GetFloat("acceleration_easy",bossDefaultAcceleration);
	float bossAccelerationHard = kv.GetFloat("acceleration_hard",bossDefaultAcceleration);
	float bossAccelerationInsane = kv.GetFloat("acceleration_insane",bossAccelerationHard);
	float bossAccelerationNightmare = kv.GetFloat("acceleration_nightmare",bossAccelerationInsane);
	float bossAccelerationApollyon = kv.GetFloat("acceleration_apollyon",bossAccelerationNightmare);
	
	float bossDefaultIdleLifetime = kv.GetFloat("idle_lifetime", 10.0);
	float bossIdleLifetimeEasy = kv.GetFloat("idle_lifetime_easy", bossDefaultIdleLifetime);
	float bossIdleLifetimeHard = kv.GetFloat("idle_lifetime_hard", bossDefaultIdleLifetime);
	float bossIdleLifetimeInsane = kv.GetFloat("idle_lifetime_insane", bossIdleLifetimeHard);
	float bossIdleLifetimeNightmare = kv.GetFloat("idle_lifetime_nightmare", bossIdleLifetimeInsane);
	float bossIdleLifetimeApollyon = kv.GetFloat("idle_lifetime_apollyon", bossIdleLifetimeNightmare);
	
	bool useCustomOutlines = view_as<bool>(kv.GetNum("customizable_outlines"));
	int outlineColorR = kv.GetNum("outline_color_r", 255);
	int outlineColorG = kv.GetNum("outline_color_g", 255);
	int outlineColorB = kv.GetNum("outline_color_b", 255);
	int outlineColorTrans = kv.GetNum("outline_color_transparency", 255);
	bool rainbowOutline = view_as<bool>(kv.GetNum("enable_rainbow_outline"));
	float rainbowCycleTime = kv.GetFloat("rainbow_outline_cycle_rate", 1.0);
	if (rainbowCycleTime < 0.0)
	{
		rainbowCycleTime = 0.0;
	}

	bool speedBoostOnScare = view_as<bool>(kv.GetNum("scare_player_speed_boost"));
	float scareSpeedBoostDuration = kv.GetFloat("scare_player_speed_boost_duration");

	bool scareReaction = view_as<bool>(kv.GetNum("scare_player_reaction"));
	int scareReactionType = kv.GetNum("scare_player_reaction_type", 1);
	if (scareReactionType < 1)
	{
		scareReactionType = 1;
	}
	if (scareReactionType > 3)
	{
		scareReactionType = 3;
	}
	
	bool scareReplenishSprint = view_as<bool>(kv.GetNum("scare_player_replenish_sprint"));
	int scareReplenishSprintAmount = kv.GetNum("scare_player_replenish_sprint_amount");

	float staticRadius = kv.GetFloat("static_radius", 0.0);
	float staticRadiusEasy = kv.GetFloat("static_radius_easy", staticRadius);
	float staticRadiusHard = kv.GetFloat("static_radius_hard", staticRadius);
	float staticRadiusInsane = kv.GetFloat("static_radius_insane", staticRadiusHard);
	float staticRadiusNightmare = kv.GetFloat("static_radius_nightmare", staticRadiusInsane);
	float staticRadiusApollyon = kv.GetFloat("static_radius_apollyon", staticRadiusNightmare);

	float staticRate = kv.GetFloat("static_rate");
	float staticRateEasy = kv.GetFloat("static_rate_easy", staticRate);
	float staticRateHard = kv.GetFloat("static_rate_hard", staticRate);
	float staticRateInsane = kv.GetFloat("static_rate_insane", staticRateHard);
	float staticRateNightmare = kv.GetFloat("static_rate_nightmare", staticRateInsane);
	float staticRateApollyon = kv.GetFloat("static_rate_apollyon", staticRateNightmare);

	float staticRateDecay = kv.GetFloat("static_rate_decay");
	float staticRateDecayEasy = kv.GetFloat("static_rate_decay_easy", staticRateDecay);
	float staticRateDecayHard = kv.GetFloat("static_rate_decay_hard", staticRateDecay);
	float staticRateDecayInsane = kv.GetFloat("static_rate_decay_insane", staticRateDecayHard);
	float staticRateDecayNightmare = kv.GetFloat("static_rate_decay_nightmare", staticRateDecayInsane);
	float staticRateDecayApollyon = kv.GetFloat("static_rate_decay_apollyon", staticRateDecayNightmare);

	float staticGraceTime = kv.GetFloat("static_on_look_gracetime", 1.0);
	float staticGraceTimeEasy = kv.GetFloat("static_on_look_gracetime_easy", staticGraceTime);
	float staticGraceTimeHard = kv.GetFloat("static_on_look_gracetime_hard", staticGraceTime);
	float staticGraceTimeInsane = kv.GetFloat("static_on_look_gracetime_insane", staticGraceTimeHard);
	float staticGraceTimeNightmare = kv.GetFloat("static_on_look_gracetime_nightmare", staticGraceTimeInsane);
	float staticGraceTimeApollyon = kv.GetFloat("static_on_look_gracetime_apollyon", staticGraceTimeNightmare);

	float proxyDamageVsEnemy = kv.GetFloat("proxies_damage_scale_vs_enemy", 1.0);
	float proxyDamageVsEnemyEasy = kv.GetFloat("proxies_damage_scale_vs_enemy_easy", proxyDamageVsEnemy);
	float proxyDamageVsEnemyHard = kv.GetFloat("proxies_damage_scale_vs_enemy_hard", proxyDamageVsEnemy);
	float proxyDamageVsEnemyInsane = kv.GetFloat("proxies_damage_scale_vs_enemy_insane", proxyDamageVsEnemyHard);
	float proxyDamageVsEnemyNightmare = kv.GetFloat("proxies_damage_scale_vs_enemy_nightmare", proxyDamageVsEnemyInsane);
	float proxyDamageVsEnemyApollyon = kv.GetFloat("proxies_damage_scale_vs_enemy_apollyon", proxyDamageVsEnemyNightmare);

	float proxyDamageVsBackstab = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab", 0.25);
	float proxyDamageVsBackstabEasy = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_easy", proxyDamageVsBackstab);
	float proxyDamageVsBackstabHard = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_hard", proxyDamageVsBackstab);
	float proxyDamageVsBackstabInsane = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_insane", proxyDamageVsBackstabHard);
	float proxyDamageVsBackstabNightmare = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_nightmare", proxyDamageVsBackstabInsane);
	float proxyDamageVsBackstabApollyon = kv.GetFloat("proxies_damage_scale_vs_enemy_backstab_apollyon", proxyDamageVsBackstabNightmare);

	float proxyDamageVsSelf = kv.GetFloat("proxies_damage_scale_vs_self", 1.0);
	float proxyDamageVsSelfEasy = kv.GetFloat("proxies_damage_scale_vs_self_easy", proxyDamageVsSelf);
	float proxyDamageVsSelfHard = kv.GetFloat("proxies_damage_scale_vs_self_hard", proxyDamageVsSelf);
	float proxyDamageVsSelfInsane = kv.GetFloat("proxies_damage_scale_vs_self_insane", proxyDamageVsSelfHard);
	float proxyDamageVsSelfNightmare = kv.GetFloat("proxies_damage_scale_vs_self_nightmare", proxyDamageVsSelfInsane);
	float proxyDamageVsSelfApollyon = kv.GetFloat("proxies_damage_scale_vs_self_apollyon", proxyDamageVsSelfNightmare);

	int proxyControlGainHitEnemy = kv.GetNum("proxies_controlgain_hitenemy");
	int proxyControlGainHitEnemyEasy = kv.GetNum("proxies_controlgain_hitenemy_easy", proxyControlGainHitEnemy);
	int proxyControlGainHitEnemyHard = kv.GetNum("proxies_controlgain_hitenemy_hard", proxyControlGainHitEnemy);
	int proxyControlGainHitEnemyInsane = kv.GetNum("proxies_controlgain_hitenemy_insane", proxyControlGainHitEnemyHard);
	int proxyControlGainHitEnemyNightmare = kv.GetNum("proxies_controlgain_hitenemy_nightmare", proxyControlGainHitEnemyInsane);
	int proxyControlGainHitEnemyApollyon = kv.GetNum("proxies_controlgain_hitenemy_apollyon", proxyControlGainHitEnemyNightmare);

	int proxyControlGainHitByEnemy = kv.GetNum("proxies_controlgain_hitbyenemy");
	int proxyControlGainHitByEnemyEasy = kv.GetNum("proxies_controlgain_hitbyenemy_easy", proxyControlGainHitByEnemy);
	int proxyControlGainHitByEnemyHard = kv.GetNum("proxies_controlgain_hitbyenemy_hard", proxyControlGainHitByEnemy);
	int proxyControlGainHitByEnemyInsane = kv.GetNum("proxies_controlgain_hitbyenemy_insane", proxyControlGainHitByEnemyHard);
	int proxyControlGainHitByEnemyNightmare = kv.GetNum("proxies_controlgain_hitbyenemy_nightmare", proxyControlGainHitByEnemyInsane);
	int proxyControlGainHitByEnemyApollyon = kv.GetNum("proxies_controlgain_hitbyenemy_apollyon", proxyControlGainHitByEnemyNightmare);

	float proxyControlDrainRate = kv.GetFloat("proxies_controldrainrate");
	float proxyControlDrainRateEasy = kv.GetFloat("proxies_controldrainrate_easy", proxyControlDrainRate);
	float proxyControlDrainRateHard = kv.GetFloat("proxies_controldrainrate_hard", proxyControlDrainRate);
	float proxyControlDrainRateInsane = kv.GetFloat("proxies_controldrainrate_insane", proxyControlDrainRateHard);
	float proxyControlDrainRateNightmare = kv.GetFloat("proxies_controldrainrate_nightmare", proxyControlDrainRateInsane);
	float proxyControlDrainRateApollyon = kv.GetFloat("proxies_controldrainrate_apollyon", proxyControlDrainRateNightmare);

	float proxySpawnChanceMin = kv.GetFloat("proxies_spawn_chance_min");
	float proxySpawnChanceMinEasy = kv.GetFloat("proxies_spawn_chance_min_easy", proxySpawnChanceMin);
	float proxySpawnChanceMinHard = kv.GetFloat("proxies_spawn_chance_min_hard", proxySpawnChanceMin);
	float proxySpawnChanceMinInsane = kv.GetFloat("proxies_spawn_chance_min_insane", proxySpawnChanceMinHard);
	float proxySpawnChanceMinNightmare = kv.GetFloat("proxies_spawn_chance_min_nightmare", proxySpawnChanceMinInsane);
	float proxySpawnChanceMinApollyon = kv.GetFloat("proxies_spawn_chance_min_apollyon", proxySpawnChanceMinNightmare);

	float proxySpawnChanceMax = kv.GetFloat("proxies_spawn_chance_max");
	float proxySpawnChanceMaxEasy = kv.GetFloat("proxies_spawn_chance_max_easy", proxySpawnChanceMax);
	float proxySpawnChanceMaxHard = kv.GetFloat("proxies_spawn_chance_max_hard", proxySpawnChanceMax);
	float proxySpawnChanceMaxInsane = kv.GetFloat("proxies_spawn_chance_max_insane", proxySpawnChanceMaxHard);
	float proxySpawnChanceMaxNightmare = kv.GetFloat("proxies_spawn_chance_max_nightmare", proxySpawnChanceMaxInsane);
	float proxySpawnChanceMaxApollyon = kv.GetFloat("proxies_spawn_chance_max_apollyon", proxySpawnChanceMaxNightmare);

	float proxySpawnChanceThreshold = kv.GetFloat("proxies_spawn_chance_threshold");
	float proxySpawnChanceThresholdEasy = kv.GetFloat("proxies_spawn_chance_threshold_easy", proxySpawnChanceThreshold);
	float proxySpawnChanceThresholdHard = kv.GetFloat("proxies_spawn_chance_threshold_hard", proxySpawnChanceThreshold);
	float proxySpawnChanceThresholdInsane = kv.GetFloat("proxies_spawn_chance_threshold_insane", proxySpawnChanceThresholdHard);
	float proxySpawnChanceThresholdNightmare = kv.GetFloat("proxies_spawn_chance_threshold_nightmare", proxySpawnChanceThresholdInsane);
	float proxySpawnChanceThresholdApollyon = kv.GetFloat("proxies_spawn_chance_threshold_apollyon", proxySpawnChanceThresholdNightmare);

	int proxySpawnNumMin = kv.GetNum("proxies_spawn_num_min");
	int proxySpawnNumMinEasy = kv.GetNum("proxies_spawn_num_min_easy", proxySpawnNumMin);
	int proxySpawnNumMinHard = kv.GetNum("proxies_spawn_num_min_hard", proxySpawnNumMin);
	int proxySpawnNumMinInsane = kv.GetNum("proxies_spawn_num_min_insane", proxySpawnNumMinHard);
	int proxySpawnNumMinNightmare = kv.GetNum("proxies_spawn_num_min_nightmare", proxySpawnNumMinInsane);
	int proxySpawnNumMinApollyon = kv.GetNum("proxies_spawn_num_min_apollyon", proxySpawnNumMinNightmare);

	int proxySpawnNumMax = kv.GetNum("proxies_spawn_num_max");
	int proxySpawnNumMaxEasy = kv.GetNum("proxies_spawn_num_max_easy", proxySpawnNumMax);
	int proxySpawnNumMaxHard = kv.GetNum("proxies_spawn_num_max_hard", proxySpawnNumMax);
	int proxySpawnNumMaxInsane = kv.GetNum("proxies_spawn_num_max_insane", proxySpawnNumMaxHard);
	int proxySpawnNumMaxNightmare = kv.GetNum("proxies_spawn_num_max_nightmare", proxySpawnNumMaxInsane);
	int proxySpawnNumMaxApollyon = kv.GetNum("proxies_spawn_num_max_apollyon", proxySpawnNumMaxNightmare);

	float proxySpawnCooldownMin = kv.GetFloat("proxies_spawn_cooldown_min");
	float proxySpawnCooldownMinEasy = kv.GetFloat("proxies_spawn_cooldown_min_easy", proxySpawnCooldownMin);
	float proxySpawnCooldownMinHard = kv.GetFloat("proxies_spawn_cooldown_min_hard", proxySpawnCooldownMin);
	float proxySpawnCooldownMinInsane = kv.GetFloat("proxies_spawn_cooldown_min_insane", proxySpawnCooldownMinHard);
	float proxySpawnCooldownMinNightmare = kv.GetFloat("proxies_spawn_cooldown_min_nightmare", proxySpawnCooldownMinInsane);
	float proxySpawnCooldownMinApollyon = kv.GetFloat("proxies_spawn_cooldown_min_apollyon", proxySpawnCooldownMinNightmare);

	float proxySpawnCooldownMax = kv.GetFloat("proxies_spawn_cooldown_max");
	float proxySpawnCooldownMaxEasy = kv.GetFloat("proxies_spawn_cooldown_max_easy", proxySpawnCooldownMax);
	float proxySpawnCooldownMaxHard = kv.GetFloat("proxies_spawn_cooldown_max_hard", proxySpawnCooldownMax);
	float proxySpawnCooldownMaxInsane = kv.GetFloat("proxies_spawn_cooldown_max_insane", proxySpawnCooldownMaxHard);
	float proxySpawnCooldownMaxNightmare = kv.GetFloat("proxies_spawn_cooldown_max_nightmare", proxySpawnCooldownMaxInsane);
	float proxySpawnCooldownMaxApollyon = kv.GetFloat("proxies_spawn_cooldown_max_apollyon", proxySpawnCooldownMaxNightmare);

	int proxyMax = kv.GetNum("proxies_max");
	int proxyMaxEasy = kv.GetNum("proxies_max_easy", proxyMax);
	int proxyMaxHard = kv.GetNum("proxies_max_hard", proxyMax);
	int proxyMaxInsane = kv.GetNum("proxies_max_insane", proxyMaxHard);
	int proxyMaxNightmare = kv.GetNum("proxies_max_nightmare", proxyMaxInsane);
	int proxyMaxApollyon = kv.GetNum("proxies_max_apollyon", proxyMaxNightmare);

	float proxyTeleportRangeMin = kv.GetFloat("proxies_teleport_range_min", 500.0);
	float proxyTeleportRangeMinEasy = kv.GetFloat("proxies_teleport_range_min_easy", proxyTeleportRangeMin);
	float proxyTeleportRangeMinHard = kv.GetFloat("proxies_teleport_range_min_hard", proxyTeleportRangeMin);
	float proxyTeleportRangeMinInsane = kv.GetFloat("proxies_teleport_range_min_insane", proxyTeleportRangeMinHard);
	float proxyTeleportRangeMinNightmare = kv.GetFloat("proxies_teleport_range_min_nightmare", proxyTeleportRangeMinInsane);
	float proxyTeleportRangeMinApollyon = kv.GetFloat("proxies_teleport_range_min_apollyon", proxyTeleportRangeMinNightmare);

	float proxyTeleportRangeMax = kv.GetFloat("proxies_teleport_range_max", 3200.0);
	float proxyTeleportRangeMaxEasy = kv.GetFloat("proxies_teleport_range_max_easy", proxyTeleportRangeMax);
	float proxyTeleportRangeMaxHard = kv.GetFloat("proxies_teleport_range_max_hard", proxyTeleportRangeMax);
	float proxyTeleportRangeMaxInsane = kv.GetFloat("proxies_teleport_range_max_insane", proxyTeleportRangeMaxHard);
	float proxyTeleportRangeMaxNightmare = kv.GetFloat("proxies_teleport_range_max_nightmare", proxyTeleportRangeMaxInsane);
	float proxyTeleportRangeMaxApollyon = kv.GetFloat("proxies_teleport_range_max_apollyon", proxyTeleportRangeMaxNightmare);

	int proxyHurtChannel = kv.GetNum("sound_proxy_hurt_channel", SNDCHAN_AUTO);
	int proxyHurtLevel = kv.GetNum("sound_proxy_hurt_level", SNDLEVEL_NORMAL);
	int proxyHurtFlags = kv.GetNum("sound_proxy_hurt_flags", SND_NOFLAGS);
	float proxyHurtVolume = kv.GetFloat("sound_proxy_hurt_volume", SNDVOL_NORMAL);
	int proxyHurtPitch = kv.GetNum("sound_proxy_hurt_pitch", SNDPITCH_NORMAL);

	int proxyDeathChannel = kv.GetNum("sound_proxy_death_channel", SNDCHAN_AUTO);
	int proxyDeathLevel = kv.GetNum("sound_proxy_death_level", SNDLEVEL_NORMAL);
	int proxyDeathFlags = kv.GetNum("sound_proxy_death_flags", SND_NOFLAGS);
	float proxyDeathVolume = kv.GetFloat("sound_proxy_death_volume", SNDVOL_NORMAL);
	int proxyDeathPitch = kv.GetNum("sound_proxy_death_pitch", SNDPITCH_NORMAL);

	int proxyIdleChannel = kv.GetNum("sound_proxy_idle_channel", SNDCHAN_AUTO);
	int proxyIdleLevel = kv.GetNum("sound_proxy_idle_level", SNDLEVEL_NORMAL);
	int proxyIdleFlags = kv.GetNum("sound_proxy_idle_flags", SND_NOFLAGS);
	float proxyIdleVolume = kv.GetFloat("sound_proxy_idle_volume", SNDVOL_NORMAL);
	int proxyIdlePitch = kv.GetNum("sound_proxy_idle_pitch", SNDPITCH_NORMAL);
	float proxyIdleCooldownMin = kv.GetFloat("sound_proxy_idle_cooldown_min", 1.5);
	float proxyIdleCooldownMax = kv.GetFloat("sound_proxy_idle_cooldown_max", 3.0);

	int proxySpawnChannel = kv.GetNum("sound_proxy_spawn_channel", SNDCHAN_AUTO);
	int proxySpawnLevel = kv.GetNum("sound_proxy_spawn_level", SNDLEVEL_NORMAL);
	int proxySpawnFlags = kv.GetNum("sound_proxy_spawn_flags", SND_NOFLAGS);
	float proxySpawnVolume = kv.GetFloat("sound_proxy_spawn_volume", SNDVOL_NORMAL);
	int proxySpawnPitch = kv.GetNum("sound_proxy_spawn_pitch", SNDPITCH_NORMAL);

	bool proxySpawnEffects = view_as<bool>(kv.GetNum("proxies_spawn_effect_enabled"));
	float proxySpawnEffectZOffset = kv.GetFloat("proxies_spawn_effect_z_offset");

	bool proxyWeaponsEnabled = view_as<bool>(kv.GetNum("proxies_weapon", 0));

	bool fakeCopies = view_as<bool>(kv.GetNum("fake_copies"));

	bool drainCreditsOnKill = view_as<bool>(kv.GetNum("drain_credits_on_kill"));
	int creditDrainAmount = kv.GetNum("drain_credits_amount", 50);
	int creditDrainAmountEasy = kv.GetNum("drain_credits_amount_easy", creditDrainAmount);
	int creditDrainAmountHard = kv.GetNum("drain_credits_amount_hard", creditDrainAmount);
	int creditDrainAmountInsane = kv.GetNum("drain_credits_amount_insane", creditDrainAmountHard);
	int creditDrainAmountNightmare = kv.GetNum("drain_credits_amount_nightmare", creditDrainAmountInsane);
	int creditDrainAmountApollyon = kv.GetNum("drain_credits_amount_apollyon", creditDrainAmountNightmare);

	bool ashRagdoll = view_as<bool>(kv.GetNum("ash_ragdoll_on_kill"));
	if (!ashRagdoll)
	{
		ashRagdoll = view_as<bool>(kv.GetNum("disintegrate_ragdoll_on_kill"));
	}

	float bossEyePosOffset[3];
	kv.GetVector("eye_pos", bossEyePosOffset);
	
	float bossEyeAngOffset[3];
	kv.GetVector("eye_ang_offset", bossEyeAngOffset);

	// Parse through flags.
	int bossFlags = 0;
	if (kv.GetNum("static_shake")) bossFlags |= SFF_HASSTATICSHAKE;
	if (kv.GetNum("static_on_look")) bossFlags |= SFF_STATICONLOOK;
	if (kv.GetNum("static_on_radius")) bossFlags |= SFF_STATICONRADIUS;
	if (kv.GetNum("proxies")) bossFlags |= SFF_PROXIES;
	if (kv.GetNum("jumpscare")) bossFlags |= SFF_HASJUMPSCARE;
	if (kv.GetNum("sound_sight_enabled")) bossFlags |= SFF_HASSIGHTSOUNDS;
	if (kv.GetNum("sound_static_loop_local_enabled")) bossFlags |= SFF_HASSTATICLOOPLOCALSOUND;
	if (kv.GetNum("view_shake", 1)) bossFlags |= SFF_HASVIEWSHAKE;
	if (kv.GetNum("copy")) bossFlags |= SFF_COPIES;
	if (kv.GetNum("wander_move", 1)) bossFlags |= SFF_WANDERMOVE;
	if (kv.GetNum("attack_props", 0)) bossFlags |= SFF_ATTACKPROPS;
	if (kv.GetNum("attack_weaponsenable", 0)) bossFlags |= SFF_WEAPONKILLS;
	if (kv.GetNum("kill_weaponsenable", 0)) bossFlags |= SFF_WEAPONKILLSONRADIUS;
	if (kv.GetNum("random_attacks", 0)) bossFlags |= SFF_RANDOMATTACKS;
	
	// Try validating unique profile type.
	// The unique profile index specifies the location of a boss's type-specific data in another array.

	int uniqueProfileIndex = -1;
	
	switch (bossType)
	{
		case SF2BossType_Statue:
		{
			if (!LoadStatueBossProfile(kv, profile, uniqueProfileIndex, loadFailReasonBuffer))
			{
				return false;
			}
		}
		case SF2BossType_Chaser:
		{
			if (!LoadChaserBossProfile(kv, profile, uniqueProfileIndex, loadFailReasonBuffer))
			{
				return false;
			}
		}
	}
	
	// Add the section to our config.
	g_Config.Rewind();
	g_Config.JumpToKey(profile, true);
	KvCopySubkeys(kv, g_Config);
	
	bool createNewBoss = false;
	int iIndex = GetBossProfileList().FindString(profile);
	if (iIndex == -1)
	{
		createNewBoss = true;
	}
	
	// Add to/Modify our array.
	// Cache values into g_BossProfileData, because traversing a KeyValues object is expensive.

	if (createNewBoss)
	{
		iIndex = g_BossProfileData.Push(-1);
		g_BossProfileNames.SetValue(profile, iIndex);
		
		// Add to the boss list since it's not there already.
		GetBossProfileList().PushString(profile);
	}

	g_BossProfileData.Set(iIndex, uniqueProfileIndex, BossProfileData_UniqueProfileIndex);
	g_BossProfileData.Set(iIndex, bossType, BossProfileData_Type);
	g_BossProfileData.Set(iIndex, bossModelScale, BossProfileData_ModelScale);
	g_BossProfileData.Set(iIndex, bossHealth, BossProfileData_Health);
	g_BossProfileData.Set(iIndex, bossSkin, BossProfileData_Skin);
	g_BossProfileData.Set(iIndex, bossSkinEasy, BossProfileData_SkinEasy);
	g_BossProfileData.Set(iIndex, bossSkinHard, BossProfileData_SkinHard);
	g_BossProfileData.Set(iIndex, bossSkinInsane, BossProfileData_SkinInsane);
	g_BossProfileData.Set(iIndex, bossSkinNightmare, BossProfileData_SkinNightmare);
	g_BossProfileData.Set(iIndex, bossSkinApollyon, BossProfileData_SkinApollyon);
	g_BossProfileData.Set(iIndex, bossSkinMax, BossProfileData_SkinMax);
	g_BossProfileData.Set(iIndex, bossBodyGroups, BossProfileData_Body);
	g_BossProfileData.Set(iIndex, bossBodyGroupsEasy, BossProfileData_BodyEasy);
	g_BossProfileData.Set(iIndex, bossBodyGroupsHard, BossProfileData_BodyHard);
	g_BossProfileData.Set(iIndex, bossBodyGroupsInsane, BossProfileData_BodyInsane);
	g_BossProfileData.Set(iIndex, bossBodyGroupsNightmare, BossProfileData_BodyNightmare);
	g_BossProfileData.Set(iIndex, bossBodyGroupsApollyon, BossProfileData_BodyApollyon);
	g_BossProfileData.Set(iIndex, bossBodyGroupsMax, BossProfileData_BodyMax);
	g_BossProfileData.Set(iIndex, useRaidHitbox, BossProfileData_UseRaidHitbox);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("ignore_nav_prefer", 1)), BossProfileData_IgnoreNavPrefer);
	g_BossProfileData.Set(iIndex, blinkLookRateMultiplier, BossProfileData_BlinkLookRateMultipler);
	g_BossProfileData.Set(iIndex, blinkStaticRateMultiplier, BossProfileData_BlinkStaticRateMultiplier);
	g_BossProfileData.Set(iIndex, bossStepSize, BossProfileData_StepSize);

	g_BossProfileData.Set(iIndex, discoMode, BossProfileData_DiscoMode);
	g_BossProfileData.Set(iIndex, discoModeRangeMin, BossProfileData_DiscoDistanceMin);
	g_BossProfileData.Set(iIndex, discoModeRangeMax, BossProfileData_DiscoDistanceMax);

	g_BossProfileData.Set(iIndex, festiveLights, BossProfileData_FestiveLights);
	g_BossProfileData.Set(iIndex, festiveLightBrightness, BossProfileData_FestiveLightBrightness);
	g_BossProfileData.Set(iIndex, festiveLightDistance, BossProfileData_FestiveLightDistance);
	g_BossProfileData.Set(iIndex, festiveLightRadius, BossProfileData_FestiveLightRadius);

	g_BossProfileData.Set(iIndex, deathCam, BossProfileData_HasDeathCam);
	g_BossProfileData.Set(iIndex, deathCamScareSound, BossProfileData_DeathCamPlayScareSound);
	g_BossProfileData.Set(iIndex, deathCamPublic, BossProfileData_PublicDeathCam);
	g_BossProfileData.Set(iIndex, deathCamPublicSpeed, BossProfileData_PublicDeathCamSpeed);
	g_BossProfileData.Set(iIndex, deathCamPublicAcceleration, BossProfileData_PublicDeathCamAcceleration);
	g_BossProfileData.Set(iIndex, deathCamPublicDeceleration, BossProfileData_PublicDeathCamDeceleration);
	g_BossProfileData.Set(iIndex, deathCamBackwardOffset, BossProfileData_PublicDeathCamBackwardOffset);
	g_BossProfileData.Set(iIndex, deathCamDownwardOffset, BossProfileData_PublicDeathCamDownwardOffset);
	g_BossProfileData.Set(iIndex, deathCamOverlay, BossProfileData_DeathCamOverlay);
	g_BossProfileData.Set(iIndex, deathCamOverlayTimeStart, BossProfileData_DeathCamOverlayStartTime);
	g_BossProfileData.Set(iIndex, deathCamTime, BossProfileData_DeathCamTime);

	g_BossProfileData.Set(iIndex, soundMusicLoop, BossProfileData_SoundMusicLoopNormal);
	g_BossProfileData.Set(iIndex, soundMusicLoopEasy, BossProfileData_SoundMusicLoopEasy);
	g_BossProfileData.Set(iIndex, soundMusicLoopHard, BossProfileData_SoundMusicLoopHard);
	g_BossProfileData.Set(iIndex, soundMusicLoopInsane, BossProfileData_SoundMusicLoopInsane);
	g_BossProfileData.Set(iIndex, soundMusicLoopNightmare, BossProfileData_SoundMusicLoopNightmare);
	g_BossProfileData.Set(iIndex, soundMusicLoopApollyon, BossProfileData_SoundMusicLoopApollyon);
	
	g_BossProfileData.Set(iIndex, copyMax, BossProfileData_CopyNormal);
	g_BossProfileData.Set(iIndex, copyMaxEasy, BossProfileData_CopyEasy);
	g_BossProfileData.Set(iIndex, copyMaxHard, BossProfileData_CopyHard);
	g_BossProfileData.Set(iIndex, copyMaxInsane, BossProfileData_CopyInsane);
	g_BossProfileData.Set(iIndex, copyMaxNightmare, BossProfileData_CopyNightmare);
	g_BossProfileData.Set(iIndex, copyMaxApollyon, BossProfileData_CopyApollyon);
	
	g_BossProfileData.Set(iIndex, bossFlags, BossProfileData_Flags);
	
	g_BossProfileData.Set(iIndex, bossDefaultSpeed, BossProfileData_SpeedNormal);
	g_BossProfileData.Set(iIndex, bossSpeedEasy, BossProfileData_SpeedEasy);
	g_BossProfileData.Set(iIndex, bossSpeedHard, BossProfileData_SpeedHard);
	g_BossProfileData.Set(iIndex, bossSpeedInsane, BossProfileData_SpeedInsane);
	g_BossProfileData.Set(iIndex, bossSpeedNightmare, BossProfileData_SpeedNightmare);
	g_BossProfileData.Set(iIndex, bossSpeedApollyon, BossProfileData_SpeedApollyon);
	
	g_BossProfileData.Set(iIndex, bossDefaultMaxSpeed, BossProfileData_MaxSpeedNormal);
	g_BossProfileData.Set(iIndex, bossMaxSpeedEasy, BossProfileData_MaxSpeedEasy);
	g_BossProfileData.Set(iIndex, bossMaxSpeedHard, BossProfileData_MaxSpeedHard);
	g_BossProfileData.Set(iIndex, bossMaxSpeedInsane, BossProfileData_MaxSpeedInsane);
	g_BossProfileData.Set(iIndex, bossMaxSpeedNightmare, BossProfileData_MaxSpeedNightmare);
	g_BossProfileData.Set(iIndex, bossMaxSpeedApollyon, BossProfileData_MaxSpeedApollyon);

	g_BossProfileData.Set(iIndex, bossDefaultAcceleration, BossProfileData_AccelerationNormal);
	g_BossProfileData.Set(iIndex, bossAccelerationEasy, BossProfileData_AccelerationEasy);
	g_BossProfileData.Set(iIndex, bossAccelerationHard, BossProfileData_AccelerationHard);
	g_BossProfileData.Set(iIndex, bossAccelerationInsane, BossProfileData_AccelerationInsane);
	g_BossProfileData.Set(iIndex, bossAccelerationNightmare, BossProfileData_AccelerationNightmare);
	g_BossProfileData.Set(iIndex, bossAccelerationApollyon, BossProfileData_AccelerationApollyon);

	g_BossProfileData.Set(iIndex, bossDefaultIdleLifetime, BossProfileData_IdleLifetimeNormal);
	g_BossProfileData.Set(iIndex, bossIdleLifetimeEasy, BossProfileData_IdleLifetimeEasy);
	g_BossProfileData.Set(iIndex, bossIdleLifetimeHard, BossProfileData_IdleLifetimeHard);
	g_BossProfileData.Set(iIndex, bossIdleLifetimeInsane, BossProfileData_IdleLifetimeInsane);
	g_BossProfileData.Set(iIndex, bossIdleLifetimeNightmare, BossProfileData_IdleLifetimeNightmare);
	g_BossProfileData.Set(iIndex, bossIdleLifetimeApollyon, BossProfileData_IdleLifetimeApollyon);
	
	g_BossProfileData.Set(iIndex, bossEyePosOffset[0], BossProfileData_EyePosOffsetX);
	g_BossProfileData.Set(iIndex, bossEyePosOffset[1], BossProfileData_EyePosOffsetY);
	g_BossProfileData.Set(iIndex, bossEyePosOffset[2], BossProfileData_EyePosOffsetZ);
	
	g_BossProfileData.Set(iIndex, bossEyeAngOffset[0], BossProfileData_EyeAngOffsetX);
	g_BossProfileData.Set(iIndex, bossEyeAngOffset[1], BossProfileData_EyeAngOffsetY);
	g_BossProfileData.Set(iIndex, bossEyeAngOffset[2], BossProfileData_EyeAngOffsetZ);
	
	g_BossProfileData.Set(iIndex, bossAngerStart, BossProfileData_AngerStart);
	g_BossProfileData.Set(iIndex, bossAngerAddOnPageGrab, BossProfileData_AngerAddOnPageGrab);
	g_BossProfileData.Set(iIndex, bossAngerPageGrabTimeDiffReq, BossProfileData_AngerPageGrabTimeDiffReq);
	
	g_BossProfileData.Set(iIndex, bossInstantKillRadius, BossProfileData_InstantKillRadius);

	g_BossProfileData.Set(iIndex, instantKillCooldown, BossProfileData_InstantKillCooldownNormal);
	g_BossProfileData.Set(iIndex, instantKillCooldownEasy, BossProfileData_InstantKillCooldownEasy);
	g_BossProfileData.Set(iIndex, instantKillCooldownHard, BossProfileData_InstantKillCooldownHard);
	g_BossProfileData.Set(iIndex, instantKillCooldownInsane, BossProfileData_InstantKillCooldownInsane);
	g_BossProfileData.Set(iIndex, instantKillCooldownNightmare, BossProfileData_InstantKillCooldownNightmare);
	g_BossProfileData.Set(iIndex, instantKillCooldownApollyon, BossProfileData_InstantKillCooldownApollyon);
	
	g_BossProfileData.Set(iIndex, bossScareRadius, BossProfileData_ScareRadius);
	g_BossProfileData.Set(iIndex, bossScareCooldown, BossProfileData_ScareCooldown);

	g_BossProfileData.Set(iIndex, speedBoostOnScare, BossProfileData_SpeedBoostOnScare);
	g_BossProfileData.Set(iIndex, scareSpeedBoostDuration, BossProfileData_ScareSpeedBoostDuration);

	g_BossProfileData.Set(iIndex, scareReaction, BossProfileData_ScareReaction);
	g_BossProfileData.Set(iIndex, scareReactionType, BossProfileData_ScareReactionType);

	g_BossProfileData.Set(iIndex, scareReplenishSprint, BossProfileData_ScareReplenishSprint);
	g_BossProfileData.Set(iIndex, scareReplenishSprintAmount, BossProfileData_ScareReplenishSprintAmount);
	
	g_BossProfileData.Set(iIndex, bossTeleportType, BossProfileData_TeleportType);
	
	g_BossProfileData.Set(iIndex, useCustomOutlines, BossProfileData_EnableCustomizableOutlines);
	g_BossProfileData.Set(iIndex, outlineColorR, BossProfileData_OutlineColorR);
	g_BossProfileData.Set(iIndex, outlineColorG, BossProfileData_OutlineColorG);
	g_BossProfileData.Set(iIndex, outlineColorB, BossProfileData_OutlineColorB);
	g_BossProfileData.Set(iIndex, outlineColorTrans, BossProfileData_OutlineColorTrans);
	g_BossProfileData.Set(iIndex, rainbowOutline, BossProfileData_RainbowOutline);
	g_BossProfileData.Set(iIndex, rainbowCycleTime, BossProfileData_RainbowOutlineCycle);

	g_BossProfileData.Set(iIndex, staticRadius, BossProfileData_StaticRadiusNormal);
	g_BossProfileData.Set(iIndex, staticRadiusEasy, BossProfileData_StaticRadiusEasy);
	g_BossProfileData.Set(iIndex, staticRadiusHard, BossProfileData_StaticRadiusHard);
	g_BossProfileData.Set(iIndex, staticRadiusInsane, BossProfileData_StaticRadiusInsane);
	g_BossProfileData.Set(iIndex, staticRadiusNightmare, BossProfileData_StaticRadiusNightmare);
	g_BossProfileData.Set(iIndex, staticRadiusApollyon, BossProfileData_StaticRadiusApollyon);

	g_BossProfileData.Set(iIndex, staticRate, BossProfileData_StaticRateNormal);
	g_BossProfileData.Set(iIndex, staticRateEasy, BossProfileData_StaticRateEasy);
	g_BossProfileData.Set(iIndex, staticRateHard, BossProfileData_StaticRateHard);
	g_BossProfileData.Set(iIndex, staticRateInsane, BossProfileData_StaticRateInsane);
	g_BossProfileData.Set(iIndex, staticRateNightmare, BossProfileData_StaticRateNightmare);
	g_BossProfileData.Set(iIndex, staticRateApollyon, BossProfileData_StaticRateApollyon);

	g_BossProfileData.Set(iIndex, staticRateDecay, BossProfileData_StaticRateDecayNormal);
	g_BossProfileData.Set(iIndex, staticRateDecayEasy, BossProfileData_StaticRateDecayEasy);
	g_BossProfileData.Set(iIndex, staticRateDecayHard, BossProfileData_StaticRateDecayHard);
	g_BossProfileData.Set(iIndex, staticRateDecayInsane, BossProfileData_StaticRateDecayInsane);
	g_BossProfileData.Set(iIndex, staticRateDecayNightmare, BossProfileData_StaticRateDecayNightmare);
	g_BossProfileData.Set(iIndex, staticRateDecayApollyon, BossProfileData_StaticRateDecayApollyon);

	g_BossProfileData.Set(iIndex, staticGraceTime, BossProfileData_StaticGraceTimeNormal);
	g_BossProfileData.Set(iIndex, staticGraceTimeEasy, BossProfileData_StaticGraceTimeEasy);
	g_BossProfileData.Set(iIndex, staticGraceTimeHard, BossProfileData_StaticGraceTimeHard);
	g_BossProfileData.Set(iIndex, staticGraceTimeInsane, BossProfileData_StaticGraceTimeInsane);
	g_BossProfileData.Set(iIndex, staticGraceTimeNightmare, BossProfileData_StaticGraceTimeNightmare);
	g_BossProfileData.Set(iIndex, staticGraceTimeApollyon, BossProfileData_StaticGraceTimeApollyon);

	g_BossProfileData.Set(iIndex, bBossTeleportAllowed, BossProfileData_TeleportAllowedNormal);
	g_BossProfileData.Set(iIndex, bBossTeleportAllowedEasy, BossProfileData_TeleportAllowedEasy);
	g_BossProfileData.Set(iIndex, bBossTeleportAllowedHard, BossProfileData_TeleportAllowedHard);
	g_BossProfileData.Set(iIndex, bBossTeleportAllowedInsane, BossProfileData_TeleportAllowedInsane);
	g_BossProfileData.Set(iIndex, bBossTeleportAllowedNightmare, BossProfileData_TeleportAllowedNightmare);
	g_BossProfileData.Set(iIndex, bBossTeleportAllowedApollyon, BossProfileData_TeleportAllowedApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportTimeMin, BossProfileData_TeleportTimeMinNormal);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMinEasy, BossProfileData_TeleportTimeMinEasy);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMinHard, BossProfileData_TeleportTimeMinHard);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMinInsane, BossProfileData_TeleportTimeMinInsane);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMinNightmare, BossProfileData_TeleportTimeMinNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMinApollyon, BossProfileData_TeleportTimeMinApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportTimeMax, BossProfileData_TeleportTimeMaxNormal);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMaxEasy, BossProfileData_TeleportTimeMaxEasy);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMaxHard, BossProfileData_TeleportTimeMaxHard);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMaxInsane, BossProfileData_TeleportTimeMaxInsane);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMaxNightmare, BossProfileData_TeleportTimeMaxNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportTimeMaxApollyon, BossProfileData_TeleportTimeMaxApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportRestPeriod, BossProfileData_TeleportRestPeriodNormal);
	g_BossProfileData.Set(iIndex, bossTeleportRestPeriodEasy, BossProfileData_TeleportRestPeriodEasy);
	g_BossProfileData.Set(iIndex, bossTeleportRestPeriodHard, BossProfileData_TeleportRestPeriodHard);
	g_BossProfileData.Set(iIndex, bossTeleportRestPeriodInsane, BossProfileData_TeleportRestPeriodInsane);
	g_BossProfileData.Set(iIndex, bossTeleportRestPeriodNightmare, BossProfileData_TeleportRestPeriodNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportRestPeriodApollyon, BossProfileData_TeleportRestPeriodApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportStressMin, BossProfileData_TeleportStressMinNormal);
	g_BossProfileData.Set(iIndex, bossTeleportStressMinEasy, BossProfileData_TeleportStressMinEasy);
	g_BossProfileData.Set(iIndex, bossTeleportStressMinHard, BossProfileData_TeleportStressMinHard);
	g_BossProfileData.Set(iIndex, bossTeleportStressMinInsane, BossProfileData_TeleportStressMinInsane);
	g_BossProfileData.Set(iIndex, bossTeleportStressMinNightmare, BossProfileData_TeleportStressMinNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportStressMinApollyon, BossProfileData_TeleportStressMinApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportStressMax, BossProfileData_TeleportStressMaxNormal);
	g_BossProfileData.Set(iIndex, bossTeleportStressMaxEasy, BossProfileData_TeleportStressMaxEasy);
	g_BossProfileData.Set(iIndex, bossTeleportStressMaxHard, BossProfileData_TeleportStressMaxHard);
	g_BossProfileData.Set(iIndex, bossTeleportStressMaxInsane, BossProfileData_TeleportStressMaxInsane);
	g_BossProfileData.Set(iIndex, bossTeleportStressMaxNightmare, BossProfileData_TeleportStressMaxNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportStressMaxApollyon, BossProfileData_TeleportStressMaxApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriod, BossProfileData_TeleportPersistencyPeriodNormal);
	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriodEasy, BossProfileData_TeleportPersistencyPeriodEasy);
	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriodHard, BossProfileData_TeleportPersistencyPeriodHard);
	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriodInsane, BossProfileData_TeleportPersistencyPeriodInsane);
	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriodNightmare, BossProfileData_TeleportPersistencyPeriodNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportPersistencyPeriodApollyon, BossProfileData_TeleportPersistencyPeriodApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportRangeMin, BossProfileData_TeleportRangeMinNormal);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMinEasy, BossProfileData_TeleportRangeMinEasy);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMinHard, BossProfileData_TeleportRangeMinHard);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMinInsane, BossProfileData_TeleportRangeMinInsane);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMinNightmare, BossProfileData_TeleportRangeMinNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMinApollyon, BossProfileData_TeleportRangeMinApollyon);

	g_BossProfileData.Set(iIndex, bossTeleportRangeMax, BossProfileData_TeleportRangeMaxNormal);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMaxEasy, BossProfileData_TeleportRangeMaxEasy);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMaxHard, BossProfileData_TeleportRangeMaxHard);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMaxInsane, BossProfileData_TeleportRangeMaxInsane);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMaxNightmare, BossProfileData_TeleportRangeMaxNightmare);
	g_BossProfileData.Set(iIndex, bossTeleportRangeMaxApollyon, BossProfileData_TeleportRangeMaxApollyon);

	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("teleport_target_ignore_chases")), BossProfileData_TeleportIgnoreChases);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("teleport_target_ignore_visibility")), BossProfileData_TeleportIgnoreVis);

	g_BossProfileData.Set(iIndex, bossJumpscareDistance, BossProfileData_JumpscareDistanceNormal);
	g_BossProfileData.Set(iIndex, bossJumpscareDistanceEasy, BossProfileData_JumpscareDistanceEasy);
	g_BossProfileData.Set(iIndex, bossJumpscareDistanceHard, BossProfileData_JumpscareDistanceHard);
	g_BossProfileData.Set(iIndex, bossJumpscareDistanceInsane, BossProfileData_JumpscareDistanceInsane);
	g_BossProfileData.Set(iIndex, bossJumpscareDistanceNightmare, BossProfileData_JumpscareDistanceNightmare);
	g_BossProfileData.Set(iIndex, bossJumpscareDistanceApollyon, BossProfileData_JumpscareDistanceApollyon);

	g_BossProfileData.Set(iIndex, bossJumpscareDuration, BossProfileData_JumpscareDurationNormal);
	g_BossProfileData.Set(iIndex, bossJumpscareDurationEasy, BossProfileData_JumpscareDurationEasy);
	g_BossProfileData.Set(iIndex, bossJumpscareDurationHard, BossProfileData_JumpscareDurationHard);
	g_BossProfileData.Set(iIndex, bossJumpscareDurationInsane, BossProfileData_JumpscareDurationInsane);
	g_BossProfileData.Set(iIndex, bossJumpscareDurationNightmare, BossProfileData_JumpscareDurationNightmare);
	g_BossProfileData.Set(iIndex, bossJumpscareDurationApollyon, BossProfileData_JumpscareDurationApollyon);

	g_BossProfileData.Set(iIndex, bossJumpscareCooldown, BossProfileData_JumpscareCooldownNormal);
	g_BossProfileData.Set(iIndex, bossJumpscareCooldownEasy, BossProfileData_JumpscareCooldownEasy);
	g_BossProfileData.Set(iIndex, bossJumpscareCooldownHard, BossProfileData_JumpscareCooldownHard);
	g_BossProfileData.Set(iIndex, bossJumpscareCooldownInsane, BossProfileData_JumpscareCooldownInsane);
	g_BossProfileData.Set(iIndex, bossJumpscareCooldownNightmare, BossProfileData_JumpscareCooldownNightmare);
	g_BossProfileData.Set(iIndex, bossJumpscareCooldownApollyon, BossProfileData_JumpscareCooldownApollyon);

	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("jumpscare_on_scare")), BossProfileData_JumpscareOnScare);

	g_BossProfileData.Set(iIndex, bossSearchRadius, BossProfileData_SearchRange);
	g_BossProfileData.Set(iIndex, bossSearchRadiusEasy, BossProfileData_SearchRangeEasy);
	g_BossProfileData.Set(iIndex, bossSearchRadiusHard, BossProfileData_SearchRangeHard);
	g_BossProfileData.Set(iIndex, bossSearchRadiusInsane, BossProfileData_SearchRangeInsane);
	g_BossProfileData.Set(iIndex, bossSearchRadiusNightmare, BossProfileData_SearchRangeNightmare);
	g_BossProfileData.Set(iIndex, bossSearchRadiusApollyon, BossProfileData_SearchRangeApollyon);

	g_BossProfileData.Set(iIndex, flTauntAlertRange, BossProfileData_TauntAlertRange);
	g_BossProfileData.Set(iIndex, flTauntAlertRangeEasy, BossProfileData_TauntAlertRangeEasy);
	g_BossProfileData.Set(iIndex, flTauntAlertRangeHard, BossProfileData_TauntAlertRangeHard);
	g_BossProfileData.Set(iIndex, flTauntAlertRangeInsane, BossProfileData_TauntAlertRangeInsane);
	g_BossProfileData.Set(iIndex, flTauntAlertRangeNightmare, BossProfileData_TauntAlertRangeNightmare);
	g_BossProfileData.Set(iIndex, flTauntAlertRangeApollyon, BossProfileData_TauntAlertRangeApollyon);

	g_BossProfileData.Set(iIndex, bossSearchSoundRadius, BossProfileData_SearchSoundRange);
	g_BossProfileData.Set(iIndex, bossSearchSoundRadiusEasy, BossProfileData_SearchSoundRangeEasy);
	g_BossProfileData.Set(iIndex, bossSearchSoundRadiusHard, BossProfileData_SearchSoundRangeHard);
	g_BossProfileData.Set(iIndex, bossSearchSoundRadiusInsane, BossProfileData_SearchSoundRangeInsane);
	g_BossProfileData.Set(iIndex, bossSearchSoundRadiusNightmare, BossProfileData_SearchSoundRangeNightmare);
	g_BossProfileData.Set(iIndex, bossSearchSoundRadiusApollyon, BossProfileData_SearchSoundRangeApollyon);

	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("healthbar")), BossProfileData_UseHealthbar);

	g_BossProfileData.Set(iIndex, proxyDamageVsEnemy, BossProfileData_ProxyDamageVsEnemyNormal);
	g_BossProfileData.Set(iIndex, proxyDamageVsEnemyEasy, BossProfileData_ProxyDamageVsEnemyEasy);
	g_BossProfileData.Set(iIndex, proxyDamageVsEnemyHard, BossProfileData_ProxyDamageVsEnemyHard);
	g_BossProfileData.Set(iIndex, proxyDamageVsEnemyInsane, BossProfileData_ProxyDamageVsEnemyInsane);
	g_BossProfileData.Set(iIndex, proxyDamageVsEnemyNightmare, BossProfileData_ProxyDamageVsEnemyNightmare);
	g_BossProfileData.Set(iIndex, proxyDamageVsEnemyApollyon, BossProfileData_ProxyDamageVsEnemyApollyon);

	g_BossProfileData.Set(iIndex, proxyDamageVsBackstab, BossProfileData_ProxyDamageVsBackstabNormal);
	g_BossProfileData.Set(iIndex, proxyDamageVsBackstabEasy, BossProfileData_ProxyDamageVsBackstabEasy);
	g_BossProfileData.Set(iIndex, proxyDamageVsBackstabHard, BossProfileData_ProxyDamageVsBackstabHard);
	g_BossProfileData.Set(iIndex, proxyDamageVsBackstabInsane, BossProfileData_ProxyDamageVsBackstabInsane);
	g_BossProfileData.Set(iIndex, proxyDamageVsBackstabNightmare, BossProfileData_ProxyDamageVsBackstabNightmare);
	g_BossProfileData.Set(iIndex, proxyDamageVsBackstabApollyon, BossProfileData_ProxyDamageVsBackstabApollyon);

	g_BossProfileData.Set(iIndex, proxyDamageVsSelf, BossProfileData_ProxyDamageVsSelfNormal);
	g_BossProfileData.Set(iIndex, proxyDamageVsSelfEasy, BossProfileData_ProxyDamageVsSelfEasy);
	g_BossProfileData.Set(iIndex, proxyDamageVsSelfHard, BossProfileData_ProxyDamageVsSelfHard);
	g_BossProfileData.Set(iIndex, proxyDamageVsSelfInsane, BossProfileData_ProxyDamageVsSelfInsane);
	g_BossProfileData.Set(iIndex, proxyDamageVsSelfNightmare, BossProfileData_ProxyDamageVsSelfNightmare);
	g_BossProfileData.Set(iIndex, proxyDamageVsSelfApollyon, BossProfileData_ProxyDamageVsSelfApollyon);

	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemy, BossProfileData_ProxyControlGainHitEnemyNormal);
	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemyEasy, BossProfileData_ProxyControlGainHitEnemyEasy);
	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemyHard, BossProfileData_ProxyControlGainHitEnemyHard);
	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemyInsane, BossProfileData_ProxyControlGainHitEnemyInsane);
	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemyNightmare, BossProfileData_ProxyControlGainHitEnemyNightmare);
	g_BossProfileData.Set(iIndex, proxyControlGainHitEnemyApollyon, BossProfileData_ProxyControlGainHitEnemyApollyon);

	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemy, BossProfileData_ProxyControlGainHitByEnemyNormal);
	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemyEasy, BossProfileData_ProxyControlGainHitByEnemyEasy);
	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemyHard, BossProfileData_ProxyControlGainHitByEnemyHard);
	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemyInsane, BossProfileData_ProxyControlGainHitByEnemyInsane);
	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemyNightmare, BossProfileData_ProxyControlGainHitByEnemyNightmare);
	g_BossProfileData.Set(iIndex, proxyControlGainHitByEnemyApollyon, BossProfileData_ProxyControlGainHitByEnemyApollyon);
	
	g_BossProfileData.Set(iIndex, proxyControlDrainRate, BossProfileData_ProxyControlDrainRateNormal);
	g_BossProfileData.Set(iIndex, proxyControlDrainRateEasy, BossProfileData_ProxyControlDrainRateEasy);
	g_BossProfileData.Set(iIndex, proxyControlDrainRateHard, BossProfileData_ProxyControlDrainRateHard);
	g_BossProfileData.Set(iIndex, proxyControlDrainRateInsane, BossProfileData_ProxyControlDrainRateInsane);
	g_BossProfileData.Set(iIndex, proxyControlDrainRateNightmare, BossProfileData_ProxyControlDrainRateNightmare);
	g_BossProfileData.Set(iIndex, proxyControlDrainRateApollyon, BossProfileData_ProxyControlDrainRateApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnChanceMin, BossProfileData_ProxySpawnChanceMinNormal);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMinEasy, BossProfileData_ProxySpawnChanceMinEasy);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMinHard, BossProfileData_ProxySpawnChanceMinHard);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMinInsane, BossProfileData_ProxySpawnChanceMinInsane);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMinNightmare, BossProfileData_ProxySpawnChanceMinNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMinApollyon, BossProfileData_ProxySpawnChanceMinApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnChanceMax, BossProfileData_ProxySpawnChanceMaxNormal);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMaxEasy, BossProfileData_ProxySpawnChanceMaxEasy);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMaxHard, BossProfileData_ProxySpawnChanceMaxHard);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMaxInsane, BossProfileData_ProxySpawnChanceMaxInsane);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMaxNightmare, BossProfileData_ProxySpawnChanceMaxNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnChanceMaxApollyon, BossProfileData_ProxySpawnChanceMaxApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnChanceThreshold, BossProfileData_ProxySpawnChanceThresholdNormal);
	g_BossProfileData.Set(iIndex, proxySpawnChanceThresholdEasy, BossProfileData_ProxySpawnChanceThresholdEasy);
	g_BossProfileData.Set(iIndex, proxySpawnChanceThresholdHard, BossProfileData_ProxySpawnChanceThresholdHard);
	g_BossProfileData.Set(iIndex, proxySpawnChanceThresholdInsane, BossProfileData_ProxySpawnChanceThresholdInsane);
	g_BossProfileData.Set(iIndex, proxySpawnChanceThresholdNightmare, BossProfileData_ProxySpawnChanceThresholdNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnChanceThresholdApollyon, BossProfileData_ProxySpawnChanceThresholdApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnNumMin, BossProfileData_ProxySpawnNumMinNormal);
	g_BossProfileData.Set(iIndex, proxySpawnNumMinEasy, BossProfileData_ProxySpawnNumMinEasy);
	g_BossProfileData.Set(iIndex, proxySpawnNumMinHard, BossProfileData_ProxySpawnNumMinHard);
	g_BossProfileData.Set(iIndex, proxySpawnNumMinInsane, BossProfileData_ProxySpawnNumMinInsane);
	g_BossProfileData.Set(iIndex, proxySpawnNumMinNightmare, BossProfileData_ProxySpawnNumMinNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnNumMinApollyon, BossProfileData_ProxySpawnNumMinApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnNumMax, BossProfileData_ProxySpawnNumMaxNormal);
	g_BossProfileData.Set(iIndex, proxySpawnNumMaxEasy, BossProfileData_ProxySpawnNumMaxEasy);
	g_BossProfileData.Set(iIndex, proxySpawnNumMaxHard, BossProfileData_ProxySpawnNumMaxHard);
	g_BossProfileData.Set(iIndex, proxySpawnNumMaxInsane, BossProfileData_ProxySpawnNumMaxInsane);
	g_BossProfileData.Set(iIndex, proxySpawnNumMaxNightmare, BossProfileData_ProxySpawnNumMaxNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnNumMaxApollyon, BossProfileData_ProxySpawnNumMaxApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnCooldownMin, BossProfileData_ProxySpawnCooldownMinNormal);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMinEasy, BossProfileData_ProxySpawnCooldownMinEasy);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMinHard, BossProfileData_ProxySpawnCooldownMinHard);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMinInsane, BossProfileData_ProxySpawnCooldownMinInsane);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMinNightmare, BossProfileData_ProxySpawnCooldownMinNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMinApollyon, BossProfileData_ProxySpawnCooldownMinApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnCooldownMax, BossProfileData_ProxySpawnCooldownMaxNormal);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMaxEasy, BossProfileData_ProxySpawnCooldownMaxEasy);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMaxHard, BossProfileData_ProxySpawnCooldownMaxHard);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMaxInsane, BossProfileData_ProxySpawnCooldownMaxInsane);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMaxNightmare, BossProfileData_ProxySpawnCooldownMaxNightmare);
	g_BossProfileData.Set(iIndex, proxySpawnCooldownMaxApollyon, BossProfileData_ProxySpawnCooldownMaxApollyon);

	g_BossProfileData.Set(iIndex, proxyMax, BossProfileData_ProxyMaxNormal);
	g_BossProfileData.Set(iIndex, proxyMaxEasy, BossProfileData_ProxyMaxEasy);
	g_BossProfileData.Set(iIndex, proxyMaxHard, BossProfileData_ProxyMaxHard);
	g_BossProfileData.Set(iIndex, proxyMaxInsane, BossProfileData_ProxyMaxInsane);
	g_BossProfileData.Set(iIndex, proxyMaxNightmare, BossProfileData_ProxyMaxNightmare);
	g_BossProfileData.Set(iIndex, proxyMaxApollyon, BossProfileData_ProxyMaxApollyon);

	g_BossProfileData.Set(iIndex, proxyTeleportRangeMin, BossProfileData_ProxyTeleportRangeMinNormal);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMinEasy, BossProfileData_ProxyTeleportRangeMinEasy);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMinHard, BossProfileData_ProxyTeleportRangeMinHard);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMinInsane, BossProfileData_ProxyTeleportRangeMinInsane);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMinNightmare, BossProfileData_ProxyTeleportRangeMinNightmare);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMinApollyon, BossProfileData_ProxyTeleportRangeMinApollyon);

	g_BossProfileData.Set(iIndex, proxyTeleportRangeMax, BossProfileData_ProxyTeleportRangeMaxNormal);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMaxEasy, BossProfileData_ProxyTeleportRangeMaxEasy);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMaxHard, BossProfileData_ProxyTeleportRangeMaxHard);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMaxInsane, BossProfileData_ProxyTeleportRangeMaxInsane);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMaxNightmare, BossProfileData_ProxyTeleportRangeMaxNightmare);
	g_BossProfileData.Set(iIndex, proxyTeleportRangeMaxApollyon, BossProfileData_ProxyTeleportRangeMaxApollyon);
	
	g_BossProfileData.Set(iIndex, proxyHurtChannel, BossProfileData_ProxyHurtChannel);
	g_BossProfileData.Set(iIndex, proxyHurtLevel, BossProfileData_ProxyHurtLevel);
	g_BossProfileData.Set(iIndex, proxyHurtFlags, BossProfileData_ProxyHurtFlags);
	g_BossProfileData.Set(iIndex, proxyHurtVolume, BossProfileData_ProxyHurtVolume);
	g_BossProfileData.Set(iIndex, proxyHurtPitch, BossProfileData_ProxyHurtPitch);

	g_BossProfileData.Set(iIndex, proxyDeathChannel, BossProfileData_ProxyDeathChannel);
	g_BossProfileData.Set(iIndex, proxyDeathLevel, BossProfileData_ProxyDeathLevel);
	g_BossProfileData.Set(iIndex, proxyDeathFlags, BossProfileData_ProxyDeathFlags);
	g_BossProfileData.Set(iIndex, proxyDeathVolume, BossProfileData_ProxyDeathVolume);
	g_BossProfileData.Set(iIndex, proxyDeathPitch, BossProfileData_ProxyDeathPitch);

	g_BossProfileData.Set(iIndex, proxyIdleChannel, BossProfileData_ProxyIdleChannel);
	g_BossProfileData.Set(iIndex, proxyIdleLevel, BossProfileData_ProxyIdleLevel);
	g_BossProfileData.Set(iIndex, proxyIdleFlags, BossProfileData_ProxyIdleFlags);
	g_BossProfileData.Set(iIndex, proxyIdleVolume, BossProfileData_ProxyIdleVolume);
	g_BossProfileData.Set(iIndex, proxyIdlePitch, BossProfileData_ProxyIdlePitch);
	g_BossProfileData.Set(iIndex, proxyIdleCooldownMin, BossProfileData_ProxyIdleCooldownMin);
	g_BossProfileData.Set(iIndex, proxyIdleCooldownMax, BossProfileData_ProxyIdleCooldownMax);

	g_BossProfileData.Set(iIndex, proxySpawnChannel, BossProfileData_ProxySpawnChannel);
	g_BossProfileData.Set(iIndex, proxySpawnLevel, BossProfileData_ProxySpawnLevel);
	g_BossProfileData.Set(iIndex, proxySpawnFlags, BossProfileData_ProxySpawnFlags);
	g_BossProfileData.Set(iIndex, proxySpawnVolume, BossProfileData_ProxySpawnVolume);
	g_BossProfileData.Set(iIndex, proxySpawnPitch, BossProfileData_ProxySpawnPitch);

	g_BossProfileData.Set(iIndex, fakeCopies, BossProfileData_FakeCopyEnabled);

	g_BossProfileData.Set(iIndex, drainCreditsOnKill, BossProfileData_DrainCreditEnabled);
	g_BossProfileData.Set(iIndex, creditDrainAmountEasy, BossProfileData_DrainCreditAmountEasy);
	g_BossProfileData.Set(iIndex, creditDrainAmount, BossProfileData_DrainCreditAmountNormal);
	g_BossProfileData.Set(iIndex, creditDrainAmountHard, BossProfileData_DrainCreditAmountHard);
	g_BossProfileData.Set(iIndex, creditDrainAmountInsane, BossProfileData_DrainCreditAmountInsane);
	g_BossProfileData.Set(iIndex, creditDrainAmountNightmare, BossProfileData_DrainCreditAmountNightmare);
	g_BossProfileData.Set(iIndex, creditDrainAmountApollyon, BossProfileData_DrainCreditAmountApollyon);

	g_BossProfileData.Set(iIndex, proxySpawnEffects, BossProfileData_ProxySpawnEffectEnabled);
	g_BossProfileData.Set(iIndex, proxySpawnEffectZOffset, BossProfileData_ProxySpawnEffectZPosOffset);

	g_BossProfileData.Set(iIndex, proxyWeaponsEnabled, BossProfileData_ProxyWeapons);

	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("proxies_allownormalvoices", 1)), BossProfileData_ProxyAllowNormalVoices);

	g_BossProfileData.Set(iIndex, kv.GetNum("chat_message_upon_death_difficulty_indexes", 123456), BossProfileData_DeathMessageDifficultyIndexes);

	g_BossProfileData.Set(iIndex, bossFOV, BossProfileData_FieldOfView);
	g_BossProfileData.Set(iIndex, bossMaxTurnRate, BossProfileData_TurnRate);

	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("burn_ragdoll_on_kill")), BossProfileData_BurnRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("cloak_ragdoll_on_kill")), BossProfileData_CloakRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("decap_ragdoll_on_kill")), BossProfileData_DecapRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("gib_ragdoll_on_kill")), BossProfileData_GibRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("gold_ragdoll_on_kill")), BossProfileData_GoldRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("ice_ragdoll_on_kill")), BossProfileData_IceRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("electrocute_ragdoll_on_kill")), BossProfileData_ElectrocuteRagdoll);
	g_BossProfileData.Set(iIndex, ashRagdoll, BossProfileData_AshRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("delete_ragdoll_on_kill")), BossProfileData_DeleteRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("push_ragdoll_on_kill")), BossProfileData_PushRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("dissolve_ragdoll_on_kill")), BossProfileData_DissolveRagdoll);
	g_BossProfileData.Set(iIndex, kv.GetNum("dissolve_ragdoll_type"), BossProfileData_DissolveKillType);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("plasma_ragdoll_on_kill")), BossProfileData_PlasmaRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("resize_ragdoll_on_kill")), BossProfileData_ResizeRagdoll);
	g_BossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_head", 1.0), BossProfileData_ResizeRagdollHead);
	g_BossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_hands", 1.0), BossProfileData_ResizeRagdollHands);
	g_BossProfileData.Set(iIndex, kv.GetFloat("resize_ragdoll_torso", 1.0), BossProfileData_ResizeRagdollTorso);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("decap_or_gib_ragdoll_on_kill")), BossProfileData_DecapOrGipRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("silent_kill")), BossProfileData_SilentKill);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("multieffect_ragdoll_on_kill")), BossProfileData_MultieffectRagdoll);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("attack_custom_deathflag_enabled")), BossProfileData_CustomDeathFlag);
	g_BossProfileData.Set(iIndex, kv.GetNum("attack_custom_deathflag"), BossProfileData_CustomDeathFlagType);
	g_BossProfileData.Set(iIndex, view_as<bool>(kv.GetNum("sound_music_outro_enabled")), BossProfileData_OutroMusicEnabled);
	
	char sCOn[PLATFORM_MAX_PATH], sCOff[PLATFORM_MAX_PATH], sJ[PLATFORM_MAX_PATH], sM[PLATFORM_MAX_PATH], sG[PLATFORM_MAX_PATH], sS[PLATFORM_MAX_PATH], sFE[PLATFORM_MAX_PATH], sFS[PLATFORM_MAX_PATH], sFIS[PLATFORM_MAX_PATH], sRE[PLATFORM_MAX_PATH], sRS[PLATFORM_MAX_PATH], sEngineSound[PLATFORM_MAX_PATH], sGrenadeShoot[PLATFORM_MAX_PATH], sSentryrocketShoot[PLATFORM_MAX_PATH], sArrowShoot[PLATFORM_MAX_PATH], sManglerShoot[PLATFORM_MAX_PATH], sBaseballShoot[PLATFORM_MAX_PATH], sSpawnParticleSound[PLATFORM_MAX_PATH], sDespawnParticleSound[PLATFORM_MAX_PATH];
	char sSmiteSound[PLATFORM_MAX_PATH], sRocketModel[PLATFORM_MAX_PATH], sTrapModel[PLATFORM_MAX_PATH], sTrapDeploySound[PLATFORM_MAX_PATH], sTrapMissSound[PLATFORM_MAX_PATH], sTrapHitSound[PLATFORM_MAX_PATH];
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
	kv.GetString("player_smite_sound", sSmiteSound, sizeof(sSmiteSound));
	kv.GetString("rocket_model", sRocketModel, sizeof(sRocketModel), ROCKET_MODEL);
	kv.GetString("trap_model", sTrapModel, sizeof(sTrapModel), TRAP_MODEL);
	kv.GetString("trap_deploy_sound", sTrapDeploySound, sizeof(sTrapDeploySound), TRAP_DEPLOY);
	kv.GetString("trap_miss_sound", sTrapMissSound, sizeof(sTrapMissSound), TRAP_CLOSE);
	kv.GetString("trap_catch_sound", sTrapHitSound, sizeof(sTrapHitSound), TRAP_CLOSE);

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
	TryPrecacheBossProfileSoundPath(sSmiteSound);
	TryPrecacheBossProfileSoundPath(sTrapDeploySound, true);
	TryPrecacheBossProfileSoundPath(sTrapMissSound, true);
	TryPrecacheBossProfileSoundPath(sTrapHitSound, true);
	if (strcmp(sRocketModel, ROCKET_MODEL, true) != 0)
	{
		if (!PrecacheModel(sRocketModel, true))
		{
			LogSF2Message("Rocket model file %s failed to be loaded, likely does not exist. This will crash the server if not fixed.", sRocketModel);
		}
	}
	if (strcmp(sTrapModel, TRAP_MODEL, true) != 0)
	{
		if (!PrecacheModel(sTrapModel, true))
		{
			LogSF2Message("Trap model file %s failed to be loaded, likely does not exist. This will crash the server if not fixed.", sTrapModel);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection", 1)))
	{
		if (GetSelectableBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableBossProfileList().Erase(selectIndex);
		}	
	}
	
	if (view_as<bool>(kv.GetNum("admin_only", 0)))
	{
		if (GetSelectableAdminBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableAdminBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableAdminBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableAdminBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection_boxing", 0)))
	{
		if (GetSelectableBoxingBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBoxingBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBoxingBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableBoxingBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection_renevant", 0)))
	{
		if (GetSelectableRenevantBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossProfileList().Erase(selectIndex);
		}
	}
	
	if (view_as<bool>(kv.GetNum("enable_random_selection_renevant_admin", 0)))
	{
		if (GetSelectableRenevantBossAdminProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossAdminProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossAdminProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossAdminProfileList().Erase(selectIndex);
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
					
					if (FileExists(s4) || FileExists(s4, true))
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
					
					if (!PrecacheModel(s4, true))
					{
						LogSF2Message("Model file %s failed to be precached, likely does not exist. This will crash the server if not fixed.", s4);
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
					if (FileExists(s5) || FileExists(s5, true))
					{
						AddFileToDownloadsTable(s5);
					}
					else
					{
						LogSF2Message("Texture file %s does not exist, please fix this download or remove it from the array.", s5);
					}

					FormatEx(s5, sizeof(s5), "%s.vmt", s4);
					if (FileExists(s5) || FileExists(s5, true))
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
						if (FileExists(s5) || FileExists(s5, true))
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

int GetBossProfileIndexFromName(const char[] profile)
{
	int iReturn = -1;
	g_BossProfileNames.GetValue(profile, iReturn);
	return iReturn;
}

int GetBossProfileUniqueProfileIndex(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_UniqueProfileIndex);
}

int GetBossProfileSkin(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_Skin);
}

int GetBossProfileSkinDifficulty(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_SkinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_SkinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_SkinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_SkinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_SkinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_Skin);
}

int GetBossProfileSkinMax(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_SkinMax);
}

int GetBossProfileBodyGroups(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_Body);
}

int GetBossProfileBodyGroupsDifficulty(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_BodyEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_BodyHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_BodyInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_BodyNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_BodyApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_Body);
}

int GetBossProfileBodyGroupsMax(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_BodyMax);
}

int GetBossProfileRaidHitbox(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_UseRaidHitbox);
}

bool GetBossProfileIgnoreNavPrefer(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_IgnoreNavPrefer);
}

float GetBossProfileSoundMusicLoop(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_SoundMusicLoopNormal);
}

int GetBossProfileMaxCopies(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_CopyEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_CopyHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_CopyInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_CopyNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_CopyApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_CopyNormal);
}

float GetBossProfileModelScale(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ModelScale);
}

float GetBossProfileStepSize(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_StepSize);
}

bool GetBossProfileDiscoModeState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DiscoMode);
}

float GetBossProfileDiscoRadiusMin(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DiscoDistanceMin);
}

float GetBossProfileDiscoRadiusMax(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DiscoDistanceMax);
}

bool GetBossProfileFestiveLightState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FestiveLights);
}

int GetBossProfileFestiveLightBrightness(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FestiveLightBrightness);
}

float GetBossProfileFestiveLightDistance(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FestiveLightDistance);
}

float GetBossProfileFestiveLightRadius(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FestiveLightRadius);
}

int GetBossProfileHealth(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_Health);
}

int GetBossProfileType(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_Type);
}

int GetBossProfileFlags(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_Flags);
}

float GetBossProfileBlinkLookRate(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_BlinkLookRateMultipler);
}

float GetBossProfileBlinkStaticRate(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_BlinkStaticRateMultiplier);
}

bool GetBossProfileDeathCamState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_HasDeathCam);
}

bool GetBossProfileDeathCamScareSound(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DeathCamPlayScareSound);
}

bool GetBossProfilePublicDeathCamState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCam);
}

float GetBossProfilePublicDeathCamSpeed(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCamSpeed);
}

float GetBossProfilePublicDeathCamAcceleration(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCamAcceleration);
}

float GetBossProfilePublicDeathCamDeceleration(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCamDeceleration);
}

float GetBossProfilePublicDeathCamBackwardOffset(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCamBackwardOffset);
}

float GetBossProfilePublicDeathCamDownwardOffset(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_PublicDeathCamDownwardOffset);
}

bool GetBossProfileDeathCamOverlayState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DeathCamOverlay);
}

float GetBossProfileDeathCamOverlayStartTime(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DeathCamOverlayStartTime);
}

float GetBossProfileDeathCamTime(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DeathCamTime);
}

float GetBossProfileSpeed(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedNormal);
}

float GetBossProfileMaxSpeed(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_MaxSpeedNormal);
}

float GetBossProfileAcceleration(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_AccelerationNormal);
}

float GetBossProfileIdleLifetime(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_IdleLifetimeNormal);
}

float GetBossProfileStaticRadius(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRadiusNormal);
}

float GetBossProfileStaticRate(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateNormal);
}

float GetBossProfileStaticRateDecay(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_StaticRateDecayNormal);
}

float GetBossProfileStaticGraceTime(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_StaticGraceTimeNormal);
}

float GetBossProfileSearchRadius(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRangeEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRangeHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRangeInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRangeNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRangeApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_SearchRange);
}

float GetBossProfileHearRadius(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRangeEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRangeHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRangeInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRangeNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRangeApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_SearchSoundRange);
}

bool GetBossProfileTeleportAllowed(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedApollyon);
	}

	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportAllowedNormal);
}

float GetBossProfileTauntAlertRange(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRangeEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRangeHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRangeInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRangeNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRangeApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TauntAlertRange);
}

float GetBossProfileTeleportTimeMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMinNormal);
}

float GetBossProfileTeleportTimeMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportTimeMaxNormal);
}

float GetBossProfileTeleportTargetRestPeriod(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRestPeriodNormal);
}

float GetBossProfileTeleportTargetStressMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMinNormal);
}

float GetBossProfileTeleportTargetStressMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportStressMaxNormal);
}

float GetBossProfileTeleportTargetPersistencyPeriod(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportPersistencyPeriodNormal);
}

float GetBossProfileTeleportRangeMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMinNormal);
}

float GetBossProfileTeleportRangeMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportRangeMaxNormal);
}

bool GetBossProfileTeleportIgnoreChases(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportIgnoreChases);
}

bool GetBossProfileTeleportIgnoreVis(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportIgnoreVis);
}

float GetBossProfileJumpscareDistance(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDistanceNormal);
}

float GetBossProfileJumpscareDuration(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareDurationNormal);
}

float GetBossProfileJumpscareCooldown(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareCooldownNormal);
}

float GetBossProfileProxyDamageVsEnemy(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsEnemyNormal);
}

float GetBossProfileProxyDamageVsBackstab(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsBackstabNormal);
}

float GetBossProfileProxyDamageVsSelf(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDamageVsSelfNormal);
}

int GetBossProfileProxyControlGainHitEnemy(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitEnemyNormal);
}

int GetBossProfileProxyControlGainHitByEnemy(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyEasy);
		case Difficulty_Hard: g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyHard);
		case Difficulty_Insane: g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyInsane);
		case Difficulty_Nightmare: g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyNightmare);
		case Difficulty_Apollyon: g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlGainHitByEnemyNormal);
}

float GetBossProfileProxyControlDrainRate(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyControlDrainRateNormal);
}

float GetBossProfileProxySpawnChanceMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMinNormal);
}

float GetBossProfileProxySpawnChanceMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceMaxNormal);
}

float GetBossProfileProxySpawnChanceThreshold(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChanceThresholdNormal);
}

int GetBossProfileProxySpawnNumberMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMinNormal);
}

int GetBossProfileProxySpawnNumberMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnNumMaxNormal);
}

float GetBossProfileProxySpawnCooldownMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMinNormal);
}

float GetBossProfileProxySpawnCooldownMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnCooldownMaxNormal);
}

float GetBossProfileProxyTeleportRangeMin(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMinNormal);
}

float GetBossProfileProxyTeleportRangeMax(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyTeleportRangeMaxNormal);
}

int GetBossProfileSoundProxyHurtChannel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyHurtChannel);
}

int GetBossProfileSoundProxyHurtLevel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyHurtLevel);
}

int GetBossProfileSoundProxyHurtFlags(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyHurtFlags);
}

float GetBossProfileSoundProxyHurtVolume(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyHurtVolume);
}

int GetBossProfileSoundProxyHurtPitch(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyHurtPitch);
}

int GetBossProfileSoundProxyDeathChannel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDeathChannel);
}

int GetBossProfileSoundProxyDeathLevel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDeathLevel);
}

int GetBossProfileSoundProxyDeathFlags(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDeathFlags);
}

float GetBossProfileSoundProxyDeathVolume(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDeathVolume);
}

int GetBossProfileSoundProxyDeathPitch(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyDeathPitch);
}

int GetBossProfileSoundProxyIdleChannel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleChannel);
}

int GetBossProfileSoundProxyIdleLevel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleLevel);
}

int GetBossProfileSoundProxyIdleFlags(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleFlags);
}

float GetBossProfileSoundProxyIdleVolume(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleVolume);
}

int GetBossProfileSoundProxyIdlePitch(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdlePitch);
}

float GetBossProfileSoundProxyIdleCooldownMin(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleCooldownMin);
}

float GetBossProfileSoundProxyIdleCooldownMax(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyIdleCooldownMax);
}

int GetBossProfileSoundProxySpawnChannel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnChannel);
}

int GetBossProfileSoundProxySpawnLevel(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnLevel);
}

int GetBossProfileSoundProxySpawnFlags(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnFlags);
}

float GetBossProfileSoundProxySpawnVolume(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnVolume);
}

int GetBossProfileSoundProxySpawnPitch(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnPitch);
}

int GetBossProfileMaxProxies(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyMaxNormal);
}

bool GetBossProfileFakeCopies(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FakeCopyEnabled);
}

bool GetBossProfileDrainCreditState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditEnabled);
}

int GetBossProfileDrainCreditAmount(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_DrainCreditAmountNormal);
}

bool GetBossProfileProxySpawnEffectState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnEffectEnabled);
}

float GetBossProfileProxySpawnEffectZOffset(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxySpawnEffectZPosOffset);
}

float GetBossProfileFOV(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_FieldOfView);
}

float GetBossProfileTurnRate(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_TurnRate);
}

void GetBossProfileEyePositionOffset(int profileIndex, float buffer[3])
{
	buffer[0] = g_BossProfileData.Get(profileIndex, BossProfileData_EyePosOffsetX);
	buffer[1] = g_BossProfileData.Get(profileIndex, BossProfileData_EyePosOffsetY);
	buffer[2] = g_BossProfileData.Get(profileIndex, BossProfileData_EyePosOffsetZ);
}

void GetBossProfileEyeAngleOffset(int profileIndex, float buffer[3])
{
	buffer[0] = g_BossProfileData.Get(profileIndex, BossProfileData_EyeAngOffsetX);
	buffer[1] = g_BossProfileData.Get(profileIndex, BossProfileData_EyeAngOffsetY);
	buffer[2] = g_BossProfileData.Get(profileIndex, BossProfileData_EyeAngOffsetZ);
}

float GetBossProfileAngerStart(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_AngerStart);
}

float GetBossProfileAngerAddOnPageGrab(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_AngerAddOnPageGrab);
}

float GetBossProfileAngerPageGrabTimeDiff(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_AngerPageGrabTimeDiffReq);
}

float GetBossProfileInstantKillRadius(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillRadius);
}

float GetBossProfileInstantKillCooldown(int profileIndex, int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownEasy);
		case Difficulty_Hard: return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownHard);
		case Difficulty_Insane: return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownInsane);
		case Difficulty_Nightmare: return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownNightmare);
		case Difficulty_Apollyon: return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownApollyon);
	}
	
	return g_BossProfileData.Get(profileIndex, BossProfileData_InstantKillCooldownNormal);
}

float GetBossProfileScareRadius(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareRadius);
}

float GetBossProfileScareCooldown(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareCooldown);
}

bool GetBossProfileSpeedBoostOnScare(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_SpeedBoostOnScare);
}

bool GetBossProfileJumpscareOnScare(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_JumpscareOnScare);
}

float GetBossProfileScareSpeedBoostDuration(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareSpeedBoostDuration);
}

bool GetBossProfileScareReactionState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareReaction);
}

int GetBossProfileScareReactionType(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareReactionType);
}

bool GetBossProfileScareReplenishState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareReplenishSprint);
}

int GetBossProfileScareReplenishAmount(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ScareReplenishSprintAmount);
}

int GetBossProfileTeleportType(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_TeleportType);
}

bool GetBossProfileCustomOutlinesState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_EnableCustomizableOutlines);
}

int GetBossProfileOutlineColorR(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_OutlineColorR);
}

int GetBossProfileOutlineColorG(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_OutlineColorG);
}

int GetBossProfileOutlineColorB(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_OutlineColorB);
}

int GetBossProfileOutlineTransparency(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_OutlineColorTrans);
}

bool GetBossProfileRainbowOutlineState(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_RainbowOutline);
}

float GetBossProfileRainbowCycleRate(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_RainbowOutlineCycle);
}

bool GetBossProfileProxyWeapons(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyWeapons);
}

bool GetBossProfileProxyAllowNormalVoices(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_ProxyAllowNormalVoices);
}

int GetBossProfileChatDeathMessageDifficultyIndexes(int profileIndex)
{
	return g_BossProfileData.Get(profileIndex, BossProfileData_DeathMessageDifficultyIndexes);
}

bool GetBossProfileHealthbarState(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_UseHealthbar);
}

bool GetBossProfileBurnRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_BurnRagdoll);
}

bool GetBossProfileCloakRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_CloakRagdoll);
}

bool GetBossProfileDecapRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_DecapRagdoll);
}

bool GetBossProfileGibRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_GibRagdoll);
}

bool GetBossProfileGoldRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_GoldRagdoll);
}

bool GetBossProfileIceRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_IceRagdoll);
}

bool GetBossProfileElectrocuteRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_ElectrocuteRagdoll);
}

bool GetBossProfileAshRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_AshRagdoll);
}

bool GetBossProfileDeleteRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_DeleteRagdoll);
}

bool GetBossProfilePushRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_PushRagdoll);
}

bool GetBossProfileDissolveRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_DissolveRagdoll);
}

int GetBossProfileDissolveRagdollType(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_DissolveKillType);
}

bool GetBossProfilePlasmaRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_PlasmaRagdoll);
}

bool GetBossProfileResizeRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_ResizeRagdoll);
}

float GetBossProfileResizeRagdollHead(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_ResizeRagdollHead);
}

float GetBossProfileResizeRagdollHands(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_ResizeRagdollHands);
}

float GetBossProfileResizeRagdollTorso(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_ResizeRagdollTorso);
}

bool GetBossProfileDecapOrGibRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_DecapOrGipRagdoll);
}

bool GetBossProfileSilentKill(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_SilentKill);
}

bool GetBossProfileMultieffectRagdoll(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_MultieffectRagdoll);
}

bool GetBossProfileCustomDeathFlag(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_CustomDeathFlag);
}

int GetBossProfileCustomDeathFlagType(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_CustomDeathFlagType);
}

bool GetBossProfileOutroMusicState(int chaserProfileIndex)
{
	return g_BossProfileData.Get(chaserProfileIndex, BossProfileData_OutroMusicEnabled);
}
