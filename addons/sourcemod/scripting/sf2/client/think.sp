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

	ClientProcessFlashlightAngles(client);
	ClientProcessStaticShake(client);
	ClientProcessViewAngles(client);

	if ((g_PlayerTrapped[client] || g_PlayerLatchedByTongue[client]) && !IsClientInGhostMode(client))
	{
		TF2Attrib_SetByName(client, "increased jump height", 0.0);
	}
	else
	{
		TF2Attrib_SetByName(client, "increased jump height", 1.0);
	}

	if (IsClientInGhostMode(client))
	{
		SetEntityFlags(client, GetEntityFlags(client) ^ FL_EDICT_ALWAYS);
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

			if (!g_PlayerProxy[client] && GetClientTeam(client) == TFTeam_Red)
			{
				if (TF2_IsPlayerInCondition(client, TFCond_Disguised))
				{
					TF2_RemoveCondition(client, TFCond_Disguised);
				}

				if (TF2_IsPlayerInCondition(client, TFCond_Taunting) && (g_PlayerTrapped[client] || g_PlayerLatchedByTongue[client]))
				{
					TF2_RemoveCondition(client, TFCond_Taunting);
				}

				KeyMap modifiedWeapons = GetModifiedWeapons();
				if (modifiedWeapons != null && TF2_IsPlayerInCondition(client, TFCond_Taunting) && GetEntProp(client, Prop_Send, "m_iTauntIndex") == 0)
				{
					int weaponEnt = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
					if (weaponEnt && weaponEnt != INVALID_ENT_REFERENCE)
					{
						int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
						ModifiedWeaponObject usedObject = GetModifiedWeaponFromIndex(client, itemDefInt);
						if (usedObject != null && usedObject.BlockTaunts)
						{
							TF2_RemoveCondition(client, TFCond_Taunting);
						}
					}
				}

				if (roundState == 4)
				{

				}
			}
			else if (g_PlayerProxy[client] && GetClientTeam(client) == TFTeam_Blue)
			{
				int master = NPCGetFromUniqueID(g_PlayerProxyMaster[client]);

				float maxSpeed;
				bool override;

				if (master != -1)
				{
					char profile[SF2_MAX_PROFILE_NAME_LENGTH];
					NPCGetProfile(master, profile, sizeof(profile));

					override = GetBossProfileProxyOverrideMaxSpeed(profile);
					if (override)
					{
						int difficulty = GetLocalGlobalDifficulty(master);

						maxSpeed = GetBossProfileProxyMaxSpeed(profile, difficulty);
					}
				}

				bool speedup = TF2_IsPlayerInCondition(client, TFCond_SpeedBuffAlly);

				if (override)
				{
					if (speedup || g_InProxySurvivalRageMode)
					{
						float rageSpeed = maxSpeed + 30.0;
						SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", rageSpeed);
					}
					else
					{
						SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", maxSpeed);
					}
				}
				else
				{
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
								float rageSpeed = ClientGetDefaultSprintSpeed(client) + 30.0;
								SetEntPropFloat(client, Prop_Send, "m_flMaxspeed", rageSpeed);
							}
						}
					}
				}
			}
		}
	}
	if (g_PlayerEliminated[client] && (IsClientInPvP(client) || IsClientInPvE(client)))
	{
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(client, Prop_Send, "m_flHandScale", 1.0);
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client, TFCond_HalloweenKart);
			TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
		}
	}
	if (IsRoundInWarmup() || (IsRoundInIntro() && !g_PlayerEliminated[client]) || IsRoundEnding()) //I told you, stop breaking my plugin
	{
		if (IsClientInKart(client))
		{
			TF2_RemoveCondition(client, TFCond_HalloweenKart);
			TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
			TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
		}
	}

	// Calculate player stress levels.
	if (!g_PlayerEliminated[client] && !DidClientEscape(client) && GetGameTime() >= g_PlayerStressNextUpdateTime[client])
	{
		g_PlayerStressNextUpdateTime[client] = GetGameTime() + 0.33;
		ClientAddStress(client, -0.01);

		#if defined DEBUG
		SendDebugMessageToPlayer(client, DEBUG_PLAYER_STRESS, 1, "g_PlayerStressAmount[%d]: %0.1f", client, g_PlayerStressAmount[client]);
		#endif
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

void ClientOnButtonPress(SF2_BasePlayer client, int button)
{
	switch (button)
	{
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

	int hours, minutes, seconds;
	FloatToTimeHMS(float(g_RoundTime), hours, minutes, seconds);
	char addon[16];
	if (g_RoundTimer != null)
	{
		if (SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
		{
			FormatEx(addon, sizeof(addon), "\n??:??");
		}
		else
		{
			FormatEx(addon, sizeof(addon), "\n%d:%02d", minutes, seconds);
		}
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (g_RoundState != SF2RoundState_Active && g_RoundState != SF2RoundState_Escape)
		{
			continue;
		}
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid || player.IsBot || (player.IsEliminated && !player.IsInGhostMode))
		{
			continue;
		}

		SetHudTextParams(-1.0, 0.1,
			0.26,
			SF2_HUD_TEXT_COLOR_R,
			SF2_HUD_TEXT_COLOR_G,
			SF2_HUD_TEXT_COLOR_B,
			40,
			_,
			1.0,
			0.07,
			0.07);

		char text[512];
		switch (g_RoundState)
		{
			case SF2RoundState_Active:
			{
				FormatEx(text, sizeof(text), "%d/%d", g_PageCount, g_PageMax);
			}

			case SF2RoundState_Escape:
			{
				if (SF_IsBoxingMap())
				{
					FormatEx(text, sizeof(text), "%T", "SF2 Default Boxing Message", i);
				}
				else
				{
					if (SF_IsSurvivalMap() && g_RoundTime > g_TimeEscape)
					{
						FormatEx(text, sizeof(text), "%T", "SF2 Default Survive Message", i);
					}
					else
					{
						FormatEx(text, sizeof(text), "%T", "SF2 Default Escape Message", i);
					}
				}
			}
		}
		StrCat(text, sizeof(text), addon);
		ShowSyncHudText(player.index, g_RoundTimerSync, text);
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
					StrCat(buffer, sizeof(buffer), "\n");
				}

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
					FormatEx(buffer2, sizeof(buffer2), "%s  ", SF2_PLAYER_HUD_HEALTH_SYMBOL);
					StrCat(buffer, sizeof(buffer), buffer2);
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
					float yPos = 0.83;
					if (player.HasStartedBlinking)
					{
						yPos = 0.756;
					}
					SetHudTextParams(0.035, yPos,
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