#pragma semicolon 1
#pragma newdecls required

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
			return EntRefToEntIndex(this.GetDataEnt("m_Attacker"));
		}

		public set(int value)
		{
			this.SetDataEnt("m_Attacker", EnsureEntRef(value));
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserDeathAction action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();

	controller.WasKilled = true;

	actor.IsAttemptingToMove = false;
	loco.Stop();

	actor.EndCloak();

	actor.PerformVoice(SF2BossSound_Death);

	actor.State = STATE_DEATH;

	if (data.IsPvEBoss)
	{
		KillPvEBoss(actor.index);
	}

	if (data.GetAnimations().HasAnimationSection(g_SlenderAnimationsList[SF2BossAnimation_Death]))
	{
		return SF2_PlaySequenceAndWaitEx(g_SlenderAnimationsList[SF2BossAnimation_Death]);
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserDeathAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileDeathData deathData = data.GetDeathBehavior();
	actor.GroundSpeedOverride = true;
	int difficulty = controller.Difficulty;

	if (deathData.GetOnStartEffects() != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(deathData.GetOnStartEffects(), controller.Index, false, pos, ang, _, _, false);
	}

	if (deathData.GetOnStartInputs() != null)
	{
		deathData.GetOnStartInputs().AcceptInputs(actor.index, action.Attacker, action.Attacker);
	}

	if (deathData.KeyDrop)
	{
		char model[PLATFORM_MAX_PATH], trigger[64];
		deathData.GetKeyModel(model, sizeof(model));
		deathData.GetKeyTrigger(trigger, sizeof(trigger));
		if (SF_IsBoxingMap() && data.BoxingBoss && !g_SlenderBoxingBossIsKilled[controller.Index] && data.IsPvEBoss)
		{
			g_SlenderBoxingBossKilled++;
			if ((g_SlenderBoxingBossKilled == g_SlenderBoxingBossCount))
			{
				NPC_DropKey(controller.Index, model, trigger);
			}
			g_SlenderBoxingBossIsKilled[controller.Index] = true;
		}
		else
		{
			NPC_DropKey(controller.Index, model, trigger);
		}
	}

	actor.DropItem(true);

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	if (deathData.GetAddHealthPerDeath(difficulty) > 0.0)
	{
		controller.SetDeathHealth(difficulty, controller.GetDeathHealth(difficulty) + deathData.GetAddHealthPerDeath(difficulty));
	}

	controller.SetAddSpeed(deathData.GetAddRunSpeed(difficulty));
	controller.SetAddAcceleration(deathData.GetAddAcceleration(difficulty));

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

	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileDeathData deathData = data.GetDeathBehavior();

	if (deathData.GetOnEndEffects() != null)
	{
		float pos[3], ang[3];
		actor.GetAbsOrigin(pos);
		actor.GetAbsAngles(ang);
		SlenderSpawnEffects(deathData.GetOnEndEffects(), controller.Index, false, pos, ang, _, _, false);
	}

	if (deathData.GetOnEndInputs() != null)
	{
		deathData.GetOnEndInputs().AcceptInputs(actor.index, action.Attacker, action.Attacker);
	}

	data.SetBool("__was_killed", true);

	if (deathData.RemoveOnDeath)
	{
		SpawnGibs(actor);
		if (deathData.RagdollOnDeath)
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
	else if (deathData.DisappearOnDeath)
	{
		SpawnGibs(actor);
		controller.UnSpawn(true);
	}
	else if (deathData.RagdollOnDeath)
	{
		actor.AcceptInput("BecomeRagdoll");
	}
}

static void SpawnGibs(SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfile data = controller.GetProfileData();
	ChaserBossProfileDeathData deathData = data.GetDeathBehavior();
	if (deathData.GetGibs() == null)
	{
		return;
	}
	float pos[3], ang[3], vel[3];
	char model[PLATFORM_MAX_PATH];
	actor.WorldSpaceCenter(pos);
	actor.GetAbsAngles(ang);
	for (int i = 0; i < deathData.GetGibs().Size; i++)
	{
		ang[1] = GetRandomFloat(-180.0, 180.0);

		for(int i2 = 0; i2 < 2; i2++)
		{
			vel[i2] += GetRandomFloat(-300.0, 300.0);
		}
		vel[2] = GetRandomFloat(-300.0, 300.0);

		char name[64];
		data.GetRages().GetKeyNameFromIndex(i, name, sizeof(name));
		if (strcmp(name, "skin") == 0)
		{
			continue;
		}
		deathData.GetGibs().GetString(name, model, sizeof(model));

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
			gib.SetProp(Prop_Send, "m_nSkin", deathData.GibSkin);

			int effects = 16 | 64;
			gib.SetProp(Prop_Send, "m_fEffects", effects);

			SetVariantString("OnUser1 !self:Kill::10.0:1");
			gib.AcceptInput("AddOutput");
			gib.AcceptInput("FireUser1");
		}
	}
}
