#if defined _sf2_profiles_precache_included
 #endinput
#endif
#define _sf2_profiles_precache_included

#pragma semicolon 1

/**
 *	Loads a profile in the current KeyValues position in kv.
 */
bool LoadBossProfile(KeyValues kv, const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen, bool lookIntoLoads = false, const char[] originalDir = "")
{
	SF2BossProfileData profileData;
	profileData.Init();

	if (kv.JumpToKey("map_blacklist"))
	{
		char s1[4], s2[64], s3[64];
		GetCurrentMap(s3, sizeof(s3));
		for (int i = 1;; i++)
		{
			FormatEx(s1, sizeof(s1), "%d", i);
			kv.GetString(s1, s2, sizeof(s2));
			if (s2[0] == '\0')
			{
				break;
			}

			if (StrContains(s3, s2, false) != -1)
			{
				FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "is blacklisted on %s!", s3);
				return false;
			}
		}

		kv.GoBack();
	}

	if (lookIntoLoads)
	{
		// In this, we're basically just gonna go look for companion bosses and skip them here
		bool skip = true;

		if (kv.GetNum("enable_random_selection", true) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("admin_only", false) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("enable_random_selection_boxing", false) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("enable_random_selection_renevant", false) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("enable_random_selection_renevant_admin", false) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("is_pve", false) != 0 && kv.GetNum("pve_selectable", 1) != 0)
		{
			skip = false;
		}

		if (kv.GetNum("always_load", false) != 0)
		{
			skip = false;
		}

		if (kv.JumpToKey("pve") && kv.GetNum("selectable", 1) != 0)
		{
			kv.GoBack();
			skip = false;
		}

		if (skip)
		{
			FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "is not selectable, skipping!");
			return false;
		}
	}

	profileData.Models = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	profileData.Names = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	SetProfileDifficultyStringArrayValues(kv, "model", profileData.Models, true);
	char modelName[PLATFORM_MAX_PATH];
	for (int i = 0; i < profileData.Models.Length; i++)
	{
		profileData.Models.GetString(i, modelName, sizeof(modelName));
		if (modelName[0] != '\0' && strcmp(modelName, "models/", true) != 0 && strcmp(modelName, "models\\", true) != 0)
		{
			PrecacheModel2(modelName, _, _, g_FileCheckConVar.BoolValue);
		}
	}
	SetProfileDifficultyStringArrayValues(kv, "name", profileData.Names);

	profileData.Type = kv.GetNum("type", profileData.Type);
	if (profileData.Type == SF2BossType_Unknown || profileData.Type >= SF2BossType_MaxTypes)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "boss type is unknown!");
		return false;
	}

	profileData.ModelScale = kv.GetFloat("model_scale", profileData.ModelScale);
	if (profileData.ModelScale <= 0.0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "model_scale must be a value greater than 0!");
		return false;
	}

	profileData.Skin[1] = kv.GetNum("skin", profileData.Skin[1]);
	if (profileData.Skin[1] < 0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "skin must be a value that is at least 0!");
		return false;
	}
	GetProfileDifficultyNumValues(kv, "skin", profileData.Skin, profileData.Skin);

	profileData.SkinMax = kv.GetNum("skin_max", profileData.SkinMax);
	if (profileData.SkinMax < 0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "skin_max must be a value that is at least 0!");
		return false;
	}

	profileData.SkinDifficultiesOn = kv.GetNum("skin_difficulty", profileData.SkinDifficultiesOn) != 0;

	profileData.Body[1] = kv.GetNum("body", profileData.Body[1]);
	if (profileData.Body[1] < 0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "body must be a value that is at least 0!");
		return false;
	}
	GetProfileDifficultyNumValues(kv, "body", profileData.Body, profileData.Body);

	profileData.BodyMax = kv.GetNum("body_max", profileData.BodyMax);
	if (profileData.BodyMax < 0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "body_max must be a value that is at least 0!");
		return false;
	}

	profileData.BodyDifficultiesOn = kv.GetNum("body_difficulty", profileData.BodyDifficultiesOn) != 0;

	profileData.RaidHitbox = kv.GetNum("use_raid_hitbox", profileData.RaidHitbox) != 0;

	profileData.InstantKillRadius = kv.GetFloat("kill_radius", profileData.InstantKillRadius);

	profileData.ScareRadius = kv.GetFloat("scare_radius", profileData.ScareRadius);
	if (profileData.ScareRadius < 0.0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "scare_radius must be a value that is at least 0!");
		return false;
	}

	profileData.TeleportType = kv.GetNum("teleport_type", profileData.TeleportType);
	if (profileData.TeleportType < 0)
	{
		FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "unknown teleport type!");
		return false;
	}

	FormatEx(loadFailReasonBuffer, loadFailReasonBufferLen, "unknown!");

	profileData.FOV = kv.GetFloat("fov", profileData.FOV);
	if (profileData.FOV < 0.0)
	{
		profileData.FOV = 0.0;
	}
	else if (profileData.FOV > 360.0)
	{
		profileData.FOV = 360.0;
	}

	profileData.TurnRate = kv.GetFloat("maxyawrate", profileData.TurnRate);
	profileData.TurnRate = kv.GetFloat("turnrate", profileData.TurnRate);

	switch (profileData.Type)
	{
		case SF2BossType_Chaser:
		{
			profileData.Description.Type = "Chaser";
		}

		case SF2BossType_Statue:
		{
			profileData.Description.Type = "Statue";
		}
	}

	if (kv.JumpToKey("description"))
	{
		profileData.Description.Load(kv);
		kv.GoBack();
	}

	profileData.ScareCooldown = kv.GetFloat("scare_cooldown", profileData.ScareCooldown);
	if (profileData.ScareCooldown < 0.0)
	{
		// clamp value
		profileData.ScareCooldown = 0.0;
	}

	kv.GetVector("mins", profileData.Mins, profileData.Mins);
	kv.GetVector("maxs", profileData.Maxs, profileData.Maxs);

	profileData.StepSize = kv.GetFloat("stepsize", profileData.StepSize);

	profileData.NodeDistanceLookAhead = kv.GetFloat("search_node_dist_lookahead", profileData.NodeDistanceLookAhead);

	GetProfileColorNoBacks(kv, "effect_rendercolor", profileData.RenderColor[0], profileData.RenderColor[1], profileData.RenderColor[2], profileData.RenderColor[3],
							profileData.RenderColor[0], profileData.RenderColor[1], profileData.RenderColor[2], profileData.RenderColor[3]);
	profileData.RenderFX = kv.GetNum("effect_renderfx", profileData.RenderFX);
	profileData.RenderMode = kv.GetNum("effect_rendermode", profileData.RenderMode);

	kv.GetString("kill_weapontype", profileData.WeaponString, sizeof(profileData.WeaponString), profileData.WeaponString);
	profileData.WeaponInt = kv.GetNum("kill_weapontype", profileData.WeaponInt);

	profileData.DiscoMode = kv.GetNum("disco_mode", profileData.DiscoMode) != 0;
	if (profileData.DiscoMode)
	{
		profileData.DiscoDistanceMin = kv.GetFloat("disco_mode_rng_distance_min", profileData.DiscoDistanceMin);
		profileData.DiscoDistanceMax = kv.GetFloat("disco_mode_rng_distance_max", profileData.DiscoDistanceMax);
		kv.GetVector("disco_mode_pos", profileData.DiscoPos, profileData.DiscoPos);
	}

	profileData.FestiveLights = kv.GetNum("festive_lights", profileData.FestiveLights) != 0;
	if (profileData.FestiveLights)
	{
		profileData.FestiveLightBrightness = kv.GetNum("festive_light_brightness", profileData.FestiveLightBrightness);
		profileData.FestiveLightDistance = kv.GetFloat("festive_light_distance", profileData.FestiveLightDistance);
		profileData.FestiveLightRadius = kv.GetFloat("festive_light_radius", profileData.FestiveLightRadius);
		kv.GetVector("festive_lights_pos", profileData.FestiveLightPos, profileData.FestiveLightPos);
		kv.GetVector("festive_lights_ang", profileData.FestiveLightAng, profileData.FestiveLightAng);
	}

	if (kv.GetNum("tp_effect_spawn", false) != 0)
	{
		if (profileData.SpawnEffects == null)
		{
			profileData.SpawnEffects = new StringMap();
		}
		ArrayList listEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

		SF2BossProfileBaseEffectInfo particle;
		SF2BossProfileBaseEffectInfo sound;

		particle.Init();
		particle.Type = EffectType_Particle;
		particle.Event = EffectEvent_Constant;
		kv.GetString("tp_effect_spawn_particle", particle.ParticleName, sizeof(particle.ParticleName), particle.ParticleName);
		particle.LifeTime = 0.1;
		kv.GetVector("tp_effect_origin", particle.Origin, particle.Origin);
		particle.PostLoad();
		listEffects.PushArray(particle);

		char soundName[PLATFORM_MAX_PATH];
		sound.Init();
		sound.Type = EffectType_Sound;
		sound.Event = EffectEvent_Constant;
		kv.GetString("tp_effect_spawn_sound", soundName, sizeof(soundName), soundName);
		TryPrecacheBossProfileSoundPath(soundName, g_FileCheckConVar.BoolValue);
		sound.SoundSounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		sound.SoundSounds.Paths.PushString(soundName);
		sound.SoundSounds.Volume = kv.GetFloat("tp_effect_spawn_sound_volume", sound.SoundSounds.Volume);
		sound.SoundSounds.Pitch = kv.GetNum("tp_effect_spawn_sound_pitch", sound.SoundSounds.Pitch);
		sound.SoundSounds.PostLoad();
		listEffects.PushArray(sound);

		profileData.SpawnEffects.SetValue("TPEffectSpawnBackwards", listEffects);
	}

	if (kv.GetNum("tp_effect_despawn", false) != 0)
	{
		if (profileData.DespawnEffects == null)
		{
			profileData.DespawnEffects = new StringMap();
		}
		ArrayList listEffects = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

		SF2BossProfileBaseEffectInfo particle;
		SF2BossProfileBaseEffectInfo sound;

		particle.Init();
		particle.Type = EffectType_Particle;
		particle.Event = EffectEvent_Constant;
		kv.GetString("tp_effect_despawn_particle", particle.ParticleName, sizeof(particle.ParticleName), particle.ParticleName);
		particle.LifeTime = 0.1;
		kv.GetVector("tp_effect_origin", particle.Origin, particle.Origin);
		particle.PostLoad();
		listEffects.PushArray(particle);

		char soundName[PLATFORM_MAX_PATH];
		sound.Init();
		sound.Type = EffectType_Sound;
		sound.Event = EffectEvent_Constant;
		kv.GetString("tp_effect_despawn_sound", soundName, sizeof(soundName), soundName);
		TryPrecacheBossProfileSoundPath(soundName, g_FileCheckConVar.BoolValue);
		sound.SoundSounds.Paths = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		sound.SoundSounds.Paths.PushString(soundName);
		sound.SoundSounds.Volume = kv.GetFloat("tp_effect_despawn_sound_volume", sound.SoundSounds.Volume);
		sound.SoundSounds.Pitch = kv.GetNum("tp_effect_despawn_sound_pitch", sound.SoundSounds.Pitch);
		sound.SoundSounds.PostLoad();
		listEffects.PushArray(sound);

		profileData.DespawnEffects.SetValue("TPEffectDespawnBackwards", listEffects);
	}

	profileData.BlinkLookRate = kv.GetFloat("blink_look_rate_multiply", profileData.BlinkLookRate);
	profileData.BlinkStaticRate = kv.GetFloat("blink_static_rate_multiply", profileData.BlinkStaticRate);

	profileData.DeathCam = kv.GetNum("death_cam", profileData.DeathCam) != 0;
	if (profileData.DeathCam)
	{
		profileData.DeathCamScareSound = kv.GetNum("death_cam_play_scare_sound", profileData.DeathCamScareSound) != 0;
		profileData.PublicDeathCam = kv.GetNum("death_cam_public", profileData.PublicDeathCam) != 0;
		if (profileData.PublicDeathCam)
		{
			profileData.PublicDeathCamSpeed = kv.GetFloat("death_cam_speed", profileData.PublicDeathCamSpeed);
			profileData.PublicDeathCamAcceleration = kv.GetFloat("death_cam_acceleration", profileData.PublicDeathCamAcceleration);
			profileData.PublicDeathCamDeceleration = kv.GetFloat("death_cam_deceleration", profileData.PublicDeathCamDeceleration);
			profileData.PublicDeathCamBackwardOffset = kv.GetFloat("deathcam_death_backward_offset", profileData.PublicDeathCamBackwardOffset);
			profileData.PublicDeathCamDownwardOffset = kv.GetFloat("deathcam_death_downward_offset", profileData.PublicDeathCamDownwardOffset);
		}
		profileData.DeathCamOverlay = kv.GetNum("death_cam_overlay", profileData.DeathCamOverlay) != 0;
		profileData.DeathCamOverlayStartTime = kv.GetFloat("death_cam_time_overlay_start", profileData.DeathCamOverlayStartTime);
		if (profileData.DeathCamOverlayStartTime < 0.0)
		{
			profileData.DeathCamOverlayStartTime = 0.0;
		}
		profileData.DeathCamTime = kv.GetFloat("death_cam_time_death", profileData.DeathCamTime);
		if (profileData.DeathCamTime < 0.0)
		{
			profileData.DeathCamTime = 0.0;
		}
		kv.GetVector("death_cam_pos", profileData.DeathCamPos, profileData.DeathCamPos);
		kv.GetString("death_cam_attachtment_target_point", profileData.PublicDeathCamAttachmentTarget, sizeof(profileData.PublicDeathCamAttachmentTarget), profileData.PublicDeathCamAttachmentTarget);
		kv.GetString("death_cam_attachtment_point", profileData.PublicDeathCamAttachment, sizeof(profileData.PublicDeathCamAttachment), profileData.PublicDeathCamAttachment);
	}

	if (kv.JumpToKey("public_death_cam"))
	{
		profileData.DeathCamData.Load(kv, g_FileCheckConVar.BoolValue);
		kv.GoBack();
	}

	GetProfileDifficultyFloatValues(kv, "sound_music_loop", profileData.SoundMusicLoop, profileData.SoundMusicLoop);
	GetProfileDifficultyFloatValues(kv, "kill_cooldown", profileData.InstantKillCooldown, profileData.InstantKillCooldown);

	GetProfileDifficultyFloatValues(kv, "search_view_distance", profileData.SearchRange, profileData.SearchRange);
	GetProfileDifficultyFloatValues(kv, "search_range", profileData.SearchRange, profileData.SearchRange);
	GetProfileDifficultyFloatValues(kv, "hearing_range", profileData.SearchSoundRange, profileData.SearchSoundRange);
	GetProfileDifficultyFloatValues(kv, "search_sound_range", profileData.SearchSoundRange, profileData.SearchSoundRange);
	GetProfileDifficultyFloatValues(kv, "taunt_alert_range", profileData.TauntAlertRange, profileData.TauntAlertRange);

	GetProfileDifficultyBoolValues(kv, "teleport_allowed", profileData.TeleportAllowed, profileData.TeleportAllowed);
	GetProfileDifficultyFloatValues(kv, "teleport_range_min", profileData.TeleportRangeMin, profileData.TeleportRangeMin);
	GetProfileDifficultyFloatValues(kv, "teleport_range_max", profileData.TeleportRangeMax, profileData.TeleportRangeMax);
	GetProfileDifficultyFloatValues(kv, "teleport_time_min", profileData.TeleportTimeMin, profileData.TeleportTimeMin);
	GetProfileDifficultyFloatValues(kv, "teleport_time_max", profileData.TeleportTimeMax, profileData.TeleportTimeMax);
	GetProfileDifficultyFloatValues(kv, "teleport_target_rest_period", profileData.TeleportRestPeriod, profileData.TeleportRestPeriod);
	GetProfileDifficultyFloatValues(kv, "teleport_target_stress_min", profileData.TeleportStressMin, profileData.TeleportStressMin);
	GetProfileDifficultyFloatValues(kv, "teleport_target_stress_max", profileData.TeleportStressMax, profileData.TeleportStressMax);
	GetProfileDifficultyFloatValues(kv, "teleport_target_persistency_period", profileData.TeleportPersistencyPeriod, profileData.TeleportPersistencyPeriod);
	profileData.TeleportIgnoreChases = kv.GetNum("teleport_target_ignore_chases", profileData.TeleportIgnoreChases) != 0;
	profileData.TeleportIgnoreVis = kv.GetNum("teleport_target_ignore_visibility", profileData.TeleportIgnoreVis) != 0;

	GetProfileDifficultyFloatValues(kv, "jumpscare_distance", profileData.JumpscareDistance, profileData.JumpscareDistance);
	GetProfileDifficultyFloatValues(kv, "jumpscare_duration", profileData.JumpscareDuration, profileData.JumpscareDuration);
	GetProfileDifficultyFloatValues(kv, "jumpscare_cooldown", profileData.JumpscareCooldown, profileData.JumpscareCooldown);
	profileData.JumpscareOnScare = kv.GetNum("jumpscare_on_scare", profileData.JumpscareOnScare) != 0;
	profileData.JumpscareNoSight = kv.GetNum("jumpscare_no_sight", profileData.JumpscareNoSight) != 0;

	GetProfileDifficultyFloatValues(kv, "speed", profileData.RunSpeed, profileData.RunSpeed);
	GetProfileDifficultyFloatValues(kv, "acceleration", profileData.Acceleration, profileData.Acceleration);

	GetProfileDifficultyFloatValues(kv, "idle_lifetime", profileData.IdleLifeTime, profileData.IdleLifeTime);

	profileData.CustomOutlines = kv.GetNum("customizable_outlines", profileData.CustomOutlines) != 0;
	if (profileData.CustomOutlines)
	{
		profileData.OutlineColor[0] = kv.GetNum("outline_color_r", profileData.OutlineColor[0]);
		profileData.OutlineColor[1] = kv.GetNum("outline_color_g", profileData.OutlineColor[1]);
		profileData.OutlineColor[2] = kv.GetNum("outline_color_b", profileData.OutlineColor[2]);
		profileData.OutlineColor[3] = kv.GetNum("outline_color_transparency", profileData.OutlineColor[3]);
		profileData.RainbowOutline = !!kv.GetNum("enable_rainbow_outline", profileData.RainbowOutline);
		if (profileData.RainbowOutline)
		{
			profileData.RainbowOutlineCycle = kv.GetFloat("rainbow_outline_cycle_rate", profileData.RainbowOutlineCycle);
			if (profileData.RainbowOutlineCycle < 0.0)
			{
				profileData.RainbowOutlineCycle = 0.0;
			}
		}
	}

	profileData.SpeedBoostOnScare = !!kv.GetNum("scare_player_speed_boost", profileData.SpeedBoostOnScare);
	if (profileData.SpeedBoostOnScare)
	{
		profileData.ScareSpeedBoostDuration = kv.GetFloat("scare_player_speed_boost_duration", profileData.ScareSpeedBoostDuration);
	}

	profileData.ScareReaction = !!kv.GetNum("scare_player_reaction", profileData.ScareReaction);
	if (profileData.ScareReaction)
	{
		profileData.ScareReactionType = kv.GetNum("scare_player_reaction_type", profileData.ScareReactionType);
		if (profileData.ScareReactionType < 1)
		{
			profileData.ScareReactionType = 1;
		}
		if (profileData.ScareReactionType > 3)
		{
			profileData.ScareReactionType = 3;
		}
		kv.GetString("scare_player_reaction_response_custom", profileData.ScareReactionCustom, sizeof(profileData.ScareReactionCustom), profileData.ScareReactionCustom);
	}

	profileData.ScareReplenishSprint = kv.GetNum("scare_player_replenish_sprint", profileData.ScareReplenishSprint) != 0;
	if (profileData.ScareReplenishSprint)
	{
		profileData.ScareReplenishSprintAmount = kv.GetFloat("scare_player_replenish_sprint_amount", profileData.ScareReplenishSprintAmount);
	}

	GetProfileDifficultyFloatValues(kv, "static_radius", profileData.StaticRadius, profileData.StaticRadius);
	GetProfileDifficultyFloatValues(kv, "static_rate", profileData.StaticRate, profileData.StaticRate);
	GetProfileDifficultyFloatValues(kv, "static_rate_decay", profileData.StaticRateDecay, profileData.StaticRateDecay);
	GetProfileDifficultyFloatValues(kv, "static_on_look_gracetime", profileData.StaticGraceTime, profileData.StaticGraceTime);
	profileData.StaticScareAmount = kv.GetFloat("scare_static_amount", profileData.StaticScareAmount);

	profileData.StaticShakeLocalLevel = kv.GetNum("sound_static_loop_local_level", profileData.StaticShakeLocalLevel);
	profileData.StaticShakeVolumeMin = kv.GetFloat("sound_static_shake_local_volume_min", profileData.StaticShakeVolumeMin);
	profileData.StaticShakeVolumeMax = kv.GetFloat("sound_static_shake_local_volume_max", profileData.StaticShakeVolumeMax);

	profileData.DrainCredits = !!kv.GetNum("drain_credits_on_kill", profileData.DrainCredits);
	GetProfileDifficultyNumValues(kv, "drain_credits_amount", profileData.DrainCreditAmount, profileData.DrainCreditAmount);

	profileData.Healthbar = !!kv.GetNum("healthbar", profileData.Healthbar);

	profileData.DeathMessageDifficultyIndexes = kv.GetNum("chat_message_upon_death_difficulty_indexes", profileData.DeathMessageDifficultyIndexes);
	if (kv.JumpToKey("chat_message_upon_death"))
	{
		profileData.DeathMessagesArray = new ArrayList(ByteCountToCells(256));
		char message[256], section[64];
		for (int i = 1;; i++)
		{
			FormatEx(section, sizeof(section), "%d", i);
			kv.GetString(section, message, sizeof(message));
			if (message[0] == '\0')
			{
				break;
			}

			profileData.DeathMessagesArray.PushString(message);
		}
		kv.GoBack();
	}
	kv.GetString("chat_message_upon_death_prefix", profileData.DeathMessagePrefix, sizeof(profileData.DeathMessagePrefix), profileData.DeathMessagePrefix);

	profileData.BurnRagdoll = kv.GetNum("burn_ragdoll_on_kill", profileData.BurnRagdoll) != 0;
	profileData.CloakRagdoll = kv.GetNum("cloak_ragdoll_on_kill", profileData.CloakRagdoll) != 0;
	profileData.DecapRagdoll = kv.GetNum("decap_ragdoll_on_kill", profileData.DecapRagdoll) != 0;
	profileData.GibRagdoll = kv.GetNum("gib_ragdoll_on_kill", profileData.GibRagdoll) != 0;
	profileData.IceRagdoll = kv.GetNum("ice_ragdoll_on_kill", profileData.IceRagdoll) != 0;
	profileData.GoldRagdoll = kv.GetNum("gold_ragdoll_on_kill", profileData.GoldRagdoll) != 0;
	profileData.ElectrocuteRagdoll = kv.GetNum("electrocute_ragdoll_on_kill", profileData.ElectrocuteRagdoll) != 0;
	profileData.AshRagdoll = kv.GetNum("disintegrate_ragdoll_on_kill", profileData.AshRagdoll) != 0;
	profileData.DeleteRagdoll = kv.GetNum("delete_ragdoll_on_kill", profileData.DeleteRagdoll) != 0;
	profileData.PushRagdoll = kv.GetNum("push_ragdoll_on_kill", profileData.PushRagdoll) != 0;
	if (profileData.PushRagdoll)
	{
		kv.GetVector("push_ragdoll_force", profileData.PushRagdollForce, profileData.PushRagdollForce);
	}
	profileData.DissolveRagdoll = kv.GetNum("dissolve_ragdoll_on_kill", profileData.DissolveRagdoll) != 0;
	if (profileData.DissolveRagdoll)
	{
		profileData.DissolveKillType = kv.GetNum("dissolve_ragdoll_type", profileData.DissolveKillType);
	}
	profileData.PlasmaRagdoll = kv.GetNum("plasma_ragdoll_on_kill", profileData.PlasmaRagdoll) != 0;
	profileData.ResizeRagdoll = kv.GetNum("resize_ragdoll_on_kill", profileData.ResizeRagdoll) != 0;
	if (profileData.ResizeRagdoll)
	{
		profileData.ResizeRagdollHead = kv.GetFloat("resize_ragdoll_head", profileData.ResizeRagdollHead);
		profileData.ResizeRagdollHands = kv.GetFloat("resize_ragdoll_hands", profileData.ResizeRagdollHands);
		profileData.ResizeRagdollTorso = kv.GetFloat("resize_ragdoll_torso", profileData.ResizeRagdollTorso);
	}
	profileData.DecapOrGibRagdoll = kv.GetNum("decap_or_gib_ragdoll_on_kill", profileData.DecapOrGibRagdoll) != 0;
	profileData.SilentKill = kv.GetNum("silent_kill", profileData.SilentKill) != 0;
	profileData.MultiEffectRagdoll = kv.GetNum("multieffect_ragdoll_on_kill", profileData.MultiEffectRagdoll) != 0;
	profileData.CustomDeathFlag = kv.GetNum("attack_custom_deathflag_enabled", profileData.CustomDeathFlag) != 0;
	if (profileData.CustomDeathFlag)
	{
		profileData.CustomDeathFlagType = kv.GetNum("attack_custom_deathflag", profileData.CustomDeathFlagType);
	}

	profileData.OutroMusic = kv.GetNum("sound_music_outro_enabled", profileData.OutroMusic) != 0;

	profileData.EngineSoundLevel = kv.GetNum("constant_sound_level", profileData.EngineSoundLevel);
	profileData.EngineSoundLevel = kv.GetNum("engine_sound_level", profileData.EngineSoundLevel);
	profileData.EngineSoundVolume = kv.GetFloat("constant_sound_volume", profileData.EngineSoundVolume);
	profileData.EngineSoundVolume = kv.GetFloat("engine_sound_volume", profileData.EngineSoundVolume);

	kv.GetVector("eye_pos", profileData.EyePosOffset, profileData.EyePosOffset);
	kv.GetVector("eye_ang_offset", profileData.EyeAngOffset, profileData.EyeAngOffset);

	if (kv.JumpToKey("eyes"))
	{
		profileData.EyeData.Load(kv);
		kv.GoBack();
		profileData.EyePosOffset = profileData.EyeData.OffsetPos;
		profileData.EyeAngOffset = profileData.EyeData.OffsetAng;
	}

	if (kv.JumpToKey("slaughter_run"))
	{
		profileData.SlaughterRunData.Load(kv);
		kv.GoBack();
	}

	// Parse through flags.
	int bossFlags = 0;
	if (kv.GetNum("static_on_look"))
	{
		bossFlags |= SFF_STATICONLOOK;
	}
	if (kv.GetNum("static_on_radius"))
	{
		bossFlags |= SFF_STATICONRADIUS;
	}
	if (kv.GetNum("proxies"))
	{
		bossFlags |= SFF_PROXIES;
	}
	if (kv.GetNum("jumpscare"))
	{
		bossFlags |= SFF_HASJUMPSCARE;
	}
	if (kv.GetNum("sound_static_loop_local_enabled"))
	{
		bossFlags |= SFF_HASSTATICLOOPLOCALSOUND;
	}
	if (kv.GetNum("view_shake", 1))
	{
		bossFlags |= SFF_HASVIEWSHAKE;
	}
	if (kv.GetNum("wander_move", 1))
	{
		bossFlags |= SFF_WANDERMOVE;
	}
	if (kv.GetNum("attack_props", 0))
	{
		bossFlags |= SFF_ATTACKPROPS;
	}
	if (kv.GetNum("attack_weaponsenable", 0))
	{
		bossFlags |= SFF_WEAPONKILLS;
	}
	if (kv.GetNum("kill_weaponsenable", 0))
	{
		bossFlags |= SFF_WEAPONKILLSONRADIUS;
	}
	if (kv.GetNum("static_shake", 0))
	{
		bossFlags |= SFF_HASSTATICSHAKE;
	}
	profileData.Flags = bossFlags;

	profileData.CopiesInfo.Load(kv);

	if (profileData.Flags & SFF_PROXIES)
	{
		kv.GetString("proxies_classes", profileData.ProxyClasses, sizeof(profileData.ProxyClasses), profileData.ProxyClasses);
		GetProfileDifficultyFloatValues(kv, "proxies_damage_scale_vs_enemy", profileData.ProxyDamageVsEnemy, profileData.ProxyDamageVsEnemy);
		GetProfileDifficultyFloatValues(kv, "proxies_damage_scale_vs_enemy_backstab", profileData.ProxyDamageVsBackstab, profileData.ProxyDamageVsBackstab);
		GetProfileDifficultyFloatValues(kv, "proxies_damage_scale_vs_self", profileData.ProxyDamageVsSelf, profileData.ProxyDamageVsSelf);
		GetProfileDifficultyNumValues(kv, "proxies_controlgain_hitenemy", profileData.ProxyControlGainHitEnemy, profileData.ProxyControlGainHitEnemy);
		GetProfileDifficultyNumValues(kv, "proxies_controlgain_hitbyenemy", profileData.ProxyControlGainHitByEnemy, profileData.ProxyControlGainHitByEnemy);
		GetProfileDifficultyFloatValues(kv, "proxies_controldrainrate", profileData.ProxyControlDrainRate, profileData.ProxyControlDrainRate);
		GetProfileDifficultyNumValues(kv, "proxies_max", profileData.MaxProxies, profileData.MaxProxies);
		GetProfileDifficultyFloatValues(kv, "proxies_spawn_chance_min", profileData.ProxySpawnChanceMin, profileData.ProxySpawnChanceMin);
		GetProfileDifficultyFloatValues(kv, "proxies_spawn_chance_max", profileData.ProxySpawnChaceMax, profileData.ProxySpawnChaceMax);
		GetProfileDifficultyFloatValues(kv, "proxies_spawn_chance_threshold", profileData.ProxySpawnChanceThreshold, profileData.ProxySpawnChanceThreshold);
		GetProfileDifficultyNumValues(kv, "proxies_spawn_num_min", profileData.ProxySpawnNumMin, profileData.ProxySpawnNumMin);
		GetProfileDifficultyNumValues(kv, "proxies_spawn_num_max", profileData.ProxySpawnNumMax, profileData.ProxySpawnNumMax);
		GetProfileDifficultyFloatValues(kv, "proxies_spawn_cooldown_min", profileData.ProxySpawnCooldownMin, profileData.ProxySpawnCooldownMin);
		GetProfileDifficultyFloatValues(kv, "proxies_spawn_cooldown_max", profileData.ProxySpawnCooldownMax, profileData.ProxySpawnCooldownMax);
		GetProfileDifficultyFloatValues(kv, "proxies_teleport_range_min", profileData.ProxyTeleportRangeMin, profileData.ProxyTeleportRangeMin);
		GetProfileDifficultyFloatValues(kv, "proxies_teleport_range_max", profileData.ProxyTeleportRangeMax, profileData.ProxyTeleportRangeMax);
		profileData.ProxyAllowVoices = !!kv.GetNum("proxies_allownormalvoices", profileData.ProxyAllowVoices);
		profileData.ProxyWeapons = !!kv.GetNum("proxies_weapon", profileData.ProxyWeapons);
		profileData.ProxyDeathAnimations = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
		char className[15], deathSection[64], storedAnim[PLATFORM_MAX_PATH];
		for (int i = 0; i < 10; i++)
		{
			TF2_GetClassName(view_as<TFClassType>(i), className, sizeof(className));
			if (i == 0)
			{
				deathSection = "proxies_death_anim_all";
			}
			else
			{
				FormatEx(deathSection, sizeof(deathSection), "proxies_death_anim_%s", className);
			}
			kv.GetString(deathSection, storedAnim, sizeof(storedAnim));
			profileData.ProxyDeathAnimations.PushString(storedAnim);
			if (i == 0)
			{
				deathSection = "proxies_death_anim_frames_all";
			}
			else
			{
				FormatEx(deathSection, sizeof(deathSection), "proxies_death_anim_frames_%s", className);
			}
			profileData.ProxyDeathAnimFrames[i] = kv.GetNum(deathSection);
		}
		if (profileData.ProxyWeapons)
		{
			profileData.ProxyWeaponClassNames = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
			profileData.ProxyWeaponStats = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
			char classKey[15], keyValue[45], arrayStringValue[PLATFORM_MAX_PATH];
			for (int i = 1; i < 10; i++)
			{
				TF2_GetClassName(view_as<TFClassType>(i), classKey, sizeof(classKey));

				FormatEx(keyValue, sizeof(keyValue), "proxies_weapon_class_%s", classKey);
				kv.GetString(keyValue, arrayStringValue, sizeof(arrayStringValue));
				profileData.ProxyWeaponClassNames.PushString(arrayStringValue);

				FormatEx(keyValue, sizeof(keyValue), "proxies_weapon_stats_%s", classKey);
				kv.GetString(keyValue, arrayStringValue, sizeof(arrayStringValue));
				profileData.ProxyWeaponStats.PushString(arrayStringValue);

				FormatEx(keyValue, sizeof(keyValue), "proxies_weapon_index_%s", classKey);
				profileData.ProxyWeaponIndexes[i] = kv.GetNum(keyValue, profileData.ProxyWeaponIndexes[i]);

				FormatEx(keyValue, sizeof(keyValue), "proxies_weapon_slot_%s", classKey);
				profileData.ProxyWeaponSlots[i] = kv.GetNum(keyValue, profileData.ProxyWeaponSlots[i]);
			}
		}
		profileData.ProxySpawnEffect = kv.GetNum("proxies_spawn_effect_enabled", profileData.ProxySpawnEffect) != 0;
		if (profileData.ProxySpawnEffect)
		{
			kv.GetString("proxies_spawn_effect", profileData.ProxySpawnEffectName, sizeof(profileData.ProxySpawnEffectName), profileData.ProxySpawnEffectName);
			profileData.ProxySpawnEffectZOffset = kv.GetFloat("proxies_spawn_effect_z_offset", profileData.ProxySpawnEffectZOffset);
		}
		profileData.ProxyZombies = kv.GetNum("proxies_zombie", profileData.ProxyZombies) != 0;
		profileData.ProxyRobots = kv.GetNum("proxies_robot", profileData.ProxyRobots) != 0;
		profileData.ProxyDifficultyModels = kv.GetNum("proxy_difficulty_models", profileData.ProxyDifficultyModels) != 0;

		char index[64], modelDirectory[PLATFORM_MAX_PATH];
		if (profileData.ProxyDifficultyModels)
		{
			for (int i = 0; i < 10; i++)
			{
				for (int j = 1; j < Difficulty_Max; j--)
				{
					TF2_GetClassName(view_as<TFClassType>(i), className, sizeof(className));
					if (i == 0)
					{
						switch (j)
						{
							case Difficulty_Normal:
							{
								deathSection = "mod_proxy_all";
							}
							case Difficulty_Hard:
							{
								deathSection = "mod_proxy_all_hard";
							}
							case Difficulty_Insane:
							{
								deathSection = "mod_proxy_all_insane";
							}
							case Difficulty_Nightmare:
							{
								deathSection = "mod_proxy_all_nightmare";
							}
							case Difficulty_Apollyon:
							{
								deathSection = "mod_proxy_all_apollyon";
							}
						}
					}
					else
					{
						switch (j)
						{
							case Difficulty_Normal:
							{
								FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s", className);
							}
							case Difficulty_Hard:
							{
								FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s_hard", className);
							}
							case Difficulty_Insane:
							{
								FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s_insane", className);
							}
							case Difficulty_Nightmare:
							{
								FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s_nightmare", className);
							}
							case Difficulty_Apollyon:
							{
								FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s_apollyon", className);
							}
						}
					}
					if (kv.JumpToKey(deathSection))
					{
						switch (j)
						{
							case Difficulty_Normal:
							{
								profileData.ProxyModels[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
							}
							case Difficulty_Hard:
							{
								profileData.ProxyModelsHard[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
							}
							case Difficulty_Insane:
							{
								profileData.ProxyModelsInsane[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
							}
							case Difficulty_Nightmare:
							{
								profileData.ProxyModelsNightmare[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
							}
							case Difficulty_Apollyon:
							{
								profileData.ProxyModelsApollyon[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
							}
						}
						for (int i2 = 1;; i2++)
						{
							FormatEx(index, sizeof(index), "%d", i2);
							kv.GetString(index, modelDirectory, sizeof(modelDirectory));
							if (modelDirectory[0] == '\0')
							{
								break;
							}

							if (!PrecacheModel(modelDirectory, true))
							{
								LogSF2Message("Proxy model file %s failed to be precached, this model will not be used.", modelDirectory);
							}
							else
							{
								switch (j)
								{
									case Difficulty_Normal:
									{
										profileData.ProxyModels[i].PushString(modelDirectory);
									}
									case Difficulty_Hard:
									{
										profileData.ProxyModelsHard[i].PushString(modelDirectory);
									}
									case Difficulty_Insane:
									{
										profileData.ProxyModelsInsane[i].PushString(modelDirectory);
									}
									case Difficulty_Nightmare:
									{
										profileData.ProxyModelsNightmare[i].PushString(modelDirectory);
									}
									case Difficulty_Apollyon:
									{
										profileData.ProxyModelsApollyon[i].PushString(modelDirectory);
									}
								}
								PrecacheModel2(modelDirectory, _, _, g_FileCheckConVar.BoolValue);
							}
						}
						kv.GoBack();
					}
				}
			}
		}
		else
		{
			for (int i = 0; i < 10; i++)
			{
				TF2_GetClassName(view_as<TFClassType>(i), className, sizeof(className));
				if (i == 0)
				{
					deathSection = "mod_proxy_all";
				}
				else
				{
					FormatEx(deathSection, sizeof(deathSection), "mod_proxy_%s", className);
				}
				if (kv.JumpToKey(deathSection))
				{
					profileData.ProxyModels[i] = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
					for (int i2 = 1;; i2++)
					{
						FormatEx(index, sizeof(index), "%d", i2);
						kv.GetString(index, modelDirectory, sizeof(modelDirectory));
						if (modelDirectory[0] == '\0')
						{
							break;
						}

						if (!PrecacheModel(modelDirectory, true))
						{
							LogSF2Message("Proxy model file %s failed to be precached, this model will not be used.", modelDirectory);
						}
						else
						{
							profileData.ProxyModels[i].PushString(modelDirectory);
						}
					}
					kv.GoBack();
				}
			}
		}

		profileData.ProxyOverrideMaxSpeed = !!kv.GetNum("proxies_override_max_speed", profileData.ProxyOverrideMaxSpeed);
		if (profileData.ProxyOverrideMaxSpeed)
		{
			GetProfileDifficultyFloatValues(kv, "proxies_max_speed", profileData.ProxyMaxSpeed, profileData.ProxyMaxSpeed);
		}
	}

	UnloadBossProfile(profile);

	profileData.AnimationData.Load(kv, true);

	switch (profileData.Type)
	{
		case SF2BossType_Statue:
		{
			if (!LoadStatueBossProfile(kv, profile, loadFailReasonBuffer, loadFailReasonBufferLen, profileData))
			{
				return false;
			}
		}
		case SF2BossType_Chaser:
		{
			if (!LoadChaserBossProfile(kv, profile, loadFailReasonBuffer, loadFailReasonBufferLen, profileData))
			{
				return false;
			}
		}
	}
	// Add the section to our config.
	g_Config.Rewind();
	g_Config.JumpToKey(profile, true);
	g_Config.Import(kv);

	kv.GetString("constant_sound", profileData.EngineSound, sizeof(profileData.EngineSound), profileData.EngineSound);
	kv.GetString("engine_sound", profileData.EngineSound, sizeof(profileData.EngineSound), profileData.EngineSound);

	TryPrecacheBossProfileSoundPath(profileData.EngineSound, g_FileCheckConVar.BoolValue);

	int index = g_BossProfileList.FindString(profile);
	if (index == -1)
	{
		g_BossProfileList.PushString(profile);
	}

	if (kv.GetNum("enable_random_selection", true) != 0)
	{
		if (GetSelectableBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableBossProfileList().Erase(selectIndex);
		}
	}

	if (kv.GetNum("admin_only", false) != 0)
	{
		if (GetSelectableAdminBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableAdminBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableAdminBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableAdminBossProfileList().Erase(selectIndex);
		}
	}

	if (kv.GetNum("enable_random_selection_boxing", false) != 0)
	{
		if (GetSelectableBoxingBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableBoxingBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableBoxingBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableBoxingBossProfileList().Erase(selectIndex);
		}
	}

	if (kv.GetNum("enable_random_selection_renevant", false) != 0)
	{
		if (GetSelectableRenevantBossProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossProfileList().Erase(selectIndex);
		}
	}

	if (kv.GetNum("enable_random_selection_renevant_admin", false) != 0)
	{
		if (GetSelectableRenevantBossAdminProfileList().FindString(profile) == -1)
		{
			// Add to the selectable boss list if it isn't there already.
			GetSelectableRenevantBossAdminProfileList().PushString(profile);
		}
	}
	else
	{
		int selectIndex = GetSelectableRenevantBossAdminProfileList().FindString(profile);
		if (selectIndex != -1)
		{
			GetSelectableRenevantBossAdminProfileList().Erase(selectIndex);
		}
	}

	if (kv.JumpToKey("pve"))
	{
		profileData.IsPvEBoss = true;
		kv.GoBack();
	}
	else
	{
		profileData.IsPvEBoss = kv.GetNum("is_pve", profileData.IsPvEBoss) != 0;
	}

	if (profileData.IsPvEBoss)
	{
		profileData.Flags = profileData.Flags & ~SFF_PROXIES;
		if (kv.JumpToKey("pve"))
		{
			if (kv.JumpToKey("spawn_messages"))
			{
				profileData.PvESpawnMessagesArray = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
				char message[256], section[64];
				for (int i = 1;; i++)
				{
					FormatEx(section, sizeof(section), "%d", i);
					kv.GetString(section, message, sizeof(message));
					if (message[0] == '\0')
					{
						break;
					}

					profileData.PvESpawnMessagesArray.PushString(message);
				}
				kv.GoBack();
			}
			kv.GetString("spawn_message_prefix", profileData.PvESpawnMessagePrefix, sizeof(profileData.PvESpawnMessagePrefix), profileData.PvESpawnMessagePrefix);
			profileData.DisplayPvEHealth = kv.GetNum("health_bar", profileData.DisplayPvEHealth) != 0;
			char setProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			strcopy(setProfile, sizeof(setProfile), profile);
			if (kv.GetNum("selectable", 1) != 0)
			{
				RegisterPvESlenderBoss(setProfile);
			}
			profileData.PvETeleportEndTimer = kv.GetFloat("teleport_players_time", profileData.PvETeleportEndTimer);
			kv.GoBack();
		}
		else
		{
			if (kv.JumpToKey("pve_spawn_messages"))
			{
				profileData.PvESpawnMessagesArray = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
				char message[256], section[64];
				for (int i = 1;; i++)
				{
					FormatEx(section, sizeof(section), "%d", i);
					kv.GetString(section, message, sizeof(message));
					if (message[0] == '\0')
					{
						break;
					}

					profileData.PvESpawnMessagesArray.PushString(message);
				}
				kv.GoBack();
			}
			kv.GetString("pve_spawn_message_prefix", profileData.PvESpawnMessagePrefix, sizeof(profileData.PvESpawnMessagePrefix), profileData.PvESpawnMessagePrefix);
			profileData.DisplayPvEHealth = kv.GetNum("pve_health_bar", profileData.DisplayPvEHealth) != 0;
			char setProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			strcopy(setProfile, sizeof(setProfile), profile);
			if (kv.GetNum("pve_selectable", 1) != 0)
			{
				RegisterPvESlenderBoss(setProfile);
			}
		}

		index = GetSelectableBossProfileList().FindString(profile);
		if (index != -1)
		{
			GetSelectableBossProfileList().Erase(index);
		}
		index = GetSelectableAdminBossProfileList().FindString(profile);
		if (index != -1)
		{
			GetSelectableAdminBossProfileList().Erase(index);
		}
		index = GetSelectableBoxingBossProfileList().FindString(profile);
		if (index != -1)
		{
			GetSelectableBoxingBossProfileList().Erase(index);
		}
		index = GetSelectableRenevantBossProfileList().FindString(profile);
		if (index != -1)
		{
			GetSelectableRenevantBossProfileList().Erase(index);
		}
		index = GetSelectableRenevantBossAdminProfileList().FindString(profile);
		if (index != -1)
		{
			GetSelectableRenevantBossAdminProfileList().Erase(index);
		}
	}

	ArrayList validSections = new ArrayList(ByteCountToCells(128));

	if (kv.GotoFirstSubKey()) //Special thanks to Fire for modifying the code for download errors.
	{
		char s2[64], s3[64], s4[PLATFORM_MAX_PATH], s5[PLATFORM_MAX_PATH];

		do
		{
			kv.GetSectionName(s2, sizeof(s2));

			if (validSections.FindString(s2) != -1)
			{
				continue;
			}

			validSections.PushString(s2);

			if (StrContains(s2, "sound_") != -1)
			{
				bool doBack = false;
				if (kv.JumpToKey("paths"))
				{
					doBack = true;
				}
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0')
					{
						break;
					}

					TryPrecacheBossProfileSoundPath(s4, g_FileCheckConVar.BoolValue);

					// Here comes an if else mess, I'm very sorry
					if (strcmp(s2, "sound_jumpscare") == 0)
					{
						profileData.JumpscareSound = s4;
						break;
					}
					else if (strcmp(s2, "sound_static") == 0)
					{
						profileData.StaticSound = s4;
						break;
					}
					else if (strcmp(s2, "sound_static_loop_local") == 0)
					{
						profileData.StaticLocalSound = s4;
						break;
					}
					else if (strcmp(s2, "sound_static_shake_local") == 0)
					{
						profileData.StaticShakeLocal = s4;
						break;
					}
				}
				if (doBack)
				{
					kv.GoBack();
				}
				profileData.SortSoundSections(kv, s2, g_FileCheckConVar.BoolValue);
			}
			else if (strcmp(s2, "download") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0')
					{
						break;
					}

					if (g_FileCheckConVar.BoolValue)
					{
						if (FileExists(s4) || FileExists(s4, true))
						{
							AddFileToDownloadsTable(s4);
						}
						else
						{
							LogSF2Message("File %s does not exist, please fix this download or remove it from the array.", s4);
						}
					}
					else
					{
						AddFileToDownloadsTable(s4);
					}
				}
			}
			else if (strcmp(s2, "mod_precache") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0')
					{
						break;
					}

					if (!PrecacheModel(s4, true))
					{
						LogSF2Message("Model file %s failed to be precached, likely does not exist. This will crash the server if not fixed.", s4);
					}
				}
			}
			else if (strcmp(s2, "mat_download") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0')
					{
						break;
					}

					FormatEx(s5, sizeof(s5), "%s.vtf", s4);
					if (g_FileCheckConVar.BoolValue)
					{
						if (FileExists(s5) || FileExists(s5, true))
						{
							AddFileToDownloadsTable(s5);
						}
						else
						{
							LogSF2Message("Texture file %s does not exist, please fix this download or remove it from the array.", s5);
						}
					}
					else
					{
						AddFileToDownloadsTable(s5);
					}

					FormatEx(s5, sizeof(s5), "%s.vmt", s4);
					if (g_FileCheckConVar.BoolValue)
					{
						if (FileExists(s5) || FileExists(s5, true))
						{
							AddFileToDownloadsTable(s5);
						}
						else
						{
							LogSF2Message("Material file %s does not exist, please fix this download or remove it from the array.", s5);
						}
					}
					else
					{
						AddFileToDownloadsTable(s5);
					}
				}
			}
			else if (strcmp(s2, "mod_download") == 0)
			{
				for (int i = 1;; i++)
				{
					FormatEx(s3, sizeof(s3), "%d", i);
					kv.GetString(s3, s4, sizeof(s4));
					if (s4[0] == '\0')
					{
						break;
					}

					PrecacheModel2(s4, _, _, g_FileCheckConVar.BoolValue);
				}
			}
			else if (strcmp(s2, "overlay_player_death") == 0)
			{
				kv.GetString("1", s4, sizeof(s4));
				profileData.OverlayPlayerDeath = s4;
			}
			else if (strcmp(s2, "overlay_jumpscare") == 0)
			{
				kv.GetString("1", s4, sizeof(s4));
				profileData.OverlayJumpscare = s4;
			}
			if (StrContains(s2, "sound_footsteps_event_") != -1)
			{
				if (profileData.FootstepEventSounds == null)
				{
					profileData.FootstepEventSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
				}
				if (profileData.FootstepEventIndexes == null)
				{
					profileData.FootstepEventIndexes = new ArrayList();
				}

				SF2BossProfileSoundInfo soundInfo;
				soundInfo.Init();
				soundInfo.Load(kv, g_FileCheckConVar.BoolValue);
				soundInfo.PostLoad();
				if (soundInfo.Paths != null)
				{
					strcopy(s3, sizeof(s3), s2);
					ReplaceStringEx(s3, sizeof(s3), "sound_footsteps_event_", "");
					int eventNumber = StringToInt(s3);

					profileData.FootstepEventIndexes.Push(eventNumber);
					profileData.FootstepEventSounds.PushArray(soundInfo);
				}
			}
			else if (StrContains(s2, "sound_event_") != -1)
			{
				if (profileData.EventSounds == null)
				{
					profileData.EventSounds = new ArrayList(sizeof(SF2BossProfileSoundInfo));
				}
				if (profileData.EventIndexes == null)
				{
					profileData.EventIndexes = new ArrayList();
				}

				SF2BossProfileSoundInfo soundInfo;
				soundInfo.Init();
				soundInfo.Load(kv, g_FileCheckConVar.BoolValue);
				soundInfo.PostLoad();
				if (soundInfo.Paths != null)
				{
					strcopy(s3, sizeof(s3), s2);
					ReplaceStringEx(s3, sizeof(s3), "sound_event_", "");
					int eventNumber = StringToInt(s3);

					profileData.EventIndexes.Push(eventNumber);
					profileData.EventSounds.PushArray(soundInfo);
				}
			}
		}
		while (kv.GotoNextKey());

		kv.GoBack();
	}

	delete validSections;

	if (kv.JumpToKey("companions"))
	{
		profileData.CompanionsArray = new ArrayList(sizeof(SF2BossProfileCompanionsInfo));

		kv.GetString("type", profileData.CompanionSpawnType, sizeof(profileData.CompanionSpawnType));
		if (kv.GotoFirstSubKey())
		{
			do
			{
				SF2BossProfileCompanionsInfo companions;
				companions.Init();
				companions.Load(kv);
				profileData.CompanionsArray.PushArray(companions);
				if (lookIntoLoads)
				{
					char compProfile[SF2_MAX_PROFILE_NAME_LENGTH], otherProfile[SF2_MAX_PROFILE_NAME_LENGTH], dir[PLATFORM_MAX_PATH], file[PLATFORM_MAX_PATH];
					FileType fileType;
					DirectoryListing directory = OpenDirectory(originalDir);
					while (directory.GetNext(file, sizeof(file), fileType))
					{
						if (fileType == FileType_Directory)
						{
							continue;
						}

						FormatEx(dir, sizeof(dir), "%s/%s", originalDir, file);

						for (int i = 0; i < companions.Bosses.Length; i++)
						{
							companions.Bosses.GetString(i, compProfile, sizeof(compProfile));

							KeyValues otherKeys = new KeyValues("root");
							if (!FileToKeyValues(otherKeys, dir))
							{
								delete otherKeys;
								continue;
							}

							otherKeys.GetSectionName(otherProfile, sizeof(otherProfile));

							if (strcmp(compProfile, otherProfile) == 0)
							{
								if (!LoadBossProfile(otherKeys, otherProfile, loadFailReasonBuffer, loadFailReasonBufferLen))
								{
									LogSF2Message("(COMPANION) %s...FAILED (reason: %s)", dir, loadFailReasonBuffer);
								}
								else
								{
									LogSF2Message("(COMPANION) %s...", otherProfile);
								}
							}

							delete otherKeys;
						}
					}
				}
			}
			while (kv.GotoNextKey());
			kv.GoBack();
		}
		kv.GoBack();
	}

	if (kv.JumpToKey("attributes"))
	{
		profileData.AttributesInfo.Load(kv);
	}

	if (kv.JumpToKey("effects"))
	{
		profileData.EffectsArray = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));

		if (kv.GotoFirstSubKey())
		{
			do
			{
				SF2BossProfileBaseEffectInfo effects;
				effects.Init();
				effects.ModelScale = profileData.ModelScale;
				effects.Load(kv, g_FileCheckConVar.BoolValue);
				profileData.EffectsArray.PushArray(effects);
			}
			while (kv.GotoNextKey());
			kv.GoBack();
		}
		kv.GoBack();
	}

	if (kv.JumpToKey("spawn_effects"))
	{
		if (profileData.SpawnEffects == null)
		{
			profileData.SpawnEffects = new StringMap();
		}

		if (kv.GotoFirstSubKey())
		{
			do
			{
				char section[64];
				kv.GetSectionName(section, sizeof(section));
				if (kv.JumpToKey("effects"))
				{
					ArrayList list = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
					if (kv.GotoFirstSubKey())
					{
						do
						{
							SF2BossProfileBaseEffectInfo effects;
							effects.Init();
							effects.ModelScale = profileData.ModelScale;
							effects.Load(kv, g_FileCheckConVar.BoolValue);
							if (effects.Type == EffectType_Particle)
							{
								effects.LifeTime = 0.1;
							}
							list.PushArray(effects);
						}
						while (kv.GotoNextKey());
						kv.GoBack();
					}
					kv.GoBack();
					profileData.SpawnEffects.SetValue(section, list);
				}
			}
			while (kv.GotoNextKey());
			kv.GoBack();
		}
		kv.GoBack();
	}

	if (kv.JumpToKey("despawn_effects"))
	{
		if (profileData.DespawnEffects == null)
		{
			profileData.DespawnEffects = new StringMap();
		}
		profileData.HideDespawnEffectsOnDeath = kv.GetNum("hide_on_death", profileData.HideDespawnEffectsOnDeath) != 0;

		if (kv.GotoFirstSubKey())
		{
			do
			{
				char section[64];
				kv.GetSectionName(section, sizeof(section));
				if (kv.JumpToKey("effects"))
				{
					ArrayList list = new ArrayList(sizeof(SF2BossProfileBaseEffectInfo));
					if (kv.GotoFirstSubKey())
					{
						do
						{
							SF2BossProfileBaseEffectInfo effects;
							effects.Init();
							effects.ModelScale = profileData.ModelScale;
							effects.Load(kv, g_FileCheckConVar.BoolValue);
							if (effects.Type == EffectType_Particle)
							{
								effects.LifeTime = 0.1;
							}
							list.PushArray(effects);
						}
						while (kv.GotoNextKey());
						kv.GoBack();
					}
					kv.GoBack();
					profileData.DespawnEffects.SetValue(section, list);
				}
			}
			while (kv.GotoNextKey());
			kv.GoBack();
		}
		kv.GoBack();
	}

	profileData.PostLoad();

	g_BossProfileData.SetArray(profile, profileData, sizeof(profileData));

	Call_StartForward(g_OnBossProfileLoadedFwd);
	Call_PushString(profile);
	Call_PushCell(kv);
	Call_Finish();

	return true;
}

