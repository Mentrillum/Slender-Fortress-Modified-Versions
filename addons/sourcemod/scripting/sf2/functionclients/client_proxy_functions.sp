#if defined _sf2_client_proxy_functions_included
 #endinput
#endif
#define _sf2_client_proxy_functions_included

void ClientResetProxy(int client, bool bResetFull=true)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetProxy(%d)", client);
#endif

	int iOldMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[client]);
	char sOldProfileName[SF2_MAX_PROFILE_NAME_LENGTH];
	if (iOldMaster >= 0)
	{
		NPCGetProfile(iOldMaster, sOldProfileName, sizeof(sOldProfileName));
	}
	
	bool bOldProxy = g_bPlayerProxy[client];
	if (bResetFull) 
	{
		g_bPlayerProxy[client] = false;
		g_iPlayerProxyMaster[client] = -1;
	}
	
	g_iPlayerProxyControl[client] = 0;
	g_hPlayerProxyControlTimer[client] = null;
	g_flPlayerProxyControlRate[client] = 0.0;
	g_flPlayerProxyVoiceTimer[client] = null;
	
	if (IsClientInGame(client))
	{
		if (bOldProxy)
		{
			ClientStartProxyAvailableTimer(client);
		
			if (bResetFull)
			{
				ClientDisableConstantGlow(client);
				SetVariantString("");
				AcceptEntityInput(client, "SetCustomModel");
			}
			
			if (sOldProfileName[0] != '\0')
			{
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_spawn", g_iSlenderProxySpawnChannel[iOldMaster]);
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_hurt", g_iSlenderProxyHurtChannel[iOldMaster]);
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_idle", g_iSlenderProxyIdleChannel[iOldMaster]);
			}
		}
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetProxy(%d)", client);
#endif
}

