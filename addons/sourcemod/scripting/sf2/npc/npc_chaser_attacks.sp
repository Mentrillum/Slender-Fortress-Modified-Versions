#if defined _sf2_npc_chaser_attacks_included
 #endinput
#endif

#define _sf2_npc_chaser_attacks_included

public void PerformSmiteBoss(int client, int target, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	// define where the lightning strike ends
	float clientpos[3];
	GetClientAbsOrigin(target, clientpos);
	clientpos[2] -= 26; // increase y-axis by 26 to strike at player's chest instead of the ground
	
	// get random numbers for the x and y starting positions
	int randomx = GetRandomInt(-500, 500);
	int randomy = GetRandomInt(-500, 500);
	
	// define where the lightning strike starts
	float startpos[3];
	startpos[0] = clientpos[0] + randomx;
	startpos[1] = clientpos[1] + randomy;
	startpos[2] = clientpos[2] + 800;
	
	// define the color of the strike
	int color[4];
	color[0] = NPCChaserGetSmiteColorR(iBossIndex);
	color[1] = NPCChaserGetSmiteColorG(iBossIndex);
	color[2] = NPCChaserGetSmiteColorB(iBossIndex);
	color[3] = NPCChaserGetSmiteColorTrans(iBossIndex);
	if (color[0] < 0) color[0] = 0;
	if (color[1] < 0) color[1] = 0;
	if (color[2] < 0) color[2] = 0;
	if (color[3] < 0) color[3] = 0;
	if (color[0] > 255) color[0] = 255;
	if (color[1] > 255) color[1] = 255;
	if (color[2] > 255) color[2] = 255;
	if (color[3] > 255) color[3] = 255;
	
	// define the direction of the sparks
	float dir[3];
	
	TE_SetupBeamPoints(startpos, clientpos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
	TE_SendToAll();
	
	TE_SetupSparks(clientpos, dir, 5000, 1000);
	TE_SendToAll();
	
	TE_SetupEnergySplash(clientpos, dir, false);
	TE_SendToAll();
	
	TE_SetupSmoke(clientpos, g_SmokeSprite, 5.0, 10);
	TE_SendToAll();
	
	EmitAmbientSound(SOUND_THUNDER, startpos, client, 90);

}

public Action Timer_SlenderStealLife(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;

	if (!g_bSlenderAttacking[iBossIndex]) return Plugin_Stop;
	
	if (timer != g_hNPCLifeStealTimer[iBossIndex]) return Plugin_Stop;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	float flDamage = NPCChaserGetAttackDamage(iBossIndex, iAttackIndex, iDifficulty);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);

	float flTargetDist;
	Handle hTrace = null;
	
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);

	float flAttackRange = NPCChaserGetAttackRange(iBossIndex, iAttackIndex);
	float flAttackFOV = NPCChaserGetAttackSpread(iBossIndex, iAttackIndex);
	float flAttackDamageForce = NPCChaserGetAttackDamageForce(iBossIndex, iAttackIndex);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;

		if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;

		float flTargetPos[3], vecClientPos[3];
		GetClientEyePosition(i, flTargetPos);
		GetClientAbsOrigin(i, vecClientPos);

		hTrace = TR_TraceRayFilterEx(flMyEyePos,
			flTargetPos,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
			RayType_EndPoint,
			TraceRayDontHitAnyEntity,
			slender);
				
		bool bTraceDidHit = TR_DidHit(hTrace);
		int iTraceHitEntity = TR_GetEntityIndex(hTrace);
		delete hTrace;
				
		if (bTraceDidHit && iTraceHitEntity != i)
		{
			float flTargetMins[3], flTargetMaxs[3];
			GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
			GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
			GetClientAbsOrigin(i, flTargetPos);
			for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);

			hTrace = TR_TraceRayFilterEx(flMyEyePos,
				flTargetPos,
				CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				slender);
						
			bTraceDidHit = TR_DidHit(hTrace);
			iTraceHitEntity = TR_GetEntityIndex(hTrace);
			delete hTrace;
		}
				
		if (!bTraceDidHit || iTraceHitEntity == i)
		{
			flTargetDist = GetVectorSquareMagnitude(flTargetPos, flMyEyePos);

			if (flTargetDist <= SquareFloat(flAttackRange))
			{
				float flDirection[3];
				SubtractVectors(flTargetPos, flMyEyePos, flDirection);
				GetVectorAngles(flDirection, flDirection);
						
				if (FloatAbs(AngleDiff(flDirection[1], vecMyEyeAng[1])) <= flAttackFOV)
				{
					GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
					NormalizeVector(flDirection, flDirection);
					ScaleVector(flDirection, flAttackDamageForce);
					
					float flHealthRecover = flDamage * 2.0;
					NPCChaserAddStunHealth(iBossIndex, flHealthRecover);
					
					if (NPCGetHealthbarState(iBossIndex))
					{
						UpdateHealthBar(iBossIndex);
					}
					SDKHooks_TakeDamage(i, slender, slender, flDamage * 0.25, 3, _, flDirection, flMyEyePos);
				}
			}
		}
	}
	delete hTrace;

	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossAttack(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return Plugin_Stop;
	}

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	
	float flDamage = NPCChaserGetAttackDamage(iBossIndex, iAttackIndex, iDifficulty);
	float flTinyDamage = flDamage * 0.5;
	float flDamageVsProps = NPCChaserGetAttackDamageVsProps(iBossIndex, iAttackIndex);
	int iDamageType = NPCChaserGetAttackDamageType(iBossIndex, iAttackIndex);
	
	// Damage all players within range.
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3], vecMyRot[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyRot);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);
	
	AddVectors(g_flSlenderEyePosOffset[iBossIndex], vecMyEyeAng, vecMyEyeAng);

	float flViewPunch[3];
	GetProfileAttackVector(sProfile, "attack_punchvel", flViewPunch, _, iAttackIndex+1);
	
	float flTargetDist;
	Handle hTrace = null;
	Handle hTraceShockwave = null;
	
	float flAttackRange = NPCChaserGetAttackRange(iBossIndex, iAttackIndex);
	float flAttackFOV = NPCChaserGetAttackSpread(iBossIndex, iAttackIndex);
	float flAttackDamageForce = NPCChaserGetAttackDamageForce(iBossIndex, iAttackIndex);
	
	bool bHit = false;

	if (g_iSlenderState[iBossIndex] == STATE_CHASE)
	{
		g_bSlenderAttacking[iBossIndex] = false;
		g_bNPCStealingLife[iBossIndex] = false;
		if (g_hSlenderAttackTimer[iBossIndex] != null) KillTimer(g_hSlenderAttackTimer[iBossIndex]);
		if (g_hNPCLifeStealTimer[iBossIndex] != null) KillTimer(g_hNPCLifeStealTimer[iBossIndex]);
		if (g_hSlenderBackupAtkTimer[iBossIndex] != null) KillTimer(g_hSlenderBackupAtkTimer[iBossIndex]);
		g_bNPCAlreadyAttacked[iBossIndex] = false;
		g_bNPCUseFireAnimation[iBossIndex] = false;
		if (g_hSlenderLaserTimer[iBossIndex] != null) KillTimer(g_hSlenderLaserTimer[iBossIndex]);
		return Plugin_Stop;
	}
	if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
	loco.ClearStuckStatus();
	if (g_hSlenderChaseInitialTimer[iBossIndex] != null) TriggerTimer(g_hSlenderChaseInitialTimer[iBossIndex]);

	if (NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) == 1)
	{
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
		if (g_hSlenderBackupAtkTimer[iBossIndex] == null && g_bNPCAlreadyAttacked[iBossIndex])
		{
			g_bSlenderAttacking[iBossIndex] = false;
			g_bNPCStealingLife[iBossIndex] = false;
			if (g_hSlenderAttackTimer[iBossIndex] != null) KillTimer(g_hSlenderAttackTimer[iBossIndex]);
			if (g_hNPCLifeStealTimer[iBossIndex] != null) KillTimer(g_hNPCLifeStealTimer[iBossIndex]);
			if (g_hSlenderBackupAtkTimer[iBossIndex] != null) KillTimer(g_hSlenderBackupAtkTimer[iBossIndex]);
			g_bNPCAlreadyAttacked[iBossIndex] = false;
			g_bNPCUseFireAnimation[iBossIndex] = false;
			if (g_hSlenderLaserTimer[iBossIndex] != null) KillTimer(g_hSlenderLaserTimer[iBossIndex]);
			return Plugin_Stop;
		}
	}
	else if (NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) == 2)
	{
		if (NPCGetCurrentAttackRepeat(iBossIndex, iAttackIndex) < NPCChaserGetMaxAttackRepeats(iBossIndex, iAttackIndex))
		{
			char sAttackBuffer[512];
			FormatEx(sAttackBuffer, sizeof(sAttackBuffer), "attack_repeat_%i_delay", NPCGetCurrentAttackRepeat(iBossIndex, iAttackIndex) + 1);
			float flDelay = GetProfileAttackFloat(sProfile, sAttackBuffer, 0.0, iAttackIndex+1);
			g_hSlenderAttackTimer[iBossIndex] = CreateTimer(flDelay, Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
			NPCSetCurrentAttackRepeat(iBossIndex, iAttackIndex, NPCGetCurrentAttackRepeat(iBossIndex, iAttackIndex) + 1);
			if (g_hSlenderBackupAtkTimer[iBossIndex] == null && g_bNPCAlreadyAttacked[iBossIndex])
			{
				g_bSlenderAttacking[iBossIndex] = false;
				g_bNPCStealingLife[iBossIndex] = false;
				if (g_hSlenderAttackTimer[iBossIndex] != null) KillTimer(g_hSlenderAttackTimer[iBossIndex]);
				if (g_hNPCLifeStealTimer[iBossIndex] != null) KillTimer(g_hNPCLifeStealTimer[iBossIndex]);
				if (g_hSlenderBackupAtkTimer[iBossIndex] != null) KillTimer(g_hSlenderBackupAtkTimer[iBossIndex]);
				g_bNPCAlreadyAttacked[iBossIndex] = false;
				g_bNPCUseFireAnimation[iBossIndex] = false;
				if (g_hSlenderLaserTimer[iBossIndex] != null) KillTimer(g_hSlenderLaserTimer[iBossIndex]);
				return Plugin_Stop;
			}
		}
	}
	switch (NPCChaserGetAttackType(iBossIndex, iAttackIndex))
	{
		case SF2BossAttackType_Melee:
		{
			int prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
			{
				if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
				{
					bHit = true;
					SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					float SpreadVel = 1800.0;
					float VertVel = 1300.0;
					float vel[3];
					GetAngleVectors(vecMyEyeAng, vel, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(vel,SpreadVel);
					vel[2] = ((GetURandomFloat() + 0.1) * VertVel) * ((GetURandomFloat() + 0.1) * 2);
					TeleportEntity(prop, NULL_VECTOR, NULL_VECTOR, vel);
				}
			}
			
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_dynamic")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			if (NPCChaserShockwaveOnAttack(iBossIndex))
			{
				char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
				char sCurrentIndex[2];
				int iDamageIndexes = NPCChaserGetShockwaveAttackIndexes(iBossIndex);
				GetProfileString(sProfile, "shockwave_attack_index", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
				FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
				FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex+1);

				int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
				if (iCount > 1)
				{
					for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
					{
						int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
						if (iForIndex == iAttackIndex + 1)
						{
							float flBeamColor[3], flHaloColor[3];
							int iColor1[4], iColor2[4];
							float flDefaultColorBeam[3] = {128.0, 128.0, 128.0};
							float flDefaultColorHalo[3] = {255.0, 255.0, 255.0};
							float vecMyShockPos[3];
							
							GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyShockPos);
							vecMyShockPos[2] += 10;

							GetProfileVector(sProfile, "shockwave_color_1", flBeamColor, flDefaultColorBeam);
							GetProfileVector(sProfile, "shockwave_color_2", flHaloColor, flDefaultColorHalo);

							iColor1[0] = RoundToNearest(flBeamColor[0]);
							iColor1[1] = RoundToNearest(flBeamColor[1]);
							iColor1[2] = RoundToNearest(flBeamColor[2]);
							iColor1[3] = GetProfileNum(sProfile, "shockwave_alpha_1", 255);
		
							iColor2[0] = RoundToNearest(flHaloColor[0]);
							iColor2[1] = RoundToNearest(flHaloColor[1]);
							iColor2[2] = RoundToNearest(flHaloColor[2]);
							iColor2[3] = GetProfileNum(sProfile, "shockwave_alpha_2", 255);
							int iModelBeam, iModelHalo;
							iModelBeam = PrecacheModel(g_sSlenderShockwaveBeamSprite[iBossIndex], true);
							iModelHalo = PrecacheModel(g_sSlenderShockwaveHaloSprite[iBossIndex], true);
				
							TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.2, 20.0, 5.0, iColor2, 15, 0); //Inner
							TE_SendToAll();

							TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.3, 40.0, 5.0, iColor1, 15, 0); //Outer
							TE_SendToAll();
						}
					}
				}
				else //Legacy support
				{
					char sNumber = sCurrentIndex[0];
					int iAttackNumber = 0;
					if (FindCharInString(sIndexes, sNumber) != -1)
					{
						iAttackNumber += iAttackIndex+1;
					}
					if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
					{
						int iCurrentAtkIndex = StringToInt(sCurrentIndex);
						if (iAttackNumber == iCurrentAtkIndex)
						{
							float flBeamColor[3], flHaloColor[3];
							int iColor1[4], iColor2[4];
							float flDefaultColorBeam[3] = {128.0, 128.0, 128.0};
							float flDefaultColorHalo[3] = {255.0, 255.0, 255.0};
							float vecMyShockPos[3];
							
							GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyShockPos);
							vecMyShockPos[2] += 10;

							GetProfileVector(sProfile, "shockwave_color_1", flBeamColor, flDefaultColorBeam);
							GetProfileVector(sProfile, "shockwave_color_2", flHaloColor, flDefaultColorHalo);

							iColor1[0] = RoundToNearest(flBeamColor[0]);
							iColor1[1] = RoundToNearest(flBeamColor[1]);
							iColor1[2] = RoundToNearest(flBeamColor[2]);
							iColor1[3] = GetProfileNum(sProfile, "shockwave_alpha_1", 255);
		
							iColor2[0] = RoundToNearest(flHaloColor[0]);
							iColor2[1] = RoundToNearest(flHaloColor[1]);
							iColor2[2] = RoundToNearest(flHaloColor[2]);
							iColor2[3] = GetProfileNum(sProfile, "shockwave_alpha_2", 255);
							int iModelBeam, iModelHalo;
							iModelBeam = PrecacheModel(g_sSlenderShockwaveBeamSprite[iBossIndex], true);
							iModelHalo = PrecacheModel(g_sSlenderShockwaveHaloSprite[iBossIndex], true);
				
							TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.2, 20.0, 5.0, iColor2, 15, 0); //Inner
							TE_SendToAll();

							TE_SetupBeamRingPoint(vecMyShockPos, 10.0, NPCChaserGetShockwaveRange(iBossIndex,iDifficulty), iModelBeam, iModelHalo, 0, 30, 0.3, 40.0, 5.0, iColor1, 15, 0); //Outer
							TE_SendToAll();
						}
					}
				}
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;
				
				if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;
				
				float flTargetPos[3], vecClientPos[3], flTargetPosShockwave[3];
				GetClientEyePosition(i, flTargetPos);
				GetClientEyePosition(i, flTargetPosShockwave);
				GetClientAbsOrigin(i, vecClientPos);

				if (NPCChaserShockwaveOnAttack(iBossIndex))
				{
					char sIndexes[8], sAllowedIndexes[88], sAllowedIndexesList[33][3];
					char sCurrentIndex[2];
					int iDamageIndexes = NPCChaserGetShockwaveAttackIndexes(iBossIndex);
					GetProfileString(sProfile, "shockwave_attack_index", sAllowedIndexes, sizeof(sAllowedIndexes), "1");
					FormatEx(sIndexes, sizeof(sIndexes), "%d", iDamageIndexes);
					FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", iAttackIndex+1);

					int iCount = ExplodeString(sAllowedIndexes, " ", sAllowedIndexesList, 33, 3);
					if (iCount > 1)
					{
						for (int iIndex = 0; iIndex < iCount && iIndex < NPCChaserGetAttackCount(iBossIndex); iIndex++)
						{
							int iForIndex = StringToInt(sAllowedIndexesList[iIndex]);
							if (iForIndex == iAttackIndex + 1)
							{
								hTraceShockwave = TR_TraceRayFilterEx(flMyEyePos,
									flTargetPosShockwave,
									CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
									RayType_EndPoint,
									TraceRayDontHitCharactersOrEntity,
									slender);
								
								bool bTraceDidHitShockwave = TR_DidHit(hTraceShockwave);
								int iTraceHitEntityShockwave = TR_GetEntityIndex(hTraceShockwave);
								delete hTraceShockwave;
								
								if (bTraceDidHitShockwave && iTraceHitEntityShockwave != i)
								{
									float flTargetMins[3], flTargetMaxs[3];
									GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
									GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
									GetClientAbsOrigin(i, flTargetPosShockwave);
									for (int i2 = 0; i2 < 3; i2++) flTargetPosShockwave[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
									
									hTraceShockwave = TR_TraceRayFilterEx(flMyEyePos,
										flTargetPosShockwave,
										CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
										RayType_EndPoint,
										TraceRayDontHitCharactersOrEntity,
										slender);
										
									bTraceDidHitShockwave = TR_DidHit(hTraceShockwave);
									iTraceHitEntityShockwave = TR_GetEntityIndex(hTraceShockwave);
									delete hTraceShockwave;
								}
								
								if (!bTraceDidHitShockwave || iTraceHitEntityShockwave == i)
								{
									float flTargetDistShockwave = GetVectorSquareMagnitude(flTargetPos, flMyEyePos);

									if ((vecClientPos[2] <= vecMyPos[2] + NPCChaserGetShockwaveHeight(iBossIndex, iDifficulty)) && (flTargetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(iBossIndex, iDifficulty))))
									{
										float flPercentLife;
										flPercentLife = ClientGetFlashlightBatteryLife(i) - NPCChaserGetShockwaveDrain(iBossIndex, iDifficulty);
										if (flPercentLife < 0.0) flPercentLife = 0.0;
										ClientSetFlashlightBatteryLife(i, flPercentLife);

										float flDirectionForce[3];
										float flNewClientPosit[3];
										GetClientAbsOrigin(i, flNewClientPosit);
										flNewClientPosit[2] += 10.0;

										MakeVectorFromPoints(vecMyPos, flNewClientPosit, flDirectionForce);

										NormalizeVector(flDirectionForce, flDirectionForce);
																						
										ScaleVector(flDirectionForce, NPCChaserGetShockwaveForce(iBossIndex, iDifficulty));

										if (flDirectionForce[2] < 0.0)
										{
											flDirectionForce[2] *= -1.0;
										}

										SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", flDirectionForce);

										if (NPCChaserShockwaveStunEnabled(iBossIndex))
										{
											TF2_StunPlayer(i, NPCChaserGetShockwaveStunDuration(iBossIndex, iDifficulty), NPCChaserGetShockwaveStunSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
										}
									}		
								}
								break;
							}
						}
					}
					else //Legacy support
					{
						char sNumber = sCurrentIndex[0];
						int iAttackNumber = 0;
						if (FindCharInString(sIndexes, sNumber) != -1)
						{
							iAttackNumber += iAttackIndex+1;
						}
						if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iAttackNumber != -1)
						{
							int iCurrentAtkIndex = StringToInt(sCurrentIndex);
							if (iAttackNumber == iCurrentAtkIndex)
							{
								hTraceShockwave = TR_TraceRayFilterEx(flMyEyePos,
									flTargetPosShockwave,
									CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
									RayType_EndPoint,
									TraceRayDontHitCharactersOrEntity,
									slender);
								
								bool bTraceDidHitShockwave = TR_DidHit(hTraceShockwave);
								int iTraceHitEntityShockwave = TR_GetEntityIndex(hTraceShockwave);
								delete hTraceShockwave;
								
								if (bTraceDidHitShockwave && iTraceHitEntityShockwave != i)
								{
									float flTargetMins[3], flTargetMaxs[3];
									GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
									GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
									GetClientAbsOrigin(i, flTargetPosShockwave);
									for (int i2 = 0; i2 < 3; i2++) flTargetPosShockwave[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
									
									hTraceShockwave = TR_TraceRayFilterEx(flMyEyePos,
										flTargetPosShockwave,
										CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
										RayType_EndPoint,
										TraceRayDontHitCharactersOrEntity,
										slender);
										
									bTraceDidHitShockwave = TR_DidHit(hTraceShockwave);
									iTraceHitEntityShockwave = TR_GetEntityIndex(hTraceShockwave);
									delete hTraceShockwave;
								}
								
								if (!bTraceDidHitShockwave || iTraceHitEntityShockwave == i)
								{
									float flTargetDistShockwave = GetVectorSquareMagnitude(flTargetPos, flMyEyePos);

									if ((vecClientPos[2] <= vecMyPos[2] + NPCChaserGetShockwaveHeight(iBossIndex, iDifficulty)) && (flTargetDistShockwave <= SquareFloat(NPCChaserGetShockwaveRange(iBossIndex, iDifficulty))))
									{
										float flPercentLife;
										flPercentLife = ClientGetFlashlightBatteryLife(i) - NPCChaserGetShockwaveDrain(iBossIndex, iDifficulty);
										if (flPercentLife < 0.0) flPercentLife = 0.0;
										ClientSetFlashlightBatteryLife(i, flPercentLife);

										float flDirectionForce[3];
										float flNewClientPosit[3];
										GetClientAbsOrigin(i, flNewClientPosit);
										flNewClientPosit[2] += 10.0;

										MakeVectorFromPoints(vecMyPos, flNewClientPosit, flDirectionForce);

										NormalizeVector(flDirectionForce, flDirectionForce);
																						
										ScaleVector(flDirectionForce, NPCChaserGetShockwaveForce(iBossIndex, iDifficulty));

										if (flDirectionForce[2] < 0.0)
										{
											flDirectionForce[2] *= -1.0;
										}

										SetEntPropVector(i, Prop_Data, "m_vecBaseVelocity", flDirectionForce);

										if (NPCChaserShockwaveStunEnabled(iBossIndex))
										{
											TF2_StunPlayer(i, NPCChaserGetShockwaveStunDuration(iBossIndex, iDifficulty), NPCChaserGetShockwaveStunSlowdown(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, i);
										}
									}		
								}
							}
						}
					}
				}
				
				hTrace = TR_TraceRayFilterEx(flMyEyePos,
					flTargetPos,
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
					RayType_EndPoint,
					TraceRayDontHitAnyEntity,
					slender);
				
				bool bTraceDidHit = TR_DidHit(hTrace);
				int iTraceHitEntity = TR_GetEntityIndex(hTrace);
				delete hTrace;
				
				if (bTraceDidHit && iTraceHitEntity != i)
				{
					float flTargetMins[3], flTargetMaxs[3];
					GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
					GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
					GetClientAbsOrigin(i, flTargetPos);
					for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
					
					hTrace = TR_TraceRayFilterEx(flMyEyePos,
						flTargetPos,
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
						RayType_EndPoint,
						TraceRayDontHitAnyEntity,
						slender);
						
					bTraceDidHit = TR_DidHit(hTrace);
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
				}
				
				if (!bTraceDidHit || iTraceHitEntity == i)
				{
					flTargetDist = GetVectorSquareMagnitude(flTargetPos, flMyEyePos);

					if (flTargetDist <= SquareFloat(flAttackRange))
					{
						float flDirection[3];
						SubtractVectors(flTargetPos, flMyEyePos, flDirection);
						GetVectorAngles(flDirection, flDirection);
						
						if (FloatAbs(AngleDiff(flDirection[1], vecMyEyeAng[1])) <= flAttackFOV)
						{
							GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flDirection, flDirection);
							ScaleVector(flDirection, flAttackDamageForce);

							if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_bRenevantMultiEffect)
							{
								int iEffect = GetRandomInt(0, 6);
								switch (iEffect)
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
										int iEffectRare = GetRandomInt(1, 30);
										switch (iEffectRare)
										{
											case 1,14,25,30:
											{
												int iNewHealth = GetEntProp(i, Prop_Send, "m_iHealth")+view_as<int>(flDamage);
												if (iNewHealth > 450) iNewHealth = 450;
												TF2_AddCondition(i, TFCond_MegaHeal, 2.0);
												SetEntProp(i, Prop_Send, "m_iHealth", iNewHealth);
												flDamage = 0.0;
											}
											case 7,27:
											{
												//It's over 9000!
												flDamage = 9001.0;
											}
											case 5,16,18,22,23,26:
											{
												ScaleVector(flDirection, 1200.0);
											}
										}
									}
								}
							}
							
							if(TF2_IsPlayerInCondition(i, TFCond_UberchargedCanteen) && TF2_IsPlayerInCondition(i, TFCond_CritOnFirstBlood) && TF2_IsPlayerInCondition(i, TFCond_UberBulletResist) && TF2_IsPlayerInCondition(i, TFCond_UberBlastResist) && TF2_IsPlayerInCondition(i, TFCond_UberFireResist) && TF2_IsPlayerInCondition(i, TFCond_MegaHeal)) //Remove Powerplay
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
								Call_StartForward(fOnClientDamagedByBoss);
								Call_PushCell(i);
								Call_PushCell(iBossIndex);
								Call_PushCell(slender);
								Call_PushFloat(flTinyDamage);
								Call_PushCell(iDamageType);
								Call_Finish();
								float flCheckHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (NPCHasAttribute(iBossIndex, "death cam on low health") && GetClientTeam(i) != TFTeam_Blue)
								{
									float flCheckDamage = flTinyDamage;
									
									if ((iDamageType == 1048576 || iDamageType == 1114112) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 3;
									else if ((iDamageType == 1327104 || TF2_IsPlayerInCondition(i, TFCond_Jarated) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeath)) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 1.35;
									else if (TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 0.65;
									
									if (flCheckDamage > flCheckHealth)
									{
										ClientStartDeathCam(i, iBossIndex, vecMyPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
										{
											float flNewClientPos[3];
											GetClientAbsOrigin(i, flNewClientPos);
											flNewClientPos[2] += 10.0;

											float flEffectAng[3] = {0.0, 0.0, 0.0};
											
											VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
											AddVectors(flEffectAng, vecMyRot, flEffectAng);

											float flPullDirection[3], flPullAngle[3];
											SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
											NormalizeVector(flPullDirection, flPullDirection);
											GetVectorAngles(flPullDirection, flPullAngle);
											ScaleVector(flPullAngle, 1200.0);
											flPullAngle[2] = 10.0;
											
											TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
											
											SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
										}
										else SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
									{
										float flNewClientPos[3];
										GetClientAbsOrigin(i, flNewClientPos);
										flNewClientPos[2] += 10.0;

										float flEffectAng[3] = {0.0, 0.0, 0.0};
											
										VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
										AddVectors(flEffectAng, vecMyRot, flEffectAng);

										float flPullDirection[3], flPullAngle[3];
										SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
										NormalizeVector(flPullDirection, flPullDirection);
										GetVectorAngles(flPullDirection, flPullAngle);
										ScaleVector(flPullAngle, 1200.0);
										flPullAngle[2] = 10.0;
											
										TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
										
										SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
									}
									else SDKHooks_TakeDamage(i, slender, slender, flTinyDamage, iDamageType, _, flDirection, flMyEyePos);
								}
							}
							else
							{
								Call_StartForward(fOnClientDamagedByBoss);
								Call_PushCell(i);
								Call_PushCell(iBossIndex);
								Call_PushCell(slender);
								Call_PushFloat(flDamage);
								Call_PushCell(iDamageType);
								Call_Finish();
								float flCheckHealth = float(GetEntProp(i, Prop_Send, "m_iHealth"));
								if (NPCHasAttribute(iBossIndex, "death cam on low health") && GetClientTeam(i) != TFTeam_Blue)
								{
									float flCheckDamage = flDamage;
									
									if ((iDamageType == 1048576 || iDamageType == 1114112) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 3;
									else if ((iDamageType == 1327104 || TF2_IsPlayerInCondition(i, TFCond_Jarated) || TF2_IsPlayerInCondition(i, TFCond_MarkedForDeath)) && !TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 1.35;
									else if (TF2_IsPlayerInCondition(i, TFCond_DefenseBuffed)) flCheckDamage *= 0.65;
									
									if (flCheckDamage > flCheckHealth)
									{
										ClientStartDeathCam(i, iBossIndex, vecMyPos);
									}
									else
									{
										if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
										{
											float flNewClientPos[3];
											GetClientAbsOrigin(i, flNewClientPos);
											flNewClientPos[2] += 10.0;

											float flEffectAng[3] = {0.0, 0.0, 0.0};
											
											VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
											AddVectors(flEffectAng, vecMyRot, flEffectAng);

											float flPullDirection[3], flPullAngle[3];
											SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
											NormalizeVector(flPullDirection, flPullDirection);
											GetVectorAngles(flPullDirection, flPullAngle);
											ScaleVector(flPullAngle, 1200.0);
											flPullAngle[2] = 10.0;
											
											TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
											
											SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType|DMG_PREVENT_PHYSICS_FORCE, _, flDirection, flMyEyePos);
										}
										else SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType, _, flDirection, flMyEyePos);
									}
								}
								else
								{
									if (NPCChaserGetAttackPullIn(iBossIndex, iAttackIndex))
									{
										float flNewClientPos[3];
										GetClientAbsOrigin(i, flNewClientPos);
										flNewClientPos[2] += 10.0;

										float flEffectAng[3] = {0.0, 0.0, 0.0};
											
										VectorTransform(flMyEyePos, vecMyPos, vecMyRot, flMyEyePos);
										AddVectors(flEffectAng, vecMyRot, flEffectAng);

										float flPullDirection[3], flPullAngle[3];
										SubtractVectors(flNewClientPos, flMyEyePos, flPullDirection);
										NormalizeVector(flPullDirection, flPullDirection);
										GetVectorAngles(flPullDirection, flPullAngle);
										ScaleVector(flPullAngle, 1200.0);
										flPullAngle[2] = 10.0;
										flPullAngle[1] -= flPullAngle[1] * 2.0;
										flPullAngle[0] -= flPullAngle[0] * 2.0;
											
										TeleportEntity(i, flNewClientPos, NULL_VECTOR, flPullAngle);
										
										SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType|DMG_PREVENT_PHYSICS_FORCE, _, flDirection, flMyEyePos);
									}
									else SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType, _, flDirection, flMyEyePos);
								}
							}
							ClientViewPunch(i, flViewPunch);
							
							if(TF2_IsPlayerInCondition(i, TFCond_Gas))
							{
								TF2_IgnitePlayer(i, i);
								TF2_RemoveCondition(i, TFCond_Gas);
							}
							if(TF2_IsPlayerInCondition(i, TFCond_Milked))
							{
								float flHealthRecover = flDamage * 0.35;
								NPCChaserAddStunHealth(iBossIndex, flHealthRecover);
								if (NPCGetHealthbarState(iBossIndex))
								{
									UpdateHealthBar(iBossIndex);
								}
							}
							
							if (NPCHasAttribute(iBossIndex, "bleed player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "bleed player on hit");
								if (flDuration > 0.0 && !TF2_IsPlayerInCondition(i, TFCond_Bleeding))
								{
									TF2_MakeBleed(i, i, flDuration);
								}
							}
							if (NPCHasAttribute(iBossIndex, "ignite player on hit"))
							{
								TF2_IgnitePlayer(i, i);
							}
							if (NPCHasAttribute(iBossIndex, "stun player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "stun player on hit");
								float flSlowdown = NPCGetAttributeValue(iBossIndex, "stun player percentage");
								if (flDuration > 0.0 && flSlowdown > 0.0)
								{
									TF2_StunPlayer(i, flDuration, flSlowdown, TF_STUNFLAGS_SMALLBONK, i);
								}
							}
							if (NPCHasAttribute(iBossIndex, "jarate player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "jarate player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserJaratePlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Jarated, flDuration);
									}
								}
							}
							if (NPCHasAttribute(iBossIndex, "milk player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "milk player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserMilkPlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Milked, flDuration);
									}
								}
							}
							if (NPCHasAttribute(iBossIndex, "gas player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "gas player on hit");
								if (flDuration > 0.0)
								{
									if(!NPCChaserGasPlayerOnHit(iBossIndex))
									{
										TF2_AddCondition(i, TFCond_Gas, flDuration);
									}
								}
							}
							
							if (NPCChaserUseAdvancedDamageEffects(iBossIndex))
							{
								SlenderDoDamageEffects(iBossIndex, iAttackIndex, i);
							}
							if (NPCChaserDamageParticlesEnabled(iBossIndex))
							{
								GetProfileString(sProfile, "damage_effect_particle", sDamageEffectParticle, sizeof(sDamageEffectParticle));
								if(sDamageEffectParticle[0] != '\0')
								{
									SlenderCreateParticleAttach(iBossIndex, sDamageEffectParticle, 35.0, i);
									GetProfileString(sProfile, "sound_damage_effect", sDamageEffectSound, sizeof(sDamageEffectSound));
									if(sDamageEffectSound[0] != '\0')
									{
										EmitSoundToAll(sDamageEffectSound, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
									}
								}
							}
							if (NPCChaserXenobladeSystemEnabled(iBossIndex))
							{
								switch (iDamageType)
								{
									case 134217728: TF2_AddCondition(i, TFCond_TeleportedGlow, NPCChaserGetXenobladeBreakDuration(iBossIndex), i);
									case 131072:
									{
										if (TF2_IsPlayerInCondition(i, TFCond_TeleportedGlow))
										{
											TF2_StunPlayer(i, NPCChaserGetXenobladeToppleDuration(iBossIndex), NPCChaserGetXenobladeToppleSlowdown(iBossIndex), TF_STUNFLAGS_LOSERSTATE, i);
											TF2_RemoveCondition(i, TFCond_TeleportedGlow);
											TF2_AddCondition(i, TFCond_MedigunDebuff, NPCChaserGetXenobladeToppleDuration(iBossIndex), i);
										}
									}
									case 268435456:
									{
										if (TF2_IsPlayerInCondition(i, TFCond_MedigunDebuff))
										{
											TF2_StunPlayer(i, NPCChaserGetXenobladeDazeDuration(iBossIndex), 1.0, 10, i);
											TF2_RemoveCondition(i, TFCond_MedigunDebuff);
										}
									}
								}
							}
							
							// Add stress
							float flStressScalar = flDamage / 125.0;
							if (flStressScalar > 1.0) flStressScalar = 1.0;
							ClientAddStress(i, 0.33 * flStressScalar);

							bHit = true;
						}
					}
				}
			}
			char sSoundPath[PLATFORM_MAX_PATH];
			
			if (bHit)
			{
				// Fling it.
				int phys = CreateEntityByName("env_physexplosion");
				if (phys != -1)
				{
					TeleportEntity(phys, flMyEyePos, NULL_VECTOR, NULL_VECTOR);
					DispatchKeyValue(phys, "spawnflags", "1");
					DispatchKeyValueFloat(phys, "radius", flAttackRange);
					DispatchKeyValueFloat(phys, "magnitude", flAttackDamageForce);
					DispatchSpawn(phys);
					ActivateEntity(phys);
					AcceptEntityInput(phys, "Explode");
					RemoveEntity(phys);
				}
				if(!NPCChaserHasMultiHitSounds(iBossIndex))
				{
					GetRandomStringFromProfile(sProfile, "sound_hitenemy", sSoundPath, sizeof(sSoundPath), _, iAttackIndex + 1);
					if (sSoundPath[0] != '\0') 
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
						strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sProfile, sBuffer, 100);
						EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
				else
				{
					char sAttackString[PLATFORM_MAX_PATH];
					int iAttackIndexNum = iAttackIndex+1;
					FormatEx(sAttackString, sizeof(sAttackString), "sound_hitenemy_%i", iAttackIndexNum);
					switch (iAttackIndexNum)
					{
						case 1:
						{
							GetRandomStringFromProfile(sProfile, "sound_hitenemy", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0] != '\0') 
							{
								char sBuffer[512];
								strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_volume");
								float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
								strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_channel");
								int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
								strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_level");
								int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
								strcopy(sBuffer, sizeof(sBuffer), "sound_hitenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_pitch");
								int iPitch = GetProfileNum(sProfile, sBuffer, 100);
								EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
							}
						}
						default:
						{
							GetRandomStringFromProfile(sProfile, sAttackString, sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0] != '\0') 
							{
								char sBuffer[512];
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_volume");
								float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_channel");
								int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_level");
								int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_pitch");
								int iPitch = GetProfileNum(sProfile, sBuffer, 100);
								EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
							}
						}
					}
				}
				
			}
			else
			{
				if(!NPCChaserHasMultiMissSounds(iBossIndex))
				{
					GetRandomStringFromProfile(sProfile, "sound_missenemy", sSoundPath, sizeof(sSoundPath), _, iAttackIndex+1);
					if (sSoundPath[0] != '\0') 
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
						strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sProfile, sBuffer, 100);
						EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
				else
				{
					char sAttackString[PLATFORM_MAX_PATH];
					int iAttackIndexNum = iAttackIndex+1;
					FormatEx(sAttackString, sizeof(sAttackString), "sound_missenemy_%i", iAttackIndexNum);
					switch (iAttackIndexNum)
					{
						case 1:
						{
							GetRandomStringFromProfile(sProfile, "sound_missenemy", sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0] != '\0') 
							{
								char sBuffer[512];
								strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_volume");
								float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
								strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_channel");
								int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
								strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_level");
								int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
								strcopy(sBuffer, sizeof(sBuffer), "sound_missenemy");
								StrCat(sBuffer, sizeof(sBuffer), "_pitch");
								int iPitch = GetProfileNum(sProfile, sBuffer, 100);
								EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
							}
						}
						default:
						{
							GetRandomStringFromProfile(sProfile, sAttackString, sSoundPath, sizeof(sSoundPath));
							if (sSoundPath[0] != '\0') 
							{
								char sBuffer[512];
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_volume");
								float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_channel");
								int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_level");
								int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
								strcopy(sBuffer, sizeof(sBuffer), sAttackString);
								StrCat(sBuffer, sizeof(sBuffer), "_pitch");
								int iPitch = GetProfileNum(sProfile, sBuffer, 100);
								EmitSoundToAll(sSoundPath, slender, iChannel, iLevel, _, flVolume, iPitch);
							}
						}
					}
				}
			}
		}
		case SF2BossAttackType_Ranged:
		{	
			//BULLETS ANYONE? Thx Pelipoika
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			char sSoundPath[PLATFORM_MAX_PATH];
			float vecSpread = NPCChaserGetAttackBulletSpread(iBossIndex, iAttackIndex, iDifficulty);
			GetRandomStringFromProfile(sProfile, "sound_bulletshoot", sSoundPath, sizeof(sSoundPath));
			if (sSoundPath[0] != '\0') EmitSoundToAll(sSoundPath, slender, SNDCHAN_WEAPON, GetProfileNum(sProfile, "sound_bulletshoot_level",90));

			float flEffectPos[3];
			float flClientPos[3];
			if (IsValidClient(iTarget))
			{
				GetClientEyePosition(iTarget, flClientPos);
				flClientPos[2] -= 20.0;
			}	
			float flBasePos[3], flBaseAng[3];
			float flEffectAng[3] = {0.0, 0.0, 0.0};
			GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
			GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);
			GetProfileAttackVector(sProfile, "attack_bullet_offset", flEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
			VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
			AddVectors(flEffectAng, flBaseAng, flEffectAng);

			float flShootDirection[3], flShootAng[3];
			if (!IsValidClient(iTarget))
			{
				flShootAng[0] = vecMyEyeAng[0];
				flShootAng[1] = vecMyEyeAng[1];
				flShootAng[2] = vecMyEyeAng[2];
			}
			SubtractVectors(flClientPos, flEffectPos, flShootDirection);
			NormalizeVector(flShootDirection, flShootDirection);
			GetVectorAngles(flShootDirection, flShootAng);

			for (int i = 0; i < NPCChaserGetAttackBulletCount(iBossIndex, iAttackIndex, iDifficulty); i++)
			{
				float x, y;
				x = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );
				y = GetRandomFloat( -0.5, 0.5 ) + GetRandomFloat( -0.5, 0.5 );

				float vecDirShooting[3], vecRight[3], vecUp[3];
				GetAngleVectors(flShootAng, vecDirShooting, vecRight, vecUp);

				float vecDir[3];
				vecDir[0] = vecDirShooting[0] + x * vecSpread * vecRight[0] + y * vecSpread * vecUp[0]; 
				vecDir[1] = vecDirShooting[1] + x * vecSpread * vecRight[1] + y * vecSpread * vecUp[1]; 
				vecDir[2] = vecDirShooting[2] + x * vecSpread * vecRight[2] + y * vecSpread * vecUp[2]; 
				NormalizeVector(vecDir, vecDir);

				float vecEnd[3];
				vecEnd[0] = flEffectPos[0] + vecDir[0] * 9001.0; 
				vecEnd[1] = flEffectPos[1] + vecDir[1] * 9001.0; 
				vecEnd[2] = flEffectPos[2] + vecDir[2] * 9001.0;
				
				// Fire a bullet (ignoring the shooter).
				Handle trace = TR_TraceRayFilterEx(flEffectPos, vecEnd, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
				RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
				if ( TR_GetFraction(trace) < 1.0 )
				{
					// Verify we have an entity at the point of impact.
					if(TR_GetEntityIndex(trace) == -1)
					{
						delete trace;
						return Plugin_Stop;
					}
					
					float endpos[3];    TR_GetEndPosition(endpos, trace);
					
					if(TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
					{
						float vecNormal[3];	TR_GetPlaneNormal(trace, vecNormal);
						GetVectorAngles(vecNormal, vecNormal);
						//CreateParticle("impact_concrete", endpos, vecNormal);
					}
					
					// Regular impact effects.
					char effect[PLATFORM_MAX_PATH], tracerEffect[PLATFORM_MAX_PATH];
					tracerEffect = "bullet_tracer02_blue";
					FormatEx(effect, PLATFORM_MAX_PATH, "%s", tracerEffect);
					
					if (tracerEffect[0] != '\0')
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
						TE_WriteFloat("m_vecOrigin[0]", flEffectPos[0]);
						TE_WriteFloat("m_vecOrigin[1]", flEffectPos[1]);
						TE_WriteFloat("m_vecOrigin[2]", flEffectPos[2]);
						TE_WriteNum("m_iParticleSystemIndex", stridx);
						TE_WriteNum("entindex", slender);
						TE_WriteNum("m_iAttachType", 2);
						TE_WriteNum("m_iAttachmentPointIndex", 0);
						TE_WriteNum("m_bResetParticles", false);    
						TE_WriteNum("m_bControlPoint1", 1);    
						TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 5);  
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endpos[0]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endpos[1]);
						TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endpos[2]);
						TE_SendToAll();
					}
					
				//	TE_SetupBeamPoints(flEffectPos, endpos, g_iPathLaserModelIndex, g_iPathLaserModelIndex, 0, 30, 0.1, 0.1, 0.1, 5, 0.0, view_as<int>({255, 0, 255, 255}), 30);
				//	TE_SendToAll();
					if (NPCChaserUseAdvancedDamageEffects(iBossIndex))
					{
						SlenderDoDamageEffects(iBossIndex, iAttackIndex, TR_GetEntityIndex(trace));
					}
					SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackBulletDamage(iBossIndex, iAttackIndex, iDifficulty), DMG_BULLET, _, CalculateBulletDamageForce(vecDir, 1.0), endpos);
				}
				
				delete trace;
			}
		}
		case SF2BossAttackType_Projectile:
		{
			int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			if (IsValidClient(iTarget) && IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && !IsClientInGhostMode(iTarget))
			{
				if(!view_as<bool>(GetProfileNum(sProfile,"multi_shoot_projectile_sounds",0)))
				{
					NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile");
				}
				else
				{
					int iAttackIndexNum = iAttackIndex+1;
					char sAttackShootString[128];
					FormatEx(sAttackShootString, sizeof(sAttackShootString), "sound_attackshootprojectile_%i", iAttackIndexNum);
					switch (iAttackIndexNum)
					{
						case 1: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, "sound_attackshootprojectile");
						default: NPCChaserProjectileAttackShoot(iBossIndex, slender, iTarget, sProfile, sAttackShootString);
					}
				}
				if(view_as<bool>(GetProfileNum(sProfile,"use_shoot_animations",0)))
				{
					g_bNPCUseFireAnimation[iBossIndex] = true;
					int iState = g_iSlenderState[iBossIndex];
					NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
				}
			}
			else //Our target is unavailable, abort.
			{
				g_bSlenderAttacking[iBossIndex] = false;
				g_bNPCStealingLife[iBossIndex] = false;
				if (g_hSlenderAttackTimer[iBossIndex] != null) KillTimer(g_hSlenderAttackTimer[iBossIndex]);
				if (g_hNPCLifeStealTimer[iBossIndex] != null) KillTimer(g_hNPCLifeStealTimer[iBossIndex]);
				if (g_hSlenderBackupAtkTimer[iBossIndex] != null) KillTimer(g_hSlenderBackupAtkTimer[iBossIndex]);
				g_bNPCAlreadyAttacked[iBossIndex] = false;
				g_bNPCUseFireAnimation[iBossIndex] = false;
				if (g_hSlenderLaserTimer[iBossIndex] != null) KillTimer(g_hSlenderLaserTimer[iBossIndex]);
				return Plugin_Stop;
			}
		}
	}
	if (NPCChaserGetAttackDisappear(iBossIndex, iAttackIndex) != 1 && NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) < 1)
	{
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
	}
	if(NPCChaserGetAttackRepeat(iBossIndex, iAttackIndex) >= 1 && !g_bNPCAlreadyAttacked[iBossIndex])
	{
		g_hSlenderBackupAtkTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEndBackup, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
		g_bNPCAlreadyAttacked[iBossIndex] = true;
	}
	if (NPCChaserGetAttackDisappear(iBossIndex, iAttackIndex) == 1)
	{
		g_bSlenderAttacking[iBossIndex] = false;
		g_bNPCStealingLife[iBossIndex] = false;
		if (g_hSlenderAttackTimer[iBossIndex] != null) KillTimer(g_hSlenderAttackTimer[iBossIndex]);
		if (g_hNPCLifeStealTimer[iBossIndex] != null) KillTimer(g_hNPCLifeStealTimer[iBossIndex]);
		if (g_hSlenderBackupAtkTimer[iBossIndex] != null) KillTimer(g_hSlenderBackupAtkTimer[iBossIndex]);
		g_bNPCAlreadyAttacked[iBossIndex] = false;
		g_bNPCUseFireAnimation[iBossIndex] = false;
		if (g_hSlenderLaserTimer[iBossIndex] != null) KillTimer(g_hSlenderLaserTimer[iBossIndex]);
		RemoveSlender(iBossIndex);
		return Plugin_Stop;
	}
	delete hTrace;
	delete hTraceShockwave;
	return Plugin_Stop;
}

