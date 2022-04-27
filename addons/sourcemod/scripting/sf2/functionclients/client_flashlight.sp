#if defined _sf2_client_flashlight_included
 #endinput
#endif
#define _sf2_client_flashlight_included

#define SF2_ULTRAVISION_CONE 180.0

public Action Timer_DrainFlashlight(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}
	
	if (timer != g_PlayerFlashlightBatteryTimer[client])
	{
		return Plugin_Stop;
	}
	
	if (!IsInfiniteFlashlightEnabled())
	{
		ClientSetFlashlightBatteryLife(client, ClientGetFlashlightBatteryLife(client) - 0.01);
	}
	
	if (ClientGetFlashlightBatteryLife(client) <= 0.0)
	{
		// Break the player's flashlight, but also start recharging.
		ClientBreakFlashlight(client);
		ClientStartRechargingFlashlightBattery(client);
		ClientActivateUltravision(client);
		return Plugin_Stop;
	}
	else
	{
		ClientHandleFlashlightFlickerState(client);
	}
	
	return Plugin_Continue;
}

public Action Timer_RechargeFlashlight(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}
	
	if (timer != g_PlayerFlashlightBatteryTimer[client])
	{
		return Plugin_Stop;
	}
	
	ClientSetFlashlightBatteryLife(client, ClientGetFlashlightBatteryLife(client) + 0.01);
	
	if (IsClientFlashlightBroken(client) && ClientGetFlashlightBatteryLife(client) >= SF2_FLASHLIGHT_ENABLEAT)
	{
		// Repair the flashlight.
		g_PlayerFlashlightBroken[client] = false;
	}
	
	if (ClientGetFlashlightBatteryLife(client) >= 1.0)
	{
		// I am fully charged!
		ClientSetFlashlightBatteryLife(client, 1.0);
		g_PlayerFlashlightBatteryTimer[client] = null;
		
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}

bool IsClientUsingFlashlight(int client)
{
	return g_PlayerHasFlashlight[client];
}

float ClientGetFlashlightBatteryLife(int client)
{
	return g_PlayerFlashlightBatteryLife[client];
}

void ClientSetFlashlightBatteryLife(int client, float flPercent)
{
	g_PlayerFlashlightBatteryLife[client] = flPercent;
}

/**
 *	Called in Hook_ClientPreThink, this makes sure the flashlight is oriented correctly on the player.
 */
void ClientProcessFlashlightAngles(int client)
{
	if (!IsClientInGame(client))
	{
		return;
	}
	
	if (IsPlayerAlive(client))
	{
		int fl;
		float eyeAng[3], ang2[3];
		
		if (IsClientUsingFlashlight(client))
		{
			fl = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
			if (fl && fl != INVALID_ENT_REFERENCE)
			{
				TeleportEntity(fl, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }), NULL_VECTOR);
			}
			
			fl = EntRefToEntIndex(g_PlayerFlashlightEntAng[client]);
			if (fl && fl != INVALID_ENT_REFERENCE)
			{
				GetClientEyeAngles(client, eyeAng);
				GetClientAbsAngles(client, ang2);
				SubtractVectors(eyeAng, ang2, eyeAng);
				TeleportEntity(fl, NULL_VECTOR, eyeAng, NULL_VECTOR);
			}
		}
	}
}

/**
 *	Handles whether or not the player's flashlight should be "flickering", a sign of a dying flashlight battery.
 */
void ClientHandleFlashlightFlickerState(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}
	
	if (IsClientUsingFlashlight(client))
	{
		bool flicker = view_as<bool>(ClientGetFlashlightBatteryLife(client) <= SF2_FLASHLIGHT_FLICKERAT);
	
		int fl = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
		if (fl && fl != INVALID_ENT_REFERENCE)
		{
			if (flicker)
			{
				SetEntProp(fl, Prop_Data, "m_LightStyle", 10);
			}
			else
			{
				SetEntProp(fl, Prop_Data, "m_LightStyle", 0);
			}
		}
		
		fl = EntRefToEntIndex(g_PlayerFlashlightEntAng[client]);
		if (fl && fl != INVALID_ENT_REFERENCE)
		{
			if (flicker) 
			{
				SetEntityRenderFx(fl, view_as<RenderFx>(13));
			}
			else 
			{
				SetEntityRenderFx(fl, view_as<RenderFx>(0));
			}
		}
	}
}

