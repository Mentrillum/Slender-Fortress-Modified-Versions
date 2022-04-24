#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#define SF2_CHASER_BOSS_MAX_ATTACKS 32
#define SF2_CHASER_BOSS_MAX_ANIMATIONS 32

StringMap g_ChaserProfileNames;
ArrayList g_ChaserProfileData;

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
		public get() { return GetChaserProfileAttackCount(this.uniqueProfileIndex); }
	}

	property bool DifficultyAffectsAnimations
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_DifficultyAffectsAnimations); }
	}

	property float WakeRadius
	{
		public get() { return GetChaserProfileWakeRadius(this.uniqueProfileIndex); }
	}

	property int SmiteDamageType
	{
		public get() { return GetChaserProfileSmiteDamageType(this.uniqueProfileIndex); }
	}

	property float SmiteDamage
	{
		public get() { return GetChaserProfileSmiteDamage(this.uniqueProfileIndex); }
	}

	property bool AdvancedDamageEffectsEnabled
	{
		public get() { return GetChaserProfileEnableAdvancedDamageEffects(this.uniqueProfileIndex); }
	}

	property bool AdvancedDamageEffectsRandom
	{
		public get() { return GetChaserProfileEnableAdvancedDamageEffectsRandom(this.uniqueProfileIndex); }
	}

	property bool AttachDamageEffectsParticle
	{
		public get() { return GetChaserProfileEnableAdvancedDamageParticles(this.uniqueProfileIndex); }
	}
	
	property int RandomAttackIndexes
	{
		public get() { return GetChaserProfileRandomAttackIndexes(this.uniqueProfileIndex); }
	}
		
	property int RandomAttackStunType
	{
		public get() { return GetChaserProfileRandomStunType(this.uniqueProfileIndex); }
	}

	property bool JaratePlayerOnHit
	{
		public get() { return GetChaserProfileJarateState(this.uniqueProfileIndex); }
	}

	property int JarateAttackIndexes
	{
		public get() { return GetChaserProfileJarateAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool JaratePlayerBeamParticle
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_JarateAdvancedBeamParticle); }
	}

	property bool MilkPlayerOnHit
	{
		public get() { return GetChaserProfileMilkState(this.uniqueProfileIndex); }
	}

	property int MilkAttackIndexes
	{
		public get() { return GetChaserProfileMilkAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool MilkPlayerBeamParticle
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_MilkAdvancedBeamParticle); }
	}

	property bool GasPlayerOnHit
	{
		public get() { return GetChaserProfileGasState(this.uniqueProfileIndex); }
	}

	property int GasAttackIndexes
	{
		public get() { return GetChaserProfileGasAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool GasPlayerBeamParticle
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_GasAdvancedBeamParticle); }
	}

	property bool MarkPlayerOnHit
	{
		public get() { return GetChaserProfileMarkState(this.uniqueProfileIndex); }
	}

	property int MarkAttackIndexes
	{
		public get() { return GetChaserProfileMarkAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool SilentMarkPlayerOnHit
	{
		public get() { return GetChaserProfileSilentMarkState(this.uniqueProfileIndex); }
	}

	property int SilentMarkAttackIndexes
	{
		public get() { return GetChaserProfileSilentMarkAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool IgnitePlayerOnHit
	{
		public get() { return GetChaserProfileIgniteState(this.uniqueProfileIndex); }
	}

	property int IgniteAttackIndexes
	{
		public get() { return GetChaserProfileIgniteAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool StunPlayerOnHit
	{
		public get() { return GetChaserProfileStunAttackState(this.uniqueProfileIndex); }
	}

	property int StunAttackIndexes
	{
		public get() { return GetChaserProfileStunAttackIndexes(this.uniqueProfileIndex); }
	}

	property int StunAttackType
	{
		public get() { return GetChaserProfileStunDamageType(this.uniqueProfileIndex); }
	}

	property bool StunPlayerBeamParticle
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_StunAdvancedBeamParticle); }
	}

	property bool BleedPlayerOnHit
	{
		public get() { return GetChaserProfileBleedState(this.uniqueProfileIndex); }
	}

	property int BleedAttackIndexes
	{
		public get() { return GetChaserProfileBleedAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool ElectricPlayerOnHit
	{
		public get() { return GetChaserProfileEletricAttackState(this.uniqueProfileIndex); }
	}

	property int ElectricAttackIndexes
	{
		public get() { return GetChaserProfileEletricAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool ElectricPlayerBeamParticle
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EletricAdvancedBeamParticle); }
	}

	property bool SmitePlayerOnHit
	{
		public get() { return GetChaserProfileSmiteState(this.uniqueProfileIndex); }
	}

	property bool SmiteMessage
	{
		public get() { return GetChaserProfileSmiteMessage(this.uniqueProfileIndex); }
	}

	property int SmiteAttackIndexes
	{
		public get() { return GetChaserProfileSmiteAttackIndexes(this.uniqueProfileIndex); }
	}

	property bool XenobladeCombo
	{
		public get() { return GetChaserProfileXenobladeCombo(this.uniqueProfileIndex); }
	}

	property float XenobladeBreakDuration
	{
		public get() { return GetChaserProfileXenobladeBreakDuration(this.uniqueProfileIndex); }
	}

	property float XenobladeToppleDuration
	{
		public get() { return GetChaserProfileXenobladeToppleDuration(this.uniqueProfileIndex); }
	}

	property float XenobladeToppleSlowdown
	{
		public get() { return GetChaserProfileXenobladeToppleSlowdown(this.uniqueProfileIndex); }
	}

	property float XenobladeDazeDuration
	{
		public get() { return GetChaserProfileXenobladeDazeDuration(this.uniqueProfileIndex); }
	}

	property bool CloakEnabled
	{
		public get() { return GetChaserProfileCloakState(this.uniqueProfileIndex); }
	}

	property bool HasKeyDrop
	{
		public get() { return GetChaserProfileKeyDrop(this.uniqueProfileIndex); }
	}

	property bool HasDamageParticles
	{
		public get() { return GetChaserProfileDamageParticleState(this.uniqueProfileIndex); }
	}

	property float DamageParticleVolume
	{
		public get() { return GetChaserProfileDamageParticleVolume(this.uniqueProfileIndex); }
	}

	property int DamageParticlePitch
	{
		public get() { return GetChaserProfileDamageParticlePitch(this.uniqueProfileIndex); }
	}

	property bool StunEnabled
	{
		public get() { return GetChaserProfileStunState(this.uniqueProfileIndex); }
	}

	property float StunDuration
	{
		public get() { return GetChaserProfileStunDuration(this.uniqueProfileIndex); }
	}

	property float StunCooldown
	{
		public get() { return GetChaserProfileStunCooldown(this.uniqueProfileIndex); }
	}

	property bool StunByFlashlightEnabled
	{
		public get() { return GetChaserProfileStunFlashlightState(this.uniqueProfileIndex); }
	}

	property float StunFlashlightDamage
	{
		public get() { return GetChaserProfileStunFlashlightDamage(this.uniqueProfileIndex); }
	}

	property bool ChaseInitialOnStun
	{
		public get() { return GetChaserProfileStunOnChaseInitial(this.uniqueProfileIndex); }
	}

	property float StunHealth
	{
		public get() { return GetChaserProfileStunHealth(this.uniqueProfileIndex); }
	}

	property float StunHealthPerPlayer
	{
		public get() { return GetChaserProfileStunHealthPerPlayer(this.uniqueProfileIndex); }
	}

	property bool HasShockwaves
	{
		public get() { return GetChaserProfileShockwaveState(this.uniqueProfileIndex); }
	}

	property int ShockwaveAttackIndexes
	{
		public get() { return GetChaserProfileShockwaveAttackIndexes(this.uniqueProfileIndex); }
	}

	property float ShockwaveWidth1
	{
		public get() { return GetChaserProfileShockwaveWidth1(this.uniqueProfileIndex); }
	}

	property float ShockwaveWidth2
	{
		public get() { return GetChaserProfileShockwaveWidth2(this.uniqueProfileIndex); }
	}

	property float ShockwaveAmplitude
	{
		public get() { return GetChaserProfileShockwaveAmplitude(this.uniqueProfileIndex); }
	}

	property bool ShockwaveStunEnabled
	{
		public get() { return GetChaserProfileShockwaveStunState(this.uniqueProfileIndex); }
	}

	property bool HasTraps
	{
		public get() { return GetChaserProfileTrapState(this.uniqueProfileIndex); }
	}

	property int TrapType
	{
		public get() { return GetChaserProfileTrapType(this.uniqueProfileIndex); }
	}

	property bool ProjectileEnabled
	{
		public get() { return GetChaserProfileProjectileState(this.uniqueProfileIndex); }
	}

	property bool HasCriticalRockets
	{
		public get() { return GetChaserProfileCriticalRockets(this.uniqueProfileIndex); }
	}

	property bool UseShootGesture
	{
		public get() { return GetChaserProfileGestureShoot(this.uniqueProfileIndex); }
	}

	property bool ProjectileUsesAmmo
	{
		public get() { return GetChaserProfileProjectileAmmoState(this.uniqueProfileIndex); }
	}

	property bool ChargeUpProjectiles
	{
		public get() { return GetChaserProfileChargeUpProjectilesState(this.uniqueProfileIndex); }
	}

	property int ProjectileType
	{
		public get() { return GetChaserProfileProjectileType(this.uniqueProfileIndex); }
	}

	property bool AutoChaseEnabled
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_AutoChaseEnabled); }
	}

	public int AutoChaseThreshold(int difficulty)
	{
		return GetChaserProfileAutoChaseCount(this.uniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddGeneral(int difficulty)
	{
		return GetChaserProfileAutoChaseAddGeneral(this.uniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddFootstep(int difficulty)
	{
		return GetChaserProfileAutoChaseAddFootstep(this.uniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddVoice(int difficulty)
	{
		return GetChaserProfileAutoChaseAddVoice(this.uniqueProfileIndex, difficulty);
	}

	public int AutoChaseAddWeapon(int difficulty)
	{
		return GetChaserProfileAutoChaseAddWeapon(this.uniqueProfileIndex, difficulty);
	}

	property bool AutoChaseSprinters
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_AutoChaseSprinters); }
	}

	property bool EarthquakeFootstepsEnabled
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsEnabled); }
	}

	property float EarthquakeFootstepsAmplitude
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsAmplitude); }
	}

	property float EarthquakeFootstepsFrequency
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsFrequency); }
	}

	property float EarthquakeFootstepsDuration
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsDuration); }
	}

	property float EarthquakeFootstepsRadius
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsRadius); }
	}

	property bool EarthquakeFootstepsAirShake
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_EarthquakeFootstepsCanAirShake); }
	}

	property bool ChasesEndlessly
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_ChasesEndlessly); }
	}
	
	property bool SelfHealState
	{
		public get() { return GetChaserProfileSelfHealState(this.uniqueProfileIndex); }
	}

	property int SoundCountToAlert
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_SoundCountToAlert); }
	}

	property bool CanDisappearOnStun
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_DisappearOnStun); }
	}

	property bool DropItemOnStun
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_ItemDropOnStun); }
	}

	property int DropItemType
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_ItemDropTypeStun); }
	}

	property bool IsBoxingBoss
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_BoxingBoss); }
	}

	property bool NormalSoundHook
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_NormalSoundHook); }
	}

	property bool CanCloakToHeal
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_CloakToHeal); }
	}

	property bool UseChaseInitialAnimation
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_ChaseInitialAnimationUse); }
	}

	property bool HasOldAnimationAI
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_OldAnimationAI); }
	}

	property bool UseAlertWalkingAnimation
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_AlertWalkingAnimation); }
	}

	property bool MultiAttackSounds
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_MultiAttackSounds); }
	}

	property bool MultiHitSounds
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_MultiHitSounds); }
	}

	property bool MultiMissSounds
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_MultiMissSounds); }
	}

	property float SelfHealStartPercentage
	{
		public get() { return GetChaserProfileSelfHealStartPercentage(this.uniqueProfileIndex); }
	}
	
	property float SelfHealPercentageOne
	{
		public get() { return GetChaserProfileSelfHealPercentageOne(this.uniqueProfileIndex); }
	}
	
	property float SelfHealPercentageTwo
	{
		public get() { return GetChaserProfileSelfHealPercentageTwo(this.uniqueProfileIndex); }
	}
	
	property float SelfHealPercentageThree
	{
		public get() { return GetChaserProfileSelfHealPercentageThree(this.uniqueProfileIndex); }
	}

	public SF2ChaserBossProfile(int profileIndex)
	{
		return view_as<SF2ChaserBossProfile>(profileIndex);
	}

	public float GetWalkSpeed(int difficulty)
	{
		return GetChaserProfileWalkSpeed(this.uniqueProfileIndex, difficulty);
	}

	public float GetMaxWalkSpeed(int difficulty)
	{
		return GetChaserProfileMaxWalkSpeed(this.uniqueProfileIndex, difficulty);
	}

	public float GetAlertStateGraceTime(int difficulty)
	{
		return GetChaserProfileAlertGracetime(this.uniqueProfileIndex, difficulty);
	}

	public float GetAlertStateDuration(int difficulty)
	{
		return GetChaserProfileAlertDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetChaseStateDuration(int difficulty)
	{
		return GetChaserProfileChaseDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetWanderRangeMin(int difficulty)
	{
		return GetChaserProfileWanderRangeMin(this.uniqueProfileIndex, difficulty);
	}

	public float GetWanderRangeMax(int difficulty)
	{
		return GetChaserProfileWanderRangeMax(this.uniqueProfileIndex, difficulty);
	}

	public float GetWanderTimeMin(int difficulty)
	{
		return GetChaserProfileWanderTimeMin(this.uniqueProfileIndex, difficulty);
	}

	public float GetWanderTimeMax(int difficulty)
	{
		return GetChaserProfileWanderTimeMax(this.uniqueProfileIndex, difficulty);
	}

	public float GetAwarenessIncreaseRate(int difficulty)
	{
		return GetChaserProfileAwarenessIncreaseRate(this.uniqueProfileIndex, difficulty);
	}

	public float GetAwarenessDecreaseRate(int difficulty)
	{
		return GetChaserProfileAwarenessDecreaseRate(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileCooldownMin(int difficulty)
	{
		return GetChaserProfileProjectileCooldownMin(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileCooldownMax(int difficulty)
	{
		return GetChaserProfileProjectileCooldownMax(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileSpeed(int difficulty)
	{
		return GetChaserProfileProjectileSpeed(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileDamage(int difficulty)
	{
		return GetChaserProfileProjectileDamage(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileRadius(int difficulty)
	{
		return GetChaserProfileProjectileRadius(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileDeviation(int difficulty)
	{
		return GetChaserProfileProjectileDeviation(this.uniqueProfileIndex, difficulty);
	}

	public int GetProjectileCount(int difficulty)
	{
		return GetChaserProfileProjectileCount(this.uniqueProfileIndex, difficulty);
	}

	public int GetProjectileLoadedAmmo(int difficulty)
	{
		return GetChaserProfileProjectileLoadedAmmo(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileReloadTime(int difficulty)
	{
		return GetChaserProfileProjectileAmmoReloadTime(this.uniqueProfileIndex, difficulty);
	}

	public float GetProjectileChargeUpTime(int difficulty)
	{
		return GetChaserProfileProjectileChargeUpTime(this.uniqueProfileIndex, difficulty);
	}

	public float GetIceballSlowdownDuration(int difficulty)
	{
		return GetChaserProfileIceballSlowdownDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetIceballSlowdownPercent(int difficulty)
	{
		return GetChaserProfileIceballSlowdownPercent(this.uniqueProfileIndex, difficulty);
	}
	
	public float GetRandomDuration(int difficulty)
	{
		return GetChaserProfileRandomEffectDuration(this.uniqueProfileIndex, difficulty);
	}
	
	public float GetRandomSlowdown(int difficulty)
	{
		return GetChaserProfileRandomEffectSlowdown(this.uniqueProfileIndex, difficulty);
	}

	public float GetJarateDuration(int difficulty)
	{
		return GetChaserProfileJaratePlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetMilkDuration(int difficulty)
	{
		return GetChaserProfileMilkPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetGasDuration(int difficulty)
	{
		return GetChaserProfileGasPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetMarkDuration(int difficulty)
	{
		return GetChaserProfileMarkPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetSilentMarkDuration(int difficulty)
	{
		return GetChaserProfileSilentMarkPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetIgniteDelay(int difficulty)
	{
		return GetChaserProfileIgnitePlayerDelay(this.uniqueProfileIndex, difficulty);
	}

	public float GetStunAttackDuration(int difficulty)
	{
		return GetChaserProfileStunPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetStunAttackSlowdown(int difficulty)
	{
		return GetChaserProfileStunPlayerSlowdown(this.uniqueProfileIndex, difficulty);
	}

	public float GetBleedDuration(int difficulty)
	{
		return GetChaserProfileBleedPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetElectricDuration(int difficulty)
	{
		return GetChaserProfileEletricPlayerDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetElectricSlowdown(int difficulty)
	{
		return GetChaserProfileEletricPlayerSlowdown(this.uniqueProfileIndex, difficulty);
	}

	public int GetAttackType(int attackIndex)
	{
		return GetChaserProfileAttackType(this.uniqueProfileIndex, attackIndex);
	}

	public bool ShouldDisappearAfterAttack(int attackIndex)
	{
		return GetChaserProfileAttackDisappear(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackRepeatCount(int attackIndex)
	{
		return GetChaserProfileAttackRepeat(this.uniqueProfileIndex, attackIndex);
	}

	public int GetMaxAttackRepeats(int attackIndex)
	{
		return GetChaserProfileMaxAttackRepeats(this.uniqueProfileIndex, attackIndex);
	}

	public bool GetAttackIgnoreAlwaysLooking(int attackIndex)
	{
		return GetChaserProfileAttackIgnoreAlwaysLooking(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackWeaponTypeInt(int attackIndex)
	{
		return GetChaserProfileAttackWeaponTypeInt(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackDamage(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackDamageVsProps(int attackIndex)
	{
		return GetChaserProfileAttackDamageVsProps(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamageDelay(int attackIndex)
	{
		return GetChaserProfileAttackDamageDelay(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackDamageForce(int attackIndex)
	{
		return GetChaserProfileAttackDamageForce(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackDamageType(int attackIndex)
	{
		return GetChaserProfileAttackDamageType(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackCooldown(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackCooldown(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackDuration(int attackIndex)
	{
		return GetChaserProfileAttackDuration(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackRange(int attackIndex)
	{
		return GetChaserProfileAttackRange(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackSpread(int attackIndex)
	{
		return GetChaserProfileAttackSpread(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackBeginRange(int attackIndex)
	{
		return GetChaserProfileAttackBeginRange(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackBeginFOV(int attackIndex)
	{
		return GetChaserProfileAttackBeginFOV(this.uniqueProfileIndex, attackIndex);
	}

	public bool CanAttackLifeSteal(int attackIndex)
	{
		return GetChaserProfileAttackLifeStealState(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackLifeStealDuration(int attackIndex)
	{
		return GetChaserProfileAttackLifeStealDuration(this.uniqueProfileIndex, attackIndex);
	}

	public bool CanRunWhileAttacking(int attackIndex)
	{
		return GetChaserProfileAttackRunWhileAttackingState(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackRunSpeed(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackRunSpeed(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackRunDuration(int attackIndex)
	{
		return GetChaserProfileAttackRunDuration(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackRunDelay(int attackIndex)
	{
		return GetChaserProfileAttackRunDelay(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackUseOnDifficulty(int attackIndex)
	{
		return GetChaserProfileAttackUseOnDifficulty(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackBlockOnDifficulty(int attackIndex)
	{
		return GetChaserProfileAttackBlockOnDifficulty(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackExplosiveDanceRadius(int attackIndex)
	{
		return GetChaserProfileAttackExplosiveDanceRadius(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackProjectileDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileDamage(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileSpeed(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileSpeed(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileRadius(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileRadius(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackProjectileDeviation(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileDeviation(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public int GetAttackProjectileCount(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileCount(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public bool AreAttackProjectilesCritBoosted(int attackIndex)
	{
		return GetChaserProfileAttackCritProjectiles(this.uniqueProfileIndex, attackIndex);
	}

	public int GetAttackProjectileType(int attackIndex)
	{
		return GetChaserProfileAttackProjectileType(this.uniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackProjectileIceSlowdownPercent(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileIceSlowPercent(this.uniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackProjectileIceSlowdownDuration(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackProjectileIceSlowDuration(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public int GetAttackBulletCount(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletCount(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackBulletDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletDamage(this.uniqueProfileIndex, attackIndex, difficulty);
	}

	public float GetAttackBulletSpread(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackBulletSpread(this.uniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackLaserDamage(int attackIndex, int difficulty)
	{
		return GetChaserProfileAttackLaserDamage(this.uniqueProfileIndex, attackIndex, difficulty);
	}
	
	public float GetAttackLaserSize(int attackIndex)
	{
		return GetChaserProfileAttackLaserSize(this.uniqueProfileIndex, attackIndex);
	}

	public void GetAttackLaserColor(int color[3],int attackIndex)
	{
		color[0] = GetChaserProfileAttackLaserColorR(this.uniqueProfileIndex, attackIndex);
		color[1] = GetChaserProfileAttackLaserColorG(this.uniqueProfileIndex, attackIndex);
		color[2] = GetChaserProfileAttackLaserColorB(this.uniqueProfileIndex, attackIndex);
	}

	public bool IsLaserOnAttachment(int attackIndex)
	{
		return GetChaserProfileEnableLaserAttachment(this.uniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackLaserDuration(int attackIndex)
	{
		return GetChaserProfileAttackLaserDuration(this.uniqueProfileIndex, attackIndex);
	}
	
	public float GetAttackLaserNoise(int attackIndex)
	{
		return GetChaserProfileAttackLaserNoise(this.uniqueProfileIndex, attackIndex);
	}
	
	public bool CanAttackPullIn(int attackIndex)
	{
		return GetChaserProfileAttackPullIn(this.uniqueProfileIndex, attackIndex);
	}

	public bool HasAttackGestures(int attackIndex)
	{
		return GetChaserProfileAttackGesturesState(this.uniqueProfileIndex, attackIndex);
	}

	public bool AttackDeathCamOnLowHealth(int attackIndex)
	{
		return GetChaserProfileAttackDeathCamLowHealth(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackUseOnHealth(int attackIndex)
	{
		return GetChaserProfileAttackUseOnHealth(this.uniqueProfileIndex, attackIndex);
	}

	public float GetAttackBlockOnHealth(int attackIndex)
	{
		return GetChaserProfileAttackBlockOnHealth(this.uniqueProfileIndex, attackIndex);
	}

	public void GetSmiteColor(int color[4])
	{
		color[0] = GetChaserProfileSmiteColorR(this.uniqueProfileIndex);
		color[1] = GetChaserProfileSmiteColorG(this.uniqueProfileIndex);
		color[2] = GetChaserProfileSmiteColorB(this.uniqueProfileIndex);
		color[3] = GetChaserProfileSmiteColorTrans(this.uniqueProfileIndex);
	}

	public float GetCloakCooldown(int difficulty)
	{
		return GetChaserProfileCloakCooldown(this.uniqueProfileIndex, difficulty);
	}

	public float GetCloakRange(int difficulty)
	{
		return GetChaserProfileCloakRange(this.uniqueProfileIndex, difficulty);
	}

	public float GetDecloakRange(int difficulty)
	{
		return GetChaserProfileDecloakRange(this.uniqueProfileIndex, difficulty);
	}

	public float GetCloakDuration(int difficulty)
	{
		return GetChaserProfileCloakDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetCloakSpeedMultiplier(int difficulty)
	{
		return GetChaserProfileCloakSpeedMultiplier(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveHeight(int difficulty)
	{
		return GetChaserProfileShockwaveHeight(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveRange(int difficulty)
	{
		return GetChaserProfileShockwaveRange(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveDrain(int difficulty)
	{
		return GetChaserProfileShockwaveDrain(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveForce(int difficulty)
	{
		return GetChaserProfileShockwaveForce(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveStunDuration(int difficulty)
	{
		return GetChaserProfileShockwaveStunDuration(this.uniqueProfileIndex, difficulty);
	}

	public float GetShockwaveStunSlowdown(int difficulty)
	{
		return GetChaserProfileShockwaveStunSlowdown(this.uniqueProfileIndex, difficulty);
	}

	public float GetTrapCooldown(int difficulty)
	{
		return GetChaserProfileTrapSpawnCooldown(this.uniqueProfileIndex, difficulty);
	}

	property bool IsCrawlingEnabled
	{
		public get() { g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_CrawlingEnabled); }
	}

	public float GetCrawlingSpeedMultiplier(int difficulty)
	{
		return GetChaserProfileCrawlSpeedMultiplier(this.uniqueProfileIndex, difficulty);
	}

	property bool CanChaseOnLook
	{
		public get() { return g_ChaserProfileData.Get(this.uniqueProfileIndex, ChaserProfileData_ChaseOnLook); }
	}
}

#include "sf2/profiles/profile_chaser_precache.sp"

void InitializeChaserProfiles()
{
	g_ChaserProfileNames = new StringMap();
	g_ChaserProfileData = new ArrayList(ChaserProfileData_MaxStats);
}

/**
 *	Clears all data and memory currently in use by chaser profiles.
 */
void ClearChaserProfiles()
{
	for (int i = 0; i < g_ChaserProfileData.Length; i++)
	{
		ArrayList hHandle = g_ChaserProfileData.Get(i, ChaserProfileData_Attacks);
		if (hHandle != null)
		{
			delete hHandle;
		}
	}
	
	g_ChaserProfileNames.Clear();
	g_ChaserProfileData.Clear();
}

int GetChaserProfileAutoChaseCount(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCountEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCountHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCountInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCountNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCountApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseCount);
}

int GetChaserProfileAutoChaseAddGeneral(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAdd);
}

int GetChaserProfileAutoChaseAddFootstep(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstepApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddFootstep);
}

int GetChaserProfileAutoChaseAddVoice(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoiceApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddVoice);
}

int GetChaserProfileAutoChaseAddWeapon(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeaponApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AutoChaseAddWeapon);
}

float GetChaserProfileWalkSpeed(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WalkSpeedNormal);
}

float GetChaserProfileMaxWalkSpeed(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MaxWalkSpeedNormal);
}

float GetChaserProfileAlertGracetime(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetimeEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetimeHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetimeInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetimeNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetimeApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertGracetime);
}

float GetChaserProfileAlertDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchAlertDuration);
}

float GetChaserProfileChaseDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchChaseDuration);
}

float GetChaserProfileWanderRangeMin(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMinEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMinHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMinInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMinNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMinApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMin);
}

float GetChaserProfileWanderRangeMax(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMaxApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderRangeMax);
}

float GetChaserProfileWanderTimeMin(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMinEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMinHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMinInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMinNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMinApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMin);
}

float GetChaserProfileWanderTimeMax(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMaxApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SearchWanderTimeMax);
}

float GetChaserProfileProjectileCooldownMin(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMinNormal);
}

float GetChaserProfileProjectileCooldownMax(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCooldownMaxNormal);
}

float GetChaserProfileIceballSlowdownDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownDurationNormal);
}

float GetChaserProfileIceballSlowdownPercent(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IceballSlowdownPercentNormal);
}

float GetChaserProfileProjectileSpeed(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileSpeedNormal);
}

float GetChaserProfileProjectileDamage(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDamageNormal);
}

float GetChaserProfileProjectileRadius(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileRadiusNormal);
}

float GetChaserProfileProjectileDeviation(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileDeviation);
}

int GetChaserProfileProjectileCount(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCountEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCountHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCountInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCountNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCountApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileCount);
}

float GetChaserProfileRandomEffectDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedDurationNormal);
}

float GetChaserProfileRandomEffectSlowdown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedSlowdownNormal);
}

float GetChaserProfileJaratePlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedDurationNormal);
}

float GetChaserProfileMilkPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedDurationNormal);
}

float GetChaserProfileGasPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedDurationNormal);
}

float GetChaserProfileMarkPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedDurationNormal);
}

float GetChaserProfileSilentMarkPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedDurationNormal);
}

float GetChaserProfileIgnitePlayerDelay(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedDelayNormal);
}

float GetChaserProfileStunPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedDurationNormal);
}

float GetChaserProfileStunPlayerSlowdown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedSlowdownNormal);
}

float GetChaserProfileBleedPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedDurationNormal);
}

float GetChaserProfileEletricPlayerDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedDurationNormal);
}

float GetChaserProfileEletricPlayerSlowdown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedSlowdownNormal);
}
/*
Handle GetChaserProfileAnimationsData(int chaserProfileIndex)
{
	return view_as<Handle>(g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Animations));
}
*/
float GetChaserProfileWakeRadius(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_WakeRadius);
}

int GetChaserProfileAttackCount(int chaserProfileIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Length;
}

int GetChaserProfileRandomAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedIndexes);
}

int GetChaserProfileRandomStunType(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_RandomAdvancedStunType);
}

int GetChaserProfileJarateAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_JarateAdvancedIndexes);
}

int GetChaserProfileMilkAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MilkAdvancedIndexes);
}

int GetChaserProfileGasAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_GasAdvancedIndexes);
}

int GetChaserProfileMarkAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_MarkAdvancedIndexes);
}

int GetChaserProfileSilentMarkAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SilentMarkAdvancedIndexes);
}

int GetChaserProfileIgniteAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_IgniteAdvancedIndexes);
}

int GetChaserProfileStunAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedIndexes);
}

int GetChaserProfileStunDamageType(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunAdvancedType);
}

int GetChaserProfileBleedAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_BleedAdvancedIndexes);
}

int GetChaserProfileEletricAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EletricAdvancedIndexes);
}

int GetChaserProfileSmiteAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteAdvancedIndexes);
}

int GetChaserProfileSmiteDamageType(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteAdvancedDamageType);
}

int GetChaserProfileSmiteColorR(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteColorR);
}

int GetChaserProfileSmiteColorG(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteColorG);
}

int GetChaserProfileSmiteColorB(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteColorB);
}

int GetChaserProfileSmiteColorTrans(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteTransparency);
}

float GetChaserProfileSmiteDamage(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteAdvancedDamage);
}

int GetChaserProfileAttackType(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Type);
}

bool GetChaserProfileAttackDisappear(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Disappear);
}

int GetChaserProfileAttackRepeat(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Repeat);
}

int GetChaserProfileMaxAttackRepeats(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_MaxAttackRepeat);
}

bool GetChaserProfileAttackIgnoreAlwaysLooking(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_IgnoreAlwaysLooking);
}

int GetChaserProfileAttackWeaponTypeInt(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_WeaponInt);
}

float GetChaserProfileAttackDamage(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Damage);
}

float GetChaserProfileAttackLifeStealDuration(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LifeStealDuration);
}

float GetChaserProfileAttackProjectileDamage(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamageHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamageApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDamage);
}

float GetChaserProfileAttackProjectileSpeed(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeedEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeedHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeedInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeedNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeedApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileSpeed);
}

float GetChaserProfileAttackProjectileRadius(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadiusEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadiusHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadiusInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadiusNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadiusApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileRadius);
}

float GetChaserProfileAttackProjectileDeviation(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviationEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviationHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviationInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviationNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviationApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileDeviation);
}

int GetChaserProfileAttackProjectileCount(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCountEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCountHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCountInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCountNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCountApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCount);
}

bool GetChaserProfileAttackCritProjectiles(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileCrits);
}

int GetChaserProfileAttackProjectileType(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileType);
}

