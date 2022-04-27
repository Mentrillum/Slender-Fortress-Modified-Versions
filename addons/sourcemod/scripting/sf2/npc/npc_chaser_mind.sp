#if defined _sf2_npc_chaser_mind_included
#endinput
#endif

#define _sf2_npc_chaser_mind_included

char cloakParticle[PLATFORM_MAX_PATH];

public Action Timer_SlenderChaseBossThink(Handle timer, any entref) //God damn you are so big, you get a file dedicated to only you
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
	
	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (NPCGetFlags(bossIndex) & SFF_MARKEDASFAKE)
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	if (npc == INVALID_NPC)
	{
		return Plugin_Stop;
	}

	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();
	CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npc.GetEntity());

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_BOSS_IDLE, 1, "g_SlenderTimeUntilKill[%d]: %f", bossIndex, g_SlenderTimeUntilKill[bossIndex] - GetGameTime());
	#endif

	float myPos[3], myEyeAng[3];
	float buffer[3];
	
	char slenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, slenderProfile, sizeof(slenderProfile));
	
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", myEyeAng);
	
	AddVectors(myEyeAng, g_SlenderEyeAngOffset[bossIndex], myEyeAng);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	
	float originalSpeed, originalMaxSpeed, originalAcceleration;
	if (!g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
	{
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !SF_IsSlaughterRunMap() && !g_Renevant90sEffect)
		{
			originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
			originalMaxSpeed = NPCGetMaxSpeed(bossIndex, difficulty) + NPCGetAddMaxSpeed(bossIndex);
			originalAcceleration = NPCGetAcceleration(bossIndex, difficulty) + NPCGetAddAcceleration(bossIndex);
		}
		else if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || SF_IsSlaughterRunMap() || g_Renevant90sEffect)
		{
			originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
			originalMaxSpeed = NPCGetMaxSpeed(bossIndex, difficulty) + NPCGetAddMaxSpeed(bossIndex);
			originalAcceleration = NPCGetAcceleration(bossIndex, difficulty) + NPCGetAddAcceleration(bossIndex);
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
		originalAcceleration = NPCGetAcceleration(bossIndex, difficulty) + NPCGetAddAcceleration(bossIndex); //Do this anyways
	}
	float originalWalkSpeed = NPCChaserGetWalkSpeed(bossIndex, difficulty);
	float originalMaxWalkSpeed = NPCChaserGetMaxWalkSpeed(bossIndex, difficulty);
	
	if (g_InProxySurvivalRageMode)
	{
		originalSpeed *= 1.25;
		originalWalkSpeed *= 1.25;
		originalMaxSpeed *= 1.25;
		originalMaxWalkSpeed *= 1.25;
	}
	float speed, maxSpeed, acceleration;
	if (!g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
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
		speed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0) + (NPCGetAnger(bossIndex) * g_RoundDifficultyModifier);
		maxSpeed = originalMaxSpeed + ((originalMaxSpeed * g_RoundDifficultyModifier) / 20.0) + (NPCGetAnger(bossIndex) * g_RoundDifficultyModifier);
		acceleration = originalAcceleration + ((originalAcceleration * g_RoundDifficultyModifier) / 15.0);
	}
	else
	{
		speed = originalSpeed + NPCGetAnger(bossIndex);
		maxSpeed = originalMaxSpeed + NPCGetAnger(bossIndex);
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

	g_SlenderSpeedMultiplier[bossIndex] = 1.0;
	if (PeopleCanSeeSlender(bossIndex, _, true))
	{
		if (NPCHasAttribute(bossIndex, "reduced speed on look"))
		{
			g_SlenderSpeedMultiplier[bossIndex] = NPCGetAttributeValue(bossIndex, "reduced speed on look");
			speed *= NPCGetAttributeValue(bossIndex, "reduced speed on look");
		}
		
		if (NPCHasAttribute(bossIndex, "reduced walk speed on look"))
		{
			walkSpeed *= NPCGetAttributeValue(bossIndex, "reduced walk speed on look");
		}

		if (NPCHasAttribute(bossIndex, "reduced acceleration on look"))
		{
			acceleration *= NPCGetAttributeValue(bossIndex, "reduced acceleration on look");
		}
	}
	if (g_NpcHasCloaked[bossIndex])
	{
		speed *= NPCChaserGetCloakSpeedMultiplier(bossIndex, difficulty);
		maxSpeed *= NPCChaserGetCloakSpeedMultiplier(bossIndex, difficulty);
	}
	if (g_NpcIsCrawling[bossIndex])
	{
		walkSpeed *= NPCChaserGetCrawlSpeedMultiplier(bossIndex, difficulty);
		maxWalkSpeed *= NPCChaserGetCrawlSpeedMultiplier(bossIndex, difficulty);
		speed *= NPCChaserGetCrawlSpeedMultiplier(bossIndex, difficulty);
		maxSpeed *= NPCChaserGetCrawlSpeedMultiplier(bossIndex, difficulty);
	}
	Action fAction = Plugin_Continue;
	float flForwardSpeed = walkSpeed;
	Call_StartForward(g_OnBossGetWalkSpeedFwd);
	Call_PushCell(bossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
	{
		walkSpeed = flForwardSpeed;
	}
	
	fAction = Plugin_Continue;
	flForwardSpeed = speed;
	Call_StartForward(g_OnBossGetSpeedFwd);
	Call_PushCell(bossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
	{
		speed = flForwardSpeed;
	}
	
	if (difficulty >= RoundToNearest(NPCGetAttributeValue(bossIndex, "block walk speed under difficulty", 0.0)))
	{
		g_SlenderCalculatedWalkSpeed[bossIndex] = walkSpeed;
	}
	else
	{
		g_SlenderCalculatedWalkSpeed[bossIndex] = 0.0;
	}
	
	if (!g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
	{
		g_SlenderCalculatedSpeed[bossIndex] = speed;
	}
	else
	{
		g_SlenderCalculatedSpeed[bossIndex] = 0.0;
	}
	g_SlenderCalculatedAcceleration[bossIndex] = acceleration;
	g_SlenderCalculatedMaxSpeed[bossIndex] = maxSpeed;
	g_SlenderCalculatedMaxWalkSpeed[bossIndex] = maxWalkSpeed;
	
	int oldState = g_SlenderState[bossIndex];
	int oldTarget = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
	
	int bestNewTarget = INVALID_ENT_REFERENCE;
	int soundTarget = INVALID_ENT_REFERENCE;
	float searchRange = NPCGetSearchRadius(bossIndex, difficulty);
	float searchSoundRange = NPCGetHearingRadius(bossIndex, difficulty);
	float bestNewTargetDist = SquareFloat(searchRange);
	int state = oldState;

	bool playerInFOV[MAXPLAYERS + 1];
	bool playerNear[MAXPLAYERS + 1];
	bool playerMadeNoise[MAXPLAYERS + 1];
	bool playerInTrap[MAXPLAYERS + 1];
	float playerDists[MAXPLAYERS + 1];
	bool playerVisible[MAXPLAYERS + 1];
	
	bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);
	bool stunEnabled = NPCChaserIsStunEnabled(bossIndex);
	
	float slenderMins[3], slenderMaxs[3];
	GetEntPropVector(slender, Prop_Send, "m_vecMins", slenderMins);
	GetEntPropVector(slender, Prop_Send, "m_vecMaxs", slenderMaxs);
	
	float traceMins[3], traceMaxs[3];
	traceMins[0] = slenderMins[0];
	traceMins[1] = slenderMins[1];
	traceMins[2] = 0.0;
	traceMaxs[0] = slenderMaxs[0];
	traceMaxs[1] = slenderMaxs[1];
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
	
	if (g_SlenderSoundTarget[bossIndex] != INVALID_ENT_REFERENCE)
	{
		soundTarget = EntRefToEntIndex(g_SlenderSoundTarget[bossIndex]);
	}
	
	bool inFlashlight = false;
	bool doubleFlashlightDamage = false;

	// Gather data about the players around me and get the best new target, in case my old target is invalidated.
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "player")) != -1)
	{
		if (!IsTargetValidForSlender(ent, attackEliminated))
		{
			continue;
		}
		float traceStartPos[3], traceEndPos[3];
		NPCGetEyePosition(bossIndex, traceStartPos);
		GetClientEyePosition(ent, traceEndPos);

		float dist = 99999999999.9;
		
		Handle trace = TR_TraceRayFilterEx(traceStartPos, 
					traceEndPos, 
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
					RayType_EndPoint, 
					TraceRayBossVisibility, 
					slender);

		bool isVisible = !TR_DidHit(trace);
		int traceHitEntity = TR_GetEntityIndex(trace);
		delete trace;

		if (!isVisible && traceHitEntity == ent)
		{
			isVisible = true;
		}
		
		if (isVisible)
		{
			isVisible = NPCShouldSeeEntity(bossIndex, ent);
		}

		if (g_PlayerFogCtrlOffset != -1 && g_FogCtrlEnableOffset != -1 && g_FogCtrlEndOffset != -1)
		{
			int iFogEntity = GetEntDataEnt2(ent, g_PlayerFogCtrlOffset);
			if (IsValidEdict(iFogEntity))
			{
				if (GetEntData(iFogEntity, g_FogCtrlEnableOffset) &&
					GetVectorSquareMagnitude(traceStartPos, traceEndPos) >= SquareFloat(GetEntDataFloat(iFogEntity, g_FogCtrlEndOffset))) 
				{
					isVisible = false;
				}
			}
		}

		float priorityValue;
		
		playerVisible[ent] = isVisible;
		
		// Near radius check.
		if (!g_NpcIgnoreNonMarkedForChase[bossIndex] && playerVisible[ent] && 
			GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(NPCChaserGetWakeRadius(bossIndex)))
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

		if (FloatAbs(AngleDiff(myEyeAng[1], buffer[1])) <= (NPCGetFOV(bossIndex) * 0.5))
		{
			playerInFOV[ent] = true;
		}
		
		if (!SF_IsRaidMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_NpcChasesEndlessly[bossIndex])
		{
			priorityValue = g_PageMax > 0 ? ((float(g_PlayerPageCount[ent]) / float(g_PageMax))/4.0) : 0.0;
		}
		
		if ((TF2_GetPlayerClass(ent) == TFClass_Medic || g_PlayerHasRegenerationItem[ent]) && !SF_IsBoxingMap())
		{
			priorityValue += 0.2;
		}
		
		if (TF2_GetPlayerClass(ent) == TFClass_Spy)
		{
			priorityValue += 0.1;
		}
		
		//Taunt alerts
		if (!g_NpcIgnoreNonMarkedForChase[bossIndex] && state != STATE_ALERT && state != STATE_ATTACK && state != STATE_STUN && state != STATE_CHASE && 
		GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(NPCGetTauntAlertRange(bossIndex, difficulty)) && TF2_IsPlayerInCondition(ent, TFCond_Taunting))
		{
			if (g_SlenderTauntAlertCount[bossIndex] < 5)
			{
				float targetPos[3];
				if (IsValidClient(ent))
				{
					GetClientAbsOrigin(ent, targetPos);
				}
				bestNewTarget = ent;
				if (g_SlenderChaseInitialTimer[bossIndex] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
				}
				g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
				g_SlenderGoalPos[bossIndex][0] = targetPos[0];
				g_SlenderGoalPos[bossIndex][1] = targetPos[1];
				g_SlenderGoalPos[bossIndex][2] = targetPos[2];
				g_SlenderAutoChaseCount[bossIndex] += NPCChaserAutoChaseAddVoice(bossIndex, difficulty) * 2;
				state = STATE_ALERT;
				g_SlenderTauntAlertCount[bossIndex]++;
			}
			else
			{
				playerMadeNoise[ent] = true;
				g_NpcInAutoChase[bossIndex] = true;
				g_SlenderTauntAlertCount[bossIndex] = 0;
			}
		}

		//Trap check
		if (g_PlayerTrapped[ent] && GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(searchRange))
		{
			if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
			{
				playerInTrap[ent] = true;
				g_NpcInAutoChase[bossIndex] = true;
			}
		}
		
		if (NPCChaserCanAutoChaseSprinters(bossIndex) && IsClientReallySprinting(ent) && GetVectorSquareMagnitude(traceStartPos, traceEndPos) <= SquareFloat(searchSoundRange) && GetGameTime() >= g_NpcAutoChaseSprinterCooldown[bossIndex] && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
		{
			playerMadeNoise[ent] = true;
			g_NpcInAutoChase[bossIndex] = true;
		}
		
		if (NPCChaserIsAutoChaseEnabled(bossIndex))
		{
			if (IsValidClient(soundTarget) && g_SlenderAutoChaseCount[bossIndex] >= NPCChaserAutoChaseThreshold(bossIndex, difficulty) && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
			{
				playerMadeNoise[soundTarget] = true;
				g_NpcInAutoChase[bossIndex] = true;
			}
		}

		dist = GetVectorSquareMagnitude(traceStartPos, traceEndPos);
		playerDists[ent] = dist;

		if (!g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex] && playerVisible[ent] && (playerNear[ent] || playerInFOV[ent]))
		{
			float targetPos[3];
			GetClientAbsOrigin(ent, targetPos);
			if (!g_SlenderIsAutoChasingLoudPlayer[bossIndex] && !g_NpcIgnoreNonMarkedForChase[bossIndex])
			{
				if (dist <= SquareFloat(searchRange))
				{
					// Subtract distance to increase priority.
					dist -= ((dist * priorityValue));
					
					if (dist < bestNewTargetDist)
					{
						bestNewTarget = ent;
						bestNewTargetDist = dist;
						g_SlenderInterruptConditions[bossIndex] |= COND_SAWENEMY;
						g_SlenderSeeTarget[bossIndex] = EntIndexToEntRef(ent);
					}
					g_SlenderLastFoundPlayerPos[bossIndex][ent][0] = targetPos[0];
					g_SlenderLastFoundPlayerPos[bossIndex][ent][1] = targetPos[1];
					g_SlenderLastFoundPlayerPos[bossIndex][ent][2] = targetPos[2];
					g_SlenderLastFoundPlayer[bossIndex][ent] = GetGameTime();
				}
			}
			else if (g_SlenderIsAutoChasingLoudPlayer[bossIndex] && g_NpcIgnoreNonMarkedForChase[bossIndex])
			{
				if (g_NpcChaseOnLookTarget[bossIndex].Length > 0 && g_NpcChaseOnLookTarget[bossIndex].FindValue(ent) != -1 &&
					dist <= SquareFloat(searchRange))
				{
					// Subtract distance to increase priority.
					dist -= ((dist * priorityValue));
					
					if (dist < bestNewTargetDist)
					{
						bestNewTarget = ent;
						bestNewTargetDist = dist;
						g_SlenderInterruptConditions[bossIndex] |= COND_SAWENEMY;
						g_SlenderSeeTarget[bossIndex] = EntIndexToEntRef(ent);
					}
					g_SlenderLastFoundPlayerPos[bossIndex][ent][0] = targetPos[0];
					g_SlenderLastFoundPlayerPos[bossIndex][ent][1] = targetPos[1];
					g_SlenderLastFoundPlayerPos[bossIndex][ent][2] = targetPos[2];
					g_SlenderLastFoundPlayer[bossIndex][ent] = GetGameTime();
				}
			}
		}

		if ((playerMadeNoise[ent] || playerInTrap[ent]) && state != STATE_CHASE && state != STATE_STUN && state != STATE_ATTACK)
		{
			if (g_NpcIgnoreNonMarkedForChase[bossIndex] && playerMadeNoise[ent])
			{
				bestNewTarget = ent;
				state = STATE_CHASE;
				SlenderAlertAllValidBosses(bossIndex, ent, bestNewTarget);
				GetClientAbsOrigin(ent, g_SlenderGoalPos[bossIndex]);
				g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
				g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
				g_SlenderGiveUp[bossIndex] = false;
				g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
				g_SlenderIsAutoChasingLoudPlayer[bossIndex] = true;
				g_SlenderAutoChaseCount[bossIndex] = 0;
			}
			else if (playerInTrap[ent] || (!g_NpcIgnoreNonMarkedForChase[bossIndex] && playerMadeNoise[ent]))
			{
				bestNewTarget = ent;
				state = STATE_CHASE;
				SlenderAlertAllValidBosses(bossIndex, ent, bestNewTarget);
				GetClientAbsOrigin(ent, g_SlenderGoalPos[bossIndex]);
				g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
				g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
				g_SlenderGiveUp[bossIndex] = false;
				g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
				g_SlenderIsAutoChasingLoudPlayer[bossIndex] = false;
			}
		}

		if (NPCChaserIsStunByFlashlightEnabled(bossIndex) && IsClientUsingFlashlight(ent) && playerInFOV[ent]) // Check to see if someone is facing at us with flashlight on. Only if I'm facing them too. BLINDNESS!
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
						if (TF2_GetPlayerClass(ent) == TFClass_Engineer)
						{
							doubleFlashlightDamage = true;
						}
					}
				}
			}
		}
		if (NPCChaserCanChaseOnLook(bossIndex) && playerInFOV[ent] && playerVisible[ent])
		{
			float eyeAng[3], requiredAng[3];
			GetClientEyeAngles(ent, eyeAng);
			SubtractVectors(traceEndPos, traceStartPos, requiredAng);
			GetVectorAngles(requiredAng, requiredAng);
			if (FloatAbs(AngleDiff(eyeAng[0], requiredAng[0])) <= 45.0 && FloatAbs(AngleDiff(requiredAng[1], eyeAng[1])) >= 135.0)
			{
				if (g_NpcChaseOnLookTarget[bossIndex].FindValue(ent) == -1)
				{
					g_NpcChaseOnLookTarget[bossIndex].Push(ent);
					char scarePath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, "sound_scare_player", scarePath, sizeof(scarePath));
					if (scarePath[0] != '\0')
					{
						EmitSoundToClient(ent, scarePath, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
					}
					TF2_AddCondition(ent, TFCond_MarkedForDeathSilent, -1.0);
					if (g_SlenderChaseInitialTimer[bossIndex] == null && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
					{
						g_NpcUsesChaseInitialAnimation[bossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(bossIndex, slender, state);
						g_SlenderChaseInitialTimer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}

	if (IsValidClient(EntRefToEntIndex(g_SlenderTarget[bossIndex])) && playerVisible[EntRefToEntIndex(g_SlenderTarget[bossIndex])])
	{
		g_SlenderTargetIsVisible[bossIndex] = true;
	}
	else
	{
		g_SlenderTargetIsVisible[bossIndex] = false;
	}

	if (g_SlenderIsAutoChasingLoudPlayer[bossIndex])
	{
		if (g_NpcChaseOnLookTarget[bossIndex].Length <= 0)
		{
			g_SlenderIsAutoChasingLoudPlayer[bossIndex] = false;
			g_SlenderSoundTarget[bossIndex] = INVALID_ENT_REFERENCE;
			soundTarget = INVALID_ENT_REFERENCE;
		}
	}
	
	// Damage us if we're in a flashlight.
	if (inFlashlight)
	{
		if (stunEnabled)
		{
			if (NPCChaserIsStunByFlashlightEnabled(bossIndex) && !(SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && !(g_NightvisionEnabledConVar.BoolValue))
			{
				if (NPCChaserGetStunHealth(bossIndex) > 0)
				{
					if (!doubleFlashlightDamage)
					{
						NPCChaserAddStunHealth(bossIndex, -NPCChaserGetStunFlashlightDamage(bossIndex));
					}
					else
					{
						NPCChaserAddStunHealth(bossIndex, -NPCChaserGetStunFlashlightDamage(bossIndex) * 1.5);
					}
					if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
					{
						NPCBossTriggerStun(bossIndex, slender, slenderProfile, myPos);
						Call_StartForward(g_OnBossStunnedFwd);
						Call_PushCell(bossIndex);
						Call_PushCell(-1);
						Call_Finish();
						state = STATE_STUN;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
					}
				}
			}
		}
	}
	
	// Process the target that we should have.
	int target = oldTarget;
	
	/*
	if (IsValidEdict(bestNewTarget))
	{
		target = bestNewTarget;
		g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
	}
	*/
	
	if (target && target != INVALID_ENT_REFERENCE)
	{
		if (!IsTargetValidForSlender(target, attackEliminated))
		{
			// Clear our target; he's not valid anymore.
			oldTarget = target;
			target = INVALID_ENT_REFERENCE;
			g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
		}
	}
	else
	{
		// Clear our target; he's not valid anymore.
		oldTarget = target;
		target = INVALID_ENT_REFERENCE;
		g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
	}

	if (building)
	{
		target = bestNewTarget;
	}
	
	//We should never give up, but sometimes it happens.
	if (g_SlenderGiveUp[bossIndex])
	{
		//Damit our target is unreachable for some unexplained reasons, haaaaaaaaaaaa!
		if (!SF_IsRaidMap() || !SF_BossesChaseEndlessly() || !SF_IsProxyMap() || !g_NpcChasesEndlessly[bossIndex] || !SF_IsBoxingMap() || !SF_IsSlaughterRunMap())
		{
			state = STATE_IDLE;
			g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
			g_SlenderGiveUp[bossIndex] = false;
		}
		
		if ((SF_BossesChaseEndlessly() || g_NpcChasesEndlessly[bossIndex] || SF_IsSlaughterRunMap() || SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap()) && !(NPCGetFlags(bossIndex) & SFF_NOTELEPORT))
		{
			//RemoveSlender(bossIndex);
		}
		//Do not, ok?
		g_SlenderGiveUp[bossIndex] = false;
		if (g_SlenderChaseInitialTimer[bossIndex] != null)
		{
			TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
		}
	}
	
	int interruptConditions = g_SlenderInterruptConditions[bossIndex];

	if ((SF_IsRaidMap() || (SF_BossesChaseEndlessly() || g_NpcChasesEndlessly[bossIndex]) || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap()) && !g_SlenderGiveUp[bossIndex] && !building && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
	{
		if (!IsValidClient(target) || (IsValidClient(target) && g_PlayerEliminated[target]))
		{
			if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && NPCAreAvailablePlayersAlive())
			{
				int raidClient;
				do
				{
					raidClient = GetRandomInt(1, MaxClients);
				}
				while (!IsClientInGame(raidClient) || 
					!IsPlayerAlive(raidClient) || 
					g_PlayerEliminated[raidClient] || 
					IsClientInGhostMode(raidClient) || 
					DidClientEscape(raidClient));
				
				for (int i = 1; i <= MaxClients; i++)
				{
					if (i == raidClient && IsValidClient(raidClient) && !g_PlayerEliminated[raidClient])
					{
						bestNewTarget = raidClient;
						g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
						g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
						state = STATE_CHASE;
						GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[bossIndex]);
						target = bestNewTarget;
					}
				}
			}
		}
	}

	if (NPCChaserCanChaseOnLook(bossIndex))
	{
		if (state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && NPCAreAvailablePlayersAlive() && g_NpcChaseOnLookTarget[bossIndex].Length != 0)
		{
			for (int i = 0; i < g_NpcChaseOnLookTarget[bossIndex].Length; i++)
			{
				int iLookClient = g_NpcChaseOnLookTarget[bossIndex].Get(i);
				if (IsValidClient(iLookClient) && !g_PlayerEliminated[iLookClient] && IsPlayerAlive(iLookClient) && IsClientInGame(iLookClient) &&
					!IsClientInGhostMode(iLookClient) && !DidClientEscape(iLookClient))
				{
					bestNewTarget = iLookClient;
					g_SlenderTarget[bossIndex] = EntIndexToEntRef(iLookClient);
					g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
					state = STATE_CHASE;
					GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[bossIndex]);
					target = bestNewTarget;
					SlenderAlertAllValidBosses(bossIndex, target, bestNewTarget);
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
				if (NPCChaserGetTeleporter(bossIndex, i) != INVALID_ENT_REFERENCE)
				{
					NPCChaserSetTeleporter(bossIndex, i, INVALID_ENT_REFERENCE);
				}
			}
			if (state == STATE_WANDER)
			{
				if (!g_BossPathFollower[bossIndex].IsValid() && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0)
				{
					state = STATE_IDLE;
				}
			}
			else
			{
				if ((NPCGetFlags(bossIndex) & SFF_WANDERMOVE) && GetGameTime() >= g_SlenderNextWanderPos[bossIndex][difficulty] && GetRandomFloat(0.0, 1.0) <= 0.25 && difficulty >= RoundToNearest(NPCGetAttributeValue(bossIndex, "block walk speed under difficulty", 0.0)))
				{
					state = STATE_WANDER;
				}
			}
			if (SF_SpecialRound(SPECIALROUND_BEACON) || g_RenevantBeaconEffect)
			{
				if (!g_SlenderInBacon[bossIndex])
				{
					int clientToPos = NPCChaserGetClosestPlayer(slender);
					float clientPosition[3];
					if (IsValidClient(clientToPos))
					{
						GetClientAbsOrigin(clientToPos, clientPosition);
					}
					bestNewTarget = clientToPos;
					state = STATE_ALERT;
					if (g_SlenderChaseInitialTimer[bossIndex] != null)
					{
						TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
					}
					g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
					g_SlenderGoalPos[bossIndex][0] = clientPosition[0];
					g_SlenderGoalPos[bossIndex][1] = clientPosition[1];
					g_SlenderGoalPos[bossIndex][2] = clientPosition[2];
					g_SlenderInBacon[bossIndex] = true;
				}
			}
			if (interruptConditions & COND_SAWENEMY)
			{
				if (NPCChaserIsAutoChaseEnabled(bossIndex))
				{
					g_SlenderAutoChaseCount[bossIndex] += NPCChaserAutoChaseAddGeneral(bossIndex, difficulty);
				}
				// I saw someone over here. Automatically put me into alert mode.
				state = STATE_ALERT;
				if (g_SlenderChaseInitialTimer[bossIndex] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
				}
				g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
				int clientToPos = EntRefToEntIndex(g_SlenderSeeTarget[bossIndex]);
				float clientPosition[3];
				if (IsValidClient(clientToPos))
				{
					GetClientAbsOrigin(clientToPos, clientPosition);
					bestNewTarget = clientToPos;
					g_SlenderGoalPos[bossIndex][0] = clientPosition[0];
					g_SlenderGoalPos[bossIndex][1] = clientPosition[1];
					g_SlenderGoalPos[bossIndex][2] = clientPosition[2];
				}
			}
			else if (interruptConditions & COND_HEARDSUSPICIOUSSOUND)
			{
				// Sound counts:
				// +1 will be added if it hears a footstep.
				// +2 will be added if the footstep is someone sprinting.
				// +5 will be added if the sound is from a player's weapon hitting an object or flashlight is heard..
				// +10 will be added if a voice command.
				//
				// Sound counts will be reset after the boss hears a sound after a certain amount of time.
				// The purpose of sound counts is to induce boss focusing on sounds suspicious entities are making.
				
				int count = 0;
				if (interruptConditions & COND_HEARDFOOTSTEP)
				{
					count += 1;
				}
				if (interruptConditions & COND_HEARDFOOTSTEPLOUD)
				{
					count += 2;
				}
				if ((interruptConditions & COND_HEARDWEAPON) || (interruptConditions & COND_HEARDFLASHLIGHT))
				{
					count += 5;
				}
				if (interruptConditions & COND_HEARDVOICE)
				{
					count += 10;
				}

				bool discardMasterPos = view_as<bool>(GetGameTime() >= g_SlenderTargetSoundDiscardMasterPosTime[bossIndex]);
				
				if (GetVectorSquareMagnitude(g_SlenderTargetSoundTempPos[bossIndex], g_SlenderTargetSoundMasterPos[bossIndex]) <= SquareFloat(GetProfileFloat(slenderProfile, "search_sound_pos_dist_tolerance", 512.0)) || 
					discardMasterPos)
				{
					if (discardMasterPos)
					{
						g_SlenderTargetSoundCount[bossIndex] = 0;
					}
					
					g_SlenderTargetSoundDiscardMasterPosTime[bossIndex] = GetGameTime() + GetProfileFloat(slenderProfile, "search_sound_pos_discard_time", 2.0);
					g_SlenderTargetSoundMasterPos[bossIndex][0] = g_SlenderTargetSoundTempPos[bossIndex][0];
					g_SlenderTargetSoundMasterPos[bossIndex][1] = g_SlenderTargetSoundTempPos[bossIndex][1];
					g_SlenderTargetSoundMasterPos[bossIndex][2] = g_SlenderTargetSoundTempPos[bossIndex][2];
					g_SlenderTargetSoundCount[bossIndex] += count;
				}
				if (g_SlenderTargetSoundCount[bossIndex] >= NPCChaserGetSoundCountToAlert(bossIndex))
				{
					// Someone's making some noise over there! Time to investigate.
					g_SlenderInvestigatingSound[bossIndex] = true; // This is just so that our sound position would be the goal position.
					state = STATE_ALERT;
					if (g_SlenderChaseInitialTimer[bossIndex] != null)
					{
						TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
					}
					g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
				}
			}
			if (NPCChaserGetTrapState(bossIndex))
			{
				if (g_SlenderNextTrapPlacement[bossIndex] <= GetGameTime() && g_TrapEntityCount < 32)
				{
					Trap_SpawnTrap(myPos, myEyeAng, bossIndex);
					g_SlenderNextTrapPlacement[bossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(bossIndex, difficulty);
				}
				else if (g_SlenderNextTrapPlacement[bossIndex] <= GetGameTime() && g_TrapEntityCount >= 32)
				{
					g_SlenderNextTrapPlacement[bossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(bossIndex, difficulty);
				}
			}
		}
		case STATE_ALERT:
		{
			if (state == STATE_ALERT)
			{
				if (!g_BossPathFollower[bossIndex].IsValid() && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0)
				{
					if (!(interruptConditions & COND_HEARDSUSPICIOUSSOUND))
					{
						state = STATE_IDLE;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
					}
					else if ((interruptConditions & COND_HEARDSUSPICIOUSSOUND) && GetVectorSquareMagnitude(g_SlenderGoalPos[bossIndex], myPos) <= SquareFloat(20.0))
					{
						state = STATE_IDLE;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
					}
				}
			}
			if (GetGameTime() >= g_SlenderTimeUntilIdle[bossIndex] && !g_NpcIsHealing[bossIndex] && !g_NpcIsRunningToHeal[bossIndex])
			{
				state = STATE_IDLE;
				if (g_SlenderChaseInitialTimer[bossIndex] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
				}
			}
			else if (IsValidClient(bestNewTarget))
			{
				if (GetGameTime() >= g_SlenderTimeUntilChase[bossIndex] || playerNear[bestNewTarget])
				{
					float traceStartPos[3], traceEndPos[3];
					NPCGetEyePosition(bossIndex, traceStartPos);
					
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
						slender);
					
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
						g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
						state = STATE_CHASE;
						GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[bossIndex]);
						SlenderAlertAllValidBosses(bossIndex, target, bestNewTarget);
					}
				}
				if (playerInTrap[bestNewTarget] || playerMadeNoise[bestNewTarget])
				{
					// AHAHAHAH! I GOT YOU NOW!
					target = bestNewTarget;
					g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
					state = STATE_CHASE;
					GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[bossIndex]);
					SlenderAlertAllValidBosses(bossIndex, target, bestNewTarget);
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
						g_SlenderGoalPos[bossIndex][0] = g_SlenderLastFoundPlayerPos[bossIndex][bestNewTarget][0];
						g_SlenderGoalPos[bossIndex][1] = g_SlenderLastFoundPlayerPos[bossIndex][bestNewTarget][1];
						g_SlenderGoalPos[bossIndex][2] = g_SlenderLastFoundPlayerPos[bossIndex][bestNewTarget][2];
					}
				}
				else if (interruptConditions & COND_HEARDSUSPICIOUSSOUND)
				{
					bool discardMasterPos = view_as<bool>(GetGameTime() >= g_SlenderTargetSoundDiscardMasterPosTime[bossIndex]);
					
					if (GetVectorSquareMagnitude(g_SlenderTargetSoundTempPos[bossIndex], g_SlenderTargetSoundMasterPos[bossIndex]) <= SquareFloat(GetProfileFloat(slenderProfile, "search_sound_pos_dist_tolerance", 512.0)) || 
						discardMasterPos)
					{
						g_SlenderTargetSoundDiscardMasterPosTime[bossIndex] = GetGameTime() + GetProfileFloat(slenderProfile, "search_sound_pos_discard_time", 2.0);
						g_SlenderTargetSoundMasterPos[bossIndex][0] = g_SlenderTargetSoundTempPos[bossIndex][0];
						g_SlenderTargetSoundMasterPos[bossIndex][1] = g_SlenderTargetSoundTempPos[bossIndex][1];
						g_SlenderTargetSoundMasterPos[bossIndex][2] = g_SlenderTargetSoundTempPos[bossIndex][2];
						
						// We have to manually set the goal position here because the goal position will not be changed due to no change in state.
						g_SlenderGoalPos[bossIndex][0] = g_SlenderTargetSoundMasterPos[bossIndex][0];
						g_SlenderGoalPos[bossIndex][1] = g_SlenderTargetSoundMasterPos[bossIndex][1];
						g_SlenderGoalPos[bossIndex][2] = g_SlenderTargetSoundMasterPos[bossIndex][2];
						
						g_SlenderInvestigatingSound[bossIndex] = true;
					}
				}
				
				for (int attackIndex = 0; attackIndex < NPCChaserGetAttackCount(bossIndex); attackIndex++)
				{
					if (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam)
					{
						continue;
					}
					
					bool blockingProp = false;
					
					if (NPCGetFlags(bossIndex) & SFF_ATTACKPROPS)
					{
						blockingProp = NPC_CanAttackProps(bossIndex, NPCChaserGetAttackRange(bossIndex, attackIndex), NPCChaserGetAttackSpread(bossIndex, attackIndex));
					}
					
					if (blockingProp)
					{
						state = STATE_ATTACK;
						NPCSetCurrentAttackIndex(bossIndex, attackIndex);
						break;
					}
				}
			}
			if (NPCChaserGetTrapState(bossIndex))
			{
				if (g_SlenderNextTrapPlacement[bossIndex] <= GetGameTime() && g_TrapEntityCount < 32)
				{
					Trap_SpawnTrap(myPos, myEyeAng, bossIndex);
					g_SlenderNextTrapPlacement[bossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(bossIndex, difficulty);
				}
				else if (g_SlenderNextTrapPlacement[bossIndex] <= GetGameTime() && g_TrapEntityCount >= 32)
				{
					g_SlenderNextTrapPlacement[bossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(bossIndex, difficulty);
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
					NPCGetEyePosition(bossIndex, traceStartPos);
					if (NPCChaserIsCloakEnabled(bossIndex))
					{
						float cloakDist = GetVectorSquareMagnitude(g_SlenderGoalPos[bossIndex], myPos);
						float cloakRange = NPCChaserGetCloakRange(bossIndex, difficulty);
						float decloakRange = NPCChaserGetDecloakRange(bossIndex, difficulty);
						if (cloakDist <= SquareFloat(cloakRange) && !g_NpcHasCloaked[bossIndex] && g_SlenderNextCloakTime[bossIndex] <= GetGameTime() && !g_NpcUsesChaseInitialAnimation[bossIndex])
						{
							//Time for a more cloaking aproach!
							SetEntityRenderMode(slender, view_as<RenderMode>(GetProfileNum(slenderProfile, "cloak_rendermode", 1)));

							int cloakColor[4];
							GetProfileColor(slenderProfile, "cloak_rendercolor", cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3], 
							g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);

							SetEntityRenderColor(slender, cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3]);
							g_NpcNextDecloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakDuration(bossIndex, difficulty);
							SlenderToggleParticleEffects(slender);
							GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
							if (cloakParticle[0] == '\0')
							{
								cloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOnSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_NpcHasCloaked[bossIndex] = true;
							Call_StartForward(g_OnBossCloakedFwd);
							Call_PushCell(bossIndex);
							Call_Finish();
						}
						if ((cloakDist <= SquareFloat(decloakRange) || GetGameTime() >= g_NpcNextDecloakTime[bossIndex]) && g_NpcHasCloaked[bossIndex])
						{
							//Come back now!
							SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
							SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
							
							SlenderToggleParticleEffects(slender, true);
							GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
							if (cloakParticle[0] == '\0')
							{
								cloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
							Call_StartForward(g_OnBossDecloakedFwd);
							Call_PushCell(bossIndex);
							Call_Finish();
							g_NpcHasCloaked[bossIndex] = false;
						}
					}
					
					if (NPCChaserIsProjectileEnabled(bossIndex))
					{
						if (NPCGetFlags(bossIndex) & SFF_FAKE)
						{
							SlenderMarkAsFake(bossIndex);
						}
						if (g_NpcProjectileCooldown[bossIndex] <= GetGameTime() && !NPCChaserUseProjectileAmmo(bossIndex) && !g_NpcUsesChaseInitialAnimation[bossIndex] && (building || (playerInFOV[target] && CanNPCSeePlayerNonTransparent(bossIndex, target))) && !g_NpcHasCloaked[bossIndex])
						{
							NPCChaserProjectileShoot(bossIndex, slender, target, slenderProfile, myPos);
						}
						else if (NPCChaserUseProjectileAmmo(bossIndex))
						{
							if (g_NpcProjectileCooldown[bossIndex] <= GetGameTime() && !g_NpcUsesChaseInitialAnimation[bossIndex] && (building || (playerInFOV[target] && CanNPCSeePlayerNonTransparent(bossIndex, target))) && !g_NpcHasCloaked[bossIndex] && (g_NpcProjectileAmmo[bossIndex] != 0))
							{
								NPCChaserProjectileShoot(bossIndex, slender, target, slenderProfile, myPos);
								g_NpcProjectileAmmo[bossIndex] = g_NpcProjectileAmmo[bossIndex] - 1;
							}
							if (g_NpcProjectileAmmo[bossIndex] == 0 && !g_NpcReloadingProjectiles[bossIndex])
							{
								g_NpcProjectileTimeToReload[bossIndex] = GetGameTime() + NPCChaserGetProjectileReloadTime(bossIndex, difficulty);
								g_NpcReloadingProjectiles[bossIndex] = true;
							}
							if (g_NpcProjectileTimeToReload[bossIndex] <= GetGameTime() && g_NpcProjectileAmmo[bossIndex] == 0)
							{
								g_NpcProjectileAmmo[bossIndex] = NPCChaserGetLoadedProjectiles(bossIndex, difficulty);
								g_NpcReloadingProjectiles[bossIndex] = false;
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
					
					if (g_SlenderChaseDeathPositionBool[bossIndex])
					{
						Handle trace = TR_TraceRayFilterEx(traceStartPos, 
							g_SlenderChaseDeathPosition[bossIndex], 
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
							RayType_EndPoint, 
							TraceRayBossVisibility, 
							slender);
						isDeathPosVisible = !TR_DidHit(trace);
						delete trace;
					}
					
					if (!building && !playerVisible[target] && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
					{
						if (GetGameTime() >= g_SlenderTimeUntilAlert[bossIndex] || (!attackEliminated && g_PlayerEliminated[target]))
						{
							state = STATE_ALERT;
							g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
							if (NPCHasAttribute(bossIndex, "chase target on scare"))
							{
								g_NpcLostChasingScareVictim[bossIndex] = true;
								g_NpcChasingScareVictin[bossIndex] = false;
							}
							if (NPCHasAttribute(bossIndex, "alert copies") || NPCHasAttribute(bossIndex, "alert companions"))
							{
								g_NpcCopyAlerted[bossIndex] = false;
							}
							g_SlenderAutoChaseCount[bossIndex] = 0;
							g_SlenderIsAutoChasingLoudPlayer[bossIndex] = false;
							g_NpcInAutoChase[bossIndex] = false;
							g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
							if (g_SlenderChaseInitialTimer[bossIndex] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
							}
						}
						else if (isDeathPosVisible || (!attackEliminated && g_PlayerEliminated[target]))
						{
							state = STATE_IDLE;
							if (NPCHasAttribute(bossIndex, "chase target on scare"))
							{
								g_NpcLostChasingScareVictim[bossIndex] = true;
								g_NpcChasingScareVictin[bossIndex] = false;
							}
							if (NPCHasAttribute(bossIndex, "alert copies") || NPCHasAttribute(bossIndex, "alert companions"))
							{
								g_NpcCopyAlerted[bossIndex] = false;
							}
							g_SlenderAutoChaseCount[bossIndex] = 0;
							g_SlenderIsAutoChasingLoudPlayer[bossIndex] = false;
							g_NpcInAutoChase[bossIndex] = false;
							g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
							if (g_SlenderChaseInitialTimer[bossIndex] != null)
							{
								TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
							}
						}
						GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
					}
					else if ((building || CanNPCSeePlayerNonTransparent(bossIndex, target)) && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
					{
						g_SlenderChaseDeathPositionBool[bossIndex] = false; // We're not chasing a dead player after all! Reset.
						
						float attackDirection[3], attackEyePos[3], clientPosAttack[3], attackDist;
						NPCGetEyePosition(bossIndex, attackEyePos);
						if (IsValidClient(target))
						{
							GetClientEyePosition(target, clientPosAttack);
						}
						else
						{
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", clientPosAttack);
							clientPosAttack[2] += 20.0;
						}
						attackDist = GetVectorSquareMagnitude(myPos, g_SlenderGoalPos[bossIndex]);
						SubtractVectors(clientPosAttack, attackEyePos, attackDirection);
						GetVectorAngles(attackDirection, attackDirection);
						attackDirection[2] = 180.0;
						
						float attackBeginRangeEx, attackBeginFOVEx;

						float fov = FloatAbs(AngleDiff(attackDirection[1], myEyeAng[1]));
						float clientHealth = float(GetEntProp(target, Prop_Send, "m_iHealth"));
						if (NPCGetFlags(bossIndex) & SFF_RANDOMATTACKS)
						{
							ArrayList arrayAttacks = new ArrayList();
							arrayAttacks.Clear();
							for (int attackIndex2 = 0; attackIndex2 < NPCChaserGetAttackCount(bossIndex); attackIndex2++)
							{
								if ((difficulty >= NPCChaserGetAttackUseOnDifficulty(bossIndex, attackIndex2) && difficulty < NPCChaserGetAttackBlockOnDifficulty(bossIndex, attackIndex2)) && 
								NPCChaserGetNextAttackTime(bossIndex, attackIndex2) <= GetGameTime())
								{
									arrayAttacks.Push(attackIndex2);
								}
								if (IsValidClient(target) && (NPCChaserGetAttackUseOnHealth(bossIndex, attackIndex2) != -1.0 && clientHealth < NPCChaserGetAttackUseOnHealth(bossIndex, attackIndex2)) ||
								(NPCChaserGetAttackBlockOnHealth(bossIndex, attackIndex2) != -1.0 && clientHealth >= NPCChaserGetAttackBlockOnHealth(bossIndex, attackIndex2)))
								{
									int eraseAttack = arrayAttacks.FindValue(attackIndex2);
									if (eraseAttack != -1)
									{
										arrayAttacks.Erase(eraseAttack);
									}
								}
							}
							if (arrayAttacks.Length > 0)
							{
								int randomAttackIndex = arrayAttacks.Get(GetRandomInt(0, arrayAttacks.Length - 1));
								attackBeginRangeEx = NPCChaserGetAttackBeginRange(bossIndex, randomAttackIndex);
								attackBeginFOVEx = NPCChaserGetAttackBeginFOV(bossIndex, randomAttackIndex);
								if (attackDist <= SquareFloat(attackBeginRangeEx) && fov <= (attackBeginFOVEx / 2.0) &&
								!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && 
								!g_NpcUseStartFleeAnimation[bossIndex] && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
								{
									state = STATE_ATTACK;
									NPCSetCurrentAttackIndex(bossIndex, randomAttackIndex);
								}
							}
							delete arrayAttacks;
						}
						else
						{
							for (int attackIndex = 0; attackIndex < NPCChaserGetAttackCount(bossIndex); attackIndex++)
							{
								attackBeginRangeEx = NPCChaserGetAttackBeginRange(bossIndex, attackIndex);
								attackBeginFOVEx = NPCChaserGetAttackBeginFOV(bossIndex, attackIndex);
								if (attackDist <= SquareFloat(attackBeginRangeEx) && ((!building && fov <= (attackBeginFOVEx / 2.0)) || (building && fov > (attackBeginFOVEx / 2.0))) && NPCChaserGetNextAttackTime(bossIndex, attackIndex) <= GetGameTime() && 
								!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex] && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex]
								&& (difficulty >= NPCChaserGetAttackUseOnDifficulty(bossIndex, attackIndex) && difficulty < NPCChaserGetAttackBlockOnDifficulty(bossIndex, attackIndex)))
								{
									// ENOUGH TALK! HAVE AT YOU!
									state = STATE_ATTACK;
									NPCSetCurrentAttackIndex(bossIndex, attackIndex);
									break;
								}
							}
						}
					}
					if (state == STATE_CHASE)
					{
						for (int attackIndex = 0; attackIndex < NPCChaserGetAttackCount(bossIndex); attackIndex++)
						{
							if (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam)
							{
								continue;
							}
							
							bool blockingProp = false;
							
							if (NPCGetFlags(bossIndex) & SFF_ATTACKPROPS)
							{
								blockingProp = NPC_CanAttackProps(bossIndex, NPCChaserGetAttackRange(bossIndex, attackIndex), NPCChaserGetAttackSpread(bossIndex, attackIndex));
							}
							
							if (blockingProp)
							{
								state = STATE_ATTACK;
								NPCSetCurrentAttackIndex(bossIndex, attackIndex);
								break;
							}
						}
					}
				}
				if (!IsValidEntity(target) || (!building && !IsTargetValidForSlender(target)) && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
				{
					g_SlenderGiveUp[bossIndex] = true;
					// Even if the target isn't valid anymore, see if I still have some ways to go on my current path,
					// because I shouldn't actually know that the target has died until I see it.
					if (!g_BossPathFollower[bossIndex].IsValid())
					{
						state = STATE_IDLE;
						g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
					}
				}
			}
			else if (state == STATE_ATTACK)
			{
				if (!g_IsSlenderAttacking[bossIndex] || (g_SlenderTimeUntilAttackEnd[bossIndex] != -1.0 && g_SlenderTimeUntilAttackEnd[bossIndex] <= GetGameTime()))
				{
					if (g_LastStuckTime[bossIndex] != 0.0)
					{
						g_LastStuckTime[bossIndex] = GetGameTime();
					}
					loco.ClearStuckStatus();
					g_SlenderTimeUntilAttackEnd[bossIndex] = -1.0;
					if (IsValidClient(target))
					{
						g_SlenderChaseDeathPositionBool[bossIndex] = false;
						
						// Chase him again!
						g_SlenderGiveUp[bossIndex] = false;
						g_IsSlenderAttacking[bossIndex] = false;
						g_NpcStealingLife[bossIndex] = false;
						g_SlenderAttackTimer[bossIndex] = null;
						g_NpcLifeStealTimer[bossIndex] = null;
						g_SlenderBackupAtkTimer[bossIndex] = null;
						g_NpcAlreadyAttacked[bossIndex] = false;
						g_NpcUseFireAnimation[bossIndex] = false;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
						state = STATE_CHASE;
						GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
					}
					else
					{
						// Target isn't valid anymore. We killed him, Mac!
						state = STATE_ALERT;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
						g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
						g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
						g_IsSlenderAttacking[bossIndex] = false;
						g_NpcStealingLife[bossIndex] = false;
						g_SlenderAttackTimer[bossIndex] = null;
						g_NpcLifeStealTimer[bossIndex] = null;
						g_SlenderBackupAtkTimer[bossIndex] = null;
						g_NpcAlreadyAttacked[bossIndex] = false;
						g_NpcUseFireAnimation[bossIndex] = false;
						if (NPCHasAttribute(bossIndex, "chase target on scare"))
						{
							g_NpcLostChasingScareVictim[bossIndex] = true;
							g_NpcChasingScareVictin[bossIndex] = false;
						}
						if (NPCHasAttribute(bossIndex, "alert copies") || NPCHasAttribute(bossIndex, "alert companions"))
						{
							g_NpcCopyAlerted[bossIndex] = false;
						}
					}
				}
			}
			else if (state == STATE_STUN)
			{
				if (GetGameTime() >= g_SlenderTimeUntilRecover[bossIndex])
				{
					if (NPCChaserCanDisappearOnStun(bossIndex))
					{
						RemoveSlender(bossIndex);
					}
					loco.ClearStuckStatus();
					if (NPCHasAttribute(bossIndex, "add stun health on stun"))
					{
						float value = NPCGetAttributeValue(bossIndex, "add stun health on stun");
						NPCChaserSetStunHealth(bossIndex, NPCChaserGetStunInitialHealth(bossIndex));
						NPCChaserSetAddStunHealth(bossIndex, value);
						if (value > 0.0)
						{
							NPCChaserAddStunHealth(bossIndex, NPCChaserGetAddStunHealth(bossIndex));
						}
					}
					else
					{
						NPCChaserSetStunHealth(bossIndex, NPCChaserGetStunInitialHealth(bossIndex));
					}
					if (NPCHasAttribute(bossIndex, "add speed on stun"))
					{
						float value = NPCGetAttributeValue(bossIndex, "add speed on stun");
						if (value > 0.0)
						{
							NPCSetAddSpeed(bossIndex, value);
						}
					}
					if (NPCHasAttribute(bossIndex, "add max speed on stun"))
					{
						float value = NPCGetAttributeValue(bossIndex, "add max speed on stun");
						if (value > 0.0)
						{
							NPCSetAddMaxSpeed(bossIndex, value);
						}
					}
					if (NPCHasAttribute(bossIndex, "add acceleration on stun"))
					{
						float value = NPCGetAttributeValue(bossIndex, "add acceleration on stun");
						if (value > 0.0)
						{
							NPCSetAddAcceleration(bossIndex, value);
						}
					}
					g_SlenderNextStunTime[bossIndex] = GetGameTime() + NPCChaserGetStunCooldown(bossIndex);
					if (IsValidClient(target))
					{
						// Chase him again!
						state = STATE_CHASE;
						GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
					}
					else
					{
						// WHAT DA FUUUUUUUUUUUQ. TARGET ISN'T VALID. AUSDHASUIHD
						state = STATE_ALERT;
						if (g_SlenderChaseInitialTimer[bossIndex] != null)
						{
							TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
						}
						g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
						g_NpcAutoChaseSprinterCooldown[bossIndex] = GetGameTime() + 5.0;
						if (NPCHasAttribute(bossIndex, "chase target on scare"))
						{
							g_NpcLostChasingScareVictim[bossIndex] = true;
							g_NpcChasingScareVictin[bossIndex] = false;
						}
						if (NPCHasAttribute(bossIndex, "alert copies") || NPCHasAttribute(bossIndex, "alert companions"))
						{
							g_NpcCopyAlerted[bossIndex] = false;
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
			if (NPCChaserGetStunHealth(bossIndex) <= 0 && g_SlenderNextStunTime[bossIndex] <= GetGameTime())
			{
				state = STATE_STUN;
				if (g_SlenderChaseInitialTimer[bossIndex] != null)
				{
					TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
				}
			}
			if (SF_IsBoxingMap() && NPCChaserIsBoxingBoss(bossIndex))
			{
				if (!NPCChaserGetSelfHealState(bossIndex))
				{
					float percent = NPCChaserGetStunInitialHealth(bossIndex) > 0 ? (NPCChaserGetStunHealth(bossIndex) / NPCChaserGetStunInitialHealth(bossIndex)) : 0.0;
					if (percent < 0.75 && percent >= 0.5 && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsedRage1[bossIndex])
					{
						if (difficulty != 2 && difficulty < 2)
						{
							NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
									EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								}
							}
						}
						NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
						SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						NPCSetAddSpeed(bossIndex, 12.5);
						NPCSetAddMaxSpeed(bossIndex, 25.0);
						NPCSetAddAcceleration(bossIndex, 100.0);

						g_NpcUsedRage1[bossIndex] = true;
						g_NpcUsesRageAnimation1[bossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(bossIndex, slender, state);
						g_SlenderRage1Timer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "rage_timer", 0.0), Timer_SlenderRageOneTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[bossIndex])
						{
							// Cancel attacking.
							g_IsSlenderAttacking[bossIndex] = false;
							g_NpcStealingLife[bossIndex] = false;
							g_SlenderAttackTimer[bossIndex] = null;
							g_NpcLifeStealTimer[bossIndex] = null;
							g_SlenderBackupAtkTimer[bossIndex] = null;
							g_NpcAlreadyAttacked[bossIndex] = false;
							g_NpcUseFireAnimation[bossIndex] = false;
						}
					}
					else if (percent < 0.5 && percent >= 0.25 && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsedRage2[bossIndex])
					{
						if (difficulty != 3 && difficulty < 3)
						{
							NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int buff = GetRandomInt(1, 3);
									switch (buff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
									}
								}
							}
						}
						NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
						char rageSound2Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(slenderProfile, "sound_rage_2", rageSound2Path, sizeof(rageSound2Path));
						if (rageSound2Path[0] != '\0')
						{
							SlenderPerformVoice(bossIndex, "sound_rage_2", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						else
						{
							SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						NPCSetAddSpeed(bossIndex, 12.5);
						NPCSetAddMaxSpeed(bossIndex, 25.0);
						NPCSetAddAcceleration(bossIndex, 100.0);

						g_NpcUsedRage2[bossIndex] = true;
						g_NpcUsesRageAnimation2[bossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(bossIndex, slender, state);
						g_SlenderRage2Timer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "rage_timer", 0.0), Timer_SlenderRageTwoTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[bossIndex])
						{
							// Cancel attacking.
							g_IsSlenderAttacking[bossIndex] = false;
							g_NpcStealingLife[bossIndex] = false;
							g_SlenderAttackTimer[bossIndex] = null;
							g_NpcLifeStealTimer[bossIndex] = null;
							g_SlenderBackupAtkTimer[bossIndex] = null;
							g_NpcAlreadyAttacked[bossIndex] = false;
							g_NpcUseFireAnimation[bossIndex] = false;
						}
					}
					else if (percent < 0.25 && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcHasUsedRage3[bossIndex])
					{
						if (difficulty != 4 && difficulty < 4)
						{
							NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int buff = GetRandomInt(1, 4);
									switch (buff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(slenderProfile, "rage_timer", 0.0));
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
						NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
						char rageSound3Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(slenderProfile, "sound_rage_3", rageSound3Path, sizeof(rageSound3Path));
						if (rageSound3Path[0] != '\0')
						{
							SlenderPerformVoice(bossIndex, "sound_rage_3", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						else
						{
							SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						NPCSetAddSpeed(bossIndex, 12.5);
						NPCSetAddMaxSpeed(bossIndex, 25.0);
						NPCSetAddAcceleration(bossIndex, 100.0);

						g_NpcHasUsedRage3[bossIndex] = true;
						g_NpcUsesRageAnimation3[bossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(bossIndex, slender, state);
						g_SlenderRage3Timer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "rage_timer", 0.0), Timer_SlenderRageThreeTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_IsSlenderAttacking[bossIndex])
						{
							// Cancel attacking.
							g_IsSlenderAttacking[bossIndex] = false;
							g_NpcStealingLife[bossIndex] = false;
							g_SlenderAttackTimer[bossIndex] = null;
							g_NpcLifeStealTimer[bossIndex] = null;
							g_SlenderBackupAtkTimer[bossIndex] = null;
							g_NpcAlreadyAttacked[bossIndex] = false;
							g_NpcUseFireAnimation[bossIndex] = false;
						}
					}
				}
				else
				{
					float percent = NPCChaserGetStunInitialHealth(bossIndex) > 0 ? (NPCChaserGetStunHealth(bossIndex) / NPCChaserGetStunInitialHealth(bossIndex)) : 0.0;
					if (percent < NPCChaserGetStartSelfHealPercentage(bossIndex) && g_NpcSelfHealStage[bossIndex] < 3)
					{
						if (g_NpcIsRunningToHeal[bossIndex] || g_NpcIsHealing[bossIndex])
						{
							oldTarget = target;
							target = INVALID_ENT_REFERENCE;
							g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
						}
						float delayTimer1 = GetProfileFloat(slenderProfile, "flee_delay_time", 0.0);
						float delayTimer2 = GetProfileFloat(slenderProfile, "flee_delay_time_two", delayTimer1);
						float delayTimer3 = GetProfileFloat(slenderProfile, "flee_delay_time_three", delayTimer2);
						if (g_NpcIsRunningToHeal[bossIndex] && !g_NpcSetHealDestination[bossIndex] && !g_NpcIsHealing[bossIndex])
						{
							float min = GetProfileFloat(slenderProfile, "heal_time_min", 3.0);
							float max = GetProfileFloat(slenderProfile, "heal_time_max", 4.5);
							g_NpcFleeHealTimer[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
							
							// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
							// If the position can't be reached, then just get to the closest area that we can get.
							float wanderRangeMin = GetProfileFloat(slenderProfile, "heal_range_min", 600.0);
							float wanderRangeMax = GetProfileFloat(slenderProfile, "heal_range_max", 1200.0);
							float wanderRange = GetRandomFloat(wanderRangeMin, wanderRangeMax);
							
							float fleePos[3];
							fleePos[0] = 0.0;
							fleePos[1] = GetRandomFloat(0.0, 360.0);
							fleePos[2] = 0.0;
							
							GetAngleVectors(fleePos, fleePos, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(fleePos, fleePos);
							ScaleVector(fleePos, wanderRange);
							AddVectors(fleePos, myPos, fleePos);
							
							g_SlenderGoalPos[bossIndex][0] = fleePos[0];
							g_SlenderGoalPos[bossIndex][1] = fleePos[1];
							g_SlenderGoalPos[bossIndex][2] = fleePos[2];
							
							if (!g_NpcHasCloaked[bossIndex] && !g_NpcUsesChaseInitialAnimation[bossIndex] && NPCChaserIsCloakEnabled(bossIndex) && NPCChaserCanCloakToHeal(bossIndex))
							{
								//Time for a more cloaking aproach!
								SetEntityRenderMode(slender, view_as<RenderMode>(GetProfileNum(slenderProfile, "cloak_rendermode", 1)));
							
								int cloakColor[4];
								GetProfileColor(slenderProfile, "cloak_rendercolor", cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3], 
								g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);

								SetEntityRenderColor(slender, cloakColor[0], cloakColor[1], cloakColor[2], cloakColor[3]);
								g_NpcHasCloaked[bossIndex] = true;
								g_NpcNextDecloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakDuration(bossIndex, difficulty);
								SlenderToggleParticleEffects(slender);
								GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
								if (cloakParticle[0] == '\0')
								{
									cloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
								EmitSoundToAll(g_SlenderCloakOnSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								Call_StartForward(g_OnBossCloakedFwd);
								Call_PushCell(bossIndex);
								Call_Finish();
							}
							
							g_NpcSetHealDestination[bossIndex] = true;
						}
						if (!g_BossPathFollower[bossIndex].IsValid())
						{
							g_NpcSetHealDestination[bossIndex] = false;
						}
						if ((GetVectorSquareMagnitude(g_SlenderGoalPos[bossIndex], myPos) < SquareFloat(125.0) || g_NpcFleeHealTimer[bossIndex] < GetGameTime()) && g_NpcSetHealDestination[bossIndex] && !g_NpcIsHealing[bossIndex])
						{
							if (g_NpcHasCloaked[bossIndex] && NPCChaserIsCloakEnabled(bossIndex))
							{
								SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
								SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
								
								g_NpcHasCloaked[bossIndex] = false;
								SlenderToggleParticleEffects(slender, true);
								GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
								if (cloakParticle[0] == '\0')
								{
									cloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
								EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
								Call_StartForward(g_OnBossDecloakedFwd);
								Call_PushCell(bossIndex);
								Call_Finish();
							}
							float timerFloat = GetProfileFloat(slenderProfile, "heal_timer_animation", 0.0);
							g_NpcHealCount[bossIndex] = 0;
							g_NpcUsesHealAnimation[bossIndex] = true;
							g_NpcIsRunningToHeal[bossIndex] = false;
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
							g_SlenderHealTimer[bossIndex] = CreateTimer(timerFloat, Timer_SlenderHealAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_SlenderHealDelayTimer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "heal_timer", timerFloat), Timer_SlenderHealDelayTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_NpcIsHealing[bossIndex] = true;
							NPCChaserUpdateBossAnimation(bossIndex, slender, state);
						}
						if (!g_NpcUseStartFleeAnimation[bossIndex] && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
						{
							switch (g_NpcSelfHealStage[bossIndex])
							{
								case 0:
								{
									if (difficulty != 2 && difficulty < 2)
									{
										NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer1);
												EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											}
										}
									}
									NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[bossIndex] = CreateTimer(delayTimer1, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[bossIndex] = 0;
									SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									NPCSetAddSpeed(bossIndex, 12.5);
									NPCSetAddMaxSpeed(bossIndex, 25.0);
									NPCSetAddAcceleration(bossIndex, 100.0);

									g_NpcUseStartFleeAnimation[bossIndex] = true;
									NPCChaserUpdateBossAnimation(bossIndex, slender, state);
								}
								case 1:
								{
									if (difficulty != 3 && difficulty < 3)
									{
										NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int buff = GetRandomInt(1, 3);
												switch (buff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer2);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
												}
											}
										}
									}
									NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[bossIndex] = CreateTimer(delayTimer2, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[bossIndex] = 0;
									char rageSound2Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(slenderProfile, "sound_rage_2", rageSound2Path, sizeof(rageSound2Path));
									if (rageSound2Path[0] != '\0')
									{
										SlenderPerformVoice(bossIndex, "sound_rage_2", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									}
									else
									{
										SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									}
									NPCSetAddSpeed(bossIndex, 12.5);
									NPCSetAddMaxSpeed(bossIndex, 25.0);
									NPCSetAddAcceleration(bossIndex, 100.0);

									g_NpcUseStartFleeAnimation[bossIndex] = true;
									NPCChaserUpdateBossAnimation(bossIndex, slender, state);
								}
								case 2:
								{
									if (difficulty != 4 && difficulty < 4)
									{
										NPCChaserSetBoxingDifficulty(bossIndex, NPCChaserGetBoxingDifficulty(bossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_PlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int buff = GetRandomInt(1, 4);
												switch (buff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer3);
														EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer3);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(slenderProfile, "heal_time_max", 4.5) + delayTimer3);
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
									NPCChaserSetBoxingRagePhase(bossIndex, NPCChaserGetBoxingRagePhase(bossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_SlenderStartFleeTimer[bossIndex] = CreateTimer(delayTimer3, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_NpcHealCount[bossIndex] = 0;
									char rageSound3Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(slenderProfile, "sound_rage_3", rageSound3Path, sizeof(rageSound3Path));
									if (rageSound3Path[0] != '\0')
									{
										SlenderPerformVoice(bossIndex, "sound_rage_3", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									}
									else
									{
										SlenderPerformVoice(bossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									}
									NPCSetAddSpeed(bossIndex, 12.5);
									NPCSetAddMaxSpeed(bossIndex, 25.0);
									NPCSetAddAcceleration(bossIndex, 100.0);
									
									g_NpcUseStartFleeAnimation[bossIndex] = true;
									NPCChaserUpdateBossAnimation(bossIndex, slender, state);
								}
							}
						}
						if (g_IsSlenderAttacking[bossIndex])
						{
							// Cancel attacking.
							g_IsSlenderAttacking[bossIndex] = false;
							g_NpcStealingLife[bossIndex] = false;
							g_SlenderAttackTimer[bossIndex] = null;
							g_NpcLifeStealTimer[bossIndex] = null;
							g_SlenderBackupAtkTimer[bossIndex] = null;
							g_NpcAlreadyAttacked[bossIndex] = false;
							g_NpcUseFireAnimation[bossIndex] = false;
						}
					}
				}
			}
		}
	}
	
	if (!IsValidClient(target) && g_SlenderTeleportTargetIsCamping[bossIndex] && g_SlenderTeleportTarget[bossIndex] != INVALID_ENT_REFERENCE) //We spawned, and our target is a camper kill him!
	{
		int campingTarget = EntRefToEntIndex(g_SlenderTeleportTarget[bossIndex]);
		if (MaxClients >= campingTarget > 0 && IsTargetValidForSlender(campingTarget))
		{
			g_SlenderTarget[bossIndex] = EntIndexToEntRef(campingTarget);
			state = STATE_CHASE;
			GetClientAbsOrigin(campingTarget, g_SlenderGoalPos[bossIndex]);
		}
		g_SlenderTeleportTargetIsCamping[bossIndex] = false;
	}

	if (NPCChaserCanChaseOnLook(bossIndex) && g_NpcChaseOnLookTarget[bossIndex].Length > 0 && IsValidClient(target) && state != STATE_ATTACK && state != STATE_STUN)
	{
		g_SlenderIsAutoChasingLoudPlayer[bossIndex] = true;
		g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
	}
	if ((SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_BossesChaseEndlessly() || g_NpcChasesEndlessly[bossIndex] || SF_IsSlaughterRunMap()) && state != STATE_ATTACK && state != STATE_STUN && IsValidClient(target) && !g_SlenderGiveUp[bossIndex])
	{
		g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
	}
	if ((SF_IsRaidMap() || SF_IsBoxingMap()) && (g_NpcIsRunningToHeal[bossIndex] || g_NpcIsHealing[bossIndex]))
	{
		g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		state = STATE_CHASE;
	}
	if (NPCHasAttribute(bossIndex, "chase target on scare") && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN && IsValidClient(target) && g_PlayerScaredByBoss[target][bossIndex] && !g_NpcChasingScareVictin[bossIndex] && !g_NpcLostChasingScareVictim[bossIndex])
	{
		g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_NpcChasingScareVictin[bossIndex] = true;
		g_PlayerScaredByBoss[target][bossIndex] = false;
		state = STATE_CHASE;
		GetClientAbsOrigin(target, g_SlenderGoalPos[bossIndex]);
	}
	if (IsValidClient(bestNewTarget) && (playerInTrap[bestNewTarget] || playerMadeNoise[bestNewTarget]) && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
	{
		g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
		target = bestNewTarget;
		g_SlenderTarget[bossIndex] = EntIndexToEntRef(target);
		state = STATE_CHASE;
		GetClientAbsOrigin(bestNewTarget, g_SlenderGoalPos[bossIndex]);
	}
	// Finally, set our new state.
	g_SlenderState[bossIndex] = state;
	
	if (oldState != state)
	{
		g_BossPathFollower[bossIndex].Invalidate();
		
		switch (state)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
				g_SlenderTimeUntilIdle[bossIndex] = 0.0;
				g_SlenderTimeUntilAlert[bossIndex] = 0.0;
				g_SlenderTimeUntilChase[bossIndex] = 0.0;
				g_SlenderChaseDeathPositionBool[bossIndex] = false;
				g_NpcLostChasingScareVictim[bossIndex] = false;
				g_NpcChasingScareVictin[bossIndex] = false;
				
				if (oldState != STATE_IDLE && oldState != STATE_WANDER)
				{
					g_SlenderTargetSoundCount[bossIndex] = 0;
					g_SlenderInvestigatingSound[bossIndex] = false;
					g_SlenderTargetSoundDiscardMasterPosTime[bossIndex] = -1.0;
					
					g_SlenderTimeUntilKill[bossIndex] = GetGameTime() + NPCGetIdleLifetime(bossIndex, difficulty);
				}
				
				if (g_NpcHasCloaked[bossIndex] && NPCChaserIsCloakEnabled(bossIndex))
				{
					SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
					SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
					g_NpcHasCloaked[bossIndex] = false;
					SlenderToggleParticleEffects(slender, true);
					GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
					if (cloakParticle[0] == '\0')
					{
						cloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
					EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
					Call_StartForward(g_OnBossDecloakedFwd);
					Call_PushCell(bossIndex);
					Call_Finish();
				}
				
				if (state == STATE_WANDER)
				{
					// Force new wander position.
					for (int difficulty3; difficulty3 < Difficulty_Max; difficulty3++)
					{
						g_SlenderNextWanderPos[bossIndex][difficulty3] = -1.0;
					}
				}
			}
			
			case STATE_ALERT:
			{
				g_SlenderGiveUp[bossIndex] = false;
				
				g_SlenderChaseDeathPositionBool[bossIndex] = false;
				
				// Set our goal position.
				if (g_SlenderInvestigatingSound[bossIndex])
				{
					g_SlenderGoalPos[bossIndex][0] = g_SlenderTargetSoundMasterPos[bossIndex][0];
					g_SlenderGoalPos[bossIndex][1] = g_SlenderTargetSoundMasterPos[bossIndex][1];
					g_SlenderGoalPos[bossIndex][2] = g_SlenderTargetSoundMasterPos[bossIndex][2];
				}
				
				g_SlenderTimeUntilIdle[bossIndex] = GetGameTime() + NPCChaserGetAlertDuration(bossIndex, difficulty);
				g_SlenderTimeUntilAlert[bossIndex] = -1.0;
				g_NpcLostChasingScareVictim[bossIndex] = false;
				g_SlenderTimeUntilChase[bossIndex] = GetGameTime() + NPCChaserGetAlertGracetime(bossIndex, difficulty);
				
				if (g_NpcHasCloaked[bossIndex] && NPCChaserIsCloakEnabled(bossIndex))
				{
					SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
					SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
					
					g_NpcHasCloaked[bossIndex] = false;
					SlenderToggleParticleEffects(slender, true);
					GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
					if (cloakParticle[0] == '\0')
					{
						cloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
					EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
					Call_StartForward(g_OnBossDecloakedFwd);
					Call_PushCell(bossIndex);
					Call_Finish();
				}
			}
			case STATE_CHASE, STATE_ATTACK:
			{
				g_SlenderInvestigatingSound[bossIndex] = false;
				g_SlenderTargetSoundCount[bossIndex] = 0;
				
				if (oldState != STATE_ATTACK && oldState != STATE_CHASE && oldState != STATE_STUN)
				{
					g_SlenderTimeUntilIdle[bossIndex] = -1.0;
					g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
					g_SlenderAutoChaseCount[bossIndex] = 0;
					g_SlenderTimeUntilChase[bossIndex] = -1.0;
					
					float persistencyTime = GetProfileFloat(slenderProfile, "search_chase_persistency_time_init", 5.0);
					if (persistencyTime >= 0.0)
					{
						g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + persistencyTime;
					}
				}
				
				if (state == STATE_ATTACK)
				{
					if (g_NpcUsesRageAnimation1[bossIndex] || g_NpcUsesRageAnimation2[bossIndex] || g_NpcUsesRageAnimation3[bossIndex])
					{
						state = oldState;
					}
					else
					{
						g_IsSlenderAttacking[bossIndex] = true;
						npcEntity.RemoveAllGestures();
						CBaseNPC_RemoveAllLayers(slender);
						loco.ClearStuckStatus();
						int attackIndex = NPCGetCurrentAttackIndex(bossIndex);
						if (!NPCChaserGetAttackWhileRunningState(bossIndex, attackIndex))
						{
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
						}
						if (NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_ExplosiveDance && NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_LaserBeam)
						{
							g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_NpcAlreadyAttacked[bossIndex] = false;
							NpcSetCurrentAttackRepeat(bossIndex, attackIndex, 0);
							NPCChaserSetNextAttackTime(bossIndex, attackIndex, GetGameTime() + NPCChaserGetAttackCooldown(bossIndex, attackIndex, difficulty));
						}
						else if (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_ExplosiveDance)
						{
							g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderPrepareExplosiveDance, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							NPCChaserSetNextAttackTime(bossIndex, attackIndex, GetGameTime() + NPCChaserGetAttackCooldown(bossIndex, attackIndex, difficulty));
						}
						else if (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam)
						{
							g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttackBeginLaser, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						}
						if (NPCChaserGetAttackLifeStealState(bossIndex, attackIndex))
						{
							if (!g_NpcStealingLife[bossIndex])
							{
								g_NpcLifeStealTimer[bossIndex] = CreateTimer(0.5, Timer_SlenderStealLife, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
								g_NpcStealingLife[bossIndex] = true;
							}
						}
						
						g_SlenderTimeUntilAttackEnd[bossIndex] = GetGameTime() + NPCChaserGetAttackDuration(bossIndex, attackIndex) + 0.01;
						
						g_NpcBaseAttackRunDurationTime[bossIndex][attackIndex] = GetGameTime() + NPCChaserGetAttackRunDuration(bossIndex, attackIndex);
						
						g_NpcBaseAttackRunDelayTime[bossIndex][attackIndex] = GetGameTime() + NPCChaserGetAttackRunDelay(bossIndex, attackIndex);
						
						float persistencyTime = GetProfileFloat(slenderProfile, "search_chase_persistency_time_init_attack", -1.0);
						if (persistencyTime >= 0.0)
						{
							g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + persistencyTime;
						}
						
						persistencyTime = GetProfileFloat(slenderProfile, "search_chase_persistency_time_add_attack", 2.0);
						if (persistencyTime >= 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[bossIndex] < GetGameTime()) g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime();
							g_SlenderTimeUntilNoPersistence[bossIndex] += persistencyTime;
						}
						
						if (g_NpcHasCloaked[bossIndex] && NPCChaserIsCloakEnabled(bossIndex))
						{
							SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
							SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], 0);
							g_NpcHasCloaked[bossIndex] = false;
							SlenderToggleParticleEffects(slender, true);
							GetProfileString(slenderProfile, "cloak_particle", cloakParticle, sizeof(cloakParticle));
							if (cloakParticle[0] == '\0')
							{
								cloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(bossIndex, cloakParticle, 35.0);
							EmitSoundToAll(g_SlenderCloakOffSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_SlenderNextCloakTime[bossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(bossIndex, difficulty);
							Call_StartForward(g_OnBossDecloakedFwd);
							Call_PushCell(bossIndex);
							Call_Finish();
						}
						if (!NPCChaserHasMultiAttackSounds(bossIndex))
						{
							SlenderPerformVoice(bossIndex, "sound_attackenemy", attackIndex + 1, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						else
						{
							char attackString[PLATFORM_MAX_PATH];
							FormatEx(attackString, sizeof(attackString), "sound_attackenemy_%i", attackIndex+1);
							switch (attackIndex)
							{
								case 0:
								{
									SlenderPerformVoice(bossIndex, "sound_attackenemy", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
								}
								default:
								{
									SlenderPerformVoice(bossIndex, attackString, _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
								}
							}
						}
						if (g_LastStuckTime[bossIndex] != 0.0)
						{
							g_LastStuckTime[bossIndex] = GetGameTime();
						}
						loco.ClearStuckStatus();
					}
				}
				else
				{
					if (oldState != STATE_ATTACK && !building)
					{
						// Sound handling.
						if (!NPCChaserCanChaseInitialOnStun(bossIndex))
						{
							if (oldState != STATE_STUN)
							{
								SlenderPerformVoice(bossIndex, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
								if (NPCChaserCanUseChaseInitialAnimation(bossIndex) && !g_NpcUsesChaseInitialAnimation[bossIndex] && !SF_IsSlaughterRunMap())
								{
									if (g_SlenderChaseInitialTimer[bossIndex] == null && g_NpcChaseOnLookTarget[bossIndex].Length <= 0)
									{
										g_NpcUsesChaseInitialAnimation[bossIndex] = true;
										npc.flWalkSpeed = 0.0;
										npc.flRunSpeed = 0.0;
										NPCChaserUpdateBossAnimation(bossIndex, slender, state);
										g_SlenderChaseInitialTimer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									}
								}
							}
						}
						else
						{
							SlenderPerformVoice(bossIndex, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
							if (NPCChaserCanUseChaseInitialAnimation(bossIndex) && !g_NpcUsesChaseInitialAnimation[bossIndex] && !SF_IsSlaughterRunMap())
							{
								if (g_SlenderChaseInitialTimer[bossIndex] == null && g_NpcChaseOnLookTarget[bossIndex].Length <= 0)
								{
									g_NpcUsesChaseInitialAnimation[bossIndex] = true;
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									NPCChaserUpdateBossAnimation(bossIndex, slender, state);
									g_SlenderChaseInitialTimer[bossIndex] = CreateTimer(GetProfileFloat(slenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				}
			}
		}
		NPCChaserSetState(bossIndex, state);
		// Call our forward.
		Call_StartForward(g_OnBossChangeStateFwd);
		Call_PushCell(bossIndex);
		Call_PushCell(oldState);
		Call_PushCell(state);
		Call_Finish();
		/*if (NPCChaserNormalSoundHookEnabled(bossIndex))
		{
			switch (oldState)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					if (state != STATE_IDLE && state != STATE_WANDER) ClientStopAllSlenderSounds(slender, slenderProfile, "sound_idle", SNDCHAN_AUTO);
				}
				case STATE_ALERT: ClientStopAllSlenderSounds(slender, slenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
				case STATE_CHASE:
				{
					ClientStopAllSlenderSounds(slender, slenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
					ClientStopAllSlenderSounds(slender, slenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
				}
			}
			switch (state)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					if (oldState != STATE_IDLE && oldState != STATE_WANDER) SlenderPerformVoice(bossIndex, "sound_idle", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
				}
				case STATE_ALERT: SlenderPerformVoice(bossIndex, "sound_alertofenemy", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
				case STATE_CHASE:
				{
					char sChaseSoundPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, "sound_chaseenemyinitial", sChaseSoundPath, sizeof(sChaseSoundPath));
					if (sChaseSoundPath[0] == '\0' && !g_NpcUsesChaseInitialAnimation[bossIndex])
					{
						SlenderPerformVoice(bossIndex, "sound_chasingenemy", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
					}
				}
			}
		}*/
		if (NPCChaserNormalSoundHookEnabled(bossIndex) && state != STATE_WANDER && oldState != STATE_IDLE && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
		{
			g_SlenderNextVoiceSound[bossIndex] = 0.0;
		}
	}
	
	if (oldState != state && !g_SlenderSpawning[bossIndex])
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
	}

	if (g_NpcChangeToCrawl[bossIndex] && (state == STATE_CHASE || state == STATE_WANDER || state == STATE_ALERT))
	{
		NPCChaserUpdateBossAnimation(bossIndex, slender, state);
		g_NpcChangeToCrawl[bossIndex] = false;
	}
	
	if (NPCChaserOldAnimationAIEnabled(bossIndex))
	{
		float slenderVelocity, returnFloat;
		slenderVelocity = loco.GetGroundSpeed();
		returnFloat = slenderVelocity / GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed");
		if (GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed") != 0.0 && GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed") > 10.0)
		{
			if (loco.IsOnGround())
			{
				if (state == STATE_WANDER && (NPCGetFlags(bossIndex) & SFF_WANDERMOVE) || state == STATE_ALERT)
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
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
				if (state == STATE_CHASE && !g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
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
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
			}
		}
		else
		{
			float slenderVelocityOld;
			float velocity, walkVelocity, generalVel;
			slenderVelocityOld = loco.GetGroundSpeed();
			generalVel = slenderVelocityOld;
			if (g_SlenderCalculatedSpeed[bossIndex] <= 0.0)
			{
				velocity = 0.0;
			}
			else
			{
				velocity = (generalVel + ((g_SlenderCalculatedSpeed[bossIndex] * g_RoundDifficultyModifier)/15))/g_SlenderCalculatedSpeed[bossIndex];
			}
			
			if (g_SlenderCalculatedWalkSpeed[bossIndex] <= 0.0)
			{
				walkVelocity = 0.0;
			}
			else
			{
				walkVelocity = (generalVel + ((g_SlenderCalculatedWalkSpeed[bossIndex] * g_RoundDifficultyModifier)/15))/g_SlenderCalculatedWalkSpeed[bossIndex];
			}
			if (loco.IsOnGround())
			{
				if (state == STATE_WANDER && (NPCGetFlags(bossIndex) & SFF_WANDERMOVE) || state == STATE_ALERT)
				{
					float playbackSpeed = walkVelocity * g_NpcCurrentAnimationSequencePlaybackRate[bossIndex];
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", playbackSpeed);
				}
				if (state == STATE_CHASE && !g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
				{
					float playbackSpeed = velocity * g_NpcCurrentAnimationSequencePlaybackRate[bossIndex];
					if (playbackSpeed > 12.0)
					{
						playbackSpeed = 12.0;
					}
					if (playbackSpeed < -4.0)
					{
						playbackSpeed = -4.0;
					}
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", playbackSpeed);
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
				if (GetGameTime() >= g_SlenderNextWanderPos[bossIndex][difficulty])
				{
					float min = GetChaserProfileWanderTimeMin(NPCGetUniqueProfileIndex(bossIndex), difficulty);
					float max = GetChaserProfileWanderTimeMax(NPCGetUniqueProfileIndex(bossIndex), difficulty);
					g_SlenderNextWanderPos[bossIndex][difficulty] = GetGameTime() + GetRandomFloat(min, max);
					
					if (NPCGetFlags(bossIndex) & SFF_WANDERMOVE)
					{
						// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
						// If the position can't be reached, then just get to the closest area that we can get.
						float wanderRangeMin = NPCChaserGetWanderRangeMin(bossIndex, difficulty);
						float wanderRangeMax = NPCChaserGetWanderRangeMax(bossIndex, difficulty);
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

						g_SlenderGoalPos[bossIndex][0] = wanderPos[0];
						g_SlenderGoalPos[bossIndex][1] = wanderPos[1];
						g_SlenderGoalPos[bossIndex][2] = wanderPos[2];
						
						g_SlenderNextPathTime[bossIndex] = -1.0; // We're not going to wander around too much, so no need for a time constraint.
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
							if (GetGameTime() >= g_SlenderNextPathTime[bossIndex])
							{
								GetEntPropVector(bestNewTarget, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[bossIndex]);
								g_SlenderNextPathTime[bossIndex] = GetGameTime() + 0.4;
							}
						}
					}
				}
			}
			else if ((state == STATE_CHASE || state == STATE_ATTACK) && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
			{
				if (IsValidEntity(bestNewTarget))
				{
					oldTarget = target;
					target = bestNewTarget;
					g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestNewTarget);
				}
				
				if (target != INVALID_ENT_REFERENCE)
				{
					if (oldTarget != target)
					{
						// Brand new target! We need a path, and we need to reset our persistency, if needed.
						float persistencyTime = GetProfileFloat(slenderProfile, "search_chase_persistency_time_init_newtarget", -1.0);
						if (persistencyTime >= 0.0)
						{
							g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + persistencyTime;
						}
						
						persistencyTime = GetProfileFloat(slenderProfile, "search_chase_persistency_time_add_newtarget", 2.0);
						if (persistencyTime >= 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[bossIndex] < GetGameTime())
							{
								g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime();
							}
							g_SlenderTimeUntilNoPersistence[bossIndex] += persistencyTime;
						}
						
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[bossIndex]);
					}
					else if ((building) || ((playerInFOV[target] && playerVisible[target]) || GetGameTime() < g_SlenderTimeUntilNoPersistence[bossIndex]))
					{
						// Constantly update my path if I see him or if I'm still being persistent.
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[bossIndex]);
					}
				}
				if (NPCChaserGetTeleporter(bossIndex, 0) != INVALID_ENT_REFERENCE)
				{
					int teleporter = EntRefToEntIndex(NPCChaserGetTeleporter(bossIndex, 0));
					if (IsValidEntity(teleporter) && teleporter > MaxClients)
					{
						GetEntPropVector(teleporter, Prop_Data, "m_vecAbsOrigin", g_SlenderGoalPos[bossIndex]);
					}
				}
			}
			if ((!g_SlenderInDeathcam[bossIndex] && (state == STATE_WANDER && (NPCGetFlags(bossIndex) & SFF_WANDERMOVE) && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0)
				 || (state == STATE_ALERT && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0)
				 || (state == STATE_CHASE && g_SlenderCalculatedSpeed[bossIndex] > 0.0)
				 || (state == STATE_ATTACK)))
			{
				g_BossPathFollower[bossIndex].ComputeToPos(bot, g_SlenderGoalPos[bossIndex]);
			}
			if (state == STATE_CHASE || state == STATE_ATTACK)
			{
				if (IsValidClient(target))
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(target, DEBUG_BOSS_CHASE, 1, "g_SlenderTimeUntilAlert[%d]: %f\ng_SlenderTimeUntilNoPersistence[%d]: %f", bossIndex, g_SlenderTimeUntilAlert[bossIndex] - GetGameTime(), bossIndex, g_SlenderTimeUntilNoPersistence[bossIndex] - GetGameTime());
					#endif
					
					if ((building || (playerInFOV[target] && playerVisible[target])) && !g_NpcUsesChaseInitialAnimation[bossIndex])
					{
						float distRatio = (playerDists[target] / SquareFloat(NPCGetSearchRadius(bossIndex, difficulty)));
						
						float chaseDurationTimeAddMin = GetProfileFloat(slenderProfile, "search_chase_duration_add_visible_min", 0.025);
						float chaseDurationTimeAddMax = GetProfileFloat(slenderProfile, "search_chase_duration_add_visible_max", 0.2);
						
						float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * distRatio);
						
						if (chaseDurationAdd > 0.0)
						{
							g_SlenderTimeUntilAlert[bossIndex] += chaseDurationAdd;
							if (g_SlenderTimeUntilAlert[bossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty)))
							{
								g_SlenderTimeUntilAlert[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
							}
						}
						
						float persistencyTimeAddMin = GetProfileFloat(slenderProfile, "search_chase_persistency_time_add_visible_min", 0.05);
						float persistencyTimeAddMax = GetProfileFloat(slenderProfile, "search_chase_persistency_time_add_visible_max", 0.15);
						
						float persistencyTimeAdd = persistencyTimeAddMax - ((persistencyTimeAddMax - persistencyTimeAddMin) * distRatio);
						
						if (persistencyTimeAdd > 0.0)
						{
							if (g_SlenderTimeUntilNoPersistence[bossIndex] < GetGameTime())
							{
								g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime();
							}
							
							g_SlenderTimeUntilNoPersistence[bossIndex] += persistencyTimeAdd;
							if (g_SlenderTimeUntilNoPersistence[bossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty)))
							{
								g_SlenderTimeUntilNoPersistence[bossIndex] = GetGameTime() + NPCChaserGetChaseDuration(bossIndex, difficulty);
							}
						}
					}
				}
			}
		}
	}

	// Sound handling.
	if (GetGameTime() >= g_SlenderNextVoiceSound[bossIndex])
	{
		switch (state)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				SlenderPerformVoice(bossIndex, "sound_idle", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
			}
			case STATE_ALERT:
			{
				SlenderPerformVoice(bossIndex, "sound_alertofenemy", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
			}
			case STATE_CHASE:
			{
				if (!g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex] && !g_NpcUsesChaseInitialAnimation[bossIndex])
				{
					SlenderPerformVoice(bossIndex, "sound_chasingenemy", _, NPCChaserNormalSoundHookEnabled(bossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
				}
			}
		}
	}
	
	//Footstep handling.
	switch (state)
	{
		case STATE_IDLE:
		{
			if (GetGameTime() >= g_SlenderNextFootstepIdleSound[bossIndex])
			{
				SlenderCastFootstep(bossIndex, "sound_footsteps");
			}
		}
		case STATE_WANDER, STATE_ALERT:
		{
			if (GetGameTime() >= g_SlenderNextFootstepWalkSound[bossIndex])
			{
				SlenderCastFootstep(bossIndex, "sound_footsteps");
			}
		}
		case STATE_CHASE:
		{
			if (GetGameTime() >= g_SlenderNextFootstepRunSound[bossIndex] && !g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] && !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
			{
				SlenderCastFootstep(bossIndex, "sound_footsteps");
			}
		}
		case STATE_STUN:
		{
			if (GetGameTime() >= g_SlenderNextFootstepStunSound[bossIndex])
			{
				SlenderCastFootstep(bossIndex, "sound_footsteps");
			}
		}
		case STATE_ATTACK:
		{
			if (GetGameTime() >= g_SlenderNextFootstepAttackSound[bossIndex])
			{
				SlenderCastFootstep(bossIndex, "sound_footsteps");
			}
		}
	}
	
	// Reset our interrupt conditions.
	g_SlenderInterruptConditions[bossIndex] = 0;
	
	return Plugin_Continue;
}

public Action Timer_SlenderPublicDeathCamThink(Handle timer, any entref)
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
	
	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}
	
	if (timer != g_SlenderEntityThink[bossIndex])
	{
		return Plugin_Stop;
	}

	if (!g_SlenderInDeathcam[bossIndex])
	{
		return Plugin_Stop;
	}

	int client = EntRefToEntIndex(g_SlenderDeathCamTarget[bossIndex]);

	if (!IsValidClient(client) || (IsValidClient(client) && (!IsPlayerAlive(client) || GetClientTeam(client) == TFTeam_Blue)))
	{
		if (g_SlenderDeathCamTimer[bossIndex] != null)
		{
			TriggerTimer(g_SlenderDeathCamTimer[bossIndex]);
		}
		else
		{
			if ((NPCGetFlags(bossIndex) & SFF_FAKE))
			{
				if (g_SlenderInDeathcam[bossIndex])
				{
					g_SlenderInDeathcam[bossIndex] = false;
				}
				SlenderMarkAsFake(bossIndex);
			}
			else
			{
				SetEntityRenderMode(slender, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
				if (!NPCChaserIsCloaked(bossIndex))
				{
					SetEntityRenderColor(slender, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
				}
				if (g_SlenderEntityThink[bossIndex] != null)
				{
					KillTimer(g_SlenderEntityThink[bossIndex]);
				}
				g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				g_SlenderInDeathcam[bossIndex] = false;
				NPCChaserUpdateBossAnimation(bossIndex, slender, g_SlenderState[bossIndex]);
			}
		}
	}

	return Plugin_Continue;
}