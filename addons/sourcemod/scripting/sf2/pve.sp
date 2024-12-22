#pragma semicolon 1
#pragma newdecls required

static bool g_PlayerInPvE[MAXTF2PLAYERS];
static bool g_PlayerIsLeavingPvE[MAXTF2PLAYERS];
static bool g_PlayerShowBossHealthPvE[MAXTF2PLAYERS];
static Handle g_PlayerPvETimer[MAXTF2PLAYERS];
static Handle g_PlayerPvERespawnTimer[MAXTF2PLAYERS];
static int g_PlayerPvETimerCount[MAXTF2PLAYERS];
static ArrayList g_PlayerEnteredPvETriggers[MAXTF2PLAYERS] = { null, ... };
static ArrayList g_SlenderBosses;
static ArrayList g_CustomBosses;
static ArrayList g_ActiveBosses;
static bool g_IsPvEActive;
static bool g_DoesPvEExist;
static char g_PlayerCurrentPvEMusic[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static bool g_PvEBoxingMode;

static float g_TimeUntilBossSpawns;
static bool g_HasBossSpawned;

#define MAX_MUSICS 14
static Database g_MusicDataBase;
static bool g_IsMusicCached[MAXTF2PLAYERS];
static char g_MusicFile[MAXTF2PLAYERS][MAX_MUSICS][PLATFORM_MAX_PATH];
static char g_MenuMusic[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
static float g_MusicVolume[MAXTF2PLAYERS][MAX_MUSICS];
static float g_MusicLoopTime[MAXTF2PLAYERS][MAX_MUSICS];
static char g_CustomMusicOverride[PLATFORM_MAX_PATH];

static GlobalForward g_OnSelectedPvEBoss;
static GlobalForward g_OnPlayerEnterPvE;
static GlobalForward g_OnPlayerExitPvE;

static ArrayList g_PvETriggers;

static Menu g_MenuSettingsPvE;

void PvE_Initialize()
{
	g_OnGamemodeStartPFwd.AddFunction(null, OnGamemodeStart);
	g_OnGameFramePFwd.AddFunction(null, GameFrame);
	g_OnMapStartPFwd.AddFunction(null, MapStart);
	g_OnRoundStartPFwd.AddFunction(null, RoundStart);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerAverageUpdatePFwd.AddFunction(null, OnPlayerAverageUpdate);

	g_SlenderBosses = new ArrayList(ByteCountToCells(SF2_MAX_PROFILE_NAME_LENGTH));
	g_CustomBosses = new ArrayList(ByteCountToCells(64));
	g_ActiveBosses = new ArrayList();

	g_PvETriggers = new ArrayList();

	RegConsoleCmd("sm_sf2_add_pve_music", Command_AddPvEMusic);
	RegConsoleCmd("sm_sf2_pve_show_health", Command_ShowHealth);
	RegAdminCmd("sm_sf2_do_pve", Command_DoPvE, ADMFLAG_SLAY);
}

void PvE_SetupMenus()
{
	g_MenuSettingsPvE = new Menu(Menu_SettingsPvE);
	g_MenuSettingsPvE.SetTitle("%t %t\n \n", "SF2 Prefix", "SF2 Settings PvE Menu Title");
	char formatter[256];
	FormatEx(formatter, sizeof(formatter), "%t", "SF2 PvE Music Settings Title");
	g_MenuSettingsPvE.AddItem("0", formatter);
	g_MenuSettingsPvE.ExitBackButton = true;
}

Menu GetPvEMenu()
{
	return g_MenuSettingsPvE;
}

static void OnGamemodeStart()
{
	Database base;
	char error[512];
	if (SQL_CheckConfig("sf2_pve_music"))
	{
		base = SQL_Connect("sf2_pve_music", true, error, sizeof(error));
		if (base == null)
		{
			PrintToServer("%s", error);
			return;
		}
	}
	else
	{
		base = SQLite_UseDatabase("sf2_pve_music", error, sizeof(error));
		if (base == null)
		{
			PrintToServer("%s", error);
			return;
		}
	}

	Transaction action = new Transaction();
	for (int i = 0; i < MAXTF2PLAYERS; i++)
	{
		for (int i2 = 0; i2 < MAX_MUSICS; i2++)
		{
			g_MusicFile[i][i2][0] = '\0';
			g_MusicVolume[i][i2] = 0.75;
			g_MusicLoopTime[i][i2] = 0.0;
		}
	}

	char formatter[1024];
	for (int i = 0; i < MAX_MUSICS; i++)
	{
		FormatEx(formatter, sizeof(formatter), "CREATE TABLE IF NOT EXISTS music_selection_%i ("
		... "steamid INTEGER PRIMARY KEY, "
		... "music_file VARCHAR(256), "
		... "music_volume FLOAT NOT NULL DEFAULT 1.0, "
		... "music_loop_time FLOAT NOT NULL DEFAULT 0.0);",
		i);

		action.AddQuery(formatter);
	}

	base.Execute(action, Database_Success, Database_FailHandle, base);
}

static void GameFrame()
{
	if (g_DoesPvEExist && g_TimeUntilBossSpawns < GetGameTime() && !g_HasBossSpawned && GetRoundState() != SF2RoundState_Waiting)
	{
		SpawnPvEBoss();
	}
}

static void MapStart()
{
	g_DoesPvEExist = false;
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		CBaseEntity trigger = CBaseEntity(ent);
		if (trigger.IsValid())
		{
			char name[50];
			trigger.GetPropString(Prop_Data, "m_iName", name, sizeof(name));
			if (StrContains(name, "sf2_pve_trigger", false) == 0)
			{
				float mins[3], maxs[3];
				trigger.GetPropVector(Prop_Send, "m_vecMins", mins);
				trigger.GetPropVector(Prop_Send, "m_vecMaxs", maxs);
				float range = ((maxs[0] + maxs[1]) / 2.0) + (FloatAbs(mins[0] + mins[1]) / 2.0);
				if (range > 2000.0)
				{
					g_DoesPvEExist = true;
				}
				SDKHook(ent, SDKHook_EndTouch, PvE_OnTriggerEndTouch);
			}
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_trigger_pve")) != -1)
	{
		SF2TriggerPvEEntity trigger = SF2TriggerPvEEntity(ent);
		if (trigger.IsValid())
		{
			if (trigger.IsBossPvE)
			{
				g_DoesPvEExist = true;
			}
			SDKHook(ent, SDKHook_EndTouch, PvE_OnTriggerEndTouch);
		}
	}
}

static void Database_Success(Database db, any data, int numQueries, DBResultSet[] results, any[] queryData)
{
	g_MusicDataBase = data;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientAuthorized(i))
		{
			OnClientAuthorized(i, NULL_STRING);
		}
	}
}

public void OnClientAuthorized(int client, const char[] auth)
{
	if (g_MusicDataBase == null || IsFakeClient(client))
	{
		return;
	}

	int id = GetSteamAccountID(client);
	if (id == 0)
	{
		return;
	}

	Transaction action = new Transaction();

	char formatter[256];
	for (int i = 0; i < MAX_MUSICS; i++)
	{
		FormatEx(formatter, sizeof(formatter), "SELECT * FROM music_selection_%i WHERE steamid = %d;", i, id);
		action.AddQuery(formatter);
	}

	g_MusicDataBase.Execute(action, Database_SetupMusics, Database_RetryClient, GetClientUserId(client));
}

static void Database_SetupMusics(Database db, any data, int numQueries, DBResultSet[] results, any[] queryData)
{
	int client = GetClientOfUserId(data);
	if (!IsValidClient(client))
	{
		return;
	}
	char formatter[256];
	Transaction action;
	for (int i = 0; i < MAX_MUSICS; i++)
	{
		if (results[i].FetchRow())
		{
			results[i].FetchString(1, g_MusicFile[client][i], sizeof(g_MusicFile[][]));
			g_MusicVolume[client][i] = results[i].FetchFloat(2);
			g_MusicLoopTime[client][i] = results[i].FetchFloat(3);
			if (g_MusicFile[client][i][0] != '\0')
			{
				PrecacheSound(g_MusicFile[client][i]);
			}
		}
		else if (!results[i].MoreRows)
		{
			if (action == null)
			{
				action = new Transaction();
			}

			FormatEx(formatter, sizeof(formatter), "INSERT INTO music_selection_%i (steamid, music_file) VALUES ('%d', '%s')", i, GetSteamAccountID(client), "");
			action.AddQuery(formatter);
		}
	}

	if (action != null)
	{
		g_MusicDataBase.Execute(action, _, Database_Fail);
	}

	g_IsMusicCached[client] = true;
}

static void Database_Fail(Database db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	LogError(error);
}

static void Database_FailHandle(Database db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	LogError(error);
	CloseHandle(data);
}

static void Database_RetryClient(Database db, any data, int numQueries, const char[] error, int failIndex, any[] queryData)
{
	int client = GetClientOfUserId(data);
	if (IsValidClient(client))
	{
		OnClientAuthorized(client, error);
	}
}

bool IsPvEBoxing()
{
	return g_PvEBoxingMode;
}

static void RoundStart()
{
	g_PvETriggers.Clear();
	g_TimeUntilBossSpawns = GetRandomFloat(10.0, 20.0) + GetGameTime();
	g_IsPvEActive = false;
	g_HasBossSpawned = false;
	g_ActiveBosses.Clear();

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		CBaseEntity trigger = CBaseEntity(ent);
		if (trigger.IsValid())
		{
			char name[50];
			trigger.GetPropString(Prop_Data, "m_iName", name, sizeof(name));
			if (StrContains(name, "sf2_pve_trigger", false) == 0)
			{
				float mins[3], maxs[3];
				trigger.GetPropVector(Prop_Send, "m_vecMins", mins);
				trigger.GetPropVector(Prop_Send, "m_vecMaxs", maxs);
				float range = ((maxs[0] + maxs[1]) / 2.0) + (FloatAbs(mins[0] + mins[1]) / 2.0);
				if (range > 2000.0)
				{
					g_PvETriggers.Push(EntIndexToEntRef(ent));
				}
				SDKHook(ent, SDKHook_EndTouch, PvE_OnTriggerEndTouch);
			}
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_trigger_pve")) != -1)
	{
		SF2TriggerPvEEntity trigger = SF2TriggerPvEEntity(ent);
		if (trigger.IsValid())
		{
			if (trigger.IsBossPvE)
			{
				g_PvETriggers.Push(EntIndexToEntRef(ent));
			}
			SDKHook(ent, SDKHook_EndTouch, PvE_OnTriggerEndTouch);
		}
	}
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	g_PlayerEnteredPvETriggers[client.index] = new ArrayList();

	g_PlayerShowBossHealthPvE[client.index] = false;

	PvE_ForceResetPlayerPvEData(client.index);

	if (IsClientAuthorized(client.index))
	{
		OnClientAuthorized(client.index, NULL_STRING);
	}
}

static void OnDisconnected(SF2_BasePlayer client)
{
	PvE_SetPlayerPvEState(client.index, false, false);

	if (g_PlayerEnteredPvETriggers[client.index] != null)
	{
		delete g_PlayerEnteredPvETriggers[client.index];
		g_PlayerEnteredPvETriggers[client.index] = null;
	}

	if (g_MusicDataBase != null && !IsFakeClient(client.index) && g_IsMusicCached[client.index])
	{
		int id = GetSteamAccountID(client.index);
		if (id != 0)
		{
			Transaction action = new Transaction();

			char formatter[512];
			for (int i = 0; i < MAX_MUSICS; i++)
			{
				FormatEx(formatter, sizeof(formatter), "UPDATE music_selection_%i SET "
				... "music_file = '%s', "
				... "music_volume = %f, "
				... "music_loop_time = %f "
				... "WHERE steamid = %d;",
				i,
				g_MusicFile[client.index][i],
				g_MusicVolume[client.index][i],
				g_MusicLoopTime[client.index][i],
				id);

				action.AddQuery(formatter);
			}

			g_MusicDataBase.Execute(action, _, Database_Fail, _, DBPrio_High);
		}
	}

	g_IsMusicCached[client.index] = false;
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	if (IsRoundInWarmup() || GameRules_GetProp("m_bInWaitingForPlayers"))
	{
		return;
	}

	PvE_SetPlayerPvEState(client.index, false, false);

	g_PlayerIsLeavingPvE[client.index] = false;
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		if (client.IsInPvE)
		{
			g_PlayerIsLeavingPvE[client.index] = false;
		}

		PvE_SetPlayerPvEState(client.index, false, false);
	}
}

static void OnPlayerAverageUpdate(SF2_BasePlayer client)
{
	if (!client.IsInPvE && !g_PlayerShowBossHealthPvE[client.index])
	{
		return;
	}

	if (!client.IsEliminated && g_PlayerShowBossHealthPvE[client.index])
	{
		return;
	}

	static int hudColorBossBar[3] = { 43, 103, 255 };
	char buffer[256];

	ArrayList bosses = GetActivePvEBosses();
	char buffer2[64];
	char formatter[128], name[SF2_MAX_NAME_LENGTH];
	for (int i2 = 0; i2 < bosses.Length; i2++)
	{
		if (i2 >= 4)
		{
			continue;
		}
		name[0] = '\0';
		SF2_ChaserEntity chaser = SF2_ChaserEntity(EntRefToEntIndex(bosses.Get(i2)));
		if (chaser.IsValid() && chaser.Controller.IsValid())
		{
			ChaserBossProfile data = chaser.Controller.GetProfileDataEx();
			data.GetName(1, name, sizeof(name));
			if (!data.DisplayPvEHealth)
			{
				continue;
			}
		}

		if (bosses.Length > 1 && i2 > 0)
		{
			FormatEx(buffer2, sizeof(buffer2), "\n");
		}

		CBaseCombatCharacter boss = CBaseCombatCharacter(EntRefToEntIndex(bosses.Get(i2)));
		int health = boss.GetProp(Prop_Data, "m_iHealth");
		if (name[0] != '\0')
		{
			FormatEx(formatter, sizeof(formatter), "%s: %d", name, health);
		}
		else
		{
			FormatEx(formatter, sizeof(formatter), "%d", health);
		}

		StrCat(buffer2, sizeof(buffer2), formatter);
		StrCat(buffer, sizeof(buffer), buffer2);
		SetHudTextParams(-1.0, 0.15, 0.25, hudColorBossBar[0], hudColorBossBar[1], hudColorBossBar[2], 225, 0, 1.0, 0.07, 0.3);
		ShowSyncHudText(client.index, g_HudSync2, buffer);
	}
}

static Action Timer_TeleportPlayerToPvE(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (g_PlayerProxy[client])
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerPvERespawnTimer[client])
	{
		return Plugin_Stop;
	}
	g_PlayerPvERespawnTimer[client] = null;

	ArrayList spawnPointList = new ArrayList();

	int ent = -1;

	{
		float myPos[3];
		float mins[3], maxs[3];
		GetEntPropVector(client, Prop_Send, "m_vecMins", mins);
		GetEntPropVector(client, Prop_Send, "m_vecMaxs", maxs);

		char name[32];

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));

			if (!StrContains(name, "spawn_loot", false))
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", myPos);

				spawnPointList.Push(ent);
			}
		}
	}

	int num;
	if ((num = spawnPointList.Length) > 0)
	{
		ent = spawnPointList.Get(GetRandomInt(0, num - 1));
	}

	delete spawnPointList;

	if (num > 0)
	{
		float pos[3], ang[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(client, pos, ang, { 0.0, 0.0, 0.0 });

		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, pos, _, SNDLEVEL_NORMAL, _, 1.0);
	}
	return Plugin_Stop;
}