float GetChaserProfileAttackProjectileIceSlowPercent(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercentApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownPercent);
}

float GetChaserProfileAttackProjectileIceSlowDuration(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDurationApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ProjectileIceSlowdownDuration);
}

int GetChaserProfileAttackBulletCount(int chaserProfileIndex,int attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCountEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCountHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCountInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCountNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCountApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletCount);
}

float GetChaserProfileAttackBulletDamage(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamageHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamageApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletDamage);
}

float GetChaserProfileAttackBulletSpread(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpreadEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpreadHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpreadInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpreadNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpreadApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BulletSpread);
}

float GetChaserProfileAttackLaserDamage(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamageEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamageHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamageInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamageNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamageApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDamage);
}

float GetChaserProfileAttackLaserSize(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserSize);
}

int GetChaserProfileAttackLaserColorR(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserColorR);
}

int GetChaserProfileAttackLaserColorG(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserColorG);
}

int GetChaserProfileAttackLaserColorB(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserColorB);
}

bool GetChaserProfileEnableLaserAttachment(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserAttachment);
}

float GetChaserProfileAttackLaserDuration(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserDuration);
}

float GetChaserProfileAttackLaserNoise(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LaserNoise);
}

bool GetChaserProfileAttackPullIn(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	return hAttacks.Get(attackIndex, ChaserProfileAttackData_PullIn);
}

