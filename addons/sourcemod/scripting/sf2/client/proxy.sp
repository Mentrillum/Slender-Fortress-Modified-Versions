#if defined _sf2_client_proxy_functions_included
 #endinput
#endif
#define _sf2_client_proxy_functions_included

#pragma semicolon 1
#pragma newdecls required

methodmap BossProfileProxyData < ProfileObject
{
	public bool IsEnabled(int difficulty)
	{
		if (this == null)
		{
			return false;
		}
		return this.GetDifficultyBool("enabled", difficulty, true);
	}

	public int GetMaxProxies(int difficulty)
	{
		return this.GetDifficultyInt("__proxies_max", difficulty);
	}

	public void SetMaxProxies(int difficulty, int value)
	{
		this.SetDifficultyInt("__proxies_max", difficulty, value);
	}

	public float GetMinSpawnChance(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_chance_min", difficulty, 0.0);
	}

	public float GetMaxSpawnChance(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_chance_max", difficulty, 0.0);
	}

	public float GetSpawnChanceThreshold(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_chance_threshold", difficulty, 0.25);
	}

	public int GetMinSpawnedProxies(int difficulty)
	{
		return this.GetDifficultyInt("spawn_num_min", difficulty, 0);
	}

	public int GetMaxSpawnedProxies(int difficulty)
	{
		return this.GetDifficultyInt("spawn_num_max", difficulty, 0);
	}

	public float GetMinSpawnCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_cooldown_min", difficulty, 4.0);
	}

	public float GetMaxSpawnCooldown(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_cooldown_max", difficulty, 8.0);
	}

	public float GetMinTeleportRange(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_range_min", difficulty, 500.0);
	}

	public float GetMaxTeleportRange(int difficulty)
	{
		return this.GetDifficultyFloat("spawn_range_max", difficulty, 3200.0);
	}

	public BossProfileProxyClass GetDefaultClassData()
	{
		ProfileObject obj = this.GetSection("classes");
		if (obj == null)
		{
			return null;
		}

		return view_as<BossProfileProxyClass>(obj.GetSection("default"));
	}

	public BossProfileProxyClass GetClassData(TFClassType class)
	{
		ProfileObject obj = this.GetSection("classes");
		if (obj == null)
		{
			return null;
		}

		switch (class)
		{
			case TFClass_Scout:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("scout"));
			}
			case TFClass_Soldier:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("soldier"));
			}
			case TFClass_Pyro:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("pyro"));
			}
			case TFClass_DemoMan:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("demoman"));
			}
			case TFClass_Heavy:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("heavy"));
			}
			case TFClass_Engineer:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("engineer"));
			}
			case TFClass_Medic:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("medic"));
			}
			case TFClass_Sniper:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("sniper"));
			}
			case TFClass_Spy:
			{
				return view_as<BossProfileProxyClass>(obj.GetSection("spy"));
			}
		}

		return null;
	}

	public void Precache()
	{
		BossProfileProxyClass classData = this.GetDefaultClassData();
		if (classData != null)
		{
			classData.Precache();
		}

		for (int i = view_as<int>(TFClass_Scout); i <= view_as<int>(TFClass_Engineer); i++)
		{
			TFClassType class = view_as<TFClassType>(i);
			classData = this.GetClassData(class);
			if (classData != null)
			{
				classData.Precache();
			}

			for (int i2 = 0; i2 < Difficulty_Max; i2++)
			{
				int max = this.GetMaxProxies(i2);
				if (classData.GetMax(i2) >= 0)
				{
					max += classData.GetMax(i2);
					this.SetMaxProxies(i2, max);
				}
			}
		}
	}
}

methodmap BossProfileProxyClass < ProfileObject
{
	public BossProfileProxyClass GetDefaultClassData()
	{
		BossProfileProxyData parent = view_as<BossProfileProxyData>(this.Parent);
		return parent.GetDefaultClassData();
	}

	public void GetModel(int difficulty, char[] buffer, int bufferSize, const char[] defaultValue = "")
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			def.GetModel(difficulty, buffer, bufferSize, defaultValue);
		}

		this.GetDifficultyString("model", difficulty, buffer, bufferSize, buffer);
		ReplaceString(buffer, bufferSize, "\\", "/", false);
	}

	public int GetMax(int difficulty, int defValue = 8)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyInt("max", difficulty, defValue);
		}

		return this.GetDifficultyInt("max", difficulty, defValue);
	}

	public float GetWeight(int difficulty, float defValue = 1.0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("weight", difficulty, defValue);
		}

		return this.GetDifficultyFloat("weight", difficulty, defValue);
	}

	public int GetHealth(int difficulty, int defValue = 0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyInt("health", difficulty, defValue);
		}

		return this.GetDifficultyInt("health", difficulty, defValue);
	}

	public float GetWalkSpeed(int difficulty, float defValue = 150.0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("walkspeed", difficulty, defValue);
		}

		return this.GetDifficultyFloat("walkspeed", difficulty, defValue);
	}

	public float GetRunSpeed(int difficulty, float defValue = 300.0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("runspeed", difficulty, defValue);
		}

		return this.GetDifficultyFloat("runspeed", difficulty, defValue);
	}

	public float GetDamageScale(int difficulty, float defValue = 1.0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("damage_scale", difficulty, defValue);
		}

		return this.GetDifficultyFloat("damage_scale", difficulty, defValue);
	}

	public float GetSelfDamageScale(int difficulty, float defValue = 1.0)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("self_damage_scale", difficulty, defValue);
		}

		return this.GetDifficultyFloat("self_damage_scale", difficulty, defValue);
	}

	public float GetBackstabDamageScale(int difficulty, float defValue = 0.2)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetDifficultyFloat("backstab_damage_scale", difficulty, defValue);
		}

		return this.GetDifficultyFloat("backstab_damage_scale", difficulty, defValue);
	}

	public bool AllowVoices(bool defValue = false)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetBool("allow_voices", defValue);
		}

		return this.GetBool("allow_voices", defValue);
	}

	public bool Zombies(bool defValue = false)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetBool("zombie", defValue);
		}

		return this.GetBool("zombie", defValue);
	}

	public bool Robots(bool defValue = false)
	{
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			defValue = def.GetBool("robot", defValue);
		}

		return this.GetBool("robot", defValue);
	}

	public float GetControlDrainRate(int difficulty, float defValue = 0.0)
	{
		float value = defValue;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetControlDrainRate(difficulty, value);
		}

		ProfileObject obj = this.GetSection("control");
		if (obj != null)
		{
			value = obj.GetDifficultyFloat("level", difficulty, value);
		}

		return value;
	}

	public int GetControlGainHitEnemy(int difficulty, int defValue = 0)
	{
		int value = defValue;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetControlGainHitEnemy(difficulty, value);
		}

		ProfileObject obj = this.GetSection("control");
		if (obj != null)
		{
			value = obj.GetDifficultyInt("hit_enemy", difficulty, value);
		}

		return value;
	}

	public int GetControlGainHitByEnemy(int difficulty, int defValue = 0)
	{
		int value = defValue;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetControlGainHitByEnemy(difficulty, value);
		}

		ProfileObject obj = this.GetSection("control");
		if (obj != null)
		{
			value = obj.GetDifficultyInt("hit_by_enemy", difficulty, value);
		}

		return value;
	}

	public ProfileSound GetSpawnSounds()
	{
		ProfileSound value = null;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetSpawnSounds();
		}

		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			value = view_as<ProfileSound>(obj.GetSection("spawn"));
		}

		return value;
	}

	public ProfileSound GetIdleSounds()
	{
		ProfileSound value = null;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetIdleSounds();
		}

		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			value = view_as<ProfileSound>(obj.GetSection("idle"));
		}

		return value;
	}

	public ProfileSound GetHurtSounds()
	{
		ProfileSound value = null;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetHurtSounds();
		}

		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			value = view_as<ProfileSound>(obj.GetSection("hurt"));
		}

		return value;
	}

	public ProfileSound GetDeathSounds()
	{
		ProfileSound value = null;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetDeathSounds();
		}

		ProfileObject obj = this.GetSection("sounds");
		if (obj != null)
		{
			value = view_as<ProfileSound>(obj.GetSection("death"));
		}

		return value;
	}

	public KeyMap_Array GetDeathAnimations()
	{
		KeyMap_Array value = null;
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetArray("death_animations", value);
		}

		return this.GetArray("death_animations", value);
	}

	public BossProfileProxyWeapon GetWeapon(int weaponSlot)
	{
		ProfileObject value = null;

		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetWeapon(weaponSlot);
		}

		ProfileObject obj = this.GetSection("weapons");
		if (obj != null)
		{
			value = obj.GetSection("death");
			switch (weaponSlot)
			{
				case TFWeaponSlot_Primary:
				{
					value = obj.GetSection("primary");
				}

				case TFWeaponSlot_Secondary:
				{
					value = obj.GetSection("secondary");
				}

				case TFWeaponSlot_Melee:
				{
					value = obj.GetSection("melee");
				}

				case TFWeaponSlot_Grenade: // Yes, this is the fucking building PDA and the disguise kit
				{
					value = obj.GetSection("pda_build");
					value = obj.GetSection("disguise", value);
				}

				case TFWeaponSlot_Building: // Yes, this is the fucking destruction PDA and the invis watch
				{
					value = obj.GetSection("pda_destroy");
					value = obj.GetSection("invis_watch", value);
				}
			}
		}

		return view_as<BossProfileProxyWeapon>(value);
	}

	public KeyMap_Array GetSpawnEffects()
	{
		KeyMap_Array value = null;
		BossProfileProxyClass def = this.GetDefaultClassData();
		if (def != null && def != this)
		{
			value = def.GetArray("spawn_effects", value);
		}

		return this.GetArray("spawn_effects", value);
	}

	public void Precache()
	{
		char path[PLATFORM_MAX_PATH];
		for (int i = 0; i < Difficulty_Max; i++)
		{
			this.GetModel(i, path, sizeof(path));
			if (path[0] != '\0')
			{
				PrecacheModel2(path, _, _, g_FileCheckConVar.BoolValue);
			}
		}

		this.ConvertSectionsSectionToArray("spawn_effects");
		this.ConvertSectionsSectionToArray("death_animations");

		if (this.GetSpawnSounds() != null)
		{
			this.GetSpawnSounds().Precache();
		}

		if (this.GetIdleSounds() != null)
		{
			this.GetIdleSounds().Precache();
		}

		if (this.GetHurtSounds() != null)
		{
			this.GetHurtSounds().Precache();
		}

		if (this.GetDeathSounds() != null)
		{
			this.GetDeathSounds().Precache();
		}
	}
}