void PvE_ForceResetPlayerPvEData(int client)
{
	g_PlayerInPvE[client] = false;
	g_PlayerPvETimer[client] = null;
	g_PlayerPvETimerCount[client] = 0;
	g_PlayerPvERespawnTimer[client] = null;
	g_PlayerIsLeavingPvE[client] = false;

	if (g_PlayerEnteredPvETriggers[client] != null)
	{
		g_PlayerEnteredPvETriggers[client].Clear();
	}
}

void PvE_SetPlayerPvEState(int client, bool status, bool regenerate = true)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid)
	{
		return;
	}

	bool oldInPvE = g_PlayerInPvE[player.index];
	if (status == oldInPvE)
	{
		return; // no change
	}

	g_PlayerInPvE[player.index] = status;
	if (!status && g_PlayerCurrentPvEMusic[client][0] != '\0')
	{
		StopSound(client, SNDCHAN_AUTO, g_PlayerCurrentPvEMusic[client]);
		g_PlayerCurrentPvEMusic[client][0] = '\0';
	}

	if (status && player.IsInPvP)
	{
		PvP_ForceResetPlayerPvPData(player.index);
		PvP_SetPlayerPvPState(player.index, false, false, false);
	}
	g_PlayerPvETimer[player.index] = null;
	g_PlayerPvERespawnTimer[player.index] = null;
	g_PlayerPvETimerCount[player.index] = 0;

	if (status)
	{
		player.ChangeCondition(TFCond_UberchargedCanteen, true);
		player.ChangeCondition(TFCond_UberchargedHidden, true);
		player.ChangeCondition(TFCond_Ubercharged, true);
		player.ChangeCondition(TFCond_UberchargedOnTakeDamage, true);
		player.ChangeCondition(TFCond_Taunting, true);
		player.ChangeCondition(TFCond_UberchargedCanteen, _, 1.0);

		Call_StartForward(g_OnPlayerEnterPvE);
		Call_PushCell(player.index);
		Call_Finish();
	}
	else
	{
		Call_StartForward(g_OnPlayerExitPvE);
		Call_PushCell(player.index);
		Call_Finish();
	}

	if (regenerate)
	{
		// Regenerate player but keep health the same.
		int health = player.GetProp(Prop_Send, "m_iHealth");
		player.RemoveWeaponSlot(TFWeaponSlot_Primary);
		player.RemoveWeaponSlot(TFWeaponSlot_Secondary);
		player.Regenerate();
		player.SetProp(Prop_Data, "m_iHealth", health);
		player.SetProp(Prop_Send, "m_iHealth", health);
	}
}

