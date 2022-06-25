#if defined _sf2_npc_chaser_projectiles_included
 #endinput
#endif
#define _sf2_npc_chaser_projectiles_included

static char gestureShootAnim[PLATFORM_MAX_PATH];
static char baseballModel[PLATFORM_MAX_PATH];

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

public int NPCChaserProjectileShoot(int bossIndex, int slender, int target, const char[] slenderProfile, float myPos[3])
{
	if (g_RestartSessionEnabled)
	{
		return -1;
	}

	CBaseCombatCharacter combatChar = CBaseCombatCharacter(slender);

	int projectileType = NPCChaserGetProjectileType(bossIndex);
	int difficulty = GetLocalGlobalDifficulty(bossIndex);
	int projectileEnt;
	float shootDist = GetVectorSquareMagnitude(g_SlenderGoalPos[bossIndex], myPos);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char projectileName[45];
	float clientPos[3];
	float slenderPosition[3];
	float nonRocketScaleMins[3], nonRocketScaleMaxs[3];
	nonRocketScaleMins[0] = -10.0;
	nonRocketScaleMins[1] = -10.0;
	nonRocketScaleMins[2] = -10.0;
	nonRocketScaleMaxs[0] = 10.0;
	nonRocketScaleMaxs[1] = 10.0;
	nonRocketScaleMaxs[2] = 10.0;
	NPCGetEyePosition(bossIndex, slenderPosition);
	GetClientEyePosition(target, clientPos);
	switch (projectileType)
	{
		case SF2BossProjectileType_Grenade:
		{
			if (shootDist < SquareFloat(600.0))
			{
				clientPos[2] += 0.0;
			}
			else if (shootDist > SquareFloat(600.0) && shootDist < SquareFloat(1000.0))
			{
				clientPos[2] += 60.0;
			}
			else if (shootDist > SquareFloat(1000.0))
			{
				clientPos[2] += 120.0;
			}
		}
		case SF2BossProjectileType_Arrow, SF2BossProjectileType_Baseball:
		{
			clientPos[2] -= 0.0;
		}
		default:
		{
			clientPos[2] -= 25.0;
		}
	}

	float basePos[3], baseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);

	float effectPos[3], tempEffectPos[3];
	float effectAng[3] = {0.0, 0.0, 0.0};

	int randomPosMin = GetProfileNum(profile, "projectile_pos_number_min", 1);
	int randomPosMax = GetProfileNum(profile, "projectile_pos_number_max", 1);

	if (randomPosMin == 1 && randomPosMax == 1)
	{
		g_Config.GetVector("projectile_pos_offset", tempEffectPos);
	}
	else
	{
		int randomProjectilePos = GetRandomInt(randomPosMin, randomPosMax);
		char keyName[PLATFORM_MAX_PATH];
		FormatEx(keyName, sizeof(keyName), "projectile_pos_offset_%i", randomProjectilePos);
		g_Config.GetVector(keyName, tempEffectPos);
	}

	VectorTransform(tempEffectPos, basePos, baseAng, tempEffectPos);
	AddVectors(effectAng, baseAng, effectAng);

	float spread = NPCChaserGetProjectileDeviation(bossIndex, difficulty);

	int team = 3;
	int teamNon = 5;

	float min = NPCChaserGetProjectileCooldownMin(bossIndex, difficulty);
	float max = NPCChaserGetProjectileCooldownMax(bossIndex, difficulty);

	for (int i = 0; i < NPCChaserGetProjectileCount(bossIndex, difficulty); i++)
	{
		if (NPCChaserGetProjectileCount(bossIndex, difficulty) != 1)
		{
			effectPos[0] = tempEffectPos[0] + GetRandomFloat(-10.0, 10.0);
			effectPos[1] = tempEffectPos[1] + GetRandomFloat(-10.0, 10.0);
			effectPos[2] = tempEffectPos[2] + GetRandomFloat(-10.0, 10.0);
		}
		else
		{
			effectPos[0] = tempEffectPos[0];
			effectPos[1] = tempEffectPos[1];
			effectPos[2] = tempEffectPos[2];
		}
		float shootDirection[3], shootAng[3];
		SubtractVectors(clientPos, effectPos, shootDirection);
		if (spread != 0.0)
		{
			shootDirection[0] += GetRandomFloat(-spread, spread);
			shootDirection[1] += GetRandomFloat(-spread, spread);
			shootDirection[2] += GetRandomFloat(-spread, spread);
		}
		NormalizeVector(shootDirection, shootDirection);
		GetVectorAngles(shootDirection, shootAng);

		switch (projectileType)
		{
			case SF2BossProjectileType_Fireball:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					AttachParticle(projectileEnt, g_SlenderFireballTrail[bossIndex]);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", nonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", nonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     teamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_FIREBALL);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderFireballShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
			case SF2BossProjectileType_Iceball:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					AttachParticle(projectileEnt, g_SlenderIceballTrail[bossIndex]);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Data, "m_flModelScale", 1.0);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", nonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", nonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     teamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_ICEBALL);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderFireballShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
			case SF2BossProjectileType_Rocket:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(bossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(bossIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					SetEntityModel(projectileEnt, g_SlenderRocketModel[bossIndex]);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     team, 1);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderRocketShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
			/*case SF2BossProjectileType_Rocket:
			{
				projectileName = "prop_dynamic_override";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					g_projectileSpeed[projectileEnt] = NPCChaserGetProjectileSpeed(bossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					//if (NPCChaserHasCriticalRockets(bossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					//SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					g_hProjectileTimer[projectileEnt] = CreateTimer(BOSS_THINKRATE, Timer_ProjectileThink, EntIndexToEntRef(projectileEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					SetEntityModel(projectileEnt, ROCKET_MODEL);

					//SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     team, 1);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					GetEntPropVector(projectileEnt, Prop_Data, "m_vecOrigin", g_flOriginalProjectilePos[projectileEnt]);
					g_flOriginalProjectilePos[projectileEnt][0] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[projectileEnt][1] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					g_flOriginalProjectilePos[projectileEnt][2] /= (g_projectileSpeed[projectileEnt] - 64.0) / 54.0;
					PrintToChatAll("%f", shootAng[0]);
					if (shootAng[0] == 0.0  || shootAng[0] == 180.0)
						g_projectileRotateState[projectileEnt] = 0;
					else if (shootAng[0] > 0.0 && shootAng[0] < 180.0)
						g_projectileRotateState[projectileEnt] = 1;
					else if (shootAng[0] > 180.0)
						g_projectileRotateState[projectileEnt] = 2;

					CreateTimer(1.0, Timer_KillEntity, EntIndexToEntRef(projectileEnt), TIMER_FLAG_NO_MAPCHANGE);

					if (NPCChaserUseShootGesture(bossIndex))
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1) combatChar.AddGestureSequence(iSequence);
					}

					if (i == 0) EmitSoundToAll(g_SlenderRocketShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}*/
			case SF2BossProjectileType_Grenade:
			{
				projectileName = "tf_projectile_pipe";
				if (shootDist <= SquareFloat(1800.0))
				{
					projectileEnt = CreateEntityByName(projectileName);
					if (projectileEnt != -1)
					{
						float velocity[3], bufferProj[3];

						GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

						velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
						velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
						velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);

						TeleportEntity(projectileEnt, effectPos, shootAng, NULL_VECTOR);
						DispatchSpawn(projectileEnt);
						if (NPCChaserHasCriticalRockets(bossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
						SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
						SetEntProp(projectileEnt,    Prop_Send, "m_nSkin",     1, 1);
						SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						SetEntPropFloat(projectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetProjectileRadius(bossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Send, "m_flDamage",  NPCChaserGetProjectileDamage(bossIndex, difficulty));
						TeleportEntity(projectileEnt, NULL_VECTOR, NULL_VECTOR, velocity);
						SetEntDataFloat(projectileEnt, g_FullDamageData, NPCChaserGetProjectileDamage(bossIndex, difficulty));
						ProjectileSetFlags(projectileEnt, PROJ_GRENADE);

						if (NPCChaserUseShootGesture(bossIndex) && i == 0)
						{
							GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

							int iSequence = combatChar.LookupSequence(gestureShootAnim);
							if (iSequence != -1)
							{
								combatChar.AddGestureSequence(iSequence);
							}
						}

						if (i == 0)
						{
							EmitSoundToAll(g_SlenderGrenadeShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						}
						g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
					}
				}
			}
			case SF2BossProjectileType_SentryRocket:
			{
				projectileName = "tf_projectile_sentryrocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserHasCriticalRockets(bossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_SentryRocket", "m_iDeflected") + 4, NPCChaserGetProjectileDamage(bossIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_SENTRYROCKET);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     team, 1);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderSentryRocketShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
			case SF2BossProjectileType_Arrow:
			{
				projectileName = "tf_point_weapon_mimic";
				if (shootDist <= SquareFloat(1250.0))
				{
					projectileEnt = CreateEntityByName(projectileName);
					if (projectileEnt != -1)
					{
						float velocity[3], bufferProj[3];

						GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

						velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
						velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
						velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);

						if (NPCChaserHasCriticalRockets(bossIndex)) SetEntProp(projectileEnt,    Prop_Send, "m_bCrits", 1, 1);
						SetEntPropFloat(projectileEnt, Prop_Data, "m_flDamage", NPCChaserGetProjectileDamage(bossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Data, "m_flSpeedMin", NPCChaserGetProjectileSpeed(bossIndex, difficulty));
						SetEntPropFloat(projectileEnt, Prop_Data, "m_flSpeedMax", NPCChaserGetProjectileSpeed(bossIndex, difficulty));
						SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
						ProjectileSetFlags(projectileEnt, PROJ_ARROW);
						TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
						DispatchSpawn(projectileEnt);
						DispatchKeyValueVector(projectileEnt, "origin", effectPos);
						DispatchKeyValueVector(projectileEnt, "angles", shootAng);
						DispatchKeyValue(projectileEnt, "WeaponType", "2");

						AcceptEntityInput(projectileEnt, "FireOnce");

						if (NPCChaserUseShootGesture(bossIndex) && i == 0)
						{
							GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

							int iSequence = combatChar.LookupSequence(gestureShootAnim);
							if (iSequence != -1)
							{
								combatChar.AddGestureSequence(iSequence);
							}
						}

						CreateTimer(5.0, Timer_KillEntity, EntIndexToEntRef(projectileEnt), TIMER_FLAG_NO_MAPCHANGE);
						if (i == 0)
						{
							EmitSoundToAll(g_SlenderArrowShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
						}
						g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
					}
				}
			}
			case SF2BossProjectileType_Mangler:
			{
				projectileName = "tf_projectile_energy_ball";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntProp(projectileEnt, Prop_Send, "m_CollisionGroup", 4);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     5, 1);
					SetEntProp(projectileEnt, Prop_Data, "m_takedamage", 0);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", view_as<float>( { 3.0, 3.0, 3.0 } ));
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", view_as<float>( { 3.0, 3.0, 3.0 } ));
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					ProjectileSetFlags(projectileEnt, PROJ_MANGLER);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderManglerShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
			case SF2BossProjectileType_Baseball:
			{
				projectileName = "tf_projectile_stun_ball";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetProjectileSpeed(bossIndex, difficulty);
					GetProfileString(slenderProfile, "baseball_model", baseballModel, sizeof(baseballModel));
					if (baseballModel[0] == '\0')
					{
						baseballModel = BASEBALL_MODEL;
					}

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropEnt(projectileEnt, Prop_Send, "m_hThrower", slender);
					SetEntityModel(projectileEnt, baseballModel);
					ProjectileSetFlags(projectileEnt, PROJ_BASEBALL);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     team, 1);
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					if (NPCChaserUseShootGesture(bossIndex) && i == 0)
					{
						GetProfileString(slenderProfile, "gesture_shootprojectile", gestureShootAnim, sizeof(gestureShootAnim));

						int iSequence = combatChar.LookupSequence(gestureShootAnim);
						if (iSequence != -1)
						{
							combatChar.AddGestureSequence(iSequence);
						}
					}

					if (i == 0)
					{
						EmitSoundToAll(g_SlenderBaseballShootSound[bossIndex], slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
					}
					g_NpcProjectileCooldown[bossIndex] = GetGameTime() + GetRandomFloat(min, max);
				}
			}
		}
	}

	return projectileEnt;
}

