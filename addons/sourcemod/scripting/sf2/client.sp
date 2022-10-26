#if defined _sf2_client_included
 #endinput
#endif
#define _sf2_client_included

#pragma semicolon 1

#define SF2_OVERLAY_DEFAULT "overlays/slender/newcamerahud_3"
#define SF2_OVERLAY_DEFAULT_NO_FILMGRAIN "overlays/slender/nofilmgrain"
#define SF2_OVERLAY_GHOST "overlays/slender/ghostcamera"
#define SF2_OVERLAY_MARBLEHORNETS "overlays/slender/marblehornetsoverlay"

#define SF2_ULTRAVISION_WIDTH 800.0
#define SF2_ULTRAVISION_LENGTH 800.0
#define SF2_ULTRAVISION_BRIGHTNESS -4 // Intensity of Ultravision.

#define SF2_PLAYER_BREATH_COOLDOWN_MIN 0.8
#define SF2_PLAYER_BREATH_COOLDOWN_MAX 2.0

#define SF2_FLASHLIGHT_WIDTH 512.0 // How wide the player's Flashlight should be in world units.
#define SF2_FLASHLIGHT_BRIGHTNESS 0 // Intensity of the players' Flashlight.
#define SF2_FLASHLIGHT_DRAIN_RATE 0.65 // How long (in seconds) each bar on the player's Flashlight meter lasts.
#define SF2_FLASHLIGHT_RECHARGE_RATE 0.68 // How long (in seconds) it takes each bar on the player's Flashlight meter to recharge.
#define SF2_FLASHLIGHT_FLICKERAT 0.25 // The percentage of the Flashlight battery where the Flashlight will start to blink.
#define SF2_FLASHLIGHT_ENABLEAT 0.3 // The percentage of the Flashlight battery where the Flashlight will be able to be used again (if the player shortens out the Flashlight from excessive use).
#define SF2_FLASHLIGHT_COOLDOWN 0.4 // How much time players have to wait before being able to switch their flashlight on again after turning it off.

char g_strPlayerBreathSounds[][] =
{
	"slender/fastbreath1.wav"
};

//Client Special Round Timer
static Handle g_ClientSpecialRoundTimer[MAXPLAYERS + 1];

// Deathcam data.
static int g_PlayerDeathCamBoss[MAXPLAYERS + 1] = { -1, ... };
static bool g_PlayerDeathCam[MAXPLAYERS + 1] = { false, ... };
static bool g_PlayerDeathCamShowOverlay[MAXPLAYERS + 1] = { false, ... };
int g_PlayerDeathCamEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamEnt2[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerDeathCamTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static Handle g_PlayerDeathCamTimer[MAXPLAYERS + 1] = { null, ... };
bool g_CameraInDeathCamAdvanced[2049] = { false, ... };
float g_CameraPlayerOffsetBackward[2049] = { 0.0, ... };
float g_CameraPlayerOffsetDownward[2049] = { 0.0, ... };
static float g_vecPlayerOriginalDeathcamPosition[MAXPLAYERS + 1][3];

// Ultravision data.
bool g_PlayerHasUltravision[MAXPLAYERS + 1] = { false, ... };
int g_PlayerUltravisionEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Sprint data.
static bool g_PlayerSprint[MAXPLAYERS + 1] = { false, ... };
int g_PlayerSprintPoints[MAXPLAYERS + 1] = { 100, ... };
Handle g_PlayerSprintTimer[MAXPLAYERS + 1] = { null, ... };

// Blink data.
static Handle g_PlayerBlinkTimer[MAXPLAYERS + 1] = { null, ... };
static bool g_PlayerBlink[MAXPLAYERS + 1] = { false, ... };
bool g_PlayerHoldingBlink[MAXPLAYERS + 1] = { false, ... };
static float g_PlayerBlinkMeter[MAXPLAYERS + 1] = { 0.0, ... };
static float g_TimeUntilUnblink[MAXPLAYERS + 1] = { 0.0, ... };
static int g_PlayerBlinkCount[MAXPLAYERS + 1] = { 0, ... };

// Breathing data.
bool g_PlayerBreath[MAXPLAYERS + 1] = { false, ... };
static Handle g_PlayerBreathTimer[MAXPLAYERS + 1] = { null, ... };

// Interactive glow data.
static int g_PlayerInteractiveGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerInteractiveGlowTargetEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Constant glow data.
static int g_PlayerGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static bool g_PlayerConstantGlowEnabled[MAXPLAYERS + 1] = { false, ... };

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

MRESReturn Hook_ClientWantsLagCompensationOnEntity(int client, DHookReturn returnHandle, DHookParam params)
{
	if (!g_Enabled || IsFakeClient(client))
	{
		return MRES_Ignored;
	}

	returnHandle.Value = true;
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

Action Hook_HealthKitOnTouch(int healthKit, int client)
{
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		TFClassType class = TF2_GetPlayerClass(client);
		int classToInt = view_as<int>(class);
		if (!SF_IsBoxingMap())
		{
			if (!IsClassConfigsValid())
			{
				if (!g_PlayerEliminated[client] && TF2_GetPlayerClass(client) == TFClass_Medic)
				{
					return Plugin_Handled;
				}
			}
			else
			{
				if (!g_ClassCanPickUpHealth[classToInt])
				{
					return Plugin_Handled;
				}
			}
		}
		if (IsClientInGhostMode(client))
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

Action Hook_ClientSetTransmit(int client,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (other == client)
	{
		return Plugin_Continue;
	}

	if (g_PlayerEliminated[client])
	{
		if (IsClientInGhostMode(client))
		{
			return Plugin_Handled;
		}

		if (IsClientInPvP(client))
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
	else
	{
		if (SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
		{
			if (!g_PlayerEliminated[other] && !DidClientEscape(other))
			{
				return Plugin_Handled;
			}
		}
	}

	return Plugin_Continue;
}

public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponName, bool &result)
{
	if (!g_Enabled || g_RestartSessionEnabled || g_PlayerEliminated[client])
	{
		return Plugin_Continue;
	}

	int entity = GetClientAimTarget(client, false);
	if (entity > MaxClients)
	{
		char buffer[64];
		if (GetEntityClassname(entity, buffer, sizeof(buffer)) && StrContains(buffer, "prop_dynamic") == 0)
		{
			if (GetEntPropString(entity, Prop_Data, "m_iName", buffer, sizeof(buffer)) && StrContains(buffer, "sf2_page", false) == 0)
			{
				float pos1[3], pos2[3];
				GetClientEyePosition(client, pos1);
				GetEntPropVector(entity, Prop_Data, "m_vecOrigin", pos2);

				if (GetVectorDistance(pos1, pos2, true) < 2500.0)
				{
					CollectPage(entity, client);
				}
			}
		}
	}

	return Plugin_Continue;
}

void Hook_ClientWeaponEquipPost(int client, int weapon)
{
	if (!IsValidClient(client) || !IsClientInGame(client) || !IsValidEdict(weapon))
	{
		return;
	}
	g_DHookWeaponGetCustomDamageType.HookEntity(Hook_Pre, weapon, Hook_WeaponGetCustomDamageType);
}

Action Hook_TEFireBullets(const char[] te_name,const int[] players,int numClients, float delay)
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
	g_PlayerStaticIncreaseRate[client] = 0.0;
	g_PlayerStaticDecreaseRate[client] = 0.0;
	g_PlayerLastStaticTimer[client] = null;
	g_PlayerLastStaticTime[client] = 0.0;
	g_PlayerLastStaticVolume[client] = 0.0;
	g_PlayerInStaticShake[client] = false;
	g_PlayerStaticShakeMaster[client] = -1;
	g_PlayerStaticShakeMinVolume[client] = 0.0;
	g_PlayerStaticShakeMaxVolume[client] = 0.0;
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
		switch (NPCGetType(npcIndex))
		{
			case SF2BossType_Chaser:
			{
				if (g_SlenderState[npcIndex] == STATE_CHASE && EntRefToEntIndex(g_SlenderTarget[npcIndex]) == client)
				{
					g_SlenderGiveUp[npcIndex] = true;
				}
			}
		}
	}

	// Speed recalculation. Props to the creators of FF2/VSH for this snippet.
	TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.001);
	TF2Attrib_RemoveByDefIndex(client, 49);
	SetEntProp(client, Prop_Send, "m_iAirDash", 0);

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

Action Timer_TeleportPlayerToEscapePoint(Handle timer, any userid)
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

float ClientGetDistanceFromEntity(int client,int entity)
{
	float startPos[3], endPos[3];
	GetClientAbsOrigin(client, startPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", endPos);
	return GetVectorSquareMagnitude(startPos, endPos);
}

float ClientGetDefaultWalkSpeed(int client, TFClassType class = TFClass_Unknown)
{
	float returnFloat = 190.0;
	float returnFloat2 = returnFloat;
	Action action = Plugin_Continue;
	if (IsValidClient(client))
	{
		class = TF2_GetPlayerClass(client);
	}

	switch (class)
	{
		case TFClass_Scout:
		{
			returnFloat = 190.0;
		}
		case TFClass_Sniper:
		{
			returnFloat = 190.0;
		}
		case TFClass_Soldier:
		{
			returnFloat = 190.0;
		}
		case TFClass_DemoMan:
		{
			returnFloat = 190.0;
		}
		case TFClass_Heavy:
		{
			returnFloat = 190.0;
		}
		case TFClass_Medic:
		{
			returnFloat = 190.0;
		}
		case TFClass_Pyro:
		{
			returnFloat = 190.0;
		}
		case TFClass_Spy:
		{
			returnFloat = 190.0;
		}
		case TFClass_Engineer:
		{
			returnFloat = 190.0;
		}
	}

	if (IsValidClient(client))
	{
		// Call our forward.
		Call_StartForward(g_OnClientGetDefaultWalkSpeedFwd);
		Call_PushCell(client);
		Call_PushCellRef(returnFloat2);
		Call_Finish(action);
	}

	if (action == Plugin_Changed)
	{
		returnFloat = returnFloat2;
	}

	return returnFloat;
}

float ClientGetDefaultSprintSpeed(int client, TFClassType class = TFClass_Unknown)
{
	float returnFloat = 340.0;
	float returnFloat2 = returnFloat;
	Action action = Plugin_Continue;
	if (IsValidClient(client))
	{
		class = TF2_GetPlayerClass(client);
	}

	switch (class)
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
			returnFloat = 290.0;
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

	if (IsValidClient(client))
	{
		// Call our forward.
		Call_StartForward(g_OnClientGetDefaultSprintSpeedFwd);
		Call_PushCell(client);
		Call_PushCellRef(returnFloat2);
		Call_Finish(action);
	}

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

	bool oldStaticShake = g_PlayerInStaticShake[client];
	int oldStaticShakeMaster = NPCGetFromUniqueID(g_PlayerStaticShakeMaster[client]);
	int newStaticShakeMaster = -1;

	float oldPunchAng[3], oldPunchAngVel[3];
	GetEntDataVector(client, g_PlayerPunchAngleOffset, oldPunchAng);
	GetEntDataVector(client, g_PlayerPunchAngleOffsetVel, oldPunchAngVel);

	float newPunchAng[3], newPunchAngVel[3];

	for (int i = 0; i < 3; i++)
	{
		newPunchAng[i] = oldPunchAng[i];
		newPunchAngVel[i] = oldPunchAngVel[i];
	}

	if (newStaticShakeMaster != -1)
	{
		g_PlayerStaticShakeMaster[client] = NPCGetUniqueID(newStaticShakeMaster);

		if (newStaticShakeMaster != oldStaticShakeMaster)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(newStaticShakeMaster, profile, sizeof(profile));

			if (g_PlayerStaticShakeSound[client][0] != '\0')
			{
				StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
			}

			g_PlayerStaticShakeMinVolume[client] = GetBossProfileStaticShakeLocalVolumeMin(profile);
			g_PlayerStaticShakeMaxVolume[client] = GetBossProfileStaticShakeLocalVolumeMax(profile);

			char staticSound[PLATFORM_MAX_PATH];
			GetBossProfileStaticShakeSound(profile, staticSound, sizeof(staticSound));
			if (staticSound[0] != '\0')
			{
				strcopy(g_PlayerStaticShakeSound[client], sizeof(g_PlayerStaticShakeSound[]), staticSound);
			}
			else
			{
				g_PlayerStaticShakeSound[client][0] = '\0';
			}
		}
	}

	if (g_PlayerInStaticShake[client])
	{
		if (g_PlayerStaticAmount[client] <= 0.0)
		{
			g_PlayerInStaticShake[client] = false;
		}
	}
	else
	{
		if (newStaticShakeMaster != -1)
		{
			g_PlayerInStaticShake[client] = true;
		}
	}

	if (g_PlayerInStaticShake[client] && !oldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = 0.0;
			newPunchAngVel[i] = 0.0;
		}

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}
	else if (!g_PlayerInStaticShake[client] && oldStaticShake)
	{
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = 0.0;
			newPunchAngVel[i] = 0.0;
		}

		g_PlayerStaticShakeMaster[client] = -1;

		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerStaticShakeSound[client]);
		}

		g_PlayerStaticShakeSound[client][0] = '\0';

		g_PlayerStaticShakeMinVolume[client] = 0.0;
		g_PlayerStaticShakeMaxVolume[client] = 0.0;

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}

	if (g_PlayerInStaticShake[client])
	{
		if (g_PlayerStaticShakeSound[client][0] != '\0')
		{
			float volume = g_PlayerStaticAmount[client];
			if (GetRandomFloat(0.0, 1.0) <= 0.35)
			{
				volume = 0.0;
			}
			else
			{
				if (volume < g_PlayerStaticShakeMinVolume[client])
				{
					volume = g_PlayerStaticShakeMinVolume[client];
				}

				if (volume > g_PlayerStaticShakeMaxVolume[client])
				{
					volume = g_PlayerStaticShakeMaxVolume[client];
				}
			}

			EmitSoundToClient(client, g_PlayerStaticShakeSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL | SND_STOP, volume);
		}

		// Spazz our view all over the place.
		for (int i = 0; i < 2; i++)
		{
			newPunchAng[i] = AngleNormalize(GetRandomFloat(0.0, 360.0));
		}
		NormalizeVector(newPunchAng, newPunchAng);

		float angVelocityScalar = 5.0 * g_PlayerStaticAmount[client];
		if (angVelocityScalar < 1.0)
		{
			angVelocityScalar = 1.0;
		}
		ScaleVector(newPunchAng, angVelocityScalar);

		for (int i = 0; i < 2; i++)
		{
			newPunchAngVel[i] = 0.0;
		}

		SetEntDataVector(client, g_PlayerPunchAngleOffset, newPunchAng, true);
		SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, newPunchAngVel, true);
	}
}

