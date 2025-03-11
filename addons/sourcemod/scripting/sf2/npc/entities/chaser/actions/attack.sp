#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfileBaseAttack < ProfileObject
{
	property int Type
	{
		public get()
		{
			return this.GetInt("type", view_as<int>(SF2BossAttackType_Melee));
		}
	}

	property int Index
	{
		public get()
		{
			int val = 0;
			this.GetValue("__index", val);
			return val;
		}

		public set(int value)
		{
			this.SetValue("__index", value);
		}
	}

	public bool IsEnabled(int difficulty)
	{
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public bool CanUseWithPosture(const char[] posture)
	{
		bool ret = true;

		ProfileObject arr = this.GetSection("use_with_posture");
		if (arr != null)
		{
			ret = false;

			if (posture[0] == '\0')
			{
				ret = arr.ContainsString(SF2_PROFILE_CHASER_DEFAULT_POSTURE);
			}
			else
			{
				ret = arr.ContainsString(posture);
			}
		}

		return ret;
	}

	property bool CanUseAgainstProps
	{
		public get()
		{
			bool def = false;
			def = this.GetBool("props", def);
			def = this.GetBool("attack_props", def);
			return def;
		}
	}

	public bool ShouldAutoAim(int difficulty)
	{
		return this.GetDifficultyBool("autoaim", difficulty, false);
	}

	property int UseOnDifficulty
	{
		public get()
		{
			int def = 0;
			def = this.GetInt("use_on_difficulty", def);
			def = this.GetInt("attack_use_on_difficulty", def);
			return def;
		}
	}

	property int BlockOnDifficulty
	{
		public get()
		{
			int def = 6;
			def = this.GetInt("block_on_difficulty", def);
			def = this.GetInt("attack_block_on_difficulty", def);
			return def;
		}
	}

	public float CanUseOnHealth(int difficulty)
	{
		float def = -1.0;
		def = this.GetDifficultyFloat("use_on_health", difficulty, def);
		def = this.GetDifficultyFloat("attack_use_on_health", difficulty, def);
		return def;
	}

	public float CanBlockOnHealth(int difficulty)
	{
		float def = -1.0;
		def = this.GetDifficultyFloat("block_on_health", difficulty, def);
		def = this.GetDifficultyFloat("attack_block_on_health", difficulty, def);
		return def;
	}

	public float GetDamage(int difficulty)
	{
		float defaultValue;

		switch (this.Type)
		{
			case SF2BossAttackType_Melee:
			{
				defaultValue = 50.0;
			}

			case SF2BossAttackType_Ranged:
			{
				defaultValue = 8.0;
				defaultValue = this.GetDifficultyFloat("bullet_damage", difficulty, defaultValue);
				defaultValue = this.GetDifficultyFloat("attack_bullet_damage", difficulty, defaultValue);
			}

			case SF2BossAttackType_Projectile:
			{
				defaultValue = 60.0;
				defaultValue = this.GetDifficultyFloat("projectile_damage", difficulty, defaultValue);
				defaultValue = this.GetDifficultyFloat("attack_projectile_damage", difficulty, defaultValue);
			}

			case SF2BossAttackType_LaserBeam:
			{
				defaultValue = 25.0;
				defaultValue = this.GetDifficultyFloat("laser_damage", difficulty, defaultValue);
				defaultValue = this.GetDifficultyFloat("attack_laser_damage", difficulty, defaultValue);
			}

			case SF2BossAttackType_ExplosiveDance:
			{
				defaultValue = 25.0;
			}

			case SF2BossAttackType_Tongue:
			{
				defaultValue = 10.0;
			}
		}

		defaultValue = this.GetDifficultyFloat("damage", difficulty, defaultValue);
		defaultValue = this.GetDifficultyFloat("attack_damage", difficulty, defaultValue);

		return defaultValue;
	}

	public float GetDamagePercent(int difficulty)
	{
		return this.GetDifficultyFloat("damage_percent", difficulty);
	}

	public float GetDamageFallOff(int difficulty)
	{
		float def = 1.0;
		ProfileObject obj = this.GetSection("fall_off");
		if (obj != null)
		{
			return obj.GetDifficultyFloat("percent", difficulty, def);
		}
		return def;
	}

	public float GetDamageFallOffRange(int difficulty)
	{
		float def = 1024.0;
		ProfileObject obj = this.GetSection("fall_off");
		if (obj != null)
		{
			return obj.GetDifficultyFloat("range", difficulty, def);
		}
		return def;
	}

	public float GetDamageRampUp(int difficulty)
	{
		float def = 1.0;
		ProfileObject obj = this.GetSection("ramp_up");
		if (obj != null)
		{
			return obj.GetDifficultyFloat("percent", difficulty, def);
		}
		return def;
	}

	public float GetDamageRampUpRange(int difficulty)
	{
		float def = 512.0;
		ProfileObject obj = this.GetSection("ramp_up");
		if (obj != null)
		{
			return obj.GetDifficultyFloat("range", difficulty, def);
		}
		return def;
	}

	public int GetDamageType(int difficulty)
	{
		int defaultValue;

		switch (this.Type)
		{
			case SF2BossAttackType_Melee:
			{
				defaultValue = DMG_CLUB;
			}

			case SF2BossAttackType_Ranged:
			{
				defaultValue = DMG_BULLET;
			}

			case SF2BossAttackType_Projectile, SF2BossAttackType_ExplosiveDance:
			{
				defaultValue = DMG_BLAST;
			}

			case SF2BossAttackType_LaserBeam:
			{
				defaultValue = DMG_SHOCK | DMG_ALWAYSGIB;
			}

			case SF2BossAttackType_Tongue:
			{
				defaultValue = DMG_BULLET | DMG_PREVENT_PHYSICS_FORCE;
			}
		}
		defaultValue = this.GetDifficultyInt("damagetype", difficulty, defaultValue);
		defaultValue = this.GetDifficultyInt("attack_damagetype", difficulty, defaultValue);

		return defaultValue;
	}

	public float GetDelay(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("delay", difficulty, def);
		def = this.GetDifficultyFloat("attack_delay", difficulty, def);
		return def;
	}

	public float GetDuration(int difficulty)
	{
		float value = this.GetDifficultyFloat("duration", difficulty);
		float endAfter = this.GetDifficultyFloat("endafter", difficulty);
		value = this.GetDifficultyFloat("attack_duration", difficulty, value);
		endAfter = this.GetDifficultyFloat("attack_endafter", difficulty, endAfter);

		if (value <= 0.0)
		{
			value = this.GetDelay(difficulty) + endAfter;
		}

		return value;
	}

	public float GetBeginRange(int difficulty)
	{
		float def = 80.0;
		def = this.GetDifficultyFloat("begin_range", difficulty, def);
		def = this.GetDifficultyFloat("attack_begin_range", difficulty, def);
		return def;
	}

	public float GetBeginFOV(int difficulty)
	{
		float def = this.GetFOV(difficulty);
		def = this.GetDifficultyFloat("begin_fov", difficulty, def);
		def = this.GetDifficultyFloat("attack_begin_fov", difficulty, def);
		return def;
	}

	public float GetFOV(int difficulty)
	{
		float def = 45.0;
		def = this.GetDifficultyFloat("spread", difficulty, def);
		def = this.GetDifficultyFloat("attack_spread", difficulty, def);
		return def;
	}

	public float GetRange(int difficulty)
	{
		float def = 180.0;
		def = this.GetDifficultyFloat("range", difficulty, def);
		def = this.GetDifficultyFloat("attack_range", difficulty, def);
		return def;
	}

	public float GetCooldown(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("cooldown", difficulty, def);
		def = this.GetDifficultyFloat("attack_cooldown", difficulty, def);
		return def;
	}

	public bool GetDisappearAfterAttack(int difficulty)
	{
		bool def = false;
		def = this.GetDifficultyBool("disappear", difficulty, def);
		def = this.GetDifficultyBool("attack_disappear_upon_damaging", difficulty, def);
		return def;
	}

	public bool GetDisappearAfterHit(int difficulty)
	{
		return this.GetDifficultyBool("disappear_upon_damaging", difficulty);
	}

	public void GetViewPunchAngles(int difficulty, float viewPunch[3])
	{
		this.GetDifficultyVector("punchvel", difficulty, viewPunch, viewPunch);
		this.GetDifficultyVector("attack_punchvel", difficulty, viewPunch, viewPunch);
	}

	public float GetDamageForce(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("damageforce", difficulty);
		def = this.GetDifficultyFloat("attack_damageforce", difficulty);
		return def;
	}

	public int GetEventNumber(int difficulty)
	{
		return this.GetDifficultyInt("event", difficulty, -1);
	}

	public bool GetStartThroughWalls(int difficulty)
	{
		return this.GetDifficultyBool("start_through_walls", difficulty);
	}

	public bool GetHitThroughWalls(int difficulty)
	{
		return this.GetDifficultyBool("hit_through_walls", difficulty);
	}

	public int GetRepeatState(int difficulty)
	{
		int def = 0;
		def = this.GetDifficultyInt("repeat", difficulty, def);
		def = this.GetDifficultyInt("attack_repeat", difficulty, def);
		return def;
	}

	public float GetRepeatTimer(int difficulty, int index)
	{
		float def = -1.0;
		char key[64];
		FormatEx(key, sizeof(key), "repeat_%i_delay", index);
		def = this.GetDifficultyFloat(key, difficulty, def);
		FormatEx(key, sizeof(key), "attack_repeat_%i_delay", index);
		def = this.GetDifficultyFloat(key, difficulty, def);
		return def;
	}

	public float GetRunSpeed(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("run_speed", difficulty, def);
		def = this.GetDifficultyFloat("attack_run_speed", difficulty, def);
		return def;
	}

	public float GetAcceleration(int difficulty)
	{
		return this.GetDifficultyFloat("run_acceleration", difficulty, 4000.0);
	}

	public float GetRunDuration(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("run_duration", difficulty, def);
		def = this.GetDifficultyFloat("attack_run_duration", difficulty, def);
		return def;
	}

	public float GetRunDelay(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("run_delay", difficulty, def);
		def = this.GetDifficultyFloat("attack_run_delay", difficulty, def);
		return def;
	}

	public bool GetGroundSpeedOverride(int difficulty)
	{
		return this.GetDifficultyBool("run_ground_speed", difficulty);
	}

	public float GetMinCancelDistance(int difficulty)
	{
		return this.GetDifficultyFloat("cancel_distance_min", difficulty, -1.0);
	}

	public float GetMaxCancelDistance(int difficulty)
	{
		return this.GetDifficultyFloat("cancel_distance_max", difficulty, -1.0);
	}

	public bool GetCancelLOS(int difficulty)
	{
		return this.GetDifficultyBool("cancel_los", difficulty, false);
	}

	property bool DeathCamLowHealth
	{
		public get()
		{
			bool def = false;
			def = this.GetBool("deathcam_on_low_health", def);
			def = this.GetBool("attack_deathcam_on_low_health", def);
			return def;
		}
	}

	public bool IsImmuneToDamage(int difficulty)
	{
		return this.GetDifficultyBool("invulnerable", difficulty, false);
	}

	public bool ShouldNotInterruptChaseInitial(int difficulty)
	{
		return this.GetDifficultyBool("dont_interrupt_chaseinitial", difficulty, false);
	}

	public ProfileSound GetBeginSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("begin"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileSound GetStartSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("attack"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileSound GetHitSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("hit"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileSound GetMissSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("miss"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileSound GetLoopSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("loop"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileSound GetEndSounds()
	{
		ProfileObject obj = this.GetSection("sounds");
		if (obj == null)
		{
			return null;
		}

		ProfileSound sound = view_as<ProfileSound>(obj.GetSection("end"));
		if (sound == null)
		{
			return null;
		}

		return sound;
	}

	public ProfileMasterAnimations GetAnimations()
	{
		return view_as<ProfileMasterAnimations>(this.GetSection("animations"));
	}

	public void GetWeaponString(char[] buffer, int bufferSize)
	{
		this.GetString("weapontype", buffer, bufferSize, buffer);
		this.GetString("attack_weapontype", buffer, bufferSize, buffer);
	}

	property int WeaponInt
	{
		public get()
		{
			int def = 0;
			def = this.GetInt("weapontypeint", def);
			def = this.GetInt("attack_weapontypeint", def);
			return def;
		}
	}

	public ProfileEffectMaster GetStartEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("start") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileInputsList GetStartInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("start"));
		}
		return null;
	}

	public ProfileEffectMaster GetHitEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("hit") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileInputsList GetHitInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("hit"));
		}
		return null;
	}

	public ProfileEffectMaster GetMissEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("miss") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileInputsList GetMissInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("miss"));
		}
		return null;
	}

	public ProfileEffectMaster GetOnKillEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("on_kill") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileInputsList GetOnKillInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("on_kill"));
		}
		return null;
	}

	public KeyMap_Array GetDamageEffects()
	{
		return this.GetArray("apply_conditions");
	}

	public void ApplyDamageEffects(CBaseCombatCharacter player, int difficulty, SF2_ChaserEntity chaser = view_as<SF2_ChaserEntity>(-1))
	{
		if (this.GetDamageEffects() == null)
		{
			return;
		}

		if (!player.IsValid())
		{
			return;
		}

		for (int i = 0; i < this.GetDamageEffects().Length; i++)
		{
			KeyMap obj = this.GetDamageEffects().GetSection(i);
			if (obj == null)
			{
				continue;
			}
			BossProfileDamageEffect effect = view_as<BossProfileDamageEffect>(obj);
			effect.Apply(player, difficulty, chaser);
		}
	}

	public BossProfileShockwave GetShockwave()
	{
		return view_as<BossProfileShockwave>(this.GetSection("shockwave"));
	}

	public void Precache()
	{
		this.ConvertSectionsSectionToArray("apply_conditions");

		if (this.GetBeginSounds() != null)
		{
			this.GetBeginSounds().Precache();
		}

		if (this.GetStartSounds() != null)
		{
			this.GetStartSounds().Precache();
		}

		if (this.GetHitSounds() != null)
		{
			this.GetHitSounds().Precache();
		}

		if (this.GetMissSounds() != null)
		{
			this.GetMissSounds().Precache();
		}

		if (this.GetEndSounds() != null)
		{
			this.GetEndSounds().Precache();
		}

		if (this.GetLoopSounds() != null)
		{
			this.GetLoopSounds().Precache();
		}

		if (this.GetStartEffects() != null)
		{
			this.GetStartEffects().Precache();
		}

		if (this.GetHitEffects() != null)
		{
			this.GetHitEffects().Precache();
		}

		if (this.GetMissEffects() != null)
		{
			this.GetMissEffects().Precache();
		}

		if (this.GetOnKillEffects() != null)
		{
			this.GetOnKillEffects().Precache();
		}

		if (this.GetShockwave() != null)
		{
			this.GetShockwave().Precache();
		}

		if (this.GetDamageEffects() != null)
		{
			for (int i = 0; i < this.GetDamageEffects().Length; i++)
			{
				BossProfileDamageEffect effect = view_as<BossProfileDamageEffect>(this.GetDamageEffects().GetSection(i));
				if (effect != null)
				{
					effect.Precache();
				}
			}
		}

		switch (this.Type)
		{
			case SF2BossAttackType_Ranged:
			{
				view_as<ChaserBossProfileBulletAttack>(this).Precache();
			}

			case SF2BossAttackType_Projectile:
			{
				view_as<ChaserBossProfileProjectileAttack>(this).Precache();
			}

			case SF2BossAttackType_Tongue:
			{
				view_as<ChaserBossProfileTongueAttack>(this).Precache();
			}

			case SF2BossAttackType_Combo:
			{
				view_as<ChaserBossProfileComboAttack>(this).Precache();
			}
		}
	}
}

