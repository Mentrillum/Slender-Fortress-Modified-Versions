#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Tongue < NextBotAction
{
	public SF2_ChaserAttackAction_Tongue(int attackIndex, const char[] attackName, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackTongue");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetCallback(NextBotActionCallbackType_OnEnd, OnEnd);
			g_Factory.SetEventCallback(EventResponderType_OnCommandString, OnCommandString);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextFireTime")
				.DefineEntityField("m_TongueEntity")
				.DefineEntityField("m_TongueEntityEnd")
				.DefineEntityField("m_TongueEntityTrail")
				.DefineBoolField("m_CaughtTarget")
				.DefineEntityField("m_LatchedTarget")
				.DefineFloatField("m_TongueTimer")
				.DefineBoolField("m_InPullAnimation")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Tongue action = view_as<SF2_ChaserAttackAction_Tongue>(g_Factory.Create());

		action.NextFireTime = fireDelay;
		action.AttackIndex = attackIndex;
		action.SetAttackName(attackName);

		return action;
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

	public static void Initialize()
	{
		g_OnPlayerJumpPFwd.AddFunction(null, OnJump);
		g_OnChaserGetAttackActionPFwd.AddFunction(null, OnChaserGetAttackAction);
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

	property float NextFireTime
	{
		public get()
		{
			return this.GetDataFloat("m_NextFireTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_NextFireTime", value);
		}
	}

	property int TongueEntity
	{
		public get()
		{
			return this.GetDataEnt("m_TongueEntity");
		}

		public set(int value)
		{
			this.SetDataEnt("m_TongueEntity", value);
		}
	}

	property int TongueEntityEnd
	{
		public get()
		{
			return this.GetDataEnt("m_TongueEntityEnd");
		}

		public set(int value)
		{
			this.SetDataEnt("m_TongueEntityEnd", value);
		}
	}

	property int TongueEntityTrail
	{
		public get()
		{
			return this.GetDataEnt("m_TongueEntityTrail");
		}

		public set(int value)
		{
			this.SetDataEnt("m_TongueEntityTrail", value);
		}
	}

	property bool CaughtTarget
	{
		public get()
		{
			return this.GetData("m_CaughtTarget") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_CaughtTarget", value);
		}
	}

	property SF2_BasePlayer LatchedTarget
	{
		public get()
		{
			return SF2_BasePlayer(this.GetDataEnt("m_LatchedTarget"));
		}

		public set(SF2_BasePlayer value)
		{
			this.SetDataEnt("m_LatchedTarget", value.index);
		}
	}

	property float TongueTime
	{
		public get()
		{
			return this.GetDataFloat("m_TongueTimer");
		}

		public set(float value)
		{
			this.SetDataFloat("m_TongueTimer", value);
		}
	}

	property bool InPullAnimation
	{
		public get()
		{
			return this.GetData("m_InPullAnimation") != 0;
		}

		public set(bool value)
		{
			this.SetData("m_InPullAnimation", value);
		}
	}
}

static Action OnChaserGetAttackAction(SF2_ChaserEntity chaser, const char[] attackName, NextBotAction &result)
{
	if (result != NULL_ACTION)
	{
		return Plugin_Continue;
	}

	SF2ChaserBossProfileData data;
	data = chaser.Controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(attackName, attackData);
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type != SF2BossAttackType_Tongue)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Tongue(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
	return Plugin_Changed;
}

static void OnJump(SF2_BasePlayer client)
{
	if (client.IsEliminated || IsRoundEnding() || IsRoundInWarmup() || client.HasEscaped)
	{
		return;
	}

	if (client.IsLatched)
	{
		client.LatchCount--;
		if (client.LatchCount <= 0)
		{
			client.IsLatched = false;
			client.LatchCount = 0;
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(i);
				if (!npc.IsValid())
				{
					continue;
				}

				if (client.Latcher != npc.Index)
				{
					continue;
				}

				SF2_ChaserEntity chaser = SF2_ChaserEntity(npc.EntIndex);
				if (!chaser.IsValid())
				{
					continue;
				}

				chaser.MyNextBotPointer().GetIntentionInterface().OnCommandString("break tongue");
			}
		}
	}
}

static int OnStart(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION || action.IsSuspended)
	{
		return action.Done("No longer firing a tongue");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	if (action.CaughtTarget)
	{
		SF2_ChaserAttackAction parent = view_as<SF2_ChaserAttackAction>(action.Parent);
		parent.EndTime += GetGameFrameTime();
		if (!action.LatchedTarget.IsValid)
		{
			return action.Done("Nobody is in my tongue");
		}
	}

	SF2NPC_Chaser controller = actor.Controller;
	bool attackEliminated = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();
	if (originalData.IsPvEBoss)
	{
		attackEliminated = true;
	}
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.EventNumber == -1)
	{
		FireTongue(actor, action);

		action.NextFireTime = -1.0;
	}

	if (action.NextFireTime <= -1.0 && (!IsValidEntity(action.TongueEntity) || !IsValidEntity(action.TongueEntityEnd)))
	{
		return action.Done("Tongue down");
	}

	if (IsValidEntity(action.TongueEntity) && IsValidEntity(action.TongueEntityEnd) && IsValidEntity(action.TongueEntityTrail) && !action.CaughtTarget)
	{
		CBaseEntity tongueEnd = CBaseEntity(action.TongueEntityEnd);
		float tonguePos[3];
		tongueEnd.GetAbsOrigin(tonguePos);
		ArrayList players = new ArrayList();
		TR_EnumerateEntitiesSphere(tonguePos, 75.0, PARTITION_SOLID_EDICTS, EnumerateLivingPlayers, players);

		for (int i = 0; i < players.Length; i++)
		{
			SF2_BasePlayer player = players.Get(i);

			if (!attackEliminated && player.IsEliminated)
			{
				continue;
			}

			float worldSpace[3];
			player.WorldSpaceCenter(worldSpace);
			TR_TraceRayFilter(tonguePos, worldSpace,
			CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
			RayType_EndPoint, TraceRayDontHitAnyEntity, tongueEnd.index);

			if (TR_DidHit() && TR_GetEntityIndex() != player.index)
			{
				continue;
			}

			if (!attackData.TongueCanEscape[difficulty])
			{
				player.Stun(1.0, 1.0, TF_STUNFLAG_NOSOUNDOREFFECT | TF_STUNFLAG_BONKSTUCK);
			}
			else
			{
				player.Stun(2.0, 1.0, TF_STUNFLAG_SLOWDOWN);
			}
			player.TakeDamage(_, actor.index, actor.index, attackData.Damage[difficulty], DMG_BULLET | DMG_PREVENT_PHYSICS_FORCE);

			tongueEnd.AcceptInput("ClearParent");
			tongueEnd.Teleport(worldSpace, NULL_VECTOR, NULL_VECTOR);
			SetVariantString("!activator");
			tongueEnd.AcceptInput("SetParent", player.index);
			RemoveEntity(action.TongueEntityTrail);
			action.TongueTime = 0.5 + gameTime;
			action.LatchedTarget = player;
			action.CaughtTarget = true;
			attackData.TongueTiedSound.EmitSound(_, tongueEnd.index);
			attackData.TongueHitSound.EmitSound(_, tongueEnd.index);
			player.IsLatched = true;
			player.LatchCount = GetRandomInt(6, 10);
			if (!attackData.TongueCanEscape[difficulty])
			{
				player.LatchCount = 999999; // I'm lazy
			}
			player.Latcher = controller.Index;
			if (!player.HasHint(PlayerHint_Trap))
			{
				player.ShowHint(PlayerHint_Trap);
			}
			actor.MyNextBotPointer().GetIntentionInterface().OnCommandString("latch tongue");
			break;
		}

		delete players;
	}

	TongueThink(action, actor);

	return action.Continue();
}

