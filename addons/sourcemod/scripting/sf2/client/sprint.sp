#pragma semicolon 1

bool g_PlayerSprint[MAXTF2PLAYERS] = { false, ... };
int g_PlayerSprintPoints[MAXTF2PLAYERS] = { 100, ... };
Handle g_PlayerSprintTimer[MAXTF2PLAYERS] = { null, ... };

void SetupSprint()
{
	g_OnPlayerJumpPFwd.AddFunction(null, OnJump);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetSprint(client.index);

	SDKHook(client.index, SDKHook_PreThink, Hook_SprintThink);
}

static void OnJump(SF2_BasePlayer client)
{
	if (client.IsEliminated || IsRoundEnding() || IsRoundInWarmup() || client.HasEscaped)
	{
		return;
	}

	int override = g_PlayerInfiniteSprintOverrideConVar.IntValue;
	if ((!g_IsRoundInfiniteSprint && override != 1) || override == 0 && !client.IsTrapped)
	{
		if (client.GetSprintPoints() >= 2)
		{
			TFClassType classType = client.Class;
			int classToInt = view_as<int>(classType);
			if (!IsClassConfigsValid())
			{
				if (classType != TFClass_Soldier || client.GetSprintPoints() <= 10 || client.IsSprinting)
				{
					client.SetSprintPoints(client.GetSprintPoints() - 7);
				}
			}
			else
			{
				int sprintPointsLoss = g_ClassSprintPointLossJumping[classToInt];
				if (client.GetSprintPoints() <= 10 || client.IsSprinting)
				{
					sprintPointsLoss = 7;
				}
				client.SetSprintPoints(client.GetSprintPoints() - sprintPointsLoss);
			}
			if (client.GetSprintPoints() <= 0)
			{
				client.SetSprintPoints(0);
			}
		}
	}

	if (!client.IsSprinting)
	{
		if (g_PlayerSprintTimer[client.index] == null)
		{
			// If the player hasn't sprinted recently, force us to regenerate the stamina.
			client.SetSprintTimer(true);
		}
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetSprint(client.index);
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetSprint(client.index);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetSprint(client.index);
}

float ClientGetDefaultSprintSpeed(int client, TFClassType class = TFClass_Unknown)
{
	float returnFloat = 340.0;
	float returnFloat2 = returnFloat;
	Action action = Plugin_Continue;
	if (IsValidClient(client))
	{
		class = TF2_GetPlayerClass(client);
	}

	switch (class)
	{
		case TFClass_Scout:
		{
			returnFloat = 305.0;
		}
		case TFClass_Sniper:
		{
			returnFloat = 295.0;
		}
		case TFClass_Soldier:
		{
			returnFloat = 280.0;
		}
		case TFClass_DemoMan:
		{
			returnFloat = 280.0;
		}
		case TFClass_Heavy:
		{
			returnFloat = 280.0;
		}
		case TFClass_Medic:
		{
			returnFloat = 290.0;
		}
		case TFClass_Pyro:
		{
			returnFloat = 290.0;
		}
		case TFClass_Spy:
		{
			returnFloat = 300.0;
		}
		case TFClass_Engineer:
		{
			returnFloat = 295.0;
		}
	}

	if (IsValidClient(client))
	{
		// Call our forward.
		Call_StartForward(g_OnClientGetDefaultSprintSpeedFwd);
		Call_PushCell(client);
		Call_PushCellRef(returnFloat2);
		Call_Finish(action);
	}

	if (action == Plugin_Changed)
	{
		returnFloat = returnFloat2;
	}

	return returnFloat;
}

bool IsClientSprinting(int client)
{
	return g_PlayerSprint[client];
}

int ClientGetSprintPoints(int client)
{
	return g_PlayerSprintPoints[client];
}

void ClientSetSprintPoints(int client, int value)
{
	g_PlayerSprintPoints[client] = value;
}

void ClientResetSprint(int client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetSprint(%d)", client);
	}
	#endif

	bool wasSprinting = IsClientSprinting(client);

	g_PlayerSprint[client] = false;
	g_PlayerSprintPoints[client] = 100;
	g_PlayerSprintTimer[client] = null;

	if (IsValidClient(client))
	{
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
		SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);

		ClientSetFOV(client, g_PlayerDesiredFOV[client]);
	}

	if (wasSprinting)
	{
		Call_StartForward(g_OnClientStopSprintingFwd);
		Call_PushCell(client);
		Call_Finish();
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetSprint(%d)", client);
	}
	#endif
}

