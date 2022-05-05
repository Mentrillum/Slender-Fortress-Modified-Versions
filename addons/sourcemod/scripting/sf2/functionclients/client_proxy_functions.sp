#if defined _sf2_client_proxy_functions_included
 #endinput
#endif
#define _sf2_client_proxy_functions_included

void ClientResetProxy(int client, bool resetFull=true)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetProxy(%d)", client);
	}
#endif

	int oldMaster = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);
	char oldProfileName[SF2_MAX_PROFILE_NAME_LENGTH];
	if (oldMaster >= 0)
	{
		NPCGetProfile(oldMaster, oldProfileName, sizeof(oldProfileName));
	}
	
	bool oldProxy = g_PlayerProxy[client];
	if (resetFull) 
	{
		g_PlayerProxy[client] = false;
		g_PlayerProxyMaster[client] = -1;
	}
	
	g_PlayerProxyControl[client] = 0;
	g_PlayerProxyControlTimer[client] = null;
	g_PlayerProxyControlRate[client] = 0.0;
	g_PlayerProxyVoiceTimer[client] = null;
	
	if (IsClientInGame(client))
	{
		if (oldProxy)
		{
			ClientStartProxyAvailableTimer(client);
		
			if (resetFull)
			{
				ClientDisableConstantGlow(client);
				SetVariantString("");
				AcceptEntityInput(client, "SetCustomModel");
			}
			
			if (oldProfileName[0] != '\0')
			{
				ClientStopAllSlenderSounds(client, oldProfileName, "sound_proxy_spawn", g_SlenderProxySpawnChannel[oldMaster]);
				ClientStopAllSlenderSounds(client, oldProfileName, "sound_proxy_hurt", g_SlenderProxyHurtChannel[oldMaster]);
				ClientStopAllSlenderSounds(client, oldProfileName, "sound_proxy_idle", g_SlenderProxyIdleChannel[oldMaster]);
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

public Action Timer_ClientForceProxy(Handle timer, any userid)
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
				if (!IsClientInGame(i) || !g_PlayerEliminated[i])
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
	Handle menu = CreateMenu(Menu_ProxyAsk);
	SetMenuTitle(menu, "%T\n \n%T\n \n", "SF2 Proxy Ask Menu Title", client, "SF2 Proxy Ask Menu Description", client);
	
	FormatEx(buffer, sizeof(buffer), "%T", "Yes", client);
	AddMenuItem(menu, "1", buffer);
	FormatEx(buffer, sizeof(buffer), "%T", "No", client);
	AddMenuItem(menu, "0", buffer);
	
	g_PlayerProxyAskMaster[client] = askMaster;
	for (int i = 0; i < 3; i++)
	{
		g_PlayerProxyAskPosition[client][i] = pos[i];
	}
	g_PlayerProxyAskSpawnPoint[client] = EnsureEntRef(spawnPoint);

	DisplayMenu(menu, client, 15);
}

public int Menu_ProxyAsk(Handle menu, MenuAction action,int param1,int param2)
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
						if (!IsClientInGame(client) || !g_PlayerEliminated[client])
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
}

public Action Timer_ClientProxyAvailable(Handle timer, any userid)
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
	ClientDisableConstantGlow(client);
	
	ClientStopProxyForce(client);

	if (IsClientInKart(client))
	{
		TF2_RemoveCondition(client,TFCond_HalloweenKart);
		TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
		TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
		TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
	}

	g_PlayerProxy[client] = true;
	ChangeClientTeamNoSuicide(client, TFTeam_Blue);
	PvP_SetPlayerPvPState(client, false, true, false);
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
	GetProfileString(profile, "proxies_classes", allowedClasses, sizeof(allowedClasses));
	
	char className[64];
	TF2_GetClassName(TF2_GetPlayerClass(client), className, sizeof(className));
	if (allowedClasses[0] && className[0] && StrContains(allowedClasses, className, false) == -1)
	{
		// Pick the first class that's allowed.
		char allowedClassesList[32][32];
		int iClassCount = ExplodeString(allowedClasses, " ", allowedClassesList, 32, 32);
		if (iClassCount)
		{
			TF2_SetPlayerClass(client, TF2_GetClass(allowedClassesList[0]), _, false);
			
			int maxHealth = GetEntProp(client, Prop_Send, "m_iHealth");
			TF2_RegeneratePlayer(client);
			SetEntProp(client, Prop_Data, "m_iHealth", maxHealth);
			SetEntProp(client, Prop_Send, "m_iHealth", maxHealth);
		}
	}
	
	UTIL_ScreenFade(client, 200, 1, FFADE_IN, 255, 255, 255, 100);
	EmitSoundToClient(client, "weapons/teleporter_send.wav", _, SNDCHAN_STATIC);
	
	ClientActivateUltravision(client);
	ClientDisableConstantGlow(client);
	
	CreateTimer(0.33, Timer_ApplyCustomModel, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

	if (NPCHasProxyWeapons(bossIndex)) CreateTimer(1.0, Timer_GiveWeaponAll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	
	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{	
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		if (g_SlenderInDeathcam[npcIndex])
		{
			continue;
		}
		SlenderRemoveGlow(npcIndex);
		if (NPCGetCustomOutlinesState(npcIndex))
		{
			int color[4];
			color[0] = NPCGetOutlineColorR(npcIndex);
			color[1] = NPCGetOutlineColorG(npcIndex);
			color[2] = NPCGetOutlineColorB(npcIndex);
			color[3] = NPCGetOutlineTransparency(npcIndex);
			if (color[0] < 0)
			{
				color[0] = 0;
			}
			if (color[1] < 0)
			{
				color[1] = 0;
			}
			if (color[2] < 0)
			{
				color[2] = 0;
			}
			if (color[3] < 0)
			{
				color[3] = 0;
			}
			if (color[0] > 255)
			{
				color[0] = 255;
			}
			if (color[1] > 255)
			{
				color[1] = 255;
			}
			if (color[2] > 255)
			{
				color[2] = 255;
			}
			if (color[3] > 255)
			{
				color[3] = 255;
			}
			SlenderAddGlow(npcIndex,_,color);
		}
		else
		{
			int purple[4] = {150, 0, 255, 255};
			SlenderAddGlow(npcIndex,_,purple);
		}
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		ClientDisableConstantGlow(i);
		if (!g_PlayerProxy[i] && !DidClientEscape(i) && !g_PlayerEliminated[i])
		{
			int iRed[4] = {184, 56, 59, 255};
			ClientEnableConstantGlow(i, "head", iRed);
		}
		else if ((g_PlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
		{
			int yellow[4] = {255, 208, 0, 255};
			ClientEnableConstantGlow(i, "head", yellow);
		}
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
		GetProfileString(profile, "proxies_spawn_effect", spawnEffect, sizeof(spawnEffect));
		CreateGeneralParticle(client, spawnEffect, NPCGetProxySpawnEffectZOffset(bossIndex));
	}

	Call_StartForward(g_OnClientSpawnedAsProxyFwd);
	Call_PushCell(client);
	Call_Finish();
}

public Action Timer_GiveWeaponAll(Handle timer, any userid)
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
		char weaponName[PLATFORM_MAX_PATH], weaponStats[PLATFORM_MAX_PATH], className[64], sectionName[64];
		TF2_GetClassName(TF2_GetPlayerClass(client), className, sizeof(className));
		FormatEx(sectionName, sizeof(sectionName), "proxies_weapon_class_%s", className);
		GetProfileString(profile, sectionName, weaponName, sizeof(weaponName));
		FormatEx(sectionName, sizeof(sectionName), "proxies_weapon_stats_%s", className);
		GetProfileString(profile, sectionName, weaponStats, sizeof(weaponStats));
		FormatEx(sectionName, sizeof(sectionName), "proxies_weapon_index_%s", className);
		weaponIndex = GetProfileNum(profile, sectionName, 0);
		FormatEx(sectionName, sizeof(sectionName), "proxies_weapon_slot_%s", className);
		weaponSlot = GetProfileNum(profile, sectionName, 0);

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
		Handle weaponHandle = PrepareItemHandle(weaponName, weaponIndex, 0, 0, weaponStats, true);
		int entity = TF2Items_GiveNamedItem(client, weaponHandle);
		delete weaponHandle;
		weaponHandle = null;
		EquipPlayerWeapon(client, entity);
		SetEntProp(entity, Prop_Send, "m_bValidatedAttachedEntity", 1);
	}
	return Plugin_Stop;
}

public bool Hook_ClientProxyShouldCollide(int ent,int collisiongroup,int contentsmask, bool originalResult)
{
	if (!g_Enabled || !g_PlayerProxy[ent] || IsClientInPvP(ent))
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
}
//RequestFrame//
public void ProxyDeathAnimation(any client)
{
	if (client != -1)
	{
		if (g_ClientFrame[client]>=g_ClientMaxFrameDeathAnim[client])
		{
			g_ClientFrame[client]=-1;
			KillClient(client);
		}
		else
		{
			g_ClientFrame[client]+=1;
			RequestFrame(ProxyDeathAnimation,client);
		}	
	}
}
	
public Action Timer_ClientProxyControl(Handle timer, any userid)
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
		SDKHooks_TakeDamage(client, client, client, 9001.0, DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		return Plugin_Stop;
	}
	
	g_PlayerProxyControlTimer[client] = CreateTimer(g_PlayerProxyControlRate[client], Timer_ClientProxyControl, userid, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

public Action Timer_ApplyCustomModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int master = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);
	
	if (g_PlayerProxy[client] && master != -1)
	{
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(master, profile, sizeof(profile));
		
		// Set custom model, if any.
		char buffer[PLATFORM_MAX_PATH], bufferHard[PLATFORM_MAX_PATH], bufferInsane[PLATFORM_MAX_PATH], bufferNightmare[PLATFORM_MAX_PATH], bufferApollyon[PLATFORM_MAX_PATH];
		char sectionName[64];
		
		TF2_RegeneratePlayer(client);
		
		char className[64];
		TF2_GetClassName(TF2_GetPlayerClass(client), className, sizeof(className));

		if (view_as<bool>(g_Config.GetNum("proxy_difficulty_models", 0)))
		{
			char sectionNameHard[128], sectionNameInsane[128], sectionNameNightmare[128], sectionNameApollyon[128];
			
			FormatEx(sectionName, sizeof(sectionName), "mod_proxy_%s", className);
			FormatEx(sectionNameHard, sizeof(sectionNameHard), "mod_proxy_%s_hard", className);
			FormatEx(sectionNameInsane, sizeof(sectionNameInsane), "mod_proxy_%s_insane", className);
			FormatEx(sectionNameNightmare, sizeof(sectionNameNightmare), "mod_proxy_%s_nightmare", className);
			FormatEx(sectionNameApollyon, sizeof(sectionNameApollyon), "mod_proxy_%s_apollyon", className);
			
			if ((GetRandomStringFromProfile(profile, sectionName, buffer, sizeof(buffer)) && buffer[0] != '\0') ||
				(GetRandomStringFromProfile(profile, "mod_proxy_all", buffer, sizeof(buffer)) && buffer[0] != '\0'))
			{
				SetVariantString(buffer);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
				strcopy(g_ClientProxyModel[client],sizeof(g_ClientProxyModel[]),buffer);
				
				if ((GetRandomStringFromProfile(profile, sectionNameHard, bufferHard, sizeof(bufferHard)) && bufferHard[0] != '\0') ||
					(GetRandomStringFromProfile(profile, "mod_proxy_all_hard", bufferHard, sizeof(bufferHard)) && bufferHard[0] != '\0'))
				{
					strcopy(g_ClientProxyModelHard[client],sizeof(g_ClientProxyModelHard[]),bufferHard);
				}
				else
				{
					strcopy(bufferHard,sizeof(bufferHard),buffer);
					strcopy(g_ClientProxyModelHard[client],sizeof(g_ClientProxyModelHard[]),bufferHard);
				}
				
				if ((GetRandomStringFromProfile(profile, sectionNameInsane, bufferInsane, sizeof(bufferInsane)) && bufferInsane[0] != '\0') ||
					(GetRandomStringFromProfile(profile, "mod_proxy_all_insane", bufferInsane, sizeof(bufferInsane)) && bufferInsane[0] != '\0'))
				{
					strcopy(g_ClientProxyModelInsane[client],sizeof(g_ClientProxyModelInsane[]),bufferInsane);
				}
				else
				{
					strcopy(bufferInsane,sizeof(bufferInsane),bufferHard);
					strcopy(g_ClientProxyModelInsane[client],sizeof(g_ClientProxyModelInsane[]),bufferInsane);
				}
				
				if ((GetRandomStringFromProfile(profile, sectionNameNightmare, bufferNightmare, sizeof(bufferNightmare)) && bufferNightmare[0] != '\0') ||
					(GetRandomStringFromProfile(profile, "mod_proxy_all_nightmare", bufferNightmare, sizeof(bufferNightmare)) && bufferNightmare[0] != '\0'))
				{
					strcopy(g_ClientProxyModelNightmare[client],sizeof(g_ClientProxyModelNightmare[]),bufferNightmare);
				}
				else
				{
					strcopy(bufferNightmare,sizeof(bufferNightmare),bufferInsane);
					strcopy(g_ClientProxyModelNightmare[client],sizeof(g_ClientProxyModelNightmare[]),bufferNightmare);
				}
				
				if ((GetRandomStringFromProfile(profile, sectionNameApollyon, bufferApollyon, sizeof(bufferApollyon)) && bufferApollyon[0] != '\0') ||
					(GetRandomStringFromProfile(profile, "mod_proxy_all_apollyon", bufferApollyon, sizeof(bufferApollyon)) && bufferApollyon[0] != '\0'))
				{
					strcopy(g_ClientProxyModelApollyon[client],sizeof(g_ClientProxyModelApollyon[]),bufferApollyon);
				}
				else
				{
					strcopy(bufferApollyon,sizeof(bufferApollyon),bufferNightmare);
					strcopy(g_ClientProxyModelApollyon[client],sizeof(g_ClientProxyModelApollyon[]),bufferApollyon);
				}
				
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			FormatEx(sectionName, sizeof(sectionName), "mod_proxy_%s", className);
			if ((GetRandomStringFromProfile(profile, sectionName, buffer, sizeof(buffer)) && buffer[0] != '\0') ||
				(GetRandomStringFromProfile(profile, "mod_proxy_all", buffer, sizeof(buffer)) && buffer[0] != '\0'))
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
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				//PrintToChatAll("Proxy model:%s",g_ClientProxyModel[client]);
			}
		}
		
		ClientDisableConstantGlow(client);
		int yellow[4] = {255, 208, 0, 255};
		ClientEnableConstantGlow(client, "head", yellow);
		
		if (IsPlayerAlive(client))
		{
			g_PlayerProxyNextVoiceSound[client] = GetGameTime();
			// Play any sounds, if any.
			if (GetRandomStringFromProfile(profile, "sound_proxy_spawn", buffer, sizeof(buffer)) && buffer[0] != '\0')
			{
				int channel = g_SlenderProxySpawnChannel[master];
				int level = g_SlenderProxySpawnLevel[master];
				int flags = g_SlenderProxySpawnFlags[master];
				float volume = g_SlenderProxySpawnVolume[master];
				int pitch = g_SlenderProxySpawnPitch[master];
				
				EmitSoundToAll(buffer, client, channel, level, flags, volume, pitch);
			}
			
			bool zombie = view_as<bool>(GetProfileNum(profile, "proxies_zombie", 0));
			if (zombie)
			{
				int value = FindConVar("tf_forced_holiday").IntValue;
				if (value != 9 && value != 2)
				{
					FindConVar("tf_forced_holiday").SetInt(9);//Full-Moon
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

public Action ClientCheckProxyModel(Handle timer, any userid)
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
			if (strcmp(model,g_ClientProxyModel[client]) != 0)
			{
				SetVariantString(g_ClientProxyModel[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Hard:
		{
			if (strcmp(model,g_ClientProxyModelHard[client]) != 0)
			{
				SetVariantString(g_ClientProxyModelHard[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Insane:
		{
			if (strcmp(model,g_ClientProxyModelInsane[client]) != 0)
			{
				SetVariantString(g_ClientProxyModelInsane[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Nightmare:
		{
			if (strcmp(model,g_ClientProxyModelNightmare[client]) != 0)
			{
				SetVariantString(g_ClientProxyModelNightmare[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Apollyon:
		{
			if (strcmp(model,g_ClientProxyModelApollyon[client]) != 0)
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
	for(int client=1;client <=MaxClients;client++)
	{
		if (IsValidClient(client) && (!g_PlayerEliminated[client] || !IsClientInPvP(client)))
		{
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_PlayerPostWeaponsTimer[client]=CreateTimer(1.0,Timer_ClientPostWeapons,GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public Action Timer_ClientPostWeapons(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}
	
	if (IsClientInGame(client) && !IsPlayerAlive(client))
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
		if (IsClientInGame(client) && IsValidClient(client))
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
			keepUtilityItems = false;
		}
	}

	if (g_PlayerEliminated[client] && g_PlayerKeepWeaponsConVar.BoolValue)
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = true;
	}
	
	// pvp
	if (IsClientInPvP(client)) 
	{
		removeWeapons = false;
		restrictWeapons = false;
		keepUtilityItems = false;
		preventAttack = false;
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
										itemHandle = PrepareItemHandle("tf_weapon_bat", 0, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Sniper:
									{
										itemHandle = PrepareItemHandle("tf_weapon_club", 3, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Soldier:
									{
										itemHandle = PrepareItemHandle("tf_weapon_shovel", 6, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_DemoMan:
									{
										itemHandle = PrepareItemHandle("tf_weapon_bottle", 1, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Heavy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_fists", 5, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Medic:
									{
										itemHandle = PrepareItemHandle("tf_weapon_bonesaw", 8, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Pyro:
									{
										itemHandle = PrepareItemHandle("tf_weapon_fireaxe", 2, 0, 0, "", g_PlayerProxy[client]);
									}
									case TFClass_Spy:
									{
										itemHandle = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "");
									}
									case TFClass_Engineer:
									{
										itemHandle = PrepareItemHandle("tf_weapon_wrench", 7, 0, 0, "", g_PlayerProxy[client]);
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
							g_PlayerHasRegenerationItem[client] = IsRegenWeapon(weaponEnt);
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
					
					weaponHandle = PrepareItemHandle("tf_weapon_bonesaw", 304, 0, 0, "200 ; 0.0 ; 57 ; 2 ; 1 ; 0.8");
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
			if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
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
	if (IsClientInPvP(client) || ((SF_IsRaidMap() || SF_IsBoxingMap()) && !g_PlayerEliminated[client])) //DidClientEscape(client)
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

public void Frame_ReplaceSpyCicle(int client)
{
	if (IsClientInGame(client))
	{
		TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
		Handle itemHandle = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "");
		int newKnife = TF2Items_GiveNamedItem(client, itemHandle);
		delete itemHandle;
		itemHandle = null;
		EquipPlayerWeapon(client, newKnife);
		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
	}
}

public void Frame_ClientHealArrow(int client)
{
	if (IsClientInGame(client) && IsClientInPvP(client))
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
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
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
		//returnBool = view_as<bool>(g_RestrictedWeaponsConfig.GetNum(itemDef));
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
				returnBool=true;
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
		//returnBool = view_as<bool>(g_RestrictedWeaponsConfig.GetNum(itemDef, returnBool));
		if (g_RestrictedWeaponsConfig.GetNum(itemDef)==1)
		{
			returnBool=true;
		}
		if (proxyBoss && !returnBool)
		{
			int proxyRestricted = g_RestrictedWeaponsConfig.GetNum(itemDef, 0);
			if (proxyRestricted==2)
			{
				returnBool=true;
			}
		}
	}
	
	return returnBool;
}
