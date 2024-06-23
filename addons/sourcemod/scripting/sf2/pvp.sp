#if defined _sf2_pvp_included
 #endinput
#endif
#define _sf2_pvp_included

#pragma semicolon 1

#define SF2_PVP_SPAWN_SOUND "items/pumpkin_drop.wav"

static ConVar g_PvPArenaLeaveTimeConVar = null;
static ConVar g_PvPArenaProjectileZapConVar = null;

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
	"tf_projectile_jar_gas",
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

static const char g_PvPProjectileClassesNoHook[][] =
{
	"tf_projectile_pipe_remote",
	"tf_projectile_balloffire"
};

static int g_SpectatorItemIDs[] =
{
	TF_WEAPON_BUFF_ITEM,		// CTFPlayerShared::PulseRageBuff
	TF_WEAPON_FLAMETHROWER,		// CTFFlameThrower::SecondaryAttack
	TF_WEAPON_FLAME_BALL,		// CWeaponFlameBall::SecondaryAttack
	TF_WEAPON_SNIPERRIFLE,		// CTFPlayer::FireBullet
	TF_WEAPON_KNIFE,			// CTFKnife::BackstabVMThink
	TF_WEAPON_RAYGUN_REVENGE,	// CTFFlareGun_Revenge::ExtinguishPlayerInternal
};

static int g_EnemyItemIDs[] =
{
	TF_WEAPON_HANDGUN_SCOUT_PRIMARY,	// CTFPistol_ScoutPrimary::Push
	TF_WEAPON_GRAPPLINGHOOK,			// CTFGrapplingHook::ActivateRune
};

static bool g_PlayerInPvP[MAXTF2PLAYERS];
static bool g_PlayerIsLeavingPvP[MAXTF2PLAYERS];
Handle g_PlayerPvPTimer[MAXTF2PLAYERS];
Handle g_PlayerPvPRespawnTimer[MAXTF2PLAYERS];
static int g_PlayerPvPTimerCount[MAXTF2PLAYERS];
static ArrayList g_PlayerEnteredPvPTriggers[MAXTF2PLAYERS] = { null, ... };
static float g_PlayerMedigunDrainTime[MAXTF2PLAYERS];
static int g_PlayerOriginalTeam[MAXTF2PLAYERS];

static TFTeam g_PreHookTeam[2049];
static TFTeam g_PreHookDisguiseTeam[MAXTF2PLAYERS];

//Blood
static int g_PvPUserIdLastTrace;
static float g_TimeLastTrace;

static ArrayList g_PvPBallsOfFire;

static GlobalForward g_OnPlayerEnterPvP;
static GlobalForward g_OnPlayerExitPvP;

#define TICK_NEVER_THINK -1.0
static Handle g_SDKGetNextThink;
static Handle g_SDKGetGlobalTeam;
static Handle g_SDKChangeTeam;
static Handle g_SDKAddPlayer;
static Handle g_SDKRemovePlayer;
static Handle g_SDKAddObject;
static Handle g_SDKRemoveObject;
static Handle g_SDKGetPenetrationType;

static DynamicHook g_DHookCTFBaseRocketExplode;
static DynamicHook g_DHookCBaseGrenadeExplode;
static DynamicHook g_DHookVPhysicsUpdate;

static DynamicDetour g_DDetourPhysicsDispatchThink;
static DynamicDetour g_DDetourAllowedToHealTarget;

enum ThinkFunction
{
	ThinkFunction_None,
	ThinkFunction_DispenseThink,
	ThinkFunction_SentryThink,
	ThinkFunction_SapperThink,
}

static ThinkFunction g_ThinkFunction = ThinkFunction_None;

enum
{
	PostThinkType_None,
	PostThinkType_Spectator,
	PostThinkType_EnemyTeam,
}

