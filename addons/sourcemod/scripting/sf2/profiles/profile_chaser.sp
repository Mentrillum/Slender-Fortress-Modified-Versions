#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#define SF2_CHASER_BOSS_MAX_ATTACKS 32
#define SF2_CHASER_BOSS_MAX_ANIMATIONS 32

StringMap g_hChaserProfileNames;
ArrayList g_hChaserProfileData;

enum
{
	SF2BossAttackType_Invalid = -1,
	SF2BossAttackType_Melee = 0,
	SF2BossAttackType_Ranged = 1,
	SF2BossAttackType_Projectile = 2,
	SF2BossAttackType_ExplosiveDance = 3,
	SF2BossAttackType_LaserBeam = 4,
	SF2BossAttackType_Unused,
	SF2BossAttackType_Custom
};

enum
{
	SF2BossProjectileType_Invalid = -1,
	SF2BossProjectileType_Fireball = 0,
	SF2BossProjectileType_Iceball = 1,
	SF2BossProjectileType_Rocket = 2,
	SF2BossProjectileType_Grenade = 3,
	SF2BossProjectileType_SentryRocket = 4,
	SF2BossProjectileType_Arrow = 5,
	SF2BossProjectileType_Mangler = 6,
	SF2BossProjectileType_Baseball = 7,
	SF2BossProjectileType_Unused,
	SF2BossProjectileType_Custom
};

enum
{
	SF2BossTrapType_Invalid = -1,
	SF2BossTrapType_BearTrap = 0,
	SF2BossTrapType_Unused,
	SF2BossTrapType_Custom
};

enum
{
	ChaserProfileData_WalkSpeedEasy,
	ChaserProfileData_WalkSpeedNormal,
	ChaserProfileData_WalkSpeedHard,
	ChaserProfileData_WalkSpeedInsane,
	ChaserProfileData_WalkSpeedNightmare,
	ChaserProfileData_WalkSpeedApollyon,
	
	ChaserProfileData_MaxWalkSpeedEasy,
	ChaserProfileData_MaxWalkSpeedNormal,
	ChaserProfileData_MaxWalkSpeedHard,
	ChaserProfileData_MaxWalkSpeedInsane,
	ChaserProfileData_MaxWalkSpeedNightmare,
	ChaserProfileData_MaxWalkSpeedApollyon,
	
	ChaserProfileData_WakeRadius,

	ChaserProfileData_DifficultyAffectsAnimations,
	
	ChaserProfileData_Attacks,		// array that contains data about attacks
	
	ChaserProfileData_SearchAlertDuration,
	ChaserProfileData_SearchAlertDurationEasy,
	ChaserProfileData_SearchAlertDurationHard,
	ChaserProfileData_SearchAlertDurationInsane,
	ChaserProfileData_SearchAlertDurationNightmare,
	ChaserProfileData_SearchAlertDurationApollyon,

	ChaserProfileData_SearchAlertGracetime,
	ChaserProfileData_SearchAlertGracetimeEasy,
	ChaserProfileData_SearchAlertGracetimeHard,
	ChaserProfileData_SearchAlertGracetimeInsane,
	ChaserProfileData_SearchAlertGracetimeNightmare,
	ChaserProfileData_SearchAlertGracetimeApollyon,
	
	ChaserProfileData_SearchChaseDuration,
	ChaserProfileData_SearchChaseDurationEasy,
	ChaserProfileData_SearchChaseDurationHard,
	ChaserProfileData_SearchChaseDurationInsane,
	ChaserProfileData_SearchChaseDurationNightmare,
	ChaserProfileData_SearchChaseDurationApollyon,

	ChaserProfileData_SearchWanderRangeMin,
	ChaserProfileData_SearchWanderRangeMinEasy,
	ChaserProfileData_SearchWanderRangeMinHard,
	ChaserProfileData_SearchWanderRangeMinInsane,
	ChaserProfileData_SearchWanderRangeMinNightmare,
	ChaserProfileData_SearchWanderRangeMinApollyon,

	ChaserProfileData_SearchWanderRangeMax,
	ChaserProfileData_SearchWanderRangeMaxEasy,
	ChaserProfileData_SearchWanderRangeMaxHard,
	ChaserProfileData_SearchWanderRangeMaxInsane,
	ChaserProfileData_SearchWanderRangeMaxNightmare,
	ChaserProfileData_SearchWanderRangeMaxApollyon,

	ChaserProfileData_SearchWanderTimeMin,
	ChaserProfileData_SearchWanderTimeMinEasy,
	ChaserProfileData_SearchWanderTimeMinHard,
	ChaserProfileData_SearchWanderTimeMinInsane,
	ChaserProfileData_SearchWanderTimeMinNightmare,
	ChaserProfileData_SearchWanderTimeMinApollyon,

	ChaserProfileData_SearchWanderTimeMax,
	ChaserProfileData_SearchWanderTimeMaxEasy,
	ChaserProfileData_SearchWanderTimeMaxHard,
	ChaserProfileData_SearchWanderTimeMaxInsane,
	ChaserProfileData_SearchWanderTimeMaxNightmare,
	ChaserProfileData_SearchWanderTimeMaxApollyon,

	ChaserProfileData_CanBeStunned,
	ChaserProfileData_StunDuration,
	ChaserProfileData_StunCooldown,
	ChaserProfileData_StunHealth,
	ChaserProfileData_StunHealthPerPlayer,
	ChaserProfileData_CanBeStunnedByFlashlight,
	ChaserProfileData_StunFlashlightDamage,
	ChaserProfileData_DisappearOnStun,
	ChaserProfileData_ItemDropOnStun,
	ChaserProfileData_ItemDropTypeStun,
	ChaserProfileData_ChaseInitialOnStun,
	
	ChaserProfileData_KeyDrop,
	
	ChaserProfileData_MemoryLifeTime,
	
	ChaserProfileData_AwarenessIncreaseRateEasy,
	ChaserProfileData_AwarenessIncreaseRateNormal,
	ChaserProfileData_AwarenessIncreaseRateHard,
	ChaserProfileData_AwarenessIncreaseRateInsane,
	ChaserProfileData_AwarenessIncreaseRateNightmare,
	ChaserProfileData_AwarenessIncreaseRateApollyon,
	
	ChaserProfileData_AwarenessDecreaseRateEasy,
	ChaserProfileData_AwarenessDecreaseRateNormal,
	ChaserProfileData_AwarenessDecreaseRateHard,
	ChaserProfileData_AwarenessDecreaseRateInsane,
	ChaserProfileData_AwarenessDecreaseRateNightmare,
	ChaserProfileData_AwarenessDecreaseRateApollyon,

	ChaserProfileData_AutoChaseEnabled,
	ChaserProfileData_AutoChaseCount,
	ChaserProfileData_AutoChaseCountEasy,
	ChaserProfileData_AutoChaseCountHard,
	ChaserProfileData_AutoChaseCountInsane,
	ChaserProfileData_AutoChaseCountNightmare,
	ChaserProfileData_AutoChaseCountApollyon,
	ChaserProfileData_AutoChaseAdd,
	ChaserProfileData_AutoChaseAddEasy,
	ChaserProfileData_AutoChaseAddHard,
	ChaserProfileData_AutoChaseAddInsane,
	ChaserProfileData_AutoChaseAddNightmare,
	ChaserProfileData_AutoChaseAddApollyon,
	ChaserProfileData_AutoChaseAddFootstep,
	ChaserProfileData_AutoChaseAddFootstepEasy,
	ChaserProfileData_AutoChaseAddFootstepHard,
	ChaserProfileData_AutoChaseAddFootstepInsane,
	ChaserProfileData_AutoChaseAddFootstepNightmare,
	ChaserProfileData_AutoChaseAddFootstepApollyon,
	ChaserProfileData_AutoChaseAddVoice,
	ChaserProfileData_AutoChaseAddVoiceEasy,
	ChaserProfileData_AutoChaseAddVoiceHard,
	ChaserProfileData_AutoChaseAddVoiceInsane,
	ChaserProfileData_AutoChaseAddVoiceNightmare,
	ChaserProfileData_AutoChaseAddVoiceApollyon,
	ChaserProfileData_AutoChaseAddWeapon,
	ChaserProfileData_AutoChaseAddWeaponEasy,
	ChaserProfileData_AutoChaseAddWeaponHard,
	ChaserProfileData_AutoChaseAddWeaponInsane,
	ChaserProfileData_AutoChaseAddWeaponNightmare,
	ChaserProfileData_AutoChaseAddWeaponApollyon,
	ChaserProfileData_AutoChaseSprinters,
	
	ChaserProfileData_ChasesEndlessly,

	ChaserProfileData_EarthquakeFootstepsEnabled,
	ChaserProfileData_EarthquakeFootstepsRadius,
	ChaserProfileData_EarthquakeFootstepsDuration,
	ChaserProfileData_EarthquakeFootstepsCanAirShake,
	ChaserProfileData_EarthquakeFootstepsAmplitude,
	ChaserProfileData_EarthquakeFootstepsFrequency,

	ChaserProfileData_CanCloak,
	ChaserProfileData_CloakOnFlee,
	ChaserProfileData_CloakCooldownEasy,
	ChaserProfileData_CloakCooldownNormal,
	ChaserProfileData_CloakCooldownHard,
	ChaserProfileData_CloakCooldownInsane,
	ChaserProfileData_CloakCooldownNightmare,
	ChaserProfileData_CloakCooldownApollyon,
	
	ChaserProfileData_CloakRangeEasy,
	ChaserProfileData_CloakRangeNormal,
	ChaserProfileData_CloakRangeHard,
	ChaserProfileData_CloakRangeInsane,
	ChaserProfileData_CloakRangeNightmare,
	ChaserProfileData_CloakRangeApollyon,

	ChaserProfileData_CloakDecloakRangeEasy,
	ChaserProfileData_CloakDecloakRangeNormal,
	ChaserProfileData_CloakDecloakRangeHard,
	ChaserProfileData_CloakDecloakRangeInsane,
	ChaserProfileData_CloakDecloakRangeNightmare,
	ChaserProfileData_CloakDecloakRangeApollyon,

