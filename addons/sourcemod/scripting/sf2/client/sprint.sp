#pragma semicolon 1

static bool g_PlayerSprint[MAXTF2PLAYERS] = { false, ... };
static bool g_WantsToSprint[MAXTF2PLAYERS] = { false, ... };
static float g_Stamina[MAXTF2PLAYERS] = { 1.0, ... };
static float g_StaminaRechargeTime[MAXTF2PLAYERS] = { 1.0, ... };

static ConVar g_PlayerScareSprintBoost;

void SetupSprint()
{
	g_OnPlayerJumpPFwd.AddFunction(null, OnJump);
	g_OnPlayerPutInServerPFwd.AddFunction(null, OnPutInServer);
	g_OnPlayerSpawnPFwd.AddFunction(null, OnPlayerSpawn);
	g_OnPlayerDeathPFwd.AddFunction(null, OnPlayerDeath);
	g_OnPlayerEscapePFwd.AddFunction(null, OnPlayerEscape);

	g_PlayerScareSprintBoost = CreateConVar("sf2_player_scare_boost", "0", "If player is in danger, provide a small boost in speed.", _, true, 0.0, true, 1.0);
}

static void OnPutInServer(SF2_BasePlayer client)
{
	ClientResetSprint(client);

	SDKHook(client.index, SDKHook_PreThink, Hook_SpeedThink);
	SDKHook(client.index, SDKHook_PreThink, Hook_SprintThink);
}

static void OnJump(SF2_BasePlayer client)
{
	if (client.IsEliminated || IsRoundEnding() || IsRoundInWarmup() || client.HasEscaped || client.IsLatched || client.IsTrapped)
	{
		return;
	}

	if (!IsInfiniteSprintEnabled() && client.Stamina > 0.0)
	{
		TFClassType classType = client.Class;
		int classToInt = view_as<int>(classType);
		if (!IsClassConfigsValid())
		{
			if (classType != TFClass_Soldier || client.Stamina <= 0.1 || client.IsSprinting)
			{
				client.SetStaminaRechargeTime(GetGameTime() + 1.5);

				client.Stamina -= 0.07;
			}
		}
		else
		{
			float sprintPointsLoss = g_ClassSprintPointLossJumping[classToInt];
			if (client.Stamina <= 0.1 || client.IsSprinting)
			{
				sprintPointsLoss = 0.07;
			}

			if (sprintPointsLoss > 0.0)
			{
				client.SetStaminaRechargeTime(GetGameTime() + 1.5);
			}

			client.Stamina -= sprintPointsLoss;
		}
	}
}

static void OnPlayerSpawn(SF2_BasePlayer client)
{
	ClientResetSprint(client);

	if (client.IsAlive && !client.IsEliminated && !client.HasEscaped)
	{
		if (SF_IsBoxingMap() || SF_IsRaidMap())
		{
			g_WantsToSprint[client.index] = true;
		}
	}
}

static void OnPlayerDeath(SF2_BasePlayer client, int attacker, int inflictor, bool fake)
{
	if (!fake)
	{
		ClientResetSprint(client);
	}
}

static void OnPlayerEscape(SF2_BasePlayer client)
{
	ClientResetSprint(client);
}