bool IsClientFlashlightBroken(int client)
{
	return g_PlayerFlashlightBroken[client];
}

float ClientGetFlashlightNextInputTime(int client)
{
	return g_PlayerFlashlightNextInputTime[client];
}

/**
 *	Breaks the player's flashlight. Nothing else.
 */
void ClientBreakFlashlight(int client)
{
	if (IsClientFlashlightBroken(client))
	{
		return;
	}
	
	ClientDeactivateUltravision(client);
	
	g_PlayerFlashlightBroken[client] = true;
	
	ClientSetFlashlightBatteryLife(client, 0.0);
	ClientTurnOffFlashlight(client);
	
	ClientAddStress(client, 0.2);
	
	EmitSoundToAll(FLASHLIGHT_BREAKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
	
	Call_StartForward(g_OnClientBreakFlashlightFwd);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Resets everything of the player's flashlight.
 */
void ClientResetFlashlight(int client)
{
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetFlashlight(%d)", client);
	}
#endif
	
	ClientTurnOffFlashlight(client);
	ClientSetFlashlightBatteryLife(client, 1.0);
	g_PlayerFlashlightBroken[client] = false;
	g_PlayerFlashlightBatteryTimer[client] = null;
	g_PlayerFlashlightNextInputTime[client] = -1.0;
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetFlashlight(%d)", client);
	}
#endif
}

public Action Hook_FlashlightSetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	
	if (EntRefToEntIndex(g_PlayerFlashlightEnt[other]) != ent)
	{
		return Plugin_Handled;
	}
	
	// We've already checked for flashlight ownership in the last statement. So we can do just this.
	if (g_PlayerPreferences[other].PlayerPreference_ProjectedFlashlight)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Hook_Flashlight2SetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (EntRefToEntIndex(g_PlayerFlashlightEntAng[other]) == ent)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void Hook_FlashlightEndSpawnPost(int ent)
{
	if (!g_Enabled)
	{
		return;
	}

	SDKHook(ent, SDKHook_SetTransmit, Hook_FlashlightEndSetTransmit);
	SDKUnhook(ent, SDKHook_SpawnPost, Hook_FlashlightEndSpawnPost);
}

