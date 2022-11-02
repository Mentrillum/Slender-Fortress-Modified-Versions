#if defined _sf2_npc_chaser_mind_included
#endinput
#endif

#define _sf2_npc_chaser_mind_included

#pragma semicolon 1

char cloakParticle[PLATFORM_MAX_PATH];

Action Timer_SlenderChaseBossThink(Handle timer, any entref) //God damn you are so big, you get a file dedicated to only you
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_Chaser chaserBoss = SF2NPC_Chaser(NPCGetFromEntIndex(slender));
	if (chaserBoss == SF2_INVALID_NPC_CHASER)
	{
		return Plugin_Stop;
	}

	if (chaserBoss.Flags & SFF_MARKEDASFAKE)
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	if (npc == INVALID_NPC)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderEntityThink[chaserBoss.Index])
	{
		return Plugin_Stop;
	}

	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();
	CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npc.GetEntity());

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_BOSS_IDLE, 1, "g_SlenderTimeUntilKill[%d]: %f", chaserBoss.Index, g_SlenderTimeUntilKill[chaserBoss.Index] - GetGameTime());
	#endif

	float myPos[3], myEyeAng[3];
	float buffer[3];

	char slenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	chaserBoss.GetProfile(slenderProfile, sizeof(slenderProfile));

	npcEntity.GetAbsOrigin(myPos);
	npcEntity.GetAbsAngles(myEyeAng);

	AddVectors(myEyeAng, g_SlenderEyeAngOffset[chaserBoss.Index], myEyeAng);

	int difficulty = GetLocalGlobalDifficulty(chaserBoss.Index);

	float originalSpeed, originalMaxSpeed, originalAcceleration;
	if (!g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUsesHealAnimation[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
	{
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !SF_IsSlaughterRunMap() && !g_Renevant90sEffect)
		{
			originalSpeed = chaserBoss.GetSpeed(difficulty) + chaserBoss.AddSpeed;
			originalMaxSpeed = chaserBoss.GetMaxSpeed(difficulty) + chaserBoss.AddMaxSpeed;
			originalAcceleration = chaserBoss.GetAcceleration(difficulty) + chaserBoss.AddAcceleration;
		}
		else if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || SF_IsSlaughterRunMap() || g_Renevant90sEffect)
		{
			originalSpeed = chaserBoss.GetSpeed(difficulty) + chaserBoss.AddSpeed;
			originalMaxSpeed = chaserBoss.GetMaxSpeed(difficulty) + chaserBoss.AddMaxSpeed;
			originalAcceleration = chaserBoss.GetAcceleration(difficulty) + chaserBoss.AddAcceleration;
			if (originalSpeed < (SF_IsSlaughterRunMap() ? 580.0 : 520.0))
			{
				originalSpeed = SF_IsSlaughterRunMap() ? 580.0 : 520.0;
			}
			if (originalMaxSpeed < (SF_IsSlaughterRunMap() ? 580.0 : 520.0))
			{
				originalMaxSpeed = SF_IsSlaughterRunMap() ? 580.0 : 520.0;
			}
			if (originalAcceleration < (SF_IsSlaughterRunMap() ? 10000.0 : 9001.0))
			{
				originalAcceleration = SF_IsSlaughterRunMap() ? 10000.0 : 9001.0;
			}
		}
	}
	else
	{
		originalSpeed = 0.0;
		originalMaxSpeed = 0.0;
		originalAcceleration = chaserBoss.GetAcceleration(difficulty) + chaserBoss.AddAcceleration;
	}
	float originalWalkSpeed = chaserBoss.GetWalkSpeed(difficulty);
	float originalMaxWalkSpeed = chaserBoss.GetMaxWalkSpeed(difficulty);

	if (g_InProxySurvivalRageMode)
	{
		originalSpeed *= 1.25;
		originalWalkSpeed *= 1.25;
		originalMaxSpeed *= 1.25;
		originalMaxWalkSpeed *= 1.25;
	}
	float speed, maxSpeed, acceleration;
	if (!g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUsesHealAnimation[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
	{
		speed = originalSpeed;
		maxSpeed = originalMaxSpeed;
	}
	else
	{
		speed = 0.0;
		maxSpeed = 0.0;
	}
	acceleration = originalAcceleration;
	if (g_RoundDifficultyModifier > 1.0)
	{
		speed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0);
		maxSpeed = originalMaxSpeed + ((originalMaxSpeed * g_RoundDifficultyModifier) / 20.0);
		acceleration = originalAcceleration + ((originalAcceleration * g_RoundDifficultyModifier) / 15.0);
	}
	else
	{
		speed = originalSpeed;
		maxSpeed = originalMaxSpeed;
		acceleration = originalAcceleration;
	}
	if (speed < originalSpeed)
	{
		speed = originalSpeed;
	}
	if (speed > maxSpeed)
	{
		speed = maxSpeed;
	}
	if (acceleration < originalAcceleration)
	{
		acceleration = originalAcceleration;
	}

	float walkSpeed = originalWalkSpeed;
	float maxWalkSpeed = originalMaxWalkSpeed;
	if (g_RoundDifficultyModifier > 1.0)
	{
		walkSpeed = (originalWalkSpeed + (originalWalkSpeed * g_RoundDifficultyModifier) / 15.0);
		maxWalkSpeed = (originalMaxWalkSpeed + (originalMaxWalkSpeed * g_RoundDifficultyModifier) / 20.0);
	}
	if (walkSpeed < originalWalkSpeed)
	{
		walkSpeed = originalWalkSpeed;
	}
	if (walkSpeed > maxWalkSpeed)
	{
		walkSpeed = maxWalkSpeed;
	}

	g_SlenderSpeedMultiplier[chaserBoss.Index] = 1.0;
	if (chaserBoss.CanBeSeen(_, true))
	{
		if (chaserBoss.HasAttribute(SF2Attribute_ReducedSpeedOnLook))
		{
			g_SlenderSpeedMultiplier[chaserBoss.Index] = chaserBoss.GetAttributeValue(SF2Attribute_ReducedSpeedOnLook);
			speed *= chaserBoss.GetAttributeValue(SF2Attribute_ReducedSpeedOnLook);
		}

		if (chaserBoss.HasAttribute(SF2Attribute_ReducedWalkSpeedOnLook))
		{
			walkSpeed *= chaserBoss.GetAttributeValue(SF2Attribute_ReducedWalkSpeedOnLook);
		}

		if (chaserBoss.HasAttribute(SF2Attribute_ReducedAccelerationOnLook))
		{
			walkSpeed *= chaserBoss.GetAttributeValue(SF2Attribute_ReducedAccelerationOnLook);
		}
	}
	if (g_NpcHasCloaked[chaserBoss.Index])
	{
		speed *= chaserBoss.GetCloakSpeedMultiplier(difficulty);
		maxSpeed *= chaserBoss.GetCloakSpeedMultiplier(difficulty);
	}
	if (g_NpcIsCrawling[chaserBoss.Index])
	{
		walkSpeed *= chaserBoss.GetCrawlSpeedMultiplier(difficulty);
		maxWalkSpeed *= chaserBoss.GetCrawlSpeedMultiplier(difficulty);
		speed *= chaserBoss.GetCrawlSpeedMultiplier(difficulty);
		maxSpeed *= chaserBoss.GetCrawlSpeedMultiplier(difficulty);
	}
	Action action = Plugin_Continue;
	float forwardSpeed = walkSpeed;
	Call_StartForward(g_OnBossGetWalkSpeedFwd);
	Call_PushCell(chaserBoss.Index);
	Call_PushFloatRef(forwardSpeed);
	Call_Finish(action);
	if (action == Plugin_Changed)
	{
		walkSpeed = forwardSpeed;
	}

	action = Plugin_Continue;
	forwardSpeed = speed;
	Call_StartForward(g_OnBossGetSpeedFwd);
	Call_PushCell(chaserBoss.Index);
	Call_PushFloatRef(forwardSpeed);
	Call_Finish(action);
	if (action == Plugin_Changed)
	{
		speed = forwardSpeed;
	}

	if (difficulty >= RoundToNearest(chaserBoss.GetAttributeValue(SF2Attribute_BlockWalkSpeedUnderDifficulty)))
	{
		g_SlenderCalculatedWalkSpeed[chaserBoss.Index] = walkSpeed;
	}
	else
	{
		g_SlenderCalculatedWalkSpeed[chaserBoss.Index] = 0.0;
	}

	if (!g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUsesHealAnimation[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
	{
		g_SlenderCalculatedSpeed[chaserBoss.Index] = speed;
	}
	else
	{
		g_SlenderCalculatedSpeed[chaserBoss.Index] = 0.0;
	}
	g_SlenderCalculatedAcceleration[chaserBoss.Index] = acceleration;
	g_SlenderCalculatedMaxSpeed[chaserBoss.Index] = maxSpeed;
	g_SlenderCalculatedMaxWalkSpeed[chaserBoss.Index] = maxWalkSpeed;

	int oldState = g_SlenderState[chaserBoss.Index];
	int oldTarget = EntRefToEntIndex(g_SlenderTarget[chaserBoss.Index]);

	int bestNewTarget = INVALID_ENT_REFERENCE;
	int soundTarget = INVALID_ENT_REFERENCE;
	float searchRange = NPCGetSearchRadius(chaserBoss.Index, difficulty);
	float searchSoundRange = NPCGetHearingRadius(chaserBoss.Index, difficulty);
	float bestNewTargetDist = SquareFloat(searchRange);
	int state = oldState;

	bool playerInFOV[MAXPLAYERS + 1];
	bool playerNear[MAXPLAYERS + 1];
	bool playerMadeNoise[MAXPLAYERS + 1];
	bool playerInTrap[MAXPLAYERS + 1];
	float playerDists[MAXPLAYERS + 1];
	bool playerVisible[MAXPLAYERS + 1];

	bool attackEliminated = view_as<bool>(chaserBoss.Flags & SFF_ATTACKWAITERS);
	bool stunEnabled = chaserBoss.StunEnabled;

	float traceMins[3] = { -16.0, ... };
	traceMins[2] = 0.0;
	float traceMaxs[3] = { 16.0, ... };
	traceMaxs[2] = 0.0;

	char class[32];

	bool building = false;
	if (oldTarget > MaxClients)
	{
		GetEdictClassname(oldTarget, class, sizeof(class));
		if (strcmp(class, "obj_sentrygun") == 0 && !GetEntProp(oldTarget, Prop_Send, "m_bCarried"))
		{
			building = true;
		}
		if (strcmp(class, "obj_dispenser") == 0 && !GetEntProp(oldTarget, Prop_Send, "m_bCarried"))
		{
			building = true;
		}
		if (strcmp(class, "obj_teleporter") == 0 && !GetEntProp(oldTarget, Prop_Send, "m_bCarried"))
		{
			building = true;
		}
	}

	if (g_SlenderSoundTarget[chaserBoss.Index] != INVALID_ENT_REFERENCE)
	{
		soundTarget = EntRefToEntIndex(g_SlenderSoundTarget[chaserBoss.Index]);
	}

	bool inFlashlight = false;
	bool doubleFlashlightDamage = false;
	float customFlashlightDamage = 1.0;

	// Gather data about the players around me and get the best new target, in case my old target is invalidated.
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "player")) != -1)
	{
		if (!IsTargetValidForSlender(ent, attackEliminated))
		{
			continue;
		}
		TFClassType classType = TF2_GetPlayerClass(ent);
		int classToInt = view_as<int>(classType);

		float traceStartPos[3], traceEndPos[3];
		chaserBoss.GetEyePosition(traceStartPos);
		GetClientEyePosition(ent, traceEndPos);

		float dist = 99999999999.9;

		bool isVisible;
		int traceHitEntity;
		if (!g_NpcOriginalVisibility[chaserBoss.Index])
		{
			Handle trace = TR_TraceRayFilterEx(traceStartPos,
					traceEndPos,
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
					RayType_EndPoint,
					TraceRayBossVisibility,
					npcEntity.index);
			isVisible = !TR_DidHit(trace);
			traceHitEntity = TR_GetEntityIndex(trace);

			delete trace;
		}
		else
		{
			TR_TraceHullFilter(traceStartPos,
			traceEndPos,
			traceMins,
			traceMaxs,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
			TraceRayBossVisibility,
			npcEntity.index);

			isVisible = !TR_DidHit();
			traceHitEntity = TR_GetEntityIndex();
		}

		if (!isVisible && traceHitEntity == ent)
		{
			isVisible = true;
		}

		if (isVisible)
		{
			isVisible = NPCShouldSeeEntity(chaserBoss.Index, ent);
		}

		if (g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
		{
			int fogEntity = GetEntDataEnt2(ent, g_PlayerFogCtrlOffset);
			if (IsValidEdict(fogEntity))
			{
				if (GetEntData(fogEntity, g_FogCtrlEnableOffset) &&
					GetVectorSquareMagnitude(traceStartPos, traceEndPos) >= SquareFloat(GetEntDataFloat(fogEntity, g_FogCtrlEndOffset)))
				{
					isVisible = false;
				}
			}
		}

		float priorityValue;

		playerVisible[ent] = isVisible;

		// Near radius check.
		if (!g_NpcIgnoreNonMarkedForChase[chaserBoss.Index] && playerVisible[ent] &&
			GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(NPCChaserGetWakeRadius(chaserBoss.Index)))
		{
			playerNear[ent] = true;
		}
		if (playerVisible[ent] && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(traceEndPos, traceStartPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
		{
			TF2_StunPlayer(ent, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		}

		// FOV check.
		SubtractVectors(traceEndPos, traceStartPos, buffer);
		GetVectorAngles(buffer, buffer);

		if (FloatAbs(AngleDiff(myEyeAng[1], buffer[1])) <= (NPCGetFOV(chaserBoss.Index) * 0.5))
		{
			playerInFOV[ent] = true;
		}

		if (!SF_IsRaidMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_SlenderChasesEndlessly[chaserBoss.Index])
		{
			priorityValue = g_PageMax > 0 ? ((float(g_PlayerPageCount[ent]) / float(g_PageMax))/4.0) : 0.0;
		}

		if (!IsClassConfigsValid())
		{
			if ((classType == TFClass_Medic || g_PlayerHasRegenerationItem[ent]) && !SF_IsBoxingMap())
			{
				priorityValue += 0.2;
			}

			if (classType == TFClass_Spy)
			{
				priorityValue += 0.1;
			}
		}
		else
		{
			if (!SF_IsBoxingMap() && g_PlayerHasRegenerationItem[ent])
			{
				priorityValue += 0.2;
			}
			priorityValue += g_ClassBossPriorityMultiplier[classToInt];
		}

		//Taunt alerts
		if (!g_NpcIgnoreNonMarkedForChase[chaserBoss.Index] && state != STATE_ALERT && state != STATE_ATTACK && state != STATE_STUN && state != STATE_CHASE &&
		GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(NPCGetTauntAlertRange(chaserBoss.Index, difficulty)) && TF2_IsPlayerInCondition(ent, TFCond_Taunting))
		{
			if (g_SlenderTauntAlertCount[chaserBoss.Index] < 5)
			{
				float targetPos[3];
				if (IsValidClient(ent))
				{
					GetClientAbsOrigin(ent, targetPos);
				}
				bestNewTarget = ent;
				if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
				}
				g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
				chaserBoss.SetGoalPos(targetPos);
				g_SlenderAutoChaseCount[chaserBoss.Index] += NPCChaserAutoChaseAddVoice(chaserBoss.Index, difficulty) * 2;
				state = STATE_ALERT;
				g_SlenderTauntAlertCount[chaserBoss.Index]++;
			}
			else
			{
				playerMadeNoise[ent] = true;
				g_NpcInAutoChase[chaserBoss.Index] = true;
				g_SlenderTauntAlertCount[chaserBoss.Index] = 0;
			}
		}

		//Trap check
		if (g_PlayerTrapped[ent] && GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(searchRange))
		{
			if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
			{
				playerInTrap[ent] = true;
				g_NpcInAutoChase[chaserBoss.Index] = true;
			}
		}

		if (NPCChaserCanAutoChaseSprinters(chaserBoss.Index) && IsClientReallySprinting(ent) && GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(searchSoundRange) && GetGameTime() >= g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
		{
			playerMadeNoise[ent] = true;
			g_NpcInAutoChase[chaserBoss.Index] = true;
		}

		if (NPCChaserIsAutoChaseEnabled(chaserBoss.Index))
		{
			if (IsValidClient(soundTarget) && g_SlenderAutoChaseCount[chaserBoss.Index] >= NPCChaserAutoChaseThreshold(chaserBoss.Index, difficulty) && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
			{
				playerMadeNoise[soundTarget] = true;
				g_NpcInAutoChase[chaserBoss.Index] = true;
			}
		}

		dist = GetVectorSquareMagnitude(traceStartPos, traceEndPos);
		playerDists[ent] = dist;

		if (!g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index] && playerVisible[ent] && (playerNear[ent] || playerInFOV[ent]))
		{
			float targetPos[3];
			GetClientAbsOrigin(ent, targetPos);
			if (!g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] && !g_NpcIgnoreNonMarkedForChase[chaserBoss.Index])
			{
				if (dist <= SquareFloat(searchRange))
				{
					// Subtract distance to increase priority.
					dist -= ((dist * priorityValue));

					if (dist < bestNewTargetDist)
					{
						bestNewTarget = ent;
						bestNewTargetDist = dist;
						g_SlenderInterruptConditions[chaserBoss.Index] |= COND_SAWENEMY;
						g_SlenderSeeTarget[chaserBoss.Index] = EntIndexToEntRef(ent);
					}
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][0] = targetPos[0];
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][1] = targetPos[1];
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][2] = targetPos[2];
					g_SlenderLastFoundPlayer[chaserBoss.Index][ent] = GetGameTime();
				}
			}
			else if ((g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] && g_NpcIgnoreNonMarkedForChase[chaserBoss.Index]) || NPCChaserCanChaseOnLook(chaserBoss.Index))
			{
				if (g_NpcChaseOnLookTarget[chaserBoss.Index].Length > 0 && g_NpcChaseOnLookTarget[chaserBoss.Index].FindValue(ent) != -1 &&
					dist <= SquareFloat(searchRange))
				{
					// Subtract distance to increase priority.
					dist -= ((dist * priorityValue));

					if (dist < bestNewTargetDist)
					{
						bestNewTarget = ent;
						bestNewTargetDist = dist;
						g_SlenderInterruptConditions[chaserBoss.Index] |= COND_SAWENEMY;
						g_SlenderSeeTarget[chaserBoss.Index] = EntIndexToEntRef(ent);
					}
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][0] = targetPos[0];
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][1] = targetPos[1];
					g_SlenderLastFoundPlayerPos[chaserBoss.Index][ent][2] = targetPos[2];
					g_SlenderLastFoundPlayer[chaserBoss.Index][ent] = GetGameTime();
				}
			}
		}

		if ((playerMadeNoise[ent] || playerInTrap[ent]) && state != STATE_CHASE && state != STATE_STUN && state != STATE_ATTACK)
		{
			if (g_NpcIgnoreNonMarkedForChase[chaserBoss.Index] && playerMadeNoise[ent])
			{
				bestNewTarget = ent;
				state = STATE_CHASE;
				SlenderAlertAllValidBosses(chaserBoss.Index, ent, bestNewTarget);
				GetClientAbsOrigin(ent, g_SlenderGoalPos[chaserBoss.Index]);
				g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
				g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
				g_SlenderGiveUp[chaserBoss.Index] = false;
				g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
				g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = true;
				g_SlenderAutoChaseCount[chaserBoss.Index] = 0;
			}
			else if (playerInTrap[ent] || (!g_NpcIgnoreNonMarkedForChase[chaserBoss.Index] && playerMadeNoise[ent]))
			{
				bestNewTarget = ent;
				state = STATE_CHASE;
				SlenderAlertAllValidBosses(chaserBoss.Index, ent, bestNewTarget);
				GetClientAbsOrigin(ent, g_SlenderGoalPos[chaserBoss.Index]);
				g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
				g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
				g_SlenderGiveUp[chaserBoss.Index] = false;
				g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
				g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = false;
			}
		}

		if (NPCChaserIsStunByFlashlightEnabled(chaserBoss.Index) && IsClientUsingFlashlight(ent) && playerInFOV[ent]) // Check to see if someone is facing at us with flashlight on. Only if I'm facing them too. BLINDNESS!
		{
			if (GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(SF2_FLASHLIGHT_LENGTH))
			{
				float eyeAng[3], requiredAng[3];
				GetClientEyeAngles(ent, eyeAng);
				SubtractVectors(traceEndPos, traceStartPos, requiredAng);
				GetVectorAngles(requiredAng, requiredAng);

				if (FloatAbs(AngleDiff(eyeAng[0], requiredAng[0])) <= 45.0 && FloatAbs(AngleDiff(requiredAng[1], eyeAng[1])) >= 135.0)
				{
					if (playerVisible[ent])
					{
						inFlashlight = true;
						if (!IsClassConfigsValid())
						{
							if (classType == TFClass_Engineer)
							{
								doubleFlashlightDamage = true;
							}
						}
						else
						{
							customFlashlightDamage = g_ClassFlashlightDamageMultiplier[classToInt];
						}
					}
				}
			}
		}
		if (NPCChaserCanChaseOnLook(chaserBoss.Index) && playerInFOV[ent] && playerVisible[ent])
		{
			float eyeAng[3], requiredAng[3];
			GetClientEyeAngles(ent, eyeAng);
			SubtractVectors(traceEndPos, traceStartPos, requiredAng);
			GetVectorAngles(requiredAng, requiredAng);
			if (FloatAbs(AngleDiff(eyeAng[0], requiredAng[0])) <= 45.0 && FloatAbs(AngleDiff(requiredAng[1], eyeAng[1])) >= 135.0)
			{
				if (g_NpcChaseOnLookTarget[chaserBoss.Index].FindValue(ent) == -1)
				{
					g_NpcChaseOnLookTarget[chaserBoss.Index].Push(ent);
					ArrayList soundList;
					SF2BossProfileSoundInfo soundInfo;
					char scarePath[PLATFORM_MAX_PATH];
					GetBossProfileScareSounds(slenderProfile, soundInfo);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), scarePath, sizeof(scarePath));
						if (buffer[0] != '\0')
						{
							EmitSoundToClient(ent, scarePath, _, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
						}
					}
					soundList = null;
					TF2_AddCondition(ent, TFCond_MarkedForDeathSilent, -1.0);
					if (NPCChaserCanUseChaseInitialAnimation(chaserBoss.Index) && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !SF_IsSlaughterRunMap())
					{
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] == null && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
						{
							g_NpcUsesChaseInitialAnimation[chaserBoss.Index] = true;
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
							NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, STATE_CHASE);
							g_SlenderChaseInitialTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
			}
		}
	}

	if (IsValidClient(EntRefToEntIndex(g_SlenderTarget[chaserBoss.Index])) && playerVisible[EntRefToEntIndex(g_SlenderTarget[chaserBoss.Index])])
	{
		g_SlenderTargetIsVisible[chaserBoss.Index] = true;
	}
	else
	{
		g_SlenderTargetIsVisible[chaserBoss.Index] = false;
	}

	if (g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index])
	{
		if (g_NpcChaseOnLookTarget[chaserBoss.Index] == null || g_NpcChaseOnLookTarget[chaserBoss.Index].Length <= 0)
		{
			g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = false;
			g_SlenderSoundTarget[chaserBoss.Index] = INVALID_ENT_REFERENCE;
			soundTarget = INVALID_ENT_REFERENCE;
		}
	}

	// Damage us if we're in a flashlight.
	if (inFlashlight)
	{
		if (stunEnabled)
		{
			if (NPCChaserIsStunByFlashlightEnabled(chaserBoss.Index) && !(SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && !(g_NightvisionEnabledConVar.BoolValue))
			{
				if (NPCChaserGetStunHealth(chaserBoss.Index) > 0)
				{
					if (!IsClassConfigsValid())
					{
						if (!doubleFlashlightDamage)
						{
							NPCChaserAddStunHealth(chaserBoss.Index, -NPCChaserGetStunFlashlightDamage(chaserBoss.Index));
						}
						else
						{
							NPCChaserAddStunHealth(chaserBoss.Index, -NPCChaserGetStunFlashlightDamage(chaserBoss.Index) * 1.5);
						}
					}
					else
					{
						NPCChaserAddStunHealth(chaserBoss.Index, -NPCChaserGetStunFlashlightDamage(chaserBoss.Index) * customFlashlightDamage);
					}
					if (NPCChaserGetStunHealth(chaserBoss.Index) <= 0.0 && state != STATE_STUN)
					{
						chaserBoss.TriggerStun(npcEntity.index, slenderProfile, myPos);
						Call_StartForward(g_OnBossStunnedFwd);
						Call_PushCell(chaserBoss.Index);
						Call_PushCell(-1);
						Call_Finish();
						state = STATE_STUN;
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
						}
					}
				}
			}
		}
	}

	// Process the target that we should have.
	int target = oldTarget;

	if (target && target != INVALID_ENT_REFERENCE)
	{
		if (!IsTargetValidForSlender(target, attackEliminated))
		{
			// Clear our target; he's not valid anymore.
			oldTarget = target;
			target = INVALID_ENT_REFERENCE;
			g_SlenderTarget[chaserBoss.Index] = INVALID_ENT_REFERENCE;
		}
	}
	else
	{
		// Clear our target; he's not valid anymore.
		oldTarget = target;
		target = INVALID_ENT_REFERENCE;
		g_SlenderTarget[chaserBoss.Index] = INVALID_ENT_REFERENCE;
	}

	if (building)
	{
		target = bestNewTarget;
	}

	//We should never give up, but sometimes it happens.
	if (g_SlenderGiveUp[chaserBoss.Index])
	{
		//Damit our target is unreachable for some unexplained reasons, haaaaaaaaaaaa!
		if (!SF_IsRaidMap() || !SF_BossesChaseEndlessly() || !SF_IsProxyMap() || !g_SlenderChasesEndlessly[chaserBoss.Index] || !SF_IsBoxingMap() || !SF_IsSlaughterRunMap())
		{
			state = STATE_IDLE;
			g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;
			g_SlenderGiveUp[chaserBoss.Index] = false;
		}

		if ((SF_BossesChaseEndlessly() || g_SlenderChasesEndlessly[chaserBoss.Index] || SF_IsSlaughterRunMap() || SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap()) && !(chaserBoss.Flags & SFF_NOTELEPORT))
		{
			//RemoveSlender(chaserBoss.Index);
		}
		//Do not, ok?
		g_SlenderGiveUp[chaserBoss.Index] = false;
		if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
		{
			TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
		}
	}

	int interruptConditions = g_SlenderInterruptConditions[chaserBoss.Index];

	if ((SF_IsRaidMap() || (SF_BossesChaseEndlessly() || g_SlenderChasesEndlessly[chaserBoss.Index]) || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap()) && !g_SlenderGiveUp[chaserBoss.Index] && !building && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
	{
		if (!IsValidClient(target) || (IsValidClient(target) && g_PlayerEliminated[target]))
		{
			if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && NPCAreAvailablePlayersAlive())
			{
				ArrayList arrayRaidTargets = new ArrayList();

				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) ||
						!IsPlayerAlive(i) ||
						g_PlayerEliminated[i] ||
						IsClientInGhostMode(i) ||
						DidClientEscape(i))
					{
						continue;
					}
					arrayRaidTargets.Push(i);
				}
				if(arrayRaidTargets.Length > 0)
				{
					int raidTarget = arrayRaidTargets.Get(GetRandomInt(0, arrayRaidTargets.Length - 1));
					if(IsValidClient(raidTarget) && !g_PlayerEliminated[raidTarget])
					{
						bestNewTarget = raidTarget;
						g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
						g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
						state = STATE_CHASE;
						GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[chaserBoss.Index]);
						target = bestNewTarget;
					}
				}
				delete arrayRaidTargets;
			}
		}
	}

	if (NPCChaserCanChaseOnLook(chaserBoss.Index))
	{
		if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && NPCAreAvailablePlayersAlive() && g_NpcChaseOnLookTarget[chaserBoss.Index].Length != 0)
		{
			for (int i = 0; i < g_NpcChaseOnLookTarget[chaserBoss.Index].Length; i++)
			{
				int lookClient = g_NpcChaseOnLookTarget[chaserBoss.Index].Get(i);
				if (IsValidClient(lookClient) && !g_PlayerEliminated[lookClient] && IsPlayerAlive(lookClient) && IsClientInGame(lookClient) &&
					!IsClientInGhostMode(lookClient) && !DidClientEscape(lookClient))
				{
					bestNewTarget = lookClient;
					g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(lookClient);
					g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
					state = STATE_CHASE;
					GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[chaserBoss.Index]);
					target = bestNewTarget;
					SlenderAlertAllValidBosses(chaserBoss.Index, target, bestNewTarget);
				}
				else
				{
					i--;
				}
			}
		}
	}

	// Process which state we should be in.
	switch (state)
	{
		case STATE_IDLE, STATE_WANDER:
		{
			for (int i = 0; i < MAX_NPCTELEPORTER; i++)
			{
				if (chaserBoss.GetTeleporter(i) != INVALID_ENT_REFERENCE)
				{
					chaserBoss.SetTeleporter(i, INVALID_ENT_REFERENCE);
				}
			}
			if (state == STATE_WANDER)
			{
				if (!g_BossPathFollower[chaserBoss.Index].IsValid() && g_SlenderCalculatedWalkSpeed[chaserBoss.Index] > 0.0)
				{
					state = STATE_IDLE;
				}
			}
			else
			{
				if ((chaserBoss.Flags & SFF_WANDERMOVE) && GetGameTime() >= g_SlenderNextWanderPos[chaserBoss.Index][difficulty] && GetRandomFloat(0.0, 1.0) <= 0.25 &&
				difficulty >= RoundToNearest(chaserBoss.GetAttributeValue(SF2Attribute_BlockWalkSpeedUnderDifficulty)))
				{
					state = STATE_WANDER;
				}
			}
			if (SF_SpecialRound(SPECIALROUND_BEACON) || g_RenevantBeaconEffect)
			{
				if (!g_SlenderInBacon[chaserBoss.Index])
				{
					int clientToPos = NPCChaserGetClosestPlayer(npcEntity.index);
					float clientPosition[3];
					if (IsValidClient(clientToPos))
					{
						GetClientAbsOrigin(clientToPos, clientPosition);
					}
					bestNewTarget = clientToPos;
					state = STATE_ALERT;
					if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
					{
						TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
					}
					g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
					chaserBoss.SetGoalPos(clientPosition);
					g_SlenderInBacon[chaserBoss.Index] = true;
				}
			}
			if (interruptConditions & COND_SAWENEMY)
			{
				if (NPCChaserIsAutoChaseEnabled(chaserBoss.Index))
				{
					g_SlenderAutoChaseCount[chaserBoss.Index] += NPCChaserAutoChaseAddGeneral(chaserBoss.Index, difficulty);
				}
				// I saw someone over here. Automatically put me into alert mode.
				state = STATE_ALERT;
				if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
				}
				g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
				int clientToPos = EntRefToEntIndex(g_SlenderSeeTarget[chaserBoss.Index]);
				float clientPosition[3];
				if (IsValidClient(clientToPos))
				{
					GetClientAbsOrigin(clientToPos, clientPosition);
					bestNewTarget = clientToPos;
					chaserBoss.SetGoalPos(clientPosition);
				}
			}
			else if (interruptConditions & COND_HEARDSUSPICIOUSSOUND)
			{
				// Sound counts will be reset after the boss hears a sound after a certain amount of time.
				// The purpose of sound counts is to induce boss focusing on sounds suspicious entities are making.

				int count = 0;
				if (interruptConditions & COND_HEARDFOOTSTEP)
				{
					count += GetChaserProfileFootstepAddThreshold(slenderProfile, difficulty);
				}
				if (interruptConditions & COND_HEARDFOOTSTEPLOUD)
				{
					count += GetChaserProfileLoudFootstepAddThreshold(slenderProfile, difficulty);
				}
				if (interruptConditions & COND_HEARDFOOTSTEPQUIET)
				{
					count += GetChaserProfileQuietFootstepAddThreshold(slenderProfile, difficulty);
				}
				if (interruptConditions & COND_HEARDWEAPON)
				{
					count += GetChaserProfileWeaponAddThreshold(slenderProfile, difficulty);
				}
				if (interruptConditions & COND_HEARDFLASHLIGHT)
				{
					count += GetChaserProfileFlashlightAddThreshold(slenderProfile, difficulty);
				}
				if (interruptConditions & COND_HEARDVOICE)
				{
					count += GetChaserProfileVoiceAddThreshold(slenderProfile, difficulty);
				}

				bool discardMasterPos = view_as<bool>(GetGameTime() >= g_SlenderTargetSoundDiscardMasterPosTime[chaserBoss.Index]);

				if (discardMasterPos)
				{
					g_SlenderTargetSoundCount[chaserBoss.Index] = 0;
				}

				if ((GetVectorSquareMagnitude(g_SlenderTargetSoundTempPos[chaserBoss.Index], g_SlenderTargetSoundMasterPos[chaserBoss.Index]) <= SquareFloat(GetChaserProfileSoundPosDistanceTolerance(slenderProfile, difficulty)) ||
					discardMasterPos) && count > 0)
				{
					g_SlenderTargetSoundDiscardMasterPosTime[chaserBoss.Index] = GetGameTime() + GetChaserProfileSoundPosDiscardTime(slenderProfile, difficulty);
					g_SlenderTargetSoundMasterPos[chaserBoss.Index][0] = g_SlenderTargetSoundTempPos[chaserBoss.Index][0];
					g_SlenderTargetSoundMasterPos[chaserBoss.Index][1] = g_SlenderTargetSoundTempPos[chaserBoss.Index][1];
					g_SlenderTargetSoundMasterPos[chaserBoss.Index][2] = g_SlenderTargetSoundTempPos[chaserBoss.Index][2];
					g_SlenderTargetSoundCount[chaserBoss.Index] += count;
				}
				if (g_SlenderTargetSoundCount[chaserBoss.Index] >= NPCChaserGetSoundCountToAlert(chaserBoss.Index, difficulty))
				{
					// Someone's making some noise over there! Time to investigate.
					g_SlenderInvestigatingSound[chaserBoss.Index] = true; // This is just so that our sound position would be the goal position.
					state = STATE_ALERT;
					if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
					{
						TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
					}
					g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
				}
			}
			if (NPCChaserGetTrapState(chaserBoss.Index))
			{
				if (g_SlenderNextTrapPlacement[chaserBoss.Index] <= GetGameTime() && g_TrapEntityCount < 32)
				{
					Trap_SpawnTrap(myPos, myEyeAng, chaserBoss.Index);
					g_SlenderNextTrapPlacement[chaserBoss.Index] = GetGameTime() + NPCChaserGetTrapSpawnTime(chaserBoss.Index, difficulty);
				}
				else if (g_SlenderNextTrapPlacement[chaserBoss.Index] <= GetGameTime() && g_TrapEntityCount >= 32)
				{
					g_SlenderNextTrapPlacement[chaserBoss.Index] = GetGameTime() + NPCChaserGetTrapSpawnTime(chaserBoss.Index, difficulty);
				}
			}
		}
		case STATE_ALERT:
		{
			if (state == STATE_ALERT)
			{
				if (!g_BossPathFollower[chaserBoss.Index].IsValid() && g_SlenderCalculatedWalkSpeed[chaserBoss.Index] > 0.0)
				{
					if (!(interruptConditions & COND_HEARDSUSPICIOUSSOUND))
					{
						state = STATE_IDLE;
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
						}
					}
					else if ((interruptConditions & COND_HEARDSUSPICIOUSSOUND) && GetVectorSquareMagnitude(g_SlenderGoalPos[chaserBoss.Index], myPos) <= SquareFloat(20.0))
					{
						state = STATE_IDLE;
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
						}
					}
				}
			}
			if (GetGameTime() >= g_SlenderTimeUntilIdle[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index] && !g_NpcIsRunningToHeal[chaserBoss.Index])
			{
				state = STATE_IDLE;
				if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
				}
			}
			else if (IsValidClient(bestNewTarget))
			{
				if (GetGameTime() >= g_SlenderTimeUntilChase[chaserBoss.Index] || playerNear[bestNewTarget])
				{
					float traceStartPos[3], traceEndPos[3];
					NPCGetEyePosition(chaserBoss.Index, traceStartPos);

					if (IsValidClient(bestNewTarget))
					{
						GetClientEyePosition(bestNewTarget, traceEndPos);
					}
					else
					{
						float targetMins[3], targetMaxs[3];
						GetEntPropVector(bestNewTarget, Prop_Send, "m_vecMins", targetMins);
						GetEntPropVector(bestNewTarget, Prop_Send, "m_vecMaxs", targetMaxs);
						GetEntPropVector(bestNewTarget, Prop_Data, "m_vecAbsOrigin", traceEndPos);
						for (int i = 0; i < 3; i++)
						{
							traceEndPos[i] += ((targetMins[i] + targetMaxs[i]) / 2.0);
						}
					}

					Handle trace = TR_TraceRayFilterEx(traceStartPos,
						traceEndPos,
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
						RayType_EndPoint,
						TraceRayBossVisibility,
						npcEntity.index);

					bool isVisible = !TR_DidHit(trace);
					int traceHitEntity = TR_GetEntityIndex(trace);
					delete trace;

					if (!isVisible && traceHitEntity == bestNewTarget)
					{
						isVisible = true;
					}

					if (building || ((playerNear[bestNewTarget] || playerInFOV[bestNewTarget]) && playerVisible[bestNewTarget]))
					{
						// AHAHAHAH! I GOT YOU NOW!
						target = bestNewTarget;
						g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
						state = STATE_CHASE;
						GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[chaserBoss.Index]);
						SlenderAlertAllValidBosses(chaserBoss.Index, target, bestNewTarget);
					}
				}
				if (playerInTrap[bestNewTarget] || playerMadeNoise[bestNewTarget])
				{
					// AHAHAHAH! I GOT YOU NOW!
					target = bestNewTarget;
					g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
					state = STATE_CHASE;
					GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[chaserBoss.Index]);
					SlenderAlertAllValidBosses(chaserBoss.Index, target, bestNewTarget);
				}
			}
			if ((building))
			{
				state = STATE_CHASE;
			}
			else
			{
				if (interruptConditions & COND_SAWENEMY)
				{
					if (IsValidClient(bestNewTarget))
					{
						chaserBoss.SetGoalPos(g_SlenderLastFoundPlayerPos[chaserBoss.Index][bestNewTarget]);
					}
				}
				else if (interruptConditions & COND_HEARDSUSPICIOUSSOUND)
				{
					int count = 0;
					if (interruptConditions & COND_HEARDFOOTSTEP)
					{
						count += GetChaserProfileFootstepAddThreshold(slenderProfile, difficulty);
					}
					if (interruptConditions & COND_HEARDFOOTSTEPLOUD)
					{
						count += GetChaserProfileLoudFootstepAddThreshold(slenderProfile, difficulty);
					}
					if (interruptConditions & COND_HEARDFOOTSTEPQUIET)
					{
						count += GetChaserProfileQuietFootstepAddThreshold(slenderProfile, difficulty);
					}
					if (interruptConditions & COND_HEARDWEAPON)
					{
						count += GetChaserProfileWeaponAddThreshold(slenderProfile, difficulty);
					}
					if (interruptConditions & COND_HEARDFLASHLIGHT)
					{
						count += GetChaserProfileFlashlightAddThreshold(slenderProfile, difficulty);
					}
					if (interruptConditions & COND_HEARDVOICE)
					{
						count += GetChaserProfileVoiceAddThreshold(slenderProfile, difficulty);
					}
					bool discardMasterPos = view_as<bool>(GetGameTime() >= g_SlenderTargetSoundDiscardMasterPosTime[chaserBoss.Index]);

					if ((GetVectorSquareMagnitude(g_SlenderTargetSoundTempPos[chaserBoss.Index], g_SlenderTargetSoundMasterPos[chaserBoss.Index]) <= SquareFloat(GetChaserProfileSoundPosDistanceTolerance(slenderProfile, difficulty)) ||
						discardMasterPos) && count > 0)
					{
						g_SlenderTargetSoundDiscardMasterPosTime[chaserBoss.Index] = GetGameTime() + GetChaserProfileSoundPosDiscardTime(slenderProfile, difficulty);
						g_SlenderTargetSoundMasterPos[chaserBoss.Index][0] = g_SlenderTargetSoundTempPos[chaserBoss.Index][0];
						g_SlenderTargetSoundMasterPos[chaserBoss.Index][1] = g_SlenderTargetSoundTempPos[chaserBoss.Index][1];
						g_SlenderTargetSoundMasterPos[chaserBoss.Index][2] = g_SlenderTargetSoundTempPos[chaserBoss.Index][2];

						// We have to manually set the goal position here because the goal position will not be changed due to no change in state.
						chaserBoss.SetGoalPos(g_SlenderTargetSoundMasterPos[chaserBoss.Index]);

						g_SlenderInvestigatingSound[chaserBoss.Index] = true;
					}
				}

				for (int attackIndex = 0; attackIndex < NPCChaserGetAttackCount(chaserBoss.Index); attackIndex++)
				{
					if (NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_LaserBeam)
					{
						continue;
					}

					bool blockingProp = false;

					if (chaserBoss.Flags & SFF_ATTACKPROPS)
					{
						blockingProp = NPC_CanAttackProps(chaserBoss.Index, NPCChaserGetAttackRange(chaserBoss.Index, attackIndex), NPCChaserGetAttackSpread(chaserBoss.Index, attackIndex));
					}

					if (blockingProp)
					{
						state = STATE_ATTACK;
						NPCSetCurrentAttackIndex(chaserBoss.Index, attackIndex);
						break;
					}
				}
			}
			if (NPCChaserGetTrapState(chaserBoss.Index))
			{
				if (g_SlenderNextTrapPlacement[chaserBoss.Index] <= GetGameTime() && g_TrapEntityCount < 32)
				{
					Trap_SpawnTrap(myPos, myEyeAng, chaserBoss.Index);
					g_SlenderNextTrapPlacement[chaserBoss.Index] = GetGameTime() + NPCChaserGetTrapSpawnTime(chaserBoss.Index, difficulty);
				}
				else if (g_SlenderNextTrapPlacement[chaserBoss.Index] <= GetGameTime() && g_TrapEntityCount >= 32)
				{
					g_SlenderNextTrapPlacement[chaserBoss.Index] = GetGameTime() + NPCChaserGetTrapSpawnTime(chaserBoss.Index, difficulty);
				}
			}
		}
		case STATE_CHASE, STATE_ATTACK, STATE_STUN:
		{
			if (state == STATE_CHASE)
			{
				if (IsValidEntity(target))
				{
					float traceStartPos[3], traceEndPos[3];
					NPCGetEyePosition(chaserBoss.Index, traceStartPos);
					if (NPCChaserIsCloakEnabled(chaserBoss.Index))
					{
						float cloakDist = GetVectorSquareMagnitude(g_SlenderGoalPos[chaserBoss.Index], myPos);
						float cloakRange = NPCChaserGetCloakRange(chaserBoss.Index, difficulty);
						float decloakRange = NPCChaserGetDecloakRange(chaserBoss.Index, difficulty);
						if (cloakDist <= SquareFloat(cloakRange) && !g_NpcHasCloaked[chaserBoss.Index] && g_SlenderNextCloakTime[chaserBoss.Index] <= GetGameTime() && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index])
						{
							//Time for a more cloaking aproach!
							SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(GetChaserProfileCloakRenderMode(slenderProfile)));

							int cloakColor[4];
							GetChaserProfileCloakRenderColor(slenderProfile, cloakColor);

							SetEntityRenderColor(npcEntity.index, cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3]);
							g_NpcNextDecloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakDuration(chaserBoss.Index, difficulty);
							SlenderToggleParticleEffects(npcEntity.index);
							GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
							SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOnSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_NpcHasCloaked[chaserBoss.Index] = true;
							Call_StartForward(g_OnBossCloakedFwd);
							Call_PushCell(chaserBoss.Index);
							Call_Finish();
						}
						if ((cloakDist <= SquareFloat(decloakRange) || GetGameTime() >= g_NpcNextDecloakTime[chaserBoss.Index]) && g_NpcHasCloaked[chaserBoss.Index])
						{
							//Come back now!
							SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
							SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], g_SlenderRenderColor[chaserBoss.Index][3]);

							SlenderToggleParticleEffects(npcEntity.index, true);
							GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
							SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOffSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_SlenderNextCloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakCooldown(chaserBoss.Index, difficulty);
							Call_StartForward(g_OnBossDecloakedFwd);
							Call_PushCell(chaserBoss.Index);
							Call_Finish();
							g_NpcHasCloaked[chaserBoss.Index] = false;
						}
					}

					if (NPCChaserIsProjectileEnabled(chaserBoss.Index))
					{
						if (chaserBoss.Flags & SFF_FAKE)
						{
							SlenderMarkAsFake(chaserBoss.Index);
						}
						if (g_NpcProjectileCooldown[chaserBoss.Index] <= GetGameTime() && !NPCChaserUseProjectileAmmo(chaserBoss.Index) && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && (building || (playerInFOV[target] && CanNPCSeePlayerNonTransparent(chaserBoss.Index, target))) && !g_NpcHasCloaked[chaserBoss.Index])
						{
							NPCChaserProjectileShoot(chaserBoss.Index, npcEntity.index, target, slenderProfile, myPos);
						}
						else if (NPCChaserUseProjectileAmmo(chaserBoss.Index))
						{
							if (g_NpcProjectileCooldown[chaserBoss.Index] <= GetGameTime() && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && (building || (playerInFOV[target] && CanNPCSeePlayerNonTransparent(chaserBoss.Index, target))) && !g_NpcHasCloaked[chaserBoss.Index] && (g_NpcProjectileAmmo[chaserBoss.Index] != 0))
							{
								NPCChaserProjectileShoot(chaserBoss.Index, npcEntity.index, target, slenderProfile, myPos);
								g_NpcProjectileAmmo[chaserBoss.Index] = g_NpcProjectileAmmo[chaserBoss.Index] - 1;
							}
							if (g_NpcProjectileAmmo[chaserBoss.Index] == 0 && !g_NpcReloadingProjectiles[chaserBoss.Index])
							{
								g_NpcProjectileTimeToReload[chaserBoss.Index] = GetGameTime() + NPCChaserGetProjectileReloadTime(chaserBoss.Index, difficulty);
								g_NpcReloadingProjectiles[chaserBoss.Index] = true;
							}
							if (g_NpcProjectileTimeToReload[chaserBoss.Index] <= GetGameTime() && g_NpcProjectileAmmo[chaserBoss.Index] == 0)
							{
								g_NpcProjectileAmmo[chaserBoss.Index] = NPCChaserGetLoadedProjectiles(chaserBoss.Index, difficulty);
								g_NpcReloadingProjectiles[chaserBoss.Index] = false;
							}
						}
					}

					if (IsValidClient(target))
					{
						GetClientEyePosition(target, traceEndPos);
					}
					else
					{
						float targetMins[3], targetMaxs[3];
						GetEntPropVector(target, Prop_Send, "m_vecMins", targetMins);
						GetEntPropVector(target, Prop_Send, "m_vecMaxs", targetMaxs);
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", traceEndPos);
						for (int i = 0; i < 3; i++)
						{
							traceEndPos[i] += ((targetMins[i] + targetMaxs[i]) / 2.0);
						}
					}

					bool isDeathPosVisible = false;

					if (g_SlenderChaseDeathPositionBool[chaserBoss.Index])
					{
						Handle trace = TR_TraceRayFilterEx(traceStartPos,
							g_SlenderChaseDeathPosition[chaserBoss.Index],
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
							RayType_EndPoint,
							TraceRayBossVisibility,
							npcEntity.index);
						isDeathPosVisible = !TR_DidHit(trace);
						delete trace;
					}

					if (!building && !playerVisible[target] && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
					{
						if (GetGameTime() >= g_SlenderTimeUntilAlert[chaserBoss.Index] || (!attackEliminated && g_PlayerEliminated[target]))
						{
							state = STATE_ALERT;
							g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
							if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
							{
								g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
								g_NpcChasingScareVictin[chaserBoss.Index] = false;
							}
							if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
							{
								g_NpcCopyAlerted[chaserBoss.Index] = false;
							}
							g_SlenderAutoChaseCount[chaserBoss.Index] = 0;
							g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = false;
							g_NpcInAutoChase[chaserBoss.Index] = false;
							g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;
							if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
							}
						}
						else if (isDeathPosVisible || (!attackEliminated && g_PlayerEliminated[target]))
						{
							state = STATE_IDLE;
							if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
							{
								g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
								g_NpcChasingScareVictin[chaserBoss.Index] = false;
							}
							if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
							{
								g_NpcCopyAlerted[chaserBoss.Index] = false;
							}
							g_SlenderAutoChaseCount[chaserBoss.Index] = 0;
							g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = false;
							g_NpcInAutoChase[chaserBoss.Index] = false;
							g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;
							if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
							}
						}
						GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
					}
					else if ((building || CanNPCSeePlayerNonTransparent(chaserBoss.Index, target)) && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
					{
						g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false; // We're not chasing a dead player after all! Reset.

						float attackDirection[3], attackEyePos[3], clientPosAttack[3], attackDist;
						NPCGetEyePosition(chaserBoss.Index, attackEyePos);
						if (IsValidClient(target))
						{
							GetClientEyePosition(target, clientPosAttack);
						}
						else
						{
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", clientPosAttack);
							clientPosAttack[2] += 20.0;
						}
						attackDist = GetVectorSquareMagnitude(myPos, g_SlenderGoalPos[chaserBoss.Index]);
						SubtractVectors(clientPosAttack, attackEyePos, attackDirection);
						GetVectorAngles(attackDirection, attackDirection);
						attackDirection[2] = 180.0;

						float attackBeginRangeEx, attackBeginFOVEx;

						float fov = FloatAbs(AngleDiff(attackDirection[1], myEyeAng[1]));
						float clientHealth = float(GetEntProp(target, Prop_Send, "m_iHealth"));
						ArrayList arrayAttacks = new ArrayList();
						for (int attackIndex2 = 0; attackIndex2 < NPCChaserGetAttackCount(chaserBoss.Index); attackIndex2++)
						{
							if ((difficulty >= NPCChaserGetAttackUseOnDifficulty(chaserBoss.Index, attackIndex2) && difficulty < NPCChaserGetAttackBlockOnDifficulty(chaserBoss.Index, attackIndex2)) &&
							NPCChaserGetNextAttackTime(chaserBoss.Index, attackIndex2) <= GetGameTime())
							{
								arrayAttacks.Push(attackIndex2);
							}
							if (IsValidClient(target) && (NPCChaserGetAttackUseOnHealth(chaserBoss.Index, attackIndex2) != -1.0 && clientHealth < NPCChaserGetAttackUseOnHealth(chaserBoss.Index, attackIndex2)) ||
							(NPCChaserGetAttackBlockOnHealth(chaserBoss.Index, attackIndex2) != -1.0 && clientHealth >= NPCChaserGetAttackBlockOnHealth(chaserBoss.Index, attackIndex2)))
							{
								int eraseAttack = arrayAttacks.FindValue(attackIndex2);
								if (eraseAttack != -1)
								{
									arrayAttacks.Erase(eraseAttack);
								}
							}
							if (g_NpcUsesChaseInitialAnimation[chaserBoss.Index] &&
								NPCChaserGetAttackInterruptChaseInitialState(chaserBoss.Index, attackIndex2))
							{
								int eraseAttack = arrayAttacks.FindValue(attackIndex2);
								if (eraseAttack != -1)
								{
									arrayAttacks.Erase(eraseAttack);
								}
							}
						}
						Call_StartForward(g_OnBossPreAttackFwd);
						Call_PushCell(chaserBoss.Index);
						Call_PushCell(arrayAttacks);
						Call_Finish();
						if (arrayAttacks != null && arrayAttacks.Length > 0)
						{
							int randomAttackIndex = arrayAttacks.Get(GetRandomInt(0, arrayAttacks.Length - 1));
							attackBeginRangeEx = NPCChaserGetAttackBeginRange(chaserBoss.Index, randomAttackIndex);
							attackBeginFOVEx = NPCChaserGetAttackBeginFOV(chaserBoss.Index, randomAttackIndex);
							if (attackDist <= SquareFloat(attackBeginRangeEx) && fov <= (attackBeginFOVEx / 2.0) &&
							!g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] &&
							!g_NpcUseStartFleeAnimation[chaserBoss.Index] && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
							{
								state = STATE_ATTACK;
								NPCSetCurrentAttackIndex(chaserBoss.Index, randomAttackIndex);
							}
						}
						if (arrayAttacks != null)
						{
							delete arrayAttacks;
						}
					}
					if (state == STATE_CHASE)
					{
						for (int attackIndex = 0; attackIndex < NPCChaserGetAttackCount(chaserBoss.Index); attackIndex++)
						{
							if (NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_LaserBeam)
							{
								continue;
							}

							bool blockingProp = false;

							if (chaserBoss.Flags & SFF_ATTACKPROPS)
							{
								blockingProp = NPC_CanAttackProps(chaserBoss.Index, NPCChaserGetAttackRange(chaserBoss.Index, attackIndex), NPCChaserGetAttackSpread(chaserBoss.Index, attackIndex));
							}

							if (blockingProp)
							{
								state = STATE_ATTACK;
								NPCSetCurrentAttackIndex(chaserBoss.Index, attackIndex);
								break;
							}
						}
					}
				}
				if ((!IsValidEntity(target) && !IsValidEntity(bestNewTarget)) || (!building && !IsTargetValidForSlender(target, attackEliminated)) && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
				{
					// Even if the target isn't valid anymore, see if I still have some ways to go on my current path,
					// because I shouldn't actually know that the target has died until I see it.
					if (!g_BossPathFollower[chaserBoss.Index].IsValid())
					{
						state = STATE_IDLE;
						g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
						}
					}
				}
			}
			else if (state == STATE_ATTACK)
			{
				if (g_IsSlenderAttacking[chaserBoss.Index])
				{
					int attackIndex = NPCGetCurrentAttackIndex(chaserBoss.Index);
					bool cancelLos = GetChaserProfileAttackCancelLOSState(slenderProfile, attackIndex);
					float cancelDistance = GetChaserProfileAttackCancelDistance(slenderProfile, attackIndex);
					if (cancelLos)
					{
						if (!IsValidClient(target) || !playerVisible[target])
						{
							if (g_LastStuckTime[chaserBoss.Index] != 0.0)
							{
								g_LastStuckTime[chaserBoss.Index] = GetGameTime();
							}
							if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
							}
							loco.ClearStuckStatus();
							g_SlenderTimeUntilAttackEnd[chaserBoss.Index] = -1.0;
							NPCClearAttackStats(chaserBoss.Index, true);
							if (IsValidClient(target))
							{
								g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false;

								g_SlenderGiveUp[chaserBoss.Index] = false;
								state = STATE_CHASE;
								GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
							}
							else
							{
								state = STATE_ALERT;
								g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
								g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;

								if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
								{
									g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
									g_NpcChasingScareVictin[chaserBoss.Index] = false;
								}
								if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
								{
									g_NpcCopyAlerted[chaserBoss.Index] = false;
								}
							}
						}
					}
					if (cancelDistance > 0.0)
					{
						float distance = GetVectorSquareMagnitude(myPos, g_SlenderGoalPos[chaserBoss.Index]);
						if (distance > SquareFloat(cancelDistance))
						{
							if (g_LastStuckTime[chaserBoss.Index] != 0.0)
							{
								g_LastStuckTime[chaserBoss.Index] = GetGameTime();
							}
							if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
							}
							loco.ClearStuckStatus();
							NPCClearAttackStats(chaserBoss.Index, true);
							if (IsValidClient(target))
							{
								g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false;

								g_SlenderGiveUp[chaserBoss.Index] = false;
								state = STATE_CHASE;
								GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
							}
							else
							{
								state = STATE_ALERT;
								g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
								g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;

								if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
								{
									g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
									g_NpcChasingScareVictin[chaserBoss.Index] = false;
								}
								if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
								{
									g_NpcCopyAlerted[chaserBoss.Index] = false;
								}
							}
						}
					}
				}
				if (!g_IsSlenderAttacking[chaserBoss.Index] || (g_SlenderTimeUntilAttackEnd[chaserBoss.Index] != -1.0 && g_SlenderTimeUntilAttackEnd[chaserBoss.Index] <= GetGameTime()))
				{
					if (g_LastStuckTime[chaserBoss.Index] != 0.0)
					{
						g_LastStuckTime[chaserBoss.Index] = GetGameTime();
					}
					loco.ClearStuckStatus();
					g_SlenderTimeUntilAttackEnd[chaserBoss.Index] = -1.0;
					NPCClearAttackStats(chaserBoss.Index);

					if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
					{
						TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
					}
					if (IsValidClient(target))
					{
						g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false;

						// Chase him again!
						g_SlenderGiveUp[chaserBoss.Index] = false;
						state = STATE_CHASE;
						GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
					}
					else
					{
						// Target isn't valid anymore. We killed him, Mac!
						state = STATE_ALERT;
						g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
						g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;

						if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
						{
							g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
							g_NpcChasingScareVictin[chaserBoss.Index] = false;
						}
						if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
						{
							g_NpcCopyAlerted[chaserBoss.Index] = false;
						}
					}
				}
			}
			else if (state == STATE_STUN)
			{
				if (GetGameTime() >= g_SlenderTimeUntilRecover[chaserBoss.Index])
				{
					g_LastStuckTime[chaserBoss.Index] = 0.0;
					if (NPCChaserCanDisappearOnStun(chaserBoss.Index))
					{
						RemoveSlender(chaserBoss.Index);
					}
					loco.ClearStuckStatus();
					float value = chaserBoss.GetAttributeValue(SF2Attribute_AddStunHealhOnStun);
					if (value > 0.0)
					{
						NPCChaserSetStunHealth(chaserBoss.Index, NPCChaserGetStunInitialHealth(chaserBoss.Index));
						NPCChaserSetAddStunHealth(chaserBoss.Index, value);
						NPCChaserAddStunHealth(chaserBoss.Index, NPCChaserGetAddStunHealth(chaserBoss.Index));
					}
					else
					{
						NPCChaserSetStunHealth(chaserBoss.Index, NPCChaserGetStunInitialHealth(chaserBoss.Index));
					}
					value = chaserBoss.GetAttributeValue(SF2Attribute_AddSpeedOnStun);
					if (value > 0.0)
					{
						NPCSetAddSpeed(chaserBoss.Index, value);
					}
					value = chaserBoss.GetAttributeValue(SF2Attribute_AddMaxSpeedOnStun);
					if (value > 0.0)
					{
						NPCSetAddMaxSpeed(chaserBoss.Index, value);
					}
					value = chaserBoss.GetAttributeValue(SF2Attribute_AddAccelerationOnStun);
					if (value > 0.0)
					{
						NPCSetAddAcceleration(chaserBoss.Index, value);
					}
					g_SlenderNextStunTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetStunCooldown(chaserBoss.Index);
					if (IsValidClient(target))
					{
						// Chase him again!
						state = STATE_CHASE;
						GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
					}
					else
					{
						// WHAT DA FUUUUUUUUUUUQ. TARGET ISN'T VALID. AUSDHASUIHD
						state = STATE_ALERT;
						if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
						}
						g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
						g_NpcAutoChaseSprinterCooldown[chaserBoss.Index] = GetGameTime() + 5.0;
						if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare))
						{
							g_NpcLostChasingScareVictim[chaserBoss.Index] = true;
							g_NpcChasingScareVictin[chaserBoss.Index] = false;
						}
						if (chaserBoss.HasAttribute(SF2Attribute_AlertCopies) || chaserBoss.HasAttribute(SF2Attribute_AlertCompanions))
						{
							g_NpcCopyAlerted[chaserBoss.Index] = false;
						}
					}
				}
			}
		}
	}

	if (state != STATE_STUN)
	{
		if (stunEnabled)
		{
			if (NPCChaserGetStunHealth(chaserBoss.Index) <= 0 && g_SlenderNextStunTime[chaserBoss.Index] <= GetGameTime())
			{
				state = STATE_STUN;
				if (g_SlenderChaseInitialTimer[chaserBoss.Index] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[chaserBoss.Index]);
				}
			}
			if (SF_IsBoxingMap() && NPCChaserIsBoxingBoss(chaserBoss.Index))
			{
				if (!NPCChaserGetSelfHealState(chaserBoss.Index))
				{
					float percent = NPCChaserGetStunInitialHealth(chaserBoss.Index) > 0 ? (NPCChaserGetStunHealth(chaserBoss.Index) / NPCChaserGetStunInitialHealth(chaserBoss.Index)) : 0.0;
					if (percent < 0.75 && percent >= 0.5 && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsedRage1[chaserBoss.Index])
					{
						g_NpcUsesRageAnimation1[chaserBoss.Index] = true;
						NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
						if (difficulty != 2 && difficulty < 2)
						{
							NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									TF2_AddCondition(client, TFCond_CritCola, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
									EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								}
							}
						}
						NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
						SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
						NPCSetAddSpeed(chaserBoss.Index, 12.5);
						NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
						NPCSetAddAcceleration(chaserBoss.Index, 100.0);

						g_NpcUsedRage1[chaserBoss.Index] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						g_SlenderRage1Timer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderRageOneTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[chaserBoss.Index])
						{
							// Cancel attacking.
							NPCClearAttackStats(chaserBoss.Index);
						}
					}
					else if (percent < 0.5 && percent >= 0.25 && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsedRage2[chaserBoss.Index])
					{
						g_NpcUsesRageAnimation2[chaserBoss.Index] = true;
						NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
						if (difficulty != 3 && difficulty < 3)
						{
							NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int buff = GetRandomInt(1, 3);
									switch (buff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritCola, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
									}
								}
							}
						}
						NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
						SF2BossProfileSoundInfo soundInfo;
						GetChaserProfileRageTwoSounds(slenderProfile, soundInfo);
						if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
						{
							SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageTwo);
						}
						else
						{
							SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
						}
						NPCSetAddSpeed(chaserBoss.Index, 12.5);
						NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
						NPCSetAddAcceleration(chaserBoss.Index, 100.0);

						g_NpcUsedRage2[chaserBoss.Index] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						g_SlenderRage2Timer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderRageTwoTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[chaserBoss.Index])
						{
							// Cancel attacking.
							NPCClearAttackStats(chaserBoss.Index);
						}
					}
					else if (percent < 0.25 && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcHasUsedRage3[chaserBoss.Index])
					{
						g_NpcUsesRageAnimation3[chaserBoss.Index] = true;
						NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
						if (difficulty != 4 && difficulty < 4)
						{
							NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int buff = GetRandomInt(1, 4);
									switch (buff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + g_SlenderAnimationDuration[chaserBoss.Index]);
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 4:
										{
											TF2_RegeneratePlayer(client);
										}
									}
								}
							}
						}
						NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
						SF2BossProfileSoundInfo soundInfo;
						GetChaserProfileRageThreeSounds(slenderProfile, soundInfo);
						if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
						{
							SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageThree);
						}
						else
						{
							SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
						}
						NPCSetAddSpeed(chaserBoss.Index, 12.5);
						NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
						NPCSetAddAcceleration(chaserBoss.Index, 100.0);

						g_NpcHasUsedRage3[chaserBoss.Index] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						g_SlenderRage3Timer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderRageThreeTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[chaserBoss.Index])
						{
							// Cancel attacking.
							NPCClearAttackStats(chaserBoss.Index);
						}
					}
				}
				else
				{
					float percent = NPCChaserGetStunInitialHealth(chaserBoss.Index) > 0 ? (NPCChaserGetStunHealth(chaserBoss.Index) / NPCChaserGetStunInitialHealth(chaserBoss.Index)) : 0.0;
					if (percent < NPCChaserGetStartSelfHealPercentage(chaserBoss.Index) && g_NpcSelfHealStage[chaserBoss.Index] < 3)
					{
						if (g_NpcIsRunningToHeal[chaserBoss.Index] || g_NpcIsHealing[chaserBoss.Index])
						{
							oldTarget = target;
							target = INVALID_ENT_REFERENCE;
							g_SlenderTarget[chaserBoss.Index] = INVALID_ENT_REFERENCE;
						}
						if (g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcSetHealDestination[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
						{
							float min = GetChaserProfileHealTimeMin(slenderProfile);
							float max = GetChaserProfileHealTimeMax(slenderProfile);
							g_NpcFleeHealTimer[chaserBoss.Index] = GetGameTime() + GetRandomFloat(min, max);

							// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
							// If the position can't be reached, then just get to the closest area that we can get.
							float wanderRangeMin = GetChaserProfileHealRangeMin(slenderProfile);
							float wanderRangeMax = GetChaserProfileHealRangeMax(slenderProfile);
							float wanderRange = GetRandomFloat(wanderRangeMin, wanderRangeMax);

							float fleePos[3];
							fleePos[0] = 0.0;
							fleePos[1] = GetRandomFloat(0.0, 360.0);
							fleePos[2] = 0.0;

							GetAngleVectors(fleePos, fleePos, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(fleePos, fleePos);
							ScaleVector(fleePos, wanderRange);
							AddVectors(fleePos, myPos, fleePos);

							chaserBoss.SetGoalPos(fleePos);

							if (!g_NpcHasCloaked[chaserBoss.Index] && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && NPCChaserIsCloakEnabled(chaserBoss.Index) && NPCChaserCanCloakToHeal(chaserBoss.Index))
							{
								//Time for a more cloaking aproach!
								SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(GetChaserProfileCloakRenderMode(slenderProfile)));

								int cloakColor[4];
								GetChaserProfileCloakRenderColor(slenderProfile, cloakColor);

								SetEntityRenderColor(npcEntity.index, cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3]);
								g_NpcHasCloaked[chaserBoss.Index] = true;
								g_NpcNextDecloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakDuration(chaserBoss.Index, difficulty);
								SlenderToggleParticleEffects(npcEntity.index);
								GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
								SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
								EmitSoundToAll(g_SlenderCloakOnSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								Call_StartForward(g_OnBossCloakedFwd);
								Call_PushCell(chaserBoss.Index);
								Call_Finish();
							}

							g_NpcSetHealDestination[chaserBoss.Index] = true;
						}
						if (!g_BossPathFollower[chaserBoss.Index].IsValid())
						{
							g_NpcSetHealDestination[chaserBoss.Index] = false;
						}
						if ((GetVectorSquareMagnitude(g_SlenderGoalPos[chaserBoss.Index], myPos) < SquareFloat(125.0) || g_NpcFleeHealTimer[chaserBoss.Index] < GetGameTime()) && g_NpcSetHealDestination[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
						{
							if (g_NpcHasCloaked[chaserBoss.Index] && NPCChaserIsCloakEnabled(chaserBoss.Index))
							{
								SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
								SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], g_SlenderRenderColor[chaserBoss.Index][3]);

								g_NpcHasCloaked[chaserBoss.Index] = false;
								SlenderToggleParticleEffects(npcEntity.index, true);
								GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
								SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
								EmitSoundToAll(g_SlenderCloakOffSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								g_SlenderNextCloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakCooldown(chaserBoss.Index, difficulty);
								Call_StartForward(g_OnBossDecloakedFwd);
								Call_PushCell(chaserBoss.Index);
								Call_Finish();
							}
							float timerFloat = GetChaserProfileHealAnimTimer(slenderProfile);
							g_NpcHealCount[chaserBoss.Index] = 0;
							g_NpcUsesHealAnimation[chaserBoss.Index] = true;
							g_NpcIsRunningToHeal[chaserBoss.Index] = false;
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
							g_SlenderHealTimer[chaserBoss.Index] = CreateTimer(timerFloat, Timer_SlenderHealAnimationTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
							g_SlenderHealDelayTimer[chaserBoss.Index] = CreateTimer(GetChaserProfileHealFunctionTimer(slenderProfile), Timer_SlenderHealDelayTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
							g_NpcIsHealing[chaserBoss.Index] = true;
							NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
						}
						if (!g_NpcUseStartFleeAnimation[chaserBoss.Index] && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
						{
							switch (g_NpcSelfHealStage[chaserBoss.Index])
							{
								case 0:
								{
									g_NpcUseStartFleeAnimation[chaserBoss.Index] = true;
									NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
									if (difficulty != 2 && difficulty < 2)
									{
										NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
												EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											}
										}
									}
									NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[chaserBoss.Index] = 0;
									SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
									NPCSetAddSpeed(chaserBoss.Index, 12.5);
									NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
									NPCSetAddAcceleration(chaserBoss.Index, 100.0);
								}
								case 1:
								{
									g_NpcUseStartFleeAnimation[chaserBoss.Index] = true;
									NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
									if (difficulty != 3 && difficulty < 3)
									{
										NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int buff = GetRandomInt(1, 3);
												switch (buff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
												}
											}
										}
									}
									NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[chaserBoss.Index] = 0;
									SF2BossProfileSoundInfo soundInfo;
									GetChaserProfileRageTwoSounds(slenderProfile, soundInfo);
									if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
									{
										SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageTwo);
									}
									else
									{
										SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
									}
									NPCSetAddSpeed(chaserBoss.Index, 12.5);
									NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
									NPCSetAddAcceleration(chaserBoss.Index, 100.0);
								}
								case 2:
								{
									g_NpcUseStartFleeAnimation[chaserBoss.Index] = true;
									NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
									if (difficulty != 4 && difficulty < 4)
									{
										NPCChaserSetBoxingDifficulty(chaserBoss.Index, NPCChaserGetBoxingDifficulty(chaserBoss.Index)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int buff = GetRandomInt(1, 4);
												switch (buff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetChaserProfileHealTimeMax(slenderProfile) + g_SlenderAnimationDuration[chaserBoss.Index]);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 4:
													{
														TF2_RegeneratePlayer(client);
													}
												}
											}
										}
									}
									NPCChaserSetBoxingRagePhase(chaserBoss.Index, NPCChaserGetBoxingRagePhase(chaserBoss.Index)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[chaserBoss.Index] = 0;
									SF2BossProfileSoundInfo soundInfo;
									GetChaserProfileRageThreeSounds(slenderProfile, soundInfo);
									if (soundInfo.Paths != null && soundInfo.Paths.Length > 0)
									{
										SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageThree);
									}
									else
									{
										SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_RageAll);
									}
									NPCSetAddSpeed(chaserBoss.Index, 12.5);
									NPCSetAddMaxSpeed(chaserBoss.Index, 25.0);
									NPCSetAddAcceleration(chaserBoss.Index, 100.0);
								}
							}
						}
						if (g_IsSlenderAttacking[chaserBoss.Index])
						{
							// Cancel attacking.
							NPCClearAttackStats(chaserBoss.Index);
						}
					}
				}
			}
		}
	}

	if (!IsValidClient(target) && g_SlenderTeleportTargetIsCamping[chaserBoss.Index] && g_SlenderTeleportTarget[chaserBoss.Index] != INVALID_ENT_REFERENCE) //We spawned, and our target is a camper kill him!
	{
		int campingTarget = EntRefToEntIndex(g_SlenderTeleportTarget[chaserBoss.Index]);
		if (MaxClients >= campingTarget > 0 && IsTargetValidForSlender(campingTarget))
		{
			g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(campingTarget);
			state = STATE_CHASE;
			GetClientAbsOrigin(campingTarget, g_SlenderGoalPos[chaserBoss.Index]);
		}
		g_SlenderTeleportTargetIsCamping[chaserBoss.Index] = false;
	}

	if (NPCChaserCanChaseOnLook(chaserBoss.Index) && g_NpcChaseOnLookTarget[chaserBoss.Index].Length > 0 && IsValidClient(target) && state != STATE_ATTACK && state != STATE_STUN)
	{
		g_SlenderIsAutoChasingLoudPlayer[chaserBoss.Index] = true;
		g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
	}
	if ((SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_BossesChaseEndlessly() || g_SlenderChasesEndlessly[chaserBoss.Index] || SF_IsSlaughterRunMap()) && state != STATE_ATTACK && state != STATE_STUN && IsValidClient(target) && !g_SlenderGiveUp[chaserBoss.Index])
	{
		g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
	}
	if ((SF_IsRaidMap() || SF_IsBoxingMap()) && (g_NpcIsRunningToHeal[chaserBoss.Index] || g_NpcIsHealing[chaserBoss.Index]))
	{
		g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		state = STATE_CHASE;
	}
	if (chaserBoss.HasAttribute(SF2Attribute_ChaseTargetOnScare) && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && IsValidClient(target) && g_PlayerScaredByBoss[target][chaserBoss.Index] && !g_NpcChasingScareVictin[chaserBoss.Index] && !g_NpcLostChasingScareVictim[chaserBoss.Index])
	{
		g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_NpcChasingScareVictin[chaserBoss.Index] = true;
		g_PlayerScaredByBoss[target][chaserBoss.Index] = false;
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[chaserBoss.Index]);
	}
	if (IsValidClient(bestNewTarget) && (playerInTrap[bestNewTarget] || playerMadeNoise[bestNewTarget]) && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
	{
		g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
		target = bestNewTarget;
		g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(target);
		state = STATE_CHASE;
		GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[chaserBoss.Index]);
	}
	// Finally, set our new state.
	g_SlenderState[chaserBoss.Index] = state;

	if (oldState != state)
	{
		g_BossPathFollower[chaserBoss.Index].Invalidate();

		switch (state)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				g_SlenderTarget[chaserBoss.Index] = INVALID_ENT_REFERENCE;
				g_SlenderTimeUntilIdle[chaserBoss.Index] = 0.0;
				g_SlenderTimeUntilAlert[chaserBoss.Index] = 0.0;
				g_SlenderTimeUntilChase[chaserBoss.Index] = 0.0;
				g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false;
				g_NpcLostChasingScareVictim[chaserBoss.Index] = false;
				g_NpcChasingScareVictin[chaserBoss.Index] = false;

				if (oldState != STATE_IDLE && oldState != STATE_WANDER)
				{
					g_SlenderTargetSoundCount[chaserBoss.Index] = 0;
					g_SlenderInvestigatingSound[chaserBoss.Index] = false;
					g_SlenderTargetSoundDiscardMasterPosTime[chaserBoss.Index] = -1.0;

					g_SlenderTimeUntilKill[chaserBoss.Index] = GetGameTime() + NPCGetIdleLifetime(chaserBoss.Index, difficulty);
				}

				if (g_NpcHasCloaked[chaserBoss.Index] && NPCChaserIsCloakEnabled(chaserBoss.Index))
				{
					SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
					SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], 0);
					g_NpcHasCloaked[chaserBoss.Index] = false;
					SlenderToggleParticleEffects(npcEntity.index, true);
					GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
					SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
					EmitSoundToAll(g_SlenderCloakOffSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_SlenderNextCloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakCooldown(chaserBoss.Index, difficulty);
					Call_StartForward(g_OnBossDecloakedFwd);
					Call_PushCell(chaserBoss.Index);
					Call_Finish();
				}

				if (state == STATE_WANDER)
				{
					// Force new wander position.
					for (int difficulty3; difficulty3 < Difficulty_Max; difficulty3++)
					{
						g_SlenderNextWanderPos[chaserBoss.Index][difficulty3] = -1.0;
					}
				}
			}

			case STATE_ALERT:
			{
				g_SlenderGiveUp[chaserBoss.Index] = false;

				g_SlenderChaseDeathPositionBool[chaserBoss.Index] = false;

				// Set our goal position.
				if (g_SlenderInvestigatingSound[chaserBoss.Index])
				{
					chaserBoss.SetGoalPos(g_SlenderTargetSoundMasterPos[chaserBoss.Index]);
				}

				g_SlenderTimeUntilIdle[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertDuration(chaserBoss.Index, difficulty);
				g_SlenderTimeUntilAlert[chaserBoss.Index] = -1.0;
				g_NpcLostChasingScareVictim[chaserBoss.Index] = false;
				g_SlenderTimeUntilChase[chaserBoss.Index] = GetGameTime() + NPCChaserGetAlertGracetime(chaserBoss.Index, difficulty);

				if (g_NpcHasCloaked[chaserBoss.Index] && NPCChaserIsCloakEnabled(chaserBoss.Index))
				{
					SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
					SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], 0);

					g_NpcHasCloaked[chaserBoss.Index] = false;
					SlenderToggleParticleEffects(npcEntity.index, true);
					GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
					SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
					EmitSoundToAll(g_SlenderCloakOffSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_SlenderNextCloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakCooldown(chaserBoss.Index, difficulty);
					Call_StartForward(g_OnBossDecloakedFwd);
					Call_PushCell(chaserBoss.Index);
					Call_Finish();
				}
			}
			case STATE_CHASE, STATE_ATTACK:
			{
				g_SlenderInvestigatingSound[chaserBoss.Index] = false;
				g_SlenderTargetSoundCount[chaserBoss.Index] = 0;

				if (oldState != STATE_ATTACK && oldState != STATE_CHASE && oldState != STATE_STUN)
				{
					g_SlenderTimeUntilIdle[chaserBoss.Index] = -1.0;
					g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
					g_SlenderAutoChaseCount[chaserBoss.Index] = 0;
					g_SlenderTimeUntilChase[chaserBoss.Index] = -1.0;

					float persistencyTime = GetChaserProfileChasePersistencyTimeInit(slenderProfile);
					if (persistencyTime >= 0.0)
					{
						g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + persistencyTime;
					}
				}

				if (state == STATE_ATTACK)
				{
					if (g_NpcUsesRageAnimation1[chaserBoss.Index] || g_NpcUsesRageAnimation2[chaserBoss.Index] || g_NpcUsesRageAnimation3[chaserBoss.Index])
					{
						state = oldState;
					}
					else
					{
						g_IsSlenderAttacking[chaserBoss.Index] = true;
						npcEntity.RemoveAllGestures();
						CBaseNPC_RemoveAllLayers(npcEntity.index);
						loco.ClearStuckStatus();
						int attackIndex = NPCGetCurrentAttackIndex(chaserBoss.Index);
						if (!NPCChaserGetAttackWhileRunningState(chaserBoss.Index, attackIndex))
						{
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
						}
						if (NPCChaserGetAttackType(chaserBoss.Index, attackIndex) != SF2BossAttackType_ExplosiveDance && NPCChaserGetAttackType(chaserBoss.Index, attackIndex) != SF2BossAttackType_LaserBeam)
						{
							g_SlenderAttackTimer[chaserBoss.Index] = CreateTimer(NPCChaserGetAttackDamageDelay(chaserBoss.Index, attackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
							g_NpcAlreadyAttacked[chaserBoss.Index] = false;
							NpcSetCurrentAttackRepeat(chaserBoss.Index, attackIndex, 0);
							NPCChaserSetNextAttackTime(chaserBoss.Index, attackIndex, GetGameTime() + NPCChaserGetAttackCooldown(chaserBoss.Index, attackIndex, difficulty));
						}
						else if (NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_ExplosiveDance)
						{
							g_SlenderAttackTimer[chaserBoss.Index] = CreateTimer(NPCChaserGetAttackDamageDelay(chaserBoss.Index, attackIndex), Timer_SlenderPrepareExplosiveDance, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
							NPCChaserSetNextAttackTime(chaserBoss.Index, attackIndex, GetGameTime() + NPCChaserGetAttackCooldown(chaserBoss.Index, attackIndex, difficulty));
						}
						else if (NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_LaserBeam)
						{
							g_SlenderAttackTimer[chaserBoss.Index] = CreateTimer(NPCChaserGetAttackDamageDelay(chaserBoss.Index, attackIndex), Timer_SlenderChaseBossAttackBeginLaser, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
						}
						if (NPCChaserGetAttackLifeStealState(chaserBoss.Index, attackIndex) && NPCChaserGetAttackType(chaserBoss.Index, attackIndex) == SF2BossAttackType_Melee)
						{
							if (!g_NpcStealingLife[chaserBoss.Index])
							{
								g_NpcLifeStealTimer[chaserBoss.Index] = CreateTimer(0.5, Timer_SlenderStealLife, EntIndexToEntRef(npcEntity.index), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
								g_NpcStealingLife[chaserBoss.Index] = true;
							}
						}

						g_SlenderTimeUntilAttackEnd[chaserBoss.Index] = GetGameTime() + NPCChaserGetAttackDuration(chaserBoss.Index, attackIndex) + 0.01;

						g_NpcBaseAttackRunDurationTime[chaserBoss.Index][attackIndex] = GetGameTime() + NPCChaserGetAttackRunDuration(chaserBoss.Index, attackIndex);

						g_NpcBaseAttackRunDelayTime[chaserBoss.Index][attackIndex] = GetGameTime() + NPCChaserGetAttackRunDelay(chaserBoss.Index, attackIndex);

						float persistencyTime = GetChaserProfileChaseAttackPersistencyTimeInit(slenderProfile);
						if (persistencyTime >= 0.0)
						{
							g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + persistencyTime;
						}

						persistencyTime = GetChaserProfileChaseAttackPersistencyTimeAdd(slenderProfile);
						if (persistencyTime >= 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[chaserBoss.Index] < GetGameTime())
							{
								g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime();
							}
							g_SlenderTimeUntilNoPersistence[chaserBoss.Index] += persistencyTime;
						}

						if (g_NpcHasCloaked[chaserBoss.Index] && NPCChaserIsCloakEnabled(chaserBoss.Index))
						{
							SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
							SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], 0);
							g_NpcHasCloaked[chaserBoss.Index] = false;
							SlenderToggleParticleEffects(npcEntity.index, true);
							GetChaserProfileCloakParticle(slenderProfile, cloakParticle, sizeof(cloakParticle));
							SlenderCreateParticle(chaserBoss.Index, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOffSound[chaserBoss.Index], npcEntity.index, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_SlenderNextCloakTime[chaserBoss.Index] = GetGameTime() + NPCChaserGetCloakCooldown(chaserBoss.Index, difficulty);
							Call_StartForward(g_OnBossDecloakedFwd);
							Call_PushCell(chaserBoss.Index);
							Call_Finish();
						}
						SlenderPerformVoice(chaserBoss.Index, attackIndex, SF2BossSound_Attack);
						if (g_LastStuckTime[chaserBoss.Index] != 0.0)
						{
							g_LastStuckTime[chaserBoss.Index] = GetGameTime();
						}
						loco.ClearStuckStatus();
					}
				}
				else
				{
					if (oldState != STATE_ATTACK && !building)
					{
						// Sound handling.
						if (!NPCChaserCanChaseInitialOnStun(chaserBoss.Index))
						{
							if (oldState != STATE_STUN)
							{
								SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_ChaseInitial);
								if (NPCChaserCanUseChaseInitialAnimation(chaserBoss.Index) && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !SF_IsSlaughterRunMap())
								{
									if (g_SlenderChaseInitialTimer[chaserBoss.Index] == null && (g_NpcChaseOnLookTarget[chaserBoss.Index] == null || g_NpcChaseOnLookTarget[chaserBoss.Index].Length <= 0))
									{
										g_NpcUsesChaseInitialAnimation[chaserBoss.Index] = true;
										npc.flWalkSpeed = 0.0;
										npc.flRunSpeed = 0.0;
										NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
										g_SlenderChaseInitialTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
									}
								}
							}
						}
						else
						{
							SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_ChaseInitial);
							if (NPCChaserCanUseChaseInitialAnimation(chaserBoss.Index) && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !SF_IsSlaughterRunMap())
							{
								if (g_SlenderChaseInitialTimer[chaserBoss.Index] == null && (g_NpcChaseOnLookTarget[chaserBoss.Index] == null || g_NpcChaseOnLookTarget[chaserBoss.Index].Length <= 0))
								{
									g_NpcUsesChaseInitialAnimation[chaserBoss.Index] = true;
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
									g_SlenderChaseInitialTimer[chaserBoss.Index] = CreateTimer(g_SlenderAnimationDuration[chaserBoss.Index], Timer_SlenderChaseInitialTimer, EntIndexToEntRef(npcEntity.index), TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				}
			}
		}
		NPCChaserSetState(chaserBoss.Index, state);
		// Call our forward.
		Call_StartForward(g_OnBossChangeStateFwd);
		Call_PushCell(chaserBoss.Index);
		Call_PushCell(oldState);
		Call_PushCell(state);
		Call_Finish();
		if (NPCChaserNormalSoundHookEnabled(chaserBoss.Index) && state != STATE_WANDER &&
		!g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
		{
			if (state == STATE_CHASE)
			{
				SF2BossProfileSoundInfo soundInfo;
				GetChaserProfileChaseInitialSounds(slenderProfile, soundInfo);
				if (soundInfo.Paths == null || soundInfo.Paths.Length <= 0)
				{
					g_SlenderNextVoiceSound[chaserBoss.Index] = 0.0;
				}
			}
			else
			{
				g_SlenderNextVoiceSound[chaserBoss.Index] = 0.0;
			}
		}
	}

	if (oldState != state && !g_SlenderSpawning[chaserBoss.Index])
	{
		NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
	}

	if (g_NpcChangeToCrawl[chaserBoss.Index] && (state == STATE_CHASE || state == STATE_WANDER || state == STATE_ALERT))
	{
		NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, state);
		g_NpcChangeToCrawl[chaserBoss.Index] = false;
	}

	if (NPCChaserOldAnimationAIEnabled(chaserBoss.Index))
	{
		float slenderVelocity, returnFloat;
		slenderVelocity = loco.GetGroundSpeed();
		returnFloat = (slenderVelocity / GetEntPropFloat(npcEntity.index, Prop_Data, "m_flGroundSpeed")) * g_NpcCurrentAnimationSequencePlaybackRate[chaserBoss.Index];
		if (GetEntPropFloat(npcEntity.index, Prop_Data, "m_flGroundSpeed") != 0.0 && GetEntPropFloat(npcEntity.index, Prop_Data, "m_flGroundSpeed") > 10.0)
		{
			if (loco.IsOnGround())
			{
				if (state == STATE_WANDER && (chaserBoss.Flags & SFF_WANDERMOVE) || state == STATE_ALERT)
				{
					float playbackSpeed = returnFloat;
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(npcEntity.index, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
				if (state == STATE_CHASE && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUsesHealAnimation[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
				{
					float playbackSpeed = returnFloat;
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(npcEntity.index, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
			}
		}
		else
		{
			float slenderVelocityOld;
			float velocity, walkVelocity, generalVel;
			slenderVelocityOld = loco.GetGroundSpeed();
			generalVel = slenderVelocityOld;
			if (g_SlenderCalculatedSpeed[chaserBoss.Index] <= 0.0)
			{
				velocity = 0.0;
			}
			else
			{
				velocity = (generalVel + ((g_SlenderCalculatedSpeed[chaserBoss.Index] * g_RoundDifficultyModifier)/15))/g_SlenderCalculatedSpeed[chaserBoss.Index];
			}

			if (g_SlenderCalculatedWalkSpeed[chaserBoss.Index] <= 0.0)
			{
				walkVelocity = 0.0;
			}
			else
			{
				walkVelocity = (generalVel + ((g_SlenderCalculatedWalkSpeed[chaserBoss.Index] * g_RoundDifficultyModifier)/15))/g_SlenderCalculatedWalkSpeed[chaserBoss.Index];
			}
			if (loco.IsOnGround())
			{
				if (state == STATE_WANDER && (chaserBoss.Flags & SFF_WANDERMOVE) || state == STATE_ALERT)
				{
					float playbackSpeed = walkVelocity * g_NpcCurrentAnimationSequencePlaybackRate[chaserBoss.Index];
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(npcEntity.index, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
				if (state == STATE_CHASE && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index] && !g_NpcUsesRageAnimation1[chaserBoss.Index] && !g_NpcUsesRageAnimation2[chaserBoss.Index] && !g_NpcUsesRageAnimation3[chaserBoss.Index] && !g_NpcUsesHealAnimation[chaserBoss.Index] && !g_NpcUseStartFleeAnimation[chaserBoss.Index])
				{
					float playbackSpeed = velocity * g_NpcCurrentAnimationSequencePlaybackRate[chaserBoss.Index];
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(npcEntity.index, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
			}
		}
	}

	switch (state)
	{
		case STATE_WANDER, STATE_ALERT, STATE_CHASE, STATE_ATTACK:
		{
			// These deal with movement, therefore we need to set our
			// destination first. That is, if we don't have one. (nav mesh only)

			if (state == STATE_WANDER)
			{
				if (GetGameTime() >= g_SlenderNextWanderPos[chaserBoss.Index][difficulty])
				{
					float min = GetChaserProfileWanderTimeMin(slenderProfile, difficulty);
					float max = GetChaserProfileWanderTimeMax(slenderProfile, difficulty);
					g_SlenderNextWanderPos[chaserBoss.Index][difficulty] = GetGameTime() + GetRandomFloat(min, max);

					if (chaserBoss.Flags & SFF_WANDERMOVE)
					{
						// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
						// If the position can't be reached, then just get to the closest area that we can get.
						float wanderRangeMin = NPCChaserGetWanderRangeMin(chaserBoss.Index, difficulty);
						float wanderRangeMax = NPCChaserGetWanderRangeMax(chaserBoss.Index, difficulty);
						float wanderRange = GetRandomFloat(wanderRangeMin, wanderRangeMax);

						float wanderPos[3];

						wanderPos[0] = myPos[0] + GetRandomFloat(-wanderRange, wanderRange);
						wanderPos[1] = myPos[1] + GetRandomFloat(-wanderRange, wanderRange);
						wanderPos[2] = myPos[2];

						CNavArea zArea = TheNavMesh.GetNearestNavArea(wanderPos, _, wanderRange);
						if (zArea != NULL_AREA)
						{
							wanderPos[2] = zArea.GetZ(wanderPos[0], wanderPos[1]);
						}

						chaserBoss.SetGoalPos(wanderPos);

						g_SlenderNextPathTime[chaserBoss.Index] = -1.0; // We're not going to wander around too much, so no need for a time constraint.
					}
				}
			}
			else if (state == STATE_ALERT)
			{
				if (interruptConditions & COND_SAWENEMY)
				{
					if (IsValidEntity(bestNewTarget))
					{
						if ((building) || (((playerInFOV[bestNewTarget] || playerNear[bestNewTarget]) && playerVisible[bestNewTarget]) || (playerMadeNoise[bestNewTarget] || playerInTrap[bestNewTarget])))
						{
							// Constantly update my path if I see him.
							if (GetGameTime() >= g_SlenderNextPathTime[chaserBoss.Index])
							{
								GetEntPropVector(bestNewTarget, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[chaserBoss.Index]);
								g_SlenderNextPathTime[chaserBoss.Index] = GetGameTime() + 0.4;
							}
						}
					}
				}
			}
			else if ((state == STATE_CHASE || state == STATE_ATTACK) && !g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index])
			{
				if (IsValidEntity(bestNewTarget))
				{
					oldTarget = target;
					target = bestNewTarget;
					g_SlenderTarget[chaserBoss.Index] = EntIndexToEntRef(bestNewTarget);
				}

				if (target != INVALID_ENT_REFERENCE)
				{
					if (oldTarget != target)
					{
						// Brand new target! We need a path, and we need to reset our persistency, if needed.
						float persistencyTime = GetChaserProfileChaseNewTargetPersistencyTimeInit(slenderProfile);
						if (persistencyTime >= 0.0)
						{
							g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + persistencyTime;
						}

						persistencyTime = GetChaserProfileChaseNewTargetPersistencyTimeAdd(slenderProfile);
						if (persistencyTime >= 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[chaserBoss.Index] < GetGameTime())
							{
								g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime();
							}
							g_SlenderTimeUntilNoPersistence[chaserBoss.Index] += persistencyTime;
						}

						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[chaserBoss.Index]);
					}
					else if ((building) || ((playerInFOV[target] && playerVisible[target]) || GetGameTime() < g_SlenderTimeUntilNoPersistence[chaserBoss.Index]))
					{
						// Constantly update my path if I see him or if I'm still being persistent.
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[chaserBoss.Index]);
					}
				}
				if (chaserBoss.GetTeleporter(0) != INVALID_ENT_REFERENCE)
				{
					int teleporter = EntRefToEntIndex(chaserBoss.GetTeleporter(0));
					if (IsValidEntity(teleporter) && teleporter > MaxClients)
					{
						GetEntPropVector(teleporter, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[chaserBoss.Index]);
					}
				}
			}
			if ((!g_SlenderInDeathcam[chaserBoss.Index] && (state == STATE_WANDER && (chaserBoss.Flags & SFF_WANDERMOVE) && g_SlenderCalculatedWalkSpeed[chaserBoss.Index] > 0.0)
				 || (state == STATE_ALERT && g_SlenderCalculatedWalkSpeed[chaserBoss.Index] > 0.0)
				 || (state == STATE_CHASE && g_SlenderCalculatedSpeed[chaserBoss.Index] > 0.0)
				 || (state == STATE_ATTACK)))
			{
				g_BossPathFollower[chaserBoss.Index].ComputeToPos(bot, g_SlenderGoalPos[chaserBoss.Index]);
			}
			if (state == STATE_CHASE || state == STATE_ATTACK)
			{
				if (IsValidClient(target))
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(target, DEBUG_BOSS_CHASE, 1, "g_SlenderTimeUntilAlert[%d]: %f\ng_SlenderTimeUntilNoPersistence[%d]: %f", chaserBoss.Index, g_SlenderTimeUntilAlert[chaserBoss.Index] - GetGameTime(), chaserBoss.Index, g_SlenderTimeUntilNoPersistence[chaserBoss.Index] - GetGameTime());
					#endif

					if ((building || (playerInFOV[target] && playerVisible[target])) && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index])
					{
						float distRatio = (playerDists[target] / SquareFloat(NPCGetSearchRadius(chaserBoss.Index, difficulty)));

						float chaseDurationTimeAddMin = GetChaserProfileChaseDurationAddVisibleMin(slenderProfile);
						float chaseDurationTimeAddMax = GetChaserProfileChaseDurationAddVisibleMax(slenderProfile);

						float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * distRatio);

						if (chaseDurationAdd > 0.0)
						{
							g_SlenderTimeUntilAlert[chaserBoss.Index] += chaseDurationAdd;
							if (g_SlenderTimeUntilAlert[chaserBoss.Index] > (GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty)))
							{
								g_SlenderTimeUntilAlert[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
							}
						}

						float persistencyTimeAddMin = GetChaserProfileChasePersistencyAddVisibleMin(slenderProfile);
						float persistencyTimeAddMax = GetChaserProfileChasePersistencyAddVisibleMax(slenderProfile);

						float persistencyTimeAdd = persistencyTimeAddMax - ((persistencyTimeAddMax - persistencyTimeAddMin) * distRatio);

						if (persistencyTimeAdd > 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[chaserBoss.Index] < GetGameTime())
							{
								g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime();
							}

							g_SlenderTimeUntilNoPersistence[chaserBoss.Index] += persistencyTimeAdd;
							if (g_SlenderTimeUntilNoPersistence[chaserBoss.Index] > (GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty)))
							{
								g_SlenderTimeUntilNoPersistence[chaserBoss.Index] = GetGameTime() + NPCChaserGetChaseDuration(chaserBoss.Index, difficulty);
							}
						}
					}
				}
			}
		}
	}

	// Sound handling.
	if (GetGameTime() >= g_SlenderNextVoiceSound[chaserBoss.Index])
	{
		switch (state)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_Idle);
			}
			case STATE_ALERT:
			{
				SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_Alert);
			}
			case STATE_CHASE:
			{
				if (!g_NpcIsRunningToHeal[chaserBoss.Index] && !g_NpcIsHealing[chaserBoss.Index] && !g_NpcUsesChaseInitialAnimation[chaserBoss.Index])
				{
					SlenderPerformVoice(chaserBoss.Index, _, SF2BossSound_Chasing);
				}
			}
		}
	}

	if (GetGameTime() >= g_SlenderNextFootstepSound[chaserBoss.Index])
	{
		SlenderCastFootstep(chaserBoss.Index);
	}

	// Reset our interrupt conditions.
	g_SlenderInterruptConditions[chaserBoss.Index] = 0;

	return Plugin_Continue;
}