static void Hook_SprintThink(int client)
{
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsAlive || player.IsEliminated || player.HasEscaped || player.IsInGhostMode)
	{
		return;
	}

	bool wasSprinting = g_PlayerSprint[client];
	bool isSprinting = false;

	if (g_WantsToSprint[player.index] && !player.IsInDeathCam)
	{
		float velocity[3];
		player.GetAbsVelocity(velocity);
		if (GetVectorLength(velocity, true) > Pow(30.0, 2.0))
		{
			isSprinting = true;
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
		}
	}
	else
	{
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

	g_PlayerSprint[player.index] = isSprinting;

	if (wasSprinting != isSprinting)
	{
		if (SF_SpecialRound(SPECIALROUND_RUNNINGINTHE90S))
		{
			if (isSprinting)
			{
				Client90sMusicStart(client);

				Call_StartForward(g_OnClientStartSprintingFwd);
				Call_PushCell(client);
				Call_Finish();
			}
			else
			{
				Client90sMusicStop(client);

				Call_StartForward(g_OnClientStopSprintingFwd);
				Call_PushCell(client);
				Call_Finish();
			}
		}
	}

	if (isSprinting)
	{
		if (!IsInfiniteSprintEnabled())
		{
			player.SetStaminaRechargeTime(GetGameTime() + 1.5);

			player.Stamina -= GetStaminaDecreaseRate(player) * GetTickInterval();
			if (player.Stamina <= 0.0)
			{
				g_WantsToSprint[client] = false;
			}
		}
	}

	if (player.Stamina < 1.0 && GetGameTime() > g_StaminaRechargeTime[player.index])
	{
		player.Stamina += GetStaminaRechargeRate(player) * GetTickInterval();
	}
}

float ClientGetDefaultSprintSpeed(int client, TFClassType class = TFClass_Unknown)
{
	float returnFloat = 400.0;
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
			returnFloat = 400.0;
		}
		case TFClass_Sniper:
		{
			returnFloat = 370.0;
		}
		case TFClass_Soldier:
		{
			returnFloat = 350.0;
		}
		case TFClass_DemoMan:
		{
			returnFloat = 350.0;
		}
		case TFClass_Heavy:
		{
			returnFloat = 350.0;
		}
		case TFClass_Medic:
		{
			returnFloat = 370.0;
		}
		case TFClass_Pyro:
		{
			returnFloat = 370.0;
		}
		case TFClass_Spy:
		{
			returnFloat = 370.0;
		}
		case TFClass_Engineer:
		{
			returnFloat = 370.0;
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

float ClientGetStamina(int client)
{
	return g_Stamina[client];
}

void ClientSetStamina(int client, float value)
{
	g_Stamina[client] = value;
	if (g_Stamina[client] > 1.0)
	{
		g_Stamina[client] = 1.0;
	}
	if (g_Stamina[client] < 0.0)
	{
		g_Stamina[client] = 0.0;
	}
}

void SetPlayerStaminaRechargeTime(SF2_BasePlayer client, float time, bool checkTime = true)
{
	if (checkTime && g_StaminaRechargeTime[client.index] >= time)
	{
		return;
	}

	g_StaminaRechargeTime[client.index] = time;
}

float GetStaminaDecreaseRate(SF2_BasePlayer client)
{
	float rate = 0.03;

	if (SF_SpecialRound(SPECIALROUND_COFFEE))
	{
		rate *= 0.5;
	}

	if (SF_IsProxyMap())
	{
		rate *= 0.25;
	}

	TFClassType class = client.Class;
	int classToInt = view_as<int>(class);
	if (!IsClassConfigsValid())
	{
		if (class == TFClass_DemoMan)
		{
			rate *= 0.9; // Demoman gets a 10% sprint duration increase
		}
		else if (class == TFClass_Scout)
		{
			rate *= 0.95; // Scout gets a 5% sprint duration increase
		}
	}
	else
	{
		rate *= g_ClassSprintDurationMultipler[classToInt];
	}

	return rate;
}

float GetStaminaRechargeRate(SF2_BasePlayer client)
{
	float rate = 0.02;

	if (client.Ducked)
	{
		float velocity[3];
		client.GetAbsVelocity(velocity);
		if (GetVectorLength(velocity, true) == 0.0)
		{
			// Double the sprint rate if the player is crouching and holding still
			rate = 0.04;
		}
	}

	if (SF_SpecialRound(SPECIALROUND_COFFEE))
	{
		rate *= 0.35;
	}

	if (SF_IsProxyMap())
	{
		rate *= 0.25;
	}

	return rate;
}

static void ClientResetSprint(SF2_BasePlayer client)
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START ClientResetSprint(%d)", client.index);
	}
	#endif

	bool wasSprinting = client.IsSprinting;

	client.SetStaminaRechargeTime(0.0, false);
	g_PlayerSprint[client.index] = false;
	g_WantsToSprint[client.index] = false;
	client.Stamina = 1.0;

	if (client.IsValid)
	{
		ClientSetFOV(client.index, g_PlayerDesiredFOV[client.index]);
	}

	if (wasSprinting)
	{
		Call_StartForward(g_OnClientStopSprintingFwd);
		Call_PushCell(client.index);
		Call_Finish();
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END ClientResetSprint(%d)", client.index);
	}
	#endif
}

 /**
  *	Handles sprinting upon player input.
  */
