#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_iceball";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileIceball < SF2_ProjectileBase
{
	public SF2_ProjectileIceball(int entIndex)
	{
		return view_as<SF2_ProjectileIceball>(CBaseAnimating(entIndex));
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
			.DefineFloatField("m_SlowDuration")
			.DefineFloatField("m_SlowMultiplier")
			.DefineStringField("m_FreezeSound")
			.EndDataMapDesc();
		g_Factory.Install();
		g_OnPlayerDamagedByProjectilePFwd.AddFunction(null, OnPlayerDamagedByProjectile);
	}

	property float SlowDuration
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_SlowDuration");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_SlowDuration", value);
		}
	}

	property float SlowMultiplier
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_SlowMultiplier");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_SlowMultiplier", value);
		}
	}

	public char[] GetFreezeSound()
	{
		char buffer[PLATFORM_MAX_PATH];
		this.GetPropString(Prop_Data, "m_FreezeSound", buffer, sizeof(buffer));
		return buffer;
	}

	public void SetFreezeSound(const char[] value)
	{
		this.SetPropString(Prop_Data, "m_FreezeSound", value);
	}

	public void OnPlayerDamaged(SF2_BasePlayer player)
	{
		EmitSoundToClient(player.index, this.GetFreezeSound(), _, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
		player.Stun(this.SlowDuration, this.SlowMultiplier, TF_STUNFLAG_SLOWDOWN, player.index);
	}

	public static SF2_ProjectileIceball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const char[] impactSound,
		const char[] trail,
		const float slowDuration,
		const float slowMultiplier,
		const char[] freezeSound,
		const bool attackWaiters = false)
	{
		SF2_ProjectileIceball iceball = SF2_ProjectileIceball(CreateEntityByName(g_EntityClassname));
		if (!iceball.IsValid())
		{
			return SF2_ProjectileIceball(-1);
		}

		iceball.SlowDuration = slowDuration;
		iceball.SlowMultiplier = slowMultiplier;
		iceball.SetFreezeSound(freezeSound);
		iceball.InitializeProjectile(SF2BossProjectileType_Iceball, owner, pos, ang, speed, damage, blastRadius,
									false, "spell_fireball_small_blue", "spell_batball_impact_blue", impactSound, "models/roller.mdl", attackWaiters);
		return iceball;
	}
}

static void OnPlayerDamagedByProjectile(SF2_BasePlayer player, SF2_ProjectileBase projectile)
{
	if (projectile.Type == SF2BossProjectileType_Iceball)
	{
		SF2_ProjectileIceball iceball = SF2_ProjectileIceball(projectile.index);
		EmitSoundToClient(player.index, iceball.GetFreezeSound(), _, SNDCHAN_ITEM, SNDLEVEL_SCREAMING);
		player.Stun(iceball.SlowDuration, iceball.SlowMultiplier, TF_STUNFLAG_SLOWDOWN, player.index);
	}
}