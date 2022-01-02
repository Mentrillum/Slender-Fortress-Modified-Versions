#if defined _sf2_commands_included
 #endinput
#endif
#define _sf2_commands_included

public void OnPluginStart()
{
	LoadTranslations("core.phrases");
	LoadTranslations("common.phrases");
	LoadTranslations("sf2.phrases");
	LoadTranslations("basetriggers.phrases");

	AddTempEntHook("World Decal", Hook_BlockDecals);
	AddTempEntHook("Entity Decal", Hook_BlockDecals);
	//AddTempEntHook("TFExplosion", Hook_DebugExplosion);

	for (int i = 0; i < MAX_BOSSES; i++) g_pPath[i] = PathFollower(_, TraceRayDontHitAnyEntity_Pathing, Path_FilterOnlyActors);
	
	// Get offsets.
	g_offsPlayerFOV = FindSendPropInfo("CBasePlayer", "m_iFOV");
	if (g_offsPlayerFOV == -1) SetFailState("Couldn't find CBasePlayer offset for m_iFOV.");
	
	g_offsPlayerDefaultFOV = FindSendPropInfo("CBasePlayer", "m_iDefaultFOV");
	if (g_offsPlayerDefaultFOV == -1) SetFailState("Couldn't find CBasePlayer offset for m_iDefaultFOV.");
	
	g_offsPlayerFogCtrl = FindSendPropInfo("CBasePlayer", "m_PlayerFog.m_hCtrl");
	if (g_offsPlayerFogCtrl == -1) LogError("Couldn't find CBasePlayer offset for m_PlayerFog.m_hCtrl!");
	
	g_offsPlayerPunchAngle = FindSendPropInfo("CBasePlayer", "m_vecPunchAngle");
	if (g_offsPlayerPunchAngle == -1) LogError("Couldn't find CBasePlayer offset for m_vecPunchAngle!");
	
	g_offsPlayerPunchAngleVel = FindSendPropInfo("CBasePlayer", "m_vecPunchAngleVel");
	if (g_offsPlayerPunchAngleVel == -1) LogError("Couldn't find CBasePlayer offset for m_vecPunchAngleVel!");
	
	g_offsFogCtrlEnable = FindSendPropInfo("CFogController", "m_fog.enable");
	if (g_offsFogCtrlEnable == -1) LogError("Couldn't find CFogController offset for m_fog.enable!");
	
	g_offsFogCtrlEnd = FindSendPropInfo("CFogController", "m_fog.end");
	if (g_offsFogCtrlEnd == -1) LogError("Couldn't find CFogController offset for m_fog.end!");
	
	g_offsCollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	if (g_offsCollisionGroup == -1)  LogError("Couldn't find CBaseEntity offset for m_CollisionGroup!");
	
	g_hPages = new ArrayList(sizeof(SF2PageEntityData));
	g_hPageMusicRanges = new ArrayList(3);
	
	// Register console variables.
	g_cvVersion = CreateConVar("sf2modified_version", PLUGIN_VERSION, "The current version of Slender Fortress. DO NOT TOUCH!", FCVAR_SPONLY | FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_cvVersion.SetString(PLUGIN_VERSION);
	
	g_cvEnabled = CreateConVar("sf2_enabled", "1", "Enable/Disable the Slender Fortress gamemode. This will take effect on map change.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_cvSlenderMapsOnly = CreateConVar("sf2_slendermapsonly", "1", "Only enable the Slender Fortress gamemode on map names prefixed with \"slender_\" or \"sf2_\".");
	
	g_cvGraceTime = CreateConVar("sf2_gracetime", "30.0");
	g_cvIntroEnabled = CreateConVar("sf2_intro_enabled", "1");
	g_cvIntroDefaultHoldTime = CreateConVar("sf2_intro_default_hold_time", "9.0");
	g_cvIntroDefaultFadeTime = CreateConVar("sf2_intro_default_fade_time", "1.0");
	
	g_cvBlockSuicideDuringRound = CreateConVar("sf2_block_suicide_during_round", "0");
	
	g_cvAllChat = CreateConVar("sf2_alltalk", "0");
	g_cvAllChat.AddChangeHook(OnConVarChanged);
	
	g_cvPlayerVoiceDistance = CreateConVar("sf2_player_voice_distance", "800.0", "The maximum distance RED can communicate in voice chat. Set to 0 if you want them to be heard at all times.", _, true, 0.0);
	g_cvPlayerVoiceWallScale = CreateConVar("sf2_player_voice_scale_blocked", "0.5", "The distance required to hear RED in voice chat will be multiplied by this amount if something is blocking them.");
	
	g_cvPlayerViewbobEnabled = CreateConVar("sf2_player_viewbob_enabled", "1", "Enable/Disable player viewbobbing.", _, true, 0.0, true, 1.0);
	g_cvPlayerViewbobEnabled.AddChangeHook(OnConVarChanged);
	g_cvPlayerViewbobHurtEnabled = CreateConVar("sf2_player_viewbob_hurt_enabled", "0", "Enable/Disable player view tilting when hurt.", _, true, 0.0, true, 1.0);
	g_cvPlayerViewbobHurtEnabled.AddChangeHook(OnConVarChanged);
	g_cvPlayerViewbobSprintEnabled = CreateConVar("sf2_player_viewbob_sprint_enabled", "0", "Enable/Disable player step viewbobbing when sprinting.", _, true, 0.0, true, 1.0);
	g_cvPlayerViewbobSprintEnabled.AddChangeHook(OnConVarChanged);
	g_cvGravity = FindConVar("sv_gravity");
	g_cvGravity.AddChangeHook(OnConVarChanged);

	g_cvPlayerShakeEnabled = CreateConVar("sf2_player_shake_enabled", "1", "Enable/Disable player view shake during boss encounters.", _, true, 0.0, true, 1.0);
	g_cvPlayerShakeEnabled.AddChangeHook(OnConVarChanged);
	g_cvPlayerShakeFrequencyMax = CreateConVar("sf2_player_shake_frequency_max", "255", "Maximum frequency value of the shake. Should be a value between 1-255.", _, true, 1.0, true, 255.0);
	g_cvPlayerShakeAmplitudeMax = CreateConVar("sf2_player_shake_amplitude_max", "5", "Maximum amplitude value of the shake. Should be a value between 1-16.", _, true, 1.0, true, 16.0);
	
	g_cvPlayerBlinkRate = CreateConVar("sf2_player_blink_rate", "0.33", "How long (in seconds) each bar on the player's Blink meter lasts.", _, true, 0.0);
	g_cvPlayerBlinkHoldTime = CreateConVar("sf2_player_blink_holdtime", "0.15", "How long (in seconds) a player will stay in Blink mode when he or she blinks.", _, true, 0.0);
	
	g_cvUltravisionEnabled = CreateConVar("sf2_player_ultravision_enabled", "1", "Enable/Disable player Ultravision. This helps players see in the dark when their Flashlight is off or unavailable.", _, true, 0.0, true, 1.0);
	g_cvUltravisionRadiusRed = CreateConVar("sf2_player_ultravision_radius_red", "600.0");
	g_cvUltravisionRadiusBlue = CreateConVar("sf2_player_ultravision_radius_blue", "1600.0");
	g_cvNightvisionRadius = CreateConVar("sf2_player_nightvision_radius", "900.0");
	g_cvUltravisionBrightness = CreateConVar("sf2_player_ultravision_brightness", "-2");
	g_cvNightvisionEnabled = CreateConVar("sf2_player_flashlight_isnightvision", "0", "Enable/Disable flashlight replacement with nightvision",_, true, 0.0, true, 1.0);
	
	g_cvGhostModeConnection = CreateConVar("sf2_ghostmode_no_tolerance", "0", "If set on 1, it will instant kick out the client of the Ghost mode if the client has timed out.");
	g_cvGhostModeConnectionCheck = CreateConVar("sf2_ghostmode_check_connection", "1", "Checks a player's connection while in Ghost Mode. If the check fails, the client is booted out of Ghost Mode and the action and client's SteamID is logged in the main SF2 log.");
	g_cvGhostModeConnectionTolerance = CreateConVar("sf2_ghostmode_connection_tolerance", "5.0", "If sf2_ghostmode_check_connection is set to 1 and the client has timed out for at least this amount of time, the client will be booted out of Ghost Mode.");
	
	g_cv20Dollars = CreateConVar("sf2_20dollarmode", "0", "Enable/Disable $20 mode.", _, true, 0.0, true, 1.0);
	g_cv20Dollars.AddChangeHook(OnConVarChanged);
	
	g_cvMaxPlayers = CreateConVar("sf2_maxplayers", "6", "The maximum amount of players that can be in one round.", _, true, 1.0);
	g_cvMaxPlayers.AddChangeHook(OnConVarChanged);
	
	g_cvMaxPlayersOverride = CreateConVar("sf2_maxplayers_override", "-1", "Overrides the maximum amount of players that can be in one round.", _, true, -1.0);
	g_cvMaxPlayersOverride.AddChangeHook(OnConVarChanged);
	
	g_cvCampingEnabled = CreateConVar("sf2_anticamping_enabled", "1", "Enable/Disable anti-camping system for RED.", _, true, 0.0, true, 1.0);
	g_cvCampingMaxStrikes = CreateConVar("sf2_anticamping_maxstrikes", "4", "How many 5-second intervals players are allowed to stay in one spot before he/she is forced to suicide.", _, true, 0.0);
	g_cvCampingStrikesWarn = CreateConVar("sf2_anticamping_strikeswarn", "2", "The amount of strikes left where the player will be warned of camping.");
	g_cvExitCampingTimeAllowed = CreateConVar("sf2_exitcamping_allowedtime", "25.0", "The amount of time a player can stay near the exit before being flagged as camper.");
	g_cvCampingMinDistance = CreateConVar("sf2_anticamping_mindistance", "128.0", "Every 5 seconds the player has to be at least this far away from his last position 5 seconds ago or else he'll get a strike.");
	g_cvCampingNoStrikeSanity = CreateConVar("sf2_anticamping_no_strike_sanity", "0.1", "The camping system will NOT give any strikes under any circumstances if the players's Sanity is missing at least this much of his maximum Sanity (max is 1.0).");
	g_cvCampingNoStrikeBossDistance = CreateConVar("sf2_anticamping_no_strike_boss_distance", "512.0", "The camping system will NOT give any strikes under any circumstances if the player is this close to a boss (ignoring LOS).");
	g_cvBossMain = CreateConVar("sf2_boss_main", "slenderman", "The name of the main boss (its profile name, not its display name)");
	g_cvBossProfileOverride = CreateConVar("sf2_boss_profile_override", "", "Overrides which boss will be chosen next. Only applies to the first boss being chosen.");
	g_cvDifficulty = CreateConVar("sf2_difficulty", "1", "Difficulty of the game. 1 = Normal, 2 = Hard, 3 = Insane, 4 = Nightmare, 5 = Apollyon.", _, true, 1.0, true, 5.0);
	g_cvDifficulty.AddChangeHook(OnConVarChanged);

	g_cvCameraOverlay = CreateConVar("sf2_camera_overlay", SF2_OVERLAY_DEFAULT, "The overlay directory for what RED players will see with No Filmgrain off. This value shouldn't be updated in realtime and should be set before a map changes fully.");
	g_cvOverlayNoGrain = CreateConVar("sf2_camera_overlay_nograin", SF2_OVERLAY_DEFAULT_NO_FILMGRAIN, "The overlay directory for what RED players will see with No Filmgrain on. This value shouldn't be updated in realtime and should be set before a map changes fully.");
	g_cvGhostOverlay = CreateConVar("sf2_camera_ghost_overlay", SF2_OVERLAY_GHOST, "The overlay directory for what BLU ghosted players will see. This value shouldn't be updated in realtime and should be set before a map changes fully.");
	
	g_cvSpecialRoundBehavior = CreateConVar("sf2_specialround_mode", "0", "0 = Special Round resets on next round, 1 = Special Round keeps going until all players have played (not counting spectators, recently joined players, and those who reset their queue points during the round)", _, true, 0.0, true, 1.0);
	g_cvSpecialRoundForce = CreateConVar("sf2_specialround_forceenable", "-1", "Sets whether a Special Round will occur on the next round or not.", _, true, -1.0, true, 1.0);
	g_cvSpecialRoundOverride = CreateConVar("sf2_specialround_forcetype", "-1", "Sets the type of Special Round that will be chosen on the next Special Round. Set to -1 to let the game choose.", _, true, -1.0);
	g_cvSpecialRoundInterval = CreateConVar("sf2_specialround_interval", "5", "If this many rounds are completed, the next round will be a Special Round.", _, true, 0.0);
	
	g_cvNewBossRoundBehavior = CreateConVar("sf2_newbossround_mode", "0", "0 = boss selection will return to normal after the boss round, 1 = the new boss will continue being the boss until all players in the server have played against it (not counting spectators, recently joined players, and those who reset their queue points during the round).", _, true, 0.0, true, 1.0);
	g_cvNewBossRoundInterval = CreateConVar("sf2_newbossround_interval", "3", "If this many rounds are completed, the next round's boss will be randomly chosen, but will not be the main boss.", _, true, 0.0);
	g_cvNewBossRoundForce = CreateConVar("sf2_newbossround_forceenable", "-1", "Sets whether a new boss will be chosen on the next round or not. Set to -1 to let the game choose.", _, true, -1.0, true, 1.0);
	
	g_cvIgnoreRoundWinConditions = CreateConVar("sf2_ignore_round_win_conditions", "0", "If set to 1, round will not end when RED is eliminated.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvIgnoreRoundWinConditions.AddChangeHook(OnConVarChanged);
	g_cvIgnoreRedPlayerDeathSwap = CreateConVar("sf2_ignore_red_player_death_team_switch", "0", "If set to 1, RED players will not switch back to the BLU team.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvIgnoreRedPlayerDeathSwap.AddChangeHook(OnConVarChanged);
	
	g_cvDisableBossCrushFix = CreateConVar("sf2_disable_boss_crush_fix", "0", "Enables/disables the boss crushing patch from Secret Update 4, should only be turned on if the server introduces players getting stuck in bosses.", _, true, 0.0, true, 1.0);

	g_cvEnableWallHax = CreateConVar("sf2_enable_wall_hax", "0", "Enables/disables the Wall Hax special round without needing to turn on Wall Hax. This will not force the difficulty to Insane and will show player + boss outlines.", _, true, 0.0, true, 1.0);
	
	g_cvTimeLimit = CreateConVar("sf2_timelimit_default", "300", "The time limit of the round. Maps can change the time limit.", _, true, 0.0);
	g_cvTimeLimitEscape = CreateConVar("sf2_timelimit_escape_default", "90", "The time limit to escape. Maps can change the time limit.", _, true, 0.0);
	g_cvTimeGainFromPageGrab = CreateConVar("sf2_time_gain_page_grab", "12", "The time gained from grabbing a page. Maps can change the time gain amount.");
	
	g_cvWarmupRound = CreateConVar("sf2_warmupround", "1", "Enables/disables Warmup Rounds after the \"Waiting for Players\" phase.", _, true, 0.0, true, 1.0);
	g_cvWarmupRoundNum = CreateConVar("sf2_warmupround_num", "1", "Sets the amount of Warmup Rounds that occur after the \"Waiting for Players\" phase.", _, true, 0.0);
	
	g_cvPlayerProxyWaitTime = CreateConVar("sf2_player_proxy_waittime", "35", "How long (in seconds) after a player was chosen to be a Proxy must the system wait before choosing him again.");
	g_cvPlayerProxyAsk = CreateConVar("sf2_player_proxy_ask", "0", "Set to 1 if the player can choose before becoming a Proxy, set to 0 to force.");

	g_cvPlayerAFKTime = CreateConVar("sf2_player_afk_time", "60.0", "Amount of time before a player is considered AFK, set to 0 to disable.", _, true, 0.0);

	g_cvPlayerInfiniteSprintOverride = CreateConVar("sf2_player_infinite_sprint_override", "-1", "1 = infinite sprint, 0 = never have infinite sprint, -1 = let the game choose.", _, true, -1.0, true, 1.0);
	g_cvPlayerInfiniteFlashlightOverride = CreateConVar("sf2_player_infinite_flashlight_override", "-1", "1 = infinite flashlight, 0 = never have infinite flashlight, -1 = let the game choose.", _, true, -1.0, true, 1.0);
	g_cvPlayerInfiniteBlinkOverride = CreateConVar("sf2_player_infinite_blink_override", "-1", "1 = infinite blink, 0 = never have infinite blink, -1 = let the game choose.", _, true, -1.0, true, 1.0);
	
	g_cvRaidMap = CreateConVar("sf2_israidmap", "0", "Set to 1 if the map is a raid map.", _, true, 0.0, true, 1.0);
	
	g_cvBossChaseEndlessly = CreateConVar("sf2_bosseschaseendlessly", "0", "Set to 1 if you want bosses chasing you forever.", _, true, 0.0, true, 1.0);
	
	g_cvProxyMap = CreateConVar("sf2_isproxymap", "0", "Set to 1 if the map is a proxy survival map.", _, true, 0.0, true, 1.0);
	
	g_cvBoxingMap = CreateConVar("sf2_isboxingmap", "0", "Set to 1 if the map is a boxing map.", _, true, 0.0, true, 1.0);
	
	g_cvRenevantMap = CreateConVar("sf2_isrenevantmap", "0", "Set to 1 if the map uses Renevant logic.", _, true, 0.0, true, 1.0);
	g_cvDefaultRenevantBoss = CreateConVar("sf2_renevant_boss_default", "", "Determine what boss should spawn during the Single Boss wave, if nothing is inputted, Single Boss will not trigger.");
	g_cvDefaultRenevantBossMessage = CreateConVar("sf2_renevant_bossspawn_message", "", "This is what will be used as the spawn message for the Single Boss wave.");

	g_cvSlaughterRunMap = CreateConVar("sf2_isslaughterrunmap", "0", "Set to 1 if the map is a slaughter run map.", _, true, 0.0, true, 1.0);

	g_cvSlaughterRunDivisibleTime = CreateConVar("sf2_slaughterrun_divide_time", "125.0", "Determines how much the average time should be divided by in Slaughter Run, the lower the number, the longer the bosses spawn.", _, true, 0.0);
	
	g_cvUseAlternateConfigDirectory = CreateConVar("sf2_alternateconfigs", "0", "Set to 1 if the server should pick up the configs from data/.", _, true, 0.0, true, 1.0);

	g_cvPlayerKeepWeapons = CreateConVar("sf2_player_keep_weapons", "0", "Set to 1 if players can keep their non-melee weapons outside of PvP arenas.", _, true, 0.0, true, 1.0);

	g_cvRestartSession = CreateConVar("sf2_dont_touch_this", "0", "Seriously, do not touch this.", _, true, 0.0, true, 1.0);
	g_cvRestartSession.AddChangeHook(OnConVarChanged);

	g_cvSurvivalMap = CreateConVar("sf2_issurvivalmap", "0", "Set to 1 if the map is a survival map.", _, true, 0.0, true, 1.0);
	g_cvTimeEscapeSurvival = CreateConVar("sf2_survival_time_limit", "30", "when X secs left the mod will turn back the Survive! text to Escape! text", _, true, 0.0);

	g_cvFullyEnableSpectator = CreateConVar("sf2_enable_spectator", "0", "Determines if all spectator restrictions should be disabled.", _, true, 0.0, true, 1.0);

	g_cvMaxRounds = FindConVar("mp_maxrounds");
	
	g_hHudSync = CreateHudSynchronizer();
	g_hHudSync2 = CreateHudSynchronizer();
	g_hHudSync3 = CreateHudSynchronizer();
	g_hRoundTimerSync = CreateHudSynchronizer();
	g_hCookie = RegClientCookie("sf2_newcookies", "", CookieAccess_Private);
	
	// Register console commands.
	RegConsoleCmd("sm_sf2", Command_MainMenu);
	RegConsoleCmd("sm_sl", Command_MainMenu);
	RegConsoleCmd("sm_slender", Command_MainMenu);
	RegConsoleCmd("sm_sltutorial", Command_Tutorial);
	RegConsoleCmd("sm_sltuto", Command_Tutorial);
	RegConsoleCmd("sm_sf2tutorial", Command_Tutorial);
	RegConsoleCmd("sm_sf2tuto", Command_Tutorial);
	RegConsoleCmd("sm_slupdate", Command_Update);
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
	
	// Hook sounds.
	AddNormalSoundHook(view_as<NormalSHook>(Hook_NormalSound));
	
	AddTempEntHook("Fire Bullets", Hook_TEFireBullets);

	steamtools = LibraryExists("SteamTools");
	
	steamworks = LibraryExists("SteamWorks");

	InitializeBossProfiles();
	
	NPCInitialize();
	
	SetupMenus();
	
	Tutorial_Initialize();
	
	SetupAdminMenu();

	SetupPlayerGroups();
	
	PvP_Initialize();

	SetupCustomMapEntities();
	
	// @TODO: When cvars are finalized, set this to true.
	AutoExecConfig(false);
#if defined DEBUG
	InitializeDebug();
#endif
}

public Action Hook_BlockDecals(const char[] te_name, const int[] Players, int numClients, float delay)
{
	return Plugin_Stop;
}

//	==========================================================
//	COMMANDS AND COMMAND HOOK FUNCTIONS
//	==========================================================

public Action Command_Help(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayMenu(g_hMenuHelp, iClient, 30);
	return Plugin_Handled;
}

public Action Command_Settings(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayMenu(g_hMenuSettings, iClient, 30);
	return Plugin_Handled;
}

public Action Command_Credits(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayMenu(g_hMenuCredits, iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Action Command_BossList(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayBossList(iClient);
	return Plugin_Handled;
}

public Action Command_NoPoints(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	if(!g_bPlayerNoPoints[iClient])
	{
		CPrintToChat(iClient, "%T", "SF2 AFK On", iClient);
		g_bPlayerNoPoints[iClient] = true;
		AFK_SetTime(iClient);
	}
	else
	{
		CPrintToChat(iClient, "%T", "SF2 AFK Off", iClient);
		g_bPlayerNoPoints[iClient] = false;
		AFK_SetTime(iClient);
	}
	return Plugin_Handled;
}

public Action Command_ToggleFlashlight(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (!IsClientInGame(iClient) || !IsPlayerAlive(iClient)) return Plugin_Handled;
	
	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding() && !DidClientEscape(iClient))
	{
		if (GetGameTime() >= ClientGetFlashlightNextInputTime(iClient))
		{
			ClientHandleFlashlight(iClient);
		}
	}
	
	return Plugin_Handled;
}

public Action Command_SprintOn(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (IsPlayerAlive(iClient) && !g_bPlayerEliminated[iClient])
	{
		ClientHandleSprint(iClient, true);
	}
	
	return Plugin_Handled;
}

public Action Command_SprintOff(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (IsPlayerAlive(iClient) && !g_bPlayerEliminated[iClient])
	{
		ClientHandleSprint(iClient, false);
	}
	
	return Plugin_Handled;
}

public Action Command_BlinkOn(int iClient, int iArgs)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding())
	{
		if (!g_bPlayerEliminated[iClient] && !DidClientEscape(iClient))
		{
			g_bPlayerHoldingBlink[iClient] = true;
			ClientBlink(iClient);
		}
	}

	return Plugin_Handled;
}

public Action Command_BlinkOff(int iClient, int iArgs)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (!IsRoundInWarmup() && !IsRoundInIntro() && !IsRoundEnding())
	{
		if (!g_bPlayerEliminated[iClient] && !DidClientEscape(iClient))
		{
			g_bPlayerHoldingBlink[iClient] = false;
		}
	}

	return Plugin_Handled;
}

public Action Command_BlockItemPreset(int client, int args)
{    
	return Plugin_Stop;
} 

public Action DevCommand_BossPackVote(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	InitiateBossPackVote(iClient);
	return Plugin_Handled;
}

public Action Command_NoPointsAdmin(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_nopoints <name|#userid> <0/1>");
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			iClient,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	bool bMode;
	if (args > 1)
	{
		char arg2[32];
		GetCmdArg(2, arg2, sizeof(arg2));
		bMode = view_as<bool>(StringToInt(arg2));
	}
	
	for (int i = 0; i < target_count; i++)
	{
		int iTarget = target_list[i];
		if (IsClientSourceTV(iTarget)) continue;//Exclude the sourcetv bot
		
		g_bAdminNoPoints[iClient] = args > 1 ? bMode : !g_bAdminNoPoints[iClient];
		if(g_bAdminNoPoints[iClient])
		{
			CPrintToChat(iClient, "%T", "SF2 AFK On", iClient);
		}
		else
		{
			CPrintToChat(iClient, "%T", "SF2 AFK Off", iClient);
		}
		
		AFK_SetTime(iClient);
	}
	
	return Plugin_Handled;
}

public Action Command_MainMenu(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	DisplayMenu(g_hMenuMain, iClient, 30);
	return Plugin_Handled;
}

public Action Command_Tutorial(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	//Tutorial_HandleClient(iClient);
	return Plugin_Handled;
}

public Action Command_Update(int iClient, int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	DisplayMenu(g_hMenuUpdate, iClient, 30);
	return Plugin_Handled;
}

public Action Command_Next(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayQueuePointsMenu(iClient);
	return Plugin_Handled;
}


public Action Command_Group(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	DisplayGroupMainMenuToClient(iClient);
	return Plugin_Handled;
}

public Action Command_GroupName(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_slgroupname <name>");
		return Plugin_Handled;
	}
	
	int iGroupIndex = ClientGetPlayerGroup(iClient);
	if (!IsPlayerGroupActive(iGroupIndex))
	{
		CPrintToChat(iClient, "%T", "SF2 Group Does Not Exist", iClient);
		return Plugin_Handled;
	}
	
	if (GetPlayerGroupLeader(iGroupIndex) != iClient)
	{
		CPrintToChat(iClient, "%T", "SF2 Not Group Leader", iClient);
		return Plugin_Handled;
	}
	
	char sGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetCmdArg(1, sGroupName, sizeof(sGroupName));
	if (sGroupName[0] == '\0')
	{
		CPrintToChat(iClient, "%T", "SF2 Invalid Group Name", iClient);
		return Plugin_Handled;
	}
	
	char sOldGroupName[SF2_MAX_PLAYER_GROUP_NAME_LENGTH];
	GetPlayerGroupName(iGroupIndex, sOldGroupName, sizeof(sOldGroupName));
	SetPlayerGroupName(iGroupIndex, sGroupName);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		if (ClientGetPlayerGroup(i) != iGroupIndex) continue;
		CPrintToChat(i, "%T", "SF2 Group Name Set", i, sOldGroupName, sGroupName);
	}
	
	return Plugin_Handled;
}
public Action Command_GhostMode(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (IsRoundEnding() || IsRoundInWarmup() || !g_bPlayerEliminated[iClient] || !IsClientParticipating(iClient) || g_bPlayerProxy[iClient] || IsClientInPvP(iClient) || IsClientInKart(iClient) || TF2_IsPlayerInCondition(iClient,TFCond_Taunting)|| TF2_IsPlayerInCondition(iClient,TFCond_Charging) || g_flLastCommandTime[iClient] > GetEngineTime())
	{
		CPrintToChat(iClient, "{red}%T", "SF2 Ghost Mode Not Allowed", iClient);
		return Plugin_Handled;
	}
	if (!IsClientInGhostMode(iClient))
	{
		TF2_RespawnPlayer(iClient);
		ClientSetGhostModeState(iClient, true);
		HandlePlayerHUD(iClient);
		TF2_AddCondition(iClient, TFCond_StealthedUserBuffFade, -1.0);
	
		CPrintToChat(iClient, "{dodgerblue}%T", "SF2 Ghost Mode Enabled", iClient);
	}
	else
	{
		ClientSetGhostModeState(iClient, false);
		TF2_RespawnPlayer(iClient);
		TF2_RemoveCondition(iClient, TFCond_StealthedUserBuffFade);

		CPrintToChat(iClient, "{dodgerblue}%T", "SF2 Ghost Mode Disabled", iClient);
	}
	g_flLastCommandTime[iClient] = GetEngineTime()+0.5;
	return Plugin_Handled;
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs) {
	if (!g_bPlayerCalledForNightmare[client])
		g_bPlayerCalledForNightmare[client] = (StrContains(sArgs, "nightmare", false) != -1 || StrContains(sArgs, "Nightmare", false) != -1);

	if (g_hTimerChangeClientName[client] != null)
	{
		Handle timer = g_hTimerChangeClientName[client];
		TriggerTimer(timer);
		KillTimer(timer);
	}

	if (!g_bEnabled || g_cvAllChat.BoolValue || SF_IsBoxingMap()) return Plugin_Continue;

	if (!IsRoundEnding()) {
		bool bSayTeam = strcmp(command, "say_team") == 0;

		if (g_bPlayerEliminated[client]) 
		{
			if (IsClientInGame(client) && !IsPlayerAlive(client) && GetClientTeam(client) == TFTeam_Red)
				return Plugin_Stop; // Plugin_Stop in this case stops message AND post hook so bot won't see message in OnClientSayCommand_Post()

			char szMessage[256];
			FormatEx(szMessage, sizeof szMessage, "{blue}%N:{default} %s", client, sArgs);
			//Broadcast the msg to the source tv, if the server has one.
			PrintToSourceTV(szMessage);

			if (!bSayTeam) 
			{
				if (sArgs[0] == '!' || sArgs[1] == '!')	// Don't let ! commands get detected twice
				{
					FakeClientCommandEx(client, "say_team \" %s\"", sArgs);
				}
				else
				{
					FakeClientCommandEx(client, "say_team %s", sArgs);
				}
				return Plugin_Stop;
			}
		}

		if (!bSayTeam) 
		{
			char szMessage[256];
			FormatEx(szMessage, sizeof szMessage, "{red}%N:{default} %s", client, sArgs);
			//Broadcast the msg to the source tv, if the server has one.
			PrintToSourceTV(szMessage);
		}
	}
	
	return Plugin_Continue;
}
public Action Hook_CommandSuicideAttempt(int iClient, const char[] command,int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (GetClientTeam(iClient) == TFTeam_Spectator) return Plugin_Continue;
	if (IsClientInGhostMode(iClient)) return Plugin_Handled;
	
	if (IsRoundInIntro() && !g_bPlayerEliminated[iClient]) return Plugin_Handled;
	
	if (g_cvBlockSuicideDuringRound.BoolValue)
	{
		if (!g_bRoundGrace && !g_bPlayerEliminated[iClient] && !DidClientEscape(iClient))
		{
			return Plugin_Handled;
		}
	}
	
	if (IsClientInPvP(iClient)) //Nobody asked you to cheat your way out of PvP to miss a kill.
	{
		return Plugin_Handled;
	}

	if (IsClientInKart(iClient))
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}
public Action Hook_CommandPreventJoinTeam(int iClient, const char[] command,int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (GetClientTeam(iClient) == TFTeam_Spectator) return Plugin_Continue;
	if (IsClientInGhostMode(iClient)) return Plugin_Handled;
	
	if (IsRoundInIntro() && !g_bPlayerEliminated[iClient]) return Plugin_Handled;
	
	if (g_cvBlockSuicideDuringRound.BoolValue)
	{
		if (!g_bRoundGrace && !g_bPlayerEliminated[iClient] && !DidClientEscape(iClient))
		{
			return Plugin_Handled;
		}
	}
	
	if (IsClientInPvP(iClient)) //Nobody asked you to cheat your way out of PvP to miss a kill.
	{
		return Plugin_Handled;
	}
	
	if (IsClientInKart(iClient))
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Hook_BlockCommand(int iClient, const char[] command,int argc) 
{
	if (!g_bEnabled) return Plugin_Continue;
	return Plugin_Handled;
}

public Action Hook_BlockLoadout(int iClient, const char[] command,int argc) 
{
	if (!g_bEnabled) return Plugin_Continue;
	if (!g_bRoundGrace && !g_bPlayerEliminated[iClient] && !DidClientEscape(iClient)) return Plugin_Handled;
	return Plugin_Continue;
}

public Action Hook_CommandBlockInGhostMode(int iClient, const char[] command,int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (IsClientInGhostMode(iClient)) return Plugin_Handled;
	if (IsRoundInIntro() && !g_bPlayerEliminated[iClient]) return Plugin_Handled;
	
	return Plugin_Continue;
}

public Action Hook_CommandVoiceMenu(int iClient, const char[] command,int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (IsClientInGhostMode(iClient))
	{
		ClientGhostModeNextTarget(iClient);
		return Plugin_Handled;
	}
	
	if (g_bPlayerProxy[iClient])
	{
		int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]);
		if (iMaster != -1)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_proxy_idle", sBuffer, sizeof(sBuffer));

			if (sBuffer[0] != '\0' && GetGameTime() >= g_flPlayerProxyNextVoiceSound[iClient])
			{
				int iChannel = g_iSlenderProxyIdleChannel[iMaster];
				int iLevel = g_iSlenderProxyIdleLevel[iMaster];
				int iFlags = g_iSlenderProxyIdleFlags[iMaster];
				float flVolume = g_flSlenderProxyIdleVolume[iMaster];
				int iPitch = g_iSlenderProxyIdlePitch[iMaster];

				EmitSoundToAll(sBuffer, iClient, iChannel, iLevel, iFlags, flVolume, iPitch);
				float flCooldownMin = g_flSlenderProxyIdleCooldownMin[iMaster];
				float flCooldownMax = g_flSlenderProxyIdleCooldownMax[iMaster];
				
				g_flPlayerProxyNextVoiceSound[iClient] = GetGameTime() + GetRandomFloat(flCooldownMin, flCooldownMax);
			}
		}
	}
	
	return Plugin_Continue;
}

