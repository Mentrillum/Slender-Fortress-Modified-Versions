#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Bullet < NextBotAction
{
	public SF2_ChaserAttackAction_Bullet(int attackIndex, const char[] attackName, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackBullet");
			g_Factory.SetCallback(NextBotActionCallbackType_OnStart, OnStart);
			g_Factory.SetCallback(NextBotActionCallbackType_Update, Update);
			g_Factory.SetEventCallback(EventResponderType_OnAnimationEvent, OnAnimationEvent);
			g_Factory.BeginDataMapDesc()
				.DefineIntField("m_AttackIndex")
				.DefineStringField("m_AttackName")
				.DefineFloatField("m_NextFireTime")
				.DefineIntField("m_RepeatIndex")
				.EndDataMapDesc();
		}
		SF2_ChaserAttackAction_Bullet action = view_as<SF2_ChaserAttackAction_Bullet>(g_Factory.Create());

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

	if (attackData.Type != SF2BossAttackType_Ranged)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Bullet(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
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
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);
	float gameTime = GetGameTime();
	int difficulty = controller.Difficulty;

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.EventNumber == -1)
	{
		DoBulletAttack(actor, action.GetAttackName());

		int repeatState = attackData.Repeat;
		if (repeatState > 0)
		{
			switch (repeatState)
			{
				case 1:
				{
					action.NextFireTime = gameTime + attackData.DamageDelay[difficulty];
				}
				case 2:
				{
					if (action.RepeatIndex >= attackData.RepeatTimers.Length)
					{
						action.NextFireTime = -1.0;
					}
					else
					{
						float next = attackData.RepeatTimers.Get(action.RepeatIndex);
						action.NextFireTime = next + gameTime;
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

static void DoBulletAttack(SF2_ChaserEntity actor, const char[] attackName)
{
	SF2NPC_Chaser controller = actor.Controller;
	CBaseEntity target = actor.Target;

	int difficulty = controller.Difficulty;

	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(attackName, attackData);

	float spread = attackData.BulletSpread[difficulty];
	ArrayList bulletSounds = data.BulletShootSounds;
	SF2BossProfileSoundInfo soundInfo;
	if (actor.SearchSoundsWithSectionName(bulletSounds, attackName, soundInfo))
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
	effectPos = attackData.BulletOffset;
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

	for (int i = 0; i < attackData.BulletCount[difficulty]; i++)
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
					.damageType = DMG_BULLET,
					.surfaceProp = TR_GetSurfaceProps(trace),
					.hitbox = TR_GetHitGroup(trace),
					.entindex = TR_GetEntityIndex(trace));
			TE_SendToAll();

			SDKHooks_TakeDamage(hitTarget, actor.index, actor.index, attackData.BulletDamage[difficulty], DMG_BULLET, _, CalculateBulletDamageForce(dir, 1.0), endPos);
			if (SF2_BasePlayer(hitTarget).IsValid)
			{
				attackData.ApplyDamageEffects(SF2_BasePlayer(hitTarget), difficulty, SF2_ChaserBossEntity(actor.index));
			}

			if (attackData.BulletTrace[0] == '\0')
			{
				delete trace;
				continue;
			}

			int table = FindStringTable("ParticleEffectNames");
			char tmp[256];
			int count = GetStringTableNumStrings(table);
			int index = INVALID_STRING_INDEX;
			for (int i2 = 0; i2 < count; i2++)
			{
				ReadStringTable(table, i2, tmp, sizeof(tmp));
				if (strcmp(tmp, attackData.BulletTrace, false) == 0)
				{
					index = i2;
					break;
				}
			}

			if (index == INVALID_STRING_INDEX)
			{
				LogError("Could not find particle: %s", attackData.BulletTrace);
				delete trace;
				continue;
			}
			TE_Particle(index, effectPos, effectPos, dir, actor.index, view_as<int>(PATTACH_CUSTOMORIGIN), _, _, true, view_as<int>(PATTACH_CUSTOMORIGIN), endPos);
			TE_SendToAll();
		}
		delete trace;
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
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(action.GetAttackName(), attackData);

	if (event == attackData.EventNumber)
	{
		DoBulletAttack(actor, action.GetAttackName());
	}
}