static int g_PostThinkType;

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
		if (!IsValidClient(ownerEntity) || otherEntity == ownerEntity)
		{
			return;
		}

		if (!IsClientInPvP(ownerEntity))
		{
			return;
		}

		if (IsValidEntity(otherEntity))
		{
			if (this.TouchedEntities.FindValue(otherEntity) == -1)
			{
				this.TouchedEntities.Push(otherEntity);

				if (IsValidClient(otherEntity) && (IsClientInPvP(otherEntity)) && GetEntProp(otherEntity, Prop_Send, "m_iTeamNum") == GetEntProp(ownerEntity, Prop_Send, "m_iTeamNum"))
				{
					float damage = GetEntDataFloat(ent, FindSendPropInfo("CTFProjectile_BallOfFire", "m_iDeflected") + 4);
					float damageBonus = TF2_IsPlayerInCondition(otherEntity, TFCond_OnFire) ? g_DragonsFuryBurningBonusConVar.FloatValue : 1.0;
					float damagePos[3];
					GetEntPropVector(ent, Prop_Data, "m_vecOrigin", damagePos);
					// int damageCustom = 79;

					if (TF2_GetPlayerClass(otherEntity) == TFClass_Pyro)
					{
						TF2_AddCondition(otherEntity, TFCond_BurningPyro, g_DragonsFuryBurnDurationConVar.FloatValue * 0.5, ownerEntity);
					}

					TF2_IgnitePlayer(otherEntity, ownerEntity);
					SDKHooks_TakeDamage(otherEntity, ownerEntity, ownerEntity, damage * damageBonus, 0x1220000, GetEntPropEnt(ownerEntity, Prop_Send, "m_hActiveWeapon"), NULL_VECTOR, damagePos);
					CBaseEntity primary = CBaseEntity(GetPlayerWeaponSlot(ownerEntity, TFWeaponSlot_Primary));
					if (primary.IsValid())
					{
						primary.SetPropFloat(Prop_Send, "m_flRechargeScale", 1.5);
					}
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

	g_OnMapStartPFwd.AddFunction(null, MapStart);
	g_OnGameFramePFwd.AddFunction(null, GameFrame);
	g_OnRoundStartPFwd.AddFunction(null, RoundStart);
	g_OnEntityCreatedPFwd.AddFunction(null, EntityCreated);
	g_OnEntityDestroyedPFwd.AddFunction(null, EntityDestroyed);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPrePFwd.AddFunction(null, OnPlayerDeathPre);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);

	GameData gameData = new GameData("sf2");

	g_DHookCTFBaseRocketExplode = DynamicHook.FromConf(gameData, "CTFBaseRocket::Explode");
	if (g_DHookCTFBaseRocketExplode == null)
	{
		SetFailState("Failed to create hook CTFBaseRocket::Explode from gamedata!");
	}

	g_DHookCBaseGrenadeExplode = DynamicHook.FromConf(gameData, "CBaseGrenade::Explode");
	if (g_DHookCBaseGrenadeExplode == null)
	{
		SetFailState("Failed to create hook CTFBaseRocket::Explode from gamedata!");
	}

	g_DHookVPhysicsUpdate = DynamicHook.FromConf(gameData, "CBaseEntity::VPhysicsUpdate");
	if (g_DHookVPhysicsUpdate == null)
	{
		SetFailState("Failed to create hook CBaseEntity::VPhysicsUpdate from gamedata!");
	}

	g_DDetourPhysicsDispatchThink = DynamicDetour.FromConf(gameData, "CBaseEntity::PhysicsDispatchThink");
	if (g_DDetourPhysicsDispatchThink == null)
	{
		SetFailState("Failed to create hook CBaseEntity::PhysicsDispatchThink from gamedata!");
	}

	g_DDetourPhysicsDispatchThink.Enable(Hook_Pre, PhysicsDispatchThinkPre);
	g_DDetourPhysicsDispatchThink.Enable(Hook_Post, PhysicsDispatchThinkPost);

	g_DDetourAllowedToHealTarget = DynamicDetour.FromConf(gameData, "CWeaponMedigun::AllowedToHealTarget");
	if (g_DDetourAllowedToHealTarget == null)
	{
		SetFailState("Failed to create hook CWeaponMedigun::AllowedToHealTarget from gamedata!");
	}

	g_DDetourAllowedToHealTarget.Enable(Hook_Pre, AllowedToHealTargetPre);

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CBaseEntity::GetNextThink");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer, VDECODE_FLAG_ALLOWNULL);
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_Plain);
	g_SDKGetNextThink = EndPrepSDKCall();
	if (g_SDKGetNextThink == null)
	{
		SetFailState("Failed to retrieve CBaseEntity::GetNextThink offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "GetGlobalTeam");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_SDKGetGlobalTeam = EndPrepSDKCall();
	if (g_SDKGetGlobalTeam == null)
	{
		SetFailState("Failed to retrieve GetGlobalTeam offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CBaseEntity::ChangeTeam");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_SDKChangeTeam = EndPrepSDKCall();
	if (g_SDKChangeTeam == null)
	{
		SetFailState("Failed to retrieve CBaseEntity::ChangeTeam offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CTeam::AddPlayer");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	g_SDKAddPlayer = EndPrepSDKCall();
	if (g_SDKAddPlayer == null)
	{
		SetFailState("Failed to retrieve CTeam::AddPlayer offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CTeam::RemovePlayer");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	g_SDKRemovePlayer = EndPrepSDKCall();
	if (g_SDKRemovePlayer == null)
	{
		SetFailState("Failed to retrieve CTeam::RemovePlayer offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CTFTeam::AddObject");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_SDKAddObject = EndPrepSDKCall();
	if (g_SDKAddObject == null)
	{
		SetFailState("Failed to retrieve CTFTeam::AddObject offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CTFTeam::RemoveObject");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_SDKRemoveObject = EndPrepSDKCall();
	if (g_SDKRemoveObject == null)
	{
		SetFailState("Failed to retrieve CTFTeam::RemoveObject offset from gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CTFSniperRifle::GetPenetrateType");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	g_SDKGetPenetrationType = EndPrepSDKCall();
	if (g_SDKGetPenetrationType == null)
	{
		SetFailState("Failed to retrieve CTFSniperRifle::GetPenetrateType offset from gamedata!");
	}

	delete gameData;

	AddTempEntHook("TFBlood", TempEntHook_PvPBlood);
	AddTempEntHook("World Decal", TempEntHook_PvPDecal);
	AddTempEntHook("Entity Decal", TempEntHook_PvPDecal);

	HookEvent("fish_notice", OnPlayerDeathEventPre, EventHookMode_Pre);
	HookEvent("fish_notice__arm", OnPlayerDeathEventPre, EventHookMode_Pre);
	HookEvent("slap_notice", OnPlayerDeathEventPre, EventHookMode_Pre);
	HookEvent("player_death", OnPlayerDeathEventPre, EventHookMode_Pre);
}

void PvP_SetupMenus()
{
	g_MenuSettingsPvP = new Menu(Menu_SettingsPvP);
	g_MenuSettingsPvP.SetTitle("%t%t\n \n", "SF2 Prefix", "SF2 Settings PvP Menu Title");
	g_MenuSettingsPvP.AddItem("0", "Toggle automatic spawning");
	g_MenuSettingsPvP.AddItem("1", "Toggle spawn protection");
	g_MenuSettingsPvP.ExitBackButton = true;
}

static void MapStart()
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

static void RoundStart()
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
				SDKHook(ent, SDKHook_EndTouch, PvP_OnTriggerEndTouch);
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

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	g_PlayerEnteredPvPTriggers[client.index] = new ArrayList();

	if (!client.IsSourceTV)
	{
		SDKHook(client.index, SDKHook_PreThink, ClientPreThink);
		SDKHook(client.index, SDKHook_PreThinkPost, ClientPreThinkPost);
		SDKHook(client.index, SDKHook_PostThink, ClientPostThink);
		SDKHook(client.index, SDKHook_PostThinkPost, ClientPostThinkPost);
	}

	PvP_ForceResetPlayerPvPData(client.index);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	PvP_SetPlayerPvPState(client.index, false, false, false);

	if (g_PlayerEnteredPvPTriggers[client.index] != null)
	{
		delete g_PlayerEnteredPvPTriggers[client.index];
		g_PlayerEnteredPvPTriggers[client.index] = null;
	}
}

static void GameFrame()
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

			for (int i2 = 0; i2 < sizeof(g_PvPProjectileClassesNoHook); i2++)
			{
				if (strcmp(g_PvPProjectileClasses[i], g_PvPProjectileClassesNoHook[i2], false) == 0)
				{
					changeProjectileTeam = false;
				}
			}

			if (changeProjectileTeam)
			{
				SetEntProp(ent, Prop_Data, "m_iInitialTeamNum", 0);
				SetEntProp(ent, Prop_Send, "m_iTeamNum", 0);
			}
		}
	}
}

static void EntityCreated(CBaseEntity ent, const char[] classname)
{
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x083EFF3EFF+ %i(%s)", ent.index, classname);
	#endif
	for (int i = 0; i < sizeof(g_PvPProjectileClasses); i++)
	{
		if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
		{
			SDKHook(ent.index, SDKHook_SpawnPost, Hook_PvPProjectileSpawnPost);
			break;
		}
	}

	for (int i = 0; i < sizeof(g_PvPProjectileClassesNoTouch); i++)
	{
		if (strcmp(classname, g_PvPProjectileClassesNoTouch[i], false) == 0)
		{
			SDKHook(ent.index, SDKHook_Touch, Hook_PvPProjectile_OnTouch);
			break;
		}
	}

	if (strcmp(classname, "tf_flame_manager", false) == 0)
	{
		SDKHook(ent.index, SDKHook_Touch, FlameStartTouch);
		SDKHook(ent.index, SDKHook_TouchPost, FlameStartTouchPost);
	}
	else if (strcmp(classname, "tf_gas_manager", false) == 0)
	{
		SDKHook(ent.index, SDKHook_Touch, GasStartTouch);
	}

	if (strncmp(classname, "tf_projectile_", 14) == 0)
	{
		g_DHookProjectileCanCollideWithTeammates.HookEntity(Hook_Post, ent.index, Hook_PvPProjectileCanCollideWithTeammates);

		if (strcmp(classname, "tf_projectile_pipe_remote") == 0)
		{
			SDKHook(ent.index, SDKHook_OnTakeDamage, PipeOnTakeDamage);
			SDKHook(ent.index, SDKHook_OnTakeDamagePost, PipeOnTakeDamagePost);
		}
		else if (strcmp(classname, "tf_projectile_flare") == 0)
		{
			g_DHookCTFBaseRocketExplode.HookEntity(Hook_Pre, ent.index, FlareExplodePre);
			g_DHookCTFBaseRocketExplode.HookEntity(Hook_Post, ent.index, FlareExplodePost);
		}
		else if (strncmp(classname, "tf_projectile_jar", 17) == 0)
		{
			g_DHookCBaseGrenadeExplode.HookEntity(Hook_Pre, ent.index, JarExplodePre);
			g_DHookCBaseGrenadeExplode.HookEntity(Hook_Post, ent.index, JarExplodePost);
		}
		else if (strncmp(classname, "tf_projectile_pipe", 18) == 0)
		{
			g_DHookVPhysicsUpdate.HookEntity(Hook_Pre, ent.index, VPhysicsUpdatePre);
			g_DHookVPhysicsUpdate.HookEntity(Hook_Post, ent.index, VPhysicsUpdatePost);
		}
		else if (strcmp(classname, "tf_projectile_cleaver") == 0)
		{
			SDKHook(ent.index, SDKHook_Touch, CleaverTouch);
			SDKHook(ent.index, SDKHook_TouchPost, CleaverTouchPost);
		}
		else if (strcmp(classname, "tf_projectile_pipe") == 0)
		{
			SDKHook(ent.index, SDKHook_Touch, GrenadeTouch);
			SDKHook(ent.index, SDKHook_TouchPost, GrenadeTouchPost);
		}
	}
	else if (IsEntityWeapon(ent.index))
	{
		int id = GetWeaponID(ent.index);
		if (id == TF_WEAPON_SNIPERRIFLE || id == TF_WEAPON_SNIPERRIFLE_DECAP || id == TF_WEAPON_SNIPERRIFLE_CLASSIC)
		{
			// Fixes Sniper Rifles dealing no damage to teammates
			g_DHookWeaponGetCustomDamageType.HookEntity(Hook_Post, ent.index, GetCustomDamageTypePost);
		}
	}
}

static void EntityDestroyed(CBaseEntity ent, const char[] classname)
{
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ENTITIES,0,"\x08FF4040FF- %i(%s)", ent.index, classname);
	#endif

	if (strcmp(classname, "tf_projectile_balloffire", false) == 0)
	{
		int index = g_PvPBallsOfFire.FindValue(ent.index);
		if (index != -1)
		{
			PvPProjectile_BallOfFire projectileData;
			g_PvPBallsOfFire.GetArray(index, projectileData, sizeof(projectileData));
			projectileData.Cleanup();
			g_PvPBallsOfFire.Erase(index);
		}
	}
}

static float GetNextThink(int entity, const char[] context = "")
{
	if (g_SDKGetNextThink != null)
	{
		return SDKCall(g_SDKGetNextThink, entity, context);
	}

	return TICK_NEVER_THINK;
}

static Address SDKCall_GetGlobalTeam(TFTeam team)
{
	if (g_SDKGetGlobalTeam)
	{
		return SDKCall(g_SDKGetGlobalTeam, team);
	}

	return Address_Null;
}

static void CBaseEntity_ChangeTeam(int entity, TFTeam team)
{
	SDKCall(g_SDKChangeTeam, entity, team);
}

static void CTeam_AddPlayer(Address team, int client)
{
	SDKCall(g_SDKAddPlayer, team, client);
}

static void CTeam_RemovePlayer(Address team, int client)
{
	SDKCall(g_SDKRemovePlayer, team, client);
}

static void CTeam_AddObject(Address team, int obj)
{
	SDKCall(g_SDKAddObject, team, obj);
}

static void CTeam_RemoveObject(Address team, int obj)
{
	SDKCall(g_SDKRemoveObject, team, obj);
}

static void ClientPreThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsInPvP)
	{
		return;
	}

	if (player.Team == TFTeam_Red)
	{
		return;
	}

	float gameTime = GetGameTime();
	CBaseEntity secondary = CBaseEntity(GetPlayerWeaponSlot(player.index, TFWeaponSlot_Secondary));
	if (secondary.IsValid() && GetWeaponID(secondary.index) == TF_WEAPON_MEDIGUN && g_PlayerMedigunDrainTime[player.index] <= gameTime)
	{
		SF2_BasePlayer healTarget = SF2_BasePlayer(secondary.GetPropEnt(Prop_Send, "m_hHealingTarget"));
		if (healTarget.IsValid && healTarget.IsAlive && (healTarget.IsInPvP))
		{
			float damage = 6.0;
			if (secondary.GetProp(Prop_Send, "m_iItemDefinitionIndex") == 411) // Quick-Fix
			{
				damage *= 1.4;
			}
			if (player.InCondition(TFCond_MegaHeal))
			{
				damage *= 3.0;
			}

			int damageType = DMG_ENERGYBEAM;
			if (player.IsCritBoosted())
			{
				damageType |= DMG_CRIT;
			}
			SDKHooks_TakeDamage(healTarget.index, player.index, player.index, damage, damageType, .bypassHooks = false);
			g_PlayerMedigunDrainTime[player.index] = gameTime + 0.1;
		}
	}

	player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
}

static void ClientPreThinkPost(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsInPvP)
	{
		return;
	}

	if (player.Team != TFTeam_Spectator)
	{
		return;
	}

	player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
}

