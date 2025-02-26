#if defined _sf2_profiles_precache_included
 #endinput
#endif
#define _sf2_profiles_precache_included

#pragma semicolon 1
#pragma newdecls required

methodmap BaseBossProfile < ProfileObject
{
	public ProfileObject GetBlacklistedMaps()
	{
		return this.GetSection("map_blacklist");
	}

	property int Type
	{
		public get()
		{
			return this.GetInt("type", SF2BossType_Chaser);
		}
	}

	property bool IgnoreNavPrefer
	{
		public get()
		{
			return true;
		}
	}

	property int Flags
	{
		public get()
		{
			int bossFlags = 0;
			if (this.GetBool("static_on_look", false))
			{
				bossFlags |= SFF_STATICONLOOK;
			}
			if (this.GetBool("static_on_radius", false))
			{
				bossFlags |= SFF_STATICONRADIUS;
			}
			if (this.GetBool("proxies", false))
			{
				bossFlags |= SFF_PROXIES;
			}
			if (this.GetBool("jumpscare", false))
			{
				bossFlags |= SFF_HASJUMPSCARE;
			}
			if (this.GetBool("sound_static_loop_local_enabled", false))
			{
				bossFlags |= SFF_HASSTATICLOOPLOCALSOUND;
			}
			if (this.GetBool("view_shake", true))
			{
				bossFlags |= SFF_HASVIEWSHAKE;
			}
			if (this.GetBool("wander_move", true))
			{
				bossFlags |= SFF_WANDERMOVE;
			}
			if (this.GetBool("attack_props", false))
			{
				bossFlags |= SFF_ATTACKPROPS;
			}
			if (this.GetBool("attack_weaponsenable", false))
			{
				bossFlags |= SFF_WEAPONKILLS;
			}
			if (this.GetBool("kill_weaponsenable", false))
			{
				bossFlags |= SFF_WEAPONKILLSONRADIUS;
			}
			return bossFlags;
		}
	}

	public void GetModel(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("model", difficulty, buffer, bufferSize);
		ReplaceString(buffer, bufferSize, "\\", "/", false);
	}

	public void GetName(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("name", difficulty, buffer, bufferSize);
	}

	property float ModelScale
	{
		public get()
		{
			return this.GetFloat("model_scale", 1.0);
		}
	}

	public int GetSkin(int difficulty)
	{
		return this.GetDifficultyInt("skin", difficulty);
	}

	property int SkinMax
	{
		public get()
		{
			return this.GetInt("skin_max");
		}
	}

	public int GetBodyGroup(int difficulty)
	{
		return this.GetDifficultyInt("body", difficulty);
	}

	property int BodyMax
	{
		public get()
		{
			return this.GetInt("body_max");
		}
	}

	property bool BodyDifficultiesOn
	{
		public get()
		{
			return this.GetBool("body_difficulty");
		}
	}

	property bool RaidHitbox
	{
		public get()
		{
			return this.GetBool("use_raid_hitbox");
		}
	}

	public float GetInstantKillRadius(int difficulty)
	{
		return this.GetDifficultyFloat("kill_radius", difficulty, -1.0);
	}

	public float GetInstantKillCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("kill_cooldown", difficulty, 0.0);
	}

	property int TeleportType
	{
		public get()
		{
			return this.GetInt("teleport_type", 2);
		}
	}

	public bool IsTeleportAllowed(int difficulty)
	{
		return this.GetDifficultyBool("teleport_allowed", difficulty, true);
	}

	public float GetMinTeleportRange(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_range_min", difficulty, 450.0);
	}

	public float GetMaxTeleportRange(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_range_max", difficulty, 1500.0);
	}

	public float GetMinTeleportTime(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_time_min", difficulty, 5.0);
	}

	public float GetMaxTeleportTime(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_time_max", difficulty, 9.0);
	}

	public float GetTeleportRestPeriod(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_target_rest_period", difficulty, 15.0);
	}

	public float GetMinTeleportStress(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_target_stress_min", difficulty, 0.2);
	}

	public float GetMaxTeleportStress(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_target_stress_max", difficulty, 1.0);
	}

	public float GetTeleportPersistencyPeriod(int difficulty)
	{
		return this.GetDifficultyFloat("teleport_target_persistency_period", difficulty, 13.0);
	}

	property int TeleportIgnoreChases
	{
		public get()
		{
			return this.GetInt("teleport_target_ignore_chases", false);
		}
	}

	property int TeleportIgnoreVis
	{
		public get()
		{
			return this.GetInt("teleport_target_ignore_visibility", false);
		}
	}

	property float FOV
	{
		public get()
		{
			return this.GetFloat("fov", 90.0);
		}
	}

	property float TurnRate
	{
		public get()
		{
			float val = 250.0;
			val = this.GetFloat("maxyawrate", val);
			val = this.GetFloat("turnrate", val);
			return val;
		}
	}

	property float ScareRadius
	{
		public get()
		{
			return this.GetFloat("scare_radius", 0.0);
		}
	}

	property float ScareCooldown
	{
		public get()
		{
			return this.GetFloat("scare_cooldown", 0.0);
		}
	}

	property float ScareReplenishSprintAmount
	{
		public get()
		{
			return this.GetFloat("scare_player_replenish_sprint_amount", 0.0);
		}
	}

	property float ScareSpeedBoostDuration
	{
		public get()
		{
			return this.GetFloat("scare_player_speed_boost_duration", 0.0);
		}
	}

	property int ScareReactionType
	{
		public get()
		{
			return this.GetInt("scare_player_reaction_type", 0);
		}
	}

	public void GetCustomScareReaction(char[] buffer, int bufferSize)
	{
		this.GetString("scare_player_reaction_response_custom", buffer, bufferSize);
	}

	public float GetJumpscareDistance(int difficulty)
	{
		return this.GetDifficultyFloat("jumpscare_distance", difficulty, 0.0);
	}

	public float GetJumpscareDuration(int difficulty)
	{
		return this.GetDifficultyFloat("jumpscare_duration", difficulty, 0.0);
	}

	public float GetJumpscareCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("jumpscare_cooldown", difficulty, 0.0);
	}

	property bool JumpscareOnScare
	{
		public get()
		{
			return this.GetBool("jumpscare_on_scare", false);
		}
	}

	property bool JumpscareNoSight
	{
		public get()
		{
			return this.GetBool("jumpscare_no_sight", false);
		}
	}

	public ProfileSound GetJumpscareSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_jumpscare"));
	}

	public KeyMap_Array GetJumpscareOverlays()
	{
		return this.GetArray("overlay_jumpscare");
	}

	public KeyMap_Array GetRedCameraOverlays()
	{
		return this.GetArray("overlay_red_camera");
	}

	public void GetActiveRedCameraOverlay(char[] buffer, int bufferSize)
	{
		this.GetString("__active_red_camera_overlay", buffer, bufferSize);
	}

	public void SetActiveRedCameraOverlay(char[] value)
	{
		this.SetString("__active_red_camera_overlay", value);
	}

	public void GetHullMins(float vec[3])
	{
		this.GetVector("mins", vec, HULL_HUMAN_MINS);
	}

	public void GetHullMaxs(float vec[3])
	{
		this.GetVector("maxs", vec, HULL_HUMAN_MAXS);
	}

	property float StepSize
	{
		public get()
		{
			return this.GetFloat("stepsize", 18.0);
		}
	}

	property float NodeDistanceLookAhead
	{
		public get()
		{
			return this.GetFloat("search_node_dist_lookahead", 128.0);
		}
	}

	public void GetRenderColor(int difficulty, int buffer[4])
	{
		this.GetDifficultyColor("effect_rendercolor", difficulty, buffer);
	}

	public RenderFx GetRenderFx(int difficulty)
	{
		return view_as<RenderFx>(this.GetDifficultyInt("effect_renderfx", difficulty, view_as<int>(RENDERFX_NONE)));
	}

	public RenderMode GetRenderMode(int difficulty)
	{
		return view_as<RenderMode>(this.GetDifficultyInt("effect_rendermode", difficulty, view_as<int>(RENDER_NORMAL)));
	}

	public BossProfileEyeData GetEyes()
	{
		ProfileObject obj = this.GetSection("eyes");
		if (obj == null)
		{
			obj = this;
		}
		return view_as<BossProfileEyeData>(obj);
	}

	public bool HasStaticOnRadius(int difficulty)
	{
		return this.GetDifficultyBool("static_on_radius", difficulty);
	}

	public float GetStaticRadius(int difficulty)
	{
		return this.GetDifficultyFloat("static_radius", difficulty, 150.0);
	}

	public float GetStaticRate(int difficulty)
	{
		static const float defaultValue[Difficulty_Max] = { 0.8, 0.8, 0.75, 0.7, 0.5, 0.4 };

		return this.GetDifficultyFloat("static_rate", difficulty, defaultValue[difficulty]);
	}

	public float GetStaticRateDecay(int difficulty)
	{
		static const float defaultValue[Difficulty_Max] = { 0.2, 0.2, 0.25, 0.3, 0.4, 0.55 };

		return this.GetDifficultyFloat("static_rate_decay", difficulty, defaultValue[difficulty]);
	}

	public bool HasStaticOnLook(int difficulty)
	{
		return this.GetDifficultyBool("static_on_look", difficulty);
	}

	public float GetStaticOnLookGraceTime(int difficulty)
	{
		return this.GetDifficultyFloat("static_on_look_gracetime", difficulty, 1.0);
	}

	public float GetScareStaticAmount(int difficulty)
	{
		return this.GetDifficultyFloat("scare_static_amount", difficulty);
	}

	public float GetRunSpeed(int difficulty)
	{
		return this.GetDifficultyFloat("speed", difficulty, 300.0);
	}

	public float GetForwardFriction(int difficulty)
	{
		return this.GetDifficultyFloat("friction_forward", difficulty, 0.0);
	}

	public float GetSidewaysFriction(int difficulty)
	{
		return this.GetDifficultyFloat("friction_sideways", difficulty, 3.0);
	}

	public float GetAcceleration(int difficulty)
	{
		float def;

		switch (this.Type)
		{
			case SF2BossType_Statue:
			{
				def = 10000.0;
			}
			default:
			{
				def = 4000.0;
			}
		}

		return this.GetDifficultyFloat("acceleration", difficulty, def);
	}

	public float GetSearchRange(int difficulty)
	{
		float value = 1024.0;
		value = this.GetDifficultyFloat("search_view_distance", difficulty, value);
		value = this.GetDifficultyFloat("search_range", difficulty, value);
		return value;
	}

	public ProfileMasterAnimations GetAnimations()
	{
		return view_as<ProfileMasterAnimations>(this.GetSection("animations"));
	}

	public BossProfileCopies GetCopies()
	{
		ProfileObject obj = this.GetSection("copies");
		if (obj == null)
		{
			obj = this;
		}
		return view_as<BossProfileCopies>(obj);
	}

	public BossProfileCompanions GetCompanions()
	{
		return view_as<BossProfileCompanions>(this.GetSection("companions"));
	}

	public BossProfileProxyData GetProxies()
	{
		return view_as<BossProfileProxyData>(this.GetSection("proxies"));
	}

	public BossProfileDeathCamData GetDeathCamData()
	{
		return view_as<BossProfileDeathCamData>(this.GetSection("death_cam"));
	}

	public BossProfilePvEData GetPvEData()
	{
		return view_as<BossProfilePvEData>(this.GetSection("pve"));
	}

	property bool IsPvEBoss
	{
		public get()
		{
			return this.GetPvEData().IsEnabled;
		}
	}

	public BossProfileOutlineData GetOutlineData()
	{
		return view_as<BossProfileOutlineData>(this.GetSection("outline"));
	}

	public void GetStaticSound(char[] buffer, int bufferSize)
	{
		ProfileObject obj = this.GetSection("sound_static");
		if (obj != null)
		{
			obj.GetString("1", buffer, bufferSize);
		}
	}

	public void GetStaticLocalLoopSound(char[] buffer, int bufferSize)
	{
		ProfileObject obj = this.GetSection("sound_static_loop_local");
		if (obj != null)
		{
			obj.GetString("1", buffer, bufferSize);
		}
	}

	public void GetStaticShakeLocalSound(char[] buffer, int bufferSize)
	{
		ProfileObject obj = this.GetSection("sound_static_shake_local");
		if (obj != null)
		{
			obj.GetString("1", buffer, bufferSize);
		}
	}

	property float StaticShakeMinVolume
	{
		public get()
		{
			return this.GetFloat("sound_static_shake_local_volume_min", 0.0);
		}
	}

	property float StaticShakeMaxVolume
	{
		public get()
		{
			return this.GetFloat("sound_static_shake_local_volume_max", 0.0);
		}
	}

	property int StaticShakeLocalLevel
	{
		public get()
		{
			return this.GetInt("sound_static_loop_local_level", SNDLEVEL_NORMAL);
		}
	}

	property float BlinkLookRate
	{
		public get()
		{
			return this.GetFloat("blink_look_rate_multiply", 1.0);
		}
	}

	property float BlinkStaticRate
	{
		public get()
		{
			return this.GetFloat("blink_static_rate_multiply", 1.0);
		}
	}

	public ProfileSound GetIntroSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_spawn_all"));
	}

	public ProfileSound GetLocalSpawnSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_spawn_local"));
	}

	public ProfileSound GetScareSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_scare_player"));
	}

	public ProfileSound GetClientDeathCamSounds()
	{
		ProfileObject obj = this.GetSection("sound_player_deathcam");
		if (obj == null)
		{
			obj = this.GetSection("sound_player_death");
		}
		return view_as<ProfileSound>(obj);
	}

	public ProfileSound GetGlobalDeathCamSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_player_deathcam_all"));
	}

	public ProfileSound GetLocalDeathCamSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_player_deathcam_local"));
	}

	public ProfileSound GetOverlayDeathCamSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_player_deathcam_overlay"));
	}

	public ProfileSound GetSightSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_sight"));
	}

	public void GetWeaponString(char[] buffer, int bufferSize)
	{
		this.GetString("kill_weapontype", buffer, bufferSize);
	}

	property int WeaponInt
	{
		public get()
		{
			return this.GetInt("kill_weapontypeint", 0);
		}
	}

	property bool AshRagdoll
	{
		public get()
		{
			return this.GetBool("disintegrate_ragdoll_on_kill", false);
		}
	}

	property bool CloakRagdoll
	{
		public get()
		{
			return this.GetBool("cloak_ragdoll_on_kill", false);
		}
	}

	property bool DecapRagdoll
	{
		public get()
		{
			return this.GetBool("decap_ragdoll_on_kill", false);
		}
	}

	property bool DeleteRagdoll
	{
		public get()
		{
			return this.GetBool("delete_ragdoll_on_kill", false);
		}
	}

	property bool DissolveRagdoll
	{
		public get()
		{
			return this.GetBool("dissolve_ragdoll_on_kill", false);
		}
	}

	property int DissolveKillType
	{
		public get()
		{
			return this.GetInt("dissolve_ragdoll_type", 0);
		}
	}

	property bool ElectrocuteRagdoll
	{
		public get()
		{
			return this.GetBool("electrocute_ragdoll_on_kill", false);
		}
	}

	property bool GoldRagdoll
	{
		public get()
		{
			return this.GetBool("gold_ragdoll_on_kill", false);
		}
	}

	property bool IceRagdoll
	{
		public get()
		{
			return this.GetBool("ice_ragdoll_on_kill", false);
		}
	}

	property bool PlasmaRagdoll
	{
		public get()
		{
			return this.GetBool("plasma_ragdoll_on_kill", false);
		}
	}

	property bool PushRagdoll
	{
		public get()
		{
			return this.GetBool("push_ragdoll_on_kill", false);
		}
	}

	public void GetPushRagdollForce(float buffer[3])
	{
		this.GetVector("push_ragdoll_force", buffer);
	}

	property bool ResizeRagdoll
	{
		public get()
		{
			return this.GetBool("resize_ragdoll_on_kill", false);
		}
	}

	property float ResizeRagdollHead
	{
		public get()
		{
			return this.GetFloat("resize_ragdoll_head", 1.0);
		}
	}

	property float ResizeRagdollTorso
	{
		public get()
		{
			return this.GetFloat("resize_ragdoll_torso", 1.0);
		}
	}

	property float ResizeRagdollHands
	{
		public get()
		{
			return this.GetFloat("resize_ragdoll_hands", 1.0);
		}
	}

	property bool BurnRagdoll
	{
		public get()
		{
			return this.GetBool("burn_ragdoll_on_kill", false);
		}
	}

	property bool GibRagdoll
	{
		public get()
		{
			return this.GetBool("gib_ragdoll_on_kill", false);
		}
	}

	property bool DecapOrGibRagdoll
	{
		public get()
		{
			return this.GetBool("decap_or_gib_ragdoll_on_kill", false);
		}
	}

	property bool MultiEffectRagdoll
	{
		public get()
		{
			return this.GetBool("multieffect_ragdoll_on_kill", false);
		}
	}

	property bool CustomDeathFlag
	{
		public get()
		{
			return this.GetBool("attack_custom_deathflag_enabled", false);
		}
	}

	property int CustomDeathFlagType
	{
		public get()
		{
			return this.GetInt("attack_custom_deathflag", 0);
		}
	}

	public void GetConstantSound(char[] buffer, int bufferSize)
	{
		this.GetString("constant_sound", buffer, bufferSize, buffer);
		this.GetString("engine_sound", buffer, bufferSize, buffer);
	}

	property int ConstantSoundLevel
	{
		public get()
		{
			int def = 83;
			def = this.GetInt("constant_sound_level", def);
			def = this.GetInt("engine_sound_level", def);
			return def;
		}
	}

	property float ConstantSoundVolume
	{
		public get()
		{
			float def = 0.8;
			def = this.GetFloat("constant_sound_volume", def);
			def = this.GetFloat("engine_sound_volume", def);
			return def;
		}
	}

	public float GetIdleLifeTime(int difficulty)
	{
		return this.GetDifficultyFloat("idle_lifetime", difficulty, 10.0);
	}

	public BossProfileSlaughterRunData GetSlaughterRunData()
	{
		return view_as<BossProfileSlaughterRunData>(this.GetSection("slaughter_run"));
	}

	public KeyMap_Array GetSpawnEffects()
	{
		return this.GetArray("spawn_effects");
	}

	public ProfileInputsList GetSpawnInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("spawn"));
		}
		return null;
	}

	public KeyMap_Array GetDespawnEffects()
	{
		return this.GetArray("despawn_effects");
	}

	public ProfileInputsList GetDespawnInputs()
	{
		ProfileObject obj = this.GetSection("inputs");
		if (obj != null)
		{
			return view_as<ProfileInputsList>(obj.GetSection("spawn"));
		}
		return null;
	}

	public ProfileOutputsList GetOutputs()
	{
		return view_as<ProfileOutputsList>(this.GetSection("outputs"));
	}

	property bool HideDespawnEffectsOnDeath
	{
		public get()
		{
			return this.GetBool("hide_on_death", false);
		}
	}

	property bool DiscoMode
	{
		public get()
		{
			return this.GetBool("disco_mode", false);
		}
	}

	property float DiscoDistanceMin
	{
		public get()
		{
			return this.GetFloat("disco_mode_rng_distance_min", 420.0);
		}
	}

	property float DiscoDistanceMax
	{
		public get()
		{
			return this.GetFloat("disco_mode_rng_distance_max", 750.0);
		}
	}

	public void GetDiscoPos(float buffer[3])
	{
		this.GetVector("disco_mode_pos", buffer);
	}

	property bool FestiveLights
	{
		public get()
		{
			return this.GetBool("festive_lights", false);
		}
	}

	property int FestiveLightBrightness
	{
		public get()
		{
			return this.GetInt("festive_light_brightness", 0);
		}
	}

	property float FestiveLightDistance
	{
		public get()
		{
			return this.GetFloat("festive_light_distance", 0.0);
		}
	}

	property float FestiveLightRadius
	{
		public get()
		{
			return this.GetFloat("festive_light_radius", 0.0);
		}
	}

	public void GetFestiveLightPos(float buffer[3])
	{
		this.GetVector("festive_lights_pos", buffer);
	}

	public void GetFestiveLightAng(float buffer[3])
	{
		this.GetVector("festive_lights_ang", buffer);
	}

	property float TickRate
	{
		public get()
		{
			return this.GetFloat("tick_rate", 0.0);
		}
	}

	public ProfileMusic GetGlobalMusic(int difficulty)
	{
		return view_as<ProfileMusic>(this.GetDifficultySection("sound_music", difficulty));
	}

	public ProfileGlobalTracks GetGlobalTracks()
	{
		ProfileObject obj = this.GetSection("music");
		obj = obj != null ? obj.GetSection("global") : null;
		if (obj != null)
		{
			return view_as<ProfileGlobalTracks>(obj);
		}

		return null;
	}

	public ProfileSound GetOutroWinSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_outro_win"));
	}

	public ProfileSound GetOutroLoseSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_outro_lose"));
	}

	public BossProfileAttributes GetAttributes()
	{
		return view_as<BossProfileAttributes>(this.GetSection("attributes"));
	}

	public BossProfileDescription GetDescription()
	{
		return view_as<BossProfileDescription>(this.GetSection("description"));
	}

	public ProfileSound GetFootstepEventSounds(int index)
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "sound_footsteps_event_%i", index);
		return view_as<ProfileSound>(this.GetSection(formatter));
	}

	public ProfileSound GetEventSounds(int index)
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "sound_event_%i", index);
		return view_as<ProfileSound>(this.GetSection(formatter));
	}

	public BossProfileEventData GetEvents(int index)
	{
		char formatter[64];
		FormatEx(formatter, sizeof(formatter), "%d", index);
		ProfileObject obj = this.GetSection("events");
		if (obj != null)
		{
			return view_as<BossProfileEventData>(obj.GetSection(formatter));
		}
		return null;
	}

	public BossKillSoundsData GetLocalKillSounds()
	{
		return view_as<BossKillSoundsData>(this.GetSection("local_kill_sounds"));
	}

	public BossKillSoundsData GetGlobalKillSounds()
	{
		return view_as<BossKillSoundsData>(this.GetSection("global_kill_sounds"));
	}

	public BossKillSoundsData GetClientKillSounds()
	{
		return view_as<BossKillSoundsData>(this.GetSection("client_kill_sounds"));
	}

	public ProfileObject GetMapSelectionBlacklist()
	{
		ProfileObject obj = this.GetSection("selection_blacklist");
		obj = obj != null ? obj.GetSection("maps") : null;
		return obj;
	}

	public ProfileObject GetModeSelectionBlacklist()
	{
		ProfileObject obj = this.GetSection("selection_blacklist");
		obj = obj != null ? obj.GetSection("modes") : null;
		return obj;
	}

	public void Precache()
	{
		char path[PLATFORM_MAX_PATH], key[512], value[2048];
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.GetModel(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
			}
		}

		path[0] = '\0';
		this.GetConstantSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		// ========================
		// LEGACY KEY CONVERSION
		// ========================
		ProfileObject newObj = null, temp = null, temp2 = null, temp3 = null, temp4 = null;
		ArrayList keys = new ArrayList(ByteCountToCells(256));
		if (this.GetAnimations() != null)
		{
			for (int i = 0; i < this.GetAnimations().SectionLength; i++)
			{
				char animType[64], name[64], formatter[256];
				int size = 0;
				this.GetAnimations().GetSectionNameFromIndex(i, animType, sizeof(animType));
				temp = this.GetAnimations().GetSection(animType);
				for (int i2 = 0; i2 < temp.SectionLength; i2++)
				{
					temp.GetSectionNameFromIndex(i2, name, sizeof(name));
					temp2 = temp.GetSection(name);
					for (int i3 = 0; i3 < temp2.KeyLength; i3++)
					{
						temp2.GetKeyNameFromIndex(i3, name, sizeof(name));
						FormatEx(formatter, sizeof(formatter), "animation_%s", animType);
						if (strcmp(name, formatter) == 0)
						{
							size = temp2.GetKeyValueLength(name);

						}
					}
				}
			}
		}
		else
		{
			keys.PushString("animation_idle");
			keys.PushString("animation_walk");
			keys.PushString("animation_walkalert");
			keys.PushString("animation_attack");
			keys.PushString("animation_shoot");
			keys.PushString("animation_run");
			keys.PushString("animation_chaseinitial");
			keys.PushString("animation_rage");
			keys.PushString("animation_stun");
			keys.PushString("animation_death");
			keys.PushString("animation_spawn");
			keys.PushString("animation_fleestart");
			keys.PushString("animation_heal");
			keys.PushString("animation_deathcam");
			keys.PushString("animation_crawlwalk");
			keys.PushString("animation_crawlrun");
			if (this.ContainsAnyDifficultyKey(keys))
			{
				newObj = this.InsertNewSection("animations");
				this.InsertAnimationSection("idle", newObj);
				this.InsertAnimationSection("walk", newObj);
				this.InsertAnimationSection("walkalert", newObj);
				this.InsertAnimationSection("attack", newObj);
				this.InsertAnimationSection("shoot", newObj);
				this.InsertAnimationSection("run", newObj);
				this.InsertAnimationSection("chaseinitial", newObj);
				this.InsertAnimationSection("rage", newObj);
				this.InsertAnimationSection("stun", newObj);
				this.InsertAnimationSection("death", newObj);
				this.InsertAnimationSection("spawn", newObj);
				this.InsertAnimationSection("fleestart", newObj);
				this.InsertAnimationSection("heal", newObj);
				this.InsertAnimationSection("deathcam", newObj);
				this.InsertAnimationSection("crawlwalk", newObj);
				this.InsertAnimationSection("crawlrun", newObj);
			}
		}

		char particle[128], sound[PLATFORM_MAX_PATH];
		float offset[3];
		this.GetVector("tp_effect_origin", offset, offset);
		if (this.GetBool("tp_effect_spawn"))
		{
			newObj = this.InsertNewSection("spawn_effects");
			temp = newObj.InsertNewSection("Legacy Spawn");
			temp2 = temp.InsertNewSection("effects");
			this.GetString("tp_effect_spawn_particle", particle, sizeof(particle));
			this.GetString("tp_effect_spawn_sound", sound, sizeof(sound));
			if (particle[0] != '\0')
			{
				temp3 = temp2.InsertNewSection("particle");
				temp3.SetString("type", "particle");
				temp3.SetString("particlename", particle);
				temp3.SetVector("origin", offset);
			}

			if (sound[0] != '\0')
			{
				float defFloat = 1.0;
				defFloat = this.GetFloat("tp_effect_spawn_sound_volume", defFloat);
				int defInt = 100;
				defInt = this.GetInt("tp_effect_spawn_sound_pitch", defInt);

				temp3 = temp2.InsertNewSection("sound");
				temp3.SetString("type", "sound");
				temp4 = temp3.InsertNewSection("paths");
				temp4.SetString("1", sound);
				temp3.SetFloat("volume", defFloat);
				temp3.SetInt("pitch", defInt);
			}
		}

		if (this.GetBool("tp_effect_despawn"))
		{
			newObj = this.InsertNewSection("despawn_effects");
			temp = newObj.InsertNewSection("Legacy Despawn");
			temp2 = temp.InsertNewSection("effects");
			this.GetString("tp_effect_despawn_particle", particle, sizeof(particle));
			this.GetString("tp_effect_despawn_sound", sound, sizeof(sound));
			if (particle[0] != '\0')
			{
				temp3 = temp2.InsertNewSection("particle");
				temp3.SetString("type", "particle");
				temp3.SetString("particlename", particle);
				temp3.SetVector("origin", offset);
			}

			if (sound[0] != '\0')
			{
				float defFloat = 1.0;
				defFloat = this.GetFloat("tp_effect_despawn_sound_volume", defFloat);
				int defInt = 100;
				defInt = this.GetInt("tp_effect_despawn_sound_pitch", defInt);

				temp3 = temp2.InsertNewSection("sound");
				temp3.SetString("type", "sound");
				temp4 = temp3.InsertNewSection("paths");
				temp4.SetString("1", sound);
				temp3.SetFloat("volume", defFloat);
				temp3.SetInt("pitch", defInt);
			}
		}

		if (this.GetBool("customizable_outlines", false))
		{
			newObj = this.InsertNewSection("outline");
			int color[4];
			color[0] = this.GetInt("outline_color_r", 255);
			color[1] = this.GetInt("outline_color_g", 255);
			color[2] = this.GetInt("outline_color_b", 255);
			color[3] = this.GetInt("outline_color_transparency", 255);
			ColorToString(color, value, sizeof(value));
			newObj.SetKeyValue("color", value);
			newObj.TransferKey(this, "enable_rainbow_outline", "rainbow");
			newObj.TransferKey(this, "rainbow_outline_cycle_rate", "rainbow_cycle");
		}

		if (this.GetBool("is_pve"))
		{
			newObj = this.InsertNewSection("pve");
			newObj.TransferKey(this, "pve_spawn_message_prefix", "spawn_message_prefix");
			newObj.TransferKey(this, "pve_health_bar", "health_bar");
			newObj.TransferKey(this, "pve_selectable", "selectable");
			if (this.GetSection("pve_spawn_messages") != null)
			{
				temp = view_as<ProfileObject>(this.GetSection("pve_spawn_messages").Clone());
				temp.SetSectionName("spawn_messages");
				newObj.AddExistingSection(temp);
				this.RemoveKey("pve_spawn_messages");
			}
		}

		if (this.GetBool("enable_random_selection_boxing"))
		{
			this.TransferKey(this, "enable_random_selection_boxing", "enable_random_selection");
		}

		if (this.GetBool("enable_random_selection_renevant"))
		{
			this.TransferKey(this, "enable_random_selection_renevant", "enable_random_selection");
		}

		for (int i = 0; i < this.SectionLength; i++)
		{
			this.GetSectionNameFromIndex(i, key, sizeof(key));
			if (StrContains(key, "sound_footsteps_event_", false)  != -1)
			{
				newObj = this.InsertNewSection("events");
				temp = view_as<ProfileObject>(this.GetSection(key).Clone());
				this.RemoveKey(key);
				ReplaceStringEx(key, sizeof(key), "sound_footsteps_event_", "", .caseSensitive = false);
				temp.SetSectionName("sounds");
				temp2 = newObj.InsertNewSection(key);
				temp2.AddExistingSection(temp);
				temp2.SetKeyValue("footstep", "1");
				i--;
				continue;
			}

			if (StrContains(key, "sound_event_", false) != -1)
			{
				newObj = this.InsertNewSection("events");
				temp = view_as<ProfileObject>(this.GetSection(key).Clone());
				this.RemoveKey(key);
				ReplaceStringEx(key, sizeof(key), "sound_event_", "", .caseSensitive = false);
				temp.SetSectionName("sounds");
				temp2 = newObj.InsertNewSection(key);
				temp2.AddExistingSection(temp);
				i--;
				continue;
			}
		}

		if (this.GetSection("sound_music_outro") != null)
		{
			this.RenameKey("sound_music_outro", "sound_outro_lose");
			newObj = view_as<ProfileObject>(this.GetSection("sound_outro_lose").Clone());
			newObj.SetSectionName("sound_outro_win");
			this.AddExistingSection(newObj);
		}

		if (this.GetBool("death_cam"))
		{
			this.RemoveKey("death_cam");
			newObj = this.InsertNewSection("death_cam");
			newObj.TransferKey(this, "death_cam_pos", "look_position");
			newObj.TransferKey(this, "death_cam_play_scare_sound", "scare_sound");
			newObj.SetFloat("__legacy_duration", this.GetFloat("death_cam_time_death") + this.GetFloat("death_cam_time_overlay_start"));
			newObj.SetFloat("__legacy_overlay_start", this.GetFloat("death_cam_time_overlay_start"));
			if (this.GetSection("overlay_player_death") != null)
			{
				temp3 = view_as<ProfileObject>(this.GetSection("overlay_player_death").Clone());
				temp3.SetSectionName("overlays");
				newObj.AddExistingSection(temp3);
			}
			if (this.GetSection("animations") != null)
			{
				temp = this.GetSection("animations");
				temp2 = newObj.InsertNewSection("animations");
				if (temp.GetSection("deathcam") != null)
				{
					temp2.AddExistingSection(view_as<ProfileObject>(temp.GetSection("deathcam").Clone()));
				}
				else if (temp.GetSection("idle") != null)
				{
					temp2.AddExistingSection(view_as<ProfileObject>(temp.GetSection("idle").Clone()));
				}
			}
			if (this.GetBool("death_cam_public") || this.GetSection("public_death_cam") != null)
			{
				temp = newObj.InsertNewSection("public");
				temp.TransferKey(this, "death_cam_acceleration", "acceleration");
				temp.TransferKey(this, "death_cam_deceleration", "deceleration");
				temp.TransferKey(this, "death_cam_speed", "speed");
				if (this.GetSection("public_death_cam") == null)
				{
					this.GetString("death_cam_attachtment_target_point", value, sizeof(value));
					this.GetString("death_cam_attachment_target_point", value, sizeof(value));
					temp.SetKeyValue("target_attachment", value);
					this.GetString("death_cam_attachtment_target_point", value, sizeof(value));
					this.GetString("death_cam_attachment_target_point", value, sizeof(value));
					temp.SetKeyValue("attachment", value);
					temp = temp.InsertNewSection("offset");
					temp.TransferKey(this, "deathcam_death_backward_offset", "backward");
					temp.TransferKey(this, "deathcam_death_downward_offset", "downward");
				}
				else
				{
					temp2 = this.GetSection("public_death_cam");
					temp.TransferKey(temp2, "acceleration", "acceleration");
					temp.TransferKey(temp2, "deceleration", "deceleration");
					temp.TransferKey(temp2, "target_attachment", "target_attachment");
					temp.TransferKey(temp2, "attachment", "attachment");
					if (temp2.GetSection("offset") != null)
					{
						temp.AddExistingSection(view_as<ProfileObject>(temp2.GetSection("offset").Clone()));
					}
					if (temp2.GetSection("sounds") != null)
					{
						newObj.AddExistingSection(view_as<ProfileObject>(temp2.GetSection("sounds").Clone()));
					}
				}
			}
		}

		bool exists = false;
		for (int i = 1; i < Difficulty_Max; i++)
		{
			if (this.GetDifficultySection("sound_music", i) != null)
			{
				exists = true;
				break;
			}
		}

		if (exists)
		{
			newObj = this.InsertNewSection("music");
			newObj = newObj.InsertNewSection("global");

			for (int i = 1; i < Difficulty_Max; i++)
			{
				temp = this.GetDifficultySection("sound_music", i);
				if (temp == null)
				{
					continue;
				}

				temp = temp.GetSection("paths");
				if (temp == null)
				{
					continue;
				}

				temp2 = newObj.InsertDifficultySection("tracks", i);
				for (int i2 = 0; i2 < temp.KeyLength; i2++)
				{
					temp.GetKeyNameFromIndex(i2, key, sizeof(key));
					temp.GetString(key, path, sizeof(path));
					temp3 = temp2.InsertNewSection(key);
					temp3.SetKeyValue("path", path);
				}
			}
		}

		this.ConvertSectionsSectionToArray("spawn_effects");
		this.ConvertSectionsSectionToArray("despawn_effects");
		this.ConvertValuesSectionToArray("overlay_jumpscare");
		this.ConvertValuesSectionToArray("overlay_red_camera");
		this.ConvertValuesSectionToArray("mat_download");
		this.ConvertValuesSectionToArray("mod_download");
		this.ConvertValuesSectionToArray("mod_precache");
		this.ConvertValuesSectionToArray("download");

		KeyMap_Array arr = this.GetArray("mat_download");
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH], file[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));

				FormatEx(file, sizeof(file), "%s.vtf", asset);
				if (g_FileCheckConVar.BoolValue)
				{
					if (FileExists(file) || FileExists(file, true))
					{
						AddFileToDownloadsTable(file);
					}
					else
					{
						LogSF2Message("Texture file %s does not exist, please fix this download or remove it from the array.", file);
					}
				}
				else
				{
					AddFileToDownloadsTable(file);
				}

				FormatEx(file, sizeof(file), "%s.vmt", asset);
				if (g_FileCheckConVar.BoolValue)
				{
					if (FileExists(file) || FileExists(file, true))
					{
						AddFileToDownloadsTable(file);
					}
					else
					{
						LogSF2Message("Material file %s does not exist, please fix this download or remove it from the array.", file);
					}
				}
				else
				{
					AddFileToDownloadsTable(file);
				}
			}
		}

		arr = this.GetArray("mod_download");
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));
				if (asset[0] != '\0')
				{
					PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
				}
			}
		}

		arr = this.GetArray("mod_precache");
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));
				if (asset[0] != '\0')
				{
					PrecacheModel(asset, true);
				}
			}
		}

		arr = this.GetArray("download");
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));
				if (asset[0] != '\0')
				{
					AddFileToDownloadsTable(asset);
				}
			}
		}

		arr = this.GetJumpscareOverlays();
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));
				if (asset[0] != '\0')
				{
					PrecacheMaterial2(asset, g_FileCheckConVar.BoolValue);
				}
			}
		}

		arr = this.GetRedCameraOverlays();
		if (arr != null)
		{
			for (int i = 0; i < arr.Length; i++)
			{
				char asset[PLATFORM_MAX_PATH];
				arr.GetString(i, asset, sizeof(asset));
				if (asset[0] != '\0')
				{
					PrecacheMaterial2(asset, g_FileCheckConVar.BoolValue);
				}
			}
		}

		if (this.GetIntroSounds() != null)
		{
			this.GetIntroSounds().Precache();
		}

		if (this.GetLocalSpawnSounds() != null)
		{
			this.GetLocalSpawnSounds().Precache();
		}

		if (this.GetScareSounds() != null)
		{
			this.GetScareSounds().Precache();
		}

		if (this.GetJumpscareSounds() != null)
		{
			this.GetJumpscareSounds().Precache();
		}

		if (this.GetClientDeathCamSounds() != null)
		{
			this.GetClientDeathCamSounds().Precache();
		}

		if (this.GetGlobalDeathCamSounds() != null)
		{
			this.GetGlobalDeathCamSounds().Precache();
		}

		if (this.GetLocalDeathCamSounds() != null)
		{
			this.GetLocalDeathCamSounds().Precache();
		}

		if (this.GetOverlayDeathCamSounds() != null)
		{
			this.GetOverlayDeathCamSounds().Precache();
		}

		if (this.GetSightSounds() != null)
		{
			this.GetSightSounds().Precache();
		}

		if (this.GetSpawnEffects() != null)
		{
			for (int i = 0; i < this.GetSpawnEffects().Length; i++)
			{
				ProfileObject obj = view_as<ProfileObject>(this.GetSpawnEffects().GetSection(i));
				obj = obj != null ? obj.GetSection("effects") : null;
				if (obj == null)
				{
					continue;
				}
				view_as<ProfileEffectMaster>(obj).Precache();
			}
		}

		if (this.GetDespawnEffects() != null)
		{
			for (int i = 0; i < this.GetDespawnEffects().Length; i++)
			{
				ProfileObject obj = view_as<ProfileObject>(this.GetDespawnEffects().GetSection(i));
				obj = obj != null ? obj.GetSection("effects") : null;
				if (obj == null)
				{
					continue;
				}
				view_as<ProfileEffectMaster>(obj).Precache();
			}
		}

		if (this.GetGlobalMusic(1) != null)
		{
			this.GetGlobalMusic(1).Precache();
		}

		if (this.GetGlobalTracks() != null)
		{
			this.GetGlobalTracks().Precache();
		}

		if (this.GetOutroLoseSounds() != null)
		{
			this.GetOutroLoseSounds().Precache();
		}

		if (this.GetOutroWinSounds() != null)
		{
			this.GetOutroWinSounds().Precache();
		}

		if (this.GetLocalKillSounds() != null)
		{
			this.GetLocalKillSounds().Precache();
		}

		if (this.GetGlobalKillSounds() != null)
		{
			this.GetGlobalKillSounds().Precache();
		}

		if (this.GetClientKillSounds() != null)
		{
			this.GetClientKillSounds().Precache();
		}

		if (this.GetDeathCamData() != null)
		{
			this.GetDeathCamData().Precache();
		}

		newObj = this.GetSection("events");
		if (newObj != null)
		{
			for (int i = 0; i < newObj.SectionLength; i++)
			{
				char index[64];
				newObj.GetSectionNameFromIndex(i, index, sizeof(index));
				BossProfileEventData event = view_as<BossProfileEventData>(newObj.GetSection(index));
				if (event == null)
				{
					continue;
				}

				event.Precache();
			}
		}

		switch (this.Type)
		{
			case SF2BossType_Chaser:
			{
				view_as<ChaserBossProfile>(this).Precache();
			}

			case SF2BossType_Statue:
			{
				view_as<StatueBossProfile>(this).Precache();
			}
		}

		delete keys;
	}

	public void InsertAnimationSection(char[] animName, ProfileObject animationSection)
	{
		ProfileObject temp = null;
		char formatter[128], name[64];

		for (int i = 0; i < Difficulty_Max; i++)
		{
			FormatEx(formatter, sizeof(formatter), "animation_%s", animName);
			if (this.ContainsDifficultyKey(formatter, i))
			{
				temp = animationSection.InsertNewSection(animName);
				temp = temp.InsertNewSection("1");
				this.GetDifficultyString(formatter, i, name, sizeof(name));
				temp.SetDifficultyString("name", i, name);
				FormatEx(formatter, sizeof(formatter), "animation_%s_playbackrate", animName);
				temp.SetDifficultyFloat("playbackrate", i, this.GetDifficultyFloat(formatter, i, 1.0));
				FormatEx(formatter, sizeof(formatter), "animation_%s_footstepinterval", animName);
				temp.SetDifficultyFloat("footstepinterval", i, this.GetDifficultyFloat(formatter, i, 0.0));
			}
		}
	}
}

