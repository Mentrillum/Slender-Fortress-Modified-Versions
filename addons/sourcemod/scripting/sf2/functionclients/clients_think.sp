#if defined _sf2_clients_think_included
 #endinput
#endif
#define _sf2_clients_think_included

#pragma semicolon 1

void Hook_ClientPreThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	ClientProcessFlashlightAngles(client);
	ClientProcessInteractiveGlow(client);
	ClientProcessStaticShake(client);
	ClientProcessViewAngles(client);

	if (IsClientInDeathCam(client) && !IsClientInGhostMode(client))
	{
		int ent = EntRefToEntIndex(g_PlayerDeathCamEnt[client]);
		if (ent && ent != INVALID_ENT_REFERENCE && g_CameraInDeathCamAdvanced[ent])
		{
			float camPos[3], camAngs[3];
			GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", camAngs);
			GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", camPos);

			camPos[0] -= g_CameraPlayerOffsetBackward[ent];
			camPos[2] -= g_CameraPlayerOffsetDownward[ent];

			CBaseEntity player = CBaseEntity(client);

			player.SetLocalOrigin(camPos);
			player.SetLocalAngles(camAngs);
		}
	}

	if (IsClientInGhostMode(client))
	{
		SetEntityFlags(client,GetEntityFlags(client)^FL_EDICT_ALWAYS);
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
		SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		if (IsClientInKart(client) || !TF2_IsPlayerInCondition(client, TFCond_Stealthed))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
			TF2_RemoveCondition(client, TFCond_Taunting);
			ClientHandleGhostMode(client, true);
		}
		TF2_RemoveCondition(client, TFCond_Taunting);
	}
	else if (!g_PlayerEliminated[client] || g_PlayerProxy[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);

			int roundState = view_as<int>(GameRules_GetRoundState());
			TFClassType class = TF2_GetPlayerClass(client);
			int classToInt = view_as<int>(class);

			if (!g_PlayerProxy[client] && GetClientTeam(client) == TFTeam_Red)
			{
				if (TF2_IsPlayerInCondition(client,TFCond_Disguised))
				{
					TF2_RemoveCondition(client,TFCond_Disguised);
				}

				if (TF2_IsPlayerInCondition(client,TFCond_Taunting) && g_PlayerTrapped[client])
				{
					TF2_RemoveCondition(client,TFCond_Taunting);
				}

				if (TF2_IsPlayerInCondition(client,TFCond_Taunting) && class == TFClass_Soldier)
				{
					int weaponEnt = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
					if (weaponEnt && weaponEnt != INVALID_ENT_REFERENCE)
					{
						int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
						if (itemDefInt == 775 || itemDefInt == 128)
						{
							TF2_RemoveCondition(client,TFCond_Taunting); //Stop suiciding...
						}
					}
				}

				if (roundState == 4)
				{
					bool inDanger = false;

					if (!inDanger)
					{
						int state;
						int bossTarget;

						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1)
							{
								continue;
							}

							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								bossTarget = EntRefToEntIndex(g_SlenderTarget[i]);
								state = g_SlenderState[i];

								if ((state == STATE_CHASE || state == STATE_ATTACK || state == STATE_STUN) &&
									((bossTarget && bossTarget != INVALID_ENT_REFERENCE && (bossTarget == client || ClientGetDistanceFromEntity(client, bossTarget) < SquareFloat(512.0))) || NPCGetDistanceFromEntity(i, client) < SquareFloat(512.0) || PlayerCanSeeSlender(client, i, false)))
								{
									inDanger = true;
									ClientSetScareBoostEndTime(client, GetGameTime() + 5.0);

									// Induce client stress levels.
									float flUnComfortZoneDist = 512.0;
									float flStressScalar = ((SquareFloat(flUnComfortZoneDist) / NPCGetDistanceFromEntity(i, client)));
									ClientAddStress(client, 0.025 * flStressScalar);

									break;
								}
							}
						}
					}

					if (g_PlayerStaticAmount[client] > 0.4)
					{
						inDanger = true;
					}
					if (GetGameTime() < ClientGetScareBoostEndTime(client))
					{
						inDanger = true;
					}

					if (!inDanger)
					{
						int state;
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1)
							{
								continue;
							}

							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								if (state == STATE_ALERT)
								{
									if (PlayerCanSeeSlender(client, i))
									{
										inDanger = true;
										ClientSetScareBoostEndTime(client, GetGameTime() + 5.0);
									}
								}
							}
						}
					}

					if (!inDanger)
					{
						float curTime = GetGameTime();
						float scareSprintDuration = 3.0;
						if (!IsClassConfigsValid())
						{
							if (class == TFClass_DemoMan)
							{
								scareSprintDuration *= 1.667;
							}
						}
						else
						{
							scareSprintDuration *= g_ClassScareSprintDurationMultipler[classToInt];
						}

						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1)
							{
								continue;
							}

							if ((curTime - g_PlayerScareLastTime[client][i]) <= scareSprintDuration)
							{
								inDanger = true;
								break;
							}
						}
					}

					float walkSpeed, sprintSpeed;
					if (!IsClassConfigsValid())
					{
						walkSpeed = ClientGetDefaultWalkSpeed(client);
						sprintSpeed = ClientGetDefaultSprintSpeed(client);
					}
					else
					{
						walkSpeed = g_ClassWalkSpeed[classToInt];
						sprintSpeed = g_ClassRunSpeed[classToInt];
					}

					// Check for weapon speed changes.
					int weaponEnt = INVALID_ENT_REFERENCE;

					for (int slot = 0; slot <= 5; slot++)
					{
						weaponEnt = GetPlayerWeaponSlot(client, slot);
						if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
						{
							continue;
						}

						int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
						switch (itemDefInt)
						{
							case 172: // Scotsman's Skullcutter
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weaponEnt)
								{
									sprintSpeed -= (sprintSpeed * 0.05);
									walkSpeed -= (walkSpeed * 0.05);
								}
							}
							case 214: // The Powerjack
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weaponEnt)
								{
									sprintSpeed += (sprintSpeed * 0.03);
								}
							}
							case 239: // Gloves of Running Urgently
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weaponEnt)
								{
									sprintSpeed += (sprintSpeed * 0.075);
								}
							}
							case 775: // Escape Plan
							{
								float health = float(GetEntProp(client, Prop_Send, "m_iHealth"));
								float maxHealth = float(SDKCall(g_SDKGetMaxHealth, client));
								float percentage = health / maxHealth;

								if (percentage < 0.805 && percentage >= 0.605)
								{
									walkSpeed += (walkSpeed * 0.05);
									sprintSpeed += (sprintSpeed * 0.05);
								}
								else if (percentage < 0.605 && percentage >= 0.405)
								{
									walkSpeed += (walkSpeed * 0.1);
									sprintSpeed += (sprintSpeed * 0.1);
								}
								else if (percentage < 0.405 && percentage >= 0.205)
								{
									walkSpeed += (walkSpeed * 0.15);
									sprintSpeed += (sprintSpeed * 0.15);
								}
								else if (percentage < 0.205)
								{
									walkSpeed += (walkSpeed * 0.2);
									sprintSpeed += (sprintSpeed * 0.2);
								}
							}
						}
					}

					// Speed buff
					if (!SF_IsSlaughterRunMap())
					{
						if (TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly))
						{
							walkSpeed += (walkSpeed * 0.115);
							sprintSpeed += (sprintSpeed * 0.165);
						}
					}
					else
					{
						if (TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly))
						{
							walkSpeed += (walkSpeed * 0.105);
							sprintSpeed += (sprintSpeed * 0.14);
						}
					}

					if (inDanger)
					{
						if (!IsClassConfigsValid())
						{
							if (class != TFClass_Spy && class != TFClass_Pyro)
							{
								walkSpeed *= 1.34;
								sprintSpeed *= 1.34;
							}
							else
							{
								if (class == TFClass_Spy)
								{
									walkSpeed *= 1.28;
									sprintSpeed *= 1.28;
								}
								else
								{
									weaponEnt = INVALID_ENT_REFERENCE;
									for (int iSlot = 0; iSlot <= 5; iSlot++)
									{
										weaponEnt = GetPlayerWeaponSlot(client, iSlot);
										if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
										{
											continue;
										}

										int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
										if (itemDefInt == 214 && GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weaponEnt)
										{
											walkSpeed *= 1.32;
											sprintSpeed *= 1.32;
										}
										else
										{
											walkSpeed *= 1.34;
											sprintSpeed *= 1.34;
										}
									}
								}
							}
						}
						else
						{
							float multiplier = g_ClassDangerSpeedMultipler[classToInt];
							if (class == TFClass_Pyro)
							{
								weaponEnt = INVALID_ENT_REFERENCE;
								for (int iSlot = 0; iSlot <= 5; iSlot++)
								{
									weaponEnt = GetPlayerWeaponSlot(client, iSlot);
									if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
									{
										continue;
									}

									int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
									if (itemDefInt == 214 && GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == weaponEnt)
									{
										multiplier -= 0.02;
									}
								}
							}
							walkSpeed *= multiplier;
							sprintSpeed *= multiplier;
						}

						if (!g_PlayerHints[client][PlayerHint_Sprint])
						{
							ClientShowHint(client, PlayerHint_Sprint);
						}
					}

					float sprintSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.5);
					float walkSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.35);
					if (g_PlayerSprintPoints[client] > 7)
					{
						sprintSpeedSubtract -= sprintSpeedSubtract * (g_PlayerSprintPoints[client] != 0 ? (float(g_PlayerSprintPoints[client]) / 100.0) : 0.0);
						sprintSpeed -= sprintSpeedSubtract;
					}
					else
					{
						sprintSpeedSubtract += 25;
						sprintSpeed -= sprintSpeedSubtract;
						walkSpeedSubtract += 15;
						walkSpeed -= walkSpeedSubtract;
					}

					if (IsClientSprinting(client))
					{
						if (!g_PlayerTrapped[client])
						{
							if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
							{
								if (!TF2_IsPlayerInCondition(client, TFCond_Charging))
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", sprintSpeed);
								}
								else
								{
									if (SF_IsBoxingMap() || SF_IsRaidMap())
									{
										SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", sprintSpeed*2.5);
									}
									else
									{
										SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", sprintSpeed/2.5);
									}
								}
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", sprintSpeed-170.0);
							}
							else
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", sprintSpeed-170.0);
							}
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 0.1);
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", 0.1);
						}
					}
					else
					{
						if (!g_PlayerTrapped[client])
						{
							if (!TF2_IsPlayerInCondition(client, TFCond_Charging))
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", walkSpeed);
							}
							else
							{
								if (SF_IsBoxingMap() || SF_IsRaidMap())
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", walkSpeed*2.5);
								}
								else
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", walkSpeed/2.5);
								}
							}
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", walkSpeed-20.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 0.01);
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", 0.01);
						}
					}

					if (ClientCanBreath(client) && !g_PlayerBreath[client])
					{
						ClientStartBreathing(client);
					}

					if (g_PlayerTrapped[client])
					{
						TF2Attrib_SetByName(client, "increased jump height", 0.0);
					}
					else
					{
						TF2Attrib_SetByName(client, "increased jump height", 1.0);
					}
				}
			}
			else if (g_PlayerProxy[client] && GetClientTeam(client) == TFTeam_Blue)
			{
				bool speedup = TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly);

				switch (class)
				{
					case TFClass_Scout:
					{
						if (speedup || g_InProxySurvivalRageMode)
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 390.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
						}
					}
					case TFClass_Medic:
					{
						if (speedup || g_InProxySurvivalRageMode)
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 370.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
						}
					}
					case TFClass_Spy:
					{
						if (speedup || g_InProxySurvivalRageMode)
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 370.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
						}
					}
					default:
					{
						if (g_InProxySurvivalRageMode)
						{
							float rageSpeed = ClientGetDefaultSprintSpeed(client)+30.0;
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", rageSpeed);
						}
					}
				}
			}
		}
	}
	if (g_PlayerEliminated[client] && IsClientInPvP(client))
	{
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
		}
	}
	if (IsRoundInWarmup() || (IsRoundInIntro() && !g_PlayerEliminated[client]) || IsRoundEnding()) //I told you, stop breaking my plugin
	{
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client,TFCond_HalloweenKart);
			TF2_RemoveCondition(client,TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client,TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client,TFCond_HalloweenKartCage);
		}
	}

	// Calculate player stress levels.
	if (GetGameTime() >= g_PlayerStressNextUpdateTime[client])
	{
		//float flPagePercent = g_PageMax != 0 ? float(g_PageCount) / float(g_PageMax) : 0.0;
		//float flPageCountPercent = g_PageMax != 0? float(g_PlayerPageCount[client]) / float(g_PageMax) : 0.0;

		g_PlayerStressNextUpdateTime[client] = GetGameTime() + 0.33;
		ClientAddStress(client, -0.01);

		#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_PLAYER_STRESS, 1, "g_PlayerStressAmount[%d]: %0.1f", client, g_PlayerStressAmount[client]);
		#endif
	}

	// Process screen shake, if enabled.
	if (g_IsPlayerShakeEnabled)
	{
		bool doShake = false;

		if (IsPlayerAlive(client))
		{
			int staticMaster = NPCGetFromUniqueID(g_PlayerStaticMaster[client]);
			if (staticMaster != -1 && NPCGetFlags(staticMaster) & SFF_HASVIEWSHAKE)
			{
				doShake = true;
			}
		}

		if (doShake)
		{
			float percent = g_PlayerStaticAmount[client];

			float amplitudeMax = g_PlayerShakeAmplitudeMaxConVar.FloatValue;
			float amplitude = amplitudeMax * percent;

			float frequencyMax = g_PlayerShakeFrequencyMaxConVar.FloatValue;
			float frequency = frequencyMax * percent;

			UTIL_ClientScreenShake(client, amplitude, 0.5, frequency);
		}
	}

	if (g_LastVisibilityProcess[client] + 0.30 >= GetGameTime())
	{
		return;
	}

	/*if (!g_PlayerEliminated[client])
	{
		CNavArea targetArea = SDK_GetLastKnownArea(client);//SDK_GetLastKnownArea(client) =/= g_lastNavArea[client], SDK_GetLastKnownArea() retrives the nav area stored by the server
		if (targetArea != INVALID_NAV_AREA)
		{
			ClientNavAreaUpdate(client, g_lastNavArea[client], targetArea);
			g_lastNavArea[client] = targetArea;
		}
	}*/

	g_LastVisibilityProcess[client] = GetGameTime();

	ClientProcessVisibility(client);
}

