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

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_CowMangler.Create", Native_Create);
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

static any Native_Create(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(2, pos, 3);
	GetNativeArray(3, ang, 3);
	char impact[64], trail[64], freeze[64];
	GetNativeString(7, impact, sizeof(impact));
	GetNativeString(8, trail, sizeof(trail));
	GetNativeString(9, freeze, sizeof(freeze));
	SF2_ProjectileCowMangler projectile = SF2_ProjectileCowMangler.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), GetNativeCell(7));
	return projectile;
}