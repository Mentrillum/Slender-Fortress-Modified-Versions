#if defined _sf2_commands_included
 #endinput
#endif
#define _sf2_commands_included

#pragma semicolon 1

public void OnPluginStart()
{
	LoadTranslations("core.phrases");
	LoadTranslations("common.phrases");
	LoadTranslations("sf2.phrases");
	LoadTranslations("basetriggers.phrases");

	AddTempEntHook("World Decal", Hook_BlockDecals);
	AddTempEntHook("Entity Decal", Hook_BlockDecals);

	// Get offsets.
	g_PlayerFOVOffset = FindSendPropInfo("CBasePlayer", "m_iFOV");
	if (g_PlayerFOVOffset == -1)
	{
		SetFailState("Couldn't find CBasePlayer offset for m_iFOV.");
	}

	g_PlayerDefaultFOVOffset = FindSendPropInfo("CBasePlayer", "m_iDefaultFOV");
	if (g_PlayerDefaultFOVOffset == -1)
	{
		SetFailState("Couldn't find CBasePlayer offset for m_iDefaultFOV.");
	}

	g_PlayerFogCtrlOffset = FindSendPropInfo("CBasePlayer", "m_PlayerFog.m_hCtrl");
	if (g_PlayerFogCtrlOffset == -1)
	{
		LogError("Couldn't find CBasePlayer offset for m_PlayerFog.m_hCtrl!");
	}

	g_PlayerPunchAngleOffset = FindSendPropInfo("CBasePlayer", "m_vecPunchAngle");
	if (g_PlayerPunchAngleOffset == -1)
	{
		LogError("Couldn't find CBasePlayer offset for m_vecPunchAngle!");
	}

	g_PlayerPunchAngleOffsetVel = FindSendPropInfo("CBasePlayer", "m_vecPunchAngleVel");
	if (g_PlayerPunchAngleOffsetVel == -1)
	{
		LogError("Couldn't find CBasePlayer offset for m_vecPunchAngleVel!");
	}

	g_FogCtrlEnableOffset = FindSendPropInfo("CFogController", "m_fog.enable");
	if (g_FogCtrlEnableOffset == -1)
	{
		LogError("Couldn't find CFogController offset for m_fog.enable!");
	}

	g_FogCtrlEndOffset = FindSendPropInfo("CFogController", "m_fog.end");
	if (g_FogCtrlEndOffset == -1)
	{
		LogError("Couldn't find CFogController offset for m_fog.end!");
	}

	g_CollisionGroupOffset = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	if (g_CollisionGroupOffset == -1)
	{
		LogError("Couldn't find CBaseEntity offset for m_CollisionGroup!");
	}

	g_FullDamageData = FindSendPropInfo("CTFGrenadePipebombProjectile", "m_bDefensiveBomb") - 4;
	if (g_FullDamageData == -1)
	{
		LogError("Couldn't find CTFGrenadePipebombProjectile offset for m_bDefensiveBomb!");
	}

	g_Pages = new ArrayList(sizeof(SF2PageEntityData));
	g_PageMusicRanges = new ArrayList(3);
	g_EmptySpawnPagePoints = new ArrayList();

	char valueToString[32];

	// Register console variables.
	g_VersionConVar = CreateConVar("sf2modified_version", PLUGIN_VERSION, "The current version of Slender Fortress. DO NOT TOUCH!", FCVAR_SPONLY | FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_VersionConVar.SetString(PLUGIN_VERSION);

	g_EnabledConVar = CreateConVar("sf2_enabled", "1", "Enable/Disable the Slender Fortress gamemode. This will take effect on map change.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_SlenderMapsOnlyConVar = CreateConVar("sf2_slendermapsonly", "1", "Only enable the Slender Fortress gamemode on map names prefixed with \"slender_\" or \"sf2_\".");

	g_GraceTimeConVar = CreateConVar("sf2_gracetime", "30.0");
	g_IntroEnabledConVar = CreateConVar("sf2_intro_enabled", "1");
	g_IntroDefaultHoldTimeConVar = CreateConVar("sf2_intro_default_hold_time", "9.0");
	g_IntroDefaultFadeTimeConVar = CreateConVar("sf2_intro_default_fade_time", "1.0");

	g_BlockSuicideDuringRoundConVar = CreateConVar("sf2_block_suicide_during_round", "0");

	g_AllChatConVar = CreateConVar("sf2_alltalk", "0");
	g_AllChatConVar.AddChangeHook(OnConVarChanged);

	g_PlayerVoiceDistanceConVar = CreateConVar("sf2_player_voice_distance", "800.0", "The maximum distance RED can communicate in voice chat. Set to 0 if you want them to be heard at all times.", _, true, 0.0);
	g_PlayerVoiceWallScaleConVar = CreateConVar("sf2_player_voice_scale_blocked", "0.5", "The distance required to hear RED in voice chat will be multiplied by this amount if something is blocking them.");

	g_PlayerViewbobEnabledConVar = CreateConVar("sf2_player_viewbob_enabled", "1", "Enable/Disable player viewbobbing.", _, true, 0.0, true, 1.0);
	g_PlayerViewbobEnabledConVar.AddChangeHook(OnConVarChanged);
	g_PlayerViewbobHurtEnabledConVar = CreateConVar("sf2_player_viewbob_hurt_enabled", "0", "Enable/Disable player view tilting when hurt.", _, true, 0.0, true, 1.0);
	g_PlayerViewbobHurtEnabledConVar.AddChangeHook(OnConVarChanged);
	g_PlayerViewbobSprintEnabledConVar = CreateConVar("sf2_player_viewbob_sprint_enabled", "0", "Enable/Disable player step viewbobbing when sprinting.", _, true, 0.0, true, 1.0);
	g_PlayerViewbobSprintEnabledConVar.AddChangeHook(OnConVarChanged);

	g_ForcedHolidayConVar = FindConVar("tf_forced_holiday");

	g_WeaponCriticalsConVar = FindConVar("tf_weapon_criticals");

	g_PhysicsPushScaleConVar = FindConVar("phys_pushscale");

	g_DragonsFuryBurningBonusConVar = FindConVar("tf_fireball_burning_bonus");
	g_DragonsFuryBurnDurationConVar = FindConVar("tf_fireball_burn_duration");

	g_PlayerShakeEnabledConVar = CreateConVar("sf2_player_shake_enabled", "1", "Enable/Disable player view shake during boss encounters.", _, true, 0.0, true, 1.0);
	g_PlayerShakeEnabledConVar.AddChangeHook(OnConVarChanged);
	g_PlayerShakeFrequencyMaxConVar = CreateConVar("sf2_player_shake_frequency_max", "255", "Maximum frequency value of the shake. Should be a value between 1-255.", _, true, 1.0, true, 255.0);
	g_PlayerShakeAmplitudeMaxConVar = CreateConVar("sf2_player_shake_amplitude_max", "5", "Maximum amplitude value of the shake. Should be a value between 1-16.", _, true, 1.0, true, 16.0);

	g_PlayerBlinkRateConVar = CreateConVar("sf2_player_blink_rate", "1.0", "How long (in seconds) each bar on the player's Blink meter lasts.", _, true, 0.0);
	g_PlayerBlinkHoldTimeConVar = CreateConVar("sf2_player_blink_holdtime", "0.15", "How long (in seconds) a player will stay in Blink mode when he or she blinks.", _, true, 0.0);

	g_UltravisionEnabledConVar = CreateConVar("sf2_player_ultravision_enabled", "1", "Enable/Disable player Ultravision. This helps players see in the dark when their Flashlight is off or unavailable.", _, true, 0.0, true, 1.0);
	g_UltravisionRadiusRedConVar = CreateConVar("sf2_player_ultravision_radius_red", "600.0");
	g_UltravisionRadiusBlueConVar = CreateConVar("sf2_player_ultravision_radius_blue", "1600.0");
	g_NightvisionRadiusConVar = CreateConVar("sf2_player_nightvision_radius", "900.0");
	g_UltravisionBrightnessConVar = CreateConVar("sf2_player_ultravision_brightness", "-2");
	g_NightvisionEnabledConVar = CreateConVar("sf2_player_flashlight_isnightvision", "0", "Enable/Disable flashlight replacement with nightvision",_, true, 0.0, true, 1.0);
	g_NightvisionEnabledConVar.AddChangeHook(OnConVarChanged);

	g_GhostModeConnectionConVar = CreateConVar("sf2_ghostmode_no_tolerance", "0", "If set on 1, it will instant kick out the client of the Ghost mode if the client has timed out.");
	g_GhostModeConnectionCheckConVar = CreateConVar("sf2_ghostmode_check_connection", "1", "Checks a player's connection while in Ghost Mode. If the check fails, the client is booted out of Ghost Mode and the action and client's SteamID is logged in the main SF2 log.");
	g_GhostModeConnectionToleranceConVar = CreateConVar("sf2_ghostmode_connection_tolerance", "5.0", "If sf2_ghostmode_check_connection is set to 1 and the client has timed out for at least this amount of time, the client will be booted out of Ghost Mode.");

	g_MaxPlayersConVar = CreateConVar("sf2_maxplayers", "6", "The maximum amount of players that can be in one round.", _, true, 1.0);
	g_MaxPlayersConVar.AddChangeHook(OnConVarChanged);

	g_MaxPlayersOverrideConVar = CreateConVar("sf2_maxplayers_override", "-1", "Overrides the maximum amount of players that can be in one round.", _, true, -1.0);
	g_MaxPlayersOverrideConVar.AddChangeHook(OnConVarChanged);

	g_BossMainConVar = CreateConVar("sf2_boss_main", "slenderman", "The name of the main boss (its profile name, not its display name)");
	g_BossProfileOverrideConVar = CreateConVar("sf2_boss_profile_override", "", "Overrides which boss will be chosen next. Only applies to the first boss being chosen.");
	g_DifficultyConVar = CreateConVar("sf2_difficulty", "1", "Difficulty of the game. 1 = Normal, 2 = Hard, 3 = Insane, 4 = Nightmare, 5 = Apollyon.", _, true, 1.0, true, 5.0);
	g_DifficultyConVar.AddChangeHook(OnConVarChanged);
	g_DifficultyConVar.AddChangeHook(OnDifficultyConVarChangedForward);

	g_CameraOverlayConVar = CreateConVar("sf2_camera_overlay", SF2_OVERLAY_DEFAULT, "The overlay directory for what RED players will see with No Filmgrain off. This value shouldn't be updated in realtime and should be set before a map changes fully.");
	g_OverlayNoGrainConVar = CreateConVar("sf2_camera_overlay_nograin", SF2_OVERLAY_DEFAULT_NO_FILMGRAIN, "The overlay directory for what RED players will see with No Filmgrain on. This value shouldn't be updated in realtime and should be set before a map changes fully.");
	g_GhostOverlayConVar = CreateConVar("sf2_camera_ghost_overlay", SF2_OVERLAY_GHOST, "The overlay directory for what BLU ghosted players will see. This value shouldn't be updated in realtime and should be set before a map changes fully.");

	g_SpecialRoundBehaviorConVar = CreateConVar("sf2_specialround_mode", "0", "0 = Special Round resets on next round, 1 = Special Round keeps going until all players have played (not counting spectators, recently joined players, and those who reset their queue points during the round)", _, true, 0.0, true, 1.0);
	g_SpecialRoundForceConVar = CreateConVar("sf2_specialround_forceenable", "-1", "Sets whether a Special Round will occur on the next round or not.", _, true, -1.0, true, 1.0);
	g_SpecialRoundOverrideConVar = CreateConVar("sf2_specialround_forcetype", "-1", "Sets the type of Special Round that will be chosen on the next Special Round. Set to -1 to let the game choose.", _, true, -1.0);
	g_SpecialRoundIntervalConVar = CreateConVar("sf2_specialround_interval", "5", "If this many rounds are completed, the next round will be a Special Round.", _, true, 0.0);

	g_NewBossRoundBehaviorConVar = CreateConVar("sf2_newbossround_mode", "0", "0 = boss selection will return to normal after the boss round, 1 = the new boss will continue being the boss until all players in the server have played against it (not counting spectators, recently joined players, and those who reset their queue points during the round).", _, true, 0.0, true, 1.0);
	g_NewBossRoundIntervalConVar = CreateConVar("sf2_newbossround_interval", "3", "If this many rounds are completed, the next round's boss will be randomly chosen, but will not be the main boss.", _, true, 0.0);
	g_NewBossRoundForceConVar = CreateConVar("sf2_newbossround_forceenable", "-1", "Sets whether a new boss will be chosen on the next round or not. Set to -1 to let the game choose.", _, true, -1.0, true, 1.0);

	g_IgnoreRoundWinConditionsConVar = CreateConVar("sf2_ignore_round_win_conditions", "0", "If set to 1, round will not end when RED is eliminated.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_IgnoreRoundWinConditionsConVar.AddChangeHook(OnConVarChanged);
	g_IgnoreRedPlayerDeathSwapConVar = CreateConVar("sf2_ignore_red_player_death_team_switch", "0", "If set to 1, RED players will not switch back to the BLU team.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_IgnoreRedPlayerDeathSwapConVar.AddChangeHook(OnConVarChanged);

	g_EnableWallHaxConVar = CreateConVar("sf2_enable_wall_hax", "0", "Enables/disables the Wall Hax special round without needing to turn on Wall Hax. This will not force the difficulty to Insane and will show player + boss outlines.", _, true, 0.0, true, 1.0);
	g_EnableWallHaxConVar.AddChangeHook(OnConVarChanged);

	g_TimeLimitConVar = CreateConVar("sf2_timelimit_default", "300", "The time limit of the round. Maps can change the time limit.", _, true, 0.0);
	g_TimeLimitEscapeConVar = CreateConVar("sf2_timelimit_escape_default", "90", "The time limit to escape. Maps can change the time limit.", _, true, 0.0);
	g_TimeGainFromPageGrabConVar = CreateConVar("sf2_time_gain_page_grab", "12", "The time gained from grabbing a page. Maps can change the time gain amount.");

	g_WarmupRoundConVar = CreateConVar("sf2_warmupround", "1", "Enables/disables Warmup Rounds after the \"Waiting for Players\" phase.", _, true, 0.0, true, 1.0);
	g_WarmupRoundNumConVar = CreateConVar("sf2_warmupround_num", "1", "Sets the amount of Warmup Rounds that occur after the \"Waiting for Players\" phase.", _, true, 0.0);

	g_PlayerProxyWaitTimeConVar = CreateConVar("sf2_player_proxy_waittime", "35", "How long (in seconds) after a player was chosen to be a Proxy must the system wait before choosing him again.");
	g_PlayerProxyAskConVar = CreateConVar("sf2_player_proxy_ask", "0", "Set to 1 if the player can choose before becoming a Proxy, set to 0 to force.");

	g_PlayerAFKTimeConVar = CreateConVar("sf2_player_afk_time", "60.0", "Amount of time before a player is considered AFK, set to 0 to disable.", _, true, 0.0);

	g_PlayerInfiniteSprintOverrideConVar = CreateConVar("sf2_player_infinite_sprint_override", "-1", "1 = infinite sprint, 0 = never have infinite sprint, -1 = let the game choose.", _, true, -1.0, true, 1.0);
	g_PlayerInfiniteFlashlightOverrideConVar = CreateConVar("sf2_player_infinite_flashlight_override", "-1", "1 = infinite flashlight, 0 = never have infinite flashlight, -1 = let the game choose.", _, true, -1.0, true, 1.0);
	g_PlayerInfiniteBlinkOverrideConVar = CreateConVar("sf2_player_infinite_blink_override", "-1", "1 = infinite blink, 0 = never have infinite blink, -1 = let the game choose.", _, true, -1.0, true, 1.0);

	g_RaidMapConVar = CreateConVar("sf2_israidmap", "0", "Set to 1 if the map is a raid map.", _, true, 0.0, true, 1.0);

	g_BossChaseEndlesslyConVar = CreateConVar("sf2_bosseschaseendlessly", "0", "Set to 1 if you want bosses chasing you forever.", _, true, 0.0, true, 1.0);

	g_ProxyMapConVar = CreateConVar("sf2_isproxymap", "0", "Set to 1 if the map is a proxy survival map.", _, true, 0.0, true, 1.0);

	g_BoxingMapConVar = CreateConVar("sf2_isboxingmap", "0", "Set to 1 if the map is a boxing map.", _, true, 0.0, true, 1.0);

	IntToString(RENEVANT_MAXWAVES, valueToString, sizeof(valueToString));
	g_RenevantMapConVar = CreateConVar("sf2_isrenevantmap", "0", "Set to 1 if the map uses Renevant logic.", _, true, 0.0, true, 1.0);
	g_DefaultRenevantBossConVar = CreateConVar("sf2_renevant_boss_default", "", "Determine what boss should spawn during the Single Boss wave, if nothing is inputted, Single Boss will not trigger.");
	g_DefaultRenevantBossMessageConVar = CreateConVar("sf2_renevant_bossspawn_message", "", "This is what will be used as the spawn message for the Single Boss wave.");
	g_RenevantMaxWaves = CreateConVar("sf2_renevant_maxwaves", valueToString, "Determines the maximum number of waves the Revenant gamemode can use.", _, true, 0.0);

	g_SlaughterRunMapConVar = CreateConVar("sf2_isslaughterrunmap", "0", "Set to 1 if the map is a slaughter run map.", _, true, 0.0, true, 1.0);
	g_SlaughterRunDivisibleTimeConVar = CreateConVar("sf2_slaughterrun_divide_time", "125.0", "Determines how much the average time should be divided by in Slaughter Run, the lower the number, the longer the bosses spawn.", _, true, 0.0);
	g_SlaughterRunDefaultClassRunSpeedConVar = CreateConVar("sf2_slaughterrun_class_run_speed", "450.0", "How fast every class will run if Slaughter Run is enabled.", _, true);
	g_SlaughterRunMinimumBossRunSpeedConVar = CreateConVar("sf2_slaughterrun_min_boss_run_speed", "600.0", "The speed bosses will run at if their original run speed is less than this value.", _, true);

	g_UseAlternateConfigDirectoryConVar = CreateConVar("sf2_alternateconfigs", "0", "Set to 1 if the server should pick up the configs from data/.", _, true, 0.0, true, 1.0);

	g_PlayerKeepWeaponsConVar = CreateConVar("sf2_player_keep_weapons", "0", "Set to 1 if players can keep their non-melee weapons outside of PvP arenas.", _, true, 0.0, true, 1.0);

	g_RestartSessionConVar = CreateConVar("sf2_dont_touch_this", "0", "Seriously, do not touch this.", _, true, 0.0, true, 1.0);
	g_RestartSessionConVar.AddChangeHook(OnConVarChanged);

	g_SurvivalMapConVar = CreateConVar("sf2_issurvivalmap", "0", "Set to 1 if the map is a survival map.", _, true, 0.0, true, 1.0);
	g_TimeEscapeSurvivalConVar = CreateConVar("sf2_survival_time_limit", "30", "when X secs left the mod will turn back the Survive! text to Escape! text", _, true, 0.0);

	g_FullyEnableSpectatorConVar = CreateConVar("sf2_enable_spectator", "0", "Determines if all spectator restrictions should be disabled.", _, true, 0.0, true, 1.0);

	g_AllowPlayerPeekingConVar = CreateConVar("sf2_player_peeking", "0", "Allow players to go into thirdperson by crouching and taunting.", _, true, 0.0, true, 1.0);

	g_UsePlayersForKillFeedConVar = CreateConVar("sf2_kill_feed_players", "0", "Uses players for kill feed when SourceTV is unavailable.", _, true, 0.0, true, 1.0);

	g_DefaultLegacyHudConVar = CreateConVar("sf2_default_legacy_hud", "0", "Set to 1 if the server should enable the legacy hud by default in their settings.", _, true, 0.0, true, 1.0);

	g_DifficultyVoteOptionsConVar = CreateConVar("sf2_difficulty_vote_options", "1,2,3", "What vote options will appear on the Difficulty vote. 1 = Normal, 2 = Hard, 3 = Insane, 4 = Nightmare, 5 = Apollyon, 6 = Random");
	g_DifficultyVoteRevoteConVar = CreateConVar("sf2_difficulty_vote_runoff", "0.0", "If the winning vote has less precentage of player votes, do a run-off vote.", _, true, 0.0, true, 1.0);
	g_DifficultyVoteRandomConVar = CreateConVar("sf2_difficulty_random_vote", "1", "If random vote will use a random vote option instead of a random difficulty.", _, true, 0.0, true, 1.0);
	g_DifficultyNoGracePageConVar = CreateConVar("sf2_difficulty_no_grace_pages", "", "On what difficulties will players be unable to collect pages while grace period is active. 1 = Normal, 2 = Hard, 3 = Insane, 4 = Nightmare, 5 = Apollyon");

	g_HighDifficultyPercentConVar = CreateConVar("sf2_high_difficulty_vote_percentage", "0.0", "The required percentage needed for Nightmare and Apollyon to vote whenever they show up in the vote pool.");

	g_FileCheckConVar = CreateConVar("sf2_debug_file_checks", "0", "Determines if the gamemode should look for missing files when loading all the bosses. Note that turning this on leads to longer boss loading times.", _, true, 0.0, true, 1.0);

	g_LoadOutsideMapsConVar = CreateConVar("sf2_load_outside_maps", "0", "Allow bosses to be loaded outside of Slender Fortress maps.", _, true, 0.0, true, 1.0);
	g_DefaultBossTeamConVar = CreateConVar("sf2_default_boss_team", "1", "If bosses are loaded outside of SF2, determine what default team bosses should be with.", _, true, 1.0, true, 5.0);

	g_EngineerBuildInBLUConVar = CreateConVar("sf2_engineer_build_in_blue", "0", "Allows BLU engineers to build outside of the PvP and PvE arena.", _, true, 0.0, true, 1.0);

	g_MaxRoundsConVar = FindConVar("mp_maxrounds");

	g_HudSync = CreateHudSynchronizer();
	g_HudSync2 = CreateHudSynchronizer();
	g_HudSync3 = CreateHudSynchronizer();
	g_HudSync4 = CreateHudSynchronizer();
	g_RoundTimerSync = CreateHudSynchronizer();
	g_Cookie = RegClientCookie("sf2_newcookies", "", CookieAccess_Private);

	g_Buildings = new ArrayList();
	g_WhitelistedEntities = new ArrayList();
	g_BreakableProps = new ArrayList();

	switch (g_DifficultyConVar.IntValue)
	{
		case Difficulty_Hard:
		{
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_HARD;
		}
		case Difficulty_Insane:
		{
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_INSANE;
		}
		case Difficulty_Nightmare:
		{
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_NIGHTMARE;
		}
		case Difficulty_Apollyon:
		{
			if (g_RestartSessionEnabled)
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_RESTARTSESSION;
			}
			else
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_APOLLYON;
			}
		}
		default:
		{
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
		}
	}

	// Register console commands.
	RegConsoleCmd("sm_sf2", Command_MainMenu);
	RegConsoleCmd("sm_sl", Command_MainMenu);
	RegConsoleCmd("sm_slender", Command_MainMenu);
	RegConsoleCmd("sm_sltutorial", Command_Tutorial);
	RegConsoleCmd("sm_sltuto", Command_Tutorial);
	RegConsoleCmd("sm_sf2tutorial", Command_Tutorial);
	RegConsoleCmd("sm_sf2tuto", Command_Tutorial);
	RegConsoleCmd("sm_slpack", Command_Pack);
	RegConsoleCmd("sm_sf2pack", Command_Pack);
	RegConsoleCmd("sm_slnextpack", Command_NextPack);
	RegConsoleCmd("sm_sf2nextpack", Command_NextPack);
	RegConsoleCmd("sm_slnext", Command_Next);
	RegConsoleCmd("sm_slgroup", Command_Group);
	RegConsoleCmd("sm_slghost", Command_GhostMode);
	RegConsoleCmd("sm_slhelp", Command_Help);
	RegConsoleCmd("sm_slsettings", Command_Settings);
	RegConsoleCmd("sm_slcredits", Command_Credits);
	RegConsoleCmd("sm_slviewbosslist", Command_BossList);
	RegConsoleCmd("sm_slbosslist", Command_BossList);
	RegConsoleCmd("sm_slafk", Command_NoPoints);
	RegConsoleCmd("sm_flashlight", Command_ToggleFlashlight);
	RegConsoleCmd("sm_slhud", Command_MenuSwitchHud);
	RegConsoleCmd("sm_slviewbob", Command_MenuViewBob);
	RegConsoleCmd("+sprint", Command_SprintOn);
	RegConsoleCmd("-sprint", Command_SprintOff);
	RegConsoleCmd("+blink", Command_BlinkOn);
	RegConsoleCmd("-blink", Command_BlinkOff);

	RegAdminCmd("sm_slgroupname", Command_GroupName, ADMFLAG_SLAY); //People like to use naughty names, keep it at this for now until pre-defined group names are made
	RegAdminCmd("sm_sf2_bosspack_vote", DevCommand_BossPackVote, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_nopoints", Command_NoPointsAdmin, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_scare", Command_ClientPerformScare, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_spawn_boss", Command_SpawnSlender, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_spawn_all_bosses", Command_SpawnAllSlenders, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_add_boss", Command_AddSlender, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_add_boss_fake", Command_AddSlenderFake, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_remove_boss", Command_RemoveSlender, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_remove_all_bosses", Command_RemoveAllSlenders, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_getbossindexes", Command_GetBossIndexes, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_setplaystate", Command_ForceState, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_boss_attack_waiters", Command_SlenderAttackWaiters, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_boss_no_teleport", Command_SlenderNoTeleport, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_force_proxy", Command_ForceProxy, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_force_escape", Command_ForceEscape, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_set_difficulty", Command_ForceDifficulty, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_force_special_round", Command_ForceSpecialRound, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_toggle_boss_teleports", Command_ToggleAllBossTeleports, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_toggle_attack_waiters", Command_ToggleAllAttackWaiters, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_debug_logic_escape", Command_DebugLogicEscape, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_kill_client", Command_ClientKillDeathcam, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_end_grace_period", Command_ForceEndGrace, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_reloadprofiles", Command_ReloadProfiles, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_alltalk", Command_AllTalkToggle, ADMFLAG_SLAY);
	RegAdminCmd("sm_slalltalk", Command_AllTalkToggle, ADMFLAG_SLAY, _, _, FCVAR_HIDDEN);
	RegAdminCmd("sm_sf2_eventmode", Command_ConditionToggle, ADMFLAG_CONVARS);
	RegAdminCmd("sm_sleventmode", Command_ConditionToggle, ADMFLAG_CONVARS, _, _, FCVAR_HIDDEN);
	RegAdminCmd("sm_sf2_endless_chasing", Command_EndlessChasing, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_red_player_death_switch", Command_RedDeathTeamSwitch, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_set_queue", Command_SetQueuePoints, ADMFLAG_CHEATS);
	RegAdminCmd("sm_sf2_toggle_intro", Command_ToggleIntro, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_global_alltalk", Command_ToggleGlobalAllTalk, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_block_suicide", Command_ToggleBlockSuicide, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_maxplayers", Command_MaxPlayers, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_maxplayers_override", Command_MaxPlayersOverride, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_specialround_mode", Command_SpecialRoundMode, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_player_infinite_sprint_override", Command_InfiniteSprint, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_player_infinite_flashlight_override", Command_InfiniteFlashlight, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_player_infinite_blink_override", Command_InfiniteBlink, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_wall_hax", Command_WallHax, ADMFLAG_SLAY);
	RegAdminCmd("sm_sf2_keep_weapons", Command_KeepWeapons, ADMFLAG_SLAY);
	RegAdminCmd("+alltalk", Command_AllTalkOn, ADMFLAG_SLAY);
	RegAdminCmd("-alltalk", Command_AllTalkOff, ADMFLAG_SLAY);
	RegAdminCmd("+slalltalk", Command_AllTalkOn, ADMFLAG_SLAY, _, _, FCVAR_HIDDEN);
	RegAdminCmd("-slalltalk", Command_AllTalkOff, ADMFLAG_SLAY, _, _, FCVAR_HIDDEN);

	RegServerCmd("load_itempreset", Command_BlockCommand);

	// Hook onto existing console commands.
	AddCommandListener(Hook_CommandBuild, "build");
	AddCommandListener(Hook_CommandTaunt, "taunt");
	AddCommandListener(Hook_CommandDisguise, "disguise");
	AddCommandListener(Hook_CommandSuicideAttempt, "kill");
	AddCommandListener(Hook_CommandSuicideAttempt, "explode");
	AddCommandListener(Hook_CommandSuicideAttempt, "joinclass");
	AddCommandListener(Hook_CommandPreventJoinTeam, "join_class");
	AddCommandListener(Hook_CommandPreventJoinTeam, "jointeam");
	AddCommandListener(Hook_CommandPreventJoinTeam, "autoteam");
	AddCommandListener(Hook_BlockCommand, "spectate");
	AddCommandListener(Hook_CommandVoiceMenu, "voicemenu");
	// Hook events.
	HookEvent("teamplay_round_start", Event_RoundStart);
	HookEvent("teamplay_round_win", Event_RoundEnd);
	HookEvent("teamplay_win_panel", Event_WinPanel, EventHookMode_Pre);
	HookEvent("teamplay_broadcast_audio", Event_Audio, EventHookMode_Pre);
	HookEvent("player_team", Event_DontBroadcastToClients, EventHookMode_Pre);
	HookEvent("player_team", Event_PlayerTeam);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_hurt", Event_PlayerHurt);
	//HookEvent("npc_hurt", Event_HitBoxHurt);
	HookEvent("post_inventory_application", Event_PostInventoryApplication);
	HookEvent("item_found", Event_DontBroadcastToClients, EventHookMode_Pre);
	HookEvent("teamplay_teambalanced_player", Event_DontBroadcastToClients, EventHookMode_Pre);
	HookEvent("fish_notice", Event_PlayerDeathPre, EventHookMode_Pre);
	HookEvent("fish_notice__arm", Event_PlayerDeathPre, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeathPre, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_changeclass", Event_PlayerClass);
	HookEvent("player_healed", Event_PlayerHealed, EventHookMode_Pre);
	HookEvent("player_healonhit", Event_HealOnHit, EventHookMode_Pre);

	// Hook entities.
	HookEntityOutput("info_npc_spawn_destination", "OnUser1", NPCSpawn);
	HookEntityOutput("trigger_multiple", "OnStartTouch", Hook_TriggerOnStartTouch);
	HookEntityOutput("trigger_multiple", "OnEndTouch", Hook_TriggerOnEndTouch);
	HookEntityOutput("trigger_teleport", "OnStartTouch", Hook_TriggerTeleportOnStartTouch);
	//HookEntityOutput("trigger_teleport", "OnEndTouch", Hook_TriggerTeleportOnEndTouch);

	// Hook usermessages.
	HookUserMessage(GetUserMessageId("VoiceSubtitle"), Hook_BlockUserMessage, true);
	HookUserMessage(GetUserMessageId("PlayerTauntSoundLoopStart"), Hook_TauntUserMessage, true);
	HookUserMessage(GetUserMessageId("SayText2"), Hook_BlockUserMessageEx, true);
	//HookUserMessage(GetUserMessageId("TextMsg"), Hook_BlockUserMessage, true);

	g_OnGamemodeStartPFwd = new PrivateForward(ET_Ignore);
	g_OnGamemodeEndPFwd = new PrivateForward(ET_Ignore);
	g_OnMapStartPFwd = new PrivateForward(ET_Ignore);
	g_OnMapEndPFwd = new PrivateForward(ET_Ignore);
	g_OnGameFramePFwd = new PrivateForward(ET_Ignore);
	g_OnRoundStartPFwd = new PrivateForward(ET_Ignore);
	g_OnRoundEndPFwd = new PrivateForward(ET_Ignore);
	g_OnEntityCreatedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_String);
	g_OnEntityDestroyedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_String);
	g_OnEntityTeleportedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerJumpPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerSpawnPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerTakeDamagePFwd = new PrivateForward(ET_Hook, Param_Cell, Param_CellByRef, Param_CellByRef, Param_FloatByRef, Param_CellByRef);
	g_OnPlayerDeathPrePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	g_OnPlayerDeathPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	g_OnPlayerPutInServerPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerDisconnectedPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerEscapePFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerTeamPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerClassPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerLookAtBossPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerChangePlayStatePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_OnPlayerChangeGhostStatePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerChangeProxyStatePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerConditionAddedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerConditionRemovedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnPlayerTurnOnFlashlightPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerTurnOffFlashlightPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerFlashlightBreakPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnPlayerAverageUpdatePFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnSpecialRoundStartPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnBossSpawnPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnBossRemovedPFwd = new PrivateForward(ET_Ignore, Param_Cell);
	g_OnChaserGetAttackActionPFwd = new PrivateForward(ET_Hook, Param_Cell, Param_String, Param_CellByRef);
	g_OnChaserGetCustomAttackPossibleStatePFwd = new PrivateForward(ET_Hook, Param_Cell, Param_String, Param_Cell);
	g_OnChaserUpdatePosturePFwd = new PrivateForward(ET_Hook, Param_Cell, Param_String, Param_Cell);
	g_OnDifficultyChangePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnDifficultyVoteFinishedPFwd = new PrivateForward(ET_Hook, Param_Cell, Param_CellByRef);
	g_OnRenevantTriggerWavePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_OnWallHaxDebugPFwd = new PrivateForward(ET_Ignore);

	// Hook sounds.
	AddNormalSoundHook(Hook_NormalSound);

	AddTempEntHook("Fire Bullets", Hook_TEFireBullets);

	steamtools = LibraryExists("SteamTools");

	steamworks = LibraryExists("SteamWorks");

	InitializeBossProfiles();

	NPCInitialize();

	SetupTraps();

	SetupMenus();

	InitializeChangelog();

	InitializeEffects();

	SetupAntiCamping();
	SetupBlink();
	SetupBreathing();
	SetupDeathCams();
	SetupGhost();
	SetupProxy();
	SetupHints();
	SetupStatic();
	SetupFlashlight();
	SetupMusic();
	SetupSprint();
	SetupUltravision();
	SetupPlayerGlows();
	SetupInteractables();

	SetupAdminMenu();

	SetupPlayerGroups();

	PvP_Initialize();
	PvE_Initialize();

	SetupCustomMapEntities();

	SetupEntityActions();

	InitializeCustomEntities();

	SetupSpecialRounds();

	SetupRenevantMode();

	SetupGlows();

	g_FuncNavPrefer = new ArrayList();

	CreateTimer(0.1, Timer_OnEverythingLoaded, _, TIMER_FLAG_NO_MAPCHANGE);

	// @TODO: When cvars are finalized, set this to true.
	AutoExecConfig(false);
	#if defined DEBUG
	InitializeDebug();
	#endif
}

// You have to do this otherwise SF2_OnEverythingLoaded won't call
static Action Timer_OnEverythingLoaded(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}
	Call_StartForward(g_OnEverythingLoadedFwd);
	Call_Finish();
	return Plugin_Stop;
}

static Action Command_BlockCommand(int args)
{
    return Plugin_Handled;
}

static Action Hook_BlockDecals(const char[] te_name, const int[] Players, int numClients, float delay)
{
	return Plugin_Stop;
}

static void OnDifficultyConVarChangedForward(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	if (!g_Enabled)
	{
		return;
	}

	int oldDifficulty = StringToInt(oldValue);
	int difficulty = StringToInt(newValue);

	Call_StartForward(g_OnDifficultyChangeFwd);
	Call_PushCell(difficulty);
	Call_PushCell(oldDifficulty);
	Call_Finish();

	Call_StartForward(g_OnDifficultyChangePFwd);
	Call_PushCell(difficulty);
	Call_PushCell(oldDifficulty);
	Call_Finish();
}

//	==========================================================
//	COMMANDS AND COMMAND HOOK FUNCTIONS
//	==========================================================

static Action Command_Help(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	g_MenuHelp.Display(client, 30);
	return Plugin_Handled;
}

static Action Command_Settings(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	g_MenuSettings.Display(client, 30);
	return Plugin_Handled;
}

static Action Command_MenuSwitchHud(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	char buffer[512];
	FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Hud Version Title", client);

	Panel panel = new Panel();
	panel.SetTitle(buffer);

	panel.DrawItem("Use the new HUD");
	panel.DrawItem("Use the legacy HUD");

	panel.Send(client, Panel_SettingsHudVersion, 30);
	delete panel;
	return Plugin_Handled;
}

static Action Command_MenuViewBob(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	char buffer[512];
	FormatEx(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings View Bobbing Toggle Title", client);
	Panel panel = new Panel();
	panel.SetTitle(buffer);
	panel.DrawItem("Enable View Bobbing");
	panel.DrawItem("Disable View Bobbing");
	panel.Send(client, Panel_SettingsViewBobbing, 30);
	delete panel;
	return Plugin_Handled;
}

static Action Command_Credits(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	g_MenuCredits.Display(client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

static Action Command_BossList(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	DisplayBossList(client);
	return Plugin_Handled;
}

static Action Command_NoPoints(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (!g_PlayerNoPoints[client])
	{
		CPrintToChat(client, "%T", "SF2 AFK On", client);
		g_PlayerNoPoints[client] = true;
		AFK_SetTime(client);
	}
	else
	{
		CPrintToChat(client, "%T", "SF2 AFK Off", client);
		g_PlayerNoPoints[client] = false;
		AFK_SetTime(client);
	}
	return Plugin_Handled;
}

static Action Command_ToggleFlashlight(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return Plugin_Handled;
	}

	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding() && !DidClientEscape(client))
	{
		if (GetGameTime() >= ClientGetFlashlightNextInputTime(client))
		{
			ClientHandleFlashlight(client);
		}
	}

	return Plugin_Handled;
}

static Action Command_SprintOn(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsPlayerAlive(client) && !g_PlayerEliminated[client])
	{
		ClientHandleSprint(client, true);
	}

	return Plugin_Handled;
}

static Action Command_SprintOff(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsPlayerAlive(client) && !g_PlayerEliminated[client])
	{
		ClientHandleSprint(client, false);
	}

	return Plugin_Handled;
}

