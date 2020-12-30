#if defined _sf2_client_included
 #endinput
#endif
#define _sf2_client_included

#define GHOST_MODEL "models/empty.mdl"
#define SF2_OVERLAY_DEFAULT "overlays/slender/newcamerahud_3"
#define SF2_OVERLAY_DEFAULT_NO_FILMGRAIN "overlays/slender/nofilmgrain"
#define SF2_OVERLAY_GHOST "overlays/slender/ghostcamera"
#define SF2_OVERLAY_MARBLEHORNETS "overlays/slender/marblehornetsoverlay"

#define SF2_ULTRAVISION_WIDTH 800.0
#define SF2_ULTRAVISION_LENGTH 800.0
#define SF2_ULTRAVISION_BRIGHTNESS -4 // Intensity of Ultravision.
#define SF2_ULTRAVISION_CONE 180.0

#define SF2_PLAYER_BREATH_COOLDOWN_MIN 0.8
#define SF2_PLAYER_BREATH_COOLDOWN_MAX 2.0

char g_strPlayerBreathSounds[][] = 
{
	"slender/fastbreath1.wav"
};

//Client Special Round Timer
static Handle g_hClientSpecialRoundTimer[MAXPLAYERS + 1];

// Deathcam data.
static int g_iPlayerDeathCamBoss[MAXPLAYERS + 1] = { -1, ... };
static bool g_bPlayerDeathCam[MAXPLAYERS + 1] = { false, ... };
static bool g_bPlayerDeathCamShowOverlay[MAXPLAYERS + 1] = { false, ... };
static int g_iPlayerDeathCamEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerDeathCamEnt2[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerDeathCamTarget[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static Handle g_hPlayerDeathCamTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };
static bool g_bCameraDeathCamAdvanced[2049] = { false, ... };
static float g_flCameraPlayerOffsetBackward[2049] = { 0.0, ... };
static float g_flCameraPlayerOffsetDownward[2049] = { 0.0, ... };
static float g_vecPlayerOriginalDeathcamPosition[MAXPLAYERS + 1][3];

// Flashlight data.
static bool g_bPlayerFlashlight[MAXPLAYERS + 1] = { false, ... };
static bool g_bPlayerFlashlightBroken[MAXPLAYERS + 1] = { false, ... };
static int g_iPlayerFlashlightEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerFlashlightEntAng[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static float g_flPlayerFlashlightBatteryLife[MAXPLAYERS + 1] = { 1.0, ... };
static Handle g_hPlayerFlashlightBatteryTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };
static float g_flPlayerFlashlightNextInputTime[MAXPLAYERS + 1] = { -1.0, ... };

static int g_ActionItemIndexes[] = { 57, 231 };

// Ultravision data.
static bool g_bPlayerUltravision[MAXPLAYERS + 1] = { false, ... };
static int g_iPlayerUltravisionEnt[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Sprint data.
static bool g_bPlayerSprint[MAXPLAYERS + 1] = { false, ... };
int g_iPlayerSprintPoints[MAXPLAYERS + 1] = { 100, ... };
static Handle g_hPlayerSprintTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };

// Blink data.
static Handle g_hPlayerBlinkTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };
static bool g_bPlayerBlink[MAXPLAYERS + 1] = { false, ... };
static float g_flPlayerBlinkMeter[MAXPLAYERS + 1] = { 0.0, ... };
static int g_iPlayerBlinkCount[MAXPLAYERS + 1] = { 0, ... };

// Breathing data.
static bool g_bPlayerBreath[MAXPLAYERS + 1] = { false, ... };
static Handle g_hPlayerBreathTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };

// Interactive glow data.
static int g_iPlayerInteractiveGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static int g_iPlayerInteractiveGlowTargetEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };

// Constant glow data.
static int g_iPlayerConstantGlowEntity[MAXPLAYERS + 1] = { INVALID_ENT_REFERENCE, ... };
static bool g_bPlayerConstantGlowEnabled[MAXPLAYERS + 1] = { false, ... };
static Handle g_hClientGlowTimer[MAXPLAYERS + 1];

// Jumpscare data.
static int g_iPlayerJumpScareBoss[MAXPLAYERS + 1] = { -1, ... };
static float g_flPlayerJumpScareLifeTime[MAXPLAYERS + 1] = { -1.0, ... };

static float g_flPlayerScareBoostEndTime[MAXPLAYERS + 1] = { -1.0, ... };

// Anti-camping data.
static int g_iPlayerCampingStrikes[MAXPLAYERS + 1] = { 0, ... };
static Handle g_hPlayerCampingTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };
static float g_flPlayerCampingLastPosition[MAXPLAYERS + 1][3];
static bool g_bPlayerCampingFirstTime[MAXPLAYERS + 1];

// Frame data
static int g_iClientMaxFrameDeathAnim[MAXPLAYERS + 1];
static int g_iClientFrame[MAXPLAYERS + 1];

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

public void Hook_ClientPreThink(int client)
{
	if (!g_bEnabled) return;
	
	ClientProcessFlashlightAngles(client);
	ClientProcessInteractiveGlow(client);
	ClientProcessStaticShake(client);
	ClientProcessViewAngles(client);
	
	if (IsClientInGhostMode(client))
	{
		SetEntityFlags(client,GetEntityFlags(client)^FL_EDICT_ALWAYS);
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
		SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
		if(IsClientInKart(client) || !TF2_IsPlayerInCondition(client, TFCond_Stealthed))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
			TF2_RemoveCondition(client,TFCond_Taunting);
			ClientHandleGhostMode(client, true);
		}
	}
	else if (!g_bPlayerEliminated[client] || g_bPlayerProxy[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		
			int iRoundState = view_as<int>(GameRules_GetRoundState());

			if (!g_bPlayerProxy[client] && GetClientTeam(client) == TFTeam_Red)
			{
				if (iRoundState == 4)
				{
					if (IsClientInDeathCam(client))
					{
						int ent = EntRefToEntIndex(g_iPlayerDeathCamEnt[client]);
						if (ent && ent != INVALID_ENT_REFERENCE && g_bCameraDeathCamAdvanced[ent])
						{
							float vecCamPos[3], vecCamAngs[3];
							GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", vecCamAngs);
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", vecCamPos);
							
							vecCamPos[0] -= g_flCameraPlayerOffsetBackward[ent];
							vecCamPos[2] -= g_flCameraPlayerOffsetDownward[ent];
							
							TeleportEntity(client, vecCamPos, vecCamAngs, NULL_VECTOR);
						}
					}
					bool bDanger = false;
					
					if (!bDanger)
					{
						int iState;
						int iBossTarget;
						
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								iBossTarget = EntRefToEntIndex(g_iSlenderTarget[i]);
								iState = g_iSlenderState[i];
								
								if ((iState == STATE_CHASE || iState == STATE_ATTACK || iState == STATE_STUN) &&
									((iBossTarget && iBossTarget != INVALID_ENT_REFERENCE && (iBossTarget == client || ClientGetDistanceFromEntity(client, iBossTarget) < 512.0)) || NPCGetDistanceFromEntity(i, client) < 512.0 || PlayerCanSeeSlender(client, i, false)))
								{
									bDanger = true;
									ClientSetScareBoostEndTime(client, GetGameTime() + 5.0);
									
									// Induce client stress levels.
									float flUnComfortZoneDist = 512.0;
									float flStressScalar = (flUnComfortZoneDist / NPCGetDistanceFromEntity(i, client));
									ClientAddStress(client, 0.025 * flStressScalar);
									
									break;
								}
							}
						}
					}
					
					if (g_flPlayerStaticAmount[client] > 0.4) bDanger = true;
					if (GetGameTime() < ClientGetScareBoostEndTime(client)) bDanger = true;
					
					if (!bDanger)
					{
						int iState;
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								if (iState == STATE_ALERT)
								{
									if (PlayerCanSeeSlender(client, i))
									{
										bDanger = true;
										ClientSetScareBoostEndTime(client, GetGameTime() + 5.0);
									}
								}
							}
						}
					}
					
					if (!bDanger)
					{
						float flCurTime = GetGameTime();
						float flScareSprintDuration = 3.0;
						if (TF2_GetPlayerClass(client) == TFClass_DemoMan) flScareSprintDuration *= 1.667;
						
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if ((flCurTime - g_flPlayerScareLastTime[client][i]) <= flScareSprintDuration)
							{
								bDanger = true;
								break;
							}
						}
					}
					
					float flWalkSpeed = ClientGetDefaultWalkSpeed(client);
					float flSprintSpeed = ClientGetDefaultSprintSpeed(client);
					
					// Check for weapon speed changes.
					int iWeapon = INVALID_ENT_REFERENCE;
					
					for (int iSlot = 0; iSlot <= 5; iSlot++)
					{
						iWeapon = GetPlayerWeaponSlot(client, iSlot);
						if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;
						
						int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
						switch (iItemDef)
						{
							case 172: // Scotsman's Skullcutter
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed -= (flSprintSpeed * 0.05);
									flWalkSpeed -= (flWalkSpeed * 0.05);
								}
							}
							case 214: // The Powerjack
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed += (flSprintSpeed * 0.05);
								}
							}
							case 239: // Gloves of Running Urgently
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed += (flSprintSpeed * 0.1);
								}
							}
							case 775: // Escape Plan
							{
								float flHealth = float(GetEntProp(client, Prop_Send, "m_iHealth"));
								float flMaxHealth = float(SDKCall(g_hSDKGetMaxHealth, client));
								float flPercentage = flHealth / flMaxHealth;
								
								if (flPercentage > 0.805)
								{
									flWalkSpeed += 0;
									flSprintSpeed += 0;
								}
								else if (flPercentage < 0.805 && flPercentage >= 0.605) 
								{
									flWalkSpeed += (flWalkSpeed * 0.05);
									flSprintSpeed += (flSprintSpeed * 0.05);
								}
								else if (flPercentage < 0.605 && flPercentage >= 0.405) 
								{
									flWalkSpeed += (flWalkSpeed * 0.1);
									flSprintSpeed += (flSprintSpeed * 0.1);
								}
								else if (flPercentage < 0.405 && flPercentage >= 0.205)
								{
									flWalkSpeed += (flWalkSpeed * 0.15);
									flSprintSpeed += (flSprintSpeed * 0.15);
								}
								else if (flPercentage < 0.205)
								{
									flWalkSpeed += (flWalkSpeed * 0.2);
									flSprintSpeed += (flSprintSpeed * 0.2);
								}
							}
						}
					}
					
					// Speed buff
					if (TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly))
					{
						flWalkSpeed += (flWalkSpeed * 0.115);
						flSprintSpeed += (flSprintSpeed * 0.175);
					}
					
					if (bDanger)
					{
						flWalkSpeed *= 1.34;
						flSprintSpeed *= 1.34;
						
						if (!g_bPlayerHints[client][PlayerHint_Sprint])
						{
							ClientShowHint(client, PlayerHint_Sprint);
						}
					}
					
					float flSprintSpeedSubtract = ((flSprintSpeed - flWalkSpeed) * 0.5);
					float flWalkSpeedSubtract = ((flSprintSpeed - flWalkSpeed) * 0.35);
					if (g_iPlayerSprintPoints[client] > 7)
					{
						flSprintSpeedSubtract -= flSprintSpeedSubtract * (g_iPlayerSprintPoints[client] != 0 ? (float(g_iPlayerSprintPoints[client]) / 100.0) : 0.0);
						flSprintSpeed -= flSprintSpeedSubtract;
					}
					else
					{
						flSprintSpeedSubtract += 25;
						flSprintSpeed -= flSprintSpeedSubtract;
						flWalkSpeedSubtract += 15;
						flWalkSpeed -= flWalkSpeedSubtract;
					}
					
					if (IsClientSprinting(client)) 
					{
						if (!g_bPlayerTrapped[client])
						{
							if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
							{
								if(!TF2_IsPlayerInCondition(client, TFCond_Charging))
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flSprintSpeed);
								}
								else
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flSprintSpeed*2.5);
								}
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flSprintSpeed-220.0);
							}
							else
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flSprintSpeed-220.0);
							}
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 0.1);
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", 0.1);
						}
					}
					else 
					{
						if (!g_bPlayerTrapped[client])
						{
							if(!TF2_IsPlayerInCondition(client, TFCond_Charging))
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flWalkSpeed);
							}
							else
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flWalkSpeed*2.5);
							}
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flWalkSpeed-75.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 0.1);
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", 0.1);
						}
					}
					
					if (ClientCanBreath(client) && !g_bPlayerBreath[client])
					{
						ClientStartBreathing(client);
					}
					
					if (g_bPlayerTrapped[client])
					{
						TF2Attrib_SetByName(client, "increased jump height", 0.0);
					}
					else
					{
						TF2Attrib_SetByName(client, "increased jump height", 1.0);
					}
				}
			}
			else if (g_bPlayerProxy[client] && GetClientTeam(client) == TFTeam_Blue)
			{
				TFClassType iClass = TF2_GetPlayerClass(client);
				bool bSpeedup = TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly);
			
				switch (iClass)
				{
					case TFClass_Scout:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 380.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					case TFClass_Medic:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 360.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					case TFClass_Spy:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 360.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					default:
					{
						if (g_bProxySurvivalRageMode)
						{
							float flRageSpeed = ClientGetDefaultSprintSpeed(client)+20.0;
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flRageSpeed);
						}
					}
				}
			}
		}
	}
	if (g_bPlayerEliminated[client] && IsClientInPvP(client))
	{
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
		}
	}
	if (IsRoundInWarmup() || (IsRoundInIntro() && !g_bPlayerEliminated[client]) || IsRoundEnding()) //I told you, stop breaking my plugin
	{
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
		}
	}
	
	// Calculate player stress levels.
	if (GetGameTime() >= g_flPlayerStressNextUpdateTime[client])
	{
		//float flPagePercent = g_iPageMax != 0 ? float(g_iPageCount) / float(g_iPageMax) : 0.0;
		//float flPageCountPercent = g_iPageMax != 0? float(g_iPlayerPageCount[client]) / float(g_iPageMax) : 0.0;
		
		g_flPlayerStressNextUpdateTime[client] = GetGameTime() + 0.33;
		ClientAddStress(client, -0.01);
		
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_PLAYER_STRESS, 1, "g_flPlayerStress[%d]: %0.1f", client, g_flPlayerStress[client]);
#endif
	}
	
	// Process screen shake, if enabled.
	if (g_bPlayerShakeEnabled)
	{
		bool bDoShake = false;
		
		if (IsPlayerAlive(client))
		{
			int iStaticMaster = NPCGetFromUniqueID(g_iPlayerStaticMaster[client]);
			if (iStaticMaster != -1 && NPCGetFlags(iStaticMaster) & SFF_HASVIEWSHAKE)
			{
				bDoShake = true;
			}
		}
		
		if (bDoShake)
		{
			float flPercent = g_flPlayerStaticAmount[client];
			
			float flAmplitudeMax = GetConVarFloat(g_cvPlayerShakeAmplitudeMax);
			float flAmplitude = flAmplitudeMax * flPercent;
			
			float flFrequencyMax = GetConVarFloat(g_cvPlayerShakeFrequencyMax);
			float flFrequency = flFrequencyMax * flPercent;
			
			UTIL_ClientScreenShake(client, flAmplitude, 0.5, flFrequency);
		}
	}
	
	if(g_flLastVisibilityProcess[client]+0.30>=GetGameTime()) return;
	

	/*if (!g_bPlayerEliminated[client])
	{
		CNavArea targetArea = SDK_GetLastKnownArea(client);//SDK_GetLastKnownArea(client) =/= g_lastNavArea[client], SDK_GetLastKnownArea() retrives the nav area stored by the server
		if (targetArea != INVALID_NAV_AREA)
		{
			ClientNavAreaUpdate(client, g_lastNavArea[client], targetArea);
			g_lastNavArea[client] = targetArea;
		}
	}*/
	
	g_flLastVisibilityProcess[client] = GetGameTime();
	
	ClientProcessVisibility(client);
}

