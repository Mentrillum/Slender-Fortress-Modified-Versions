#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_projectile_fireball";

static CEntityFactory g_Factory;

methodmap SF2_ProjectileFireball < SF2_ProjectileBase
{
	public SF2_ProjectileFireball(int entIndex)
	{
		return view_as<SF2_ProjectileFireball>(CBaseAnimating(entIndex));
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
		g_OnPlayerDamagedByProjectilePFwd.AddFunction(null, OnPlayerDamagedByProjectile);
	}

	public static void SetupAPI()
	{
		CreateNative("SF2_Projectile_Fireball.Create", Native_Create);
	}

	public void OnPlayerDamaged(SF2_BasePlayer player)
	{
		player.Ignite(true);
	}

	public static SF2_ProjectileFireball Create(
		const CBaseEntity owner,
		const float pos[3],
		const float ang[3],
		const float speed,
		const float damage,
		const float blastRadius,
		const char[] impactSound,
		const char[] trail,
		const bool attackWaiters = false)
	{
		SF2_ProjectileFireball fireball = SF2_ProjectileFireball(CreateEntityByName(g_EntityClassname));
		if (!fireball.IsValid())
		{
			return SF2_ProjectileFireball(-1);
		}

		fireball.InitializeProjectile(SF2BossProjectileType_Fireball, owner, pos, ang, speed, damage, blastRadius,
									false, "spell_fireball_small_red", "bombinomicon_burningdebris", impactSound, "models/roller.mdl", attackWaiters);

		return fireball;
	}
}

static void OnPlayerDamagedByProjectile(SF2_BasePlayer player, SF2_ProjectileBase projectile)
{
	if (projectile.Type == SF2BossProjectileType_Fireball)
	{
		player.Ignite(true);
	}
}

static any Native_Create(Handle plugin, int numParams)
{
	float pos[3], ang[3];
	GetNativeArray(2, pos, 3);
	GetNativeArray(3, ang, 3);
	char impact[64], trail[64];
	GetNativeString(7, impact, sizeof(impact));
	GetNativeString(8, trail, sizeof(trail));
	SF2_ProjectileFireball projectile = SF2_ProjectileFireball.Create(GetNativeCell(1), pos, ang, GetNativeCell(4), GetNativeCell(5), GetNativeCell(6), impact, trail);
	return projectile;
}