public Action Command_ClientKillDeathcam(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 2)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_kill_client <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
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
			iClient,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		if (!IsClientInGame(target) || !IsPlayerAlive(target) || g_bPlayerEliminated[target] || IsClientInGhostMode(target)) continue;
			
		float flBuffer[3];
		GetClientAbsOrigin(target, flBuffer);
		ClientStartDeathCam(target, StringToInt(arg2), flBuffer, true);
		g_bPlayerDied1Up[target] = false;
		g_bPlayerIn1UpCondition[target] = false;
		KillClient(target);
		
	}
	
	return Plugin_Handled;
}

public Action Command_ClientPerformScare(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 2)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_scare <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
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
			iClient,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		ClientPerformScare(target, StringToInt(arg2));
	}
	
	return Plugin_Handled;
}

public Action Command_SpawnSlender(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args == 0)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_spawn_boss <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(StringToInt(arg1));
	if (NPCGetUniqueID(Npc.Index) == -1) return Plugin_Handled;
	
	float eyePos[3], eyeAng[3], endPos[3];
	GetClientEyePosition(iClient, eyePos);
	GetClientEyeAngles(iClient, eyeAng);
	
	Handle hTrace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, iClient);
	TR_GetEndPosition(endPos, hTrace);
	delete hTrace;
	
	SpawnSlender(Npc, endPos);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.GetProfile(sProfile, sizeof(sProfile));
	
	CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Spawned Boss", iClient);

	return Plugin_Handled;
}