methodmap BossProfileEventData < ProfileObject
{
	property bool IsFootsteps
	{
		public get()
		{
			return this.GetBool("footstep");
		}
	}

	public ProfileSound GetSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sounds"));
	}

	public ProfileEffectMaster GetEffects()
	{
		return view_as<ProfileEffectMaster>(this.GetSection("effects"));
	}

	public void Precache()
	{
		if (this.GetSounds() != null)
		{
			this.GetSounds().Precache();
		}

		if (this.GetEffects() != null)
		{
			this.GetEffects().Precache();
		}
	}
}

methodmap BossProfilePvEData < ProfileObject
{
	property bool IsEnabled
	{
		public get()
		{
			return this != null;
		}
	}

	property bool IsSelectable
	{
		public get()
		{
			return this.GetBool("selectable", true);
		}
	}

	public ProfileObject GetSpawnMessages()
	{
		return this.GetSection("spawn_messages");
	}

	public void GetSpawnMessagePrefix(char[] buffer, int bufferSize)
	{
		this.GetString("spawn_message_prefix", buffer, bufferSize);
	}

	property bool DisplayHealth
	{
		public get()
		{
			this.GetBool("health_bar", true);
		}
	}

	property float TeleportEndTimer
	{
		public get()
		{
			return this.GetFloat("teleport_players_time", 5.0);
		}
	}
}