void ClientStartProxyAvailableTimer(int client)
{
	g_bPlayerProxyAvailable[client] = false;
	float flCooldown = g_cvPlayerProxyWaitTime.FloatValue;
	if (g_bProxySurvivalRageMode) flCooldown -= 10.0;
	if (flCooldown <= 0.0) flCooldown = 0.0;
	
	g_hPlayerProxyAvailableTimer[client] = CreateTimer(flCooldown, Timer_ClientProxyAvailable, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStartProxyForce(int client, int iSlenderID, const float flPos[3], int iSpawnPoint)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientStartProxyForce(%d, %d, flPos)", client, iSlenderID);
#endif

	g_iPlayerProxyAskMaster[client] = iSlenderID;
	for (int i = 0; i < 3; i++) g_iPlayerProxyAskPosition[client][i] = flPos[i];
	g_iPlayerProxyAskSpawnPoint[client] = EnsureEntRef(iSpawnPoint);

	g_iPlayerProxyAvailableCount[client] = 0;
	g_bPlayerProxyAvailableInForce[client] = true;
	g_hPlayerProxyAvailableTimer[client] = CreateTimer(1.0, Timer_ClientForceProxy, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	TriggerTimer(g_hPlayerProxyAvailableTimer[client], true);
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientStartProxyForce(%d, %d, flPos)", client, iSlenderID);
#endif
}

void ClientStopProxyForce(int client)
{
	g_iPlayerProxyAvailableCount[client] = 0;
	g_bPlayerProxyAvailableInForce[client] = false;
	g_hPlayerProxyAvailableTimer[client] = null;
}

public Action Timer_ClientForceProxy(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerProxyAvailableTimer[client]) return Plugin_Stop;

	
	if (!IsRoundEnding())
	{
		int iBossIndex = NPCGetFromUniqueID(g_iPlayerProxyAskMaster[client]);
		if (iBossIndex != -1)
		{
			int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
		
			int iMaxProxies = g_iSlenderMaxProxies[iBossIndex][iDifficulty];
			int iNumProxies = 0;
			
			for (int iClient = 1; iClient <= MaxClients; iClient++)
			{
				if (!IsClientInGame(iClient) || !g_bPlayerEliminated[iClient]) continue;
				if (!g_bPlayerProxy[iClient]) continue;
				if (NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]) != iBossIndex) continue;
				
				iNumProxies++;
			}
			
			if (iNumProxies < iMaxProxies)
			{
				if (g_iPlayerProxyAvailableCount[client] > 0)
				{
					g_iPlayerProxyAvailableCount[client]--;
					
					SetHudTextParams(-1.0, 0.25, 
						1.0,
						255, 255, 255, 255,
						_,
						_,
						0.25, 1.25);
					
					ShowSyncHudText(client, g_hHudSync, "%T", "SF2 Proxy Force Message", client, g_iPlayerProxyAvailableCount[client]);
					
					return Plugin_Continue;
				}
				else
				{
					ClientEnableProxy(client, iBossIndex, g_iPlayerProxyAskPosition[client], g_iPlayerProxyAskSpawnPoint[client]);
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

void DisplayProxyAskMenu(int client, int iAskMaster, const float flPos[3], int iSpawnPoint)
{
	if (IsRoundEnding() || IsRoundInIntro() || IsRoundInWarmup()) return;
	char sBuffer[512];
	Handle hMenu = CreateMenu(Menu_ProxyAsk);
	SetMenuTitle(hMenu, "%T\n \n%T\n \n", "SF2 Proxy Ask Menu Title", client, "SF2 Proxy Ask Menu Description", client);
	
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "1", sBuffer);
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	
	g_iPlayerProxyAskMaster[client] = iAskMaster;
	for (int i = 0; i < 3; i++) g_iPlayerProxyAskPosition[client][i] = flPos[i];
	g_iPlayerProxyAskSpawnPoint[client] = EnsureEntRef(iSpawnPoint);

	DisplayMenu(hMenu, client, 15);
}

public int Menu_ProxyAsk(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			if (!IsRoundEnding() && !IsRoundInIntro() && !IsRoundInWarmup())
			{
				int iBossIndex = NPCGetFromUniqueID(g_iPlayerProxyAskMaster[param1]);
				if (iBossIndex != -1)
				{
					int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
				
					int iMaxProxies = g_iSlenderMaxProxies[iBossIndex][iDifficulty];
					int iNumProxies;
				
					for (int iClient = 1; iClient <= MaxClients; iClient++)
					{
						if (!IsClientInGame(iClient) || !g_bPlayerEliminated[iClient]) continue;
						if (!g_bPlayerProxy[iClient]) continue;
						if (NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]) != iBossIndex) continue;
						
						iNumProxies++;
					}
					
					if (iNumProxies < iMaxProxies)
					{
						if (param2 == 0)
						{
							bool bIgnoreVisibility = false;
							int iSpawnPoint = g_iPlayerProxyAskSpawnPoint[param1];
							float flSpawnPos[3];

							if (IsValidEntity(iSpawnPoint))
							{
								GetEntPropVector(iSpawnPoint, Prop_Data, "m_vecAbsOrigin", flSpawnPos);

								SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(iSpawnPoint);
								if (spawnPoint.IsValid()) bIgnoreVisibility = spawnPoint.IgnoreVisibility;
							}
							else 
							{
								for (int i = 0; i < 3; i++) flSpawnPos[i] = g_iPlayerProxyAskPosition[param1][i];
							}

							if (bIgnoreVisibility || !IsPointVisibleToAPlayer(flSpawnPos, _, false))
							{
								ClientEnableProxy(param1, iBossIndex, flSpawnPos, iSpawnPoint);
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
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerProxyAvailableTimer[client]) return Plugin_Stop;
	
	g_bPlayerProxyAvailable[client] = true;
	g_hPlayerProxyAvailableTimer[client] = null;

	return Plugin_Stop;
}

/**
 *	Respawns a player as a proxy.
 *
 *	@noreturn
 */
void ClientEnableProxy(int client, int iBossIndex, const float flPos[3], int iSpawnPoint=-1)
{
	if (NPCGetUniqueID(iBossIndex) == -1) return;
	if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) return;
	if (GetClientTeam(client) != TFTeam_Blue) return;
	if (g_bPlayerProxy[client]) return;

	TF2_RemovePlayerDisguise(client);

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
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

	g_bPlayerProxy[client] = true;
	ChangeClientTeamNoSuicide(client, TFTeam_Blue);
	PvP_SetPlayerPvPState(client, false, true, false);
	TF2_RespawnPlayer(client);

	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);
	
	g_bPlayerProxy[client] = true;
	g_iPlayerProxyMaster[client] = NPCGetUniqueID(iBossIndex);
	g_iPlayerProxyControl[client] = 100;
	g_flPlayerProxyControlRate[client] = g_flSlenderProxyControlDrainRate[iBossIndex][iDifficulty];
	g_hPlayerProxyControlTimer[client] = CreateTimer(g_flPlayerProxyControlRate[client], Timer_ClientProxyControl, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	g_bPlayerProxyAvailable[client] = false;
	g_hPlayerProxyAvailableTimer[client] = null;
	
	char sAllowedClasses[512];
	GetProfileString(sProfile, "proxies_classes", sAllowedClasses, sizeof(sAllowedClasses));
	
	char sClassName[64];
	TF2_GetClassName(TF2_GetPlayerClass(client), sClassName, sizeof(sClassName));
	if (sAllowedClasses[0] && sClassName[0] && StrContains(sAllowedClasses, sClassName, false) == -1)
	{
		// Pick the first class that's allowed.
		char sAllowedClassesList[32][32];
		int iClassCount = ExplodeString(sAllowedClasses, " ", sAllowedClassesList, 32, 32);
		if (iClassCount)
		{
			TF2_SetPlayerClass(client, TF2_GetClass(sAllowedClassesList[0]), _, false);
			
			int iMaxHealth = GetEntProp(client, Prop_Send, "m_iHealth");
			TF2_RegeneratePlayer(client);
			SetEntProp(client, Prop_Data, "m_iHealth", iMaxHealth);
			SetEntProp(client, Prop_Send, "m_iHealth", iMaxHealth);
		}
	}
	
	UTIL_ScreenFade(client, 200, 1, FFADE_IN, 255, 255, 255, 100);
	EmitSoundToClient(client, "weapons/teleporter_send.wav", _, SNDCHAN_STATIC);
	
	ClientActivateUltravision(client);
	ClientDisableConstantGlow(client);
	
	CreateTimer(0.33, Timer_ApplyCustomModel, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

	if (NPCHasProxyWeapons(iBossIndex)) CreateTimer(1.0, Timer_GiveWeaponAll, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{	
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		if (g_bSlenderInDeathcam[iNPCIndex]) continue;
		SlenderRemoveGlow(iNPCIndex);
		if (NPCGetCustomOutlinesState(iNPCIndex))
		{
			int color[4];
			color[0] = NPCGetOutlineColorR(iNPCIndex);
			color[1] = NPCGetOutlineColorG(iNPCIndex);
			color[2] = NPCGetOutlineColorB(iNPCIndex);
			color[3] = NPCGetOutlineTransparency(iNPCIndex);
			if (color[0] < 0) color[0] = 0;
			if (color[1] < 0) color[1] = 0;
			if (color[2] < 0) color[2] = 0;
			if (color[3] < 0) color[3] = 0;
			if (color[0] > 255) color[0] = 255;
			if (color[1] > 255) color[1] = 255;
			if (color[2] > 255) color[2] = 255;
			if (color[3] > 255) color[3] = 255;
			SlenderAddGlow(iNPCIndex,_,color);
		}
		else
		{
			int iPurple[4] = {150, 0, 255, 255};
			SlenderAddGlow(iNPCIndex,_,iPurple);
		}
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		ClientDisableConstantGlow(i);
		if (!g_bPlayerProxy[i] && !DidClientEscape(i) && !g_bPlayerEliminated[i])
		{
			int iRed[4] = {184, 56, 59, 255};
			ClientEnableConstantGlow(i, "head", iRed);
		}
		else if ((g_bPlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
		{
			int iYellow[4] = {255, 208, 0, 255};
			ClientEnableConstantGlow(i, "head", iYellow);
		}
	}
	
	//SDKHook(client, SDKHook_ShouldCollide, Hook_ClientProxyShouldCollide);
	
	SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(iSpawnPoint);
	if (spawnPoint.IsValid())
	{
		float flSpawnPos[3]; float flAng[3];
		GetEntPropVector(iSpawnPoint, Prop_Data, "m_vecAbsOrigin", flSpawnPos);
		GetEntPropVector(iSpawnPoint, Prop_Data, "m_angAbsRotation", flAng);
		TeleportEntity(client, flSpawnPos, flAng, view_as<float>({ 0.0, 0.0, 0.0 }));
		spawnPoint.FireOutput("OnSpawn", client);
	}
	else 
	{
		TeleportEntity(client, flPos, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
	}

	if (NPCGetProxySpawnEffectState(iBossIndex))
	{
		char sSpawnEffect[PLATFORM_MAX_PATH];
		GetProfileString(sProfile, "proxies_spawn_effect", sSpawnEffect, sizeof(sSpawnEffect));
		CreateGeneralParticle(client, sSpawnEffect, NPCGetProxySpawnEffectLifetime(iBossIndex), NPCGetProxySpawnEffectZOffset(iBossIndex));
	}

	Call_StartForward(fOnClientSpawnedAsProxy);
	Call_PushCell(client);
	Call_Finish();
}

public Action Timer_GiveWeaponAll(Handle timer, any userid)
{
	if (!g_bEnabled) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = NPCGetFromUniqueID(g_iPlayerProxyMaster[client]);
	
	if (g_bPlayerProxy[client] && iBossIndex != -1)
	{
		if (!NPCHasProxyWeapons(iBossIndex)) return Plugin_Stop;
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

		int iWeaponIndex, iWeaponSlot;
		char sWeaponName[PLATFORM_MAX_PATH], sWeaponStats[PLATFORM_MAX_PATH], sClassName[64], sSectionName[64];
		TF2_GetClassName(TF2_GetPlayerClass(client), sClassName, sizeof(sClassName));
		FormatEx(sSectionName, sizeof(sSectionName), "proxies_weapon_class_%s", sClassName);
		GetProfileString(sProfile, sSectionName, sWeaponName, sizeof(sWeaponName));
		FormatEx(sSectionName, sizeof(sSectionName), "proxies_weapon_stats_%s", sClassName);
		GetProfileString(sProfile, sSectionName, sWeaponStats, sizeof(sWeaponStats));
		FormatEx(sSectionName, sizeof(sSectionName), "proxies_weapon_index_%s", sClassName);
		iWeaponIndex = GetProfileNum(sProfile, sSectionName, 0);
		FormatEx(sSectionName, sizeof(sSectionName), "proxies_weapon_slot_%s", sClassName);
		iWeaponSlot = GetProfileNum(sProfile, sSectionName, 0);

		switch(iWeaponSlot)
		{
			case 0: TF2_RemoveWeaponSlot(client, TFWeaponSlot_Primary);
			case 1: TF2_RemoveWeaponSlot(client, TFWeaponSlot_Secondary);
			case 2: TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
		}
		Handle hWeapon = PrepareItemHandle(sWeaponName, iWeaponIndex, 0, 0, sWeaponStats, true);
		int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
		delete hWeapon;
		hWeapon = null;
		EquipPlayerWeapon(client, iEnt);
		SetEntProp(iEnt, Prop_Send, "m_bValidatedAttachedEntity", 1);
	}
	return Plugin_Stop;
}

public bool Hook_ClientProxyShouldCollide(int ent,int collisiongroup,int contentsmask, bool originalResult)
{
	if (!g_bEnabled || !g_bPlayerProxy[ent] || IsClientInPvP(ent))
	{
		SDKUnhook(ent, SDKHook_ShouldCollide, Hook_ClientProxyShouldCollide);
		return originalResult;
	}
	if ((contentsmask & MASK_RED))
		return true;
	//To-do add no collision proxy-boss here, the collision boss-proxy is done, see npc_chaser.sp
	return originalResult;
}
//RequestFrame//
public void ProxyDeathAnimation(any client)
{
	if (client != -1)
	{
		if(g_iClientFrame[client]>=g_iClientMaxFrameDeathAnim[client])
		{
			g_iClientFrame[client]=-1;
			KillClient(client);
		}
		else
		{
			g_iClientFrame[client]+=1;
			RequestFrame(ProxyDeathAnimation,client);
		}	
	}
}
	
public Action Timer_ClientProxyControl(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerProxyControlTimer[client]) return Plugin_Stop;
	
	g_iPlayerProxyControl[client]--;
	if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
		g_iPlayerProxyControl[client] -= 5;
	if (g_iPlayerProxyControl[client] <= 0)
	{
		// ForcePlayerSuicide isn't really dependable, since the player doesn't suicide until several seconds after spawning has passed.
		SDKHooks_TakeDamage(client, client, client, 9001.0, DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		return Plugin_Stop;
	}
	
	g_hPlayerProxyControlTimer[client] = CreateTimer(g_flPlayerProxyControlRate[client], Timer_ClientProxyControl, userid, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

public Action Timer_ApplyCustomModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[client]);
	
	if (g_bPlayerProxy[client] && iMaster != -1)
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
		
		// Set custom model, if any.
		char sBuffer[PLATFORM_MAX_PATH], sBufferHard[PLATFORM_MAX_PATH], sBufferInsane[PLATFORM_MAX_PATH], sBufferNightmare[PLATFORM_MAX_PATH], sBufferApollyon[PLATFORM_MAX_PATH];
		char sSectionName[64];
		
		TF2_RegeneratePlayer(client);
		
		char sClassName[64];
		TF2_GetClassName(TF2_GetPlayerClass(client), sClassName, sizeof(sClassName));

		if (view_as<bool>(g_hConfig.GetNum("proxy_difficulty_models", 0)))
		{
			char sSectionNameHard[128], sSectionNameInsane[128], sSectionNameNightmare[128], sSectionNameApollyon[128];
			
			FormatEx(sSectionName, sizeof(sSectionName), "mod_proxy_%s", sClassName);
			FormatEx(sSectionNameHard, sizeof(sSectionNameHard), "mod_proxy_%s_hard", sClassName);
			FormatEx(sSectionNameInsane, sizeof(sSectionNameInsane), "mod_proxy_%s_insane", sClassName);
			FormatEx(sSectionNameNightmare, sizeof(sSectionNameNightmare), "mod_proxy_%s_nightmare", sClassName);
			FormatEx(sSectionNameApollyon, sizeof(sSectionNameApollyon), "mod_proxy_%s_apollyon", sClassName);
			
			if ((GetRandomStringFromProfile(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0') ||
				(GetRandomStringFromProfile(sProfile, "mod_proxy_all", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0'))
			{
				SetVariantString(sBuffer);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
				strcopy(g_sClientProxyModel[client],sizeof(g_sClientProxyModel[]),sBuffer);
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameHard, sBufferHard, sizeof(sBufferHard)) && sBufferHard[0] != '\0') ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_hard", sBufferHard, sizeof(sBufferHard)) && sBufferHard[0] != '\0'))
				{
					strcopy(g_sClientProxyModelHard[client],sizeof(g_sClientProxyModelHard[]),sBufferHard);
				}
				else
				{
					strcopy(sBufferHard,sizeof(sBufferHard),sBuffer);
					strcopy(g_sClientProxyModelHard[client],sizeof(g_sClientProxyModelHard[]),sBufferHard);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameInsane, sBufferInsane, sizeof(sBufferInsane)) && sBufferInsane[0] != '\0') ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_insane", sBufferInsane, sizeof(sBufferInsane)) && sBufferInsane[0] != '\0'))
				{
					strcopy(g_sClientProxyModelInsane[client],sizeof(g_sClientProxyModelInsane[]),sBufferInsane);
				}
				else
				{
					strcopy(sBufferInsane,sizeof(sBufferInsane),sBufferHard);
					strcopy(g_sClientProxyModelInsane[client],sizeof(g_sClientProxyModelInsane[]),sBufferInsane);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameNightmare, sBufferNightmare, sizeof(sBufferNightmare)) && sBufferNightmare[0] != '\0') ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_nightmare", sBufferNightmare, sizeof(sBufferNightmare)) && sBufferNightmare[0] != '\0'))
				{
					strcopy(g_sClientProxyModelNightmare[client],sizeof(g_sClientProxyModelNightmare[]),sBufferNightmare);
				}
				else
				{
					strcopy(sBufferNightmare,sizeof(sBufferNightmare),sBufferInsane);
					strcopy(g_sClientProxyModelNightmare[client],sizeof(g_sClientProxyModelNightmare[]),sBufferNightmare);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameApollyon, sBufferApollyon, sizeof(sBufferApollyon)) && sBufferApollyon[0] != '\0') ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_apollyon", sBufferApollyon, sizeof(sBufferApollyon)) && sBufferApollyon[0] != '\0'))
				{
					strcopy(g_sClientProxyModelApollyon[client],sizeof(g_sClientProxyModelApollyon[]),sBufferApollyon);
				}
				else
				{
					strcopy(sBufferApollyon,sizeof(sBufferApollyon),sBufferNightmare);
					strcopy(g_sClientProxyModelApollyon[client],sizeof(g_sClientProxyModelApollyon[]),sBufferApollyon);
				}
				
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			FormatEx(sSectionName, sizeof(sSectionName), "mod_proxy_%s", sClassName);
			if ((GetRandomStringFromProfile(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0') ||
				(GetRandomStringFromProfile(sProfile, "mod_proxy_all", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0'))
			{
				SetVariantString(sBuffer);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
				strcopy(g_sClientProxyModel[client],sizeof(g_sClientProxyModel[]),sBuffer);
				strcopy(g_sClientProxyModelHard[client],sizeof(g_sClientProxyModelHard[]),sBuffer);
				strcopy(g_sClientProxyModelInsane[client],sizeof(g_sClientProxyModelInsane[]),sBuffer);
				strcopy(g_sClientProxyModelNightmare[client],sizeof(g_sClientProxyModelNightmare[]),sBuffer);
				strcopy(g_sClientProxyModelApollyon[client],sizeof(g_sClientProxyModelApollyon[]),sBuffer);
				//Prevent plugins like Model manager to override proxy model.
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				//PrintToChatAll("Proxy model:%s",g_sClientProxyModel[client]);
			}
		}
		
		ClientDisableConstantGlow(client);
		int iYellow[4] = {255, 208, 0, 255};
		ClientEnableConstantGlow(client, "head", iYellow);
		
		if (IsPlayerAlive(client))
		{
			g_flPlayerProxyNextVoiceSound[client] = GetGameTime();
			// Play any sounds, if any.
			if (GetRandomStringFromProfile(sProfile, "sound_proxy_spawn", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0')
			{
				int iChannel = g_iSlenderProxySpawnChannel[iMaster];
				int iLevel = g_iSlenderProxySpawnLevel[iMaster];
				int iFlags = g_iSlenderProxySpawnFlags[iMaster];
				float flVolume = g_flSlenderProxySpawnVolume[iMaster];
				int iPitch = g_iSlenderProxySpawnPitch[iMaster];
				
				EmitSoundToAll(sBuffer, client, iChannel, iLevel, iFlags, flVolume, iPitch);
			}
			
			bool Zombie = view_as<bool>(GetProfileNum(sProfile, "proxies_zombie", 0));
			if(Zombie)
			{
				int value = FindConVar("tf_forced_holiday").IntValue;
				if(value != 9 && value != 2)
					FindConVar("tf_forced_holiday").SetInt(9);//Full-Moon
				int index;
				TFClassType iClass = TF2_GetPlayerClass( client );
				switch(iClass)
				{
					case TFClass_Scout: index = 5617;
					case TFClass_Soldier: index = 5618;
					case TFClass_Pyro: index = 5624;
					case TFClass_DemoMan: index = 5620;
					case TFClass_Engineer: index = 5621;
					case TFClass_Heavy: index = 5619;
					case TFClass_Medic: index = 5622;
					case TFClass_Sniper: index = 5625;
					case TFClass_Spy: index = 5623;
				}
				Handle ZombieSoul = PrepareItemHandle("tf_wearable", index, 100, 7,"448 ; 1.0 ; 450 ; 1");
				int entity = TF2Items_GiveNamedItem(client, ZombieSoul);
				delete ZombieSoul;
				ZombieSoul = null;
				if( IsValidEdict( entity ) )
				{
					SDK_EquipWearable(client, entity);
				}
				if(TF2_GetPlayerClass(client) == TFClass_Spy)
					SetEntProp(client, Prop_Send, "m_nForcedSkin", 23);
				else
					SetEntProp(client, Prop_Send, "m_nForcedSkin", 5);
			}	
			
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
		}
	}
	return Plugin_Stop;
}

public Action ClientCheckProxyModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if(client <= 0) return Plugin_Stop;
	if(!IsValidClient(client)) return Plugin_Stop;
	if(!IsPlayerAlive(client)) return Plugin_Stop;
	if(!g_bPlayerProxy[client]) return Plugin_Stop;
	int iDifficulty = g_cvDifficulty.IntValue;
	
	char sModel[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
	switch (iDifficulty)
	{
		case Difficulty_Normal:
		{
			if (strcmp(sModel,g_sClientProxyModel[client]) != 0)
			{
				SetVariantString(g_sClientProxyModel[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Hard:
		{
			if (strcmp(sModel,g_sClientProxyModelHard[client]) != 0)
			{
				SetVariantString(g_sClientProxyModelHard[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Insane:
		{
			if (strcmp(sModel,g_sClientProxyModelInsane[client]) != 0)
			{
				SetVariantString(g_sClientProxyModelInsane[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Nightmare:
		{
			if (strcmp(sModel,g_sClientProxyModelNightmare[client]) != 0)
			{
				SetVariantString(g_sClientProxyModelNightmare[client]);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
			}
		}
		case Difficulty_Apollyon:
		{
			if (strcmp(sModel,g_sClientProxyModelApollyon[client]) != 0)
			{
				SetVariantString(g_sClientProxyModelApollyon[client]);
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
		if(IsValidClient(client) && (!g_bPlayerEliminated[client] || !IsClientInPvP(client)))
		{
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_hPlayerPostWeaponsTimer[client]=CreateTimer(1.0,Timer_ClientPostWeapons,GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}
public Action Timer_ClientPostWeapons(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (IsClientInGame(client) && !IsPlayerAlive(client)) return Plugin_Stop;
	
	if (!IsValidClient(client)) return Plugin_Stop;
	
	if (timer != g_hPlayerPostWeaponsTimer[client]) return Plugin_Stop;
	
	g_bPlayerHasRegenerationItem[client] = false;

#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) 
	{
		DebugMessage("START Timer_ClientPostWeapons(%d)", client);
	}
	
	int iOldWeaponItemIndexes[6] = { -1, ... };
	int iNewWeaponItemIndexes[6] = { -1, ... };
	
	for (int i = 0; i <= 5; i++)
	{
		if (IsClientInGame(client) && IsValidClient(client))
		{
			int iWeapon = GetPlayerWeaponSlot(client, i);
			if (!IsValidEdict(iWeapon)) continue;
			
			iOldWeaponItemIndexes[i] = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
		}
	}
#endif
	
	bool bRemoveWeapons = true;
	bool bKeepUtilityItems = false;
	bool bRestrictWeapons = true;
	bool bUseStock = false;
	bool bRemoveWearables = false;
	bool bPreventAttack = false;
	
	if (IsRoundEnding())
	{
		if (!g_bPlayerEliminated[client]) 
		{
			bRemoveWeapons = false;
			bRestrictWeapons = false;
			bKeepUtilityItems = false;
		}
	}

	if (g_bPlayerEliminated[client] && g_cvPlayerKeepWeapons.BoolValue)
	{
		bRemoveWeapons = false;
		bRestrictWeapons = false;
		bKeepUtilityItems = false;
		bPreventAttack = true;
	}
	
	// pvp
	if (IsClientInPvP(client)) 
	{
		bRemoveWeapons = false;
		bRestrictWeapons = false;
		bKeepUtilityItems = false;
		bPreventAttack = false;
	}
	
	if (g_bPlayerProxy[client])
	{
		bRestrictWeapons = true;
		bRemoveWeapons = true;
		bUseStock = true;
		bRemoveWearables = true;
		bKeepUtilityItems = false;
	}
	
	if (IsRoundInWarmup()) 
	{
		bRemoveWeapons = false;
		bRestrictWeapons = false;
		bKeepUtilityItems = false;
		bPreventAttack = false;
	}
	
	if (IsClientInGhostMode(client)) 
	{
		bRemoveWeapons = true;
	}
	
	if (SF_IsRaidMap() && !g_bPlayerEliminated[client])
	{
		bRemoveWeapons = false;
		bRestrictWeapons = false;
		bKeepUtilityItems = false;
		bPreventAttack = false;
	}
	
	if (SF_IsBoxingMap() && !g_bPlayerEliminated[client] && !IsRoundEnding())
	{
		bRestrictWeapons = false;
		bKeepUtilityItems = true;
		bPreventAttack = false;
	}

	if (bRemoveWeapons && !bKeepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if (i == TFWeaponSlot_Melee && !IsClientInGhostMode(client)) continue;
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
	
	if (bKeepUtilityItems)
	{
		for (int i = 0; i <= 5; i++)
		{
			if ((i == TFWeaponSlot_Melee || i == TFWeaponSlot_Secondary) && !IsClientInGhostMode(client)) continue;
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
		
		int iWeapon = INVALID_ENT_REFERENCE;
		iWeapon = GetPlayerWeaponSlot(client, TFWeaponSlot_Secondary);

		if (IsValidEdict(iWeapon))
		{
			int itemIndex = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
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
	
	if (bRemoveWearables)
		TF2_StripWearables(client);
	
	TFClassType iPlayerClass = TF2_GetPlayerClass(client);

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
	
	if (bRestrictWeapons)
	{
		int iHealth = GetEntProp(client, Prop_Send, "m_iHealth");
		
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
		
		if (g_hRestrictedWeaponsConfig != null)
		{
			int iWeapon = INVALID_ENT_REFERENCE;
			for (int iSlot = 0; iSlot <= 5; iSlot++)
			{
				Handle hItem = null;
				iWeapon = GetPlayerWeaponSlot(client, iSlot);
				
				if (IsValidEdict(iWeapon))
				{
					if (bUseStock || IsWeaponRestricted(iPlayerClass, GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex")))
					{
						TF2_RemoveWeaponSlotAndWearables(client, iSlot);
						switch (iSlot)
						{
							case TFWeaponSlot_Primary:
							{
								switch (iPlayerClass)
								{
									case TFClass_Scout: hItem = PrepareItemHandle("tf_weapon_scattergun", 13, 0, 0, "");
									case TFClass_Sniper: hItem = PrepareItemHandle("tf_weapon_sniperrifle", 14, 0, 0, "");
									case TFClass_Soldier: hItem = PrepareItemHandle("tf_weapon_rocketlauncher", 18, 0, 0, "");
									case TFClass_DemoMan: hItem = PrepareItemHandle("tf_weapon_grenadelauncher", 19, 0, 0, "");
									case TFClass_Heavy: hItem = PrepareItemHandle("tf_weapon_minigun", 15, 0, 0, "");
									case TFClass_Medic: hItem = PrepareItemHandle("tf_weapon_syringegun_medic", 17, 0, 0, "");
									case TFClass_Pyro: hItem = PrepareItemHandle("tf_weapon_flamethrower", 21, 0, 0, "254 ; 4.0");
									case TFClass_Spy: hItem = PrepareItemHandle("tf_weapon_revolver", 24, 0, 0, "");
									case TFClass_Engineer: hItem = PrepareItemHandle("tf_weapon_shotgun", 9, 0, 0, "");
								}
							}
							case TFWeaponSlot_Secondary:
							{
								switch (iPlayerClass)
								{
									case TFClass_Scout: hItem = PrepareItemHandle("tf_weapon_pistol", 23, 0, 0, "");
									case TFClass_Sniper: hItem = PrepareItemHandle("tf_weapon_smg", 16, 0, 0, "");
									case TFClass_Soldier: hItem = PrepareItemHandle("tf_weapon_shotgun", 10, 0, 0, "");
									case TFClass_DemoMan: hItem = PrepareItemHandle("tf_weapon_pipebomblauncher", 20, 0, 0, "");
									case TFClass_Heavy: hItem = PrepareItemHandle("tf_weapon_shotgun", 11, 0, 0, "");
									case TFClass_Medic: hItem = PrepareItemHandle("tf_weapon_medigun", 29, 0, 0, "");
									case TFClass_Pyro: hItem = PrepareItemHandle("tf_weapon_shotgun", 12, 0, 0, "");
									case TFClass_Engineer: hItem = PrepareItemHandle("tf_weapon_pistol", 22, 0, 0, "");
								}
							}
							case TFWeaponSlot_Melee:
							{
								switch (iPlayerClass)
								{
									case TFClass_Scout: hItem = PrepareItemHandle("tf_weapon_bat", 0, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Sniper: hItem = PrepareItemHandle("tf_weapon_club", 3, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Soldier: hItem = PrepareItemHandle("tf_weapon_shovel", 6, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_DemoMan: hItem = PrepareItemHandle("tf_weapon_bottle", 1, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Heavy: hItem = PrepareItemHandle("tf_weapon_fists", 5, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Medic: hItem = PrepareItemHandle("tf_weapon_bonesaw", 8, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Pyro: hItem = PrepareItemHandle("tf_weapon_fireaxe", 2, 0, 0, "", g_bPlayerProxy[client]);
									case TFClass_Spy: hItem = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "");
									case TFClass_Engineer: hItem = PrepareItemHandle("tf_weapon_wrench", 7, 0, 0, "", g_bPlayerProxy[client]);
								}
							}
							case 4:
							{
								switch (iPlayerClass)
								{
									case TFClass_Spy: hItem = PrepareItemHandle("tf_weapon_invis", 297, 0, 0, "");
								}
							}
						}
						
						if (hItem != null)
						{
							int iNewWeapon = TF2Items_GiveNamedItem(client, hItem);
							if (IsValidEntity(iNewWeapon)) 
							{
								EquipPlayerWeapon(client, iNewWeapon);
							}
						}
					}
					else
					{
						if (!g_bPlayerHasRegenerationItem[client])
							g_bPlayerHasRegenerationItem[client] = IsRegenWeapon(iWeapon);
					}
				}
				delete hItem;
				hItem = null;
			}
		}
		
		// Fixes the Pretty Boy's Pocket Pistol glitch.
		int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, client);
		if (iHealth > iMaxHealth)
		{
			SetEntProp(client, Prop_Data, "m_iHealth", iMaxHealth);
			SetEntProp(client, Prop_Send, "m_iHealth", iMaxHealth);
		}
	}
	
	// Change stats on some weapons.
	if (!g_bPlayerEliminated[client] || g_bPlayerProxy[client])
	{
		int iWeapon = INVALID_ENT_REFERENCE;
		Handle hWeapon = null;
		for (int iSlot = 0; iSlot <= 5; iSlot++)
		{
			iWeapon = GetPlayerWeaponSlot(client, iSlot);
			if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;
			
			int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
			switch (iItemDef)
			{
				case 214: // Powerjack
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fireaxe", 214, 0, 0, "180 ; 12.0 ; 412 ; 1.2");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 310: //The Warrior's Spirit
				{
					TF2_RemoveWeaponSlot(client, iSlot);

					hWeapon = PrepareItemHandle("tf_weapon_fists", 310, 0, 0, "2 ; 1.3 ; 412 ; 1.3");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 326: // The Back Scratcher
				{
					TF2_RemoveWeaponSlot(client, iSlot);

					hWeapon = PrepareItemHandle("tf_weapon_fireaxe", 326, 0, 0, "2 ; 1.25 ; 412 ; 1.25 ; 69 ; 0.25 ; 108 ; 1.25");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 304: // Amputator
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_bonesaw", 304, 0, 0, "200 ; 0.0 ; 57 ; 2 ; 1 ; 0.8");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 239: //GRU
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 239, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 1100: //Bread Bite
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 1100, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 426: //Eviction Notice
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 426, 0, 0, "6 ; 0.6 ; 107 ; 1.15 ; 737 ; 4.0 ; 1 ; 0.4 ; 412 ; 1.2");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 775: //The Escape Plan (Its like, real buggy on wearer)
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_shovel", 775, 0, 0, "414 ; 1 ; 734 ; 0.1");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 452: //Three Rune Blade
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_bat", 452, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 325: //Boston Basher
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_bat", 325, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 450: //Atomizer
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_bat", 450, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 225: //Your Eternal Reward
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_knife", 225, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 649: //Spy-cicle
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_knife", 649, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
				case 574: //Spy-cicle
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_knife", 574, 0, 0, "");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
			}
		}
		delete hWeapon;
	}
	
	if (bPreventAttack)
	{
		int iWeapon = INVALID_ENT_REFERENCE;
		while ((iWeapon = FindEntityByClassname(iWeapon, "tf_wearable_demoshield")) != INVALID_ENT_REFERENCE)
		{
			if (GetEntPropEnt(iWeapon, Prop_Send, "m_hOwnerEntity") == client)
			{
				RemoveEntity(iWeapon);
			}
		}

		for (int iSlot = 0; iSlot <= 5; iSlot++)
		{
			if (iSlot == TFWeaponSlot_Melee) continue;

			iWeapon = GetPlayerWeaponSlot(client, iSlot);
			if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;

			int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
			switch (iItemDef)
			{
				case 30, 212, 59, 60, 297, 947, 1101:	// Invis Watch, Base Jumper
				{
					TF2_RemoveWeaponSlotAndWearables(client, iSlot);
				}
				default:
				{
					SetEntPropFloat(iWeapon, Prop_Send, "m_flNextPrimaryAttack", 99999999.9);
					SetEntPropFloat(iWeapon, Prop_Send, "m_flNextSecondaryAttack", 99999999.9);
				}
			}
		}
	}

	//Remove the teleport ability
	if (IsClientInPvP(client) || ((SF_IsRaidMap() || SF_IsBoxingMap()) && !g_bPlayerEliminated[client])) //DidClientEscape(client)
	{
		int iWeapon = INVALID_ENT_REFERENCE;
		Handle hWeapon = null;
		for (int iSlot = 0; iSlot <= 5; iSlot++)
		{
			iWeapon = GetPlayerWeaponSlot(client, iSlot);
			if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;
			
			int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
			switch (iItemDef)
			{
				case 589: // Eureka Effect
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_wrench", 589, 0, 0, "93 ; 0.5 ; 732 ; 0.5");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					hWeapon = null;
					EquipPlayerWeapon(client, iEnt);
				}
			}
		}
		delete hWeapon;
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
	
	float flHealthFromPack = 1.0;
	if (!g_bPlayerEliminated[client] && !SF_IsBoxingMap())
	{
		if (g_bPlayerHasRegenerationItem[client])
			flHealthFromPack = 0.40;
		if (TF2_GetPlayerClass(client) == TFClass_Medic)
			flHealthFromPack = 0.0;
	}
	
	TF2Attrib_SetByDefIndex(client, 109, flHealthFromPack);

#if defined DEBUG
	int iWeapon = INVALID_ENT_REFERENCE;
	
	for (int i = 0; i <= 5; i++)
	{
		iWeapon = GetPlayerWeaponSlot(client, i);
		if (!IsValidEdict(iWeapon)) continue;
		
		iNewWeaponItemIndexes[i] = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
	}

	if (g_cvDebugDetail.IntValue > 0) 
	{
		for (int i = 0; i <= 5; i++)
		{
			DebugMessage("-> slot %d: %d (old: %d)", i, iNewWeaponItemIndexes[i], iOldWeaponItemIndexes[i]);
		}
	
		DebugMessage("END Timer_ClientPostWeapons(%d) -> remove = %d, restrict = %d", client, bRemoveWeapons, bRestrictWeapons);
	}
#endif
	return Plugin_Stop;
}

public Action TF2Items_OnGiveNamedItem(int client, char[] classname, int iItemDefinitionIndex, Handle &hItem)
{
	if(!g_bEnabled) return Plugin_Continue;
	
	/*if (iItemDefinitionIndex == 649)
	{
		RequestFrame(Frame_ReplaceSpyCicle, client);
		return Plugin_Handled;
	}*/
	switch (iItemDefinitionIndex)
	{
		case 642:
		{
			Handle hItemOverride = PrepareItemHandle("tf_wearable", 642, 0, 0, "376 ; 1.0 ; 377 ; 0.2 ; 57 ; 2 ; 412 ; 1.10");
			
			if (hItemOverride != null)
			{
				hItem = hItemOverride;

				return Plugin_Changed;
			}
			delete hItemOverride;
			hItemOverride = null;
		}
	}
	
	return Plugin_Continue;
}

public void Frame_ReplaceSpyCicle(int client)
{
	if (IsClientInGame(client))
	{
		TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
		Handle hItem = PrepareItemHandle("tf_weapon_knife", 4, 0, 0, "");
		int iNewKnife = TF2Items_GiveNamedItem(client, hItem);
		delete hItem;
		hItem = null;
		EquipPlayerWeapon(client, iNewKnife);
		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
	}
}

public void Frame_ClientHealArrow(int client)
{
	if (IsClientInGame(client) && IsClientInPvP(client))
	{
		int iEnt = -1;
		while ((iEnt = FindEntityByClassname(iEnt, "tf_projectile_healing_bolt")) != -1)
		{
			int iThrowerOffset = FindDataMapInfo(iEnt, "m_hThrower");
			int iOwnerEntity = GetEntPropEnt(iEnt, Prop_Data, "m_hOwnerEntity");
			if (iOwnerEntity != client && iThrowerOffset != -1) iOwnerEntity = GetEntDataEnt2(iEnt, iThrowerOffset);
			if (iOwnerEntity == client)
			{
				SetEntProp(iEnt, Prop_Data, "m_iInitialTeamNum", GetClientTeam(client));
				SetEntProp(iEnt, Prop_Send, "m_iTeamNum", GetClientTeam(client));
			}
		}
	}
}

bool IsRegenWeapon(int iWeapon)
{
	Address attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 1003);
	if (attribRegen != Address_Null) return true;
	attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 490);
	if (attribRegen != Address_Null) return true;
	attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 190);
	if (attribRegen != Address_Null) return true;
	attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 130);
	if (attribRegen != Address_Null) return true;
	attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 57);
	if (attribRegen != Address_Null) return true;
	attribRegen = TF2Attrib_GetByDefIndex(iWeapon, 220);
	if (attribRegen != Address_Null) return true;
	return false;
}

bool IsWeaponRestricted(TFClassType iClass,int iItemDef)
{
	if (g_hRestrictedWeaponsConfig == null) return false;
	
	bool bReturn = false;
	
	char sItemDef[32];
	FormatEx(sItemDef, sizeof(sItemDef), "%d", iItemDef);
	
	g_hRestrictedWeaponsConfig.Rewind();
	bool bProxyBoss = false;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
		if (!Npc.IsValid()) continue;
		if (Npc.Flags & SFF_PROXIES)
		{
			bProxyBoss = true;
			break;
		}
	}
	if (g_hRestrictedWeaponsConfig.JumpToKey("all"))
	{
		//bReturn = view_as<bool>(g_hRestrictedWeaponsConfig.GetNum(sItemDef));
		//view_as bool value turn to 2 into a true value.
		if(g_hRestrictedWeaponsConfig.GetNum(sItemDef)==1)
			bReturn=true;
		if(bProxyBoss && !bReturn)
		{
			int bProxyRestricted = g_hRestrictedWeaponsConfig.GetNum(sItemDef, 0);
			if(bProxyRestricted==2)
				bReturn=true;
		}
	}
	
	bool bFoundSection = false;
	g_hRestrictedWeaponsConfig.Rewind();
	
	switch (iClass)
	{
		case TFClass_Scout: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("scout");
		case TFClass_Soldier: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("soldier");
		case TFClass_Sniper: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("sniper");
		case TFClass_DemoMan: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("demoman");
		case TFClass_Heavy: 
		{
			bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("heavy");
		
			if (!bFoundSection)
			{
				g_hRestrictedWeaponsConfig.Rewind();
				bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("heavyweapons");
			}
		}
		case TFClass_Medic: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("medic");
		case TFClass_Spy: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("spy");
		case TFClass_Pyro: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("pyro");
		case TFClass_Engineer: bFoundSection = g_hRestrictedWeaponsConfig.JumpToKey("engineer");
	}
	
	if (bFoundSection)
	{
		//bReturn = view_as<bool>(g_hRestrictedWeaponsConfig.GetNum(sItemDef, bReturn));
		if(g_hRestrictedWeaponsConfig.GetNum(sItemDef)==1)
			bReturn=true;
		if(bProxyBoss && !bReturn)
		{
			int bProxyRestricted = g_hRestrictedWeaponsConfig.GetNum(sItemDef, 0);
			if(bProxyRestricted==2)
				bReturn=true;
		}
	}
	
	return bReturn;
}