void ClientProcessVisibility(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH], masterProfile[SF2_MAX_PROFILE_NAME_LENGTH];

	bool wasSeeingSlender[MAX_BOSSES];
	int oldStaticMode[MAX_BOSSES];

	float slenderPos[3];
	float slenderEyePos[3];
	float slenderOBBCenterPos[3];

	float myPos[3];
	GetClientAbsOrigin(client, myPos);

	int difficulty = g_DifficultyConVar.IntValue;

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		wasSeeingSlender[i] = g_PlayerSeesSlender[client][i];
		oldStaticMode[i] = g_PlayerStaticMode[client][i];
		g_PlayerSeesSlender[client][i] = false;
		g_PlayerStaticMode[client][i] = Static_None;

		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		NPCGetProfile(i, profile, sizeof(profile));

		int boss = NPCGetEntIndex(i);

		if (boss && boss != INVALID_ENT_REFERENCE)
		{
			SlenderGetAbsOrigin(i, slenderPos);
			NPCGetEyePosition(i, slenderEyePos);

			float slenderMins[3], slenderMaxs[3];
			GetEntPropVector(boss, Prop_Send, "m_vecMins", slenderMins);
			GetEntPropVector(boss, Prop_Send, "m_vecMaxs", slenderMaxs);

			for (int i2 = 0; i2 < 3; i2++)
			{
				slenderOBBCenterPos[i2] = slenderPos[i2] + ((slenderMins[i2] + slenderMaxs[i2]) / 2.0);
			}
		}

		if (IsClientInGhostMode(client))
		{
		}
		else if (!IsClientInDeathCam(client))
		{
			if (boss && boss != INVALID_ENT_REFERENCE)
			{
				int copyMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);

				if (!IsPointVisibleToPlayer(client, slenderEyePos, true, SlenderUsesBlink(i)))
				{
					g_PlayerSeesSlender[client][i] = IsPointVisibleToPlayer(client, slenderOBBCenterPos, true, SlenderUsesBlink(i));
				}
				else
				{
					g_PlayerSeesSlender[client][i] = true;
				}

				if ((GetGameTime() - g_PlayerSeesSlenderLastTime[client][i]) > g_SlenderStaticGraceTime[i][difficulty] ||
					(oldStaticMode[i] == Static_Increase && g_PlayerStaticAmount[client] > 0.1))
				{
					if ((NPCGetFlags(i) & SFF_STATICONLOOK) &&
						g_PlayerSeesSlender[client][i])
					{
						if (copyMaster != -1)
						{
							g_PlayerStaticMode[client][copyMaster] = Static_Increase;
						}
						else
						{
							g_PlayerStaticMode[client][i] = Static_Increase;
						}
					}
					else if ((NPCGetFlags(i) & SFF_STATICONRADIUS) &&
						GetVectorSquareMagnitude(myPos, slenderPos) <= SquareFloat(g_SlenderStaticRadius[i][difficulty]))
					{
						bool noObstacles = IsPointVisibleToPlayer(client, slenderEyePos, false, false);
						if (!noObstacles)
						{
							noObstacles = IsPointVisibleToPlayer(client, slenderOBBCenterPos, false, false);
						}

						if (noObstacles)
						{
							if (copyMaster != -1)
							{
								g_PlayerStaticMode[client][copyMaster] = Static_Increase;
							}
							else
							{
								g_PlayerStaticMode[client][i] = Static_Increase;
							}
						}
					}
				}

				// Process death cam sequence with static
				if (g_PlayerStaticAmount[client] >= 1.0)
				{
					ClientStartDeathCam(client, NPCGetFromUniqueID(g_PlayerStaticMaster[client]), slenderPos, true);
				}
			}
		}

		int master = NPCGetFromUniqueID(g_SlenderCopyMaster[i]);
		if (master == -1)
		{
			master = i;
		}

		NPCGetProfile(master, masterProfile, sizeof(masterProfile));

		// Boss visiblity.
		if (g_PlayerSeesSlender[client][i] && !wasSeeingSlender[i])
		{
			g_PlayerSeesSlenderLastTime[client][master] = GetGameTime();

			if (GetGameTime() >= g_PlayerScareNextTime[client][master])
			{
				g_PlayerScaredByBoss[client][master] = false;
				if (GetVectorSquareMagnitude(myPos, slenderPos) <= SquareFloat(NPCGetScareRadius(i)))
				{
					ClientPerformScare(client, master);

					if (NPCGetSpeedBoostOnScare(master))
					{
						TF2_AddCondition(client, TFCond_SpeedBuffAlly, NPCGetScareSpeedBoostDuration(master), client);
					}

					if (NPCGetScareReactionState(master))
					{
						switch (NPCGetScareReactionType(master))
						{
							case 1:
							{
								SpeakResponseConcept(client, "TLK_PLAYER_SPELL_METEOR_SWARM");
							}
							case 2:
							{
								SpeakResponseConcept(client, "HalloweenLongFall");
							}
							case 3:
							{
								char scareReactionCustom[PLATFORM_MAX_PATH];
								GetBossProfileScareReactionCustom(masterProfile, scareReactionCustom, sizeof(scareReactionCustom));
								SpeakResponseConcept(client, scareReactionCustom);
							}
						}
					}

					if (NPCGetScareReplenishSprintState(master))
					{
						int clientSprintPoints = ClientGetSprintPoints(client);
						g_PlayerSprintPoints[client] = clientSprintPoints + NPCGetScareReplenishSprintAmount(master);
					}

					float value = NPCGetAttributeValue(master, SF2Attribute_IgnitePlayerOnScare);
					if (value > 0.0)
					{
						TF2_IgnitePlayer(client, client);
					}
					value = NPCGetAttributeValue(master, SF2Attribute_MarkPlayerForDeathOnScare);
					if (value > 0.0)
					{
						TF2_AddCondition(client, TFCond_MarkedForDeath, value);
					}
					value = NPCGetAttributeValue(master, SF2Attribute_SilentMarkPlayerForDeathOnScare);
					if (value > 0.0)
					{
						TF2_AddCondition(client, TFCond_MarkedForDeathSilent, value);
					}
					if (NPCHasAttribute(master, SF2Attribute_ChaseTargetOnScare))
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
							SlenderPerformVoice(i, _, SF2BossSound_ChaseInitial);
							if (NPCChaserCanUseChaseInitialAnimation(i) && !g_NpcUsesChaseInitialAnimation[i] && !SF_IsSlaughterRunMap())
							{
								if (g_SlenderChaseInitialTimer[i] == null)
								{
									CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
									g_NpcUsesChaseInitialAnimation[i] = true;
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									NPCChaserUpdateBossAnimation(i, slender, g_SlenderState[i]);
									g_SlenderChaseInitialTimer[i] = CreateTimer(g_SlenderAnimationDuration[i], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
								}
							}
							else
							{
								if (i != -1 && slender && slender != INVALID_ENT_REFERENCE)
								{
									NPCChaserUpdateBossAnimation(i, slender, g_SlenderState[i]);
								}
							}
							g_PlayerScaredByBoss[client][i] = true;
							SlenderAlertAllValidBosses(i, client, client);
						}
					}
					if (NPCGetJumpscareOnScare(master))
					{
						float jumpScareDuration = NPCGetJumpscareDuration(master, difficulty);
						ClientDoJumpScare(client, master, jumpScareDuration);
					}
				}
				else
				{
					g_PlayerScareNextTime[client][master] = GetGameTime() + NPCGetScareCooldown(master);
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
		else if (!g_PlayerSeesSlender[client][i] && wasSeeingSlender[i])
		{
			g_PlayerScareLastTime[client][master] = GetGameTime();

			Call_StartForward(g_OnClientLooksAwayFromBossFwd);
			Call_PushCell(client);
			Call_PushCell(i);
			Call_Finish();
		}

		if (g_PlayerSeesSlender[client][i])
		{
			if (GetGameTime() >= g_PlayerSightSoundNextTime[client][master])
			{
				ClientPerformSightSound(client, i);
			}
		}

		if (g_PlayerStaticMode[client][i] == Static_Increase &&
			oldStaticMode[i] != Static_Increase)
		{
			if (NPCGetFlags(i) & SFF_HASSTATICLOOPLOCALSOUND)
			{
				char loopSound[PLATFORM_MAX_PATH];
				GetBossProfileStaticLocalSound(profile, loopSound, sizeof(loopSound));

				if (loopSound[0] != '\0')
				{
					EmitSoundToClient(client, loopSound, boss, SNDCHAN_STATIC, GetBossProfileStaticShakeLocalLevel(profile), SND_CHANGEVOL, 1.0);
					ClientAddStress(client, 0.03);
				}
			}
		}
		else if (g_PlayerStaticMode[client][i] != Static_Increase &&
			oldStaticMode[i] == Static_Increase)
		{
			if (NPCGetFlags(i) & SFF_HASSTATICLOOPLOCALSOUND)
			{
				if (boss && boss != INVALID_ENT_REFERENCE)
				{
					char loopSound[PLATFORM_MAX_PATH];
					GetBossProfileStaticLocalSound(profile, loopSound, sizeof(loopSound));

					if (loopSound[0] != '\0')
					{
						EmitSoundToClient(client, loopSound, boss, SNDCHAN_STATIC, _, SND_CHANGEVOL | SND_STOP, 0.0);
					}
				}
			}
		}
	}

	// Initialize static timers.
	int bossLastStatic = NPCGetFromUniqueID(g_PlayerStaticMaster[client]);
	int bossNewStatic = -1;
	if (bossLastStatic != -1 && g_PlayerStaticMode[client][bossLastStatic] == Static_Increase)
	{
		bossNewStatic = bossLastStatic;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		int staticMode = g_PlayerStaticMode[client][i];

		// Determine new static rates.
		if (staticMode != Static_Increase)
		{
			continue;
		}

		if (bossLastStatic == -1 ||
			g_PlayerStaticMode[client][bossLastStatic] != Static_Increase)
		{
			bossNewStatic = i;
		}
	}

	if (bossNewStatic != -1)
	{
		int copyMaster = NPCGetFromUniqueID(g_SlenderCopyMaster[bossNewStatic]);
		if (copyMaster != -1)
		{
			bossNewStatic = copyMaster;
			g_PlayerStaticMaster[client] = NPCGetUniqueID(copyMaster);
		}
		else
		{
			g_PlayerStaticMaster[client] = NPCGetUniqueID(bossNewStatic);
		}
	}
	else
	{
		g_PlayerStaticMaster[client] = -1;
	}

	if (bossNewStatic != bossLastStatic)
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

		if (bossNewStatic == -1)
		{
			// No one is the static master.
			g_PlayerStaticTimer[client] = CreateTimer(g_PlayerStaticDecreaseRate[client],
				Timer_ClientDecreaseStatic,
				GetClientUserId(client),
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			TriggerTimer(g_PlayerStaticTimer[client], true);
		}
		else
		{
			NPCGetProfile(bossNewStatic, profile, sizeof(profile));

			g_PlayerStaticSound[client][0] = '\0';

			char staticSound[PLATFORM_MAX_PATH];
			GetBossProfileStaticSound(profile, staticSound, sizeof(staticSound));

			if (staticSound[0] != '\0')
			{
				strcopy(g_PlayerStaticSound[client], sizeof(g_PlayerStaticSound[]), staticSound);
			}

			// Cross-fade out the static sounds.
			g_PlayerLastStaticVolume[client] = g_PlayerStaticAmount[client];
			g_PlayerLastStaticTime[client] = GetGameTime();

			g_PlayerLastStaticTimer[client] = CreateTimer(0.0,
				Timer_ClientFadeOutLastStaticSound,
				GetClientUserId(client),
				TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			TriggerTimer(g_PlayerLastStaticTimer[client], true);

			// Start up our own static timer.
			float staticIncreaseRate = (g_SlenderStaticRate[bossNewStatic][difficulty] - (g_SlenderStaticRate[bossNewStatic][difficulty] * g_RoundDifficultyModifier)/10);
			float staticDecreaseRate = (g_SlenderStaticRateDecay[bossNewStatic][difficulty] + (g_SlenderStaticRateDecay[bossNewStatic][difficulty] * g_RoundDifficultyModifier)/10);
			if (!IsClassConfigsValid())
			{
				if (class == TFClass_Heavy)
				{
					staticIncreaseRate *= 1.15;
					staticDecreaseRate *= 0.85;
				}
				else if (class == TFClass_Sniper)
				{
					staticDecreaseRate *= 1.05;
					staticDecreaseRate *= 0.9;
				}
				else if (class == TFClass_Engineer)
				{
					staticIncreaseRate *= 0.9;
				}
				else if (class == TFClass_Scout)
				{
					staticIncreaseRate *= 0.85;
					staticDecreaseRate *= 1.15;
				}
				else if (class == TFClass_Soldier)
				{
					staticIncreaseRate *= 1.05;
					staticDecreaseRate *= 0.95;
				}
			}
			else
			{
				staticIncreaseRate *= g_ClassResistanceStaticIncrease[classToInt];
				staticDecreaseRate *= g_ClassResistanceStaticDecrease[classToInt];
			}

			g_PlayerStaticIncreaseRate[client] = staticIncreaseRate;
			g_PlayerStaticDecreaseRate[client] = staticDecreaseRate;

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
				float punchVel[3];

				if (!g_PlayerViewbobSprintEnabled || !IsClientReallySprinting(client))
				{
					if (GetEntityFlags(client) & FL_ONGROUND)
					{
						float velocity[3];
						GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);
						float speed = GetVectorLength(velocity);

						float punchIdle[3];

						if (speed > 0.0)
						{
							if (speed >= 60.0)
							{
								punchIdle[0] = Sine(GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * speed * SF2_PLAYER_VIEWBOB_SCALE_X / 400.0;
								punchIdle[1] = Sine(2.0 * GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * speed * SF2_PLAYER_VIEWBOB_SCALE_Y / 400.0;
								punchIdle[2] = Sine(1.6 * GetGameTime() * SF2_PLAYER_VIEWBOB_TIMER) * speed * SF2_PLAYER_VIEWBOB_SCALE_Z / 400.0;

								AddVectors(punchVel, punchIdle, punchVel);
							}

							// Calculate roll.
							float forwardFloat[3], velocityDirection[3];
							GetClientEyeAngles(client, forwardFloat);
							GetVectorAngles(velocity, velocityDirection);

							float yawDiff = AngleDiff(forwardFloat[1], velocityDirection[1]);
							if (FloatAbs(yawDiff) > 90.0)
							{
								yawDiff = AngleDiff(forwardFloat[1] + 180.0, velocityDirection[1]) * -1.0;
							}

							float walkSpeed = ClientGetDefaultWalkSpeed(client);
							float rollScalar = speed / walkSpeed;
							if (rollScalar > 1.0)
							{
								rollScalar = 1.0;
							}

							float rollScale = (yawDiff / 90.0) * 0.25 * rollScalar;
							punchIdle[0] = 0.0;
							punchIdle[1] = 0.0;
							punchIdle[2] = rollScale * -1.0;

							AddVectors(punchVel, punchIdle, punchVel);
						}

						/*
						if (speed < 60.0)
						{
							punchIdle[0] = FloatAbs(Cosine(GetGameTime() * 1.25) * 0.047);
							punchIdle[1] = Sine(GetGameTime() * 1.25) * 0.075;
							punchIdle[2] = 0.0;

							AddVectors(punchVel, punchIdle, punchVel);
						}
						*/
					}
				}

				if (g_PlayerViewbobHurtEnabled)
				{
					// Shake screen the more the player is hurt.
					float health = float(GetEntProp(client, Prop_Send, "m_iHealth"));
					float maxHealth = float(SDKCall(g_SDKGetMaxHealth, client));

					float punchVelHurt[3];
					punchVelHurt[0] = Sine(1.22 * GetGameTime()) * 48.5 * ((maxHealth - health) / (maxHealth * 0.75)) / maxHealth;
					punchVelHurt[1] = Sine(2.12 * GetGameTime()) * 80.0 * ((maxHealth - health) / (maxHealth * 0.75)) / maxHealth;
					punchVelHurt[2] = Sine(0.5 * GetGameTime()) * 36.0 * ((maxHealth - health) / (maxHealth * 0.75)) / maxHealth;

					AddVectors(punchVel, punchVelHurt, punchVel);
				}

				ClientViewPunch(client, punchVel);
			}
		}
	}
}

static Action Timer_ClientIncreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerStaticTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerStaticAmount[client] += 0.05;
	if (g_PlayerStaticAmount[client] > 1.0)
	{
		g_PlayerStaticAmount[client] = 1.0;
	}

	if (g_PlayerStaticSound[client][0] != '\0')
	{
		EmitSoundToClient(client, g_PlayerStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, g_PlayerStaticAmount[client]);

		if (g_PlayerStaticAmount[client] >= 0.5)
		{
			ClientAddStress(client, 0.03);
		}
		else
		{
			ClientAddStress(client, 0.02);
		}
	}

	return Plugin_Continue;
}