void PvE_OnTriggerStartTouch(int trigger, int other)
{
	char name[64];
	GetEntPropString(trigger, Prop_Data, "m_iName", name, sizeof(name));

	// The reason I'm not searching for the PvE triggers array is because of maps like Cliffroad and Mountain Complex
	// where the PvE arenas are too small but still serve as shooting ranges.
	if (StrContains(name, "sf2_pve_trigger", false) == 0 || SF2TriggerPvEEntity(trigger).IsValid())
	{
		if (IsValidClient(other) && IsPlayerAlive(other) && !IsClientInGhostMode(other))
		{
			if (!g_PlayerEliminated[other] && !DidClientEscape(other))
			{
				return;
			}
			//Use valve's kill code if the player is stuck.
			if (GetEntPropFloat(other, Prop_Send, "m_flModelScale") != 1.0)
			{
				TF2_AddCondition(other, TFCond_HalloweenTiny, 0.1);
			}
			//Resize the player.
			SetEntPropFloat(other, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(other, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(other, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(other, Prop_Send, "m_flHandScale", 1.0);

			int entRef = EntIndexToEntRef(trigger);
			if (g_PlayerEnteredPvETriggers[other].FindValue(entRef) == -1)
			{
				g_PlayerEnteredPvETriggers[other].Push(entRef);
			}

			if (IsClientInPvE(other))
			{
				if (g_PlayerIsLeavingPvE[other])
				{
					// Player left and came back again, but is still in PvP mode.
					g_PlayerPvETimerCount[other] = 0;
					g_PlayerPvETimer[other] = null;
					g_PlayerIsLeavingPvE[other] = false;
				}
			}
			else
			{
				PvE_SetPlayerPvEState(other, true);
				if (g_IsPvEActive && g_PvETriggers.FindValue(entRef) != -1)
				{
					if (g_CustomMusicOverride[0] != '\0')
					{
						EmitSoundToClient(other, g_CustomMusicOverride, _, _, _, _, 0.75);
						strcopy(g_PlayerCurrentPvEMusic[other], sizeof(g_PlayerCurrentPvEMusic[]), g_CustomMusicOverride);
					}
					else
					{
						ArrayList musics = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
						ArrayList volumes = new ArrayList();
						for (int i = 0; i < MAX_MUSICS; i++)
						{
							if (g_MusicFile[other][i][0] != '\0')
							{
								musics.PushString(g_MusicFile[other][i]);
								volumes.Push(g_MusicVolume[other][i]);
							}
						}
						if (musics.Length > 0)
						{
							char preferredMusic[PLATFORM_MAX_PATH];
							int random = GetRandomInt(0, musics.Length - 1);
							musics.GetString(random, preferredMusic, sizeof(preferredMusic));
							EmitSoundToClient(other, preferredMusic, _, _, _, _, volumes.Get(random));
							strcopy(g_PlayerCurrentPvEMusic[other], sizeof(g_PlayerCurrentPvEMusic[]), preferredMusic);
						}
						delete volumes;
						delete musics;
					}
				}
			}
		}
	}
}

void PvE_OnTriggerEndTouch(int trigger, int other)
{
	if (IsValidClient(other))
	{
		if (g_PlayerEnteredPvETriggers[other] != null)
		{
			int triggerEntRef = EnsureEntRef(trigger);
			for (int i = g_PlayerEnteredPvETriggers[other].Length - 1; i >= 0; i--)
			{
				int entRef = g_PlayerEnteredPvETriggers[other].Get(i);
				if (entRef == triggerEntRef)
				{
					g_PlayerEnteredPvETriggers[other].Erase(i);
				}
				else if (EntRefToEntIndex(entRef) == INVALID_ENT_REFERENCE)
				{
					g_PlayerEnteredPvETriggers[other].Erase(i);
				}
			}
		}

		if (IsClientInPvE(other))
		{
			if (g_PlayerEnteredPvETriggers[other].Length == 0)
			{
				g_PlayerPvETimerCount[other] = 4;
				if (g_PlayerPvETimerCount[other] != 0)
				{
					g_PlayerPvETimer[other] = CreateTimer(1.0, Timer_PlayerPvELeaveCountdown, GetClientUserId(other), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					g_PlayerIsLeavingPvE[other] = true;
				}
				else
				{
					g_PlayerPvETimer[other] = CreateTimer(0.1, Timer_PlayerPvELeaveCountdown, GetClientUserId(other), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

static Action Timer_PlayerPvELeaveCountdown(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerPvETimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsClientInPvE(client))
	{
		return Plugin_Stop;
	}

	if (g_PlayerPvETimerCount[client] <= 0)
	{
		PvE_SetPlayerPvEState(client, false);
		g_PlayerIsLeavingPvE[client] = false;

		// Force them to their melee weapon and stop taunting, to prevent tposing and what not.
		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
		TF2_RemoveCondition(client, TFCond_Taunting);
		return Plugin_Stop;
	}

	g_PlayerPvETimerCount[client]--;

	//if (!g_PlayerProxyAvailableInForce[client])
	{
		SetHudTextParams(-1.0, 0.75,
			1.0,
			255, 255, 255, 255,
			_,
			_,
			0.25, 1.25);

		ShowSyncHudText(client, g_HudSync, "%T", "SF2 Exiting PvE Arena", client, g_PlayerPvETimerCount[client]);
	}

	return Plugin_Continue;
}

bool IsClientInPvE(int client)
{
	return g_PlayerInPvE[client];
}

static void SpawnPvEBoss(const char[] override = "")
{
	if (g_CustomBosses.Length == 0 && g_SlenderBosses.Length == 0)
	{
		return;
	}

	int ent = -1;
	char targetName[64];
	while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] != '\0' && strcmp(targetName, "boss_start", false) == 0)
		{
			AcceptEntityInput(ent, "Trigger");
			break;
		}
	}

	ArrayList spawnPointList = new ArrayList();

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (!StrContains(targetName, "minigames_boss_spawnpoint", false))
		{
			spawnPointList.Push(ent);
		}
	}

	if (spawnPointList.Length > 0)
	{
		ent = spawnPointList.Get(GetRandomInt(0, spawnPointList.Length - 1));
	}

	delete spawnPointList;

	if (!IsValidEntity(ent))
	{
		return;
	}

	g_IsPvEActive = true;
	bool shouldDoCustom = false;
	shouldDoCustom = g_CustomBosses.Length > 0 && GetRandomInt(0, 1) == 1;
	if (override[0] != '\0')
	{
		shouldDoCustom = g_CustomBosses.FindString(override) != -1;
	}
	int bossChosen;
	if (shouldDoCustom || g_SlenderBosses.Length == 0)
	{
		char boss[64];
		float spawnPos[3], spawnAng[3];
		CBaseEntity(ent).GetAbsOrigin(spawnPos);
		CBaseEntity(ent).GetAbsAngles(spawnAng);
		bossChosen = GetRandomInt(0, g_CustomBosses.Length - 1);
		if (override[0] != '\0')
		{
			bossChosen = g_CustomBosses.FindString(override);
			if (bossChosen == -1)
			{
				bossChosen = GetRandomInt(0, g_CustomBosses.Length - 1);
			}
		}
		g_CustomBosses.GetString(bossChosen, boss, sizeof(boss));
		Call_StartForward(g_OnSelectedPvEBoss);
		Call_PushString(boss);
		Call_PushArray(spawnPos, sizeof(spawnPos));
		Call_PushArray(spawnAng, sizeof(spawnAng));
		Call_Finish();
	}
	else
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		float spawnPos[3];
		CBaseEntity(ent).GetAbsOrigin(spawnPos);
		bossChosen = GetRandomInt(0, g_SlenderBosses.Length - 1);
		if (override[0] != '\0')
		{
			bossChosen = g_SlenderBosses.FindString(override);
			if (bossChosen == -1)
			{
				bossChosen = GetRandomInt(0, g_SlenderBosses.Length - 1);
			}
		}
		g_SlenderBosses.GetString(bossChosen, profile, sizeof(profile));
		SF2NPC_BaseNPC npc = AddProfile(profile);
		if (npc.IsValid())
		{
			npc.Spawn(spawnPos);
			ChaserBossProfile data = view_as<SF2NPC_Chaser>(npc).GetProfileDataEx();
			ProfileSound soundInfo = data.GetGlobalMusic(1);
			g_PvEBoxingMode = data.BoxingBoss;
			if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
			{
				soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), g_CustomMusicOverride, sizeof(g_CustomMusicOverride));
			}
			g_ActiveBosses.Push(EntIndexToEntRef(npc.EntIndex));
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_BaseNPC testNPC = SF2NPC_BaseNPC(i);
				if (!testNPC.IsValid())
				{
					continue;
				}

				if (testNPC.CompanionMaster == npc)
				{
					testNPC.Spawn(spawnPos);
					g_ActiveBosses.Push(EntIndexToEntRef(testNPC.EntIndex));

					BaseBossProfile tempData = testNPC.GetProfileDataEx();

					if (tempData.GetCopies().IsEnabled(1))
					{
						char tempProfile[SF2_MAX_PROFILE_NAME_LENGTH];
						testNPC.GetProfile(tempProfile, sizeof(tempProfile));
						for (int i2 = 0; i2 < tempData.GetCopies().GetMaxCopies(1); i2++)
						{
							SF2NPC_BaseNPC copy = AddProfile(tempProfile, _, testNPC);
							if (!copy.IsValid())
							{
								continue;
							}
							copy.Spawn(spawnPos);
							g_ActiveBosses.Push(EntIndexToEntRef(copy.EntIndex));
						}
					}
				}
			}

			if (data.GetCopies().IsEnabled(1))
			{
				for (int i = 0; i < data.GetCopies().GetMaxCopies(1); i++)
				{
					SF2NPC_BaseNPC copy = AddProfile(profile, _, npc);
					if (!copy.IsValid())
					{
						continue;
					}
					copy.Spawn(spawnPos);
					g_ActiveBosses.Push(EntIndexToEntRef(copy.EntIndex));
				}
			}
		}
	}

	g_HasBossSpawned = true;
}

static Action Command_DoPvE(int client, int args)
{
	if (!g_DoesPvEExist)
	{
		CPrintToChat(client, "{royalblue}%t {default}A PvE arena does not exist.", "SF2 Prefix");
		return Plugin_Handled;
	}

	if (g_IsPvEActive)
	{
		CPrintToChat(client, "{royalblue}%t {default}You may not reactivate the PvE arena.", "SF2 Prefix");
		return Plugin_Handled;
	}

	if (g_CustomBosses.Length == 0 && g_SlenderBosses.Length == 0)
	{
		return Plugin_Handled;
	}

	char override[64];
	GetCmdArg(1, override, sizeof(override));
	SpawnPvEBoss(override);

	return Plugin_Handled;
}

static Action Command_AddPvEMusic(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (args < 1)
	{
		ReplyToCommand(client, "Usage: sf2_add_pve_music <sound file>");
		return Plugin_Handled;
	}

	char soundFile[PLATFORM_MAX_PATH];
	GetCmdArg(1, soundFile, sizeof(soundFile));

	if (soundFile[0] == '\0')
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE Invalid File", client);
		return Plugin_Handled;
	}

	bool isAvailable = false;
	for (int i = 0; i < MAX_MUSICS; i++)
	{
		if (g_MusicFile[client][i][0] == '\0')
		{
			isAvailable = true;
			strcopy(g_MusicFile[client][i], sizeof(g_MusicFile[][]), soundFile);
			break;
		}

		if (strcmp(g_MusicFile[client][i], soundFile, false) == 0)
		{
			CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE Add Unique Track", client);
			return Plugin_Handled;
		}
	}

	if (!isAvailable)
	{
		CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE Tracks Unavailable", client);
		return Plugin_Handled;
	}

	PrecacheSound(soundFile);
	CPrintToChat(client, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE Added Track", client, soundFile);

	ClientSaveCookies(client);

	return Plugin_Handled;
}

static Action Command_ShowHealth(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	g_PlayerShowBossHealthPvE[client] = !g_PlayerShowBossHealthPvE[client];
	CPrintToChat(client, "{royalblue}%t {default}%s seeing the PvE boss health anywhere.", "SF2 Prefix", g_PlayerShowBossHealthPvE[client] ? "Enabled" : "Disabled");

	return Plugin_Handled;
}

static void DisplayMusicSelectionPvE(int client)
{
	Menu newMenu = new Menu(PvEMenu_MusicSelection);
	ArrayList musics = new ArrayList(ByteCountToCells(PLATFORM_MAX_PATH));
	for (int i = 0; i < MAX_MUSICS; i++)
	{
		if (g_MusicFile[client][i][0] != '\0')
		{
			musics.PushString(g_MusicFile[client][i]);
		}
	}
	for (int i = 0; i < musics.Length; i++)
	{
		char music[PLATFORM_MAX_PATH];
		musics.GetString(i, music, sizeof(music));
		newMenu.AddItem(music, music);
	}
	delete musics;
	newMenu.SetTitle("%t %T\n \n", "SF2 Prefix", "SF2 PvE Music Settings Title", client);
	newMenu.ExitBackButton = true;
	newMenu.Display(client, MENU_TIME_FOREVER);
	g_MenuMusic[client][0] = '\0';
}

static int Menu_SettingsPvE(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				g_MenuSettings.Display(param1, 30);
			}
		}
		case MenuAction_Select:
		{
			bool hasMusic = false;
			for (int i = 0; i < MAX_MUSICS; i++)
			{
				if (g_MusicFile[param1][i][0] != '\0')
				{
					hasMusic = true;
					break;
				}
			}
			if (!hasMusic)
			{
				g_MenuSettingsPvE.Display(param1, 30);
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE No Tracks 1-3", param1);
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE No Tracks 2-3", param1);
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE No Tracks 3-3", param1);
			}
			else
			{
				DisplayMusicSelectionPvE(param1);
			}
		}
	}
	return 0;
}

