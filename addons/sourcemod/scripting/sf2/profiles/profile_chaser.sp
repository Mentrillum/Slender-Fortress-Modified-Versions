#if defined _sf2_profiles_chaser
 #endinput
#endif

#define _sf2_profiles_chaser

#pragma semicolon 1
#pragma newdecls required

/*for (int i = 0; i < Difficulty_Max; i++)
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
		this.DecloakEffects = null;*/

methodmap ChaserBossProfile < BaseBossProfile
{
	property bool ClearLayersOnAnimUpdate
	{
		public get()
		{
			return this.GetBool("animation_clear_layers_on_update", false);
		}
	}

	property bool BoxingBoss
	{
		public get()
		{
			return this.GetBool("boxing_boss", false);
		}
	}

	property bool ChasesEndlessly
	{
		public get()
		{
			return this.GetBool("boss_chases_endlessly", false);
		}
	}

	property bool NormalSoundHook
	{
		public get()
		{
			return this.GetBool("normal_sound_hook", false);
		}
	}

	property bool OldAnimationAI
	{
		public get()
		{
			return this.GetBool("old_animation_ai", false);
		}
	}

	public float GetWalkSpeed(int difficulty)
	{
		return this.GetDifficultyFloat("walkspeed", difficulty, 90.0);
	}

	public float GetWakeRadius(int difficulty)
	{
		return this.GetDifficultyFloat("wake_radius", difficulty, 90.0);
	}

	public float GetHearingRange(int difficulty)
	{
		float value = 1024.0;
		value = this.GetDifficultyFloat("hearing_range", difficulty, value);
		value = this.GetDifficultyFloat("search_sound_range", difficulty, value);
		return value;
	}

	public bool ShouldIgnoreHearingPathChecking(int difficulty)
	{
		return this.GetDifficultyBool("hearing_ignore_path_checking", difficulty, false);
	}

	public bool CanWander(int difficulty)
	{
		return this.GetDifficultyBool("wander_move", difficulty, true);
	}

	public float GetWanderMinRange(int difficulty)
	{
		return this.GetDifficultyFloat("wander_range_min", difficulty, 800.0);
	}

	public float GetWanderMaxRange(int difficulty)
	{
		return this.GetDifficultyFloat("wander_range_max", difficulty, 1600.0);
	}

	public float GetWanderMinTime(int difficulty)
	{
		return this.GetDifficultyFloat("wander_time_min", difficulty, 8.0);
	}

	public float GetWanderMaxTime(int difficulty)
	{
		return this.GetDifficultyFloat("wander_time_max", difficulty, 12.0);
	}

	public float GetWanderEnterMinTime(int difficulty)
	{
		return this.GetDifficultyFloat("wander_enter_time_min", difficulty, 2.0);
	}

	public float GetWanderEnterMaxTime(int difficulty)
	{
		return this.GetDifficultyFloat("wander_enter_time_max", difficulty, 4.5);
	}

	property float BackstabDamageScale
	{
		public get()
		{
			return this.GetFloat("backstab_damage_scale", 0.05);
		}
	}

	public ChaserBossProfileIdleData GetIdleBehavior()
	{
		return view_as<ChaserBossProfileIdleData>(this.GetSection("idle"));
	}

	public ChaserBossProfileAlertData GetAlertBehavior()
	{
		return view_as<ChaserBossProfileAlertData>(this.GetSection("alert"));
	}

	public ChaserBossProfileChaseData GetChaseBehavior()
	{
		return view_as<ChaserBossProfileChaseData>(this.GetSection("chase"));
	}

	public ChaserBossProfileStunData GetStunBehavior()
	{
		return view_as<ChaserBossProfileStunData>(this.GetSection("stun"));
	}

	property bool Healthbar
	{
		public get()
		{
			return this.GetBool("healthbar", false);
		}
	}

	public ChaserBossProfileDeathData GetDeathBehavior()
	{
		return view_as<ChaserBossProfileDeathData>(this.GetSection("death"));
	}

	public int GetAttackCount()
	{
		KeyMap_Array arr = this.GetArray("__chaser_attack_names");
		if (arr == null)
		{
			return -1;
		}

		return arr.Length;
	}

	public void GetAttackName(int index, char[] buffer, int bufferSize)
	{
		KeyMap_Array arr = this.GetArray("__chaser_attack_names");
		if (arr == null)
		{
			return;
		}

		arr.GetString(index, buffer, bufferSize);
	}

	public int GetAttackIndex(const char[] attackName)
	{
		KeyMap_Array arr = this.GetArray("__chaser_attack_names");
		if (arr == null)
		{
			return -1;
		}

		return arr.IndexOf(attackName);
	}

	public ChaserBossProfileBaseAttack GetAttack(const char[] name)
	{
		ProfileObject obj = this.GetSection("attacks");
		if (obj == null)
		{
			return null;
		}

		return view_as<ChaserBossProfileBaseAttack>(obj.GetSection(name));
	}

	public ChaserBossProfileBaseAttack GetAttackFromIndex(int index)
	{
		char name[256];
		this.GetAttackName(index, name, sizeof(name));
		return this.GetAttack(name);
	}

	public ProfileObject GetPosture(const char[] name)
	{
		ProfileObject obj = this.GetSection("postures");
		if (obj == null || strcmp(name, SF2_PROFILE_CHASER_DEFAULT_POSTURE) == 0)
		{
			return null;
		}

		return obj.GetSection(name);
	}

	public ProfileObject GetPostureFromIndex(int index)
	{
		ProfileObject obj = this.GetSection("postures");
		if (obj == null)
		{
			return null;
		}

		char name[64];
		obj.GetSectionNameFromIndex(index, name, sizeof(name));
		if (strcmp(name, SF2_PROFILE_CHASER_DEFAULT_POSTURE) == 0)
		{
			return null;
		}

		return obj.GetSection(name);
	}

	public float GetPostureRunSpeed(const char[] name, int difficulty)
	{
		float value = this.GetRunSpeed(difficulty);

		ProfileObject obj = this.GetPosture(name);
		if (obj != null)
		{
			value = obj.GetDifficultyFloat("speed", difficulty, value);
		}

		return value;
	}

	public float GetPostureWalkSpeed(const char[] name, int difficulty)
	{
		float value = this.GetWalkSpeed(difficulty);

		ProfileObject obj = this.GetPosture(name);
		if (obj != null)
		{
			value = obj.GetDifficultyFloat("walkspeed", difficulty, value);
		}

		return value;
	}

	public float GetPostureAcceleration(const char[] name, int difficulty)
	{
		float value = this.GetAcceleration(difficulty);

		ProfileObject obj = this.GetPosture(name);
		if (obj != null)
		{
			value = obj.GetDifficultyFloat("acceleration", difficulty, value);
		}

		return value;
	}

	public ProfileMasterAnimations GetPostureAnimations(const char[] name)
	{
		ProfileObject obj = this.GetPosture(name);
		obj = obj != null ? obj.GetSection("animations") : null;
		if (obj != null)
		{
			return view_as<ProfileMasterAnimations>(obj);
		}

		return null;
	}

	public ChaserBossProfileSmellData GetSmellData()
	{
		ProfileObject obj = this.GetSection("senses");
		obj = obj != null ? obj.GetSection("smell") : null;
		if (obj != null)
		{
			return view_as<ChaserBossProfileSmellData>(obj);
		}

		return null;
	}

	public ChaserBossSoundSenseData GetSoundSenseData()
	{
		ProfileObject obj = this.GetSection("senses");
		obj = obj != null ? obj.GetSection("hearing") : null;
		if (obj != null)
		{
			return view_as<ChaserBossSoundSenseData>(obj);
		}

		return null;
	}

	public ProfileMusic GetIdleMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_idle_music"));
	}

	public ProfileMusic GetAlertMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_alert_music"));
	}

	public ProfileMusic GetChaseMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_chase_music"));
	}

	public ProfileMusic GetVisibleIdleMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_idle_visible"));
	}

	public ProfileMusic GetVisibleAlertMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_alert_visible"));
	}

	public ProfileMusic GetVisibleChaseMusics()
	{
		return view_as<ProfileMusic>(this.GetSection("sound_chase_visible"));
	}

	public bool HasTraps(int difficulty)
	{
		return this.GetDifficultyBool("traps_enabled", difficulty, false);
	}

	public int GetTrapType(int difficulty)
	{
		return this.GetDifficultyInt("trap_type", difficulty, 0);
	}

	public float GetTrapCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("trap_spawn_cooldown", difficulty, 8.0);
	}

	public void GetTrapModel(char[] buffer, int bufferSize)
	{
		this.GetString("trap_model", buffer, bufferSize, TRAP_MODEL);
	}

	public void GetTrapDeploySound(char[] buffer, int bufferSize)
	{
		this.GetString("trap_deploy_sound", buffer, bufferSize, TRAP_DEPLOY);
	}

	public void GetTrapMissSound(char[] buffer, int bufferSize)
	{
		this.GetString("trap_miss_sound", buffer, bufferSize, TRAP_CLOSE);
	}

	public void GetTrapCatchSound(char[] buffer, int bufferSize)
	{
		this.GetString("trap_catch_sound", buffer, bufferSize, TRAP_CLOSE);
	}

	public void GetTrapIdleAnimation(char[] buffer, int bufferSize)
	{
		this.GetString("trap_animation_idle", buffer, bufferSize, "trapopenend");
	}

	public void GetTrapClosedAnimation(char[] buffer, int bufferSize)
	{
		this.GetString("trap_animation_closed", buffer, bufferSize, "trapclosed");
	}

	public void GetTrapOpenAnimation(char[] buffer, int bufferSize)
	{
		this.GetString("trap_animation_open", buffer, bufferSize);
	}

	property bool EarthquakeFootsteps
	{
		public get()
		{
			return this.GetBool("earthquake_footsteps", false);
		}
	}

	property float EarthquakeFootstepRadius
	{
		public get()
		{
			return this.GetFloat("earthquake_footsteps_radius", 1000.0);
		}
	}

	property float EarthquakeFootstepDuration
	{
		public get()
		{
			return this.GetFloat("earthquake_footsteps_duration", 1.0);
		}
	}

	property bool EarthquakeFootstepAirShake
	{
		public get()
		{
			return this.GetBool("earthquake_footsteps_airshake", false);
		}
	}

	property float EarthquakeFootstepAmplitude
	{
		public get()
		{
			return this.GetFloat("earthquake_footsteps_amplitude", 5.0);
		}
	}

	property float EarthquakeFootstepFrequency
	{
		public get()
		{
			return this.GetFloat("earthquake_footsteps_frequency", 25.0);
		}
	}

	public ProfileObject GetRages()
	{
		return this.GetSection("rages");
	}

	public ChaserBossAutoChaseData GetAutoChaseData()
	{
		return view_as<ChaserBossAutoChaseData>(this.GetSection("autochase"));
	}

	public ChaserBossChaseOnLookData GetChaseOnLookData()
	{
		return view_as<ChaserBossChaseOnLookData>(this.GetSection("chase_on_look"));
	}

	public ChaserBossProfileCloakData GetCloakData()
	{
		return view_as<ChaserBossProfileCloakData>(this.GetSection("cloaking"));
	}

	public ProfileObject GetResistances()
	{
		return this.GetSection("resistances");
	}

	public ChaserBossProjectileData GetProjectiles()
	{
		return view_as<ChaserBossProjectileData>(this);
	}

	public ProfileSound GetIdleSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Idle]));
	}

	public ProfileSound GetAlertSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Alert]));
	}

	public ProfileSound GetChasingSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Chasing]));
	}

	public ProfileSound GetChaseInitialSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_ChaseInitial]));
	}

	public ProfileSound GetStunSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Stun]));
	}

	public ProfileSound GetAttackKilledSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_AttackKilled]));
	}

	public ProfileSound GetAttackKilledAllSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_attack_killed_all"));
	}

	public ProfileSound GetAttackKilledClientSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_attack_killed_client"));
	}

	public ProfileSound GetHurtSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_hurt"));
	}

	public ProfileSound GetDeathSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Death]));
	}

	public ProfileSound GetTauntKillSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_TauntKill]));
	}

	public ProfileSound GetSmellSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Smell]));
	}

	public ProfileSound GetSelfHealSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_SelfHeal]));
	}

	public ProfileSound GetRageAllSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_RageAll]));
	}

	public ProfileSound GetRageTwoSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_RageTwo]));
	}

	public ProfileSound GetRageThreeSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_RageThree]));
	}

	public ProfileSound GetDespawnSounds()
	{
		return view_as<ProfileSound>(this.GetSection(g_SlenderVoiceList[SF2BossSound_Despawn]));
	}

	public ProfileSound GetFootstepSounds()
	{
		return view_as<ProfileSound>(this.GetSection("sound_footsteps"));
	}

	public ProfileObject GetAttackSounds()
	{
		return this.GetSection(g_SlenderVoiceList[SF2BossSound_Attack]);
	}

	public ProfileObject GetAttackBeginSounds()
	{
		return this.GetSection(g_SlenderVoiceList[SF2BossSound_AttackBegin]);
	}

	public ProfileObject GetAttackLoopSounds()
	{
		return this.GetSection("sound_attack_loop");
	}

	public ProfileObject GetAttackEndSounds()
	{
		return this.GetSection(g_SlenderVoiceList[SF2BossSound_AttackEnd]);
	}

	public ProfileObject GetHitSounds()
	{
		return this.GetSection("sound_hitenemy");
	}

	public ProfileObject GetMissSounds()
	{
		return this.GetSection("sound_missenemy");
	}

	public ProfileObject GetBulletShootSounds()
	{
		return this.GetSection("sound_bulletshoot");
	}

	public ProfileObject GetProjectileShootSounds()
	{
		return this.GetSection("sound_attackshootprojectile");
	}

	public void Precache()
	{
		// ========================
		// LEGACY KEY CONVERSION
		// ========================
		ProfileObject newObj = this.GetIdleBehavior();
		ArrayList keys = new ArrayList(ByteCountToCells(256));
		newObj = this.InsertNewSection("idle");

		keys.PushString("alert_gracetime");
		keys.PushString("alert_duration");
		keys.PushString("search_alert_gracetime");
		keys.PushString("search_alert_duration");
		if (this.ContainsAnyDifficultyKey(keys))
		{
			newObj = this.InsertNewSection("alert");
			for (int i = 0; i < Difficulty_Max; i++)
			{
				float def = 0.5;
				if (this.ContainsDifficultyKey("alert_gracetime", i) || this.ContainsDifficultyKey("search_alert_gracetime", i))
				{
					def = this.GetDifficultyFloat("alert_gracetime", i, def);
					def = this.GetDifficultyFloat("search_alert_gracetime", i, def);
					newObj.SetDifficultyFloat("gracetime", i, def);
				}

				def = 10.0;
				if (this.ContainsDifficultyKey("alert_duration", i) || this.ContainsDifficultyKey("search_alert_duration", i))
				{
					def = this.GetDifficultyFloat("alert_duration", i, def);
					def = this.GetDifficultyFloat("search_alert_duration", i, def);
					newObj.SetDifficultyFloat("duration", i, def);
				}
			}
		}

		keys.Clear();
		ProfileObject temp = null, temp2 = null;
		keys.PushString("chase_duration");
		keys.PushString("search_chase_duration");
		keys.PushString("chase_duration_add_max_range");
		keys.PushString("chase_duration_add_visible_min");
		keys.PushString("chase_duration_add_visible_max");
		if (this.ContainsAnyDifficultyKey(keys))
		{
			newObj = this.InsertNewSection("chase");
			temp = newObj.InsertNewSection("duration");
			temp2 = temp.InsertNewSection("add");
			for (int i = 0; i < Difficulty_Max; i++)
			{
				float def = 10.0;
				if (this.ContainsDifficultyKey("chase_duration", i) || this.ContainsDifficultyKey("search_chase_duration", i))
				{
					def = this.GetDifficultyFloat("chase_duration", i, def);
					def = this.GetDifficultyFloat("search_chase_duration", i, def);
					temp.SetDifficultyFloat("max", i, def);
				}

				if (this.ContainsDifficultyKey("chase_duration_add_max_range", i))
				{
					temp2.SetDifficultyFloat("target_range", i, this.GetDifficultyFloat("chase_duration_add_max_range", i, this.GetSearchRange(i)));
				}

				if (this.ContainsDifficultyKey("chase_duration_add_visible_min", i))
				{
					temp2.SetDifficultyFloat("visible_target_near", i, this.GetDifficultyFloat("chase_duration_add_visible_min", i, 0.01));
				}

				if (this.ContainsDifficultyKey("chase_duration_add_visible_max", i))
				{
					temp2.SetDifficultyFloat("visible_target_far", i, this.GetDifficultyFloat("chase_duration_add_visible_max", i, 0.05));
				}
			}
		}

		keys.Clear();
		keys.PushString("stun_enabled");
		keys.PushString("stun_health");
		keys.PushString("stun_cooldown");
		keys.PushString("disappear_on_stun");
		keys.PushString("stun_damage_flashlight_enabled");
		keys.PushString("stun_damage_flashlight");
		keys.PushString("chase_initial_on_stun");
		keys.PushString("drop_item_on_stun");
		keys.PushString("drop_item_type");
		if (this.ContainsAnyDifficultyKey(keys))
		{
			newObj = this.InsertNewSection("stun");
			bool defBool = false;
			char defString[PLATFORM_MAX_PATH];
			for (int i = 0; i < Difficulty_Max; i++)
			{
				if (this.ContainsDifficultyKey("stun_enabled", i))
				{
					newObj.SetDifficultyBool("enabled", i, this.GetDifficultyBool("stun_enabled", i, false));
				}

				if (this.ContainsDifficultyKey("stun_health", i))
				{
					newObj.SetDifficultyFloat("health", i, this.GetDifficultyFloat("stun_health", i, 50.0));
				}

				if (this.ContainsDifficultyKey("stun_cooldown", i))
				{
					newObj.SetDifficultyFloat("cooldown", i, this.GetDifficultyFloat("stun_cooldown", i, 3.5));
				}

				if (this.ContainsDifficultyKey("disappear_on_stun", i))
				{
					newObj.SetDifficultyBool("disappear", i, this.GetDifficultyBool("disappear_on_stun", i, false));
				}

				defBool = this.GetDifficultyBool("stun_damage_flashlight_enabled", i, false);
				if (defBool)
				{
					temp = newObj.InsertNewSection("flashlight_stun");
					temp.SetDifficultyBool("enabled", i, defBool);

					if (this.ContainsDifficultyKey("stun_damage_flashlight", i))
					{
						temp.SetDifficultyFloat("damage", i, this.GetDifficultyFloat("stun_damage_flashlight", i, 0.0));
					}
				}

				if (this.ContainsDifficultyKey("chase_initial_on_stun", i))
				{
					newObj.SetDifficultyBool("chase_initial_on_end", i, this.GetDifficultyBool("chase_initial_on_stun", i, false));
				}

				if (this.ContainsDifficultyKey("drop_item_on_stun", i))
				{
					newObj.SetDifficultyBool("item_drop", i, this.GetDifficultyBool("drop_item_on_stun", i, false));
				}

				if (this.ContainsDifficultyKey("drop_item_type", i))
				{
					newObj.SetDifficultyInt("item_drop_type", i, this.GetDifficultyInt("drop_item_type", i, 1));
				}

				keys.Clear();
				keys.PushString("stun_health_per_player");
				keys.PushString("stun_health_per_scout");
				keys.PushString("stun_health_per_soldier");
				keys.PushString("stun_health_per_pyro");
				keys.PushString("stun_health_per_demoman");
				keys.PushString("stun_health_per_heavyweapons");
				keys.PushString("stun_health_per_engineer");
				keys.PushString("stun_health_per_medic");
				keys.PushString("stun_health_per_sniper");
				keys.PushString("stun_health_per_spy");
				if (this.ContainsAnyDifficultyKey(keys, i))
				{
					temp = newObj.InsertNewSection("add_health");
					if (this.ContainsDifficultyKey("stun_health_per_player", i))
					{
						temp.SetDifficultyFloat("player", i, this.GetDifficultyFloat("stun_health_per_player", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_scout", i))
					{
						temp.SetDifficultyFloat("scout", i, this.GetDifficultyFloat("stun_health_per_scout", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_soldier", i))
					{
						temp.SetDifficultyFloat("soldier", i, this.GetDifficultyFloat("stun_health_per_soldier", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_pyro", i))
					{
						temp.SetDifficultyFloat("pyro", i, this.GetDifficultyFloat("stun_health_per_pyro", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_demoman", i))
					{
						temp.SetDifficultyFloat("demoman", i, this.GetDifficultyFloat("stun_health_per_demoman", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_heavyweapons", i))
					{
						temp.SetDifficultyFloat("heavy", i, this.GetDifficultyFloat("stun_health_per_heavyweapons", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_engineer", i))
					{
						temp.SetDifficultyFloat("engineer", i, this.GetDifficultyFloat("stun_health_per_engineer", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_medic", i))
					{
						temp.SetDifficultyFloat("medic", i, this.GetDifficultyFloat("stun_health_per_medic", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_sniper", i))
					{
						temp.SetDifficultyFloat("sniper", i, this.GetDifficultyFloat("stun_health_per_sniper", i, 0.0));
					}

					if (this.ContainsDifficultyKey("stun_health_per_spy", i))
					{
						temp.SetDifficultyFloat("spy", i, this.GetDifficultyFloat("stun_health_per_spy", i, 0.0));
					}
				}
			}

			keys.Clear();
			keys.PushString("keydrop_enabled");
			keys.PushString("key_model");
			keys.PushString("key_trigger");
			if (this.ContainsAnyKey(keys))
			{
				if (this.ContainsKey("keydrop_enabled"))
				{
					newObj.SetBool("key_drop", this.GetBool("keydrop_enabled", false));
				}

				defString = SF_KEYMODEL;
				if (this.ContainsKey("key_model"))
				{
					this.GetString("key_model", defString, sizeof(defString), defString);
					newObj.SetString("key_model", defString);
				}

				defString = "";
				if (this.ContainsKey("key_trigger"))
				{
					this.GetString("key_trigger", defString, sizeof(defString), defString);
					newObj.SetString("key_trigger", defString);
				}
			}
		}

		keys.Clear();
		keys.PushString("chase_upon_look");
		keys.PushString("auto_chase_upon_look");
		if (this.ContainsAnyDifficultyKey(keys))
		{
			newObj = this.GetChaseOnLookData();
			if (newObj == null)
			{
				newObj = this.InsertNewSection("chase_on_look");

				for (int i = 0; i < Difficulty_Max; i++)
				{
					bool def = false;
					def = this.GetDifficultyBool("chase_upon_look", i, def);
					def = this.GetDifficultyBool("auto_chase_upon_look", i, def);
					newObj.SetDifficultyBool("enabled", i, def);
				}
			}
		}

		keys.Clear();
		keys.PushString("auto_chase_enabled");
		keys.PushString("auto_chase_sound_threshold");
		keys.PushString("auto_chase_cooldown_after_chase");
		keys.PushString("auto_chase_sprinters");
		if (this.ContainsAnyDifficultyKey(keys))
		{
			newObj = this.InsertNewSection("autochase");
			int defInt = 0;

			keys.Clear();
			keys.PushString("auto_chase_sound_add");
			keys.PushString("auto_chase_sound_add_footsteps");
			keys.PushString("auto_chase_sound_add_footsteps_loud");
			keys.PushString("auto_chase_sound_add_footsteps_quiet");
			keys.PushString("auto_chase_sound_add_voice");
			keys.PushString("auto_chase_sound_add_weapon");

			for (int i = 0; i < Difficulty_Max; i++)
			{
				if (this.ContainsDifficultyKey("auto_chase_enabled", i))
				{
					newObj.SetDifficultyBool("enabled", i, this.GetDifficultyBool("auto_chase_enabled", i, false));
				}

				if (this.ContainsDifficultyKey("auto_chase_sound_threshold", i))
				{
					newObj.SetDifficultyInt("threshold", i, this.GetDifficultyInt("auto_chase_sound_threshold", i, 100));
				}

				if (this.ContainsDifficultyKey("auto_chase_cooldown_after_chase", i))
				{
					newObj.SetDifficultyFloat("cooldown_after_chase", i, this.GetDifficultyFloat("auto_chase_cooldown_after_chase", i, 3.0));
				}

				if (this.ContainsDifficultyKey("auto_chase_sprinters", i))
				{
					newObj.SetDifficultyBool("sprinters", i, this.GetDifficultyBool("auto_chase_sprinters", i, false));
				}

				if (this.ContainsAnyDifficultyKey(keys, i))
				{
					temp = newObj.InsertNewSection("add");

					if (this.ContainsDifficultyKey("auto_chase_sound_add", i))
					{
						temp.SetDifficultyInt("on_state_change", i, this.GetDifficultyInt("auto_chase_sound_add", i, 0));
					}

					if (this.ContainsDifficultyKey("auto_chase_sound_add_footsteps", i))
					{
						temp.SetDifficultyInt("footsteps", i, this.GetDifficultyInt("auto_chase_sound_add_footsteps", i, 2));
					}

					defInt = temp.GetDifficultyInt("footsteps", i);
					if (this.ContainsDifficultyKey("auto_chase_sound_add_footsteps_loud", i))
					{
						defInt = this.GetDifficultyInt("auto_chase_sound_add_footsteps_loud", i, defInt);
						temp.SetDifficultyInt("footsteps_loud", i, defInt);
					}

					defInt = temp.GetDifficultyInt("footsteps", i);
					if (this.ContainsDifficultyKey("auto_chase_sound_add_footsteps_quiet", i))
					{
						defInt = this.GetDifficultyInt("auto_chase_sound_add_footsteps_quiet", i, defInt);
						temp.SetDifficultyInt("footsteps_quiet", i, defInt);
					}

					if (this.ContainsDifficultyKey("auto_chase_sound_add_voice", i))
					{
						temp.SetDifficultyInt("voice", i, this.GetDifficultyInt("auto_chase_sound_add_voice", i, 8));
					}

					if (this.ContainsDifficultyKey("auto_chase_sound_add_weapon", i))
					{
						temp.SetDifficultyInt("weapon", i, this.GetDifficultyInt("auto_chase_sound_add_weapon", i, 8));
					}
				}
			}
		}

		if (this.GetBool("cloak_enable", false))
		{
			newObj = this.InsertNewSection("cloaking");

			float multipliers[Difficulty_Max] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
			bool addPosture = false;
			for (int i = 0; i < Difficulty_Max; i++)
			{
				newObj.SetDifficultyBool("enabled", i, true);
				if (this.ContainsDifficultyKey("cloak_cooldown", i))
				{
					newObj.SetDifficultyFloat("cooldown", i, this.GetDifficultyFloat("cloak_cooldown", i, 10.0));
				}
				if (this.ContainsDifficultyKey("cloak_range", i))
				{
					newObj.SetDifficultyFloat("cloak_range", i, this.GetDifficultyFloat("cloak_range", i, 350.0));
				}
				if (this.ContainsDifficultyKey("cloak_decloak_range", i))
				{
					newObj.SetDifficultyFloat("decloak_range", i, this.GetDifficultyFloat("cloak_decloak_range", i, 150.0));
				}
				if (this.ContainsDifficultyKey("cloak_decloak_range", i))
				{
					newObj.SetDifficultyFloat("duration", i, this.GetDifficultyFloat("cloak_duration", i, 8.0));
				}
				multipliers[i] = this.GetDifficultyFloat("cloak_speed_multiplier", i, multipliers[i]);
				if (multipliers[i] != 1.0)
				{
					addPosture = true;
				}
			}

			int color[4];
			if (this.ContainsKey("cloak_rendercolor"))
			{
				this.GetColor("cloak_rendercolor", color, { 0, 0, 0, 0 });
				newObj.SetColor("color", color);
			}

			if (this.ContainsKey("cloak_rendermode"))
			{
				newObj.SetInt("rendermode", this.GetInt("cloak_rendermode", view_as<int>(RENDER_TRANSCOLOR)));
			}

			char particle[128], sound[PLATFORM_MAX_PATH];
			temp = newObj.InsertNewSection("effects");
			ProfileEffectMaster effectSection = view_as<ProfileEffectMaster>(temp.InsertNewSection("cloak"));

			this.GetString("cloak_particle", particle, sizeof(particle), "drg_cow_explosioncore_charged_blue");
			this.GetString("cloak_on_sound", sound, sizeof(sound), "weapons/medi_shield_deploy.wav");
			ProfileEffect effect = view_as<ProfileEffect>(effectSection.InsertNewSection("Legacy Cloak Particle"));
			effect.SetString("type", "particle");
			effect.SetFloat("lifetime", 0.1);
			effect.SetVector("origin", { 0.0, 0.0, 35.0 });
			effect.SetString("particlename", particle);

			effect = view_as<ProfileEffect>(effectSection.InsertNewSection("Legacy Cloak Sound"));
			effect.SetString("type", "sound");
			temp = effect.InsertNewSection("paths");
			temp.SetString("1", sound);

			this.GetString("cloak_off_sound", sound, sizeof(sound), "weapons/medi_shield_retract.wav");
			temp = newObj.GetSection("effects");
			effectSection = view_as<ProfileEffectMaster>(temp.InsertNewSection("decloak"));

			effect = view_as<ProfileEffect>(effectSection.InsertNewSection("Legacy Cloak Particle"));
			effect.SetString("type", "particle");
			effect.SetFloat("lifetime", 0.1);
			effect.SetVector("origin", { 0.0, 0.0, 35.0 });
			effect.SetString("particlename", particle);

			effect = view_as<ProfileEffect>(effectSection.InsertNewSection("Legacy Cloak Sound"));
			effect.SetString("type", "sound");
			temp = effect.InsertNewSection("paths");
			temp.SetString("1", sound);

			if (addPosture)
			{
				temp = this.InsertNewSection("postures");
				temp2 = temp.InsertNewSection("Legacy Cloak");

				for (int i = 0; i < Difficulty_Max; i++)
				{
					temp2.SetDifficultyFloat("speed", i, this.GetRunSpeed(i) * multipliers[i]);
					temp2.SetDifficultyFloat("walkspeed", i, this.GetWalkSpeed(i) * multipliers[i]);
					temp2.SetDifficultyFloat("acceleration", i, this.GetAcceleration(i) * multipliers[i]);
				}

				temp = temp2.InsertNewSection("conditions");
				temp2 = temp.InsertNewSection("on_cloak");

				for (int i = 0; i < Difficulty_Max; i++)
				{
					temp2.SetDifficultyBool("enabled", i, true);
				}
			}
		}

		if (this.GetSection("attacks") != null)
		{
			if (this.GetAttackSounds() != null)
			{
				ProfileObject obj = this.GetAttackSounds().GetSection("paths");
				if (obj != null)
				{
					for (int i = 0; i < this.GetAttackCount(); i++)
					{
						ChaserBossProfileBaseAttack attack = this.GetAttackFromIndex(i);
					}
				}
				else
				{
					if (this.GetAttackSounds().SectionLength > 0)
					{

					}
					else
					{

					}
				}
			}
		}

		if (this.GetProjectiles() != null)
		{
			this.GetProjectiles().Precache();
		}

		if (this.GetIdleSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetIdleSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetIdleSounds().Precache();
		}

		if (this.GetAlertSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetAlertSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetAlertSounds().Precache();
		}

		if (this.GetChasingSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetChasingSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetChasingSounds().Precache();
		}

		if (this.GetChaseInitialSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetChaseInitialSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetChaseInitialSounds().Precache();
		}

		if (this.GetStunSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetStunSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetStunSounds().Precache();
		}

		if (this.GetHurtSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetHurtSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetHurtSounds().Precache();
		}

		if (this.GetDeathSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetDeathSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetDeathSounds().Precache();
		}

		if (this.GetTauntKillSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetTauntKillSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetTauntKillSounds().Precache();
		}

		if (this.GetAttackKilledSounds() != null)
		{
			this.GetAttackKilledSounds().Precache();
		}

		if (this.GetAttackKilledAllSounds() != null)
		{
			this.GetAttackKilledAllSounds().Precache();
		}

		if (this.GetAttackKilledClientSounds() != null)
		{
			this.GetAttackKilledClientSounds().Precache();
		}

		if (this.GetSmellSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetSmellSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetSmellSounds().Precache();
		}

		if (this.GetSelfHealSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetSelfHealSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetSelfHealSounds().Precache();
		}

		if (this.GetRageAllSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetRageAllSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetRageAllSounds().Precache();
		}

		if (this.GetRageTwoSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetRageTwoSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetRageTwoSounds().Precache();
		}

		if (this.GetRageThreeSounds() != null)
		{
			if (this.NormalSoundHook)
			{
				this.GetRageThreeSounds().SetDefaultChannel(SNDCHAN_VOICE);
			}
			this.GetRageThreeSounds().Precache();
		}

		if (this.GetDespawnSounds() != null)
		{
			this.GetDespawnSounds().Precache();
		}

		if (this.GetFootstepSounds() != null)
		{
			this.GetFootstepSounds().Precache();
		}

		if (this.GetIdleMusics() != null)
		{
			this.GetIdleMusics().Precache();
		}

		if (this.GetAlertMusics() != null)
		{
			this.GetAlertMusics().Precache();
		}

		if (this.GetChaseMusics() != null)
		{
			this.GetChaseMusics().Precache();
		}

		if (this.GetVisibleIdleMusics() != null)
		{
			this.GetVisibleIdleMusics().Precache();
		}

		if (this.GetVisibleAlertMusics() != null)
		{
			this.GetVisibleAlertMusics().Precache();
		}

		if (this.GetVisibleChaseMusics() != null)
		{
			this.GetVisibleChaseMusics().Precache();
		}

		if (this.GetCloakData() != null)
		{
			this.GetCloakData().Precache();
		}

		if (this.GetStunBehavior() != null)
		{
			this.GetStunBehavior().Precache();
		}

		if (this.GetDeathBehavior() != null)
		{
			this.GetDeathBehavior().Precache();
		}

		this.PrecacheAttackSounds(this.GetAttackSounds(), "attack", this.NormalSoundHook);

		this.PrecacheAttackSounds(this.GetHitSounds(), "hitenemy", false);

		this.PrecacheAttackSounds(this.GetMissSounds(), "missenemy", false);

		this.PrecacheAttackSounds(this.GetAttackBeginSounds(), "attack_begin", this.NormalSoundHook);

		this.PrecacheAttackSounds(this.GetAttackLoopSounds(), "attack_loop", false);

		this.PrecacheAttackSounds(this.GetAttackEndSounds(), "attack_end", this.NormalSoundHook);

		this.PrecacheAttackSounds(this.GetBulletShootSounds(), "bulletshoot", false);

		this.PrecacheAttackSounds(this.GetProjectileShootSounds(), "attackshootprojectile", false);

		ProfileObject obj = this.GetSection("attacks");
		if (obj != null)
		{
			KeyMap_Array attackNames = new KeyMap_Array(Key_Type_Value);
			this.SetSection("__chaser_attack_names", attackNames);
			this.SetType("__chaser_attack_names", Key_Type_Section);
			attackNames.Parent = this;

			for (int i = 0; i < obj.SectionLength; i++)
			{
				char name[64];
				obj.GetSectionNameFromIndex(i, name, sizeof(name));

				ChaserBossProfileBaseAttack attack = view_as<ChaserBossProfileBaseAttack>(obj.GetSection(name));
				if (attack != null)
				{
					attackNames.PushString(name);
					attack.Precache();
				}
			}
		}

		if (this.OldAnimationAI && this.GetAnimations() != null && !this.GetAnimations().IsLegacy)
		{
			for (int i = 0; i < this.GetAnimations().SectionLength; i++)
			{
				char key[64];
				this.GetAnimations().GetSectionNameFromIndex(i, key, sizeof(key));
				obj = this.GetAnimations().GetSection(key);
				if (obj != null && strcmp(key, g_SlenderAnimationsList[SF2BossAnimation_Walk]) == 0 || strcmp(key, g_SlenderAnimationsList[SF2BossAnimation_Run]) == 0)
				{
					for (int i2 = 0; i2 < obj.SectionLength; i2++)
					{
						obj.GetSectionNameFromIndex(i2, key, sizeof(key));
						ProfileAnimation animObj = view_as<ProfileAnimation>(obj.GetSection(key));
						if (animObj != null)
						{
							for (int i3 = 0; i3 < Difficulty_Max; i3++)
							{
								animObj.SetDifficultyBool("ground_sync", i3, true);
							}
						}
					}
				}
			}
		}
	}

	public void PrecacheAttackSounds(ProfileObject base, char[] section, bool hook = false)
	{
		if (base == null)
		{
			return;
		}

		if (hook)
		{
			view_as<ProfileSound>(base).SetDefaultChannel(SNDCHAN_VOICE);
		}

		bool sections = false;
		if (base.GetSection("paths") != null)
		{
			view_as<ProfileSound>(base).Precache();
		}
		else
		{
			for (int i = 0; i < base.SectionLength; i++)
			{
				char key[64];
				base.GetSectionNameFromIndex(i, key, sizeof(key));
				if (base.GetSection(key) != null)
				{
					sections = true;
					break;
				}
			}

			if (!sections)
			{
				view_as<ProfileSound>(base).Precache();
			}
			else
			{
				char formatter[64];
				FormatEx(formatter, sizeof(formatter), "__chaser_%s_sounds", section);
				KeyMap_Array sounds = new KeyMap_Array(Key_Type_Value);
				this.SetSection(formatter, sounds);
				this.SetType(formatter, Key_Type_Section);
				sounds.Parent = this;

				for (int i = 0; i < base.SectionLength; i++)
				{
					char key[64];
					base.GetSectionNameFromIndex(i, key, sizeof(key));
					ProfileObject obj = base.GetSection(key);
					if (obj != null)
					{
						sounds.PushString(key);
						if (hook)
						{
							view_as<ProfileSound>(obj).SetDefaultChannel(SNDCHAN_VOICE);
						}
						view_as<ProfileSound>(obj).Precache();
					}
				}
			}
		}
	}
}

methodmap ChaserBossProfileIdleData < ProfileObject
{
	public bool IsTurnEnabled(int difficulty)
	{
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return true;
		}

		return obj.GetDifficultyBool("enabled", difficulty, true);
	}

	public float GetTurnAngle(int difficulty)
	{
		float def = 360.0;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("angle", difficulty, def);
	}

	public float GetTurnMinCooldown(int difficulty)
	{
		float def = 1.5;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("cooldown_min", difficulty, def);
	}

	public float GetTurnMaxCooldown(int difficulty)
	{
		float def = 3.0;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("cooldown_max", difficulty, def);
	}
}

methodmap ChaserBossProfileAlertData < ProfileObject
{
	public float GetGraceTime(int difficulty)
	{
		return this.GetDifficultyFloat("gracetime", difficulty, 0.5);
	}

	public float GetDuration(int difficulty)
	{
		return this.GetDifficultyFloat("duration", difficulty, 10.0);
	}

	public bool ShouldRunOnWander(int difficulty)
	{
		return this.GetDifficultyBool("run_on_wander", difficulty, false);
	}

	public bool ShouldRunOnSuspect(int difficulty)
	{
		return this.GetDifficultyBool("run_on_suspect", difficulty, false);
	}

	public bool IsTurnEnabled(int difficulty)
	{
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return true;
		}

		return obj.GetDifficultyBool("enabled", difficulty, true);
	}

	public float GetTurnAngle(int difficulty)
	{
		float def = 360.0;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("angle", difficulty, def);
	}

	public float GetTurnMinCooldown(int difficulty)
	{
		float def = 1.5;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("cooldown_min", difficulty, def);
	}

	public float GetTurnMaxCooldown(int difficulty)
	{
		float def = 3.0;
		ProfileObject obj = this.GetSection("turn");
		if (obj == null)
		{
			return def;
		}

		return obj.GetDifficultyFloat("cooldown_max", difficulty, def);
	}

	public ChaserBossAlertOnStateData GetAlertSyncData()
	{
		return view_as<ChaserBossAlertOnStateData>(this.GetSection("sync"));
	}
}

methodmap ChaserBossProfileChaseData < ProfileObject
{
	public float GetMaxChaseDuration(int difficulty)
	{
		float def = 10.0;
		ProfileObject obj = this.GetSection("duration");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("max", difficulty, def);
		}
		return def;
	}

	public float GetDurationTargetRange(int difficulty)
	{
		float def = 1024.0;
		if (this == null)
		{
			return def;
		}
		def = view_as<ChaserBossProfile>(this.Parent).GetSearchRange(difficulty);
		ProfileObject obj = this.GetSection("duration");
		obj = obj != null ? obj.GetSection("add") : null;
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("target_range", difficulty, def);
		}
		return def;
	}

	public float GetDurationAddVisibleTargetNear(int difficulty)
	{
		float def = 0.01;
		ProfileObject obj = this.GetSection("duration");
		obj = obj != null ? obj.GetSection("add") : null;
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("visible_target_near", difficulty, def);
		}
		return def;
	}

	public float GetDurationAddVisibleTargetFar(int difficulty)
	{
		float def = 0.05;
		ProfileObject obj = this.GetSection("duration");
		obj = obj != null ? obj.GetSection("add") : null;
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("visible_target_far", difficulty, def);
		}
		return def;
	}

	public float GetDurationAddOnAttack(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("duration");
		obj = obj != null ? obj.GetSection("add") : null;
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("attack", difficulty, def);
		}
		return def;
	}

	public float GetDurationAddOnStunned(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("duration");
		obj = obj != null ? obj.GetSection("add") : null;
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("stunned", difficulty, def);
		}
		return def;
	}

	public ChaserBossAlertOnStateData GetChaseTogetherData()
	{
		return view_as<ChaserBossAlertOnStateData>(this.GetSection("chase_together"));
	}
}

methodmap ChaserBossProfileStunData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyBool("enabled", difficulty, def);
	}

	public float GetHealth(int difficulty)
	{
		float def = 50.0;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("health", difficulty, def);
	}

	public float GetCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown", difficulty, 3.5);
	}

	public bool ShouldDisappear(int difficulty)
	{
		return this.GetDifficultyBool("disappear", difficulty, false);
	}

	public bool CanFlashlightStun(int difficulty)
	{
		bool def = false;
		ProfileObject obj = this.GetSection("flashlight_stun");
		if (obj != null)
		{
			def = obj.GetDifficultyBool("enabled", difficulty, def);
		}
		return def;
	}

	public float GetFlashlightDamage(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("flashlight_stun");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("damage", difficulty, def);
		}
		return def;
	}

	public bool CanChaseInitialOnEnd(int difficulty)
	{
		return this.GetDifficultyBool("chase_initial_on_end", difficulty, false);
	}

	property bool KeyDrop
	{
		public get()
		{
			return this.GetBool("key_drop", false);
		}
	}

	public void GetKeyModel(char[] buffer, int bufferSize)
	{
		this.GetString("key_model", buffer, bufferSize, SF_KEYMODEL);
	}

	public void GetKeyTrigger(char[] buffer, int bufferSize)
	{
		this.GetString("key_trigger", buffer, bufferSize);
	}

	public bool CanDropItem(int difficulty)
	{
		return this.GetDifficultyBool("item_drop", difficulty, false);
	}

	public int GetItemDropType(int difficulty)
	{
		return this.GetDifficultyInt("item_drop_type", difficulty, 1);
	}

	public float GetAddHealthPerClass(int difficulty, TFClassType class)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			switch (class)
			{
				case TFClass_Scout:
				{
					def = obj.GetDifficultyFloat("scout", difficulty, def);
				}

				case TFClass_Soldier:
				{
					def = obj.GetDifficultyFloat("soldier", difficulty, def);
				}

				case TFClass_Pyro:
				{
					def = obj.GetDifficultyFloat("pyro", difficulty, def);
				}

				case TFClass_DemoMan:
				{
					def = obj.GetDifficultyFloat("demoman", difficulty, def);
				}

				case TFClass_Heavy:
				{
					def = obj.GetDifficultyFloat("heavy", difficulty, def);
				}

				case TFClass_Engineer:
				{
					def = obj.GetDifficultyFloat("engineer", difficulty, def);
				}

				case TFClass_Medic:
				{
					def = obj.GetDifficultyFloat("medic", difficulty, def);
				}

				case TFClass_Sniper:
				{
					def = obj.GetDifficultyFloat("sniper", difficulty, def);
				}

				case TFClass_Spy:
				{
					def = obj.GetDifficultyFloat("spy", difficulty, def);
				}
			}
		}
		return def;
	}

	public float GetAddHealthPerPlayer(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("player", difficulty, def);
		}
		return def;
	}

	public float GetAddHealthPerStun(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("on_stun", difficulty, def);
		}
		return def;
	}

	public float GetAddRunSpeed(int difficulty)
	{
		return this.GetDifficultyFloat("add_speed", difficulty, 0.0);
	}

	public float GetAddAcceleration(int difficulty)
	{
		return this.GetDifficultyFloat("add_acceleration", difficulty, 0.0);
	}

	public ProfileEffectMaster GetOnStartEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("on_start") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileEffectMaster GetOnEndEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("on_end") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public void Precache()
	{
		if (this.GetOnStartEffects() != null)
		{
			this.GetOnStartEffects().Precache();
		}

		if (this.GetOnEndEffects() != null)
		{
			this.GetOnEndEffects().Precache();
		}
	}
}

methodmap ChaserBossProfileDeathData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyBool("enabled", difficulty, def);
	}

	public float GetHealth(int difficulty)
	{
		float def = 400.0;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("health", difficulty, def);
	}

	property bool RemoveOnDeath
	{
		public get()
		{
			return this.GetBool("remove", false);
		}
	}

	property bool DisappearOnDeath
	{
		public get()
		{
			return this.GetBool("disappear", false);
		}
	}

	property bool RagdollOnDeath
	{
		public get()
		{
			return this.GetBool("become_ragdoll", false);
		}
	}

	property bool KeyDrop
	{
		public get()
		{
			return this.GetBool("key_drop", false);
		}
	}

	public void GetKeyModel(char[] buffer, int bufferSize)
	{
		this.GetString("key_model", buffer, bufferSize, SF_KEYMODEL);
	}

	public void GetKeyTrigger(char[] buffer, int bufferSize)
	{
		this.GetString("key_trigger", buffer, bufferSize);
	}

	public bool CanDropItem(int difficulty)
	{
		return this.GetDifficultyBool("item_drop", difficulty, false);
	}

	public int GetItemDropType(int difficulty)
	{
		return this.GetDifficultyInt("item_drop_type", difficulty, 1);
	}

	public float GetAddHealthPerClass(int difficulty, TFClassType class)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			switch (class)
			{
				case TFClass_Scout:
				{
					def = obj.GetDifficultyFloat("scout", difficulty, def);
				}

				case TFClass_Soldier:
				{
					def = obj.GetDifficultyFloat("soldier", difficulty, def);
				}

				case TFClass_Pyro:
				{
					def = obj.GetDifficultyFloat("pyro", difficulty, def);
				}

				case TFClass_DemoMan:
				{
					def = obj.GetDifficultyFloat("demoman", difficulty, def);
				}

				case TFClass_Heavy:
				{
					def = obj.GetDifficultyFloat("heavy", difficulty, def);
				}

				case TFClass_Engineer:
				{
					def = obj.GetDifficultyFloat("engineer", difficulty, def);
				}

				case TFClass_Medic:
				{
					def = obj.GetDifficultyFloat("medic", difficulty, def);
				}

				case TFClass_Sniper:
				{
					def = obj.GetDifficultyFloat("sniper", difficulty, def);
				}

				case TFClass_Spy:
				{
					def = obj.GetDifficultyFloat("spy", difficulty, def);
				}
			}
		}
		return def;
	}

	public float GetAddHealthPerPlayer(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("player", difficulty, def);
		}
		return def;
	}

	public float GetAddHealthPerDeath(int difficulty)
	{
		float def = 0.0;
		ProfileObject obj = this.GetSection("add_health");
		if (obj != null)
		{
			def = obj.GetDifficultyFloat("on_death", difficulty, def);
		}
		return def;
	}

	public float GetAddRunSpeed(int difficulty)
	{
		return this.GetDifficultyFloat("add_speed", difficulty, 0.0);
	}

	public float GetAddAcceleration(int difficulty)
	{
		return this.GetDifficultyFloat("add_acceleration", difficulty, 0.0);
	}

	property int GibSkin
	{
		public get()
		{
			int def = 0;
			ProfileObject obj = this.GetGibs();
			if (obj != null)
			{
				obj.GetInt("skin", def);
			}
			return def;
		}
	}

	public ProfileObject GetGibs()
	{
		return this.GetSection("gibs");
	}

	public ProfileEffectMaster GetOnStartEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("on_start") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileEffectMaster GetOnEndEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("on_end") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public void Precache()
	{
		if (this.GetOnStartEffects() != null)
		{
			this.GetOnStartEffects().Precache();
		}

		if (this.GetOnEndEffects() != null)
		{
			this.GetOnEndEffects().Precache();
		}
	}
}

methodmap ChaserBossProfileRageData < ProfileObject
{
	property float PercentageThreshold
	{
		public get()
		{
			return this.GetFloat("health_percent", 0.75);
		}
	}

	property bool IncreaseDifficulty
	{
		public get()
		{
			return this.GetBool("increase_difficulty", true);
		}
	}

	property bool Invincible
	{
		public get()
		{
			return this.GetBool("invincible", false);
		}
	}

	property bool IsHealing
	{
		public get()
		{
			return this.GetSection("heal") != null;
		}
	}

	property bool HealCloak
	{
		public get()
		{
			bool def = false;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetBool("cloak", def);
			}
			return def;
		}
	}

	property float FleeMinRange
	{
		public get()
		{
			float def = 512.0;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetFloat("flee_range_min", def);
			}
			return def;
		}
	}

	property float FleeMaxRange
	{
		public get()
		{
			float def = 1024.0;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetFloat("flee_range_max", def);
			}
			return def;
		}
	}

	property float HealAmount
	{
		public get()
		{
			float def = 0.5;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetFloat("amount", def);
			}
			return def;
		}
	}

	property float HealDelay
	{
		public get()
		{
			float def = 0.0;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetFloat("delay", def);
			}
			return def;
		}
	}

	property float HealDuration
	{
		public get()
		{
			float def = 1.0;
			ProfileObject obj = this.GetSection("heal");
			if (obj != null)
			{
				def = obj.GetFloat("duration", def);
			}
			return def;
		}
	}

	public ProfileSound GetStartSounds()
	{
		ProfileSound def = null;
		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			def = view_as<ProfileSound>(obj.GetSection("start"));
		}
		return def;
	}

	public ProfileSound GetHealSounds()
	{
		ProfileSound def = null;
		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			def = view_as<ProfileSound>(obj.GetSection("healing"));
		}
		return def;
	}

	public ProfileMasterAnimations GetAnimations()
	{
		return view_as<ProfileMasterAnimations>(this.GetSection("animations"));
	}

	public void Precache()
	{

	}
}

