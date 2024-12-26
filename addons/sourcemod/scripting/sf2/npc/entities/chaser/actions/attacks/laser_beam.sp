#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfileLaserAttack < ChaserBossProfileBaseAttack
{
	property float LaserSize
	{
		public get()
		{
			float def = 12.0;
			def = this.GetFloat("laser_size", def);
			def = this.GetFloat("attack_laser_size", def);
			return def;
		}
	}

	public void GetLaserColor(int buffer[3])
	{
		buffer[0] = this.GetInt("laser_color_r");
		buffer[0] = this.GetInt("attack_laser_color_r");
		buffer[1] = this.GetInt("laser_color_g");
		buffer[1] = this.GetInt("attack_laser_color_g");
		buffer[2] = this.GetInt("laser_color_b");
		buffer[2] = this.GetInt("attack_laser_color_b");
	}

	public void GetAttachment(char[] buffer, int bufferSize)
	{
		this.GetString("laser_attachment_name", buffer, bufferSize, buffer);
		this.GetString("attack_laser_attachment_name", buffer, bufferSize, buffer);
	}

	public float GetLaserDuration(int difficulty)
	{
		float def = this.GetDuration(difficulty);
		def = this.GetDifficultyFloat("laser_duration", difficulty, def);
		def = this.GetDifficultyFloat("attack_laser_duration", difficulty, def);
		return def;
	}

	property float LaserNoise
	{
		public get()
		{
			float def = 1.0;
			def = this.GetFloat("laser_noise", def);
			def = this.GetFloat("attack_laser_noise", def);
			return def;
		}
	}

	public void GetOffset(float buffer[3])
	{
		this.GetVector("laser_offset", buffer, buffer);
		this.GetVector("attack_laser_offset", buffer, buffer);
	}

	public float GetLaserTickRate(int difficulty)
	{
		float def = 0.1;
		def = this.GetDifficultyFloat("laser_tick_delay", difficulty, def);
		return def;
	}
}

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Laser < NextBotAction
{
	public SF2_ChaserAttackAction_Laser(const char[] attackName, ChaserBossProfileLaserAttack data, float fireDelay, float duration)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackLaser");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_AttackName")
				.DefineIntField("m_ProfileData")
				.DefineFloatField("m_NextFireTime")
				.DefineFloatField("m_LaserDuration")
				.DefineFloatField("m_LaserCooldown")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Laser action = view_as<SF2_ChaserAttackAction_Laser>(g_Factory.Create());

		action.NextFireTime = fireDelay;
		action.LaserDuration = duration;
		action.SetAttackName(attackName);
		action.ProfileData = data;

		return action;
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

	property ChaserBossProfileLaserAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileLaserAttack value)
		{
			this.SetData("m_ProfileData", value);
		}
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

	ChaserBossProfile data = chaser.Controller.GetProfileData();
	ChaserBossProfileLaserAttack attackData = view_as<ChaserBossProfileLaserAttack>(data.GetAttack(attackName));
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type != SF2BossAttackType_LaserBeam)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Laser(attackName, attackData, attackData.GetDelay(difficulty) + GetGameTime(), attackData.GetLaserDuration(difficulty) + GetGameTime() + attackData.GetDelay(difficulty));
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
	ChaserBossProfileLaserAttack attackData = action.ProfileData;
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.GetEventNumber(difficulty) == -1)
	{
		if (action.LaserCooldown < gameTime)
		{
			action.LaserCooldown = gameTime + attackData.GetLaserTickRate(difficulty);
			FireLaser(action, actor, attackData.GetLaserTickRate(difficulty));
		}

		if (action.LaserDuration < gameTime)
		{
			action.NextFireTime = -1.0;
		}
	}

	CBaseEntity target = actor.Target;
	if (target.IsValid())
	{
		float lookAt[3];
		target.GetAbsOrigin(lookAt);
		actor.MyNextBotPointer().GetLocomotionInterface().FaceTowards(lookAt);
	}

	return action.Continue();
}

static void FireLaser(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, float interval)
{
	SF2NPC_Chaser controller = actor.Controller;
	CBaseEntity target = actor.Target;

	int difficulty = controller.Difficulty;

	ChaserBossProfileLaserAttack attackData = action.ProfileData;

	if (!target.IsValid())
	{
		return;
	}

	float targetPos[3];
	target.WorldSpaceCenter(targetPos);

	float basePos[3], baseAng[3], effectAng[3], effectPos[3];
	actor.GetAbsOrigin(basePos);
	actor.GetAbsAngles(baseAng);
	attackData.GetOffset(effectPos);
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
		attackData.GetLaserColor(color);
		int actualColor[4];
		actualColor[0] = color[0];
		actualColor[1] = color[1];
		actualColor[2] = color[2];
		actualColor[3] = 255;

		char attachment[64];
		attackData.GetAttachment(attachment, sizeof(attachment));
		if (attachment[0] != '\0')
		{
			int attachmentIndex = actor.LookupAttachment(attachment);
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

		SDKHooks_TakeDamage(hitTarget, actor.index, actor.index, attackData.GetDamage(difficulty), attackData.GetDamageType(difficulty), _, _, endPos);

		attackData.ApplyDamageEffects(SF2_BasePlayer(hitTarget), difficulty, actor);
	}
	delete trace;
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Laser action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfileLaserAttack attackData = action.ProfileData;

	if (event == attackData.GetEventNumber(controller.Difficulty))
	{
		FireLaser(action, actor, 0.1);
	}
}