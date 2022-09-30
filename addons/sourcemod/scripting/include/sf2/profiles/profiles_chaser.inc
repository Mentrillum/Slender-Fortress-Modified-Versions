ConVar g_DefaultBossVisibilityStateConVar;

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

enum struct SF2BossProfileAttackGestureData // This one covers the gestures
{
	ArrayList Names;
	float Playbackrate[Difficulty_Max];
	float Cycle[Difficulty_Max];

	void Init()
	{
		this.Names = new ArrayList(ByteCountToCells(64));
		this.Names.Resize(Difficulty_Max);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Playbackrate[i] = this.Playbackrate[i] = i > 0 ? this.Playbackrate[i - 1] : 1.0;
			this.Cycle[i] = this.Cycle[i] = i > 0 ? this.Cycle[i - 1] : 0.0;
		}
	}

	void Load(KeyValues kv)
	{
		char animNames[Difficulty_Max][64];

		GetProfileDifficultyStringValues(kv, "gesture_name", animNames, sizeof(animNames[]), animNames);
		GetProfileDifficultyFloatValues(kv, "gesture_playbackrate", this.Playbackrate, this.Playbackrate);
		GetProfileDifficultyFloatValues(kv, "gesture_cycle", this.Cycle, this.Cycle);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.SetGesture(i, animNames[i]);
		}
	}

	void Destroy()
	{
		if (this.Names != null)
		{
			delete this.Names;
		}
	}

	void GetGesture(int difficulty, char[] buffer, int bufferLen)
	{
		this.Names.GetString(difficulty, buffer, bufferLen);
	}

	void SetGesture(int difficulty, const char[] name)
	{
		this.Names.SetString(difficulty, name);
	}
}

enum struct SF2ChaserBossProfileAttackData
{
	int Type;

	bool CanUseAgainstProps;

	float Damage[Difficulty_Max];
	float DamageVsProps;
	float DamageForce;
	int DamageType;
	float DamageDelay;

	float Range;
	float Duration;
	float Spread;
	float BeginRange;
	float BeginFOV;
	float PunchVelocity[3];

	float Cooldown[Difficulty_Max];

	bool Disappear;
	int Repeat;
	int MaxRepeats;
	ArrayList RepeatTimers;

	bool IgnoreAlwaysLooking;

	int WeaponInt;
	char WeaponString[PLATFORM_MAX_PATH];
	bool WeaponTypes;

	bool LifeSteal;
	float LifeStealDuration;

	float ProjectileDamage[Difficulty_Max];
	float ProjectileSpeed[Difficulty_Max];
	float ProjectileRadius[Difficulty_Max];
	float ProjectileDeviation[Difficulty_Max];
	int ProjectileCount[Difficulty_Max];
	bool CritProjectiles;
	int ProjectileType;
	float ProjectileOffset[3];
	char FireballTrail[PLATFORM_MAX_PATH];
	char RocketModel[PLATFORM_MAX_PATH];

	float IceballSlowdownPercent[Difficulty_Max];
	float IceballSlowdownDuration[Difficulty_Max];
	char IceballTrail[PLATFORM_MAX_PATH];

	int BulletCount[Difficulty_Max];
	float BulletDamage[Difficulty_Max];
	float BulletSpread[Difficulty_Max];
	char BulletTrace[PLATFORM_MAX_PATH];
	float BulletOffset[3];

	float LaserDamage[Difficulty_Max];
	float LaserSize;
	int LaserColor[3];
	bool LaserAttachment;
	float LaserDuration;
	float LaserNoise;
	float LaserOffset[3];
	char LaserAttachmentName[PLATFORM_MAX_PATH];

	bool PullIn;

	bool AttackWhileRunning;
	float RunSpeed[Difficulty_Max];
	float RunDuration;
	float RunDelay;

	int UseOnDifficulty;
	int BlockOnDifficulty;
	float UseOnHealth;
	float BlockOnHealth;

	int ExplosiveDanceRadius;

	bool Gestures;

	bool DeathCamLowHealth;

	bool DontInterruptChaseInitial;

	bool CancelLos;
	float CancelDistance;

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Damage[difficulty] = this.Damage[difficulty] = difficulty > 0 ? this.Damage[difficulty - 1] : 0.0;

			this.Cooldown[difficulty] = this.Cooldown[difficulty] = difficulty > 0 ? this.Cooldown[difficulty - 1] : 0.0;

			this.ProjectileDamage[difficulty] = this.ProjectileDamage[difficulty] = difficulty > 0 ? this.ProjectileDamage[difficulty - 1] : 20.0;
			this.ProjectileSpeed[difficulty] = this.ProjectileSpeed[difficulty] = difficulty > 0 ? this.ProjectileSpeed[difficulty - 1] : 1100.0;
			this.ProjectileRadius[difficulty] = this.ProjectileRadius[difficulty] = difficulty > 0 ? this.ProjectileRadius[difficulty - 1] : 128.0;
			this.ProjectileDeviation[difficulty] = this.ProjectileDeviation[difficulty] = difficulty > 0 ? this.ProjectileDeviation[difficulty - 1] : 0.0;
			this.ProjectileCount[difficulty] = this.ProjectileCount[difficulty] = difficulty > 0 ? this.ProjectileCount[difficulty - 1] : 1;

			this.IceballSlowdownPercent[difficulty] = this.IceballSlowdownPercent[difficulty] = difficulty > 0 ? this.IceballSlowdownPercent[difficulty - 1] : 0.55;
			this.IceballSlowdownDuration[difficulty] = this.IceballSlowdownDuration[difficulty] = difficulty > 0 ? this.IceballSlowdownDuration[difficulty - 1] : 2.0;

