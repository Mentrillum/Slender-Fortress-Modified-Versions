#if defined _sf2_npc_chaser_projectiles_included
 #endinput
#endif
#define _sf2_npc_chaser_projectiles_included

static char sGestureShootAnim[PLATFORM_MAX_PATH];
static char sBaseballModel[PLATFORM_MAX_PATH];

//static float g_projectileSpeed[2049];
//static float g_projectileDamage[2049];
//static float g_projectileRadius[2049];
//static float g_projectileIceSlowPercent[2049];
//static float g_projectileIceSlowDuration[2049];
//static float g_flOriginalProjectilePos[2049][3];
//static int g_projectileType[2049];
//static int g_projectileRotateState[2049]; // 0 = 0 degrees, 1 = 1-180 degrees, 2 = 181-360 degrees
//static Handle g_hProjectileTimer[2049];

/*public Action Timer_ProjectileThink(Handle timer, any entref)
{
	int projectile = EntRefToEntIndex(entref);
	if (!projectile || projectile == INVALID_ENT_REFERENCE) return Plugin_Stop;

	if (timer != g_hProjectileTimer[projectile]) return Plugin_Stop;

	float flPos[3], flAng[3], flNewPos[3];
	GetEntPropVector(projectile, Prop_Data, "m_vecAbsOrigin", flPos);
	GetEntPropVector(projectile, Prop_Data, "m_angAbsRotation", flAng);

	flNewPos[0] = flPos[0];
	flNewPos[1] = flPos[1];
	flNewPos[2] = flPos[2];

	float flSpeed = (g_projectileSpeed[projectile] - 64.0) / 54.0;
	AddVectors(g_flOriginalProjectilePos[projectile], flNewPos, flNewPos);
	flNewPos[0] += g_flOriginalProjectilePos[projectile][0];
	flNewPos[1] += g_flOriginalProjectilePos[projectile][1];
	switch (g_projectileRotateState[projectile])
	{
		case 0: flNewPos[2] = g_flOriginalProjectilePos[projectile][2];
		case 1: flNewPos[2] += g_flOriginalProjectilePos[projectile][2]/flAng[0];
		case 2: flNewPos[2] -= g_flOriginalProjectilePos[projectile][2]/flAng[0];
	}

	TeleportEntity(projectile, flNewPos, flAng, NULL_VECTOR);

	return Plugin_Continue;
}*/

