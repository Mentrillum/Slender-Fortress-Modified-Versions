#if defined _sf2_client_proxy_functions_included
 #endinput
#endif
#define _sf2_client_proxy_functions_included

#pragma semicolon 1
#pragma newdecls required

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

		SF2BossProfileSoundInfo soundInfo;
		GetBossProfileProxyDeathSounds(profile, soundInfo);
		soundInfo.EmitSound(_, client.index);
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

	SF2BossProfileData data;
	data = NPCGetProfileData(master);

	switch (channel)
	{
		case SNDCHAN_VOICE:
		{
			if (!data.ProxyAllowVoices)
			{
				return Plugin_Handled;
			}
		}
	}

	if (data.ProxyRobots)
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

			int maxProxies = g_SlenderMaxProxies[bossIndex][difficulty];
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

					int maxProxies = g_SlenderMaxProxies[bossIndex][difficulty];
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

							if (ignoreVisibility || !IsPointVisibleToAPlayer(spawnPos, _, false, _, _, true))
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

/**
 *	Respawns a player as a proxy.
 *
 *	@noreturn
 */
void ClientEnableProxy(int client, int bossIndex, const float pos[3], int spawnPointEnt=-1)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return;
	}

	if (!(NPCGetFlags(bossIndex) & SFF_PROXIES))
	{
		return;
	}

	if (GetClientTeam(client) != TFTeam_Blue)
	{
		return;
	}

	if (g_PlayerProxy[client])
	{
		return;
	}

	TF2_RemovePlayerDisguise(client);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	ClientSetGhostModeState(client, false);

	ClientStopProxyForce(client);

	if (IsClientInKart(client))
	{
		TF2_RemoveCondition(client, TFCond_HalloweenKart);
		TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
		TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
		TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
	}

	g_PlayerProxy[client] = true;

	ChangeClientTeamNoSuicide(client, TFTeam_Blue);
	PvP_SetPlayerPvPState(client, false, true, false);
	PvE_SetPlayerPvEState(client, false, false);
	TF2_RespawnPlayer(client);

	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);

	g_PlayerProxy[client] = true;

	g_PlayerProxyMaster[client] = NPCGetUniqueID(bossIndex);
	g_PlayerProxyControl[client] = 100;
	g_PlayerProxyControlRate[client] = g_SlenderProxyControlDrainRate[bossIndex][difficulty];
	g_PlayerProxyControlTimer[client] = CreateTimer(g_PlayerProxyControlRate[client], Timer_ClientProxyControl, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	g_PlayerProxyAvailable[client] = false;
	g_PlayerProxyAvailableTimer[client] = null;

	char allowedClasses[512];
	GetBossProfileProxyClasses(profile, allowedClasses, sizeof(allowedClasses));
	char allowedClassesList[32][32];
	int classCount = ExplodeString(allowedClasses, " ", allowedClassesList, 32, 32);
	if (classCount)
	{
		TF2_SetPlayerClass(client, TF2_GetClass(allowedClassesList[GetRandomInt(0, classCount - 1)]), _, false);

		int maxHealth = GetEntProp(client, Prop_Data, "m_iMaxHealth");
		TF2_RegeneratePlayer(client);
		SetEntProp(client, Prop_Data, "m_iHealth", maxHealth);
		SetEntProp(client, Prop_Send, "m_iHealth", maxHealth);
	}

	UTIL_ScreenFade(client, 200, 1, FFADE_IN, 255, 255, 255, 100);
	EmitSoundToClient(client, "weapons/teleporter_send.wav", _, SNDCHAN_STATIC);

	ClientActivateUltravision(client);

	TF2Attrib_SetByDefIndex(client, 28, 1.0);

	CreateTimer(0.33, Timer_ApplyCustomModel, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

	if (NPCHasProxyWeapons(bossIndex))
	{
		CreateTimer(1.0, Timer_GiveWeaponAll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	//SDKHook(client, SDKHook_ShouldCollide, Hook_ClientProxyShouldCollide);

	SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(spawnPointEnt);
	if (spawnPoint.IsValid())
	{
		float spawnPos[3]; float ang[3];
		GetEntPropVector(spawnPointEnt, Prop_Data, "m_vecAbsOrigin", spawnPos);
		GetEntPropVector(spawnPointEnt, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(client, spawnPos, ang, view_as<float>({ 0.0, 0.0, 0.0 }));
		spawnPoint.FireOutput("OnSpawn", client);
	}
	else
	{
		TeleportEntity(client, pos, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
	}

	if (NPCGetProxySpawnEffectState(bossIndex))
	{
		char spawnEffect[PLATFORM_MAX_PATH];
		GetBossProfileProxySpawnEffectName(profile, spawnEffect, sizeof(spawnEffect));
		CreateGeneralParticle(client, spawnEffect, NPCGetProxySpawnEffectZOffset(bossIndex));
	}

	Call_StartForward(g_OnClientSpawnedAsProxyFwd);
	Call_PushCell(client);
	Call_Finish();

	Call_StartForward(g_OnPlayerChangeProxyStatePFwd);
	Call_PushCell(SF2_BasePlayer(client));
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

	int bossIndex = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);

	if (g_PlayerProxy[client] && bossIndex != -1)
	{
		if (!NPCHasProxyWeapons(bossIndex))
		{
			return Plugin_Stop;
		}
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(bossIndex, profile, sizeof(profile));

		int weaponIndex, weaponSlot;
		char weaponName[PLATFORM_MAX_PATH], weaponStats[PLATFORM_MAX_PATH];
		int classIndex = view_as<int>(TF2_GetPlayerClass(client));
		classIndex--;
		ArrayList weaponArray = GetBossProfileProxyWeaponClassNames(profile);
		if (weaponArray == null)
		{
			return Plugin_Stop;
		}
		weaponArray.GetString(classIndex, weaponName, sizeof(weaponName));
		weaponArray = GetBossProfileProxyWeaponStats(profile);
		if (weaponArray == null)
		{
			return Plugin_Stop;
		}
		weaponArray.GetString(classIndex, weaponStats, sizeof(weaponStats));
		weaponIndex = GetBossProfileProxyWeaponIndexes(profile, classIndex + 1);
		weaponSlot = GetBossProfileProxyWeaponSlots(profile, classIndex + 1);

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
	}
	return Plugin_Stop;
}

/*bool Hook_ClientProxyShouldCollide(int ent, int collisiongroup, int contentsmask, bool originalResult)
{
	if (!g_Enabled || !g_PlayerProxy[ent] || IsClientInPvP(ent) || IsClientInPvE(ent))
	{
		SDKUnhook(ent, SDKHook_ShouldCollide, Hook_ClientProxyShouldCollide);
		return originalResult;
	}
	if ((contentsmask & MASK_RED))
	{
		return true;
	}
	//To-do add no collision proxy-boss here, the collision boss-proxy is done, see npc_chaser.sp
	return originalResult;
}*/
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

	int master = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);

	if (g_PlayerProxy[client] && master != -1)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(master, profile, sizeof(profile));

		int difficulty = GetLocalGlobalDifficulty(master);

		// Set custom model, if any.
		char buffer[PLATFORM_MAX_PATH];

		TF2_RegeneratePlayer(client);

		char className[64];
		TFClassType playerClass = TF2_GetPlayerClass(client);
		int classToInt = view_as<int>(playerClass);
		TF2_GetClassName(playerClass, className, sizeof(className));

		ArrayList modelsArray;

		if (GetBossProfileProxyDifficultyModelsState(profile))
		{
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					modelsArray = GetBossProfileProxyModels(profile, classToInt, difficulty);
					if (modelsArray == null)
					{
						modelsArray = GetBossProfileProxyModels(profile, 0, difficulty);
					}
					modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
					strcopy(g_ClientProxyModel[client],sizeof(g_ClientProxyModel[]),buffer);
				}
				case Difficulty_Hard:
				{
					modelsArray = GetBossProfileProxyModels(profile, classToInt, difficulty);
					if (modelsArray == null)
					{
						modelsArray = GetBossProfileProxyModels(profile, 0, difficulty);
						if (modelsArray == null)
						{
							modelsArray = GetBossProfileProxyModels(profile, classToInt, 1);
							if (modelsArray == null)
							{
								modelsArray = GetBossProfileProxyModels(profile, 0, 1);
							}
						}
					}
					modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelHard[client],sizeof(g_ClientProxyModelHard[]),buffer);
				}
				case Difficulty_Insane:
				{
					modelsArray = GetBossProfileProxyModels(profile, classToInt, difficulty);
					if (modelsArray == null)
					{
						modelsArray = GetBossProfileProxyModels(profile, 0, difficulty);
						if (modelsArray == null)
						{
							modelsArray = GetBossProfileProxyModels(profile, classToInt, 2);
							if (modelsArray == null)
							{
								modelsArray = GetBossProfileProxyModels(profile, 0, 2);
								if (modelsArray == null)
								{
									modelsArray = GetBossProfileProxyModels(profile, classToInt, 1);
									if (modelsArray == null)
									{
										modelsArray = GetBossProfileProxyModels(profile, 0, 1);
									}
								}
							}
						}
					}
					modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelInsane[client],sizeof(g_ClientProxyModelInsane[]),buffer);
				}
				case Difficulty_Nightmare:
				{
					modelsArray = GetBossProfileProxyModels(profile, classToInt, difficulty);
					if (modelsArray == null)
					{
						modelsArray = GetBossProfileProxyModels(profile, 0, difficulty);
						if (modelsArray == null)
						{
							modelsArray = GetBossProfileProxyModels(profile, classToInt, 3);
							if (modelsArray == null)
							{
								modelsArray = GetBossProfileProxyModels(profile, 0, 3);
								if (modelsArray == null)
								{
									modelsArray = GetBossProfileProxyModels(profile, classToInt, 2);
									if (modelsArray == null)
									{
										modelsArray = GetBossProfileProxyModels(profile, 0, 2);
										if (modelsArray == null)
										{
											modelsArray = GetBossProfileProxyModels(profile, classToInt, 1);
											if (modelsArray == null)
											{
												modelsArray = GetBossProfileProxyModels(profile, 0, 1);
											}
										}
									}
								}
							}
						}
					}
					modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelNightmare[client],sizeof(g_ClientProxyModelNightmare[]),buffer);
				}
				case Difficulty_Apollyon:
				{
					modelsArray = GetBossProfileProxyModels(profile, classToInt, difficulty);
					if (modelsArray == null)
					{
						modelsArray = GetBossProfileProxyModels(profile, 0, difficulty);
						if (modelsArray == null)
						{
							modelsArray = GetBossProfileProxyModels(profile, classToInt, 4);
							if (modelsArray == null)
							{
								modelsArray = GetBossProfileProxyModels(profile, 0, 4);
								if (modelsArray == null)
								{
									modelsArray = GetBossProfileProxyModels(profile, classToInt, 3);
									if (modelsArray == null)
									{
										modelsArray = GetBossProfileProxyModels(profile, 0, 3);
										if (modelsArray == null)
										{
											modelsArray = GetBossProfileProxyModels(profile, classToInt, 2);
											if (modelsArray == null)
											{
												modelsArray = GetBossProfileProxyModels(profile, 0, 2);
												if (modelsArray == null)
												{
													modelsArray = GetBossProfileProxyModels(profile, classToInt, 1);
													if (modelsArray == null)
													{
														modelsArray = GetBossProfileProxyModels(profile, 0, 1);
													}
												}
											}
										}
									}
								}
							}
						}
					}
					modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
					strcopy(g_ClientProxyModelApollyon[client],sizeof(g_ClientProxyModelApollyon[]),buffer);
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
			modelsArray = GetBossProfileProxyModels(profile, classToInt, 1);
			if (modelsArray == null)
			{
				modelsArray = GetBossProfileProxyModels(profile, 0, 1);
			}
			if (modelsArray != null)
			{
				modelsArray.GetString(GetRandomInt(0, modelsArray.Length - 1), buffer, sizeof(buffer));
				if (buffer[0] != '\0')
				{
					SetVariantString(buffer);
					AcceptEntityInput(client, "SetCustomModel");
					SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
					strcopy(g_ClientProxyModel[client],sizeof(g_ClientProxyModel[]),buffer);
					strcopy(g_ClientProxyModelHard[client],sizeof(g_ClientProxyModelHard[]),buffer);
					strcopy(g_ClientProxyModelInsane[client],sizeof(g_ClientProxyModelInsane[]),buffer);
					strcopy(g_ClientProxyModelNightmare[client],sizeof(g_ClientProxyModelNightmare[]),buffer);
					strcopy(g_ClientProxyModelApollyon[client],sizeof(g_ClientProxyModelApollyon[]),buffer);
					//Prevent plugins like Model manager to override proxy model.
					CreateTimer(0.5, ClientCheckProxyModel, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}

		if (IsPlayerAlive(client))
		{
			g_PlayerProxyNextVoiceSound[client] = GetGameTime();
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileProxySpawnSounds(profile, soundInfo);
			// Play any sounds, if any.
			soundInfo.EmitSound(_, client);

			bool zombie = GetBossProfileProxyZombiesState(profile);
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
	}
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
