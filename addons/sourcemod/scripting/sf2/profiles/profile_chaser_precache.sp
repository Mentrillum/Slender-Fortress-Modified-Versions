#if defined _sf2_profiles_chaser_precache
 #endinput
#endif

#define _sf2_profiles_chaser_precache

#pragma semicolon 1

/**
 *	Parses and stores the unique values of a chaser profile from the current position in the profiles config.
 *	Returns true if loading was successful, false if not.
 */
public bool LoadChaserBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen)
{
	strcopy(loadFailReasonBuffer, loadFailReasonBufferLen, "");

	SF2ChaserBossProfileData profileData;
	profileData.Init();

	SF2BossProfileData g_CachedProfileData;
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));

	profileData.UnnerfedVisibility = view_as<bool>(kv.GetNum("old_boss_visibility", profileData.UnnerfedVisibility));

	profileData.ClearLayersOnAnimUpdate = view_as<bool>(kv.GetNum("animation_clear_layers_on_update", profileData.ClearLayersOnAnimUpdate));

	GetProfileDifficultyFloatValues(kv, "walkspeed", profileData.WalkSpeed, profileData.WalkSpeed);
	GetProfileDifficultyFloatValues(kv, "walkspeed_max", profileData.MaxWalkSpeed, profileData.MaxWalkSpeed);

	profileData.WakeRadius = kv.GetFloat("wake_radius", profileData.WakeRadius);
	if (profileData.WakeRadius < 0.0)
	{
		profileData.WakeRadius = 0.0;
	}

	GetProfileDifficultyFloatValues(kv, "search_alert_gracetime", profileData.AlertGracetime, profileData.AlertGracetime);
	GetProfileDifficultyFloatValues(kv, "search_alert_duration", profileData.AlertDuration, profileData.AlertDuration);
	GetProfileDifficultyFloatValues(kv, "search_chase_duration", profileData.ChaseDuration, profileData.ChaseDuration);
	profileData.ChaseDurationAddVisibleMin = kv.GetFloat("search_chase_duration_add_visible_min", profileData.ChaseDurationAddVisibleMin);
	profileData.ChaseDurationAddVisibleMax = kv.GetFloat("search_chase_duration_add_visible_max", profileData.ChaseDurationAddVisibleMax);

	profileData.SoundPosDiscardTime = kv.GetFloat("search_sound_pos_discard_time", profileData.SoundPosDiscardTime);
	profileData.SoundPosDistanceTolerance = kv.GetFloat("search_sound_pos_dist_tolerance", profileData.SoundPosDistanceTolerance);
	profileData.ChasePersistencyTimeInit = kv.GetFloat("search_chase_persistency_time_init", profileData.ChasePersistencyTimeInit);
	profileData.ChaseAttackPersistencyTimeInit = kv.GetFloat("search_chase_persistency_time_init_attack", profileData.ChaseAttackPersistencyTimeInit);
	profileData.ChaseAttackPersistencyTimeAdd = kv.GetFloat("search_chase_persistency_time_add_attack", profileData.ChaseAttackPersistencyTimeAdd);
	profileData.ChaseNewTargetPersistencyTimeInit = kv.GetFloat("search_chase_persistency_time_init_newtarget", profileData.ChaseNewTargetPersistencyTimeInit);
	profileData.ChaseNewTargetPersistencyTimeAdd = kv.GetFloat("search_chase_persistency_time_add_newtarget", profileData.ChaseNewTargetPersistencyTimeAdd);
	profileData.ChasePersistencyAddVisibleMin = kv.GetFloat("search_chase_persistency_time_add_visible_min", profileData.ChasePersistencyAddVisibleMin);
	profileData.ChaseStunPersistencyTimeInit = kv.GetFloat("search_chase_persistency_time_init_stun", profileData.ChaseStunPersistencyTimeInit);
	profileData.ChaseStunPersistencyTimeAdd = kv.GetFloat("search_chase_persistency_time_add_stun", profileData.ChaseStunPersistencyTimeAdd);

	GetProfileDifficultyFloatValues(kv, "search_wander_range_min", profileData.WanderRangeMin, profileData.WanderRangeMin);
	GetProfileDifficultyFloatValues(kv, "search_wander_range_max", profileData.WanderRangeMax, profileData.WanderRangeMax);
	GetProfileDifficultyFloatValues(kv, "search_wander_time_min", profileData.WanderTimeMin, profileData.WanderTimeMin);
	GetProfileDifficultyFloatValues(kv, "search_wander_time_max", profileData.WanderTimeMax, profileData.WanderTimeMax);

	profileData.StunEnabled = view_as<bool>(kv.GetNum("stun_enabled", profileData.StunEnabled));
	if (profileData.StunEnabled)
	{
		profileData.StunCooldown = kv.GetFloat("stun_cooldown", profileData.StunCooldown);
		if (profileData.StunCooldown < 0.0)
		{
			profileData.StunCooldown = 0.0;
		}
		profileData.StunHealth = kv.GetFloat("stun_health", profileData.StunHealth);
		if (profileData.StunHealth < 0.0)
		{
			profileData.StunHealth = 0.0;
		}
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
		profileData.FlashlightStun = view_as<bool>(kv.GetNum("stun_damage_flashlight_enabled", profileData.FlashlightStun));
		profileData.FlashlightDamage = kv.GetFloat("stun_damage_flashlight", profileData.FlashlightDamage);
		profileData.ChaseInitialOnStun = view_as<bool>(kv.GetNum("chase_initial_on_stun", profileData.ChaseInitialOnStun));

		profileData.ItemDropOnStun = view_as<bool>(kv.GetNum("drop_item_on_stun", profileData.ItemDropOnStun));
		if (profileData.ItemDropOnStun)
		{
			profileData.StunItemDropType = kv.GetNum("drop_item_type", profileData.StunItemDropType);
			if (profileData.StunItemDropType < 1)
			{
				profileData.StunItemDropType = 1;
			}
			if (profileData.StunItemDropType > 7)
			{
				profileData.StunItemDropType = 7;
			}
		}

		profileData.DisappearOnStun = view_as<bool>(kv.GetNum("disappear_on_stun", profileData.DisappearOnStun));

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
	}

	profileData.KeyDrop = view_as<bool>(kv.GetNum("keydrop_enabled", profileData.KeyDrop));
	if (profileData.KeyDrop)
	{
		kv.GetString("key_model", profileData.KeyModel, sizeof(profileData.KeyModel), profileData.KeyModel);
		kv.GetString("key_trigger", profileData.KeyTrigger, sizeof(profileData.KeyTrigger), profileData.KeyTrigger);
	}

	profileData.CanCloak = view_as<bool>(kv.GetNum("cloak_enable", profileData.CanCloak));
	if (profileData.CanCloak)
	{
		GetProfileDifficultyFloatValues(kv, "cloak_cooldown", profileData.CloakCooldown, profileData.CloakCooldown);
		GetProfileDifficultyFloatValues(kv, "cloak_range", profileData.CloakRange, profileData.CloakRange);
		GetProfileDifficultyFloatValues(kv, "cloak_decloak_range", profileData.DecloakRange, profileData.DecloakRange);
		GetProfileDifficultyFloatValues(kv, "cloak_duration", profileData.CloakDuration, profileData.CloakDuration);
		GetProfileDifficultyFloatValues(kv, "cloak_speed_multiplier", profileData.CloakSpeedMultiplier, profileData.CloakSpeedMultiplier);
		kv.GetString("cloak_particle", profileData.CloakParticle, sizeof(profileData.CloakParticle), profileData.CloakParticle);

		GetProfileColorNoBacks(kv, "cloak_rendercolor", profileData.CloakRenderColor[0], profileData.CloakRenderColor[1], profileData.CloakRenderColor[2], profileData.CloakRenderColor[3],
								g_CachedProfileData.RenderColor[0], g_CachedProfileData.RenderColor[1], g_CachedProfileData.RenderColor[2], profileData.CloakRenderColor[3]);
		profileData.CloakRenderMode = kv.GetNum("cloak_rendermode", profileData.CloakRenderMode);
	}
	profileData.ShootAnimations = view_as<bool>(kv.GetNum("use_shoot_animations", profileData.ShootAnimations));
	profileData.ProjectilesEnabled = view_as<bool>(kv.GetNum("projectile_enable", profileData.ProjectilesEnabled));
	if (profileData.ProjectilesEnabled)
	{
		GetProfileDifficultyFloatValues(kv, "projectile_cooldown_min", profileData.ProjectileCooldownMin, profileData.ProjectileCooldownMin);
		GetProfileDifficultyFloatValues(kv, "projectile_cooldown_max", profileData.ProjectileCooldownMax, profileData.ProjectileCooldownMax);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_duration", profileData.IceballSlowDuration, profileData.IceballSlowDuration);
		GetProfileDifficultyFloatValues(kv, "projectile_iceslow_percent", profileData.IceballSlowPercent, profileData.IceballSlowPercent);
		GetProfileDifficultyFloatValues(kv, "projectile_speed", profileData.ProjectileSpeed, profileData.ProjectileSpeed);
		GetProfileDifficultyFloatValues(kv, "projectile_damage", profileData.ProjectileDamage, profileData.ProjectileDamage);
		GetProfileDifficultyFloatValues(kv, "projectile_damageradius", profileData.ProjectileRadius, profileData.ProjectileRadius);
		GetProfileDifficultyFloatValues(kv, "projectile_deviation", profileData.ProjectileDeviation, profileData.ProjectileDeviation);
		GetProfileDifficultyNumValues(kv, "projectile_count", profileData.ProjectileCount, profileData.ProjectileCount);
		profileData.CriticalProjectiles = view_as<bool>(kv.GetNum("enable_crit_rockets", profileData.CriticalProjectiles));
		profileData.ShootGestures = view_as<bool>(kv.GetNum("use_gesture_shoot", profileData.ShootGestures));
		if (profileData.ShootGestures)
		{
			kv.GetString("gesture_shootprojectile", profileData.ShootGestureName, sizeof(profileData.ShootGestureName), profileData.ShootGestureName);
		}

		profileData.ProjectileClips = view_as<bool>(kv.GetNum("projectile_clips_enable", profileData.ProjectileClips));
		if (profileData.ProjectileClips)
		{
			GetProfileDifficultyNumValues(kv, "projectile_ammo_loaded", profileData.ProjectileClipSize, profileData.ProjectileClipSize);
			GetProfileDifficultyFloatValues(kv, "projectile_reload_time", profileData.ProjectileReloadTime, profileData.ProjectileReloadTime);
		}

		profileData.ChargeUpProjectiles = view_as<bool>(kv.GetNum("projectile_chargeup_enable", profileData.ChargeUpProjectiles));
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
		if (profileData.ProjectileType == SF2BossProjectileType_Baseball)
		{
			kv.GetString("baseball_model", profileData.BaseballModel, sizeof(profileData.BaseballModel), profileData.BaseballModel);
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
				position = view_as<float>( { 0.0, 0.0, 0.0 });
				FormatEx(keyName, sizeof(keyName), "projectile_pos_offset_%i", i);
				kv.GetVector(keyName, position, position);
				profileData.ProjectilePosOffsets.PushArray(position);
			}
		}
	}

	profileData.AdvancedDamageEffects = view_as<bool>(kv.GetNum("player_damage_effects", profileData.AdvancedDamageEffects));
	if (profileData.AdvancedDamageEffects)
	{
		profileData.AdvancedDamageEffectParticles = view_as<bool>(kv.GetNum("player_attach_particle", profileData.AdvancedDamageEffectParticles));

		profileData.RandomAdvancedDamageEffects = view_as<bool>(kv.GetNum("player_damage_random_effects", profileData.RandomAdvancedDamageEffects));
		if (profileData.RandomAdvancedDamageEffects)
		{
			profileData.RandomEffectIndexes = kv.GetNum("player_random_attack_indexes", profileData.RandomEffectIndexes);
			if (profileData.RandomEffectIndexes < 0)
			{
				profileData.RandomEffectIndexes = 1;
			}
			kv.GetString("player_random_attack_indexes", profileData.RandomEffectIndexesString, sizeof(profileData.RandomEffectIndexesString), profileData.RandomEffectIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_random_duration", profileData.RandomEffectDuration, profileData.RandomEffectDuration);
			GetProfileDifficultyFloatValues(kv, "player_random_slowdown", profileData.RandomEffectSlowdown, profileData.RandomEffectSlowdown);
			profileData.RandomEffectStunType = kv.GetNum("player_random_stun_type", profileData.RandomEffectStunType);
			if (profileData.RandomEffectStunType < 0)
			{
				profileData.RandomEffectStunType = 0;
			}
			if (profileData.RandomEffectStunType > 3)
			{
				profileData.RandomEffectStunType = 3;
			}
		}

		profileData.JarateEffects = view_as<bool>(kv.GetNum("player_jarate_on_hit", profileData.JarateEffects));
		if (profileData.JarateEffects)
		{
			profileData.JarateIndexes = kv.GetNum("player_jarate_attack_indexs", profileData.JarateIndexes);
			if (profileData.JarateIndexes < 0)
			{
				profileData.JarateIndexes = 1;
			}
			kv.GetString("player_jarate_attack_indexs", profileData.JarateIndexesString, sizeof(profileData.JarateIndexesString), profileData.JarateIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_jarate_duration", profileData.JarateDuration, profileData.JarateDuration);
			profileData.JarateBeamParticle = view_as<bool>(kv.GetNum("player_jarate_beam_particle", profileData.JarateBeamParticle));
			kv.GetString("player_jarate_particle", profileData.JarateParticle, sizeof(profileData.JarateParticle), profileData.JarateParticle);
		}

		profileData.MilkEffects = view_as<bool>(kv.GetNum("player_milk_on_hit", profileData.MilkEffects));
		if (profileData.MilkEffects)
		{
			profileData.MilkIndexes = kv.GetNum("player_milk_attack_indexs", profileData.MilkIndexes);
			if (profileData.MilkIndexes < 0)
			{
				profileData.MilkIndexes = 1;
			}
			kv.GetString("player_milk_attack_indexs", profileData.MilkIndexesString, sizeof(profileData.MilkIndexesString), profileData.MilkIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_milk_duration", profileData.MilkDuration, profileData.MilkDuration);
			profileData.MilkBeamParaticle = view_as<bool>(kv.GetNum("player_milk_beam_particle", profileData.MilkBeamParaticle));
			kv.GetString("player_milk_particle", profileData.MilkParticle, sizeof(profileData.MilkParticle), profileData.MilkParticle);
		}

		profileData.GasEffects = view_as<bool>(kv.GetNum("player_gas_on_hit", profileData.GasEffects));
		if (profileData.GasEffects)
		{
			profileData.GasIndexes = kv.GetNum("player_gas_attack_indexs", profileData.GasIndexes);
			if (profileData.GasIndexes < 0)
			{
				profileData.GasIndexes = 1;
			}
			kv.GetString("player_gas_attack_indexs", profileData.GasIndexesString, sizeof(profileData.GasIndexesString), profileData.GasIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_gas_duration", profileData.GasDuration, profileData.GasDuration);
			profileData.GasBeamParticle = view_as<bool>(kv.GetNum("player_gas_beam_particle", profileData.GasBeamParticle));
			kv.GetString("player_gas_particle", profileData.GasParticle, sizeof(profileData.GasParticle), profileData.GasParticle);
		}

		profileData.MarkEffects = view_as<bool>(kv.GetNum("player_mark_on_hit", profileData.MarkEffects));
		if (profileData.MarkEffects)
		{
			profileData.MarkIndexes = kv.GetNum("player_mark_attack_indexs", profileData.MarkIndexes);
			if (profileData.MarkIndexes < 0)
			{
				profileData.MarkIndexes = 1;
			}
			kv.GetString("player_mark_attack_indexs", profileData.MarkIndexesString, sizeof(profileData.MarkIndexesString), profileData.MarkIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_mark_duration", profileData.MarkDuration, profileData.MarkDuration);
		}

		profileData.SilentMarkEffects = view_as<bool>(kv.GetNum("player_silent_mark_on_hit", profileData.SilentMarkEffects));
		if (profileData.SilentMarkEffects)
		{
			profileData.SilentMarkIndexes = kv.GetNum("player_silent_mark_attack_indexs", profileData.SilentMarkIndexes);
			if (profileData.SilentMarkIndexes < 0)
			{
				profileData.SilentMarkIndexes = 1;
			}
			kv.GetString("player_silent_mark_attack_indexs", profileData.SilentMarkIndexesString, sizeof(profileData.SilentMarkIndexesString), profileData.SilentMarkIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_silent_mark_duration", profileData.SilentMarkDuration, profileData.SilentMarkDuration);
		}

		profileData.IgniteEffects = view_as<bool>(kv.GetNum("player_ignite_on_hit", profileData.IgniteEffects));
		if (profileData.IgniteEffects)
		{
			profileData.IgniteIndexes = kv.GetNum("player_ignite_attack_indexs", profileData.IgniteIndexes);
			if (profileData.IgniteIndexes < 0)
			{
				profileData.IgniteIndexes = 1;
			}
			kv.GetString("player_ignite_attack_indexs", profileData.IgniteIndexesString, sizeof(profileData.IgniteIndexesString), profileData.IgniteIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_ignite_delay", profileData.IgniteDelay, profileData.IgniteDelay);
		}

		profileData.StunEffects = view_as<bool>(kv.GetNum("player_stun_on_hit", profileData.StunEffects));
		if (profileData.StunEffects)
		{
			profileData.StunEffectType = kv.GetNum("player_stun_type", profileData.StunEffectType);
			if (profileData.StunEffectType < 0)
			{
				profileData.StunEffectType = 0;
			}
			if (profileData.StunEffectType > 3)
			{
				profileData.StunEffectType = 3;
			}
			profileData.StunEffectIndexes = kv.GetNum("player_stun_attack_indexs", profileData.StunEffectIndexes);
			if (profileData.StunEffectIndexes < 0)
			{
				profileData.StunEffectIndexes = 1;
			}
			kv.GetString("player_stun_attack_indexs", profileData.StunEffectIndexesString, sizeof(profileData.StunEffectIndexesString), profileData.StunEffectIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_stun_duration", profileData.StunEffectDuration, profileData.StunEffectDuration);
			GetProfileDifficultyFloatValues(kv, "player_stun_slowdown", profileData.StunEffectSlowdown, profileData.StunEffectSlowdown);
			profileData.StunEffectBeamParticle = view_as<bool>(kv.GetNum("player_stun_beam_particle", profileData.StunEffectBeamParticle));
			kv.GetString("player_stun_particle", profileData.StunParticle, sizeof(profileData.StunParticle), profileData.StunParticle);
		}

		profileData.BleedEffects = view_as<bool>(kv.GetNum("player_bleed_on_hit", profileData.BleedEffects));
		if (profileData.BleedEffects)
		{
			profileData.BleedIndexes = kv.GetNum("player_bleed_attack_indexs", profileData.BleedIndexes);
			if (profileData.BleedIndexes < 0)
			{
				profileData.BleedIndexes = 1;
			}
			kv.GetString("player_bleed_attack_indexs", profileData.BleedIndexesString, sizeof(profileData.BleedIndexesString), profileData.BleedIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_bleed_duration", profileData.BleedDuration, profileData.BleedDuration);
		}

		profileData.ElectricEffects = view_as<bool>(kv.GetNum("player_electric_slow_on_hit", profileData.ElectricEffects));
		if (profileData.ElectricEffects)
		{
			profileData.ElectricIndexes = kv.GetNum("player_electrocute_attack_indexs", profileData.ElectricIndexes);
			if (profileData.ElectricIndexes < 0)
			{
				profileData.ElectricIndexes = 1;
			}
			kv.GetString("player_electrocute_attack_indexs", profileData.ElectricIndexesString, sizeof(profileData.ElectricIndexesString), profileData.ElectricIndexesString);
			GetProfileDifficultyFloatValues(kv, "player_electric_slow_duration", profileData.ElectricDuration, profileData.ElectricDuration);
			GetProfileDifficultyFloatValues(kv, "player_electric_slow_slowdown", profileData.ElectricSlowdown, profileData.ElectricSlowdown);
			profileData.ElectricBeamParticle = view_as<bool>(kv.GetNum("player_electric_beam_particle", profileData.ElectricBeamParticle));
			kv.GetString("player_electric_red_particle", profileData.ElectricParticleRed, sizeof(profileData.ElectricParticleRed), profileData.ElectricParticleRed);
			kv.GetString("player_electric_blue_particle", profileData.ElectricParticleBlue, sizeof(profileData.ElectricParticleBlue), profileData.ElectricParticleBlue);
		}

		profileData.SmiteEffects = view_as<bool>(kv.GetNum("player_smite_on_hit", profileData.SmiteEffects));
		if (profileData.SmiteEffects)
		{
			profileData.SmiteIndexes = kv.GetNum("player_smite_attack_indexs", profileData.SmiteIndexes);
			if (profileData.SmiteIndexes < 0)
			{
				profileData.SmiteIndexes = 1;
			}
			kv.GetString("player_smite_attack_indexs", profileData.SmiteIndexesString, sizeof(profileData.SmiteIndexesString), profileData.SmiteIndexesString);
			profileData.SmiteDamage = kv.GetFloat("player_smite_damage", profileData.SmiteDamage);
			profileData.SmiteDamageType = kv.GetNum("player_smite_damage_type", profileData.SmiteDamageType);
			profileData.SmiteColor[0] = kv.GetNum("player_smite_color_r", profileData.SmiteColor[0]);
			profileData.SmiteColor[1] = kv.GetNum("player_smite_color_g", profileData.SmiteColor[1]);
			profileData.SmiteColor[2] = kv.GetNum("player_smite_color_b", profileData.SmiteColor[2]);
			profileData.SmiteColor[3] = kv.GetNum("player_smite_transparency", profileData.SmiteColor[3]);
			profileData.SmiteMessage = view_as<bool>(kv.GetNum("player_smite_message", profileData.SmiteMessage));
		}
	}

	profileData.XenobladeCombo = view_as<bool>(kv.GetNum("xenoblade_chain_art_combo", profileData.XenobladeCombo));
	profileData.XenobladeDuration = kv.GetFloat("xenoblade_break_duration", profileData.XenobladeDuration);
	profileData.XenobladeToppleDuration = kv.GetFloat("xenoblade_topple_duration", profileData.XenobladeToppleDuration);
	profileData.XenobladeToppleSlowdown = kv.GetFloat("xenoblade_topple_slowdown", profileData.XenobladeToppleSlowdown);
	profileData.XenobladeDazeDuration = kv.GetFloat("xenoblade_daze_duration", profileData.XenobladeDazeDuration);

	profileData.ProjectileType = kv.GetNum("projectile_type", profileData.ProjectileType);

	profileData.DamageParticles = view_as<bool>(kv.GetNum("damage_particle_effect_enabled", profileData.DamageParticles));
	kv.GetString("damage_effect_particle", profileData.DamageParticleName, sizeof(profileData.DamageParticleName), profileData.DamageParticleName);
	profileData.DamageParticleBeam = view_as<bool>(kv.GetNum("damage_effect_beam_particle", profileData.DamageParticleBeam));
	kv.GetString("sound_damage_effect", profileData.DamageParticleSound, sizeof(profileData.DamageParticleSound), profileData.DamageParticleSound);

	profileData.Shockwaves = view_as<bool>(kv.GetNum("shockwave", profileData.Shockwaves));
	if (profileData.Shockwaves)
	{
		GetProfileDifficultyFloatValues(kv, "shockwave_height", profileData.ShockwaveHeight, profileData.ShockwaveHeight);
		GetProfileDifficultyFloatValues(kv, "shockwave_range", profileData.ShockwaveRange, profileData.ShockwaveRange);
		GetProfileDifficultyFloatValues(kv, "shockwave_drain", profileData.ShockwaveDrain, profileData.ShockwaveDrain);
		GetProfileDifficultyFloatValues(kv, "shockwave_force", profileData.ShockwaveForce, profileData.ShockwaveForce);

		profileData.ShockwaveStun = view_as<bool>(kv.GetNum("shockwave_stun", profileData.ShockwaveStun));
		GetProfileDifficultyFloatValues(kv, "shockwave_stun_duration", profileData.ShockwaveStunDuration, profileData.ShockwaveStunDuration);
		GetProfileDifficultyFloatValues(kv, "shockwave_stun_slowdown", profileData.ShockwaveStunSlowdown, profileData.ShockwaveStunSlowdown);

		profileData.ShockwaveIndexes = kv.GetNum("shockwave_attack_index", profileData.ShockwaveIndexes);
		if (profileData.ShockwaveIndexes < 1)
		{
			profileData.ShockwaveIndexes = 1;
		}
		kv.GetString("shockwave_attack_index", profileData.ShockwaveIndexesString, sizeof(profileData.ShockwaveIndexesString), profileData.ShockwaveIndexesString);
		profileData.ShockwaveWidths[0] = kv.GetFloat("shockwave_width_1", profileData.ShockwaveWidths[0]);
		profileData.ShockwaveWidths[1] = kv.GetFloat("shockwave_width_2", profileData.ShockwaveWidths[1]);
		profileData.ShockwaveAmplitude = kv.GetFloat("shockwave_amplitude", profileData.ShockwaveAmplitude);

		float tempColor[3];
		tempColor[0] = float(profileData.ShockwaveColor1[0]);
		tempColor[1] = float(profileData.ShockwaveColor1[1]);
		tempColor[2] = float(profileData.ShockwaveColor1[2]);
		kv.GetVector("shockwave_color_1", tempColor, tempColor);
		profileData.ShockwaveColor1[0] = RoundToNearest(tempColor[0]);
		profileData.ShockwaveColor1[1] = RoundToNearest(tempColor[1]);
		profileData.ShockwaveColor1[2] = RoundToNearest(tempColor[2]);

		tempColor[0] = float(profileData.ShockwaveColor2[0]);
		tempColor[1] = float(profileData.ShockwaveColor2[1]);
		tempColor[2] = float(profileData.ShockwaveColor2[2]);
		kv.GetVector("shockwave_color_2", tempColor, tempColor);
		profileData.ShockwaveColor2[0] = RoundToNearest(tempColor[0]);
		profileData.ShockwaveColor2[1] = RoundToNearest(tempColor[1]);
		profileData.ShockwaveColor2[2] = RoundToNearest(tempColor[2]);

		profileData.ShockwaveAlpha1 = kv.GetNum("shockwave_alpha_1", profileData.ShockwaveAlpha1);
		profileData.ShockwaveAlpha2 = kv.GetNum("shockwave_alpha_2", profileData.ShockwaveAlpha2);

		kv.GetString("shockwave_beam_sprite", profileData.ShockwaveBeamSprite, sizeof(profileData.ShockwaveBeamSprite), profileData.ShockwaveBeamSprite);
		kv.GetString("shockwave_halo_sprite", profileData.ShockwaveHaloSprite, sizeof(profileData.ShockwaveHaloSprite), profileData.ShockwaveHaloSprite);
		profileData.ShockwaveBeamModel = PrecacheModel(profileData.ShockwaveBeamSprite, true);
		profileData.ShockwaveHaloModel = PrecacheModel(profileData.ShockwaveHaloSprite, true);
	}

	profileData.EarthquakeFootsteps = view_as<bool>(kv.GetNum("earthquake_footsteps", profileData.EarthquakeFootsteps));
	if (profileData.EarthquakeFootsteps)
	{
		profileData.EarthquakeFootstepAmplitude = kv.GetFloat("earthquake_footsteps_amplitude", profileData.EarthquakeFootstepAmplitude);
		profileData.EarthquakeFootstepFrequency = kv.GetFloat("earthquake_footsteps_frequency", profileData.EarthquakeFootstepFrequency);
		profileData.EarthquakeFootstepDuration = kv.GetFloat("earthquake_footsteps_duration", profileData.EarthquakeFootstepDuration);
		profileData.EarthquakeFootstepRadius = kv.GetFloat("earthquake_footsteps_radius", profileData.EarthquakeFootstepRadius);
		profileData.EarthquakeFootstepAirShake = view_as<bool>(kv.GetNum("earthquake_footsteps_airshake", profileData.EarthquakeFootstepAirShake));
	}

	profileData.Traps = view_as<bool>(kv.GetNum("traps_enabled", profileData.Traps));
	profileData.TrapType = kv.GetNum("trap_type", profileData.TrapType);
	GetProfileDifficultyFloatValues(kv, "trap_spawn_cooldown", profileData.TrapCooldown, profileData.TrapCooldown);

	profileData.AutoChaseEnabled = view_as<bool>(kv.GetNum("auto_chase_enabled", profileData.AutoChaseEnabled));
	if (profileData.AutoChaseEnabled)
	{
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_threshold", profileData.AutoChaseCount, profileData.AutoChaseCount);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add", profileData.AutoChaseAdd, profileData.AutoChaseAdd);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_footsteps", profileData.AutoChaseAddFootstep, profileData.AutoChaseAddFootstep);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_voice", profileData.AutoChaseAddVoice, profileData.AutoChaseAddVoice);
		GetProfileDifficultyNumValues(kv, "auto_chase_sound_add_weapon", profileData.AutoChaseAddWeapon, profileData.AutoChaseAddWeapon);
	}
	profileData.AutoChaseSprinters = view_as<bool>(kv.GetNum("auto_chase_sprinters", profileData.AutoChaseSprinters));
	profileData.SoundCountToAlert = kv.GetNum("search_sound_count_until_alert", profileData.SoundCountToAlert);

	profileData.ChasesEndlessly = view_as<bool>(KvGetNum(kv,"boss_chases_endlessly", profileData.ChasesEndlessly));

	profileData.SelfHeal = view_as<bool>(kv.GetNum("self_heal_enabled", profileData.SelfHeal));
	if (profileData.SelfHeal)
	{
		profileData.SelfHealPercentageStart = kv.GetFloat("health_percentage_to_heal", profileData.SelfHealPercentageStart);
		if (profileData.SelfHealPercentageStart < 0.0)
		{
			profileData.SelfHealPercentageStart = 0.0;
		}
		if (profileData.SelfHealPercentageStart > 0.999)
		{
			profileData.SelfHealPercentageStart = 0.999;
		}
		profileData.SelfHealRecover[0] = kv.GetFloat("heal_percentage_one", profileData.SelfHealRecover[0]);
		if (profileData.SelfHealRecover[0] < 0.0)
		{
			profileData.SelfHealRecover[0] = 0.0;
		}
		if (profileData.SelfHealRecover[0] > 1.0)
		{
			profileData.SelfHealRecover[0] = 1.0;
		}
		profileData.SelfHealRecover[1] = kv.GetFloat("heal_percentage_two", profileData.SelfHealRecover[1]);
		if (profileData.SelfHealRecover[1] < 0.0)
		{
			profileData.SelfHealRecover[1] = 0.0;
		}
		if (profileData.SelfHealRecover[1] > 1.0)
		{
			profileData.SelfHealRecover[1] = 1.0;
		}
		profileData.SelfHealRecover[2] = kv.GetFloat("heal_percentage_three", profileData.SelfHealRecover[2]);
		if (profileData.SelfHealRecover[2] < 0.0)
		{
			profileData.SelfHealRecover[2] = 0.0;
		}
		if (profileData.SelfHealRecover[2] > 1.0)
		{
			profileData.SelfHealRecover[2] = 1.0;
		}
		profileData.CloakToHeal = view_as<bool>(kv.GetNum("cloak_to_heal", profileData.CloakToHeal));
	}

	profileData.Crawling = view_as<bool>(kv.GetNum("crawling_enabled", profileData.Crawling));
	if (profileData.Crawling)
	{
		GetProfileDifficultyFloatValues(kv, "crawl_multiplier", profileData.CrawlSpeedMultiplier, profileData.CrawlSpeedMultiplier);
		kv.GetVector("crawl_detect_mins", profileData.CrawlDetectMins, profileData.CrawlDetectMins);
		kv.GetVector("crawl_detect_maxs", profileData.CrawlDetectMaxs, profileData.CrawlDetectMaxs);
	}

	profileData.ChaseOnLook = view_as<bool>(kv.GetNum("auto_chase_upon_look", profileData.ChaseOnLook));

	profileData.MemoryLifeTime = kv.GetFloat("memory_lifetime", profileData.MemoryLifeTime);

	GetProfileDifficultyFloatValues(kv, "awareness_rate_increase", profileData.AwarenessIncreaseRate, profileData.AwarenessIncreaseRate);
	GetProfileDifficultyFloatValues(kv, "awareness_rate_decrease", profileData.AwarenessDecreaseRate, profileData.AwarenessDecreaseRate);

	profileData.BoxingBoss = view_as<bool>(kv.GetNum("boxing_boss", profileData.BoxingBoss));

	profileData.NormalSoundHook = view_as<bool>(kv.GetNum("normal_sound_hook", profileData.NormalSoundHook));

	profileData.ChaseInitialAnimations = view_as<bool>(kv.GetNum("use_chase_initial_animation", profileData.ChaseInitialAnimations));

	profileData.SpawnAnimationsEnabled = view_as<bool>(kv.GetNum("spawn_animation", profileData.SpawnAnimationsEnabled));

	profileData.OldAnimationAI = view_as<bool>(kv.GetNum("old_animation_ai", profileData.OldAnimationAI));

	profileData.AlertWalkingAnimation = view_as<bool>(kv.GetNum("use_alert_walking_animation", profileData.AlertWalkingAnimation));

	if (profileData.BoxingBoss)
	{
		profileData.HealAnimationTimer = kv.GetFloat("heal_timer_animation", profileData.HealAnimationTimer);
		profileData.HealFunctionTimer = kv.GetFloat("heal_timer", profileData.HealFunctionTimer);
		profileData.HealRangeMin = kv.GetFloat("heal_range_min", profileData.HealRangeMin);
		profileData.HealRangeMax = kv.GetFloat("heal_range_max", profileData.HealRangeMax);
		profileData.HealTimeMin = kv.GetFloat("heal_time_min", profileData.HealTimeMin);
		profileData.HealTimeMax = kv.GetFloat("heal_range_max", profileData.HealTimeMax);

		profileData.AfterburnMultiplier = kv.GetFloat("fire_damage_multiplier", profileData.AfterburnMultiplier);
		profileData.BackstabDamageScale = kv.GetFloat("backstab_damage_scale", profileData.BackstabDamageScale);
	}

	profileData.Attacks = new ArrayList(sizeof(SF2ChaserBossProfileAttackData));

	int attackNums = ParseChaserProfileAttacks(kv, profileData);

	if (g_CachedProfileData.Flags & SFF_ATTACKPROPS)
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
		profileData.RageAllSounds.Channel = SNDCHAN_VOICE;
		profileData.RageTwoSounds.Channel = SNDCHAN_VOICE;
		profileData.RageThreeSounds.Channel = SNDCHAN_VOICE;
		profileData.SelfHealSounds.Channel = SNDCHAN_VOICE;
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
				profileData.SortSoundSections(kv, s2);
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	if (attackNums > 0)
	{
		if (kv.JumpToKey(g_SlenderVoiceList[SF2BossSound_Attack]))
		{
			profileData.AttackSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
			char number[3];
			if (kv.GotoFirstSubKey())
			{
				char sectionName[64];
				kv.GetSectionName(sectionName, sizeof(sectionName));
				if (strcmp(sectionName, "paths") == 0)
				{
					kv.GoBack();
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					if (profileData.NormalSoundHook)
					{
						soundInfo.Channel = SNDCHAN_VOICE;
					}
					soundInfo.Load(kv);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						profileData.AttackSounds.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				else
				{
					profileData.AttackSounds.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
					for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
					{
						SF2BossProfileSoundInfo tempInfo;
						profileData.AttackSounds.SetArray(i, tempInfo, sizeof(tempInfo));
					}
					do
					{
						kv.GetSectionName(number, sizeof(number));
						int index = StringToInt(number);
						SF2BossProfileSoundInfo soundInfo;
						soundInfo.Init();
						if (profileData.NormalSoundHook)
						{
							soundInfo.Channel = SNDCHAN_VOICE;
						}
						soundInfo.Load(kv);
						soundInfo.PostLoad();
						if (soundInfo.Paths != null)
						{
							profileData.AttackSounds.SetArray(index - 1, soundInfo, sizeof(soundInfo));
						}
					}
					while (kv.GotoNextKey());
					kv.GoBack();
				}
			}
			kv.GoBack();
		}
		if (kv.JumpToKey("sound_hitenemy"))
		{
			profileData.HitSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
			char number[3];
			if (kv.GotoFirstSubKey())
			{
				char sectionName[64];
				kv.GetSectionName(sectionName, sizeof(sectionName));
				if (strcmp(sectionName, "paths") == 0)
				{
					kv.GoBack();
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					soundInfo.Load(kv);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						profileData.HitSounds.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				else
				{
					profileData.HitSounds.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
					for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
					{
						SF2BossProfileSoundInfo tempInfo;
						profileData.HitSounds.SetArray(i, tempInfo, sizeof(tempInfo));
					}
					do
					{
						kv.GetSectionName(number, sizeof(number));
						int index = StringToInt(number);
						SF2BossProfileSoundInfo soundInfo;
						soundInfo.Init();
						soundInfo.Load(kv);
						soundInfo.PostLoad();
						if (soundInfo.Paths != null)
						{
							profileData.HitSounds.SetArray(index - 1, soundInfo, sizeof(soundInfo));
						}
					}
					while (kv.GotoNextKey());
					kv.GoBack();
				}
			}
			kv.GoBack();
		}
		if (kv.JumpToKey("sound_missenemy"))
		{
			profileData.MissSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
			char number[3];
			if (kv.GotoFirstSubKey())
			{
				char sectionName[64];
				kv.GetSectionName(sectionName, sizeof(sectionName));
				if (strcmp(sectionName, "paths") == 0)
				{
					kv.GoBack();
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					soundInfo.Load(kv);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						profileData.MissSounds.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				else
				{
					profileData.MissSounds.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
					for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
					{
						SF2BossProfileSoundInfo tempInfo;
						profileData.MissSounds.SetArray(i, tempInfo, sizeof(tempInfo));
					}
					do
					{
						kv.GetSectionName(number, sizeof(number));
						int index = StringToInt(number);
						SF2BossProfileSoundInfo soundInfo;
						soundInfo.Init();
						soundInfo.Load(kv);
						soundInfo.PostLoad();
						if (soundInfo.Paths != null)
						{
							profileData.MissSounds.SetArray(index - 1, soundInfo, sizeof(soundInfo));
						}
					}
					while (kv.GotoNextKey());
					kv.GoBack();
				}
			}
			kv.GoBack();
		}
		if (kv.JumpToKey("sound_bulletshoot"))
		{
			profileData.BulletShootSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
			char number[3];
			if (kv.GotoFirstSubKey())
			{
				char sectionName[64];
				kv.GetSectionName(sectionName, sizeof(sectionName));
				if (strcmp(sectionName, "paths") == 0)
				{
					kv.GoBack();
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					soundInfo.Load(kv);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						profileData.BulletShootSounds.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				else
				{
					profileData.BulletShootSounds.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
					for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
					{
						SF2BossProfileSoundInfo tempInfo;
						profileData.BulletShootSounds.SetArray(i, tempInfo, sizeof(tempInfo));
					}
					do
					{
						kv.GetSectionName(number, sizeof(number));
						int index = StringToInt(number);
						SF2BossProfileSoundInfo soundInfo;
						soundInfo.Init();
						soundInfo.Load(kv);
						soundInfo.PostLoad();
						if (soundInfo.Paths != null)
						{
							profileData.BulletShootSounds.SetArray(index - 1, soundInfo, sizeof(soundInfo));
						}
					}
					while (kv.GotoNextKey());
					kv.GoBack();
				}
			}
			kv.GoBack();
		}
		if (kv.JumpToKey("sound_attackshootprojectile"))
		{
			profileData.ProjectileShootSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
			char number[3];
			if (kv.GotoFirstSubKey())
			{
				char sectionName[64];
				kv.GetSectionName(sectionName, sizeof(sectionName));
				if (strcmp(sectionName, "paths") == 0)
				{
					kv.GoBack();
					SF2BossProfileSoundInfo soundInfo;
					soundInfo.Init();
					soundInfo.Load(kv);
					soundInfo.PostLoad();
					if (soundInfo.Paths != null)
					{
						profileData.ProjectileShootSounds.PushArray(soundInfo, sizeof(soundInfo));
					}
				}
				else
				{
					profileData.ProjectileShootSounds.Resize(SF2_CHASER_BOSS_MAX_ATTACKS);
					for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
					{
						SF2BossProfileSoundInfo tempInfo;
						profileData.ProjectileShootSounds.SetArray(i, tempInfo, sizeof(tempInfo));
					}
					do
					{
						kv.GetSectionName(number, sizeof(number));
						int index = StringToInt(number);
						SF2BossProfileSoundInfo soundInfo;
						soundInfo.Init();
						soundInfo.Load(kv);
						soundInfo.PostLoad();
						if (soundInfo.Paths != null)
						{
							profileData.ProjectileShootSounds.SetArray(index - 1, soundInfo, sizeof(soundInfo));
						}
					}
					while (kv.GotoNextKey());
					kv.GoBack();
				}
			}
			kv.GoBack();
		}
		char sectionName[128];
		kv.GetSectionName(sectionName, sizeof(sectionName));
	}

	profileData.PostLoad();

	g_ChaserBossProfileData.SetArray(profile, profileData, sizeof(profileData));

	return true;
}

public int ParseChaserProfileAttacks(KeyValues kv, SF2ChaserBossProfileData chaserProfileData)
{
	// Create the array.
	ArrayList attacks = chaserProfileData.Attacks;

	int maxAttacks = -1;
	if (kv.JumpToKey("attacks"))
	{
		maxAttacks = 0;
		char num[3];
		for (int i = 1; i <= SF2_CHASER_BOSS_MAX_ATTACKS; i++)
		{
			FormatEx(num, sizeof(num), "%d", i);
			if (kv.JumpToKey(num))
			{
				maxAttacks++;
				kv.GoBack();
			}
		}
		if (maxAttacks == 0)
		{
			LogSF2Message("[SF2 PROFILES PARSER] Critical error, found \"attacks\" section with no attacks inside of it!");
		}
	}
	if (maxAttacks <= -1)
	{
		return -1;
	}
	else
	{
		attacks.Resize(maxAttacks);
		for (int i = 0; i < maxAttacks; i++)
		{
			attacks.Set(i, SF2BossAttackType_Invalid, SF2ChaserBossProfileAttackData::Type);
		}
	}
	char num[3];
	for (int attackNum = -1; attackNum <=maxAttacks; attackNum++)
	{
		if (attackNum < 1)
		{
			attackNum = 1;
		}
		FormatEx(num, sizeof(num), "%d", attackNum);
		kv.JumpToKey(num);
		SF2ChaserBossProfileAttackData attackData;
		attackData.Init();

		attackData.Type = kv.GetNum("type", attackData.Type);

		attackData.Range = kv.GetFloat("range", attackData.Range);
		if (attackData.Range < 0.0)
		{
			attackData.Range = 0.0;
		}

		switch (attackData.Type)
		{
			case SF2BossAttackType_Melee:
			{
				GetProfileDifficultyFloatValues(kv, "damage", attackData.Damage, attackData.Damage);

				attackData.DamageVsProps = kv.GetFloat("damage_vs_props", attackData.DamageVsProps);
				attackData.DamageForce = kv.GetFloat("damageforce", attackData.DamageForce);

				attackData.DamageType = kv.GetNum("damagetype", attackData.DamageType);
				if (attackData.DamageType < 0)
				{
					attackData.DamageType = 0;
				}

				attackData.CanUseAgainstProps = view_as<bool>(kv.GetNum("props", attackData.CanUseAgainstProps));

				kv.GetVector("punchvel", attackData.PunchVelocity, attackData.PunchVelocity);

				attackData.LifeSteal = view_as<bool>(kv.GetNum("lifesteal", attackData.LifeSteal));
				if (attackData.LifeSteal)
				{
					attackData.LifeStealDuration = kv.GetFloat("lifesteal_duration", attackData.LifeStealDuration);
					if (attackData.LifeStealDuration < 0.0)
					{
						attackData.LifeStealDuration = 0.0;
					}
				}

				attackData.PullIn = view_as<bool>(kv.GetNum("pull_player_in", attackData.PullIn));

				attackData.DeathCamLowHealth = view_as<bool>(kv.GetNum("deathcam_on_low_health", attackData.DeathCamLowHealth));
			}
			case SF2BossAttackType_Ranged:
			{
				GetProfileDifficultyNumValues(kv, "bullet_count", attackData.BulletCount, attackData.BulletCount);
				GetProfileDifficultyFloatValues(kv, "bullet_damage", attackData.BulletDamage, attackData.BulletDamage);
				GetProfileDifficultyFloatValues(kv, "bullet_spread", attackData.BulletSpread, attackData.BulletSpread);
				kv.GetVector("bullet_offset", attackData.BulletOffset, attackData.BulletOffset);
				kv.GetString("bullet_tracer", attackData.BulletTrace, sizeof(attackData.BulletTrace), attackData.BulletTrace);
			}
			case SF2BossAttackType_Projectile:
			{
				GetProfileDifficultyFloatValues(kv, "projectile_damage", attackData.ProjectileDamage, attackData.ProjectileDamage);
				GetProfileDifficultyFloatValues(kv, "projectile_speed", attackData.ProjectileSpeed, attackData.ProjectileSpeed);
				GetProfileDifficultyFloatValues(kv, "projectile_radius", attackData.ProjectileRadius, attackData.ProjectileRadius);
				GetProfileDifficultyFloatValues(kv, "projectile_deviation", attackData.ProjectileDeviation, attackData.ProjectileDeviation);
				attackData.CritProjectiles = view_as<bool>(kv.GetNum("projectile_crits", attackData.CritProjectiles));
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
						LogSF2Message("Attack rocket model file %s on attack index %i failed to be loaded, likely does not exist. This will crash the server if not fixed.", attackData.RocketModel, attackNum);
					}
				}
			}
			case SF2BossAttackType_ExplosiveDance:
			{
				attackData.ExplosiveDanceRadius = kv.GetNum("explosivedance_radius", attackData.ExplosiveDanceRadius);
			}
			case SF2BossAttackType_LaserBeam:
			{
				GetProfileDifficultyFloatValues(kv, "laser_damage", attackData.LaserDamage, attackData.LaserDamage);
				attackData.LaserSize = kv.GetFloat("laser_size", attackData.LaserSize);
				if (attackData.LaserSize < 0.0)
				{
					attackData.LaserSize = 0.0;
				}
				attackData.LaserColor[0] = kv.GetNum("laser_color_r", attackData.LaserColor[0]);
				attackData.LaserColor[1] = kv.GetNum("laser_color_g", attackData.LaserColor[1]);
				attackData.LaserColor[2] = kv.GetNum("laser_color_b", attackData.LaserColor[2]);
				attackData.LaserAttachment = view_as<bool>(kv.GetNum("laser_attachment", attackData.LaserAttachment));
				if (attackData.LaserAttachment)
				{
					kv.GetString("laser_attachment_name", attackData.LaserAttachmentName, sizeof(attackData.LaserAttachmentName), attackData.LaserAttachmentName);
				}
				else
				{
					kv.GetVector("laser_offset", attackData.LaserOffset, attackData.LaserOffset);
				}
				attackData.LaserDuration = kv.GetFloat("laser_duration", attackData.LaserDuration);
				attackData.LaserNoise = kv.GetFloat("laser_noise", attackData.LaserNoise);
			}
		}

		attackData.DontInterruptChaseInitial = view_as<bool>(kv.GetNum("dont_interrupt_chaseinitial", attackData.DontInterruptChaseInitial));

		attackData.DamageDelay = kv.GetFloat("delay", attackData.DamageDelay);
		if (attackData.DamageDelay < 0.0)
		{
			attackData.DamageDelay = 0.0;
		}

		attackData.Duration = kv.GetFloat("duration", attackData.Duration);
		if (attackData.Duration <= 0.0)//Backward compatibility
		{
			if (attackData.Duration < 0.0)
			{
				attackData.Duration = 0.0;
			}
			attackData.Duration = attackData.DamageDelay+kv.GetFloat("endafter", attackData.Duration);
		}

		attackData.Spread = kv.GetFloat("fov", attackData.Spread);
		attackData.Spread = kv.GetFloat("spread", attackData.Spread);

		if (attackData.Spread < 0.0)
		{
			attackData.Spread = 0.0;
		}
		else if (attackData.Spread > 360.0)
		{
			attackData.Spread = 360.0;
		}

		attackData.BeginRange = kv.GetFloat("begin_range", attackData.Range);
		if (attackData.BeginRange < 0.0)
		{
			attackData.BeginRange = 0.0;
		}

		attackData.BeginFOV = kv.GetFloat("begin_fov", attackData.BeginFOV);
		if (attackData.BeginFOV < 0.0)
		{
			attackData.BeginFOV = 0.0;
		}
		else if (attackData.BeginFOV > 360.0)
		{
			attackData.BeginFOV = 360.0;
		}

		GetProfileDifficultyFloatValues(kv, "cooldown", attackData.Cooldown, attackData.Cooldown);

		attackData.Disappear = view_as<bool>(kv.GetNum("disappear_upon_damaging", attackData.Disappear));

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

		attackData.IgnoreAlwaysLooking = view_as<bool>(kv.GetNum("ignore_always_looking", attackData.IgnoreAlwaysLooking));

		attackData.WeaponTypes = view_as<bool>(kv.GetNum("weaponsenable", attackData.WeaponTypes));
		attackData.WeaponInt = kv.GetNum("weapontypeint", attackData.WeaponInt);
		if (attackData.WeaponInt < 1)
		{
			attackData.WeaponInt = 0;
		}
		kv.GetString("weapontype", attackData.WeaponString, sizeof(attackData.WeaponString), attackData.WeaponString);

		attackData.AttackWhileRunning = view_as<bool>(kv.GetNum("run_enabled", attackData.AttackWhileRunning));
		GetProfileDifficultyFloatValues(kv, "run_speed", attackData.RunSpeed, attackData.RunSpeed);
		attackData.RunDuration = kv.GetFloat("run_duration", attackData.RunDuration);
		attackData.RunDelay = kv.GetFloat("run_delay", attackData.RunDelay);

		attackData.UseOnDifficulty = kv.GetNum("use_on_difficulty", attackData.UseOnDifficulty);
		attackData.BlockOnDifficulty = kv.GetNum("block_on_difficulty", attackData.BlockOnDifficulty);
		attackData.UseOnHealth = kv.GetFloat("use_on_health", attackData.UseOnHealth);
		attackData.BlockOnHealth = kv.GetFloat("block_on_health", attackData.BlockOnHealth);

		attackData.Gestures = view_as<bool>(kv.GetNum("gestures", attackData.Gestures));

		attackData.CancelLos = view_as<bool>(kv.GetNum("cancel_los", attackData.CancelLos));
		attackData.CancelDistance = kv.GetFloat("cancel_distance", attackData.CancelDistance);

		attacks.SetArray(attackNum - 1, attackData, sizeof(attackData));

		if (maxAttacks > 0)//Backward compatibility
		{
			kv.GoBack();
		}
		else
		{
			break;
		}
	}
	if (maxAttacks > 0)
	{
		kv.GoBack();
	}
	return maxAttacks;
}