methodmap ChaserBossProfileCloakData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", false);
	}

	public float GetDuration(int difficulty)
	{
		return this.GetDifficultyFloat("duration", difficulty, 8.0);
	}

	public float GetCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown", difficulty, 10.0);
	}

	public float GetCloakRange(int difficulty)
	{
		return this.GetDifficultyFloat("cloak_range", difficulty, 350.0);
	}

	public float GetDecloakRange(int difficulty)
	{
		return this.GetDifficultyFloat("decloak_range", difficulty, 150.0);
	}

	public void GetRenderColor(int buffer[4])
	{
		this.GetColor("color", buffer, { 0, 0, 0, 0 });
	}

	public RenderMode GetRenderMode(int difficulty)
	{
		return view_as<RenderMode>(this.GetDifficultyInt("rendermode", difficulty, view_as<int>(RENDER_TRANSCOLOR)));
	}

	public RenderFx GetRenderFx(int difficulty)
	{
		return view_as<RenderFx>(this.GetDifficultyInt("renderfx", difficulty, view_as<int>(RENDERFX_NONE)));
	}

	public ProfileEffectMaster GetCloakEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("cloak") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public ProfileEffectMaster GetDecloakEffects()
	{
		ProfileObject obj = this.GetSection("effects");
		obj = obj != null ? obj.GetSection("decloak") : null;
		if (obj != null)
		{
			return view_as<ProfileEffectMaster>(obj);
		}

		return null;
	}

	public void Precache()
	{
		if (this.GetCloakEffects() != null)
		{
			this.GetCloakEffects().Precache();
		}

		if (this.GetDecloakEffects() != null)
		{
			this.GetDecloakEffects().Precache();
		}
	}
}

