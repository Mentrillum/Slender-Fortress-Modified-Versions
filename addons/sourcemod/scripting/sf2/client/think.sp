#if defined _sf2_clients_think_included
 #endinput
#endif
#define _sf2_clients_think_included

#pragma semicolon 1
#pragma newdecls required

void Hook_ClientPreThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	float gameTime = GetGameTime();

	ClientProcessFlashlightAngles(player.index);
	ClientProcessStaticShake(player.index);
	ClientProcessViewAngles(player.index);

	if ((player.IsTrapped || player.IsLatched) && !player.IsInGhostMode)
	{
		TF2Attrib_SetByName(player.index, "increased jump height", 0.0);
	}
	else
	{
		TF2Attrib_SetByName(player.index, "increased jump height", 1.0);
	}

	if (!player.IsEliminated && !player.HasEscaped)
	{
		if (!IsRoundEnding() && !IsRoundInWarmup())
		{
			player.SetPropFloat(Prop_Send, "m_flModelScale", 1.0);
			player.SetPropFloat(Prop_Send, "m_flHeadScale", 1.0);
			player.SetPropFloat(Prop_Send, "m_flTorsoScale", 1.0);
			player.SetPropFloat(Prop_Send, "m_flHandScale", 1.0);

			if (player.InCondition(TFCond_Disguised))
			{
				player.ChangeCondition(TFCond_Disguised, true);
			}

			if (player.InCondition(TFCond_Taunting) && (player.IsTrapped || player.IsLatched))
			{
				player.ChangeCondition(TFCond_Taunting, true);
			}

			if (player.InCondition(TFCond_Taunting) && (player.IsTrapped || player.IsLatched))
			{
				int weaponEnt = player.GetWeaponSlot(TFWeaponSlot_Melee);
				if (weaponEnt && weaponEnt != INVALID_ENT_REFERENCE)
				{
					int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
					if ((itemDefInt == 775 || itemDefInt == 128) && GetEntProp(client, Prop_Send, "m_iTauntIndex") == 0)
					{
						player.ChangeCondition(TFCond_Taunting, true); //Stop suiciding...
					}
				}
			}
		}

		if (gameTime >= g_PlayerStressNextUpdateTime[player.index])
		{
			g_PlayerStressNextUpdateTime[player.index] = gameTime + 0.33;
			ClientAddStress(player.index, -0.01);

			#if defined DEBUG
			SendDebugMessageToPlayer(player.index, DEBUG_PLAYER_STRESS, 1, "g_PlayerStressAmount[%d]: %0.1f", player.index, g_PlayerStressAmount[player.index]);
			#endif
		}
	}
	if (player.IsEliminated && (player.IsInPvP || player.IsInPvE))
	{
		player.SetPropFloat(Prop_Send, "m_flModelScale", 1.0);
		player.SetPropFloat(Prop_Send, "m_flHeadScale", 1.0);
		player.SetPropFloat(Prop_Send, "m_flTorsoScale", 1.0);
		player.SetPropFloat(Prop_Send, "m_flHandScale", 1.0);
		if (IsClientInKart(player.index))
		{
			player.ChangeCondition(TFCond_HalloweenKart, true);
			player.ChangeCondition(TFCond_HalloweenKartDash, true);
			player.ChangeCondition(TFCond_HalloweenKartNoTurn, true);
			player.ChangeCondition(TFCond_HalloweenKartCage, true);
		}
	}
	if (IsRoundInWarmup() || (IsRoundInIntro() && !player.IsEliminated) || IsRoundEnding()) //I told you, stop breaking my plugin
	{
		if (IsClientInKart(player.index))
		{
			player.ChangeCondition(TFCond_HalloweenKart, true);
			player.ChangeCondition(TFCond_HalloweenKartDash, true);
			player.ChangeCondition(TFCond_HalloweenKartNoTurn, true);
			player.ChangeCondition(TFCond_HalloweenKartCage, true);
		}
	}

	if (g_LastVisibilityProcess[player.index] + 0.30 >= GetGameTime())
	{
		return;
	}

	g_LastVisibilityProcess[player.index] = GetGameTime();

	ClientProcessVisibility(player.index);
}

