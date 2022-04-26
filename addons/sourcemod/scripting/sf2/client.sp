#if defined _sf2_client_included
 #endinput
#endif
#define _sf2_client_included

#define SF2_OVERLAY_DEFAULT "overlays/slender/newcamerahud_3"
#define SF2_OVERLAY_DEFAULT_NO_FILMGRAIN "overlays/slender/nofilmgrain"
#define SF2_OVERLAY_GHOST "overlays/slender/ghostcamera"
#define SF2_OVERLAY_MARBLEHORNETS "overlays/slender/marblehornetsoverlay"

#define SF2_ULTRAVISION_WIDTH 800.0
#define SF2_ULTRAVISION_LENGTH 800.0
#define SF2_ULTRAVISION_BRIGHTNESS -4 // Intensity of Ultravision.

#define SF2_PLAYER_BREATH_COOLDOWN_MIN 0.8
#define SF2_PLAYER_BREATH_COOLDOWN_MAX 2.0

char g_strPlayerBreathSounds[][] = 
{
	"slender/fastbreath1.wav"
};

//Client Special Round Timer
Handle g_ClientSpecialRoundTimer[MAXPLAYERS + 1];

// Deathcam data.
static int g_iPlayerDeathCamBoss[MAXPLAYERS + 1] = { -1, ... };
static bool g_bPlayerDeathCam[MAXPLAYERS + 1] = { false, ... };
static bool g_bPlayerDeathCamShowOverlay[MAXPLAYERS + 1] = { false, ... };
int g_PlayerDeathCamEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_PlayerDeathCamEnt2[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_PlayerDeathCamTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
Handle g_PlayerDeathCamTimer[MAXPLAYERS + 1] = { null, ... };
bool g_CameraInDeathCamAdvanced[2049] = { false, ... };
float g_CameraPlayerOffsetBackward[2049] = { 0.0, ... };
float g_CameraPlayerOffsetDownward[2049] = { 0.0, ... };
float g_vecPlayerOriginalDeathcamPosition[MAXPLAYERS + 1][3];

// Flashlight data.
bool g_PlayerHasFlashlight[MAXPLAYERS + 1] = { false, ... };
bool g_PlayerFlashlightBroken[MAXPLAYERS + 1] = { false, ... };
int g_PlayerFlashlightEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_PlayerFlashlightEntAng[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
float g_PlayerFlashlightBatteryLife[MAXPLAYERS + 1] = { 1.0, ... };
Handle g_PlayerFlashlightBatteryTimer[MAXPLAYERS + 1] = { null, ... };
float g_PlayerFlashlightNextInputTime[MAXPLAYERS + 1] = { -1.0, ... };

int g_ActionItemIndexes[] = { 57, 231 };

// Ultravision data.
bool g_PlayerHasUltravision[MAXPLAYERS + 1] = { false, ... };
int g_PlayerUltravisionEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Sprint data.
static bool g_PlayerSprint[MAXPLAYERS + 1] = { false, ... };
int g_PlayerSprintPoints[MAXPLAYERS + 1] = { 100, ... };
Handle g_PlayerSprintTimer[MAXPLAYERS + 1] = { null, ... };

// Blink data.
Handle g_PlayerBlinkTimer[MAXPLAYERS + 1] = { null, ... };
static bool g_PlayerBlink[MAXPLAYERS + 1] = { false, ... };
bool g_PlayerHoldingBlink[MAXPLAYERS + 1] = { false, ... };
static float g_PlayerBlinkMeter[MAXPLAYERS + 1] = { 0.0, ... };
static float g_TimeUntilUnblink[MAXPLAYERS + 1] = { 0.0, ... };
static int g_PlayerBlinkCount[MAXPLAYERS + 1] = { 0, ... };

// Breathing data.
bool g_PlayerBreath[MAXPLAYERS + 1] = { false, ... };
Handle g_PlayerBreathTimer[MAXPLAYERS + 1] = { null, ... };

// Interactive glow data.
static int g_PlayerInteractiveGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerInteractiveGlowTargetEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Constant glow data.
static int g_PlayerConstantGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static bool g_PlayerConstantGlowEnabled[MAXPLAYERS + 1] = { false, ... };
Handle g_ClientGlowTimer[MAXPLAYERS + 1];

// Jumpscare data.
static int g_PlayerJumpScareBoss[MAXPLAYERS + 1] = { -1, ... };
static float g_PlayerJumpScareLifeTime[MAXPLAYERS + 1] = { -1.0, ... };

static float g_PlayerScareBoostEndTime[MAXPLAYERS + 1] = { -1.0, ... };

// Anti-camping data.
int g_PlayerCampingStrikes[MAXPLAYERS + 1] = { 0, ... };
Handle g_PlayerCampingTimer[MAXPLAYERS + 1] = { null, ... };
float g_PlayerCampingLastPosition[MAXPLAYERS + 1][3];
bool g_IsPlayerCampingFirstTime[MAXPLAYERS + 1];

// Frame data
int g_ClientMaxFrameDeathAnim[MAXPLAYERS + 1];
int g_ClientFrame[MAXPLAYERS + 1];

// Client model
static char g_OldClientModel[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

//Proxy model
char g_ClientProxyModel[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_ClientProxyModelHard[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_ClientProxyModelInsane[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_ClientProxyModelNightmare[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_ClientProxyModelApollyon[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

//Nav Data
//static CNavArea g_lastNavArea[MAXPLAYERS + 1];

static float g_ClientAllowedTimeNearEscape[MAXPLAYERS + 1];
//Peeking Data
static bool g_PlayerPeeking[MAXPLAYERS + 1] = { false, ... };

//	==========================================================
//	GENERAL CLIENT HOOK FUNCTIONS
//	==========================================================

#define SF2_PLAYER_VIEWBOB_TIMER 10.0
#define SF2_PLAYER_VIEWBOB_SCALE_X 0.05
#define SF2_PLAYER_VIEWBOB_SCALE_Y 0.0
#define SF2_PLAYER_VIEWBOB_SCALE_Z 0.0

public MRESReturn Hook_ClientWantsLagCompensationOnEntity(int client, Handle returnHandle, Handle params)
{
	if (!g_Enabled || IsFakeClient(client))
	{
		return MRES_Ignored;
	}

	DHookSetReturn(returnHandle, true);
	return MRES_Supercede;
}

public Action CH_ShouldCollide(int ent1,int ent2, bool &result)
{
	SF2RoundState state = GetRoundState();
	if (state == SF2RoundState_Intro || state == SF2RoundState_Outro)
	{
		return Plugin_Continue;
	}

	if (MaxClients >= ent1 > 0)
	{
		if (IsClientInGhostMode(ent1))
		{
			result = false;
			return Plugin_Changed;
		}
	}
	if (MaxClients >= ent2 > 0)
	{
		if (IsClientInGhostMode(ent2))
		{
			result = false;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

public Action CH_PassFilter(int ent1,int ent2, bool &result)
{
	SF2RoundState state = GetRoundState();
	if (state == SF2RoundState_Intro || state == SF2RoundState_Outro)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(ent1))
	{
		if (IsClientInGhostMode(ent1))
		{
			result = false;
			return Plugin_Changed;
		}
	}
	if (IsValidClient(ent2))
	{
		if (IsClientInGhostMode(ent2))
		{
			result = false;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

float ClientGetScareBoostEndTime(int client)
{
	return g_PlayerScareBoostEndTime[client];
}

void ClientSetScareBoostEndTime(int client, float time)
{
	g_PlayerScareBoostEndTime[client] = time;
}

public Action Hook_HealthKitOnTouch(int healthKit, int client)
{
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (!SF_IsBoxingMap())
		{
			if (!g_PlayerEliminated[client] && TF2_GetPlayerClass(client) == TFClass_Medic)
			{
				return Plugin_Handled;
			}
		}
		if (IsClientInGhostMode(client))
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public Action Hook_ClientSetTransmit(int client,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	
	if (other != client)
	{
		if (IsClientInGhostMode(client))
		{
#if defined DEBUG
			SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Prevented myself from being transmited to %N.", other);
#endif
			return Plugin_Handled;
		}

		if (!IsRoundEnding())
		{
			// pvp
			if (IsClientInPvP(client) && IsClientInPvP(other)) 
			{
				if (TF2_IsPlayerInCondition(client, TFCond_Cloaked) &&
					!TF2_IsPlayerInCondition(client, TFCond_CloakFlicker) &&
					!TF2_IsPlayerInCondition(client, TFCond_Jarated) &&
					!TF2_IsPlayerInCondition(client, TFCond_Milked) &&
					!TF2_IsPlayerInCondition(client, TFCond_OnFire) &&
					(GetGameTime() > GetEntPropFloat(client, Prop_Send, "m_flInvisChangeCompleteTime")))
				{
					return Plugin_Handled;
				}
			}
		}
	}
	
	return Plugin_Continue;
}

public Action TF2_CalcIsAttackCritical(int client,int weapon, char[] weaponName, bool &result)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if ((IsRoundInWarmup() || IsClientInPvP(client)) && !IsRoundEnding())
	{
		//Save this for later I guess
	}
	
	return Plugin_Continue;
}

public void Hook_ClientWeaponEquipPost(int client, int weapon)
{
	if (!IsValidClient(client) || !IsClientInGame(client) || !IsValidEdict(weapon))
	{
		return;
	}
	g_hSDKWeaponGetCustomDamageType.HookEntity(Hook_Pre, weapon, Hook_WeaponGetCustomDamageType);
}

public Action Hook_TEFireBullets(const char[] te_name,const int[] players,int numClients, float delay)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	
	int client = TE_ReadNum("m_iPlayer") + 1;
	if (IsValidClient(client))
	{
		//Save this for later I guess
	}
	
	return Plugin_Continue;
}

void ClientResetStatic(int client)
{
	g_PlayerStaticMaster[client] = -1;
	g_PlayerStaticTimer[client] = null;
	g_flPlayerStaticIncreaseRate[client] = 0.0;
	g_flPlayerStaticDecreaseRate[client] = 0.0;
	g_hPlayerLastStaticTimer[client] = null;
	g_flPlayerLastStaticTime[client] = 0.0;
	g_flPlayerLastStaticVolume[client] = 0.0;
	g_bPlayerInStaticShake[client] = false;
	g_iPlayerStaticShakeMaster[client] = -1;
	g_flPlayerStaticShakeMinVolume[client] = 0.0;
	g_flPlayerStaticShakeMaxVolume[client] = 0.0;
	g_PlayerStaticAmount[client] = 0.0;
	
	if (IsClientInGame(client))
	{
		if (g_PlayerStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticSound[client]);
		}
		if (g_PlayerLastStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
		}
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
		}
	}
	
	g_PlayerStaticSound[client][0] = '\0';
	g_PlayerLastStaticSound[client][0] = '\0';
	g_PlayerStaticShakeSound[client][0] = '\0';
}

void ClientResetHints(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetHints(%d)", client);
	}
#endif

	for (int i = 0; i < PlayerHint_MaxNum; i++)
	{
		g_PlayerHints[client][i] = false;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetHints(%d)", client);
	}
#endif
}

void ClientShowHint(int client,int hint)
{
	g_PlayerHints[client][hint] = true;
	
	switch (hint)
	{
		case PlayerHint_Sprint:
		{
			PrintHintText(client, "%T", "SF2 Hint Sprint", client);
		}
		case PlayerHint_Flashlight:
		{
			PrintHintText(client, "%T", "SF2 Hint Flashlight", client);
		}
		case PlayerHint_Blink:
		{
			PrintHintText(client, "%T", "SF2 Hint Blink", client);
		}
		case PlayerHint_MainMenu:
		{
			PrintHintText(client, "%T", "SF2 Hint Main Menu", client);
		}
		case PlayerHint_Trap:
		{
			PrintHintText(client, "%T", "SF2 Hint Trap", client);
		}
	}
}

bool DidClientEscape(int client)
{
	return g_PlayerEscaped[client];
}

void ClientEscape(int client)
{
	if (DidClientEscape(client))
	{
		return;
	}

#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("START ClientEscape(%d)", client);
	}
#endif
	
	g_PlayerEscaped[client] = true;
	
	g_PlayerPageCount[client] = 0;

	ClientResetStatic(client);
	ClientResetSlenderStats(client);
	ClientResetCampingStats(client);
	ClientResetOverlay(client);
	ClientResetJumpScare(client);
	ClientUpdateListeningFlags(client);
	ClientUpdateMusicSystem(client);
	ClientChaseMusicReset(client);
	ClientChaseMusicSeeReset(client);
	ClientAlertMusicReset(client);
	ClientIdleMusicReset(client);
	Client20DollarsMusicReset(client);
	Client90sMusicReset(client);
	ClientMusicReset(client);
	ClientResetProxy(client);
	ClientResetHints(client);
	ClientResetScare(client);
			
	ClientResetDeathCam(client);
	ClientResetFlashlight(client);
	ClientDeactivateUltravision(client);
	ClientResetSprint(client);
	ClientResetBreathing(client);
	ClientResetBlink(client);
	ClientResetInteractiveGlow(client);
	ClientDisableConstantGlow(client);
	
	ClientHandleGhostMode(client);

	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		if (g_NpcChaseOnLookTarget[npcIndex] == null)
		{
			continue;
		}
		int foundClient = g_NpcChaseOnLookTarget[npcIndex].FindValue(client);
		if (foundClient != -1)
		{
			g_NpcChaseOnLookTarget[npcIndex].Erase(foundClient);
		}
	}
	
	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);
	
	HandlePlayerHUD(client);
	if (!SF_IsBoxingMap())
	{
		char name[MAX_NAME_LENGTH];
		FormatEx(name, sizeof(name), "%N", client);
		CPrintToChatAll("%t", "SF2 Player Escaped", name);
	}

	if (SF_IsRenevantMap() && g_RenevantMarkForDeath)
	{
		TF2_RemoveCondition(client, TFCond_MarkedForDeathSilent);
	}
	
	CheckRoundWinConditions();
	
	Call_StartForward(g_OnClientEscapeFwd);
	Call_PushCell(client);
	Call_Finish();
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 1)
	{
		DebugMessage("END ClientEscape(%d)", client);
	}
#endif
}

public Action Timer_TeleportPlayerToEscapePoint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}
	
	if (!DidClientEscape(client))
	{
		return Plugin_Stop;
	}
	
	if (IsPlayerAlive(client))
	{
		TeleportClientToEscapePoint(client);
	}
	return Plugin_Stop;
}

stock float ClientGetDistanceFromEntity(int client,int entity)
{
	float startPos[3], endPos[3];
	GetClientAbsOrigin(client, startPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", endPos);
	return GetVectorSquareMagnitude(startPos, endPos);
}

float ClientGetDefaultWalkSpeed(int client)
{
	float returnFloat = 190.0;
	float returnFloat2 = returnFloat;
	Action action = Plugin_Continue;
	/*TFClassType iClass = TF2_GetPlayerClass(client);
	
	switch (iClass)
	{
		case TFClass_Scout:
		{
			returnFloat = 190.0;
		}
		case TFClass_Sniper:
		{
			returnFloat = 180.0;
		}
		case TFClass_Soldier:
		{
			returnFloat = 170.0;
		}
		case TFClass_DemoMan:
		{
			returnFloat = 175.0;
		}
		case TFClass_Heavy:
		{
			returnFloat = 170.0;
		}
		case TFClass_Medic:
		{
			returnFloat = 185.0;
		}
		case TFClass_Pyro:
		{
			returnFloat = 180.0;
		}
		case TFClass_Spy:
		{
			returnFloat = 185.0;
		}
		case TFClass_Engineer:
		{
			returnFloat = 180.0;
		}
	}*/
	//Psyche, everyone walks the same.
	
	// Call our forward.
	Call_StartForward(g_OnClientGetDefaultWalkSpeedFwd);
	Call_PushCell(client);
	Call_PushCellRef(returnFloat2);
	Call_Finish(action);
	
	if (action == Plugin_Changed)
	{
		returnFloat = returnFloat2;
	}
	
	return returnFloat;
}

float ClientGetDefaultSprintSpeed(int client)
{
	float returnFloat = 340.0;
	float returnFloat2 = returnFloat;
	Action action = Plugin_Continue;
	TFClassType iClass = TF2_GetPlayerClass(client);
	
	switch (iClass)
	{
		case TFClass_Scout:
		{
			returnFloat = 305.0;
		}
		case TFClass_Sniper:
		{
			returnFloat = 295.0;
		}
		case TFClass_Soldier:
		{
			returnFloat = 280.0;
		}
		case TFClass_DemoMan:
		{
			returnFloat = 280.0;
		}
		case TFClass_Heavy:
		{
			returnFloat = 280.0;
		}
		case TFClass_Medic:
		{
			returnFloat = 300.0;
		}
		case TFClass_Pyro:
		{
			returnFloat = 290.0;
		}
		case TFClass_Spy:
		{
			returnFloat = 300.0;
		}
		case TFClass_Engineer:
		{
			returnFloat = 295.0;
		}
	}
	
	// Call our forward.
	Call_StartForward(g_OnClientGetDefaultSprintSpeedFwd);
	Call_PushCell(client);
	Call_PushCellRef(returnFloat2);
	Call_Finish(action);
	
	if (action == Plugin_Changed)
	{
		returnFloat = returnFloat2;
	}
	
	return returnFloat;
}

// Static shaking should only affect the x, y portion of the player's view, not roll.
// This is purely for cosmetic effect.

void ClientProcessStaticShake(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}
	
	bool bOldStaticShake = g_bPlayerInStaticShake[client];
	int iOldStaticShakeMaster = NPCGetFromUniqueID(g_iPlayerStaticShakeMaster[client]);
	int iNewStaticShakeMaster = -1;
	float flNewStaticShakeMasterAnger = -1.0;
	
	float flOldPunchAng[3], flOldPunchAngVel[3];
	GetEntDataVector(client, g_PlayerPunchAngleOffset, flOldPunchAng);
	GetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flOldPunchAngVel);
	
	float flNewPunchAng[3], flNewPunchAngVel[3];
	
	for (int i = 0; i < 3; i++)
	{
		flNewPunchAng[i] = flOldPunchAng[i];
		flNewPunchAngVel[i] = flOldPunchAngVel[i];
	}
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		
		if (g_iPlayerStaticMode[client][i] != Static_Increase) continue;
		if (!(NPCGetFlags(i) & SFF_HASSTATICSHAKE)) continue;
		
		if (NPCGetAnger(i) > flNewStaticShakeMasterAnger)
		{
			int iMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);
			if (iMaster == -1) iMaster = i;
			
			iNewStaticShakeMaster = iMaster;
			flNewStaticShakeMasterAnger = NPCGetAnger(iMaster);
		}
	}
	
	if (iNewStaticShakeMaster != -1)
	{
		g_iPlayerStaticShakeMaster[client] = NPCGetUniqueID(iNewStaticShakeMaster);
		
		if (iNewStaticShakeMaster != iOldStaticShakeMaster)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iNewStaticShakeMaster, profile, sizeof(profile));
		
			if (g_PlayerStaticShakeSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
			}
			
			g_flPlayerStaticShakeMinVolume[client] = GetProfileFloat(profile, "sound_static_shake_local_volume_min", 0.0);
			g_flPlayerStaticShakeMaxVolume[client] = GetProfileFloat(profile, "sound_static_shake_local_volume_max", 1.0);
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_static_shake_local", sStaticSound, sizeof(sStaticSound));
			if (sStaticSound[0] != '\0')
			{
				strcopy(g_PlayerStaticShakeSound[client], sizeof(g_PlayerStaticShakeSound[]), sStaticSound);
			}
			else
			{
				g_PlayerStaticShakeSound[client][0] = '\0';
			}
		}
	}
	
	if (g_bPlayerInStaticShake[client])
	{
		if (g_PlayerStaticAmount[client] <= 0.0)
		{
			g_bPlayerInStaticShake[client] = false;
		}
	}
	else
	{
		if (iNewStaticShakeMaster != -1)
		{
			g_bPlayerInStaticShake[client] = true;
		}
	}
	
	if (g_bPlayerInStaticShake[client] && !bOldStaticShake)
	{	
		for (int i = 0; i < 2; i++)
		{
			flNewPunchAng[i] = 0.0;
			flNewPunchAngVel[i] = 0.0;
		}
		
		SetEntDataVector(client, g_PlayerPunchAngleOffset, flNewPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flNewPunchAngVel, true);
	}
	else if (!g_bPlayerInStaticShake[client] && bOldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			flNewPunchAng[i] = 0.0;
			flNewPunchAngVel[i] = 0.0;
		}
	
		g_iPlayerStaticShakeMaster[client] = -1;
		
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
		}
		
		g_PlayerStaticShakeSound[client][0] = '\0';
		
		g_flPlayerStaticShakeMinVolume[client] = 0.0;
		g_flPlayerStaticShakeMaxVolume[client] = 0.0;
		
		SetEntDataVector(client, g_PlayerPunchAngleOffset, flNewPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flNewPunchAngVel, true);
	}
	
	if (g_bPlayerInStaticShake[client])
	{
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			float flVolume = g_PlayerStaticAmount[client];
			if (GetRandomFloat(0.0, 1.0) <= 0.35)
			{
				flVolume = 0.0;
			}
			else
			{
				if (flVolume < g_flPlayerStaticShakeMinVolume[client])
				{
					flVolume = g_flPlayerStaticShakeMinVolume[client];
				}
				
				if (flVolume > g_flPlayerStaticShakeMaxVolume[client])
				{
					flVolume = g_flPlayerStaticShakeMaxVolume[client];
				}
			}
			
			EmitSoundToClient(client, g_PlayerStaticShakeSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL | SND_STOP, flVolume);
		}
		
		// Spazz our view all over the place.
		for (int i = 0; i < 2; i++) flNewPunchAng[i] = AngleNormalize(GetRandomFloat(0.0, 360.0));
		NormalizeVector(flNewPunchAng, flNewPunchAng);
		
		float flAngVelocityScalar = 5.0 * g_PlayerStaticAmount[client];
		if (flAngVelocityScalar < 1.0) flAngVelocityScalar = 1.0;
		ScaleVector(flNewPunchAng, flAngVelocityScalar);
		
		for (int i = 0; i < 2; i++) flNewPunchAngVel[i] = 0.0;
		
		SetEntDataVector(client, g_PlayerPunchAngleOffset, flNewPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flNewPunchAngVel, true);
	}
}
void ClientProcessVisibility(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client)) return;
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH], sMasterProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	bool bWasSeeingSlender[MAX_BOSSES];
	int iOldStaticMode[MAX_BOSSES];
	
	float flSlenderPos[3];
	float flSlenderEyePos[3];
	float flSlenderOBBCenterPos[3];
	
	float flMyPos[3];
	GetClientAbsOrigin(client, flMyPos);

	int difficulty = g_DifficultyConVar.IntValue;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		bWasSeeingSlender[i] = g_PlayerSeesSlender[client][i];
		iOldStaticMode[i] = g_iPlayerStaticMode[client][i];
		g_PlayerSeesSlender[client][i] = false;
		g_iPlayerStaticMode[client][i] = Static_None;
		
		if (NPCGetUniqueID(i) == -1) continue;
		
		NPCGetProfile(i, profile, sizeof(profile));
		
		int iBoss = NPCGetEntIndex(i);
		
		if (iBoss && iBoss != INVALID_ENT_REFERENCE)
		{
			SlenderGetAbsOrigin(i, flSlenderPos);
			NPCGetEyePosition(i, flSlenderEyePos);
			
			float flSlenderMins[3], flSlenderMaxs[3];
			GetEntPropVector(iBoss, Prop_Send, "m_vecMins", flSlenderMins);
			GetEntPropVector(iBoss, Prop_Send, "m_vecMaxs", flSlenderMaxs);
			
			for (int i2 = 0; i2 < 3; i2++) flSlenderOBBCenterPos[i2] = flSlenderPos[i2] + ((flSlenderMins[i2] + flSlenderMaxs[i2]) / 2.0);
		}
		
		if (IsClientInGhostMode(client))
		{
		}
		else if (!IsClientInDeathCam(client))
		{
			if (iBoss && iBoss != INVALID_ENT_REFERENCE)
			{
				int copyMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);
				
				if (!IsPointVisibleToPlayer(client, flSlenderEyePos, true, SlenderUsesBlink(i)))
				{
					g_PlayerSeesSlender[client][i] = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, true, SlenderUsesBlink(i));
				}
				else
				{
					g_PlayerSeesSlender[client][i] = true;
				}
				
				if ((GetGameTime() - g_flPlayerSeesSlenderLastTime[client][i]) > g_SlenderStaticGraceTime[i][difficulty] ||
					(iOldStaticMode[i] == Static_Increase && g_PlayerStaticAmount[client] > 0.1))
				{
					if ((NPCGetFlags(i) & SFF_STATICONLOOK) && 
						g_PlayerSeesSlender[client][i])
					{
						if (copyMaster != -1)
						{
							g_iPlayerStaticMode[client][copyMaster] = Static_Increase;
						}
						else
						{
							g_iPlayerStaticMode[client][i] = Static_Increase;
						}
					}
					else if ((NPCGetFlags(i) & SFF_STATICONRADIUS) && 
						GetVectorSquareMagnitude(flMyPos, flSlenderPos) <= SquareFloat(g_SlenderStaticRadius[i][difficulty]))
					{
						bool bNoObstacles = IsPointVisibleToPlayer(client, flSlenderEyePos, false, false);
						if (!bNoObstacles) bNoObstacles = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, false, false);
						
						if (bNoObstacles)
						{
							if (copyMaster != -1)
							{
								g_iPlayerStaticMode[client][copyMaster] = Static_Increase;
							}
							else
							{
								g_iPlayerStaticMode[client][i] = Static_Increase;
							}
						}
					}
				}
				
				// Process death cam sequence conditions
				if (SlenderKillsOnNear(i))
				{
					if (g_PlayerStaticAmount[client] >= 1.0 ||
						(GetVectorSquareMagnitude(flMyPos, flSlenderPos) <= SquareFloat(NPCGetInstantKillRadius(i)) && (GetGameTime() - g_SlenderLastKill[i]) >= NPCGetInstantKillCooldown(i, difficulty))
						&& !g_SlenderInDeathcam[i])
					{
						bool bKillPlayer = true;
						if (g_PlayerStaticAmount[client] < 1.0)
						{
							bKillPlayer = IsPointVisibleToPlayer(client, flSlenderEyePos, false, SlenderUsesBlink(i));
						}
						
						if (!bKillPlayer) bKillPlayer = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, false, SlenderUsesBlink(i));
						
						if (bKillPlayer)
						{
							g_SlenderLastKill[i] = GetGameTime();
							
							if (g_PlayerStaticAmount[client] >= 1.0)
							{
								ClientStartDeathCam(client, NPCGetFromUniqueID(g_PlayerStaticMaster[client]), flSlenderPos, true);
							}
							else
							{
								ClientStartDeathCam(client, i, flSlenderPos);
							}
						}
					}
				}
			}
		}
		
		int iMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);
		if (iMaster == -1) iMaster = i;

		NPCGetProfile(iMaster, sMasterProfile, sizeof(sMasterProfile));
		
		// Boss visiblity.
		if (g_PlayerSeesSlender[client][i] && !bWasSeeingSlender[i])
		{
			g_flPlayerSeesSlenderLastTime[client][iMaster] = GetGameTime();
			
			if (GetGameTime() >= g_flPlayerScareNextTime[client][iMaster])
			{
				g_PlayerScaredByBoss[client][iMaster] = false;
				if (GetVectorSquareMagnitude(flMyPos, flSlenderPos) <= SquareFloat(NPCGetScareRadius(i)))
				{
					ClientPerformScare(client, iMaster);

					if (NPCGetSpeedBoostOnScare(iMaster))
					{
						TF2_AddCondition(client, TFCond_SpeedBuffAlly, NPCGetScareSpeedBoostDuration(iMaster), client);
					}

					if (NPCGetScareReactionState(iMaster))
					{
						switch (NPCGetScareReactionType(iMaster))
						{
							case 1: SpeakResponseConcept(client, "TLK_PLAYER_SPELL_METEOR_SWARM");
							case 2: SpeakResponseConcept(client, "HalloweenLongFall");
							case 3:
							{
								char sScareReactionCustom[PLATFORM_MAX_PATH];
								GetProfileString(sMasterProfile, "scare_player_reaction_response_custom", sScareReactionCustom, sizeof(sScareReactionCustom));
								SpeakResponseConcept(client, sScareReactionCustom);
							}
						}
					}

					if (NPCGetScareReplenishSprintState(iMaster))
					{
						int iClientSprintPoints = ClientGetSprintPoints(client);
						g_PlayerSprintPoints[client] = iClientSprintPoints + NPCGetScareReplenishSprintAmount(iMaster);
					}
					
					if (NPCHasAttribute(iMaster, "ignite player on scare"))
					{
						float flValue = NPCGetAttributeValue(iMaster, "ignite player on scare");
						if (flValue > 0.0) TF2_IgnitePlayer(client, client);
					}
					if (NPCHasAttribute(iMaster, "mark player for death on scare"))
					{
						float flValue = NPCGetAttributeValue(iMaster, "mark player for death on scare");
						if (flValue > 0.0) TF2_AddCondition(client, TFCond_MarkedForDeath, flValue);
					}
					if (NPCHasAttribute(iMaster, "silent mark player for death on scare"))
					{
						float flValue = NPCGetAttributeValue(iMaster, "silent mark player for death on scare");
						if (flValue > 0.0) TF2_AddCondition(client, TFCond_MarkedForDeathSilent, flValue);
					}
					if (NPCHasAttribute(iMaster, "chase target on scare"))
					{
						if (g_SlenderState[i] != STATE_CHASE && g_SlenderState[i] != STATE_ATTACK && g_SlenderState[i] != STATE_STUN)
						{
							int slender = NPCGetEntIndex(i);
							g_NpcPlayerScareVictin[i] = EntIndexToEntRef(client);
							g_SlenderState[i] = STATE_CHASE;
							GetClientAbsOrigin(client, g_SlenderGoalPos[i]);
							g_SlenderTarget[i] = EntIndexToEntRef(client);
							g_SlenderTimeUntilNoPersistence[i] = GetGameTime() + NPCChaserGetChaseDuration(i, difficulty);
							g_SlenderTimeUntilAlert[i] = GetGameTime() + NPCChaserGetChaseDuration(i, difficulty);
							SlenderPerformVoice(i, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(i) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
							if (NPCChaserCanUseChaseInitialAnimation(i) && !g_NpcUsesChaseInitialAnimation[i] && !SF_IsSlaughterRunMap())
							{
								if (g_SlenderChaseInitialTimer[i] == null)
								{
									CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
									g_NpcUsesChaseInitialAnimation[i] = true;
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									NPCChaserUpdateBossAnimation(i, slender, g_SlenderState[i]);
									g_SlenderChaseInitialTimer[i] = CreateTimer(GetProfileFloat(profile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
								}
							}
							else
							{
								if (i != -1 && slender && slender != INVALID_ENT_REFERENCE)
									NPCChaserUpdateBossAnimation(i, slender, g_SlenderState[i]);
							}
							g_PlayerScaredByBoss[client][i] = true;
							SlenderAlertAllValidBosses(i, client, client);
						}
					}
					if (NPCGetJumpscareOnScare(iMaster))
					{
						float flJumpScareDuration = NPCGetJumpscareDuration(iMaster, difficulty);
						ClientDoJumpScare(client, iMaster, flJumpScareDuration);
					}
				}
				else
				{
					g_flPlayerScareNextTime[client][iMaster] = GetGameTime() + NPCGetScareCooldown(iMaster);
				}
			}
			
			if (NPCGetType(i) == SF2BossType_Static)
			{
				if (NPCGetFlags(i) & SFF_FAKE)
				{
					SlenderMarkAsFake(i);
					return;
				}
			}
			
			Call_StartForward(g_OnClientLooksAtBossFwd);
			Call_PushCell(client);
			Call_PushCell(i);
			Call_Finish();
		}
		else if (!g_PlayerSeesSlender[client][i] && bWasSeeingSlender[i])
		{
			g_flPlayerScareLastTime[client][iMaster] = GetGameTime();
			
			Call_StartForward(g_OnClientLooksAwayFromBossFwd);
			Call_PushCell(client);
			Call_PushCell(i);
			Call_Finish();
		}
		
		if (g_PlayerSeesSlender[client][i])
		{
			if (GetGameTime() >= g_flPlayerSightSoundNextTime[client][iMaster])
			{
				ClientPerformSightSound(client, i);
			}
		}
		
		if (g_iPlayerStaticMode[client][i] == Static_Increase &&
			iOldStaticMode[i] != Static_Increase)
		{
			if (NPCGetFlags(i) & SFF_HASSTATICLOOPLOCALSOUND)
			{
				char sLoopSound[PLATFORM_MAX_PATH];
				GetRandomStringFromProfile(profile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
				
				if (sLoopSound[0] != '\0')
				{
					EmitSoundToClient(client, sLoopSound, iBoss, SNDCHAN_STATIC, GetProfileNum(profile, "sound_static_loop_local_level", SNDLEVEL_NORMAL), SND_CHANGEVOL, 1.0);
					ClientAddStress(client, 0.03);
				}
			}
		}
		else if (g_iPlayerStaticMode[client][i] != Static_Increase &&
			iOldStaticMode[i] == Static_Increase)
		{
			if (NPCGetFlags(i) & SFF_HASSTATICLOOPLOCALSOUND)
			{
				if (iBoss && iBoss != INVALID_ENT_REFERENCE)
				{
					char sLoopSound[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(profile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
					
					if (sLoopSound[0] != '\0')
					{
						EmitSoundToClient(client, sLoopSound, iBoss, SNDCHAN_STATIC, _, SND_CHANGEVOL | SND_STOP, 0.0);
					}
				}
			}
		}
	}
	
	// Initialize static timers.
	int iBossLastStatic = NPCGetFromUniqueID(g_PlayerStaticMaster[client]);
	int iBossNewStatic = -1;
	if (iBossLastStatic != -1 && g_iPlayerStaticMode[client][iBossLastStatic] == Static_Increase)
	{
		iBossNewStatic = iBossLastStatic;
	}
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		int iStaticMode = g_iPlayerStaticMode[client][i];
		
		// Determine new static rates.
		if (iStaticMode != Static_Increase) continue;
		
		if (iBossLastStatic == -1 || 
			g_iPlayerStaticMode[client][iBossLastStatic] != Static_Increase || 
			NPCGetAnger(i) > NPCGetAnger(iBossLastStatic))
		{
			iBossNewStatic = i;
		}
	}
	
	if (iBossNewStatic != -1)
	{
		int copyMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[iBossNewStatic]);
		if (copyMaster != -1)
		{
			iBossNewStatic = copyMaster;
			g_PlayerStaticMaster[client] = NPCGetUniqueID(copyMaster);
		}
		else
		{
			g_PlayerStaticMaster[client] = NPCGetUniqueID(iBossNewStatic);
		}
	}
	else
	{
		g_PlayerStaticMaster[client] = -1;
	}
	
	if (iBossNewStatic != iBossLastStatic)
	{
		if (strcmp(g_PlayerLastStaticSound[client], g_PlayerStaticSound[client], false) != 0)
		{
			// Stop last-last static sound entirely.
			if (g_PlayerLastStaticSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
			}
		}
		
		// Move everything down towards the last arrays.
		if (g_PlayerStaticSound[client][0] != '\0')
		{
			strcopy(g_PlayerLastStaticSound[client], sizeof(g_PlayerLastStaticSound[]), g_PlayerStaticSound[client]);
		}
		
		if (iBossNewStatic == -1)
		{
			// No one is the static master.
			g_PlayerStaticTimer[client] = CreateTimer(g_flPlayerStaticDecreaseRate[client], 
				Timer_ClientDecreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				
			TriggerTimer(g_PlayerStaticTimer[client], true);
		}
		else
		{
			NPCGetProfile(iBossNewStatic, profile, sizeof(profile));
		
			g_PlayerStaticSound[client][0] = '\0';
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_static", sStaticSound, sizeof(sStaticSound), 1);
			
			if (sStaticSound[0] != '\0') 
			{
				strcopy(g_PlayerStaticSound[client], sizeof(g_PlayerStaticSound[]), sStaticSound);
			}
			
			// Cross-fade out the static sounds.
			g_flPlayerLastStaticVolume[client] = g_PlayerStaticAmount[client];
			g_flPlayerLastStaticTime[client] = GetGameTime();
			
			g_hPlayerLastStaticTimer[client] = CreateTimer(0.0, 
				Timer_ClientFadeOutLastStaticSound, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			TriggerTimer(g_hPlayerLastStaticTimer[client], true);
			
			// Start up our own static timer.
			float staticIncreaseRate = (g_SlenderStaticRate[iBossNewStatic][difficulty] - (g_SlenderStaticRate[iBossNewStatic][difficulty] * g_RoundDifficultyModifier)/10);
			float staticDecreaseRate = (g_SlenderStaticRateDecay[iBossNewStatic][difficulty] + (g_SlenderStaticRateDecay[iBossNewStatic][difficulty] * g_RoundDifficultyModifier)/10);
			if (TF2_GetPlayerClass(client) == TFClass_Heavy)
			{
				staticIncreaseRate *= 1.15;
				staticDecreaseRate *= 0.85;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Sniper && g_PlayerSeesSlender[client][iBossNewStatic])
			{
				if (g_PlayerSeesSlender[client][iBossNewStatic])
				{
					staticIncreaseRate *= 1.05;
				}
				else
				{
					staticIncreaseRate *= 0.9;
				}
				staticDecreaseRate *= 0.9;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Engineer)
			{
				staticIncreaseRate *= 0.9;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Scout)
			{
				staticIncreaseRate *= 0.95;
			}
			
			g_flPlayerStaticIncreaseRate[client] = staticIncreaseRate;
			g_flPlayerStaticDecreaseRate[client] = staticDecreaseRate;
			
			g_PlayerStaticTimer[client] = CreateTimer(staticIncreaseRate, 
				Timer_ClientIncreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			TriggerTimer(g_PlayerStaticTimer[client], true);
		}
	}
}

void ClientProcessViewAngles(int client)
{
	if ((!g_PlayerEliminated[client] || g_PlayerProxy[client]) && 
		!DidClientEscape(client) && !SF_IsRaidMap() && !SF_IsBoxingMap())
	{
		// Process view bobbing, if enabled.
		// This code is based on the code in this page: https://developer.valvesoftware.com/wiki/Camera_Bob
		// Many thanks to whomever created it in the first place.
		
		if (IsPlayerAlive(client))
		{
			if (g_PlayerPreferences[client].PlayerPreference_ViewBobbing)
			{
				float flPunchVel[3];
			
				if (!g_bPlayerViewbobSprintEnabled || !IsClientReallySprinting(client))
				{
					if (GetEntityFlags(client) & FL_ONGROUND)
					{
						float flVelocity[3];
						GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", flVelocity);
						float flSpeed = GetVectorLength(flVelocity);
						
						float flPunchIdle[3];
						
						if (flSpeed > 0.0)
						{
							if (flSpeed >= 60.0)
							{
								flPunchIdle[0] = Sine(GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * flSpeed * SF2_PLAYER_VIEWBOB_SCALE_X / 400.0;
								flPunchIdle[1] = Sine(2.0 * GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * flSpeed * SF2_PLAYER_VIEWBOB_SCALE_Y / 400.0;
								flPunchIdle[2] = Sine(1.6 * GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * flSpeed * SF2_PLAYER_VIEWBOB_SCALE_Z / 400.0;
								
								AddVectors(flPunchVel, flPunchIdle, flPunchVel);
							}
							
							// Calculate roll.
							float flForward[3], flVelocityDirection[3];
							GetClientEyeAngles(client, flForward);
							GetVectorAngles(flVelocity, flVelocityDirection);
							
							float flYawDiff = AngleDiff(flForward[1], flVelocityDirection[1]);
							if (FloatAbs(flYawDiff) > 90.0) flYawDiff = AngleDiff(flForward[1] + 180.0, flVelocityDirection[1]) * -1.0;
							
							float flWalkSpeed = ClientGetDefaultWalkSpeed(client);
							float flRollScalar = flSpeed / flWalkSpeed;
							if (flRollScalar > 1.0) flRollScalar = 1.0;
							
							float flRollScale = (flYawDiff / 90.0) * 0.25 * flRollScalar;
							flPunchIdle[0] = 0.0;
							flPunchIdle[1] = 0.0;
							flPunchIdle[2] = flRollScale * -1.0;
							
							AddVectors(flPunchVel, flPunchIdle, flPunchVel);
						}
						
						/*
						if (flSpeed < 60.0) 
						{
							flPunchIdle[0] = FloatAbs(Cosine(GetGameTime() * 1.25) * 0.047);
							flPunchIdle[1] = Sine(GetGameTime() * 1.25) * 0.075;
							flPunchIdle[2] = 0.0;
							
							AddVectors(flPunchVel, flPunchIdle, flPunchVel);
						}
						*/
					}
				}
				
				if (g_bPlayerViewbobHurtEnabled)
				{
					// Shake screen the more the player is hurt.
					float health = float(GetEntProp(client, Prop_Send, "m_iHealth"));
					float flMaxHealth = float(SDKCall(g_hSDKGetMaxHealth, client));
					
					float flPunchVelHurt[3];
					flPunchVelHurt[0] = Sine(1.22 * GetGameTime()) * 48.5 * ((flMaxHealth - health) / (flMaxHealth * 0.75)) / flMaxHealth;
					flPunchVelHurt[1] = Sine(2.12 * GetGameTime()) * 80.0 * ((flMaxHealth - health) / (flMaxHealth * 0.75)) / flMaxHealth;
					flPunchVelHurt[2] = Sine(0.5 * GetGameTime()) * 36.0 * ((flMaxHealth - health) / (flMaxHealth * 0.75)) / flMaxHealth;
					
					AddVectors(flPunchVel, flPunchVelHurt, flPunchVel);
				}
				
				ClientViewPunch(client, flPunchVel);
			}
		}
	}
}

public Action Timer_ClientIncreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerStaticTimer[client]) return Plugin_Stop;
	
	g_PlayerStaticAmount[client] += 0.05;
	if (g_PlayerStaticAmount[client] > 1.0) g_PlayerStaticAmount[client] = 1.0;
	
	if (g_PlayerStaticSound[client][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, g_PlayerStaticAmount[client]);
		
		if (g_PlayerStaticAmount[client] >= 0.5) ClientAddStress(client, 0.03);
		else
		{
			ClientAddStress(client, 0.02);
		}
	}
	
	return Plugin_Continue;
}

public Action Timer_ClientDecreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerStaticTimer[client]) return Plugin_Stop;
	
	g_PlayerStaticAmount[client] -= 0.05;
	if (g_PlayerStaticAmount[client] < 0.0) g_PlayerStaticAmount[client] = 0.0;
	
	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float flVolume = g_PlayerStaticAmount[client];
		if (flVolume > 0.0)
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, flVolume);
		}
	}
	
	if (g_PlayerStaticAmount[client] <= 0.0)
	{
		// I've done my job; no point to keep on doing it.
		if (g_PlayerLastStaticSound[client][0] != '\0') StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
		g_PlayerStaticTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_ClientFadeOutLastStaticSound(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerLastStaticTimer[client]) return Plugin_Stop;
	
	if (strcmp(g_PlayerLastStaticSound[client], g_PlayerStaticSound[client], false) == 0) 
	{
		// Wait, the player's current static sound is the same one we're stopping. Abort!
		g_hPlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}
	
	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float flDiff = (GetGameTime() - g_flPlayerLastStaticTime[client]) / 1.0;
		if (flDiff > 1.0) flDiff = 1.0;
		
		float flVolume = g_flPlayerLastStaticVolume[client] - flDiff;
		if (flVolume < 0.0) flVolume = 0.0;
		
		if (flVolume <= 0.0)
		{
			// I've done my job; no point to keep on doing it.
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
			g_hPlayerLastStaticTimer[client] = null;
			return Plugin_Stop;
		}
		else
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, flVolume);
		}
	}
	else
	{
		// I've done my job; no point to keep on doing it.
		g_hPlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

//	==========================================================
//	SPECIAL ROUND FUNCTIONS
//	==========================================================

void ClientSetSpecialRoundTimer(int client, float flTime, Timer callback, any data, int flags=0)
{
	g_ClientSpecialRoundTimer[client] = CreateTimer(flTime, callback, data, flags);
}

public Action Timer_ClientPageDetector(Handle timer, int userid)
{
	if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR)) return Plugin_Stop;
	if (GetRoundState() == SF2RoundState_Escape) return Plugin_Stop;
	
	int client = GetClientOfUserId(userid);
	if (g_ClientSpecialRoundTimer[client] != timer) return Plugin_Stop;
	
	if (!IsValidClient(client)) return Plugin_Stop;
	
	if (g_PlayerEliminated[client]) return Plugin_Stop;
	
	float flDistance = 99999.0, flClientPos[3], flPagePos[3];
	GetClientAbsOrigin(client, flClientPos);
	
	char sModel[255], targetName[64];
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "*")) != -1)
	{
		if (!IsEntityClassname(ent, "prop_dynamic", false) && !IsEntityClassname(ent, "prop_dynamic_override", false)) continue;
		
		GetEntPropString(ent, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (sModel[0] != '\0')
		{
			if ((strcmp(sModel, g_PageRefModelName) == 0 || strcmp(sModel, PAGE_MODEL) == 0) && StrContains(targetName, "sf2_page_ex", false) != -1)
			{
				GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPagePos);
				if (GetVectorDistance(flClientPos, flPagePos, false) < flDistance)
					flDistance = GetVectorDistance(flClientPos, flPagePos, false);
			}
		}
	}
	float flNextBeepTime = flDistance/800.0;
	
	if (flNextBeepTime > 5.0) flNextBeepTime = 5.0;
	if (flNextBeepTime < 0.1) flNextBeepTime = 0.1;
	
	EmitSoundToClient(client,PAGE_DETECTOR_BEEP, _, _, _, _, _, 100-RoundToNearest(flNextBeepTime*10.0));
	g_ClientSpecialRoundTimer[client] = CreateTimer(flNextBeepTime, Timer_ClientPageDetector, userid, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

//	==========================================================
//	INTERACTIVE GLOW FUNCTIONS
//	==========================================================

void ClientProcessInteractiveGlow(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || (g_PlayerEliminated[client] && !g_PlayerProxy[client]) || IsClientInGhostMode(client)) return;
	
	int iOldLookEntity = EntRefToEntIndex(g_PlayerInteractiveGlowTargetEntity[client]);
	
	float startPos[3], flMyEyeAng[3];
	GetClientEyePosition(client, startPos);
	GetClientEyeAngles(client, flMyEyeAng);
	
	Handle hTrace = TR_TraceRayFilterEx(startPos, flMyEyeAng, MASK_VISIBLE, RayType_Infinite, TraceRayDontHitPlayers, -1);
	int iEnt = TR_GetEntityIndex(hTrace);
	delete hTrace;
	
	if (IsValidEntity(iEnt))
	{
		g_PlayerInteractiveGlowTargetEntity[client] = EntRefToEntIndex(iEnt);
	}
	else
	{
		g_PlayerInteractiveGlowTargetEntity[client] = INVALID_ENT_REFERENCE;
	}
	
	if (iEnt != iOldLookEntity)
	{
		ClientRemoveInteractiveGlow(client);
		
		if (IsEntityClassname(iEnt, "prop_dynamic", false) || IsEntityClassname(iEnt, "tf_taunt_prop", false))
		{
			char sTargetName[64];
			GetEntPropString(iEnt, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
			
			if (StrContains(sTargetName, "sf2_page", false) == 0 || StrContains(sTargetName, "sf2_interact", false) == 0)
			{
				ClientCreateInteractiveGlow(client, iEnt);
			}
		}
	}
}

void ClientResetInteractiveGlow(int client)
{
	ClientRemoveInteractiveGlow(client);
	g_PlayerInteractiveGlowTargetEntity[client] = INVALID_ENT_REFERENCE;
}

/**
 *	Removes the player's current interactive glow entity.
 */
void ClientRemoveInteractiveGlow(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientRemoveInteractiveGlow(%d)", client);
#endif

	int ent = EntRefToEntIndex(g_PlayerInteractiveGlowEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}
	
	g_PlayerInteractiveGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientRemoveInteractiveGlow(%d)", client);
#endif
}

/**
 *	Creates an interactive glow for an entity to show to a player.
 */
bool ClientCreateInteractiveGlow(int client,int iEnt, const char[] sAttachment="")
{
	ClientRemoveInteractiveGlow(client);
	
	if (!IsClientInGame(client)) return false;
	
	if (!iEnt || !IsValidEdict(iEnt)) return false;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientCreateInteractiveGlow(%d)", client);
#endif
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetEntPropString(iEnt, Prop_Data, "m_ModelName", sBuffer, sizeof(sBuffer));
	
	if (sBuffer[0] == '\0') 
	{
		return false;
	}
	
	int ent = CreateEntityByName("tf_taunt_prop");
	if (ent != -1)
	{
		g_PlayerInteractiveGlowEntity[client] = EntIndexToEntRef(ent);
		
		float flModelScale = GetEntPropFloat(iEnt, Prop_Send, "m_flModelScale");
		
		SetEntityModel(ent, sBuffer);
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		SetEntityRenderColor(ent, 0, 0, 0, 0);
		SetEntPropFloat(ent, Prop_Send, "m_flModelScale", flModelScale);
		
		int iFlags = GetEntProp(ent, Prop_Send, "m_fEffects");
		SetEntProp(ent, Prop_Send, "m_fEffects", iFlags | (1 << 0));
		SetEntProp(ent, Prop_Send, "m_bGlowEnabled", true);
		
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", iEnt);
		
		if (sAttachment[0] != '\0')
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(ent, "SetParentAttachment");
		}
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_InterativeGlowSetTransmit);
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> false", client);
#endif
	
	return false;
}