methodmap BossProfileProxyWeapon < ProfileObject
{
	public void GetClassname(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("classname", difficulty, buffer, bufferSize);
	}

	public int GetIndex(int difficulty)
	{
		return this.GetDifficultyInt("index", difficulty, -1);
	}

	public void GetAttributes(int difficulty, char[] buffer, int bufferSize)
	{
		this.GetDifficultyString("stats", difficulty, buffer, bufferSize);
	}

	public int GetLevel(int difficulty)
	{
		return this.GetDifficultyInt("level", difficulty, 0);
	}

	public int GetQuality(int difficulty)
	{
		return this.GetDifficultyInt("quality", difficulty, 0);
	}

	public bool ShouldPreserveAttributes(int difficulty)
	{
		return this.GetDifficultyBool("preserve_default_attributes", difficulty, true);
	}
}

static int g_ActionItemIndexes[] = { 57, 231 };

//Proxy model
static char g_ClientProxyModel[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static char g_ClientProxyModelHard[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static char g_ClientProxyModelInsane[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static char g_ClientProxyModelNightmare[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static char g_ClientProxyModelApollyon[MAXTF2PLAYERS][PLATFORM_MAX_PATH];

void SetupProxy()
{
	g_OnMapStartPFwd.AddFunction(null, MapStart);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerTakeDamagePFwd.AddFunction(null, OnPlayerTakeDamage);

	AddNormalSoundHook(Hook_ProxySoundHook);
}

static void MapStart()
{
	for (int i = 1; i <= 18; i++)
	{
		char sound[PLATFORM_MAX_PATH];
		FormatEx(sound, sizeof(sound), "mvm/player/footsteps/robostep_%s%i.wav", (i < 10) ? "0" : "", i);
		PrecacheSound(sound, true);
	}
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	ClientResetProxy(client.index);
	ClientStartProxyAvailableTimer(client.index);
	SDKHook(client.index, SDKHook_PreThinkPost, ProxyThink);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	ClientStopProxyForce(client.index);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientResetProxy(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!client.IsProxy)
	{
		return;
	}

	// We're a proxy, so play some sounds.

	int proxyMaster = NPCGetFromUniqueID(g_PlayerProxyMaster[client.index]);
	if (proxyMaster != -1)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(proxyMaster, profile, sizeof(profile));

		BossProfileProxyData proxyData = GetBossProfile(profile).GetProxies();
		BossProfileProxyClass classData = proxyData.GetClassData(client.Class);
		classData.GetDeathSounds().EmitSound(_, client.index);
	}

	CreateTimer(0.1, Timer_ResetProxy, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
}

static Action Timer_ResetProxy(Handle timer, any userid)
{
	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(userid));
	if (!client.IsValid)
	{
		return Plugin_Stop;
	}

	ClientResetProxy(client.index, true);
	return Plugin_Stop;
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetProxy(client.index);
}

static Action OnPlayerTakeDamage(SF2_BasePlayer client, int &attacker, int &inflictor, float &damage, int &damageType, int damageCustom)
{
	SF2_BasePlayer attackerPlayer = SF2_BasePlayer(attacker);
	if (!attackerPlayer.IsValid)
	{
		return Plugin_Continue;
	}

	if (attackerPlayer.index == client.index)
	{
		return Plugin_Continue;
	}

	if (client.IsProxy || attackerPlayer.IsProxy)
	{
		if (client.IsEliminated && attackerPlayer.IsEliminated)
		{
			damage = 0.0;
			return Plugin_Changed;
		}

		BossProfileProxyData proxyData;
		BossProfileProxyClass classData;
		if (attackerPlayer.IsProxy)
		{
			int maxHealth = attackerPlayer.MaxHealth;
			SF2NPC_BaseNPC master = SF2NPC_BaseNPC(attackerPlayer.ProxyMaster);
			if (master.IsValid())
			{
				proxyData = master.GetProfileData().GetProxies();
				classData = proxyData.GetClassData(attackerPlayer.Class);
				int difficulty = master.Difficulty;

				if (damageCustom == TF_CUSTOM_TAUNT_GRAND_SLAM ||
					damageCustom == TF_CUSTOM_TAUNT_FENCING ||
					damageCustom == TF_CUSTOM_TAUNT_ARROW_STAB ||
					damageCustom == TF_CUSTOM_TAUNT_GRENADE ||
					damageCustom == TF_CUSTOM_TAUNT_BARBARIAN_SWING ||
					damageCustom == TF_CUSTOM_TAUNT_ENGINEER_ARM ||
					damageCustom == TF_CUSTOM_TAUNT_ARMAGEDDON)
				{
					if (damage >= float(maxHealth))
					{
						damage = float(maxHealth) * 0.5;
					}
					else
					{
						damage = 0.0;
					}
				}
				else if (damageCustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
				{
					damage = float(maxHealth) * classData.GetBackstabDamageScale(difficulty);
					if (damageType & DMG_ACID)
					{
						damage /= 2.0;
					}
				}

				attackerPlayer.ProxyControl += classData.GetControlGainHitEnemy(difficulty);

				float originalPercentage = classData.GetDamageScale(difficulty);
				float additionPercentage = 0.15;
				if (!IsClassConfigsValid())
				{
					if (client.Class == TFClass_Medic)
					{
						damage *= (originalPercentage + additionPercentage);
					}
					else
					{
						damage *= originalPercentage;
					}
				}
				else
				{
					damage *= originalPercentage + g_ClassProxyDamageVulnerability[view_as<int>(client.Class)];
				}
			}
			return Plugin_Changed;
		}
		else if (client.IsProxy)
		{
			SF2NPC_BaseNPC master = SF2NPC_BaseNPC(client.ProxyMaster);
			if (master.IsValid())
			{
				proxyData = master.GetProfileData().GetProxies();
				classData = proxyData.GetClassData(client.Class);
				int difficulty = master.Difficulty;

				client.ProxyControl += classData.GetControlGainHitByEnemy(difficulty);

				damage *= classData.GetSelfDamageScale(difficulty);
				if (classData.GetHurtSounds() != null)
				{
					classData.GetHurtSounds().EmitSound(_, client.index);
				}

				if (damage * (damageType & DMG_CRIT ? 3.0 : 1.0) >= float(client.Health) && !client.InCondition(TFCond_FreezeInput)) // The proxy is about to die
				{
					char buffer[PLATFORM_MAX_PATH];
					KeyMap_Array array = classData.GetDeathAnimations();
					ProfileAnimation animation = null;
					if (array != null && array.Length > 0)
					{
						animation = view_as<ProfileAnimation>(array.GetSection(GetRandomInt(0, array.Length - 1)));
					}
					if (animation != null)
					{
						animation.GetAnimationName(difficulty, buffer, sizeof(buffer));
						if (buffer[0] != '\0')
						{
							g_ClientMaxFrameDeathAnim[client.index] = animation.GetDifficultyInt("frames", difficulty, 0);
							if (g_ClientMaxFrameDeathAnim[client.index] > 0)
							{
								// Cancel out any other taunts.
								if (client.InCondition(TFCond_Taunting))
								{
									client.ChangeCondition(TFCond_Taunting, true);
								}
								//The model has a death anim play it.
								SDK_PlaySpecificSequence(client.index, buffer);
								g_ClientFrame[client.index] = 0;
								RequestFrame(ProxyDeathAnimation, client.index);
								client.ChangeCondition(TFCond_FreezeInput, _, 5.0);
								//Prevent death, and show the damage to the attacker.
								client.ChangeCondition(TFCond_PreventDeath, _, 0.5);
								return Plugin_Changed;
							}
						}
					}

					// The player has no death anim leave him die.
				}
			}
			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}

static void ProxyThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsProxy)
	{
		return;
	}

	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(player.ProxyMaster);
	if (!controller.IsValid())
	{
		return;
	}

	int difficulty = controller.Difficulty;
	TFClassType class = player.Class;

	BossProfileProxyData proxyData = controller.GetProfileData().GetProxies();
	BossProfileProxyClass classData = proxyData.GetClassData(class);

	float speed = classData.GetRunSpeed(difficulty);
	if (player.InCondition(TFCond_SpeedBuffAlly) || g_InProxySurvivalRageMode)
	{
		speed += 30.0;
	}

	player.SetPropFloat(Prop_Send, "m_flMaxspeed", speed);
}

static Action Hook_ProxySoundHook(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer client = SF2_BasePlayer(entity);
	if (!client.IsValid || !client.IsProxy)
	{
		return Plugin_Continue;
	}

	int master = NPCGetFromUniqueID(client.ProxyMaster);
	if (master == -1)
	{
		return Plugin_Continue;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(master, profile, sizeof(profile));
	BossProfileProxyData proxyData = GetBossProfile(profile).GetProxies();
	BossProfileProxyClass classData = proxyData.GetClassData(client.Class);

	switch (channel)
	{
		case SNDCHAN_VOICE:
		{
			if (!classData.AllowVoices())
			{
				return Plugin_Handled;
			}
		}
	}

	if (classData.Robots())
	{
		switch (channel)
		{
			case SNDCHAN_VOICE:
			{
				if (StrContains(sample, "vo/", false) == -1)
				{
					return Plugin_Continue;
				}

				ReplaceString(sample, sizeof(sample), "vo/", "vo/mvm/norm/", false);
				ReplaceString(sample, sizeof(sample), ".wav", ".mp3", false);
				char className[10], classMvM[15];
				TF2_GetClassName(client.Class, className, sizeof(className), true);
				FormatEx(classMvM, sizeof(classMvM), "%s_mvm", className);
				ReplaceString(sample, sizeof(sample), className, classMvM, false);
				for (int i = 0; i < strlen(sample); i++)
				{
					sample[i] = CharToLower(sample[i]);
				}
				PrecacheSound(sample);
				return Plugin_Changed;
			}
			case SNDCHAN_BODY:
			{
				if (StrContains(sample, "player/footsteps/", false) == -1 || client.Class == TFClass_Medic)
				{
					return Plugin_Handled;
				}
				int random = GetRandomInt(1, 18);
				pitch = GetRandomInt(95, 100);
				FormatEx(sample, sizeof(sample), "mvm/player/footsteps/robostep_%s%i.wav", (random < 10) ? "0" : "", random);
				EmitSoundToAll(sample, client.index, _, _, _, 0.25, pitch);
				return Plugin_Changed;
			}
		}
	}

	return Plugin_Continue;
}

void ClientResetProxy(int client, bool resetFull = true)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetProxy(%d)", client);
	}
	#endif

	bool oldProxy = g_PlayerProxy[client];
	if (IsValidClient(client) && oldProxy != g_PlayerProxy[client])
	{
		Call_StartForward(g_OnPlayerChangeProxyStatePFwd);
		Call_PushCell(SF2_BasePlayer(client));
		Call_PushCell(false);
		Call_Finish();
	}

	if (resetFull)
	{
		g_PlayerProxy[client] = false;
		g_PlayerProxyMaster[client] = -1;
	}

	g_PlayerProxyControl[client] = 0;
	g_PlayerProxyControlTimer[client] = null;
	g_PlayerProxyControlRate[client] = 0.0;
	g_PlayerProxyVoiceTimer[client] = null;

	if (IsValidClient(client))
	{
		if (oldProxy)
		{
			ClientStartProxyAvailableTimer(client);

			if (resetFull)
			{
				SetVariantString("");
				AcceptEntityInput(client, "SetCustomModel");
			}
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetProxy(%d)", client);
	}
	#endif
}

void ClientStartProxyAvailableTimer(int client)
{
	g_PlayerProxyAvailable[client] = false;
	float cooldown = g_PlayerProxyWaitTimeConVar.FloatValue;
	if (g_InProxySurvivalRageMode)
	{
		cooldown -= 10.0;
	}
	if (cooldown <= 0.0)
	{
		cooldown = 0.0;
	}

	g_PlayerProxyAvailableTimer[client] = CreateTimer(cooldown, Timer_ClientProxyAvailable, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStartProxyForce(int client, int slenderID, const float pos[3], int spawnPoint)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientStartProxyForce(%d, %d, pos)", client, slenderID);
	}
	#endif

	g_PlayerProxyAskMaster[client] = slenderID;
	for (int i = 0; i < 3; i++)
	{
		g_PlayerProxyAskPosition[client][i] = pos[i];
	}
	g_PlayerProxyAskSpawnPoint[client] = EnsureEntRef(spawnPoint);

	g_PlayerProxyAvailableCount[client] = 0;
	g_PlayerProxyAvailableInForce[client] = true;
	g_PlayerProxyAvailableTimer[client] = CreateTimer(1.0, Timer_ClientForceProxy, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_PlayerProxyAvailableTimer[client], true);

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientStartProxyForce(%d, %d, pos)", client, slenderID);
	}
	#endif
}

void ClientStopProxyForce(int client)
{
	g_PlayerProxyAvailableCount[client] = 0;
	g_PlayerProxyAvailableInForce[client] = false;
	g_PlayerProxyAvailableTimer[client] = null;
}

Action Timer_ClientForceProxy(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerProxyAvailableTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsRoundEnding())
	{
		int bossIndex = NPCGetFromUniqueID(g_PlayerProxyAskMaster[client]);
		if (bossIndex != -1)
		{
			int difficulty = GetLocalGlobalDifficulty(bossIndex);
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(bossIndex, profile, sizeof(profile));

			int maxProxies = GetBossProfile(profile).GetProxies().GetMaxProxies(difficulty);
			int numProxies = 0;

			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || !g_PlayerEliminated[i])
				{
					continue;
				}
				if (!g_PlayerProxy[i])
				{
					continue;
				}
				if (NPCGetFromUniqueID(g_PlayerProxyMaster[i]) != bossIndex)
				{
					continue;
				}

				numProxies++;
			}

			if (numProxies < maxProxies)
			{
				if (g_PlayerProxyAvailableCount[client] > 0)
				{
					g_PlayerProxyAvailableCount[client]--;

					SetHudTextParams(-1.0, 0.25,
						1.0,
						255, 255, 255, 255,
						_,
						_,
						0.25, 1.25);

					ShowSyncHudText(client, g_HudSync, "%T", "SF2 Proxy Force Message", client, g_PlayerProxyAvailableCount[client]);

					return Plugin_Continue;
				}
				else
				{
					ClientEnableProxy(client, bossIndex, g_PlayerProxyAskPosition[client], g_PlayerProxyAskSpawnPoint[client]);
				}
			}
			else
			{
				//PrintToChat(client, "%T", "SF2 Too Many Proxies", client);
			}
		}
	}

	ClientStopProxyForce(client);
	return Plugin_Stop;
}