static void TongueThink(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor)
{
	if (!IsValidEntity(action.TongueEntity) && !IsValidEntity(action.TongueEntityEnd))
	{
		return;
	}

	if (!action.CaughtTarget)
	{
		return;
	}

	float gameTime = GetGameTime();
	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	SF2_BasePlayer player = action.LatchedTarget;
	if (!player.IsValid || !player.IsAlive)
	{
		Unlatch(action);
		return;
	}

	CBaseEntity tongueStart = CBaseEntity(action.TongueEntity);
	float tonguePos[3], worldSpace[3];
	tongueStart.GetAbsOrigin(tonguePos);
	player.WorldSpaceCenter(worldSpace);

	TR_TraceRayFilter(tonguePos, worldSpace,
	CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
	RayType_EndPoint, TraceRayDontHitAnyEntity, tongueStart.index);

	if (TR_DidHit() && TR_GetEntityIndex() != player.index)
	{
		Unlatch(action, true);
		return;
	}

	INextBot bot = actor.MyNextBotPointer();
	ILocomotion loco = bot.GetLocomotionInterface();
	float myPos[3], targetPos[3];
	actor.GetAbsOrigin(myPos);
	player.GetAbsOrigin(targetPos);

	if (action.TongueTime > -1.0 && action.TongueTime <= gameTime)
	{
		SF2_BasePlayer latched = action.LatchedTarget;
		if (!attackData.TongueCanEscape[difficulty])
		{
			latched.Stun(1.0, 1.0, TF_STUNFLAG_BONKSTUCK|TF_STUNFLAG_NOSOUNDOREFFECT);
		}
		else
		{
			latched.Stun(2.0, 1.0, TF_STUNFLAG_SLOWDOWN);
		}
		action.TongueTime = gameTime + 0.5;

		float velocity[3];
		SubtractVectors(myPos, targetPos, velocity);
		velocity[2] = 0.0;

		ScaleVector(velocity, attackData.TonguePullScale[difficulty]);
		player.SetPropVector(Prop_Data, "m_vecBaseVelocity", velocity);

		player.TakeDamage(_, actor.index, actor.index, attackData.Damage[difficulty], DMG_BULLET | DMG_PREVENT_PHYSICS_FORCE);
	}

	loco.FaceTowards(targetPos);
}

