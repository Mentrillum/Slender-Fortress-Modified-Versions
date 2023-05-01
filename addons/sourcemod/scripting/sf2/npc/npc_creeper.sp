#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

#pragma semicolon 1

static bool g_NpcStatueMoving[MAX_BOSSES];

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

CBaseCombatCharacter Spawn_Statue(int npcIndex)
{
	g_NpcStatueMoving[npcIndex] = false;
	g_SlenderTarget[npcIndex] = INVALID_ENT_REFERENCE;
	g_SlenderStatueIdleLifeTime[npcIndex] = GetGameTime() + g_NpcStatueIdleLifetime[npcIndex][GetLocalGlobalDifficulty()];
	return CBaseCombatCharacter(CreateEntityByName("sf2_statue_npc"));
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
	CBaseCombatCharacter combatChar = CBaseCombatCharacter(bossEnt);

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

	if (!g_SlenderInDeathcam[bossIndex] && g_NpcStatueMoving[bossIndex])
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
	if (g_NpcStatueMoving[bossIndex])
	{
		int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
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
		if (g_NpcStatueMoving[bossIndex])
		{
			loco.Run();
			g_BossPathFollower[bossIndex].Update(bot);
			bot.Update();
		}
		else
		{
			loco.Stop();
		}
		if (loco.IsOnGround() && !loco.IsClimbingOrJumping() && g_NpcStatueMoving[bossIndex])
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

	if (g_NpcStatueMoving[bossIndex] && !g_SlenderInDeathcam[bossIndex] && GetGameTime() < g_NpcTimeUntilAbandon[bossIndex] && (GetGameTime() - g_SlenderLastKill[bossIndex]) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
	{
		bool runUnstuck = true;
		if (runUnstuck)
		{
			if (GetVectorSquareMagnitude(myPos, g_LastPos[bossIndex]) < 0.1 || loco.IsStuck())
			{
				bool blockingProp = false;

				if (!blockingProp)
				{
					if (g_LastStuckTime[bossIndex] == 0.0) g_LastStuckTime[bossIndex] = GetGameTime();

					if ((g_LastStuckTime[bossIndex] <= GetGameTime()-1.0 || loco.GetStuckDuration() >= 1.0) &&
					!g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex])
					{
						float movePos[3];
						Segment segment;
						if (g_BossPathFollower[bossIndex].FirstSegment() != NULL_PATH_SEGMENT &&
						g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
						{
							segment = g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment());
							segment.GetPos(movePos);
						}
						else if (g_BossPathFollower[bossIndex].FirstSegment() != NULL_PATH_SEGMENT &&
						g_BossPathFollower[bossIndex].PriorSegment(g_BossPathFollower[bossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
						{
							segment = g_BossPathFollower[bossIndex].PriorSegment(g_BossPathFollower[bossIndex].FirstSegment());
							segment.GetPos(movePos);
						}
						else
						{
							g_BossPathFollower[bossIndex].GetClosestPosition(myPos, movePos);
						}
						bool pathResolved = false;

						if (SlenderChaseBoss_OnStuckResolvePath(bossEnt, myPos, myEyeAng, movePos, movePos))
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
						if (!pathResolved)
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
									CNavArea area = combatChar.GetLastKnownArea();
									if (area == NULL_AREA && segment != NULL_PATH_SEGMENT)
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
										if (!SF_IsSlaughterRunMap() && !g_RestartSessionEnabled)
										{
											RemoveSlender(bossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
										}
										else
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