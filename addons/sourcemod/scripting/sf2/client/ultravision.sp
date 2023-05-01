#pragma semicolon 1

#define SF2_ULTRAVISION_CONE 180.0
#define SF2_ULTRAVISION_WIDTH 800.0
#define SF2_ULTRAVISION_LENGTH 800.0
#define SF2_ULTRAVISION_BRIGHTNESS -4 // Intensity of Ultravision.

// Ultravision data.
bool g_PlayerHasUltravision[MAXTF2PLAYERS] = { false, ... };
int g_PlayerUltravisionEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };

void SetupUltravision()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientDeactivateUltravision(client.index);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	ClientDeactivateUltravision(client.index);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientDeactivateUltravision(client.index);
	if (!client.IsEliminated && !client.HasEscaped)
	{
		ClientActivateUltravision(client.index);
	}
}

static void OnPlayerDeath(SF2_BasePlayer client)
{
	ClientDeactivateUltravision(client.index);
}

bool IsClientUsingUltravision(int client)
{
	return g_PlayerHasUltravision[client];
}

void ClientActivateUltravision(int client, bool nightVision = false)
{
	if (!IsValidClient(client) || IsClientUsingUltravision(client))
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

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	g_PlayerHasUltravision[client] = true;

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
				if (!IsClassConfigsValid())
				{
					radius = g_NightvisionRadiusConVar.FloatValue;
				}
				else
				{
					radius = g_NightvisionRadiusConVar.FloatValue * g_ClassNightvisionRadiusMultiplier[classToInt];
				}
			}
			if (!nightVision && class == TFClass_Sniper && !IsClassConfigsValid())
			{
				radius *= 2.0;
			}
			else if (!nightVision && IsClassConfigsValid())
			{
				radius *= g_ClassUltravisionRadiusMultiplier[classToInt];
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
			if (!IsClassConfigsValid())
			{
				SetVariantInt(5);
				AcceptEntityInput(ent, "brightness");
			}
			else
			{
				int roundedBrightness = RoundToNearest(5.0 * g_ClassNightvisionBrightnessMultiplier[classToInt]);
				SetVariantInt(roundedBrightness);
				AcceptEntityInput(ent, "brightness");
			}
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
			}
		}

		g_PlayerUltravisionEnt[client] = EntIndexToEntRef(ent);

		SDKHook(ent, SDKHook_SetTransmit, Hook_UltravisionSetTransmit);

		// Fade in effect.
		if (!IsClassConfigsValid())
		{
			if (class != TFClass_Engineer || IsClientInGhostMode(client))
			{
				CreateTimer(0.0, Timer_UltravisionFadeInEffect, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
			else if (class == TFClass_Engineer && !IsClientInGhostMode(client))
			{
				CreateTimer(0.15, Timer_UltravisionFadeInEffect, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		else
		{
			CreateTimer(g_ClassUltravisionFadeInTimer[classToInt], Timer_UltravisionFadeInEffect, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientActivateUltravision(%d)", client);
	}
	#endif
}

static Action Timer_UltravisionFadeInEffect(Handle timer, any userid)
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

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	int brightness = GetEntProp(ent, Prop_Send, "m_Exponent");
	int maxBrightness = g_UltravisionBrightnessConVar.IntValue;
	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Sniper)
		{
			maxBrightness = RoundToNearest(float(maxBrightness) * 0.75);
		}
	}
	else
	{
		maxBrightness = RoundToNearest(float(maxBrightness) * g_ClassUltravisionBrightnessMultiplier[classToInt]);
	}
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

static Action Hook_UltravisionSetTransmit(int ent,int other)
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