	ChaserProfileData_CloakDurationEasy,
	ChaserProfileData_CloakDurationNormal,
	ChaserProfileData_CloakDurationHard,
	ChaserProfileData_CloakDurationInsane,
	ChaserProfileData_CloakDurationNightmare,
	ChaserProfileData_CloakDurationApollyon,

	ChaserProfileData_CloakSpeedMultiplierEasy,
	ChaserProfileData_CloakSpeedMultiplierNormal,
	ChaserProfileData_CloakSpeedMultiplierHard,
	ChaserProfileData_CloakSpeedMultiplierInsane,
	ChaserProfileData_CloakSpeedMultiplierNightmare,
	ChaserProfileData_CloakSpeedMultiplierApollyon,
	
	ChaserProfileData_ProjectileEnable,
	ChaserProfileData_ProjectileCooldownMinEasy,
	ChaserProfileData_ProjectileCooldownMinNormal,
	ChaserProfileData_ProjectileCooldownMinHard,
	ChaserProfileData_ProjectileCooldownMinInsane,
	ChaserProfileData_ProjectileCooldownMinNightmare,
	ChaserProfileData_ProjectileCooldownMinApollyon,
	
	ChaserProfileData_ProjectileCooldownMaxEasy,
	ChaserProfileData_ProjectileCooldownMaxNormal,
	ChaserProfileData_ProjectileCooldownMaxHard,
	ChaserProfileData_ProjectileCooldownMaxInsane,
	ChaserProfileData_ProjectileCooldownMaxNightmare,
	ChaserProfileData_ProjectileCooldownMaxApollyon,
	
	ChaserProfileData_ProjectileSpeedEasy,
	ChaserProfileData_ProjectileSpeedNormal,
	ChaserProfileData_ProjectileSpeedHard,
	ChaserProfileData_ProjectileSpeedInsane,
	ChaserProfileData_ProjectileSpeedNightmare,
	ChaserProfileData_ProjectileSpeedApollyon,
	
	ChaserProfileData_ProjectileDamageEasy,
	ChaserProfileData_ProjectileDamageNormal,
	ChaserProfileData_ProjectileDamageHard,
	ChaserProfileData_ProjectileDamageInsane,
	ChaserProfileData_ProjectileDamageNightmare,
	ChaserProfileData_ProjectileDamageApollyon,
	
	ChaserProfileData_ProjectileRadiusEasy,
	ChaserProfileData_ProjectileRadiusNormal,
	ChaserProfileData_ProjectileRadiusHard,
	ChaserProfileData_ProjectileRadiusInsane,
	ChaserProfileData_ProjectileRadiusNightmare,
	ChaserProfileData_ProjectileRadiusApollyon,

	ChaserProfileData_ProjectileDeviation,
	ChaserProfileData_ProjectileDeviationEasy,
	ChaserProfileData_ProjectileDeviationHard,
	ChaserProfileData_ProjectileDeviationInsane,
	ChaserProfileData_ProjectileDeviationNightmare,
	ChaserProfileData_ProjectileDeviationApollyon,
	
	ChaserProfileData_ProjectileType,
	ChaserProfileData_CriticlaRockets,
	ChaserProfileData_UseShootGesture,
	ChaserProfileData_ProjectileClipEnable,
	ChaserProfileData_ProjectileClipEasy,
	ChaserProfileData_ProjectileClipNormal,
	ChaserProfileData_ProjectileClipHard,
	ChaserProfileData_ProjectileClipInsane,
	ChaserProfileData_ProjectileClipNightmare,
	ChaserProfileData_ProjectileClipApollyon,
	
	ChaserProfileData_ProjectileReloadTimeEasy,
	ChaserProfileData_ProjectileReloadTimeNormal,
	ChaserProfileData_ProjectileReloadTimeHard,
	ChaserProfileData_ProjectileReloadTimeInsane,
	ChaserProfileData_ProjectileReloadTimeNightmare,
	ChaserProfileData_ProjectileReloadTimeApollyon,
	
	ChaserProfileData_UseChargeUpProjectiles,
	ChaserProfileData_ProjectileChargeUpEasy,
	ChaserProfileData_ProjectileChargeUpNormal,
	ChaserProfileData_ProjectileChargeUpHard,
	ChaserProfileData_ProjectileChargeUpInsane,
	ChaserProfileData_ProjectileChargeUpNightmare,
	ChaserProfileData_ProjectileChargeUpApollyon,

	ChaserProfileData_ProjectileCount,
	ChaserProfileData_ProjectileCountEasy,
	ChaserProfileData_ProjectileCountHard,
	ChaserProfileData_ProjectileCountInsane,
	ChaserProfileData_ProjectileCountNightmare,
	ChaserProfileData_ProjectileCountApollyon,
	
	ChaserProfileData_IceballSlowdownDurationEasy,
	ChaserProfileData_IceballSlowdownDurationNormal,
	ChaserProfileData_IceballSlowdownDurationHard,
	ChaserProfileData_IceballSlowdownDurationInsane,
	ChaserProfileData_IceballSlowdownDurationNightmare,
	ChaserProfileData_IceballSlowdownDurationApollyon,
	
	ChaserProfileData_IceballSlowdownPercentEasy,
	ChaserProfileData_IceballSlowdownPercentNormal,
	ChaserProfileData_IceballSlowdownPercentHard,
	ChaserProfileData_IceballSlowdownPercentInsane,
	ChaserProfileData_IceballSlowdownPercentNightmare,
	ChaserProfileData_IceballSlowdownPercentApollyon,
	
	ChaserProfileData_AdvancedDamageEffectsEnabled,
	ChaserProfileData_AdvancedDamageEffectsRandom,
	ChaserProfileData_AdvancedDamageEffectsParticles,
	
	ChaserProfileData_RandomAdvancedIndexes,
	ChaserProfileData_RandomAdvancedDurationEasy,
	ChaserProfileData_RandomAdvancedDurationNormal,
	ChaserProfileData_RandomAdvancedDurationHard,
	ChaserProfileData_RandomAdvancedDurationInsane,
	ChaserProfileData_RandomAdvancedDurationNightmare,
	ChaserProfileData_RandomAdvancedDurationApollyon,
	ChaserProfileData_RandomAdvancedSlowdownEasy,
	ChaserProfileData_RandomAdvancedSlowdownNormal,
	ChaserProfileData_RandomAdvancedSlowdownHard,
	ChaserProfileData_RandomAdvancedSlowdownInsane,
	ChaserProfileData_RandomAdvancedSlowdownNightmare,
	ChaserProfileData_RandomAdvancedSlowdownApollyon,
	ChaserProfileData_RandomAdvancedStunType,
	
	ChaserProfileData_EnableJarateAdvanced,
	ChaserProfileData_JarateAdvancedIndexes,
	ChaserProfileData_JarateAdvancedDurationEasy,
	ChaserProfileData_JarateAdvancedDurationNormal,
	ChaserProfileData_JarateAdvancedDurationHard,
	ChaserProfileData_JarateAdvancedDurationInsane,
	ChaserProfileData_JarateAdvancedDurationNightmare,
	ChaserProfileData_JarateAdvancedDurationApollyon,
	ChaserProfileData_JarateAdvancedBeamParticle,
	
	ChaserProfileData_EnableMilkAdvanced,
	ChaserProfileData_MilkAdvancedIndexes,
	ChaserProfileData_MilkAdvancedDurationEasy,
	ChaserProfileData_MilkAdvancedDurationNormal,
	ChaserProfileData_MilkAdvancedDurationHard,
	ChaserProfileData_MilkAdvancedDurationInsane,
	ChaserProfileData_MilkAdvancedDurationNightmare,
	ChaserProfileData_MilkAdvancedDurationApollyon,
	ChaserProfileData_MilkAdvancedBeamParticle,
	
	ChaserProfileData_EnableGasAdvanced,
	ChaserProfileData_GasAdvancedIndexes,
	ChaserProfileData_GasAdvancedDurationEasy,
	ChaserProfileData_GasAdvancedDurationNormal,
	ChaserProfileData_GasAdvancedDurationHard,
	ChaserProfileData_GasAdvancedDurationInsane,
	ChaserProfileData_GasAdvancedDurationNightmare,
	ChaserProfileData_GasAdvancedDurationApollyon,
	ChaserProfileData_GasAdvancedBeamParticle,
	
	ChaserProfileData_EnableMarkAdvanced,
	ChaserProfileData_MarkAdvancedIndexes,
	ChaserProfileData_MarkAdvancedDurationEasy,
	ChaserProfileData_MarkAdvancedDurationNormal,
	ChaserProfileData_MarkAdvancedDurationHard,
	ChaserProfileData_MarkAdvancedDurationInsane,
	ChaserProfileData_MarkAdvancedDurationNightmare,
	ChaserProfileData_MarkAdvancedDurationApollyon,

	ChaserProfileData_EnableSilentMarkAdvanced,
	ChaserProfileData_SilentMarkAdvancedIndexes,
	ChaserProfileData_SilentMarkAdvancedDurationEasy,
	ChaserProfileData_SilentMarkAdvancedDurationNormal,
	ChaserProfileData_SilentMarkAdvancedDurationHard,
	ChaserProfileData_SilentMarkAdvancedDurationInsane,
	ChaserProfileData_SilentMarkAdvancedDurationNightmare,
	ChaserProfileData_SilentMarkAdvancedDurationApollyon,
	
	ChaserProfileData_EnableIgniteAdvanced,
	ChaserProfileData_IgniteAdvancedIndexes,
	ChaserProfileData_IgniteAdvancedDelayEasy,
	ChaserProfileData_IgniteAdvancedDelayNormal,
	ChaserProfileData_IgniteAdvancedDelayHard,
	ChaserProfileData_IgniteAdvancedDelayInsane,
	ChaserProfileData_IgniteAdvancedDelayNightmare,
	ChaserProfileData_IgniteAdvancedDelayApollyon,
	