Action Timer_ClientDecreaseStatic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerStaticTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerStaticAmount[client] -= 0.05;
	if (g_PlayerStaticAmount[client] < 0.0)
	{
		g_PlayerStaticAmount[client] = 0.0;
	}

	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float volume = g_PlayerStaticAmount[client];
		if (volume > 0.0)
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, volume);
		}
	}

	if (g_PlayerStaticAmount[client] <= 0.0)
	{
		// I've done my job; no point to keep on doing it.
		if (g_PlayerLastStaticSound[client][0] != '\0')
		{
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
		}
		g_PlayerStaticTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

static Action Timer_ClientFadeOutLastStaticSound(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerLastStaticTimer[client])
	{
		return Plugin_Stop;
	}

	if (strcmp(g_PlayerLastStaticSound[client], g_PlayerStaticSound[client], false) == 0)
	{
		// Wait, the player's current static sound is the same one we're stopping. Abort!
		g_PlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}

	if (g_PlayerLastStaticSound[client][0] != '\0')
	{
		float diff = (GetGameTime() - g_PlayerLastStaticTime[client]) / 1.0;
		if (diff > 1.0)
		{
			diff = 1.0;
		}

		float volume = g_PlayerLastStaticVolume[client] - diff;
		if (volume < 0.0)
		{
			volume = 0.0;
		}

		if (volume <= 0.0)
		{
			// I've done my job; no point to keep on doing it.
			StopSound(client, SNDCHAN_STATIC, g_PlayerLastStaticSound[client]);
			g_PlayerLastStaticTimer[client] = null;
			return Plugin_Stop;
		}
		else
		{
			EmitSoundToClient(client, g_PlayerLastStaticSound[client], _, SNDCHAN_STATIC, SNDLEVEL_NONE, SND_CHANGEVOL, volume);
		}
	}
	else
	{
		// I've done my job; no point to keep on doing it.
		g_PlayerLastStaticTimer[client] = null;
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

//	==========================================================
//	SPECIAL ROUND FUNCTIONS
//	==========================================================

void ClientSetSpecialRoundTimer(int client, float time, Timer callback, any data, int flags=0)
{
	g_ClientSpecialRoundTimer[client] = CreateTimer(time, callback, data, flags);
}

Action Timer_ClientPageDetector(Handle timer, int userid)
{
	if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR))
	{
		return Plugin_Stop;
	}
	if (GetRoundState() == SF2RoundState_Escape)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (g_ClientSpecialRoundTimer[client] != timer)
	{
		return Plugin_Stop;
	}

	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if (g_PlayerEliminated[client])
	{
		return Plugin_Stop;
	}

	int closestPageEntIndex = -1;

	float distance = SquareFloat(99999.0);
	float clientPos[3], pagePos[3];
	GetClientAbsOrigin(client, clientPos);

	ArrayList pageEntities = new ArrayList();
	GetPageEntities(pageEntities);

	for (int i = 0; i < pageEntities.Length; i++)
	{
		CBaseEntity pageEnt = CBaseEntity(pageEntities.Get(i));
		pageEnt.GetAbsOrigin(pagePos);

		float squareDistance = GetVectorSquareMagnitude(clientPos, pagePos);

		if (closestPageEntIndex == -1 || squareDistance < distance)
		{
			closestPageEntIndex = pageEnt.index;
			distance = squareDistance;
		}
	}

	delete pageEntities;

	float nextBeepTime = distance/SquareFloat(800.0);

	if (nextBeepTime > 5.0)
	{
		nextBeepTime = 5.0;
	}
	if (nextBeepTime < 0.1)
	{
		nextBeepTime = 0.1;
	}

	EmitSoundToClient(client, PAGE_DETECTOR_BEEP, _, _, _, _, _, 100 - RoundToNearest(nextBeepTime * 10.0));
	g_ClientSpecialRoundTimer[client] = CreateTimer(nextBeepTime, Timer_ClientPageDetector, userid, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

//	==========================================================
//	INTERACTIVE GLOW FUNCTIONS
//	==========================================================

void ClientProcessInteractiveGlow(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client) || (g_PlayerEliminated[client] && !g_PlayerProxy[client]) || IsClientInGhostMode(client))
	{
		return;
	}

	int oldLookEntity = EntRefToEntIndex(g_PlayerInteractiveGlowTargetEntity[client]);

	float startPos[3], myEyeAng[3];
	GetClientEyePosition(client, startPos);
	GetClientEyeAngles(client, myEyeAng);

	Handle trace = TR_TraceRayFilterEx(startPos, myEyeAng, MASK_VISIBLE, RayType_Infinite, TraceRayDontHitPlayers, -1);
	int entity = TR_GetEntityIndex(trace);
	delete trace;

	if (IsValidEntity(entity))
	{
		g_PlayerInteractiveGlowTargetEntity[client] = EntRefToEntIndex(entity);
	}
	else
	{
		g_PlayerInteractiveGlowTargetEntity[client] = INVALID_ENT_REFERENCE;
	}

	if (entity != oldLookEntity)
	{
		ClientRemoveInteractiveGlow(client);

		if (IsEntityClassname(entity, "prop_dynamic", false) || IsEntityClassname(entity, "tf_taunt_prop", false))
		{
			char targetName[64];
			GetEntPropString(entity, Prop_Data, "m_iName", targetName, sizeof(targetName));

			if (StrContains(targetName, "sf2_page", false) == 0 || StrContains(targetName, "sf2_interact", false) == 0)
			{
				ClientCreateInteractiveGlow(client, entity);
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
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientRemoveInteractiveGlow(%d)", client);
	}
	#endif

	int ent = EntRefToEntIndex(g_PlayerInteractiveGlowEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(ent);
	}

	g_PlayerInteractiveGlowEntity[client] = INVALID_ENT_REFERENCE;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientRemoveInteractiveGlow(%d)", client);
	}
	#endif
}

/**
 *	Creates an interactive glow for an entity to show to a player.
 */
static bool ClientCreateInteractiveGlow(int client,int entity, const char[] attachment="")
{
	ClientRemoveInteractiveGlow(client);

	if (!IsClientInGame(client))
	{
		return false;
	}

	if (!entity || !IsValidEdict(entity))
	{
		return false;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientCreateInteractiveGlow(%d)", client);
	}
	#endif

	char buffer[PLATFORM_MAX_PATH];
	GetEntPropString(entity, Prop_Data, "m_ModelName", buffer, sizeof(buffer));

	if (buffer[0] == '\0')
	{
		return false;
	}

	int ent = CreateEntityByName("tf_taunt_prop");
	if (ent != -1)
	{
		g_PlayerInteractiveGlowEntity[client] = EntIndexToEntRef(ent);

		float modelScale = GetEntPropFloat(entity, Prop_Send, "m_flModelScale");

		SetEntityModel(ent, buffer);
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		SetEntityRenderColor(ent, 0, 0, 0, 0);
		SetEntPropFloat(ent, Prop_Send, "m_flModelScale", modelScale);

		int flags = GetEntProp(ent, Prop_Send, "m_fEffects");
		SetEntProp(ent, Prop_Send, "m_fEffects", flags | (1 << 0));
		SetEntProp(ent, Prop_Send, "m_bGlowEnabled", true);

		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", entity);

		if (attachment[0] != '\0')
		{
			SetVariantString(attachment);
			AcceptEntityInput(ent, "SetParentAttachment");
		}

		SDKHook(ent, SDKHook_SetTransmit, Hook_InterativeGlowSetTransmit);

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("END ClientCreateInteractiveGlow(%d) -> true", client);
		}
		#endif

		return true;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientCreateInteractiveGlow(%d) -> false", client);
	}
	#endif

	return false;
}

