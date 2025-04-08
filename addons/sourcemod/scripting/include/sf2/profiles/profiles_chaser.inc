#include <morecolors>

enum
{
	SF2BossAttackType_Invalid = -1,
	SF2BossAttackType_Melee = 0,
	SF2BossAttackType_Ranged = 1,
	SF2BossAttackType_Projectile = 2,
	SF2BossAttackType_ExplosiveDance = 3,
	SF2BossAttackType_LaserBeam = 4,
	SF2BossAttackType_Custom = 5,
	SF2BossAttackType_Tongue = 6
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
	SF2BossProjectileType_Custom
};

enum
{
	SF2BossTrapType_Invalid = -1,
	SF2BossTrapType_BearTrap = 0,
	SF2BossTrapType_Custom
};

enum
{
	SF2DamageType_Invalid = -1,
	SF2DamageType_Jarate = 0,
	SF2DamageType_Milk,
	SF2DamageType_Gas,
	SF2DamageType_Mark,
	SF2DamageType_Ignite,
	SF2DamageType_Stun,
	SF2DamageType_Bleed,
	SF2DamageType_Smite,
	SF2DamageType_Random
}

enum struct SF2BossProfileAttackGestureData // This one covers the gestures
{
	ArrayList Names;
	float Playbackrate[Difficulty_Max];
	float Cycle[Difficulty_Max];
	char SectionName[64];

	void Init(char optionalSectionName[64] = "")
	{
		this.Names = null;
		this.SectionName = optionalSectionName;

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Playbackrate[i] = 1.0;
			this.Cycle[i] = 0.0;
		}
	}

	void Load(KeyValues kv)
	{
		char animNames[Difficulty_Max][64];
		this.Names = new ArrayList(ByteCountToCells(64));
		this.Names.Resize(Difficulty_Max);

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

enum struct SF2ChaserBossProfileDamageEffectData // Can be any data
{
	int Type;
	bool Enabled[Difficulty_Max];
	float Duration[Difficulty_Max];
	SF2BossProfileSoundInfo Sounds;
	ArrayList Particles;

	bool MarkSilent[Difficulty_Max];

	float StunSlowdown[Difficulty_Max];
	ArrayList StunFlags;

	int SmiteSprite;
	int SmiteSmokeSprite;
	float SmiteDamage[Difficulty_Max];
	int SmiteDamageType[Difficulty_Max];
	int SmiteColor[4];
	bool SmiteMessage;
	char SmiteHitSound[PLATFORM_MAX_PATH];

	ArrayList Types;

	void Init()
	{
		this.Type = SF2DamageType_Invalid;
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
			this.Duration[i] = 8.0;

			this.MarkSilent[i] = false;

			this.StunSlowdown[i] = 0.5;

			this.SmiteDamage[i] = 9001.0;
			this.SmiteDamageType[i] = (1 << 20);
		}
		this.Sounds.Init();
		this.Particles = null;

		this.StunFlags = null;

		this.SmiteSprite = PrecacheModel("sprites/lgtning.vmt");
		this.SmiteSmokeSprite = PrecacheModel("sprites/steam1.vmt");
		for (int i = 0; i < 4; i++)
		{
			this.SmiteColor[i] = 255;
		}
		this.SmiteMessage = false;
		this.SmiteHitSound = SOUND_THUNDER;

		this.Types = null;
	}

	bool SetType(const char[] section)
	{
		if (strcmp(section, "ignite", false) == 0)
		{
			this.Type = SF2DamageType_Ignite;
		}
		else if (strcmp(section, "gas", false) == 0)
		{
			this.Type = SF2DamageType_Gas;
		}
		else if (strcmp(section, "bleed", false) == 0)
		{
			this.Type = SF2DamageType_Bleed;
		}
		else if (strcmp(section, "mark", false) == 0)
		{
			this.Type = SF2DamageType_Mark;
		}
		else if (strcmp(section, "jarate", false) == 0)
		{
			this.Type = SF2DamageType_Jarate;
		}
		else if (strcmp(section, "milk", false) == 0)
		{
			this.Type = SF2DamageType_Milk;
		}
		else if (strcmp(section, "stun", false) == 0)
		{
			this.Type = SF2DamageType_Stun;
		}
		else if (strcmp(section, "smite", false) == 0)
		{
			this.Type = SF2DamageType_Smite;
		}
		else if (strcmp(section, "random", false) == 0)
		{
			this.Types = new ArrayList();
			this.Type = SF2DamageType_Random;
		}

		if (this.Type == SF2DamageType_Invalid)
		{
			return false;
		}

		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}

		return true;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "duration", this.Duration, this.Duration);

		GetProfileDifficultyBoolValues(kv, "silent", this.MarkSilent, this.MarkSilent);

		char flags[Difficulty_Max][256];
		GetProfileDifficultyFloatValues(kv, "slow_multiplier", this.StunSlowdown, this.StunSlowdown);
		this.StunFlags = new ArrayList(ByteCountToCells(256));
		for (int i = 0; i < Difficulty_Max; i++)
		{
			flags[i] = "slow";
		}
		GetProfileDifficultyStringValues(kv, "flags", flags, sizeof(flags[]), flags);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.StunFlags.PushString(flags[i]);
		}

		GetProfileDifficultyFloatValues(kv, "damage", this.SmiteDamage, this.SmiteDamage);
		GetProfileDifficultyNumValues(kv, "damagetype", this.SmiteDamageType, this.SmiteDamageType);

		GetProfileColorNoBacks(kv, "color", this.SmiteColor[0], this.SmiteColor[1], this.SmiteColor[2], this.SmiteColor[3],
													this.SmiteColor[0], this.SmiteColor[1], this.SmiteColor[2], this.SmiteColor[3]);
		this.SmiteMessage = kv.GetNum("message", this.SmiteMessage) != 0;
		kv.GetString("hit_sound", this.SmiteHitSound, sizeof(this.SmiteHitSound), this.SmiteHitSound);

		if (this.Types != null)
		{
			char type[256];
			kv.GetString("random_types", type, sizeof(type));
			char types[32][32];
			int nums = ExplodeString(type, " ", types, sizeof(types), sizeof(types[]));
			for (int i = 0; i < nums; i++)
			{
				if (strcmp(types[i], "ignite", false) == 0)
				{
					this.Types.Push(SF2DamageType_Ignite);
				}
				else if (strcmp(types[i], "gas", false) == 0)
				{
					this.Types.Push(SF2DamageType_Gas);
				}
				else if (strcmp(types[i], "bleed", false) == 0)
				{
					this.Types.Push(SF2DamageType_Bleed);
				}
				else if (strcmp(types[i], "mark", false) == 0)
				{
					this.Types.Push(SF2DamageType_Mark);
				}
				else if (strcmp(types[i], "jarate", false) == 0)
				{
					this.Types.Push(SF2DamageType_Jarate);
				}
				else if (strcmp(types[i], "milk", false) == 0)
				{
					this.Types.Push(SF2DamageType_Milk);
				}
				else if (strcmp(types[i], "stun", false) == 0)
				{
					this.Types.Push(SF2DamageType_Stun);
				}
				else if (strcmp(types[i], "smite", false) == 0)
				{
					this.Types.Push(SF2DamageType_Smite);
				}
			}
		}

		if (kv.JumpToKey("sounds"))
		{
			this.Sounds.Load(kv, checkFile);
			kv.GoBack();
		}

		if (kv.JumpToKey("particles"))
		{
			this.Particles = new ArrayList(sizeof(SF2ParticleData));
			if (kv.GotoFirstSubKey())
			{
				do
				{
					SF2ParticleData particle;
					particle.Init();
					particle.Load(kv);
					this.Particles.PushArray(particle, sizeof(particle));
				}
				while (kv.GotoNextKey());
				kv.GoBack();
			}
			kv.GoBack();
		}
	}

	void PostLoad()
	{
		this.Sounds.PostLoad();
	}

	int GetStunType(int difficulty)
	{
		char flag[256];
		this.StunFlags.GetString(difficulty, flag, sizeof(flag));
		char flags[32][64];
		int nums = ExplodeString(flag, " ", flags, sizeof(flags), sizeof(flags[]));
		int value = 0;

		for (int i = 0; i < nums; i++)
		{
			if (strcmp(flags[i], "slow", false) == 0)
			{
				value |= (1 << 0);
			}
			else if (strcmp(flags[i], "stuck", false) == 0)
			{
				value |= (1 << 1);
			}
			else if (strcmp(flags[i], "cheer_fx", false) == 0)
			{
				value |= (1 << 3);
			}
			else if (strcmp(flags[i], "no_fx", false) == 0)
			{
				value |= (1 << 5);
			}
			else if (strcmp(flags[i], "thirdperson", false) == 0)
			{
				value |= (1 << 6);
			}
			else if (strcmp(flags[i], "ghost_fx", false) == 0)
			{
				value |= (1 << 7);
			}
			else if (strcmp(flags[i], "loser", false) == 0)
			{
				value |= (1 << 0) | (1 << 5) | (1 << 6);
			}
			else if (strcmp(flags[i], "boo", false) == 0)
			{
				value |= (1 << 7) | (1 << 6);
			}
		}

		return value;
	}

	void Destroy()
	{
		if (this.Particles != null)
		{
			delete this.Particles;
		}
		if (this.StunFlags != null)
		{
			delete this.StunFlags;
		}
		if (this.Types != null)
		{
			delete this.Types;
		}
		this.Sounds.Destroy();
	}

	void Apply(CBaseCombatCharacter player, int difficulty, SF2_ChaserBossEntity chaser = SF2_ChaserBossEntity(-1))
	{
		if (!this.Enabled[difficulty])
		{
			return;
		}
		this.Sounds.EmitSound(_, chaser.index);
		if (this.Particles != null)
		{
			SF2ParticleData particle;
			this.Particles.GetArray(GetRandomInt(0, this.Particles.Length - 1), particle, sizeof(particle));
			particle.Apply(player, chaser);
		}
		int type = this.Type;
		if (type == SF2DamageType_Random)
		{
			type = this.Types.Get(GetRandomInt(0, this.Types.Length - 1));
		}

		switch (type)
		{
			case SF2DamageType_Ignite:
			{
				TF2_IgnitePlayer(player.index, player.index, this.Duration[difficulty]);
			}
			case SF2DamageType_Gas:
			{
				TF2_AddCondition(player.index, TFCond_Gas, this.Duration[difficulty], player.index);
			}
			case SF2DamageType_Mark:
			{
				TF2_AddCondition(player.index, this.MarkSilent[difficulty] ? TFCond_MarkedForDeathSilent : TFCond_MarkedForDeath, this.Duration[difficulty], player.index);
			}
			case SF2DamageType_Bleed:
			{
				TF2_MakeBleed(player.index, player.index, this.Duration[difficulty]);
			}
			case SF2DamageType_Milk:
			{
				TF2_AddCondition(player.index, TFCond_Milked, this.Duration[difficulty], player.index);
			}
			case SF2DamageType_Jarate:
			{
				TF2_AddCondition(player.index, TFCond_Jarated, this.Duration[difficulty], player.index);
			}
			case SF2DamageType_Stun:
			{
				TF2_StunPlayer(player.index, this.Duration[difficulty], this.StunSlowdown[difficulty], this.GetStunType(difficulty));
			}
			case SF2DamageType_Smite:
			{
				float targetPos[3];
				player.GetAbsOrigin(targetPos);
				targetPos[2] -= 26.0;

				int randomX = GetRandomInt(-500, 500);
				int randomY = GetRandomInt(-500, 500);

				float startPos[3];
				startPos[0] = targetPos[0] + randomX;
				startPos[1] = targetPos[1] + randomY;
				startPos[2] = targetPos[2] + 800.0;

				float origin[3];
				TE_SetupBeamPoints(startPos, targetPos, this.SmiteSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, this.SmiteColor, 3);
				TE_SendToAll();

				TE_SetupSparks(targetPos, origin, 5000, 1000);
				TE_SendToAll();

				TE_SetupEnergySplash(targetPos, origin, false);
				TE_SendToAll();

				TE_SetupSmoke(targetPos, this.SmiteSmokeSprite, 5.0, 10);
				TE_SendToAll();

				EmitAmbientSound(this.SmiteHitSound, startPos, player.index, SNDLEVEL_SCREAMING);
				SDKHooks_TakeDamage(player.index, chaser.index, chaser.index, this.SmiteDamage[difficulty], this.SmiteDamageType[difficulty]);

				int controller = chaser.Controller;
				if (this.SmiteMessage && controller > -1 && GetClientTeam(player.index) == 2)
				{
					char playerName[32], bossName[SF2_MAX_NAME_LENGTH];
					GetClientName(player.index, playerName, sizeof(playerName));
					chaser.GetName(bossName, sizeof(bossName));
					CPrintToChatAll("{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Smote target", bossName, playerName);
				}
			}
		}
	}
}

