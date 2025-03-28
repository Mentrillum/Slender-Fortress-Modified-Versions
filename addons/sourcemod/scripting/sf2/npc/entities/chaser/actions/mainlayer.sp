#pragma semicolon 1
#pragma newdecls required
// The purpose of this action is to be the master action

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserMainAction < NextBotAction
{
	public SF2_ChaserMainAction()
	{
		return view_as<SF2_ChaserMainAction>(g_Factory.Create());
	}

	public static NextBotActionFactory GetFactory()
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Main");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetEventCallback(EventResponderType_OnInjured, OnInjured);
			g_Factory.SetEventCallback(EventResponderType_OnContact, OnContact);
			g_Factory.SetEventCallback(EventResponderType_OnKilled, OnKilled);
			g_Factory.SetEventCallback(EventResponderType_OnLeaveGround, OnLeaveGround);
			g_Factory.SetEventCallback(EventResponderType_OnLandOnGround, OnLandOnGround);
			g_Factory.SetEventCallback(EventResponderType_OnCommandString, OnCommandString);
			g_Factory.BeginDataMapDesc()
				.DefineFloatField("m_LastStuckTime")
				.DefineVectorField("m_LastPos")
				.DefineVectorField("m_UnstuckPos")
				.EndDataMapDesc();
		}
		return g_Factory;
	}

	property float LastStuckTime
	{
		public get()
		{
			return this.GetDataFloat("m_LastStuckTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_LastStuckTime", value);
		}
	}

	public void GetLastPos(float pos[3])
	{
		this.GetDataVector("m_LastPos", pos);
	}

	public void SetLastPos(const float pos[3])
	{
		this.SetDataVector("m_LastPos", pos);
	}

	public void GetUnstuckPos(float pos[3])
	{
		this.GetDataVector("m_UnstuckPos", pos);
	}

	public void SetUnstuckPos(const float pos[3])
	{
		this.SetDataVector("m_UnstuckPos", pos);
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserMainAction action, SF2_ChaserEntity actor)
{
	return SF2_ChaserSpawnAction();
}

static void OnStart(SF2_ChaserMainAction action, SF2_ChaserEntity actor)
{
	float pos[3];
	actor.MyNextBotPointer().GetLocomotionInterface().GetFeet(pos);
	action.SetLastPos(pos);
	action.LastStuckTime = GetGameTime();
}