void ClientStartSprint(int client)
{
	if (IsClientSprinting(client))
	{
		return;
	}

	g_PlayerSprint[client] = true;
	g_PlayerSprintTimer[client] = null;
	ClientSprintTimer(client);
	TriggerTimer(g_PlayerSprintTimer[client], true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || g_Renevant90sEffect)
	{
		Client90sMusicStart(client);
	}

	SDKHook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);

	Call_StartForward(g_OnClientStartSprintingFwd);
	Call_PushCell(client);
	Call_Finish();
}

void ClientSprintTimer(int client, bool recharge=false)
{
	float rate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 0.38 : 0.28;
	if (recharge)
	{
		rate = (SF_SpecialRound(SPECIALROUND_COFFEE)) ? 1.4 : 0.8;
	}

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	float velocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);

	if (recharge)
	{
		if (!(GetEntityFlags(client) & FL_ONGROUND))
		{
			rate *= 0.75;
		}
		else if (GetVectorLength(velocity, true) == 0.0)
		{
			if (GetEntProp(client, Prop_Send, "m_bDucked"))
			{
				rate *= 0.66;
			}
			else
			{
				rate *= 0.75;
			}
		}
	}
	else
	{
		if (!IsClassConfigsValid())
		{
			if (class == TFClass_DemoMan)
			{
				rate *= 1.15;
			}
			else if (class == TFClass_Medic || class == TFClass_Spy)
			{
				rate *= 1.05;
			}
			else if (class == TFClass_Scout)
			{
				rate *= 1.08;
			}
		}
		else
		{
			rate *= g_ClassSprintDurationMultipler[classToInt];
		}
	}

	if (recharge)
	{
		g_PlayerSprintTimer[client] = CreateTimer(rate, Timer_ClientRechargeSprint, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		g_PlayerSprintTimer[client] = CreateTimer(rate, Timer_ClientSprinting, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
	}
}

void ClientStopSprint(int client)
{
	if (!IsClientSprinting(client))
	{
		return;
	}
	g_PlayerSprint[client] = false;
	g_PlayerSprintTimer[client] = null;
	ClientSprintTimer(client, true);
	if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) || g_Renevant90sEffect)
	{
		Client90sMusicStop(client);
	}

	SDKHook(client, SDKHook_PreThink, Hook_ClientRechargeSprintPreThink);
	SDKUnhook(client, SDKHook_PreThink, Hook_ClientSprintingPreThink);

	Call_StartForward(g_OnClientStopSprintingFwd);
	Call_PushCell(client);
	Call_Finish();
}

 /**
  *	Handles sprinting upon player input.
  */
void ClientHandleSprint(int client, bool sprint)
{
	if (!IsPlayerAlive(client) ||
		g_PlayerEliminated[client] ||
		DidClientEscape(client) ||
		g_PlayerProxy[client] ||
		IsClientInGhostMode(client))
	{
		return;
	}

	if (sprint)
	{
		if (g_PlayerSprintPoints[client] > 0)
		{
			ClientStartSprint(client);
		}
		else
		{
			EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
		}
	}
	else
	{
		if (IsClientSprinting(client))
		{
			ClientStopSprint(client);
		}
	}
}
bool IsClientReallySprinting(int client)
{
	if (!IsClientSprinting(client))
	{
		return false;
	}
	if (!(GetEntityFlags(client) & FL_ONGROUND))
	{
		return false;
	}

	float velocity[3];
	GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", velocity);
	if (GetVectorLength(velocity, true) < SquareFloat(30.0))
	{
		return false;
	}

	return true;
}

static Action Timer_ClientSprinting(Handle timer, any userid)
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

static Action Timer_ClientRechargeSprint(Handle timer, any userid)
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

static void Hook_ClientSprintingPreThink(int client)
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

static void Hook_ClientRechargeSprintPreThink(int client)
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