			this.BulletCount[difficulty] = this.BulletCount[difficulty] = difficulty > 0 ? this.BulletCount[difficulty - 1] : 4;
			this.BulletDamage[difficulty] = this.BulletDamage[difficulty] = difficulty > 0 ? this.BulletDamage[difficulty - 1] : 8.0;
			this.BulletSpread[difficulty] = this.BulletSpread[difficulty] = difficulty > 0 ? this.BulletSpread[difficulty - 1] : 0.1;

			this.LaserDamage[difficulty] = this.LaserDamage[difficulty] = difficulty > 0 ? this.LaserDamage[difficulty - 1] : 25.0;

			this.RunSpeed[difficulty] = this.RunSpeed[difficulty] = difficulty > 0 ? this.RunSpeed[difficulty - 1] : 0.0;
		}
		for (int i = 0; i < 3; i++)
		{
			this.PunchVelocity[i] = 0.0;

			this.ProjectileOffset[i] = 0.0;

			this.BulletOffset[i] = 0.0;

			this.LaserColor[i] = 0;
			this.LaserOffset[i] = 0.0;
		}
		this.Type = SF2BossAttackType_Melee;

		this.CanUseAgainstProps = false;

		this.DamageVsProps = this.Damage[1];
		this.DamageForce = 0.0;
		this.DamageType = 0;
		this.DamageDelay = 0.0;

		this.Range = 0.0;
		this.Duration = 0.0;
		this.Spread = 45.0;
		this.BeginRange = this.Range;
		this.BeginFOV = this.Spread;

		this.Disappear = false;
		this.Repeat = 0;
		this.MaxRepeats = 0;
		this.RepeatTimers = null;

		this.IgnoreAlwaysLooking = false;

		this.WeaponInt = 0;
		this.WeaponString[0] = '\0';
		this.WeaponTypes = false;

		this.LifeSteal = false;
		this.LifeStealDuration = 0.0;

		this.CritProjectiles = false;
		this.ProjectileType = 0;
		this.FireballTrail = FIREBALL_TRAIL;
		this.IceballTrail = ICEBALL_TRAIL;
		this.RocketModel = ROCKET_MODEL;

		this.BulletTrace = "bullet_tracer02_blue";

		this.LaserSize = 12.0;
		this.LaserAttachment = false;
		this.LaserDuration = this.Duration;
		this.LaserNoise = 1.0;
		this.LaserAttachmentName[0] = '\0';

		this.PullIn = false;

		this.AttackWhileRunning = false;
		this.RunDuration = 0.0;
		this.RunDelay = 0.0;

		this.UseOnDifficulty = 0;
		this.BlockOnDifficulty = 6;
		this.UseOnHealth = -1.0;
		this.BlockOnHealth = -1.0;

		this.ExplosiveDanceRadius = 350;

		this.Gestures = false;

		this.DeathCamLowHealth = false;

		this.DontInterruptChaseInitial = false;

		this.CancelLos = false;
		this.CancelDistance = -1.0;
	}

	void Destroy()
	{
		if (this.RepeatTimers != null)
		{
			delete this.RepeatTimers;
		}
	}
}

enum struct SF2ChaserBossProfileData
{
	float WalkSpeed[Difficulty_Max];
	float MaxWalkSpeed[Difficulty_Max];

	float WakeRadius;

	ArrayList Attacks;

	ArrayList AttackPropModels;

	float AlertDuration[Difficulty_Max];
	float AlertGracetime[Difficulty_Max];
	float ChaseDuration[Difficulty_Max];
	float ChaseDurationAddVisibleMin;
	float ChaseDurationAddVisibleMax;

	float SoundPosDiscardTime;
	float SoundPosDistanceTolerance;
	float ChasePersistencyTimeInit;
	float ChaseAttackPersistencyTimeInit;
	float ChaseAttackPersistencyTimeAdd;
	float ChaseNewTargetPersistencyTimeInit;
	float ChaseNewTargetPersistencyTimeAdd;
	float ChasePersistencyAddVisibleMin;
	float ChasePersistencyAddVisibleMax;
	float ChaseStunPersistencyTimeInit;
	float ChaseStunPersistencyTimeAdd;

	float WanderRangeMin[Difficulty_Max];
	float WanderRangeMax[Difficulty_Max];
	float WanderTimeMin[Difficulty_Max];
	float WanderTimeMax[Difficulty_Max];

	bool StunEnabled;
	float StunCooldown;
	float StunHealth;
	float StunHealthPerPlayer;
	float StunHealthPerClass[10];
	bool FlashlightStun;
	float FlashlightDamage;
	bool DisappearOnStun;
	bool ItemDropOnStun;
	int StunItemDropType;
	bool ChaseInitialOnStun;
	ArrayList DamageResistances;

	bool KeyDrop;
	char KeyModel[PLATFORM_MAX_PATH];
	char KeyTrigger[PLATFORM_MAX_PATH];

	float MemoryLifeTime;

	float AwarenessIncreaseRate[Difficulty_Max];
	float AwarenessDecreaseRate[Difficulty_Max];

	bool AutoChaseEnabled;
	int AutoChaseCount[Difficulty_Max];
	int AutoChaseAdd[Difficulty_Max];
	int AutoChaseAddFootstep[Difficulty_Max];
	int AutoChaseAddVoice[Difficulty_Max];
	int AutoChaseAddWeapon[Difficulty_Max];
	bool AutoChaseSprinters;
	int SoundCountToAlert;

