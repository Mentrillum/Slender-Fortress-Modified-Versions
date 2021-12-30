#if defined _sf2_pvp_included
 #endinput
#endif
#define _sf2_pvp_included


#define SF2_PVP_SPAWN_SOUND "items/pumpkin_drop.wav"
#define FLAME_HIT_DELAY 0.05

ConVar g_cvPvPArenaLeaveTime = null;
ConVar g_cvPvPArenaProjectileZap = null;

static const char g_sPvPProjectileClasses[][] = 
{
	"tf_projectile_rocket", 
	"tf_projectile_sentryrocket",
	"tf_projectile_stun_ball",
	"tf_projectile_ball_ornament",
	"tf_projectile_cleaver",
	"tf_projectile_energy_ball",
	"tf_projectile_flare",
	"tf_projectile_balloffire",
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
	"tf_projectile_flare"
};

static bool g_bPlayerInPvP[MAXPLAYERS + 1];
Handle g_hPlayerPvPTimer[MAXPLAYERS + 1];
Handle g_hPlayerPvPRespawnTimer[MAXPLAYERS + 1];
static int g_iPlayerPvPTimerCount[MAXPLAYERS + 1];
static bool g_bPlayerInPvPTrigger[MAXPLAYERS + 1];

//Blood
static int g_iPvPUserIdLastTrace;
static float g_flTimeLastTrace;

static ArrayList g_hPvPBallsOfFire;

enum struct PvPProjectile_BallOfFire
{
	int EntIndex;
	ArrayList TouchedEntities;

	void Init(int entIndex)
	{
		this.EntIndex = entIndex;
		this.TouchedEntities = new ArrayList();
	}

	void OnTouchPost(int otherEntity)
	{
		if (IsRoundEnding())
			return;

		int ent = this.EntIndex;
		int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
		if (!IsValidClient(ownerEntity) || otherEntity == ownerEntity || !IsClientInPvP(ownerEntity))
			return;
		
		if (IsValidEntity(otherEntity))
		{
			if ( this.TouchedEntities.FindValue(otherEntity) == -1 )
			{
				this.TouchedEntities.Push(otherEntity);

				if (IsValidClient(otherEntity) && IsClientInPvP(otherEntity) && GetEntProp(otherEntity, Prop_Send, "m_iTeamNum") == GetEntProp(ownerEntity, Prop_Send, "m_iTeamNum"))
				{
					float flDamage = GetEntDataFloat(ent, FindSendPropInfo("CTFProjectile_BallOfFire", "m_iDeflected") + 4);
					float flDamageBonus = TF2_IsPlayerInCondition(otherEntity, TFCond_OnFire) ? FindConVar("tf_fireball_burning_bonus").FloatValue : 1.0;
					float flDamagePos[3];
					GetEntPropVector(ent, Prop_Data, "m_vecOrigin", flDamagePos);
					// int iDamageCustom = 79;

					if (TF2_GetPlayerClass(otherEntity) == TFClass_Pyro)
					{
						TF2_AddCondition(otherEntity, TFCond_BurningPyro, FindConVar("tf_fireball_burn_duration").FloatValue * 0.5, ownerEntity);
					}

					TF2_IgnitePlayer(otherEntity, ownerEntity);
					SDKHooks_TakeDamage(otherEntity, ownerEntity, ownerEntity, flDamage * flDamageBonus, 0x1220000, GetEntPropEnt(ownerEntity, Prop_Send, "m_hActiveWeapon"), NULL_VECTOR, flDamagePos);
				}
			}
		}
	}

	void Cleanup()
	{
		delete this.TouchedEntities;
	}
}

public void PvP_Initialize()
{
	g_cvPvPArenaLeaveTime = CreateConVar("sf2_player_pvparena_leavetime", "5");
	g_cvPvPArenaProjectileZap = CreateConVar("sf2_pvp_projectile_removal", "0", "This is an experimental code! It could make your server crash, if you get any crash disable this cvar");
	
	g_hPvPBallsOfFire = new ArrayList(sizeof(PvPProjectile_BallOfFire));

	AddTempEntHook("TFBlood", TempEntHook_PvPBlood);
	AddTempEntHook("World Decal", TempEntHook_PvPDecal);
	AddTempEntHook("Entity Decal", TempEntHook_PvPDecal);
}

