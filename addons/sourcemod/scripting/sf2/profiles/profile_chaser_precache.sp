#if defined _sf2_profiles_chaser_precache
 #endinput
#endif

#define _sf2_profiles_chaser_precache

#pragma semicolon 1

/**
 *	Parses and stores the unique values of a chaser profile from the current position in the profiles config.
 *	Returns true if loading was successful, false if not.
 */
bool LoadChaserBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen, SF2BossProfileData baseData)
{
	strcopy(loadFailReasonBuffer, loadFailReasonBufferLen, "");

	SF2ChaserBossProfileData profileData;
	profileData.Init();

	profileData.ClearLayersOnAnimUpdate = kv.GetNum("animation_clear_layers_on_update", profileData.ClearLayersOnAnimUpdate) != 0;

	GetProfileDifficultyFloatValues(kv, "walkspeed", profileData.WalkSpeed, profileData.WalkSpeed);

	profileData.WakeRadius = kv.GetFloat("wake_radius", profileData.WakeRadius);
	if (profileData.WakeRadius < 0.0)
	{
		profileData.WakeRadius = 0.0;
	}

	if (kv.JumpToKey("idle"))
	{
		profileData.IdleData.Load(kv);
		kv.GoBack();
	}

	if (kv.JumpToKey("alert"))
	{
		profileData.AlertData.Load(kv);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.AlertOnAlertInfo.Radius[i] = baseData.SearchRange[i];
		}
		profileData.AlertOnAlertInfo.Load(kv);

		kv.GoBack();
	}
	else
	{
		GetProfileDifficultyFloatValues(kv, "alert_gracetime", profileData.AlertData.GraceTime, profileData.AlertData.GraceTime);
		GetProfileDifficultyFloatValues(kv, "search_alert_gracetime", profileData.AlertData.GraceTime, profileData.AlertData.GraceTime);
		GetProfileDifficultyFloatValues(kv, "alert_duration", profileData.AlertData.Duration, profileData.AlertData.Duration);
		GetProfileDifficultyFloatValues(kv, "search_alert_duration", profileData.AlertData.Duration, profileData.AlertData.Duration);
	}

	if (kv.JumpToKey("chase"))
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.AlertOnChaseInfo.Radius[i] = baseData.SearchRange[i];
		}
		profileData.AlertOnChaseInfo.Load(kv);

		if (kv.JumpToKey("duration"))
		{
			GetProfileDifficultyFloatValues(kv, "max", profileData.ChaseDuration, profileData.ChaseDuration);

			if (kv.JumpToKey("add"))
			{
				GetProfileDifficultyFloatValues(kv, "target_range", profileData.ChaseDurationAddMaxRange, profileData.ChaseDurationAddMaxRange);
				GetProfileDifficultyFloatValues(kv, "visible_target_near", profileData.ChaseDurationAddVisibleMin, profileData.ChaseDurationAddVisibleMin);
				GetProfileDifficultyFloatValues(kv, "visible_target_far", profileData.ChaseDurationAddVisibleMax, profileData.ChaseDurationAddVisibleMax);
				GetProfileDifficultyFloatValues(kv, "attack", profileData.ChaseDurationAddOnAttack, profileData.ChaseDurationAddOnAttack);
				GetProfileDifficultyFloatValues(kv, "stunned", profileData.ChaseDurationAddOnStun, profileData.ChaseDurationAddOnStun);

				kv.GoBack();
			}

			kv.GoBack();
		}

		kv.GoBack();
	}
	else
	{
		GetProfileDifficultyFloatValues(kv, "chase_duration", profileData.ChaseDuration, profileData.ChaseDuration);
		GetProfileDifficultyFloatValues(kv, "search_chase_duration", profileData.ChaseDuration, profileData.ChaseDuration);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.ChaseDurationAddMaxRange[i] = baseData.SearchRange[i];
		}
		GetProfileDifficultyFloatValues(kv, "chase_duration_add_max_range", profileData.ChaseDurationAddMaxRange, profileData.ChaseDurationAddMaxRange);
		GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_min", profileData.ChaseDurationAddVisibleMin, profileData.ChaseDurationAddVisibleMin);
		GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_max", profileData.ChaseDurationAddVisibleMax, profileData.ChaseDurationAddVisibleMax);
	}

	if (kv.JumpToKey("senses"))
	{
		if (kv.JumpToKey("hearing"))
		{
			GetProfileDifficultyNumValues(kv, "threshold", profileData.SoundCountToAlert, profileData.SoundCountToAlert);
			GetProfileDifficultyFloatValues(kv, "discard_time", profileData.SoundPosDiscardTime, profileData.SoundPosDiscardTime);
			GetProfileDifficultyFloatValues(kv, "distance_tolerance", profileData.SoundPosDistanceTolerance, profileData.SoundPosDistanceTolerance);

			if (kv.JumpToKey("cooldown"))
			{
				GetProfileDifficultyFloatValues(kv, "footstep", profileData.FootstepSenses.Cooldown, profileData.FootstepSenses.Cooldown);
				GetProfileDifficultyFloatValues(kv, "footstep_loud", profileData.LoudFootstepSenses.Cooldown, profileData.LoudFootstepSenses.Cooldown);
				GetProfileDifficultyFloatValues(kv, "footstep_quiet", profileData.QuietFootstepSenses.Cooldown, profileData.QuietFootstepSenses.Cooldown);

				GetProfileDifficultyFloatValues(kv, "voice", profileData.VoiceSenses.Cooldown, profileData.VoiceSenses.Cooldown);
				GetProfileDifficultyFloatValues(kv, "weapon", profileData.WeaponSenses.Cooldown, profileData.WeaponSenses.Cooldown);
				GetProfileDifficultyFloatValues(kv, "flashlight", profileData.FlashlightSenses.Cooldown, profileData.FlashlightSenses.Cooldown);
				kv.GoBack();
			}
			if (kv.JumpToKey("add"))
			{
				GetProfileDifficultyNumValues(kv, "footstep", profileData.FootstepSenses.AddCount, profileData.FootstepSenses.AddCount);
				GetProfileDifficultyNumValues(kv, "footstep_loud", profileData.LoudFootstepSenses.AddCount, profileData.LoudFootstepSenses.AddCount);
				GetProfileDifficultyNumValues(kv, "footstep_quiet", profileData.QuietFootstepSenses.AddCount, profileData.QuietFootstepSenses.AddCount);

				GetProfileDifficultyNumValues(kv, "voice", profileData.VoiceSenses.AddCount, profileData.VoiceSenses.AddCount);
				GetProfileDifficultyNumValues(kv, "weapon", profileData.WeaponSenses.AddCount, profileData.WeaponSenses.AddCount);
				GetProfileDifficultyNumValues(kv, "flashlight", profileData.FlashlightSenses.AddCount, profileData.FlashlightSenses.AddCount);
				kv.GoBack();
			}
			kv.GoBack();
		}
		if (kv.JumpToKey("smell"))
		{
			profileData.SmellData.Load(kv);

			kv.GoBack();
		}
		kv.GoBack();
	}

	GetProfileDifficultyBoolValues(kv, "wander_move", profileData.CanWander, profileData.CanWander);
	GetProfileDifficultyFloatValues(kv, "wander_range_min", profileData.WanderRangeMin, profileData.WanderRangeMin);
	GetProfileDifficultyFloatValues(kv, "wander_range_max", profileData.WanderRangeMax, profileData.WanderRangeMax);
	GetProfileDifficultyFloatValues(kv, "wander_time_min", profileData.WanderTimeMin, profileData.WanderTimeMin);
	GetProfileDifficultyFloatValues(kv, "wander_time_max", profileData.WanderTimeMax, profileData.WanderTimeMax);
	GetProfileDifficultyFloatValues(kv, "wander_enter_time_min", profileData.WanderEnterTimeMin, profileData.WanderEnterTimeMin);
	GetProfileDifficultyFloatValues(kv, "wander_enter_time_max", profileData.WanderEnterTimeMax, profileData.WanderEnterTimeMax);

	if (kv.GetNum("stun_enabled", false) != 0)
	{
		SF2ChaserBossProfileStunData stunData;
		stunData = profileData.StunData;
		for (int i = 0; i < Difficulty_Max; i++)
		{
			stunData.Enabled[i] = true;
		}
		GetProfileDifficultyFloatValues(kv, "stun_cooldown", stunData.Cooldown, stunData.Cooldown);
		GetProfileDifficultyFloatValues(kv, "stun_health", stunData.Health, stunData.Health);

		GetProfileDifficultyFloatValues(kv, "stun_health_per_player", stunData.AddHealthPerPlayer, stunData.AddHealthPerPlayer);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_scout", stunData.AddHealthPerScout, stunData.AddHealthPerScout);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_soldier", stunData.AddHealthPerSoldier, stunData.AddHealthPerSoldier);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_pyro", stunData.AddHealthPerPyro, stunData.AddHealthPerPyro);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_demoman", stunData.AddHealthPerDemoman, stunData.AddHealthPerDemoman);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_heavyweapons", stunData.AddHealthPerHeavy, stunData.AddHealthPerHeavy);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_engineer", stunData.AddHealthPerEngineer, stunData.AddHealthPerEngineer);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_medic", stunData.AddHealthPerMedic, stunData.AddHealthPerMedic);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_sniper", stunData.AddHealthPerSniper, stunData.AddHealthPerSniper);
		GetProfileDifficultyFloatValues(kv, "stun_health_per_spy", stunData.AddHealthPerSpy, stunData.AddHealthPerSpy);

		GetProfileDifficultyBoolValues(kv, "stun_damage_flashlight_enabled", stunData.FlashlightStun, stunData.FlashlightStun);
		GetProfileDifficultyFloatValues(kv, "stun_damage_flashlight", stunData.FlashlightStunDamage, stunData.FlashlightStunDamage);

		GetProfileDifficultyBoolValues(kv, "chase_initial_on_stun", stunData.ChaseInitialOnEnd, stunData.ChaseInitialOnEnd);

		GetProfileDifficultyBoolValues(kv, "drop_item_on_stun", stunData.ItemDrop, stunData.ItemDrop);
		GetProfileDifficultyNumValues(kv, "drop_item_type", stunData.ItemDropType, stunData.ItemDropType);

		GetProfileDifficultyBoolValues(kv, "disappear_on_stun", stunData.Disappear, stunData.Disappear);

		stunData.KeyDrop = kv.GetNum("keydrop_enabled", stunData.KeyDrop) != 0;
		kv.GetString("key_model", stunData.KeyModel, sizeof(stunData.KeyModel), stunData.KeyModel);
		PrecacheModel2(stunData.KeyModel, _, _, g_FileCheckConVar.BoolValue);
		kv.GetString("key_trigger", stunData.KeyTrigger, sizeof(stunData.KeyTrigger), stunData.KeyTrigger);
		profileData.StunData = stunData;
	}
	else
	{
		if (kv.JumpToKey("stun"))
		{
			for (int i = 0; i < Difficulty_Max; i++)
			{
				profileData.StunData.Enabled[i] = true;
			}
			profileData.StunData.Load(kv, g_FileCheckConVar.BoolValue);
			kv.GoBack();
		}
	}

	if (kv.JumpToKey("resistances"))
	{
		profileData.DamageResistances = new ArrayList(sizeof(SF2ChaserBossProfileResistanceData));
		if (!kv.GotoFirstSubKey())
		{
			SF2ChaserBossProfileResistanceData resistanceData;
			resistanceData.Init();
			for (int i = 0; i < Difficulty_Max; i++)
			{
				resistanceData.Multiplier[i] = 0.0;
			}
			resistanceData.DamageTypes = new ArrayList();
			char key[64];
			int resistance = -1;
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				resistance = kv.GetNum(key, -1);
				if (resistance == -1)
				{
					break;
				}
				resistanceData.DamageTypes.Push(resistance);
			}
			profileData.DamageResistances.PushArray(resistanceData);
		}
		else
		{
			do
			{
				SF2ChaserBossProfileResistanceData resistance;
				resistance.Init();
				resistance.Load(kv);
				profileData.DamageResistances.PushArray(resistance);
			}
			while (kv.GotoNextKey());

			kv.GoBack();
		}
		kv.GoBack();
	}

	if (kv.JumpToKey("death"))
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.DeathData.Enabled[i] = true;
		}
		profileData.DeathData.Load(kv, g_FileCheckConVar.BoolValue);
		kv.GoBack();
	}

	profileData.BackstabDamageScale = kv.GetFloat("backstab_damage_scale", profileData.BackstabDamageScale);

	if (kv.JumpToKey("cloaking"))
	{
		profileData.CloakData.Load(kv, g_FileCheckConVar.BoolValue);
		kv.GoBack();
	}
	else if (kv.GetNum("cloak_enable", false) != 0)
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.CloakData.Enabled[i] = true;
		}
		GetProfileDifficultyFloatValues(kv, "cloak_cooldown", profileData.CloakData.Cooldown, profileData.CloakData.Cooldown);
		GetProfileDifficultyFloatValues(kv, "cloak_range", profileData.CloakData.CloakRange, profileData.CloakData.CloakRange);
		GetProfileDifficultyFloatValues(kv, "cloak_decloak_range", profileData.CloakData.DecloakRange, profileData.CloakData.DecloakRange);
		GetProfileDifficultyFloatValues(kv, "cloak_duration", profileData.CloakData.Duration, profileData.CloakData.Duration);

		GetProfileColorNoBacks(kv, "cloak_rendercolor", profileData.CloakData.CloakRenderColor[0], profileData.CloakData.CloakRenderColor[1], profileData.CloakData.CloakRenderColor[2], profileData.CloakData.CloakRenderColor[3],
								profileData.CloakData.CloakRenderColor[0], profileData.CloakData.CloakRenderColor[1], profileData.CloakData.CloakRenderColor[2], profileData.CloakData.CloakRenderColor[3]);

		profileData.CloakData.CloakRenderMode = kv.GetNum("cloak_rendermode", profileData.CloakData.CloakRenderMode);

		profileData.CloakData.CloakEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

		SF2BossProfileBaseEffectInfo particle1;
		particle1.Init();
		particle1.Type = EffectType_Particle;
		particle1.Event = EffectEvent_Constant;
		kv.GetString("cloak_particle", particle1.ParticleName, sizeof(particle1.ParticleName), "drg_cow_explosioncore_charged_blue");
		particle1.LifeTime = 0.1;
		particle1.Origin = {0.0, 0.0, 35.0};
		particle1.PostLoad();
		profileData.CloakData.CloakEffects.PushArray(particle1);

		char sound[PLATFORM_MAX_PATH];
		SF2BossProfileBaseEffectInfo sound1;
		sound1.Init();
		sound1.Type = EffectType_Sound;
		sound1.Event = EffectEvent_Constant;
		kv.GetString("cloak_on_sound", sound, sizeof(sound), "weapons/medi_shield_deploy.wav");
		TryPrecacheBossProfileSoundPath(sound, g_FileCheckConVar.BoolValue);
		sound1.SoundSounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		sound1.SoundSounds.Paths.PushString(sound);
		sound1.PostLoad();
		profileData.CloakData.CloakEffects.PushArray(sound1);

		profileData.CloakData.DecloakEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

		profileData.CloakData.DecloakEffects.PushArray(particle1);

		SF2BossProfileBaseEffectInfo sound2;
		sound2.Init();
		sound2.Type = EffectType_Sound;
		sound2.Event = EffectEvent_Constant;
		kv.GetString("cloak_off_sound", sound, sizeof(sound), "weapons/medi_shield_retract.wav");
		TryPrecacheBossProfileSoundPath(sound, g_FileCheckConVar.BoolValue);
		sound2.SoundSounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		sound2.SoundSounds.Paths.PushString(sound);
		sound2.PostLoad();
		profileData.CloakData.DecloakEffects.PushArray(sound2);

		SF2ChaserBossProfilePostureInfo posture;
		posture.Init();
		float multipliers[Difficulty_Max] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
		GetProfileDifficultyFloatValues(kv, "cloak_speed_multiplier", multipliers, multipliers);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			posture.Speed[i] = baseData.RunSpeed[i] * multipliers[i];
			posture.WalkSpeed[i] = profileData.WalkSpeed[i] * multipliers[i];
			posture.Acceleration[i] = baseData.Acceleration[i] * multipliers[i];
			posture.CloakInfo.Enabled[i] = true;
		}
		posture.Name = "Legacy Cloak";

		if (profileData.Postures == null)
		{
			profileData.Postures = new StringMap();
		}
		profileData.Postures.SetArray(posture.Name, posture, sizeof(posture));
	}

	profileData.ProjectilesEnabled = !!kv.GetNum("projectile_enable", profileData.ProjectilesEnabled);
	if (profileData.ProjectilesEnabled)
	{
		profileData.ProjectileType = kv.GetNum("projectile_type", profileData.ProjectileType);

		GetProfileDifficultyFloatValues(kv, "projectile_cooldown_min", profileData.ProjectileCooldownMin, profileData.ProjectileCooldownMin);
		GetProfileDifficultyFloatValues(kv, "projectile_cooldown_max", profileData.ProjectileCooldownMax, profileData.ProjectileCooldownMax);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_duration", profileData.IceballSlowDuration, profileData.IceballSlowDuration);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_percent", profileData.IceballSlowPercent, profileData.IceballSlowPercent);
		GetProfileDifficultyFloatValues(kv, "projectile_speed", profileData.ProjectileSpeed, profileData.ProjectileSpeed);
		GetProfileDifficultyFloatValues(kv, "projectile_damage", profileData.ProjectileDamage, profileData.ProjectileDamage);
		GetProfileDifficultyFloatValues(kv, "projectile_damageradius", profileData.ProjectileRadius, profileData.ProjectileRadius);
		GetProfileDifficultyFloatValues(kv, "projectile_deviation", profileData.ProjectileDeviation, profileData.ProjectileDeviation);
		GetProfileDifficultyNumValues(kv, "projectile_count", profileData.ProjectileCount, profileData.ProjectileCount);
		profileData.CriticalProjectiles = kv.GetNum("enable_crit_rockets", profileData.CriticalProjectiles) != 0;
		profileData.ShootGestures = kv.GetNum("use_gesture_shoot", profileData.ShootGestures) != 0;
		if (profileData.ShootGestures)
		{
			kv.GetString("gesture_shootprojectile", profileData.ShootGestureName, sizeof(profileData.ShootGestureName), profileData.ShootGestureName);
		}

		profileData.ProjectileClips = kv.GetNum("projectile_clips_enable", profileData.ProjectileClips) != 0;
		if (profileData.ProjectileClips)
		{
			GetProfileDifficultyNumValues(kv, "projectile_ammo_loaded", profileData.ProjectileClipSize, profileData.ProjectileClipSize);
			GetProfileDifficultyFloatValues(kv, "projectile_reload_time", profileData.ProjectileReloadTime, profileData.ProjectileReloadTime);
		}

		profileData.ChargeUpProjectiles = kv.GetNum("projectile_chargeup_enable", profileData.ChargeUpProjectiles) != 0;
		if (profileData.ChargeUpProjectiles)
		{
			GetProfileDifficultyFloatValues(kv, "projectile_chargeup_duration", profileData.ProjectileChargeUp, profileData.ProjectileChargeUp);
		}

		profileData.ProjectileRandomPosMin = kv.GetNum("projectile_pos_number_min", profileData.ProjectileRandomPosMin);
		if (profileData.ProjectileRandomPosMin < 0)
		{
			profileData.ProjectileRandomPosMin = 0;
		}
		profileData.ProjectileRandomPosMax = kv.GetNum("projectile_pos_number_max", profileData.ProjectileRandomPosMax);
		if (profileData.ProjectileRandomPosMax < profileData.ProjectileRandomPosMax)
		{
			profileData.ProjectileRandomPosMax = profileData.ProjectileRandomPosMin;
		}

		switch (profileData.ProjectileType)
		{
			case SF2BossProjectileType_Fireball:
			{
				kv.GetString("fire_explode_sound", profileData.FireballExplodeSound, sizeof(profileData.FireballExplodeSound), profileData.FireballExplodeSound);
				kv.GetString("fire_shoot_sound", profileData.FireballShootSound, sizeof(profileData.FireballShootSound), profileData.FireballShootSound);
				kv.GetString("fire_trail", profileData.FireballTrail, sizeof(profileData.FireballTrail), profileData.FireballTrail);

				TryPrecacheBossProfileSoundPath(profileData.FireballExplodeSound, g_FileCheckConVar.BoolValue);
				TryPrecacheBossProfileSoundPath(profileData.FireballShootSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_Iceball:
			{
				kv.GetString("fire_explode_sound", profileData.FireballExplodeSound, sizeof(profileData.FireballExplodeSound), profileData.FireballExplodeSound);
				kv.GetString("fire_shoot_sound", profileData.FireballShootSound, sizeof(profileData.FireballShootSound), profileData.FireballShootSound);
				kv.GetString("fire_iceball_slow_sound", profileData.IceballSlowSound, sizeof(profileData.IceballSlowSound), profileData.IceballSlowSound);
				kv.GetString("fire_iceball_trail", profileData.IceballTrail, sizeof(profileData.IceballTrail), profileData.IceballTrail);

				TryPrecacheBossProfileSoundPath(profileData.FireballExplodeSound, g_FileCheckConVar.BoolValue);
				TryPrecacheBossProfileSoundPath(profileData.FireballShootSound, g_FileCheckConVar.BoolValue);
				TryPrecacheBossProfileSoundPath(profileData.IceballSlowSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_Rocket:
			{
				kv.GetString("rocket_trail_particle", profileData.RocketTrail, sizeof(profileData.RocketTrail), profileData.RocketTrail);
				kv.GetString("rocket_explode_particle", profileData.RocketExplodeParticle, sizeof(profileData.RocketExplodeParticle), profileData.RocketExplodeParticle);
				kv.GetString("rocket_explode_sound", profileData.RocketExplodeSound, sizeof(profileData.RocketExplodeSound), profileData.RocketExplodeSound);
				kv.GetString("rocket_shoot_sound", profileData.RocketShootSound, sizeof(profileData.RocketShootSound), profileData.RocketShootSound);
				kv.GetString("rocket_model", profileData.RocketModel, sizeof(profileData.RocketModel), profileData.RocketModel);

				TryPrecacheBossProfileSoundPath(profileData.RocketExplodeSound, g_FileCheckConVar.BoolValue);
				TryPrecacheBossProfileSoundPath(profileData.RocketShootSound, g_FileCheckConVar.BoolValue);

				if (strcmp(profileData.RocketModel, ROCKET_MODEL, true) != 0)
				{
					if (!PrecacheModel(profileData.RocketModel, true))
					{
						LogSF2Message("Rocket model file %s failed to be loaded, likely does not exist. This will crash the server if not fixed.", profileData.RocketModel);
					}
					else
					{
						PrecacheModel2(profileData.RocketModel, _, _, g_FileCheckConVar.BoolValue);
					}
				}
			}
			case SF2BossProjectileType_Grenade:
			{
				kv.GetString("grenade_shoot_sound", profileData.GrenadeShootSound, sizeof(profileData.GrenadeShootSound), profileData.GrenadeShootSound);

				TryPrecacheBossProfileSoundPath(profileData.GrenadeShootSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_SentryRocket:
			{
				kv.GetString("sentryrocket_shoot_sound", profileData.SentryRocketShootSound, sizeof(profileData.SentryRocketShootSound), profileData.SentryRocketShootSound);

				TryPrecacheBossProfileSoundPath(profileData.SentryRocketShootSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_Arrow:
			{
				kv.GetString("arrow_shoot_sound", profileData.ArrowShootSound, sizeof(profileData.ArrowShootSound), profileData.ArrowShootSound);

				TryPrecacheBossProfileSoundPath(profileData.ArrowShootSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_Mangler:
			{
				kv.GetString("mangler_shoot_sound", profileData.ManglerShootSound, sizeof(profileData.ManglerShootSound), profileData.ManglerShootSound);

				TryPrecacheBossProfileSoundPath(profileData.ManglerShootSound, g_FileCheckConVar.BoolValue);
			}
			case SF2BossProjectileType_Baseball:
			{
				kv.GetString("baseball_model", profileData.BaseballModel, sizeof(profileData.BaseballModel), profileData.BaseballModel);
				kv.GetString("baseball_shoot_sound", profileData.BaseballShootSound, sizeof(profileData.BaseballShootSound), profileData.BaseballShootSound);

				TryPrecacheBossProfileSoundPath(profileData.BaseballShootSound, g_FileCheckConVar.BoolValue);
				PrecacheModel2(profileData.BaseballModel, _, _, g_FileCheckConVar.BoolValue);
			}
		}
		profileData.ProjectilePosOffsets = new ArrayList(3);
		if (profileData.ProjectileRandomPosMin == profileData.ProjectileRandomPosMax)
		{
			float position[3];
			kv.GetVector("projectile_pos_offset", position, position);
			kv.GetVector("projectile_pos_offset_1", position, position);
			profileData.ProjectilePosOffsets.PushArray(position);
		}
		else
		{
			char keyName[PLATFORM_MAX_PATH];
			float position[3];
			for (int i = 0; i <= profileData.ProjectileRandomPosMax; i++)
			{
				position = { 0.0, 0.0, 0.0 };
				FormatEx(keyName, sizeof(keyName), "projectile_pos_offset_%i", i);
				kv.GetVector(keyName, position, position);
				profileData.ProjectilePosOffsets.PushArray(position);
			}
		}
	}

	profileData.XenobladeCombo = kv.GetNum("xenoblade_chain_art_combo", profileData.XenobladeCombo) != 0;
	if (profileData.XenobladeCombo)
	{
		profileData.XenobladeDuration = kv.GetFloat("xenoblade_break_duration", profileData.XenobladeDuration);
		profileData.XenobladeToppleDuration = kv.GetFloat("xenoblade_topple_duration", profileData.XenobladeToppleDuration);
		profileData.XenobladeToppleSlowdown = kv.GetFloat("xenoblade_topple_slowdown", profileData.XenobladeToppleSlowdown);
		profileData.XenobladeDazeDuration = kv.GetFloat("xenoblade_daze_duration", profileData.XenobladeDazeDuration);
	}

	profileData.EarthquakeFootsteps = kv.GetNum("earthquake_footsteps", profileData.EarthquakeFootsteps) != 0;
	if (profileData.EarthquakeFootsteps)
	{
		profileData.EarthquakeFootstepAmplitude = kv.GetFloat("earthquake_footsteps_amplitude", profileData.EarthquakeFootstepAmplitude);
		profileData.EarthquakeFootstepFrequency = kv.GetFloat("earthquake_footsteps_frequency", profileData.EarthquakeFootstepFrequency);
		profileData.EarthquakeFootstepDuration = kv.GetFloat("earthquake_footsteps_duration", profileData.EarthquakeFootstepDuration);
		profileData.EarthquakeFootstepRadius = kv.GetFloat("earthquake_footsteps_radius", profileData.EarthquakeFootstepRadius);
		profileData.EarthquakeFootstepAirShake = kv.GetNum("earthquake_footsteps_airshake", profileData.EarthquakeFootstepAirShake) != 0;
	}

	GetProfileDifficultyBoolValues(kv, "traps_enabled", profileData.Traps, profileData.Traps);
	GetProfileDifficultyNumValues(kv, "trap_type", profileData.TrapType, profileData.TrapType);
	GetProfileDifficultyFloatValues(kv, "trap_spawn_cooldown", profileData.TrapCooldown, profileData.TrapCooldown);
	kv.GetString("trap_model", profileData.TrapModel, sizeof(profileData.TrapModel), profileData.TrapModel);
	kv.GetString("trap_deploy_sound", profileData.TrapDeploySound, sizeof(profileData.TrapDeploySound), profileData.TrapDeploySound);
	kv.GetString("trap_miss_sound", profileData.TrapMissSound, sizeof(profileData.TrapMissSound), profileData.TrapMissSound);
	kv.GetString("trap_catch_sound", profileData.TrapCatchSound, sizeof(profileData.TrapCatchSound), profileData.TrapCatchSound);
	kv.GetString("trap_animation_idle", profileData.TrapAnimIdle, sizeof(profileData.TrapAnimIdle), profileData.TrapAnimIdle);
	kv.GetString("trap_animation_closed", profileData.TrapAnimClose, sizeof(profileData.TrapAnimClose), profileData.TrapAnimClose);
	kv.GetString("trap_animation_open", profileData.TrapAnimOpen, sizeof(profileData.TrapAnimOpen), profileData.TrapAnimOpen);
	TryPrecacheBossProfileSoundPath(profileData.TrapDeploySound, g_FileCheckConVar.BoolValue);
	TryPrecacheBossProfileSoundPath(profileData.TrapMissSound, g_FileCheckConVar.BoolValue);
	TryPrecacheBossProfileSoundPath(profileData.TrapCatchSound, g_FileCheckConVar.BoolValue);

	if (strcmp(profileData.TrapModel, TRAP_MODEL, true) != 0)
	{
		if (!PrecacheModel(profileData.TrapModel, true))
		{
			LogSF2Message("Trap model file %s failed to be loaded, likely does not exist. This will crash the server if not fixed.", profileData.TrapModel);
		}
		else
		{
			PrecacheModel2(profileData.TrapModel, _, _, g_FileCheckConVar.BoolValue);
		}
	}

	if (kv.JumpToKey("autochase"))
	{
		GetProfileDifficultyBoolValues(kv, "enabled", profileData.AutoChaseEnabled, profileData.AutoChaseEnabled);
		GetProfileDifficultyNumValues(kv, "threshold", profileData.AutoChaseCount, profileData.AutoChaseCount);
		GetProfileDifficultyFloatValues(kv, "cooldown_after_chase", profileData.AutoChaseAfterChaseCooldown, profileData.AutoChaseAfterChaseCooldown);
		GetProfileDifficultyBoolValues(kv, "sprinters", profileData.AutoChaseSprinters, profileData.AutoChaseSprinters);
		if (kv.JumpToKey("add"))
		{
			GetProfileDifficultyNumValues(kv, "on_state_change", profileData.AutoChaseAdd, profileData.AutoChaseAdd);
			GetProfileDifficultyNumValues(kv, "footsteps", profileData.AutoChaseAddFootstep, profileData.AutoChaseAddFootstep);
			GetProfileDifficultyNumValues(kv, "footsteps_loud", profileData.AutoChaseAddLoudFootstep, profileData.AutoChaseAddLoudFootstep);
			GetProfileDifficultyNumValues(kv, "footsteps_quiet", profileData.AutoChaseAddQuietFootstep, profileData.AutoChaseAddQuietFootstep);
			GetProfileDifficultyNumValues(kv, "voice", profileData.AutoChaseAddVoice, profileData.AutoChaseAddVoice);
			GetProfileDifficultyNumValues(kv, "weapon", profileData.AutoChaseAddWeapon, profileData.AutoChaseAddWeapon);
			kv.GoBack();
		}
		kv.GoBack();
	}
	else
	{
		GetProfileDifficultyBoolValues(kv, "auto_chase_enabled", profileData.AutoChaseEnabled, profileData.AutoChaseEnabled);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_threshold", profileData.AutoChaseCount, profileData.AutoChaseCount);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add", profileData.AutoChaseAdd, profileData.AutoChaseAdd);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_footsteps", profileData.AutoChaseAddFootstep, profileData.AutoChaseAddFootstep);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_footsteps_loud", profileData.AutoChaseAddLoudFootstep, profileData.AutoChaseAddLoudFootstep);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_footsteps_quiet", profileData.AutoChaseAddQuietFootstep, profileData.AutoChaseAddQuietFootstep);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_voice", profileData.AutoChaseAddVoice, profileData.AutoChaseAddVoice);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_weapon", profileData.AutoChaseAddWeapon, profileData.AutoChaseAddWeapon);
		GetProfileDifficultyBoolValues(kv, "auto_chase_sprinters", profileData.AutoChaseSprinters, profileData.AutoChaseSprinters);
		GetProfileDifficultyFloatValues(kv, "auto_chase_cooldown_after_chase", profileData.AutoChaseAfterChaseCooldown, profileData.AutoChaseAfterChaseCooldown);
	}

	profileData.ChasesEndlessly = KvGetNum(kv, "boss_chases_endlessly", profileData.ChasesEndlessly) != 0;

	if (kv.JumpToKey("chase_on_look"))
	{
		profileData.ChaseOnLookData.Load(kv);
		kv.GoBack();
	}
	else
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.ChaseOnLookData.Enabled[i] = kv.GetNum("chase_upon_look") != 0;
			profileData.ChaseOnLookData.Enabled[i] = kv.GetNum("auto_chase_upon_look", profileData.ChaseOnLookData.Enabled[i]) != 0;
		}
	}

	profileData.BoxingBoss = kv.GetNum("boxing_boss", profileData.BoxingBoss) != 0;

	profileData.NormalSoundHook = kv.GetNum("normal_sound_hook", profileData.NormalSoundHook) != 0;

	profileData.OldAnimationAI = kv.GetNum("old_animation_ai", profileData.OldAnimationAI) != 0;

	if (kv.JumpToKey("rages"))
	{
		profileData.Rages = new ArrayList(sizeof(SF2ChaserRageInfo));
		if (kv.GotoFirstSubKey())
		{
			do
			{
				SF2ChaserRageInfo rage;
				rage.Init();
				rage.Load(kv, g_FileCheckConVar.BoolValue);
				profileData.Rages.PushArray(rage);
			}
			while (kv.GotoNextKey());

			kv.GoBack();
		}
		kv.GoBack();
	}
	else
	{
		if (profileData.BoxingBoss)
		{
			profileData.Rages = new ArrayList(sizeof(SF2ChaserRageInfo));
			SF2ChaserRageInfo rage1, rage2, rage3;
			rage1.Init();
			rage2.Init();
			rage3.Init();
			rage2.PercentageThreshold = 0.5;
			rage3.PercentageThreshold = 0.25;

			rage1.Name = "1";
			rage2.Name = "2";
			rage3.Name = "3";

			rage1.Invincible = true;
			rage2.Invincible = true;
			rage3.Invincible = true;

			if (kv.GetNum("self_heal_enabled", false) != 0)
			{
				rage1.Invincible = false;
				rage2.Invincible = false;
				rage3.Invincible = false;

				rage1.IsHealing = true;
				rage2.IsHealing = true;
				rage3.IsHealing = true;

				rage1.HealDelay = kv.GetFloat("heal_timer", 0.0);
				rage2.HealDelay = rage1.HealDelay;
				rage3.HealDelay = rage1.HealDelay;

				rage1.FleeRange[0] = kv.GetFloat("heal_range_min", 512.0);
				rage1.FleeRange[1] = kv.GetFloat("heal_range_max", 1024.0);
				rage2.FleeRange[0] = rage1.FleeRange[0];
				rage2.FleeRange[1] = rage1.FleeRange[1];
				rage3.FleeRange[0] = rage1.FleeRange[0];
				rage3.FleeRange[1] = rage1.FleeRange[1];

				rage1.PercentageThreshold = kv.GetFloat("health_percentage_to_heal", 0.35);
				rage2.PercentageThreshold = rage1.PercentageThreshold;
				rage3.PercentageThreshold = rage1.PercentageThreshold;

				rage1.HealAmount = kv.GetFloat("heal_percentage_one", 0.5);
				rage2.HealAmount = kv.GetFloat("heal_percentage_two", 0.5);
				rage3.HealAmount = kv.GetFloat("heal_percentage_three", 0.5);

				rage1.HealCloak = kv.GetNum("cloak_to_heal", false) != 0;
				rage2.HealCloak = rage1.HealCloak;
				rage3.HealCloak = rage1.HealCloak;
			}

			if (kv.JumpToKey("sound_rage"))
			{
				rage1.StartSounds.Load(kv, g_FileCheckConVar.BoolValue);
				kv.GoBack();
			}

			if (kv.JumpToKey("sound_rage_2"))
			{
				rage2.StartSounds.Load(kv, g_FileCheckConVar.BoolValue);
				kv.GoBack();
			}
			else
			{
				if (kv.JumpToKey("sound_rage"))
				{
					rage2.StartSounds.Load(kv, g_FileCheckConVar.BoolValue);
					kv.GoBack();
				}
			}

			if (kv.JumpToKey("sound_rage_3"))
			{
				rage3.StartSounds.Load(kv, g_FileCheckConVar.BoolValue);
				kv.GoBack();
			}
			else
			{
				if (kv.JumpToKey("sound_rage"))
				{
					rage3.StartSounds.Load(kv, g_FileCheckConVar.BoolValue);
					kv.GoBack();
				}
			}

			if (kv.JumpToKey("sound_heal_self"))
			{
				rage1.HealSounds.Load(kv, g_FileCheckConVar.BoolValue);
				rage2.HealSounds.Load(kv, g_FileCheckConVar.BoolValue);
				rage3.HealSounds.Load(kv, g_FileCheckConVar.BoolValue);
				kv.GoBack();
			}

			rage1.Animations.Init();
			rage2.Animations.Init();
			rage3.Animations.Init();
			rage1.Animations.Load(kv);
			rage2.Animations.Load(kv);
			rage3.Animations.Load(kv);

			StringMapSnapshot snapshot = rage1.Animations.Animations.Snapshot();
			SF2BossProfileAnimationSectionNameData animData;
			char animType[64];
			ArrayList animDataArray;
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, animType, sizeof(animType));
				if (strcmp(animType, "rage", false) == 0 || strcmp(animType, "heal", false) == 0 || strcmp(animType, "fleestart", false) == 0)
				{
					continue;
				}

				rage1.Animations.Animations.GetValue(animType, animDataArray);

				for (int j = 0; j < animDataArray.Length; j++)
				{
					animDataArray.GetArray(j, animData, sizeof(animData));
					animData.Destroy();
				}
				if (animDataArray != null)
				{
					delete animDataArray;
				}
				rage1.Animations.Animations.Remove(animType);
			}
			if (rage1.Animations.Animations.GetValue("rage", animDataArray) || rage1.Animations.Animations.GetValue("fleestart", animDataArray))
			{
				rage1.Animations.Animations.SetValue("start", animDataArray);
				rage1.Animations.Animations.Remove("rage");
				rage1.Animations.Animations.Remove("fleestart");
			}
			if (rage1.Animations.Animations.GetValue("heal", animDataArray))
			{
				rage1.Animations.Animations.SetValue("healing", animDataArray);
				rage1.Animations.Animations.Remove("heal");
			}
			delete snapshot;

			snapshot = rage2.Animations.Animations.Snapshot();
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, animType, sizeof(animType));
				if (strcmp(animType, "rage", false) == 0 || strcmp(animType, "heal", false) == 0 || strcmp(animType, "fleestart", false) == 0)
				{
					continue;
				}

				rage2.Animations.Animations.GetValue(animType, animDataArray);

				for (int j = 0; j < animDataArray.Length; j++)
				{
					animDataArray.GetArray(j, animData, sizeof(animData));
					animData.Destroy();
				}
				if (animDataArray != null)
				{
					delete animDataArray;
				}
				rage2.Animations.Animations.Remove(animType);
			}
			if (rage2.Animations.Animations.GetValue("rage", animDataArray) || rage1.Animations.Animations.GetValue("fleestart", animDataArray))
			{
				rage2.Animations.Animations.SetValue("start", animDataArray);
				rage2.Animations.Animations.Remove("rage");
				rage2.Animations.Animations.Remove("fleestart");
			}
			if (rage2.Animations.Animations.GetValue("heal", animDataArray))
			{
				rage2.Animations.Animations.SetValue("healing", animDataArray);
				rage2.Animations.Animations.Remove("heal");
			}
			delete snapshot;

			snapshot = rage3.Animations.Animations.Snapshot();
			for (int i = 0; i < snapshot.Length; i++)
			{
				snapshot.GetKey(i, animType, sizeof(animType));
				if (strcmp(animType, "rage", false) == 0 || strcmp(animType, "heal", false) == 0 || strcmp(animType, "fleestart", false) == 0)
				{
					continue;
				}

				rage3.Animations.Animations.GetValue(animType, animDataArray);

				for (int j = 0; j < animDataArray.Length; j++)
				{
					animDataArray.GetArray(j, animData, sizeof(animData));
					animData.Destroy();
				}
				if (animDataArray != null)
				{
					delete animDataArray;
				}
				rage3.Animations.Animations.Remove(animType);
			}
			if (rage3.Animations.Animations.GetValue("rage", animDataArray) || rage1.Animations.Animations.GetValue("fleestart", animDataArray))
			{
				rage3.Animations.Animations.SetValue("start", animDataArray);
				rage3.Animations.Animations.Remove("rage");
				rage3.Animations.Animations.Remove("fleestart");
			}
			if (rage3.Animations.Animations.GetValue("heal", animDataArray))
			{
				rage3.Animations.Animations.SetValue("healing", animDataArray);
				rage3.Animations.Animations.Remove("heal");
			}
			delete snapshot;

			profileData.Rages.PushArray(rage1, sizeof(rage1));
			profileData.Rages.PushArray(rage2, sizeof(rage2));
			profileData.Rages.PushArray(rage3, sizeof(rage3));
		}
	}

	profileData.Attacks = new ArrayList(sizeof(SF2ChaserBossProfileAttackData));

	int attackNums = ParseChaserProfileAttacks(kv, profileData, baseData);

	if (baseData.Flags & SFF_ATTACKPROPS)
	{
		profileData.AttackPropModels = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		if (kv.JumpToKey("attack_props_physics_models"))
		{
			char key[64], model[PLATFORM_MAX_PATH];
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				kv.GetString(key, model, sizeof(model));
				if (model[0] == '\0')
				{
					break;
				}
				profileData.AttackPropModels.PushString(model);
			}
			kv.GoBack();
		}
		else
		{
			delete profileData.AttackPropModels;
		}
	}

	if (profileData.NormalSoundHook)
	{
		profileData.IdleSounds.Channel = SNDCHAN_VOICE;
		profileData.AlertSounds.Channel = SNDCHAN_VOICE;
		profileData.ChasingSounds.Channel = SNDCHAN_VOICE;
		profileData.ChaseInitialSounds.Channel = SNDCHAN_VOICE;
		profileData.StunnedSounds.Channel = SNDCHAN_VOICE;
		profileData.DeathSounds.Channel = SNDCHAN_VOICE;
		profileData.TauntKillSounds.Channel = SNDCHAN_VOICE;
		profileData.SmellSounds.Channel = SNDCHAN_VOICE;
		profileData.SelfHealSounds.Channel = SNDCHAN_VOICE;
		profileData.RageSounds1.Channel = SNDCHAN_VOICE;
		profileData.RageSounds2.Channel = SNDCHAN_VOICE;
		profileData.RageSounds3.Channel = SNDCHAN_VOICE;
	}

	ArrayList validSections = new ArrayList(ByteCountToCells(128));

	// We have to copy and paste here, the previous kv.GotoFirstSubKey() in profile_boss_functions.sp will somehow reset all values of these sound sections
	if (kv.GotoFirstSubKey())
	{
		char s2[64];

		do
		{
			kv.GetSectionName(s2, sizeof(s2));

			if (validSections.FindString(s2) != -1)
			{
				continue;
			}

			validSections.PushString(s2);

			if (!StrContains(s2, "sound_"))
			{
				profileData.SortSoundSections(kv, s2, g_FileCheckConVar.BoolValue);
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	delete validSections;

	if (attackNums > 0)
	{
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_Attack]))
		{
			profileData.LoadNestedSoundSections(g_SlenderVoiceList[SF2BossSound_Attack], kv, g_FileCheckConVar.BoolValue, profileData.AttackSounds, profileData.NormalSoundHook, profileData);
		}
		if (kv.JumpToKey("sound_hitenemy"))
		{
			profileData.LoadNestedSoundSections("sound_hitenemy", kv, g_FileCheckConVar.BoolValue, profileData.HitSounds, false, profileData);
		}
		if (kv.JumpToKey("sound_missenemy"))
		{
			profileData.LoadNestedSoundSections("sound_missenemy", kv, g_FileCheckConVar.BoolValue, profileData.MissSounds, false, profileData);
		}
		if (kv.JumpToKey("sound_bulletshoot"))
		{
			profileData.LoadNestedSoundSections("sound_bulletshoot", kv, g_FileCheckConVar.BoolValue, profileData.BulletShootSounds, false, profileData);
		}
		if (kv.JumpToKey("sound_attackshootprojectile"))
		{
			profileData.LoadNestedSoundSections("sound_attackshootprojectile", kv, g_FileCheckConVar.BoolValue, profileData.ProjectileShootSounds, false, profileData);
		}
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_AttackBegin]))
		{
			profileData.LoadNestedSoundSections(g_SlenderVoiceList[SF2BossSound_AttackBegin], kv, g_FileCheckConVar.BoolValue, profileData.AttackBeginSounds, profileData.NormalSoundHook, profileData);
		}
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_AttackEnd]))
		{
			profileData.LoadNestedSoundSections(g_SlenderVoiceList[SF2BossSound_AttackEnd], kv, g_FileCheckConVar.BoolValue, profileData.AttackEndSounds, profileData.NormalSoundHook, profileData);
		}
		if (kv.JumpToKey("sound_attack_loop"))
		{
			profileData.LoadNestedSoundSections("sound_attack_loop", kv, g_FileCheckConVar.BoolValue, profileData.AttackLoopSounds, false, profileData);
		}

		if (kv.GetNum("player_damage_effects", false) != 0)
		{
			if (kv.GetNum("player_damage_random_effects", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Random, _, attackNums);
			}

			if (kv.GetNum("player_jarate_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Jarate, _, attackNums);
			}

			if (kv.GetNum("player_milk_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Milk, _, attackNums);
			}

			if (kv.GetNum("player_gas_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Gas, _, attackNums);
			}

			if (kv.GetNum("player_mark_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Mark, _, attackNums);
			}

			if (kv.GetNum("player_silent_mark_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Mark, true, attackNums);
			}

			if (kv.GetNum("player_ignite_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Ignite, _, attackNums);
			}

			if (kv.GetNum("player_stun_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Stun, _, attackNums);
			}

			if (kv.GetNum("player_bleed_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Bleed, _, attackNums);
			}

			if (kv.GetNum("player_electric_slow_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Stun, true, attackNums);
			}

			if (kv.GetNum("player_smite_on_hit", false) != 0)
			{
				LoadLegacyEffects(kv, profileData, SF2DamageType_Smite, _, attackNums);
			}
		}

		if (kv.GetNum("shockwave", false) != 0)
		{
			char indexes[128], index[64][64], buffer[PLATFORM_MAX_PATH];
			kv.GetString("shockwave_attack_index", indexes, sizeof(indexes), "1");
			int nums = ExplodeString(indexes, " ", index, sizeof(index), sizeof(index));

			for (int i = 0; i < attackNums; i++)
			{
				SF2ChaserBossProfileAttackData attackData;
				profileData.GetAttackFromIndex(i, attackData);

				for (int i2 = 0; i2 < nums; i2++)
				{
					if (strcmp(attackData.Name, index[i2]) != 0)
					{
						continue;
					}

					attackData.Shockwave.Enabled = true;

					GetProfileDifficultyFloatValues(kv, "shockwave_height", attackData.Shockwave.Height, attackData.Shockwave.Height);
					GetProfileDifficultyFloatValues(kv, "shockwave_range", attackData.Shockwave.Radius, attackData.Shockwave.Radius);
					GetProfileDifficultyFloatValues(kv, "shockwave_drain", attackData.Shockwave.BatteryDrainPercent, attackData.Shockwave.BatteryDrainPercent);
					GetProfileDifficultyFloatValues(kv, "shockwave_force", attackData.Shockwave.Force, attackData.Shockwave.Force);

					if (kv.GetNum("shockwave_stun", false) != 0)
					{
						if (attackData.Shockwave.DamageEffects == null)
						{
							attackData.Shockwave.DamageEffects = new ArrayList(sizeof(SF2ChaserBossProfileDamageEffectData));
						}
						SF2ChaserBossProfileDamageEffectData damageData;
						damageData.Init();
						damageData.SetType("stun");
						damageData.StunFlags = new ArrayList(ByteCountToCells(256));
						for (int i3 = 0; i3 < Difficulty_Max; i3++)
						{
							damageData.StunFlags.PushString("slow");
						}

						GetProfileDifficultyFloatValues(kv, "shockwave_stun_duration", damageData.Duration, damageData.Duration);
						GetProfileDifficultyFloatValues(kv, "shockwave_stun_slowdown", damageData.StunSlowdown, damageData.StunSlowdown);

						attackData.Shockwave.DamageEffects.PushArray(damageData, sizeof(damageData));
					}

					if (attackData.Shockwave.Effects == null)
					{
						attackData.Shockwave.Effects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
					}
					SF2BossProfileBaseEffectInfo effect1;
					effect1.Init();
					effect1.Type = EffectType_TempEntBeamRing;
					effect1.Event = EffectEvent_Constant;
					effect1.BeamRingWidth = kv.GetFloat("shockwave_width_1", 40.0);
					effect1.BeamRingEndRadius = attackData.Shockwave.Radius[1];
					effect1.BeamRingSpeed = RoundToNearest(attackData.Shockwave.Radius[1]);
					effect1.BeamRingAmplitude = kv.GetFloat("shockwave_amplitude", 5.0);
					effect1.LifeTime = 0.3;

					kv.GetString("shockwave_beam_sprite", effect1.BeamRingBeamSprite, sizeof(effect1.BeamRingBeamSprite), effect1.BeamRingBeamSprite);
					if (effect1.BeamRingBeamSprite[0] != '\0')
					{
						effect1.BeamRingBeamModel = PrecacheModel(effect1.BeamRingBeamSprite, true);
						FormatEx(buffer, sizeof(buffer), "materials/%s", effect1.BeamRingBeamSprite);
						AddFileToDownloadsTable(buffer);
					}

					kv.GetString("shockwave_halo_sprite", effect1.BeamRingHaloSprite, sizeof(effect1.BeamRingHaloSprite), effect1.BeamRingHaloSprite);
					if (effect1.BeamRingHaloSprite[0] != '\0')
					{
						effect1.BeamRingHaloModel = PrecacheModel(effect1.BeamRingHaloSprite, true);
						FormatEx(buffer, sizeof(buffer), "materials/%s", effect1.BeamRingHaloSprite);
						AddFileToDownloadsTable(buffer);
					}

					char color[32];
					kv.GetString("shockwave_color_1", buffer, sizeof(buffer), "128 128 128");
					FormatEx(color, sizeof(color), "%s %i", buffer, kv.GetNum("shockwave_alpha_1", 255));
					strcopy(effect1.BeamRingColor, sizeof(effect1.BeamRingColor), color);

					effect1.BeamRingFrameRate = 30;

					attackData.Shockwave.Effects.PushArray(effect1, sizeof(effect1));

					SF2BossProfileBaseEffectInfo effect2;
					effect2.Init();
					effect2.Type = EffectType_TempEntBeamRing;
					effect2.Event = EffectEvent_Constant;
					effect2.BeamRingWidth = kv.GetFloat("shockwave_width_2", 20.0);
					effect2.BeamRingEndRadius = attackData.Shockwave.Radius[1];
					effect2.BeamRingSpeed = RoundToNearest(attackData.Shockwave.Radius[1]);
					effect2.BeamRingAmplitude = effect1.BeamRingAmplitude;
					effect2.LifeTime = 0.2;

					strcopy(effect2.BeamRingBeamSprite, sizeof(effect2.BeamRingBeamSprite), effect1.BeamRingBeamSprite);
					effect2.BeamRingBeamModel = effect1.BeamRingBeamModel;

					strcopy(effect2.BeamRingHaloSprite, sizeof(effect2.BeamRingHaloSprite), effect1.BeamRingHaloSprite);
					effect2.BeamRingHaloModel = effect1.BeamRingHaloModel;

					kv.GetString("shockwave_color_2", buffer, sizeof(buffer), "255 255 255");
					FormatEx(color, sizeof(color), "%s %i", buffer, kv.GetNum("shockwave_alpha_2", 255));
					strcopy(effect2.BeamRingColor, sizeof(effect2.BeamRingColor), color);

					effect2.BeamRingFrameRate = 30;

					attackData.Shockwave.Effects.PushArray(effect2, sizeof(effect2));

					profileData.Attacks.SetArray(i, attackData, sizeof(attackData));
				}
			}
		}
	}

	if (kv.JumpToKey("postures"))
	{
		if (profileData.Postures == null)
		{
			profileData.Postures = new StringMap();
		}

		if (kv.GotoFirstSubKey())
		{
			do
			{
				SF2ChaserBossProfilePostureInfo posture;
				posture.Init();
				for (int i = 0; i < Difficulty_Max; i++)
				{
					posture.Speed[i] = baseData.RunSpeed[i];
					posture.WalkSpeed[i] = profileData.WalkSpeed[i];
					posture.Acceleration[i] = baseData.Acceleration[i];
				}
				posture.Load(kv);
				profileData.Postures.SetArray(posture.Name, posture, sizeof(posture));
			}
			while (kv.GotoNextKey());

			kv.GoBack();
		}
		kv.GoBack();
	}

	if (kv.GetNum("use_alert_walking_animation", false) != 0)
	{
		if (profileData.Postures == null)
		{
			profileData.Postures = new StringMap();
		}
		SF2ChaserBossProfilePostureInfo posture;
		posture.Init();
		for (int i = 0; i < Difficulty_Max; i++)
		{
			posture.Speed[i] = baseData.RunSpeed[i];
			posture.WalkSpeed[i] = profileData.WalkSpeed[i];
			posture.Acceleration[i] = baseData.Acceleration[i];
			posture.AlertInfo.Enabled[i] = true;
		}
		posture.Name = "Legacy Walk Alert";
		posture.Animations.Load(kv);
		StringMapSnapshot snapshot = posture.Animations.Animations.Snapshot();
		SF2BossProfileAnimationSectionNameData animData;
		char animType[64];
		ArrayList animDataArray;
		for (int i = 0; i < snapshot.Length; i++)
		{
			snapshot.GetKey(i, animType, sizeof(animType));
			if (strcmp(animType, "walkalert", false) == 0)
			{
				continue;
			}
			posture.Animations.Animations.GetValue(animType, animDataArray);

			for (int j = 0; j < animDataArray.Length; j++)
			{
				animDataArray.GetArray(j, animData, sizeof(animData));
				animData.Destroy();
			}
			if (animDataArray != null)
			{
				delete animDataArray;
			}
			posture.Animations.Animations.Remove(animType);
		}

		if (posture.Animations.Animations.GetValue("walkalert", animDataArray))
		{
			posture.Animations.Animations.SetValue("walk", animDataArray);
			posture.Animations.Animations.Remove("walkalert");
			profileData.Postures.SetArray(posture.Name, posture, sizeof(posture));
		}
		delete snapshot;
	}

	profileData.PostLoad();

	g_ChaserBossProfileData.SetArray(profile, profileData, sizeof(profileData));

	return true;
}

// #define THIS_IS_A_FUCKING_MESS
static void LoadLegacyEffects(KeyValues kv, SF2ChaserBossProfileData profileData, int type = SF2DamageType_Jarate, bool alt = false, int maxAttacks = 0)
{
	char key[64];

	bool attach = kv.GetNum("player_attach_particle", true) != 0;
	char flag[32];
	flag[0] = '\0';
	switch (kv.GetNum("player_stun_type", 0))
	{
		case 1:
		{
			flag = "slow";
		}

		case 2:
		{
			flag = "loser";
		}

		case 3:
		{
			flag = "no_fx stuck";
		}

		case 4:
		{
			flag = "boo";
		}
	}

	switch (type)
	{
		case SF2DamageType_Bleed:
		{
			key = "player_bleed_attack_indexs";
		}

		case SF2DamageType_Gas:
		{
			key = "player_gas_attack_indexs";
		}

		case SF2DamageType_Ignite:
		{
			key = "player_ignite_attack_indexs";
		}

		case SF2DamageType_Jarate:
		{
			key = "player_jarate_attack_indexs";
		}

		case SF2DamageType_Mark:
		{
			key = "player_mark_attack_indexs";
			if (alt)
			{
				key = "player_silent_mark_attack_indexs";
			}
		}

		case SF2DamageType_Milk:
		{
			key = "player_milk_attack_indexs";
		}

		case SF2DamageType_Random:
		{
			key = "player_random_attack_indexes";
		}

		case SF2DamageType_Smite:
		{
			key = "player_smite_attack_indexs";
		}

		case SF2DamageType_Stun:
		{
			key = "player_stun_attack_indexs";
			if (alt)
			{
				key = "player_electrocute_attack_indexs";
			}
		}
	}

	char indexes[128], index[64][64];
	kv.GetString(key, indexes, sizeof(indexes), "1");
	int nums = ExplodeString(indexes, " ", index, sizeof(index), sizeof(index));

	for (int i = 0; i < maxAttacks; i++)
	{
		SF2ChaserBossProfileAttackData attackData;
		profileData.GetAttackFromIndex(i, attackData);

		for (int i2 = 0; i2 < nums; i2++)
		{
			if (strcmp(attackData.Name, index[i2]) != 0)
			{
				continue;
			}

			SF2ChaserBossProfileDamageEffectData damageEffect;
			damageEffect.Init();
			switch (type)
			{
				case SF2DamageType_Bleed:
				{
					key = "player_bleed_attack_indexs";
					damageEffect.SetType("bleed");
				}

				case SF2DamageType_Gas:
				{
					key = "player_gas_attack_indexs";
					damageEffect.SetType("gas");
				}

				case SF2DamageType_Ignite:
				{
					key = "player_ignite_attack_indexs";
					damageEffect.SetType("ignite");
				}

				case SF2DamageType_Jarate:
				{
					key = "player_jarate_attack_indexs";
					damageEffect.SetType("jarate");
				}

				case SF2DamageType_Mark:
				{
					key = "player_mark_attack_indexs";
					if (alt)
					{
						key = "player_silent_mark_attack_indexs";
					}
					damageEffect.SetType("mark");
				}

				case SF2DamageType_Milk:
				{
					key = "player_milk_attack_indexs";
					damageEffect.SetType("milk");
				}

				case SF2DamageType_Random:
				{
					key = "player_random_attack_indexes";
					damageEffect.SetType("random");
					damageEffect.Types.Push(SF2DamageType_Ignite);
					damageEffect.Types.Push(SF2DamageType_Gas);
					damageEffect.Types.Push(SF2DamageType_Bleed);
					damageEffect.Types.Push(SF2DamageType_Mark);
					damageEffect.Types.Push(SF2DamageType_Jarate);
					damageEffect.Types.Push(SF2DamageType_Milk);
					damageEffect.Types.Push(SF2DamageType_Stun);
				}

				case SF2DamageType_Smite:
				{
					key = "player_smite_attack_indexs";
					damageEffect.SetType("smite");
				}

				case SF2DamageType_Stun:
				{
					key = "player_stun_attack_indexs";
					if (alt)
					{
						key = "player_electrocute_attack_indexs";
					}
					damageEffect.SetType("stun");
				}
			}

			if (attackData.DamageEffects == null)
			{
				attackData.DamageEffects = new ArrayList(sizeof(SF2ChaserBossProfileDamageEffectData));
			}

			switch (damageEffect.Type)
			{
				case SF2DamageType_Bleed:
				{
					key = "player_bleed_duration";
				}

				case SF2DamageType_Gas:
				{
					key = "player_gas_duration";
				}

				case SF2DamageType_Ignite:
				{
					key = "player_ignite_duration";
				}

				case SF2DamageType_Jarate:
				{
					key = "player_jarate_duration";
				}

				case SF2DamageType_Mark:
				{
					key = "player_mark_duration";
					if (alt)
					{
						key = "player_silent_mark_duration";
					}
				}

				case SF2DamageType_Milk:
				{
					key = "player_milk_duration";
				}

				case SF2DamageType_Random:
				{
					key = "player_random_duration";
				}

				case SF2DamageType_Stun:
				{
					key = "player_stun_duration";
					if (alt)
					{
						key = "player_electric_slow_duration";
					}
				}

				default:
				{
					key[0] = '\0';
				}
			}

			if (key[0] != '\0')
			{
				GetProfileDifficultyFloatValues(kv, key, damageEffect.Duration, damageEffect.Duration);
			}

			if (damageEffect.Type == SF2DamageType_Mark && alt)
			{
				for (int i3 = 0; i3 < Difficulty_Max; i3++)
				{
					damageEffect.MarkSilent[i3] = true;
				}
			}

			if (damageEffect.Type == SF2DamageType_Stun)
			{
				if (alt)
				{
					key = "player_electric_slow_slowdown";
				}
				else
				{
					key = "player_stun_slowdown";
				}

				if (damageEffect.StunFlags == null)
				{
					damageEffect.StunFlags = new ArrayList(ByteCountToCells(256));
				}

				GetProfileDifficultyFloatValues(kv, key, damageEffect.StunSlowdown, damageEffect.StunSlowdown);

				for (int i3 = 0; i3 < Difficulty_Max; i3++)
				{
					damageEffect.StunFlags.PushString(flag);
				}
			}
			else if (damageEffect.Type == SF2DamageType_Random)
			{
				switch (kv.GetNum("player_random_stun_type", 0))
				{
					case 1:
					{
						flag = "slow";
					}

					case 2:
					{
						flag = "loser";
					}

					case 3:
					{
						flag = "no_fx stuck";
					}

					case 4:
					{
						flag = "boo";
					}
				}

				if (damageEffect.StunFlags == null)
				{
					damageEffect.StunFlags = new ArrayList(ByteCountToCells(256));
				}

				GetProfileDifficultyFloatValues(kv, "player_random_slowdown", damageEffect.StunSlowdown, damageEffect.StunSlowdown);

				for (int i3 = 0; i3 < Difficulty_Max; i3++)
				{
					damageEffect.StunFlags.PushString(flag);
				}
			}

			if (damageEffect.Type == SF2DamageType_Smite)
			{
				GetProfileDifficultyFloatValues(kv, "player_smite_damage", damageEffect.SmiteDamage, damageEffect.SmiteDamage);
				GetProfileDifficultyNumValues(kv, "player_smite_damage_type", damageEffect.SmiteDamageType, damageEffect.SmiteDamageType);

				damageEffect.SmiteColor[0] = kv.GetNum("player_smite_color_r", 255);
				damageEffect.SmiteColor[1] = kv.GetNum("player_smite_color_g", 255);
				damageEffect.SmiteColor[2] = kv.GetNum("player_smite_color_b", 255);
				damageEffect.SmiteColor[3] = kv.GetNum("player_smite_transparency", 255);

				damageEffect.SmiteMessage = kv.GetNum("player_smite_message", damageEffect.SmiteMessage) != 0;

				kv.GetString("hit_sound", damageEffect.SmiteHitSound, sizeof(damageEffect.SmiteHitSound), damageEffect.SmiteHitSound);
			}

			bool create = false;
			switch (damageEffect.Type)
			{
				case SF2DamageType_Gas, SF2DamageType_Jarate, SF2DamageType_Milk, SF2DamageType_Stun:
				{
					create = true;
				}
			}

			if (create)
			{
				switch (damageEffect.Type)
				{
					case SF2DamageType_Gas:
					{
						key = "player_gas_beam_particle";
					}

					case SF2DamageType_Jarate:
					{
						key = "player_jarate_beam_particle";
					}

					case SF2DamageType_Milk:
					{
						key = "player_milk_beam_particle";
					}

					case SF2DamageType_Stun:
					{
						key = "player_stun_beam_particle";
						if (alt)
						{
							key = "player_electric_beam_particle";
						}
					}
				}

				SF2ParticleData particle;
				particle.Init();
				particle.BeamParticles = kv.GetNum(key, false) != 0;
				particle.AttachParticles = attach;

				char particleName[128];
				switch (damageEffect.Type)
				{
					case SF2DamageType_Gas:
					{
						key = "player_gas_particle";
						particleName = "gas_can_impact_blue";
					}

					case SF2DamageType_Jarate:
					{
						key = "player_jarate_particle";
						particleName = "peejar_impact";
					}

					case SF2DamageType_Milk:
					{
						key = "player_milk_particle";
						particleName = "peejar_impact_milk";
					}

					case SF2DamageType_Stun:
					{
						key = "player_stun_particle";
						particleName = "xms_icicle_melt";
						if (alt)
						{
							key = "player_electric_red_particle";
							particleName = "electrocuted_gibbed_red";
						}
					}
				}

				kv.GetString(key, particle.ParticleName, sizeof(particle.ParticleName), particleName);

				if (particleName[0] != '\0')
				{
					if (damageEffect.Particles == null)
					{
						damageEffect.Particles = new ArrayList(sizeof(SF2ParticleData));
					}
					damageEffect.Particles.PushArray(particle, sizeof(particle));
				}

				if (damageEffect.Sounds.Paths == null && !alt)
				{
					damageEffect.Sounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
				}

				char sound[PLATFORM_MAX_PATH];
				switch (damageEffect.Type)
				{
					case SF2DamageType_Gas:
					{
						key = "player_gas_sound";
						sound = "weapons/jar_single.wav";
					}

					case SF2DamageType_Jarate:
					{
						key = "player_jarate_sound";
						sound = "weapons/jar_single.wav";
					}

					case SF2DamageType_Milk:
					{
						key = "player_milk_sound";
						sound = "weapons/jar_single.wav";
					}

					case SF2DamageType_Stun:
					{
						key = "player_stun_sound";
						sound = "weapons/icicle_freeze_victim_01.wav";
					}
				}

				if (!alt)
				{
					kv.GetString(key, sound, sizeof(sound), sound);
					if (sound[0] != '\0')
					{
						TryPrecacheBossProfileSoundPath(sound, g_FileCheckConVar.BoolValue);
						damageEffect.Sounds.Paths.PushString(sound);
						damageEffect.Sounds.PostLoad();
					}
				}
			}

			attackData.DamageEffects.PushArray(damageEffect);

			profileData.Attacks.SetArray(i, attackData, sizeof(attackData));
		}
	}
}

static int ParseChaserProfileAttacks(KeyValues kv, SF2ChaserBossProfileData chaserProfileData, SF2BossProfileData baseData)
{
	// Create the array.
	ArrayList attacks = chaserProfileData.Attacks;

	bool oldStuff = false;
	if (!kv.JumpToKey("attacks"))
	{
		oldStuff = true;
		if (kv.GetDataType("attack_damage") == KvData_None)
		{
			return -1;
		}
	}

	if (!oldStuff && !kv.GotoFirstSubKey())
	{
		LogSF2Message("[SF2 PROFILES PARSER] Critical error, found \"attacks\" section with no attacks inside of it!");
		kv.GoBack();
		return -1;
	}

	char attackName[64];
	int index = 0;
	do
	{
		kv.GetSectionName(attackName, sizeof(attackName));

		SF2ChaserBossProfileAttackData attackData;
		attackData.Init();

		attackData.Index = index;
		attackData.Name = attackName;

		if (!oldStuff)
		{
			attackData.Type = kv.GetNum("type", attackData.Type);
			GetProfileDifficultyFloatValues(kv, "range", attackData.Range, attackData.Range);
			GetProfileDifficultyFloatValues(kv, "damage", attackData.Damage, attackData.Damage);
			GetProfileDifficultyFloatValues(kv, "damage_percent", attackData.DamagePercent, attackData.DamagePercent);
			attackData.DamageVsProps = kv.GetFloat("damage_vs_props", attackData.DamageVsProps);
			GetProfileDifficultyFloatValues(kv, "damageforce", attackData.DamageForce, attackData.DamageForce);
			GetProfileDifficultyNumValues(kv, "damagetype", attackData.DamageType, attackData.DamageType);

			attackData.CanUseAgainstProps = kv.GetNum("props", attackData.CanUseAgainstProps) != 0;

			GetProfileDifficultyFloatValues(kv, "delay", attackData.DamageDelay, attackData.DamageDelay);

			kv.GetVector("punchvel", attackData.PunchVelocity, attackData.PunchVelocity);

			GetProfileDifficultyFloatValues(kv, "duration", attackData.Duration, attackData.Duration);

			GetProfileDifficultyFloatValues(kv, "fov", attackData.Spread, attackData.Spread);
			GetProfileDifficultyFloatValues(kv, "spread", attackData.Spread, attackData.Spread);
			GetProfileDifficultyFloatValues(kv, "begin_range", attackData.BeginRange, attackData.BeginRange);
			GetProfileDifficultyFloatValues(kv, "begin_fov", attackData.BeginFOV, attackData.Spread);
			GetProfileDifficultyFloatValues(kv, "cooldown", attackData.Cooldown, attackData.Cooldown);

			GetProfileDifficultyBoolValues(kv, "disappear", attackData.Disappear, attackData.Disappear);
			GetProfileDifficultyBoolValues(kv, "disappear_upon_damaging", attackData.DisappearOnHit, attackData.DisappearOnHit);
		}
		attackData.Type = kv.GetNum("attack_type", attackData.Type);

		GetProfileDifficultyFloatValues(kv, "attack_range", attackData.Range, attackData.Range);

		GetProfileDifficultyFloatValues(kv, "attack_damage", attackData.Damage, attackData.Damage);

		attackData.DamageVsProps = kv.GetFloat("attack_damage_vs_props", attackData.DamageVsProps);
		GetProfileDifficultyFloatValues(kv, "attack_damageforce", attackData.DamageForce, attackData.DamageForce);

		GetProfileDifficultyNumValues(kv, "attack_damagetype", attackData.DamageType, attackData.DamageType);

		attackData.CanUseAgainstProps = kv.GetNum("attack_props", attackData.CanUseAgainstProps) != 0;

		kv.GetVector("attack_punchvel", attackData.PunchVelocity, attackData.PunchVelocity);

		GetProfileDifficultyFloatValues(kv, "attack_delay", attackData.DamageDelay, attackData.DamageDelay);

		GetProfileDifficultyFloatValues(kv, "attack_duration", attackData.Duration, attackData.Duration);
		bool backwardsCompatibility = true;
		for (int i = 0; i < Difficulty_Max; i++)
		{
			if (attackData.Duration[i] > 0.0)
			{
				backwardsCompatibility = false;
			}
		}
		if (backwardsCompatibility) // Backward compatibility
		{
			float endAfter[Difficulty_Max];
			if (!oldStuff)
			{
				GetProfileDifficultyFloatValues(kv, "endafter", endAfter, endAfter);
			}
			GetProfileDifficultyFloatValues(kv, "attack_endafter", endAfter, endAfter);
			for (int i = 0; i < Difficulty_Max; i++)
			{
				attackData.Duration[i] = attackData.DamageDelay[i] + endAfter[i];
			}
		}

		GetProfileDifficultyFloatValues(kv, "attack_fov", attackData.Spread, attackData.Spread);
		GetProfileDifficultyFloatValues(kv, "attack_spread", attackData.Spread, attackData.Spread);

		GetProfileDifficultyFloatValues(kv, "attack_begin_range", attackData.BeginRange, attackData.BeginRange);

		GetProfileDifficultyFloatValues(kv, "attack_begin_fov", attackData.BeginFOV, attackData.Spread);

		GetProfileDifficultyFloatValues(kv, "attack_cooldown", attackData.Cooldown, attackData.Cooldown);

		GetProfileDifficultyBoolValues(kv, "attack_disappear_upon_damaging", attackData.Disappear, attackData.Disappear);

		if (oldStuff)
		{
			attacks.PushArray(attackData, sizeof(attackData));
			index++;
			continue;
		}

		GetProfileDifficultyBoolValues(kv, "lifesteal", attackData.LifeSteal, attackData.LifeSteal);
		GetProfileDifficultyBoolValues(kv, "attack_lifesteal", attackData.LifeSteal, attackData.LifeSteal);
		GetProfileDifficultyFloatValues(kv, "lifesteal_duration", attackData.LifeStealDuration, attackData.LifeStealDuration);
		GetProfileDifficultyFloatValues(kv, "attack_lifesteal_duration", attackData.LifeStealDuration, attackData.LifeStealDuration);

		attackData.PullIn = kv.GetNum("pull_player_in", attackData.PullIn) != 0;

		attackData.DeathCamLowHealth = kv.GetNum("deathcam_on_low_health", attackData.DeathCamLowHealth) != 0;
		attackData.DeathCamLowHealth = kv.GetNum("attack_deathcam_on_low_health", attackData.DeathCamLowHealth) != 0;

		GetProfileDifficultyNumValues(kv, "bullet_count", attackData.BulletCount, attackData.BulletCount);
		GetProfileDifficultyNumValues(kv, "attack_bullet_count", attackData.BulletCount, attackData.BulletCount);
		GetProfileDifficultyFloatValues(kv, "bullet_damage", attackData.BulletDamage, attackData.BulletDamage);
		GetProfileDifficultyFloatValues(kv, "attack_bullet_damage", attackData.BulletDamage, attackData.BulletDamage);
		GetProfileDifficultyFloatValues(kv, "bullet_spread", attackData.BulletSpread, attackData.BulletSpread);
		GetProfileDifficultyFloatValues(kv, "attack_bullet_spread", attackData.BulletSpread, attackData.BulletSpread);
		kv.GetVector("bullet_offset", attackData.BulletOffset, attackData.BulletOffset);
		kv.GetVector("attack_bullet_offset", attackData.BulletOffset, attackData.BulletOffset);
		kv.GetString("bullet_tracer", attackData.BulletTrace, sizeof(attackData.BulletTrace), attackData.BulletTrace);
		kv.GetString("attack_bullet_tracer", attackData.BulletTrace, sizeof(attackData.BulletTrace), attackData.BulletTrace);

		GetProfileDifficultyFloatValues(kv, "projectile_damage", attackData.ProjectileDamage, attackData.ProjectileDamage);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_damage", attackData.ProjectileDamage, attackData.ProjectileDamage);
		GetProfileDifficultyFloatValues(kv, "projectile_speed", attackData.ProjectileSpeed, attackData.ProjectileSpeed);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_speed", attackData.ProjectileSpeed, attackData.ProjectileSpeed);
		GetProfileDifficultyFloatValues(kv, "projectile_radius", attackData.ProjectileRadius, attackData.ProjectileRadius);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_radius", attackData.ProjectileRadius, attackData.ProjectileRadius);
		GetProfileDifficultyFloatValues(kv, "projectile_deviation", attackData.ProjectileDeviation, attackData.ProjectileDeviation);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_deviation", attackData.ProjectileDeviation, attackData.ProjectileDeviation);
		GetProfileDifficultyBoolValues(kv, "projectile_crits", attackData.CritProjectiles, attackData.CritProjectiles);
		GetProfileDifficultyBoolValues(kv, "attack_projectile_crits", attackData.CritProjectiles, attackData.CritProjectiles);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_percent", attackData.IceballSlowdownPercent, attackData.IceballSlowdownPercent);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_iceslow_percent", attackData.IceballSlowdownPercent, attackData.IceballSlowdownPercent);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_duration", attackData.IceballSlowdownDuration, attackData.IceballSlowdownDuration);
		GetProfileDifficultyFloatValues(kv, "attack_projectile_iceslow_duration", attackData.IceballSlowdownDuration, attackData.IceballSlowdownDuration);
		GetProfileDifficultyNumValues(kv, "projectile_count", attackData.ProjectileCount, attackData.ProjectileCount);
		GetProfileDifficultyNumValues(kv, "attack_projectile_count", attackData.ProjectileCount, attackData.ProjectileCount);
		attackData.ProjectileType = kv.GetNum("projectiletype", attackData.ProjectileType);
		attackData.ProjectileType = kv.GetNum("attack_projectiletype", attackData.ProjectileType);
		kv.GetVector("projectile_offset", attackData.ProjectileOffset, attackData.ProjectileOffset);
		kv.GetVector("attack_projectile_offset", attackData.ProjectileOffset, attackData.ProjectileOffset);
		kv.GetString("fire_trail", attackData.FireballTrail, sizeof(attackData.FireballTrail), attackData.FireballTrail);
		kv.GetString("fire_iceball_trail", attackData.IceballTrail, sizeof(attackData.IceballTrail), attackData.IceballTrail);
		kv.GetString("rocket_model", attackData.RocketModel, sizeof(attackData.RocketModel), attackData.RocketModel);

		if (strcmp(attackData.RocketModel, ROCKET_MODEL, true) != 0)
		{
			if (!PrecacheModel(attackData.RocketModel, true))
			{
				LogSF2Message("Attack rocket model file %s on attack name %s failed to be loaded, likely does not exist. This will crash the server if not fixed.", attackData.RocketModel, attackName);
			}
			else
			{
				PrecacheModel2(attackData.RocketModel, _, _, g_FileCheckConVar.BoolValue);
			}
		}

		GetProfileDifficultyFloatValues(kv, "explosivedance_radius", attackData.ExplosiveDanceRadius, attackData.ExplosiveDanceRadius);
		GetProfileDifficultyFloatValues(kv, "attack_explosivedance_radius", attackData.ExplosiveDanceRadius, attackData.ExplosiveDanceRadius);

		GetProfileDifficultyFloatValues(kv, "laser_damage", attackData.LaserDamage, attackData.LaserDamage);
		GetProfileDifficultyFloatValues(kv, "attack_laser_damage", attackData.LaserDamage, attackData.LaserDamage);
		attackData.LaserSize = kv.GetFloat("laser_size", attackData.LaserSize);
		attackData.LaserSize = kv.GetFloat("attack_laser_size", attackData.LaserSize);
		if (attackData.LaserSize < 0.0)
		{
			attackData.LaserSize = 0.0;
		}
		attackData.LaserColor[0] = kv.GetNum("laser_color_r", attackData.LaserColor[0]);
		attackData.LaserColor[0] = kv.GetNum("attack_laser_color_r", attackData.LaserColor[0]);
		attackData.LaserColor[1] = kv.GetNum("laser_color_g", attackData.LaserColor[1]);
		attackData.LaserColor[1] = kv.GetNum("attack_laser_color_g", attackData.LaserColor[1]);
		attackData.LaserColor[2] = kv.GetNum("laser_color_b", attackData.LaserColor[2]);
		attackData.LaserColor[2] = kv.GetNum("attack_laser_color_b", attackData.LaserColor[2]);
		attackData.LaserAttachment = kv.GetNum("laser_attachment", attackData.LaserAttachment) != 0;
		attackData.LaserAttachment = kv.GetNum("attack_laser_attachment", attackData.LaserAttachment) != 0;
		if (attackData.LaserAttachment)
		{
			kv.GetString("laser_attachment_name", attackData.LaserAttachmentName, sizeof(attackData.LaserAttachmentName), attackData.LaserAttachmentName);
			kv.GetString("attack_laser_attachment_name", attackData.LaserAttachmentName, sizeof(attackData.LaserAttachmentName), attackData.LaserAttachmentName);
		}
		else
		{
			kv.GetVector("laser_offset", attackData.LaserOffset, attackData.LaserOffset);
			kv.GetVector("attack_laser_offset", attackData.LaserOffset, attackData.LaserOffset);
		}
		GetProfileDifficultyFloatValues(kv, "laser_duration", attackData.LaserDuration, attackData.LaserDuration);
		GetProfileDifficultyFloatValues(kv, "attack_laser_duration", attackData.LaserDuration, attackData.LaserDuration);
		attackData.LaserNoise = kv.GetFloat("laser_noise", attackData.LaserNoise);
		attackData.LaserNoise = kv.GetFloat("attack_laser_noise", attackData.LaserNoise);
		GetProfileDifficultyFloatValues(kv, "laser_tick_delay", attackData.LaserTicks, attackData.LaserTicks);

		GetProfileDifficultyBoolValues(kv, "dont_interrupt_chaseinitial", attackData.DontInterruptChaseInitial, attackData.DontInterruptChaseInitial);

		attackData.Repeat = kv.GetNum("repeat", attackData.Repeat);
		attackData.Repeat = kv.GetNum("attack_repeat", attackData.Repeat);
		if (attackData.Repeat < 0)
		{
			attackData.Repeat = 0;
		}
		else if (attackData.Repeat > 2)
		{
			attackData.Repeat = 2;
		}
		attackData.MaxRepeats = kv.GetNum("max_repeats", attackData.MaxRepeats);
		attackData.MaxRepeats = kv.GetNum("attack_max_repeats", attackData.MaxRepeats);
		if (attackData.MaxRepeats < 0)
		{
			attackData.MaxRepeats = 0;
		}
		if (attackData.Repeat == 2 && attackData.MaxRepeats > 0)
		{
			attackData.RepeatTimers = new ArrayList();
			char attackBuffer[512];
			float delay;
			for (int repeats = 0; repeats < attackData.MaxRepeats; repeats++)
			{
				FormatEx(attackBuffer, sizeof(attackBuffer), "repeat_%i_delay", repeats + 1);
				delay = kv.GetFloat(attackBuffer, delay);
				FormatEx(attackBuffer, sizeof(attackBuffer), "attack_repeat_%i_delay", repeats + 1);
				delay = kv.GetFloat(attackBuffer, delay);
				attackData.RepeatTimers.Push(delay);
			}
		}

		GetProfileDifficultyBoolValues(kv, "ignore_always_looking", attackData.IgnoreAlwaysLooking, attackData.IgnoreAlwaysLooking);
		GetProfileDifficultyBoolValues(kv, "attack_ignore_always_looking", attackData.IgnoreAlwaysLooking, attackData.IgnoreAlwaysLooking);

		GetProfileDifficultyBoolValues(kv, "start_through_walls", attackData.StartThroughWalls, attackData.StartThroughWalls);
		GetProfileDifficultyBoolValues(kv, "hit_through_walls", attackData.HitThroughWalls, attackData.HitThroughWalls);

		attackData.WeaponInt = kv.GetNum("weapontypeint", attackData.WeaponInt);
		attackData.WeaponInt = kv.GetNum("attack_weapontypeint", attackData.WeaponInt);
		if (attackData.WeaponInt < 0)
		{
			attackData.WeaponInt = 0;
		}
		kv.GetString("attack_weapontype", attackData.WeaponString, sizeof(attackData.WeaponString), attackData.WeaponString);
		kv.GetString("weapontype", attackData.WeaponString, sizeof(attackData.WeaponString), attackData.WeaponString);

		GetProfileDifficultyFloatValues(kv, "run_speed", attackData.RunSpeed, attackData.RunSpeed);
		GetProfileDifficultyFloatValues(kv, "attack_run_speed", attackData.RunSpeed, attackData.RunSpeed);
		GetProfileDifficultyFloatValues(kv, "run_duration", attackData.RunDuration, attackData.RunDuration);
		GetProfileDifficultyFloatValues(kv, "attack_run_duration", attackData.RunDuration, attackData.RunDuration);
		GetProfileDifficultyFloatValues(kv, "run_delay", attackData.RunDelay, attackData.RunDelay);
		GetProfileDifficultyFloatValues(kv, "attack_run_delay", attackData.RunDelay, attackData.RunDelay);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			attackData.RunAcceleration[i] = baseData.Acceleration[i];
		}
		GetProfileDifficultyFloatValues(kv, "run_acceleration", attackData.RunAcceleration, attackData.RunAcceleration);
		GetProfileDifficultyBoolValues(kv, "run_ground_speed", attackData.RunGroundSpeed, attackData.RunGroundSpeed);

		attackData.UseOnDifficulty = kv.GetNum("use_on_difficulty", attackData.UseOnDifficulty);
		attackData.UseOnDifficulty = kv.GetNum("attack_use_on_difficulty", attackData.UseOnDifficulty);
		attackData.BlockOnDifficulty = kv.GetNum("block_on_difficulty", attackData.BlockOnDifficulty);
		attackData.BlockOnDifficulty = kv.GetNum("attack_block_on_difficulty", attackData.BlockOnDifficulty);
		attackData.UseOnHealth = kv.GetFloat("use_on_health", attackData.UseOnHealth);
		attackData.UseOnHealth = kv.GetFloat("attack_use_on_health", attackData.UseOnHealth);
		attackData.BlockOnHealth = kv.GetFloat("block_on_health", attackData.BlockOnHealth);
		attackData.BlockOnHealth = kv.GetFloat("attack_block_on_health", attackData.BlockOnHealth);

		attackData.Gestures = kv.GetNum("gestures", attackData.Gestures) != 0;
		attackData.Gestures = kv.GetNum("attack_gestures", attackData.Gestures) != 0;

		GetProfileDifficultyBoolValues(kv, "cancel_los", attackData.CancelLos, attackData.CancelLos);
		GetProfileDifficultyFloatValues(kv, "cancel_distance_max", attackData.CancelDistance, attackData.CancelDistance);
		GetProfileDifficultyFloatValues(kv, "cancel_distance_min", attackData.MinCancelDistance, attackData.MinCancelDistance);

		attackData.EventNumber = kv.GetNum("event", attackData.EventNumber);

		kv.GetString("subtype", attackData.SubType, sizeof(attackData.SubType), attackData.SubType);

		if (kv.JumpToKey("shockwave"))
		{
			attackData.Shockwave.Load(kv, g_FileCheckConVar.BoolValue);
			kv.GoBack();
		}

		if (kv.JumpToKey("effects"))
		{
			if (kv.JumpToKey("start"))
			{
				attackData.StartEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, g_FileCheckConVar.BoolValue);
						attackData.StartEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			if (kv.JumpToKey("hit"))
			{
				attackData.HitEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, g_FileCheckConVar.BoolValue);
						attackData.HitEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			if (kv.JumpToKey("miss"))
			{
				attackData.MissEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, g_FileCheckConVar.BoolValue);
						attackData.MissEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			if (kv.JumpToKey("on_kill"))
			{
				attackData.KillEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
				if (kv.GotoFirstSubKey())
				{
					do
					{
						SF2BossProfileBaseEffectInfo effect;
						effect.Init();
						effect.Load(kv, g_FileCheckConVar.BoolValue);
						attackData.KillEffects.PushArray(effect);
					}
					while (kv.GotoNextKey());

					kv.GoBack();
				}
				kv.GoBack();
			}

			kv.GoBack();
		}

		if (kv.JumpToKey("apply_conditions"))
		{
			attackData.DamageEffects = new ArrayList(sizeof(SF2ChaserBossProfileDamageEffectData));
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
					damageData.Load(kv, g_FileCheckConVar.BoolValue);
					attackData.DamageEffects.PushArray(damageData, sizeof(damageData));
				}
				while (kv.GotoNextKey());
				kv.GoBack();
			}
			kv.GoBack();
		}

		GetProfileDifficultyBoolValues(kv, "invulnerable", attackData.ImmuneToDamage, attackData.ImmuneToDamage);

		if (kv.JumpToKey("use_with_posture"))
		{
			attackData.PostureWhitelist = new ArrayList(ByteCountToCells(64));
			char key[64], posture[64];
			for (int i = 1;; i++)
			{
				FormatEx(key, sizeof(key), "%d", i);
				kv.GetString(key, posture, sizeof(posture));
				if (posture[0] == '\0')
				{
					break;
				}
				attackData.PostureWhitelist.PushString(posture);
			}
			kv.GoBack();
		}

		if (kv.JumpToKey("tongue"))
		{
			GetProfileDifficultyFloatValues(kv, "speed", attackData.TongueSpeed, attackData.TongueSpeed);
			GetProfileDifficultyFloatValues(kv, "pull_scale", attackData.TonguePullScale, attackData.TonguePullScale);
			GetProfileDifficultyBoolValues(kv, "can_escape", attackData.TongueCanEscape, attackData.TongueCanEscape);
			kv.GetString("material", attackData.TongueMaterial, sizeof(attackData.TongueMaterial), attackData.TongueMaterial);
			PrecacheMaterial2(attackData.TongueMaterial, g_FileCheckConVar.BoolValue);
			kv.GetString("attachment", attackData.TongueAttachment, sizeof(attackData.TongueAttachment), attackData.TongueAttachment);
			kv.GetVector("offset", attackData.TongueOffset, attackData.TongueOffset);

			if (kv.JumpToKey("sounds"))
			{
				if (kv.JumpToKey("launch"))
				{
					attackData.TongueLaunchSound.Load(kv, g_FileCheckConVar.BoolValue);
					kv.GoBack();
				}

				if (kv.JumpToKey("hit"))
				{
					attackData.TongueHitSound.Load(kv, g_FileCheckConVar.BoolValue);
					kv.GoBack();
				}

				if (kv.JumpToKey("tied"))
				{
					attackData.TongueTiedSound.Load(kv, g_FileCheckConVar.BoolValue);
					kv.GoBack();
				}
				kv.GoBack();
			}

			attackData.Animations.Init();
			attackData.Animations.Load(kv, false);

			kv.GoBack();
		}

		attacks.PushArray(attackData, sizeof(attackData));
		index++;
	}
	while (kv.GotoNextKey() && !oldStuff);

	if (!oldStuff)
	{
		kv.GoBack();
		kv.GoBack();
	}

	return index;
}
