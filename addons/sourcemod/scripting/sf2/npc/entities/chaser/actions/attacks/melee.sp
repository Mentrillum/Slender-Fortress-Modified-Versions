#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Melee < NextBotAction
{
	public SF2_ChaserAttackAction_Melee(int attackIndex, const char[] attackName, float damageDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackMelee");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextDamageTime")
				.DefineIntField("m_RepeatIndex")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Melee action = view_as<SF2_ChaserAttackAction_Melee>(g_Factory.Create());

		action.NextDamageTime = damageDelay;
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

	property float NextDamageTime
	{
		public get()
		{
			return this.GetDataFloat("m_NextDamageTime");
		}

		public set(float value)
		{
			this.SetDataFloat("m_NextDamageTime", value);
		}
	}

	property int RepeatIndex
	{
		public get()
		{
			return this.GetData("m_RepeatIndex");
		}

		public set(int value)
		{
			this.SetData("m_RepeatIndex", value);
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

	if (attackData.Type != SF2BossAttackType_Melee)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Melee(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
	return Plugin_Changed;
}

static int OnStart(SF2_ChaserAttackAction_Melee action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Melee action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer melee attacking");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	SF2NPC_Chaser controller = actor.Controller;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();
	if (action.NextDamageTime >= 0.0 && gameTime > action.NextDamageTime && attackData.EventNumber == -1)
	{
		DoMeleeAttack(action, actor);

		int repeatState = attackData.Repeat;
		if (repeatState > 0)
		{
			switch (repeatState)
			{
				case 1:
				{
					action.NextDamageTime = gameTime + attackData.DamageDelay[difficulty];
				}
				case 2:
				{
					if (action.RepeatIndex >= attackData.RepeatTimers.Length)
					{
						action.NextDamageTime = -1.0;
					}
					else
					{
						float next = attackData.RepeatTimers.Get(action.RepeatIndex);
						action.NextDamageTime = next + gameTime;
						action.RepeatIndex++;
					}
				}
			}
		}
		else
		{
			action.NextDamageTime = -1.0;
		}
	}
	return action.Continue();
}

static void DoMeleeAttack(SF2_ChaserAttackAction_Melee action, SF2_ChaserEntity actor)
{
	SF2NPC_Chaser controller = actor.Controller;

	int difficulty = controller.Difficulty;

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
	float damage = attackData.Damage[difficulty];
	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		damage *= 0.5;
	}
	int damageType = attackData.DamageType[difficulty];

	float myPos[3], myEyePos[3], myEyeAng[3];
	actor.GetAbsOrigin(myPos);
	controller.GetEyePosition(myEyePos);
	actor.GetAbsAngles(myEyeAng);

	AddVectors(g_SlenderEyePosOffset[controller.Index], myEyeAng, myEyeAng);

	float viewPunch[3];
	viewPunch = attackData.PunchVelocity;

	float range = attackData.Range[difficulty];
	float spread = attackData.Spread[difficulty];
	float force = attackData.DamageForce[difficulty];

	bool hit = false;

	ArrayList targets = new ArrayList();

	// Sweep the props
	for (int i = 0; i < g_Buildings.Length; i++)
	{
		CBaseEntity building = CBaseEntity(EntRefToEntIndex(g_Buildings.Get(i)));
		if (!building.IsValid())
		{
			continue;
		}

		if (!originalData.IsPvEBoss && !IsTargetValidForSlender(actor, building, attackEliminated))
		{
			continue;
		}

		if (originalData.IsPvEBoss && !IsPvETargetValid(building))
		{
			continue;
		}

		if (!IsTargetInMeleeChecks(actor, attackData, building, range, spread))
		{
			continue;
		}

		targets.Push(g_Buildings.Get(i));
	}

	for (int i = 0; i < g_WhitelistedEntities.Length; i++)
	{
		CBaseEntity building = CBaseEntity(EntRefToEntIndex(g_WhitelistedEntities.Get(i)));
		if (!building.IsValid())
		{
			continue;
		}

		if (!originalData.IsPvEBoss && !IsTargetValidForSlender(actor, building, attackEliminated))
		{
			continue;
		}

		if (originalData.IsPvEBoss && !IsPvETargetValid(building))
		{
			continue;
		}

		if (!IsTargetInMeleeChecks(actor, attackData, building, range, spread))
		{
			continue;
		}

		targets.Push(g_WhitelistedEntities.Get(i));
	}

	for (int i = 0; i < g_BreakableProps.Length; i++)
	{
		CBaseEntity building = CBaseEntity(EntRefToEntIndex(g_BreakableProps.Get(i)));
		if (!building.IsValid())
		{
			continue;
		}

		if (!originalData.IsPvEBoss && !IsTargetValidForSlender(actor, building, attackEliminated))
		{
			continue;
		}

		if (originalData.IsPvEBoss && !IsPvETargetValid(building))
		{
			continue;
		}

		if (!IsTargetInMeleeChecks(actor, attackData, building, range, spread))
		{
			continue;
		}

		targets.Push(g_BreakableProps.Get(i));
	}

	for (int i = 0; i < targets.Length; i++)
	{
		CBaseEntity prop = CBaseEntity(EntRefToEntIndex(targets.Get(i)));
		if (!prop.IsValid())
		{
			continue;
		}

		hit = true;

		char class[64];
		prop.GetClassname(class, sizeof(class));

		float realDamage = damage;
		if (attackData.DamagePercent[difficulty] > 0.0)
		{
			realDamage = strcmp(class, "tank_boss", false) != 0 ? float(prop.GetProp(Prop_Send, "m_iMaxHealth")) : float(prop.GetProp(Prop_Data, "m_iMaxHealth"));
			realDamage *= attackData.DamagePercent[difficulty];
		}
		SDKHooks_TakeDamage(prop.index, actor.index, actor.index, realDamage, 64, _, _, myEyePos, false);
	}
	delete targets;

	// Sweep the players
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);

		if (!originalData.IsPvEBoss && !IsTargetValidForSlender(actor, player, attackEliminated))
		{
			continue;
		}

		if (originalData.IsPvEBoss && !IsPvETargetValid(player))
		{
			continue;
		}

		if (!IsTargetInMeleeChecks(actor, attackData, player, range, spread))
		{
			continue;
		}

		hit = true;

		float direction[3], targetPos[3];
		player.WorldSpaceCenter(targetPos);
		SubtractVectors(targetPos, myEyePos, direction);
		GetVectorAngles(direction, direction);
		GetAngleVectors(direction, direction, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(direction, direction);
		ScaleVector(direction, force);

		float realDamage = damage;
		if (attackData.DamagePercent[difficulty] > 0.0)
		{
			realDamage = float(player.GetProp(Prop_Data, "m_iMaxHealth")) * attackData.DamagePercent[difficulty];
		}

		if (controller.HasAttribute(SF2Attribute_DeathCamOnLowHealth) || attackData.DeathCamLowHealth)
		{
			float checkDamage = realDamage;

			if ((damageType & DMG_ACID) && !player.InCondition(TFCond_DefenseBuffed))
			{
				checkDamage *= 3.0;
			}
			else if (((damageType & DMG_POISON) || player.InCondition(TFCond_Jarated) || player.InCondition(TFCond_MarkedForDeath) || player.InCondition(TFCond_MarkedForDeathSilent)) && !player.InCondition(TFCond_DefenseBuffed))
			{
				checkDamage *= 1.35;
			}
			else if (player.InCondition(TFCond_DefenseBuffed))
			{
				checkDamage *= 0.65;
			}

			if (checkDamage > player.Health)
			{
				player.StartDeathCam(controller.Index, myPos);
			}
		}

		player.TakeDamage(_, actor.index, actor.index, realDamage, damageType, _, direction, myEyePos, false);
		player.ViewPunch(viewPunch);

		if (player.InCondition(TFCond_UberchargedCanteen) && player.InCondition(TFCond_CritOnFirstBlood) && player.InCondition(TFCond_UberBulletResist) && player.InCondition(TFCond_UberBlastResist) && player.InCondition(TFCond_UberFireResist) && player.InCondition(TFCond_MegaHeal)) //Remove Powerplay
		{
			player.ChangeCondition(TFCond_UberchargedCanteen, true);
			player.ChangeCondition(TFCond_CritOnFirstBlood, true);
			player.ChangeCondition(TFCond_UberBulletResist, true);
			player.ChangeCondition(TFCond_UberBlastResist, true);
			player.ChangeCondition(TFCond_UberFireResist, true);
			player.ChangeCondition(TFCond_MegaHeal, true);
			TF2_SetPlayerPowerPlay(player.index, false);
		}

		attackData.ApplyDamageEffects(player, difficulty, SF2_ChaserBossEntity(actor.index));

		// Add stress
		float stressScalar = damage / 125.0;
		if (stressScalar > 1.0)
		{
			stressScalar = 1.0;
		}
		ClientAddStress(player.index, 0.33 * stressScalar);
	}

	ArrayList hitSounds = hit ? data.HitSounds : data.MissSounds;
	SF2BossProfileSoundInfo info;
	if (actor.SearchSoundsWithSectionName(hitSounds, action.GetAttackName(), info))
	{
		info.EmitSound(_, actor.index);
	}

	actor.DoShockwave(action.GetAttackName());

	if (hit)
	{
		CBaseEntity phys = CBaseEntity(CreateEntityByName("env_physexplosion"));
		if (phys.IsValid())
		{
			float worldSpace[3];
			actor.WorldSpaceCenter(worldSpace);
			phys.Teleport(worldSpace, NULL_VECTOR, NULL_VECTOR);
			phys.KeyValue("spawnflags", "1");
			phys.KeyValueFloat("radius", range);
			phys.KeyValueFloat("magnitude", force);
			phys.Spawn();
			phys.Activate();
			phys.AcceptInput("Explode");
			RemoveEntity(phys.index);
		}
	}
	else
	{
		if (attackData.MissEffects != null)
		{
			SlenderSpawnEffects(attackData.MissEffects, controller.Index, false);
		}
	}

	if (!SF_IsSlaughterRunMap())
	{
		if (attackData.Disappear[difficulty])
		{
			controller.UnSpawn(true);
		}
		else
		{
			if (hit && attackData.DisappearOnHit[difficulty])
			{
				controller.UnSpawn(true);
			}
		}
	}
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Melee action, SF2_ChaserEntity actor, int event)
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
		DoMeleeAttack(action, actor);
	}
}