static Action Hook_InterativeGlowSetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (EntRefToEntIndex(g_PlayerInteractiveGlowEntity[other]) != ent)
	{
		return Plugin_Handled;
	}

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

static float ClientCalculateBreathingCooldown(int client)
{
	float average = 0.0;
	int averageNum = 0;

	// Sprinting only, for now.
	average += (SF2_PLAYER_BREATH_COOLDOWN_MAX * 6.7765 * Pow((float(g_PlayerSprintPoints[client]) / 100.0), 1.65));
	averageNum++;

	average /= float(averageNum);

	if (average < SF2_PLAYER_BREATH_COOLDOWN_MIN)
	{
		average = SF2_PLAYER_BREATH_COOLDOWN_MIN;
	}

	return average;
}

void ClientStartBreathing(int client)
{
	g_PlayerBreath[client] = true;
	g_PlayerBreathTimer[client] = CreateTimer(ClientCalculateBreathingCooldown(client), Timer_ClientBreath, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

static void ClientStopBreathing(int client)
{
	g_PlayerBreath[client] = false;
	g_PlayerBreathTimer[client] = null;
}

bool ClientCanBreath(int client)
{
	return view_as<bool>(ClientCalculateBreathingCooldown(client) < SF2_PLAYER_BREATH_COOLDOWN_MAX);
}

static Action Timer_ClientBreath(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerBreathTimer[client])
	{
		return Plugin_Stop;
	}

	if (!g_PlayerBreath[client])
	{
		return Plugin_Stop;
	}

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
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetSprint(%d)", client);
	}
	#endif

	bool wasSprinting = IsClientSprinting(client);

	g_PlayerSprint[client] = false;
	g_PlayerSprintPoints[client] = 100;
	g_PlayerSprintTimer[client] = null;

	if (IsValidClient(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);

		ClientSetFOV(client, g_PlayerDesiredFOV[client]);
	}

	if (wasSprinting)
	{
		Call_StartForward(g_OnClientStopSprintingFwd);
		Call_PushCell(client);
		Call_Finish();
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetSprint(%d)", client);
	}
	#endif
}