static void Unlatch(SF2_ChaserAttackAction_Tongue action, bool removeSlow = false)
{
	if (IsValidEntity(action.TongueEntity))
	{
		RemoveEntity(action.TongueEntity);
	}

	if (IsValidEntity(action.TongueEntityEnd))
	{
		RemoveEntity(action.TongueEntityEnd);
	}

	if (action.LatchedTarget.IsValid)
	{
		action.LatchedTarget.IsLatched = false;
		action.LatchedTarget.LatchCount = 0;
		if (removeSlow)
		{
			action.LatchedTarget.ChangeCondition(TFCond_Dazed, true);
		}
	}

	action.LatchedTarget = SF2_BasePlayer(-1);
}

static void OnEnd(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor)
{
	Unlatch(action);
}

static void FireTongue(SF2_ChaserEntity actor, SF2_ChaserAttackAction_Tongue action)
{
	CBaseEntity target = actor.Target;
	if (!target.IsValid())
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	float effectPos[3], myPos[3], myAng[3];
	actor.GetAbsOrigin(myPos);
	actor.GetAbsAngles(myAng);
	int difficulty = controller.Difficulty;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	effectPos = attackData.TongueOffset;
	VectorTransform(effectPos, myPos, myAng, effectPos);

	CBaseEntity tongue = CBaseEntity(CreateEntityByName("move_rope"));

	/*if (attackData.TongueAttachment[0] == '\0')
	{
		tongue.Teleport(effectPos, myAng, NULL_VECTOR);
		SetVariantString("!activator");
		tongue.AcceptInput("SetParent", actor.index);
	}*/

	tongue.Teleport(effectPos, myAng, NULL_VECTOR);
	SetVariantString("!activator");
	tongue.AcceptInput("SetParent", actor.index);

	char buffer[PLATFORM_MAX_PATH];
	tongue.KeyValue("Slack", "50");
	tongue.KeyValue("RopeMaterial", attackData.TongueMaterial);
	FormatEx(buffer, sizeof(buffer), "rope_%i", controller.Index);
	tongue.KeyValue("NextKey", buffer);

	CBaseEntity tongueEnd = CBaseEntity(CreateEntityByName("move_rope"));
	tongueEnd.KeyValue("targetname", buffer);
	tongueEnd.KeyValue("Slack", "50");
	tongueEnd.KeyValue("RopeMaterial", attackData.TongueMaterial);
	tongueEnd.Teleport(effectPos, myAng, NULL_VECTOR);
	tongueEnd.SetMoveType(MOVETYPE_FLY);

	tongue.Spawn();
	tongueEnd.Spawn();
	tongue.Activate();
	tongueEnd.Activate();

	action.TongueEntity = tongue.index;
	action.TongueEntityEnd = tongueEnd.index;

	float velocity[3], shootAng[3], targetPos[3];
	target.WorldSpaceCenter(targetPos);
	SubtractVectors(targetPos, effectPos, shootAng);
	NormalizeVector(shootAng, shootAng);
	GetVectorAngles(shootAng, shootAng);
	GetAngleVectors(shootAng, velocity, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(velocity, attackData.TongueSpeed[difficulty]);

	attackData.TongueLaunchSound.EmitSound(_, actor.index);

	CBaseEntity trail = CBaseEntity(CreateEntityByName("tf_projectile_grapplinghook"));
	trail.SetModel("models/roller.mdl");
	trail.KeyValue("solid", "0");
	trail.Spawn();
	trail.Activate();
	trail.SetProp(Prop_Send, "m_usSolidFlags", 22);
	SetEntityCollisionGroup(trail.index, 1);
	trail.Teleport(effectPos, shootAng, velocity);
	SetVariantString("!activator");
	tongueEnd.AcceptInput("SetParent", trail.index);
	SetEntityOwner(trail.index, tongueEnd.index);
	trail.SetRenderMode(RENDER_TRANSCOLOR);
	trail.SetRenderColor(0, 0, 0, 0);
	CreateTimer(0.1, Timer_Think, EntIndexToEntRef(trail.index), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	action.TongueEntityTrail = trail.index;
	SetEntDataFloat(trail.index, GetEntSendPropOffs(trail.index, "m_iProjectileType") + 32, GetGameTime() + 9999.9);

	SetEntityOwner(trail.index, tongue.index);
}

static Action Timer_Think(Handle timer, any ref)
{
	int entity = EntRefToEntIndex(ref);
	if (!entity || entity == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	CBaseEntity trail = CBaseEntity(entity);
	int owner = trail.GetPropEnt(Prop_Send, "m_hOwnerEntity");
	if (!IsValidEntity(owner))
	{
		RemoveEntity(trail.index);
		return Plugin_Stop;
	}
	float pos[3], mins[3] = {-8.0, ... }, maxs[3] = {8.0, ... };
	trail.GetAbsOrigin(pos);
	TR_TraceHullFilter(pos, pos, mins, maxs, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP, TraceRayGrenade, trail.index);

	if (TR_GetEntityIndex() == 0)
	{
		if (IsValidEntity(owner))
		{
			RemoveEntity(owner);
		}
		RemoveEntity(trail.index);
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

static int OnCommandString(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor, const char[] command)
{
	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	char animName[64];
	float rate = 1.0, duration = 0.0, cycle = 0.0;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	if (strcmp(command, "break tongue") == 0)
	{
		Unlatch(action, true);
		if (attackData.Animations.GetAnimation("break", difficulty, animName, sizeof(animName), rate, duration, cycle))
		{
			int sequence = LookupProfileAnimation(actor.index, animName);
			if (sequence != -1)
			{
				return action.TrySuspendFor(SF2_PlaySequenceAndWait(sequence, duration, rate, cycle), RESULT_CRITICAL);
			}
		}
	}

	if (strcmp(command, "latch tongue") == 0 && !action.InPullAnimation)
	{
		if (attackData.Animations.GetAnimation("pull", difficulty, animName, sizeof(animName), rate, duration, cycle))
		{
			int sequence = LookupProfileAnimation(actor.index, animName);
			if (sequence != -1)
			{
				actor.ResetSequence(sequence);
				actor.SetPropFloat(Prop_Send, "m_flCycle", cycle);
				actor.SetPropFloat(Prop_Send, "m_flPlaybackRate", rate);
			}
		}
		action.InPullAnimation = true;
	}

	return action.TryContinue();
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Tongue action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	if (event == attackData.EventNumber)
	{
		FireTongue(actor, action);
	}
}