public Action Command_SpawnAllSlenders(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	float eyePos[3], eyeAng[3], endPos[3];
	GetClientEyePosition(iClient, eyePos);
	GetClientEyeAngles(iClient, eyeAng);
	
	Handle hTrace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, iClient);
	TR_GetEndPosition(endPos, hTrace);
	delete hTrace;
	
	SF2NPC_BaseNPC Npc;
	for(int iNpc;iNpc<=MAX_BOSSES;iNpc++)
	{
		Npc = view_as<SF2NPC_BaseNPC>(iNpc);
		if(Npc.IsValid()) SpawnSlender(Npc, endPos);
	}

	CPrintToChat(iClient, "{royalblue}%t{default}Spawned all bosses at your location.", "SF2 Prefix");

	return Plugin_Handled;
}

public Action Command_RemoveSlender(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args == 0)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_remove_boss <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int iBossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(iBossIndex) == -1) return Plugin_Handled;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	if (SF_IsBoxingMap() && (GetRoundState() == SF2RoundState_Escape) && NPCChaserIsBoxingBoss(iBossIndex))
	{
		g_iSlenderBoxingBossCount -= 1;
	}
	
	if (MusicActive() && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES) && BossHasMusic(sProfile) && BossMatchesCurrentMusic(sProfile))
	{
		NPCStopMusic();
	}
		
	NPCRemove(iBossIndex);
	
	CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Removed Boss", iClient);
	
	return Plugin_Handled;
}