	ChaserProfileData_EnableStunAdvanced,
	ChaserProfileData_StunAdvancedIndexes,
	ChaserProfileData_StunAdvancedDurationEasy,
	ChaserProfileData_StunAdvancedDurationNormal,
	ChaserProfileData_StunAdvancedDurationHard,
	ChaserProfileData_StunAdvancedDurationInsane,
	ChaserProfileData_StunAdvancedDurationNightmare,
	ChaserProfileData_StunAdvancedDurationApollyon,
	ChaserProfileData_StunAdvancedSlowdownEasy,
	ChaserProfileData_StunAdvancedSlowdownNormal,
	ChaserProfileData_StunAdvancedSlowdownHard,
	ChaserProfileData_StunAdvancedSlowdownInsane,
	ChaserProfileData_StunAdvancedSlowdownNightmare,
	ChaserProfileData_StunAdvancedSlowdownApollyon,
	ChaserProfileData_StunAdvancedType,
	ChaserProfileData_StunAdvancedBeamParticle,
	
	ChaserProfileData_EnableBleedAdvanced,
	ChaserProfileData_BleedAdvancedIndexes,
	ChaserProfileData_BleedAdvancedDurationEasy,
	ChaserProfileData_BleedAdvancedDurationNormal,
	ChaserProfileData_BleedAdvancedDurationHard,
	ChaserProfileData_BleedAdvancedDurationInsane,
	ChaserProfileData_BleedAdvancedDurationNightmare,
	ChaserProfileData_BleedAdvancedDurationApollyon,
	
	ChaserProfileData_EnableEletricAdvanced,
	ChaserProfileData_EletricAdvancedIndexes,
	ChaserProfileData_EletricAdvancedDurationEasy,
	ChaserProfileData_EletricAdvancedDurationNormal,
	ChaserProfileData_EletricAdvancedDurationHard,
	ChaserProfileData_EletricAdvancedDurationInsane,
	ChaserProfileData_EletricAdvancedDurationNightmare,
	ChaserProfileData_EletricAdvancedDurationApollyon,
	ChaserProfileData_EletricAdvancedSlowdownEasy,
	ChaserProfileData_EletricAdvancedSlowdownNormal,
	ChaserProfileData_EletricAdvancedSlowdownHard,
	ChaserProfileData_EletricAdvancedSlowdownInsane,
	ChaserProfileData_EletricAdvancedSlowdownNightmare,
	ChaserProfileData_EletricAdvancedSlowdownApollyon,
	ChaserProfileData_EletricAdvancedType,
	ChaserProfileData_EletricAdvancedBeamParticle,
	
	ChaserProfileData_EnableSmiteAdvanced,
	ChaserProfileData_SmiteAdvancedIndexes,
	ChaserProfileData_SmiteAdvancedDamage,
	ChaserProfileData_SmiteAdvancedDamageType,
	ChaserProfileData_SmiteColorR,
	ChaserProfileData_SmiteColorG,
	ChaserProfileData_SmiteColorB,
	ChaserProfileData_SmiteTransparency,
	ChaserProfileData_SmiteMessage,

	ChaserProfileData_EnableXenobladeBreakCombo,
	ChaserProfileData_XenobladeBreakDuration,
	ChaserProfileData_XenobladeToppleDuration,
	ChaserProfileData_XenobladeToppleSlowdown,
	ChaserProfileData_XenobladeDazeDuration,
	
	ChaserProfileData_ShockwavesEnable,
	ChaserProfileData_ShockwaveHeightEasy,
	ChaserProfileData_ShockwaveHeightNormal,
	ChaserProfileData_ShockwaveHeightHard,
	ChaserProfileData_ShockwaveHeightInsane,
	ChaserProfileData_ShockwaveHeightNightmare,
	ChaserProfileData_ShockwaveHeightApollyon,
	ChaserProfileData_ShockwaveRangeEasy,
	ChaserProfileData_ShockwaveRangeNormal,
	ChaserProfileData_ShockwaveRangeHard,
	ChaserProfileData_ShockwaveRangeInsane,
	ChaserProfileData_ShockwaveRangeNightmare,
	ChaserProfileData_ShockwaveRangeApollyon,
	ChaserProfileData_ShockwaveDrainEasy,
	ChaserProfileData_ShockwaveDrainNormal,
	ChaserProfileData_ShockwaveDrainHard,
	ChaserProfileData_ShockwaveDrainInsane,
	ChaserProfileData_ShockwaveDrainNightmare,
	ChaserProfileData_ShockwaveDrainApollyon,
	ChaserProfileData_ShockwaveForceEasy,
	ChaserProfileData_ShockwaveForceNormal,
	ChaserProfileData_ShockwaveForceHard,
	ChaserProfileData_ShockwaveForceInsane,
	ChaserProfileData_ShockwaveForceNightmare,
	ChaserProfileData_ShockwaveForceApollyon,
	ChaserProfileData_ShockwaveStunEnabled,
	ChaserProfileData_ShockwaveStunDurationEasy,
	ChaserProfileData_ShockwaveStunDurationNormal,
	ChaserProfileData_ShockwaveStunDurationHard,
	ChaserProfileData_ShockwaveStunDurationInsane,
	ChaserProfileData_ShockwaveStunDurationNightmare,
	ChaserProfileData_ShockwaveStunDurationApollyon,
	ChaserProfileData_ShockwaveStunSlowdownEasy,
	ChaserProfileData_ShockwaveStunSlowdownNormal,
	ChaserProfileData_ShockwaveStunSlowdownHard,
	ChaserProfileData_ShockwaveStunSlowdownInsane,
	ChaserProfileData_ShockwaveStunSlowdownNightmare,
	ChaserProfileData_ShockwaveStunSlowdownApollyon,
	ChaserProfileData_ShockwaveAttackIndexes,
	ChaserProfileData_ShockwaveWidth1,
	ChaserProfileData_ShockwaveWidth2,
	ChaserProfileData_ShockwaveAmplitude,
	
	ChaserProfileData_TrapsEnabled,
	ChaserProfileData_TrapType,
	ChaserProfileData_TrapSpawnCooldownEasy,
	ChaserProfileData_TrapSpawnCooldownNormal,
	ChaserProfileData_TrapSpawnCooldownHard,
	ChaserProfileData_TrapSpawnCooldownInsane,
	ChaserProfileData_TrapSpawnCooldownNightmare,
	ChaserProfileData_TrapSpawnCooldownApollyon,
	
	ChaserProfileData_EnableDamageParticles,
	ChaserProfileData_DamageParticleVolume,
	ChaserProfileData_DamageParticlePitch,
	
	ChaserProfileData_CanSelfHeal,
	ChaserProfileData_HealStartHealthPercentage,
	ChaserProfileData_HealPercentageOne,
	ChaserProfileData_HealPercentageTwo,
	ChaserProfileData_HealPercentageThree,

	ChaserProfileData_SoundCountToAlert,
	ChaserProfileData_BoxingBoss,
	ChaserProfileData_CloakToHeal,
	ChaserProfileData_NormalSoundHook,
	ChaserProfileData_ChaseInitialAnimationUse,
	ChaserProfileData_OldAnimationAI,
	ChaserProfileData_AlertWalkingAnimation,

	ChaserProfileData_MultiAttackSounds,
	ChaserProfileData_MultiHitSounds,
	ChaserProfileData_MultiMissSounds,

	ChaserProfileData_CrawlingEnabled,
	ChaserProfileData_CrawlSpeedMultiplierEasy,
	ChaserProfileData_CrawlSpeedMultiplierNormal,
	ChaserProfileData_CrawlSpeedMultiplierHard,
	ChaserProfileData_CrawlSpeedMultiplierInsane,
	ChaserProfileData_CrawlSpeedMultiplierNightmare,
	ChaserProfileData_CrawlSpeedMultiplierApollyon,

	ChaserProfileData_ChaseOnLook,

	ChaserProfileData_MaxStats
};

