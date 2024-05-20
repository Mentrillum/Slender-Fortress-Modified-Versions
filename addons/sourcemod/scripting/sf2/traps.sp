#if defined _sf2_traps_included
 #endinput
#endif
#define _sf2_traps_included

#pragma semicolon 1

static float g_TrapDespawnTimer[2049];
static bool g_TrapClosed[2049];
static int g_TrapState[2049];
static SF2NPC_Chaser g_TrapMaster[2049];
static bool g_TrapStartedOpenAnim[2049];
static bool g_TrapDoIdleAnim[2049];
static bool g_TrapAnimChange[2049];
static Handle g_TrapTimer[2049];
//State 0 = Idle, State 1 = Closed

void SetupTraps()
{
	g_OnPlayerJumpPFwd.AddFunction(null, OnJump);
}

static void OnJump(SF2_BasePlayer client)
{
	if (client.IsEliminated || IsRoundEnding() || IsRoundInWarmup() || client.HasEscaped)
	{
		return;
	}

	if (client.IsTrapped)
	{
		client.TrapCount -= 1;
	}
	if (client.IsTrapped && client.TrapCount <= 1)
	{
		client.IsTrapped = false;
		client.TrapCount = 0;
	}
}

void Trap_SpawnTrap(float position[3], float direction[3], SF2NPC_Chaser controller)
{
	int slender = controller.EntIndex;
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}
	float newPos[3], zPos[3], newAngles[3], tempAngles[3], product1[3], product2[3], cross[3];
	CopyVector(position, zPos);
	zPos[2] -= 99999.9;
	Handle trace = TR_TraceRayFilterEx(position, zPos, MASK_PLAYERSOLID | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
	TR_GetEndPosition(newPos, trace);
	TR_GetPlaneNormal(trace, direction);
	delete trace;

	CopyVector(direction, tempAngles);
	NegateVector(tempAngles);
	GetVectorAngles(tempAngles, newAngles);
	newAngles[0] -= 90.0;

	GetAngleVectors(direction, product1, NULL_VECTOR, NULL_VECTOR);
	GetAngleVectors(newAngles, product2, NULL_VECTOR, NULL_VECTOR);
	GetVectorCrossProduct(product1, tempAngles, cross);
	float yaw = GetAngleBetweenVectors(product2, cross, tempAngles);
	RotateYaw(newAngles, yaw - 90.0);

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	int difficulty = controller.Difficulty;

	switch (data.TrapType[difficulty])
	{
		case SF2BossTrapType_BearTrap:
		{
			int trapEntity = CreateEntityByName("prop_dynamic");
			if (trapEntity != -1)
			{
				TeleportEntity(trapEntity, newPos, newAngles, NULL_VECTOR);
				SetEntityModel(trapEntity, data.TrapModel);
				DispatchSpawn(trapEntity);
				ActivateEntity(trapEntity);

				SetEntProp(trapEntity, Prop_Send, "m_usSolidFlags", FSOLID_TRIGGER_TOUCH_DEBRIS|FSOLID_TRIGGER|FSOLID_NOT_SOLID|FSOLID_CUSTOMBOXTEST);
				SetEntProp(trapEntity, Prop_Data, "m_nSolidType", SOLID_BBOX);
				SetEntityCollisionGroup(trapEntity, COLLISION_GROUP_DEBRIS_TRIGGER);

				float mins[3], maxs[3];
				mins[0] = -25.0;
				mins[1] = -25.0;
				mins[2] = 0.0;
				maxs[0] = 25.0;
				maxs[1] = 25.0;
				maxs[2] = 25.0;

				SetEntPropVector(trapEntity, Prop_Send, "m_vecMins", mins);
				SetEntPropVector(trapEntity, Prop_Send, "m_vecMaxs", maxs);
				SetEntPropVector(trapEntity, Prop_Send, "m_vecMinsPreScaled", mins);
				SetEntPropVector(trapEntity, Prop_Send, "m_vecMaxsPreScaled", maxs);

				AcceptEntityInput(trapEntity, "EnableCollision");

				g_TrapMaster[trapEntity] = controller;

				g_TrapClosed[trapEntity] = false;
				g_TrapAnimChange[trapEntity] = true;
				SetEntProp(trapEntity, Prop_Data, "m_bSequenceLoops", false);
				if (data.TrapAnimOpen[0] != '\0')
				{
					SetVariantString(data.TrapAnimOpen);
					AcceptEntityInput(trapEntity, "SetAnimation");
					HookSingleEntityOutput(trapEntity, "OnAnimationDone", OnTrapOpenComplete, false);
					g_TrapStartedOpenAnim[trapEntity] = true;
				}
				else
				{
					SetVariantString(data.TrapAnimIdle);
					AcceptEntityInput(trapEntity, "SetAnimation");
				}

				g_TrapEntityCount++;

				g_TrapDespawnTimer[trapEntity] = GetGameTime() + GetRandomFloat(20.0, 40.0);
				g_TrapState[trapEntity] = 0;

				EmitSoundToAll(data.TrapDeploySound, trapEntity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);

				SDKHook(trapEntity, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);
				g_TrapTimer[trapEntity] = CreateTimer(0.1, Timer_TrapThink, EntIndexToEntRef(trapEntity), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
			}
		}
	}
}

static Action Timer_TrapThink(Handle timer, any entref)
{
	int trapEntity = EntRefToEntIndex(entref);
	if (!trapEntity || trapEntity == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	if (timer != g_TrapTimer[trapEntity])
	{
		return Plugin_Stop;
	}

	SF2NPC_Chaser controller = g_TrapMaster[trapEntity];
	if (GetGameTime() >= g_TrapDespawnTimer[trapEntity] || !controller.IsValid())
	{
		Trap_Despawn(trapEntity);
	}

	if (!g_TrapClosed[trapEntity])
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid)
			{
				continue;
			}

			if (!player.IsAlive ||
				player.IsInDeathCam ||
				player.IsInGhostMode ||
				player.HasEscaped ||
				player.InCondition(view_as<TFCond>(130)) ||
				player.Team == TFTeam_Spectator)
			{
				continue;
			}

			if (!g_Enabled)
			{
				if (player.GetProp(Prop_Data, "m_iTeamNum") == controller.DefaultTeam)
				{
					continue;
				}
			}

			float entPos[3], otherPos[3];
			player.GetAbsOrigin(otherPos);
			GetEntPropVector(trapEntity, Prop_Data, "m_vecAbsOrigin", entPos);
			float zPos = otherPos[2] - entPos[2];
			float distance = GetVectorSquareMagnitude(otherPos, entPos);
			if (distance <= SquareFloat(50.0) && (zPos <= 25.0 && zPos >= -25.0))
			{
				TFClassType classType = player.Class;
				int classToInt = view_as<int>(classType);

				if (!IsClassConfigsValid())
				{
					if (classType != TFClass_Heavy)
					{
						player.IsTrapped = true;
						player.TrapCount = GetRandomInt(2, 4);
					}
				}
				else
				{
					if (!g_ClassInvulnerableToTraps[classToInt])
					{
						player.IsTrapped = true;
						player.TrapCount = GetRandomInt(2, 4);
					}
				}
				if (!player.HasHint(PlayerHint_Trap))
				{
					player.ShowHint(PlayerHint_Trap);
				}
				player.TakeDamage(true, _, _, 10.0, 128);
				g_TrapState[trapEntity] = 1;
				g_TrapAnimChange[trapEntity] = true;
				SF2ChaserBossProfileData data;
				data = controller.GetProfileData();
				EmitSoundToAll(data.TrapCatchSound, trapEntity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				SetVariantString(data.TrapAnimClose);
				AcceptEntityInput(trapEntity, "SetAnimation");
				AcceptEntityInput(trapEntity, "DisableCollision");
				g_TrapClosed[trapEntity] = true;
				TrapUpdateAnimation(trapEntity);
			}
		}
	}

	return Plugin_Continue;
}

