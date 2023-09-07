#if defined _sf2_npc_chaser_pathing_included
 #endinput
#endif
#define _sf2_npc_chaser_pathing_included

#pragma semicolon 1

static float g_NpcEstimatedYaw[MAX_BOSSES] = { 0.0, ... };

void SlenderChaseBossProcessMovement(int bossEnt)
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

	float gameTime = GetGameTime();

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
				if (!g_NpcUsesChaseInitialAnimation[bossIndex] && !NPCIsRaging(bossIndex)
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
				if (NPCChaserGetAttackWhileRunningState(bossIndex, currentAttackIndex, difficulty) &&
					!NPCIsRaging(bossIndex) && gameTime >= g_NpcBaseAttackRunDelayTime[bossIndex][currentAttackIndex])
				{
					if (NPCChaserGetAttackRunDuration(bossIndex, currentAttackIndex, difficulty) > 0.0)
					{
						if (gameTime < g_NpcBaseAttackRunDurationTime[bossIndex][currentAttackIndex])
						{
							float attackSpeed, originalSpeed;
							originalSpeed = NPCChaserGetAttackRunSpeed(bossIndex, currentAttackIndex, difficulty);
							if (g_RoundDifficultyModifier > 1.0)
							{
								attackSpeed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0);
							}
							else
							{
								attackSpeed = originalSpeed;
							}
							if (npc != INVALID_NPC)
							{
								attackSpeed *= g_SlenderSpeedMultiplier[bossIndex];
								float groundSpeed = GetEntPropFloat(bossEnt, Prop_Data, "m_flGroundSpeed") * g_SlenderSpeedMultiplier[bossIndex];
								if (groundSpeed > 0.0 && attackSpeed < groundSpeed)
								{
									npc.flWalkSpeed = groundSpeed;
									npc.flRunSpeed = groundSpeed;
								}
								else
								{
									npc.flWalkSpeed = attackSpeed;
									npc.flRunSpeed = attackSpeed;
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
					}
					else
					{
						float attackSpeed, originalSpeed;
						originalSpeed = NPCChaserGetAttackRunSpeed(bossIndex, currentAttackIndex, difficulty);

						if (g_RoundDifficultyModifier > 1.0)
						{
							attackSpeed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0);
						}
						else
						{
							attackSpeed = originalSpeed;
						}

						if (npc != INVALID_NPC)
						{
							attackSpeed *= g_SlenderSpeedMultiplier[bossIndex];
							float groundSpeed = GetEntPropFloat(bossEnt, Prop_Data, "m_flGroundSpeed") * g_SlenderSpeedMultiplier[bossIndex];
							if (groundSpeed > 0.0 && attackSpeed < groundSpeed)
							{
								npc.flWalkSpeed = groundSpeed;
								npc.flRunSpeed = groundSpeed;
							}
							else
							{
								npc.flWalkSpeed = attackSpeed;
								npc.flRunSpeed = attackSpeed;
							}
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
		if (NPCChaserGetAttackWhileRunningState(bossIndex, currentAttackIndex, difficulty))
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

					if (g_NpcUsesChaseInitialAnimation[bossIndex] || NPCIsRaging(bossIndex) || g_NpcUseStartFleeAnimation[bossIndex])
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
					if (g_NpcHasAlwaysLookAtTargetWhileAttacking[bossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex, difficulty) && ((NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
					{
						if (target && target != INVALID_ENT_REFERENCE)
						{
							changeAngle = true;
							GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
						}
					}
					if (!NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex, difficulty) && (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
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
				if (NPCChaserGetAttackWhileRunningState(bossIndex, attackIndex, difficulty))
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
		!g_NpcUsesChaseInitialAnimation[bossIndex] && !NPCIsRaging(bossIndex) &&
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

				if (g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, CLIMB_UP, 120.0) || g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, JUMP_OVER_GAP, 120.0)|| g_BossPathFollower[bossIndex].IsDiscontinuityAhead(bot, LADDER_UP, 120.0))
				{
					CBaseNPC_Jump(bossEnt, loco, myPos, pathEndPos);
				}
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
		float dir[3], ang[3], npcCenter[3], lookPos[3];
		combatChar.WorldSpaceCenter(npcCenter);
		int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
		if (target && target != INVALID_ENT_REFERENCE)
		{
			GetClientEyePosition(target, lookPos);
			lookPos[2] -= 20.0;
		}
		else
		{
			CopyVector(g_SlenderGoalPos[bossIndex], lookPos);
		}
		SubtractVectors(npcCenter, lookPos, dir);
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
				float returnValue = (groundSpeed / _groundSpeed) * g_NpcCurrentAnimationSequencePlaybackRate[bossIndex];
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

		int moveScale = combatChar.LookupPoseParameter("move_scale");
		int moveYaw = combatChar.LookupPoseParameter("move_yaw");

		float fwd[3], right[3], up[3];
		combatChar.GetVectors(fwd, right, up);

		float motionVector[3];
		loco.GetGroundMotionVector(motionVector);

		if (moveScale > 0)
		{
			float moveSpeed = loco.GetGroundSpeed();
			float scale = npc.flRunSpeed / moveSpeed;
			combatChar.SetPoseParameter(moveScale, scale);
		}

		if (moveYaw > 0)
		{
			float deltaTime = GetGameFrameTime();
			if (deltaTime > 0.0)
			{
				float myAngle[3], normalAngle, estimateYaw;
				estimateYaw = g_NpcEstimatedYaw[bossIndex];
				combatChar.GetLocalAngles(myAngle);

				if (motionVector[0] == 0.0 && motionVector[1] == 0.0)
				{
					float yawDelta = myAngle[1] - estimateYaw;
					yawDelta = AngleNormalize(yawDelta);

					if (deltaTime < 0.25)
					{
						yawDelta *= (deltaTime * 4.0);
					}
					else
					{
						yawDelta *= deltaTime;
					}

					estimateYaw += yawDelta;
					estimateYaw = AngleNormalize(estimateYaw);
				}
				else
				{
					estimateYaw = (ArcTangent2(motionVector[1], motionVector[0]) * 180.0 / 3.14159);
					estimateYaw = FloatClamp(estimateYaw, -180.0, 180.0);
				}
				normalAngle = AngleNormalize(myAngle[1]);
				g_NpcEstimatedYaw[bossIndex] = estimateYaw;
				float actualYaw = normalAngle - estimateYaw;
				actualYaw = AngleNormalize(-actualYaw);

				combatChar.SetPoseParameter(moveYaw, actualYaw);
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
			runUnstuck = (state == STATE_WANDER && (NPCGetFlags(bossIndex) & SFF_WANDERMOVE) && g_SlenderCalculatedWalkSpeed[bossIndex] > 0.0 &&
			difficulty >= RoundToNearest(NPCGetAttributeValue(bossIndex, SF2Attribute_BlockWalkSpeedUnderDifficulty)));
		}
		if (runUnstuck)
		{
			if (loco.GetGroundSpeed() <= 0.1 || GetVectorSquareMagnitude(myPos, g_LastPos[bossIndex]) <= 0.13 || loco.IsStuck())
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
						blockingProp = NPC_CanAttackProps(bossIndex,NPCChaserGetAttackRange(bossIndex, attackIndex2, difficulty), NPCChaserGetAttackSpread(bossIndex, attackIndex2, difficulty));
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
						g_LastStuckTime[bossIndex] = gameTime;
					}

					if ((g_LastStuckTime[bossIndex] <= gameTime - 1.0 || loco.GetStuckDuration() >= 1.0) &&
					!g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
					{
						float destination[3];
						CNavArea area = TheNavMesh.GetNearestNavArea(g_LastPos[bossIndex], _, _, _, false);
						area.GetCenter(destination);
						float tempMaxs[3];
						npc.GetBodyMaxs(tempMaxs);
						float traceMins[3];
						traceMins[0] = g_SlenderDetectMins[bossIndex][0] - 5.0;
						traceMins[1] = g_SlenderDetectMins[bossIndex][1] - 5.0;
						traceMins[2] = 0.0;

						float traceMaxs[3];
						traceMaxs[0] = g_SlenderDetectMaxs[bossIndex][0] + 5.0;
						traceMaxs[1] = g_SlenderDetectMaxs[bossIndex][1] + 5.0;
						traceMaxs[2] = tempMaxs[2];
						TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
						if (GetVectorSquareMagnitude(destination, g_LastPos[bossIndex]) <= SquareFloat(16.0) || TR_DidHit())
						{
							CursorData cursor = g_BossPathFollower[bossIndex].GetCursorData();
							SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, 256.0);
							int areaCount = collector.Count();
							ArrayList areaArray = new ArrayList(1, areaCount);
							int validAreaCount = 0;
							for (int i = 0; i < areaCount; i++)
							{
								if (collector.Get(i).GetCostSoFar() < 16.0)
								{
									continue;
								}
								if (cursor.segmentPrior != NULL_PATH_SEGMENT)
								{
									CNavArea segmentArea = cursor.segmentPrior.area;
									if (segmentArea == collector.Get(i))
									{
										continue;
									}
								}
								float navPos[3];
								collector.Get(i).GetCenter(navPos);
								if (GetVectorSquareMagnitude(myPos, navPos) <= SquareFloat(16.0))
								{
									continue;
								}
								areaArray.Set(validAreaCount, i);
								validAreaCount++;
							}

							int randomArea = 0, randomCell = 0;
							areaArray.Resize(validAreaCount);
							area = NULL_AREA;
							while (validAreaCount > 1)
							{
								randomCell = GetRandomInt(0, validAreaCount - 1);
								randomArea = areaArray.Get(randomCell);
								area = collector.Get(randomArea);
								area.GetCenter(destination);

								TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
								if (TR_DidHit())
								{
									area = NULL_AREA;
									validAreaCount--;
									int findValue = areaArray.FindValue(randomCell);
									if (findValue != -1)
									{
										areaArray.Erase(findValue);
									}
								}
								else
								{
									break;
								}
							}

							delete collector;
							delete areaArray;
						}
						g_BossPathFollower[bossIndex].GetClosestPosition(destination, destination, g_BossPathFollower[bossIndex].FirstSegment(), 128.0);
						TeleportEntity(bossEnt, destination, NULL_VECTOR, NULL_VECTOR);

						loco.ClearStuckStatus();
						g_LastStuckTime[bossIndex] = gameTime;
					}
				}
			}
			else
			{
				loco.ClearStuckStatus();
				g_LastStuckTime[bossIndex] += 0.03;
				if (g_LastStuckTime[bossIndex] > gameTime)
				{
					g_LastStuckTime[bossIndex] = gameTime;
				}
				g_LastPos[bossIndex] = myPos;
			}
		}
	}
	else
	{
		g_LastStuckTime[bossIndex] = gameTime;
	}

	if (gameTime >= g_SlenderNextFootstepSound[bossIndex])
	{
		SlenderCastFootstep(bossIndex);
	}

	return;
}

void SlenderSetNextThink(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseCombatCharacter(bossEnt).SetNextThink(GetGameTime());
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(bossEnt);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	int bossIndex = NPCGetFromEntIndex(bossEnt);
	if (bossIndex != -1)
	{
		int difficulty = GetLocalGlobalDifficulty(bossIndex);
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

						if (g_NpcUsesChaseInitialAnimation[bossIndex] || NPCIsRaging(bossIndex) || g_NpcUseStartFleeAnimation[bossIndex])
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
						if (g_NpcHasAlwaysLookAtTargetWhileAttacking[bossIndex] && !NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex, difficulty) && ((NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) != SF2BossAttackType_LaserBeam)))
						{
							if (target && target != INVALID_ENT_REFERENCE)
							{
								changeAngle = true;
								GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
							}
						}
						if (!NPCChaserGetAttackIgnoreAlwaysLooking(bossIndex, attackIndex, difficulty) && (NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(bossIndex, attackIndex) == SF2BossAttackType_LaserBeam))
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

void CBaseNPC_Jump(int entity, NextBotGroundLocomotion nextbotLocomotion, float startPos[3], float endPos[3])
{
	float jumpVel[3];
	startPos[2] += nextbotLocomotion.GetStepHeight();
	float actualHeight = endPos[2] - startPos[2];
	float height = actualHeight;
	if (height < 16.0)
	{
		height = 16.0;
	}

	float additionalHeight = 20.0;
	if (height < 32.0)
	{
		additionalHeight += 16.0;
	}
	float gravity = nextbotLocomotion.GetGravity();

	height += additionalHeight;

	float speed = SquareRoot(2.0 * gravity * height);
	float time = (speed / gravity);

	time += SquareRoot((2.0 * additionalHeight) / gravity);

	SubtractVectors(endPos, startPos, jumpVel);
	jumpVel[0] /= time;
	jumpVel[1] /= time;
	jumpVel[2] /= time;

	jumpVel[2] = speed;

	float jumpSpeed = GetVectorLength(jumpVel, true);
	float maxSpeed = SquareFloat(650.0);
	if (jumpSpeed > maxSpeed)
	{
		jumpVel[0] *= (maxSpeed / jumpSpeed);
		jumpVel[1] *= (maxSpeed / jumpSpeed);
		jumpVel[2] *= (maxSpeed / jumpSpeed);
	}

	CBaseEntity(entity).SetLocalOrigin(startPos);
	nextbotLocomotion.Jump();
	nextbotLocomotion.SetVelocity(jumpVel);
}