public int NPCChaserProjectileShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, float flMyPos[3])
{
	if (g_bRestartSessionEnabled) return -1;

	CBaseCombatCharacter combatChar = CBaseCombatCharacter(slender);
	
	int projectileType = NPCChaserGetProjectileType(iBossIndex);
	int difficulty = GetLocalGlobalDifficulty(iBossIndex);
	int projectileEnt;
	float flShootDist = GetVectorSquareMagnitude(g_flSlenderGoalPos[iBossIndex], flMyPos);
	
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, profile, sizeof(profile));
	
	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	float flNonRocketScaleMins[3], flNonRocketScaleMaxs[3];
	flNonRocketScaleMins[0] = -10.0;
	flNonRocketScaleMins[1] = -10.0;
	flNonRocketScaleMins[2] = -10.0;
	flNonRocketScaleMaxs[0] = 10.0;
	flNonRocketScaleMaxs[1] = 10.0;
	flNonRocketScaleMaxs[2] = 10.0;
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);
	switch (projectileType)
	{
		case SF2BossProjectileType_Grenade:
		{
			if (flShootDist < SquareFloat(600.0))
			{
				flClientPos[2] += 0.0;
			}
			else if (flShootDist > SquareFloat(600.0) && flShootDist < SquareFloat(1000.0))
			{
				flClientPos[2] += 60.0;
			}
			else if (flShootDist > SquareFloat(1000.0))
			{
				flClientPos[2] += 120.0;
			}
		}
		case SF2BossProjectileType_Arrow, SF2BossProjectileType_Baseball:
		{
			flClientPos[2] -= 0.0;
		}
		default:
		{
			flClientPos[2] -= 25.0;
		}
	}

	float flBasePos[3], flBaseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);

	float flEffectPos[3], flTempEffectPos[3];
	float flEffectAng[3] = {0.0, 0.0, 0.0};
	
	int iRandomPosMin = GetProfileNum(profile, "projectile_pos_number_min", 1);
	int iRandomPosMax = GetProfileNum(profile, "projectile_pos_number_max", 1);
	
	if (iRandomPosMin == 1 && iRandomPosMax == 1)
	{
		g_Config.GetVector("projectile_pos_offset", flTempEffectPos);
	}
	else
	{
		int iRandomProjectilePos = GetRandomInt(iRandomPosMin, iRandomPosMax);
		char sKeyName[PLATFORM_MAX_PATH];
		FormatEx(sKeyName, sizeof(sKeyName), "projectile_pos_offset_%i", iRandomProjectilePos);
		g_Config.GetVector(sKeyName, flTempEffectPos);
	}

	VectorTransform(flTempEffectPos, flBasePos, flBaseAng, flTempEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float vecSpread = NPCChaserGetProjectileDeviation(iBossIndex, difficulty);

	int iTeam = 3;
	int iTeamNon = 5;

	float flMin = NPCChaserGetProjectileCooldownMin(iBossIndex, difficulty);
	float flMax = NPCChaserGetProjectileCooldownMax(iBossIndex, difficulty);
	
	for (int i = 0; i < NPCChaserGetProjectileCount(iBossIndex, difficulty); i++)
	{
		if (NPCChaserGetProjectileCount(iBossIndex, difficulty) != 1)
		{
			flEffectPos[0] = flTempEffectPos[0] + GetRandomFloat(-10.0, 10.0);
			flEffectPos[1] = flTempEffectPos[1] + GetRandomFloat(-10.0, 10.0);
			flEffectPos[2] = flTempEffectPos[2] + GetRandomFloat(-10.0, 10.0);
		}
		else
		{
			flEffectPos[0] = flTempEffectPos[0];
			flEffectPos[1] = flTempEffectPos[1];
			flEffectPos[2] = flTempEffectPos[2];
		}
		float flShootDirection[3], flShootAng[3];
		SubtractVectors(flClientPos, flEffectPos, flShootDirection);
		if (vecSpread != 0.0)
		{
			flShootDirection[0] += GetRandomFloat(-vecSpread, vecSpread);
			flShootDirection[1] += GetRandomFloat(-vecSpread, vecSpread);
			flShootDirection[2] += GetRandomFloat(-vecSpread, vecSpread);
		}
		NormalizeVector(flShootDirection, flShootDirection);
		GetVectorAngles(flShootDirection, flShootAng);

		switch(projectileType)
		{
			case SF2BossProjectileType_Fireball:		
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					AttachParticle(projectileEnt, g_sSlenderFireballTrail[iBossIndex]);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_FIREBALL);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Iceball:
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					AttachParticle(projectileEnt, g_sSlenderIceballTrail[iBossIndex]);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_ICEBALL);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Rocket:
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(iBossIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					SetEntityModel(projectileEnt, g_sSlenderRocketModel[iBossIndex]);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			/*case SF2BossProjectileType_Rocket:
			{
				sProjectileName = "prop_dynamic_override";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					g_projectileSpeed[projectileEnt] = NPCChaserGetProjectileSpeed(iBossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					//if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					//SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					g_hProjectileTimer[projectileEnt] = CreateTimer(BOSS_THINKRATE, Timer_ProjectileThink, EntIndexToEntRef(projectileEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					SetEntityModel(projectileEnt, ROCKET_MODEL);

					//SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					GetEntPropVector(projectileEnt, Prop_Data, "m_vecOrigin", g_flOriginalProjectilePos[projectileEnt]);
					g_flOriginalProjectilePos[projectileEnt][0] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[projectileEnt][1] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[projectileEnt][2] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					PrintToChatAll("%f", flShootAng[0]);
					if (flShootAng[0] == 0.0  || flShootAng[0] == 180.0)
						g_projectileRotateState[projectileEnt] = 0;
					else if (flShootAng[0] > 0.0 && flShootAng[0] < 180.0)
						g_projectileRotateState[projectileEnt] = 1;
					else if (flShootAng[0] > 180.0)
						g_projectileRotateState[projectileEnt] = 2;

					CreateTimer(1.0, Timer_KillEntity, EntIndexToEntRef(projectileEnt), TIMER_FLAG_NO_MAPCHANGE);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}*/
			case SF2BossProjectileType_Grenade:
			{
				sProjectileName = "tf_projectile_pipe";
				if (flShootDist <= SquareFloat(1800.0))
				{
					projectileEnt = CreateEntityByName(sProjectileName);
					if (projectileEnt != -1)
					{
						float flVelocity[3], flBufferProj[3];

						GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

						flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
						flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
						flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
						
						TeleportEntity(projectileEnt, flEffectPos, flShootAng, NULL_VECTOR);
						DispatchSpawn(projectileEnt);
						if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
						SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
						SetEntProp(projectileEnt,    Prop_Send, "m_nSkin",     1, 1);
						SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						SetEntPropFloat(projectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetProjectileRadius(iBossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Send, "m_damage",  NPCChaserGetProjectileDamage(iBossIndex, difficulty));
						TeleportEntity(projectileEnt, NULL_VECTOR, NULL_VECTOR, flVelocity);
						SetEntDataFloat(projectileEnt, g_dataFullDamage, NPCChaserGetProjectileDamage(iBossIndex, difficulty));
						ProjectileSetFlags(projectileEnt, PROJ_GRENADE);

						if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
						{
							GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

							int iSequence = combatChar.LookupSequence(sGestureShootAnim);
							if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
						}

						if (i == 0) EmitSoundToAll(g_sSlenderGrenadeShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					}
				}
			}
			case SF2BossProjectileType_SentryRocket:
			{
				sProjectileName = "tf_projectile_sentryrocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_SentryRocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(iBossIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_SENTRYROCKET);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderSentryRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Arrow:
			{
				sProjectileName = "tf_point_weapon_mimic";
				if (flShootDist <= SquareFloat(1250.0))
				{
					projectileEnt = CreateEntityByName(sProjectileName);
					if (projectileEnt != -1)
					{
						float flVelocity[3], flBufferProj[3];

						GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

						flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
						flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
						flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);

						if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCrits", 1, 1);
						SetEntPropFloat(projectileEnt, Prop_Data, "m_damage", NPCChaserGetProjectileDamage(iBossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Data, "m_flSpeedMin", NPCChaserGetProjectileSpeed(iBossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Data, "m_flSpeedMax", NPCChaserGetProjectileSpeed(iBossIndex, difficulty));
						SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						ProjectileSetFlags(projectileEnt, PROJ_ARROW);
						TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
						DispatchSpawn(projectileEnt);
						DispatchKeyValueVector(projectileEnt, "origin", flEffectPos);
						DispatchKeyValueVector(projectileEnt, "angles", flShootAng);
						DispatchKeyValue(projectileEnt, "WeaponType", "2");

						AcceptEntityInput(projectileEnt, "FireOnce");

						if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
						{
							GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

							int iSequence = combatChar.LookupSequence(sGestureShootAnim);
							if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
						}

						CreateTimer(5.0, Timer_KillEntity, EntIndexToEntRef(projectileEnt), TIMER_FLAG_NO_MAPCHANGE);
						if (i == 0) EmitSoundToAll(g_sSlenderArrowShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					}
				}
			}
			case SF2BossProjectileType_Mangler:
			{
				sProjectileName = "tf_projectile_energy_ball";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntProp(projectileEnt, Prop_Send, "m_CollisionGroup", 4);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     5, 1);
					SetEntProp(projectileEnt, Prop_Data, "m_takedamage", 0);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", view_as<float>( { 3.0, 3.0, 3.0 } ));
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", view_as<float>( { 3.0, 3.0, 3.0 } ));
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					ProjectileSetFlags(projectileEnt, PROJ_MANGLER);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderManglerShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Baseball:
			{
				sProjectileName = "tf_projectile_stun_ball";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, difficulty);
					GetProfileString(sSlenderProfile, "baseball_model", sBaseballModel, sizeof(sBaseballModel));
					if (sBaseballModel[0] == '\0')
					{
						sBaseballModel = BASEBALL_MODEL;
					}

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropEnt(projectileEnt, Prop_Send, "m_hThrower", slender);
					SetEntityModel(projectileEnt, sBaseballModel);
					ProjectileSetFlags(projectileEnt, PROJ_BASEBALL);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex) && i == 0)
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						int iSequence = combatChar.LookupSequence(sGestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderBaseballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
		}
	}

	return projectileEnt;
}

public int NPCChaserProjectileAttackShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, const char[] sSectionName)
{
	int attackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	int projectileType = NPCChaserGetAttackProjectileType(iBossIndex, attackIndex);
	int projectileEnt;
	int difficulty = GetLocalGlobalDifficulty(iBossIndex);

	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	float flNonRocketScaleMins[3], flNonRocketScaleMaxs[3];
	flNonRocketScaleMins[0] = -10.0;
	flNonRocketScaleMins[1] = -10.0;
	flNonRocketScaleMins[2] = -10.0;
	flNonRocketScaleMaxs[0] = 10.0;
	flNonRocketScaleMaxs[1] = 10.0;
	flNonRocketScaleMaxs[2] = 10.0;
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);
	flClientPos[2] -= 25.0;

	float flBasePos[3], flBaseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);

	float flEffectPos[3], flTempEffectPos[3];
	float flEffectAng[3] = {0.0, 0.0, 0.0};
	
	GetProfileAttackVector(sSlenderProfile, "attack_projectile_offset", flTempEffectPos, view_as<float>({0.0, 0.0, 0.0}), attackIndex+1);
	VectorTransform(flTempEffectPos, flBasePos, flBaseAng, flTempEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float vecSpread = NPCChaserGetAttackProjectileDeviation(iBossIndex, attackIndex, difficulty);

	int iTeam = 3;
	int iTeamNon = 5;
	for (int i = 0; i < NPCChaserGetAttackProjectileCount(iBossIndex, attackIndex, difficulty); i++)
	{
		if (NPCChaserGetAttackProjectileCount(iBossIndex, attackIndex, difficulty) != 1)
		{
			flEffectPos[0] = flTempEffectPos[0] + GetRandomFloat(-10.0, 10.0);
			flEffectPos[1] = flTempEffectPos[1] + GetRandomFloat(-10.0, 10.0);
			flEffectPos[2] = flTempEffectPos[2] + GetRandomFloat(-10.0, 10.0);
		}
		else
		{
			flEffectPos[0] = flTempEffectPos[0];
			flEffectPos[1] = flTempEffectPos[1];
			flEffectPos[2] = flTempEffectPos[2];
		}

		float flShootDirection[3], flShootAng[3];
		SubtractVectors(flClientPos, flEffectPos, flShootDirection);
		if (vecSpread != 0.0)
		{
			flShootDirection[0] += GetRandomFloat(-vecSpread, vecSpread);
			flShootDirection[1] += GetRandomFloat(-vecSpread, vecSpread);
			flShootDirection[2] += GetRandomFloat(-vecSpread, vecSpread);
		}
		NormalizeVector(flShootDirection, flShootDirection);
		GetVectorAngles(flShootDirection, flShootAng);

		switch(projectileType)
		{
			case 0:		
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					char sFireballTrail[PLATFORM_MAX_PATH];
					GetProfileAttackString(sSlenderProfile, "attack_fire_trail", sFireballTrail, sizeof(sFireballTrail), FIREBALL_TRAIL, attackIndex+1);
					AttachParticle(projectileEnt, sFireballTrail);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_FIREBALL_ATTACK);
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);
					
					char sPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
					
					if (sPath[0] != '\0')
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
						
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
			}
			case 1:
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];
					char sRocketModel[PLATFORM_MAX_PATH];
					GetProfileAttackString(sSlenderProfile, "attack_rocket_model", sRocketModel, sizeof(sRocketModel), ROCKET_MODEL, attackIndex+1);

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserGetAttackProjectileCrits(iBossIndex, attackIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetAttackProjectileDamage(iBossIndex, attackIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					if (strcmp(sRocketModel, ROCKET_MODEL, true) != 0)
					{
						int iModel;
						iModel = PrecacheModel(sRocketModel, true);
						SetEntProp(projectileEnt, Prop_Send, "m_nModelIndexOverrides", iModel);
					}

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);

					char sPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
					
					if (sPath[0] != '\0' && i == 0)
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
						
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
			}
			case 2:
			{
				sProjectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					char sFireballTrail[PLATFORM_MAX_PATH];
					GetProfileAttackString(sSlenderProfile, "attack_fire_iceball_trail", sFireballTrail, sizeof(sFireballTrail), ICEBALL_TRAIL, attackIndex+1);
					AttachParticle(projectileEnt, sFireballTrail);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_ICEBALL_ATTACK);

					char sPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
					
					if (sPath[0] != '\0' && i == 0)
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
						
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
			}
			case 3:
			{
				sProjectileName = "tf_projectile_pipe";
				projectileEnt = CreateEntityByName(sProjectileName);
				if (projectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, attackIndex, difficulty);
						
					TeleportEntity(projectileEnt, flEffectPos, flShootAng, NULL_VECTOR);
					DispatchSpawn(projectileEnt);
					if (NPCChaserGetAttackProjectileCrits(iBossIndex, attackIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
					SetEntProp(projectileEnt,    Prop_Send, "m_nSkin",     1, 1);
					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetAttackProjectileDamage(iBossIndex, attackIndex, difficulty));
					SetEntPropFloat(projectileEnt, Prop_Send, "m_damage",  NPCChaserGetAttackProjectileRadius(iBossIndex, attackIndex, difficulty));
					SetEntDataFloat(projectileEnt, g_dataFullDamage, NPCChaserGetAttackProjectileDamage(iBossIndex, attackIndex, difficulty));
					TeleportEntity(projectileEnt, NULL_VECTOR, NULL_VECTOR, flVelocity);
					ProjectileSetFlags(projectileEnt, PROJ_GRENADE);

					//SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);

					char sPath[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(sSlenderProfile, sSectionName, sPath, sizeof(sPath));
					
					if (sPath[0] != '\0' && i == 0)
					{
						char sBuffer[512];
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_volume");
						float flVolume = GetProfileFloat(sSlenderProfile, sBuffer, 1.0);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_channel");
						int iChannel = GetProfileNum(sSlenderProfile, sBuffer, SNDCHAN_WEAPON);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_level");
						int iLevel = GetProfileNum(sSlenderProfile, sBuffer, SNDLEVEL_SCREAMING);
						strcopy(sBuffer, sizeof(sBuffer), sSectionName);
						StrCat(sBuffer, sizeof(sBuffer), "_pitch");
						int iPitch = GetProfileNum(sSlenderProfile, sBuffer, 100);
						
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
				}
			}
		}
	}

	return projectileEnt;
}