	bool ChasesEndlessly;

	bool EarthquakeFootsteps;
	float EarthquakeFootstepRadius;
	float EarthquakeFootstepDuration;
	bool EarthquakeFootstepAirShake;
	float EarthquakeFootstepAmplitude;
	float EarthquakeFootstepFrequency;

	bool CanCloak;
	bool CloakOnFlee;
	float CloakCooldown[Difficulty_Max];
	float CloakRange[Difficulty_Max];
	float DecloakRange[Difficulty_Max];
	float CloakDuration[Difficulty_Max];
	float CloakSpeedMultiplier[Difficulty_Max];
	char CloakParticle[PLATFORM_MAX_PATH];
	int CloakRenderColor[4];
	int CloakRenderMode;

	bool ProjectilesEnabled;
	float ProjectileCooldownMin[Difficulty_Max];
	float ProjectileCooldownMax[Difficulty_Max];
	float ProjectileSpeed[Difficulty_Max];
	float ProjectileDamage[Difficulty_Max];
	float ProjectileRadius[Difficulty_Max];
	float ProjectileDeviation[Difficulty_Max];
	int ProjectileType;
	bool CriticalProjectiles;
	bool ShootGestures;
	char ShootGestureName[PLATFORM_MAX_PATH];
	bool ShootAnimations;
	bool ProjectileClips;
	int ProjectileClipSize[Difficulty_Max];
	float ProjectileReloadTime[Difficulty_Max];
	bool ChargeUpProjectiles;
	float ProjectileChargeUp[Difficulty_Max];
	int ProjectileCount[Difficulty_Max];
	int ProjectileRandomPosMin;
	int ProjectileRandomPosMax;
	ArrayList ProjectilePosOffsets;
	char BaseballModel[PLATFORM_MAX_PATH];

	float IceballSlowDuration[Difficulty_Max];
	float IceballSlowPercent[Difficulty_Max];

	bool AdvancedDamageEffects;
	bool RandomAdvancedDamageEffects;
	bool AdvancedDamageEffectParticles;

	int RandomEffectIndexes;
	char RandomEffectIndexesString[88];
	float RandomEffectDuration[Difficulty_Max];
	float RandomEffectSlowdown[Difficulty_Max];
	int RandomEffectStunType;

	bool JarateEffects;
	int JarateIndexes;
	char JarateIndexesString[88];
	float JarateDuration[Difficulty_Max];
	bool JarateBeamParticle;
	char JarateParticle[PLATFORM_MAX_PATH];

	bool MilkEffects;
	int MilkIndexes;
	char MilkIndexesString[88];
	float MilkDuration[Difficulty_Max];
	bool MilkBeamParaticle;
	char MilkParticle[PLATFORM_MAX_PATH];

	bool GasEffects;
	int GasIndexes;
	char GasIndexesString[88];
	float GasDuration[Difficulty_Max];
	bool GasBeamParticle;
	char GasParticle[PLATFORM_MAX_PATH];

	bool MarkEffects;
	int MarkIndexes;
	char MarkIndexesString[88];
	float MarkDuration[Difficulty_Max];

	bool SilentMarkEffects;
	int SilentMarkIndexes;
	char SilentMarkIndexesString[88];
	float SilentMarkDuration[Difficulty_Max];

	bool IgniteEffects;
	int IgniteIndexes;
	char IgniteIndexesString[88];
	float IgniteDelay[Difficulty_Max];

	bool StunEffects;
	int StunEffectIndexes;
	char StunEffectIndexesString[88];
	float StunEffectDuration[Difficulty_Max];
	float StunEffectSlowdown[Difficulty_Max];
	int StunEffectType;
	bool StunEffectBeamParticle;
	char StunParticle[PLATFORM_MAX_PATH];

	bool BleedEffects;
	int BleedIndexes;
	char BleedIndexesString[88];
	float BleedDuration[Difficulty_Max];

	bool ElectricEffects;
	int ElectricIndexes;
	char ElectricIndexesString[88];
	float ElectricDuration[Difficulty_Max];
	float ElectricSlowdown[Difficulty_Max];
	int ElectricType;
	bool ElectricBeamParticle;
	char ElectricParticleRed[PLATFORM_MAX_PATH];
	char ElectricParticleBlue[PLATFORM_MAX_PATH];

	bool SmiteEffects;
	int SmiteIndexes;
	char SmiteIndexesString[88];
	float SmiteDamage;
	int SmiteDamageType;
	int SmiteColor[4];
	bool SmiteMessage;

	bool XenobladeCombo;
	float XenobladeDuration;
	float XenobladeToppleDuration;
	float XenobladeToppleSlowdown;
	float XenobladeDazeDuration;

	bool Shockwaves;
	float ShockwaveHeight[Difficulty_Max];
	float ShockwaveRange[Difficulty_Max];
	float ShockwaveDrain[Difficulty_Max];
	float ShockwaveForce[Difficulty_Max];
	bool ShockwaveStun;
	float ShockwaveStunDuration[Difficulty_Max];
	float ShockwaveStunSlowdown[Difficulty_Max];
	int ShockwaveIndexes;
	char ShockwaveIndexesString[88];
	float ShockwaveWidths[2];
	float ShockwaveAmplitude;
	int ShockwaveColor1[3];
	int ShockwaveColor2[3];
	int ShockwaveAlpha1;
	int ShockwaveAlpha2;
	char ShockwaveBeamSprite[PLATFORM_MAX_PATH];
	char ShockwaveHaloSprite[PLATFORM_MAX_PATH];
	int ShockwaveBeamModel;
	int ShockwaveHaloModel;