methodmap BossProfileDamageEffect < ProfileObject
{
	property int Type
	{
		public get()
		{
			char section[64];
			this.GetSectionName(section, sizeof(section));
			if (strcmp(section, "ignite", false) == 0)
			{
				return SF2DamageType_Ignite;
			}
			else if (strcmp(section, "gas", false) == 0)
			{
				return SF2DamageType_Gas;
			}
			else if (strcmp(section, "bleed", false) == 0)
			{
				return SF2DamageType_Bleed;
			}
			else if (strcmp(section, "mark", false) == 0)
			{
				return SF2DamageType_Mark;
			}
			else if (strcmp(section, "jarate", false) == 0)
			{
				return SF2DamageType_Jarate;
			}
			else if (strcmp(section, "milk", false) == 0)
			{
				return SF2DamageType_Milk;
			}
			else if (strcmp(section, "stun", false) == 0)
			{
				return SF2DamageType_Stun;
			}
			else if (strcmp(section, "smite", false) == 0)
			{
				return SF2DamageType_Smite;
			}
			else if (strcmp(section, "random", false) == 0)
			{
				return SF2DamageType_Random;
			}

			return SF2DamageType_Invalid;
		}
	}

	public bool IsEnabled(int difficulty)
	{
		if (this.Type == SF2DamageType_Invalid)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public float GetDuration(int difficulty)
	{
		float def = 8.0;
		if (this.Type == SF2DamageType_Invalid)
		{
			return def;
		}
		return this.GetDifficultyFloat("duration", difficulty, def);
	}

	public ProfileSound GetSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sounds"));
	}

	public ProfileObject GetParticles()
	{
		return this.GetSection("particles");
	}

	public void Apply(CBaseCombatCharacter player, int difficulty, CBaseAnimating attacker = view_as<CBaseAnimating>(-1), SF2NPC_Chaser parentController = SF2_INVALID_NPC_CHASER)
	{
		if (!this.IsEnabled(difficulty))
		{
			return;
		}
		this.GetSounds().EmitSound(_, attacker.index);
		if (this.GetParticles() != null)
		{
			char name[64];
			this.GetParticles().GetSectionNameFromIndex(GetRandomInt(0, this.GetParticles().SectionLength - 1), name, sizeof(name));
			ProfileObject obj = this.GetParticles().GetSection(name);
			if (obj != null)
			{
				view_as<BossProfileParticleData>(obj).Apply(player, attacker);
			}
		}
		int type = this.Type;
		if (type == SF2DamageType_Random)
		{
			type = view_as<BossProfileDamageEffect_Random>(this).GetRandomType();
		}

		switch (type)
		{
			case SF2DamageType_Ignite:
			{
				TF2_IgnitePlayer(player.index, player.index, this.GetDuration(difficulty));
			}
			case SF2DamageType_Gas:
			{
				TF2_AddCondition(player.index, TFCond_Gas, this.GetDuration(difficulty), player.index);
			}
			case SF2DamageType_Mark:
			{
				TF2_AddCondition(player.index, view_as<BossProfileDamageEffect_Mark>(this).GetSilentMark(difficulty) ? TFCond_MarkedForDeathSilent : TFCond_MarkedForDeath, this.GetDuration(difficulty), player.index);
			}
			case SF2DamageType_Bleed:
			{
				TF2_MakeBleed(player.index, player.index, this.GetDuration(difficulty));
			}
			case SF2DamageType_Milk:
			{
				TF2_AddCondition(player.index, TFCond_Milked, this.GetDuration(difficulty), player.index);
			}
			case SF2DamageType_Jarate:
			{
				TF2_AddCondition(player.index, TFCond_Jarated, this.GetDuration(difficulty), player.index);
			}
			case SF2DamageType_Stun:
			{
				TF2_StunPlayer(player.index, this.GetDuration(difficulty), view_as<BossProfileDamageEffect_Stun>(this).GetSlowdown(difficulty), view_as<BossProfileDamageEffect_Stun>(this).GetFlags(difficulty));
			}
			case SF2DamageType_Smite:
			{
				BossProfileDamageEffect_Smite smiteData = view_as<BossProfileDamageEffect_Smite>(this);
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
				int color[4];
				smiteData.GetSmiteColor(color);
				TE_SetupBeamPoints(startPos, targetPos, smiteData.SmiteSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
				TE_SendToAll();

				TE_SetupSparks(targetPos, origin, 5000, 1000);
				TE_SendToAll();

				TE_SetupEnergySplash(targetPos, origin, false);
				TE_SendToAll();

				TE_SetupSmoke(targetPos, smiteData.SmiteSmokeSprite, 5.0, 10);
				TE_SendToAll();

				char sound[PLATFORM_MAX_PATH];
				smiteData.GetHitSound(sound, sizeof(sound));
				EmitAmbientSound(sound, startPos, player.index, SNDLEVEL_SCREAMING);
				SDKHooks_TakeDamage(player.index, attacker.index, attacker.index, smiteData.GetDamage(difficulty), smiteData.GetDamageType(difficulty));

				SF2NPC_Chaser controller = parentController;
				if (!controller.IsValid() && SF2_ChaserEntity(attacker.index).IsValid())
				{
					controller = SF2_ChaserEntity(attacker.index).Controller;
					if (smiteData.SmiteMessage && controller.IsValid() && GetClientTeam(player.index) == 2)
					{
						char playerName[32], bossName[SF2_MAX_NAME_LENGTH];
						GetClientName(player.index, playerName, sizeof(playerName));
						controller.GetProfileData().GetName(controller.Difficulty, bossName, sizeof(bossName));
						CPrintToChatAll("{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Smote target", bossName, playerName);
					}
				}
			}
		}
	}

	public void Precache()
	{
		if (this.GetSounds() != null)
		{
			this.GetSounds().Precache();
		}
	}
}

methodmap BossProfileDamageEffect_Mark < BossProfileDamageEffect
{
	public bool GetSilentMark(int difficulty)
	{
		bool def = false;
		if (this.Type == SF2DamageType_Invalid)
		{
			return def;
		}
		return this.GetDifficultyBool("silent", difficulty, def);
	}
}

methodmap BossProfileDamageEffect_Stun < BossProfileDamageEffect
{
	public float GetSlowdown(int difficulty)
	{
		float def = 0.5;
		if (this.Type == SF2DamageType_Invalid)
		{
			return def;
		}
		return this.GetDifficultyFloat("slow_multiplier", difficulty, def);
	}

	public int GetFlags(int difficulty)
	{
		char flag[256];
		this.GetDifficultyString("flags", difficulty, flag, sizeof(flag), "slow");
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
}

methodmap BossProfileDamageEffect_Smite < BossProfileDamageEffect
{
	property int SmiteSprite
	{
		public get()
		{
			int val = 0;
			this.GetValue("__smite_sprite", val);
			return val;
		}

		public set(int value)
		{
			this.SetValue("__smite_sprite", value);
		}
	}

	property int SmiteSmokeSprite
	{
		public get()
		{
			int val = 0;
			this.GetValue("__smite_smoke_sprite", val);
			return val;
		}

		public set(int value)
		{
			this.SetValue("__smite_smoke_sprite", value);
		}
	}

	public float GetDamage(int difficulty)
	{
		float def = 9001.0;
		if (this.Type == SF2DamageType_Invalid)
		{
			return def;
		}
		return this.GetDifficultyFloat("damage", difficulty, def);
	}

	public int GetDamageType(int difficulty)
	{
		int def = (1 << 20);
		if (this.Type == SF2DamageType_Invalid)
		{
			return def;
		}
		return this.GetDifficultyInt("damagetype", difficulty, def);
	}

	public void GetSmiteColor(int buffer[4])
	{
		this.GetColor("color", buffer, { 255, 255, 255, 255 });
	}

	property bool SmiteMessage
	{
		public get()
		{
			bool def = false;
			if (this.Type == SF2DamageType_Invalid)
			{
				return def;
			}
			return this.GetBool("message", def);
		}
	}

	public void GetHitSound(char[] buffer, int bufferSize)
	{
		if (this.Type == SF2DamageType_Invalid)
		{
			return;
		}
		this.GetString("hit_sound", buffer, bufferSize, SOUND_THUNDER);
	}
}

methodmap BossProfileDamageEffect_Random < BossProfileDamageEffect
{
	public int GetRandomType()
	{
		if (this.Type == SF2DamageType_Invalid)
		{
			return SF2DamageType_Invalid;
		}
		char type[256];
		this.GetString("random_types", type, sizeof(type));
		ArrayList random = new ArrayList();
		char types[32][32];
		int nums = ExplodeString(type, " ", types, sizeof(types), sizeof(types[]));
		for (int i = 0; i < nums; i++)
		{
			if (strcmp(types[i], "ignite", false) == 0)
			{
				random.Push(SF2DamageType_Ignite);
			}
			else if (strcmp(types[i], "gas", false) == 0)
			{
				random.Push(SF2DamageType_Gas);
			}
			else if (strcmp(types[i], "bleed", false) == 0)
			{
				random.Push(SF2DamageType_Bleed);
			}
			else if (strcmp(types[i], "mark", false) == 0)
			{
				random.Push(SF2DamageType_Mark);
			}
			else if (strcmp(types[i], "jarate", false) == 0)
			{
				random.Push(SF2DamageType_Jarate);
			}
			else if (strcmp(types[i], "milk", false) == 0)
			{
				random.Push(SF2DamageType_Milk);
			}
			else if (strcmp(types[i], "stun", false) == 0)
			{
				random.Push(SF2DamageType_Stun);
			}
			else if (strcmp(types[i], "smite", false) == 0)
			{
				random.Push(SF2DamageType_Smite);
			}
		}
		int val = random.Get(GetRandomInt(0, random.Length - 1));
		delete random;
		return val;
	}
}

methodmap BossProfileShockwave < ProfileObject
{
	public float GetHeight(int difficulty)
	{
		return this.GetDifficultyFloat("height", difficulty, 80.0);
	}

	public float GetRadius(int difficulty)
	{
		return this.GetDifficultyFloat("radius", difficulty, 200.0);
	}

	public float GetForce(int difficulty)
	{
		return this.GetDifficultyFloat("force", difficulty, 600.0);
	}

	public float GetBatteryDrainPercent(int difficulty)
	{
		return this.GetDifficultyFloat("battery_drain", difficulty, 0.0);
	}

	public float GetStaminaDrainPercent(int difficulty)
	{
		return this.GetDifficultyFloat("stamina_drain", difficulty, 0.0);
	}

	public ProfileEffectMaster GetEffects()
	{
		return view_as<ProfileEffectMaster>(this.GetSection("effects"));
	}

	public KeyMap_Array GetDamageEffects()
	{
		return this.GetArray("apply_conditions");
	}

	public void ApplyDamageEffects(CBaseCombatCharacter player, int difficulty, SF2_ChaserEntity chaser = view_as<SF2_ChaserEntity>(-1))
	{
		if (this.GetDamageEffects() == null)
		{
			return;
		}

		if (!player.IsValid())
		{
			return;
		}

		for (int i = 0; i < this.GetDamageEffects().Length; i++)
		{
			KeyMap obj = this.GetDamageEffects().GetSection(i);
			if (obj == null)
			{
				continue;
			}
			BossProfileDamageEffect effect = view_as<BossProfileDamageEffect>(obj);
			effect.Apply(player, difficulty, chaser);
		}
	}

	public void Precache()
	{
		this.ConvertSectionsSectionToArray("apply_conditions");
		if (this.GetDamageEffects() != null)
		{
			for (int i = 0; i < this.GetDamageEffects().Length; i++)
			{
				BossProfileDamageEffect obj = view_as<BossProfileDamageEffect>(this.GetDamageEffects().GetSection(i));
				if (obj == null)
				{
					continue;
				}
				obj.Precache();
			}
		}

		if (this.GetEffects() != null)
		{
			this.GetEffects().Precache();
		}
	}
}

#include "attacks/melee.sp"
#include "attacks/bullet.sp"
#include "attacks/projectile.sp"
#include "attacks/laser_beam.sp"
#include "attacks/explosive_dance.sp"
#include "attacks/custom.sp"
#include "attacks/tongue.sp"
#include "attacks/combo.sp"
#include "attacks/forward_based.sp"

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction < NextBotAction
{
	public SF2_ChaserAttackAction(ChaserBossProfile profileData, const char[] attackName, int attackIndex, float endTime)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackMain");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnOtherKilled, OnOtherKilled);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_ProfileData")
				.DefineIntField("m_OldState")
				.DefineIntField("m_OldMovementType")
				.DefineStringField("m_AttackName")
				.DefineIntField("m_AttackIndex")
				.DefineFloatField("m_EndTime")
				.DefineBoolField("m_DidEndAnimation")
				.DefineBoolField("m_PlayedBeginVoice")
				.DefineBoolField("m_ShouldReplayAnimation")
				.DefineStringField("m_LoopSound")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction action = view_as<SF2_ChaserAttackAction>(g_Factory.Create());

		action.SetAttackName(attackName);
		action.ProfileData = profileData.GetAttack(attackName);
		action.EndTime = endTime;
		action.AttackIndex = attackIndex;

		return action;
	}

	public static void Initialize()
	{
		SF2_ChaserAttackAction_Melee.Initialize();
		SF2_ChaserAttackAction_ExplosiveDance.Initialize();
		SF2_ChaserAttackAction_Bullet.Initialize();
		SF2_ChaserAttackAction_Projectile.Initialize();
		SF2_ChaserAttackAction_Laser.Initialize();
		SF2_ChaserAttackAction_Custom.Initialize();
		SF2_ChaserAttackAction_Tongue.Initialize();
		SF2_ChaserAttackAction_Combo.Initialize();
		SF2_ChaserAttackAction_ForwardBased.Initialize();
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_ChaserBossProfileBaseAttack.Type.get", Native_GetType);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetDamageDelay", Native_GetDamageDelay);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetRange", Native_GetRange);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetDamage", Native_GetDamage);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetDamageType", Native_GetDamageType);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetDamageForce", Native_GetDamageForce);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetViewPunchAngles", Native_GetViewPunchAngles);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetDuration", Native_GetDuration);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetFOV", Native_GetFOV);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetBeginRange", Native_GetBeginRange);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetBeginFOV", Native_GetBeginFOV);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetCooldown", Native_GetCooldown);
		CreateNative("SF2_ChaserBossProfileBaseAttack.UseOnDifficulty.get", Native_GetUseOnDifficulty);
		CreateNative("SF2_ChaserBossProfileBaseAttack.BlockOnDifficulty.get", Native_GetBlockOnDifficulty);
		CreateNative("SF2_ChaserBossProfileBaseAttack.CanUseOnHealth", Native_GetCanUseOnHealth);
		CreateNative("SF2_ChaserBossProfileBaseAttack.CanBlockOnHealth", Native_GetCanBlockOnHealth);
		CreateNative("SF2_ChaserBossProfileBaseAttack.GetEventNumber", Native_GetEventNumber);
		ChaserBossProfileCustomAttack.SetupAPI();
	}

	property ChaserBossProfileBaseAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileBaseAttack value)
		{
			this.SetData("m_ProfileData", value);
		}
	}

	property int OldState
	{
		public get()
		{
			return this.GetData("m_OldState");
		}

		public set(int value)
		{
			this.SetData("m_OldState", value);
		}
	}

	property SF2NPCMoveTypes OldMovementType
	{
		public get()
		{
			return this.GetData("m_OldMovementType");
		}

		public set(SF2NPCMoveTypes value)
		{
			this.SetData("m_OldMovementType", value);
		}
	}

	public char[] GetAttackName()
	{
		char name[128];
		this.GetDataString("m_AttackName", name, sizeof(name));
		return name;
	}

	public void SetAttackName(const char[] name)
	{
		this.SetDataString("m_AttackName", name);
	}

	property int AttackIndex
	{
		public get()
		{
			return this.GetData("m_AttackIndex");
		}

		public set(int value)
		{
			this.SetData("m_AttackIndex", value);
		}
	}

	property float EndTime
	{
		public get()
		{
			return this.GetDataFloat("m_EndTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndTime", value);
		}
	}

	property bool DidEndAnimation
	{
		public get()
		{
			return this.GetData("m_DidEndAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_DidEndAnimation", value);
		}
	}

	public char[] GetLoopSound()
	{
		char name[PLATFORM_MAX_PATH];
		this.GetDataString("m_LoopSound", name, sizeof(name));
		return name;
	}

	public void SetLoopSound(const char[] name)
	{
		this.SetDataString("m_LoopSound", name);
	}

	property bool PlayedBeginVoice
	{
		public get()
		{
			return this.GetData("m_PlayedBeginVoice") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_PlayedBeginVoice", value);
		}
	}

	property bool ShouldReplayAnimation
	{
		public get()
		{
			return this.GetData("m_ShouldReplayAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_ShouldReplayAnimation", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserAttackAction action, SF2_ChaserEntity actor)
{
	NextBotAction attackAction = NULL_ACTION;

	Action result = Plugin_Continue;
	Call_StartForward(g_OnChaserGetAttackActionPFwd);
	Call_PushCell(actor);
	Call_PushString(action.GetAttackName());
	Call_PushCellRef(attackAction);
	Call_Finish(result);

	if (result == Plugin_Changed)
	{
		return attackAction;
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (controller.Flags & SFF_FAKE)
	{
		controller.MarkAsFake();
		return action.Done("I'm a faker, bye");
	}

	if (action.ActiveChild == NULL_ACTION)
	{
		return action.Done("No attack action was given");
	}

	actor.SetAttackName(action.GetAttackName());
	actor.AttackIndex = action.AttackIndex;
	actor.IsAttacking = true;
	actor.EndCloak();

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();
	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileChaseData chaseData = data.GetChaseBehavior();
	ChaserBossProfileBaseAttack attackData = action.ProfileData;
	actor.AttackRunDelay = gameTime + attackData.GetRunDelay(difficulty);
	actor.AttackRunDuration = gameTime + attackData.GetRunDuration(difficulty);

	if (actor.State == STATE_CHASE)
	{
		actor.CurrentChaseDuration += chaseData.GetDurationAddOnAttack(difficulty);
		if (actor.CurrentChaseDuration > chaseData.GetMaxChaseDuration(difficulty))
		{
			actor.CurrentChaseDuration = chaseData.GetMaxChaseDuration(difficulty);
		}
	}

	action.OldState = actor.State;
	actor.State = STATE_ATTACK;
	action.OldMovementType = actor.MovementType;

	actor.InvokeOnStartAttack(action.GetAttackName());

	if (attackData.GetStartEffects() != null)
	{
		SlenderSpawnEffects(attackData.GetStartEffects(), controller.Index, false);
	}

	if (attackData.GetStartInputs() != null)
	{
		attackData.GetStartInputs().AcceptInputs(actor);
	}

	if (attackData.GetRunSpeed(difficulty) <= 0.0)
	{
		actor.MyNextBotPointer().GetLocomotionInterface().Stop();
		controller.Path.Invalidate();
		actor.IsAttemptingToMove = false;
	}
	else
	{
		actor.MovementType = SF2NPCMoveType_Attack;
	}

	if (attackData.Type == SF2BossAttackType_Custom)
	{
		return action.Continue();
	}

	ProfileSound info;
	if (attackData.GetStartSounds() == null && attackData.GetBeginSounds() == null)
	{
		actor.SearchSoundsWithSectionName(data.GetAttackBeginSounds(), action.GetAttackName(), info, "attack_begin");
		if (info != null)
		{
			action.PlayedBeginVoice = actor.PerformVoice(SF2BossSound_AttackBegin, action.GetAttackName());
		}
		else
		{
			actor.PerformVoice(SF2BossSound_Attack, action.GetAttackName());
			action.PlayedBeginVoice = true;
		}
	}
	else
	{
		if (attackData.GetBeginSounds() != null)
		{
			action.PlayedBeginVoice = actor.PerformVoiceCooldown(attackData.GetBeginSounds(), attackData.GetBeginSounds().Paths);
		}
		else
		{
			actor.PerformVoiceCooldown(attackData.GetStartSounds(), attackData.GetStartSounds().Paths);
			action.PlayedBeginVoice = true;
		}
	}

	NextBotAction newAction = actor.IsAttackTransitionPossible(action.GetAttackName());
	action.ShouldReplayAnimation = newAction != NULL_ACTION;
	if (newAction == NULL_ACTION)
	{
		actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], .preDefinedName = attackData.GetAnimations() == null ? action.GetAttackName() : "", .animations = attackData.GetAnimations());
		actor.AddGesture(g_SlenderAnimationsList[SF2BossAnimation_Attack], .definedName = attackData.GetAnimations() == null ? action.GetAttackName() : "", .animations = attackData.GetAnimations());
	}
	return newAction != NULL_ACTION ? action.SuspendFor(newAction) : action.Continue();
}

static int Update(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;

	if (!controller.IsValid())
	{
		return action.Done();
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileBaseAttack attackData = action.ProfileData;
	int interrputConditions = actor.InterruptConditions;
	bool end = false;
	INextBot bot = actor.MyNextBotPointer();
	PathFollower path = controller.Path;
	ILocomotion loco = bot.GetLocomotionInterface();

	int difficulty = controller.Difficulty;

	CBaseEntity target = actor.Target;
	if (target.IsValid())
	{
		float myPos[3], targetPos[3];
		actor.GetAbsOrigin(myPos);
		target.GetAbsOrigin(targetPos);
		float distance = GetVectorSquareMagnitude(myPos, targetPos);
		if (attackData.GetMaxCancelDistance(difficulty) > 0.0 && distance > Pow(attackData.GetMaxCancelDistance(difficulty), 2.0))
		{
			end = true;
		}

		if (attackData.GetMinCancelDistance(difficulty) > 0.0 && distance < Pow(attackData.GetMinCancelDistance(difficulty), 2.0))
		{
			end = true;
		}

		if (attackData.GetCancelLOS(difficulty) && (actor.InterruptConditions & COND_ENEMYVISIBLE_NOGLASS) == 0)
		{
			end = true;
		}

		if (actor.MovementType == SF2NPCMoveType_Attack)
		{
			float pos[3];
			target.GetAbsOrigin(pos);
			if (actor.Teleporters.Length > 0)
			{
				CBaseEntity(EntRefToEntIndex(actor.Teleporters.Get(0))).GetAbsOrigin(pos);
			}

			if ((interrputConditions & COND_NEWENEMY) != 0 || path.GetAge() > 0.3 || (path.IsValid() && (path.GetLength() - path.GetCursorPosition()) < 256.0))
			{
				path.ComputeToPos(bot, pos);
			}
		}
	}

	if (!path.IsValid())
	{
		loco.Stop();
		actor.IsAttemptingToMove = false;
	}
	else
	{
		path.Update(bot);
		actor.IsAttemptingToMove = true;
	}

	if (attackData.Type == SF2BossAttackType_Custom)
	{
		if (action.ActiveChild == NULL_ACTION || end)
		{
			return action.Done("Done using a custom attack");
		}
		return action.Continue();
	}

	ProfileSound info = attackData.GetLoopSounds();
	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] == '\0')
	{
		if (info == null)
		{
			actor.SearchSoundsWithSectionName(data.GetAttackLoopSounds(), action.GetAttackName(), info, "attack_loop");
		}
		if (info != null)
		{
			char sound[PLATFORM_MAX_PATH];
			info.EmitSound(_, actor.index, _, _, _, sound);
			action.SetLoopSound(sound);
		}
		else
		{
			action.SetLoopSound("-");
		}
	}

	action.EndTime -= interval;

	if (action.ActiveChild == NULL_ACTION || (action.EndTime > -1.0 && action.EndTime <= 0.0) || end)
	{
		NextBotAction newAction = actor.IsAttackTransitionPossible(action.GetAttackName(), true);
		if (!action.DidEndAnimation && newAction != NULL_ACTION)
		{
			if (attackData.GetEndSounds() == null)
			{
				actor.PerformVoice(SF2BossSound_AttackEnd, action.GetAttackName());
			}
			else
			{
				actor.PerformVoiceCooldown(attackData.GetEndSounds(), attackData.GetEndSounds().Paths);
			}
			action.DidEndAnimation = true;
			if (newAction != NULL_ACTION)
			{
				return action.SuspendFor(newAction, "We're gonna do a attack end action");
			}
		}
		return action.Done("Attack finished");
	}

	return action.Continue();
}