enum struct SF2ChaserBossProfileShockwaveData
{
	bool Enabled;
	float Height[Difficulty_Max];
	float Radius[Difficulty_Max];
	float Force[Difficulty_Max];
	float BatteryDrainPercent[Difficulty_Max];
	float StaminaDrainPercent[Difficulty_Max];

	ArrayList Effects;
	ArrayList DamageEffects;

	void Init()
	{
		this.Enabled = false;
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Height[i] = 80.0;
			this.Radius[i] = 200.0;
			this.Force[i] = 600.0;
			this.BatteryDrainPercent[i] = 0.0;
			this.StaminaDrainPercent[i] = 0.0;
		}

		this.Effects = null;
		this.DamageEffects = null;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		this.Enabled = true;
		GetProfileDifficultyFloatValues(kv, "height", this.Height, this.Height);
		GetProfileDifficultyFloatValues(kv, "radius", this.Radius, this.Radius);
		GetProfileDifficultyFloatValues(kv, "force", this.Force, this.Force);
		GetProfileDifficultyFloatValues(kv, "battery_drain", this.BatteryDrainPercent, this.BatteryDrainPercent);
		GetProfileDifficultyFloatValues(kv, "stamina_drain", this.StaminaDrainPercent, this.StaminaDrainPercent);

		if (kv.JumpToKey("effects"))
		{
			this.Effects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
			if (kv.GotoFirstSubKey())
			{
				do
				{
					SF2BossProfileBaseEffectInfo effect;
					effect.Init();
					effect.Load(kv, checkFile);
					this.Effects.PushArray(effect);
				}
				while (kv.GotoNextKey());

				kv.GoBack();
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("apply_conditions"))
		{
			this.DamageEffects = new ArrayList(sizeof(SF2ChaserBossProfileDamageEffectData));
			if (kv.GotoFirstSubKey())
			{
				do
				{
					char section[64];
					SF2ChaserBossProfileDamageEffectData damageData;
					damageData.Init();
					kv.GetSectionName(section, sizeof(section));
					if (!damageData.SetType(section))
					{
						continue;
					}
					damageData.Load(kv, checkFile);
					this.DamageEffects.PushArray(damageData, sizeof(damageData));
				}
				while (kv.GotoNextKey());
				kv.GoBack();
			}
			kv.GoBack();
		}
	}

	void PostLoad()
	{
		if (this.Effects != null && this.Effects.Length <= 0)
		{
			delete this.Effects;
		}
		if (this.DamageEffects != null)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i = 0; i < this.DamageEffects.Length; i++)
			{
				this.DamageEffects.GetArray(i, damageData, sizeof(damageData));
				damageData.PostLoad();
			}
		}

		if (this.Effects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.Effects.Length; i++)
			{
				this.Effects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}
	}

	void Destroy()
	{
		if (this.Effects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.Effects.Length; i++)
			{
				this.Effects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.Effects;
		}
		if (this.DamageEffects != null)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i = 0; i < this.DamageEffects.Length; i++)
			{
				this.DamageEffects.GetArray(i, damageData, sizeof(damageData));
				damageData.Destroy();
			}
			delete this.DamageEffects;
		}
	}

	void ApplyDamageEffects(CBaseCombatCharacter player, int difficulty, SF2_ChaserBossEntity chaser = SF2_ChaserBossEntity(-1))
	{
		if (this.DamageEffects == null)
		{
			return;
		}

		if (!SF2_Player(player.index).IsValid)
		{
			return;
		}

		for (int i = 0; i < this.DamageEffects.Length; i++)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i2 = 0; i2 < this.DamageEffects.Length; i2++)
			{
				this.DamageEffects.GetArray(i2, damageData, sizeof(damageData));
				damageData.Apply(player, difficulty, chaser);
			}
		}
	}
}

enum struct SF2ChaserBossProfileAttackData
{
	int Index;
	char Name[64];

	int Type;

	bool CanUseAgainstProps;

	float Damage[Difficulty_Max];
	float DamagePercent[Difficulty_Max];
	float DamageVsProps;
	float DamageForce[Difficulty_Max];
	int DamageType[Difficulty_Max];
	float DamageDelay[Difficulty_Max];

	float Range[Difficulty_Max];
	float Duration[Difficulty_Max];
	float Spread[Difficulty_Max];
	float BeginRange[Difficulty_Max];
	float BeginFOV[Difficulty_Max];
	float PunchVelocity[3];

	float Cooldown[Difficulty_Max];

	bool Disappear[Difficulty_Max];
	bool DisappearOnHit[Difficulty_Max];
	int Repeat;
	int MaxRepeats;
	ArrayList RepeatTimers;

	bool IgnoreAlwaysLooking[Difficulty_Max];

	bool StartThroughWalls[Difficulty_Max];
	bool HitThroughWalls[Difficulty_Max];

	int WeaponInt;
	char WeaponString[PLATFORM_MAX_PATH];

	bool LifeSteal[Difficulty_Max];
	float LifeStealDuration[Difficulty_Max];

	float ProjectileDamage[Difficulty_Max];
	float ProjectileSpeed[Difficulty_Max];
	float ProjectileRadius[Difficulty_Max];
	float ProjectileDeviation[Difficulty_Max];
	int ProjectileCount[Difficulty_Max];
	bool CritProjectiles[Difficulty_Max];
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
	float LaserDuration[Difficulty_Max];
	float LaserNoise;
	float LaserOffset[3];
	char LaserAttachmentName[PLATFORM_MAX_PATH];
	float LaserTicks[Difficulty_Max];

	bool PullIn;

	float RunSpeed[Difficulty_Max];
	float RunDuration[Difficulty_Max];
	float RunDelay[Difficulty_Max];
	float RunAcceleration[Difficulty_Max];
	bool RunGroundSpeed[Difficulty_Max];

	int UseOnDifficulty;
	int BlockOnDifficulty;
	float UseOnHealth;
	float BlockOnHealth;

	float ExplosiveDanceRadius[Difficulty_Max];

	bool Gestures;

	bool DeathCamLowHealth;

	bool DontInterruptChaseInitial[Difficulty_Max];

	bool CancelLos[Difficulty_Max];
	float CancelDistance[Difficulty_Max];
	float MinCancelDistance[Difficulty_Max];

	int EventNumber;

	char SubType[64];

	SF2ChaserBossProfileShockwaveData Shockwave;

	ArrayList StartEffects;
	ArrayList HitEffects;
	ArrayList MissEffects;
	ArrayList KillEffects;
	ArrayList DamageEffects;

	bool ImmuneToDamage[Difficulty_Max];

	ArrayList PostureWhitelist;

	SF2BossProfileSoundInfo TongueLaunchSound;
	SF2BossProfileSoundInfo TongueHitSound;
	SF2BossProfileSoundInfo TongueTiedSound;
	float TongueSpeed[Difficulty_Max];
	float TonguePullScale[Difficulty_Max];
	bool TongueCanEscape[Difficulty_Max];
	char TongueMaterial[PLATFORM_MAX_PATH];
	char TongueAttachment[PLATFORM_MAX_PATH];
	float TongueOffset[3];

	SF2BossProfileMasterAnimationsData Animations;

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Damage[difficulty] = 50.0;
			this.DamagePercent[difficulty] = 0.0;
			this.DamageForce[difficulty] = 0.0;
			this.DamageType[difficulty] = 128;
			this.DamageDelay[difficulty] = 0.0;

			this.Range[difficulty] = 180.0;
			this.Duration[difficulty] = 0.0;
			this.Spread[difficulty] = 45.0;
			this.BeginRange[difficulty] = 80.0;
			this.BeginFOV[difficulty] = this.Spread[difficulty];

			this.Cooldown[difficulty] = 0.0;

			this.Disappear[difficulty] = false;
			this.DisappearOnHit[difficulty] = false;

			this.IgnoreAlwaysLooking[difficulty] = false;

			this.StartThroughWalls[difficulty] = false;
			this.HitThroughWalls[difficulty] = false;

			this.LifeSteal[difficulty] = false;
			this.LifeStealDuration[difficulty] = 0.0;

			this.ProjectileDamage[difficulty] = 20.0;
			this.ProjectileSpeed[difficulty] = 1100.0;
			this.ProjectileRadius[difficulty] = 128.0;
			this.ProjectileDeviation[difficulty] = 0.0;
			this.ProjectileCount[difficulty] = 1;
			this.CritProjectiles[difficulty] = false;

			this.IceballSlowdownPercent[difficulty] = 0.55;
			this.IceballSlowdownDuration[difficulty] = 2.0;

			this.BulletCount[difficulty] = 4;
			this.BulletDamage[difficulty] = 8.0;
			this.BulletSpread[difficulty] = 0.1;

			this.LaserDamage[difficulty] = 25.0;
			this.LaserDuration[difficulty] = this.Duration[difficulty];
			this.LaserTicks[difficulty] = 0.1;

			this.RunDuration[difficulty] = 0.0;
			this.RunDelay[difficulty] = 0.0;
			this.RunSpeed[difficulty] = 0.0;
			this.RunAcceleration[difficulty] = 4000.0;
			this.RunGroundSpeed[difficulty] = false;

			this.ExplosiveDanceRadius[difficulty] = 350.0;

			this.DontInterruptChaseInitial[difficulty] = false;

			this.CancelLos[difficulty] = false;
			this.CancelDistance[difficulty] = -1.0;
			this.MinCancelDistance[difficulty] = -1.0;

			this.ImmuneToDamage[difficulty] = false;

