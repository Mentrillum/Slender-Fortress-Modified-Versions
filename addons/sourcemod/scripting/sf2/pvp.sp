#if defined _sf2_pvp_included
 #endinput
#endif
#define _sf2_pvp_included

#pragma semicolon 1

#define SF2_PVP_SPAWN_SOUND "items/pumpkin_drop.wav"
#define FLAME_HIT_DELAY 0.05

ConVar g_PvPArenaLeaveTimeConVar = null;
ConVar g_PvPArenaProjectileZapConVar = null;

static const char g_PvPProjectileClasses[][] =
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
static const char g_PvPProjectileClassesNoTouch[][] =
{
	"tf_projectile_flare"
};

static bool g_PlayerInPvP[MAXTF2PLAYERS];
static bool g_PlayerIsLeavingPvP[MAXTF2PLAYERS];
Handle g_PlayerPvPTimer[MAXTF2PLAYERS];
Handle g_PlayerPvPRespawnTimer[MAXTF2PLAYERS];
static int g_PlayerPvPTimerCount[MAXTF2PLAYERS];
static ArrayList g_PlayerEnteredPvPTriggers[MAXTF2PLAYERS] = { null, ... };

//Blood
static int g_PvPUserIdLastTrace;
static float g_TimeLastTrace;

static ArrayList g_PvPBallsOfFire;

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
		{
			return;
		}

		int ent = this.EntIndex;
		int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
		if (!IsValidClient(ownerEntity) || otherEntity == ownerEntity || !IsClientInPvP(ownerEntity))
		{
			return;
		}

		if (IsValidEntity(otherEntity))
		{
			if (this.TouchedEntities.FindValue(otherEntity) == -1)
			{
				this.TouchedEntities.Push(otherEntity);

				if (IsValidClient(otherEntity) && IsClientInPvP(otherEntity) && GetEntProp(otherEntity, Prop_Send, "m_iTeamNum") == GetEntProp(ownerEntity, Prop_Send, "m_iTeamNum"))
				{
					float damage = GetEntDataFloat(ent, FindSendPropInfo("CTFProjectile_BallOfFire", "m_iDeflected") + 4);
					float damageBonus = TF2_IsPlayerInCondition(otherEntity, TFCond_OnFire) ? g_DragonsFuryBurningBonus.FloatValue : 1.0;
					float damagePos[3];
					GetEntPropVector(ent, Prop_Data, "m_vecOrigin", damagePos);
					// int damageCustom = 79;

					if (TF2_GetPlayerClass(otherEntity) == TFClass_Pyro)
					{
						TF2_AddCondition(otherEntity, TFCond_BurningPyro, g_DragonsFuryBurnDuration.FloatValue * 0.5, ownerEntity);
					}

					TF2_IgnitePlayer(otherEntity, ownerEntity);
					SDKHooks_TakeDamage(otherEntity, ownerEntity, ownerEntity, damage * damageBonus, 0x1220000, GetEntPropEnt(ownerEntity, Prop_Send, "m_hActiveWeapon"), NULL_VECTOR, damagePos);
				}
			}
		}
	}

	void Cleanup()
	{
		delete this.TouchedEntities;
	}
}

void PvP_Initialize()
{
	g_PvPArenaLeaveTimeConVar = CreateConVar("sf2_player_pvparena_leavetime", "5");
	g_PvPArenaProjectileZapConVar = CreateConVar("sf2_pvp_projectile_removal", "0", "This is an experimental code! It could make your server crash, if you get any crash disable this cvar");

	g_PvPBallsOfFire = new ArrayList(sizeof(PvPProjectile_BallOfFire));

	AddTempEntHook("TFBlood", TempEntHook_PvPBlood);
	AddTempEntHook("World Decal", TempEntHook_PvPDecal);
	AddTempEntHook("Entity Decal", TempEntHook_PvPDecal);
}