static SF2BossProfileData g_CachedProfileData;

int GetBossProfileSkin(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Skin[1];
}

int GetBossProfileSkinDifficulty(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Skin[difficulty];
}

bool GetBossProfileSkinDifficultyState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SkinDifficultiesOn;
}

int GetBossProfileSkinMax(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SkinMax;
}

int GetBossProfileBodyGroups(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Body[1];
}

int GetBossProfileBodyGroupsDifficulty(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Body[difficulty];
}

bool GetBossProfileBodyGroupsDifficultyState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BodyDifficultiesOn;
}

int GetBossProfileBodyGroupsMax(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BodyMax;
}

bool GetBossProfileRaidHitbox(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RaidHitbox;
}

bool GetBossProfileIgnoreNavPrefer(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IgnoreNavPrefer;
}

float GetBossProfileSoundMusicLoop(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SoundMusicLoop[difficulty];
}

int GetBossProfileMaxCopies(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CopiesInfo.MaxCopies[difficulty];
}

float GetBossProfileModelScale(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ModelScale;
}

float GetBossProfileStepSize(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StepSize;
}

float GetBossProfileNodeDistanceLookAhead(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.NodeDistanceLookAhead;
}

void GetBossProfileRenderColor(const char[] profile, int buffer[4])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.RenderColor;
}

