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
Handle g_hClientSpecialRoundTimer[MAXPLAYERS + 1];

// Deathcam data.
static int g_iPlayerDeathCamBoss[MAXPLAYERS + 1] = { -1, ... };
static bool g_bPlayerDeathCam[MAXPLAYERS + 1] = { false, ... };
static bool g_bPlayerDeathCamShowOverlay[MAXPLAYERS + 1] = { false, ... };
int g_iPlayerDeathCamEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_iPlayerDeathCamEnt2[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_iPlayerDeathCamTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
Handle g_hPlayerDeathCamTimer[MAXPLAYERS + 1] = { null, ... };
bool g_bCameraDeathCamAdvanced[2049] = { false, ... };
float g_flCameraPlayerOffsetBackward[2049] = { 0.0, ... };
float g_flCameraPlayerOffsetDownward[2049] = { 0.0, ... };
float g_vecPlayerOriginalDeathcamPosition[MAXPLAYERS + 1][3];

// Flashlight data.
bool g_bPlayerFlashlight[MAXPLAYERS + 1] = { false, ... };
bool g_bPlayerFlashlightBroken[MAXPLAYERS + 1] = { false, ... };
int g_iPlayerFlashlightEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
int g_iPlayerFlashlightEntAng[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
float g_flPlayerFlashlightBatteryLife[MAXPLAYERS + 1] = { 1.0, ... };
Handle g_hPlayerFlashlightBatteryTimer[MAXPLAYERS + 1] = { null, ... };
float g_flPlayerFlashlightNextInputTime[MAXPLAYERS + 1] = { -1.0, ... };

int g_ActionItemIndexes[] = { 57, 231 };

// Ultravision data.
bool g_bPlayerUltravision[MAXPLAYERS + 1] = { false, ... };
int g_iPlayerUltravisionEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Sprint data.
static bool g_bPlayerSprint[MAXPLAYERS + 1] = { false, ... };
int g_iPlayerSprintPoints[MAXPLAYERS + 1] = { 100, ... };
Handle g_hPlayerSprintTimer[MAXPLAYERS + 1] = { null, ... };

// Blink data.
Handle g_hPlayerBlinkTimer[MAXPLAYERS + 1] = { null, ... };
static bool g_bPlayerBlink[MAXPLAYERS + 1] = { false, ... };
bool g_bPlayerHoldingBlink[MAXPLAYERS + 1] = { false, ... };
static float g_flPlayerBlinkMeter[MAXPLAYERS + 1] = { 0.0, ... };
static float g_flTimeUntilUnblink[MAXPLAYERS + 1] = { 0.0, ... };
static int g_iPlayerBlinkCount[MAXPLAYERS + 1] = { 0, ... };

// Breathing data.
bool g_bPlayerBreath[MAXPLAYERS + 1] = { false, ... };
Handle g_hPlayerBreathTimer[MAXPLAYERS + 1] = { null, ... };

// Interactive glow data.
static int g_iPlayerInteractiveGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerInteractiveGlowTargetEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Constant glow data.
static int g_iPlayerConstantGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static bool g_bPlayerConstantGlowEnabled[MAXPLAYERS + 1] = { false, ... };
Handle g_hClientGlowTimer[MAXPLAYERS + 1];

// Jumpscare data.
static int g_iPlayerJumpScareBoss[MAXPLAYERS + 1] = { -1, ... };
static float g_flPlayerJumpScareLifeTime[MAXPLAYERS + 1] = { -1.0, ... };

static float g_flPlayerScareBoostEndTime[MAXPLAYERS + 1] = { -1.0, ... };

// Anti-camping data.
int g_iPlayerCampingStrikes[MAXPLAYERS + 1] = { 0, ... };
Handle g_hPlayerCampingTimer[MAXPLAYERS + 1] = { null, ... };
float g_flPlayerCampingLastPosition[MAXPLAYERS + 1][3];
bool g_bPlayerCampingFirstTime[MAXPLAYERS + 1];

// Frame data
int g_iClientMaxFrameDeathAnim[MAXPLAYERS + 1];
int g_iClientFrame[MAXPLAYERS + 1];

// Client model
static char g_sOldClientModel[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

//Proxy model
char g_sClientProxyModel[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_sClientProxyModelHard[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_sClientProxyModelInsane[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_sClientProxyModelNightmare[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_sClientProxyModelApollyon[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

//Nav Data
//static CNavArea g_lastNavArea[MAXPLAYERS + 1];
static float g_flClientAllowedTimeNearEscape[MAXPLAYERS + 1];

//	==========================================================
//	GENERAL CLIENT HOOK FUNCTIONS
//	==========================================================

#define SF2_PLAYER_VIEWBOB_TIMER 10.0
#define SF2_PLAYER_VIEWBOB_SCALE_X 0.05
#define SF2_PLAYER_VIEWBOB_SCALE_Y 0.0
#define SF2_PLAYER_VIEWBOB_SCALE_Z 0.0

public MRESReturn Hook_ClientWantsLagCompensationOnEntity(int client, Handle hReturn, Handle hParams)
{
	if (!g_bEnabled || IsFakeClient(client)) return MRES_Ignored;

	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
}

public Action CH_ShouldCollide(int ent1,int ent2, bool &result)
{
	SF2RoundState state = GetRoundState();
	if (state == SF2RoundState_Intro || state == SF2RoundState_Outro) return Plugin_Continue;

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
	if (state == SF2RoundState_Intro || state == SF2RoundState_Outro) return Plugin_Continue;

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

float ClientGetScareBoostEndTime(int client)
{
	return g_flPlayerScareBoostEndTime[client];
}

void ClientSetScareBoostEndTime(int client, float time)
{
	g_flPlayerScareBoostEndTime[client] = time;
}

public Action Hook_HealthKitOnTouch(int iHealthKit, int client)
{
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (!SF_IsBoxingMap())
		{
			if (!g_bPlayerEliminated[client] && TF2_GetPlayerClass(client) == TFClass_Medic) return Plugin_Handled;
		}
		if (IsClientInGhostMode(client)) return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action Hook_ClientSetTransmit(int client,int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	
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

public Action TF2_CalcIsAttackCritical(int client,int weapon, char[] sWeaponName, bool &result)
{
	if (!g_bEnabled) return Plugin_Continue;

	if ((IsRoundInWarmup() || IsClientInPvP(client)) && !IsRoundEnding())
	{
		//Save this for later I guess
	}
	
	return Plugin_Continue;
}

public void Hook_ClientWeaponEquipPost(int client, int weapon)
{
	if (!IsValidClient(client) || !IsClientInGame(client) || !IsValidEdict(weapon)) return;
	DHookEntity(g_hSDKWeaponGetCustomDamageType, true, weapon);
}

public Action Hook_TEFireBullets(const char[] te_name,const int[] Players,int numClients, float delay)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	int client = TE_ReadNum("m_iPlayer") + 1;
	if (IsValidClient(client))
	{
		//Save this for later I guess
	}
	
	return Plugin_Continue;
}

void ClientResetStatic(int client)
{
	g_iPlayerStaticMaster[client] = -1;
	g_hPlayerStaticTimer[client] = null;
	g_flPlayerStaticIncreaseRate[client] = 0.0;
	g_flPlayerStaticDecreaseRate[client] = 0.0;
	g_hPlayerLastStaticTimer[client] = null;
	g_flPlayerLastStaticTime[client] = 0.0;
	g_flPlayerLastStaticVolume[client] = 0.0;
	g_bPlayerInStaticShake[client] = false;
	g_iPlayerStaticShakeMaster[client] = -1;
	g_flPlayerStaticShakeMinVolume[client] = 0.0;
	g_flPlayerStaticShakeMaxVolume[client] = 0.0;
	g_flPlayerStaticAmount[client] = 0.0;
	
	if (IsClientInGame(client))
	{
		if (g_strPlayerStaticSound[client][0] != '\0') StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticSound[client]);
		if (g_strPlayerLastStaticSound[client][0] != '\0') StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
		if (g_strPlayerStaticShakeSound[client][0] != '\0') StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
	}
	
	g_strPlayerStaticSound[client][0] = '\0';
	g_strPlayerLastStaticSound[client][0] = '\0';
	g_strPlayerStaticShakeSound[client][0] = '\0';
}

void ClientResetHints(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetHints(%d)", client);
#endif

	for (int i = 0; i < PlayerHint_MaxNum; i++)
	{
		g_bPlayerHints[client][i] = false;
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetHints(%d)", client);
#endif
}

void ClientShowHint(int client,int iHint)
{
	g_bPlayerHints[client][iHint] = true;
	
	switch (iHint)
	{
		case PlayerHint_Sprint: PrintHintText(client, "%T", "SF2 Hint Sprint", client);
		case PlayerHint_Flashlight: PrintHintText(client, "%T", "SF2 Hint Flashlight", client);
		case PlayerHint_Blink: PrintHintText(client, "%T", "SF2 Hint Blink", client);
		case PlayerHint_MainMenu: PrintHintText(client, "%T", "SF2 Hint Main Menu", client);
		case PlayerHint_Trap: PrintHintText(client, "%T", "SF2 Hint Trap", client);
	}
}

bool DidClientEscape(int client)
{
	return g_bPlayerEscaped[client];
}

void ClientEscape(int client)
{
	if (DidClientEscape(client)) return;

#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("START ClientEscape(%d)", client);
#endif
	
	g_bPlayerEscaped[client] = true;
	
	g_iPlayerPageCount[client] = 0;

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
	
	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);
	
	HandlePlayerHUD(client);
	if (!SF_SpecialRound(SPECIALROUND_REALISM) && !SF_IsBoxingMap())
	{
		char sName[MAX_NAME_LENGTH];
		FormatEx(sName, sizeof(sName), "%N", client);
		CPrintToChatAll("%t", "SF2 Player Escaped", sName);
	}
	
	if (SF_SpecialRound(SPECIALROUND_REALISM))
		StopSound(client, SNDCHAN_STATIC, MARBLEHORNETS_STATIC);
	
	CheckRoundWinConditions();
	
	Call_StartForward(fOnClientEscape);
	Call_PushCell(client);
	Call_Finish();
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("END ClientEscape(%d)", client);
#endif
}

public Action Timer_TeleportPlayerToEscapePoint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (!DidClientEscape(client)) return Plugin_Stop;
	
	if (IsPlayerAlive(client))
	{
		TeleportClientToEscapePoint(client);
	}
	return Plugin_Stop;
}

stock float ClientGetDistanceFromEntity(int client,int entity)
{
	float flStartPos[3], flEndPos[3];
	GetClientAbsOrigin(client, flStartPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEndPos);
	return GetVectorSquareMagnitude(flStartPos, flEndPos);
}

float ClientGetDefaultWalkSpeed(int client)
{
	float flReturn = 190.0;
	float flReturn2 = flReturn;
	Action iAction = Plugin_Continue;
	TFClassType iClass = TF2_GetPlayerClass(client);
	
	switch (iClass)
	{
		case TFClass_Scout: flReturn = 190.0;
		case TFClass_Sniper: flReturn = 180.0;
		case TFClass_Soldier: flReturn = 170.0;
		case TFClass_DemoMan: flReturn = 175.0;
		case TFClass_Heavy: flReturn = 170.0;
		case TFClass_Medic: flReturn = 185.0;
		case TFClass_Pyro: flReturn = 180.0;
		case TFClass_Spy: flReturn = 185.0;
		case TFClass_Engineer: flReturn = 180.0;
	}
	
	// Call our forward.
	Call_StartForward(fOnClientGetDefaultWalkSpeed);
	Call_PushCell(client);
	Call_PushCellRef(flReturn2);
	Call_Finish(iAction);
	
	if (iAction == Plugin_Changed) flReturn = flReturn2;
	
	return flReturn;
}

float ClientGetDefaultSprintSpeed(int client)
{
	float flReturn = 340.0;
	float flReturn2 = flReturn;
	Action iAction = Plugin_Continue;
	TFClassType iClass = TF2_GetPlayerClass(client);
	
	switch (iClass)
	{
		case TFClass_Scout: flReturn = 305.0;
		case TFClass_Sniper: flReturn = 295.0;
		case TFClass_Soldier: flReturn = 280.0;
		case TFClass_DemoMan: flReturn = 280.0;
		case TFClass_Heavy: flReturn = 275.0;
		case TFClass_Medic: flReturn = 300.0;
		case TFClass_Pyro: flReturn = 290.0;
		case TFClass_Spy: flReturn = 300.0;
		case TFClass_Engineer: flReturn = 295.0;
	}
	
	// Call our forward.
	Call_StartForward(fOnClientGetDefaultSprintSpeed);
	Call_PushCell(client);
	Call_PushCellRef(flReturn2);
	Call_Finish(iAction);
	
	if (iAction == Plugin_Changed) flReturn = flReturn2;
	
	return flReturn;
}

// Static shaking should only affect the x, y portion of the player's view, not roll.
// This is purely for cosmetic effect.

void ClientProcessStaticShake(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client)) return;
	
	bool bOldStaticShake = g_bPlayerInStaticShake[client];
	int iOldStaticShakeMaster = NPCGetFromUniqueID(g_iPlayerStaticShakeMaster[client]);
	int iNewStaticShakeMaster = -1;
	float flNewStaticShakeMasterAnger = -1.0;
	
	float flOldPunchAng[3], flOldPunchAngVel[3];
	GetEntDataVector(client, g_offsPlayerPunchAngle, flOldPunchAng);
	GetEntDataVector(client, g_offsPlayerPunchAngleVel, flOldPunchAngVel);
	
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
			int iMaster = NPCGetFromUniqueID(g_iSlenderCopyMaster[i]);
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
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iNewStaticShakeMaster, sProfile, sizeof(sProfile));
		
			if (g_strPlayerStaticShakeSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
			}
			
			g_flPlayerStaticShakeMinVolume[client] = GetProfileFloat(sProfile, "sound_static_shake_local_volume_min", 0.0);
			g_flPlayerStaticShakeMaxVolume[client] = GetProfileFloat(sProfile, "sound_static_shake_local_volume_max", 1.0);
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static_shake_local", sStaticSound, sizeof(sStaticSound));
			if (sStaticSound[0] != '\0')
			{
				strcopy(g_strPlayerStaticShakeSound[client], sizeof(g_strPlayerStaticShakeSound[]), sStaticSound);
			}
			else
			{
				g_strPlayerStaticShakeSound[client][0] = '\0';
			}
		}
	}
	
	if (g_bPlayerInStaticShake[client])
	{
		if (g_flPlayerStaticAmount[client] <= 0.0)
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
		
		SetEntDataVector(client, g_offsPlayerPunchAngle, flNewPunchAng, true);
		SetEntDataVector(client, g_offsPlayerPunchAngleVel, flNewPunchAngVel, true);
	}
	else if (!g_bPlayerInStaticShake[client] && bOldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			flNewPunchAng[i] = 0.0;
			flNewPunchAngVel[i] = 0.0;
		}
	
		g_iPlayerStaticShakeMaster[client] = -1;
		
		if (g_strPlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
		}
		
		g_strPlayerStaticShakeSound[client][0] = '\0';
		
		g_flPlayerStaticShakeMinVolume[client] = 0.0;
		g_flPlayerStaticShakeMaxVolume[client] = 0.0;
		
		SetEntDataVector(client, g_offsPlayerPunchAngle, flNewPunchAng, true);
		SetEntDataVector(client, g_offsPlayerPunchAngleVel, flNewPunchAngVel, true);
	}
	
	if (g_bPlayerInStaticShake[client])
	{
		if (g_strPlayerStaticShakeSound[client][0] != '\0')
		{
			float flVolume = g_flPlayerStaticAmount[client];
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
			
			EmitSoundToClient(client, g_strPlayerStaticShakeSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL | SND_STOP, flVolume);
		}
		
		// Spazz our view all over the place.
		for (int i = 0; i < 2; i++) flNewPunchAng[i] = AngleNormalize(GetRandomFloat(0.0, 360.0));
		NormalizeVector(flNewPunchAng, flNewPunchAng);
		
		float flAngVelocityScalar = 5.0 * g_flPlayerStaticAmount[client];
		if (flAngVelocityScalar < 1.0) flAngVelocityScalar = 1.0;
		ScaleVector(flNewPunchAng, flAngVelocityScalar);
		
		for (int i = 0; i < 2; i++) flNewPunchAngVel[i] = 0.0;
		
		SetEntDataVector(client, g_offsPlayerPunchAngle, flNewPunchAng, true);
		SetEntDataVector(client, g_offsPlayerPunchAngleVel, flNewPunchAngVel, true);
	}
}
void ClientProcessVisibility(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client)) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH], sMasterProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	bool bWasSeeingSlender[MAX_BOSSES];
	int iOldStaticMode[MAX_BOSSES];
	
	float flSlenderPos[3];
	float flSlenderEyePos[3];
	float flSlenderOBBCenterPos[3];
	
	float flMyPos[3];
	GetClientAbsOrigin(client, flMyPos);

	int iDifficulty = g_cvDifficulty.IntValue;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		bWasSeeingSlender[i] = g_bPlayerSeesSlender[client][i];
		iOldStaticMode[i] = g_iPlayerStaticMode[client][i];
		g_bPlayerSeesSlender[client][i] = false;
		g_iPlayerStaticMode[client][i] = Static_None;
		
		if (NPCGetUniqueID(i) == -1) continue;
		
		NPCGetProfile(i, sProfile, sizeof(sProfile));
		
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
				int iCopyMaster = NPCGetFromUniqueID(g_iSlenderCopyMaster[i]);
				
				if (!IsPointVisibleToPlayer(client, flSlenderEyePos, true, SlenderUsesBlink(i)))
				{
					g_bPlayerSeesSlender[client][i] = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, true, SlenderUsesBlink(i));
				}
				else
				{
					g_bPlayerSeesSlender[client][i] = true;
				}
				
				if ((GetGameTime() - g_flPlayerSeesSlenderLastTime[client][i]) > g_flSlenderStaticGraceTime[i][iDifficulty] ||
					(iOldStaticMode[i] == Static_Increase && g_flPlayerStaticAmount[client] > 0.1))
				{
					if ((NPCGetFlags(i) & SFF_STATICONLOOK) && 
						g_bPlayerSeesSlender[client][i])
					{
						if (iCopyMaster != -1)
						{
							g_iPlayerStaticMode[client][iCopyMaster] = Static_Increase;
						}
						else
						{
							g_iPlayerStaticMode[client][i] = Static_Increase;
						}
					}
					else if ((NPCGetFlags(i) & SFF_STATICONRADIUS) && 
						GetVectorSquareMagnitude(flMyPos, flSlenderPos) <= SquareFloat(g_flSlenderStaticRadius[i][iDifficulty]))
					{
						bool bNoObstacles = IsPointVisibleToPlayer(client, flSlenderEyePos, false, false);
						if (!bNoObstacles) bNoObstacles = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, false, false);
						
						if (bNoObstacles)
						{
							if (iCopyMaster != -1)
							{
								g_iPlayerStaticMode[client][iCopyMaster] = Static_Increase;
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
					if (g_flPlayerStaticAmount[client] >= 1.0 ||
						(GetVectorSquareMagnitude(flMyPos, flSlenderPos) <= SquareFloat(NPCGetInstantKillRadius(i)) && (GetGameTime() - g_flSlenderLastKill[i]) >= NPCGetInstantKillCooldown(i, iDifficulty))
						&& !g_bSlenderInDeathcam[i])
					{
						bool bKillPlayer = true;
						if (g_flPlayerStaticAmount[client] < 1.0)
						{
							bKillPlayer = IsPointVisibleToPlayer(client, flSlenderEyePos, false, SlenderUsesBlink(i));
						}
						
						if (!bKillPlayer) bKillPlayer = IsPointVisibleToPlayer(client, flSlenderOBBCenterPos, false, SlenderUsesBlink(i));
						
						if (bKillPlayer)
						{
							g_flSlenderLastKill[i] = GetGameTime();
							
							if (g_flPlayerStaticAmount[client] >= 1.0)
							{
								ClientStartDeathCam(client, NPCGetFromUniqueID(g_iPlayerStaticMaster[client]), flSlenderPos, true);
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
		
		int iMaster = NPCGetFromUniqueID(g_iSlenderCopyMaster[i]);
		if (iMaster == -1) iMaster = i;

		NPCGetProfile(iMaster, sMasterProfile, sizeof(sMasterProfile));
		
		// Boss visiblity.
		if (g_bPlayerSeesSlender[client][i] && !bWasSeeingSlender[i])
		{
			g_flPlayerSeesSlenderLastTime[client][iMaster] = GetGameTime();
			
			if (GetGameTime() >= g_flPlayerScareNextTime[client][iMaster])
			{
				g_bPlayerScaredByBoss[client][iMaster] = false;
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
						g_iPlayerSprintPoints[client] = iClientSprintPoints + NPCGetScareReplenishSprintAmount(iMaster);
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
						if (g_iSlenderState[i] != STATE_CHASE && g_iSlenderState[i] != STATE_ATTACK && g_iSlenderState[i] != STATE_STUN)
						{
							int slender = NPCGetEntIndex(i);
							g_iNPCPlayerScareVictin[i] = EntIndexToEntRef(client);
							g_iSlenderState[i] = STATE_CHASE;
							g_iSlenderTarget[i] = EntIndexToEntRef(client);
							g_flSlenderTimeUntilNoPersistence[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
							g_flSlenderTimeUntilAlert[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
							if (i != -1 && slender && slender != INVALID_ENT_REFERENCE)
								NPCChaserUpdateBossAnimation(i, slender, g_iSlenderState[i]);
							g_bPlayerScaredByBoss[client][i] = true;
						}
					}
					if (NPCGetJumpscareOnScare(iMaster))
					{
						float flJumpScareDuration = NPCGetJumpscareDuration(iMaster, iDifficulty);
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
			
			Call_StartForward(fOnClientLooksAtBoss);
			Call_PushCell(client);
			Call_PushCell(i);
			Call_Finish();
		}
		else if (!g_bPlayerSeesSlender[client][i] && bWasSeeingSlender[i])
		{
			g_flPlayerScareLastTime[client][iMaster] = GetGameTime();
			
			Call_StartForward(fOnClientLooksAwayFromBoss);
			Call_PushCell(client);
			Call_PushCell(i);
			Call_Finish();
		}
		
		if (g_bPlayerSeesSlender[client][i])
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
				GetRandomStringFromProfile(sProfile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
				
				if (sLoopSound[0] != '\0')
				{
					EmitSoundToClient(client, sLoopSound, iBoss, SNDCHAN_STATIC, GetProfileNum(sProfile, "sound_static_loop_local_level", SNDLEVEL_NORMAL), SND_CHANGEVOL, 1.0);
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
					GetRandomStringFromProfile(sProfile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
					
					if (sLoopSound[0] != '\0')
					{
						EmitSoundToClient(client, sLoopSound, iBoss, SNDCHAN_STATIC, _, SND_CHANGEVOL | SND_STOP, 0.0);
					}
				}
			}
		}
	}
	
	// Initialize static timers.
	int iBossLastStatic = NPCGetFromUniqueID(g_iPlayerStaticMaster[client]);
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
		int iCopyMaster = NPCGetFromUniqueID(g_iSlenderCopyMaster[iBossNewStatic]);
		if (iCopyMaster != -1)
		{
			iBossNewStatic = iCopyMaster;
			g_iPlayerStaticMaster[client] = NPCGetUniqueID(iCopyMaster);
		}
		else
		{
			g_iPlayerStaticMaster[client] = NPCGetUniqueID(iBossNewStatic);
		}
	}
	else
	{
		g_iPlayerStaticMaster[client] = -1;
	}
	
	if (iBossNewStatic != iBossLastStatic)
	{
		if (strcmp(g_strPlayerLastStaticSound[client], g_strPlayerStaticSound[client], false) != 0)
		{
			// Stop last-last static sound entirely.
			if (g_strPlayerLastStaticSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
			}
		}
		
		// Move everything down towards the last arrays.
		if (g_strPlayerStaticSound[client][0] != '\0')
		{
			strcopy(g_strPlayerLastStaticSound[client], sizeof(g_strPlayerLastStaticSound[]), g_strPlayerStaticSound[client]);
		}
		
		if (iBossNewStatic == -1)
		{
			// No one is the static master.
			g_hPlayerStaticTimer[client] = CreateTimer(g_flPlayerStaticDecreaseRate[client], 
				Timer_ClientDecreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				
			TriggerTimer(g_hPlayerStaticTimer[client], true);
		}
		else
		{
			NPCGetProfile(iBossNewStatic, sProfile, sizeof(sProfile));
		
			g_strPlayerStaticSound[client][0] = '\0';
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static", sStaticSound, sizeof(sStaticSound), 1);
			
			if (sStaticSound[0] != '\0') 
			{
				strcopy(g_strPlayerStaticSound[client], sizeof(g_strPlayerStaticSound[]), sStaticSound);
			}
			
			// Cross-fade out the static sounds.
			g_flPlayerLastStaticVolume[client] = g_flPlayerStaticAmount[client];
			g_flPlayerLastStaticTime[client] = GetGameTime();
			
			g_hPlayerLastStaticTimer[client] = CreateTimer(0.0, 
				Timer_ClientFadeOutLastStaticSound, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			TriggerTimer(g_hPlayerLastStaticTimer[client], true);
			
			// Start up our own static timer.
			float flStaticIncreaseRate = (g_flSlenderStaticRate[iBossNewStatic][iDifficulty] - (g_flSlenderStaticRate[iBossNewStatic][iDifficulty] * g_flRoundDifficultyModifier)/10);
			float flStaticDecreaseRate = (g_flSlenderStaticRateDecay[iBossNewStatic][iDifficulty] + (g_flSlenderStaticRateDecay[iBossNewStatic][iDifficulty] * g_flRoundDifficultyModifier)/10);
			if (TF2_GetPlayerClass(client) == TFClass_Heavy)
			{
				flStaticIncreaseRate *= 1.15;
				flStaticDecreaseRate *= 0.9;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Sniper && g_bPlayerSeesSlender[client][iBossNewStatic])
			{
				if (g_bPlayerSeesSlender[client][iBossNewStatic])
				{
					flStaticIncreaseRate *= 1.05;
				}
				else
				{
					flStaticIncreaseRate *= 0.9;
				}
				flStaticDecreaseRate *= 0.9;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Engineer)
			{
				flStaticIncreaseRate *= 0.9;
			}
			else if (TF2_GetPlayerClass(client) == TFClass_Scout)
			{
				flStaticIncreaseRate *= 0.95;
			}
			
			g_flPlayerStaticIncreaseRate[client] = flStaticIncreaseRate;
			g_flPlayerStaticDecreaseRate[client] = flStaticDecreaseRate;
			
			g_hPlayerStaticTimer[client] = CreateTimer(flStaticIncreaseRate, 
				Timer_ClientIncreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			
			TriggerTimer(g_hPlayerStaticTimer[client], true);
		}
	}
}

void ClientProcessViewAngles(int client)
{
	if ((!g_bPlayerEliminated[client] || g_bPlayerProxy[client]) && 
		!DidClientEscape(client) && !SF_IsRaidMap() && !SF_IsBoxingMap())
	{
		// Process view bobbing, if enabled.
		// This code is based on the code in this page: https://developer.valvesoftware.com/wiki/Camera_Bob
		// Many thanks to whomever created it in the first place.
		
		if (IsPlayerAlive(client))
		{
			if (g_iPlayerPreferences[client].PlayerPreference_ViewBobbing)
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
					float flHealth = float(GetEntProp(client, Prop_Send, "m_iHealth"));
					float flMaxHealth = float(SDKCall(g_hSDKGetMaxHealth, client));
					
					float flPunchVelHurt[3];
					flPunchVelHurt[0] = Sine(1.22 * GetGameTime()) * 48.5 * ((flMaxHealth - flHealth) / (flMaxHealth * 0.75)) / flMaxHealth;
					flPunchVelHurt[1] = Sine(2.12 * GetGameTime()) * 80.0 * ((flMaxHealth - flHealth) / (flMaxHealth * 0.75)) / flMaxHealth;
					flPunchVelHurt[2] = Sine(0.5 * GetGameTime()) * 36.0 * ((flMaxHealth - flHealth) / (flMaxHealth * 0.75)) / flMaxHealth;
					
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
	
	if (timer != g_hPlayerStaticTimer[client]) return Plugin_Stop;
	
	g_flPlayerStaticAmount[client] += 0.05;
	if (g_flPlayerStaticAmount[client] > 1.0) g_flPlayerStaticAmount[client] = 1.0;
	
	if (g_strPlayerStaticSound[client][0] != '\0')
	{
		EmitSoundToClient(client, g_strPlayerStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, g_flPlayerStaticAmount[client]);
		
		if (g_flPlayerStaticAmount[client] >= 0.5) ClientAddStress(client, 0.03);
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
	
	if (timer != g_hPlayerStaticTimer[client]) return Plugin_Stop;
	
	g_flPlayerStaticAmount[client] -= 0.05;
	if (g_flPlayerStaticAmount[client] < 0.0) g_flPlayerStaticAmount[client] = 0.0;
	
	if (g_strPlayerLastStaticSound[client][0] != '\0')
	{
		float flVolume = g_flPlayerStaticAmount[client];
		if (flVolume > 0.0)
		{
			EmitSoundToClient(client, g_strPlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, flVolume);
		}
	}
	
	if (g_flPlayerStaticAmount[client] <= 0.0)
	{
		// I've done my job; no point to keep on doing it.
		if (g_strPlayerLastStaticSound[client][0] != '\0') StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
		g_hPlayerStaticTimer[client] = null;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_ClientFadeOutLastStaticSound(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerLastStaticTimer[client]) return Plugin_Stop;
	
	if (strcmp(g_strPlayerLastStaticSound[client], g_strPlayerStaticSound[client], false) == 0) 
	{
		// Wait, the player's current static sound is the same one we're stopping. Abort!
		g_hPlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}
	
	if (g_strPlayerLastStaticSound[client][0] != '\0')
	{
		float flDiff = (GetGameTime() - g_flPlayerLastStaticTime[client]) / 1.0;
		if (flDiff > 1.0) flDiff = 1.0;
		
		float flVolume = g_flPlayerLastStaticVolume[client] - flDiff;
		if (flVolume < 0.0) flVolume = 0.0;
		
		if (flVolume <= 0.0)
		{
			// I've done my job; no point to keep on doing it.
			StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
			g_hPlayerLastStaticTimer[client] = null;
			return Plugin_Stop;
		}
		else
		{
			EmitSoundToClient(client, g_strPlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, flVolume);
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

void ClientSetSpecialRoundTimer(int iClient, float flTime, Timer callback, any data, int flags=0)
{
	g_hClientSpecialRoundTimer[iClient] = CreateTimer(flTime, callback, data, flags);
}

public Action Timer_ClientPageDetector(Handle timer, int userid)
{
	if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR)) return Plugin_Stop;
	if (GetRoundState() == SF2RoundState_Escape) return Plugin_Stop;
	
	int iClient = GetClientOfUserId(userid);
	if (g_hClientSpecialRoundTimer[iClient] != timer) return Plugin_Stop;
	
	if (!IsValidClient(iClient)) return Plugin_Stop;
	
	if (g_bPlayerEliminated[iClient]) return Plugin_Stop;
	
	float flDistance = 99999.0, flClientPos[3], flPagePos[3];
	GetClientAbsOrigin(iClient, flClientPos);
	
	char sModel[255], targetName[64];
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "*")) != -1)
	{
		if (!IsEntityClassname(ent, "prop_dynamic", false) && !IsEntityClassname(ent, "prop_dynamic_override", false)) continue;
		
		GetEntPropString(ent, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (sModel[0] != '\0')
		{
			if ((strcmp(sModel, g_strPageRefModel) == 0 || strcmp(sModel, PAGE_MODEL) == 0) && StrContains(targetName, "sf2_page_ex", false) != -1)
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
	
	EmitSoundToClient(iClient,PAGE_DETECTOR_BEEP, _, _, _, _, _, 100-RoundToNearest(flNextBeepTime*10.0));
	g_hClientSpecialRoundTimer[iClient] = CreateTimer(flNextBeepTime, Timer_ClientPageDetector, userid, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

//	==========================================================
//	INTERACTIVE GLOW FUNCTIONS
//	==========================================================

void ClientProcessInteractiveGlow(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || (g_bPlayerEliminated[client] && !g_bPlayerProxy[client]) || IsClientInGhostMode(client)) return;
	
	int iOldLookEntity = EntRefToEntIndex(g_iPlayerInteractiveGlowTargetEntity[client]);
	
	float flStartPos[3], flMyEyeAng[3];
	GetClientEyePosition(client, flStartPos);
	GetClientEyeAngles(client, flMyEyeAng);
	
	Handle hTrace = TR_TraceRayFilterEx(flStartPos, flMyEyeAng, MASK_VISIBLE, RayType_Infinite, TraceRayDontHitPlayers, -1);
	int iEnt = TR_GetEntityIndex(hTrace);
	delete hTrace;
	
	if (IsValidEntity(iEnt))
	{
		g_iPlayerInteractiveGlowTargetEntity[client] = EntRefToEntIndex(iEnt);
	}
	else
	{
		g_iPlayerInteractiveGlowTargetEntity[client] = INVALID_ENT_REFERENCE;
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
	g_iPlayerInteractiveGlowTargetEntity[client] = INVALID_ENT_REFERENCE;
}

/**
 *	Removes the player's current interactive glow entity.
 */
void ClientRemoveInteractiveGlow(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientRemoveInteractiveGlow(%d)", client);
#endif

	int ent = EntRefToEntIndex(g_iPlayerInteractiveGlowEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}
	
	g_iPlayerInteractiveGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientRemoveInteractiveGlow(%d)", client);
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
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientCreateInteractiveGlow(%d)", client);
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
		g_iPlayerInteractiveGlowEntity[client] = EntIndexToEntRef(ent);
		
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
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> false", client);
#endif
	
	return false;
}

public Action Hook_InterativeGlowSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (EntRefToEntIndex(g_iPlayerInteractiveGlowEntity[other]) != ent) return Plugin_Handled;
	
	return Plugin_Continue;
}

//	==========================================================
//	BREATHING FUNCTIONS
//	==========================================================

void ClientResetBreathing(int client)
{
	g_bPlayerBreath[client] = false;
	g_hPlayerBreathTimer[client] = null;
}

float ClientCalculateBreathingCooldown(int client)
{
	float flAverage = 0.0;
	int iAverageNum = 0;
	
	// Sprinting only, for now.
	flAverage += (SF2_PLAYER_BREATH_COOLDOWN_MAX * 6.7765 * Pow((float(g_iPlayerSprintPoints[client]) / 100.0), 1.65));
	iAverageNum++;
	
	flAverage /= float(iAverageNum);
	
	if (flAverage < SF2_PLAYER_BREATH_COOLDOWN_MIN) flAverage = SF2_PLAYER_BREATH_COOLDOWN_MIN;
	
	return flAverage;
}

void ClientStartBreathing(int client)
{
	g_bPlayerBreath[client] = true;
	g_hPlayerBreathTimer[client] = CreateTimer(ClientCalculateBreathingCooldown(client), Timer_ClientBreath, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStopBreathing(int client)
{
	g_bPlayerBreath[client] = false;
	g_hPlayerBreathTimer[client] = null;
}

bool ClientCanBreath(int client)
{
	return view_as<bool>(ClientCalculateBreathingCooldown(client) < SF2_PLAYER_BREATH_COOLDOWN_MAX);
}

public Action Timer_ClientBreath(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerBreathTimer[client]) return Plugin_Stop;
	
	if (!g_bPlayerBreath[client]) return Plugin_Stop;
	
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
	return g_bPlayerSprint[client];
}

int ClientGetSprintPoints(int client)
{
	return g_iPlayerSprintPoints[client];
}

void ClientResetSprint(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetSprint(%d)", client);
#endif

	bool bWasSprinting = IsClientSprinting(client);

	g_bPlayerSprint[client] = false;
	g_iPlayerSprintPoints[client] = 100;
	g_hPlayerSprintTimer[client] = null;
	
	if (IsValidClient(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		
		ClientSetFOV(client, g_iPlayerDesiredFOV[client]);
	}
	
	if (bWasSprinting)
	{
		Call_StartForward(fOnClientStopSprinting);
		Call_PushCell(client);
		Call_Finish();
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetSprint(%d)", client);
#endif
}

void ClientStartSprint(int client)
{
	if (IsClientSprinting(client)) return;
	
	g_bPlayerSprint[client] = true;
	g_hPlayerSprintTimer[client] = null;
	ClientSprintTimer(client);
	TriggerTimer(g_hPlayerSprintTimer[client], true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
	{
		Client90sMusicStart(client);
	}
	
	SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	
	Call_StartForward(fOnClientStartSprinting);
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
		if (TF2_GetPlayerClass(client) == TFClass_DemoMan) flRate *= 1.175;
		else if (TF2_GetPlayerClass(client) == TFClass_Medic || TF2_GetPlayerClass(client) == TFClass_Spy || TF2_GetPlayerClass(client)) flRate *= 1.05;
	}
	
	if (bRecharge) g_hPlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientRechargeSprint, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	else g_hPlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientSprinting, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStopSprint(int client)
{
	if (!IsClientSprinting(client)) return;
	g_bPlayerSprint[client] = false;
	g_hPlayerSprintTimer[client] = null;
	ClientSprintTimer(client, true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
	{
		Client90sMusicStop(client);
	}
	
	SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	
	Call_StartForward(fOnClientStopSprinting);
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
	if (!g_bEnabled) return Plugin_Stop;

	int iClient = GetClientOfUserId(userid);

	if (iClient <= 0 || DidClientEscape(iClient) || g_bPlayerEliminated[iClient] || !IsPlayerAlive(iClient) || IsClientInGhostMode(iClient) || g_bPlayerProxy[iClient]) return Plugin_Stop;
	g_iPlayerRandomClassNumber[iClient] = GetRandomInt(1, 9);

	// Regenerate player but keep health the same.
	int iHealth = GetEntProp(iClient, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(iClient);
	SetEntProp(iClient, Prop_Data, "m_iHealth", iHealth);
	SetEntProp(iClient, Prop_Send, "m_iHealth", iHealth);

	return Plugin_Stop;
}
public Action Timer_ClassScramblePlayer2(Handle timer, any userid)
{
	if (!g_bEnabled) return Plugin_Stop;

	int iClient = GetClientOfUserId(userid);

	if (iClient <= 0 || DidClientEscape(iClient) || g_bPlayerEliminated[iClient] || !IsPlayerAlive(iClient) || IsClientInGhostMode(iClient) || g_bPlayerProxy[iClient]) return Plugin_Stop;

	// Regenerate player but keep health the same.
	int iHealth = GetEntProp(iClient, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(iClient);
	SetEntProp(iClient, Prop_Data, "m_iHealth", iHealth);
	SetEntProp(iClient, Prop_Send, "m_iHealth", iHealth);

	return Plugin_Stop;
}

bool DoesClientHaveConstantGlow(int client)
{
	return g_bPlayerConstantGlowEnabled[client];
}

void ClientDisableConstantGlow(int client)
{
	if (!DoesClientHaveConstantGlow(client)) return;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientDisableConstantGlow(%d)", client);
#endif
	
	g_bPlayerConstantGlowEnabled[client] = false;
	
	int iGlow = EntRefToEntIndex(g_iPlayerConstantGlowEntity[client]);
	if (iGlow && iGlow != INVALID_ENT_REFERENCE) 
	{
		int iGlowManager = GetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity");
		RemoveEntity(iGlow);
		if (iGlowManager > MaxClients)
		{
			RemoveEntity(iGlowManager);
		}
	}
	
	g_iPlayerConstantGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientDisableConstantGlow(%d)", client);
#endif
}

bool ClientEnableConstantGlow(int client, const char[] sAttachment="", int iColor[4] = {255, 255, 255, 255})
{
	if (DoesClientHaveConstantGlow(client)) return true;
	
	/*if (g_hClientGlowTimer[client] == null)
	{
		g_hClientGlowTimer[client] = CreateTimer(0.5, Timer_UpdateClientGlow, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		GetEntPropString(client, Prop_Data, "m_ModelName", g_sOldClientModel[client], sizeof(g_sOldClientModel[]));
	}*/
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientEnableConstantGlow(%d)", client);
#endif
	
	char sModel[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
	
	if (sModel[0] == '\0') 
	{
		// For some reason the model couldn't be found, so no.
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false (no model specified)", client);
#endif
		
		return false;
	}
	
	int iGlow = CreateEntityByName("tf_taunt_prop");
	if (iGlow != -1)
	{
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("tf_taunt_prop -> created");
#endif
	
		g_bPlayerConstantGlowEnabled[client] = true;
		g_iPlayerConstantGlowEntity[client] = EntIndexToEntRef(iGlow);

#if defined DEBUG
		float flModelScale = GetEntPropFloat(client, Prop_Send, "m_flModelScale");
		if (g_cvDebugDetail.IntValue > 2)
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
		DHookEntity(g_hSDKShouldTransmit, true, iGlowManager);
		DHookEntity(g_hSDKShouldTransmit, true, iGlow);
		//Set our desired glow color
		SetVariantColor(iColor);
		AcceptEntityInput(iGlowManager, "SetGlowColor");
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("tf_taunt_prop -> set model and model scale");
#endif
		
		// Set effect flags.
		int iFlags = GetEntProp(iGlow, Prop_Send, "m_fEffects");
		SetEntProp(iGlow, Prop_Send, "m_fEffects", iFlags | (1 << 0)); // EF_BONEMERGE
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("tf_taunt_prop -> set bonemerge flags");
#endif
		
		SetVariantString("!activator");
		AcceptEntityInput(iGlow, "SetParent", client);
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("tf_taunt_prop -> set parent to client");
#endif
		
		if (sAttachment[0] != '\0')
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(iGlow, "SetParentAttachment");
		}
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("tf_taunt_prop -> set parent attachment to %s", sAttachment);
#endif
		
		SetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity", iGlowManager);
		
		Network_HookEntity(iGlow);
		SDKHook(iGlow, SDKHook_SetTransmit, Hook_ConstantGlowSetTransmitVersion2);
		
#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false", client);
#endif
	
	return false;
}

public Action Timer_UpdateClientGlow(Handle timer, int userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0 || iClient > MaxClients)
	{
		for (int i = 1; i <= MaxClients; i++)//Find the previous client index owning that timer and reset it. 
		{
			if (g_hClientGlowTimer[i] == timer)
			{
				g_hClientGlowTimer[i] = null;
				break;
			}
		}
		return Plugin_Stop;
	}
	if (!IsClientInGame(iClient) || !IsPlayerAlive(iClient) || !DoesClientHaveConstantGlow(iClient))
	{
		g_hClientGlowTimer[iClient] = null;
		return Plugin_Stop;
	}
	
	char sClientModel[128];
	GetEntPropString(iClient, Prop_Data, "m_ModelName", sClientModel, sizeof(sClientModel));
	
	if (strcmp(sClientModel, g_sOldClientModel[iClient]) != 0)
	{
		ClientDisableConstantGlow(iClient);
		ClientEnableConstantGlow(iClient);
		strcopy(g_sOldClientModel[iClient], sizeof(g_sOldClientModel[]), sClientModel);
	}
	return Plugin_Continue;
}

public bool ClientGlowFilter(int iClient)
{
	if (g_bPlayerEliminated[iClient])
		return false;
	return true;
}

void ClientResetJumpScare(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetJumpScare(%d)", client);
#endif

	g_iPlayerJumpScareBoss[client] = -1;
	g_flPlayerJumpScareLifeTime[client] = -1.0;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetJumpScare(%d)", client);
#endif
}

void ClientDoJumpScare(int client,int iBossIndex, float flLifeTime)
{
	g_iPlayerJumpScareBoss[client] = NPCGetUniqueID(iBossIndex);
	g_flPlayerJumpScareLifeTime[client] = GetGameTime() + flLifeTime;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_jumpscare", sBuffer, sizeof(sBuffer), 1);
	
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
		g_bPlayerEliminated[client] || 
		DidClientEscape(client) || 
		g_bPlayerProxy[client] || 
		IsClientInGhostMode(client)) return;
	
	if (bSprint)
	{
		if (g_iPlayerSprintPoints[client] > 0)
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

//	==========================================================
//	DEATH CAM FUNCTIONS
//	==========================================================

bool IsClientInDeathCam(int client)
{
	return g_bPlayerDeathCam[client];
}

public Action Hook_DeathCamSetTransmit(int slender,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (EntRefToEntIndex(g_iPlayerDeathCamEnt2[other]) != slender) return Plugin_Handled;
	return Plugin_Continue;
}

void ClientResetDeathCam(int client)
{
	if (!IsClientInDeathCam(client)) return; // no really need to reset if it wasn't set.
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetDeathCam(%d)", client);
#endif
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	
	g_iPlayerDeathCamBoss[client] = -1;
	g_bPlayerDeathCam[client] = false;
	g_bPlayerDeathCamShowOverlay[client] = false;
	g_hPlayerDeathCamTimer[client] = null;
	
	int ent = EntRefToEntIndex(g_iPlayerDeathCamEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		g_bCameraDeathCamAdvanced[ent] = false;
		AcceptEntityInput(ent, "Disable");
		RemoveEntity(ent);
	}
	
	ent = EntRefToEntIndex(g_iPlayerDeathCamEnt2[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
	}
	
	ent = EntRefToEntIndex(g_iPlayerDeathCamTarget[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}
	
	g_iPlayerDeathCamEnt[client] = INVALID_ENT_REFERENCE;
	g_iPlayerDeathCamEnt2[client] = INVALID_ENT_REFERENCE;
	g_iPlayerDeathCamTarget[client] = INVALID_ENT_REFERENCE;
	
	if (IsClientInGame(client))
	{
		SetClientViewEntity(client, client);
	}
	
	Call_StartForward(fOnClientEndDeathCam);
	Call_PushCell(client);
	Call_PushCell(iDeathCamBoss);
	Call_Finish();
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetDeathCam(%d)", client);
#endif
}

void ClientStartDeathCam(int client,int iBossIndex, const float vecLookPos[3], bool bAnticamp = false)
{
	if (IsClientInDeathCam(client)) return;
	if (!NPCIsValid(iBossIndex)) return;

	GetClientAbsOrigin(client, g_vecPlayerOriginalDeathcamPosition[client]);
	
	char buffer[PLATFORM_MAX_PATH];
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (g_bSlenderDeathCamScareSound[iBossIndex])
	{
		GetRandomStringFromProfile(sProfile, "sound_scare_player", buffer, sizeof(buffer));
		if (buffer[0] != '\0' && !SF_SpecialRound(SPECIALROUND_REALISM)) EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	
	GetRandomStringFromProfile(sProfile, "sound_player_deathcam", buffer, sizeof(buffer));
	if (buffer[0] != '\0') 
	{
		EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death"
		if (g_b20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
		{
			GetRandomStringFromProfile(sProfile, "sound_player_death_20dollars", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
			}
		}
		else
		{
			GetRandomStringFromProfile(sProfile, "sound_player_death", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
			}
		}
	}
	
	GetRandomStringFromProfile(sProfile, "sound_player_deathcam_all", buffer, sizeof(buffer));
	if (buffer[0] != '\0') 
	{
		EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death_all"
		GetRandomStringFromProfile(sProfile, "sound_player_death_all", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
		}
	}

	// Call our forward.
	Call_StartForward(fOnClientCaughtByBoss);
	Call_PushCell(client);
	Call_PushCell(iBossIndex);
	Call_Finish();
	
	if (!NPCHasDeathCamEnabled(iBossIndex) && !(NPCGetFlags(iBossIndex) & SFF_FAKE))
	{
		SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol changes our lifestate.
		
		// TODO: Add more attributes!
		if (NPCHasAttribute(iBossIndex, "ignite player on death"))
		{
			float flValue = NPCGetAttributeValue(iBossIndex, "ignite player on death");
			if (flValue > 0.0) TF2_IgnitePlayer(client, client);
		}
	
		int iSlender = NPCGetEntIndex(iBossIndex);
		if (iSlender > MaxClients) SDKHooks_TakeDamage(client, iSlender, iSlender, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
		KillClient(client);
		return;
	}
	else if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
	}
	
	g_iPlayerDeathCamBoss[client] = NPCGetUniqueID(iBossIndex);
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
	int slender = SpawnSlenderModel(iBossIndex, vecLookPos, true);
	TeleportEntity(slender, vecLookPos, vecAng, NULL_VECTOR);
	g_iPlayerDeathCamEnt2[client] = EntIndexToEntRef(slender);
	if (!g_bSlenderPublicDeathCam[iBossIndex])
	{
		SDKHook(slender, SDKHook_SetTransmit, Hook_DeathCamSetTransmit);
	}
	else
	{
		GetRandomStringFromProfile(sProfile, "sound_player_deathcam_local", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
		}
		else
		{
			// Legacy support for "sound_player_death_local" cause why not 
			GetRandomStringFromProfile(sProfile, "sound_player_death_local", buffer, sizeof(buffer));
			if (buffer[0] != '\0') 
			{
				EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
			}
		}
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		if (!bAnticamp)
		{
			int slenderEnt = NPCGetEntIndex(iBossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_bSlenderInDeathcam[iBossIndex] = true;
				SetEntityRenderMode(slenderEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slenderEnt, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);
				NPCChaserUpdateBossAnimation(iBossIndex, slenderEnt, STATE_DEATHCAM);
				g_iSlenderDeathCamTarget[iBossIndex] = EntIndexToEntRef(client);
				g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderPublicDeathCamThink, EntIndexToEntRef(slenderEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	
	// Create camera look point.
	char sName[64];
	FormatEx(sName, sizeof(sName), "sf2_boss_%d", EntIndexToEntRef(slender));
	
	float flOffsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!g_bSlenderPublicDeathCam[iBossIndex])
	{
		GetProfileVector(sProfile, "death_cam_pos", flOffsetPos);
		AddVectors(vecLookPos, flOffsetPos, flOffsetPos);
		TeleportEntity(target, flOffsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", sName);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
	}
	else
	{
		char sBoneName[PLATFORM_MAX_PATH];
		AddVectors(vecLookPos, flOffsetPos, flOffsetPos);
		TeleportEntity(target, flOffsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", sName);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
		GetProfileString(sProfile, "death_cam_attachtment_target_point", sBoneName, sizeof(sBoneName));
		if (sBoneName[0] != '\0')
		{
			SetVariantString(sBoneName);
			AcceptEntityInput(target, "SetParentAttachment");
		}
	}
	g_iPlayerDeathCamTarget[client] = EntIndexToEntRef(target);
	
	// Create the camera itself.
	int camera = CreateEntityByName("point_viewcontrol");
	TeleportEntity(camera, eyePos, eyeAng, NULL_VECTOR);
	DispatchKeyValue(camera, "spawnflags", "12");
	DispatchKeyValue(camera, "target", sName);
	DispatchSpawn(camera);
	AcceptEntityInput(camera, "Enable", client);
	g_iPlayerDeathCamEnt[client] = EntIndexToEntRef(camera);
	if (g_bSlenderPublicDeathCam[iBossIndex])
	{
		float flCamSpeed, flCamAcceleration, flCamDeceleration;
		char sBuffer[PLATFORM_MAX_PATH];
		
		flCamSpeed = g_flSlenderPublicDeathCamSpeed[iBossIndex];
		flCamAcceleration = g_flSlenderPublicDeathCamAcceleration[iBossIndex];
		flCamDeceleration = g_flSlenderPublicDeathCamDeceleration[iBossIndex];
		FloatToString(flCamSpeed, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "acceleration", sBuffer);
		FloatToString(flCamAcceleration, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "deceleration", sBuffer);
		FloatToString(flCamDeceleration, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(camera, "speed", sBuffer);
		
		SetVariantString("!activator");
		AcceptEntityInput(camera, "SetParent", slender);
		char sAttachmentName[PLATFORM_MAX_PATH];
		GetProfileString(sProfile, "death_cam_attachtment_point", sAttachmentName, sizeof(sAttachmentName));
		if (sAttachmentName[0] != '\0')
		{
			SetVariantString(sAttachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}
		
		g_bCameraDeathCamAdvanced[camera] = true;
		g_flCameraPlayerOffsetBackward[camera] = g_flSlenderPublicDeathCamBackwardOffset[iBossIndex];
		g_flCameraPlayerOffsetDownward[camera] = g_flSlenderPublicDeathCamDownwardOffset[iBossIndex];
	}
	
	if (g_bSlenderDeathCamOverlay[iBossIndex] && g_flSlenderDeathCamOverlayTimeStart[iBossIndex] >= 0.0)
	{
		if (g_bSlenderPublicDeathCam[iBossIndex] && !bAnticamp) 
		{
			int iSlender = NPCGetEntIndex(iBossIndex);
			if (iSlender && iSlender != INVALID_ENT_REFERENCE)
			{
				g_hSlenderDeathCamTimer[iBossIndex] = CreateTimer(g_flSlenderDeathCamOverlayTimeStart[iBossIndex], Timer_BossDeathCamDelay, EntIndexToEntRef(iSlender), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_hPlayerDeathCamTimer[client] = CreateTimer(g_flSlenderDeathCamOverlayTimeStart[iBossIndex], Timer_ClientResetDeathCam1, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		if (g_bSlenderPublicDeathCam[iBossIndex] && !bAnticamp) 
		{
			int iSlender = NPCGetEntIndex(iBossIndex);
			if (iSlender && iSlender != INVALID_ENT_REFERENCE)
			{
				g_hSlenderDeathCamTimer[iBossIndex] = CreateTimer(g_flSlenderDeathCamTime[iBossIndex], Timer_BossDeathCamDuration, EntIndexToEntRef(iSlender), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_hPlayerDeathCamTimer[client] = CreateTimer(g_flSlenderDeathCamTime[iBossIndex], Timer_ClientResetDeathCamEnd, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
	
	Call_StartForward(fOnClientStartDeathCam);
	Call_PushCell(client);
	Call_PushCell(iBossIndex);
	Call_Finish();
}

public Action Timer_ClientResetDeathCam1(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerDeathCamTimer[client]) return Plugin_Stop;
	
	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]));

	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	if(Npc.IsValid())
	{
		g_bPlayerDeathCamShowOverlay[client] = true;
		Npc.GetProfile(sProfile, sizeof(sProfile));
		GetRandomStringFromProfile(sProfile, "sound_player_deathcam_overlay", buffer, sizeof(buffer));
		if (buffer[0] != '\0') 
		{
			EmitSoundToClient(client, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
		}
		g_hPlayerDeathCamTimer[client] = CreateTimer(g_flSlenderDeathCamTime[Npc.Index], Timer_ClientResetDeathCamEnd, userid, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

public Action Timer_BossDeathCamDelay(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	
	if (timer != g_hSlenderDeathCamTimer[iBossIndex]) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	g_hSlenderDeathCamTimer[iBossIndex] = CreateTimer(g_flSlenderDeathCamTime[iBossIndex], Timer_BossDeathCamDuration, slender, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

public Action Timer_BossDeathCamDuration(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);

	if (timer != g_hSlenderDeathCamTimer[iBossIndex]) return Plugin_Stop;

	if (g_bSlenderInDeathcam[iBossIndex])
	{
		SetEntityRenderMode(slender, RENDER_NORMAL);
		if (!NPCChaserIsCloaked(iBossIndex)) SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
		g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (!(NPCGetFlags(iBossIndex) & SFF_FAKE)) g_bSlenderInDeathcam[iBossIndex] = false;
		NPCChaserUpdateBossAnimation(iBossIndex, slender, g_iSlenderState[iBossIndex]);
	}
	if ((NPCGetFlags(iBossIndex) & SFF_FAKE))
	{
		if (g_bSlenderInDeathcam[iBossIndex])
		{
			g_bSlenderInDeathcam[iBossIndex] = false;
		}
		SlenderMarkAsFake(iBossIndex);
	}
	g_hSlenderDeathCamTimer[iBossIndex] = null;

	return Plugin_Stop;
}

public Action Timer_ClientResetDeathCamEnd(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerDeathCamTimer[client]) return Plugin_Stop;
	
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
	
	if (g_bPlayerEliminated[client]) return;
	
	if (newArea == INVALID_NAV_AREA) return;
	
	if ((oldArea != INVALID_NAV_AREA && oldArea.Attributes & NAV_MESH_DONT_HIDE) || newArea.Attributes & NAV_MESH_DONT_HIDE)
	{
		g_flClientAllowedTimeNearEscape[client] -= 0.3;//Remove 0.3sec this function is called every ~0.3sec
	}
	else
	{
		g_flClientAllowedTimeNearEscape[client] += 0.1;//Forgive the player of 0.1
	}
	if (g_flClientAllowedTimeNearEscape[client] <= 0.0 && SF_IsSurvivalMap())
	{
		g_bPlayerIsExitCamping[client] = true;
	}
	else
	{
		g_bPlayerIsExitCamping[client] = false;
	}
#if defined DEBUG
	SendDebugMessageToPlayer(client, DEBUG_NAV, 1, "Old area: %i DHF:%s, New area: %i DHF:%s, is considered as exit camper: %s", oldArea.Index, (oldArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", newArea.Index, (newArea.Attributes & NAV_MESH_DONT_HIDE) ? "true" : "false", (g_bPlayerIsExitCamping[client]) ? "true" : "false" );
#endif
}*/


//	==========================================================
//	GHOST MODE FUNCTIONS
//	==========================================================

static bool g_bPlayerGhostMode[MAXPLAYERS + 1] = { false, ... };
static int g_iPlayerGhostModeTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerGhostModeBossTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
Handle g_hPlayerGhostModeConnectionCheckTimer[MAXPLAYERS + 1] = { null, ... };
float g_flPlayerGhostModeConnectionTimeOutTime[MAXPLAYERS + 1] = { -1.0, ... };
float g_flPlayerGhostModeConnectionBootTime[MAXPLAYERS + 1] = { -1.0, ... };

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
		if(iDesiredClass == TFClass_Unknown) iDesiredClass = TFClass_Spy;
		
		//Set player's class to spy, this replaces old ghost mode mechanics.
		TF2_SetPlayerClass(client, TFClass_Spy);
		TF2_RegeneratePlayer(client);
		
		//Set player's old class as desired class.
		SetEntProp(client, Prop_Send, "m_iDesiredPlayerClass", iDesiredClass);
		
		ClientHandleGhostMode(client, true);
		if (g_cvGhostModeConnectionCheck.BoolValue)
		{
			g_hPlayerGhostModeConnectionCheckTimer[client] = CreateTimer(0.0, Timer_GhostModeConnectionCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_flPlayerGhostModeConnectionTimeOutTime[client] = -1.0;
			g_flPlayerGhostModeConnectionBootTime[client] = -1.0;
		}
		
		for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
		{	
			if (NPCGetUniqueID(iNPCIndex) == -1) continue;
			if (g_bSlenderInDeathcam[iNPCIndex]) continue;
			SlenderRemoveGlow(iNPCIndex);
			if (NPCGetCustomOutlinesState(iNPCIndex))
			{
				if (!NPCGetRainbowOutlineState(iNPCIndex))
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
				else SlenderAddGlow(iNPCIndex,_,view_as<int>({0, 0, 0, 0}));
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

		PvP_OnClientGhostModeEnable(client);
	}
	else
	{
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Exited ghost mode.");
#endif
		TF2Attrib_SetByName(client, "mod see enemy health", 0.0);
		g_hPlayerGhostModeConnectionCheckTimer[client] = null;
		g_flPlayerGhostModeConnectionTimeOutTime[client] = -1.0;
		g_flPlayerGhostModeConnectionBootTime[client] = -1.0;
	
		if (IsClientInGame(client))
		{
			SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_YES);
			TF2_RemoveCondition(client, TFCond_Stealthed);
			SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
			SetEntityGravity(client, 1.0);
			SetEntProp(client, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_PLAYER);
			SetEntProp(client, Prop_Data, "m_usSolidFlags", 16);
			SetEntProp(client, Prop_Send, "m_nSolidType", 2);
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
			//SetEntityMoveType(client, MOVETYPE_WALK);
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
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
	
	if (!TF2_IsPlayerInCondition(client, TFCond_Stealthed) || bForceSpawn)
	{
		TF2_StripWearables(client);
		SetEntityGravity(client, 0.5);
		TF2_AddCondition(client, TFCond_Stealthed, -1.0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_NO);
		SetEntData(client, g_offsCollisionGroup, 2, 4, true);
		GetEntProp(client, Prop_Send, "m_usSolidFlags", FSOLID_NOT_SOLID);
		GetEntProp(client, Prop_Data, "m_nSolidType", SOLID_NONE);
		SetEntProp(client, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS);
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
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
}

public Action Timer_ClientGhostStripWearables(Handle timer, int userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0 || iClient > MaxClients) return Plugin_Stop;
	if (!IsClientInGhostMode(iClient)) return Plugin_Stop;
	TF2_StripWearables(iClient);
	return Plugin_Stop;
}

void ClientGhostModeNextTarget(int client, bool bIgnoreSetting = false)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientGhostModeNextTarget(%d)", client);
#endif

	if (g_iPlayerPreferences[client].PlayerPreference_GhostModeTeleportState == 0 || bIgnoreSetting)
	{
		int iLastTarget = EntRefToEntIndex(g_iPlayerGhostModeTarget[client]);
		int iNextTarget = -1;
		int iFirstTarget = -1;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && (!g_bPlayerEliminated[i] || g_bPlayerProxy[i]) && !IsClientInGhostMode(i) && !DidClientEscape(i) && IsPlayerAlive(i))
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
			if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		#endif
	}
	else
	{
		int iLastTarget = NPCGetFromEntIndex(EntRefToEntIndex(g_iPlayerGhostModeBossTarget[client]));
		int iNextTarget = -1;
		int iFirstTarget = -1;
		for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
		{
			if (NPCGetUniqueID(iBossIndex) == -1 || !IsValidEntity(NPCGetEntIndex(iBossIndex))) continue;

			if (iFirstTarget == -1) iFirstTarget = iBossIndex;
			if (iBossIndex > iLastTarget) 
			{
				iNextTarget = iBossIndex;
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
			if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientGhostModeNextTarget(%d)", client);
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

void ClientPerformScare(int client,int iBossIndex)
{
	if (NPCGetUniqueID(iBossIndex) == -1)
	{
		LogError("Could not perform scare on client %d: boss does not exist!", client);
		return;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	g_flPlayerScareLastTime[client][iBossIndex] = GetGameTime();
	g_flPlayerScareNextTime[client][iBossIndex] = GetGameTime() + NPCGetScareCooldown(iBossIndex);
	
	// See how much Sanity should be drained from a scare.
	float flStaticAmount = GetProfileFloat(sProfile, "scare_static_amount", 0.0);
	g_flPlayerStaticAmount[client] += flStaticAmount;
	if (g_flPlayerStaticAmount[client] > 1.0) g_flPlayerStaticAmount[client] = 1.0;
	
	char sScareSound[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_scare_player", sScareSound, sizeof(sScareSound));
	
	if (sScareSound[0] != '\0')
	{
		if (!SF_SpecialRound(SPECIALROUND_REALISM)) EmitSoundToClient(client, sScareSound, _, MUSIC_CHAN, SNDLEVEL_NONE);
		
		if (NPCGetFlags(iBossIndex) & SFF_HASSIGHTSOUNDS)
		{
			float flCooldownMin = GetProfileFloat(sProfile, "sound_sight_cooldown_min", 8.0);
			float flCooldownMax = GetProfileFloat(sProfile, "sound_sight_cooldown_max", 14.0);
			
			g_flPlayerSightSoundNextTime[client][iBossIndex] = GetGameTime() + GetRandomFloat(flCooldownMin, flCooldownMax);
		}
		
		if (g_flPlayerStress[client] > 0.4)
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
		if (g_flPlayerStress[client] > 0.4)
		{
			ClientAddStress(client, 0.3);
		}
		else
		{
			ClientAddStress(client, 0.45);
		}
	}

	Call_StartForward(fOnClientScare);
	Call_PushCell(client);
	Call_PushCell(iBossIndex);
	Call_Finish();
}

void ClientPerformSightSound(int client,int iBossIndex)
{
	if (NPCGetUniqueID(iBossIndex) == -1)
	{
		LogError("Could not perform sight sound on client %d: boss does not exist!", client);
		return;
	}
	
	if (!(NPCGetFlags(iBossIndex) & SFF_HASSIGHTSOUNDS)) return;
	
	int iMaster = NPCGetFromUniqueID(g_iSlenderCopyMaster[iBossIndex]);
	if (iMaster == -1) iMaster = iBossIndex;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sSightSound[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_sight", sSightSound, sizeof(sSightSound));
	
	if (sSightSound[0] != '\0')
	{
		if (!SF_SpecialRound(SPECIALROUND_REALISM)) EmitSoundToClient(client, sSightSound, _, MUSIC_CHAN, SNDLEVEL_NONE);
		
		float flCooldownMin = GetProfileFloat(sProfile, "sound_sight_cooldown_min", 8.0);
		float flCooldownMax = GetProfileFloat(sProfile, "sound_sight_cooldown_max", 14.0);
		
		g_flPlayerSightSoundNextTime[client][iMaster] = GetGameTime() + GetRandomFloat(flCooldownMin, flCooldownMax);
		
		float flBossPos[3], flMyPos[3];
		int iBoss = NPCGetEntIndex(iBossIndex);
		GetClientAbsOrigin(client, flMyPos);
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flBossPos);
		float flDistUnComfortZone = 400.0;
		float flBossDist = GetVectorSquareMagnitude(flMyPos, flBossPos);
		
		float flStressScalar = 1.0 + ((SquareFloat(flDistUnComfortZone) / flBossDist));
		
		ClientAddStress(client, 0.1 * flStressScalar);
	}
}

void ClientResetScare(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetScare(%d)", client);
#endif

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_flPlayerScareNextTime[client][i] = -1.0;
		g_flPlayerScareLastTime[client][i] = -1.0;
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetScare(%d)", client);
#endif
}

//	==========================================================
//	ANTI-CAMPING FUNCTIONS
//	==========================================================

stock void ClientResetCampingStats(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetCampingStats(%d)", client);
#endif

	g_iPlayerCampingStrikes[client] = 0;
	g_bPlayerIsExitCamping[client] = false;
	g_hPlayerCampingTimer[client] = null;
	g_bPlayerCampingFirstTime[client] = true;
	g_flPlayerCampingLastPosition[client][0] = 0.0;
	g_flPlayerCampingLastPosition[client][1] = 0.0;
	g_flPlayerCampingLastPosition[client][2] = 0.0;
	g_flClientAllowedTimeNearEscape[client] = g_cvExitCampingTimeAllowed.FloatValue;
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetCampingStats(%d)", client);
#endif
}

void ClientStartCampingTimer(int client)
{
	g_hPlayerCampingTimer[client] = CreateTimer(5.0, Timer_ClientCheckCamp, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

//	==========================================================
//	BLINK FUNCTIONS
//	==========================================================

bool IsClientBlinking(int client)
{
	return g_bPlayerBlink[client];
}

float ClientGetBlinkMeter(int client)
{
	return g_flPlayerBlinkMeter[client];
}

void ClientSetBlinkMeter(int client, float amount)
{
	g_flPlayerBlinkMeter[client] = amount;
}

int ClientGetBlinkCount(int client)
{
	return g_iPlayerBlinkCount[client];
}

/**
 *	Resets all data on blinking.
 */
void ClientResetBlink(int client)
{
	g_hPlayerBlinkTimer[client] = null;
	g_bPlayerBlink[client] = false;
	g_bPlayerHoldingBlink[client] = false;
	g_flTimeUntilUnblink[client] = 0.0;
	g_flPlayerBlinkMeter[client] = 1.0;
	g_iPlayerBlinkCount[client] = 0;
}

/**
 *	Sets the player into a blinking state and blinds the player
 */
void ClientBlink(int client)
{
	if (IsRoundInWarmup() || DidClientEscape(client)) return;
	
	if (IsClientBlinking(client)) return;
	
	if (SF_IsRaidMap() || SF_IsBoxingMap()) return;
	
	g_bPlayerBlink[client] = true;
	g_iPlayerBlinkCount[client]++;
	g_flPlayerBlinkMeter[client] = 0.0;
	g_hPlayerBlinkTimer[client] = CreateTimer(0.0, Timer_TryUnblink, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_flTimeUntilUnblink[client] = GetGameTime() + g_cvPlayerBlinkHoldTime.FloatValue;
	
	UTIL_ScreenFade(client, 100, RoundToFloor(g_cvPlayerBlinkHoldTime.FloatValue * 1000.0), FFADE_IN, 0, 0, 0, 255);
	
	Call_StartForward(fOnClientBlink);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Unsets the player from the blinking state.
 */
void ClientUnblink(int client)
{
	if (!IsClientBlinking(client)) return;
	
	g_bPlayerBlink[client] = false;
	g_hPlayerBlinkTimer[client] = null;
	g_flPlayerBlinkMeter[client] = 1.0;
}

void ClientStartDrainingBlinkMeter(int client)
{
	g_hPlayerBlinkTimer[client] = CreateTimer(ClientGetBlinkRate(client), Timer_BlinkTimer, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_BlinkTimer(Handle timer, any userid)
{
	if (IsRoundInWarmup()) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerBlinkTimer[client]) return Plugin_Stop;
	
	if (IsPlayerAlive(client) && !IsClientInDeathCam(client) && !g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !IsRoundEnding())
	{
		int iOverride = g_cvPlayerInfiniteBlinkOverride.IntValue;
		if ((!g_bRoundInfiniteBlink && iOverride != 1) || iOverride == 0)
		{
			g_flPlayerBlinkMeter[client] -= 0.05;
		}
		
		if (g_flPlayerBlinkMeter[client] <= 0.0)
		{
			ClientBlink(client);
			return Plugin_Stop;
		}
	}
	
	return Plugin_Continue;
}

static Action Timer_TryUnblink(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0 || timer != g_hPlayerBlinkTimer[iClient] || !g_bPlayerBlink[iClient]) return Plugin_Stop;
	
	if (g_bPlayerHoldingBlink[iClient])
	{
		// Some maps use the env_fade entity, so don't use FFADE_PURGE.
		// Instead, we resort to spamming fade messages to the client to keep
		// them blind.
		UTIL_ScreenFade(iClient, 100, 150, FFADE_IN, 0, 0, 0, 255);
		return Plugin_Continue;
	}

	if (GetGameTime() < g_flTimeUntilUnblink[iClient])
	{
		return Plugin_Continue;
	}

	ClientUnblink(iClient);
	ClientStartDrainingBlinkMeter(iClient);

	return Plugin_Stop;
}

public Action Timer_BlinkTimer2(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerBlinkTimer[client]) return Plugin_Stop;
	
	ClientUnblink(client);
	ClientStartDrainingBlinkMeter(client);

	return Plugin_Stop;
}

float ClientGetBlinkRate(int client)
{
	float flValue = g_cvPlayerBlinkRate.FloatValue;
	if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 3) 
	{
		// Being underwater makes you blink faster, obviously.
		flValue *= 0.75;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;

		if (g_bPlayerSeesSlender[client][i]) 
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
	g_flPlayerStress[client] += flStressAmount;
	if (g_flPlayerStress[client] < 0.0) g_flPlayerStress[client] = 0.0;
	if (g_flPlayerStress[client] > 1.0) g_flPlayerStress[client] = 1.0;
	
	//PrintCenterText(client, "g_flPlayerStress[%d] = %f", client, g_flPlayerStress[client]);
	
	SlenderOnClientStressUpdate(client);
}

stock void ClientResetOverlay(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetOverlay(%d)", client);
#endif
	
	g_hPlayerOverlayCheck[client] = null;
	
	if (IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay \"\"");
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetOverlay(%d)", client);
#endif
}

public Action Timer_PlayerOverlayCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerOverlayCheck[client]) return Plugin_Stop;
	
	if (IsRoundInWarmup()) return Plugin_Continue;
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	int iJumpScareBoss = NPCGetFromUniqueID(g_iPlayerJumpScareBoss[client]);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	char sMaterial[PLATFORM_MAX_PATH];
	
	if (IsClientInDeathCam(client) && iDeathCamBoss != -1 && g_bPlayerDeathCamShowOverlay[client])
	{
		NPCGetProfile(iDeathCamBoss, sProfile, sizeof(sProfile));
		GetRandomStringFromProfile(sProfile, "overlay_player_death", sMaterial, sizeof(sMaterial), 1);
	}
	else if (iJumpScareBoss != -1 && GetGameTime() <= g_flPlayerJumpScareLifeTime[client])
	{
		NPCGetProfile(iJumpScareBoss, sProfile, sizeof(sProfile));
		GetRandomStringFromProfile(sProfile, "overlay_jumpscare", sMaterial, sizeof(sMaterial), 1);
	}
	else if (IsClientInGhostMode(client) && !SF_IsBoxingMap())
	{
		strcopy(sMaterial, sizeof(sMaterial), SF2_OVERLAY_GHOST);
	}
	else if (IsRoundInWarmup() || g_bPlayerEliminated[client] || DidClientEscape(client) && !IsClientInGhostMode(client))
	{
		return Plugin_Continue;
	}
	else if (SF_SpecialRound(SPECIALROUND_REALISM))
	{
		strcopy(sMaterial, sizeof(sMaterial), SF2_OVERLAY_MARBLEHORNETS);
	}
	else
	{
		if (!g_iPlayerPreferences[client].PlayerPreference_FilmGrain)
			strcopy(sMaterial, sizeof(sMaterial), SF2_OVERLAY_DEFAULT_NO_FILMGRAIN);
		else
			strcopy(sMaterial, sizeof(sMaterial), SF2_OVERLAY_DEFAULT);
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
	
	g_hConfig.Rewind();
	if (g_hConfig.JumpToKey(profileName))
	{
		char s[32];
		
		if (g_hConfig.JumpToKey(sectionName))
		{
			for (int i2 = 1;; i2++)
			{
				FormatEx(s, sizeof(s), "%d", i2);
				g_hConfig.GetString(s, buffer, sizeof(buffer));
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
		
		if (bReset || IsRoundEnding() || g_cvAllChat.BoolValue || SF_IsBoxingMap())
		{
			SetListenOverride(client, i, Listen_Default);
			continue;
		}

		if (g_bPlayerEliminated[client])
		{
			if (!g_bPlayerEliminated[i])
			{
				if (g_iPlayerPreferences[client].PlayerPreference_MuteMode == 1)
				{
					SetListenOverride(client, i, Listen_No);
				}
				else if (g_iPlayerPreferences[client].PlayerPreference_MuteMode == 2 && !g_bPlayerProxy[client])
				{
					SetListenOverride(client, i, Listen_No);
				}
				else if (g_iPlayerPreferences[client].PlayerPreference_MuteMode == 0)
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
			if (!g_bPlayerEliminated[i])
			{
				bool bCanHear = false;
				if (g_cvPlayerVoiceDistance.FloatValue <= 0.0) bCanHear = true;
					
				if (!bCanHear)
				{
					float flMyPos[3], flHisPos[3];
					GetClientEyePosition(client, flMyPos);
					GetClientEyePosition(i, flHisPos);
						
					float flDist = GetVectorSquareMagnitude(flMyPos, flHisPos);
						
					if (g_cvPlayerVoiceWallScale.FloatValue > 0.0)
					{
						Handle hTrace = TR_TraceRayFilterEx(flMyPos, flHisPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitCharacters);
						bool bDidHit = TR_DidHit(hTrace);
						delete hTrace;
							
						if (bDidHit)
						{
							flDist *= SquareFloat(g_cvPlayerVoiceWallScale.FloatValue);
						}
					}
						
					if (flDist <= SquareFloat(g_cvPlayerVoiceDistance.FloatValue))
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
	ShowSyncHudText(client, g_hHudSync, message);
}

stock void ClientShowRenevantMessage(int client, const char[] sMessage, any ...)
{
	char message[512];
	VFormat(message, sizeof(message), sMessage, 3);
	
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
	ShowSyncHudText(client, g_hHudSync, message);
}

stock void ClientResetSlenderStats(int client)
{
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START ClientResetSlenderStats(%d)", client);
#endif
	
	g_flPlayerStress[client] = 0.0;
	g_flPlayerStressNextUpdateTime[client] = -1.0;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_bPlayerSeesSlender[client][i] = false;
		g_flPlayerSeesSlenderLastTime[client][i] = -1.0;
		g_flPlayerSightSoundNextTime[client][i] = -1.0;
		g_bPlayerScaredByBoss[client][i] = false;
	}
	
#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END ClientResetSlenderStats(%d)", client);
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
	FormatEx(s, sizeof(s), "%d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d", g_iPlayerQueuePoints[client], 
		g_iPlayerPreferences[client].PlayerPreference_PvPAutoSpawn, 
		g_iPlayerPreferences[client].PlayerPreference_ShowHints, 
		g_iPlayerPreferences[client].PlayerPreference_MuteMode,
		g_iPlayerPreferences[client].PlayerPreference_FilmGrain,
		g_iPlayerPreferences[client].PlayerPreference_EnableProxySelection,
		g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature,
		g_iPlayerPreferences[client].PlayerPreference_PvPSpawnProtection,
		g_iPlayerPreferences[client].PlayerPreference_ProxyShowMessage,
		g_iPlayerPreferences[client].PlayerPreference_ViewBobbing,
		g_iPlayerPreferences[client].PlayerPreference_GhostModeToggleState,
		g_iPlayerPreferences[client].PlayerPreference_GroupOutline,
		g_iPlayerPreferences[client].PlayerPreference_GhostModeTeleportState);
		
	SetClientCookie(client, g_hCookie, s);
}

stock void ClientViewPunch(int client, const float angleOffset[3])
{
	if (g_offsPlayerPunchAngleVel == -1) return;
	
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
	GetEntDataVector(client, g_offsPlayerPunchAngleVel, flAngleVel);
	AddVectors(flAngleVel, flOffset, flOffset);
	SetEntDataVector(client, g_offsPlayerPunchAngleVel, flOffset, true);
}

public Action Hook_ConstantGlowSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;
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

		if (!SF_SpecialRound(SPECIALROUND_DEBUGMODE) && !IsClientInGhostMode(other) && !g_bPlayerProxy[other])
		{
			if (iOwner == other) return Plugin_Handled;
		
			if (!IsPlayerAlive(iOwner) || !IsPlayerAlive(other) || !g_bPlayerEliminated[other] || !SF_SpecialRound(SPECIALROUND_DEBUGMODE)) 
			{
				return Plugin_Handled;
			}
		}
		
		if (IsClientInGhostMode(other) || g_bPlayerProxy[other])
		{
			return Plugin_Continue;
		}
		
		if (SF_SpecialRound(SPECIALROUND_DEBUGMODE) && !g_bPlayerEscaped[other] && GetClientTeam(other) == TFTeam_Red)
		{
			return Plugin_Continue;
		}
		
		if (g_bPlayerProxy[other])
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
					float flOwnerPos[3], flProxyPos[3];
					GetClientEyePosition(iOwner, flOwnerPos);
					GetClientEyePosition(other, flProxyPos);
					
					if (GetVectorSquareMagnitude(flOwnerPos, flProxyPos) <= SquareFloat((700.0 + ((g_bPlayerHasRegenerationItem[iOwner]) ? 300.0 : 0.0))))//To-do add a cvar for that.
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
	if (!g_bEnabled) return Plugin_Continue;

	int iOwner = GetEntPropEnt(ent, Prop_Send, "moveparent");
	if (iOwner == other) return Plugin_Handled;
	if (!IsValidClient(other)) return Plugin_Handled;
	if (!IsPlayerAlive(other)) return Plugin_Handled;
	if (g_bPlayerProxy[other]) return Plugin_Continue;
	if (IsClientInGhostMode(other)) return Plugin_Continue;
	if (SF_SpecialRound(SPECIALROUND_DEBUGMODE) && ((GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other]) || (g_bPlayerProxy[other]))) return Plugin_Continue;
	return Plugin_Handled;
}

stock void ClientSetFOV(int client,int iFOV)
{
	SetEntData(client, g_offsPlayerFOV, iFOV);
	SetEntData(client, g_offsPlayerDefaultFOV, iFOV);
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

stock bool IsPointVisibleToPlayer(int client, const float pos[3], bool bCheckFOV=true, bool bCheckBlink=false, bool bCheckEliminated=true)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client)) return false;
	
	if (bCheckEliminated && g_bPlayerEliminated[client]) return false;
	
	if (bCheckBlink && IsClientBlinking(client)) return false;
	
	float eyePos[3];
	GetClientEyePosition(client, eyePos);
	
	// Check fog, if we can.
	if (g_offsPlayerFogCtrl != -1 && g_offsFogCtrlEnable != -1 && g_offsFogCtrlEnd != -1)
	{
		int iFogEntity = GetEntDataEnt2(client, g_offsPlayerFogCtrl);
		if (IsValidEdict(iFogEntity))
		{
			if (GetEntData(iFogEntity, g_offsFogCtrlEnable) &&
				GetVectorSquareMagnitude(eyePos, pos) >= SquareFloat(GetEntDataFloat(iFogEntity, g_offsFogCtrlEnd))) 
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
		
		float flFOV = float(g_iPlayerDesiredFOV[client]);
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

	if (SF_SpecialRound(SPECIALROUND_1UP) && g_bPlayerIn1UpCondition[client] && !DidClientEscape(client) && !IsRoundEnding() && !IsRoundInWarmup() && !IsRoundInIntro() && !g_bRoundGrace) 
	{
		g_bPlayerDied1Up[client] = true;
		g_bPlayerIn1UpCondition[client] = false;
		EmitSoundToClient(client, SPECIAL1UPSOUND);
	}
	
	TF2_RespawnPlayer(client);

	return Plugin_Stop;
}

#include "sf2/functionclients/clients_think.sp"
#include "sf2/functionclients/client_flashlight.sp"
#include "sf2/functionclients/client_music.sp"
#include "sf2/functionclients/client_proxy_functions.sp"