public Action Hook_FlashlightBeamSetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int owner = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (owner == -1)
	{
		return Plugin_Continue;
	}
	
	int client = -1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		
		if (EntRefToEntIndex(g_PlayerFlashlightEntAng[i]) == owner)
		{
			client = i;
			break;
		}
	}
	
	if (client == -1)
	{
		return Plugin_Continue;
	}
	
	if (client == other)
	{
		if (!GetEntProp(client, Prop_Send, "m_nForceTauntCam") || !GetEntProp(client, Prop_Send, "m_iObserverMode"))
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

public Action Hook_FlashlightEndSetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int owner = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	
	if (owner == -1)
	{
		return Plugin_Continue;
	}
	
	int client = -1;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		
		if (EntRefToEntIndex(g_PlayerFlashlightEntAng[i]) == owner)
		{
			client = i;
			break;
		}
	}
	
	if (client == -1)
	{
		return Plugin_Continue;
	}
	
	if (client == other)
	{
		if (!GetEntProp(client, Prop_Send, "m_nForceTauntCam") || !GetEntProp(client, Prop_Send, "m_iObserverMode"))
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

/**
 *	Turns on the player's flashlight. Nothing else.
 */
void ClientTurnOnFlashlight(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		return;
	}
	
	if (IsClientUsingFlashlight(client))
	{
		return;
	}
	
	g_PlayerHasFlashlight[client] = true;
	
	float eyePos[3];

	float length = SF2_FLASHLIGHT_LENGTH;
	float doubleLength = SF2_FLASHLIGHT_LENGTH*3.0;
	float radius = SF2_FLASHLIGHT_WIDTH;
	float doubleRadius = SF2_FLASHLIGHT_WIDTH*2.0;
	GetClientEyePosition(client, eyePos);

	if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
	{
		// If the player is using the projected flashlight, just set effect flags.
		int effects = GetEntProp(client, Prop_Send, "m_fEffects");
		if (!(effects & (1 << 2)))
		{
			SetEntProp(client, Prop_Send, "m_fEffects", effects | (1 << 2));
		}
	}
	else
	{
		// Spawn the light which only the user will see.
		int ent = CreateEntityByName("light_dynamic");
		if (ent != -1)
		{
			TeleportEntity(ent, eyePos, NULL_VECTOR, NULL_VECTOR);
			DispatchKeyValue(ent, "targetname", "WUBADUBDUBMOTHERBUCKERS");
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 1)
			{
				DispatchKeyValue(ent, "rendercolor", "255 150 50");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 2)
			{
				DispatchKeyValue(ent, "rendercolor", "255 210 100");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 3)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 120");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 4)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 185");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 5)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 210");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 6)
			{
				DispatchKeyValue(ent, "rendercolor", "255 255 255");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 7)
			{
				DispatchKeyValue(ent, "rendercolor", "210 255 255");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 8)
			{
				DispatchKeyValue(ent, "rendercolor", "185 255 255");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 9)
			{
				DispatchKeyValue(ent, "rendercolor", "150 255 255");
			}
			if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 10)
			{
				DispatchKeyValue(ent, "rendercolor", "125 255 255");
			}
			if (TF2_GetPlayerClass(client) != TFClass_Engineer)
			{
				SetVariantFloat(radius);
			}
			else
			{
				SetVariantFloat(doubleRadius);
			}
			AcceptEntityInput(ent, "spotlight_radius");
			if (TF2_GetPlayerClass(client) != TFClass_Engineer)
			{
				SetVariantFloat(length);
			}
			else
			{
				SetVariantFloat(doubleLength);
			}
			AcceptEntityInput(ent, "distance");
			SetVariantInt(SF2_FLASHLIGHT_BRIGHTNESS);
			AcceptEntityInput(ent, "brightness");
			
			// Convert WU to inches.
			float cone = 55.0;
			cone *= 0.75;
			
			SetVariantInt(RoundToFloor(cone));
			AcceptEntityInput(ent, "_inner_cone");
			SetVariantInt(RoundToFloor(cone));
			AcceptEntityInput(ent, "_cone");
			DispatchSpawn(ent);
			ActivateEntity(ent);
			SetVariantString("!activator");
			AcceptEntityInput(ent, "SetParent", client);
			AcceptEntityInput(ent, "TurnOn");
			
			g_PlayerFlashlightEnt[client] = EntIndexToEntRef(ent);
			
			SDKHook(ent, SDKHook_SetTransmit, Hook_FlashlightSetTransmit);
		}
	}
	
	// Spawn the light that only everyone else will see.
	int ent = CreateEntityByName("point_spotlight");
	if (ent != -1)
	{
		TeleportEntity(ent, eyePos, NULL_VECTOR, NULL_VECTOR);
		
		char buffer[256];
		if (TF2_GetPlayerClass(client) != TFClass_Engineer)
		{
			FloatToString(length, buffer, sizeof(buffer));
		}
		else
		{
			FloatToString(doubleLength, buffer, sizeof(buffer));
		}
		DispatchKeyValue(ent, "spotlightlength", buffer);
		if (TF2_GetPlayerClass(client) != TFClass_Engineer)
		{
			FloatToString(radius, buffer, sizeof(buffer));
		}
		else
		{
			FloatToString(doubleRadius, buffer, sizeof(buffer));
		}
		DispatchKeyValue(ent, "spotlightwidth", buffer);
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 1)
		{
			DispatchKeyValue(ent, "rendercolor", "255 150 50");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 2)
		{
			DispatchKeyValue(ent, "rendercolor", "255 210 100");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 3)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 120");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 4)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 185");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 5)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 210");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 6)
		{
			DispatchKeyValue(ent, "rendercolor", "255 255 255");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 7)
		{
			DispatchKeyValue(ent, "rendercolor", "210 255 255");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 8)
		{
			DispatchKeyValue(ent, "rendercolor", "185 255 255");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 9)
		{
			DispatchKeyValue(ent, "rendercolor", "150 255 255");
		}
		if (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature == 10)
		{
			DispatchKeyValue(ent, "rendercolor", "125 255 255");
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", client);
		AcceptEntityInput(ent, "LightOn");
		
		g_PlayerFlashlightEntAng[client] = EntIndexToEntRef(ent);
	}
	
	Call_StartForward(g_OnClientActivateFlashlightFwd);
	Call_PushCell(client);
	Call_Finish();
}