Action Hook_ClientOnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	SF2_BasePlayer victimPlayer = SF2_BasePlayer(victim);
	if (!g_Enabled)
	{
		if (NPCGetFromEntIndex(attacker) != -1 && GetEntProp(attacker, Prop_Data, "m_iTeamNum") == victimPlayer.Team)
		{
			damage = 0.0;
			return Plugin_Changed;
		}
		return Plugin_Continue;
	}

	Action action = Plugin_Continue;

	float damage2 = damage;
	Call_StartForward(g_OnClientTakeDamageFwd);
	Call_PushCell(victimPlayer.index);
	Call_PushCellRef(attacker);
	Call_PushCellRef(inflictor);
	Call_PushFloatRef(damage2);
	Call_Finish(action);

	if (action == Plugin_Changed)
	{
		damage = damage2;
		return Plugin_Changed;
	}

	Call_StartForward(g_OnPlayerTakeDamagePFwd);
	Call_PushCell(victimPlayer);
	Call_PushCellRef(attacker);
	Call_PushCellRef(inflictor);
	Call_PushFloatRef(damage2);
	Call_PushCellRef(damagetype);
	Call_PushCell(damagecustom);
	Call_Finish(action);

	if (action == Plugin_Changed)
	{
		damage = damage2;
		return Plugin_Changed;
	}

	TFClassType class = victimPlayer.Class;

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

	if (IsClientInKart(victimPlayer.index) && (attacker == -1 || inflictor == -1))
	{
		damage = 0.0;
		return Plugin_Changed;
	}

	char inflictorClass[32];
	if (inflictor >= 0)
	{
		GetEdictClassname(inflictor, inflictorClass, sizeof(inflictorClass));
	}

	if (IsValidClient(attacker) && victimPlayer.IsValid && g_PlayerProxy[attacker] && victimPlayer.Team == TFTeam_Red && victimPlayer.InCondition(TFCond_Gas))
	{
		victimPlayer.Ignite(true);
		victimPlayer.ChangeCondition(TFCond_Gas, true);
	}

	if (victimPlayer.InCondition(TFCond_Gas) && SF2_ChaserEntity(attacker).IsValid())
	{
		victimPlayer.Ignite(true);
		victimPlayer.ChangeCondition(TFCond_Gas, true);
	}

	if (IsValidClient(attacker) && victimPlayer.IsValid && (victimPlayer.IsInPvP || victimPlayer.IsInPvE) && victimPlayer.Team == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && victim != attacker)
	{
		damage = 0.0;
		return Plugin_Changed;
	}

	if (IsValidClient(attacker) && victimPlayer.IsValid && victimPlayer.Team == TFTeam_Red && GetClientTeam(attacker) == TFTeam_Red && (victimPlayer.IsTrapped || victimPlayer.IsLatched))
	{
		if (!g_PlayerEliminated[attacker] && !victimPlayer.IsEliminated && (damagetype & 0x80) != 0)
		{
			victimPlayer.IsTrapped = false;
			if (victimPlayer.IsLatched)
			{
				victimPlayer.ChangeCondition(TFCond_Dazed, true);
				for (int i = 0; i < MAX_BOSSES; i++)
				{
					SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
					if (!npc.IsValid())
					{
						continue;
					}

					if (victimPlayer.Latcher != npc.Index)
					{
						continue;
					}

					SF2_ChaserEntity chaser = SF2_ChaserEntity(npc.EntIndex);
					if (!chaser.IsValid())
					{
						continue;
					}

					chaser.MyNextBotPointer().GetIntentionInterface().OnCommandString("break tongue");
				}
			}
			victimPlayer.IsLatched = false;
			victimPlayer.LatchCount = 0;
			TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
			TF2_AddCondition(victim, TFCond_SpeedBuffAlly, 4.0);
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
			if (itemDefInt == 416 && zVelocity[2] < 0.0 && weaponEnt == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon")) // A soldier has the market gardener and is currently falling down, like Minecraft with it's critical hits.
			{
				damagetype |= DMG_ACID;
			}
		}
	}

	if (!SF2_ChaserEntity(inflictor).IsValid() && !SF2_StatueEntity(inflictor).IsValid() && !IsValidClient(inflictor))
	{
		int npcIndex = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex != -1)
		{
			bool attackEliminated = (NPCGetFlags(npcIndex) & SFF_ATTACKWAITERS) != 0;
			if (!attackEliminated && (GetClientTeam(victim) == TFTeam_Blue) && IsValidClient(victim) )
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}

	bool canDamage = false;
	if (attacker != victim && IsValidClient(attacker))
	{
		if (IsClientInPvP(victim) && IsClientInPvP(attacker))
		{
			canDamage = true;
		}
		if (IsClientLeavingPvP(victim) && !IsClientInPvP(attacker))
		{
			canDamage = true;
		}
		if (!IsRoundEnding())
		{
			if (canDamage)
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
	}

	return Plugin_Continue;
}

void ClientOnButtonPress(SF2_BasePlayer client, int button)
{
	switch (button)
	{
		case IN_ATTACK2:
		{
			if (client.IsAlive)
			{
				if (!IsRoundInWarmup() &&
					!IsRoundInIntro() &&
					!IsRoundEnding() &&
					!client.HasEscaped)
				{
					if (GetGameTime() >= client.GetFlashlightNextInputTime())
					{
						client.HandleFlashlight();
					}
				}
			}
		}
		case IN_ATTACK3:
		{
			client.HandleSprint(true);
		}
		case IN_RELOAD:
		{
			if (client.IsAlive)
			{
				if (!client.IsEliminated)
				{
					if (!IsRoundEnding() &&
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!client.HasEscaped)
					{
						client.SetHoldingBlink(true);
						client.Blink();
					}
				}
			}
		}
		case IN_JUMP:
		{
			if (client.IsAlive && !(client.GetFlags() & FL_FROZEN))
			{
				if (!(client.GetProp(Prop_Send, "m_bDucked")) &&
					(client.GetFlags() & FL_ONGROUND) &&
					client.GetProp(Prop_Send, "m_nWaterLevel") < 2)
				{
					Call_StartForward(g_OnPlayerJumpPFwd);
					Call_PushCell(client);
					Call_Finish();
				}
			}
			if (client.IsInGhostMode)
			{
				client.SetGravity(0.0001);
			}
			else
			{
				client.SetGravity(1.0);
			}
		}
		case IN_DUCK:
		{
			if (client.IsInGhostMode)
			{
				client.SetGravity(4.0);
			}
			else
			{
				client.SetGravity(1.0);
			}
		}
	}
}

void ClientOnButtonRelease(SF2_BasePlayer client, int button)
{
	switch (button)
	{
		case IN_ATTACK3:
		{
			client.HandleSprint(false);
		}
		case IN_DUCK:
		{
			client.EndPeeking();

			if (client.IsInGhostMode)
			{
				client.SetGravity(0.5);
			}
			else
			{
				client.SetGravity(1.0);
			}
		}
		case IN_JUMP:
		{
			if (client.IsInGhostMode)
			{
				client.SetGravity(0.5);
			}
			else
			{
				client.SetGravity(1.0);
			}
		}
		case IN_RELOAD:
		{
			if (client.IsAlive)
			{
				if (!client.IsEliminated)
				{
					if (!IsRoundEnding() &&
						!IsRoundInWarmup() &&
						!IsRoundInIntro() &&
						!client.HasEscaped)
					{
						client.SetHoldingBlink(false);
					}
				}
			}
		}
	}
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
#define SF2_PLAYER_HUD_HEALTH_SYMBOL "♥"

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
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid)
		{
			continue;
		}
		if (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud)
		{
			hudColorHealthy = { 50, 255, 50 };
		}
		else
		{
			hudColorHealthy = { 150, 255, 150 };
		}

		if (player.IsAlive && !player.IsInDeathCam)
		{
			if (!player.IsEliminated)
			{
				if (player.HasEscaped)
				{
					continue;
				}

				int maxBars = 12;
				int bars;
				char buffer2[64];
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					float percent = float(player.Health) / float(player.MaxHealth);
					if (percent > 1.0)
					{
						percent = 1.0;
					}
					bars = RoundToCeil(float(maxBars) * percent);
					if (bars > maxBars)
					{
						bars = maxBars;
					}
					FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_HEALTH_SYMBOL);
					for (int i2 = 0; i2 < maxBars; i2++)
					{
						if (i2 < bars)
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
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
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
							}
							else
							{
								StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
							}
						}
					}
				}

				bars = RoundToCeil(float(maxBars) * player.Stamina);
				if (bars > maxBars)
				{
					bars = maxBars;
				}

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
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
						}
					}
				}

				float healthRatio = float(player.Health) / float(player.MaxHealth);
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
				ShowSyncHudText(player.index, g_HudSync2, buffer);
				if (!SF_IsRaidMap() && !SF_IsBoxingMap() && !IsInfiniteBlinkEnabled() && player.HasStartedBlinking)
				{
					bars = RoundToCeil(float(maxBars) * player.BlinkMeter);
					if (bars > maxBars)
					{
						bars = maxBars;
					}

					if (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud)
					{
						if (bars != 0)
						{
							FormatEx(buffer, sizeof(buffer), "\n%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_ON);
						}
						else
						{
							FormatEx(buffer, sizeof(buffer), "\n%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OFF);
						}
					}
					else
					{
						FormatEx(buffer, sizeof(buffer), "\n%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL_OLD);
					}

					for (int i2 = 0; i2 < maxBars; i2++)
					{
						if (i2 < bars)
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
						}
					}

					SetHudTextParams(0.8, 0.83,
						0.3,
						color[0],
						color[1],
						color[2],
						40,
						_,
						1.0,
						0.07,
						0.5);
					ShowSyncHudText(player.index, g_HudSync4, buffer);
				}
				buffer[0] = '\0';
			}
			else
			{
				if (player.IsProxy)
				{
					int maxBars = 12;
					int bars = RoundToCeil(float(maxBars) * (float(player.ProxyControl) / 100.0));
					if (bars > maxBars)
					{
						bars = maxBars;
					}

					strcopy(buffer, sizeof(buffer), "CONTROL\n");

					for (int i2 = 0; i2 < maxBars; i2++)
					{
						if (i2 < bars)
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_SYMBOL : SF2_PLAYER_HUD_BAR_SYMBOL_OLD));
						}
						else
						{
							StrCat(buffer, sizeof(buffer), (!g_PlayerPreferences[player.index].PlayerPreference_LegacyHud ? SF2_PLAYER_HUD_BAR_MISSING_SYMBOL : SF2_PLAYER_HUD_BAR_MISSING_SYMBOL_OLD));
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
					ShowSyncHudText(player.index, g_HudSync2, buffer);
				}
			}
		}
		player.UpdateListeningFlags();

		Call_StartForward(g_OnPlayerAverageUpdatePFwd);
		Call_PushCell(player);
		Call_Finish();
	}

	return Plugin_Continue;
}