static void ClientPostThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsInPvP)
	{
		return;
	}

	if (player.Team == TFTeam_Red)
	{
		return;
	}

	// CTFPlayer::DoTauntAttack
	if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
	{
		g_PostThinkType |= PostThinkType_Spectator;

		// Allows taunt kill work on both teams
		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
		return;
	}

	int activeWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (!IsValidEntity(activeWeapon))
	{
		return;
	}

	// For functions that use GetEnemyTeam(), move everyone else to the enemy team
	// Disabled for now but it doesn't matter since this only applies to the Shortstop
	for (int i = 0; i < sizeof(g_EnemyItemIDs); i++)
	{
		if (GetWeaponID(activeWeapon) == g_EnemyItemIDs[i])
		{
			g_PostThinkType |= PostThinkType_EnemyTeam;

			TFTeam enemyTeam = GetEnemyTeam(TF2_GetClientTeam(client));

			for (int other = 1; other <= MaxClients; other++)
			{
				SF2_BasePlayer otherPlayer = SF2_BasePlayer(other);
				if (otherPlayer.IsValid && otherPlayer.index != player.index && (otherPlayer.IsInPvP))
				{
					otherPlayer.SetProp(Prop_Send, "m_iTeamNum", view_as<int>(enemyTeam));
				}
			}
		}
	}

	// For functions that do simple GetTeamNumber() checks, move ourselves to spectator team
	for (int i = 0; i < sizeof(g_SpectatorItemIDs); i++)
	{
		// Don't let losing team attack with those weapons
		if (GameRules_GetRoundState() == RoundState_TeamWin && TF2_GetClientTeam(client) != view_as<TFTeam>(GameRules_GetProp("m_iWinningTeam")))
		{
			break;
		}

		if (GetWeaponID(activeWeapon) == g_SpectatorItemIDs[i])
		{
			g_PostThinkType |= PostThinkType_Spectator;

			player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
		}
	}
}