Action Hook_ClientOnTakeDamage(int victim,int &attacker,int &inflictor, float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3],int damagecustom)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	Action action = Plugin_Continue;

	float damage2 = damage;
	Call_StartForward(g_OnClientTakeDamageFwd);
	Call_PushCell(victim);
	Call_PushCellRef(attacker);
	Call_PushCellRef(inflictor);
	Call_PushFloatRef(damage2);
	Call_Finish(action);

	if (action == Plugin_Changed)
	{
		damage = damage2;
		return Plugin_Changed;
	}

	TFClassType class = TF2_GetPlayerClass(victim);
	int classToInt = view_as<int>(class);

	if (IsRoundInWarmup() && IsValidClient(attacker))
	{
		float modelScale = GetEntPropFloat(attacker, Prop_Send, "m_flModelScale");
		float headScale = GetEntPropFloat(attacker, Prop_Send, "m_flHeadScale");
		float torsoScale = GetEntPropFloat(attacker, Prop_Send, "m_flTorsoScale");
		float handScale = GetEntPropFloat(attacker, Prop_Send, "m_flHandScale");
		if (modelScale < 1.0 || modelScale > 1.0 || headScale < 1.0 || headScale > 1.0 || torsoScale < 1.0 || torsoScale > 1.0 || handScale < 1.0 || handScale > 1.0)
		{
			damage = 0.0; //So how does it feel?
			return Plugin_Changed;
		}
	}

	if (IsClientInKart(victim) && (attacker == -1 || inflictor == -1))
	{
		damage = 0.0;
		return Plugin_Changed;
	}

	char inflictorClass[32];
	if (inflictor >= 0)
	{
		GetEdictClassname(inflictor, inflictorClass, sizeof(inflictorClass));
	}

	if (IsValidClient(attacker) && IsValidClient(victim) && g_PlayerProxy[attacker] && GetClientTeam(victim) == TFTeam_Red && TF2_IsPlayerInCondition(victim, TFCond_Gas))
	{
		TF2_IgnitePlayer(victim, victim);
		TF2_RemoveCondition(victim, TFCond_Gas);
	}

	if (IsValidClient(attacker) && IsValidClient(victim) && IsClientInPvP(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && victim != attacker)
	{
		damage = 0.0;
		return Plugin_Changed;
	}

	if (IsValidClient(attacker) && IsValidClient(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && g_PlayerTrapped[victim])
	{
		if (!g_PlayerEliminated[attacker] && !g_PlayerEliminated[victim])
		{
			if (damagetype & 0x80) // 0x80 == melee damage
			{
				g_PlayerTrapped[victim] = false;
				TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				TF2_AddCondition(victim, TFCond_SpeedBuffAlly, 4.0);
			}
		}
	}

	if (IsValidClient(attacker) && !g_PlayerEliminated[attacker] && !DidClientEscape(attacker) && class == TFClass_Soldier && !(GetEntityFlags(attacker) & FL_ONGROUND))
	{
		int weaponEnt = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
		if (IsValidEntity(weaponEnt))
		{
			int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
			float zVelocity[3];
			GetEntPropVector(attacker, Prop_Data, "m_vecVelocity", zVelocity);
			if (itemDefInt == 416 && zVelocity[2] < 0.0 && weaponEnt == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon")) //A soldier has the market gardener and is currently falling down, like Minecraft with it's critical hits.
			{
				damagetype |= DMG_ACID;
			}
		}
	}

	if (IsEntityAProjectile(inflictor))
	{
		int npcIndex = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex != -1)
		{
			bool attackEliminated = view_as<bool>(NPCGetFlags(npcIndex) & SFF_ATTACKWAITERS);
			if (!attackEliminated && (GetClientTeam(victim) == TFTeam_Blue) && IsValidClient(victim) )
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}

	// Prevent telefrags
	if ((damagetype & DMG_CRUSH) && damage > 500.0)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(NPCGetFromEntIndex(attacker));
		if (Npc != SF2_INVALID_NPC && IsValidClient(victim))
		{
			damage = 0.0;
			Npc.UnSpawn();
			return Plugin_Changed;
		}
	}

	if (attacker != victim && IsValidClient(attacker))
	{
		if (!IsRoundEnding())
		{
			if (IsRoundInWarmup() || (IsClientInPvP(victim) && IsClientInPvP(attacker)))
			{
				if (attacker == inflictor)
				{
					if (IsValidEdict(weapon))
					{
						char weaponClass[64];
						GetEdictClassname(weapon, weaponClass, sizeof(weaponClass));

						// Backstab check!
						if ((strcmp(weaponClass, "tf_weapon_knife") == 0 || (TF2_GetPlayerClass(attacker) == TFClass_Spy && strcmp(weaponClass, "saxxy") == 0)) &&
							(damagecustom != TF_CUSTOM_TAUNT_FENCING))
						{
							float myPos[3], hisPos[3], myDirection[3];
							GetClientAbsOrigin(victim, myPos);
							GetClientAbsOrigin(attacker, hisPos);
							GetClientEyeAngles(victim, myDirection);
							GetAngleVectors(myDirection, myDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(myDirection, myDirection);
							ScaleVector(myDirection, 32.0);
							AddVectors(myDirection, myPos, myDirection);

							float p[3], s[3];
							MakeVectorFromPoints(myPos, hisPos, p);
							MakeVectorFromPoints(myPos, myDirection, s);
							if (GetVectorDotProduct(p, s) <= 0.0)//We can backstab him m8
							{
								if (GetClientTeam(victim) == GetClientTeam(attacker) && class == TFClass_Sniper)
								{
									//look if the player has a razorback
									int wearableEnt = INVALID_ENT_REFERENCE;
									while ((wearableEnt = FindEntityByClassname(wearableEnt, "tf_wearable")) != -1)
									{
										if (GetEntPropEnt(wearableEnt, Prop_Send, "m_hOwnerEntity") == victim && GetEntProp(wearableEnt, Prop_Send, "m_iItemDefinitionIndex") == 57)
										{
											RemoveEntity(wearableEnt);
											damage = 0.0;
											EmitSoundToClient(victim, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
											EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);

											SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
											int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
											if (vm > MaxClients)
											{
												int meleeIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
												int anim = 41;
												switch (meleeIndex)
												{
													case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968:
													{
														anim = 15;
													}
													case 638:
													{
														anim = 31;
													}
												}
												SetEntProp(vm, Prop_Send, "m_nSequence", anim);
											}
											return Plugin_Changed;
										}
									}
								}
								if (damagecustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
								{
									damage = 120.0;
									if (damagetype & DMG_ACID)
									{
										damage = 120.0;
									}
								}

								if (g_WeaponCriticalsConVar != null && g_WeaponCriticalsConVar.BoolValue)
								{
									damagetype |= DMG_ACID;
								}

								if (!IsClientCritUbercharged(victim))
								{
									if (GetClientTeam(victim) == GetClientTeam(attacker))
									{
										int pistol = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
										if (pistol > MaxClients && GetEntProp(pistol, Prop_Send, "m_iItemDefinitionIndex") == 525) //Give one crit fort the backstab
										{
											int crits = GetEntProp(attacker, Prop_Send, "m_iRevengeCrits");
											crits++;
											SetEntProp(attacker, Prop_Send, "m_iRevengeCrits", crits);
										}
									}
									if (GetEntProp(victim, Prop_Send, "m_iHealth") <= 120)
									{
										g_PlayerBackStabbed[victim] = true;
									}
									else
									{
										g_PlayerBackStabbed[victim] = false;
									}
								}
								return Plugin_Changed;
							}
						}
					}
				}
			}
			else if (g_PlayerProxy[victim] || g_PlayerProxy[attacker])
			{
				if (g_PlayerEliminated[attacker] == g_PlayerEliminated[victim])
				{
					damage = 0.0;
					return Plugin_Changed;
				}

				if (attacker == victim)//Don't allow proxy to self regenerate control.
				{
					return Plugin_Continue;
				}

				if (g_PlayerProxy[attacker])
				{
					int maxHealth = SDKCall(g_SDKGetMaxHealth, victim);
					int master = NPCGetFromUniqueID(g_PlayerProxyMaster[attacker]);
					if (master != -1)
					{
						int difficulty = GetLocalGlobalDifficulty(master);
						if (damagecustom == TF_CUSTOM_TAUNT_GRAND_SLAM ||
							damagecustom == TF_CUSTOM_TAUNT_FENCING ||
							damagecustom == TF_CUSTOM_TAUNT_ARROW_STAB ||
							damagecustom == TF_CUSTOM_TAUNT_GRENADE ||
							damagecustom == TF_CUSTOM_TAUNT_BARBARIAN_SWING ||
							damagecustom == TF_CUSTOM_TAUNT_ENGINEER_ARM ||
							damagecustom == TF_CUSTOM_TAUNT_ARMAGEDDON)
						{
							if (damage >= float(maxHealth))
							{
								damage = float(maxHealth) * 0.5;
							}
							else
							{
								damage = 0.0;
							}
						}
						else if (damagecustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
						{
							damage = float(maxHealth) * g_SlenderProxyDamageVsBackstab[master][difficulty];
							if (damagetype & DMG_ACID)
							{
								damage /= 2.0;
							}
						}

						g_PlayerProxyControl[attacker] += g_SlenderProxyControlGainHitEnemy[master][difficulty];
						if (g_PlayerProxyControl[attacker] > 100)
						{
							g_PlayerProxyControl[attacker] = 100;
						}

						float originalPercentage = g_SlenderProxyDamageVsEnemy[master][difficulty];
						float additionPercentage = 0.15;
						if (!IsClassConfigsValid())
						{
							if (class == TFClass_Medic)
							{
								damage *= (originalPercentage + additionPercentage);
							}
							else
							{
								damage *= originalPercentage;
							}
						}
						else
						{
							damage *= originalPercentage + g_ClassProxyDamageVulnerability[classToInt];
						}
					}
					return Plugin_Changed;
				}
				else if (g_PlayerProxy[victim])
				{
					char profile[SF2_MAX_PROFILE_NAME_LENGTH];
					int master = NPCGetFromUniqueID(g_PlayerProxyMaster[victim]);
					if (master != -1)
					{
						NPCGetProfile(master, profile, sizeof(profile));
						int difficulty = GetLocalGlobalDifficulty(master);
						g_PlayerProxyControl[attacker] += g_SlenderProxyControlGainHitByEnemy[master][difficulty];
						if (g_PlayerProxyControl[attacker] > 100)
						{
							g_PlayerProxyControl[attacker] = 100;
						}

						damage *= g_SlenderProxyDamageVsSelf[master][difficulty];
					}
					if (TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))
					{
						damage = 0.0;
					}
					if (damage * (damagetype & DMG_CRIT ? 3.0 : 1.0) >= float(GetClientHealth(victim)) && !TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))//The proxy is about to die
					{
						char buffer[PLATFORM_MAX_PATH];
						int classIndex = view_as<int>(TF2_GetPlayerClass(victim));
						ArrayList deathAnims = GetBossProfileProxyDeathAnimations(profile);
						if (deathAnims != null)
						{
							deathAnims.GetString(classIndex, buffer, sizeof(buffer));
							if (buffer[0] == '\0')
							{
								deathAnims.GetString(0, buffer, sizeof(buffer));
							}
							if (buffer[0] != '\0')
							{
								g_ClientMaxFrameDeathAnim[victim]=GetBossProfileProxyDeathAnimFrames(profile, classIndex);
								if (g_ClientMaxFrameDeathAnim[victim] == 0)
								{
									g_ClientMaxFrameDeathAnim[victim] = GetBossProfileProxyDeathAnimFrames(profile, 0);
								}
								if (g_ClientMaxFrameDeathAnim[victim] > 0)
								{
									// Cancel out any other taunts.
									if (TF2_IsPlayerInCondition(victim, TFCond_Taunting))
									{
										TF2_RemoveCondition(victim, TFCond_Taunting);
									}
									//The model has a death anim play it.
									SDK_PlaySpecificSequence(victim,buffer);
									g_ClientFrame[victim] = 0;
									RequestFrame(ProxyDeathAnimation,victim);
									TF2_AddCondition(victim, view_as<TFCond>(87), 5.0);
									//Prevent death, and show the damage to the attacker.
									TF2_AddCondition(victim, view_as<TFCond>(70), 0.5);
									return Plugin_Changed;
								}
							}
						}

						//the player has no death anim leave him die.
					}
					return Plugin_Changed;
				}
			}
			else
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
		else
		{
			if (g_PlayerEliminated[attacker] == g_PlayerEliminated[victim])
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}

		if (IsClientInGhostMode(victim))
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}

Action Timer_ClientSprinting(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerSprintTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsClientSprinting(client))
	{
		return Plugin_Stop;
	}

	if (g_PlayerSprintPoints[client] <= 0)
	{
		ClientStopSprint(client);
		g_PlayerSprintPoints[client] = 0;
		return Plugin_Stop;
	}

	if (IsClientReallySprinting(client))
	{
		int override = g_PlayerInfiniteSprintOverrideConVar.IntValue;
		if ((!g_IsRoundInfiniteSprint && override != 1) || override == 0)
		{
			g_PlayerSprintPoints[client]--;
		}
	}

	ClientSprintTimer(client);

	return Plugin_Stop;
}

void Hook_ClientSprintingPreThink(int client)
{
	if (!IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		return;
	}

	int fov = GetEntData(client, g_PlayerDefaultFOVOffset);

	int targetFov = g_PlayerDesiredFOV[client] + 10;

	if (fov < targetFov)
	{
		int diff = RoundFloat(FloatAbs(float(fov - targetFov)));
		if (diff >= 1)
		{
			ClientSetFOV(client, fov + 1);
		}
		else
		{
			ClientSetFOV(client, targetFov);
		}
	}
	else if (fov >= targetFov)
	{
		ClientSetFOV(client, targetFov);
		//SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	}
}

void Hook_ClientRechargeSprintPreThink(int client)
{
	if (IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		return;
	}

	int fov = GetEntData(client, g_PlayerDefaultFOVOffset);
	if (fov > g_PlayerDesiredFOV[client])
	{
		int diff = RoundFloat(FloatAbs(float(fov - g_PlayerDesiredFOV[client])));
		if (diff >= 1)
		{
			ClientSetFOV(client, fov - 1);
		}
		else
		{
			ClientSetFOV(client, g_PlayerDesiredFOV[client]);
		}
	}
	else if (fov <= g_PlayerDesiredFOV[client])
	{
		ClientSetFOV(client, g_PlayerDesiredFOV[client]);
	}
}

Action Timer_ClientRechargeSprint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	float velSpeed[3];
	GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", velSpeed);
	float speed = GetVectorLength(velSpeed, true);

	if (timer != g_PlayerSprintTimer[client])
	{
		return Plugin_Stop;
	}

	if (IsClientSprinting(client))
	{
		g_PlayerSprintTimer[client] = null;
		return Plugin_Stop;
	}

	if (g_PlayerSprintPoints[client] >= 100)
	{
		g_PlayerSprintPoints[client] = 100;
		g_PlayerSprintTimer[client] = null;
		return Plugin_Stop;
	}
	if ((!GetEntProp(client, Prop_Send, "m_bDucking") && !GetEntProp(client, Prop_Send, "m_bDucked")) || (GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked") && IsClientReallySprinting(client) || speed > 0.0))
	{
		g_PlayerSprintPoints[client]++;
	}
	else if ((GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked")) && !IsClientReallySprinting(client) && speed == 0.0)
	{
		if (!SF_SpecialRound(SPECIALROUND_COFFEE))
		{
			g_PlayerSprintPoints[client] += 2;
		}
		else
		{
			g_PlayerSprintPoints[client] += 1;
		}
	}
	ClientSprintTimer(client, true);
	return Plugin_Stop;
}

void ClientOnButtonPress(int client,int button)
{
	switch (button)
	{
		case IN_ATTACK2:
		{
			if (IsPlayerAlive(client))
			{
				if (!IsRoundInWarmup() &&
					!IsRoundInIntro() &&
					!IsRoundEnding() &&
					!DidClientEscape(client))
				{
					if (GetGameTime() >= ClientGetFlashlightNextInputTime(client))
					{
						ClientHandleFlashlight(client);
					}
				}
			}
		}
		case IN_ATTACK3:
		{
			ClientHandleSprint(client, true);
		}
		case IN_RELOAD:
		{
			if (IsPlayerAlive(client))
			{
				if (!g_PlayerEliminated[client])
				{
					if (!IsRoundEnding() &&
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!DidClientEscape(client))
					{
						g_PlayerHoldingBlink[client] = true;
						ClientBlink(client);
					}
				}
			}
		}
		case IN_JUMP:
		{
			if (IsPlayerAlive(client) && !(GetEntityFlags(client) & FL_FROZEN))
			{
				if (!view_as<bool>(GetEntProp(client, Prop_Send, "m_bDucked")) &&
					(GetEntityFlags(client) & FL_ONGROUND) &&
					GetEntProp(client, Prop_Send, "m_nWaterLevel") < 2)
				{
					ClientOnJump(client);
				}
			}
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.0001);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
		case IN_DUCK:
		{
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 4.0);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
	}
}

void ClientOnButtonRelease(int client,int button)
{
	switch (button)
	{
		case IN_ATTACK3:
		{
			ClientHandleSprint(client, false);
		}
		case IN_DUCK:
		{
			ClientEndPeeking(client);

			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.5);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
		case IN_JUMP:
		{
			if (IsClientInGhostMode(client))
			{
				SetEntityGravity(client, 0.5);
			}
			else
			{
				SetEntityGravity(client, 1.0);
			}
		}
		case IN_RELOAD:
		{
			if (IsPlayerAlive(client))
			{
				if (!g_PlayerEliminated[client])
				{
					if (!IsRoundEnding() &&
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!DidClientEscape(client))
					{
						g_PlayerHoldingBlink[client] = false;
					}
				}
			}
		}
	}
}

void ClientOnJump(int client)
{
	if (!g_PlayerEliminated[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			int override = g_PlayerInfiniteSprintOverrideConVar.IntValue;
			if ((!g_IsRoundInfiniteSprint && override != 1) || override == 0 && !g_PlayerTrapped[client])
			{
				if (g_PlayerSprintPoints[client] >= 2)
				{
					TFClassType classType = TF2_GetPlayerClass(client);
					int classToInt = view_as<int>(classType);
					if (!IsClassConfigsValid())
					{
						if (classType != TFClass_Soldier || g_PlayerSprintPoints[client] <= 10 || IsClientSprinting(client))
						{
							g_PlayerSprintPoints[client] -= 7;
						}
					}
					else
					{
						int sprintPointsLoss = g_ClassSprintPointLossJumping[classToInt];
						if (g_PlayerSprintPoints[client] <= 10 || IsClientSprinting(client))
						{
							sprintPointsLoss = 7;
						}
						g_PlayerSprintPoints[client] -= sprintPointsLoss;
					}
					if (g_PlayerSprintPoints[client] <= 0)
					{
						g_PlayerSprintPoints[client] = 0;
					}
				}
			}

			if (!IsClientSprinting(client))
			{
				if (g_PlayerSprintTimer[client] == null)
				{
					// If the player hasn't sprinted recently, force us to regenerate the stamina.
					ClientSprintTimer(client, true);
				}
			}
			if (g_PlayerTrapped[client])
			{
				g_PlayerTrapCount[client] -= 1;
			}
			if (g_PlayerTrapped[client] && g_PlayerTrapCount[client] <= 1)
			{
				g_PlayerTrapped[client] = false;
				g_PlayerTrapCount[client] = 0;
			}
		}
	}
}

Action Timer_GhostModeConnectionCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerGhostModeConnectionCheckTimer[client])
	{
		return Plugin_Stop;
	}

	if (!IsFakeClient(client) && IsClientTimingOut(client))
	{
		float bootTime = g_PlayerGhostModeConnectionBootTime[client];
		bool checkBool = g_GhostModeConnectionConVar.BoolValue;
		if (bootTime < 0.0 && !checkBool)
		{
			bootTime = GetGameTime() + g_GhostModeConnectionToleranceConVar.FloatValue;
			g_PlayerGhostModeConnectionBootTime[client] = bootTime;
			g_PlayerGhostModeConnectionTimeOutTime[client] = GetGameTime();
		}

		if (GetGameTime() >= bootTime || checkBool)
		{
			ClientSetGhostModeState(client, false);
			TF2_RespawnPlayer(client);

			char authString[128];
			GetClientAuthId(client,AuthId_Engine, authString, sizeof(authString));

			LogSF2Message("Removed %N (%s) from ghost mode due to timing out for %f seconds", client, authString, g_GhostModeConnectionToleranceConVar.FloatValue);

			float timeOutTime = g_PlayerGhostModeConnectionTimeOutTime[client];
			CPrintToChat(client, "\x08FF4040FF%T", "SF2 Ghost Mode Bad Connection", client, RoundFloat(bootTime - timeOutTime));

			return Plugin_Stop;
		}
	}
	else
	{
		// Player regained connection; reset.
		g_PlayerGhostModeConnectionBootTime[client] = -1.0;
	}

	return Plugin_Continue;
}

Action Timer_ClientCheckCamp(Handle timer, any userid)
{
	if (IsRoundInWarmup())
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerCampingTimer[client])
	{
		return Plugin_Stop;
	}

	if (IsRoundEnding() || !IsPlayerAlive(client) || g_PlayerEliminated[client] || DidClientEscape(client))
	{
		return Plugin_Stop;
	}

	if (!g_IsPlayerCampingFirstTime[client])
	{
		bool isCamping = false;
		float pos[3], maxs[3], mins[3];
		GetClientAbsOrigin(client, pos);
		GetEntPropVector(client, Prop_Send, "m_vecMins", mins);
		GetEntPropVector(client, Prop_Send, "m_vecMaxs", maxs);

		// Only do something if the player is NOT stuck.
		float distFromLastPosition = GetVectorSquareMagnitude(g_PlayerCampingLastPosition[client], pos);
		float distFromClosestBoss = 9999999.0;
		int closestBoss = -1;

		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1)
			{
				continue;
			}

			int slender = NPCGetEntIndex(i);
			if (!slender || slender == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			float slenderPos[3];
			SlenderGetAbsOrigin(i, slenderPos);

			float flDist = GetVectorSquareMagnitude(slenderPos, pos);
			if (flDist < distFromClosestBoss)
			{
				closestBoss = i;
				distFromClosestBoss = flDist;
			}
		}
		/*if (IsSpaceOccupiedIgnorePlayers(pos, mins, maxs, client))
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is stuck, no actions taken", client, client);*/
		if (!SF_IsBoxingMap() && g_CampingEnabledConVar.BoolValue &&
		IsRoundPlaying() &&
			g_PlayerStaticAmount[client] <= g_CampingNoStrikeSanityConVar.FloatValue &&
			(closestBoss == -1 || distFromClosestBoss >= g_CampingNoStrikeBossDistanceConVar.FloatValue) &&
			distFromLastPosition <= SquareFloat(g_CampingMinDistanceConVar.FloatValue))
		{
			isCamping = true;
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk, or camping", client, client);
		}
		if (isCamping)
		{
			g_PlayerCampingStrikes[client]++;
			if (g_PlayerCampingStrikes[client] < g_CampingMaxStrikesConVar.IntValue)
			{
				if (g_PlayerCampingStrikes[client] >= g_CampingStrikesWarnConVar.IntValue)
				{
					CPrintToChat(client, "{red}%T", "SF2 Camping System Warning", client, (g_CampingMaxStrikesConVar.IntValue - g_PlayerCampingStrikes[client]) * 5);
				}
			}
			else
			{
				g_PlayerCampingStrikes[client] = 0;
				ClientStartDeathCam(client, 0, pos, true);
			}
		}
		else
		{
			// Forgiveness.
			if (g_PlayerCampingStrikes[client] > 0)
			{
				//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is forgiven of one strike.", client, client);
				g_PlayerCampingStrikes[client]--;
			}
		}

		g_PlayerCampingLastPosition[client][0] = pos[0];
		g_PlayerCampingLastPosition[client][1] = pos[1];
		g_PlayerCampingLastPosition[client][2] = pos[2];
	}
	else
	{
		g_IsPlayerCampingFirstTime[client] = false;
		//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk/camping for the 1st time since the reset, don't take any actions for now.....", client, client);
	}

	return Plugin_Continue;
}

#define SF2_PLAYER_HUD_BLINK_SYMBOL_ON "O"
#define SF2_PLAYER_HUD_BLINK_SYMBOL_OFF "Ɵ"
#define SF2_PLAYER_HUD_BLINK_SYMBOL_OLD "B"
#define SF2_PLAYER_HUD_FLASHLIGHT_SYMBOL "ϟ"
#define SF2_PLAYER_HUD_BAR_SYMBOL "█"
#define SF2_PLAYER_HUD_BAR_MISSING_SYMBOL "░"
#define SF2_PLAYER_HUD_BAR_SYMBOL_OLD "|"
#define SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD ""
#define SF2_PLAYER_HUD_INFINITY_SYMBOL "∞"
#define SF2_PLAYER_HUD_SPRINT_SYMBOL "»"

Action Timer_ClientAverageUpdate(Handle timer)
{
	if (timer != g_ClientAverageUpdateTimer)
	{
		return Plugin_Stop;
	}

	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	if (IsRoundInWarmup() || IsRoundEnding())
	{
		return Plugin_Continue;
	}

	// First, process through HUD stuff.
	char buffer[256];

	static int hudColorHealthy[3];
	static int hudColorCritical[3] = { 255, 10, 10 };

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		if (!g_PlayerPreferences[i].PlayerPreference_LegacyHud)
		{
			hudColorHealthy = { 50, 255, 50 };
		}
		else
		{
			hudColorHealthy = { 150, 255, 150 };
		}

		if (IsPlayerAlive(i) && !IsClientInDeathCam(i))
		{
			if (!g_PlayerEliminated[i])
			{
				if (DidClientEscape(i))
				{
					continue;
				}

				int maxBars = 12;
				int bars;
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					bars = RoundToCeil(float(maxBars) * ClientGetBlinkMeter(i));
					if (bars > maxBars)
					{
						bars = maxBars;
					}

					if (!g_PlayerPreferences[i].PlayerPreference_LegacyHud)
					{
						if (bars != 0)
						{
							FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_ON);
						}
						else
						{
							FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OFF);
						}
					}
					else
					{
						FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OLD);
					}

					if (IsInfiniteBlinkEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < maxBars; i2++)
						{
							if (i2 < bars)
							{
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
							}
							else
							{
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
							}
						}
					}
				}
				if (!SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					bars = RoundToCeil(float(maxBars) * ClientGetFlashlightBatteryLife(i));
					if (bars > maxBars)
					{
						bars = maxBars;
					}

					char buffer2[64];
					FormatEx(buffer2, sizeof(buffer2), "\n%s  ", SF2_PLAYER_HUD_FLASHLIGHT_SYMBOL);
					StrCat(buffer, sizeof(buffer), buffer2);

					if (IsInfiniteFlashlightEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < maxBars; i2++)
						{
							if (i2 < bars)
							{
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
							}
							else
							{
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
							}
						}
					}
				}

				bars = RoundToCeil(float(maxBars) * (float(ClientGetSprintPoints(i)) / 100.0));
				if (bars > maxBars)
				{
					bars = maxBars;
				}

				char buffer2[64];
				FormatEx(buffer2, sizeof(buffer2), "\n%s  ", SF2_PLAYER_HUD_SPRINT_SYMBOL);
				StrCat(buffer, sizeof(buffer), buffer2);

				if (IsInfiniteSprintEnabled())
				{
					StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
				}
				else
				{
					for (int i2 = 0; i2 < maxBars; i2++)
					{
						if (i2 < bars)
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
						}
					}
				}

				float healthRatio = float(GetEntProp(i, Prop_Send, "m_iHealth")) / float(SDKCall(g_SDKGetMaxHealth, i));

				int color[3];
				for (int i2 = 0; i2 < 3; i2++)
				{
					color[i2] = RoundFloat(float(hudColorHealthy[i2]) + (float(hudColorCritical[i2] - hudColorHealthy[i2]) * (1.0 - healthRatio)));
				}
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					SetHudTextParams(0.035, 0.83,
						0.3,
						color[0],
						color[1],
						color[2],
						40,
						_,
						1.0,
						0.07,
						0.5);
				}
				else if (SF_IsRaidMap() || SF_IsBoxingMap())
				{
					SetHudTextParams(0.035, 0.43,
						0.3,
						color[0],
						color[1],
						color[2],
						40,
						_,
						1.0,
						0.07,
						0.5);
				}
				ShowSyncHudText(i, g_HudSync2, buffer);
				buffer[0] = '\0';
			}
			else
			{
				if (g_PlayerProxy[i])
				{
					int maxBars = 12;
					int bars = RoundToCeil(float(maxBars) * (float(g_PlayerProxyControl[i]) / 100.0));
					if (bars > maxBars)
					{
						bars = maxBars;
					}

					strcopy(buffer, sizeof(buffer), "CONTROL\n");

					for (int i2 = 0; i2 < maxBars; i2++)
					{
						if (i2 < bars)
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
						}
					}

					SetHudTextParams(-1.0, 0.83,
						0.3,
						SF2_HUD_TEXT_COLOR_R,
						SF2_HUD_TEXT_COLOR_G,
						SF2_HUD_TEXT_COLOR_B,
						40,
						_,
						1.0,
						0.07,
						0.5);
					ShowSyncHudText(i, g_HudSync2, buffer);
				}
			}
		}
		ClientUpdateListeningFlags(i);
		ClientUpdateMusicSystem(i);
	}

	return Plugin_Continue;
}
