#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

#pragma semicolon 1

static float g_NpcStatueChaseDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcStatueChaseDurationAddMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcStatueChaseDurationAddMax[MAX_BOSSES][Difficulty_Max];

static float g_NpcTimeUntilAbandon[MAX_BOSSES] = { -1.0, ... };

static float g_NpcStatueIdleLifetime[MAX_BOSSES][Difficulty_Max];
static float g_NpcStatueModelChangeDistMax[MAX_BOSSES][Difficulty_Max];

float NPCStatueChaseDuration(int npcIndex, int difficulty)
{
	return g_NpcStatueChaseDuration[npcIndex][difficulty];
}

float NPCStatueGetChaseDurationAddMin(int npcIndex, int difficulty)
{
	return g_NpcStatueChaseDurationAddMin[npcIndex][difficulty];
}

float NPCStatueGetChaseDurationAddMax(int npcIndex, int difficulty)
{
	return g_NpcStatueChaseDurationAddMax[npcIndex][difficulty];
}

float NPCStatueGetIdleLifetime(int npcIndex, int difficulty)
{
	return g_NpcStatueIdleLifetime[npcIndex][difficulty];
}

float NPCStatueGetModelChangeDistance(int npcIndex, int difficulty)
{
	return g_NpcStatueModelChangeDistMax[npcIndex][difficulty];
}

void NPCStatueOnSelectProfile(const char[] profile, int npcIndex)
{
	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcStatueChaseDuration[npcIndex][difficulty] = GetStatueProfileChaseDuration(profile, difficulty);
		g_NpcStatueChaseDurationAddMin[npcIndex][difficulty] = GetStatueProfileChaseDurationAddVisibleMin(profile, difficulty);
		g_NpcStatueChaseDurationAddMax[npcIndex][difficulty] = GetStatueProfileChaseDurationAddVisibleMax(profile, difficulty);

		g_NpcStatueIdleLifetime[npcIndex][difficulty] = GetStatueProfileIdleLifeTime(profile, difficulty);
		g_NpcStatueModelChangeDistMax[npcIndex][difficulty] = GetStatueProfileModelChangeDistMax(profile, difficulty);
	}
}

CBaseCombatCharacter Spawn_Statue(SF2NPC_BaseNPC controller, const float pos[3], const float ang[3])
{
	g_SlenderTarget[controller.Index] = INVALID_ENT_REFERENCE;
	g_SlenderStatueIdleLifeTime[controller.Index] = GetGameTime() + g_NpcStatueIdleLifetime[controller.Index][GetLocalGlobalDifficulty()];
	return SF2_StatueEntity.Create(controller, pos, ang);
}