			this.TongueSpeed[difficulty] = 900.0;
			this.TonguePullScale[difficulty] = 6.0;
			this.TongueCanEscape[difficulty] = true;
		}
		for (int i = 0; i < 3; i++)
		{
			this.PunchVelocity[i] = 0.0;

			this.ProjectileOffset[i] = 0.0;

			this.BulletOffset[i] = 0.0;

			this.LaserColor[i] = 0;
			this.LaserOffset[i] = 0.0;

			this.TongueOffset[i] = 0.0;
		}
		this.Index = -1;
		this.Name[0] = '\0';

		this.Type = SF2BossAttackType_Melee;

		this.CanUseAgainstProps = false;

		this.DamageVsProps = this.Damage[1];

		this.Repeat = 0;
		this.MaxRepeats = 0;
		this.RepeatTimers = null;

		this.WeaponInt = 0;
		this.WeaponString[0] = '\0';

		this.ProjectileType = 0;
		this.FireballTrail = FIREBALL_TRAIL;
		this.IceballTrail = ICEBALL_TRAIL;
		this.RocketModel = ROCKET_MODEL;

		this.BulletTrace = "bullet_tracer02_blue";

		this.LaserSize = 12.0;
		this.LaserAttachment = false;
		this.LaserNoise = 1.0;
		this.LaserAttachmentName[0] = '\0';

		this.PullIn = false;

		this.UseOnDifficulty = 0;
		this.BlockOnDifficulty = 6;
		this.UseOnHealth = -1.0;
		this.BlockOnHealth = -1.0;

		this.Gestures = false;

		this.DeathCamLowHealth = false;

		this.EventNumber = -1;

		this.SubType[0] = '\0';

		this.Shockwave.Init();

		this.StartEffects = null;
		this.HitEffects = null;
		this.MissEffects = null;
		this.KillEffects = null;
		this.DamageEffects = null;

		this.PostureWhitelist = null;

		this.TongueLaunchSound.Init();
		this.TongueHitSound.Init();
		this.TongueTiedSound.Init();
		this.TongueMaterial[0] = '\0';
		this.TongueAttachment[0] = '\0';
	}

	void PostLoad()
	{
		this.Shockwave.PostLoad();
		if (this.StartEffects != null && this.StartEffects.Length <= 0)
		{
			delete this.StartEffects;
		}

		if (this.HitEffects != null && this.HitEffects.Length <= 0)
		{
			delete this.HitEffects;
		}

		if (this.MissEffects != null && this.MissEffects.Length <= 0)
		{
			delete this.MissEffects;
		}

		if (this.KillEffects != null && this.KillEffects.Length <= 0)
		{
			delete this.KillEffects;
		}

		if (this.DamageEffects != null)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i = 0; i < this.DamageEffects.Length; i++)
			{
				this.DamageEffects.GetArray(i, damageData, sizeof(damageData));
				damageData.PostLoad();
			}
		}

		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.HitEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.HitEffects.Length; i++)
			{
				this.HitEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.MissEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.MissEffects.Length; i++)
			{
				this.MissEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.KillEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.KillEffects.Length; i++)
			{
				this.KillEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.PostureWhitelist != null && this.PostureWhitelist.Length == 0)
		{
			delete this.PostureWhitelist;
		}

		this.TongueLaunchSound.PostLoad();
		this.TongueHitSound.PostLoad();
		this.TongueTiedSound.PostLoad();
	}

	void Destroy()
	{
		if (this.RepeatTimers != null)
		{
			delete this.RepeatTimers;
		}

		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.StartEffects;
		}

		if (this.HitEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.HitEffects.Length; i++)
			{
				this.HitEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.HitEffects;
		}

		if (this.MissEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.MissEffects.Length; i++)
			{
				this.MissEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.MissEffects;
		}

		if (this.KillEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.KillEffects.Length; i++)
			{
				this.KillEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.KillEffects;
		}

		if (this.DamageEffects != null)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i = 0; i < this.DamageEffects.Length; i++)
			{
				this.DamageEffects.GetArray(i, damageData, sizeof(damageData));
				damageData.Destroy();
			}
			delete this.DamageEffects;
		}
		this.Shockwave.Destroy();

		if (this.PostureWhitelist != null)
		{
			delete this.PostureWhitelist;
		}

		this.TongueLaunchSound.Destroy();
		this.TongueHitSound.Destroy();
		this.TongueTiedSound.Destroy();

		this.Animations.Destroy();
	}

	bool IsSubType(const char[] subType)
	{
		return strcmp(subType, this.SubType) == 0;
	}

	void ApplyDamageEffects(CBaseCombatCharacter player, int difficulty, SF2_ChaserBossEntity chaser = SF2_ChaserBossEntity(-1))
	{
		if (this.DamageEffects == null)
		{
			return;
		}

		if (!SF2_Player(player.index).IsValid)
		{
			return;
		}

		for (int i = 0; i < this.DamageEffects.Length; i++)
		{
			SF2ChaserBossProfileDamageEffectData damageData;
			for (int i2 = 0; i2 < this.DamageEffects.Length; i2++)
			{
				this.DamageEffects.GetArray(i2, damageData, sizeof(damageData));
				damageData.Apply(player, difficulty, chaser);
			}
		}
	}

	bool CanBeUsedWithPosture(const char[] posture)
	{
		if (this.PostureWhitelist == null)
		{
			return true;
		}

		return this.PostureWhitelist.FindString(posture) != -1;
	}
}

enum struct SF2ChaserBossProfileSoundSenseData
{
	int AddCount[Difficulty_Max];
	float Cooldown[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.AddCount[difficulty] = 2;
			this.Cooldown[difficulty] = 0.0;
		}
	}
}

enum struct SF2ChaserBossProfileSmellData
{
	bool Enabled[Difficulty_Max];
	float CooldownMin[Difficulty_Max];
	float CooldownMax[Difficulty_Max];
	float CooldownAfterStateMin[Difficulty_Max];
	float CooldownAfterStateMax[Difficulty_Max];
	int PlayerCount[Difficulty_Max];
	float PlayerRange[Difficulty_Max];
	float SmellRange[Difficulty_Max];
	bool ShouldChase[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.CooldownMin[difficulty] = 6.0;
			this.CooldownMax[difficulty] = 12.0;
			this.CooldownAfterStateMin[difficulty] = 16.0;
			this.CooldownAfterStateMax[difficulty] = 24.0;
			this.PlayerCount[difficulty] = 1;
			this.PlayerRange[difficulty] = 1000.0;
			this.SmellRange[difficulty] = 1500.0;
			this.ShouldChase[difficulty] = false;
		}
	}

	void Load(KeyValues kv)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "cooldown_min", this.CooldownMin, this.CooldownMin);
		GetProfileDifficultyFloatValues(kv, "cooldown_max", this.CooldownMax, this.CooldownMax);
		GetProfileDifficultyFloatValues(kv, "cooldown_after_state_min", this.CooldownAfterStateMin, this.CooldownAfterStateMin);
		GetProfileDifficultyFloatValues(kv, "cooldown_after_state_max", this.CooldownAfterStateMax, this.CooldownAfterStateMax);
		GetProfileDifficultyNumValues(kv, "required_players", this.PlayerCount, this.PlayerCount);
		GetProfileDifficultyFloatValues(kv, "required_player_range", this.PlayerRange, this.PlayerRange);
		GetProfileDifficultyFloatValues(kv, "smelling_range", this.SmellRange, this.SmellRange);
		GetProfileDifficultyBoolValues(kv, "should_chase_upon_smelled", this.ShouldChase, this.ShouldChase);
	}
}

enum struct SF2ChaserBossProfileStunData
{
	bool Enabled[Difficulty_Max];
	float Health[Difficulty_Max];
	float Cooldown[Difficulty_Max];
	bool Disappear[Difficulty_Max];

	bool FlashlightStun[Difficulty_Max];
	float FlashlightStunDamage[Difficulty_Max];

	bool ChaseInitialOnEnd[Difficulty_Max];

	bool KeyDrop;
	char KeyModel[PLATFORM_MAX_PATH];
	char KeyTrigger[PLATFORM_MAX_PATH];

	bool ItemDrop[Difficulty_Max];
	int ItemDropType[Difficulty_Max];

	float AddHealthPerPlayer[Difficulty_Max];
	float AddHealthPerScout[Difficulty_Max];
	float AddHealthPerSoldier[Difficulty_Max];
	float AddHealthPerPyro[Difficulty_Max];
	float AddHealthPerDemoman[Difficulty_Max];
	float AddHealthPerHeavy[Difficulty_Max];
	float AddHealthPerEngineer[Difficulty_Max];
	float AddHealthPerMedic[Difficulty_Max];
	float AddHealthPerSniper[Difficulty_Max];
	float AddHealthPerSpy[Difficulty_Max];
	float AddHealthPerStun[Difficulty_Max];
	float AddSpeedPerStun[Difficulty_Max];
	float AddAccelerationPerStun[Difficulty_Max];

	ArrayList StartEffects;
	ArrayList EndEffects;

	void Init()
	{
		this.KeyDrop = false;
		this.KeyModel = SF_KEYMODEL;
		this.KeyTrigger[0] = '\0';

		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.Health[difficulty] = 50.0;
			this.Cooldown[difficulty] = 3.5;
			this.Disappear[difficulty] = false;

			this.FlashlightStun[difficulty] = false;
			this.FlashlightStunDamage[difficulty] = 0.0;

			this.ChaseInitialOnEnd[difficulty] = false;

			this.ItemDrop[difficulty] = false;
			this.ItemDropType[difficulty] = 1;

			this.AddHealthPerPlayer[difficulty] = 0.0;
			this.AddHealthPerScout[difficulty] = 0.0;
			this.AddHealthPerSoldier[difficulty] = 0.0;
			this.AddHealthPerPyro[difficulty] = 0.0;
			this.AddHealthPerDemoman[difficulty] = 0.0;
			this.AddHealthPerHeavy[difficulty] = 0.0;
			this.AddHealthPerEngineer[difficulty] = 0.0;
			this.AddHealthPerMedic[difficulty] = 0.0;
			this.AddHealthPerSniper[difficulty] = 0.0;
			this.AddHealthPerSpy[difficulty] = 0.0;
			this.AddHealthPerStun[difficulty] = 0.0;
			this.AddSpeedPerStun[difficulty] = 0.0;
			this.AddAccelerationPerStun[difficulty] = 0.0;
		}