	bool Traps;
	int TrapType;
	float TrapCooldown[Difficulty_Max];

	bool DamageParticles;
	char DamageParticleName[PLATFORM_MAX_PATH];
	bool DamageParticleBeam;
	char DamageParticleSound[PLATFORM_MAX_PATH];

	bool SelfHeal;
	float SelfHealPercentageStart;
	float SelfHealRecover[3];
	bool CloakToHeal;

	bool BoxingBoss;

	bool NormalSoundHook;
	bool ChaseInitialAnimations;
	bool OldAnimationAI;
	bool AlertWalkingAnimation;
	bool SpawnAnimationsEnabled;

	bool Crawling;
	float CrawlSpeedMultiplier[Difficulty_Max];
	float CrawlDetectMins[3];
	float CrawlDetectMaxs[3];

	bool ChaseOnLook;

	bool UnnerfedVisibility;

	bool ClearLayersOnAnimUpdate;

	float HealAnimationTimer;
	float HealFunctionTimer;
	float HealRangeMin;
	float HealRangeMax;
	float HealTimeMin;
	float HealTimeMax;

	float AfterburnMultiplier;
	float BackstabDamageScale;

	// Sounds
	SF2BossProfileSoundInfo IdleSounds;
	SF2BossProfileSoundInfo AlertSounds;
	SF2BossProfileSoundInfo ChasingSounds;
	SF2BossProfileSoundInfo ChaseInitialSounds;
	SF2BossProfileSoundInfo AttackKilledSounds;
	SF2BossProfileSoundInfo AttackKilledAllSounds;
	SF2BossProfileSoundInfo AttackKilledClientSounds;
	SF2BossProfileSoundInfo RageAllSounds;
	SF2BossProfileSoundInfo RageTwoSounds;
	SF2BossProfileSoundInfo RageThreeSounds;
	SF2BossProfileSoundInfo SelfHealSounds;
	SF2BossProfileSoundInfo StunnedSounds;
	SF2BossProfileSoundInfo FootstepSounds;
	ArrayList AttackSounds;
	ArrayList HitSounds;
	ArrayList MissSounds;
	ArrayList BulletShootSounds;
	ArrayList ProjectileShootSounds;

	SF2BossProfileSoundInfo ChaseMusics;
	SF2BossProfileSoundInfo ChaseVisibleMusics;
	SF2BossProfileSoundInfo AlertMusics;
	SF2BossProfileSoundInfo IdleMusics;
	SF2BossProfileSoundInfo TwentyDollarsMusics;

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.WalkSpeed[difficulty] = this.WalkSpeed[difficulty] = difficulty > 0 ? this.WalkSpeed[difficulty - 1] : 30.0;
			this.MaxWalkSpeed[difficulty] = this.MaxWalkSpeed[difficulty] = difficulty > 0 ? this.MaxWalkSpeed[difficulty - 1] : 30.0;

			this.AlertDuration[difficulty] = this.AlertDuration[difficulty] = difficulty > 0 ? this.AlertDuration[difficulty - 1] : 5.0;
			this.AlertGracetime[difficulty] = this.AlertGracetime[difficulty] = difficulty > 0 ? this.AlertGracetime[difficulty - 1] : 0.5;
			this.ChaseDuration[difficulty] = this.ChaseDuration[difficulty] = difficulty > 0 ? this.ChaseDuration[difficulty - 1] : 10.0;

			this.WanderRangeMin[difficulty] = this.WanderRangeMin[difficulty] = difficulty > 0 ? this.WanderRangeMin[difficulty - 1] : 400.0;
			this.WanderRangeMax[difficulty] = this.WanderRangeMax[difficulty] = difficulty > 0 ? this.WanderRangeMax[difficulty - 1] : 1024.0;
			this.WanderTimeMin[difficulty] = this.WanderTimeMin[difficulty] = difficulty > 0 ? this.WanderTimeMin[difficulty - 1] : 3.0;
			this.WanderTimeMax[difficulty] = this.WanderTimeMax[difficulty] = difficulty > 0 ? this.WanderTimeMax[difficulty - 1] : 4.5;

			this.AwarenessIncreaseRate[difficulty] = this.AwarenessIncreaseRate[difficulty] = difficulty > 0 ? this.AwarenessIncreaseRate[difficulty - 1] : 75.0;
			this.AwarenessDecreaseRate[difficulty] = this.AwarenessDecreaseRate[difficulty] = difficulty > 0 ? this.AwarenessDecreaseRate[difficulty - 1] : 150.0;

			this.AutoChaseCount[difficulty] = this.AutoChaseCount[difficulty] = difficulty > 0 ? this.AutoChaseCount[difficulty - 1] : 30;
			this.AutoChaseAdd[difficulty] = this.AutoChaseAdd[difficulty] = difficulty > 0 ? this.AutoChaseAdd[difficulty - 1] : 0;
			this.AutoChaseAddFootstep[difficulty] = this.AutoChaseAddFootstep[difficulty] = difficulty > 0 ? this.AutoChaseAddFootstep[difficulty - 1] : 2;
			this.AutoChaseAddVoice[difficulty] = this.AutoChaseAddVoice[difficulty] = difficulty > 0 ? this.AutoChaseAddVoice[difficulty - 1] : 8;
			this.AutoChaseAddWeapon[difficulty] = this.AutoChaseAddWeapon[difficulty] = difficulty > 0 ? this.AutoChaseAddWeapon[difficulty - 1] : 4;