static void Hook_SprintThink(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	RoundState roundState = GameRules_GetRoundState();
	if (player.IsEliminated || roundState != RoundState_RoundRunning ||
		IsRoundEnding() || IsRoundInWarmup() || player.HasEscaped)
	{
		return;
	}

	TFClassType class = player.Class;
	int classToInt = view_as<int>(class);

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
					ClientSetScareBoostEndTime(player.index, GetGameTime() + 5.0);

					// Induce client stress levels.
					float unComfortZoneDist = 512.0;
					float stressScalar = ((SquareFloat(unComfortZoneDist) / NPCGetDistanceFromEntity(i, client)));
					ClientAddStress(player.index, 0.025 * stressScalar);

					break;
				}
			}
		}
	}

	if (g_PlayerStaticAmount[player.index] > 0.4)
	{
		inDanger = true;
	}
	if (GetGameTime() < ClientGetScareBoostEndTime(player.index))
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
					if (player.CanSeeSlender(i))
					{
						inDanger = true;
						ClientSetScareBoostEndTime(player.index, GetGameTime() + 5.0);
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

			if ((curTime - g_PlayerScareLastTime[player.index][i]) <= scareSprintDuration)
			{
				inDanger = true;
				break;
			}
		}
	}

	if (player.IsTrapped)
	{
		player.SetPropFloat(Prop_Send, "m_flMaxspeed", 0.1);
		player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", 0.1);
		return;
	}

	float walkSpeed, sprintSpeed;
	if (!IsClassConfigsValid())
	{
		walkSpeed = ClientGetDefaultWalkSpeed(player.index);
		sprintSpeed = ClientGetDefaultSprintSpeed(player.index);
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
		weaponEnt = player.GetWeaponSlot(slot);
		if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
		{
			continue;
		}

		int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
		switch (itemDefInt)
		{
			case 172: // Scotsman's Skullcutter
			{
				if (player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt)
				{
					sprintSpeed -= (sprintSpeed * 0.05);
					walkSpeed -= (walkSpeed * 0.05);
				}
			}
			case 214: // The Powerjack
			{
				if (player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt)
				{
					sprintSpeed += (sprintSpeed * 0.03);
				}
			}
			case 239: // Gloves of Running Urgently
			{
				if (player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt)
				{
					sprintSpeed += (sprintSpeed * 0.075);
				}
			}
			case 775: // Escape Plan
			{
				float health = float(player.GetProp(Prop_Send, "m_iHealth"));
				float maxHealth = float(SDKCall(g_SDKGetMaxHealth, player.index));
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
		if (player.InCondition(TFCond_SpeedBuffAlly))
		{
			walkSpeed += (walkSpeed * 0.115);
			sprintSpeed += (sprintSpeed * 0.165);
		}
	}
	else
	{
		if (player.InCondition(TFCond_SpeedBuffAlly))
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
					for (int slot = 0; slot <= 5; slot++)
					{
						weaponEnt = player.GetWeaponSlot(slot);
						if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
						{
							continue;
						}

						int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
						if (itemDefInt == 214 && player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt)
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
				for (int slot = 0; slot <= 5; slot++)
				{
					weaponEnt = player.GetWeaponSlot(slot);
					if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
					{
						continue;
					}

					int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
					if (itemDefInt == 214 && player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt)
					{
						multiplier -= 0.02;
					}
				}
			}
			walkSpeed *= multiplier;
			sprintSpeed *= multiplier;
		}

		if (!g_PlayerHints[player.index][PlayerHint_Sprint])
		{
			player.ShowHint(PlayerHint_Sprint);
		}
	}

	float sprintSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.425);
	float walkSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.3);
	if (player.GetSprintPoints() > 8)
	{
		sprintSpeedSubtract -= sprintSpeedSubtract * (player.GetSprintPoints() != 0 ? (float(player.GetSprintPoints()) / 100.0) : 0.0);
		sprintSpeed -= sprintSpeedSubtract;
	}
	else
	{
		sprintSpeedSubtract += 125;
		sprintSpeed -= sprintSpeedSubtract;
		walkSpeedSubtract += 25;
		walkSpeed -= walkSpeedSubtract;
	}

	if (player.IsSprinting)
	{
		if (!SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S) && !g_Renevant90sEffect)
		{
			if (!player.InCondition(TFCond_Charging))
			{
				player.SetPropFloat(Prop_Send, "m_flMaxspeed", sprintSpeed);
			}
			else
			{
				if (SF_IsBoxingMap() || SF_IsRaidMap())
				{
					player.SetPropFloat(Prop_Send, "m_flMaxspeed", sprintSpeed*2.5);
				}
				else
				{
					player.SetPropFloat(Prop_Send, "m_flMaxspeed", sprintSpeed/2.5);
				}
			}
			player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", sprintSpeed-170.0);
		}
		else
		{
			player.SetPropFloat(Prop_Send, "m_flMaxspeed", 520.0);
			player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", sprintSpeed-170.0);
		}
	}
	else
	{
		if (!player.InCondition(TFCond_Charging))
		{
			player.SetPropFloat(Prop_Send, "m_flMaxspeed", walkSpeed);
		}
		else
		{
			if (SF_IsBoxingMap() || SF_IsRaidMap())
			{
				player.SetPropFloat(Prop_Send, "m_flMaxspeed", walkSpeed*2.5);
			}
			else
			{
				player.SetPropFloat(Prop_Send, "m_flMaxspeed", walkSpeed/2.5);
			}
		}
		player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", walkSpeed-20.0);
	}
}