static int OnSuspend(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] != '\0' && strcmp(value, "-") != 0)
	{
		StopSound(actor.index, SNDCHAN_AUTO, value);
	}
	if (actor.IsStunned)
	{
		return action.Done();
	}
	if (!action.ShouldReplayAnimation && !action.DidEndAnimation)
	{
		return action.Done("Suspended");
	}
	return action.Continue();
}

static int OnResume(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	ChaserBossProfileBaseAttack attackData = action.ProfileData;
	ProfileMasterAnimations animations = attackData.GetAnimations();
	if (!action.PlayedBeginVoice)
	{
		if (attackData.GetStartSounds() == null)
		{
			actor.PerformVoice(SF2BossSound_Attack, action.GetAttackName());
		}
		else
		{
			actor.PerformVoiceCooldown(attackData.GetStartSounds(), attackData.GetStartSounds().Paths);
		}
		action.PlayedBeginVoice = true;
	}
	if (action.ShouldReplayAnimation)
	{
		actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], .preDefinedName = animations == null ? action.GetAttackName() : "", .animations = animations);
		actor.AddGesture(g_SlenderAnimationsList[SF2BossAnimation_Attack], .definedName = animations == null ? action.GetAttackName() : "", .animations = animations);
		action.ShouldReplayAnimation = false;
	}

	if (action.DidEndAnimation)
	{
		return action.Done("Finished");
	}
	return action.Continue();
}