			this.CloakCooldown[difficulty] = this.CloakCooldown[difficulty] = difficulty > 0 ? this.CloakCooldown[difficulty - 1] : 8.0;
			this.CloakRange[difficulty] = this.CloakRange[difficulty] = difficulty > 0 ? this.CloakRange[difficulty - 1] : 350.0;
			this.DecloakRange[difficulty] = this.DecloakRange[difficulty] = difficulty > 0 ? this.DecloakRange[difficulty - 1] : 150.0;
			this.CloakDuration[difficulty] = this.CloakDuration[difficulty] = difficulty > 0 ? this.CloakDuration[difficulty - 1] : 10.0;
			this.CloakSpeedMultiplier[difficulty] = this.CloakSpeedMultiplier[difficulty] = difficulty > 0 ? this.CloakSpeedMultiplier[difficulty - 1] : 1.0;

			this.ProjectileCooldownMin[difficulty] = this.ProjectileCooldownMin[difficulty] = difficulty > 0 ? this.ProjectileCooldownMin[difficulty - 1] : 1.0;
			this.ProjectileCooldownMax[difficulty] = this.ProjectileCooldownMax[difficulty] = difficulty > 0 ? this.ProjectileCooldownMax[difficulty - 1] : 2.0;
			this.ProjectileSpeed[difficulty] = this.ProjectileSpeed[difficulty] = difficulty > 0 ? this.ProjectileSpeed[difficulty - 1] : 400.0;
			this.ProjectileDamage[difficulty] = this.ProjectileDamage[difficulty] = difficulty > 0 ? this.ProjectileDamage[difficulty - 1] : 50.0;
			this.ProjectileRadius[difficulty] = this.ProjectileRadius[difficulty] = difficulty > 0 ? this.ProjectileRadius[difficulty - 1] : 128.0;
			this.ProjectileDeviation[difficulty] = this.ProjectileDeviation[difficulty] = difficulty > 0 ? this.ProjectileDeviation[difficulty - 1] : 0.0;
			this.ProjectileClipSize[difficulty] = this.ProjectileClipSize[difficulty] = difficulty > 0 ? this.ProjectileClipSize[difficulty - 1] : 3;
			this.ProjectileReloadTime[difficulty] = this.ProjectileReloadTime[difficulty] = difficulty > 0 ? this.ProjectileReloadTime[difficulty - 1] : 2.0;
			this.ProjectileChargeUp[difficulty] = this.ProjectileChargeUp[difficulty] = difficulty > 0 ? this.ProjectileChargeUp[difficulty - 1] : 5.0;
			this.ProjectileCount[difficulty] = this.ProjectileCount[difficulty] = difficulty > 0 ? this.ProjectileCount[difficulty - 1] : 1;

			this.IceballSlowDuration[difficulty] = this.IceballSlowDuration[difficulty] = difficulty > 0 ? this.IceballSlowDuration[difficulty - 1] : 2.0;
			this.IceballSlowPercent[difficulty] = this.IceballSlowPercent[difficulty] = difficulty > 0 ? this.IceballSlowPercent[difficulty - 1] : 0.55;

			this.RandomEffectDuration[difficulty] = this.RandomEffectDuration[difficulty] = difficulty > 0 ? this.RandomEffectDuration[difficulty - 1] : 0.0;
			this.RandomEffectSlowdown[difficulty] = this.RandomEffectSlowdown[difficulty] = difficulty > 0 ? this.RandomEffectSlowdown[difficulty - 1] : 0.0;
			this.JarateDuration[difficulty] = this.JarateDuration[difficulty] = difficulty > 0 ? this.JarateDuration[difficulty - 1] : 0.0;
			this.MilkDuration[difficulty] = this.MilkDuration[difficulty] = difficulty > 0 ? this.MilkDuration[difficulty - 1] : 0.0;
			this.GasDuration[difficulty] = this.GasDuration[difficulty] = difficulty > 0 ? this.GasDuration[difficulty - 1] : 0.0;
			this.MarkDuration[difficulty] = this.MarkDuration[difficulty] = difficulty > 0 ? this.MarkDuration[difficulty - 1] : 0.0;
			this.SilentMarkDuration[difficulty] = this.SilentMarkDuration[difficulty] = difficulty > 0 ? this.SilentMarkDuration[difficulty - 1] : 0.0;
			this.IgniteDelay[difficulty] = this.IgniteDelay[difficulty] = difficulty > 0 ? this.IgniteDelay[difficulty - 1] : 0.0;
			this.StunEffectDuration[difficulty] = this.StunEffectDuration[difficulty] = difficulty > 0 ? this.StunEffectDuration[difficulty - 1] : 0.0;
			this.StunEffectSlowdown[difficulty] = this.StunEffectSlowdown[difficulty] = difficulty > 0 ? this.StunEffectSlowdown[difficulty - 1] : 0.0;
			this.BleedDuration[difficulty] = this.BleedDuration[difficulty] = difficulty > 0 ? this.BleedDuration[difficulty - 1] : 0.0;
			this.ElectricDuration[difficulty] = this.ElectricDuration[difficulty] = difficulty > 0 ? this.ElectricDuration[difficulty - 1] : 0.0;
			this.ElectricSlowdown[difficulty] = this.ElectricSlowdown[difficulty] = difficulty > 0 ? this.ElectricSlowdown[difficulty - 1] : 0.0;

