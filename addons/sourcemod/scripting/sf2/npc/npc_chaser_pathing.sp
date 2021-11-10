#if defined _sf2_npc_chaser_pathing_included
 #endinput
#endif
#define _sf2_npc_chaser_pathing_included

public void SlenderChaseBossProcessMovement(int iBoss)
{
	if (!g_bEnabled) return;
	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);
		return;
	}

	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	float flMyPos[3], flMyEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	
	SDKCall(g_hSDKStudioFrameAdvance, iBoss);
	
	int iState = g_iSlenderState[iBossIndex];
	int iOldState = g_iSlenderOldState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);

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
		
		if (NPCHasAttribute(iBossIndex, "always look at target"))
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
							TR_TraceRayFilter(vecMyEyePos, vecTargetPos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharacters, iBoss);
							bCanSeeTarget = !TR_DidHit();
						}
					}

					if (bCanSeeTarget)
					{
						bCanSeeTarget = NPCShouldSeeEntity(iBossIndex, iTarget);
					}
					
					if (NPCHasAttribute(iBossIndex, "always look at target while chasing") || bCanSeeTarget)
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
					if (!g_ILocomotion[iBossIndex].IsOnGround() || g_ILocomotion[iBossIndex].IsClimbingOrJumping())
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
					if (NPCHasAttribute(iBossIndex, "always look at target while attacking") && !NPCChaserGetAttackIgnoreAlwaysLooking(iBossIndex, iAttackIndex) && ((NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) != SF2BossAttackType_LaserBeam)))
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
	
	if (bChangeAngle) g_ILocomotion[iBossIndex].FaceTowards(vecPosToAt);
	
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
					g_ILocomotion[iBossIndex].Run();
				}
			}
			case STATE_ALERT:
			{
				bPFUpdate = true;
				g_ILocomotion[iBossIndex].Run();
			}
			case STATE_CHASE:
			{
				bPFUpdate = true;
				g_ILocomotion[iBossIndex].Run();
			}
			case STATE_ATTACK:
			{
				if (NPCChaserGetAttackWhileRunningState(iBossIndex, iAttackIndex))
				{
					bPFUpdate = true;
					g_ILocomotion[iBossIndex].Run();
				}
			}
		}
		if (bPFUpdate)
		{
			g_hBossChaserPathLogic[iBossIndex].Update(g_INextBot[iBossIndex], !bChangeAngle, TraceRayDontHitAnyEntity);
		}
		else
			g_ILocomotion[iBossIndex].Stop();
		if (iState != iOldState)
		{
			g_INextBot[iBossIndex].Update();
		}
	}

	if (!g_ILocomotion[iBossIndex].IsOnGround() && !g_ILocomotion[iBossIndex].IsClimbingOrJumping() && !g_bSlenderSpawning[iBossIndex])
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
		hullcheckmins[0] -= 10.0;
		hullcheckmins[1] -= 10.0;
		
		hullcheckmaxs[0] += 10.0;
		hullcheckmaxs[1] += 10.0;
		
		hullcheckmins[2] += g_ILocomotion[iBossIndex].GetStepHeight();
		hullcheckmaxs[2] -= g_ILocomotion[iBossIndex].GetStepHeight();
		
		if (!g_bNPCVelocityCancel[iBossIndex] && IsSpaceOccupiedIgnorePlayers(flMyPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
		{
			float vec3Origin[3];
			g_ILocomotion[iBossIndex].SetVelocity(vec3Origin);
			g_bNPCVelocityCancel[iBossIndex] = true;
		}
	}
	else
		g_bNPCVelocityCancel[iBossIndex] = false;

	if (NPCChaserCanCrawl(iBossIndex) && !g_bSlenderSpawning[iBossIndex] && 
	iState != STATE_ATTACK && iState != STATE_STUN && iState != STATE_IDLE && g_ILocomotion[iBossIndex].IsOnGround() && !g_ILocomotion[iBossIndex].IsClimbingOrJumping())
	{
		float flCrawlDetectMins[3], flCrawlDetectMaxs[3];
		flCrawlDetectMins = g_flNPCCrawlDetectMins[iBossIndex];
		flCrawlDetectMaxs = g_flNPCCrawlDetectMaxs[iBossIndex];

		if (IsSpaceOccupiedIgnorePlayers(flMyPos, flCrawlDetectMins, flCrawlDetectMaxs, iBoss) && !g_bNPCIsCrawling[iBossIndex])
		{
			NPCChaserUpdateBossAnimation(iBossIndex, iBoss, g_iSlenderState[iBossIndex]);
			g_bNPCIsCrawling[iBossIndex] = true;
			g_bNPCChangeToCrawl[iBossIndex] = true;
		}
		if (!IsSpaceOccupiedIgnorePlayers(flMyPos, flCrawlDetectMins, flCrawlDetectMaxs, iBoss) && g_bNPCIsCrawling[iBossIndex])
		{
			NPCChaserUpdateBossAnimation(iBossIndex, iBoss, g_iSlenderState[iBossIndex]);
			g_bNPCIsCrawling[iBossIndex] = false;
			g_bNPCChangeToCrawl[iBossIndex] = true;
		}
	}
	
	if (iState != STATE_IDLE && iState != STATE_STUN && iState != STATE_ATTACK && !g_bSlenderSpawning[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex])
	{
		bool bRunUnstuck = (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (bRunUnstuck)
		{
			if (GetVectorSquareMagnitude(flMyPos, g_flLastPos[iBossIndex]) < 0.1 || g_ILocomotion[iBossIndex].IsStuck())
			{
				bool bBlockingProp = false;
				
				if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
				{
					for (int iAttackIndex2 = 0; iAttackIndex2 < NPCChaserGetAttackCount(iBossIndex); iAttackIndex2++)
					{
						if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Projectile || NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_LaserBeam) continue;
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex2), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex2));
						if (bBlockingProp) break;
					}
				}
				
				if (!bBlockingProp)
				{
					if (g_flLastStuckTime[iBossIndex] == 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					
					if (g_flLastStuckTime[iBossIndex] <= GetGameTime()-1.0 && !g_bNPCRunningToHeal[iBossIndex] && !g_bNPCHealing[iBossIndex])
					{
						bool bPathResolved = false;
						float vecMovePos[3];
						g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
						
						if (SlenderChaseBoss_OnStuckResolvePath(iBoss, flMyPos, flMyEyeAng, vecMovePos, vecMovePos))
						{
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
								}
							}
						}
						if (!bPathResolved)
						{
							g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
							if (NPCGetRaidHitbox(iBossIndex) == 1)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
									else
									{
										CNavArea area = NavMesh_GetNearestArea(flMyPos, _, 10000.0);
										if (area == INVALID_NAV_AREA)
										{
											area = g_hBossChaserPathLogic[iBossIndex].GetMovePositionNavArea();
										}
										if (area != INVALID_NAV_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
											}
											else
											{
												vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
												if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hRespawnPoint in SlenderChaseBossProcessMovement during Boxing.", hRespawnPoint);
												#endif
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hRespawnPoint in SlenderChaseBossProcessMovement during Boxing.", hRespawnPoint);
												#endif
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_bRestartSessionEnabled)
											{
												ArrayList hSpawnPoint = new ArrayList();
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hSpawnPoint in SlenderChaseBossProcessMovement during Restart Session.", hSpawnPoint);
												#endif
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hSpawnPoint in SlenderChaseBossProcessMovement during Restart Session.", hSpawnPoint);
												#endif

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
												}
												else RemoveSlender(iBossIndex);
											}
										}
									}
								}
							}
							else if (NPCGetRaidHitbox(iBossIndex) == 0)
							{
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = false;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
									if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
									{
										bPathResolved = true;
										TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
									}
									else
									{
										CNavArea area = NavMesh_GetNearestArea(flMyPos, _, 10000.0);
										if (area == INVALID_NAV_AREA)
										{
											area = g_hBossChaserPathLogic[iBossIndex].GetMovePositionNavArea();
										}
										if (area != INVALID_NAV_AREA)
										{
											area.GetCenter(vecMovePos);
											if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
											{
												bPathResolved = false;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
											}
											else
											{
												vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
												if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
												{
													bPathResolved = true;
													TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hRespawnPoint in SlenderChaseBossProcessMovement during Boxing.", hRespawnPoint);
												#endif
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hRespawnPoint in SlenderChaseBossProcessMovement during Boxing.", hRespawnPoint);
												#endif
												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
												}
												else
												{
													RemoveSlender(iBossIndex);
												}
											}
											else if (!SF_IsBoxingMap() && g_bRestartSessionEnabled)
											{
												ArrayList hSpawnPoint = new ArrayList();
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hSpawnPoint in SlenderChaseBossProcessMovement during Restart Session.", hSpawnPoint);
												#endif
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
												#if defined DEBUG
												SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hSpawnPoint in SlenderChaseBossProcessMovement during Restart Session.", hSpawnPoint);
												#endif

												if (IsValidEntity(ent))
												{
													GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
													TeleportEntity(iBoss, flTeleportPos, NULL_VECTOR, NULL_VECTOR);
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
							g_flLastStuckTime[iBossIndex] = 0.0;
						}
					}
				}
			}
			else
			{
				g_flLastStuckTime[iBossIndex] = 0.0;
				g_flLastPos[iBossIndex] = flMyPos;
			}
		}
	}
	
	Address pStudioHdr = CBaseAnimating_GetModelPtr(iBoss);
	if (pStudioHdr != Address_Null)
	{
		int m_iMoveX = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_x");
		int m_iMoveY = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_y");
		
		float flGroundSpeed = g_ILocomotion[iBossIndex].GetGroundSpeed();
		if ( flGroundSpeed != 0.0 )
		{
			float vecForward[3], vecRight[3], vecUp[3], vecMotion[3];
			SDK_GetVectors(iBoss, vecForward, vecRight, vecUp);
			g_ILocomotion[iBossIndex].GetGroundMotionVector(vecMotion);
			
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, GetVectorDotProduct(vecMotion,vecForward));
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, GetVectorDotProduct(vecMotion,vecRight));
		}
		else
		{
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, 0.0);
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, 0.0);
		}
		
		if (m_iMoveX < 0 && m_iMoveY < 0) return;
		
		if (iState == STATE_CHASE || iState == STATE_ALERT || iState == STATE_WANDER)
		{
			float m_flGroundSpeed = GetEntPropFloat(iBoss, Prop_Data, "m_flGroundSpeed");
			if(m_flGroundSpeed != 0.0 && g_ILocomotion[iBossIndex].IsOnGround())
			{
				float flReturnValue = flGroundSpeed / m_flGroundSpeed;
				if (flReturnValue < -4.0) flReturnValue = -4.0;
				if (flReturnValue > 12.0) flReturnValue = 12.0;
				
				SetEntPropFloat(iBoss, Prop_Send, "m_flPlaybackRate", flReturnValue);
			}
		}
	}
	
	return;
}