methodmap BossProfileCopies < ProfileObject
{
	property bool IsLegacy
	{
		public get()
		{
			char section[64];
			this.GetSectionName(section, sizeof(section));
			return strcmp(section, "copies") != 0;
		}
	}

	public bool IsEnabled(int difficulty)
	{
		bool def = false;
		if (this.IsLegacy)
		{
			return this.GetDifficultyBool("copy", difficulty, def);
		}
		return this.GetDifficultyBool("enabled", difficulty, def);
	}

	public int GetMinCopies(int difficulty)
	{
		int def = 0;
		if (this.IsLegacy)
		{
			return def;
		}
		return this.GetDifficultyInt("min", difficulty, def);
	}

	public int GetMaxCopies(int difficulty)
	{
		int def = 1;
		if (this.IsLegacy)
		{
			return this.GetDifficultyInt("copy_max", difficulty, def);
		}
		return this.GetDifficultyInt("max", difficulty, def);
	}

	public float GetTeleportDistanceSpacing(int difficulty)
	{
		float def = 800.0;
		if (this.IsLegacy)
		{
			return this.GetDifficultyFloat("copy_teleport_dist_from_others", difficulty, def);
		}
		return this.GetDifficultyFloat("teleport_spacing_between", difficulty, def);
	}

	public bool GetFakes(int difficulty)
	{
		bool def = false;
		if (this.IsLegacy)
		{
			return this.GetDifficultyBool("fake_copies", difficulty, def);
		}
		return this.GetDifficultyBool("fakes", difficulty, def);
	}
}

