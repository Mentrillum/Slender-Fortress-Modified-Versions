#if defined _sf2_npc_chaser_mind_included
#endinput
#endif

#define _sf2_npc_chaser_mind_included

char sCloakParticle[PLATFORM_MAX_PATH];

public Action Timer_SlenderChaseBossThink(Handle timer, any entref) //God damn you are so big, you get a file dedicated to only you
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;

	if (NPCGetFlags(iBossIndex) & SFF_MARKEDASFAKE) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	if (npc == INVALID_NPC) return Plugin_Stop;

	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();
	CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npc.GetEntity());

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_BOSS_IDLE, 1, "g_flSlenderTimeUntilKill[%d]: %f", iBossIndex, g_flSlenderTimeUntilKill[iBossIndex] - GetGameTime());
	#endif

	float flMyPos[3], flMyEyeAng[3];
	float flBuffer[3];
	
	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	
	AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng);

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flOriginalSpeed, flOriginalMaxSpeed, flOriginalAcceleration;
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !SF_IsSlaughterRunMap() && !g_bRenevant90sEffect)
		{
			flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
			flOriginalMaxSpeed = NPCGetMaxSpeed(iBossIndex, iDifficulty) + NPCGetAddMaxSpeed(iBossIndex);
			flOriginalAcceleration = NPCGetAcceleration(iBossIndex, iDifficulty) + NPCGetAddAcceleration(iBossIndex);
		}
		else if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || SF_IsSlaughterRunMap() || g_bRenevant90sEffect)
		{
			flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty) + NPCGetAddSpeed(iBossIndex);
			flOriginalMaxSpeed = NPCGetMaxSpeed(iBossIndex, iDifficulty) + NPCGetAddMaxSpeed(iBossIndex);
			flOriginalAcceleration = NPCGetAcceleration(iBossIndex, iDifficulty) + NPCGetAddAcceleration(iBossIndex);
			if (flOriginalSpeed < (SF_IsSlaughterRunMap() ? 580.0 : 520.0))
			{
				flOriginalSpeed = SF_IsSlaughterRunMap() ? 580.0 : 520.0;
			}
			if (flOriginalMaxSpeed < (SF_IsSlaughterRunMap() ? 580.0 : 520.0))
			{
				flOriginalMaxSpeed = SF_IsSlaughterRunMap() ? 580.0 : 520.0;
			}
			if (flOriginalAcceleration < (SF_IsSlaughterRunMap() ? 10000.0 : 9001.0))
			{
				flOriginalAcceleration = SF_IsSlaughterRunMap() ? 10000.0 : 9001.0;
			}
		}
	}
	else
	{
		flOriginalSpeed = 0.0;
		flOriginalMaxSpeed = 0.0;
		flOriginalAcceleration = NPCGetAcceleration(iBossIndex, iDifficulty) + NPCGetAddAcceleration(iBossIndex); //Do this anyways
	}
	float flOriginalWalkSpeed = NPCChaserGetWalkSpeed(iBossIndex, iDifficulty);
	float flOriginalMaxWalkSpeed = NPCChaserGetMaxWalkSpeed(iBossIndex, iDifficulty);
	
	if (g_bProxySurvivalRageMode)
	{
		flOriginalSpeed *= 1.25;
		flOriginalWalkSpeed *= 1.25;
		flOriginalMaxSpeed *= 1.25;
		flOriginalMaxWalkSpeed *= 1.25;
	}
	float flSpeed, flMaxSpeed, flAcceleration;
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		flSpeed = flOriginalSpeed;
		flMaxSpeed = flOriginalMaxSpeed;
	}
	else
	{
		flSpeed = 0.0;
		flMaxSpeed = 0.0;
	}
	flAcceleration = flOriginalAcceleration;
	if (g_flRoundDifficultyModifier > 1.0)
	{
		flSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier) / 15.0) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
		flMaxSpeed = flOriginalMaxSpeed + ((flOriginalMaxSpeed * g_flRoundDifficultyModifier) / 20.0) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
		flAcceleration = flOriginalAcceleration + ((flOriginalAcceleration * g_flRoundDifficultyModifier) / 15.0);
	}
	else
	{
		flSpeed = flOriginalSpeed + NPCGetAnger(iBossIndex);
		flMaxSpeed = flOriginalMaxSpeed + NPCGetAnger(iBossIndex);
		flAcceleration = flOriginalAcceleration;
	}
	if (flSpeed < flOriginalSpeed) flSpeed = flOriginalSpeed;
	if (flSpeed > flMaxSpeed) flSpeed = flMaxSpeed;
	if (flAcceleration < flOriginalAcceleration)flAcceleration = flOriginalAcceleration;
	
	float flWalkSpeed = flOriginalWalkSpeed;
	float flMaxWalkSpeed = flOriginalMaxWalkSpeed;
	if (g_flRoundDifficultyModifier > 1.0)
	{
		flWalkSpeed = (flOriginalWalkSpeed + (flOriginalWalkSpeed * g_flRoundDifficultyModifier) / 15.0);
		flMaxWalkSpeed = (flOriginalMaxWalkSpeed + (flOriginalMaxWalkSpeed * g_flRoundDifficultyModifier) / 20.0);
	}
	if (flWalkSpeed < flOriginalWalkSpeed) flWalkSpeed = flOriginalWalkSpeed;
	if (flWalkSpeed > flMaxWalkSpeed) flWalkSpeed = flMaxWalkSpeed;

	g_flSlenderSpeedMultiplier[iBossIndex] = 1.0;
	if (PeopleCanSeeSlender(iBossIndex, _, true))
	{
		if (NPCHasAttribute(iBossIndex, "reduced speed on look"))
		{
			g_flSlenderSpeedMultiplier[iBossIndex] = NPCGetAttributeValue(iBossIndex, "reduced speed on look");
			flSpeed *= NPCGetAttributeValue(iBossIndex, "reduced speed on look");
		}
		
		if (NPCHasAttribute(iBossIndex, "reduced walk speed on look"))
		{
			flWalkSpeed *= NPCGetAttributeValue(iBossIndex, "reduced walk speed on look");
		}

		if (NPCHasAttribute(iBossIndex, "reduced acceleration on look"))
		{
			flAcceleration *= NPCGetAttributeValue(iBossIndex, "reduced acceleration on look");
		}
	}
	if (g_bNPCHasCloaked[iBossIndex])
	{
		flSpeed *= NPCChaserGetCloakSpeedMultiplier(iBossIndex, iDifficulty);
		flMaxSpeed *= NPCChaserGetCloakSpeedMultiplier(iBossIndex, iDifficulty);
	}
	if (g_bNPCIsCrawling[iBossIndex])
	{
		flWalkSpeed *= NPCChaserGetCrawlSpeedMultiplier(iBossIndex, iDifficulty);
		flMaxWalkSpeed *= NPCChaserGetCrawlSpeedMultiplier(iBossIndex, iDifficulty);
		flSpeed *= NPCChaserGetCrawlSpeedMultiplier(iBossIndex, iDifficulty);
		flMaxSpeed *= NPCChaserGetCrawlSpeedMultiplier(iBossIndex, iDifficulty);
	}
	Action fAction = Plugin_Continue;
	float flForwardSpeed = flWalkSpeed;
	Call_StartForward(fOnBossGetWalkSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flWalkSpeed = flForwardSpeed;
	
	fAction = Plugin_Continue;
	flForwardSpeed = flSpeed;
	Call_StartForward(fOnBossGetSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flSpeed = flForwardSpeed;
	
	if (iDifficulty >= RoundToNearest(NPCGetAttributeValue(iBossIndex, "block walk speed under difficulty", 0.0)))
		g_flSlenderCalculatedWalkSpeed[iBossIndex] = flWalkSpeed;
	else g_flSlenderCalculatedWalkSpeed[iBossIndex] = 0.0;
	
	if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
	{
		g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	}
	else
	{
		g_flSlenderCalculatedSpeed[iBossIndex] = 0.0;
	}
	g_flSlenderCalculatedAcceleration[iBossIndex] = flAcceleration;
	g_flSlenderCalculatedMaxSpeed[iBossIndex] = flMaxSpeed;
	g_flSlenderCalculatedMaxWalkSpeed[iBossIndex] = flMaxWalkSpeed;
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iOldTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	
	int iBestNewTarget = INVALID_ENT_REFERENCE;
	int iSoundTarget = INVALID_ENT_REFERENCE;
	float flSearchRange = NPCGetSearchRadius(iBossIndex, iDifficulty);
	float flSearchSoundRange = NPCGetHearingRadius(iBossIndex, iDifficulty);
	float flBestNewTargetDist = SquareFloat(flSearchRange);
	int iState = iOldState;

	bool bPlayerInFOV[MAXPLAYERS + 1];
	bool bPlayerNear[MAXPLAYERS + 1];
	bool bPlayerMadeNoise[MAXPLAYERS + 1];
	bool bPlayerInTrap[MAXPLAYERS + 1];
	float flPlayerDists[MAXPLAYERS + 1];
	bool bPlayerVisible[MAXPLAYERS + 1];
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	bool bStunEnabled = NPCChaserIsStunEnabled(iBossIndex);
	
	float flSlenderMins[3], flSlenderMaxs[3];
	GetEntPropVector(slender, Prop_Send, "m_vecMins", flSlenderMins);
	GetEntPropVector(slender, Prop_Send, "m_vecMaxs", flSlenderMaxs);
	
	float flTraceMins[3], flTraceMaxs[3];
	flTraceMins[0] = flSlenderMins[0];
	flTraceMins[1] = flSlenderMins[1];
	flTraceMins[2] = 0.0;
	flTraceMaxs[0] = flSlenderMaxs[0];
	flTraceMaxs[1] = flSlenderMaxs[1];
	flTraceMaxs[2] = 0.0;
	
	char strClass[32];
	
	bool bBuilding = false;
	if (iOldTarget > MaxClients)
	{
		GetEdictClassname(iOldTarget, strClass, sizeof(strClass));
		if (strcmp(strClass, "obj_sentrygun") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
		if (strcmp(strClass, "obj_dispenser") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
		if (strcmp(strClass, "obj_teleporter") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
	}
	
	if (g_iSlenderSoundTarget[iBossIndex] != INVALID_ENT_REFERENCE) iSoundTarget = EntRefToEntIndex(g_iSlenderSoundTarget[iBossIndex]);
	
	bool bInFlashlight = false;
	bool bDoubleFlashlightDamage = false;

	// Gather data about the players around me and get the best new target, in case my old target is invalidated.
	int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "player")) != -1)
	{
		if (!IsTargetValidForSlender(iEnt, bAttackEliminated)) continue;
		float flTraceStartPos[3], flTraceEndPos[3];
		NPCGetEyePosition(iBossIndex, flTraceStartPos);
		GetClientEyePosition(iEnt, flTraceEndPos);

		float flDist = 99999999999.9;
		
		Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos, 
					flTraceEndPos, 
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
					RayType_EndPoint, 
					TraceRayBossVisibility, 
					slender);

		bool bIsVisible = !TR_DidHit(hTrace);
		int iTraceHitEntity = TR_GetEntityIndex(hTrace);
		delete hTrace;

		if (!bIsVisible && iTraceHitEntity == iEnt) bIsVisible = true;
		
		if (bIsVisible)
		{
			bIsVisible = NPCShouldSeeEntity(iBossIndex, iEnt);
		}

		if (g_offsPlayerFogCtrl != -1 && g_offsFogCtrlEnable != -1 && g_offsFogCtrlEnd != -1)
		{
			int iFogEntity = GetEntDataEnt2(iEnt, g_offsPlayerFogCtrl);
			if (IsValidEdict(iFogEntity))
			{
				if (GetEntData(iFogEntity, g_offsFogCtrlEnable) &&
					GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) >= SquareFloat(GetEntDataFloat(iFogEntity, g_offsFogCtrlEnd))) 
				{
					bIsVisible = false;
				}
			}
		}

		float flPriorityValue;
		
		bPlayerVisible[iEnt] = bIsVisible;
		
		// Near radius check.
		if (!g_bNPCIgnoreNonMarkedForChase[iBossIndex] && bPlayerVisible[iEnt] && 
			GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) <= SquareFloat(NPCChaserGetWakeRadius(iBossIndex)))
		{
			bPlayerNear[iEnt] = true;
		}
		if (bPlayerVisible[iEnt] && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(flTraceEndPos, flTraceStartPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
			TF2_StunPlayer(iEnt, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		
		// FOV check.
		SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
		GetVectorAngles(flBuffer, flBuffer);

		if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) <= (NPCGetFOV(iBossIndex) * 0.5))
		{
			bPlayerInFOV[iEnt] = true;
		}
		
		if (!SF_IsRaidMap() && !SF_BossesChaseEndlessly() && !SF_IsProxyMap() && !SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_bNPCChasesEndlessly[iBossIndex])
		{
			flPriorityValue = g_iPageMax > 0 ? ((float(g_iPlayerPageCount[iEnt]) / float(g_iPageMax))/4.0) : 0.0;
		}
		
		if ((TF2_GetPlayerClass(iEnt) == TFClass_Medic || g_bPlayerHasRegenerationItem[iEnt]) && !SF_IsBoxingMap()) flPriorityValue += 0.2;
		
		if (TF2_GetPlayerClass(iEnt) == TFClass_Spy) flPriorityValue += 0.1;
		
		//Taunt alerts
		if (!g_bNPCIgnoreNonMarkedForChase[iBossIndex] && iState != STATE_ALERT && iState != STATE_ATTACK && iState != STATE_STUN && iState != STATE_CHASE && 
		GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) <= SquareFloat(NPCGetTauntAlertRange(iBossIndex, iDifficulty)) && TF2_IsPlayerInCondition(iEnt, TFCond_Taunting))
		{
			if (g_iSlenderTauntAlertCount[iBossIndex] < 5)
			{
				float flTargetPos[3];
				if (IsValidClient(iEnt)) GetClientAbsOrigin(iEnt, flTargetPos);
				iBestNewTarget = iEnt;
				if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				g_flSlenderGoalPos[iBossIndex][0] = flTargetPos[0];
				g_flSlenderGoalPos[iBossIndex][1] = flTargetPos[1];
				g_flSlenderGoalPos[iBossIndex][2] = flTargetPos[2];
				g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddVoice(iBossIndex, iDifficulty) * 2;
				iState = STATE_ALERT;
				g_iSlenderTauntAlertCount[iBossIndex]++;
			}
			else
			{
				bPlayerMadeNoise[iEnt] = true;
				g_bNPCInAutoChase[iBossIndex] = true;
				g_iSlenderTauntAlertCount[iBossIndex] = 0;
			}
		}

		//Trap check
		if (g_bPlayerTrapped[iEnt] && GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) <= SquareFloat(flSearchRange))
		{
			if (iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				bPlayerInTrap[iEnt] = true;
				g_bNPCInAutoChase[iBossIndex] = true;
			}
		}
		
		if (NPCChaserCanAutoChaseSprinters(iBossIndex) && IsClientReallySprinting(iEnt) && GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) <= SquareFloat(flSearchSoundRange) && GetGameTime() >= g_flNPCAutoChaseSprinterCooldown[iBossIndex] && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
		{
			bPlayerMadeNoise[iEnt] = true;
			g_bNPCInAutoChase[iBossIndex] = true;
		}
		
		if (NPCChaserIsAutoChaseEnabled(iBossIndex))
		{
			if (IsValidClient(iSoundTarget) && g_iSlenderAutoChaseCount[iBossIndex] >= NPCChaserAutoChaseThreshold(iBossIndex, iDifficulty) && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				bPlayerMadeNoise[iSoundTarget] = true;
				g_bNPCInAutoChase[iBossIndex] = true;
			}
		}

		flDist = GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos);
		flPlayerDists[iEnt] = flDist;

		if (!g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && bPlayerVisible[iEnt] && (bPlayerNear[iEnt] || bPlayerInFOV[iEnt]))
		{
			float flTargetPos[3];
			GetClientAbsOrigin(iEnt, flTargetPos);
			if (!g_bAutoChasingLoudPlayer[iBossIndex] && !g_bNPCIgnoreNonMarkedForChase[iBossIndex])
			{
				if (flDist <= SquareFloat(flSearchRange))
				{
					// Subtract distance to increase priority.
					flDist -= ((flDist * flPriorityValue));
					
					if (flDist < flBestNewTargetDist)
					{
						iBestNewTarget = iEnt;
						flBestNewTargetDist = flDist;
						g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
						g_iSlenderSeeTarget[iBossIndex] = EntIndexToEntRef(iEnt);
					}
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][0] = flTargetPos[0];
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][1] = flTargetPos[1];
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][2] = flTargetPos[2];
					g_flSlenderLastFoundPlayer[iBossIndex][iEnt] = GetGameTime();
				}
			}
			else if (g_bAutoChasingLoudPlayer[iBossIndex] && g_bNPCIgnoreNonMarkedForChase[iBossIndex])
			{
				if (g_aNPCChaseOnLookTarget[iBossIndex].Length > 0 && g_aNPCChaseOnLookTarget[iBossIndex].FindValue(iEnt) != -1 &&
					flDist <= SquareFloat(flSearchRange))
				{
					// Subtract distance to increase priority.
					flDist -= ((flDist * flPriorityValue));
					
					if (flDist < flBestNewTargetDist)
					{
						iBestNewTarget = iEnt;
						flBestNewTargetDist = flDist;
						g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
						g_iSlenderSeeTarget[iBossIndex] = EntIndexToEntRef(iEnt);
					}
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][0] = flTargetPos[0];
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][1] = flTargetPos[1];
					g_flSlenderLastFoundPlayerPos[iBossIndex][iEnt][2] = flTargetPos[2];
					g_flSlenderLastFoundPlayer[iBossIndex][iEnt] = GetGameTime();
				}
			}
		}

		if ((bPlayerMadeNoise[iEnt] || bPlayerInTrap[iEnt]) && iState != STATE_CHASE && iState != STATE_STUN && iState != STATE_ATTACK)
		{
			if (g_bNPCIgnoreNonMarkedForChase[iBossIndex] && bPlayerMadeNoise[iEnt])
			{
				iBestNewTarget = iEnt;
				iState = STATE_CHASE;
				SlenderAlertAllValidBosses(iBossIndex, iEnt, iBestNewTarget);
				GetClientAbsOrigin(iEnt, g_flSlenderGoalPos[iBossIndex]);
				g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_bSlenderGiveUp[iBossIndex] = false;
				g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				g_bAutoChasingLoudPlayer[iBossIndex] = true;
				g_iSlenderAutoChaseCount[iBossIndex] = 0;
			}
			else if (bPlayerInTrap[iEnt] || (!g_bNPCIgnoreNonMarkedForChase[iBossIndex] && bPlayerMadeNoise[iEnt]))
			{
				iBestNewTarget = iEnt;
				iState = STATE_CHASE;
				SlenderAlertAllValidBosses(iBossIndex, iEnt, iBestNewTarget);
				GetClientAbsOrigin(iEnt, g_flSlenderGoalPos[iBossIndex]);
				g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
				g_bSlenderGiveUp[iBossIndex] = false;
				g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				g_bAutoChasingLoudPlayer[iBossIndex] = false;
			}
		}

		if (NPCChaserIsStunByFlashlightEnabled(iBossIndex) && IsClientUsingFlashlight(iEnt) && bPlayerInFOV[iEnt]) // Check to see if someone is facing at us with flashlight on. Only if I'm facing them too. BLINDNESS!
		{
			if (GetVectorSquareMagnitude(flTraceStartPos, flTraceEndPos) <= SquareFloat(SF2_FLASHLIGHT_LENGTH))
			{
				float flEyeAng[3], flRequiredAng[3];
				GetClientEyeAngles(iEnt, flEyeAng);
				SubtractVectors(flTraceEndPos, flTraceStartPos, flRequiredAng);
				GetVectorAngles(flRequiredAng, flRequiredAng);

				if (FloatAbs(AngleDiff(flEyeAng[0], flRequiredAng[0])) <= 45.0 && FloatAbs(AngleDiff(flRequiredAng[1], flEyeAng[1])) >= 135.0)
				{
					if (bPlayerVisible[iEnt])
					{
						bInFlashlight = true;
						if (TF2_GetPlayerClass(iEnt) == TFClass_Engineer) bDoubleFlashlightDamage = true;
					}
				}
			}
		}
		if (NPCChaserCanChaseOnLook(iBossIndex) && bPlayerInFOV[iEnt] && bPlayerVisible[iEnt])
		{
			float flEyeAng[3], flRequiredAng[3];
			GetClientEyeAngles(iEnt, flEyeAng);
			SubtractVectors(flTraceEndPos, flTraceStartPos, flRequiredAng);
			GetVectorAngles(flRequiredAng, flRequiredAng);
			if (FloatAbs(AngleDiff(flEyeAng[0], flRequiredAng[0])) <= 45.0 && FloatAbs(AngleDiff(flRequiredAng[1], flEyeAng[1])) >= 135.0)
			{
				if (g_aNPCChaseOnLookTarget[iBossIndex].FindValue(iEnt) == -1)
				{
					g_aNPCChaseOnLookTarget[iBossIndex].Push(iEnt);
					char buffer[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, "sound_scare_player", buffer, sizeof(buffer));
					if (buffer[0] != '\0') EmitSoundToClient(iEnt, buffer, _, SNDCHAN_STATIC, SNDLEVEL_NONE);
					TF2_AddCondition(iEnt, TFCond_MarkedForDeathSilent, -1.0);
					if (g_hSlenderChaseInitialTimer[iBossIndex] == null && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
					{
						g_bNPCUsesChaseInitialAnimation[iBossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderChaseInitialTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}

	if (IsValidClient(EntRefToEntIndex(g_iSlenderTarget[iBossIndex])) && bPlayerVisible[EntRefToEntIndex(g_iSlenderTarget[iBossIndex])]) g_bSlenderTargetIsVisible[iBossIndex] = true;
	else g_bSlenderTargetIsVisible[iBossIndex] = false;

	if (g_bAutoChasingLoudPlayer[iBossIndex])
	{
		if (g_aNPCChaseOnLookTarget[iBossIndex].Length <= 0)
		{
			g_bAutoChasingLoudPlayer[iBossIndex] = false;
			g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			iSoundTarget = INVALID_ENT_REFERENCE;
		}
	}
	
	// Damage us if we're in a flashlight.
	if (bInFlashlight)
	{
		if (bStunEnabled)
		{
			if (NPCChaserIsStunByFlashlightEnabled(iBossIndex) && !(SF_SpecialRound(SPECIALROUND_NIGHTVISION)) && !(g_cvNightvisionEnabled.BoolValue))
			{
				if (NPCChaserGetStunHealth(iBossIndex) > 0)
				{
					if (!bDoubleFlashlightDamage) NPCChaserAddStunHealth(iBossIndex, -NPCChaserGetStunFlashlightDamage(iBossIndex));
					else NPCChaserAddStunHealth(iBossIndex, -NPCChaserGetStunFlashlightDamage(iBossIndex) * 1.5);
					if (NPCChaserGetStunHealth(iBossIndex) <= 0.0 && iState != STATE_STUN)
					{
						NPCBossTriggerStun(iBossIndex, slender, sSlenderProfile, flMyPos);
						Call_StartForward(fOnBossStunned);
						Call_PushCell(iBossIndex);
						Call_PushCell(-1);
						Call_Finish();
						iState = STATE_STUN;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					}
				}
			}
		}
	}
	
	// Process the target that we should have.
	int iTarget = iOldTarget;
	
	/*
	if (IsValidEdict(iBestNewTarget))
	{
		iTarget = iBestNewTarget;
		g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
	}
	*/
	
	if (iTarget && iTarget != INVALID_ENT_REFERENCE)
	{
		if (!IsTargetValidForSlender(iTarget, bAttackEliminated))
		{
			// Clear our target; he's not valid anymore.
			iOldTarget = iTarget;
			iTarget = INVALID_ENT_REFERENCE;
			g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
		}
	}
	else
	{
		// Clear our target; he's not valid anymore.
		iOldTarget = iTarget;
		iTarget = INVALID_ENT_REFERENCE;
		g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	}

	if (bBuilding) iTarget = iBestNewTarget;
	
	//We should never give up, but sometimes it happens.
	if (g_bSlenderGiveUp[iBossIndex])
	{
		//Damit our target is unreachable for some unexplained reasons, haaaaaaaaaaaa!
		if (!SF_IsRaidMap() || !SF_BossesChaseEndlessly() || !SF_IsProxyMap() || !g_bNPCChasesEndlessly[iBossIndex] || !SF_IsBoxingMap() || !SF_IsSlaughterRunMap())
		{
			iState = STATE_IDLE;
			g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
			g_bSlenderGiveUp[iBossIndex] = false;
		}
		
		if ((SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex] || SF_IsSlaughterRunMap() || SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap()) && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			//RemoveSlender(iBossIndex);
		//Do not, ok?
		g_bSlenderGiveUp[iBossIndex] = false;
		if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
	}
	
	int iInterruptConditions = g_iSlenderInterruptConditions[iBossIndex];

	if ((SF_IsRaidMap() || (SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex]) || SF_IsProxyMap() || SF_IsBoxingMap() || SF_IsSlaughterRunMap()) && !g_bSlenderGiveUp[iBossIndex] && !bBuilding && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
	{
		if (!IsValidClient(iTarget) || (IsValidClient(iTarget) && g_bPlayerEliminated[iTarget]))
		{
			if (iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN && NPCAreAvailablePlayersAlive())
			{
				int iRaidClient;
				do
				{
					iRaidClient = GetRandomInt(1, MaxClients);
				}
				while (!IsClientInGame(iRaidClient) || 
					!IsPlayerAlive(iRaidClient) || 
					g_bPlayerEliminated[iRaidClient] || 
					IsClientInGhostMode(iRaidClient) || 
					DidClientEscape(iRaidClient));
				
				for (int i = 1; i <= MaxClients; i++)
				{
					if (i == iRaidClient && IsValidClient(iRaidClient) && !g_bPlayerEliminated[iRaidClient])
					{
						iBestNewTarget = iRaidClient;
						g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
						iState = STATE_CHASE;
						GetClientAbsOrigin(iBestNewTarget, g_flSlenderGoalPos[iBossIndex]);
						iTarget = iBestNewTarget;
					}
				}
			}
		}
	}

	if (NPCChaserCanChaseOnLook(iBossIndex))
	{
		if (iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN && NPCAreAvailablePlayersAlive() && g_aNPCChaseOnLookTarget[iBossIndex].Length != 0)
		{
			for (int i = 0; i < g_aNPCChaseOnLookTarget[iBossIndex].Length; i++)
			{
				int iLookClient = g_aNPCChaseOnLookTarget[iBossIndex].Get(i);
				if (IsValidClient(iLookClient) && !g_bPlayerEliminated[iLookClient] && IsPlayerAlive(iLookClient) && IsClientInGame(iLookClient) &&
					!IsClientInGhostMode(iLookClient) && !DidClientEscape(iLookClient))
				{
					iBestNewTarget = iLookClient;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iLookClient);
					g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
					iState = STATE_CHASE;
					GetClientAbsOrigin(iBestNewTarget, g_flSlenderGoalPos[iBossIndex]);
					iTarget = iBestNewTarget;
					SlenderAlertAllValidBosses(iBossIndex, iTarget, iBestNewTarget);
				}
				else i--;
			}
		}
	}

	// Process which state we should be in.
	switch (iState)
	{
		case STATE_IDLE, STATE_WANDER:
		{
			for (int i = 0; i < MAX_NPCTELEPORTER; i++)
			{
				if (NPCChaserGetTeleporter(iBossIndex, i) != INVALID_ENT_REFERENCE)
					NPCChaserSetTeleporter(iBossIndex, i, INVALID_ENT_REFERENCE);
			}
			if (iState == STATE_WANDER)
			{
				if (!g_pPath[iBossIndex].IsValid() && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				{
					iState = STATE_IDLE;
				}
			}
			else
			{
				if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex][iDifficulty] && GetRandomFloat(0.0, 1.0) <= 0.25 && iDifficulty >= RoundToNearest(NPCGetAttributeValue(iBossIndex, "block walk speed under difficulty", 0.0)))
				{
					iState = STATE_WANDER;
				}
			}
			if (SF_SpecialRound(SPECIALROUND_BEACON) || g_bRenevantBeaconEffect)
			{
				if (!g_bSlenderInBacon[iBossIndex])
				{
					int iClientToPos = NPCChaserGetClosestPlayer(slender);
					float flClientPosition[3];
					if (IsValidClient(iClientToPos)) GetClientAbsOrigin(iClientToPos, flClientPosition);
					iBestNewTarget = iClientToPos;
					iState = STATE_ALERT;
					if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
					g_flSlenderGoalPos[iBossIndex][0] = flClientPosition[0];
					g_flSlenderGoalPos[iBossIndex][1] = flClientPosition[1];
					g_flSlenderGoalPos[iBossIndex][2] = flClientPosition[2];
					g_bSlenderInBacon[iBossIndex] = true;
				}
			}
			if (iInterruptConditions & COND_SAWENEMY)
			{
				if (NPCChaserIsAutoChaseEnabled(iBossIndex))
				{
					g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddGeneral(iBossIndex, iDifficulty);
				}
				// I saw someone over here. Automatically put me into alert mode.
				iState = STATE_ALERT;
				if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				int iClientToPos = EntRefToEntIndex(g_iSlenderSeeTarget[iBossIndex]);
				float flClientPosition[3];
				if (IsValidClient(iClientToPos))
				{
					GetClientAbsOrigin(iClientToPos, flClientPosition);
					iBestNewTarget = iClientToPos;
					g_flSlenderGoalPos[iBossIndex][0] = flClientPosition[0];
					g_flSlenderGoalPos[iBossIndex][1] = flClientPosition[1];
					g_flSlenderGoalPos[iBossIndex][2] = flClientPosition[2];
				}
			}
			else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
			{
				// Sound counts:
				// +1 will be added if it hears a footstep.
				// +2 will be added if the footstep is someone sprinting.
				// +5 will be added if the sound is from a player's weapon hitting an object or flashlight is heard..
				// +10 will be added if a voice command.
				//
				// Sound counts will be reset after the boss hears a sound after a certain amount of time.
				// The purpose of sound counts is to induce boss focusing on sounds suspicious entities are making.
				
				int iCount = 0;
				if (iInterruptConditions & COND_HEARDFOOTSTEP) iCount += 1;
				if (iInterruptConditions & COND_HEARDFOOTSTEPLOUD) iCount += 2;
				if (iInterruptConditions & COND_HEARDWEAPON) iCount += 5;
				if (iInterruptConditions & COND_HEARDVOICE) iCount += 10;
				if (iInterruptConditions & COND_HEARDFLASHLIGHT) iCount += 5;
				
				bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
				
				if (GetVectorSquareMagnitude(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= SquareFloat(GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0)) || 
					bDiscardMasterPos)
				{
					if (bDiscardMasterPos) g_iSlenderTargetSoundCount[iBossIndex] = 0;
					
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
					g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
					g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
					g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
					g_iSlenderTargetSoundCount[iBossIndex] += iCount;
				}
				if (g_iSlenderTargetSoundCount[iBossIndex] >= NPCChaserGetSoundCountToAlert(iBossIndex))
				{
					// Someone's making some noise over there! Time to investigate.
					g_bSlenderInvestigatingSound[iBossIndex] = true; // This is just so that our sound position would be the goal position.
					iState = STATE_ALERT;
					if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				}
			}
			if (NPCChaserGetTrapState(iBossIndex))
			{
				if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && g_iTrapEntityCount < 32)
				{
					Trap_SpawnTrap(flMyPos, flMyEyeAng, iBossIndex);
					g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
				}
				else if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && g_iTrapEntityCount >= 32)g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
			}
		}
		case STATE_ALERT:
		{
			if (iState == STATE_ALERT)
			{
				if (!g_pPath[iBossIndex].IsValid() && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				{
					if (!(iInterruptConditions & COND_HEARDSUSPICIOUSSOUND))
					{
						iState = STATE_IDLE;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					}
					else if ((iInterruptConditions & COND_HEARDSUSPICIOUSSOUND) && GetVectorSquareMagnitude(g_flSlenderGoalPos[iBossIndex], flMyPos) <= SquareFloat(20.0))
					{
						iState = STATE_IDLE;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					}
				}
			}
			if (GetGameTime() >= g_flSlenderTimeUntilIdle[iBossIndex] && !g_bNPCHealing[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex])
			{
				iState = STATE_IDLE;
				if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
			}
			else if (IsValidClient(iBestNewTarget))
			{
				if (GetGameTime() >= g_flSlenderTimeUntilChase[iBossIndex] || bPlayerNear[iBestNewTarget])
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					
					if (IsValidClient(iBestNewTarget)) GetClientEyePosition(iBestNewTarget, flTraceEndPos);
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++)flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos, 
						flTraceEndPos, 
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
						RayType_EndPoint, 
						TraceRayBossVisibility, 
						slender);
					
					bool bIsVisible = !TR_DidHit(hTrace);
					int iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (!bIsVisible && iTraceHitEntity == iBestNewTarget) bIsVisible = true;
					
					if (bBuilding || ((bPlayerNear[iBestNewTarget] || bPlayerInFOV[iBestNewTarget]) && bPlayerVisible[iBestNewTarget]))
					{
						// AHAHAHAH! I GOT YOU NOW!
						iTarget = iBestNewTarget;
						g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
						iState = STATE_CHASE;
						GetClientAbsOrigin(iBestNewTarget, g_flSlenderGoalPos[iBossIndex]);
						SlenderAlertAllValidBosses(iBossIndex, iTarget, iBestNewTarget);
					}
				}
				if (bPlayerInTrap[iBestNewTarget] || bPlayerMadeNoise[iBestNewTarget])
				{
					// AHAHAHAH! I GOT YOU NOW!
					iTarget = iBestNewTarget;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
					iState = STATE_CHASE;
					GetClientAbsOrigin(iBestNewTarget, g_flSlenderGoalPos[iBossIndex]);
					SlenderAlertAllValidBosses(iBossIndex, iTarget, iBestNewTarget);
				}
			}
			if ((bBuilding))
			{
				iState = STATE_CHASE;
			}
			else
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidClient(iBestNewTarget))
					{
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][2];
					}
				}
				else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
				{
					bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
					
					if (GetVectorSquareMagnitude(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= SquareFloat(GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0)) || 
						bDiscardMasterPos)
					{
						g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
						g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
						g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
						g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
						
						// We have to manually set the goal position here because the goal position will not be changed due to no change in state.
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
						
						g_bSlenderInvestigatingSound[iBossIndex] = true;
					}
				}
				
				for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
				{
					if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam) continue;
					
					bool bBlockingProp = false;
					
					if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
					{
						bBlockingProp = NPC_CanAttackProps(iBossIndex, NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
					}
					
					if (bBlockingProp)
					{
						iState = STATE_ATTACK;
						NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
						break;
					}
				}
			}
			if (NPCChaserGetTrapState(iBossIndex))
			{
				if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && g_iTrapEntityCount < 32)
				{
					Trap_SpawnTrap(flMyPos, flMyEyeAng, iBossIndex);
					g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
				}
				else if (g_flSlenderNextTrapPlacement[iBossIndex] <= GetGameTime() && g_iTrapEntityCount >= 32) g_flSlenderNextTrapPlacement[iBossIndex] = GetGameTime() + NPCChaserGetTrapSpawnTime(iBossIndex, iDifficulty);
			}
		}
		case STATE_CHASE, STATE_ATTACK, STATE_STUN:
		{
			if (iState == STATE_CHASE)
			{
				if (IsValidEntity(iTarget))
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					if (NPCChaserIsCloakEnabled(iBossIndex))
					{
						float flCloakDist = GetVectorSquareMagnitude(g_flSlenderGoalPos[iBossIndex], flMyPos);
						float flCloakRange = NPCChaserGetCloakRange(iBossIndex, iDifficulty);
						float flDecloakRange = NPCChaserGetDecloakRange(iBossIndex, iDifficulty);
						if (flCloakDist <= SquareFloat(flCloakRange) && !g_bNPCHasCloaked[iBossIndex] && g_flSlenderNextCloakTime[iBossIndex] <= GetGameTime() && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
						{
							//Time for a more cloaking aproach!
							SetEntityRenderMode(slender, view_as<RenderMode>(GetProfileNum(sSlenderProfile, "cloak_rendermode", 1)));

							int iCloakColor[4];
							GetProfileColor(sSlenderProfile, "cloak_rendercolor", iCloakColor[0], iCloakColor[1], iCloakColor[2], iCloakColor[3], 
							g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);

							SetEntityRenderColor(slender, iCloakColor[0], iCloakColor[1], iCloakColor[2], iCloakColor[3]);
							g_flNPCNextDecloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakDuration(iBossIndex, iDifficulty);
							SlenderToggleParticleEffects(slender);
							GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
							if (sCloakParticle[0] == '\0')
							{
								sCloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
							EmitSoundToAll(g_sSlenderCloakOnSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_bNPCHasCloaked[iBossIndex] = true;
							Call_StartForward(fOnBossCloaked);
							Call_PushCell(iBossIndex);
							Call_Finish();
						}
						if ((flCloakDist <= SquareFloat(flDecloakRange) || GetGameTime() >= g_flNPCNextDecloakTime[iBossIndex]) && g_bNPCHasCloaked[iBossIndex])
						{
							//Come back now!
							SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
							SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
							
							SlenderToggleParticleEffects(slender, true);
							GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
							if (sCloakParticle[0] == '\0')
							{
								sCloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
							EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
							Call_StartForward(fOnBossDecloaked);
							Call_PushCell(iBossIndex);
							Call_Finish();
							g_bNPCHasCloaked[iBossIndex] = false;
						}
					}
					
					if (NPCChaserIsProjectileEnabled(iBossIndex))
					{
						if (NPCGetFlags(iBossIndex) & SFF_FAKE)
						{
							SlenderMarkAsFake(iBossIndex);
						}
						if (g_flNPCProjectileCooldown[iBossIndex] <= GetGameTime() && !NPCChaserUseProjectileAmmo(iBossIndex) && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && (bBuilding || (bPlayerInFOV[iTarget] && CanNPCSeePlayerNonTransparent(iBossIndex, iTarget))) && !g_bNPCHasCloaked[iBossIndex])
						{
							NPCChaserProjectileShoot(iBossIndex, slender, iTarget, sSlenderProfile, flMyPos);
						}
						else if (NPCChaserUseProjectileAmmo(iBossIndex))
						{
							if (g_flNPCProjectileCooldown[iBossIndex] <= GetGameTime() && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && (bBuilding || (bPlayerInFOV[iTarget] && CanNPCSeePlayerNonTransparent(iBossIndex, iTarget))) && !g_bNPCHasCloaked[iBossIndex] && (g_iNPCProjectileAmmo[iBossIndex] != 0))
							{
								NPCChaserProjectileShoot(iBossIndex, slender, iTarget, sSlenderProfile, flMyPos);
								g_iNPCProjectileAmmo[iBossIndex] = g_iNPCProjectileAmmo[iBossIndex] - 1;
							}
							if (g_iNPCProjectileAmmo[iBossIndex] == 0 && !g_bNPCReloadingProjectiles[iBossIndex])
							{
								g_flNPCProjectileTimeToReload[iBossIndex] = GetGameTime() + NPCChaserGetProjectileReloadTime(iBossIndex, iDifficulty);
								g_bNPCReloadingProjectiles[iBossIndex] = true;
							}
							if (g_flNPCProjectileTimeToReload[iBossIndex] <= GetGameTime() && g_iNPCProjectileAmmo[iBossIndex] == 0)
							{
								g_iNPCProjectileAmmo[iBossIndex] = NPCChaserGetLoadedProjectiles(iBossIndex, iDifficulty);
								g_bNPCReloadingProjectiles[iBossIndex] = false;
							}
						}
					}
					
					if (IsValidClient(iTarget))
					{
						GetClientEyePosition(iTarget, flTraceEndPos);
					}
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++) flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					bool bIsDeathPosVisible = false;
					
					if (g_bSlenderChaseDeathPosition[iBossIndex])
					{
						Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos, 
							g_flSlenderChaseDeathPosition[iBossIndex], 
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
							RayType_EndPoint, 
							TraceRayBossVisibility, 
							slender);
						bIsDeathPosVisible = !TR_DidHit(hTrace);
						delete hTrace;
					}
					
					if (!bBuilding && !bPlayerVisible[iTarget] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
					{
						if (GetGameTime() >= g_flSlenderTimeUntilAlert[iBossIndex] || (!bAttackEliminated && g_bPlayerEliminated[iTarget]))
						{
							iState = STATE_ALERT;
							g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
							if (NPCHasAttribute(iBossIndex, "chase target on scare"))
							{
								g_bNPCLostChasingScareVictim[iBossIndex] = true;
								g_bNPCChasingScareVictin[iBossIndex] = false;
							}
							if (NPCHasAttribute(iBossIndex, "alert copies") || NPCHasAttribute(iBossIndex, "alert companions"))
							{
								g_bNPCCopyAlerted[iBossIndex] = false;
							}
							g_iSlenderAutoChaseCount[iBossIndex] = 0;
							g_bAutoChasingLoudPlayer[iBossIndex] = false;
							g_bNPCInAutoChase[iBossIndex] = false;
							g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
							if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
						}
						else if (bIsDeathPosVisible || (!bAttackEliminated && g_bPlayerEliminated[iTarget]))
						{
							iState = STATE_IDLE;
							if (NPCHasAttribute(iBossIndex, "chase target on scare"))
							{
								g_bNPCLostChasingScareVictim[iBossIndex] = true;
								g_bNPCChasingScareVictin[iBossIndex] = false;
							}
							if (NPCHasAttribute(iBossIndex, "alert copies") || NPCHasAttribute(iBossIndex, "alert companions"))
							{
								g_bNPCCopyAlerted[iBossIndex] = false;
							}
							g_iSlenderAutoChaseCount[iBossIndex] = 0;
							g_bAutoChasingLoudPlayer[iBossIndex] = false;
							g_bNPCInAutoChase[iBossIndex] = false;
							g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
							if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
						}
						GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
					}
					else if ((bBuilding || CanNPCSeePlayerNonTransparent(iBossIndex, iTarget)) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false; // We're not chasing a dead player after all! Reset.
						
						float flAttackDirection[3], flAttackEyePos[3], flClientPosAttack[3], flAttackDist;
						NPCGetEyePosition(iBossIndex, flAttackEyePos);
						if (IsValidClient(iTarget))
							GetClientEyePosition(iTarget, flClientPosAttack);
						else
						{
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flClientPosAttack);
							flClientPosAttack[2] += 20.0;
						}
						flAttackDist = GetVectorSquareMagnitude(flMyPos, g_flSlenderGoalPos[iBossIndex]);
						SubtractVectors(flClientPosAttack, flAttackEyePos, flAttackDirection);
						GetVectorAngles(flAttackDirection, flAttackDirection);
						flAttackDirection[2] = 180.0;
						
						float flAttackBeginRangeEx, flAttackBeginFOVEx;

						float flFov = FloatAbs(AngleDiff(flAttackDirection[1], flMyEyeAng[1]));
						float flClientHealth = float(GetEntProp(iTarget, Prop_Send, "m_iHealth"));
						if (NPCGetFlags(iBossIndex) & SFF_RANDOMATTACKS)
						{
							ArrayList aArrayAttacks = new ArrayList();
							aArrayAttacks.Clear();
							for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
							{
								if ((iDifficulty >= NPCChaserGetAttackUseOnDifficulty(iBossIndex, iAttackIndex2) && iDifficulty < NPCChaserGetAttackBlockOnDifficulty(iBossIndex, iAttackIndex2)) && 
								NPCChaserGetNextAttackTime(iBossIndex, iAttackIndex2) <= GetGameTime())
								{
									aArrayAttacks.Push(iAttackIndex2);
								}
								if (IsValidClient(iTarget) && (NPCChaserGetAttackUseOnHealth(iBossIndex, iAttackIndex2) != -1.0 && flClientHealth < NPCChaserGetAttackUseOnHealth(iBossIndex, iAttackIndex2)) ||
								(NPCChaserGetAttackBlockOnHealth(iBossIndex, iAttackIndex2) != -1.0 && flClientHealth >= NPCChaserGetAttackBlockOnHealth(iBossIndex, iAttackIndex2)))
								{
									int iEraseAttack = aArrayAttacks.FindValue(iAttackIndex2);
									if (iEraseAttack != -1) aArrayAttacks.Erase(iEraseAttack);
								}
							}
							if (aArrayAttacks.Length > 0)
							{
								int iRandomAttackIndex = aArrayAttacks.Get(GetRandomInt(0, aArrayAttacks.Length - 1));
								flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iRandomAttackIndex);
								flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iRandomAttackIndex);
								if (flAttackDist <= SquareFloat(flAttackBeginRangeEx) && flFov <= (flAttackBeginFOVEx / 2.0) &&
								!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && 
								!g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
								{
									iState = STATE_ATTACK;
									NPCSetCurrentAttackIndex(iBossIndex, iRandomAttackIndex);
								}
							}
							delete aArrayAttacks;
						}
						else
						{
							for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
							{
								flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iAttackIndex);
								flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iAttackIndex);
								if (flAttackDist <= SquareFloat(flAttackBeginRangeEx) && ((!bBuilding && flFov <= (flAttackBeginFOVEx / 2.0)) || (bBuilding && flFov > (flAttackBeginFOVEx / 2.0))) && NPCChaserGetNextAttackTime(iBossIndex, iAttackIndex) <= GetGameTime() && 
								!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex]
								&& (iDifficulty >= NPCChaserGetAttackUseOnDifficulty(iBossIndex, iAttackIndex) && iDifficulty < NPCChaserGetAttackBlockOnDifficulty(iBossIndex, iAttackIndex)))
								{
									// ENOUGH TALK! HAVE AT YOU!
									iState = STATE_ATTACK;
									NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
									break;
								}
							}
						}
					}
					if (iState == STATE_CHASE)
					{
						for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
						{
							if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam)continue;
							
							bool bBlockingProp = false;
							
							if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
							{
								bBlockingProp = NPC_CanAttackProps(iBossIndex, NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
							}
							
							if (bBlockingProp)
							{
								iState = STATE_ATTACK;
								NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
								break;
							}
						}
					}
				}
				if (!IsValidEntity(iTarget) || (!bBuilding && DidClientEscape(iTarget)) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				{
					if (g_hBossFailSafeTimer[iBossIndex] == null)
						g_hBossFailSafeTimer[iBossIndex] = CreateTimer(0.1, Timer_DeathPosChaseStop, iBossIndex, TIMER_FLAG_NO_MAPCHANGE); //Setup a fail safe timer in case we can't finish our path.
					// Even if the target isn't valid anymore, see if I still have some ways to go on my current path,
					// because I shouldn't actually know that the target has died until I see it.
					if (!g_pPath[iBossIndex].IsValid())
					{
						iState = STATE_IDLE;
						g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
					}
				}
			}
			else if (iState == STATE_ATTACK)
			{
				if (!g_bSlenderAttacking[iBossIndex] || (g_flSlenderTimeUntilAttackEnd[iBossIndex] != -1.0 && g_flSlenderTimeUntilAttackEnd[iBossIndex] <= GetGameTime()))
				{
					if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					loco.ClearStuckStatus();
					g_flSlenderTimeUntilAttackEnd[iBossIndex] = -1.0;
					if (IsValidClient(iTarget))
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false;
						
						// Chase him again!
						g_bSlenderGiveUp[iBossIndex] = false;
						g_bSlenderAttacking[iBossIndex] = false;
						g_bNPCStealingLife[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = null;
						g_hNPCLifeStealTimer[iBossIndex] = null;
						g_hSlenderBackupAtkTimer[iBossIndex] = null;
						g_bNPCAlreadyAttacked[iBossIndex] = false;
						g_bNPCUseFireAnimation[iBossIndex] = false;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
						iState = STATE_CHASE;
						GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
					}
					else
					{
						// Target isn't valid anymore. We killed him, Mac!
						iState = STATE_ALERT;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
						g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
						g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
						g_bSlenderAttacking[iBossIndex] = false;
						g_bNPCStealingLife[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = null;
						g_hNPCLifeStealTimer[iBossIndex] = null;
						g_hSlenderBackupAtkTimer[iBossIndex] = null;
						g_bNPCAlreadyAttacked[iBossIndex] = false;
						g_bNPCUseFireAnimation[iBossIndex] = false;
						if (NPCHasAttribute(iBossIndex, "chase target on scare"))
						{
							g_bNPCLostChasingScareVictim[iBossIndex] = true;
							g_bNPCChasingScareVictin[iBossIndex] = false;
						}
						if (NPCHasAttribute(iBossIndex, "alert copies") || NPCHasAttribute(iBossIndex, "alert companions"))
						{
							g_bNPCCopyAlerted[iBossIndex] = false;
						}
					}
				}
			}
			else if (iState == STATE_STUN)
			{
				if (GetGameTime() >= g_flSlenderTimeUntilRecover[iBossIndex])
				{
					if (NPCChaserCanDisappearOnStun(iBossIndex))
					{
						RemoveSlender(iBossIndex);
					}
					loco.ClearStuckStatus();
					if (NPCHasAttribute(iBossIndex, "add stun health on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add stun health on stun");
						NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
						NPCChaserSetAddStunHealth(iBossIndex, flValue);
						if (flValue > 0.0)
						{
							NPCChaserAddStunHealth(iBossIndex, NPCChaserGetAddStunHealth(iBossIndex));
						}
					}
					else
					{
						NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
					}
					if (NPCHasAttribute(iBossIndex, "add speed on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add speed on stun");
						if (flValue > 0.0)
						{
							NPCSetAddSpeed(iBossIndex, flValue);
						}
					}
					if (NPCHasAttribute(iBossIndex, "add max speed on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add max speed on stun");
						if (flValue > 0.0)
						{
							NPCSetAddMaxSpeed(iBossIndex, flValue);
						}
					}
					if (NPCHasAttribute(iBossIndex, "add acceleration on stun"))
					{
						float flValue = NPCGetAttributeValue(iBossIndex, "add acceleration on stun");
						if (flValue > 0.0)
						{
							NPCSetAddAcceleration(iBossIndex, flValue);
						}
					}
					g_flSlenderNextStunTime[iBossIndex] = GetGameTime() + NPCChaserGetStunCooldown(iBossIndex);
					if (IsValidClient(iTarget))
					{
						// Chase him again!
						iState = STATE_CHASE;
						GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
					}
					else
					{
						// WHAT DA FUUUUUUUUUUUQ. TARGET ISN'T VALID. AUSDHASUIHD
						iState = STATE_ALERT;
						if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
						g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
						g_flNPCAutoChaseSprinterCooldown[iBossIndex] = GetGameTime() + 5.0;
						if (NPCHasAttribute(iBossIndex, "chase target on scare"))
						{
							g_bNPCLostChasingScareVictim[iBossIndex] = true;
							g_bNPCChasingScareVictin[iBossIndex] = false;
						}
						if (NPCHasAttribute(iBossIndex, "alert copies") || NPCHasAttribute(iBossIndex, "alert companions"))
						{
							g_bNPCCopyAlerted[iBossIndex] = false;
						}
					}
				}
			}
		}
	}
	
	if (iState != STATE_STUN)
	{
		if (bStunEnabled)
		{
			if (NPCChaserGetStunHealth(iBossIndex) <= 0 && g_flSlenderNextStunTime[iBossIndex] <= GetGameTime())
			{
				iState = STATE_STUN;
				if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);
			}
			if (SF_IsBoxingMap() && NPCChaserIsBoxingBoss(iBossIndex))
			{
				if (!NPCChaserGetSelfHealState(iBossIndex))
				{
					float flPercent = NPCChaserGetStunInitialHealth(iBossIndex) > 0 ? (NPCChaserGetStunHealth(iBossIndex) / NPCChaserGetStunInitialHealth(iBossIndex)) : 0.0;
					if (flPercent < 0.75 && flPercent >= 0.5 && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsedRage1[iBossIndex])
					{
						if (iDifficulty != 2 && iDifficulty < 2)
						{
							NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
									EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								}
							}
						}
						NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
						SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						NPCSetAddAcceleration(iBossIndex, 100.0);
						/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0] != '\0')
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								if (NPCChaserHasMultiAttackSounds(iBossIndex))
								{
									for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
									{
										if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
										else
										{
											char sAttackString[PLATFORM_MAX_PATH];
											FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
										}
									}
								}
								else
								{
									ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								}
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}*/
						g_bNPCUsedRage1[iBossIndex] = true;
						g_bNPCUsesRageAnimation1[iBossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage1Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageOneTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = null;
							g_hNPCLifeStealTimer[iBossIndex] = null;
							g_hSlenderBackupAtkTimer[iBossIndex] = null;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
					else if (flPercent < 0.5 && flPercent >= 0.25 && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsedRage2[iBossIndex])
					{
						if (iDifficulty != 3 && iDifficulty < 3)
						{
							NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int iBuff = GetRandomInt(1, 3);
									switch (iBuff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
									}
								}
							}
						}
						NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
						char sRageSound2Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sSlenderProfile, "sound_rage_2", sRageSound2Path, sizeof(sRageSound2Path));
						if (sRageSound2Path[0] != '\0') SlenderPerformVoice(iBossIndex, "sound_rage_2", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						else SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						NPCSetAddAcceleration(iBossIndex, 100.0);
						/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0] != '\0')
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								if (NPCChaserHasMultiAttackSounds(iBossIndex))
								{
									for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
									{
										if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
										else
										{
											char sAttackString[PLATFORM_MAX_PATH];
											FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
										}
									}
								}
								else
								{
									ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								}
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}*/
						g_bNPCUsedRage2[iBossIndex] = true;
						g_bNPCUsesRageAnimation2[iBossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage2Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageTwoTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = null;
							g_hNPCLifeStealTimer[iBossIndex] = null;
							g_hSlenderBackupAtkTimer[iBossIndex] = null;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
					else if (flPercent < 0.25 && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsedRage3[iBossIndex])
					{
						if (iDifficulty != 4 && iDifficulty < 4)
						{
							NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
							for (int client = 1; client <= MaxClients; client++)
							{
								if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
								{
									int iBuff = GetRandomInt(1, 4);
									switch (iBuff)
									{
										case 1:
										{
											TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 2:
										{
											TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
											EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
										}
										case 3:
										{
											TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(sSlenderProfile, "rage_timer", 0.0));
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
						NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
						char sRageSound3Path[PLATFORM_MAX_PATH];
						GetRandomStringFromProfile(sSlenderProfile, "sound_rage_3", sRageSound3Path, sizeof(sRageSound3Path));
						if (sRageSound3Path[0] != '\0') SlenderPerformVoice(iBossIndex, "sound_rage_3", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						else SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						NPCSetAddSpeed(iBossIndex, 12.5);
						NPCSetAddMaxSpeed(iBossIndex, 25.0);
						NPCSetAddAcceleration(iBossIndex, 100.0);
						/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
						{
							char sRageSoundPath[PLATFORM_MAX_PATH];
							GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
							if (sRageSoundPath[0] != '\0')
							{
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
								if (NPCChaserHasMultiAttackSounds(iBossIndex))
								{
									for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
									{
										if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
										else
										{
											char sAttackString[PLATFORM_MAX_PATH];
											FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
										}
									}
								}
								else
								{
									ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
								}
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
								ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
							}
						}*/
						g_bNPCUsedRage3[iBossIndex] = true;
						g_bNPCUsesRageAnimation3[iBossIndex] = true;
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
						NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						g_hSlenderRage3Timer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "rage_timer", 0.0), Timer_SlenderRageThreeTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = null;
							g_hNPCLifeStealTimer[iBossIndex] = null;
							g_hSlenderBackupAtkTimer[iBossIndex] = null;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
				}
				else
				{
					float flPercent = NPCChaserGetStunInitialHealth(iBossIndex) > 0 ? (NPCChaserGetStunHealth(iBossIndex) / NPCChaserGetStunInitialHealth(iBossIndex)) : 0.0;
					if (flPercent < NPCChaserGetStartSelfHealPercentage(iBossIndex) && g_iNPCSelfHealStage[iBossIndex] < 3)
					{
						if (g_bNPCRunningToHeal[iBossIndex] || g_bNPCHealing[iBossIndex])
						{
							iOldTarget = iTarget;
							iTarget = INVALID_ENT_REFERENCE;
							g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
						}
						float flDelayTimer1 = GetProfileFloat(sSlenderProfile, "flee_delay_time", 0.0);
						float flDelayTimer2 = GetProfileFloat(sSlenderProfile, "flee_delay_time_two", flDelayTimer1);
						float flDelayTimer3 = GetProfileFloat(sSlenderProfile, "flee_delay_time_three", flDelayTimer2);
						if (g_bNPCRunningToHeal[iBossIndex] && !g_bNPCSetHealDestination[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							float flMin = GetProfileFloat(sSlenderProfile, "heal_time_min", 3.0);
							float flMax = GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5);
							g_flNPCFleeHealTimer[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
							
							// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
							// If the position can't be reached, then just get to the closest area that we can get.
							float flWanderRangeMin = GetProfileFloat(sSlenderProfile, "heal_range_min", 600.0);
							float flWanderRangeMax = GetProfileFloat(sSlenderProfile, "heal_range_max", 1200.0);
							float flWanderRange = GetRandomFloat(flWanderRangeMin, flWanderRangeMax);
							
							float flFleePos[3];
							flFleePos[0] = 0.0;
							flFleePos[1] = GetRandomFloat(0.0, 360.0);
							flFleePos[2] = 0.0;
							
							GetAngleVectors(flFleePos, flFleePos, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flFleePos, flFleePos);
							ScaleVector(flFleePos, flWanderRange);
							AddVectors(flFleePos, flMyPos, flFleePos);
							
							g_flSlenderGoalPos[iBossIndex][0] = flFleePos[0];
							g_flSlenderGoalPos[iBossIndex][1] = flFleePos[1];
							g_flSlenderGoalPos[iBossIndex][2] = flFleePos[2];
							
							if (!g_bNPCHasCloaked[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex) && NPCChaserCanCloakToHeal(iBossIndex))
							{
								//Time for a more cloaking aproach!
								SetEntityRenderMode(slender, view_as<RenderMode>(GetProfileNum(sSlenderProfile, "cloak_rendermode", 1)));
							
								int iCloakColor[4];
								GetProfileColor(sSlenderProfile, "cloak_rendercolor", iCloakColor[0], iCloakColor[1], iCloakColor[2], iCloakColor[3], 
								g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);

								SetEntityRenderColor(slender, iCloakColor[0], iCloakColor[1], iCloakColor[2], iCloakColor[3]);
								g_bNPCHasCloaked[iBossIndex] = true;
								g_flNPCNextDecloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakDuration(iBossIndex, iDifficulty);
								SlenderToggleParticleEffects(slender);
								GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
								if (sCloakParticle[0] == '\0')
								{
									sCloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
								EmitSoundToAll(g_sSlenderCloakOnSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								Call_StartForward(fOnBossCloaked);
								Call_PushCell(iBossIndex);
								Call_Finish();
							}
							
							g_bNPCSetHealDestination[iBossIndex] = true;
						}
						if (!g_pPath[iBossIndex].IsValid()) g_bNPCSetHealDestination[iBossIndex] = false;
						if ((GetVectorSquareMagnitude(g_flSlenderGoalPos[iBossIndex], flMyPos) < SquareFloat(125.0) || g_flNPCFleeHealTimer[iBossIndex] < GetGameTime()) && g_bNPCSetHealDestination[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							if (g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
							{
								SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
								SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
								
								g_bNPCHasCloaked[iBossIndex] = false;
								SlenderToggleParticleEffects(slender, true);
								GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
								if (sCloakParticle[0] == '\0')
								{
									sCloakParticle = "drg_cow_explosioncore_charged_blue";
								}
								SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
								EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
								Call_StartForward(fOnBossDecloaked);
								Call_PushCell(iBossIndex);
								Call_Finish();
							}
							float flTimer = GetProfileFloat(sSlenderProfile, "heal_timer_animation", 0.0);
							g_iNPCHealCount[iBossIndex] = 0;
							g_bNPCUsesHealAnimation[iBossIndex] = true;
							g_bNPCRunningToHeal[iBossIndex] = false;
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
							g_hSlenderHealTimer[iBossIndex] = CreateTimer(flTimer, Timer_SlenderHealAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_hSlenderHealDelayTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "heal_timer", flTimer), Timer_SlenderHealDelayTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_bNPCHealing[iBossIndex] = true;
							NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
						}
						if (!g_bNPCUseStartFleeAnimation[iBossIndex] && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
						{
							switch (g_iNPCSelfHealStage[iBossIndex])
							{
								case 0:
								{
									if (iDifficulty != 2 && iDifficulty < 2)
									{
										NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer1);
												EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
											}
										}
									}
									NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer1, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_iNPCHealCount[iBossIndex] = 0;
									SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									NPCSetAddAcceleration(iBossIndex, 100.0);
									/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0] != '\0')
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											if (NPCChaserHasMultiAttackSounds(iBossIndex))
											{
												for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
												{
													if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
													else
													{
														char sAttackString[PLATFORM_MAX_PATH];
														FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
														ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
													}
												}
											}
											else
											{
												ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											}
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}*/
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
								case 1:
								{
									if (iDifficulty != 3 && iDifficulty < 3)
									{
										NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int iBuff = GetRandomInt(1, 3);
												switch (iBuff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritCola, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer2);
														EmitSoundToClient(client, MINICRIT_BUFF, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
												}
											}
										}
									}
									NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer2, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_iNPCHealCount[iBossIndex] = 0;
									char sRageSound2Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(sSlenderProfile, "sound_rage_2", sRageSound2Path, sizeof(sRageSound2Path));
									if (sRageSound2Path[0] != '\0') SlenderPerformVoice(iBossIndex, "sound_rage_2", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									else SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									NPCSetAddAcceleration(iBossIndex, 100.0);
									/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0] != '\0')
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											if (NPCChaserHasMultiAttackSounds(iBossIndex))
											{
												for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
												{
													if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
													else
													{
														char sAttackString[PLATFORM_MAX_PATH];
														FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
														ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
													}
												}
											}
											else
											{
												ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											}
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}*/
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
								case 2:
								{
									if (iDifficulty != 4 && iDifficulty < 4)
									{
										NPCChaserSetBoxingDifficulty(iBossIndex, NPCChaserGetBoxingDifficulty(iBossIndex)+1);
										for (int client = 1; client <= MaxClients; client++)
										{
											if (IsValidClient(client) && !g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red)
											{
												int iBuff = GetRandomInt(1, 4);
												switch (iBuff)
												{
													case 1:
													{
														TF2_AddCondition(client, TFCond_CritOnFirstBlood, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
														EmitSoundToClient(client, CRIT_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 2:
													{
														TF2_AddCondition(client, TFCond_HalloweenQuickHeal, 5.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
														EmitSoundToClient(client, UBER_ROLL, client, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
													}
													case 3:
													{
														TF2_AddCondition(client, TFCond_DefenseBuffed, 8.0 + GetProfileFloat(sSlenderProfile, "heal_time_max", 4.5) + flDelayTimer3);
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
									NPCChaserSetBoxingRagePhase(iBossIndex, NPCChaserGetBoxingRagePhase(iBossIndex)+1);
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									g_hSlenderStartFleeTimer[iBossIndex] = CreateTimer(flDelayTimer3, Timer_SlenderFleeAnimationTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									g_iNPCHealCount[iBossIndex] = 0;
									char sRageSound3Path[PLATFORM_MAX_PATH];
									GetRandomStringFromProfile(sSlenderProfile, "sound_rage_3", sRageSound3Path, sizeof(sRageSound3Path));
									if (sRageSound3Path[0] != '\0') SlenderPerformVoice(iBossIndex, "sound_rage_3", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									else SlenderPerformVoice(iBossIndex, "sound_rage", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
									NPCSetAddSpeed(iBossIndex, 12.5);
									NPCSetAddMaxSpeed(iBossIndex, 25.0);
									NPCSetAddAcceleration(iBossIndex, 100.0);
									/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
									{
										char sRageSoundPath[PLATFORM_MAX_PATH];
										GetRandomStringFromProfile(sSlenderProfile, "sound_rage", sRageSoundPath, sizeof(sRageSoundPath));
										if (sRageSoundPath[0] != '\0')
										{
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
											if (NPCChaserHasMultiAttackSounds(iBossIndex))
											{
												for (int i = 0; i < NPCChaserGetAttackCount(iBossIndex); i++)
												{
													if (i == 0) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
													else
													{
														char sAttackString[PLATFORM_MAX_PATH];
														FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", i+1);
														ClientStopAllSlenderSounds(slender, sSlenderProfile, sAttackString, SNDCHAN_AUTO);
													}
												}
											}
											else
											{
												ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_attackenemy", SNDCHAN_AUTO);
											}
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
											ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
										}
									}*/
									g_bNPCUseStartFleeAnimation[iBossIndex] = true;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
								}
							}
						}
						if (g_bSlenderAttacking[iBossIndex])
						{
							// Cancel attacking.
							g_bSlenderAttacking[iBossIndex] = false;
							g_bNPCStealingLife[iBossIndex] = false;
							g_hSlenderAttackTimer[iBossIndex] = null;
							g_hNPCLifeStealTimer[iBossIndex] = null;
							g_hSlenderBackupAtkTimer[iBossIndex] = null;
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							g_bNPCUseFireAnimation[iBossIndex] = false;
						}
					}
				}
			}
		}
	}
	
	if (!IsValidClient(iTarget) && g_bSlenderTeleportTargetIsCamping[iBossIndex] && g_iSlenderTeleportTarget[iBossIndex] != INVALID_ENT_REFERENCE) //We spawned, and our target is a camper kill him!
	{
		int iCampingTarget = EntRefToEntIndex(g_iSlenderTeleportTarget[iBossIndex]);
		if (MaxClients >= iCampingTarget > 0 && IsTargetValidForSlender(iCampingTarget))
		{
			g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iCampingTarget);
			iState = STATE_CHASE;
			GetClientAbsOrigin(iCampingTarget, g_flSlenderGoalPos[iBossIndex]);
		}
		g_bSlenderTeleportTargetIsCamping[iBossIndex] = false;
	}

	if (NPCChaserCanChaseOnLook(iBossIndex) && g_aNPCChaseOnLookTarget[iBossIndex].Length > 0 && IsValidClient(iTarget) && iState != STATE_ATTACK && iState != STATE_STUN)
	{
		g_bAutoChasingLoudPlayer[iBossIndex] = true;
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iState = STATE_CHASE;
		GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
	}
	if ((SF_IsRaidMap() || SF_IsProxyMap() || SF_IsBoxingMap() || SF_BossesChaseEndlessly() || g_bNPCChasesEndlessly[iBossIndex] || SF_IsSlaughterRunMap()) && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && !g_bSlenderGiveUp[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iState = STATE_CHASE;
		GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
	}
	if ((SF_IsRaidMap() || SF_IsBoxingMap()) && (g_bNPCRunningToHeal[iBossIndex] || g_bNPCHealing[iBossIndex]))
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iState = STATE_CHASE;
	}
	if (NPCHasAttribute(iBossIndex, "chase target on scare") && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && g_bPlayerScaredByBoss[iTarget][iBossIndex] && !g_bNPCChasingScareVictin[iBossIndex] && !g_bNPCLostChasingScareVictim[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_bNPCChasingScareVictin[iBossIndex] = true;
		g_bPlayerScaredByBoss[iTarget][iBossIndex] = false;
		iState = STATE_CHASE;
		GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
	}
	if (IsValidClient(iBestNewTarget) && (bPlayerInTrap[iBestNewTarget] || bPlayerMadeNoise[iBestNewTarget]) && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
		iTarget = iBestNewTarget;
		g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iTarget);
		iState = STATE_CHASE;
		GetClientAbsOrigin(iBestNewTarget, g_flSlenderGoalPos[iBossIndex]);
	}
	// Finally, set our new state.
	g_iSlenderState[iBossIndex] = iState;
	
	if (iOldState != iState)
	{
		g_pPath[iBossIndex].Invalidate();
		
		switch (iState)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
				g_flSlenderTimeUntilIdle[iBossIndex] = 0.0;
				g_flSlenderTimeUntilAlert[iBossIndex] = 0.0;
				g_flSlenderTimeUntilChase[iBossIndex] = 0.0;
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				g_bNPCLostChasingScareVictim[iBossIndex] = false;
				g_bNPCChasingScareVictin[iBossIndex] = false;
				
				if (iOldState != STATE_IDLE && iOldState != STATE_WANDER)
				{
					g_iSlenderTargetSoundCount[iBossIndex] = 0;
					g_bSlenderInvestigatingSound[iBossIndex] = false;
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = -1.0;
					
					g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + NPCGetIdleLifetime(iBossIndex, iDifficulty);
				}
				
				if (g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
				{
					SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
					SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);
					g_bNPCHasCloaked[iBossIndex] = false;
					SlenderToggleParticleEffects(slender, true);
					GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
					if (sCloakParticle[0] == '\0')
					{
						sCloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
					EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
					Call_StartForward(fOnBossDecloaked);
					Call_PushCell(iBossIndex);
					Call_Finish();
				}
				
				if (iState == STATE_WANDER)
				{
					// Force new wander position.
					for (int iDifficulty3; iDifficulty3 < Difficulty_Max; iDifficulty3++)g_flSlenderNextWanderPos[iBossIndex][iDifficulty3] = -1.0;
				}
			}
			
			case STATE_ALERT:
			{
				g_bSlenderGiveUp[iBossIndex] = false;
				
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				
				// Set our goal position.
				if (g_bSlenderInvestigatingSound[iBossIndex])
				{
					g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
					g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
					g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
				}
				
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + NPCChaserGetAlertDuration(iBossIndex, iDifficulty);
				g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
				g_bNPCLostChasingScareVictim[iBossIndex] = false;
				g_flSlenderTimeUntilChase[iBossIndex] = GetGameTime() + NPCChaserGetAlertGracetime(iBossIndex, iDifficulty);
				
				if (g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
				{
					SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
					SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);
					
					g_bNPCHasCloaked[iBossIndex] = false;
					SlenderToggleParticleEffects(slender, true);
					GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
					if (sCloakParticle[0] == '\0')
					{
						sCloakParticle = "drg_cow_explosioncore_charged_blue";
					}
					SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
					EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
					Call_StartForward(fOnBossDecloaked);
					Call_PushCell(iBossIndex);
					Call_Finish();
				}
			}
			case STATE_CHASE, STATE_ATTACK:
			{
				g_bSlenderInvestigatingSound[iBossIndex] = false;
				g_iSlenderTargetSoundCount[iBossIndex] = 0;
				
				if (iOldState != STATE_ATTACK && iOldState != STATE_CHASE && iOldState != STATE_STUN)
				{
					g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
					g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
					g_iSlenderAutoChaseCount[iBossIndex] = 0;
					g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
					
					float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init", 5.0);
					if (flPersistencyTime >= 0.0)
					{
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
					}
				}
				
				if (iState == STATE_ATTACK)
				{
					if (g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex])
					{
						iState = iOldState;
					}
					else
					{
						g_bSlenderAttacking[iBossIndex] = true;
						npcEntity.RemoveAllGestures();
						CBaseNPC_RemoveAllLayers(slender);
						loco.ClearStuckStatus();
						int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
						if (!NPCChaserGetAttackWhileRunningState(iBossIndex, iAttackIndex))
						{
							npc.flWalkSpeed = 0.0;
							npc.flRunSpeed = 0.0;
						}
						if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_ExplosiveDance && NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_LaserBeam)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							g_bNPCAlreadyAttacked[iBossIndex] = false;
							NPCSetCurrentAttackRepeat(iBossIndex, iAttackIndex, 0);
							NPCChaserSetNextAttackTime(iBossIndex, iAttackIndex, GetGameTime() + NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex, iDifficulty));
						}
						else if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_ExplosiveDance)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderPrepareExplosiveDance, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
							NPCChaserSetNextAttackTime(iBossIndex, iAttackIndex, GetGameTime() + NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex, iDifficulty));
						}
						else if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam)
						{
							g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackBeginLaser, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						}
						if (NPCChaserGetAttackLifeStealState(iBossIndex, iAttackIndex))
						{
							if (!g_bNPCStealingLife[iBossIndex])
							{
								g_hNPCLifeStealTimer[iBossIndex] = CreateTimer(0.5, Timer_SlenderStealLife, EntIndexToEntRef(slender), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
								g_bNPCStealingLife[iBossIndex] = true;
							}
						}
						
						g_flSlenderTimeUntilAttackEnd[iBossIndex] = GetGameTime() + NPCChaserGetAttackDuration(iBossIndex, iAttackIndex) + 0.01;
						
						g_flNPCBaseAttackRunDurationTime[iBossIndex][iAttackIndex] = GetGameTime() + NPCChaserGetAttackRunDuration(iBossIndex, iAttackIndex);
						
						g_flNPCBaseAttackRunDelayTime[iBossIndex][iAttackIndex] = GetGameTime() + NPCChaserGetAttackRunDelay(iBossIndex, iAttackIndex);
						
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_attack", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_attack", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
						
						if (g_bNPCHasCloaked[iBossIndex] && NPCChaserIsCloakEnabled(iBossIndex))
						{
							SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
							SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], 0);
							g_bNPCHasCloaked[iBossIndex] = false;
							SlenderToggleParticleEffects(slender, true);
							GetProfileString(sSlenderProfile, "cloak_particle", sCloakParticle, sizeof(sCloakParticle));
							if (sCloakParticle[0] == '\0')
							{
								sCloakParticle = "drg_cow_explosioncore_charged_blue";
							}
							SlenderCreateParticle(iBossIndex, sCloakParticle, 35.0);
							EmitSoundToAll(g_sSlenderCloakOffSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							g_flSlenderNextCloakTime[iBossIndex] = GetGameTime() + NPCChaserGetCloakCooldown(iBossIndex, iDifficulty);
							Call_StartForward(fOnBossDecloaked);
							Call_PushCell(iBossIndex);
							Call_Finish();
						}
						if (!NPCChaserHasMultiAttackSounds(iBossIndex))
						{
							SlenderPerformVoice(iBossIndex, "sound_attackenemy", iAttackIndex + 1, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
						}
						else
						{
							char sAttackString[PLATFORM_MAX_PATH];
							FormatEx(sAttackString, sizeof(sAttackString), "sound_attackenemy_%i", iAttackIndex+1);
							switch (iAttackIndex)
							{
								case 0: SlenderPerformVoice(iBossIndex, "sound_attackenemy", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
								default: SlenderPerformVoice(iBossIndex, sAttackString, _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
							}
						}
						if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
						loco.ClearStuckStatus();
					}
				}
				else
				{
					if (iOldState != STATE_ATTACK && !bBuilding)
					{
						// Sound handling.
						if (!NPCChaserCanChaseInitialOnStun(iBossIndex))
						{
							if (iOldState != STATE_STUN)
							{
								SlenderPerformVoice(iBossIndex, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
								if (NPCChaserCanUseChaseInitialAnimation(iBossIndex) && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !SF_IsSlaughterRunMap())
								{
									if (g_hSlenderChaseInitialTimer[iBossIndex] == null && g_aNPCChaseOnLookTarget[iBossIndex].Length <= 0)
									{
										g_bNPCUsesChaseInitialAnimation[iBossIndex] = true;
										npc.flWalkSpeed = 0.0;
										npc.flRunSpeed = 0.0;
										NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
										g_hSlenderChaseInitialTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
									}
								}
							}
						}
						else
						{
							SlenderPerformVoice(iBossIndex, "sound_chaseenemyinitial", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
							if (NPCChaserCanUseChaseInitialAnimation(iBossIndex) && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !SF_IsSlaughterRunMap())
							{
								if (g_hSlenderChaseInitialTimer[iBossIndex] == null && g_aNPCChaseOnLookTarget[iBossIndex].Length <= 0)
								{
									g_bNPCUsesChaseInitialAnimation[iBossIndex] = true;
									npc.flWalkSpeed = 0.0;
									npc.flRunSpeed = 0.0;
									NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
									g_hSlenderChaseInitialTimer[iBossIndex] = CreateTimer(GetProfileFloat(sSlenderProfile, "chase_initial_timer", 0.0), Timer_SlenderChaseInitialTimer, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
								}
							}
						}
					}
				}
			}
		}
		NPCChaserSetState(iBossIndex, iState);
		// Call our forward.
		Call_StartForward(fOnBossChangeState);
		Call_PushCell(iBossIndex);
		Call_PushCell(iOldState);
		Call_PushCell(iState);
		Call_Finish();
		/*if (NPCChaserNormalSoundHookEnabled(iBossIndex))
		{
			switch (iOldState)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					if (iState != STATE_IDLE && iState != STATE_WANDER) ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_idle", SNDCHAN_AUTO);
				}
				case STATE_ALERT: ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_alertofenemy", SNDCHAN_AUTO);
				case STATE_CHASE:
				{
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chasingenemy", SNDCHAN_AUTO);
					ClientStopAllSlenderSounds(slender, sSlenderProfile, "sound_chaseenemyinitial", SNDCHAN_AUTO);
				}
			}
			switch (iState)
			{
				case STATE_IDLE, STATE_WANDER:
				{
					if (iOldState != STATE_IDLE && iOldState != STATE_WANDER) SlenderPerformVoice(iBossIndex, "sound_idle", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
				}
				case STATE_ALERT: SlenderPerformVoice(iBossIndex, "sound_alertofenemy", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
				case STATE_CHASE:
				{
					char sChaseSoundPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, "sound_chaseenemyinitial", sChaseSoundPath, sizeof(sChaseSoundPath));
					if (sChaseSoundPath[0] == '\0' && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
					{
						SlenderPerformVoice(iBossIndex, "sound_chasingenemy", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
					}
				}
			}
		}*/
		if (NPCChaserNormalSoundHookEnabled(iBossIndex)) g_flSlenderNextVoiceSound[iBossIndex] = 0.0;
	}
	
	if (iOldState != iState && !g_bSlenderSpawning[iBossIndex])
		NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);

	if (g_bNPCChangeToCrawl[iBossIndex] && (iState == STATE_CHASE || iState == STATE_WANDER || iState == STATE_ALERT))
	{
		NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
		g_bNPCChangeToCrawl[iBossIndex] = false;
	}
	
	if (NPCChaserOldAnimationAIEnabled(iBossIndex))
	{
		float flSlenderVelocity, flReturn;
		flSlenderVelocity = loco.GetGroundSpeed();
		flReturn = flSlenderVelocity / GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed");
		if (GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed") != 0.0 && GetEntPropFloat(slender, Prop_Data, "m_flGroundSpeed") > 10.0)
		{
			if (loco.IsOnGround())
			{
				if (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) || iState == STATE_ALERT)
				{
					float flPlaybackSpeed = flReturn;
					if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
					if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
				}
				if (iState == STATE_CHASE && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				{
					float flPlaybackSpeed = flReturn;
					if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
					if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
				}
			}
		}
		else
		{
			float flSlenderVelocityOld;
			float flVelocity, flWalkVelocity, flGeneralVel;
			flSlenderVelocityOld = loco.GetGroundSpeed();
			flGeneralVel = flSlenderVelocityOld;
			if (g_flSlenderCalculatedSpeed[iBossIndex] <= 0.0) flVelocity = 0.0;
			else flVelocity = (flGeneralVel + ((g_flSlenderCalculatedSpeed[iBossIndex] * g_flRoundDifficultyModifier)/15))/g_flSlenderCalculatedSpeed[iBossIndex];
			
			if (g_flSlenderCalculatedWalkSpeed[iBossIndex] <= 0.0) flWalkVelocity = 0.0;
			else flWalkVelocity = (flGeneralVel + ((g_flSlenderCalculatedWalkSpeed[iBossIndex] * g_flRoundDifficultyModifier)/15))/g_flSlenderCalculatedWalkSpeed[iBossIndex];
			if (loco.IsOnGround())
			{
				if (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) || iState == STATE_ALERT)
				{
					float flPlaybackSpeed = flWalkVelocity * g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex];
					if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
					if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
				}
				if (iState == STATE_CHASE && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				{
					float flPlaybackSpeed = flVelocity * g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex];
					if (flPlaybackSpeed > 12.0) flPlaybackSpeed = 12.0;
					if (flPlaybackSpeed < -4.0) flPlaybackSpeed = -4.0;
					SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", flPlaybackSpeed);
				}
			}
		}
	}

	switch (iState)
	{
		case STATE_WANDER, STATE_ALERT, STATE_CHASE, STATE_ATTACK:
		{
			// These deal with movement, therefore we need to set our 
			// destination first. That is, if we don't have one. (nav mesh only)
			
			if (iState == STATE_WANDER)
			{
				if (GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex][iDifficulty])
				{
					float flMin = GetChaserProfileWanderTimeMin(NPCGetUniqueProfileIndex(iBossIndex), iDifficulty);
					float flMax = GetChaserProfileWanderTimeMax(NPCGetUniqueProfileIndex(iBossIndex), iDifficulty);
					g_flSlenderNextWanderPos[iBossIndex][iDifficulty] = GetGameTime() + GetRandomFloat(flMin, flMax);
					
					if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
					{
						// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
						// If the position can't be reached, then just get to the closest area that we can get.
						float flWanderRangeMin = NPCChaserGetWanderRangeMin(iBossIndex, iDifficulty);
						float flWanderRangeMax = NPCChaserGetWanderRangeMax(iBossIndex, iDifficulty);
						float flWanderRange = GetRandomFloat(flWanderRangeMin, flWanderRangeMax);
						
						float flWanderPos[3];

						flWanderPos[0] = flMyPos[0] + GetRandomFloat(-flWanderRange, flWanderRange);
						flWanderPos[1] = flMyPos[1] + GetRandomFloat(-flWanderRange, flWanderRange);
						flWanderPos[2] = flMyPos[2];

						CNavArea cZArea = TheNavMesh.GetNearestNavArea(flWanderPos, _, flWanderRange);
						if (cZArea != NULL_AREA) flWanderPos[2] = cZArea.GetZ(flWanderPos[0], flWanderPos[1]);

						g_flSlenderGoalPos[iBossIndex][0] = flWanderPos[0];
						g_flSlenderGoalPos[iBossIndex][1] = flWanderPos[1];
						g_flSlenderGoalPos[iBossIndex][2] = flWanderPos[2];
						
						g_flSlenderNextPathTime[iBossIndex] = -1.0; // We're not going to wander around too much, so no need for a time constraint.
					}
				}
			}
			else if (iState == STATE_ALERT)
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidEntity(iBestNewTarget))
					{
						if ((bBuilding) || (((bPlayerInFOV[iBestNewTarget] || bPlayerNear[iBestNewTarget]) && bPlayerVisible[iBestNewTarget]) || (bPlayerMadeNoise[iBestNewTarget] || bPlayerInTrap[iBestNewTarget])))
						{
							// Constantly update my path if I see him.
							if (GetGameTime() >= g_flSlenderNextPathTime[iBossIndex])
							{
								GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
								g_flSlenderNextPathTime[iBossIndex] = GetGameTime() + 0.4;
							}
						}
					}
				}
			}
			else if ((iState == STATE_CHASE || iState == STATE_ATTACK) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
			{
				if (IsValidEntity(iBestNewTarget))
				{
					iOldTarget = iTarget;
					iTarget = iBestNewTarget;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				}
				
				if (iTarget != INVALID_ENT_REFERENCE)
				{
					if (iOldTarget != iTarget)
					{
						// Brand new target! We need a path, and we need to reset our persistency, if needed.
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_newtarget", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_newtarget", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
						
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
					else if ((bBuilding) || ((bPlayerInFOV[iTarget] && bPlayerVisible[iTarget]) || GetGameTime() < g_flSlenderTimeUntilNoPersistence[iBossIndex]))
					{
						// Constantly update my path if I see him or if I'm still being persistent.
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
				}
				if (NPCChaserGetTeleporter(iBossIndex, 0) != INVALID_ENT_REFERENCE)
				{
					int iTeleporter = EntRefToEntIndex(NPCChaserGetTeleporter(iBossIndex, 0));
					if (IsValidEntity(iTeleporter) && iTeleporter > MaxClients)
						GetEntPropVector(iTeleporter, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
				}
			}
			if ((!g_bSlenderInDeathcam[iBossIndex] && (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				 || (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				 || (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0)
				 || (iState == STATE_ATTACK)))
			{
				g_pPath[iBossIndex].ComputeToPos(bot, g_flSlenderGoalPos[iBossIndex], 9999999999.0);
			}
			if (iState == STATE_CHASE || iState == STATE_ATTACK)
			{
				if (IsValidClient(iTarget))
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(iTarget, DEBUG_BOSS_CHASE, 1, "g_flSlenderTimeUntilAlert[%d]: %f\ng_flSlenderTimeUntilNoPersistence[%d]: %f", iBossIndex, g_flSlenderTimeUntilAlert[iBossIndex] - GetGameTime(), iBossIndex, g_flSlenderTimeUntilNoPersistence[iBossIndex] - GetGameTime());
					#endif
					
					if ((bBuilding || (bPlayerInFOV[iTarget] && bPlayerVisible[iTarget])) && !g_bNPCUsesChaseInitialAnimation[iBossIndex])
					{
						float flDistRatio = (flPlayerDists[iTarget] / SquareFloat(NPCGetSearchRadius(iBossIndex, iDifficulty)));
						
						float flChaseDurationTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_min", 0.025);
						float flChaseDurationTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_max", 0.2);
						
						float flChaseDurationAdd = flChaseDurationTimeAddMax - ((flChaseDurationTimeAddMax - flChaseDurationTimeAddMin) * flDistRatio);
						
						if (flChaseDurationAdd > 0.0)
						{
							g_flSlenderTimeUntilAlert[iBossIndex] += flChaseDurationAdd;
							if (g_flSlenderTimeUntilAlert[iBossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty)))
							{
								g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
							}
						}
						
						float flPersistencyTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_min", 0.05);
						float flPersistencyTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_max", 0.15);
						
						float flPersistencyTimeAdd = flPersistencyTimeAddMax - ((flPersistencyTimeAddMax - flPersistencyTimeAddMin) * flDistRatio);
						
						if (flPersistencyTimeAdd > 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTimeAdd;
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] > (GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty)))
							{
								g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + NPCChaserGetChaseDuration(iBossIndex, iDifficulty);
							}
						}
					}
				}
			}
		}
	}

	bool bChangeAngle = false;
	float vecPosToAt[3];
	if (iState != STATE_STUN && !g_bSlenderSpawning[iBossIndex])
	{
		if (g_bNPCAlwaysLookAtTarget[iBossIndex])
		{
			if (iTarget && iTarget != INVALID_ENT_REFERENCE)
			{
				bChangeAngle = true;
				GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
			}
		}
		else
		{
			switch (iState)
			{
				case STATE_CHASE:
				{
					if (g_bNPCAlwaysLookAtTargetWhileChasing[iBossIndex] || g_bSlenderTargetIsVisible[iBossIndex])
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);

						}
					}
					
					if (g_bNPCUsesChaseInitialAnimation[iBossIndex] || g_bNPCUsesRageAnimation1[iBossIndex] || g_bNPCUsesRageAnimation2[iBossIndex] || g_bNPCUsesRageAnimation3[iBossIndex] || g_bNPCUseStartFleeAnimation[iBossIndex])
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
					if (!loco.IsOnGround() || loco.IsClimbingOrJumping())
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							float vecTargetPos[3], vecMyEyePos[3];
							NPCGetEyePosition(iBossIndex, vecMyEyePos);
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
							vecTargetPos[2] += 18.0;
							if (GetVectorSquareMagnitude(vecTargetPos, vecMyEyePos) <= SquareFloat(400.0))
							{
								bChangeAngle = true;
								GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
							}
						}
					}
				}
				case STATE_ATTACK:
				{
					int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
					if (g_bNPCAlwaysLookAtTargetWhileAttacking[iBossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, iAttackIndex) && ((NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_LaserBeam)))
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
					if (!NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, iAttackIndex) && (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam))
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
				}
			}
		}
	}
	
	if (bChangeAngle)
	{
		loco.FaceTowards(vecPosToAt);
	}

	// Sound handling.
	if (GetGameTime() >= g_flSlenderNextVoiceSound[iBossIndex])
	{
		switch (iState)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				SlenderPerformVoice(iBossIndex, "sound_idle", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
			}
			case STATE_ALERT:
			{
				SlenderPerformVoice(iBossIndex, "sound_alertofenemy", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
			}
			case STATE_CHASE:
			{
				if (!g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex]) SlenderPerformVoice(iBossIndex, "sound_chasingenemy", _, NPCChaserNormalSoundHookEnabled(iBossIndex) ? SNDCHAN_VOICE : SNDCHAN_AUTO);
			}
		}
	}
	
	//Footstep handling.
	switch (iState)
	{
		case STATE_IDLE:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepIdleSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_WANDER, STATE_ALERT:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepWalkSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_CHASE:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepRunSound[iBossIndex] && !g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_STUN:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepStunSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
		case STATE_ATTACK:
		{
			if (GetGameTime() >= g_flSlenderNextFootstepAttackSound[iBossIndex]) SlenderCastFootstep(iBossIndex, "sound_footsteps");
		}
	}
	
	// Reset our interrupt conditions.
	g_iSlenderInterruptConditions[iBossIndex] = 0;
	
	return Plugin_Continue;
}

