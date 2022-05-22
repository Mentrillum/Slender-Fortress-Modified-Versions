#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

static bool g_NpcStatueMoving[MAX_BOSSES];

static float g_NpcStatueChaseDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcStatueChaseDurationAddMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcStatueChaseDurationAddMax[MAX_BOSSES][Difficulty_Max];

static float g_NpcTimeUntilAbandon[MAX_BOSSES] = { -1.0, ... };

float NPCStatueChaseDuration(int npcIndex, int difficulty)
{
	return g_NpcStatueChaseDuration[npcIndex][difficulty];
}

int NPCStatueOnSelectProfile(int npcIndex)
{
	SF2StatueBossProfile profile = SF2StatueBossProfile(NPCGetProfileIndex(npcIndex));

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcStatueChaseDuration[npcIndex][difficulty] = profile.GetChaseDuration(difficulty);
		g_NpcStatueChaseDurationAddMin[npcIndex][difficulty] = profile.GetChaseDurationAddVisibilityMin(difficulty);
		g_NpcStatueChaseDurationAddMax[npcIndex][difficulty] = profile.GetChaseDurationAddVisibilityMax(difficulty);
	}
}

void Spawn_Statue(int npcIndex)
{
	g_NpcStatueMoving[npcIndex] = false;
	g_SlenderTarget[npcIndex] = INVALID_ENT_REFERENCE;
}

