#if defined _sf2_traps_included
 #endinput
#endif
#define _sf2_traps_included

static float g_flTrapDespawnTimer[2049];
static bool g_bTrapClosed[2049];
static int g_iTrapState[2049];
static int g_iTrapMaster[2049];
static bool g_bTrapStartedOpenAnim[2049];
static bool g_bTrapDoIdleAnim[2049];
static bool g_bTrapAnimChange[2049];
static Handle g_hTrapTimer[2049];
//State 0 = Idle, State 1 = Closed

void Trap_SpawnTrap(float flPosition[3], float flDirection[3], int iBossIndex)
{
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	float flNewPos[3], flZPos[3], flNewAngles[3], flTempAngles[3], flProduct1[3], flProduct2[3], flCross[3];
	CopyVector(flPosition, flZPos);
	flZPos[2] -= 99999.9;
	Handle hTrace = TR_TraceRayFilterEx(flPosition, flZPos, MASK_PLAYERSOLID | CONTENTS_MONSTERCLIP, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
	TR_GetEndPosition(flNewPos, hTrace);
	TR_GetPlaneNormal(hTrace, flDirection);
	delete hTrace;

	CopyVector(flDirection, flTempAngles);
	NegateVector(flTempAngles);
	GetVectorAngles(flTempAngles, flNewAngles);
	flNewAngles[0] -= 90.0;

	GetAngleVectors(flDirection, flProduct1, NULL_VECTOR, NULL_VECTOR);
	GetAngleVectors(flNewAngles, flProduct2, NULL_VECTOR, NULL_VECTOR);
	GetVectorCrossProduct(flProduct1, flTempAngles, flCross);
	float flYaw = GetAngleBetweenVectors(flProduct2, flCross, flTempAngles);
	RotateYaw(flNewAngles, flYaw - 90.0 );

	switch (NPCChaserGetTrapType(iBossIndex))
	{
		case SF2BossTrapType_BearTrap:
		{
			int iTrap = CreateEntityByName("prop_dynamic");
			if (iTrap != -1)
			{
				TeleportEntity(iTrap, flNewPos, flNewAngles, NULL_VECTOR);
				SetEntityModel(iTrap, g_sSlenderTrapModel[iBossIndex]);
				DispatchSpawn(iTrap);
				ActivateEntity(iTrap);

				SetEntProp(iTrap, Prop_Send, "m_usSolidFlags", FSOLID_TRIGGER_TOUCH_DEBRIS|FSOLID_TRIGGER|FSOLID_NOT_SOLID|FSOLID_CUSTOMBOXTEST);
				SetEntProp(iTrap, Prop_Data, "m_nSolidType", SOLID_BBOX);
				SetEntProp(iTrap, Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER); // COLLISION_GROUP_DEBRIS 

				float flMins[3], flMaxs[3];
				flMins[0] = -25.0;
				flMins[1] = -25.0;
				flMins[2] = 0.0;
				flMaxs[0] = 25.0;
				flMaxs[1] = 25.0;
				flMaxs[2] = 25.0;

				SetEntPropVector(iTrap, Prop_Send, "m_vecMins", flMins);
				SetEntPropVector(iTrap, Prop_Send, "m_vecMaxs", flMaxs);
				SetEntPropVector(iTrap, Prop_Send, "m_vecMinsPreScaled", flMins);
				SetEntPropVector(iTrap, Prop_Send, "m_vecMaxsPreScaled", flMaxs);

				AcceptEntityInput(iTrap, "EnableCollision");

				g_iTrapMaster[iTrap] = iBossIndex;

				g_bTrapClosed[iTrap] = false;
				g_bTrapAnimChange[iTrap] = true;
				SetEntProp(iTrap, Prop_Data, "m_bSequenceLoops", false);
				if (g_sSlenderTrapAnimOpen[iBossIndex][0] != '\0')
				{
					SetVariantString(g_sSlenderTrapAnimOpen[iBossIndex]);
					AcceptEntityInput(iTrap, "SetAnimation");
					HookSingleEntityOutput(iTrap, "OnAnimationDone", OnTrapOpenComplete, false);
					g_bTrapStartedOpenAnim[iTrap] = true;
				}
				else
				{
					SetVariantString(g_sSlenderTrapAnimIdle[iBossIndex]);
					AcceptEntityInput(iTrap, "SetAnimation");
				}
				
				g_iTrapEntityCount++;
				
				g_flTrapDespawnTimer[iTrap] = GetGameTime() + GetRandomFloat(20.0, 40.0);
				g_iTrapState[iTrap] = 0;
				
				EmitSoundToAll(g_sSlenderTrapDeploySound[iBossIndex], iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);

				SDKHook(iTrap, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);
				g_hTrapTimer[iTrap] = CreateTimer(0.1, Timer_TrapThink, EntIndexToEntRef(iTrap), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
			}
		}
	}
}

Action Timer_TrapThink(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int iTrap = EntRefToEntIndex(entref);
	if (!iTrap || iTrap == INVALID_ENT_REFERENCE) return Plugin_Stop;

	if (timer != g_hTrapTimer[iTrap]) return Plugin_Stop;

	if (GetGameTime() >= g_flTrapDespawnTimer[iTrap])
		Trap_Despawn(iTrap);

	if (!g_bTrapClosed[iTrap])
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) ||
				!IsPlayerAlive(i) ||
				g_bPlayerEliminated[i] ||
				IsClientInGhostMode(i) ||
				DidClientEscape(i))
			{
				continue;
			}
			
			float flEntPos[3], flOtherPos[3];
			GetEntPropVector(i, Prop_Data, "m_vecAbsOrigin", flOtherPos);
			GetEntPropVector(iTrap, Prop_Data, "m_vecAbsOrigin", flEntPos);
			float flZPos = flOtherPos[2] - flEntPos[2];
			float flDistance = GetVectorSquareMagnitude(flOtherPos, flEntPos);
			if (flDistance <= SquareFloat(50.0) && (flZPos <= 25.0 && flZPos >= -25.0))
			{
				g_bPlayerTrapped[i] = true;
				if (!g_bPlayerHints[i][PlayerHint_Trap])
				{
					ClientShowHint(i, PlayerHint_Trap);
				}
				SDKHooks_TakeDamage(i, i, i, 10.0, 128);
				g_iPlayerTrapCount[i] = GetRandomInt(2, 4);
				g_iTrapState[iTrap] = 1;
				g_bTrapAnimChange[iTrap] = true;
				int iBossIndex = g_iTrapMaster[iTrap];
				EmitSoundToAll(g_sSlenderTrapHitSound[iBossIndex], iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				SetVariantString(g_sSlenderTrapAnimClose[iBossIndex]);
				AcceptEntityInput(iTrap, "SetAnimation");
				AcceptEntityInput(iTrap, "DisableCollision");
				g_bTrapClosed[iTrap] = true;
				TrapUpdateAnimation(iTrap);
			}
		}
	}

	return Plugin_Continue;
}

