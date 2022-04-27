#if defined _sf2_profiles_chaser_precache
 #endinput
#endif

#define _sf2_profiles_chaser_precache

/**
 *	Parses and stores the unique values of a chaser profile from the current position in the profiles config.
 *	Returns true if loading was successful, false if not.
 */
public bool LoadChaserBossProfile(KeyValues kv, const char[] profile, int &uniqueProfileIndex, char[] loadFailReasonBuffer)
{
	loadFailReasonBuffer[0] = '\0';
	
	uniqueProfileIndex = g_ChaserProfileData.Push(-1);
	g_ChaserProfileNames.SetValue(profile, uniqueProfileIndex);
	
	float bossDefaultWalkSpeed = kv.GetFloat("walkspeed", 30.0);
	float bossWalkSpeedEasy = kv.GetFloat("walkspeed_easy", bossDefaultWalkSpeed);
	float bossWalkSpeedHard = kv.GetFloat("walkspeed_hard", bossDefaultWalkSpeed);
	float bossWalkSpeedInsane = kv.GetFloat("walkspeed_insane", bossWalkSpeedHard);
	float bossWalkSpeedNightmare = kv.GetFloat("walkspeed_nightmare", bossWalkSpeedInsane);
	float bossWalkSpeedApollyon = kv.GetFloat("walkspeed_apollyon", bossWalkSpeedNightmare);
	
	float bossDefaultMaxWalkSpeed = kv.GetFloat("walkspeed_max", 30.0);
	float bossMaxWalkSpeedEasy = kv.GetFloat("walkspeed_max_easy", bossDefaultMaxWalkSpeed);
	float bossMaxWalkSpeedHard = kv.GetFloat("walkspeed_max_hard", bossDefaultMaxWalkSpeed);
	float bossMaxWalkSpeedInsane = kv.GetFloat("walkspeed_max_insane", bossMaxWalkSpeedHard);
	float bossMaxWalkSpeedNightmare = kv.GetFloat("walkspeed_max_nightmare", bossMaxWalkSpeedInsane);
	float bossMaxWalkSpeedApollyon = kv.GetFloat("walkspeed_max_apollyon", bossMaxWalkSpeedNightmare);

	float wakeRange = kv.GetFloat("wake_radius");
	if (wakeRange < 0.0)
	{
		wakeRange = 0.0;
	}
	
	float alertGracetime = kv.GetFloat("search_alert_gracetime", 0.5);
	float alertGracetimeEasy = kv.GetFloat("search_alert_gracetime_easy", alertGracetime);
	float alertGracetimeHard = kv.GetFloat("search_alert_gracetime_hard", alertGracetime);
	float alertGracetimeInsane = kv.GetFloat("search_alert_gracetime_insane", alertGracetimeHard);
	float alertGracetimeNightmare = kv.GetFloat("search_alert_gracetime_nightmare", alertGracetimeInsane);
	float alertGracetimeApollyon = kv.GetFloat("search_alert_gracetime_apollyon", alertGracetimeNightmare);
	
	float alertDuration = kv.GetFloat("search_alert_duration", 5.0);
	float alertDurationEasy = kv.GetFloat("search_alert_duration_easy", alertDuration);
	float alertDurationHard = kv.GetFloat("search_alert_duration_hard", alertDuration);
	float alertDurationInsane = kv.GetFloat("search_alert_duration_insane", alertDurationHard);
	float alertDurationNightmare = kv.GetFloat("search_alert_duration_nightmare", alertDurationInsane);
	float alertDurationApollyon = kv.GetFloat("search_alert_duration_apollyon", alertDurationNightmare);
	
	float chaseDuration = kv.GetFloat("search_chase_duration", 10.0);
	float chaseDurationEasy = kv.GetFloat("search_chase_duration_easy", chaseDuration);
	float chaseDurationHard = kv.GetFloat("search_chase_duration_hard", chaseDuration);
	float chaseDurationInsane = kv.GetFloat("search_chase_duration_insane", chaseDurationHard);
	float chaseDurationNightmare = kv.GetFloat("search_chase_duration_nightmare", chaseDurationInsane);
	float chaseDurationApollyon = kv.GetFloat("search_chase_duration_apollyon", chaseDurationNightmare);

	float wanderRangeMin = kv.GetFloat("search_wander_range_min", 400.0);
	float wanderRangeMinEasy = kv.GetFloat("search_wander_range_min_easy", wanderRangeMin);
	float wanderRangeMinHard = kv.GetFloat("search_wander_range_min_hard", wanderRangeMin);
	float wanderRangeMinInsane = kv.GetFloat("search_wander_range_min_insane", wanderRangeMinHard);
	float wanderRangeMinNightmare = kv.GetFloat("search_wander_range_min_nightmare", wanderRangeMinInsane);
	float wanderRangeMinApollyon = kv.GetFloat("search_wander_range_min_apollyon", wanderRangeMinNightmare);

	float wanderRangeMax = kv.GetFloat("search_wander_range_max", 1024.0);
	float wanderRangeMaxEasy = kv.GetFloat("search_wander_range_max_easy", wanderRangeMax);
	float wanderRangeMaxHard = kv.GetFloat("search_wander_range_max_hard", wanderRangeMax);
	float wanderRangeMaxInsane = kv.GetFloat("search_wander_range_max_insane", wanderRangeMaxHard);
	float wanderRangeMaxNightmare = kv.GetFloat("search_wander_range_max_nightmare", wanderRangeMaxInsane);
	float wanderRangeMaxApollyon = kv.GetFloat("search_wander_range_max_apollyon", wanderRangeMaxNightmare);

	float wanderTimeMin = kv.GetFloat("search_wander_time_min", 3.0);
	float wanderTimeMinEasy = kv.GetFloat("search_wander_time_min_easy", wanderTimeMin);
	float wanderTimeMinHard = kv.GetFloat("search_wander_time_min_hard", wanderTimeMin);
	float wanderTimeMinInsane = kv.GetFloat("search_wander_time_min_insane", wanderTimeMinHard);
	float wanderTimeMinNightmare = kv.GetFloat("search_wander_time_min_nightmare", wanderTimeMinInsane);
	float wanderTimeMinApollyon = kv.GetFloat("search_wander_time_min_apollyon", wanderTimeMinNightmare);

	float wanderTimeMax = kv.GetFloat("search_wander_time_max", 4.5);
	float wanderTimeMaxEasy = kv.GetFloat("search_wander_time_max_easy", wanderTimeMax);
	float wanderTimeMaxHard = kv.GetFloat("search_wander_time_max_hard", wanderTimeMax);
	float wanderTimeMaxInsane = kv.GetFloat("search_wander_time_max_insane", wanderTimeMaxHard);
	float wanderTimeMaxNightmare = kv.GetFloat("search_wander_time_max_nightmare", wanderTimeMaxInsane);
	float wanderTimeMaxApollyon = kv.GetFloat("search_wander_time_max_apollyon", wanderTimeMaxNightmare);

	bool canBeStunned = view_as<bool>(kv.GetNum("stun_enabled"));
	
	float stunDuration = kv.GetFloat("stun_duration");
	if (stunDuration < 0.0)
	{
		stunDuration = 0.0;
	}
	
	float stunCooldown = kv.GetFloat("stun_cooldown", 3.5);
	if (stunCooldown < 0.0)
	{
		stunCooldown = 0.0;
	}
	
	float stunHealth = kv.GetFloat("stun_health");
	if (stunHealth < 0.0)
	{
		stunHealth = 0.0;
	}
	float stunHealthPerPlayer = kv.GetFloat("stun_health_per_player");
	if (stunHealthPerPlayer < 0.0)
	{
		stunHealthPerPlayer = 0.0;
	}
	
	bool stunTakeDamageFromFlashlight = view_as<bool>(kv.GetNum("stun_damage_flashlight_enabled"));
	
	float stunFlashlightDamage = kv.GetFloat("stun_damage_flashlight");

	bool itemDrop = view_as<bool>(kv.GetNum("drop_item_on_stun"));
	int itemDropType = kv.GetNum("drop_item_type", 1);
	if (itemDropType < 1)
	{
		itemDropType = 1;
	}
	if (itemDropType > 7)
	{
		itemDropType = 7;
	}
	
	bool keyDrop = view_as<bool>(kv.GetNum("keydrop_enabled"));
	
	bool canCloak = view_as<bool>(kv.GetNum("cloak_enable"));
	
	float bossDefaultCloakCooldown = kv.GetFloat("cloak_cooldown", 8.0);
	float bossCloakCooldownEasy = kv.GetFloat("cloak_cooldown_easy", bossDefaultCloakCooldown);
	float bossCloakCooldownHard = kv.GetFloat("cloak_cooldown_hard", bossDefaultCloakCooldown);
	float bossCloakCooldownInsane = kv.GetFloat("cloak_cooldown_insane", bossCloakCooldownHard);
	float bossCloakCooldownNightmare = kv.GetFloat("cloak_cooldown_nightmare", bossCloakCooldownInsane);
	float bossCloakCooldownApollyon = kv.GetFloat("cloak_cooldown_apollyon", bossCloakCooldownNightmare);
	
	float bossDefaultCloakRange = kv.GetFloat("cloak_range", 350.0);
	float bossCloakRangeEasy = kv.GetFloat("cloak_range_easy", bossDefaultCloakRange);
	float bossCloakRangeHard = kv.GetFloat("cloak_range_hard", bossDefaultCloakRange);
	float bossCloakRangeInsane = kv.GetFloat("cloak_range_insane", bossCloakRangeHard);
	float bossCloakRangeNightmare = kv.GetFloat("cloak_range_nightmare", bossCloakRangeInsane);
	float bossCloakRangeApollyon = kv.GetFloat("cloak_range_apollyon", bossCloakRangeNightmare);

	float bossDefaultDecloakRange = kv.GetFloat("cloak_decloak_range", 150.0);
	float bossDecloakRangeEasy = kv.GetFloat("cloak_decloak_range_easy", bossDefaultDecloakRange);
	float bossDecloakRangeHard = kv.GetFloat("cloak_decloak_range_hard", bossDefaultDecloakRange);
	float bossDecloakRangeInsane = kv.GetFloat("cloak_decloak_range_insane", bossDecloakRangeHard);
	float bossDecloakRangeNightmare = kv.GetFloat("cloak_decloak_range_nightmare", bossDecloakRangeInsane);
	float bossDecloakRangeApollyon = kv.GetFloat("cloak_decloak_range_apollyon", bossDecloakRangeNightmare);

	float bossDefaultCloakDuration = kv.GetFloat("cloak_duration", 10.0);
	float bossCloakDurationEasy = kv.GetFloat("cloak_duration_easy", bossDefaultCloakDuration);
	float bossCloakDurationHard = kv.GetFloat("cloak_duration_hard", bossDefaultCloakDuration);
	float bossCloakDurationInsane = kv.GetFloat("cloak_duration_insane", bossCloakDurationHard);
	float bossCloakDurationNightmare = kv.GetFloat("cloak_duration_nightmare", bossCloakDurationInsane);
	float bossCloakDurationApollyon = kv.GetFloat("cloak_duration_apollyon", bossCloakDurationNightmare);

	float bossDefaultCloakSpeedMultiplier = kv.GetFloat("cloak_speed_multiplier", 1.0);
	float bossCloakSpeedMultiplierEasy = kv.GetFloat("cloak_speed_multiplier_easy", bossDefaultCloakSpeedMultiplier);
	float bossCloakSpeedMultiplierHard = kv.GetFloat("cloak_speed_multiplier_hard", bossDefaultCloakSpeedMultiplier);
	float bossCloakSpeedMultiplierInsane = kv.GetFloat("cloak_speed_multiplier_insane", bossCloakSpeedMultiplierHard);
	float bossCloakSpeedMultiplierNightmare = kv.GetFloat("cloak_speed_multiplier_nightmare", bossCloakSpeedMultiplierInsane);
	float bossCloakSpeedMultiplierApollyon = kv.GetFloat("cloak_speed_multiplier_apollyon", bossCloakSpeedMultiplierNightmare);
	
	bool projectileEnable = view_as<bool>(kv.GetNum("projectile_enable"));
	
	float projectileCooldownMin = kv.GetFloat("projectile_cooldown_min", 1.0);
	float projectileCooldownMinEasy = kv.GetFloat("projectile_cooldown_min_easy", projectileCooldownMin);
	float projectileCooldownMinHard = kv.GetFloat("projectile_cooldown_min_hard", projectileCooldownMin);
	float projectileCooldownMinInsane = kv.GetFloat("projectile_cooldown_min_insane", projectileCooldownMinHard);
	float projectileCooldownMinNightmare = kv.GetFloat("projectile_cooldown_min_nightmare", projectileCooldownMinInsane);
	float projectileCooldownMinApollyon = kv.GetFloat("projectile_cooldown_min_apollyon", projectileCooldownMinNightmare);
	
	float projectileCooldownMax = kv.GetFloat("projectile_cooldown_max", 2.0);
	float projectileCooldownMaxEasy = kv.GetFloat("projectile_cooldown_max_easy", projectileCooldownMax);
	float projectileCooldownMaxHard = kv.GetFloat("projectile_cooldown_max_hard", projectileCooldownMax);
	float projectileCooldownMaxInsane = kv.GetFloat("projectile_cooldown_max_insane", projectileCooldownMaxHard);
	float projectileCooldownMaxNightmare = kv.GetFloat("projectile_cooldown_max_nightmare", projectileCooldownMaxInsane);
	float projectileCooldownMaxApollyon = kv.GetFloat("projectile_cooldown_max_apollyon", projectileCooldownMaxNightmare);
	
	float iceballSlowdownDuration = kv.GetFloat("projectile_iceslow_duration", 2.0);
	float iceballSlowdownDurationEasy = kv.GetFloat("projectile_iceslow_duration_easy", iceballSlowdownDuration);
	float iceballSlowdownDurationHard = kv.GetFloat("projectile_iceslow_duration_hard", iceballSlowdownDuration);
	float iceballSlowdownDurationInsane = kv.GetFloat("projectile_iceslow_duration_insane", iceballSlowdownDurationHard);
	float iceballSlowdownDurationNightmare = kv.GetFloat("projectile_iceslow_duration_nightmare", iceballSlowdownDurationInsane);
	float iceballSlowdownDurationApollyon = kv.GetFloat("projectile_iceslow_duration_apollyon", iceballSlowdownDurationNightmare);
	
	float iceballSlowdownPercent = kv.GetFloat("projectile_iceslow_percent", 0.55);
	float iceballSlowdownPercentEasy = kv.GetFloat("projectile_iceslow_percent_easy", iceballSlowdownPercent);
	float iceballSlowdownPercentHard = kv.GetFloat("projectile_iceslow_percent_hard", iceballSlowdownPercent);
	float iceballSlowdownPercentInsane = kv.GetFloat("projectile_iceslow_percent_insane", iceballSlowdownPercentHard);
	float iceballSlowdownPercentNightmare = kv.GetFloat("projectile_iceslow_percent_nightmare", iceballSlowdownPercentInsane);
	float iceballSlowdownPercentApollyon = kv.GetFloat("projectile_iceslow_percent_apollyon", iceballSlowdownPercentNightmare);

	float projectileSpeed = kv.GetFloat("projectile_speed", 400.0);
	float projectileSpeedEasy = kv.GetFloat("projectile_speed_easy", projectileSpeed);
	float projectileSpeedHard = kv.GetFloat("projectile_speed_hard", projectileSpeed);
	float projectileSpeedInsane = kv.GetFloat("projectile_speed_insane", projectileSpeedHard);
	float projectileSpeedNightmare = kv.GetFloat("projectile_speed_nightmare", projectileSpeedInsane);
	float projectileSpeedApollyon = kv.GetFloat("projectile_speed_apollyon", projectileSpeedNightmare);

	float projectileDamage = kv.GetFloat("projectile_damage", 50.0);
	float projectileDamageEasy = kv.GetFloat("projectile_damage_easy", projectileDamage);
	float projectileDamageHard = kv.GetFloat("projectile_damage_hard", projectileDamage);
	float projectileDamageInsane = kv.GetFloat("projectile_damage_insane", projectileDamageHard);
	float projectileDamageNightmare = kv.GetFloat("projectile_damage_nightmare", projectileDamageInsane);
	float projectileDamageApollyon = kv.GetFloat("projectile_damage_apollyon", projectileDamageNightmare);

	float projectileRadius = kv.GetFloat("projectile_damageradius", 128.0);
	float projectileRadiusEasy = kv.GetFloat("projectile_damageradius_easy", projectileRadius);
	float projectileRadiusHard = kv.GetFloat("projectile_damageradius_hard", projectileRadius);
	float projectileRadiusInsane = kv.GetFloat("projectile_damageradius_insane", projectileRadiusHard);
	float projectileRadiusNightmare = kv.GetFloat("projectile_damageradius_nightmare", projectileRadiusInsane);
	float projectileRadiusApollyon = kv.GetFloat("projectile_damageradius_apollyon", projectileRadiusNightmare);

	float projectileDeviation = kv.GetFloat("projectile_deviation", 0.0);
	float projectileDeviationEasy = kv.GetFloat("projectile_deviation_easy", projectileDeviation);
	float projectileDeviationHard = kv.GetFloat("projectile_deviation_hard", projectileDeviation);
	float projectileDeviationInsane = kv.GetFloat("projectile_deviation_insane", projectileDeviationHard);
	float projectileDeviationNightmare = kv.GetFloat("projectile_deviation_nightmare", projectileDeviationInsane);
	float projectileDeviationApollyon = kv.GetFloat("projectile_deviation_apollyon", projectileDeviationNightmare);

	int projectileCount = kv.GetNum("projectile_count", 1);
	if (projectileCount < 1)
	{
		projectileCount = 1;
	}
	int projectileCountEasy = kv.GetNum("projectile_count_easy", projectileCount);
	if (projectileCountEasy < 1)
	{
		projectileCountEasy = 1;
	}
	int projectileCountHard = kv.GetNum("projectile_count_hard", projectileCount);
	if (projectileCountHard < 1)
	{
		projectileCountHard = 1;
	}
	int projectileCountInsane = kv.GetNum("projectile_count_insane", projectileCountHard);
	if (projectileCountInsane < 1)
	{
		projectileCountInsane = 1;
	}
	int projectileCountNightmare = kv.GetNum("projectile_count_nightmare", projectileCountInsane);
	if (projectileCountNightmare < 1)
	{
		projectileCountNightmare = 1;
	}
	int projectileCountApollyon = kv.GetNum("projectile_count_apollyon", projectileCountNightmare);
	if (projectileCountApollyon < 1)
	{
		projectileCountApollyon = 1;
	}
	
	bool rocketCritical = view_as<bool>(kv.GetNum("enable_crit_rockets"));
	bool useShootGesture = view_as<bool>(kv.GetNum("use_gesture_shoot"));
	
	bool enableProjectileClips = view_as<bool>(kv.GetNum("projectile_clips_enable"));
	
	int projectileClips = kv.GetNum("projectile_ammo_loaded", 3);
	int projectileClipsEasy = kv.GetNum("projectile_ammo_loaded_easy", projectileClips);
	int projectileClipsHard = kv.GetNum("projectile_ammo_loaded_hard", projectileClips);
	int projectileClipsInsane = kv.GetNum("projectile_ammo_loaded_insane", projectileClipsHard);
	int projectileClipsNightmare = kv.GetNum("projectile_ammo_loaded_nightmare", projectileClipsInsane);
	int projectileClipsApollyon = kv.GetNum("projectile_ammo_loaded_apollyon", projectileClipsNightmare);
	
	float projectilesReload = kv.GetFloat("projectile_reload_time", 2.0);
	float projectilesReloadEasy = kv.GetFloat("projectile_reload_time_easy", projectilesReload);
	float projectilesReloadHard = kv.GetFloat("projectile_reload_time_hard", projectilesReload);
	float projectilesReloadInsane = kv.GetFloat("projectile_reload_time_insane", projectilesReloadHard);
	float projectilesReloadNightmare = kv.GetFloat("projectile_reload_time_nightmare", projectilesReloadInsane);
	float projectilesReloadApollyon = kv.GetFloat("projectile_reload_time_apollyon", projectilesReloadNightmare);
	
	bool enableChargeUpProjectiles = view_as<bool>(kv.GetNum("projectile_chargeup_enable"));
	
	float projectileChargeUpDuration = kv.GetFloat("projectile_chargeup_duration", 5.0);
	float projectileChargeUpDurationEasy = kv.GetFloat("projectile_chargeup_duration_easy", projectileChargeUpDuration);
	float projectileChargeUpDurationHard = kv.GetFloat("projectile_chargeup_duration_hard", projectileChargeUpDuration);
	float projectileChargeUpDurationInsane = kv.GetFloat("projectile_chargeup_duration_insane", projectileChargeUpDurationHard);
	float projectileChargeUpDurationNightmare = kv.GetFloat("projectile_chargeup_duration_nightmare", projectileChargeUpDurationInsane);
	float projectileChargeUpDurationApollyon = kv.GetFloat("projectile_chargeup_duration_apollyon", projectileChargeUpDurationNightmare);
	
	bool advancedDamageEffectsEnabled = view_as<bool>(kv.GetNum("player_damage_effects"));
	bool advancedDamageEffectsRandom = view_as<bool>(kv.GetNum("player_damage_random_effects"));
	bool advancedDamageEffectsParticles = view_as<bool>(kv.GetNum("player_attach_particle", 1));
	
	int randomEffectAttackIndexes = kv.GetNum("player_random_attack_indexes", 1);
	if (randomEffectAttackIndexes < 0) randomEffectAttackIndexes = 1;
	
	float randomEffectDurationNormal = kv.GetFloat("player_random_duration");
	float randomEffectDurationEasy = kv.GetFloat("player_random_duration_easy", randomEffectDurationNormal);
	float randomEffectDurationHard = kv.GetFloat("player_random_duration_hard", randomEffectDurationNormal);
	float randomEffectDurationInsane = kv.GetFloat("player_random_duration_insane", randomEffectDurationHard);
	float randomEffectDurationNightmare = kv.GetFloat("player_random_duration_nightmare", randomEffectDurationInsane);
	float randomEffectDurationApollyon = kv.GetFloat("player_random_duration_apollyon", randomEffectDurationNightmare);
	
	float randomEffectSlowdownNormal = kv.GetFloat("player_random_slowdown");
	if (randomEffectSlowdownNormal > 1.0)
	{
		randomEffectSlowdownNormal = 1.0;
	}
	if (randomEffectSlowdownNormal < 0.0)
	{
		randomEffectSlowdownNormal = 0.0;
	}
	float randomEffectSlowdownEasy = kv.GetFloat("player_random_slowdown_easy", randomEffectSlowdownNormal);
	if (randomEffectSlowdownEasy > 1.0)
	{
		randomEffectSlowdownEasy = 1.0;
	}
	if (randomEffectSlowdownEasy < 0.0)
	{
		randomEffectSlowdownEasy = 0.0;
	}
	float randomEffectSlowdownHard = kv.GetFloat("player_random_slowdown_hard", randomEffectSlowdownNormal);
	if (randomEffectSlowdownHard > 1.0)
	{
		randomEffectSlowdownHard = 1.0;
	}
	if (randomEffectSlowdownHard < 0.0)
	{
		randomEffectSlowdownHard = 0.0;
	}
	float randomEffectSlowdownInsane = kv.GetFloat("player_random_slowdown_insane", randomEffectSlowdownHard);
	if (randomEffectSlowdownInsane > 1.0)
	{
		randomEffectSlowdownInsane = 1.0;
	}
	if (randomEffectSlowdownInsane < 0.0)
	{
		randomEffectSlowdownInsane = 0.0;
	}
	float randomEffectSlowdownNightmare = kv.GetFloat("player_random_slowdown_nightmare", randomEffectSlowdownInsane);
	if (randomEffectSlowdownNightmare > 1.0)
	{
		randomEffectSlowdownNightmare = 1.0;
	}
	if (randomEffectSlowdownNightmare < 0.0)
	{
		randomEffectSlowdownNightmare = 0.0;
	}
	float randomEffectSlowdownApollyon = kv.GetFloat("player_random_slowdown_apollyon", randomEffectSlowdownNightmare);
	if (randomEffectSlowdownApollyon > 1.0)
	{
		randomEffectSlowdownApollyon = 1.0;
	}
	if (randomEffectSlowdownApollyon < 0.0)
	{
		randomEffectSlowdownApollyon = 0.0;
	}
	
	int randomStunType = kv.GetNum("player_random_stun_type");
	if (randomStunType < 0)
	{
		randomStunType = 0;
	}
	if (randomStunType > 3)
	{
		randomStunType = 3;
	}
	
	bool jaratePlayerAdvanced = view_as<bool>(kv.GetNum("player_jarate_on_hit"));
	
	int jaratePlayerAttackIndexes = kv.GetNum("player_jarate_attack_indexs", 1);
	if (jaratePlayerAttackIndexes < 0)
	{
		jaratePlayerAttackIndexes = 1;
	}
	
	float jaratePlayerDurationNormal = kv.GetFloat("player_jarate_duration");
	float jaratePlayerDurationEasy = kv.GetFloat("player_jarate_duration_easy", jaratePlayerDurationNormal);
	float jaratePlayerDurationHard = kv.GetFloat("player_jarate_duration_hard", jaratePlayerDurationNormal);
	float jaratePlayerDurationInsane = kv.GetFloat("player_jarate_duration_insane", jaratePlayerDurationHard);
	float jaratePlayerDurationNightmare = kv.GetFloat("player_jarate_duration_nightmare", jaratePlayerDurationInsane);
	float jaratePlayerDurationApollyon = kv.GetFloat("player_jarate_duration_apollyon", jaratePlayerDurationNightmare);

	bool jaratePlayerParticleBeam = view_as<bool>(kv.GetNum("player_jarate_beam_particle"));

	bool milkPlayerAdvanced = view_as<bool>(kv.GetNum("player_milk_on_hit"));
	
	int milkPlayerAttackIndexes = kv.GetNum("player_milk_attack_indexs", 1);
	if (milkPlayerAttackIndexes < 0)
	{
		milkPlayerAttackIndexes = 1;
	}
	
	float milkPlayerDurationNormal = kv.GetFloat("player_milk_duration");
	float milkPlayerDurationEasy = kv.GetFloat("player_milk_duration_easy", milkPlayerDurationNormal);
	float milkPlayerDurationHard = kv.GetFloat("player_milk_duration_hard", milkPlayerDurationNormal);
	float milkPlayerDurationInsane = kv.GetFloat("player_milk_duration_insane", milkPlayerDurationHard);
	float milkPlayerDurationNightmare = kv.GetFloat("player_milk_duration_nightmare", milkPlayerDurationInsane);
	float milkPlayerDurationApollyon = kv.GetFloat("player_milk_duration_apollyon", milkPlayerDurationNightmare);

	bool milkPlayerParticleBeam = view_as<bool>(kv.GetNum("player_milk_beam_particle"));

	bool gasPlayerAdvanced = view_as<bool>(kv.GetNum("player_gas_on_hit"));
	
	int gasPlayerAttackIndexes = kv.GetNum("player_gas_attack_indexs", 1);
	if (gasPlayerAttackIndexes < 0)
	{
		gasPlayerAttackIndexes = 1;
	}
	
	float gasPlayerDurationNormal = kv.GetFloat("player_gas_duration");
	float gasPlayerDurationEasy = kv.GetFloat("player_gas_duration_easy", gasPlayerDurationNormal);
	float gasPlayerDurationHard = kv.GetFloat("player_gas_duration_hard", gasPlayerDurationNormal);
	float gasPlayerDurationInsane = kv.GetFloat("player_gas_duration_insane", gasPlayerDurationHard);
	float gasPlayerDurationNightmare = kv.GetFloat("player_gas_duration_nightmare", gasPlayerDurationInsane);
	float gasPlayerDurationApollyon = kv.GetFloat("player_gas_duration_apollyon", gasPlayerDurationNightmare);

	bool gasPlayerParticleBeam = view_as<bool>(kv.GetNum("player_gas_beam_particle"));

	bool markPlayerAdvanced = view_as<bool>(kv.GetNum("player_mark_on_hit"));
	
	int markPlayerAttackIndexes = kv.GetNum("player_mark_attack_indexs", 1);
	if (markPlayerAttackIndexes < 0)
	{
		markPlayerAttackIndexes = 1;
	}
	
	float markPlayerDurationNormal = kv.GetFloat("player_mark_duration");
	float markPlayerDurationEasy = kv.GetFloat("player_mark_duration_easy", markPlayerDurationNormal);
	float markPlayerDurationHard = kv.GetFloat("player_mark_duration_hard", markPlayerDurationNormal);
	float markPlayerDurationInsane = kv.GetFloat("player_mark_duration_insane", markPlayerDurationHard);
	float markPlayerDurationNightmare = kv.GetFloat("player_mark_duration_nightmare", markPlayerDurationInsane);
	float markPlayerDurationApollyon = kv.GetFloat("player_mark_duration_apollyon", markPlayerDurationNightmare);

	bool silentMarkPlayerAdvanced = view_as<bool>(kv.GetNum("player_silent_mark_on_hit"));
	
	int silentMarkPlayerAttackIndexes = kv.GetNum("player_silent_mark_attack_indexs", 1);
	if (silentMarkPlayerAttackIndexes < 0)
	{
		silentMarkPlayerAttackIndexes = 1;
	}
	
	float silentMarkPlayerDurationNormal = kv.GetFloat("player_silent_mark_duration");
	float silentMarkPlayerDurationEasy = kv.GetFloat("player_silent_mark_duration_easy", silentMarkPlayerDurationNormal);
	float silentMarkPlayerDurationHard = kv.GetFloat("player_silent_mark_duration_hard", silentMarkPlayerDurationNormal);
	float silentMarkPlayerDurationInsane = kv.GetFloat("player_silent_mark_duration_insane", silentMarkPlayerDurationHard);
	float silentMarkPlayerDurationNightmare = kv.GetFloat("player_silent_mark_duration_nightmare", silentMarkPlayerDurationInsane);
	float silentMarkPlayerDurationApollyon = kv.GetFloat("player_silent_mark_duration_apollyon", silentMarkPlayerDurationNightmare);

	bool ignitePlayerAdvanced = view_as<bool>(kv.GetNum("player_ignite_on_hit"));
	
	int ignitePlayerAttackIndexes = kv.GetNum("player_ignite_attack_indexs", 1);
	if (ignitePlayerAttackIndexes < 0)
	{
		ignitePlayerAttackIndexes = 1;
	}
	
	float ignitePlayerDelayNormal = kv.GetFloat("player_ignite_delay");
	float ignitePlayerDelayEasy = kv.GetFloat("player_ignite_delay_easy", ignitePlayerDelayNormal);
	float ignitePlayerDelayHard = kv.GetFloat("player_ignite_delay_hard", ignitePlayerDelayNormal);
	float ignitePlayerDelayInsane = kv.GetFloat("player_ignite_delay_insane", ignitePlayerDelayHard);
	float ignitePlayerDelayNightmare = kv.GetFloat("player_ignite_delay_nightmare", ignitePlayerDelayInsane);
	float ignitePlayerDelayApollyon = kv.GetFloat("player_ignite_delay_apollyon", ignitePlayerDelayNightmare);

	bool stunPlayerAdvanced = view_as<bool>(kv.GetNum("player_stun_on_hit"));
	
	int stunPlayerType = kv.GetNum("player_stun_type");
	if (stunPlayerType < 0)
	{
		stunPlayerType = 0;
	}
	if (stunPlayerType > 3)
	{
		stunPlayerType = 3;
	}
	
	int stunPlayerAttackIndexes = kv.GetNum("player_stun_attack_indexs", 1);
	if (stunPlayerAttackIndexes < 0)
	{
		stunPlayerAttackIndexes = 1;
	}
	
	float stunPlayerDurationNormal = kv.GetFloat("player_stun_duration");
	float stunPlayerDurationEasy = kv.GetFloat("player_stun_duration_easy", stunPlayerDurationNormal);
	float stunPlayerDurationHard = kv.GetFloat("player_stun_duration_hard", stunPlayerDurationNormal);
	float stunPlayerDurationInsane = kv.GetFloat("player_stun_duration_insane", stunPlayerDurationHard);
	float stunPlayerDurationNightmare = kv.GetFloat("player_stun_duration_nightmare", stunPlayerDurationInsane);
	float stunPlayerDurationApollyon = kv.GetFloat("player_stun_duration_apollyon", stunPlayerDurationNightmare);
	
	float stunPlayerSlowdownNormal = kv.GetFloat("player_stun_slowdown");
	if (stunPlayerSlowdownNormal > 1.0)
	{
		stunPlayerSlowdownNormal = 1.0;
	}
	if (stunPlayerSlowdownNormal < 0.0)
	{
		stunPlayerSlowdownNormal = 0.0;
	}
	float stunPlayerSlowdownEasy = kv.GetFloat("player_stun_slowdown_easy", stunPlayerSlowdownNormal);
	if (stunPlayerSlowdownEasy > 1.0)
	{
		stunPlayerSlowdownEasy = 1.0;
	}
	if (stunPlayerSlowdownEasy < 0.0)
	{
		stunPlayerSlowdownEasy = 0.0;
	}
	float stunPlayerSlowdownHard = kv.GetFloat("player_stun_slowdown_hard", stunPlayerSlowdownNormal);
	if (stunPlayerSlowdownHard > 1.0)
	{
		stunPlayerSlowdownHard = 1.0;
	}
	if (stunPlayerSlowdownHard < 0.0)
	{
		stunPlayerSlowdownHard = 0.0;
	}
	float stunPlayerSlowdownInsane = kv.GetFloat("player_stun_slowdown_insane", stunPlayerSlowdownHard);
	if (stunPlayerSlowdownInsane > 1.0)
	{
		stunPlayerSlowdownInsane = 1.0;
	}
	if (stunPlayerSlowdownInsane < 0.0)
	{
		stunPlayerSlowdownInsane = 0.0;
	}
	float stunPlayerSlowdownNightmare = kv.GetFloat("player_stun_slowdown_nightmare", stunPlayerSlowdownInsane);
	if (stunPlayerSlowdownNightmare > 1.0)
	{
		stunPlayerSlowdownNightmare = 1.0;
	}
	if (stunPlayerSlowdownNightmare < 0.0)
	{
		stunPlayerSlowdownNightmare = 0.0;
	}
	float stunPlayerSlowdownApollyon = kv.GetFloat("player_stun_slowdown_apollyon", stunPlayerSlowdownNightmare);
	if (stunPlayerSlowdownApollyon > 1.0)
	{
		stunPlayerSlowdownApollyon = 1.0;
	}
	if (stunPlayerSlowdownApollyon < 0.0)
	{
		stunPlayerSlowdownApollyon = 0.0;
	}

	bool stunPlayerParticleBeam = view_as<bool>(kv.GetNum("player_stun_beam_particle"));

	bool bleedPlayerAdvanced = view_as<bool>(kv.GetNum("player_bleed_on_hit"));
	
	int bleedPlayerAttackIndexes = kv.GetNum("player_bleed_attack_indexs", 1);
	if (bleedPlayerAttackIndexes < 0)
	{
		bleedPlayerAttackIndexes = 1;
	}
	
	float bleedPlayerDurationNormal = kv.GetFloat("player_bleed_duration");
	float bleedPlayerDurationEasy = kv.GetFloat("player_bleed_duration_easy", bleedPlayerDurationNormal);
	float bleedPlayerDurationHard = kv.GetFloat("player_bleed_duration_hard", bleedPlayerDurationNormal);
	float bleedPlayerDurationInsane = kv.GetFloat("player_bleed_duration_insane", bleedPlayerDurationHard);
	float bleedPlayerDurationNightmare = kv.GetFloat("player_bleed_duration_nightmare", bleedPlayerDurationInsane);
	float bleedPlayerDurationApollyon = kv.GetFloat("player_bleed_duration_apollyon", bleedPlayerDurationNightmare);

	bool eletricPlayerAdvanced = view_as<bool>(kv.GetNum("player_electric_slow_on_hit"));
	
	int eletricPlayerAttackIndexes = kv.GetNum("player_electrocute_attack_indexs", 1);
	if (eletricPlayerAttackIndexes < 0)
	{
		eletricPlayerAttackIndexes = 1;
	}
	
	float eletricPlayerDurationNormal = kv.GetFloat("player_electric_slow_duration");
	float eletricPlayerDurationEasy = kv.GetFloat("player_electric_slow_duration_easy", eletricPlayerDurationNormal);
	float eletricPlayerDurationHard = kv.GetFloat("player_electric_slow_duration_hard", eletricPlayerDurationNormal);
	float eletricPlayerDurationInsane = kv.GetFloat("player_electric_slow_duration_insane", eletricPlayerDurationHard);
	float eletricPlayerDurationNightmare = kv.GetFloat("player_electric_slow_duration_nightmare", eletricPlayerDurationInsane);
	float eletricPlayerDurationApollyon = kv.GetFloat("player_electric_slow_duration_apollyon", eletricPlayerDurationNightmare);
	
	float eletricPlayerSlowdownNormal = kv.GetFloat("player_electric_slow_slowdown");
	if (eletricPlayerSlowdownNormal > 1.0)
	{
		eletricPlayerSlowdownNormal = 1.0;
	}
	if (eletricPlayerSlowdownNormal < 0.0)
	{
		eletricPlayerSlowdownNormal = 0.0;
	}
	float eletricPlayerSlowdownEasy = kv.GetFloat("player_electric_slow_slowdown_easy", eletricPlayerSlowdownNormal);
	if (eletricPlayerSlowdownEasy > 1.0)
	{
		eletricPlayerSlowdownEasy = 1.0;
	}
	if (eletricPlayerSlowdownEasy < 0.0)
	{
		eletricPlayerSlowdownEasy = 0.0;
	}
	float eletricPlayerSlowdownHard = kv.GetFloat("player_electric_slow_slowdown_hard", eletricPlayerSlowdownNormal);
	if (eletricPlayerSlowdownHard > 1.0)
	{
		eletricPlayerSlowdownHard = 1.0;
	}
	if (eletricPlayerSlowdownHard < 0.0)
	{
		eletricPlayerSlowdownHard = 0.0;
	}
	float eletricPlayerSlowdownInsane = kv.GetFloat("player_electric_slow_slowdown_insane", eletricPlayerSlowdownHard);
	if (eletricPlayerSlowdownInsane > 1.0)
	{
		eletricPlayerSlowdownInsane = 1.0;
	}
	if (eletricPlayerSlowdownInsane < 0.0)
	{
		eletricPlayerSlowdownInsane = 0.0;
	}
	float eletricPlayerSlowdownNightmare = kv.GetFloat("player_electric_slow_slowdown_nightmare", eletricPlayerSlowdownInsane);
	if (eletricPlayerSlowdownNightmare > 1.0)
	{
		eletricPlayerSlowdownNightmare = 1.0;
	}
	if (eletricPlayerSlowdownNightmare < 0.0)
	{
		eletricPlayerSlowdownNightmare = 0.0;
	}
	float eletricPlayerSlowdownApollyon = kv.GetFloat("player_electric_slow_slowdown_apollyon", eletricPlayerSlowdownNightmare);
	if (eletricPlayerSlowdownApollyon > 1.0)
	{
		eletricPlayerSlowdownApollyon = 1.0;
	}
	if (eletricPlayerSlowdownApollyon < 0.0)
	{
		eletricPlayerSlowdownApollyon = 0.0;
	}

	bool electricPlayerParticleBeam = view_as<bool>(kv.GetNum("player_electric_beam_particle"));
	
	bool smitePlayerAdvanced = view_as<bool>(kv.GetNum("player_smite_on_hit"));
	
	int smiteAttackIndexes = kv.GetNum("player_smite_attack_indexs", 1);
	if (smiteAttackIndexes < 0)
	{
		smiteAttackIndexes = 1;
	}

	float smiteDamage = kv.GetFloat("player_smite_damage", 9001.0);
	int smiteDamageType = kv.GetNum("player_smite_damage_type", 1048576); //Critical cause we're mean
	int smiteColorR = kv.GetNum("player_smite_color_r", 255);
	int smiteColorG = kv.GetNum("player_smite_color_g", 255);
	int smiteColorB = kv.GetNum("player_smite_color_b", 255);
	int smiteColorTrans = kv.GetNum("player_smite_transparency", 255);

	bool smitePlayerMessage = view_as<bool>(kv.GetNum("player_smite_message"));

	bool xenobladeCombo = view_as<bool>(kv.GetNum("xenoblade_chain_art_combo"));
	float xenobladeBreakDuration = kv.GetFloat("xenoblade_break_duration");
	float xenobladeToppleDuration = kv.GetFloat("xenoblade_topple_duration");
	float xenobladeToppleSlowdown = kv.GetFloat("xenoblade_topple_slowdown", 0.5);
	float xenobladeDazeDuration = kv.GetFloat("xenoblade_daze_duration");

	int projectileType = kv.GetNum("projectile_type", SF2BossProjectileType_Fireball);
	
	bool damageParticlesEnabled = view_as<bool>(kv.GetNum("damage_particle_effect_enabled"));
	float damageParticleVolume = kv.GetFloat("damage_particle_effect_volume");
	int damageParticlePitch = kv.GetNum("damage_particle_effect_pitch");
	if (damageParticlePitch < 1)
	{
		damageParticlePitch = 1;
	}
	if (damageParticlePitch > 255)
	{
		damageParticlePitch = 255;
	}
	
	bool shockwaveEnabled = view_as<bool>(kv.GetNum("shockwave"));
	
	float shockwaveHeight = kv.GetFloat("shockwave_height", 64.0);
	float shockwaveHeightEasy = kv.GetFloat("shockwave_height_easy", shockwaveHeight);
	float shockwaveHeightHard = kv.GetFloat("shockwave_height_hard", shockwaveHeight);
	float shockwaveHeightInsane = kv.GetFloat("shockwave_height_insane", shockwaveHeightHard);
	float shockwaveHeightNightmare = kv.GetFloat("shockwave_height_nightmare", shockwaveHeightInsane);
	float shockwaveHeightApollyon = kv.GetFloat("shockwave_height_apollyon", shockwaveHeightNightmare);
	
	float shockwaveRange = kv.GetFloat("shockwave_range", 200.0);
	float shockwaveRangeEasy = kv.GetFloat("shockwave_range_easy", shockwaveRange);
	float shockwaveRangeHard = kv.GetFloat("shockwave_range_hard", shockwaveRange);
	float shockwaveRangeInsane = kv.GetFloat("shockwave_range_insane", shockwaveRangeHard);
	float shockwaveRangeNightmare = kv.GetFloat("shockwave_range_nightmare", shockwaveRangeInsane);
	float shockwaveRangeApollyon = kv.GetFloat("shockwave_range_apollyon", shockwaveRangeNightmare);
	
	float shockwaveDrain = kv.GetFloat("shockwave_drain", 0.2);
	float shockwaveDrainEasy = kv.GetFloat("shockwave_drain_easy", shockwaveDrain);
	float shockwaveDrainHard = kv.GetFloat("shockwave_drain_hard", shockwaveDrain);
	float shockwaveDrainInsane = kv.GetFloat("shockwave_drain_insane", shockwaveDrainHard);
	float shockwaveDrainNightmare = kv.GetFloat("shockwave_drain_nightmare", shockwaveDrainInsane);
	float shockwaveDrainApollyon = kv.GetFloat("shockwave_drain_apollyon", shockwaveDrainNightmare);

	float shockwaveForce = kv.GetFloat("shockwave_force", 6.0);
	float shockwaveForceEasy = kv.GetFloat("shockwave_force_easy", shockwaveForce);
	float shockwaveForceHard = kv.GetFloat("shockwave_force_hard", shockwaveForce);
	float shockwaveForceInsane = kv.GetFloat("shockwave_force_insane", shockwaveForceHard);
	float shockwaveForceNightmare = kv.GetFloat("shockwave_force_nightmare", shockwaveForceInsane);
	float shockwaveForceApollyon = kv.GetFloat("shockwave_force_apollyon", shockwaveForceNightmare);
	
	bool shockwaveStunEnabled = view_as<bool>(kv.GetNum("shockwave_stun"));
	
	float shockwaveStunDuration = kv.GetFloat("shockwave_stun_duration", 2.0);
	float shockwaveStunDurationEasy = kv.GetFloat("shockwave_stun_duration_easy", shockwaveStunDuration);
	float shockwaveStunDurationHard = kv.GetFloat("shockwave_stun_duration_hard", shockwaveStunDuration);
	float shockwaveStunDurationInsane = kv.GetFloat("shockwave_stun_duration_insane", shockwaveStunDurationHard);
	float shockwaveStunDurationNightmare = kv.GetFloat("shockwave_stun_duration_nightmare", shockwaveStunDurationInsane);
	float shockwaveStunDurationApollyon = kv.GetFloat("shockwave_stun_duration_apollyon", shockwaveStunDurationNightmare);
	
	float shockwaveStunSlowdown = kv.GetFloat("shockwave_stun_slowdown", 0.7);
	float shockwaveStunSlowdownEasy = kv.GetFloat("shockwave_stun_slowdown_easy", shockwaveStunSlowdown);
	float shockwaveStunSlowdownHard = kv.GetFloat("shockwave_stun_slowdown_hard", shockwaveStunSlowdown);
	float shockwaveStunSlowdownInsane = kv.GetFloat("shockwave_stun_slowdown_insane", shockwaveStunSlowdownHard);
	float shockwaveStunSlowdownNightmare = kv.GetFloat("shockwave_stun_slowdown_nightmare", shockwaveStunSlowdownInsane);
	float shockwaveStunSlowdownApollyon = kv.GetFloat("shockwave_stun_slowdown_apollyon", shockwaveStunSlowdownNightmare);
	
	int shockwaveAttackIndexes = kv.GetNum("shockwave_attack_index", 1);
	if (shockwaveAttackIndexes < 1)
	{
		shockwaveAttackIndexes = 1;
	}

	float shockwaveWidth1 = kv.GetFloat("shockwave_width_1", 40.0);
	float shockwaveWidth2 = kv.GetFloat("shockwave_width_2", 20.0);
	float shockwaveAmplitude = kv.GetFloat("shockwave_amplitude", 5.0);

	bool earthquakeFootstepsEnabled = view_as<bool>(kv.GetNum("earthquake_footsteps"));

	float earthquakeFootstepsAmplitude = kv.GetFloat("earthquake_footsteps_amplitude", 5.0);
	float earthquakeFootstepsFrequency = kv.GetFloat("earthquake_footsteps_frequency", 25.0);
	float earthquakeFootstepsDuration = kv.GetFloat("earthquake_footsteps_duration", 1.0);
	float earthquakeFootstepsRadius = kv.GetFloat("earthquake_footsteps_radius", 1000.0);
	bool earthquakeFootstepsAirShake = view_as<bool>(kv.GetNum("earthquake_footsteps_airshake"));
	
	bool trapsEnabled = view_as<bool>(kv.GetNum("traps_enabled"));
	
	int trapType = kv.GetNum("trap_type", 0);
	
	float trapSpawnCooldown = kv.GetFloat("trap_spawn_cooldown", 8.0);
	float trapSpawnCooldownEasy = kv.GetFloat("trap_spawn_cooldown_easy", trapSpawnCooldown);
	float trapSpawnCooldownHard = kv.GetFloat("trap_spawn_cooldown_hard", trapSpawnCooldown);
	float trapSpawnCooldownInsane = kv.GetFloat("trap_spawn_cooldown_insane", trapSpawnCooldownHard);
	float trapSpawnCooldownNightmare = kv.GetFloat("trap_spawn_cooldown_nightmare", trapSpawnCooldownInsane);
	float trapSpawnCooldownApollyon = kv.GetFloat("trap_spawn_cooldown_apollyon", trapSpawnCooldownNightmare);

	bool autoChaseEnabled = view_as<bool>(kv.GetNum("auto_chase_enabled", 0));

	int autoChaseCount = kv.GetNum("auto_chase_count", 30);
	if (autoChaseCount < 0)
	{
		autoChaseCount = 0;
	}
	int autoChaseCountEasy = kv.GetNum("auto_chase_count_easy", autoChaseCount);
	if (autoChaseCountEasy < 0)
	{
		autoChaseCountEasy = 0;
	}
	int autoChaseCountHard = kv.GetNum("auto_chase_count_hard", autoChaseCount);
	if (autoChaseCountHard < 0)
	{
		autoChaseCountHard = 0;
	}
	int autoChaseCountInsane = kv.GetNum("auto_chase_count_insane", autoChaseCountHard);
	if (autoChaseCountInsane < 0)
	{
		autoChaseCountInsane = 0;
	}
	int autoChaseCountNightmare = kv.GetNum("auto_chase_count_nightmare", autoChaseCountInsane);
	if (autoChaseCountNightmare < 0)
	{
		autoChaseCountNightmare = 0;
	}
	int autoChaseCountApollyon = kv.GetNum("auto_chase_count_apollyon", autoChaseCountNightmare);
	if (autoChaseCountApollyon < 0)
	{
		autoChaseCountApollyon = 0;
	}

	int autoChaseAdd = kv.GetNum("sound_alert_add", 0);
	if (autoChaseAdd < 0)
	{
		autoChaseAdd = 0;
	}
	int autoChaseAddEasy = kv.GetNum("sound_alert_add_easy", autoChaseAdd);
	if (autoChaseAddEasy < 0)
	{
		autoChaseAddEasy = 0;
	}
	int autoChaseAddHard = kv.GetNum("sound_alert_add_hard", autoChaseAdd);
	if (autoChaseAddHard < 0)
	{
		autoChaseAddHard = 0;
	}
	int autoChaseAddInsane = kv.GetNum("sound_alert_add_insane", autoChaseAddHard);
	if (autoChaseAddInsane < 0)
	{
		autoChaseAddInsane = 0;
	}
	int autoChaseAddNightmare = kv.GetNum("sound_alert_add_nightmare", autoChaseAddInsane);
	if (autoChaseAddNightmare < 0)
	{
		autoChaseAddNightmare = 0;
	}
	int autoChaseAddApollyon = kv.GetNum("sound_alert_add_apollyon", autoChaseAddNightmare);
	if (autoChaseAddApollyon < 0)
	{
		autoChaseAddApollyon = 0;
	}

	int autoChaseAddFootsteps = kv.GetNum("sound_alert_add_footsteps", 2);
	if (autoChaseAddFootsteps < 0)
	{
		autoChaseAddFootsteps = 0;
	}
	int autoChaseAddFootstepsEasy = kv.GetNum("sound_alert_add_footsteps_easy", autoChaseAddFootsteps);
	if (autoChaseAddFootstepsEasy < 0)
	{
		autoChaseAddFootstepsEasy = 0;
	}
	int autoChaseAddFootstepsHard = kv.GetNum("sound_alert_add_footsteps_hard", autoChaseAddFootsteps);
	if (autoChaseAddFootstepsHard < 0)
	{
		autoChaseAddFootstepsHard = 0;
	}
	int autoChaseAddFootstepsInsane = kv.GetNum("sound_alert_add_footsteps_insane", autoChaseAddFootstepsHard);
	if (autoChaseAddFootstepsInsane < 0)
	{
		autoChaseAddFootstepsInsane = 0;
	}
	int autoChaseAddFootstepsNightmare = kv.GetNum("sound_alert_add_footsteps_nightmare", autoChaseAddFootstepsInsane);
	if (autoChaseAddFootstepsNightmare < 0)
	{
		autoChaseAddFootstepsNightmare = 0;
	}
	int autoChaseAddFootstepsApollyon = kv.GetNum("sound_alert_add_footsteps_apollyon", autoChaseAddFootstepsNightmare);
	if (autoChaseAddFootstepsApollyon < 0)
	{
		autoChaseAddFootstepsApollyon = 0;
	}

	int autoChaseAddVoice = kv.GetNum("sound_alert_add_voice", 8);
	if (autoChaseAddVoice < 0)
	{
		autoChaseAddVoice = 0;
	}
	int autoChaseAddVoiceEasy = kv.GetNum("sound_alert_add_voice_easy", autoChaseAddVoice);
	if (autoChaseAddVoiceEasy < 0)
	{
		autoChaseAddVoiceEasy = 0;
	}
	int autoChaseAddVoiceHard = kv.GetNum("sound_alert_add_voice_hard", autoChaseAddVoice);
	if (autoChaseAddVoiceHard < 0)
	{
		autoChaseAddVoiceHard = 0;
	}
	int autoChaseAddVoiceInsane = kv.GetNum("sound_alert_add_voice_insane", autoChaseAddVoiceHard);
	if (autoChaseAddVoiceInsane < 0)
	{
		autoChaseAddVoiceInsane = 0;
	}
	int autoChaseAddVoiceNightmare = kv.GetNum("sound_alert_add_voice_nightmare", autoChaseAddVoiceInsane);
	if (autoChaseAddVoiceNightmare < 0)
	{
		autoChaseAddVoiceNightmare = 0;
	}
	int autoChaseAddVoiceApollyon = kv.GetNum("sound_alert_add_voice_apollyon", autoChaseAddVoiceNightmare);
	if (autoChaseAddVoiceApollyon < 0)
	{
		autoChaseAddVoiceApollyon = 0;
	}

	int autoChaseAddWeapon = kv.GetNum("sound_alert_add_weapon", 4);
	if (autoChaseAddWeapon < 0)
	{
		autoChaseAddWeapon = 0;
	}
	int autoChaseAddWeaponEasy = kv.GetNum("sound_alert_add_weapon_easy", autoChaseAddWeapon);
	if (autoChaseAddWeaponEasy < 0)
	{
		autoChaseAddWeaponEasy = 0;
	}
	int autoChaseAddWeaponHard = kv.GetNum("sound_alert_add_weapon_hard", autoChaseAddWeapon);
	if (autoChaseAddWeaponHard < 0)
	{
		autoChaseAddWeaponHard = 0;
	}
	int autoChaseAddWeaponInsane = kv.GetNum("sound_alert_add_weapon_insane", autoChaseAddWeaponHard);
	if (autoChaseAddWeaponInsane < 0)
	{
		autoChaseAddWeaponInsane = 0;
	}
	int autoChaseAddWeaponNightmare = kv.GetNum("sound_alert_add_weapon_nightmare", autoChaseAddWeaponInsane);
	if (autoChaseAddWeaponNightmare < 0)
	{
		autoChaseAddWeaponNightmare = 0;
	}
	int autoChaseAddWeaponApollyon = kv.GetNum("sound_alert_add_weapon_apollyon", autoChaseAddWeaponNightmare);
	if (autoChaseAddWeaponApollyon < 0)
	{
		autoChaseAddWeaponApollyon = 0;
	}

	bool autoChaseSprinters = view_as<bool>(kv.GetNum("auto_chase_sprinters", 0));

	bool chasesEndlessly = view_as<bool>(KvGetNum(kv,"boss_chases_endlessly", 0));
	
	bool bSelfHeal = view_as<bool>(kv.GetNum("self_heal_enabled", 0));
	float healthPercentageToHeal = kv.GetFloat("health_percentage_to_heal", 0.35);
	if (healthPercentageToHeal < 0.0)
	{
		healthPercentageToHeal = 0.0;
	}
	if (healthPercentageToHeal > 0.999)
	{
		healthPercentageToHeal = 0.999;
	}
	float healPercentageOne = kv.GetFloat("heal_percentage_one", 0.75);
	if (healPercentageOne < 0.0)
	{
		healPercentageOne = 0.0;
	}
	if (healPercentageOne > 1.0)
	{
		healPercentageOne = 1.0;
	}
	float healPercentageTwo = kv.GetFloat("heal_percentage_two", 0.5);
	if (healPercentageTwo < 0.0)
	{
		healPercentageTwo = 0.0;
	}
	if (healPercentageTwo > 1.0)
	{
		healPercentageTwo = 1.0;
	}
	float healPercentageThree = kv.GetFloat("heal_percentage_three", 0.25);
	if (healPercentageThree < 0.0)
	{
		healPercentageThree = 0.0;
	}
	if (healPercentageThree > 1.0)
	{
		healPercentageThree = 1.0;
	}

	bool crawlingEnabled = view_as<bool>(kv.GetNum("crawling_enabled"));
	float crawlSpeedMultiplier = kv.GetFloat("crawl_multiplier", 0.5);
	float crawlSpeedMultiplierEasy = kv.GetFloat("crawl_multiplier", crawlSpeedMultiplier);
	float crawlSpeedMultiplierHard = kv.GetFloat("crawl_multiplier", crawlSpeedMultiplier);
	float crawlSpeedMultiplierInsane = kv.GetFloat("crawl_multiplier", crawlSpeedMultiplierHard);
	float crawlSpeedMultiplierNightmare = kv.GetFloat("crawl_multiplier", crawlSpeedMultiplierInsane);
	float crawlSpeedMultiplierApollyon = kv.GetFloat("crawl_multiplier", crawlSpeedMultiplierNightmare);

	bool chaseOnLook = view_as<bool>(kv.GetNum("chase_upon_look"));

	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("difficulty_affects_animations")), ChaserProfileData_DifficultyAffectsAnimations);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultWalkSpeed, ChaserProfileData_WalkSpeedNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossWalkSpeedEasy, ChaserProfileData_WalkSpeedEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossWalkSpeedHard, ChaserProfileData_WalkSpeedHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossWalkSpeedInsane, ChaserProfileData_WalkSpeedInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossWalkSpeedNightmare, ChaserProfileData_WalkSpeedNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossWalkSpeedApollyon, ChaserProfileData_WalkSpeedApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultMaxWalkSpeed, ChaserProfileData_MaxWalkSpeedNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossMaxWalkSpeedEasy, ChaserProfileData_MaxWalkSpeedEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossMaxWalkSpeedHard, ChaserProfileData_MaxWalkSpeedHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossMaxWalkSpeedInsane, ChaserProfileData_MaxWalkSpeedInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossMaxWalkSpeedNightmare, ChaserProfileData_MaxWalkSpeedNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossMaxWalkSpeedApollyon, ChaserProfileData_MaxWalkSpeedApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetime, ChaserProfileData_SearchAlertGracetime);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetimeEasy, ChaserProfileData_SearchAlertGracetimeEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetimeHard, ChaserProfileData_SearchAlertGracetimeHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetimeInsane, ChaserProfileData_SearchAlertGracetimeInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetimeNightmare, ChaserProfileData_SearchAlertGracetimeNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertGracetimeApollyon, ChaserProfileData_SearchAlertGracetimeApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDuration, ChaserProfileData_SearchAlertDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDurationEasy, ChaserProfileData_SearchAlertDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDurationHard, ChaserProfileData_SearchAlertDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDurationInsane, ChaserProfileData_SearchAlertDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDurationNightmare, ChaserProfileData_SearchAlertDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, alertDurationApollyon, ChaserProfileData_SearchAlertDurationApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDuration, ChaserProfileData_SearchChaseDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDurationEasy, ChaserProfileData_SearchChaseDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDurationHard, ChaserProfileData_SearchChaseDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDurationInsane, ChaserProfileData_SearchChaseDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDurationNightmare, ChaserProfileData_SearchChaseDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, chaseDurationApollyon, ChaserProfileData_SearchChaseDurationApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMin, ChaserProfileData_SearchWanderRangeMin);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMinEasy, ChaserProfileData_SearchWanderRangeMinEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMinHard, ChaserProfileData_SearchWanderRangeMinHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMinInsane, ChaserProfileData_SearchWanderRangeMinInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMinNightmare, ChaserProfileData_SearchWanderRangeMinNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMinApollyon, ChaserProfileData_SearchWanderRangeMinApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMax, ChaserProfileData_SearchWanderRangeMax);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMaxEasy, ChaserProfileData_SearchWanderRangeMaxEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMaxHard, ChaserProfileData_SearchWanderRangeMaxHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMaxInsane, ChaserProfileData_SearchWanderRangeMaxInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMaxNightmare, ChaserProfileData_SearchWanderRangeMaxNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderRangeMaxApollyon, ChaserProfileData_SearchWanderRangeMaxApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMin, ChaserProfileData_SearchWanderTimeMin);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMinEasy, ChaserProfileData_SearchWanderTimeMinEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMinHard, ChaserProfileData_SearchWanderTimeMinHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMinInsane, ChaserProfileData_SearchWanderTimeMinInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMinNightmare, ChaserProfileData_SearchWanderTimeMinNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMinApollyon, ChaserProfileData_SearchWanderTimeMinApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMax, ChaserProfileData_SearchWanderTimeMax);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMaxEasy, ChaserProfileData_SearchWanderTimeMaxEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMaxHard, ChaserProfileData_SearchWanderTimeMaxHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMaxInsane, ChaserProfileData_SearchWanderTimeMaxInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMaxNightmare, ChaserProfileData_SearchWanderTimeMaxNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, wanderTimeMaxApollyon, ChaserProfileData_SearchWanderTimeMaxApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, wakeRange, ChaserProfileData_WakeRadius);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, canBeStunned, ChaserProfileData_CanBeStunned);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunDuration, ChaserProfileData_StunDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunCooldown, ChaserProfileData_StunCooldown);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunHealth, ChaserProfileData_StunHealth);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunHealthPerPlayer, ChaserProfileData_StunHealthPerPlayer);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunTakeDamageFromFlashlight, ChaserProfileData_CanBeStunnedByFlashlight);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunFlashlightDamage, ChaserProfileData_StunFlashlightDamage);
	g_ChaserProfileData.Set(uniqueProfileIndex, itemDrop, ChaserProfileData_ItemDropOnStun);
	g_ChaserProfileData.Set(uniqueProfileIndex, itemDropType, ChaserProfileData_ItemDropTypeStun);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("chase_initial_on_stun")), ChaserProfileData_ChaseInitialOnStun);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, keyDrop, ChaserProfileData_KeyDrop);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, canCloak, ChaserProfileData_CanCloak);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultCloakCooldown, ChaserProfileData_CloakCooldownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakCooldownEasy, ChaserProfileData_CloakCooldownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakCooldownHard, ChaserProfileData_CloakCooldownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakCooldownInsane, ChaserProfileData_CloakCooldownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakCooldownNightmare, ChaserProfileData_CloakCooldownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakCooldownApollyon, ChaserProfileData_CloakCooldownApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultCloakRange, ChaserProfileData_CloakRangeNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakRangeEasy, ChaserProfileData_CloakRangeEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakRangeHard, ChaserProfileData_CloakRangeHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakRangeInsane, ChaserProfileData_CloakRangeInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakRangeNightmare, ChaserProfileData_CloakRangeNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakRangeApollyon, ChaserProfileData_CloakRangeApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultDecloakRange, ChaserProfileData_CloakDecloakRangeNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDecloakRangeEasy, ChaserProfileData_CloakDecloakRangeEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDecloakRangeHard, ChaserProfileData_CloakDecloakRangeHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDecloakRangeInsane, ChaserProfileData_CloakDecloakRangeInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDecloakRangeNightmare, ChaserProfileData_CloakDecloakRangeNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDecloakRangeApollyon, ChaserProfileData_CloakDecloakRangeApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultCloakDuration, ChaserProfileData_CloakDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakDurationEasy, ChaserProfileData_CloakDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakDurationHard, ChaserProfileData_CloakDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakDurationInsane, ChaserProfileData_CloakDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakDurationNightmare, ChaserProfileData_CloakDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakDurationApollyon, ChaserProfileData_CloakDurationApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bossDefaultCloakSpeedMultiplier, ChaserProfileData_CloakSpeedMultiplierNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakSpeedMultiplierEasy, ChaserProfileData_CloakSpeedMultiplierEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakSpeedMultiplierHard, ChaserProfileData_CloakSpeedMultiplierHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakSpeedMultiplierInsane, ChaserProfileData_CloakSpeedMultiplierInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakSpeedMultiplierNightmare, ChaserProfileData_CloakSpeedMultiplierNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bossCloakSpeedMultiplierApollyon, ChaserProfileData_CloakSpeedMultiplierApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileEnable, ChaserProfileData_ProjectileEnable);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, rocketCritical, ChaserProfileData_CriticlaRockets);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, useShootGesture, ChaserProfileData_UseShootGesture);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, enableProjectileClips, ChaserProfileData_ProjectileClipEnable);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, enableChargeUpProjectiles, ChaserProfileData_UseChargeUpProjectiles);

	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMin, ChaserProfileData_ProjectileCooldownMinNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMinEasy, ChaserProfileData_ProjectileCooldownMinEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMinHard, ChaserProfileData_ProjectileCooldownMinHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMinInsane, ChaserProfileData_ProjectileCooldownMinInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMinNightmare, ChaserProfileData_ProjectileCooldownMinNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMinApollyon, ChaserProfileData_ProjectileCooldownMinApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMax, ChaserProfileData_ProjectileCooldownMaxNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMaxEasy, ChaserProfileData_ProjectileCooldownMaxEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMaxHard, ChaserProfileData_ProjectileCooldownMaxHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMaxInsane, ChaserProfileData_ProjectileCooldownMaxInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMaxNightmare, ChaserProfileData_ProjectileCooldownMaxNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCooldownMaxApollyon, ChaserProfileData_ProjectileCooldownMaxApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCount, ChaserProfileData_ProjectileCount);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCountEasy, ChaserProfileData_ProjectileCountEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCountHard, ChaserProfileData_ProjectileCountHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCountInsane, ChaserProfileData_ProjectileCountInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCountNightmare, ChaserProfileData_ProjectileCountNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileCountApollyon, ChaserProfileData_ProjectileCountApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDuration, ChaserProfileData_IceballSlowdownDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDurationEasy, ChaserProfileData_IceballSlowdownDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDurationHard, ChaserProfileData_IceballSlowdownDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDurationInsane, ChaserProfileData_IceballSlowdownDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDurationNightmare, ChaserProfileData_IceballSlowdownDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownDurationApollyon, ChaserProfileData_IceballSlowdownDurationApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercent, ChaserProfileData_IceballSlowdownPercentNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercentEasy, ChaserProfileData_IceballSlowdownPercentEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercentHard, ChaserProfileData_IceballSlowdownPercentHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercentInsane, ChaserProfileData_IceballSlowdownPercentInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercentNightmare, ChaserProfileData_IceballSlowdownPercentNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, iceballSlowdownPercentApollyon, ChaserProfileData_IceballSlowdownPercentApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeed, ChaserProfileData_ProjectileSpeedNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeedEasy, ChaserProfileData_ProjectileSpeedEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeedHard, ChaserProfileData_ProjectileSpeedHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeedInsane, ChaserProfileData_ProjectileSpeedInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeedNightmare, ChaserProfileData_ProjectileSpeedNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileSpeedApollyon, ChaserProfileData_ProjectileSpeedApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamage, ChaserProfileData_ProjectileDamageNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamageEasy, ChaserProfileData_ProjectileDamageEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamageHard, ChaserProfileData_ProjectileDamageHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamageInsane, ChaserProfileData_ProjectileDamageInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamageNightmare, ChaserProfileData_ProjectileDamageNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDamageApollyon, ChaserProfileData_ProjectileDamageApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadius, ChaserProfileData_ProjectileRadiusNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadiusEasy, ChaserProfileData_ProjectileRadiusEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadiusHard, ChaserProfileData_ProjectileRadiusHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadiusInsane, ChaserProfileData_ProjectileRadiusInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadiusNightmare, ChaserProfileData_ProjectileRadiusNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileRadiusApollyon, ChaserProfileData_ProjectileRadiusApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviation, ChaserProfileData_ProjectileDeviation);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviationEasy, ChaserProfileData_ProjectileDeviationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviationHard, ChaserProfileData_ProjectileDeviationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviationInsane, ChaserProfileData_ProjectileDeviationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviationNightmare, ChaserProfileData_ProjectileDeviationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileDeviationApollyon, ChaserProfileData_ProjectileDeviationApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileType, ChaserProfileData_ProjectileType);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClips, ChaserProfileData_ProjectileClipNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClipsEasy, ChaserProfileData_ProjectileClipEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClipsHard, ChaserProfileData_ProjectileClipHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClipsInsane, ChaserProfileData_ProjectileClipInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClipsNightmare, ChaserProfileData_ProjectileClipNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileClipsApollyon, ChaserProfileData_ProjectileClipApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReload, ChaserProfileData_ProjectileReloadTimeNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReloadEasy, ChaserProfileData_ProjectileReloadTimeEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReloadHard, ChaserProfileData_ProjectileReloadTimeHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReloadInsane, ChaserProfileData_ProjectileReloadTimeInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReloadNightmare, ChaserProfileData_ProjectileReloadTimeNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectilesReloadApollyon, ChaserProfileData_ProjectileReloadTimeApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDuration, ChaserProfileData_ProjectileChargeUpNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDurationEasy, ChaserProfileData_ProjectileChargeUpEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDurationHard, ChaserProfileData_ProjectileChargeUpHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDurationInsane, ChaserProfileData_ProjectileChargeUpInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDurationNightmare, ChaserProfileData_ProjectileChargeUpNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, projectileChargeUpDurationApollyon, ChaserProfileData_ProjectileChargeUpApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, advancedDamageEffectsEnabled, ChaserProfileData_AdvancedDamageEffectsEnabled);
	g_ChaserProfileData.Set(uniqueProfileIndex, advancedDamageEffectsRandom, ChaserProfileData_AdvancedDamageEffectsRandom);
	g_ChaserProfileData.Set(uniqueProfileIndex, advancedDamageEffectsParticles, ChaserProfileData_AdvancedDamageEffectsParticles);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectAttackIndexes, ChaserProfileData_RandomAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationEasy, ChaserProfileData_RandomAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationNormal, ChaserProfileData_RandomAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationHard, ChaserProfileData_RandomAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationInsane, ChaserProfileData_RandomAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationNightmare, ChaserProfileData_RandomAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectDurationApollyon, ChaserProfileData_RandomAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownEasy, ChaserProfileData_RandomAdvancedSlowdownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownNormal, ChaserProfileData_RandomAdvancedSlowdownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownHard, ChaserProfileData_RandomAdvancedSlowdownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownInsane, ChaserProfileData_RandomAdvancedSlowdownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownNightmare, ChaserProfileData_RandomAdvancedSlowdownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomEffectSlowdownApollyon, ChaserProfileData_RandomAdvancedSlowdownApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, randomStunType, ChaserProfileData_RandomAdvancedStunType);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerAdvanced, ChaserProfileData_EnableJarateAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerAttackIndexes, ChaserProfileData_JarateAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationEasy, ChaserProfileData_JarateAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationNormal, ChaserProfileData_JarateAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationHard, ChaserProfileData_JarateAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationInsane, ChaserProfileData_JarateAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationNightmare, ChaserProfileData_JarateAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerDurationApollyon, ChaserProfileData_JarateAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, jaratePlayerParticleBeam, ChaserProfileData_JarateAdvancedBeamParticle);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerAdvanced, ChaserProfileData_EnableMilkAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerAttackIndexes, ChaserProfileData_MilkAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationEasy, ChaserProfileData_MilkAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationNormal, ChaserProfileData_MilkAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationHard, ChaserProfileData_MilkAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationInsane, ChaserProfileData_MilkAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationNightmare, ChaserProfileData_MilkAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerDurationApollyon, ChaserProfileData_MilkAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, milkPlayerParticleBeam, ChaserProfileData_MilkAdvancedBeamParticle);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerAdvanced, ChaserProfileData_EnableGasAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerAttackIndexes, ChaserProfileData_GasAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationEasy, ChaserProfileData_GasAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationNormal, ChaserProfileData_GasAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationHard, ChaserProfileData_GasAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationInsane, ChaserProfileData_GasAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationNightmare, ChaserProfileData_GasAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerDurationApollyon, ChaserProfileData_GasAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, gasPlayerParticleBeam, ChaserProfileData_GasAdvancedBeamParticle);

	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerAdvanced, ChaserProfileData_EnableMarkAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerAttackIndexes, ChaserProfileData_MarkAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationEasy, ChaserProfileData_MarkAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationNormal, ChaserProfileData_MarkAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationHard, ChaserProfileData_MarkAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationInsane, ChaserProfileData_MarkAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationNightmare, ChaserProfileData_MarkAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, markPlayerDurationApollyon, ChaserProfileData_MarkAdvancedDurationApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerAdvanced, ChaserProfileData_EnableSilentMarkAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerAttackIndexes, ChaserProfileData_SilentMarkAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationEasy, ChaserProfileData_SilentMarkAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationNormal, ChaserProfileData_SilentMarkAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationHard, ChaserProfileData_SilentMarkAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationInsane, ChaserProfileData_SilentMarkAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationNightmare, ChaserProfileData_SilentMarkAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, silentMarkPlayerDurationApollyon, ChaserProfileData_SilentMarkAdvancedDurationApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerAdvanced, ChaserProfileData_EnableIgniteAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerAttackIndexes, ChaserProfileData_IgniteAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayEasy, ChaserProfileData_IgniteAdvancedDelayEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayNormal, ChaserProfileData_IgniteAdvancedDelayNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayHard, ChaserProfileData_IgniteAdvancedDelayHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayInsane, ChaserProfileData_IgniteAdvancedDelayInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayNightmare, ChaserProfileData_IgniteAdvancedDelayNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, ignitePlayerDelayApollyon, ChaserProfileData_IgniteAdvancedDelayApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerAdvanced, ChaserProfileData_EnableStunAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerAttackIndexes, ChaserProfileData_StunAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationEasy, ChaserProfileData_StunAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationNormal, ChaserProfileData_StunAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationHard, ChaserProfileData_StunAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationInsane, ChaserProfileData_StunAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationNightmare, ChaserProfileData_StunAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerDurationApollyon, ChaserProfileData_StunAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownEasy, ChaserProfileData_StunAdvancedSlowdownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownNormal, ChaserProfileData_StunAdvancedSlowdownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownHard, ChaserProfileData_StunAdvancedSlowdownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownInsane, ChaserProfileData_StunAdvancedSlowdownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownNightmare, ChaserProfileData_StunAdvancedSlowdownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerSlowdownApollyon, ChaserProfileData_StunAdvancedSlowdownApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerType, ChaserProfileData_StunAdvancedType);
	g_ChaserProfileData.Set(uniqueProfileIndex, stunPlayerParticleBeam, ChaserProfileData_StunAdvancedBeamParticle);

	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerAdvanced, ChaserProfileData_EnableBleedAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerAttackIndexes, ChaserProfileData_BleedAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationEasy, ChaserProfileData_BleedAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationNormal, ChaserProfileData_BleedAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationHard, ChaserProfileData_BleedAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationInsane, ChaserProfileData_BleedAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationNightmare, ChaserProfileData_BleedAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, bleedPlayerDurationApollyon, ChaserProfileData_BleedAdvancedDurationApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerAdvanced, ChaserProfileData_EnableEletricAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerAttackIndexes, ChaserProfileData_EletricAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationEasy, ChaserProfileData_EletricAdvancedDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationNormal, ChaserProfileData_EletricAdvancedDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationHard, ChaserProfileData_EletricAdvancedDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationInsane, ChaserProfileData_EletricAdvancedDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationNightmare, ChaserProfileData_EletricAdvancedDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerDurationApollyon, ChaserProfileData_EletricAdvancedDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownEasy, ChaserProfileData_EletricAdvancedSlowdownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownNormal, ChaserProfileData_EletricAdvancedSlowdownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownHard, ChaserProfileData_EletricAdvancedSlowdownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownInsane, ChaserProfileData_EletricAdvancedSlowdownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownNightmare, ChaserProfileData_EletricAdvancedSlowdownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, eletricPlayerSlowdownApollyon, ChaserProfileData_EletricAdvancedSlowdownApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, electricPlayerParticleBeam, ChaserProfileData_EletricAdvancedBeamParticle);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, smitePlayerAdvanced, ChaserProfileData_EnableSmiteAdvanced);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteAttackIndexes, ChaserProfileData_SmiteAdvancedIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteDamage, ChaserProfileData_SmiteAdvancedDamage);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteDamageType, ChaserProfileData_SmiteAdvancedDamageType);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteColorR, ChaserProfileData_SmiteColorR);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteColorG, ChaserProfileData_SmiteColorG);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteColorB, ChaserProfileData_SmiteColorB);
	g_ChaserProfileData.Set(uniqueProfileIndex, smiteColorTrans, ChaserProfileData_SmiteTransparency);
	g_ChaserProfileData.Set(uniqueProfileIndex, smitePlayerMessage, ChaserProfileData_SmiteMessage);

	g_ChaserProfileData.Set(uniqueProfileIndex, xenobladeCombo, ChaserProfileData_EnableXenobladeBreakCombo);
	g_ChaserProfileData.Set(uniqueProfileIndex, xenobladeBreakDuration, ChaserProfileData_XenobladeBreakDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, xenobladeToppleDuration, ChaserProfileData_XenobladeToppleDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, xenobladeToppleSlowdown, ChaserProfileData_XenobladeToppleSlowdown);
	g_ChaserProfileData.Set(uniqueProfileIndex, xenobladeDazeDuration, ChaserProfileData_XenobladeDazeDuration);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, damageParticlesEnabled, ChaserProfileData_EnableDamageParticles);
	g_ChaserProfileData.Set(uniqueProfileIndex, damageParticleVolume, ChaserProfileData_DamageParticleVolume);
	g_ChaserProfileData.Set(uniqueProfileIndex, damageParticlePitch, ChaserProfileData_DamageParticlePitch);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveEnabled, ChaserProfileData_ShockwavesEnable);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeightEasy, ChaserProfileData_ShockwaveHeightEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeight, ChaserProfileData_ShockwaveHeightNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeightHard, ChaserProfileData_ShockwaveHeightHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeightInsane, ChaserProfileData_ShockwaveHeightInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeightNightmare, ChaserProfileData_ShockwaveHeightNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveHeightApollyon, ChaserProfileData_ShockwaveHeightApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRangeEasy, ChaserProfileData_ShockwaveRangeEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRange, ChaserProfileData_ShockwaveRangeNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRangeHard, ChaserProfileData_ShockwaveRangeHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRangeInsane, ChaserProfileData_ShockwaveRangeInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRangeNightmare, ChaserProfileData_ShockwaveRangeNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveRangeApollyon, ChaserProfileData_ShockwaveRangeApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrainEasy, ChaserProfileData_ShockwaveDrainEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrain, ChaserProfileData_ShockwaveDrainNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrainHard, ChaserProfileData_ShockwaveDrainHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrainInsane, ChaserProfileData_ShockwaveDrainInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrainNightmare, ChaserProfileData_ShockwaveDrainNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveDrainApollyon, ChaserProfileData_ShockwaveDrainApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForceEasy, ChaserProfileData_ShockwaveForceEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForce, ChaserProfileData_ShockwaveForceNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForceHard, ChaserProfileData_ShockwaveForceHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForceInsane, ChaserProfileData_ShockwaveForceInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForceNightmare, ChaserProfileData_ShockwaveForceNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveForceApollyon, ChaserProfileData_ShockwaveForceApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunEnabled, ChaserProfileData_ShockwaveStunEnabled);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDurationEasy, ChaserProfileData_ShockwaveStunDurationEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDuration, ChaserProfileData_ShockwaveStunDurationNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDurationHard, ChaserProfileData_ShockwaveStunDurationHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDurationInsane, ChaserProfileData_ShockwaveStunDurationInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDurationNightmare, ChaserProfileData_ShockwaveStunDurationNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunDurationApollyon, ChaserProfileData_ShockwaveStunDurationApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdownEasy, ChaserProfileData_ShockwaveStunSlowdownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdown, ChaserProfileData_ShockwaveStunSlowdownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdownHard, ChaserProfileData_ShockwaveStunSlowdownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdownInsane, ChaserProfileData_ShockwaveStunSlowdownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdownNightmare, ChaserProfileData_ShockwaveStunSlowdownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveStunSlowdownApollyon, ChaserProfileData_ShockwaveStunSlowdownApollyon);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveAttackIndexes, ChaserProfileData_ShockwaveAttackIndexes);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveWidth1, ChaserProfileData_ShockwaveWidth1);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveWidth2, ChaserProfileData_ShockwaveWidth2);
	g_ChaserProfileData.Set(uniqueProfileIndex, shockwaveAmplitude, ChaserProfileData_ShockwaveAmplitude);

	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsEnabled, ChaserProfileData_EarthquakeFootstepsEnabled);
	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsAmplitude, ChaserProfileData_EarthquakeFootstepsAmplitude);
	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsFrequency, ChaserProfileData_EarthquakeFootstepsFrequency);
	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsDuration, ChaserProfileData_EarthquakeFootstepsDuration);
	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsRadius, ChaserProfileData_EarthquakeFootstepsRadius);
	g_ChaserProfileData.Set(uniqueProfileIndex, earthquakeFootstepsAirShake, ChaserProfileData_EarthquakeFootstepsCanAirShake);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, trapsEnabled, ChaserProfileData_TrapsEnabled);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapType, ChaserProfileData_TrapType);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldown, ChaserProfileData_TrapSpawnCooldownNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldownEasy, ChaserProfileData_TrapSpawnCooldownEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldownHard, ChaserProfileData_TrapSpawnCooldownHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldownInsane, ChaserProfileData_TrapSpawnCooldownInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldownNightmare, ChaserProfileData_TrapSpawnCooldownNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, trapSpawnCooldownApollyon, ChaserProfileData_TrapSpawnCooldownApollyon);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, bSelfHeal, ChaserProfileData_CanSelfHeal);
	g_ChaserProfileData.Set(uniqueProfileIndex, healthPercentageToHeal, ChaserProfileData_HealStartHealthPercentage);
	g_ChaserProfileData.Set(uniqueProfileIndex, healPercentageOne, ChaserProfileData_HealPercentageOne);
	g_ChaserProfileData.Set(uniqueProfileIndex, healPercentageTwo, ChaserProfileData_HealPercentageTwo);
	g_ChaserProfileData.Set(uniqueProfileIndex, healPercentageThree, ChaserProfileData_HealPercentageThree);

	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("memory_lifetime", 10.0), ChaserProfileData_MemoryLifeTime);
	
	float flDefaultAwarenessIncreaseRate = kv.GetFloat("awareness_rate_increase", 75.0);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_increase_easy", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, flDefaultAwarenessIncreaseRate, ChaserProfileData_AwarenessIncreaseRateNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_increase_hard", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_increase_insane", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_increase_nightmare", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_increase_apollyon", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateApollyon);
	
	float flDefaultAwarenessDecreaseRate = kv.GetFloat("awareness_rate_decrease", 150.0);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_easy", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, flDefaultAwarenessDecreaseRate, ChaserProfileData_AwarenessDecreaseRateNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_hard", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_insane", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_nightmare", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_apollyon", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, kv.GetNum("search_sound_count_until_alert", 4), ChaserProfileData_SoundCountToAlert);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("disappear_on_stun")), ChaserProfileData_DisappearOnStun);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("boxing_boss")), ChaserProfileData_BoxingBoss);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("normal_sound_hook")), ChaserProfileData_NormalSoundHook);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("cloak_to_heal")), ChaserProfileData_CloakToHeal);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("use_chase_initial_animation")), ChaserProfileData_ChaseInitialAnimationUse);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("old_animation_ai")), ChaserProfileData_OldAnimationAI);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("use_alert_walking_animation")), ChaserProfileData_AlertWalkingAnimation);
	
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseEnabled, ChaserProfileData_AutoChaseEnabled);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCount, ChaserProfileData_AutoChaseCount);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCountEasy, ChaserProfileData_AutoChaseCountEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCountHard, ChaserProfileData_AutoChaseCountHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCountInsane, ChaserProfileData_AutoChaseCountInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCountNightmare, ChaserProfileData_AutoChaseCountNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseCountApollyon, ChaserProfileData_AutoChaseCountApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAdd, ChaserProfileData_AutoChaseAdd);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddEasy, ChaserProfileData_AutoChaseAddEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddHard, ChaserProfileData_AutoChaseAddHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddInsane, ChaserProfileData_AutoChaseAddInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddNightmare, ChaserProfileData_AutoChaseAddNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddApollyon, ChaserProfileData_AutoChaseAddApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootsteps, ChaserProfileData_AutoChaseAddFootstep);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootstepsEasy, ChaserProfileData_AutoChaseAddFootstepEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootstepsHard, ChaserProfileData_AutoChaseAddFootstepHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootstepsInsane, ChaserProfileData_AutoChaseAddFootstepInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootstepsNightmare, ChaserProfileData_AutoChaseAddFootstepNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddFootstepsApollyon, ChaserProfileData_AutoChaseAddFootstepApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoice, ChaserProfileData_AutoChaseAddVoice);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoiceEasy, ChaserProfileData_AutoChaseAddVoiceEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoiceHard, ChaserProfileData_AutoChaseAddVoiceHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoiceInsane, ChaserProfileData_AutoChaseAddVoiceInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoiceNightmare, ChaserProfileData_AutoChaseAddVoiceNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddVoiceApollyon, ChaserProfileData_AutoChaseAddVoiceApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeapon, ChaserProfileData_AutoChaseAddWeapon);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeaponEasy, ChaserProfileData_AutoChaseAddWeaponEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeaponHard, ChaserProfileData_AutoChaseAddWeaponHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeaponInsane, ChaserProfileData_AutoChaseAddWeaponInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeaponNightmare, ChaserProfileData_AutoChaseAddWeaponNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseAddWeaponApollyon, ChaserProfileData_AutoChaseAddWeaponApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, autoChaseSprinters, ChaserProfileData_AutoChaseSprinters);

	g_ChaserProfileData.Set(uniqueProfileIndex, chasesEndlessly, ChaserProfileData_ChasesEndlessly);

	g_ChaserProfileData.Set(uniqueProfileIndex, crawlingEnabled, ChaserProfileData_CrawlingEnabled);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplierEasy, ChaserProfileData_CrawlSpeedMultiplierEasy);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplier, ChaserProfileData_CrawlSpeedMultiplierNormal);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplierHard, ChaserProfileData_CrawlSpeedMultiplierHard);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplierInsane, ChaserProfileData_CrawlSpeedMultiplierInsane);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplierNightmare, ChaserProfileData_CrawlSpeedMultiplierNightmare);
	g_ChaserProfileData.Set(uniqueProfileIndex, crawlSpeedMultiplierApollyon, ChaserProfileData_CrawlSpeedMultiplierApollyon);

	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("multi_attack_sounds")), ChaserProfileData_MultiAttackSounds);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("multi_hit_sounds")), ChaserProfileData_MultiHitSounds);
	g_ChaserProfileData.Set(uniqueProfileIndex, view_as<bool>(kv.GetNum("multi_miss_sounds")), ChaserProfileData_MultiMissSounds);

	g_ChaserProfileData.Set(uniqueProfileIndex, chaseOnLook, ChaserProfileData_ChaseOnLook);

	ParseChaserProfileAttacks(kv, uniqueProfileIndex);
	
	return true;
}