methodmap BossProfileCompanions < ProfileObject
{
	public void GetSpawnType(char[] buffer, int bufferSize)
	{
		this.GetString("type", buffer, bufferSize, "on_spawn");
	}

	public bool DoesGroupExist(char[] group)
	{
		return this.GetSection(group) != null;
	}

	public float GetWeightFromGroup(char[] group, int difficulty)
	{
		float def = 1.0;
		if (!this.DoesGroupExist(group))
		{
			return 0.0;
		}
		return this.GetSection(group).GetDifficultyFloat("weight", difficulty, def);
	}

	public ProfileObject GetBossesFromGroup(char[] group)
	{
		if (!this.DoesGroupExist(group))
		{
			return null;
		}
		ProfileObject obj = this.GetSection(group);
		return obj.GetSection("bosses");
	}

	public bool DoesGroupExistEx(int group, char[] buffer, int bufferSize)
	{
		return this.GetSectionNameFromIndex(group, buffer, bufferSize);
	}

	public float GetWeightFromGroupEx(int group, int difficulty)
	{
		float def = 1.0;
		char key[SF2_MAX_PROFILE_NAME_LENGTH];
		if (!this.GetSectionNameFromIndex(group, key, sizeof(key)))
		{
			return 0.0;
		}
		return this.GetSection(key).GetDifficultyFloat("weight", difficulty, def);
	}

	public ProfileObject GetBossesFromGroupEx(int group)
	{
		char key[SF2_MAX_PROFILE_NAME_LENGTH];
		if (!this.GetSectionNameFromIndex(group, key, sizeof(key)))
		{
			return null;
		}
		ProfileObject obj = this.GetSection(key);
		return obj.GetSection("bosses");
	}
}