static int Update(SF2_ChaserMainAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (controller.IsValid() && (controller.Flags & SFF_MARKEDASFAKE) != 0)
	{
		return action.Done("I'm a faker");
	}

	if (!controller.IsValid())
	{
		return action.Continue();
	}

	if (actor.ShouldDespawn)
	{
		return action.ChangeTo(SF2_ChaserDespawnAction());
	}

	float gameTime = GetGameTime();

	int difficulty = controller.Difficulty;

	actor.FollowOtherBossAlert();

	actor.FollowOtherBossChase();

	if (actor.State == STATE_ATTACK)
	{
		actor.DoAttackMiscConditions(actor.GetAttackName());
	}

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileStunData stunData = data.GetStunBehavior();
	if (stunData != null && stunData.CanFlashlightStun(difficulty) && actor.CanBeStunned() && actor.CanTakeDamage() && actor.FlashlightTick < gameTime &&
		!IsNightVisionEnabled())
	{
		bool inFlashlight = false;
		float customDamage = 1.0;
		bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
		int attacker = -1;

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!IsTargetValidForSlender(actor, player, attackEliminated))
			{
				continue;
			}

			if (!player.UsingFlashlight)
			{
				continue;
			}

			float hisPos[3], myPos[3], myEyeAng[3], hisEyeAng[3], requiredAng[3];
			player.GetAbsOrigin(hisPos);
			actor.GetAbsOrigin(myPos);

			if (GetVectorDistance(myPos, hisPos, true) > Pow(SF2_FLASHLIGHT_LENGTH, 2.0))
			{
				continue;
			}

			actor.GetAbsAngles(myEyeAng);
			player.GetEyeAngles(hisEyeAng);
			SubtractVectors(hisPos, myPos, requiredAng);
			GetVectorAngles(requiredAng, requiredAng);

			if (FloatAbs(AngleDiff(myEyeAng[1], requiredAng[1])) > 70.0 || FloatAbs(AngleDiff(hisEyeAng[1], requiredAng[1])) < 130.0 || FloatAbs(AngleDiff(requiredAng[0], hisEyeAng[0])) > 30.0)
			{
				continue;
			}

			if (!actor.IsLOSClearFromTarget(player))
			{
				continue;
			}

			Action fwdAction;
			Call_StartForward(g_OnBossPreFlashlightDamageFwd);
			Call_PushCell(actor);
			Call_PushCell(player);
			Call_Finish(fwdAction);
			if (fwdAction == Plugin_Stop)
			{
				continue;
			}

			inFlashlight = true;
			if (!IsClassConfigsValid())
			{
				if (player.Class == TFClass_Engineer)
				{
					customDamage = 2.0;
				}
			}
			else
			{
				customDamage = g_ClassFlashlightDamageMultiplier[view_as<int>(player.Class)];
			}
			attacker = i;
			break;
		}

		if (inFlashlight)
		{
			actor.StunHealth -= stunData.GetFlashlightDamage(difficulty) * customDamage;
			actor.FlashlightTick = gameTime + 0.1;

			Event event = CreateEvent("npc_hurt");
			if (event)
			{
				event.SetInt("entindex", actor.index);
				event.SetInt("health", actor.GetProp(Prop_Data, "m_iHealth"));
				event.SetInt("damageamount", RoundToFloor(stunData.GetFlashlightDamage(difficulty) * customDamage));
				event.SetBool("crit", false);

				if (IsValidClient(attacker))
				{
					event.SetInt("attacker_player", GetClientUserId(attacker));
					event.SetInt("weaponid", 0);
				}
				else
				{
					event.SetInt("attacker_player", 0);
					event.SetInt("weaponid", 0);
				}

				event.Fire();
			}

			if (actor.StunHealth <= 0.0)
			{
				return action.SuspendFor(SF2_ChaserStunnedAction(CBaseEntity(attacker)), "I was stunned by a flashlight");
			}
		}
	}

	if (data.GetInstantKillRadius(difficulty) > 0.0)
	{
		if (gameTime >= actor.LastKillTime && !actor.IsKillingSomeone)
		{
			float worldSpace[3], myPos[3];
			actor.WorldSpaceCenter(worldSpace);
			actor.GetAbsOrigin(myPos);
			bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
			if (controller.GetProfileData().IsPvEBoss)
			{
				attackEliminated = true;
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				SF2_BasePlayer client = SF2_BasePlayer(i);
				if (!IsTargetValidForSlender(actor, client, attackEliminated))
				{
					continue;
				}

				if (client.IsInDeathCam)
				{
					continue;
				}

				if (actor.MyNextBotPointer().GetRangeSquaredTo(client.index) > Pow(data.GetInstantKillRadius(difficulty), 2.0) ||
					!client.CanSeeSlender(controller.Index, false, _, !attackEliminated))
				{
					continue;
				}

				actor.LastKillTime = gameTime + data.GetInstantKillCooldown(difficulty);
				client.StartDeathCam(controller.Index, myPos);
				actor.CheckTauntKill(SF2_BasePlayer(client.index));
			}
		}
	}

	if (actor.IsKillingSomeone)
	{
		actor.EndCloak();
		return action.SuspendFor(SF2_DeathCamAction());
	}

	actor.ProcessTraps();

	#if defined DEBUG
	if (actor.IsAttemptingToMove && controller.Path.IsValid())
	{
		PathFollower path = controller.Path;
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid || (g_PlayerDebugFlags[player.index] & DEBUG_BOSS_PATH) == 0)
			{
				continue;
			}

			Segment init, end;
			init = path.FirstSegment();
			while (init != NULL_PATH_SEGMENT)
			{
				end = path.NextSegment(init);
				if (end == NULL_PATH_SEGMENT)
				{
					break;
				}

				float from[3], to[3];
				int color[4] = { 25, 94, 255, 255 };
				init.GetPos(from);
				end.GetPos(to);
				TE_SetupBeamPoints(from,
					to,
					g_ShockwaveBeam,
					g_ShockwaveHalo,
					0,
					30,
					0.1,
					5.0,
					5.0,
					5,
					0.0,
					color,
					1);

				TE_SendToClient(player.index);

				init = end;
			}
		}
	}
	#endif

	if (!actor.IsAttacking && (controller.Flags & SFF_ATTACKPROPS) != 0)
	{
		float myPos[3], propPos[3];
		actor.GetAbsOrigin(myPos);
		for (int i = 0; i < g_BreakableProps.Length; i++)
		{
			CBaseEntity prop = CBaseEntity(EntRefToEntIndex(g_BreakableProps.Get(i)));
			if (!prop.IsValid())
			{
				continue;
			}

			prop.GetAbsOrigin(propPos);
			if (GetVectorSquareMagnitude(myPos, propPos) > Pow(1500.0, 2.0))
			{
				continue;
			}

			if (!actor.IsLOSClearFromTarget(prop))
			{
				continue;
			}

			NextBotAction attackAction = actor.GetAttackAction(prop, true);
			if (attackAction != NULL_ACTION)
			{
				actor.EndCloak();
				return action.SuspendFor(attackAction, "Fuck you prop.");
			}
		}
	}

	UnstuckCheck(action, actor);

	return action.Continue();
}

