#if defined _sf2_clients_think_included
 #endinput
#endif
#define _sf2_clients_think_included

public void Hook_ClientPreThink(int client)
{
	if (!g_bEnabled) return;

	ClientProcessFlashlightAngles(client);
	ClientProcessInteractiveGlow(client);
	ClientProcessStaticShake(client);
	ClientProcessViewAngles(client);
	
	if (IsClientInGhostMode(client))
	{
		SetEntityFlags(client,GetEntityFlags(client)^FL_EDICT_ALWAYS);
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
		SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		if(IsClientInKart(client) || !TF2_IsPlayerInCondition(client, TFCond_Stealthed))
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
	else if (!g_bPlayerEliminated[client] || g_bPlayerProxy[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
			SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		
			int iRoundState = view_as<int>(GameRules_GetRoundState());

			if (!g_bPlayerProxy[client] && GetClientTeam(client) == TFTeam_Red)
			{
				if (TF2_IsPlayerInCondition(client,TFCond_Disguised)) TF2_RemoveCondition(client,TFCond_Disguised);

				if (TF2_IsPlayerInCondition(client,TFCond_Taunting) && g_bPlayerTrapped[client]) TF2_RemoveCondition(client,TFCond_Taunting);

				if (TF2_IsPlayerInCondition(client,TFCond_Taunting) && TF2_GetPlayerClass(client) == TFClass_Soldier)
				{
					int iWeapon = GetPlayerWeaponSlot(client, TFWeaponSlot_Melee);
					if (iWeapon && iWeapon != INVALID_ENT_REFERENCE)
					{
						int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
						if (iItemDef == 775 || iItemDef == 128) TF2_RemoveCondition(client,TFCond_Taunting); //Stop suiciding...
					}
				}

				if (iRoundState == 4)
				{
					if (IsClientInDeathCam(client))
					{
						int ent = EntRefToEntIndex(g_iPlayerDeathCamEnt[client]);
						if (ent && ent != INVALID_ENT_REFERENCE && g_bCameraDeathCamAdvanced[ent])
						{
							float vecCamPos[3], vecCamAngs[3];
							GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", vecCamAngs);
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", vecCamPos);
							
							vecCamPos[0] -= g_flCameraPlayerOffsetBackward[ent];
							vecCamPos[2] -= g_flCameraPlayerOffsetDownward[ent];
							
							TeleportEntity(client, vecCamPos, vecCamAngs, NULL_VECTOR);
						}
					}
					bool bDanger = false;
					
					if (!bDanger)
					{
						int iState;
						int iBossTarget;
						
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								iBossTarget = EntRefToEntIndex(g_iSlenderTarget[i]);
								iState = g_iSlenderState[i];
								
								if ((iState == STATE_CHASE || iState == STATE_ATTACK || iState == STATE_STUN) &&
									((iBossTarget && iBossTarget != INVALID_ENT_REFERENCE && (iBossTarget == client || ClientGetDistanceFromEntity(client, iBossTarget) < SquareFloat(512.0))) || NPCGetDistanceFromEntity(i, client) < SquareFloat(512.0) || PlayerCanSeeSlender(client, i, false)))
								{
									bDanger = true;
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
					
					if (g_flPlayerStaticAmount[client] > 0.4) bDanger = true;
					if (GetGameTime() < ClientGetScareBoostEndTime(client)) bDanger = true;
					
					if (!bDanger)
					{
						int iState;
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if (NPCGetType(i) == SF2BossType_Chaser)
							{
								if (iState == STATE_ALERT)
								{
									if (PlayerCanSeeSlender(client, i))
									{
										bDanger = true;
										ClientSetScareBoostEndTime(client, GetGameTime() + 5.0);
									}
								}
							}
						}
					}
					
					if (!bDanger)
					{
						float flCurTime = GetGameTime();
						float flScareSprintDuration = 3.0;
						if (TF2_GetPlayerClass(client) == TFClass_DemoMan) flScareSprintDuration *= 1.667;
						
						for (int i = 0; i < MAX_BOSSES; i++)
						{
							if (NPCGetUniqueID(i) == -1) continue;
							
							if ((flCurTime - g_flPlayerScareLastTime[client][i]) <= flScareSprintDuration)
							{
								bDanger = true;
								break;
							}
						}
					}
					
					float flWalkSpeed = ClientGetDefaultWalkSpeed(client);
					float flSprintSpeed = ClientGetDefaultSprintSpeed(client);
					
					// Check for weapon speed changes.
					int iWeapon = INVALID_ENT_REFERENCE;
					
					for (int iSlot = 0; iSlot <= 5; iSlot++)
					{
						iWeapon = GetPlayerWeaponSlot(client, iSlot);
						if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;
						
						int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
						switch (iItemDef)
						{
							case 172: // Scotsman's Skullcutter
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed -= (flSprintSpeed * 0.05);
									flWalkSpeed -= (flWalkSpeed * 0.05);
								}
							}
							case 214: // The Powerjack
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed += (flSprintSpeed * 0.03);
								}
							}
							case 239: // Gloves of Running Urgently
							{
								if (GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
								{
									flSprintSpeed += (flSprintSpeed * 0.075);
								}
							}
							case 775: // Escape Plan
							{
								float flHealth = float(GetEntProp(client, Prop_Send, "m_iHealth"));
								float flMaxHealth = float(SDKCall(g_hSDKGetMaxHealth, client));
								float flPercentage = flHealth / flMaxHealth;

								if (flPercentage < 0.805 && flPercentage >= 0.605) 
								{
									flWalkSpeed += (flWalkSpeed * 0.05);
									flSprintSpeed += (flSprintSpeed * 0.05);
								}
								else if (flPercentage < 0.605 && flPercentage >= 0.405) 
								{
									flWalkSpeed += (flWalkSpeed * 0.1);
									flSprintSpeed += (flSprintSpeed * 0.1);
								}
								else if (flPercentage < 0.405 && flPercentage >= 0.205)
								{
									flWalkSpeed += (flWalkSpeed * 0.15);
									flSprintSpeed += (flSprintSpeed * 0.15);
								}
								else if (flPercentage < 0.205)
								{
									flWalkSpeed += (flWalkSpeed * 0.2);
									flSprintSpeed += (flSprintSpeed * 0.2);
								}
							}
						}
					}
					
					// Speed buff
					if (!SF_IsSlaughterRunMap())
					{
						if (TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly))
						{
							flWalkSpeed += (flWalkSpeed * 0.115);
							flSprintSpeed += (flSprintSpeed * 0.165);
						}
					}
					else
					{
						if (TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly))
						{
							flWalkSpeed += (flWalkSpeed * 0.105);
							flSprintSpeed += (flSprintSpeed * 0.14);
						}
					}
					
					if (bDanger)
					{
						if (TF2_GetPlayerClass(client) != TFClass_Spy && TF2_GetPlayerClass(client) != TFClass_Pyro)
						{
							flWalkSpeed *= 1.34;
							flSprintSpeed *= 1.34;
						}
						else
						{
							if (TF2_GetPlayerClass(client) == TFClass_Spy)
							{
								flWalkSpeed *= 1.26;
								flSprintSpeed *= 1.26;
							}
							else
							{
								iWeapon = INVALID_ENT_REFERENCE;
								for (int iSlot = 0; iSlot <= 5; iSlot++)
								{
									iWeapon = GetPlayerWeaponSlot(client, iSlot);
									if (!iWeapon || iWeapon == INVALID_ENT_REFERENCE) continue;
									
									int iItemDef = GetEntProp(iWeapon, Prop_Send, "m_iItemDefinitionIndex");
									if (iItemDef == 214 && GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon") == iWeapon)
									{
										flWalkSpeed *= 1.32;
										flSprintSpeed *= 1.32;
									}
									else
									{
										flWalkSpeed *= 1.34;
										flSprintSpeed *= 1.34;
									}
								}
							}
						}
						
						if (!g_bPlayerHints[client][PlayerHint_Sprint])
						{
							ClientShowHint(client, PlayerHint_Sprint);
						}
					}
					
					float flSprintSpeedSubtract = ((flSprintSpeed - flWalkSpeed) * 0.5);
					float flWalkSpeedSubtract = ((flSprintSpeed - flWalkSpeed) * 0.35);
					if (g_iPlayerSprintPoints[client] > 7)
					{
						flSprintSpeedSubtract -= flSprintSpeedSubtract * (g_iPlayerSprintPoints[client] != 0 ? (float(g_iPlayerSprintPoints[client]) / 100.0) : 0.0);
						flSprintSpeed -= flSprintSpeedSubtract;
					}
					else
					{
						flSprintSpeedSubtract += 25;
						flSprintSpeed -= flSprintSpeedSubtract;
						flWalkSpeedSubtract += 15;
						flWalkSpeed -= flWalkSpeedSubtract;
					}
					
					if (IsClientSprinting(client)) 
					{
						if (!g_bPlayerTrapped[client])
						{
							if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_bRenevant90sEffect)
							{
								if(!TF2_IsPlayerInCondition(client, TFCond_Charging))
								{
									SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flSprintSpeed);
								}
								else
								{
									if (SF_IsBoxingMap() || SF_IsRaidMap()) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flSprintSpeed*2.5);
									else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flSprintSpeed/2.5);
								}
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flSprintSpeed-170.0);
							}
							else
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 520.0);
								SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flSprintSpeed-170.0);
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
						if (!g_bPlayerTrapped[client])
						{
							if(!TF2_IsPlayerInCondition(client, TFCond_Charging))
							{
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flWalkSpeed);
							}
							else
							{
								if (SF_IsBoxingMap() || SF_IsRaidMap()) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flWalkSpeed*2.5);
								else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flWalkSpeed/2.5);
							}
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", flWalkSpeed-20.0);
						}
						else
						{
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 0.1);
							SetEntPropFloat(client, Prop_Send, "m_flCurrentTauntMoveSpeed", 0.1);
						}
					}
					
					if (ClientCanBreath(client) && !g_bPlayerBreath[client])
					{
						ClientStartBreathing(client);
					}
					
					if (g_bPlayerTrapped[client])
					{
						TF2Attrib_SetByName(client, "increased jump height", 0.0);
					}
					else
					{
						TF2Attrib_SetByName(client, "increased jump height", 1.0);
					}
				}
			}
			else if (g_bPlayerProxy[client] && GetClientTeam(client) == TFTeam_Blue)
			{
				TFClassType iClass = TF2_GetPlayerClass(client);
				bool bSpeedup = TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly);
			
				switch (iClass)
				{
					case TFClass_Scout:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 390.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					case TFClass_Medic:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 370.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					case TFClass_Spy:
					{
						if (bSpeedup || g_bProxySurvivalRageMode) SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 370.0);
						else SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", 300.0);
					}
					default:
					{
						if (g_bProxySurvivalRageMode)
						{
							float flRageSpeed = ClientGetDefaultSprintSpeed(client)+30.0;
							SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", flRageSpeed);
						}
					}
				}
			}
		}
	}
	if (g_bPlayerEliminated[client] && IsClientInPvP(client))
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
	if (IsRoundInWarmup() || (IsRoundInIntro() && !g_bPlayerEliminated[client]) || IsRoundEnding()) //I told you, stop breaking my plugin
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
	if (GetGameTime() >= g_flPlayerStressNextUpdateTime[client])
	{
		//float flPagePercent = g_iPageMax != 0 ? float(g_iPageCount) / float(g_iPageMax) : 0.0;
		//float flPageCountPercent = g_iPageMax != 0? float(g_iPlayerPageCount[client]) / float(g_iPageMax) : 0.0;
		
		g_flPlayerStressNextUpdateTime[client] = GetGameTime() + 0.33;
		ClientAddStress(client, -0.01);
		
#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_PLAYER_STRESS, 1, "g_flPlayerStress[%d]: %0.1f", client, g_flPlayerStress[client]);
#endif
	}
	
	// Process screen shake, if enabled.
	if (g_bPlayerShakeEnabled)
	{
		bool bDoShake = false;
		
		if (IsPlayerAlive(client))
		{
			int iStaticMaster = NPCGetFromUniqueID(g_iPlayerStaticMaster[client]);
			if (iStaticMaster != -1 && NPCGetFlags(iStaticMaster) & SFF_HASVIEWSHAKE)
			{
				bDoShake = true;
			}
		}
		
		if (bDoShake)
		{
			float flPercent = g_flPlayerStaticAmount[client];
			
			float flAmplitudeMax = g_cvPlayerShakeAmplitudeMax.FloatValue;
			float flAmplitude = flAmplitudeMax * flPercent;
			
			float flFrequencyMax = g_cvPlayerShakeFrequencyMax.FloatValue;
			float flFrequency = flFrequencyMax * flPercent;
			
			UTIL_ClientScreenShake(client, flAmplitude, 0.5, flFrequency);
		}
	}
	
	if(g_flLastVisibilityProcess[client]+0.30>=GetGameTime()) return;
	

	/*if (!g_bPlayerEliminated[client])
	{
		CNavArea targetArea = SDK_GetLastKnownArea(client);//SDK_GetLastKnownArea(client) =/= g_lastNavArea[client], SDK_GetLastKnownArea() retrives the nav area stored by the server
		if (targetArea != INVALID_NAV_AREA)
		{
			ClientNavAreaUpdate(client, g_lastNavArea[client], targetArea);
			g_lastNavArea[client] = targetArea;
		}
	}*/
	
	g_flLastVisibilityProcess[client] = GetGameTime();
	
	ClientProcessVisibility(client);
}

