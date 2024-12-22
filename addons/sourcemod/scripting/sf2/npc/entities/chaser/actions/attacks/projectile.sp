#pragma semicolon 1
#pragma newdecls required

methodmap ChaserBossProfileProjectileAttack < ChaserBossProfileBaseAttack
{
	public float GetSpeed(int difficulty)
	{
		float def = 1100.0;
		def = this.GetDifficultyFloat("projectile_speed", difficulty, def);
		def = this.GetDifficultyFloat("attack_projectile_speed", difficulty, def);
		return def;
	}

	public float GetBlastRadius(int difficulty)
	{
		float def = 128.0;
		def = this.GetDifficultyFloat("projectile_radius", difficulty, def);
		def = this.GetDifficultyFloat("attack_projectile_radius", difficulty, def);
		return def;
	}

	public float GetDeviation(int difficulty)
	{
		float def = 0.0;
		def = this.GetDifficultyFloat("projectile_deviation", difficulty, def);
		def = this.GetDifficultyFloat("attack_projectile_deviation", difficulty, def);
		return def;
	}

	public int GetProjectileCount(int difficulty)
	{
		int def = 1;
		def = this.GetDifficultyInt("projectile_count", difficulty, def);
		def = this.GetDifficultyInt("attack_projectile_count", difficulty, def);
		return def;
	}

	public bool GetCrits(int difficulty)
	{
		bool def = false;
		def = this.GetDifficultyBool("projectile_crits", difficulty, def);
		def = this.GetDifficultyBool("attack_projectile_crits", difficulty, def);
		return def;
	}

	property int ProjectileType
	{
		public get()
		{
			int def = SF2BossProjectileType_Fireball;
			def = this.GetInt("projectiletype", def);
			def = this.GetInt("attack_projectiletype", def);
			return def;
		}
	}

	public void GetOffset(float buffer[3])
	{
		this.GetVector("projectile_offset", buffer, buffer);
		this.GetVector("attack_projectile_offset", buffer, buffer);
	}

	public void GetFireballTrail(char[] buffer, int bufferSize)
	{
		this.GetString("fire_trail", buffer, bufferSize, FIREBALL_TRAIL);
	}

	public void GetRocketModel(char[] buffer, int bufferSize)
	{
		this.GetString("rocket_model", buffer, bufferSize, ROCKET_MODEL);
	}

	public float GetIceballSlowPercent(int difficulty)
	{
		float def = 0.55;
		def = this.GetDifficultyFloat("projectile_iceslow_percent", difficulty, def);
		def = this.GetDifficultyFloat("attack_projectile_iceslow_percent", difficulty, def);
		return def;
	}

	public float GetIceballSlowDuration(int difficulty)
	{
		float def = 2.0;
		def = this.GetDifficultyFloat("projectile_iceslow_duration", difficulty, def);
		def = this.GetDifficultyFloat("attack_projectile_iceslow_duration", difficulty, def);
		return def;
	}

	public void GetIceballTrail(char[] buffer, int bufferSize)
	{
		this.GetString("fire_iceball_trail", buffer, bufferSize, ICEBALL_TRAIL);
	}
}

static NextBotActionFactory g_Factory;

