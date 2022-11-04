#if defined _sf2_npc_chaser_attacks_included
 #endinput
#endif

#define _sf2_npc_chaser_attacks_included

#pragma semicolon 1

void PerformSmiteBoss(int client, int target, any entref)
{
	if (!g_Enabled)
	{
		return;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	// define where the lightning strike ends
	float clientPos[3];
	GetClientAbsOrigin(target, clientPos);
	clientPos[2] -= 26; // increase y-axis by 26 to strike at player's chest instead of the ground

	// get random numbers for the x and y starting positions
	int randomX = GetRandomInt(-500, 500);
	int randomY = GetRandomInt(-500, 500);

	// define where the lightning strike starts
	float startPos[3];
	startPos[0] = clientPos[0] + randomX;
	startPos[1] = clientPos[1] + randomY;
	startPos[2] = clientPos[2] + 800;

	// define the color of the strike
	int color[4];
	color[0] = NPCChaserGetSmiteColorR(bossIndex);
	color[1] = NPCChaserGetSmiteColorG(bossIndex);
	color[2] = NPCChaserGetSmiteColorB(bossIndex);
	color[3] = NPCChaserGetSmiteColorTrans(bossIndex);
	if (color[0] < 0)
	{
		color[0] = 0;
	}
	if (color[1] < 0)
	{
		color[1] = 0;
	}
	if (color[2] < 0)
	{
		color[2] = 0;
	}
	if (color[3] < 0)
	{
		color[3] = 0;
	}
	if (color[0] > 255)
	{
		color[0] = 255;
	}
	if (color[1] > 255)
	{
		color[1] = 255;
	}
	if (color[2] > 255)
	{
		color[2] = 255;
	}
	if (color[3] > 255)
	{
		color[3] = 255;
	}

	// define the direction of the sparks
	float dir[3];

	TE_SetupBeamPoints(startPos, clientPos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
	TE_SendToAll();

	TE_SetupSparks(clientPos, dir, 5000, 1000);
	TE_SendToAll();

	TE_SetupEnergySplash(clientPos, dir, false);
	TE_SendToAll();

	TE_SetupSmoke(clientPos, g_SmokeSprite, 5.0, 10);
	TE_SendToAll();

	EmitAmbientSound(g_SlenderSmiteSound[bossIndex], startPos, client, SNDLEVEL_SCREAMING);

}

Action Timer_SlenderStealLife(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	if (!g_IsSlenderAttacking[bossIndex])
	{
		return Plugin_Stop;
	}

	if (timer != g_NpcLifeStealTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);
	float damage = NPCChaserGetAttackDamage(bossIndex, attackIndex, difficulty);

	bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	float targetDist;
	Handle traceHandle = null;

	float myPos[3], myEyePos[3], myEyeAng[3];
	NPCGetEyePosition(bossIndex, myEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", myEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	float attackRange = NPCChaserGetAttackRange(bossIndex, attackIndex);
	float attackFOV = NPCChaserGetAttackSpread(bossIndex, attackIndex);
	float attackDamageForce = NPCChaserGetAttackDamageForce(bossIndex, attackIndex);

	int i = -1;
	while ((i = FindEntityByClassname(i, "player")) != -1)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i))
		{
			continue;
		}

		if (!attackEliminated && g_PlayerEliminated[i])
		{
			continue;
		}

		float targetPos[3], vecClientPos[3];
		GetClientEyePosition(i, targetPos);
		GetClientAbsOrigin(i, vecClientPos);

		traceHandle = TR_TraceRayFilterEx(myEyePos,
			targetPos,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
			RayType_EndPoint,
			TraceRayDontHitAnyEntity,
			slender);

		bool traceDidHit = TR_DidHit(traceHandle);
		int traceHitEntity = TR_GetEntityIndex(traceHandle);
		delete traceHandle;

		if (traceDidHit && traceHitEntity != i)
		{
			float targetMins[3], targetMaxs[3];
			GetEntPropVector(i, Prop_Send, "m_vecMins", targetMins);
			GetEntPropVector(i, Prop_Send, "m_vecMaxs", targetMaxs);
			GetClientAbsOrigin(i, targetPos);
			for (int i2 = 0; i2 < 3; i2++)
			{
				targetPos[i2] += ((targetMins[i2] + targetMaxs[i2]) / 2.0);
			}

			traceHandle = TR_TraceRayFilterEx(myEyePos,
				targetPos,
				CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				slender);

			traceDidHit = TR_DidHit(traceHandle);
			traceHitEntity = TR_GetEntityIndex(traceHandle);
			delete traceHandle;
		}

		if (!traceDidHit || traceHitEntity == i)
		{
			targetDist = GetVectorSquareMagnitude(targetPos, myEyePos);

			if (targetDist <= SquareFloat(attackRange))
			{
				float direction[3];
				SubtractVectors(targetPos, myEyePos, direction);
				GetVectorAngles(direction, direction);

				if (FloatAbs(AngleDiff(direction[1], myEyeAng[1])) <= attackFOV)
				{
					GetAngleVectors(direction, direction, NULL_VECTOR, NULL_VECTOR);
					NormalizeVector(direction, direction);
					ScaleVector(direction, attackDamageForce);

					float healthRecover = damage * 2.0;
					NPCChaserAddStunHealth(bossIndex, healthRecover);

					if (NPCGetHealthbarState(bossIndex))
					{
						UpdateHealthBar(bossIndex);
					}
					SDKHooks_TakeDamage(i, slender, slender, damage * 0.25, 3, _, direction, myEyePos);
				}
			}
		}
	}
	delete traceHandle;

	return Plugin_Continue;
}