static int PvEMenu_MusicSelection(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
			{
				g_MenuSettings.Display(param1, 30);
			}
		}
		case MenuAction_Select:
		{
			char music[PLATFORM_MAX_PATH];
			float volume = 0.75;
			menu.GetItem(param2, music, sizeof(music));
			Menu newMenu = new Menu(PvEMenu_SelectedMusic);
			newMenu.SetTitle("%t %s\n \n", "SF2 Prefix", music);
			newMenu.ExitBackButton = true;

			char formatter[256];
			for (int i = 0; i < MAX_MUSICS; i++)
			{
				if (strcmp(g_MusicFile[param1][i], music, false) == 0)
				{
					volume = g_MusicVolume[param1][i];
					break;
				}
			}
			FormatEx(formatter, sizeof(formatter), "%T", "SF2 PvE Set Volume", param1, RoundToNearest(volume * 100.0));
			newMenu.AddItem("0", formatter);
			FormatEx(formatter, sizeof(formatter), "%T", "SF2 PvE Remove Music", param1);
			newMenu.AddItem("1", formatter);
			newMenu.Display(param1, MENU_TIME_FOREVER);
			strcopy(g_MenuMusic[param1], sizeof(g_MenuMusic[]), music);
		}
	}
	return 0;
}

static int PvEMenu_SelectedMusic(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				char buffer[512];
				Format(buffer, sizeof(buffer), "%T\n \n", "SF2 Settings Music Volume Title", param1);

				Panel panel = new Panel();
				panel.SetTitle(buffer);

				panel.DrawItem("0%");
				panel.DrawItem("25%");
				panel.DrawItem("50%");
				panel.DrawItem("75% (Default)");
				panel.DrawItem("100%");

				panel.Send(param1, Panel_SettingsMusicVolume, 30);
				delete panel;
			}

			case 1:
			{
				for (int i = 0; i < MAX_MUSICS; i++)
				{
					if (strcmp(g_MusicFile[param1][i], g_MenuMusic[param1], false) == 0)
					{
						g_MusicFile[param1][i][0] = '\0';
						g_MusicVolume[param1][i] = 0.75;
						g_MusicLoopTime[param1][i] = 0.0;
						break;
					}
				}
				CPrintToChat(param1, "{royalblue}%t {default}%T", "SF2 Prefix", "SF2 PvE Removed Music", param1, g_MenuMusic[param1]);
				DisplayMusicSelectionPvE(param1);
			}
		}
	}
	else if (action == MenuAction_Cancel)
	{
		if (param2 == MenuCancel_ExitBack)
		{
			DisplayMusicSelectionPvE(param1);
		}
	}
	return 0;
}