/**
 *	Turns off the player's flashlight. Nothing else.
 */
void ClientTurnOffFlashlight(int client)
{
	if (!IsClientUsingFlashlight(client))
	{
		return;
	}
	
	g_PlayerHasFlashlight[client] = false;
	g_PlayerFlashlightBatteryTimer[client] = null;
	
	// Remove user-only light.
	int ent = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
	if (ent && ent != INVALID_ENT_REFERENCE) 
	{
		AcceptEntityInput(ent, "TurnOff");
		RemoveEntity(ent);
	}
	
	// Remove everyone-else-only light.
	ent = EntRefToEntIndex(g_PlayerFlashlightEntAng[client]);
	if (ent && ent != INVALID_ENT_REFERENCE) 
	{
		AcceptEntityInput(ent, "LightOff");
		CreateTimer(0.1, Timer_KillEntity, g_PlayerFlashlightEntAng[client], TIMER_FLAG_NO_MAPCHANGE);
	}
	
	g_PlayerFlashlightEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerFlashlightEntAng[client] = INVALID_ENT_REFERENCE;
	
	if (IsClientInGame(client))
	{
		if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
		{
			int effects = GetEntProp(client, Prop_Send, "m_fEffects");
			if (effects & (1 << 2))
			{
				SetEntProp(client, Prop_Send, "m_fEffects", effects &= ~(1 << 2));
			}
		}
	}
	
	Call_StartForward(g_OnClientDeactivateFlashlightFwd);
	Call_PushCell(client);
	Call_Finish();
}

