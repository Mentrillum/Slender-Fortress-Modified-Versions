#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfileBulletAttack < ChaserBossProfileBaseAttack
{
	public int GetBulletCount(int difficulty)
	{
		int def = 4;
		def = this.GetDifficultyInt("attack_bullet_count", difficulty, def);
		def = this.GetDifficultyInt("bullet_count", difficulty, def);
		return def;
	}

	public float GetBulletSpread(int difficulty)
	{
		float def = 0.1;
		def = this.GetDifficultyFloat("bullet_spread", difficulty, def);
		def = this.GetDifficultyFloat("attack_bullet_spread", difficulty, def);
		return def;
	}

	public void GetBulletTrace(char[] buffer, int bufferSize)
	{
		FormatEx(buffer, bufferSize, "bullet_tracer02_blue");
		this.GetString("bullet_tracer", buffer, bufferSize, buffer);
		this.GetString("attack_bullet_tracer", buffer, bufferSize, buffer);
	}

	public void GetBulletOffset(float buffer[3])
	{
		this.GetVector("bullet_offset", buffer, buffer);
		this.GetVector("attack_bullet_offset", buffer, buffer);
	}
}

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Bullet < NextBotAction
{
	public SF2_ChaserAttackAction_Bullet(const char[] attackName, ChaserBossProfileBulletAttack data, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackBullet");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineStringField("m_AttackName")
				.DefineIntField("m_ProfileData")
				.DefineFloatField("m_NextFireTime")
				.DefineIntField("m_RepeatIndex")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Bullet action = view_as<SF2_ChaserAttackAction_Bullet>(g_Factory.Create());

		action.NextFireTime = fireDelay;
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

	property ChaserBossProfileBulletAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileBulletAttack value)
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

	ChaserBossProfile data = chaser.Controller.GetProfileDataEx();
	ChaserBossProfileBulletAttack attackData = view_as<ChaserBossProfileBulletAttack>(data.GetAttack(attackName));
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type != SF2BossAttackType_Ranged)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Bullet(attackName, attackData, attackData.GetDelay(difficulty) + GetGameTime());
	return Plugin_Changed;
}

static int OnStart(SF2_ChaserAttackAction_Bullet action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Bullet action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer firing bullets");
	}

	if (actor.CancelAttack)
	{
		return action.Done();
	}

	SF2NPC_Chaser controller = actor.Controller;
	ChaserBossProfileBulletAttack attackData = action.ProfileData;
	float gameTime = GetGameTime();
	int difficulty = controller.Difficulty;

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.GetEventNumber(difficulty) == -1)
	{
		DoBulletAttack(action, actor, action.GetAttackName());

		int repeatState = attackData.GetRepeatState(difficulty);
		if (repeatState > 0)
		{
			switch (repeatState)
			{
				case 1:
				{
					action.NextFireTime = gameTime + attackData.GetDelay(difficulty);
				}
				case 2:
				{
					if (attackData.GetRepeatTimer(difficulty, action.RepeatIndex) < 0.0)
					{
						action.NextFireTime = -1.0;
					}
					else
					{
						action.NextFireTime = attackData.GetRepeatTimer(difficulty, action.RepeatIndex) + gameTime;
						action.RepeatIndex++;
					}
				}
			}
		}
		else
		{
			action.NextFireTime = -1.0;
		}
	}
	return action.Continue();
}