void PvP_SetupMenus()
{
	g_MenuSettingsPvP = CreateMenu(Menu_SettingsPvP);
	SetMenuTitle(g_MenuSettingsPvP, "%t%t\n \n", "SF2 Prefix", "SF2 Settings PvP Menu Title");
	AddMenuItem(g_MenuSettingsPvP, "0", "Toggle automatic spawning");
	AddMenuItem(g_MenuSettingsPvP, "1", "Toggle spawn protection");
	SetMenuExitBackButton(g_MenuSettingsPvP, true);
}

void PvP_OnMapStart()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		if (IsValidEntity(ent))
		{
			char strName[50];
			GetEntPropString(ent, Prop_Data, "m_iName", strName, sizeof(strName));
			if (strcmp(strName, "sf2_pvp_trigger") == 0)
			{
				//StartTouch seems to be unreliable if a player is teleported/spawned in the trigger
				//SDKHook(ent, SDKHook_StartTouch, PvP_OnTriggerStartTouch);
				//But end touch works fine.
				SDKHook(ent, SDKHook_EndTouch, PvP_OnTriggerEndTouch);
			}
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_respawnroom")) != -1)
	{
		if (IsValidEntity(ent) && SF_IsBoxingMap())
		{
			SDKHook(ent, SDKHook_StartTouch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(ent, SDKHook_Touch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(ent, SDKHook_EndTouch, PvP_OnTriggerStartTouchBoxing);
		}
	}
}

void PvP_OnRoundStart()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_multiple")) != -1)
	{
		if (IsValidEntity(ent))
		{
			char strName[50];
			GetEntPropString(ent, Prop_Data, "m_iName", strName, sizeof(strName));
			if (strcmp(strName, "sf2_pvp_trigger") == 0)
			{
				//Add physics object flag, so we can zap projectiles!
				int flags = GetEntProp(ent, Prop_Data, "m_spawnflags");
				flags |= TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS;
				//flags |= TRIGGER_PHYSICS_OBJECTS;
				flags |= TRIGGER_PHYSICS_DEBRIS;
				SetEntProp(ent, Prop_Data, "m_spawnflags", flags);
				SDKHook( ent, SDKHook_EndTouch, PvP_OnTriggerEndTouch );
			}
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_respawnroom")) != -1)
	{
		if (IsValidEntity(ent) && SF_IsBoxingMap())
		{
			//Add physics object flag, so we can zap projectiles!
			int flags = GetEntProp(ent, Prop_Data, "m_spawnflags");
			flags |= TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS;
			//flags |= TRIGGER_PHYSICS_OBJECTS;
			flags |= TRIGGER_PHYSICS_DEBRIS;
			SetEntProp(ent, Prop_Data, "m_spawnflags", flags);
			SDKHook(ent, SDKHook_StartTouch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(ent, SDKHook_Touch, PvP_OnTriggerStartTouchBoxing);
			SDKHook(ent, SDKHook_EndTouch, PvP_OnTriggerStartTouchBoxing);
		}
	}
}

void PvP_Precache()
{
	PrecacheSound2(SF2_PVP_SPAWN_SOUND, true);
}

void PvP_OnClientPutInServer(int client)
{
	g_PlayerEnteredPvPTriggers[client] = new ArrayList();

	PvP_ForceResetPlayerPvPData(client);
}

void PvP_OnClientDisconnect(int client)
{
	PvP_SetPlayerPvPState(client, false, false, false);

	if (g_PlayerEnteredPvPTriggers[client] != null)
	{
		delete g_PlayerEnteredPvPTriggers[client];
		g_PlayerEnteredPvPTriggers[client] = null;
	}
}

void PvP_OnGameFrame()
{
	// Process through PvP projectiles.
	for (int i = 0; i < sizeof(g_PvPProjectileClasses); i++)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, g_PvPProjectileClasses[i])) != -1)
		{
			int throwerOffset = FindDataMapInfo(ent, "m_hThrower");
			bool changeProjectileTeam = false;

			int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
			if (IsValidClient(ownerEntity) && IsClientInPvP(ownerEntity) && GetClientTeam(ownerEntity) != TFTeam_Red)
			{
				changeProjectileTeam = true;
			}
			else if (throwerOffset != -1)
			{
				ownerEntity = GetEntDataEnt2(ent, throwerOffset);
				if (IsValidClient(ownerEntity) && IsClientInPvP(ownerEntity) && GetClientTeam(ownerEntity) != TFTeam_Red)
				{
					changeProjectileTeam = true;
				}
			}

			if (changeProjectileTeam)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
		}
	}

	// Process through PvP flame entities.
	{
		static float mins[3] = { -6.0, ... };
		static float maxs[3] = { 6.0, ... };

		float flOrigin[3];

		Handle trace = null;
		int ent = -1;
		int ownerEntity = INVALID_ENT_REFERENCE;
		int hitEntity = INVALID_ENT_REFERENCE;

		while ((ent = FindEntityByClassname(ent, "tf_flame_manager")) != -1)
		{
			ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");

			if (IsValidEdict(ownerEntity))
			{
				// tf_flame's initial owner SHOULD be the flamethrower that it originates from.
				// If not, then something's completely bogus.

				ownerEntity = GetEntPropEnt(ownerEntity, Prop_Data, "m_hOwnerEntity");
			}

			if (IsValidClient(ownerEntity) && (IsRoundInWarmup() || IsClientInPvP(ownerEntity)))
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flOrigin);

				trace = TR_TraceHullFilterEx(flOrigin, flOrigin, mins, maxs, MASK_PLAYERSOLID, TraceRayDontHitEntity, ownerEntity);
				hitEntity = TR_GetEntityIndex(trace);
				delete trace;

				if (IsValidEntity(hitEntity))
				{
					PvP_OnFlameEntityStartTouchPost(ent, hitEntity);
				}
			}
		}
		delete trace;
	}
}