float GetChaserProfileAttackDamageVsProps(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageVsProps);
}

float GetChaserProfileAttackDamageForce(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageForce);
}

int GetChaserProfileAttackDamageType(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageType);
}

float GetChaserProfileAttackDamageDelay(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_DamageDelay);
}

float GetChaserProfileAttackRange(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Range);
}

float GetChaserProfileAttackDuration(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Duration);
}

float GetChaserProfileAttackSpread(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Spread);
}

float GetChaserProfileAttackBeginRange(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BeginRange);
}

float GetChaserProfileAttackBeginFOV(int chaserProfileIndex,int  attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BeginFOV);
}

float GetChaserProfileAttackCooldown(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);
	
	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_CooldownEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_CooldownHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_CooldownInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_CooldownNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_CooldownApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Cooldown);
}

bool GetChaserProfileAttackLifeStealState(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_LifeStealEnabled);
}

bool GetChaserProfileAttackRunWhileAttackingState(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_CanAttackWhileRunning);
}


float GetChaserProfileAttackRunSpeed(int chaserProfileIndex,int  attackIndex,int difficulty)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	switch (difficulty)
	{
		case Difficulty_Easy: return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeedEasy);
		case Difficulty_Hard: return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeedHard);
		case Difficulty_Insane: return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeedInsane);
		case Difficulty_Nightmare: return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeedNightmare);
		case Difficulty_Apollyon: return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeedApollyon);
	}

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunSpeed);
}

