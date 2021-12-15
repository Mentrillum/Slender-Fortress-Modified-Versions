#if defined _sf2_npc_chaser_projectiles_included
 #endinput
#endif
#define _sf2_npc_chaser_projectiles_included

static char sGestureShootAnim[PLATFORM_MAX_PATH];
static char sBaseballModel[PLATFORM_MAX_PATH];

//static float g_flProjectileSpeed[2049];
//static float g_flProjectileDamage[2049];
//static float g_flProjectileRadius[2049];
//static float g_flProjectileIceSlowPercent[2049];
//static float g_flProjectileIceSlowDuration[2049];
//static float g_flOriginalProjectilePos[2049][3];
//static int g_iProjectileType[2049];
//static int g_iProjectileRotateState[2049]; // 0 = 0 degrees, 1 = 1-180 degrees, 2 = 181-360 degrees
//static Handle g_hProjectileTimer[2049];

/*public Action Timer_ProjectileThink(Handle timer, any entref)
{
	int iProjectile = EntRefToEntIndex(entref);
	if (!iProjectile || iProjectile == INVALID_ENT_REFERENCE) return Plugin_Stop;

	if (timer != g_hProjectileTimer[iProjectile]) return Plugin_Stop;

	float flPos[3], flAng[3], flNewPos[3];
	GetEntPropVector(iProjectile, Prop_Data, "m_vecAbsOrigin", flPos);
	GetEntPropVector(iProjectile, Prop_Data, "m_angAbsRotation", flAng);

	flNewPos[0] = flPos[0];
	flNewPos[1] = flPos[1];
	flNewPos[2] = flPos[2];

	float flSpeed = (g_flProjectileSpeed[iProjectile] - 64.0) / 54.0;
	AddVectors(g_flOriginalProjectilePos[iProjectile], flNewPos, flNewPos);
	flNewPos[0] += g_flOriginalProjectilePos[iProjectile][0];
	flNewPos[1] += g_flOriginalProjectilePos[iProjectile][1];
	switch (g_iProjectileRotateState[iProjectile])
	{
		case 0: flNewPos[2] = g_flOriginalProjectilePos[iProjectile][2];
		case 1: flNewPos[2] += g_flOriginalProjectilePos[iProjectile][2]/flAng[0];
		case 2: flNewPos[2] -= g_flOriginalProjectilePos[iProjectile][2]/flAng[0];
	}

	TeleportEntity(iProjectile, flNewPos, flAng, NULL_VECTOR);

	return Plugin_Continue;
}*/