static Action Command_BlinkOn(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding())
	{
		if (!g_PlayerEliminated[client] && !DidClientEscape(client))
		{
			g_PlayerHoldingBlink[client] = true;
			ClientBlink(client);
		}
	}

	return Plugin_Handled;
}

static Action Command_BlinkOff(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding())
	{
		if (!g_PlayerEliminated[client] && !DidClientEscape(client))
		{
			g_PlayerHoldingBlink[client] = false;
		}
	}

	return Plugin_Handled;
}

static Action DevCommand_BossPackVote(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	InitiateBossPackVote(client);
	return Plugin_Handled;
}

static Action Command_NoPointsAdmin(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_nopoints <name|#userid> <0/1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	bool mode;
	if (args > 1)
	{
		char arg2[32];
		GetCmdArg(2, arg2, sizeof(arg2));
		mode = StringToInt(arg2) != 0;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		if (IsClientSourceTV(target))
		{
			continue; // Exclude the sourcetv bot
		}

		g_AdminNoPoints[client] = args > 1 ? mode : !g_AdminNoPoints[client];
		if (g_AdminNoPoints[client])
		{
			CPrintToChat(client, "%T", "SF2 AFK On", client);
		}
		else
		{
			CPrintToChat(client, "%T", "SF2 AFK Off", client);
		}

		AFK_SetTime(client);
	}

	return Plugin_Handled;
}