enum
{
	ChaserProfileAttackData_Type = 0,
	ChaserProfileAttackData_CanUseAgainstProps,
	ChaserProfileAttackData_Damage,
	ChaserProfileAttackData_DamageEasy,
	ChaserProfileAttackData_DamageHard,
	ChaserProfileAttackData_DamageInsane,
	ChaserProfileAttackData_DamageNightmare,
	ChaserProfileAttackData_DamageApollyon,
	ChaserProfileAttackData_DamageVsProps,
	ChaserProfileAttackData_DamageForce,
	ChaserProfileAttackData_DamageType,
	ChaserProfileAttackData_DamageDelay,
	ChaserProfileAttackData_Range,
	ChaserProfileAttackData_Duration,
	ChaserProfileAttackData_Spread,
	ChaserProfileAttackData_BeginRange,
	ChaserProfileAttackData_BeginFOV,
	ChaserProfileAttackData_Cooldown,
	ChaserProfileAttackData_CooldownEasy,
	ChaserProfileAttackData_CooldownHard,
	ChaserProfileAttackData_CooldownInsane,
	ChaserProfileAttackData_CooldownNightmare,
	ChaserProfileAttackData_CooldownApollyon,
	ChaserProfileAttackData_Disappear,
	ChaserProfileAttackData_Repeat,
	ChaserProfileAttackData_MaxAttackRepeat,
	ChaserProfileAttackData_IgnoreAlwaysLooking,
	ChaserProfileAttackData_WeaponInt,
	ChaserProfileAttackData_WeaponString,
	ChaserProfileAttackData_CanUseWeaponTypes,
	ChaserProfileAttackData_LifeStealEnabled,
	ChaserProfileAttackData_LifeStealDuration,
	ChaserProfileAttackData_ProjectileDamage,
	ChaserProfileAttackData_ProjectileDamageEasy,
	ChaserProfileAttackData_ProjectileDamageHard,
	ChaserProfileAttackData_ProjectileDamageInsane,
	ChaserProfileAttackData_ProjectileDamageNightmare,
	ChaserProfileAttackData_ProjectileDamageApollyon,
	ChaserProfileAttackData_ProjectileSpeed,
	ChaserProfileAttackData_ProjectileSpeedEasy,
	ChaserProfileAttackData_ProjectileSpeedHard,
	ChaserProfileAttackData_ProjectileSpeedInsane,
	ChaserProfileAttackData_ProjectileSpeedNightmare,
	ChaserProfileAttackData_ProjectileSpeedApollyon,
	ChaserProfileAttackData_ProjectileRadius,
	ChaserProfileAttackData_ProjectileRadiusEasy,
	ChaserProfileAttackData_ProjectileRadiusHard,
	ChaserProfileAttackData_ProjectileRadiusInsane,
	ChaserProfileAttackData_ProjectileRadiusNightmare,
	ChaserProfileAttackData_ProjectileRadiusApollyon,
	ChaserProfileAttackData_ProjectileDeviation,
	ChaserProfileAttackData_ProjectileDeviationEasy,
	ChaserProfileAttackData_ProjectileDeviationHard,
	ChaserProfileAttackData_ProjectileDeviationInsane,
	ChaserProfileAttackData_ProjectileDeviationNightmare,
	ChaserProfileAttackData_ProjectileDeviationApollyon,
	ChaserProfileAttackData_ProjectileCount,
	ChaserProfileAttackData_ProjectileCountEasy,
	ChaserProfileAttackData_ProjectileCountHard,
	ChaserProfileAttackData_ProjectileCountInsane,
	ChaserProfileAttackData_ProjectileCountNightmare,
	ChaserProfileAttackData_ProjectileCountApollyon,
	ChaserProfileAttackData_ProjectileCrits,
	ChaserProfileAttackData_ProjectileType,
	ChaserProfileAttackData_BulletCount,
	ChaserProfileAttackData_BulletCountEasy,
	ChaserProfileAttackData_BulletCountHard,
	ChaserProfileAttackData_BulletCountInsane,
	ChaserProfileAttackData_BulletCountNightmare,
	ChaserProfileAttackData_BulletCountApollyon,
	ChaserProfileAttackData_BulletDamage,
	ChaserProfileAttackData_BulletDamageEasy,
	ChaserProfileAttackData_BulletDamageHard,
	ChaserProfileAttackData_BulletDamageInsane,
	ChaserProfileAttackData_BulletDamageNightmare,
	ChaserProfileAttackData_BulletDamageApollyon,
	ChaserProfileAttackData_BulletSpread,
	ChaserProfileAttackData_BulletSpreadEasy,
	ChaserProfileAttackData_BulletSpreadHard,
	ChaserProfileAttackData_BulletSpreadInsane,
	ChaserProfileAttackData_BulletSpreadNightmare,
	ChaserProfileAttackData_BulletSpreadApollyon,
	ChaserProfileAttackData_LaserDamage,
	ChaserProfileAttackData_LaserDamageEasy,
	ChaserProfileAttackData_LaserDamageHard,
	ChaserProfileAttackData_LaserDamageInsane,
	ChaserProfileAttackData_LaserDamageNightmare,
	ChaserProfileAttackData_LaserDamageApollyon,
	ChaserProfileAttackData_LaserSize,
	ChaserProfileAttackData_LaserColorR,
	ChaserProfileAttackData_LaserColorG,
	ChaserProfileAttackData_LaserColorB,
	ChaserProfileAttackData_LaserAttachment,
	ChaserProfileAttackData_LaserDuration,
	ChaserProfileAttackData_LaserNoise,
	ChaserProfileAttackData_PullIn,
	ChaserProfileAttackData_ProjectileIceSlowdownPercent,
	ChaserProfileAttackData_ProjectileIceSlowdownPercentEasy,
	ChaserProfileAttackData_ProjectileIceSlowdownPercentHard,
	ChaserProfileAttackData_ProjectileIceSlowdownPercentInsane,
	ChaserProfileAttackData_ProjectileIceSlowdownPercentNightmare,
	ChaserProfileAttackData_ProjectileIceSlowdownPercentApollyon,
	ChaserProfileAttackData_ProjectileIceSlowdownDuration,
	ChaserProfileAttackData_ProjectileIceSlowdownDurationEasy,
	ChaserProfileAttackData_ProjectileIceSlowdownDurationHard,
	ChaserProfileAttackData_ProjectileIceSlowdownDurationInsane,
	ChaserProfileAttackData_ProjectileIceSlowdownDurationNightmare,
	ChaserProfileAttackData_ProjectileIceSlowdownDurationApollyon,
	ChaserProfileAttackData_CanAttackWhileRunning,
	ChaserProfileAttackData_RunSpeed,
	ChaserProfileAttackData_RunSpeedEasy,
	ChaserProfileAttackData_RunSpeedHard,
	ChaserProfileAttackData_RunSpeedInsane,
	ChaserProfileAttackData_RunSpeedNightmare,
	ChaserProfileAttackData_RunSpeedApollyon,
	ChaserProfileAttackData_RunDuration,
	ChaserProfileAttackData_RunDelay,
	ChaserProfileAttackData_UseOnDifficulty,
	ChaserProfileAttackData_BlockOnDifficulty,
	ChaserProfileAttackData_ExplosiveDanceRadius,
	ChaserProfileAttackData_Gestures,
	ChaserProfileAttackData_DeathCamLowHealth,
	ChaserProfileAttackData_UseOnHealth,
	ChaserProfileAttackData_BlockOnHealth,
	ChaserProfileAttackData_MaxStats
};

enum 
{
	ChaserAnimationType_Idle = 0,
	ChaserAnimationType_IdlePlaybackRate,
	ChaserAnimationType_Walk = 0,
	ChaserAnimationType_WalkPlaybackRate,
	ChaserAnimationType_Run = 0,
	ChaserAnimationType_RunPlaybackRate,
	ChaserAnimationType_Attack = 0,
	ChaserAnimationType_AttackPlaybackRate,
	ChaserAnimationType_Stunned = 0,
	ChaserAnimationType_StunnedPlaybackRate,
	ChaserAnimationType_Death = 0,
	ChaserAnimationType_DeathPlaybackRate,
	ChaserAnimationType_Spawn = 0,
	ChaserAnimationType_SpawnPlaybackRate,
	ChaserAnimationType_Heal = 0,
	ChaserAnimationType_HealPlaybackRate,
	ChaserAnimationType_Deathcam = 0,
	ChaserAnimationType_DeathcamPlaybackRate,
	ChaserAnimationType_CloakStart = 0,
	ChaserAnimationType_CloakStartPlaybackRate,
	ChaserAnimationType_CloakEnd = 0,
	ChaserAnimationType_CloakEndPlaybackRate,
};

enum
{
	ChaserAnimation_IdleAnimations = 0, //Array that contains all the idle animations
	ChaserAnimation_WalkAnimations, //Array that contains all the walk animations
	ChaserAnimation_WalkAlertAnimations, //Array that contains all the alert walk animations
	ChaserAnimation_AttackAnimations, //Array that contains all the attack animations (working on attack index)
	ChaserAnimation_ShootAnimations, //Array that contains all the attack animations after we shoot something
	ChaserAnimation_RunAnimations, //Array that contains all the run animations
	ChaserAnimation_RunAltAnimations, //Array that contains all the alternate run animations
	ChaserAnimation_StunAnimations, //Array that contains all the stun animations
	ChaserAnimation_ChaseInitialAnimations, //Array that contains all the chase initial animations
	ChaserAnimation_RageAnimations, //Array that contains all the rage animations, used for Boxing Maps
	ChaserAnimation_DeathAnimations, //Array that contains all the death animations
	ChaserAnimation_JumpAnimations, //Array that contains all the jump animations
	ChaserAnimation_SpawnAnimations, //Array that contains all the spawn animations
	ChaserAnimation_FleeInitialAnimations, //Array that contains all the flee initial animations
	ChaserAnimation_HealAnimations, //Array that contains all the self healing animations
	ChaserAnimation_DeathcamAnimations, //Array that contains all the deathcam animations
	ChaserAnimation_CloakStartAnimations, //Array that contains all the cloak start animations
	ChaserAnimation_CloakEndAnimations, //Array that contains all the cloak end animations
	ChaserAnimation_CrawlWalkAnimations, //Array that contains all the crawl walking animations
	ChaserANimation_CrawlRunAnimations, //Array that contains all the crawl running animations
	ChaserANimation_CrawlAltRunAnimations, //Array that contains all the crawl running animations
	ChaserAnimation_MaxAnimations
};