static void TrapUpdateAnimation(int trapEntity)
{
	if (!IsValidEntity(trapEntity))
	{
		return;
	}
	int state = g_TrapState[trapEntity];
	SF2NPC_Chaser controller = g_TrapMaster[trapEntity];
	if (!controller.IsValid())
	{
		return;
	}
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	switch (state)
	{
		case 0:
		{
			if (!g_TrapStartedOpenAnim[trapEntity] && data.TrapAnimOpen[0] != '\0')
			{
				SetVariantString(data.TrapAnimOpen);
				AcceptEntityInput(trapEntity, "SetAnimation");
				HookSingleEntityOutput(trapEntity, "OnAnimationDone", OnTrapOpenComplete, true);
				g_TrapStartedOpenAnim[trapEntity] = true;
			}
			else if (g_TrapDoIdleAnim[trapEntity])
			{
				SetVariantString(data.TrapAnimIdle);
				AcceptEntityInput(trapEntity, "SetAnimation");
			}
		}
		case 1:
		{
			SetVariantString(data.TrapAnimClose);
			AcceptEntityInput(trapEntity, "SetAnimation");
			AcceptEntityInput(trapEntity, "DisableCollision");
		}
	}
	SetEntProp(trapEntity, Prop_Data, "m_bSequenceLoops", false);
	g_TrapAnimChange[trapEntity] = false;
}

static void OnTrapOpenComplete(const char[] output, int caller, int activator, float delay)
{
	if (IsValidEntity(caller))
	{
		g_TrapAnimChange[caller] = true;
		g_TrapDoIdleAnim[caller] = true;
	}
}

static Action Hook_TrapOnTakeDamage(int trapEntity, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(attacker))
	{
		if (!g_PlayerEliminated[attacker])
		{
			if (damagetype & 0x80 && !g_TrapClosed[trapEntity] && GetClientTeam(attacker) == TFTeam_Red) // 0x80 == melee damage
			{
				g_TrapClosed[trapEntity] = true;
				g_TrapState[trapEntity] = 1;
				g_TrapAnimChange[trapEntity] = true;
				SF2NPC_Chaser controller = g_TrapMaster[trapEntity];
				SF2ChaserBossProfileData data;
				data = controller.GetProfileData();
				EmitSoundToAll(data.TrapMissSound, trapEntity, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				SetVariantString(data.TrapAnimClose);
				AcceptEntityInput(trapEntity, "SetAnimation");
				AcceptEntityInput(trapEntity, "DisableCollision");
				if (g_TrapDespawnTimer[trapEntity] > 5.0)
				{
					g_TrapDespawnTimer[trapEntity] = GetGameTime()+5.0;
				}
				TrapUpdateAnimation(trapEntity);
			}
		}
	}

	return Plugin_Continue;
}

static void Trap_Despawn(int trapEntity)
{
	if (g_TrapTimer[trapEntity] != null)
	{
		KillTimer(g_TrapTimer[trapEntity]);
	}
	SDKUnhook(trapEntity, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);
	g_TrapEntityCount--;
	RemoveEntity(trapEntity);
}