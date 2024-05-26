#pragma semicolon 1
// This manages the end time and getting a attack

#include "attacks/melee.sp"
#include "attacks/bullet.sp"
#include "attacks/projectile.sp"
#include "attacks/laser_beam.sp"
#include "attacks/explosive_dance.sp"
#include "attacks/custom.sp"
#include "attacks/tongue.sp"
#include "attacks/forward_based.sp"

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction < NextBotAction
{
	public SF2_ChaserAttackAction(const char[] attackName, int attackIndex, float endTime)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackMain");
			g_Factory.SetCallback(NextBotActionCallbackType_InitialContainedAction, InitialContainedAction);
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnSuspend, OnSuspend);
			g_Factory.SetCallback(NextBotActionCallbackType_OnResume, OnResume);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnOtherKilled, OnOtherKilled);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_OldState")
				.DefineIntField("m_OldMovementType")
				.DefineStringField("m_AttackName")
				.DefineIntField("m_AttackIndex")
				.DefineFloatField("m_EndTime")
				.DefineBoolField("m_DidEndAnimation")
				.DefineBoolField("m_PlayedBeginVoice")
				.DefineBoolField("m_ShouldReplayAnimation")
				.DefineStringField("m_LoopSound")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction action = view_as<SF2_ChaserAttackAction>(g_Factory.Create());

		action.SetAttackName(attackName);
		action.EndTime = endTime;

		return action;
	}

	public static void Initialize()
	{
		SF2_ChaserAttackAction_Melee.Initialize();
		SF2_ChaserAttackAction_ExplosiveDance.Initialize();
		SF2_ChaserAttackAction_Bullet.Initialize();
		SF2_ChaserAttackAction_Projectile.Initialize();
		SF2_ChaserAttackAction_Laser.Initialize();
		SF2_ChaserAttackAction_Custom.Initialize();
		SF2_ChaserAttackAction_Tongue.Initialize();
		SF2_ChaserAttackAction_ForwardBased.Initialize();
	}

	property int OldState
	{
		public get()
		{
			return this.GetData("m_OldState");
		}

		public set(int value)
		{
			this.SetData("m_OldState", value);
		}
	}

	property SF2NPCMoveTypes OldMovementType
	{
		public get()
		{
			return this.GetData("m_OldMovementType");
		}

		public set(SF2NPCMoveTypes value)
		{
			this.SetData("m_OldMovementType", value);
		}
	}

	public char[] GetAttackName()
	{
		char name[128];
		this.GetDataString("m_AttackName", name, sizeof(name));
		return name;
	}

	public void SetAttackName(const char[] name)
	{
		this.SetDataString("m_AttackName", name);
	}

	property int AttackIndex
	{
		public get()
		{
			return this.GetData("m_AttackIndex");
		}

		public set(int value)
		{
			this.SetData("m_AttackIndex", value);
		}
	}

	property float EndTime
	{
		public get()
		{
			return this.GetDataFloat("m_EndTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_EndTime", value);
		}
	}

	property bool DidEndAnimation
	{
		public get()
		{
			return this.GetData("m_DidEndAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_DidEndAnimation", value);
		}
	}

	public char[] GetLoopSound()
	{
		char name[PLATFORM_MAX_PATH];
		this.GetDataString("m_LoopSound", name, sizeof(name));
		return name;
	}

	public void SetLoopSound(const char[] name)
	{
		this.SetDataString("m_LoopSound", name);
	}

	property bool PlayedBeginVoice
	{
		public get()
		{
			return this.GetData("m_PlayedBeginVoice") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_PlayedBeginVoice", value);
		}
	}

	property bool ShouldReplayAnimation
	{
		public get()
		{
			return this.GetData("m_ShouldReplayAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_ShouldReplayAnimation", value);
		}
	}
}

static NextBotAction InitialContainedAction(SF2_ChaserAttackAction action, SF2_ChaserEntity actor)
{
	actor.MyNextBotPointer().GetLocomotionInterface().Stop();
	actor.Controller.Path.Invalidate();

	NextBotAction attackAction = NULL_ACTION;

	Action result = Plugin_Continue;
	Call_StartForward(g_OnChaserGetAttackActionPFwd);
	Call_PushCell(actor);
	Call_PushString(action.GetAttackName());
	Call_PushCellRef(attackAction);
	Call_Finish(result);

	if (result == Plugin_Changed)
	{
		return attackAction;
	}

	return NULL_ACTION;
}