public Action Command_RemoveAllSlenders(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (!SF_IsBoxingMap())
	{
		for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
		{
			if (NPCGetUniqueID(iNPCIndex) == -1) continue;
			NPCRemove(iNPCIndex);
		}
		CPrintToChat(iClient, "{royalblue}%t{default}Removed all bosses.", "SF2 Prefix", iClient);
	}
	else
	{
		CPrintToChat(iClient, "{royalblue}%t{default}Cannot use this command in Boxing maps.", "SF2 Prefix", iClient);
	}

	if (MusicActive() && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
	{
		NPCStopMusic();
	}

	return Plugin_Handled;
}

public Action Command_GetBossIndexes(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	char sMessage[512];
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	if (!IsValidClient(iClient))
	{
		LogMessage("Active Boss Indexes:");
		LogMessage("----------------------------");
	}
	else
	{
		ClientCommand(iClient, "echo Active Boss Indexes:");
		ClientCommand(iClient, "echo ----------------------------");
	}
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		
		NPCGetProfile(i, sProfile, sizeof(sProfile));
		
		FormatEx(sMessage, sizeof(sMessage), "%d - %s", i, sProfile);
		if (NPCGetFlags(i) & SFF_FAKE)
		{
			StrCat(sMessage, sizeof(sMessage), " (fake)");
		}
		
		if (g_iSlenderCopyMaster[i] != -1)
		{
			char sCat[64];
			FormatEx(sCat, sizeof(sCat), " (copy of %d)", g_iSlenderCopyMaster[i]);
			StrCat(sMessage, sizeof(sMessage), sCat);
		}
		
		if (IsValidClient(iClient))
		{
			ClientCommand(iClient, "echo %s", sMessage);
		}
		else
		{
			LogMessage("%s", sMessage);
		}
	}
	
	if (IsValidClient(iClient))
	{
		ClientCommand(iClient, "echo ----------------------------");
		
		ReplyToCommand(iClient, "Printed active boss indexes to your console!");
	}
	else
	{
		LogMessage("----------------------------");

		LogMessage("Printed active boss indexes to the server console!");
	}
	
	return Plugin_Handled;
}

