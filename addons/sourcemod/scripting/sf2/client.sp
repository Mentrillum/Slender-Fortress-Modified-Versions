#if defined _sf2_client_included
 #endinput
#endif
#define _sf2_client_included

#pragma semicolon 1

#define SF2_OVERLAY_DEFAULT "overlays/slender/newcamerahud_3"
#define SF2_OVERLAY_DEFAULT_NO_FILMGRAIN "overlays/slender/nofilmgrain"

//Client Special Round Timer
static Handle g_ClientSpecialRoundTimer[MAXTF2PLAYERS];

// Jumpscare data.
static int g_PlayerJumpScareBoss[MAXTF2PLAYERS] = { -1, ... };
static float g_PlayerJumpScareLifeTime[MAXTF2PLAYERS] = { -1.0, ... };

static float g_PlayerScareBoostEndTime[MAXTF2PLAYERS] = { -1.0, ... };

// Frame data
int g_ClientMaxFrameDeathAnim[MAXTF2PLAYERS];
int g_ClientFrame[MAXTF2PLAYERS];

//Nav Data
//static CNavArea g_lastNavArea[MAXTF2PLAYERS];

#include "client/glow.sp"
#include "client/interactables.sp"
#include "client/hints.sp"
#include "client/think.sp"
#include "client/static.sp"
#include "client/blink.sp"
#include "client/deathcam.sp"
#include "client/ultravision.sp"
#include "client/flashlight.sp"
#include "client/peek.sp"
#include "client/sprint.sp"
#include "client/breathing.sp"
#include "client/ghostmode.sp"
#include "client/music.sp"
#include "client/proxy.sp"

void Client_SetupAPI()
{
	Sprint_SetupAPI();
}

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

public Action CH_PassFilter(int ent1, int ent2, bool &result)
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
	if (IsValidClient(client))
	{
		if (IsClientInPvE(client) || IsClientInPvP(client))
		{
			return Plugin_Continue;
		}

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

Action Hook_ClientSetTransmit(int client, int other)
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
		else
		{

		}
	}

	return Plugin_Continue;
}

