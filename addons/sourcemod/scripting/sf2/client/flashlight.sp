#if defined _sf2_client_flashlight_included
 #endinput
#endif
#define _sf2_client_flashlight_included

#pragma semicolon 1
#pragma newdecls required

#define SF2_FLASHLIGHT_WIDTH 512.0 // How wide the player's Flashlight should be in world units.
#define SF2_FLASHLIGHT_BRIGHTNESS 0 // Intensity of the players' Flashlight.
#define SF2_FLASHLIGHT_DRAIN_RATE 0.12 // How long (in seconds) each bar on the player's Flashlight meter lasts.
#define SF2_FLASHLIGHT_RECHARGE_RATE 0.1 // How long (in seconds) it takes each bar on the player's Flashlight meter to recharge.
#define SF2_FLASHLIGHT_FLICKERAT 0.25 // The percentage of the Flashlight battery where the Flashlight will start to blink.
#define SF2_FLASHLIGHT_ENABLEAT 0.3 // The percentage of the Flashlight battery where the Flashlight will be able to be used again (if the player shortens out the Flashlight from excessive use).
#define SF2_FLASHLIGHT_COOLDOWN 0.4 // How much time players have to wait before being able to switch their flashlight on again after turning it off.

static bool g_PlayerHasFlashlight[MAXTF2PLAYERS] = { false, ... };
static bool g_PlayerFlashlightBroken[MAXTF2PLAYERS] = { false, ... };
static float g_PlayerFlashlightBatteryLife[MAXTF2PLAYERS] = { 1.0, ... };
static Handle g_PlayerFlashlightBatteryTimer[MAXTF2PLAYERS] = { null, ... };
static float g_PlayerFlashlightNextInputTime[MAXTF2PLAYERS] = { -1.0, ... };
static bool g_PlayerFlashlightIsFlickering[MAXTF2PLAYERS] = { false, ... };
static bool g_PlayerFlashlightFlickerState[MAXTF2PLAYERS] = { false, ... };
static float g_PlayerFlashlightNextFlickerTime[MAXTF2PLAYERS] = { -1.0, ... };
static int g_PlayerFlashlightEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };
static int g_PlayerFlashlightLightEnt[MAXTF2PLAYERS] = { INVALID_ENT_REFERENCE, ... };

void SetupFlashlight()
{
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerDisconnectedPFwd.AddFunction(null, OnDisconnected);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerPressButtonPFwd.AddFunction(null, OnPlayerPressButton);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
	g_OnPlayerConditionAddedPFwd.AddFunction(null, OnPlayerConditionAdded);

	RegConsoleCmd("sm_flashlight", Command_ToggleFlashlight);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	if (!g_Enabled)
	{
		return;
	}
	ClientResetFlashlight(client.index);

	SDKHook(client.index, SDKHook_PreThink, Hook_FlashlightThink);
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
	if (!g_Enabled)
	{
		return;
	}

	if (!fake)
	{
		ClientResetFlashlight(client.index);
	}
}

static void OnPlayerPressButton(SF2_BasePlayer client, int button)
{
	if (!client.IsAlive || client.IsInDeathCam || button != IN_ATTACK2 || IsRoundInWarmup() || IsRoundInIntro() || IsRoundEnding() || client.IsEliminated || client.HasEscaped)
	{
		return;
	}

	if (GetGameTime() >= client.GetFlashlightNextInputTime())
	{
		client.ToggleFlashlight();
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetFlashlight(client.index);
}

static void OnPlayerConditionAdded(SF2_BasePlayer client, TFCond condition)
{
	if (!g_Enabled)
	{
		return;
	}

	if (condition == TFCond_Taunting && client.UsingFlashlight)
	{
		client.ToggleFlashlight();
	}
}

static Action Command_ToggleFlashlight(int client, int args)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsValid || !player.IsAlive || player.IsInDeathCam || IsRoundInWarmup() || IsRoundInIntro() || IsRoundEnding() || player.IsEliminated || player.HasEscaped)
	{
		return Plugin_Handled;
	}

	if (GetGameTime() >= player.GetFlashlightNextInputTime())
	{
		player.ToggleFlashlight();
	}

	return Plugin_Handled;
}

