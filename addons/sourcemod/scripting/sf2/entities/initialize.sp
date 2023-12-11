#include "sf2_base_projectile.sp"

void InitializeCustomEntities()
{
	SF2_ProjectileBase.Initialize();
	SF2_ProjectileRocket.Initialize();
	SF2_ProjectileFireball.Initialize();
	SF2_ProjectileIceball.Initialize();
	SF2_ProjectileSentryRocket.Initialize();
	SF2_ProjectileCowMangler.Initialize();
	SF2_ProjectileArrow.Initialize();
	SF2_ProjectileGrenade.Initialize();
	SF2_ProjectileBaseball.Initialize();
}

void SetupCustomEntitiesAPI()
{
	SF2_ProjectileBase.SetupAPI();
	SF2_ProjectileRocket.SetupAPI();
	SF2_ProjectileFireball.SetupAPI();
	SF2_ProjectileIceball.SetupAPI();
	SF2_ProjectileSentryRocket.SetupAPI();
	SF2_ProjectileCowMangler.SetupAPI();
	SF2_ProjectileArrow.SetupAPI();
	SF2_ProjectileGrenade.SetupAPI();
	SF2_ProjectileBaseball.SetupAPI();
}