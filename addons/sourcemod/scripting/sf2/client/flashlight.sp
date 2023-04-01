#if defined _sf2_client_flashlight_included
 #endinput
#endif
#define _sf2_client_flashlight_included

#define SF2_FLASHLIGHT_WIDTH 512.0 // How wide the player's Flashlight should be in world units.
#define SF2_FLASHLIGHT_BRIGHTNESS 0 // Intensity of the players' Flashlight.
#define SF2_FLASHLIGHT_DRAIN_RATE 0.65 // How long (in seconds) each bar on the player's Flashlight meter lasts.
#define SF2_FLASHLIGHT_RECHARGE_RATE 0.68 // How long (in seconds) it takes each bar on the player's Flashlight meter to recharge.
#define SF2_FLASHLIGHT_FLICKERAT 0.25 // The percentage of the Flashlight battery where the Flashlight will start to blink.
#define SF2_FLASHLIGHT_ENABLEAT 0.3 // The percentage of the Flashlight battery where the Flashlight will be able to be used again (if the player shortens out the Flashlight from excessive use).
#define SF2_FLASHLIGHT_COOLDOWN 0.4 // How much time players have to wait before being able to switch their flashlight on again after turning it off.

#pragma semicolon 1

static bool g_PlayerHasFlashlight[MAXTF2PLAYERS] = { false, ... };
static bool g_PlayerFlashlightBroken[MAXTF2PLAYERS] = { false, ... };
static float g_PlayerFlashlightBatteryLife[MAXTF2PLAYERS] = { 1.0, ... };
static Handle g_PlayerFlashlightBatteryTimer[MAXTF2PLAYERS] = { null, ... };
static float g_PlayerFlashlightNextInputTime[MAXTF2PLAYERS] = { -1.0, ... };
static int g_PlayerFlashlightEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerFlashlightEntAng[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_ClientFlashlightStartEntity[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_ClientFlashlightEndEntity[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };

void SetupFlashlight()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetFlashlight(client.index);
}

static void OnDisconnected(SF2_BasePlayer client)
{
	ClientResetFlashlight(client.index);
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetFlashlight(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetFlashlight(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetFlashlight(client.index);
}

static Action Timer_DrainFlashlight(Handle timer, any userid)
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

static Action Timer_RechargeFlashlight(Handle timer, any userid)
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

void ClientSetFlashlightBatteryLife(int client, float percent)
{
	g_PlayerFlashlightBatteryLife[client] = percent;
}

/**
 *	Called in Hook_ClientPreThink, this makes sure the flashlight is oriented correctly on the player.
 */
void ClientProcessFlashlightAngles(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return;
	}

	int fl;

	if (IsClientUsingFlashlight(client))
	{
		fl = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
		if (fl && fl != INVALID_ENT_REFERENCE)
		{
			TeleportEntity(fl, NULL_VECTOR, view_as<float>({ 0.0, 0.0, 0.0 }), NULL_VECTOR);
		}
	}
}

/**
 *	Handles whether or not the player's flashlight should be "flickering", a sign of a dying flashlight battery.
 */
void ClientHandleFlashlightFlickerState(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return;
	}

	if (IsClientUsingFlashlight(client))
	{
		bool flicker = ClientGetFlashlightBatteryLife(client) <= SF2_FLASHLIGHT_FLICKERAT;

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

static Action Hook_FlashlightSetTransmit(int ent,int other)
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

/*static Action Hook_Flashlight2SetTransmit(int ent,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	int ownerEntity = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity");
	if (!IsValidClient(ownerEntity))
	{
		return Plugin_Continue;
	}

	if (ownerEntity == other)
	{
		if (!!(GetEntProp(ownerEntity, Prop_Send, "m_nForceTauntCam")) && !TF2_IsPlayerInCondition(ownerEntity, TFCond_Taunting))
		{
			return Plugin_Handled;
		}
	}
	else
	{
		if (GetEntPropEnt(other, Prop_Send, "m_hObserverTarget") == ownerEntity && GetEntProp(other, Prop_Send, "m_iObserverMode") == 4)
		{
			return Plugin_Handled;
		}

		if (!DidClientEscape(ownerEntity) && !g_PlayerEliminated[ownerEntity])
		{
			if (SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
			{
				if (!g_PlayerEliminated[other] && !DidClientEscape(other))
				{
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Continue;
}*/

/**
 *	Turns on the player's flashlight. Nothing else.
 */
void ClientTurnOnFlashlight(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return;
	}

	if (IsClientUsingFlashlight(client))
	{
		return;
	}

	g_PlayerHasFlashlight[client] = true;

	float eyePos[3], eyeAng[3];

	float length = SF2_FLASHLIGHT_LENGTH;
	float doubleLength = SF2_FLASHLIGHT_LENGTH*3.0;
	float radius = SF2_FLASHLIGHT_WIDTH;
	float doubleRadius = SF2_FLASHLIGHT_WIDTH*2.0;
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

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
			TeleportEntity(ent, eyePos, eyeAng, NULL_VECTOR);
			DispatchKeyValue(ent, "targetname", "WUBADUBDUBMOTHERBUCKERS");
			switch (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature)
			{
				case 1:
				{
					DispatchKeyValue(ent, "rendercolor", "255 150 50");
				}
				case 2:
				{
					DispatchKeyValue(ent, "rendercolor", "255 210 100");
				}
				case 3:
				{
					DispatchKeyValue(ent, "rendercolor", "255 255 120");
				}
				case 4:
				{
					DispatchKeyValue(ent, "rendercolor", "255 255 185");
				}
				case 5:
				{
					DispatchKeyValue(ent, "rendercolor", "255 255 210");
				}
				case 6:
				{
					DispatchKeyValue(ent, "rendercolor", "255 255 255");
				}
				case 7:
				{
					DispatchKeyValue(ent, "rendercolor", "210 255 255");
				}
				case 8:
				{
					DispatchKeyValue(ent, "rendercolor", "185 255 255");
				}
				case 9:
				{
					DispatchKeyValue(ent, "rendercolor", "150 255 255");
				}
				case 10:
				{
					DispatchKeyValue(ent, "rendercolor", "125 255 255");
				}
			}
			if (!IsClassConfigsValid())
			{
				if (class != TFClass_Engineer)
				{
					SetVariantFloat(radius);
				}
				else
				{
					SetVariantFloat(doubleRadius);
				}
			}
			else
			{
				float customRadius = radius * g_ClassFlashlightRadius[classToInt];
				SetVariantFloat(customRadius);
			}
			AcceptEntityInput(ent, "spotlight_radius");
			if (!IsClassConfigsValid())
			{
				if (class != TFClass_Engineer)
				{
					SetVariantFloat(length);
				}
				else
				{
					SetVariantFloat(doubleLength);
				}
			}
			else
			{
				float customLength = length * g_ClassFlashlightLength[classToInt];
				SetVariantFloat(customLength);
			}
			AcceptEntityInput(ent, "distance");
			if (!IsClassConfigsValid())
			{
				SetVariantInt(SF2_FLASHLIGHT_BRIGHTNESS);
			}
			else
			{
				int customBrightness = SF2_FLASHLIGHT_BRIGHTNESS + g_ClassFlashlightBrightness[classToInt];
				SetVariantInt(customBrightness);
			}
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
	/*int ent = CreateEntityByName("env_beam");
	if (ent != -1)
	{
		int startEnt = CreateEntityByName("info_target");
		int endEnt = CreateEntityByName("info_target");
		if (startEnt != -1) // Start
		{
			SetEntPropString(startEnt, Prop_Data, "m_iClassname", "sf2_flashlight_spotlight_start");
			SetEntProp(startEnt, Prop_Data, "m_spawnflags", 1);
			TeleportEntity(startEnt, eyePos, eyeAng, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(startEnt, "SetParent", client);

			DispatchSpawn(startEnt);
			SetEntityOwner(startEnt, client);

			g_ClientFlashlightStartEntity[client] = EntIndexToEntRef(startEnt);

			SetEntityTransmitState(startEnt, FL_EDICT_FULLCHECK);
			g_DHookUpdateTransmitState.HookEntity(Hook_Pre, startEnt, Hook_SpotlightEffectUpdateTransmitState);
			g_DHookShouldTransmit.HookEntity(Hook_Pre, startEnt, Hook_SpotlightEffectShouldTransmit);
		}
		if (endEnt != -1) // End
		{
			SetEntPropString(endEnt, Prop_Data, "m_iClassname", "sf2_flashlight_spotlight_end");
			SetEntProp(endEnt, Prop_Data, "m_spawnflags", 1);
			TeleportEntity(endEnt, eyePos, eyeAng, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(endEnt, "SetParent", client);

			DispatchSpawn(endEnt);
			SetEntityOwner(endEnt, client);

			g_ClientFlashlightEndEntity[client] = EntIndexToEntRef(endEnt);

			SetEntityTransmitState(endEnt, FL_EDICT_FULLCHECK);
			g_DHookUpdateTransmitState.HookEntity(Hook_Pre, endEnt, Hook_SpotlightEffectUpdateTransmitState);
			g_DHookShouldTransmit.HookEntity(Hook_Pre, endEnt, Hook_SpotlightEffectShouldTransmit);
		}

		switch (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature)
		{
			case 1:
			{
				SetEntityRenderColor(ent, 255, 150, 50, 64);
			}
			case 2:
			{
				SetEntityRenderColor(ent, 255, 210, 100, 64);
			}
			case 3:
			{
				SetEntityRenderColor(ent, 255, 255, 120, 64);
			}
			case 4:
			{
				SetEntityRenderColor(ent, 255, 255, 185, 64);
			}
			case 5:
			{
				SetEntityRenderColor(ent, 255, 255, 210, 64);
			}
			case 6:
			{
				SetEntityRenderColor(ent, 255, 255, 255, 64);
			}
			case 7:
			{
				SetEntityRenderColor(ent, 210, 255, 255, 64);
			}
			case 8:
			{
				SetEntityRenderColor(ent, 185, 255, 255, 64);
			}
			case 9:
			{
				SetEntityRenderColor(ent, 150, 255, 255, 64);
			}
			case 10:
			{
				SetEntityRenderColor(ent, 125, 255, 255, 64);
			}
		}

		SetEntityModel(ent, SF2_FLASHLIGHT_BEAM_MATERIAL);
		SetEntityRenderMode(ent, RENDER_TRANSTEXTURE);
		SetEntPropFloat(ent, Prop_Data, "m_life", 0.0);

		TeleportEntity(ent, eyePos, eyeAng, NULL_VECTOR);

		DispatchSpawn(ent);
		ActivateEntity(ent);

		SetEntPropEnt(ent, Prop_Send, "m_hAttachEntity", startEnt, 0);
		SetEntPropEnt(ent, Prop_Send, "m_hAttachEntity", endEnt, 1);
		SetEntProp(ent, Prop_Send, "m_nNumBeamEnts", 2);
		SetEntProp(ent, Prop_Send, "m_nBeamType", 2);

		SetEntPropFloat(ent, Prop_Send, "m_fWidth", 40.0);
		SetEntPropFloat(ent, Prop_Data, "m_fEndWidth", 102.0);

		SetEntPropFloat(ent, Prop_Send, "m_fFadeLength", 0.0);
		SetEntProp(ent, Prop_Send, "m_nHaloIndex", g_FlashlightHaloModel);
		SetEntPropFloat(ent, Prop_Send, "m_fHaloScale", 40.0);
		SetEntProp(ent, Prop_Send, "m_nBeamFlags", 0x80 | 0x200);
		SetEntProp(ent, Prop_Data, "m_spawnflags", 0x8000);

		AcceptEntityInput(ent, "TurnOn");

		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", client);

		SetEntityOwner(ent, client);

		SDKHook(ent, SDKHook_SetTransmit, Hook_Flashlight2SetTransmit);
		SetEntityTransmitState(ent, FL_EDICT_FULLCHECK);
		g_DHookUpdateTransmitState.HookEntity(Hook_Pre, ent, Hook_SpotlightEffectUpdateTransmitState);
		g_DHookShouldTransmit.HookEntity(Hook_Pre, ent, Hook_SpotlightEffectShouldTransmit);

		g_PlayerFlashlightEntAng[client] = EntIndexToEntRef(ent);
	}*/

	Call_StartForward(g_OnClientActivateFlashlightFwd);
	Call_PushCell(client);
	Call_Finish();
}

void Hook_OnFlashlightThink(int client)
{
	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);
	float length;
	if (!IsClassConfigsValid())
	{
		if (class != TFClass_Engineer)
		{
			length = SF2_FLASHLIGHT_LENGTH;
		}
		else
		{
			length = SF2_FLASHLIGHT_LENGTH * 3.0;
		}
	}
	else
	{
		length = SF2_FLASHLIGHT_LENGTH * g_ClassFlashlightLength[classToInt];
	}
	if (IsClientUsingFlashlight(client))
	{
		int endEnt = EntRefToEntIndex(g_ClientFlashlightEndEntity[client]);
		if (IsValidEntity(endEnt))
		{
			float entPos[3], entRot[3], tempRot[3], endPos[3];
			GetClientEyePosition(client, entPos);
			GetClientEyeAngles(client, entRot);
			GetEntPropVector(client, Prop_Data, "m_angAbsRotation", tempRot);
			tempRot[0] = 0.0;
			tempRot[2] = 0.0;
			AddVectors(entRot, tempRot, entRot);
			GetAngleVectors(entRot, entRot, NULL_VECTOR, NULL_VECTOR);
			endPos = entRot;
			ScaleVector(endPos, length);
			AddVectors(endPos, entPos, endPos);

			CBaseEntity spotlightEnd = CBaseEntity(endEnt);
			if (spotlightEnd.IsValid())
			{
				TR_TraceRayFilter(entPos, endPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, TraceRayDontHitEntity, client);

				float hitPos[3];
				TR_GetEndPosition(hitPos);

				hitPos[2] += 20.0;

				spotlightEnd.SetAbsOrigin(hitPos);
			}
		}
	}
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
		AcceptEntityInput(ent, "TurnOff");
		CreateTimer(0.1, Timer_KillEntity, g_PlayerFlashlightEntAng[client], TIMER_FLAG_NO_MAPCHANGE);
	}
	ent = EntRefToEntIndex(g_ClientFlashlightStartEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		CreateTimer(0.1, Timer_KillEntity, g_ClientFlashlightStartEntity[client], TIMER_FLAG_NO_MAPCHANGE);
	}
	ent = EntRefToEntIndex(g_ClientFlashlightEndEntity[client]);
	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		CreateTimer(0.1, Timer_KillEntity, g_ClientFlashlightEndEntity[client], TIMER_FLAG_NO_MAPCHANGE);
	}

	g_PlayerFlashlightEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerFlashlightEntAng[client] = INVALID_ENT_REFERENCE;
	g_ClientFlashlightStartEntity[client] = INVALID_ENT_REFERENCE;
	g_ClientFlashlightEndEntity[client] = INVALID_ENT_REFERENCE;

	if (IsValidClient(client))
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
	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);
	float rechargeRate = SF2_FLASHLIGHT_RECHARGE_RATE;
	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Engineer)
		{
			rechargeRate *= 0.8;
		}
	}
	else
	{
		rechargeRate *= g_ClassFlashlightRechargeRate[classToInt];
	}

	g_PlayerFlashlightBatteryTimer[client] = CreateTimer(rechargeRate, Timer_RechargeFlashlight, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void ClientStartDrainingFlashlightBattery(int client)
{
	float drainRate = SF2_FLASHLIGHT_DRAIN_RATE;

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Engineer)
		{
			// Engineers have a 50% longer battery life and 20% decreased recharge rate, basically.
			drainRate *= 1.5;
		}
	}
	else
	{
		drainRate *= g_ClassFlashlightDrainRate[classToInt];
	}

	g_PlayerFlashlightBatteryTimer[client] = CreateTimer(drainRate, Timer_DrainFlashlight, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

void ClientHandleFlashlight(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || (TF2_IsPlayerInCondition(client, TFCond_Taunting) && !IsClientUsingFlashlight(client)))
	{
		return;
	}

	bool nightVision = (g_NightvisionEnabledConVar.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));

	if (IsClientUsingFlashlight(client) || TF2_IsPlayerInCondition(client, TFCond_Taunting))
	{
		ClientTurnOffFlashlight(client);
		ClientStartRechargingFlashlightBattery(client);
		ClientDeactivateUltravision(client);
		ClientActivateUltravision(client);

		g_PlayerFlashlightNextInputTime[client] = GetGameTime() + SF2_FLASHLIGHT_COOLDOWN;

		if (!nightVision)
		{
			if (!SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
			{
				EmitSoundToAll(FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
			}
			else
			{
				EmitSoundToClient(client, FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
			}
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
					g_PlayerHasFlashlight[client] = true;
					ClientActivateUltravision(client, nightVision);
				}
				else
				{
					ClientTurnOnFlashlight(client);
				}
				ClientStartDrainingFlashlightBattery(client);

				g_PlayerFlashlightNextInputTime[client] = GetGameTime();
				if (!SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
				{
					EmitSoundToAll((nightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
				}
				else
				{
					EmitSoundToClient(client, (nightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);
				}
			}
			else
			{
				EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
			}
		}
	}
}

/*
void ClientSDKFlashlightTurnOn(int client)
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

void ClientSDKFlashlightTurnOff(int client)
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
*/