float GetChaserProfileAttackRunDuration(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunDuration);
}

float GetChaserProfileAttackRunDelay(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_RunDelay);
}

int GetChaserProfileAttackUseOnDifficulty(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_UseOnDifficulty);
}

int GetChaserProfileAttackBlockOnDifficulty(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BlockOnDifficulty);
}

int GetChaserProfileAttackExplosiveDanceRadius(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_ExplosiveDanceRadius);
}

bool GetChaserProfileAttackGesturesState(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_Gestures);
}

bool GetChaserProfileAttackDeathCamLowHealth(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_DeathCamLowHealth);
}

float GetChaserProfileAttackUseOnHealth(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_UseOnHealth);
}

float GetChaserProfileAttackBlockOnHealth(int chaserProfileIndex,int attackIndex)
{
	ArrayList hAttacks = g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_Attacks);

	return hAttacks.Get(attackIndex, ChaserProfileAttackData_BlockOnHealth);
}

bool GetChaserProfileEnableAdvancedDamageEffects(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsEnabled);
}

bool GetChaserProfileEnableAdvancedDamageEffectsRandom(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsRandom);
}

bool GetChaserProfileEnableAdvancedDamageParticles(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AdvancedDamageEffectsParticles);
}

bool GetChaserProfileJarateState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableJarateAdvanced);
}