public Action Command_SlenderAttackWaiters(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 2)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_boss_attack_waiters <bossindex 0-%d> <0/1>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int iBossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(iBossIndex) == -1) return Plugin_Handled;
	
	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int iBossFlags = NPCGetFlags(iBossIndex);
	
	bool bState = view_as<bool>(StringToInt(arg2));
	bool bOldState = view_as<bool>(iBossFlags & SFF_ATTACKWAITERS);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (bState)
	{
		if (!bOldState)
		{
			NPCSetFlags(iBossIndex, iBossFlags | SFF_ATTACKWAITERS);
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Attack Waiters", iClient);
		}
	}
	else
	{
		if (bOldState)
		{
			NPCSetFlags(iBossIndex, iBossFlags & ~SFF_ATTACKWAITERS);
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Do Not Attack Waiters", iClient);
		}
	}
	
	return Plugin_Handled;
}

public Action Command_SlenderNoTeleport(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 2)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_boss_no_teleport <bossindex 0-%d> <0/1>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int iBossIndex = StringToInt(arg1);
	if (NPCGetUniqueID(iBossIndex) == -1) return Plugin_Handled;
	
	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int iBossFlags = NPCGetFlags(iBossIndex);
	
	bool bState = view_as<bool>(StringToInt(arg2));
	bool bOldState = view_as<bool>(iBossFlags & SFF_NOTELEPORT);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (bState)
	{
		if (!bOldState)
		{
			NPCSetFlags(iBossIndex, iBossFlags | SFF_NOTELEPORT);
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Should Not Teleport", iClient);
		}
	}
	else
	{
		if (bOldState)
		{
			NPCSetFlags(iBossIndex, iBossFlags & ~SFF_NOTELEPORT);
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Boss Should Teleport", iClient);
		}
	}
	
	return Plugin_Handled;
}

