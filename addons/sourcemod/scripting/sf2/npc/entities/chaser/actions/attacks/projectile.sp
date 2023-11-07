#pragma semicolon 1

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Projectile < NextBotAction
{
	public SF2_ChaserAttackAction_Projectile(int attackIndex, const char[] attackName, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackProjectile");
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
		SF2_ChaserAttackAction_Projectile action = view_as<SF2_ChaserAttackAction_Projectile>(g_Factory.Create());

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

	if (attackData.Type != SF2BossAttackType_Projectile)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Projectile(attackData.Index, attackData.Name, attackData.DamageDelay[difficulty] + GetGameTime());
	return Plugin_Changed;
}

static int OnStart(SF2_ChaserAttackAction_Projectile action, SF2_ChaserEntity actor, NextBotAction priorAction)
{
	return action.Continue();
}

static int Update(SF2_ChaserAttackAction_Projectile action, SF2_ChaserEntity actor, float interval)
{
	if (action.Parent == NULL_ACTION)
	{
		return action.Done("No longer firing projectiles");
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

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.EventNumber == -1)
	{
		FireProjectile(actor, action.GetAttackName());

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

static void FireProjectile(SF2_ChaserEntity actor, const char[] attackName)
{
	SF2NPC_Chaser controller = actor.Controller;
	float targetPos[3], myPos[3], myAng[3];
	actor.GetAbsOrigin(myPos);
	actor.GetAbsAngles(myAng);
	if (actor.Target.IsValid())
	{
		actor.Target.WorldSpaceCenter(targetPos);
	}
	else
	{
		float fwd[3], eyePos[3];
		GetAngleVectors(myAng, fwd, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(fwd, fwd);
		controller.GetEyePosition(eyePos);
		targetPos[0] = eyePos[0] + fwd[0] * 9001.0;
		targetPos[1] = eyePos[1] + fwd[1] * 9001.0;
		targetPos[2] = eyePos[2] + fwd[2] * 9001.0;
	}
	int difficulty = controller.Difficulty;
	SF2ChaserBossProfileData data;
	data = controller.GetProfileData();
	SF2ChaserBossProfileAttackData attackData;
	data.GetAttack(attackName, attackData);
	SF2BossProfileData originalData;
	originalData = view_as<SF2NPC_BaseNPC>(controller).GetProfileData();

	bool attackWaiters = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	if (originalData.IsPvEBoss)
	{
		attackWaiters = true;
	}

	ArrayList projectileSounds = data.ProjectileShootSounds;
	SF2BossProfileSoundInfo soundInfo;
	if (actor.SearchSoundsWithSectionName(projectileSounds, attackName, soundInfo))
	{
		soundInfo.EmitSound(_, actor.index);
	}

	float effectPos[3];
	effectPos = attackData.ProjectileOffset;
	VectorTransform(effectPos, myPos, myAng, effectPos);

	for (int i = 0; i < attackData.ProjectileCount[difficulty]; i++)
	{
		float direction[3], angle[3];
		SubtractVectors(targetPos, effectPos, direction);
		float deviation = attackData.ProjectileDeviation[difficulty];

		if (deviation != 0)
		{
			direction[0] += GetRandomFloat(-deviation, deviation);
			direction[1] += GetRandomFloat(-deviation, deviation);
			direction[2] += GetRandomFloat(-deviation, deviation);
		}
		NormalizeVector(direction, direction);
		GetVectorAngles(direction, angle);

		switch (attackData.ProjectileType)
		{
			case SF2BossProjectileType_Fireball:
			{
				SF2_ProjectileFireball.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], data.FireballExplodeSound, attackData.FireballTrail, attackWaiters);
			}
			case SF2BossProjectileType_Iceball:
			{
				SF2_ProjectileIceball.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], data.FireballExplodeSound, attackData.IceballTrail, attackData.IceballSlowdownDuration[difficulty], attackData.IceballSlowdownPercent[difficulty], data.IceballSlowSound, attackWaiters);
			}
			case SF2BossProjectileType_Rocket:
			{
				SF2_ProjectileRocket.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], attackData.CritProjectiles[difficulty], data.RocketTrail, data.RocketExplodeParticle, data.RocketExplodeSound, attackData.RocketModel, attackWaiters);
			}
			case SF2BossProjectileType_SentryRocket:
			{
				SF2_ProjectileSentryRocket.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], attackData.CritProjectiles[difficulty], attackWaiters);
			}
			case SF2BossProjectileType_Mangler:
			{
				SF2_ProjectileCowMangler.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], attackWaiters);
			}
			case SF2BossProjectileType_Grenade:
			{
				SF2_ProjectileGrenade.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.ProjectileRadius[difficulty], attackData.CritProjectiles[difficulty], "pipebombtrail_blue", ROCKET_EXPLODE_PARTICLE, ROCKET_IMPACT, "models/weapons/w_models/w_grenade_grenadelauncher.mdl", attackWaiters);
			}
			case SF2BossProjectileType_Arrow:
			{
				SF2_ProjectileArrow.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.CritProjectiles[difficulty], "pipebombtrail_blue", "weapons/fx/rics/arrow_impact_flesh2.wav", "models/weapons/w_models/w_arrow.mdl", attackWaiters);
			}
			case SF2BossProjectileType_Baseball:
			{
				SF2_ProjectileBaseball.Create(actor, effectPos, angle, attackData.ProjectileSpeed[difficulty], attackData.ProjectileDamage[difficulty],
					attackData.CritProjectiles[difficulty], "models/weapons/w_models/w_baseball.mdl", attackWaiters);
			}
		}
	}
}

static void OnAnimationEvent(SF2_ChaserAttackAction_Projectile action, SF2_ChaserEntity actor, int event)
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
		FireProjectile(actor, action.GetAttackName());
	}
}