static int OnStart(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	SF2NPC_Chaser controller = actor.Controller;
	if (controller.Flags & SFF_FAKE)
	{
		controller.MarkAsFake();
		return action.Done("I'm a faker, bye");
	}

	if (action.ActiveChild == NULL_ACTION)
	{
		return action.Done("No attack action was given");
	}

	actor.SetAttackName(action.GetAttackName());
	actor.AttackIndex = action.AttackIndex;
	actor.IsAttacking = true;

	actor.RemoveAllGestures();
	CBaseNPC_RemoveAllLayers(actor.index);

	int difficulty = controller.Difficulty;
	float gameTime = GetGameTime();
	SF2ChaserBossProfileData data;
	SF2ChaserBossProfileAttackData attackData;
	data = controller.GetProfileData();
	data.GetAttack(actor.GetAttackName(), attackData);
	actor.AttackRunDelay = gameTime + attackData.RunDelay[difficulty];
	actor.AttackRunDuration = gameTime + attackData.RunDuration[difficulty];
	actor.MyNextBotPointer().GetLocomotionInterface().Stop();
	controller.Path.Invalidate();

	if (actor.State == STATE_CHASE)
	{
		actor.CurrentChaseDuration += data.ChaseDurationAddOnAttack[difficulty];
		if (actor.CurrentChaseDuration > data.ChaseDuration[difficulty])
		{
			actor.CurrentChaseDuration = data.ChaseDuration[difficulty];
		}
	}

	action.OldState = actor.State;
	action.OldMovementType = actor.MovementType;
	actor.State = STATE_ATTACK;

	actor.InvokeOnStartAttack(action.GetAttackName());

	if (attackData.StartEffects != null)
	{
		SlenderSpawnEffects(attackData.StartEffects, controller.Index, false);
	}

	if (attackData.RunSpeed[difficulty] > 0.0)
	{
		actor.MovementType = SF2NPCMoveType_Attack;
	}

	if (attackData.Type == SF2BossAttackType_Custom)
	{
		return action.Continue();
	}

	actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], _, action.GetAttackName());
	actor.AddGesture(g_SlenderAnimationsList[SF2BossAnimation_Attack], _, action.GetAttackName());

	SF2BossProfileSoundInfo info;
	if (actor.SearchSoundsWithSectionName(data.AttackBeginSounds, action.GetAttackName(), info))
	{
		action.PlayedBeginVoice = actor.PerformVoice(SF2BossSound_AttackBegin, action.GetAttackName());
	}
	else
	{
		actor.PerformVoice(SF2BossSound_Attack, action.GetAttackName());
		action.PlayedBeginVoice = true;
	}

	float duration = 0.0;
	NextBotAction newAction = actor.IsAttackTransitionPossible(action.GetAttackName(), _, duration);
	action.ShouldReplayAnimation = newAction != NULL_ACTION;
	if (newAction != NULL_ACTION)
	{
		action.EndTime += duration;
	}
	return newAction != NULL_ACTION ? action.SuspendFor(newAction) : action.Continue();
}