static Action Command_MainMenu(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	g_MenuMain.Display(client, 30);
	return Plugin_Handled;
}

static Action Command_Tutorial(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	//Tutorial_HandleClient(client);
	return Plugin_Handled;
}

static Action Command_Next(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	DisplayQueuePointsMenu(client);
	return Plugin_Handled;
}

static Action Command_Group(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	DisplayGroupMainMenuToClient(client);
	return Plugin_Handled;
}

static Action Command_GroupName(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_slgroupname <name>");
		return Plugin_Handled;
	}

	int groupIndex = ClientGetPlayerGroup(client);
	if (!IsPlayerGroupActive(groupIndex))
	{
		CPrintToChat(client, "%T", "SF2 Group Does Not Exist", client);
		return Plugin_Handled;
	}

	if (GetPlayerGroupLeader(groupIndex) != client)
	{
		CPrintToChat(client, "%T", "SF2 Not Group Leader", client);
		return Plugin_Handled;
	}

	char groupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetCmdArg(1, groupName, sizeof(groupName));
	if (groupName[0] == '\0')
	{
		CPrintToChat(client, "%T", "SF2 Invalid Group Name", client);
		return Plugin_Handled;
	}

	char oldGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(groupIndex, oldGroupName, sizeof(oldGroupName));
	SetPlayerGroupName(groupIndex, groupName);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		if (ClientGetPlayerGroup(i) != groupIndex)
		{
			continue;
		}
		CPrintToChat(i, "%T", "SF2 Group Name Set", i, oldGroupName, groupName);
	}

	return Plugin_Handled;
}