Action Timer_SlenderPublicDeathCamThink(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	SF2NPC_Chaser chaserBoss = SF2NPC_Chaser(NPCGetFromEntIndex(slender));
	if (chaserBoss == SF2_INVALID_NPC_CHASER)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderEntityThink[chaserBoss.Index])
	{
		return Plugin_Stop;
	}

	if (!g_SlenderInDeathcam[chaserBoss.Index])
	{
		return Plugin_Stop;
	}
	CBaseCombatCharacter npcEntity = CBaseCombatCharacter(slender);
	int client = EntRefToEntIndex(g_SlenderDeathCamTarget[chaserBoss.Index]);

	bool attackWaiters = view_as<bool>(chaserBoss.Flags & SFF_ATTACKWAITERS);

	if (!IsValidClient(client) || (IsValidClient(client) && (!IsPlayerAlive(client) || (GetClientTeam(client) == TFTeam_Blue && !attackWaiters))))
	{
		if (g_SlenderDeathCamTimer[chaserBoss.Index] != null)
		{
			TriggerTimer(g_SlenderDeathCamTimer[chaserBoss.Index]);
		}
		else
		{
			if ((chaserBoss.Flags & SFF_FAKE))
			{
				if (g_SlenderInDeathcam[chaserBoss.Index])
				{
					g_SlenderInDeathcam[chaserBoss.Index] = false;
				}
				SlenderMarkAsFake(chaserBoss.Index);
			}
			else
			{
				SetEntityRenderMode(npcEntity.index, view_as<RenderMode>(g_SlenderRenderMode[chaserBoss.Index]));
				if (!NPCChaserIsCloaked(chaserBoss.Index))
				{
					SetEntityRenderColor(npcEntity.index, g_SlenderRenderColor[chaserBoss.Index][0], g_SlenderRenderColor[chaserBoss.Index][1], g_SlenderRenderColor[chaserBoss.Index][2], g_SlenderRenderColor[chaserBoss.Index][3]);
				}
				if (g_SlenderEntityThink[chaserBoss.Index] != null)
				{
					KillTimer(g_SlenderEntityThink[chaserBoss.Index]);
				}
				g_SlenderEntityThink[chaserBoss.Index] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(npcEntity.index), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				g_SlenderInDeathcam[chaserBoss.Index] = false;
				NPCChaserUpdateBossAnimation(chaserBoss.Index, npcEntity.index, g_SlenderState[chaserBoss.Index]);
			}
		}
	}

	return Plugin_Continue;
}