public int NPCChaserProjectileAttackShoot(int bossIndex, int slender, int target, const char[] slenderProfile, const char[] sectionName)
{
	int attackIndex = NPCGetCurrentAttackIndex(bossIndex);
	int projectileType = NPCChaserGetAttackProjectileType(bossIndex, attackIndex);
	int projectileEnt;
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	char projectileName[45];
	float clientPos[3];
	float slenderPosition[3];
	float nonRocketScaleMins[3], nonRocketScaleMaxs[3];
	nonRocketScaleMins[0] = -10.0;
	nonRocketScaleMins[1] = -10.0;
	nonRocketScaleMins[2] = -10.0;
	nonRocketScaleMaxs[0] = 10.0;
	nonRocketScaleMaxs[1] = 10.0;
	nonRocketScaleMaxs[2] = 10.0;
	NPCGetEyePosition(bossIndex, slenderPosition);
	GetClientEyePosition(target, clientPos);
	clientPos[2] -= 25.0;

	float basePos[3], baseAng[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", basePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", baseAng);

	float effectPos[3], tempEffectPos[3];
	float effectAng[3] = {0.0, 0.0, 0.0};

	GetProfileAttackVector(slenderProfile, "attack_projectile_offset", tempEffectPos, view_as<float>({0.0, 0.0, 0.0}), attackIndex+1);
	VectorTransform(tempEffectPos, basePos, baseAng, tempEffectPos);
	AddVectors(effectAng, baseAng, effectAng);

	float spread = NPCChaserGetAttackProjectileDeviation(bossIndex, attackIndex, difficulty);

	int team = 3;
	int teamNon = 5;
	for (int i = 0; i < NPCChaserGetAttackProjectileCount(bossIndex, attackIndex, difficulty); i++)
	{
		if (NPCChaserGetAttackProjectileCount(bossIndex, attackIndex, difficulty) != 1)
		{
			effectPos[0] = tempEffectPos[0] + GetRandomFloat(-10.0, 10.0);
			effectPos[1] = tempEffectPos[1] + GetRandomFloat(-10.0, 10.0);
			effectPos[2] = tempEffectPos[2] + GetRandomFloat(-10.0, 10.0);
		}
		else
		{
			effectPos[0] = tempEffectPos[0];
			effectPos[1] = tempEffectPos[1];
			effectPos[2] = tempEffectPos[2];
		}

		float shootDirection[3], shootAng[3];
		SubtractVectors(clientPos, effectPos, shootDirection);
		if (spread != 0.0)
		{
			shootDirection[0] += GetRandomFloat(-spread, spread);
			shootDirection[1] += GetRandomFloat(-spread, spread);
			shootDirection[2] += GetRandomFloat(-spread, spread);
		}
		NormalizeVector(shootDirection, shootDirection);
		GetVectorAngles(shootDirection, shootAng);

		switch (projectileType)
		{
			case 0:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					char fireballTrail[PLATFORM_MAX_PATH];
					GetProfileAttackString(slenderProfile, "attack_fire_trail", fireballTrail, sizeof(fireballTrail), FIREBALL_TRAIL, attackIndex+1);
					AttachParticle(projectileEnt, fireballTrail);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", nonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", nonRocketScaleMaxs);
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     teamNon, 1);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_FIREBALL_ATTACK);
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);

					char path[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, sectionName, path, sizeof(path));

					if (path[0] != '\0')
					{
						char buffer[512];
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_volume");
						float volume = GetProfileFloat(slenderProfile, buffer, 1.0);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_channel");
						int channel = GetProfileNum(slenderProfile, buffer, SNDCHAN_WEAPON);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_level");
						int level = GetProfileNum(slenderProfile, buffer, SNDLEVEL_SCREAMING);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_pitch");
						int pitch = GetProfileNum(slenderProfile, buffer, 100);

						EmitSoundToAll(path, slender, channel, level, _, volume, pitch);
					}
				}
			}
			case 1:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];
					char rocketModel[PLATFORM_MAX_PATH];
					GetProfileAttackString(slenderProfile, "attack_rocket_model", rocketModel, sizeof(rocketModel), ROCKET_MODEL, attackIndex+1);

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					if (NPCChaserGetAttackProjectileCrits(bossIndex, attackIndex))
					{
						SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					}
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, NPCChaserGetAttackProjectileDamage(bossIndex, attackIndex, difficulty), true); // set damage
					ProjectileSetFlags(projectileEnt, PROJ_ROCKET);
					if (strcmp(rocketModel, ROCKET_MODEL, true) != 0)
					{
						int model;
						model = PrecacheModel(rocketModel, true);
						SetEntProp(projectileEnt, Prop_Send, "m_nModelIndexOverrides", model);
					}

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     team, 1);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);

					char path[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, sectionName, path, sizeof(path));

					if (path[0] != '\0' && i == 0)
					{
						char buffer[512];
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_volume");
						float volume = GetProfileFloat(slenderProfile, buffer, 1.0);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_channel");
						int channel = GetProfileNum(slenderProfile, buffer, SNDCHAN_WEAPON);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_level");
						int level = GetProfileNum(slenderProfile, buffer, SNDLEVEL_SCREAMING);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_pitch");
						int pitch = GetProfileNum(slenderProfile, buffer, 100);

						EmitSoundToAll(path, slender, channel, level, _, volume, pitch);
					}
				}
			}
			case 2:
			{
				projectileName = "tf_projectile_rocket";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					char fireballTrail[PLATFORM_MAX_PATH];
					GetProfileAttackString(slenderProfile, "attack_fire_iceball_trail", fireballTrail, sizeof(fireballTrail), ICEBALL_TRAIL, attackIndex+1);
					AttachParticle(projectileEnt, fireballTrail);

					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMins", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxs", nonRocketScaleMaxs);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMinsPreScaled", nonRocketScaleMins);
					SetEntPropVector(projectileEnt, Prop_Send, "m_vecMaxsPreScaled", nonRocketScaleMaxs);
					SetEntityRenderMode(projectileEnt, RENDER_TRANSCOLOR);
					SetEntityRenderColor(projectileEnt, 0, 0, 0, 0);
					SetEntDataFloat(projectileEnt, FindSendPropInfo("CTFProjectile_Rocket", "m_iDeflected") + 4, 0.1, true); // set damage to nothing
					SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileAttackTouch);
					SDKHook(projectileEnt, SDKHook_SetTransmit, Hook_ProjectileTransmit);

					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     teamNon, 1);
					TeleportEntity(projectileEnt, effectPos, shootAng, velocity);
					DispatchSpawn(projectileEnt);
					ProjectileSetFlags(projectileEnt, PROJ_ICEBALL_ATTACK);

					char path[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, sectionName, path, sizeof(path));

					if (path[0] != '\0' && i == 0)
					{
						char buffer[512];
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_volume");
						float volume = GetProfileFloat(slenderProfile, buffer, 1.0);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_channel");
						int channel = GetProfileNum(slenderProfile, buffer, SNDCHAN_WEAPON);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_level");
						int level = GetProfileNum(slenderProfile, buffer, SNDLEVEL_SCREAMING);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_pitch");
						int pitch = GetProfileNum(slenderProfile, buffer, 100);

						EmitSoundToAll(path, slender, channel, level, _, volume, pitch);
					}
				}
			}
			case 3:
			{
				projectileName = "tf_projectile_pipe";
				projectileEnt = CreateEntityByName(projectileName);
				if (projectileEnt != -1)
				{
					float velocity[3], bufferProj[3];

					GetAngleVectors(shootAng, bufferProj, NULL_VECTOR, NULL_VECTOR);

					velocity[0] = bufferProj[0]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[1] = bufferProj[1]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);
					velocity[2] = bufferProj[2]*NPCChaserGetAttackProjectileSpeed(bossIndex, attackIndex, difficulty);

					TeleportEntity(projectileEnt, effectPos, shootAng, NULL_VECTOR);
					DispatchSpawn(projectileEnt);
					if (NPCChaserGetAttackProjectileCrits(bossIndex, attackIndex))
					{
						SetEntProp(projectileEnt,    Prop_Send, "m_bCritical", 1, 1);
					}
					SetEntProp(projectileEnt,    Prop_Send, "m_iTeamNum",     3, 1);
					SetEntProp(projectileEnt,    Prop_Send, "m_nSkin",     1, 1);
					SetEntPropEnt(projectileEnt, Prop_Send, "m_hOwnerEntity", slender);
					SetEntPropFloat(projectileEnt, Prop_Send, "m_DmgRadius", NPCChaserGetAttackProjectileDamage(bossIndex, attackIndex, difficulty));
					SetEntPropFloat(projectileEnt, Prop_Send, "m_flDamage",  NPCChaserGetAttackProjectileRadius(bossIndex, attackIndex, difficulty));
					SetEntDataFloat(projectileEnt, g_FullDamageData, NPCChaserGetAttackProjectileDamage(bossIndex, attackIndex, difficulty));
					TeleportEntity(projectileEnt, NULL_VECTOR, NULL_VECTOR, velocity);
					ProjectileSetFlags(projectileEnt, PROJ_GRENADE);

					//SDKHook(projectileEnt, SDKHook_StartTouch, Hook_ProjectileTouch);

					char path[PLATFORM_MAX_PATH];
					GetRandomStringFromProfile(slenderProfile, sectionName, path, sizeof(path));

					if (path[0] != '\0' && i == 0)
					{
						char buffer[512];
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_volume");
						float volume = GetProfileFloat(slenderProfile, buffer, 1.0);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_channel");
						int channel = GetProfileNum(slenderProfile, buffer, SNDCHAN_WEAPON);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_level");
						int level = GetProfileNum(slenderProfile, buffer, SNDLEVEL_SCREAMING);
						strcopy(buffer, sizeof(buffer), sectionName);
						StrCat(buffer, sizeof(buffer), "_pitch");
						int pitch = GetProfileNum(slenderProfile, buffer, 100);

						EmitSoundToAll(path, slender, channel, level, _, volume, pitch);
					}
				}
			}
		}
	}

	return projectileEnt;
}

