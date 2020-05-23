#if defined _sf2_pvp_included
 #endinput
#endif
#define _sf2_pvp_included


#define SF2_PVP_SPAWN_SOUND "items/pumpkin_drop.wav"
#define FLAME_HIT_DELAY 0.05

Handle g_cvPvPArenaLeaveTime;
Handle g_cvPvPArenaPlayerCollisions;
Handle g_cvPvPArenaProjectileZap;

Handle g_hCvarAvoidTeammates;

static const char g_sPvPProjectileClasses[][] = 
{
	"tf_projectile_rocket", 
	"tf_projectile_sentryrocket",
	"tf_projectile_stun_ball",
	"tf_projectile_ball_ornament",
	"tf_projectile_cleaver",
	"tf_projectile_energy_ball",
	"tf_projectile_flare",
	"tf_projectile_jar",
	"tf_projectile_jar_milk",
	"tf_projectile_pipe",
	"tf_projectile_pipe_remote",
	"tf_projectile_stun_ball",
	"tf_projectile_throwable_breadmonster",
	"tf_projectile_throwable_brick",
	"tf_projectile_throwable",
	//Don't change
	"tf_projectile_arrow",
	"tf_projectile_healing_bolt",
	"tf_projectile_energy_ring",
	"tf_projectile_syringe"
};
static const char g_sPvPProjectileClassesNoTouch[][] = 
{
	"tf_projectile_ball_ornament",
	"tf_projectile_flare"
};

static bool g_bPlayerInPvP[MAXPLAYERS + 1];
static Handle g_hPlayerPvPTimer[MAXPLAYERS + 1];
static Handle g_hPlayerPvPRespawnTimer[MAXPLAYERS + 1];
static int g_iPlayerPvPTimerCount[MAXPLAYERS + 1];
static bool g_bPlayerInPvPTrigger[MAXPLAYERS + 1];

static Handle g_hPvPFlameEntities;

//Blood
static int g_iPvPUserIdLastTrace;
static float g_flTimeLastTrace;

enum
{
	PvPFlameEntData_EntRef = 0,
	PvPFlameEntData_LastHitEntRef,
	PvPFlameEntData_MaxStats
};

public void PvP_Initialize()
{
	g_hCvarAvoidTeammates =	FindConVar("tf_avoidteammates");
	
	g_cvPvPArenaLeaveTime = CreateConVar("sf2_player_pvparena_leavetime", "6");
	g_cvPvPArenaPlayerCollisions = CreateConVar("sf2_player_pvparena_collisions", "1");
	g_cvPvPArenaProjectileZap = CreateConVar("sf2_pvp_projectile_removal", "0", "This is an experimental code! It could make your server crash, if you get any crash disable this cvar");
	
	AddTempEntHook("TFBlood", TempEntHook_PvPBlood);
	AddTempEntHook("World Decal", TempEntHook_PvPDecal);
	AddTempEntHook("Entity Decal", TempEntHook_PvPDecal);
	
	
	g_hPvPFlameEntities = CreateArray(PvPFlameEntData_MaxStats);
}

public void PvP_SetupMenus()
{
	g_hMenuSettingsPvP = CreateMenu(Menu_SettingsPvP);
	SetMenuTitle(g_hMenuSettingsPvP, "%t%t\n \n", "SF2 Prefix", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_hMenuSettingsPvP, "0", "Toggle automatic spawning");
	SetMenuExitBackButton(g_hMenuSettingsPvP, true);
}

public void PvP_OnMapStart()
{
	ClearArray(g_hPvPFlameEntities);
	int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_multiple")) != -1)
	{
		if(IsValidEntity(iEnt))
		{
			char strName[50];
			GetEntPropString(iEnt, Prop_Data, "m_iName", strName, sizeof(strName));
			if(strcmp(strName, "sf2_pvp_trigger") == 0)
			{
				//StartTouch seems to be unreliable if a player is teleported/spawned in the trigger
				//SDKHook( iEnt, SDKHook_StartTouch, PvP_OnTriggerStartTouch );
				//But end touch works fine.
				SDKHook( iEnt, SDKHook_EndTouch, PvP_OnTriggerEndTouch );
			}
		}
	}
}

