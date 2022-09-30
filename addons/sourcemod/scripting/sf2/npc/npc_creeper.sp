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

void Spawn_Statue(int npcIndex)
{
	g_NpcStatueMoving[npcIndex] = false;
	g_SlenderTarget[npcIndex] = INVALID_ENT_REFERENCE;
	g_SlenderStatueIdleLifeTime[npcIndex] = GetGameTime() + g_NpcStatueIdleLifetime[npcIndex][GetLocalGlobalDifficulty()];
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

void SlenderStatueSetNextThink(int bossEnt)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseCombatCharacter(bossEnt).SetNextThink(GetGameTime());

	return;
}

Action Timer_SlenderBlinkBossThink(Handle timer, any entref)
{
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

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	if (npc == INVALID_NPC)
	{
		return Plugin_Stop;
	}

	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();

	int difficulty = g_DifficultyConVar.IntValue;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	bool attackWaiters = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		float gameTime = GetGameTime();
		float chaseDurationTimeAddMin = g_NpcStatueChaseDurationAddMin[bossIndex][difficulty];
		float chaseDurationTimeAddMax = g_NpcStatueChaseDurationAddMax[bossIndex][difficulty];
		bool move = false;
		if (PeopleCanSeeSlender(bossIndex, true, SlenderUsesBlink(bossIndex), !attackWaiters))
		{
			if (g_NpcTimeUntilAbandon[bossIndex] < gameTime)
			{
				g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
			}
			g_NpcTimeUntilAbandon[bossIndex] += chaseDurationTimeAddMin;
			if (g_NpcTimeUntilAbandon[bossIndex] > (gameTime + NPCStatueChaseDuration(bossIndex, difficulty)))
			{
				g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
			}
			for (int i = 0; i < MAX_NPCTELEPORTER; i++)
			{
				if (NPCGetTeleporter(bossIndex, i) != INVALID_ENT_REFERENCE)
				{
					NPCSetTeleporter(bossIndex, i, INVALID_ENT_REFERENCE);
				}
			}
		}

		int origTarget = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
		if (SF_BossesChaseEndlessly() || SF_IsSlaughterRunMap() && IsValidClient(origTarget))
		{
			g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
		}

		if (SF_BossesChaseEndlessly() || SF_IsSlaughterRunMap())
		{
			if (!IsValidClient(origTarget) || (IsValidClient(origTarget) && g_PlayerEliminated[origTarget]))
			{
				if (NPCAreAvailablePlayersAlive())
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
							g_SlenderTarget[bossIndex] = EntIndexToEntRef(raidTarget);
							g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
						}
					}
					delete arrayRaidTargets;
				}
			}
		}

		int bestPlayer = -1;
		ArrayList array = new ArrayList();

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInDeathCam(i) || (!attackWaiters && g_PlayerEliminated[i]) || DidClientEscape(i) || IsClientInGhostMode(i) || !PlayerCanSeeSlender(i, bossIndex, false, false, !attackWaiters))
			{
				continue;
			}

			if (!NPCShouldSeeEntity(bossIndex, i))
			{
				continue;
			}

			array.Push(i);
		}

		if (array.Length)
		{
			float slenderPos[3];
			SlenderGetAbsOrigin(bossIndex, slenderPos);

			float tempPos[3];
			int tempPlayer = -1;
			float tempDist = SquareFloat(16384.0);
			for (int i = 0; i < array.Length; i++)
			{
				int client = array.Get(i);
				GetClientAbsOrigin(client, tempPos);
				if (GetVectorSquareMagnitude(tempPos, slenderPos) < tempDist)
				{
					tempPlayer = client;
					tempDist = GetVectorSquareMagnitude(tempPos, slenderPos);
				}
				if (SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(tempPos, slenderPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
				{
					TF2_StunPlayer(client, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
				}
			}

			bestPlayer = tempPlayer;
			if (bestPlayer != -1)
			{
				g_SlenderTarget[bossIndex] = EntIndexToEntRef(bestPlayer);
				if (g_NpcTimeUntilAbandon[bossIndex] < gameTime)
				{
					g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
				}
			}
		}

		delete array;

		if (!PeopleCanSeeSlender(bossIndex, true, SlenderUsesBlink(bossIndex), !attackWaiters))
		{
			int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
			if (IsTargetValidForSlender(target, attackWaiters) && gameTime < g_NpcTimeUntilAbandon[bossIndex] && (gameTime - g_SlenderLastKill[bossIndex]) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
			{
				move = true;
				float slenderPos[3], pos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", slenderPos);
				GetClientAbsOrigin(target, pos);
				if (NPCGetTeleporter(bossIndex, 0) != INVALID_ENT_REFERENCE)
				{
					int iTeleporter = EntRefToEntIndex(NPCGetTeleporter(bossIndex, 0));
					if (IsValidEntity(iTeleporter) && iTeleporter > MaxClients)
					{
						GetEntPropVector(iTeleporter, Prop_Data, "m_vecAbsOrigin", pos);
					}
				}
				g_BossPathFollower[bossIndex].ComputeToPos(bot, pos);

				float maxRange = g_NpcStatueModelChangeDistMax[bossIndex][difficulty];
				float dist = GetVectorSquareMagnitude(slenderPos, pos);

				char buffer[PLATFORM_MAX_PATH];

				if (dist < SquareFloat(maxRange * 0.33))
				{
					GetSlenderModel(bossIndex, 2, buffer, sizeof(buffer));
				}
				else if (dist < SquareFloat(maxRange * 0.66))
				{
					GetSlenderModel(bossIndex, 1, buffer, sizeof(buffer));
				}
				else
				{
					GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));
				}

				// Fallback if error.
				if (buffer[0] == '\0' || strcmp(buffer, "models/") == 0)
				{
					GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));
				}

				SetEntityModel(slender, buffer);

				if (PlayerCanSeeSlender(target, bossIndex, false, !attackWaiters))
				{
					float distRatio = (dist / SquareFloat(maxRange));

					float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * distRatio);

					if (chaseDurationAdd > 0.0)
					{
						g_NpcTimeUntilAbandon[bossIndex] += chaseDurationAdd;
						if (g_NpcTimeUntilAbandon[bossIndex] > (gameTime + NPCStatueChaseDuration(bossIndex, difficulty)))
						{
							g_NpcTimeUntilAbandon[bossIndex] = gameTime + NPCStatueChaseDuration(bossIndex, difficulty);
						}
					}
				}

				if (dist <= SquareFloat(NPCGetInstantKillRadius(bossIndex)))
				{
					if (NPCGetFlags(bossIndex) & SFF_FAKE)
					{
						SlenderMarkAsFake(bossIndex);
						return Plugin_Stop;
					}
					else
					{
						g_SlenderLastKill[bossIndex] = gameTime;
						ClientStartDeathCam(target, bossIndex, pos);
						g_LastStuckTime[bossIndex] = gameTime + NPCGetInstantKillCooldown(bossIndex, difficulty) + 0.1;
						if (NPCGetInstantKillCooldown(bossIndex, difficulty) > 0.0)
						{
							g_NpcStatueMoving[bossIndex] = false;
							loco.ClearStuckStatus();
						}
						g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
					}
				}

				g_SlenderStatueIdleLifeTime[bossIndex] = gameTime + g_NpcStatueIdleLifetime[bossIndex][difficulty];
			}
			else
			{
				float origin[3];
				SlenderGetAbsOrigin(bossIndex, origin);
				origin[2] -= 10.0;
				g_LastPos[bossIndex] = origin;
			}
		}

		SF2BossProfileSoundInfo soundInfo;
		if (move)
		{
			ArrayList soundList;
			char buffer[PLATFORM_MAX_PATH];
			GetStatueProfileSingleMoveSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
				if (buffer[0] != '\0')
				{
					EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
				}
			}

			GetStatueProfileMoveSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
				if (buffer[0] != '\0')
				{
					EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, SND_CHANGEVOL, soundInfo.Volume, soundInfo.Pitch);
				}
			}
			soundList = null;
		}
		else
		{
			GetStatueProfileMoveSounds(profile, soundInfo);
			soundInfo.StopAllSounds(slender);
		}
		g_NpcStatueMoving[bossIndex] = move;
	}

	return Plugin_Continue;
}