void DisplayProxyAskMenu(int client, int askMaster, const float pos[3], int spawnPoint)
{
	if (IsRoundEnding() || IsRoundInIntro() || IsRoundInWarmup())
	{
		return;
	}
	char buffer[512];
	Menu menu = new Menu(Menu_ProxyAsk);
	menu.SetTitle("%T\n \n%T\n \n", "SF2 Proxy Ask Menu Title", client, "SF2 Proxy Ask Menu Description", client);

	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	menu.AddItem("1", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
	menu.AddItem("0", buffer);

	g_PlayerProxyAskMaster[client] = askMaster;
	for (int i = 0; i < 3; i++)
	{
		g_PlayerProxyAskPosition[client][i] = pos[i];
	}
	g_PlayerProxyAskSpawnPoint[client] = EnsureEntRef(spawnPoint);

	menu.Display(client, 15);
}

int Menu_ProxyAsk(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_Select:
		{
			if (!IsRoundEnding() && !IsRoundInIntro() && !IsRoundInWarmup())
			{
				int bossIndex = NPCGetFromUniqueID(g_PlayerProxyAskMaster[param1]);
				if (bossIndex != -1)
				{
					int difficulty = GetLocalGlobalDifficulty(bossIndex);
					char profile[SF2_MAX_PROFILE_NAME_LENGTH];
					NPCGetProfile(bossIndex, profile, sizeof(profile));

					int maxProxies = GetBossProfile(profile).GetProxies().GetMaxProxies(difficulty);
					int numProxies;

					for (int client = 1; client <= MaxClients; client++)
					{
						if (!IsValidClient(client) || !g_PlayerEliminated[client])
						{
							continue;
						}
						if (!g_PlayerProxy[client])
						{
							continue;
						}
						if (NPCGetFromUniqueID(g_PlayerProxyMaster[client]) != bossIndex)
						{
							continue;
						}

						numProxies++;
					}

					if (numProxies < maxProxies)
					{
						if (param2 == 0)
						{
							bool ignoreVisibility = false;
							int spawnPointEnt = g_PlayerProxyAskSpawnPoint[param1];
							float spawnPos[3];

							if (IsValidEntity(spawnPointEnt))
							{
								GetEntPropVector(spawnPointEnt, Prop_Data, "m_vecAbsOrigin", spawnPos);

								SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(spawnPointEnt);
								if (spawnPoint.IsValid())
								{
									ignoreVisibility = spawnPoint.IgnoreVisibility;
								}
							}
							else
							{
								for (int i = 0; i < 3; i++)
								{
									spawnPos[i] = g_PlayerProxyAskPosition[param1][i];
								}
							}

							if (ignoreVisibility || !IsPointVisibleToAPlayer(spawnPos, _, false))
							{
								ClientEnableProxy(param1, bossIndex, spawnPos, spawnPointEnt);
							}
							else
							{
								CPrintToChat(param1, "%T", "SF2 Too Much Time", param1);
							}
						}
						else
						{
							ClientStartProxyAvailableTimer(param1);
						}
					}
					else
					{
						PrintToChat(param1, "%T", "SF2 Too Many Proxies", param1);
					}
				}
			}
		}
	}
	return 0;
}