static void ClientPostThinkPost(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsInPvP)
	{
		return;
	}

	// Change everything back to how it was accordingly
	if ((g_PostThinkType & PostThinkType_Spectator) != 0)
	{
		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	}

	if ((g_PostThinkType & PostThinkType_EnemyTeam) != 0)
	{
		for (int other = 1; other <= MaxClients; other++)
		{
			SF2_BasePlayer otherPlayer = SF2_BasePlayer(other);
			if (otherPlayer.IsValid && otherPlayer.index != player.index && otherPlayer.IsInPvP)
			{
				otherPlayer.SetProp(Prop_Send, "m_iTeamNum", view_as<int>(GetEnemyTeam(TF2_GetClientTeam(otherPlayer.index))));
			}
		}
	}

	g_PostThinkType = PostThinkType_None;
}

static Action Hook_PvPProjectile_OnTouch(int projectile, int client)
{
	// Check if the projectile hit a player outside of pvp area
	// Without that, cannon balls can bounce players which should not happen because they are outside of pvp.
	bool remove = false;
	if (IsValidClient(client) && !IsClientInPvP(client))
	{
		remove = true;
	}

	int owner = GetEntPropEnt(projectile, Prop_Data, "m_hOwnerEntity");
	if (owner == client)
	{
		remove = false;
	}

	if (remove)
	{
		float vel[3];
		CBaseEntity(client).GetAbsVelocity(vel);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		RemoveEntity(projectile);
		return Plugin_Handled;
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

			if (g_PlayerPvPTimer[ownerEntity] == null)
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

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	PvP_SetPlayerPvPState(client.index, false, false, false);

	g_PlayerIsLeavingPvP[client.index] = false;

	g_PlayerOriginalTeam[client.index] = client.Team;

	if (IsRoundInWarmup() || GameRules_GetProp("m_bInWaitingForPlayers"))
	{
		return;
	}

	if (client.IsAlive && client.IsParticipating)
	{
		if (!client.IsInGhostMode && !client.IsProxy)
		{
			if (client.IsEliminated || client.HasEscaped)
			{
				bool autoSpawn = g_PlayerPreferences[client.index].PlayerPreference_PvPAutoSpawn;

				if (autoSpawn)
				{
					g_PlayerPvPRespawnTimer[client.index] = CreateTimer(0.12, Timer_TeleportPlayerToPvP, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
			else
			{
				g_PlayerPvPRespawnTimer[client.index] = null;
			}
		}
	}
}

void PvP_ZapProjectile(int projectile, bool effects=true)
{
	if (!IsValidEntity(projectile))
	{
		return;
	}

	//Add zap effects
	if (effects)
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

static void OnPlayerDeathPre(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		if (client.IsInPvP)
		{
			client.SetProp(Prop_Send, "m_iTeamNum", g_PlayerOriginalTeam[client.index]);
		}
	}
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		if (client.IsInPvP)
		{
			g_PlayerIsLeavingPvP[client.index] = false;
		}

		if (!client.IsInGhostMode && !client.IsProxy)
		{
			bool autoSpawn = g_PlayerPreferences[client.index].PlayerPreference_PvPAutoSpawn;

			if (autoSpawn)
			{
				if (client.IsEliminated || client.HasEscaped)
				{
					if (!IsRoundEnding())
					{
						g_PlayerPvPRespawnTimer[client.index] = CreateTimer(0.3, Timer_RespawnPlayer, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}

		PvP_SetPlayerPvPState(client.index, false, false, false);
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

void PvP_OnTriggerStartTouch(int trigger, int other)
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

void PvP_OnTriggerEndTouch(int trigger, int other)
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

	//A projectile went off pvp area.
	if (other > MaxClients && IsValidEntity(other))
	{
		//Get entity's classname.
		char classname[50];
		GetEntityClassname(other, classname, sizeof(classname));
		for (int i = 0; i < (sizeof(g_PvPProjectileClasses) - 4); i++)
		{
			if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
			{
				if (!GetEntProp(other, Prop_Send, "m_iDeflected"))
				{
					//Yup it's a projectile zap it!
					//But we have to wait to prevent some bugs.
					CreateTimer(0.1, EntityStillAlive, other, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

static void PvP_OnTriggerStartTouchBoxing(int trigger, int other)
{
	if (other > MaxClients && IsValidEntity(other) && !IsRoundInWarmup() && !IsRoundEnding())
	{
		char classname[50];
		GetEntityClassname(other, classname, sizeof(classname));
		for (int i = 0; i < (sizeof(g_PvPProjectileClasses) - 4); i++)
		{
			if (strcmp(classname, g_PvPProjectileClasses[i], false) == 0)
			{
				if (!GetEntProp(other, Prop_Send, "m_iDeflected"))
				{
					CreateTimer(0.1, EntityStillAlive, other, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
}

static Action EntityStillAlive(Handle timer, int ref)
{
	int ent = EntRefToEntIndex(ref);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		PvP_ZapProjectile(ent);
	}
	return Plugin_Stop;
}
/**
 *	Enables/Disables PvP mode on the player.
 */
void PvP_SetPlayerPvPState(int client, bool status, bool removeProjectiles = true, bool regenerate = true)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid)
	{
		return;
	}

	bool oldInPvP = g_PlayerInPvP[player.index];
	if (status == oldInPvP)
	{
		return; // no change
	}

	if (status && player.IsInPvE)
	{
		PvE_ForceResetPlayerPvEData(player.index);
		PvE_SetPlayerPvEState(player.index, false, false);
	}

	g_PlayerInPvP[player.index] = status;
	g_PlayerPvPTimer[player.index] = null;
	g_PlayerPvPRespawnTimer[player.index] = null;
	g_PlayerPvPTimerCount[player.index] = 0;

	if (removeProjectiles)
	{
		// Remove previous projectiles.
		PvP_RemovePlayerProjectiles(player.index);
	}

	if (status)
	{
		Call_StartForward(g_OnPlayerEnterPvP);
		Call_PushCell(player.index);
		Call_Finish();
	}
	else
	{
		Call_StartForward(g_OnPlayerExitPvP);
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

static void FlameStartTouch(int flame, int other)
{
	SF2_BasePlayer client = SF2_BasePlayer(other);
	if (client.IsValid)
	{
		if ((client.IsInPvP) && !IsRoundEnding())
		{
			int flamethrower = GetEntPropEnt(flame, Prop_Data, "m_hOwnerEntity");
			if (IsValidEdict(flamethrower))
			{
				SF2_BasePlayer ownerEntity = SF2_BasePlayer(GetEntPropEnt(flamethrower, Prop_Data, "m_hOwnerEntity"));
				if (ownerEntity.index != client.index && ownerEntity.IsValid)
				{
					if (ownerEntity.IsInPvP)
					{
						if (client.Team == ownerEntity.Team && ownerEntity.Team != TFTeam_Red)
						{
							ownerEntity.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
						}
					}
				}
			}
		}
	}
}

static void FlameStartTouchPost(int flame, int other)
{
	int flamethrower = GetEntPropEnt(flame, Prop_Data, "m_hOwnerEntity");
	if (IsValidEdict(flamethrower))
	{
		SF2_BasePlayer ownerEntity = SF2_BasePlayer(GetEntPropEnt(flamethrower, Prop_Data, "m_hOwnerEntity"));
		if (ownerEntity.IsValid && ownerEntity.Team == TFTeam_Spectator)
		{
			ownerEntity.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
		}
	}
}

static Action GasStartTouch(int entity, int other)
{
	SF2_BasePlayer client = SF2_BasePlayer(other);
	if (client.IsValid)
	{
		if ((client.IsInPvP) && !IsRoundEnding())
		{
			SF2_BasePlayer ownerEntity = SF2_BasePlayer(GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity"));
			if (ownerEntity.index == client.index)
			{
				return Plugin_Handled;
			}

			if (ownerEntity.IsValid)
			{
				if (!ownerEntity.IsInPvP)
				{
					return Plugin_Handled;
				}
			}
		}
	}

	return Plugin_Continue;
}

static Action PipeOnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (attacker != -1)
	{
		int owner = GetEntPropEnt(victim, Prop_Data, "m_hOwnerEntity");
		if (owner == attacker)
		{
			return Plugin_Handled;
		}

		SF2_BasePlayer player = SF2_BasePlayer(owner);
		if (player.IsValid)
		{
			if (player.Team == TFTeam_Red)
			{
				return Plugin_Handled;
			}

			if (!player.IsInPvP)
			{
				return Plugin_Handled;
			}

			player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
		}
	}

	return Plugin_Continue;
}

static void PipeOnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damagetype)
{
	if (attacker != -1)
	{
		int owner = GetEntPropEnt(victim, Prop_Data, "m_hOwnerEntity");
		if (owner == attacker)
		{
			return;
		}

		SF2_BasePlayer player = SF2_BasePlayer(owner);
		if (player.IsValid)
		{
			if (player.Team == TFTeam_Red)
			{
				return;
			}

			if (!player.IsInPvP)
			{
				return;
			}

			player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
		}
	}
}

static MRESReturn PhysicsDispatchThinkPre(int entity)
{
	char classname[64];
	if (!GetEntityClassname(entity, classname, sizeof(classname)))
	{
		return MRES_Ignored;
	}

	if (strcmp(classname, "obj_sentrygun") == 0)
	{
		// CObjectSentrygun::SentryThink
		if (GetNextThink(entity, "SentryThink") != TICK_NEVER_THINK)
		{
			return MRES_Ignored;
		}

		g_ThinkFunction = ThinkFunction_SentryThink;

		TFTeam myTeam = TF2_GetEntityTeam(entity);
		TFTeam enemyTeam = GetEnemyTeam(myTeam);
		Address globalTeam = SDKCall_GetGlobalTeam(enemyTeam);

		// CObjectSentrygun::FindTarget uses CTFTeamManager to collect valid players.
		// Add all enemy players to the desired team.
		for (int client = 1; client <= MaxClients; client++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(client);
			if (player.IsValid && (player.IsInPvP))
			{
				TFTeam team = TF2_GetClientTeam(client);
				g_PreHookTeam[client] = team;
				bool friendly = IsObjectFriendly(entity, client);

				if (friendly && team == enemyTeam)
				{
					CTeam_RemovePlayer(globalTeam, client);
				}
				else if (!friendly && team != enemyTeam)
				{
					CTeam_AddPlayer(globalTeam, client);
				}

				// Sentry Guns don't shoot spies disguised as the same team, spoof the disguise team
				if (!friendly)
				{
					g_PreHookDisguiseTeam[client] = view_as<TFTeam>(GetEntProp(client, Prop_Send, "m_nDisguiseTeam"));
					SetEntProp(client, Prop_Send, "m_nDisguiseTeam", TFTeam_Spectator);
				}
			}
		}

		// Buildings work in a similar way.
		// NOTE: Previously, we would use CBaseObject::ChangeTeam, but we switched to AddObject/RemoveObject calls,
		// due to ChangeTeam recreating the build points, causing issues with sapper placement.
		int obj = -1;
		while ((obj = FindEntityByClassname(obj, "obj_*")) != -1)
		{
			if (!GetEntProp(obj, Prop_Send, "m_bPlacing"))
			{
				TFTeam team = TF2_GetEntityTeam(obj);
				g_PreHookTeam[obj] = team;
				bool friendly = IsObjectFriendly(entity, obj);

				if (friendly && team == enemyTeam)
				{
					CTeam_RemoveObject(globalTeam, obj);
				}
				else if (!friendly && team != enemyTeam)
				{
					CTeam_AddObject(globalTeam, obj);
				}
			}
		}
	}
	else if (strcmp(classname, "obj_dispenser") == 0)
	{
		// CObjectDispenser::DispenseThink
		if (GetNextThink(entity, "DispenseThink") != TICK_NEVER_THINK)
		{
			return MRES_Ignored;
		}

		if (!GetEntProp(entity, Prop_Send, "m_bPlacing") && !GetEntProp(entity, Prop_Send, "m_bBuilding"))
		{
			g_ThinkFunction = ThinkFunction_DispenseThink;

			// Disallow players able to be healed from dispenser
			for (int client = 1; client <= MaxClients; client++)
			{
				SF2_BasePlayer player = SF2_BasePlayer(client);
				if (player.IsValid && player.IsInPvP && player.Team != TFTeam_Red)
				{
					if (!IsObjectFriendly(entity, client))
					{
						player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
					}
				}
			}
		}
	}
	else if (strcmp(classname, "obj_attachment_sapper") == 0)
	{
		// CBaseObject::BaseObjectThink
		if (GetNextThink(entity, "BaseObjectThink") != TICK_NEVER_THINK)
		{
			return MRES_Ignored;
		}

		g_ThinkFunction = ThinkFunction_SapperThink;

		// Always set team to spectator so we can place sappers on buildings of both teams
		CBaseEntity_ChangeTeam(entity, view_as<TFTeam>(TFTeam_Spectator));
	}

	return MRES_Ignored;
}

static MRESReturn PhysicsDispatchThinkPost(int entity)
{
	switch (g_ThinkFunction)
	{
		case ThinkFunction_SentryThink:
		{
			TFTeam myTeam = TF2_GetEntityTeam(entity);
			TFTeam enemyTeam = GetEnemyTeam(myTeam);
			Address globalTeam = SDKCall_GetGlobalTeam(enemyTeam);

			for (int client = 1; client <= MaxClients; client++)
			{
				SF2_BasePlayer player = SF2_BasePlayer(client);
				if (player.IsValid && (player.IsInPvP))
				{
					TFTeam team = g_PreHookTeam[client];
					g_PreHookTeam[client] = TFTeam_Unassigned;
					bool friendly = IsObjectFriendly(entity, client);

					if (friendly && team == enemyTeam)
					{
						CTeam_AddPlayer(globalTeam, client);
					}
					else if (!friendly && team != enemyTeam)
					{
						CTeam_RemovePlayer(globalTeam, client);
					}

					if (!friendly)
					{
						SetEntProp(client, Prop_Send, "m_nDisguiseTeam", g_PreHookDisguiseTeam[client]);
						g_PreHookDisguiseTeam[client] = TFTeam_Unassigned;
					}
				}
			}

			int obj = -1;
			while ((obj = FindEntityByClassname(obj, "obj_*")) != -1)
			{
				if (!GetEntProp(obj, Prop_Send, "m_bPlacing"))
				{
					TFTeam team = g_PreHookTeam[obj];
					bool friendly = IsObjectFriendly(entity, obj);

					if (friendly && team == enemyTeam)
					{
						CTeam_AddObject(globalTeam, obj);
					}
					else if (!friendly && team != enemyTeam)
					{
						CTeam_RemoveObject(globalTeam, obj);
					}

					g_PreHookTeam[obj] = TFTeam_Unassigned;
				}
			}
		}
		case ThinkFunction_DispenseThink:
		{
			for (int client = 1; client <= MaxClients; client++)
			{
				SF2_BasePlayer player = SF2_BasePlayer(client);
				if (player.IsValid && (player.IsInPvP) && player.Team != TFTeam_Red)
				{
					if (!IsObjectFriendly(entity, client))
					{
						player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
					}
				}
			}
		}
	}

	g_ThinkFunction = ThinkFunction_None;

	return MRES_Ignored;
}

static MRESReturn FlareExplodePre(int entity, DHookParam params)
{
	SF2_BasePlayer other = SF2_BasePlayer(params.Get(2));
	if (!other.IsValid)
	{
		return MRES_Ignored;
	}

	if (!other.IsInPvP)
	{
		return MRES_Ignored;
	}

	if (other.Team == TFTeam_Red)
	{
		return MRES_Ignored;
	}

	other.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);

	return MRES_Ignored;
}

static MRESReturn FlareExplodePost(int entity, DHookParam params)
{
	SF2_BasePlayer other = SF2_BasePlayer(params.Get(2));
	if (!other.IsValid)
	{
		return MRES_Ignored;
	}

	if (!other.IsInPvP)
	{
		return MRES_Ignored;
	}

	if (other.Team == TFTeam_Red)
	{
		return MRES_Ignored;
	}

	other.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);

	return MRES_Ignored;
}

static MRESReturn AllowedToHealTargetPre(int medigun, DHookReturn ret, DHookParam params)
{
	SF2_BasePlayer owner = SF2_BasePlayer(GetEntPropEnt(medigun, Prop_Send, "m_hOwnerEntity"));
	if (!owner.IsValid)
	{
		owner = SF2_BasePlayer(GetEntPropEnt(medigun, Prop_Send, "m_hOwner"));
	}
	int entity = params.Get(1);
	SF2_BasePlayer target = SF2_BasePlayer(entity);
	if (owner.IsEliminated)
	{
		if (target.IsValid)
		{
			if (target.IsEliminated)
			{
				if (owner.IsInPvP && !target.IsInPvP)
				{
					ret.Value = false;
					return MRES_Supercede;
				}

				if (!owner.IsInPvP && target.IsInPvP)
				{
					ret.Value = false;
					return MRES_Supercede;
				}
			}
			else
			{
				ret.Value = true;
				return MRES_Supercede;
			}
		}
		else if (entity > MaxClients && NPCGetFromEntIndex(entity) != -1)
		{
			ret.Value = true;
			return MRES_Supercede;
		}
	}
	return MRES_Ignored;
}

static MRESReturn JarExplodePre(int entity, DHookParam params)
{
	SF2_BasePlayer thrower = SF2_BasePlayer(GetEntPropEnt(entity, Prop_Send, "m_hThrower"));
	if (!thrower.IsValid)
	{
		return MRES_Ignored;
	}

	if (!thrower.IsInPvP)
	{
		return MRES_Ignored;
	}

	if (thrower.Team == TFTeam_Red)
	{
		return MRES_Ignored;
	}

	thrower.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
	CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);

	return MRES_Ignored;
}

static MRESReturn JarExplodePost(int entity, DHookParam params)
{
	SF2_BasePlayer thrower = SF2_BasePlayer(GetEntPropEnt(entity, Prop_Send, "m_hThrower"));
	if (!thrower.IsValid)
	{
		return MRES_Ignored;
	}

	if (!thrower.IsInPvP)
	{
		return MRES_Ignored;
	}

	if (thrower.Team == TFTeam_Red)
	{
		return MRES_Ignored;
	}

	thrower.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);

	return MRES_Ignored;
}

static MRESReturn VPhysicsUpdatePre(int entity, DHookParam params)
{
	SF2_BasePlayer thrower = SF2_BasePlayer(GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity"));
	if (!thrower.IsValid)
	{
		return MRES_Ignored;
	}

	if (!thrower.IsInPvP)
	{
		return MRES_Ignored;
	}

	if (thrower.Team == TFTeam_Red)
	{
		return MRES_Ignored;
	}

	TFTeam enemyTeam = GetEnemyTeam(TF2_GetEntityTeam(entity));

	// Not needed because of our CanCollideWithTeammates hook, but can't hurt
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid || client.Team == TFTeam_Red)
		{
			continue;
		}

		if (!client.IsInPvP)
		{
			continue;
		}

		client.SetProp(Prop_Send, "m_iTeamNum", view_as<int>(enemyTeam));
	}

	// Fix projectiles rarely bouncing off buildings
	int obj = -1;
	while ((obj = FindEntityByClassname(obj, "obj_*")) != -1)
	{
		if (!IsObjectFriendly(obj, thrower.index))
		{
			continue;
		}

		if (CBaseEntity(obj).GetProp(Prop_Send, "m_iTeamNum") == TFTeam_Red)
		{
			continue;
		}

		CBaseEntity(obj).SetProp(Prop_Send, "m_iTeamNum", view_as<int>(enemyTeam));
	}

	return MRES_Ignored;
}

static MRESReturn VPhysicsUpdatePost(int entity, DHookParam params)
{
	int thrower = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");

	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer client = SF2_BasePlayer(i);
		if (!client.IsValid || client.Team == TFTeam_Red)
		{
			continue;
		}

		if (!client.IsInPvP)
		{
			continue;
		}

		client.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	}

	int obj = -1;
	while ((obj = FindEntityByClassname(obj, "obj_*")) != -1)
	{
		if (!IsObjectFriendly(obj, thrower))
		{
			continue;
		}

		CBaseEntity(obj).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	}

	return MRES_Ignored;
}

static Action CleaverTouch(int entity, int other)
{
	if (other == 0)
	{
		return Plugin_Continue;
	}

	int owner = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
	if (owner == other)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer player = SF2_BasePlayer(owner);
	if (player.IsValid)
	{
		if (player.Team == TFTeam_Red)
		{
			return Plugin_Continue;
		}

		if (!player.IsInPvP)
		{
			return Plugin_Continue;
		}

		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
		CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
	}

	return Plugin_Continue;
}

static void CleaverTouchPost(int entity, int other)
{
	if (other == 0)
	{
		return;
	}

	int owner = GetEntPropEnt(entity, Prop_Data, "m_hThrower");
	if (owner == other)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(owner);
	if (player.IsValid)
	{
		if (player.Team == TFTeam_Red)
		{
			return;
		}

		if (!player.IsInPvP)
		{
			return;
		}

		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
		CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	}
}

static Action GrenadeTouch(int entity, int other)
{
	if (other == 0)
	{
		return Plugin_Continue;
	}

	int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
	if (owner == other)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer player = SF2_BasePlayer(owner);
	if (player.IsValid)
	{
		if (player.Team == TFTeam_Red)
		{
			return Plugin_Continue;
		}

		if (!player.IsInPvP)
		{
			return Plugin_Continue;
		}

		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
		CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Spectator);
	}

	return Plugin_Continue;
}

static void GrenadeTouchPost(int entity, int other)
{
	if (other == 0)
	{
		return;
	}

	int owner = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");
	if (owner == other)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(owner);
	if (player.IsValid)
	{
		if (player.Team == TFTeam_Red)
		{
			return;
		}

		if (!player.IsInPvP)
		{
			return;
		}

		player.SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
		CBaseEntity(entity).SetProp(Prop_Send, "m_iTeamNum", TFTeam_Blue);
	}
}

static MRESReturn GetCustomDamageTypePost(int entity, DHookReturn ret)
{
	// Allows Sniper Rifles to hit teammates, without breaking Machina penetration
	int penetrateType = SDKCall(g_SDKGetPenetrationType, entity);
	if (penetrateType == 0)
	{
		ret.Value = 0;
		return MRES_Supercede;
	}

	return MRES_Ignored;
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
		TeleportEntity(client, pos, ang, { 0.0, 0.0, 0.0 });

		EmitAmbientSound(SF2_PVP_SPAWN_SOUND, pos, _, SNDLEVEL_NORMAL, _, 1.0);
		if (g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection)
		{
			TF2_AddCondition(client, TFCond_UberchargedCanteen, 1.5);
		}

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

bool IsClientLeavingPvP(int client)
{
	return g_PlayerIsLeavingPvP[client];
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

// For mediguns, eventually I'll make proper assistants
static Action OnPlayerDeathEventPre(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer attacker = SF2_BasePlayer(GetClientOfUserId(event.GetInt("attacker")));

	if (attacker.IsValid && attacker.IsInPvP)
	{
		CBaseEntity weapon = CBaseEntity(attacker.GetPropEnt(Prop_Send, "m_hActiveWeapon"));
		if (weapon.IsValid() && GetWeaponID(weapon.index) == TF_WEAPON_MEDIGUN)
		{
			event.SetString("weapon_logclassname", "tf_weapon_deathgun");
			event.SetString("weapon", "merasmus_zap");
		}
	}

	SF2_BasePlayer assister = SF2_BasePlayer(GetClientOfUserId(event.GetInt("assister")));
	if (assister.IsValid && assister.IsInPvP)
	{
		CBaseEntity weapon = CBaseEntity(assister.GetPropEnt(Prop_Send, "m_hActiveWeapon"));
		if (weapon.IsValid() && GetWeaponID(weapon.index) == TF_WEAPON_MEDIGUN)
		{
			CBaseEntity target = CBaseEntity(weapon.GetPropEnt(Prop_Send, "m_hHealingTarget"));
			if (target.index == attacker.index)
			{
				event.SetInt("assister", -1);
				event.SetString("assister_fallback", "");
			}
		}
	}

	return Plugin_Changed;
}

static MRESReturn Hook_PvPProjectileCanCollideWithTeammates(int projectile, DHookReturn returnHandle, DHookParam params)
{
	if (!g_Enabled)
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
	g_OnPlayerEnterPvP = new GlobalForward("SF2_OnClientEnterPvP", ET_Ignore, Param_Cell);
	g_OnPlayerExitPvP = new GlobalForward("SF2_OnClientEnterPvP", ET_Ignore, Param_Cell);
}

static int Native_IsClientInPvP(Handle plugin,int numParams)
{
	return IsClientInPvP(GetNativeCell(1));
}