public void SlenderStatueBossProcessMovement(int iBoss)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(iBoss);
	if (npc == INVALID_NPC)
	{
		SDKUnhook(iBoss, SDKHook_Think, SlenderStatueBossProcessMovement); //What no boss?
		return;
	}

	int bossIndex = NPCGetFromEntIndex(iBoss);
	if (bossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderStatueBossProcessMovement);
		return;
	}

	INextBot bot = npc.GetBot();
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	char slenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, slenderProfile, sizeof(slenderProfile));

	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	
	float myPos[3], myEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", myPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", myEyeAng);

	int state = g_SlenderState[bossIndex];
	g_SlenderOldState[bossIndex] = state;

	float originalSpeed = NPCGetSpeed(bossIndex, difficulty) + NPCGetAddSpeed(bossIndex);
	float speed = originalSpeed;
	speed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15.0) + (NPCGetAnger(bossIndex) * g_RoundDifficultyModifier);

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
		TeleportEntity(iBoss, NULL_VECTOR, ang, NULL_VECTOR);
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
		
		if (!g_NpcVelocityCancel[bossIndex] && IsSpaceOccupiedIgnorePlayersAndEnts(myPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
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

					if ((g_LastStuckTime[bossIndex] <= GetGameTime()-1.0 || loco.GetStuckDuration() >= 1.0) && !g_NpcIsRunningToHeal[bossIndex] && !g_NpcIsHealing[bossIndex] && 
					g_BossPathFollower[bossIndex].FirstSegment() != NULL_PATH_SEGMENT && 
					g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment()) != NULL_PATH_SEGMENT)
					{
						float movePos[3];
						Segment segment;
						segment = g_BossPathFollower[bossIndex].NextSegment(g_BossPathFollower[bossIndex].FirstSegment());
						segment.GetPos(movePos);
						bool pathResolved = false;

						if (SlenderChaseBoss_OnStuckResolvePath(iBoss, myPos, myEyeAng, movePos, movePos))
						{
							if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
							{
								pathResolved = true;
								TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
								float origin[3];
								loco.SetVelocity(origin);
							}
							else
							{
								movePos[2] += loco.GetStepHeight();
								if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									pathResolved = true;
									TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
									float origin[3];
									loco.SetVelocity(origin);
								}
							}
						}
						if (!pathResolved)
						{
							if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
							{
								pathResolved = false;
								TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
								float origin[3];
								loco.SetVelocity(origin);
							}
							else
							{
								movePos[2] += loco.GetStepHeight();
								if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									pathResolved = true;
									TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
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
										if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
										{
											pathResolved = false;
											TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
											float origin[3];
											loco.SetVelocity(origin);
										}
										else
										{
											movePos[2] += loco.GetStepHeight();
											if (!IsSpaceOccupied(movePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
											{
												pathResolved = true;
												TeleportEntity(iBoss, movePos, NULL_VECTOR, NULL_VECTOR);
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
												TeleportEntity(iBoss, teleportPos, NULL_VECTOR, NULL_VECTOR);
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

public void SlenderStatueSetNextThink(int iBoss)
{
	if (!g_Enabled)
	{
		return;
	}

	CBaseCombatCharacter(iBoss).SetNextThink(GetGameTime() + 0.01);
	
	return;
}

public Action Timer_SlenderBlinkBossThink(Handle timer, any entref)
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
	
	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		float chaseDurationTimeAddMin = g_NpcStatueChaseDurationAddMin[bossIndex][difficulty];
		float chaseDurationTimeAddMax = g_NpcStatueChaseDurationAddMax[bossIndex][difficulty];
		bool move = false;
		if (PeopleCanSeeSlender(bossIndex, true, SlenderUsesBlink(bossIndex)))
		{
			if (g_NpcTimeUntilAbandon[bossIndex] < GetGameTime())
			{
				g_NpcTimeUntilAbandon[bossIndex] = GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty);
			}
			g_NpcTimeUntilAbandon[bossIndex] += chaseDurationTimeAddMin;
			if (g_NpcTimeUntilAbandon[bossIndex] > (GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty)))
			{
				g_NpcTimeUntilAbandon[bossIndex] = GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty);
			}
			for (int i = 0; i < MAX_NPCTELEPORTER; i++)
			{
				if (NPCGetTeleporter(bossIndex, i) != INVALID_ENT_REFERENCE)
				{
					NPCSetTeleporter(bossIndex, i, INVALID_ENT_REFERENCE);
				}
			}
		}

		int bestPlayer = -1;
		ArrayList array = new ArrayList();

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInDeathCam(i) || g_PlayerEliminated[i] || DidClientEscape(i) || IsClientInGhostMode(i) || !PlayerCanSeeSlender(i, bossIndex, false, false))
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
				if (g_NpcTimeUntilAbandon[bossIndex] < GetGameTime())
				{
					g_NpcTimeUntilAbandon[bossIndex] = GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty);
				}
			}
		}

		delete array;

		if (!PeopleCanSeeSlender(bossIndex, true, SlenderUsesBlink(bossIndex)))
		{
			int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
			if (IsTargetValidForSlender(target) && GetGameTime() < g_NpcTimeUntilAbandon[bossIndex] && (GetGameTime() - g_SlenderLastKill[bossIndex]) >= NPCGetInstantKillCooldown(bossIndex, difficulty))
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
					
				float maxRange = g_SlenderTeleportMaxRange[bossIndex][difficulty];
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
				if (buffer[0] == '\0')
				{
					GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));
				}

				SetEntityModel(slender, buffer);

				if (PlayerCanSeeSlender(target, bossIndex, false))
				{
					float distRatio = (dist / SquareFloat(maxRange));

					float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * distRatio);

					if (chaseDurationAdd > 0.0)
					{
						g_NpcTimeUntilAbandon[bossIndex] += chaseDurationAdd;
						if (g_NpcTimeUntilAbandon[bossIndex] > (GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty)))
						{
							g_NpcTimeUntilAbandon[bossIndex] = GetGameTime() + NPCStatueChaseDuration(bossIndex, difficulty);
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
						g_SlenderLastKill[bossIndex] = GetGameTime();
						ClientStartDeathCam(target, bossIndex, pos);
						g_LastStuckTime[bossIndex] = GetGameTime() + NPCGetInstantKillCooldown(bossIndex, difficulty) + 0.1;
						if (NPCGetInstantKillCooldown(bossIndex, difficulty) > 0.0)
						{
							g_NpcStatueMoving[bossIndex] = false;
							loco.ClearStuckStatus();
						}
						g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
					}
				}
			}
			else
			{
				float origin[3];
				SlenderGetAbsOrigin(bossIndex, origin);
				origin[2] -= 10.0;
				g_LastPos[bossIndex] = origin;
			}
		}
		
		if (move)
		{
			char buffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_move_single", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			}
			
			GetRandomStringFromProfile(profile, "sound_move", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				EmitSoundToAll(buffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, SND_CHANGEVOL);
			}
		}
		else
		{
			char buffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_move", buffer, sizeof(buffer));
			if (buffer[0] != '\0')
			{
				StopSound(slender, SNDCHAN_AUTO, buffer);
			}
		}
		g_NpcStatueMoving[bossIndex] = move;
	}
	
	return Plugin_Continue;
}