public void PvP_OnRoundStart()
{
	int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_multiple")) != -1)
	{
		if(IsValidEntity(iEnt))
		{
			char strName[50];
			GetEntPropString(iEnt, Prop_Data, "m_iName", strName, sizeof(strName));
			if(strcmp(strName, "sf2_pvp_trigger") == 0)
			{
				//Add physics object flag, so we can zap projectiles!
				int flags = GetEntProp(iEnt, Prop_Data, "m_spawnflags");
				flags |= TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS;
				//flags |= TRIGGER_PHYSICS_OBJECTS;
				flags |= TRIGGER_PHYSICS_DEBRIS;
				SetEntProp(iEnt, Prop_Data, "m_spawnflags", flags);
				SDKHook( iEnt, SDKHook_EndTouch, PvP_OnTriggerEndTouch );
			}
		}
	}
}

public void PvP_Precache()
{
	PrecacheSound2(SF2_PVP_SPAWN_SOUND);
}

public void PvP_OnClientPutInServer(int iClient)
{
	PvP_ForceResetPlayerPvPData(iClient);
}

public void PvP_OnClientDisconnect(int iClient)
{
	PvP_SetPlayerPvPState(iClient, false, false, false);
}

public void PvP_OnGameFrame()
{
	// Process through PvP projectiles.
	for (int i = 0; i < sizeof(g_sPvPProjectileClasses); i++)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, g_sPvPProjectileClasses[i])) != -1)
		{
			int iThrowerOffset = FindDataMapInfo(ent, "m_hThrower");
			bool bChangeProjectileTeam = false;
			
			int iOwnerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
			if (IsValidClient(iOwnerEntity) && IsClientInPvP(iOwnerEntity) && GetClientTeam(iOwnerEntity) != TFTeam_Red)
			{
				bChangeProjectileTeam = true;
			}
			else if (iThrowerOffset != -1)
			{
				iOwnerEntity = GetEntDataEnt2(ent, iThrowerOffset);
				if (IsValidClient(iOwnerEntity) && IsClientInPvP(iOwnerEntity) && GetClientTeam(iOwnerEntity) != TFTeam_Red)
				{
					bChangeProjectileTeam = true;
				}
			}
			
			if (bChangeProjectileTeam)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
		}
	}

	// Process through PvP flame entities.
	{
		static float flMins[3] = { -6.0, ... };
		static float flMaxs[3] = { 6.0, ... };
		
		float flOrigin[3];
		
		Handle hTrace = INVALID_HANDLE;
		int ent = -1;
		int iOwnerEntity = INVALID_ENT_REFERENCE; 
		int iHitEntity = INVALID_ENT_REFERENCE;
		
		while ((ent = FindEntityByClassname(ent, "tf_flame_manager")) != -1)
		{
			iOwnerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
			
			if (IsValidEdict(iOwnerEntity))
			{
				// tf_flame's initial owner SHOULD be the flamethrower that it originates from.
				// If not, then something's completely bogus.
				
				iOwnerEntity = GetEntPropEnt(iOwnerEntity, Prop_Data, "m_hOwnerEntity");
			}
			
			if (IsValidClient(iOwnerEntity) && (IsRoundInWarmup() || IsClientInPvP(iOwnerEntity)))
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flOrigin);
				
				hTrace = TR_TraceHullFilterEx(flOrigin, flOrigin, flMins, flMaxs, MASK_PLAYERSOLID, TraceRayDontHitEntity, iOwnerEntity);
				iHitEntity = TR_GetEntityIndex(hTrace);
				CloseHandle(hTrace);
				
				if (IsValidEntity(iHitEntity))
				{
					PvP_OnFlameEntityStartTouchPost(ent, iHitEntity);
				}
			}
		}
	}
}