bool GetChaserProfileMilkState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableMilkAdvanced);
}

bool GetChaserProfileGasState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableGasAdvanced);
}

bool GetChaserProfileMarkState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableMarkAdvanced);
}

bool GetChaserProfileSilentMarkState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableSilentMarkAdvanced);
}

bool GetChaserProfileIgniteState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableIgniteAdvanced);
}

bool GetChaserProfileStunAttackState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableStunAdvanced);
}

bool GetChaserProfileBleedState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableBleedAdvanced);
}

bool GetChaserProfileEletricAttackState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableEletricAdvanced);
}

bool GetChaserProfileSmiteState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableSmiteAdvanced);
}

bool GetChaserProfileSmiteMessage(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_SmiteMessage);
}

bool GetChaserProfileXenobladeCombo(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableXenobladeBreakCombo);
}

float GetChaserProfileXenobladeBreakDuration(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_XenobladeBreakDuration);
}

float GetChaserProfileXenobladeToppleDuration(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_XenobladeToppleDuration);
}

float GetChaserProfileXenobladeToppleSlowdown(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_XenobladeToppleSlowdown);
}

float GetChaserProfileXenobladeDazeDuration(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_XenobladeDazeDuration);
}

bool GetChaserProfileCloakState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CanCloak);
}