public Action Command_ToggleAllBossTeleports(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_toggle_boss_teleports <0/1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int iState = StringToInt(arg1);

	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		int iBossFlags = NPCGetFlags(iNPCIndex);
		if (iState) NPCSetFlags(iNPCIndex, iBossFlags | SFF_NOTELEPORT);
		else if (!iState) NPCSetFlags(iNPCIndex, iBossFlags & ~SFF_NOTELEPORT);
	}
	if (iState) 
	{
		CPrintToChat(iClient, "{royalblue}%t{default}All bosses can no longer teleport.", "SF2 Prefix", iClient);
	}
	else if (!iState) 
	{
		CPrintToChat(iClient, "{royalblue}%t{default}All bosses can now teleport.", "SF2 Prefix", iClient);
	}

	return Plugin_Handled;
}

public Action Command_DebugLogicEscape(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	char sName[32];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (!SF_IsBoxingMap())
		{
			if (strcmp(sName, "sf2_logic_escape", false) == 0)
			{
				AcceptEntityInput(ent, "FireUser1");
				break;
			}
		}
		else
		{
			if (strcmp(sName, "sf2_logic_escape", false) == 0)
			{
				AcceptEntityInput(ent, "FireUser1");
				break;
			}
		}
	}
	CPrintToChat(iClient, "{royalblue}%t{default}Triggered sf2_logic_escape.", "SF2 Prefix", iClient);

	return Plugin_Handled;
}

public Action Command_ForceEndGrace(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if(g_hRoundGraceTimer != null)
		TriggerTimer(g_hRoundGraceTimer);

	return Plugin_Handled;
}

public Action Command_ReloadProfiles(int iClient, int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	ReloadBossProfiles();
	ReloadRestrictedWeapons();
	ReloadSpecialRounds();
	CPrintToChatAll("{royalblue}%t{default} Reloaded all profiles successfully.", "SF2 Prefix");

	return Plugin_Handled;
}

public Action Command_ToggleAllAttackWaiters(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_toggle_attack_waiters <0/1>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));

	int iState = StringToInt(arg1);

	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		int iBossFlags = NPCGetFlags(iNPCIndex);
		if (iState) NPCSetFlags(iNPCIndex, iBossFlags | SFF_ATTACKWAITERS);
		else if (!iState) NPCSetFlags(iNPCIndex, iBossFlags & ~SFF_ATTACKWAITERS);
	}
	if (iState) 
	{
		CPrintToChat(iClient, "{royalblue}%t{default}All bosses can now attack waiters.", "SF2 Prefix", iClient);
	}
	else if (!iState) 
	{
		CPrintToChat(iClient, "{royalblue}%t{default}All bosses can no longer attack waiters.", "SF2 Prefix", iClient);
	}

	return Plugin_Handled;
}