public Action Timer_SlenderPublicDeathCamThink(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderEntityThink[iBossIndex]) return Plugin_Stop;

	if (!g_bSlenderInDeathcam[iBossIndex]) return Plugin_Stop;

	int iClient = EntRefToEntIndex(g_iSlenderDeathCamTarget[iBossIndex]);

	if (!IsValidClient(iClient) || (IsValidClient(iClient) && (!IsPlayerAlive(iClient) || g_bPlayerEliminated[iClient] || GetClientTeam(iClient) == TFTeam_Blue)))
	{
		if (g_hSlenderDeathCamTimer[iBossIndex] != null) TriggerTimer(g_hSlenderDeathCamTimer[iBossIndex]);
		else
		{
			if ((NPCGetFlags(iBossIndex) & SFF_FAKE))
			{
				if (g_bSlenderInDeathcam[iBossIndex])
				{
					g_bSlenderInDeathcam[iBossIndex] = false;
				}
				SlenderMarkAsFake(iBossIndex);
			}
			else
			{
				SetEntityRenderMode(slender, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
				if (!NPCChaserIsCloaked(iBossIndex)) SetEntityRenderColor(slender, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
				g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				g_bSlenderInDeathcam[iBossIndex] = false;
				NPCChaserUpdateBossAnimation(iBossIndex, slender, g_iSlenderState[iBossIndex]);
			}
		}
	}

	return Plugin_Continue;
}