static int Panel_SettingsMusicVolume(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		float volume;
		for (int i = 1; i < param2; i++)
		{
			volume += 0.25;
		}
		for (int i = 0; i < MAX_MUSICS; i++)
		{
			if (strcmp(g_MusicFile[param1][i], g_MenuMusic[param1], false) == 0)
			{
				g_MusicVolume[param1][i] = volume;
				break;
			}
		}
		CPrintToChat(param1, "%t", "SF2 Music Volum Changed", RoundToNearest(volume * 100.0));
		ClientSaveCookies(param1);

		DisplayMusicSelectionPvE(param1);
	}
	return 0;
}

// These register boss entity names to choose from
void RegisterPvEBoss(char[] bossName)
{
	g_CustomBosses.PushString(bossName);
}

void UnregisterPveBoss(char[] bossName)
{
	int index = g_CustomBosses.FindString(bossName);
	if (index != -1)
	{
		g_CustomBosses.Erase(index);
	}
}

void RegisterPvESlenderBoss(char profile[SF2_MAX_PROFILE_NAME_LENGTH])
{
	g_SlenderBosses.PushString(profile);
}

void UnregisterPvESlenderBoss(char profile[SF2_MAX_PROFILE_NAME_LENGTH])
{
	int index = g_SlenderBosses.FindString(profile);
	if (index != -1)
	{
		g_SlenderBosses.Erase(index);
	}
}