static Action Command_GhostMode(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsRoundEnding() || IsRoundInWarmup() || !g_PlayerEliminated[client] || !IsClientParticipating(client) || g_PlayerProxy[client] || IsClientInPvP(client) || IsClientInPvE(client) || IsClientInKart(client) || TF2_IsPlayerInCondition(client,TFCond_Taunting)|| TF2_IsPlayerInCondition(client,TFCond_Charging) || g_LastCommandTime[client] > GetEngineTime())
	{
		CPrintToChat(client, "{red}%T", "SF2 Ghost Mode Not Allowed", client);
		return Plugin_Handled;
	}
	if (!IsClientInGhostMode(client))
	{
		TF2_RespawnPlayer(client);
		ClientSetGhostModeState(client, true);
		HandlePlayerHUD(client);
		TF2_AddCondition(client, TFCond_StealthedUserBuffFade, -1.0);

		CPrintToChat(client, "{dodgerblue}%T", "SF2 Ghost Mode Enabled", client);
	}
	else
	{
		ClientSetGhostModeState(client, false);
		TF2_RespawnPlayer(client);
		TF2_RemoveCondition(client, TFCond_StealthedUserBuffFade);

		CPrintToChat(client, "{dodgerblue}%T", "SF2 Ghost Mode Disabled", client);
	}
	g_LastCommandTime[client] = GetEngineTime() + 0.5;
	return Plugin_Handled;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] args)
{
	if (!g_PlayerCalledForNightmare[client])
	{
		g_PlayerCalledForNightmare[client] = (StrContains(args, "nightmare", false) != -1 || StrContains(args, "Nightmare", false) != -1);
	}

	if (g_TimerChangeClientName[client] != null)
	{
		TriggerTimer(g_TimerChangeClientName[client]);
	}

	if (!g_Enabled || (g_AllChatConVar.BoolValue && !SF_SpecialRound(SPECIALROUND_SINGLEPLAYER)) || SF_IsBoxingMap() || g_AdminAllTalk[client])
	{
		return Plugin_Continue;
	}

	if (!IsRoundEnding())
	{
		bool sayTeam = strcmp(command, "say_team") == 0;

		if (g_PlayerEliminated[client])
		{
			if (IsValidClient(client) && !IsPlayerAlive(client) && GetClientTeam(client) == TFTeam_Red)
			{
				return Plugin_Stop; // Plugin_Stop in this case stops message AND post hook so bot won't see message in OnClientSayCommand_Post()
			}

			char message[256];
			FormatEx(message, sizeof message, "{blue}%N:{default} %s", client, args);
			//Broadcast the msg to the source tv, if the server has one.
			PrintToSourceTV(message);

			if (!sayTeam)
			{
				if (args[0] == '!' || args[1] == '!')	// Don't let ! commands get detected twice
				{
					FakeClientCommandEx(client, "say_team \" %s\"", args);
				}
				else
				{
					FakeClientCommandEx(client, "say_team %s", args);
				}
				return Plugin_Stop;
			}
		}
		else
		{
			if (SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
			{
				return Plugin_Stop;
			}
		}

		if (!sayTeam)
		{
			char message[256];
			FormatEx(message, sizeof message, "{red}%N:{default} %s", client, args);
			//Broadcast the msg to the source tv, if the server has one.
			PrintToSourceTV(message);
		}
	}

	return Plugin_Continue;
}
static Action Hook_CommandSuicideAttempt(int client, const char[] command,int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (!IsValidClient(client))
	{
		return Plugin_Continue;
	}
	if (GetClientTeam(client) == TFTeam_Spectator)
	{
		return Plugin_Continue;
	}
	if (IsClientInGhostMode(client))
	{
		return Plugin_Handled;
	}

	if (IsRoundInIntro() && !g_PlayerEliminated[client])
	{
		return Plugin_Handled;
	}

	if (g_BlockSuicideDuringRoundConVar.BoolValue)
	{
		if (IsRoundPlaying() && !g_PlayerEliminated[client] && !DidClientEscape(client))
		{
			return Plugin_Handled;
		}
	}

	if (IsClientInPvP(client)) //Nobody asked you to cheat your way out of PvP to miss a kill.
	{
		return Plugin_Handled;
	}

	if (IsClientInKart(client))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}
static Action Hook_CommandPreventJoinTeam(int client, const char[] command,int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (GetClientTeam(client) == TFTeam_Spectator)
	{
		return Plugin_Continue;
	}
	if (IsClientInGhostMode(client))
	{
		return Plugin_Handled;
	}

	if (IsRoundInIntro() && !g_PlayerEliminated[client])
	{
		return Plugin_Handled;
	}

	if (g_BlockSuicideDuringRoundConVar.BoolValue)
	{
		if (IsRoundPlaying() && !g_PlayerEliminated[client] && !DidClientEscape(client))
		{
			return Plugin_Handled;
		}
	}

	if (IsClientInPvP(client)) //Nobody asked you to cheat your way out of PvP to miss a kill.
	{
		return Plugin_Handled;
	}

	if (IsClientInKart(client))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action Hook_BlockCommand(int client, const char[] command,int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

static Action Hook_CommandVoiceMenu(int client, const char[] command,int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (IsClientInGhostMode(client))
	{
		ClientGhostModeNextTarget(client);
		return Plugin_Handled;
	}

	if (g_PlayerProxy[client])
	{
		int master = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);
		if (master != -1)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(master, profile, sizeof(profile));
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileProxyIdleSounds(profile, soundInfo);
			if (soundInfo.Paths != null && soundInfo.Paths.Length > 0 && GetGameTime() >= g_PlayerProxyNextVoiceSound[client])
			{
				soundInfo.EmitSound(_, client);
				g_PlayerProxyNextVoiceSound[client] = GetGameTime() + GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);
			}
		}
	}

	return Plugin_Continue;
}