float[] CalculateBulletDamageForce(const float vecBulletDir[3], float flScale)
{
	float vecForce[3]; vecForce = vecBulletDir;
	NormalizeVector( vecForce, vecForce );
	ScaleVector(vecForce, FindConVar("phys_pushscale").FloatValue);
	ScaleVector(vecForce, flScale);
	return vecForce;
}

public Action Timer_SlenderChaseBossAttackIgniteHit(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;

	if (timer != g_hPlayerIgniteTimer[player]) return Plugin_Stop;
	
	TF2_IgnitePlayer(player, player);
	g_hPlayerResetIgnite[player] = CreateTimer(0.1, Timer_SlenderChaseBossResetIgnite, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action Timer_SlenderChaseBossResetIgnite(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;

	if (timer != g_hPlayerResetIgnite[player]) return Plugin_Stop;
	
	g_hPlayerIgniteTimer[player] = null;
	return Plugin_Stop;
}

public Action Timer_SlenderPrepareExplosiveDance(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	CreateTimer(0.13, Timer_SlenderChaseBossExplosiveDance, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action Timer_SlenderChaseBossExplosiveDance(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	static int iExploded = 0;

	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		iExploded=0;
		return Plugin_Stop;
	}

	// Damage all players within range.
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);

	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	int iRange = NPCChaserGetAttackExplosiveDanceRadius(iBossIndex, iAttackIndex);
	
	AddVectors(g_flSlenderEyePosOffset[iBossIndex], vecMyEyeAng, vecMyEyeAng);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	
	if (!g_bSlenderAttacking[iBossIndex])
	{
		iExploded=0;
		return Plugin_Stop;
	}

	iExploded++;
	if (iExploded <= 35)
	{
		float flSlenderPosition[3], flexplosionPosition[3];
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPosition);
		flexplosionPosition[2] = flSlenderPosition[2] + 50.0;
		for (int e = 0; e < 5; e++)
		{					
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;
				
				if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;
					
				int explosivePower = CreateEntityByName("env_explosion");
				if (explosivePower != -1)
				{
					DispatchKeyValueFloat(explosivePower, "DamageForce", 180.0);
						
					SetEntProp(explosivePower, Prop_Data, "m_iMagnitude", 666, 4);
					SetEntProp(explosivePower, Prop_Data, "m_iRadiusOverride", 200, 4);
					SetEntPropEnt(explosivePower, Prop_Data, "m_hOwnerEntity", slender);
					flexplosionPosition[0]=flSlenderPosition[0]+float(GetRandomInt(-iRange, iRange));
					flexplosionPosition[1]=flSlenderPosition[1]+float(GetRandomInt(-iRange, iRange));
					TeleportEntity(explosivePower, flexplosionPosition, NULL_VECTOR, NULL_VECTOR);
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
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender));
		iExploded=0;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossAttackBeginLaser(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return Plugin_Stop;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	g_flNPCLaserTimer[iBossIndex] = GetGameTime() + NPCChaserGetAttackLaserDuration(iBossIndex, iAttackIndex);

	g_hSlenderLaserTimer[iBossIndex] = CreateTimer(0.1, Timer_SlenderChaseBossAttackLaser, EntIndexToEntRef(slender), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);

	NPCChaserSetNextAttackTime(iBossIndex, iAttackIndex, GetGameTime()+NPCChaserGetAttackCooldown(iBossIndex, iAttackIndex, iDifficulty));

	return Plugin_Stop;
}

public Action Timer_SlenderChaseBossAttackLaser(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderLaserTimer[iBossIndex]) return Plugin_Stop;
	
	if (GetGameTime() >= g_flNPCLaserTimer[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return Plugin_Stop;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	if (!g_bSlenderAttacking[iBossIndex]) return Plugin_Stop;
	
	int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	if (IsValidClient(iTarget) && IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && !IsClientInGhostMode(iTarget))
	{
		float flEffectPos[3];
		float flClientPos[3];
		
		GetClientEyePosition(iTarget, flClientPos);
		flClientPos[2] -= 20.0;
		
		float flBasePos[3], flBaseAng[3];
		float flEffectAng[3] = {0.0, 0.0, 0.0};
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);
		GetProfileAttackVector(sProfile, "attack_laser_offset", flEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
		VectorTransform(flEffectPos, flBasePos, flBaseAng, flEffectPos);
		AddVectors(flEffectAng, flBaseAng, flEffectAng);

		float flShootDirection[3], flShootAng[3];
		if (!IsValidClient(iTarget))
		{
			flShootAng[0] = flBaseAng[0];
			flShootAng[1] = flBaseAng[1];
			flShootAng[2] = flBaseAng[2];
		}
		SubtractVectors(flClientPos, flEffectPos, flShootDirection);
		NormalizeVector(flShootDirection, flShootDirection);
		GetVectorAngles(flShootDirection, flShootAng);

		float vecDirShooting[3];
		GetAngleVectors(flShootAng, vecDirShooting, NULL_VECTOR, NULL_VECTOR);

		float vecDir[3];
		vecDir[0] = vecDirShooting[0]; 
		vecDir[1] = vecDirShooting[1]; 
		vecDir[2] = vecDirShooting[2]; 
		NormalizeVector(vecDir, vecDir);

		float vecEnd[3];
		vecEnd[0] = flEffectPos[0] + vecDir[0] * 9001.0; 
		vecEnd[1] = flEffectPos[1] + vecDir[1] * 9001.0; 
		vecEnd[2] = flEffectPos[2] + vecDir[2] * 9001.0;

		Handle trace = TR_TraceRayFilterEx(flEffectPos, vecEnd, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
		RayType_EndPoint, TraceRayDontHitAnyEntity, slender);
		if ( TR_GetFraction(trace) < 1.0 )
		{
			// Verify we have an entity at the point of impact.
			if(TR_GetEntityIndex(trace) == -1)
			{
				delete trace;
				return Plugin_Stop;
			}

			float endpos[3];    TR_GetEndPosition(endpos, trace);

			if(TR_GetEntityIndex(trace) <= 0 || TR_GetEntityIndex(trace) > MaxClients)
			{
				float vecNormal[3];	TR_GetPlaneNormal(trace, vecNormal);
				GetVectorAngles(vecNormal, vecNormal);
			}
			
			int iColor[3];
			NPCChaserGetAttackLaserColor(iBossIndex, iAttackIndex, iColor);
			int iColorReal[4];
			iColorReal[0] = iColor[0];
			iColorReal[1] = iColor[1];
			iColorReal[2] = iColor[2];
			iColorReal[3] = 255;
			
			if (NPCChaserGetAttackLaserAttachmentState(iBossIndex, iAttackIndex))
			{
				int iTargetEnt = CreateEntityByName("info_target");
				char sAttachment[PLATFORM_MAX_PATH];
				TeleportEntity(iTargetEnt, flBasePos, NULL_VECTOR, NULL_VECTOR);
				SetVariantString("!activator");
				AcceptEntityInput(iTargetEnt, "SetParent", slender);
				GetProfileAttackString(sProfile, "attack_laser_attachment_name", sAttachment, sizeof(sAttachment), "", iAttackIndex+1);
				if (sAttachment[0] != '\0')
				{
					SetVariantString(sAttachment);
					AcceptEntityInput(iTargetEnt, "SetParentAttachment");
				}
				float flTargetEntPos[3];
				GetEntPropVector(iTargetEnt, Prop_Data, "m_vecAbsOrigin", flTargetEntPos);
				TE_SetupBeamPoints(flTargetEntPos, endpos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), 5, NPCChaserGetAttackLaserNoise(iBossIndex, iAttackIndex), iColorReal, 1);
				TE_SendToAll();
				CreateTimer(0.1, Timer_KillEdict, EntIndexToEntRef(iTargetEnt), TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				TE_SetupBeamPoints(flEffectPos, endpos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, 0.1, NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), NPCChaserGetAttackLaserSize(iBossIndex, iAttackIndex), 5, NPCChaserGetAttackLaserNoise(iBossIndex, iAttackIndex), iColorReal, 1);
				TE_SendToAll();
			}
			if (NPCChaserUseAdvancedDamageEffects(iBossIndex))
			{
				SlenderDoDamageEffects(iBossIndex, iAttackIndex, TR_GetEntityIndex(trace));
			}
			SDKHooks_TakeDamage(TR_GetEntityIndex(trace), slender, slender, NPCChaserGetAttackLaserDamage(iBossIndex, iAttackIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB, _, _, endpos);
		}

		delete trace;

	}
	return Plugin_Continue;
}

bool NPCAttackValidateTarget(int iBossIndex,int iTarget, float flAttackRange, float flAttackFOV, bool bCheckBlock = false)
{
	int iBoss = NPCGetEntIndex(iBossIndex);
	
	float flMyEyePos[3], flMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	if(iTarget>MaxClients)
	{
		//float flVecMaxs[3];
		flMyEyePos[2]+=30.0;
	}
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	AddVectors(g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng, flMyEyeAng);

	float flTargetPos[3], flTargetMins[3], flTargetMaxs[3];
	GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
	
	for (int i = 0; i < 3; i++)
	{
		flTargetPos[i] += (flTargetMins[i] + flTargetMaxs[i]) / 2.0;
	}
	
	float flTargetDist = GetVectorSquareMagnitude(flTargetPos, flMyEyePos);
	if (flTargetDist <= SquareFloat(flAttackRange))
	{
		float flDirection[3];
		SubtractVectors(g_flSlenderGoalPos[iBossIndex], flMyEyePos, flDirection);
		GetVectorAngles(flDirection, flDirection);
		
		if (FloatAbs(AngleDiff(flDirection[1], flMyEyeAng[1])) <= flAttackFOV / 2.0)
		{
			Handle hTrace = TR_TraceRayFilterEx(flMyEyePos,
				flTargetPos,
				CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP,
				RayType_EndPoint,
				TraceRayDontHitAnyEntity,
				iBoss);
				
			bool bTraceDidHit = TR_DidHit(hTrace);
			int iTraceHitEntity = TR_GetEntityIndex(hTrace);
			delete hTrace;
			
			if (!bTraceDidHit || iTraceHitEntity == iTarget)
			{
				if (bCheckBlock)
				{
					float flPos[3], flPosForward[3];
					GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flPos);
					GetPositionForward(flPos, flMyEyeAng, flPosForward, SquareRoot(flTargetDist+SquareFloat(50.0)));
					if (NPCGetRaidHitbox(iBossIndex) == 1)
					{
						hTrace = TR_TraceHullFilterEx(flPos,
						flPosForward, 
						g_flSlenderDetectMins[iBossIndex], 
						g_flSlenderDetectMaxs[iBossIndex], 
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
						TraceRayBossVisibility, 
						iBoss);
					}
					else if (NPCGetRaidHitbox(iBossIndex) == 0)
					{
						hTrace = TR_TraceHullFilterEx(flPos,
						flPosForward, 
						HULL_HUMAN_MINS, 
						HULL_HUMAN_MAXS, 
						CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE | CONTENTS_MONSTERCLIP, 
						TraceRayBossVisibility, 
						iBoss);
					}
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (iTraceHitEntity == iTarget)
					{
						return true;
					}
				}
				else
					return true;
			}
			delete hTrace;
		}
	}
	
	return false;
}

static Action Timer_SlenderChaseBossAttackEnd(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	loco.ClearStuckStatus();
	
	g_bSlenderAttacking[iBossIndex] = false;
	g_bNPCStealingLife[iBossIndex] = false;
	g_hSlenderAttackTimer[iBossIndex] = null;
	g_hNPCLifeStealTimer[iBossIndex] = null;
	g_hSlenderBackupAtkTimer[iBossIndex] = null;
	g_bNPCAlreadyAttacked[iBossIndex] = false;
	g_bNPCUseFireAnimation[iBossIndex] = false;
	g_hSlenderLaserTimer[iBossIndex] = null;
	CBaseNPC_RemoveAllLayers(slender);
	return Plugin_Stop;
}

static Action Timer_SlenderChaseBossAttackEndBackup(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderBackupAtkTimer[iBossIndex]) return Plugin_Stop;

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(slender);
	CBaseNPC_Locomotion loco = npc.GetLocomotion();
	loco.ClearStuckStatus();
	
	g_bSlenderAttacking[iBossIndex] = false;
	g_bNPCStealingLife[iBossIndex] = false;
	g_hSlenderAttackTimer[iBossIndex] = null;
	g_hNPCLifeStealTimer[iBossIndex] = null;
	g_hSlenderBackupAtkTimer[iBossIndex] = null;
	g_bNPCAlreadyAttacked[iBossIndex] = false;
	g_bNPCUseFireAnimation[iBossIndex] = false;
	g_hSlenderLaserTimer[iBossIndex] = null;
	CBaseNPC_RemoveAllLayers(slender);
	return Plugin_Stop;
}