public Action Hook_ProjectileAttackTouch(int entity, int iOther)
{
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_ICEBALL_ATTACK:
		{
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					EmitSoundToAll(g_sSlenderFireballExplodeSound[iBossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "spell_batball_impact_blue");
			}
		}
		case PROJ_FIREBALL_ATTACK:
		{
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				EmitSoundToAll(FIREBALL_IMPACT, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				CreateGeneralParticle(entity, "bombinomicon_burningdebris");
			}
		}
	}
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_FIREBALL_ATTACK, PROJ_ICEBALL_ATTACK:
		{
			float flEntPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			flEntPos[2] += 10.0;
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					int difficulty = GetLocalGlobalDifficulty(iBossIndex);
					int attackIndex = NPCGetCurrentAttackIndex(iBossIndex);
					bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
					float flRadius = NPCChaserGetAttackProjectileRadius(iBossIndex, attackIndex, difficulty);
					for (int client = 1; client <= MaxClients; client++)
					{
						if (!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client)) continue;

						if (!bAttackEliminated && g_bPlayerEliminated[client]) continue;

						float flTargetPos[3];
						GetClientEyePosition(client, flTargetPos);

						Handle hTrace = TR_TraceRayFilterEx(flEntPos, 
							flTargetPos, 
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, 
							RayType_EndPoint, 
							TraceRayBossVisibility, 
							entity);

						bool bIsVisible = !TR_DidHit(hTrace);
						int iTraceHitEntity = TR_GetEntityIndex(hTrace);
						delete hTrace;

						if (!bIsVisible && iTraceHitEntity == client) bIsVisible = true;
	
						if (bIsVisible)
						{
							float flDistance = GetVectorSquareMagnitude(flEntPos, flTargetPos);
							if (flDistance <= SquareFloat(flRadius))
							{
								SDKHooks_TakeDamage(client, entity, entity, NPCChaserGetAttackProjectileDamage(iBossIndex, attackIndex, difficulty), DMG_BLAST);
								if(TF2_IsPlayerInCondition(client, TFCond_Gas))
								{
									TF2_IgnitePlayer(client, client);
									TF2_RemoveCondition(client, TFCond_Gas);
								}
								if ((ProjectileGetFlags(entity) & PROJ_FIREBALL_ATTACK))
								{
									TF2_IgnitePlayer(client, client);
								}
								else if ((ProjectileGetFlags(entity) & PROJ_ICEBALL_ATTACK))
								{
									EmitSoundToClient(client, ICEBALL_IMPACT, _, MUSIC_CHAN);
									TF2_StunPlayer(client, NPCChaserGetAttackProjectileIceSlowdownDuration(iBossIndex, attackIndex, difficulty), NPCChaserGetAttackProjectileIceSlowdownPercent(iBossIndex, attackIndex, difficulty), TF_STUNFLAG_SLOWDOWN, client);
								}
							}
						}
					}
					RemoveEntity(entity);
				}
			}
		}
	}
	
	return Plugin_Handled;
}