methodmap ChaserBossProfileSmellData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", false);
	}

	public float GetMinCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown_min", difficulty, 6.0);
	}

	public float GetMaxCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown_max", difficulty, 12.0);
	}

	public float GetMinCooldownAfterState(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown_after_state_min", difficulty, 16.0);
	}

	public float GetMaxCooldownAfterState(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown_after_state_min", difficulty, 24.0);
	}

	public int GetRequiredPlayers(int difficulty)
	{
		return this.GetDifficultyInt("required_players", difficulty, 1);
	}

	public float GetRequiredPlayerRange(int difficulty)
	{
		return this.GetDifficultyFloat("required_player_range", difficulty, 1000.0);
	}

	public float GetSmellRange(int difficulty)
	{
		return this.GetDifficultyFloat("smelling_range", difficulty, 1500.0);
	}

	public bool GetShouldChaseState(int difficulty)
	{
		return this.GetDifficultyBool("should_chase_upon_smelled", false);
	}
}

methodmap ChaserBossSoundSenseData < ProfileObject
{
	public int GetThreshold(int difficulty)
	{
		int def = 8;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyInt("threshold", difficulty, def);
	}

	public float GetDiscardTime(int difficulty)
	{
		float def = 2.0;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("discard_time", difficulty, def);
	}

	public float GetDistanceTolerance(int difficulty)
	{
		float def = 512.0;
		if (this == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("distance_tolerance", difficulty, def);
	}

	public float GetFootstepCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("footstep", difficulty, def);
	}

	public float GetLoudFootstepCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("footstep_loud", difficulty, def);
	}

	public float GetQuietFootstepCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("footstep_quiet", difficulty, def);
	}

	public float GetVoiceCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("voice", difficulty, def);
	}

	public float GetWeaponCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("weapon", difficulty, def);
	}

	public float GetFlashlightCooldown(int difficulty)
	{
		float def = 0.0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("cooldown");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyFloat("flashlight", difficulty, def);
	}

	public int GetFootstepAdd(int difficulty)
	{
		int def = 1;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("footstep", difficulty, def);
	}

	public int GetLoudFootstepAdd(int difficulty)
	{
		int def = 2;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("footstep_loud", difficulty, def);
	}

	public int GetQuietFootstepAdd(int difficulty)
	{
		int def = 0;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("footstep_quiet", difficulty, def);
	}

	public int GetVoiceAdd(int difficulty)
	{
		int def = 10;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("voice", difficulty, def);
	}

	public int GetWeaponAdd(int difficulty)
	{
		int def = 5;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("weapon", difficulty, def);
	}

	public int GetFlashlightAdd(int difficulty)
	{
		int def = 5;
		if (this == null)
		{
			return def;
		}
		ProfileObject obj = this.GetSection("add");
		if (obj == null)
		{
			return def;
		}
		return this.GetDifficultyInt("flashlight", difficulty, def);
	}
}

