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

	GetProfileDifficultyFloatValues(kv, "alert_gracetime", profileData.AlertGracetime, profileData.AlertGracetime);
	GetProfileDifficultyFloatValues(kv, "alert_duration", profileData.AlertDuration, profileData.AlertDuration);

	if (kv.JumpToKey("alert"))
	{
		GetProfileDifficultyFloatValues(kv, "gracetime", profileData.AlertGracetime, profileData.AlertGracetime);
		GetProfileDifficultyFloatValues(kv, "duration", profileData.AlertDuration, profileData.AlertDuration);
		GetProfileDifficultyBoolValues(kv, "run_on_wander", profileData.AlertRunOnWander, profileData.AlertRunOnWander);
		GetProfileDifficultyBoolValues(kv, "run_on_suspect", profileData.AlertRunOnHearSound, profileData.AlertRunOnHearSound);

		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.AlertOnAlertInfo.Radius[i] = baseData.SearchRange[i];
		}
		profileData.AlertOnAlertInfo.Load(kv);

		kv.GoBack();
	}

	if (kv.JumpToKey("chase"))
	{
		for (int i = 0; i < Difficulty_Max; i++)
		{
			profileData.AlertOnChaseInfo.Radius[i] = baseData.SearchRange[i];
		}
		profileData.AlertOnChaseInfo.Load(kv);

		kv.GoBack();
	}

	GetProfileDifficultyFloatValues(kv, "chase_duration", profileData.ChaseDuration, profileData.ChaseDuration);
	for (int i = 0; i < Difficulty_Max; i++)
	{
		profileData.ChaseDurationAddMaxRange[i] = baseData.SearchRange[i];
	}
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_max_range", profileData.ChaseDurationAddMaxRange, profileData.ChaseDurationAddMaxRange);
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_min", profileData.ChaseDurationAddVisibleMin, profileData.ChaseDurationAddVisibleMin);
	GetProfileDifficultyFloatValues(kv, "chase_duration_add_visible_max", profileData.ChaseDurationAddVisibleMax, profileData.ChaseDurationAddVisibleMax);

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

	profileData.StunEnabled = kv.GetNum("stun_enabled", profileData.StunEnabled) != 0;
	if (profileData.StunEnabled)
	{
		GetProfileDifficultyFloatValues(kv, "stun_cooldown", profileData.StunCooldown, profileData.StunCooldown);
		GetProfileDifficultyFloatValues(kv, "stun_health", profileData.StunHealth, profileData.StunHealth);
		profileData.StunHealthPerPlayer = kv.GetFloat("stun_health_per_player", profileData.StunHealthPerPlayer);
		if (profileData.StunHealthPerPlayer < 0.0)
		{
			profileData.StunHealthPerPlayer = 0.0;
		}
		profileData.StunHealthPerClass[1] = kv.GetFloat("stun_health_per_scout", profileData.StunHealthPerClass[1]);
		profileData.StunHealthPerClass[2] = kv.GetFloat("stun_health_per_sniper", profileData.StunHealthPerClass[2]);
		profileData.StunHealthPerClass[3] = kv.GetFloat("stun_health_per_soldier", profileData.StunHealthPerClass[3]);
		profileData.StunHealthPerClass[4] = kv.GetFloat("stun_health_per_demoman", profileData.StunHealthPerClass[4]);
		profileData.StunHealthPerClass[5] = kv.GetFloat("stun_health_per_medic", profileData.StunHealthPerClass[5]);
		profileData.StunHealthPerClass[6] = kv.GetFloat("stun_health_per_heavyweapons", profileData.StunHealthPerClass[6]);
		profileData.StunHealthPerClass[7] = kv.GetFloat("stun_health_per_pyro", profileData.StunHealthPerClass[7]);
		profileData.StunHealthPerClass[8] = kv.GetFloat("stun_health_per_spy", profileData.StunHealthPerClass[8]);
		profileData.StunHealthPerClass[9] = kv.GetFloat("stun_health_per_engineer", profileData.StunHealthPerClass[9]);
		GetProfileDifficultyBoolValues(kv, "stun_damage_flashlight_enabled", profileData.FlashlightStun, profileData.FlashlightStun);
		GetProfileDifficultyFloatValues(kv, "stun_damage_flashlight", profileData.FlashlightDamage, profileData.FlashlightDamage);
		profileData.ChaseInitialOnStun = kv.GetNum("chase_initial_on_stun", profileData.ChaseInitialOnStun) != 0;

		GetProfileDifficultyBoolValues(kv, "drop_item_on_stun", profileData.ItemDropOnStun);
		GetProfileDifficultyNumValues(kv, "drop_item_type", profileData.StunItemDropType, profileData.StunItemDropType);

		profileData.DisappearOnStun = kv.GetNum("disappear_on_stun", profileData.DisappearOnStun) != 0;

		if (kv.JumpToKey("resistances"))
		{
			profileData.DamageResistances = new ArrayList();
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
				profileData.DamageResistances.Push(resistance);
			}
			kv.GoBack();
		}

		profileData.KeyDrop = kv.GetNum("keydrop_enabled", profileData.KeyDrop) != 0;
		if (profileData.KeyDrop)
		{
			kv.GetString("key_model", profileData.KeyModel, sizeof(profileData.KeyModel), profileData.KeyModel);
			PrecacheModel2(profileData.KeyModel, _, _, g_FileCheckConVar.BoolValue);
			kv.GetString("key_trigger", profileData.KeyTrigger, sizeof(profileData.KeyTrigger), profileData.KeyTrigger);
		}
	}

	if (kv.JumpToKey("death"))
	{
		profileData.DeathData.Load(kv, g_FileCheckConVar.BoolValue);
		kv.GoBack();
	}

	if (kv.JumpToKey("cloaking"))
	{
		profileData.CloakData.Load(kv, g_FileCheckConVar.BoolValue);
		kv.GoBack();
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

		profileData.ProjectileClips = !!kv.GetNum("projectile_clips_enable", profileData.ProjectileClips);
		if (profileData.ProjectileClips)
		{
			GetProfileDifficultyNumValues(kv, "projectile_ammo_loaded", profileData.ProjectileClipSize, profileData.ProjectileClipSize);
			GetProfileDifficultyFloatValues(kv, "projectile_reload_time", profileData.ProjectileReloadTime, profileData.ProjectileReloadTime);
		}

		profileData.ChargeUpProjectiles = !!kv.GetNum("projectile_chargeup_enable", profileData.ChargeUpProjectiles);
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

	profileData.ShootAnimations = !!kv.GetNum("use_shoot_animations", profileData.ShootAnimations);

	profileData.XenobladeCombo = !!kv.GetNum("xenoblade_chain_art_combo", profileData.XenobladeCombo);
	if (profileData.XenobladeCombo)
	{
		profileData.XenobladeDuration = kv.GetFloat("xenoblade_break_duration", profileData.XenobladeDuration);
		profileData.XenobladeToppleDuration = kv.GetFloat("xenoblade_topple_duration", profileData.XenobladeToppleDuration);
		profileData.XenobladeToppleSlowdown = kv.GetFloat("xenoblade_topple_slowdown", profileData.XenobladeToppleSlowdown);
		profileData.XenobladeDazeDuration = kv.GetFloat("xenoblade_daze_duration", profileData.XenobladeDazeDuration);
	}

	profileData.EarthquakeFootsteps = !!kv.GetNum("earthquake_footsteps", profileData.EarthquakeFootsteps);
	if (profileData.EarthquakeFootsteps)
	{
		profileData.EarthquakeFootstepAmplitude = kv.GetFloat("earthquake_footsteps_amplitude", profileData.EarthquakeFootstepAmplitude);
		profileData.EarthquakeFootstepFrequency = kv.GetFloat("earthquake_footsteps_frequency", profileData.EarthquakeFootstepFrequency);
		profileData.EarthquakeFootstepDuration = kv.GetFloat("earthquake_footsteps_duration", profileData.EarthquakeFootstepDuration);
		profileData.EarthquakeFootstepRadius = kv.GetFloat("earthquake_footsteps_radius", profileData.EarthquakeFootstepRadius);
		profileData.EarthquakeFootstepAirShake = !!kv.GetNum("earthquake_footsteps_airshake", profileData.EarthquakeFootstepAirShake);
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

	profileData.ChasesEndlessly = !!KvGetNum(kv, "boss_chases_endlessly", profileData.ChasesEndlessly);

	if (kv.JumpToKey("chase_on_look"))
	{
		profileData.ChaseOnLookData.Load(kv);
		kv.GoBack();
	}

	profileData.BoxingBoss = kv.GetNum("boxing_boss", profileData.BoxingBoss) != 0;

	profileData.NormalSoundHook = kv.GetNum("normal_sound_hook", profileData.NormalSoundHook) != 0;

	profileData.OldAnimationAI = !!kv.GetNum("old_animation_ai", profileData.OldAnimationAI);

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
	}

	// We have to copy and paste here, the previous kv.GotoFirstSubKey() in profile_boss_functions.sp will somehow reset all values of these sound sections
	if (kv.GotoFirstSubKey())
	{
		char s2[64];

		do
		{
			kv.GetSectionName(s2, sizeof(s2));

			if (!StrContains(s2, "sound_"))
			{
				profileData.SortSoundSections(kv, s2, g_FileCheckConVar.BoolValue);
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	if (attackNums > 0)
	{
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_Attack]))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.AttackSounds, profileData.NormalSoundHook);
		}
		if (kv.JumpToKey("sound_hitenemy"))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.HitSounds, false);
		}
		if (kv.JumpToKey("sound_missenemy"))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.MissSounds, false);
		}
		if (kv.JumpToKey("sound_bulletshoot"))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.BulletShootSounds, false);
		}
		if (kv.JumpToKey("sound_attackshootprojectile"))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.ProjectileShootSounds, false);
		}
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_AttackBegin]))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.AttackBeginSounds, profileData.NormalSoundHook);
		}
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_AttackEnd]))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.AttackEndSounds, profileData.NormalSoundHook);
		}
		if (kv.JumpToKey("sound_attack_loop"))
		{
			profileData.LoadNestedSoundSections(kv, g_FileCheckConVar.BoolValue, profileData.AttackLoopSounds, false);
		}
	}

	if (kv.JumpToKey("postures"))
	{
		profileData.Postures = new StringMap();
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

	profileData.PostLoad();

	g_ChaserBossProfileData.SetArray(profile, profileData, sizeof(profileData));

	return true;
}