void SlenderStatueBossProcessMovement(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(bossEnt);
	if (npc == INVALID_NPC)
	{
		SDKUnhook(bossEnt, SDKHook_Think, SlenderStatueBossProcessMovement); //What no boss?
		return;
	}

	int bossIndex = NPCGetFromEntIndex(bossEnt);
	if (bossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(bossEnt, SDKHook_Think, SlenderStatueBossProcessMovement);
		return;
	}

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

	INextBot bot = npc.GetBot();
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	SF2_StatueEntity statue = SF2_StatueEntity(bossEnt);

	char slenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, slenderProfile, sizeof(slenderProfile));

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	float myPos[3], myEyeAng[3];
	GetEntPropVector(bossEnt, Prop_Data, "m_vecAbsOrigin", myPos);
	GetEntPropVector(bossEnt, Prop_Data, "m_angAbsRotation", myEyeAng);

	int state = g_SlenderState[bossIndex];
	g_SlenderOldState[bossIndex] = state;

	float originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	float speed = originalSpeed;
	speed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0);

	if (!g_SlenderInDeathcam[bossIndex] && statue.IsMoving)
	{
		npc.flWalkSpeed = speed * 10.0;
		npc.flRunSpeed = speed * 10.0;
	}
	else
	{
		npc.flWalkSpeed = 0.0;
		npc.flRunSpeed = 0.0;
	}
	npc.flAcceleration = 50000.0;

	// Process angles.
	bool changeAngle = false;
	float posToAt[3];
	g_SlenderTarget[bossIndex] = EnsureEntRef(statue.Target);
	if (statue.IsMoving)
	{
		int target = statue.Target;
		if (target && target != INVALID_ENT_REFERENCE)
		{
			changeAngle = true;
			GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", posToAt);
		}
	}

	if (changeAngle)
	{
		float ang[3];
		SubtractVectors(posToAt, myPos, ang);
		GetVectorAngles(ang, ang);
		AddVectors(ang, g_SlenderEyeAngOffset[bossIndex], ang);
		for (int cell2 = 0; cell2 < 3; cell2++)
		{
			ang[cell2] = AngleNormalize(ang[cell2]);
		}
		ang[0] = 0.0;
		TeleportEntity(bossEnt, NULL_VECTOR, ang, NULL_VECTOR);
	}

	if (!g_SlenderSpawning[bossIndex] && !g_SlenderInDeathcam[bossIndex])
	{
		if (statue.IsMoving)
		{
			loco.Run();
			g_BossPathFollower[bossIndex].Update(bot);
			bot.Update();
		}
		else
		{
			loco.Stop();
		}
		if (loco.IsOnGround() && !loco.IsClimbingOrJumping() && statue.IsMoving)
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
					CBaseNPC_Jump(bossEnt, loco, myPos, pathEndPos);
				}
			}
		}
	}

	if (!loco.IsClimbingOrJumping() && !g_SlenderSpawning[bossIndex])
	{
		float hullcheckmins[3], hullcheckmaxs[3];
		hullcheckmins = HULL_HUMAN_MINS;
		hullcheckmaxs = HULL_HUMAN_MAXS;

		hullcheckmins[0] -= 20.0;
		hullcheckmins[1] -= 20.0;

		hullcheckmaxs[0] += 20.0;
		hullcheckmaxs[1] += 20.0;

		hullcheckmins[2] += loco.GetStepHeight();
		hullcheckmaxs[2] += 5.0;

		if (!g_NpcVelocityCancel[bossIndex] && IsSpaceOccupiedIgnorePlayersAndEnts(myPos, hullcheckmins, hullcheckmaxs, bossEnt))//The boss will start to merge with shits, cancel out velocity.
		{
			float origin[3];
			loco.SetVelocity(origin);
			g_NpcVelocityCancel[bossIndex] = true;
		}
	}
	else
	{
		g_NpcVelocityCancel[bossIndex] = false;
	}

	if (statue.IsMoving && !g_SlenderInDeathcam[bossIndex] && GetGameTime() < g_NpcTimeUntilAbandon[bossIndex] && (GetGameTime() - g_SlenderLastKill[bossIndex]) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
	{
		bool runUnstuck = true;
		if (runUnstuck)
		{
			if (GetVectorSquareMagnitude(myPos, g_LastPos[bossIndex]) < 0.1 || loco.IsStuck())
			{
				bool blockingProp = false;

				if (!blockingProp)
				{
					if (g_LastStuckTime[bossIndex] == 0.0)
					{
						g_LastStuckTime[bossIndex] = GetGameTime();
					}

					if ((g_LastStuckTime[bossIndex] <= GetGameTime() - 1.0 || loco.GetStuckDuration() >= 1.0))
					{
						float destination[3];
						CNavArea area = TheNavMesh.GetNearestNavArea(g_LastPos[bossIndex], _, _, _, false);
						area.GetCenter(destination);
						float tempMaxs[3];
						npc.GetBodyMaxs(tempMaxs);
						float traceMins[3];
						traceMins[0] = g_SlenderDetectMins[bossIndex][0];
						traceMins[1] = g_SlenderDetectMins[bossIndex][1];
						traceMins[2] = 0.0;

						float traceMaxs[3];
						traceMaxs[0] = g_SlenderDetectMaxs[bossIndex][0];
						traceMaxs[1] = g_SlenderDetectMaxs[bossIndex][1];
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
						g_LastStuckTime[bossIndex] = GetGameTime();
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