methodmap ChaserBossPostureCondition < ProfileObject
{
	public bool GetEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}
}

methodmap ChaserBossChaseOnLookData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, false);
	}

	public bool ShouldAddTargets(int difficulty)
	{
		return this.GetDifficultyBool("add_targets", difficulty, true);
	}

	public void GetRequiredLookPosition(float buffer[3])
	{
		this.GetVector("look_position", buffer, { 0.0, 0.0, 35.0 });
	}

	public float GetMinXAngle(int difficulty)
	{
		return this.GetDifficultyFloat("minimum_x_angle", difficulty, -45.0);
	}

	public float GetMaxXAngle(int difficulty)
	{
		return this.GetDifficultyFloat("maximum_x_angle", difficulty, 180.0);
	}

	public float GetMinYAngle(int difficulty)
	{
		return this.GetDifficultyFloat("minimum_y_angle", difficulty, 0.0);
	}

	public float GetMaxYAngle(int difficulty)
	{
		return this.GetDifficultyFloat("maximum_y_angle", difficulty, 105.0);
	}

	public float GetRequiredFOV(int difficulty)
	{
		return this.GetDifficultyFloat("required_fov", difficulty, -1.0);
	}
}

methodmap ChaserBossAutoChaseData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		return this.GetDifficultyBool("enabled", difficulty, false);
	}

	public int GetThreshold(int difficulty)
	{
		return this.GetDifficultyInt("threshold", difficulty, 100);
	}

	public float GetCooldownAfterChase(int difficulty)
	{
		return this.GetDifficultyFloat("cooldown_after_chase", difficulty, 3.0);
	}

	public bool ShouldChaseSprinters(int difficulty)
	{
		return this.GetDifficultyBool("sprinters", difficulty, false);
	}

	public int GetAddOnStateChange(int difficulty)
	{
		int def = 0;
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("on_state_change", difficulty, def);
		}
		return def;
	}

	public int GetAddFootsteps(int difficulty)
	{
		int def = 2;
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("footsteps", difficulty, def);
		}
		return def;
	}

	public int GetAddLoudFootsteps(int difficulty)
	{
		int def = this.GetAddFootsteps(difficulty);
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("footsteps_loud", difficulty, def);
		}
		return def;
	}

	public int GetAddQuietFootsteps(int difficulty)
	{
		int def = this.GetAddFootsteps(difficulty);
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("footsteps_quiet", difficulty, def);
		}
		return def;
	}

	public int GetAddVoice(int difficulty)
	{
		int def = 8;
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("voice", difficulty, def);
		}
		return def;
	}

	public int GetAddWeapon(int difficulty)
	{
		int def = 8;
		ProfileObject obj = this.GetSection("add");
		if (obj != null)
		{
			def = obj.GetDifficultyInt("weapon", difficulty, def);
		}
		return def;
	}
}

