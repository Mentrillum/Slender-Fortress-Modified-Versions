#if defined _sf2_npc_chaser_attacks_included
 #endinput
#endif

#define _sf2_npc_chaser_attacks_included

#pragma semicolon 1

void PerformSmiteBoss(int client, SF2_BasePlayer target, any entref)
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
	target.GetAbsOrigin(clientPos);
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
	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		damage *= 0.5;
	}

	bool attackEliminated = !!(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

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
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid || !player.IsAlive || player.IsInGhostMode)
		{
			continue;
		}

		if (!attackEliminated && player.IsEliminated)
		{
			continue;
		}

		float targetPos[3], vecClientPos[3];
		player.GetEyePosition(targetPos);
		player.GetAbsOrigin(vecClientPos);

		traceHandle = TR_TraceRayFilterEx(myEyePos,
			targetPos,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
			RayType_EndPoint,
			TraceRayDontHitAnyEntity,
			slender);

		bool traceDidHit = TR_DidHit(traceHandle);
		int traceHitEntity = TR_GetEntityIndex(traceHandle);
		delete traceHandle;

		if (traceDidHit && traceHitEntity != player.index)
		{
			float targetMins[3], targetMaxs[3];
			player.GetPropVector(Prop_Send, "m_vecMins", targetMins);
			player.GetPropVector(Prop_Send, "m_vecMaxs", targetMaxs);
			player.GetAbsOrigin(targetPos);
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

		if (!traceDidHit || traceHitEntity == player.index)
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
					player.TakeDamage(_, slender, slender, damage * 0.25, 3, _, direction, myEyePos);
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

	bool attackEliminated = !!(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

	float damage = NPCChaserGetAttackDamage(bossIndex, attackIndex, difficulty);
	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		damage *= 0.5;
	}
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
				SF2_BasePlayer player = SF2_BasePlayer(i);
				if (!player.IsValid || !player.IsAlive || player.IsInGhostMode)
				{
					continue;
				}

				if (!attackEliminated && player.IsEliminated)
				{
					continue;
				}

				float targetPos[3], vecClientPos[3], targetPosShockwave[3];
				player.GetEyePosition(targetPos);
				targetPosShockwave = targetPos;
				player.GetAbsOrigin(vecClientPos);

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

								if (traceDidHitShockwave && traceHitEntityShockwave != player.index)
								{
									float targetMins[3], targetMaxs[3];
									player.GetPropVector(Prop_Send, "m_vecMins", targetMins);
									player.GetPropVector(Prop_Send, "m_vecMaxs", targetMaxs);
									player.GetAbsOrigin(targetPosShockwave);
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

								if (!traceDidHitShockwave || traceHitEntityShockwave == player.index)
								{
									float targetDistShockwave = GetVectorSquareMagnitude(targetPos, myEyePos);

									if ((vecClientPos[2] <= myPos[2] + NPCChaserGetShockwaveHeight(bossIndex, difficulty)) && (targetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(bossIndex, difficulty))))
									{
										float percentLife;
										percentLife = player.FlashlightBatteryLife - NPCChaserGetShockwaveDrain(bossIndex, difficulty);
										if (percentLife < 0.0)
										{
											percentLife = 0.0;
										}
										player.FlashlightBatteryLife = percentLife;

										float directionForce[3];
										float newClientPosit[3];
										player.GetAbsOrigin(newClientPosit);
										newClientPosit[2] += 10.0;

										MakeVectorFromPoints(myPos, newClientPosit, directionForce);

										NormalizeVector(directionForce, directionForce);

										ScaleVector(directionForce, NPCChaserGetShockwaveForce(bossIndex, difficulty));

										if (directionForce[2] < 0.0)
										{
											directionForce[2] *= -1.0;
										}

										player.SetPropVector(Prop_Data, "m_vecBaseVelocity", directionForce);

										if (NPCChaserShockwaveStunEnabled(bossIndex))
										{
											player.Stun(NPCChaserGetShockwaveStunDuration(bossIndex, difficulty), NPCChaserGetShockwaveStunSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, player.index);
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

								if (traceDidHitShockwave && traceHitEntityShockwave != player.index)
								{
									float targetMins[3], targetMaxs[3];
									player.GetPropVector(Prop_Send, "m_vecMins", targetMins);
									player.GetPropVector(Prop_Send, "m_vecMaxs", targetMaxs);
									player.GetAbsOrigin(targetPosShockwave);
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

								if (!traceDidHitShockwave || traceHitEntityShockwave == player.index)
								{
									float targetDistShockwave = GetVectorSquareMagnitude(targetPos, myEyePos);

									if ((vecClientPos[2] <= myPos[2] + NPCChaserGetShockwaveHeight(bossIndex, difficulty)) && (targetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(bossIndex, difficulty))))
									{
										float percentLife;
										percentLife = player.FlashlightBatteryLife - NPCChaserGetShockwaveDrain(bossIndex, difficulty);
										if (percentLife < 0.0)
										{
											percentLife = 0.0;
										}
										player.FlashlightBatteryLife = percentLife;

										float directionForce[3];
										float newClientPosit[3];
										player.GetAbsOrigin(newClientPosit);
										newClientPosit[2] += 10.0;

										MakeVectorFromPoints(myPos, newClientPosit, directionForce);

										NormalizeVector(directionForce, directionForce);

										ScaleVector(directionForce, NPCChaserGetShockwaveForce(bossIndex, difficulty));

										if (directionForce[2] < 0.0)
										{
											directionForce[2] *= -1.0;
										}

										player.SetPropVector(Prop_Data, "m_vecBaseVelocity", directionForce);

										if (NPCChaserShockwaveStunEnabled(bossIndex))
										{
											player.Stun(NPCChaserGetShockwaveStunDuration(bossIndex, difficulty), NPCChaserGetShockwaveStunSlowdown(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, player.index);
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

				if (traceDidHit && traceHitEntity != player.index)
				{
					float targetMins[3], targetMaxs[3];
					player.GetPropVector(Prop_Send, "m_vecMins", targetMins);
					player.GetPropVector(Prop_Send, "m_vecMaxs", targetMaxs);
					player.GetAbsOrigin(targetPos);
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

				if (!traceDidHit || traceHitEntity == player.index)
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
										if (!player.InCondition(TFCond_Bleeding))
										{
											player.Bleed(true, _, 4.0);
										}
									}
									case 2:
									{
										player.Ignite(true);
									}
									case 3:
									{
										player.ChangeCondition(TFCond_Jarated, _, 4.0);
									}
									case 4:
									{
										player.ChangeCondition(TFCond_CritMmmph, _, 3.0);
									}
									case 5:
									{
										player.ChangeCondition(TFCond_Gas, _, 3.0);
									}
									case 6:
									{
										int effectRare = GetRandomInt(1, 30);
										switch (effectRare)
										{
											case 1, 14, 25, 30:
											{
												int newHealth = player.GetProp(Prop_Send, "m_iHealth")+view_as<int>(damage);
												if (newHealth > 450)
												{
													newHealth = 450;
												}
												player.ChangeCondition(TFCond_MegaHeal, _, 2.0);
												player.SetProp(Prop_Send, "m_iHealth", newHealth);
												damage = 0.0;
											}
											case 7, 27:
											{
												//It's over 9000!
												damage = 9001.0;
											}
											case 5, 16, 18, 22, 23, 26:
											{
												ScaleVector(direction, 1200.0);
											}
										}
									}
								}
							}

							if (player.InCondition(TFCond_UberchargedCanteen) && player.InCondition(TFCond_CritOnFirstBlood) && player.InCondition(TFCond_UberBulletResist) && player.InCondition(TFCond_UberBlastResist) && player.InCondition(TFCond_UberFireResist) && player.InCondition(TFCond_MegaHeal)) //Remove Powerplay
							{
								player.ChangeCondition(TFCond_UberchargedCanteen, true);
								player.ChangeCondition(TFCond_CritOnFirstBlood, true);
								player.ChangeCondition(TFCond_UberBulletResist, true);
								player.ChangeCondition(TFCond_UberBlastResist, true);
								player.ChangeCondition(TFCond_UberFireResist, true);
								player.ChangeCondition(TFCond_MegaHeal, true);
								TF2_SetPlayerPowerPlay(player.index, false);
							}
							Call_StartForward(g_OnClientDamagedByBossFwd);
							Call_PushCell(player.index);
							Call_PushCell(bossIndex);
							Call_PushCell(slender);
							Call_PushFloat(damage);
							Call_PushCell(damageType);
							Call_Finish();
							float checkHealth = float(player.GetProp(Prop_Send, "m_iHealth"));
							if ((NPCHasAttribute(bossIndex, SF2Attribute_DeathCamOnLowHealth) || NPCChaserGetAttackDeathCamOnLowHealth(bossIndex, attackIndex)))
							{
								float checkDamage = damage;

								if ((damageType & DMG_ACID) && !player.InCondition(TFCond_DefenseBuffed))
								{
									checkDamage *= 3;
								}
								else if (((damageType & DMG_POISON) || player.InCondition(TFCond_Jarated) || player.InCondition(TFCond_MarkedForDeath) || player.InCondition(TFCond_MarkedForDeathSilent)) && !player.InCondition(TFCond_DefenseBuffed))
								{
									checkDamage *= 1.35;
								}
								else if (player.InCondition(TFCond_DefenseBuffed))
								{
									checkDamage *= 0.65;
								}

								if (checkDamage > checkHealth)
								{
									player.StartDeathCam(bossIndex, myPos);
								}
							}
							if (NPCChaserGetAttackPullIn(bossIndex, attackIndex))
							{
								float newClientPos[3];
								player.GetAbsOrigin(newClientPos);
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

								player.Teleport(newClientPos, NULL_VECTOR, pullAngle);

								player.TakeDamage(_, slender, slender, damage, damageType|DMG_PREVENT_PHYSICS_FORCE, _, direction, myEyePos);
							}
							else
							{
								player.TakeDamage(_, slender, slender, damage, damageType, _, direction, myEyePos);
							}
							player.ViewPunch(viewPunch);

							if (player.InCondition(TFCond_Gas))
							{
								player.Ignite(true);
								player.ChangeCondition(TFCond_Gas, true);
							}
							if (player.InCondition(TFCond_Milked))
							{
								NPCChaserAddStunHealth(bossIndex, damage * 0.6);
								if (NPCGetHealthbarState(bossIndex))
								{
									UpdateHealthBar(bossIndex);
								}
							}
							float duration = NPCGetAttributeValue(bossIndex, SF2Attribute_BleedPlayerOnHit);
							if (duration > 0.0 && !player.InCondition(TFCond_Bleeding) && !NPCChaserBleedPlayerOnHit(bossIndex))
							{
								player.Bleed(true, _, duration);
							}
							if (NPCHasAttribute(bossIndex, SF2Attribute_IgnitePlayerOnHit))
							{
								player.Ignite(true);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_StunPlayerOnHit);
							if (duration > 0.0)
							{
								float slowdown = NPCGetAttributeValue(bossIndex, SF2Attribute_StunPlayerPercentage);
								if (slowdown > 0.0)
								{
									player.Stun(duration, slowdown, TF_STUNFLAGS_SMALLBONK, player.index);
								}
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_JaratePlayerOnHit);
							if (duration > 0.0 && !NPCChaserJaratePlayerOnHit(bossIndex))
							{
								player.ChangeCondition(TFCond_Jarated, _, duration);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_MilkPlayerOnHit);
							if (duration > 0.0 && !NPCChaserMilkPlayerOnHit(bossIndex))
							{
								player.ChangeCondition(TFCond_Milked, _, duration);
							}
							duration = NPCGetAttributeValue(bossIndex, SF2Attribute_GasPlayerOnHit);
							if (duration > 0.0 && !NPCChaserGasPlayerOnHit(bossIndex))
							{
								player.ChangeCondition(TFCond_Gas, _, duration);
							}

							if (NPCChaserUseAdvancedDamageEffects(bossIndex))
							{
								SlenderDoDamageEffects(bossIndex, attackIndex, player);
							}
							if (NPCChaserDamageParticlesEnabled(bossIndex))
							{
								GetChaserProfileDamageParticleName(profile, damageEffectParticle, sizeof(damageEffectParticle));
								if (damageEffectParticle[0] != '\0')
								{
									bool beamParticle = GetChaserProfileDamageParticleBeamState(profile);
									if (beamParticle)
									{
										SlenderCreateParticleBeamClient(bossIndex, damageEffectParticle, 35.0, player);
									}
									else
									{
										SlenderCreateParticleAttach(bossIndex, damageEffectParticle, 35.0, player);
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
										player.ChangeCondition(TFCond_TeleportedGlow, _, NPCChaserGetXenobladeBreakDuration(bossIndex), player.index);
									}
									case 131072:
									{
										if (player.InCondition(TFCond_TeleportedGlow))
										{
											player.Stun(NPCChaserGetXenobladeToppleDuration(bossIndex), NPCChaserGetXenobladeToppleSlowdown(bossIndex), TF_STUNFLAGS_LOSERSTATE, player.index);
											player.ChangeCondition(TFCond_TeleportedGlow, true);
											player.ChangeCondition(TFCond_MedigunDebuff, _, NPCChaserGetXenobladeToppleDuration(bossIndex), player.index);
										}
									}
									case 268435456:
									{
										if (player.InCondition(TFCond_MedigunDebuff))
										{
											player.Stun(NPCChaserGetXenobladeDazeDuration(bossIndex), 1.0, 10, player.index);
											player.ChangeCondition(TFCond_MedigunDebuff, true);
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
							ClientAddStress(player.index, 0.33 * stressScalar);

							hit = true;
						}
					}
				}
			}

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
					hitSounds.GetArray(hitSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundInfo.EmitSound(_, slender);
				}
			}
			else
			{
				ArrayList missSounds = GetChaserProfileMissSounds(profile);
				if (missSounds != null && missSounds.Length > 0)
				{
					SF2BossProfileSoundInfo soundInfo;
					missSounds.GetArray(missSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundInfo.EmitSound(_, slender);
				}
			}
		}
		case SF2BossAttackType_Ranged:
		{
			//BULLETS ANYONE? Thx Pelipoika
			SF2_BasePlayer target = SF2_BasePlayer(EntRefToEntIndex(g_SlenderTarget[bossIndex]));
			char particleName[PLATFORM_MAX_PATH];
			GetChaserProfileAttackBulletTrace(profile, attackIndex, particleName, sizeof(particleName));
			float vecSpread = NPCChaserGetAttackBulletSpread(bossIndex, attackIndex, difficulty);
			ArrayList bulletSounds = GetChaserProfileBulletShootSounds(profile);
			if (bulletSounds != null && bulletSounds.Length > 0)
			{
				SF2BossProfileSoundInfo soundInfo;
				bulletSounds.GetArray(bulletSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
				soundInfo.EmitSound(_, slender);
			}

			float effectPos[3], clientPos[3], basePos[3], baseAng[3];
			float effectAng[3] = {0.0, 0.0, 0.0};
			GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
			GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);
			if (target.IsValid)
			{
				target.GetEyePosition(clientPos);
				clientPos[2] -= 20.0;
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
			if (!target.IsValid)
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
						SlenderDoDamageEffects(bossIndex, attackIndex, SF2_BasePlayer(TR_GetEntityIndex(trace)));
					}
					SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackBulletDamage(bossIndex, attackIndex, difficulty), DMG_BULLET, _, CalculateBulletDamageForce(dir, 1.0), endPos);
				}

				delete trace;
			}
		}
		case SF2BossAttackType_Projectile:
		{
			SF2_BasePlayer target = SF2_BasePlayer(EntRefToEntIndex(g_SlenderTarget[bossIndex]));
			if (target.IsValid && target.IsAlive && !target.IsInGhostMode)
			{
				ArrayList projectileSounds = GetChaserProfileProjectileShootSounds(profile);
				if (projectileSounds != null && projectileSounds.Length > 0)
				{
					SF2BossProfileSoundInfo soundInfo;
					projectileSounds.GetArray(projectileSounds.Length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
					soundInfo.EmitSound(_, slender);
				}
				NPCChaserProjectileAttackShoot(bossIndex, slender, target.index, profile);
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

	bool attackEliminated = !!(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);

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
				SF2_BasePlayer player = SF2_BasePlayer(i);
				if (!player.IsValid || !player.IsAlive || player.IsInGhostMode)
				{
					continue;
				}

				if (!attackEliminated && player.IsEliminated)
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

	SF2_BasePlayer target = SF2_BasePlayer(EntRefToEntIndex(g_SlenderTarget[bossIndex]));
	if (target.IsValid && target.IsAlive && !target.IsInGhostMode)
	{
		float effectPos[3];
		float clientPos[3];

		target.GetEyePosition(clientPos);
		clientPos[2] -= 20.0;

		float basePos[3], baseAng[3];
		float effectAng[3] = {0.0, 0.0, 0.0};
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);
		GetChaserProfileAttackLaserOffset(profile, attackIndex, effectPos);
		VectorTransform(effectPos, basePos, baseAng, effectPos);
		AddVectors(effectAng, baseAng, effectAng);

		float shootDirection[3], shootAng[3];
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
				SlenderDoDamageEffects(bossIndex, attackIndex, SF2_BasePlayer(TR_GetEntityIndex(trace)));
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