void KillPvEBoss(int boss)
{
	int index = g_ActiveBosses.FindValue(EntIndexToEntRef(boss));
	if (index != -1)
	{
		g_ActiveBosses.Erase(index);
	}
	else
	{
		return;
	}
	if (g_ActiveBosses.Length == 0)
	{
		g_CustomMusicOverride[0] = '\0';
		g_IsPvEActive = false;
		char targetName[64];
		int bossIndex = NPCGetFromEntIndex(boss);
		float time = 5.0;
		if (bossIndex != -1)
		{
			time = SF2NPC_BaseNPC(bossIndex).GetProfileDataEx().PvETeleportEndTimer;
		}
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid || !client.IsInPvE)
			{
				continue;
			}

			if (g_PlayerCurrentPvEMusic[client.index][0] != '\0')
			{
				StopSound(client.index, SNDCHAN_AUTO, g_PlayerCurrentPvEMusic[client.index]);
			}

			g_PlayerPvERespawnTimer[client.index] = CreateTimer(time, Timer_TeleportPlayerToPvE, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
		}

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
			if (targetName[0] != '\0' && strcmp(targetName, "boss_end", false) == 0)
			{
				AcceptEntityInput(ent, "Trigger");
				break;
			}
		}

		CreateTimer(time, Timer_RemoveAllPvEBosses, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

ArrayList GetActivePvEBosses()
{
	return g_ActiveBosses;
}

static Action Timer_RemoveAllPvEBosses(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
		if (!npc.IsValid())
		{
			continue;
		}

		if (!npc.GetProfileDataEx().IsPvEBoss)
		{
			continue;
		}

		npc.Remove();
	}

	return Plugin_Stop;
}