methodmap BossProfileEyeData < ProfileObject
{
	property bool IsLegacy
	{
		public get()
		{
			char section[64];
			this.GetSectionName(section, sizeof(section));
			return strcmp(section, "eyes") != 0;
		}
	}

	property int Type
	{
		public get()
		{
			if (this.IsLegacy)
			{
				return 0;
			}

			char type[64];
			this.GetString("mode", type, sizeof(type), "default");
			if (strcmp(type, "bone") == 0)
			{
				return 1;
			}
			return 0;
		}
	}

	public void GetOffsetPos(float buffer[3])
	{
		float def[3];
		if (this.Type == 0)
		{
			def = { 0.0, 0.0, 45.0 };
		}
		if (this.IsLegacy)
		{
			this.GetVector("eye_pos", buffer, def);
		}
		else
		{
			this.GetVector("offset_pos", buffer, def);
		}
	}

	public void GetOffsetAng(float buffer[3])
	{
		if (this.IsLegacy)
		{
			this.GetVector("eye_ang_offset", buffer);
		}
		else
		{
			this.GetVector("offset_pos", buffer);
		}
	}

	public void GetBone(char[] buffer, int bufferSize)
	{
		this.GetString("bone", buffer, bufferSize);
	}
}

methodmap BossProfileOutlineData < ProfileObject
{
	public void GetOutlineColor(int buffer[4], int difficulty)
	{
		this.GetDifficultyColor("color", difficulty, buffer);
	}

	public bool GetRainbowState(int difficulty)
	{
		return this.GetDifficultyBool("rainbow", difficulty, false);
	}

	public float GetRainbowCycle(int difficulty)
	{
		return this.GetDifficultyFloat("rainbow_cycle", difficulty, 1.0);
	}
}

