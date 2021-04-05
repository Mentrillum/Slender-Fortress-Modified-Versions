#if defined _sf2_traps_included
 #endinput
#endif
#define _sf2_traps_included

static float g_flTrapDespawnTimer[2049];
static bool g_bTrapClosed[2049];
static int g_iTrapState[2049];
//State 0 = Idle, State 1 = Closed

void Trap_SpawnTrap(float flPosition[3], float flDirection[3], int iBossIndex)
{
	switch (NPCChaserGetTrapType(iBossIndex))
	{
		case SF2BossTrapType_BearTrap:
		{
			int iTrap = CreateEntityByName("prop_dynamic");
			if (iTrap != -1)
			{
				TeleportEntity(iTrap, flPosition, flDirection, NULL_VECTOR);
				SetEntityModel(iTrap, TRAP_MODEL);
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

				SDKHook(iTrap, SDKHook_Think, Hook_TrapThink);
				SDKHook(iTrap, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);

				g_bTrapClosed[iTrap] = false;
				SetVariantString("trapopened");
				AcceptEntityInput(iTrap, "SetDefaultAnimation");
				SetVariantString("trapopened");
				AcceptEntityInput(iTrap, "SetAnimation");
				
				g_flTrapDespawnTimer[iTrap] = GetGameTime() + GetRandomFloat(30.0, 60.0);
				g_iTrapState[iTrap] = 0;
				
				EmitSoundToAll(TRAP_DEPLOY, iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
			}
		}
	}
}

void Hook_TrapThink(int iTrap)
{
	if (!g_bEnabled) return;
	
	if (GetGameTime() >= g_flTrapDespawnTimer[iTrap])
		Trap_Despawn(iTrap);
		
	int iState = g_iTrapState[iTrap];
	switch (iState)
	{
		case 0:
		{
			SetVariantString("trapopened");
			AcceptEntityInput(iTrap, "SetAnimation");
		}
		case 1:
		{
			SetVariantString("trapclosed");
			AcceptEntityInput(iTrap, "SetAnimation");
			AcceptEntityInput(iTrap, "DisableCollision");
		}
	}

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
				g_bTrapClosed[iTrap] = true;
				g_iTrapState[iTrap] = 1;
				EmitSoundToAll(TRAP_CLOSE, iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				AcceptEntityInput(iTrap, "DisableCollision");
			}
		}
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
				EmitSoundToAll(TRAP_CLOSE, iTrap, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, 1.0);
				AcceptEntityInput(iTrap, "DisableCollision");
				if (g_flTrapDespawnTimer[iTrap] > 10.0)
				{
					g_flTrapDespawnTimer[iTrap] = GetGameTime()+10.0;
				}
			}
		}
	}
	
	return Plugin_Continue;
}

void Trap_Despawn(int iTrap)
{
	SDKUnhook(iTrap, SDKHook_Think, Hook_TrapThink);
	SDKUnhook(iTrap, SDKHook_OnTakeDamage, Hook_TrapOnTakeDamage);
	RemoveEntity(iTrap);
}