public int ParseChaserProfileAttacks(KeyValues kv,int uniqueProfileIndex)
{
	// Create the array.
	ArrayList hAttacks = new ArrayList(ChaserProfileAttackData_MaxStats);
	g_ChaserProfileData.Set(uniqueProfileIndex, hAttacks, ChaserProfileData_Attacks);
	
	int iMaxAttacks = -1;
	if (kv.JumpToKey("attacks"))
	{
		iMaxAttacks = 0;
		char sNum[3];
		for (int i = 1; i <= SF2_CHASER_BOSS_MAX_ATTACKS; i++)
		{
			FormatEx(sNum, sizeof(sNum), "%d", i);
			if (kv.JumpToKey(sNum))
			{
				iMaxAttacks++;
				kv.GoBack();
			}
		}
		if (iMaxAttacks == 0)
		{
			LogSF2Message("[SF2 PROFILES PARSER] Critical error, found \"attacks\" section with no attacks inside of it!");
		}
	}
	for (int iAttackNum = -1; iAttackNum <=iMaxAttacks; iAttackNum++)
	{
		if (iAttackNum < 1) iAttackNum = 1;
		if (iMaxAttacks > 0) //Backward compatibility
		{
			char sNum[3];
			FormatEx(sNum, sizeof(sNum), "%d", iAttackNum);
			kv.JumpToKey(sNum);
		}
		int iAttackType = kv.GetNum("attack_type", SF2BossAttackType_Melee);
		//int iAttackType = SF2BossAttackType_Melee;
		
		float flAttackRange = kv.GetFloat("attack_range");
		if (flAttackRange < 0.0) flAttackRange = 0.0;
		
		float flAttackDamage = kv.GetFloat("attack_damage");
		float flAttackDamageEasy = kv.GetFloat("attack_damage_easy", flAttackDamage);
		float flAttackDamageHard = kv.GetFloat("attack_damage_hard", flAttackDamage);
		float flAttackDamageInsane = kv.GetFloat("attack_damage_insane", flAttackDamageHard);
		float flAttackDamageNightmare = kv.GetFloat("attack_damage_nightmare", flAttackDamageInsane);
		float flAttackDamageApollyon = kv.GetFloat("attack_damage_apollyon", flAttackDamageNightmare);
		
		float flAttackDamageVsProps = kv.GetFloat("attack_damage_vs_props", flAttackDamage);
		float flAttackDamageForce = kv.GetFloat("attack_damageforce");
		
		int iAttackDamageType = kv.GetNum("attack_damagetype");
		if (iAttackDamageType < 0) iAttackDamageType = 0;
		
		float flAttackDamageDelay = kv.GetFloat("attack_delay");
		if (flAttackDamageDelay < 0.0) flAttackDamageDelay = 0.0;
		
		float flAttackDuration = kv.GetFloat("attack_duration", 0.0);
		if (flAttackDuration <= 0.0)//Backward compatibility
		{
			if (flAttackDuration < 0.0) flAttackDuration = 0.0;
			flAttackDuration = flAttackDamageDelay+kv.GetFloat("attack_endafter", 0.0);
		}
		
		bool bAttackProps = view_as<bool>(kv.GetNum("attack_props", 0));
		
		float flAttackSpreadOld = kv.GetFloat("attack_fov", 45.0);
		float flAttackSpread = kv.GetFloat("attack_spread", flAttackSpreadOld);
		
		if (flAttackSpread < 0.0) flAttackSpread = 0.0;
		else if (flAttackSpread > 360.0) flAttackSpread = 360.0;
		
		float flAttackBeginRange = kv.GetFloat("attack_begin_range", flAttackRange);
		if (flAttackBeginRange < 0.0) flAttackBeginRange = 0.0;
		
		float flAttackBeginFOV = kv.GetFloat("attack_begin_fov", flAttackSpread);
		if (flAttackBeginFOV < 0.0) flAttackBeginFOV = 0.0;
		else if (flAttackBeginFOV > 360.0) flAttackBeginFOV = 360.0;
		
		float flAttackCooldown = kv.GetFloat("attack_cooldown");
		if (flAttackCooldown < 0.0) flAttackCooldown = 0.0;
		float flAttackCooldownEasy = kv.GetFloat("attack_cooldown_easy", flAttackCooldown);
		if (flAttackCooldownEasy < 0.0) flAttackCooldownEasy = 0.0;
		float flAttackCooldownHard = kv.GetFloat("attack_cooldown_hard", flAttackCooldown);
		if (flAttackCooldownHard < 0.0) flAttackCooldownHard = 0.0;
		float flAttackCooldownInsane = kv.GetFloat("attack_cooldown_insane", flAttackCooldownHard);
		if (flAttackCooldownInsane < 0.0) flAttackCooldownInsane = 0.0;
		float flAttackCooldownNightmare = kv.GetFloat("attack_cooldown_nightmare", flAttackCooldownInsane);
		if (flAttackCooldownNightmare < 0.0) flAttackCooldownNightmare = 0.0;
		float flAttackCooldownApollyon = kv.GetFloat("attack_cooldown_apollyon", flAttackCooldownNightmare);
		if (flAttackCooldownApollyon < 0.0) flAttackCooldownApollyon = 0.0;
		
		int bAttackDisappear = view_as<bool>(kv.GetNum("attack_disappear_upon_damaging"));
		
		int iAttackRepeat = kv.GetNum("attack_repeat");
		if (iAttackRepeat < 0) iAttackRepeat = 0;
		else if (iAttackRepeat > 2) iAttackRepeat = 2;

		int iMaxAttackRepeat = kv.GetNum("attack_max_repeats");
		if (iMaxAttackRepeat < 0) iMaxAttackRepeat = 0;

		bool bAttackIgnoreAlwaysLooking = view_as<bool>(kv.GetNum("attack_ignore_always_looking"));
		
		bool bAttackWeapons = view_as<bool>(kv.GetNum("attack_weaponsenable", 0));
		
		int iAttackWeaponInt = kv.GetNum("attack_weapontypeint");
		if (iAttackWeaponInt < 1) iAttackWeaponInt = 0;
		
		bool bAttackLifeSteal = view_as<bool>(kv.GetNum("attack_lifesteal", 0));
		
		float flAttackLifeStealDuration = kv.GetFloat("attack_lifesteal_duration", 0.0);
		if (flAttackLifeStealDuration < 0.0) flAttackLifeStealDuration = 0.0;
		
		float flAttackProjectileDamage = kv.GetFloat("attack_projectile_damage", 20.0);
		if (flAttackProjectileDamage < 0.0) flAttackProjectileDamage = 0.0;
		float flAttackProjectileDamageEasy = kv.GetFloat("attack_projectile_damage_easy", flAttackProjectileDamage);
		if (flAttackProjectileDamageEasy < 0.0) flAttackProjectileDamageEasy = 0.0;
		float flAttackProjectileDamageHard = kv.GetFloat("attack_projectile_damage_hard", flAttackProjectileDamage);
		if (flAttackProjectileDamageHard < 0.0) flAttackProjectileDamageHard = 0.0;
		float flAttackProjectileDamageInsane = kv.GetFloat("attack_projectile_damage_insane", flAttackProjectileDamageHard);
		if (flAttackProjectileDamageInsane < 0.0) flAttackProjectileDamageInsane = 0.0;
		float flAttackProjectileDamageNightmare = kv.GetFloat("attack_projectile_damage_nightmare", flAttackProjectileDamageInsane);
		if (flAttackProjectileDamageNightmare < 0.0) flAttackProjectileDamageNightmare = 0.0;
		float flAttackProjectileDamageApollyon = kv.GetFloat("attack_projectile_damage_apollyon", flAttackProjectileDamageNightmare);
		if (flAttackProjectileDamageApollyon < 0.0) flAttackProjectileDamageApollyon = 0.0;
		
		float flAttackProjectileSpeed = kv.GetFloat("attack_projectile_speed", 1100.0);
		if (flAttackProjectileSpeed < 0.0) flAttackProjectileSpeed = 0.0;
		float flAttackProjectileSpeedEasy = kv.GetFloat("attack_projectile_speed_easy", flAttackProjectileSpeed);
		if (flAttackProjectileSpeedEasy < 0.0) flAttackProjectileSpeedEasy = 0.0;
		float flAttackProjectileSpeedHard = kv.GetFloat("attack_projectile_speed_hard", flAttackProjectileSpeed);
		if (flAttackProjectileSpeedHard < 0.0) flAttackProjectileSpeedHard = 0.0;
		float flAttackProjectileSpeedInsane = kv.GetFloat("attack_projectile_speed_insane", flAttackProjectileSpeedHard);
		if (flAttackProjectileSpeedInsane < 0.0) flAttackProjectileSpeedInsane = 0.0;
		float flAttackProjectileSpeedNightmare = kv.GetFloat("attack_projectile_speed_nightmare", flAttackProjectileSpeedInsane);
		if (flAttackProjectileSpeedNightmare < 0.0) flAttackProjectileSpeedNightmare = 0.0;
		float flAttackProjectileSpeedApollyon = kv.GetFloat("attack_projectile_speed_apollyon", flAttackProjectileSpeedNightmare);
		if (flAttackProjectileSpeedApollyon < 0.0) flAttackProjectileSpeedApollyon = 0.0;
		
		float flAttackProjectileRadius = kv.GetFloat("attack_projectile_radius", 128.0);
		if (flAttackProjectileRadius < 0.0) flAttackProjectileRadius = 0.0;
		float flAttackProjectileRadiusEasy = kv.GetFloat("attack_projectile_radius_easy", flAttackProjectileRadius);
		if (flAttackProjectileRadiusEasy < 0.0) flAttackProjectileRadiusEasy = 0.0;
		float flAttackProjectileRadiusHard = kv.GetFloat("attack_projectile_radius_hard", flAttackProjectileRadius);
		if (flAttackProjectileRadiusHard < 0.0) flAttackProjectileRadiusHard = 0.0;
		float flAttackProjectileRadiusInsane = kv.GetFloat("attack_projectile_radius_insane", flAttackProjectileRadiusHard);
		if (flAttackProjectileRadiusInsane < 0.0) flAttackProjectileRadiusInsane = 0.0;
		float flAttackProjectileRadiusNightmare = kv.GetFloat("attack_projectile_radius_nightmare", flAttackProjectileRadiusInsane);
		if (flAttackProjectileRadiusNightmare < 0.0) flAttackProjectileRadiusNightmare = 0.0;
		float flAttackProjectileRadiusApollyon = kv.GetFloat("attack_projectile_radius_apollyon", flAttackProjectileRadiusNightmare);
		if (flAttackProjectileRadiusApollyon < 0.0) flAttackProjectileRadiusApollyon = 0.0;

		float flAttackProjectileDeviation = kv.GetFloat("attack_projectile_deviation", 0.0);
		float flAttackProjectileDeviationEasy = kv.GetFloat("attack_projectile_deviation_easy", flAttackProjectileDeviation);
		float flAttackProjectileDeviationHard = kv.GetFloat("attack_projectile_deviation_hard", flAttackProjectileDeviation);
		float flAttackProjectileDeviationInsane = kv.GetFloat("attack_projectile_deviation_insane", flAttackProjectileDeviationHard);
		float flAttackProjectileDeviationNightmare = kv.GetFloat("attack_projectile_deviation_nightmare", flAttackProjectileDeviationInsane);
		float flAttackProjectileDeviationApollyon = kv.GetFloat("attack_projectile_deviation_apollyon", flAttackProjectileDeviationNightmare);
		
		bool bAttackCritProjectiles = view_as<bool>(kv.GetNum("attack_projectile_crits", 0));
		
		float flAttackProjectileIceSlowdownPercent = kv.GetFloat("attack_projectile_iceslow_percent", 0.55);
		if (flAttackProjectileIceSlowdownPercent < 0.0) flAttackProjectileIceSlowdownPercent = 0.0;
		float flAttackProjectileIceSlowdownPercentEasy = kv.GetFloat("attack_projectile_iceslow_percent_easy", flAttackProjectileIceSlowdownPercent);
		if (flAttackProjectileIceSlowdownPercentEasy < 0.0) flAttackProjectileIceSlowdownPercentEasy = 0.0;
		float flAttackProjectileIceSlowdownPercentHard = kv.GetFloat("attack_projectile_iceslow_percent_hard", flAttackProjectileIceSlowdownPercent);
		if (flAttackProjectileIceSlowdownPercentHard < 0.0) flAttackProjectileIceSlowdownPercentHard = 0.0;
		float flAttackProjectileIceSlowdownPercentInsane = kv.GetFloat("attack_projectile_iceslow_percent_insane", flAttackProjectileIceSlowdownPercentHard);
		if (flAttackProjectileIceSlowdownPercentInsane < 0.0) flAttackProjectileIceSlowdownPercentInsane = 0.0;
		float flAttackProjectileIceSlowdownPercentNightmare = kv.GetFloat("attack_projectile_iceslow_percent_nightmare", flAttackProjectileIceSlowdownPercentInsane);
		if (flAttackProjectileIceSlowdownPercentNightmare < 0.0) flAttackProjectileIceSlowdownPercentNightmare = 0.0;
		float flAttackProjectileIceSlowdownPercentApollyon = kv.GetFloat("attack_projectile_iceslow_percent_apollyon", flAttackProjectileIceSlowdownPercentNightmare);
		if (flAttackProjectileIceSlowdownPercentApollyon < 0.0) flAttackProjectileIceSlowdownPercentApollyon = 0.0;
		
		float flAttackProjectileIceSlowdownDuration = kv.GetFloat("attack_projectile_iceslow_duration", 2.0);
		if (flAttackProjectileIceSlowdownDuration < 0.0) flAttackProjectileIceSlowdownDuration = 0.0;
		float flAttackProjectileIceSlowdownDurationEasy = kv.GetFloat("attack_projectile_iceslow_duration_easy", flAttackProjectileIceSlowdownDuration);
		if (flAttackProjectileIceSlowdownDurationEasy < 0.0) flAttackProjectileIceSlowdownDurationEasy = 0.0;
		float flAttackProjectileIceSlowdownDurationHard = kv.GetFloat("attack_projectile_iceslow_duration_hard", flAttackProjectileIceSlowdownDuration);
		if (flAttackProjectileIceSlowdownDurationHard < 0.0) flAttackProjectileIceSlowdownDurationHard = 0.0;
		float flAttackProjectileIceSlowdownDurationInsane = kv.GetFloat("attack_projectile_iceslow_duration_insane", flAttackProjectileIceSlowdownDurationHard);
		if (flAttackProjectileIceSlowdownDurationInsane < 0.0) flAttackProjectileIceSlowdownDurationInsane = 0.0;
		float flAttackProjectileIceSlowdownDurationNightmare = kv.GetFloat("attack_projectile_iceslow_duration_nightmare", flAttackProjectileIceSlowdownDurationInsane);
		if (flAttackProjectileIceSlowdownDurationNightmare < 0.0) flAttackProjectileIceSlowdownDurationNightmare = 0.0;
		float flAttackProjectileIceSlowdownDurationApollyon = kv.GetFloat("attack_projectile_iceslow_duration_apollyon", flAttackProjectileIceSlowdownDurationNightmare);
		if (flAttackProjectileIceSlowdownDurationApollyon < 0.0) flAttackProjectileIceSlowdownDurationApollyon = 0.0;

		int iAttackProjectileCount = kv.GetNum("attack_projectile_count", 1);
		if (iAttackProjectileCount < 1) iAttackProjectileCount = 1;
		int iAttackProjectileCountEasy = kv.GetNum("attack_projectile_count_easy", iAttackProjectileCount);
		if (iAttackProjectileCountEasy < 1) iAttackProjectileCountEasy = 1;
		int iAttackProjectileCountHard = kv.GetNum("attack_projectile_count_hard", iAttackProjectileCount);
		if (iAttackProjectileCountHard < 1) iAttackProjectileCountHard = 1;
		int iAttackProjectileCountInsane = kv.GetNum("attack_projectile_count_insane", iAttackProjectileCountHard);
		if (iAttackProjectileCountInsane < 1) iAttackProjectileCountInsane = 1;
		int iAttackProjectileCountNightmare = kv.GetNum("attack_projectile_count_nightmare", iAttackProjectileCountInsane);
		if (iAttackProjectileCountNightmare < 1) iAttackProjectileCountNightmare = 1;
		int iAttackProjectileCountApollyon = kv.GetNum("attack_projectile_count_apollyon", iAttackProjectileCountNightmare);
		if (iAttackProjectileCountApollyon < 1) iAttackProjectileCountApollyon = 1;

		int iAttackProjectileType = kv.GetNum("attack_projectiletype");
		
		int iAttackBulletCount = kv.GetNum("attack_bullet_count", 4);
		if (iAttackBulletCount < 1) iAttackBulletCount = 1;
		int iAttackBulletCountEasy = kv.GetNum("attack_bullet_count_easy", iAttackBulletCount);
		if (iAttackBulletCountEasy < 1) iAttackBulletCountEasy = 1;
		int iAttackBulletCountHard = kv.GetNum("attack_bullet_count_hard", iAttackBulletCount);
		if (iAttackBulletCountHard < 1) iAttackBulletCountHard = 1;
		int iAttackBulletCountInsane = kv.GetNum("attack_bullet_count_insane", iAttackBulletCountHard);
		if (iAttackBulletCountInsane < 1) iAttackBulletCountInsane = 1;
		int iAttackBulletCountNightmare = kv.GetNum("attack_bullet_count_nightmare", iAttackBulletCountInsane);
		if (iAttackBulletCountNightmare < 1) iAttackBulletCountNightmare = 1;
		int iAttackBulletCountApollyon = kv.GetNum("attack_bullet_count_apollyon", iAttackBulletCountNightmare);
		if (iAttackBulletCountApollyon < 1) iAttackBulletCountApollyon = 1;
		
		float flAttackBulletDamage = kv.GetFloat("attack_bullet_damage", 8.0);
		if (flAttackBulletDamage < 0.0) flAttackBulletDamage = 0.0;
		float flAttackBulletDamageEasy = kv.GetFloat("attack_bullet_damage_easy", flAttackBulletDamage);
		if (flAttackBulletDamageEasy < 0.0) flAttackBulletDamageEasy = 0.0;
		float flAttackBulletDamageHard = kv.GetFloat("attack_bullet_damage_hard", flAttackBulletDamage);
		if (flAttackBulletDamageHard < 0.0) flAttackBulletDamageHard = 0.0;
		float flAttackBulletDamageInsane = kv.GetFloat("attack_bullet_damage_insane", flAttackBulletDamageHard);
		if (flAttackBulletDamageInsane < 0.0) flAttackBulletDamageInsane = 0.0;
		float flAttackBulletDamageNightmare = kv.GetFloat("attack_bullet_damage_nightmare", flAttackBulletDamageInsane);
		if (flAttackBulletDamageNightmare < 0.0) flAttackBulletDamageNightmare = 0.0;
		float flAttackBulletDamageApollyon = kv.GetFloat("attack_bullet_damage_apollyon", flAttackBulletDamageNightmare);
		if (flAttackBulletDamageApollyon < 0.0) flAttackBulletDamageApollyon = 0.0;
		
		float flAttackBulletSpread = kv.GetFloat("attack_bullet_spread", 0.1);
		if (flAttackBulletSpread < 0.0) flAttackBulletSpread = 0.0;
		float flAttackBulletSpreadEasy = kv.GetFloat("attack_bullet_spread_easy", flAttackBulletSpread);
		if (flAttackBulletSpreadEasy < 0.0) flAttackBulletSpreadEasy = 0.0;
		float flAttackBulletSpreadHard = kv.GetFloat("attack_bullet_spread_hard", flAttackBulletSpread);
		if (flAttackBulletSpreadHard < 0.0) flAttackBulletSpreadHard = 0.0;
		float flAttackBulletSpreadInsane = kv.GetFloat("attack_bullet_spread_insane", flAttackBulletSpreadHard);
		if (flAttackBulletSpreadInsane < 0.0) flAttackBulletSpreadInsane = 0.0;
		float flAttackBulletSpreadNightmare = kv.GetFloat("attack_bullet_spread_nightmare", flAttackBulletSpreadInsane);
		if (flAttackBulletSpreadNightmare < 0.0) flAttackBulletSpreadNightmare = 0.0;
		float flAttackBulletSpreadApollyon = kv.GetFloat("attack_bullet_spread_apollyon", flAttackBulletSpreadNightmare);
		if (flAttackBulletSpreadApollyon < 0.0) flAttackBulletSpreadApollyon = 0.0;
		
		float flAttackLaserDamage = kv.GetFloat("attack_laser_damage", 25.0);
		if (flAttackLaserDamage < 0.0) flAttackLaserDamage = 0.0;
		float flAttackLaserDamageEasy = kv.GetFloat("attack_laser_damage_easy", flAttackLaserDamage);
		if (flAttackLaserDamageEasy < 0.0) flAttackLaserDamageEasy = 0.0;
		float flAttackLaserDamageHard = kv.GetFloat("attack_laser_damage_hard", flAttackLaserDamage);
		if (flAttackLaserDamageHard < 0.0) flAttackLaserDamageHard = 0.0;
		float flAttackLaserDamageInsane = kv.GetFloat("attack_laser_damage_insane", flAttackLaserDamageHard);
		if (flAttackLaserDamageInsane < 0.0) flAttackLaserDamageInsane = 0.0;
		float flAttackLaserDamageNightmare = kv.GetFloat("attack_laser_damage_nightmare", flAttackLaserDamageInsane);
		if (flAttackLaserDamageNightmare < 0.0) flAttackLaserDamageNightmare = 0.0;
		float flAttackLaserDamageApollyon = kv.GetFloat("attack_laser_damage_apollyon", flAttackLaserDamageNightmare);
		if (flAttackLaserDamageApollyon < 0.0) flAttackLaserDamageApollyon = 0.0;
		
		float flAttackLaserSize = kv.GetFloat("attack_laser_size", 12.0);
		if (flAttackLaserSize < 0.0) flAttackLaserSize = 0.0;

		int iAttackLaserColorR = kv.GetNum("attack_laser_color_r", 255);
		int iAttackLaserColorG = kv.GetNum("attack_laser_color_g", 255);
		int iAttackLaserColorB = kv.GetNum("attack_laser_color_b", 255);
		
		bool bAttackLaserAttachment = view_as<bool>(kv.GetNum("attack_laser_attachment", 0));
		
		float flAttackLaserDuration = kv.GetFloat("attack_laser_duration", flAttackDuration);

		float flAttackLaserNoise = kv.GetFloat("attack_laser_noise", 1.0);
		
		bool bAttackPullIn = view_as<bool>(kv.GetNum("attack_pull_player_in", 0));
		
		bool bAttackWhileRunning = view_as<bool>(kv.GetNum("attack_while_running", 0));

		float flAttackRunSpeed = kv.GetFloat("attack_run_speed");
		float flAttackRunSpeedEasy = kv.GetFloat("attack_run_speed_easy", flAttackRunSpeed);
		float flAttackRunSpeedHard = kv.GetFloat("attack_run_speed_hard", flAttackRunSpeed);
		float flAttackRunSpeedInsane = kv.GetFloat("attack_run_speed_insane", flAttackRunSpeedHard);
		float flAttackRunSpeedNightmare = kv.GetFloat("attack_run_speed_nightmare", flAttackRunSpeedInsane);
		float flAttackRunSpeedApollyon = kv.GetFloat("attack_run_speed_apollyon", flAttackRunSpeedNightmare);

		float flAttackRunDuration = kv.GetFloat("attack_run_duration");

		float flAttackRunDelay = kv.GetFloat("attack_run_delay");

		int iAttackUseOnDifficulty = kv.GetNum("attack_use_on_difficulty");
		int iAttackBlockOnDifficulty = kv.GetNum("attack_block_on_difficulty", 6);

		int iAttackExplosiveDanceRadius = kv.GetNum("attack_explosivedance_radius", 350);

		bool bAttackGestures = view_as<bool>(kv.GetNum("attack_gestures", 0));

		bool bAttackDeathCamLowHealth = view_as<bool>(kv.GetNum("attack_deathcam_on_low_health"));

		float flAttackUseOnHealth = kv.GetFloat("attack_use_on_health", -1.0);
		float flAttackBlockOnHealth = kv.GetFloat("attack_block_on_health", -1.0);

		int attackIndex = hAttacks.Push(-1);
		
		hAttacks.Set(attackIndex, iAttackType, ChaserProfileAttackData_Type);
		hAttacks.Set(attackIndex, bAttackProps, ChaserProfileAttackData_CanUseAgainstProps);
		hAttacks.Set(attackIndex, flAttackRange, ChaserProfileAttackData_Range);
		hAttacks.Set(attackIndex, flAttackDamage, ChaserProfileAttackData_Damage);
		hAttacks.Set(attackIndex, flAttackDamageEasy, ChaserProfileAttackData_DamageEasy);
		hAttacks.Set(attackIndex, flAttackDamageHard, ChaserProfileAttackData_DamageHard);
		hAttacks.Set(attackIndex, flAttackDamageInsane, ChaserProfileAttackData_DamageInsane);
		hAttacks.Set(attackIndex, flAttackDamageNightmare, ChaserProfileAttackData_DamageNightmare);
		hAttacks.Set(attackIndex, flAttackDamageApollyon, ChaserProfileAttackData_DamageApollyon);
		hAttacks.Set(attackIndex, flAttackDamageVsProps, ChaserProfileAttackData_DamageVsProps);
		hAttacks.Set(attackIndex, flAttackDamageForce, ChaserProfileAttackData_DamageForce);
		hAttacks.Set(attackIndex, iAttackDamageType, ChaserProfileAttackData_DamageType);
		hAttacks.Set(attackIndex, flAttackDamageDelay, ChaserProfileAttackData_DamageDelay);
		hAttacks.Set(attackIndex, flAttackDuration, ChaserProfileAttackData_Duration);
		hAttacks.Set(attackIndex, flAttackSpread, ChaserProfileAttackData_Spread);
		hAttacks.Set(attackIndex, flAttackBeginRange, ChaserProfileAttackData_BeginRange);
		hAttacks.Set(attackIndex, flAttackBeginFOV, ChaserProfileAttackData_BeginFOV);
		hAttacks.Set(attackIndex, flAttackCooldown, ChaserProfileAttackData_Cooldown);
		hAttacks.Set(attackIndex, flAttackCooldownEasy, ChaserProfileAttackData_CooldownEasy);
		hAttacks.Set(attackIndex, flAttackCooldownHard, ChaserProfileAttackData_CooldownHard);
		hAttacks.Set(attackIndex, flAttackCooldownInsane, ChaserProfileAttackData_CooldownInsane);
		hAttacks.Set(attackIndex, flAttackCooldownNightmare, ChaserProfileAttackData_CooldownNightmare);
		hAttacks.Set(attackIndex, flAttackCooldownApollyon, ChaserProfileAttackData_CooldownApollyon);
		hAttacks.Set(attackIndex, bAttackDisappear, ChaserProfileAttackData_Disappear);
		hAttacks.Set(attackIndex, iAttackRepeat, ChaserProfileAttackData_Repeat);
		hAttacks.Set(attackIndex, iMaxAttackRepeat, ChaserProfileAttackData_MaxAttackRepeat);
		hAttacks.Set(attackIndex, bAttackIgnoreAlwaysLooking, ChaserProfileAttackData_IgnoreAlwaysLooking);
		hAttacks.Set(attackIndex, iAttackWeaponInt, ChaserProfileAttackData_WeaponInt);
		hAttacks.Set(attackIndex, bAttackWeapons, ChaserProfileAttackData_CanUseWeaponTypes);
		hAttacks.Set(attackIndex, bAttackLifeSteal, ChaserProfileAttackData_LifeStealEnabled);
		hAttacks.Set(attackIndex, flAttackLifeStealDuration, ChaserProfileAttackData_LifeStealDuration);
		hAttacks.Set(attackIndex, flAttackProjectileDamage, ChaserProfileAttackData_ProjectileDamage);
		hAttacks.Set(attackIndex, flAttackProjectileDamageEasy, ChaserProfileAttackData_ProjectileDamageEasy);
		hAttacks.Set(attackIndex, flAttackProjectileDamageHard, ChaserProfileAttackData_ProjectileDamageHard);
		hAttacks.Set(attackIndex, flAttackProjectileDamageInsane, ChaserProfileAttackData_ProjectileDamageInsane);
		hAttacks.Set(attackIndex, flAttackProjectileDamageNightmare, ChaserProfileAttackData_ProjectileDamageNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileDamageApollyon, ChaserProfileAttackData_ProjectileDamageApollyon);
		hAttacks.Set(attackIndex, flAttackProjectileSpeed, ChaserProfileAttackData_ProjectileSpeed);
		hAttacks.Set(attackIndex, flAttackProjectileSpeedEasy, ChaserProfileAttackData_ProjectileSpeedEasy);
		hAttacks.Set(attackIndex, flAttackProjectileSpeedHard, ChaserProfileAttackData_ProjectileSpeedHard);
		hAttacks.Set(attackIndex, flAttackProjectileSpeedInsane, ChaserProfileAttackData_ProjectileSpeedInsane);
		hAttacks.Set(attackIndex, flAttackProjectileSpeedNightmare, ChaserProfileAttackData_ProjectileSpeedNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileSpeedApollyon, ChaserProfileAttackData_ProjectileSpeedApollyon);
		hAttacks.Set(attackIndex, flAttackProjectileRadius, ChaserProfileAttackData_ProjectileRadius);
		hAttacks.Set(attackIndex, flAttackProjectileRadiusEasy, ChaserProfileAttackData_ProjectileRadiusEasy);
		hAttacks.Set(attackIndex, flAttackProjectileRadiusHard, ChaserProfileAttackData_ProjectileRadiusHard);
		hAttacks.Set(attackIndex, flAttackProjectileRadiusInsane, ChaserProfileAttackData_ProjectileRadiusInsane);
		hAttacks.Set(attackIndex, flAttackProjectileRadiusNightmare, ChaserProfileAttackData_ProjectileRadiusNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileRadiusApollyon, ChaserProfileAttackData_ProjectileRadiusApollyon);
		hAttacks.Set(attackIndex, flAttackProjectileDeviation, ChaserProfileAttackData_ProjectileDeviation);
		hAttacks.Set(attackIndex, flAttackProjectileDeviationEasy, ChaserProfileAttackData_ProjectileDeviationEasy);
		hAttacks.Set(attackIndex, flAttackProjectileDeviationHard, ChaserProfileAttackData_ProjectileDeviationHard);
		hAttacks.Set(attackIndex, flAttackProjectileDeviationInsane, ChaserProfileAttackData_ProjectileDeviationInsane);
		hAttacks.Set(attackIndex, flAttackProjectileDeviationNightmare, ChaserProfileAttackData_ProjectileDeviationNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileDeviationApollyon, ChaserProfileAttackData_ProjectileDeviationApollyon);
		hAttacks.Set(attackIndex, bAttackCritProjectiles, ChaserProfileAttackData_ProjectileCrits);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercent, ChaserProfileAttackData_ProjectileIceSlowdownPercent);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercentEasy, ChaserProfileAttackData_ProjectileIceSlowdownPercentEasy);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercentHard, ChaserProfileAttackData_ProjectileIceSlowdownPercentHard);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercentInsane, ChaserProfileAttackData_ProjectileIceSlowdownPercentInsane);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercentNightmare, ChaserProfileAttackData_ProjectileIceSlowdownPercentNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownPercentApollyon, ChaserProfileAttackData_ProjectileIceSlowdownPercentApollyon);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDuration, ChaserProfileAttackData_ProjectileIceSlowdownDuration);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDurationEasy, ChaserProfileAttackData_ProjectileIceSlowdownDurationEasy);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDurationHard, ChaserProfileAttackData_ProjectileIceSlowdownDurationHard);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDurationInsane, ChaserProfileAttackData_ProjectileIceSlowdownDurationInsane);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDurationNightmare, ChaserProfileAttackData_ProjectileIceSlowdownDurationNightmare);
		hAttacks.Set(attackIndex, flAttackProjectileIceSlowdownDurationApollyon, ChaserProfileAttackData_ProjectileIceSlowdownDurationApollyon);
		hAttacks.Set(attackIndex, iAttackProjectileCount, ChaserProfileAttackData_ProjectileCount);
		hAttacks.Set(attackIndex, iAttackProjectileCountEasy, ChaserProfileAttackData_ProjectileCountEasy);
		hAttacks.Set(attackIndex, iAttackProjectileCountHard, ChaserProfileAttackData_ProjectileCountHard);
		hAttacks.Set(attackIndex, iAttackProjectileCountInsane, ChaserProfileAttackData_ProjectileCountInsane);
		hAttacks.Set(attackIndex, iAttackProjectileCountNightmare, ChaserProfileAttackData_ProjectileCountNightmare);
		hAttacks.Set(attackIndex, iAttackProjectileCountApollyon, ChaserProfileAttackData_ProjectileCountApollyon);
		hAttacks.Set(attackIndex, iAttackProjectileType, ChaserProfileAttackData_ProjectileType);
		hAttacks.Set(attackIndex, iAttackBulletCount, ChaserProfileAttackData_BulletCount);
		hAttacks.Set(attackIndex, iAttackBulletCountEasy, ChaserProfileAttackData_BulletCountEasy);
		hAttacks.Set(attackIndex, iAttackBulletCountHard, ChaserProfileAttackData_BulletCountHard);
		hAttacks.Set(attackIndex, iAttackBulletCountInsane, ChaserProfileAttackData_BulletCountInsane);
		hAttacks.Set(attackIndex, iAttackBulletCountNightmare, ChaserProfileAttackData_BulletCountNightmare);
		hAttacks.Set(attackIndex, iAttackBulletCountApollyon, ChaserProfileAttackData_BulletCountApollyon);
		hAttacks.Set(attackIndex, flAttackBulletDamage, ChaserProfileAttackData_BulletDamage);
		hAttacks.Set(attackIndex, flAttackBulletDamageEasy, ChaserProfileAttackData_BulletDamageEasy);
		hAttacks.Set(attackIndex, flAttackBulletDamageHard, ChaserProfileAttackData_BulletDamageHard);
		hAttacks.Set(attackIndex, flAttackBulletDamageInsane, ChaserProfileAttackData_BulletDamageInsane);
		hAttacks.Set(attackIndex, flAttackBulletDamageNightmare, ChaserProfileAttackData_BulletDamageNightmare);
		hAttacks.Set(attackIndex, flAttackBulletDamageApollyon, ChaserProfileAttackData_BulletDamageApollyon);
		hAttacks.Set(attackIndex, flAttackBulletSpread, ChaserProfileAttackData_BulletSpread);
		hAttacks.Set(attackIndex, flAttackBulletSpreadEasy, ChaserProfileAttackData_BulletSpreadEasy);
		hAttacks.Set(attackIndex, flAttackBulletSpreadHard, ChaserProfileAttackData_BulletSpreadHard);
		hAttacks.Set(attackIndex, flAttackBulletSpreadInsane, ChaserProfileAttackData_BulletSpreadInsane);
		hAttacks.Set(attackIndex, flAttackBulletSpreadNightmare, ChaserProfileAttackData_BulletSpreadNightmare);
		hAttacks.Set(attackIndex, flAttackBulletSpreadApollyon, ChaserProfileAttackData_BulletSpreadApollyon);
		hAttacks.Set(attackIndex, flAttackLaserDamage, ChaserProfileAttackData_LaserDamage);
		hAttacks.Set(attackIndex, flAttackLaserDamageEasy, ChaserProfileAttackData_LaserDamageEasy);
		hAttacks.Set(attackIndex, flAttackLaserDamageHard, ChaserProfileAttackData_LaserDamageHard);
		hAttacks.Set(attackIndex, flAttackLaserDamageInsane, ChaserProfileAttackData_LaserDamageInsane);
		hAttacks.Set(attackIndex, flAttackLaserDamageNightmare, ChaserProfileAttackData_LaserDamageNightmare);
		hAttacks.Set(attackIndex, flAttackLaserDamageApollyon, ChaserProfileAttackData_LaserDamageApollyon);
		hAttacks.Set(attackIndex, flAttackLaserSize, ChaserProfileAttackData_LaserSize);
		hAttacks.Set(attackIndex, iAttackLaserColorR, ChaserProfileAttackData_LaserColorR);
		hAttacks.Set(attackIndex, iAttackLaserColorG, ChaserProfileAttackData_LaserColorG);
		hAttacks.Set(attackIndex, iAttackLaserColorB, ChaserProfileAttackData_LaserColorB);
		hAttacks.Set(attackIndex, bAttackLaserAttachment, ChaserProfileAttackData_LaserAttachment);
		hAttacks.Set(attackIndex, flAttackLaserDuration, ChaserProfileAttackData_LaserDuration);
		hAttacks.Set(attackIndex, flAttackLaserNoise, ChaserProfileAttackData_LaserNoise);
		hAttacks.Set(attackIndex, bAttackPullIn, ChaserProfileAttackData_PullIn);
		hAttacks.Set(attackIndex, bAttackWhileRunning, ChaserProfileAttackData_CanAttackWhileRunning);
		hAttacks.Set(attackIndex, flAttackRunSpeed, ChaserProfileAttackData_RunSpeed);
		hAttacks.Set(attackIndex, flAttackRunSpeedEasy, ChaserProfileAttackData_RunSpeedEasy);
		hAttacks.Set(attackIndex, flAttackRunSpeedHard, ChaserProfileAttackData_RunSpeedHard);
		hAttacks.Set(attackIndex, flAttackRunSpeedInsane, ChaserProfileAttackData_RunSpeedInsane);
		hAttacks.Set(attackIndex, flAttackRunSpeedNightmare, ChaserProfileAttackData_RunSpeedNightmare);
		hAttacks.Set(attackIndex, flAttackRunSpeedApollyon, ChaserProfileAttackData_RunSpeedApollyon);	
		hAttacks.Set(attackIndex, flAttackRunDuration, ChaserProfileAttackData_RunDuration);
		hAttacks.Set(attackIndex, flAttackRunDelay, ChaserProfileAttackData_RunDelay);
		hAttacks.Set(attackIndex, iAttackUseOnDifficulty, ChaserProfileAttackData_UseOnDifficulty);
		hAttacks.Set(attackIndex, iAttackBlockOnDifficulty, ChaserProfileAttackData_BlockOnDifficulty);
		hAttacks.Set(attackIndex, iAttackExplosiveDanceRadius, ChaserProfileAttackData_ExplosiveDanceRadius);
		hAttacks.Set(attackIndex, bAttackGestures, ChaserProfileAttackData_Gestures);
		hAttacks.Set(attackIndex, bAttackDeathCamLowHealth, ChaserProfileAttackData_DeathCamLowHealth);
		hAttacks.Set(attackIndex, flAttackUseOnHealth, ChaserProfileAttackData_UseOnHealth);
		hAttacks.Set(attackIndex, flAttackBlockOnHealth, ChaserProfileAttackData_BlockOnHealth);

		if (iMaxAttacks > 0)//Backward compatibility
		{
			kv.GoBack();
		}
		else
			break;
	}
	if (iMaxAttacks > 0)
		kv.GoBack();
	return iMaxAttacks;
}