Action Timer_ClientProxyAvailable(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerProxyAvailableTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerProxyAvailable[client] = true;
	g_PlayerProxyAvailableTimer[client] = null;

	return Plugin_Stop;
}

static TFClassType SelectProxyClass(SF2_BasePlayer client)
{
	SF2NPC_BaseNPC controller = SF2NPC_BaseNPC(client.ProxyMaster);
	int difficulty = controller.Difficulty;

	BossProfileProxyData proxyData = controller.GetProfileData().GetProxies();
	ArrayList allowed = new ArrayList();

	int classCount[10] = { 0, ... };
	for (int otherIndex = 1; otherIndex <= MaxClients; otherIndex++)
	{
		SF2_BasePlayer other = SF2_BasePlayer(otherIndex);
		if (other == client || !other.IsValid)
		{
			continue;
		}

		if (other.IsProxy && other.ProxyMaster == controller.Index)
		{
			classCount[view_as<int>(other.Class)]++;
		}
	}

	for (int classIndex = view_as<int>(TFClass_Scout); classIndex <= view_as<int>(TFClass_Engineer); classIndex++)
	{
		if (proxyData.GetClassData(view_as<TFClassType>(classIndex)) == null)
		{
			continue;
		}

		allowed.Push(view_as<TFClassType>(classIndex));
	}

	if (allowed.Length == 0)
	{
		// If no classes specified then assume all classes.
		// We really don't have a choice here anyway.
		allowed.Push(TFClass_Scout);
		allowed.Push(TFClass_Sniper);
		allowed.Push(TFClass_Soldier);
		allowed.Push(TFClass_DemoMan);
		allowed.Push(TFClass_Medic);
		allowed.Push(TFClass_Heavy);
		allowed.Push(TFClass_Pyro);
		allowed.Push(TFClass_Spy);
		allowed.Push(TFClass_Engineer);
	}

	float maxWeight = 0.0;
	for (int i = 0; i < allowed.Length; i++)
	{
		TFClassType tfClass = allowed.Get(i);
		BossProfileProxyClass classData = proxyData.GetClassData(tfClass);

		int classLimit = classData.GetMax(difficulty);
		if (classCount[view_as<int>(tfClass)] < classLimit)
		{
			allowed.Erase(i);
			i--;
			continue;
		}
		maxWeight += classData.GetWeight(difficulty);
	}

	float randomWeight = GetRandomFloat(0.0, maxWeight);
	TFClassType newClass = client.Class;

	for (int i = 0; i < allowed.Length; i++)
	{
		TFClassType tfClass = allowed.Get(i);
		BossProfileProxyClass classData = proxyData.GetClassData(tfClass);

		float weight = classData.GetWeight(difficulty);
		if (weight <= 0.0)
		{
			continue;
		}

		randomWeight -= weight;
		if (randomWeight >= 0.0)
		{
			continue;
		}

		newClass = tfClass;
		break;
	}

	delete allowed;
	return newClass;
}

/**
 *	Respawns a player as a proxy.
 *
 *	@noreturn
 */