void ClientHandleSprint(int client, bool sprint)
{
	if (IsRoundInWarmup() || IsRoundInIntro() || IsRoundEnding())
	{
		return;
	}

	if (!IsPlayerAlive(client) ||
		g_PlayerEliminated[client] ||
		DidClientEscape(client) ||
		g_PlayerProxy[client] ||
		IsClientInGhostMode(client))
	{
		return;
	}

	if (SF_IsRaidMap() || SF_IsBoxingMap()) // On these maps we always sprint
	{
		return;
	}

	if (sprint)
	{
		if (g_Stamina[client] > 0)
		{
			g_WantsToSprint[client] = true;
		}
		else
		{
			EmitSoundToClient(client, FLASHLIGHT_NOSOUND, _, SNDCHAN_ITEM, SNDLEVEL_NONE);
		}
	}
	else
	{
		g_WantsToSprint[client] = false;
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

static void Hook_SpeedThink(int client)
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

			int ent = NPCGetEntIndex(i);
			if (!ent || ent == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			if (NPCGetType(i) == SF2BossType_Chaser)
			{
				SF2_ChaserEntity chaser = SF2_ChaserEntity(ent);
				bossTarget = chaser.Target.index;
				state = chaser.State;

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

	if (player.IsTrapped || g_PlayerPeeking[player.index])
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
			sprintSpeed += (sprintSpeed * 0.125);
		}
	}
	else
	{
		if (player.InCondition(TFCond_SpeedBuffAlly))
		{
			walkSpeed += (walkSpeed * 0.11);
			sprintSpeed += (sprintSpeed * 0.11);
		}
	}

	if (inDanger)
	{
		if (g_PlayerScareSprintBoost.BoolValue)
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
					weaponEnt = INVALID_ENT_REFERENCE;
					for (int slot = 0; slot <= 5; slot++)
					{
						weaponEnt = player.GetWeaponSlot(slot);
						if (!weaponEnt || weaponEnt == INVALID_ENT_REFERENCE)
						{
							continue;
						}

						int itemDefInt = GetEntProp(weaponEnt, Prop_Send, "m_iItemDefinitionIndex");
						if (itemDefInt == 214 && player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt) // Powerjack
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
						if (itemDefInt == 214 && player.GetPropEnt(Prop_Send, "m_hActiveWeapon") == weaponEnt) // Powerjack
						{
							multiplier -= 0.02;
						}
					}
				}
				walkSpeed *= multiplier;
				sprintSpeed *= multiplier;
			}
		}

		if (!player.HasHint(PlayerHint_Sprint))
		{
			player.ShowHint(PlayerHint_Sprint);
		}
	}

	if (player.Stamina <= 0.04)
	{
		float sprintSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.425);
		float walkSpeedSubtract = ((sprintSpeed - walkSpeed) * 0.3);

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
					player.SetPropFloat(Prop_Send, "m_flMaxspeed", sprintSpeed * 2.5);
				}
				else
				{
					player.SetPropFloat(Prop_Send, "m_flMaxspeed", sprintSpeed / 2.5);
				}
			}
			player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", 190.0);
		}
		else
		{
			player.SetPropFloat(Prop_Send, "m_flMaxspeed", 520.0);
			player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", 190.0);
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
				player.SetPropFloat(Prop_Send, "m_flMaxspeed", walkSpeed * 2.5);
			}
			else
			{
				player.SetPropFloat(Prop_Send, "m_flMaxspeed", 190.0);
			}
		}
		player.SetPropFloat(Prop_Send, "m_flCurrentTauntMoveSpeed", 190.0);
	}
}