stock bool GetProfileGesture(int bossIndex, const char[] profile, int iAnimationSection, char[] sAnimation, int iLenght, float &flPlaybackRate, float &flCycle, int iAnimationIndex = -1)
{
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	char sAnimationSection[40], sKeyGestureName[65], sKeyGesturePlayBackRate[65], sKeyGestureCycle[65];
	switch (iAnimationSection)
	{
		case ChaserAnimation_AttackAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "attack");
			strcopy(sKeyGestureName, sizeof(sKeyGestureName), "gesture_attack");
			strcopy(sKeyGesturePlayBackRate, sizeof(sKeyGesturePlayBackRate), "gesture_attack_playbackrate");
			strcopy(sKeyGestureCycle, sizeof(sKeyGestureCycle), "gesture_attack_cycle");
		}
	}
	if (g_Config.JumpToKey("animations"))
	{
		if (g_Config.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_Config.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_Config.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_Config.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	g_Config.GetString(sKeyGestureName, sAnimation, iLenght);
	flPlaybackRate = g_Config.GetFloat(sKeyGesturePlayBackRate, 1.0);
	flCycle = g_Config.GetFloat(sKeyGestureCycle, 0.0);
	return true;
}

stock bool GetProfileAnimation(int bossIndex, const char[] profile, int iAnimationSection, char[] sAnimation, int iLenght, float &flPlaybackRate, int difficulty, int iAnimationIndex = -1, float &flFootstepInterval, float &flCycle = 0.0)
{
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	char sAnimationSection[40], sKeyAnimationName[65], sKeyAnimationPlayBackRate[65], sKeyAnimationFootstepInt[65], sKeyAnimationCycle[65];
	switch (iAnimationSection)
	{
		case ChaserAnimation_IdleAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "idle");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_idle");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_idle_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_idle_footstepinterval");
			}
		}
		case ChaserAnimation_WalkAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "walk");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walk");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walk_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
			}
		}
		case ChaserAnimation_WalkAlertAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "walkalert");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_walkalert");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_walkalert_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
			}
		}
		case ChaserAnimation_AttackAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "attack");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_attack");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_attack_playbackrate");
			strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_attack_footstepinterval");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_attack_cycle");
		}
		case ChaserAnimation_ShootAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "shoot");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_shoot");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_shoot_playbackrate");
			strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_attack_footstepinterval");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_shoot_cycle");
		}
		case ChaserAnimation_RunAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "run");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_run");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_run_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_footstepinterval");
			}
		}
		case ChaserAnimation_RunAltAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "run");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_runalt");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_runalt_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_runalt_footstepinterval");
			}
		}
		case ChaserAnimation_ChaseInitialAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "chaseinitial");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_chaseinitial");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_chaseinitial_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_chaseinitial_cycle");
		}
		case ChaserAnimation_RageAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "rage");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_rage");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_rage_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_rage_cycle");
		}
		case ChaserAnimation_StunAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "stun");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_stun");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_stun_playbackrate");
			strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_stun_footstepinterval");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_stun_cycle");
		}
		case ChaserAnimation_DeathAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "death");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_death");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_death_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_death_cycle");
		}
		case ChaserAnimation_JumpAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "jump");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_jump");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_jump_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_jump_cycle");
		}
		case ChaserAnimation_SpawnAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "spawn");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_spawn");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_spawn_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_spawn_cycle");
		}
		case ChaserAnimation_FleeInitialAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "fleestart");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_fleestart");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_fleestart_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_fleestart_cycle");
		}
		case ChaserAnimation_HealAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "heal");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_heal");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_heal_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_heal_cycle");
		}
		case ChaserAnimation_DeathcamAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "deathcam");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_deathcam");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_deathcam_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_deathcam_cycle");
		}
		case ChaserAnimation_CloakStartAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "cloakstart");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_cloakstart");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_cloakstart_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_cloakstart_cycle");
		}
		case ChaserAnimation_CloakEndAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "cloakend");
			strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_cloakend");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_cloakend_playbackrate");
			strcopy(sKeyAnimationCycle, sizeof(sKeyAnimationCycle), "animation_cloakend_cycle");
		}
		case ChaserAnimation_CrawlWalkAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "crawlwalk");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlwalk");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlwalk_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_walk_footstepinterval");
			}
		}
		case ChaserANimation_CrawlRunAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "crawlrun");
			if (g_SlenderDifficultyAnimations[bossIndex])
			{
				switch (difficulty)
				{
					case Difficulty_Easy:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun_easy");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_easy_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_easy_footstepinterval");
					}
					case Difficulty_Normal:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_footstepinterval");
					}
					case Difficulty_Hard:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun_hard");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_hard_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_hard_footstepinterval");
					}
					case Difficulty_Insane:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun_insane");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_insane_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_insane_footstepinterval");
					}
					case Difficulty_Nightmare:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun_nightmare");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_nightmare_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_nightmare_footstepinterval");
					}
					case Difficulty_Apollyon:
					{
						strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun_apollyon");
						strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_apollyon_playbackrate");
						strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_apollyon_footstepinterval");
					}
				}
			}
			else
			{
				strcopy(sKeyAnimationName, sizeof(sKeyAnimationName), "animation_crawlrun");
				strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "animation_crawlrun_playbackrate");
				strcopy(sKeyAnimationFootstepInt, sizeof(sKeyAnimationFootstepInt), "animation_run_footstepinterval");
			}
		}
	}
	
	if (g_Config.JumpToKey("animations"))
	{
		if (g_Config.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_Config.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_Config.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_Config.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	g_Config.GetString(sKeyAnimationName, sAnimation, iLenght);
	flPlaybackRate = g_Config.GetFloat(sKeyAnimationPlayBackRate, 1.0);
	flFootstepInterval = g_Config.GetFloat(sKeyAnimationFootstepInt);
	flCycle = g_Config.GetFloat(sKeyAnimationCycle);
	return true;
}

stock bool GetProfileBlendAnimationSpeed(const char[] profile, int iAnimationSection, float &flPlaybackRate, int iAnimationIndex = -1)
{
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	char sAnimationSection[20], sKeyAnimationPlayBackRate[65];
	switch (iAnimationSection)
	{
		case ChaserAnimation_IdleAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "idle");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_idle_playbackrate");
		}
		case ChaserAnimation_WalkAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "walk");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_walk_playbackrate");
		}
		case ChaserAnimation_WalkAlertAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "walkalert");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_walkalert_playbackrate");
		}
		case ChaserAnimation_AttackAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "attack");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_attack_playbackrate");
		}
		case ChaserAnimation_ShootAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "shoot");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_shoot_playbackrate");
		}
		case ChaserAnimation_RunAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "run");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_run_playbackrate");
		}
		case ChaserAnimation_ChaseInitialAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "chaseinitial");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_chaseinitial_playbackrate");
		}
		case ChaserAnimation_RageAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "rage");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_rage_playbackrate");
		}
		case ChaserAnimation_StunAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "stun");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_stun_playbackrate");
		}
		case ChaserAnimation_DeathAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "death");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_death_playbackrate");
		}
		case ChaserAnimation_JumpAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "jump");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_jump_playbackrate");
		}
		case ChaserAnimation_SpawnAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "spawn");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_spawn_playbackrate");
		}
		case ChaserAnimation_HealAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "heal");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_heal_playbackrate");
		}
		case ChaserAnimation_DeathcamAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "deathcam");
			strcopy(sKeyAnimationPlayBackRate, sizeof(sKeyAnimationPlayBackRate), "blend_animation_deathcam_playbackrate");
		}
	}
	
	if (g_Config.JumpToKey("animations"))
	{
		if (g_Config.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_Config.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_Config.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_Config.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	flPlaybackRate = g_Config.GetFloat(sKeyAnimationPlayBackRate, 1.0);
	return true;
}