public Action Hook_ClientSetTransmit(int client,int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (other != client)
	{
		if (IsClientInGhostMode(client) && !IsClientInGhostMode(other))
		{
#if defined DEBUG
			SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Prevented myself from being transmited to %N.", other);
#endif
			return Plugin_Handled;
		}
		
		if (!IsRoundEnding())
		{
			// SPECIAL ROUND: Singleplayer
			if (g_bSpecialRound && SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
			{
				if (!g_bPlayerEliminated[client] && !g_bPlayerEliminated[other] && !DidClientEscape(other)) return Plugin_Handled; 
			}
			
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

public Action Hook_ClientOnTakeDamage(int victim,int &attacker,int &inflictor, float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3],int damagecustom)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (IsRoundInWarmup()) return Plugin_Continue;
	
	Action iAction = Plugin_Continue;
	
	float damage2 = damage;
	Call_StartForward(fOnClientTakeDamage);
	Call_PushCell(victim);
	Call_PushCell(attacker);
	Call_PushFloatRef(damage2);
	Call_Finish(iAction);
	
	if (iAction == Plugin_Changed) 
	{
		damage = damage2;
		return Plugin_Changed;
	}
	
	if (IsClientInKart(victim) && (attacker == 0 || inflictor == 0))
	{
		damage = 0.0;
		return Plugin_Changed;
	}
	
	char inflictorClass[32];
	if(inflictor >= 0) GetEdictClassname(inflictor, inflictorClass, sizeof(inflictorClass));

	if(IsValidClient(attacker) && IsValidClient(victim) && IsClientInPvP(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && victim != attacker)
	{
		damage = 0.0;
		return Plugin_Changed;
	}
	
	if (IsValidClient(attacker) && IsValidClient(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && g_bPlayerTrapped[victim])
	{
		if (!g_bPlayerEliminated[attacker] && !g_bPlayerEliminated[victim])
		{
			if (damagetype & 0x80) // 0x80 == melee damage
			{
				g_bPlayerTrapped[victim] = false;
				TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				TF2_AddCondition(victim, TFCond_SpeedBuffAlly, 4.0);
			}
		}
	}

	char classname[64];

	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && (StrEqual(classname, "env_explosion") || StrEqual(classname, "tf_projectile_sentryrocket") || StrEqual(classname, "tf_projectile_rocket") || StrEqual(classname, "tf_projectile_pipe") || StrEqual(classname, "tf_projectile_arrow")))
	{
		int npcIndex = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex != -1)
		{
			bool bAttackEliminated = view_as<bool>(NPCGetFlags(npcIndex) & SFF_ATTACKWAITERS);
			if(!bAttackEliminated && (GetClientTeam(victim) == TFTeam_Blue) && IsValidClient(victim) )
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}
	
	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && StrEqual(classname, "tf_projectile_rocket") && (ProjectileGetFlags(inflictor) & PROJ_ICEBALL))
	{
		int iDifficulty = GetConVarInt(g_cvDifficulty);
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1)
			{
				if(!g_sSlenderIceballImpactSound[iBossIndex][0])
				{
					g_sSlenderIceballImpactSound[iBossIndex] = ICEBALL_IMPACT;
				}
				EmitSoundToClient(victim, g_sSlenderIceballImpactSound[iBossIndex], _, MUSIC_CHAN);
				SDKHooks_TakeDamage(victim, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_StunPlayer(victim, NPCChaserGetIceballSlowdownDuration(iBossIndex, iDifficulty), NPCChaserGetIceballSlowdownPercent(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, victim);
				if (g_bPlayerEliminated[victim])
				{
					CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(victim));
				}
			}
		}
	}
	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && StrEqual(classname, "tf_projectile_rocket") && (ProjectileGetFlags(inflictor) & PROJ_ICEBALL_ATTACK))
	{
		int iDifficulty = GetConVarInt(g_cvDifficulty);
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1)
			{
				EmitSoundToClient(victim, ICEBALL_IMPACT, _, MUSIC_CHAN);
				SDKHooks_TakeDamage(victim, slender, slender, NPCChaserGetAttackProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_StunPlayer(victim, NPCChaserGetAttackProjectileIceSlowdownDuration(iBossIndex, iDifficulty), NPCChaserGetAttackProjectileIceSlowdownPercent(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, victim);
				if (g_bPlayerEliminated[victim])
				{
					CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(victim));
				}
			}
		}
	}
	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && StrEqual(classname, "tf_projectile_rocket") && (ProjectileGetFlags(inflictor) & PROJ_FIREBALL))
	{
		int iDifficulty = GetConVarInt(g_cvDifficulty);
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1)
			{
				SDKHooks_TakeDamage(victim, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_IgnitePlayer(victim, victim);
			}
		}
	}

	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && StrEqual(classname, "tf_projectile_rocket") && (ProjectileGetFlags(inflictor) & PROJ_FIREBALL_ATTACK))
	{
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
			if (iBossIndex != -1)
			{
				SDKHooks_TakeDamage(victim, slender, slender, NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex+1), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_IgnitePlayer(victim, victim);
			}
		}
	}
	
	if (attacker != victim && IsValidClient(attacker))
	{
		if (!IsRoundEnding())
		{
			if (IsClientInPvP(victim) && IsClientInPvP(attacker) || IsRoundInWarmup())
			{
				if (attacker == inflictor)
				{
					if (IsValidEdict(weapon))
					{
						char sWeaponClass[64];
						GetEdictClassname(weapon, sWeaponClass, sizeof(sWeaponClass));
						
						// Backstab check!
						if ((StrEqual(sWeaponClass, "tf_weapon_knife", false) || (TF2_GetPlayerClass(attacker) == TFClass_Spy && StrEqual(sWeaponClass, "saxxy", false))) &&
							(damagecustom != TF_CUSTOM_TAUNT_FENCING))
						{
							float flMyPos[3], flHisPos[3], flMyDirection[3];
							GetClientAbsOrigin(victim, flMyPos);
							GetClientAbsOrigin(attacker, flHisPos);
							GetClientEyeAngles(victim, flMyDirection);
							GetAngleVectors(flMyDirection, flMyDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flMyDirection, flMyDirection);
							ScaleVector(flMyDirection, 32.0);
							AddVectors(flMyDirection, flMyPos, flMyDirection);
							int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, victim);
							
							float p[3], s[3];
							MakeVectorFromPoints(flMyPos, flHisPos, p);
							MakeVectorFromPoints(flMyPos, flMyDirection, s);
							if (GetVectorDotProduct(p, s) <= 0.0)//We can backstab him m8
							{
								if (GetClientTeam(victim) == GetClientTeam(attacker) && TF2_GetPlayerClass(victim) == TFClass_Sniper)
								{
									//look if the player has a razorback
									int iWearable = INVALID_ENT_REFERENCE;
									while ((iWearable = FindEntityByClassname(iWearable, "tf_wearable")) != -1)
									{
										if (GetEntPropEnt(iWearable, Prop_Send, "m_hOwnerEntity") == victim && GetEntProp(iWearable, Prop_Send, "m_iItemDefinitionIndex") == 57)
										{
											AcceptEntityInput(iWearable, "Kill");
											damage = 0.0;
											EmitSoundToClient(victim, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
											EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);

											SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
											int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
											if (vm > MaxClients)
											{
												int iMeleeIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
												int anim = 41;
												switch (iMeleeIndex)
												{
													case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968: anim = 15;
													case 638: anim = 31;
												}
												SetEntProp(vm, Prop_Send, "m_nSequence", anim);
											}
											return Plugin_Changed;
										}
									}
								}
								if (damagecustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
								{
									damage = float(iMaxHealth) * 0.3;
									if (damagetype & DMG_ACID) damage /= 2.0;
								}
								
								ConVar hCvar = FindConVar("tf_weapon_criticals");
								if (hCvar != view_as<ConVar>(INVALID_HANDLE) && GetConVarBool(hCvar)) damagetype |= DMG_ACID;
								
								if (!IsClientCritUbercharged(victim))
								{
									if (GetClientTeam(victim) == GetClientTeam(attacker))
									{
										int iPistol = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
										if (iPistol > MaxClients && GetEntProp(iPistol, Prop_Send, "m_iItemDefinitionIndex") == 525) //Give one crit fort the backstab
										{
											int iCrits = GetEntProp(attacker, Prop_Send, "m_iRevengeCrits");
											iCrits++;
											SetEntProp(attacker, Prop_Send, "m_iRevengeCrits", iCrits);
										}
									}
									g_bBackStabbed[victim] = true;
								}
								return Plugin_Changed;
							}
						}
					}
				}
			}
			else if (g_bPlayerProxy[victim] || g_bPlayerProxy[attacker])
			{
				if (g_bPlayerEliminated[attacker] == g_bPlayerEliminated[victim])
				{
					damage = 0.0;
					return Plugin_Changed;
				}
				
				if (attacker == victim)//Don't allow proxy to self regenerate control.
				{
					return Plugin_Continue;
				}
				
				if (g_bPlayerProxy[attacker])
				{
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, victim);
					int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[attacker]);
					NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
					if (iMaster != -1 && sProfile[0])
					{
						if (damagecustom == TF_CUSTOM_TAUNT_GRAND_SLAM ||
							damagecustom == TF_CUSTOM_TAUNT_FENCING ||
							damagecustom == TF_CUSTOM_TAUNT_ARROW_STAB ||
							damagecustom == TF_CUSTOM_TAUNT_GRENADE ||
							damagecustom == TF_CUSTOM_TAUNT_BARBARIAN_SWING ||
							damagecustom == TF_CUSTOM_TAUNT_ENGINEER_ARM ||
							damagecustom == TF_CUSTOM_TAUNT_ARMAGEDDON)
						{
							if (damage >= float(iMaxHealth)) damage = float(iMaxHealth) * 0.5;
							else damage = 0.0;
						}
						else if (damagecustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
						{
							damage = float(iMaxHealth) * GetProfileFloat(sProfile, "proxies_damage_scale_vs_enemy_backstab", 0.25);
							if (damagetype & DMG_ACID) damage /= 2.0;
						}
					
						g_iPlayerProxyControl[attacker] += GetProfileNum(sProfile, "proxies_controlgain_hitenemy");
						if (g_iPlayerProxyControl[attacker] > 100)
						{
							g_iPlayerProxyControl[attacker] = 100;
						}
						
						damage *= GetProfileFloat(sProfile, "proxies_damage_scale_vs_enemy", 1.0);
					}
					return Plugin_Changed;
				}
				else if (g_bPlayerProxy[victim])
				{
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[victim]);
					NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
					if (iMaster != -1 && sProfile[0])
					{
						g_iPlayerProxyControl[attacker] += GetProfileNum(sProfile, "proxies_controlgain_hitbyenemy");
						if (g_iPlayerProxyControl[attacker] > 100)
						{
							g_iPlayerProxyControl[attacker] = 100;
						}
						
						damage *= GetProfileFloat(sProfile, "proxies_damage_scale_vs_self", 1.0);
					}
					if(TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))
					{
						damage=0.0;
					}
					if( damage * ( damagetype & DMG_CRIT ? 3.0 : 1.0 ) >= float(GetClientHealth(victim)) && !TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))//The proxy is about to die
					{
						char sClassName[64];
						char sSectionName[64];
						char sBuffer[PLATFORM_MAX_PATH];
						TF2_GetClassName(TF2_GetPlayerClass(victim), sClassName, sizeof(sClassName));
		
						Format(sSectionName, sizeof(sSectionName), "proxies_death_anim_%s", sClassName);
						if ((GetProfileString(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0]) ||
						(GetProfileString(sProfile, "proxies_death_anim_all", sBuffer, sizeof(sBuffer)) && sBuffer[0]))
						{
							Format(sSectionName, sizeof(sSectionName), "proxies_death_anim_frames_%s", sClassName);
							g_iClientMaxFrameDeathAnim[victim]=GetProfileNum(sProfile, sSectionName, 0);
							if(g_iClientMaxFrameDeathAnim[victim]==0)
								g_iClientMaxFrameDeathAnim[victim]=GetProfileNum(sProfile, "proxies_death_anim_frames_all", 0);
							if(g_iClientMaxFrameDeathAnim[victim]>0)
							{
								// Cancel out any other taunts.
								if(TF2_IsPlayerInCondition(victim, TFCond_Taunting)) TF2_RemoveCondition(victim, TFCond_Taunting);
								//The model has a death anim play it.
								SDK_PlaySpecificSequence(victim,sBuffer);
								g_iClientFrame[victim]=0;
								RequestFrame(ProxyDeathAnimation,victim);
								TF2_AddCondition(victim, view_as<TFCond>(87), 5.0);
								//Prevent death, and show the damage to the attacker.
								TF2_AddCondition(victim, view_as<TFCond>(70), 0.5);
								return Plugin_Changed;
							}
						}
						//the player has no death anim leave him die.
					}
					return Plugin_Changed;
				}
			}
			else
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
		else
		{
			if (g_bPlayerEliminated[attacker] == g_bPlayerEliminated[victim])
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
		
		if (IsClientInGhostMode(victim))
		{
			damage = 0.0;
			return Plugin_Changed;
		}
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
	g_hPlayerStaticTimer[client] = INVALID_HANDLE;
	g_flPlayerStaticIncreaseRate[client] = 0.0;
	g_flPlayerStaticDecreaseRate[client] = 0.0;
	g_hPlayerLastStaticTimer[client] = INVALID_HANDLE;
	g_flPlayerLastStaticTime[client] = 0.0;
	g_flPlayerLastStaticVolume[client] = 0.0;
	g_bPlayerInStaticShake[client] = false;
	g_iPlayerStaticShakeMaster[client] = -1;
	g_flPlayerStaticShakeMinVolume[client] = 0.0;
	g_flPlayerStaticShakeMaxVolume[client] = 0.0;
	g_flPlayerStaticAmount[client] = 0.0;
	
	if (IsClientInGame(client))
	{
		if (g_strPlayerStaticSound[client][0]) StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticSound[client]);
		if (g_strPlayerLastStaticSound[client][0]) StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
		if (g_strPlayerStaticShakeSound[client][0]) StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
	}
	
	strcopy(g_strPlayerStaticSound[client], sizeof(g_strPlayerStaticSound[]), "");
	strcopy(g_strPlayerLastStaticSound[client], sizeof(g_strPlayerLastStaticSound[]), "");
	strcopy(g_strPlayerStaticShakeSound[client], sizeof(g_strPlayerStaticShakeSound[]), "");
}

void ClientResetHints(int client)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetHints(%d)", client);
#endif

	for (int i = 0; i < PlayerHint_MaxNum; i++)
	{
		g_bPlayerHints[client][i] = false;
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetHints(%d)", client);
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
	if (GetConVarInt(g_cvDebugDetail) > 1) DebugMessage("START ClientEscape(%d)", client);
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
	//Client90sMusicReset(client);
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
		GetClientName(client, sName, sizeof(sName));
		CPrintToChatAll("%t", "SF2 Player Escaped", sName);
	}
	
	if (SF_SpecialRound(SPECIALROUND_REALISM))
		StopSound(client, SNDCHAN_STATIC, MARBLEHORNETS_STATIC);
	
	CheckRoundWinConditions();
	
	Call_StartForward(fOnClientEscape);
	Call_PushCell(client);
	Call_Finish();
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 1) DebugMessage("END ClientEscape(%d)", client);
#endif
}

public Action Timer_TeleportPlayerToEscapePoint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (!DidClientEscape(client)) return;
	
	if (IsPlayerAlive(client))
	{
		TeleportClientToEscapePoint(client);
	}
}

stock float ClientGetDistanceFromEntity(int client,int entity)
{
	float flStartPos[3], flEndPos[3];
	GetClientAbsOrigin(client, flStartPos);
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEndPos);
	return GetVectorDistance(flStartPos, flEndPos);
}

//	==========================================================
//	FLASHLIGHT / ULTRAVISION FUNCTIONS
//	==========================================================

bool IsClientUsingFlashlight(int client)
{
	return g_bPlayerFlashlight[client];
}

float ClientGetFlashlightBatteryLife(int client)
{
	return g_flPlayerFlashlightBatteryLife[client];
}

void ClientSetFlashlightBatteryLife(int client, float flPercent)
{
	g_flPlayerFlashlightBatteryLife[client] = flPercent;
}

/**
 *	Called in Hook_ClientPreThink, this makes sure the flashlight is oriented correctly on the player.
 */
static void ClientProcessFlashlightAngles(int client)
{
	if (!IsClientInGame(client)) return;
	
	if (IsPlayerAlive(client))
	{
		int fl;
		float eyeAng[3], ang2[3];
		
		if (IsClientUsingFlashlight(client))
		{
			fl = EntRefToEntIndex(g_iPlayerFlashlightEnt[client]);
			if (fl && fl != INVALID_ENT_REFERENCE)
			{
				TeleportEntity(fl, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }), NULL_VECTOR);
			}
			
			fl = EntRefToEntIndex(g_iPlayerFlashlightEntAng[client]);
			if (fl && fl != INVALID_ENT_REFERENCE)
			{
				GetClientEyeAngles(client, eyeAng);
				GetClientAbsAngles(client, ang2);
				SubtractVectors(eyeAng, ang2, eyeAng);
				TeleportEntity(fl, NULL_VECTOR, eyeAng, NULL_VECTOR);
			}
		}
	}
}

/**
 *	Handles whether or not the player's flashlight should be "flickering", a sign of a dying flashlight battery.
 */
static void ClientHandleFlashlightFlickerState(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client)) return;
	
	if (IsClientUsingFlashlight(client))
	{
		bool bFlicker = view_as<bool>(ClientGetFlashlightBatteryLife(client) <= SF2_FLASHLIGHT_FLICKERAT);
	
		int fl = EntRefToEntIndex(g_iPlayerFlashlightEnt[client]);
		if (fl && fl != INVALID_ENT_REFERENCE)
		{
			if (bFlicker)
			{
				SetEntProp(fl, Prop_Data, "m_LightStyle", 10);
			}
			else
			{
				SetEntProp(fl, Prop_Data, "m_LightStyle", 0);
			}
		}
		
		fl = EntRefToEntIndex(g_iPlayerFlashlightEntAng[client]);
		if (fl && fl != INVALID_ENT_REFERENCE)
		{
			if (bFlicker) 
			{
				SetEntityRenderFx(fl, view_as<RenderFx>(13));
			}
			else 
			{
				SetEntityRenderFx(fl, view_as<RenderFx>(0));
			}
		}
	}
}

bool IsClientFlashlightBroken(int client)
{
	return g_bPlayerFlashlightBroken[client];
}

float ClientGetFlashlightNextInputTime(int client)
{
	return g_flPlayerFlashlightNextInputTime[client];
}

/**
 *	Breaks the player's flashlight. Nothing else.
 */
void ClientBreakFlashlight(int client)
{
	if (IsClientFlashlightBroken(client)) return;
	
	ClientDeactivateUltravision(client);
	
	g_bPlayerFlashlightBroken[client] = true;
	
	ClientSetFlashlightBatteryLife(client, 0.0);
	ClientTurnOffFlashlight(client);
	
	ClientAddStress(client, 0.2);
	
	EmitSoundToAll(FLASHLIGHT_BREAKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
	
	Call_StartForward(fOnClientBreakFlashlight);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Resets everything of the player's flashlight.
 */
void ClientResetFlashlight(int client)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetFlashlight(%d)", client);
#endif
	
	ClientTurnOffFlashlight(client);
	ClientSetFlashlightBatteryLife(client, 1.0);
	g_bPlayerFlashlightBroken[client] = false;
	g_hPlayerFlashlightBatteryTimer[client] = INVALID_HANDLE;
	g_flPlayerFlashlightNextInputTime[client] = -1.0;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetFlashlight(%d)", client);
#endif
}

public Action Hook_FlashlightSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (EntRefToEntIndex(g_iPlayerFlashlightEnt[other]) != ent) return Plugin_Handled;
	
	// We've already checked for flashlight ownership in the last statement. So we can do just this.
	if (g_iPlayerPreferences[other].PlayerPreference_ProjectedFlashlight) return Plugin_Handled;
	
	return Plugin_Continue;
}

public Action Hook_Flashlight2SetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (EntRefToEntIndex(g_iPlayerFlashlightEntAng[other]) == ent) return Plugin_Handled;
	return Plugin_Continue;
}

public void Hook_FlashlightEndSpawnPost(int ent)
{
	if (!g_bEnabled) return;

	SDKHook(ent, SDKHook_SetTransmit, Hook_FlashlightEndSetTransmit);
	SDKUnhook(ent, SDKHook_SpawnPost, Hook_FlashlightEndSpawnPost);
}

public Action Hook_FlashlightBeamSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	int iOwner = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (iOwner == -1) return Plugin_Continue;
	
	int iClient = -1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		
		if (EntRefToEntIndex(g_iPlayerFlashlightEntAng[i]) == iOwner)
		{
			iClient = i;
			break;
		}
	}
	
	if (iClient == -1) return Plugin_Continue;
	
	if (iClient == other)
	{
		if (!GetEntProp(iClient, Prop_Send, "m_nForceTauntCam") || !GetEntProp(iClient, Prop_Send, "m_iObserverMode"))
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

public Action Hook_FlashlightEndSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	int iOwner = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (iOwner == -1) return Plugin_Continue;
	
	int iClient = -1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		
		if (EntRefToEntIndex(g_iPlayerFlashlightEntAng[i]) == iOwner)
		{
			iClient = i;
			break;
		}
	}
	
	if (iClient == -1) return Plugin_Continue;
	
	if (iClient == other)
	{
		if (!GetEntProp(iClient, Prop_Send, "m_nForceTauntCam") || !GetEntProp(iClient, Prop_Send, "m_iObserverMode"))
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}


public Action Timer_DrainFlashlight(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerFlashlightBatteryTimer[client]) return Plugin_Stop;
	
	if (!IsInfiniteFlashlightEnabled())
	{
		ClientSetFlashlightBatteryLife(client, ClientGetFlashlightBatteryLife(client) - 0.01);
	}
	
	if (ClientGetFlashlightBatteryLife(client) <= 0.0)
	{
		// Break the player's flashlight, but also start recharging.
		ClientBreakFlashlight(client);
		ClientStartRechargingFlashlightBattery(client);
		ClientActivateUltravision(client);
		return Plugin_Stop;
	}
	else
	{
		ClientHandleFlashlightFlickerState(client);
	}
	
	return Plugin_Continue;
}