void ClientStartSprint(int client)
{
	if (IsClientSprinting(client))
	{
		return;
	}

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

void ClientSprintTimer(int client, bool recharge=false)
{
	float rate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 0.38 : 0.28;
	if (recharge)
	{
		rate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 1.4 : 0.8;
	}

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	float velocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);

	if (recharge)
	{
		if (!(GetEntityFlags(client) & FL_ONGROUND))
		{
			rate *= 0.75;
		}
		else if (GetVectorLength(velocity, true) == 0.0)
		{
			if (GetEntProp(client, Prop_Send, "m_bDucked"))
			{
				rate *= 0.66;
			}
			else
			{
				rate *= 0.75;
			}
		}
	}
	else
	{
		if (!IsClassConfigsValid())
		{
			if (class == TFClass_DemoMan)
			{
				rate *= 1.15;
			}
			else if (class == TFClass_Medic || class == TFClass_Spy)
			{
				rate *= 1.05;
			}
			else if (class == TFClass_Scout)
			{
				rate *= 1.08;
			}
		}
		else
		{
			rate *= g_ClassSprintDurationMultipler[classToInt];
		}
	}

	if (recharge)
	{
		g_PlayerSprintTimer[client] = CreateTimer(rate, Timer_ClientRechargeSprint, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		g_PlayerSprintTimer[client] = CreateTimer(rate, Timer_ClientSprinting, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}

void ClientStopSprint(int client)
{
	if (!IsClientSprinting(client))
	{
		return;
	}
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
	if (!IsClientSprinting(client))
	{
		return false;
	}
	if (!(GetEntityFlags(client) & FL_ONGROUND))
	{
		return false;
	}

	float velocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);
	if (GetVectorLength(velocity, true) < SquareFloat(30.0))
	{
		return false;
	}

	return true;
}

//	==========================================================
//	GHOST AND GLOW FUNCTIONS
//	==========================================================

Action Timer_ClassScramblePlayer(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);

	if (client <= 0 || DidClientEscape(client) || g_PlayerEliminated[client] || !IsPlayerAlive(client) || IsClientInGhostMode(client) || g_PlayerProxy[client])
	{
		return Plugin_Stop;
	}
	g_PlayerRandomClassNumber[client] = GetRandomInt(1, 9);

	// Regenerate player but keep health the same.
	int health = GetEntProp(client, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(client);
	SetEntProp(client, Prop_Data, "m_iHealth", health);
	SetEntProp(client, Prop_Send, "m_iHealth", health);

	return Plugin_Stop;
}

Action Timer_ClassScramblePlayer2(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);

	if (client <= 0 || DidClientEscape(client) || g_PlayerEliminated[client] || !IsPlayerAlive(client) || IsClientInGhostMode(client) || g_PlayerProxy[client])
	{
		return Plugin_Stop;
	}

	// Regenerate player but keep health the same.
	int health = GetEntProp(client, Prop_Send, "m_iHealth");
	TF2_RegeneratePlayer(client);
	SetEntProp(client, Prop_Data, "m_iHealth", health);
	SetEntProp(client, Prop_Send, "m_iHealth", health);

	return Plugin_Stop;
}

bool DoesClientHaveConstantGlow(int client)
{
	return g_PlayerConstantGlowEnabled[client];
}

void ClientDisableConstantGlow(int client)
{
	if (!DoesClientHaveConstantGlow(client))
	{
		return;
	}

	int glow = EntRefToEntIndex(g_PlayerGlowEntity[client]);
	if (glow != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(glow);
		g_PlayerGlowEntity[client] = INVALID_ENT_REFERENCE;
	}

	g_PlayerConstantGlowEnabled[client] = false;
}

void ClientEnableConstantGlow(int client, int color[4] = {255, 255, 255, 255})
{
	if (!IsValidClient(client))
	{
		return;
	}

	if (DoesClientHaveConstantGlow(client) || g_PlayerGlowEntity[client] != INVALID_ENT_REFERENCE)
	{
		return;
	}

	char model[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", model, sizeof(model));

	if (model[0] == '\0')
	{
		// For some reason the model couldn't be found, so no.
		return;
	}

	int glow = TF2_CreateGlow(client);
	if (IsValidEntity(glow))
	{
		g_PlayerConstantGlowEnabled[client] = true;

		SDKHook(glow, SDKHook_SetTransmit, Hook_ConstantGlowSetTransmit);

		g_PlayerGlowEntity[client] = EntIndexToEntRef(glow);
		//Set our desired glow color
		SetVariantColor(color);
		AcceptEntityInput(glow, "SetGlowColor");
		SetEntityTransmitState(glow, FL_EDICT_FULLCHECK);
		g_DHookShouldTransmit.HookEntity(Hook_Pre, glow, Hook_EntityShouldTransmit);
		g_DHookUpdateTransmitState.HookEntity(Hook_Pre, glow, Hook_GlowUpdateTransmitState);
	}
}

void ClientResetJumpScare(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetJumpScare(%d)", client);
	}
	#endif

	g_PlayerJumpScareBoss[client] = -1;
	g_PlayerJumpScareLifeTime[client] = -1.0;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetJumpScare(%d)", client);
	}
	#endif
}

void ClientDoJumpScare(int client,int bossIndex, float flLifeTime)
{
	g_PlayerJumpScareBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerJumpScareLifeTime[client] = GetGameTime() + flLifeTime;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	GetBossProfileJumpscareSound(profile, buffer, sizeof(buffer));

	if (buffer[0] != '\0')
	{
		EmitSoundToClient(client, buffer, _, MUSIC_CHAN);
	}
}

 /**
  *	Handles sprinting upon player input.
  */
void ClientHandleSprint(int client, bool sprint)
{
	if (!IsPlayerAlive(client) ||
		g_PlayerEliminated[client] ||
		DidClientEscape(client) ||
		g_PlayerProxy[client] ||
		IsClientInGhostMode(client))
	{
		return;
	}

	if (sprint)
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
	return g_PlayerDeathCam[client];
}

static Action Hook_DeathCamSetTransmit(int slender,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (EntRefToEntIndex(g_PlayerDeathCamEnt2[other]) != slender)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

void ClientResetDeathCam(int client)
{
	if (!IsClientInDeathCam(client))
	{
		return; // no really need to reset if it wasn't set.
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetDeathCam(%d)", client);
	}
	#endif

	int deathCamBoss = NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]);

	g_PlayerDeathCamBoss[client] = -1;
	g_PlayerDeathCam[client] = false;
	g_PlayerDeathCamShowOverlay[client] = false;
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
	Call_PushCell(deathCamBoss);
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetDeathCam(%d)", client);
	}
	#endif
}

