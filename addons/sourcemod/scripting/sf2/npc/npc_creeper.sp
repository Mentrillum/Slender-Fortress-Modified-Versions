#if defined _sf2_npc_creeper_included
#endinput
#endif
#define _sf2_npc_creeper_included

static bool g_bNPCStatueMoving[MAX_BOSSES];

static float g_flNPCStatueChaseDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCStatueChaseDurationAddMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCStatueChaseDurationAddMax[MAX_BOSSES][Difficulty_Max];

static float g_flNPCTimeUntilAbandon[MAX_BOSSES] = { -1.0, ... };

static int g_iNPCStatueTeleporter[MAX_BOSSES][MAX_NPCTELEPORTER];

const SF2NPC_Statue SF2_INVALID_NPC_STATUE = view_as<SF2NPC_Statue>(-1);

methodmap SF2NPC_Statue < SF2NPC_BaseNPC
{
	public SF2NPC_Statue(int index)
	{
		return view_as<SF2NPC_Statue>(SF2NPC_BaseNPC(index));
	}

	public int GetTeleporter(int iTeleporterNumber)
	{
		return NPCStatueGetTeleporter(this.Index, iTeleporterNumber);
	}
	
	public void SetTeleporter(int iTeleporterNumber, int iEntity)
	{
		NPCStatueSetTeleporter(this.Index, iTeleporterNumber, iEntity);
	}
}

float NPCStatueChaseDuration(int iNPCIndex, int difficulty)
{
	return g_flNPCStatueChaseDuration[iNPCIndex][difficulty];
}

void NPCStatueSetTeleporter(int iBossIndex, int iTeleporterNumber, int iEntity)
{
	g_iNPCStatueTeleporter[iBossIndex][iTeleporterNumber] = iEntity;
}

int NPCStatueGetTeleporter(int iBossIndex, int iTeleporterNumber)
{
	return g_iNPCStatueTeleporter[iBossIndex][iTeleporterNumber];
}

int NPCStatueOnSelectProfile(int iNPCIndex)
{
	SF2StatueBossProfile profile = SF2StatueBossProfile(NPCGetProfileIndex(iNPCIndex));

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_flNPCStatueChaseDuration[iNPCIndex][difficulty] = profile.GetChaseDuration(difficulty);
		g_flNPCStatueChaseDurationAddMin[iNPCIndex][difficulty] = profile.GetChaseDurationAddVisibilityMin(difficulty);
		g_flNPCStatueChaseDurationAddMax[iNPCIndex][difficulty] = profile.GetChaseDurationAddVisibilityMax(difficulty);
	}
}

void Spawn_Statue(int iNPCIndex)
{
	g_bNPCStatueMoving[iNPCIndex] = false;
	g_iSlenderTarget[iNPCIndex] = INVALID_ENT_REFERENCE;
}