public Action Timer_RechargeFlashlight(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerFlashlightBatteryTimer[client]) return Plugin_Stop;
	
	ClientSetFlashlightBatteryLife(client, ClientGetFlashlightBatteryLife(client) + 0.01);
	
	if (IsClientFlashlightBroken(client) && ClientGetFlashlightBatteryLife(client) >= SF2_FLASHLIGHT_ENABLEAT)
	{
		// Repair the flashlight.
		g_bPlayerFlashlightBroken[client] = false;
	}
	
	if (ClientGetFlashlightBatteryLife(client) >= 1.0)
	{
		// I am fully charged!
		ClientSetFlashlightBatteryLife(client, 1.0);
		g_hPlayerFlashlightBatteryTimer[client] = INVALID_HANDLE;
		
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

/**
 *	Turns on the player's flashlight. Nothing else.
 */
void ClientTurnOnFlashlight(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client)) return;
	
	if (IsClientUsingFlashlight(client)) return;
	
	g_bPlayerFlashlight[client] = true;
	
	float flEyePos[3];
	GetClientEyePosition(client, flEyePos);

	if (g_iPlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
	{
		// If the player is using the projected flashlight, just set effect flags.
		int iEffects = GetEntProp(client, Prop_Send, "m_fEffects");
		if (!(iEffects & (1 << 2)))
		{
			SetEntProp(client, Prop_Send, "m_fEffects", iEffects | (1 << 2));
		}
	}
	else
	{
		// Spawn the light which only the user will see.
		int ent = CreateEntityByName("light_dynamic");
		if (ent != -1)
		{
			TeleportEntity(ent, flEyePos, NULL_VECTOR, NULL_VECTOR);
			DispatchKeyValue(ent, "targetname", "WUBADUBDUBMOTHERBUCKERS");
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 1)
			{
				DispatchKeyValue(ent, "rendercolor", "255 150 50");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 2)
			{
				DispatchKeyValue(ent, "rendercolor", "255 210 100");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 3)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 120");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 4)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 185");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 5)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 210");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 6)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 255");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 7)
			{
				DispatchKeyValue(ent, "rendercolor", "210 255 255");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 8)
			{
				DispatchKeyValue(ent, "rendercolor", "185 255 255");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 9)
			{
				DispatchKeyValue(ent, "rendercolor", "150 255 255");
			}
			if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 10)
			{
				DispatchKeyValue(ent, "rendercolor", "125 255 255");
			}
			SetVariantFloat(SF2_FLASHLIGHT_WIDTH);
			AcceptEntityInput(ent, "spotlight_radius");
			SetVariantFloat(SF2_FLASHLIGHT_LENGTH);
			AcceptEntityInput(ent, "distance");
			SetVariantInt(SF2_FLASHLIGHT_BRIGHTNESS);
			AcceptEntityInput(ent, "brightness");
			
			// Convert WU to inches.
			float cone = 55.0;
			cone *= 0.75;
			
			SetVariantInt(RoundToFloor(cone));
			AcceptEntityInput(ent, "_inner_cone");
			SetVariantInt(RoundToFloor(cone));
			AcceptEntityInput(ent, "_cone");
			DispatchSpawn(ent);
			ActivateEntity(ent);
			SetVariantString("!activator");
			AcceptEntityInput(ent, "SetParent", client);
			AcceptEntityInput(ent, "TurnOn");
			
			g_iPlayerFlashlightEnt[client] = EntIndexToEntRef(ent);
			
			SDKHook(ent, SDKHook_SetTransmit, Hook_FlashlightSetTransmit);
		}
	}
	
	// Spawn the light that only everyone else will see.
	int ent = CreateEntityByName("point_spotlight");
	if (ent != -1)
	{
		TeleportEntity(ent, flEyePos, NULL_VECTOR, NULL_VECTOR);
		
		char sBuffer[256];
		FloatToString(SF2_FLASHLIGHT_LENGTH, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(ent, "spotlightlength", sBuffer);
		FloatToString(SF2_FLASHLIGHT_WIDTH, sBuffer, sizeof(sBuffer));
		DispatchKeyValue(ent, "spotlightwidth", sBuffer);
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 1)
		{
			DispatchKeyValue(ent, "rendercolor", "255 150 50");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 2)
		{
			DispatchKeyValue(ent, "rendercolor", "255 210 100");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 3)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 120");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 4)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 185");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 5)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 210");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 6)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 255");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 7)
		{
			DispatchKeyValue(ent, "rendercolor", "210 255 255");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 8)
		{
			DispatchKeyValue(ent, "rendercolor", "185 255 255");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 9)
		{
			DispatchKeyValue(ent, "rendercolor", "150 255 255");
		}
		if (g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature == 10)
		{
			DispatchKeyValue(ent, "rendercolor", "125 255 255");
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", client);
		AcceptEntityInput(ent, "LightOn");
		
		g_iPlayerFlashlightEntAng[client] = EntIndexToEntRef(ent);
	}
	
	Call_StartForward(fOnClientActivateFlashlight);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Turns off the player's flashlight. Nothing else.
 */