static Action Command_ClientKillDeathcam(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_kill_client <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32], arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		if (!IsValidClient(target) || !IsPlayerAlive(target) || g_PlayerEliminated[target] || IsClientInGhostMode(target))
		{
			continue;
		}

		float bufferPos[3];
		GetClientAbsOrigin(target, bufferPos);
		ClientStartDeathCam(target, StringToInt(arg2), bufferPos, true);
		g_PlayerDied1Up[target] = false;
		g_PlayerIn1UpCondition[target] = false;
		KillClient(target);
	}

	return Plugin_Handled;
}

static Action Command_ClientPerformScare(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_scare <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32], arg2[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, arg2, sizeof(arg2));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		ClientPerformScare(target, StringToInt(arg2));
	}

	return Plugin_Handled;
}

static Action Command_SpawnSlender(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args == 0)
	{
		ReplyToCommand(client, "Usage: sm_sf2_spawn_boss <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(StringToInt(arg1));
	if (!npc.IsValid())
	{
		return Plugin_Handled;
	}

	SF2BossProfileData data;
	data = npc.GetProfileData();
	if (data.IsPvEBoss)
	{
		ReplyToCommand(client, "You may not spawn PvE bosses!");
		return Plugin_Handled;
	}

	float eyePos[3], eyeAng[3], endPos[3];
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);

	Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, client);
	TR_GetEndPosition(endPos, trace);
	delete trace;

	npc.Spawn(endPos);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	npc.GetProfile(profile, sizeof(profile));

	if (IsValidClient(client))
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Spawned Boss", client);
	}

	return Plugin_Handled;
}

static Handle g_SpawnAllSlendersTimer[MAXTF2PLAYERS] = { null, ... };
static int g_SpawnAllBossesCount = 0;

static Action Command_SpawnAllSlenders(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args == 0)
	{
		ReplyToCommand(client, "Usage: sm_sf2_spawn_all_bosses <timer 0-1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	bool doTimer = StringToInt(arg1) != 0;

	if (!doTimer)
	{
		g_SpawnAllBossesCount = 0;
		float eyePos[3], eyeAng[3], endPos[3];
		GetClientEyePosition(client, eyePos);
		GetClientEyeAngles(client, eyeAng);

		Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, client);
		TR_GetEndPosition(endPos, trace);
		delete trace;

		SF2NPC_BaseNPC npc;
		for (int npcIndex = 0; npcIndex <= MAX_BOSSES; npcIndex++)
		{
			npc = SF2NPC_BaseNPC(npcIndex);
			if (npc.IsValid())
			{
				SF2BossProfileData data;
				data = npc.GetProfileData();
				if (data.IsPvEBoss)
				{
					continue;
				}
				npc.Spawn(endPos);
			}
		}
	}
	else
	{
		g_SpawnAllBossesCount = 0;
		if (g_SpawnAllSlendersTimer[client] == null)
		{
			g_SpawnAllSlendersTimer[client] = CreateTimer(0.1, Timer_SpawnAllSlenders, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
		}
		else
		{
			CPrintToChat(client, "{royalblue}%t {default}Already spawning bosses, please wait...", "SF2 Prefix");
		}
	}

	CPrintToChat(client, "{royalblue}%t {default}Spawned all bosses at your location.", "SF2 Prefix");

	return Plugin_Handled;
}

static Action Timer_SpawnAllSlenders(Handle timer, any userid)
{
	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(userid));
	if (!client.IsValid)
	{
		return Plugin_Stop;
	}
	if (timer != g_SpawnAllSlendersTimer[client.index])
	{
		return Plugin_Stop;
	}
	if (g_SpawnAllBossesCount >= MAX_BOSSES)
	{
		CPrintToChat(client.index, "{royalblue}%t {default}Spawned all bosses at your locations.", "SF2 Prefix");
		g_SpawnAllBossesCount = 0;
		g_SpawnAllSlendersTimer[client.index] = null;
		return Plugin_Stop;
	}
	float eyePos[3], eyeAng[3], endPos[3];
	client.GetEyePosition(eyePos);
	client.GetEyeAngles(eyeAng);

	Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, client);
	TR_GetEndPosition(endPos, trace);
	delete trace;

	SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(g_SpawnAllBossesCount);
	if (npc.IsValid())
	{
		SF2BossProfileData data;
		data = npc.GetProfileData();
		if (!data.IsPvEBoss)
		{
			npc.Spawn(endPos);
		}
	}
	g_SpawnAllBossesCount++;
	return Plugin_Continue;
}

