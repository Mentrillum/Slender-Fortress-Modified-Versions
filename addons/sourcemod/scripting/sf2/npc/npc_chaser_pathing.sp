#if defined _sf2_npc_chaser_pathing_included
 #endinput
#endif
#define _sf2_npc_chaser_pathing_included

public void SlenderChaseBossProcessMovement(int iBoss)
{
	if (!g_bEnabled) return;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(iBoss);
	if (npc == INVALID_NPC)
	{
		SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement); //What no boss?
		return;
	}

	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);
		return;
	}

	INextBot bot = npc.GetBot();
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	CBaseCombatCharacter combatChar = CBaseCombatCharacter(iBoss);
	combatChar.DispatchAnimEvents(combatChar);

	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	float flMyPos[3], flMyEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);

	int iState = g_iSlenderState[iBossIndex];
	int iOldState = g_iSlenderOldState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;
	
	int difficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	if (!g_bSlenderInDeathcam[iBossIndex])
	{
		switch (iState)
		{
			case STATE_WANDER, STATE_ALERT:
			{
				if (npc != INVALID_NPC) npc.flWalkSpeed = g_flSlenderCalculatedWalkSpeed[iBossIndex];
				if (npc != INVALID_NPC) npc.flRunSpeed = g_flSlenderCalculatedWalkSpeed[iBossIndex];
				loco.SetSpeedLimit(g_flSlenderCalculatedMaxWalkSpeed[iBossIndex]);
			}
			case STATE_CHASE:
			{
				if (!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex]
					&& !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex]
					&& !g_bNPCUsesHealAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
				{
					if (npc != INVALID_NPC) npc.flWalkSpeed = g_flSlenderCalculatedSpeed[iBossIndex];
					if (npc != INVALID_NPC) npc.flRunSpeed = g_flSlenderCalculatedSpeed[iBossIndex];
				}
				else
				{
					if (npc != INVALID_NPC) npc.flWalkSpeed = 0.0;
					if (npc != INVALID_NPC) npc.flRunSpeed = 0.0;
				}
				loco.SetSpeedLimit(g_flSlenderCalculatedMaxSpeed[iBossIndex]);
			}
			case STATE_ATTACK:
			{
				int iCurrentAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
				if (NPCChaserGetAttackWhileRunningState(iBossIndex, iCurrentAttackIndex) && 
					!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && 
					!g_bNPCUsesRageAnimation3[iBossIndex] && GetGameTime() >= g_flNPCBaseAttackRunDelayTime[iBossIndex][iCurrentAttackIndex])
				{
					if (NPCChaserGetAttackRunDuration(iBossIndex, iCurrentAttackIndex) > 0.0)
					{
						if (GetGameTime() < g_flNPCBaseAttackRunDurationTime[iBossIndex][iCurrentAttackIndex])
						{
							float flAttackSpeed, flOriginalSpeed;
							flOriginalSpeed = NPCChaserGetAttackRunSpeed(iBossIndex, iCurrentAttackIndex, difficulty);
							if (g_flRoundDifficultyModifier > 1.0)
							{
								flAttackSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier) / 15.0) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
							}
							else
							{
								flAttackSpeed = flOriginalSpeed + NPCGetAnger(iBossIndex);
							}
							if (npc != INVALID_NPC) npc.flWalkSpeed = flAttackSpeed * g_flSlenderSpeedMultiplier[iBossIndex];
							if (npc != INVALID_NPC) npc.flRunSpeed = flAttackSpeed * g_flSlenderSpeedMultiplier[iBossIndex];
						}
						else
						{
							if (npc != INVALID_NPC) npc.flWalkSpeed = 0.0;
							if (npc != INVALID_NPC) npc.flRunSpeed = 0.0;
						}
					}
					else
					{
						float flAttackSpeed, flOriginalSpeed;
						flOriginalSpeed = NPCChaserGetAttackRunSpeed(iBossIndex, iCurrentAttackIndex, difficulty);
						if (g_flRoundDifficultyModifier > 1.0)
						{
							flAttackSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier) / 15.0) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);
						}
						else
						{
							flAttackSpeed = flOriginalSpeed + NPCGetAnger(iBossIndex);
						}

						if (npc != INVALID_NPC) npc.flWalkSpeed = flAttackSpeed * g_flSlenderSpeedMultiplier[iBossIndex];
						if (npc != INVALID_NPC) npc.flRunSpeed = flAttackSpeed * g_flSlenderSpeedMultiplier[iBossIndex];
					}
				}
				else
				{
					if (npc != INVALID_NPC) npc.flWalkSpeed = 0.0;
					if (npc != INVALID_NPC) npc.flRunSpeed = 0.0;
				}
				loco.SetSpeedLimit(999999.9);
			}
			case STATE_STUN:
			{
				if (npc != INVALID_NPC) npc.flWalkSpeed = 0.0;
				if (npc != INVALID_NPC) npc.flRunSpeed = 0.0;
			}
		}
	}
	else
	{
		npc.flWalkSpeed = 0.0;
		npc.flRunSpeed = 0.0;
	}
	if (iState == STATE_ATTACK)
	{
		int iCurrentAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
		if (NPCChaserGetAttackWhileRunningState(iBossIndex, iCurrentAttackIndex)) npc.flAcceleration = 99999.9;
		else npc.flAcceleration = g_flSlenderCalculatedAcceleration[iBossIndex];
	}
	else npc.flAcceleration = g_flSlenderCalculatedAcceleration[iBossIndex];

	int attackIndex = NPCGetCurrentAttackIndex(iBossIndex);

	//From Pelipoika's rainbow outline plugin
	if (NPCGetCustomOutlinesState(iBossIndex) && NPCGetRainbowOutlineState(iBossIndex))
	{
		int iGlow = EntRefToEntIndex(g_iNPCGlowEntity[iBossIndex]);
		int color[4];
		color[0] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(iBossIndex)) + iBossIndex + 0) * 127.5 + 127.5);
		color[1] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(iBossIndex)) + iBossIndex + 2) * 127.5 + 127.5);
		color[2] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(iBossIndex)) + iBossIndex + 4) * 127.5 + 127.5);
		color[3] = 255; 
		if (iGlow && iGlow != INVALID_ENT_REFERENCE)
		{
			SetVariantColor(color);
			AcceptEntityInput(iGlow, "SetGlowColor");
		}
	}
	
	// Process angles.
	bool bChangeAngle = false;
	float vecPosToAt[3];
	if (iState != STATE_STUN && !g_bSlenderSpawning[iBossIndex])
	{
		int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
		
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
					bool bCanSeeTarget = false;
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						float vecTargetPos[3], vecMyEyePos[3];
						NPCGetEyePosition(iBossIndex, vecMyEyePos);
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
						vecTargetPos[2] += 18.0;
						if (GetVectorSquareMagnitude(vecTargetPos, vecMyEyePos) <= SquareFloat(100.0))
						{
							TR_TraceRayFilter(vecMyEyePos, vecTargetPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharacters, iBoss);
							bCanSeeTarget = !TR_DidHit();
						}
					}

					if (bCanSeeTarget)
					{
						bCanSeeTarget = NPCShouldSeeEntity(iBossIndex, iTarget);
					}
					
					if (g_bNPCAlwaysLookAtTargetWhileChasing[iBossIndex] || bCanSeeTarget)
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
					if (g_bNPCAlwaysLookAtTargetWhileAttacking[iBossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, attackIndex) && ((NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
					{
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							bChangeAngle = true;
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
						}
					}
					if (!NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, attackIndex) && (NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
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

	if (!g_bSlenderSpawning[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex])
	{
		// Process our desired speed.
		bool bPFUpdate = false;
		switch (iState)
		{
			case STATE_WANDER:
			{
				if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE))
				{
					bPFUpdate = true;
					loco.Run();
				}
			}
			case STATE_ALERT:
			{
				bPFUpdate = true;
				loco.Run();
			}
			case STATE_CHASE:
			{
				bPFUpdate = true;
				loco.Run();
			}
			case STATE_ATTACK:
			{
				if (NPCChaserGetAttackWhileRunningState(iBossIndex, attackIndex))
				{
					bPFUpdate = true;
					loco.Run();
				}
			}
		}
		if (bPFUpdate)
		{
			g_pPath[iBossIndex].Update(bot);
		}
		else
			loco.Stop();
		if (iState != iOldState)
		{
			bot.Update();
		}
		if (loco.IsOnGround() && !loco.IsClimbingOrJumping() && (iState == STATE_ALERT || iState == STATE_CHASE || iState == STATE_WANDER || iState == STATE_ATTACK) && 
		!g_bNPCUsesChaseInitialAnimation[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && 
		!g_bNPCUsesCloakStartAnimation[iBossIndex] && !g_bNPCUsesCloakEndAnimation[iBossIndex] && !g_bNPCUseStartFleeAnimation[iBossIndex])
		{
			float flVecPathNodePos[3], flVecPathEndPos[3];
			Segment sSegment;
			if (g_pPath[iBossIndex].FirstSegment() != NULL_PATH_SEGMENT && g_pPath[iBossIndex].NextSegment(g_pPath[iBossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
			{
				sSegment = g_pPath[iBossIndex].NextSegment(g_pPath[iBossIndex].FirstSegment());
				sSegment.GetForward(flVecPathNodePos);
				sSegment.GetPos(flVecPathEndPos);
				ScaleVector(flVecPathNodePos, sSegment.length);
				AddVectors(flVecPathEndPos, flVecPathNodePos, flVecPathEndPos);

				if (g_pPath[iBossIndex].IsDiscontinuityAhead(bot, JUMP_OVER_GAP, 120.0) || g_pPath[iBossIndex].IsDiscontinuityAhead(bot, CLIMB_UP, 120.0) || g_pPath[iBossIndex].IsDiscontinuityAhead(bot, LADDER_UP, 120.0))
				{
					CBaseNPC_Jump(loco, flMyPos, flVecPathEndPos);
				}

				/*if (flVecPathNodePos[2] > loco.GetStepHeight())
				{
					float vecMyPos2D[3], vecGoalPos2D[3];
					vecMyPos2D = flMyPos;
					vecMyPos2D[2] = 0.0;
					vecGoalPos2D = flVecPathEndPos;
					vecGoalPos2D[2] = 0.0;
	
					float fl2DDist = GetVectorSquareMagnitude(vecMyPos2D, vecGoalPos2D);
					if (fl2DDist <= SquareFloat(200.0))
					{
						//Before we actually jump like freaking retards, let's check first if we aren't actually on a slope...
						bool bJump = false;
							
						float vecGoal[3], goalAng[3], forwadPos[3];
						MakeVectorFromPoints(flMyPos, flVecPathEndPos, vecGoal);
							
						GetVectorAngles(vecGoal, goalAng);
						goalAng[0] = 0.0;
						goalAng[2] = 0.0;
							
						float vecTracePos[3];
						vecTracePos = flMyPos;
						vecTracePos[2] += 1.0;
						GetPositionForward(vecTracePos, goalAng, forwadPos, body.GetHullWidth()+1.0);

						Handle hTrace = null;
						hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, iBoss);
							
						bool bClear = !TR_DidHit(hTrace);
						delete hTrace;
							
						if (!bClear)
						{
								
							forwadPos[2] += loco.GetStepHeight() + vecTracePos[2];
								
							hTrace = null;
							hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, iBoss);
								
							bClear = !TR_DidHit(hTrace);
							delete hTrace;
								
							if (!bClear) //we have a wall
							{
								bJump = true;
							}
						}
						else //We have a gap ahead
						{
							bJump = true;
						}

						if (bJump)
						{
							CBaseNPC_Jump(loco, flMyPos, flVecPathEndPos);
						}
					}
				}*/
			}
		}
	}

	if (!loco.IsClimbingOrJumping() && !g_bSlenderSpawning[iBossIndex])
	{
		float hullcheckmins[3], hullcheckmaxs[3];
		if (NPCGetRaidHitbox(iBossIndex) == 1)
		{
			hullcheckmins = g_flSlenderDetectMins[iBossIndex];
			hullcheckmaxs = g_flSlenderDetectMaxs[iBossIndex];
		}
		else if (NPCGetRaidHitbox(iBossIndex) == 0)
		{
			hullcheckmins = HULL_HUMAN_MINS;
			hullcheckmaxs = HULL_HUMAN_MAXS;
		}
		hullcheckmins[0] -= 20.0;
		hullcheckmins[1] -= 20.0;
		
		hullcheckmaxs[0] += 20.0;
		hullcheckmaxs[1] += 20.0;
		
		hullcheckmins[2] += loco.GetStepHeight();
		hullcheckmaxs[2] += 5.0;
		
		if (!g_bNPCVelocityCancel[iBossIndex] && IsSpaceOccupiedIgnorePlayersAndEnts(flMyPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
		{
			float vec3Origin[3];
			loco.SetVelocity(vec3Origin);
			g_bNPCVelocityCancel[iBossIndex] = true;
		}
	}
	else
		g_bNPCVelocityCancel[iBossIndex] = false;

	if (NPCChaserCanCrawl(iBossIndex) && !g_bSlenderSpawning[iBossIndex] && 
	iState != STATE_ATTACK && iState != STATE_STUN && iState != STATE_IDLE && loco.IsOnGround() && !loco.IsClimbingOrJumping())
	{
		float flCrawlDetectMins[3], flCrawlDetectMaxs[3];
		flCrawlDetectMins = g_flNPCCrawlDetectMins[iBossIndex];
		flCrawlDetectMaxs = g_flNPCCrawlDetectMaxs[iBossIndex];

		if (IsSpaceOccupiedIgnorePlayersAndEnts(flMyPos, flCrawlDetectMins, flCrawlDetectMaxs, iBoss) && !g_bNPCIsCrawling[iBossIndex])
		{
			NPCChaserUpdateBossAnimation(iBossIndex, iBoss, g_iSlenderState[iBossIndex]);
			g_bNPCIsCrawling[iBossIndex] = true;
			g_bNPCChangeToCrawl[iBossIndex] = true;
		}
		if (!IsSpaceOccupiedIgnorePlayersAndEnts(flMyPos, flCrawlDetectMins, flCrawlDetectMaxs, iBoss) && g_bNPCIsCrawling[iBossIndex])
		{
			NPCChaserUpdateBossAnimation(iBossIndex, iBoss, g_iSlenderState[iBossIndex]);
			g_bNPCIsCrawling[iBossIndex] = false;
			g_bNPCChangeToCrawl[iBossIndex] = true;
		}
	}

	if ((iState == STATE_CHASE || iState == STATE_ALERT || iState == STATE_WANDER) && !g_bSlenderInDeathcam[iBossIndex])
	{
		int iPitch = combatChar.LookupPoseParameter("body_pitch");
		int iYaw = combatChar.LookupPoseParameter("body_yaw");
		float vecDir[3], vecAng[3], vecNPCCenter[3];
		combatChar.WorldSpaceCenter(vecNPCCenter);
		SubtractVectors(vecNPCCenter, g_flSlenderGoalPos[iBossIndex], vecDir); 
		NormalizeVector(vecDir, vecDir);
		GetVectorAngles(vecDir, vecAng); 
	
		float flPitch = combatChar.GetPoseParameter(iPitch);
		float flYaw = combatChar.GetPoseParameter(iYaw);

		vecAng[0] = UTIL_Clamp(UTIL_AngleNormalize(vecAng[0]), -44.0, 89.0);
		combatChar.SetPoseParameter(iPitch, UTIL_ApproachAngle(iState == STATE_CHASE && g_bSlenderTargetIsVisible[iBossIndex] ? vecAng[0] : 0.0, flPitch, (NPCGetTurnRate(iBossIndex)/1000.0) * 16.0));
		vecAng[1] = UTIL_Clamp(-UTIL_AngleNormalize(UTIL_AngleDiff(UTIL_AngleNormalize(vecAng[1]), UTIL_AngleNormalize(flMyEyeAng[1]+180.0))), -44.0,  44.0);
		combatChar.SetPoseParameter(iYaw, UTIL_ApproachAngle(iState == STATE_CHASE && g_bSlenderTargetIsVisible[iBossIndex] ? vecAng[1] : 0.0, flYaw, (NPCGetTurnRate(iBossIndex)/1000.0) * 16.0));
		
		int m_iMoveX = combatChar.LookupPoseParameter("move_x");
		int m_iMoveY = combatChar.LookupPoseParameter("move_y");

		float flGroundSpeed = loco.GetGroundSpeed();
		if (m_iMoveX > 0 || m_iMoveY > 0)
		{
			if ( flGroundSpeed != 0.0 )
			{
				float vecForward[3], vecRight[3], vecUp[3], vecMotion[3];
				combatChar.GetVectors(vecForward, vecRight, vecUp);
				loco.GetGroundMotionVector(vecMotion);
				
				if (m_iMoveX >= 0) combatChar.SetPoseParameter(m_iMoveX, GetVectorDotProduct(vecMotion,vecForward));
				if (m_iMoveY >= 0) combatChar.SetPoseParameter(m_iMoveY, GetVectorDotProduct(vecMotion,vecRight));
			}
			else
			{
				if (m_iMoveX >= 0) combatChar.SetPoseParameter(m_iMoveX, 0.0);
				if (m_iMoveY >= 0) combatChar.SetPoseParameter(m_iMoveY, 0.0);
			}
			float m_flGroundSpeed = GetEntPropFloat(iBoss, Prop_Data, "m_flGroundSpeed");
			if(m_flGroundSpeed != 0.0 && loco.IsOnGround())
			{
				float flReturnValue = flGroundSpeed / m_flGroundSpeed;
				if (flReturnValue < -4.0) flReturnValue = -4.0;
				if (flReturnValue > 12.0) flReturnValue = 12.0;
					
				SetEntPropFloat(iBoss, Prop_Send, "m_flPlaybackRate", flReturnValue);
			}
		}
	}

	if (iState != STATE_IDLE && iState != STATE_STUN && iState != STATE_ATTACK && !g_bSlenderSpawning[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex])
	{
		bool bRunUnstuck = (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0 && difficulty >= RoundToNearest(NPCGetAttributeValue(iBossIndex, "block walk speed under difficulty", 0.0)));
		if (bRunUnstuck)
		{
			if (loco.GetGroundSpeed() <= 0.1 || GetVectorSquareMagnitude(flMyPos, g_flLastPos[iBossIndex]) < 0.1 || loco.IsStuck())
			{
				bool bBlockingProp = false;

				if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
				{
					for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
					{
						if (NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_LaserBeam) continue;
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex2), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex2));
						if (bBlockingProp) break;
					}
				}
				if (!bBlockingProp)
				{
					if (g_flLastStuckTime[iBossIndex] == 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();

					if ((g_flLastStuckTime[iBossIndex] <= GetGameTime()-1.0 || loco.GetStuckDuration() >= 1.0) && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex] && 
					g_pPath[iBossIndex].FirstSegment() != NULL_PATH_SEGMENT && 
					g_pPath[iBossIndex].NextSegment(g_pPath[iBossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
					{
						float vecMovePos[3];
						Segment sSegment;
						sSegment = g_pPath[iBossIndex].NextSegment(g_pPath[iBossIndex].FirstSegment());
						sSegment.GetPos(vecMovePos);
						bool bPathResolved = false;

						if (SlenderChaseBoss_OnStuckResolvePath(iBoss, flMyPos, flMyEyeAng, vecMovePos, vecMovePos))
						{
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									float vec3Origin[3];
									loco.SetVelocity(vec3Origin);
								}
								else
								{
									vecMovePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
										float vec3Origin[3];
										loco.SetVelocity(vec3Origin);
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									float vec3Origin[3];
									loco.SetVelocity(vec3Origin);
								}
								else
								{
									vecMovePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
										float vec3Origin[3];
										loco.SetVelocity(vec3Origin);
									}
								}
							}
						}
						if (!bPathResolved)
						{
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									float vec3Origin[3];
									loco.SetVelocity(vec3Origin);
								}
								else
								{
									vecMovePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
										float vec3Origin[3];
										loco.SetVelocity(vec3Origin);
									}
									else
									{
										CNavArea area = TheNavMesh.GetNearestNavArea(flMyPos, _, 300.0);
										if (area == NULL_AREA)
										{
											area = sSegment.area;
										}
										if (area != NULL_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
												float vec3Origin[3];
												loco.SetVelocity(vec3Origin);
											}
											else
											{
												vecMovePos[2] += loco.GetStepHeight();
												if (!IsSpaceOccupied(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
											}
										}
										if (!bPathResolved)
										{
											if (!SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_bRestartSessionEnabled)
											{
												RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else if (SF_IsBoxingMap())
											{
												float flTeleportPos[3];
												ArrayList hRespawnPoint = new ArrayList();
												char sName[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
													if (StrContains(sName, "sf2_boss_respawnpoint", false))
													{
														hRespawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (hRespawnPoint.Length > 0) ent = hRespawnPoint.Get(GetRandomInt(0,hRespawnPoint.Length-1));
												
												delete hRespawnPoint;
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_bRestartSessionEnabled)
											{
												ArrayList hSpawnPoint = new ArrayList();
												float flTeleportPos[3];
												int ent = -1, iSpawnTeam = 0;
												while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
												{
													iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
													if (iSpawnTeam == TFTeam_Red) 
													{
														hSpawnPoint.Push(ent);
													}

												}
												ent = -1;
												if (hSpawnPoint.Length > 0) ent = hSpawnPoint.Get(GetRandomInt(0,hSpawnPoint.Length-1));

												delete hSpawnPoint;

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
												else RemoveSlender(iBossIndex);
											}
										}
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									float vec3Origin[3];
									loco.SetVelocity(vec3Origin);
								}
								else
								{
									vecMovePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
										float vec3Origin[3];
										loco.SetVelocity(vec3Origin);
									}
									else
									{
										CNavArea area = TheNavMesh.GetNearestNavArea(flMyPos, _, 300.0);
										if (area == NULL_AREA)
										{
											area = sSegment.area;
										}
										if (area != NULL_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
												float vec3Origin[3];
												loco.SetVelocity(vec3Origin);
											}
											else
											{
												vecMovePos[2] += loco.GetStepHeight();
												if (!IsSpaceOccupied(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
											}
										}
										if (!bPathResolved)
										{
											if (!SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_bRestartSessionEnabled)
											{
												RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else if (SF_IsBoxingMap())
											{
												float flTeleportPos[3];
												ArrayList hRespawnPoint = new ArrayList();
												char sName[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
													if (StrContains(sName, "sf2_boss_respawnpoint", false))
													{
														hRespawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (hRespawnPoint.Length > 0) ent = hRespawnPoint.Get(GetRandomInt(0,hRespawnPoint.Length-1));
														
												delete hRespawnPoint;
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_bRestartSessionEnabled)
											{
												ArrayList hSpawnPoint = new ArrayList();
												float flTeleportPos[3];
												int ent = -1, iSpawnTeam = 0;
												while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
												{
													iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
													if (iSpawnTeam == TFTeam_Red) 
													{
														hSpawnPoint.Push(ent);
													}

												}
												ent = -1;
												if (hSpawnPoint.Length > 0) ent = hSpawnPoint.Get(GetRandomInt(0,hSpawnPoint.Length-1));

												delete hSpawnPoint;

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
													float vec3Origin[3];
													loco.SetVelocity(vec3Origin);
												}
												else RemoveSlender(iBossIndex);
											}
										}
									}
								}
							}
						}
						if (bPathResolved)
						{
							loco.ClearStuckStatus();
							g_flLastStuckTime[iBossIndex] = 0.0;
						}
					}
				}
			}
			else
			{
				loco.ClearStuckStatus();
				g_flLastStuckTime[iBossIndex] = 0.0;
				g_flLastPos[iBossIndex] = flMyPos;
			}
		}
	}
	
	return;
}

public void SlenderSetNextThink(int iBoss)
{
	if (!g_bEnabled) return;

	CBaseCombatCharacter(iBoss).SetNextThink(GetGameTime() + 0.01);
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(iBoss);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex != -1)
	{
		int iState = g_iSlenderState[iBossIndex];
		bool bChangeAngle = false;
		float vecPosToAt[3];
		int attackIndex = NPCGetCurrentAttackIndex(iBossIndex);
		if (iState != STATE_STUN && !g_bSlenderSpawning[iBossIndex])
		{
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			
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
						bool bCanSeeTarget = false;
						if (iTarget && iTarget != INVALID_ENT_REFERENCE)
						{
							float vecTargetPos[3], vecMyEyePos[3];
							NPCGetEyePosition(iBossIndex, vecMyEyePos);
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
							vecTargetPos[2] += 18.0;
							if (GetVectorSquareMagnitude(vecTargetPos, vecMyEyePos) <= SquareFloat(100.0))
							{
								TR_TraceRayFilter(vecMyEyePos, vecTargetPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharacters, iBoss);
								bCanSeeTarget = !TR_DidHit();
							}
						}

						if (bCanSeeTarget)
						{
							bCanSeeTarget = NPCShouldSeeEntity(iBossIndex, iTarget);
						}
						
						if (g_bNPCAlwaysLookAtTargetWhileChasing[iBossIndex] || bCanSeeTarget)
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
						if (g_bNPCAlwaysLookAtTargetWhileAttacking[iBossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, attackIndex) && ((NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
						{
							if (iTarget && iTarget != INVALID_ENT_REFERENCE)
							{
								bChangeAngle = true;
								GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
							}
						}
						if (!NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, attackIndex) && (NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
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

	}
	
	return;
}

public float CBaseNPC_PathCost(INextBot bot, CNavArea area, CNavArea fromArea, CNavLadder ladder, int iElevator, float length)
{
	if (fromArea == NULL_AREA || area == NULL_AREA)
	{
		return 0.0;
	}
	else
	{
		ILocomotion loco = bot.GetLocomotionInterface();
		float flDist;
		float flAreaCenter[3], flFromAreaCenter[3];
		area.GetCenter(flAreaCenter);
		fromArea.GetCenter(flFromAreaCenter);
		
		if (ladder != NULL_LADDER_AREA)
		{
			flDist = ladder.length;
		}
		else if (length > 0.0)
		{
			flDist = length;
		}
		else
		{
			flDist = GetVectorSquareMagnitude(flAreaCenter, flFromAreaCenter);
		}
		
		float flCost = (flDist + SquareFloat(fromArea.GetCostSoFar()));

		int attributes = area.GetAttributes();
		if (attributes & NAV_MESH_CROUCH) flCost += SquareFloat(20.0);
		if (attributes & NAV_MESH_JUMP) flCost += SquareFloat(5.0 * flDist);
		
		if ((flAreaCenter[2] - flFromAreaCenter[2]) > loco.GetStepHeight()) flCost += SquareFloat(loco.GetStepHeight());

		float multiplier = 1.0;

		int seed = RoundToFloor(GetGameTime() * 0.1) + 1;

		seed *= area.GetID();
		seed *= bot.GetEntity();
		multiplier += (Cosine(float(seed)) + 1.0) * 50.0;

		flCost += flDist * multiplier;
		
		float flReturn = flCost;

		if (flReturn > 2.0)
		{
			flReturn = 2.0;
		}

		return flReturn;
	}
}

public void CBaseNPC_Jump(NextBotGroundLocomotion nextbotLocomotion, float vecStartPos[3], float vecEndPos[3])
{
	float vecJumpVel[3];
	float flActualHeight = vecEndPos[2] - vecStartPos[2];
	float height = flActualHeight;
	if ( height < 16.0 )
	{
		height = 16.0;
	}
	
	float additionalHeight = 20.0;
	if (height < 32.0)
	{
		additionalHeight += 8.0;
	}
	float flGravity = nextbotLocomotion.GetGravity();
	
	height += additionalHeight;
	
	float speed = SquareRoot(2.0 * flGravity * height);
	float time = (speed / flGravity);
	
	time += SquareRoot((2.0 * additionalHeight) / flGravity);
	
	SubtractVectors(vecEndPos, vecStartPos, vecJumpVel);
	vecJumpVel[0] /= time;
	vecJumpVel[1] /= time;
	vecJumpVel[2] /= time;
	
	vecJumpVel[2] = speed;
	vecJumpVel[2] += height+additionalHeight;
		
	float flJumpSpeed = GetVectorLength(vecJumpVel, true);
	float flMaxSpeed = SquareFloat(650.0);
	if (flJumpSpeed > flMaxSpeed)
	{
		vecJumpVel[0] *= (flMaxSpeed / flJumpSpeed);
		vecJumpVel[1] *= (flMaxSpeed / flJumpSpeed);
		vecJumpVel[2] *= (flMaxSpeed / flJumpSpeed);
	}

	nextbotLocomotion.Jump();
	nextbotLocomotion.SetVelocity(vecJumpVel);
}

stock bool SlenderChaseBoss_OnStuckResolvePath(int slender, float flMyPos[3], float flMyAng[3], float flGoalPosition[3], float flReturn[3])
{
	//We are stuck, try to find a free pos to path on the right or left.
	int attemp = 1;
	while (attemp <= 2)
	{
		float yawMin, yawMax, yawInc;
		if (attemp == 1) //We will first try on the right
		{
			yawMin = 10.0;
			yawMax = 90.0;
			yawInc = 5.0;
		}
		else if (attemp == 2) //Then on the left
		{
			yawMin = -90.0;
			yawMax = -10.0;
			yawInc = 5.0;
		}
		//Note: Actually there's no right and left, it's just to give you an idea on how this will be done. 
		for(int y=RoundToNearest(yawMin); y<=RoundToNearest(yawMax); y+=RoundToNearest(yawInc))
		{
			flMyAng[1] += float(y);
			for(int r=30; r<=300; r+=10)
			{
				float flFreePos[3];
				GetPositionForward(flMyPos, flMyAng, flFreePos, float(r));

				// Perform a line of sight check to avoid spawning players in unreachable map locations.
				TR_TraceRayFilter(flMyPos, flFreePos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);

				if(!TR_DidHit())
				{
					// Perform an other line of sight check to avoid moving in a area that can't reach the original goal!
					TR_TraceRayFilter(flFreePos, flGoalPosition, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
					if(!TR_DidHit())
					{
						TR_TraceHullFilter(flMyPos, flFreePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, TraceRayDontHitAnyEntity, slender);
					
						if(!TR_DidHit())
						{
							flReturn = flFreePos;
							flMyAng[1] -= float(y);
							return true;
						}
					}
					else
					{
						//This free position can't bring us to the goal position. Give up on this angle.
						break;
					}
				}
				else
				{
					// We hit something that breaks the line of sight. Give up on this angle.
					break;
				}
			}
			flMyAng[1] -= float(y);
		}
		attemp++;
	}
	return false;
}