void PvP_OnEntityCreated(int ent, const char[] classname)
{
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x083EFF3EFF+ %i(%s)",ent,classname);
	#endif
	for (int i = 0; i < sizeof(g_PvPProjectileClasses); i++)
	{
		if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
		{
			SDKHook(ent, SDKHook_Spawn, Hook_PvPProjectileSpawn);
			SDKHook(ent, SDKHook_SpawnPost, Hook_PvPProjectileSpawnPost);
			break;
		}
	}

	for (int i = 0; i < sizeof(g_PvPProjectileClassesNoTouch); i++)
	{
		if (strcmp(classname, g_PvPProjectileClassesNoTouch[i], false) == 0)
		{
			SDKHook(ent, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
			break;
		}
	}
}

void PvP_OnEntityDestroyed(int ent, const char[] classname)
{
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x08FF4040FF- %i(%s)",ent,classname);
	#endif

	if (strcmp(classname, "tf_projectile_balloffire", false) == 0)
	{
		int index = g_PvPBallsOfFire.FindValue( ent );
		if (index != -1)
		{
			PvPProjectile_BallOfFire projectileData;
			g_PvPBallsOfFire.GetArray(index, projectileData, sizeof(projectileData));
			projectileData.Cleanup();
			g_PvPBallsOfFire.Erase(index);
		}
	}
}

static Action Hook_PvPProjectile_OnTouch(int projectile, int client)
{
	// Check if the projectile hit a player outside of pvp area
	// Without that, cannon balls can bounce players which should not happen because they are outside of pvp.
	if (IsValidClient(client) && !IsClientInPvP(client))
	{
		RemoveEntity(projectile);
		return Plugin_Handled;
	}

	int throwerOffset = FindDataMapInfo(projectile, "m_hThrower");
	int ownerEntity = GetEntPropEnt(projectile, Prop_Data, "m_hOwnerEntity");
	if (ownerEntity != client && throwerOffset != -1)
	{
		ownerEntity = GetEntDataEnt2(projectile, throwerOffset);
	}

	if (ownerEntity == client)
	{
		RemoveEntity(projectile);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action Hook_PvPProjectileSpawn(int ent)
{
	char class[64];
	GetEntityClassname(ent, class, sizeof(class));

	int throwerOffset = FindDataMapInfo(ent, "m_hThrower");
	int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");

	if (ownerEntity == -1 && throwerOffset != -1)
	{
		ownerEntity = GetEntDataEnt2(ent, throwerOffset);
	}

	if (IsValidClient(ownerEntity))
	{
		if (IsClientInPvP(ownerEntity))
		{
			SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
			SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
		}
	}

	return Plugin_Continue;
}

static void Hook_PvPProjectileSpawnPost(int ent)
{
	if (!IsValidEntity(ent))
	{
		return;
	}

	char class[64];
	GetEntityClassname(ent, class, sizeof(class));

	int throwerOffset = FindDataMapInfo(ent, "m_hThrower");
	int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");

	if (ownerEntity == -1 && throwerOffset != -1)
	{
		ownerEntity = GetEntDataEnt2(ent, throwerOffset);
	}

	if (IsValidClient(ownerEntity))
	{
		if (IsClientInPvP(ownerEntity))
		{
			static const char fixWeaponNotCollidingWithTeammates[][] =
			{
				"tf_projectile_rocket",
				"tf_projectile_sentryrocket",
				"tf_projectile_flare"
			};

			for (int i = 0; i < sizeof(fixWeaponNotCollidingWithTeammates); i++)
			{
				if (IsValidEntity(ent) && strcmp(class, fixWeaponNotCollidingWithTeammates[i], false) == 0)
				{
					DHookEntity(g_DHookProjectileCanCollideWithTeammates, false, ent, _, Hook_PvPProjectileCanCollideWithTeammates);
					break;
				}
			}

			if (strcmp(class, "tf_projectile_pipe", false) == 0 && GetEntProp(ent, Prop_Send, "m_iType") == 3)
			{
				/*
					Loose Cannon's projectiles
					KR: I'm assuming that stopping non-PvP players from getting bounced is the reason why this is implemented.
					Despite hooking onto Touch, the knockback still happens half of the time. StartTouch yields the same result
					so this is really the best that can be done.
				*/
				SDKHook(ent, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
			}
			else if (strcmp(class, "tf_projectile_balloffire", false) == 0)
			{
				/*
					Replicate projectile logic for Dragon's Fury projectiles.
					KR: The projectile checks the team of its owner entity (the player), not itself. CBaseEntity::InSameTeam()
					could be hooked to change this, but I think that would be too game-changing and not really worth doing for
					a single case, so the enemy player logic is sort of replicated.
				*/

				PvPProjectile_BallOfFire projectileData;
				projectileData.Init(ent);
				g_PvPBallsOfFire.PushArray(projectileData, sizeof(projectileData));

				SDKHook(ent, SDKHook_TouchPost, Hook_PvPProjectileBallOfFireTouchPost);
			}

			if (g_PlayerPvPTimer[ownerEntity]==null)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
			else
			{
				//Client is not in pvp, remove the projectile
				if (g_PvPArenaProjectileZapConVar.BoolValue)
				{
					PvP_ZapProjectile(ent, false);
				}
			}
		}
	}
}

static void Hook_PvPProjectileBallOfFireTouchPost(int projectile, int otherEntity)
{
	int index = g_PvPBallsOfFire.FindValue(projectile);
	if (index != -1)
	{
		PvPProjectile_BallOfFire projectileData;
		g_PvPBallsOfFire.GetArray(index, projectileData, sizeof(projectileData));
		projectileData.OnTouchPost(otherEntity);
	}
}

void PvP_OnPlayerSpawn(int client)
{
	if (IsRoundInWarmup() || GameRules_GetProp("m_bInWaitingForPlayers"))
	{
		return;
	}

	PvP_SetPlayerPvPState(client, false, false, false);

	g_PlayerIsLeavingPvP[client] = false;

	if (IsPlayerAlive(client) && IsClientParticipating(client))
	{
		if (!IsClientInGhostMode(client) && !g_PlayerProxy[client])
		{
			if (g_PlayerEliminated[client] || DidClientEscape(client))
			{
				bool autoSpawn = g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn;

				if (autoSpawn)
				{
					g_PlayerPvPRespawnTimer[client] = CreateTimer(0.12, Timer_TeleportPlayerToPvP, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				g_PlayerPvPRespawnTimer[client] = null;
			}
		}
	}
}

void PvP_ZapProjectile(int projectile,bool bEffects=true)
{
	if (!IsValidEntity(projectile))
	{
		return;
	}

	//Add zap effects
	if (bEffects)
	{
		float pos[3];
		GetEntPropVector(projectile, Prop_Send, "m_vecOrigin", pos);
		//Spawn the particle.
		TE_Particle(g_Particles[ZapParticle], pos, pos);
		TE_SendToAll();
		//Play zap sound.
		EmitSoundToAll(ZAP_SOUND, projectile, SNDCHAN_AUTO, SNDLEVEL_CAR);
		SetEntityRenderMode(projectile, RENDER_TRANSCOLOR);
		SetEntityRenderColor(projectile, 0, 0, 0, 1);
	}
	RemoveEntity(projectile);
}

void PvP_OnPlayerDeath(int client, bool fake)
{
	if (!fake)
	{
		if (IsClientInPvP(client))
		{
			g_PlayerIsLeavingPvP[client] = false;
		}

		if (!IsClientInGhostMode(client) && !g_PlayerProxy[client])
		{
			bool autoSpawn = g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn;

			if (autoSpawn)
			{
				if (g_PlayerEliminated[client] || DidClientEscape(client))
				{
					if (!IsRoundEnding())
					{
						g_PlayerPvPRespawnTimer[client] = CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
}

void PvP_OnClientGhostModeEnable(int client)
{
	g_PlayerPvPRespawnTimer[client] = null;
}

static bool Hook_ClientPvPShouldCollide(int ent,int collisiongroup,int contentsmask, bool originalResult)
{
	if (!g_Enabled || g_PlayerProxy[ent] || !IsClientInPvP(ent) || !g_PlayerEliminated[ent])
	{
		SDKUnhook(ent, SDKHook_ShouldCollide, Hook_ClientPvPShouldCollide);
		if (collisiongroup == 8)
		{
			return false;
		}
		return originalResult;
	}
	if (IsClientInPvP(ent) && GetClientTeam(ent) == TFTeam_Blue && collisiongroup == 8)
	{
		return true;
	}
	return originalResult;
}

void PvP_OnTriggerStartTouch(int trigger,int other)
{
	char name[64];
	GetEntPropString(trigger, Prop_Data, "m_iName", name, sizeof(name));

	if (StrContains(name, "sf2_pvp_trigger", false) == 0 || SF2TriggerPvPEntity(trigger).IsValid())
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

			int entRef = EnsureEntRef(trigger);
			if (g_PlayerEnteredPvPTriggers[other].FindValue(entRef) == -1)
			{
				g_PlayerEnteredPvPTriggers[other].Push(entRef);
			}

			if (IsClientInPvP(other))
			{
				if (g_PlayerIsLeavingPvP[other])
				{
					// Player left and came back again, but is still in PvP mode.
					g_PlayerPvPTimerCount[other] = 0;
					g_PlayerPvPTimer[other] = null;
					g_PlayerIsLeavingPvP[other] = false;
				}
			}
			else
			{
				PvP_SetPlayerPvPState(other, true);
			}
		}
	}
}

void PvP_OnTriggerEndTouch(int trigger,int other)
{
	if (IsValidClient(other))
	{
		if (g_PlayerEnteredPvPTriggers[other] != null)
		{
			int triggerEntRef = EnsureEntRef(trigger);
			for (int i = g_PlayerEnteredPvPTriggers[other].Length - 1; i >= 0; i--)
			{
				int entRef = g_PlayerEnteredPvPTriggers[other].Get(i);
				if (entRef == triggerEntRef)
				{
					g_PlayerEnteredPvPTriggers[other].Erase(i);
				}
				else if (EntRefToEntIndex(entRef) == INVALID_ENT_REFERENCE)
				{
					g_PlayerEnteredPvPTriggers[other].Erase(i);
				}
			}
		}

		if (IsClientInPvP(other))
		{
			if (g_PlayerEnteredPvPTriggers[other].Length == 0)
			{
				g_PlayerPvPTimerCount[other] = g_PvPArenaLeaveTimeConVar.IntValue;
				if (g_PlayerPvPTimerCount[other] != 0)
				{
					g_PlayerPvPTimer[other] = CreateTimer(1.0, Timer_PlayerPvPLeaveCountdown, GetClientUserId(other), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					g_PlayerIsLeavingPvP[other] = true;
				}
				else
				{
					g_PlayerPvPTimer[other] = CreateTimer(0.1, Timer_PlayerPvPLeaveCountdown, GetClientUserId(other), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}

	//A projectile went off pvp area. (Experimental)
	if (other > MaxClients && IsValidEntity(other))
	{
		//Get entity's classname.
		char classname[50];
		GetEntityClassname(other,classname,sizeof(classname));
		for (int i = 0; i < (sizeof(g_PvPProjectileClasses)-4); i++)
		{
			if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
			{
				if (!GetEntProp(other, Prop_Send, "m_iDeflected"))
				{
					//Yup it's a projectile zap it!
					//But we have to wait to prevent some bugs.
					CreateTimer(0.1,EntityStillAlive,other,TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

static void PvP_OnTriggerStartTouchBoxing(int trigger,int other)
{
	//A projectile went in the area. (Experimental)
	if (other > MaxClients && IsValidEntity(other) && !IsRoundInWarmup() && !IsRoundEnding())
	{
		//Get entity's classname.
		char classname[50];
		GetEntityClassname(other,classname,sizeof(classname));
		for (int i = 0; i < (sizeof(g_PvPProjectileClasses)-4); i++)
		{
			if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
			{
				if (!GetEntProp(other, Prop_Send, "m_iDeflected"))
				{
					//Yup it's a projectile zap it!
					//But we have to wait to prevent some bugs.
					CreateTimer(0.1,EntityStillAlive,other,TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

static Action EntityStillAlive(Handle timer, int iRef)
{
	int ent = EntRefToEntIndex(iRef);
	if (ent > MaxClients)
	{
		PvP_ZapProjectile(ent);
	}
	return Plugin_Stop;
}
/**
 *	Enables/Disables PvP mode on the player.
 */
void PvP_SetPlayerPvPState(int client, bool status, bool removeProjectiles=true, bool regenerate=true)
{
	if (!IsValidClient(client))
	{
		return;
	}

	bool oldInPvP = g_PlayerInPvP[client];
	if (status == oldInPvP)
	{
		return; // no change
	}

	g_PlayerInPvP[client] = status;
	g_PlayerPvPTimer[client] = null;
	g_PlayerPvPRespawnTimer[client] = null;
	g_PlayerPvPTimerCount[client] = 0;

	if (removeProjectiles)
	{
		// Remove previous projectiles.
		PvP_RemovePlayerProjectiles(client);
	}

	if (regenerate)
	{
		// Regenerate player but keep health the same.
		int health = GetEntProp(client, Prop_Send, "m_iHealth");
		TF2_RemoveWeaponSlot(client, TFWeaponSlot_Primary);
		TF2_RemoveWeaponSlot(client, TFWeaponSlot_Secondary);
		TF2_RegeneratePlayer(client);
		SetEntProp(client, Prop_Data, "m_iHealth", health);
		SetEntProp(client, Prop_Send, "m_iHealth", health);
	}
}

static void PvP_OnFlameEntityStartTouchPost(int flame,int other) //Thanks Fire
{
	static float flasthit[MAXPLAYERS+1];

	if (IsValidClient(other))
	{
		float time = GetEngineTime();
		if (flasthit[other] < time)
		{
			flasthit[other] = time + FLAME_HIT_DELAY;

			if ((IsRoundInWarmup() || IsClientInPvP(other)) && !IsRoundEnding())
			{
				int iFlamethrower = GetEntPropEnt(flame, Prop_Data, "m_hOwnerEntity");
				if (IsValidEdict(iFlamethrower))
				{
					int ownerEntity = GetEntPropEnt(iFlamethrower, Prop_Data, "m_hOwnerEntity");
					if (ownerEntity != other && IsValidClient(ownerEntity))
					{
						if (IsRoundInWarmup() || IsClientInPvP(ownerEntity))
						{
							if (GetClientTeam(other) == GetClientTeam(ownerEntity) && GetClientTeam(ownerEntity) != TFTeam_Red)
							{
								//TF2_MakeBleed(other, ownerEntity, 4.0);
								TF2_IgnitePlayer(other, ownerEntity);
								SDKHooks_TakeDamage(other, ownerEntity, ownerEntity, 10.0, IsClientCritBoosted(ownerEntity) ? (DMG_BURN | DMG_PREVENT_PHYSICS_FORCE | DMG_ACID) : DMG_BURN | DMG_PREVENT_PHYSICS_FORCE);
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
void PvP_ForceResetPlayerPvPData(int client)
{
	g_PlayerInPvP[client] = false;
	g_PlayerPvPTimer[client] = null;
	g_PlayerPvPTimerCount[client] = 0;
	g_PlayerPvPRespawnTimer[client] = null;
	g_PlayerIsLeavingPvP[client] = false;

	if (g_PlayerEnteredPvPTriggers[client] != null)
	{
		g_PlayerEnteredPvPTriggers[client].Clear();
	}
}

static void PvP_RemovePlayerProjectiles(int client)
{
	for (int i = 0; i < sizeof(g_PvPProjectileClasses); i++)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, g_PvPProjectileClasses[i])) != -1)
		{
			int throwerOffset = FindDataMapInfo(ent, "m_hThrower");
			bool mine = false;

			int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
			if (ownerEntity == client)
			{
				mine = true;
			}
			else if (throwerOffset != -1)
			{
				ownerEntity = GetEntDataEnt2(ent, throwerOffset);
				if (ownerEntity == client)
				{
					mine = true;
				}
			}

			if (mine)
			{
				RemoveEntity(ent);
			}
		}
	}
}

static Action Timer_TeleportPlayerToPvP(Handle timer, any userid)
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

	if (timer != g_PlayerPvPRespawnTimer[client])
	{
		return Plugin_Stop;
	}
	g_PlayerPvPRespawnTimer[client] = null;

	ArrayList spawnPointList = new ArrayList();
	ArrayList clearSpawnPointList = new ArrayList();

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

			if (!StrContains(name, "sf2_pvp_spawnpoint", false))
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", myPos);

				spawnPointList.Push(ent);
				if (!IsSpaceOccupiedPlayer(myPos, mins, maxs, client))
				{
					clearSpawnPointList.Push(ent);
				}
			}
		}

		ent = -1;
		while ((ent = FindEntityByClassname(ent, "sf2_info_player_pvpspawn")) != -1)
		{
			SF2PlayerPvPSpawnEntity spawnPoint = SF2PlayerPvPSpawnEntity(ent);
			if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
			{
				continue;
			}

			GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", myPos);

			spawnPointList.Push(ent);
			if (!IsSpaceOccupiedPlayer(myPos, mins, maxs, client))
			{
				clearSpawnPointList.Push(ent);
			}
		}
	}

	int num;
	if ((num = clearSpawnPointList.Length) > 0)
	{
		ent = clearSpawnPointList.Get(GetRandomInt(0, num - 1));
	}
	else if ((num = spawnPointList.Length) > 0)
	{
		ent = spawnPointList.Get(GetRandomInt(0, num - 1));
	}

	delete spawnPointList;
	delete clearSpawnPointList;

	if (num > 0)
	{
		float pos[3], ang[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(client, pos, ang, view_as<float>({ 0.0, 0.0, 0.0 }));

		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, pos, _, SNDLEVEL_NORMAL, _, 1.0);
		if (g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection) TF2_AddCondition(client, TFCond_UberchargedCanteen, 1.5);

		SF2PlayerPvPSpawnEntity spawnPoint = SF2PlayerPvPSpawnEntity(ent);
		if (spawnPoint.IsValid())
		{
			spawnPoint.FireOutput("OnSpawn", client);
		}
	}
	return Plugin_Stop;
}

static Action Timer_PlayerPvPLeaveCountdown(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerPvPTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsClientInPvP(client))
	{
		return Plugin_Stop;
	}

	if (g_PlayerPvPTimerCount[client] <= 0)
	{
		PvP_SetPlayerPvPState(client, false);
		g_PlayerIsLeavingPvP[client] = false;

		// Force them to their melee weapon and stop taunting, to prevent tposing and what not.
		ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
		TF2_RemoveCondition(client, TFCond_Taunting);
		return Plugin_Stop;
	}

	g_PlayerPvPTimerCount[client]--;

	//if (!g_PlayerProxyAvailableInForce[client])
	{
		SetHudTextParams(-1.0, 0.75,
			1.0,
			255, 255, 255, 255,
			_,
			_,
			0.25, 1.25);

		ShowSyncHudText(client, g_HudSync, "%T", "SF2 Exiting PvP Arena", client, g_PlayerPvPTimerCount[client]);
	}

	return Plugin_Continue;
}
bool IsClientInPvP(int client)
{
	return g_PlayerInPvP[client];
}
////////////////
// Blood effects
////////////////

//Actually we are blocking the damages if the player is injured and not in pvp. So this hook is useless
static Action TempEntHook_PvPBlood(const char[] te_name, int[] players, int numPlayers, float delay)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int client = TE_ReadNum("entindex");
	if (IsValidClient(client) && g_PlayerEliminated[client] && !IsClientInPvP(client))
	{
		//Block effect
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

//Credits to STT creators for this decal trace
Action Hook_PvPPlayerTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(victim))
	{
		g_PvPUserIdLastTrace = GetClientUserId(victim);
		g_TimeLastTrace = GetEngineTime();
	}

	return Plugin_Continue;
}
static Action TempEntHook_PvPDecal(const char[] te_name, int[] players, int numPlayers, float delay)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	// Blocks the blood decals on the walls / nearby entities

	int client = GetClientOfUserId(g_PvPUserIdLastTrace);
	if (IsValidClient(client) && g_PlayerEliminated[client] && !IsClientInPvP(client))
	{
		if (g_TimeLastTrace != 0.0 && GetEngineTime() - g_TimeLastTrace < 0.1)
		{
			//PrintToChatAll("Blocked blood stain for %N (%f)", client, GetEngineTime() - g_TimeLastTrace);
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
				{
					customDamageType = 12; // TF_DMG_CUSTOM_PENETRATE_ALL_PLAYERS
				}
				else
				{
					customDamageType = 0; // no penetration behavior.
				}

				return MRES_Supercede;
			}
		}
	}

	return MRES_Ignored;
}

static MRESReturn Hook_PvPProjectileCanCollideWithTeammates(int projectile, DHookReturn returnHandle, DHookParam params)
{
	if (!IsValidEdict(projectile) || !IsValidEntity(projectile))
	{
		return MRES_Ignored;
	}

	returnHandle.Value = true;
	return MRES_Supercede;
}

// API

void PvP_InitializeAPI()
{
	CreateNative("SF2_IsClientInPvP", Native_IsClientInPvP);
}

static int Native_IsClientInPvP(Handle plugin,int numParams)
{
	return IsClientInPvP(GetNativeCell(1));
}