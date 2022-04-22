#if defined _sf2_profiles_chaser_precache
 #endinput
#endif

#define _sf2_profiles_chaser_precache

/**
 *	Parses and stores the unique values of a chaser profile from the current position in the profiles config.
 *	Returns true if loading was successful, false if not.
 */
public bool LoadChaserBossProfile(KeyValues kv, const char[] sProfile, int &iUniqueProfileIndex, char[] sLoadFailReasonBuffer)
{
	sLoadFailReasonBuffer[0] = '\0';
	
	iUniqueProfileIndex = g_hChaserProfileData.Push(-1);
	g_hChaserProfileNames.SetValue(sProfile, iUniqueProfileIndex);
	
	float flBossDefaultWalkSpeed = kv.GetFloat("walkspeed", 30.0);
	float flBossWalkSpeedEasy = kv.GetFloat("walkspeed_easy", flBossDefaultWalkSpeed);
	float flBossWalkSpeedHard = kv.GetFloat("walkspeed_hard", flBossDefaultWalkSpeed);
	float flBossWalkSpeedInsane = kv.GetFloat("walkspeed_insane", flBossWalkSpeedHard);
	float flBossWalkSpeedNightmare = kv.GetFloat("walkspeed_nightmare", flBossWalkSpeedInsane);
	float flBossWalkSpeedApollyon = kv.GetFloat("walkspeed_apollyon", flBossWalkSpeedNightmare);
	
	float flBossDefaultMaxWalkSpeed = kv.GetFloat("walkspeed_max", 30.0);
	float flBossMaxWalkSpeedEasy = kv.GetFloat("walkspeed_max_easy", flBossDefaultMaxWalkSpeed);
	float flBossMaxWalkSpeedHard = kv.GetFloat("walkspeed_max_hard", flBossDefaultMaxWalkSpeed);
	float flBossMaxWalkSpeedInsane = kv.GetFloat("walkspeed_max_insane", flBossMaxWalkSpeedHard);
	float flBossMaxWalkSpeedNightmare = kv.GetFloat("walkspeed_max_nightmare", flBossMaxWalkSpeedInsane);
	float flBossMaxWalkSpeedApollyon = kv.GetFloat("walkspeed_max_apollyon", flBossMaxWalkSpeedNightmare);

	float flWakeRange = kv.GetFloat("wake_radius");
	if (flWakeRange < 0.0) flWakeRange = 0.0;
	
	float flAlertGracetime = kv.GetFloat("search_alert_gracetime", 0.5);
	float flAlertGracetimeEasy = kv.GetFloat("search_alert_gracetime_easy", flAlertGracetime);
	float flAlertGracetimeHard = kv.GetFloat("search_alert_gracetime_hard", flAlertGracetime);
	float flAlertGracetimeInsane = kv.GetFloat("search_alert_gracetime_insane", flAlertGracetimeHard);
	float flAlertGracetimeNightmare = kv.GetFloat("search_alert_gracetime_nightmare", flAlertGracetimeInsane);
	float flAlertGracetimeApollyon = kv.GetFloat("search_alert_gracetime_apollyon", flAlertGracetimeNightmare);
	
	float flAlertDuration = kv.GetFloat("search_alert_duration", 5.0);
	float flAlertDurationEasy = kv.GetFloat("search_alert_duration_easy", flAlertDuration);
	float flAlertDurationHard = kv.GetFloat("search_alert_duration_hard", flAlertDuration);
	float flAlertDurationInsane = kv.GetFloat("search_alert_duration_insane", flAlertDurationHard);
	float flAlertDurationNightmare = kv.GetFloat("search_alert_duration_nightmare", flAlertDurationInsane);
	float flAlertDurationApollyon = kv.GetFloat("search_alert_duration_apollyon", flAlertDurationNightmare);
	
	float flChaseDuration = kv.GetFloat("search_chase_duration", 10.0);
	float flChaseDurationEasy = kv.GetFloat("search_chase_duration_easy", flChaseDuration);
	float flChaseDurationHard = kv.GetFloat("search_chase_duration_hard", flChaseDuration);
	float flChaseDurationInsane = kv.GetFloat("search_chase_duration_insane", flChaseDurationHard);
	float flChaseDurationNightmare = kv.GetFloat("search_chase_duration_nightmare", flChaseDurationInsane);
	float flChaseDurationApollyon = kv.GetFloat("search_chase_duration_apollyon", flChaseDurationNightmare);

	float flWanderRangeMin = kv.GetFloat("search_wander_range_min", 400.0);
	float flWanderRangeMinEasy = kv.GetFloat("search_wander_range_min_easy", flWanderRangeMin);
	float flWanderRangeMinHard = kv.GetFloat("search_wander_range_min_hard", flWanderRangeMin);
	float flWanderRangeMinInsane = kv.GetFloat("search_wander_range_min_insane", flWanderRangeMinHard);
	float flWanderRangeMinNightmare = kv.GetFloat("search_wander_range_min_nightmare", flWanderRangeMinInsane);
	float flWanderRangeMinApollyon = kv.GetFloat("search_wander_range_min_apollyon", flWanderRangeMinNightmare);

	float flWanderRangeMax = kv.GetFloat("search_wander_range_max", 1024.0);
	float flWanderRangeMaxEasy = kv.GetFloat("search_wander_range_max_easy", flWanderRangeMax);
	float flWanderRangeMaxHard = kv.GetFloat("search_wander_range_max_hard", flWanderRangeMax);
	float flWanderRangeMaxInsane = kv.GetFloat("search_wander_range_max_insane", flWanderRangeMaxHard);
	float flWanderRangeMaxNightmare = kv.GetFloat("search_wander_range_max_nightmare", flWanderRangeMaxInsane);
	float flWanderRangeMaxApollyon = kv.GetFloat("search_wander_range_max_apollyon", flWanderRangeMaxNightmare);

	float flWanderTimeMin = kv.GetFloat("search_wander_time_min", 3.0);
	float flWanderTimeMinEasy = kv.GetFloat("search_wander_time_min_easy", flWanderTimeMin);
	float flWanderTimeMinHard = kv.GetFloat("search_wander_time_min_hard", flWanderTimeMin);
	float flWanderTimeMinInsane = kv.GetFloat("search_wander_time_min_insane", flWanderTimeMinHard);
	float flWanderTimeMinNightmare = kv.GetFloat("search_wander_time_min_nightmare", flWanderTimeMinInsane);
	float flWanderTimeMinApollyon = kv.GetFloat("search_wander_time_min_apollyon", flWanderTimeMinNightmare);

	float flWanderTimeMax = kv.GetFloat("search_wander_time_max", 4.5);
	float flWanderTimeMaxEasy = kv.GetFloat("search_wander_time_max_easy", flWanderTimeMax);
	float flWanderTimeMaxHard = kv.GetFloat("search_wander_time_max_hard", flWanderTimeMax);
	float flWanderTimeMaxInsane = kv.GetFloat("search_wander_time_max_insane", flWanderTimeMaxHard);
	float flWanderTimeMaxNightmare = kv.GetFloat("search_wander_time_max_nightmare", flWanderTimeMaxInsane);
	float flWanderTimeMaxApollyon = kv.GetFloat("search_wander_time_max_apollyon", flWanderTimeMaxNightmare);

	bool bCanBeStunned = view_as<bool>(kv.GetNum("stun_enabled"));
	
	float flStunDuration = kv.GetFloat("stun_duration");
	if (flStunDuration < 0.0) flStunDuration = 0.0;
	
	float flStunCooldown = kv.GetFloat("stun_cooldown", 3.5);
	if (flStunCooldown < 0.0) flStunCooldown = 0.0;
	
	float flStunHealth = kv.GetFloat("stun_health");
	if (flStunHealth < 0.0) flStunHealth = 0.0;
	float flStunHealthPerPlayer = kv.GetFloat("stun_health_per_player");
	if (flStunHealthPerPlayer < 0.0) flStunHealthPerPlayer = 0.0;
	
	bool bStunTakeDamageFromFlashlight = view_as<bool>(kv.GetNum("stun_damage_flashlight_enabled"));
	
	float flStunFlashlightDamage = kv.GetFloat("stun_damage_flashlight");

	bool bItemDrop = view_as<bool>(kv.GetNum("drop_item_on_stun"));
	int iItemDropType = kv.GetNum("drop_item_type", 1);
	if (iItemDropType < 1) iItemDropType = 1;
	if (iItemDropType > 7) iItemDropType = 7;
	
	bool bKeyDrop = view_as<bool>(kv.GetNum("keydrop_enabled"));
	
	bool bCanCloak = view_as<bool>(kv.GetNum("cloak_enable"));
	
	float flBossDefaultCloakCooldown = kv.GetFloat("cloak_cooldown", 8.0);
	float flBossCloakCooldownEasy = kv.GetFloat("cloak_cooldown_easy", flBossDefaultCloakCooldown);
	float flBossCloakCooldownHard = kv.GetFloat("cloak_cooldown_hard", flBossDefaultCloakCooldown);
	float flBossCloakCooldownInsane = kv.GetFloat("cloak_cooldown_insane", flBossCloakCooldownHard);
	float flBossCloakCooldownNightmare = kv.GetFloat("cloak_cooldown_nightmare", flBossCloakCooldownInsane);
	float flBossCloakCooldownApollyon = kv.GetFloat("cloak_cooldown_apollyon", flBossCloakCooldownNightmare);
	
	float flBossDefaultCloakRange = kv.GetFloat("cloak_range", 350.0);
	float flBossCloakRangeEasy = kv.GetFloat("cloak_range_easy", flBossDefaultCloakRange);
	float flBossCloakRangeHard = kv.GetFloat("cloak_range_hard", flBossDefaultCloakRange);
	float flBossCloakRangeInsane = kv.GetFloat("cloak_range_insane", flBossCloakRangeHard);
	float flBossCloakRangeNightmare = kv.GetFloat("cloak_range_nightmare", flBossCloakRangeInsane);
	float flBossCloakRangeApollyon = kv.GetFloat("cloak_range_apollyon", flBossCloakRangeNightmare);

	float flBossDefaultDecloakRange = kv.GetFloat("cloak_decloak_range", 150.0);
	float flBossDecloakRangeEasy = kv.GetFloat("cloak_decloak_range_easy", flBossDefaultDecloakRange);
	float flBossDecloakRangeHard = kv.GetFloat("cloak_decloak_range_hard", flBossDefaultDecloakRange);
	float flBossDecloakRangeInsane = kv.GetFloat("cloak_decloak_range_insane", flBossDecloakRangeHard);
	float flBossDecloakRangeNightmare = kv.GetFloat("cloak_decloak_range_nightmare", flBossDecloakRangeInsane);
	float flBossDecloakRangeApollyon = kv.GetFloat("cloak_decloak_range_apollyon", flBossDecloakRangeNightmare);

	float flBossDefaultCloakDuration = kv.GetFloat("cloak_duration", 10.0);
	float flBossCloakDurationEasy = kv.GetFloat("cloak_duration_easy", flBossDefaultCloakDuration);
	float flBossCloakDurationHard = kv.GetFloat("cloak_duration_hard", flBossDefaultCloakDuration);
	float flBossCloakDurationInsane = kv.GetFloat("cloak_duration_insane", flBossCloakDurationHard);
	float flBossCloakDurationNightmare = kv.GetFloat("cloak_duration_nightmare", flBossCloakDurationInsane);
	float flBossCloakDurationApollyon = kv.GetFloat("cloak_duration_apollyon", flBossCloakDurationNightmare);

	float flBossDefaultCloakSpeedMultiplier = kv.GetFloat("cloak_speed_multiplier", 1.0);
	float flBossCloakSpeedMultiplierEasy = kv.GetFloat("cloak_speed_multiplier_easy", flBossDefaultCloakSpeedMultiplier);
	float flBossCloakSpeedMultiplierHard = kv.GetFloat("cloak_speed_multiplier_hard", flBossDefaultCloakSpeedMultiplier);
	float flBossCloakSpeedMultiplierInsane = kv.GetFloat("cloak_speed_multiplier_insane", flBossCloakSpeedMultiplierHard);
	float flBossCloakSpeedMultiplierNightmare = kv.GetFloat("cloak_speed_multiplier_nightmare", flBossCloakSpeedMultiplierInsane);
	float flBossCloakSpeedMultiplierApollyon = kv.GetFloat("cloak_speed_multiplier_apollyon", flBossCloakSpeedMultiplierNightmare);
	
	bool bProjectileEnable = view_as<bool>(kv.GetNum("projectile_enable"));
	
	float flProjectileCooldownMin = kv.GetFloat("projectile_cooldown_min", 1.0);
	float flProjectileCooldownMinEasy = kv.GetFloat("projectile_cooldown_min_easy", flProjectileCooldownMin);
	float flProjectileCooldownMinHard = kv.GetFloat("projectile_cooldown_min_hard", flProjectileCooldownMin);
	float flProjectileCooldownMinInsane = kv.GetFloat("projectile_cooldown_min_insane", flProjectileCooldownMinHard);
	float flProjectileCooldownMinNightmare = kv.GetFloat("projectile_cooldown_min_nightmare", flProjectileCooldownMinInsane);
	float flProjectileCooldownMinApollyon = kv.GetFloat("projectile_cooldown_min_apollyon", flProjectileCooldownMinNightmare);
	
	float flProjectileCooldownMax = kv.GetFloat("projectile_cooldown_max", 2.0);
	float flProjectileCooldownMaxEasy = kv.GetFloat("projectile_cooldown_max_easy", flProjectileCooldownMax);
	float flProjectileCooldownMaxHard = kv.GetFloat("projectile_cooldown_max_hard", flProjectileCooldownMax);
	float flProjectileCooldownMaxInsane = kv.GetFloat("projectile_cooldown_max_insane", flProjectileCooldownMaxHard);
	float flProjectileCooldownMaxNightmare = kv.GetFloat("projectile_cooldown_max_nightmare", flProjectileCooldownMaxInsane);
	float flProjectileCooldownMaxApollyon = kv.GetFloat("projectile_cooldown_max_apollyon", flProjectileCooldownMaxNightmare);
	
	float flIceballSlowdownDuration = kv.GetFloat("projectile_iceslow_duration", 2.0);
	float flIceballSlowdownDurationEasy = kv.GetFloat("projectile_iceslow_duration_easy", flIceballSlowdownDuration);
	float flIceballSlowdownDurationHard = kv.GetFloat("projectile_iceslow_duration_hard", flIceballSlowdownDuration);
	float flIceballSlowdownDurationInsane = kv.GetFloat("projectile_iceslow_duration_insane", flIceballSlowdownDurationHard);
	float flIceballSlowdownDurationNightmare = kv.GetFloat("projectile_iceslow_duration_nightmare", flIceballSlowdownDurationInsane);
	float flIceballSlowdownDurationApollyon = kv.GetFloat("projectile_iceslow_duration_apollyon", flIceballSlowdownDurationNightmare);
	
	float flIceballSlowdownPercent = kv.GetFloat("projectile_iceslow_percent", 0.55);
	float flIceballSlowdownPercentEasy = kv.GetFloat("projectile_iceslow_percent_easy", flIceballSlowdownPercent);
	float flIceballSlowdownPercentHard = kv.GetFloat("projectile_iceslow_percent_hard", flIceballSlowdownPercent);
	float flIceballSlowdownPercentInsane = kv.GetFloat("projectile_iceslow_percent_insane", flIceballSlowdownPercentHard);
	float flIceballSlowdownPercentNightmare = kv.GetFloat("projectile_iceslow_percent_nightmare", flIceballSlowdownPercentInsane);
	float flIceballSlowdownPercentApollyon = kv.GetFloat("projectile_iceslow_percent_apollyon", flIceballSlowdownPercentNightmare);

	float flProjectileSpeed = kv.GetFloat("projectile_speed", 400.0);
	float flProjectileSpeedEasy = kv.GetFloat("projectile_speed_easy", flProjectileSpeed);
	float flProjectileSpeedHard = kv.GetFloat("projectile_speed_hard", flProjectileSpeed);
	float flProjectileSpeedInsane = kv.GetFloat("projectile_speed_insane", flProjectileSpeedHard);
	float flProjectileSpeedNightmare = kv.GetFloat("projectile_speed_nightmare", flProjectileSpeedInsane);
	float flProjectileSpeedApollyon = kv.GetFloat("projectile_speed_apollyon", flProjectileSpeedNightmare);

	float flProjectileDamage = kv.GetFloat("projectile_damage", 50.0);
	float flProjectileDamageEasy = kv.GetFloat("projectile_damage_easy", flProjectileDamage);
	float flProjectileDamageHard = kv.GetFloat("projectile_damage_hard", flProjectileDamage);
	float flProjectileDamageInsane = kv.GetFloat("projectile_damage_insane", flProjectileDamageHard);
	float flProjectileDamageNightmare = kv.GetFloat("projectile_damage_nightmare", flProjectileDamageInsane);
	float flProjectileDamageApollyon = kv.GetFloat("projectile_damage_apollyon", flProjectileDamageNightmare);

	float flProjectileRadius = kv.GetFloat("projectile_damageradius", 128.0);
	float flProjectileRadiusEasy = kv.GetFloat("projectile_damageradius_easy", flProjectileRadius);
	float flProjectileRadiusHard = kv.GetFloat("projectile_damageradius_hard", flProjectileRadius);
	float flProjectileRadiusInsane = kv.GetFloat("projectile_damageradius_insane", flProjectileRadiusHard);
	float flProjectileRadiusNightmare = kv.GetFloat("projectile_damageradius_nightmare", flProjectileRadiusInsane);
	float flProjectileRadiusApollyon = kv.GetFloat("projectile_damageradius_apollyon", flProjectileRadiusNightmare);

	float flProjectileDeviation = kv.GetFloat("projectile_deviation", 0.0);
	float flProjectileDeviationEasy = kv.GetFloat("projectile_deviation_easy", flProjectileDeviation);
	float flProjectileDeviationHard = kv.GetFloat("projectile_deviation_hard", flProjectileDeviation);
	float flProjectileDeviationInsane = kv.GetFloat("projectile_deviation_insane", flProjectileDeviationHard);
	float flProjectileDeviationNightmare = kv.GetFloat("projectile_deviation_nightmare", flProjectileDeviationInsane);
	float flProjectileDeviationApollyon = kv.GetFloat("projectile_deviation_apollyon", flProjectileDeviationNightmare);

	int iProjectileCount = kv.GetNum("projectile_count", 1);
	if (iProjectileCount < 1) iProjectileCount = 1;
	int iProjectileCountEasy = kv.GetNum("projectile_count_easy", iProjectileCount);
	if (iProjectileCountEasy < 1) iProjectileCountEasy = 1;
	int iProjectileCountHard = kv.GetNum("projectile_count_hard", iProjectileCount);
	if (iProjectileCountHard < 1) iProjectileCountHard = 1;
	int iProjectileCountInsane = kv.GetNum("projectile_count_insane", iProjectileCountHard);
	if (iProjectileCountInsane < 1) iProjectileCountInsane = 1;
	int iProjectileCountNightmare = kv.GetNum("projectile_count_nightmare", iProjectileCountInsane);
	if (iProjectileCountNightmare < 1) iProjectileCountNightmare = 1;
	int iProjectileCountApollyon = kv.GetNum("projectile_count_apollyon", iProjectileCountNightmare);
	if (iProjectileCountApollyon < 1) iProjectileCountApollyon = 1;
	
	bool bRocketCritical = view_as<bool>(kv.GetNum("enable_crit_rockets"));
	bool bUseShootGesture = view_as<bool>(kv.GetNum("use_gesture_shoot"));
	
	bool bEnableProjectileClips = view_as<bool>(kv.GetNum("projectile_clips_enable"));
	
	int iProjectileClips = kv.GetNum("projectile_ammo_loaded", 3);
	int iProjectileClipsEasy = kv.GetNum("projectile_ammo_loaded_easy", iProjectileClips);
	int iProjectileClipsHard = kv.GetNum("projectile_ammo_loaded_hard", iProjectileClips);
	int iProjectileClipsInsane = kv.GetNum("projectile_ammo_loaded_insane", iProjectileClipsHard);
	int iProjectileClipsNightmare = kv.GetNum("projectile_ammo_loaded_nightmare", iProjectileClipsInsane);
	int iProjectileClipsApollyon = kv.GetNum("projectile_ammo_loaded_apollyon", iProjectileClipsNightmare);
	
	float flProjectilesReload = kv.GetFloat("projectile_reload_time", 2.0);
	float flProjectilesReloadEasy = kv.GetFloat("projectile_reload_time_easy", flProjectilesReload);
	float flProjectilesReloadHard = kv.GetFloat("projectile_reload_time_hard", flProjectilesReload);
	float flProjectilesReloadInsane = kv.GetFloat("projectile_reload_time_insane", flProjectilesReloadHard);
	float flProjectilesReloadNightmare = kv.GetFloat("projectile_reload_time_nightmare", flProjectilesReloadInsane);
	float flProjectilesReloadApollyon = kv.GetFloat("projectile_reload_time_apollyon", flProjectilesReloadNightmare);
	
	bool bEnableChargeUpProjectiles = view_as<bool>(kv.GetNum("projectile_chargeup_enable"));
	
	float flProjectileChargeUpDuration = kv.GetFloat("projectile_chargeup_duration", 5.0);
	float flProjectileChargeUpDurationEasy = kv.GetFloat("projectile_chargeup_duration_easy", flProjectileChargeUpDuration);
	float flProjectileChargeUpDurationHard = kv.GetFloat("projectile_chargeup_duration_hard", flProjectileChargeUpDuration);
	float flProjectileChargeUpDurationInsane = kv.GetFloat("projectile_chargeup_duration_insane", flProjectileChargeUpDurationHard);
	float flProjectileChargeUpDurationNightmare = kv.GetFloat("projectile_chargeup_duration_nightmare", flProjectileChargeUpDurationInsane);
	float flProjectileChargeUpDurationApollyon = kv.GetFloat("projectile_chargeup_duration_apollyon", flProjectileChargeUpDurationNightmare);
	
	bool bAdvancedDamageEffectsEnabled = view_as<bool>(kv.GetNum("player_damage_effects"));
	bool bAdvancedDamageEffectsRandom = view_as<bool>(kv.GetNum("player_damage_random_effects"));
	bool bAdvancedDamageEffectsParticles = view_as<bool>(kv.GetNum("player_attach_particle", 1));
	
	int iRandomEffectAttackIndexes = kv.GetNum("player_random_attack_indexes", 1);
	if (iRandomEffectAttackIndexes < 0) iRandomEffectAttackIndexes = 1;
	
	float flRandomEffectDurationNormal = kv.GetFloat("player_random_duration");
	float flRandomEffectDurationEasy = kv.GetFloat("player_random_duration_easy", flRandomEffectDurationNormal);
	float flRandomEffectDurationHard = kv.GetFloat("player_random_duration_hard", flRandomEffectDurationNormal);
	float flRandomEffectDurationInsane = kv.GetFloat("player_random_duration_insane", flRandomEffectDurationHard);
	float flRandomEffectDurationNightmare = kv.GetFloat("player_random_duration_nightmare", flRandomEffectDurationInsane);
	float flRandomEffectDurationApollyon = kv.GetFloat("player_random_duration_apollyon", flRandomEffectDurationNightmare);
	
	float flRandomEffectSlowdownNormal = kv.GetFloat("player_random_slowdown");
	if (flRandomEffectSlowdownNormal > 1.0) flRandomEffectSlowdownNormal = 1.0;
	if (flRandomEffectSlowdownNormal < 0.0) flRandomEffectSlowdownNormal = 0.0;
	float flRandomEffectSlowdownEasy = kv.GetFloat("player_random_slowdown_easy", flRandomEffectSlowdownNormal);
	if (flRandomEffectSlowdownEasy > 1.0) flRandomEffectSlowdownEasy = 1.0;
	if (flRandomEffectSlowdownEasy < 0.0) flRandomEffectSlowdownEasy = 0.0;
	float flRandomEffectSlowdownHard = kv.GetFloat("player_random_slowdown_hard", flRandomEffectSlowdownNormal);
	if (flRandomEffectSlowdownHard > 1.0) flRandomEffectSlowdownHard = 1.0;
	if (flRandomEffectSlowdownHard < 0.0) flRandomEffectSlowdownHard = 0.0;
	float flRandomEffectSlowdownInsane = kv.GetFloat("player_random_slowdown_insane", flRandomEffectSlowdownHard);
	if (flRandomEffectSlowdownInsane > 1.0) flRandomEffectSlowdownInsane = 1.0;
	if (flRandomEffectSlowdownInsane < 0.0) flRandomEffectSlowdownInsane = 0.0;
	float flRandomEffectSlowdownNightmare = kv.GetFloat("player_random_slowdown_nightmare", flRandomEffectSlowdownInsane);
	if (flRandomEffectSlowdownNightmare > 1.0) flRandomEffectSlowdownNightmare = 1.0;
	if (flRandomEffectSlowdownNightmare < 0.0) flRandomEffectSlowdownNightmare = 0.0;
	float flRandomEffectSlowdownApollyon = kv.GetFloat("player_random_slowdown_apollyon", flRandomEffectSlowdownNightmare);
	if (flRandomEffectSlowdownApollyon > 1.0) flRandomEffectSlowdownApollyon = 1.0;
	if (flRandomEffectSlowdownApollyon < 0.0) flRandomEffectSlowdownApollyon = 0.0;
	
	int iRandomStunType = kv.GetNum("player_random_stun_type");
	if (iRandomStunType < 0) iRandomStunType = 0;
	if (iRandomStunType > 3) iRandomStunType = 3;
	
	bool bJaratePlayerAdvanced = view_as<bool>(kv.GetNum("player_jarate_on_hit"));
	
	int iJaratePlayerAttackIndexes = kv.GetNum("player_jarate_attack_indexs", 1);
	if (iJaratePlayerAttackIndexes < 0) iJaratePlayerAttackIndexes = 1;
	
	float flJaratePlayerDurationNormal = kv.GetFloat("player_jarate_duration");
	float flJaratePlayerDurationEasy = kv.GetFloat("player_jarate_duration_easy", flJaratePlayerDurationNormal);
	float flJaratePlayerDurationHard = kv.GetFloat("player_jarate_duration_hard", flJaratePlayerDurationNormal);
	float flJaratePlayerDurationInsane = kv.GetFloat("player_jarate_duration_insane", flJaratePlayerDurationHard);
	float flJaratePlayerDurationNightmare = kv.GetFloat("player_jarate_duration_nightmare", flJaratePlayerDurationInsane);
	float flJaratePlayerDurationApollyon = kv.GetFloat("player_jarate_duration_apollyon", flJaratePlayerDurationNightmare);

	bool bJaratePlayerParticleBeam = view_as<bool>(kv.GetNum("player_jarate_beam_particle"));

	bool bMilkPlayerAdvanced = view_as<bool>(kv.GetNum("player_milk_on_hit"));
	
	int iMilkPlayerAttackIndexes = kv.GetNum("player_milk_attack_indexs", 1);
	if (iMilkPlayerAttackIndexes < 0) iMilkPlayerAttackIndexes = 1;
	
	float flMilkPlayerDurationNormal = kv.GetFloat("player_milk_duration");
	float flMilkPlayerDurationEasy = kv.GetFloat("player_milk_duration_easy", flMilkPlayerDurationNormal);
	float flMilkPlayerDurationHard = kv.GetFloat("player_milk_duration_hard", flMilkPlayerDurationNormal);
	float flMilkPlayerDurationInsane = kv.GetFloat("player_milk_duration_insane", flMilkPlayerDurationHard);
	float flMilkPlayerDurationNightmare = kv.GetFloat("player_milk_duration_nightmare", flMilkPlayerDurationInsane);
	float flMilkPlayerDurationApollyon = kv.GetFloat("player_milk_duration_apollyon", flMilkPlayerDurationNightmare);

	bool bMilkPlayerParticleBeam = view_as<bool>(kv.GetNum("player_milk_beam_particle"));

	bool bGasPlayerAdvanced = view_as<bool>(kv.GetNum("player_gas_on_hit"));
	
	int iGasPlayerAttackIndexes = kv.GetNum("player_gas_attack_indexs", 1);
	if (iGasPlayerAttackIndexes < 0) iGasPlayerAttackIndexes = 1;
	
	float flGasPlayerDurationNormal = kv.GetFloat("player_gas_duration");
	float flGasPlayerDurationEasy = kv.GetFloat("player_gas_duration_easy", flGasPlayerDurationNormal);
	float flGasPlayerDurationHard = kv.GetFloat("player_gas_duration_hard", flGasPlayerDurationNormal);
	float flGasPlayerDurationInsane = kv.GetFloat("player_gas_duration_insane", flGasPlayerDurationHard);
	float flGasPlayerDurationNightmare = kv.GetFloat("player_gas_duration_nightmare", flGasPlayerDurationInsane);
	float flGasPlayerDurationApollyon = kv.GetFloat("player_gas_duration_apollyon", flGasPlayerDurationNightmare);

	bool bGasPlayerParticleBeam = view_as<bool>(kv.GetNum("player_gas_beam_particle"));

	bool bMarkPlayerAdvanced = view_as<bool>(kv.GetNum("player_mark_on_hit"));
	
	int iMarkPlayerAttackIndexes = kv.GetNum("player_mark_attack_indexs", 1);
	if (iMarkPlayerAttackIndexes < 0) iMarkPlayerAttackIndexes = 1;
	
	float flMarkPlayerDurationNormal = kv.GetFloat("player_mark_duration");
	float flMarkPlayerDurationEasy = kv.GetFloat("player_mark_duration_easy", flMarkPlayerDurationNormal);
	float flMarkPlayerDurationHard = kv.GetFloat("player_mark_duration_hard", flMarkPlayerDurationNormal);
	float flMarkPlayerDurationInsane = kv.GetFloat("player_mark_duration_insane", flMarkPlayerDurationHard);
	float flMarkPlayerDurationNightmare = kv.GetFloat("player_mark_duration_nightmare", flMarkPlayerDurationInsane);
	float flMarkPlayerDurationApollyon = kv.GetFloat("player_mark_duration_apollyon", flMarkPlayerDurationNightmare);

	bool bSilentMarkPlayerAdvanced = view_as<bool>(kv.GetNum("player_silent_mark_on_hit"));
	
	int iSilentMarkPlayerAttackIndexes = kv.GetNum("player_silent_mark_attack_indexs", 1);
	if (iSilentMarkPlayerAttackIndexes < 0) iSilentMarkPlayerAttackIndexes = 1;
	
	float flSilentMarkPlayerDurationNormal = kv.GetFloat("player_silent_mark_duration");
	float flSilentMarkPlayerDurationEasy = kv.GetFloat("player_silent_mark_duration_easy", flSilentMarkPlayerDurationNormal);
	float flSilentMarkPlayerDurationHard = kv.GetFloat("player_silent_mark_duration_hard", flSilentMarkPlayerDurationNormal);
	float flSilentMarkPlayerDurationInsane = kv.GetFloat("player_silent_mark_duration_insane", flSilentMarkPlayerDurationHard);
	float flSilentMarkPlayerDurationNightmare = kv.GetFloat("player_silent_mark_duration_nightmare", flSilentMarkPlayerDurationInsane);
	float flSilentMarkPlayerDurationApollyon = kv.GetFloat("player_silent_mark_duration_apollyon", flSilentMarkPlayerDurationNightmare);

	bool bIgnitePlayerAdvanced = view_as<bool>(kv.GetNum("player_ignite_on_hit"));
	
	int iIgnitePlayerAttackIndexes = kv.GetNum("player_ignite_attack_indexs", 1);
	if (iIgnitePlayerAttackIndexes < 0) iIgnitePlayerAttackIndexes = 1;
	
	float flIgnitePlayerDelayNormal = kv.GetFloat("player_ignite_delay");
	float flIgnitePlayerDelayEasy = kv.GetFloat("player_ignite_delay_easy", flIgnitePlayerDelayNormal);
	float flIgnitePlayerDelayHard = kv.GetFloat("player_ignite_delay_hard", flIgnitePlayerDelayNormal);
	float flIgnitePlayerDelayInsane = kv.GetFloat("player_ignite_delay_insane", flIgnitePlayerDelayHard);
	float flIgnitePlayerDelayNightmare = kv.GetFloat("player_ignite_delay_nightmare", flIgnitePlayerDelayInsane);
	float flIgnitePlayerDelayApollyon = kv.GetFloat("player_ignite_delay_apollyon", flIgnitePlayerDelayNightmare);

	bool bStunPlayerAdvanced = view_as<bool>(kv.GetNum("player_stun_on_hit"));
	
	int iStunPlayerType = kv.GetNum("player_stun_type");
	if (iStunPlayerType < 0) iStunPlayerType = 0;
	if (iStunPlayerType > 3) iStunPlayerType = 3;
	
	int iStunPlayerAttackIndexes = kv.GetNum("player_stun_attack_indexs", 1);
	if (iStunPlayerAttackIndexes < 0) iStunPlayerAttackIndexes = 1;
	
	float flStunPlayerDurationNormal = kv.GetFloat("player_stun_duration");
	float flStunPlayerDurationEasy = kv.GetFloat("player_stun_duration_easy", flStunPlayerDurationNormal);
	float flStunPlayerDurationHard = kv.GetFloat("player_stun_duration_hard", flStunPlayerDurationNormal);
	float flStunPlayerDurationInsane = kv.GetFloat("player_stun_duration_insane", flStunPlayerDurationHard);
	float flStunPlayerDurationNightmare = kv.GetFloat("player_stun_duration_nightmare", flStunPlayerDurationInsane);
	float flStunPlayerDurationApollyon = kv.GetFloat("player_stun_duration_apollyon", flStunPlayerDurationNightmare);
	
	float flStunPlayerSlowdownNormal = kv.GetFloat("player_stun_slowdown");
	if (flStunPlayerSlowdownNormal > 1.0) flStunPlayerSlowdownNormal = 1.0;
	if (flStunPlayerSlowdownNormal < 0.0) flStunPlayerSlowdownNormal = 0.0;
	float flStunPlayerSlowdownEasy = kv.GetFloat("player_stun_slowdown_easy", flStunPlayerSlowdownNormal);
	if (flStunPlayerSlowdownEasy > 1.0) flStunPlayerSlowdownEasy = 1.0;
	if (flStunPlayerSlowdownEasy < 0.0) flStunPlayerSlowdownEasy = 0.0;
	float flStunPlayerSlowdownHard = kv.GetFloat("player_stun_slowdown_hard", flStunPlayerSlowdownNormal);
	if (flStunPlayerSlowdownHard > 1.0) flStunPlayerSlowdownHard = 1.0;
	if (flStunPlayerSlowdownHard < 0.0) flStunPlayerSlowdownHard = 0.0;
	float flStunPlayerSlowdownInsane = kv.GetFloat("player_stun_slowdown_insane", flStunPlayerSlowdownHard);
	if (flStunPlayerSlowdownInsane > 1.0) flStunPlayerSlowdownInsane = 1.0;
	if (flStunPlayerSlowdownInsane < 0.0) flStunPlayerSlowdownInsane = 0.0;
	float flStunPlayerSlowdownNightmare = kv.GetFloat("player_stun_slowdown_nightmare", flStunPlayerSlowdownInsane);
	if (flStunPlayerSlowdownNightmare > 1.0) flStunPlayerSlowdownNightmare = 1.0;
	if (flStunPlayerSlowdownNightmare < 0.0) flStunPlayerSlowdownNightmare = 0.0;
	float flStunPlayerSlowdownApollyon = kv.GetFloat("player_stun_slowdown_apollyon", flStunPlayerSlowdownNightmare);
	if (flStunPlayerSlowdownApollyon > 1.0) flStunPlayerSlowdownApollyon = 1.0;
	if (flStunPlayerSlowdownApollyon < 0.0) flStunPlayerSlowdownApollyon = 0.0;

	bool bStunPlayerParticleBeam = view_as<bool>(kv.GetNum("player_stun_beam_particle"));

	bool bBleedPlayerAdvanced = view_as<bool>(kv.GetNum("player_bleed_on_hit"));
	
	int iBleedPlayerAttackIndexes = kv.GetNum("player_bleed_attack_indexs", 1);
	if (iBleedPlayerAttackIndexes < 0) iBleedPlayerAttackIndexes = 1;
	
	float flBleedPlayerDurationNormal = kv.GetFloat("player_bleed_duration");
	float flBleedPlayerDurationEasy = kv.GetFloat("player_bleed_duration_easy", flBleedPlayerDurationNormal);
	float flBleedPlayerDurationHard = kv.GetFloat("player_bleed_duration_hard", flBleedPlayerDurationNormal);
	float flBleedPlayerDurationInsane = kv.GetFloat("player_bleed_duration_insane", flBleedPlayerDurationHard);
	float flBleedPlayerDurationNightmare = kv.GetFloat("player_bleed_duration_nightmare", flBleedPlayerDurationInsane);
	float flBleedPlayerDurationApollyon = kv.GetFloat("player_bleed_duration_apollyon", flBleedPlayerDurationNightmare);

	bool bEletricPlayerAdvanced = view_as<bool>(kv.GetNum("player_electric_slow_on_hit"));
	
	int iEletricPlayerAttackIndexes = kv.GetNum("player_electrocute_attack_indexs", 1);
	if (iEletricPlayerAttackIndexes < 0) iEletricPlayerAttackIndexes = 1;
	
	float flEletricPlayerDurationNormal = kv.GetFloat("player_electric_slow_duration");
	float flEletricPlayerDurationEasy = kv.GetFloat("player_electric_slow_duration_easy", flEletricPlayerDurationNormal);
	float flEletricPlayerDurationHard = kv.GetFloat("player_electric_slow_duration_hard", flEletricPlayerDurationNormal);
	float flEletricPlayerDurationInsane = kv.GetFloat("player_electric_slow_duration_insane", flEletricPlayerDurationHard);
	float flEletricPlayerDurationNightmare = kv.GetFloat("player_electric_slow_duration_nightmare", flEletricPlayerDurationInsane);
	float flEletricPlayerDurationApollyon = kv.GetFloat("player_electric_slow_duration_apollyon", flEletricPlayerDurationNightmare);
	
	float flEletricPlayerSlowdownNormal = kv.GetFloat("player_electric_slow_slowdown");
	if (flEletricPlayerSlowdownNormal > 1.0) flEletricPlayerSlowdownNormal = 1.0;
	if (flEletricPlayerSlowdownNormal < 0.0) flEletricPlayerSlowdownNormal = 0.0;
	float flEletricPlayerSlowdownEasy = kv.GetFloat("player_electric_slow_slowdown_easy", flEletricPlayerSlowdownNormal);
	if (flEletricPlayerSlowdownEasy > 1.0) flEletricPlayerSlowdownEasy = 1.0;
	if (flEletricPlayerSlowdownEasy < 0.0) flEletricPlayerSlowdownEasy = 0.0;
	float flEletricPlayerSlowdownHard = kv.GetFloat("player_electric_slow_slowdown_hard", flEletricPlayerSlowdownNormal);
	if (flEletricPlayerSlowdownHard > 1.0) flEletricPlayerSlowdownHard = 1.0;
	if (flEletricPlayerSlowdownHard < 0.0) flEletricPlayerSlowdownHard = 0.0;
	float flEletricPlayerSlowdownInsane = kv.GetFloat("player_electric_slow_slowdown_insane", flEletricPlayerSlowdownHard);
	if (flEletricPlayerSlowdownInsane > 1.0) flEletricPlayerSlowdownInsane = 1.0;
	if (flEletricPlayerSlowdownInsane < 0.0) flEletricPlayerSlowdownInsane = 0.0;
	float flEletricPlayerSlowdownNightmare = kv.GetFloat("player_electric_slow_slowdown_nightmare", flEletricPlayerSlowdownInsane);
	if (flEletricPlayerSlowdownNightmare > 1.0) flEletricPlayerSlowdownNightmare = 1.0;
	if (flEletricPlayerSlowdownNightmare < 0.0) flEletricPlayerSlowdownNightmare = 0.0;
	float flEletricPlayerSlowdownApollyon = kv.GetFloat("player_electric_slow_slowdown_apollyon", flEletricPlayerSlowdownNightmare);
	if (flEletricPlayerSlowdownApollyon > 1.0) flEletricPlayerSlowdownApollyon = 1.0;
	if (flEletricPlayerSlowdownApollyon < 0.0) flEletricPlayerSlowdownApollyon = 0.0;

	bool bElectricPlayerParticleBeam = view_as<bool>(kv.GetNum("player_electric_beam_particle"));
	
	bool bSmitePlayerAdvanced = view_as<bool>(kv.GetNum("player_smite_on_hit"));
	
	int iSmiteAttackIndexes = kv.GetNum("player_smite_attack_indexs", 1);
	if (iSmiteAttackIndexes < 0) iSmiteAttackIndexes = 1;

	float flSmiteDamage = kv.GetFloat("player_smite_damage", 9001.0);
	int iSmiteDamageType = kv.GetNum("player_smite_damage_type", 1048576); //Critical cause we're mean
	int iSmiteColorR = kv.GetNum("player_smite_color_r", 255);
	int iSmiteColorG = kv.GetNum("player_smite_color_g", 255);
	int iSmiteColorB = kv.GetNum("player_smite_color_b", 255);
	int iSmiteColorTrans = kv.GetNum("player_smite_transparency", 255);

	bool bSmitePlayerMessage = view_as<bool>(kv.GetNum("player_smite_message"));

	bool bXenobladeCombo = view_as<bool>(kv.GetNum("xenoblade_chain_art_combo"));
	float flXenobladeBreakDuration = kv.GetFloat("xenoblade_break_duration");
	float flXenobladeToppleDuration = kv.GetFloat("xenoblade_topple_duration");
	float flXenobladeToppleSlowdown = kv.GetFloat("xenoblade_topple_slowdown", 0.5);
	float flXenobladeDazeDuration = kv.GetFloat("xenoblade_daze_duration");

	int iProjectileType = kv.GetNum("projectile_type", SF2BossProjectileType_Fireball);
	
	bool bDamageParticlesEnabled = view_as<bool>(kv.GetNum("damage_particle_effect_enabled"));
	float flDamageParticleVolume = kv.GetFloat("damage_particle_effect_volume");
	int iDamageParticlePitch = kv.GetNum("damage_particle_effect_pitch");
	if (iDamageParticlePitch < 1) iDamageParticlePitch = 1;
	if (iDamageParticlePitch > 255) iDamageParticlePitch = 255;
	
	bool bShockwaveEnabled = view_as<bool>(kv.GetNum("shockwave"));
	
	float flShockwaveHeight = kv.GetFloat("shockwave_height", 64.0);
	float flShockwaveHeightEasy = kv.GetFloat("shockwave_height_easy", flShockwaveHeight);
	float flShockwaveHeightHard = kv.GetFloat("shockwave_height_hard", flShockwaveHeight);
	float flShockwaveHeightInsane = kv.GetFloat("shockwave_height_insane", flShockwaveHeightHard);
	float flShockwaveHeightNightmare = kv.GetFloat("shockwave_height_nightmare", flShockwaveHeightInsane);
	float flShockwaveHeightApollyon = kv.GetFloat("shockwave_height_apollyon", flShockwaveHeightNightmare);
	
	float flShockwaveRange = kv.GetFloat("shockwave_range", 200.0);
	float flShockwaveRangeEasy = kv.GetFloat("shockwave_range_easy", flShockwaveRange);
	float flShockwaveRangeHard = kv.GetFloat("shockwave_range_hard", flShockwaveRange);
	float flShockwaveRangeInsane = kv.GetFloat("shockwave_range_insane", flShockwaveRangeHard);
	float flShockwaveRangeNightmare = kv.GetFloat("shockwave_range_nightmare", flShockwaveRangeInsane);
	float flShockwaveRangeApollyon = kv.GetFloat("shockwave_range_apollyon", flShockwaveRangeNightmare);
	
	float flShockwaveDrain = kv.GetFloat("shockwave_drain", 0.2);
	float flShockwaveDrainEasy = kv.GetFloat("shockwave_drain_easy", flShockwaveDrain);
	float flShockwaveDrainHard = kv.GetFloat("shockwave_drain_hard", flShockwaveDrain);
	float flShockwaveDrainInsane = kv.GetFloat("shockwave_drain_insane", flShockwaveDrainHard);
	float flShockwaveDrainNightmare = kv.GetFloat("shockwave_drain_nightmare", flShockwaveDrainInsane);
	float flShockwaveDrainApollyon = kv.GetFloat("shockwave_drain_apollyon", flShockwaveDrainNightmare);

	float flShockwaveForce = kv.GetFloat("shockwave_force", 6.0);
	float flShockwaveForceEasy = kv.GetFloat("shockwave_force_easy", flShockwaveForce);
	float flShockwaveForceHard = kv.GetFloat("shockwave_force_hard", flShockwaveForce);
	float flShockwaveForceInsane = kv.GetFloat("shockwave_force_insane", flShockwaveForceHard);
	float flShockwaveForceNightmare = kv.GetFloat("shockwave_force_nightmare", flShockwaveForceInsane);
	float flShockwaveForceApollyon = kv.GetFloat("shockwave_force_apollyon", flShockwaveForceNightmare);
	
	bool bShockwaveStunEnabled = view_as<bool>(kv.GetNum("shockwave_stun"));
	
	float flShockwaveStunDuration = kv.GetFloat("shockwave_stun_duration", 2.0);
	float flShockwaveStunDurationEasy = kv.GetFloat("shockwave_stun_duration_easy", flShockwaveStunDuration);
	float flShockwaveStunDurationHard = kv.GetFloat("shockwave_stun_duration_hard", flShockwaveStunDuration);
	float flShockwaveStunDurationInsane = kv.GetFloat("shockwave_stun_duration_insane", flShockwaveStunDurationHard);
	float flShockwaveStunDurationNightmare = kv.GetFloat("shockwave_stun_duration_nightmare", flShockwaveStunDurationInsane);
	float flShockwaveStunDurationApollyon = kv.GetFloat("shockwave_stun_duration_apollyon", flShockwaveStunDurationNightmare);
	
	float flShockwaveStunSlowdown = kv.GetFloat("shockwave_stun_slowdown", 0.7);
	float flShockwaveStunSlowdownEasy = kv.GetFloat("shockwave_stun_slowdown_easy", flShockwaveStunSlowdown);
	float flShockwaveStunSlowdownHard = kv.GetFloat("shockwave_stun_slowdown_hard", flShockwaveStunSlowdown);
	float flShockwaveStunSlowdownInsane = kv.GetFloat("shockwave_stun_slowdown_insane", flShockwaveStunSlowdownHard);
	float flShockwaveStunSlowdownNightmare = kv.GetFloat("shockwave_stun_slowdown_nightmare", flShockwaveStunSlowdownInsane);
	float flShockwaveStunSlowdownApollyon = kv.GetFloat("shockwave_stun_slowdown_apollyon", flShockwaveStunSlowdownNightmare);
	
	int iShockwaveAttackIndexes = kv.GetNum("shockwave_attack_index", 1);
	if (iShockwaveAttackIndexes < 1) iShockwaveAttackIndexes = 1;

	float flShockwaveWidth1 = kv.GetFloat("shockwave_width_1", 40.0);
	float flShockwaveWidth2 = kv.GetFloat("shockwave_width_2", 20.0);
	float flShockwaveAmplitude = kv.GetFloat("shockwave_amplitude", 5.0);

	bool bEarthquakeFootstepsEnabled = view_as<bool>(kv.GetNum("earthquake_footsteps"));

	float flEarthquakeFootstepsAmplitude = kv.GetFloat("earthquake_footsteps_amplitude", 5.0);
	float flEarthquakeFootstepsFrequency = kv.GetFloat("earthquake_footsteps_frequency", 25.0);
	float flEarthquakeFootstepsDuration = kv.GetFloat("earthquake_footsteps_duration", 1.0);
	float flEarthquakeFootstepsRadius = kv.GetFloat("earthquake_footsteps_radius", 1000.0);
	bool bEarthquakeFootstepsAirShake = view_as<bool>(kv.GetNum("earthquake_footsteps_airshake"));
	
	bool bTrapsEnabled = view_as<bool>(kv.GetNum("traps_enabled"));
	
	int iTrapType = kv.GetNum("trap_type", 0);
	
	float flTrapSpawnCooldown = kv.GetFloat("trap_spawn_cooldown", 8.0);
	float flTrapSpawnCooldownEasy = kv.GetFloat("trap_spawn_cooldown_easy", flTrapSpawnCooldown);
	float flTrapSpawnCooldownHard = kv.GetFloat("trap_spawn_cooldown_hard", flTrapSpawnCooldown);
	float flTrapSpawnCooldownInsane = kv.GetFloat("trap_spawn_cooldown_insane", flTrapSpawnCooldownHard);
	float flTrapSpawnCooldownNightmare = kv.GetFloat("trap_spawn_cooldown_nightmare", flTrapSpawnCooldownInsane);
	float flTrapSpawnCooldownApollyon = kv.GetFloat("trap_spawn_cooldown_apollyon", flTrapSpawnCooldownNightmare);

	bool bAutoChaseEnabled = view_as<bool>(kv.GetNum("auto_chase_enabled", 0));

	int iAutoChaseCount = kv.GetNum("auto_chase_count", 30);
	if (iAutoChaseCount < 0) iAutoChaseCount = 0;
	int iAutoChaseCountEasy = kv.GetNum("auto_chase_count_easy", iAutoChaseCount);
	if (iAutoChaseCountEasy < 0) iAutoChaseCountEasy = 0;
	int iAutoChaseCountHard = kv.GetNum("auto_chase_count_hard", iAutoChaseCount);
	if (iAutoChaseCountHard < 0) iAutoChaseCountHard = 0;
	int iAutoChaseCountInsane = kv.GetNum("auto_chase_count_insane", iAutoChaseCountHard);
	if (iAutoChaseCountInsane < 0) iAutoChaseCountInsane = 0;
	int iAutoChaseCountNightmare = kv.GetNum("auto_chase_count_nightmare", iAutoChaseCountInsane);
	if (iAutoChaseCountNightmare < 0) iAutoChaseCountNightmare = 0;
	int iAutoChaseCountApollyon = kv.GetNum("auto_chase_count_apollyon", iAutoChaseCountNightmare);
	if (iAutoChaseCountApollyon < 0) iAutoChaseCountApollyon = 0;

	int iAutoChaseAdd = kv.GetNum("sound_alert_add", 0);
	if (iAutoChaseAdd < 0) iAutoChaseAdd = 0;
	int iAutoChaseAddEasy = kv.GetNum("sound_alert_add_easy", iAutoChaseAdd);
	if (iAutoChaseAddEasy < 0) iAutoChaseAddEasy = 0;
	int iAutoChaseAddHard = kv.GetNum("sound_alert_add_hard", iAutoChaseAdd);
	if (iAutoChaseAddHard < 0) iAutoChaseAddHard = 0;
	int iAutoChaseAddInsane = kv.GetNum("sound_alert_add_insane", iAutoChaseAddHard);
	if (iAutoChaseAddInsane < 0) iAutoChaseAddInsane = 0;
	int iAutoChaseAddNightmare = kv.GetNum("sound_alert_add_nightmare", iAutoChaseAddInsane);
	if (iAutoChaseAddNightmare < 0) iAutoChaseAddNightmare = 0;
	int iAutoChaseAddApollyon = kv.GetNum("sound_alert_add_apollyon", iAutoChaseAddNightmare);
	if (iAutoChaseAddApollyon < 0) iAutoChaseAddApollyon = 0;

	int iAutoChaseAddFootsteps = kv.GetNum("sound_alert_add_footsteps", 2);
	if (iAutoChaseAddFootsteps < 0) iAutoChaseAddFootsteps = 0;
	int iAutoChaseAddFootstepsEasy = kv.GetNum("sound_alert_add_footsteps_easy", iAutoChaseAddFootsteps);
	if (iAutoChaseAddFootstepsEasy < 0) iAutoChaseAddFootstepsEasy = 0;
	int iAutoChaseAddFootstepsHard = kv.GetNum("sound_alert_add_footsteps_hard", iAutoChaseAddFootsteps);
	if (iAutoChaseAddFootstepsHard < 0) iAutoChaseAddFootstepsHard = 0;
	int iAutoChaseAddFootstepsInsane = kv.GetNum("sound_alert_add_footsteps_insane", iAutoChaseAddFootstepsHard);
	if (iAutoChaseAddFootstepsInsane < 0) iAutoChaseAddFootstepsInsane = 0;
	int iAutoChaseAddFootstepsNightmare = kv.GetNum("sound_alert_add_footsteps_nightmare", iAutoChaseAddFootstepsInsane);
	if (iAutoChaseAddFootstepsNightmare < 0) iAutoChaseAddFootstepsNightmare = 0;
	int iAutoChaseAddFootstepsApollyon = kv.GetNum("sound_alert_add_footsteps_apollyon", iAutoChaseAddFootstepsNightmare);
	if (iAutoChaseAddFootstepsApollyon < 0) iAutoChaseAddFootstepsApollyon = 0;

	int iAutoChaseAddVoice = kv.GetNum("sound_alert_add_voice", 8);
	if (iAutoChaseAddVoice < 0) iAutoChaseAddVoice = 0;
	int iAutoChaseAddVoiceEasy = kv.GetNum("sound_alert_add_voice_easy", iAutoChaseAddVoice);
	if (iAutoChaseAddVoiceEasy < 0) iAutoChaseAddVoiceEasy = 0;
	int iAutoChaseAddVoiceHard = kv.GetNum("sound_alert_add_voice_hard", iAutoChaseAddVoice);
	if (iAutoChaseAddVoiceHard < 0) iAutoChaseAddVoiceHard = 0;
	int iAutoChaseAddVoiceInsane = kv.GetNum("sound_alert_add_voice_insane", iAutoChaseAddVoiceHard);
	if (iAutoChaseAddVoiceInsane < 0) iAutoChaseAddVoiceInsane = 0;
	int iAutoChaseAddVoiceNightmare = kv.GetNum("sound_alert_add_voice_nightmare", iAutoChaseAddVoiceInsane);
	if (iAutoChaseAddVoiceNightmare < 0) iAutoChaseAddVoiceNightmare = 0;
	int iAutoChaseAddVoiceApollyon = kv.GetNum("sound_alert_add_voice_apollyon", iAutoChaseAddVoiceNightmare);
	if (iAutoChaseAddVoiceApollyon < 0) iAutoChaseAddVoiceApollyon = 0;

	int iAutoChaseAddWeapon = kv.GetNum("sound_alert_add_weapon", 4);
	if (iAutoChaseAddWeapon < 0) iAutoChaseAddWeapon = 0;
	int iAutoChaseAddWeaponEasy = kv.GetNum("sound_alert_add_weapon_easy", iAutoChaseAddWeapon);
	if (iAutoChaseAddWeaponEasy < 0) iAutoChaseAddWeaponEasy = 0;
	int iAutoChaseAddWeaponHard = kv.GetNum("sound_alert_add_weapon_hard", iAutoChaseAddWeapon);
	if (iAutoChaseAddWeaponHard < 0) iAutoChaseAddWeaponHard = 0;
	int iAutoChaseAddWeaponInsane = kv.GetNum("sound_alert_add_weapon_insane", iAutoChaseAddWeaponHard);
	if (iAutoChaseAddWeaponInsane < 0) iAutoChaseAddWeaponInsane = 0;
	int iAutoChaseAddWeaponNightmare = kv.GetNum("sound_alert_add_weapon_nightmare", iAutoChaseAddWeaponInsane);
	if (iAutoChaseAddWeaponNightmare < 0) iAutoChaseAddWeaponNightmare = 0;
	int iAutoChaseAddWeaponApollyon = kv.GetNum("sound_alert_add_weapon_apollyon", iAutoChaseAddWeaponNightmare);
	if (iAutoChaseAddWeaponApollyon < 0) iAutoChaseAddWeaponApollyon = 0;

	bool bAutoChaseSprinters = view_as<bool>(kv.GetNum("auto_chase_sprinters", 0));

	bool bChasesEndlessly = view_as<bool>(KvGetNum(kv,"boss_chases_endlessly", 0));
	
	bool bSelfHeal = view_as<bool>(kv.GetNum("self_heal_enabled", 0));
	float flHealthPercentageToHeal = kv.GetFloat("health_percentage_to_heal", 0.35);
	if (flHealthPercentageToHeal < 0.0) flHealthPercentageToHeal = 0.0;
	if (flHealthPercentageToHeal > 0.999) flHealthPercentageToHeal = 0.999;
	float flHealPercentageOne = kv.GetFloat("heal_percentage_one", 0.75);
	if (flHealPercentageOne < 0.0) flHealPercentageOne = 0.0;
	if (flHealPercentageOne > 1.0) flHealPercentageOne = 1.0;
	float flHealPercentageTwo = kv.GetFloat("heal_percentage_two", 0.5);
	if (flHealPercentageTwo < 0.0) flHealPercentageTwo = 0.0;
	if (flHealPercentageTwo > 1.0) flHealPercentageTwo = 1.0;
	float flHealPercentageThree = kv.GetFloat("heal_percentage_three", 0.25);
	if (flHealPercentageThree < 0.0) flHealPercentageThree = 0.0;
	if (flHealPercentageThree > 1.0) flHealPercentageThree = 1.0;

	bool bCrawlingEnabled = view_as<bool>(kv.GetNum("crawling_enabled"));
	float flCrawlSpeedMultiplier = kv.GetFloat("crawl_multiplier", 0.5);
	float flCrawlSpeedMultiplierEasy = kv.GetFloat("crawl_multiplier", flCrawlSpeedMultiplier);
	float flCrawlSpeedMultiplierHard = kv.GetFloat("crawl_multiplier", flCrawlSpeedMultiplier);
	float flCrawlSpeedMultiplierInsane = kv.GetFloat("crawl_multiplier", flCrawlSpeedMultiplierHard);
	float flCrawlSpeedMultiplierNightmare = kv.GetFloat("crawl_multiplier", flCrawlSpeedMultiplierInsane);
	float flCrawlSpeedMultiplierApollyon = kv.GetFloat("crawl_multiplier", flCrawlSpeedMultiplierNightmare);

	bool bChaseOnLook = view_as<bool>(kv.GetNum("chase_upon_look"));

	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("difficulty_affects_animations")), ChaserProfileData_DifficultyAffectsAnimations);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultWalkSpeed, ChaserProfileData_WalkSpeedNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossWalkSpeedEasy, ChaserProfileData_WalkSpeedEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossWalkSpeedHard, ChaserProfileData_WalkSpeedHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossWalkSpeedInsane, ChaserProfileData_WalkSpeedInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossWalkSpeedNightmare, ChaserProfileData_WalkSpeedNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossWalkSpeedApollyon, ChaserProfileData_WalkSpeedApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultMaxWalkSpeed, ChaserProfileData_MaxWalkSpeedNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossMaxWalkSpeedEasy, ChaserProfileData_MaxWalkSpeedEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossMaxWalkSpeedHard, ChaserProfileData_MaxWalkSpeedHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossMaxWalkSpeedInsane, ChaserProfileData_MaxWalkSpeedInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossMaxWalkSpeedNightmare, ChaserProfileData_MaxWalkSpeedNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossMaxWalkSpeedApollyon, ChaserProfileData_MaxWalkSpeedApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetime, ChaserProfileData_SearchAlertGracetime);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetimeEasy, ChaserProfileData_SearchAlertGracetimeEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetimeHard, ChaserProfileData_SearchAlertGracetimeHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetimeInsane, ChaserProfileData_SearchAlertGracetimeInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetimeNightmare, ChaserProfileData_SearchAlertGracetimeNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertGracetimeApollyon, ChaserProfileData_SearchAlertGracetimeApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDuration, ChaserProfileData_SearchAlertDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDurationEasy, ChaserProfileData_SearchAlertDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDurationHard, ChaserProfileData_SearchAlertDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDurationInsane, ChaserProfileData_SearchAlertDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDurationNightmare, ChaserProfileData_SearchAlertDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flAlertDurationApollyon, ChaserProfileData_SearchAlertDurationApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDuration, ChaserProfileData_SearchChaseDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDurationEasy, ChaserProfileData_SearchChaseDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDurationHard, ChaserProfileData_SearchChaseDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDurationInsane, ChaserProfileData_SearchChaseDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDurationNightmare, ChaserProfileData_SearchChaseDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flChaseDurationApollyon, ChaserProfileData_SearchChaseDurationApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMin, ChaserProfileData_SearchWanderRangeMin);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMinEasy, ChaserProfileData_SearchWanderRangeMinEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMinHard, ChaserProfileData_SearchWanderRangeMinHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMinInsane, ChaserProfileData_SearchWanderRangeMinInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMinNightmare, ChaserProfileData_SearchWanderRangeMinNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMinApollyon, ChaserProfileData_SearchWanderRangeMinApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMax, ChaserProfileData_SearchWanderRangeMax);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMaxEasy, ChaserProfileData_SearchWanderRangeMaxEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMaxHard, ChaserProfileData_SearchWanderRangeMaxHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMaxInsane, ChaserProfileData_SearchWanderRangeMaxInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMaxNightmare, ChaserProfileData_SearchWanderRangeMaxNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderRangeMaxApollyon, ChaserProfileData_SearchWanderRangeMaxApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMin, ChaserProfileData_SearchWanderTimeMin);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMinEasy, ChaserProfileData_SearchWanderTimeMinEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMinHard, ChaserProfileData_SearchWanderTimeMinHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMinInsane, ChaserProfileData_SearchWanderTimeMinInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMinNightmare, ChaserProfileData_SearchWanderTimeMinNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMinApollyon, ChaserProfileData_SearchWanderTimeMinApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMax, ChaserProfileData_SearchWanderTimeMax);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMaxEasy, ChaserProfileData_SearchWanderTimeMaxEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMaxHard, ChaserProfileData_SearchWanderTimeMaxHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMaxInsane, ChaserProfileData_SearchWanderTimeMaxInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMaxNightmare, ChaserProfileData_SearchWanderTimeMaxNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWanderTimeMaxApollyon, ChaserProfileData_SearchWanderTimeMaxApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flWakeRange, ChaserProfileData_WakeRadius);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bCanBeStunned, ChaserProfileData_CanBeStunned);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunDuration, ChaserProfileData_StunDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunCooldown, ChaserProfileData_StunCooldown);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunHealth, ChaserProfileData_StunHealth);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunHealthPerPlayer, ChaserProfileData_StunHealthPerPlayer);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bStunTakeDamageFromFlashlight, ChaserProfileData_CanBeStunnedByFlashlight);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunFlashlightDamage, ChaserProfileData_StunFlashlightDamage);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bItemDrop, ChaserProfileData_ItemDropOnStun);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iItemDropType, ChaserProfileData_ItemDropTypeStun);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("chase_initial_on_stun")), ChaserProfileData_ChaseInitialOnStun);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bKeyDrop, ChaserProfileData_KeyDrop);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bCanCloak, ChaserProfileData_CanCloak);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultCloakCooldown, ChaserProfileData_CloakCooldownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakCooldownEasy, ChaserProfileData_CloakCooldownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakCooldownHard, ChaserProfileData_CloakCooldownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakCooldownInsane, ChaserProfileData_CloakCooldownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakCooldownNightmare, ChaserProfileData_CloakCooldownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakCooldownApollyon, ChaserProfileData_CloakCooldownApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultCloakRange, ChaserProfileData_CloakRangeNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakRangeEasy, ChaserProfileData_CloakRangeEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakRangeHard, ChaserProfileData_CloakRangeHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakRangeInsane, ChaserProfileData_CloakRangeInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakRangeNightmare, ChaserProfileData_CloakRangeNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakRangeApollyon, ChaserProfileData_CloakRangeApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultDecloakRange, ChaserProfileData_CloakDecloakRangeNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDecloakRangeEasy, ChaserProfileData_CloakDecloakRangeEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDecloakRangeHard, ChaserProfileData_CloakDecloakRangeHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDecloakRangeInsane, ChaserProfileData_CloakDecloakRangeInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDecloakRangeNightmare, ChaserProfileData_CloakDecloakRangeNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDecloakRangeApollyon, ChaserProfileData_CloakDecloakRangeApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultCloakDuration, ChaserProfileData_CloakDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakDurationEasy, ChaserProfileData_CloakDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakDurationHard, ChaserProfileData_CloakDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakDurationInsane, ChaserProfileData_CloakDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakDurationNightmare, ChaserProfileData_CloakDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakDurationApollyon, ChaserProfileData_CloakDurationApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossDefaultCloakSpeedMultiplier, ChaserProfileData_CloakSpeedMultiplierNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakSpeedMultiplierEasy, ChaserProfileData_CloakSpeedMultiplierEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakSpeedMultiplierHard, ChaserProfileData_CloakSpeedMultiplierHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakSpeedMultiplierInsane, ChaserProfileData_CloakSpeedMultiplierInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakSpeedMultiplierNightmare, ChaserProfileData_CloakSpeedMultiplierNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBossCloakSpeedMultiplierApollyon, ChaserProfileData_CloakSpeedMultiplierApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bProjectileEnable, ChaserProfileData_ProjectileEnable);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bRocketCritical, ChaserProfileData_CriticlaRockets);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bUseShootGesture, ChaserProfileData_UseShootGesture);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bEnableProjectileClips, ChaserProfileData_ProjectileClipEnable);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bEnableChargeUpProjectiles, ChaserProfileData_UseChargeUpProjectiles);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMin, ChaserProfileData_ProjectileCooldownMinNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMinEasy, ChaserProfileData_ProjectileCooldownMinEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMinHard, ChaserProfileData_ProjectileCooldownMinHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMinInsane, ChaserProfileData_ProjectileCooldownMinInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMinNightmare, ChaserProfileData_ProjectileCooldownMinNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMinApollyon, ChaserProfileData_ProjectileCooldownMinApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMax, ChaserProfileData_ProjectileCooldownMaxNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMaxEasy, ChaserProfileData_ProjectileCooldownMaxEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMaxHard, ChaserProfileData_ProjectileCooldownMaxHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMaxInsane, ChaserProfileData_ProjectileCooldownMaxInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMaxNightmare, ChaserProfileData_ProjectileCooldownMaxNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileCooldownMaxApollyon, ChaserProfileData_ProjectileCooldownMaxApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCount, ChaserProfileData_ProjectileCount);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCountEasy, ChaserProfileData_ProjectileCountEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCountHard, ChaserProfileData_ProjectileCountHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCountInsane, ChaserProfileData_ProjectileCountInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCountNightmare, ChaserProfileData_ProjectileCountNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileCountApollyon, ChaserProfileData_ProjectileCountApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDuration, ChaserProfileData_IceballSlowdownDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDurationEasy, ChaserProfileData_IceballSlowdownDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDurationHard, ChaserProfileData_IceballSlowdownDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDurationInsane, ChaserProfileData_IceballSlowdownDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDurationNightmare, ChaserProfileData_IceballSlowdownDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownDurationApollyon, ChaserProfileData_IceballSlowdownDurationApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercent, ChaserProfileData_IceballSlowdownPercentNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercentEasy, ChaserProfileData_IceballSlowdownPercentEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercentHard, ChaserProfileData_IceballSlowdownPercentHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercentInsane, ChaserProfileData_IceballSlowdownPercentInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercentNightmare, ChaserProfileData_IceballSlowdownPercentNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIceballSlowdownPercentApollyon, ChaserProfileData_IceballSlowdownPercentApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeed, ChaserProfileData_ProjectileSpeedNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeedEasy, ChaserProfileData_ProjectileSpeedEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeedHard, ChaserProfileData_ProjectileSpeedHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeedInsane, ChaserProfileData_ProjectileSpeedInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeedNightmare, ChaserProfileData_ProjectileSpeedNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileSpeedApollyon, ChaserProfileData_ProjectileSpeedApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamage, ChaserProfileData_ProjectileDamageNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamageEasy, ChaserProfileData_ProjectileDamageEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamageHard, ChaserProfileData_ProjectileDamageHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamageInsane, ChaserProfileData_ProjectileDamageInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamageNightmare, ChaserProfileData_ProjectileDamageNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDamageApollyon, ChaserProfileData_ProjectileDamageApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadius, ChaserProfileData_ProjectileRadiusNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadiusEasy, ChaserProfileData_ProjectileRadiusEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadiusHard, ChaserProfileData_ProjectileRadiusHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadiusInsane, ChaserProfileData_ProjectileRadiusInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadiusNightmare, ChaserProfileData_ProjectileRadiusNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileRadiusApollyon, ChaserProfileData_ProjectileRadiusApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviation, ChaserProfileData_ProjectileDeviation);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviationEasy, ChaserProfileData_ProjectileDeviationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviationHard, ChaserProfileData_ProjectileDeviationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviationInsane, ChaserProfileData_ProjectileDeviationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviationNightmare, ChaserProfileData_ProjectileDeviationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileDeviationApollyon, ChaserProfileData_ProjectileDeviationApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileType, ChaserProfileData_ProjectileType);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClips, ChaserProfileData_ProjectileClipNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClipsEasy, ChaserProfileData_ProjectileClipEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClipsHard, ChaserProfileData_ProjectileClipHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClipsInsane, ChaserProfileData_ProjectileClipInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClipsNightmare, ChaserProfileData_ProjectileClipNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iProjectileClipsApollyon, ChaserProfileData_ProjectileClipApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReload, ChaserProfileData_ProjectileReloadTimeNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReloadEasy, ChaserProfileData_ProjectileReloadTimeEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReloadHard, ChaserProfileData_ProjectileReloadTimeHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReloadInsane, ChaserProfileData_ProjectileReloadTimeInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReloadNightmare, ChaserProfileData_ProjectileReloadTimeNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectilesReloadApollyon, ChaserProfileData_ProjectileReloadTimeApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDuration, ChaserProfileData_ProjectileChargeUpNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDurationEasy, ChaserProfileData_ProjectileChargeUpEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDurationHard, ChaserProfileData_ProjectileChargeUpHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDurationInsane, ChaserProfileData_ProjectileChargeUpInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDurationNightmare, ChaserProfileData_ProjectileChargeUpNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flProjectileChargeUpDurationApollyon, ChaserProfileData_ProjectileChargeUpApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bAdvancedDamageEffectsEnabled, ChaserProfileData_AdvancedDamageEffectsEnabled);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bAdvancedDamageEffectsRandom, ChaserProfileData_AdvancedDamageEffectsRandom);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bAdvancedDamageEffectsParticles, ChaserProfileData_AdvancedDamageEffectsParticles);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, iRandomEffectAttackIndexes, ChaserProfileData_RandomAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationEasy, ChaserProfileData_RandomAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationNormal, ChaserProfileData_RandomAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationHard, ChaserProfileData_RandomAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationInsane, ChaserProfileData_RandomAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationNightmare, ChaserProfileData_RandomAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectDurationApollyon, ChaserProfileData_RandomAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownEasy, ChaserProfileData_RandomAdvancedSlowdownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownNormal, ChaserProfileData_RandomAdvancedSlowdownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownHard, ChaserProfileData_RandomAdvancedSlowdownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownInsane, ChaserProfileData_RandomAdvancedSlowdownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownNightmare, ChaserProfileData_RandomAdvancedSlowdownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flRandomEffectSlowdownApollyon, ChaserProfileData_RandomAdvancedSlowdownApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iRandomStunType, ChaserProfileData_RandomAdvancedStunType);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bJaratePlayerAdvanced, ChaserProfileData_EnableJarateAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iJaratePlayerAttackIndexes, ChaserProfileData_JarateAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationEasy, ChaserProfileData_JarateAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationNormal, ChaserProfileData_JarateAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationHard, ChaserProfileData_JarateAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationInsane, ChaserProfileData_JarateAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationNightmare, ChaserProfileData_JarateAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flJaratePlayerDurationApollyon, ChaserProfileData_JarateAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bJaratePlayerParticleBeam, ChaserProfileData_JarateAdvancedBeamParticle);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bMilkPlayerAdvanced, ChaserProfileData_EnableMilkAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iMilkPlayerAttackIndexes, ChaserProfileData_MilkAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationEasy, ChaserProfileData_MilkAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationNormal, ChaserProfileData_MilkAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationHard, ChaserProfileData_MilkAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationInsane, ChaserProfileData_MilkAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationNightmare, ChaserProfileData_MilkAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMilkPlayerDurationApollyon, ChaserProfileData_MilkAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bMilkPlayerParticleBeam, ChaserProfileData_MilkAdvancedBeamParticle);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bGasPlayerAdvanced, ChaserProfileData_EnableGasAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iGasPlayerAttackIndexes, ChaserProfileData_GasAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationEasy, ChaserProfileData_GasAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationNormal, ChaserProfileData_GasAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationHard, ChaserProfileData_GasAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationInsane, ChaserProfileData_GasAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationNightmare, ChaserProfileData_GasAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flGasPlayerDurationApollyon, ChaserProfileData_GasAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bGasPlayerParticleBeam, ChaserProfileData_GasAdvancedBeamParticle);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bMarkPlayerAdvanced, ChaserProfileData_EnableMarkAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iMarkPlayerAttackIndexes, ChaserProfileData_MarkAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationEasy, ChaserProfileData_MarkAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationNormal, ChaserProfileData_MarkAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationHard, ChaserProfileData_MarkAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationInsane, ChaserProfileData_MarkAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationNightmare, ChaserProfileData_MarkAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flMarkPlayerDurationApollyon, ChaserProfileData_MarkAdvancedDurationApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bSilentMarkPlayerAdvanced, ChaserProfileData_EnableSilentMarkAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSilentMarkPlayerAttackIndexes, ChaserProfileData_SilentMarkAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationEasy, ChaserProfileData_SilentMarkAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationNormal, ChaserProfileData_SilentMarkAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationHard, ChaserProfileData_SilentMarkAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationInsane, ChaserProfileData_SilentMarkAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationNightmare, ChaserProfileData_SilentMarkAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSilentMarkPlayerDurationApollyon, ChaserProfileData_SilentMarkAdvancedDurationApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bIgnitePlayerAdvanced, ChaserProfileData_EnableIgniteAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iIgnitePlayerAttackIndexes, ChaserProfileData_IgniteAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayEasy, ChaserProfileData_IgniteAdvancedDelayEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayNormal, ChaserProfileData_IgniteAdvancedDelayNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayHard, ChaserProfileData_IgniteAdvancedDelayHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayInsane, ChaserProfileData_IgniteAdvancedDelayInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayNightmare, ChaserProfileData_IgniteAdvancedDelayNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flIgnitePlayerDelayApollyon, ChaserProfileData_IgniteAdvancedDelayApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bStunPlayerAdvanced, ChaserProfileData_EnableStunAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iStunPlayerAttackIndexes, ChaserProfileData_StunAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationEasy, ChaserProfileData_StunAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationNormal, ChaserProfileData_StunAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationHard, ChaserProfileData_StunAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationInsane, ChaserProfileData_StunAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationNightmare, ChaserProfileData_StunAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerDurationApollyon, ChaserProfileData_StunAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownEasy, ChaserProfileData_StunAdvancedSlowdownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownNormal, ChaserProfileData_StunAdvancedSlowdownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownHard, ChaserProfileData_StunAdvancedSlowdownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownInsane, ChaserProfileData_StunAdvancedSlowdownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownNightmare, ChaserProfileData_StunAdvancedSlowdownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flStunPlayerSlowdownApollyon, ChaserProfileData_StunAdvancedSlowdownApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iStunPlayerType, ChaserProfileData_StunAdvancedType);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bStunPlayerParticleBeam, ChaserProfileData_StunAdvancedBeamParticle);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bBleedPlayerAdvanced, ChaserProfileData_EnableBleedAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iBleedPlayerAttackIndexes, ChaserProfileData_BleedAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationEasy, ChaserProfileData_BleedAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationNormal, ChaserProfileData_BleedAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationHard, ChaserProfileData_BleedAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationInsane, ChaserProfileData_BleedAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationNightmare, ChaserProfileData_BleedAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flBleedPlayerDurationApollyon, ChaserProfileData_BleedAdvancedDurationApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bEletricPlayerAdvanced, ChaserProfileData_EnableEletricAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iEletricPlayerAttackIndexes, ChaserProfileData_EletricAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationEasy, ChaserProfileData_EletricAdvancedDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationNormal, ChaserProfileData_EletricAdvancedDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationHard, ChaserProfileData_EletricAdvancedDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationInsane, ChaserProfileData_EletricAdvancedDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationNightmare, ChaserProfileData_EletricAdvancedDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerDurationApollyon, ChaserProfileData_EletricAdvancedDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownEasy, ChaserProfileData_EletricAdvancedSlowdownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownNormal, ChaserProfileData_EletricAdvancedSlowdownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownHard, ChaserProfileData_EletricAdvancedSlowdownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownInsane, ChaserProfileData_EletricAdvancedSlowdownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownNightmare, ChaserProfileData_EletricAdvancedSlowdownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEletricPlayerSlowdownApollyon, ChaserProfileData_EletricAdvancedSlowdownApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bElectricPlayerParticleBeam, ChaserProfileData_EletricAdvancedBeamParticle);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bSmitePlayerAdvanced, ChaserProfileData_EnableSmiteAdvanced);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteAttackIndexes, ChaserProfileData_SmiteAdvancedIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flSmiteDamage, ChaserProfileData_SmiteAdvancedDamage);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteDamageType, ChaserProfileData_SmiteAdvancedDamageType);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteColorR, ChaserProfileData_SmiteColorR);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteColorG, ChaserProfileData_SmiteColorG);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteColorB, ChaserProfileData_SmiteColorB);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iSmiteColorTrans, ChaserProfileData_SmiteTransparency);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bSmitePlayerMessage, ChaserProfileData_SmiteMessage);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bXenobladeCombo, ChaserProfileData_EnableXenobladeBreakCombo);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flXenobladeBreakDuration, ChaserProfileData_XenobladeBreakDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flXenobladeToppleDuration, ChaserProfileData_XenobladeToppleDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flXenobladeToppleSlowdown, ChaserProfileData_XenobladeToppleSlowdown);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flXenobladeDazeDuration, ChaserProfileData_XenobladeDazeDuration);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bDamageParticlesEnabled, ChaserProfileData_EnableDamageParticles);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flDamageParticleVolume, ChaserProfileData_DamageParticleVolume);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iDamageParticlePitch, ChaserProfileData_DamageParticlePitch);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bShockwaveEnabled, ChaserProfileData_ShockwavesEnable);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeightEasy, ChaserProfileData_ShockwaveHeightEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeight, ChaserProfileData_ShockwaveHeightNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeightHard, ChaserProfileData_ShockwaveHeightHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeightInsane, ChaserProfileData_ShockwaveHeightInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeightNightmare, ChaserProfileData_ShockwaveHeightNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveHeightApollyon, ChaserProfileData_ShockwaveHeightApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRangeEasy, ChaserProfileData_ShockwaveRangeEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRange, ChaserProfileData_ShockwaveRangeNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRangeHard, ChaserProfileData_ShockwaveRangeHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRangeInsane, ChaserProfileData_ShockwaveRangeInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRangeNightmare, ChaserProfileData_ShockwaveRangeNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveRangeApollyon, ChaserProfileData_ShockwaveRangeApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrainEasy, ChaserProfileData_ShockwaveDrainEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrain, ChaserProfileData_ShockwaveDrainNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrainHard, ChaserProfileData_ShockwaveDrainHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrainInsane, ChaserProfileData_ShockwaveDrainInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrainNightmare, ChaserProfileData_ShockwaveDrainNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveDrainApollyon, ChaserProfileData_ShockwaveDrainApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForceEasy, ChaserProfileData_ShockwaveForceEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForce, ChaserProfileData_ShockwaveForceNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForceHard, ChaserProfileData_ShockwaveForceHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForceInsane, ChaserProfileData_ShockwaveForceInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForceNightmare, ChaserProfileData_ShockwaveForceNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveForceApollyon, ChaserProfileData_ShockwaveForceApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bShockwaveStunEnabled, ChaserProfileData_ShockwaveStunEnabled);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDurationEasy, ChaserProfileData_ShockwaveStunDurationEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDuration, ChaserProfileData_ShockwaveStunDurationNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDurationHard, ChaserProfileData_ShockwaveStunDurationHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDurationInsane, ChaserProfileData_ShockwaveStunDurationInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDurationNightmare, ChaserProfileData_ShockwaveStunDurationNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunDurationApollyon, ChaserProfileData_ShockwaveStunDurationApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdownEasy, ChaserProfileData_ShockwaveStunSlowdownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdown, ChaserProfileData_ShockwaveStunSlowdownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdownHard, ChaserProfileData_ShockwaveStunSlowdownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdownInsane, ChaserProfileData_ShockwaveStunSlowdownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdownNightmare, ChaserProfileData_ShockwaveStunSlowdownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveStunSlowdownApollyon, ChaserProfileData_ShockwaveStunSlowdownApollyon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iShockwaveAttackIndexes, ChaserProfileData_ShockwaveAttackIndexes);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveWidth1, ChaserProfileData_ShockwaveWidth1);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveWidth2, ChaserProfileData_ShockwaveWidth2);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flShockwaveAmplitude, ChaserProfileData_ShockwaveAmplitude);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bEarthquakeFootstepsEnabled, ChaserProfileData_EarthquakeFootstepsEnabled);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEarthquakeFootstepsAmplitude, ChaserProfileData_EarthquakeFootstepsAmplitude);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEarthquakeFootstepsFrequency, ChaserProfileData_EarthquakeFootstepsFrequency);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEarthquakeFootstepsDuration, ChaserProfileData_EarthquakeFootstepsDuration);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flEarthquakeFootstepsRadius, ChaserProfileData_EarthquakeFootstepsRadius);
	g_hChaserProfileData.Set(iUniqueProfileIndex, bEarthquakeFootstepsAirShake, ChaserProfileData_EarthquakeFootstepsCanAirShake);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bTrapsEnabled, ChaserProfileData_TrapsEnabled);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iTrapType, ChaserProfileData_TrapType);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldown, ChaserProfileData_TrapSpawnCooldownNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldownEasy, ChaserProfileData_TrapSpawnCooldownEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldownHard, ChaserProfileData_TrapSpawnCooldownHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldownInsane, ChaserProfileData_TrapSpawnCooldownInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldownNightmare, ChaserProfileData_TrapSpawnCooldownNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flTrapSpawnCooldownApollyon, ChaserProfileData_TrapSpawnCooldownApollyon);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bSelfHeal, ChaserProfileData_CanSelfHeal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flHealthPercentageToHeal, ChaserProfileData_HealStartHealthPercentage);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flHealPercentageOne, ChaserProfileData_HealPercentageOne);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flHealPercentageTwo, ChaserProfileData_HealPercentageTwo);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flHealPercentageThree, ChaserProfileData_HealPercentageThree);

	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("memory_lifetime", 10.0), ChaserProfileData_MemoryLifeTime);
	
	float flDefaultAwarenessIncreaseRate = kv.GetFloat("awareness_rate_increase", 75.0);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_increase_easy", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flDefaultAwarenessIncreaseRate, ChaserProfileData_AwarenessIncreaseRateNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_increase_hard", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_increase_insane", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_increase_nightmare", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_increase_apollyon", flDefaultAwarenessIncreaseRate), ChaserProfileData_AwarenessIncreaseRateApollyon);
	
	float flDefaultAwarenessDecreaseRate = kv.GetFloat("awareness_rate_decrease", 150.0);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_easy", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flDefaultAwarenessDecreaseRate, ChaserProfileData_AwarenessDecreaseRateNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_hard", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_insane", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_nightmare", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetFloat("awareness_rate_decrease_apollyon", flDefaultAwarenessDecreaseRate), ChaserProfileData_AwarenessDecreaseRateApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, kv.GetNum("search_sound_count_until_alert", 4), ChaserProfileData_SoundCountToAlert);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("disappear_on_stun")), ChaserProfileData_DisappearOnStun);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("boxing_boss")), ChaserProfileData_BoxingBoss);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("normal_sound_hook")), ChaserProfileData_NormalSoundHook);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("cloak_to_heal")), ChaserProfileData_CloakToHeal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("use_chase_initial_animation")), ChaserProfileData_ChaseInitialAnimationUse);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("old_animation_ai")), ChaserProfileData_OldAnimationAI);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("use_alert_walking_animation")), ChaserProfileData_AlertWalkingAnimation);
	
	g_hChaserProfileData.Set(iUniqueProfileIndex, bAutoChaseEnabled, ChaserProfileData_AutoChaseEnabled);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCount, ChaserProfileData_AutoChaseCount);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCountEasy, ChaserProfileData_AutoChaseCountEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCountHard, ChaserProfileData_AutoChaseCountHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCountInsane, ChaserProfileData_AutoChaseCountInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCountNightmare, ChaserProfileData_AutoChaseCountNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseCountApollyon, ChaserProfileData_AutoChaseCountApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAdd, ChaserProfileData_AutoChaseAdd);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddEasy, ChaserProfileData_AutoChaseAddEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddHard, ChaserProfileData_AutoChaseAddHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddInsane, ChaserProfileData_AutoChaseAddInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddNightmare, ChaserProfileData_AutoChaseAddNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddApollyon, ChaserProfileData_AutoChaseAddApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootsteps, ChaserProfileData_AutoChaseAddFootstep);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootstepsEasy, ChaserProfileData_AutoChaseAddFootstepEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootstepsHard, ChaserProfileData_AutoChaseAddFootstepHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootstepsInsane, ChaserProfileData_AutoChaseAddFootstepInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootstepsNightmare, ChaserProfileData_AutoChaseAddFootstepNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddFootstepsApollyon, ChaserProfileData_AutoChaseAddFootstepApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoice, ChaserProfileData_AutoChaseAddVoice);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoiceEasy, ChaserProfileData_AutoChaseAddVoiceEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoiceHard, ChaserProfileData_AutoChaseAddVoiceHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoiceInsane, ChaserProfileData_AutoChaseAddVoiceInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoiceNightmare, ChaserProfileData_AutoChaseAddVoiceNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddVoiceApollyon, ChaserProfileData_AutoChaseAddVoiceApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeapon, ChaserProfileData_AutoChaseAddWeapon);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeaponEasy, ChaserProfileData_AutoChaseAddWeaponEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeaponHard, ChaserProfileData_AutoChaseAddWeaponHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeaponInsane, ChaserProfileData_AutoChaseAddWeaponInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeaponNightmare, ChaserProfileData_AutoChaseAddWeaponNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, iAutoChaseAddWeaponApollyon, ChaserProfileData_AutoChaseAddWeaponApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bAutoChaseSprinters, ChaserProfileData_AutoChaseSprinters);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bChasesEndlessly, ChaserProfileData_ChasesEndlessly);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bCrawlingEnabled, ChaserProfileData_CrawlingEnabled);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplierEasy, ChaserProfileData_CrawlSpeedMultiplierEasy);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplier, ChaserProfileData_CrawlSpeedMultiplierNormal);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplierHard, ChaserProfileData_CrawlSpeedMultiplierHard);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplierInsane, ChaserProfileData_CrawlSpeedMultiplierInsane);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplierNightmare, ChaserProfileData_CrawlSpeedMultiplierNightmare);
	g_hChaserProfileData.Set(iUniqueProfileIndex, flCrawlSpeedMultiplierApollyon, ChaserProfileData_CrawlSpeedMultiplierApollyon);

	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("multi_attack_sounds")), ChaserProfileData_MultiAttackSounds);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("multi_hit_sounds")), ChaserProfileData_MultiHitSounds);
	g_hChaserProfileData.Set(iUniqueProfileIndex, view_as<bool>(kv.GetNum("multi_miss_sounds")), ChaserProfileData_MultiMissSounds);

	g_hChaserProfileData.Set(iUniqueProfileIndex, bChaseOnLook, ChaserProfileData_ChaseOnLook);

	ParseChaserProfileAttacks(kv, iUniqueProfileIndex);
	
	return true;
}

