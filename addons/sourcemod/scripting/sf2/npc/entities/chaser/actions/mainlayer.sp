#pragma semicolon 1
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
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.SetEventCallback(EventResponderType_OnContact, OnContact);
			g_Factory.SetEventCallback(EventResponderType_OnKilled, OnKilled);
			g_Factory.SetEventCallback(EventResponderType_OnLeaveGround, OnLeaveGround);
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

	float gameTime = GetGameTime();

	int difficulty = controller.Difficulty;

	actor.FollowOtherBossAlert();

	actor.FollowOtherBossChase();

	if (actor.State == STATE_ATTACK)
	{
		actor.DoAttackMiscConditions(actor.GetAttackName());
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();
	if (data.FlashlightStun[difficulty] && actor.CanBeStunned() && actor.CanTakeDamage())
	{
		bool inFlashlight = false;
		float customDamage = 1.0;
		bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!IsTargetValidForSlender(player, attackEliminated))
			{
				continue;
			}

			if (!player.UsingFlashlight)
			{
				continue;
			}

			float hisPos[3], myPos[3], eyeAng[3], requiredAng[3];
			player.GetAbsOrigin(hisPos);
			actor.GetAbsOrigin(myPos);

			if (GetVectorDistance(myPos, hisPos, true) > Pow(SF2_FLASHLIGHT_LENGTH, 2.0))
			{
				continue;
			}

			player.GetEyeAngles(eyeAng);
			SubtractVectors(hisPos, myPos, requiredAng);
			GetVectorAngles(requiredAng, requiredAng);

			if (FloatAbs(AngleDiff(eyeAng[0], requiredAng[0])) <= 35.0 && FloatAbs(AngleDiff(requiredAng[1], eyeAng[1])) < 145.0)
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
			break;
		}

		if (SF_SpecialRound(SPECIALROUND_NIGHTVISION) || g_NightvisionEnabledConVar.BoolValue)
		{
			inFlashlight = false;
		}

		if (inFlashlight)
		{
			actor.StunHealth -= data.FlashlightDamage[difficulty] * customDamage;
			if (actor.StunHealth <= 0.0)
			{
				return action.SuspendFor(SF2_ChaserStunnedAction(), "I was stunned by a flashlight");
			}
		}
	}

	if (originalData.InstantKillRadius > 0.0)
	{
		if (gameTime >= actor.LastKillTime && !actor.IsKillingSomeone)
		{
			float worldSpace[3], myPos[3];
			actor.WorldSpaceCenter(worldSpace);
			actor.GetAbsOrigin(myPos);
			bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
			if (view_as<SF2NPC_BaseNPC>(controller).GetProfileData().IsPvEBoss)
			{
				attackEliminated = true;
			}
			ArrayList playersList = new ArrayList();
			TR_EnumerateEntitiesSphere(worldSpace, originalData.InstantKillRadius, PARTITION_SOLID_EDICTS, EnumerateLivingPlayers, playersList);
			for (int i = 0; i < playersList.Length; i++)
			{
				SF2_BasePlayer client = SF2_BasePlayer(playersList.Get(i));
				if (!attackEliminated && client.IsEliminated)
				{
					continue;
				}

				if (client.IsInDeathCam)
				{
					continue;
				}

				if (actor.MyNextBotPointer().GetRangeSquaredTo(client.index) > Pow(originalData.InstantKillRadius, 2.0) ||
					!client.CanSeeSlender(controller.Index, false, _, !attackEliminated))
				{
					continue;
				}

				actor.LastKillTime = gameTime + originalData.InstantKillCooldown[difficulty];
				client.StartDeathCam(controller.Index, myPos);
				actor.CheckTauntKill(SF2_BasePlayer(client.index));
			}
			delete playersList;
		}
	}

	if (actor.IsKillingSomeone)
	{
		return action.SuspendFor(SF2_DeathCamAction());
	}

	UnstuckCheck(action, actor);

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
		float myPos[3];
		actor.GetAbsOrigin(myPos);
		ArrayList props = new ArrayList();
		TR_EnumerateEntitiesSphere(myPos, 2000.0, PARTITION_SOLID_EDICTS, EnumerateBreakableEntities, props);
		for (int i = 0; i < props.Length; i++)
		{
			if (!actor.IsLOSClearFromTarget(CBaseEntity(props.Get(i))))
			{
				continue;
			}

			NextBotAction attackAction = actor.GetAttackAction(props.Get(i), true);
			if (attackAction != NULL_ACTION)
			{
				actor.EndCloak();
				delete props;
				return action.SuspendFor(attackAction, "Fuck you prop.");
			}
		}
		delete props;
	}

	return action.Continue();
}