void ClientTurnOffFlashlight(int client)
{
	if (!IsClientUsingFlashlight(client)) return;
	
	g_bPlayerFlashlight[client] = false;
	g_hPlayerFlashlightBatteryTimer[client] = INVALID_HANDLE;
	
	// Remove user-only light.
	int ent = EntRefToEntIndex(g_iPlayerFlashlightEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE) 
	{
		AcceptEntityInput(ent, "TurnOff");
		AcceptEntityInput(ent, "Kill");
	}
	
	// Remove everyone-else-only light.
	ent = EntRefToEntIndex(g_iPlayerFlashlightEntAng[client]);
	if (ent && ent != INVALID_ENT_REFERENCE) 
	{
		AcceptEntityInput(ent, "LightOff");
		CreateTimer(0.1, Timer_KillEntity, g_iPlayerFlashlightEntAng[client]);
	}
	
	g_iPlayerFlashlightEnt[client] = INVALID_ENT_REFERENCE;
	g_iPlayerFlashlightEntAng[client] = INVALID_ENT_REFERENCE;
	
	if (IsClientInGame(client))
	{
		if (g_iPlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
		{
			int iEffects = GetEntProp(client, Prop_Send, "m_fEffects");
			if (iEffects & (1 << 2))
			{
				SetEntProp(client, Prop_Send, "m_fEffects", iEffects &= ~(1 << 2));
			}
		}
	}
	
	Call_StartForward(fOnClientDeactivateFlashlight);
	Call_PushCell(client);
	Call_Finish();
}

void ClientStartRechargingFlashlightBattery(int client)
{
	g_hPlayerFlashlightBatteryTimer[client] = CreateTimer(SF2_FLASHLIGHT_RECHARGE_RATE, Timer_RechargeFlashlight, GetClientUserId(client), TIMER_REPEAT);
}

void ClientStartDrainingFlashlightBattery(int client)
{
	float flDrainRate = SF2_FLASHLIGHT_DRAIN_RATE;
	float flRechargeRate = SF2_FLASHLIGHT_RECHARGE_RATE;
	bool bNightVision = (GetConVarBool(g_cvNightvisionEnabled) || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	if (bNightVision && g_iNightvisionType == 2) //Blue nightvision
	{
		switch (iDifficulty)
		{
			case Difficulty_Normal:
			{
				flDrainRate *= 0.4;
			}
			case Difficulty_Hard:
			{
				flDrainRate *= 0.35;
			}
			case Difficulty_Insane:
			{
				flDrainRate *= 0.3;
			}
			case Difficulty_Nightmare:
			{
				flDrainRate *= 0.2;
			}
			case Difficulty_Apollyon:
			{
				flDrainRate *= 0.1;
			}
		}
	}
	
	if (TF2_GetPlayerClass(client) == TFClass_Engineer) 
	{
		// Engineers have a 50% longer battery life and 20% decreased recharge rate, basically.
		// TODO: Make this value customizable via cvar.
		flDrainRate *= 1.5;
		flRechargeRate *= 0.8;
	}
	
	g_hPlayerFlashlightBatteryTimer[client] = CreateTimer(flDrainRate, Timer_DrainFlashlight, GetClientUserId(client), TIMER_REPEAT);
}

void ClientHandleFlashlight(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client)) return;
	
	bool bNightVision = (GetConVarBool(g_cvNightvisionEnabled) || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	
	if (IsClientUsingFlashlight(client)) 
	{
		ClientTurnOffFlashlight(client);
		ClientStartRechargingFlashlightBattery(client);
		ClientDeactivateUltravision(client);
		ClientActivateUltravision(client);
		
		g_flPlayerFlashlightNextInputTime[client] = GetGameTime() + SF2_FLASHLIGHT_COOLDOWN;
		
		if (!bNightVision) EmitSoundToAll(FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
	}
	else
	{
		// Only players in the "game" can use the flashlight.
		if (!g_bPlayerEliminated[client])
		{
			bool bCanUseFlashlight = true;
			if (SF_SpecialRound(SPECIALROUND_LIGHTSOUT) || SF_IsRaidMap() || SF_IsBoxingMap())
			{
				// Unequip the flashlight please.
				bCanUseFlashlight = false;
			}
			
			if (!IsClientFlashlightBroken(client) && bCanUseFlashlight)
			{
				ClientDeactivateUltravision(client);
				if (bNightVision)
					ClientActivateUltravision(client, bNightVision);
				else
					ClientTurnOnFlashlight(client);
				ClientStartDrainingFlashlightBattery(client);
				
				g_flPlayerFlashlightNextInputTime[client] = GetGameTime();
				
				EmitSoundToAll((bNightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
			}
			else
			{
				EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
			}
		}
	}
}

bool IsClientUsingUltravision(int client)
{
	return g_bPlayerUltravision[client];
}

void ClientActivateUltravision(int client, bool bNightVision = false)
{
	if (!IsClientInGame(client) || IsClientUsingUltravision(client)) return;
	
	if (!g_bPlayerEliminated[client] && (SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !bNightVision)) return;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientActivateUltravision(%d)", client);
#endif
	
	g_bPlayerUltravision[client] = true;
	g_bPlayerFlashlight[client] = bNightVision;
	
	int ent = CreateEntityByName("light_dynamic");
	if (ent != -1)
	{
		float flEyePos[3];
		GetClientEyePosition(client, flEyePos);
		
		TeleportEntity(ent, flEyePos, view_as<float>({ 90.0, 0.0, 0.0 }), NULL_VECTOR);
		if (bNightVision && !g_bPlayerEliminated[client])
		{
			switch (g_iNightvisionType)
			{
				case 0:
				{
					DispatchKeyValue(ent, "rendercolor", "50 255 50");
				}
				case 1:
				{
					DispatchKeyValue(ent, "rendercolor", "255 50 50");
				}
				case 2:
				{
					DispatchKeyValue(ent, "rendercolor", "50 50 255");
				}
			}
		}
		else
			DispatchKeyValue(ent, "rendercolor", "0 200 255");
		
		float flRadius = 0.0;
		if (g_bPlayerEliminated[client])
		{
			flRadius = GetConVarFloat(g_cvUltravisionRadiusBlue);
		}
		else
		{
			flRadius = GetConVarFloat(g_cvUltravisionRadiusRed);
			if(bNightVision)
				flRadius = GetConVarFloat(g_cvNightvisionRadius);
		}
		
		SetVariantFloat(flRadius);
		AcceptEntityInput(ent, "spotlight_radius");
		SetVariantFloat(flRadius);
		AcceptEntityInput(ent, "distance");
		
		SetVariantInt(-15); // Start dark, then fade in via the Timer_UltravisionFadeInEffect timer func.
		AcceptEntityInput(ent, "brightness");
		if (bNightVision && !g_bPlayerEliminated[client])
		{
			SetVariantInt(5);
			AcceptEntityInput(ent, "brightness");
		}
		
		// Convert WU to inches.
		float cone = SF2_ULTRAVISION_CONE;
		cone *= 0.75;
		
		SetVariantInt(RoundToFloor(cone));
		AcceptEntityInput(ent, "_inner_cone");
		SetVariantInt(0);
		AcceptEntityInput(ent, "_cone");
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", client);
		AcceptEntityInput(ent, "TurnOn");
		SetEntityRenderFx(ent, RENDERFX_SOLID_SLOW);
		SetEntityRenderColor(ent, 100, 200, 255, 255);
		if (bNightVision && !g_bPlayerEliminated[client])
		{
			switch (g_iNightvisionType)
			{
				case 0:
				{
					DispatchKeyValue(ent, "rendercolor", "50 255 50");
				}
				case 1:
				{
					DispatchKeyValue(ent, "rendercolor", "255 50 50");
				}
				case 2:
				{
					DispatchKeyValue(ent, "rendercolor", "50 50 255");
				}
			}
		}
		
		g_iPlayerUltravisionEnt[client] = EntIndexToEntRef(ent);
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_UltravisionSetTransmit);
		
		// Fade in effect.
		CreateTimer(0.0, Timer_UltravisionFadeInEffect, g_iPlayerUltravisionEnt[client], TIMER_REPEAT);
	}

#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientActivateUltravision(%d)", client);
#endif
}

public Action Timer_UltravisionFadeInEffect(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (!ent || ent == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBrightness = GetEntProp(ent, Prop_Send, "m_Exponent");
	if (iBrightness >= GetConVarInt(g_cvUltravisionBrightness)) return Plugin_Stop;
	
	iBrightness++;
	SetVariantInt(iBrightness);
	AcceptEntityInput(ent, "brightness");
	
	return Plugin_Continue;
}

void ClientDeactivateUltravision(int client)
{
	if (!IsClientUsingUltravision(client)) return;
	
	g_bPlayerUltravision[client] = false;
	
	int ent = EntRefToEntIndex(g_iPlayerUltravisionEnt[client]);
	if (ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "TurnOff");
		AcceptEntityInput(ent, "Kill");
	}
	
	g_iPlayerUltravisionEnt[client] = INVALID_ENT_REFERENCE;
}

public Action Hook_UltravisionSetTransmit(int ent,int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (!GetConVarBool(g_cvUltravisionEnabled) || EntRefToEntIndex(g_iPlayerUltravisionEnt[other]) != ent || !IsPlayerAlive(other)) return Plugin_Handled;
	return Plugin_Continue;
}

static float ClientGetDefaultWalkSpeed(int client)
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

static float ClientGetDefaultSprintSpeed(int client)
{
	float flReturn = 340.0;
	float flReturn2 = flReturn;
	Action iAction = Plugin_Continue;
	TFClassType iClass = TF2_GetPlayerClass(client);
	
	switch (iClass)
	{
		case TFClass_Scout: flReturn = 310.0;
		case TFClass_Sniper: flReturn = 300.0;
		case TFClass_Soldier: flReturn = 280.0;
		case TFClass_DemoMan: flReturn = 285.0;
		case TFClass_Heavy: flReturn = 275.0;
		case TFClass_Medic: flReturn = 305.0;
		case TFClass_Pyro: flReturn = 300.0;
		case TFClass_Spy: flReturn = 305.0;
		case TFClass_Engineer: flReturn = 300.0;
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
		
			if (g_strPlayerStaticShakeSound[client][0])
			{
				StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
			}
			
			g_flPlayerStaticShakeMinVolume[client] = GetProfileFloat(sProfile, "sound_static_shake_local_volume_min", 0.0);
			g_flPlayerStaticShakeMaxVolume[client] = GetProfileFloat(sProfile, "sound_static_shake_local_volume_max", 1.0);
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static_shake_local", sStaticSound, sizeof(sStaticSound));
			if (sStaticSound[0])
			{
				strcopy(g_strPlayerStaticShakeSound[client], sizeof(g_strPlayerStaticShakeSound[]), sStaticSound);
			}
			else
			{
				strcopy(g_strPlayerStaticShakeSound[client], sizeof(g_strPlayerStaticShakeSound[]), "");
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
		
		if (g_strPlayerStaticShakeSound[client][0])
		{
			StopSound(client, SNDCHAN_STATIC, g_strPlayerStaticShakeSound[client]);
		}
		
		strcopy(g_strPlayerStaticShakeSound[client], sizeof(g_strPlayerStaticShakeSound[]), "");
		
		g_flPlayerStaticShakeMinVolume[client] = 0.0;
		g_flPlayerStaticShakeMaxVolume[client] = 0.0;
		
		SetEntDataVector(client, g_offsPlayerPunchAngle, flNewPunchAng, true);
		SetEntDataVector(client, g_offsPlayerPunchAngleVel, flNewPunchAngVel, true);
	}
	
	if (g_bPlayerInStaticShake[client])
	{
		if (g_strPlayerStaticShakeSound[client][0])
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
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	bool bWasSeeingSlender[MAX_BOSSES];
	int iOldStaticMode[MAX_BOSSES];
	
	float flSlenderPos[3];
	float flSlenderEyePos[3];
	float flSlenderOBBCenterPos[3];
	
	float flMyPos[3];
	GetClientAbsOrigin(client, flMyPos);
	
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
				
				if ((GetGameTime() - g_flPlayerSeesSlenderLastTime[client][i]) > GetProfileFloat(sProfile, "static_on_look_gracetime", 1.0) ||
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
						GetVectorDistance(flMyPos, flSlenderPos) <= g_flSlenderStaticRadius[i])
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
						GetVectorDistance(flMyPos, flSlenderPos) <= NPCGetInstantKillRadius(i) && !g_bSlenderInDeathcam[i])
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
								ClientStartDeathCam(client, NPCGetFromUniqueID(g_iPlayerStaticMaster[client]), flSlenderPos);
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
		
		// Boss visiblity.
		if (g_bPlayerSeesSlender[client][i] && !bWasSeeingSlender[i])
		{
			g_flPlayerSeesSlenderLastTime[client][iMaster] = GetGameTime();
			
			if (GetGameTime() >= g_flPlayerScareNextTime[client][iMaster])
			{
				g_bPlayerScaredByBoss[client][iMaster] = false;
				if (GetVectorDistance(flMyPos, flSlenderPos) <= NPCGetScareRadius(i))
				{
					ClientPerformScare(client, iMaster);
					
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
						if (g_iSlenderState[iMaster] != STATE_CHASE && g_iSlenderState[iMaster] != STATE_ATTACK && g_iSlenderState[iMaster] != STATE_STUN)
						{
							int slender = NPCGetEntIndex(iMaster);
							g_iNPCPlayerScareVictin[iMaster] = EntIndexToEntRef(client);
							int iDifficulty = GetConVarInt(g_cvDifficulty);
							g_iSlenderState[iMaster] = STATE_CHASE;
							g_iSlenderTarget[iMaster] = client;
							g_flSlenderTimeUntilNoPersistence[iMaster] = GetGameTime() + NPCChaserGetChaseDuration(iMaster, iDifficulty);
							if (iMaster != -1 && slender && slender != INVALID_ENT_REFERENCE)
							NPCChaserUpdateBossAnimation(iMaster, slender, g_iSlenderState[iMaster]);
							g_bPlayerScaredByBoss[client][iMaster] = true;
						}
					}
					if (view_as<bool>(GetProfileNum(sProfile,"jumpscare_on_scare",0)))
					{
						float flJumpScareDuration = GetProfileFloat(sProfile, "jumpscare_duration");
						ClientDoJumpScare(client, iMaster, flJumpScareDuration);
					}
				}
				else
				{
					g_flPlayerScareNextTime[client][iMaster] = GetGameTime() + GetProfileFloat(sProfile, "scare_cooldown");
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
				
				if (sLoopSound[0])
				{
					EmitSoundToClient(client, sLoopSound, iBoss, SNDCHAN_STATIC, GetProfileNum(sProfile, "sound_static_loop_local_level", SNDLEVEL_NORMAL), SND_CHANGEVOL, 1.0);
					ClientAddStress(client, 0.03);
				}
				else
				{
					LogError("Warning! Boss %s supports static loop local sounds, but was given a blank sound path!", sProfile);
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
					
					if (sLoopSound[0])
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
		if (!StrEqual(g_strPlayerLastStaticSound[client], g_strPlayerStaticSound[client], false))
		{
			// Stop last-last static sound entirely.
			if (g_strPlayerLastStaticSound[client][0])
			{
				StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
			}
		}
		
		// Move everything down towards the last arrays.
		if (g_strPlayerStaticSound[client][0])
		{
			strcopy(g_strPlayerLastStaticSound[client], sizeof(g_strPlayerLastStaticSound[]), g_strPlayerStaticSound[client]);
		}
		
		if (iBossNewStatic == -1)
		{
			// No one is the static master.
			g_hPlayerStaticTimer[client] = CreateTimer(g_flPlayerStaticDecreaseRate[client], 
				Timer_ClientDecreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT);
				
			TriggerTimer(g_hPlayerStaticTimer[client], true);
		}
		else
		{
			NPCGetProfile(iBossNewStatic, sProfile, sizeof(sProfile));
		
			strcopy(g_strPlayerStaticSound[client], sizeof(g_strPlayerStaticSound[]), "");
			
			char sStaticSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static", sStaticSound, sizeof(sStaticSound), 1);
			
			if (sStaticSound[0]) 
			{
				strcopy(g_strPlayerStaticSound[client], sizeof(g_strPlayerStaticSound[]), sStaticSound);
			}
			
			// Cross-fade out the static sounds.
			g_flPlayerLastStaticVolume[client] = g_flPlayerStaticAmount[client];
			g_flPlayerLastStaticTime[client] = GetGameTime();
			
			g_hPlayerLastStaticTimer[client] = CreateTimer(0.0, 
				Timer_ClientFadeOutLastStaticSound, 
				GetClientUserId(client), 
				TIMER_REPEAT);
			
			TriggerTimer(g_hPlayerLastStaticTimer[client], true);
			
			// Start up our own static timer.
			float flStaticIncreaseRate = (GetProfileFloat(sProfile, "static_rate") - (GetProfileFloat(sProfile, "static_rate") * g_flRoundDifficultyModifier)/10);
			float flStaticDecreaseRate = (GetProfileFloat(sProfile, "static_rate_decay") + (GetProfileFloat(sProfile, "static_rate_decay") * g_flRoundDifficultyModifier)/10);
			
			g_flPlayerStaticIncreaseRate[client] = flStaticIncreaseRate;
			g_flPlayerStaticDecreaseRate[client] = flStaticDecreaseRate;
			
			g_hPlayerStaticTimer[client] = CreateTimer(flStaticIncreaseRate, 
				Timer_ClientIncreaseStatic, 
				GetClientUserId(client), 
				TIMER_REPEAT);
			
			TriggerTimer(g_hPlayerStaticTimer[client], true);
		}
	}
}

void ClientProcessViewAngles(int client)
{
	if ((!g_bPlayerEliminated[client] || g_bPlayerProxy[client]) && 
		!DidClientEscape(client))
	{
		// Process view bobbing, if enabled.
		// This code is based on the code in this page: https://developer.valvesoftware.com/wiki/Camera_Bob
		// Many thanks to whomever created it in the first place.
		
		if (IsPlayerAlive(client))
		{
			if (g_bPlayerViewbobEnabled)
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
	
	if (g_strPlayerStaticSound[client][0])
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
	
	if (g_strPlayerLastStaticSound[client][0])
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
		StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
		g_hPlayerStaticTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_ClientFadeOutLastStaticSound(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerLastStaticTimer[client]) return Plugin_Stop;
	
	if (StrEqual(g_strPlayerLastStaticSound[client], g_strPlayerStaticSound[client], false)) 
	{
		// Wait, the player's current static sound is the same one we're stopping. Abort!
		g_hPlayerLastStaticTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	if (g_strPlayerLastStaticSound[client][0])
	{
		float flDiff = (GetGameTime() - g_flPlayerLastStaticTime[client]) / 1.0;
		if (flDiff > 1.0) flDiff = 1.0;
		
		float flVolume = g_flPlayerLastStaticVolume[client] - flDiff;
		if (flVolume < 0.0) flVolume = 0.0;
		
		if (flVolume <= 0.0)
		{
			// I've done my job; no point to keep on doing it.
			StopSound(client, SNDCHAN_STATIC, g_strPlayerLastStaticSound[client]);
			g_hPlayerLastStaticTimer[client] = INVALID_HANDLE;
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
		g_hPlayerLastStaticTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

//	==========================================================
//	SPECIAL ROUND FUNCTIONS
//	==========================================================

void ClientSetSpecialRoundTimer(int iClient, float flTime, Timer callback, any data=INVALID_HANDLE, int flags=0)
{
	g_hClientSpecialRoundTimer[iClient] = CreateTimer(flTime, callback, data, flags);
}

public Action Timer_ClientPageDetector(Handle timer, int userid)
{
	if (!SF_SpecialRound(SPECIALROUND_PAGEDETECTOR)) return;
	if (GetRoundState() == SF2RoundState_Escape) return;
	
	int iClient = GetClientOfUserId(userid);
	if (g_hClientSpecialRoundTimer[iClient] != timer) return;
	
	if (!IsValidClient(iClient)) return;
	
	if (g_bPlayerEliminated[iClient]) return;
	
	float flDistance = 99999.0, flClientPos[3], flPagePos[3];
	GetClientAbsOrigin(iClient, flClientPos);
	
	char sModel[255];
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "*")) != -1)
	{
		if (!IsEntityClassname(ent, "prop_dynamic", false)) continue;
		
		GetEntPropString(ent, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
		int iParent = GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity");
		if (sModel[0] && iParent > MaxClients)
		{
			int iParent2 = GetEntPropEnt(ent, Prop_Send, "m_hEffectEntity");
			if (iParent2 > MaxClients)
			{
				if (strcmp(sModel, g_strPageRefModel) == 0 || strcmp(sModel, PAGE_MODEL) == 0)
				{
					GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPagePos);
					if (GetVectorDistance(flClientPos, flPagePos, false) < flDistance)
						flDistance = GetVectorDistance(flClientPos, flPagePos, false);
				}
			}
		}
	}
	float flNextBeepTime = flDistance/800.0;
	
	if (flNextBeepTime > 5.0) flNextBeepTime = 5.0;
	if (flNextBeepTime < 0.1) flNextBeepTime = 0.1;
	
	EmitSoundToClient(iClient,PAGE_DETECTOR_BEEP, _, _, _, _, _, 100-RoundToNearest(flNextBeepTime*10.0));
	g_hClientSpecialRoundTimer[iClient] = CreateTimer(flNextBeepTime, Timer_ClientPageDetector, userid);
}

//	==========================================================
//	INTERACTIVE GLOW FUNCTIONS
//	==========================================================

static void ClientProcessInteractiveGlow(int client)
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientRemoveInteractiveGlow(%d)", client);
#endif

	int ent = EntRefToEntIndex(g_iPlayerInteractiveGlowEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
	}
	
	g_iPlayerInteractiveGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientRemoveInteractiveGlow(%d)", client);
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientCreateInteractiveGlow(%d)", client);
#endif
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetEntPropString(iEnt, Prop_Data, "m_ModelName", sBuffer, sizeof(sBuffer));
	
	if (strlen(sBuffer) == 0) 
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
		
		if (sAttachment[0])
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(ent, "SetParentAttachment");
		}
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_InterativeGlowSetTransmit);
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientCreateInteractiveGlow(%d) -> false", client);
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
	g_hPlayerBreathTimer[client] = INVALID_HANDLE;
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
	g_hPlayerBreathTimer[client] = CreateTimer(ClientCalculateBreathingCooldown(client), Timer_ClientBreath, GetClientUserId(client));
}

void ClientStopBreathing(int client)
{
	g_bPlayerBreath[client] = false;
	g_hPlayerBreathTimer[client] = INVALID_HANDLE;
}

bool ClientCanBreath(int client)
{
	return view_as<bool>(ClientCalculateBreathingCooldown(client) < SF2_PLAYER_BREATH_COOLDOWN_MAX);
}

public Action Timer_ClientBreath(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (timer != g_hPlayerBreathTimer[client]) return;
	
	if (!g_bPlayerBreath[client]) return;
	
	if (ClientCanBreath(client))
	{
		EmitSoundToAll(g_strPlayerBreathSounds[GetRandomInt(0, sizeof(g_strPlayerBreathSounds) - 1)], client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		
		ClientStartBreathing(client);
		return;
	}
	
	ClientStopBreathing(client);
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetSprint(%d)", client);
#endif

	bool bWasSprinting = IsClientSprinting(client);

	g_bPlayerSprint[client] = false;
	g_iPlayerSprintPoints[client] = 100;
	g_hPlayerSprintTimer[client] = INVALID_HANDLE;
	
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetSprint(%d)", client);
#endif
}

void ClientStartSprint(int client)
{
	if (IsClientSprinting(client)) return;
	
	g_bPlayerSprint[client] = true;
	g_hPlayerSprintTimer[client] = INVALID_HANDLE;
	ClientSprintTimer(client);
	TriggerTimer(g_hPlayerSprintTimer[client], true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
	{
		//Client90sMusicStart(client);
	}
	
	SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	
	Call_StartForward(fOnClientStartSprinting);
	Call_PushCell(client);
	Call_Finish();
}

static void ClientSprintTimer(int client, bool bRecharge=false)
{
	float flRate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 0.38 : 0.28;
	if (bRecharge) flRate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 1.4 : 0.8;
	
	float flVelocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", flVelocity);
	
	if (bRecharge)
	{
		if (!(GetEntityFlags(client) & FL_ONGROUND)) flRate *= 0.75;
		else if (GetVectorLength(flVelocity) == 0.0)
		{
			if (GetEntProp(client, Prop_Send, "m_bDucked")) flRate *= 0.66;
			else flRate *= 0.75;
		}
	}
	else
	{
		if (TF2_GetPlayerClass(client) == TFClass_Scout) flRate *= 1.15;
		else if (TF2_GetPlayerClass(client) == TFClass_DemoMan) flRate *= 1.25;
		else if (TF2_GetPlayerClass(client) == TFClass_Medic || TF2_GetPlayerClass(client) == TFClass_Spy) flRate *= 1.05;
	}
	
	if (bRecharge) g_hPlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientRechargeSprint, GetClientUserId(client));
	else g_hPlayerSprintTimer[client] = CreateTimer(flRate, Timer_ClientSprinting, GetClientUserId(client));
}

void ClientStopSprint(int client)
{
	if (!IsClientSprinting(client)) return;
	g_bPlayerSprint[client] = false;
	g_hPlayerSprintTimer[client] = INVALID_HANDLE;
	ClientSprintTimer(client, true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
	{
		//Client90sMusicStop(client);
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
	if (GetVectorLength(flVelocity) < 30.0) return false;
	
	return true;
}

public Action Timer_ClientSprinting(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (timer != g_hPlayerSprintTimer[client]) return;
	
	if (!IsClientSprinting(client)) return;
	
	if (g_iPlayerSprintPoints[client] <= 0)
	{
		ClientStopSprint(client);
		g_iPlayerSprintPoints[client] = 0;
		return;
	}

	if (IsClientReallySprinting(client)) 
	{
		int iOverride = GetConVarInt(g_cvPlayerInfiniteSprintOverride);
		if ((!g_bRoundInfiniteSprint && iOverride != 1) || iOverride == 0)
		{
			g_iPlayerSprintPoints[client]--;
		}
	}
	
	ClientSprintTimer(client);
}

public void Hook_ClientSprintingPreThink(int client)
{
	if (!IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		return;
	}
	
	int iFOV = GetEntData(client, g_offsPlayerDefaultFOV);
	
	int iTargetFOV = g_iPlayerDesiredFOV[client] + 10;
	
	if (iFOV < iTargetFOV)
	{
		int iDiff = RoundFloat(FloatAbs(float(iFOV - iTargetFOV)));
		if (iDiff >= 1)
		{
			ClientSetFOV(client, iFOV + 1);
		}
		else
		{
			ClientSetFOV(client, iTargetFOV);
		}
	}
	else if (iFOV >= iTargetFOV)
	{
		ClientSetFOV(client, iTargetFOV);
		//SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	}
}

public void Hook_ClientRechargeSprintPreThink(int client)
{
	if (IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		return;
	}
	
	int iFOV = GetEntData(client, g_offsPlayerDefaultFOV);
	if (iFOV > g_iPlayerDesiredFOV[client])
	{
		int iDiff = RoundFloat(FloatAbs(float(iFOV - g_iPlayerDesiredFOV[client])));
		if (iDiff >= 1)
		{
			ClientSetFOV(client, iFOV - 1);
		}
		else
		{
			ClientSetFOV(client, g_iPlayerDesiredFOV[client]);
		}
	}
	else if (iFOV <= g_iPlayerDesiredFOV[client])
	{
		ClientSetFOV(client, g_iPlayerDesiredFOV[client]);
	}
}

public Action Timer_ClientRechargeSprint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	float flVelSpeed[3];
	GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", flVelSpeed);
	float flSpeed = GetVectorLength(flVelSpeed);
	
	if (timer != g_hPlayerSprintTimer[client]) return;
	
	if (IsClientSprinting(client)) 
	{
		g_hPlayerSprintTimer[client] = INVALID_HANDLE;
		return;
	}
	
	if (g_iPlayerSprintPoints[client] >= 100)
	{
		g_iPlayerSprintPoints[client] = 100;
		g_hPlayerSprintTimer[client] = INVALID_HANDLE;
		return;
	}
	if ((!GetEntProp(client, Prop_Send, "m_bDucking") && !GetEntProp(client, Prop_Send, "m_bDucked")) || (GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked") && IsClientReallySprinting(client) || flSpeed > 0.0))
	{
		g_iPlayerSprintPoints[client]++;
	}
	else if ((GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked")) && !IsClientReallySprinting(client) && flSpeed == 0.0)
	{
		if (!SF_SpecialRound(SPECIALROUND_COFFEE)) g_iPlayerSprintPoints[client] += 2;
		else g_iPlayerSprintPoints[client] += 1;
	}
	ClientSprintTimer(client, true);
}

//	==========================================================
//	PROXY / GHOST AND GLOW FUNCTIONS
//	==========================================================

void ClientResetProxy(int client, bool bResetFull=true)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetProxy(%d)", client);
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
	g_hPlayerProxyControlTimer[client] = INVALID_HANDLE;
	g_flPlayerProxyControlRate[client] = 0.0;
	g_flPlayerProxyVoiceTimer[client] = INVALID_HANDLE;
	
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
			
			if (sOldProfileName[0])
			{
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_spawn", GetProfileNum(sOldProfileName, "sound_proxy_spawn_channel", SNDCHAN_AUTO));
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_hurt", GetProfileNum(sOldProfileName, "sound_proxy_hurt_channel", SNDCHAN_AUTO));
				ClientStopAllSlenderSounds(client, sOldProfileName, "sound_proxy_idle", GetProfileNum(sOldProfileName, "sound_proxy_idle_channel", SNDCHAN_AUTO));
			}
		}
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetProxy(%d)", client);
#endif
}

void ClientStartProxyAvailableTimer(int client)
{
	g_bPlayerProxyAvailable[client] = false;
	float flCooldown = GetConVarFloat(g_cvPlayerProxyWaitTime);
	if (g_bProxySurvivalRageMode) flCooldown -= 10.0;
	if (flCooldown <= 0.0) flCooldown = 0.0;
	
	g_hPlayerProxyAvailableTimer[client] = CreateTimer(flCooldown, Timer_ClientProxyAvailable, GetClientUserId(client));
}

void ClientStartProxyForce(int client,int iSlenderID, const float flPos[3])
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientStartProxyForce(%d, %d, flPos)", client, iSlenderID);
#endif

	g_iPlayerProxyAskMaster[client] = iSlenderID;
	for (int i = 0; i < 3; i++) g_iPlayerProxyAskPosition[client][i] = flPos[i];

	g_iPlayerProxyAvailableCount[client] = 0;
	g_bPlayerProxyAvailableInForce[client] = true;
	g_hPlayerProxyAvailableTimer[client] = CreateTimer(1.0, Timer_ClientForceProxy, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerProxyAvailableTimer[client], true);
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientStartProxyForce(%d, %d, flPos)", client, iSlenderID);
#endif
}

void ClientStopProxyForce(int client)
{
	g_iPlayerProxyAvailableCount[client] = 0;
	g_bPlayerProxyAvailableInForce[client] = false;
	g_hPlayerProxyAvailableTimer[client] = INVALID_HANDLE;
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
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
		
			int iMaxProxies = GetProfileNum(sProfile, "proxies_max");
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
					ClientEnableProxy(client, iBossIndex);
					TeleportEntity(client, g_iPlayerProxyAskPosition[client], NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
				}
			}
			else
			{
				PrintToChat(client, "%T", "SF2 Too Many Proxies", client);
			}
		}
	}
	
	ClientStopProxyForce(client);
	return Plugin_Stop;
}

void DisplayProxyAskMenu(int client,int iAskMaster, const float flPos[3])
{
	char sBuffer[512];
	Handle hMenu = CreateMenu(Menu_ProxyAsk);
	SetMenuTitle(hMenu, "%T\n \n%T\n \n", "SF2 Proxy Ask Menu Title", client, "SF2 Proxy Ask Menu Description", client);
	
	Format(sBuffer, sizeof(sBuffer), "%T", "Yes", client);
	AddMenuItem(hMenu, "1", sBuffer);
	Format(sBuffer, sizeof(sBuffer), "%T", "No", client);
	AddMenuItem(hMenu, "0", sBuffer);
	
	g_iPlayerProxyAskMaster[client] = iAskMaster;
	for (int i = 0; i < 3; i++) g_iPlayerProxyAskPosition[client][i] = flPos[i];
	DisplayMenu(hMenu, client, 15);
}

public int Menu_ProxyAsk(Handle menu, MenuAction action,int param1,int param2)
{
	switch (action)
	{
		case MenuAction_End: delete menu;
		case MenuAction_Select:
		{
			if (!IsRoundEnding())
			{
				int iBossIndex = NPCGetFromUniqueID(g_iPlayerProxyAskMaster[param1]);
				if (iBossIndex != -1)
				{
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
				
					int iMaxProxies = GetProfileNum(sProfile, "proxies_max");
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
							if(!IsPointVisibleToAPlayer(g_iPlayerProxyAskPosition[param1], _, false))
							{
								ClientEnableProxy(param1, iBossIndex);
								/*char sName[64];
								int ent = -1;
								while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
								{
									GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
									if (StrEqual(sName, "sf2_proxy_spawn_point", false))
									{
										GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", g_iPlayerProxyAskPosition[param1]);
										break;
									}
								}*/
								TeleportEntity(param1, g_iPlayerProxyAskPosition[param1], NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
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
	if (client <= 0) return;
	
	if (timer != g_hPlayerProxyAvailableTimer[client]) return;
	
	g_bPlayerProxyAvailable[client] = true;
	g_hPlayerProxyAvailableTimer[client] = INVALID_HANDLE;
}

void ClientEnableProxy(int client,int iBossIndex)
{
	if (NPCGetUniqueID(iBossIndex) == -1) return;
	if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) return;
	if (g_bPlayerProxy[client]) return;

	TF2_RemovePlayerDisguise(client);
	
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
	g_flPlayerProxyControlRate[client] = GetProfileFloat(sProfile, "proxies_controldrainrate");
	g_hPlayerProxyControlTimer[client] = CreateTimer(g_flPlayerProxyControlRate[client], Timer_ClientProxyControl, GetClientUserId(client));
	g_bPlayerProxyAvailable[client] = false;
	g_hPlayerProxyAvailableTimer[client] = INVALID_HANDLE;
	
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
	PrecacheSound("weapons/teleporter_send.wav");
	EmitSoundToClient(client, "weapons/teleporter_send.wav", _, SNDCHAN_STATIC);
	
	ClientActivateUltravision(client);
	ClientDisableConstantGlow(client);
	
	CreateTimer(0.33, Timer_ApplyCustomModel, GetClientUserId(client));
	
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
	
	Call_StartForward(fOnClientSpawnedAsProxy);
	Call_PushCell(client);
	Call_Finish();
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
	if (client <= 0) return;
	
	if (timer != g_hPlayerProxyControlTimer[client]) return;
	
	g_iPlayerProxyControl[client]--;
	if (TF2_IsPlayerInCondition(client, TFCond_Taunting))
		g_iPlayerProxyControl[client] -= 5;
	if (g_iPlayerProxyControl[client] <= 0)
	{
		// ForcePlayerSuicide isn't really dependable, since the player doesn't suicide until several seconds after spawning has passed.
		SDKHooks_TakeDamage(client, client, client, 9001.0, DMG_PREVENT_PHYSICS_FORCE, _, view_as<float>({ 0.0, 0.0, 0.0 }));
		return;
	}
	
	g_hPlayerProxyControlTimer[client] = CreateTimer(g_flPlayerProxyControlRate[client], Timer_ClientProxyControl, userid);
}

bool DoesClientHaveConstantGlow(int client)
{
	return g_bPlayerConstantGlowEnabled[client];
}

void ClientDisableConstantGlow(int client)
{
	if (!DoesClientHaveConstantGlow(client)) return;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientDisableConstantGlow(%d)", client);
#endif
	
	g_bPlayerConstantGlowEnabled[client] = false;
	
	int iGlow = EntRefToEntIndex(g_iPlayerConstantGlowEntity[client]);
	if (iGlow && iGlow != INVALID_ENT_REFERENCE) 
	{
		int iGlowManager = GetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity");
		AcceptEntityInput(iGlow, "Kill");
		if (iGlowManager > MaxClients)
		{
			AcceptEntityInput(iGlowManager, "Kill");
		}
	}
	
	g_iPlayerConstantGlowEntity[client] = INVALID_ENT_REFERENCE;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientDisableConstantGlow(%d)", client);
#endif
}

bool ClientEnableConstantGlow(int client, const char[] sAttachment="", int iColor[4] = {255, 255, 255, 255})
{
	if (DoesClientHaveConstantGlow(client)) return true;
	
	/*if (g_hClientGlowTimer[client] == null)
	{
		g_hClientGlowTimer[client] = CreateTimer(0.5, Timer_UpdateClientGlow, GetClientUserId(client));
		GetEntPropString(client, Prop_Data, "m_ModelName", g_sOldClientModel[client], sizeof(g_sOldClientModel[]));
	}*/
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientEnableConstantGlow(%d)", client);
#endif
	
	char sModel[PLATFORM_MAX_PATH];
	GetEntPropString(client, Prop_Data, "m_ModelName", sModel, sizeof(sModel));
	
	if (strlen(sModel) == 0) 
	{
		// For some reason the model couldn't be found, so no.
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false (no model specified)", client);
#endif
		
		return false;
	}
	
	int iGlow = CreateEntityByName("tf_taunt_prop");
	if (iGlow != -1)
	{
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("tf_taunt_prop -> created");
#endif
	
		g_bPlayerConstantGlowEnabled[client] = true;
		g_iPlayerConstantGlowEntity[client] = EntIndexToEntRef(iGlow);
		
		float flModelScale = GetEntPropFloat(client, Prop_Send, "m_flModelScale");
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) 
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
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("tf_taunt_prop -> set model and model scale");
#endif
		
		// Set effect flags.
		int iFlags = GetEntProp(iGlow, Prop_Send, "m_fEffects");
		SetEntProp(iGlow, Prop_Send, "m_fEffects", iFlags | (1 << 0)); // EF_BONEMERGE
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("tf_taunt_prop -> set bonemerge flags");
#endif
		
		SetVariantString("!activator");
		AcceptEntityInput(iGlow, "SetParent", client);
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("tf_taunt_prop -> set parent to client");
#endif
		
		if (sAttachment[0])
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(iGlow, "SetParentAttachment");
		}
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("tf_taunt_prop -> set parent attachment to %s", sAttachment);
#endif
		
		SetEntPropEnt(iGlow, Prop_Send, "m_hOwnerEntity", iGlowManager);
		
		Network_HookEntity(iGlow);
		SDKHook(iGlow, SDKHook_SetTransmit, Hook_ConstantGlowSetTransmitVersion2);
		
#if defined DEBUG
		if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> true", client);
#endif
		
		return true;
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientEnableConstantGlow(%d) -> false", client);
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetJumpScare(%d)", client);
#endif

	g_iPlayerJumpScareBoss[client] = -1;
	g_flPlayerJumpScareLifeTime[client] = -1.0;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetJumpScare(%d)", client);
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
	
	if (strlen(sBuffer) > 0)
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

void ClientOnButtonPress(int client,int button)
{
	switch (button)
	{
		case IN_ATTACK2:
		{
			if (IsPlayerAlive(client))
			{
				if (!IsRoundInWarmup() &&
					!IsRoundInIntro() &&
					!IsRoundEnding() && 
					!DidClientEscape(client))
				{
					if (GetGameTime() >= ClientGetFlashlightNextInputTime(client))
					{
						ClientHandleFlashlight(client);
					}
				}
			}
		}
		case IN_ATTACK3:
		{
			ClientHandleSprint(client, true);
		}
		case IN_RELOAD:
		{
			if (IsPlayerAlive(client))
			{
				if (!g_bPlayerEliminated[client])
				{
					if (!IsRoundEnding() && 
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!DidClientEscape(client))
					{
						ClientBlink(client);
					}
				}
			}
		}
		case IN_JUMP:
		{
			if (IsPlayerAlive(client) && !(GetEntityFlags(client) & FL_FROZEN))
			{
				if (!view_as<bool>(GetEntProp(client, Prop_Send, "m_bDucked")) && 
					(GetEntityFlags(client) & FL_ONGROUND) &&
					GetEntProp(client, Prop_Send, "m_nWaterLevel") < 2)
				{
					ClientOnJump(client);
				}
			}
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.0001);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
		case IN_DUCK:
		{
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 4.0);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
	}
}

void ClientOnButtonRelease(int client,int button)
{
	switch (button)
	{
		case IN_ATTACK3:
		{
			ClientHandleSprint(client, false);
		}
		case IN_DUCK:
		{
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.5);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
		case IN_JUMP:
		{
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.5);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
	}
}

void ClientOnJump(int client)
{
	if (!g_bPlayerEliminated[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			int iOverride = GetConVarInt(g_cvPlayerInfiniteSprintOverride);
			if ((!g_bRoundInfiniteSprint && iOverride != 1) || iOverride == 0 && !g_bPlayerTrapped[client])
			{
				if(g_iPlayerSprintPoints[client] >= 2)
				{
					g_iPlayerSprintPoints[client] -= 7;
					if (g_iPlayerSprintPoints[client] <= 0) g_iPlayerSprintPoints[client] = 0;
				}
			}
			
			if (!IsClientSprinting(client))
			{
				if (g_hPlayerSprintTimer[client] == INVALID_HANDLE)
				{
					// If the player hasn't sprinted recently, force us to regenerate the stamina.
					ClientSprintTimer(client, true);
				}
			}
			if (g_bPlayerTrapped[client])
				g_iPlayerTrapCount[client] -= 1;
			if (g_bPlayerTrapped[client] && g_iPlayerTrapCount[client] <= 1)
			{
				g_bPlayerTrapped[client] = false;
				g_iPlayerTrapCount[client] = 0;
			}
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetDeathCam(%d)", client);
#endif
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	
	g_iPlayerDeathCamBoss[client] = -1;
	g_bPlayerDeathCam[client] = false;
	g_bPlayerDeathCamShowOverlay[client] = false;
	g_hPlayerDeathCamTimer[client] = INVALID_HANDLE;
	
	int ent = EntRefToEntIndex(g_iPlayerDeathCamEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		g_bCameraDeathCamAdvanced[ent] = false;
		AcceptEntityInput(ent, "Disable");
		AcceptEntityInput(ent, "Kill");
	}
	
	ent = EntRefToEntIndex(g_iPlayerDeathCamEnt2[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
	}
	
	ent = EntRefToEntIndex(g_iPlayerDeathCamTarget[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "Kill");
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetDeathCam(%d)", client);
#endif
}

void ClientStartDeathCam(int client,int iBossIndex, const float vecLookPos[3], bool bAnticamp = false)
{
	if (IsClientInDeathCam(client)) return;
	if (!NPCIsValid(iBossIndex)) return;
	
	char buffer[PLATFORM_MAX_PATH];
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (GetProfileNum(sProfile, "death_cam_play_scare_sound"))
	{
		GetRandomStringFromProfile(sProfile, "sound_scare_player", buffer, sizeof(buffer));
		if (buffer[0] && !SF_SpecialRound(SPECIALROUND_REALISM)) EmitSoundToClient(client, buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
	}
	
	GetRandomStringFromProfile(sProfile, "sound_player_deathcam", buffer, sizeof(buffer));
	if (strlen(buffer) > 0) 
	{
		EmitSoundToClient(client, buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death"
		if (g_b20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
		{
			GetRandomStringFromProfile(sProfile, "sound_player_death_20dollars", buffer, sizeof(buffer));
			if (strlen(buffer) > 0)
			{
				EmitSoundToClient(client, buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
			}
		}
		else
		{
			GetRandomStringFromProfile(sProfile, "sound_player_death", buffer, sizeof(buffer));
			if (strlen(buffer) > 0)
			{
				EmitSoundToClient(client, buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
			}
		}
	}
	
	GetRandomStringFromProfile(sProfile, "sound_player_deathcam_all", buffer, sizeof(buffer));
	if (strlen(buffer) > 0) 
	{
		EmitSoundToAll(buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
	}
	else
	{
		// Legacy support for "sound_player_death_all"
		GetRandomStringFromProfile(sProfile, "sound_player_death_all", buffer, sizeof(buffer));
		if (strlen(buffer) > 0) 
		{
			EmitSoundToAll(buffer, _, MUSIC_CHAN, SNDLEVEL_NONE);
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
	if (!view_as<bool>(GetProfileNum(sProfile,"death_cam_public",0)))
	{
		SDKHook(slender, SDKHook_SetTransmit, Hook_DeathCamSetTransmit);
	}
	else
	{
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		GetClientAbsOrigin(client, g_vecPlayerOriginalDeathcamPosition[client]);
		if (!bAnticamp)
		{
			int slenderEnt = NPCGetEntIndex(iBossIndex);
			if (slenderEnt && slenderEnt != INVALID_ENT_REFERENCE)
			{
				g_bSlenderInDeathcam[iBossIndex] = true;
				SetEntityRenderMode(slenderEnt, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slenderEnt, 255, 255, 255, 0);
				g_hSlenderEntityThink[iBossIndex] = INVALID_HANDLE;
			}
		}
	}
	
	// Create camera look point.
	char sName[64];
	Format(sName, sizeof(sName), "sf2_boss_%d", EntIndexToEntRef(slender));
	
	float flOffsetPos[3];
	int target = CreateEntityByName("info_target");
	if (!view_as<bool>(GetProfileNum(sProfile,"death_cam_public",0)))
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
		if (sBoneName[0])
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
	if (view_as<bool>(GetProfileNum(sProfile,"death_cam_public",0)))
	{
		float flCamSpeed, flCamAcceleration, flCamDeceleration;
		char sBuffer[PLATFORM_MAX_PATH];
		
		flCamSpeed = GetProfileFloat(sProfile, "death_cam_speed", 1000.0);
		flCamAcceleration = GetProfileFloat(sProfile, "death_cam_acceleration", 1000.0);
		flCamDeceleration = GetProfileFloat(sProfile, "death_cam_deceleration", 1000.0);
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
		if (sAttachmentName[0])
		{
			SetVariantString(sAttachmentName);
			AcceptEntityInput(camera, "SetParentAttachment");
		}
		
		g_bCameraDeathCamAdvanced[camera] = true;
		g_flCameraPlayerOffsetBackward[camera] = GetProfileFloat(sProfile, "deathcam_death_backward_offset", 0.0);
		g_flCameraPlayerOffsetDownward[camera] = GetProfileFloat(sProfile, "deathcam_death_downward_offset", 0.0);
	}
	
	if (GetProfileNum(sProfile, "death_cam_overlay") && GetProfileFloat(sProfile, "death_cam_time_overlay_start") >= 0.0)
	{
		g_hPlayerDeathCamTimer[client] = CreateTimer(GetProfileFloat(sProfile, "death_cam_time_overlay_start"), Timer_ClientResetDeathCam1, GetClientUserId(client));
	}
	else
	{
		g_hPlayerDeathCamTimer[client] = CreateTimer(GetProfileFloat(sProfile, "death_cam_time_death"), Timer_ClientResetDeathCamEnd, GetClientUserId(client));
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
	if (client <= 0) return;
	
	if (timer != g_hPlayerDeathCamTimer[client]) return;
	
	SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]));
	
	if(Npc.IsValid())
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(Npc.Index, sProfile, sizeof(sProfile));
	
		g_bPlayerDeathCamShowOverlay[client] = true;
		g_hPlayerDeathCamTimer[client] = CreateTimer(GetProfileFloat(sProfile, "death_cam_time_death"), Timer_ClientResetDeathCamEnd, userid);
	}
}

public Action Timer_ClientResetDeathCamEnd(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (timer != g_hPlayerDeathCamTimer[client]) return;
	
	SetEntProp(client, Prop_Data, "m_takedamage", 2); // We do this because the point_viewcontrol entity changes our damage state.
	
	int iDeathCamBoss = NPCGetFromUniqueID(g_iPlayerDeathCamBoss[client]);
	if (iDeathCamBoss != -1)
	{
		if (g_bSlenderInDeathcam[iDeathCamBoss])
		{
			int iSlender = NPCGetEntIndex(iDeathCamBoss);
			if (iSlender && iSlender != INVALID_ENT_REFERENCE)
			{
				SetEntityRenderMode(iSlender, RENDER_NORMAL);
				SetEntityRenderColor(iSlender, 255, 255, 255, 255);
				g_hSlenderEntityThink[iDeathCamBoss] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(iSlender), TIMER_REPEAT);
				if (!(NPCGetFlags(iDeathCamBoss) & SFF_FAKE)) g_bSlenderInDeathcam[iDeathCamBoss] = false;
			}
		}
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
			if (g_bSlenderInDeathcam[iDeathCamBoss])
			{
				TeleportEntity(client, g_vecPlayerOriginalDeathcamPosition[client], NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }));
				g_bSlenderInDeathcam[iDeathCamBoss] = false;
			}
			SlenderMarkAsFake(iDeathCamBoss);	
			SetEntityMoveType(client, MOVETYPE_WALK);
		}
	}
	else//The boss is invalid? But the player got a death cam?
	{
		//Then kill him anyways.
		KillClient(client);
		ForcePlayerSuicide(client);
	}
	ClientResetDeathCam(client);
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
static int g_iGhostModelIndex;
static Handle g_hPlayerGhostModeConnectionCheckTimer[MAXPLAYERS + 1] = { INVALID_HANDLE, ... };
static float g_flPlayerGhostModeConnectionTimeOutTime[MAXPLAYERS + 1] = { -1.0, ... };
static float g_flPlayerGhostModeConnectionBootTime[MAXPLAYERS + 1] = { -1.0, ... };

void SF2_SetGhostModel(int iModelIndex)
{
	g_iGhostModelIndex = iModelIndex;
}

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
		if (GetConVarBool(g_cvGhostModeConnectionCheck))
		{
			g_hPlayerGhostModeConnectionCheckTimer[client] = CreateTimer(0.0, Timer_GhostModeConnectionCheck, GetClientUserId(client), TIMER_REPEAT);
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

		PvP_OnClientGhostModeEnable(client);
	}
	else
	{
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_GHOSTMODE, 0, "{green}Exited ghost mode.");
#endif
		TF2Attrib_SetByName(client, "mod see enemy health", 0.0);
		g_hPlayerGhostModeConnectionCheckTimer[client] = INVALID_HANDLE;
		g_flPlayerGhostModeConnectionTimeOutTime[client] = -1.0;
		g_flPlayerGhostModeConnectionBootTime[client] = -1.0;
	
		if (IsClientInGame(client))
		{
			SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_YES);
			TF2_RemoveCondition(client, TFCond_Stealthed);
			SetEntityGravity(client, 1.0);
			SetEntProp(client, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_PLAYER);
			SetEntityMoveType(client, MOVETYPE_WALK);
			Client_ModelOverrides(client);
		}
	}
}

public Action Timer_GhostModeConnectionCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerGhostModeConnectionCheckTimer[client]) return Plugin_Stop;
	
	if (!IsFakeClient(client) && IsClientTimingOut(client))
	{
		float bootTime = g_flPlayerGhostModeConnectionBootTime[client];
		bool Check = GetConVarBool(g_cvGhostModeConnection);
		if (bootTime < 0.0 && !Check)
		{
			bootTime = GetGameTime() + GetConVarFloat(g_cvGhostModeConnectionTolerance);
			g_flPlayerGhostModeConnectionBootTime[client] = bootTime;
			g_flPlayerGhostModeConnectionTimeOutTime[client] = GetGameTime();
		}
		
		if (GetGameTime() >= bootTime || Check)
		{
			ClientSetGhostModeState(client, false);
			TF2_RespawnPlayer(client);
			
			char authString[128];
			GetClientAuthId(client,AuthId_Engine, authString, sizeof(authString));
			
			LogSF2Message("Removed %N (%s) from ghost mode due to timing out for %f seconds", client, authString, GetConVarFloat(g_cvGhostModeConnectionTolerance));
			
			float timeOutTime = g_flPlayerGhostModeConnectionTimeOutTime[client];
			CPrintToChat(client, "\x08FF4040FF%T", "SF2 Ghost Mode Bad Connection", client, RoundFloat(bootTime - timeOutTime));
			
			return Plugin_Stop;
		}
	}
	else
	{
		// Player regained connection; reset.
		g_flPlayerGhostModeConnectionBootTime[client] = -1.0;
	}
	
	return Plugin_Continue;
}
/**
 *	Makes sure that the player is a ghost when ghost mode is activated.
 */
void ClientHandleGhostMode(int client, bool bForceSpawn=false)
{
	if (!IsClientInGhostMode(client)) return;
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
	
	if (!TF2_IsPlayerInCondition(client, TFCond_Stealthed) || bForceSpawn)
	{
		TF2_StripWearables(client);
		SetEntityGravity(client, 0.5);
		TF2_AddCondition(client, TFCond_Stealthed, -1.0);
		SetEntProp(client, Prop_Data, "m_takedamage", DAMAGE_NO);
		SetEntData(client, g_offsCollisionGroup, 2, 4, true);
		SetEntProp(client, Prop_Data, "m_CollisionGroup", COLLISION_GROUP_DEBRIS);
		SetEntityMoveType(client, MOVETYPE_NOCLIP);
		Client_ModelOverrides(client, g_iGhostModelIndex);
		
		// Set first observer target.
		ClientGhostModeNextTarget(client);
		ClientActivateUltravision(client);
		
		// screen overlay timer
		g_hPlayerOverlayCheck[client] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(client), TIMER_REPEAT);
		TriggerTimer(g_hPlayerOverlayCheck[client], true);
		
		CreateTimer(0.2, Timer_ClientGhostStripWearables, GetClientUserId(client));
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientHandleGhostMode(%d, %d)", client, bForceSpawn);
#endif
}

public Action Timer_ClientGhostStripWearables(Handle timer, int userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0 || iClient > MaxClients) return;
	if (!IsClientInGhostMode(iClient)) return;
	TF2_StripWearables(iClient);
}

void ClientGhostModeNextTarget(int client)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientGhostModeNextTarget(%d)", client);
#endif

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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientGhostModeNextTarget(%d)", client);
#endif
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
	
	if (sScareSound[0])
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
	
	if (sSightSound[0])
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
		float flBossDist = GetVectorDistance(flMyPos, flBossPos);
		
		float flStressScalar = 1.0 + (flDistUnComfortZone / flBossDist);
		
		ClientAddStress(client, 0.1 * flStressScalar);
	}
	else
	{
		LogError("Warning! %s supports sight sounds, but was given a blank sound!", sProfile);
	}
}

void ClientResetScare(int client)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetScare(%d)", client);
#endif

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_flPlayerScareNextTime[client][i] = -1.0;
		g_flPlayerScareLastTime[client][i] = -1.0;
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetScare(%d)", client);
#endif
}

//	==========================================================
//	ANTI-CAMPING FUNCTIONS
//	==========================================================

stock void ClientResetCampingStats(int client)
{
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetCampingStats(%d)", client);
#endif

	g_iPlayerCampingStrikes[client] = 0;
	g_bPlayerIsExitCamping[client] = false;
	g_hPlayerCampingTimer[client] = INVALID_HANDLE;
	g_bPlayerCampingFirstTime[client] = true;
	g_flPlayerCampingLastPosition[client][0] = 0.0;
	g_flPlayerCampingLastPosition[client][1] = 0.0;
	g_flPlayerCampingLastPosition[client][2] = 0.0;
	g_flClientAllowedTimeNearEscape[client] = GetConVarFloat(g_cvExitCampingTimeAllowed);
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetCampingStats(%d)", client);
#endif
}

void ClientStartCampingTimer(int client)
{
	g_hPlayerCampingTimer[client] = CreateTimer(5.0, Timer_ClientCheckCamp, GetClientUserId(client), TIMER_REPEAT);
}

public Action Timer_ClientCheckCamp(Handle timer, any userid)
{
	if (IsRoundInWarmup()) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerCampingTimer[client]) return Plugin_Stop;
	
	if (IsRoundEnding() || !IsPlayerAlive(client) || g_bPlayerEliminated[client] || DidClientEscape(client)) return Plugin_Stop;
	
	if (!g_bPlayerCampingFirstTime[client])
	{
		bool bCamping = false;
		float flPos[3], flMaxs[3], flMins[3];
		GetClientAbsOrigin(client, flPos);
		GetEntPropVector(client, Prop_Send, "m_vecMins", flMins);
		GetEntPropVector(client, Prop_Send, "m_vecMaxs", flMaxs);
		
		// Only do something if the player is NOT stuck.
		float flDistFromLastPosition = GetVectorDistance(g_flPlayerCampingLastPosition[client], flPos);
		float flDistFromClosestBoss = 9999999.0;
		int iClosestBoss = -1;
		
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1) continue;
			
			int iSlender = NPCGetEntIndex(i);
			if (!iSlender || iSlender == INVALID_ENT_REFERENCE) continue;
			
			float flSlenderPos[3];
			SlenderGetAbsOrigin(i, flSlenderPos);
			
			float flDist = GetVectorDistance(flSlenderPos, flPos);
			if (flDist < flDistFromClosestBoss)
			{
				iClosestBoss = i;
				flDistFromClosestBoss = flDist;
			}
		}
		/*if(IsSpaceOccupiedIgnorePlayers(flPos, flMins, flMaxs, client))
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is stuck, no actions taken", client, client);*/
		if (GetConVarBool(g_cvCampingEnabled) && 
			!g_bRoundGrace &&
			g_flPlayerStaticAmount[client] <= GetConVarFloat(g_cvCampingNoStrikeSanity) && 
			(iClosestBoss == -1 || flDistFromClosestBoss >= GetConVarFloat(g_cvCampingNoStrikeBossDistance)) &&
			flDistFromLastPosition <= GetConVarFloat(g_cvCampingMinDistance))
		{
			bCamping = true;
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk, or camping", client, client);
		}
		if(bCamping)
		{
			g_iPlayerCampingStrikes[client]++;
			if (g_iPlayerCampingStrikes[client] < GetConVarInt(g_cvCampingMaxStrikes))
			{
				if (g_iPlayerCampingStrikes[client] >= GetConVarInt(g_cvCampingStrikesWarn))
				{
					CPrintToChat(client, "{red}%T", "SF2 Camping System Warning", client, (GetConVarInt(g_cvCampingMaxStrikes) - g_iPlayerCampingStrikes[client]) * 5);
				}
			}
			else
			{
				g_iPlayerCampingStrikes[client] = 0;
				ClientStartDeathCam(client, 0, flPos, true);
			}
		}
		else
		{
			// Forgiveness.
			if (g_iPlayerCampingStrikes[client] > 0)
			{
				//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is forgiven of one strike.", client, client);
				g_iPlayerCampingStrikes[client]--;
			}
		}
		
		g_flPlayerCampingLastPosition[client][0] = flPos[0];
		g_flPlayerCampingLastPosition[client][1] = flPos[1];
		g_flPlayerCampingLastPosition[client][2] = flPos[2];
	}
	else
	{
		g_bPlayerCampingFirstTime[client] = false;
		//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk/camping for the 1st time since the reset, don't take any actions for now.....", client, client);
	}
	
	return Plugin_Continue;
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
	g_hPlayerBlinkTimer[client] = INVALID_HANDLE;
	g_bPlayerBlink[client] = false;
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
	g_hPlayerBlinkTimer[client] = CreateTimer(GetConVarFloat(g_cvPlayerBlinkHoldTime), Timer_BlinkTimer2, GetClientUserId(client));
	
	UTIL_ScreenFade(client, 100, RoundToFloor(GetConVarFloat(g_cvPlayerBlinkHoldTime) * 1000.0), FFADE_IN, 0, 0, 0, 255);
	
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
	g_hPlayerBlinkTimer[client] = INVALID_HANDLE;
	g_flPlayerBlinkMeter[client] = 1.0;
}

void ClientStartDrainingBlinkMeter(int client)
{
	g_hPlayerBlinkTimer[client] = CreateTimer(ClientGetBlinkRate(client), Timer_BlinkTimer, GetClientUserId(client), TIMER_REPEAT);
}

public Action Timer_BlinkTimer(Handle timer, any userid)
{
	if (IsRoundInWarmup()) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerBlinkTimer[client]) return Plugin_Stop;
	
	if (IsPlayerAlive(client) && !IsClientInDeathCam(client) && !g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !IsRoundEnding())
	{
		int iOverride = GetConVarInt(g_cvPlayerInfiniteBlinkOverride);
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

public Action Timer_BlinkTimer2(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (timer != g_hPlayerBlinkTimer[client]) return;
	
	ClientUnblink(client);
	ClientStartDrainingBlinkMeter(client);
}

float ClientGetBlinkRate(int client)
{
	float flValue = GetConVarFloat(g_cvPlayerBlinkRate);
	if (GetEntProp(client, Prop_Send, "m_nWaterLevel") >= 3) 
	{
		// Being underwater makes you blink faster, obviously.
		flValue *= 0.75;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		
		NPCGetProfile(i, sProfile, sizeof(sProfile));
		
		if (g_bPlayerSeesSlender[client][i]) 
		{
			flValue *= GetProfileFloat(sProfile, "blink_look_rate_multiply", 1.0);
		}
		
		else if (g_iPlayerStaticMode[client][i] == Static_Increase)
		{
			flValue *= GetProfileFloat(sProfile, "blink_static_rate_multiply", 1.0);
		}
	}
	
	if (TF2_GetPlayerClass(client) == TFClass_Sniper) flValue *= 1.5;
	
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
			float flPercent = (GetVectorDistance(startPos, endPos) / flLength);
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetOverlay(%d)", client);
#endif
	
	g_hPlayerOverlayCheck[client] = INVALID_HANDLE;
	
	if (IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay \"\"");
	}
	
#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetOverlay(%d)", client);
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
//	MUSIC SYSTEM FUNCTIONS
//	==========================================================

stock void ClientUpdateMusicSystem(int client, bool bInitialize=false)
{
	int iOldPageMusicMaster = EntRefToEntIndex(g_iPlayerPageMusicMaster[client]);
	int iOldMusicFlags = g_iPlayerMusicFlags[client];
	int iChasingBoss = -1;
	int iChasingSeeBoss = -1;
	int iAlertBoss = -1;
	int i20DollarsBoss = -1;
	
	if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !g_bPlayerProxy[client]) || SF_SpecialRound(SPECIALROUND_REALISM)) 
	{
		g_iPlayerMusicFlags[client] = 0;
		g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
		if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		{
			char sPath[PLATFORM_MAX_PATH];
			GetBossMusic(sPath,sizeof(sPath));
			StopSound(client, MUSIC_CHAN, sPath);
			if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				StopSound(client, MUSIC_CHAN, TRIPLEBOSSESMUSIC);
			}
		}
	}
	else
	{
		bool bPlayMusicOnEscape = true;
		char sName[64];
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
			if (StrEqual(sName, "sf2_escape_custommusic", false))
			{
				bPlayMusicOnEscape = false;
				break;
			}
		}
		
		// Page music first.
		int iPageRange = 0;
		
		if (GetArraySize(g_hPageMusicRanges) > 0) // Map has its own defined page music?
		{
			for (int i = 0, iSize = GetArraySize(g_hPageMusicRanges); i < iSize; i++)
			{
				ent = EntRefToEntIndex(GetArrayCell(g_hPageMusicRanges, i));
				if (!ent || ent == INVALID_ENT_REFERENCE) continue;
				
				int iMin = GetArrayCell(g_hPageMusicRanges, i, 1);
				int iMax = GetArrayCell(g_hPageMusicRanges, i, 2);
				
				if (g_iPageCount >= iMin && g_iPageCount <= iMax)
				{
					g_iPlayerPageMusicMaster[client] = GetArrayCell(g_hPageMusicRanges, i);
					break;
				}
			}
		}
		else // Nope. Use old system instead.
		{
			g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
		
			float flPercent = g_iPageMax > 0 ? (float(g_iPageCount) / float(g_iPageMax)) : 0.0;
			if (flPercent > 0.0 && flPercent <= 0.25) iPageRange = 1;
			else if (flPercent > 0.25 && flPercent <= 0.5) iPageRange = 2;
			else if (flPercent > 0.5 && flPercent <= 0.75) iPageRange = 3;
			else if (flPercent > 0.75) iPageRange = 4;
			
			if (iPageRange == 1) ClientAddMusicFlag(client, MUSICF_PAGES1PERCENT);
			else if (iPageRange == 2) ClientAddMusicFlag(client, MUSICF_PAGES25PERCENT);
			else if (iPageRange == 3) ClientAddMusicFlag(client, MUSICF_PAGES50PERCENT);
			else if (iPageRange == 4) ClientAddMusicFlag(client, MUSICF_PAGES75PERCENT);
		}
		
		if (iPageRange != 1) ClientRemoveMusicFlag(client, MUSICF_PAGES1PERCENT);
		if (iPageRange != 2) ClientRemoveMusicFlag(client, MUSICF_PAGES25PERCENT);
		if (iPageRange != 3) ClientRemoveMusicFlag(client, MUSICF_PAGES50PERCENT);
		if (iPageRange != 4) ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
		
		if (IsRoundInEscapeObjective() && !bPlayMusicOnEscape) 
		{
			ClientRemoveMusicFlag(client, MUSICF_PAGES75PERCENT);
			g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
			//NPCStopMusic();
		}
		
		int iOldChasingBoss = g_iPlayerChaseMusicMaster[client];
		int iOldChasingSeeBoss = g_iPlayerChaseMusicSeeMaster[client];
		int iOldAlertBoss = g_iPlayerAlertMusicMaster[client];
		int iOld20DollarsBoss = g_iPlayer20DollarsMusicMaster[client];
		//int iOld90sSprint = g_iPlayer20DollarsMusicMaster[client];
		
		float flAnger = -1.0;
		float flSeeAnger = -1.0;
		float flAlertAnger = -1.0;
		float fl20DollarsAnger = -1.0;
		
		float flBuffer[3], flBuffer2[3], flBuffer3[3];
		
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1) continue;
			
			if (NPCGetEntIndex(i) == INVALID_ENT_REFERENCE) continue;
			
			NPCGetProfile(i, sProfile, sizeof(sProfile));
			
			int iBossType = NPCGetType(i);
			
			switch (iBossType)
			{
				case SF2BossType_Chaser:
				{
					GetClientAbsOrigin(client, flBuffer);
					SlenderGetAbsOrigin(i, flBuffer3);
					
					int iTarget = EntRefToEntIndex(g_iSlenderTarget[i]);
					if (iTarget != -1)
					{
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flBuffer2);
						
						if ((g_iSlenderState[i] == STATE_CHASE || g_iSlenderState[i] == STATE_ATTACK || g_iSlenderState[i] == STATE_STUN) &&
							!(NPCGetFlags(i) & SFF_MARKEDASFAKE) && 
							(iTarget == client || GetVectorDistance(flBuffer, flBuffer2) <= 850.0 || GetVectorDistance(flBuffer, flBuffer3) <= 850.0 || GetVectorDistance(flBuffer, g_flSlenderGoalPos[i]) <= 850.0))
						{
							char sPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sProfile, "sound_chase_music", sPath, sizeof(sPath), 1);
							if (sPath[0])
							{
								if (NPCGetAnger(i) > flAnger)
								{
									flAnger = NPCGetAnger(i);
									iChasingBoss = i;
								}
							}
							
							if ((g_iSlenderState[i] == STATE_CHASE || g_iSlenderState[i] == STATE_ATTACK) &&
								PlayerCanSeeSlender(client, i, false))
							{
								if (iOldChasingSeeBoss == -1 || !PlayerCanSeeSlender(client, iOldChasingSeeBoss, false) || (NPCGetAnger(i) > flSeeAnger))
								{
									GetRandomStringFromProfile(sProfile, "sound_chase_visible", sPath, sizeof(sPath), 1);
									
									if (sPath[0])
									{
										flSeeAnger = NPCGetAnger(i);
										iChasingSeeBoss = i;
									}
								}
								
								if (g_b20Dollars || SF_SpecialRound(SPECIALROUND_20DOLLARS))
								{
									if (iOld20DollarsBoss == -1 || !PlayerCanSeeSlender(client, iOld20DollarsBoss, false) || (NPCGetAnger(i) > fl20DollarsAnger))
									{
										GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sPath, sizeof(sPath), 1);
										
										if (sPath[0] || SF_SpecialRound(SPECIALROUND_20DOLLARS))
										{
											fl20DollarsAnger = NPCGetAnger(i);
											i20DollarsBoss = i;
										}
									}
								}
							}
						}
					}
					
					if (g_iSlenderState[i] == STATE_ALERT)
					{
						char sPath[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sProfile, "sound_alert_music", sPath, sizeof(sPath), 1);
						if (!sPath[0]) continue;
					
						if (!(NPCGetFlags(i) & SFF_MARKEDASFAKE))
						{
							if (GetVectorDistance(flBuffer, flBuffer3) <= 850.0 || GetVectorDistance(flBuffer, g_flSlenderGoalPos[i]) <= 850.0)
							{
								if (NPCGetAnger(i) > flAlertAnger)
								{
									flAlertAnger = NPCGetAnger(i);
									iAlertBoss = i;
								}
							}
						}
					}
				}
			}
		}
		
		if (iChasingBoss != iOldChasingBoss)
		{
			if (iChasingBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASE);
			}
		}
		
		if (iChasingSeeBoss != iOldChasingSeeBoss)
		{
			if (iChasingSeeBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_CHASEVISIBLE);
			}
		}
		
		if (iAlertBoss != iOldAlertBoss)
		{
			if (iAlertBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_ALERT);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_ALERT);
			}
		}
		
		if (i20DollarsBoss != iOld20DollarsBoss)
		{
			if (i20DollarsBoss != -1)
			{
				ClientAddMusicFlag(client, MUSICF_20DOLLARS);
			}
			else
			{
				ClientRemoveMusicFlag(client, MUSICF_20DOLLARS);
			}
		}
	}
	
	if (IsValidClient(client))
	{
		bool bWasChase = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_CHASE);
		bool bChase = ClientHasMusicFlag(client, MUSICF_CHASE);
		bool bWasChaseSee = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_CHASEVISIBLE);
		bool bChaseSee = ClientHasMusicFlag(client, MUSICF_CHASEVISIBLE);
		bool bAlert = ClientHasMusicFlag(client, MUSICF_ALERT);
		bool bWasAlert = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_ALERT);
		bool b20Dollars = ClientHasMusicFlag(client, MUSICF_20DOLLARS);
		bool bWas20Dollars = ClientHasMusicFlag2(iOldMusicFlags, MUSICF_20DOLLARS);
		char sPath[PLATFORM_MAX_PATH];
		if (IsRoundEnding() || !IsClientInGame(client) || IsFakeClient(client) || DidClientEscape(client) || (g_bPlayerEliminated[client] && !IsClientInGhostMode(client) && !g_bPlayerProxy[client])) 
		{
		}
		else if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		{
			if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				GetBossMusic(sPath,sizeof(sPath));
				ClientMusicStart(client, sPath, _, MUSIC_PAGE_VOLUME);
				return;
			}
			else
			{
				ClientMusicStart(client, TRIPLEBOSSESMUSIC, _, MUSIC_PAGE_VOLUME);
				return;
			}
		}
		// Custom system.
		if (GetArraySize(g_hPageMusicRanges) > 0) 
		{
		
			int iMaster = EntRefToEntIndex(g_iPlayerPageMusicMaster[client]);
			if (iMaster != INVALID_ENT_REFERENCE)
			{
				for (int i = 0, iSize = GetArraySize(g_hPageMusicRanges); i < iSize; i++)
				{
					int ent = EntRefToEntIndex(GetArrayCell(g_hPageMusicRanges, i));
					if (!ent || ent == INVALID_ENT_REFERENCE) continue;
					
					GetEntPropString(ent, Prop_Data, "m_iszSound", sPath, sizeof(sPath));
					
					if (ent == iMaster && 
						(iOldPageMusicMaster != iMaster || iOldPageMusicMaster == INVALID_ENT_REFERENCE))
					{
						if (!sPath[0])
						{
							LogError("Could not play music of page range %d-%d: no sound path specified!", GetArrayCell(g_hPageMusicRanges, i, 1), GetArrayCell(g_hPageMusicRanges, i, 2));
						}
						else
						{
							ClientMusicStart(client, sPath, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
						}
						
						if (iOldPageMusicMaster && iOldPageMusicMaster != INVALID_ENT_REFERENCE)
						{
							GetEntPropString(iOldPageMusicMaster, Prop_Data, "m_iszSound", sPath, sizeof(sPath));
							if (sPath[0])
							{
								StopSound(client, MUSIC_CHAN, sPath);
							}
						}
					}
				}
			}
			else
			{
				if (iOldPageMusicMaster && iOldPageMusicMaster != INVALID_ENT_REFERENCE)
				{
					GetEntPropString(iOldPageMusicMaster, Prop_Data, "m_iszSound", sPath, sizeof(sPath));
					if (sPath[0])
					{
						StopSound(client, MUSIC_CHAN, sPath);
					}
				}
			}
		}
		
		// Old system.
		if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES1PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
		{
			StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES1_SOUND);
		}
		else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES1PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES1PERCENT))
		{
			ClientMusicStart(client, MUSIC_GOTPAGES1_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		
		if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES25PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
		{
			StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES2_SOUND);
		}
		else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES25PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES25PERCENT))
		{
			ClientMusicStart(client, MUSIC_GOTPAGES2_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		
		if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES50PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
		{
			StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES3_SOUND);
		}
		else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES50PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES50PERCENT))
		{
			ClientMusicStart(client, MUSIC_GOTPAGES3_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		
		if ((bInitialize || ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES75PERCENT)) && !ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
		{
			StopSound(client, MUSIC_CHAN, MUSIC_GOTPAGES4_SOUND);
		}
		else if ((bInitialize || !ClientHasMusicFlag2(iOldMusicFlags, MUSICF_PAGES75PERCENT)) && ClientHasMusicFlag(client, MUSICF_PAGES75PERCENT))
		{
			ClientMusicStart(client, MUSIC_GOTPAGES4_SOUND, _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		
		int iMainMusicState = 0;
		
		if (bAlert != bWasAlert || iAlertBoss != g_iPlayerAlertMusicMaster[client])
		{
			if (bAlert && !bChase)
			{
				ClientAlertMusicStart(client, iAlertBoss);
				if (!bWasAlert) iMainMusicState = -1;
			}
			else
			{
				ClientAlertMusicStop(client, g_iPlayerAlertMusicMaster[client]);
				if (!bChase && bWasAlert) iMainMusicState = 1;
			}
		}
		
		if (bChase != bWasChase || iChasingBoss != g_iPlayerChaseMusicMaster[client])
		{
			if (bChase)
			{
				ClientMusicChaseStart(client, iChasingBoss);
				
				if (!bWasChase)
				{
					iMainMusicState = -1;
					
					if (bAlert)
					{
						ClientAlertMusicStop(client, g_iPlayerAlertMusicMaster[client]);
					}
				}
			}
			else
			{
				ClientMusicChaseStop(client, g_iPlayerChaseMusicMaster[client]);
				if (bWasChase)
				{
					if (bAlert)
					{
						ClientAlertMusicStart(client, iAlertBoss);
					}
					else
					{
						iMainMusicState = 1;
					}
				}
			}
		}
		
		if (bChaseSee != bWasChaseSee || iChasingSeeBoss != g_iPlayerChaseMusicSeeMaster[client])
		{
			if (bChaseSee)
			{
				ClientMusicChaseSeeStart(client, iChasingSeeBoss);
			}
			else
			{
				ClientMusicChaseSeeStop(client, g_iPlayerChaseMusicSeeMaster[client]);
			}
		}
		
		if (b20Dollars != bWas20Dollars || i20DollarsBoss != g_iPlayer20DollarsMusicMaster[client])
		{
			if (b20Dollars)
			{
				Client20DollarsMusicStart(client, i20DollarsBoss);
			}
			else
			{
				Client20DollarsMusicStop(client, g_iPlayer20DollarsMusicMaster[client]);
			}
		}
		
		if (iMainMusicState == 1)
		{
			ClientMusicStart(client, g_strPlayerMusic[client], _, MUSIC_PAGE_VOLUME, bChase || bAlert);
		}
		else if (iMainMusicState == -1)
		{
			ClientMusicStop(client);
		}
		
		if (bChase || bAlert)
		{
			int iBossToUse = -1;
			if (bChase)
			{
				iBossToUse = iChasingBoss;
			}
			else
			{
				iBossToUse = iAlertBoss;
			}
			
			if (iBossToUse != -1)
			{
				// We got some alert/chase music going on! The player's excitement will no doubt go up!
				// Excitement, though, really depends on how close the boss is in relation to the
				// player.
				
				float flBossDist = NPCGetDistanceFromEntity(iBossToUse, client);
				float flScalar = flBossDist / 700.0;
				if (flScalar > 1.0) flScalar = 1.0;
				float flStressAdd = 0.1 * (1.0 - flScalar);
				
				ClientAddStress(client, flStressAdd);
			}
		}
	}
}

stock void ClientMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerMusic[client]);
	strcopy(g_strPlayerMusic[client], sizeof(g_strPlayerMusic[]), "");
	if (IsValidClient(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerMusicFlags[client] = 0;
	g_flPlayerMusicVolume[client] = 0.0;
	g_flPlayerMusicTargetVolume[client] = 0.0;
	g_hPlayerMusicTimer[client] = INVALID_HANDLE;
	g_iPlayerPageMusicMaster[client] = INVALID_ENT_REFERENCE;
}

stock void ClientMusicStart(int client, const char[] sNewMusic, float flVolume=-1.0, float flTargetVolume=-1.0, bool bCopyOnly=false)
{
	if (!IsValidClient(client)) return;
	if (!sNewMusic[0]) return;
	
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerMusic[client]);
	
	if (!StrEqual(sOldMusic, sNewMusic, false))
	{
		if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	}
	strcopy(g_strPlayerMusic[client], sizeof(g_strPlayerMusic[]), sNewMusic);
	if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		GetBossMusic(g_strPlayerMusic[client],sizeof(g_strPlayerMusic[]));
	if (flVolume >= 0.0) g_flPlayerMusicVolume[client] = flVolume;
	if (flTargetVolume >= 0.0) g_flPlayerMusicTargetVolume[client] = flTargetVolume;

	if (!bCopyOnly)
	{
		bool bPlayMusicOnEscape = false;
		char sName[64];
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
			if (StrEqual(sName, "sf2_escape_custommusic", false))
			{
				bPlayMusicOnEscape = true;
				break;
			}
		}
		if(g_iPageCount < g_iPageMax)
		{
			g_hPlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeInMusic, GetClientUserId(client), TIMER_REPEAT);
			TriggerTimer(g_hPlayerMusicTimer[client], true);
		}
		if(!bPlayMusicOnEscape)
		{
			g_hPlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeInMusic, GetClientUserId(client), TIMER_REPEAT);
			TriggerTimer(g_hPlayerMusicTimer[client], true);
		}
	}
	else
	{
		g_hPlayerMusicTimer[client] = INVALID_HANDLE;
	}
}