public Action Hook_ProjectileTouch(int entity, int iOther)
{
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_ICEBALL, PROJ_ICEBALL_ATTACK:
		{
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					EmitSoundToAll(g_sSlenderFireballExplodeSound[iBossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "spell_batball_impact_blue");
			}
		}
		case PROJ_FIREBALL, PROJ_FIREBALL_ATTACK:
		{
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					EmitSoundToAll(g_sSlenderFireballExplodeSound[iBossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "bombinomicon_burningdebris");
			}
		}
	}
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_BASEBALL:
		{
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(iOther, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			if(iOther > 0 && iOther <= MaxClients)
			{
				int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
				if(slender != INVALID_ENT_REFERENCE)
				{
					int iBossIndex = NPCGetFromEntIndex(slender);
					int difficulty = GetLocalGlobalDifficulty(iBossIndex);
					SDKHooks_TakeDamage(iOther, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, difficulty), 1048576);
					if(TF2_IsPlayerInCondition(iOther, TFCond_Gas))
					{
						TF2_IgnitePlayer(iOther, iOther);
						TF2_RemoveCondition(iOther, TFCond_Gas);
					}
					RemoveEntity(iOther);
				}
			}
		}
		case PROJ_MANGLER, PROJ_FIREBALL, PROJ_ICEBALL:
		{
			float flEntPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			flEntPos[2] += 10.0;
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					int difficulty = GetLocalGlobalDifficulty(iBossIndex);
					bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
					float flRadius = NPCChaserGetProjectileRadius(iBossIndex, difficulty);
					float flFallOff = NPCChaserGetProjectileRadius(iBossIndex, difficulty)/2.0;
					for (int client = 1; client <= MaxClients; client++)
					{
						if (!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client)) continue;

						if (!bAttackEliminated && g_bPlayerEliminated[client]) continue;

						float flTargetPos[3];
						GetClientEyePosition(client, flTargetPos);

						Handle hTrace = TR_TraceRayFilterEx(flEntPos, 
							flTargetPos, 
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, 
							RayType_EndPoint, 
							TraceRayBossVisibility, 
							entity);

						bool bIsVisible = !TR_DidHit(hTrace);
						int iTraceHitEntity = TR_GetEntityIndex(hTrace);
						delete hTrace;

						if (!bIsVisible && iTraceHitEntity == client) bIsVisible = true;
	
						if (bIsVisible)
						{
							float flDistance = GetVectorSquareMagnitude(flEntPos, flTargetPos);
							if (flDistance <= SquareFloat(flRadius))
							{
								float flFinalDamage;
								if (flDistance <= SquareFloat(flFallOff))
								{
									flFinalDamage = NPCChaserGetProjectileDamage(iBossIndex, difficulty);
								}
								else
								{
									float flMultiplier = (1.0 - ((flDistance - SquareFloat(flFallOff)) / (SquareFloat(flRadius) - SquareFloat(flFallOff))));
									flFinalDamage = flMultiplier * NPCChaserGetProjectileDamage(iBossIndex, difficulty);
								}
								if ((ProjectileGetFlags(entity) & PROJ_MANGLER)) SDKHooks_TakeDamage(client, entity, entity, flFinalDamage, DMG_BLAST);
								else SDKHooks_TakeDamage(client, entity, entity, NPCChaserGetProjectileDamage(iBossIndex, difficulty), DMG_BLAST);
								if(TF2_IsPlayerInCondition(client, TFCond_Gas))
								{
									TF2_IgnitePlayer(client, client);
									TF2_RemoveCondition(client, TFCond_Gas);
								}
								if ((ProjectileGetFlags(entity) & PROJ_FIREBALL))
								{
									TF2_IgnitePlayer(client, client);
								}
								else if ((ProjectileGetFlags(entity) & PROJ_ICEBALL))
								{
									EmitSoundToClient(client, ICEBALL_IMPACT, _, MUSIC_CHAN);
									TF2_StunPlayer(client, NPCChaserGetIceballSlowdownDuration(iBossIndex, difficulty), NPCChaserGetIceballSlowdownPercent(iBossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, client);
								}
							}
						}
					}
					if ((ProjectileGetFlags(entity) & PROJ_MANGLER))
					{
						int iRandomSound = GetRandomInt(0, 2);
						switch (iRandomSound)
						{
							case 0: EmitSoundToAll(MANGLER_EXPLODE1, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							case 1: EmitSoundToAll(MANGLER_EXPLODE2, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							case 2: EmitSoundToAll(MANGLER_EXPLODE3, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
						}
					}
					RemoveEntity(entity);
				}
			}
		}
	}
	
	return Plugin_Handled;
}

public Action Hook_ProjectileTransmit(int ent, int other)
{
	if (!g_bEnabled) return Plugin_Continue;

	return Plugin_Handled;
}
