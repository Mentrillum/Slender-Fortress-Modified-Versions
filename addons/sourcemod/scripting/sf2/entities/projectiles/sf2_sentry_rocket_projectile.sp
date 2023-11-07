#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_sentryrocket";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileSentryRocket < SF2_ProjectileRocket
{
	public SF2_ProjectileSentryRocket(int entIndex)
	{
		return view_as<SF2_ProjectileSentryRocket>(CBaseAnimating(entIndex));
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
		g_Factory.DeriveFromFactory(SF2_ProjectileRocket.GetFactory());
		g_Factory.Install();
	}

	public static SF2_ProjectileSentryRocket Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool isCrits,
		const bool attackWaiters = false)
	{
		SF2_ProjectileSentryRocket rocket = SF2_ProjectileSentryRocket(CreateEntityByName(g_EntityClassname));
		if (!rocket.IsValid())
		{
			return SF2_ProjectileSentryRocket(-1);
		}

		rocket.InitializeProjectile(SF2BossProjectileType_SentryRocket, owner, pos, ang, speed, damage, blastRadius, isCrits, ROCKET_TRAIL, ROCKET_EXPLODE_PARTICLE, ROCKET_IMPACT, "models/buildables/sentry3_rockets.mdl", attackWaiters);
		rocket.ResetSequence(rocket.LookupSequence("idle"));
		rocket.SetProp(Prop_Data, "m_bSequenceLoops", true);

		return rocket;
	}
}