stock void ClientMusicStop(int client)
{
	g_hPlayerMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeOutMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerMusicTimer[client], true);
}

stock void Client20DollarsMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayer20DollarsMusic[client]);
	strcopy(g_strPlayer20DollarsMusic[client], sizeof(g_strPlayer20DollarsMusic[]), "");
	if (IsValidClient(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayer20DollarsMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayer20DollarsMusicTimer[client][i] = INVALID_HANDLE;
		g_flPlayer20DollarsMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
				if (!sOldMusic[0] && SF_SpecialRound(SPECIALROUND_20DOLLARS)) StopSound(client, MUSIC_CHAN, TWENTYDOLLARS_MUSIC);
			}
		}
	}
}

stock void Client20DollarsMusicStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayer20DollarsMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sBuffer, sizeof(sBuffer), 1);
	
	if (SF_SpecialRound(SPECIALROUND_20DOLLARS) && !sBuffer[0])
	{
		sBuffer = TWENTYDOLLARS_MUSIC;
	}
	else
	{
		return;
	}

	g_iPlayer20DollarsMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayer20DollarsMusic[client], sizeof(g_strPlayer20DollarsMusic[]), sBuffer);
	g_hPlayer20DollarsMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeIn20DollarsMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayer20DollarsMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientAlertMusicStop(client, iOldMaster);
	}
}