int GetBossProfileRenderFX(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RenderFX;
}

int GetBossProfileRenderMode(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RenderMode;
}

int GetBossProfileWeaponString(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.WeaponString);
}

int GetBossProfileWeaponInt(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.WeaponInt;
}

void GetBossProfileHullMins(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.Mins;
}

void GetBossProfileHullMaxs(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.Maxs;
}

bool GetBossProfileDiscoModeState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DiscoMode;
}

float GetBossProfileDiscoRadiusMin(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DiscoDistanceMin;
}

float GetBossProfileDiscoRadiusMax(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DiscoDistanceMax;
}

void GetBossProfileDiscoPosition(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.DiscoPos;
}

bool GetBossProfileFestiveLightState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FestiveLights;
}

int GetBossProfileFestiveLightBrightness(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FestiveLightBrightness;
}

float GetBossProfileFestiveLightDistance(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FestiveLightDistance;
}

float GetBossProfileFestiveLightRadius(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FestiveLightRadius;
}

void GetBossProfileFestiveLightPosition(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.FestiveLightPos;
}

void GetBossProfileFestiveLightAngles(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.FestiveLightAng;
}

ArrayList GetBossProfileNames(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Names;
}

ArrayList GetBossProfileModels(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Models;
}

int GetBossProfileType(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Type;
}

