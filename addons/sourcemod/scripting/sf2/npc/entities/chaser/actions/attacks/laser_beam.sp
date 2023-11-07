#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Laser < NextBotAction
{
	public SF2_ChaserAttackAction_Laser(int attackIndex, const char[] attackName, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackLaser");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextFireTime")
				.DefineFloatField("m_LaserDuration")
				.DefineFloatField("m_LaserCooldown")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Laser action = view_as<SF2_ChaserAttackAction_Laser>(g_Factory.Create());

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

	property float LaserDuration
	{
		public get()
		{
			return this.GetDataFloat("m_LaserDuration");
		}

		public set(float value)
		{
			this.SetDataFloat("m_LaserDuration", value);
		}
	}

	property float LaserCooldown
	{
		public get()
		{
			return this.GetDataFloat("m_LaserCooldown");
		}

		public set(float value)
		{
			this.SetDataFloat("m_LaserCooldown", value);
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

	if (attackData.Type != SF2BossAttackType_LaserBeam)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Laser(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
	return Plugin_Changed;
}

static int OnStart(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer firing my super laser beam");
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

	float gameTime = GetGameTime();

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.EventNumber == -1)
	{
		if (action.LaserCooldown < gameTime)
		{
			action.LaserCooldown = gameTime + 0.1;
			FireLaser(action, actor, 0.1);
		}

		if (action.LaserDuration < gameTime)
		{
			action.NextFireTime = -1.0;
		}
	}

	return action.Continue();
}

static void FireLaser(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;
	CBaseEntity target = actor.Target;

	int difficulty = controller.Difficulty;

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	if (!target.IsValid())
	{
		return;
	}

	float targetPos[3];
	target.WorldSpaceCenter(targetPos);

	float basePos[3], baseAng[3], effectAng[3], effectPos[3];
	actor.GetAbsOrigin(basePos);
	actor.GetAbsAngles(baseAng);
	effectPos = attackData.LaserOffset;
	VectorTransform(effectPos, basePos, baseAng, effectPos);
	AddVectors(effectAng, baseAng, effectAng);

	float direction[3], angle[3];
	SubtractVectors(targetPos, effectPos, direction);
	NormalizeVector(direction, direction);
	GetVectorAngles(direction, angle);

	float fwd[3];
	GetAngleVectors(angle, fwd, NULL_VECTOR, NULL_VECTOR);

	NormalizeVector(fwd, fwd);

	float end[3];
	end[0] = effectPos[0] + fwd[0] * 9001.0;
	end[1] = effectPos[1] + fwd[1] * 9001.0;
	end[2] = effectPos[2] + fwd[2] * 9001.0;

	Handle trace = TR_TraceRayFilterEx(effectPos, end, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
	RayType_EndPoint, TraceRayDontHitAnyEntity, actor.index);

	if (TR_GetFraction(trace) < 1.0)
	{
		int hitTarget = TR_GetEntityIndex(trace);
		if (hitTarget == -1)
		{
			delete trace;
			return;
		}

		float endPos[3];
		TR_GetEndPosition(endPos, trace);

		int color[3];
		color = attackData.LaserColor;
		int actualColor[4];
		actualColor[0] = color[0];
		actualColor[1] = color[1];
		actualColor[2] = color[2];
		actualColor[3] = 255;

		if (attackData.LaserAttachment)
		{
			int attachmentIndex = actor.LookupAttachment(attackData.LaserAttachmentName);
			float targetEntPos[3], tempAng[3];
			actor.GetAttachment(attachmentIndex, targetEntPos, tempAng);
			TE_SetupBeamPoints(targetEntPos, endPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, interval, attackData.LaserSize, attackData.LaserSize, 5, attackData.LaserNoise, actualColor, 1);
			TE_SendToAll();
		}
		else
		{
			TE_SetupBeamPoints(effectPos, endPos, g_ShockwaveBeam, g_ShockwaveHalo, 0, 30, interval, attackData.LaserSize, attackData.LaserSize, 5, attackData.LaserNoise, actualColor, 1);
			TE_SendToAll();
		}

		SDKHooks_TakeDamage(hitTarget, actor.index, actor.index, attackData.LaserDamage[difficulty], DMG_SHOCK|DMG_ALWAYSGIB, _, _, endPos);

		attackData.ApplyDamageEffects(SF2_BasePlayer(hitTarget), difficulty, SF2_ChaserBossEntity(actor.index));
	}
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, int event)
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
		FireLaser(action, actor, 0.1);
	}
}