methodmap BossProfileSlaughterRunData < ProfileObject
{
	public bool ShouldUseCustomMinSpeed(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("custom_minimum_speed", difficulty, false);
	}

	public float GetCustomSpawnTime(int difficulty)
	{
		if (this == null)
		{
			return -1.0;
		}
		return this.GetDifficultyFloat("spawn_time", difficulty, -1.0);
	}
}

methodmap BossProfileAttributes < ProfileObject
{
	public float GetValue(int attribute)
	{
		float def = -1.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection(g_AttributesList[attribute]);
		if (obj == null)
		{
			return def;
		}
		return obj.GetFloat("value", def);
	}
}

methodmap BossProfileDescription < ProfileObject
{
	property bool Hidden
	{
		public get()
		{
			if (this == null)
			{
				return false;
			}
			return this.GetBool("hidden", false);
		}
	}

	public void GetType(char[] buffer, int bufferSize, char[] def)
	{
		if (this == null)
		{
			strcopy(buffer, bufferSize, def);
			return;
		}
		this.GetString("type", buffer, bufferSize, def);
	}

	public void GetDescription(char[] buffer, int bufferSize)
	{
		char def[64];
		def = "No description provided.";
		if (this == null)
		{
			strcopy(buffer, bufferSize, def);
			return;
		}
		this.GetString("description", buffer, bufferSize, def);
	}
}