methodmap ChaserBossAlertOnStateData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}

		return this.GetDifficultyBool("enabled", difficulty, false);
	}

	public bool ShouldStartOnStateChange(int difficulty)
	{
		bool def = true;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyBool("on_change_state", difficulty, true);
	}

	public float GetRadius(int difficulty)
	{
		float def = 1024.0;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyFloat("radius", difficulty, def);
	}

	public bool ShouldBeVisible(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyBool("should_be_visible", difficulty, def);
	}

	public bool ShouldFollow(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyBool("follow_leader", difficulty, def);
	}

	public float GetFollowCooldown(int difficulty)
	{
		float def = 10.0;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyFloat("follow_cooldown", difficulty, def);
	}

	public bool GetCopies(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyBool("copies", difficulty, def);
	}

	public bool GetCompanions(int difficulty)
	{
		bool def = false;
		if (this == null)
		{
			return def;
		}

		return this.GetDifficultyBool("companions", difficulty, def);
	}
}

methodmap ChaserBossResistanceData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public float GetMultiplier(int difficulty)
	{
		return this.GetDifficultyFloat("multiplier", difficulty, 1.0);
	}

	public ProfileObject GetDamageTypes()
	{
		return this.GetSection("damage_type");
	}

	public ProfileObject GetHitboxes()
	{
		return this.GetSection("hitbox");
	}

	public ProfileObject GetWeapons()
	{
		return this.GetSection("weapon");
	}
}