		this.StartEffects = null;
		this.EndEffects = null;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "health", this.Health, this.Health);
		GetProfileDifficultyFloatValues(kv, "cooldown", this.Cooldown, this.Cooldown);
		GetProfileDifficultyBoolValues(kv, "disappear", this.Disappear, this.Disappear);

		if (kv.JumpToKey("flashlight_stun"))
		{
			for (int i = 0; i < Difficulty_Max; i++)
			{
				this.FlashlightStun[i] = true;
			}
			GetProfileDifficultyBoolValues(kv, "enabled", this.FlashlightStun, this.FlashlightStun);
			GetProfileDifficultyFloatValues(kv, "damage", this.FlashlightStunDamage, this.FlashlightStunDamage);
			kv.GoBack();
		}

		GetProfileDifficultyBoolValues(kv, "chase_initial_on_end", this.ChaseInitialOnEnd, this.ChaseInitialOnEnd);

		this.KeyDrop = kv.GetNum("key_drop", this.KeyDrop) != 0;
		kv.GetString("key_model", this.KeyModel, sizeof(this.KeyModel), this.KeyModel);
		PrecacheModel2(this.KeyModel, _, _, checkFile);
		kv.GetString("key_trigger", this.KeyTrigger, sizeof(this.KeyTrigger), this.KeyTrigger);

		GetProfileDifficultyBoolValues(kv, "item_drop", this.ItemDrop, this.ItemDrop);
		GetProfileDifficultyNumValues(kv, "item_drop_type", this.ItemDropType, this.ItemDropType);

		if (kv.JumpToKey("effects"))
		{
			if (kv.JumpToKey("on_start"))
			{
				this.StartEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.StartEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			if (kv.JumpToKey("on_end"))
			{
				this.EndEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.EndEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("add_health"))
		{
			GetProfileDifficultyFloatValues(kv, "player", this.AddHealthPerPlayer, this.AddHealthPerPlayer);
			GetProfileDifficultyFloatValues(kv, "scout", this.AddHealthPerScout, this.AddHealthPerScout);
			GetProfileDifficultyFloatValues(kv, "soldier", this.AddHealthPerSoldier, this.AddHealthPerSoldier);
			GetProfileDifficultyFloatValues(kv, "pyro", this.AddHealthPerPyro, this.AddHealthPerPyro);
			GetProfileDifficultyFloatValues(kv, "demoman", this.AddHealthPerDemoman, this.AddHealthPerDemoman);
			GetProfileDifficultyFloatValues(kv, "heavy", this.AddHealthPerHeavy, this.AddHealthPerHeavy);
			GetProfileDifficultyFloatValues(kv, "engineer", this.AddHealthPerEngineer, this.AddHealthPerEngineer);
			GetProfileDifficultyFloatValues(kv, "medic", this.AddHealthPerMedic, this.AddHealthPerMedic);
			GetProfileDifficultyFloatValues(kv, "sniper", this.AddHealthPerSniper, this.AddHealthPerSniper);
			GetProfileDifficultyFloatValues(kv, "spy", this.AddHealthPerSpy, this.AddHealthPerSpy);
			GetProfileDifficultyFloatValues(kv, "on_stun", this.AddHealthPerStun, this.AddHealthPerStun);
			kv.GoBack();
		}

		GetProfileDifficultyFloatValues(kv, "add_speed", this.AddSpeedPerStun, this.AddSpeedPerStun);
		GetProfileDifficultyFloatValues(kv, "add_acceleration", this.AddAccelerationPerStun, this.AddAccelerationPerStun);
	}

	void PostLoad()
	{
		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.EndEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.EndEffects.Length; i++)
			{
				this.EndEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}
	}

	void Destroy()
	{
		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.StartEffects;
		}

		if (this.EndEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.EndEffects.Length; i++)
			{
				this.EndEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.EndEffects;
		}
	}
}

enum struct SF2ChaserBossProfileDeathData
{
	bool Enabled[Difficulty_Max];
	float Health[Difficulty_Max];
	bool RemoveOnDeath;
	bool DisappearOnDeath;
	bool RagdollOnDeath;

	bool KeyDrop;
	char KeyModel[PLATFORM_MAX_PATH];
	char KeyTrigger[PLATFORM_MAX_PATH];

	bool ItemDrop[Difficulty_Max];
	int ItemDropType[Difficulty_Max];

	float AddHealthPerPlayer[Difficulty_Max];
	float AddHealthPerScout[Difficulty_Max];
	float AddHealthPerSoldier[Difficulty_Max];
	float AddHealthPerPyro[Difficulty_Max];
	float AddHealthPerDemoman[Difficulty_Max];
	float AddHealthPerHeavy[Difficulty_Max];
	float AddHealthPerEngineer[Difficulty_Max];
	float AddHealthPerMedic[Difficulty_Max];
	float AddHealthPerSniper[Difficulty_Max];
	float AddHealthPerSpy[Difficulty_Max];
	float AddHealthPerDeath[Difficulty_Max];

	ArrayList Gibs;
	int GibSkin;

	ArrayList StartEffects;
	ArrayList EndEffects;

	void Init()
	{
		this.RemoveOnDeath = false;
		this.DisappearOnDeath = false;
		this.RagdollOnDeath = false;

		this.KeyDrop = false;
		this.KeyModel = SF_KEYMODEL;
		this.KeyTrigger[0] = '\0';

		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.Health[difficulty] = 400.0;

			this.ItemDrop[difficulty] = false;
			this.ItemDropType[difficulty] = 1;

			this.AddHealthPerPlayer[difficulty] = 0.0;
			this.AddHealthPerScout[difficulty] = 0.0;
			this.AddHealthPerSoldier[difficulty] = 0.0;
			this.AddHealthPerPyro[difficulty] = 0.0;
			this.AddHealthPerDemoman[difficulty] = 0.0;
			this.AddHealthPerHeavy[difficulty] = 0.0;
			this.AddHealthPerEngineer[difficulty] = 0.0;
			this.AddHealthPerMedic[difficulty] = 0.0;
			this.AddHealthPerSniper[difficulty] = 0.0;
			this.AddHealthPerSpy[difficulty] = 0.0;
			this.AddHealthPerDeath[difficulty] = 0.0;
		}

		this.Gibs = null;
		this.GibSkin = 0;

		this.StartEffects = null;
		this.EndEffects = null;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "health", this.Health, this.Health);
		this.RemoveOnDeath = kv.GetNum("remove", this.RemoveOnDeath) != 0;
		this.DisappearOnDeath = kv.GetNum("disappear", this.DisappearOnDeath) != 0;
		this.RagdollOnDeath = kv.GetNum("become_ragdoll", this.RagdollOnDeath) != 0;

		this.KeyDrop = kv.GetNum("key_drop", this.KeyDrop) != 0;
		kv.GetString("key_model", this.KeyModel, sizeof(this.KeyModel), this.KeyModel);
		PrecacheModel2(this.KeyModel, _, _, checkFile);
		kv.GetString("key_trigger", this.KeyTrigger, sizeof(this.KeyTrigger), this.KeyTrigger);

		GetProfileDifficultyBoolValues(kv, "item_drop", this.ItemDrop, this.ItemDrop);
		GetProfileDifficultyNumValues(kv, "item_drop_type", this.ItemDropType, this.ItemDropType);

		if (kv.JumpToKey("effects"))
		{
			if (kv.JumpToKey("on_start"))
			{
				this.StartEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.StartEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			if (kv.JumpToKey("on_end"))
			{
				this.EndEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.EndEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("add_health"))
		{
			GetProfileDifficultyFloatValues(kv, "player", this.AddHealthPerPlayer, this.AddHealthPerPlayer);
			GetProfileDifficultyFloatValues(kv, "scout", this.AddHealthPerScout, this.AddHealthPerScout);
			GetProfileDifficultyFloatValues(kv, "soldier", this.AddHealthPerSoldier, this.AddHealthPerSoldier);
			GetProfileDifficultyFloatValues(kv, "pyro", this.AddHealthPerPyro, this.AddHealthPerPyro);
			GetProfileDifficultyFloatValues(kv, "demoman", this.AddHealthPerDemoman, this.AddHealthPerDemoman);
			GetProfileDifficultyFloatValues(kv, "heavy", this.AddHealthPerHeavy, this.AddHealthPerHeavy);
			GetProfileDifficultyFloatValues(kv, "engineer", this.AddHealthPerEngineer, this.AddHealthPerEngineer);
			GetProfileDifficultyFloatValues(kv, "medic", this.AddHealthPerMedic, this.AddHealthPerMedic);
			GetProfileDifficultyFloatValues(kv, "sniper", this.AddHealthPerSniper, this.AddHealthPerSniper);
			GetProfileDifficultyFloatValues(kv, "spy", this.AddHealthPerSpy, this.AddHealthPerSpy);
			GetProfileDifficultyFloatValues(kv, "on_death", this.AddHealthPerDeath, this.AddHealthPerDeath);
			kv.GoBack();
		}

		if (kv.JumpToKey("gibs"))
		{
			this.GibSkin = kv.GetNum("skin", this.GibSkin);
			this.Gibs = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
			char value[PLATFORM_MAX_PATH], key[64];
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				kv.GetString(key, value, sizeof(value));
				if (value[0] == '\0')
				{
					break;
				}
				PrecacheModel2(value, _, _, checkFile);
				this.Gibs.PushString(value);
			}
			kv.GoBack();
		}
	}

	void PostLoad()
	{
		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.EndEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.EndEffects.Length; i++)
			{
				this.EndEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}
	}

	void Destroy()
	{
		if (this.Gibs != null)
		{
			delete this.Gibs;
		}

		if (this.StartEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.StartEffects.Length; i++)
			{
				this.StartEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.StartEffects;
		}

		if (this.EndEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.EndEffects.Length; i++)
			{
				this.EndEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.EndEffects;
		}
	}
}

enum struct SF2ChaserBossProfileChaseOnLookData
{
	bool Enabled[Difficulty_Max];
	bool AddTargets[Difficulty_Max];
	float RequiredLookPosition[3];
	float MinimumXAngle[Difficulty_Max];
	float MaximumXAngle[Difficulty_Max];
	float MinimumYAngle[Difficulty_Max];
	float MaximumYAngle[Difficulty_Max];
	float RequiredYAngle[Difficulty_Max];
	float RequiredFOV[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.AddTargets[difficulty] = true;
			this.MinimumXAngle[difficulty] = -45.0;
			this.MaximumXAngle[difficulty] = 180.0;
			this.MinimumYAngle[difficulty] = 0.0;
			this.MaximumYAngle[difficulty] = 105.0;
			this.RequiredFOV[difficulty] = -1.0;
		}
		this.RequiredLookPosition[2] = 35.0;
		for (int i = 0; i < 2; i++)
		{
			this.RequiredLookPosition[i] = 0.0;
		}
	}

	void Load(KeyValues kv)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyBoolValues(kv, "add_targets", this.AddTargets, this.AddTargets);
		kv.GetVector("look_position", this.RequiredLookPosition, this.RequiredLookPosition);
		GetProfileDifficultyFloatValues(kv, "minimum_x_angle", this.MinimumXAngle, this.MinimumXAngle);
		GetProfileDifficultyFloatValues(kv, "maximum_x_angle", this.MaximumXAngle, this.MaximumXAngle);
		GetProfileDifficultyFloatValues(kv, "minimum_y_angle", this.MinimumYAngle, this.MinimumYAngle);
		GetProfileDifficultyFloatValues(kv, "maximum_y_angle", this.MaximumYAngle, this.MaximumYAngle);
		GetProfileDifficultyFloatValues(kv, "required_fov", this.RequiredFOV, this.RequiredFOV);
	}
}

enum struct SF2PostureConditionWithinBoundsInfo
{
	bool Enabled;
	float Mins[3];
	float Maxs[3];

	void Init()
	{
		this.Enabled = false;
		for (int i = 0; i < 3; i++)
		{
			this.Mins[0] = 0.0;
			this.Maxs[0] = 0.0;
		}
	}

	void Load(KeyValues kv)
	{
		this.Enabled = true;
		kv.GetVector("mins", this.Mins, this.Mins);
		kv.GetVector("maxs", this.Maxs, this.Maxs);
	}
}

enum struct SF2PostureConditionRunAwayInfo
{
	bool Enabled;

	void Init()
	{
		this.Enabled = false;
	}

	void Load()
	{
		this.Enabled = true;
	}
}

enum struct SF2PostureConditionRagePhase
{
	bool Enabled;
	ArrayList Names;

	void Init()
	{
		this.Enabled = false;
		this.Names = null;
	}

