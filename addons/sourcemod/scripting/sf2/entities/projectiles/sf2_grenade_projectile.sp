#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_grenade";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileGrenade < SF2_ProjectileBase
{
	public SF2_ProjectileGrenade(int entIndex)
	{
		return view_as<SF2_ProjectileGrenade>(CBaseAnimating(entIndex));
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
		g_Factory.DeriveFromClass("prop_physics_override");
		g_Factory.BeginDataMapDesc()
			.DefineEntityField("m_TrailEntity")
			.DefineEntityField("m_ParticleEntity")
			.DefineEntityField("m_CritEntity")
			.DefineIntField("m_Type")
			.DefineFloatField("m_Speed")
			.DefineFloatField("m_Damage")
			.DefineBoolField("m_IsCrits")
			.DefineFloatField("m_BlastRadius")
			.DefineStringField("m_TrailName")
			.DefineStringField("m_ExplosionParticle")
			.DefineStringField("m_ImpactSound")
			.DefineBoolField("m_AttackWaiters")
			.DefineBoolField("m_Touched")
			.DefineFloatField("m_Timer")
			.EndDataMapDesc();
		g_Factory.Install();
	}

	public static CEntityFactory GetFactory()
	{
		return g_Factory;
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Grenade.Create", Native_Create);
		CreateNative("SF2_Projectile_Grenade.IsValid.get", Native_IsValid);
	}

	property CBaseEntity TrailEntity
	{
		public get()
		{
			return CBaseEntity(this.GetPropEnt(Prop_Data, "m_TrailEntity"));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_TrailEntity", entity.index);
		}
	}

	property CBaseEntity ParticleEntity
	{
		public get()
		{
			return CBaseEntity(this.GetPropEnt(Prop_Data, "m_ParticleEntity"));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_ParticleEntity", entity.index);
		}
	}

	property CBaseEntity CritEntity
	{
		public get()
		{
			return CBaseEntity(this.GetPropEnt(Prop_Data, "m_CritEntity"));
		}

		public set(CBaseEntity entity)
		{
			this.SetPropEnt(Prop_Data, "m_CritEntity", entity.index);
		}
	}

	property int Type
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_Type");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_Type", value);
		}
	}

	property float Speed
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_Speed");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_Speed", value);
		}
	}

	property float Damage
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_Damage");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_Damage", value);
		}
	}

	property bool IsCrits
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsCrits") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsCrits", value);
		}
	}

	property float BlastRadius
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_BlastRadius");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_BlastRadius", value);
		}
	}

	public char[] GetTrailName()
	{
		char buffer[128];
		this.GetPropString(Prop_Data, "m_TrailName", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetTrailName(const char[] value)
	{
		this.SetPropString(Prop_Data, "m_TrailName", value);
	}

	public char[] GetExplosionParticle()
	{
		char buffer[128];
		this.GetPropString(Prop_Data, "m_ExplosionParticle", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetExplosionParticle(const char[] value)
	{
		this.SetPropString(Prop_Data, "m_ExplosionParticle", value);
	}

	public char[] GetImpactSound()
	{
		char buffer[PLATFORM_MAX_PATH];
		this.GetPropString(Prop_Data, "m_ImpactSound", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetImpactSound(const char[] value)
	{
		this.SetPropString(Prop_Data, "m_ImpactSound", value);
	}

	property bool AttackWaiters
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_AttackWaiters") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_AttackWaiters", value);
		}
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

	property float Timer
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_Timer");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_Timer", value);
		}
	}

	public static SF2_ProjectileGrenade Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool isCrits,
		const char[] trail,
		const char[] explosion,
		const char[] impactSound,
		const char[] model,
		const bool attackWaiters = false)
	{
		SF2_ProjectileGrenade grenade = SF2_ProjectileGrenade(CreateEntityByName(g_EntityClassname));
		if (!grenade.IsValid())
		{
			return SF2_ProjectileGrenade(-1);
		}

		grenade.Type = SF2BossProjectileType_Grenade;
		grenade.Speed = speed;
		grenade.Damage = damage;
		grenade.BlastRadius = blastRadius;
		if (grenade.IsCrits)
		{
			CBaseEntity critParticle = grenade.CreateParticle("critical_grenade_blue");
			grenade.CritEntity = critParticle;
		}
		grenade.AttackWaiters = attackWaiters;
		grenade.SetTrailName(trail);
		grenade.SetImpactSound(impactSound);
		grenade.SetExplosionParticle(explosion);
		SetEntityOwner(grenade.index, owner.index);
		grenade.SetModel(model);
		grenade.SetProp(Prop_Send, "m_nSkin", 1);
		grenade.KeyValue("solid", "2");
		grenade.KeyValue("spawnflags", "4");
		SetEntityCollisionGroup(grenade.index, COLLISION_GROUP_DEBRIS_TRIGGER);
		grenade.SetProp(Prop_Send, "m_usSolidFlags", 0);

		CBaseEntity particle = grenade.CreateParticle(grenade.GetTrailName());
		grenade.ParticleEntity = particle;

		grenade.Spawn();
		grenade.Activate();
		grenade.CreateTrail();
		grenade.Teleport(pos, ang, NULL_VECTOR);
		grenade.SetVelocity();

		grenade.Timer = GetGameTime() + 2.0;

		CreateTimer(0.1, Timer_Think, EntIndexToEntRef(grenade.index), TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
	}
}