methodmap ChaserBossProjectileData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		return this.GetDifficultyBool("projectile_enable", difficulty, false);
	}

	public float GetMinCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_cooldown_min", difficulty, 1.0);
	}

	public float GetMaxCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_cooldown_max", difficulty, 2.0);
	}

	public float GetSpeed(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_speed", difficulty, 1100.0);
	}

	public float GetDamage(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_damage", difficulty, 50.0);
	}

	public float GetRadius(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_damageradius", difficulty, 128.0);
	}

	public float GetDeviation(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_deviation", difficulty, 0.0);
	}

	public int GetCount(int difficulty)
	{
		return this.GetDifficultyInt("projectile_count", difficulty, 1);
	}

	property int Type
	{
		public get()
		{
			return this.GetInt("projectile_type", SF2BossProjectileType_Fireball);
		}
	}

	public bool GetCritState(int difficulty)
	{
		return this.GetDifficultyBool("enable_crit_rockets", difficulty, false);
	}

	public void GetShootGesture(char[] buffer, int bufferSize)
	{
		this.GetString("gesture_shootprojectile", buffer, bufferSize);
	}

	property bool ProjectileClips
	{
		public get()
		{
			return this.GetBool("projectile_clips_enable", false);
		}
	}

	public int GetClipSize(int difficulty)
	{
		return this.GetDifficultyInt("projectile_ammo_loaded", difficulty, 3);
	}

	public float GetReloadTime(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_reload_time", difficulty, 2.0);
	}

	property int MinRandomPos
	{
		public get()
		{
			return this.GetInt("projectile_pos_number_min", 1);
		}
	}

	property int MaxRandomPos
	{
		public get()
		{
			return this.GetInt("projectile_pos_number_max", 1);
		}
	}

	public void GetOffset(int index, float buffer[3])
	{
		if (index == 1)
		{
			this.GetVector("projectile_pos_offset", buffer, buffer);
			this.GetVector("projectile_pos_offset_1", buffer, buffer);
			return;
		}
		char key[64];
		FormatEx(key, sizeof(key), "projectile_pos_offset_%i", index);
		this.GetVector(key, buffer);
	}

	public void GetFireballExplodeSound(char[] buffer, int bufferSize)
	{
		this.GetString("fire_explode_sound", buffer, bufferSize, FIREBALL_IMPACT);
	}

	public void GetFireballShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("fire_shoot_sound", buffer, bufferSize, FIREBALL_SHOOT);
	}

	public void GetFireballTrail(char[] buffer, int bufferSize)
	{
		this.GetString("fire_trail", buffer, bufferSize, FIREBALL_TRAIL);
	}

	public void GetRocketTrail(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_trail_particle", buffer, bufferSize, ROCKET_TRAIL);
	}

	public void GetRocketExplodeParticle(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_explode_particle", buffer, bufferSize, ROCKET_EXPLODE_PARTICLE);
	}

	public void GetRocketExplodeSound(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_explode_sound", buffer, bufferSize, ROCKET_IMPACT);
	}

	public void GetRocketShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_shoot_sound", buffer, bufferSize, ROCKET_SHOOT);
	}

	public void GetRocketModel(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_model", buffer, bufferSize, ROCKET_MODEL);
	}

	public float GetIceballSlowDuration(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_iceslow_duration", difficulty, 2.0);
	}

	public float GetIceballSlowPercent(int difficulty)
	{
		return this.GetDifficultyFloat("projectile_iceslow_percent", difficulty, 0.55);
	}

	public void GetIceballSlowSound(char[] buffer, int bufferSize)
	{
		this.GetString("fire_iceball_slow_sound", buffer, bufferSize, ICEBALL_IMPACT);
	}

	public void GetIceballTrail(char[] buffer, int bufferSize)
	{
		this.GetString("fire_iceball_slow_sound", buffer, bufferSize, ICEBALL_TRAIL);
	}

	public void GetGrenadeShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("grenade_shoot_sound", buffer, bufferSize, GRENADE_SHOOT);
	}

	public void GetSentryRocketShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("sentryrocket_shoot_sound", buffer, bufferSize, SENTRYROCKET_SHOOT);
	}

	public void GetArrowShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("arrow_shoot_sound", buffer, bufferSize, ARROW_SHOOT);
	}

	public void GetManglerShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("mangler_shoot_sound", buffer, bufferSize, MANGLER_SHOOT);
	}

	public void GetBaseballShootSound(char[] buffer, int bufferSize)
	{
		this.GetString("baseball_shoot_sound", buffer, bufferSize, BASEBALL_SHOOT);
	}

	public void GetBaseballModel(char[] buffer, int bufferSize)
	{
		this.GetString("baseball_model", buffer, bufferSize, BASEBALL_MODEL);
	}

	public void Precache()
	{
		char path[PLATFORM_MAX_PATH];
		this.GetRocketShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetRocketExplodeSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetFireballShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetFireballExplodeSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetIceballSlowSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetGrenadeShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetSentryRocketShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetArrowShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetManglerShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetBaseballShootSound(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheSound2(path, g_FileCheckConVar.BoolValue);
		}

		this.GetBaseballModel(path, sizeof(path));
		if (path[0] != '\0')
		{
			PrecacheModel2(path, .checkFile = g_FileCheckConVar.BoolValue);
		}
	}
}