void ClientStartDeathCam(int client,int bossIndex, const float vecLookPos[3], bool antiCamp = false)
{
	if (IsClientInDeathCam(client))
	{
		return;
	}
	if (!NPCIsValid(bossIndex))
	{
		return;
	}

	for (int npcIndex; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		switch (NPCGetType(npcIndex))
		{
			case SF2BossType_Chaser:
			{
				if (g_SlenderState[npcIndex] == STATE_CHASE && EntRefToEntIndex(g_SlenderTarget[npcIndex]) == client)
				{
					g_SlenderGiveUp[npcIndex] = true;
				}
			}
		}
	}

	GetClientAbsOrigin(client, g_vecPlayerOriginalDeathcamPosition[client]);

	char buffer[PLATFORM_MAX_PATH];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	ArrayList soundList;
	SF2BossProfileSoundInfo soundInfo;
	if (g_SlenderDeathCamScareSound[bossIndex])
	{
		GetBossProfileScareSounds(profile, soundInfo);
		soundList = soundInfo.Paths;
		if (soundList != null && soundList.Length > 0)
		{
			soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
			}
		}
		soundList = null;
	}

	GetBossProfileClientDeathCamSounds(profile, soundInfo);
	soundList = soundInfo.Paths;
	if (soundList != null && soundList.Length > 0)
	{
		soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
		if (buffer[0] != '\0')
		{
			EmitSoundToClient(client, buffer, _, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
		}
	}
	soundList = null;

	GetBossProfileGlobalDeathCamSounds(profile, soundInfo);
	soundList = soundInfo.Paths;
	if (soundList != null && soundList.Length > 0)
	{
		soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
		if (buffer[0] != '\0')
		{
			EmitSoundToAll(buffer, _, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
		}
	}
	soundList = null;

	// Call our forward.
	Call_StartForward(g_OnClientCaughtByBossFwd);
	Call_PushCell(client);
	Call_PushCell(bossIndex);
	Call_Finish();

	if (!NPCHasDeathCamEnabled(bossIndex) && !(NPCGetFlags(bossIndex) & SFF_FAKE))
	{
		SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol changes our lifestate.

		float value = NPCGetAttributeValue(bossIndex, SF2Attribute_IgnitePlayerOnDeath);
		if (value > 0.0)
		{
			TF2_IgnitePlayer(client, client);
		}

		int slenderEnt = NPCGetEntIndex(bossIndex);
		if (slenderEnt > MaxClients)
		{
			SDKHooks_TakeDamage(client, slenderEnt, slenderEnt, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		}
		SDKHooks_TakeDamage(client, 0, 0, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		ForcePlayerSuicide(client);//Sometimes SDKHooks_TakeDamage doesn't work (probably because of point_viewcontrol), the player is still alive and result in a endless round.
		KillClient(client);
		return;
	}
	else if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
	}

	g_PlayerDeathCamBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerDeathCam[client] = true;
	g_PlayerDeathCamShowOverlay[client] = false;

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
		GetBossProfileLocalDeathCamSounds(profile, soundInfo);
		soundList = soundInfo.Paths;
		if (soundList != null && soundList.Length > 0)
		{
			soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
			}
		}
		soundList = null;
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		if (!antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderInDeathcam[bossIndex] = true;
				SetEntityRenderMode(slenderEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slenderEnt, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
				NPCChaserUpdateBossAnimation(bossIndex, slenderEnt, STATE_DEATHCAM);
				g_SlenderDeathCamTarget[bossIndex] = EntIndexToEntRef(client);
				if (g_SlenderEntityThink[bossIndex] != null)
				{
					KillTimer(g_SlenderEntityThink[bossIndex]);
				}
				g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderPublicDeathCamThink, EntIndexToEntRef(slenderEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}

	// Create camera look point.
	char name[64];
	FormatEx(name, sizeof(name), "sf2_boss_%d", EntIndexToEntRef(slender));

	float offsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!g_SlenderPublicDeathCam[bossIndex])
	{
		GetBossProfileDeathCamPosition(profile, offsetPos);
		AddVectors(vecLookPos, offsetPos, offsetPos);
		TeleportEntity(target, offsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
	}
	else
	{
		char boneName[PLATFORM_MAX_PATH];
		AddVectors(vecLookPos, offsetPos, offsetPos);
		TeleportEntity(target, offsetPos, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(target, "targetname", name);
		SetVariantString("!activator");
		AcceptEntityInput(target, "SetParent", slender);
		GetBossProfilePublicDeathCamTargetAttachment(profile, boneName, sizeof(boneName));
		if (boneName[0] != '\0')
		{
			SetVariantString(boneName);
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
		float camSpeed, camAcceleration, camDeceleration;

		camSpeed = g_SlenderPublicDeathCamSpeed[bossIndex];
		camAcceleration = g_SlenderPublicDeathCamAcceleration[bossIndex];
		camDeceleration = g_SlenderPublicDeathCamDeceleration[bossIndex];
		FloatToString(camSpeed, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "acceleration", buffer);
		FloatToString(camAcceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "deceleration", buffer);
		FloatToString(camDeceleration, buffer, sizeof(buffer));
		DispatchKeyValue(camera, "speed", buffer);

		SetVariantString("!activator");
		AcceptEntityInput(camera, "SetParent", slender);
		char attachmentName[PLATFORM_MAX_PATH];
		GetBossProfilePublicDeathCamAttachment(profile, attachmentName, sizeof(attachmentName));
		if (attachmentName[0] != '\0')
		{
			SetVariantString(attachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}

		g_CameraInDeathCamAdvanced[camera] = true;
		g_CameraPlayerOffsetBackward[camera] = g_SlenderPublicDeathCamBackwardOffset[bossIndex];
		g_CameraPlayerOffsetDownward[camera] = g_SlenderPublicDeathCamDownwardOffset[bossIndex];
		RequestFrame(Frame_PublicDeathCam, camera); //Resend taunt sound to eliminated players only
	}

	if (g_SlenderDeathCamOverlay[bossIndex] && g_SlenderDeathCamOverlayTimeStart[bossIndex] >= 0.0)
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_BossDeathCamDelay, EntIndexToEntRef(slenderEnt), TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamOverlayTimeStart[bossIndex], Timer_ClientResetDeathCam1, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		if (g_SlenderPublicDeathCam[bossIndex] && !antiCamp)
		{
			int slenderEnt = NPCGetEntIndex(bossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_SlenderDeathCamTimer[bossIndex] = CreateTimer(g_SlenderDeathCamTime[bossIndex], Timer_BossDeathCamDuration, EntIndexToEntRef(slenderEnt), TIMER_FLAG_NO_MAPCHANGE);
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

static void Frame_PublicDeathCam(int cameraRef)
{
	int camera = EntRefToEntIndex(cameraRef);
	if (IsValidEntity(camera))
	{
		int slender = GetEntPropEnt(camera, Prop_Data, "m_hOwnerEntity");
		int client = GetEntPropEnt(camera, Prop_Data, "m_hPlayer");
		if (IsValidEntity(slender) && IsValidClient(client))
		{
			float camPos[3], camAngs[3];
			GetEntPropVector(camera, Prop_Data, "m_angAbsRotation", camAngs);
			GetEntPropVector(camera, Prop_Data, "m_vecAbsOrigin", camPos);

			camPos[0] -= g_CameraPlayerOffsetBackward[camera];
			camPos[2] -= g_CameraPlayerOffsetDownward[camera];

			TeleportEntity(client, camPos, camAngs, NULL_VECTOR);

			RequestFrame(Frame_PublicDeathCam, EntIndexToEntRef(cameraRef));
		}
	}
}

static Action Timer_ClientResetDeathCam1(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerDeathCamTimer[client])
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]));

	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];

	if (Npc.IsValid())
	{
		g_PlayerDeathCamShowOverlay[client] = true;
		Npc.GetProfile(profile, sizeof(profile));
		SF2BossProfileSoundInfo soundInfo;
		GetBossProfilePlayerDeathcamOverlaySounds(profile, soundInfo);
		if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
		{
			soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToClient(client, buffer, _, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
			}
		}
		g_PlayerDeathCamTimer[client] = CreateTimer(g_SlenderDeathCamTime[Npc.Index], Timer_ClientResetDeathCamEnd, userid, TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Stop;
}

static Action Timer_BossDeathCamDelay(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(NPCGetFromEntIndex(slender));

	if (timer != g_SlenderDeathCamTimer[Npc.Index])
	{
		return Plugin_Stop;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.GetProfile(profile, sizeof(profile));

	g_SlenderDeathCamTimer[Npc.Index] = CreateTimer(g_SlenderDeathCamTime[Npc.Index], Timer_BossDeathCamDuration, slender, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

static Action Timer_BossDeathCamDuration(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_Chaser Npc = SF2NPC_Chaser(NPCGetFromEntIndex(slender));

	if (timer != g_SlenderDeathCamTimer[Npc.Index])
	{
		return Plugin_Stop;
	}

	if (g_SlenderInDeathcam[Npc.Index])
	{
		SetEntityRenderMode(slender, RENDER_NORMAL);
		if (!Npc.CloakEnabled)
		{
			SetEntityRenderColor(slender, Npc.GetRenderColor(0), Npc.GetRenderColor(1), Npc.GetRenderColor(2), Npc.GetRenderColor(3));
		}
		g_SlenderEntityThink[Npc.Index] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (!(Npc.Flags & SFF_FAKE))
		{
			g_SlenderInDeathcam[Npc.Index] = false;
		}
		Npc.UpdateAnimation(slender, Npc.State);
	}
	if ((Npc.Flags & SFF_FAKE))
	{
		if (g_SlenderInDeathcam[Npc.Index])
		{
			g_SlenderInDeathcam[Npc.Index] = false;
		}
		Npc.MarkAsFake();
	}
	g_SlenderDeathCamTimer[Npc.Index] = null;

	return Plugin_Stop;
}

static Action Timer_ClientResetDeathCamEnd(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerDeathCamTimer[client])
	{
		return Plugin_Stop;
	}

	SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol entity changes our damage state.

	SF2NPC_BaseNPC deathCamBoss = SF2NPC_BaseNPC(NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]));
	if (deathCamBoss != SF2_INVALID_NPC)
	{
		float value = deathCamBoss.GetAttributeValue(SF2Attribute_IgnitePlayerOnDeath);
		if (value > 0.0)
		{
			TF2_IgnitePlayer(client, client);
		}
		if (!(deathCamBoss.Flags & SFF_FAKE))
		{
			int slenderEnt = deathCamBoss.EntIndex;
			if (slenderEnt > MaxClients)
			{
				SDKHooks_TakeDamage(client, slenderEnt, slenderEnt, 9001.0, 0x80 | DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
			}
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

static bool g_PlayerInGhostMode[MAXPLAYERS + 1] = { false, ... };
static int g_PlayerGhostModeTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerGhostModeBossTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
Handle g_PlayerGhostModeConnectionCheckTimer[MAXPLAYERS + 1] = { null, ... };
float g_PlayerGhostModeConnectionTimeOutTime[MAXPLAYERS + 1] = { -1.0, ... };
float g_PlayerGhostModeConnectionBootTime[MAXPLAYERS + 1] = { -1.0, ... };

/**
 *	Enables/Disables ghost mode on the player.
 */
void ClientSetGhostModeState(int client, bool state)
{
	if (state == g_PlayerInGhostMode[client])
	{
		return;
	}

	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, client);
	delete message;
	EndMessage();

	if (state && !IsClientInGame(client))
	{
		return;
	}

	g_PlayerInGhostMode[client] = state;
	g_PlayerGhostModeTarget[client] = INVALID_ENT_REFERENCE;
	g_PlayerGhostModeBossTarget[client] = INVALID_ENT_REFERENCE;

	if (state)
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

		TFClassType desiredClass = TF2_GetPlayerClass(client);
		if (desiredClass == TFClass_Unknown)
		{
			desiredClass = TFClass_Spy;
		}

		//Set player's class to spy, this replaces old ghost mode mechanics.
		TF2_SetPlayerClass(client, TFClass_Spy);
		TF2_RegeneratePlayer(client);

		//Set player's old class as desired class.
		SetEntProp(client, Prop_Send, "m_iDesiredPlayerClass", desiredClass);

		ClientHandleGhostMode(client, true);
		if (g_GhostModeConnectionCheckConVar.BoolValue)
		{
			g_PlayerGhostModeConnectionCheckTimer[client] = CreateTimer(0.0, Timer_GhostModeConnectionCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			g_PlayerGhostModeConnectionTimeOutTime[client] = -1.0;
			g_PlayerGhostModeConnectionBootTime[client] = -1.0;
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
	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
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
				SlenderAddGlow(npcIndex,_,view_as<int>({0, 0, 0, 0}));
			}
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
			int red[4] = {184, 56, 59, 255};
			ClientEnableConstantGlow(i, red);
		}
		else if ((g_PlayerProxy[i] && GetClientTeam(i) == TFTeam_Blue))
		{
			int yellow[4] = {255, 208, 0, 255};
			ClientEnableConstantGlow(i, yellow);
		}
	}
}

/**
 *	Makes sure that the player is a ghost when ghost mode is activated.
 */
void ClientHandleGhostMode(int client, bool forceSpawn=false)
{
	if (!IsClientInGhostMode(client))
	{
		return;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientHandleGhostMode(%d, %d)", client, forceSpawn);
	}
	#endif

	if (!TF2_IsPlayerInCondition(client, TFCond_Stealthed) || forceSpawn)
	{
		TF2_StripWearables(client);
		DestroyAllActiveWeapons(client);
		TF2_DestroySpyWeapons();
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
		g_PlayerOverlayCheck[client] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		TriggerTimer(g_PlayerOverlayCheck[client], true);

		CreateTimer(0.2, Timer_ClientGhostStripWearables, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientHandleGhostMode(%d, %d)", client, forceSpawn);
	}
	#endif
}

static Action Timer_ClientGhostStripWearables(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}
	if (!IsClientInGhostMode(client))
	{
		return Plugin_Stop;
	}
	TF2_StripWearables(client);
	DestroyAllActiveWeapons(client);
	TF2_DestroySpyWeapons();
	return Plugin_Stop;
}

void ClientGhostModeNextTarget(int client, bool ignoreSetting = false)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientGhostModeNextTarget(%d)", client);
	}
	#endif

	if (g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState == 0 || ignoreSetting)
	{
		int lastTarget = EntRefToEntIndex(g_PlayerGhostModeTarget[client]);
		int nextTarget = -1;
		int firstTarget = -1;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && (!g_PlayerEliminated[i] || g_PlayerProxy[i]) && !IsClientInGhostMode(i) && !DidClientEscape(i) && IsPlayerAlive(i))
			{
				if (firstTarget == -1)
				{
					firstTarget = i;
				}
				if (i > lastTarget)
				{
					nextTarget = i;
					break;
				}
			}
		}

		int target = -1;
		if (IsValidClient(nextTarget))
		{
			target = nextTarget;
		}
		else
		{
			target = firstTarget;
		}

		if (IsValidClient(target))
		{
			g_PlayerGhostModeTarget[client] = EntIndexToEntRef(target);

			float pos[3], ang[3], velocity[3];
			GetClientAbsOrigin(target, pos);
			GetClientEyeAngles(target, ang);
			GetEntPropVector(target, Prop_Data, "m_vecAbsVelocity", velocity);
			TeleportEntity(client, pos, ang, velocity);
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		}
		#endif
	}
	else
	{
		int lastTarget = NPCGetFromEntIndex(EntRefToEntIndex(g_PlayerGhostModeBossTarget[client]));
		int nextTarget = -1;
		int firstTarget = -1;
		for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
		{
			if (NPCGetUniqueID(bossIndex) == -1 || !IsValidEntity(NPCGetEntIndex(bossIndex)))
			{
				continue;
			}

			if (firstTarget == -1)
			{
				firstTarget = bossIndex;
			}
			if (bossIndex > lastTarget)
			{
				nextTarget = bossIndex;
				break;
			}
		}

		int target = -1;
		if (nextTarget != - 1 && NPCGetEntIndex(nextTarget) && NPCGetEntIndex(nextTarget) != INVALID_ENT_REFERENCE)
		{
			target = nextTarget;
		}
		else
		{
			target = firstTarget;
		}

		if (target != -1 && IsValidEntity(NPCGetEntIndex(target)))
		{
			g_PlayerGhostModeBossTarget[client] = EntIndexToEntRef(NPCGetEntIndex(target));

			float pos[3], ang[3], velocity[3];
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_vecAbsOrigin", pos);
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_angAbsRotation", ang);
			GetEntPropVector(NPCGetEntIndex(target), Prop_Data, "m_vecAbsVelocity", velocity);
			TeleportEntity(client, pos, ang, velocity);
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 2)
		{
			DebugMessage("END ClientGhostModeNextTarget(%d)", client);
		}
		#endif
	}
}

bool IsClientInGhostMode(int client)
{
	return g_PlayerInGhostMode[client];
}

Action Hook_GhostNoTouch(int entity, int other)
{
	if (0 < other <= MaxClients && IsClientInGame(other))
	{
		if (IsClientInGhostMode(other))
		{
			return Plugin_Handled;
		}
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

	g_PlayerScareLastTime[client][bossIndex] = GetGameTime();
	g_PlayerScareNextTime[client][bossIndex] = GetGameTime() + NPCGetScareCooldown(bossIndex);

	// See how much Sanity should be drained from a scare.
	float staticAmount = GetBossProfileStaticScareAmount(profile);
	g_PlayerStaticAmount[client] += staticAmount;
	if (g_PlayerStaticAmount[client] > 1.0)
	{
		g_PlayerStaticAmount[client] = 1.0;
	}

	char scareSound[PLATFORM_MAX_PATH];
	ArrayList soundList;
	SF2BossProfileSoundInfo soundInfo;
	GetBossProfileScareSounds(profile, soundInfo);
	soundList = soundInfo.Paths;
	if (soundList != null && soundList.Length > 0)
	{
		soundList.GetString(GetRandomInt(0, soundList.Length - 1), scareSound, sizeof(scareSound));
	}
	soundList = null;

	if (scareSound[0] != '\0')
	{
		EmitSoundToClient(client, scareSound, _, MUSIC_CHAN, SNDLEVEL_NONE);

		if (NPCGetFlags(bossIndex) & SFF_HASSIGHTSOUNDS)
		{
			g_PlayerSightSoundNextTime[client][bossIndex] = GetGameTime() + GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);
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

static void ClientPerformSightSound(int client,int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not perform sight sound on client %d: boss does not exist!", client);
		return;
	}

	if (!(NPCGetFlags(bossIndex) & SFF_HASSIGHTSOUNDS))
	{
		return;
	}

	int master = NPCGetFromUniqueID(g_SlenderCopyMaster[bossIndex]);
	if (master == -1)
	{
		master = bossIndex;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char sightSound[PLATFORM_MAX_PATH];
	ArrayList soundList;
	SF2BossProfileSoundInfo soundInfo;
	GetBossProfileSightSounds(profile, soundInfo);
	soundList = soundInfo.Paths;
	if (soundList != null && soundList.Length > 0)
	{
		soundList.GetString(GetRandomInt(0, soundList.Length - 1), sightSound, sizeof(sightSound));
	}
	soundList = null;

	if (sightSound[0] != '\0')
	{
		EmitSoundToClient(client, sightSound, _, MUSIC_CHAN, SNDLEVEL_NONE);

		g_PlayerSightSoundNextTime[client][master] = GetGameTime() + GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);

		float bossPos[3], myPos[3];
		int boss = NPCGetEntIndex(bossIndex);
		GetClientAbsOrigin(client, myPos);
		GetEntPropVector(boss, Prop_Data, "m_vecAbsOrigin", bossPos);
		float distUnComfortZone = 400.0;
		float bossDist = GetVectorSquareMagnitude(myPos, bossPos);

		float stressScalar = 1.0 + ((SquareFloat(distUnComfortZone) / bossDist));

		ClientAddStress(client, 0.1 * stressScalar);
	}
}

void ClientResetScare(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetScare(%d)", client);
	}
	#endif

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerScareNextTime[client][i] = -1.0;
		g_PlayerScareLastTime[client][i] = -1.0;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetScare(%d)", client);
	}
	#endif
}

//	==========================================================
//	ANTI-CAMPING FUNCTIONS
//	==========================================================

void ClientResetCampingStats(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetCampingStats(%d)", client);
	}
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
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetCampingStats(%d)", client);
	}
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
	if (IsRoundInWarmup() || DidClientEscape(client))
	{
		return;
	}

	if (IsClientBlinking(client))
	{
		return;
	}

	if (SF_IsRaidMap() || SF_IsBoxingMap())
	{
		return;
	}

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
static void ClientUnblink(int client)
{
	if (!IsClientBlinking(client))
	{
		return;
	}

	g_PlayerBlink[client] = false;
	g_PlayerBlinkTimer[client] = null;
	g_PlayerBlinkMeter[client] = 1.0;
}

void ClientStartDrainingBlinkMeter(int client)
{
	g_PlayerBlinkTimer[client] = CreateTimer(ClientGetBlinkRate(client), Timer_BlinkTimer, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

static Action Timer_BlinkTimer(Handle timer, any userid)
{
	if (IsRoundInWarmup())
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerBlinkTimer[client])
	{
		return Plugin_Stop;
	}

	if (IsPlayerAlive(client) && !IsClientInDeathCam(client) && !g_PlayerEliminated[client] && !IsClientInGhostMode(client) && !IsRoundEnding())
	{
		int override = g_PlayerInfiniteBlinkOverrideConVar.IntValue;
		if ((!g_RoundInfiniteBlink && override != 1) || override == 0)
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
	if (client <= 0 || timer != g_PlayerBlinkTimer[client] || !g_PlayerBlink[client])
	{
		return Plugin_Stop;
	}

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

static float ClientGetBlinkRate(int client)
{
	float value = g_PlayerBlinkRateConVar.FloatValue;
	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);
	if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 3)
	{
		// Being underwater makes you blink faster, obviously.
		value *= 0.75;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		if (g_PlayerSeesSlender[client][i])
		{
			value *= NPCGetBlinkLookRate(i);
		}

		else if (g_PlayerStaticMode[client][i] == Static_Increase)
		{
			value *= NPCGetBlinkStaticRate(i);
		}
	}

	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Sniper)
		{
			value *= 2.0;
		}
	}
	else
	{
		value *= g_ClassBlinkRateMultiplier[classToInt];
	}

	if (IsClientUsingFlashlight(client))
	{
		float startPos[3], endPos[3], direction[3];
		float length = SF2_FLASHLIGHT_LENGTH;
		GetClientEyePosition(client, startPos);
		GetClientEyePosition(client, endPos);
		GetClientEyeAngles(client, direction);
		GetAngleVectors(direction, direction, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(direction, direction);
		ScaleVector(direction, length);
		AddVectors(endPos, direction, endPos);
		Handle trace = TR_TraceRayFilterEx(startPos, endPos, MASK_VISIBLE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, client);
		TR_GetEndPosition(endPos, trace);
		bool hit = TR_DidHit(trace);
		delete trace;

		if (hit)
		{
			float percent = ((GetVectorSquareMagnitude(startPos, endPos) / length));
			percent *= 3.5;
			if (percent > 1.0)
			{
				percent = 1.0;
			}
			value *= percent;
		}
	}

	return value;
}

//	==========================================================
//	SCREEN OVERLAY FUNCTIONS
//	==========================================================

void ClientAddStress(int client, float stressAmount)
{
	g_PlayerStressAmount[client] += stressAmount;
	if (g_PlayerStressAmount[client] < 0.0)
	{
		g_PlayerStressAmount[client] = 0.0;
	}
	if (g_PlayerStressAmount[client] > 1.0)
	{
		g_PlayerStressAmount[client] = 1.0;
	}

	//PrintCenterText(client, "g_PlayerStressAmount[%d] = %f", client, g_PlayerStressAmount[client]);

	SlenderOnClientStressUpdate(client);
}

void ClientResetOverlay(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetOverlay(%d)", client);
	}
	#endif

	g_PlayerOverlayCheck[client] = null;

	if (IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay \"\"");
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetOverlay(%d)", client);
	}
	#endif
}

Action Timer_PlayerOverlayCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerOverlayCheck[client])
	{
		return Plugin_Stop;
	}

	if (IsRoundInWarmup())
	{
		return Plugin_Continue;
	}

	int deathCamBoss = NPCGetFromUniqueID(g_PlayerDeathCamBoss[client]);
	int jumpScareBoss = NPCGetFromUniqueID(g_PlayerJumpScareBoss[client]);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	char material[PLATFORM_MAX_PATH], overlay[PLATFORM_MAX_PATH];

	if (IsClientInDeathCam(client) && deathCamBoss != -1 && g_PlayerDeathCamShowOverlay[client])
	{
		NPCGetProfile(deathCamBoss, profile, sizeof(profile));
		GetBossProfileOverlayPlayerDeath(profile, material, sizeof(material));
	}
	else if (jumpScareBoss != -1 && GetGameTime() <= g_PlayerJumpScareLifeTime[client])
	{
		NPCGetProfile(jumpScareBoss, profile, sizeof(profile));
		GetBossProfileOverlayJumpscare(profile, material, sizeof(material));
	}
	else if (IsClientInGhostMode(client) && !SF_IsBoxingMap())
	{
		g_GhostOverlayConVar.GetString(overlay, sizeof(overlay));
		strcopy(material, sizeof(material), overlay);
	}
	else if (IsRoundInWarmup() || g_PlayerEliminated[client] || DidClientEscape(client) && !IsClientInGhostMode(client))
	{
		return Plugin_Continue;
	}
	else
	{
		if (!g_PlayerPreferences[client].PlayerPreference_FilmGrain)
		{
			g_OverlayNoGrainConVar.GetString(overlay, sizeof(overlay));
			strcopy(material, sizeof(material), overlay);
		}
		else
		{
			g_CameraOverlayConVar.GetString(overlay, sizeof(overlay));
			strcopy(material, sizeof(material), overlay);
		}
	}

	ClientCommand(client, "r_screenoverlay %s", material);
	return Plugin_Continue;
}