stock void Client20DollarsMusicStop(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayer20DollarsMusicMaster[client])
	{
		g_iPlayer20DollarsMusicMaster[client] = -1;
		strcopy(g_strPlayer20DollarsMusic[client], sizeof(g_strPlayer20DollarsMusic[]), "");
	}
	
	g_hPlayer20DollarsMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOut20DollarsMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayer20DollarsMusicTimer[client][iBossIndex], true);
}

stock void ClientAlertMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerAlertMusic[client]);
	strcopy(g_strPlayerAlertMusic[client], sizeof(g_strPlayerAlertMusic[]), "");
	if (IsValidClient(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerAlertMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerAlertMusicTimer[client][i] = INVALID_HANDLE;
		g_flPlayerAlertMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				GetRandomStringFromProfile(sProfile, "sound_alert_music", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

stock void ClientAlertMusicStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayerAlertMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_alert_music", sBuffer, sizeof(sBuffer), 1);
	
	if (!sBuffer[0]) return;
	
	g_iPlayerAlertMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayerAlertMusic[client], sizeof(g_strPlayerAlertMusic[]), sBuffer);
	g_hPlayerAlertMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInAlertMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerAlertMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientAlertMusicStop(client, iOldMaster);
	}
}

stock void ClientAlertMusicStop(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerAlertMusicMaster[client])
	{
		g_iPlayerAlertMusicMaster[client] = -1;
		strcopy(g_strPlayerAlertMusic[client], sizeof(g_strPlayerAlertMusic[]), "");
	}
	
	g_hPlayerAlertMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutAlertMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerAlertMusicTimer[client][iBossIndex], true);
}

