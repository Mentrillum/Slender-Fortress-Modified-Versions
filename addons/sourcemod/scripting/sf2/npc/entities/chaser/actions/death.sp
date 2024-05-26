#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserDeathAction < NextBotAction
{
	public SF2_ChaserDeathAction(CBaseEntity attacker = view_as<CBaseEntity>(-1))
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_Death");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineEntityField("m_Attacker")
				.EndDataMapDesc();
		}
		SF2_ChaserDeathAction action = view_as<SF2_ChaserDeathAction>(g_Factory.Create());

		action.Attacker = attacker.index;
		return action;
	}

	property int Attacker
	{
		public get()
		{
			return this.GetDataEnt("m_Attacker");
		}

		public set(int value)
		{
			this.SetDataEnt("m_Attacker", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserDeathAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();
	int difficulty = controller.Difficulty;
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();

	controller.WasKilled = true;

	actor.IsAttemptingToMove = false;
	loco.Stop();

	actor.EndCloak();

	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	actor.PerformVoice(SF2BossSound_Death);

	actor.State = STATE_DEATH;

	if (originalData.IsPvEBoss)
	{
		KillPvEBoss(actor.index);
	}

	if (originalData.AnimationData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Death], difficulty, animName, sizeof(animName), rate, duration, cycle))
	{
		int sequence = actor.SelectProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Death], rate, duration, cycle);
		if (sequence != -1)
		{
			return SF2_PlaySequenceAndWait(sequence, duration, rate, cycle);
		}
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserDeathAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	actor.GroundSpeedOverride = true;
	int difficulty = controller.Difficulty;

	if (data.DeathData.StartEffects != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(data.DeathData.StartEffects, controller.Index, false, pos, ang, _, _, true);
	}

	if (data.DeathData.KeyDrop)
	{
		if (SF_IsBoxingMap() && data.BoxingBoss && !g_SlenderBoxingBossIsKilled[controller.Index] && !view_as<SF2NPC_BaseNPC>(controller).GetProfileData().IsPvEBoss)
		{
			g_SlenderBoxingBossKilled++;
			if ((g_SlenderBoxingBossKilled == g_SlenderBoxingBossCount))
			{
				NPC_DropKey(controller.Index, data.DeathData.KeyModel, data.DeathData.KeyTrigger);
			}
			g_SlenderBoxingBossIsKilled[controller.Index] = true;
		}
		else
		{
			NPC_DropKey(controller.Index, data.DeathData.KeyModel, data.DeathData.KeyTrigger);
		}
	}

	actor.DropItem(true);

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	if (data.DeathData.AddHealthPerDeath[difficulty] > 0.0)
	{
		controller.SetDeathHealth(difficulty, controller.GetDeathHealth(difficulty) + data.DeathData.AddHealthPerDeath[difficulty]);
	}

	return action.Continue();
}

static int Update(SF2_ChaserDeathAction action, SF2_ChaserEntity actor, float interval)
{
	if (action.ActiveChild != NULL_ACTION)
	{
		return action.Continue();
	}

	return action.Done("I am actually fully dead now");
}

static void OnEnd(SF2_ChaserDeathAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;

	if (!controller.IsValid())
	{
		return;
	}

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();

	if (data.DeathData.EndEffects != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(data.DeathData.EndEffects, controller.Index, false, pos, ang, _, _, true);
	}

	if (data.DeathData.RemoveOnDeath)
	{
		SpawnGibs(actor);
		if (data.DeathData.RagdollOnDeath)
		{
			actor.AcceptInput("BecomeRagdoll");
		}
		if (controller.IsCopy)
		{
			controller.Remove();
		}
		else
		{
			SF2NPC_BaseNPC newMaster = SF2_INVALID_NPC;
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_BaseNPC other = SF2NPC_BaseNPC(i);
				if (!other.IsValid())
				{
					continue;
				}

				if (other == controller)
				{
					continue;
				}

				if (!other.IsCopy)
				{
					continue;
				}

				if (other.CopyMaster == controller && CBaseEntity(other.EntIndex).IsValid())
				{
					newMaster = other;
					newMaster.CopyMaster = SF2_INVALID_NPC;
					break;
				}
			}

			// Let's switch copy masters
			if (newMaster.IsValid())
			{
				for (int i = 0; i < MAX_BOSSES; i++)
				{
					SF2NPC_BaseNPC other = SF2NPC_BaseNPC(i);
					if (!other.IsValid())
					{
						continue;
					}

					if (other == controller)
					{
						continue;
					}

					if (!other.IsCopy)
					{
						continue;
					}

					if (other.CopyMaster == controller)
					{
						other.CopyMaster = newMaster;
					}
				}
			}

			controller.Remove();
		}
	}
	else if (data.DeathData.DisappearOnDeath)
	{
		SpawnGibs(actor);
		controller.UnSpawn(true);
	}
	else if (data.DeathData.RagdollOnDeath)
	{
		actor.AcceptInput("BecomeRagdoll");
	}
}

static void OnAnimationEvent(SF2_ChaserDeathAction action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	actor.CastAnimEvent(event);
	actor.CastAnimEvent(event, true);
}

static void SpawnGibs(SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	if (data.DeathData.Gibs == null)
	{
		return;
	}
	float pos[3], ang[3], vel[3];
	char model[PLATFORM_MAX_PATH];
	actor.WorldSpaceCenter(pos);
	actor.GetAbsAngles(ang);
	for (int i = 0; i < data.DeathData.Gibs.Length; i++)
	{
		ang[1] = GetRandomFloat(-180.0, 180.0);

		for(int i2 = 0; i2 < 2; i2++)
		{
			vel[i2] += GetRandomFloat(-300.0, 300.0);
		}
		vel[2] = GetRandomFloat(-300.0, 300.0);

		data.DeathData.Gibs.GetString(i, model, sizeof(model));

		if (strlen(model) > 0)
		{
			CBaseEntity gib = CBaseEntity(CreateEntityByName("prop_physics_multiplayer"));
			gib.KeyValue("model", model);
			gib.KeyValue("physicsmode", "2");

			gib.Teleport(pos, ang, vel);
			gib.Spawn();
			gib.Teleport(NULL_VECTOR, NULL_VECTOR, vel);

			SetEntityCollisionGroup(gib.index, 1);
			gib.SetProp(Prop_Send, "m_usSolidFlags", 0);
			gib.SetProp(Prop_Send, "m_nSolidType", 2);
			gib.SetProp(Prop_Send, "m_nSkin", data.DeathData.GibSkin);

			int effects = 16 | 64;
			gib.SetProp(Prop_Send, "m_fEffects", effects);

			SetVariantString("OnUser1 !self:Kill::10.0:1");
			gib.AcceptInput("AddOutput");
			gib.AcceptInput("FireUser1");
		}
	}
}
