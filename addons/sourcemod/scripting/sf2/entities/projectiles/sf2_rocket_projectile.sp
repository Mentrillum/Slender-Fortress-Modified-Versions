#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_rocket";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileRocket < SF2_ProjectileBase
{
	public SF2_ProjectileRocket(int entIndex)
	{
		return view_as<SF2_ProjectileRocket>(CBaseAnimating(entIndex));
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
		g_Factory.Install();
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Rocket.Create", Native_Create);
	}

	public static SF2_ProjectileRocket Create(
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
		SF2_ProjectileRocket rocket = SF2_ProjectileRocket(CreateEntityByName(g_EntityClassname));
		if (!rocket.IsValid())
		{
			return SF2_ProjectileRocket(-1);
		}

		rocket.InitializeProjectile(SF2BossProjectileType_Rocket, owner, pos, ang, speed, damage, blastRadius, isCrits, trail, explosion, impactSound, model, attackWaiters);

		return rocket;
	}
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
	SF2_ProjectileRocket projectile = SF2_ProjectileRocket.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), GetNativeCell(7), trail, explosion, impact, model, GetNativeCell(12));
	return projectile;
}