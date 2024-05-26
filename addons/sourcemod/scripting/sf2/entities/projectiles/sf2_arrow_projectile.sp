#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_arrow";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileArrow < SF2_ProjectileBase
{
	public SF2_ProjectileArrow(int entIndex)
	{
		return view_as<SF2_ProjectileArrow>(CBaseAnimating(entIndex));
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
		g_Factory.DeriveFromFactory(SF2_ProjectileBase.GetFactory());
		g_Factory.BeginDataMapDesc()
			.DefineBoolField("m_Touched")
			.EndDataMapDesc();
		g_Factory.Install();
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Arrow.Create", Native_Create);
		CreateNative("SF2_projectile_Arrow.IsValid.get", Native_IsValid);
	}

	property bool Touched
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_Touched") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_Touched", value);
		}
	}

	public static SF2_ProjectileArrow Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const bool isCrits,
		const char[] trail,
		const char[] impactSound,
		const char[] model,
		const bool attackWaiters = false)
	{
		SF2_ProjectileArrow arrow = SF2_ProjectileArrow(CreateEntityByName(g_EntityClassname));
		if (!arrow.IsValid())
		{
			return SF2_ProjectileArrow(-1);
		}

		arrow.Type = SF2BossProjectileType_Arrow;
		arrow.Speed = speed;
		arrow.Damage = damage;
		if (arrow.IsCrits)
		{
			CBaseEntity critParticle = arrow.CreateParticle("critical_rocket_blue");
			arrow.CritEntity = critParticle;
		}
		arrow.AttackWaiters = attackWaiters;
		arrow.SetImpactSound(impactSound);
		SetEntityOwner(arrow.index, owner.index);
		arrow.SetModel(model);
		arrow.KeyValue("solid", "2");

		arrow.Spawn();
		arrow.Activate();
		arrow.SetMoveType(MOVETYPE_FLYGRAVITY);
		arrow.SetProp(Prop_Send, "m_usSolidFlags", 12);
		arrow.Teleport(pos, ang, NULL_VECTOR);
		arrow.CreateTrail(true, "effects/arrowtrail_red.vmt", "255", "1");
		arrow.SetVelocity();

		SDKHook(arrow.index, SDKHook_StartTouch, StartTouch);
	}
}

static void StartTouch(int entity, int other)
{
	SF2_ProjectileArrow projectile = SF2_ProjectileArrow(entity);

	if (other == 0)
	{
		RemoveEntity(projectile.index);
		return;
	}

	bool hit = false;
	SF2_BasePlayer otherPlayer = SF2_BasePlayer(other);
	int owner = projectile.GetPropEnt(Prop_Send, "m_hOwnerEntity");
	if (otherPlayer.IsValid)
	{
		if (otherPlayer.IsInGhostMode)
		{
			return;
		}

		if (otherPlayer.IsEliminated && !projectile.AttackWaiters)
		{
			return;
		}

		if (IsValidEntity(owner) && GetEntProp(owner, Prop_Data, "m_iTeamNum") == otherPlayer.Team)
		{
			return;
		}
	}
	else
	{
		int hitIndex = NPCGetFromEntIndex(other);
		if (hitIndex != -1)
		{
			hit = false;
		}
	}

	if (owner == other)
	{
		hit = false;
	}

	char class[64];
	GetEntityClassname(other, class, sizeof(class));
	if (StrContains(class, "sf2_projectile", false) != -1)
	{
		hit = false;
	}

	if (SF2_BasePlayer(other).IsValid)
	{
		hit = true;
	}

	if (hit)
	{
		Call_StartForward(g_OnProjectileTouchFwd);
		Call_PushCell(projectile);
		Call_PushCell(CBaseEntity(other));
		Call_Finish();
		int flags = DMG_BULLET;
		float pos[3];
		projectile.GetAbsOrigin(pos);
		if (projectile.IsCrits)
		{
			flags |= DMG_ACID;
		}
		SF2_BasePlayer player = SF2_BasePlayer(other);
		if (player.IsValid)
		{
			if (!projectile.AttackWaiters && player.IsEliminated)
			{
				return;
			}

			player.TakeDamage(_, !IsValidEntity(owner) ? projectile.index : owner, !IsValidEntity(owner) ? projectile.index : owner, projectile.Damage, flags, _, _, pos);
			Call_StartForward(g_OnPlayerDamagedByProjectilePFwd);
			Call_PushCell(player);
			Call_PushCell(projectile);
			Call_Finish();
		}
		else
		{
			SDKHooks_TakeDamage(other, !IsValidEntity(owner) ? projectile.index : owner, !IsValidEntity(owner) ? projectile.index : owner, projectile.Damage, flags, _, _, pos);
		}
		EmitSoundToAll(projectile.GetImpactSound(), projectile.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
		RemoveEntity(projectile.index);
	}
}

static any Native_Create(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(2, pos, 3);
	GetNativeArray(3, ang, 3);
	char trail[64], impact[64], model[64];
	GetNativeString(7, trail, sizeof(trail));
	GetNativeString(8, impact, sizeof(impact));
	GetNativeString(9, model, sizeof(model));
	SF2_ProjectileArrow projectile = SF2_ProjectileArrow.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), trail, impact, model, GetNativeCell(10));
	return projectile;
}

static any Native_IsValid(Handle plugin, int numParams)
{
	return SF2_ProjectileArrow(GetNativeCell(1)).IsValid();
}