static Action Timer_Think(Handle timer, any ref)
{
	int entity = EntRefToEntIndex(ref);
	if (!entity || entity == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}
	SF2_ProjectileGrenade projectile = SF2_ProjectileGrenade(entity);

	if (projectile.Timer < GetGameTime())
	{
		projectile.DoExplosion();
		if (projectile.IsValid())
		{
			RemoveEdict(projectile.index);
		}
	}

	if (projectile.Touched)
	{
		return Plugin_Continue;
	}

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
			return Plugin_Continue;
		}
		else
		{
			if (SF2_BasePlayer(hitIndex).IsValid)
			{
				if (!SF2_BasePlayer(hitIndex).IsEliminated || projectile.AttackWaiters)
				{
					projectile.DoExplosion();
				}

				if (g_Buildings.FindValue(EntIndexToEntRef(hitIndex)) != -1)
				{
					projectile.DoExplosion();
				}

				if (g_WhitelistedEntities.FindValue(EntIndexToEntRef(hitIndex)) != -1)
				{
					projectile.DoExplosion();
				}

				if (g_BreakableProps.FindValue(EntIndexToEntRef(hitIndex)) != -1)
				{
					projectile.DoExplosion();
				}
			}
		}
	}

	return Plugin_Continue;
}

bool TraceRayGrenade(int entity, int mask, any data)
{
	SF2_ProjectileGrenade projectile = SF2_ProjectileGrenade(data);
	if (entity == data)
	{
		return false;
	}

	int owner = projectile.GetPropEnt(Prop_Send, "m_hOwnerEntity");

	SF2_BasePlayer player = SF2_BasePlayer(entity);
	if (player.IsValid)
	{
		if (player.IsInGhostMode)
		{
			return false;
		}

		if (player.IsEliminated && !projectile.AttackWaiters)
		{
			return false;
		}

		if (IsValidEntity(owner) && GetEntProp(owner, Prop_Data, "m_iTeamNum") == player.Team)
		{
			return false;
		}
	}

	if (IsValidEntity(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}

	if (g_WhitelistedEntities.FindValue(EntIndexToEntRef(entity)) != -1)
	{
		return true;
	}

	if (g_Buildings.FindValue(EntIndexToEntRef(entity)) != -1)
	{
		return true;
	}

	if (g_BreakableProps.FindValue(EntIndexToEntRef(entity)) != -1)
	{
		return true;
	}

	return true;
}

static any Native_Create(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(2, pos, 3);
	GetNativeArray(3, ang, 3);
	char trail[64], explosion[64], impact[64], model[64];
	GetNativeString(8, trail, sizeof(trail));
	GetNativeString(9, explosion, sizeof(explosion));
	GetNativeString(10, impact, sizeof(impact));
	GetNativeString(11, model, sizeof(model));
	SF2_ProjectileGrenade projectile = SF2_ProjectileGrenade.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), GetNativeCell(7), trail, explosion, impact, model, GetNativeCell(12));
	return projectile;
}

static any Native_IsValid(Handle plugin, int numParams)
{
	return SF2_ProjectileGrenade(GetNativeCell(1)).IsValid();
}