methodmap SF2ChaserBossProfile < SF2BaseBossProfile
{
	property int AttackCount
	{
		public get() { return GetChaserProfileAttackCount(this.UniqueProfileIndex); }
	}

	property bool DifficultyAffectsAnimations
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_DifficultyAffectsAnimations); }
	}

	property float WakeRadius
	{
		public get() { return GetChaserProfileWakeRadius(this.UniqueProfileIndex); }
	}

	property int SmiteDamageType
	{
		public get() { return GetChaserProfileSmiteDamageType(this.UniqueProfileIndex); }
	}

	property float SmiteDamage
	{
		public get() { return GetChaserProfileSmiteDamage(this.UniqueProfileIndex); }
	}

	property bool AdvancedDamageEffectsEnabled
	{
		public get() { return GetChaserProfileEnableAdvancedDamageEffects(this.UniqueProfileIndex); }
	}

	property bool AdvancedDamageEffectsRandom
	{
		public get() { return GetChaserProfileEnableAdvancedDamageEffectsRandom(this.UniqueProfileIndex); }
	}

	property bool AttachDamageEffectsParticle
	{
		public get() { return GetChaserProfileEnableAdvancedDamageParticles(this.UniqueProfileIndex); }
	}
	
	property int RandomAttackIndexes
	{
		public get() { return GetChaserProfileRandomAttackIndexes(this.UniqueProfileIndex); }
	}
		
	property int RandomAttackStunType
	{
		public get() { return GetChaserProfileRandomStunType(this.UniqueProfileIndex); }
	}

	property bool JaratePlayerOnHit
	{
		public get() { return GetChaserProfileJarateState(this.UniqueProfileIndex); }
	}

	property int JarateAttackIndexes
	{
		public get() { return GetChaserProfileJarateAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool JaratePlayerBeamParticle
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_JarateAdvancedBeamParticle); }
	}

	property bool MilkPlayerOnHit
	{
		public get() { return GetChaserProfileMilkState(this.UniqueProfileIndex); }
	}

	property int MilkAttackIndexes
	{
		public get() { return GetChaserProfileMilkAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool MilkPlayerBeamParticle
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_MilkAdvancedBeamParticle); }
	}

	property bool GasPlayerOnHit
	{
		public get() { return GetChaserProfileGasState(this.UniqueProfileIndex); }
	}

	property int GasAttackIndexes
	{
		public get() { return GetChaserProfileGasAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool GasPlayerBeamParticle
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_GasAdvancedBeamParticle); }
	}

	property bool MarkPlayerOnHit
	{
		public get() { return GetChaserProfileMarkState(this.UniqueProfileIndex); }
	}

	property int MarkAttackIndexes
	{
		public get() { return GetChaserProfileMarkAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool SilentMarkPlayerOnHit
	{
		public get() { return GetChaserProfileSilentMarkState(this.UniqueProfileIndex); }
	}

	property int SilentMarkAttackIndexes
	{
		public get() { return GetChaserProfileSilentMarkAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool IgnitePlayerOnHit
	{
		public get() { return GetChaserProfileIgniteState(this.UniqueProfileIndex); }
	}

	property int IgniteAttackIndexes
	{
		public get() { return GetChaserProfileIgniteAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool StunPlayerOnHit
	{
		public get() { return GetChaserProfileStunAttackState(this.UniqueProfileIndex); }
	}

	property int StunAttackIndexes
	{
		public get() { return GetChaserProfileStunAttackIndexes(this.UniqueProfileIndex); }
	}

	property int StunAttackType
	{
		public get() { return GetChaserProfileStunDamageType(this.UniqueProfileIndex); }
	}

	property bool StunPlayerBeamParticle
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_StunAdvancedBeamParticle); }
	}

	property bool BleedPlayerOnHit
	{
		public get() { return GetChaserProfileBleedState(this.UniqueProfileIndex); }
	}

	property int BleedAttackIndexes
	{
		public get() { return GetChaserProfileBleedAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool ElectricPlayerOnHit
	{
		public get() { return GetChaserProfileEletricAttackState(this.UniqueProfileIndex); }
	}

	property int ElectricAttackIndexes
	{
		public get() { return GetChaserProfileEletricAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool ElectricPlayerBeamParticle
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EletricAdvancedBeamParticle); }
	}

	property bool SmitePlayerOnHit
	{
		public get() { return GetChaserProfileSmiteState(this.UniqueProfileIndex); }
	}

	property bool SmiteMessage
	{
		public get() { return GetChaserProfileSmiteMessage(this.UniqueProfileIndex); }
	}

	property int SmiteAttackIndexes
	{
		public get() { return GetChaserProfileSmiteAttackIndexes(this.UniqueProfileIndex); }
	}

	property bool XenobladeCombo
	{
		public get() { return GetChaserProfileXenobladeCombo(this.UniqueProfileIndex); }
	}

	property float XenobladeBreakDuration
	{
		public get() { return GetChaserProfileXenobladeBreakDuration(this.UniqueProfileIndex); }
	}

	property float XenobladeToppleDuration
	{
		public get() { return GetChaserProfileXenobladeToppleDuration(this.UniqueProfileIndex); }
	}

	property float XenobladeToppleSlowdown
	{
		public get() { return GetChaserProfileXenobladeToppleSlowdown(this.UniqueProfileIndex); }
	}

	property float XenobladeDazeDuration
	{
		public get() { return GetChaserProfileXenobladeDazeDuration(this.UniqueProfileIndex); }
	}

	property bool CloakEnabled
	{
		public get() { return GetChaserProfileCloakState(this.UniqueProfileIndex); }
	}

	property bool HasKeyDrop
	{
		public get() { return GetChaserProfileKeyDrop(this.UniqueProfileIndex); }
	}

	property bool HasDamageParticles
	{
		public get() { return GetChaserProfileDamageParticleState(this.UniqueProfileIndex); }
	}

	property float DamageParticleVolume
	{
		public get() { return GetChaserProfileDamageParticleVolume(this.UniqueProfileIndex); }
	}

	property int DamageParticlePitch
	{
		public get() { return GetChaserProfileDamageParticlePitch(this.UniqueProfileIndex); }
	}

	property bool StunEnabled
	{
		public get() { return GetChaserProfileStunState(this.UniqueProfileIndex); }
	}

	property float StunDuration
	{
		public get() { return GetChaserProfileStunDuration(this.UniqueProfileIndex); }
	}

	property float StunCooldown
	{
		public get() { return GetChaserProfileStunCooldown(this.UniqueProfileIndex); }
	}

	property bool StunByFlashlightEnabled
	{
		public get() { return GetChaserProfileStunFlashlightState(this.UniqueProfileIndex); }
	}

	property float StunFlashlightDamage
	{
		public get() { return GetChaserProfileStunFlashlightDamage(this.UniqueProfileIndex); }
	}

	property bool ChaseInitialOnStun
	{
		public get() { return GetChaserProfileStunOnChaseInitial(this.UniqueProfileIndex); }
	}

	property float StunHealth
	{
		public get() { return GetChaserProfileStunHealth(this.UniqueProfileIndex); }
	}

	property float StunHealthPerPlayer
	{
		public get() { return GetChaserProfileStunHealthPerPlayer(this.UniqueProfileIndex); }
	}

	property bool HasShockwaves
	{
		public get() { return GetChaserProfileShockwaveState(this.UniqueProfileIndex); }
	}

	property int ShockwaveAttackIndexes
	{
		public get() { return GetChaserProfileShockwaveAttackIndexes(this.UniqueProfileIndex); }
	}

	property float ShockwaveWidth1
	{
		public get() { return GetChaserProfileShockwaveWidth1(this.UniqueProfileIndex); }
	}

	property float ShockwaveWidth2
	{
		public get() { return GetChaserProfileShockwaveWidth2(this.UniqueProfileIndex); }
	}

	property float ShockwaveAmplitude
	{
		public get() { return GetChaserProfileShockwaveAmplitude(this.UniqueProfileIndex); }
	}

	property bool ShockwaveStunEnabled
	{
		public get() { return GetChaserProfileShockwaveStunState(this.UniqueProfileIndex); }
	}

	property bool HasTraps
	{
		public get() { return GetChaserProfileTrapState(this.UniqueProfileIndex); }
	}

	property int TrapType
	{
		public get() { return GetChaserProfileTrapType(this.UniqueProfileIndex); }
	}

	property bool ProjectileEnabled
	{
		public get() { return GetChaserProfileProjectileState(this.UniqueProfileIndex); }
	}

	property bool HasCriticalRockets
	{
		public get() { return GetChaserProfileCriticalRockets(this.UniqueProfileIndex); }
	}

	property bool UseShootGesture
	{
		public get() { return GetChaserProfileGestureShoot(this.UniqueProfileIndex); }
	}

	property bool ProjectileUsesAmmo
	{
		public get() { return GetChaserProfileProjectileAmmoState(this.UniqueProfileIndex); }
	}

	property bool ChargeUpProjectiles
	{
		public get() { return GetChaserProfileChargeUpProjectilesState(this.UniqueProfileIndex); }
	}

	property int ProjectileType
	{
		public get() { return GetChaserProfileProjectileType(this.UniqueProfileIndex); }
	}

	property bool AutoChaseEnabled
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_AutoChaseEnabled); }
	}

	public int AutoChaseThreshold(int difficulty)
	{
		return GetChaserProfileAutoChaseCount(this.UniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddGeneral(int difficulty)
	{
		return GetChaserProfileAutoChaseAddGeneral(this.UniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddFootstep(int difficulty)
	{
		return GetChaserProfileAutoChaseAddFootstep(this.UniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddVoice(int difficulty)
	{
		return GetChaserProfileAutoChaseAddVoice(this.UniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddWeapon(int difficulty)
	{
		return GetChaserProfileAutoChaseAddWeapon(this.UniqueProfileIndex, difficulty);
	}

	property bool AutoChaseSprinters
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_AutoChaseSprinters); }
	}

	property bool EarthquakeFootstepsEnabled
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsEnabled); }
	}

	property float EarthquakeFootstepsAmplitude
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsAmplitude); }
	}

	property float EarthquakeFootstepsFrequency
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsFrequency); }
	}

	property float EarthquakeFootstepsDuration
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsDuration); }
	}

	property float EarthquakeFootstepsRadius
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsRadius); }
	}

	property bool EarthquakeFootstepsAirShake
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsCanAirShake); }
	}

	property bool ChasesEndlessly
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_ChasesEndlessly); }
	}
	
	property bool SelfHealState
	{
		public get() { return GetChaserProfileSelfHealState(this.UniqueProfileIndex); }
	}

	property int SoundCountToAlert
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_SoundCountToAlert); }
	}

	property bool CanDisappearOnStun
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_DisappearOnStun); }
	}

	property bool DropItemOnStun
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_ItemDropOnStun); }
	}

	property int DropItemType
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_ItemDropTypeStun); }
	}

	property bool IsBoxingBoss
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_BoxingBoss); }
	}

	property bool NormalSoundHook
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_NormalSoundHook); }
	}

	property bool CanCloakToHeal
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_CloakToHeal); }
	}

	property bool UseChaseInitialAnimation
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_ChaseInitialAnimationUse); }
	}

	property bool HasOldAnimationAI
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_OldAnimationAI); }
	}

	property bool UseAlertWalkingAnimation
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_AlertWalkingAnimation); }
	}

	property bool MultiAttackSounds
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_MultiAttackSounds); }
	}

	property bool MultiHitSounds
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_MultiHitSounds); }
	}

	property bool MultiMissSounds
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_MultiMissSounds); }
	}

	property float SelfHealStartPercentage
	{
		public get() { return GetChaserProfileSelfHealStartPercentage(this.UniqueProfileIndex); }
	}
	
	property float SelfHealPercentageOne
	{
		public get() { return GetChaserProfileSelfHealPercentageOne(this.UniqueProfileIndex); }
	}
	
	property float SelfHealPercentageTwo
	{
		public get() { return GetChaserProfileSelfHealPercentageTwo(this.UniqueProfileIndex); }
	}
	
	property float SelfHealPercentageThree
	{
		public get() { return GetChaserProfileSelfHealPercentageThree(this.UniqueProfileIndex); }
	}

	public SF2ChaserBossProfile(int profileIndex)
	{
		return view_as<SF2ChaserBossProfile>(profileIndex);
	}

	public float GetWalkSpeed(int difficulty)
	{
		return GetChaserProfileWalkSpeed(this.UniqueProfileIndex, difficulty);
	}

	public float GetMaxWalkSpeed(int difficulty)
	{
		return GetChaserProfileMaxWalkSpeed(this.UniqueProfileIndex, difficulty);
	}

	public float GetAlertStateGraceTime(int difficulty)
	{
		return GetChaserProfileAlertGracetime(this.UniqueProfileIndex, difficulty);
	}

	public float GetAlertStateDuration(int difficulty)
	{
		return GetChaserProfileAlertDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetChaseStateDuration(int difficulty)
	{
		return GetChaserProfileChaseDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetWanderRangeMin(int difficulty)
	{
		return GetChaserProfileWanderRangeMin(this.UniqueProfileIndex, difficulty);
	}

	public float GetWanderRangeMax(int difficulty)
	{
		return GetChaserProfileWanderRangeMax(this.UniqueProfileIndex, difficulty);
	}

	public float GetWanderTimeMin(int difficulty)
	{
		return GetChaserProfileWanderTimeMin(this.UniqueProfileIndex, difficulty);
	}

	public float GetWanderTimeMax(int difficulty)
	{
		return GetChaserProfileWanderTimeMax(this.UniqueProfileIndex, difficulty);
	}

	public float GetAwarenessIncreaseRate(int difficulty)
	{
		return GetChaserProfileAwarenessIncreaseRate(this.UniqueProfileIndex, difficulty);
	}

	public float GetAwarenessDecreaseRate(int difficulty)
	{
		return GetChaserProfileAwarenessDecreaseRate(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileCooldownMin(int difficulty)
	{
		return GetChaserProfileProjectileCooldownMin(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileCooldownMax(int difficulty)
	{
		return GetChaserProfileProjectileCooldownMax(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileSpeed(int difficulty)
	{
		return GetChaserProfileProjectileSpeed(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileDamage(int difficulty)
	{
		return GetChaserProfileProjectileDamage(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileRadius(int difficulty)
	{
		return GetChaserProfileProjectileRadius(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileDeviation(int difficulty)
	{
		return GetChaserProfileProjectileDeviation(this.UniqueProfileIndex, difficulty);
	}

	public int GetProjectileCount(int difficulty)
	{
		return GetChaserProfileProjectileCount(this.UniqueProfileIndex, difficulty);
	}

	public int GetProjectileLoadedAmmo(int difficulty)
	{
		return GetChaserProfileProjectileLoadedAmmo(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileReloadTime(int difficulty)
	{
		return GetChaserProfileProjectileAmmoReloadTime(this.UniqueProfileIndex, difficulty);
	}

	public float GetProjectileChargeUpTime(int difficulty)
	{
		return GetChaserProfileProjectileChargeUpTime(this.UniqueProfileIndex, difficulty);
	}

	public float GetIceballSlowdownDuration(int difficulty)
	{
		return GetChaserProfileIceballSlowdownDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetIceballSlowdownPercent(int difficulty)
	{
		return GetChaserProfileIceballSlowdownPercent(this.UniqueProfileIndex, difficulty);
	}
	
	public float GetRandomDuration(int difficulty)
	{
		return GetChaserProfileRandomEffectDuration(this.UniqueProfileIndex, difficulty);
	}
	
	public float GetRandomSlowdown(int difficulty)
	{
		return GetChaserProfileRandomEffectSlowdown(this.UniqueProfileIndex, difficulty);
	}

	public float GetJarateDuration(int difficulty)
	{
		return GetChaserProfileJaratePlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetMilkDuration(int difficulty)
	{
		return GetChaserProfileMilkPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetGasDuration(int difficulty)
	{
		return GetChaserProfileGasPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetMarkDuration(int difficulty)
	{
		return GetChaserProfileMarkPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetSilentMarkDuration(int difficulty)
	{
		return GetChaserProfileSilentMarkPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetIgniteDelay(int difficulty)
	{
		return GetChaserProfileIgnitePlayerDelay(this.UniqueProfileIndex, difficulty);
	}

	public float GetStunAttackDuration(int difficulty)
	{
		return GetChaserProfileStunPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetStunAttackSlowdown(int difficulty)
	{
		return GetChaserProfileStunPlayerSlowdown(this.UniqueProfileIndex, difficulty);
	}

	public float GetBleedDuration(int difficulty)
	{
		return GetChaserProfileBleedPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetElectricDuration(int difficulty)
	{
		return GetChaserProfileEletricPlayerDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetElectricSlowdown(int difficulty)
	{
		return GetChaserProfileEletricPlayerSlowdown(this.UniqueProfileIndex, difficulty);
	}

	public int GetAttackType(int attackIndex)
	{
		return GetChaserProfileAttackType(this.UniqueProfileIndex, attackIndex);
	}

	public bool ShouldDisappearAfterAttack(int attackIndex)
	{
		return GetChaserProfileAttackDisappear(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackRepeatCount(int attackIndex)
	{
		return GetChaserProfileAttackRepeat(this.UniqueProfileIndex, attackIndex);
	}

	public int GetMaxAttackRepeats(int attackIndex)
	{
		return GetChaserProfileMaxAttackRepeats(this.UniqueProfileIndex, attackIndex);
	}

	public bool GetAttackIgnoreAlwaysLooking(int attackIndex)
	{
		return GetChaserProfileAttackIgnoreAlwaysLooking(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackWeaponTypeInt(int attackIndex)
	{
		return GetChaserProfileAttackWeaponTypeInt(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackDamage(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackDamageVsProps(int attackIndex)
	{
		return GetChaserProfileAttackDamageVsProps(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamageDelay(int attackIndex)
	{
		return GetChaserProfileAttackDamageDelay(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamageForce(int attackIndex)
	{
		return GetChaserProfileAttackDamageForce(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackDamageType(int attackIndex)
	{
		return GetChaserProfileAttackDamageType(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackCooldown(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackCooldown(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackDuration(int attackIndex)
	{
		return GetChaserProfileAttackDuration(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackRange(int attackIndex)
	{
		return GetChaserProfileAttackRange(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackSpread(int attackIndex)
	{
		return GetChaserProfileAttackSpread(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackBeginRange(int attackIndex)
	{
		return GetChaserProfileAttackBeginRange(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackBeginFOV(int attackIndex)
	{
		return GetChaserProfileAttackBeginFOV(this.UniqueProfileIndex, attackIndex);
	}

	public bool CanAttackLifeSteal(int attackIndex)
	{
		return GetChaserProfileAttackLifeStealState(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackLifeStealDuration(int attackIndex)
	{
		return GetChaserProfileAttackLifeStealDuration(this.UniqueProfileIndex, attackIndex);
	}

	public bool CanRunWhileAttacking(int attackIndex)
	{
		return GetChaserProfileAttackRunWhileAttackingState(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackRunSpeed(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackRunSpeed(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackRunDuration(int attackIndex)
	{
		return GetChaserProfileAttackRunDuration(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackRunDelay(int attackIndex)
	{
		return GetChaserProfileAttackRunDelay(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackUseOnDifficulty(int attackIndex)
	{
		return GetChaserProfileAttackUseOnDifficulty(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackBlockOnDifficulty(int attackIndex)
	{
		return GetChaserProfileAttackBlockOnDifficulty(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackExplosiveDanceRadius(int attackIndex)
	{
		return GetChaserProfileAttackExplosiveDanceRadius(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackProjectileDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileDamage(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileSpeed(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileSpeed(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileRadius(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileRadius(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileDeviation(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileDeviation(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public int GetAttackProjectileCount(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileCount(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public bool AreAttackProjectilesCritBoosted(int attackIndex)
	{
		return GetChaserProfileAttackCritProjectiles(this.UniqueProfileIndex, attackIndex);
	}

	public int GetAttackProjectileType(int attackIndex)
	{
		return GetChaserProfileAttackProjectileType(this.UniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackProjectileIceSlowdownPercent(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileIceSlowPercent(this.UniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackProjectileIceSlowdownDuration(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileIceSlowDuration(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public int GetAttackBulletCount(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletCount(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackBulletDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletDamage(this.UniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackBulletSpread(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletSpread(this.UniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackLaserDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackLaserDamage(this.UniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackLaserSize(int attackIndex)
	{
		return GetChaserProfileAttackLaserSize(this.UniqueProfileIndex, attackIndex);
	}

	public void GetAttackLaserColor(int color[3],int attackIndex)
	{
		color[0] = GetChaserProfileAttackLaserColorR(this.UniqueProfileIndex, attackIndex);
		color[1] = GetChaserProfileAttackLaserColorG(this.UniqueProfileIndex, attackIndex);
		color[2] = GetChaserProfileAttackLaserColorB(this.UniqueProfileIndex, attackIndex);
	}

	public bool IsLaserOnAttachment(int attackIndex)
	{
		return GetChaserProfileEnableLaserAttachment(this.UniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackLaserDuration(int attackIndex)
	{
		return GetChaserProfileAttackLaserDuration(this.UniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackLaserNoise(int attackIndex)
	{
		return GetChaserProfileAttackLaserNoise(this.UniqueProfileIndex, attackIndex);
	}
	
	public bool CanAttackPullIn(int attackIndex)
	{
		return GetChaserProfileAttackPullIn(this.UniqueProfileIndex, attackIndex);
	}

	public bool HasAttackGestures(int attackIndex)
	{
		return GetChaserProfileAttackGesturesState(this.UniqueProfileIndex, attackIndex);
	}

	public bool AttackDeathCamOnLowHealth(int attackIndex)
	{
		return GetChaserProfileAttackDeathCamLowHealth(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackUseOnHealth(int attackIndex)
	{
		return GetChaserProfileAttackUseOnHealth(this.UniqueProfileIndex, attackIndex);
	}

	public float GetAttackBlockOnHealth(int attackIndex)
	{
		return GetChaserProfileAttackBlockOnHealth(this.UniqueProfileIndex, attackIndex);
	}

	public void GetSmiteColor(int color[4])
	{
		color[0] = GetChaserProfileSmiteColorR(this.UniqueProfileIndex);
		color[1] = GetChaserProfileSmiteColorG(this.UniqueProfileIndex);
		color[2] = GetChaserProfileSmiteColorB(this.UniqueProfileIndex);
		color[3] = GetChaserProfileSmiteColorTrans(this.UniqueProfileIndex);
	}

	public float GetCloakCooldown(int difficulty)
	{
		return GetChaserProfileCloakCooldown(this.UniqueProfileIndex, difficulty);
	}

	public float GetCloakRange(int difficulty)
	{
		return GetChaserProfileCloakRange(this.UniqueProfileIndex, difficulty);
	}

	public float GetDecloakRange(int difficulty)
	{
		return GetChaserProfileDecloakRange(this.UniqueProfileIndex, difficulty);
	}

	public float GetCloakDuration(int difficulty)
	{
		return GetChaserProfileCloakDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetCloakSpeedMultiplier(int difficulty)
	{
		return GetChaserProfileCloakSpeedMultiplier(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveHeight(int difficulty)
	{
		return GetChaserProfileShockwaveHeight(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveRange(int difficulty)
	{
		return GetChaserProfileShockwaveRange(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveDrain(int difficulty)
	{
		return GetChaserProfileShockwaveDrain(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveForce(int difficulty)
	{
		return GetChaserProfileShockwaveForce(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveStunDuration(int difficulty)
	{
		return GetChaserProfileShockwaveStunDuration(this.UniqueProfileIndex, difficulty);
	}

	public float GetShockwaveStunSlowdown(int difficulty)
	{
		return GetChaserProfileShockwaveStunSlowdown(this.UniqueProfileIndex, difficulty);
	}

	public float GetTrapCooldown(int difficulty)
	{
		return GetChaserProfileTrapSpawnCooldown(this.UniqueProfileIndex, difficulty);
	}

	property bool IsCrawlingEnabled
	{
		public get() { g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_CrawlingEnabled); }
	}

	public float GetCrawlingSpeedMultiplier(int difficulty)
	{
		return GetChaserProfileCrawlSpeedMultiplier(this.UniqueProfileIndex, difficulty);
	}

	property bool CanChaseOnLook
	{
		public get() { return g_hChaserProfileData.Get(this.UniqueProfileIndex, ChaserProfileData_ChaseOnLook); }
	}
}

#include "sf2/profiles/profile_chaser_precache.sp"

void InitializeChaserProfiles()
{
	g_hChaserProfileNames = new StringMap();
	g_hChaserProfileData = new ArrayList(ChaserProfileData_MaxStats);
}

/**
 *	Clears all data and memory currently in use by chaser profiles.
 */
void ClearChaserProfiles()
{
	for (int i = 0; i < g_hChaserProfileData.Length; i++)
	{
		ArrayList hHandle = g_hChaserProfileData.Get(i, ChaserProfileData_Attacks);
		if (hHandle != null)
		{
			delete hHandle;
		}
	}
	
	g_hChaserProfileNames.Clear();
	g_hChaserProfileData.Clear();
}

int GetChaserProfileAutoChaseCount(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCountEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCountHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCountInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCountNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCountApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseCount);
}

int GetChaserProfileAutoChaseAddGeneral(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAdd);
}

int GetChaserProfileAutoChaseAddFootstep(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddFootstep);
}

int GetChaserProfileAutoChaseAddVoice(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddVoice);
}

int GetChaserProfileAutoChaseAddWeapon(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AutoChaseAddWeapon);
}

float GetChaserProfileWalkSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WalkSpeedNormal);
}

float GetChaserProfileMaxWalkSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MaxWalkSpeedNormal);
}

float GetChaserProfileAlertGracetime(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetimeEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetimeHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetimeInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetimeNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetimeApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertGracetime);
}

float GetChaserProfileAlertDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchAlertDuration);
}

float GetChaserProfileChaseDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchChaseDuration);
}

float GetChaserProfileWanderRangeMin(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMinEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMinHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMinInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMinNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMinApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMin);
}

float GetChaserProfileWanderRangeMax(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderRangeMax);
}

float GetChaserProfileWanderTimeMin(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMinEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMinHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMinInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMinNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMinApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMin);
}

float GetChaserProfileWanderTimeMax(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SearchWanderTimeMax);
}

float GetChaserProfileProjectileCooldownMin(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMinNormal);
}

float GetChaserProfileProjectileCooldownMax(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxNormal);
}

float GetChaserProfileIceballSlowdownDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownDurationNormal);
}

float GetChaserProfileIceballSlowdownPercent(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IceballSlowdownPercentNormal);
}

float GetChaserProfileProjectileSpeed(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileSpeedNormal);
}

float GetChaserProfileProjectileDamage(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDamageNormal);
}

float GetChaserProfileProjectileRadius(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileRadiusNormal);
}

float GetChaserProfileProjectileDeviation(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileDeviation);
}

int GetChaserProfileProjectileCount(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCountEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCountHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCountInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCountNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCountApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileCount);
}

float GetChaserProfileRandomEffectDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedDurationNormal);
}

float GetChaserProfileRandomEffectSlowdown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownNormal);
}

float GetChaserProfileJaratePlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedDurationNormal);
}

float GetChaserProfileMilkPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedDurationNormal);
}

float GetChaserProfileGasPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedDurationNormal);
}

float GetChaserProfileMarkPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedDurationNormal);
}

float GetChaserProfileSilentMarkPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationNormal);
}

float GetChaserProfileIgnitePlayerDelay(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayNormal);
}

float GetChaserProfileStunPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedDurationNormal);
}

float GetChaserProfileStunPlayerSlowdown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownNormal);
}

float GetChaserProfileBleedPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedDurationNormal);
}

float GetChaserProfileEletricPlayerDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedDurationNormal);
}

float GetChaserProfileEletricPlayerSlowdown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownNormal);
}
/*
Handle GetChaserProfileAnimationsData(int iChaserProfileIndex)
{
	return view_as<Handle>(g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Animations));
}
*/
float GetChaserProfileWakeRadius(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_WakeRadius);
}

int GetChaserProfileAttackCount(int iChaserProfileIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Length;
}

int GetChaserProfileRandomAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedIndexes);
}

int GetChaserProfileRandomStunType(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_RandomAdvancedStunType);
}

int GetChaserProfileJarateAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_JarateAdvancedIndexes);
}

int GetChaserProfileMilkAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MilkAdvancedIndexes);
}

int GetChaserProfileGasAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_GasAdvancedIndexes);
}

int GetChaserProfileMarkAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_MarkAdvancedIndexes);
}

int GetChaserProfileSilentMarkAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SilentMarkAdvancedIndexes);
}

int GetChaserProfileIgniteAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_IgniteAdvancedIndexes);
}

int GetChaserProfileStunAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedIndexes);
}

int GetChaserProfileStunDamageType(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunAdvancedType);
}

int GetChaserProfileBleedAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_BleedAdvancedIndexes);
}

int GetChaserProfileEletricAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EletricAdvancedIndexes);
}

int GetChaserProfileSmiteAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteAdvancedIndexes);
}

int GetChaserProfileSmiteDamageType(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteAdvancedDamageType);
}

int GetChaserProfileSmiteColorR(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteColorR);
}

int GetChaserProfileSmiteColorG(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteColorG);
}

int GetChaserProfileSmiteColorB(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteColorB);
}

int GetChaserProfileSmiteColorTrans(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteTransparency);
}

float GetChaserProfileSmiteDamage(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteAdvancedDamage);
}

int GetChaserProfileAttackType(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Type);
}

bool GetChaserProfileAttackDisappear(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Disappear);
}

int GetChaserProfileAttackRepeat(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Repeat);
}

int GetChaserProfileMaxAttackRepeats(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_MaxAttackRepeat);
}

bool GetChaserProfileAttackIgnoreAlwaysLooking(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_IgnoreAlwaysLooking);
}

int GetChaserProfileAttackWeaponTypeInt(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_WeaponInt);
}

float GetChaserProfileAttackDamage(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Damage);
}

float GetChaserProfileAttackLifeStealDuration(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LifeStealDuration);
}

float GetChaserProfileAttackProjectileDamage(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamageHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamageApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDamage);
}

float GetChaserProfileAttackProjectileSpeed(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeedEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeedHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeedInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeedNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeedApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileSpeed);
}

float GetChaserProfileAttackProjectileRadius(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadiusEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadiusHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadiusInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadiusNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadiusApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileRadius);
}

float GetChaserProfileAttackProjectileDeviation(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviationEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviationHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviationInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviationNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviationApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileDeviation);
}

int GetChaserProfileAttackProjectileCount(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCountEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCountHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCountInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCountNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCountApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCount);
}

bool GetChaserProfileAttackCritProjectiles(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileCrits);
}

int GetChaserProfileAttackProjectileType(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileType);
}

float GetChaserProfileAttackProjectileIceSlowPercent(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercent);
}

float GetChaserProfileAttackProjectileIceSlowDuration(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDuration);
}

int GetChaserProfileAttackBulletCount(int iChaserProfileIndex,int iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCountEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCountHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCountInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCountNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCountApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletCount);
}