static void Hook_FlashlightThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsAlive || player.IsEliminated || player.HasEscaped || player.IsInGhostMode || player.IsInDeathCam)
	{
		return;
	}

	if (player.InCondition(TFCond_Taunting) && player.UsingFlashlight)
	{
		player.ToggleFlashlight();
		return;
	}

	if (player.UsingFlashlight)
	{
		ClientProcessFlashlightAngles(player.index);
		if (!IsInfiniteFlashlightEnabled())
		{
			player.FlashlightBatteryLife -= GetFlashlightDecreaseRate(player) * GetGameFrameTime();
			if (player.FlashlightBatteryLife <= 0.0)
			{
				ClientBreakFlashlight(player.index);
				player.FlashlightBatteryLife = 0.0;
			}
		}
	}
	else
	{
		player.FlashlightBatteryLife += GetFlashlightRechargeRate(player) * GetGameFrameTime();
		if (player.FlashlightBatteryLife >= 1.0)
		{
			player.FlashlightBatteryLife = 1.0;
		}
		if (IsClientFlashlightBroken(player.index) && player.FlashlightBatteryLife >= SF2_FLASHLIGHT_ENABLEAT)
		{
			g_PlayerFlashlightBroken[player.index] = false;
		}
	}
	ClientHandleFlashlightFlickerState(player.index);
}