void ClientEnableProxy(int clientIndex, int bossIndex, const float pos[3], int spawnPointEnt=-1)
{
	SF2_BasePlayer client = SF2_BasePlayer(clientIndex);
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return;
	}

	if (!(NPCGetFlags(bossIndex) & SFF_PROXIES))
	{
		return;
	}

	if (client.Team != TFTeam_Blue)
	{
		return;
	}

	if (client.IsProxy)
	{
		return;
	}

	TF2_RemovePlayerDisguise(client.index);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	BossProfileProxyData proxyData = GetBossProfile(profile).GetProxies();
	TFClassType class = SelectProxyClass(client);
	BossProfileProxyClass classData = proxyData.GetClassData(class);

	client.SetGhostState(false);

	ClientStopProxyForce(client.index);

	if (IsClientInKart(client.index))
	{
		client.ChangeCondition(TFCond_HalloweenKart, true);
		client.ChangeCondition(TFCond_HalloweenKartDash, true);
		client.ChangeCondition(TFCond_HalloweenKartNoTurn, true);
		client.ChangeCondition(TFCond_HalloweenKartCage, true);
	}

	client.IsProxy = true;

	ChangeClientTeamNoSuicide(client.index, TFTeam_Blue);
	PvP_SetPlayerPvPState(client.index, false, true, false);
	PvE_SetPlayerPvEState(client.index, false, false);
	client.Respawn();

	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	client.ChangeCondition(TFCond_SpeedBuffAlly, _, 0.001);

	client.ProxyMaster = NPCGetUniqueID(bossIndex);
	client.ProxyControl = 100;
	g_PlayerProxyControlRate[client.index] = classData.GetControlDrainRate(difficulty);
	g_PlayerProxyControlTimer[client.index] = CreateTimer(g_PlayerProxyControlRate[client.index], Timer_ClientProxyControl, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
	g_PlayerProxyAvailable[client.index] = false;
	g_PlayerProxyAvailableTimer[client.index] = null;

	int health = classData.GetHealth(difficulty);
	if (health <= 0)
	{
		health = client.Health;
	}

	client.Regenerate();
	client.Health = health;

	client.ScreenFade(200, 1, FFADE_IN, 255, 255, 255, 100);
	EmitSoundToClient(client.index, "weapons/teleporter_send.wav", _, SNDCHAN_STATIC);

	ClientActivateUltravision(client.index);

	TF2Attrib_SetByDefIndex(client.index, 28, 1.0);

	char path[PLATFORM_MAX_PATH];
	classData.GetModel(difficulty, path, sizeof(path));
	SetVariantString(path);
	client.AcceptInput("SetCustomModel");
	client.SetProp(Prop_Send, "m_bUseClassAnimations", true);

	/*if (proxyData.CustomWeapons)
	{
		CreateTimer(1.0, Timer_GiveWeaponAll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}*/

	//SDKHook(client, SDKHook_ShouldCollide, Hook_ClientProxyShouldCollide);

	SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(spawnPointEnt);
	if (spawnPoint.IsValid())
	{
		float spawnPos[3]; float ang[3];
		GetEntPropVector(spawnPointEnt, Prop_Data, "m_vecAbsOrigin", spawnPos);
		GetEntPropVector(spawnPointEnt, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(client.index, spawnPos, ang, view_as<float>({ 0.0, 0.0, 0.0 }));
		spawnPoint.FireOutput("OnSpawn", client.index);
	}
	else
	{
		TeleportEntity(client.index, pos, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
	}

	/*if (proxyData.SpawnEffect)
	{
		char spawnEffect[PLATFORM_MAX_PATH];
		proxyData.GetSpawnEffectName(spawnEffect, sizeof(spawnEffect));
		CreateGeneralParticle(client, spawnEffect, proxyData.SpawnEffectZOffset);
	}*/

	Call_StartForward(g_OnClientSpawnedAsProxyFwd);
	Call_PushCell(client);
	Call_Finish();

	Call_StartForward(g_OnPlayerChangeProxyStatePFwd);
	Call_PushCell(client);
	Call_PushCell(true);
	Call_Finish();
}

static Action Timer_GiveWeaponAll(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	/*int bossIndex = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);

	if (g_PlayerProxy[client] && bossIndex != -1)
	{
		BossProfileProxyData proxyData = SF2NPC_BaseNPC(bossIndex).GetProfileData().GetProxies();
		if (!proxyData.CustomWeapons)
		{
			return Plugin_Stop;
		}
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(bossIndex, profile, sizeof(profile));
		BossProfileProxyClass classData = proxyData.GetClassData();

		int weaponIndex, weaponSlot;
		char weaponName[PLATFORM_MAX_PATH], weaponStats[PLATFORM_MAX_PATH];
		TFClassType class = TF2_GetPlayerClass(client);
		classData.GetWeaponClassname(class, weaponName, sizeof(weaponName));
		if (weaponName[0] == '\0')
		{
			return Plugin_Stop;
		}
		classData.GetWeaponClassname(class, weaponStats, sizeof(weaponStats));
		weaponIndex = classData.GetWeaponIndex(class);
		weaponSlot = classData.GetWeaponSlot(class);

		switch (weaponSlot)
		{
			case 0:
			{
				TF2_RemoveWeaponSlot(client, TFWeaponSlot_Primary);
			}
			case 1:
			{
				TF2_RemoveWeaponSlot(client, TFWeaponSlot_Secondary);
			}
			case 2:
			{
				TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
			}
		}
		Handle weaponHandle = PrepareItemHandle(weaponName, weaponIndex, 0, 0, weaponStats);
		int entity = TF2Items_GiveNamedItem(client, weaponHandle);
		delete weaponHandle;
		EquipPlayerWeapon(client, entity);
		SetEntProp(entity, Prop_Send, "m_bValidatedAttachedEntity", 1);
	}*/
	return Plugin_Stop;
}

//RequestFrame//
void ProxyDeathAnimation(any client)
{
	if (client != -1)
	{
		if (g_ClientFrame[client] >= g_ClientMaxFrameDeathAnim[client])
		{
			g_ClientFrame[client]--;
			KillClient(client);
		}
		else
		{
			g_ClientFrame[client]++;
			RequestFrame(ProxyDeathAnimation,client);
		}
	}
}

Action Timer_ClientProxyControl(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerProxyControlTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerProxyControl[client]--;
	if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
	{
		g_PlayerProxyControl[client] -= 5;
	}
	if (g_PlayerProxyControl[client] <= 0)
	{
		// ForcePlayerSuicide isn't really dependable, since the player doesn't suicide until several seconds after spawning has passed.
		KillClient(client);
		return Plugin_Stop;
	}

	g_PlayerProxyControlTimer[client] = CreateTimer(g_PlayerProxyControlRate[client], Timer_ClientProxyControl, userid, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

Action Timer_ApplyCustomModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	SetEntProp(client, Prop_Send, "m_iAirDash", 99999);

	/*int master = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);

	if (g_PlayerProxy[client] && master != -1)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(master, profile, sizeof(profile));
		BossProfileProxyData proxyData = GetBossProfile(profile).GetProxies();
		BossProfileProxyClass classData = proxyData.GetClassData();

		int difficulty = GetLocalGlobalDifficulty(master);

		// Set custom model, if any.
		char buffer[PLATFORM_MAX_PATH];

		TF2_RegeneratePlayer(client);

		char className[64], keyName[64];
		TFClassType playerClass = TF2_GetPlayerClass(client);
		TF2_GetClassName(playerClass, className, sizeof(className));

		ProfileObject modelsArray;

		if (proxyData.DifficultyModels)
		{
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					modelsArray = classData.GetModel(playerClass, difficulty);
					if (modelsArray == null)
					{
						modelsArray = proxyData.GetUniversalModel(difficulty);
					}
					modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
					modelsArray.GetString(keyName, buffer, sizeof(buffer));
					strcopy(g_ClientProxyModel[client], sizeof(g_ClientProxyModel[]), buffer);
				}
				case Difficulty_Hard:
				{
					modelsArray = classData.GetModel(playerClass, difficulty);
					if (modelsArray == null)
					{
						modelsArray = proxyData.GetUniversalModel(difficulty);
						if (modelsArray == null)
						{
							modelsArray = classData.GetModel(playerClass, 1);
							if (modelsArray == null)
							{
								modelsArray = proxyData.GetUniversalModel(1);
							}
						}
					}
					modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
					modelsArray.GetString(keyName, buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelHard[client], sizeof(g_ClientProxyModelHard[]), buffer);
				}
				case Difficulty_Insane:
				{
					modelsArray = classData.GetModel(playerClass, difficulty);
					if (modelsArray == null)
					{
						modelsArray = proxyData.GetUniversalModel(difficulty);
						if (modelsArray == null)
						{
							modelsArray = classData.GetModel(playerClass, 2);
							if (modelsArray == null)
							{
								modelsArray = proxyData.GetUniversalModel(2);
								if (modelsArray == null)
								{
									modelsArray = classData.GetModel(playerClass, 1);
									if (modelsArray == null)
									{
										modelsArray = proxyData.GetUniversalModel(1);
									}
								}
							}
						}
					}
					modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
					modelsArray.GetString(keyName, buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelInsane[client], sizeof(g_ClientProxyModelInsane[]), buffer);
				}
				case Difficulty_Nightmare:
				{
					modelsArray = classData.GetModel(playerClass, difficulty);
					if (modelsArray == null)
					{
						modelsArray = proxyData.GetUniversalModel(difficulty);
						if (modelsArray == null)
						{
							modelsArray = classData.GetModel(playerClass, 3);
							if (modelsArray == null)
							{
								modelsArray = proxyData.GetUniversalModel(3);
								if (modelsArray == null)
								{
									modelsArray = classData.GetModel(playerClass, 2);
									if (modelsArray == null)
									{
										modelsArray = proxyData.GetUniversalModel(2);
										if (modelsArray == null)
										{
											modelsArray = classData.GetModel(playerClass, 1);
											if (modelsArray == null)
											{
												modelsArray = proxyData.GetUniversalModel(1);
											}
										}
									}
								}
							}
						}
					}
					modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
					modelsArray.GetString(keyName, buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelNightmare[client], sizeof(g_ClientProxyModelNightmare[]), buffer);
				}
				case Difficulty_Apollyon:
				{
					modelsArray = classData.GetModel(playerClass, difficulty);
					if (modelsArray == null)
					{
						modelsArray = proxyData.GetUniversalModel(difficulty);
						if (modelsArray == null)
						{
							modelsArray = classData.GetModel(playerClass, 4);
							if (modelsArray == null)
							{
								modelsArray = proxyData.GetUniversalModel(4);
								if (modelsArray == null)
								{
									modelsArray = classData.GetModel(playerClass, 3);
									if (modelsArray == null)
									{
										modelsArray = proxyData.GetUniversalModel(3);
										if (modelsArray == null)
										{
											modelsArray = classData.GetModel(playerClass, 2);
											if (modelsArray == null)
											{
												modelsArray = proxyData.GetUniversalModel(2);
												if (modelsArray == null)
												{
													modelsArray = classData.GetModel(playerClass, 1);
													if (modelsArray == null)
													{
														modelsArray = proxyData.GetUniversalModel(1);
													}
												}
											}
										}
									}
								}
							}
						}
					}
					modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
					modelsArray.GetString(keyName, buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelApollyon[client], sizeof(g_ClientProxyModelApollyon[]), buffer);
				}
			}

			if (buffer[0] != '\0')
			{
				SetVariantString(buffer);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);

				CreateTimer(0.5, ClientCheckProxyModel, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			modelsArray = classData.GetModel(playerClass, 1);
			if (modelsArray == null)
			{
				modelsArray = proxyData.GetUniversalModel(1);
			}
			if (modelsArray != null)
			{
				modelsArray.GetKeyNameFromIndex(GetRandomInt(0, modelsArray.Size - 1), keyName, sizeof(keyName));
				modelsArray.GetString(keyName, buffer, sizeof(buffer));
				if (buffer[0] != '\0')
				{
					SetVariantString(buffer);
					AcceptEntityInput(client, "SetCustomModel");
					SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
					strcopy(g_ClientProxyModel[client], sizeof(g_ClientProxyModel[]), buffer);
					strcopy(g_ClientProxyModelHard[client], sizeof(g_ClientProxyModelHard[]), buffer);
					strcopy(g_ClientProxyModelInsane[client], sizeof(g_ClientProxyModelInsane[]), buffer);
					strcopy(g_ClientProxyModelNightmare[client], sizeof(g_ClientProxyModelNightmare[]), buffer);
					strcopy(g_ClientProxyModelApollyon[client], sizeof(g_ClientProxyModelApollyon[]), buffer);
					//Prevent plugins like Model manager to override proxy model.
					CreateTimer(0.5, ClientCheckProxyModel, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}

		if (IsPlayerAlive(client))
		{
			g_PlayerProxyNextVoiceSound[client] = GetGameTime();
			// Play any sounds, if any.
			proxyData.GetSpawnSounds().EmitSound(_, client);

			bool zombie = proxyData.Zombies;
			if (zombie)
			{
				int value = g_ForcedHolidayConVar.IntValue;
				if (value != 9 && value != 2)
				{
					g_ForcedHolidayConVar.SetInt(9); //Full-Moon
				}
				int index;
				TFClassType class = TF2_GetPlayerClass(client);
				switch (class)
				{
					case TFClass_Scout:
					{
						index = 5617;
					}
					case TFClass_Soldier:
					{
						index = 5618;
					}
					case TFClass_Pyro:
					{
						index = 5624;
					}
					case TFClass_DemoMan:
					{
						index = 5620;
					}
					case TFClass_Engineer:
					{
						index = 5621;
					}
					case TFClass_Heavy:
					{
						index = 5619;
					}
					case TFClass_Medic:
					{
						index = 5622;
					}
					case TFClass_Sniper:
					{
						index = 5625;
					}
					case TFClass_Spy:
					{
						index = 5623;
					}
				}
				Handle zombieSoul = PrepareItemHandle("tf_wearable", index, 100, 7,"448 ; 1.0 ; 450 ; 1");
				int entity = TF2Items_GiveNamedItem(client, zombieSoul);
				delete zombieSoul;
				zombieSoul = null;
				if (IsValidEdict(entity))
				{
					SDK_EquipWearable(client, entity);
				}
				if (TF2_GetPlayerClass(client) == TFClass_Spy)
				{
					SetEntProp(client, Prop_Send, "m_nForcedSkin", 23);
				}
				else
				{
					SetEntProp(client, Prop_Send, "m_nForcedSkin", 5);
				}
			}

			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
		}
	}*/
	return Plugin_Stop;
}

Action ClientCheckProxyModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}
	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}
	if (!IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}
	if (!g_PlayerProxy[client])
	{
		return Plugin_Stop;
	}
	int difficulty = g_DifficultyConVar.IntValue;

	char model[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", model, sizeof(model));
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			if (strcmp(model, g_ClientProxyModel[client]) != 0 && g_ClientProxyModel[client][0] != '\0')
			{
				SetVariantString(g_ClientProxyModel[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Hard:
		{
			if (strcmp(model, g_ClientProxyModelHard[client]) != 0 && g_ClientProxyModelHard[client][0] != '\0')
			{
				SetVariantString(g_ClientProxyModelHard[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Insane:
		{
			if (strcmp(model, g_ClientProxyModelInsane[client]) != 0 && g_ClientProxyModelInsane[client][0] != '\0')
			{
				SetVariantString(g_ClientProxyModelInsane[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Nightmare:
		{
			if (strcmp(model, g_ClientProxyModelNightmare[client]) != 0 && g_ClientProxyModelNightmare[client][0] != '\0')
			{
				SetVariantString(g_ClientProxyModelNightmare[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Apollyon:
		{
			if (strcmp(model, g_ClientProxyModelApollyon[client]) != 0 && g_ClientProxyModelApollyon[client][0] != '\0')
			{
				SetVariantString(g_ClientProxyModelApollyon[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
	}
	return Plugin_Continue;
}

void SF2_RefreshRestrictions()
{
	for(int client = 1; client <= MaxClients; client++)
	{
		if (IsValidClient(client) && (!g_PlayerEliminated[client] || (g_PlayerEliminated[client] && !IsClientInPvP(client) && !IsClientInPvE(client))))
		{
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_PlayerPostWeaponsTimer[client] = CreateTimer(1.0, Timer_ClientPostWeapons, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

Action Timer_ClientPostWeapons(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (IsValidClient(client) && !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}

	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerPostWeaponsTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerHasRegenerationItem[client] = false;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START Timer_ClientPostWeapons(%d)", client);
	}

	int oldWeaponItemIndexes[6] = { -1, ... };
	int newWeaponItemIndexes[6] = { -1, ... };

	for (int i = 0; i <= 5; i++)
	{
		if (IsValidClient(client))
		{
			int weaponEnt = GetPlayerWeaponSlot(client, i);
			if (!IsValidEdict(weaponEnt))
			{
				continue;
			}

			oldWeaponItemIndexes[i] = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
		}
	}
	#endif

	bool removeWeapons = true;
	bool keepUtilityItems = false;
	bool restrictWeapons = true;
	bool useStock = false;
	bool removeWearables = false;
	bool preventAttack = false;

	if (IsRoundEnding())
	{
		if (!g_PlayerEliminated[client])
		{
			removeWeapons = false;
			restrictWeapons = false;
		}
	}

	if (g_PlayerEliminated[client] && g_PlayerKeepWeaponsConVar.BoolValue)
	{
		removeWeapons = false;
		restrictWeapons = false;
		preventAttack = true;
	}

	// pvp
	if (IsClientInPvP(client) || IsClientInWeaponsTrigger(client))
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (IsClientInPvE(client))
	{
		if (IsPvEBoxing())
		{
			restrictWeapons = false;
			keepUtilityItems = true;
			preventAttack = false;
		}
		else
		{
			removeWeapons = false;
			restrictWeapons = false;
			keepUtilityItems = false;
			preventAttack = false;
		}
	}

	if (g_PlayerProxy[client])
	{
		restrictWeapons = true;
		removeWeapons = true;
		useStock = true;
		removeWearables = true;
		keepUtilityItems = false;
	}

	if (IsRoundInWarmup())
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (IsClientInGhostMode(client))
	{
		removeWeapons = true;
	}

	if (SF_IsRaidMap() && !g_PlayerEliminated[client])
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = false;
	}

	if (SF_IsBoxingMap() && !g_PlayerEliminated[client] && !IsRoundEnding())
	{
		restrictWeapons = false;
		keepUtilityItems = true;
		preventAttack = false;
	}

	if (removeWeapons && !keepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if (i == TFWeaponSlot_Melee && !IsClientInGhostMode(client))
			{
				continue;
			}
			TF2_RemoveWeaponSlotAndWearables(client, i);
		}

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_weapon_builder")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}

		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
	}

	if (keepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if ((i == TFWeaponSlot_Melee || i == TFWeaponSlot_Secondary) && !IsClientInGhostMode(client))
			{
				continue;
			}
			TF2_RemoveWeaponSlotAndWearables(client, i);
		}

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_weapon_builder")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}

		int weaponEnt = INVALID_ENT_REFERENCE;
		weaponEnt = GetPlayerWeaponSlot(client, TFWeaponSlot_Secondary);

		if (IsValidEdict(weaponEnt))
		{
			int itemIndex = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemIndex)
			{
				case 163, 129, 226, 354, 1001, 131, 406, 1099, 42, 159, 311, 433, 863, 1002, 1190:
				{
					//Do nothing
				}
				default:
				{
					TF2_RemoveWeaponSlotAndWearables(client, TFWeaponSlot_Secondary);
				}
			}
		}

		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
	}

	if (removeWearables)
	{
		TF2_StripWearables(client);
	}

	TFClassType playerClass = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(playerClass);

	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

			if (642 == itemIndex)
			{
				if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
				{
					RemoveEntity(ent);
				}
			}
		}
	}

	if (restrictWeapons)
	{
		int health = GetEntProp(client, Prop_Send, "m_iHealth");

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			int itemIndex = GetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex");

			for (int i = 0; i < sizeof(g_ActionItemIndexes); i++)
			{
				if (g_ActionItemIndexes[i] == itemIndex)
				{
					if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
					{
						RemoveEntity(ent);
					}
				}
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_razorback")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}

		if (g_RestrictedWeaponsConfig != null)
		{
			int weaponEnt = INVALID_ENT_REFERENCE;
			for (int slot = 0; slot <= 5; slot++)
			{
				Handle itemHandle = null;
				weaponEnt = GetPlayerWeaponSlot(client, slot);

				if (IsValidEdict(weaponEnt))
				{
					if (useStock || IsWeaponRestricted(playerClass, GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex")))
					{
						TF2_RemoveWeaponSlotAndWearables(client, slot);
						switch (slot)
						{
							case TFWeaponSlot_Primary:
							{
								switch (playerClass)
								{
									case TFClass_Scout:
									{
										itemHandle = PrepareItemHandle("tf_weapon_scattergun", 13, 0, 0, "");
									}
									case TFClass_Sniper:
									{
										itemHandle = PrepareItemHandle("tf_weapon_sniperrifle", 14, 0, 0, "");
									}
									case TFClass_Soldier:
									{
										itemHandle = PrepareItemHandle("tf_weapon_rocketlauncher", 18, 0, 0, "");
									}
									case TFClass_DemoMan:
									{
										itemHandle = PrepareItemHandle("tf_weapon_grenadelauncher", 19, 0, 0, "");
									}
									case TFClass_Heavy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_minigun", 15, 0, 0, "");
									}
									case TFClass_Medic:
									{
										itemHandle = PrepareItemHandle("tf_weapon_syringegun_medic", 17, 0, 0, "");
									}
									case TFClass_Pyro:
									{
										itemHandle = PrepareItemHandle("tf_weapon_flamethrower", 21, 0, 0, "254 ; 4.0");
									}
									case TFClass_Spy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_revolver", 24, 0, 0, "");
									}
									case TFClass_Engineer:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shotgun", 9, 0, 0, "");
									}
								}
							}
							case TFWeaponSlot_Secondary:
							{
								switch (playerClass)
								{
									case TFClass_Scout:
									{
										itemHandle = PrepareItemHandle("tf_weapon_pistol", 23, 0, 0, "");
									}
									case TFClass_Sniper:
									{
										itemHandle = PrepareItemHandle("tf_weapon_smg", 16, 0, 0, "");
									}
									case TFClass_Soldier:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shotgun", 10, 0, 0, "");
									}
									case TFClass_DemoMan:
									{
										itemHandle = PrepareItemHandle("tf_weapon_pipebomblauncher", 20, 0, 0, "");
									}
									case TFClass_Heavy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shotgun", 11, 0, 0, "");
									}
									case TFClass_Medic:
									{
										itemHandle = PrepareItemHandle("tf_weapon_medigun", 29, 0, 0, "");
									}
									case TFClass_Pyro:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shotgun", 12, 0, 0, "");
									}
									case TFClass_Engineer:
									{
										itemHandle = PrepareItemHandle("tf_weapon_pistol", 22, 0, 0, "");
									}
								}
							}
							case TFWeaponSlot_Melee:
							{
								switch (playerClass)
								{
									case TFClass_Scout:
									{
										itemHandle = PrepareItemHandle("tf_weapon_bat", 0, 0, 0, "");
									}
									case TFClass_Sniper:
									{
										itemHandle = PrepareItemHandle("tf_weapon_club", 3, 0, 0, "");
									}
									case TFClass_Soldier:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shovel", 6, 0, 0, "");
									}
									case TFClass_DemoMan:
									{
										itemHandle = PrepareItemHandle("tf_weapon_bottle", 1, 0, 0, "");
									}
									case TFClass_Heavy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_fists", 5, 0, 0, "");
									}
									case TFClass_Medic:
									{
										itemHandle = PrepareItemHandle("tf_weapon_bonesaw", 8, 0, 0, "");
									}
									case TFClass_Pyro:
									{
										itemHandle = PrepareItemHandle("tf_weapon_fireaxe", 2, 0, 0, "");
									}
									case TFClass_Spy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "");
									}
									case TFClass_Engineer:
									{
										itemHandle = PrepareItemHandle("tf_weapon_wrench", 7, 0, 0, "");
									}
								}
							}
							case 4:
							{
								switch (playerClass)
								{
									case TFClass_Spy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_invis", 297, 0, 0, "");
									}
								}
							}
						}

						if (itemHandle != null)
						{
							int newWeapon = TF2Items_GiveNamedItem(client, itemHandle);
							if (IsValidEntity(newWeapon))
							{
								EquipPlayerWeapon(client, newWeapon);
							}
						}
					}
					else
					{
						if (!g_PlayerHasRegenerationItem[client])
						{
							g_PlayerHasRegenerationItem[client] = IsRegenWeapon(weaponEnt);
						}
					}
				}
				delete itemHandle;
				itemHandle = null;
			}
		}

		// Fixes the Pretty Boy's Pocket Pistol glitch.
		int maxHealth = SDKCall(g_SDKGetMaxHealth, client);
		if (health > maxHealth)
		{
			SetEntProp(client, Prop_Data, "m_iHealth", maxHealth);
			SetEntProp(client, Prop_Send, "m_iHealth", maxHealth);
		}
	}

	// Change stats on some weapons.
	if (!g_PlayerEliminated[client] || g_PlayerProxy[client])
	{
		int weaponEnt = INVALID_ENT_REFERENCE;
		Handle weaponHandle = null;
		for (int slot = 0; slot <= 5; slot++)
		{
			weaponEnt = GetPlayerWeaponSlot(client, slot);
			if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			int itemDef = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemDef)
			{
				case 214: // Powerjack
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fireaxe", 214, 0, 0, "180 ; 12.0 ; 412 ; 1.2");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 310: //The Warrior's Spirit
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fists", 310, 0, 0, "2 ; 1.3 ; 412 ; 1.3");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 326: // The Back Scratcher
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fireaxe", 326, 0, 0, "2 ; 1.25 ; 412 ; 1.25 ; 69 ; 0.25 ; 108 ; 1.25");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 304: // Amputator
				{
					TF2_RemoveWeaponSlot(client, slot);

					if (!SF_SpecialRound(SPECIALROUND_THANATOPHOBIA))
					{
						weaponHandle = PrepareItemHandle("tf_weapon_bonesaw", 304, 0, 0, "200 ; 0.0 ; 57 ; 2 ; 1 ; 0.8");
					}
					else
					{
						weaponHandle = PrepareItemHandle("tf_weapon_bonesaw", 304, 0, 0, "1 ; 0.8");
					}
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 239: //GRU
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fists", 239, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
					if (!IsRoundPlaying())
					{
						SetEntityHealth(client, 300);
					}
				}
				case 1100: //Bread Bite
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fists", 1100, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 426: //Eviction Notice
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_fists", 426, 0, 0, "6 ; 0.6 ; 107 ; 1.15 ; 737 ; 4.0 ; 1 ; 0.4 ; 412 ; 1.2");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
					if (!IsRoundPlaying())
					{
						SetEntityHealth(client, 300);
					}
				}
				case 775: //The Escape Plan (Its like, real buggy on wearer)
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_shovel", 775, 0, 0, "414 ; 1 ; 734 ; 0.1");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 452: //Three Rune Blade
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_bat", 452, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 325: //Boston Basher
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_bat", 325, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 450: //Atomizer
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_bat", 450, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 225: //Your Eternal Reward
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_knife", 225, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 649: //Spy-cicle
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_knife", 649, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
				case 574: //Spy-cicle
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_knife", 574, 0, 0, "");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
			}
		}
		delete weaponHandle;
	}

	if (preventAttack)
	{
		int weaponEnt = INVALID_ENT_REFERENCE;
		while ((weaponEnt = FindEntityByClassname(weaponEnt, "tf_wearable_demoshield")) != INVALID_ENT_REFERENCE)
		{
			if (GetEntPropEnt(weaponEnt, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(weaponEnt);
			}
		}

		for (int slot = 0; slot <= 5; slot++)
		{
			if (slot == TFWeaponSlot_Melee)
			{
				continue;
			}

			weaponEnt = GetPlayerWeaponSlot(client, slot);
			if (!IsValidEntity(weaponEnt))
			{
				continue;
			}

			int itemDef = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemDef)
			{
				case 30, 212, 59, 60, 297, 947, 1101:	// Invis Watch, Base Jumper
				{
					TF2_RemoveWeaponSlotAndWearables(client, slot);
				}
				default:
				{
					SetEntPropFloat(weaponEnt, Prop_Send, "m_flNextPrimaryAttack", 99999999.9);
					SetEntPropFloat(weaponEnt, Prop_Send, "m_flNextSecondaryAttack", 99999999.9);
				}
			}
		}
	}

	//Remove the teleport ability
	if (IsClientInPvP(client) || IsClientInPvE(client) || ((SF_IsRaidMap() || SF_IsBoxingMap()) && !g_PlayerEliminated[client])) //DidClientEscape(client)
	{
		int weaponEnt = INVALID_ENT_REFERENCE;
		Handle weaponHandle = null;
		for (int slot = 0; slot <= 5; slot++)
		{
			weaponEnt = GetPlayerWeaponSlot(client, slot);
			if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			int itemDef = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemDef)
			{
				case 589: // Eureka Effect
				{
					TF2_RemoveWeaponSlot(client, slot);

					weaponHandle = PrepareItemHandle("tf_weapon_wrench", 589, 0, 0, "93 ; 0.5 ; 732 ; 0.5");
					int entity = TF2Items_GiveNamedItem(client, weaponHandle);
					delete weaponHandle;
					weaponHandle = null;
					EquipPlayerWeapon(client, entity);
				}
			}
		}
		delete weaponHandle;
	}
	//Force them to take their melee wep, it prevents the civilian bug.
	ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);

	// Remove all hats.
	if (IsClientInGhostMode(client))
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_campaign_item")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(ent);
			}
		}
	}

	float healthFromPack = 1.0;
	if (!IsClassConfigsValid())
	{
		if (!g_PlayerEliminated[client] && !SF_IsBoxingMap())
		{
			if (g_PlayerHasRegenerationItem[client])
			{
				healthFromPack = 0.40;
			}
			if (TF2_GetPlayerClass(client) == TFClass_Medic)
			{
				healthFromPack = 0.0;
			}
		}
	}
	else
	{
		if (!g_PlayerEliminated[client] && !SF_IsBoxingMap())
		{
			healthFromPack = g_ClassHealthPickupMultiplier[classToInt];
			if (g_PlayerHasRegenerationItem[client])
			{
				healthFromPack -= 0.6;
			}
			if (healthFromPack <= 0.0)
			{
				healthFromPack = 0.0;
			}
		}
	}

	TF2Attrib_SetByDefIndex(client, 109, healthFromPack);

	#if defined DEBUG
	int weaponEnt = INVALID_ENT_REFERENCE;

	for (int i = 0; i <= 5; i++)
	{
		weaponEnt = GetPlayerWeaponSlot(client, i);
		if (!IsValidEdict(weaponEnt))
		{
			continue;
		}

		newWeaponItemIndexes[i] = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
	}

	if (g_DebugDetailConVar.IntValue > 0)
	{
		for (int i = 0; i <= 5; i++)
		{
			DebugMessage("-> slot %d: %d (old: %d)", i, newWeaponItemIndexes[i], oldWeaponItemIndexes[i]);
		}

		DebugMessage("END Timer_ClientPostWeapons(%d) -> remove = %d, restrict = %d", client, removeWeapons, restrictWeapons);
	}
	#endif
	return Plugin_Stop;
}

public Action TF2Items_OnGiveNamedItem(int client, char[] classname, int itemDefinitionIndex, Handle &itemHandle)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	/*if (itemDefinitionIndex == 649)
	{
		RequestFrame(Frame_ReplaceSpyCicle, client);
		return Plugin_Handled;
	}*/
	switch (itemDefinitionIndex)
	{
		case 642:
		{
			Handle itemOverride = PrepareItemHandle("tf_wearable", 642, 0, 0, "376 ; 1.0 ; 377 ; 0.2 ; 57 ; 2 ; 412 ; 1.10");

			if (itemOverride != null)
			{
				itemHandle = itemOverride;

				return Plugin_Changed;
			}
			delete itemOverride;
			itemOverride = null;
		}
	}

	return Plugin_Continue;
}