	void Load(KeyValues kv)
	{
		this.Enabled = true;
		this.Names = new ArrayList(ByteCountToCells(64));
		char value[1024];
		kv.GetString("phases", value, sizeof(value), value);
		char phase[64][64];
		int maxLength = ExplodeString(value, " ", phase, sizeof(phase), sizeof(phase));
		for (int i = 0; i < maxLength; i++)
		{
			this.Names.PushString(phase[i]);
		}
	}

	void Destroy()
	{
		if (this.Names != null)
		{
			delete this.Names;
		}
	}
}

enum struct SF2PostureConditionWithinRangeInfo
{
	bool Enabled[Difficulty_Max];
	float MinRange[Difficulty_Max];
	float MaxRange[Difficulty_Max];
	float Cooldown[Difficulty_Max];
	float CurrentCooldown;

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
			this.MinRange[i] = 0.0;
			this.MaxRange[i] = 512.0;
			this.Cooldown[i] = 1.0;
		}
		this.CurrentCooldown = 0.0;
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "min_range", this.MinRange, this.MinRange);
		GetProfileDifficultyFloatValues(kv, "max_range", this.MaxRange, this.MaxRange);
		GetProfileDifficultyFloatValues(kv, "cooldown", this.Cooldown, this.Cooldown);
	}
}

enum struct SF2PostureConditionLookAtInfo
{
	bool Enabled[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
		}
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
	}
}

enum struct SF2PostureConditionAlertInfo
{
	bool Enabled[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
		}
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
	}
}

enum struct SF2PostureConditionCloakInfo
{
	bool Enabled[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
		}
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
	}
}

enum struct SF2ChaserBossProfilePostureInfo
{
	char Name[64];
	float Speed[Difficulty_Max];
	float WalkSpeed[Difficulty_Max];
	float Acceleration[Difficulty_Max];
	SF2BossProfileMasterAnimationsData Animations;
	SF2PostureConditionWithinBoundsInfo BoundsInfo;
	SF2PostureConditionRunAwayInfo RunAwayInfo;
	SF2PostureConditionRagePhase RagePhaseInfo;
	SF2PostureConditionWithinRangeInfo RangeInfo;
	SF2PostureConditionLookAtInfo LookAtInfo;
	SF2PostureConditionAlertInfo AlertInfo;
	SF2PostureConditionCloakInfo CloakInfo;

	void Init()
	{
		this.Name[0] = '\0';
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Speed[i] = 300.0;
			this.WalkSpeed[i] = 100.0;
			this.Acceleration[i] = 4000.0;
		}
		this.Animations.Init();
		this.BoundsInfo.Init();
		this.RunAwayInfo.Init();
		this.RagePhaseInfo.Init();
		this.RangeInfo.Init();
		this.LookAtInfo.Init();
		this.AlertInfo.Init();
		this.CloakInfo.Init();
	}

	void Load(KeyValues kv)
	{
		kv.GetSectionName(this.Name, sizeof(this.Name));
		GetProfileDifficultyFloatValues(kv, "speed", this.Speed, this.Speed);
		GetProfileDifficultyFloatValues(kv, "walkspeed", this.WalkSpeed, this.WalkSpeed);
		GetProfileDifficultyFloatValues(kv, "acceleration", this.Acceleration, this.Acceleration);
		this.Animations.Load(kv, false);
		if (kv.JumpToKey("conditions"))
		{
			if (kv.JumpToKey("within_bounds"))
			{
				this.BoundsInfo.Load(kv);
				kv.GoBack();
			}

			if (kv.JumpToKey("running_away"))
			{
				this.RunAwayInfo.Load();
				kv.GoBack();
			}

			if (kv.JumpToKey("in_phases"))
			{
				this.RagePhaseInfo.Load(kv);
				kv.GoBack();
			}

			if (kv.JumpToKey("within_range"))
			{
				this.RangeInfo.Load(kv);
				kv.GoBack();
			}

			if (kv.JumpToKey("on_look"))
			{
				this.LookAtInfo.Load(kv);
				kv.GoBack();
			}

			if (kv.JumpToKey("on_alert"))
			{
				this.AlertInfo.Load(kv);
				kv.GoBack();
			}

			if (kv.JumpToKey("on_cloak"))
			{
				this.CloakInfo.Load(kv);
				kv.GoBack();
			}
			kv.GoBack();
		}
	}

	void Destroy()
	{
		this.Animations.Destroy();
		this.RagePhaseInfo.Destroy();
	}
}

enum struct SF2ChaserBossProfileAlertOnAlertInfo
{
	bool Enabled[Difficulty_Max];
	bool OnChangeState[Difficulty_Max];
	float Radius[Difficulty_Max];
	bool ShouldBeVisible[Difficulty_Max];
	bool Follow[Difficulty_Max];
	float FollowCooldown[Difficulty_Max];
	bool Patrol[Difficulty_Max];
	float PatrolDurationMin[Difficulty_Max];
	float PatrolDurationMax[Difficulty_Max];
	float PatrolRadiusMin[Difficulty_Max];
	float PatrolRadiusMax[Difficulty_Max];
	bool Copies[Difficulty_Max];
	bool Companions[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.OnChangeState[difficulty] = true;
			this.Radius[difficulty] = 1024.0;
			this.ShouldBeVisible[difficulty] = false;
			this.Follow[difficulty] = false;
			this.FollowCooldown[difficulty] = 10.0;
			this.Patrol[difficulty] = false;
			this.PatrolDurationMin[difficulty] = 10.0;
			this.PatrolDurationMax[difficulty] = 15.0;
			this.PatrolRadiusMin[difficulty] = 750.0;
			this.PatrolRadiusMax[difficulty] = 1500.0;
			this.Copies[difficulty] = false;
			this.Companions[difficulty] = false;
		}
	}

	void Load(KeyValues kv)
	{
		if (kv.JumpToKey("sync"))
		{
			GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
			GetProfileDifficultyBoolValues(kv, "on_change_state", this.OnChangeState, this.OnChangeState);
			GetProfileDifficultyFloatValues(kv, "radius", this.Radius, this.Radius);
			GetProfileDifficultyBoolValues(kv, "should_be_visible", this.ShouldBeVisible, this.ShouldBeVisible);
			GetProfileDifficultyBoolValues(kv, "follow_leader", this.Follow, this.Follow);
			GetProfileDifficultyFloatValues(kv, "follow_cooldown", this.FollowCooldown, this.FollowCooldown);
			GetProfileDifficultyBoolValues(kv, "copies", this.Copies, this.Copies);
			GetProfileDifficultyBoolValues(kv, "companions", this.Companions, this.Companions);

			if (kv.JumpToKey("patrol"))
			{
				GetProfileDifficultyBoolValues(kv, "enabled", this.Patrol, this.Patrol);
				GetProfileDifficultyFloatValues(kv, "duration_min", this.PatrolDurationMin, this.PatrolDurationMin);
				GetProfileDifficultyFloatValues(kv, "duration_max", this.PatrolDurationMax, this.PatrolDurationMax);
				GetProfileDifficultyFloatValues(kv, "radius_min", this.PatrolRadiusMin, this.PatrolRadiusMin);
				GetProfileDifficultyFloatValues(kv, "radius_max", this.PatrolRadiusMax, this.PatrolRadiusMax);

				kv.GoBack();
			}

			kv.GoBack();
		}
	}
}

enum struct SF2ChaserBossProfileAlertOnChaseInfo
{
	bool Enabled[Difficulty_Max];
	bool OnChangeState[Difficulty_Max];
	float Radius[Difficulty_Max];
	bool ShouldBeVisible[Difficulty_Max];
	bool Follow[Difficulty_Max];
	float FollowCooldown[Difficulty_Max];
	bool Copies[Difficulty_Max];
	bool Companions[Difficulty_Max];

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.Enabled[difficulty] = false;
			this.OnChangeState[difficulty] = true;
			this.Radius[difficulty] = 1024.0;
			this.ShouldBeVisible[difficulty] = false;
			this.Follow[difficulty] = false;
			this.FollowCooldown[difficulty] = 10.0;
			this.Copies[difficulty] = false;
			this.Companions[difficulty] = false;
		}
	}

	void Load(KeyValues kv)
	{
		if (kv.JumpToKey("chase_together"))
		{
			GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
			GetProfileDifficultyBoolValues(kv, "on_change_state", this.OnChangeState, this.OnChangeState);
			GetProfileDifficultyFloatValues(kv, "radius", this.Radius, this.Radius);
			GetProfileDifficultyBoolValues(kv, "should_be_visible", this.ShouldBeVisible, this.ShouldBeVisible);
			GetProfileDifficultyBoolValues(kv, "follow_leader", this.Follow, this.Follow);
			GetProfileDifficultyFloatValues(kv, "follow_cooldown", this.FollowCooldown, this.FollowCooldown);
			GetProfileDifficultyBoolValues(kv, "copies", this.Copies, this.Copies);
			GetProfileDifficultyBoolValues(kv, "companions", this.Companions, this.Companions);

			kv.GoBack();
		}
	}
}

enum struct SF2ChaserRageInfo
{
	char Name[64];
	float PercentageThreshold;

	bool IncreaseDifficulty;

	bool Invincible;

	SF2BossProfileSoundInfo StartSounds;
	SF2BossProfileSoundInfo HealSounds;

	bool IsHealing;
	bool HealCloak;
	float FleeRange[2];
	float HealAmount;
	float HealDelay;
	float HealDuration;

	SF2BossProfileMasterAnimationsData Animations;

	void Init()
	{
		this.Name[0] = '\0';
		this.PercentageThreshold = 0.75;
		this.IncreaseDifficulty = true;
		this.Invincible = false;

		this.StartSounds.Init();
		this.HealSounds.Init();

		this.IsHealing = false;
		this.HealCloak = false;
		this.FleeRange[0] = 512.0;
		this.FleeRange[1] = 1024.0;
		this.HealAmount = 0.5;
		this.HealDelay = 0.0;
		this.HealDuration = 1.0;

		this.Animations.Init();
	}

	void Load(KeyValues kv, bool checkFile)
	{
		kv.GetSectionName(this.Name, sizeof(this.Name));
		this.PercentageThreshold = kv.GetFloat("health_percent", this.PercentageThreshold);
		this.IncreaseDifficulty = kv.GetNum("increase_difficulty", this.IncreaseDifficulty) != 0;
		this.Invincible = kv.GetNum("invincible", this.Invincible) != 0;

		if (kv.JumpToKey("heal"))
		{
			this.IsHealing = true;
			this.HealCloak = kv.GetNum("cloak", this.HealCloak) != 0;
			this.FleeRange[0] = kv.GetFloat("flee_range_min", this.FleeRange[0]);
			this.FleeRange[1] = kv.GetFloat("flee_range_max", this.FleeRange[1]);
			this.HealAmount = kv.GetFloat("amount", this.HealAmount);
			this.HealDelay = kv.GetFloat("delay", this.HealDelay);
			this.HealDuration = kv.GetFloat("duration", this.HealDuration);
			kv.GoBack();
		}

		if (kv.JumpToKey("sounds"))
		{
			if (kv.JumpToKey("start"))
			{
				this.StartSounds.Load(kv, checkFile);
				kv.GoBack();
			}

			if (kv.JumpToKey("healing"))
			{
				this.HealSounds.Load(kv, checkFile);
				kv.GoBack();
			}

			kv.GoBack();
		}

		this.Animations.Load(kv, false);
	}