Action Timer_SlenderChaseBossAttack(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	if (timer != g_SlenderAttackTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
		return Plugin_Stop;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);

	bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	float damage = NPCChaserGetAttackDamage(bossIndex, attackIndex, difficulty);
	float tinyDamage = damage * 0.5;
	float damageVsProps = NPCChaserGetAttackDamageVsProps(bossIndex, attackIndex);
	int damageType = NPCChaserGetAttackDamageType(bossIndex, attackIndex);

	// Damage all players within range.
	float myPos[3], myEyePos[3], myEyeAng[3], vecMyRot[3];
	NPCGetEyePosition(bossIndex, myEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", myEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyRot);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	AddVectors(g_SlenderEyePosOffset[bossIndex], myEyeAng, myEyeAng);

	float viewPunch[3];
	GetChaserProfileAttackPunchVelocity(profile, attackIndex, viewPunch);

	float targetDist;
	Handle traceHandle = null;
	Handle traceShockwave = null;

	float attackRange = NPCChaserGetAttackRange(bossIndex, attackIndex);
	float attackFOV = NPCChaserGetAttackSpread(bossIndex, attackIndex);
	float attackDamageForce = NPCChaserGetAttackDamageForce(bossIndex, attackIndex);

	bool hit = false;

	if (g_SlenderState[bossIndex] == STATE_CHASE)
	{
		g_IsSlenderAttacking[bossIndex] = false;
		g_NpcStealingLife[bossIndex] = false;
		if (g_SlenderAttackTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderAttackTimer[bossIndex]);
		}
		if (g_NpcLifeStealTimer[bossIndex] != null)
		{
			KillTimer(g_NpcLifeStealTimer[bossIndex]);
		}
		if (g_SlenderBackupAtkTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
		}
		g_NpcAlreadyAttacked[bossIndex] = false;
		g_NpcUseFireAnimation[bossIndex] = false;
		if (g_SlenderLaserTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderLaserTimer[bossIndex]);
		}
		return Plugin_Stop;
	}
	if (g_LastStuckTime[bossIndex] != 0.0)
	{
		g_LastStuckTime[bossIndex] = GetGameTime();
	}
	loco.ClearStuckStatus();
	if (g_SlenderChaseInitialTimer[bossIndex] != null)
	{
		TriggerTimer(g_SlenderChaseInitialTimer[bossIndex]);
	}

	if (NPCChaserGetAttackRepeat(bossIndex, attackIndex) == 1)
	{
		g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
		if (g_SlenderBackupAtkTimer[bossIndex] == null && g_NpcAlreadyAttacked[bossIndex])
		{
			g_IsSlenderAttacking[bossIndex] = false;
			g_NpcStealingLife[bossIndex] = false;
			if (g_SlenderAttackTimer[bossIndex] != null)
			{
				KillTimer(g_SlenderAttackTimer[bossIndex]);
			}
			if (g_NpcLifeStealTimer[bossIndex] != null)
			{
				KillTimer(g_NpcLifeStealTimer[bossIndex]);
			}
			if (g_SlenderBackupAtkTimer[bossIndex] != null)
			{
				KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
			}
			g_NpcAlreadyAttacked[bossIndex] = false;
			g_NpcUseFireAnimation[bossIndex] = false;
			if (g_SlenderLaserTimer[bossIndex] != null)
			{
				KillTimer(g_SlenderLaserTimer[bossIndex]);
			}
			return Plugin_Stop;
		}
	}
	else if (NPCChaserGetAttackRepeat(bossIndex, attackIndex) == 2)
	{
		if (NpcGetCurrentAttackRepeat(bossIndex, attackIndex) < NPCChaserGetMaxAttackRepeats(bossIndex, attackIndex))
		{
			ArrayList repeatArray = GetChaserProfileAttackRepeatTimers(profile, attackIndex);
			float delay = repeatArray.Get(NpcGetCurrentAttackRepeat(bossIndex, attackIndex));
			g_SlenderAttackTimer[bossIndex] = CreateTimer(delay, Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
			NpcSetCurrentAttackRepeat(bossIndex, attackIndex, NpcGetCurrentAttackRepeat(bossIndex, attackIndex) + 1);
			if (g_SlenderBackupAtkTimer[bossIndex] == null && g_NpcAlreadyAttacked[bossIndex])
			{
				g_IsSlenderAttacking[bossIndex] = false;
				g_NpcStealingLife[bossIndex] = false;
				if (g_SlenderAttackTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderAttackTimer[bossIndex]);
				}
				if (g_NpcLifeStealTimer[bossIndex] != null)
				{
					KillTimer(g_NpcLifeStealTimer[bossIndex]);
				}
				if (g_SlenderBackupAtkTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
				}
				g_NpcAlreadyAttacked[bossIndex] = false;
				g_NpcUseFireAnimation[bossIndex] = false;
				if (g_SlenderLaserTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderLaserTimer[bossIndex]);
				}
				return Plugin_Stop;
			}
		}
	}
	switch (NPCChaserGetAttackType(bossIndex, attackIndex))
	{
		case SF2BossAttackType_Melee:
		{
			int prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
			{
				if (NPCAttackValidateTarget(bossIndex, prop, attackRange, attackFOV))
				{
					hit = true;
					SDKHooks_TakeDamage(prop, slender, slender, damageVsProps, damageType, _, _, myEyePos);
					float spreadVel = 1800.0;
					float vertVel = 1300.0;
					float vel[3];
					GetAngleVectors(myEyeAng, vel, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(vel,spreadVel);
					vel[2] = ((GetURandomFloat() + 0.1) * vertVel) * ((GetURandomFloat() + 0.1) * 2);
					TeleportEntity(prop, NULL_VECTOR, NULL_VECTOR, vel);
				}
			}

			prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_dynamic")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(bossIndex, prop, attackRange, attackFOV))
					{
						hit = true;
						SDKHooks_TakeDamage(prop, slender, slender, damageVsProps, damageType, _, _, myEyePos);
					}
				}
			}
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(bossIndex, prop, attackRange, attackFOV))
					{
						hit = true;
						SDKHooks_TakeDamage(prop, slender, slender, damageVsProps, damageType, _, _, myEyePos);
					}
				}
			}
			if (NPCChaserShockwaveOnAttack(bossIndex))
			{
				char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
				char currentIndex[2];
				int damageIndexes = NPCChaserGetShockwaveAttackIndexes(bossIndex);
				GetChaserProfileShockwaveAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
				FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
				FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex+1);

				int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
				if (count > 1)
				{
					for (int index = 0; index < count && index < NPCChaserGetAttackCount(bossIndex); index++)
					{
						int forIndex = StringToInt(allowedIndexesList[index]);
						if (forIndex == attackIndex + 1)
						{
							int beamColor[3], haloColor[3];
							int color1[4], color2[4];
							float myShockPos[3];

							GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myShockPos);
							myShockPos[2] += 10;

							GetChaserProfileShockwaveColor1(profile, beamColor);
							GetChaserProfileShockwaveColor2(profile, haloColor);

							color1[0] = beamColor[0];
							color1[1] = beamColor[1];
							color1[2] = beamColor[2];
							color1[3] = GetChaserProfileShockwaveAlpha1(profile);

							color2[0] = haloColor[0];
							color2[1] = haloColor[1];
							color2[2] = haloColor[2];
							color2[3] = GetChaserProfileShockwaveAlpha2(profile);

							int modelBeam, modelHalo;
							modelBeam = GetBossProfileShockwaveBeamModel(profile);
							modelHalo = GetBossProfileShockwaveHaloModel(profile);

							TE_SetupBeamRingPoint(myShockPos, 10.0, NPCChaserGetShockwaveRange(bossIndex,difficulty), modelBeam, modelHalo, 0, 30, 0.2, NPCChaserGetShockwaveWidth(bossIndex,1), NPCChaserGetShockwaveAmplitude(bossIndex), color2, 15, 0); //Inner
							TE_SendToAll();

							TE_SetupBeamRingPoint(myShockPos, 10.0, NPCChaserGetShockwaveRange(bossIndex,difficulty), modelBeam, modelHalo, 0, 30, 0.3, NPCChaserGetShockwaveWidth(bossIndex,0), NPCChaserGetShockwaveAmplitude(bossIndex), color1, 15, 0); //Outer
							TE_SendToAll();
						}
					}
				}
				else //Legacy support
				{
					char number = currentIndex[0];
					int attackNumber = 0;
					if (FindCharInString(indexes, number) != -1)
					{
						attackNumber += attackIndex+1;
					}
					if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
					{
						int currentAtkIndex = StringToInt(currentIndex);
						if (attackNumber == currentAtkIndex)
						{
							int beamColor[3], haloColor[3];
							int color1[4], color2[4];
							float myShockPos[3];

							GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myShockPos);
							myShockPos[2] += 10;

							GetChaserProfileShockwaveColor1(profile, beamColor);
							GetChaserProfileShockwaveColor2(profile, haloColor);

							color1[0] = beamColor[0];
							color1[1] = beamColor[1];
							color1[2] = beamColor[2];
							color1[3] = GetChaserProfileShockwaveAlpha1(profile);

							color2[0] = haloColor[0];
							color2[1] = haloColor[1];
							color2[2] = haloColor[2];
							color2[3] = GetChaserProfileShockwaveAlpha2(profile);

							int modelBeam, modelHalo;
							modelBeam = PrecacheModel(g_SlenderShockwaveBeamSprite[bossIndex], true);
							modelHalo = PrecacheModel(g_SlenderShockwaveHaloSprite[bossIndex], true);

							TE_SetupBeamRingPoint(myShockPos, 10.0, NPCChaserGetShockwaveRange(bossIndex,difficulty), modelBeam, modelHalo, 0, 30, 0.2, NPCChaserGetShockwaveWidth(bossIndex,1), NPCChaserGetShockwaveAmplitude(bossIndex), color2, 15, 0); //Inner
							TE_SendToAll();

							TE_SetupBeamRingPoint(myShockPos, 10.0, NPCChaserGetShockwaveRange(bossIndex,difficulty), modelBeam, modelHalo, 0, 30, 0.3, NPCChaserGetShockwaveWidth(bossIndex,0), NPCChaserGetShockwaveAmplitude(bossIndex), color1, 15, 0); //Outer
							TE_SendToAll();
						}
					}
				}
			}
			int i = -1;
			while ((i = FindEntityByClassname(i, "player")) != -1)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i))
				{
					continue;
				}

				if (!attackEliminated && g_PlayerEliminated[i])
				{
					continue;
				}

				float targetPos[3], vecClientPos[3], targetPosShockwave[3];
				GetClientEyePosition(i, targetPos);
				GetClientEyePosition(i, targetPosShockwave);
				GetClientAbsOrigin(i, vecClientPos);

				if (NPCChaserShockwaveOnAttack(bossIndex))
				{
					char indexes[8], allowedIndexes[88], allowedIndexesList[33][3];
					char currentIndex[2];
					int damageIndexes = NPCChaserGetShockwaveAttackIndexes(bossIndex);
					GetChaserProfileShockwaveAttackIndexesString(profile, allowedIndexes, sizeof(allowedIndexes));
					FormatEx(indexes, sizeof(indexes), "%d", damageIndexes);
					FormatEx(currentIndex, sizeof(currentIndex), "%d", attackIndex+1);

					int count = ExplodeString(allowedIndexes, " ", allowedIndexesList, 33, 3);
					if (count > 1)
					{
						for (int index = 0; index < count && index < NPCChaserGetAttackCount(bossIndex); index++)
						{
							int forIndex = StringToInt(allowedIndexesList[index]);
							if (forIndex == attackIndex + 1)
							{
								traceShockwave = TR_TraceRayFilterEx(myEyePos,
									targetPosShockwave,
									CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
									RayType_EndPoint,
									TraceRayDontHitCharactersOrEntity,
									slender);

								bool traceDidHitShockwave = TR_DidHit(traceShockwave);
								int traceHitEntityShockwave = TR_GetEntityIndex(traceShockwave);
								delete traceShockwave;

								if (traceDidHitShockwave && traceHitEntityShockwave != i)
								{
									float targetMins[3], targetMaxs[3];
									GetEntPropVector(i, Prop_Send, "m_vecMins", targetMins);
									GetEntPropVector(i, Prop_Send, "m_vecMaxs", targetMaxs);
									GetClientAbsOrigin(i, targetPosShockwave);
									for (int i2 = 0; i2 < 3; i2++)
									{
										targetPosShockwave[i2] += ((targetMins[i2] + targetMaxs[i2]) / 2.0);
									}

									traceShockwave = TR_TraceRayFilterEx(myEyePos,
										targetPosShockwave,
										CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
										RayType_EndPoint,
										TraceRayDontHitCharactersOrEntity,
										slender);

									traceDidHitShockwave = TR_DidHit(traceShockwave);
									traceHitEntityShockwave = TR_GetEntityIndex(traceShockwave);
									delete traceShockwave;
								}

								if (!traceDidHitShockwave || traceHitEntityShockwave == i)
								{
									float flTargetDistShockwave = GetVectorSquareMagnitude(targetPos, myEyePos);

									if ((vecClientPos[2] <= myPos[2] + NPCChaserGetShockwaveHeight(bossIndex, difficulty)) && (flTargetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(bossIndex, difficulty))))
									{
										float percentLife;
										percentLife = ClientGetFlashlightBatteryLife(i) - NPCChaserGetShockwaveDrain(bossIndex, difficulty);
										if (percentLife < 0.0) percentLife = 0.0;
										ClientSetFlashlightBatteryLife(i, percentLife);

										float directionForce[3];
										float newClientPosit[3];
										GetClientAbsOrigin(i, newClientPosit);
										newClientPosit[2] += 10.0;

										MakeVectorFromPoints(myPos, newClientPosit, directionForce);

										NormalizeVector(directionForce, directionForce);

										ScaleVector(directionForce, NPCChaserGetShockwaveForce(bossIndex, difficulty));

										if (directionForce[2] < 0.0)
										{
											directionForce[2] *= -1.0;
										}

										SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", directionForce);

										if (NPCChaserShockwaveStunEnabled(bossIndex))
										{
											TF2_StunPlayer(i, NPCChaserGetShockwaveStunDuration(bossIndex, difficulty), NPCChaserGetShockwaveStunSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, i);
										}
									}
								}
								break;
							}
						}
					}
					else //Legacy support
					{
						char number = currentIndex[0];
						int attackNumber = 0;
						if (FindCharInString(indexes, number) != -1)
						{
							attackNumber += attackIndex+1;
						}
						if (indexes[0] != '\0' && currentIndex[0] != '\0' && attackNumber != -1)
						{
							int currentAtkIndex = StringToInt(currentIndex);
							if (attackNumber == currentAtkIndex)
							{
								traceShockwave = TR_TraceRayFilterEx(myEyePos,
									targetPosShockwave,
									CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
									RayType_EndPoint,
									TraceRayDontHitCharactersOrEntity,
									slender);

								bool traceDidHitShockwave = TR_DidHit(traceShockwave);
								int traceHitEntityShockwave = TR_GetEntityIndex(traceShockwave);
								delete traceShockwave;

								if (traceDidHitShockwave && traceHitEntityShockwave != i)
								{
									float targetMins[3], targetMaxs[3];
									GetEntPropVector(i, Prop_Send, "m_vecMins", targetMins);
									GetEntPropVector(i, Prop_Send, "m_vecMaxs", targetMaxs);
									GetClientAbsOrigin(i, targetPosShockwave);
									for (int i2 = 0; i2 < 3; i2++)
									{
										targetPosShockwave[i2] += ((targetMins[i2] + targetMaxs[i2]) / 2.0);
									}

									traceShockwave = TR_TraceRayFilterEx(myEyePos,
										targetPosShockwave,
										CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
										RayType_EndPoint,
										TraceRayDontHitCharactersOrEntity,
										slender);

									traceDidHitShockwave = TR_DidHit(traceShockwave);
									traceHitEntityShockwave = TR_GetEntityIndex(traceShockwave);
									delete traceShockwave;
								}

								if (!traceDidHitShockwave || traceHitEntityShockwave == i)
								{
									float flTargetDistShockwave = GetVectorSquareMagnitude(targetPos, myEyePos);

									if ((vecClientPos[2] <= myPos[2] + NPCChaserGetShockwaveHeight(bossIndex, difficulty)) && (flTargetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(bossIndex, difficulty))))
									{
										float percentLife;
										percentLife = ClientGetFlashlightBatteryLife(i) - NPCChaserGetShockwaveDrain(bossIndex, difficulty);
										if (percentLife < 0.0)
										{
											percentLife = 0.0;
										}
										ClientSetFlashlightBatteryLife(i, percentLife);

										float directionForce[3];
										float newClientPosit[3];
										GetClientAbsOrigin(i, newClientPosit);
										newClientPosit[2] += 10.0;

										MakeVectorFromPoints(myPos, newClientPosit, directionForce);

										NormalizeVector(directionForce, directionForce);

										ScaleVector(directionForce, NPCChaserGetShockwaveForce(bossIndex, difficulty));

										if (directionForce[2] < 0.0)
										{
											directionForce[2] *= -1.0;
										}

										SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", directionForce);

										if (NPCChaserShockwaveStunEnabled(bossIndex))
										{
											TF2_StunPlayer(i, NPCChaserGetShockwaveStunDuration(bossIndex, difficulty), NPCChaserGetShockwaveStunSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, i);
										}
									}
								}
							}
						}
					}
				}

				traceHandle = TR_TraceRayFilterEx(myEyePos,
					targetPos,
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
					RayType_EndPoint,
					TraceRayDontHitAnyEntity,
					slender);

				bool traceDidHit = TR_DidHit(traceHandle);
				int traceHitEntity = TR_GetEntityIndex(traceHandle);
				delete traceHandle;

				if (traceDidHit && traceHitEntity != i)
				{
					float targetMins[3], targetMaxs[3];
					GetEntPropVector(i, Prop_Send, "m_vecMins", targetMins);
					GetEntPropVector(i, Prop_Send, "m_vecMaxs", targetMaxs);
					GetClientAbsOrigin(i, targetPos);
					for (int i2 = 0; i2 < 3; i2++)
					{
						targetPos[i2] += ((targetMins[i2] + targetMaxs[i2]) / 2.0);
					}

					traceHandle = TR_TraceRayFilterEx(myEyePos,
						targetPos,
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
						RayType_EndPoint,
						TraceRayDontHitAnyEntity,
						slender);

					traceDidHit = TR_DidHit(traceHandle);
					traceHitEntity = TR_GetEntityIndex(traceHandle);
					delete traceHandle;
				}

				if (!traceDidHit || traceHitEntity == i)
				{
					targetDist = GetVectorSquareMagnitude(targetPos, myEyePos);

					if (targetDist <= SquareFloat(attackRange))
					{
						float direction[3];
						SubtractVectors(targetPos, myEyePos, direction);
						GetVectorAngles(direction, direction);

						if (FloatAbs(AngleDiff(direction[1], myEyeAng[1])) <= attackFOV)
						{
							GetAngleVectors(direction, direction, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(direction, direction);
							ScaleVector(direction, attackDamageForce);

							if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_RenevantMultiEffect)
							{
								int effect = GetRandomInt(0, 6);
								switch (effect)
								{
									case 1:
									{
										if (!TF2_IsPlayerInCondition(i, TFCond_Bleeding)) TF2_MakeBleed(i, i, 4.0);
									}
									case 2:
									{
										TF2_IgnitePlayer(i, i);
									}
									case 3:
									{
										TF2_AddCondition(i, TFCond_Jarated, 4.0);
									}
									case 4:
									{
										TF2_AddCondition(i, TFCond_CritMmmph, 3.0);
									}
									case 5:
									{
										TF2_AddCondition(i, TFCond_Gas, 3.0);
									}
									case 6:
									{
										int effectRare = GetRandomInt(1, 30);
										switch (effectRare)
										{
											case 1,14,25,30:
											{
												int newHealth = GetEntProp(i, Prop_Send, "m_iHealth")+view_as<int>(damage);
												if (newHealth > 450)
												{
													newHealth = 450;
												}
												TF2_AddCondition(i, TFCond_MegaHeal, 2.0);
												SetEntProp(i, Prop_Send, "m_iHealth", newHealth);
												damage = 0.0;
											}
											case 7,27:
											{
												//It's over 9000!
												damage = 9001.0;
											}
											case 5,16,18,22,23,26:
											{
												ScaleVector(direction, 1200.0);
											}
										}
									}
								}
							}

							if (TF2_IsPlayerInCondition(i, TFCond_UberchargedCanteen) && TF2_IsPlayerInCondition(i, TFCond_CritOnFirstBlood) && TF2_IsPlayerInCondition(i, TFCond_UberBulletResist) && TF2_IsPlayerInCondition(i, TFCond_UberBlastResist) && TF2_IsPlayerInCondition(i, TFCond_UberFireResist) && TF2_IsPlayerInCondition(i, TFCond_MegaHeal)) //Remove Powerplay
							{
								TF2_RemoveCondition(i, TFCond_UberchargedCanteen);
								TF2_RemoveCondition(i, TFCond_CritOnFirstBlood);
								TF2_RemoveCondition(i, TFCond_UberBulletResist);
								TF2_RemoveCondition(i, TFCond_UberBlastResist);
								TF2_RemoveCondition(i, TFCond_UberFireResist);
								TF2_RemoveCondition(i, TFCond_MegaHeal);
								TF2_SetPlayerPowerPlay(i, false);
							}
							if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
							{
								Call_StartForward(g_OnClientDamagedByBossFwd);
								Call_PushCell(i);
								Call_PushCell(bossIndex);
								Call_PushCell(slender);
								Call_PushFloat(tinyDamage);
								Call_PushCell(damageType);
								Call_Finish();
								float checkHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (IsValidClient(i) && (NPCHasAttribute(bossIndex, SF2Attribute_DeathCamOnLowHealth) || NPCChaserGetAttackDeathCamOnLowHealth(bossIndex, attackIndex)) && GetClientTeam(i) != TFTeam_Blue)
								{
									float checkDamage = tinyDamage;

									if ((damageType == 1048576 || damageType == 1114112) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 3;
									}
									else if ((damageType == 1327104 || TF2_IsPlayerInCondition(i, TFCond_Jarated) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeath) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeathSilent)) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 1.35;
									}
									else if (TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 0.65;
									}

									if (checkDamage > checkHealth)
									{
										ClientStartDeathCam(i, bossIndex, myPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(bossIndex, attackIndex))
										{
											float newClientPos[3];
											GetClientAbsOrigin(i, newClientPos);
											newClientPos[2] += 10.0;

											float effectAng[3] = {0.0, 0.0, 0.0};

											VectorTransform(myEyePos, myPos, vecMyRot, myEyePos);
											AddVectors(effectAng, vecMyRot, effectAng);

											float pullDirection[3], pullAngle[3];
											SubtractVectors(newClientPos, myEyePos, pullDirection);
											NormalizeVector(pullDirection, pullDirection);
											GetVectorAngles(pullDirection, pullAngle);
											ScaleVector(pullAngle, 1200.0);
											pullAngle[2] = 10.0;

											TeleportEntity(i, newClientPos, NULL_VECTOR, pullAngle);

											SDKHooks_TakeDamage(i, slender, slender, tinyDamage, damageType, _, direction, myEyePos);
										}
										else
										{
											SDKHooks_TakeDamage(i, slender, slender, tinyDamage, damageType, _, direction, myEyePos);
										}
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(bossIndex, attackIndex))
									{
										float newClientPos[3];
										GetClientAbsOrigin(i, newClientPos);
										newClientPos[2] += 10.0;

										float effectAng[3] = {0.0, 0.0, 0.0};

										VectorTransform(myEyePos, myPos, vecMyRot, myEyePos);
										AddVectors(effectAng, vecMyRot, effectAng);

										float pullDirection[3], pullAngle[3];
										SubtractVectors(newClientPos, myEyePos, pullDirection);
										NormalizeVector(pullDirection, pullDirection);
										GetVectorAngles(pullDirection, pullAngle);
										ScaleVector(pullAngle, 1200.0);
										pullAngle[2] = 10.0;

										TeleportEntity(i, newClientPos, NULL_VECTOR, pullAngle);

										SDKHooks_TakeDamage(i, slender, slender, tinyDamage, damageType, _, direction, myEyePos);
									}
									else
									{
										SDKHooks_TakeDamage(i, slender, slender, tinyDamage, damageType, _, direction, myEyePos);
									}
								}
							}
							else
							{
								Call_StartForward(g_OnClientDamagedByBossFwd);
								Call_PushCell(i);
								Call_PushCell(bossIndex);
								Call_PushCell(slender);
								Call_PushFloat(damage);
								Call_PushCell(damageType);
								Call_Finish();
								float checkHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (IsValidClient(i) && (NPCHasAttribute(bossIndex, SF2Attribute_DeathCamOnLowHealth) || NPCChaserGetAttackDeathCamOnLowHealth(bossIndex, attackIndex)) && GetClientTeam(i) != TFTeam_Blue)
								{
									float checkDamage = damage;

									if ((damageType == 1048576 || damageType == 1114112) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 3;
									}
									else if ((damageType == 1327104 || TF2_IsPlayerInCondition(i, TFCond_Jarated) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeath) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeathSilent)) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 1.35;
									}
									else if (TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed))
									{
										checkDamage *= 0.65;
									}

									if (checkDamage > checkHealth)
									{
										ClientStartDeathCam(i, bossIndex, myPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(bossIndex, attackIndex))
										{
											float newClientPos[3];
											GetClientAbsOrigin(i, newClientPos);
											newClientPos[2] += 10.0;

											float effectAng[3] = {0.0, 0.0, 0.0};

											VectorTransform(myEyePos, myPos, vecMyRot, myEyePos);
											AddVectors(effectAng, vecMyRot, effectAng);

											float pullDirection[3], pullAngle[3];
											SubtractVectors(newClientPos, myEyePos, pullDirection);
											NormalizeVector(pullDirection, pullDirection);
											GetVectorAngles(pullDirection, pullAngle);
											ScaleVector(pullAngle, 1200.0);
											pullAngle[2] = 10.0;

											TeleportEntity(i, newClientPos, NULL_VECTOR, pullAngle);

											SDKHooks_TakeDamage(i, slender, slender, damage, damageType|DMG_PREVENT_PHYSICS_FORCE, _, direction, myEyePos);
										}
										else
										{
											SDKHooks_TakeDamage(i, slender, slender, damage, damageType, _, direction, myEyePos);
										}
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(bossIndex, attackIndex))
									{
										float newClientPos[3];
										GetClientAbsOrigin(i, newClientPos);
										newClientPos[2] += 10.0;

										float effectAng[3] = {0.0, 0.0, 0.0};

										VectorTransform(myEyePos, myPos, vecMyRot, myEyePos);
										AddVectors(effectAng, vecMyRot, effectAng);

										float pullDirection[3], pullAngle[3];
										SubtractVectors(newClientPos, myEyePos, pullDirection);
										NormalizeVector(pullDirection, pullDirection);
										GetVectorAngles(pullDirection, pullAngle);
										ScaleVector(pullAngle, 1200.0);
										pullAngle[2] = 10.0;
										pullAngle[1] -= pullAngle[1] * 2.0;
										pullAngle[0] -= pullAngle[0] * 2.0;

										TeleportEntity(i, newClientPos, NULL_VECTOR, pullAngle);

										SDKHooks_TakeDamage(i, slender, slender, damage, damageType|DMG_PREVENT_PHYSICS_FORCE, _, direction, myEyePos);
									}
									else
									{
										SDKHooks_TakeDamage(i, slender, slender, damage, damageType, _, direction, myEyePos);
									}
								}
							}
							ClientViewPunch(i, viewPunch);

							if (TF2_IsPlayerInCondition(i, TFCond_Gas))
							{
								TF2_IgnitePlayer(i, i);
								TF2_RemoveCondition(i, TFCond_Gas);
							}
							if (TF2_IsPlayerInCondition(i, TFCond_Milked))
							{
								NPCChaserAddStunHealth(bossIndex, damage * 0.6);
								if (NPCGetHealthbarState(bossIndex))
								{
									UpdateHealthBar(bossIndex);
								}
							}
							float duration = NPCGetAttributeValue(bossIndex, SF2Attribute_BleedPlayerOnHit);
							if (duration > 0.0 && !TF2_IsPlayerInCondition(i, TFCond_Bleeding) && !NPCChaserBleedPlayerOnHit(bossIndex))
							{
								TF2_MakeBleed(i, i, duration);
							}
							if (NPCHasAttribute(bossIndex, SF2Attribute_IgnitePlayerOnHit))
							{
								TF2_IgnitePlayer(i, i);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_StunPlayerOnHit);
							if (duration > 0.0)
							{
								float slowdown = NPCGetAttributeValue(bossIndex, SF2Attribute_StunPlayerPercentage);
								if (slowdown > 0.0)
								{
									TF2_StunPlayer(i, duration, slowdown, TF_STUNFLAGS_SMALLBONK, i);
								}
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_JaratePlayerOnHit);
							if (duration > 0.0 && !NPCChaserJaratePlayerOnHit(bossIndex))
							{
								TF2_AddCondition(i, TFCond_Jarated, duration);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_MilkPlayerOnHit);
							if (duration > 0.0 && !NPCChaserMilkPlayerOnHit(bossIndex))
							{
								TF2_AddCondition(i, TFCond_Milked, duration);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_GasPlayerOnHit);
							if (duration > 0.0 && !NPCChaserGasPlayerOnHit(bossIndex))
							{
								TF2_AddCondition(i, TFCond_Gas, duration);
							}

							if (NPCChaserUseAdvancedDamageEffects(bossIndex))
							{
								SlenderDoDamageEffects(bossIndex, attackIndex, i);
							}
							if (NPCChaserDamageParticlesEnabled(bossIndex))
							{
								GetChaserProfileDamageParticleName(profile, damageEffectParticle, sizeof(damageEffectParticle));
								if (damageEffectParticle[0] != '\0')
								{
									bool beamParticle = GetChaserProfileDamageParticleBeamState(profile);
									if (beamParticle)
									{
										SlenderCreateParticleBeamClient(bossIndex, damageEffectParticle, 35.0, i);
									}
									else
									{
										SlenderCreateParticleAttach(bossIndex, damageEffectParticle, 35.0, i);
									}
									GetChaserProfileDamageParticleSound(profile, damageEffectSound, sizeof(damageEffectSound));
									if (damageEffectSound[0] != '\0')
									{
										EmitSoundToAll(damageEffectSound, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
									}
								}
							}
							if (NPCChaserXenobladeSystemEnabled(bossIndex))
							{
								switch (damageType)
								{
									case 134217728:
									{
										TF2_AddCondition(i, TFCond_TeleportedGlow, NPCChaserGetXenobladeBreakDuration(bossIndex), i);
									}
									case 131072:
									{
										if (TF2_IsPlayerInCondition(i, TFCond_TeleportedGlow))
										{
											TF2_StunPlayer(i, NPCChaserGetXenobladeToppleDuration(bossIndex), NPCChaserGetXenobladeToppleSlowdown(bossIndex), TF_STUNFLAGS_LOSERSTATE, i);
											TF2_RemoveCondition(i, TFCond_TeleportedGlow);
											TF2_AddCondition(i, TFCond_MedigunDebuff, NPCChaserGetXenobladeToppleDuration(bossIndex), i);
										}
									}
									case 268435456:
									{
										if (TF2_IsPlayerInCondition(i, TFCond_MedigunDebuff))
										{
											TF2_StunPlayer(i, NPCChaserGetXenobladeDazeDuration(bossIndex), 1.0, 10, i);
											TF2_RemoveCondition(i, TFCond_MedigunDebuff);
										}
									}
								}
							}

							// Add stress
							float stressScalar = damage / 125.0;
							if (stressScalar > 1.0)
							{
								stressScalar = 1.0;
							}
							ClientAddStress(i, 0.33 * stressScalar);

							hit = true;
						}
					}
				}
			}
			char soundPath[PLATFORM_MAX_PATH];

			if (hit)
			{
				// Fling it.
				int phys = CreateEntityByName("env_physexplosion");
				if (phys != -1)
				{
					TeleportEntity(phys, myEyePos, NULL_VECTOR, NULL_VECTOR);
					DispatchKeyValue(phys, "spawnflags", "1");
					DispatchKeyValueFloat(phys, "radius", attackRange);
					DispatchKeyValueFloat(phys, "magnitude", attackDamageForce);
					DispatchSpawn(phys);
					ActivateEntity(phys);
					AcceptEntityInput(phys, "Explode");
					RemoveEntity(phys);
				}
				ArrayList hitSounds = GetChaserProfileHitSounds(profile);
				if (hitSounds != null && hitSounds.Length > 0)
				{
					SF2BossProfileSoundInfo soundInfo;
					ArrayList soundList;
					hitSounds.GetArray(hitSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), soundPath, sizeof(soundPath));
						if (soundPath[0] != '\0')
						{
							EmitSoundToAll(soundPath, slender, soundInfo.Channel, soundInfo.Level,
							soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
						}
					}
				}
			}
			else
			{
				ArrayList hitSounds = GetChaserProfileMissSounds(profile);
				if (hitSounds != null && hitSounds.Length > 0)
				{
					SF2BossProfileSoundInfo soundInfo;
					ArrayList soundList;
					hitSounds.GetArray(hitSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), soundPath, sizeof(soundPath));
						if (soundPath[0] != '\0')
						{
							EmitSoundToAll(soundPath, slender, soundInfo.Channel, soundInfo.Level,
							soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
						}
					}
				}
			}
		}
		case SF2BossAttackType_Ranged:
		{
			//BULLETS ANYONE? Thx Pelipoika
			int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
			char soundPath[PLATFORM_MAX_PATH], particleName[PLATFORM_MAX_PATH];
			GetChaserProfileAttackBulletTrace(profile, attackIndex, particleName, sizeof(particleName));
			float vecSpread = NPCChaserGetAttackBulletSpread(bossIndex, attackIndex, difficulty);
			ArrayList hitSounds = GetChaserProfileBulletShootSounds(profile);
			if (hitSounds != null && hitSounds.Length > 0)
			{
				SF2BossProfileSoundInfo soundInfo;
				ArrayList soundList;
				hitSounds.GetArray(hitSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), soundPath, sizeof(soundPath));
					if (soundPath[0] != '\0')
					{
						EmitSoundToAll(soundPath, slender, soundInfo.Channel, soundInfo.Level,
						soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
					}
				}
			}

			float effectPos[3], clientPos[3], basePos[3], baseAng[3];
			float effectAng[3] = {0.0, 0.0, 0.0};
			GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
			GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);
			if (IsValidEntity(target))
			{
				if (IsValidClient(target))
				{
					GetClientEyePosition(target, clientPos);
					clientPos[2] -= 20.0;
				}
				else
				{
					GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", clientPos);
					clientPos[2] += 25.0;
				}
			}
			else
			{
				clientPos[2] = 50.0;
				clientPos[0] = 10.0;
				VectorTransform(clientPos, basePos, baseAng, clientPos);
			}
			GetChaserProfileAttackBulletOffset(profile, attackIndex, effectPos);
			VectorTransform(effectPos, basePos, baseAng, effectPos);
			AddVectors(effectAng, baseAng, effectAng);

			float shootDirection[3], shootAng[3];
			if (!IsValidClient(target))
			{
				shootAng[0] = myEyeAng[0];
				shootAng[1] = myEyeAng[1];
				shootAng[2] = myEyeAng[2];
			}
			SubtractVectors(clientPos, effectPos, shootDirection);
			NormalizeVector(shootDirection, shootDirection);
			GetVectorAngles(shootDirection, shootAng);

			for (int i = 0; i < NPCChaserGetAttackBulletCount(bossIndex, attackIndex, difficulty); i++)
			{
				float x, y;
				x = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );
				y = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );

				float dirShooting[3], vecRight[3], vecUp[3];
				GetAngleVectors(shootAng, dirShooting, vecRight, vecUp);

				float dir[3];
				dir[0] = dirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0];
				dir[1] = dirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1];
				dir[2] = dirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2];
				NormalizeVector(dir, dir);

				float end[3];
				end[0] = effectPos[0] + dir[0] * 9001.0;
				end[1] = effectPos[1] + dir[1] * 9001.0;
				end[2] = effectPos[2] + dir[2] * 9001.0;

				// Fire a bullet (ignoring the shooter).
				Handle trace = TR_TraceRayFilterEx(effectPos, end, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
				RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
				if (TR_GetFraction(trace) < 1.0)
				{
					// Verify we have an entity at the point of impact.
					if (TR_GetEntityIndex(trace) == -1)
					{
						delete trace;
						return Plugin_Stop;
					}

					float endPos[3];
					TR_GetEndPosition(endPos, trace);

					if (TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
					{
						float normal[3];
						TR_GetPlaneNormal(trace, normal);
						GetVectorAngles(normal, normal);
						//CreateParticle("impact_concrete", endPos, normal);
					}

					// Regular impact effects.
					char effect[PLATFORM_MAX_PATH];
					FormatEx(effect, PLATFORM_MAX_PATH, "%s", particleName);

					if (particleName[0] != '\0')
					{
						int tblidx = FindStringTable("ParticleEffectNames");
						if (tblidx == INVALID_STRING_TABLE)
						{
							LogError("Could not find string table: ParticleEffectNames");
							return Plugin_Stop;
						}
						char tmp[256];
						int count = GetStringTableNumStrings(tblidx);
						int stridx = INVALID_STRING_INDEX;
						for (int i2 = 0; i2 < count; i2++)
						{
							ReadStringTable(tblidx, i2, tmp, sizeof(tmp));
							if (strcmp(tmp, effect, false) == 0)
							{
								stridx = i2;
								break;
							}
						}
						if (stridx == INVALID_STRING_INDEX)
						{
							LogError("Could not find particle: %s", effect);
							return Plugin_Stop;
						}

						TE_Start("TFParticleEffect");
						TE_WriteFloat("m_vecOrigin[0]", effectPos[0]);
						TE_WriteFloat("m_vecOrigin[1]", effectPos[1]);
						TE_WriteFloat("m_vecOrigin[2]", effectPos[2]);
						TE_WriteNum("m_iParticleSystemIndex", stridx);
						TE_WriteNum("entindex", slender);
						TE_WriteNum("m_iAttachType", 2);
						TE_WriteNum("m_iAttachmentPointIndex", 0);
						TE_WriteNum("m_bResetParticles", false);
						TE_WriteNum("m_bControlPoint1", 1);
						TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 5);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endPos[0]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endPos[1]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endPos[2]);
						TE_SendToAll();
					}

				//	TE_SetupBeamPoints(effectPos, endPos, g_iPathLaserModelIndex, g_iPathLaserModelIndex, 0, 30, 0.1, 0.1, 0.1, 5, 0.0, view_as<int>({255, 0, 255, 255}), 30);
				//	TE_SendToAll();
					if (NPCChaserUseAdvancedDamageEffects(bossIndex))
					{
						SlenderDoDamageEffects(bossIndex, attackIndex, TR_GetEntityIndex(trace));
					}
					SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackBulletDamage(bossIndex, attackIndex, difficulty), DMG_BULLET, _, CalculateBulletDamageForce(dir, 1.0), endPos);
				}

				delete trace;
			}
		}
		case SF2BossAttackType_Projectile:
		{
			int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
			if (IsValidClient(target) && IsClientInGame(target) && IsPlayerAlive(target) && !IsClientInGhostMode(target))
			{
				ArrayList hitSounds = GetChaserProfileProjectileShootSounds(profile);
				if (hitSounds != null && hitSounds.Length > 0)
				{
					SF2BossProfileSoundInfo soundInfo;
					ArrayList soundList;
					hitSounds.GetArray(hitSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						char soundPath[PLATFORM_MAX_PATH];
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), soundPath, sizeof(soundPath));
						if (soundPath[0] != '\0')
						{
							EmitSoundToAll(soundPath, slender, soundInfo.Channel, soundInfo.Level,
							soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
						}
					}
				}
				NPCChaserProjectileAttackShoot(bossIndex, slender, target, profile);
				if (GetChaserProfileShootAnimationsState(profile))
				{
					g_NpcUseFireAnimation[bossIndex] = true;
					int state = g_SlenderState[bossIndex];
					NPCChaserUpdateBossAnimation(bossIndex, slender, state);
				}
			}
			else //Our target is unavailable, abort.
			{
				g_IsSlenderAttacking[bossIndex] = false;
				g_NpcStealingLife[bossIndex] = false;
				if (g_SlenderAttackTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderAttackTimer[bossIndex]);
				}
				if (g_NpcLifeStealTimer[bossIndex] != null)
				{
					KillTimer(g_NpcLifeStealTimer[bossIndex]);
				}
				if (g_SlenderBackupAtkTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
				}
				g_NpcAlreadyAttacked[bossIndex] = false;
				g_NpcUseFireAnimation[bossIndex] = false;
				if (g_SlenderLaserTimer[bossIndex] != null)
				{
					KillTimer(g_SlenderLaserTimer[bossIndex]);
				}
				return Plugin_Stop;
			}
		}
	}
	Call_StartForward(g_OnBossAttackedFwd);
	Call_PushCell(bossIndex);
	Call_PushCell(attackIndex);
	Call_Finish();
	if (NPCChaserGetAttackDisappear(bossIndex, attackIndex) != 1 && NPCChaserGetAttackRepeat(bossIndex, attackIndex) < 1)
	{
		g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDuration(bossIndex, attackIndex)-NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
	}
	if (NPCChaserGetAttackRepeat(bossIndex, attackIndex) >= 1 && !g_NpcAlreadyAttacked[bossIndex])
	{
		g_SlenderBackupAtkTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDuration(bossIndex, attackIndex)-NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttackEndBackup, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
		g_NpcAlreadyAttacked[bossIndex] = true;
	}
	if (NPCChaserGetAttackDisappear(bossIndex, attackIndex) == 1)
	{
		g_IsSlenderAttacking[bossIndex] = false;
		g_NpcStealingLife[bossIndex] = false;
		if (g_SlenderAttackTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderAttackTimer[bossIndex]);
		}
		if (g_NpcLifeStealTimer[bossIndex] != null)
		{
			KillTimer(g_NpcLifeStealTimer[bossIndex]);
		}
		if (g_SlenderBackupAtkTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderBackupAtkTimer[bossIndex]);
		}
		g_NpcAlreadyAttacked[bossIndex] = false;
		g_NpcUseFireAnimation[bossIndex] = false;
		if (g_SlenderLaserTimer[bossIndex] != null)
		{
			KillTimer(g_SlenderLaserTimer[bossIndex]);
		}
		RemoveSlender(bossIndex);
		return Plugin_Stop;
	}
	delete traceHandle;
	delete traceShockwave;
	return Plugin_Stop;
}