stock void ClientChaseMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerChaseMusic[client]);
	strcopy(g_strPlayerChaseMusic[client], sizeof(g_strPlayerChaseMusic[]), "");
	if (IsValidClient(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerChaseMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerChaseMusicTimer[client][i] = INVALID_HANDLE;
		g_flPlayerChaseMusicVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsValidClient(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
				
				GetRandomStringFromProfile(sProfile, "sound_chase_music", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

stock void ClientMusicChaseStart(int client,int iBossIndex)
{
	if (!IsValidClient(client)) return;
	
	int iOldMaster = g_iPlayerChaseMusicMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_music", sBuffer, sizeof(sBuffer), 1);
	
	if (!sBuffer[0]) return;
	
	g_iPlayerChaseMusicMaster[client] = iBossIndex;
	strcopy(g_strPlayerChaseMusic[client], sizeof(g_strPlayerChaseMusic[]), sBuffer);
	if(MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))//A boss is overriding the music.
		GetBossMusic(g_strPlayerChaseMusic[client],sizeof(g_strPlayerChaseMusic[]));
	g_hPlayerChaseMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerChaseMusicTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientMusicChaseStop(client, iOldMaster);
	}
}

stock void ClientMusicChaseStop(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerChaseMusicMaster[client])
	{
		g_iPlayerChaseMusicMaster[client] = -1;
		strcopy(g_strPlayerChaseMusic[client], sizeof(g_strPlayerChaseMusic[]), "");
	}
	
	g_hPlayerChaseMusicTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerChaseMusicTimer[client][iBossIndex], true);
}

stock void ClientChaseMusicSeeReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayerChaseMusicSee[client]);
	strcopy(g_strPlayerChaseMusicSee[client], sizeof(g_strPlayerChaseMusicSee[]), "");
	if (IsClientInGame(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayerChaseMusicSeeMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		g_hPlayerChaseMusicSeeTimer[client][i] = INVALID_HANDLE;
		g_flPlayerChaseMusicSeeVolumes[client][i] = 0.0;
		
		if (NPCGetUniqueID(i) != -1)
		{
			if (IsClientInGame(client))
			{
				NPCGetProfile(i, sProfile, sizeof(sProfile));
			
				GetRandomStringFromProfile(sProfile, "sound_chase_visible", sOldMusic, sizeof(sOldMusic), 1);
				if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
			}
		}
	}
}

stock void ClientMusicChaseSeeStart(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	
	int iOldMaster = g_iPlayerChaseMusicSeeMaster[client];
	if (iOldMaster == iBossIndex) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_visible", sBuffer, sizeof(sBuffer), 1);
	if (!sBuffer[0]) return;
	
	g_iPlayerChaseMusicSeeMaster[client] = iBossIndex;
	strcopy(g_strPlayerChaseMusicSee[client], sizeof(g_strPlayerChaseMusicSee[]), sBuffer);
	g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeInChaseMusicSee, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerChaseMusicSeeTimer[client][iBossIndex], true);
	
	if (iOldMaster != -1)
	{
		ClientMusicChaseSeeStop(client, iOldMaster);
	}
}

stock void ClientMusicChaseSeeStop(int client,int iBossIndex)
{
	if (!IsClientInGame(client)) return;
	if (iBossIndex == -1) return;
	
	if (iBossIndex == g_iPlayerChaseMusicSeeMaster[client])
	{
		g_iPlayerChaseMusicSeeMaster[client] = -1;
		strcopy(g_strPlayerChaseMusicSee[client], sizeof(g_strPlayerChaseMusicSee[]), "");
	}
	
	g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = CreateTimer(0.01, Timer_PlayerFadeOutChaseMusicSee, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayerChaseMusicSeeTimer[client][iBossIndex], true);
}

/*stock void Client90sMusicReset(int client)
{
	char sOldMusic[PLATFORM_MAX_PATH];
	strcopy(sOldMusic, sizeof(sOldMusic), g_strPlayer90sMusic[client]);
	strcopy(g_strPlayer90sMusic[client], sizeof(g_strPlayer90sMusic[]), "");
	if (IsValidClient(client) && sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	
	g_iPlayer90sMusicMaster[client] = -1;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];

	g_hPlayer90sMusicTimer[client] = INVALID_HANDLE;
	g_flPlayer90sMusicVolumes[client] = 0.0;

	if (IsValidClient(client))
	{
		sOldMusic = NINETYSMUSIC;
		if (sOldMusic[0]) StopSound(client, MUSIC_CHAN, sOldMusic);
	}
}

stock void Client90sMusicStart(int client)
{
	if (!IsValidClient(client)) return;

	char sBuffer[PLATFORM_MAX_PATH];
	sBuffer = NINETYSMUSIC;
	
	if (!sBuffer[0]) return;
	
	g_iPlayer90sMusicMaster[client] = 1;
	
	strcopy(g_strPlayer90sMusic[client], sizeof(g_strPlayer90sMusic[]), sBuffer);
	g_hPlayer90sMusicTimer[client] = CreateTimer(0.01, Timer_PlayerFadeIn90sMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayer90sMusicTimer[client], true);
	
	if (client != -1)
	{
		Client90sMusicStop(client);
	}
}

stock void Client90sMusicStop(int client)
{
	if (!IsValidClient(client)) return;

	if (!IsClientSprinting(client))
	{
		g_iPlayer90sMusicMaster[client] = -1;
		strcopy(g_strPlayer90sMusic[client], sizeof(g_strPlayer90sMusic[]), "");
	}
	
	g_hPlayer90sMusicTimer[client]= CreateTimer(0.01, Timer_PlayerFadeOut90sMusic, GetClientUserId(client), TIMER_REPEAT);
	TriggerTimer(g_hPlayer90sMusicTimer[client], true);
}*/

