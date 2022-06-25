#if defined _sf2_npc_chaser_pathing_included
 #endinput
#endif
#define _sf2_npc_chaser_pathing_included

public void SlenderChaseBossProcessMovement(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(bossEnt);
	if (npc == INVALID_NPC)
	{
		SDKUnhook(bossEnt, SDKHook_Think, SlenderChaseBossProcessMovement); //What no boss?
		return;
	}

	int bossIndex = NPCGetFromEntIndex(bossEnt);
	if (bossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(bossEnt, SDKHook_Think, SlenderChaseBossProcessMovement);
		return;
	}

	INextBot bot = npc.GetBot();
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	CBaseCombatCharacter combatChar = CBaseCombatCharacter(bossEnt);

	char slenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, slenderProfile, sizeof(slenderProfile));

	float myPos[3], myEyeAng[3];
	GetEntPropVector(bossEnt, Prop_Data, "m_vecAbsOrigin", myPos);
	GetEntPropVector(bossEnt, Prop_Data, "m_angAbsRotation", myEyeAng);

	int state = g_SlenderState[bossIndex];
	int oldState = g_SlenderOldState[bossIndex];
	g_SlenderOldState[bossIndex] = state;

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	if (!g_SlenderInDeathcam[bossIndex])
	{
		switch (state)
		{
			case STATE_WANDER, STATE_ALERT:
			{
				if (npc != INVALID_NPC)
				{
					npc.flWalkSpeed = g_SlenderCalculatedWalkSpeed[bossIndex];
					npc.flRunSpeed = g_SlenderCalculatedWalkSpeed[bossIndex];
				}
				loco.SetSpeedLimit(g_SlenderCalculatedMaxWalkSpeed[bossIndex]);
			}
			case STATE_CHASE:
			{
				if (!g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex]
					&& !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex]
					&& !g_NpcUsesHealAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
				{
					if (npc != INVALID_NPC)
					{
						npc.flWalkSpeed = g_SlenderCalculatedSpeed[bossIndex];
						npc.flRunSpeed = g_SlenderCalculatedSpeed[bossIndex];
					}
				}
				else
				{
					if (npc != INVALID_NPC)
					{
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
					}
				}
				loco.SetSpeedLimit(g_SlenderCalculatedMaxSpeed[bossIndex]);
			}
			case STATE_ATTACK:
			{
				int currentAttackIndex = NPCGetCurrentAttackIndex(bossIndex);
				if (NPCChaserGetAttackWhileRunningState(bossIndex, currentAttackIndex) &&
					!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] &&
					!g_NpcUsesRageAnimation3[bossIndex] && GetGameTime() >= g_NpcBaseAttackRunDelayTime[bossIndex][currentAttackIndex])
				{
					if (NPCChaserGetAttackRunDuration(bossIndex, currentAttackIndex) > 0.0)
					{
						if (GetGameTime() < g_NpcBaseAttackRunDurationTime[bossIndex][currentAttackIndex])
						{
							float attackSpeed, originalSpeed;
							originalSpeed = NPCChaserGetAttackRunSpeed(bossIndex, currentAttackIndex, difficulty);
							if (g_RoundDifficultyModifier > 1.0)
							{
								attackSpeed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0) + (NPCGetAnger(bossIndex) * g_RoundDifficultyModifier);
							}
							else
							{
								attackSpeed = originalSpeed + NPCGetAnger(bossIndex);
							}
							if (npc != INVALID_NPC)
							{
								npc.flWalkSpeed = attackSpeed * g_SlenderSpeedMultiplier[bossIndex];
								npc.flRunSpeed = attackSpeed * g_SlenderSpeedMultiplier[bossIndex];
							}
						}
						else
						{
							if (npc != INVALID_NPC)
							{
								npc.flWalkSpeed = 0.0;
								npc.flRunSpeed = 0.0;
							}
						}
					}
					else
					{
						float attackSpeed, originalSpeed;
						originalSpeed = NPCChaserGetAttackRunSpeed(bossIndex, currentAttackIndex, difficulty);
						if (g_RoundDifficultyModifier > 1.0)
						{
							attackSpeed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0) + (NPCGetAnger(bossIndex) * g_RoundDifficultyModifier);
						}
						else
						{
							attackSpeed = originalSpeed + NPCGetAnger(bossIndex);
						}

						if (npc != INVALID_NPC)
						{
							npc.flWalkSpeed = attackSpeed * g_SlenderSpeedMultiplier[bossIndex];
							npc.flRunSpeed = attackSpeed * g_SlenderSpeedMultiplier[bossIndex];
						}
					}
				}
				else
				{
					if (npc != INVALID_NPC)
					{
						npc.flWalkSpeed = 0.0;
						npc.flRunSpeed = 0.0;
					}
				}
				loco.SetSpeedLimit(999999.9);
			}
			case STATE_STUN:
			{
				if (npc != INVALID_NPC)
				{
					npc.flWalkSpeed = 0.0;
					npc.flRunSpeed = 0.0;
				}
			}
		}
	}
	else
	{
		npc.flWalkSpeed = 0.0;
		npc.flRunSpeed = 0.0;
	}
	if (state == STATE_ATTACK)
	{
		int currentAttackIndex = NPCGetCurrentAttackIndex(bossIndex);
		if (NPCChaserGetAttackWhileRunningState(bossIndex, currentAttackIndex))
		{
			npc.flAcceleration = 99999.9;
		}
		else
		{
			npc.flAcceleration = g_SlenderCalculatedAcceleration[bossIndex];
		}
	}
	else
	{
		npc.flAcceleration = g_SlenderCalculatedAcceleration[bossIndex];
	}

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);

	//From Pelipoika's rainbow outline plugin
	if (NPCGetCustomOutlinesState(bossIndex) && NPCGetRainbowOutlineState(bossIndex))
	{
		int glow = EntRefToEntIndex(g_NpcGlowEntity[bossIndex]);
		int color[4];
		color[0] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(bossIndex)) + bossIndex + 0) * 127.5 + 127.5);
		color[1] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(bossIndex)) + bossIndex + 2) * 127.5 + 127.5);
		color[2] = RoundToNearest(Cosine((GetGameTime() * NPCGetRainbowOutlineCycleRate(bossIndex)) + bossIndex + 4) * 127.5 + 127.5);
		color[3] = 255;
		if (IsValidEntity(glow))
		{
			SetVariantColor(color);
			AcceptEntityInput(glow, "SetGlowColor");
		}
	}

	// Process angles.
	bool changeAngle = false;
	float posToAt[3];
	if (state != STATE_STUN && !g_SlenderSpawning[bossIndex] && !g_SlenderInDeathcam[bossIndex])
	{
		int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);

		if (g_NpcHasAlwaysLookAtTarget[bossIndex])
		{
			if (target && target != INVALID_ENT_REFERENCE)
			{
				changeAngle = true;
				GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
			}
		}
		else
		{
			switch (state)
			{
				case STATE_CHASE:
				{
					bool canSeeTarget = false;
					if (target && target != INVALID_ENT_REFERENCE)
					{
						float targetPos[3], myEyePos[3];
						NPCGetEyePosition(bossIndex, myEyePos);
						GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", targetPos);
						targetPos[2] += 18.0;
						if (GetVectorSquareMagnitude(targetPos, myEyePos) <= SquareFloat(100.0))
						{
							TR_TraceRayFilter(myEyePos, targetPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharacters, bossEnt);
							canSeeTarget = !TR_DidHit();
						}
					}

					if (canSeeTarget)
					{
						canSeeTarget = NPCShouldSeeEntity(bossIndex, target);
					}

					if (g_NpcHasAlwaysLookAtTargetWhileChasing[bossIndex] || canSeeTarget)
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							changeAngle = true;
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);

						}
					}

					if (g_NpcUsesChaseInitialAnimation[bossIndex] || g_NpcUsesRageAnimation1[bossIndex] || g_NpcUsesRageAnimation2[bossIndex] || g_NpcUsesRageAnimation3[bossIndex] || g_NpcUseStartFleeAnimation[bossIndex])
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							changeAngle = true;
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
						}
					}
					if (!loco.IsOnGround() || loco.IsClimbingOrJumping())
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							float targetPos[3], myEyePos[3];
							NPCGetEyePosition(bossIndex, myEyePos);
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", targetPos);
							targetPos[2] += 18.0;
							if (GetVectorSquareMagnitude(targetPos, myEyePos) <= SquareFloat(400.0))
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
							}
						}
					}
				}
				case STATE_ATTACK:
				{
					if (g_NpcHasAlwaysLookAtTargetWhileAttacking[bossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex) && ((NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							changeAngle = true;
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
						}
					}
					if (!NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex) && (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							changeAngle = true;
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
						}
					}
				}
			}
		}
	}

	if (changeAngle)
	{
		loco.FaceTowards(posToAt);
	}

	if (!g_SlenderSpawning[bossIndex] && !g_SlenderInDeathcam[bossIndex])
	{
		// Process our desired speed.
		bool pfUpdate = false;
		switch (state)
		{
			case STATE_WANDER:
			{
				if ((NPCGetFlags(bossIndex) & SFF_WANDERMOVE))
				{
					pfUpdate = true;
					loco.Run();
				}
			}
			case STATE_ALERT:
			{
				pfUpdate = true;
				loco.Run();
			}
			case STATE_CHASE:
			{
				pfUpdate = true;
				loco.Run();
			}
			case STATE_ATTACK:
			{
				if (NPCChaserGetAttackWhileRunningState(bossIndex, attackIndex))
				{
					pfUpdate = true;
					loco.Run();
				}
			}
		}
		if (pfUpdate)
		{
			g_BossPathFollower[bossIndex].Update(bot);
		}
		else
		{
			loco.Stop();
		}
		if (state != oldState)
		{
			bot.Update();
		}
		if (!SF_IsBoxingMap() && loco.IsOnGround() && !loco.IsClimbingOrJumping() && (state == STATE_ALERT || state == STATE_CHASE || state == STATE_WANDER || state == STATE_ATTACK) &&
		!g_NpcUsesChaseInitialAnimation[bossIndex] && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex] &&
		!g_NpcUsesCloakStartAnimation[bossIndex] && !g_NpcUsesCloakEndAnimation[bossIndex] && !g_NpcUseStartFleeAnimation[bossIndex])
		{
			float pathNodePos[3], pathEndPos[3];
			Segment segment;
			if (g_BossPathFollower[bossIndex].FirstSegment() != NULL_PATH_SEGMENT && g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
			{
				segment = g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment());
				segment.GetForward(pathNodePos);
				segment.GetPos(pathEndPos);
				ScaleVector(pathNodePos, segment.length);
				AddVectors(pathEndPos, pathNodePos, pathEndPos);

				if (g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, JUMP_OVER_GAP, 120.0) || g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, CLIMB_UP, 120.0) || g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, LADDER_UP, 120.0))
				{
					CBaseNPC_Jump(loco, myPos, pathEndPos);
				}

				/*if (pathNodePos[2] > loco.GetStepHeight())
				{
					float vecMyPos2D[3], vecGoalPos2D[3];
					vecMyPos2D = myPos;
					vecMyPos2D[2] = 0.0;
					vecGoalPos2D = pathEndPos;
					vecGoalPos2D[2] = 0.0;

					float fl2DDist = GetVectorSquareMagnitude(vecMyPos2D, vecGoalPos2D);
					if (fl2DDist <= SquareFloat(200.0))
					{
						//Before we actually jump like freaking retards, let's check first if we aren't actually on a slope...
						bool bJump = false;

						float vecGoal[3], goalAng[3], forwadPos[3];
						MakeVectorFromPoints(myPos, pathEndPos, vecGoal);

						GetVectorAngles(vecGoal, goalAng);
						goalAng[0] = 0.0;
						goalAng[2] = 0.0;

						float vecTracePos[3];
						vecTracePos = myPos;
						vecTracePos[2] += 1.0;
						GetPositionForward(vecTracePos, goalAng, forwadPos, body.GetHullWidth()+1.0);

						Handle hTrace = null;
						hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, bossEnt);

						bool bClear = !TR_DidHit(hTrace);
						delete hTrace;

						if (!bClear)
						{

							forwadPos[2] += loco.GetStepHeight() + vecTracePos[2];

							hTrace = null;
							hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, bossEnt);

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
							CBaseNPC_Jump(loco, myPos, pathEndPos);
						}
					}
				}*/
			}
		}
	}

	if (!loco.IsClimbingOrJumping() && !g_SlenderSpawning[bossIndex])
	{
		float hullCheckMins[3], hullCheckMaxs[3];
		if (NPCGetRaidHitbox(bossIndex) == 1)
		{
			hullCheckMins = g_SlenderDetectMins[bossIndex];
			hullCheckMaxs = g_SlenderDetectMaxs[bossIndex];
		}
		else if (NPCGetRaidHitbox(bossIndex) == 0)
		{
			hullCheckMins = HULL_HUMAN_MINS;
			hullCheckMaxs = HULL_HUMAN_MAXS;
		}
		hullCheckMins[0] -= 20.0;
		hullCheckMins[1] -= 20.0;

		hullCheckMaxs[0] += 20.0;
		hullCheckMaxs[1] += 20.0;

		hullCheckMins[2] += loco.GetStepHeight();
		hullCheckMaxs[2] += 5.0;

		if (!g_NpcVelocityCancel[bossIndex] && IsSpaceOccupiedIgnorePlayersAndEnts(myPos, hullCheckMins, hullCheckMaxs, bossEnt))//The boss will start to merge with shits, cancel out velocity.
		{
			float origin[3];
			loco.SetVelocity(origin);
			g_NpcVelocityCancel[bossIndex] = true;
		}
	}
	else
		g_NpcVelocityCancel[bossIndex] = false;

	if (NPCChaserCanCrawl(bossIndex) && !g_SlenderSpawning[bossIndex] &&
	state != STATE_ATTACK && state != STATE_STUN && state != STATE_IDLE && loco.IsOnGround() && !loco.IsClimbingOrJumping())
	{
		float crawlDetectMins[3], crawlDetectMaxs[3];
		crawlDetectMins = g_NpcCrawlDetectMins[bossIndex];
		crawlDetectMaxs = g_NpcCrawlDetectMaxs[bossIndex];

		if (IsSpaceOccupiedIgnorePlayersAndEnts(myPos, crawlDetectMins, crawlDetectMaxs, bossEnt) && !g_NpcIsCrawling[bossIndex])
		{
			NPCChaserUpdateBossAnimation(bossIndex, bossEnt, g_SlenderState[bossIndex]);
			g_NpcIsCrawling[bossIndex] = true;
			g_NpcChangeToCrawl[bossIndex] = true;
		}
		if (!IsSpaceOccupiedIgnorePlayersAndEnts(myPos, crawlDetectMins, crawlDetectMaxs, bossEnt) && g_NpcIsCrawling[bossIndex])
		{
			NPCChaserUpdateBossAnimation(bossIndex, bossEnt, g_SlenderState[bossIndex]);
			g_NpcIsCrawling[bossIndex] = false;
			g_NpcChangeToCrawl[bossIndex] = true;
		}
	}

	if ((state == STATE_CHASE || state == STATE_ALERT || state == STATE_WANDER) && !g_SlenderInDeathcam[bossIndex])
	{
		int pitch = combatChar.LookupPoseParameter("body_pitch");
		int yaw = combatChar.LookupPoseParameter("body_yaw");
		float dir[3], ang[3], npcCenter[3];
		combatChar.WorldSpaceCenter(npcCenter);
		SubtractVectors(npcCenter, g_SlenderGoalPos[bossIndex], dir);
		NormalizeVector(dir, dir);
		GetVectorAngles(dir, ang);

		float pitchPose = combatChar.GetPoseParameter(pitch);
		float yawPose = combatChar.GetPoseParameter(yaw);

		ang[0] = UTIL_Clamp(UTIL_AngleNormalize(ang[0]), -44.0, 89.0);
		combatChar.SetPoseParameter(pitch, UTIL_ApproachAngle(state == STATE_CHASE && g_SlenderTargetIsVisible[bossIndex] ? ang[0] : 0.0, pitchPose, (NPCGetTurnRate(bossIndex)/1000.0) * 16.0));
		ang[1] = UTIL_Clamp(-UTIL_AngleNormalize(UTIL_AngleDiff(UTIL_AngleNormalize(ang[1]), UTIL_AngleNormalize(myEyeAng[1]+180.0))), -44.0,  44.0);
		combatChar.SetPoseParameter(yaw, UTIL_ApproachAngle(state == STATE_CHASE && g_SlenderTargetIsVisible[bossIndex] ? ang[1] : 0.0, yawPose, (NPCGetTurnRate(bossIndex)/1000.0) * 16.0));

		int moveX = combatChar.LookupPoseParameter("move_x");
		int moveY = combatChar.LookupPoseParameter("move_y");

		float groundSpeed = loco.GetGroundSpeed();
		if (moveX > 0 || moveY > 0)
		{
			if (groundSpeed != 0.0)
			{
				float forwardVector[3], rightVector[3], upVector[3], motionVector[3];
				combatChar.GetVectors(forwardVector, rightVector, upVector);
				loco.GetGroundMotionVector(motionVector);

				if (moveX >= 0)
				{
					combatChar.SetPoseParameter(moveX, GetVectorDotProduct(motionVector,forwardVector));
				}
				if (moveY >= 0)
				{
					combatChar.SetPoseParameter(moveY, GetVectorDotProduct(motionVector,rightVector));
				}
			}
			else
			{
				if (moveX >= 0)
				{
					combatChar.SetPoseParameter(moveX, 0.0);
				}
				if (moveY >= 0)
				{
					combatChar.SetPoseParameter(moveY, 0.0);
				}
			}
			float _groundSpeed = GetEntPropFloat(bossEnt, Prop_Data, "m_flGroundSpeed");
			if (_groundSpeed != 0.0 && loco.IsOnGround())
			{
				float returnValue = groundSpeed / _groundSpeed;
				if (returnValue < -4.0)
				{
					returnValue = -4.0;
				}
				if (returnValue > 12.0)
				{
					returnValue = 12.0;
				}

				SetEntPropFloat(bossEnt, Prop_Send, "m_flPlaybackRate", returnValue);
			}
		}
	}

	if (state != STATE_IDLE && state != STATE_STUN && state != STATE_ATTACK && !g_SlenderSpawning[bossIndex] && !g_SlenderInDeathcam[bossIndex])
	{
		bool runUnstuck = (state == STATE_CHASE && g_SlenderCalculatedSpeed[bossIndex] > 0.0);
		if (!runUnstuck)
		{
			runUnstuck = (state == STATE_ALERT && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0);
		}
		if (!runUnstuck)
		{
			runUnstuck = (state == STATE_WANDER && (NPCGetFlags(bossIndex) & SFF_WANDERMOVE) && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0 && difficulty >= RoundToNearest(NPCGetAttributeValue(bossIndex, "block walk speed under difficulty", 0.0)));
		}
		if (runUnstuck)
		{
			if (loco.GetGroundSpeed() <= 0.1 || GetVectorSquareMagnitude(myPos, g_LastPos[bossIndex]) < 0.1 || loco.IsStuck())
			{
				bool blockingProp = false;

				if (NPCGetFlags(bossIndex) & SFF_ATTACKPROPS)
				{
					for (int attackIndex2 = 0; attackIndex2 < NPCChaserGetAttackCount(bossIndex); attackIndex2++)
					{
						if (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam)
						{
							continue;
						}
						blockingProp = NPC_CanAttackProps(bossIndex,NPCChaserGetAttackRange(bossIndex, attackIndex2), NPCChaserGetAttackSpread(bossIndex, attackIndex2));
						if (blockingProp)
						{
							break;
						}
					}
				}
				if (!blockingProp)
				{
					if (g_LastStuckTime[bossIndex] == 0.0)
					{
						g_LastStuckTime[bossIndex] = GetGameTime();
					}

					if ((g_LastStuckTime[bossIndex] <= GetGameTime()-1.0 || loco.GetStuckDuration() >= 1.0) && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex] &&
					g_BossPathFollower[bossIndex].FirstSegment() != NULL_PATH_SEGMENT &&
					g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
					{
						float movePos[3];
						Segment segment;
						segment = g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment());
						segment.GetPos(movePos);
						bool pathResolved = false;

						if (SlenderChaseBoss_OnStuckResolvePath(bossEnt, myPos, myEyeAng, movePos, movePos))
						{
							if (NPCGetRaidHitbox(bossIndex) == 1)
							{
								if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
								{
									pathResolved = true;
									TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
									float origin[3];
									loco.SetVelocity(origin);
								}
								else
								{
									movePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
									{
										pathResolved = true;
										TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
										float origin[3];
										loco.SetVelocity(origin);
									}
								}
							}
							else if (NPCGetRaidHitbox(bossIndex) == 0)
							{
								if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
								{
									pathResolved = true;
									TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
									float origin[3];
									loco.SetVelocity(origin);
								}
								else
								{
									movePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
									{
										pathResolved = true;
										TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
										float origin[3];
										loco.SetVelocity(origin);
									}
								}
							}
						}
						if (!pathResolved)
						{
							if (NPCGetRaidHitbox(bossIndex) == 1)
							{
								if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
								{
									pathResolved = false;
									TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
									float origin[3];
									loco.SetVelocity(origin);
								}
								else
								{
									movePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
									{
										pathResolved = true;
										TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
										float origin[3];
										loco.SetVelocity(origin);
									}
									else
									{
										CNavArea area = TheNavMesh.GetNearestNavArea(myPos, _, 300.0);
										if (area == NULL_AREA)
										{
											area = segment.area;
										}
										if (area != NULL_AREA)
										{
											area.GetCenter(movePos);
											if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
											{
												pathResolved = false;
												TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
												float origin[3];
												loco.SetVelocity(origin);
											}
											else
											{
												movePos[2] += loco.GetStepHeight();
												if (!IsSpaceOccupied(movePos, g_SlenderDetectMins[bossIndex], g_SlenderDetectMaxs[bossIndex], bossEnt))
												{
													pathResolved = true;
													TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
											}
										}
										if (!pathResolved)
										{
											if (!SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_RestartSessionEnabled)
											{
												RemoveSlender(bossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else if (SF_IsBoxingMap())
											{
												float teleportPos[3];
												ArrayList respawnPoint = new ArrayList();
												char name[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
													if (StrContains(name, "sf2_boss_respawnpoint", false))
													{
														respawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (respawnPoint.Length > 0) ent = respawnPoint.Get(GetRandomInt(0,respawnPoint.Length-1));

												delete respawnPoint;
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
													TeleportEntity(bossEnt, teleportPos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
												else
												{
													RemoveSlender(bossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_RestartSessionEnabled)
											{
												ArrayList spawnPoint = new ArrayList();
												float teleportPos[3];
												int ent = -1, spawnTeam = 0;
												while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
												{
													spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
													if (spawnTeam == TFTeam_Red)
													{
														spawnPoint.Push(ent);
													}

												}
												ent = -1;
												if (spawnPoint.Length > 0)
												{
													ent = spawnPoint.Get(GetRandomInt(0,spawnPoint.Length-1));
												}

												delete spawnPoint;

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
													TeleportEntity(bossEnt, teleportPos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
												else RemoveSlender(bossIndex);
											}
										}
									}
								}
							}
							else if (NPCGetRaidHitbox(bossIndex) == 0)
							{
								if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
								{
									pathResolved = false;
									TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
									float origin[3];
									loco.SetVelocity(origin);
								}
								else
								{
									movePos[2] += loco.GetStepHeight();
									if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
									{
										pathResolved = true;
										TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
										float origin[3];
										loco.SetVelocity(origin);
									}
									else
									{
										CNavArea area = TheNavMesh.GetNearestNavArea(myPos, _, 300.0);
										if (area == NULL_AREA)
										{
											area = segment.area;
										}
										if (area != NULL_AREA)
										{
											area.GetCenter(movePos);
											if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
											{
												pathResolved = false;
												TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
												float origin[3];
												loco.SetVelocity(origin);
											}
											else
											{
												movePos[2] += loco.GetStepHeight();
												if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, bossEnt))
												{
													pathResolved = true;
													TeleportEntity(bossEnt, movePos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
											}
										}
										if (!pathResolved)
										{
											if (!SF_IsBoxingMap() && !SF_IsSlaughterRunMap() && !g_RestartSessionEnabled)
											{
												RemoveSlender(bossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
											}
											else if (SF_IsBoxingMap())
											{
												float teleportPos[3];
												ArrayList respawnPoint = new ArrayList();
												char name[32];
												int ent = -1;
												while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
												{
													GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
													if (StrContains(name, "sf2_boss_respawnpoint", false))
													{
														respawnPoint.Push(ent);
													}
												}
												ent = -1;
												if (respawnPoint.Length > 0)
												{
													ent = respawnPoint.Get(GetRandomInt(0,respawnPoint.Length-1));
												}

												delete respawnPoint;
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
													TeleportEntity(bossEnt, teleportPos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
												else
												{
													RemoveSlender(bossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_RestartSessionEnabled)
											{
												ArrayList spawnPoint = new ArrayList();
												float teleportPos[3];
												int ent = -1, spawnTeam = 0;
												while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
												{
													spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
													if (spawnTeam == TFTeam_Red)
													{
														spawnPoint.Push(ent);
													}

												}
												ent = -1;
												if (spawnPoint.Length > 0)
												{
													ent = spawnPoint.Get(GetRandomInt(0,spawnPoint.Length-1));
												}

												delete spawnPoint;

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
													TeleportEntity(bossEnt, teleportPos, NULL_VECTOR, NULL_VECTOR);
													float origin[3];
													loco.SetVelocity(origin);
												}
												else
												{
													RemoveSlender(bossIndex);
												}
											}
										}
									}
								}
							}
						}
						if (pathResolved)
						{
							loco.ClearStuckStatus();
							g_LastStuckTime[bossIndex] = 0.0;
						}
					}
				}
			}
			else
			{
				loco.ClearStuckStatus();
				g_LastStuckTime[bossIndex] = 0.0;
				g_LastPos[bossIndex] = myPos;
			}
		}
	}

	return;
}

public void SlenderSetNextThink(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseCombatCharacter(bossEnt).SetNextThink(GetGameTime() + 0.01);
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(bossEnt);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	int bossIndex = NPCGetFromEntIndex(bossEnt);
	if (bossIndex != -1)
	{
		int state = g_SlenderState[bossIndex];
		bool changeAngle = false;
		float posToAt[3];
		int attackIndex = NPCGetCurrentAttackIndex(bossIndex);
		if (state != STATE_STUN && !g_SlenderSpawning[bossIndex])
		{
			int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);

			if (g_NpcHasAlwaysLookAtTarget[bossIndex])
			{
				if (target && target != INVALID_ENT_REFERENCE)
				{
					changeAngle = true;
					GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
				}
			}
			else
			{
				switch (state)
				{
					case STATE_CHASE:
					{
						bool canSeeTarget = false;
						if (target && target != INVALID_ENT_REFERENCE)
						{
							float targetPos[3], myEyePos[3];
							NPCGetEyePosition(bossIndex, myEyePos);
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", targetPos);
							targetPos[2] += 18.0;
							if (GetVectorSquareMagnitude(targetPos, myEyePos) <= SquareFloat(100.0))
							{
								TR_TraceRayFilter(myEyePos, targetPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharacters, bossEnt);
								canSeeTarget = !TR_DidHit();
							}
						}

						if (canSeeTarget)
						{
							canSeeTarget = NPCShouldSeeEntity(bossIndex, target);
						}

						if (g_NpcHasAlwaysLookAtTargetWhileChasing[bossIndex] || canSeeTarget)
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);

							}
						}

						if (g_NpcUsesChaseInitialAnimation[bossIndex] || g_NpcUsesRageAnimation1[bossIndex] || g_NpcUsesRageAnimation2[bossIndex] || g_NpcUsesRageAnimation3[bossIndex] || g_NpcUseStartFleeAnimation[bossIndex])
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
							}
						}
						if (!loco.IsOnGround() || loco.IsClimbingOrJumping())
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								float targetPos[3], myEyePos[3];
								NPCGetEyePosition(bossIndex, myEyePos);
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", targetPos);
								targetPos[2] += 18.0;
								if (GetVectorSquareMagnitude(targetPos, myEyePos) <= SquareFloat(400.0))
								{
									changeAngle = true;
									GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
								}
							}
						}
					}
					case STATE_ATTACK:
					{
						if (g_NpcHasAlwaysLookAtTargetWhileAttacking[bossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex) && ((NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
							}
						}
						if (!NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex) && (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
							}
						}
					}
				}
			}
		}

		if (changeAngle)
		{
			loco.FaceTowards(posToAt);
		}

	}

	return;
}

public void CBaseNPC_Jump(NextBotGroundLocomotion nextbotLocomotion, float startPos[3], float endPos[3])
{
	float jumpVel[3];
	float actualHeight = endPos[2] - startPos[2];
	float height = actualHeight;
	if (height < 16.0)
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

	SubtractVectors(endPos, startPos, jumpVel);
	jumpVel[0] /= time;
	jumpVel[1] /= time;
	jumpVel[2] /= time;

	jumpVel[2] = speed;
	jumpVel[2] += height+additionalHeight;

	float flJumpSpeed = GetVectorLength(jumpVel, true);
	float flMaxSpeed = SquareFloat(650.0);
	if (flJumpSpeed > flMaxSpeed)
	{
		jumpVel[0] *= (flMaxSpeed / flJumpSpeed);
		jumpVel[1] *= (flMaxSpeed / flJumpSpeed);
		jumpVel[2] *= (flMaxSpeed / flJumpSpeed);
	}

	nextbotLocomotion.Jump();
	nextbotLocomotion.SetVelocity(jumpVel);
}

stock bool SlenderChaseBoss_OnStuckResolvePath(int slender, float myPos[3], float myAng[3], float goalPosition[3], float returnFloat[3])
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
			myAng[1] += float(y);
			for(int r=30; r<=300; r+=10)
			{
				float flFreePos[3];
				GetPositionForward(myPos, myAng, flFreePos, float(r));

				// Perform a line of sight check to avoid spawning players in unreachable map locations.
				TR_TraceRayFilter(myPos, flFreePos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);

				if (!TR_DidHit())
				{
					// Perform an other line of sight check to avoid moving in a area that can't reach the original goal!
					TR_TraceRayFilter(flFreePos, goalPosition, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
					if (!TR_DidHit())
					{
						TR_TraceHullFilter(myPos, flFreePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, TraceRayDontHitAnyEntity, slender);

						if (!TR_DidHit())
						{
							returnFloat = flFreePos;
							myAng[1] -= float(y);
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
			myAng[1] -= float(y);
		}
		attemp++;
	}
	return false;
}