float GetChaserProfileAttackBulletDamage(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamageHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamageApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletDamage);
}

float GetChaserProfileAttackBulletSpread(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpreadEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpreadHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpreadInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpreadNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpreadApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BulletSpread);
}

float GetChaserProfileAttackLaserDamage(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamageHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamageApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDamage);
}

float GetChaserProfileAttackLaserSize(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserSize);
}

int GetChaserProfileAttackLaserColorR(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserColorR);
}

int GetChaserProfileAttackLaserColorG(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserColorG);
}

int GetChaserProfileAttackLaserColorB(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserColorB);
}

bool GetChaserProfileEnableLaserAttachment(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserAttachment);
}

float GetChaserProfileAttackLaserDuration(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserDuration);
}

float GetChaserProfileAttackLaserNoise(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LaserNoise);
}

bool GetChaserProfileAttackPullIn(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_PullIn);
}

float GetChaserProfileAttackDamageVsProps(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageVsProps);
}

float GetChaserProfileAttackDamageForce(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageForce);
}

int GetChaserProfileAttackDamageType(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageType);
}

float GetChaserProfileAttackDamageDelay(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DamageDelay);
}

float GetChaserProfileAttackRange(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Range);
}

float GetChaserProfileAttackDuration(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Duration);
}

float GetChaserProfileAttackSpread(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Spread);
}