static int OnResume(SF2_ChaserMainAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	action.LastStuckTime = GetGameTime() + 0.75;
	actor.UpdateMovementAnimation();
	return action.Continue();
}

static int OnInjured(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damageType)
{
	if (actor.CanBeStunned() && IsValidClient(attacker.index) && actor.CanTakeDamage(attacker, inflictor, damage))
	{
		actor.StunHealth -= damage;
		if (actor.StunHealth <= 0.0)
		{
			return action.TrySuspendFor(SF2_ChaserStunnedAction(), RESULT_IMPORTANT, "I was stunned by someone");
		}
	}

	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	int search = actor.RageIndex + 1;
	if ((data.BoxingBoss || view_as<SF2NPC_BaseNPC>(controller).GetProfileData().IsPvEBoss) &&
		actor.CanTakeDamage(attacker, inflictor, damage) && data.Rages != null && search < data.Rages.Length && !actor.IsRaging)
	{
		SF2ChaserRageInfo rageInfo;
		data.Rages.GetArray(search, rageInfo, sizeof(rageInfo));
		if (float(actor.GetProp(Prop_Data, "m_iHealth")) <= actor.MaxHealth * rageInfo.PercentageThreshold)
		{
			return action.TrySuspendFor(SF2_ChaserRageAction(), RESULT_IMPORTANT, "I need to rage!");
		}
	}

	return action.TryContinue();
}

static void OnAnimationEvent(SF2_ChaserMainAction action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	actor.CastAnimEvent(event);
	actor.CastAnimEvent(event, true);
}