methodmap BossProfileParticleData < ProfileObject
{
	public void GetName(char[] buffer, int bufferSize)
	{
		this.GetString("particle", buffer, bufferSize);
	}

	property bool AttachParticles
	{
		public get()
		{
			return this.GetBool("attach", true);
		}
	}

	property bool BeamParticles
	{
		public get()
		{
			return this.GetBool("beam", false);
		}
	}

	property ParticleAttachment Type
	{
		public get()
		{
			return view_as<ParticleAttachment>(this.GetInt("attach_type", view_as<int>(PATTACH_CUSTOMORIGIN)));
		}
	}

	public void GetAttachment(char[] buffer, int bufferSize)
	{
		this.GetString("attachment", buffer, bufferSize);
	}

	public void Apply(CBaseAnimating target, CBaseAnimating caster)
	{
		CBaseAnimating castTo;
		float myPos[3], myAng[3], targetPos[3];
		if (!this.AttachParticles || this.BeamParticles)
		{
			caster.WorldSpaceCenter(myPos);
			caster.GetAbsAngles(myAng);
			target.WorldSpaceCenter(targetPos);
			if (this.AttachParticles)
			{
				castTo = caster;
			}
		}
		else
		{
			target.WorldSpaceCenter(myPos);
			target.GetAbsAngles(myAng);
			castTo = target;
		}

		int attachment = 0;
		char name[128], attachmentName[64];
		this.GetAttachment(attachmentName, sizeof(attachmentName));
		this.GetName(name, sizeof(name));
		if (attachmentName[0] != '\0')
		{
			attachment = castTo.LookupAttachment(attachmentName);
		}
		if (attachment != 0)
		{
			castTo.GetAttachment(attachment, myPos, myAng);
		}

		if (this.Type == PATTACH_ROOTBONE_FOLLOW)
		{
			myPos = NULL_VECTOR;
			myAng = NULL_VECTOR;
		}

		if (this.BeamParticles)
		{
			DispatchParticleEffectBeam(castTo.index, name, myPos, myAng, targetPos, attachment, this.Type, true);
		}
		else
		{
			if (!DispatchParticleEffect(castTo.index, name, myPos, myAng, myPos, attachment, this.Type, true))
			{
				if (this.Type == PATTACH_ROOTBONE_FOLLOW)
				{
					castTo.WorldSpaceCenter(myPos);
					castTo.GetAbsAngles(myAng);
				}
				CBaseEntity particleEnt = CBaseEntity(CreateEntityByName("info_particle_system"));
				if (particleEnt.IsValid())
				{
					particleEnt.Teleport(myPos, myAng, NULL_VECTOR);

					particleEnt.KeyValue("effect_name", name);
					particleEnt.Spawn();
					particleEnt.Activate();
					particleEnt.AcceptInput("start");
					RemoveEntity(particleEnt.index);
				}
			}
		}
	}
}