public Action Hook_ProjectileAttackTouch(int entity, int other)
{
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_ICEBALL_ATTACK:
		{
			float entPos[3], otherPos[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsOrigin", otherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
			{
				int bossIndex = NPCGetFromEntIndex(slender);
				if (bossIndex != -1)
				{
					EmitSoundToAll(g_SlenderFireballExplodeSound[bossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "spell_batball_impact_blue");
			}
		}
		case PROJ_FIREBALL_ATTACK:
		{
			float entPos[3], otherPos[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsOrigin", otherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
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
			float entPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			entPos[2] += 10.0;
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
			{
				int bossIndex = NPCGetFromEntIndex(slender);
				if (bossIndex != -1)
				{
					int difficulty = GetLocalGlobalDifficulty(bossIndex);
					int attackIndex = NPCGetCurrentAttackIndex(bossIndex);
					bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);
					float radius = NPCChaserGetAttackProjectileRadius(bossIndex, attackIndex, difficulty);
					for (int client = 1; client <= MaxClients; client++)
					{
						if (!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client))
						{
							continue;
						}

						if (!attackEliminated && g_PlayerEliminated[client])
						{
							continue;
						}

						float targetPos[3];
						GetClientEyePosition(client, targetPos);

						Handle trace = TR_TraceRayFilterEx(entPos,
							targetPos,
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE,
							RayType_EndPoint,
							TraceRayBossVisibility,
							entity);

						bool isVisible = !TR_DidHit(trace);
						int traceHitEntity = TR_GetEntityIndex(trace);
						delete trace;

						if (!isVisible && traceHitEntity == client) isVisible = true;

						if (isVisible)
						{
							float distance = GetVectorSquareMagnitude(entPos, targetPos);
							if (distance <= SquareFloat(radius))
							{
								SDKHooks_TakeDamage(client, entity, entity, NPCChaserGetAttackProjectileDamage(bossIndex, attackIndex, difficulty), DMG_BLAST);
								if (TF2_IsPlayerInCondition(client, TFCond_Gas))
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
									TF2_StunPlayer(client, NPCChaserGetAttackProjectileIceSlowdownDuration(bossIndex, attackIndex, difficulty), NPCChaserGetAttackProjectileIceSlowdownPercent(bossIndex, attackIndex, difficulty), TF_STUNFLAG_SLOWDOWN, client);
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

public Action Hook_ProjectileTouch(int entity, int other)
{
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_ICEBALL, PROJ_ICEBALL_ATTACK:
		{
			float entPos[3], otherPos[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsOrigin", otherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
			{
				int bossIndex = NPCGetFromEntIndex(slender);
				if (bossIndex != -1)
				{
					EmitSoundToAll(g_SlenderFireballExplodeSound[bossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "spell_batball_impact_blue");
			}
		}
		case PROJ_FIREBALL, PROJ_FIREBALL_ATTACK:
		{
			float entPos[3], otherPos[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsOrigin", otherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
			{
				int bossIndex = NPCGetFromEntIndex(slender);
				if (bossIndex != -1)
				{
					EmitSoundToAll(g_SlenderFireballExplodeSound[bossIndex], entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				}
				CreateGeneralParticle(entity, "bombinomicon_burningdebris");
			}
		}
	}
	switch (ProjectileGetFlags(entity))
	{
		case PROJ_BASEBALL:
		{
			float entPos[3], otherPos[3];
			GetEntPropVector(other, Prop_Data, "m_vecAbsOrigin", otherPos);
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			if (other > 0 && other <= MaxClients)
			{
				int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
				if (slender != INVALID_ENT_REFERENCE)
				{
					int bossIndex = NPCGetFromEntIndex(slender);
					int difficulty = GetLocalGlobalDifficulty(bossIndex);
					SDKHooks_TakeDamage(other, slender, slender, NPCChaserGetProjectileDamage(bossIndex, difficulty), 1048576);
					if (TF2_IsPlayerInCondition(other, TFCond_Gas))
					{
						TF2_IgnitePlayer(other, other);
						TF2_RemoveCondition(other, TFCond_Gas);
					}
					RemoveEntity(other);
				}
			}
		}
		case PROJ_MANGLER, PROJ_FIREBALL, PROJ_ICEBALL:
		{
			float entPos[3];
			GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", entPos);
			entPos[2] += 10.0;
			int slender = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			if (slender != INVALID_ENT_REFERENCE)
			{
				int bossIndex = NPCGetFromEntIndex(slender);
				if (bossIndex != -1)
				{
					int difficulty = GetLocalGlobalDifficulty(bossIndex);
					bool attackEliminated = view_as<bool>(NPCGetFlags(bossIndex) & SFF_ATTACKWAITERS);
					float radius = NPCChaserGetProjectileRadius(bossIndex, difficulty);
					float fallOff = NPCChaserGetProjectileRadius(bossIndex, difficulty)/2.0;
					for (int client = 1; client <= MaxClients; client++)
					{
						if (!IsValidClient(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || IsClientInGhostMode(client)) continue;

						if (!attackEliminated && g_PlayerEliminated[client]) continue;

						float targetPos[3];
						GetClientEyePosition(client, targetPos);

						Handle trace = TR_TraceRayFilterEx(entPos,
							targetPos,
							CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE,
							RayType_EndPoint,
							TraceRayBossVisibility,
							entity);

						bool isVisible = !TR_DidHit(trace);
						int traceHitEntity = TR_GetEntityIndex(trace);
						delete trace;

						if (!isVisible && traceHitEntity == client) isVisible = true;

						if (isVisible)
						{
							float distance = GetVectorSquareMagnitude(entPos, targetPos);
							if (distance <= SquareFloat(radius))
							{
								float finalDamage;
								if (distance <= SquareFloat(fallOff))
								{
									finalDamage = NPCChaserGetProjectileDamage(bossIndex, difficulty);
								}
								else
								{
									float multiplier = (1.0 - ((distance - SquareFloat(fallOff)) / (SquareFloat(radius) - SquareFloat(fallOff))));
									finalDamage = multiplier * NPCChaserGetProjectileDamage(bossIndex, difficulty);
								}
								if ((ProjectileGetFlags(entity) & PROJ_MANGLER))
								{
									SDKHooks_TakeDamage(client, entity, entity, finalDamage, DMG_BLAST);
								}
								else
								{
									SDKHooks_TakeDamage(client, entity, entity, NPCChaserGetProjectileDamage(bossIndex, difficulty), DMG_BLAST);
								}
								if (TF2_IsPlayerInCondition(client, TFCond_Gas))
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
									TF2_StunPlayer(client, NPCChaserGetIceballSlowdownDuration(bossIndex, difficulty), NPCChaserGetIceballSlowdownPercent(bossIndex, difficulty), TF_STUNFLAG_SLOWDOWN, client);
								}
							}
						}
					}
					if ((ProjectileGetFlags(entity) & PROJ_MANGLER))
					{
						int randomSound = GetRandomInt(0, 2);
						switch (randomSound)
						{
							case 0:
							{
								EmitSoundToAll(MANGLER_EXPLODE1, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 1:
							{
								EmitSoundToAll(MANGLER_EXPLODE2, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 2:
							{
								EmitSoundToAll(MANGLER_EXPLODE3, entity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
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

public Action Hook_ProjectileTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	return Plugin_Handled;
}