public void SlenderStatueBossProcessMovement(int iBoss)
{
	if (!g_bEnabled) return;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(iBoss);
	if (npc == INVALID_NPC)
	{
		SDKUnhook(iBoss, SDKHook_Think, SlenderStatueBossProcessMovement); //What no boss?
		return;
	}

	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderStatueBossProcessMovement);
		return;
	}

	INextBot bot = npc.GetBot();
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	CBaseCombatCharacter combatChar = CBaseCombatCharacter(iBoss);
	combatChar.DispatchAnimEvents(combatChar);

	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));

	int difficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	float flMyPos[3], flMyEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);

	int iState = g_iSlenderState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;

	float flOriginalSpeed = NPCGetSpeed(iBossIndex, difficulty) + NPCGetAddSpeed(iBossIndex);
	float flSpeed = flOriginalSpeed;
	flSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier) / 15.0) + (NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier);

	if (!g_bSlenderInDeathcam[iBossIndex] && g_bNPCStatueMoving[iBossIndex])
	{
		npc.flWalkSpeed = flSpeed * 10.0;
		npc.flRunSpeed = flSpeed * 10.0;
	}
	else
	{
		npc.flWalkSpeed = 0.0;
		npc.flRunSpeed = 0.0;
	}
	npc.flAcceleration = 50000.0;

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
	if (g_bNPCStatueMoving[iBossIndex])
	{
		int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
		if (iTarget && iTarget != INVALID_ENT_REFERENCE)
		{
			bChangeAngle = true;
			GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
		}
	}
	
	if (bChangeAngle)
	{
		float flAng[3];
		SubtractVectors(vecPosToAt, flMyPos, flAng);
		GetVectorAngles(flAng, flAng);
		AddVectors(flAng, g_flSlenderEyeAngOffset[iBossIndex], flAng);
		for (int iCell2 = 0; iCell2 < 3; iCell2++)
		{
			flAng[iCell2] = AngleNormalize(flAng[iCell2]);
		}
		flAng[0] = 0.0;
		TeleportEntity(iBoss, NULL_VECTOR, flAng, NULL_VECTOR);
	}

	if (!g_bSlenderSpawning[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex])
	{
		if (g_bNPCStatueMoving[iBossIndex])
		{
			loco.Run();
			g_pPath[iBossIndex].Update(bot);
			bot.Update();
		}
		else
		{
			loco.Stop();
		}
		if (loco.IsOnGround() && !loco.IsClimbingOrJumping() && g_bNPCStatueMoving[iBossIndex])
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
			}
		}
	}

	if (!loco.IsClimbingOrJumping() && !g_bSlenderSpawning[iBossIndex])
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
		
		if (!g_bNPCVelocityCancel[iBossIndex] && IsSpaceOccupiedIgnorePlayersAndEnts(flMyPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
		{
			float vec3Origin[3];
			loco.SetVelocity(vec3Origin);
			g_bNPCVelocityCancel[iBossIndex] = true;
		}
	}
	else
		g_bNPCVelocityCancel[iBossIndex] = false;

	if (g_bNPCStatueMoving[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex] && GetGameTime() < g_flNPCTimeUntilAbandon[iBossIndex] && (GetGameTime() - g_flSlenderLastKill[iBossIndex]) >= NPCGetInstantKillCooldown(iBossIndex, difficulty))
	{
		bool bRunUnstuck = true;
		if (bRunUnstuck)
		{
			if (GetVectorSquareMagnitude(flMyPos, g_flLastPos[iBossIndex]) < 0.1 || loco.IsStuck())
			{
				bool bBlockingProp = false;

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
						if (!bPathResolved)
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
										if (!SF_IsSlaughterRunMap() && !g_bRestartSessionEnabled)
										{
											RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
										}
										else
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

public void SlenderStatueSetNextThink(int iBoss)
{
	if (!g_bEnabled) return;

	CBaseCombatCharacter(iBoss).SetNextThink(GetGameTime() + 0.01);
	
	return;
}

public Action Timer_SlenderBlinkBossThink(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderEntityThink[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	if (npc == INVALID_NPC) return Plugin_Stop;

	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	INextBot bot = npc.GetBot();
	
	int difficulty = g_cvDifficulty.IntValue;

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, profile, sizeof(profile));
	
	if (NPCGetType(iBossIndex) == SF2BossType_Statue)
	{
		float chaseDurationTimeAddMin = g_flNPCStatueChaseDurationAddMin[iBossIndex][difficulty];
		float chaseDurationTimeAddMax = g_flNPCStatueChaseDurationAddMax[iBossIndex][difficulty];
		bool bMove = false;
		if (PeopleCanSeeSlender(iBossIndex, true, SlenderUsesBlink(iBossIndex)))
		{
			if (g_flNPCTimeUntilAbandon[iBossIndex] < GetGameTime())
			{
				g_flNPCTimeUntilAbandon[iBossIndex] = GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty);
			}
			g_flNPCTimeUntilAbandon[iBossIndex] += chaseDurationTimeAddMin;
			if (g_flNPCTimeUntilAbandon[iBossIndex] > (GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty)))
			{
				g_flNPCTimeUntilAbandon[iBossIndex] = GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty);
			}
			for (int i = 0; i < MAX_NPCTELEPORTER; i++)
			{
				if (NPCStatueGetTeleporter(iBossIndex, i) != INVALID_ENT_REFERENCE)
					NPCStatueSetTeleporter(iBossIndex, i, INVALID_ENT_REFERENCE);
			}
		}

		int iBestPlayer = -1;
		ArrayList hArray = new ArrayList();

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInDeathCam(i) || g_bPlayerEliminated[i] || DidClientEscape(i) || IsClientInGhostMode(i) || !PlayerCanSeeSlender(i, iBossIndex, false, false))
				continue;

			if (!NPCShouldSeeEntity(iBossIndex, i))
				continue;

			hArray.Push(i);
		}
			
		if (hArray.Length)
		{
			float flSlenderPos[3];
			SlenderGetAbsOrigin(iBossIndex, flSlenderPos);
			
			float flTempPos[3];
			int iTempPlayer = -1;
			float flTempDist = SquareFloat(16384.0);
			for (int i = 0; i < hArray.Length; i++)
			{
				int client = hArray.Get(i);
				GetClientAbsOrigin(client, flTempPos);
				if (GetVectorSquareMagnitude(flTempPos, flSlenderPos) < flTempDist)
				{
					iTempPlayer = client;
					flTempDist = GetVectorSquareMagnitude(flTempPos, flSlenderPos);
				}
				if (SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(flTempPos, flSlenderPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
					TF2_StunPlayer(client, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
			}
					
			iBestPlayer = iTempPlayer;
			if (iBestPlayer != -1)
			{
				g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestPlayer);
				if (g_flNPCTimeUntilAbandon[iBossIndex] < GetGameTime()) g_flNPCTimeUntilAbandon[iBossIndex] = GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty);
			}
		}

		delete hArray;

		if (!PeopleCanSeeSlender(iBossIndex, true, SlenderUsesBlink(iBossIndex)))
		{
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			if (IsTargetValidForSlender(iTarget) && GetGameTime() < g_flNPCTimeUntilAbandon[iBossIndex] && (GetGameTime() - g_flSlenderLastKill[iBossIndex]) >= NPCGetInstantKillCooldown(iBossIndex, difficulty))
			{
				bMove = true;
				float flSlenderPos[3], flPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPos);
				GetClientAbsOrigin(iTarget, flPos);
				if (NPCStatueGetTeleporter(iBossIndex, 0) != INVALID_ENT_REFERENCE)
				{
					int iTeleporter = EntRefToEntIndex(NPCStatueGetTeleporter(iBossIndex, 0));
					if (IsValidEntity(iTeleporter) && iTeleporter > MaxClients)
						GetEntPropVector(iTeleporter, Prop_Data, "m_vecAbsOrigin", flPos);
				}
				g_pPath[iBossIndex].ComputeToPos(bot, flPos, 9999999999.0);
					
				float flMaxRange = g_flSlenderTeleportMaxRange[iBossIndex][difficulty];
				float flDist = GetVectorSquareMagnitude(flSlenderPos, flPos);
					
				char sBuffer[PLATFORM_MAX_PATH];
					
				if (flDist < SquareFloat(flMaxRange * 0.33))
				{
					GetSlenderModel(iBossIndex, 2, sBuffer, sizeof(sBuffer));
				}
				else if (flDist < SquareFloat(flMaxRange * 0.66))
				{
					GetSlenderModel(iBossIndex, 1, sBuffer, sizeof(sBuffer));
				}
				else
				{
					GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));
				}
					
				// Fallback if error.
				if (sBuffer[0] == '\0') GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));

				SetEntityModel(slender, sBuffer);

				if (PlayerCanSeeSlender(iTarget, iBossIndex, false))
				{
					float flDistRatio = (flDist / SquareFloat(flMaxRange));

					float chaseDurationAdd = chaseDurationTimeAddMax - ((chaseDurationTimeAddMax - chaseDurationTimeAddMin) * flDistRatio);

					if (chaseDurationAdd > 0.0)
					{
						g_flNPCTimeUntilAbandon[iBossIndex] += chaseDurationAdd;
						if (g_flNPCTimeUntilAbandon[iBossIndex] > (GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty)))
						{
							g_flNPCTimeUntilAbandon[iBossIndex] = GetGameTime() + NPCStatueChaseDuration(iBossIndex, difficulty);
						}
					}
				}
					
				if (flDist <= SquareFloat(NPCGetInstantKillRadius(iBossIndex)))
				{
					if (NPCGetFlags(iBossIndex) & SFF_FAKE)
					{
						SlenderMarkAsFake(iBossIndex);
						return Plugin_Stop;
					}
					else
					{
						g_flSlenderLastKill[iBossIndex] = GetGameTime();
						ClientStartDeathCam(iTarget, iBossIndex, flPos);
						g_flLastStuckTime[iBossIndex] = GetGameTime() + NPCGetInstantKillCooldown(iBossIndex, difficulty) + 0.1;
						if (NPCGetInstantKillCooldown(iBossIndex, difficulty) > 0.0)
						{
							g_bNPCStatueMoving[iBossIndex] = false;
							loco.ClearStuckStatus();
						}
						g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
					}
				}
			}
			else
			{
				float vec3origin[3];
				SlenderGetAbsOrigin(iBossIndex, vec3origin);
				vec3origin[2] -= 10.0;
				g_flLastPos[iBossIndex] = vec3origin;
			}
		}
		
		if (bMove)
		{
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_move_single", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') EmitSoundToAll(sBuffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			
			GetRandomStringFromProfile(profile, "sound_move", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') EmitSoundToAll(sBuffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, SND_CHANGEVOL);
		}
		else
		{
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(profile, "sound_move", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') StopSound(slender, SNDCHAN_AUTO, sBuffer);
		}
		g_bNPCStatueMoving[iBossIndex] = bMove;
	}
	
	return Plugin_Continue;
}