	void PostLoad()
	{
		this.StartSounds.PostLoad();
		this.HealSounds.PostLoad();
	}

	void Destroy()
	{
		this.StartSounds.Destroy();
		this.HealSounds.Destroy();
		this.Animations.Destroy();
	}
}

enum struct SF2ChaserBossProfileCloakData
{
	bool Enabled[Difficulty_Max];
	float Duration[Difficulty_Max];
	float Cooldown[Difficulty_Max];
	float CloakRange[Difficulty_Max];
	float DecloakRange[Difficulty_Max];
	int CloakRenderColor[4];
	int CloakRenderMode;
	ArrayList CloakEffects;
	ArrayList DecloakEffects;

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
			this.Cooldown[i] = 8.0;
			this.Duration[i] = 10.0;
			this.CloakRange[i] = 350.0;
			this.DecloakRange[i] = 150.0;
		}

		this.CloakRenderColor[0] = 0;
		this.CloakRenderColor[1] = 0;
		this.CloakRenderColor[2] = 0;
		this.CloakRenderColor[3] = 0;
		this.CloakRenderMode = 1;
		this.CloakEffects = null;
		this.DecloakEffects = null;
	}

	void Load(KeyValues kv, bool checkFile)
	{
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "duration", this.Duration, this.Duration);
		GetProfileDifficultyFloatValues(kv, "cooldown", this.Cooldown, this.Cooldown);
		GetProfileDifficultyFloatValues(kv, "cloak_range", this.CloakRange, this.CloakRange);
		GetProfileDifficultyFloatValues(kv, "decloak_range", this.DecloakRange, this.DecloakRange);

		GetProfileColorNoBacks(kv, "color", this.CloakRenderColor[0], this.CloakRenderColor[1], this.CloakRenderColor[2], this.CloakRenderColor[3],
							this.CloakRenderColor[0], this.CloakRenderColor[1], this.CloakRenderColor[2], this.CloakRenderColor[3]);
		this.CloakRenderMode = kv.GetNum("rendermode", this.CloakRenderMode);

		if (kv.JumpToKey("effects"))
		{
			if (kv.JumpToKey("cloak"))
			{
				this.CloakEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.CloakEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}

				kv.GoBack();
			}

			if (kv.JumpToKey("decloak"))
			{
				this.DecloakEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, checkFile);
						this.DecloakEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}

				kv.GoBack();
			}

			kv.GoBack();
		}
	}

	void PostLoad()
	{
		if (this.CloakEffects != null && this.CloakEffects.Length <= 0)
		{
			delete this.CloakEffects;
		}

		if (this.DecloakEffects != null && this.DecloakEffects.Length <= 0)
		{
			delete this.DecloakEffects;
		}

		if (this.CloakEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.CloakEffects.Length; i++)
			{
				this.CloakEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}

		if (this.DecloakEffects != null)
		{
			SF2BossProfileBaseEffectInfo effects;

			for (int i = 0; i < this.DecloakEffects.Length; i++)
			{
				this.DecloakEffects.GetArray(i, effects, sizeof(effects));
				effects.PostLoad();
			}
		}
	}

	void Destroy()
	{
		if (this.CloakEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.CloakEffects.Length; i++)
			{
				this.CloakEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.CloakEffects;
		}

		if (this.DecloakEffects != null)
		{
			SF2BossProfileBaseEffectInfo effect;

			for (int i = 0; i < this.DecloakEffects.Length; i++)
			{
				this.DecloakEffects.GetArray(i, effect, sizeof(effect));
				effect.Destroy();
			}
			delete this.DecloakEffects;
		}
	}
}

enum struct SF2ChaserBossProfileIdleData
{
	bool TurnEnabled[Difficulty_Max];
	float TurnAngle[Difficulty_Max];
	float TurnMinTime[Difficulty_Max];
	float TurnMaxTime[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.TurnEnabled[i] = true;
			this.TurnAngle[i] = 360.0;
			this.TurnMinTime[i] = 1.5;
			this.TurnMaxTime[i] = 3.0;
		}
	}

	void Load(KeyValues kv)
	{
		if (kv.JumpToKey("turn"))
		{
			GetProfileDifficultyBoolValues(kv, "enabled", this.TurnEnabled, this.TurnEnabled);
			GetProfileDifficultyFloatValues(kv, "angle", this.TurnAngle, this.TurnAngle);
			GetProfileDifficultyFloatValues(kv, "cooldown_min", this.TurnMinTime, this.TurnMinTime);
			GetProfileDifficultyFloatValues(kv, "cooldown_max", this.TurnMaxTime, this.TurnMaxTime);
			kv.GoBack();
		}
	}
}

enum struct SF2ChaserBossProfileAlertData
{
	float GraceTime[Difficulty_Max];
	float Duration[Difficulty_Max];
	bool RunOnWander[Difficulty_Max];
	bool RunOnSuspect[Difficulty_Max];

	bool TurnEnabled[Difficulty_Max];
	float TurnAngle[Difficulty_Max];
	float TurnMinTime[Difficulty_Max];
	float TurnMaxTime[Difficulty_Max];

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Duration[i] = 10.0;
			this.GraceTime[i] = 0.5;
			this.RunOnSuspect[i] = false;
			this.RunOnWander[i] = false;

			this.TurnEnabled[i] = true;
			this.TurnAngle[i] = 360.0;
			this.TurnMinTime[i] = 1.5;
			this.TurnMaxTime[i] = 3.0;
		}
	}

	void Load(KeyValues kv)
	{
		GetProfileDifficultyFloatValues(kv, "gracetime", this.GraceTime, this.GraceTime);
		GetProfileDifficultyFloatValues(kv, "duration", this.Duration, this.Duration);
		GetProfileDifficultyBoolValues(kv, "run_on_wander", this.RunOnWander, this.RunOnWander);
		GetProfileDifficultyBoolValues(kv, "run_on_suspect", this.RunOnSuspect, this.RunOnSuspect);

		if (kv.JumpToKey("turn"))
		{
			GetProfileDifficultyBoolValues(kv, "enabled", this.TurnEnabled, this.TurnEnabled);
			GetProfileDifficultyFloatValues(kv, "angle", this.TurnAngle, this.TurnAngle);
			GetProfileDifficultyFloatValues(kv, "cooldown_min", this.TurnMinTime, this.TurnMinTime);
			GetProfileDifficultyFloatValues(kv, "cooldown_max", this.TurnMaxTime, this.TurnMaxTime);
			kv.GoBack();
		}
	}
}

enum struct SF2ChaserBossProfileResistanceData
{
	bool Enabled[Difficulty_Max];
	float Multiplier[Difficulty_Max];

	ArrayList DamageTypes;
	ArrayList HitboxGroups;
	ArrayList Weapons;

	void Init()
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = false;
			this.Multiplier[i] = 1.0;
		}

		this.DamageTypes = null;
		this.HitboxGroups = null;
		this.Weapons = null;
	}

	void Load(KeyValues kv)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.Enabled[i] = true;
		}
		GetProfileDifficultyBoolValues(kv, "enabled", this.Enabled, this.Enabled);
		GetProfileDifficultyFloatValues(kv, "multiplier", this.Multiplier, this.Multiplier);
		char key[64];
		int resistance = -1;
		if (kv.JumpToKey("damage_type"))
		{
			this.DamageTypes = new ArrayList();
			resistance = -1;
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				resistance = kv.GetNum(key, -1);
				if (resistance == -1)
				{
					break;
				}
				this.DamageTypes.Push(resistance);
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("hitbox"))
		{
			this.HitboxGroups = new ArrayList();
			resistance = -1;
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				resistance = kv.GetNum(key, -1);
				if (resistance == -1)
				{
					break;
				}
				this.HitboxGroups.Push(resistance);
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("weapon"))
		{
			this.Weapons = new ArrayList();
			resistance = -1;
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				resistance = kv.GetNum(key, -1);
				if (resistance == -1)
				{
					break;
				}
				this.Weapons.Push(resistance);
			}
			kv.GoBack();
		}
	}

	void Destroy()
	{
		if (this.DamageTypes != null)
		{
			delete this.DamageTypes;
		}

		if (this.HitboxGroups != null)
		{
			delete this.HitboxGroups;
		}

		if (this.Weapons != null)
		{
			delete this.Weapons;
		}
	}
}

enum struct SF2ChaserBossProfileData
{
	float WalkSpeed[Difficulty_Max];

	float WakeRadius;

	ArrayList Attacks;

	ArrayList AttackPropModels;

	float ChaseDuration[Difficulty_Max];
	float ChaseDurationAddMaxRange[Difficulty_Max];
	float ChaseDurationAddVisibleMin[Difficulty_Max];
	float ChaseDurationAddVisibleMax[Difficulty_Max];
	float ChaseDurationAddOnAttack[Difficulty_Max];
	float ChaseDurationAddOnStun[Difficulty_Max];

	int SoundCountToAlert[Difficulty_Max];
	float SoundPosDiscardTime[Difficulty_Max];
	float SoundPosDistanceTolerance[Difficulty_Max];
	SF2ChaserBossProfileSoundSenseData FootstepSenses;
	SF2ChaserBossProfileSoundSenseData LoudFootstepSenses;
	SF2ChaserBossProfileSoundSenseData QuietFootstepSenses;
	SF2ChaserBossProfileSoundSenseData VoiceSenses;
	SF2ChaserBossProfileSoundSenseData WeaponSenses;
	SF2ChaserBossProfileSoundSenseData FlashlightSenses;

	SF2ChaserBossProfileSmellData SmellData;

	bool CanWander[Difficulty_Max];
	float WanderRangeMin[Difficulty_Max];
	float WanderRangeMax[Difficulty_Max];
	float WanderTimeMin[Difficulty_Max];
	float WanderTimeMax[Difficulty_Max];
	float WanderEnterTimeMin[Difficulty_Max];
	float WanderEnterTimeMax[Difficulty_Max];

	ArrayList DamageResistances;

	SF2ChaserBossProfileStunData StunData;
	SF2ChaserBossProfileDeathData DeathData;

	bool KeyDrop;
	char KeyModel[PLATFORM_MAX_PATH];
	char KeyTrigger[PLATFORM_MAX_PATH];

	bool AutoChaseEnabled[Difficulty_Max];
	int AutoChaseCount[Difficulty_Max];
	int AutoChaseAdd[Difficulty_Max];
	int AutoChaseAddFootstep[Difficulty_Max];
	int AutoChaseAddLoudFootstep[Difficulty_Max];
	int AutoChaseAddQuietFootstep[Difficulty_Max];
	int AutoChaseAddVoice[Difficulty_Max];
	int AutoChaseAddWeapon[Difficulty_Max];
	bool AutoChaseSprinters[Difficulty_Max];
	float AutoChaseAfterChaseCooldown[Difficulty_Max];

	bool ChasesEndlessly;