//	==========================================================
//	MISC FUNCTIONS
//	==========================================================

void ClientUpdateListeningFlags(int client, bool reset=false)
{
	if (!IsClientInGame(client))
	{
		return;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == client || !IsClientInGame(i) || IsClientSourceTV(i))
		{
			continue;
		}

		if (reset || IsRoundEnding() || (g_AllChatConVar.BoolValue && !SF_SpecialRound(SPECIALROUND_SINGLEPLAYER)) || SF_IsBoxingMap())
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
				bool canHear = false;

				if (SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
				{
					if (!DidClientEscape(i))
					{
						if (!DidClientEscape(client))
						{
							SetListenOverride(client, i, Listen_No);
						}
						else
						{
							SetListenOverride(client, i, Listen_Default);
						}
					}
					else
					{
						if (!DidClientEscape(client))
						{
							SetListenOverride(client, i, Listen_No);
						}
						else
						{
							SetListenOverride(client, i, Listen_Default);
						}
					}
				}
				else
				{
					if (g_PlayerVoiceDistanceConVar.FloatValue <= 0.0)
					{
						canHear = true;
					}

					if (!canHear)
					{
						float myPos[3], hisPos[3];
						GetClientEyePosition(client, myPos);
						GetClientEyePosition(i, hisPos);

						float dist = GetVectorSquareMagnitude(myPos, hisPos);

						if (g_PlayerVoiceWallScaleConVar.FloatValue > 0.0)
						{
							Handle trace = TR_TraceRayFilterEx(myPos, hisPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitCharacters);
							bool didHit = TR_DidHit(trace);
							delete trace;

							if (didHit)
							{
								dist *= SquareFloat(g_PlayerVoiceWallScaleConVar.FloatValue);
							}
						}

						if (dist <= SquareFloat(g_PlayerVoiceDistanceConVar.FloatValue))
						{
							canHear = true;
						}
					}

					if (canHear)
					{
						if (IsClientInGhostMode(i) != IsClientInGhostMode(client) &&
							DidClientEscape(i) != DidClientEscape(client))
						{
							canHear = false;
						}
					}

					if (canHear)
					{
						SetListenOverride(client, i, Listen_Default);
					}
					else
					{
						SetListenOverride(client, i, Listen_No);
					}
				}
			}
			else
			{
				SetListenOverride(client, i, Listen_No);
			}
		}
	}
}