static Action Command_RemoveSlender(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args == 0)
	{
		ReplyToCommand(client, "Usage: sm_sf2_remove_boss <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int bossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return Plugin_Handled;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	SF2BossProfileData data;
	g_BossProfileData.GetArray(profile, data, sizeof(data));
	if (data.IsPvEBoss)
	{
		ReplyToCommand(client, "You may not remove PvE bosses!");
		return Plugin_Handled;
	}

	NPCRemove(bossIndex);

	if (IsValidClient(client))
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Removed Boss", client);
	}

	return Plugin_Handled;
}

static Action Command_RemoveAllSlenders(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (!SF_IsBoxingMap())
	{
		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(npcIndex);
			if (!npc.IsValid())
			{
				continue;
			}

			SF2BossProfileData data;
			data = npc.GetProfileData();
			if (data.IsPvEBoss)
			{
				continue;
			}
			npc.Remove();
		}
		if (IsValidClient(client))
		{
			CPrintToChat(client, "{royalblue}%t {default}Removed all bosses.", "SF2 Prefix", client);
		}
	}
	else
	{
		if (IsValidClient(client))
		{
			CPrintToChat(client, "{royalblue}%t {default}Cannot use this command in Boxing maps.", "SF2 Prefix", client);
		}
	}

	if (MusicActive())
	{
		NPCStopMusic();
	}

	return Plugin_Handled;
}

static Action Command_GetBossIndexes(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	char message[512];
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	if (!IsValidClient(client))
	{
		LogMessage("Active Boss Indexes:");
		LogMessage("----------------------------");
	}
	else
	{
		ClientCommand(client, "echo Active Boss Indexes:");
		ClientCommand(client, "echo ----------------------------");
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		NPCGetProfile(i, profile, sizeof(profile));

		FormatEx(message, sizeof(message), "%d - %s", i, profile);
		if (NPCGetFlags(i) & SFF_FAKE)
		{
			StrCat(message, sizeof(message), " (fake)");
		}

		if (g_SlenderCopyMaster[i] != -1)
		{
			char cat[64];
			FormatEx(cat, sizeof(cat), " (copy of %d)", g_SlenderCopyMaster[i]);
			StrCat(message, sizeof(message), cat);
		}

		if (IsValidClient(client))
		{
			ClientCommand(client, "echo %s", message);
		}
		else
		{
			LogMessage("%s", message);
		}
	}

	if (IsValidClient(client))
	{
		ClientCommand(client, "echo ----------------------------");

		ReplyToCommand(client, "Printed active boss indexes to your console!");
	}
	else
	{
		LogMessage("----------------------------");

		LogMessage("Printed active boss indexes to the server console!");
	}

	return Plugin_Handled;
}

static Action Command_SlenderAttackWaiters(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_boss_attack_waiters <bossindex 0-%d> <0/1>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int bossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return Plugin_Handled;
	}

	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));

	int bossFlags = NPCGetFlags(bossIndex);

	bool state = StringToInt(arg2) != 0;
	bool oldState = (bossFlags & SFF_ATTACKWAITERS) != 0;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (state)
	{
		if (!oldState)
		{
			NPCSetFlags(bossIndex, bossFlags | SFF_ATTACKWAITERS);
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Attack Waiters", client);
			CBaseEntity boss = CBaseEntity(NPCGetEntIndex(bossIndex));
			if (boss.IsValid())
			{
				boss.SetProp(Prop_Data, "m_iTeamNum", TFTeam_Spectator);
			}
		}
	}
	else
	{
		if (oldState)
		{
			NPCSetFlags(bossIndex, bossFlags & ~SFF_ATTACKWAITERS);
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Do Not Attack Waiters", client);
			CBaseEntity boss = CBaseEntity(NPCGetEntIndex(bossIndex));
			if (boss.IsValid())
			{
				boss.SetProp(Prop_Data, "m_iTeamNum", TFTeam_Blue);
			}
		}
	}

	return Plugin_Handled;
}

static Action Command_SlenderNoTeleport(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_boss_no_teleport <bossindex 0-%d> <0/1>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int bossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return Plugin_Handled;
	}

	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));

	int bossFlags = NPCGetFlags(bossIndex);

	bool state = StringToInt(arg2) != 0;
	bool oldState = (bossFlags & SFF_NOTELEPORT) != 0;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (state)
	{
		if (!oldState)
		{
			NPCSetFlags(bossIndex, bossFlags | SFF_NOTELEPORT);
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Should Not Teleport", client);
		}
	}
	else
	{
		if (oldState)
		{
			NPCSetFlags(bossIndex, bossFlags & ~SFF_NOTELEPORT);
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Boss Should Teleport", client);
		}
	}

	return Plugin_Handled;
}

static Action Command_ToggleAllBossTeleports(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_toggle_boss_teleports <0/1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int state = StringToInt(arg1);

	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		int bossFlags = NPCGetFlags(npcIndex);
		if (state)
		{
			NPCSetFlags(npcIndex, bossFlags | SFF_NOTELEPORT);
		}
		else if (!state)
		{
			NPCSetFlags(npcIndex, bossFlags & ~SFF_NOTELEPORT);
		}
	}
	if (state)
	{
		CPrintToChat(client, "{royalblue}%t {default}All bosses can no longer teleport.", "SF2 Prefix", client);
	}
	else if (!state)
	{
		CPrintToChat(client, "{royalblue}%t {default}All bosses can now teleport.", "SF2 Prefix", client);
	}

	return Plugin_Handled;
}

static Action Command_DebugLogicEscape(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	char name[32];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, "sf2_logic_escape", false) == 0)
		{
			AcceptEntityInput(ent, "FireUser1");
			break;
		}
	}
	CPrintToChat(client, "{royalblue}%t {default}Triggered sf2_logic_escape.", "SF2 Prefix", client);

	return Plugin_Handled;
}

static Action Command_ForceEndGrace(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (g_RoundGraceTimer != null)
	{
		TriggerTimer(g_RoundGraceTimer);
	}

	return Plugin_Handled;
}

static Action Command_ReloadProfiles(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	ReloadBossProfiles();
	if (g_Enabled)
	{
		ReloadRestrictedWeapons();
		ReloadSpecialRounds();
		ReloadClassConfigs();
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);

		if (!npc.IsValid())
		{
			continue;
		}

		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		npc.GetProfile(profile, sizeof(profile));
		SF2BossProfileData data;
		g_BossProfileData.GetArray(profile, data, sizeof(data));
		NPCSetProfileData(npc.Index, data);

		if (npc.Type == SF2BossType_Chaser)
		{
			SF2ChaserBossProfileData chaserData;
			g_ChaserBossProfileData.GetArray(profile, chaserData, sizeof(chaserData));
			NPCChaserSetProfileData(npc.Index, chaserData);
		}
		else if (npc.Type == SF2BossType_Statue)
		{
			SF2StatueBossProfileData statueData;
			g_StatueBossProfileData.GetArray(profile, statueData, sizeof(statueData));
			NPCStatueSetProfileData(npc.Index, statueData);
		}
	}
	CPrintToChatAll("{royalblue}%t {default} Reloaded all profiles successfully.", "SF2 Prefix");

	return Plugin_Handled;
}

static Action Command_ToggleAllAttackWaiters(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_toggle_attack_waiters <0/1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int state = StringToInt(arg1);

	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		int bossFlags = NPCGetFlags(npcIndex);
		if (state)
		{
			NPCSetFlags(npcIndex, bossFlags | SFF_ATTACKWAITERS);
		}
		else if (!state)
		{
			NPCSetFlags(npcIndex, bossFlags & ~SFF_ATTACKWAITERS);
		}
	}
	if (state)
	{
		CPrintToChat(client, "{royalblue}%t {default}All bosses can now attack waiters.", "SF2 Prefix", client);
	}
	else if (!state)
	{
		CPrintToChat(client, "{royalblue}%t {default}All bosses can no longer attack waiters.", "SF2 Prefix", client);
	}

	return Plugin_Handled;
}

static Action Command_ForceProxy(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_force_proxy <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}

	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Cannot Use Command", client);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));

	int bossIndex = StringToInt(arg2);
	if (bossIndex < 0 || bossIndex >= MAX_BOSSES)
	{
		ReplyToCommand(client, "Boss index is out of range!");
		return Plugin_Handled;
	}
	else if (NPCGetUniqueID(bossIndex) == -1)
	{
		ReplyToCommand(client, "Boss index is invalid! Boss index not active!");
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];

		char name[MAX_NAME_LENGTH];
		if (IsClientSourceTV(target))
		{
			continue; // Exclude the sourcetv bot
		}
		FormatEx(name, sizeof(name), "%N", target);

		if (!g_PlayerEliminated[target])
		{
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Unable To Perform Action On Player In Round", client, name);
			continue;
		}

		if (g_PlayerProxy[target])
		{
			continue; // Exclude any active proxies
		}

		float intPos[3];

		int spawnPoint = -1;

		if (!SpawnProxy(client, bossIndex, intPos, spawnPoint))
		{
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Player No Place For Proxy", client, name);
			continue;
		}

		ClientEnableProxy(target, bossIndex, intPos, spawnPoint);
	}

	return Plugin_Handled;
}