methodmap BossKillSoundsData < ProfileObject
{
	public ProfileSound GetKilledAllSounds()
	{
		return view_as<ProfileSound>(this.GetSection("player"));
	}

	public ProfileSound GetKilledClassSounds(TFClassType class)
	{
		switch (class)
		{
			case TFClass_Scout:
			{
				return view_as<ProfileSound>(this.GetSection("scout"));
			}

			case TFClass_Soldier:
			{
				return view_as<ProfileSound>(this.GetSection("soldier"));
			}

			case TFClass_Pyro:
			{
				return view_as<ProfileSound>(this.GetSection("pyro"));
			}

			case TFClass_DemoMan:
			{
				return view_as<ProfileSound>(this.GetSection("demoman"));
			}

			case TFClass_Heavy:
			{
				return view_as<ProfileSound>(this.GetSection("heavy"));
			}

			case TFClass_Engineer:
			{
				return view_as<ProfileSound>(this.GetSection("engineer"));
			}

			case TFClass_Medic:
			{
				return view_as<ProfileSound>(this.GetSection("medic"));
			}

			case TFClass_Sniper:
			{
				return view_as<ProfileSound>(this.GetSection("sniper"));
			}

			case TFClass_Spy:
			{
				return view_as<ProfileSound>(this.GetSection("spy"));
			}
		}
		return this.GetKilledAllSounds();
	}

	public void Precache()
	{
		if (this.GetKilledAllSounds() != null)
		{
			this.GetKilledAllSounds().Precache();
		}

		for (int i = 1; i <= view_as<int>(TFClass_Engineer); i++)
		{
			if (this.GetKilledClassSounds(view_as<TFClassType>(i)) != null)
			{
				this.GetKilledClassSounds(view_as<TFClassType>(i)).Precache();
			}
		}
	}
}

/**
 *	Loads a profile in the current KeyValues position in kv.
 */
/*bool LoadBossProfile(const char[] profile, char[] loadFailReasonBuffer, int loadFailReasonBufferLen, bool lookIntoLoads = false, const char[] originalDir = "")
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
}*/