public Action Hook_ClientOnTakeDamage(int victim,int &attacker,int &inflictor, float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3],int damagecustom)
{
	if (!g_bEnabled) return Plugin_Continue;

	Action iAction = Plugin_Continue;

	float damage2 = damage;
	Call_StartForward(fOnClientTakeDamage);
	Call_PushCell(victim);
	Call_PushCell(attacker);
	Call_PushFloatRef(damage2);
	Call_Finish(iAction);
	
	if (iAction == Plugin_Changed) 
	{
		damage = damage2;
		return Plugin_Changed;
	}

	if (IsRoundInWarmup() && IsValidClient(attacker))
	{
		float flModelScale = GetEntPropFloat(attacker, Prop_Send, "m_flModelScale");
		float flHeadScale = GetEntPropFloat(attacker, Prop_Send, "m_flHeadScale");
		float flTorsoScale = GetEntPropFloat(attacker, Prop_Send, "m_flTorsoScale");
		float flHandScale = GetEntPropFloat(attacker, Prop_Send, "m_flHandScale");
		if (flModelScale < 1.0 || flModelScale > 1.0 || flHeadScale < 1.0 || flHeadScale > 1.0 || flTorsoScale < 1.0 || flTorsoScale > 1.0 || flHandScale < 1.0 || flHandScale > 1.0)
		{
			damage = 0.0; //So how does it feel?
			return Plugin_Changed;
		}
	}
	
	if (IsClientInKart(victim) && (attacker == 0 || inflictor == 0))
	{
		damage = 0.0;
		return Plugin_Changed;
	}
	
	char inflictorClass[32];
	if(inflictor >= 0) GetEdictClassname(inflictor, inflictorClass, sizeof(inflictorClass));

	if (IsValidClient(attacker) && IsValidClient(victim) && g_bPlayerProxy[attacker] && GetClientTeam(victim) == TFTeam_Red && TF2_IsPlayerInCondition(victim, TFCond_Gas))
	{
		TF2_IgnitePlayer(victim, victim);
		TF2_RemoveCondition(victim, TFCond_Gas);
	}

	if(IsValidClient(attacker) && IsValidClient(victim) && IsClientInPvP(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && victim != attacker)
	{
		damage = 0.0;
		return Plugin_Changed;
	}
	
	if (IsValidClient(attacker) && IsValidClient(victim) && GetClientTeam(victim) == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && g_bPlayerTrapped[victim])
	{
		if (!g_bPlayerEliminated[attacker] && !g_bPlayerEliminated[victim])
		{
			if (damagetype & 0x80) // 0x80 == melee damage
			{
				g_bPlayerTrapped[victim] = false;
				TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				TF2_AddCondition(victim, TFCond_SpeedBuffAlly, 4.0);
			}
		}
	}

	char classname[64];

	if (IsEntityAProjectile(inflictor))
	{
		int npcIndex = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex != -1)
		{
			bool bAttackEliminated = view_as<bool>(NPCGetFlags(npcIndex) & SFF_ATTACKWAITERS);
			if(!bAttackEliminated && (GetClientTeam(victim) == TFTeam_Blue) && IsValidClient(victim) )
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}

	// Prevent telefrags
	if ((damagetype & DMG_CRUSH) && damage > 500.0)
	{
		int iBossIndex = NPCGetFromEntIndex(attacker);
		if (iBossIndex != -1 && IsValidClient(victim))
		{
			damage = 0.0;
			RemoveSlender(iBossIndex);
			return Plugin_Changed;
		}
	}

	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && strcmp(classname, "tf_projectile_rocket") == 0 && (ProjectileGetFlags(inflictor) & PROJ_ICEBALL))
	{
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1 && IsValidClient(victim))
			{
				int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
				if(g_sSlenderIceballImpactSound[iBossIndex][0] == '\0')
				{
					g_sSlenderIceballImpactSound[iBossIndex] = ICEBALL_IMPACT;
				}
				EmitSoundToClient(victim, g_sSlenderIceballImpactSound[iBossIndex], _, MUSIC_CHAN);
				SDKHooks_TakeDamage(victim, inflictor, inflictor, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_StunPlayer(victim, NPCChaserGetIceballSlowdownDuration(iBossIndex, iDifficulty), NPCChaserGetIceballSlowdownPercent(iBossIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, victim);
			}
		}
	}
	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && strcmp(classname, "tf_projectile_rocket") == 0 && (ProjectileGetFlags(inflictor) & PROJ_ICEBALL_ATTACK))
	{
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1 && IsValidClient(victim))
			{
				int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
				int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
				EmitSoundToClient(victim, ICEBALL_IMPACT, _, MUSIC_CHAN);
				SDKHooks_TakeDamage(victim, inflictor, inflictor, NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_StunPlayer(victim, NPCChaserGetAttackProjectileIceSlowdownDuration(iBossIndex, iAttackIndex, iDifficulty), NPCChaserGetAttackProjectileIceSlowdownPercent(iBossIndex, iAttackIndex, iDifficulty), TF_STUNFLAG_SLOWDOWN, victim);
			}
		}
	}
	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && strcmp(classname, "tf_projectile_rocket") == 0 && (ProjectileGetFlags(inflictor) & PROJ_FIREBALL))
	{
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1 && IsValidClient(victim))
			{
				int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
				SDKHooks_TakeDamage(victim, inflictor, inflictor, NPCChaserGetProjectileDamage(iBossIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_IgnitePlayer(victim, victim);
			}
		}
	}

	if (IsValidEntity(inflictor) && GetEntityClassname(inflictor, classname, sizeof(classname)) && strcmp(classname, "tf_projectile_rocket") == 0 && (ProjectileGetFlags(inflictor) & PROJ_FIREBALL_ATTACK))
	{
		int slender = GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity");
		if(slender != INVALID_ENT_REFERENCE)
		{
			int iBossIndex = NPCGetFromEntIndex(slender);
			if (iBossIndex != -1 && IsValidClient(victim))
			{
				int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
				int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
				SDKHooks_TakeDamage(victim, inflictor, inflictor, NPCChaserGetAttackProjectileDamage(iBossIndex, iAttackIndex, iDifficulty), DMG_SHOCK|DMG_ALWAYSGIB);
				TF2_IgnitePlayer(victim, victim);
			}
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
						char sWeaponClass[64];
						GetEdictClassname(weapon, sWeaponClass, sizeof(sWeaponClass));
						
						// Backstab check!
						if ((strcmp(sWeaponClass, "tf_weapon_knife") == 0 || (TF2_GetPlayerClass(attacker) == TFClass_Spy && strcmp(sWeaponClass, "saxxy") == 0)) &&
							(damagecustom != TF_CUSTOM_TAUNT_FENCING))
						{
							float flMyPos[3], flHisPos[3], flMyDirection[3];
							GetClientAbsOrigin(victim, flMyPos);
							GetClientAbsOrigin(attacker, flHisPos);
							GetClientEyeAngles(victim, flMyDirection);
							GetAngleVectors(flMyDirection, flMyDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flMyDirection, flMyDirection);
							ScaleVector(flMyDirection, 32.0);
							AddVectors(flMyDirection, flMyPos, flMyDirection);

							float p[3], s[3];
							MakeVectorFromPoints(flMyPos, flHisPos, p);
							MakeVectorFromPoints(flMyPos, flMyDirection, s);
							if (GetVectorDotProduct(p, s) <= 0.0)//We can backstab him m8
							{
								if (GetClientTeam(victim) == GetClientTeam(attacker) && TF2_GetPlayerClass(victim) == TFClass_Sniper)
								{
									//look if the player has a razorback
									int iWearable = INVALID_ENT_REFERENCE;
									while ((iWearable = FindEntityByClassname(iWearable, "tf_wearable")) != -1)
									{
										if (GetEntPropEnt(iWearable, Prop_Send, "m_hOwnerEntity") == victim && GetEntProp(iWearable, Prop_Send, "m_iItemDefinitionIndex") == 57)
										{
											RemoveEntity(iWearable);
											damage = 0.0;
											EmitSoundToClient(victim, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
											EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);

											SetEntPropFloat(weapon, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
											SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
											int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
											if (vm > MaxClients)
											{
												int iMeleeIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
												int anim = 41;
												switch (iMeleeIndex)
												{
													case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968: anim = 15;
													case 638: anim = 31;
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
									if (damagetype & DMG_ACID) damage = 120.0;
								}
								
								ConVar hCvar = FindConVar("tf_weapon_criticals");
								if (hCvar != null && hCvar.BoolValue) damagetype |= DMG_ACID;
								
								if (!IsClientCritUbercharged(victim))
								{
									if (GetClientTeam(victim) == GetClientTeam(attacker))
									{
										int iPistol = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
										if (iPistol > MaxClients && GetEntProp(iPistol, Prop_Send, "m_iItemDefinitionIndex") == 525) //Give one crit fort the backstab
										{
											int iCrits = GetEntProp(attacker, Prop_Send, "m_iRevengeCrits");
											iCrits++;
											SetEntProp(attacker, Prop_Send, "m_iRevengeCrits", iCrits);
										}
									}
									if (GetEntProp(victim, Prop_Send, "m_iHealth") <= 120) g_bBackStabbed[victim] = true;
									else g_bBackStabbed[victim] = false;
								}
								return Plugin_Changed;
							}
						}
					}
				}
			}
			else if (g_bPlayerProxy[victim] || g_bPlayerProxy[attacker])
			{
				if (g_bPlayerEliminated[attacker] == g_bPlayerEliminated[victim])
				{
					damage = 0.0;
					return Plugin_Changed;
				}
				
				if (attacker == victim)//Don't allow proxy to self regenerate control.
				{
					return Plugin_Continue;
				}
				
				if (g_bPlayerProxy[attacker])
				{
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, victim);
					int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[attacker]);
					NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
					if (iMaster != -1 && sProfile[0] != '\0')
					{
						int iDifficulty = GetLocalGlobalDifficulty(iMaster);
						if (damagecustom == TF_CUSTOM_TAUNT_GRAND_SLAM ||
							damagecustom == TF_CUSTOM_TAUNT_FENCING ||
							damagecustom == TF_CUSTOM_TAUNT_ARROW_STAB ||
							damagecustom == TF_CUSTOM_TAUNT_GRENADE ||
							damagecustom == TF_CUSTOM_TAUNT_BARBARIAN_SWING ||
							damagecustom == TF_CUSTOM_TAUNT_ENGINEER_ARM ||
							damagecustom == TF_CUSTOM_TAUNT_ARMAGEDDON)
						{
							if (damage >= float(iMaxHealth)) damage = float(iMaxHealth) * 0.5;
							else damage = 0.0;
						}
						else if (damagecustom == TF_CUSTOM_BACKSTAB) // Modify backstab damage.
						{
							damage = float(iMaxHealth) * g_flSlenderProxyDamageVsBackstab[iMaster][iDifficulty];
							if (damagetype & DMG_ACID) damage /= 2.0;
						}
					
						g_iPlayerProxyControl[attacker] += g_iSlenderProxyControlGainHitEnemy[iMaster][iDifficulty];
						if (g_iPlayerProxyControl[attacker] > 100)
						{
							g_iPlayerProxyControl[attacker] = 100;
						}

						float flOriginalPercentage = g_flSlenderProxyDamageVsEnemy[iMaster][iDifficulty];
						float flAdditionPercentage = 0.15;

						if (TF2_GetPlayerClass(victim) == TFClass_Medic) damage *= (flOriginalPercentage + flAdditionPercentage);
						else damage *= flOriginalPercentage;
					}
					return Plugin_Changed;
				}
				else if (g_bPlayerProxy[victim])
				{
					char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
					int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[victim]);
					NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
					if (iMaster != -1 && sProfile[0] != '\0')
					{
						int iDifficulty = GetLocalGlobalDifficulty(iMaster);
						g_iPlayerProxyControl[attacker] += g_iSlenderProxyControlGainHitByEnemy[iMaster][iDifficulty];
						if (g_iPlayerProxyControl[attacker] > 100)
						{
							g_iPlayerProxyControl[attacker] = 100;
						}
						
						damage *= g_flSlenderProxyDamageVsSelf[iMaster][iDifficulty];
					}
					if(TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))
					{
						damage=0.0;
					}
					if( damage * ( damagetype & DMG_CRIT ? 3.0 : 1.0 ) >= float(GetClientHealth(victim)) && !TF2_IsPlayerInCondition(victim, view_as<TFCond>(87)))//The proxy is about to die
					{
						char sClassName[64];
						char sSectionName[64];
						char sBuffer[PLATFORM_MAX_PATH];
						TF2_GetClassName(TF2_GetPlayerClass(victim), sClassName, sizeof(sClassName));
		
						FormatEx(sSectionName, sizeof(sSectionName), "proxies_death_anim_%s", sClassName);
						if ((GetProfileString(sProfile, sSectionName, sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0') ||
						(GetProfileString(sProfile, "proxies_death_anim_all", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0'))
						{
							FormatEx(sSectionName, sizeof(sSectionName), "proxies_death_anim_frames_%s", sClassName);
							g_iClientMaxFrameDeathAnim[victim]=GetProfileNum(sProfile, sSectionName, 0);
							if(g_iClientMaxFrameDeathAnim[victim]==0)
								g_iClientMaxFrameDeathAnim[victim]=GetProfileNum(sProfile, "proxies_death_anim_frames_all", 0);
							if(g_iClientMaxFrameDeathAnim[victim]>0)
							{
								// Cancel out any other taunts.
								if(TF2_IsPlayerInCondition(victim, TFCond_Taunting)) TF2_RemoveCondition(victim, TFCond_Taunting);
								//The model has a death anim play it.
								SDK_PlaySpecificSequence(victim,sBuffer);
								g_iClientFrame[victim]=0;
								RequestFrame(ProxyDeathAnimation,victim);
								TF2_AddCondition(victim, view_as<TFCond>(87), 5.0);
								//Prevent death, and show the damage to the attacker.
								TF2_AddCondition(victim, view_as<TFCond>(70), 0.5);
								return Plugin_Changed;
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
			if (g_bPlayerEliminated[attacker] == g_bPlayerEliminated[victim])
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

public Action Timer_ClientSprinting(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerSprintTimer[client]) return Plugin_Stop;
	
	if (!IsClientSprinting(client)) return Plugin_Stop;
	
	if (g_iPlayerSprintPoints[client] <= 0)
	{
		ClientStopSprint(client);
		g_iPlayerSprintPoints[client] = 0;
		return Plugin_Stop;
	}

	if (IsClientReallySprinting(client)) 
	{
		int iOverride = g_cvPlayerInfiniteSprintOverride.IntValue;
		if ((!g_bRoundInfiniteSprint && iOverride != 1) || iOverride == 0)
		{
			g_iPlayerSprintPoints[client]--;
		}
	}
	
	ClientSprintTimer(client);

	return Plugin_Stop;
}

public void Hook_ClientSprintingPreThink(int client)
{
	if (!IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		return;
	}
	
	int iFOV = GetEntData(client, g_offsPlayerDefaultFOV);
	
	int iTargetFOV = g_iPlayerDesiredFOV[client] + 10;
	
	if (iFOV < iTargetFOV)
	{
		int iDiff = RoundFloat(FloatAbs(float(iFOV - iTargetFOV)));
		if (iDiff >= 1)
		{
			ClientSetFOV(client, iFOV + 1);
		}
		else
		{
			ClientSetFOV(client, iTargetFOV);
		}
	}
	else if (iFOV >= iTargetFOV)
	{
		ClientSetFOV(client, iTargetFOV);
		//SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	}
}

public void Hook_ClientRechargeSprintPreThink(int client)
{
	if (IsClientReallySprinting(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
		SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		return;
	}
	
	int iFOV = GetEntData(client, g_offsPlayerDefaultFOV);
	if (iFOV > g_iPlayerDesiredFOV[client])
	{
		int iDiff = RoundFloat(FloatAbs(float(iFOV - g_iPlayerDesiredFOV[client])));
		if (iDiff >= 1)
		{
			ClientSetFOV(client, iFOV - 1);
		}
		else
		{
			ClientSetFOV(client, g_iPlayerDesiredFOV[client]);
		}
	}
	else if (iFOV <= g_iPlayerDesiredFOV[client])
	{
		ClientSetFOV(client, g_iPlayerDesiredFOV[client]);
	}
}

public Action Timer_ClientRechargeSprint(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	float flVelSpeed[3];
	GetEntPropVector(client, Prop_Data, "m_vecBaseVelocity", flVelSpeed);
	float flSpeed = GetVectorLength(flVelSpeed, true);
	
	if (timer != g_hPlayerSprintTimer[client]) return Plugin_Stop;
	
	if (IsClientSprinting(client)) 
	{
		g_hPlayerSprintTimer[client] = null;
		return Plugin_Stop;
	}
	
	if (g_iPlayerSprintPoints[client] >= 100)
	{
		g_iPlayerSprintPoints[client] = 100;
		g_hPlayerSprintTimer[client] = null;
		return Plugin_Stop;
	}
	if ((!GetEntProp(client, Prop_Send, "m_bDucking") && !GetEntProp(client, Prop_Send, "m_bDucked")) || (GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked") && IsClientReallySprinting(client) || flSpeed > 0.0))
	{
		g_iPlayerSprintPoints[client]++;
	}
	else if ((GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked")) && !IsClientReallySprinting(client) && flSpeed == 0.0)
	{
		if (!SF_SpecialRound(SPECIALROUND_COFFEE)) g_iPlayerSprintPoints[client] += 2;
		else g_iPlayerSprintPoints[client] += 1;
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
				if (!g_bPlayerEliminated[client])
				{
					if (!IsRoundEnding() && 
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!DidClientEscape(client))
					{
						g_bPlayerHoldingBlink[client] = true;
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
				if (!g_bPlayerEliminated[client])
				{
					if (!IsRoundEnding() && 
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!DidClientEscape(client))
					{
						g_bPlayerHoldingBlink[client] = false;
					}
				}
			}
		}
	}
}

void ClientOnJump(int client)
{
	if (!g_bPlayerEliminated[client])
	{
		if (!IsRoundEnding() && !IsRoundInWarmup() && !DidClientEscape(client))
		{
			int iOverride = g_cvPlayerInfiniteSprintOverride.IntValue;
			if ((!g_bRoundInfiniteSprint && iOverride != 1) || iOverride == 0 && !g_bPlayerTrapped[client])
			{
				if(g_iPlayerSprintPoints[client] >= 2)
				{
					g_iPlayerSprintPoints[client] -= 7;
					if (g_iPlayerSprintPoints[client] <= 0) g_iPlayerSprintPoints[client] = 0;
				}
			}
			
			if (!IsClientSprinting(client))
			{
				if (g_hPlayerSprintTimer[client] == null)
				{
					// If the player hasn't sprinted recently, force us to regenerate the stamina.
					ClientSprintTimer(client, true);
				}
			}
			if (g_bPlayerTrapped[client])
				g_iPlayerTrapCount[client] -= 1;
			if (g_bPlayerTrapped[client] && g_iPlayerTrapCount[client] <= 1)
			{
				g_bPlayerTrapped[client] = false;
				g_iPlayerTrapCount[client] = 0;
			}
		}
	}
}

public Action Timer_GhostModeConnectionCheck(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerGhostModeConnectionCheckTimer[client]) return Plugin_Stop;
	
	if (!IsFakeClient(client) && IsClientTimingOut(client))
	{
		float bootTime = g_flPlayerGhostModeConnectionBootTime[client];
		bool Check = g_cvGhostModeConnection.BoolValue;
		if (bootTime < 0.0 && !Check)
		{
			bootTime = GetGameTime() + g_cvGhostModeConnectionTolerance.FloatValue;
			g_flPlayerGhostModeConnectionBootTime[client] = bootTime;
			g_flPlayerGhostModeConnectionTimeOutTime[client] = GetGameTime();
		}
		
		if (GetGameTime() >= bootTime || Check)
		{
			ClientSetGhostModeState(client, false);
			TF2_RespawnPlayer(client);
			
			char authString[128];
			GetClientAuthId(client,AuthId_Engine, authString, sizeof(authString));
			
			LogSF2Message("Removed %N (%s) from ghost mode due to timing out for %f seconds", client, authString, g_cvGhostModeConnectionTolerance.FloatValue);
			
			float timeOutTime = g_flPlayerGhostModeConnectionTimeOutTime[client];
			CPrintToChat(client, "\x08FF4040FF%T", "SF2 Ghost Mode Bad Connection", client, RoundFloat(bootTime - timeOutTime));
			
			return Plugin_Stop;
		}
	}
	else
	{
		// Player regained connection; reset.
		g_flPlayerGhostModeConnectionBootTime[client] = -1.0;
	}
	
	return Plugin_Continue;
}

public Action Timer_ClientCheckCamp(Handle timer, any userid)
{
	if (IsRoundInWarmup()) return Plugin_Stop;

	int client = GetClientOfUserId(userid);
	if (client <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerCampingTimer[client]) return Plugin_Stop;
	
	if (IsRoundEnding() || !IsPlayerAlive(client) || g_bPlayerEliminated[client] || DidClientEscape(client)) return Plugin_Stop;
	
	if (!g_bPlayerCampingFirstTime[client])
	{
		bool bCamping = false;
		float flPos[3], flMaxs[3], flMins[3];
		GetClientAbsOrigin(client, flPos);
		GetEntPropVector(client, Prop_Send, "m_vecMins", flMins);
		GetEntPropVector(client, Prop_Send, "m_vecMaxs", flMaxs);
		
		// Only do something if the player is NOT stuck.
		float flDistFromLastPosition = GetVectorSquareMagnitude(g_flPlayerCampingLastPosition[client], flPos);
		float flDistFromClosestBoss = 9999999.0;
		int iClosestBoss = -1;
		
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1) continue;
			
			int iSlender = NPCGetEntIndex(i);
			if (!iSlender || iSlender == INVALID_ENT_REFERENCE) continue;
			
			float flSlenderPos[3];
			SlenderGetAbsOrigin(i, flSlenderPos);
			
			float flDist = GetVectorSquareMagnitude(flSlenderPos, flPos);
			if (flDist < flDistFromClosestBoss)
			{
				iClosestBoss = i;
				flDistFromClosestBoss = flDist;
			}
		}
		/*if(IsSpaceOccupiedIgnorePlayers(flPos, flMins, flMaxs, client))
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is stuck, no actions taken", client, client);*/
		if (!SF_IsBoxingMap() && g_cvCampingEnabled.BoolValue && 
		IsRoundPlaying() &&
			g_flPlayerStaticAmount[client] <= g_cvCampingNoStrikeSanity.FloatValue && 
			(iClosestBoss == -1 || flDistFromClosestBoss >= g_cvCampingNoStrikeBossDistance.FloatValue) &&
			flDistFromLastPosition <= SquareFloat(g_cvCampingMinDistance.FloatValue))
		{
			bCamping = true;
			//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is afk, or camping", client, client);
		}
		if(bCamping)
		{
			g_iPlayerCampingStrikes[client]++;
			if (g_iPlayerCampingStrikes[client] < g_cvCampingMaxStrikes.IntValue)
			{
				if (g_iPlayerCampingStrikes[client] >= g_cvCampingStrikesWarn.IntValue)
				{
					CPrintToChat(client, "{red}%T", "SF2 Camping System Warning", client, (g_cvCampingMaxStrikes.IntValue - g_iPlayerCampingStrikes[client]) * 5);
				}
			}
			else
			{
				g_iPlayerCampingStrikes[client] = 0;
				ClientStartDeathCam(client, 0, flPos, true);
			}
		}
		else
		{
			// Forgiveness.
			if (g_iPlayerCampingStrikes[client] > 0)
			{
				//LogSF2Message("[SF2 AFK TIMER] Client %i (%N) is forgiven of one strike.", client, client);
				g_iPlayerCampingStrikes[client]--;
			}
		}
		
		g_flPlayerCampingLastPosition[client][0] = flPos[0];
		g_flPlayerCampingLastPosition[client][1] = flPos[1];
		g_flPlayerCampingLastPosition[client][2] = flPos[2];
	}
	else
	{
		g_bPlayerCampingFirstTime[client] = false;
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

public Action Timer_ClientAverageUpdate(Handle timer)
{
	if (timer != g_hClientAverageUpdateTimer) return Plugin_Stop;
	
	if (!g_bEnabled) return Plugin_Stop;
	
	if (IsRoundInWarmup() || IsRoundEnding()) return Plugin_Continue;

	// First, process through HUD stuff.
	char buffer[256];
	
	static iHudColorHealthy[3];
	static iHudColorCritical[3] = { 255, 10, 10 };
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		if (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud) iHudColorHealthy = { 50, 255, 50 };
		else iHudColorHealthy = { 150, 255, 150 };
		
		if (IsPlayerAlive(i) && !IsClientInDeathCam(i))
		{
			if (!g_bPlayerEliminated[i])
			{
				if (DidClientEscape(i)) continue;
				
				int iMaxBars = 12;
				int iBars;
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					iBars = RoundToCeil(float(iMaxBars) * ClientGetBlinkMeter(i));
					if (iBars > iMaxBars) iBars = iMaxBars;
					
					if (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud)
					{
						if (iBars != 0) FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_ON);
						else FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OFF);
					}
					else FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OLD);
					
					if (IsInfiniteBlinkEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < iMaxBars; i2++)
						{
							if (i2 < iBars)
							{
								StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
							}
							else
							{
								StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
							}
						}
					}
				}
				if (!SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					iBars = RoundToCeil(float(iMaxBars) * ClientGetFlashlightBatteryLife(i));
					if (iBars > iMaxBars)iBars = iMaxBars;
					
					char sBuffer2[64];
					FormatEx(sBuffer2, sizeof(sBuffer2), "\n%s  ", SF2_PLAYER_HUD_FLASHLIGHT_SYMBOL);
					StrCat(buffer, sizeof(buffer), sBuffer2);
					
					if (IsInfiniteFlashlightEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < iMaxBars; i2++)
						{
							if (i2 < iBars)
							{
								StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
							}
							else
							{
								StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
							}
						}
					}
				}
				
				iBars = RoundToCeil(float(iMaxBars) * (float(ClientGetSprintPoints(i)) / 100.0));
				if (iBars > iMaxBars) iBars = iMaxBars;
				
				char sBuffer2[64];
				FormatEx(sBuffer2, sizeof(sBuffer2), "\n%s  ", SF2_PLAYER_HUD_SPRINT_SYMBOL);
				StrCat(buffer, sizeof(buffer), sBuffer2);
				
				if (IsInfiniteSprintEnabled())
				{
					StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
				}
				else
				{
					for (int i2 = 0; i2 < iMaxBars; i2++)
					{
						if (i2 < iBars)
						{
							StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
						}
					}
				}
				
				float flHealthRatio = float(GetEntProp(i, Prop_Send, "m_iHealth")) / float(SDKCall(g_hSDKGetMaxHealth, i));
				
				int iColor[3];
				for (int i2 = 0; i2 < 3; i2++)
				{
					iColor[i2] = RoundFloat(float(iHudColorHealthy[i2]) + (float(iHudColorCritical[i2] - iHudColorHealthy[i2]) * (1.0 - flHealthRatio)));
				}
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					SetHudTextParams(0.035, 0.83, 
						0.3, 
						iColor[0], 
						iColor[1], 
						iColor[2], 
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
						iColor[0], 
						iColor[1], 
						iColor[2], 
						40, 
						_, 
						1.0, 
						0.07, 
						0.5);
				}
				ShowSyncHudText(i, g_hHudSync2, buffer);
				buffer[0] = '\0';
			}
			else
			{
				if (g_bPlayerProxy[i])
				{
					int iMaxBars = 12;
					int iBars = RoundToCeil(float(iMaxBars) * (float(g_iPlayerProxyControl[i]) / 100.0));
					if (iBars > iMaxBars) iBars = iMaxBars;
					
					strcopy(buffer, sizeof(buffer), "CONTROL\n");
					
					for (int i2 = 0; i2 < iMaxBars; i2++)
					{
						if (i2 < iBars)
						{
							StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_iPlayerPreferences[i].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
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
					ShowSyncHudText(i, g_hHudSync2, buffer);
				}
			}
		}
		ClientUpdateListeningFlags(i);
		ClientUpdateMusicSystem(i);
	}
	
	return Plugin_Continue;
}