static void UnstuckCheck(SF2_ChaserMainAction action, SF2_ChaserEntity actor)
{
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	SF2NPC_Chaser controller = actor.Controller;
	PathFollower path = controller.Path;
	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(actor.index);
	float gameTime = GetGameTime();

	if (!path.IsValid() || !actor.IsAttemptingToMove || loco.GetDesiredSpeed() <= 0.0)
	{
		action.LastStuckTime = gameTime;
		return;
	}

	float lastPos[3], myPos[3];
	action.GetLastPos(lastPos);
	actor.GetAbsOrigin(myPos);

	if (bot.IsRangeLessThanEx(lastPos, 0.13) || loco.GetGroundSpeed() <= 0.1)
	{
		if (action.LastStuckTime > gameTime - 0.75)
		{
			return;
		}
		float destination[3];
		CNavArea area = TheNavMesh.GetNearestNavArea(lastPos, _, _, _, false);
		area.GetCenter(destination);
		float tempMaxs[3];
		npc.GetBodyMaxs(tempMaxs);
		float traceMins[3];
		traceMins[0] = g_SlenderDetectMins[controller.Index][0] - 5.0;
		traceMins[1] = g_SlenderDetectMins[controller.Index][1] - 5.0;
		traceMins[2] = 0.0;

		float traceMaxs[3];
		traceMaxs[0] = g_SlenderDetectMaxs[controller.Index][0] + 5.0;
		traceMaxs[1] = g_SlenderDetectMaxs[controller.Index][1] + 5.0;
		traceMaxs[2] = tempMaxs[2];
		TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
		if (GetVectorSquareMagnitude(destination, lastPos) <= SquareFloat(16.0) || TR_DidHit())
		{
			CursorData cursor = path.GetCursorData();
			SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, 256.0);
			int areaCount = collector.Count();
			ArrayList areaArray = new ArrayList(1, areaCount);
			int validAreaCount = 0;
			for (int i = 0; i < areaCount; i++)
			{
				if (collector.Get(i).GetCostSoFar() < 16.0)
				{
					continue;
				}
				if (cursor.segmentPrior != NULL_PATH_SEGMENT)
				{
					CNavArea segmentArea = cursor.segmentPrior.area;
					if (segmentArea == collector.Get(i))
					{
						continue;
					}
				}
				float navPos[3];
				collector.Get(i).GetCenter(navPos);
				if (GetVectorSquareMagnitude(myPos, navPos) <= SquareFloat(16.0))
				{
					continue;
				}
				areaArray.Set(validAreaCount, i);
				validAreaCount++;
			}

			int randomArea = 0, randomCell = 0;
			areaArray.Resize(validAreaCount);
			area = NULL_AREA;
			while (validAreaCount > 1)
			{
				randomCell = GetRandomInt(0, validAreaCount - 1);
				randomArea = areaArray.Get(randomCell);
				area = collector.Get(randomArea);
				area.GetCenter(destination);

				TR_TraceHullFilter(destination, destination, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntityEx);
				if (TR_DidHit())
				{
					area = NULL_AREA;
					validAreaCount--;
					int findValue = areaArray.FindValue(randomCell);
					if (findValue != -1)
					{
						areaArray.Erase(findValue);
					}
				}
				else
				{
					break;
				}
			}

			delete collector;
			delete areaArray;
		}
		path.GetClosestPosition(destination, destination, path.FirstSegment(), 128.0);
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
	if (strcmp(classname, "obj_sentrygun", false) == 0 || strcmp(classname, "obj_dispenser", false) == 0 ||
		strcmp(classname, "obj_teleporter", false) == 0 || strcmp(classname, "func_breakable", false) == 0)
	{
		int health = other.GetProp(Prop_Data, "m_iHealth");
		SDKHooks_TakeDamage(other.index, actor.index, actor.index, health * 4.0);
	}

	if (strcmp(classname, "prop_physics") == 0 || strcmp(classname, "prop_dynamic") == 0)
	{
		if (other.GetProp(Prop_Data, "m_iHealth") > 0)
		{
			SDKHooks_TakeDamage(other.index, actor.index, actor.index, other.GetProp(Prop_Data, "m_iHealth") * 4.0);
		}
	}
	if (strncmp(classname, "obj_", 4) == 0)
	{
		if (other.GetProp(Prop_Data, "m_iHealth") > 0)
		{
			SDKHooks_TakeDamage(other.index, actor.index, actor.index, other.GetProp(Prop_Data, "m_iHealth") * 4.0);
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
	if (!actor.IsJumping)
	{
		return;
	}

	CBaseNPC npc = TheNPCs.FindNPCByEntIndex(actor.index);
	NextBotGroundLocomotion loco = npc.GetLocomotion();
	float velocity[3];
	actor.MyNextBotPointer().GetLocomotionInterface().GetVelocity(velocity);
	velocity[2] += loco.GetStepHeight() * 4.0;
	loco.SetVelocity(velocity);
	actor.IsJumping = false;
}

static int OnCommandString(SF2_ChaserMainAction action, SF2_ChaserEntity actor, const char[] command)
{
	if (StrContains(command, "debug attack ") == 0 && !actor.IsAttacking)
	{
		SF2NPC_Chaser controller = actor.Controller;
		int difficulty = controller.Difficulty;
		char attack[128];
		strcopy(attack, sizeof(attack), command);
		ReplaceString(attack, sizeof(attack), "debug attack ", "");
		SF2ChaserBossProfileData data;
		data = controller.GetProfileData();
		SF2ChaserBossProfileAttackData attackData;
		data.GetAttack(attack, attackData);
		return action.TrySuspendFor(SF2_ChaserAttackAction(attack, attackData.Index, attackData.Duration[difficulty] + GetGameTime()), RESULT_IMPORTANT);
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