static Action Command_ForceEscape(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_force_escape <name|#userid>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		if (!g_PlayerEliminated[i] && !DidClientEscape(i))
		{
			ClientEscape(target);
			TeleportClientToEscapePoint(target);
		}
	}

	return Plugin_Handled;
}

static Action Command_ForceDifficulty(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args == 0)
	{
		ReplyToCommand(client, "Usage: sm_sf2_set_difficulty <difficulty 1-5>");
		return Plugin_Handled;
	}

	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Cannot Use Command", client);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int newDifficulty = StringToInt(arg1);

	if (newDifficulty < Difficulty_Normal)
	{
		newDifficulty = Difficulty_Normal;
	}
	else if (newDifficulty > Difficulty_Apollyon)
	{
		newDifficulty = Difficulty_Apollyon;
	}
	else if (newDifficulty > Difficulty_Easy && newDifficulty < Difficulty_Max)
	{
		g_DifficultyConVar.SetInt(newDifficulty);
	}

	switch (newDifficulty)
	{
		case Difficulty_Normal:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {yellow}%t{default}.", "SF2 Prefix", client, "SF2 Normal Difficulty");
		}
		case Difficulty_Hard:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {orange}%t{default}.", "SF2 Prefix", client, "SF2 Hard Difficulty");
		}
		case Difficulty_Insane:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {red}%t{default}.", "SF2 Prefix", client, "SF2 Insane Difficulty");
		}
		case Difficulty_Nightmare:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {valve}%t!", "SF2 Prefix", client, "SF2 Nightmare Difficulty");
		}
		case Difficulty_Apollyon:
		{
			if (!g_RestartSessionEnabled)
			{
				CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {darkgray}%t!", "SF2 Prefix", client, "SF2 Apollyon Difficulty");
			}
			else
			{
				CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the difficulty to {mediumslateblue}%t!", "SF2 Prefix", client, "SF2 Calamity Difficulty");
			}
		}
	}

	return Plugin_Handled;
}
static Action Command_ForceSpecialRound(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args == 0)
	{
		ReplyToCommand(client, "Usage: sm_sf2_force_special_round <specialround 1-38>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int specialRound = StringToInt(arg1);

	if (specialRound < 1)
	{
		specialRound = 1;
	}
	else if (specialRound > 38)
	{
		specialRound = 38;
	}

	if (specialRound > 0 && specialRound < 39)
	{
		g_SpecialRoundOverrideConVar.SetInt(specialRound);
	}

	switch (specialRound)
	{
		case SPECIALROUND_DOUBLETROUBLE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Double Trouble.", "SF2 Prefix", client);
		}
		case SPECIALROUND_INSANEDIFFICULTY:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Suicide Time.", "SF2 Prefix", client);
		}
		case SPECIALROUND_DOUBLEMAXPLAYERS:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Double Players.", "SF2 Prefix", client);
		}
		case SPECIALROUND_LIGHTSOUT:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Lights Out.", "SF2 Prefix", client);
		}
		case SPECIALROUND_BEACON:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Bacon Spray.", "SF2 Prefix", client);
		}
		case SPECIALROUND_SILENTSLENDER:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Silent Slender {default}(Here you die).", "SF2 Prefix", client);
		}
		case SPECIALROUND_NOGRACE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Start Running.", "SF2 Prefix", client);
		}
		case SPECIALROUND_2DOUBLE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Double It All, But Go No Higher.", "SF2 Prefix", client);
		}
		case SPECIALROUND_DOUBLEROULETTE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Double Roulette.", "SF2 Prefix", client);
		}
		case SPECIALROUND_NIGHTVISION:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Night Vision.", "SF2 Prefix", client);
		}
		case SPECIALROUND_INFINITEFLASHLIGHT:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Infinite Flashlight.", "SF2 Prefix", client);
		}
		case SPECIALROUND_DREAMFAKEBOSSES:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Just A Dream.", "SF2 Prefix", client);
		}
		case SPECIALROUND_EYESONTHECLOACK:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Countdown.", "SF2 Prefix", client);
		}
		case SPECIALROUND_NOPAGEBONUS:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Deadline.", "SF2 Prefix", client);
		}
		case SPECIALROUND_DUCKS:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Ducks.", "SF2 Prefix", client);
		}
		case SPECIALROUND_1UP:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}1-Up.", "SF2 Prefix", client);
		}
		case SPECIALROUND_NOULTRAVISION:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Blind.", "SF2 Prefix", client);
		}
		case SPECIALROUND_SUPRISE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Surprise Me.", "SF2 Prefix", client);
		}
		case SPECIALROUND_LASTRESORT:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Last Resort.", "SF2 Prefix", client);
		}
		case SPECIALROUND_ESCAPETICKETS:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Escape Tickets.", "SF2 Prefix", client);
		}
		case SPECIALROUND_REVOLUTION:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Special Round Revolution.", "SF2 Prefix", client);
		}
		case SPECIALROUND_DISTORTION:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Space Distortion.", "SF2 Prefix", client);
		}
		case SPECIALROUND_MULTIEFFECT:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Multieffect.", "SF2 Prefix", client);
		}
		case SPECIALROUND_BOO:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Boo.", "SF2 Prefix", client);
		}
		case SPECIALROUND_VOTE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Special Round Vote.", "SF2 Prefix", client);
		}
		case SPECIALROUND_COFFEE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Coffee.", "SF2 Prefix", client);
		}
		case SPECIALROUND_PAGEDETECTOR:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Item Detectors.", "SF2 Prefix", client);
		}
		case SPECIALROUND_CLASSSCRAMBLE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Class Scramble.", "SF2 Prefix", client);
		}
		case SPECIALROUND_PAGEREWARDS:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Page Rewards.", "SF2 Prefix", client);
		}
		case SPECIALROUND_TINYBOSSES:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Tiny Bosses.", "SF2 Prefix", client);
		}
		case SPECIALROUND_RUNNINGINTHE90S:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}In The 90s.", "SF2 Prefix", client);
		}
		case SPECIALROUND_TRIPLEBOSSES:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Triple Bosses.", "SF2 Prefix", client);
		}
		case SPECIALROUND_MODBOSSES:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}MODified Bosses {default}(WARNING, ITS H3LL).", "SF2 Prefix", client);
		}
		case SPECIALROUND_BOSSROULETTE:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Boss Roulette.", "SF2 Prefix", client);
		}
		case SPECIALROUND_THANATOPHOBIA:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Thanatophobia.", "SF2 Prefix", client);
		}
		case SPECIALROUND_WALLHAX:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Wall Hax.", "SF2 Prefix", client);
		}
		case SPECIALROUND_SINGLEPLAYER:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Single Player.", "SF2 Prefix", client);
		}
		case SPECIALROUND_BEATBOX:
		{
			CPrintToChatAll("{royalblue}%t {collectors}%N {default}set the next special round to {lightblue}Beatbox.", "SF2 Prefix", client);
		}
	}

	return Plugin_Handled;
}

static Action Command_AddSlender(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_add_boss <name>");
		return Plugin_Handled;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetCmdArg(1, profile, sizeof(profile));

	if (!IsProfileValid(profile))
	{
		ReplyToCommand(client, "That boss does not exist!");
		return Plugin_Handled;
	}

	SF2BossProfileData data;
	g_BossProfileData.GetArray(profile, data, sizeof(data));
	if (data.IsPvEBoss)
	{
		ReplyToCommand(client, "You may not spawn PvE bosses!");
		return Plugin_Handled;
	}

	SF2NPC_BaseNPC npc = AddProfile(profile);
	if (npc.IsValid())
	{
		if (SF_IsBoxingMap() && (GetRoundState() == SF2RoundState_Escape) && NPCChaserIsBoxingBoss(npc.Index))
		{
			g_SlenderBoxingBossCount++;
		}
	}

	return Plugin_Handled;
}

static void NPCSpawn(const char[] output, int ent, int activator, float delay)
{
	if (!g_Enabled)
	{
		return;
	}
	char targetName[255];
	GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
	if (targetName[0] != '\0')
	{
		if (!StrContains(targetName, "sf2_spawn_", false))
		{
			ReplaceString(targetName, sizeof(targetName), "sf2_spawn_", "", false);
			if (!IsProfileValid(targetName))
			{
				if (!SF_IsBoxingMap())
				{
					PrintToServer("Entity: %i. That boss does not exist!",ent);
				}
				return;
			}
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			SF2NPC_BaseNPC npc;
			for(int npcIndex = 0; npcIndex <= MAX_BOSSES; npcIndex++)
			{
				npc = SF2NPC_BaseNPC(npcIndex);
				if (npc.IsValid())
				{
					npc.GetProfile(profile, sizeof(profile));
					if (strcmp(profile, targetName) == 0)
					{
						float pos[3];
						GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);
						npc.Spawn(pos);
						break;
					}
				}
			}
		}
		if (SF_IsBoxingMap())
		{
			ArrayList spawnPoint = new ArrayList();
			if (strcmp(targetName, "sf2_boxing_boss_spawn") == 0)
			{
				spawnPoint.Push(ent);
			}
			ent = -1;
			if (spawnPoint.Length > 0)
			{
				ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));
			}
			delete spawnPoint;
			if (IsValidEntity(ent))
			{
				float pos[3];
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);
				for(int npcIndex = 0; npcIndex <= MAX_BOSSES; npcIndex++)
				{
					SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(npcIndex);
					if (!npc.IsValid())
					{
						continue;
					}
					if (npc.Flags & SFF_NOTELEPORT)
					{
						continue;
					}
					npc.Spawn(pos);
					break;
				}
			}
		}
	}
	return;
}