int GetProfileAttackNum(const char[] profile, const char[] keyValue, int defaultValue=0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	return g_Config.GetNum(keyValue, defaultValue);
}

float GetProfileAttackFloat(const char[] profile, const char[] keyValue,float defaultValue=0.0, const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return defaultValue;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	return g_Config.GetFloat(keyValue, defaultValue);
}

bool GetProfileAttackString(const char[] profile, const char[] keyValue, char[] buffer, int length, const char[] defaultValue = "", const int attackIndex)
{
	if (!IsProfileValid(profile))
	{
		return false;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	g_Config.GetString(keyValue, buffer, length, defaultValue);
	return true;
}

bool GetProfileAttackVector(const char[] profile, const char[] keyValue, float buffer[3], const float defaultValue[3]=NULL_VECTOR, const int attackIndex)
{
	for (int i = 0; i < 3; i++)
	{
		buffer[i] = defaultValue[i];
	}

	if (!IsProfileValid(profile))
	{
		return false;
	}

	char key[4];
	g_Config.Rewind();
	g_Config.JumpToKey(profile);
	g_Config.JumpToKey("attacks");
	FormatEx(key, sizeof(key), "%d", attackIndex);
	g_Config.JumpToKey(key);
	g_Config.GetVector(keyValue, buffer, defaultValue);
	return true;
}

void ProfileChaser_InititalizeAPI()
{
	CreateNative("SF2_ChaserBossProfile.GetAttackCount", Native_GetAttackCount);
	CreateNative("SF2_ChaserBossProfile.GetAttack", Native_GetAttack);
	CreateNative("SF2_ChaserBossProfile.GetAttackFromIndex", Native_GetAttackFromIndex);
}

static any Native_GetAttackCount(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	return profileData.GetAttackCount();
}

static any Native_GetAttack(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	char attackName[256];
	GetNativeString(2, attackName, sizeof(attackName));

	return profileData.GetAttack(attackName);
}

static any Native_GetAttackFromIndex(Handle plugin, int numParams)
{
	ChaserBossProfile profileData = GetNativeCell(1);
	if (profileData == null || profileData.Type != SF2BossType_Chaser)
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid Chaser boss profile handle %x", profileData);
	}

	int attackIndex = GetNativeCell(2);

	return profileData.GetAttackFromIndex(attackIndex);
}