	bool EarthquakeFootsteps;
	float EarthquakeFootstepRadius;
	float EarthquakeFootstepDuration;
	bool EarthquakeFootstepAirShake;
	float EarthquakeFootstepAmplitude;
	float EarthquakeFootstepFrequency;

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
	bool ProjectileClips;
	int ProjectileClipSize[Difficulty_Max];
	float ProjectileReloadTime[Difficulty_Max];
	bool ChargeUpProjectiles;
	float ProjectileChargeUp[Difficulty_Max];
	int ProjectileCount[Difficulty_Max];
	int ProjectileRandomPosMin;
	int ProjectileRandomPosMax;
	ArrayList ProjectilePosOffsets;
	char FireballExplodeSound[PLATFORM_MAX_PATH];
	char FireballShootSound[PLATFORM_MAX_PATH];
	char FireballTrail[PLATFORM_MAX_PATH];
	char RocketTrail[PLATFORM_MAX_PATH];
	char RocketExplodeParticle[PLATFORM_MAX_PATH];
	char RocketModel[PLATFORM_MAX_PATH];
	char IceballSlowSound[PLATFORM_MAX_PATH];
	char IceballTrail[PLATFORM_MAX_PATH];
	char RocketExplodeSound[PLATFORM_MAX_PATH];
	char RocketShootSound[PLATFORM_MAX_PATH];
	char GrenadeShootSound[PLATFORM_MAX_PATH];
	char SentryRocketShootSound[PLATFORM_MAX_PATH];
	char ArrowShootSound[PLATFORM_MAX_PATH];
	char ManglerShootSound[PLATFORM_MAX_PATH];
	char BaseballShootSound[PLATFORM_MAX_PATH];
	char BaseballModel[PLATFORM_MAX_PATH];

	float IceballSlowDuration[Difficulty_Max];
	float IceballSlowPercent[Difficulty_Max];

	bool XenobladeCombo;
	float XenobladeDuration;
	float XenobladeToppleDuration;
	float XenobladeToppleSlowdown;
	float XenobladeDazeDuration;

	bool Traps[Difficulty_Max];
	int TrapType[Difficulty_Max];
	float TrapCooldown[Difficulty_Max];
	char TrapModel[PLATFORM_MAX_PATH];
	char TrapDeploySound[PLATFORM_MAX_PATH];
	char TrapMissSound[PLATFORM_MAX_PATH];
	char TrapCatchSound[PLATFORM_MAX_PATH];
	char TrapAnimIdle[PLATFORM_MAX_PATH];
	char TrapAnimClose[PLATFORM_MAX_PATH];
	char TrapAnimOpen[PLATFORM_MAX_PATH];

	ArrayList Rages;

	bool BoxingBoss;

	bool NormalSoundHook;
	bool OldAnimationAI;

	SF2ChaserBossProfileChaseOnLookData ChaseOnLookData;

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
	SF2BossProfileSoundInfo StunnedSounds;
	SF2BossProfileSoundInfo DeathSounds;
	SF2BossProfileSoundInfo TauntKillSounds;
	SF2BossProfileSoundInfo SmellSounds;
	SF2BossProfileSoundInfo FootstepSounds;
	SF2BossProfileSoundInfo SelfHealSounds;
	SF2BossProfileSoundInfo RageSounds1;
	SF2BossProfileSoundInfo RageSounds2;
	SF2BossProfileSoundInfo RageSounds3;
	SF2BossProfileSoundInfo DespawnSounds;
	ArrayList AttackSounds;
	ArrayList HitSounds;
	ArrayList MissSounds;
	ArrayList BulletShootSounds;
	ArrayList ProjectileShootSounds;
	ArrayList AttackBeginSounds;
	ArrayList AttackEndSounds;
	ArrayList AttackLoopSounds;

	SF2BossProfileSoundInfo ChaseMusics;
	SF2BossProfileSoundInfo ChaseVisibleMusics;
	SF2BossProfileSoundInfo AlertMusics;
	SF2BossProfileSoundInfo IdleMusics;

	StringMap Postures;

	SF2ChaserBossProfileAlertOnAlertInfo AlertOnAlertInfo;
	SF2ChaserBossProfileAlertOnChaseInfo AlertOnChaseInfo;

	SF2ChaserBossProfileCloakData CloakData;

	SF2ChaserBossProfileIdleData IdleData;
	SF2ChaserBossProfileAlertData AlertData;

	void Init()
	{
		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.WalkSpeed[difficulty] = 90.0;

			this.ChaseDuration[difficulty] = 10.0;
			this.ChaseDurationAddMaxRange[difficulty] = 1024.0;
			this.ChaseDurationAddVisibleMin[difficulty] = 0.01;
			this.ChaseDurationAddVisibleMax[difficulty] = 0.05;
			this.ChaseDurationAddOnAttack[difficulty] = 0.0;
			this.ChaseDurationAddOnStun[difficulty] = 0.0;

			this.SoundCountToAlert[difficulty] = 8;
			this.SoundPosDiscardTime[difficulty] = 2.0;
			this.SoundPosDistanceTolerance[difficulty] = 512.0;

			this.CanWander[difficulty] = true;
			this.WanderRangeMin[difficulty] = 800.0;
			this.WanderRangeMax[difficulty] = 1600.0;
			this.WanderTimeMin[difficulty] = 8.0;
			this.WanderTimeMax[difficulty] = 12.0;
			this.WanderEnterTimeMin[difficulty] = 2.0;
			this.WanderEnterTimeMax[difficulty] = 4.5;

			this.AutoChaseEnabled[difficulty] = false;
			this.AutoChaseCount[difficulty] = 100;
			this.AutoChaseAdd[difficulty] = 0;
			this.AutoChaseAddFootstep[difficulty] = 2;
			this.AutoChaseAddLoudFootstep[difficulty] = this.AutoChaseAddFootstep[difficulty];
			this.AutoChaseAddQuietFootstep[difficulty] = 0;
			this.AutoChaseAddVoice[difficulty] = 8;
			this.AutoChaseAddWeapon[difficulty] = 4;
			this.AutoChaseSprinters[difficulty] = false;
			this.AutoChaseAfterChaseCooldown[difficulty] = 3.0;

			this.ProjectileCooldownMin[difficulty] = 1.0;
			this.ProjectileCooldownMax[difficulty] = 2.0;
			this.ProjectileSpeed[difficulty] = 400.0;
			this.ProjectileDamage[difficulty] = 50.0;
			this.ProjectileRadius[difficulty] = 128.0;
			this.ProjectileDeviation[difficulty] = 0.0;
			this.ProjectileClipSize[difficulty] = 3;
			this.ProjectileReloadTime[difficulty] = 2.0;
			this.ProjectileChargeUp[difficulty] = 5.0;
			this.ProjectileCount[difficulty] = 1;

			this.IceballSlowDuration[difficulty] = 2.0;
			this.IceballSlowPercent[difficulty] = 0.55;

			this.Traps[difficulty] = false;
			this.TrapType[difficulty] = 0;
			this.TrapCooldown[difficulty] = 8.0;
		}

		this.WakeRadius = 0.0;

		this.Attacks = null;

		this.AttackPropModels = null;

		this.FootstepSenses.Init();
		this.LoudFootstepSenses.Init();
		this.QuietFootstepSenses.Init();
		this.VoiceSenses.Init();
		this.WeaponSenses.Init();
		this.FlashlightSenses.Init();

		this.SmellData.Init();

		for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
		{
			this.FootstepSenses.AddCount[difficulty] = 1;
			this.LoudFootstepSenses.AddCount[difficulty] = 2;
			this.QuietFootstepSenses.AddCount[difficulty] = 0;

			this.VoiceSenses.AddCount[difficulty] = 10;
			this.WeaponSenses.AddCount[difficulty] = 5;
			this.FlashlightSenses.AddCount[difficulty] = 5;
		}

		this.DamageResistances = null;

		this.StunData.Init();
		this.DeathData.Init();

		this.KeyDrop = false;
		this.KeyModel = SF_KEYMODEL;
		this.KeyTrigger[0] = '\0';

		this.ChasesEndlessly = false;

		this.EarthquakeFootsteps = false;
		this.EarthquakeFootstepRadius = 1000.0;
		this.EarthquakeFootstepDuration = 1.0;
		this.EarthquakeFootstepAirShake = false;
		this.EarthquakeFootstepAmplitude = 5.0;
		this.EarthquakeFootstepFrequency = 25.0;

		this.ProjectilesEnabled = false;
		this.ProjectileType = SF2BossProjectileType_Fireball;
		this.CriticalProjectiles = false;
		this.ShootGestures = false;
		this.ShootGestureName[0] = '\0';
		this.ProjectileClips = false;
		this.ChargeUpProjectiles = false;
		this.ProjectileRandomPosMin = 1;
		this.ProjectileRandomPosMax = 1;
		this.ProjectilePosOffsets = null;
		this.FireballExplodeSound = FIREBALL_IMPACT;
		this.FireballShootSound = FIREBALL_SHOOT;
		this.FireballTrail = FIREBALL_TRAIL;
		this.RocketTrail = ROCKET_TRAIL;
		this.RocketExplodeParticle = ROCKET_EXPLODE_PARTICLE;
		this.RocketModel = ROCKET_MODEL;
		this.IceballSlowSound = ICEBALL_IMPACT;
		this.IceballTrail = ICEBALL_TRAIL;
		this.RocketExplodeSound = ROCKET_IMPACT;
		this.RocketShootSound = ROCKET_SHOOT;
		this.GrenadeShootSound = GRENADE_SHOOT;
		this.SentryRocketShootSound = SENTRYROCKET_SHOOT;
		this.ArrowShootSound = ARROW_SHOOT;
		this.ManglerShootSound = MANGLER_SHOOT;
		this.BaseballShootSound = BASEBALL_SHOOT;
		this.BaseballModel = BASEBALL_MODEL;

		this.XenobladeCombo = false;
		this.XenobladeDuration = 0.0;
		this.XenobladeToppleDuration = 0.0;
		this.XenobladeToppleSlowdown = 0.5;
		this.XenobladeDazeDuration = 0.0;

		this.TrapModel = TRAP_MODEL;
		this.TrapDeploySound = TRAP_DEPLOY;
		this.TrapMissSound = TRAP_CLOSE;
		this.TrapCatchSound = TRAP_CLOSE;
		this.TrapAnimIdle = "trapopenend";
		this.TrapAnimClose = "trapclosed";
		this.TrapAnimOpen[0] = '\0';

		this.Rages = null;

		this.BoxingBoss = false;

		this.NormalSoundHook = false;
		this.OldAnimationAI = false;

		this.ChaseOnLookData.Init();

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
		this.AttackKilledSounds.Channel = SNDCHAN_STATIC;
		this.AttackKilledSounds.Level = SNDLEVEL_HELICOPTER;
		this.AttackKilledAllSounds.Init();
		this.AttackKilledAllSounds.Channel = SNDCHAN_STATIC;
		this.AttackKilledAllSounds.Level = SNDLEVEL_HELICOPTER;
		this.AttackKilledClientSounds.Init();
		this.AttackKilledClientSounds.Channel = SNDCHAN_STATIC;
		this.AttackKilledClientSounds.Level = SNDLEVEL_HELICOPTER;
		this.StunnedSounds.Init();
		this.DeathSounds.Init();
		this.TauntKillSounds.Init();
		this.SmellSounds.Init();
		this.SelfHealSounds.Init();
		this.RageSounds1.Init();
		this.RageSounds2.Init();
		this.RageSounds3.Init();
		this.DespawnSounds.Init();
		this.FootstepSounds.Init();
		this.AttackSounds = null;
		this.HitSounds = null;
		this.MissSounds = null;
		this.BulletShootSounds = null;
		this.ProjectileShootSounds = null;
		this.AttackBeginSounds = null;
		this.AttackEndSounds = null;
		this.AttackLoopSounds = null;