public Action TF2_CalcIsAttackCritical(int client, int weapon, char[] weaponName, bool &result)
{
	if (!g_Enabled || g_RestartSessionEnabled || (g_PlayerEliminated[client] && !g_PlayerProxy[client]))
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

				if (GetVectorSquareMagnitude(pos1, pos2) < SquareFloat(50.0))
				{
					CollectPage(entity, client);
				}
			}
		}
	}

	if (g_PlayerProxy[client] && !IsClientCritBoosted(client))
	{
		result = false;
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

Action Hook_TEFireBullets(const char[] te_name, const int[] players, int numClients, float delay)
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

	ClientResetSlenderStats(client);
	ClientResetOverlay(client);
	ClientResetJumpScare(client);
	ClientUpdateListeningFlags(client);
	ClientResetHints(client);
	ClientResetScare(client);

	ClientDeactivateUltravision(client);

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
	TF2Attrib_RemoveByDefIndex(client, 49);
	SetEntProp(client, Prop_Send, "m_iAirDash", 0);

	HandlePlayerHUD(client);
	if (!SF_IsBoxingMap())
	{
		char name[MAX_NAME_LENGTH];
		FormatEx(name, sizeof(name), "%N", client);
		CPrintToChatAll("%t", "SF2 Player Escaped", name);
	}

	CheckRoundWinConditions();

	Call_StartForward(g_OnClientEscapeFwd);
	Call_PushCell(client);
	Call_Finish();

	Call_StartForward(g_OnPlayerEscapePFwd);
	Call_PushCell(SF2_BasePlayer(client));
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

float ClientGetDistanceFromEntity(int client, int entity)
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

void ClientProcessVisibility(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
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
			CBaseEntity(boss).GetAbsOrigin(slenderPos);
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
						SF2_BasePlayer(client).Stamina += NPCGetScareReplenishSprintAmount(master);
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
						SF2_ChaserEntity chaser = SF2_ChaserEntity(boss);
						if (chaser.IsValid() && chaser.State == STATE_IDLE || chaser.State == STATE_ALERT)
						{
							SF2_BasePlayer(client).SetForceChaseState(SF2NPC_BaseNPC(i), true);
							SetTargetMarkState(SF2NPC_BaseNPC(i), CBaseEntity(client), true);
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

			Call_StartForward(g_OnPlayerLookAtBossPFwd);
			Call_PushCell(SF2_BasePlayer(client));
			Call_PushCell(SF2NPC_BaseNPC(i));
			Call_Finish();

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
		SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(bossNewStatic));
		if (chaser.IsValid() && chaser.State == STATE_DEATH)
		{
			bossNewStatic = -1;
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

	if (bossNewStatic != bossLastStatic && !DidClientEscape(client))
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
			float staticIncreaseRate = (g_SlenderStaticRate[bossNewStatic][difficulty] - (g_SlenderStaticRate[bossNewStatic][difficulty] * GetDifficultyModifier(difficulty)) / 10);
			float staticDecreaseRate = (g_SlenderStaticRateDecay[bossNewStatic][difficulty] + (g_SlenderStaticRateDecay[bossNewStatic][difficulty] * GetDifficultyModifier(difficulty)) / 10);
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

	if (!IsValidClient(client))
	{
		return Plugin_Stop;
	}

	if (g_ClientSpecialRoundTimer[client] != timer)
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

	float nextBeepTime = distance / SquareFloat(800.0);

	if (nextBeepTime > 5.0)
	{
		nextBeepTime = 5.0;
	}
	if (nextBeepTime < 0.1)
	{
		nextBeepTime = 0.1;
	}

	EmitSoundToClient(client, PAGE_DETECTOR_BEEP, _, _, _, _, 0.7, 100 - RoundToNearest(nextBeepTime * 10.0));
	g_ClientSpecialRoundTimer[client] = CreateTimer(nextBeepTime, Timer_ClientPageDetector, userid, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

//	==========================================================
//	GHOST FUNCTIONS
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

void ClientDoJumpScare(int client, int bossIndex, float lifeTime)
{
	g_PlayerJumpScareBoss[client] = NPCGetUniqueID(bossIndex);
	g_PlayerJumpScareLifeTime[client] = GetGameTime() + lifeTime;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char buffer[PLATFORM_MAX_PATH];
	GetBossProfileJumpscareSound(profile, buffer, sizeof(buffer));

	if (buffer[0] != '\0')
	{
		EmitSoundToClient(client, buffer, _, MUSIC_CHAN);
	}
}

//	==========================================================
//	SCARE FUNCTIONS
//	==========================================================

void ClientPerformScare(int client, int bossIndex)
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
		soundInfo.EmitSound(true, client);

		g_PlayerSightSoundNextTime[client][bossIndex] = GetGameTime() + GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);

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

static void ClientPerformSightSound(int client, int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not perform sight sound on client %d: boss does not exist!", client);
		return;
	}

	int master = NPCGetFromUniqueID(g_SlenderCopyMaster[bossIndex]);
	if (master == -1)
	{
		master = bossIndex;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	SF2BossProfileSoundInfo soundInfo;
	GetBossProfileSightSounds(profile, soundInfo);

	if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
	{
		soundInfo.EmitSound(true, client);

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

	if (IsValidClient(client))
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

void ClientUpdateListeningFlags(int client, bool reset = false)
{
	if (!IsValidClient(client))
	{
		return;
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (i == client || !IsValidClient(i) || IsClientSourceTV(i))
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
	FormatEx(s, sizeof(s), "%d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d ; %d",
		g_PlayerQueuePoints[client],
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
		g_PlayerPreferences[client].PlayerPreference_LegacyHud,
		RoundToNearest(g_PlayerPreferences[client].PlayerPreference_MusicVolume * 100));

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

void ClientSetFOV(int client, int fov)
{
	if (!g_Enabled)
	{
		return;
	}

	SetEntData(client, g_PlayerFOVOffset, fov);
	SetEntData(client, g_PlayerDefaultFOVOffset, fov);
}

void TF2_GetClassName(TFClassType class, char[] buffer, int bufferLen, bool alt = false)
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
			strcopy(buffer, bufferLen, !alt ? "heavyweapons" : "heavy");
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

bool IsPointVisibleToAPlayer(const float pos[3], bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true, bool ignoreFog = false)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		if (IsPointVisibleToPlayer(i, pos, checkFOV, checkBlink, checkEliminated, ignoreFog))
		{
			return true;
		}
	}

	return false;
}

bool IsPointVisibleToPlayer(int client, const float pos[3], bool checkFOV = true, bool checkBlink = false, bool checkEliminated = true, bool ignoreFog = false)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client))
	{
		return false;
	}

	if (checkEliminated && g_PlayerEliminated[client])
	{
		return false;
	}

	if (checkBlink && IsClientBlinking(client) && !g_PlayerEliminated[client])
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

	if (!IsValidClient(client) || IsPlayerAlive(client))
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