			this.ShockwaveHeight[difficulty] = this.ShockwaveHeight[difficulty] = difficulty > 0 ? this.ShockwaveHeight[difficulty - 1] : 64.0;
			this.ShockwaveRange[difficulty] = this.ShockwaveRange[difficulty] = difficulty > 0 ? this.ShockwaveRange[difficulty - 1] : 200.0;
			this.ShockwaveDrain[difficulty] = this.ShockwaveDrain[difficulty] = difficulty > 0 ? this.ShockwaveDrain[difficulty - 1] : 0.2;
			this.ShockwaveForce[difficulty] = this.ShockwaveForce[difficulty] = difficulty > 0 ? this.ShockwaveForce[difficulty - 1] : 6.0;

			this.ShockwaveStunDuration[difficulty] = this.ShockwaveStunDuration[difficulty] = difficulty > 0 ? this.ShockwaveStunDuration[difficulty - 1] : 2.0;
			this.ShockwaveStunSlowdown[difficulty] = this.ShockwaveStunSlowdown[difficulty] = difficulty > 0 ? this.ShockwaveStunSlowdown[difficulty - 1] : 0.7;

			this.TrapCooldown[difficulty] = this.TrapCooldown[difficulty] = difficulty > 0 ? this.TrapCooldown[difficulty - 1] : 8.0;