bool GetChaserProfileProjectileState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileEnable);
}

bool GetChaserProfileCriticalRockets(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CriticlaRockets);
}

bool GetChaserProfileGestureShoot(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_UseShootGesture);
}

bool GetChaserProfileProjectileAmmoState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipEnable);
}

bool GetChaserProfileChargeUpProjectilesState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_UseChargeUpProjectiles);
}

int GetChaserProfileProjectileType(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileType);
}

int GetChaserProfileProjectileLoadedAmmo(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipNightmare);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileClipNormal);
}

float GetChaserProfileProjectileAmmoReloadTime(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileReloadTimeNormal);
}

float GetChaserProfileProjectileChargeUpTime(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ProjectileChargeUpNormal);
}

bool GetChaserProfileDamageParticleState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_EnableDamageParticles);
}

float GetChaserProfileDamageParticleVolume(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_DamageParticleVolume);
}

int GetChaserProfileDamageParticlePitch(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_DamageParticlePitch);
}

bool GetChaserProfileStunState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CanBeStunned);
}

float GetChaserProfileStunDuration(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunDuration);
}

float GetChaserProfileStunCooldown(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunCooldown);
}

bool GetChaserProfileStunFlashlightState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CanBeStunnedByFlashlight);
}

float GetChaserProfileStunFlashlightDamage(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunFlashlightDamage);
}