public Action Command_ForceProxy(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_force_proxy <name|#userid> <bossindex 0-%d>", MAX_BOSSES - 1);
		return Plugin_Handled;
	}
	
	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Cannot Use Command", iClient);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			iClient,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int iBossIndex = StringToInt(arg2);
	if (iBossIndex < 0 || iBossIndex >= MAX_BOSSES)
	{
		ReplyToCommand(iClient, "Boss index is out of range!");
		return Plugin_Handled;
	}
	else if (NPCGetUniqueID(iBossIndex) == -1)
	{
		ReplyToCommand(iClient, "Boss index is invalid! Boss index not active!");
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		int iTarget = target_list[i];
		
		char sName[MAX_NAME_LENGTH];
		if (IsClientSourceTV(iTarget)) continue;//Exclude the sourcetv bot
		FormatEx(sName, sizeof(sName), "%N", iTarget);

		if (!g_bPlayerEliminated[iTarget])
		{
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Unable To Perform Action On Player In Round", iClient, sName);
			continue;
		}

		if (g_bPlayerProxy[iTarget]) continue; //Exclude any active proxies

		float flintPos[3];
		
		int iSpawnPoint = -1;

		if (!SpawnProxy(iClient, iBossIndex, flintPos, iSpawnPoint)) 
		{
			CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Player No Place For Proxy", iClient, sName);
			continue;
		}
		
		ClientEnableProxy(iTarget, iBossIndex, flintPos, iSpawnPoint);
	}
	
	return Plugin_Handled;
}

public Action Command_ForceEscape(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_force_escape <name|#userid>");
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			iClient,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		if (!g_bPlayerEliminated[i] && !DidClientEscape(i))
		{
			ClientEscape(target);
			TeleportClientToEscapePoint(target);
		}
	}
	
	return Plugin_Handled;
}
public Action Command_ForceDifficulty(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (args == 0)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_set_difficulty <difficulty 1-5>");
		return Plugin_Handled;
	}
	
	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Cannot Use Command", iClient);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int iNewDifficulty = StringToInt(arg1);
	
	if (iNewDifficulty < 1)
	{
		iNewDifficulty = 1;
	}
	else if (iNewDifficulty > 5)
	{
		iNewDifficulty = 5;
	}
	else if (iNewDifficulty > 0 && iNewDifficulty < 6)
	{
		g_cvDifficulty.SetInt(iNewDifficulty);
	}
	
	switch (iNewDifficulty)
	{
		case Difficulty_Normal: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {yellow}%t{default}.", "SF2 Prefix", iClient, "SF2 Normal Difficulty");
		case Difficulty_Hard: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {orange}%t{default}.", "SF2 Prefix", iClient, "SF2 Hard Difficulty");
		case Difficulty_Insane: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {red}%t{default}.", "SF2 Prefix", iClient, "SF2 Insane Difficulty");
		case Difficulty_Nightmare: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {valve}%t!", "SF2 Prefix", iClient, "SF2 Nightmare Difficulty");
		case Difficulty_Apollyon:
		{
			if (!g_bRestartSessionEnabled) CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {darkgray}%t!", "SF2 Prefix", iClient, "SF2 Apollyon Difficulty");
			else CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the difficulty to {mediumslateblue}%t!", "SF2 Prefix", iClient, "SF2 Calamity Difficulty");
		}
	}

	return Plugin_Handled;
}
public Action Command_ForceSpecialRound(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (args == 0)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_force_special_round <specialround 1-39>");
		return Plugin_Handled;
	}

	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	int iSpecialRound = StringToInt(arg1);
	
	if (iSpecialRound < 1)
	{
		iSpecialRound = 1;
	}
	else if (iSpecialRound > 39)
	{
		iSpecialRound = 39;
	}
	else if (iSpecialRound > 0 && iSpecialRound < 40)
	{
		g_cvSpecialRoundOverride.SetInt(iSpecialRound);
	}
	
	switch (iSpecialRound)
	{
		case SPECIALROUND_DOUBLETROUBLE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Double Trouble.", "SF2 Prefix", iClient);
		case SPECIALROUND_INSANEDIFFICULTY: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Suicide Time.", "SF2 Prefix", iClient);
		case SPECIALROUND_DOUBLEMAXPLAYERS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Double Players.", "SF2 Prefix", iClient);
		case SPECIALROUND_LIGHTSOUT: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Lights Out.", "SF2 Prefix", iClient);
		case SPECIALROUND_BEACON: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Bacon Spray.", "SF2 Prefix", iClient);
		case SPECIALROUND_DOOMBOX: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Stealth Box of Doom.", "SF2 Prefix", iClient);
		case SPECIALROUND_NOGRACE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Start Running.", "SF2 Prefix", iClient);
		case SPECIALROUND_2DOUBLE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Double It All, But Go No Higher.", "SF2 Prefix", iClient);
		case SPECIALROUND_DOUBLEROULETTE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Double Roulette.", "SF2 Prefix", iClient);
		case SPECIALROUND_NIGHTVISION: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Night Vision.", "SF2 Prefix", iClient);
		case SPECIALROUND_INFINITEFLASHLIGHT: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Infinite Flashlight.", "SF2 Prefix", iClient);
		case SPECIALROUND_DREAMFAKEBOSSES: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Just A Dream.", "SF2 Prefix", iClient);
		case SPECIALROUND_EYESONTHECLOACK: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Countdown.", "SF2 Prefix", iClient);
		case SPECIALROUND_NOPAGEBONUS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Deadline.", "SF2 Prefix", iClient);
		case SPECIALROUND_DUCKS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Ducks.", "SF2 Prefix", iClient);
		case SPECIALROUND_1UP: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}1-Up.", "SF2 Prefix", iClient);
		case SPECIALROUND_NOULTRAVISION: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Blind.", "SF2 Prefix", iClient);
		case SPECIALROUND_SUPRISE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Surprise Me.", "SF2 Prefix", iClient);
		case SPECIALROUND_LASTRESORT: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Last Resort.", "SF2 Prefix", iClient);
		case SPECIALROUND_ESCAPETICKETS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Escape Tickets.", "SF2 Prefix", iClient);
		case SPECIALROUND_REVOLUTION: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Special Round Revolution.", "SF2 Prefix", iClient);
		case SPECIALROUND_DISTORTION: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Space Distortion.", "SF2 Prefix", iClient);
		case SPECIALROUND_MULTIEFFECT: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Multieffect.", "SF2 Prefix", iClient);
		case SPECIALROUND_BOO: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Boo.", "SF2 Prefix", iClient);
		case SPECIALROUND_REALISM: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Marble Hornets.", "SF2 Prefix", iClient);
		case SPECIALROUND_VOTE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Special Round Vote.", "SF2 Prefix", iClient);
		case SPECIALROUND_COFFEE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Coffee.", "SF2 Prefix", iClient);
		case SPECIALROUND_PAGEDETECTOR: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Item Detectors.", "SF2 Prefix", iClient);
		case SPECIALROUND_CLASSSCRAMBLE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Class Scramble.", "SF2 Prefix", iClient);
		case SPECIALROUND_2DOOM: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Silent Slender.", "SF2 Prefix", iClient);
		case SPECIALROUND_PAGEREWARDS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Page Rewards.", "SF2 Prefix", iClient);
		case SPECIALROUND_TINYBOSSES: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Tiny Bosses.", "SF2 Prefix", iClient);
		case SPECIALROUND_RUNNINGINTHE90S: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}In The 90s.", "SF2 Prefix", iClient);
		case SPECIALROUND_TRIPLEBOSSES: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Triple Bosses.", "SF2 Prefix", iClient);
		case SPECIALROUND_20DOLLARS: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}20 Dollars.", "SF2 Prefix", iClient);
		case SPECIALROUND_MODBOSSES: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}MODified Bosses {default}(WARNING, ITS H3LL).", "SF2 Prefix", iClient);
		case SPECIALROUND_BOSSROULETTE: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Boss Roulette.", "SF2 Prefix", iClient);
		case SPECIALROUND_THANATOPHOBIA: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Thanatophobia.", "SF2 Prefix", iClient);
		case SPECIALROUND_WALLHAX: CPrintToChatAll("{royalblue}%t{collectors}%N {default}set the next special round to {lightblue}Wall Hax.", "SF2 Prefix", iClient);
	}

	return Plugin_Handled;
}