int GetBossProfileFlags(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.Flags;
}

float GetBossProfileBlinkLookRate(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BlinkLookRate;
}

float GetBossProfileBlinkStaticRate(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.BlinkStaticRate;
}

bool GetBossProfileDeathCamState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathCam;
}

bool GetBossProfileDeathCamScareSound(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathCamScareSound;
}

bool GetBossProfilePublicDeathCamState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCam;
}

float GetBossProfilePublicDeathCamSpeed(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCamSpeed;
}

float GetBossProfilePublicDeathCamAcceleration(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCamAcceleration;
}

float GetBossProfilePublicDeathCamDeceleration(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCamDeceleration;
}

float GetBossProfilePublicDeathCamBackwardOffset(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCamBackwardOffset;
}

float GetBossProfilePublicDeathCamDownwardOffset(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.PublicDeathCamDownwardOffset;
}

bool GetBossProfileDeathCamOverlayState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathCamOverlay;
}

float GetBossProfileDeathCamOverlayStartTime(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathCamOverlayStartTime;
}

float GetBossProfileDeathCamTime(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathCamTime;
}

float GetBossProfileIdleLifetime(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.IdleLifeTime[difficulty];
}

float GetBossProfileStaticRadius(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticRadius[difficulty];
}

float GetBossProfileStaticRate(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticRate[difficulty];
}