public int ParseChaserProfileAttacks(KeyValues kv,int iUniqueProfileIndex)
{
	// Create the array.
	ArrayList hAttacks = new ArrayList(ChaserProfileAttackData_MaxStats);
	g_hChaserProfileData.Set(iUniqueProfileIndex, hAttacks, ChaserProfileData_Attacks);
	
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

		int iAttackIndex = hAttacks.Push(-1);
		
		hAttacks.Set(iAttackIndex, iAttackType, ChaserProfileAttackData_Type);
		hAttacks.Set(iAttackIndex, bAttackProps, ChaserProfileAttackData_CanUseAgainstProps);
		hAttacks.Set(iAttackIndex, flAttackRange, ChaserProfileAttackData_Range);
		hAttacks.Set(iAttackIndex, flAttackDamage, ChaserProfileAttackData_Damage);
		hAttacks.Set(iAttackIndex, flAttackDamageEasy, ChaserProfileAttackData_DamageEasy);
		hAttacks.Set(iAttackIndex, flAttackDamageHard, ChaserProfileAttackData_DamageHard);
		hAttacks.Set(iAttackIndex, flAttackDamageInsane, ChaserProfileAttackData_DamageInsane);
		hAttacks.Set(iAttackIndex, flAttackDamageNightmare, ChaserProfileAttackData_DamageNightmare);
		hAttacks.Set(iAttackIndex, flAttackDamageApollyon, ChaserProfileAttackData_DamageApollyon);
		hAttacks.Set(iAttackIndex, flAttackDamageVsProps, ChaserProfileAttackData_DamageVsProps);
		hAttacks.Set(iAttackIndex, flAttackDamageForce, ChaserProfileAttackData_DamageForce);
		hAttacks.Set(iAttackIndex, iAttackDamageType, ChaserProfileAttackData_DamageType);
		hAttacks.Set(iAttackIndex, flAttackDamageDelay, ChaserProfileAttackData_DamageDelay);
		hAttacks.Set(iAttackIndex, flAttackDuration, ChaserProfileAttackData_Duration);
		hAttacks.Set(iAttackIndex, flAttackSpread, ChaserProfileAttackData_Spread);
		hAttacks.Set(iAttackIndex, flAttackBeginRange, ChaserProfileAttackData_BeginRange);
		hAttacks.Set(iAttackIndex, flAttackBeginFOV, ChaserProfileAttackData_BeginFOV);
		hAttacks.Set(iAttackIndex, flAttackCooldown, ChaserProfileAttackData_Cooldown);
		hAttacks.Set(iAttackIndex, flAttackCooldownEasy, ChaserProfileAttackData_CooldownEasy);
		hAttacks.Set(iAttackIndex, flAttackCooldownHard, ChaserProfileAttackData_CooldownHard);
		hAttacks.Set(iAttackIndex, flAttackCooldownInsane, ChaserProfileAttackData_CooldownInsane);
		hAttacks.Set(iAttackIndex, flAttackCooldownNightmare, ChaserProfileAttackData_CooldownNightmare);
		hAttacks.Set(iAttackIndex, flAttackCooldownApollyon, ChaserProfileAttackData_CooldownApollyon);
		hAttacks.Set(iAttackIndex, bAttackDisappear, ChaserProfileAttackData_Disappear);
		hAttacks.Set(iAttackIndex, iAttackRepeat, ChaserProfileAttackData_Repeat);
		hAttacks.Set(iAttackIndex, iMaxAttackRepeat, ChaserProfileAttackData_MaxAttackRepeat);
		hAttacks.Set(iAttackIndex, bAttackIgnoreAlwaysLooking, ChaserProfileAttackData_IgnoreAlwaysLooking);
		hAttacks.Set(iAttackIndex, iAttackWeaponInt, ChaserProfileAttackData_WeaponInt);
		hAttacks.Set(iAttackIndex, bAttackWeapons, ChaserProfileAttackData_CanUseWeaponTypes);
		hAttacks.Set(iAttackIndex, bAttackLifeSteal, ChaserProfileAttackData_LifeStealEnabled);
		hAttacks.Set(iAttackIndex, flAttackLifeStealDuration, ChaserProfileAttackData_LifeStealDuration);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamage, ChaserProfileAttackData_ProjectileDamage);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamageEasy, ChaserProfileAttackData_ProjectileDamageEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamageHard, ChaserProfileAttackData_ProjectileDamageHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamageInsane, ChaserProfileAttackData_ProjectileDamageInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamageNightmare, ChaserProfileAttackData_ProjectileDamageNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileDamageApollyon, ChaserProfileAttackData_ProjectileDamageApollyon);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeed, ChaserProfileAttackData_ProjectileSpeed);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeedEasy, ChaserProfileAttackData_ProjectileSpeedEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeedHard, ChaserProfileAttackData_ProjectileSpeedHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeedInsane, ChaserProfileAttackData_ProjectileSpeedInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeedNightmare, ChaserProfileAttackData_ProjectileSpeedNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileSpeedApollyon, ChaserProfileAttackData_ProjectileSpeedApollyon);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadius, ChaserProfileAttackData_ProjectileRadius);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadiusEasy, ChaserProfileAttackData_ProjectileRadiusEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadiusHard, ChaserProfileAttackData_ProjectileRadiusHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadiusInsane, ChaserProfileAttackData_ProjectileRadiusInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadiusNightmare, ChaserProfileAttackData_ProjectileRadiusNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileRadiusApollyon, ChaserProfileAttackData_ProjectileRadiusApollyon);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviation, ChaserProfileAttackData_ProjectileDeviation);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviationEasy, ChaserProfileAttackData_ProjectileDeviationEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviationHard, ChaserProfileAttackData_ProjectileDeviationHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviationInsane, ChaserProfileAttackData_ProjectileDeviationInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviationNightmare, ChaserProfileAttackData_ProjectileDeviationNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileDeviationApollyon, ChaserProfileAttackData_ProjectileDeviationApollyon);
		hAttacks.Set(iAttackIndex, bAttackCritProjectiles, ChaserProfileAttackData_ProjectileCrits);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercent, ChaserProfileAttackData_ProjectileIceSlowdownPercent);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercentEasy, ChaserProfileAttackData_ProjectileIceSlowdownPercentEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercentHard, ChaserProfileAttackData_ProjectileIceSlowdownPercentHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercentInsane, ChaserProfileAttackData_ProjectileIceSlowdownPercentInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercentNightmare, ChaserProfileAttackData_ProjectileIceSlowdownPercentNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownPercentApollyon, ChaserProfileAttackData_ProjectileIceSlowdownPercentApollyon);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDuration, ChaserProfileAttackData_ProjectileIceSlowdownDuration);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDurationEasy, ChaserProfileAttackData_ProjectileIceSlowdownDurationEasy);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDurationHard, ChaserProfileAttackData_ProjectileIceSlowdownDurationHard);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDurationInsane, ChaserProfileAttackData_ProjectileIceSlowdownDurationInsane);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDurationNightmare, ChaserProfileAttackData_ProjectileIceSlowdownDurationNightmare);
		hAttacks.Set(iAttackIndex, flAttackProjectileIceSlowdownDurationApollyon, ChaserProfileAttackData_ProjectileIceSlowdownDurationApollyon);
		hAttacks.Set(iAttackIndex, iAttackProjectileCount, ChaserProfileAttackData_ProjectileCount);
		hAttacks.Set(iAttackIndex, iAttackProjectileCountEasy, ChaserProfileAttackData_ProjectileCountEasy);
		hAttacks.Set(iAttackIndex, iAttackProjectileCountHard, ChaserProfileAttackData_ProjectileCountHard);
		hAttacks.Set(iAttackIndex, iAttackProjectileCountInsane, ChaserProfileAttackData_ProjectileCountInsane);
		hAttacks.Set(iAttackIndex, iAttackProjectileCountNightmare, ChaserProfileAttackData_ProjectileCountNightmare);
		hAttacks.Set(iAttackIndex, iAttackProjectileCountApollyon, ChaserProfileAttackData_ProjectileCountApollyon);
		hAttacks.Set(iAttackIndex, iAttackProjectileType, ChaserProfileAttackData_ProjectileType);
		hAttacks.Set(iAttackIndex, iAttackBulletCount, ChaserProfileAttackData_BulletCount);
		hAttacks.Set(iAttackIndex, iAttackBulletCountEasy, ChaserProfileAttackData_BulletCountEasy);
		hAttacks.Set(iAttackIndex, iAttackBulletCountHard, ChaserProfileAttackData_BulletCountHard);
		hAttacks.Set(iAttackIndex, iAttackBulletCountInsane, ChaserProfileAttackData_BulletCountInsane);
		hAttacks.Set(iAttackIndex, iAttackBulletCountNightmare, ChaserProfileAttackData_BulletCountNightmare);
		hAttacks.Set(iAttackIndex, iAttackBulletCountApollyon, ChaserProfileAttackData_BulletCountApollyon);
		hAttacks.Set(iAttackIndex, flAttackBulletDamage, ChaserProfileAttackData_BulletDamage);
		hAttacks.Set(iAttackIndex, flAttackBulletDamageEasy, ChaserProfileAttackData_BulletDamageEasy);
		hAttacks.Set(iAttackIndex, flAttackBulletDamageHard, ChaserProfileAttackData_BulletDamageHard);
		hAttacks.Set(iAttackIndex, flAttackBulletDamageInsane, ChaserProfileAttackData_BulletDamageInsane);
		hAttacks.Set(iAttackIndex, flAttackBulletDamageNightmare, ChaserProfileAttackData_BulletDamageNightmare);
		hAttacks.Set(iAttackIndex, flAttackBulletDamageApollyon, ChaserProfileAttackData_BulletDamageApollyon);
		hAttacks.Set(iAttackIndex, flAttackBulletSpread, ChaserProfileAttackData_BulletSpread);
		hAttacks.Set(iAttackIndex, flAttackBulletSpreadEasy, ChaserProfileAttackData_BulletSpreadEasy);
		hAttacks.Set(iAttackIndex, flAttackBulletSpreadHard, ChaserProfileAttackData_BulletSpreadHard);
		hAttacks.Set(iAttackIndex, flAttackBulletSpreadInsane, ChaserProfileAttackData_BulletSpreadInsane);
		hAttacks.Set(iAttackIndex, flAttackBulletSpreadNightmare, ChaserProfileAttackData_BulletSpreadNightmare);
		hAttacks.Set(iAttackIndex, flAttackBulletSpreadApollyon, ChaserProfileAttackData_BulletSpreadApollyon);
		hAttacks.Set(iAttackIndex, flAttackLaserDamage, ChaserProfileAttackData_LaserDamage);
		hAttacks.Set(iAttackIndex, flAttackLaserDamageEasy, ChaserProfileAttackData_LaserDamageEasy);
		hAttacks.Set(iAttackIndex, flAttackLaserDamageHard, ChaserProfileAttackData_LaserDamageHard);
		hAttacks.Set(iAttackIndex, flAttackLaserDamageInsane, ChaserProfileAttackData_LaserDamageInsane);
		hAttacks.Set(iAttackIndex, flAttackLaserDamageNightmare, ChaserProfileAttackData_LaserDamageNightmare);
		hAttacks.Set(iAttackIndex, flAttackLaserDamageApollyon, ChaserProfileAttackData_LaserDamageApollyon);
		hAttacks.Set(iAttackIndex, flAttackLaserSize, ChaserProfileAttackData_LaserSize);
		hAttacks.Set(iAttackIndex, iAttackLaserColorR, ChaserProfileAttackData_LaserColorR);
		hAttacks.Set(iAttackIndex, iAttackLaserColorG, ChaserProfileAttackData_LaserColorG);
		hAttacks.Set(iAttackIndex, iAttackLaserColorB, ChaserProfileAttackData_LaserColorB);
		hAttacks.Set(iAttackIndex, bAttackLaserAttachment, ChaserProfileAttackData_LaserAttachment);
		hAttacks.Set(iAttackIndex, flAttackLaserDuration, ChaserProfileAttackData_LaserDuration);
		hAttacks.Set(iAttackIndex, flAttackLaserNoise, ChaserProfileAttackData_LaserNoise);
		hAttacks.Set(iAttackIndex, bAttackPullIn, ChaserProfileAttackData_PullIn);
		hAttacks.Set(iAttackIndex, bAttackWhileRunning, ChaserProfileAttackData_CanAttackWhileRunning);
		hAttacks.Set(iAttackIndex, flAttackRunSpeed, ChaserProfileAttackData_RunSpeed);
		hAttacks.Set(iAttackIndex, flAttackRunSpeedEasy, ChaserProfileAttackData_RunSpeedEasy);
		hAttacks.Set(iAttackIndex, flAttackRunSpeedHard, ChaserProfileAttackData_RunSpeedHard);
		hAttacks.Set(iAttackIndex, flAttackRunSpeedInsane, ChaserProfileAttackData_RunSpeedInsane);
		hAttacks.Set(iAttackIndex, flAttackRunSpeedNightmare, ChaserProfileAttackData_RunSpeedNightmare);
		hAttacks.Set(iAttackIndex, flAttackRunSpeedApollyon, ChaserProfileAttackData_RunSpeedApollyon);	
		hAttacks.Set(iAttackIndex, flAttackRunDuration, ChaserProfileAttackData_RunDuration);
		hAttacks.Set(iAttackIndex, flAttackRunDelay, ChaserProfileAttackData_RunDelay);
		hAttacks.Set(iAttackIndex, iAttackUseOnDifficulty, ChaserProfileAttackData_UseOnDifficulty);
		hAttacks.Set(iAttackIndex, iAttackBlockOnDifficulty, ChaserProfileAttackData_BlockOnDifficulty);
		hAttacks.Set(iAttackIndex, iAttackExplosiveDanceRadius, ChaserProfileAttackData_ExplosiveDanceRadius);
		hAttacks.Set(iAttackIndex, bAttackGestures, ChaserProfileAttackData_Gestures);
		hAttacks.Set(iAttackIndex, bAttackDeathCamLowHealth, ChaserProfileAttackData_DeathCamLowHealth);
		hAttacks.Set(iAttackIndex, flAttackUseOnHealth, ChaserProfileAttackData_UseOnHealth);
		hAttacks.Set(iAttackIndex, flAttackBlockOnHealth, ChaserProfileAttackData_BlockOnHealth);

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