methodmap SF2_ChaserAttackAction_Projectile < NextBotAction
{
	public SF2_ChaserAttackAction_Projectile(const char[] attackName, ChaserBossProfileProjectileAttack data, float fireDelay)
	{
		if (g_Factory == null)
		{
			g_Factory = new NextBotActionFactory("Chaser_AttackProjectile");
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
		SF2_ChaserAttackAction_Projectile action = view_as<SF2_ChaserAttackAction_Projectile>(g_Factory.Create());

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

	property ChaserBossProfileProjectileAttack ProfileData
	{
		public get()
		{
			return this.GetData("m_ProfileData");
		}

		public set(ChaserBossProfileProjectileAttack value)
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
	ChaserBossProfileProjectileAttack attackData = view_as<ChaserBossProfileProjectileAttack>(data.GetAttack(attackName));
	int difficulty = chaser.Controller.Difficulty;

	if (attackData.Type != SF2BossAttackType_Projectile)
	{
		return Plugin_Continue;
	}

	result = SF2_ChaserAttackAction_Projectile(attackName, attackData, attackData.GetDelay(difficulty) + GetGameTime());
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
	ChaserBossProfileProjectileAttack attackData = action.ProfileData;
	int difficulty = controller.Difficulty;

	float gameTime = GetGameTime();

	if (action.NextFireTime >= 0.0 && gameTime > action.NextFireTime && attackData.GetEventNumber(difficulty) == -1)
	{
		FireProjectile(actor, action, action.GetAttackName());
		actor.ResetProfileAnimation(g_SlenderAnimationsList[SF2BossAnimation_ProjectileShoot], _, action.GetAttackName());

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

static void FireProjectile(SF2_ChaserEntity actor, SF2_ChaserAttackAction_Projectile action, const char[] attackName)
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
	ChaserBossProfile data = controller.GetProfileDataEx();
	ChaserBossProfileProjectileAttack attackData = action.ProfileData;
	ChaserBossProjectileData projectileData = data.GetProjectiles();

	bool attackWaiters = (controller.Flags & SFF_ATTACKWAITERS) != 0;
	if (data.IsPvEBoss)
	{
		attackWaiters = true;
	}

	ProfileSound soundInfo;
	if (actor.SearchSoundsWithSectionName(data.GetProjectileShootSounds(), attackName, soundInfo, "attackshootprojectile"))
	{
		soundInfo.EmitSound(_, actor.index);
	}

	float effectPos[3];
	attackData.GetOffset(effectPos);
	VectorTransform(effectPos, myPos, myAng, effectPos);

	for (int i = 0; i < attackData.GetProjectileCount(difficulty); i++)
	{
		float direction[3], angle[3];
		SubtractVectors(targetPos, effectPos, direction);
		float deviation = attackData.GetDeviation(difficulty);

		NormalizeVector(direction, direction);
		GetVectorAngles(direction, angle);
		if (deviation != 0.0)
		{
			angle[0] += GetRandomFloat(-deviation, deviation);
			angle[1] += GetRandomFloat(-deviation, deviation);
			angle[2] += GetRandomFloat(-deviation, deviation);
		}

		switch (attackData.ProjectileType)
		{
			case SF2BossProjectileType_Fireball:
			{
				char trail[PLATFORM_MAX_PATH], explode[PLATFORM_MAX_PATH];
				attackData.GetFireballTrail(trail, sizeof(trail));
				projectileData.GetFireballExplodeSound(explode, sizeof(explode));
				SF2_ProjectileFireball.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), explode, trail, attackWaiters);
			}
			case SF2BossProjectileType_Iceball:
			{
				char trail[PLATFORM_MAX_PATH], explode[PLATFORM_MAX_PATH], slow[PLATFORM_MAX_PATH];
				attackData.GetFireballTrail(trail, sizeof(trail));
				projectileData.GetFireballExplodeSound(explode, sizeof(explode));
				projectileData.GetIceballSlowSound(explode, sizeof(explode));
				SF2_ProjectileIceball.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), explode, trail, attackData.GetIceballSlowDuration(difficulty), attackData.GetIceballSlowPercent(difficulty), slow, attackWaiters);
			}
			case SF2BossProjectileType_Rocket:
			{
				char model[PLATFORM_MAX_PATH], trail[PLATFORM_MAX_PATH], explodeSound[PLATFORM_MAX_PATH], explodeParticle[64];
				attackData.GetRocketModel(model, sizeof(model));
				projectileData.GetRocketTrail(trail, sizeof(trail));
				projectileData.GetRocketExplodeSound(explodeSound, sizeof(explodeSound));
				projectileData.GetRocketExplodeParticle(explodeParticle, sizeof(explodeParticle));
				SF2_ProjectileRocket.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), attackData.GetCrits(difficulty), trail, explodeParticle, explodeSound, model, attackWaiters);
			}
			case SF2BossProjectileType_SentryRocket:
			{
				SF2_ProjectileSentryRocket.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), attackData.GetCrits(difficulty), attackWaiters);
			}
			case SF2BossProjectileType_Mangler:
			{
				SF2_ProjectileCowMangler.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), attackWaiters);
			}
			case SF2BossProjectileType_Grenade:
			{
				SF2_ProjectileGrenade.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetBlastRadius(difficulty), attackData.GetCrits(difficulty), "pipebombtrail_blue", ROCKET_EXPLODE_PARTICLE, ROCKET_IMPACT, "models/weapons/w_models/w_grenade_grenadelauncher.mdl", attackWaiters);
			}
			case SF2BossProjectileType_Arrow:
			{
				SF2_ProjectileArrow.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetCrits(difficulty), "pipebombtrail_blue", "weapons/fx/rics/arrow_impact_flesh2.wav", "models/weapons/w_models/w_arrow.mdl", attackWaiters);
			}
			case SF2BossProjectileType_Baseball:
			{
				SF2_ProjectileBaseball.Create(actor, effectPos, angle, attackData.GetSpeed(difficulty), attackData.GetDamage(difficulty),
					attackData.GetCrits(difficulty), "models/weapons/w_models/w_baseball.mdl", attackWaiters);
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
	ChaserBossProfileProjectileAttack attackData = action.ProfileData;

	if (event == attackData.GetEventNumber(controller.Difficulty))
	{
		FireProjectile(actor, action, action.GetAttackName());
	}
}