static void OnEnd(SF2_ChaserAttackAction action, SF2_ChaserEntity actor)
{
	CBaseNPC_RemoveAllLayers(actor.index, false);

	actor.IsAttacking = false;
	actor.IsAttemptingToMove = false;
	actor.CancelAttack = false;
	actor.GroundSpeedOverride = false;
	actor.MovementType = action.OldMovementType;

	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] != '\0' && strcmp(value, "-") != 0)
	{
		StopSound(actor.index, SNDCHAN_AUTO, value);
	}

	SF2NPC_Chaser controller = actor.Controller;
	if (controller.IsValid())
	{
		float gameTime = GetGameTime();
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileBaseAttack attackData = action.ProfileData;
		int difficulty = controller.Difficulty;

		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}

		actor.SetNextAttackTime(actor.GetAttackName(), gameTime + attackData.GetCooldown(difficulty));

		actor.InvokeOnEndAttack(actor.GetAttackName());
	}

	actor.State = action.OldState;

	actor.SetAttackName("");
	actor.AttackIndex = -1;
}

static void OnOtherKilled(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseCombatCharacter victim, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damagetype)
{
	actor.CheckTauntKill(SF2_BasePlayer(victim.index));
}

static any Native_GetType(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	return attackData.Type;
}

static any Native_GetDamageDelay(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetDelay(difficulty);
}