stock bool GetProfileGesture(int iBossIndex, const char[] sProfile, int iAnimationSection, char[] sAnimation, int iLenght, float &flPlaybackRate, float &flCycle, int iAnimationIndex = -1)
{
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
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
	if (g_hConfig.JumpToKey("animations"))
	{
		if (g_hConfig.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_hConfig.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_hConfig.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_hConfig.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	g_hConfig.GetString(sKeyGestureName, sAnimation, iLenght);
	flPlaybackRate = g_hConfig.GetFloat(sKeyGesturePlayBackRate, 1.0);
	flCycle = g_hConfig.GetFloat(sKeyGestureCycle, 0.0);
	return true;
}

stock bool GetProfileAnimation(int iBossIndex, const char[] sProfile, int iAnimationSection, char[] sAnimation, int iLenght, float &flPlaybackRate, int difficulty, int iAnimationIndex = -1, float &flFootstepInterval, float &flCycle = 0.0)
{
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	char sAnimationSection[40], sKeyAnimationName[65], sKeyAnimationPlayBackRate[65], sKeyAnimationFootstepInt[65], sKeyAnimationCycle[65];
	switch (iAnimationSection)
	{
		case ChaserAnimation_IdleAnimations:
		{
			strcopy(sAnimationSection, sizeof(sAnimationSection), "idle");
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
			if (g_bSlenderDifficultyAnimations[iBossIndex])
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
	
	if (g_hConfig.JumpToKey("animations"))
	{
		if (g_hConfig.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_hConfig.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_hConfig.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_hConfig.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	g_hConfig.GetString(sKeyAnimationName, sAnimation, iLenght);
	flPlaybackRate = g_hConfig.GetFloat(sKeyAnimationPlayBackRate, 1.0);
	flFootstepInterval = g_hConfig.GetFloat(sKeyAnimationFootstepInt);
	flCycle = g_hConfig.GetFloat(sKeyAnimationCycle);
	return true;
}

stock bool GetProfileBlendAnimationSpeed(const char[] sProfile, int iAnimationSection, float &flPlaybackRate, int iAnimationIndex = -1)
{
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
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
	
	if (g_hConfig.JumpToKey("animations"))
	{
		if (g_hConfig.JumpToKey(sAnimationSection))
		{
			char sNum[3];
			if (iAnimationIndex == -1)
			{
				int iTotalAnimation;
				for (iAnimationIndex = 1; iAnimationIndex <= SF2_CHASER_BOSS_MAX_ANIMATIONS; iAnimationIndex++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
					if (g_hConfig.JumpToKey(sNum))
					{
						iTotalAnimation++;
						g_hConfig.GoBack();
					}
				}
				iAnimationIndex = GetRandomInt(1, iTotalAnimation);
			}
			FormatEx(sNum, sizeof(sNum), "%d", iAnimationIndex);
			if (!g_hConfig.JumpToKey(sNum))
			{
				return false;
			}
		}
		else
			return false;
	}
	flPlaybackRate = g_hConfig.GetFloat(sKeyAnimationPlayBackRate, 1.0);
	return true;
}