static int Update(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;

	if (!controller.IsValid())
	{
		return action.Done();
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	SF2ChaserBossProfileData data;
	SF2ChaserBossProfileAttackData attackData;
	int interrputConditions = actor.InterruptConditions;
	data = controller.GetProfileData();
	data.GetAttack(actor.GetAttackName(), attackData);
	bool end = false;
	INextBot bot = actor.MyNextBotPointer();
	PathFollower path = controller.Path;
	ILocomotion loco = bot.GetLocomotionInterface();

	int difficulty = controller.Difficulty;

	CBaseEntity target = actor.Target;
	if (target.IsValid())
	{
		float myPos[3], targetPos[3];
		actor.GetAbsOrigin(myPos);
		target.GetAbsOrigin(targetPos);
		float distance = GetVectorSquareMagnitude(myPos, targetPos);
		if (attackData.CancelDistance[difficulty] >= 0.0 && distance > Pow(attackData.CancelDistance[difficulty], 2.0))
		{
			end = true;
		}

		if (attackData.MinCancelDistance[difficulty] >= 0.0 && distance < Pow(attackData.MinCancelDistance[difficulty], 2.0))
		{
			end = true;
		}

		if (attackData.CancelLos[difficulty] && (actor.InterruptConditions & COND_ENEMYVISIBLE) == 0)
		{
			end = true;
		}

		if (actor.MovementType == SF2NPCMoveType_Attack)
		{
			if (actor.Teleporters.Length > 0)
			{
				CBaseEntity(actor.Teleporters.Get(0)).GetAbsOrigin(targetPos);
			}

			if (!bot.IsRangeLessThanEx(targetPos, 8.0))
			{
				if ((interrputConditions & COND_NEWENEMY) != 0 || path.GetAge() > 0.3 || (path.IsValid() && (path.GetLength() - path.GetCursorPosition()) < 256.0))
				{
					path.ComputeToPos(bot, targetPos);
				}
			}
		}
	}

	if (!path.IsValid())
	{
		loco.Stop();
		actor.IsAttemptingToMove = false;
	}
	else
	{
		path.Update(bot);
		actor.IsAttemptingToMove = true;
	}

	if (attackData.Type == SF2BossAttackType_Custom)
	{
		if (action.ActiveChild == NULL_ACTION || end)
		{
			return action.Done("Done using a custom attack");
		}
		return action.Continue();
	}

	SF2BossProfileSoundInfo info;
	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] == '\0')
	{
		if (actor.SearchSoundsWithSectionName(data.AttackLoopSounds, action.GetAttackName(), info))
		{
			char sound[PLATFORM_MAX_PATH];
			info.EmitSound(_, actor.index, _, _, _, sound);
			action.SetLoopSound(sound);
		}
		else
		{
			action.SetLoopSound("-");
		}
	}

	if (action.ActiveChild == NULL_ACTION || GetGameTime() > action.EndTime || end)
	{
		NextBotAction newAction = actor.IsAttackTransitionPossible(action.GetAttackName(), true);
		if (!action.DidEndAnimation && newAction != NULL_ACTION)
		{
			actor.PerformVoice(SF2BossSound_AttackEnd, action.GetAttackName());
			action.DidEndAnimation = true;
			if (newAction != NULL_ACTION)
			{
				return action.SuspendFor(newAction, "We're gonna do a attack end action");
			}
		}
		return action.Done("Attack finished");
	}

	return action.Continue();
}

static int OnSuspend(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction interruptingAction)
{
	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] != '\0' && strcmp(value, "-") != 0)
	{
		StopSound(actor.index, SNDCHAN_AUTO, value);
	}
	if (actor.IsStunned)
	{
		return action.Done();
	}
	if (!action.ShouldReplayAnimation && !action.DidEndAnimation)
	{
		return action.Done("Suspended");
	}
	return action.Continue();
}

static int OnResume(SF2_ChaserAttackAction action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	if (!action.PlayedBeginVoice)
	{
		actor.PerformVoice(SF2BossSound_Attack, action.GetAttackName());
		action.PlayedBeginVoice = true;
	}
	if (action.ShouldReplayAnimation)
	{
		actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_Attack], _, action.GetAttackName());
		actor.AddGesture(g_SlenderAnimationsList[SF2BossAnimation_Attack], _, action.GetAttackName());
		action.ShouldReplayAnimation = false;
	}

	if (action.DidEndAnimation)
	{
		return action.Done("Finished");
	}
	return action.Continue();
}

static void OnEnd(SF2_ChaserAttackAction action, SF2_ChaserEntity actor)
{
	actor.IsAttacking = false;
	actor.IsAttemptingToMove = false;
	actor.CancelAttack = false;
	actor.GroundSpeedOverride = false;
	actor.MovementType = action.OldMovementType;

	char value[PLATFORM_MAX_PATH];
	value = action.GetLoopSound();
	if (value[0] != '\0' && strcmp(value, "-") != 0)
	{
		StopSound(actor.index, SNDCHAN_AUTO, value);
	}

	SF2NPC_Chaser controller = actor.Controller;
	if (controller.IsValid())
	{
		float gameTime = GetGameTime();
		SF2ChaserBossProfileData data;
		SF2ChaserBossProfileAttackData attackData;
		data = controller.GetProfileData();
		data.GetAttack(actor.GetAttackName(), attackData);
		int difficulty = controller.Difficulty;

		if (data.NormalSoundHook)
		{
			actor.NextVoiceTime = 0.0;
		}

		actor.SetNextAttackTime(actor.GetAttackName(), gameTime + attackData.Cooldown[difficulty]);

		actor.InvokeOnEndAttack(actor.GetAttackName());
	}

	actor.State = action.OldState;

	actor.SetAttackName("");
	actor.AttackIndex = -1;
}

static void OnOtherKilled(SF2_ChaserMainAction action, SF2_ChaserEntity actor, CBaseCombatCharacter victim, CBaseEntity attacker, CBaseEntity inflictor, float damage, int damagetype)
{
	actor.CheckTauntKill(SF2_BasePlayer(victim.index));
}