static float[] CalculateBulletDamageForce(const float bulletDir[3], float scale)
{
	float force[3]; force = bulletDir;
	NormalizeVector(force, force);
	ScaleVector(force, g_PhysicsPushScaleConVar.FloatValue);
	ScaleVector(force, scale);
	return force;
}

Action Timer_SlenderChaseBossAttackIgniteHit(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerIgniteTimer[player])
	{
		return Plugin_Stop;
	}

	TF2_IgnitePlayer(player, player, g_PlayerIgniteDurationEffect[player]);
	g_PlayerIgniteTimer[player] = null;
	return Plugin_Stop;
}

Action Timer_SlenderPrepareExplosiveDance(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	CreateTimer(0.13, Timer_SlenderChaseBossExplosiveDance, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

static Action Timer_SlenderChaseBossExplosiveDance(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	static int exploded = 0;

	if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
		exploded=0;
		return Plugin_Stop;
	}

	// Damage all players within range.
	float myPos[3], myEyePos[3], myEyeAng[3];
	NPCGetEyePosition(bossIndex, myEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", myEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);

	int range = NPCChaserGetAttackExplosiveDanceRadius(bossIndex, attackIndex);

	AddVectors(g_SlenderEyePosOffset[bossIndex], myEyeAng, myEyeAng);

	bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	if (!g_IsSlenderAttacking[bossIndex])
	{
		exploded=0;
		return Plugin_Stop;
	}

	exploded++;
	if (exploded <= 35)
	{
		float slenderPosition[3], explosionPosition[3];
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", slenderPosition);
		explosionPosition[2] = slenderPosition[2] + 50.0;
		for (int e = 0; e < 5; e++)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i))
				{
					continue;
				}

				if (!attackEliminated && g_PlayerEliminated[i])
				{
					continue;
				}

				int explosivePower = CreateEntityByName("env_explosion");
				if (explosivePower != -1)
				{
					DispatchKeyValueFloat(explosivePower, "DamageForce", 180.0);

					SetEntProp(explosivePower, Prop_Data, "m_iMagnitude", 666, 4);
					SetEntProp(explosivePower, Prop_Data, "m_iRadiusOverride", 200, 4);
					SetEntPropEnt(explosivePower, Prop_Data, "m_hOwnerEntity", slender);
					explosionPosition[0]=slenderPosition[0]+float(GetRandomInt(-range, range));
					explosionPosition[1]=slenderPosition[1]+float(GetRandomInt(-range, range));
					TeleportEntity(explosivePower, explosionPosition, NULL_VECTOR, NULL_VECTOR);
					DispatchSpawn(explosivePower);

					AcceptEntityInput(explosivePower, "Explode");
					RemoveEntity(explosivePower);
					CreateTimer(0.1, Timer_KillEntity, EntIndexToEntRef(explosivePower), TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
	else
	{
		g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDuration(bossIndex, attackIndex)-NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender));
		exploded = 0;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

Action Timer_SlenderChaseBossAttackBeginLaser(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	if (timer != g_SlenderAttackTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);

	g_NpcLaserTimer[bossIndex] = GetGameTime() + NPCChaserGetAttackLaserDuration(bossIndex, attackIndex);

	g_SlenderLaserTimer[bossIndex] = CreateTimer(0.1, Timer_SlenderChaseBossAttackLaser, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	g_SlenderAttackTimer[bossIndex] = CreateTimer(NPCChaserGetAttackDuration(bossIndex, attackIndex)-NPCChaserGetAttackDamageDelay(bossIndex, attackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);

	NPCChaserSetNextAttackTime(bossIndex, attackIndex, GetGameTime()+NPCChaserGetAttackCooldown(bossIndex, attackIndex, difficulty));

	return Plugin_Stop;
}

static Action Timer_SlenderChaseBossAttackLaser(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	if (timer != g_SlenderLaserTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (GetGameTime() >= g_NpcLaserTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	if (NPCGetFlags(bossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(bossIndex);
		return Plugin_Stop;
	}

	CBaseCombatCharacter animationEntity = CBaseCombatCharacter(slender);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	if (!g_IsSlenderAttacking[bossIndex])
	{
		return Plugin_Stop;
	}

	int target = EntRefToEntIndex(g_SlenderTarget[bossIndex]);
	if (IsValidClient(target) && IsClientInGame(target) && IsPlayerAlive(target) && !IsClientInGhostMode(target))
	{
		float effectPos[3];
		float clientPos[3];

		GetClientEyePosition(target, clientPos);
		clientPos[2] -= 20.0;

		float basePos[3], baseAng[3];
		float effectAng[3] = {0.0, 0.0, 0.0};
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);
		GetChaserProfileAttackLaserOffset(profile, attackIndex, effectPos);
		VectorTransform(effectPos, basePos, baseAng, effectPos);
		AddVectors(effectAng, baseAng, effectAng);

		float shootDirection[3], shootAng[3];
		if (!IsValidClient(target))
		{
			shootAng[0] = baseAng[0];
			shootAng[1] = baseAng[1];
			shootAng[2] = baseAng[2];
		}
		SubtractVectors(clientPos, effectPos, shootDirection);
		NormalizeVector(shootDirection, shootDirection);
		GetVectorAngles(shootDirection, shootAng);

		float dirShooting[3];
		GetAngleVectors(shootAng, dirShooting, NULL_VECTOR, NULL_VECTOR);

		float dir[3];
		dir[0] = dirShooting[0];
		dir[1] = dirShooting[1];
		dir[2] = dirShooting[2];
		NormalizeVector(dir, dir);

		float end[3];
		end[0] = effectPos[0] + dir[0] * 9001.0;
		end[1] = effectPos[1] + dir[1] * 9001.0;
		end[2] = effectPos[2] + dir[2] * 9001.0;

		Handle trace = TR_TraceRayFilterEx(effectPos, end, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
		RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
		if (TR_GetFraction(trace) < 1.0)
		{
			// Verify we have an entity at the point of impact.
			if (TR_GetEntityIndex(trace) == -1)
			{
				delete trace;
				return Plugin_Stop;
			}

			float endPos[3];
			TR_GetEndPosition(endPos, trace);

			if (TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
			{
				float normal[3];	TR_GetPlaneNormal(trace, normal);
				GetVectorAngles(normal, normal);
			}

			int color[3];
			NPCChaserGetAttackLaserColor(bossIndex, attackIndex, color);
			int colorReal[4];
			colorReal[0] = color[0];
			colorReal[1] = color[1];
			colorReal[2] = color[2];
			colorReal[3] = 255;

			if (NPCChaserGetAttackLaserAttachmentState(bossIndex, attackIndex))
			{
				char attachment[PLATFORM_MAX_PATH];
				GetChaserProfileAttackLaserAttachmentName(profile, attackIndex, attachment, sizeof(attachment));
				int attachmentIndex = animationEntity.LookupAttachment(attachment);
				float targetEntPos[3], tempAng[3];
				animationEntity.GetAttachment(attachmentIndex, targetEntPos, tempAng);
				TE_SetupBeamPoints(targetEntPos, endPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(bossIndex, attackIndex), NPCChaserGetAttackLaserSize(bossIndex, attackIndex), 5, NPCChaserGetAttackLaserNoise(bossIndex, attackIndex), colorReal, 1);
				TE_SendToAll();
			}
			else
			{
				TE_SetupBeamPoints(effectPos, endPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(bossIndex, attackIndex), NPCChaserGetAttackLaserSize(bossIndex, attackIndex), 5, NPCChaserGetAttackLaserNoise(bossIndex, attackIndex), colorReal, 1);
				TE_SendToAll();
			}
			if (NPCChaserUseAdvancedDamageEffects(bossIndex))
			{
				SlenderDoDamageEffects(bossIndex, attackIndex, TR_GetEntityIndex(trace));
			}
			SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackLaserDamage(bossIndex, attackIndex, difficulty), DMG_SHOCK|DMG_ALWAYSGIB, _, _, endPos);
		}

		delete trace;

	}
	return Plugin_Continue;
}

bool NPCAttackValidateTarget(int bossIndex,int target, float attackRange, float attackFOV, bool checkBlock = false)
{
	int bossEntity = NPCGetEntIndex(bossIndex);

	float myEyePos[3], myEyeAng[3];
	NPCGetEyePosition(bossIndex, myEyePos);
	if (target > MaxClients)
	{
		//float flVecMaxs[3];
		myEyePos[2]+=30.0;
	}
	GetEntPropVector(bossEntity, Prop_Data, "m_angAbsRotation", myEyeAng);
	AddVectors(g_SlenderEyeAngOffset[bossIndex], myEyeAng, myEyeAng);

	float targetPos[3], targetMins[3], targetMaxs[3];
	GetEntPropVector(target, Prop_Data, "m_vecAbsOrigin", targetPos);
	GetEntPropVector(target, Prop_Send, "m_vecMins", targetMins);
	GetEntPropVector(target, Prop_Send, "m_vecMaxs", targetMaxs);

	for (int i = 0; i < 3; i++)
	{
		targetPos[i] += (targetMins[i] + targetMaxs[i]) / 2.0;
	}

	float targetDist = GetVectorSquareMagnitude(targetPos, myEyePos);
	if (targetDist <= SquareFloat(attackRange))
	{
		float direction[3];
		SubtractVectors(g_SlenderGoalPos[bossIndex], myEyePos, direction);
		GetVectorAngles(direction, direction);

		if (FloatAbs(AngleDiff(direction[1], myEyeAng[1])) <= attackFOV / 2.0)
		{
			Handle traceHandle = TR_TraceRayFilterEx(myEyePos,
				targetPos,
				CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				bossEntity);

			bool traceDidHit = TR_DidHit(traceHandle);
			int traceHitEntity = TR_GetEntityIndex(traceHandle);
			delete traceHandle;

			if (!traceDidHit || traceHitEntity == target)
			{
				if (checkBlock)
				{
					float pos[3], posForward[3];
					GetEntPropVector(bossEntity, Prop_Data, "m_vecAbsOrigin", pos);
					GetPositionForward(pos, myEyeAng, posForward, SquareRoot(targetDist+SquareFloat(50.0)));
					if (NPCGetRaidHitbox(bossIndex) == 1)
					{
						traceHandle = TR_TraceHullFilterEx(pos,
						posForward,
						g_SlenderDetectMins[bossIndex],
						g_SlenderDetectMaxs[bossIndex],
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
						TraceRayBossVisibility,
						bossEntity);
					}
					else if (NPCGetRaidHitbox(bossIndex) == 0)
					{
						traceHandle = TR_TraceHullFilterEx(pos,
						posForward,
						HULL_HUMAN_MINS,
						HULL_HUMAN_MAXS,
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
						TraceRayBossVisibility,
						bossEntity);
					}
					traceHitEntity = TR_GetEntityIndex(traceHandle);
					delete traceHandle;

					if (traceHitEntity == target)
					{
						return true;
					}
				}
				else
				{
					return true;
				}
			}
			delete traceHandle;
		}
	}

	return false;
}

static Action Timer_SlenderChaseBossAttackEnd(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	if (timer != g_SlenderAttackTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	loco.ClearStuckStatus();

	g_IsSlenderAttacking[bossIndex] = false;
	g_NpcStealingLife[bossIndex] = false;
	g_SlenderAttackTimer[bossIndex] = null;
	g_NpcLifeStealTimer[bossIndex] = null;
	g_SlenderBackupAtkTimer[bossIndex] = null;
	g_NpcAlreadyAttacked[bossIndex] = false;
	g_NpcUseFireAnimation[bossIndex] = false;
	g_SlenderLaserTimer[bossIndex] = null;
	CBaseNPC_RemoveAllLayers(slender);
	return Plugin_Stop;
}

static Action Timer_SlenderChaseBossAttackEndBackup(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

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

	if (timer != g_SlenderBackupAtkTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	loco.ClearStuckStatus();

	g_IsSlenderAttacking[bossIndex] = false;
	g_NpcStealingLife[bossIndex] = false;
	g_SlenderAttackTimer[bossIndex] = null;
	g_NpcLifeStealTimer[bossIndex] = null;
	g_SlenderBackupAtkTimer[bossIndex] = null;
	g_NpcAlreadyAttacked[bossIndex] = false;
	g_NpcUseFireAnimation[bossIndex] = false;
	g_SlenderLaserTimer[bossIndex] = null;
	CBaseNPC_RemoveAllLayers(slender);
	return Plugin_Stop;
}
