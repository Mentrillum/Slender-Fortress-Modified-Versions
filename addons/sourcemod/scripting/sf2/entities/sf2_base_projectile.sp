#pragma semicolon 1

static CEntityFactory g_Factory;

PrivateForward g_OnPlayerDamagedByProjectilePFwd;

methodmap SF2_ProjectileBase < CBaseAnimating
{
	public SF2_ProjectileBase(int entIndex)
	{
		return view_as<SF2_ProjectileBase>(CBaseAnimating(entIndex));
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory("sf2_projectile_base", _, OnRemove);
		g_Factory.DeriveFromClass("prop_dynamic_override");
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
			.EndDataMapDesc();
		g_Factory.IsAbstract = true;
		g_Factory.Install();

		g_OnMapStartPFwd.AddFunction(null, MapStart);
		g_OnPlayerDamagedByProjectilePFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	}

	public static CEntityFactory GetFactory()
	{
		return g_Factory;
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Base.Initialize", Native_Initialize);
		CreateNative("SF2_Projectile_Base.DoExplosion", Native_DoExplosion);
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

	public void InitializeProjectile(
		const int type,
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
		this.Type = type;
		this.Speed = speed;
		this.Damage = damage;
		this.BlastRadius = blastRadius;
		this.IsCrits = isCrits;
		if (this.IsCrits)
		{
			CBaseEntity critParticle = this.CreateParticle("critical_rocket_blue");
			this.CritEntity = critParticle;
		}
		this.AttackWaiters = attackWaiters;
		this.SetTrailName(trail);
		this.SetImpactSound(impactSound);
		this.SetExplosionParticle(explosion);
		SetEntityOwner(this.index, owner.index);
		this.SetModel(model);
		if (type == SF2BossProjectileType_Fireball || type == SF2BossProjectileType_Iceball || type == SF2BossProjectileType_Mangler)
		{
			this.SetRenderMode(RENDER_TRANSCOLOR);
			this.SetRenderColor(0, 0, 0, 0);
		}
		this.KeyValue("solid", "2");

		CBaseEntity particle = this.CreateParticle(this.GetTrailName());
		this.ParticleEntity = particle;

		this.Spawn();
		this.Activate();
		this.SetMoveType(MOVETYPE_FLY);
		this.SetProp(Prop_Send, "m_usSolidFlags", 12);
		this.CreateTrail();
		this.Teleport(pos, ang, NULL_VECTOR);
		this.SetVelocity();

		SDKHook(this.index, SDKHook_StartTouch, StartTouch);

		CreateTimer(15.0, Timer_KillEntity, EntIndexToEntRef(this.index), TIMER_FLAG_NO_MAPCHANGE);
	}

	public void CreateTrail(bool teleport = false, const char[] override = "sprites/laserbeam.vmt", const char[] alpha = "0", const char[] mode = "10")
	{
		CBaseEntity trail = CBaseEntity(CreateEntityByName("env_spritetrail"));
		if (trail.IsValid())
		{
			if (teleport)
			{
				float pos[3], ang[3];
				this.GetAbsOrigin(pos);
				this.GetAbsAngles(ang);
				trail.Teleport(pos, ang, NULL_VECTOR);
			}
			trail.KeyValue("spritetrail", override);
			trail.KeyValue("renderamt", alpha);
			trail.KeyValue("rendermode", mode);
			trail.KeyValueFloat("lifetime", 0.5);
			trail.KeyValueFloat("startwidth", 1.0);
			trail.KeyValueFloat("endwidth", 1.0);
			trail.Spawn();
			trail.Activate();
			SetVariantString("!activator");
			trail.AcceptInput("SetParent", this.index);
			this.TrailEntity = trail;
		}
	}

	public CBaseEntity CreateParticle(const char[] particleName)
	{
		CBaseEntity particle = CBaseEntity(CreateEntityByName("info_particle_system"));
		if (!particle.IsValid())
		{
			return CBaseEntity(-1);
		}

		particle.KeyValue("effect_name", particleName);
		particle.Spawn();
		particle.Activate();
		SetVariantString("!activator");
		particle.AcceptInput("SetParent", this.index);
		particle.AcceptInput("Start");
		return particle;
	}

	public void SetVelocity()
	{
		float angle[3], velocity[3], fwd[3];
		this.GetAbsAngles(angle);
		GetAngleVectors(angle, fwd, NULL_VECTOR, NULL_VECTOR);

		velocity[0] = fwd[0] * this.Speed;
		velocity[1] = fwd[1] * this.Speed;
		velocity[2] = fwd[2] * this.Speed;

		this.Teleport(NULL_VECTOR, NULL_VECTOR, velocity);
	}

	public float CalculateFallOff(CBaseEntity target)
	{
		float myPos[3], targetPos[3];
		this.GetAbsOrigin(myPos);
		target.WorldSpaceCenter(targetPos);

		float distance = GetVectorDistance(myPos, targetPos, true) / Pow(this.BlastRadius, 2.0);
		if (distance > 1.0)
		{
			distance = 1.0;
		}
		if (distance < 0.5)
		{
			distance = 0.5;
		}

		float returnValue = this.Damage / distance;
		if (returnValue > this.Damage)
		{
			returnValue = this.Damage;
		}
		return returnValue;
	}

	public void GetDamageForce(CBaseEntity target, float buffer[3])
	{
		target.GetAbsVelocity(buffer);
		NormalizeVector(buffer, buffer);
		ScaleVector(buffer, 2.0);
	}

	public void OnPlayerDamaged(SF2_BasePlayer player)
	{
		// Do nothing
	}

	public void DoExplosion()
	{
		int owner = this.GetPropEnt(Prop_Send, "m_hOwnerEntity");
		float pos[3];
		this.GetAbsOrigin(pos);

		// Go for players
		ArrayList hitList = new ArrayList();
		TR_EnumerateEntitiesSphere(pos, this.BlastRadius, PARTITION_SOLID_EDICTS, EnumerateLivingPlayers, hitList);

		for (int i = 0; i < hitList.Length; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(hitList.Get(i));
			if (!this.AttackWaiters && player.IsEliminated)
			{
				continue;
			}

			float targetPos[3];
			player.GetEyePosition(targetPos);
			TR_TraceRayFilter(pos, targetPos,
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_WINDOW | CONTENTS_MONSTER | CONTENTS_GRATE,
					RayType_EndPoint, TraceRayDontHitAnyEntity, this.index);

			if (!TR_DidHit() || TR_GetEntityIndex() == player.index)
			{
				float damage = this.CalculateFallOff(player);
				int flags = DMG_BLAST;
				if (this.IsCrits)
				{
					flags |= DMG_ACID;
				}
				float force[3];
				this.GetDamageForce(player, force);
				player.TakeDamage(_, !IsValidEntity(owner) ? this.index : owner, !IsValidEntity(owner) ? this.index : owner, damage, flags, _, force, pos);
				Call_StartForward(g_OnPlayerDamagedByProjectilePFwd);
				Call_PushCell(player);
				Call_PushCell(this);
				Call_Finish();
			}
		}
		hitList.Clear();

		// Then do props
		TR_EnumerateEntitiesSphere(pos, this.BlastRadius, PARTITION_SOLID_EDICTS, EnumerateBreakableEntities, hitList);
		for (int i = 0; i < hitList.Length; i++)
		{
			CBaseEntity prop = CBaseEntity(hitList.Get(i));

			float targetPos[3];
			prop.WorldSpaceCenter(targetPos);
			TR_TraceRayFilter(pos, targetPos,
					CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_WINDOW | CONTENTS_MONSTER | CONTENTS_GRATE,
					RayType_EndPoint, TraceRayDontHitAnyEntity, this.index);

			if (!TR_DidHit() || TR_GetEntityIndex() == prop.index)
			{
				float damage = this.CalculateFallOff(prop);
				int flags = DMG_BLAST;
				if (this.IsCrits)
				{
					flags |= DMG_ACID;
				}
				float force[3];
				this.GetDamageForce(prop, force);
				SDKHooks_TakeDamage(prop.index, !IsValidEntity(owner) ? this.index : owner, !IsValidEntity(owner) ? this.index : owner, damage, flags, _, force, pos, false);
			}
		}

		delete hitList;
		if (this.Type != SF2BossProjectileType_Mangler)
		{
			EmitSoundToAll(this.GetImpactSound(), this.index, SNDCHAN_ITEM);
		}
		else
		{
			int random = GetRandomInt(0, 2);
			char sound[PLATFORM_MAX_PATH];
			switch (random)
			{
				case 0:
				{
					strcopy(sound, sizeof(sound), MANGLER_EXPLODE1);
				}

				case 1:
				{
					strcopy(sound, sizeof(sound), MANGLER_EXPLODE2);
				}

				case 2:
				{
					strcopy(sound, sizeof(sound), MANGLER_EXPLODE3);
				}
			}
			EmitSoundToAll(sound, this.index, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
		}
		CBaseEntity particle = CBaseEntity(CreateEntityByName("info_particle_system"));
		if (particle.IsValid())
		{
			particle.KeyValue("effect_name", this.GetExplosionParticle());
			particle.Teleport(pos, NULL_VECTOR, NULL_VECTOR);
			particle.Spawn();
			particle.Activate();
			particle.AcceptInput("Start");
			CreateTimer(0.1, Timer_KillEntity, EntIndexToEntRef(particle.index), TIMER_FLAG_NO_MAPCHANGE);
		}
		RemoveEntity(this.index);
	}
}

static void OnRemove(SF2_ProjectileBase projectile)
{
	if (projectile.TrailEntity.IsValid())
	{
		RemoveEntity(projectile.TrailEntity.index);
	}
	if (projectile.ParticleEntity.IsValid())
	{
		RemoveEntity(projectile.ParticleEntity.index);
	}
	if (projectile.CritEntity.IsValid())
	{
		RemoveEntity(projectile.CritEntity.index);
	}
}

static void MapStart()
{
	PrecacheModel("models/roller.mdl");
	PrecacheModel("models/buildables/sentry3_rockets.mdl");
	PrecacheModel("models/weapons/w_models/w_grenade_grenadelauncher.mdl");
	PrecacheModel("models/weapons/w_models/w_arrow.mdl");
	PrecacheSound("weapons/fx/rics/arrow_impact_flesh2.wav");
}

static void StartTouch(int entity, int other)
{
	SF2_ProjectileBase projectile = SF2_ProjectileBase(entity);

	bool hit = true;
	SF2_BasePlayer otherPlayer = SF2_BasePlayer(other);
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
	}
	else
	{
		int hitIndex = NPCGetFromEntIndex(other);
		if (hitIndex != -1)
		{
			hit = false;
		}
	}

	if (projectile.GetPropEnt(Prop_Send, "m_hOwnerEntity") == other)
	{
		hit = false;
	}

	char class[64];
	GetEntityClassname(other, class, sizeof(class));
	if (StrContains(class, "sf2_projectile", false) != -1)
	{
		hit = false;
	}

	if (other == 0)
	{
		hit = true;
	}

	if (hit)
	{
		projectile.DoExplosion();
	}
}

static any Native_Initialize(Handle plugin, int numParams)
{
	SF2_ProjectileBase projectile = SF2_ProjectileBase(GetNativeCell(1));
	if (!projectile.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid projectile index %d", projectile.index);
	}

	float pos[3], ang[3];
	GetNativeArray(3, pos, 3);
	GetNativeArray(4, ang, 3);
	char trail[64], explosion[64], impact[64], model[64];
	GetNativeString(9, trail, sizeof(trail));
	GetNativeString(10, explosion, sizeof(explosion));
	GetNativeString(11, impact, sizeof(impact));
	GetNativeString(12, model, sizeof(model));
	projectile.InitializeProjectile(GetNativeCell(1), GetNativeCell(2), pos, ang, GetNativeCell(5), GetNativeCell(6), GetNativeCell(7), GetNativeCell(8), trail, explosion, impact, model, GetNativeCell(13));

	return 0;
}

static any Native_DoExplosion(Handle plugin, int numParams)
{
	SF2_ProjectileBase projectile = SF2_ProjectileBase(GetNativeCell(1));
	if (!projectile.IsValid())
	{
		return ThrowNativeError(SP_ERROR_NATIVE, "Invalid projectile index %d", projectile.index);
	}

	projectile.DoExplosion();

	return 0;
}

#include "projectiles/sf2_fireball_projectile.sp"
#include "projectiles/sf2_iceball_projectile.sp"
#include "projectiles/sf2_rocket_projectile.sp"
#include "projectiles/sf2_sentry_rocket_projectile.sp"
#include "projectiles/sf2_cow_mangler_projectile.sp"
#include "projectiles/sf2_grenade_projectile.sp"
#include "projectiles/sf2_arrow_projectile.sp"
#include "projectiles/sf2_baseball_projectile.sp"