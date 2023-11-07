#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_cowmangler";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileCowMangler < SF2_ProjectileRocket
{
	public SF2_ProjectileCowMangler(int entIndex)
	{
		return view_as<SF2_ProjectileCowMangler>(CBaseAnimating(entIndex));
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

	public static SF2_ProjectileCowMangler Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const bool attackWaiters = false)
	{
		SF2_ProjectileCowMangler rocket = SF2_ProjectileCowMangler(CreateEntityByName(g_EntityClassname));
		if (!rocket.IsValid())
		{
			return SF2_ProjectileCowMangler(-1);
		}

		rocket.InitializeProjectile(SF2BossProjectileType_Mangler, owner, pos, ang, speed, damage, blastRadius, false, "drg_cow_rockettrail_normal_blue", "drg_cow_explosioncore_normal_blue", ROCKET_IMPACT, "models/roller.mdl", attackWaiters);

		return rocket;
	}
}