float GetBossProfileStaticRateDecay(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticRateDecay[difficulty];
}

float GetBossProfileStaticGraceTime(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticGraceTime[difficulty];
}

float GetBossProfileStaticScareAmount(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticScareAmount;
}

int GetBossProfileStaticShakeLocalLevel(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticShakeLocalLevel;
}

float GetBossProfileStaticShakeLocalVolumeMin(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticShakeVolumeMin;
}

float GetBossProfileStaticShakeLocalVolumeMax(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.StaticShakeVolumeMax;
}

bool GetBossProfileTeleportAllowed(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportAllowed[difficulty];
}

float GetBossProfileTeleportTimeMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportTimeMin[difficulty];
}

float GetBossProfileTeleportTimeMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportTimeMax[difficulty];
}

float GetBossProfileTeleportTargetRestPeriod(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportRestPeriod[difficulty];
}

float GetBossProfileTeleportTargetStressMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportStressMin[difficulty];
}

float GetBossProfileTeleportTargetStressMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportStressMax[difficulty];
}

float GetBossProfileTeleportTargetPersistencyPeriod(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportPersistencyPeriod[difficulty];
}

float GetBossProfileTeleportRangeMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportRangeMin[difficulty];
}

float GetBossProfileTeleportRangeMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportRangeMax[difficulty];
}