void ClientToggleFlashlight(SF2_BasePlayer client)
{
	g_PlayerFlashlightNextInputTime[client.index] = GetGameTime() + SF2_FLASHLIGHT_COOLDOWN;

	bool nightVision = IsNightVisionEnabled();

	if (client.UsingFlashlight)
	{
		ClientTurnOffFlashlight(client.index);
		ClientDeactivateUltravision(client.index);
		ClientActivateUltravision(client.index);

		if (!nightVision)
		{
			if (!SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
			{
				EmitSoundToAll(FLASHLIGHT_CLICKSOUND, client.index, SNDCHAN_ITEM, SNDLEVEL_DRYER);
			}
			else
			{
				EmitSoundToClient(client.index, FLASHLIGHT_CLICKSOUND, client.index, SNDCHAN_ITEM, SNDLEVEL_DRYER);
			}
		}

		Call_StartForward(g_OnPlayerTurnOffFlashlightPFwd);
		Call_PushCell(client);
		Call_Finish();
	}
	else
	{
		if (client.IsEliminated || SF_SpecialRound(SPECIALROUND_LIGHTSOUT) || SF_IsRaidMap() || SF_IsBoxingMap())
		{
			return;
		}

		if (IsClientFlashlightBroken(client.index))
		{
			EmitSoundToClient(client.index, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
			return;
		}

		ClientDeactivateUltravision(client.index);
		if (nightVision)
		{
			g_PlayerHasFlashlight[client.index] = true;
			ClientActivateUltravision(client.index, nightVision);
		}
		else
		{
			ClientTurnOnFlashlight(client.index);
		}

		if (!SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
		{
			EmitSoundToAll((nightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client.index, SNDCHAN_ITEM, SNDLEVEL_DRYER);
		}
		else
		{
			EmitSoundToClient(client.index, (nightVision) ? FLASHLIGHT_CLICKSOUND_NIGHTVISION : FLASHLIGHT_CLICKSOUND, client.index, SNDCHAN_ITEM, SNDLEVEL_DRYER);
		}

		Call_StartForward(g_OnPlayerTurnOnFlashlightPFwd);
		Call_PushCell(client);
		Call_Finish();
	}
}

static float GetFlashlightDecreaseRate(SF2_BasePlayer client)
{
	float drainRate = SF2_FLASHLIGHT_DRAIN_RATE;

	TFClassType class = client.Class;
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
	if (IsNightVisionEnabled() && g_NightVisionType == 2) //Blue nightvision
	{
		switch (g_DifficultyConVar.IntValue)
		{
			case Difficulty_Normal:
			{
				drainRate *= 0.3;
			}
			case Difficulty_Hard:
			{
				drainRate *= 0.25;
			}
			case Difficulty_Insane:
			{
				drainRate *= 0.2;
			}
			case Difficulty_Nightmare:
			{
				drainRate *= 0.15;
			}
			case Difficulty_Apollyon:
			{
				drainRate *= 0.1;
			}
		}
	}
	return drainRate;
}

static float GetFlashlightRechargeRate(SF2_BasePlayer client)
{
	TFClassType class = client.Class;
	int classToInt = view_as<int>(class);
	float rechargeRate = SF2_FLASHLIGHT_RECHARGE_RATE;
	if (!IsClassConfigsValid())
	{
		if (class == TFClass_Engineer)
		{
			rechargeRate *= 1.2;
		}
	}
	else
	{
		rechargeRate *= g_ClassFlashlightRechargeRate[classToInt];
	}
	return rechargeRate;
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

	fl = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
	if (fl && fl != INVALID_ENT_REFERENCE)
	{
		float pos[3], ang[3];
		GetClientEyePosition(client, pos);
		GetClientEyeAngles(client, ang);
		SF2PointSpotlightEntity(fl).SetLocalOrigin(pos);
		SF2PointSpotlightEntity(fl).Start.SetLocalOrigin(pos);
		SF2PointSpotlightEntity(fl).SetLocalAngles(ang);
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
		float gameTime = GetGameTime();

		if (flicker && g_PlayerFlashlightNextFlickerTime[client] <= gameTime)
		{
			g_PlayerFlashlightFlickerState[client] = !g_PlayerFlashlightFlickerState[client];
			g_PlayerFlashlightNextFlickerTime[client] = gameTime + GetRandomFloat(0.1, 0.2);
			int effects = GetEntProp(client, Prop_Send, "m_fEffects");
			int fl = EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
			if (g_PlayerFlashlightFlickerState[client])
			{
				if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
				{
					SetEntProp(client, Prop_Send, "m_fEffects", effects | (1 << 2));
				}

				if (fl && fl != INVALID_ENT_REFERENCE)
				{
					SF2PointSpotlightEntity(fl).TurnOn();
				}
			}
			else
			{
				if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
				{
					SetEntProp(client, Prop_Send, "m_fEffects", effects &= ~(1 << 2));
				}

				if (fl && fl != INVALID_ENT_REFERENCE)
				{
					SF2PointSpotlightEntity(fl).TurnOff();
				}
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

int ClientGetFlashlightEntity(int client)
{
	return EntRefToEntIndex(g_PlayerFlashlightEnt[client]);
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
	ClientDeactivateUltravision(client);
	ClientActivateUltravision(client);

	ClientAddStress(client, 0.2);

	EmitSoundToAll(FLASHLIGHT_BREAKSOUND, client, SNDCHAN_STATIC, SNDLEVEL_DRYER);

	Call_StartForward(g_OnClientBreakFlashlightFwd);
	Call_PushCell(client);
	Call_Finish();

	Call_StartForward(g_OnPlayerFlashlightBreakPFwd);
	Call_PushCell(SF2_BasePlayer(client));
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
	g_PlayerFlashlightIsFlickering[client] = false;
	g_PlayerFlashlightFlickerState[client] = false;
	g_PlayerFlashlightNextFlickerTime[client] = -1.0;

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetFlashlight(%d)", client);
	}
	#endif
}

static Action FlashlightBeamSetTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(other) && g_PlayerFlashlightEnt[other] == EntIndexToEntRef(ent))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action FlashlightLightSetTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(other) && g_PlayerFlashlightLightEnt[other] == EntIndexToEntRef(ent))
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
		if ((GetEntProp(ownerEntity, Prop_Send, "m_nForceTauntCam") != 0) && !TF2_IsPlayerInCondition(ownerEntity, TFCond_Taunting))
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
	float doubleLength = SF2_FLASHLIGHT_LENGTH * 3.0;
	float radius = SF2_FLASHLIGHT_WIDTH;
	float doubleRadius = SF2_FLASHLIGHT_WIDTH * 2.0;
	GetClientEyePosition(client, eyePos);
	GetClientEyeAngles(client, eyeAng);

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	// Convert WU to inches.
	float cone = 55.0;
	cone *= 0.75;

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
		SF2PointSpotlightEntity ent = SF2PointSpotlightEntity(CreateEntityByName("sf2_point_spotlight"));
		if (ent.IsValid())
		{
			ent.Teleport(eyePos, eyeAng, NULL_VECTOR);
			switch (g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature)
			{
				case 1:
				{
					ent.SetColor({ 255, 150, 50, 255 });
				}
				case 2:
				{
					ent.SetColor({ 255, 210, 100, 255 });
				}
				case 3:
				{
					ent.SetColor({ 255, 255, 120, 255 });
				}
				case 4:
				{
					ent.SetColor({ 255, 255, 185, 255 });
				}
				case 5:
				{
					ent.SetColor({ 255, 255, 210, 255 });
				}
				case 6:
				{
					ent.SetColor({ 255, 255, 255, 255 });
				}
				case 7:
				{
					ent.SetColor({ 210, 255, 255, 255 });
				}
				case 8:
				{
					ent.SetColor({ 185, 255, 255, 255 });
				}
				case 9:
				{
					ent.SetColor({ 150, 255, 255, 255 });
				}
				case 10:
				{
					ent.SetColor({ 125, 255, 255, 255 });
				}
			}
			float value = radius;
			if (!IsClassConfigsValid())
			{
				if (class == TFClass_Engineer)
				{
					value = doubleRadius;
				}
			}
			else
			{
				value = radius * g_ClassFlashlightRadius[classToInt];
			}
			ent.Distance = value;
			ent.SpotlightRadius = value;
			value = length;
			if (!IsClassConfigsValid())
			{
				if (class == TFClass_Engineer)
				{
					value = doubleLength;
				}
			}
			else
			{
				value = length * g_ClassFlashlightLength[classToInt];
			}
			ent.Length = value;
			int intValue = SF2_FLASHLIGHT_BRIGHTNESS;
			if (IsClassConfigsValid())
			{
				intValue = SF2_FLASHLIGHT_BRIGHTNESS + g_ClassFlashlightBrightness[classToInt];
			}
			ent.Brightness = intValue;
			ent.Cone = RoundToFloor(cone);
			ent.Width = 40.0;
			ent.EndWidth = ent.Width * 2.0;
			ent.HaloScale = 40.0;
			ent.Spawn();
			ent.Activate();
			SetVariantString("!activator");
			ent.Start.AcceptInput("ClearParent");
			SetVariantString("!activator");
			ent.End.AcceptInput("ClearParent");
			ent.TurnOn();

			g_PlayerFlashlightEnt[client] = EntIndexToEntRef(ent.index);
			g_PlayerFlashlightLightEnt[client] = EntIndexToEntRef(ent.End.index);
			SDKHook(ent.index, SDKHook_SetTransmit, FlashlightBeamSetTransmit);

			if (g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight)
			{
				SDKHook(ent.End.index, SDKHook_SetTransmit, FlashlightLightSetTransmit);
			}
		}
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
		RemoveEntity(ent);
	}

	g_PlayerFlashlightEnt[client] = INVALID_ENT_REFERENCE;
	g_PlayerFlashlightLightEnt[client] = INVALID_ENT_REFERENCE;

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