static any Native_GetRange(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetRange(difficulty);
}

static any Native_GetDamage(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetDamage(difficulty);
}

static any Native_GetDamageType(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetDamageType(difficulty);
}

static any Native_GetDamageForce(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetDamageForce(difficulty);
}

static any Native_GetViewPunchAngles(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);
	float vec[3];
	attackData.GetViewPunchAngles(difficulty, vec);
	SetNativeArray(3, vec, 3);
	return 0;
}

static any Native_GetDuration(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetDuration(difficulty);
}

static any Native_GetFOV(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetFOV(difficulty);
}

static any Native_GetBeginRange(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetBeginRange(difficulty);
}

static any Native_GetBeginFOV(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetBeginFOV(difficulty);
}

static any Native_GetCooldown(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetCooldown(difficulty);
}

static any Native_GetUseOnDifficulty(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	return attackData.UseOnDifficulty;
}

static any Native_GetBlockOnDifficulty(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	return attackData.BlockOnDifficulty;
}

static any Native_GetCanUseOnHealth(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.CanUseOnHealth(difficulty);
}

static any Native_GetCanBlockOnHealth(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.CanBlockOnHealth(difficulty);
}

static any Native_GetEventNumber(Handle plugin, int numParams)
{
	ChaserBossProfileBaseAttack attackData = GetNativeCell(1);
	if (attackData == null)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid profile object handle %x", attackData);
	}

	int difficulty = GetNativeCell(2);

	return attackData.GetEventNumber(difficulty);
}