static int ParseChaserProfileAttacks(KeyValues kv, SF2ChaserBossProfileData chaserProfileData, SF2BossProfileData baseData)
{
	// Create the array.
	ArrayList attacks = chaserProfileData.Attacks;

	if (!kv.JumpToKey("attacks"))
	{
		return -1;
	}

	if (!kv.GotoFirstSubKey())
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

		attackData.Type = kv.GetNum("type", attackData.Type);

		GetProfileDifficultyFloatValues(kv, "range", attackData.Range, attackData.Range);

		GetProfileDifficultyFloatValues(kv, "damage", attackData.Damage, attackData.Damage);

		attackData.DamageVsProps = kv.GetFloat("damage_vs_props", attackData.DamageVsProps);
		GetProfileDifficultyFloatValues(kv, "damageforce", attackData.DamageForce, attackData.DamageForce);

		GetProfileDifficultyNumValues(kv, "damagetype", attackData.DamageType, attackData.DamageType);

		attackData.CanUseAgainstProps = !!kv.GetNum("props", attackData.CanUseAgainstProps);

		kv.GetVector("punchvel", attackData.PunchVelocity, attackData.PunchVelocity);

		GetProfileDifficultyBoolValues(kv, "lifesteal", attackData.LifeSteal, attackData.LifeSteal);
		GetProfileDifficultyFloatValues(kv, "lifesteal_duration", attackData.LifeStealDuration, attackData.LifeStealDuration);

		attackData.PullIn = !!kv.GetNum("pull_player_in", attackData.PullIn);

		attackData.DeathCamLowHealth = !!kv.GetNum("deathcam_on_low_health", attackData.DeathCamLowHealth);

		GetProfileDifficultyNumValues(kv, "bullet_count", attackData.BulletCount, attackData.BulletCount);
		GetProfileDifficultyFloatValues(kv, "bullet_damage", attackData.BulletDamage, attackData.BulletDamage);
		GetProfileDifficultyFloatValues(kv, "bullet_spread", attackData.BulletSpread, attackData.BulletSpread);
		kv.GetVector("bullet_offset", attackData.BulletOffset, attackData.BulletOffset);
		kv.GetString("bullet_tracer", attackData.BulletTrace, sizeof(attackData.BulletTrace), attackData.BulletTrace);

		GetProfileDifficultyFloatValues(kv, "projectile_damage", attackData.ProjectileDamage, attackData.ProjectileDamage);
		GetProfileDifficultyFloatValues(kv, "projectile_speed", attackData.ProjectileSpeed, attackData.ProjectileSpeed);
		GetProfileDifficultyFloatValues(kv, "projectile_radius", attackData.ProjectileRadius, attackData.ProjectileRadius);
		GetProfileDifficultyFloatValues(kv, "projectile_deviation", attackData.ProjectileDeviation, attackData.ProjectileDeviation);
		GetProfileDifficultyBoolValues(kv, "projectile_crits", attackData.CritProjectiles, attackData.CritProjectiles);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_percent", attackData.IceballSlowdownPercent, attackData.IceballSlowdownPercent);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_duration", attackData.IceballSlowdownDuration, attackData.IceballSlowdownDuration);
		GetProfileDifficultyNumValues(kv, "projectile_count", attackData.ProjectileCount, attackData.ProjectileCount);
		attackData.ProjectileType = kv.GetNum("projectiletype", attackData.ProjectileType);
		kv.GetVector("projectile_offset", attackData.ProjectileOffset, attackData.ProjectileOffset);
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

		GetProfileDifficultyFloatValues(kv, "laser_damage", attackData.LaserDamage, attackData.LaserDamage);
		attackData.LaserSize = kv.GetFloat("laser_size", attackData.LaserSize);
		if (attackData.LaserSize < 0.0)
		{
			attackData.LaserSize = 0.0;
		}
		attackData.LaserColor[0] = kv.GetNum("laser_color_r", attackData.LaserColor[0]);
		attackData.LaserColor[1] = kv.GetNum("laser_color_g", attackData.LaserColor[1]);
		attackData.LaserColor[2] = kv.GetNum("laser_color_b", attackData.LaserColor[2]);
		attackData.LaserAttachment = !!kv.GetNum("laser_attachment", attackData.LaserAttachment);
		if (attackData.LaserAttachment)
		{
			kv.GetString("laser_attachment_name", attackData.LaserAttachmentName, sizeof(attackData.LaserAttachmentName), attackData.LaserAttachmentName);
		}
		else
		{
			kv.GetVector("laser_offset", attackData.LaserOffset, attackData.LaserOffset);
		}
		GetProfileDifficultyFloatValues(kv, "laser_duration", attackData.LaserDuration, attackData.LaserDuration);
		attackData.LaserNoise = kv.GetFloat("laser_noise", attackData.LaserNoise);
		GetProfileDifficultyFloatValues(kv, "laser_tick_delay", attackData.LaserTicks, attackData.LaserTicks);

		GetProfileDifficultyBoolValues(kv, "dont_interrupt_chaseinitial", attackData.DontInterruptChaseInitial, attackData.DontInterruptChaseInitial);

		GetProfileDifficultyFloatValues(kv, "delay", attackData.DamageDelay, attackData.DamageDelay);

		GetProfileDifficultyFloatValues(kv, "duration", attackData.Duration, attackData.Duration);
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
			GetProfileDifficultyFloatValues(kv, "endafter", endAfter, endAfter);
			for (int i = 0; i < Difficulty_Max; i++)
			{
				attackData.Duration[i] = attackData.DamageDelay[i] + endAfter[i];
			}
		}

		GetProfileDifficultyFloatValues(kv, "fov", attackData.Spread, attackData.Spread);
		GetProfileDifficultyFloatValues(kv, "spread", attackData.Spread, attackData.Spread);

		GetProfileDifficultyFloatValues(kv, "begin_range", attackData.BeginRange, attackData.Range);

		GetProfileDifficultyFloatValues(kv, "begin_fov", attackData.BeginFOV, attackData.Spread);

		GetProfileDifficultyFloatValues(kv, "cooldown", attackData.Cooldown, attackData.Cooldown);

		attackData.Repeat = kv.GetNum("repeat", attackData.Repeat);
		if (attackData.Repeat < 0)
		{
			attackData.Repeat = 0;
		}
		else if (attackData.Repeat > 2)
		{
			attackData.Repeat = 2;
		}
		attackData.MaxRepeats = kv.GetNum("max_repeats", attackData.MaxRepeats);
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
				attackData.RepeatTimers.Push(delay);
			}
		}

		GetProfileDifficultyBoolValues(kv, "ignore_always_looking", attackData.IgnoreAlwaysLooking, attackData.IgnoreAlwaysLooking);
		GetProfileDifficultyBoolValues(kv, "disappear_upon_damaging", attackData.Disappear, attackData.Disappear);

		GetProfileDifficultyBoolValues(kv, "start_through_walls", attackData.StartThroughWalls, attackData.StartThroughWalls);
		GetProfileDifficultyBoolValues(kv, "hit_through_walls", attackData.HitThroughWalls, attackData.HitThroughWalls);

		attackData.WeaponInt = kv.GetNum("weapontypeint", attackData.WeaponInt);
		if (attackData.WeaponInt < 0)
		{
			attackData.WeaponInt = 0;
		}
		kv.GetString("weapontype", attackData.WeaponString, sizeof(attackData.WeaponString), attackData.WeaponString);

		GetProfileDifficultyFloatValues(kv, "run_speed", attackData.RunSpeed, attackData.RunSpeed);
		GetProfileDifficultyFloatValues(kv, "run_duration", attackData.RunDuration, attackData.RunDuration);
		GetProfileDifficultyFloatValues(kv, "run_delay", attackData.RunDelay, attackData.RunDelay);
		for (int i = 0; i < Difficulty_Max; i++)
		{
			attackData.RunAcceleration[i] = baseData.Acceleration[i];
		}
		GetProfileDifficultyFloatValues(kv, "run_acceleration", attackData.RunAcceleration, attackData.RunAcceleration);
		GetProfileDifficultyBoolValues(kv, "run_ground_speed", attackData.RunGroundSpeed, attackData.RunGroundSpeed);

		attackData.UseOnDifficulty = kv.GetNum("use_on_difficulty", attackData.UseOnDifficulty);
		attackData.BlockOnDifficulty = kv.GetNum("block_on_difficulty", attackData.BlockOnDifficulty);
		attackData.UseOnHealth = kv.GetFloat("use_on_health", attackData.UseOnHealth);
		attackData.BlockOnHealth = kv.GetFloat("block_on_health", attackData.BlockOnHealth);

		attackData.Gestures = kv.GetNum("gestures", attackData.Gestures) != 0;

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
			attackData.Animations.Load(kv);

			kv.GoBack();
		}

		attacks.PushArray(attackData, sizeof(attackData));
		index++;
	}
	while (kv.GotoNextKey());

	kv.GoBack();
	kv.GoBack();

	return index;
}