//Note: This functions is really expensive you better call this function only if you really need it!
bool SlenderChaseBoss_OnStuckResolvePath(int slender, float flMyPos[3], float flMyAng[3], float flGoalPosition[3], float flReturn[3])
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
				TR_TraceRayFilter(flMyPos, flFreePos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);

				if(!TR_DidHit())
				{
					// Perform an other line of sight check to avoid moving in a area that can't reach the original goal!
					TR_TraceRayFilter(flFreePos, flGoalPosition, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
					if(!TR_DidHit())
					{
						TR_TraceHullFilter(flMyPos, flFreePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, MASK_NPCSOLID, TraceRayDontHitAnyEntity, slender);
					
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

// Shortest-path cost function for NavMesh_BuildPath.
public int SlenderChaseBossShortestPathCost(CNavArea area, CNavArea fromArea, CNavLadder ladder, any pBotLocomotion)
{
	if (fromArea == INVALID_NAV_AREA || area == INVALID_NAV_AREA)
	{
		return 0;
	}
	else
	{
		NextBotGroundLocomotion botLocomotion = view_as<NextBotGroundLocomotion>(pBotLocomotion);
		int iDist;
		float flAreaCenter[3], flFromAreaCenter[3];
		area.GetCenter(flAreaCenter);
		fromArea.GetCenter(flFromAreaCenter);
		
		if (ladder != INVALID_NAV_LADDER)
		{
			iDist = RoundFloat(ladder.Length);
		}
		else
		{
			iDist = RoundFloat(GetVectorSquareMagnitude(flAreaCenter, flFromAreaCenter));
		}
		
		int iCost = (iDist + SquareInt(fromArea.CostSoFar));
		
		if (area.Attributes & NAV_MESH_CROUCH) iCost += SquareInt(20);
		if (area.Attributes & NAV_MESH_JUMP) iCost += SquareInt(5 * iDist);
		
		if ((flAreaCenter[2] - flFromAreaCenter[2]) > botLocomotion.GetStepHeight()) iCost += SquareInt(RoundToFloor(botLocomotion.GetStepHeight()));

		float multiplier = 1.0;

		int seed = RoundToFloor(GetGameTime() * 0.1) + 1;
		
		INextBot bot = view_as<INextBot>(botLocomotion.GetBot());
		seed *= area.ID;
		seed *= bot.GetEntity();
		multiplier += (Cosine(float(seed)) + 1.0) * 50.0;

		iCost += iDist * RoundFloat(multiplier);
		
		int iReturn = iCost;

		if (iReturn > 2)
		{
			iReturn = 2;
		}

		return iReturn;
	}
}