public Action Hook_InterativeGlowSetTransmit(int ent,int other)
{
	if (!g_Enabled) return Plugin_Continue;

	if (EntRefToEntIndex(g_PlayerInteractiveGlowEntity[other]) != ent) return Plugin_Handled;
	
	return Plugin_Continue;
}

//	==========================================================
//	BREATHING FUNCTIONS
//	==========================================================

void ClientResetBreathing(int client)
{
	g_PlayerBreath[client] = false;
	g_PlayerBreathTimer[client] = null;
}

float ClientCalculateBreathingCooldown(int client)
{
	float flAverage = 0.0;
	int iAverageNum = 0;
	
	// Sprinting only, for now.
	flAverage += (SF2_PLAYER_BREATH_COOLDOWN_MAX * 6.7765 * Pow((float(g_PlayerSprintPoints[client]) / 100.0), 1.65));
	iAverageNum++;
	
	flAverage /= float(iAverageNum);
	
	if (flAverage < SF2_PLAYER_BREATH_COOLDOWN_MIN) flAverage = SF2_PLAYER_BREATH_COOLDOWN_MIN;
	
	return flAverage;
}

void ClientStartBreathing(int client)
{
	g_PlayerBreath[client] = true;
	g_PlayerBreathTimer[client] = CreateTimer(ClientCalculateBreathingCooldown(client), Timer_ClientBreath, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStopBreathing(int client)
{
	g_PlayerBreath[client] = false;
	g_PlayerBreathTimer[client] = null;
}

bool ClientCanBreath(int client)
{
	return view_as<bool>(ClientCalculateBreathingCooldown(client) < SF2_PLAYER_BREATH_COOLDOWN_MAX);
}

public Action Timer_ClientBreath(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerBreathTimer[client]) return Plugin_Stop;
	
	if (!g_PlayerBreath[client]) return Plugin_Stop;
	
	if (ClientCanBreath(client))
	{
		EmitSoundToAll(g_strPlayerBreathSounds[GetRandomInt(0, sizeof(g_strPlayerBreathSounds) - 1)], client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		
		ClientStartBreathing(client);
		return Plugin_Stop;
	}
	
	ClientStopBreathing(client);

	return Plugin_Stop;
}

//	==========================================================
//	SPRINTING FUNCTIONS
//	==========================================================

bool IsClientSprinting(int client)
{
	return g_PlayerSprint[client];
}

int ClientGetSprintPoints(int client)
{
	return g_PlayerSprintPoints[client];
}

void ClientResetSprint(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetSprint(%d)", client);
#endif

	bool bWasSprinting = IsClientSprinting(client);

	g_PlayerSprint[client] = false;
	g_PlayerSprintPoints[client] = 100;
	g_PlayerSprintTimer[client] = null;
	
	if (IsValidClient(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		
		ClientSetFOV(client, g_PlayerDesiredFOV[client]);
	}
	
	if (bWasSprinting)
	{
		Call_StartForward(g_OnClientStopSprintingFwd);
		Call_PushCell(client);
		Call_Finish();
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetSprint(%d)", client);
#endif
}

void ClientStartSprint(int client)
{
	if (IsClientSprinting(client)) return;
	
	g_PlayerSprint[client] = true;
	g_PlayerSprintTimer[client] = null;
	ClientSprintTimer(client);
	TriggerTimer(g_PlayerSprintTimer[client], true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || g_Renevant90sEffect)
	{
		Client90sMusicStart(client);
	}
	
	SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	
	Call_StartForward(g_OnClientStartSprintingFwd);
	Call_PushCell(client);
	Call_Finish();
}

void ClientSprintTimer(int client, bool bRecharge=false)
{
	float flRate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 0.38 : 0.28;
	if (bRecharge) flRate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 1.4 : 0.8;
	
	float flVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", flVelocity);
	
	if (bRecharge)
	{
		if (!(GetEntityFlags(client) & FL_ONGROUND)) flRate *= 0.75;
		else if (GetVectorLength(flVelocity, true) == 0.0)
		{
			if (GetEntProp(client, Prop_Send, "m_bDucked")) flRate *= 0.66;
			else flRate *= 0.75;
		}
	}
	else
	{
		if (TF2_GetPlayerClass(client) == TFClass_DemoMan) flRate *= 1.16;
		else if (TF2_GetPlayerClass(client) == TFClass_Medic || TF2_GetPlayerClass(client) == TFClass_Spy || TF2_GetPlayerClass(client)) flRate *= 1.05;
	}
	
	if (bRecharge) g_PlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientRechargeSprint, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	else g_PlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientSprinting, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStopSprint(int client)
{
	if (!IsClientSprinting(client)) return;
	g_PlayerSprint[client] = false;
	g_PlayerSprintTimer[client] = null;
	ClientSprintTimer(client, true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || g_Renevant90sEffect)
	{
		Client90sMusicStop(client);
	}
	
	SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	
	Call_StartForward(g_OnClientStopSprintingFwd);
	Call_PushCell(client);
	Call_Finish();
}

bool IsClientReallySprinting(int client)
{
	if (!IsClientSprinting(client)) return false;
	if (!(GetEntityFlags(client) & FL_ONGROUND)) return false;
	
	float flVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", flVelocity);
	if (GetVectorLength(flVelocity, true) < SquareFloat(30.0)) return false;
	
	return true;
}

//	==========================================================
//	GHOST AND GLOW FUNCTIONS
//	==========================================================

public Action Timer_ClassScramblePlayer(Handle timer, any userid)
{
	if (!g_Enabled) return Plugin_Stop;

	int client = GetClientOfUserId(userid);

	if (client <= 0 || DidClientEscape(client) || g_PlayerEliminated[client] || !IsPlayerAlive(client) || IsClientInGhostMode(client) || g_PlayerProxy[client]) return Plugin_Stop;
	g_PlayerRandomClassNumber[client] = GetRandomInt(1, 9);

	// Regenerate player but keep health the same.
	int iHealth = GetEntProp(client, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(client);
	SetEntProp(client, Prop_Data, "m_iHealth", iHealth);
	SetEntProp(client, Prop_Send, "m_iHealth", iHealth);

	return Plugin_Stop;
}
public Action Timer_ClassScramblePlayer2(Handle timer, any userid)
{
	if (!g_Enabled) return Plugin_Stop;

	int client = GetClientOfUserId(userid);

	if (client <= 0 || DidClientEscape(client) || g_PlayerEliminated[client] || !IsPlayerAlive(client) || IsClientInGhostMode(client) || g_PlayerProxy[client]) return Plugin_Stop;

	// Regenerate player but keep health the same.
	int iHealth = GetEntProp(client, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(client);
	SetEntProp(client, Prop_Data, "m_iHealth", iHealth);
	SetEntProp(client, Prop_Send, "m_iHealth", iHealth);

	return Plugin_Stop;
}

bool DoesClientHaveConstantGlow(int client)
{
	return g_PlayerConstantGlowEnabled[client];
}

void ClientDisableConstantGlow(int client)
{
	if (!DoesClientHaveConstantGlow(client)) return;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientDisableConstantGlow(%d)", client);
#endif
	
	g_PlayerConstantGlowEnabled[client] = false;
	
	int iGlow = EntRefToEntIndex(g_PlayerConstantGlowEntity[client]);
	if (iGlow && iGlow != INVALID_ENT_REFERENCE) 
	{
		int iGlowManager = GetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity");
		RemoveEntity(iGlow);
		if (iGlowManager > MaxClients)
		{
			RemoveEntity(iGlowManager);
		}
	}
	
	g_PlayerConstantGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientDisableConstantGlow(%d)", client);
#endif
}

bool ClientEnableConstantGlow(int client, const char[] sAttachment="", int iColor[4] = {255, 255, 255, 255})
{
	if (DoesClientHaveConstantGlow(client)) return true;
	
	/*if (g_ClientGlowTimer[client] == null)
	{
		g_ClientGlowTimer[client] = CreateTimer(0.5, Timer_UpdateClientGlow, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		GetEntPropString(client, Prop_Data, "m_ModelName", g_OldClientModel[client], sizeof(g_OldClientModel[]));
	}*/
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientEnableConstantGlow(%d)", client);
#endif
	
	char sModel[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
	
	if (sModel[0] == '\0') 
	{
		// For some reason the model couldn't be found, so no.
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false (no model specified)", client);
#endif
		
		return false;
	}
	
	int iGlow = CreateEntityByName("tf_taunt_prop");
	if (iGlow != -1)
	{
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("tf_taunt_prop -> created");
#endif
	
		g_PlayerConstantGlowEnabled[client] = true;
		g_PlayerConstantGlowEntity[client] = EntIndexToEntRef(iGlow);

#if defined DEBUG
		float flModelScale = GetEntPropFloat(client, Prop_Send, "m_flModelScale");
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("tf_taunt_prop -> get model and model scale (%s, %f, player class: %d)", sModel, flModelScale, TF2_GetPlayerClass(client));
		}
#endif
		
		SetEntityModel(iGlow, sModel);
		DispatchSpawn(iGlow);
		ActivateEntity(iGlow);
		SetEntityRenderMode(iGlow, RENDER_TRANSCOLOR);
		SetEntityRenderColor(iGlow, 0, 0, 0, 0);
		int iGlowManager = TF2_CreateGlow(iGlow);
		g_hSDKShouldTransmit.HookEntity(Hook_Pre, iGlowManager, Hook_EntityShouldTransmit);
		g_hSDKShouldTransmit.HookEntity(Hook_Pre, iGlow, Hook_EntityShouldTransmit);
		//Set our desired glow color
		SetVariantColor(iColor);
		AcceptEntityInput(iGlowManager, "SetGlowColor");
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("tf_taunt_prop -> set model and model scale");
#endif
		
		// Set effect flags.
		int iFlags = GetEntProp(iGlow, Prop_Send, "m_fEffects");
		SetEntProp(iGlow, Prop_Send, "m_fEffects", iFlags | (1 << 0)); // EF_BONEMERGE
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("tf_taunt_prop -> set bonemerge flags");
#endif
		
		SetVariantString("!activator");
		AcceptEntityInput(iGlow, "SetParent", client);
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("tf_taunt_prop -> set parent to client");
#endif
		
		if (sAttachment[0] != '\0')
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(iGlow, "SetParentAttachment");
		}
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("tf_taunt_prop -> set parent attachment to %s", sAttachment);
#endif
		
		SetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity", iGlowManager);
		
		Network_HookEntity(iGlow);
		SDKHook(iGlow, SDKHook_SetTransmit, Hook_ConstantGlowSetTransmitVersion2);
		
#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false", client);
#endif
	
	return false;
}

public Action Timer_UpdateClientGlow(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0 || client > MaxClients)
	{
		for (int i = 1; i <= MaxClients; i++)//Find the previous client index owning that timer and reset it. 
		{
			if (g_ClientGlowTimer[i] == timer)
			{
				g_ClientGlowTimer[i] = null;
				break;
			}
		}
		return Plugin_Stop;
	}
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || !DoesClientHaveConstantGlow(client))
	{
		g_ClientGlowTimer[client] = null;
		return Plugin_Stop;
	}
	
	char sClientModel[128];
	GetEntPropString(client, Prop_Data, "m_ModelName", sClientModel, sizeof(sClientModel));
	
	if (strcmp(sClientModel, g_OldClientModel[client]) != 0)
	{
		ClientDisableConstantGlow(client);
		ClientEnableConstantGlow(client);
		strcopy(g_OldClientModel[client], sizeof(g_OldClientModel[]), sClientModel);
	}
	return Plugin_Continue;
}

public bool ClientGlowFilter(int client)
{
	if (g_PlayerEliminated[client])
		return false;
	return true;
}

void ClientResetJumpScare(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetJumpScare(%d)", client);
#endif

	g_PlayerJumpScareBoss[client] = -1;
	g_PlayerJumpScareLifeTime[client] = -1.0;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetJumpScare(%d)", client);
#endif
}

void ClientDoJumpScare(int client,int bossIndex, float flLifeTime)
{
	g_PlayerJumpScareBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerJumpScareLifeTime[client] = GetGameTime() + flLifeTime;
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(profile, "sound_jumpscare", sBuffer, sizeof(sBuffer), 1);
	
	if (sBuffer[0] != '\0')
	{
		EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN);
	}
}

 /**
  *	Handles sprinting upon player input.
  */
void ClientHandleSprint(int client, bool bSprint)
{
	if (!IsPlayerAlive(client) || 
		g_PlayerEliminated[client] || 
		DidClientEscape(client) || 
		g_PlayerProxy[client] || 
		IsClientInGhostMode(client)) return;
	
	if (bSprint)
	{
		if (g_PlayerSprintPoints[client] > 0)
		{
			ClientStartSprint(client);
		}
		else
		{
			EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
		}
	}
	else
	{
		if (IsClientSprinting(client))
		{
			ClientStopSprint(client);
		}
	}
}
/**
  *	Handles thirdperson peeking
  */
bool ClientStartPeeking(int client)
{
	if (!g_PlayerPeeking[client] && g_AllowPlayerPeekingConVar.BoolValue && !TF2_IsPlayerInCondition(client, TFCond_Dazed) && GetClientButtons(client) & IN_DUCK)
	{
		TF2_StunPlayer(client, 999.9, 1.0, TF_STUNFLAGS_LOSERSTATE);
		g_PlayerPeeking[client] = true;
		return true;
	}
	return false;
}
  
void ClientEndPeeking(int client)
{
	if (g_PlayerPeeking[client])
	{
		TF2_RemoveCondition(client, TFCond_Dazed);
		g_PlayerPeeking[client] = false;
	}
}

//	==========================================================
//	DEATH CAM FUNCTIONS
//	==========================================================

bool IsClientInDeathCam(int client)
{
	return g_bPlayerDeathCam[client];
}

public Action Hook_DeathCamSetTransmit(int slender,int other)
{
	if (!g_Enabled) return Plugin_Continue;

	if (EntRefToEntIndex(g_PlayerDeathCamEnt2[other]) != slender) return Plugin_Handled;
	return Plugin_Continue;
}

void ClientResetDeathCam(int client)
{
	if (!IsClientInDeathCam(client)) return; // no really need to reset if it wasn't set.
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetDeathCam(%d)", client);
#endif
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	
	g_iPlayerDeathCamBoss[client] = -1;
	g_bPlayerDeathCam[client] = false;
	g_bPlayerDeathCamShowOverlay[client] = false;
	g_PlayerDeathCamTimer[client] = null;
	
	int ent = EntRefToEntIndex(g_PlayerDeathCamEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		g_CameraInDeathCamAdvanced[ent] = false;
		AcceptEntityInput(ent, "Disable");
		RemoveEntity(ent);
	}
	
	ent = EntRefToEntIndex(g_PlayerDeathCamEnt2[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
	}
	
	ent = EntRefToEntIndex(g_PlayerDeathCamTarget[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}
	
	g_PlayerDeathCamEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamEnt2[client] = INVALID_ENT_REFERENCE;
	g_PlayerDeathCamTarget[client] = INVALID_ENT_REFERENCE;
	
	if (IsClientInGame(client))
	{
		SetClientViewEntity(client, client);
	}
	
	Call_StartForward(g_OnClientEndDeathCamFwd);
	Call_PushCell(client);
	Call_PushCell(iDeathCamBoss);
	Call_Finish();
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetDeathCam(%d)", client);
#endif
}

void ClientStartDeathCam(int client,int bossIndex, const float vecLookPos[3], bool bAnticamp = false)
{
	if (IsClientInDeathCam(client)) return;
	if (!NPCIsValid(bossIndex)) return;

	GetClientAbsOrigin(client, g_vecPlayerOriginalDeathcamPosition[client]);
	
	char buffer[PLATFORM_MAX_PATH];
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	
	if (g_SlenderDeathCamScareSound[bossIndex])
	{
		GetRandomStringFromProfile(profile, "sound_scare_player", buffer, sizeof(buffer));
		if (buffer[0] != '\0') EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	
	GetRandomStringFromProfile(profile, "sound_player_deathcam", buffer, sizeof(buffer));
	if (buffer[0] != '\0') 
	{
		EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death"
		if (g_20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
		{
			GetRandomStringFromProfile(profile, "sound_player_death_20dollars", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
			}
		}
		else
		{
			GetRandomStringFromProfile(profile, "sound_player_death", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
			}
		}
	}
	
	GetRandomStringFromProfile(profile, "sound_player_deathcam_all", buffer, sizeof(buffer));
	if (buffer[0] != '\0') 
	{
		EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death_all"
		GetRandomStringFromProfile(profile, "sound_player_death_all", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
		}
	}

	// Call our forward.
	Call_StartForward(g_OnClientCaughtByBossFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();
	
	if (!NPCHasDeathCamEnabled(bossIndex) && !(NPCGetFlags(bossIndex) & SFF_FAKE))
	{
		SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol changes our lifestate.
		
		// TODO: Add more attributes!
		if (NPCHasAttribute(bossIndex, "ignite player on death"))
		{
			float flValue = NPCGetAttributeValue(bossIndex, "ignite player on death");
			if (flValue > 0.0) TF2_IgnitePlayer(client, client);
		}
	
		int iSlender = NPCGetEntIndex(bossIndex);
		if (iSlender > MaxClients) SDKHooks_TakeDamage(client, iSlender, iSlender, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
		KillClient(client);
		return;
	}
	else if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
	}
	
	g_iPlayerDeathCamBoss[client] = NPCGetUniqueID(bossIndex);
	g_bPlayerDeathCam[client] = true;
	g_bPlayerDeathCamShowOverlay[client] = false;
	
	float eyePos[3], eyeAng[3], vecAng[3];
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);
	SubtractVectors(eyePos, vecLookPos, vecAng);
	GetVectorAngles(vecAng, vecAng);
	vecAng[0] = 0.0;
	vecAng[2] = 0.0;
	
	// Create fake model.
	int slender = SpawnSlenderModel(bossIndex, vecLookPos, true);
	TeleportEntity(slender, vecLookPos, vecAng, NULL_VECTOR);
	g_PlayerDeathCamEnt2[client] = EntIndexToEntRef(slender);
	if (!g_SlenderPublicDeathCam[bossIndex])
	{
		SDKHook(slender, SDKHook_SetTransmit, Hook_DeathCamSetTransmit);
	}
	else
	{
		GetRandomStringFromProfile(profile, "sound_player_deathcam_local", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
		}
		else
		{
			// Legacy support for "sound_player_death_local" cause why not 
			GetRandomStringFromProfile(profile, "sound_player_death_local", buffer, sizeof(buffer));
			if (buffer[0] != '\0') 
			{
				EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
			}
		}
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		if (!bAnticamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderInDeathcam[bossIndex] = true;
				SetEntityRenderMode(slenderEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slenderEnt, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
				NPCChaserUpdateBossAnimation(bossIndex, slenderEnt, STATE_DEATHCAM);
				g_SlenderDeathCamTarget[bossIndex] = EntIndexToEntRef(client);
				g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderPublicDeathCamThink, EntIndexToEntRef(slenderEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	
	// Create camera look point.
	char name[64];
	FormatEx(name, sizeof(name), "sf2_boss_%d", EntIndexToEntRef(slender));
	
	float flOffsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!g_SlenderPublicDeathCam[bossIndex])
	{
		GetProfileVector(profile, "death_cam_pos", flOffsetPos);
		AddVectors(vecLookPos, flOffsetPos, flOffsetPos);
		TeleportEntity(target, flOffsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
	}
	else
	{
		char sBoneName[PLATFORM_MAX_PATH];
		AddVectors(vecLookPos, flOffsetPos, flOffsetPos);
		TeleportEntity(target, flOffsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
		GetProfileString(profile, "death_cam_attachtment_target_point", sBoneName, sizeof(sBoneName));
		if (sBoneName[0] != '\0')
		{
			SetVariantString(sBoneName);
			AcceptEntityInput(target, "SetParentAttachment");
		}
	}
	g_PlayerDeathCamTarget[client] = EntIndexToEntRef(target);
	
	// Create the camera itself.
	int camera = CreateEntityByName("point_viewcontrol");
	TeleportEntity(camera, eyePos, eyeAng, NULL_VECTOR);
	DispatchKeyValue(camera, "spawnflags", "12");
	DispatchKeyValue(camera, "target", name);
	DispatchSpawn(camera);
	AcceptEntityInput(camera, "Enable", client);
	g_PlayerDeathCamEnt[client] = EntIndexToEntRef(camera);
	if (g_SlenderPublicDeathCam[bossIndex])
	{
		float flCamSpeed, flCamAcceleration, flCamDeceleration;
		char sBuffer[PLATFORM_MAX_PATH];
		
		flCamSpeed = g_SlenderPublicDeathCamSpeed[bossIndex];
		flCamAcceleration = g_SlenderPublicDeathCamAcceleration[bossIndex];
		flCamDeceleration = g_SlenderPublicDeathCamDeceleration[bossIndex];
		FloatToString(flCamSpeed, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "acceleration", sBuffer);
		FloatToString(flCamAcceleration, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "deceleration", sBuffer);
		FloatToString(flCamDeceleration, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "speed", sBuffer);
		
		SetVariantString("!activator");
		AcceptEntityInput(camera, "SetParent", slender);
		char sAttachmentName[PLATFORM_MAX_PATH];
		GetProfileString(profile, "death_cam_attachtment_point", sAttachmentName, sizeof(sAttachmentName));
		if (sAttachmentName[0] != '\0')
		{
			SetVariantString(sAttachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}
		
		g_CameraInDeathCamAdvanced[camera] = true;
		g_CameraPlayerOffsetBackward[camera] = g_SlenderPublicDeathCamBackwardOffset[bossIndex];
		g_CameraPlayerOffsetDownward[camera] = g_SlenderPublicDeathCamDownwardOffset[bossIndex];
	}
	
	if (g_SlenderDeathCamOverlay[bossIndex] && g_SlenderDeathCamOverlayTimeStart[bossIndex] >= 0.0)
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !bAnticamp) 
		{
			int iSlender = NPCGetEntIndex(bossIndex);
			if (iSlender && iSlender != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_BossDeathCamDelay, EntIndexToEntRef(iSlender), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_ClientResetDeathCam1, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !bAnticamp) 
		{
			int iSlender = NPCGetEntIndex(bossIndex);
			if (iSlender && iSlender != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_BossDeathCamDuration, EntIndexToEntRef(iSlender), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_ClientResetDeathCamEnd, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
	
	Call_StartForward(g_OnClientStartDeathCamFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();
}

public Action Timer_ClientResetDeathCam1(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerDeathCamTimer[client]) return Plugin_Stop;
	
	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]));

	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	if (Npc.IsValid())
	{
		g_bPlayerDeathCamShowOverlay[client] = true;
		Npc.GetProfile(profile, sizeof(profile));
		GetRandomStringFromProfile(profile, "sound_player_deathcam_overlay", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamTime[Npc.Index], Timer_ClientResetDeathCamEnd, userid, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

public Action Timer_BossDeathCamDelay(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int bossIndex = NPCGetFromEntIndex(slender);
	
	if (timer != g_SlenderDeathCamTimer[bossIndex]) return Plugin_Stop;
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_BossDeathCamDuration, slender, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

public Action Timer_BossDeathCamDuration(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int bossIndex = NPCGetFromEntIndex(slender);

	if (timer != g_SlenderDeathCamTimer[bossIndex]) return Plugin_Stop;

	if (g_SlenderInDeathcam[bossIndex])
	{
		SetEntityRenderMode(slender, RENDER_NORMAL);
		if (!NPCChaserIsCloaked(bossIndex)) SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
		g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (!(NPCGetFlags(bossIndex) & SFF_FAKE)) g_SlenderInDeathcam[bossIndex] = false;
		NPCChaserUpdateBossAnimation(bossIndex, slender, g_SlenderState[bossIndex]);
	}
	if ((NPCGetFlags(bossIndex) & SFF_FAKE))
	{
		if (g_SlenderInDeathcam[bossIndex])
		{
			g_SlenderInDeathcam[bossIndex] = false;
		}
		SlenderMarkAsFake(bossIndex);
	}
	g_SlenderDeathCamTimer[bossIndex] = null;

	return Plugin_Stop;
}

public Action Timer_ClientResetDeathCamEnd(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerDeathCamTimer[client]) return Plugin_Stop;
	
	SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol entity changes our damage state.
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	if (iDeathCamBoss != -1)
	{
		if (NPCHasAttribute(iDeathCamBoss, "ignite player on death"))
		{
			float flValue = NPCGetAttributeValue(iDeathCamBoss, "ignite player on death");
			if (flValue > 0.0) TF2_IgnitePlayer(client, client);
		}
		if (!(NPCGetFlags(iDeathCamBoss) & SFF_FAKE))
		{
			int iSlender = NPCGetEntIndex(iDeathCamBoss);
			if (iSlender > MaxClients) SDKHooks_TakeDamage(client, iSlender, iSlender, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
			SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
			ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
			KillClient(client);
		}
		else
		{
			SetEntityMoveType(client, MOVETYPE_WALK);
			TeleportEntity(client, g_vecPlayerOriginalDeathcamPosition[client], NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
		}
	}
	else//The boss is invalid? But the player got a death cam?
	{
		//Then kill him anyways.
		KillClient(client);
		ForcePlayerSuicide(client);
	}
	ClientResetDeathCam(client);

	return Plugin_Stop;
}
//	==========================================================
//	NAV AREA FUNCTIONS
//	==========================================================
/*void ClientNavAreaUpdate(int client, CNavArea newArea, CNavArea oldArea)
{
	if (GetRoundState() != SF2RoundState_Active) return;
	
	if (g_PlayerEliminated[client]) return;
	
	if (newArea == INVALID_NAV_AREA) return;
	
	if ((oldArea != INVALID_NAV_AREA && oldArea.Attributes & NAV_MESH_DONT_HIDE) || newArea.Attributes & NAV_MESH_DONT_HIDE)
	{
		g_ClientAllowedTimeNearEscape[client] -= 0.3;//Remove 0.3sec this function is called every ~0.3sec
	}
	else
	{
		g_ClientAllowedTimeNearEscape[client] += 0.1;//Forgive the player of 0.1
	}
	if (g_ClientAllowedTimeNearEscape[client] <= 0.0 && SF_IsSurvivalMap())
	{
		g_PlayerIsExitCamping[client] = true;
	}
	else
	{
		g_PlayerIsExitCamping[client] = false;
	}
#if defined DEBUG
	SendDebugMessageToPlayer(client, DEBUG_NAV, 1, "Old area: %i DHF:%s, New area: %i DHF:%s, is considered as exit camper: %s", oldArea.Index, (oldArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", newArea.Index, (newArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", (g_PlayerIsExitCamping[client]) ? "true" : "false" );
#endif
}*/

//	==========================================================
//	GHOST MODE FUNCTIONS
//	==========================================================

static bool g_bPlayerGhostMode[MAXPLAYERS + 1] = { false, ... };
static int g_iPlayerGhostModeTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerGhostModeBossTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
Handle g_PlayerGhostModeConnectionCheckTimer[MAXPLAYERS + 1] = { null, ... };
float g_PlayerGhostModeConnectionTimeOutTime[MAXPLAYERS + 1] = { -1.0, ... };
float g_PlayerGhostModeConnectionBootTime[MAXPLAYERS + 1] = { -1.0, ... };

/**
 *	Enables/Disables ghost mode on the player.
 */
void ClientSetGhostModeState(int client, bool bState)
{
	if (bState == g_bPlayerGhostMode[client]) return;
	
	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, client);
	delete message;
	EndMessage();

	if (bState && !IsClientInGame(client)) return;
	
	g_bPlayerGhostMode[client] = bState;
	g_iPlayerGhostModeTarget[client] = INVALID_ENT_REFERENCE;
	g_iPlayerGhostModeBossTarget[client] = INVALID_ENT_REFERENCE;
	
	if (bState)
	{
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Entered ghost mode.");
#endif
		//Strip the always edict flag
		SetEntityFlags(client,GetEntityFlags(client)^FL_EDICT_ALWAYS);
		//Remove the fire cond
		TF2_RemoveCondition(client,TFCond_OnFire);
		//Call the spawn event.
		TF2_RespawnPlayer(client);
		TF2_RemoveCondition(client,TFCond_Taunting);
		
		TFClassType iDesiredClass = TF2_GetPlayerClass(client);
		if (iDesiredClass == TFClass_Unknown) iDesiredClass = TFClass_Spy;
		
		//Set player's class to spy, this replaces old ghost mode mechanics.
		TF2_SetPlayerClass(client, TFClass_Spy);
		TF2_RegeneratePlayer(client);
		
		//Set player's old class as desired class.
		SetEntProp(client, Prop_Send, "m_iDesiredPlayerClass", iDesiredClass);

		ClientHandleGhostMode(client, true);
		if (g_GhostModeConnectionCheckConVar.BoolValue)
		{
			g_PlayerGhostModeConnectionCheckTimer[client] = CreateTimer(0.0, Timer_GhostModeConnectionCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_PlayerGhostModeConnectionTimeOutTime[client] = -1.0;
			g_PlayerGhostModeConnectionBootTime[client] = -1.0;
		}
		
		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{	
			if (NPCGetUniqueID(npcIndex) == -1) continue;
			if (g_SlenderInDeathcam[npcIndex]) continue;
			SlenderRemoveGlow(npcIndex);
			if (NPCGetCustomOutlinesState(npcIndex))
			{
				if (!NPCGetRainbowOutlineState(npcIndex))
				{
					int color[4];
					color[0] = NPCGetOutlineColorR(npcIndex);
					color[1] = NPCGetOutlineColorG(npcIndex);
					color[2] = NPCGetOutlineColorB(npcIndex);
					color[3] = NPCGetOutlineTransparency(npcIndex);
					if (color[0] < 0) color[0] = 0;
					if (color[1] < 0) color[1] = 0;
					if (color[2] < 0) color[2] = 0;
					if (color[3] < 0) color[3] = 0;
					if (color[0] > 255) color[0] = 255;
					if (color[1] > 255) color[1] = 255;
					if (color[2] > 255) color[2] = 255;
					if (color[3] > 255) color[3] = 255;
					SlenderAddGlow(npcIndex,_,color);
				}
				else SlenderAddGlow(npcIndex,_,view_as<int>({0, 0, 0, 0}));
			}
			else
			{
				int iPurple[4] = {150, 0, 255, 255};
				SlenderAddGlow(npcIndex,_,iPurple);
			}
		}
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i)) continue;
			ClientDisableConstantGlow(i);
			if (!g_PlayerProxy[i] && !DidClientEscape(i) && !g_PlayerEliminated[i])
			{
				int iRed[4] = {184, 56, 59, 255};
				ClientEnableConstantGlow(i, "head", iRed);
			}
			else if ((g_PlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
			{
				int iYellow[4] = {255, 208, 0, 255};
				ClientEnableConstantGlow(i, "head", iYellow);
			}
		}

		PvP_OnClientGhostModeEnable(client);
	}
	else
	{
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Exited ghost mode.");
#endif
		TF2Attrib_SetByName(client, "mod see enemy health", 0.0);
		g_PlayerGhostModeConnectionCheckTimer[client] = null;
		g_PlayerGhostModeConnectionTimeOutTime[client] = -1.0;
		g_PlayerGhostModeConnectionBootTime[client] = -1.0;
	
		if (IsClientInGame(client))
		{
			SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_YES);
			TF2_RemoveCondition(client, TFCond_Stealthed);
			SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
			SetEntityGravity(client, 1.0);
			SetEntProp(client, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_PLAYER);
			SetEntPropEnt(client, Prop_Send, "m_hGroundEntity", -1);
			SetEntityFlags(client, GetEntityFlags(client) &~ FL_NOTARGET);
			SetEntProp(client, Prop_Data, "m_usSolidFlags", 16);
			SetEntProp(client, Prop_Send, "m_nSolidType", 2);
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
			SetEntityRenderMode(client, RENDER_NORMAL);
			SetEntityRenderColor(client, _, _, _, 255);
		}
	}
}

/**
 *	Makes sure that the player is a ghost when ghost mode is activated.
 */
void ClientHandleGhostMode(int client, bool bForceSpawn=false)
{
	if (!IsClientInGhostMode(client)) return;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
	
	if (!TF2_IsPlayerInCondition(client, TFCond_Stealthed) || bForceSpawn)
	{
		TF2_StripWearables(client);
		DestroyAllActiveWeapons(client);
		TF2_DestroySpyWeapons(client);
		SetEntityGravity(client, 0.5);
		TF2_AddCondition(client, TFCond_Stealthed, -1.0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_NO);
		SetEntProp(client, Prop_Send, "m_usSolidFlags", 4);
		SetEntProp(client, Prop_Data, "m_nSolidType", 0);
		SetEntPropEnt(client, Prop_Send, "m_hGroundEntity", -1);
		SetEntProp(client, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);
		SetEntityFlags(client, GetEntityFlags(client) | FL_NOTARGET);
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		SetEntityRenderColor(client, _, _, _, 0);
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);

		// Set first observer target.
		ClientGhostModeNextTarget(client, true);
		ClientActivateUltravision(client);
		
		// screen overlay timer
		g_hPlayerOverlayCheck[client] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		TriggerTimer(g_hPlayerOverlayCheck[client], true);
		
		CreateTimer(0.2, Timer_ClientGhostStripWearables, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
}

public Action Timer_ClientGhostStripWearables(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (!IsValidClient(client)) return Plugin_Stop;
	if (!IsClientInGhostMode(client)) return Plugin_Stop;
	TF2_StripWearables(client);
	DestroyAllActiveWeapons(client);
	TF2_DestroySpyWeapons(client);
	return Plugin_Stop;
}

void ClientGhostModeNextTarget(int client, bool bIgnoreSetting = false)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientGhostModeNextTarget(%d)", client);
#endif

	if (g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState == 0 || bIgnoreSetting)
	{
		int iLastTarget = EntRefToEntIndex(g_iPlayerGhostModeTarget[client]);
		int iNextTarget = -1;
		int iFirstTarget = -1;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && (!g_PlayerEliminated[i] || g_PlayerProxy[i]) && !IsClientInGhostMode(i) && !DidClientEscape(i) && IsPlayerAlive(i))
			{
				if (iFirstTarget == -1) iFirstTarget = i;
				if (i > iLastTarget) 
				{
					iNextTarget = i;
					break;
				}
			}
		}
		
		int iTarget = -1;
		if (IsValidClient(iNextTarget)) iTarget = iNextTarget;
		else iTarget = iFirstTarget;
		
		if (IsValidClient(iTarget))
		{
			g_iPlayerGhostModeTarget[client] = EntIndexToEntRef(iTarget);
			
			float flPos[3], flAng[3], flVelocity[3];
			GetClientAbsOrigin(iTarget, flPos);
			GetClientEyeAngles(iTarget, flAng);
			GetEntPropVector(iTarget, Prop_Data, "m_vecAbsVelocity", flVelocity);
			TeleportEntity(client, flPos, flAng, flVelocity);
		}
		
		#if defined DEBUG
			if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		#endif
	}
	else
	{
		int iLastTarget = NPCGetFromEntIndex(EntRefToEntIndex(g_iPlayerGhostModeBossTarget[client]));
		int iNextTarget = -1;
		int iFirstTarget = -1;
		for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
		{
			if (NPCGetUniqueID(bossIndex) == -1 || !IsValidEntity(NPCGetEntIndex(bossIndex))) continue;

			if (iFirstTarget == -1) iFirstTarget = bossIndex;
			if (bossIndex > iLastTarget) 
			{
				iNextTarget = bossIndex;
				break;
			}
		}
		
		int iTarget = -1;
		if (iNextTarget != - 1 && NPCGetEntIndex(iNextTarget) && NPCGetEntIndex(iNextTarget) != INVALID_ENT_REFERENCE) iTarget = iNextTarget;
		else iTarget = iFirstTarget;
		
		if (iTarget != -1 && IsValidEntity(NPCGetEntIndex(iTarget)))
		{
			g_iPlayerGhostModeBossTarget[client] = EntIndexToEntRef(NPCGetEntIndex(iTarget));
			
			float flPos[3], flAng[3], flVelocity[3];
			GetEntPropVector(NPCGetEntIndex(iTarget), Prop_Data, "m_vecAbsOrigin", flPos);
			GetEntPropVector(NPCGetEntIndex(iTarget), Prop_Data, "m_angAbsRotation", flAng);
			GetEntPropVector(NPCGetEntIndex(iTarget), Prop_Data, "m_vecAbsVelocity", flVelocity);
			TeleportEntity(client, flPos, flAng, flVelocity);
		}
		
		#if defined DEBUG
			if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		#endif
	}
}

bool IsClientInGhostMode(int client)
{
	return g_bPlayerGhostMode[client];
}

public Action Hook_GhostNoTouch(int iEntity, int iOther)
{
	if (0 < iOther <= MaxClients && IsClientInGame(iOther))
	{
		if (IsClientInGhostMode(iOther)) return Plugin_Handled;
	}
	return Plugin_Continue;
}

//	==========================================================
//	SCARE FUNCTIONS
//	==========================================================

void ClientPerformScare(int client,int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not perform scare on client %d: boss does not exist!", client);
		return;
	}
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	
	g_flPlayerScareLastTime[client][bossIndex] = GetGameTime();
	g_flPlayerScareNextTime[client][bossIndex] = GetGameTime() + NPCGetScareCooldown(bossIndex);
	
	// See how much Sanity should be drained from a scare.
	float staticAmount = GetProfileFloat(profile, "scare_static_amount", 0.0);
	g_PlayerStaticAmount[client] += staticAmount;
	if (g_PlayerStaticAmount[client] > 1.0) g_PlayerStaticAmount[client] = 1.0;
	
	char sScareSound[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(profile, "sound_scare_player", sScareSound, sizeof(sScareSound));
	
	if (sScareSound[0] != '\0')
	{
		EmitSoundToClient(client, sScareSound, _, MUSIC_CHAN, SNDLEVEL_NONE);
		
		if (NPCGetFlags(bossIndex) & SFF_HASSIGHTSOUNDS)
		{
			float flCooldownMin = GetProfileFloat(profile, "sound_sight_cooldown_min", 8.0);
			float flCooldownMax = GetProfileFloat(profile, "sound_sight_cooldown_max", 14.0);
			
			g_flPlayerSightSoundNextTime[client][bossIndex] = GetGameTime() + GetRandomFloat(flCooldownMin, flCooldownMax);
		}
		
		if (g_PlayerStressAmount[client] > 0.4)
		{
			ClientAddStress(client, 0.4);
		}
		else
		{
			ClientAddStress(client, 0.66);
		}
	}
	else
	{
		if (g_PlayerStressAmount[client] > 0.4)
		{
			ClientAddStress(client, 0.3);
		}
		else
		{
			ClientAddStress(client, 0.45);
		}
	}

	Call_StartForward(g_OnClientScareFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();
}

void ClientPerformSightSound(int client,int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not perform sight sound on client %d: boss does not exist!", client);
		return;
	}
	
	if (!(NPCGetFlags(bossIndex) & SFF_HASSIGHTSOUNDS)) return;
	
	int iMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[bossIndex]);
	if (iMaster == -1) iMaster = bossIndex;
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	
	char sSightSound[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(profile, "sound_sight", sSightSound, sizeof(sSightSound));
	
	if (sSightSound[0] != '\0')
	{
		EmitSoundToClient(client, sSightSound, _, MUSIC_CHAN, SNDLEVEL_NONE);
		
		float flCooldownMin = GetProfileFloat(profile, "sound_sight_cooldown_min", 8.0);
		float flCooldownMax = GetProfileFloat(profile, "sound_sight_cooldown_max", 14.0);
		
		g_flPlayerSightSoundNextTime[client][iMaster] = GetGameTime() + GetRandomFloat(flCooldownMin, flCooldownMax);
		
		float bossPos[3], flMyPos[3];
		int iBoss = NPCGetEntIndex(bossIndex);
		GetClientAbsOrigin(client, flMyPos);
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", bossPos);
		float flDistUnComfortZone = 400.0;
		float bossDist = GetVectorSquareMagnitude(flMyPos, bossPos);
		
		float flStressScalar = 1.0 + ((SquareFloat(flDistUnComfortZone) / bossDist));
		
		ClientAddStress(client, 0.1 * flStressScalar);
	}
}

void ClientResetScare(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetScare(%d)", client);
#endif

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_flPlayerScareNextTime[client][i] = -1.0;
		g_flPlayerScareLastTime[client][i] = -1.0;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetScare(%d)", client);
#endif
}

//	==========================================================
//	ANTI-CAMPING FUNCTIONS
//	==========================================================

stock void ClientResetCampingStats(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetCampingStats(%d)", client);
#endif

	g_PlayerCampingStrikes[client] = 0;
	g_PlayerIsExitCamping[client] = false;
	g_PlayerCampingTimer[client] = null;
	g_IsPlayerCampingFirstTime[client] = true;
	g_PlayerCampingLastPosition[client][0] = 0.0;
	g_PlayerCampingLastPosition[client][1] = 0.0;
	g_PlayerCampingLastPosition[client][2] = 0.0;
	g_ClientAllowedTimeNearEscape[client] = g_ExitCampingTimeAllowedConVar.FloatValue;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetCampingStats(%d)", client);
#endif
}

void ClientStartCampingTimer(int client)
{
	g_PlayerCampingTimer[client] = CreateTimer(5.0, Timer_ClientCheckCamp, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

//	==========================================================
//	BLINK FUNCTIONS
//	==========================================================

bool IsClientBlinking(int client)
{
	return g_PlayerBlink[client];
}

float ClientGetBlinkMeter(int client)
{
	return g_PlayerBlinkMeter[client];
}

void ClientSetBlinkMeter(int client, float amount)
{
	g_PlayerBlinkMeter[client] = amount;
}

int ClientGetBlinkCount(int client)
{
	return g_PlayerBlinkCount[client];
}

/**
 *	Resets all data on blinking.
 */
void ClientResetBlink(int client)
{
	g_PlayerBlinkTimer[client] = null;
	g_PlayerBlink[client] = false;
	g_PlayerHoldingBlink[client] = false;
	g_TimeUntilUnblink[client] = 0.0;
	g_PlayerBlinkMeter[client] = 1.0;
	g_PlayerBlinkCount[client] = 0;
}

/**
 *	Sets the player into a blinking state and blinds the player
 */
void ClientBlink(int client)
{
	if (IsRoundInWarmup() || DidClientEscape(client)) return;
	
	if (IsClientBlinking(client)) return;
	
	if (SF_IsRaidMap() || SF_IsBoxingMap()) return;
	
	g_PlayerBlink[client] = true;
	g_PlayerBlinkCount[client]++;
	g_PlayerBlinkMeter[client] = 0.0;
	g_PlayerBlinkTimer[client] = CreateTimer(0.0, Timer_TryUnblink, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_TimeUntilUnblink[client] = GetGameTime() + g_PlayerBlinkHoldTimeConVar.FloatValue;
	
	UTIL_ScreenFade(client, 100, RoundToFloor(g_PlayerBlinkHoldTimeConVar.FloatValue * 1000.0), FFADE_IN, 0, 0, 0, 255);
	
	Call_StartForward(g_OnClientBlinkFwd);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Unsets the player from the blinking state.
 */
void ClientUnblink(int client)
{
	if (!IsClientBlinking(client)) return;
	
	g_PlayerBlink[client] = false;
	g_PlayerBlinkTimer[client] = null;
	g_PlayerBlinkMeter[client] = 1.0;
}

void ClientStartDrainingBlinkMeter(int client)
{
	g_PlayerBlinkTimer[client] = CreateTimer(ClientGetBlinkRate(client), Timer_BlinkTimer, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_BlinkTimer(Handle timer, any userid)
{
	if (IsRoundInWarmup()) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerBlinkTimer[client]) return Plugin_Stop;
	
	if (IsPlayerAlive(client) && !IsClientInDeathCam(client) && !g_PlayerEliminated[client] && !IsClientInGhostMode(client) && !IsRoundEnding())
	{
		int iOverride = g_PlayerInfiniteBlinkOverrideConVar.IntValue;
		if ((!g_bRoundInfiniteBlink && iOverride != 1) || iOverride == 0)
		{
			g_PlayerBlinkMeter[client] -= 0.05;
		}
		
		if (g_PlayerBlinkMeter[client] <= 0.0)
		{
			ClientBlink(client);
			return Plugin_Stop;
		}
	}
	
	return Plugin_Continue;
}

static Action Timer_TryUnblink(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0 || timer != g_PlayerBlinkTimer[client] || !g_PlayerBlink[client]) return Plugin_Stop;
	
	if (g_PlayerHoldingBlink[client])
	{
		// Some maps use the env_fade entity, so don't use FFADE_PURGE.
		// Instead, we resort to spamming fade messages to the client to keep
		// them blind.
		UTIL_ScreenFade(client, 100, 150, FFADE_IN, 0, 0, 0, 255);
		return Plugin_Continue;
	}

	if (GetGameTime() < g_TimeUntilUnblink[client])
	{
		return Plugin_Continue;
	}

	ClientUnblink(client);
	ClientStartDrainingBlinkMeter(client);

	return Plugin_Stop;
}

public Action Timer_BlinkTimer2(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_PlayerBlinkTimer[client]) return Plugin_Stop;
	
	ClientUnblink(client);
	ClientStartDrainingBlinkMeter(client);

	return Plugin_Stop;
}

float ClientGetBlinkRate(int client)
{
	float flValue = g_PlayerBlinkRateConVar.FloatValue;
	if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 3) 
	{
		// Being underwater makes you blink faster, obviously.
		flValue *= 0.75;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;

		if (g_PlayerSeesSlender[client][i]) 
		{
			flValue *= NPCGetBlinkLookRate(i);
		}
		
		else if (g_iPlayerStaticMode[client][i] == Static_Increase)
		{
			flValue *= NPCGetBlinkStaticRate(i);
		}
	}
	
	if (TF2_GetPlayerClass(client) == TFClass_Sniper) flValue *= 2.0;
	
	if (IsClientUsingFlashlight(client))
	{
		float startPos[3], endPos[3], flDirection[3];
		float flLength = SF2_FLASHLIGHT_LENGTH;
		GetClientEyePosition(client, startPos);
		GetClientEyePosition(client, endPos);
		GetClientEyeAngles(client, flDirection);
		GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(flDirection, flDirection);
		ScaleVector(flDirection, flLength);
		AddVectors(endPos, flDirection, endPos);
		Handle hTrace = TR_TraceRayFilterEx(startPos, endPos, MASK_VISIBLE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, client);
		TR_GetEndPosition(endPos, hTrace);
		bool bHit = TR_DidHit(hTrace);
		delete hTrace;
		
		if (bHit)
		{
			float flPercent = ((GetVectorSquareMagnitude(startPos, endPos) / flLength));
			flPercent *= 3.5;
			if (flPercent > 1.0) flPercent = 1.0;
			flValue *= flPercent;
		}
	}
	
	return flValue;
}

//	==========================================================
//	SCREEN OVERLAY FUNCTIONS
//	==========================================================

void ClientAddStress(int client, float flStressAmount)
{
	g_PlayerStressAmount[client] += flStressAmount;
	if (g_PlayerStressAmount[client] < 0.0) g_PlayerStressAmount[client] = 0.0;
	if (g_PlayerStressAmount[client] > 1.0) g_PlayerStressAmount[client] = 1.0;
	
	//PrintCenterText(client, "g_PlayerStressAmount[%d] = %f", client, g_PlayerStressAmount[client]);
	
	SlenderOnClientStressUpdate(client);
}

stock void ClientResetOverlay(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetOverlay(%d)", client);
#endif
	
	g_hPlayerOverlayCheck[client] = null;
	
	if (IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay \"\"");
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetOverlay(%d)", client);
#endif
}

public Action Timer_PlayerOverlayCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerOverlayCheck[client]) return Plugin_Stop;
	
	if (IsRoundInWarmup()) return Plugin_Continue;
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	int iJumpScareBoss = NPCGetFromUniqueID(g_PlayerJumpScareBoss[client]);
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	char sMaterial[PLATFORM_MAX_PATH], sOverlay[PLATFORM_MAX_PATH];
	
	if (IsClientInDeathCam(client) && iDeathCamBoss != -1 && g_bPlayerDeathCamShowOverlay[client])
	{
		NPCGetProfile(iDeathCamBoss, profile, sizeof(profile));
		GetRandomStringFromProfile(profile, "overlay_player_death", sMaterial, sizeof(sMaterial), 1);
	}
	else if (iJumpScareBoss != -1 && GetGameTime() <= g_PlayerJumpScareLifeTime[client])
	{
		NPCGetProfile(iJumpScareBoss, profile, sizeof(profile));
		GetRandomStringFromProfile(profile, "overlay_jumpscare", sMaterial, sizeof(sMaterial), 1);
	}
	else if (IsClientInGhostMode(client) && !SF_IsBoxingMap())
	{
		g_GhostOverlayConVar.GetString(sOverlay, sizeof(sOverlay));
		strcopy(sMaterial, sizeof(sMaterial), sOverlay);
	}
	else if (IsRoundInWarmup() || g_PlayerEliminated[client] || DidClientEscape(client) && !IsClientInGhostMode(client))
	{
		return Plugin_Continue;
	}
	else
	{
		if (!g_PlayerPreferences[client].PlayerPreference_FilmGrain)
		{
			g_OverlayNoGrainConVar.GetString(sOverlay, sizeof(sOverlay));
			strcopy(sMaterial, sizeof(sMaterial), sOverlay);
		}
		else
		{
			g_CameraOverlayConVar.GetString(sOverlay, sizeof(sOverlay));
			strcopy(sMaterial, sizeof(sMaterial), sOverlay);
		}
	}
	
	ClientCommand(client, "r_screenoverlay %s", sMaterial);
	return Plugin_Continue;
}

//	==========================================================
//	MISC FUNCTIONS
//	==========================================================

// This could be used for entities as well.
stock void ClientStopAllSlenderSounds(int client, const char[] profileName, const char[] sectionName,int iChannel)
{
	if (!client || !IsValidEntity(client)) return;
	
	if (!IsProfileValid(profileName)) return;
	
	char buffer[PLATFORM_MAX_PATH];
	
	g_Config.Rewind();
	if (g_Config.JumpToKey(profileName))
	{
		char s[32];
		
		if (g_Config.JumpToKey(sectionName))
		{
			for (int i2 = 1;; i2++)
			{
				FormatEx(s, sizeof(s), "%d", i2);
				g_Config.GetString(s, buffer, sizeof(buffer));
				if (buffer[0] == '\0') break;
				
				if (buffer[0] != '\0') StopSound(client, iChannel, buffer);
			}
		}
	}
}

stock void ClientUpdateListeningFlags(int client, bool bReset=false)
{
	if (!IsClientInGame(client)) return;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == client || !IsClientInGame(i) || IsClientSourceTV(i)) continue;
		
		if (bReset || IsRoundEnding() || g_AllChatConVar.BoolValue || SF_IsBoxingMap())
		{
			SetListenOverride(client, i, Listen_Default);
			continue;
		}

		if (g_AdminAllTalk[client] || g_AdminAllTalk[i])
		{
			SetListenOverride(client, i, Listen_Default);
		}
		else if (g_PlayerEliminated[client])
		{
			if (!g_PlayerEliminated[i])
			{
				if (g_PlayerPreferences[client].PlayerPreference_MuteMode == 1)
				{
					SetListenOverride(client, i, Listen_No);
				}
				else if (g_PlayerPreferences[client].PlayerPreference_MuteMode == 2 && !g_PlayerProxy[client])
				{
					SetListenOverride(client, i, Listen_No);
				}
				else if (g_PlayerPreferences[client].PlayerPreference_MuteMode == 0)
				{
					SetListenOverride(client, i, Listen_Default);
				}
			}
			else
			{
				SetListenOverride(client, i, Listen_Default);
			}
		}
		else
		{
			if (!g_PlayerEliminated[i])
			{
				bool bCanHear = false;
				if (g_PlayerVoiceDistanceConVar.FloatValue <= 0.0) bCanHear = true;
					
				if (!bCanHear)
				{
					float flMyPos[3], flHisPos[3];
					GetClientEyePosition(client, flMyPos);
					GetClientEyePosition(i, flHisPos);
						
					float flDist = GetVectorSquareMagnitude(flMyPos, flHisPos);
						
					if (g_PlayerVoiceWallScaleConVar.FloatValue > 0.0)
					{
						Handle hTrace = TR_TraceRayFilterEx(flMyPos, flHisPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitCharacters);
						bool bDidHit = TR_DidHit(hTrace);
						delete hTrace;
							
						if (bDidHit)
						{
							flDist *= SquareFloat(g_PlayerVoiceWallScaleConVar.FloatValue);
						}
					}
						
					if (flDist <= SquareFloat(g_PlayerVoiceDistanceConVar.FloatValue))
					{
						bCanHear = true;
					}
				}
					
				if (bCanHear)
				{
					if (IsClientInGhostMode(i) != IsClientInGhostMode(client) &&
						DidClientEscape(i) != DidClientEscape(client))
					{
						bCanHear = false;
					}
				}
					
				if (bCanHear)
				{
					SetListenOverride(client, i, Listen_Default);
				}
				else
				{
					SetListenOverride(client, i, Listen_No);
				}
			}
			else
			{
				SetListenOverride(client, i, Listen_No);
			}
		}
	}
}

stock void ClientShowMainMessage(int client, const char[] sMessage, any ...)
{
	char message[512];
	VFormat(message, sizeof(message), sMessage, 3);
	
	SetHudTextParams(-1.0, 0.4,
		5.0,
		255,
		255,
		255,
		200,
		2,
		1.0,
		0.07,
		2.0);
	ShowSyncHudText(client, g_HudSync, message);
}

stock void ClientShowRenevantMessage(int client, const char[] sMessage, int params, any ...)
{
	char message[512];
	VFormat(message, sizeof(message), sMessage, params);
	
	SetHudTextParams(-1.0, 0.25,
		5.0,
		255,
		255,
		255,
		200,
		2,
		1.0,
		0.05,
		2.0);
	ShowSyncHudText(client, g_HudSync3, message);
}

stock void ClientResetSlenderStats(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("START ClientResetSlenderStats(%d)", client);
#endif
	
	g_PlayerStressAmount[client] = 0.0;
	g_PlayerStressNextUpdateTime[client] = -1.0;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerSeesSlender[client][i] = false;
		g_flPlayerSeesSlenderLastTime[client][i] = -1.0;
		g_flPlayerSightSoundNextTime[client][i] = -1.0;
		g_PlayerScaredByBoss[client][i] = false;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2) DebugMessage("END ClientResetSlenderStats(%d)", client);
#endif
}

bool ClientSetQueuePoints(int client,int iAmount)
{
	if (!IsClientConnected(client) || !AreClientCookiesCached(client)) return false;
	g_iPlayerQueuePoints[client] = iAmount;
	ClientSaveCookies(client);
	return true;
}

void ClientSaveCookies(int client)
{
	if (!IsClientConnected(client) || !AreClientCookiesCached(client)) return;
	
	// Save and reset our queue points.
	char s[512];
	FormatEx(s, sizeof(s), "%d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d", g_iPlayerQueuePoints[client], 
		g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn, 
		g_PlayerPreferences[client].PlayerPreference_ShowHints, 
		g_PlayerPreferences[client].PlayerPreference_MuteMode,
		g_PlayerPreferences[client].PlayerPreference_FilmGrain,
		g_PlayerPreferences[client].PlayerPreference_EnableProxySelection,
		g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature,
		g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection,
		g_PlayerPreferences[client].PlayerPreference_ProxyShowMessage,
		g_PlayerPreferences[client].PlayerPreference_ViewBobbing,
		g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState,
		g_PlayerPreferences[client].PlayerPreference_GroupOutline,
		g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState,
		g_PlayerPreferences[client].PlayerPreference_LegacyHud);
		
	SetClientCookie(client, g_Cookie, s);
}

stock void ClientViewPunch(int client, const float angleOffset[3])
{
	if (g_PlayerPunchAngleOffsetVel == -1) return;
	
	float flOffset[3];
	for (int i = 0; i < 3; i++) flOffset[i] = angleOffset[i];
	ScaleVector(flOffset, 20.0);
	
	/*
	if (!IsFakeClient(client))
	{
		// Latency compensation.
		float flLatency = GetClientLatency(client, NetFlow_Outgoing);
		float flLatencyCalcDiff = 60.0 * Pow(flLatency, 2.0);
		
		for (int i = 0; i < 3; i++) flOffset[i] += (flOffset[i] * flLatencyCalcDiff);
	}
	*/
	
	float flAngleVel[3];
	GetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flAngleVel);
	AddVectors(flAngleVel, flOffset, flOffset);
	SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, flOffset, true);
}

public Action Hook_ConstantGlowSetTransmit(int ent,int other)
{
	if (!g_Enabled) return Plugin_Continue;
	if (!Network_ClientHasSeenEntity(other, ent)) return Plugin_Continue;
	
	int iOwner = GetEntPropEnt(ent, Prop_Send, "moveparent");
	
	if (iOwner != -1)
	{
		int iGlowManager = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
		if (iGlowManager > MaxClients)
		{
			AcceptEntityInput(iGlowManager, "Disable");
			AcceptEntityInput(iGlowManager, "Enable");
		}

		if (!SF_SpecialRound(SPECIALROUND_WALLHAX) && !IsClientInGhostMode(other) && !g_PlayerProxy[other] && !g_EnableWallHaxConVar.BoolValue)
		{
			if (iOwner == other) return Plugin_Handled;
		
			if (!IsPlayerAlive(iOwner) || !IsPlayerAlive(other) || !g_PlayerEliminated[other] || !SF_SpecialRound(SPECIALROUND_WALLHAX) || !g_EnableWallHaxConVar.BoolValue) 
			{
				return Plugin_Handled;
			}
		}
		
		if (IsClientInGhostMode(other) || g_PlayerProxy[other])
		{
			return Plugin_Continue;
		}
		
		if ((SF_SpecialRound(SPECIALROUND_WALLHAX) || g_EnableWallHaxConVar.BoolValue) && !g_PlayerEscaped[other] && GetClientTeam(other) == TFTeam_Red)
		{
			return Plugin_Continue;
		}
		
		if (g_PlayerProxy[other])
		{
			if (TF2_GetPlayerClass(iOwner) == TFClass_Medic || TF2_IsPlayerInCondition(iOwner, TFCond_Taunting))
			{
				return Plugin_Continue;
			}
			
			if (TF2_GetPlayerClass(iOwner) != TFClass_Spy)//Allow proxies to see someone's glow if they are moving near by, and they aren't a spy.
			{
				float vecSpeed[3];
				SDK_GetSmoothedVelocity(iOwner, vecSpeed);
				if (GetVectorLength(vecSpeed, true) >= SquareFloat(100.0))
				{
					float flOwnerPos[3], proxyPos[3];
					GetClientEyePosition(iOwner, flOwnerPos);
					GetClientEyePosition(other, proxyPos);
					
					if (GetVectorSquareMagnitude(flOwnerPos, proxyPos) <= SquareFloat((700.0 + ((g_PlayerHasRegenerationItem[iOwner]) ? 300.0 : 0.0))))//To-do add a cvar for that.
					{
						return Plugin_Continue;
					}
				}
			}
			
			float vecSpeed[3];
			SDK_GetSmoothedVelocity(other, vecSpeed);
			if (GetVectorLength(vecSpeed, true) < SquareFloat(100.0))//Don't show if not moving slowly.
			{
				return Plugin_Continue;
			}
		}
	}
	return Plugin_Handled;
}

public Action Hook_ConstantGlowSetTransmitVersion2(int ent, int other)
{
	if (!g_Enabled) return Plugin_Continue;

	int iOwner = GetEntPropEnt(ent, Prop_Send, "moveparent");
	if (iOwner == other) return Plugin_Handled;
	if (!IsValidClient(other)) return Plugin_Handled;
	if (!IsPlayerAlive(other)) return Plugin_Handled;
	if (g_PlayerProxy[other]) return Plugin_Continue;
	if (IsClientInGhostMode(other)) return Plugin_Continue;
	if ((SF_SpecialRound(SPECIALROUND_WALLHAX) || g_EnableWallHaxConVar.BoolValue) && ((GetClientTeam(other) == TFTeam_Red && !g_PlayerEscaped[other] && !g_PlayerEliminated[other]) || (g_PlayerProxy[other]))) return Plugin_Continue;
	return Plugin_Handled;
}

stock void ClientSetFOV(int client,int iFOV)
{
	SetEntData(client, g_PlayerFOVOffset, iFOV);
	SetEntData(client, g_PlayerDefaultFOVOffset, iFOV);
}

stock void TF2_GetClassName(TFClassType iClass, char[] sBuffer,int sBufferLen)
{
	switch (iClass)
	{
		case TFClass_Scout: strcopy(sBuffer, sBufferLen, "scout");
		case TFClass_Sniper: strcopy(sBuffer, sBufferLen, "sniper");
		case TFClass_Soldier: strcopy(sBuffer, sBufferLen, "soldier");
		case TFClass_DemoMan: strcopy(sBuffer, sBufferLen, "demoman");
		case TFClass_Heavy: strcopy(sBuffer, sBufferLen, "heavyweapons");
		case TFClass_Medic: strcopy(sBuffer, sBufferLen, "medic");
		case TFClass_Pyro: strcopy(sBuffer, sBufferLen, "pyro");
		case TFClass_Spy: strcopy(sBuffer, sBufferLen, "spy");
		case TFClass_Engineer: strcopy(sBuffer, sBufferLen, "engineer");
		default: sBuffer[0] = '\0';
	}
}

stock bool IsPointVisibleToAPlayer(const float pos[3], bool bCheckFOV=true, bool bCheckBlink=false)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		if (IsPointVisibleToPlayer(i, pos, bCheckFOV, bCheckBlink)) return true;
	}
	
	return false;
}

stock bool IsPointVisibleToPlayer(int client, const float pos[3], bool bCheckFOV=true, bool bCheckBlink=false, bool bCheckEliminated=true, bool bIgnoreFog = false)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client)) return false;
	
	if (bCheckEliminated && g_PlayerEliminated[client]) return false;
	
	if (bCheckBlink && IsClientBlinking(client)) return false;
	
	float eyePos[3];
	GetClientEyePosition(client, eyePos);
	
	// Check fog, if we can.
	if (!bIgnoreFog && g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
	{
		int iFogEntity = GetEntDataEnt2(client, g_PlayerFogCtrlOffset);
		if (IsValidEdict(iFogEntity))
		{
			if (GetEntData(iFogEntity, g_FogCtrlEnableOffset) &&
				GetVectorSquareMagnitude(eyePos, pos) >= SquareFloat(GetEntDataFloat(iFogEntity, g_FogCtrlEndOffset))) 
			{
				return false;
			}
		}
	}
	
	Handle hTrace = TR_TraceRayFilterEx(eyePos, pos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, client);
	bool bHit = TR_DidHit(hTrace);
	delete hTrace;
	
	if (bHit) return false;
	
	if (bCheckFOV)
	{
		float eyeAng[3], reqVisibleAng[3];
		GetClientEyeAngles(client, eyeAng);
		
		float flFOV = float(g_PlayerDesiredFOV[client]);
		SubtractVectors(pos, eyePos, reqVisibleAng);
		GetVectorAngles(reqVisibleAng, reqVisibleAng);
		
		float difference = FloatAbs(AngleDiff(eyeAng[0], reqVisibleAng[0])) + FloatAbs(AngleDiff(eyeAng[1], reqVisibleAng[1]));
		if (difference > ((flFOV * 0.5) + 10.0)) return false;
	}
	
	return true;
}
//

public Action Timer_RespawnPlayer(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (!IsValidClient(client) || !IsClientInGame(client) || IsPlayerAlive(client)) return Plugin_Stop;

	if (SF_SpecialRound(SPECIALROUND_1UP) && IsRoundPlaying() && g_RoundTime <= 0)
	{
		g_PlayerDied1Up[client] = false;
		g_PlayerIn1UpCondition[client] = false;
		g_bPlayerFullyDied1Up[client] = true;
		return Plugin_Stop;
	}

	if (SF_SpecialRound(SPECIALROUND_1UP) && g_PlayerIn1UpCondition[client] && !DidClientEscape(client) && !IsRoundEnding() && !IsRoundInWarmup() && !IsRoundInIntro() && IsRoundPlaying()) 
	{
		g_PlayerDied1Up[client] = true;
		g_PlayerIn1UpCondition[client] = false;
		EmitSoundToClient(client, SPECIAL1UPSOUND);
	}
	
	TF2_RespawnPlayer(client);

	return Plugin_Stop;
}

#include "sf2/functionclients/clients_think.sp"
#include "sf2/functionclients/client_flashlight.sp"
#include "sf2/functionclients/client_music.sp"
#include "sf2/functionclients/client_proxy_functions.sp"