static int OnResume(SF2_ChaserMainAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	action.LastStuckTime = GetGameTime() + 0.75;
	if (!actor.IsInChaseInitial)
	{
		actor.UpdateMovementAnimation();
	}
	if (actor.WasStunned)
	{
		actor.WasStunned = false;
	}
	return action.Continue();
}

static int OnInjured(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damageType)
{
	if (actor.CanBeStunned() && IsValidClient(attacker.index) && actor.CanTakeDamage(attacker, inflictor, damage))
	{
		actor.StunHealth -= damage;
		if (actor.StunHealth <= 0.0)
		{
			if (actor.GetProp(Prop_Data, "m_takedamage") == DAMAGE_EVENTS_ONLY) // Stun health only
			{
				return action.TrySuspendFor(SF2_ChaserStunnedAction(attacker), RESULT_IMPORTANT, "I was stunned by someone");
			}
			else
			{
				if (!actor.IsRaging)
				{
					return action.TrySuspendFor(SF2_ChaserStunnedAction(attacker), RESULT_IMPORTANT, "I was stunned by someone");
				}
			}
		}
	}

	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	int search = actor.RageIndex + 1;
	if ((data.BoxingBoss || data.IsPvEBoss) &&
		actor.CanTakeDamage(attacker, inflictor, damage) && data.GetRages() != null && search < data.GetRages().Size && !actor.IsRaging)
	{
		char name[64];
		data.GetRages().GetSectionNameFromIndex(search, name, sizeof(name));
		ChaserBossProfileRageData rageInfo = view_as<ChaserBossProfileRageData>(data.GetRages().GetSection(name));
		float maxHealth = actor.MaxHealth;
		float health = float(actor.GetProp(Prop_Data, "m_iHealth"));
		if (!data.GetDeathBehavior().IsEnabled(controller.Difficulty))
		{
			maxHealth = actor.MaxStunHealth;
			health = actor.StunHealth;
		}
		if (health <= maxHealth * rageInfo.PercentageThreshold)
		{
			return action.TrySuspendFor(SF2_ChaserRageAction(), RESULT_IMPORTANT, "I need to rage!");
		}
	}

	return action.TryContinue();
}

static void UnstuckCheck(SF2_ChaserMainAction action, SF2_ChaserEntity actor)
{
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	SF2NPC_Chaser controller = actor.Controller;
	PathFollower path = controller.Path;
	float gameTime = GetGameTime();

	float goalPos[3], myPos[3];
	if (path.IsValid())
	{
		path.GetEndPosition(goalPos);
	}
	actor.GetAbsOrigin(myPos);

	if (!path.IsValid() || !actor.IsAttemptingToMove || loco.GetDesiredSpeed() <= 0.0 || actor.MovementType == SF2NPCMoveType_Attack || (path.IsValid() && GetVectorSquareMagnitude(myPos, goalPos) <= Pow(16.0, 2.0)))
	{
		action.LastStuckTime = gameTime;
		return;
	}

	float lastPos[3];
	action.GetLastPos(lastPos);

	if (bot.IsRangeLessThanEx(lastPos, 0.13) || loco.GetGroundSpeed() <= 0.1)
	{
		if (action.LastStuckTime > gameTime - 0.75)
		{
			return;
		}
		float destination[3];
		if (!NPCFindUnstuckPosition(actor, lastPos, destination))
		{
			float mins[3], maxs[3];
			actor.GetPropVector(Prop_Send, "m_vecMins", mins);
			actor.GetPropVector(Prop_Send, "m_vecMaxs", maxs);
			float range = ((maxs[0] + maxs[1]) / 2.0) + (FloatAbs(mins[0] + mins[1]) / 2.0);
			if (GetVectorDistance(myPos, goalPos, true) > Pow(range + 16.0, 2.0))
			{
				controller.UnSpawn(true);
				return;
			}
		}
		action.LastStuckTime = gameTime + 0.75;
		actor.Teleport(destination, NULL_VECTOR, NULL_VECTOR);
	}
	else
	{
		loco.GetFeet(lastPos);
		action.SetLastPos(lastPos);
		action.LastStuckTime += 0.03;
		if (action.LastStuckTime > gameTime)
		{
			action.LastStuckTime = gameTime;
		}
	}
}