static bool IsTargetInMeleeChecks(SF2_ChaserEntity actor, SF2ChaserBossProfileAttackData data, CBaseEntity target, float range, float fov)
{
	if (!target.IsValid())
	{
		return false;
	}

	float myPos[3], myEyePos[3], myEyeAng[3];
	actor.GetAbsOrigin(myPos);
	actor.Controller.GetEyePosition(myEyePos);
	actor.GetAbsAngles(myEyeAng);

	AddVectors(g_SlenderEyePosOffset[actor.Controller.Index], myEyeAng, myEyeAng);

	float targetPos[3];
	target.WorldSpaceCenter(targetPos);

	float distance = actor.MyNextBotPointer().GetRangeSquaredTo(target.index);
	if (distance > Pow(range, 2.0))
	{
		return false;
	}

	float direction[3];
	SubtractVectors(targetPos, myEyePos, direction);
	GetVectorAngles(direction, direction);
	float difference = FloatAbs(AngleDiff(direction[1], myEyeAng[1]));
	if (difference > fov)
	{
		return false;
	}

	if (!data.HitThroughWalls[actor.Controller.Difficulty])
	{
		TR_TraceRayFilter(myEyePos, targetPos,
		CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
		RayType_EndPoint, TraceRayDontHitAnyEntity, actor.index);

		if (TR_DidHit() && TR_GetEntityIndex() != target.index)
		{
			return false;
		}
	}

	return true;
}