		this.ChaseMusics.Init();
		this.ChaseMusics.Channel = MUSIC_CHAN;
		this.ChaseVisibleMusics.Init();
		this.ChaseVisibleMusics.Channel = MUSIC_CHAN;
		this.AlertMusics.Init();
		this.AlertMusics.Channel = MUSIC_CHAN;
		this.IdleMusics.Init();
		this.IdleMusics.Channel = MUSIC_CHAN;

		this.Postures = null;

		this.AlertOnAlertInfo.Init();
		this.AlertOnChaseInfo.Init();

		this.CloakData.Init();

		this.IdleData.Init();
		this.AlertData.Init();
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
		this.StunnedSounds.PostLoad();
		this.DeathSounds.PostLoad();
		this.TauntKillSounds.PostLoad();
		this.SmellSounds.PostLoad();
		this.SelfHealSounds.PostLoad();
		this.RageSounds1.PostLoad();
		this.RageSounds2.PostLoad();
		this.RageSounds3.PostLoad();
		this.DespawnSounds.PostLoad();
		this.FootstepSounds.PostLoad();

		this.ChaseMusics.PostLoad();
		this.ChaseVisibleMusics.PostLoad();
		this.AlertMusics.PostLoad();
		this.IdleMusics.PostLoad();

		this.CloakData.PostLoad();

		this.StunData.PostLoad();
		this.DeathData.PostLoad();

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

		if (this.AttackBeginSounds != null && this.AttackBeginSounds.Length <= 0)
		{
			delete this.AttackBeginSounds;
		}

		if (this.AttackEndSounds != null && this.AttackEndSounds.Length <= 0)
		{
			delete this.AttackEndSounds;
		}

		if (this.AttackLoopSounds != null && this.AttackLoopSounds.Length <= 0)
		{
			delete this.AttackLoopSounds;
		}

		if (this.Rages != null)
		{
			SF2ChaserRageInfo rageData;

			for (int i = 0; i < this.Rages.Length; i++)
			{
				this.Rages.GetArray(i, rageData, sizeof(rageData));

				rageData.PostLoad();
			}
		}

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

				attackData.PostLoad();
			}
		}
	}

	void SortSoundSections(KeyValues kv, const char[] sectionName, bool checkFile)
	{
		if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Idle]) == 0)
		{
			this.IdleSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Alert]) == 0)
		{
			this.AlertSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Chasing]) == 0)
		{
			this.ChasingSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_ChaseInitial]) == 0)
		{
			this.ChaseInitialSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_AttackKilled]) == 0)
		{
			this.AttackKilledSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_attack_killed_all") == 0)
		{
			this.AttackKilledAllSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_attack_killed_client") == 0)
		{
			this.AttackKilledClientSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Stun]) == 0)
		{
			this.StunnedSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Death]) == 0)
		{
			this.DeathSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_TauntKill]) == 0)
		{
			this.TauntKillSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Smell]) == 0)
		{
			this.SmellSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_SelfHeal]) == 0)
		{
			this.SelfHealSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageAll]) == 0)
		{
			this.RageSounds1.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageTwo]) == 0)
		{
			this.RageSounds2.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_RageThree]) == 0)
		{
			this.RageSounds3.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, g_SlenderVoiceList[SF2BossSound_Despawn]) == 0)
		{
			this.DespawnSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_footsteps") == 0)
		{
			this.FootstepSounds.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_chase_music") == 0)
		{
			this.ChaseMusics.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_chase_visible") == 0)
		{
			this.ChaseVisibleMusics.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_alert_music") == 0)
		{
			this.AlertMusics.Load(kv, checkFile);
		}
		else if (strcmp(sectionName, "sound_idle_music") == 0)
		{
			this.IdleMusics.Load(kv, checkFile);
		}
	}

	void LoadNestedSoundSections(const char[] section, KeyValues kv, bool checkFile, ArrayList &list, bool soundHook = false, SF2ChaserBossProfileData data)
	{
		list = new ArrayList(sizeof(SF2BossProfileSoundInfo));
		bool classic = false;
		kv.GoBack();
		for (int i = 0; i < data.Attacks.Length; i++)
		{
			char formatter[90];
			SF2ChaserBossProfileAttackData attackData;
			data.Attacks.GetArray(i, attackData, sizeof(attackData));
			if (strcmp(attackData.Name, "1") == 0)
			{
				continue;
			}
			FormatEx(formatter, sizeof(formatter), "%s_%s", section, attackData.Name);

			if (kv.JumpToKey(formatter))
			{
				classic = true;
				kv.GoBack();
				break;
			}
		}
		if (classic)
		{
			for (int i = 0; i < data.Attacks.Length; i++)
			{
				char formatter[90];
				SF2ChaserBossProfileAttackData attackData;
				data.Attacks.GetArray(i, attackData, sizeof(attackData));
				if (strcmp(attackData.Name, "1") == 0)
				{
					FormatEx(formatter, sizeof(formatter), "%s", section);
				}
				else
				{
					FormatEx(formatter, sizeof(formatter), "%s_%s", section, attackData.Name);
				}

				if (kv.JumpToKey(formatter))
				{
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					if (soundHook)
					{
						soundInfo.Channel = SNDCHAN_VOICE;
					}
					soundInfo.Load(kv, checkFile);
					soundInfo.PostLoad();
					strcopy(soundInfo.SectionName, sizeof(soundInfo.SectionName), attackData.Name);
					if (soundInfo.Paths != null)
					{
						list.PushArray(soundInfo, sizeof(soundInfo));
					}
					kv.GoBack();
				}
			}
			return;
		}
		else
		{
			kv.JumpToKey(section);
		}
		if (kv.GotoFirstSubKey())
		{
			char sectionName[64];
			kv.GetSectionName(sectionName, sizeof(sectionName));
			if (strcmp(sectionName, "paths") == 0)
			{
				kv.GoBack();
				SF2BossProfileSoundInfo soundInfo;
				soundInfo.Init();
				if (soundHook)
				{
					soundInfo.Channel = SNDCHAN_VOICE;
				}
				soundInfo.Load(kv, checkFile);
				soundInfo.PostLoad();
				soundInfo.SectionName[0] = '\0';
				if (soundInfo.Paths != null)
				{
					list.PushArray(soundInfo, sizeof(soundInfo));
				}
			}
			else
			{
				do
				{
					kv.GetSectionName(sectionName, sizeof(sectionName));
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					if (soundHook)
					{
						soundInfo.Channel = SNDCHAN_VOICE;
					}
					soundInfo.SectionName = sectionName;
					soundInfo.Load(kv, checkFile);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						list.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				while (kv.GotoNextKey());
				kv.GoBack();
			}

		}
		else
		{
			SF2BossProfileSoundInfo soundInfo;
			soundInfo.Init();
			if (soundHook)
			{
				soundInfo.Channel = SNDCHAN_VOICE;
			}
			soundInfo.Load(kv, checkFile);
			soundInfo.PostLoad();
			soundInfo.SectionName[0] = '\0';
			if (soundInfo.Paths != null)
			{
				list.PushArray(soundInfo, sizeof(soundInfo));
			}
		}
		kv.GoBack();
	}

	void DestroyNestedSection(ArrayList list)
	{
		if (list != null)
		{
			SF2BossProfileSoundInfo soundInfo;

			for (int i = 0; i < list.Length; i++)
			{
				list.GetArray(i, soundInfo, sizeof(soundInfo));

				if (soundInfo.Paths == null)
				{
					continue;
				}
				soundInfo.Destroy();
			}
			delete list;
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
		this.StunnedSounds.Destroy();
		this.DeathSounds.Destroy();
		this.TauntKillSounds.Destroy();
		this.SmellSounds.Destroy();
		this.SelfHealSounds.Destroy();
		this.RageSounds1.Destroy();
		this.RageSounds2.Destroy();
		this.RageSounds3.Destroy();
		this.DespawnSounds.Destroy();
		this.FootstepSounds.Destroy();

		this.ChaseMusics.Destroy();
		this.ChaseVisibleMusics.Destroy();
		this.AlertMusics.Destroy();
		this.IdleMusics.Destroy();

		this.CloakData.Destroy();

		this.StunData.Destroy();
		this.DeathData.Destroy();

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

		if (this.DamageResistances != null)
		{
			SF2ChaserBossProfileResistanceData resistanceData;

			for (int i = 0; i < this.DamageResistances.Length; i++)
			{
				this.DamageResistances.GetArray(i, resistanceData, sizeof(resistanceData));

				resistanceData.Destroy();
			}

			delete this.DamageResistances;
		}

		this.DestroyNestedSection(this.AttackSounds);
		this.DestroyNestedSection(this.HitSounds);
		this.DestroyNestedSection(this.MissSounds);
		this.DestroyNestedSection(this.BulletShootSounds);
		this.DestroyNestedSection(this.ProjectileShootSounds);
		this.DestroyNestedSection(this.AttackBeginSounds);
		this.DestroyNestedSection(this.AttackEndSounds);
		this.DestroyNestedSection(this.AttackLoopSounds);

		if (this.Rages != null)
		{
			SF2ChaserRageInfo rageData;

			for (int i = 0; i < this.Rages.Length; i++)
			{
				this.Rages.GetArray(i, rageData, sizeof(rageData));

				rageData.Destroy();
			}

			delete this.Rages;
		}

		if (this.Postures != null)
		{
			StringMapSnapshot snapshot = this.Postures.Snapshot();
			SF2ChaserBossProfilePostureInfo posture;

			char postureName[64];
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, postureName, sizeof(postureName));
				this.Postures.GetArray(postureName, posture, sizeof(posture));
				posture.Destroy();
			}

			delete snapshot;
			delete this.Postures;
		}

	}

	bool GetAttackFromIndex(int attackIndex, SF2ChaserBossProfileAttackData data)
	{
		if (this.Attacks == null || this.Attacks.Length <= attackIndex)
		{
			return false;
		}
		this.Attacks.GetArray(attackIndex, data, sizeof(data));
		return true;
	}

	bool GetAttack(const char[] attackName, SF2ChaserBossProfileAttackData data)
	{
		if (this.Attacks == null || this.Attacks.Length == 0)
		{
			return false;
		}
		for (int i = 0; i < this.Attacks.Length; i++)
		{
			SF2ChaserBossProfileAttackData tempData;
			this.Attacks.GetArray(i, tempData, sizeof(tempData));
			if (strcmp(attackName, tempData.Name) == 0)
			{
				data = tempData;
				return true;
			}
		}
		return false;
	}

	bool GetPosture(const char[] posture, SF2ChaserBossProfilePostureInfo postureInfo)
	{
		if (this.Postures == null)
		{
			return false;
		}

		return this.Postures.GetArray(posture, postureInfo, sizeof(postureInfo));
	}

	bool GetPostureFromIndex(int index, SF2ChaserBossProfilePostureInfo postureInfo)
	{
		if (this.Postures == null)
		{
			return false;
		}

		StringMapSnapshot snapshot = this.Postures.Snapshot();
		if (index >= snapshot.Length)
		{
			delete snapshot;
			return false;
		}
		char postureName[64];
		snapshot.GetKey(index, postureName, sizeof(postureName));
		bool value = this.Postures.GetArray(postureName, postureInfo, sizeof(postureInfo));
		delete snapshot;
		return value;
	}
}