static void OnContact(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity other, Address result)
{
	if (IsValidClient(other.index))
	{
		return;
	}

	char classname[64];
	other.GetClassname(classname, sizeof(classname));
	if (strcmp(classname, "obj_dispenser", false) == 0 ||
		strcmp(classname, "obj_teleporter", false) == 0 || strcmp(classname, "func_breakable", false) == 0)
	{
		SDKHooks_TakeDamage(other.index, actor.index, actor.index, other.GetProp(Prop_Data, "m_iHealth") * 4.0, .bypassHooks = false);
	}

	// Destroy mini sentires, not non-mini sentries
	if (strcmp(classname, "obj_sentrygun", false) == 0 && other.GetProp(Prop_Send, "m_bMiniBuilding"))
	{
		SDKHooks_TakeDamage(other.index, actor.index, actor.index, other.GetProp(Prop_Data, "m_iHealth") * 4.0, .bypassHooks = false);
	}

	if (strcmp(classname, "prop_physics") == 0 || strcmp(classname, "prop_dynamic") == 0)
	{
		if (other.GetProp(Prop_Data, "m_iHealth") > 0)
		{
			SDKHooks_TakeDamage(other.index, actor.index, actor.index, other.GetProp(Prop_Data, "m_iHealth") * 4.0, .bypassHooks = false);
		}
	}
}

static int OnKilled(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damageType, CBaseEntity weapon, const float damageForce[3], const float damagePosition[3], int damageCustom)
{
	actor.State = STATE_DEATH;
	Call_StartForward(g_OnBossKilledFwd);
	Call_PushCell(actor.Controller);
	Call_PushCell(attacker.index);
	Call_Finish();
	return action.TryChangeTo(SF2_ChaserDeathAction(attacker), RESULT_CRITICAL);
}

static void OnLeaveGround(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity ground)
{
	if (actor.State != STATE_IDLE && actor.State != STATE_ALERT && actor.State != STATE_CHASE)
	{
		return;
	}

	if (actor.IsSpawning)
	{
		return;
	}

	if (!actor.IsJumping)
	{
		return;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(actor.index);
	NextBotGroundLocomotion loco = npc.GetLocomotion();
	float velocity[3];
	actor.MyNextBotPointer().GetLocomotionInterface().GetVelocity(velocity);
	velocity[2] += loco.GetStepHeight() * 4.0;
	//loco.SetVelocity(velocity);

	float duration = 0.0, rate = 1.0, cycle = 0.0;
	int sequence = -1;
	if (actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Jump], .sequence = sequence, .duration = duration, .rate = rate, .cycle = cycle))
	{
		if (duration <= 0.0)
		{
			duration = actor.SequenceDuration(sequence) / rate;
			duration *= (1.0 - cycle);
		}
		actor.AirTime = duration;
		actor.IsInAirAnimation = true;
	}

	actor.PerformVoice(SF2BossSound_Jump);
}

static int OnLandOnGround(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity ground)
{
	if (!actor.CanLand)
	{
		actor.CanLand = true;
		return action.TryContinue();
	}

	if (actor.State != STATE_IDLE && actor.State != STATE_ALERT && actor.State != STATE_CHASE)
	{
		return action.TryContinue();
	}

	if (actor.IsSpawning)
	{
		return action.TryContinue();
	}

	if (actor.IsJumping)
	{
		actor.IsJumping = false;
	}

	if (actor.IsInAirAnimation)
	{
		actor.IsInAirAnimation = false;
		actor.UpdateMovementAnimation();
	}

	actor.AirTime = 0.0;

	SF2NPC_Chaser controller = actor.Controller;
	if (controller.GetProfileData().GetAnimations().HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_Land]))
	{
		actor.AddGesture(g_SlenderAnimationsList[SF2BossAnimation_Land]);
		return action.TrySuspendFor(SF2_PlaySequenceAndWaitEx(g_SlenderAnimationsList[SF2BossAnimation_Land]), RESULT_CRITICAL);
	}

	return action.TryContinue();
}

static int OnCommandString(SF2_ChaserMainAction action, SF2_ChaserEntity actor, const char[] command)
{
	if (actor.IsSpawning)
	{
		return action.TryContinue();
	}

	if (StrContains(command, "debug attack ") == 0 && !actor.IsAttacking)
	{
		SF2NPC_Chaser controller = actor.Controller;
		int difficulty = controller.Difficulty;
		char attack[128];
		strcopy(attack, sizeof(attack), command);
		ReplaceString(attack, sizeof(attack), "debug attack ", "");
		ChaserBossProfile data = controller.GetProfileData();
		ChaserBossProfileBaseAttack attackData = data.GetAttack(attack);
		return action.TrySuspendFor(SF2_ChaserAttackAction(data, attack, data.IndexOfSection(attackData), attackData.GetDuration(difficulty)), RESULT_IMPORTANT);
	}

	if (strcmp(command, "suspend for action") == 0)
	{
		NextBotAction nbAction = actor.GetSuspendForAction();
		if (nbAction != NULL_ACTION)
		{
			return action.TrySuspendFor(nbAction, RESULT_CRITICAL);
		}
	}

	return action.TryContinue();
}