bool GetChaserProfileStunOnChaseInitial(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ChaseInitialOnStun);
}

float GetChaserProfileStunHealth(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunHealth);
}

float GetChaserProfileStunHealthPerPlayer(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_StunHealthPerPlayer);
}

bool GetChaserProfileKeyDrop(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_KeyDrop);
}

float GetChaserProfileCloakCooldown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakCooldownNormal);
}

float GetChaserProfileCloakRange(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakRangeNormal);
}

float GetChaserProfileDecloakRange(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDecloakRangeNormal);
}

float GetChaserProfileCloakDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakDurationNormal);
}

float GetChaserProfileCloakSpeedMultiplier(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CloakSpeedMultiplierNormal);
}

bool GetChaserProfileShockwaveState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwavesEnable);
}

float GetChaserProfileShockwaveHeight(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveHeightNormal);
}

float GetChaserProfileShockwaveRange(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveRangeNormal);
}

float GetChaserProfileShockwaveDrain(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveDrainNormal);
}

float GetChaserProfileShockwaveForce(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveForceNormal);
}

bool GetChaserProfileShockwaveStunState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunEnabled);
}

float GetChaserProfileShockwaveStunDuration(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunDurationNormal);
}

float GetChaserProfileShockwaveStunSlowdown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveStunSlowdownNormal);
}