bool GetBossProfileTeleportIgnoreChases(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportIgnoreChases;
}

bool GetBossProfileTeleportIgnoreVis(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportIgnoreVis;
}

float GetBossProfileTeleportCopyDistance(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CopiesInfo.TeleportDistanceSpacing[difficulty];
}

float GetBossProfileJumpscareDistance(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JumpscareDistance[difficulty];
}

float GetBossProfileJumpscareDuration(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JumpscareDuration[difficulty];
}

float GetBossProfileJumpscareCooldown(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JumpscareCooldown[difficulty];
}

int GetBossProfileProxyClasses(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ProxyClasses);
}

float GetBossProfileProxyDamageVsEnemy(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDamageVsEnemy[difficulty];
}

float GetBossProfileProxyDamageVsBackstab(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDamageVsBackstab[difficulty];
}

float GetBossProfileProxyDamageVsSelf(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDamageVsSelf[difficulty];
}

int GetBossProfileProxyControlGainHitEnemy(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyControlGainHitEnemy[difficulty];
}

int GetBossProfileProxyControlGainHitByEnemy(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyControlGainHitByEnemy[difficulty];
}

float GetBossProfileProxyControlDrainRate(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyControlDrainRate[difficulty];
}

float GetBossProfileProxySpawnChanceMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnChanceMin[difficulty];
}

float GetBossProfileProxySpawnChanceMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnChaceMax[difficulty];
}

float GetBossProfileProxySpawnChanceThreshold(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnChanceThreshold[difficulty];
}

int GetBossProfileProxySpawnNumberMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnNumMin[difficulty];
}

int GetBossProfileProxySpawnNumberMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnNumMax[difficulty];
}

float GetBossProfileProxySpawnCooldownMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnCooldownMin[difficulty];
}

float GetBossProfileProxySpawnCooldownMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnCooldownMax[difficulty];
}

float GetBossProfileProxyTeleportRangeMin(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportRangeMin[difficulty];
}

float GetBossProfileProxyTeleportRangeMax(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportRangeMax[difficulty];
}

int GetBossProfileMaxProxies(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.MaxProxies[difficulty];
}

bool GetBossProfileFakeCopies(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CopiesInfo.Fakes[difficulty];
}

bool GetBossProfileDrainCreditState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DrainCredits;
}

int GetBossProfileDrainCreditAmount(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DrainCreditAmount[difficulty];
}

bool GetBossProfileProxySpawnEffectState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnEffect;
}

int GetBossProfileProxySpawnEffectName(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ProxySpawnEffectName);
}

float GetBossProfileProxySpawnEffectZOffset(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxySpawnEffectZOffset;
}