public void PvP_SetupMenus()
{
	g_hMenuSettingsPvP = CreateMenu(Menu_SettingsPvP);
	SetMenuTitle(g_hMenuSettingsPvP, "%t%t\n \n", "SF2 Prefix", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_hMenuSettingsPvP, "0", "Toggle automatic spawning");
	AddMenuItem(g_hMenuSettingsPvP, "1", "Toggle spawn protection");
	SetMenuExitBackButton(g_hMenuSettingsPvP, true);
}

public void PvP_OnMapStart()
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
				//StartTouch seems to be unreliable if a player is teleported/spawned in the trigger
				//SDKHook(iEnt, SDKHook_StartTouch, PvP_OnTriggerStartTouch);
				//But end touch works fine.
				SDKHook(iEnt, SDKHook_EndTouch, PvP_OnTriggerEndTouch);
			}
		}
	}
	iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "func_respawnroom")) != -1)
	{
		if(IsValidEntity(iEnt) && SF_IsBoxingMap())
		{
			SDKHook(iEnt, SDKHook_StartTouch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(iEnt, SDKHook_Touch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(iEnt, SDKHook_EndTouch, PvP_OnTriggerStartTouchBoxing);
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
	iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "func_respawnroom")) != -1)
	{
		if(IsValidEntity(iEnt) && SF_IsBoxingMap())
		{
			//Add physics object flag, so we can zap projectiles!
			int flags = GetEntProp(iEnt, Prop_Data, "m_spawnflags");
			flags |= TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS;
			//flags |= TRIGGER_PHYSICS_OBJECTS;
			flags |= TRIGGER_PHYSICS_DEBRIS;
			SetEntProp(iEnt, Prop_Data, "m_spawnflags", flags);
			SDKHook(iEnt, SDKHook_StartTouch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(iEnt, SDKHook_Touch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(iEnt, SDKHook_EndTouch, PvP_OnTriggerStartTouchBoxing);
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
		
		Handle hTrace = null;
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
				delete hTrace;
				
				if (IsValidEntity(iHitEntity))
				{
					PvP_OnFlameEntityStartTouchPost(ent, iHitEntity);
				}
			}
		}
		delete hTrace;
	}
}

public void PvP_OnEntityCreated(int ent, const char[] sClassname)
{
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x083EFF3EFF+ %i(%s)",ent,sClassname);
#endif
	for (int i = 0; i < sizeof(g_sPvPProjectileClasses); i++)
	{
		if (strcmp(sClassname, g_sPvPProjectileClasses[i], false) == 0)
		{
			SDKHook(ent, SDKHook_Spawn, Hook_PvPProjectileSpawn);
			SDKHook(ent, SDKHook_SpawnPost, Hook_PvPProjectileSpawnPost);
			break;
		}
	}

	for (int i = 0; i < sizeof(g_sPvPProjectileClassesNoTouch); i++)
	{
		if (strcmp(sClassname, g_sPvPProjectileClassesNoTouch[i], false) == 0)
		{
			SDKHook(ent, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
			break;
		}
	}
}
public void PvP_OnEntityDestroyed(int ent, const char[] sClassname)
{
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x08FF4040FF- %i(%s)",ent,sClassname);
#endif

	if (strcmp(sClassname, "tf_projectile_balloffire", false) == 0)
	{
		int index = g_hPvPBallsOfFire.FindValue( ent );
		if (index != -1) {
			PvPProjectile_BallOfFire projectileData;
			g_hPvPBallsOfFire.GetArray(index, projectileData, sizeof(projectileData));
			projectileData.Cleanup();
			g_hPvPBallsOfFire.Erase(index);
		}
	}
}

public Action Hook_PvPProjectile_OnTouch(int iProjectile, int iClient)
{
	// Check if the projectile hit a player outside of pvp area
	// Without that, cannon balls can bounce players which should not happen because they are outside of pvp.
	if (IsValidClient(iClient) && !IsClientInPvP(iClient))
	{
		RemoveEntity(iProjectile);
		return Plugin_Handled;
	}
	
	int iThrowerOffset = FindDataMapInfo(iProjectile, "m_hThrower");
	int iOwnerEntity = GetEntPropEnt(iProjectile, Prop_Data, "m_hOwnerEntity");
	if (iOwnerEntity != iClient && iThrowerOffset != -1) iOwnerEntity = GetEntDataEnt2(iProjectile, iThrowerOffset);
	
	if (iOwnerEntity == iClient)
	{
		RemoveEntity(iProjectile);
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
			if (strcmp(sClassname, g_sPvPProjectileClasses[i], false) == 0)
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
	return Plugin_Stop;
}

public void Hook_PvPProjectileSpawnPost(int ent)
{
	if (!IsValidEntity(ent)) return;
	
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
			static const char fixWeaponNotCollidingWithTeammates[][] = 
			{
				"tf_projectile_rocket",
				"tf_projectile_sentryrocket",
				"tf_projectile_flare"
			};

			for (int i = 0; i < sizeof(fixWeaponNotCollidingWithTeammates); i++)
			{
				if (IsValidEntity(ent) && strcmp(sClass, fixWeaponNotCollidingWithTeammates[i], false) == 0)
				{
					DHookEntity(g_hSDKProjectileCanCollideWithTeammates, false, ent, _, Hook_PvPProjectileCanCollideWithTeammates);
					break;
				}
			}

			if (strcmp(sClass, "tf_projectile_pipe", false) == 0 && GetEntProp(ent, Prop_Send, "m_iType") == 3)
			{
				/*
					Loose Cannon's projectiles
					KR: I'm assuming that stopping non-PvP players from getting bounced is the reason why this is implemented.
					Despite hooking onto Touch, the knockback still happens half of the time. StartTouch yields the same result
					so this is really the best that can be done.
				*/
				SDKHook(ent, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
			}
			else if (strcmp(sClass, "tf_projectile_balloffire", false) == 0)
			{
				/*
					Replicate projectile logic for Dragon's Fury projectiles.
					KR: The projectile checks the team of its owner entity (the player), not itself. CBaseEntity::InSameTeam()
					could be hooked to change this, but I think that would be too game-changing and not really worth doing for
					a single case, so the enemy player logic is sort of replicated.
				*/

				PvPProjectile_BallOfFire projectileData;
				projectileData.Init( ent );
				g_hPvPBallsOfFire.PushArray( projectileData, sizeof(projectileData) );

				SDKHook(ent, SDKHook_TouchPost, Hook_PvPProjectileBallOfFireTouchPost);
			}

			if(g_hPlayerPvPTimer[iOwnerEntity]==null)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
			else
			{
				//Client is not in pvp, remove the projectile
				if(g_cvPvPArenaProjectileZap.BoolValue)
					PvP_ZapProjectile(ent,false);
			}
		}
	}
}

public void Hook_PvPProjectileBallOfFireTouchPost(int projectile, int otherEntity)
{
	int index = g_hPvPBallsOfFire.FindValue( projectile );
	if (index != -1) {
		PvPProjectile_BallOfFire projectileData;
		g_hPvPBallsOfFire.GetArray(index, projectileData, sizeof(projectileData));
		projectileData.OnTouchPost(otherEntity);
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
				bool bAutoSpawn = g_iPlayerPreferences[iClient].PlayerPreference_PvPAutoSpawn;
				
				if (bAutoSpawn)
				{
					g_hPlayerPvPRespawnTimer[iClient] = CreateTimer(0.12, Timer_TeleportPlayerToPvP, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				g_hPlayerPvPRespawnTimer[iClient] = null;
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
		EmitSoundToAll(ZAP_SOUND, iProjectile, SNDCHAN_AUTO, SNDLEVEL_CAR);
		SetEntityRenderMode(iProjectile, RENDER_TRANSCOLOR);
		SetEntityRenderColor(iProjectile, 0, 0, 0, 1);
	}
	RemoveEntity(iProjectile);
}

public void PvP_OnPlayerDeath(int iClient, bool bFake)
{
	if (!bFake)
	{
		if (!IsClientInGhostMode(iClient) && !g_bPlayerProxy[iClient])
		{
			bool bAutoSpawn = g_iPlayerPreferences[iClient].PlayerPreference_PvPAutoSpawn;
			
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
	g_hPlayerPvPRespawnTimer[iClient] = null;
}

public void PvP_OnClientPutInPlay(int iClient)
{
	g_hPlayerPvPRespawnTimer[iClient] = null;
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
	
	if (StrContains(sName, "sf2_pvp_trigger", false) == 0 || SF2TriggerPvPEntity(trigger).IsValid())
	{
		if (IsValidClient(iOther) && IsPlayerAlive(iOther) && !IsClientInGhostMode(iOther))
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
				g_hPlayerPvPTimer[iOther] = null;
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
			g_iPlayerPvPTimerCount[iOther] = g_cvPvPArenaLeaveTime.IntValue;
			if (g_iPlayerPvPTimerCount[iOther] != 0) 
				g_hPlayerPvPTimer[iOther] = CreateTimer(1.0, Timer_PlayerPvPLeaveCountdown, GetClientUserId(iOther), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			else g_hPlayerPvPTimer[iOther] = CreateTimer(0.1, Timer_PlayerPvPLeaveCountdown, GetClientUserId(iOther), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
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
			if (strcmp(sClassname, g_sPvPProjectileClasses[i], false) == 0)
			{
				//Yup it's a projectile zap it!
				//But we have to wait to prevent some bugs.
				CreateTimer(0.1,EntityStillAlive,iOther,TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
}

public Action PvP_OnTriggerStartTouchBoxing(int trigger,int iOther)
{
	//A projectile went in the area. (Experimental)
	if (iOther>MaxClients && IsValidEntity(iOther) && !IsRoundInWarmup() && !IsRoundEnding())
	{
		//Get entity's classname.
		char sClassname[50];
		GetEntityClassname(iOther,sClassname,sizeof(sClassname));
		for (int i = 0; i < (sizeof(g_sPvPProjectileClasses)-4); i++)
		{
			if (strcmp(sClassname, g_sPvPProjectileClasses[i], false) == 0)
			{
				//Yup it's a projectile zap it!
				//But we have to wait to prevent some bugs.
				CreateTimer(0.1,EntityStillAlive,iOther,TIMER_FLAG_NO_MAPCHANGE);
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
	return Plugin_Stop;
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
	g_hPlayerPvPTimer[iClient] = null;
	g_hPlayerPvPRespawnTimer[iClient] = null;
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
		TF2_RemoveWeaponSlot(iClient, TFWeaponSlot_Primary);
		TF2_RemoveWeaponSlot(iClient, TFWeaponSlot_Secondary);
		TF2_RegeneratePlayer(iClient);
		SetEntProp(iClient, Prop_Data, "m_iHealth", iHealth);
		SetEntProp(iClient, Prop_Send, "m_iHealth", iHealth);
	}
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
	g_hPlayerPvPTimer[iClient] = null;
	g_iPlayerPvPTimerCount[iClient] = 0;
	g_hPlayerPvPRespawnTimer[iClient] = null;
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
			
			if (bMine) RemoveEntity(ent);
		}
	}
}

public Action Timer_TeleportPlayerToPvP(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return;
	
	if (g_bPlayerProxy[iClient]) return;
	
	if (timer != g_hPlayerPvPRespawnTimer[iClient]) return;
	g_hPlayerPvPRespawnTimer[iClient] = null;
	
	ArrayList hSpawnPointList = new ArrayList();
	ArrayList hClearSpawnPointList = new ArrayList();

	int ent = -1;

	{
		float flMyPos[3];
		float flMins[3], flMaxs[3];
		GetEntPropVector(iClient, Prop_Send, "m_vecMins", flMins);
		GetEntPropVector(iClient, Prop_Send, "m_vecMaxs", flMaxs);

		char sName[32];

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));

			if (!StrContains(sName, "sf2_pvp_spawnpoint", false))
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flMyPos);

				hSpawnPointList.Push(ent);
				if (!IsSpaceOccupiedPlayer(flMyPos, flMins, flMaxs, iClient))
					hClearSpawnPointList.Push(ent);
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "sf2_info_player_pvpspawn")) != -1)
		{
			SF2PlayerPvPSpawnEntity spawnPoint = SF2PlayerPvPSpawnEntity(ent);
			if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
				continue;

			GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flMyPos);

			hSpawnPointList.Push(ent);
			if (!IsSpaceOccupiedPlayer(flMyPos, flMins, flMaxs, iClient))
				hClearSpawnPointList.Push(ent);
		}
	}
	
	int iNum;
	if ((iNum = hClearSpawnPointList.Length) > 0)
	{
		ent = hClearSpawnPointList.Get(GetRandomInt(0, iNum - 1));
	}
	else if ((iNum = hSpawnPointList.Length) > 0)
	{
		ent = hSpawnPointList.Get(GetRandomInt(0, iNum - 1));
	}

	delete hSpawnPointList;
	delete hClearSpawnPointList;
	
	if (iNum > 0)
	{
		float flPos[3], flAng[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", flAng);
		TeleportEntity(iClient, flPos, flAng, view_as<float>({ 0.0, 0.0, 0.0 }));
		
		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, flPos, _, SNDLEVEL_NORMAL, _, 1.0);
		if (g_iPlayerPreferences[iClient].PlayerPreference_PvPSpawnProtection) TF2_AddCondition(iClient, TFCond_UberchargedCanteen, 1.5);

		SF2PlayerPvPSpawnEntity spawnPoint = SF2PlayerPvPSpawnEntity(ent);
		if (spawnPoint.IsValid())
		{
			spawnPoint.FireOutput("OnSpawn", iClient);
		}
	}
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
		TF2_RemoveCondition(iClient, TFCond_Taunting);
		ClientSwitchToWeaponSlot(iClient, TFWeaponSlot_Melee);
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

MRESReturn PvP_GetWeaponCustomDamageType(int weapon, int client, int &customDamageType)
{
	if (IsValidClient(client) && IsClientInPvP(client) && IsValidEntity(weapon) && IsValidEdict(weapon) && IsValidEntity(client))
	{
		static const char fixWeaponPenetrationClasses[][] = 
		{
			"tf_weapon_sniperrifle",
			"tf_weapon_sniperrifle_decap",
			"tf_weapon_sniperrifle_classic"
		};

		char sWeaponName[256];
		GetEntityClassname(weapon, sWeaponName, sizeof(sWeaponName));

		/*
		 * Fixes the sniper rifle not damaging teammates.
		 * 
		 * WHY? For every other hitscan weapon in the game, simply enforcing lag compensation in CTFPlayer::WantsLagCompensationOnEntity()
		 * works. However, when it comes to weapons that penetrate teammates, the bullet trace will not iterate through teammates. This is
		 * the case with all sniper rifles, and is the reason why damage is never normally dealt to teammates despite having friendly fire 
		 * on and lag compensation.
		 *
		 * In this case, the type of penetration is determined by CTFWeaponBase::GetCustomDamageType(). For Snipers, default value is 
		 * TF_DMG_CUSTOM_PENETRATE_MY_TEAM (11) (piss rifle is TF_DMG_CUSTOM_PENETRATE_NONBURNING_TEAMMATE (14)). This value specifies 
		 * penetration of the bullet through teammates without damaging them. The damage type is switched to 0, and for the Machina at 
		 * full charge, TF_DMG_CUSTOM_PENETRATE_ALL_PLAYERS (12).
		 *
		 */
		for (int i = 0; i < sizeof(fixWeaponPenetrationClasses); i++)
		{
			if (strcmp(sWeaponName, fixWeaponPenetrationClasses[i], false) == 0)
			{
				customDamageType = 12; // TF_DMG_CUSTOM_PENETRATE_ALL_PLAYERS
				int itemDefIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");

				if ((itemDefIndex == 526 || itemDefIndex == 30665) && GetEntPropFloat(weapon, Prop_Send, "m_flChargedDamage") >= 150.0 )  // The Machina, Shooting Star
					customDamageType = 12; // TF_DMG_CUSTOM_PENETRATE_ALL_PLAYERS
				else
					customDamageType = 0; // no penetration behavior.

				return MRES_Supercede;
			}
			else
			{
				return MRES_Ignored;
			}
		}
	}
	else
	{
		return MRES_Ignored;
	}

	return MRES_Ignored;
}

public MRESReturn Hook_PvPProjectileCanCollideWithTeammates(int projectile, Handle hReturn, Handle hParams)
{
	if (!IsValidEdict(projectile) || !IsValidEntity(projectile)) return MRES_Ignored;
	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
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