public void PvP_OnEntityCreated(int ent, const char[] sClassname)
{
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x083EFF3EFF+ %i(%s)",ent,sClassname);
#endif
	if (StrEqual(sClassname, "tf_flame", false))
	{
		int iIndex = PushArrayCell(g_hPvPFlameEntities, EntIndexToEntRef(ent));
		if (iIndex != -1)
		{
			SetArrayCell(g_hPvPFlameEntities, iIndex, INVALID_ENT_REFERENCE, PvPFlameEntData_LastHitEntRef);
		}
	}
	else
	{
		for (int i = 0; i < sizeof(g_sPvPProjectileClasses); i++)
		{
			if (StrEqual(sClassname, g_sPvPProjectileClasses[i], false))
			{
				SDKHook(ent, SDKHook_Spawn, Hook_PvPProjectileSpawn);
				SDKHook(ent, SDKHook_SpawnPost, Hook_PvPProjectileSpawnPost);
				break;
			}
			//g_sPvPProjectileClassesNoTouch's size should be always under or equal to the size of g_sPvPProjectileClasses
			if(i<sizeof(g_sPvPProjectileClassesNoTouch))
			{
				if (StrEqual(sClassname, g_sPvPProjectileClassesNoTouch[i], false))
				{
					SDKHook(ent, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
					break;
				}
			}
		}
	}
}
public void PvP_OnEntityDestroyed(int ent, const char[] sClassname)
{
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x08FF4040FF- %i(%s)",ent,sClassname);
#endif
	if (StrEqual(sClassname, "tf_flame", false))
	{
		int entref = EntIndexToEntRef(ent);
		int iIndex = FindValueInArray(g_hPvPFlameEntities, entref);
		if (iIndex != -1)
		{
			RemoveFromArray(g_hPvPFlameEntities, iIndex);
		}
	}
}
public Action Hook_PvPProjectile_OnTouch(int iProjectile, int iClient)
{
	// Check if the projectile hit a player outside of pvp area
	// Without that, cannon balls can bounce players which should not happen because they are outside of pvp.
	if (IsValidClient(iClient) && !IsClientInPvP(iClient))
	{
		AcceptEntityInput(iProjectile,"Kill");
		return Plugin_Handled;
	}
	
	int iThrowerOffset = FindDataMapInfo(iProjectile, "m_hThrower");
	int iOwnerEntity = GetEntPropEnt(iProjectile, Prop_Data, "m_hOwnerEntity");
	if (iOwnerEntity != iClient && iThrowerOffset != -1) iOwnerEntity = GetEntDataEnt2(iProjectile, iThrowerOffset);
	
	if (iOwnerEntity == iClient)
	{
		AcceptEntityInput(iProjectile,"Kill");
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action PvP_OnTriggerStartTouchEx(int trigger,int iOther)
{
	if (iOther>MaxClients && IsValidEntity(iOther))
	{
		//Get entity's classname.
		char sClassname[50];
		GetEntityClassname(iOther,sClassname,sizeof(sClassname));
		for (int i = 0; i < sizeof(g_sPvPProjectileClasses); i++)
		{
			if (StrEqual(sClassname, g_sPvPProjectileClasses[i], false))
			{
				SetEntProp(iOther, Prop_Data, "m_usSolidFlags", 0);
			}
		}
	}
}

public Action Hook_PvPProjectileSpawn(int ent)
{
	char sClass[64];
	GetEntityClassname(ent, sClass, sizeof(sClass));
	
	int iThrowerOffset = FindDataMapInfo(ent, "m_hThrower");
	int iOwnerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (iOwnerEntity == -1 && iThrowerOffset != -1)
	{
		iOwnerEntity = GetEntDataEnt2(ent, iThrowerOffset);
	}
	
	if (IsValidClient(iOwnerEntity))
	{
		if (IsClientInPvP(iOwnerEntity))
		{
			SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
			SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
		}
	}

	return Plugin_Continue;
}

public Action PvP_EntitySpawnPost(Handle timer,any ent)
{
	if(IsValidEntity(ent))
	{
		if(GetEntProp(ent, Prop_Data, "m_usSolidFlags")!=0)
			PvP_ZapProjectile(ent,false);
	}
}

public void Hook_PvPProjectileSpawnPost(int ent)
{
	char sClass[64];
	GetEntityClassname(ent, sClass, sizeof(sClass));
	
	int iThrowerOffset = FindDataMapInfo(ent, "m_hThrower");
	int iOwnerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (iOwnerEntity == -1 && iThrowerOffset != -1)
	{
		iOwnerEntity = GetEntDataEnt2(ent, iThrowerOffset);
	}
	
	if (IsValidClient(iOwnerEntity))
	{
		if (IsClientInPvP(iOwnerEntity))
		{
			if(g_hPlayerPvPTimer[iOwnerEntity]==INVALID_HANDLE)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
			else
			{
				//Client is not in pvp, remove the projectile
				if(GetConVarBool(g_cvPvPArenaProjectileZap))
					PvP_ZapProjectile(ent,false);
			}
		}
	}
}

public void PvP_OnPlayerSpawn(int iClient)
{
	if (IsRoundInWarmup() || GameRules_GetProp("m_bInWaitingForPlayers"))
		return;
	
	PvP_SetPlayerPvPState(iClient, false, false, false);

	if (IsPlayerAlive(iClient) && IsClientParticipating(iClient))
	{
		if (!IsClientInGhostMode(iClient) && !g_bPlayerProxy[iClient])
		{
			if (g_bPlayerEliminated[iClient] || g_bPlayerEscaped[iClient])
			{
				bool bAutoSpawn = g_iPlayerPreferences[iClient][PlayerPreference_PvPAutoSpawn];
				
				if (bAutoSpawn)
				{
					g_hPlayerPvPRespawnTimer[iClient] = CreateTimer(0.12, Timer_TeleportPlayerToPvP, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
			}
		}
	}
}

void PvP_ZapProjectile(int iProjectile,bool bEffects=true)
{
	if(!IsValidEntity(iProjectile))
		return;								 
	
	//Add zap effects
	if(bEffects)
	{
		float flPos[3];
		GetEntPropVector(iProjectile, Prop_Send, "m_vecOrigin", flPos);
		//Spawn the particle.
		TE_Particle(g_iParticle[ZapParticle], flPos, flPos);
		TE_SendToAll();
		//Play zap sound.
		EmitSoundToAll(ZAP_SOUND, iProjectile, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		SetEntityRenderMode(iProjectile, RENDER_TRANSCOLOR);
		SetEntityRenderColor(iProjectile, 0, 0, 0, 1);
	}
	AcceptEntityInput(iProjectile,"Kill");
}

public void PvP_OnPlayerDeath(int iClient, bool bFake)
{
	if (!bFake)
	{
		if (!IsClientInGhostMode(iClient) && !g_bPlayerProxy[iClient])
		{
			bool bAutoSpawn = g_iPlayerPreferences[iClient][PlayerPreference_PvPAutoSpawn];
			
			if (bAutoSpawn)
			{
				if (g_bPlayerEliminated[iClient] || g_bPlayerEscaped[iClient])
				{
					if (!IsRoundEnding())
					{
						g_hPlayerPvPRespawnTimer[iClient] = CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
}

public void PvP_OnClientGhostModeEnable(int iClient)
{
	g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
}

public void PvP_OnClientPutInPlay(int iClient)
{
	g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
}

public bool Hook_ClientPvPShouldCollide(int ent,int collisiongroup,int contentsmask, bool originalResult)
{
	if (!g_bEnabled || g_bPlayerProxy[ent] || !IsClientInPvP(ent) || !g_bPlayerEliminated[ent])
	{
		SDKUnhook(ent, SDKHook_ShouldCollide, Hook_ClientPvPShouldCollide);
		if (collisiongroup == 8)
			return false;
		return originalResult;
	}
	if (IsClientInPvP(ent) && GetClientTeam(ent) == TFTeam_Blue && collisiongroup == 8)
		return true;
	return originalResult;
}

public void PvP_OnTriggerStartTouch(int trigger,int iOther)
{
	char sName[64];
	GetEntPropString(trigger, Prop_Data, "m_iName", sName, sizeof(sName));
	
	if (StrContains(sName, "sf2_pvp_trigger", false) == 0)
	{
		if (IsValidClient(iOther) && IsPlayerAlive(iOther))
		{
			if (!g_bPlayerEliminated[iOther] && !DidClientEscape(iOther))
				return;
			//Use valve's kill code if the player is stuck.
			if(GetEntPropFloat(iOther, Prop_Send, "m_flModelScale") != 1.0)
				TF2_AddCondition(iOther, TFCond_HalloweenTiny, 0.1);
			//Resize the player.
			SetEntPropFloat(iOther, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(iOther, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(iOther, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(iOther, Prop_Send, "m_flHandScale", 1.0);
			
			g_bPlayerInPvPTrigger[iOther] = true;
			
			if (IsClientInPvP(iOther))
			{
				// Player left and came back again, but is still in PvP mode.
				g_iPlayerPvPTimerCount[iOther] = 0;
				g_hPlayerPvPTimer[iOther] = INVALID_HANDLE;
			}
			else
			{
				PvP_SetPlayerPvPState(iOther, true);
			}
		}
	}
}

public Action PvP_OnTriggerEndTouch(int trigger,int iOther)
{
	if (IsValidClient(iOther))
	{
		g_bPlayerInPvPTrigger[iOther] = false;
		
		if (IsClientInPvP(iOther))
		{
			g_iPlayerPvPTimerCount[iOther] = GetConVarInt(g_cvPvPArenaLeaveTime);
			g_hPlayerPvPTimer[iOther] = CreateTimer(1.0, Timer_PlayerPvPLeaveCountdown, GetClientUserId(iOther), TIMER_REPEAT);
		}
	}

	//A projectile went off pvp area. (Experimental)
	if (iOther>MaxClients && IsValidEntity(iOther))
	{
		//Get entity's classname.
		char sClassname[50];
		GetEntityClassname(iOther,sClassname,sizeof(sClassname));
		for (int i = 0; i < (sizeof(g_sPvPProjectileClasses)-4); i++)
		{
			if (StrEqual(sClassname, g_sPvPProjectileClasses[i], false))
			{
				//Yup it's a projectile zap it!
				//But we have to wait to prevent some bugs.
				CreateTimer(0.1,EntityStillAlive,iOther);
			}
		}
	}
}

public Action EntityStillAlive(Handle timer, int iRef)
{
	int iEnt = EntRefToEntIndex(iRef);
	if(iEnt > MaxClients)
	{
		PvP_ZapProjectile(iEnt);
	}
}
/**
 *	Enables/Disables PvP mode on the player.
 */
void PvP_SetPlayerPvPState(int iClient, bool bStatus, bool bRemoveProjectiles=true, bool bRegenerate=true)
{
	if (!IsValidClient(iClient)) return;
	
	bool bOldInPvP = g_bPlayerInPvP[iClient];
	if (bStatus == bOldInPvP) return; // no change
	
	g_bPlayerInPvP[iClient] = bStatus;
	g_hPlayerPvPTimer[iClient] = INVALID_HANDLE;
	g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
	g_iPlayerPvPTimerCount[iClient] = 0;
	
	if (bRemoveProjectiles)
	{
		// Remove previous projectiles.
		PvP_RemovePlayerProjectiles(iClient);
	}
	
	if (bRegenerate)
	{
		// Regenerate player but keep health the same.
		int iHealth = GetEntProp(iClient, Prop_Send, "m_iHealth");
		TF2_RegeneratePlayer(iClient);
		SetEntProp(iClient, Prop_Data, "m_iHealth", iHealth);
		SetEntProp(iClient, Prop_Send, "m_iHealth", iHealth);
	}
	
	/*if (bStatus && GetConVarBool(g_cvPvPArenaPlayerCollisions))
	{
		SDKHook(iClient, SDKHook_ShouldCollide, Hook_ClientPvPShouldCollide);
	}
	else
	{
		SDKUnhook(iClient, SDKHook_ShouldCollide, Hook_ClientPvPShouldCollide);
	}*/
}

static void PvP_OnFlameEntityStartTouchPost(int flame,int iOther) //Thanks Fire
{
	static float flasthit[MAXPLAYERS+1];

	if (IsValidClient(iOther))
	{
		float time = GetEngineTime();
		if(flasthit[iOther] < time)
		{
			flasthit[iOther] = time + FLAME_HIT_DELAY;
				
			if ((IsRoundInWarmup() || IsClientInPvP(iOther)) && !IsRoundEnding())
			{
				int iFlamethrower = GetEntPropEnt(flame, Prop_Data, "m_hOwnerEntity");
				if (IsValidEdict(iFlamethrower))
				{
					int iOwnerEntity = GetEntPropEnt(iFlamethrower, Prop_Data, "m_hOwnerEntity");
					if (iOwnerEntity != iOther && IsValidClient(iOwnerEntity))
					{
						if (IsRoundInWarmup() || IsClientInPvP(iOwnerEntity))
						{
							if (GetClientTeam(iOther) == GetClientTeam(iOwnerEntity) && GetClientTeam(iOwnerEntity) != TFTeam_Red)
							{
								//TF2_MakeBleed(iOther, iOwnerEntity, 4.0);
								TF2_IgnitePlayer(iOther, iOwnerEntity);
								SDKHooks_TakeDamage(iOther, iOwnerEntity, iOwnerEntity, 10.0, IsClientCritBoosted(iOwnerEntity) ? (DMG_BURN | DMG_PREVENT_PHYSICS_FORCE | DMG_ACID) : DMG_BURN | DMG_PREVENT_PHYSICS_FORCE); 
							}
						}
					}
				}
			}
		}
	}
}

/**
 *	Forcibly resets global vars of the player relating to PvP. Ignores checking.
 */
void PvP_ForceResetPlayerPvPData(int iClient)
{
	g_bPlayerInPvP[iClient] = false;
	g_hPlayerPvPTimer[iClient] = INVALID_HANDLE;
	g_iPlayerPvPTimerCount[iClient] = 0;
	g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
}

static void PvP_RemovePlayerProjectiles(int iClient)
{
	for (int i = 0; i < sizeof(g_sPvPProjectileClasses); i++)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, g_sPvPProjectileClasses[i])) != -1)
		{
			int iThrowerOffset = FindDataMapInfo(ent, "m_hThrower");
			bool bMine = false;
		
			int iOwnerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
			if (iOwnerEntity == iClient)
			{
				bMine = true;
			}
			else if (iThrowerOffset != -1)
			{
				iOwnerEntity = GetEntDataEnt2(ent, iThrowerOffset);
				if (iOwnerEntity == iClient)
				{
					bMine = true;
				}
			}
			
			if (bMine) AcceptEntityInput(ent, "Kill");
		}
	}
}

public Action Timer_TeleportPlayerToPvP(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return;
	
	if (g_bPlayerProxy[iClient]) return;
	
	if (timer != g_hPlayerPvPRespawnTimer[iClient]) return;
	g_hPlayerPvPRespawnTimer[iClient] = INVALID_HANDLE;
	
	Handle hSpawnPointList = CreateArray();
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		char sName[32];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (!StrContains(sName, "sf2_pvp_spawnpoint", false))
		{
			PushArrayCell(hSpawnPointList, ent);
		}
	}
	
	float flMins[3], flMaxs[3];
	GetEntPropVector(iClient, Prop_Send, "m_vecMins", flMins);
	GetEntPropVector(iClient, Prop_Send, "m_vecMaxs", flMaxs);
	
	Handle hClearSpawnPointList = CloneArray(hSpawnPointList);
	for (int i = 0; i < GetArraySize(hSpawnPointList); i++)
	{
		int iEnt = GetArrayCell(hSpawnPointList, i);
		
		float flMyPos[3];
		GetEntPropVector(iEnt, Prop_Data, "m_vecAbsOrigin", flMyPos);
		
		if (IsSpaceOccupiedPlayer(flMyPos, flMins, flMaxs, iClient))
		{
			int iIndex = FindValueInArray(hClearSpawnPointList, iEnt);
			if (iIndex != -1)
			{
				RemoveFromArray(hClearSpawnPointList, iIndex);
			}
		}
	}
	
	int iNum;
	if ((iNum = GetArraySize(hClearSpawnPointList)) > 0)
	{
		ent = GetArrayCell(hClearSpawnPointList, GetRandomInt(0, iNum - 1));
	}
	else if ((iNum = GetArraySize(hSpawnPointList)) > 0)
	{
		ent = GetArrayCell(hSpawnPointList, GetRandomInt(0, iNum - 1));
	}
	
	if (iNum > 0)
	{
		float flPos[3], flAng[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", flAng);
		TeleportEntity(iClient, flPos, flAng, view_as<float>({ 0.0, 0.0, 0.0 }));
		
		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, flPos, _, SNDLEVEL_NORMAL, _, 1.0);
		TF2_AddCondition(iClient, TFCond_UberchargedCanteen, 1.5);
	}
	
	CloseHandle(hSpawnPointList);
	CloseHandle(hClearSpawnPointList);
}

public Action Timer_PlayerPvPLeaveCountdown(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerPvPTimer[iClient]) return Plugin_Stop;
	
	if (!IsClientInPvP(iClient)) return Plugin_Stop;
	
	if (g_iPlayerPvPTimerCount[iClient] <= 0)
	{
		PvP_SetPlayerPvPState(iClient, false);
		return Plugin_Stop;
	}
	
	g_iPlayerPvPTimerCount[iClient]--;
	
	//if (!g_bPlayerProxyAvailableInForce[iClient])
	{
		SetHudTextParams(-1.0, 0.75, 
			1.0,
			255, 255, 255, 255,
			_,
			_,
			0.25, 1.25);
		
		ShowSyncHudText(iClient, g_hHudSync, "%T", "SF2 Exiting PvP Arena", iClient, g_iPlayerPvPTimerCount[iClient]);
	}
	
	return Plugin_Continue;
}
bool IsClientInPvP(int iClient)
{
	return g_bPlayerInPvP[iClient];
}
////////////////
// Blood effects
////////////////

//Actually we are blocking the damages if the player is injured and not in pvp. So this hook is useless
public Action TempEntHook_PvPBlood(const char[] te_name, int[] players, int numPlayers, float delay)
{
	if(!g_bEnabled) return Plugin_Continue;

	int iClient = TE_ReadNum("entindex");
	if(IsValidClient(iClient) && g_bPlayerEliminated[iClient] && !IsClientInPvP(iClient))
	{
		//Block effect
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

//Credits to STT creators for this decal trace
public Action Hook_PvPPlayerTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if(!g_bEnabled) return Plugin_Continue;
	
	if(IsValidClient(victim))
	{
		g_iPvPUserIdLastTrace = GetClientUserId(victim);
		g_flTimeLastTrace = GetEngineTime();
	}

	return Plugin_Continue;
}
public Action TempEntHook_PvPDecal(const char[] te_name, int[] players, int numPlayers, float delay)
{
	if(!g_bEnabled) return Plugin_Continue;

	// Blocks the blood decals on the walls / nearby entities

	int iClient = GetClientOfUserId(g_iPvPUserIdLastTrace);
	if(IsValidClient(iClient) && g_bPlayerEliminated[iClient] && !IsClientInPvP(iClient))
	{
		if(g_flTimeLastTrace != 0.0 && GetEngineTime() - g_flTimeLastTrace < 0.1)
		{
			//PrintToChatAll("Blocked blood stain for %N (%f)", iClient, GetEngineTime() - g_flTimeLastTrace);
			return Plugin_Stop;
		}
	}

	return Plugin_Continue;
}
// API

public void PvP_InitializeAPI()
{
	CreateNative("SF2_IsClientInPvP", Native_IsClientInPvP);
}

public int Native_IsClientInPvP(Handle plugin,int numParams)
{
	return view_as<bool>(IsClientInPvP(GetNativeCell(1)));
}