public int NPCChaserProjectileShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, float flMyPos[3])
{
	if (g_bRestartSessionEnabled) return -1;
	
	int iProjectileType = NPCChaserGetProjectileType(iBossIndex);
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	int iProjectileEnt;
	float flShootDist = GetVectorSquareMagnitude(g_flSlenderGoalPos[iBossIndex], flMyPos);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	float flNonRocketScaleMins[3], flNonRocketScaleMaxs[3];
	flNonRocketScaleMins[0] = -100.0;
	flNonRocketScaleMins[1] = -100.0;
	flNonRocketScaleMins[2] = -100.0;
	flNonRocketScaleMaxs[0] = 100.0;
	flNonRocketScaleMaxs[1] = 100.0;
	flNonRocketScaleMaxs[2] = 100.0;
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);
	switch (iProjectileType)
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
	
	int iRandomPosMin = GetProfileNum(sProfile, "projectile_pos_number_min", 1);
	int iRandomPosMax = GetProfileNum(sProfile, "projectile_pos_number_max", 1);
	
	if (iRandomPosMin == 1 && iRandomPosMax == 1)
	{
		g_hConfig.GetVector("projectile_pos_offset", flTempEffectPos);
	}
	else
	{
		int iRandomProjectilePos = GetRandomInt(iRandomPosMin, iRandomPosMax);
		char sKeyName[PLATFORM_MAX_PATH];
		FormatEx(sKeyName, sizeof(sKeyName), "projectile_pos_offset_%i", iRandomProjectilePos);
		g_hConfig.GetVector(sKeyName, flTempEffectPos);
	}

	VectorTransform(flTempEffectPos, flBasePos, flBaseAng, flTempEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float vecSpread = NPCChaserGetProjectileDeviation(iBossIndex, iDifficulty);

	int iTeam = 3;
	int iTeamNon = 5;

	float flMin = NPCChaserGetProjectileCooldownMin(iBossIndex, iDifficulty);
	float flMax = NPCChaserGetProjectileCooldownMax(iBossIndex, iDifficulty);
	
	for (int i = 0; i < NPCChaserGetProjectileCount(iBossIndex, iDifficulty); i++)
	{
		if (NPCChaserGetProjectileCount(iBossIndex, iDifficulty) != 1)
		{
			flEffectPos[0] = flTempEffectPos[0] + GetRandomFloat(-vecSpread, vecSpread);
			flEffectPos[1] = flTempEffectPos[1] + GetRandomFloat(-vecSpread, vecSpread);
			flEffectPos[2] = flTempEffectPos[2] + GetRandomFloat(-vecSpread, vecSpread);
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

		switch(iProjectileType)
		{
			case SF2BossProjectileType_Fireball:		
			{
				sProjectileName = "tf_projectile_rocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					AttachParticle(iProjectileEnt, "spell_fireball_small_red");

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);
					ProjectileSetFlags(iProjectileEnt, PROJ_FIREBALL);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Iceball:
			{
				sProjectileName = "tf_projectile_rocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					AttachParticle(iProjectileEnt, "spell_fireball_small_blue");

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);
					ProjectileSetFlags(iProjectileEnt, PROJ_ICEBALL);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderFireballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Rocket:
			{
				sProjectileName = "tf_projectile_rocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					ProjectileSetFlags(iProjectileEnt, PROJ_ROCKET);

					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			/*case SF2BossProjectileType_Rocket:
			{
				sProjectileName = "prop_dynamic_override";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					g_flProjectileSpeed[iProjectileEnt] = NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					//if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					//SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					g_hProjectileTimer[iProjectileEnt] = CreateTimer(BOSS_THINKRATE, Timer_ProjectileThink, EntIndexToEntRef(iProjectileEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
					ProjectileSetFlags(iProjectileEnt, PROJ_ROCKET);
					SetEntityModel(iProjectileEnt, ROCKET_MODEL);

					//SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);

					GetEntPropVector(iProjectileEnt, Prop_Data, "m_vecOrigin", g_flOriginalProjectilePos[iProjectileEnt]);
					g_flOriginalProjectilePos[iProjectileEnt][0] /= (g_flProjectileSpeed[iProjectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[iProjectileEnt][1] /= (g_flProjectileSpeed[iProjectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[iProjectileEnt][2] /= (g_flProjectileSpeed[iProjectileEnt] - 64.0) / 54.0;
					PrintToChatAll("%f", flShootAng[0]);
					if (flShootAng[0] == 0.0  || flShootAng[0] == 180.0)
						g_iProjectileRotateState[iProjectileEnt] = 0;
					else if (flShootAng[0] > 0.0 && flShootAng[0] < 180.0)
						g_iProjectileRotateState[iProjectileEnt] = 1;
					else if (flShootAng[0] > 180.0)
						g_iProjectileRotateState[iProjectileEnt] = 2;

					CreateTimer(1.0, Timer_KillEntity, EntIndexToEntRef(iProjectileEnt), TIMER_FLAG_NO_MAPCHANGE);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderRocketShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}*/
			case SF2BossProjectileType_Grenade:
			{
				sProjectileName = "tf_projectile_pipe";
				if (flShootDist <= SquareFloat(2250.0))
				{
					iProjectileEnt = CreateEntityByName(sProjectileName);
					if (iProjectileEnt != -1)
					{
						float flVelocity[3], flBufferProj[3];

						GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

						flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
						flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
						flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
						
						SetEntProp(iProjectileEnt, Prop_Data, "m_iHealth", 1);
						SetEntProp(iProjectileEnt, Prop_Data, "m_iMaxHealth", 1);
						TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, NULL_VECTOR);
						DispatchSpawn(iProjectileEnt);
						if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
						SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
						SetEntProp(iProjectileEnt,    Prop_Send, "m_nSkin",     1, 1);
						SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						SetEntPropFloat(iProjectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetProjectileRadius(iBossIndex, iDifficulty));
						SetEntPropFloat(iProjectileEnt, Prop_Send, "m_flDamage",  NPCChaserGetProjectileDamage(iBossIndex, iDifficulty));
						TeleportEntity(iProjectileEnt, NULL_VECTOR, NULL_VECTOR, flVelocity);
						ProjectileSetFlags(iProjectileEnt, PROJ_GRENADE);
						g_bGrenadeTouchGround[iProjectileEnt] = false;

						SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);

						if(NPCChaserUseShootGesture(iBossIndex))
						{
							GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

							CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
						}

						if (i == 0) EmitSoundToAll(g_sSlenderGrenadeShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					}
				}
			}
			case SF2BossProjectileType_SentryRocket:
			{
				sProjectileName = "tf_projectile_sentryrocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_SentryRocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), true); // set damage
					ProjectileSetFlags(iProjectileEnt, PROJ_SENTRYROCKET);

					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
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
					iProjectileEnt = CreateEntityByName(sProjectileName);
					if (iProjectileEnt != -1)
					{
						float flVelocity[3], flBufferProj[3];

						GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

						flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
						flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
						flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);

						if (NPCChaserHasCriticalRockets(iBossIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCrits", 1, 1);
						SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flDamage", NPCChaserGetProjectileDamage(iBossIndex, iDifficulty));
						SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMin", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
						SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flSpeedMax", NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty));
						SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						ProjectileSetFlags(iProjectileEnt, PROJ_ARROW);
						TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
						DispatchSpawn(iProjectileEnt);
						DispatchKeyValueVector(iProjectileEnt, "origin", flEffectPos);
						DispatchKeyValueVector(iProjectileEnt, "angles", flShootAng);
						DispatchKeyValue(iProjectileEnt, "WeaponType", "2");

						AcceptEntityInput(iProjectileEnt, "FireOnce");

						if(NPCChaserUseShootGesture(iBossIndex))
						{
							GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

							CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
						}

						CreateTimer(5.0, Timer_KillEntity, EntIndexToEntRef(iProjectileEnt), TIMER_FLAG_NO_MAPCHANGE);
						if (i == 0) EmitSoundToAll(g_sSlenderArrowShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					}
				}
			}
			case SF2BossProjectileType_Mangler:
			{
				sProjectileName = "tf_projectile_rocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					AttachParticle(iProjectileEnt, "drg_cow_rockettrail_normal_blue");

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(iProjectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", view_as<float>( { -15.0, -15.0, -15.0 } ));
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", view_as<float>( { 15.0, 15.0, 15.0 } ));
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMinsPreScaled", view_as<float>( { -15.0, -15.0, -15.0 } ));
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxsPreScaled", view_as<float>( { 15.0, 15.0, 15.0 } ));
					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);
					ProjectileSetFlags(iProjectileEnt, PROJ_MANGLER);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderManglerShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
			case SF2BossProjectileType_Baseball:
			{
				sProjectileName = "tf_projectile_stun_ball";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetProjectileSpeed(iBossIndex, iDifficulty);
					GetProfileString(sSlenderProfile, "baseball_model", sBaseballModel, sizeof(sBaseballModel));
					if (sBaseballModel[0] == '\0')
					{
						sBaseballModel = BASEBALL_MODEL;
					}

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hThrower", slender);
					SetEntityModel(iProjectileEnt, sBaseballModel);
					ProjectileSetFlags(iProjectileEnt, PROJ_BASEBALL);

					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);

					if(NPCChaserUseShootGesture(iBossIndex))
					{
						GetProfileString(sSlenderProfile, "gesture_shootprojectile", sGestureShootAnim, sizeof(sGestureShootAnim));

						CBaseAnimating_PlayGesture(slender, sGestureShootAnim);
					}

					if (i == 0) EmitSoundToAll(g_sSlenderBaseballShootSound[iBossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_flNPCProjectileCooldown[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
				}
			}
		}
	}

	return iProjectileEnt;
}

public int NPCChaserProjectileAttackShoot(int iBossIndex, int slender, int iTarget, const char[] sSlenderProfile, const char[] sSectionName)
{
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	int iProjectileType = NPCChaserGetAttackProjectileType(iBossIndex, iAttackIndex);
	int iProjectileEnt;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	char sProjectileName[45];
	float flClientPos[3];
	float flSlenderPosition[3];
	float flNonRocketScaleMins[3], flNonRocketScaleMaxs[3];
	flNonRocketScaleMins[0] = -100.0;
	flNonRocketScaleMins[1] = -100.0;
	flNonRocketScaleMins[2] = -100.0;
	flNonRocketScaleMaxs[0] = 100.0;
	flNonRocketScaleMaxs[1] = 100.0;
	flNonRocketScaleMaxs[2] = 100.0;
	NPCGetEyePosition(iBossIndex, flSlenderPosition);
	GetClientEyePosition(iTarget, flClientPos);
	flClientPos[2] -= 25.0;

	float flBasePos[3], flBaseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBasePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flBaseAng);

	float flEffectPos[3], flTempEffectPos[3];
	float flEffectAng[3] = {0.0, 0.0, 0.0};
	
	GetProfileAttackVector(sSlenderProfile, "attack_projectile_offset", flTempEffectPos, view_as<float>({0.0, 0.0, 0.0}), iAttackIndex+1);
	VectorTransform(flTempEffectPos, flBasePos, flBaseAng, flTempEffectPos);
	AddVectors(flEffectAng, flBaseAng, flEffectAng);

	float vecSpread = NPCChaserGetAttackProjectileDeviation(iBossIndex, iAttackIndex, iDifficulty);

	int iTeam = 3;
	int iTeamNon = 5;
	for (int i = 0; i < NPCChaserGetAttackProjectileCount(iBossIndex, iAttackIndex, iDifficulty); i++)
	{
		if (NPCChaserGetAttackProjectileCount(iBossIndex, iAttackIndex, iDifficulty) != 1)
		{
			flEffectPos[0] = flTempEffectPos[0] + GetRandomFloat(-vecSpread, vecSpread);
			flEffectPos[1] = flTempEffectPos[1] + GetRandomFloat(-vecSpread, vecSpread);
			flEffectPos[2] = flTempEffectPos[2] + GetRandomFloat(-vecSpread, vecSpread);
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

		switch(iProjectileType)
		{
			case 0:		
			{
				sProjectileName = "tf_projectile_rocket";
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					AttachParticle(iProjectileEnt, "spell_fireball_small_red");

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);
					ProjectileSetFlags(iProjectileEnt, PROJ_FIREBALL_ATTACK);

					
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
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserGetAttackProjectileCrits(iBossIndex, iAttackIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty), true); // set damage
					ProjectileSetFlags(iProjectileEnt, PROJ_ROCKET);
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);

					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeam, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);

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
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					AttachParticle(iProjectileEnt, "spell_fireball_small_blue");

					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMins", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxs", flNonRocketScaleMaxs);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMinsPreScaled", flNonRocketScaleMins);
					SetEntPropVector(iProjectileEnt, Prop_Send, "m_vecMaxsPreScaled", flNonRocketScaleMaxs);
					SetEntityRenderMode(iProjectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(iProjectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(iProjectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);

					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     iTeamNon, 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, flVelocity);
					DispatchSpawn(iProjectileEnt);
					ProjectileSetFlags(iProjectileEnt, PROJ_ICEBALL_ATTACK);

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
				iProjectileEnt = CreateEntityByName(sProjectileName);
				if (iProjectileEnt != -1)
				{
					float flVelocity[3], flBufferProj[3];

					GetAngleVectors(flShootAng, flBufferProj, NULL_VECTOR, NULL_VECTOR);

					flVelocity[0] = flBufferProj[0]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[1] = flBufferProj[1]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
					flVelocity[2] = flBufferProj[2]*NPCChaserGetAttackProjectileSpeed(iBossIndex, iAttackIndex, iDifficulty);
						
					SetEntProp(iProjectileEnt, Prop_Data, "m_iHealth", 1);
					SetEntProp(iProjectileEnt, Prop_Data, "m_iMaxHealth", 1);
					TeleportEntity(iProjectileEnt, flEffectPos, flShootAng, NULL_VECTOR);
					DispatchSpawn(iProjectileEnt);
					if (NPCChaserGetAttackProjectileCrits(iBossIndex, iAttackIndex)) SetEntProp(iProjectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntProp(iProjectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
					SetEntProp(iProjectileEnt,    Prop_Send, "m_nSkin",     1, 1);
					SetEntPropEnt(iProjectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(iProjectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty));
					SetEntPropFloat(iProjectileEnt, Prop_Send, "m_flDamage",  NPCChaserGetAttackProjectileRadius(iBossIndex, iAttackIndex, iDifficulty));
					TeleportEntity(iProjectileEnt, NULL_VECTOR, NULL_VECTOR, flVelocity);
					ProjectileSetFlags(iProjectileEnt, PROJ_GRENADE);
					g_bGrenadeTouchGround[iProjectileEnt] = false;

					SDKHook(iProjectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);

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

	return iProjectileEnt;
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
				CreateGeneralParticle(entity, "spell_batball_impact_blue", 0.1);
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
				CreateGeneralParticle(entity, "bombinomicon_burningdebris", 0.1);
			}
		}
		case PROJ_ROCKET, PROJ_GRENADE:
		{
			float flEntPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
					int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
					if (!(ProjectileGetFlags(entity) & PROJ_GRENADE))
					{
						float flRadius = NPCChaserGetAttackProjectileRadius(iBossIndex, iAttackIndex, iDifficulty);
						float flFallOff = NPCChaserGetAttackProjectileRadius(iBossIndex, iAttackIndex, iDifficulty)/2.0;
						for (int iClient = 1; iClient <= MaxClients; iClient++)
						{
							if(IsValidClient(iClient) && IsPlayerAlive(iClient))
							{
								float flPlayerPosition[3]; 
								GetClientEyePosition(iClient, flPlayerPosition);
								float flDistance = GetVectorSquareMagnitude(flEntPos, flPlayerPosition);
								if (flDistance <= SquareFloat(flRadius))
								{
									float flFinalDamage;
									if (flDistance <= SquareFloat(flFallOff))
									{
										flFinalDamage = NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty);
									}
									else
									{
										float flMultiplier = (1.0 - ((flDistance - SquareFloat(flFallOff)) / (SquareFloat(flRadius) - SquareFloat(flFallOff))));
										flFinalDamage = flMultiplier * NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty);
									}
									if (NPCChaserHasCriticalRockets(iBossIndex) && (ProjectileGetFlags(entity) & PROJ_ROCKET)) SDKHooks_TakeDamage(iClient, slender, slender, flFinalDamage*3.0, DMG_BLAST|DMG_ACID);
									else SDKHooks_TakeDamage(iClient, slender, slender, flFinalDamage, DMG_BLAST);
								}
							}
						}
					}
					else
					{
						if (iOther > 0 && iOther <= MaxClients && !g_bGrenadeTouchGround[entity])
						{	
							float flRadius = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty);
							float flFallOff = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty)/2.0;
							for (int iClient = 1; iClient <= MaxClients; iClient++)
							{
								if(IsValidClient(iClient) && IsPlayerAlive(iClient))
								{
									float flPlayerPosition[3]; 
									GetClientEyePosition(iClient, flPlayerPosition);
									float flDistance = GetVectorSquareMagnitude(flEntPos, flPlayerPosition);
									if (flDistance <= SquareFloat(flRadius))
									{
										float flFinalDamage;
										if (flDistance <= SquareFloat(flFallOff))
										{
											flFinalDamage = NPCChaserGetProjectileDamage(iBossIndex, iDifficulty);
										}
										else
										{
											float flMultiplier = (1.0 - ((flDistance - SquareFloat(flFallOff)) / (SquareFloat(flRadius) - SquareFloat(flFallOff))));
											flFinalDamage = flMultiplier * NPCChaserGetProjectileDamage(iBossIndex, iDifficulty);
										}
										if (NPCChaserGetAttackProjectileCrits(iBossIndex, iAttackIndex)) SDKHooks_TakeDamage(iClient, slender, slender, flFinalDamage*3.0, DMG_BLAST|DMG_ACID);
										else SDKHooks_TakeDamage(iClient, slender, slender, flFinalDamage, DMG_BLAST);
									}
								}
							}
						}
						else g_bGrenadeTouchGround[entity] = true;
					}
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
		case PROJ_ICEBALL:
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
				CreateGeneralParticle(entity, "spell_batball_impact_blue", 0.1);
			}
		}
		case PROJ_FIREBALL:
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
				CreateGeneralParticle(entity, "bombinomicon_burningdebris", 0.1);
			}
		}
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
					int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
					SDKHooks_TakeDamage(iOther, slender, slender, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), 1048576);
					RemoveEntity(iOther);
				}
			}
		}
		case PROJ_MANGLER, PROJ_GRENADE, PROJ_ROCKET, PROJ_SENTRYROCKET:
		{
			float flEntPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", flEntPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if(slender != INVALID_ENT_REFERENCE)
			{
				int iBossIndex = NPCGetFromEntIndex(slender);
				if (iBossIndex != -1)
				{
					int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
					bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
					Handle hTrace = null;
					if (!(ProjectileGetFlags(entity) & PROJ_FIREBALL) && !(ProjectileGetFlags(entity) & PROJ_ICEBALL))
					{
						if (!(ProjectileGetFlags(entity) & PROJ_GRENADE))
						{
							float flRadius = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty);
							float flFallOff = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty)/2.0;
							for (int iClient = 1; iClient <= MaxClients; iClient++)
							{
								if (!IsValidClient(iClient) || !IsClientInGame(iClient) || !IsPlayerAlive(iClient) || IsClientInGhostMode(iClient)) continue;

								if (!bAttackEliminated && g_bPlayerEliminated[iClient]) continue;

								float flTargetPos[3];
								GetClientEyePosition(iClient, flTargetPos);

								hTrace = TR_TraceRayFilterEx(flEntPos,
									flTargetPos,
									MASK_NPCSOLID,
									RayType_EndPoint,
									TraceRayDontHitAnyEntity,
									entity);
										
								bool bTraceDidHit = TR_DidHit(hTrace);
								int iTraceHitEntity = TR_GetEntityIndex(hTrace);
								delete hTrace;
										
								if (bTraceDidHit && iTraceHitEntity != iClient)
								{
									float flTargetMins[3], flTargetMaxs[3];
									GetEntPropVector(iClient, Prop_Send, "m_vecMins", flTargetMins);
									GetEntPropVector(iClient, Prop_Send, "m_vecMaxs", flTargetMaxs);
									GetClientAbsOrigin(iClient, flTargetPos);
									for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);

									hTrace = TR_TraceRayFilterEx(flEntPos,
										flTargetPos,
										MASK_NPCSOLID,
										RayType_EndPoint,
										TraceRayDontHitAnyEntity,
										entity);
												
									bTraceDidHit = TR_DidHit(hTrace);
									iTraceHitEntity = TR_GetEntityIndex(hTrace);
									delete hTrace;
								}
										
								if (!bTraceDidHit || iTraceHitEntity == iClient)
								{
									float flDistance = GetVectorSquareMagnitude(flEntPos, flTargetPos);
									if (flDistance <= SquareFloat(flRadius))
									{
										float flFinalDamage;
										if (flDistance <= SquareFloat(flFallOff))
										{
											flFinalDamage = NPCChaserGetProjectileDamage(iBossIndex, iDifficulty);
										}
										else
										{
											float flMultiplier = (1.0 - ((flDistance - SquareFloat(flFallOff)) / (SquareFloat(flRadius) - SquareFloat(flFallOff))));
											flFinalDamage = flMultiplier * NPCChaserGetProjectileDamage(iBossIndex, iDifficulty);
										}
										if (NPCChaserHasCriticalRockets(iBossIndex) && (ProjectileGetFlags(entity) & PROJ_ROCKET)) SDKHooks_TakeDamage(iClient, entity, entity, flFinalDamage, DMG_SHOCK|DMG_ALWAYSGIB|DMG_ACID);
										else SDKHooks_TakeDamage(iClient, entity, entity, flFinalDamage, DMG_SHOCK|DMG_ALWAYSGIB);
									}
								}
							}
							if (!(ProjectileGetFlags(entity) & PROJ_MANGLER))
							{
								int iRandomSound = GetRandomInt(0, 2);
								switch (iRandomSound)
								{
									case 0: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION1, entity, SNDCHAN_AUTO, 50);
									case 1: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION2, entity, SNDCHAN_AUTO, 50);
									case 2: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION3, entity, SNDCHAN_AUTO, 50);
								}
								CreateGeneralParticle(entity, "ExplosionCore_MidAir", 0.1);
							}
							else
							{
								int iRandomSound = GetRandomInt(0, 2);
								switch (iRandomSound)
								{
									case 0: EmitSoundToAll(MANGLER_EXPLODE1, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
									case 1: EmitSoundToAll(MANGLER_EXPLODE2, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
									case 2: EmitSoundToAll(MANGLER_EXPLODE3, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
								}
								CreateGeneralParticle(entity, "drg_cow_explosioncore_normal_blue", 0.1);
							}
							RemoveEntity(entity);
						}
						else
						{
							if (iOther > 0 && iOther <= MaxClients && !g_bGrenadeTouchGround[entity])
							{	
								float flRadius = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty);
								float flFallOff = NPCChaserGetProjectileRadius(iBossIndex, iDifficulty)/2.0;
								for (int iClient = 1; iClient <= MaxClients; iClient++)
								{
									if (!IsValidClient(iClient) || !IsClientInGame(iClient) || !IsPlayerAlive(iClient) || IsClientInGhostMode(iClient)) continue;

									if (!bAttackEliminated && g_bPlayerEliminated[iClient]) continue;

									float flTargetPos[3];
									GetClientEyePosition(iClient, flTargetPos);

									hTrace = TR_TraceRayFilterEx(flEntPos,
										flTargetPos,
										MASK_NPCSOLID,
										RayType_EndPoint,
										TraceRayDontHitAnyEntity,
										entity);
											
									bool bTraceDidHit = TR_DidHit(hTrace);
									int iTraceHitEntity = TR_GetEntityIndex(hTrace);
									delete hTrace;
											
									if (bTraceDidHit && iTraceHitEntity != iClient)
									{
										float flTargetMins[3], flTargetMaxs[3];
										GetEntPropVector(iClient, Prop_Send, "m_vecMins", flTargetMins);
										GetEntPropVector(iClient, Prop_Send, "m_vecMaxs", flTargetMaxs);
										GetClientAbsOrigin(iClient, flTargetPos);
										for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);

										hTrace = TR_TraceRayFilterEx(flEntPos,
											flTargetPos,
											MASK_NPCSOLID,
											RayType_EndPoint,
											TraceRayDontHitAnyEntity,
											entity);
													
										bTraceDidHit = TR_DidHit(hTrace);
										iTraceHitEntity = TR_GetEntityIndex(hTrace);
										delete hTrace;
									}
											
									if (!bTraceDidHit || iTraceHitEntity == iClient)
									{
										float flDistance = GetVectorSquareMagnitude(flEntPos, flTargetPos);
										if (flDistance <= SquareFloat(flRadius))
										{
											float flFinalDamage;
											if (flDistance <= SquareFloat(flFallOff))
											{
												flFinalDamage = NPCChaserGetProjectileDamage(iBossIndex, iDifficulty);
											}
											else
											{
												float flMultiplier = (1.0 - ((flDistance - SquareFloat(flFallOff)) / (SquareFloat(flRadius) - SquareFloat(flFallOff))));
												flFinalDamage = NPCChaserGetProjectileDamage(iBossIndex, iDifficulty) * flMultiplier;
											}
											if (NPCChaserHasCriticalRockets(iBossIndex)) SDKHooks_TakeDamage(iClient, entity, entity, flFinalDamage, DMG_BLAST|DMG_ACID);
											else SDKHooks_TakeDamage(iClient, entity, entity, flFinalDamage, DMG_BLAST);
											int iRandomSound = GetRandomInt(0, 2);
											switch (iRandomSound)
											{
												case 0: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION1, entity, SNDCHAN_AUTO, 50);
												case 1: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION2, entity, SNDCHAN_AUTO, 50);
												case 2: EmitSoundToAll(EXPLOSIVEDANCE_EXPLOSION3, entity, SNDCHAN_AUTO, 50);
											}
											CreateGeneralParticle(entity, "ExplosionCore_MidAir", 0.1);
											RemoveEntity(entity);
										}
									}
								}
							}
							g_bGrenadeTouchGround[entity] = true;
						}
					}
					if (hTrace != null) delete hTrace;
				}
			}
		}
	}
	
	return Plugin_Handled;
}