void ClientStartRechargingFlashlightBattery(int client)
{
	g_PlayerFlashlightBatteryTimer[client] = CreateTimer(SF2_FLASHLIGHT_RECHARGE_RATE, Timer_RechargeFlashlight, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStartDrainingFlashlightBattery(int client)
{
	float drainRate = SF2_FLASHLIGHT_DRAIN_RATE;
	float rechargeRate = SF2_FLASHLIGHT_RECHARGE_RATE;
	bool nightVision = (g_NightvisionEnabledConVar.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	int difficulty = g_DifficultyConVar.IntValue;
	
	if (nightVision && g_NightvisionType == 2) //Blue nightvision
	{
		switch (difficulty)
		{
			case Difficulty_Normal:
			{
				drainRate *= 0.4;
			}
			case Difficulty_Hard:
			{
				drainRate *= 0.35;
			}
			case Difficulty_Insane:
			{
				drainRate *= 0.3;
			}
			case Difficulty_Nightmare:
			{
				drainRate *= 0.2;
			}
			case Difficulty_Apollyon:
			{
				drainRate *= 0.1;
			}
		}
	}
	
	if (TF2_GetPlayerClass(client) == TFClass_Engineer) 
	{
		// Engineers have a 50% longer battery life and 20% decreased recharge rate, basically.
		// TODO: Make this value customizable via cvar.
		drainRate *= 1.5;
		rechargeRate *= 0.8;
	}
	
	g_PlayerFlashlightBatteryTimer[client] = CreateTimer(drainRate, Timer_DrainFlashlight, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void ClientHandleFlashlight(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return;
	}
	
	bool nightVision = (g_NightvisionEnabledConVar.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	
	if (IsClientUsingFlashlight(client)) 
	{
		ClientTurnOffFlashlight(client);
		ClientStartRechargingFlashlightBattery(client);
		ClientDeactivateUltravision(client);
		ClientActivateUltravision(client);
		
		g_PlayerFlashlightNextInputTime[client] = GetGameTime() + SF2_FLASHLIGHT_COOLDOWN;
		
		if (!nightVision)
		{
			EmitSoundToAll(FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
		}
	}
	else
	{
		// Only players in the "game" can use the flashlight.
		if (!g_PlayerEliminated[client])
		{
			bool canUseFlashlight = true;
			if (SF_SpecialRound(SPECIALROUND_LIGHTSOUT) || SF_IsRaidMap() || SF_IsBoxingMap())
			{
				// Unequip the flashlight please.
				canUseFlashlight = false;
			}
			
			if (!IsClientFlashlightBroken(client) && canUseFlashlight)
			{
				ClientDeactivateUltravision(client);
				if (nightVision)
				{
					ClientActivateUltravision(client, nightVision);
				}
				else
				{
					ClientTurnOnFlashlight(client);
				}
				ClientStartDrainingFlashlightBattery(client);
				
				g_PlayerFlashlightNextInputTime[client] = GetGameTime();
				
				EmitSoundToAll((nightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
			}
			else
			{
				EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
			}
		}
	}
}

bool IsClientUsingUltravision(int client)
{
	return g_PlayerHasUltravision[client];
}

void ClientActivateUltravision(int client, bool nightVision = false)
{
	if (!IsClientInGame(client) || IsClientUsingUltravision(client))
	{
		return;
	}
	
	if (!g_PlayerEliminated[client] && (SF_SpecialRound(SPECIALROUND_NOULTRAVISION) && !nightVision))
	{
		return;
	}
	
#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientActivateUltravision(%d)", client);
	}
#endif
	
	g_PlayerHasUltravision[client] = true;
	g_PlayerHasFlashlight[client] = nightVision;
	
	int ent = CreateEntityByName("light_dynamic");
	if (ent != -1)
	{
		float eyePos[3];
		GetClientEyePosition(client, eyePos);
		
		TeleportEntity(ent, eyePos, view_as<float>({ 90.0, 0.0, 0.0 }), NULL_VECTOR);
		if (nightVision && !g_PlayerEliminated[client])
		{
			switch (g_NightvisionType)
			{
				case 0:
				{
					DispatchKeyValue(ent, "rendercolor", "50 255 50");
				}
				case 1:
				{
					DispatchKeyValue(ent, "rendercolor", "255 50 50");
				}
				case 2:
				{
					DispatchKeyValue(ent, "rendercolor", "50 50 255");
				}
			}
		}
		else
		{
			DispatchKeyValue(ent, "rendercolor", "100 200 255");
		}
		
		float radius = 0.0;
		if (g_PlayerEliminated[client])
		{
			radius = g_UltravisionRadiusBlueConVar.FloatValue;
		}
		else
		{
			radius = g_UltravisionRadiusRedConVar.FloatValue;
			if (nightVision)
			{
				radius = g_NightvisionRadiusConVar.FloatValue;
			}
			if (!nightVision && TF2_GetPlayerClass(client) == TFClass_Sniper)
			{
				radius *= 2.0;
			}
		}
		
		SetVariantFloat(radius);
		AcceptEntityInput(ent, "spotlight_radius");
		SetVariantFloat(radius);
		AcceptEntityInput(ent, "distance");
		
		SetVariantInt(-15); // Start dark, then fade in via the Timer_UltravisionFadeInEffect timer func.
		AcceptEntityInput(ent, "brightness");
		if (nightVision && !g_PlayerEliminated[client])
		{
			SetVariantInt(5);
			AcceptEntityInput(ent, "brightness");
		}
		
		// Convert WU to inches.
		float cone = SF2_ULTRAVISION_CONE;
		cone *= 0.75;
		
		SetVariantInt(RoundToFloor(cone));
		AcceptEntityInput(ent, "_inner_cone");
		SetVariantInt(0);
		AcceptEntityInput(ent, "_cone");
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", client);
		AcceptEntityInput(ent, "TurnOn");
		//SetEntityRenderFx(ent, RENDERFX_SOLID_FAST);
		SetEntityRenderColor(ent, 150, 225, 255, 255);
		if (nightVision && !g_PlayerEliminated[client])
		{
			switch (g_NightvisionType)
			{
				case 0:
				{
					DispatchKeyValue(ent, "rendercolor", "50 255 50");
				}
				case 1:
				{
					DispatchKeyValue(ent, "rendercolor", "255 50 50");
				}
				case 2:
				{
					DispatchKeyValue(ent, "rendercolor", "50 50 255");
				}
			}
		}
		
		g_PlayerUltravisionEnt[client] = EntIndexToEntRef(ent);
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_UltravisionSetTransmit);
		
		// Fade in effect.
		if (TF2_GetPlayerClass(client) != TFClass_Engineer || IsClientInGhostMode(client))
		{
			CreateTimer(0.0, Timer_UltravisionFadeInEffect, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (TF2_GetPlayerClass(client) == TFClass_Engineer && !IsClientInGhostMode(client))
		{
			CreateTimer(0.15, Timer_UltravisionFadeInEffect, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}

#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientActivateUltravision(%d)", client);
	}
#endif
}

public Action Timer_UltravisionFadeInEffect(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	int ent = EntRefToEntIndex(g_PlayerUltravisionEnt[client]);
	if (!ent || ent == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	
	int brightness = GetEntProp(ent, Prop_Send, "m_Exponent");
	int maxBrightness = g_UltravisionBrightnessConVar.IntValue;
	if (TF2_GetPlayerClass(client) == TFClass_Sniper) maxBrightness = RoundToNearest(float(maxBrightness) * 0.75);
	if (brightness >= maxBrightness)
	{
		return Plugin_Stop;
	}
	
	brightness++;
	SetVariantInt(brightness);
	AcceptEntityInput(ent, "brightness");
	
	return Plugin_Continue;
}

void ClientDeactivateUltravision(int client)
{
	if (!IsClientUsingUltravision(client))
	{
		return;
	}
	
	g_PlayerHasUltravision[client] = false;
	
	int ent = EntRefToEntIndex(g_PlayerUltravisionEnt[client]);
	if (ent != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(ent, "TurnOff");
		RemoveEntity(ent);
	}
	
	g_PlayerUltravisionEnt[client] = INVALID_ENT_REFERENCE;
}

public Action Hook_UltravisionSetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!g_UltravisionEnabledConVar.BoolValue || EntRefToEntIndex(g_PlayerUltravisionEnt[other]) != ent || !IsPlayerAlive(other))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

stock void ClientSDKFlashlightTurnOn(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}
	
	int effects = GetEntProp(client, Prop_Send, "m_fEffects");
	if (effects & EF_DIMLIGHT)
	{
		return;
	}

	effects |= EF_DIMLIGHT;
	
	SetEntProp(client, Prop_Send, "m_fEffects", effects);
}

stock void ClientSDKFlashlightTurnOff(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}
	
	int effects = GetEntProp(client, Prop_Send, "m_fEffects");
	if (!(effects & EF_DIMLIGHT))
	{
		return;
	}

	effects &= ~EF_DIMLIGHT;
	
	SetEntProp(client, Prop_Send, "m_fEffects", effects);
}