float GetChaserProfileAttackBeginRange(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BeginRange);
}

float GetChaserProfileAttackBeginFOV(int iChaserProfileIndex,int  iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BeginFOV);
}

float GetChaserProfileAttackCooldown(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CooldownEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CooldownHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CooldownInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CooldownNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CooldownApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Cooldown);
}

bool GetChaserProfileAttackLifeStealState(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_LifeStealEnabled);
}

bool GetChaserProfileAttackRunWhileAttackingState(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_CanAttackWhileRunning);
}


float GetChaserProfileAttackRunSpeed(int iChaserProfileIndex,int  iAttackIndex,int iDifficulty)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	switch (iDifficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeedEasy);
		case Difficulty_Hard: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeedHard);
		case Difficulty_Insane: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeedInsane);
		case Difficulty_Nightmare: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeedNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeedApollyon);
	}

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunSpeed);
}

float GetChaserProfileAttackRunDuration(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunDuration);
}

float GetChaserProfileAttackRunDelay(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_RunDelay);
}

int GetChaserProfileAttackUseOnDifficulty(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_UseOnDifficulty);
}

int GetChaserProfileAttackBlockOnDifficulty(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BlockOnDifficulty);
}

int GetChaserProfileAttackExplosiveDanceRadius(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_ExplosiveDanceRadius);
}