public Action Command_AddSlender(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_add_boss <name>");
		return Plugin_Handled;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetCmdArg(1, sProfile, sizeof(sProfile));
	
	g_hConfig.Rewind();
	if (!g_hConfig.JumpToKey(sProfile)) 
	{
		ReplyToCommand(iClient, "That boss does not exist!");
		return Plugin_Handled;
	}
	
	SF2NPC_BaseNPC Npc = AddProfile(sProfile);
	if (Npc.IsValid())
	{
		float eyePos[3], eyeAng[3], flPos[3];
		GetClientEyePosition(iClient, eyePos);
		GetClientEyeAngles(iClient, eyeAng);

		Handle hTrace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, iClient);
		TR_GetEndPosition(flPos, hTrace);
		delete hTrace;
	
		SpawnSlender(Npc, flPos);
		
		if (SF_IsBoxingMap() && (GetRoundState() == SF2RoundState_Escape) && NPCChaserIsBoxingBoss(Npc.Index))
		{
			g_iSlenderBoxingBossCount += 1;
		}
	}
	
	return Plugin_Handled;
}
public void NPCSpawn(const char[] output,int iEnt,int activator, float delay)
{
	if (!g_bEnabled) return;
	char targetName[255];
	float vecPos[3];
	GetEntPropString(iEnt, Prop_Data, "m_iName", targetName, sizeof(targetName));
	if (targetName[0] != '\0')
	{
		if (!StrContains(targetName, "sf2_spawn_", false))
		{
			ReplaceString(targetName, sizeof(targetName), "sf2_spawn_", "", false);
			g_hConfig.Rewind();
			if (!g_hConfig.JumpToKey(targetName)) 
			{
				if (!SF_IsBoxingMap())
				{
					PrintToServer("Entity: %i. That boss does not exist!",iEnt);
				}
				return;
			}
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			SF2NPC_BaseNPC Npc;
			for(int iNpc;iNpc<=MAX_BOSSES;iNpc++)
			{
				Npc = view_as<SF2NPC_BaseNPC>(iNpc);
				if(Npc.IsValid())
				{
					Npc.GetProfile(sProfile,sizeof(sProfile));
					if(strcmp(sProfile,targetName) == 0)
					{
						Npc.UnSpawn();
						float flPos[3];
						GetEntPropVector(iEnt, Prop_Data, "m_vecOrigin", flPos);
						SpawnSlender(Npc, flPos);
						break;
					}
				}
			}
		}
		if (SF_IsBoxingMap())
		{
			ArrayList hSpawnPoint = new ArrayList();
			if (strcmp(targetName, "sf2_boxing_boss_spawn") == 0)
			{
				hSpawnPoint.Push(iEnt);
			}
			iEnt = -1;
			if (hSpawnPoint.Length > 0) iEnt = hSpawnPoint.Get(GetRandomInt(0,hSpawnPoint.Length-1));
			delete hSpawnPoint;
			if (iEnt > MaxClients)
			{
				GetEntPropVector(iEnt, Prop_Data, "m_vecAbsOrigin", vecPos);
				for(int iNpc = 0;iNpc <= MAX_BOSSES; iNpc++)
				{
					SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iNpc);
					if (!Npc.IsValid()) continue;
					if (Npc.Flags & SFF_NOTELEPORT)
					{
						continue;
					}
					Npc.UnSpawn();
					SpawnSlender(Npc, vecPos);
					break;
				}
			}
		}
	}
	return;
}

public Action Command_AddSlenderFake(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 1)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_add_boss_fake <name>");
		return Plugin_Handled;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetCmdArg(1, sProfile, sizeof(sProfile));
	
	g_hConfig.Rewind();
	if (!g_hConfig.JumpToKey(sProfile)) 
	{
		ReplyToCommand(iClient, "That boss does not exist!");
		return Plugin_Handled;
	}
	
	SF2NPC_BaseNPC Npc = AddProfile(sProfile, SFF_FAKE);
	if (Npc.IsValid())
	{
		float eyePos[3], eyeAng[3], flPos[3];
		GetClientEyePosition(iClient, eyePos);
		GetClientEyeAngles(iClient, eyeAng);
		
		Handle hTrace = TR_TraceRayFilterEx(eyePos, eyeAng, MASK_NPCSOLID, RayType_Infinite, TraceRayDontHitEntity, iClient);
		TR_GetEndPosition(flPos, hTrace);
		delete hTrace;
	
		SpawnSlender(Npc, flPos);
	}
	
	return Plugin_Handled;
}

public Action Command_ForceState(int iClient,int args)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (args < 2)
	{
		ReplyToCommand(iClient, "Usage: sm_sf2_setplaystate <name|#userid> <0/1>");
		return Plugin_Handled;
	}
	
	if (IsRoundEnding() || IsRoundInWarmup())
	{
		CPrintToChat(iClient, "{royalblue}%t{default}%T", "SF2 Prefix", "SF2 Cannot Use Command", iClient);
		return Plugin_Handled;
	}
	
	char arg1[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
			arg1,
			iClient,
			target_list,
			MAXPLAYERS,
			0,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(iClient, target_count);
		return Plugin_Handled;
	}
	
	char arg2[32];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	int iState = StringToInt(arg2);
	
	char sName[MAX_NAME_LENGTH];
	
	for (int i = 0; i < target_count; i++)
	{
		int target = target_list[i];
		
		if (IsClientSourceTV(target)) continue;//Exclude the sourcetv bot
		
		FormatEx(sName, sizeof(sName), "%N", target);
		
		if (g_bPlayerProxy[target]) continue;//Can't force proxies
		
		if (iState && g_bPlayerEliminated[target])
		{
			ClientSetQueuePoints(target, 0);
			if (IsClientInGhostMode(target))
			{
				ClientSetGhostModeState(target, false);
				TF2_RespawnPlayer(target);
				TF2_RemoveCondition(target, TFCond_StealthedUserBuffFade);
				g_flLastCommandTime[target] = GetEngineTime()+0.5;
				CreateTimer(0.25, Timer_ForcePlayer, GetClientUserId(target), TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				SetClientPlayState(target, true);
			}
			CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", iClient, "SF2 Player Forced In Game", sName);
		}
		else if (!iState && !g_bPlayerEliminated[target])
		{
			SetClientPlayState(target, false);
			
			CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", iClient, "SF2 Player Forced Out Of Game", sName);
		}
	}
	
	return Plugin_Handled;
}

public Action Timer_ForcePlayer(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;

	char sName[MAX_NAME_LENGTH];
	FormatEx(sName, sizeof(sName), "%N", iClient);

	SetClientPlayState(iClient, true);
	//CPrintToChatAll("{royalblue}%t {collectors}%N: {default}%t", "SF2 Prefix", iClient, "SF2 Player Forced In Game", sName);
	return Plugin_Stop;
}