void Frame_ClientHealArrow(int client)
{
	if (IsValidClient(client) && IsClientInPvP(client))
	{
		int entity = -1;
		while ((entity = FindEntityByClassname(entity, "tf_projectile_healing_bolt")) != -1)
		{
			int throwerOffset = FindDataMapInfo(entity, "m_hThrower");
			int ownerEntity = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
			if (ownerEntity != client && throwerOffset != -1)
			{
				ownerEntity = GetEntDataEnt2(entity, throwerOffset);
			}
			if (ownerEntity == client)
			{
				SetEntProp(entity, Prop_Data, "m_iInitialTeamNum", GetClientTeam(client));
				SetEntProp(entity, Prop_Send, "m_iTeamNum", GetClientTeam(client));
			}
		}
	}
}

bool IsRegenWeapon(int weaponEnt)
{
	Address attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 1003);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 490);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 190);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 130);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 57);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	attribRegen = TF2Attrib_GetByDefIndex(weaponEnt, 220);
	if (attribRegen != Address_Null)
	{
		return true;
	}
	return false;
}

bool IsWeaponRestricted(TFClassType class,int itemDefInt)
{
	if (g_RestrictedWeaponsConfig == null)
	{
		return false;
	}

	bool returnBool = false;

	char itemDef[32];
	FormatEx(itemDef, sizeof(itemDef), "%d", itemDefInt);

	g_RestrictedWeaponsConfig.Rewind();
	bool proxyBoss = false;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
		if (!Npc.IsValid())
		{
			continue;
		}
		if (Npc.Flags & SFF_PROXIES)
		{
			proxyBoss = true;
			break;
		}
	}
	if (g_RestrictedWeaponsConfig.JumpToKey("all"))
	{
		//returnBool = (g_RestrictedWeaponsConfig.GetNum(itemDef)) != 0;
		//view_as bool value turn to 2 into a true value.
		if (g_RestrictedWeaponsConfig.GetNum(itemDef)==1)
		{
			returnBool=true;
		}
		if (proxyBoss && !returnBool)
		{
			int proxyRestricted = g_RestrictedWeaponsConfig.GetNum(itemDef, 0);
			if (proxyRestricted==2)
			{
				returnBool = true;
			}
		}
	}

	bool bFoundSection = false;
	g_RestrictedWeaponsConfig.Rewind();

	switch (class)
	{
		case TFClass_Scout:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("scout");
		}
		case TFClass_Soldier:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("soldier");
		}
		case TFClass_Sniper:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("sniper");
		}
		case TFClass_DemoMan:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("demoman");
		}
		case TFClass_Heavy:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("heavy");

			if (!bFoundSection)
			{
				g_RestrictedWeaponsConfig.Rewind();
				bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("heavyweapons");
			}
		}
		case TFClass_Medic:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("medic");
		}
		case TFClass_Spy:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("spy");
		}
		case TFClass_Pyro:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("pyro");
		}
		case TFClass_Engineer:
		{
			bFoundSection = g_RestrictedWeaponsConfig.JumpToKey("engineer");
		}
	}

	if (bFoundSection)
	{
		//returnBool = (g_RestrictedWeaponsConfig.GetNum(itemDef, returnBool)) != 0;
		if (g_RestrictedWeaponsConfig.GetNum(itemDef)==1)
		{
			returnBool = true;
		}
		if (proxyBoss && !returnBool)
		{
			int proxyRestricted = g_RestrictedWeaponsConfig.GetNum(itemDef, 0);
			if (proxyRestricted==2)
			{
				returnBool = true;
			}
		}
	}

	return returnBool;
}