bool GetChaserProfileAttackGesturesState(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_Gestures);
}

bool GetChaserProfileAttackDeathCamLowHealth(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_DeathCamLowHealth);
}

float GetChaserProfileAttackUseOnHealth(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_UseOnHealth);
}

float GetChaserProfileAttackBlockOnHealth(int iChaserProfileIndex,int iAttackIndex)
{
	ArrayList hAttacks = g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(iAttackIndex, ChaserProfileAttackData_BlockOnHealth);
}

bool GetChaserProfileEnableAdvancedDamageEffects(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsEnabled);
}

bool GetChaserProfileEnableAdvancedDamageEffectsRandom(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsRandom);
}

bool GetChaserProfileEnableAdvancedDamageParticles(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsParticles);
}

bool GetChaserProfileJarateState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableJarateAdvanced);
}

bool GetChaserProfileMilkState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableMilkAdvanced);
}

bool GetChaserProfileGasState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableGasAdvanced);
}

bool GetChaserProfileMarkState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableMarkAdvanced);
}

bool GetChaserProfileSilentMarkState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableSilentMarkAdvanced);
}

bool GetChaserProfileIgniteState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableIgniteAdvanced);
}

bool GetChaserProfileStunAttackState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableStunAdvanced);
}

bool GetChaserProfileBleedState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableBleedAdvanced);
}

bool GetChaserProfileEletricAttackState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableEletricAdvanced);
}

bool GetChaserProfileSmiteState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableSmiteAdvanced);
}

bool GetChaserProfileSmiteMessage(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_SmiteMessage);
}

bool GetChaserProfileXenobladeCombo(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableXenobladeBreakCombo);
}

float GetChaserProfileXenobladeBreakDuration(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_XenobladeBreakDuration);
}

float GetChaserProfileXenobladeToppleDuration(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_XenobladeToppleDuration);
}

float GetChaserProfileXenobladeToppleSlowdown(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_XenobladeToppleSlowdown);
}

float GetChaserProfileXenobladeDazeDuration(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_XenobladeDazeDuration);
}

bool GetChaserProfileCloakState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CanCloak);
}

bool GetChaserProfileProjectileState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileEnable);
}

bool GetChaserProfileCriticalRockets(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CriticlaRockets);
}

bool GetChaserProfileGestureShoot(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_UseShootGesture);
}

bool GetChaserProfileProjectileAmmoState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipEnable);
}

bool GetChaserProfileChargeUpProjectilesState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_UseChargeUpProjectiles);
}

int GetChaserProfileProjectileType(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileType);
}

int GetChaserProfileProjectileLoadedAmmo(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipNightmare);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileClipNormal);
}

float GetChaserProfileProjectileAmmoReloadTime(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileReloadTimeNormal);
}

float GetChaserProfileProjectileChargeUpTime(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ProjectileChargeUpNormal);
}

bool GetChaserProfileDamageParticleState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_EnableDamageParticles);
}

float GetChaserProfileDamageParticleVolume(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_DamageParticleVolume);
}

int GetChaserProfileDamageParticlePitch(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_DamageParticlePitch);
}

bool GetChaserProfileStunState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CanBeStunned);
}

float GetChaserProfileStunDuration(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunDuration);
}

float GetChaserProfileStunCooldown(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunCooldown);
}

bool GetChaserProfileStunFlashlightState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CanBeStunnedByFlashlight);
}

float GetChaserProfileStunFlashlightDamage(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunFlashlightDamage);
}

bool GetChaserProfileStunOnChaseInitial(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ChaseInitialOnStun);
}

float GetChaserProfileStunHealth(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunHealth);
}

float GetChaserProfileStunHealthPerPlayer(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_StunHealthPerPlayer);
}

bool GetChaserProfileKeyDrop(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_KeyDrop);
}

float GetChaserProfileCloakCooldown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakCooldownNormal);
}

float GetChaserProfileCloakRange(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakRangeNormal);
}

float GetChaserProfileDecloakRange(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDecloakRangeNormal);
}

float GetChaserProfileCloakDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakDurationNormal);
}

float GetChaserProfileCloakSpeedMultiplier(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierNormal);
}

bool GetChaserProfileShockwaveState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwavesEnable);
}

float GetChaserProfileShockwaveHeight(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveHeightNormal);
}

float GetChaserProfileShockwaveRange(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveRangeNormal);
}

float GetChaserProfileShockwaveDrain(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveDrainNormal);
}

float GetChaserProfileShockwaveForce(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveForceNormal);
}

bool GetChaserProfileShockwaveStunState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunEnabled);
}

float GetChaserProfileShockwaveStunDuration(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunDurationNormal);
}

float GetChaserProfileShockwaveStunSlowdown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownNormal);
}

int GetChaserProfileShockwaveAttackIndexes(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveAttackIndexes);
}

float GetChaserProfileShockwaveWidth1(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveWidth1);
}

float GetChaserProfileShockwaveWidth2(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveWidth2);
}

float GetChaserProfileShockwaveAmplitude(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_ShockwaveAmplitude);
}

bool GetChaserProfileTrapState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapsEnabled);
}

int GetChaserProfileTrapType(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapType);
}

float GetChaserProfileTrapSpawnCooldown(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_TrapSpawnCooldownNormal);
}

float GetChaserProfileCrawlSpeedMultiplier(int iChaserProfileIndex,int iDifficulty)
{
	switch (iDifficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierNormal);
}

bool GetChaserProfileSelfHealState(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_CanSelfHeal);
}

float GetChaserProfileSelfHealStartPercentage(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_HealStartHealthPercentage);
}

float GetChaserProfileSelfHealPercentageOne(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_HealPercentageOne);
}

float GetChaserProfileSelfHealPercentageTwo(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_HealPercentageTwo);
}

float GetChaserProfileSelfHealPercentageThree(int iChaserProfileIndex)
{
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_HealPercentageThree);
}

stock float GetChaserProfileAwarenessIncreaseRate(int iChaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateNormal);
}

stock float GetChaserProfileAwarenessDecreaseRate(int iChaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateEasy);
		case Difficulty_Hard: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateHard);
		case Difficulty_Insane: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateInsane);
		case Difficulty_Nightmare: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateNightmare);
		case Difficulty_Apollyon: return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateApollyon);
	}
	
	return g_hChaserProfileData.Get(iChaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateNormal);
}

stock int GetProfileAttackNum(const char[] sProfile, const char[] keyValue,int defaultValue=0, const int iAttackIndex)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	char sKey[4];
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", iAttackIndex);
	g_hConfig.JumpToKey(sKey);
	return g_hConfig.GetNum(keyValue, defaultValue);
}

stock float GetProfileAttackFloat(const char[] sProfile, const char[] keyValue,float defaultValue=0.0, const int iAttackIndex)
{
	if (!IsProfileValid(sProfile)) return defaultValue;
	
	char sKey[4];
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", iAttackIndex);
	g_hConfig.JumpToKey(sKey);
	return g_hConfig.GetFloat(keyValue, defaultValue);
}

stock bool GetProfileAttackString(const char[] sProfile, const char[] keyValue, char[] sBuffer, int iLenght, const char[] sDefaultValue = "", const int iAttackIndex)
{
	if (!IsProfileValid(sProfile)) return false;
	
	char sKey[4];
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", iAttackIndex);
	g_hConfig.JumpToKey(sKey);
	g_hConfig.GetString(keyValue, sBuffer, iLenght, sDefaultValue);
	return true;
}

stock bool GetProfileAttackVector(const char[] sProfile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int iAttackIndex)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(sProfile)) return false;
	
	char sKey[4];
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	g_hConfig.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", iAttackIndex);
	g_hConfig.JumpToKey(sKey);
	g_hConfig.GetVector(keyValue, buffer, defaultValue);
	return true;
}