static Action Command_AddSlenderFake(int client, int args)
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_add_boss_fake <name>");
		return Plugin_Handled;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetCmdArg(1, profile, sizeof(profile));

	if (!IsProfileValid(profile))
	{
		ReplyToCommand(client, "That boss does not exist!");
		return Plugin_Handled;
	}

	SF2BossProfileData data;
	g_BossProfileData.GetArray(profile, data, sizeof(data));
	if (data.IsPvEBoss)
	{
		ReplyToCommand(client, "You may not spawn PvE bosses!");
		return Plugin_Handled;
	}

	SF2NPC_BaseNPC npc = AddProfile(profile, SFF_FAKE);
	if (npc.IsValid())
	{
		float eyePos[3], eyeAng[3], pos[3];
		GetClientEyePosition(client, eyePos);
		GetClientEyeAngles(client, eyeAng);

		Handle trace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, client);
		TR_GetEndPosition(pos, trace);
		delete trace;

		npc.Spawn(pos);
	}

	return Plugin_Handled;
}

static Action Command_ForceState(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_setplaystate <name|#userid> <0/1>");
		return Plugin_Handled;
	}

	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 Cannot Use Command", client);
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));

	int state = StringToInt(arg2);

	char name[MAX_NAME_LENGTH];

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];

		if (IsClientSourceTV(target))
		{
			continue; //Exclude the sourcetv bot
		}

		FormatEx(name, sizeof(name), "%N", target);

		if (g_PlayerProxy[target])
		{
			continue; //Can't force proxies
		}

		if (state && g_PlayerEliminated[target])
		{
			ClientSetQueuePoints(target, 0);
			if (IsClientInGhostMode(target))
			{
				ClientSetGhostModeState(target, false);
				TF2_RespawnPlayer(target);
				TF2_RemoveCondition(target, TFCond_StealthedUserBuffFade);
				g_LastCommandTime[target] = GetEngineTime() + 0.5;
				CreateTimer(0.25, Timer_ForcePlayer, GetClientUserId(target), TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				SetClientPlayState(target, true);
			}
			CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", client, "SF2 Player Forced In Game", name);
		}
		else if (!state && !g_PlayerEliminated[target])
		{
			SetClientPlayState(target, false);

			CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", client, "SF2 Player Forced Out Of Game", name);
		}
	}

	return Plugin_Handled;
}

Action Timer_ForcePlayer(Handle timer, any userid)
{
	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(userid));
	if (!client.IsValid)
	{
		return Plugin_Stop;
	}

	char name[MAX_NAME_LENGTH];
	FormatEx(name, sizeof(name), "%N", client.index);

	client.SetPlayState(true);
	//CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", client, "SF2 Player Forced In Game", name);
	return Plugin_Stop;
}

static Action Command_AllTalkToggle(int client, int args)
{
	g_AdminAllTalk[client] = !g_AdminAllTalk[client];
	CPrintToChat(client, "{royalblue}%t {default}You will %s hear and speak to all players.", "SF2 Prefix", g_AdminAllTalk[client] ? "now" : "no longer");

	for (int target = 1; target <= MaxClients; target++)
	{
		ClientUpdateListeningFlags(target);
	}
	return Plugin_Handled;
}

static Action Command_AllTalkOn(int client, int args)
{
	g_AdminAllTalk[client] = true;

	for (int target = 1; target <= MaxClients; target++)
	{
		ClientUpdateListeningFlags(target);
	}
	return Plugin_Handled;
}

static Action Command_AllTalkOff(int client, int args)
{
	g_AdminAllTalk[client] = false;

	for (int target = 1; target <= MaxClients; target++)
	{
		ClientUpdateListeningFlags(target);
	}
	return Plugin_Handled;
}

static Action Command_ConditionToggle(int client, int args)
{
	g_IgnoreRoundWinConditionsConVar.BoolValue = !g_IgnoreRoundWinConditionsConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}Round condition is now %sabled.", "SF2 Prefix", g_IgnoreRoundWinConditionsConVar.BoolValue ? "dis" : "en");
	return Plugin_Handled;
}

static Action Command_EndlessChasing(int client, int args)
{
	g_BossChaseEndlesslyConVar.BoolValue = !g_BossChaseEndlesslyConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}Bosses will %s endlessly chase.", "SF2 Prefix", g_BossChaseEndlesslyConVar.BoolValue ? "now" : "no longer");
	return Plugin_Handled;
}

static Action Command_RedDeathTeamSwitch(int client, int args)
{
	g_IgnoreRedPlayerDeathSwapConVar.BoolValue = !g_IgnoreRedPlayerDeathSwapConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}RED players will %s respawn upon death.", "SF2 Prefix", g_IgnoreRedPlayerDeathSwapConVar.BoolValue ? "now" : "no longer");
	return Plugin_Handled;
}

static Action Command_SetQueuePoints(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 2)
	{
		ReplyToCommand(client, "Usage: sm_sf2_set_queue <name|#userid> <amount>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			arg1,
			client,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));

	int amount = StringToInt(arg2);

	char name[MAX_NAME_LENGTH];

	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];

		if (IsClientSourceTV(target))
		{
			continue;//Exclude the sourcetv bot
		}

		FormatEx(name, sizeof(name), "%N", target);

		ClientSetQueuePoints(target, amount);
		CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", client, "SF2 Set Queue Points", name);
	}

	return Plugin_Handled;
}

static Action Command_ToggleIntro(int client, int args)
{
	g_IntroEnabledConVar.BoolValue = !g_IntroEnabledConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}Intro is now %s.", "SF2 Prefix", g_IntroEnabledConVar.BoolValue ? "enabled" : "disabled");
	return Plugin_Handled;
}

static Action Command_ToggleGlobalAllTalk(int client, int args)
{
	g_AllChatConVar.BoolValue = !g_AllChatConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}All talk is now %s.", "SF2 Prefix", g_AllChatConVar.BoolValue ? "enabled" : "disabled");
	return Plugin_Handled;
}

static Action Command_ToggleBlockSuicide(int client, int args)
{
	g_BlockSuicideDuringRoundConVar.BoolValue = !g_BlockSuicideDuringRoundConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}RED players can %s suicide during rounds.", "SF2 Prefix", g_BlockSuicideDuringRoundConVar.BoolValue ? "now" : "no longer");
	return Plugin_Handled;
}

static Action Command_MaxPlayers(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_maxplayers <maxplayers 1-32>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int amount = StringToInt(arg1);

	if (amount < 1)
	{
		amount = 1;
	}
	else if (amount > 32)
	{
		amount = 32;
	}

	g_MaxPlayersConVar.IntValue = amount;
	CPrintToChat(client, "{royalblue}%t {default}Set the max players to %i.", "SF2 Prefix", amount);
	return Plugin_Handled;
}

static Action Command_MaxPlayersOverride(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_maxplayers_override <maxplayers 1-32>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int amount = StringToInt(arg1);

	if (amount < 1)
	{
		amount = 1;
	}
	else if (amount > 32)
	{
		amount = 32;
	}

	g_MaxPlayersOverrideConVar.IntValue = amount;
	CPrintToChat(client, "{royalblue}%t {default}Set the overrided max players to %i.", "SF2 Prefix", amount);
	return Plugin_Handled;
}

static Action Command_SpecialRoundMode(int client, int args)
{
	g_SpecialRoundBehaviorConVar.BoolValue = !g_SpecialRoundBehaviorConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}Set the special rounds to %s.", "SF2 Prefix", g_BlockSuicideDuringRoundConVar.BoolValue ? "always reset upon the next round" : "keep going until all players have played a special round");
	return Plugin_Handled;
}

static Action Command_InfiniteSprint(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_player_infinite_sprint_override <-1 - 1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int state = StringToInt(arg1);

	if (state < -1)
	{
		state = 1;
	}
	else if (state > 1)
	{
		state = 1;
	}

	g_PlayerInfiniteSprintOverrideConVar.IntValue = state;
	switch (state)
	{
		case -1:
		{
			CPrintToChat(client, "{royalblue}%t {default}The game will now determine whether infinite sprint is allowed or not.", "SF2 Prefix");
		}
		case 0:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully disabled infinite sprint across all maps.", "SF2 Prefix");
		}
		case 1:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully enabled infinite sprint across all maps.", "SF2 Prefix");
		}
	}
	return Plugin_Handled;
}

static Action Command_InfiniteFlashlight(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_player_infinite_flashlight_override <-1 - 1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int state = StringToInt(arg1);

	if (state < -1)
	{
		state = 1;
	}
	else if (state > 1)
	{
		state = 1;
	}

	g_PlayerInfiniteFlashlightOverrideConVar.IntValue = state;
	switch (state)
	{
		case -1:
		{
			CPrintToChat(client, "{royalblue}%t {default}The game will now determine whether infinite flashlight is allowed or not.", "SF2 Prefix");
		}
		case 0:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully disabled infinite flashlight across all maps.", "SF2 Prefix");
		}
		case 1:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully enabled infinite flashlight across all maps.", "SF2 Prefix");
		}
	}
	return Plugin_Handled;
}

static Action Command_InfiniteBlink(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sm_sf2_player_infinite_blink_override <-1 - 1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int state = StringToInt(arg1);

	if (state < -1)
	{
		state = 1;
	}
	else if (state > 1)
	{
		state = 1;
	}

	g_PlayerInfiniteBlinkOverrideConVar.IntValue = state;
	switch (state)
	{
		case -1:
		{
			CPrintToChat(client, "{royalblue}%t {default}The game will now determine whether infinite blink is allowed or not.", "SF2 Prefix");
		}
		case 0:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully disabled infinite blink across all maps.", "SF2 Prefix");
		}
		case 1:
		{
			CPrintToChat(client, "{royalblue}%t {default}Fully enabled infinite blink across all maps.", "SF2 Prefix");
		}
	}
	return Plugin_Handled;
}

static Action Command_WallHax(int client, int args)
{
	g_EnableWallHaxConVar.BoolValue = !g_EnableWallHaxConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}%s Wall Hax.", "SF2 Prefix", g_EnableWallHaxConVar.BoolValue ? "enabled" : "disabled");
	return Plugin_Handled;
}

static Action Command_KeepWeapons(int client, int args)
{
	g_PlayerKeepWeaponsConVar.BoolValue = !g_PlayerKeepWeaponsConVar.BoolValue;
	CPrintToChat(client, "{royalblue}%t {default}Lobby players can %s keep their weapons.", "SF2 Prefix", g_PlayerKeepWeaponsConVar.BoolValue ? "now" : "no longer");
	return Plugin_Handled;
}