int GetChaserProfileShockwaveAttackIndexes(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveAttackIndexes);
}

float GetChaserProfileShockwaveWidth1(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveWidth1);
}

float GetChaserProfileShockwaveWidth2(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveWidth2);
}

float GetChaserProfileShockwaveAmplitude(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_ShockwaveAmplitude);
}

bool GetChaserProfileTrapState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapsEnabled);
}

int GetChaserProfileTrapType(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapType);
}

float GetChaserProfileTrapSpawnCooldown(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_TrapSpawnCooldownNormal);
}

float GetChaserProfileCrawlSpeedMultiplier(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CrawlSpeedMultiplierNormal);
}

bool GetChaserProfileSelfHealState(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_CanSelfHeal);
}

float GetChaserProfileSelfHealStartPercentage(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_HealStartHealthPercentage);
}

float GetChaserProfileSelfHealPercentageOne(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_HealPercentageOne);
}

float GetChaserProfileSelfHealPercentageTwo(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_HealPercentageTwo);
}

float GetChaserProfileSelfHealPercentageThree(int chaserProfileIndex)
{
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_HealPercentageThree);
}

stock float GetChaserProfileAwarenessIncreaseRate(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessIncreaseRateNormal);
}

stock float GetChaserProfileAwarenessDecreaseRate(int chaserProfileIndex,int difficulty)
{
	switch (difficulty)
	{
		case Difficulty_Easy: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateEasy);
		case Difficulty_Hard: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateHard);
		case Difficulty_Insane: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateInsane);
		case Difficulty_Nightmare: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateNightmare);
		case Difficulty_Apollyon: return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateApollyon);
	}
	
	return g_ChaserProfileData.Get(chaserProfileIndex, ChaserProfileData_AwarenessDecreaseRateNormal);
}

stock int GetProfileAttackNum(const char[] profile, const char[] keyValue,int defaultValue=0, const int attackIndex)
{
	if (!IsProfileValid(profile)) return defaultValue;
	
	char sKey[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", attackIndex);
	g_Config.JumpToKey(sKey);
	return g_Config.GetNum(keyValue, defaultValue);
}

stock float GetProfileAttackFloat(const char[] profile, const char[] keyValue,float defaultValue=0.0, const int attackIndex)
{
	if (!IsProfileValid(profile)) return defaultValue;
	
	char sKey[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", attackIndex);
	g_Config.JumpToKey(sKey);
	return g_Config.GetFloat(keyValue, defaultValue);
}

stock bool GetProfileAttackString(const char[] profile, const char[] keyValue, char[] sBuffer, int iLenght, const char[] sDefaultValue = "", const int attackIndex)
{
	if (!IsProfileValid(profile)) return false;
	
	char sKey[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", attackIndex);
	g_Config.JumpToKey(sKey);
	g_Config.GetString(keyValue, sBuffer, iLenght, sDefaultValue);
	return true;
}

stock bool GetProfileAttackVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int attackIndex)
{
	for (int i = 0; i < 3; i++) buffer[i] = defaultValue[i];
	
	if (!IsProfileValid(profile)) return false;
	
	char sKey[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(sKey, sizeof(sKey), "%d", attackIndex);
	g_Config.JumpToKey(sKey);
	g_Config.GetVector(keyValue, buffer, defaultValue);
	return true;
}