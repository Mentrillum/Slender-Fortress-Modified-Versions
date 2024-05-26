#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_baseball";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileBaseball < SF2_ProjectileGrenade
{
	public SF2_ProjectileBaseball(int entIndex)
	{
		return view_as<SF2_ProjectileBaseball>(CBaseAnimating(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseAnimating(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory(g_EntityClassname);
		g_Factory.DeriveFromFactory(SF2_ProjectileGrenade.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineFloatField("m_TravelTime")
			.EndDataMapDesc();
		g_Factory.Install();
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Baseball.Create", Native_Create);
		CreateNative("SF2_Projectile_Baseball.IsValid.get", Native_IsValid);
	}

	property float TravelTime
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_TravelTime");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_TravelTime", value);
		}
	}

	public static SF2_ProjectileBaseball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const bool isCrits,
		const char[] model,
		const bool attackWaiters = false)
	{
		SF2_ProjectileBaseball ball = SF2_ProjectileBaseball(CreateEntityByName(g_EntityClassname));
		if (!ball.IsValid())
		{
			return SF2_ProjectileBaseball(-1);
		}

		ball.Type = SF2BossProjectileType_Baseball;
		ball.Speed = speed;
		ball.Damage = damage;
		if (ball.IsCrits)
		{
			CBaseEntity critParticle = ball.CreateParticle("critical_rocket_blue");
			ball.CritEntity = critParticle;
		}
		ball.AttackWaiters = attackWaiters;
		SetEntityOwner(ball.index, owner.index);
		ball.SetModel(model);
		ball.SetProp(Prop_Send, "m_nSkin", 1);
		ball.SetProp(Prop_Send, "m_usSolidFlags", 12);
		ball.KeyValue("solid", "2");
		ball.KeyValue("spawnflags", "4");
		SetEntityCollisionGroup(ball.index, COLLISION_GROUP_DEBRIS_TRIGGER);
		ball.SetProp(Prop_Send, "m_usSolidFlags", 0);

		ball.Spawn();
		ball.Activate();
		ball.Teleport(pos, ang, NULL_VECTOR);
		ball.CreateTrail(true, "effects/baseballtrail_blu.vmt", "255", "1");
		ball.SetVelocity();

		ball.Timer = GetGameTime() + 12.0;

		SDKHook(ball.index, SDKHook_VPhysicsUpdate, Think);
	}
}

static void Think(int entity)
{
	SF2_ProjectileBaseball projectile = SF2_ProjectileBaseball(entity);
	int owner = projectile.GetPropEnt(Prop_Send, "m_hOwnerEntity");

	if (projectile.Timer < GetGameTime())
	{
		RemoveEdict(projectile.index);
	}

	if (projectile.Touched)
	{
		return;
	}

	projectile.TravelTime += GetGameFrameTime();

	float pos[3], mins[3], maxs[3];
	projectile.GetAbsOrigin(pos);
	projectile.GetPropVector(Prop_Send, "m_vecMins", mins);
	projectile.GetPropVector(Prop_Send, "m_vecMaxs", maxs);
	TR_TraceHullFilter(pos, pos, mins, maxs, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_MONSTERCLIP, TraceRayGrenade, projectile.index);

	int hitIndex = TR_GetEntityIndex();
	if (IsValidEntity(hitIndex))
	{
		Call_StartForward(g_OnProjectileTouchFwd);
		Call_PushCell(projectile);
		Call_PushCell(CBaseEntity(hitIndex));
		Call_Finish();

		if (hitIndex == 0)
		{
			projectile.Touched = true;
			return;
		}
		else
		{
			int flags = DMG_CLUB;
			if (projectile.IsCrits)
			{
				flags |= DMG_ACID;
			}
			SF2_BasePlayer player = SF2_BasePlayer(hitIndex);
			if (player.IsValid)
			{
				if (player.IsInGhostMode)
				{
					return;
				}

				if (player.IsEliminated && !projectile.AttackWaiters)
				{
					projectile.Touched = true;
					return;
				}

				if (IsValidEntity(owner) && GetEntProp(owner, Prop_Data, "m_iTeamNum") == player.Team)
				{
					projectile.Touched = true;
					return;
				}
				player.TakeDamage(_, !IsValidEntity(owner) ? projectile.index : owner, !IsValidEntity(owner) ? projectile.index : owner, projectile.Damage, flags, _, _, pos);
				float ratio = projectile.TravelTime / 1.0;
				if (ratio > 0.1)
				{
					float time = 6.0 * ratio;
					float stun = 0.5;
					if (projectile.IsCrits)
					{
						time += 2.0;
					}

					if (ratio >= 1.0)
					{
						time += 1.0;
					}

					if (player.GetProp(Prop_Send, "m_nWaterLevel") < 3)
					{
						player.Stun(time, stun, TF_STUNFLAG_SLOWDOWN, player.index);
					}
				}
				Call_StartForward(g_OnPlayerDamagedByProjectilePFwd);
				Call_PushCell(player);
				Call_PushCell(projectile);
				Call_Finish();
				projectile.Touched = true;
			}
			else
			{
				SDKHooks_TakeDamage(hitIndex, !IsValidEntity(owner) ? projectile.index : owner, !IsValidEntity(owner) ? projectile.index : owner, projectile.Damage, flags, _, _, pos);
			}
		}
	}
}

static any Native_Create(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(2, pos, 3);
	GetNativeArray(3, ang, 3);
	char model[64];
	GetNativeString(7, model, sizeof(model));
	SF2_ProjectileBaseball projectile = SF2_ProjectileBaseball.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), model, GetNativeCell(8));
	return projectile;
}

static any Native_IsValid(Handle plugin, int numParams)
{
	return SF2_ProjectileBaseball(GetNativeCell(1)).IsValid();
}