void TrapUpdateAnimation(int iTrap)
{
	if (!IsValidEntity(iTrap)) return;
	int iState = g_iTrapState[iTrap];
	int iBossIndex = g_iTrapMaster[iTrap];
	switch (iState)
	{
		case 0:
		{
			if (!g_bTrapStartedOpenAnim[iTrap] && g_sSlenderTrapAnimOpen[iBossIndex][0] != '\0')
			{
				SetVariantString(g_sSlenderTrapAnimOpen[iBossIndex]);
				AcceptEntityInput(iTrap, "SetAnimation");
				HookSingleEntityOutput(iTrap, "OnAnimationDone", OnTrapOpenComplete, true);
				g_bTrapStartedOpenAnim[iTrap] = true;
			}
			else if (g_bTrapDoIdleAnim[iTrap])
			{
				SetVariantString(g_sSlenderTrapAnimIdle[iBossIndex]);
				AcceptEntityInput(iTrap, "SetAnimation");
			}
		}
		case 1:
		{
			SetVariantString(g_sSlenderTrapAnimClose[iBossIndex]);
			AcceptEntityInput(iTrap, "SetAnimation");
			AcceptEntityInput(iTrap, "DisableCollision");
		}
	}
	SetEntProp(iTrap, Prop_Data, "m_bSequenceLoops", false);
	g_bTrapAnimChange[iTrap] = false;
}

void OnTrapOpenComplete(const char[] output, int caller, int activator, float delay)
{
	if (IsValidEntity(caller))
	{
		g_bTrapAnimChange[caller] = true;
		g_bTrapDoIdleAnim[caller] = true;
	}
}
/*
public Action Hook_TrapTouch(int iTrap, int client)
{
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (!g_bPlayerEliminated[client] && GetClientTeam(client) == TFTeam_Red && !g_bTrapClosed[iTrap])
		{
			g_bPlayerTrapped[client] = true;
			if (!g_bPlayerHints[client][PlayerHint_Trap])
			{
				ClientShowHint(client, PlayerHint_Trap);
			}
			SDKHooks_TakeDamage(client, client, client, 10.0, 128);
			g_iPlayerTrapCount[client] = GetRandomInt(2, 4);
			g_bTrapClosed[iTrap] = true;
			g_iTrapState[iTrap] = 1;
			EmitSoundToAll(TRAP_CLOSE, iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
			AcceptEntityInput(iTrap, "DisableCollision");
		}
		if (IsClientInGhostMode(client)) return Plugin_Handled;
	}
	return Plugin_Continue;
}
*/
public Action Hook_TrapOnTakeDamage(int iTrap,int &attacker,int &inflictor,float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3],int damagecustom)
{
	if (!g_bEnabled) return Plugin_Continue;

	if (IsValidClient(attacker))
	{
		if (!g_bPlayerEliminated[attacker])
		{
			if (damagetype & 0x80 && !g_bTrapClosed[iTrap] && GetClientTeam(attacker) == TFTeam_Red) // 0x80 == melee damage
			{
				g_bTrapClosed[iTrap] = true;
				g_iTrapState[iTrap] = 1;
				g_bTrapAnimChange[iTrap] = true;
				int iBossIndex = g_iTrapMaster[iTrap];
				EmitSoundToAll(g_sSlenderTrapMissSound[iBossIndex], iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				SetVariantString(g_sSlenderTrapAnimClose[iBossIndex]);
				AcceptEntityInput(iTrap, "SetAnimation");
				AcceptEntityInput(iTrap, "DisableCollision");
				if (g_flTrapDespawnTimer[iTrap] > 5.0)
				{
					g_flTrapDespawnTimer[iTrap] = GetGameTime()+5.0;
				}
				TrapUpdateAnimation(iTrap);
			}
		}
	}
	
	return Plugin_Continue;
}

void Trap_Despawn(int iTrap)
{
	if (g_hTrapTimer[iTrap] != null) KillTimer(g_hTrapTimer[iTrap]);
	SDKUnhook(iTrap, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);
	g_iTrapEntityCount--;
	RemoveEntity(iTrap);
}