void PvE_InitializeAPI()
{
	CreateNative("SF2_IsClientInPvE", Native_IsClientInPvE);
	CreateNative("SF2_RegisterPvEBoss", Native_RegisterPvEBoss);
	CreateNative("SF2_SetOverridePvEMusic", Native_SetOverridePvEMusic);
	CreateNative("SF2_UnregisterPvEBoss", Native_UnregisterPvEBoss);
	g_OnSelectedPvEBoss = new GlobalForward("SF2_OnSelectedPvEBoss", ET_Ignore, Param_String, Param_Array, Param_Array);
	g_OnPlayerEnterPvE = new GlobalForward("SF2_OnClientEnterPvE", ET_Ignore, Param_Cell);
	g_OnPlayerExitPvE = new GlobalForward("SF2_OnClientExitPvE", ET_Ignore, Param_Cell);
	CreateNative("SF2_AddPvEBoss", Native_AddPvEBoss);
	CreateNative("SF2_KillPvEBoss", Native_KillPvEBoss);
	CreateNative("SF2_GetActivePvEBosses", Native_GetActivePvEBosses);
}

static any Native_IsClientInPvE(Handle plugin, int numParams)
{
	return IsClientInPvE(GetNativeCell(1));
}

static any Native_RegisterPvEBoss(Handle plugin, int numParams)
{
	char boss[64];
	GetNativeString(1, boss, sizeof(boss));
	RegisterPvEBoss(boss);
	return 0;
}

static any Native_SetOverridePvEMusic(Handle plugin, int numParams)
{
	char music[PLATFORM_MAX_PATH];
	GetNativeString(1, music, sizeof(music));
	strcopy(g_CustomMusicOverride, sizeof(g_CustomMusicOverride), music);
	return 0;
}

static any Native_UnregisterPvEBoss(Handle plugin, int numParams)
{
	char boss[64];
	GetNativeString(1, boss, sizeof(boss));
	UnregisterPveBoss(boss);
	return 0;
}

static any Native_AddPvEBoss(Handle plugin, int numParams)
{
	g_ActiveBosses.Push(GetNativeCell(1));
	return 0;
}

static any Native_KillPvEBoss(Handle plugin, int numParams)
{
	KillPvEBoss(GetNativeCell(1));
	return 0;
}

static any Native_GetActivePvEBosses(Handle plugin, int numParams)
{
	return GetActivePvEBosses();
}