			this.CrawlSpeedMultiplier[difficulty] = this.CrawlSpeedMultiplier[difficulty] = difficulty > 0 ? this.CrawlSpeedMultiplier[difficulty - 1] : 0.5;
		}

		for (int i = 0; i < 3; i++)
		{
			this.ShockwaveColor1[i] = 128;
			this.ShockwaveColor2[i] = 255;
		}

		this.WakeRadius = 0.0;

		this.Attacks = null;

		this.AttackPropModels = null;

		this.ChaseDurationAddVisibleMin = 0.025;
		this.ChaseDurationAddVisibleMax = 0.2;

		this.SoundPosDiscardTime = 2.0;
		this.SoundPosDistanceTolerance = 512.0;
		this.ChasePersistencyTimeInit = 5.0;
		this.ChaseAttackPersistencyTimeInit = -1.0;
		this.ChaseAttackPersistencyTimeAdd = 2.0;
		this.ChaseNewTargetPersistencyTimeInit = -1.0;
		this.ChaseNewTargetPersistencyTimeAdd = 2.0;
		this.ChasePersistencyAddVisibleMin = 0.05;
		this.ChasePersistencyAddVisibleMax = 0.15;
		this.ChaseStunPersistencyTimeInit = -1.0;
		this.ChaseStunPersistencyTimeAdd = 2.0;

		this.StunEnabled = false;
		this.StunCooldown = 3.5;
		this.StunHealth = 0.0;
		this.StunHealthPerPlayer = 0.0;
		for (int i = 0; i < 10; i++)
		{
			this.StunHealthPerClass[i] = 0.0;
		}
		this.FlashlightStun = false;
		this.FlashlightDamage = 0.0;
		this.DisappearOnStun = false;
		this.ItemDropOnStun = false;
		this.StunItemDropType = 1;
		this.ChaseInitialOnStun = false;
		this.DamageResistances = null;

		this.KeyDrop = false;
		this.KeyModel = SF_KEYMODEL;
		this.KeyTrigger[0] = '\0';

		this.MemoryLifeTime = 10.0;

		this.AutoChaseEnabled = false;
		this.AutoChaseSprinters = false;
		this.SoundCountToAlert = 4;

		this.ChasesEndlessly = false;

		this.EarthquakeFootsteps = false;
		this.EarthquakeFootstepRadius = 1000.0;
		this.EarthquakeFootstepDuration = 1.0;
		this.EarthquakeFootstepAirShake = false;
		this.EarthquakeFootstepAmplitude = 5.0;
		this.EarthquakeFootstepFrequency = 25.0;

		this.CanCloak = false;
		this.CloakOnFlee = false;
		this.CloakParticle = "drg_cow_explosioncore_charged_blue";
		this.CloakRenderColor[0] = 0;
		this.CloakRenderColor[1] = 1;
		this.CloakRenderColor[2] = 2;
		this.CloakRenderColor[3] = 3;
		this.CloakRenderMode = 1;

		this.ProjectilesEnabled = false;
		this.ProjectileType = SF2BossProjectileType_Fireball;
		this.CriticalProjectiles = false;
		this.ShootGestures = false;
		this.ShootGestureName[0] = '\0';
		this.ShootAnimations = false;
		this.ProjectileClips = false;
		this.ChargeUpProjectiles = false;
		this.ProjectileRandomPosMin = 1;
		this.ProjectileRandomPosMax = 1;
		this.ProjectilePosOffsets = null;
		this.BaseballModel = BASEBALL_MODEL;

		this.AdvancedDamageEffects = false;
		this.AdvancedDamageEffectParticles = true;

		this.RandomAdvancedDamageEffects = false;
		this.RandomEffectIndexes = 1;
		this.RandomEffectIndexesString = "1";
		this.RandomEffectStunType = 0;

		this.JarateEffects = false;
		this.JarateIndexes = 1;
		this.JarateIndexesString = "1";
		this.JarateBeamParticle = false;
		this.JarateParticle = JARATE_PARTICLE;

		this.MilkEffects = false;
		this.MilkIndexes = 1;
		this.MilkIndexesString = "1";
		this.MilkBeamParaticle = false;
		this.MilkParticle = MILK_PARTICLE;

		this.GasEffects = false;
		this.GasIndexes = 1;
		this.GasIndexesString = "1";
		this.GasBeamParticle = false;
		this.GasParticle = GAS_PARTICLE;

		this.MarkEffects = false;
		this.MarkIndexes = 1;
		this.MarkIndexesString = "1";

		this.SilentMarkEffects = false;
		this.SilentMarkIndexes = 1;
		this.SilentMarkIndexesString = "1";

		this.IgniteEffects = false;
		this.IgniteIndexes = 1;
		this.IgniteIndexesString = "1";

		this.StunEffects = false;
		this.StunEffectIndexes = 1;
		this.StunEffectIndexesString = "1";
		this.StunEffectType = 0;
		this.StunEffectBeamParticle = false;
		this.StunParticle = STUN_PARTICLE;

		this.BleedEffects = false;
		this.BleedIndexes = 1;
		this.BleedIndexesString = "1";

		this.ElectricEffects = false;
		this.ElectricIndexes = 1;
		this.ElectricIndexesString = "1";
		this.ElectricType = 0;
		this.ElectricBeamParticle = false;
		this.ElectricParticleRed = ELECTRIC_RED_PARTICLE;
		this.ElectricParticleBlue = ELECTRIC_BLUE_PARTICLE;

		this.SmiteEffects = false;
		this.SmiteIndexes = 1;
		this.SmiteIndexesString = "1";
		this.SmiteDamage = 9001.0;
		this.SmiteDamageType = 1048576; //Critical cause we're mean
		this.SmiteColor[0] = 255;
		this.SmiteColor[1] = 255;
		this.SmiteColor[2] = 255;
		this.SmiteColor[3] = 255;
		this.SmiteMessage = false;

		this.XenobladeCombo = false;
		this.XenobladeDuration = 0.0;
		this.XenobladeToppleDuration = 0.0;
		this.XenobladeToppleSlowdown = 0.5;
		this.XenobladeDazeDuration = 0.0;

		this.Shockwaves = false;
		this.ShockwaveStun = false;
		this.ShockwaveIndexes = 1;
		this.ShockwaveIndexesString = "1";
		this.ShockwaveWidths[0] = 40.0;
		this.ShockwaveWidths[1] = 20.0;
		this.ShockwaveAmplitude = 5.0;
		this.ShockwaveAlpha1 = 255;
		this.ShockwaveAlpha2 = 255;
		this.ShockwaveBeamSprite = "sprites/laser.vmt";
		this.ShockwaveHaloSprite = "sprites/halo01.vmt";
		this.ShockwaveBeamModel = -1;
		this.ShockwaveHaloModel = -1;

		this.Traps = false;
		this.TrapType = 0;

		this.DamageParticles = false;
		this.DamageParticleName[0] = '\0';
		this.DamageParticleBeam = false;
		this.DamageParticleSound[0] = '\0';

		this.SelfHeal = false;
		this.SelfHealPercentageStart = 0.35;
		this.SelfHealRecover[0] = 0.75;
		this.SelfHealRecover[1] = 0.5;
		this.SelfHealRecover[2] = 0.25;
		this.CloakToHeal = false;

		this.BoxingBoss = false;

		this.NormalSoundHook = false;
		this.ChaseInitialAnimations = false;
		this.OldAnimationAI = false;
		this.AlertWalkingAnimation = false;
		this.SpawnAnimationsEnabled = false;

		this.Crawling = false;
		this.CrawlDetectMins = view_as<float>({0.0, 0.0, 0.0});
		this.CrawlDetectMaxs = view_as<float>({0.0, 0.0, 0.0});

		this.ChaseOnLook = false;

		this.UnnerfedVisibility = g_DefaultBossVisibilityStateConVar.BoolValue;

		this.ClearLayersOnAnimUpdate = true;

		this.HealAnimationTimer = 0.0;
		this.HealFunctionTimer = this.HealAnimationTimer;
		this.HealRangeMin = 600.0;
		this.HealRangeMax = 1200.0;
		this.HealTimeMin = 3.0;
		this.HealTimeMax = 4.5;

		this.AfterburnMultiplier = 1.0;
		this.BackstabDamageScale = 0.05;

		this.IdleSounds.Init();
		this.AlertSounds.Init();
		this.ChasingSounds.Init();
		this.ChaseInitialSounds.Init();
		this.AttackKilledSounds.Init();
		this.AttackKilledAllSounds.Init();
		this.AttackKilledClientSounds.Init();
		this.RageAllSounds.Init();
		this.RageTwoSounds.Init();
		this.RageThreeSounds.Init();
		this.SelfHealSounds.Init();
		this.StunnedSounds.Init();
		this.FootstepSounds.Init();
		this.AttackSounds = null;
		this.HitSounds = null;
		this.MissSounds = null;
		this.BulletShootSounds = null;
		this.ProjectileShootSounds = null;

		this.ChaseMusics.Init();
		this.ChaseMusics.Channel = MUSIC_CHAN;
		this.ChaseVisibleMusics.Init();
		this.ChaseVisibleMusics.Channel = MUSIC_CHAN;
		this.AlertMusics.Init();
		this.AlertMusics.Channel = MUSIC_CHAN;
		this.IdleMusics.Init();
		this.IdleMusics.Channel = MUSIC_CHAN;
		this.TwentyDollarsMusics.Init();
		this.TwentyDollarsMusics.Channel = MUSIC_CHAN;
	}

	void PostLoad()
	{
		this.IdleSounds.PostLoad();
		this.AlertSounds.PostLoad();
		this.ChasingSounds.PostLoad();
		this.ChaseInitialSounds.PostLoad();
		this.AttackKilledSounds.PostLoad();
		this.AttackKilledAllSounds.PostLoad();
		this.AttackKilledClientSounds.PostLoad();
		this.RageAllSounds.PostLoad();
		this.RageTwoSounds.PostLoad();
		this.RageThreeSounds.PostLoad();
		this.SelfHealSounds.PostLoad();
		this.StunnedSounds.PostLoad();
		this.FootstepSounds.PostLoad();

		this.ChaseMusics.PostLoad();
		this.ChaseVisibleMusics.PostLoad();
		this.AlertMusics.PostLoad();
		this.IdleMusics.PostLoad();
		this.TwentyDollarsMusics.PostLoad();

		if (this.ProjectilePosOffsets != null && this.ProjectilePosOffsets.Length <= 0)
		{
			delete this.ProjectilePosOffsets;
		}

		if (this.AttackSounds != null && this.AttackSounds.Length <= 0)
		{
			delete this.AttackSounds;
		}
		if (this.HitSounds != null && this.HitSounds.Length <= 0)
		{
			delete this.HitSounds;
		}
		if (this.MissSounds != null && this.MissSounds.Length <= 0)
		{
			delete this.MissSounds;
		}
		if (this.BulletShootSounds != null && this.BulletShootSounds.Length <= 0)
		{
			delete this.BulletShootSounds;
		}
		if (this.ProjectileShootSounds != null && this.ProjectileShootSounds.Length <= 0)
		{
			delete this.ProjectileShootSounds;
		}
	}

	void SortSoundSections(KeyValues kv, const char[] sectionName)
	{
		if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Idle]) == 0)
		{
			this.IdleSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Alert]) == 0)
		{
			this.AlertSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Chasing]) == 0)
		{
			this.ChasingSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_ChaseInitial]) == 0)
		{
			this.ChaseInitialSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_AttackKilled]) == 0)
		{
			this.AttackKilledSounds.Load(kv);
		}
		else if (strcmp(sectionName, "sound_attack_killed_all") == 0)
		{
			this.AttackKilledAllSounds.Load(kv);
		}
		else if (strcmp(sectionName, "sound_attack_killed_client") == 0)
		{
			this.AttackKilledClientSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageAll]) == 0)
		{
			this.RageAllSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageTwo]) == 0)
		{
			this.RageTwoSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageThree]) == 0)
		{
			this.RageThreeSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_SelfHeal]) == 0)
		{
			this.SelfHealSounds.Load(kv);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Stun]) == 0)
		{
			this.StunnedSounds.Load(kv);
		}
		else if (strcmp(sectionName, "sound_footsteps") == 0)
		{
			this.FootstepSounds.Load(kv);
		}
		else if (strcmp(sectionName, "sound_chase_music") == 0)
		{
			this.ChaseMusics.Load(kv);
		}
		else if (strcmp(sectionName, "sound_chase_visible") == 0)
		{
			this.ChaseVisibleMusics.Load(kv);
		}
		else if (strcmp(sectionName, "sound_alert_music") == 0)
		{
			this.AlertMusics.Load(kv);
		}
		else if (strcmp(sectionName, "sound_idle_music") == 0)
		{
			this.IdleMusics.Load(kv);
		}
		else if (strcmp(sectionName, "sound_20dollars") == 0 || strcmp(sectionName, "sound_20dollars_music") == 0)
		{
			this.TwentyDollarsMusics.Load(kv);
		}
	}

	void Destroy()
	{
		this.IdleSounds.Destroy();
		this.AlertSounds.Destroy();
		this.ChasingSounds.Destroy();
		this.ChaseInitialSounds.Destroy();
		this.AttackKilledSounds.Destroy();
		this.AttackKilledAllSounds.Destroy();
		this.AttackKilledClientSounds.Destroy();
		this.RageAllSounds.Destroy();
		this.RageTwoSounds.Destroy();
		this.RageThreeSounds.Destroy();
		this.SelfHealSounds.Destroy();
		this.StunnedSounds.Destroy();
		this.FootstepSounds.Destroy();

		this.ChaseMusics.Destroy();
		this.ChaseVisibleMusics.Destroy();
		this.AlertMusics.Destroy();
		this.IdleMusics.Destroy();
		this.TwentyDollarsMusics.Destroy();
		if (this.Attacks != null)
		{
			SF2ChaserBossProfileAttackData attackData;

			for (int i = 0; i < this.Attacks.Length; i++)
			{
				this.Attacks.GetArray(i, attackData, sizeof(attackData));

				if (attackData.Type == SF2BossAttackType_Invalid)
				{
					continue;
				}

				attackData.Destroy();
			}

			delete this.Attacks;
		}
		if (this.ProjectilePosOffsets != null)
		{
			delete this.ProjectilePosOffsets;
		}
		if (this.AttackPropModels != null)
		{
			delete this.AttackPropModels;
		}
		if (this.AttackSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.AttackSounds.Length; i++)
			{
				this.AttackSounds.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
		}
		if (this.HitSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.HitSounds.Length; i++)
			{
				this.HitSounds.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
		}
		if (this.MissSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.MissSounds.Length; i++)
			{
				this.MissSounds.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
		}
		if (this.BulletShootSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.BulletShootSounds.Length; i++)
			{
				this.BulletShootSounds.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
		}
		if (this.ProjectileShootSounds != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < this.ProjectileShootSounds.Length; i++)
			{
				this.ProjectileShootSounds.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
		}
		if (this.DamageResistances != null)
		{
			delete this.DamageResistances;
		}
	}
}