void ClientShowMainMessage(int client, const char[] message, any ...)
{
	char messageDisplay[512];
	VFormat(messageDisplay, sizeof(messageDisplay), message, 3);

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
	ShowSyncHudText(client, g_HudSync, messageDisplay);
}

void ClientResetSlenderStats(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetSlenderStats(%d)", client);
	}
	#endif

	g_PlayerStressAmount[client] = 0.0;
	g_PlayerStressNextUpdateTime[client] = -1.0;

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_PlayerSeesSlender[client][i] = false;
		g_PlayerSeesSlenderLastTime[client][i] = -1.0;
		g_PlayerSightSoundNextTime[client][i] = -1.0;
		g_PlayerScaredByBoss[client][i] = false;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetSlenderStats(%d)", client);
	}
	#endif
}

bool ClientSetQueuePoints(int client,int amount)
{
	if (!IsClientConnected(client) || !AreClientCookiesCached(client))
	{
		return false;
	}
	g_PlayerQueuePoints[client] = amount;
	ClientSaveCookies(client);
	return true;
}

void ClientSaveCookies(int client)
{
	if (!IsClientConnected(client) || !AreClientCookiesCached(client))
	{
		return;
	}

	// Save and reset our queue points.
	char s[512];
	FormatEx(s, sizeof(s), "%d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d", g_PlayerQueuePoints[client],
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

void ClientViewPunch(int client, const float angleOffset[3])
{
	if (g_PlayerPunchAngleOffsetVel == -1)
	{
		return;
	}

	float offset[3];
	for (int i = 0; i < 3; i++)
	{
		offset[i] = angleOffset[i];
	}
	ScaleVector(offset, 20.0);

	/*
	if (!IsFakeClient(client))
	{
		// Latency compensation.
		float flLatency = GetClientLatency(client, NetFlow_Outgoing);
		float flLatencyCalcDiff = 60.0 * Pow(flLatency, 2.0);

		for (int i = 0; i < 3; i++) offset[i] += (offset[i] * flLatencyCalcDiff);
	}
	*/

	float angleVel[3];
	GetEntDataVector(client, g_PlayerPunchAngleOffsetVel, angleVel);
	AddVectors(angleVel, offset, offset);
	SetEntDataVector(client, g_PlayerPunchAngleOffsetVel, offset, true);
}

static Action Hook_ConstantGlowSetTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int owner = GetEntPropEnt(ent, Prop_Send, "m_hTarget");
	if (owner == other)
	{
		return Plugin_Handled;
	}
	if (!IsValidClient(other))
	{
		return Plugin_Handled;
	}
	if (!IsPlayerAlive(other))
	{
		return Plugin_Handled;
	}
	if (g_PlayerProxy[other])
	{
		if (!IsValidClient(owner))
		{
			return Plugin_Handled;
		}
		if (g_PlayerProxy[owner] || TF2_IsPlayerInCondition(owner, TFCond_Taunting))
		{
			return Plugin_Continue;
		}

		float velocity[3], moveSpeed;
		GetEntPropVector(other, Prop_Data, "m_vecAbsVelocity", velocity);
		moveSpeed = GetVectorLength(velocity, true);

		if (moveSpeed <= SquareFloat(150.0))
		{
			float ownerPos[3], proxyPos[3];
			GetClientEyePosition(owner, ownerPos);
			GetClientEyePosition(other, proxyPos);

			float distance = SquareFloat(500.0);
			if (GetVectorSquareMagnitude(ownerPos, proxyPos) <= distance)
			{
				return Plugin_Continue;
			}
		}
	}
	if (IsClientInGhostMode(other))
	{
		return Plugin_Continue;
	}
	if ((SF_SpecialRound(SPECIALROUND_WALLHAX) || g_EnableWallHaxConVar.BoolValue) && ((GetClientTeam(other) == TFTeam_Red && !g_PlayerEscaped[other] && !g_PlayerEliminated[other]) || (g_PlayerProxy[other])))
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

void ClientSetFOV(int client,int fov)
{
	SetEntData(client, g_PlayerFOVOffset, fov);
	SetEntData(client, g_PlayerDefaultFOVOffset, fov);
}

void TF2_GetClassName(TFClassType class, char[] buffer,int bufferLen)
{
	switch (class)
	{
		case TFClass_Scout:
		{
			strcopy(buffer, bufferLen, "scout");
		}
		case TFClass_Sniper:
		{
			strcopy(buffer, bufferLen, "sniper");
		}
		case TFClass_Soldier:
		{
			strcopy(buffer, bufferLen, "soldier");
		}
		case TFClass_DemoMan:
		{
			strcopy(buffer, bufferLen, "demoman");
		}
		case TFClass_Heavy:
		{
			strcopy(buffer, bufferLen, "heavyweapons");
		}
		case TFClass_Medic:
		{
			strcopy(buffer, bufferLen, "medic");
		}
		case TFClass_Pyro:
		{
			strcopy(buffer, bufferLen, "pyro");
		}
		case TFClass_Spy:
		{
			strcopy(buffer, bufferLen, "spy");
		}
		case TFClass_Engineer:
		{
			strcopy(buffer, bufferLen, "engineer");
		}
		default:
		{
			buffer[0] = '\0';
		}
	}
}

bool IsPointVisibleToAPlayer(const float pos[3], bool checkFOV=true, bool checkBlink=false)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		if (IsPointVisibleToPlayer(i, pos, checkFOV, checkBlink))
		{
			return true;
		}
	}

	return false;
}

bool IsPointVisibleToPlayer(int client, const float pos[3], bool checkFOV=true, bool checkBlink=false, bool checkEliminated=true, bool ignoreFog = false)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client))
	{
		return false;
	}

	if (checkEliminated && g_PlayerEliminated[client])
	{
		return false;
	}

	if (checkBlink && IsClientBlinking(client))
	{
		return false;
	}

	float eyePos[3];
	GetClientEyePosition(client, eyePos);

	// Check fog, if we can.
	if (!ignoreFog && g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
	{
		int fogEntity = GetEntDataEnt2(client, g_PlayerFogCtrlOffset);
		if (IsValidEdict(fogEntity))
		{
			if (GetEntData(fogEntity, g_FogCtrlEnableOffset) &&
				GetVectorSquareMagnitude(eyePos, pos) >= SquareFloat(GetEntDataFloat(fogEntity, g_FogCtrlEndOffset)))
			{
				return false;
			}
		}
	}

	TR_TraceRayFilter(eyePos, pos, MASK_PLAYERSOLID_BRUSHONLY | CONTENTS_WINDOW, RayType_EndPoint, TraceRayDontHitAnything, client);
	bool hit = TR_DidHit();

	if (hit)
	{
		return false;
	}

	if (checkFOV)
	{
		float eyeAng[3], reqVisibleAng[3];
		GetClientEyeAngles(client, eyeAng);

		if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
		{
			eyeAng[0] = 0.0; // Fix taunts bypassing view check.
		}

		float fov = float(g_PlayerDesiredFOV[client]);
		SubtractVectors(pos, eyePos, reqVisibleAng);
		GetVectorAngles(reqVisibleAng, reqVisibleAng);

		float difference = FloatAbs(AngleDiff(eyeAng[0], reqVisibleAng[0])) + FloatAbs(AngleDiff(eyeAng[1], reqVisibleAng[1]));
		if (difference > ((fov * 0.5) + 10.0))
		{
			return false;
		}
	}

	return true;
}

Action Timer_RespawnPlayer(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (!IsValidClient(client) || !IsClientInGame(client) || IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}

	if (SF_SpecialRound(SPECIALROUND_1UP) && IsRoundPlaying() && g_RoundTime <= 0)
	{
		g_PlayerDied1Up[client] = false;
		g_PlayerIn1UpCondition[client] = false;
		g_PlayerFullyDied1Up[client] = true;
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

#include "sf2/functionclients/client_hints.sp"
#include "sf2/functionclients/clients_think.sp"
#include "sf2/functionclients/client_flashlight.sp"
#include "sf2/functionclients/client_music.sp"
#include "sf2/functionclients/client_proxy_functions.sp"