static void DoBulletAttack(SF2_ChaserAttackAction_Bullet action, SF2_ChaserEntity actor, const char[] attackName)
{
	SF2NPC_Chaser controller = actor.Controller;
	CBaseEntity target = actor.Target;

	int difficulty = controller.Difficulty;

	ChaserBossProfile data = controller.GetProfileDataEx();
	ChaserBossProfileBulletAttack attackData = action.ProfileData;

	float spread = attackData.GetBulletSpread(difficulty);
	ProfileSound soundInfo;
	if (actor.SearchSoundsWithSectionName(data.GetBulletShootSounds(), attackName, soundInfo, "bulletshoot"))
	{
		soundInfo.EmitSound(_, actor.index);
	}

	float effectPos[3], targetPos[3], basePos[3], baseAng[3];
	float effectAng[3] = {0.0, 0.0, 0.0};
	actor.GetAbsOrigin(basePos);
	actor.GetAbsAngles(baseAng);
	if (target.IsValid())
	{
		target.WorldSpaceCenter(targetPos);
	}
	else
	{
		float fwd[3], eyePos[3];
		GetAngleVectors(baseAng, fwd, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(fwd, fwd);
		controller.GetEyePosition(eyePos);
		targetPos[0] = eyePos[0] + fwd[0] * 9001.0;
		targetPos[1] = eyePos[1] + fwd[1] * 9001.0;
		targetPos[2] = eyePos[2] + fwd[2] * 9001.0;
	}
	attackData.GetBulletOffset(effectPos);
	VectorTransform(effectPos, basePos, baseAng, effectPos);
	AddVectors(effectAng, baseAng, effectAng);

	float direction[3], angle[3];
	if (!target.IsValid())
	{
		angle = baseAng;
	}
	SubtractVectors(targetPos, effectPos, direction);
	NormalizeVector(direction, direction);
	GetVectorAngles(direction, angle);

	float fwd[3], right[3], up[3];
	GetAngleVectors(angle, fwd, right, up);

	float dir[3], end[3];
	float x, y;

	ArrayList hitTargets = null;
	for (int i = 0; i < attackData.GetBulletCount(difficulty); i++)
	{
		x = GetRandomFloat(-0.5, 0.5) + GetRandomFloat(-0.5, 0.5);
		y = GetRandomFloat(-0.5, 0.5) + GetRandomFloat(-0.5, 0.5);

		dir[0] = fwd[0] + x * spread * right[0] + y * spread * up[0];
		dir[1] = fwd[1] + x * spread * right[1] + y * spread * up[1];
		dir[2] = fwd[2] + x * spread * right[2] + y * spread * up[2];
		NormalizeVector(dir, dir);

		end[0] = effectPos[0] + dir[0] * 9001.0;
		end[1] = effectPos[1] + dir[1] * 9001.0;
		end[2] = effectPos[2] + dir[2] * 9001.0;

		Handle trace = TR_TraceRayFilterEx(effectPos, end, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP | CONTENTS_GRATE | CONTENTS_WINDOW,
		RayType_EndPoint, TraceRayDontHitAnyEntity, actor.index);
		if (TR_GetFraction(trace) < 1.0)
		{
			int hitTarget = TR_GetEntityIndex(trace);
			if (hitTarget == -1)
			{
				delete trace;
				continue;
			}

			float endPos[3];
			TR_GetEndPosition(endPos, trace);

			TE_SetupEffectDispatch(GetEffectDispatchStringTableIndex("Impact"),
					.origin = endPos,
					.start = effectPos,
					.damageType = attackData.GetDamageType(difficulty),
					.surfaceProp = TR_GetSurfaceProps(trace),
					.hitbox = TR_GetHitGroup(trace),
					.entindex = TR_GetEntityIndex(trace));
			TE_SendToAll();
			delete trace;

			if (hitTargets == null)
			{
				hitTargets = new ArrayList(2);
			}
			int hitIndex = hitTargets.FindValue(hitTarget);
			if (hitIndex == -1)
			{
				hitIndex = hitTargets.Push(hitTarget);
				hitTargets.Set(hitIndex, 0, 1);
			}
			hitTargets.Set(hitIndex, hitTargets.Get(hitIndex, 1) + 1, 1);

			char traceParticle[64];
			attackData.GetBulletTrace(traceParticle, sizeof(traceParticle));
			if (traceParticle[0] == '\0')
			{
				continue;
			}

			int table = FindStringTable("ParticleEffectNames");
			char tmp[256];
			int count = GetStringTableNumStrings(table);
			int index = INVALID_STRING_INDEX;
			for (int i2 = 0; i2 < count; i2++)
			{
				ReadStringTable(table, i2, tmp, sizeof(tmp));
				if (strcmp(tmp, traceParticle, false) == 0)
				{
					index = i2;
					break;
				}
			}

			if (index == INVALID_STRING_INDEX)
			{
				LogError("Could not find particle: %s", traceParticle);
				continue;
			}
			TE_Particle(index, effectPos, effectPos, dir, actor.index, view_as<int>(PATTACH_CUSTOMORIGIN), _, _, true, view_as<int>(PATTACH_CUSTOMORIGIN), endPos);
			TE_SendToAll();
		}
		delete trace;
	}

	if (hitTargets != null)
	{
		for (int i = 0; i < hitTargets.Length; i++)
		{
			int hitTarget = hitTargets.Get(i);
			float damage = attackData.GetDamage(difficulty) * float(hitTargets.Get(i, 1));
			CBaseEntity(hitTargets.Get(i)).GetAbsOrigin(targetPos);
			damage = GetDamageDistance(basePos, targetPos, damage,
							attackData.GetDamageRampUpRange(difficulty), attackData.GetDamageFallOffRange(difficulty),
							attackData.GetDamageRampUp(difficulty), attackData.GetDamageFallOff(difficulty));

			SDKHooks_TakeDamage(hitTarget, actor.index, actor.index, damage, attackData.GetDamageType(difficulty), _, CalculateBulletDamageForce(dir, 1.0), basePos);
			if (SF2_BasePlayer(hitTarget).IsValid)
			{
				attackData.ApplyDamageEffects(SF2_BasePlayer(hitTarget), difficulty, actor);
			}
		}
		delete hitTargets;
	}
}

static float[] CalculateBulletDamageForce(const float bulletDir[3], float scale)
{
	float force[3];
	force = bulletDir;
	NormalizeVector(force, force);
	ScaleVector(force, g_PhysicsPushScaleConVar.FloatValue);
	ScaleVector(force, scale);
	return force;
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Bullet action, SF2_ChaserEntity actor, int event)
{
	if (event == 0)
	{
		return;
	}

	SF2NPC_Chaser controller = actor.Controller;
	int difficulty = controller.Difficulty;
	ChaserBossProfileBulletAttack attackData = action.ProfileData;

	if (event == attackData.GetEventNumber(difficulty))
	{
		DoBulletAttack(action, actor, action.GetAttackName());
	}
}