ArrayList GetBossProfileProxyDeathAnimations(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDeathAnimations;
}

int GetBossProfileProxyDeathAnimFrames(const char[] profile, int index)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDeathAnimFrames[index];
}

bool GetBossProfileProxyZombiesState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyZombies;
}

bool GetBossProfileProxyDifficultyModelsState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyDifficultyModels;
}

ArrayList GetBossProfileProxyModels(const char[] profile, int index, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	switch (difficulty)
	{
		case Difficulty_Hard:
		{
			return g_CachedProfileData.ProxyModelsHard[index];
		}
		case Difficulty_Insane:
		{
			return g_CachedProfileData.ProxyModelsInsane[index];
		}
		case Difficulty_Nightmare:
		{
			return g_CachedProfileData.ProxyModelsNightmare[index];
		}
		case Difficulty_Apollyon:
		{
			return g_CachedProfileData.ProxyModelsApollyon[index];
		}
	}
	return g_CachedProfileData.ProxyModels[index];
}

bool GetBossProfileProxyOverrideMaxSpeed(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyOverrideMaxSpeed;
}

float GetBossProfileProxyMaxSpeed(const char[] profile, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyMaxSpeed[difficulty];
}

void GetBossProfileEyePositionOffset(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.EyePosOffset;
}

void GetBossProfileEyeAngleOffset(const char[] profile, float buffer[3])
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	buffer = g_CachedProfileData.EyeAngOffset;
}

float GetBossProfileScareRadius(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareRadius;
}

float GetBossProfileScareCooldown(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareCooldown;
}

bool GetBossProfileSpeedBoostOnScare(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.SpeedBoostOnScare;
}

bool GetBossProfileJumpscareOnScare(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JumpscareOnScare;
}

bool GetBossProfileJumpscareNoSight(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.JumpscareNoSight;
}

float GetBossProfileScareSpeedBoostDuration(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareSpeedBoostDuration;
}

bool GetBossProfileScareReactionState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareReaction;
}

int GetBossProfileScareReactionType(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareReactionType;
}

int GetBossProfileScareReactionCustom(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.ScareReactionCustom);
}

bool GetBossProfileScareReplenishState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareReplenishSprint;
}

float GetBossProfileScareReplenishAmount(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ScareReplenishSprintAmount;
}

int GetBossProfileTeleportType(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.TeleportType;
}

bool GetBossProfileCustomOutlinesState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CustomOutlines;
}

bool GetBossProfileRainbowOutlineState(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.RainbowOutline;
}

bool GetBossProfileProxyWeapons(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyWeapons;
}

ArrayList GetBossProfileProxyWeaponClassNames(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyWeaponClassNames;
}

ArrayList GetBossProfileProxyWeaponStats(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyWeaponStats;
}

int GetBossProfileProxyWeaponIndexes(const char[] profile, int index)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyWeaponIndexes[index];
}

int GetBossProfileProxyWeaponSlots(const char[] profile, int index)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyWeaponSlots[index];
}

bool GetBossProfileProxyAllowNormalVoices(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.ProxyAllowVoices;
}

int GetBossProfileChatDeathMessageDifficultyIndexes(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathMessageDifficultyIndexes;
}

ArrayList GetBossProfileChatDeathMessages(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.DeathMessagesArray;
}

int GetBossProfileChatDeathMessagePrefix(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.DeathMessagePrefix);
}

void GetBossProfileMusicSounds(const char[] profile, SF2BossProfileSoundInfo params, int difficulty)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			params = g_CachedProfileData.MusicSoundsNormal;
		}
		case Difficulty_Hard:
		{
			params = g_CachedProfileData.MusicSoundsHard;
		}
		case Difficulty_Insane:
		{
			params = g_CachedProfileData.MusicSoundsInsane;
		}
		case Difficulty_Nightmare:
		{
			params = g_CachedProfileData.MusicSoundsNightmare;
		}
		case Difficulty_Apollyon:
		{
			params = g_CachedProfileData.MusicSoundsApollyon;
		}
	}
}

void GetBossProfileScareSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ScareSounds;
}

void GetBossProfileSightSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.SightSounds;
}

void GetBossProfileIntroSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.IntroSounds;
}

void GetBossProfileSpawnLocalSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.SpawnLocalSounds;
}

void GetBossProfileProxySpawnSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ProxySpawnSounds;
}

void GetBossProfileProxyIdleSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ProxyIdleSounds;
}

void GetBossProfileProxyHurtSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ProxyHurtSounds;
}

void GetBossProfileProxyDeathSounds(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.ProxyDeathSounds;
}

void GetBossProfileOutroMusics(const char[] profile, SF2BossProfileSoundInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.OutroMusics;
}

ArrayList GetBossProfileFootstepEventSounds(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FootstepEventSounds;
}

ArrayList GetBossProfileFootstepEventIndexes(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.FootstepEventIndexes;
}

ArrayList GetBossProfileEventSounds(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EventSounds;
}

ArrayList GetBossProfileEventIndexes(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.EventIndexes;
}

void GetBossProfileAttributesInfo(const char[] profile, SF2BossProfileAttributesInfo params)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	params = g_CachedProfileData.AttributesInfo;
}

int GetBossProfileJumpscareSound(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.JumpscareSound);
}

int GetBossProfileStaticSound(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.StaticSound);
}

int GetBossProfileStaticLocalSound(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.StaticLocalSound);
}

int GetBossProfileStaticShakeSound(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.StaticShakeLocal);
}

int GetBossProfileOverlayJumpscare(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.OverlayJumpscare);
}

int GetBossProfileOverlayPlayerDeath(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.OverlayPlayerDeath);
}

ArrayList GetBossProfileCompanions(const char[] profile)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return g_CachedProfileData.CompanionsArray;
}

int GetBossProfileCompanionsSpawnType(const char[] profile, char[] buffer, int bufferlen)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	return strcopy(buffer, bufferlen, g_CachedProfileData.CompanionSpawnType);
}

void GetBossProfileAnimationsData(const char[] profile, SF2BossProfileMasterAnimationsData data)
{
	g_BossProfileData.GetArray(profile, g_CachedProfileData, sizeof(g_CachedProfileData));
	data = g_CachedProfileData.AnimationData;
}