public Action Timer_PlayerFadeInMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerMusicTimer[client]) return Plugin_Stop;
	
	g_flPlayerMusicVolume[client] += 0.07;
	if (g_flPlayerMusicVolume[client] > g_flPlayerMusicTargetVolume[client]) g_flPlayerMusicVolume[client] = g_flPlayerMusicTargetVolume[client];
	
	if (g_strPlayerMusic[client][0]) EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_flPlayerMusicVolume[client]);

	if (g_flPlayerMusicVolume[client] >= g_flPlayerMusicTargetVolume[client])
	{
		g_hPlayerMusicTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	if (timer != g_hPlayerMusicTimer[client]) return Plugin_Stop;

	g_flPlayerMusicVolume[client] -= 0.07;
	if (g_flPlayerMusicVolume[client] < 0.0) g_flPlayerMusicVolume[client] = 0.0;

	if (g_strPlayerMusic[client][0]) EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, g_flPlayerMusicVolume[client]);

	if (g_flPlayerMusicVolume[client] <= 0.0)
	{
		g_hPlayerMusicTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeIn20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayer20DollarsMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayer20DollarsMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] > 1.0) g_flPlayer20DollarsMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayer20DollarsMusic[client][0]) EmitSoundToClient(client, g_strPlayer20DollarsMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer20DollarsMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOut20DollarsMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayer20DollarsMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_20dollars_music", sBuffer, sizeof(sBuffer), 1);
	if (SF_SpecialRound(SPECIALROUND_20DOLLARS) && !sBuffer[0])
	{
		sBuffer = TWENTYDOLLARS_MUSIC;
	}
	
	if (StrEqual(sBuffer, g_strPlayer20DollarsMusic[client], false))
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	g_flPlayer20DollarsMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] < 0.0) g_flPlayer20DollarsMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0]) EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer20DollarsMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayer20DollarsMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayer20DollarsMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerAlertMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerAlertMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] > 1.0) g_flPlayerAlertMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerAlertMusic[client][0]) EmitSoundToClient(client, g_strPlayerAlertMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerAlertMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutAlertMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerAlertMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_alert_music", sBuffer, sizeof(sBuffer), 1);

	if (StrEqual(sBuffer, g_strPlayerAlertMusic[client], false))
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	g_flPlayerAlertMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] < 0.0) g_flPlayerAlertMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0]) EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerAlertMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayerAlertMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerAlertMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerChaseMusicVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] > 1.0) g_flPlayerChaseMusicVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerChaseMusic[client][0]) EmitSoundToClient(client, g_strPlayerChaseMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeInChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicSeeTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] += 0.07;
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] > 1.0) g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] = 1.0;

	if (g_strPlayerChaseMusicSee[client][0]) EmitSoundToClient(client, g_strPlayerChaseMusicSee[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicSeeVolumes[client][iBossIndex]);
	
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] >= 1.0)
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutChaseMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_music", sBuffer, sizeof(sBuffer), 1);

	if (StrEqual(sBuffer, g_strPlayerChaseMusic[client], false))
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	g_flPlayerChaseMusicVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] < 0.0) g_flPlayerChaseMusicVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0]) EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicVolumes[client][iBossIndex]);
	
	if (g_flPlayerChaseMusicVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerChaseMusicTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOutChaseMusicSee(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	int iBossIndex = -1;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (g_hPlayerChaseMusicSeeTimer[client][i] == timer)
		{
			iBossIndex = i;
			break;
		}
	}
	
	if (iBossIndex == -1) return Plugin_Stop;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, "sound_chase_visible", sBuffer, sizeof(sBuffer), 1);

	if (StrEqual(sBuffer, g_strPlayerChaseMusicSee[client], false))
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] -= 0.07;
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] < 0.0) g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] = 0.0;

	if (sBuffer[0]) EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayerChaseMusicSeeVolumes[client][iBossIndex]);
	
	if (g_flPlayerChaseMusicSeeVolumes[client][iBossIndex] <= 0.0)
	{
		g_hPlayerChaseMusicSeeTimer[client][iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}
/*
public Action Timer_PlayerFadeIn90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	g_flPlayer90sMusicVolumes[client] += 0.28;
	if (g_flPlayer90sMusicVolumes[client] > 0.5) g_flPlayer90sMusicVolumes[client] = 0.5;

	if (g_strPlayer90sMusic[client][0]) EmitSoundToClient(client, g_strPlayer90sMusic[client], _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer90sMusicVolumes[client]);
	
	if (g_flPlayer90sMusicVolumes[client] >= 0.5)
	{
		g_hPlayer90sMusicTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

public Action Timer_PlayerFadeOut90sMusic(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;

	char sBuffer[PLATFORM_MAX_PATH];
	sBuffer = NINETYSMUSIC;

	if (StrEqual(sBuffer, g_strPlayer90sMusic[client], false))
	{
		g_hPlayer90sMusicTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	g_flPlayer90sMusicVolumes[client] -= 0.28;
	if (g_flPlayer90sMusicVolumes[client] < 0.0) g_flPlayer90sMusicVolumes[client] = 0.0;

	if (sBuffer[0]) EmitSoundToClient(client, sBuffer, _, MUSIC_CHAN, _, SND_CHANGEVOL, g_flPlayer90sMusicVolumes[client]);
	
	if (g_flPlayer90sMusicVolumes[client] <= 0.0)
	{
		g_hPlayer90sMusicTimer[client] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}
*/
stock bool ClientHasMusicFlag(int client,int iFlag)
{
	return view_as<bool>(g_iPlayerMusicFlags[client] & iFlag);
}

stock bool ClientHasMusicFlag2(int iValue,int iFlag)
{
	return view_as<bool>(iValue & iFlag);
}

stock void ClientAddMusicFlag(int client,int iFlag)
{
	if (!ClientHasMusicFlag(client, iFlag)) g_iPlayerMusicFlags[client] |= iFlag;
}

stock void ClientRemoveMusicFlag(int client,int iFlag)
{
	if (ClientHasMusicFlag(client, iFlag)) g_iPlayerMusicFlags[client] &= ~iFlag;
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
	
	KvRewind(g_hConfig);
	if (KvJumpToKey(g_hConfig, profileName))
	{
		char s[32];
		
		if (KvJumpToKey(g_hConfig, sectionName))
		{
			for (int i2 = 1;; i2++)
			{
				IntToString(i2, s, sizeof(s));
				KvGetString(g_hConfig, s, buffer, sizeof(buffer));
				if (!buffer[0]) break;
				
				StopSound(client, iChannel, buffer);
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
		
		if (bReset || IsRoundEnding() || GetConVarBool(g_cvAllChat) || SF_IsBoxingMap())
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
				if (g_bSpecialRound && SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
				{
					if (DidClientEscape(i))
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
					bool bCanHear = false;
					if (GetConVarFloat(g_cvPlayerVoiceDistance) <= 0.0) bCanHear = true;
					
					if (!bCanHear)
					{
						float flMyPos[3], flHisPos[3];
						GetClientEyePosition(client, flMyPos);
						GetClientEyePosition(i, flHisPos);
						
						float flDist = GetVectorDistance(flMyPos, flHisPos);
						
						if (GetConVarFloat(g_cvPlayerVoiceWallScale) > 0.0)
						{
							Handle hTrace = TR_TraceRayFilterEx(flMyPos, flHisPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitCharacters);
							bool bDidHit = TR_DidHit(hTrace);
							delete hTrace;
							
							if (bDidHit)
							{
								flDist *= GetConVarFloat(g_cvPlayerVoiceWallScale);
							}
						}
						
						if (flDist <= GetConVarFloat(g_cvPlayerVoiceDistance))
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("START ClientResetSlenderStats(%d)", client);
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
	if (GetConVarInt(g_cvDebugDetail) > 2) DebugMessage("END ClientResetSlenderStats(%d)", client);
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
	char s[64];
	Format(s, sizeof(s), "%d ; %d ; %d ; %d ; %d ; %d ; %d", g_iPlayerQueuePoints[client], 
		g_iPlayerPreferences[client].PlayerPreference_PvPAutoSpawn, 
		g_iPlayerPreferences[client].PlayerPreference_ShowHints, 
		g_iPlayerPreferences[client].PlayerPreference_MuteMode,
		g_iPlayerPreferences[client].PlayerPreference_FilmGrain,
		g_iPlayerPreferences[client].PlayerPreference_EnableProxySelection,
		g_iPlayerPreferences[client].PlayerPreference_FlashlightTemperature);
		
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

		if (!SF_SpecialRound(SPECIALROUND_WALLHAX) && !IsClientInGhostMode(other) && !g_bPlayerProxy[other])
		{
			if (iOwner == other) return Plugin_Handled;
		
			if (!IsPlayerAlive(iOwner) || !IsPlayerAlive(other) || !g_bPlayerEliminated[other] || !SF_SpecialRound(SPECIALROUND_WALLHAX)) 
			{
				return Plugin_Handled;
			}
		}
		
		if (IsClientInGhostMode(other) || g_bPlayerProxy[other])
		{
			return Plugin_Continue;
		}
		
		if (SF_SpecialRound(SPECIALROUND_WALLHAX) && !g_bPlayerEscaped[other] && GetClientTeam(other) == TFTeam_Red)
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
				if (GetVectorLength(vecSpeed, false) >= 100.0)
				{
					float flOwnerPos[3], flProxyPos[3];
					GetClientEyePosition(iOwner, flOwnerPos);
					GetClientEyePosition(other, flProxyPos);
					
					if (GetVectorDistance(flOwnerPos, flProxyPos) <= (700.0 + ((g_bPlayerHasRegenerationItem[iOwner]) ? 300.0 : 0.0)))//To-do add a cvar for that.
					{
						return Plugin_Continue;
					}
				}
			}
			
			float vecSpeed[3];
			SDK_GetSmoothedVelocity(other, vecSpeed);
			if (GetVectorLength(vecSpeed, false) < 100.0)//Don't show if not moving slowly.
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
	if (g_bPlayerProxy[other]) return Plugin_Continue;
	if (IsClientInGhostMode(other)) return Plugin_Continue;
	if (SF_SpecialRound(SPECIALROUND_WALLHAX) && ((GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other]) || (g_bPlayerProxy[other]))) return Plugin_Continue;
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
		default: strcopy(sBuffer, sBufferLen, "");
	}
}

stock void ClientSDKFlashlightTurnOn(int client)
{
	if (!IsValidClient(client)) return;
	
	int iEffects = GetEntProp(client, Prop_Send, "m_fEffects");
	if (iEffects & EF_DIMLIGHT) return;

	iEffects |= EF_DIMLIGHT;
	
	SetEntProp(client, Prop_Send, "m_fEffects", iEffects);
}

stock void ClientSDKFlashlightTurnOff(int client)
{
	if (!IsValidClient(client)) return;
	
	int iEffects = GetEntProp(client, Prop_Send, "m_fEffects");
	if (!(iEffects & EF_DIMLIGHT)) return;

	iEffects &= ~EF_DIMLIGHT;
	
	SetEntProp(client, Prop_Send, "m_fEffects", iEffects);
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
				GetVectorDistance(eyePos, pos) >= GetEntDataFloat(iFogEntity, g_offsFogCtrlEnd)) 
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
void SF2_RefreshRestrictions()
{
	for(int client=1;client <=MaxClients;client++)
	{
		if(IsValidClient(client))
		{
			ClientSwitchToWeaponSlot(client, TFWeaponSlot_Melee);
			g_hPlayerPostWeaponsTimer[client]=CreateTimer(1.0,Timer_ClientPostWeapons,GetClientUserId(client));
		}
	}
}
public Action Timer_ClientPostWeapons(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (IsClientInGame(client) && !IsPlayerAlive(client)) return;
	
	if (!IsValidClient(client)) return;
	
	if (timer != g_hPlayerPostWeaponsTimer[client]) return;
	
	g_bPlayerHasRegenerationItem[client] = false;
	Handle hItem = INVALID_HANDLE;

#if defined DEBUG
	if (GetConVarInt(g_cvDebugDetail) > 0) 
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
	
	if (IsRoundEnding())
	{
		if (!g_bPlayerEliminated[client]) 
		{
			bRemoveWeapons = false;
			bRestrictWeapons = false;
			bKeepUtilityItems = false;
		}
	}
	
	// pvp
	if (IsClientInPvP(client)) 
	{
		bRemoveWeapons = false;
		bRestrictWeapons = false;
		bKeepUtilityItems = false;
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
	}
	
	if (SF_IsBoxingMap() && !g_bPlayerEliminated[client] && !IsRoundEnding())
	{
		bRestrictWeapons = false;
		bKeepUtilityItems = true;
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
				AcceptEntityInput(ent, "Kill");
			}
		}
		
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_demoshield")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				AcceptEntityInput(ent, "Kill");
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
				AcceptEntityInput(ent, "Kill");
			}
		}
		
		int iWeapon = INVALID_ENT_REFERENCE;
		iWeapon = GetPlayerWeaponSlot(client, TFWeaponSlot_Secondary);

		if (IsValidEdict(iWeapon))
		{
			int itemIndex = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
			switch (itemIndex)
			{
				case 222, 1121, 163, 129, 226, 354, 1001, 131, 406, 1099, 42, 159, 311, 433, 863, 1002, 1190, 58, 1105:
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
						AcceptEntityInput(ent, "Kill");
					}
				}
			}
		}
		
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_razorback")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				AcceptEntityInput(ent, "Kill");
			}
		}
		
		if (g_hRestrictedWeaponsConfig != INVALID_HANDLE)
		{
			hItem = INVALID_HANDLE;
			int iWeapon = INVALID_ENT_REFERENCE;
			for (int iSlot = 0; iSlot <= 5; iSlot++)
			{
				hItem = INVALID_HANDLE;
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
									case TFClass_Scout: hItem = g_hSDKWeaponScattergun;
									case TFClass_Sniper: hItem = g_hSDKWeaponSniperRifle;
									case TFClass_Soldier: hItem = g_hSDKWeaponRocketLauncher;
									case TFClass_DemoMan: hItem = g_hSDKWeaponGrenadeLauncher;
									case TFClass_Heavy: hItem = g_hSDKWeaponMinigun;
									case TFClass_Medic: hItem = g_hSDKWeaponSyringeGun;
									case TFClass_Pyro: hItem = g_hSDKWeaponFlamethrower;
									case TFClass_Spy: hItem = g_hSDKWeaponRevolver;
									case TFClass_Engineer: hItem = g_hSDKWeaponShotgunPrimary;
								}
							}
							case TFWeaponSlot_Secondary:
							{
								switch (iPlayerClass)
								{
									case TFClass_Scout: hItem = g_hSDKWeaponPistolScout;
									case TFClass_Sniper: hItem = g_hSDKWeaponSMG;
									case TFClass_Soldier: hItem = g_hSDKWeaponShotgunSoldier;
									case TFClass_DemoMan: hItem = g_hSDKWeaponStickyLauncher;
									case TFClass_Heavy: hItem = g_hSDKWeaponShotgunHeavy;
									case TFClass_Medic: hItem = g_hSDKWeaponMedigun;
									case TFClass_Pyro: hItem = g_hSDKWeaponShotgunPyro;
									case TFClass_Engineer: hItem = g_hSDKWeaponPistol;
								}
							}
							case TFWeaponSlot_Melee:
							{
								switch (iPlayerClass)
								{
									case TFClass_Scout: hItem = g_hSDKWeaponBat;
									case TFClass_Sniper: hItem = g_hSDKWeaponKukri;
									case TFClass_Soldier: hItem = g_hSDKWeaponShovel;
									case TFClass_DemoMan: hItem = g_hSDKWeaponBottle;
									case TFClass_Heavy: hItem = g_hSDKWeaponFists;
									case TFClass_Medic: hItem = g_hSDKWeaponBonesaw;
									case TFClass_Pyro: hItem = g_hSDKWeaponFireaxe;
									case TFClass_Spy: hItem = g_hSDKWeaponKnife;
									case TFClass_Engineer: hItem = g_hSDKWeaponWrench;
								}
							}
							case 4:
							{
								switch (iPlayerClass)
								{
									case TFClass_Spy: hItem = g_hSDKWeaponInvis;
								}
							}
						}
						
						if (hItem != INVALID_HANDLE)
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
		Handle hWeapon;
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
					
					hWeapon = PrepareItemHandle("tf_weapon_fireaxe", 214, 0, 0, "180 ; 20.0 ; 206 ; 1.33");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
				case 326: // The Back Scratcher
				{
					TF2_RemoveWeaponSlot(client, iSlot);

					hWeapon = PrepareItemHandle("tf_weapon_fireaxe", 326, 0, 0, "2 ; 1.25 ; 412 ; 1.25 ; 69 ; 0.25 ; 108 ; 1.25");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
				case 304: // Amputator
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_bonesaw", 304, 0, 0, "200 ; 0.0 ; 57 ; 2 ; 1 ; 0.8");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
				case 239: //GRU
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 239, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
				case 1100: //Bread Bite
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 1100, 0, 0, "107 ; 1.3 ; 772 ; 1.5 ; 129 ; 0.0 ; 414 ; 1.0 ; 1 ; 0.75");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
				case 426: //Eviction Notice
				{
					TF2_RemoveWeaponSlot(client, iSlot);
					
					hWeapon = PrepareItemHandle("tf_weapon_fists", 426, 0, 0, "6 ; 0.6 ; 107 ; 1.15 ; 737 ; 4.0 ; 1 ; 0.4 ; 412 ; 1.2");
					int iEnt = TF2Items_GiveNamedItem(client, hWeapon);
					delete hWeapon;
					EquipPlayerWeapon(client, iEnt);
				}
			}
		}
		delete hWeapon;
	}
	//Remove the teleport ability
	if (IsClientInPvP(client) || ((SF_IsRaidMap() || SF_IsBoxingMap()) && !g_bPlayerEliminated[client])) //DidClientEscape(client)
	{
		int iWeapon = INVALID_ENT_REFERENCE;
		Handle hWeapon;
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
				AcceptEntityInput(ent, "Kill");
			}
		}
		ent = -1;
		while ((ent = FindEntityByClassname(ent, "tf_wearable_campaign_item")) != -1)
		{
			if (GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity") == client)
			{
				AcceptEntityInput(ent, "Kill");
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
	
	delete hItem;
	
#if defined DEBUG
	int iWeapon = INVALID_ENT_REFERENCE;
	
	for (int i = 0; i <= 5; i++)
	{
		iWeapon = GetPlayerWeaponSlot(client, i);
		if (!IsValidEdict(iWeapon)) continue;
		
		iNewWeaponItemIndexes[i] = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
	}

	if (GetConVarInt(g_cvDebugDetail) > 0) 
	{
		for (int i = 0; i <= 5; i++)
		{
			DebugMessage("-> slot %d: %d (old: %d)", i, iNewWeaponItemIndexes[i], iOldWeaponItemIndexes[i]);
		}
	
		DebugMessage("END Timer_ClientPostWeapons(%d) -> remove = %d, restrict = %d", client, bRemoveWeapons, bRestrictWeapons);
	}
#endif
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
			
			if (hItemOverride != INVALID_HANDLE)
			{
				hItem = hItemOverride;

				return Plugin_Changed;
			}
			delete hItemOverride;
		}
	}
	
	return Plugin_Continue;
}

public void Frame_ReplaceSpyCicle(int client)
{
	if (IsClientInGame(client))
	{
		TF2_RemoveWeaponSlot(client, TFWeaponSlot_Melee);
		int iNewKnife = TF2Items_GiveNamedItem(client, g_hSDKWeaponKnife);
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

public Action Timer_ApplyCustomModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;

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

		if (view_as<bool>(KvGetNum(g_hConfig, "proxy_difficulty_models", 0)))
		{
			char sSectionNameHard[128], sSectionNameInsane[128], sSectionNameNightmare[128], sSectionNameApollyon[128];
			
			Format(sSectionName, sizeof(sSectionName), "mod_proxy_%s", sClassName);
			Format(sSectionNameHard, sizeof(sSectionNameHard), "mod_proxy_%s_hard", sClassName);
			Format(sSectionNameInsane, sizeof(sSectionNameInsane), "mod_proxy_%s_insane", sClassName);
			Format(sSectionNameNightmare, sizeof(sSectionNameNightmare), "mod_proxy_%s_nightmare", sClassName);
			Format(sSectionNameApollyon, sizeof(sSectionNameApollyon), "mod_proxy_%s_apollyon", sClassName);
			
			if ((GetRandomStringFromProfile(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0]) ||
				(GetRandomStringFromProfile(sProfile, "mod_proxy_all", sBuffer, sizeof(sBuffer)) && sBuffer[0]))
			{
				SetVariantString(sBuffer);
				AcceptEntityInput(client, "SetCustomModel");
				SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
				strcopy(g_sClientProxyModel[client],sizeof(g_sClientProxyModel[]),sBuffer);
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameHard, sBufferHard, sizeof(sBufferHard)) && sBufferHard[0]) ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_hard", sBufferHard, sizeof(sBufferHard)) && sBufferHard[0]))
				{
					strcopy(g_sClientProxyModelHard[client],sizeof(g_sClientProxyModelHard[]),sBufferHard);
				}
				else
				{
					strcopy(sBufferHard,sizeof(sBufferHard),sBuffer);
					strcopy(g_sClientProxyModelHard[client],sizeof(g_sClientProxyModelHard[]),sBufferHard);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameInsane, sBufferInsane, sizeof(sBufferInsane)) && sBufferInsane[0]) ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_insane", sBufferInsane, sizeof(sBufferInsane)) && sBufferInsane[0]))
				{
					strcopy(g_sClientProxyModelInsane[client],sizeof(g_sClientProxyModelInsane[]),sBufferInsane);
				}
				else
				{
					strcopy(sBufferInsane,sizeof(sBufferInsane),sBufferHard);
					strcopy(g_sClientProxyModelInsane[client],sizeof(g_sClientProxyModelInsane[]),sBufferInsane);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameNightmare, sBufferNightmare, sizeof(sBufferNightmare)) && sBufferNightmare[0]) ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_nightmare", sBufferNightmare, sizeof(sBufferNightmare)) && sBufferNightmare[0]))
				{
					strcopy(g_sClientProxyModelNightmare[client],sizeof(g_sClientProxyModelNightmare[]),sBufferNightmare);
				}
				else
				{
					strcopy(sBufferNightmare,sizeof(sBufferNightmare),sBufferInsane);
					strcopy(g_sClientProxyModelNightmare[client],sizeof(g_sClientProxyModelNightmare[]),sBufferNightmare);
				}
				
				if ((GetRandomStringFromProfile(sProfile, sSectionNameApollyon, sBufferApollyon, sizeof(sBufferApollyon)) && sBufferApollyon[0]) ||
					(GetRandomStringFromProfile(sProfile, "mod_proxy_all_apollyon", sBufferApollyon, sizeof(sBufferApollyon)) && sBufferApollyon[0]))
				{
					strcopy(g_sClientProxyModelApollyon[client],sizeof(g_sClientProxyModelApollyon[]),sBufferApollyon);
				}
				else
				{
					strcopy(sBufferApollyon,sizeof(sBufferApollyon),sBufferNightmare);
					strcopy(g_sClientProxyModelApollyon[client],sizeof(g_sClientProxyModelApollyon[]),sBufferApollyon);
				}
				
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT);
			}
		}
		else
		{
			Format(sSectionName, sizeof(sSectionName), "mod_proxy_%s", sClassName);
			if ((GetRandomStringFromProfile(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0]) ||
				(GetRandomStringFromProfile(sProfile, "mod_proxy_all", sBuffer, sizeof(sBuffer)) && sBuffer[0]))
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
				CreateTimer(0.5,ClientCheckProxyModel,GetClientUserId(client),TIMER_REPEAT);
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
			if (GetRandomStringFromProfile(sProfile, "sound_proxy_spawn", sBuffer, sizeof(sBuffer)) && sBuffer[0])
			{
				int iChannel = GetProfileNum(sProfile, "sound_proxy_spawn_channel", SNDCHAN_AUTO);
				int iLevel = GetProfileNum(sProfile, "sound_proxy_spawn_level", SNDLEVEL_NORMAL);
				int iFlags = GetProfileNum(sProfile, "sound_proxy_spawn_flags", SND_NOFLAGS);
				float flVolume = GetProfileFloat(sProfile, "sound_proxy_spawn_volume", SNDVOL_NORMAL);
				int iPitch = GetProfileNum(sProfile, "sound_proxy_spawn_pitch", SNDPITCH_NORMAL);
				
				EmitSoundToAll(sBuffer, client, iChannel, iLevel, iFlags, flVolume, iPitch);
			}
			
			bool Zombie = view_as<bool>(GetProfileNum(sProfile, "proxies_zombie", 0));
			if(Zombie)
			{
				int value = GetConVarInt(FindConVar("tf_forced_holiday"));
				if(value != 9 && value != 2)
					SetConVarInt(FindConVar("tf_forced_holiday"),9);//Full-Moon
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
}
public Action ClientCheckProxyModel(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if(client <= 0) return Plugin_Stop;
	if(!IsValidClient(client)) return Plugin_Stop;
	if(!IsPlayerAlive(client)) return Plugin_Stop;
	if(!g_bPlayerProxy[client]) return Plugin_Stop;
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
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
	if (g_hRestrictedWeaponsConfig == INVALID_HANDLE) return false;
	
	bool bReturn = false;
	
	char sItemDef[32];
	IntToString(iItemDef, sItemDef, sizeof(sItemDef));
	
	KvRewind(g_hRestrictedWeaponsConfig);
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
	if (KvJumpToKey(g_hRestrictedWeaponsConfig, "all"))
	{
		//bReturn = view_as<bool>(KvGetNum(g_hRestrictedWeaponsConfig, sItemDef));
		//view_as bool value turn to 2 into a true value.
		if(KvGetNum(g_hRestrictedWeaponsConfig, sItemDef)==1)
			bReturn=true;
		if(bProxyBoss && !bReturn)
		{
			int bProxyRestricted = KvGetNum(g_hRestrictedWeaponsConfig, sItemDef, 0);
			if(bProxyRestricted==2)
				bReturn=true;
		}
	}
	
	bool bFoundSection = false;
	KvRewind(g_hRestrictedWeaponsConfig);
	
	switch (iClass)
	{
		case TFClass_Scout: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "scout");
		case TFClass_Soldier: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "soldier");
		case TFClass_Sniper: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "sniper");
		case TFClass_DemoMan: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "demoman");
		case TFClass_Heavy: 
		{
			bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "heavy");
		
			if (!bFoundSection)
			{
				KvRewind(g_hRestrictedWeaponsConfig);
				bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "heavyweapons");
			}
		}
		case TFClass_Medic: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "medic");
		case TFClass_Spy: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "spy");
		case TFClass_Pyro: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "pyro");
		case TFClass_Engineer: bFoundSection = KvJumpToKey(g_hRestrictedWeaponsConfig, "engineer");
	}
	
	if (bFoundSection)
	{
		//bReturn = view_as<bool>(KvGetNum(g_hRestrictedWeaponsConfig, sItemDef, bReturn));
		if(KvGetNum(g_hRestrictedWeaponsConfig, sItemDef)==1)
			bReturn=true;
		if(bProxyBoss && !bReturn)
		{
			int bProxyRestricted = KvGetNum(g_hRestrictedWeaponsConfig, sItemDef, 0);
			if(bProxyRestricted==2)
				bReturn=true;
		}
	}
	
	return bReturn;
}

public Action Timer_RespawnPlayer(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return;
	
	if (!IsValidClient(client) || !IsClientInGame(client) || IsPlayerAlive(client)) return;
	
	TF2_RespawnPlayer(client);
}

void Client_ModelOverrides(int iEntity, int iModelIndex = 0)
{
    for(int i=0; i<4; i++)
    {
        SetEntProp(iEntity, Prop_Send, "m_nModelIndexOverrides", iModelIndex, _, i);
    }
}