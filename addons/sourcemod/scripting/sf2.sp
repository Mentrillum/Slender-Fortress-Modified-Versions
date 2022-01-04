#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>
#include <tf2items>
#include <tf2attributes>
#include <dhooks>
#include <nativevotes>
#include <collisionhook>
#include <cbasenpc>
#include <cbasenpc/util>

#pragma semicolon 1

#include <tf2>
#include <tf2_stocks>
#include <morecolors>

#undef REQUIRE_PLUGIN
#include <adminmenu>
#tryinclude <store/store-tf2footprints>
#tryinclude <store>
#define REQUIRE_PLUGIN

#undef REQUIRE_EXTENSIONS
#tryinclude <steamtools>
#tryinclude <steamworks>
bool steamtools;
bool steamworks;
#define REQUIRE_EXTENSIONS

#define DEBUG
#define SF2

#include <sf2>
#pragma newdecls required

#define PLUGIN_VERSION "1.7.1.1 M"
#define PLUGIN_VERSION_DISPLAY "1.7.1.1 M"

#define TFTeam_Spectator 1
#define TFTeam_Red 2
#define TFTeam_Blue 3
#define TFTeam_Boss 5

#define MASK_RED 33640459
#define MASK_BLUE 33638411

#define EF_ITEM_BLINK 0x100


public Plugin myinfo = 
{
	name = "Slender Fortress", 
	author = "KitRifty, Kenzzer, Mentrillum, The Gaben", 
	description = "Based on the game Slender: The Eight Pages.", 
	version = PLUGIN_VERSION, 
	url = "https://discord.gg/7Zz7RYTCC4"
}

#define FILE_RESTRICTEDWEAPONS "configs/sf2/restrictedweapons.cfg"
#define FILE_RESTRICTEDWEAPONS_DATA "data/sf2/restrictedweapons.cfg"

#define BOSS_THINKRATE 0.1 // doesn't really matter much since timers go at a minimum of 0.1 seconds anyways

#define CRIT_SOUND "player/crit_hit.wav"
#define CRIT_PARTICLENAME "crit_text"
#define MINICRIT_SOUND "player/crit_hit_mini.wav"
#define MINICRIT_PARTICLENAME "minicrit_text"
#define ZAP_SOUND "weapons/barret_arm_zap.wav"
#define ZAP_PARTICLENAME "dxhr_arm_muzzleflash"
#define FIREWORKSBLU_PARTICLENAME "utaunt_firework_teamcolor_blue"
#define FIREWORKSRED_PARTICLENAME "utaunt_firework_teamcolor_red"
#define TELEPORTEDINBLU_PARTICLENAME "teleported_red"
#define SOUND_THUNDER "ambient/explosions/explode_9.wav"

#define EXPLOSIVEDANCE_EXPLOSION1 "weapons/explode1.wav"
#define EXPLOSIVEDANCE_EXPLOSION2 "weapons/explode2.wav"
#define EXPLOSIVEDANCE_EXPLOSION3 "weapons/explode3.wav"

#define SPECIAL1UPSOUND "mvm/mvm_revive.wav"

#define SPECIALROUND_BOO_DISTANCE 120.0
#define SPECIALROUND_BOO_DURATION 4.0

#define PAGE_DETECTOR_BEEP "items/cart_explode_trigger.wav"

#define PAGE_MODEL "models/slender/pickups/sheet.mdl"
#define PAGE_MODELSCALE 1.0

#define DEFAULT_CLOAKONSOUND "weapons/medi_shield_deploy.wav"
#define DEFAULT_CLOAKOFFSOUND "weapons/medi_shield_retract.wav"

#define SF_KEYMODEL "models/demani_sf/key_australium.mdl"

#define FLASHLIGHT_CLICKSOUND "slender/slenderflashlightclick.wav"
#define FLASHLIGHT_CLICKSOUND_NIGHTVISION "slender/nightvision.mp3"
#define FLASHLIGHT_BREAKSOUND "ambient/energy/spark6.wav"
#define FLASHLIGHT_NOSOUND "player/suit_denydevice.wav"
#define PAGE_GRABSOUND "slender/slenderpagegrab.wav"
#define TWENTYDOLLARS_MUSIC "slender/gimm20dollars_v2.wav"
#define MARBLEHORNETS_STATIC "slender/staticlight.wav"

#define MUSIC_CHAN SNDCHAN_AUTO
#define MUSIC_GOTPAGES1_SOUND "slender/newambience_1.wav"
#define MUSIC_GOTPAGES2_SOUND "slender/newambience_2.wav"
#define MUSIC_GOTPAGES3_SOUND "slender/newambience_3.wav"
#define MUSIC_GOTPAGES4_SOUND "slender/newambience_4.wav"
#define MUSIC_PAGE_VOLUME 1.0

#define SF2_INTRO_DEFAULT_MUSIC "slender/intro.mp3"

#define PROXY_RAGE_MODE_SOUND "slender/proxyrage.mp3"

#define FIREBALL_SHOOT "misc/halloween/spell_fireball_cast.wav"
#define FIREBALL_IMPACT "misc/halloween/spell_fireball_impact.wav"
#define ICEBALL_IMPACT "weapons/icicle_freeze_victim_01.wav"
#define ROCKET_SHOOT "weapons/rocket_shoot.wav"
#define ROCKET_IMPACT "weapons/explode1.wav"
#define ROCKET_MODEL "models/weapons/w_models/w_rocket.mdl"
#define ROCKET_TRAIL "rockettrail"
#define ROCKET_EXPLODE_PARTICLE "ExplosionCore_MidAir"
#define GRENADE_SHOOT "weapons/grenade_launcher_shoot.wav"
#define SENTRYROCKET_SHOOT "weapons/sentry_rocket.wav"
#define ARROW_SHOOT "weapons/bow_shoot.wav"
#define GRENADE_MODEL "models/weapons/w_models/w_grenade_grenadelauncher.mdl"
#define MANGLER_SHOOT "weapons/cow_mangler_main_shot.wav"
#define MANGLER_EXPLODE1 "weapons/cow_mangler_explosion_normal_01.wav"
#define MANGLER_EXPLODE2 "weapons/cow_mangler_explosion_normal_02.wav"
#define MANGLER_EXPLODE3 "weapons/cow_mangler_explosion_normal_03.wav"
#define BASEBALL_SHOOT "weapons/bat_baseball_hit1.wav"
#define BASEBALL_MODEL "weapons/w_models/w_baseball.mdl"

#define JARATE_HITPLAYER "weapons/jar_single.wav"
#define JARATE_PARTICLE "peejar_impact"
#define MILK_PARTICLE "peejar_impact_milk"
#define GAS_PARTICLE "gas_can_impact_blue"
#define STUN_HITPLAYER "weapons/icicle_freeze_victim_01.wav"
#define STUN_PARTICLE "xms_icicle_melt"
#define ELECTRIC_RED_PARTICLE "electrocuted_gibbed_red"
#define ELECTRIC_BLUE_PARTICLE "electrocuted_gibbed_red"

//Page Rewards
#define EXPLODE_PLAYER "items/pumpkin_explode1.wav"
#define UBER_ROLL "misc/halloween/spell_overheal.wav"
#define NO_EFFECT_ROLL "player/taunt_sorcery_fail.wav"
#define BLEED_ROLL "items/powerup_pickup_plague_infected.wav"
#define CRIT_ROLL "items/powerup_pickup_crits.wav"
#define LOSE_SPRINT_ROLL "misc/banana_slip.wav"
#define JARATE_ROLL "weapons/jar_explode.wav"
#define GAS_ROLL "weapons/gas_can_explode.wav"

#define FIREWORK_EXPLOSION	"weapons/flare_detonator_explode.wav"
#define FIREWORK_START "weapons/flare_detonator_launch.wav"
#define FIREWORK_PARTICLE	"burningplayer_rainbow_flame"

#define GENERIC_ROLL_TICK_1 "ui/buttonrollover.wav"
#define GENERIC_ROLL_TICK_2 "ui/buttonrollover.wav"

#define MINICRIT_BUFF "weapons/buff_banner_flag.wav"

#define HYPERSNATCHER_NIGHTAMRE_1 "slender/snatcher/nightmare1.wav"
#define HYPERSNATCHER_NIGHTAMRE_2 "slender/snatcher/nightmare2.wav"
#define HYPERSNATCHER_NIGHTAMRE_3 "slender/snatcher/nightmare3.wav"
#define HYPERSNATCHER_NIGHTAMRE_4 "slender/snatcher/nightmare4.wav"
#define HYPERSNATCHER_NIGHTAMRE_5 "slender/snatcher/nightmare5.wav"
#define SNATCHER_APOLLYON_1 "slender/snatcher/apollyon1.wav"
#define SNATCHER_APOLLYON_2 "slender/snatcher/apollyon2.wav"
#define SNATCHER_APOLLYON_3 "slender/snatcher/apollyon3.wav"

#define RENEVANT_MAXWAVES 5

#define NULLSOUND "misc/null.wav"

#define NINETYSMUSIC "slender/sf2modified_runninginthe90s_v2.wav"
#define TRIPLEBOSSESMUSIC "slender/sf2modified_triplebosses_v2.wav"

#define TRAP_DEPLOY "slender/modified_traps/beartrap/trap_deploy.mp3"
#define TRAP_CLOSE "slender/modified_traps/beartrap/trap_close.mp3"
#define TRAP_MODEL "models/mentrillum/traps/beartrap.mdl"

#define LASER_MODEL "sprites/laser.vmt"

#define THANATOPHOBIA_MEDICNO "vo/medic_no03.mp3"

#define SF2_HUD_TEXT_COLOR_R 127
#define SF2_HUD_TEXT_COLOR_G 167
#define SF2_HUD_TEXT_COLOR_B 141
#define SF2_HUD_TEXT_COLOR_A 255

enum struct MuteMode
{
	int MuteMode_Normal;
	int MuteMode_DontHearOtherTeam;
	int MuteMode_DontHearOtherTeamIfNotProxy;
}

enum struct FlashlightTemperature
{
	int FlashlightTemperature_6000;
	int FlashlightTemperature_1000;
	int FlashlightTemperature_2000;
	int FlashlightTemperature_3000;
	int FlashlightTemperature_4000;
	int FlashlightTemperature_5000;
	int FlashlightTemperature_7000;
	int FlashlightTemperature_8000;
	int FlashlightTemperature_9000;
	int FlashlightTemperature_10000;
}

char g_strSoundNightmareMode[][] = 
{
	"ambient/halloween/thunder_04.wav", 
	"ambient/halloween/thunder_05.wav", 
	"ambient/halloween/thunder_08.wav", 
	"ambient/halloween/mysterious_perc_09.wav", 
	"ambient/halloween/mysterious_perc_09.wav", 
	"ambient/halloween/windgust_08.wav"
};

static const char g_sPageCollectDuckSounds[][] = 
{
	"ambient/bumper_car_quack1.wav", 
	"ambient/bumper_car_quack2.wav", 
	"ambient/bumper_car_quack3.wav", 
	"ambient/bumper_car_quack4.wav", 
	"ambient/bumper_car_quack5.wav", 
	"ambient/bumper_car_quack9.wav", 
	"ambient/bumper_car_quack11.wav"
};

//Update
bool g_bSeeUpdateMenu[MAXPLAYERS + 1] = false;
//Command
bool g_bPlayerNoPoints[MAXPLAYERS + 1] = false;
bool g_bAdminNoPoints[MAXPLAYERS + 1] = false;
bool g_bAdminAllTalk[MAXPLAYERS + 1] = false;

// Offsets.
int g_offsPlayerFOV = -1;
int g_offsPlayerDefaultFOV = -1;
int g_offsPlayerFogCtrl = -1;
int g_offsPlayerPunchAngle = -1;
int g_offsPlayerPunchAngleVel = -1;
int g_offsFogCtrlEnable = -1;
int g_offsFogCtrlEnd = -1;
int g_offsCollisionGroup = -1;

//Commands
float g_flLastCommandTime[MAXPLAYERS + 1];

bool g_bEnabled;

KeyValues g_hConfig;
KeyValues g_hRestrictedWeaponsConfig;
KeyValues g_hSpecialRoundsConfig;

ArrayList g_hPageMusicRanges;
int g_iPageMusicActiveIndex[MAXPLAYERS + 1] = { -1, ... };

int g_iSlenderModel[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_iSlenderPoseEnt[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_iSlenderCopyMaster[MAX_BOSSES] = { -1, ... };
int g_iSlenderMaxCopies[MAX_BOSSES][Difficulty_Max];
int g_iSlenderCompanionMaster[MAX_BOSSES] = { -1, ... };
float g_flSlenderEyePosOffset[MAX_BOSSES][3];
float g_flSlenderEyeAngOffset[MAX_BOSSES][3];
float g_flSlenderDetectMins[MAX_BOSSES][3];
float g_flSlenderDetectMaxs[MAX_BOSSES][3];
int g_iSlenderRenderColor[MAX_BOSSES][4];
int g_iSlenderRenderFX[MAX_BOSSES];
int g_iSlenderRenderMode[MAX_BOSSES];
Handle g_hSlenderThink[MAX_BOSSES];
Handle g_hSlenderEntityThink[MAX_BOSSES];
Handle g_hSlenderFakeTimer[MAX_BOSSES];
Handle g_hSlenderDeathCamTimer[MAX_BOSSES];
int g_iSlenderDeathCamTarget[MAX_BOSSES];
float g_flSlenderLastKill[MAX_BOSSES];
int g_iSlenderState[MAX_BOSSES];
int g_iSlenderHitbox[MAX_BOSSES];
int g_iSlenderHitboxOwner[2049] = { INVALID_ENT_REFERENCE, ... };
int g_iSlenderTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
bool g_bSlenderTargetIsVisible[MAX_BOSSES] = false;
bool g_bSlenderSpawning[MAX_BOSSES] = false;
float g_flSlenderAcceleration[MAX_BOSSES][Difficulty_Max];
float g_flSlenderGoalPos[MAX_BOSSES][3];
float g_flSlenderStaticRadius[MAX_BOSSES][Difficulty_Max];
float g_flSlenderStaticRate[MAX_BOSSES][Difficulty_Max];
float g_flSlenderStaticRateDecay[MAX_BOSSES][Difficulty_Max];
float g_flSlenderStaticGraceTime[MAX_BOSSES][Difficulty_Max];
float g_flSlenderChaseDeathPosition[MAX_BOSSES][3];
bool g_bSlenderChaseDeathPosition[MAX_BOSSES];

bool g_bSlenderDeathCamScareSound[MAX_BOSSES];
bool g_bSlenderPublicDeathCam[MAX_BOSSES];
float g_flSlenderPublicDeathCamSpeed[MAX_BOSSES];
float g_flSlenderPublicDeathCamAcceleration[MAX_BOSSES];
float g_flSlenderPublicDeathCamDeceleration[MAX_BOSSES];
float g_flSlenderPublicDeathCamBackwardOffset[MAX_BOSSES];
float g_flSlenderPublicDeathCamDownwardOffset[MAX_BOSSES];
bool g_bSlenderDeathCamOverlay[MAX_BOSSES];
float g_flSlenderDeathCamOverlayTimeStart[MAX_BOSSES];
float g_flSlenderDeathCamTime[MAX_BOSSES];

//The Gaben's stuff
bool g_bSlenderHasBurnKillEffect[MAX_BOSSES];
bool g_bSlenderHasCloakKillEffect[MAX_BOSSES];
bool g_bSlenderHasDecapKillEffect[MAX_BOSSES];
bool g_bSlenderHasGibKillEffect[MAX_BOSSES];
bool g_bSlenderHasGoldKillEffect[MAX_BOSSES];
bool g_bSlenderHasIceKillEffect[MAX_BOSSES];
bool g_bSlenderHasElectrocuteKillEffect[MAX_BOSSES];
bool g_bSlenderHasAshKillEffect[MAX_BOSSES];
bool g_bSlenderHasDeleteKillEffect[MAX_BOSSES];
bool g_bSlenderHasPushRagdollOnKill[MAX_BOSSES];
bool g_bSlenderHasDissolveRagdollOnKill[MAX_BOSSES];
int g_iSlenderDissolveRagdollType[MAX_BOSSES];
bool g_bSlenderHasPlasmaRagdollOnKill[MAX_BOSSES];
bool g_bSlenderHasResizeRagdollOnKill[MAX_BOSSES];
float g_flSlenderResizeRagdollHands[MAX_BOSSES];
float g_flSlenderResizeRagdollHead[MAX_BOSSES];
float g_flSlenderResizeRagdollTorso[MAX_BOSSES];
bool g_bSlenderCustomOutroSong[MAX_BOSSES];
bool g_bSlenderHasDecapOrGibKillEffect[MAX_BOSSES];
bool g_bSlenderHasSilentKill[MAX_BOSSES];
bool g_bSlenderHasMultiKillEffect[MAX_BOSSES];
bool g_bSlenderPlayerCustomDeathFlag[MAX_BOSSES];
int g_iSlenderPlayerSetDeathFlag[MAX_BOSSES];

bool g_bSlenderUseCustomOutlines[MAX_BOSSES];
int g_iSlenderOutlineColorR[MAX_BOSSES];
int g_iSlenderOutlineColorG[MAX_BOSSES];
int g_iSlenderOutlineColorB[MAX_BOSSES];
int g_iSlenderOutlineTransparency[MAX_BOSSES];
bool g_bSlenderUseRainbowOutline[MAX_BOSSES];
float g_flSlenderRainbowCycleRate[MAX_BOSSES];

int g_iProjectileFlags[2049] = { 0, ... };
bool g_bGrenadeTouchGround[2049];
int g_iTrapEntityCount;
float g_flRoundTimeMessage = 0.0;

char g_sSlenderCloakOnSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderCloakOffSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderJarateHitSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderMilkHitSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderGasHitSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderStunHitSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderFireballExplodeSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderFireballShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderIceballImpactSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderRocketExplodeSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderRocketShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderRocketModel[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderRocketTrailParticle[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderRocketExplodeParticle[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderGrenadeShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderSentryRocketShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderArrowShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderManglerShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderBaseballShootSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderEngineSound[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderShockwaveBeamSprite[MAX_BOSSES][PLATFORM_MAX_PATH];
char g_sSlenderShockwaveHaloSprite[MAX_BOSSES][PLATFORM_MAX_PATH];

int g_iSlenderTeleportTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_iSlenderProxyTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
bool g_bSlenderTeleportTargetIsCamping[MAX_BOSSES] = false;

float g_flSlenderNextTeleportTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTeleportTargetTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTeleportMinRange[MAX_BOSSES][Difficulty_Max];
float g_flSlenderTeleportMaxRange[MAX_BOSSES][Difficulty_Max];
float g_flSlenderTeleportMaxTargetTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTeleportMaxTargetStress[MAX_BOSSES] = { 0.0, ... };
float g_flSlenderTeleportPlayersRestTime[MAX_BOSSES][MAXPLAYERS + 1];
bool g_bSlenderTeleportIgnoreChases[MAX_BOSSES];

bool g_bSlenderInDeathcam[MAX_BOSSES] = false;

bool g_bSlenderProxiesAllowNormalVoices[MAX_BOSSES];

int g_iSlenderBoxingBossCount = 0;
int g_iSlenderBoxingBossKilled = 0;
bool g_bSlenderBoxingBossIsKilled[MAX_BOSSES] = false;

//The global timer replacing OnGameFrame()
Handle g_hOnGameFrameTimer = null;

// For boss type 2
// General variables
PathFollower g_pPath[MAX_BOSSES];
bool g_bSlenderAttacking[MAX_BOSSES];
bool g_bSlenderGiveUp[MAX_BOSSES];
Handle g_hSlenderAttackTimer[MAX_BOSSES];
Handle g_hSlenderLaserTimer[MAX_BOSSES];
Handle g_hSlenderBackupAtkTimer[MAX_BOSSES];
Handle g_hSlenderChaseInitialTimer[MAX_BOSSES];
Handle g_hSlenderRage1Timer[MAX_BOSSES];
Handle g_hSlenderRage2Timer[MAX_BOSSES];
Handle g_hSlenderRage3Timer[MAX_BOSSES];
Handle g_hSlenderSpawnTimer[MAX_BOSSES];
Handle g_hSlenderHealTimer[MAX_BOSSES];
Handle g_hSlenderHealDelayTimer[MAX_BOSSES];
Handle g_hSlenderHealEventTimer[MAX_BOSSES];
Handle g_hSlenderStartFleeTimer[MAX_BOSSES];

int g_iSlenderInterruptConditions[MAX_BOSSES];
float g_flSlenderLastFoundPlayer[MAX_BOSSES][MAXPLAYERS + 1];
float g_flSlenderLastFoundPlayerPos[MAX_BOSSES][MAXPLAYERS + 1][3];
float g_flSlenderNextPathTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderLastCalculPathTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderCalculatedWalkSpeed[MAX_BOSSES];
float g_flSlenderCalculatedSpeed[MAX_BOSSES];
float g_flSlenderCalculatedAcceleration[MAX_BOSSES];
float g_flSlenderCalculatedMaxWalkSpeed[MAX_BOSSES];
float g_flSlenderCalculatedMaxSpeed[MAX_BOSSES];
float g_flSlenderSpeedMultiplier[MAX_BOSSES];
float g_flSlenderTimeUntilNoPersistence[MAX_BOSSES];

float g_flSlenderProxyTeleportMinRange[MAX_BOSSES][Difficulty_Max];
float g_flSlenderProxyTeleportMaxRange[MAX_BOSSES][Difficulty_Max];

// Sound variables
float g_flSlenderTargetSoundLastTime[MAX_BOSSES] = { -1.0, ... };
SoundType g_iSlenderTargetSoundType[MAX_BOSSES] = { SoundType_None, ... };
float g_flSlenderTargetSoundMasterPos[MAX_BOSSES][3]; // to determine hearing focus
float g_flSlenderTargetSoundTempPos[MAX_BOSSES][3];
float g_flSlenderTargetSoundDiscardMasterPosTime[MAX_BOSSES];
bool g_bSlenderInvestigatingSound[MAX_BOSSES];
int g_iSlenderTargetSoundCount[MAX_BOSSES];
int g_iSlenderAutoChaseCount[MAX_BOSSES];
float g_flSlenderAutoChaseCooldown[MAX_BOSSES];
int g_iSlenderSoundTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_iSlenderSeeTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
bool g_bAutoChasingLoudPlayer[MAX_BOSSES];
float g_flSlenderLastHeardVoice[MAX_BOSSES];
float g_flSlenderLastHeardFootstep[MAX_BOSSES];
float g_flSlenderLastHeardWeapon[MAX_BOSSES];

float g_flSlenderNextStunTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextJumpScare[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextVoiceSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextMoanSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextWanderPos[MAX_BOSSES][Difficulty_Max];
float g_flSlenderNextCloakTime[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextTrapPlacement[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextFootstepIdleSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextFootstepWalkSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextFootstepRunSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextFootstepStunSound[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderNextFootstepAttackSound[MAX_BOSSES] = { -1.0, ... };

float g_flSlenderIdleFootstepTime[MAX_BOSSES];
float g_flSlenderWalkFootstepTime[MAX_BOSSES];
float g_flSlenderRunFootstepTime[MAX_BOSSES];
float g_flSlenderStunFootstepTime[MAX_BOSSES];
float g_flSlenderAttackFootstepTime[MAX_BOSSES];

float g_flSlenderTimeUntilRecover[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilAlert[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilIdle[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilChase[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilKill[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilNextProxy[MAX_BOSSES] = { -1.0, ... };
float g_flSlenderTimeUntilAttackEnd[MAX_BOSSES] = { -1.0, ... };

float g_flSlenderProxyDamageVsEnemy[MAX_BOSSES][Difficulty_Max];
float g_flSlenderProxyDamageVsBackstab[MAX_BOSSES][Difficulty_Max];
float g_flSlenderProxyDamageVsSelf[MAX_BOSSES][Difficulty_Max];
int g_iSlenderProxyControlGainHitEnemy[MAX_BOSSES][Difficulty_Max];
int g_iSlenderProxyControlGainHitByEnemy[MAX_BOSSES][Difficulty_Max];
float g_flSlenderProxyControlDrainRate[MAX_BOSSES][Difficulty_Max];
int g_iSlenderMaxProxies[MAX_BOSSES][Difficulty_Max];

int g_iSlenderProxyHurtChannel[MAX_BOSSES];
int g_iSlenderProxyHurtLevel[MAX_BOSSES];
int g_iSlenderProxyHurtFlags[MAX_BOSSES];
float g_flSlenderProxyHurtVolume[MAX_BOSSES];
int g_iSlenderProxyHurtPitch[MAX_BOSSES];
int g_iSlenderProxyDeathChannel[MAX_BOSSES];
int g_iSlenderProxyDeathLevel[MAX_BOSSES];
int g_iSlenderProxyDeathFlags[MAX_BOSSES];
float g_flSlenderProxyDeathVolume[MAX_BOSSES];
int g_iSlenderProxyDeathPitch[MAX_BOSSES];
int g_iSlenderProxyIdleChannel[MAX_BOSSES];
int g_iSlenderProxyIdleLevel[MAX_BOSSES];
int g_iSlenderProxyIdleFlags[MAX_BOSSES];
float g_flSlenderProxyIdleVolume[MAX_BOSSES];
int g_iSlenderProxyIdlePitch[MAX_BOSSES];
float g_flSlenderProxyIdleCooldownMin[MAX_BOSSES];
float g_flSlenderProxyIdleCooldownMax[MAX_BOSSES];
int g_iSlenderProxySpawnChannel[MAX_BOSSES];
int g_iSlenderProxySpawnLevel[MAX_BOSSES];
int g_iSlenderProxySpawnFlags[MAX_BOSSES];
float g_flSlenderProxySpawnVolume[MAX_BOSSES];
int g_iSlenderProxySpawnPitch[MAX_BOSSES];

bool g_bSlenderInBacon[MAX_BOSSES];

bool g_bSlenderDifficultyAnimations[MAX_BOSSES];

int g_iNightvisionType = 0;

//Healthbar
int g_ihealthBar;

// Page data.
enum struct SF2PageEntityData
{
	int EntRef;
	char CollectSound[PLATFORM_MAX_PATH];
	int CollectSoundPitch;
}

ArrayList g_hPages;
int g_iPageCount;
int g_iPageMax;
float g_flPageFoundLastTime;
bool g_bPageRef;
char g_strPageRefModel[PLATFORM_MAX_PATH];
float g_flPageRefModelScale;

static Handle g_hPlayerIntroMusicTimer[MAXPLAYERS + 1] = { null, ... };

// Seeing Mr. Slendy data.

float g_flLastVisibilityProcess[MAXPLAYERS + 1];
bool g_bPlayerSeesSlender[MAXPLAYERS + 1][MAX_BOSSES];
float g_flPlayerSeesSlenderLastTime[MAXPLAYERS + 1][MAX_BOSSES];

float g_flPlayerSightSoundNextTime[MAXPLAYERS + 1][MAX_BOSSES];

float g_flPlayerScareLastTime[MAXPLAYERS + 1][MAX_BOSSES];
float g_flPlayerScareNextTime[MAXPLAYERS + 1][MAX_BOSSES];
float g_flPlayerStaticAmount[MAXPLAYERS + 1];

int g_iNPCPlayerScareVictin[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
bool g_bNPCChasingScareVictin[MAX_BOSSES];
bool g_bNPCLostChasingScareVictim[MAX_BOSSES];
bool g_bPlayerScaredByBoss[MAXPLAYERS + 1][MAX_BOSSES];

bool g_bNPCVelocityCancel[MAX_BOSSES];

//Boxing data
Handle g_hSlenderBurnTimer[MAX_BOSSES];
Handle g_hSlenderBleedTimer[MAX_BOSSES];
Handle g_hSlenderMarkedTimer[MAX_BOSSES];
float g_flSlenderStopBurning[MAX_BOSSES];
float g_flSlenderStopBleeding[MAX_BOSSES];
bool g_bSlenderIsBurning[MAX_BOSSES]; //This is for the Sun-on-a-Stick
bool g_bSlenderIsMarked[MAX_BOSSES]; //For mini-crits and Bushwacka
int g_iPlayerHitsToCrits[MAXPLAYERS + 1];
int g_iPlayerHitsToHeads[MAXPLAYERS + 1];

static bool g_bPlayersAreCritted = false;
static bool g_bPlayersAreMiniCritted = false;

bool g_bPlayerIn1UpCondition[MAXPLAYERS + 1];
bool g_bPlayerDied1Up[MAXPLAYERS + 1];
bool g_bPlayerFullyDied1Up[MAXPLAYERS + 1];

float g_flPlayerLastChaseBossEncounterTime[MAXPLAYERS + 1][MAX_BOSSES];

// Player static data.
int g_iPlayerStaticMode[MAXPLAYERS + 1][MAX_BOSSES];
float g_flPlayerStaticIncreaseRate[MAXPLAYERS + 1];
float g_flPlayerStaticDecreaseRate[MAXPLAYERS + 1];
Handle g_hPlayerStaticTimer[MAXPLAYERS + 1];
int g_iPlayerStaticMaster[MAXPLAYERS + 1] = { -1, ... };
char g_strPlayerStaticSound[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_strPlayerLastStaticSound[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayerLastStaticTime[MAXPLAYERS + 1];
float g_flPlayerLastStaticVolume[MAXPLAYERS + 1];
Handle g_hPlayerLastStaticTimer[MAXPLAYERS + 1];

// Static shake data.
int g_iPlayerStaticShakeMaster[MAXPLAYERS + 1];
bool g_bPlayerInStaticShake[MAXPLAYERS + 1];
char g_strPlayerStaticShakeSound[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayerStaticShakeMinVolume[MAXPLAYERS + 1];
float g_flPlayerStaticShakeMaxVolume[MAXPLAYERS + 1];

float g_flPlayerProxyNextVoiceSound[MAXPLAYERS + 1];

bool g_bPlayerTrapped[MAXPLAYERS + 1];
int g_iPlayerTrapCount[MAXPLAYERS + 1];

int g_iPlayerBossKillSubject[MAXPLAYERS + 1];

// Difficulty
bool g_bPlayerCalledForNightmare[MAXPLAYERS + 1];
bool g_bProxySurvivalRageMode = false;

int g_iPlayerRandomClassNumber[MAXPLAYERS + 1];

// Hint data.
enum
{
	PlayerHint_Sprint = 0, 
	PlayerHint_Flashlight, 
	PlayerHint_MainMenu, 
	PlayerHint_Blink, 
	PlayerHint_Trap, 
	PlayerHint_MaxNum
};

enum struct PlayerPreferences
{
	bool PlayerPreference_PvPAutoSpawn;
	bool PlayerPreference_FilmGrain;
	bool PlayerPreference_ShowHints;
	bool PlayerPreference_EnableProxySelection;
	bool PlayerPreference_ProxyShowMessage;
	bool PlayerPreference_ProjectedFlashlight;
	bool PlayerPreference_ViewBobbing;
	bool PlayerPreference_GroupOutline;
	bool PlayerPreference_PvPSpawnProtection;
	
	int PlayerPreference_MuteMode; //0 = Normal, 1 = Opposing Team, 2 = Opposing Team Proxy Ignore
	int PlayerPreference_FlashlightTemperature; //1 = 1000, 2 = 2000, 3 = 3000, 4 = 4000, 5 = 5000, 6 = 6000, 7 = 7000, 8 = 8000, 9 = 9000, 10 = 10000
	int PlayerPreference_GhostModeToggleState; //0 = Nothing, 1 = Ghost on grace end, 2 = Ghost on death
	int PlayerPreference_GhostModeTeleportState; //0 = Players, 1 = Bosses
	
}

bool g_bPlayerHints[MAXPLAYERS + 1][PlayerHint_MaxNum];
PlayerPreferences g_iPlayerPreferences[MAXPLAYERS + 1];

//Particle data.
enum
{
	CriticalHit = 0, 
	MiniCritHit, 
	ZapParticle, 
	FireworksRED, 
	FireworksBLU, 
	TeleportedInBlu, 
	MaxParticle
};

int g_iParticle[MaxParticle] = -1;

// Player data.
bool g_bPlayerIsExitCamping[MAXPLAYERS + 1];
int g_iPlayerLastButtons[MAXPLAYERS + 1];
bool g_bPlayerChoseTeam[MAXPLAYERS + 1];
bool g_bPlayerEliminated[MAXPLAYERS + 1];
bool g_bPlayerHasRegenerationItem[MAXPLAYERS + 1];
bool g_bPlayerEscaped[MAXPLAYERS + 1];
int g_iPlayerPageCount[MAXPLAYERS + 1];
int g_iPlayerQueuePoints[MAXPLAYERS + 1];
bool g_bPlayerPlaying[MAXPLAYERS + 1];
bool g_bBackStabbed[MAXPLAYERS + 1];
Handle g_hPlayerOverlayCheck[MAXPLAYERS + 1];

Handle g_hPlayerSwitchBlueTimer[MAXPLAYERS + 1];

// Player stress data.
float g_flPlayerStress[MAXPLAYERS + 1];
float g_flPlayerStressNextUpdateTime[MAXPLAYERS + 1];

// Proxy data.
bool g_bPlayerProxy[MAXPLAYERS + 1];
bool g_bPlayerProxyAvailable[MAXPLAYERS + 1];
Handle g_hPlayerProxyAvailableTimer[MAXPLAYERS + 1];
bool g_bPlayerProxyAvailableInForce[MAXPLAYERS + 1];
int g_iPlayerProxyAvailableCount[MAXPLAYERS + 1];
int g_iPlayerProxyMaster[MAXPLAYERS + 1];
int g_iPlayerProxyControl[MAXPLAYERS + 1];
Handle g_hPlayerProxyControlTimer[MAXPLAYERS + 1];
float g_flPlayerProxyControlRate[MAXPLAYERS + 1];
Handle g_flPlayerProxyVoiceTimer[MAXPLAYERS + 1];
int g_iPlayerProxyAskMaster[MAXPLAYERS + 1] = { -1, ... };
float g_iPlayerProxyAskPosition[MAXPLAYERS + 1][3];
int g_iPlayerProxyAskSpawnPoint[MAXPLAYERS + 1] = { -1, ... };

int g_iPlayerDesiredFOV[MAXPLAYERS + 1];

Handle g_hPlayerPostWeaponsTimer[MAXPLAYERS + 1] = { null, ... };
Handle g_hPlayerIgniteTimer[MAXPLAYERS + 1] = { null, ... };
Handle g_hPlayerResetIgnite[MAXPLAYERS + 1] = { null, ... };
Handle g_hPlayerPageRewardTimer[MAXPLAYERS + 1] = { null, ... };
Handle g_hPlayerPageRewardCycleTimer[MAXPLAYERS + 1] = { null, ... };
Handle g_hPlayerFireworkTimer[MAXPLAYERS + 1] = { null, ... };

bool g_bPlayerGettingPageReward[MAXPLAYERS + 1] = false;

// Music system.
int g_iPlayerMusicFlags[MAXPLAYERS + 1];
char g_strPlayerMusic[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayerMusicVolume[MAXPLAYERS + 1];
float g_flPlayerMusicTargetVolume[MAXPLAYERS + 1];
Handle g_hPlayerMusicTimer[MAXPLAYERS + 1];
int g_iPlayerPageMusicMaster[MAXPLAYERS + 1];

// Chase music system, which apparently also uses the alert song system. And the idle sound system.
char g_strPlayerChaseMusic[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
char g_strPlayerChaseMusicSee[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayerChaseMusicVolumes[MAXPLAYERS + 1][MAX_BOSSES];
float g_flPlayerChaseMusicSeeVolumes[MAXPLAYERS + 1][MAX_BOSSES];
Handle g_hPlayerChaseMusicTimer[MAXPLAYERS + 1][MAX_BOSSES];
Handle g_hPlayerChaseMusicSeeTimer[MAXPLAYERS + 1][MAX_BOSSES];
int g_iPlayerChaseMusicMaster[MAXPLAYERS + 1] = { -1, ... };
int g_iPlayerChaseMusicSeeMaster[MAXPLAYERS + 1] = { -1, ... };

char g_strPlayerAlertMusic[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayerAlertMusicVolumes[MAXPLAYERS + 1][MAX_BOSSES];
Handle g_hPlayerAlertMusicTimer[MAXPLAYERS + 1][MAX_BOSSES];
int g_iPlayerAlertMusicMaster[MAXPLAYERS + 1] = { -1, ... };


char g_strPlayer20DollarsMusic[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayer20DollarsMusicVolumes[MAXPLAYERS + 1][MAX_BOSSES];
Handle g_hPlayer20DollarsMusicTimer[MAXPLAYERS + 1][MAX_BOSSES];
int g_iPlayer20DollarsMusicMaster[MAXPLAYERS + 1] = { -1, ... };


char g_strPlayer90sMusic[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
float g_flPlayer90sMusicVolumes[MAXPLAYERS + 1];
Handle g_hPlayer90sMusicTimer[MAXPLAYERS + 1];


SF2RoundState g_iRoundState = SF2RoundState_Invalid;
float g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
bool g_bRoundInfiniteFlashlight = false;
bool g_bIsSurvivalMap = false;
bool g_bIsRaidMap = false;
bool g_bIsProxyMap = false;
bool g_bBossesChaseEndlessly = false;
bool g_bIsBoxingMap = false;
bool g_bIsSlaughterRunMap = false;
bool g_bRoundInfiniteBlink = false;
bool g_bRoundInfiniteSprint = false;

Handle g_hRoundGraceTimer = null;
static Handle g_hRoundTimer = null;
static Handle g_hVoteTimer = null;
static char g_strRoundBossProfile[SF2_MAX_PROFILE_NAME_LENGTH];
static char g_strRoundBoxingBossProfile[SF2_MAX_PROFILE_NAME_LENGTH];

static int g_iRoundCount = 0;
static int g_iRoundEndCount = 0;
static int g_iRoundActiveCount = 0;
int g_iRoundTime = 0;
int g_iSpecialRoundTime = 0;
int g_iTimeEscape = 0;
int g_iRoundTimeLimit = 0;
int g_iRoundEscapeTimeLimit = 0;
int g_iRoundTimeGainFromPage = 0;
bool g_bRoundHasEscapeObjective = false;
bool g_bRoundStopPageMusicOnEscape = false;

static int g_iRoundEscapePointEntity = INVALID_ENT_REFERENCE;

static int g_iRoundIntroFadeColor[4] = { 255, ... };
static float g_flRoundIntroFadeHoldTime;
static float g_flRoundIntroFadeDuration;
static Handle g_hRoundIntroTimer = null;
static bool g_bRoundIntroTextDefault = true;
static Handle g_hRoundIntroTextTimer = null;
static int g_iRoundIntroText;
char g_strRoundIntroMusic[PLATFORM_MAX_PATH] = "";
static char g_strPageCollectSound[PLATFORM_MAX_PATH] = "";
static int g_iPageSoundPitch = 100;
char sCurrentMusicTrack[PLATFORM_MAX_PATH], sCurrentMusicTrackNormal[PLATFORM_MAX_PATH], sCurrentMusicTrackHard[PLATFORM_MAX_PATH], sCurrentMusicTrackInsane[PLATFORM_MAX_PATH], sCurrentMusicTrackNightmare[PLATFORM_MAX_PATH], sCurrentMusicTrackApollyon[PLATFORM_MAX_PATH];

static int g_iRoundWarmupRoundCount = 0;

static bool g_bRoundWaitingForPlayers = false;

// Special round variables.
bool g_bSpecialRound = false;

bool g_bSpecialRoundNew = false;
bool g_bSpecialRoundContinuous = false;
int g_iSpecialRoundCount = 1;
bool g_bPlayerPlayedSpecialRound[MAXPLAYERS + 1] = { true, ... };

// int boss round variables.
static bool g_bNewBossRound = false;
static bool g_bNewBossRoundNew = false;
static bool g_bNewBossRoundContinuous = false;
static int g_iNewBossRoundCount = 1;

static bool g_bPlayerPlayedNewBossRound[MAXPLAYERS + 1] = { true, ... };
static char g_strNewBossRoundProfile[64] = "";

static Handle g_hRoundMessagesTimer = null;
static int g_iRoundMessagesNum = 0;

static Handle g_hBossCountUpdateTimer = null;
static Handle g_hClientAverageUpdateTimer = null;
static Handle g_hBlueNightvisionOutlineTimer = null;

// Server variables.
ConVar g_cvVersion;
ConVar g_cvEnabled;
ConVar g_cvSlenderMapsOnly;
ConVar g_cvPlayerViewbobEnabled;
ConVar g_cvPlayerShakeEnabled;
ConVar g_cvPlayerShakeFrequencyMax;
ConVar g_cvPlayerShakeAmplitudeMax;
ConVar g_cvGraceTime;
ConVar g_cvAllChat;
ConVar g_cv20Dollars;
ConVar g_cvMaxPlayers;
ConVar g_cvMaxPlayersOverride;
ConVar g_cvCampingEnabled;
ConVar g_cvCampingMaxStrikes;
ConVar g_cvCampingStrikesWarn;
ConVar g_cvExitCampingTimeAllowed;
ConVar g_cvCampingMinDistance;
ConVar g_cvCampingNoStrikeSanity;
ConVar g_cvCampingNoStrikeBossDistance;
ConVar g_cvDifficulty;
ConVar g_cvCameraOverlay;
ConVar g_cvOverlayNoGrain;
ConVar g_cvGhostOverlay;
ConVar g_cvBossMain;
ConVar g_cvBossProfileOverride;
ConVar g_cvPlayerBlinkRate;
ConVar g_cvPlayerBlinkHoldTime;
ConVar g_cvSpecialRoundBehavior;
ConVar g_cvSpecialRoundForce;
ConVar g_cvSpecialRoundOverride;
ConVar g_cvSpecialRoundInterval;
ConVar g_cvNewBossRoundBehavior;
ConVar g_cvNewBossRoundInterval;
ConVar g_cvNewBossRoundForce;
ConVar g_cvIgnoreRoundWinConditions;
ConVar g_cvDisableBossCrushFix;
ConVar g_cvEnableWallHax;
ConVar g_cvIgnoreRedPlayerDeathSwap;
ConVar g_cvPlayerVoiceDistance;
ConVar g_cvPlayerVoiceWallScale;
ConVar g_cvUltravisionEnabled;
ConVar g_cvUltravisionRadiusRed;
ConVar g_cvUltravisionRadiusBlue;
ConVar g_cvUltravisionBrightness;
ConVar g_cvNightvisionRadius;
ConVar g_cvNightvisionEnabled;
ConVar g_cvGhostModeConnection;
ConVar g_cvGhostModeConnectionCheck;
ConVar g_cvGhostModeConnectionTolerance;
ConVar g_cvIntroEnabled;
ConVar g_cvIntroDefaultHoldTime;
ConVar g_cvIntroDefaultFadeTime;
ConVar g_cvTimeLimit;
ConVar g_cvTimeLimitEscape;
ConVar g_cvTimeGainFromPageGrab;
ConVar g_cvWarmupRound;
ConVar g_cvWarmupRoundNum;
ConVar g_cvPlayerViewbobHurtEnabled;
ConVar g_cvPlayerViewbobSprintEnabled;
ConVar g_cvPlayerProxyWaitTime;
ConVar g_cvPlayerProxyAsk;
ConVar g_cvPlayerAFKTime;
ConVar g_cvBlockSuicideDuringRound;
ConVar g_cvRaidMap;
ConVar g_cvProxyMap;
ConVar g_cvBossChaseEndlessly;
ConVar g_cvSurvivalMap;
ConVar g_cvBoxingMap;
ConVar g_cvRenevantMap;
ConVar g_cvDefaultRenevantBoss;
ConVar g_cvDefaultRenevantBossMessage;
ConVar g_cvSlaughterRunMap;
ConVar g_cvTimeEscapeSurvival;
ConVar g_cvSlaughterRunDivisibleTime;
ConVar g_cvUseAlternateConfigDirectory;
ConVar g_cvPlayerKeepWeapons;
ConVar g_cvFullyEnableSpectator;

ConVar g_cvRestartSession;
bool g_bRestartSessionEnabled;

ConVar g_cvPlayerInfiniteSprintOverride;
ConVar g_cvPlayerInfiniteFlashlightOverride;
ConVar g_cvPlayerInfiniteBlinkOverride;

ConVar g_cvGravity;
float g_flGravity;

ConVar g_cvMaxRounds;

bool g_b20Dollars;

bool g_bPlayerShakeEnabled;
bool g_bPlayerViewbobHurtEnabled;
bool g_bPlayerViewbobSprintEnabled;

Handle g_hHudSync;
Handle g_hHudSync2;
Handle g_hHudSync3;
Handle g_hRoundTimerSync;

Handle g_hCookie;

int g_SmokeSprite;
int g_LightningSprite;
int g_ShockwaveBeam;
int g_ShockwaveHalo;

// Global forwards.
Handle fOnBossAdded;
Handle fOnBossSpawn;
Handle fOnBossDespawn;
Handle fOnBossChangeState;
Handle fOnBossAnimationUpdate;
Handle fOnBossGetSpeed;
Handle fOnBossGetWalkSpeed;
Handle fOnBossSeeEntity;
Handle fOnBossHearEntity;
Handle fOnBossRemoved;
Handle fOnBossStunned;
Handle fOnBossCloaked;
Handle fOnBossDecloaked;
Handle fOnPagesSpawned;
Handle fOnRoundStateChange;
Handle fOnClientCollectPage;
Handle fOnClientBlink;
Handle fOnClientScare;
Handle fOnClientCaughtByBoss;
Handle fOnClientGiveQueuePoints;
Handle fOnClientActivateFlashlight;
Handle fOnClientDeactivateFlashlight;
Handle fOnClientBreakFlashlight;
Handle fOnClientStartSprinting;
Handle fOnClientStopSprinting;
Handle fOnClientEscape;
Handle fOnClientLooksAtBoss;
Handle fOnClientLooksAwayFromBoss;
Handle fOnClientStartDeathCam;
Handle fOnClientEndDeathCam;
Handle fOnClientGetDefaultWalkSpeed;
Handle fOnClientGetDefaultSprintSpeed;
Handle fOnClientTakeDamage;
Handle fOnClientSpawnedAsProxy;
Handle fOnClientDamagedByBoss;
Handle fOnGroupGiveQueuePoints;
Handle fOnRenevantTriggerWave;
Handle fOnBossPackVoteStart;
Handle fOnDifficultyChange;

Handle g_hSDKGetMaxHealth;
Handle g_hSDKGetLastKnownArea;
Handle g_hSDKUpdateLastKnownArea;
Handle g_hSDKWantsLagCompensationOnEntity;
Handle g_hSDKShouldTransmit;
DynamicHook g_hSDKUpdateTransmitState;
Handle g_hShouldCollide;
Handle g_hSDKGetLocomotionInterface;
Handle g_hSDKGetNextBot;
Handle g_hSDKEquipWearable;
Handle g_hSDKPlaySpecificSequence;
Handle g_hSDKPointIsWithin;
Handle g_hSDKPassesTriggerFilters;
Handle g_hSDKGetSmoothedVelocity;
Handle g_hSDKGetVectors;
Handle g_hSDKResetSequence;
Handle g_hSDKStartTouch;
Handle g_hSDKEndTouch;
Handle g_hSDKWeaponSwitch;
Handle g_hSDKWeaponGetCustomDamageType;
Handle g_hSDKProjectileCanCollideWithTeammates;

// SourceTV userid used for boss name
int g_iSourceTVUserID = -1;
char g_sOldSourceTVClientName[64];
Handle g_hTimerChangeSourceTVBotName = null;

//Fail Timer
Handle g_hTimerFail = null;

//Renevant
int g_iRenevantWaveNumber = 0;
int g_iRenevantFinaleTime = 0;
bool g_bRenevantMultiEffect = false;
bool g_bRenevantBeaconEffect = false;
bool g_bRenevant90sEffect = false;
bool g_bRenevantMarkForDeath = false;
bool g_bIsRenevantMap = false;
Handle g_hRenevantWaveTimer = null;
ArrayList g_aRenevantWaveList;

#if defined DEBUG
#include "sf2/debug.sp"
#endif
#include "sf2/stocks.sp"
#include "sf2/logging.sp"
#include "sf2/profiles.sp"
//#include "sf2/nav.sp"
#include "sf2/effects.sp"
#include "sf2/playergroups.sp"
#include "sf2/mapentities.sp"
#include "sf2/menus.sp"
#include "sf2/tutorial.sp"
#include "sf2/npc.sp"
#include "sf2/pvp.sp"
#include "sf2/client.sp"
#include "sf2/specialround.sp"
#include "sf2/adminmenu.sp"
#include "sf2/traps.sp"
#include "sf2/extras/renevant_mode.sp"
#include "sf2/extras/natives.sp"
#include "sf2/extras/commands.sp"
#include "sf2/extras/afk_mode.sp"

#define SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND "ui/item_acquired.wav"

SF2LogicRenevantEntity g_RenevantLogicEntity = view_as<SF2LogicRenevantEntity>(-1);

public void OnAllPluginsLoaded()
{
	SDK_Init();
}

public void OnPluginEnd()
{
	StopPlugin();
}
public void OnLibraryAdded(const char[] name)
{
	
	if (!strcmp(name, "SteamTools", false))
	{
		steamtools = true;
	}
	
	if (!strcmp(name, "SteamWorks", false))
	{
		steamworks = true;
	}
	
}
public void OnLibraryRemoved(const char[] name)
{
	
	if (!strcmp(name, "SteamTools", false))
	{
		steamtools = false;
	}
	
	if (!strcmp(name, "SteamWorks", false))
	{
		steamworks = false;
	}
	
}

public void OnMapStart()
{
	g_hTimerFail = null;
	PvP_OnMapStart();
	FindHealthBar();
	PrecacheSound(SOUND_THUNDER, true);
	PrecacheSound("weapons/teleporter_send.wav");
	g_SmokeSprite = PrecacheModel("sprites/steam1.vmt");
	g_LightningSprite = PrecacheModel("sprites/lgtning.vmt");
	g_ShockwaveBeam = PrecacheModel("sprites/laser.vmt");
	g_ShockwaveHalo = PrecacheModel("sprites/halo01.vmt");
	PrecacheModel(LASER_MODEL, true);
	char sOverlay[PLATFORM_MAX_PATH];
	g_cvCameraOverlay.GetString(sOverlay, sizeof(sOverlay));
	PrecacheMaterial2(sOverlay);
	g_cvOverlayNoGrain.GetString(sOverlay, sizeof(sOverlay));
	PrecacheMaterial2(sOverlay);
	g_cvGhostOverlay.GetString(sOverlay, sizeof(sOverlay));
	PrecacheMaterial2(sOverlay);

	SF2MapEntity_OnMapStart();
}

public void OnConfigsExecuted()
{
	if (!g_cvEnabled.BoolValue)
	{
		StopPlugin();
	}
	else
	{
		if (g_cvSlenderMapsOnly.BoolValue)
		{
			char sMap[256];
			GetCurrentMap(sMap, sizeof(sMap));
			
			if (!StrContains(sMap, "slender_", false) || !StrContains(sMap, "sf2_", false))
			{
				StartPlugin();
			}
			else
			{
				LogMessage("%s is not a Slender Fortress map. Plugin disabled!", sMap);
				StopPlugin();
			}
		}
		else
		{
			StartPlugin();
		}
	}
}

static void StartPlugin()
{
	if (g_bEnabled) return;
	
	g_bEnabled = true;
	
	InitializeLogging();
	
	#if defined DEBUG
	InitializeDebugLogging();
	#endif
	
	int i2 = 0;
	
	// Handle ConVars.
	ConVar hCvar = FindConVar("mp_friendlyfire");
	if (hCvar != null) hCvar.SetBool(true);
	
	hCvar = FindConVar("mp_flashlight");
	if (hCvar != null) hCvar.SetBool(true);
	
	hCvar = FindConVar("mat_supportflashlight");
	if (hCvar != null) hCvar.SetBool(true);
	
	hCvar = FindConVar("mp_autoteambalance");
	if (hCvar != null) hCvar.SetBool(false);

	if (!g_cvFullyEnableSpectator.BoolValue)
	{
		hCvar = FindConVar("mp_allowspectators");
		if (hCvar != null) hCvar.SetBool(false);
	}
	
	g_flGravity = g_cvGravity.FloatValue;
	
	g_b20Dollars = g_cv20Dollars.BoolValue;
	
	g_bPlayerShakeEnabled = g_cvPlayerShakeEnabled.BoolValue;
	g_bPlayerViewbobHurtEnabled = g_cvPlayerViewbobHurtEnabled.BoolValue;
	g_bPlayerViewbobSprintEnabled = g_cvPlayerViewbobSprintEnabled.BoolValue;
	
	#if defined _SteamWorks_Included
	if (steamworks)
	{
		SteamWorks_SetGameDescription("Slender Fortress ("...PLUGIN_VERSION_DISPLAY...")");
		steamtools = false;
	}
	#endif
	#if defined _steamtools_included
	if (steamtools)
	{
		Steam_SetGameDescription("Slender Fortress ("...PLUGIN_VERSION_DISPLAY...")");
		steamworks = false;
	}
	#endif
	
	if (steamworks) i2 = 1;
	else if (steamtools) i2 = 2;
	
	PrecacheStuff();
	
	if (i2 == 1 || i2 == 2 || i2 == 0) WarningRemoval(); //Sourcemod loves to call steamworks and steamtools unused symbols, do this to prevent this
	
	// Reset special round.
	g_bSpecialRound = false;
	g_bSpecialRoundNew = false;
	g_bSpecialRoundContinuous = false;
	g_iSpecialRoundCount = 1;
	SF_RemoveAllSpecialRound();
	
	SpecialRoundReset();
	
	// Reset boss rounds.
	g_bNewBossRound = false;
	g_bNewBossRoundNew = false;
	g_bNewBossRoundContinuous = false;
	g_iNewBossRoundCount = 1;
	g_strNewBossRoundProfile[0] = '\0';
	
	// Reset global round vars.
	g_iRoundCount = 0;
	g_iRoundEndCount = 0;
	g_iRoundActiveCount = 0;
	g_iRoundState = SF2RoundState_Invalid;
	g_hRoundMessagesTimer = CreateTimer(200.0, Timer_RoundMessages, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_iRoundMessagesNum = 0;
	
	g_iRoundWarmupRoundCount = 0;
	
	g_hClientAverageUpdateTimer = CreateTimer(0.2, Timer_ClientAverageUpdate, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_hBossCountUpdateTimer = CreateTimer(2.0, Timer_BossCountUpdate, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	
	g_hOnGameFrameTimer = CreateTimer(0.1, Timer_GlobalGameFrame, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	
	SetRoundState(SF2RoundState_Waiting);
	
	ReloadBossProfiles();
	ReloadRestrictedWeapons();
	ReloadSpecialRounds();
	
	NPCOnConfigsExecuted();
	
	InitializeBossPackVotes();
	SetupTimeLimitTimerForBossPackVote();
	
	// Late load compensation.
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		OnClientPutInServer(i);
	}
}

void WarningRemoval()
{
	
}

static void PrecacheStuff()
{
	// Initialize particles.
	g_iParticle[CriticalHit] = PrecacheParticleSystem(CRIT_PARTICLENAME);
	g_iParticle[MiniCritHit] = PrecacheParticleSystem(MINICRIT_PARTICLENAME);
	g_iParticle[ZapParticle] = PrecacheParticleSystem(ZAP_PARTICLENAME);
	g_iParticle[FireworksRED] = PrecacheParticleSystem(FIREWORKSRED_PARTICLENAME);
	g_iParticle[FireworksBLU] = PrecacheParticleSystem(FIREWORKSBLU_PARTICLENAME);
	g_iParticle[TeleportedInBlu] = PrecacheParticleSystem(TELEPORTEDINBLU_PARTICLENAME);
	
	for (int i = 0; i < sizeof(g_strSoundNightmareMode) - 1; i++) PrecacheSound2(g_strSoundNightmareMode[i]);
	
	PrecacheSound("ui/itemcrate_smash_ultrarare_short.wav");
	PrecacheSound(")weapons/crusaders_crossbow_shoot.wav");
	PrecacheSound(MINICRIT_SOUND);
	PrecacheSound(CRIT_SOUND);
	PrecacheSound(ZAP_SOUND);
	PrecacheSound(PAGE_DETECTOR_BEEP);
	PrecacheSound(EXPLOSIVEDANCE_EXPLOSION1);
	PrecacheSound(EXPLOSIVEDANCE_EXPLOSION2);
	PrecacheSound(EXPLOSIVEDANCE_EXPLOSION3);
	PrecacheSound(SPECIAL1UPSOUND);
	PrecacheSound("player/spy_shield_break.wav");
	
	PrecacheSound(CRIT_ROLL);
	PrecacheSound(EXPLODE_PLAYER);
	PrecacheSound(UBER_ROLL);
	PrecacheSound(NO_EFFECT_ROLL);
	PrecacheSound(BLEED_ROLL);
	PrecacheSound(GENERIC_ROLL_TICK_1);
	PrecacheSound(GENERIC_ROLL_TICK_2);
	PrecacheSound(LOSE_SPRINT_ROLL);
	PrecacheSound(FIREWORK_EXPLOSION);
	PrecacheSound(FIREWORK_START);
	PrecacheSound(MINICRIT_BUFF);
	PrecacheSound(NULLSOUND);
	PrecacheSound(JARATE_ROLL);
	PrecacheSound(GAS_ROLL);
	
	// simple_bot;
	PrecacheModel("models/humans/group01/female_01.mdl", true);
	
	PrecacheModel(PAGE_MODEL, true);
	PrecacheModel(SF_KEYMODEL, true);
	PrecacheModel(TRAP_MODEL, true);
	
	PrecacheSound2(FLASHLIGHT_CLICKSOUND);
	PrecacheSound2(FLASHLIGHT_CLICKSOUND_NIGHTVISION);
	PrecacheSound2(FLASHLIGHT_BREAKSOUND);
	PrecacheSound2(FLASHLIGHT_NOSOUND);
	PrecacheSound2(PAGE_GRABSOUND);
	PrecacheSound2(TWENTYDOLLARS_MUSIC);
	PrecacheSound2(MARBLEHORNETS_STATIC);
	
	PrecacheSound(DEFAULT_CLOAKONSOUND);
	PrecacheSound(DEFAULT_CLOAKOFFSOUND);
	
	PrecacheSound(FIREBALL_IMPACT);
	PrecacheSound(FIREBALL_SHOOT);
	PrecacheSound(ICEBALL_IMPACT);
	PrecacheSound(ROCKET_SHOOT);
	PrecacheSound(ROCKET_IMPACT);
	PrecacheSound(GRENADE_SHOOT);
	PrecacheSound(SENTRYROCKET_SHOOT);
	PrecacheSound(ARROW_SHOOT);
	PrecacheSound(MANGLER_EXPLODE1);
	PrecacheSound(MANGLER_EXPLODE2);
	PrecacheSound(MANGLER_EXPLODE3);
	PrecacheSound(MANGLER_SHOOT);
	PrecacheSound(BASEBALL_SHOOT);
	
	PrecacheSound(THANATOPHOBIA_MEDICNO);
	
	PrecacheModel(ROCKET_MODEL, true);
	PrecacheModel(GRENADE_MODEL, true);
	PrecacheModel(BASEBALL_MODEL, true);
	
	PrecacheSound(JARATE_HITPLAYER);
	PrecacheSound(STUN_HITPLAYER);
	
	PrecacheSound2(MUSIC_GOTPAGES1_SOUND);
	PrecacheSound2(MUSIC_GOTPAGES2_SOUND);
	PrecacheSound2(MUSIC_GOTPAGES3_SOUND);
	PrecacheSound2(MUSIC_GOTPAGES4_SOUND);
	
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_1);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_2);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_3);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_4);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_5);
	PrecacheSound2(SNATCHER_APOLLYON_1);
	PrecacheSound2(SNATCHER_APOLLYON_2);
	PrecacheSound2(SNATCHER_APOLLYON_3);
	
	PrecacheSound2(NINETYSMUSIC);
	PrecacheSound2(TRIPLEBOSSESMUSIC);
	
	PrecacheSound2(TRAP_CLOSE);
	PrecacheSound2(TRAP_DEPLOY);
	
	for (int i = 0; i < sizeof(g_sPageCollectDuckSounds); i++)
	{
		PrecacheSound(g_sPageCollectDuckSounds[i]);
	}
	
	PrecacheSound2(PROXY_RAGE_MODE_SOUND);
	
	PrecacheSound2(SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND);
	
	for (int i = 0; i < sizeof(g_strPlayerBreathSounds); i++)
	{
		PrecacheSound2(g_strPlayerBreathSounds[i]);
	}
	
	// Special round.
	PrecacheSound2(SR_MUSIC);
	PrecacheSound2(SR_SOUND_SELECT);
	PrecacheSound(SR_SOUND_SELECT_BR);
	PrecacheSound2(SF2_INTRO_DEFAULT_MUSIC);
	
	PrecacheMaterial2(SF2_OVERLAY_MARBLEHORNETS);
	
	AddFileToDownloadsTable("models/slender/pickups/sheet.mdl");
	AddFileToDownloadsTable("models/slender/pickups/sheet.dx80.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.dx90.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.phy");
	AddFileToDownloadsTable("models/slender/pickups/sheet.sw.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.vvd");
	AddFileToDownloadsTable("models/slender/pickups/sheet.xbox");
	
	AddFileToDownloadsTable("models/demani_sf/key_australium.mdl");
	AddFileToDownloadsTable("models/demani_sf/key_australium.dx80.vtx");
	AddFileToDownloadsTable("models/demani_sf/key_australium.dx90.vtx");
	AddFileToDownloadsTable("models/demani_sf/key_australium.sw.vtx");
	AddFileToDownloadsTable("models/demani_sf/key_australium.vvd");
	
	AddFileToDownloadsTable("materials/models/demani_sf/key_australium.vmt");
	AddFileToDownloadsTable("materials/models/demani_sf/key_australium.vtf");
	AddFileToDownloadsTable("materials/models/demani_sf/key_australium_normal.vtf");
	
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_1.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_1.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_2.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_2.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_3.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_3.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_4.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_4.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_5.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_5.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_6.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_6.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_7.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_7.vmt");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_8.vtf");
	AddFileToDownloadsTable("materials/models/jason278/slender/sheets/sheet_8.vmt");
	
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.mdl");
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.sw.vtx");
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.dx80.vtx");
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.dx90.vtx");
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.phy");
	AddFileToDownloadsTable("models/mentrillum/traps/beartrap.vvd");
	
	AddFileToDownloadsTable("materials/models/mentrillum/traps/beartrap/trap_m.vtf");
	AddFileToDownloadsTable("materials/models/mentrillum/traps/beartrap/trap_m.vmt");
	AddFileToDownloadsTable("materials/models/mentrillum/traps/beartrap/trap_n.vtf");
	AddFileToDownloadsTable("materials/models/mentrillum/traps/beartrap/trap_r.vtf");
	
	// pvp
	PvP_Precache();
}

static void StopPlugin()
{
	if (!g_bEnabled) return;
	
	g_bEnabled = false;
	
	g_bRestartSessionEnabled = false;
	g_cvRestartSession.SetBool(false);

	// Reset CVars.
	ConVar hCvar = FindConVar("mp_friendlyfire");
	if (hCvar != null) hCvar.SetBool(false);
	
	hCvar = FindConVar("mp_flashlight");
	if (hCvar != null) hCvar.SetBool(false);
	
	hCvar = FindConVar("mat_supportflashlight");
	if (hCvar != null) hCvar.SetBool(false);
	
	if (MusicActive()) NPCStopMusic();
	
	//Remove Timer handles
	CleanTimerHandles();
	
	// Cleanup bosses.
	NPCRemoveAll();
	
	// Cleanup clients.
	for (int i = 1; i <= MaxClients; i++)
	{
		ClientResetFlashlight(i);
		ClientDeactivateUltravision(i);
		ClientDisableConstantGlow(i);
		ClientRemoveInteractiveGlow(i);
	}

	g_bRenevantMultiEffect = false;
	g_bRenevantBeaconEffect = false;
	g_bRenevant90sEffect = false;
	g_bRenevantMarkForDeath = false;
	
	BossProfilesOnMapEnd();
	
	Tutorial_OnMapEnd();
	
	delete g_hConfig;
}

public void CleanTimerHandles()
{
	g_hRoundMessagesTimer = null;
	g_hClientAverageUpdateTimer = null;
	g_hBossCountUpdateTimer = null;
	g_hBlueNightvisionOutlineTimer = null;
	g_hRoundIntroTextTimer = null;
	g_hRoundIntroTimer = null;
	g_hRoundGraceTimer = null;
	g_hRoundTimer = null;
	g_hRenevantWaveTimer = null;
	g_hTimerChangeSourceTVBotName = null;
	g_hVoteTimer = null;
	g_hTimerFail = null;
	g_hBossPackVoteTimer = null;
	g_hBossPackVoteMapTimer = null;
	hTimerMusic = null;
	g_hOnGameFrameTimer = null;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientInGame(i)) continue;
		g_hPlayerPageRewardTimer[i] = null;
		g_hPlayerPageRewardCycleTimer[i] = null;
		g_hPlayerOverlayCheck[i] = null;
		g_hPlayerPostWeaponsTimer[i] = null;
		g_hPlayerSwitchBlueTimer[i] = null;
		g_hPlayerIntroMusicTimer[i] = null;
		g_hPlayerPvPRespawnTimer[i] = null;
		g_hPlayerPvPTimer[i] = null;
		g_hPlayerIgniteTimer[i] = null;
		g_hPlayerResetIgnite[i] = null;
		g_hPlayerStaticTimer[i] = null;
		g_hPlayerLastStaticTimer[i] = null;
		g_hClientSpecialRoundTimer[i] = null;
		g_hPlayerBreathTimer[i] = null;
		g_hPlayerSprintTimer[i] = null;
		g_hPlayerProxyAvailableTimer[i] = null;
		g_hPlayerProxyControlTimer[i] = null;
		g_hClientGlowTimer[i] = null;
		g_hPlayerDeathCamTimer[i] = null;
		g_hPlayerGhostModeConnectionCheckTimer[i] = null;
		g_hPlayerCampingTimer[i] = null;
		g_hPlayerBlinkTimer[i] = null;
		g_hPlayerMusicTimer[i] = null;
		g_hPlayer90sMusicTimer[i] = null;
		g_hPlayerFlashlightBatteryTimer[i] = null;
	}
	for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
	{
		if (NPCGetUniqueID(iBossIndex) == -1) continue;
		g_hBossFailSafeTimer[iBossIndex] = null;
		g_hSlenderRage1Timer[iBossIndex] = null;
		g_hSlenderRage2Timer[iBossIndex] = null;
		g_hSlenderRage3Timer[iBossIndex] = null;
		g_hSlenderHealTimer[iBossIndex] = null;
		g_hSlenderHealDelayTimer[iBossIndex] = null;
		g_hSlenderStartFleeTimer[iBossIndex] = null;
		g_hSlenderAttackTimer[iBossIndex] = null;
		g_hNPCLifeStealTimer[iBossIndex] = null;
		g_hSlenderChaseInitialTimer[iBossIndex] = null;
		g_hSlenderEntityThink[iBossIndex] = null;
		g_hSlenderHealEventTimer[iBossIndex] = null;
		g_hSlenderLaserTimer[iBossIndex] = null;
		g_hSlenderThink[iBossIndex] = null;
		g_hSlenderSpawnTimer[iBossIndex] = null;
		g_hSlenderBurnTimer[iBossIndex] = null;
		g_hSlenderBleedTimer[iBossIndex] = null;
		g_hSlenderMarkedTimer[iBossIndex] = null;
		g_hSlenderFakeTimer[iBossIndex] = null;
		g_hSlenderDeathCamTimer[iBossIndex] = null;
	}
}

public void OnMapEnd()
{
	StopPlugin();
}

public void OnMapTimeLeftChanged()
{
	if (g_bEnabled)
	{
		SetupTimeLimitTimerForBossPackVote();
	}
}

public void TF2_OnConditionAdded(int iClient, TFCond cond)
{
	if (cond == TFCond_Taunting)
	{
		if (IsClientInGhostMode(iClient))
		{
			// Stop ghosties from taunting.
			TF2_RemoveCondition(iClient, TFCond_Taunting);
		}
		
		if (g_bPlayerProxy[iClient])
		{
			g_iPlayerProxyControl[iClient] -= 20;
			if (g_iPlayerProxyControl[iClient] <= 0) g_iPlayerProxyControl[iClient] = 0;
		}
	}
	if (cond == view_as<TFCond>(82))
	{
		if (g_bPlayerProxy[iClient])
		{
			//Stop proxies from using kart commands
			TF2_RemoveCondition(iClient, TFCond_HalloweenKart);
			TF2_RemoveCondition(iClient, TFCond_HalloweenKartDash);
			TF2_RemoveCondition(iClient, TFCond_HalloweenKartNoTurn);
			TF2_RemoveCondition(iClient, TFCond_HalloweenKartCage);
			TF2_RemoveCondition(iClient, TFCond_SpawnOutline);
		}
	}
}

public Action Timer_GlobalGameFrame(Handle timer)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	if (timer != g_hOnGameFrameTimer) return Plugin_Stop;
	
	if (IsRoundPlaying()) g_flRoundTimeMessage += 0.1;
	else g_flRoundTimeMessage = 0.0;

	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		char sBoxingBossName[SF2_MAX_NAME_LENGTH], sMessage[1024];
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1) continue;
			NPCGetBossName(i, sBoxingBossName, sizeof(sBoxingBossName));
			int iStunHealth = RoundToNearest(NPCChaserGetStunHealth(i));
			if (iStunHealth < 0 || NPCGetEntRef(i) == INVALID_ENT_REFERENCE) iStunHealth = 0;
			int iStunInitHealth = RoundToNearest(NPCChaserGetStunInitialHealth(i));
			Format(sMessage, sizeof(sMessage), "%s\n%s's current health is %i of %i", sMessage, sBoxingBossName, iStunHealth, iStunInitHealth);
		}
		for (int iClient = 1; iClient < MaxClients; iClient++)
		{
			if (!IsClientInGame(iClient) || IsFakeClient(iClient) || !IsPlayerAlive(iClient) || (g_bPlayerEliminated[iClient] && !IsClientInGhostMode(iClient)) || DidClientEscape(iClient)) continue;

			PrintCenterText(iClient, sMessage);
		}
	}

	// Process through boss movement.
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		
		int iBoss = NPCGetEntIndex(i);
		if (!iBoss || iBoss == INVALID_ENT_REFERENCE) continue;
		
		if (NPCGetFlags(i) & SFF_MARKEDASFAKE) continue;
		
		int iType = NPCGetType(i);
		
		switch (iType)
		{
			case SF2BossType_Static:
			{
				float myPos[3], hisPos[3];
				SlenderGetAbsOrigin(i, myPos);
				AddVectors(myPos, g_flSlenderEyePosOffset[i], myPos);
				
				int iBestPlayer = -1;
				float flBestDistance = SquareFloat(16384.0);
				float flTempDistance;
				
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsClientInGame(iClient) || !IsPlayerAlive(iClient) || IsClientInGhostMode(iClient) || IsClientInDeathCam(iClient)) continue;
					if (!IsPointVisibleToPlayer(iClient, myPos, false, false)) continue;
					
					GetClientAbsOrigin(iClient, hisPos);
					
					flTempDistance = GetVectorSquareMagnitude(myPos, hisPos);
					if (flTempDistance < flBestDistance)
					{
						iBestPlayer = iClient;
						flBestDistance = flTempDistance;
					}
				}
				
				if (iBestPlayer > 0)
				{
					SlenderGetAbsOrigin(i, myPos);
					GetClientAbsOrigin(iBestPlayer, hisPos);
					
					if (!SlenderOnlyLooksIfNotSeen(i) || !IsPointVisibleToAPlayer(myPos, false, SlenderUsesBlink(i)))
					{
						float flTurnRate = NPCGetTurnRate(i);
						
						if (flTurnRate > 0.0)
						{
							float flMyEyeAng[3], ang[3];
							GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
							AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[i], flMyEyeAng);
							SubtractVectors(hisPos, myPos, ang);
							GetVectorAngles(ang, ang);
							ang[0] = 0.0;
							ang[1] += (AngleDiff(ang[1], flMyEyeAng[1]) >= 0.0 ? 1.0 : -1.0) * flTurnRate * GetTickInterval();
							ang[2] = 0.0;
							
							// Take care of angle offsets.
							AddVectors(ang, g_flSlenderEyePosOffset[i], ang);
							for (int i2 = 0; i2 < 3; i2++) ang[i2] = AngleNormalize(ang[i2]);
							
							TeleportEntity(iBoss, NULL_VECTOR, ang, NULL_VECTOR);
						}
					}
				}
			}
		}
	}
	// Check if we can add some proxies.
	if (IsRoundPlaying() && !SF_IsRenevantMap() && !SF_IsSlaughterRunMap())
	{
			ArrayList hProxyCandidates = new ArrayList();

			for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
			{
				if (NPCGetUniqueID(iBossIndex) == -1) continue;
				
				if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) continue;
				
				if (g_iSlenderCopyMaster[iBossIndex] != -1) continue; // Copies cannot generate proxies.
				
				if (GetGameTime() < g_flSlenderTimeUntilNextProxy[iBossIndex]) continue; // Proxy spawning hasn't cooled down yet.

				int iTeleportTarget = EntRefToEntIndex(g_iSlenderProxyTarget[iBossIndex]);
				if (!iTeleportTarget || iTeleportTarget == INVALID_ENT_REFERENCE) continue; // No teleport target.

				int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

				int iMaxProxies = g_iSlenderMaxProxies[iBossIndex][iDifficulty];
				if (g_bProxySurvivalRageMode) iMaxProxies += 5;
				
				int iNumActiveProxies = 0;
				
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsClientInGame(iClient) || !g_bPlayerEliminated[iClient]) continue;
					if (!g_bPlayerProxy[iClient]) continue;
					
					if (NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]) == iBossIndex)
					{
						iNumActiveProxies++;
					}
				}
				if (iNumActiveProxies >= iMaxProxies) 
				{
#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d has too many active proxies!", iBossIndex);
					//PrintToChatAll("[PROXIES] Boss %d has too many active proxies!", iBossIndex);
#endif
					continue;
				}
				
				float flSpawnChanceMin = NPCGetProxySpawnChanceMin(iBossIndex, iDifficulty);
				float flSpawnChanceMax = NPCGetProxySpawnChanceMax(iBossIndex, iDifficulty);
				float flSpawnChanceThreshold = NPCGetProxySpawnChanceThreshold(iBossIndex, iDifficulty) * NPCGetAnger(iBossIndex);
				
				float flChance = GetRandomFloat(flSpawnChanceMin, flSpawnChanceMax);
				if (flChance > flSpawnChanceThreshold && !g_bProxySurvivalRageMode) 
				{
#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d's chances weren't in his favor!", iBossIndex);
					//PrintToChatAll("[PROXIES] Boss %d's chances weren't in his favor!", iBossIndex);
#endif
					continue;
				}
				
				int iAvailableProxies = iMaxProxies - iNumActiveProxies;
				
				int iSpawnNumMin = NPCGetProxySpawnNumMin(iBossIndex, iDifficulty);
				int iSpawnNumMax = NPCGetProxySpawnNumMax(iBossIndex, iDifficulty);
				
				int iSpawnNum = 0;
				
				// Get a list of people we can transform into a good Proxy.
				hProxyCandidates.Clear();
				
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsClientInGame(iClient) || !g_bPlayerEliminated[iClient] || GetClientTeam(iClient) == TFTeam_Red) continue;
					if (g_bPlayerProxy[iClient]) continue;
					
					if (!g_iPlayerPreferences[iClient].PlayerPreference_EnableProxySelection)
					{
#if defined DEBUG
						SendDebugMessageToPlayer(iClient, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because of your preferences.", iBossIndex);
						//PrintToChatAll("[PROXIES] You were rejected for being a proxy for boss %d because of your preferences.", iBossIndex);
#endif
						continue;
					}
					
					if (!g_bPlayerProxyAvailable[iClient])
					{
#if defined DEBUG
						SendDebugMessageToPlayer(iClient, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because of your cooldown.", iBossIndex);
#endif
						continue;
					}
					
					if (g_bPlayerProxyAvailableInForce[iClient])
					{
#if defined DEBUG
						SendDebugMessageToPlayer(iClient, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because you're already being forced into a Proxy.", iBossIndex);
#endif
						continue;
					}
					
					if (!IsClientParticipating(iClient))
					{
#if defined DEBUG
						SendDebugMessageToPlayer(iClient, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because you're not participating.", iBossIndex);
#endif
						continue;
					}
					
					hProxyCandidates.Push(iClient);
					iSpawnNum++;
				}
				
				if (iSpawnNum >= iSpawnNumMax)
				{
					iSpawnNum = GetRandomInt(iSpawnNumMin, iSpawnNumMax);
				}
				else if (iSpawnNum >= iSpawnNumMin)
				{
					iSpawnNum = GetRandomInt(iSpawnNumMin, iSpawnNum);
				}
				
				if (iSpawnNum <= 0) 
				{
#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d had a set spawn number of 0!", iBossIndex);
#endif
					continue;
				}
				bool bCooldown = false;
				// Randomize the array.
				SortADTArray(hProxyCandidates, Sort_Random, Sort_Integer);
				
				float flDestinationPos[3];
				
				for (int iNum = 0; iNum < iSpawnNum && iNum < iAvailableProxies; iNum++)
				{
					int iClient = hProxyCandidates.Get(iNum);
					int iSpawnPoint = -1;

					if (!SpawnProxy(iClient, iBossIndex, flDestinationPos, iSpawnPoint))
					{
#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not find any areas to place proxies (spawned %d)!", iBossIndex, iNum);
						//PrintToChatAll("[PROXIES] Boss %d could not find any areas to place proxies (spawned %d)!", iBossIndex, iNum);
#endif
						break;
					}
					bCooldown = true;
					if (!g_iPlayerPreferences[iClient].PlayerPreference_ProxyShowMessage)
					{
						ClientStartProxyForce(iClient, NPCGetUniqueID(iBossIndex), flDestinationPos, iSpawnPoint);
					}
					else
					{
						if (!IsRoundEnding() && !IsRoundInWarmup() && !IsRoundInIntro()) DisplayProxyAskMenu(iClient, NPCGetUniqueID(iBossIndex), flDestinationPos, iSpawnPoint);
					}
				}
				// Set the cooldown time!
				if(bCooldown)
				{
					float flSpawnCooldownMin = NPCGetProxySpawnCooldownMin(iBossIndex, iDifficulty);
					float flSpawnCooldownMax = NPCGetProxySpawnCooldownMax(iBossIndex, iDifficulty);
				
					g_flSlenderTimeUntilNextProxy[iBossIndex] = GetGameTime() + GetRandomFloat(flSpawnCooldownMin, flSpawnCooldownMax);
				}
				else
					g_flSlenderTimeUntilNextProxy[iBossIndex] = GetGameTime() + GetRandomFloat(3.0, 4.0);
				
#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0,"[PROXIES] Boss %d finished proxy process!", iBossIndex);
#endif
			}
			
			delete hProxyCandidates;
	}
	
	PvP_OnGameFrame();
	
	return Plugin_Continue;
}

public Action Hook_CommandBuild(int iClient, const char[] command, int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (!IsClientInPvP(iClient)) return Plugin_Handled;
	
	return Plugin_Continue;
}

public Action Hook_CommandTaunt(int iClient, const char[] command, int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (!g_bPlayerEliminated[iClient] && GetRoundState() == SF2RoundState_Intro) return Plugin_Handled;
	if (IsClientInGhostMode(iClient)) return Plugin_Handled;
	
	return Plugin_Continue;
}

public Action Hook_CommandDisguise(int iClient, const char[] command, int argc)
{
	if (!g_bEnabled) return Plugin_Continue;
	return Plugin_Handled;
}

public Action Timer_BlueNightvisionOutline(Handle timer)
{
	if (timer != g_hBlueNightvisionOutlineTimer) return Plugin_Stop;
	
	if (!g_bEnabled) return Plugin_Stop;
	
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		SlenderRemoveGlow(iNPCIndex);
		if (NPCGetCustomOutlinesState(iNPCIndex))
		{
			if (!NPCGetRainbowOutlineState(iNPCIndex))
			{
				int color[4];
				color[0] = NPCGetOutlineColorR(iNPCIndex);
				color[1] = NPCGetOutlineColorG(iNPCIndex);
				color[2] = NPCGetOutlineColorB(iNPCIndex);
				color[3] = NPCGetOutlineTransparency(iNPCIndex);
				if (color[0] < 0) color[0] = 0;
				if (color[1] < 0) color[1] = 0;
				if (color[2] < 0) color[2] = 0;
				if (color[3] < 0) color[3] = 0;
				if (color[0] > 255) color[0] = 255;
				if (color[1] > 255) color[1] = 255;
				if (color[2] > 255) color[2] = 255;
				if (color[3] > 255) color[3] = 255;
				SlenderAddGlow(iNPCIndex, _, color);
			}
			else SlenderAddGlow(iNPCIndex, _, view_as<int>( { 0, 0, 0, 0 } ));
		}
		else
		{
			int iPurple[4] = { 150, 0, 255, 255 };
			SlenderAddGlow(iNPCIndex, _, iPurple);
		}
	}
	return Plugin_Continue;
}

public Action Timer_BossCountUpdate(Handle timer)
{
	if (timer != g_hBossCountUpdateTimer) return Plugin_Stop;
	
	if (!g_bEnabled) return Plugin_Stop;
	
	int iBossCount = NPCGetCount();
	int iBossPreferredCount;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1 || 
			g_iSlenderCopyMaster[i] != -1 || 
			(NPCGetFlags(i) & SFF_FAKE))
		{
			continue;
		}
		
		iBossPreferredCount++;
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || 
			!IsPlayerAlive(i) || 
			g_bPlayerEliminated[i] || 
			IsClientInGhostMode(i) || 
			IsClientInDeathCam(i) || 
			DidClientEscape(i)) continue;
		
		// Check if we're near any bosses.
		int iClosest = -1;
		float flBestDist = SquareFloat(SF2_BOSS_PAGE_CALCULATION);
		
		for (int iBoss = 0; iBoss < MAX_BOSSES; iBoss++)
		{
			if (NPCGetUniqueID(iBoss) == -1) continue;
			if (NPCGetEntIndex(iBoss) == INVALID_ENT_REFERENCE) continue;
			if (NPCGetFlags(iBoss) & SFF_FAKE) continue;
			
			float flDist = NPCGetDistanceFromEntity(iBoss, i);
			if (flDist < flBestDist)
			{
				iClosest = iBoss;
				flBestDist = flDist;
				break;
			}
		}
		
		if (iClosest != -1) continue;
		
		iClosest = -1;
		flBestDist = SquareFloat(SF2_BOSS_PAGE_CALCULATION);
		
		for (int iClient = 1; iClient <= MaxClients; iClient++)
		{
			if (!IsValidClient(iClient) || 
				!IsPlayerAlive(iClient) || 
				g_bPlayerEliminated[iClient] || 
				IsClientInGhostMode(iClient) || 
				IsClientInDeathCam(iClient) || 
				DidClientEscape(iClient))
			{
				continue;
			}
			
			bool bwub = false;
			for (int iBoss = 0; iBoss < MAX_BOSSES; iBoss++)
			{
				if (NPCGetUniqueID(iBoss) == -1) continue;
				if (NPCGetFlags(iBoss) & SFF_FAKE) continue;
				
				if (g_iSlenderTarget[iBoss] == iClient)
				{
					bwub = true;
					break;
				}
			}
			
			if (!bwub) continue;
			
			float flDist = EntityDistanceFromEntity(i, iClient);
			if (flDist < flBestDist)
			{
				iClosest = iClient;
				flBestDist = flDist;
			}
		}
		
		if (!IsValidClient(iClosest))
		{
			// No one's close to this dude? DUDE! WE NEED ANOTHER BOSS!
			iBossPreferredCount++;
		}
	}
	
	int iDiff = iBossCount - iBossPreferredCount;
	if (iDiff)
	{
		if (iDiff > 0)
		{
			int iCount = iDiff;
			// We need less bosses. Try and see if we can remove some.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (g_iSlenderCopyMaster[i] == -1) continue;
				if (PeopleCanSeeSlender(i, _, false)) continue;
				if (NPCGetFlags(i) & SFF_FAKE) continue;
				
				if (SlenderCanRemove(i))
				{
					NPCRemove(i);
					iCount--;
				}
				
				if (iCount <= 0)
				{
					break;
				}
			}
		}
		else
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			
			int iCount = RoundToFloor(FloatAbs(float(iDiff)));
			// Add int bosses (copy of the first boss).
			for (int i = 0; i < MAX_BOSSES && iCount > 0; i++)
			{
				SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
				if (!Npc.IsValid()) continue;
				if (g_iSlenderCopyMaster[Npc.Index] != -1) continue;
				if (!(Npc.Flags & SFF_COPIES)) continue;
				if (Npc.Flags & SFF_FAKE) continue;
				
				// Get the number of copies I already have and see if I can have more copies.
				int iCopyCount;
				for (int i2 = 0; i2 < MAX_BOSSES; i2++)
				{
					if (NPCGetUniqueID(i2) == -1) continue;
					if (g_iSlenderCopyMaster[i2] != i) continue;
					
					iCopyCount++;
				}

				int iDifficulty = GetLocalGlobalDifficulty(Npc.Index);
				
				Npc.GetProfile(sProfile, sizeof(sProfile));
				int iCopyDifficulty = g_iSlenderMaxCopies[Npc.Index][iDifficulty];
				if (iCopyCount >= iCopyDifficulty)
				{
					continue;
				}
				SF2NPC_BaseNPC NpcCopy = AddProfile(sProfile, _, Npc);
				if (!NpcCopy.IsValid())
				{
					//LogError("Could not add copy for %d: No free slots!", i);
				}
				
				iCount--;
			}
		}
	}
	return Plugin_Continue;
}

void ReloadRestrictedWeapons()
{
	if (g_hRestrictedWeaponsConfig != null)
	{
		delete g_hRestrictedWeaponsConfig;
		g_hRestrictedWeaponsConfig = null;
	}
	
	char buffer[PLATFORM_MAX_PATH];
	if (!g_cvUseAlternateConfigDirectory.BoolValue) BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS);
	else BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS_DATA);
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load restricted weapons list! File not found!");
	}
	else
	{
		g_hRestrictedWeaponsConfig = kv;
		LogSF2Message("Reloaded restricted weapons configuration file successfully");
	}
}

public Action Timer_RoundMessages(Handle timer)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	if (timer != g_hRoundMessagesTimer) return Plugin_Stop;
	
	switch (g_iRoundMessagesNum)
	{
		case 0:CPrintToChatAll("{royalblue}== {violet}Slender Fortress{royalblue} coded by {hotpink}KitRifty & Kenzzer{royalblue}==\n== Modified by {deeppink}Mentrillum & The Gaben{royalblue}, current version {violet}%s{royalblue}==", PLUGIN_VERSION_DISPLAY);
		case 1:CPrintToChatAll("%t", "SF2 Ad Message 1");
		case 2:CPrintToChatAll("%t", "SF2 Ad Message 2");
	}
	
	g_iRoundMessagesNum++;
	if (g_iRoundMessagesNum > 2)g_iRoundMessagesNum = 0;
	
	return Plugin_Continue;
}

public Action Timer_WelcomeMessage(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	CPrintToChat(iClient, "%T", "SF2 Welcome Message", iClient);
	
	return Plugin_Stop;
}

int GetMaxPlayersForRound()
{
	int iOverride = g_cvMaxPlayersOverride.IntValue;
	if (iOverride != -1) return iOverride;
	return g_cvMaxPlayers.IntValue;
}

public void OnConVarChanged(Handle cvar, const char[] oldValue, const char[] intValue)
{
	if (cvar == g_cvDifficulty)
	{
		switch (StringToInt(intValue))
		{
			case Difficulty_Easy: g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
			case Difficulty_Hard: g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_HARD;
			case Difficulty_Insane: g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_INSANE;
			case Difficulty_Nightmare: g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_NIGHTMARE;
			case Difficulty_Apollyon:
			{
				if (g_bRestartSessionEnabled) g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_RESTARTSESSION;
				else g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_APOLLYON;
			}
			default: g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
		}
		CheckIfMusicValid();
		if (MusicActive() && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || !IsClientInGame(i) || IsClientSourceTV(i)) continue;
				
				char sPath[PLATFORM_MAX_PATH];
				GetBossMusic(sPath, sizeof(sPath));
				if (sPath[0] != '\0') StopSound(i, MUSIC_CHAN, sPath);
				ClientUpdateMusicSystem(i);
			}
		}
		ChangeAllSlenderModels();
		Call_StartForward(fOnDifficultyChange);
		Call_PushCell(StringToInt(intValue));
		Call_Finish();
	}
	else if (cvar == g_cvMaxPlayers || cvar == g_cvMaxPlayersOverride)
	{
		for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
		{
			CheckPlayerGroup(i);
		}
	}
	else if (cvar == g_cvPlayerShakeEnabled)
	{
		g_bPlayerShakeEnabled = view_as<bool>(StringToInt(intValue));
	}
	else if (cvar == g_cvPlayerViewbobHurtEnabled)
	{
		g_bPlayerViewbobHurtEnabled = view_as<bool>(StringToInt(intValue));
	}
	else if (cvar == g_cvPlayerViewbobSprintEnabled)
	{
		g_bPlayerViewbobSprintEnabled = view_as<bool>(StringToInt(intValue));
	}
	else if (cvar == g_cvGravity)
	{
		g_flGravity = StringToFloat(intValue);
	}
	else if (cvar == g_cv20Dollars)
	{
		g_b20Dollars = view_as<bool>(StringToInt(intValue));
	}
	else if (cvar == g_cvAllChat || SF_IsBoxingMap())
	{
		if (g_bEnabled)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				ClientUpdateListeningFlags(i);
			}
		}
	}
	else if (cvar == g_cvIgnoreRoundWinConditions)
	{
		if (!view_as<bool>(StringToInt(intValue)) && !IsRoundInWarmup() && !IsRoundEnding())
		{
			CheckRoundWinConditions();
		}
	}
	else if (cvar == g_cvRestartSession)
	{
		if (g_cvRestartSession.BoolValue)
		{
			ArrayList hSelectableBossesAdmin = GetSelectableAdminBossProfileList().Clone();
			ArrayList hSelectableBosses = GetSelectableBossProfileList().Clone();
			for (int i = 0; i < sizeof(g_strSoundNightmareMode) - 1; i++)
			EmitSoundToAll(g_strSoundNightmareMode[i]);
			SpecialRoundGameText("Its Restart Session time!", "leaderboard_streak");
			CPrintToChatAll("{royalblue}%t{default}Your thirst for blood continues? Very well, let the blood spill. Let the demons feed off your unfortunate soul... Difficulty set to {mediumslateblue}%t!", "SF2 Prefix", "SF2 Calamity Difficulty");
			g_bRestartSessionEnabled = true;
			g_cvDifficulty.SetInt(Difficulty_Apollyon);
			g_cvIgnoreRoundWinConditions.SetBool(true);
			g_cvIgnoreRedPlayerDeathSwap.SetBool(true);
			g_cvBossChaseEndlessly.SetBool(true);
			g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_RESTARTSESSION;
			if (g_hRoundGraceTimer != null)
			{
				TriggerTimer(g_hRoundGraceTimer);
			}
			for (int iBossCount = 0; iBossCount < 10; iBossCount++)
			{
				char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH], sBufferAdmin[SF2_MAX_PROFILE_NAME_LENGTH];
				if (hSelectableBosses.Length > 0)
				{
					hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
				if (hSelectableBossesAdmin.Length > 0)
				{
					hSelectableBossesAdmin.GetString(GetRandomInt(0, hSelectableBossesAdmin.Length - 1), sBufferAdmin, sizeof(sBufferAdmin));
					AddProfile(sBufferAdmin);
				}
			}
			for (int i = 1; i < MaxClients; i++)
			{
				if (!IsValidClient(i)) continue;
				if (IsClientSourceTV(i)) continue;
				if (!CheckCommandAccess(i, "sm_sf2_setplaystate", ADMFLAG_SLAY))
				{
					if (IsClientInGhostMode(i))
					{
						ClientSetGhostModeState(i, false);
						TF2_RespawnPlayer(i);
						TF2_RemoveCondition(i, TFCond_StealthedUserBuffFade);
						g_flLastCommandTime[i] = GetEngineTime()+0.5;
						CreateTimer(0.25, Timer_ForcePlayer, GetClientUserId(i), TIMER_FLAG_NO_MAPCHANGE);
					}
					else SetClientPlayState(i, true);
				}
				else SetClientPlayState(i, false);
			}
			if (IsRoundPlaying())
			{
				ArrayList hSpawnPoint = new ArrayList();
				float flTeleportPos[3];
				int ent = -1, iSpawnTeam = 0;
				while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
				{
					iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
					if (iSpawnTeam == TFTeam_Red)
					{
						hSpawnPoint.Push(ent);
					}
					
				}
				ent = -1;
				if (hSpawnPoint.Length > 0)
				{
					for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
					{
						ent = hSpawnPoint.Get(GetRandomInt(0, hSpawnPoint.Length - 1));
						
						if (IsValidEntity(ent))
						{
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
							SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iNPCIndex);
							if (!Npc.IsValid()) continue;
							SpawnSlender(Npc, flTeleportPos);
						}
					}
				}
				delete hSpawnPoint;
			}
			delete hSelectableBosses;
			delete hSelectableBossesAdmin;
		}
		else
		{
			CPrintToChatAll("{royalblue}%t{default}You're done? Ok. Difficulty set to {darkgray}Apollyon.", "SF2 Prefix");
			g_bRestartSessionEnabled = false;
			g_cvDifficulty.SetInt(Difficulty_Apollyon);
			g_cvIgnoreRoundWinConditions.SetBool(false);
			g_cvIgnoreRedPlayerDeathSwap.SetBool(false);
			g_cvBossChaseEndlessly.SetBool(false);
			g_flRoundDifficultyModifier = DIFFICULTYMODIFIER_APOLLYON;
		}
	}
}

//	==========================================================
//	IN-GAME AND ENTITY HOOK FUNCTIONS
//	==========================================================


public void OnEntityCreated(int ent, const char[] classname)
{
	if (!g_bEnabled) return;
	
	if (!IsValidEntity(ent) || ent <= 0) return;
	
	if (strcmp(classname, "spotlight_end") == 0)
	{
		SDKHook(ent, SDKHook_SpawnPost, Hook_FlashlightEndSpawnPost);
	}
	else if (strcmp(classname, "beam") == 0)
	{
		SDKHook(ent, SDKHook_SetTransmit, Hook_FlashlightBeamSetTransmit);
	}
	else if (strncmp(classname, "item_healthkit_", 15) == 0 && !SF_IsBoxingMap())
	{
		SDKHook(ent, SDKHook_Touch, Hook_HealthKitOnTouch);
	}
	else if (strcmp(classname, "func_button") == 0)
	{
		SDKHook(ent, SDKHook_Touch, Hook_GhostNoTouch);
	}
	else if (strncmp(classname, "trigger_", 8) == 0)
	{
		SDKHook(ent, SDKHook_Touch, Hook_GhostNoTouch);
	}
	else if (strcmp(classname, "tf_dropped_weapon") == 0)
	{
		SDKHook(ent, SDKHook_SpawnPost, Hook_DeleteDroppedWeapon);
	}
	else if (strcmp(classname, "obj_sentrygun") == 0 || strcmp(classname, "obj_dispenser") == 0 || strcmp(classname, "obj_teleporter") == 0)
	{
		CreateTimer(0.1, Timer_FullyBuildBuilding, EntIndexToEntRef(ent), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}
	PvP_OnEntityCreated(ent, classname);
}

public Action Timer_FullyBuildBuilding(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int iBuilding = EntRefToEntIndex(entref);
	if (!iBuilding || iBuilding == INVALID_ENT_REFERENCE) return Plugin_Stop;

	int iBuilder = GetEntPropEnt(iBuilding, Prop_Send, "m_hBuilder");

	if (GetEntPropFloat(iBuilding, Prop_Send, "m_flPercentageConstructed") >= 1.0 && !GetEntProp(iBuilding, Prop_Send, "m_bCarried") &&
	IsValidClient(iBuilder))
	{
		char sBuilding[64];

		GetEntityClassname(iBuilding, sBuilding, sizeof(sBuilding));

		SetEntProp(iBuilding, Prop_Send, "m_iTeamNum", TFTeam_Boss);
		int iRandomLevel = GetRandomInt(1,1);
		int iHealth = 150;
		if (strcmp(sBuilding, "obj_sentrygun") == 0)
		{
			SetEntityModel(iBuilding,"models/buildables/sentry1.mdl");
		}
		else if (strcmp(sBuilding, "obj_dispenser") == 0)
		{
			SetEntityModel(iBuilding,"models/buildables/dispenser.mdl");
		}
		SetEntProp(iBuilding, Prop_Send, "m_iUpgradeLevel", iRandomLevel);
		SetEntProp(iBuilding, Prop_Send, "m_iHealth", iHealth);
		SetEntProp(iBuilding, Prop_Send, "m_iMaxHealth", iHealth);
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

public void Hook_DeleteDroppedWeapon(int ent)
{
	if (!g_bEnabled) return;
	
	if (IsValidEntity(ent))
	{
		SDKUnhook(ent, SDKHook_SpawnPost, Hook_DeleteDroppedWeapon);
		RemoveEntity(ent);
	}
}

public MRESReturn Hook_WeaponGetCustomDamageType(int weapon, Handle hReturn, Handle hParams)
{
	if (!g_bEnabled) return MRES_Ignored;
	
	int ownerEntity = GetEntPropEnt(weapon, Prop_Data, "m_hOwnerEntity");
	if (IsValidClient(ownerEntity) && IsClientInPvP(ownerEntity) && IsValidEntity(weapon) && ownerEntity)
	{
		int customDamageType = DHookGetReturn(hReturn);
		if (customDamageType != -1)
		{
			MRESReturn hookResult = PvP_GetWeaponCustomDamageType(weapon, ownerEntity, customDamageType);
			if (hookResult != MRES_Ignored)
			{
				DHookSetReturn(hReturn, customDamageType);
				return hookResult;
			}
		}
		else return MRES_Ignored;
	}
	else
	{
		return MRES_Ignored;
	}
	
	return MRES_Ignored;
}

public void OnEntityDestroyed(int ent)
{
	if (!g_bEnabled) return;
	
	if (!IsValidEntity(ent) || ent <= 0) return;
	
	int iBossIndex = NPCGetFromEntIndex(ent);
	if (iBossIndex != -1)
	{
		RemoveSlender(iBossIndex);
		return;
	}
	
	char sClassname[64];
	GetEntityClassname(ent, sClassname, sizeof(sClassname));
	
	if (strcmp(sClassname, "light_dynamic", false) == 0)
	{
		AcceptEntityInput(ent, "TurnOff");
		
		int iEnd = INVALID_ENT_REFERENCE;
		while ((iEnd = FindEntityByClassname(iEnd, "spotlight_end")) != -1)
		{
			if (GetEntPropEnt(iEnd, Prop_Data, "m_hOwnerEntity") == ent)
			{
				RemoveEntity(iEnd);
				break;
			}
		}
	}
	g_iSlenderHitboxOwner[ent]=-1;
	
	PvP_OnEntityDestroyed(ent, sClassname);
}

public Action Hook_BlockUserMessage(UserMsg msg_id, Handle bf, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_bEnabled) return Plugin_Continue;
	return Plugin_Handled;
}

public Action Hook_TauntUserMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	int iClient = msg.ReadByte();
	if (!g_bPlayerEliminated[iClient]) return Plugin_Handled; //Don't allow a red player to play a taunt sound
	if (g_bPlayerProxy[iClient]) return Plugin_Handled; //Don't allow proxies to play a taunt sound
	
	char sTauntSound[PLATFORM_MAX_PATH];
	msg.ReadString(sTauntSound, PLATFORM_MAX_PATH);
	
	DataPack dataTaunt = new DataPack();
	dataTaunt.WriteCell(iClient);
	dataTaunt.WriteString(sTauntSound);
	
	RequestFrame(Frame_SendNewTauntMessage, dataTaunt); //Resend taunt sound to eliminated players only
	
	return Plugin_Handled; //Never ever allow a red player/proxy to hear taunt sound, we keep the playing area "tauntmusicless"
}

public void Frame_SendNewTauntMessage(DataPack dataMessage)
{
	int players[MAXPLAYERS + 1];
	int playersNum;
	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (!IsClientInGame(iClient)) continue;
		if (g_bPlayerProxy[iClient]) continue;
		if (!g_bPlayerEliminated[iClient] && !DidClientEscape(iClient)) continue;
		players[playersNum++] = iClient;
	}
	
	dataMessage.Reset();
	
	BfWrite message = UserMessageToBfWrite(StartMessage("PlayerTauntSoundLoopStart", players, playersNum, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS));
	message.WriteByte(dataMessage.ReadCell());
	char sTauntSound[PLATFORM_MAX_PATH];
	dataMessage.ReadString(sTauntSound, sizeof(sTauntSound));
	message.WriteString(sTauntSound);
	delete message;
	EndMessage();
	delete dataMessage;
}

public Action Hook_BlockUserMessageEx(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	char message[32];
	msg.ReadByte();
	msg.ReadByte();
	msg.ReadString(message, sizeof(message));
	
	if (strcmp(message, "#TF_Name_Change") == 0)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Hook_NormalSound(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	int iDifficulty = g_cvDifficulty.IntValue;

	if (IsValidClient(entity))
	{
		if (IsClientInGhostMode(entity))
		{
			switch (channel)
			{
				case SNDCHAN_VOICE, SNDCHAN_WEAPON, SNDCHAN_ITEM, SNDCHAN_BODY: return Plugin_Handled;
			}
			if (!StrContains(sample, "player/footsteps", false) || StrContains(sample, "step", false) != -1)
			{
				sample = NULLSOUND;
				return Plugin_Changed;
			}
		}
		else if (g_bPlayerProxy[entity])
		{
			int iMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[entity]);
			if (iMaster != -1)
			{
				char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(iMaster, sProfile, sizeof(sProfile));
				
				switch (channel)
				{
					case SNDCHAN_VOICE:
					{
						if (!g_bSlenderProxiesAllowNormalVoices[iMaster])
						{
							return Plugin_Handled;
						}
					}
				}
			}
		}
		else if (!g_bPlayerEliminated[entity] && !g_bPlayerEscaped[entity])
		{
			switch (channel)
			{
				case SNDCHAN_VOICE:
				{
					if (IsRoundInIntro()) return Plugin_Handled;
					
					for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
					{
						if (NPCGetUniqueID(iBossIndex) == -1) continue;
						
						if (SlenderCanHearPlayer(iBossIndex, entity, SoundType_Voice) && NPCShouldHearEntity(iBossIndex, entity))
						{
							GetClientAbsOrigin(entity, g_flSlenderTargetSoundTempPos[iBossIndex]);
							g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDSUSPICIOUSSOUND;
							g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDVOICE;
							if (g_iSlenderState[iBossIndex] == STATE_ALERT && NPCChaserIsAutoChaseEnabled(iBossIndex) && g_flSlenderAutoChaseCooldown[iBossIndex] < GetGameTime())
							{
								g_iSlenderSoundTarget[iBossIndex] = EntIndexToEntRef(entity);
								g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddVoice(iBossIndex, iDifficulty);
								g_flSlenderAutoChaseCooldown[iBossIndex] = GetGameTime() + 0.3;
							}
						}
					}
				}
				case SNDCHAN_BODY:
				{
					if (!StrContains(sample, "player/footsteps", false) || StrContains(sample, "step", false) != -1)
					{
						if (g_cvPlayerViewbobSprintEnabled.BoolValue && IsClientReallySprinting(entity))
						{
							// Viewpunch.
							float flPunchVelStep[3];
							
							float flVelocity[3];
							GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", flVelocity);
							float flSpeed = GetVectorLength(flVelocity, true);
							
							flPunchVelStep[0] = (flSpeed / SquareFloat(300.0));
							flPunchVelStep[1] = 0.0;
							flPunchVelStep[2] = 0.0;
							
							ClientViewPunch(entity, flPunchVelStep);
						}
						
						for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
						{
							if (NPCGetUniqueID(iBossIndex) == -1) continue;
							
							if (SlenderCanHearPlayer(iBossIndex, entity, SoundType_Footstep) && NPCShouldHearEntity(iBossIndex, entity))
							{
								GetClientAbsOrigin(entity, g_flSlenderTargetSoundTempPos[iBossIndex]);
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDSUSPICIOUSSOUND;
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDFOOTSTEP;
								if (g_iSlenderState[iBossIndex] == STATE_ALERT && NPCChaserIsAutoChaseEnabled(iBossIndex) && g_flSlenderAutoChaseCooldown[iBossIndex] < GetGameTime())
								{
									g_iSlenderSoundTarget[iBossIndex] = EntIndexToEntRef(entity);
									if (!IsClientReallySprinting(entity)) g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddFootstep(iBossIndex, iDifficulty);
									else if (IsClientReallySprinting(entity) && NPCChaserCanAutoChaseSprinters(iBossIndex)) g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddFootstep(iBossIndex, iDifficulty) * 3;
									g_flSlenderAutoChaseCooldown[iBossIndex] = GetGameTime() + 0.3;
								}
								
								if (IsClientSprinting(entity) && !(GetEntProp(entity, Prop_Send, "m_bDucking") || GetEntProp(entity, Prop_Send, "m_bDucked")))
								{
									g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDFOOTSTEPLOUD;
								}
							}
						}
					}
				}
				case SNDCHAN_ITEM, SNDCHAN_WEAPON:
				{
					if (StrContains(sample, "swing", false) || StrContains(sample, "impact", false) != -1 || StrContains(sample, "hit", false) != -1 || StrContains(sample, "slice", false) != -1 || StrContains(sample, "reload", false) != -1 || StrContains(sample, "woosh", false) != -1 || StrContains(sample, "eviction", false) != -1 || StrContains(sample, "holy", false) != -1)
					{
						for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
						{
							if (NPCGetUniqueID(iBossIndex) == -1) continue;
							
							if (SlenderCanHearPlayer(iBossIndex, entity, SoundType_Weapon) && NPCShouldHearEntity(iBossIndex, entity))
							{
								GetClientAbsOrigin(entity, g_flSlenderTargetSoundTempPos[iBossIndex]);
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDSUSPICIOUSSOUND;
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDWEAPON;
								if (g_iSlenderState[iBossIndex] == STATE_ALERT && NPCChaserIsAutoChaseEnabled(iBossIndex) && g_flSlenderAutoChaseCooldown[iBossIndex] < GetGameTime())
								{
									g_iSlenderSoundTarget[iBossIndex] = EntIndexToEntRef(entity);
									g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddWeapon(iBossIndex, iDifficulty);
									g_flSlenderAutoChaseCooldown[iBossIndex] = GetGameTime() + 0.3;
								}
							}
						}
					}
				}
				case SNDCHAN_STATIC:
				{
					if (StrContains(sample, FLASHLIGHT_CLICKSOUND, false) != -1)
					{
						for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
						{
							if (NPCGetUniqueID(iBossIndex) == -1) continue;
							
							if (SlenderCanHearPlayer(iBossIndex, entity, SoundType_Flashlight) && NPCShouldHearEntity(iBossIndex, entity))
							{
								GetClientAbsOrigin(entity, g_flSlenderTargetSoundTempPos[iBossIndex]);
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDSUSPICIOUSSOUND;
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDFLASHLIGHT;
								if (g_iSlenderState[iBossIndex] == STATE_ALERT && NPCChaserIsAutoChaseEnabled(iBossIndex) && g_flSlenderAutoChaseCooldown[iBossIndex] < GetGameTime())
								{
									g_iSlenderSoundTarget[iBossIndex] = EntIndexToEntRef(entity);
									g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddWeapon(iBossIndex, iDifficulty);
									g_flSlenderAutoChaseCooldown[iBossIndex] = GetGameTime() + 0.3;
								}
							}
						}
					}
					if (StrContains(sample, "happy_birthday_tf", false) != -1 || StrContains(sample, "jingle_bells_nm", false) != -1)
					{
						for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
						{
							if (NPCGetUniqueID(iBossIndex) == -1) continue;
							
							if (SlenderCanHearPlayer(iBossIndex, entity, SoundType_Voice) && NPCShouldHearEntity(iBossIndex, entity))
							{
								GetClientAbsOrigin(entity, g_flSlenderTargetSoundTempPos[iBossIndex]);
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDSUSPICIOUSSOUND;
								g_iSlenderInterruptConditions[iBossIndex] |= COND_HEARDVOICE;
								if (g_iSlenderState[iBossIndex] == STATE_ALERT && NPCChaserIsAutoChaseEnabled(iBossIndex) && g_flSlenderAutoChaseCooldown[iBossIndex] < GetGameTime())
								{
									g_iSlenderSoundTarget[iBossIndex] = EntIndexToEntRef(entity);
									g_iSlenderAutoChaseCount[iBossIndex] += NPCChaserAutoChaseAddVoice(iBossIndex, iDifficulty) * 2;
									g_flSlenderAutoChaseCooldown[iBossIndex] = GetGameTime() + 0.3;
								}
							}
						}
					}
				}
			}
		}
	}
	
	if (IsValidEntity(entity))
	{
		char classname[64];
		if (GetEntityClassname(entity, classname, sizeof(classname)) && strcmp(classname, "tf_projectile_rocket") == 0 && ((ProjectileGetFlags(entity) & PROJ_ICEBALL) || (ProjectileGetFlags(entity) & PROJ_FIREBALL) || (ProjectileGetFlags(entity) & PROJ_ICEBALL_ATTACK) || (ProjectileGetFlags(entity) & PROJ_FIREBALL_ATTACK)))
		{
			if (strcmp(sample, EXPLOSIVEDANCE_EXPLOSION1, false) == 0 || strcmp(sample, EXPLOSIVEDANCE_EXPLOSION2, false) == 0 || strcmp(sample, EXPLOSIVEDANCE_EXPLOSION3, false) == 0)
			{
				sample = NULLSOUND;
				return Plugin_Changed;
			}
		}
	}
	
	bool bModified = false;
	
	/*for (int i = 0; i < numClients; i++)
	{
		int iClient = clients[i];
		if (IsValidClient(iClient) && IsPlayerAlive(iClient) && !IsClientInGhostMode(iClient))
		{
			bool bCanHearSound = true;
			
			if (IsValidClient(entity) && entity != iClient)
			{
				if (!g_bPlayerEliminated[iClient])
				{
					if (g_bSpecialRound && SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
					{
						if (!g_bPlayerEliminated[entity] && !DidClientEscape(entity))
						{
							bCanHearSound = false;
						}
					}
				}
			}
			
			if (!bCanHearSound)
			{
				bModified = true;
				clients[i] = -1;
			}
		}
	}*/
	
	if (bModified) return Plugin_Changed;
	return Plugin_Continue;
}

public MRESReturn Hook_EntityShouldTransmit(int entity, Handle hReturn, Handle hParams)
{
	if (!g_bEnabled) return MRES_Ignored;
	
	if (IsValidClient(entity))
	{
		if (DoesClientHaveConstantGlow(entity))
		{
			DHookSetReturn(hReturn, FL_EDICT_ALWAYS); // Should always transmit, but our SetTransmit hook gets the final say.
			return MRES_Supercede;
		}
		else if (IsClientInGhostMode(entity))
		{
			DHookSetReturn(hReturn, FL_EDICT_DONTSEND);
			return MRES_Supercede;
		}
	}
	else
	{
		DHookSetReturn(hReturn, FL_EDICT_ALWAYS); // Should always transmit, but our SetTransmit hook gets the final say.
		return MRES_Supercede;
	}
	
	return MRES_Ignored;
}

void SF_CollectTriggersMultiple()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "trigger_*")) != -1)
	{
		SDKHook(ent, SDKHook_StartTouch, Hook_TriggerOnStartTouchEx);
		SDKHook(ent, SDKHook_Touch, Hook_TriggerOnTouchEx);
		SDKHook(ent, SDKHook_EndTouch, Hook_TriggerOnEndTouchEx);
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func*")) != -1)
	{
		SDKHook(ent, SDKHook_StartTouch, Hook_FuncOnStartTouchEx);
		SDKHook(ent, SDKHook_Touch, Hook_FuncOnTouchEx);
		SDKHook(ent, SDKHook_EndTouch, Hook_FuncOnEndTouchEx);
	}
}
public Action Hook_TriggerOnStartTouchEx(int iTrigger, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	Hook_TriggerOnStartTouch("OnStartTouch", iTrigger, iOther, 0.0);
	return Plugin_Continue;
}

public Action Hook_TriggerOnTouchEx(int iTrigger, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	return Plugin_Continue;
}

public Action Hook_TriggerOnEndTouchEx(int iTrigger, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	Hook_TriggerOnEndTouch("OnEndTouch", iTrigger, iOther, 0.0);
	return Plugin_Continue;
}

public Action Hook_FuncOnStartTouchEx(int iFunc, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	return Plugin_Continue;
}

public Action Hook_FuncOnTouchEx(int iFunc, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	return Plugin_Continue;
}

public Action Hook_FuncOnEndTouchEx(int iFunc, int iOther)
{
	if (MaxClients >= iOther >= 1 && IsClientInGhostMode(iOther)) return Plugin_Handled;
	return Plugin_Continue;
}

public void Hook_TriggerOnStartTouch(const char[] output, int caller, int activator, float delay)
{
	if (!g_bEnabled) return;
	
	if (!IsValidEntity(caller)) return;
	
	char sName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", sName, sizeof(sName));
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0)LogSF2Message("[SF2 TRIGGERS LOG] Trigger %i (trigger_multiple) %s start touch by %i (%s)!", caller, sName, activator, IsValidClient(activator) ? "Player" : "Entity");
	#endif	
	if (StrContains(sName, "sf2_escape_trigger", false) == 0)
	{
		if (IsRoundInEscapeObjective() && !g_bRestartSessionEnabled)
		{
			if (IsValidClient(activator) && IsPlayerAlive(activator) && !IsClientInDeathCam(activator) && !g_bPlayerEliminated[activator] && !DidClientEscape(activator))
			{
				ClientEscape(activator);
				TeleportClientToEscapePoint(activator);
			}
		}
	}
	
	PvP_OnTriggerStartTouch(caller, activator);
}

public void Hook_TriggerOnEndTouch(const char[] sOutput, int caller, int activator, float flDelay)
{
	if (!g_bEnabled) return;
	
	if (!IsValidEntity(caller)) return;
	
	char sName[64];
	GetEntPropString(caller, Prop_Data, "m_iName", sName, sizeof(sName));
	#if defined DEBUG	
	if (g_cvDebugDetail.IntValue > 0)LogSF2Message("[SF2 TRIGGERS LOG] Trigger %i (trigger_multiple) %s end touch by %i (%s)!", caller, sName, activator, IsValidClient(activator) ? "Player" : "Entity");
	#endif
}

public void Hook_TriggerTeleportOnStartTouch(const char[] output, int caller, int activator, float delay)
{
	if (!g_bEnabled) return;
	
	if (!IsValidEntity(caller)) return;
	
	int flags = GetEntProp(caller, Prop_Data, "m_spawnflags");
	if (((flags & TRIGGER_CLIENTS) && (flags & TRIGGER_NPCS)) || (flags & TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS))
	{
		if (IsValidClient(activator))
		{
			bool bChase = ClientHasMusicFlag(activator, MUSICF_CHASE);
			if (bChase)
			{
				// The player took a teleporter and is chased, and the boss can take it too, add the teleporter to the temp boss' goals.
				for (int i = 0; i < MAX_BOSSES; i++)
				{
					if (NPCGetUniqueID(i) == -1) continue;
					if (EntRefToEntIndex(g_iSlenderTarget[i]) == activator)
					{
						for (int ii = 0; ii < MAX_NPCTELEPORTER; ii++)
						{
							if (NPCChaserGetTeleporter(i, ii) == INVALID_ENT_REFERENCE)
							{
								NPCChaserSetTeleporter(i, ii, EntIndexToEntRef(caller));
								break;
							}
						}
					}
				}
			}
			return;
		}
		SF2NPC_Chaser NpcChaser = view_as<SF2NPC_Chaser>(NPCGetFromEntIndex(activator));
		if (NpcChaser.IsValid())
		{
			//A boss took a teleporter
			int iTeleporter = NpcChaser.GetTeleporter(0);
			if (iTeleporter == EntIndexToEntRef(caller)) //Remove our temp goal, and go back chase our target! GRAAAAAAAAAAAAh! Unless we have some other teleporters to take....fak.
				NpcChaser.SetTeleporter(0, INVALID_ENT_REFERENCE);
			if (MAX_NPCTELEPORTER > 2 && NpcChaser.GetTeleporter(1) != INVALID_ENT_REFERENCE)
			{
				for (int i = 0; i + 1 < MAX_NPCTELEPORTER; i++)
				{
					if (NpcChaser.GetTeleporter(i + 1) != INVALID_ENT_REFERENCE)
						NpcChaser.SetTeleporter(i, NpcChaser.GetTeleporter(i + 1));
					else
						NpcChaser.SetTeleporter(i, INVALID_ENT_REFERENCE);
				}
			}
		}
	}
	if (IsValidClient(activator))
	{
		bool bChase = ClientHasMusicFlag(activator, MUSICF_CHASE);
		if (bChase)
		{
			// The player took a teleporter and is chased, but the boss can't follow.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (NPCGetUniqueID(i) == -1) continue;
				if (EntRefToEntIndex(g_iSlenderTarget[i]) == activator)
				{
					g_bSlenderGiveUp[i] = true;
				}
			}
		}
	}
}
public Action Hook_PageOnTakeDamage(int page, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (g_bRestartSessionEnabled) return Plugin_Continue;
	
	if (IsValidClient(attacker))
	{
		if (!g_bPlayerEliminated[attacker])
		{
			if (damagetype & 0x80) // 0x80 == melee damage
			{
				CollectPage(page, attacker);
			}
		}
	}
	
	return Plugin_Continue;
}

void CollectPage(int page, int activator)
{
	if (SF_SpecialRound(SPECIALROUND_ESCAPETICKETS))
	{
		ClientEscape(activator);
		TeleportClientToEscapePoint(activator);
	}
	
	if (SF_SpecialRound(SPECIALROUND_PAGEREWARDS) && !g_bPlayerGettingPageReward[activator])
	{
		g_hPlayerPageRewardTimer[activator] = CreateTimer(3.0, Timer_GiveRandomPageReward, EntIndexToEntRef(activator), TIMER_FLAG_NO_MAPCHANGE);
		g_bPlayerGettingPageReward[activator] = true;
		EmitRollSound(activator);
	}
	
	if (SF_SpecialRound(SPECIALROUND_BOSSROULETTE))
	{
		char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH], sBossName[SF2_MAX_NAME_LENGTH];
		if (NPCGetCount() < 31)
		{
			if (g_cvDifficulty.IntValue < 4 || GetSelectableAdminBossProfileList().Length <= 0)
			{
				ArrayList hSelectableBosses = GetSelectableBossProfileList().Clone();
				if (hSelectableBosses.Length > 0)
				{
					hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
					NPCGetBossName(_, sBossName, sizeof(sBossName), sBuffer);
					EmitSoundToAll(SR_SOUND_SELECT_BR, _, SNDCHAN_AUTO, _, _, 0.75);
					SpecialRoundGameText(sBossName, "d_purgatory");
				}
				delete hSelectableBosses;
			}
			else
			{
				ArrayList hSelectableBosses = GetSelectableAdminBossProfileList().Clone();
				if (hSelectableBosses.Length > 0)
				{
					hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
					NPCGetBossName(_, sBossName, sizeof(sBossName), sBuffer);
					EmitSoundToAll(SR_SOUND_SELECT_BR, _, SNDCHAN_AUTO, _, _, 0.75);
					SpecialRoundGameText(sBossName, "d_purgatory");
				}
				delete hSelectableBosses;
			}
		}
		else
		{
			SpecialRoundGameText("You got lucky, no boss can be added.", "cappoint_progressbar_blocked");
		}
	}
	
	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && g_iPageMax <= 8)
	{
		for (int iReds = 1; iReds <= MaxClients; iReds++)
		{
			if (!IsValidClient(iReds) || 
				g_bPlayerEliminated[iReds] || 
				DidClientEscape(iReds) || 
				GetClientTeam(iReds) != TFTeam_Red || 
				!IsPlayerAlive(iReds)) continue;
			int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, iReds);
			float flHealthToRecover = float(iMaxHealth) / 10.0;
			int iHealthToRecover = RoundToNearest(flHealthToRecover) + GetEntProp(iReds, Prop_Send, "m_iHealth");
			SetEntityHealth(iReds, iHealthToRecover);
		}
	}
	
	SetPageCount(g_iPageCount + 1);
	g_iPlayerPageCount[activator] += 1;
	// Play page collect sound
	char sPageCollectSound[PLATFORM_MAX_PATH];
	int iPageCollectionSoundPitch = g_iPageSoundPitch;
	if (SF_SpecialRound(SPECIALROUND_DUCKS))
	{
		// Ducks!
		int iRandomSound = GetRandomInt(0, sizeof(g_sPageCollectDuckSounds) - 1);
		strcopy(sPageCollectSound, sizeof(sPageCollectSound), g_sPageCollectDuckSounds[iRandomSound]);
	}
	else
	{
		strcopy(sPageCollectSound, sizeof(sPageCollectSound), g_strPageCollectSound);
		
		if (IsValidEntity(page))
		{
			int iPageIndex = g_hPages.FindValue(EnsureEntRef(page));
			if (iPageIndex != -1)
			{
				SF2PageEntityData pageData;
				g_hPages.GetArray(iPageIndex, pageData, sizeof(pageData));
				
				if (pageData.CollectSound[0] != '\0')
					strcopy(sPageCollectSound, sizeof(sPageCollectSound), pageData.CollectSound);
				
				if (pageData.CollectSoundPitch > 0)
					iPageCollectionSoundPitch = pageData.CollectSoundPitch;
			}
		}
	}
	
	EmitSoundToAll(sPageCollectSound, activator, SNDCHAN_ITEM, SNDLEVEL_SCREAMING, _, _, iPageCollectionSoundPitch);
	
	Call_StartForward(fOnClientCollectPage);
	Call_PushCell(page);
	Call_PushCell(activator);
	Call_Finish();
	
	// Gives points. Credit to the makers of VSH/FF2.
	Handle hEvent = CreateEvent("player_escort_score", true);
	SetEventInt(hEvent, "player", activator);
	SetEventInt(hEvent, "points", 1);
	FireEvent(hEvent);
	
	int iPage2 = GetEntPropEnt(page, Prop_Send, "m_hOwnerEntity");
	if (iPage2 > MaxClients)
		RemoveEntity(iPage2);
	else
	{
		iPage2 = GetEntPropEnt(page, Prop_Send, "m_hEffectEntity");
		if (iPage2 > MaxClients)
			RemoveEntity(iPage2);
	}
	
	AcceptEntityInput(page, "FireUser1");
	AcceptEntityInput(page, "KillHierarchy");
}

static void EmitRollSound(int client)
{
	EmitSoundToClient(client, GENERIC_ROLL_TICK_1, client);
	CreateTimer(0.12, Timer_RollTick_Case2, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_RollTick_Case1(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case2, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case2(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case3, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case3(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case4, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case4(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case5, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case5(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case6, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case6(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case7, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case7(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case8, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case8(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case9, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case9(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.1, Timer_RollTick_Case10, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case10(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.3, Timer_RollTick_Case11, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case11(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.3, Timer_RollTick_Case12, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case12(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.3, Timer_RollTick_Case13, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case13(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_2, player);
	g_hPlayerPageRewardCycleTimer[player] = CreateTimer(0.5, Timer_RollTick_Case14, EntIndexToEntRef(player), TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_RollTick_Case14(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	EmitSoundToClient(player, GENERIC_ROLL_TICK_1, player);
	
	return Plugin_Stop;
}

public Action Timer_GiveRandomPageReward(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int player = EntRefToEntIndex(entref);
	if (!player || player == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	if (timer != g_hPlayerPageRewardTimer[player]) return Plugin_Stop;
	
	g_bPlayerGettingPageReward[player] = false;
	
	int iEffect = GetRandomInt(0, 11);
	switch (iEffect)
	{
		case 1:
		{
			TF2_IgnitePlayer(player, player);
		}
		case 2:
		{
			TF2_RegeneratePlayer(player);
		}
		case 3:
		{
			TF2_StunPlayer(player, 5.0, _, TF_STUNFLAG_BONKSTUCK);
		}
		case 4:
		{
			TF2_AddCondition(player, TFCond_CritOnFirstBlood, 8.0);
			EmitSoundToClient(player, CRIT_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 5:
		{
			TF2_MakeBleed(player, player, 8.0);
			EmitSoundToClient(player, BLEED_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 6:
		{
			int iRareEffect = GetRandomInt(0, 30);
			switch (iRareEffect)
			{
				case 1, 2, 3, 4, 5:
				{
					int iDeathEffect = GetRandomInt(1, 3);
					switch (iDeathEffect)
					{
						case 1:
						{
							EmitSoundToAll(EXPLODE_PLAYER, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							SDKHooks_TakeDamage(player, player, player, 9001.0, 262272, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
						}
						case 2:
						{
							EmitSoundToAll(FIREWORK_START, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							float fPush[3], flPlayerPos[3];
							GetClientAbsOrigin(player, flPlayerPos);
							flPlayerPos[2] += 10.0;
							fPush[2] = 4096.0;
							TeleportEntity(player, flPlayerPos, NULL_VECTOR, fPush);
							
							int iParticle = AttachParticle(player, FIREWORK_PARTICLE);
							CreateTimer(0.5, Timer_KillEntity, iParticle, TIMER_FLAG_NO_MAPCHANGE);
							
							CreateTimer(0.5, Timer_Firework_Explode, GetClientUserId(player), TIMER_FLAG_NO_MAPCHANGE);
						}
						case 3:
						{
							// define where the lightning strike ends
							float clientpos[3];
							GetClientAbsOrigin(player, clientpos);
							clientpos[2] -= 26; // increase y-axis by 26 to strike at player's chest instead of the ground
							
							// get random numbers for the x and y starting positions
							int randomx = GetRandomInt(-500, 500);
							int randomy = GetRandomInt(-500, 500);
							
							// define where the lightning strike starts
							float startpos[3];
							startpos[0] = clientpos[0] + randomx;
							startpos[1] = clientpos[1] + randomy;
							startpos[2] = clientpos[2] + 800;
							
							// define the color of the strike
							int color[4];
							color[0] = 255;
							color[1] = 255;
							color[2] = 255;
							color[3] = 255;
							
							// define the direction of the sparks
							float dir[3];
							
							TE_SetupBeamPoints(startpos, clientpos, g_LightningSprite, 0, 0, 0, 0.2, 20.0, 10.0, 0, 1.0, color, 3);
							TE_SendToAll();
							
							TE_SetupSparks(clientpos, dir, 5000, 1000);
							TE_SendToAll();
							
							TE_SetupEnergySplash(clientpos, dir, false);
							TE_SendToAll();
							
							TE_SetupSmoke(clientpos, g_SmokeSprite, 5.0, 10);
							TE_SendToAll();
							
							CreateTimer(0.01, Timer_AshRagdoll, GetClientUserId(player), TIMER_FLAG_NO_MAPCHANGE);
							
							SDKHooks_TakeDamage(player, player, player, 9001.0, 1048576, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
							
							EmitAmbientSound(SOUND_THUNDER, startpos, player, SNDLEVEL_RAIDSIREN);
						}
					}
				}
				case 6:
				{
					TF2_IgnitePlayer(player, player);
				}
				case 7:
				{
					TF2_RegeneratePlayer(player);
				}
				case 8:
				{
					TF2_StunPlayer(player, 5.0, _, TF_STUNFLAG_BONKSTUCK);
				}
				case 9:
				{
					TF2_AddCondition(player, TFCond_CritOnFirstBlood, 8.0);
					EmitSoundToClient(player, CRIT_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 14:
				{
					TF2_MakeBleed(player, player, 10.0);
					EmitSoundToClient(player, BLEED_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 10, 11, 12, 13:
				{
					TF2_AddCondition(player, TFCond_UberchargedCanteen, 5.0);
					EmitSoundToClient(player, UBER_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 15, 16:
				{
					EmitSoundToClient(player, LOSE_SPRINT_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
					g_iPlayerSprintPoints[player] = 0;
				}
				case 17:
				{
					TF2_AddCondition(player, TFCond_Jarated, 10.0);
					EmitSoundToClient(player, JARATE_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 18:
				{
					TF2_AddCondition(player, TFCond_Gas, 10.0);
					EmitSoundToClient(player, GAS_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 19:
				{
					TF2_AddCondition(player, TFCond_SpeedBuffAlly, 5.0);
				}
				case 20:
				{
					TF2_AddCondition(player, TFCond_CritCola, 16.0);
					EmitSoundToClient(player, MINICRIT_BUFF, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 21:
				{
					TF2_AddCondition(player, TFCond_DefenseBuffed, 10.0);
					EmitSoundToClient(player, MINICRIT_BUFF, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				case 22:
				{
					TF2_AddCondition(player, TFCond_HalloweenQuickHeal, 3.0);
					TF2_AddCondition(player, TFCond_UberchargedCanteen, 1.0);
					EmitSoundToClient(player, UBER_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
				default:
				{
					EmitSoundToClient(player, NO_EFFECT_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
				}
			}
		}
		case 7:
		{
			TF2_AddCondition(player, TFCond_Jarated, 10.0);
			EmitSoundToClient(player, JARATE_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 8:
		{
			TF2_AddCondition(player, TFCond_Gas, 10.0);
			EmitSoundToClient(player, GAS_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 9:
		{
			TF2_AddCondition(player, TFCond_SpeedBuffAlly, 5.0);
		}
		case 10:
		{
			TF2_AddCondition(player, TFCond_CritCola, 16.0);
			EmitSoundToClient(player, MINICRIT_BUFF, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 11:
		{
			TF2_AddCondition(player, TFCond_DefenseBuffed, 10.0);
			EmitSoundToClient(player, MINICRIT_BUFF, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 12:
		{
			TF2_AddCondition(player, TFCond_HalloweenQuickHeal, 3.0);
			TF2_AddCondition(player, TFCond_UberchargedCanteen, 1.0);
			EmitSoundToClient(player, UBER_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		default:
		{
			EmitSoundToClient(player, NO_EFFECT_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
	}
	g_hPlayerPageRewardTimer[player] = null;
	g_hPlayerPageRewardCycleTimer[player] = null;
	
	return Plugin_Stop;
}

public Action Timer_Firework_Explode(Handle hTimer, int iUserId) {
	int client = GetClientOfUserId(iUserId);
	if (!client) return Plugin_Stop;
	
	EmitSoundToAll(FIREWORK_EXPLOSION, client);
	SDKHooks_TakeDamage(client, client, client, 9001.0, 1327104, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
	return Plugin_Stop;
}

//	==========================================================
//	GENERIC iClient HOOKS AND FUNCTIONS
//	==========================================================


public Action OnPlayerRunCmd(int iClient, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (!g_bEnabled) return Plugin_Continue;
	
	bool bChanged = false;
	
	// Check impulse (block spraying and built-in flashlight)
	switch (impulse)
	{
		case 100:
		{
			impulse = 0;
		}
		case 201, 202:
		{
			if (IsClientInGhostMode(iClient))
			{
				impulse = 0;
			}
		}
	}
	for (int i = 0; i < MAX_BUTTONS; i++)
	{
		int button = (1 << i);
		
		if ((buttons & button))
		{
			if (!(g_iPlayerLastButtons[iClient] & button))
			{
				AFK_SetTime(iClient);
				ClientOnButtonPress(iClient, button);
				if (button == IN_ATTACK2)
				{
					if (IsClientInPvP(iClient) && !(buttons & IN_ATTACK))
					{
						if (TF2_GetPlayerClass(iClient) == TFClass_Medic)
						{
							int iWeapon = GetPlayerWeaponSlot(iClient, 0);
							if (iWeapon > MaxClients)
							{
								char sWeaponClass[64];
								GetEdictClassname(iWeapon, sWeaponClass, sizeof(sWeaponClass));
								if (strcmp(sWeaponClass, "tf_weapon_crossbow") == 0)
								{
									int iClip = GetEntProp(iWeapon, Prop_Send, "m_iClip1");
									if (iClip > 0)
									{
										buttons |= IN_ATTACK;
										g_iPlayerLastButtons[iClient] = buttons;
										buttons &= ~IN_ATTACK2;
										bChanged = true;
										
										RequestFrame(Frame_ClientHealArrow, iClient);
										
										EmitSoundToAll(")weapons/crusaders_crossbow_shoot.wav", iClient, SNDCHAN_WEAPON, SNDLEVEL_MINIBIKE); //Fix client's predictions.
									}
								}
							}
						}
					}
				}
			}
			if (button == IN_ATTACK2)
			{
				if (!g_bPlayerEliminated[iClient])
				{
					g_iPlayerLastButtons[iClient] = buttons;
					int iWeaponActive = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
					if (iWeaponActive > MaxClients && IsTauntWep(iWeaponActive))
					{
						buttons &= ~IN_ATTACK2; //Tough break update made players able to taunt with secondary attack. Block this feature.
						bChanged = true;
					}
				}
			}
			/*if (!g_bPlayerEliminated[iClient] && button == IN_JUMP && g_iPlayerSprintPoints[iClient] < 7)
			{
				g_iPlayerLastButtons[iClient] = buttons;
				buttons &= ~IN_JUMP;
				bChanged = true;
			}*/
		}
		else if ((g_iPlayerLastButtons[iClient] & button))
		{
			ClientOnButtonRelease(iClient, button);
		}
	}
	
	AFK_CheckTime(iClient);

	if (!bChanged) g_iPlayerLastButtons[iClient] = buttons;
	return (bChanged) ? Plugin_Changed : Plugin_Continue;
}

public void OnClientCookiesCached(int iClient)
{
	if (!g_bEnabled) return;
	
	// Load our saved settings.
	char sCookie[64];
	GetClientCookie(iClient, g_hCookie, sCookie, sizeof(sCookie));
	
	g_iPlayerQueuePoints[iClient] = 0;
	
	g_iPlayerPreferences[iClient].PlayerPreference_PvPAutoSpawn = false;
	g_iPlayerPreferences[iClient].PlayerPreference_ShowHints = true;
	g_iPlayerPreferences[iClient].PlayerPreference_MuteMode = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_FilmGrain = false;
	g_iPlayerPreferences[iClient].PlayerPreference_EnableProxySelection = true;
	g_iPlayerPreferences[iClient].PlayerPreference_FlashlightTemperature = 6;
	g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_GhostModeTeleportState = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_GroupOutline = true;
	g_iPlayerPreferences[iClient].PlayerPreference_ProxyShowMessage = g_cvPlayerProxyAsk.BoolValue;
	g_iPlayerPreferences[iClient].PlayerPreference_PvPSpawnProtection = true;
	g_iPlayerPreferences[iClient].PlayerPreference_ViewBobbing = g_cvPlayerViewbobEnabled.BoolValue;
	
	if (sCookie[0] != '\0')
	{
		char s2[15][32];
		int count = ExplodeString(sCookie, " ; ", s2, 15, 32);
		
		if (count > 0)
			g_iPlayerQueuePoints[iClient] = StringToInt(s2[0]);
		if (count > 1)
			g_iPlayerPreferences[iClient].PlayerPreference_PvPAutoSpawn = view_as<bool>(StringToInt(s2[1]));
		if (count > 2)
			g_iPlayerPreferences[iClient].PlayerPreference_ShowHints = view_as<bool>(StringToInt(s2[2]));
		if (count > 3)
			g_iPlayerPreferences[iClient].PlayerPreference_MuteMode = StringToInt(s2[3]);
		if (count > 4)
			g_iPlayerPreferences[iClient].PlayerPreference_FilmGrain = view_as<bool>(StringToInt(s2[4]));
		if (count > 5)
			g_iPlayerPreferences[iClient].PlayerPreference_EnableProxySelection = view_as<bool>(StringToInt(s2[5]));
		if (count > 6)
			g_iPlayerPreferences[iClient].PlayerPreference_FlashlightTemperature = StringToInt(s2[6]);
		if (count > 7)
			g_iPlayerPreferences[iClient].PlayerPreference_PvPSpawnProtection = view_as<bool>(StringToInt(s2[7]));
		if (count > 8)
			g_iPlayerPreferences[iClient].PlayerPreference_ProxyShowMessage = view_as<bool>(StringToInt(s2[8]));
		if (count > 9)
			g_iPlayerPreferences[iClient].PlayerPreference_ViewBobbing = view_as<bool>(StringToInt(s2[9]));
		if (count > 10)
			g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState = StringToInt(s2[10]);
		if (count > 11)
			g_iPlayerPreferences[iClient].PlayerPreference_GroupOutline = view_as<bool>(StringToInt(s2[11]));
		if (count > 12)
			g_iPlayerPreferences[iClient].PlayerPreference_GhostModeTeleportState = StringToInt(s2[12]);
	}
}

public void OnClientPutInServer(int iClient)
{
	if (!g_bEnabled) return;
	
	if (IsClientSourceTV(iClient))g_iSourceTVUserID = GetClientUserId(iClient);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START OnClientPutInServer(%d)", iClient);
	#endif
	
	ClientSetPlayerGroup(iClient, -1);
	
	g_flLastCommandTime[iClient] = GetEngineTime();
	
	g_bPlayerEscaped[iClient] = false;
	g_bPlayerEliminated[iClient] = true;
	g_bPlayerChoseTeam[iClient] = false;
	g_bPlayerPlayedSpecialRound[iClient] = true;
	g_bPlayerPlayedNewBossRound[iClient] = true;
	
	g_iPlayerPreferences[iClient].PlayerPreference_PvPAutoSpawn = false;
	g_iPlayerPreferences[iClient].PlayerPreference_ProjectedFlashlight = false;
	
	g_iPlayerPageCount[iClient] = 0;
	g_iPlayerDesiredFOV[iClient] = 90;
	
	SDKHook(iClient, SDKHook_PreThink, Hook_ClientPreThink);
	SDKHook(iClient, SDKHook_SetTransmit, Hook_ClientSetTransmit);
	SDKHook(iClient, SDKHook_TraceAttack, Hook_PvPPlayerTraceAttack);
	SDKHook(iClient, SDKHook_OnTakeDamage, Hook_ClientOnTakeDamage);
	
	SDKHook(iClient, SDKHook_WeaponEquipPost, Hook_ClientWeaponEquipPost);
	
	DHookEntity(g_hSDKWantsLagCompensationOnEntity, true, iClient);
	
	DHookEntity(g_hSDKShouldTransmit, true, iClient);
	
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i)) continue;
		
		SetPlayerGroupInvitedPlayer(i, iClient, false);
		SetPlayerGroupInvitedPlayerCount(i, iClient, 0);
		SetPlayerGroupInvitedPlayerTime(i, iClient, 0.0);
	}
	
	ClientResetStatic(iClient);
	ClientResetSlenderStats(iClient);
	ClientResetCampingStats(iClient);
	ClientResetOverlay(iClient);
	ClientResetJumpScare(iClient);
	ClientUpdateListeningFlags(iClient);
	ClientUpdateMusicSystem(iClient);
	ClientChaseMusicReset(iClient);
	ClientChaseMusicSeeReset(iClient);
	ClientAlertMusicReset(iClient);
	Client20DollarsMusicReset(iClient);
	Client90sMusicReset(iClient);
	ClientMusicReset(iClient);
	ClientResetProxy(iClient);
	ClientResetHints(iClient);
	ClientResetScare(iClient);
	
	ClientResetDeathCam(iClient);
	ClientResetFlashlight(iClient);
	ClientDeactivateUltravision(iClient);
	ClientResetSprint(iClient);
	ClientResetBreathing(iClient);
	ClientResetBlink(iClient);
	ClientResetInteractiveGlow(iClient);
	ClientDisableConstantGlow(iClient);
	
	ClientSetScareBoostEndTime(iClient, -1.0);
	
	ClientStartProxyAvailableTimer(iClient);
	
	if (!IsFakeClient(iClient))
	{
		// See if the player is using the projected flashlight.
		QueryClientConVar(iClient, "mat_supportflashlight", OnClientGetProjectedFlashlightSetting);
		
		// Get desired FOV.
		QueryClientConVar(iClient, "fov_desired", OnClientGetDesiredFOV);
	}
	
	PvP_OnClientPutInServer(iClient);
	
	#if defined DEBUG
	g_iPlayerDebugFlags[iClient] = 0;
	
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END OnClientPutInServer(%d)", iClient);
	#endif
}

public void OnClientGetProjectedFlashlightSetting(QueryCookie cookie, int iClient, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (result != ConVarQuery_Okay)
	{
		LogError("Warning: Player %N failed to query for ConVar mat_supportflashlight", iClient);
		return;
	}
	
	if (StringToInt(cvarValue))
	{
		char sAuth[64];
		GetClientAuthId(iClient, AuthId_Engine, sAuth, sizeof(sAuth));
		
		g_iPlayerPreferences[iClient].PlayerPreference_ProjectedFlashlight = true;
		LogSF2Message("Player %N (%s) has mat_supportflashlight enabled, projected flashlight will be used", iClient, sAuth);
	}
}

public void OnClientGetDesiredFOV(QueryCookie cookie, int iClient, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (!IsValidClient(iClient)) return;
	
	g_iPlayerDesiredFOV[iClient] = StringToInt(cvarValue);
}

public void OnClientDisconnect(int iClient)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START OnClientDisconnect(%d)", iClient);
	#endif
	
	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, iClient);
	delete message;
	EndMessage();
	
	g_bSeeUpdateMenu[iClient] = false;
	g_bPlayerEscaped[iClient] = false;
	g_bPlayerNoPoints[iClient] = false;
	g_bAdminNoPoints[iClient] = false;
	g_bAdminAllTalk[iClient] = false;
	g_bPlayerIn1UpCondition[iClient] = false;
	g_bPlayerDied1Up[iClient] = false;
	g_bPlayerFullyDied1Up[iClient] = false;

	// Save and reset settings for the next iClient.
	ClientSaveCookies(iClient);
	ClientSetPlayerGroup(iClient, -1);
	
	// Reset variables.
	g_iPlayerPreferences[iClient].PlayerPreference_ShowHints = true;
	g_iPlayerPreferences[iClient].PlayerPreference_MuteMode = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_FilmGrain = false;
	g_iPlayerPreferences[iClient].PlayerPreference_EnableProxySelection = true;
	g_iPlayerPreferences[iClient].PlayerPreference_ProjectedFlashlight = false;
	g_iPlayerPreferences[iClient].PlayerPreference_FlashlightTemperature = 6;
	g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_GhostModeTeleportState = 0;
	g_iPlayerPreferences[iClient].PlayerPreference_GroupOutline = true;
	g_iPlayerPreferences[iClient].PlayerPreference_ProxyShowMessage = g_cvPlayerProxyAsk.BoolValue;
	g_iPlayerPreferences[iClient].PlayerPreference_PvPSpawnProtection = true;
	g_iPlayerPreferences[iClient].PlayerPreference_ViewBobbing = g_cvPlayerViewbobEnabled.BoolValue;
	
	// Reset any iClient functions that may be still active.
	ClientResetOverlay(iClient);
	ClientResetFlashlight(iClient);
	ClientDeactivateUltravision(iClient);
	ClientSetGhostModeState(iClient, false);
	ClientResetInteractiveGlow(iClient);
	ClientDisableConstantGlow(iClient);
	
	ClientStopProxyForce(iClient);
	
	Network_ResetClient(iClient);
	
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	if (!IsRoundInWarmup())
	{
		if (g_bPlayerPlaying[iClient] && !g_bPlayerEliminated[iClient])
		{
			if (!IsRoundPlaying())
			{
				// Force the next player in queue to take my place, if any.
				ForceInNextPlayersInQueue(1, true);
			}
			else
			{
				if (!IsRoundEnding())
				{
					CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
	
	g_bPlayerEliminated[iClient] = true;
	// Reset queue points global variable.
	g_iPlayerQueuePoints[iClient] = 0;
	
	PvP_OnClientDisconnect(iClient);
	AFK_SetTime(iClient, false);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END OnClientDisconnect(%d)", iClient);
	#endif
}

public void OnClientDisconnect_Post(int iClient)
{
	g_iPlayerLastButtons[iClient] = 0;
}

public void TF2_OnWaitingForPlayersStart()
{
	g_bRoundWaitingForPlayers = true;
}

public void TF2_OnWaitingForPlayersEnd()
{
	g_bRoundWaitingForPlayers = false;
}

SF2RoundState GetRoundState()
{
	return g_iRoundState;
}

void SetRoundTime(int iCurrentTime)
{
	int iOldRoundTime = g_iRoundTime;
	if (iCurrentTime == iOldRoundTime)
		return;
	
	g_iRoundTime = iCurrentTime;
	
	switch (GetRoundState())
	{
		case SF2RoundState_Escape:
		{
			if (SF_IsSurvivalMap() && iCurrentTime <= g_iTimeEscape && iOldRoundTime > g_iTimeEscape && g_GamerulesEntity.IsValid())
			{
				g_GamerulesEntity.FireOutput("OnSurvivalComplete");
			}
		}
	}
}

void SetRoundState(SF2RoundState iRoundState)
{
	if (g_iRoundState == iRoundState) return;
	
	PrintToServer("SetRoundState(%d)", iRoundState);
	
	SF2RoundState iOldRoundState = GetRoundState();
	g_iRoundState = iRoundState;
	
	//Tutorial_OnRoundStateChange(iOldRoundState, g_iRoundState);
	
	// Cleanup from old roundstate if needed.
	switch (iOldRoundState)
	{
		case SF2RoundState_Waiting:
		{
		}
		case SF2RoundState_Intro:
		{
			g_hRoundIntroTimer = null;
			if (!IsInfiniteFlashlightEnabled())g_iNightvisionType = GetRandomInt(0, 2);
			else g_iNightvisionType = 1;

			// Enable movement on players.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || g_bPlayerEliminated[i]) continue;
				SetEntityFlags(i, GetEntityFlags(i) & ~FL_FROZEN);
			}

			// Fade in.
			float flFadeTime = g_flRoundIntroFadeDuration;
			int iFadeFlags = SF_FADE_IN | FFADE_PURGE;
			
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || g_bPlayerEliminated[i]) continue;
				UTIL_ScreenFade(i, FixedUnsigned16(flFadeTime, 1 << 12), 0, iFadeFlags, g_iRoundIntroFadeColor[0], g_iRoundIntroFadeColor[1], g_iRoundIntroFadeColor[2], g_iRoundIntroFadeColor[3]);
			}
		}
		case SF2RoundState_Grace:
		{
			g_hRoundGraceTimer = null;

			for (int iClient = 1; iClient <= MaxClients; iClient++)
			{
				if (!IsClientParticipating(iClient))
				{
					g_bPlayerEliminated[iClient] = true;
				}

				if (IsValidClient(iClient))
				{
					TF2Attrib_RemoveByDefIndex(iClient, 10);

					if (IsClientParticipating(iClient) && GetClientTeam(iClient) == TFTeam_Blue && g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState == 1)
					{
						CreateTimer(0.25, Timer_ToggleGhostModeCommand, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}

			if (g_bRestartSessionEnabled)
			{
				ArrayList hSpawnPoint = new ArrayList();
#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hSpawnPoint in SetRoundState(SF2RoundState_Grace).", hSpawnPoint);
#endif
				float flTeleportPos[3];
				int ent = -1, iSpawnTeam = 0;
				while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
				{
					iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
					if (iSpawnTeam == TFTeam_Red)
					{
						hSpawnPoint.Push(ent);
					}
					
				}
				ent = -1;
				if (hSpawnPoint.Length > 0)
				{
					for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
					{
						ent = hSpawnPoint.Get(GetRandomInt(0, hSpawnPoint.Length - 1));
						
						if (IsValidEntity(ent))
						{
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
							SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iNPCIndex);
							if (!Npc.IsValid()) continue;
							SpawnSlender(Npc, flTeleportPos);
						}
					}
				}
				delete hSpawnPoint;
#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hSpawnPoint in SetRoundState(SF2RoundState_Grace).", hSpawnPoint);
#endif
			}

			CPrintToChatAll("{dodgerblue}%t", "SF2 Grace Period End");
		}
		case SF2RoundState_Active:
		{
			g_hRoundTimer = null;
			g_bPlayersAreCritted = false;
			g_bPlayersAreMiniCritted = false;
			g_flRoundTimeMessage = 0.0;
			bool bNightVision = (g_cvNightvisionEnabled.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
			if (bNightVision)
			{
				switch (g_iNightvisionType)
				{
					case 2:
					{
						g_hBlueNightvisionOutlineTimer = CreateTimer(10.0, Timer_BlueNightvisionOutline, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					}
					default:
					{
						g_hBlueNightvisionOutlineTimer = null;
					}
				}
			}
		}
		case SF2RoundState_Escape:
		{
			g_hRoundTimer = null;
		}
		case SF2RoundState_Outro:
		{
		}
	}
	
	switch (g_iRoundState)
	{
		case SF2RoundState_Waiting:
		{
		}
		case SF2RoundState_Intro:
		{
			g_hRoundIntroTimer = null;
			g_flRoundTimeMessage = 0.0;
			g_bProxySurvivalRageMode = false;
			g_hRenevantWaveTimer = null;
			g_bRenevantMultiEffect = false;
			g_bRenevantBeaconEffect = false;
			g_bRenevant90sEffect = false;
			g_bRenevantMarkForDeath = false;
			if (g_cvRestartSession.BoolValue)
			{
				g_bRestartSessionEnabled = false;
				g_cvRestartSession.SetBool(false);
			}
			StartIntroTextSequence();
			
			// Gather data on the intro parameters set by the map.
			float flHoldTime = g_flRoundIntroFadeHoldTime;
			g_hRoundIntroTimer = CreateTimer(flHoldTime, Timer_ActivateRoundFromIntro, _, TIMER_FLAG_NO_MAPCHANGE);
			
			// Trigger any intro logic entities, if any.
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
			{
				char sName[64];
				GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
				if (strcmp(sName, "sf2_intro_relay", false) == 0)
				{
					AcceptEntityInput(ent, "Trigger");
					break;
				}
			}
		}
		case SF2RoundState_Grace:
		{
			// Start the grace period timer.
			g_hRoundGraceTimer = CreateTimer(g_cvGraceTime.FloatValue, Timer_RoundGrace, _, TIMER_FLAG_NO_MAPCHANGE);
			
			CreateTimer(2.0, Timer_RoundStart, _, TIMER_FLAG_NO_MAPCHANGE);
			
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || g_bPlayerEliminated[i]) continue;

				TF2Attrib_SetByDefIndex(i, 10, 7.0);
			}
		}
		case SF2RoundState_Active:
		{
			// Initialize the main round timer.
			if (g_iRoundTimeLimit > 0)
			{
				// Set round time.
				SetRoundTime(g_iRoundTimeLimit);
				g_hRoundTimer = CreateTimer(1.0, Timer_RoundTime, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				// Infinite round time.
				g_hRoundTimer = null;
			}
		}
		case SF2RoundState_Escape:
		{
			// Initialize the escape timer, if needed.
			if (g_iRoundEscapeTimeLimit > 0)
			{
				SetRoundTime(g_iRoundEscapeTimeLimit);
				g_hRoundTimer = CreateTimer(1.0, Timer_RoundTimeEscape, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				g_hRoundTimer = null;
			}
			
			char sName[32];
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
			{
				GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
				if (!SF_IsBoxingMap())
				{
					if (strcmp(sName, "sf2_logic_escape", false) == 0)
					{
						AcceptEntityInput(ent, "FireUser1");
						break;
					}
				}
				else
				{
					if (strcmp(sName, "sf2_logic_escape", false) == 0)
					{
						AcceptEntityInput(ent, "FireUser1");
						break;
					}
				}
			}
			if (SF_IsBoxingMap())
			{
				g_cvDifficulty.IntValue = Difficulty_Normal;
				CPrintToChatAll("%t", "SF2 Boxing Initiate");
				CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
				
				for (int iBoss = 0; iBoss < MAX_BOSSES; iBoss++)
				{
					SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iBoss);
					if (!Npc.IsValid()) continue;
					if (NPCChaserIsBoxingBoss(Npc.Index)) g_iSlenderBoxingBossCount += 1;
				}
			}
			else if (SF_IsRenevantMap())
			{
				NPCRemoveAll();
				Renevant_SetWave(1, true);
			}
		}
		case SF2RoundState_Outro:
		{
			if (!g_bRoundHasEscapeObjective)
			{
				// Teleport winning players to the escape point.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i)) continue;
					
					if (!g_bPlayerEliminated[i])
					{
						TeleportClientToEscapePoint(i);
					}
				}
			}
			
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i)) continue;
				
				if (IsClientInGhostMode(i))
				{
					// Take the player out of ghost mode.
					ClientSetGhostModeState(i, false);
					TF2_RespawnPlayer(i);
				}
				else if (g_bPlayerProxy[i])
				{
					TF2_RespawnPlayer(i);
				}
				
				if (!g_bPlayerEliminated[i])
				{
					// Give them back all their weapons so they can beat the crap out of the other team.
					TF2_RegeneratePlayer(i);
				}
				
				ClientUpdateListeningFlags(i);
			}
		}
	}
	
	SF2MapEntity_OnRoundStateChanged(iRoundState, iOldRoundState);
	
	Call_StartForward(fOnRoundStateChange);
	Call_PushCell(iOldRoundState);
	Call_PushCell(g_iRoundState);
	Call_Finish();
}

bool IsRoundPlaying()
{
	return (GetRoundState() == SF2RoundState_Active || GetRoundState() == SF2RoundState_Escape);
}

bool IsRoundInEscapeObjective()
{
	return view_as<bool>(GetRoundState() == SF2RoundState_Escape);
}

bool IsRoundInWarmup()
{
	return view_as<bool>(GetRoundState() == SF2RoundState_Waiting);
}

bool IsRoundInIntro()
{
	return view_as<bool>(GetRoundState() == SF2RoundState_Intro);
}

bool IsRoundEnding()
{
	return view_as<bool>(GetRoundState() == SF2RoundState_Outro);
}

bool IsInfiniteBlinkEnabled()
{
	return view_as<bool>(g_bRoundInfiniteBlink || (g_cvPlayerInfiniteBlinkOverride.IntValue == 1));
}

bool IsInfiniteSprintEnabled()
{
	return view_as<bool>(g_bRoundInfiniteSprint || (g_cvPlayerInfiniteSprintOverride.IntValue == 1));
}

#define SF2_PLAYER_HUD_BLINK_SYMBOL "B"
#define SF2_PLAYER_HUD_FLASHLIGHT_SYMBOL "ϟ"
#define SF2_PLAYER_HUD_BAR_SYMBOL "|"
#define SF2_PLAYER_HUD_BAR_MISSING_SYMBOL ""
#define SF2_PLAYER_HUD_INFINITY_SYMBOL "∞"
#define SF2_PLAYER_HUD_SPRINT_SYMBOL "»"

public Action Timer_ClientAverageUpdate(Handle timer)
{
	if (timer != g_hClientAverageUpdateTimer) return Plugin_Stop;
	
	if (!g_bEnabled) return Plugin_Stop;
	
	if (IsRoundInWarmup() || IsRoundEnding()) return Plugin_Continue;
	
	if (SF_SpecialRound(SPECIALROUND_REALISM)) return Plugin_Continue;
	
	// First, process through HUD stuff.
	char buffer[256];
	
	static iHudColorHealthy[3] = { 150, 255, 150 };
	static iHudColorCritical[3] = { 255, 10, 10 };
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		
		if (IsPlayerAlive(i) && !IsClientInDeathCam(i))
		{
			if (!g_bPlayerEliminated[i])
			{
				if (DidClientEscape(i)) continue;
				
				int iMaxBars = 12;
				int iBars;
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					iBars = RoundToCeil(float(iMaxBars) * ClientGetBlinkMeter(i));
					if (iBars > iMaxBars)iBars = iMaxBars;
					
					FormatEx(buffer, sizeof(buffer), "%s  ", SF2_PLAYER_HUD_BLINK_SYMBOL);
					
					if (IsInfiniteBlinkEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < iMaxBars; i2++)
						{
							if (i2 < iBars)
							{
								StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_SYMBOL);
							}
							else
							{
								StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_MISSING_SYMBOL);
							}
						}
					}
				}
				if (!SF_SpecialRound(SPECIALROUND_LIGHTSOUT) && !SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					iBars = RoundToCeil(float(iMaxBars) * ClientGetFlashlightBatteryLife(i));
					if (iBars > iMaxBars)iBars = iMaxBars;
					
					char sBuffer2[64];
					FormatEx(sBuffer2, sizeof(sBuffer2), "\n%s  ", SF2_PLAYER_HUD_FLASHLIGHT_SYMBOL);
					StrCat(buffer, sizeof(buffer), sBuffer2);
					
					if (IsInfiniteFlashlightEnabled())
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
					}
					else
					{
						for (int i2 = 0; i2 < iMaxBars; i2++)
						{
							if (i2 < iBars)
							{
								StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_SYMBOL);
							}
							else
							{
								StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_MISSING_SYMBOL);
							}
						}
					}
				}
				
				iBars = RoundToCeil(float(iMaxBars) * (float(ClientGetSprintPoints(i)) / 100.0));
				if (iBars > iMaxBars)iBars = iMaxBars;
				
				char sBuffer2[64];
				FormatEx(sBuffer2, sizeof(sBuffer2), "\n%s  ", SF2_PLAYER_HUD_SPRINT_SYMBOL);
				StrCat(buffer, sizeof(buffer), sBuffer2);
				
				if (IsInfiniteSprintEnabled())
				{
					StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_INFINITY_SYMBOL);
				}
				else
				{
					for (int i2 = 0; i2 < iMaxBars; i2++)
					{
						if (i2 < iBars)
						{
							StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_SYMBOL);
						}
						else
						{
							StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_MISSING_SYMBOL);
						}
					}
				}
				
				
				float flHealthRatio = float(GetEntProp(i, Prop_Send, "m_iHealth")) / float(SDKCall(g_hSDKGetMaxHealth, i));
				
				int iColor[3];
				for (int i2 = 0; i2 < 3; i2++)
				{
					iColor[i2] = RoundFloat(float(iHudColorHealthy[i2]) + (float(iHudColorCritical[i2] - iHudColorHealthy[i2]) * (1.0 - flHealthRatio)));
				}
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					SetHudTextParams(0.035, 0.83, 
						0.3, 
						iColor[0], 
						iColor[1], 
						iColor[2], 
						40, 
						_, 
						1.0, 
						0.07, 
						0.5);
				}
				else if (SF_IsRaidMap() || SF_IsBoxingMap())
				{
					SetHudTextParams(0.035, 0.43, 
						0.3, 
						iColor[0], 
						iColor[1], 
						iColor[2], 
						40, 
						_, 
						1.0, 
						0.07, 
						0.5);
				}
				ShowSyncHudText(i, g_hHudSync2, buffer);
				buffer[0] = '\0';
			}
			else
			{
				if (g_bPlayerProxy[i])
				{
					int iMaxBars = 12;
					int iBars = RoundToCeil(float(iMaxBars) * (float(g_iPlayerProxyControl[i]) / 100.0));
					if (iBars > iMaxBars)iBars = iMaxBars;
					
					strcopy(buffer, sizeof(buffer), "CONTROL\n");
					
					for (int i2 = 0; i2 < iBars; i2++)
					{
						StrCat(buffer, sizeof(buffer), SF2_PLAYER_HUD_BAR_SYMBOL);
					}
					
					SetHudTextParams(-1.0, 0.83, 
						0.3, 
						SF2_HUD_TEXT_COLOR_R, 
						SF2_HUD_TEXT_COLOR_G, 
						SF2_HUD_TEXT_COLOR_B, 
						40, 
						_, 
						1.0, 
						0.07, 
						0.5);
					ShowSyncHudText(i, g_hHudSync2, buffer);
				}
			}
		}
		ClientUpdateListeningFlags(i);
		ClientUpdateMusicSystem(i);
	}
	
	return Plugin_Continue;
}

stock bool IsClientParticipating(int iClient)
{
	if (!IsValidClient(iClient)) return false;
	
	if (view_as<bool>(GetEntProp(iClient, Prop_Send, "m_bIsCoaching")))
	{
		// Who would coach in this game?
		return false;
	}
	
	int iTeam = GetClientTeam(iClient);
	
	switch (iTeam)
	{
		case TFTeam_Unassigned, TFTeam_Spectator: return false;
	}
	
	if (view_as<int>(TF2_GetPlayerClass(iClient)) == 0)
	{
		// Player hasn't chosen a class? What.
		return false;
	}
	
	return true;
}

ArrayList GetQueueList()
{
	ArrayList hArray = new ArrayList(3);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArray in GetQueueList.", hArray);
	#endif
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientParticipating(i)) continue;
		if (IsPlayerGroupActive(ClientGetPlayerGroup(i))) continue;
		
		int index = hArray.Push(i);
		hArray.Set(index, g_iPlayerQueuePoints[i], 1);
		hArray.Set(index, false, 2);
	}
	
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i)) continue;
		int index = hArray.Push(i);
		hArray.Set(index, GetPlayerGroupQueuePoints(i), 1);
		hArray.Set(index, true, 2);
	}
	
	if (hArray.Length > 0) hArray.SortCustom(SortQueueList);
	return hArray;
}

stock int GetOppositeTeam(int iTeam) {
	return iTeam == 2 ? 3 : 2;
}

stock int GetOppositeTeamOf(int client) {
	int iTeam = GetClientTeam(client);
	return GetOppositeTeam(iTeam);
}

void SetClientPlayState(int iClient, bool bState, bool bEnablePlay=true)
{
	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, iClient);
	delete message;
	EndMessage();

	if (bState)
	{
		if (!g_bPlayerEliminated[iClient]) return;
		if (g_bPlayerProxy[iClient]) return;
		
		g_bPlayerCalledForNightmare[iClient] = false;
		g_bPlayerEliminated[iClient] = false;
		g_bPlayerPlaying[iClient] = bEnablePlay;
		g_hPlayerSwitchBlueTimer[iClient] = null;
		
		ClientSetGhostModeState(iClient, false);
		
		PvP_SetPlayerPvPState(iClient, false, false, false);
		
		if (g_bSpecialRound) 
		{
			SetClientPlaySpecialRoundState(iClient, true);
		}
		
		if (g_bNewBossRound) 
		{
			SetClientPlayNewBossRoundState(iClient, true);
		}
		
		if (TF2_GetPlayerClass(iClient) == view_as<TFClassType>(0))
		{
			// Player hasn't chosen a class for some reason. Choose one for him.
			TF2_SetPlayerClass(iClient, view_as<TFClassType>(GetRandomInt(1, 9)), true, true);
		}
		
		ChangeClientTeamNoSuicide(iClient, TFTeam_Red);
	}
	else
	{
		if (g_bPlayerEliminated[iClient]) return;
		
		g_bPlayerEliminated[iClient] = true;
		g_bPlayerPlaying[iClient] = false;
		
		ChangeClientTeamNoSuicide(iClient, TFTeam_Blue);
	}

}
/*
bool DidClientPlayNewBossRound(int iClient)
{
	return g_bPlayerPlayedNewBossRound[iClient];
}
*/
void SetClientPlayNewBossRoundState(int iClient, bool bState)
{
	g_bPlayerPlayedNewBossRound[iClient] = bState;
}
/*
bool DidClientPlaySpecialRound(int iClient)
{
	return g_bPlayerPlayedNewBossRound[iClient];
}
*/
void SetClientPlaySpecialRoundState(int iClient, bool bState)
{
	g_bPlayerPlayedSpecialRound[iClient] = bState;
}

void TeleportClientToEscapePoint(int iClient)
{
	if (!IsClientInGame(iClient)) return;
	
	ArrayList hSpawnPoints = new ArrayList();
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_player_escapespawn")) != -1)
	{
		SF2PlayerEscapeSpawnEntity spawnPoint = SF2PlayerEscapeSpawnEntity(ent);
		if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
			continue;
		
		hSpawnPoints.Push(ent);
	}
	
	if (hSpawnPoints.Length > 0)
		ent = hSpawnPoints.Get(GetRandomInt(0, hSpawnPoints.Length - 1));
	else
		ent = EntRefToEntIndex(g_iRoundEscapePointEntity);
	
	delete hSpawnPoints;
	
	if (ent && IsValidEntity(ent))
	{
		SF2PlayerEscapeSpawnEntity spawnPoint = SF2PlayerEscapeSpawnEntity(ent);
		
		float flPos[3], flAng[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", flAng);
		
		TeleportEntity(iClient, flPos, flAng, view_as<float>( { 0.0, 0.0, 0.0 } ));
		
		if (spawnPoint.IsValid())
		{
			spawnPoint.FireOutput("OnSpawn", iClient);
		}
		else
		{
			AcceptEntityInput(ent, "FireUser1", iClient);
		}
	}
}

void ForceInNextPlayersInQueue(int iAmount, bool bShowMessage = false)
{
	// Grab the next person in line, or the next group in line if space allows.
	int iAmountLeft = iAmount;
	ArrayList hPlayers = new ArrayList();
	ArrayList hArray = GetQueueList();

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hPlayers in ForceInNextPlayersInQueue.", hPlayers);
	#endif
	
	for (int i = 0, iSize = hArray.Length; i < iSize && iAmountLeft > 0; i++)
	{
		if (!hArray.Get(i, 2))
		{
			int iClient = hArray.Get(i);
			if (g_bPlayerPlaying[iClient] || !g_bPlayerEliminated[iClient] || !IsClientParticipating(iClient) || g_bAdminNoPoints[iClient]) continue;
			
			hPlayers.Push(iClient);
			iAmountLeft -= 1;
		}
		else
		{
			int iGroupIndex = hArray.Get(i);
			if (!IsPlayerGroupActive(iGroupIndex)) continue;
			
			int iMemberCount = GetPlayerGroupMemberCount(iGroupIndex);
			if (iMemberCount <= iAmountLeft)
			{
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsValidClient(iClient) || g_bPlayerPlaying[iClient] || !g_bPlayerEliminated[iClient] || !IsClientParticipating(iClient)) continue;
					if (ClientGetPlayerGroup(iClient) == iGroupIndex)
					{
						hPlayers.Push(iClient);
					}
				}
				
				SetPlayerGroupPlaying(iGroupIndex, true);
				
				iAmountLeft -= iMemberCount;
			}
		}
	}
	
	delete hArray;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in ForceInNextPlayersInQueue.", hArray);
	#endif
	
	for (int i = 0, iSize = hPlayers.Length; i < iSize; i++)
	{
		int iClient = hPlayers.Get(i);
		ClientSetQueuePoints(iClient, 0);
		if (IsClientInGhostMode(iClient))
		{
			ClientSetGhostModeState(iClient, false);
			TF2_RespawnPlayer(iClient);
			TF2_RemoveCondition(iClient, TFCond_StealthedUserBuffFade);
			g_flLastCommandTime[iClient] = GetEngineTime()+0.5;
			CreateTimer(0.25, Timer_ForcePlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
		else SetClientPlayState(iClient, true);
		
		if (bShowMessage) CPrintToChat(iClient, "%T", "SF2 Force Play", iClient);
	}
	
	delete hPlayers;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hPlayers in ForceInNextPlayersInQueue.", hPlayers);
	#endif
}

public int SortQueueList(int index1, int index2, Handle array, Handle hndl)
{
	ArrayList aArray = view_as<ArrayList>(array);
	
	bool bDisabled = g_bPlayerNoPoints[aArray.Get(index1, 0)];
	if (bDisabled != g_bPlayerNoPoints[aArray.Get(index2, 0)]) return bDisabled ? 1 : -1;

	int iQueuePoints1 = aArray.Get(index1, 1);
	int iQueuePoints2 = aArray.Get(index2, 1);
	
	if (iQueuePoints1 > iQueuePoints2) return -1;
	else if (iQueuePoints1 == iQueuePoints2) return 0;
	return 1;
}

//	==========================================================
//	GENERIC PAGE/BOSS HOOKS AND FUNCTIONS
//	==========================================================

public Action Hook_SlenderObjectSetTransmit(int ent, int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (!IsPlayerAlive(other) || IsClientInDeathCam(other))
	{
		if (!IsValidEdict(GetEntPropEnt(other, Prop_Send, "m_hObserverTarget"))) return Plugin_Handled;
	}
	if (IsClientInGhostMode(other) || g_bPlayerProxy[other]) return Plugin_Handled;
	if (IsValidClient(other))
	{
		if (ClientGetDistanceFromEntity(other, ent) >= SquareFloat(320.0) || GetClientTeam(other) == TFTeam_Spectator)
			return Plugin_Handled;
	}
	return Plugin_Continue;
}
public Action Hook_SlenderObjectSetTransmitEx(int ent, int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	if (!IsPlayerAlive(other) || IsClientInDeathCam(other))
	{
		if (!IsValidEdict(GetEntPropEnt(other, Prop_Send, "m_hObserverTarget"))) return Plugin_Handled;
	}
	if (IsClientInGhostMode(other) || g_bPlayerProxy[other]) return Plugin_Handled;
	if (IsValidClient(other))
	{
		if (ClientGetDistanceFromEntity(other, ent) <= SquareFloat(320.0) || GetClientTeam(other) == TFTeam_Spectator)
			return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Timer_SlenderBlinkBossThink(Handle timer, any entref)
{
	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderEntityThink[iBossIndex]) return Plugin_Stop;
	
	int iDifficulty = g_cvDifficulty.IntValue;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (NPCGetType(iBossIndex) == SF2BossType_Creeper)
	{
		bool bMove = false;
		
		if ((GetGameTime() - g_flSlenderLastKill[iBossIndex]) >= NPCGetInstantKillCooldown(iBossIndex, iDifficulty))
		{
			if (PeopleCanSeeSlender(iBossIndex, false, false) && !PeopleCanSeeSlender(iBossIndex, true, SlenderUsesBlink(iBossIndex)))
			{
				int iBestPlayer = -1;
				ArrayList hArray = new ArrayList();
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArray in Timer_SlenderBlinkBossThink.", hArray);
				#endif
				
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInDeathCam(i) || g_bPlayerEliminated[i] || DidClientEscape(i) || IsClientInGhostMode(i) || !PlayerCanSeeSlender(i, iBossIndex, false, false))continue;
					
					if (!NPCShouldSeeEntity(iBossIndex, i))
						continue;
					
					hArray.Push(i);
				}
				
				if (hArray.Length)
				{
					float flSlenderPos[3];
					SlenderGetAbsOrigin(iBossIndex, flSlenderPos);
					
					float flTempPos[3];
					int iTempPlayer = -1;
					float flTempDist = SquareFloat(16384.0);
					for (int i = 0; i < hArray.Length; i++)
					{
						int iClient = hArray.Get(i);
						GetClientAbsOrigin(iClient, flTempPos);
						if (GetVectorSquareMagnitude(flTempPos, flSlenderPos) < flTempDist)
						{
							iTempPlayer = iClient;
							flTempDist = GetVectorSquareMagnitude(flTempPos, flSlenderPos);
						}
						if (SF_SpecialRound(SPECIALROUND_BOO) && GetVectorSquareMagnitude(flTempPos, flSlenderPos) < SquareFloat(SPECIALROUND_BOO_DISTANCE))
							TF2_StunPlayer(iClient, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
					}
					
					iBestPlayer = iTempPlayer;
				}
				
				delete hArray;
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArray in Timer_SlenderBlinkBossThink.", hArray);
				#endif
				
				float buffer[3];
				if (iBestPlayer != -1 && SlenderCalculateApproachToPlayer(iBossIndex, iBestPlayer, buffer))
				{
					bMove = true;
					
					float flAng[3], flBuffer[3];
					float flSlenderPos[3], flPos[3];
					GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPos);
					GetClientAbsOrigin(iBestPlayer, flPos);
					SubtractVectors(flPos, buffer, flAng);
					GetVectorAngles(flAng, flAng);
					
					// Take care of angle offsets.
					AddVectors(flAng, g_flSlenderEyeAngOffset[iBossIndex], flAng);
					for (int i = 0; i < 3; i++) flAng[i] = AngleNormalize(flAng[i]);
					
					flAng[0] = 0.0;
					
					// Take care of position offsets.
					GetProfileVector(sProfile, "pos_offset", flBuffer);
					AddVectors(buffer, flBuffer, buffer);
					
					TeleportEntity(slender, buffer, flAng, NULL_VECTOR);
					
					float flMaxRange = g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty];
					float flDist = GetVectorSquareMagnitude(buffer, flPos);
					
					char sBuffer[PLATFORM_MAX_PATH];
					
					if (flDist < SquareFloat(flMaxRange * 0.33))
					{
						GetSlenderModel(iBossIndex, 2, sBuffer, sizeof(sBuffer));
					}
					else if (flDist < SquareFloat(flMaxRange * 0.66))
					{
						GetSlenderModel(iBossIndex, 1, sBuffer, sizeof(sBuffer));
					}
					else
					{
						GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));
					}
					
					// Fallback if error.
					if (sBuffer[0] == '\0') GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));
					
					SetEntityModel(slender, sBuffer);
					
					if (flDist <= SquareFloat(NPCGetInstantKillRadius(iBossIndex)))
					{
						if (NPCGetFlags(iBossIndex) & SFF_FAKE)
						{
							SlenderMarkAsFake(iBossIndex);
							return Plugin_Stop;
						}
						else
						{
							g_flSlenderLastKill[iBossIndex] = GetGameTime();
							ClientStartDeathCam(iBestPlayer, iBossIndex, buffer);
						}
					}
				}
			}
		}
		
		if (bMove)
		{
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_move_single", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') EmitSoundToAll(sBuffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			
			GetRandomStringFromProfile(sProfile, "sound_move", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') EmitSoundToAll(sBuffer, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, SND_CHANGEVOL);
		}
		else
		{
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_move", sBuffer, sizeof(sBuffer));
			if (sBuffer[0] != '\0') StopSound(slender, SNDCHAN_AUTO, sBuffer);
		}
	}
	
	return Plugin_Continue;
}


void SlenderOnClientStressUpdate(int iClient)
{
	int iDifficulty = g_cvDifficulty.IntValue;

	float flStress = g_flPlayerStress[iClient];
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	
	for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
	{
		if (NPCGetUniqueID(iBossIndex) == -1) continue;
		
		int iBossFlags = NPCGetFlags(iBossIndex);
		if (iBossFlags & SFF_MARKEDASFAKE || 
			iBossFlags & SFF_NOTELEPORT)
		{
			continue;
		}
		
		NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
		
		int iTeleportTarget = EntRefToEntIndex(g_iSlenderTeleportTarget[iBossIndex]);
		if (iTeleportTarget && iTeleportTarget != INVALID_ENT_REFERENCE && !g_bPlayerIsExitCamping[iTeleportTarget])
		{
			if (g_bPlayerEliminated[iTeleportTarget] || 
				DidClientEscape(iTeleportTarget) || 
				(!SF_IsRenevantMap() && !SF_IsSurvivalMap() && !g_bSlenderTeleportIgnoreChases[iBossIndex] && flStress >= g_flSlenderTeleportMaxTargetStress[iBossIndex]) || 
				GetGameTime() >= g_flSlenderTeleportMaxTargetTime[iBossIndex])
			{
				// Queue for a new target and mark the old target in the rest period.
				float flRestPeriod = NPCGetTeleportRestPeriod(iBossIndex, iDifficulty);
				flRestPeriod = (flRestPeriod * GetRandomFloat(0.92, 1.08)) / (g_flRoundDifficultyModifier);
				
				g_iSlenderTeleportTarget[iBossIndex] = INVALID_ENT_REFERENCE;
				g_flSlenderTeleportPlayersRestTime[iBossIndex][iTeleportTarget] = GetGameTime() + flRestPeriod;
				g_flSlenderTeleportMaxTargetStress[iBossIndex] = 9999.0;
				g_flSlenderTeleportMaxTargetTime[iBossIndex] = -1.0;
				g_flSlenderTeleportTargetTime[iBossIndex] = -1.0;
				
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: lost target, putting at rest period", iBossIndex);
				#endif
			}
		}
		else if (IsRoundPlaying())
		{
			int iPreferredTeleportTarget = INVALID_ENT_REFERENCE;
			
			float flTargetStressMin = NPCGetTeleportStressMin(iBossIndex, iDifficulty);
			float flTargetStressMax = NPCGetTeleportStressMax(iBossIndex, iDifficulty);
			
			float flTargetStress = flTargetStressMax - ((flTargetStressMax - flTargetStressMin) / (g_flRoundDifficultyModifier));
			
			float flPreferredTeleportTargetStress = flTargetStress;
			
			int iRaidClient;
			if (NPCAreAvailablePlayersAlive())
			{
				do
				{
					iRaidClient = GetRandomInt(1, MaxClients);
				}
				while (!IsClientInGame(iRaidClient) || 
					!IsPlayerAlive(iRaidClient) || 
					g_bPlayerEliminated[iRaidClient] || 
					IsClientInGhostMode(iRaidClient) || 
					DidClientEscape(iRaidClient));
			}
			
			for (int i = 1; i <= MaxClients; i++)
			{
				if (g_bPlayerIsExitCamping[i])
				{
					if (IsValidClient(iTeleportTarget) && !g_bPlayerIsExitCamping[iTeleportTarget])
					{
						iPreferredTeleportTarget = i;
						break;
					}
				}
				if (g_flPlayerStress[i] < flPreferredTeleportTargetStress || g_bRestartSessionEnabled)
				{
					if (g_flSlenderTeleportPlayersRestTime[iBossIndex][i] <= GetGameTime())
					{
						iPreferredTeleportTarget = i;
						flPreferredTeleportTargetStress = g_flPlayerStress[i];
					}
				}
				if (i == iRaidClient && IsValidClient(iRaidClient))
				{
					g_iSlenderProxyTarget[iBossIndex] = EntIndexToEntRef(iRaidClient);
					iPreferredTeleportTarget = iRaidClient;
				}
			}
			
			if (IsValidClient(iPreferredTeleportTarget))
			{
				// Set our preferred target to the new guy.
				float flTargetDuration = NPCGetTeleportPersistencyPeriod(iBossIndex, iDifficulty);
				float flDeviation = GetRandomFloat(0.92, 1.08);
				flTargetDuration = Pow(flDeviation * flTargetDuration, ((g_flRoundDifficultyModifier * (NPCGetAnger(iBossIndex) - 1.0)) / 2.0)) + ((flDeviation * flTargetDuration) - 1.0);
				
				g_iSlenderTeleportTarget[iBossIndex] = EntIndexToEntRef(iPreferredTeleportTarget);
				g_flSlenderTeleportPlayersRestTime[iBossIndex][iPreferredTeleportTarget] = -1.0;
				g_flSlenderTeleportMaxTargetTime[iBossIndex] = GetGameTime() + flTargetDuration;
				g_flSlenderTeleportTargetTime[iBossIndex] = GetGameTime();
				g_flSlenderTeleportMaxTargetStress[iBossIndex] = flTargetStress;
				
				iTeleportTarget = iPreferredTeleportTarget;
				
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: got new target %N", iBossIndex, iPreferredTeleportTarget);
				#endif
			}
		}
	}
}

static int GetPageMusicRanges()
{
	g_hPageMusicRanges.Clear();
	
	char sName[64];
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		
		if (sName[0] != '\0' && !StrContains(sName, "sf2_page_music_", false))
		{
			ReplaceString(sName, sizeof(sName), "sf2_page_music_", "", false);
			
			char sPageRanges[2][32];
			ExplodeString(sName, "-", sPageRanges, 2, 32);
			
			int iIndex = g_hPageMusicRanges.Push(EntIndexToEntRef(ent));
			if (iIndex != -1)
			{
				int iMin = StringToInt(sPageRanges[0]);
				int iMax = StringToInt(sPageRanges[1]);
				
				#if defined DEBUG
				DebugMessage("Page range found: entity %d, iMin = %d, iMax = %d", ent, iMin, iMax);
				#endif
				g_hPageMusicRanges.Set(iIndex, iMin, 1);
				g_hPageMusicRanges.Set(iIndex, iMax, 2);
			}
		}
	}
	
	while ((ent = FindEntityByClassname(ent, "sf2_info_page_music")) != -1)
	{
		SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
		if (!pageMusic.IsValid())
			continue;
		
		pageMusic.InsertRanges(g_hPageMusicRanges);
	}
	
	// precache
	if (g_hPageMusicRanges.Length > 0)
	{
		char sPath[PLATFORM_MAX_PATH];
		
		for (int i = 0; i < g_hPageMusicRanges.Length; i++)
		{
			ent = EntRefToEntIndex(g_hPageMusicRanges.Get(i));
			if (!ent || ent == INVALID_ENT_REFERENCE) continue;
			
			SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
			if (pageMusic.IsValid())
			{
				// Don't do anything; entity already precached its own music.
			}
			else
			{
				GetEntPropString(ent, Prop_Data, "m_iszSound", sPath, sizeof(sPath));
				if (sPath[0] != '\0')
					PrecacheSound(sPath);
			}
		}
	}
	
	LogSF2Message("Loaded page music ranges successfully!");
}
void SetPageCount(int iNum)
{
	if (iNum > g_iPageMax)iNum = g_iPageMax;
	
	int iOldPageCount = g_iPageCount;
	g_iPageCount = iNum;
	int iDifficulty = g_cvDifficulty.IntValue;
	if (g_iPageCount != iOldPageCount)
	{
		if (g_iPageCount > iOldPageCount)
		{
			if (g_hRoundGraceTimer != null)
			{
				TriggerTimer(g_hRoundGraceTimer);
			}
			
			if (g_iRoundTime < g_iRoundTimeLimit)
			{
				// Add round time.
				int iRoundTime = g_iRoundTime;
				
				if (!SF_SpecialRound(SPECIALROUND_NOPAGEBONUS))
					iRoundTime += g_iRoundTimeGainFromPage;
				
				if (iRoundTime > g_iRoundTimeLimit)iRoundTime = g_iRoundTimeLimit;
				
				SetRoundTime(iRoundTime);
			}
			
			if (SF_SpecialRound(SPECIALROUND_DISTORTION))
			{
				ArrayList hClientSwap = new ArrayList();
				for (int iClient = 0; iClient < MAX_BOSSES; iClient++)
				{
					if (!IsValidClient(iClient)) continue;
					if (!IsPlayerAlive(iClient)) continue;
					if (g_bPlayerEliminated[iClient]) continue;
					if (DidClientEscape(iClient)) continue;
					if (IsClientInDeathCam(iClient)) continue;
					hClientSwap.Push(iClient);
				}
				
				int iSize = hClientSwap.Length;
				if (iSize > 1)
				{
					int iClient, iClient2;
					float flPos[3], flPos2[3], flAng[3], flAng2[3], flVel[3], flVel2[3];
					hClientSwap.Sort(Sort_Random, Sort_Integer);
					for (int iArray = 0; iArray < (iSize / 2); iArray++)
					{
						iClient = hClientSwap.Get(iArray);
						GetClientAbsOrigin(iClient, flPos);
						GetClientEyeAngles(iClient, flAng);
						GetEntPropVector(iClient, Prop_Data, "m_vecAbsVelocity", flVel);
						
						iClient2 = hClientSwap.Get((iSize - 1) - iArray);
						GetClientAbsOrigin(iClient2, flPos2);
						GetClientEyeAngles(iClient2, flAng2);
						GetEntPropVector(iClient2, Prop_Data, "m_vecAbsVelocity", flVel2);
						
						TeleportEntity(iClient, flPos2, flAng2, flVel2);
						if (IsSpaceOccupiedIgnorePlayers(flPos2, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, iClient))
						{
							Player_FindFreePosition2(iClient, flPos2, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS);
						}
						
						TeleportEntity(iClient2, flPos, flAng, flVel);
						if (IsSpaceOccupiedIgnorePlayers(flPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, iClient2))
						{
							Player_FindFreePosition2(iClient2, flPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS);
						}
					}
				}
				delete hClientSwap;
			}
			
			if (SF_SpecialRound(SPECIALROUND_CLASSSCRAMBLE))
			{
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsValidClient(iClient)) continue;
					if (!IsPlayerAlive(iClient)) continue;
					if (g_bPlayerEliminated[iClient]) continue;
					if (DidClientEscape(iClient)) continue;
					
					TFClassType newClass;
					switch (g_iPlayerRandomClassNumber[iClient])
					{
						case 1: newClass = TFClass_Scout;
						case 2: newClass = TFClass_Soldier;
						case 3: newClass = TFClass_Pyro;
						case 4: newClass = TFClass_DemoMan;
						case 5: newClass = TFClass_Heavy;
						case 6: newClass = TFClass_Engineer;
						case 7: newClass = TFClass_Medic;
						case 8: newClass = TFClass_Sniper;
						case 9: newClass = TFClass_Spy;
					}
					
					TF2_SetPlayerClass(iClient, newClass);
					
					CreateTimer(0.1, Timer_ClassScramblePlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.25, Timer_ClassScramblePlayer2, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
					
					// Regenerate player but keep health the same.
					int iHealth = GetEntProp(iClient, Prop_Send, "m_iHealth");
					TF2_RegeneratePlayer(iClient);
					SetEntProp(iClient, Prop_Data, "m_iHealth", iHealth);
					SetEntProp(iClient, Prop_Send, "m_iHealth", iHealth);
				}
			}
			
			// Increase anger on selected bosses.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (NPCGetUniqueID(i) == -1) continue;
				
				float flPageDiff = NPCGetAngerAddOnPageGrabTimeDiff(i);
				if (flPageDiff >= 0.0)
				{
					int iDiff = g_iPageCount - iOldPageCount;
					if ((GetGameTime() - g_flPageFoundLastTime) < flPageDiff)
					{
						NPCAddAnger(i, NPCGetAngerAddOnPageGrab(i) * float(iDiff));
					}
				}
			}
			
			if (SF_IsSlaughterRunMap())
			{
				if (g_iPageCount == 1) //The first collectible for maps like Enclosed
				{
					int iBosses = 0;
					float[] flTimes = new float[MAX_BOSSES];
					float flAverageTime = 0.0;
					for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
					{
						if (NPCGetUniqueID(iNPCIndex) == -1) continue;
						
						float flOriginalSpeed, flSpeed, flTimerCheck;
						flOriginalSpeed = NPCGetSpeed(iNPCIndex, iDifficulty) + NPCGetAddSpeed(iNPCIndex);
						if (flOriginalSpeed < 600.0) flOriginalSpeed = 600.0;
						if (g_flRoundDifficultyModifier > 1.0)
						{
							flSpeed = flOriginalSpeed + ((flOriginalSpeed * g_flRoundDifficultyModifier) / 15) + (NPCGetAnger(iNPCIndex) * g_flRoundDifficultyModifier);
						}
						else
						{
							flSpeed = flOriginalSpeed + NPCGetAnger(iNPCIndex);
						}
						flTimerCheck = flSpeed / g_cvSlaughterRunDivisibleTime.FloatValue;
						flTimes[iBosses] = flTimerCheck;
						iBosses++;
					}
					int iArrayLength = iBosses;
					if (iArrayLength > 0)
					{
						for (int i2 = 0; i2 < iArrayLength; i2++)
						{
							flAverageTime += flTimes[i2];
						}
						flAverageTime = flAverageTime / iArrayLength;
						flAverageTime += (float(iBosses) / 2.0);
						for (int i3 = 0; i3 < iArrayLength; i3++)
						{
							flAverageTime += (flTimes[i3] / GetRandomFloat(12.0, 22.0));
						}
						switch (g_cvDifficulty.IntValue)
						{
							case Difficulty_Normal: flAverageTime += 1.0;
							case Difficulty_Hard: flAverageTime += 2.0;
							case Difficulty_Insane: flAverageTime += 3.0;
							case Difficulty_Nightmare: flAverageTime += 4.0;
							case Difficulty_Apollyon: flAverageTime += 5.0;
						}
						PrintToChatAll("Time before bosses spawn: %f seconds", flAverageTime);
						CreateTimer(flAverageTime, Timer_SlaughterRunSpawnBosses, _, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
			
			g_flPageFoundLastTime = GetGameTime();
		}
		
		SF2MapEntity_OnPageCountChanged(g_iPageCount, iOldPageCount);
		
		// Notify logic entities.
		char sTargetName[64];
		char sFindTargetName[64];
		FormatEx(sFindTargetName, sizeof(sFindTargetName), "sf2_onpagecount_%d", g_iPageCount);
		
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
			if (sTargetName[0] != '\0' && strcmp(sTargetName, sFindTargetName, false) == 0)
			{
				AcceptEntityInput(ent, "Trigger");
				break;
			}
		}
		
		int iClients[MAXPLAYERS + 1] = { -1, ... };
		int iClientsNum = 0;
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i)) continue;
			if (!g_bPlayerEliminated[i] || IsClientInGhostMode(i))
			{
				if (g_iPageCount)
				{
					iClients[iClientsNum] = i;
					iClientsNum++;
				}
			}
		}
		
		if (g_iPageCount > 0 && g_bRoundHasEscapeObjective && g_iPageCount == g_iPageMax)
		{
			// Escape initialized!
			SetRoundState(SF2RoundState_Escape);
			
			if (iClientsNum && !SF_SpecialRound(SPECIALROUND_REALISM))
			{
				int iGameTextEscape = -1;
				SF2GameTextEntity gameText = SF2GameTextEntity(-1);
				
				if (g_GamerulesEntity.IsValid() && (gameText = g_GamerulesEntity.EscapeTextEntity).IsValid())
				{
					char sMessage[512];
					gameText.GetEscapeMessage(sMessage, sizeof(sMessage));
					if (gameText.ValidateMessageString(sMessage, sizeof(sMessage)))
					{
						ShowHudTextUsingTextEntity(iClients, iClientsNum, gameText.index, g_hHudSync, sMessage);
					}
				}
				else if (IsValidEntity((iGameTextEscape = GetTextEntity("sf2_escape_message", false))))
				{
					// Custom escape message.
					char sMessage[512];
					GetEntPropString(iGameTextEscape, Prop_Data, "m_iszMessage", sMessage, sizeof(sMessage));
					ShowHudTextUsingTextEntity(iClients, iClientsNum, iGameTextEscape, g_hHudSync, sMessage);
				}
				else
				{
					// Default escape message.
					for (int i = 0; i < iClientsNum; i++)
					{
						int iClient = iClients[i];
						ClientShowMainMessage(iClient, "%d/%d\n%T", g_iPageCount, g_iPageMax, "SF2 Default Escape Message", i);
					}
				}
			}
			
			if (SF_SpecialRound(SPECIALROUND_LASTRESORT))
			{
				char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
				ArrayList hSelectableBosses = GetSelectableBossProfileList().Clone();
				if (hSelectableBosses.Length > 0)
				{
					hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
				delete hSelectableBosses;
			}
		}
		else
		{
			if (iClientsNum && !SF_SpecialRound(SPECIALROUND_REALISM))
			{
				int iGameTextPage = -1;
				SF2GameTextEntity gameText = SF2GameTextEntity(-1);
				
				if (g_GamerulesEntity.IsValid() && (gameText = g_GamerulesEntity.PageTextEntity).IsValid())
				{
					char sMessage[512];
					gameText.GetPageMessage(sMessage, sizeof(sMessage));
					if (gameText.ValidateMessageString(sMessage, sizeof(sMessage)))
					{
						ShowHudTextUsingTextEntity(iClients, iClientsNum, gameText.index, g_hHudSync, sMessage);
					}
				}
				else if (IsValidEntity((iGameTextPage = GetTextEntity("sf2_page_message", false))))
				{
					// Custom page message.
					char sMessage[512];
					GetEntPropString(iGameTextPage, Prop_Data, "m_iszMessage", sMessage, sizeof(sMessage));
					ShowHudTextUsingTextEntity(iClients, iClientsNum, iGameTextPage, g_hHudSync, sMessage, g_iPageCount, g_iPageMax);
				}
				else
				{
					// Default page message.
					for (int i = 0; i < iClientsNum; i++)
					{
						int iClient = iClients[i];
						ClientShowMainMessage(iClient, "%d/%d", g_iPageCount, g_iPageMax);
					}
				}
			}
		}
		
		CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_SlaughterRunSpawnBosses(Handle timer)
{
	ArrayList hSpawnPoint = new ArrayList();
	float flTeleportPos[3];
	int ent = -1, iSpawnTeam = 0;
	while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
	{
		iSpawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
		if (iSpawnTeam == TFTeam_Red)
		{
			hSpawnPoint.Push(ent);
		}
		
	}
	ent = -1;
	
	for (int iNpc = 0; iNpc <= MAX_BOSSES; iNpc++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(iNpc);
		if (!Npc.IsValid()) continue;
		Npc.UnSpawn();
		if (hSpawnPoint.Length > 0)ent = hSpawnPoint.Get(GetRandomInt(0, hSpawnPoint.Length - 1));
		if (IsValidEntity(ent))
		{
			GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
			SpawnSlender(Npc, flTeleportPos);
		}
	}
	delete hSpawnPoint;
	
	return Plugin_Stop;
}

bool Player_FindFreePosition2(int client, float position[3], float mins[3], float maxs[3])
{
	int team = GetClientTeam(client);
	int mask = MASK_RED;
	if (team != TFTeam_Red) mask = MASK_BLUE;
	
	// -90 to 90
	float pitchMin = 75.0; // down
	float pitchMax = -89.0; // up
	float pitchInc = 10.0;
	
	float yawMin = -180.0;
	float yawMax = 180.0;
	float yawInc = 10.0;
	
	float radiusMin = 150.0; // 150.0
	float radiusMax = 300.0;
	float radiusInc = 25.0; // 25.0
	
	float ang[3];
	
	for (float p = pitchMin; p >= pitchMax; p -= pitchInc)
	{
		ang[0] = p;
		for (float y = yawMin; y <= yawMax; y += yawInc)
		{
			ang[1] = y;
			for (float r = radiusMin; r <= radiusMax; r += radiusInc)
			{
				float freePosition[3];
				GetPositionForward(position, ang, freePosition, r);
				
				// Perform a line of sight check to avoid spawning players in unreachable map locations.
				// The tank has this weird bug where players can be pushed into map displacements and can sometimes go completely through a wall.
				TR_TraceRayFilter(position, freePosition, mask, RayType_EndPoint, TraceRayDontHitPlayersOrEntity);
				
				if (!TR_DidHit())
				{
					TR_TraceHullFilter(freePosition, freePosition, mins, maxs, mask, TraceFilter_NotTeam, team);
					
					if (!TR_DidHit())
					{
						TeleportEntity(client, freePosition, NULL_VECTOR, NULL_VECTOR);
						return true;
					}
				}
				else
				{
					// We hit a wall, breaking line of sight. Give up on this angle.
					break;
				}
			}
		}
	}
	return false;
}
public bool TraceFilter_NotTeam(int entity, int contentsMask, int team)
{
	if (entity >= 1 && entity <= MaxClients && GetClientTeam(entity) == team)
	{
		return false;
	}
	if (IsValidEdict(entity))
	{
		char sClass[64];
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
	}
	return true;
}
int GetTextEntity(const char[] sTargetName, bool bCaseSensitive = true)
{
	// Try to see if we can use a custom message instead of the default.
	char targetName[64];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "game_text")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] != '\0')
		{
			if (strcmp(targetName, sTargetName, bCaseSensitive) == 0)
			{
				return ent;
			}
		}
	}
	
	return -1;
}

void ShowHudTextUsingTextEntity(const int[] iClients, int iClientsNum, int iGameText, Handle hHudSync, const char[] sMessage, ...)
{
	if (sMessage[0] == '\0') return;
	if (!IsValidEntity(iGameText)) return;
	
	char sTrueMessage[512];
	VFormat(sTrueMessage, sizeof(sTrueMessage), sMessage, 6);
	
	float flX = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.x");
	float flY = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.y");
	int iEffect = GetEntProp(iGameText, Prop_Data, "m_textParms.effect");
	float flFadeInTime = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.fadeinTime");
	float flFadeOutTime = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.fadeoutTime");
	float flHoldTime = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.holdTime");
	float flFxTime = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.fxTime");
	
	int Color1[4] = { 255, 255, 255, 255 };
	int Color2[4] = { 255, 255, 255, 255 };
	
	int iParmsOffset = FindDataMapInfo(iGameText, "m_textParms");
	if (iParmsOffset != -1)
	{
		// hudtextparms_s m_textParms
		
		Color1[0] = GetEntData(iGameText, iParmsOffset + 12, 1);
		Color1[1] = GetEntData(iGameText, iParmsOffset + 13, 1);
		Color1[2] = GetEntData(iGameText, iParmsOffset + 14, 1);
		Color1[3] = GetEntData(iGameText, iParmsOffset + 15, 1);
		
		Color2[0] = GetEntData(iGameText, iParmsOffset + 16, 1);
		Color2[1] = GetEntData(iGameText, iParmsOffset + 17, 1);
		Color2[2] = GetEntData(iGameText, iParmsOffset + 18, 1);
		Color2[3] = GetEntData(iGameText, iParmsOffset + 19, 1);
	}
	
	SetHudTextParamsEx(flX, flY, flHoldTime, Color1, Color2, iEffect, flFxTime, flFadeInTime, flFadeOutTime);
	
	for (int i = 0; i < iClientsNum; i++)
	{
		int iClient = iClients[i];
		if (!IsValidClient(iClient) || IsFakeClient(iClient)) continue;
		
		ShowSyncHudText(iClient, hHudSync, sTrueMessage);
	}
}

//	==========================================================
//	EVENT HOOKS
//	==========================================================

public Action Event_RoundStart(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	Handle hProf = CreateProfiler();
	StartProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Started profiling...");
	
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_RoundStart");
	#endif
	
	// Reset some global variables.
	g_iRoundCount++;
	g_hRoundTimer = null;
	
	SetRoundState(SF2RoundState_Invalid);
	
	SetPageCount(0);
	g_iPageMax = 0;
	g_flPageFoundLastTime = GetGameTime();
	
	g_hVoteTimer = null;
	//Stop the music if needed.
	NPCStopMusic();
	// Remove all bosses from the game.
	NPCRemoveAll();
	// Collect trigger_multiple to prevent touch bug.
	SF_CollectTriggersMultiple();
	// Refresh groups.
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		SetPlayerGroupPlaying(i, false);
		CheckPlayerGroup(i);
	}
	
	// Refresh players.
	for (int i = 1; i <= MaxClients; i++)
	{
		ClientSetGhostModeState(i, false);
		
		g_bPlayerPlaying[i] = false;
		g_bPlayerEliminated[i] = true;
		g_bPlayerEscaped[i] = false;
	}
	SF_RemoveAllSpecialRound();
	// Calculate the new round state.
	if (g_bRoundWaitingForPlayers)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}
		SetRoundState(SF2RoundState_Waiting);
	}
	else if (g_cvWarmupRound.BoolValue && g_iRoundWarmupRoundCount < g_cvWarmupRoundNum.IntValue)
	{
		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
		{
			AcceptEntityInput(ent, "Disable");
		}
		
		g_iRoundWarmupRoundCount++;
		
		SetRoundState(SF2RoundState_Waiting);
		
		ServerCommand("mp_restartgame 15");
		PrintCenterTextAll("Round restarting in 15 seconds");
	}
	else
	{
		g_iRoundActiveCount++;
		
		InitializeNewGame();
	}
	
	PvP_OnRoundStart();
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_RoundStart");
	
	StopProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_RoundStart) Stopped profiling, total execution time: %f", GetProfilerTime(hProf));
	delete hProf;
	
	#endif
	//Nextbot doesn't trigger the triggers with npc flags, for map backward compatibility we are going to change the trigger filter and force a custom one.
	/*int iEnt = -1;
	while ((iEnt = FindEntityByClassname(iEnt, "trigger_*")) != -1)
	{
		if(IsValidEntity(iEnt))
		{
			int flags = GetEntProp(iEnt, Prop_Data, "m_spawnflags");
			if ((flags & TRIGGER_NPCS) && !(flags & TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS))
			{
				//Set the trigger to allow every entity, our custom filter will discard the unwanted entities.
				SetEntProp(iEnt, Prop_Data, "m_spawnflags", flags|TRIGGER_EVERYTHING_BUT_PHYSICS_DEBRIS);
				SDKHook(iEnt, SDKHook_StartTouch, Hook_TriggerNPCTouch);
				SDKHook(iEnt, SDKHook_Touch, Hook_TriggerNPCTouch);
				SDKHook(iEnt, SDKHook_EndTouch, Hook_TriggerNPCTouch);
			}
		}
	}*/
}
public Action Hook_TriggerNPCTouch(int iTrigger, int iOther)
{
	int flags = GetEntProp(iTrigger, Prop_Data, "m_spawnflags");
	if ((flags & TRIGGER_CLIENTS) && MaxClients >= iOther > 0) return Plugin_Continue;
	if (MAX_BOSSES >= NPCGetFromEntIndex(iOther) > -1) return Plugin_Continue;
	
	return Plugin_Handled;
}
public Action Event_WinPanel(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	char cappers[7];
	int i = 0;
	for (int iClient; iClient <= MaxClients; iClient++)
	{
		if (IsValidClient(iClient) && DidClientEscape(iClient) && i < 7)
		{
			cappers[i] = iClient;
			event.SetString("cappers", cappers);
			i += 1;
		}
	}
	delete event;
	return Plugin_Continue;
}

public Action Event_RoundEnd(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_RoundEnd");
	#endif
	
	SF_FailEnd();
	
	for (int i = 1; i < MaxClients; i++)
	{
		if (!IsValidClient(i)) continue;
		g_bPlayerDied1Up[i] = false;
		g_bPlayerIn1UpCondition[i] = false;
	}
	
	ArrayList aRandomBosses = new ArrayList();
	char sMusic[MAX_BOSSES][PLATFORM_MAX_PATH];
	
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		
		if (g_bSlenderCustomOutroSong[iNPCIndex])
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
			GetRandomStringFromProfile(sProfile, "sound_music_outro", sMusic[iNPCIndex], sizeof(sMusic[]));
			if (sMusic[iNPCIndex][0] != '\0') aRandomBosses.Push(iNPCIndex);
		}
	}
	if (aRandomBosses.Length > 0)
	{
		int iNewBossIndex = aRandomBosses.Get(GetRandomInt(0, aRandomBosses.Length - 1));
		if (NPCGetUniqueID(iNewBossIndex) != -1)
			EmitSoundToAll(sMusic[iNewBossIndex], _, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
	}
	
	delete aRandomBosses;
	
	SpecialRound_RoundEnd();
	
	SetRoundState(SF2RoundState_Outro);
	
	DistributeQueuePointsToPlayers();
	
	g_iRoundEndCount++;
	CheckRoundLimitForBossPackVote(g_iRoundEndCount);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_RoundEnd");
	#endif
	delete event;
}

public Action Event_Audio(Event event, const char[] name, bool dB)
{
	char strAudio[PLATFORM_MAX_PATH];
	
	GetEventString(event, "sound", strAudio, sizeof(strAudio));
	if (strncmp(strAudio, "Game.Your", 9) == 0 || strcmp(strAudio, "Game.Stalemate") == 0)
	{
		for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
		{
			if (NPCGetUniqueID(iBossIndex) == -1) continue;
			if (!g_bSlenderCustomOutroSong[iBossIndex]) continue;
			
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

static void DistributeQueuePointsToPlayers()
{
	// Give away queue points.
	int iDefaultAmount = 5;
	int iAmount = iDefaultAmount;
	int iAmount2 = iAmount;
	Action iAction = Plugin_Continue;
	
	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i)) continue;
		
		if (IsPlayerGroupPlaying(i))
		{
			SetPlayerGroupQueuePoints(i, 0);
		}
		else
		{
			iAmount = iDefaultAmount;
			iAmount2 = iAmount;
			iAction = Plugin_Continue;
			
			Call_StartForward(fOnGroupGiveQueuePoints);
			Call_PushCell(i);
			Call_PushCellRef(iAmount2);
			Call_Finish(iAction);
			
			if (iAction == Plugin_Changed)iAmount = iAmount2;
			
			SetPlayerGroupQueuePoints(i, GetPlayerGroupQueuePoints(i) + iAmount);
			
			for (int iClient = 1; iClient <= MaxClients; iClient++)
			{
				if (!IsValidClient(iClient)) continue;
				if (ClientGetPlayerGroup(iClient) == i)
				{
					CPrintToChat(iClient, "%T", "SF2 Give Group Queue Points", iClient, iAmount);
				}
			}
		}
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		if (g_bAdminNoPoints[i]) continue;
		if (g_bPlayerPlaying[i])
		{
			ClientSetQueuePoints(i, 0);
		}
		else
		{
			if (!IsClientParticipating(i))
			{
				CPrintToChat(i, "%T", "SF2 No Queue Points To Spectator", i);
			}
			else
			{
				iAmount = iDefaultAmount;
				iAmount2 = iAmount;
				iAction = Plugin_Continue;
				
				Call_StartForward(fOnClientGiveQueuePoints);
				Call_PushCell(i);
				Call_PushCellRef(iAmount2);
				Call_Finish(iAction);
				
				if (iAction == Plugin_Changed)iAmount = iAmount2;
				
				ClientSetQueuePoints(i, g_iPlayerQueuePoints[i] + iAmount);
				CPrintToChat(i, "%T", "SF2 Give Queue Points", i, iAmount);
			}
		}
	}
}

public Action Event_PlayerTeamPre(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT START: Event_PlayerTeamPre");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		if (GetEventInt(event, "team") > 1 || GetEventInt(event, "oldteam") > 1) SetEventBroadcast(event, true);
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT END: Event_PlayerTeamPre");
	#endif
	
	delete event;
	
	return Plugin_Continue;
}

public Action Event_PlayerTeam(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerTeam");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		int iintTeam = GetEventInt(event, "team");
		if (iintTeam <= TFTeam_Spectator)
		{
			if (!IsRoundPlaying())
			{
				if (g_bPlayerPlaying[iClient] && !g_bPlayerEliminated[iClient])
				{
					ForceInNextPlayersInQueue(1, true);
				}
			}
			
			// You're not playing anymore.
			if (g_bPlayerPlaying[iClient])
			{
				ClientSetQueuePoints(iClient, 0);
			}
			
			g_bPlayerPlaying[iClient] = false;
			g_bPlayerEliminated[iClient] = true;
			g_bPlayerEscaped[iClient] = false;
			
			ClientSetGhostModeState(iClient, false);
			
			if (!view_as<bool>(GetEntProp(iClient, Prop_Send, "m_bIsCoaching")))
			{
				// This is to prevent player spawn spam when someone is coaching. Who coaches in SF2, anyway?
				TF2_RespawnPlayer(iClient);
			}
			
			// Special round.
			if (g_bSpecialRound) g_bPlayerPlayedSpecialRound[iClient] = true;
			
			// Boss round.
			if (g_bNewBossRound) g_bPlayerPlayedNewBossRound[iClient] = true;
			
			if (!g_cvFullyEnableSpectator.BoolValue) g_hPlayerSwitchBlueTimer[iClient] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_bPlayerChoseTeam[iClient])
			{
				g_bPlayerChoseTeam[iClient] = true;
				
				if (g_iPlayerPreferences[iClient].PlayerPreference_ProjectedFlashlight)
				{
					EmitSoundToClient(iClient, SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND);
					CPrintToChat(iClient, "%T", "SF2 Projected Flashlight", iClient);
				}
				else
				{
					CPrintToChat(iClient, "%T", "SF2 Normal Flashlight", iClient);
				}
				
				CreateTimer(5.0, Timer_WelcomeMessage, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			}
			if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_bPlayerEliminated[iClient] && iintTeam == TFTeam_Red && 
				TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
			{
				ShowVGUIPanel(iClient, "class_red");
				EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
				TFClassType newClass;
				int iRandom = GetRandomInt(1, 8);
				switch (iRandom)
				{
					case 1: newClass = TFClass_Scout;
					case 2: newClass = TFClass_Soldier;
					case 3: newClass = TFClass_Pyro;
					case 4: newClass = TFClass_DemoMan;
					case 5: newClass = TFClass_Heavy;
					case 6: newClass = TFClass_Engineer;
					case 7: newClass = TFClass_Sniper;
					case 8: newClass = TFClass_Spy;
				}
				TF2_SetPlayerClass(iClient, newClass);
				TF2_RegeneratePlayer(iClient);
			}
		}
	}
	
	// Check groups.
	if (!IsRoundEnding())
	{
		for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
		{
			if (!IsPlayerGroupActive(i)) continue;
			CheckPlayerGroup(i);
		}
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerTeam");
	#endif
	delete event;
}

/**
 *	Sets the player to the correct team if needed. Returns true if a change was necessary, false if no change occurred.
 */
static bool HandlePlayerTeam(int iClient, bool bRespawn=true)
{
	if (!IsClientInGame(iClient) || !IsClientParticipating(iClient)) return false;
	
	if (!g_bPlayerEliminated[iClient])
	{
		if (GetClientTeam(iClient) != TFTeam_Red)
		{
			if (bRespawn)
			{
				TF2_RemoveCondition(iClient,TFCond_HalloweenKart);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartDash);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartNoTurn);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartCage);
				TF2_RemoveCondition(iClient, TFCond_SpawnOutline);
				ChangeClientTeamNoSuicide(iClient, TFTeam_Red);
			}
			else
				ChangeClientTeam(iClient, TFTeam_Red);
				
			return true;
		}
	}
	else
	{
		if (GetClientTeam(iClient) != TFTeam_Blue)
		{
			if (bRespawn)
			{
				TF2_RemoveCondition(iClient,TFCond_HalloweenKart);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartDash);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartNoTurn);
				TF2_RemoveCondition(iClient,TFCond_HalloweenKartCage);
				TF2_RemoveCondition(iClient, TFCond_SpawnOutline);
				ChangeClientTeamNoSuicide(iClient, TFTeam_Blue);
			}
			else
				ChangeClientTeam(iClient, TFTeam_Blue);
				
			return true;
		}
	}
	
	return false;
}

static void HandlePlayerIntroState(int iClient)
{
	if (!IsClientInGame(iClient) || !IsPlayerAlive(iClient) || !IsClientParticipating(iClient)) return;
	
	if (!IsRoundInIntro()) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("START HandlePlayerIntroState(%d)", iClient);
	#endif
	
	// Disable movement on player.
	SetEntityFlags(iClient, GetEntityFlags(iClient) | FL_FROZEN);
	
	float flDelay = 0.0;
	if (!IsFakeClient(iClient))
	{
		flDelay = GetClientLatency(iClient, NetFlow_Outgoing);
	}
	
	CreateTimer(flDelay * 4.0, Timer_IntroBlackOut, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 2) DebugMessage("END HandlePlayerIntroState(%d)", iClient);
	#endif
}

void HandlePlayerHUD(int iClient)
{
	if (SF_IsRaidMap() || SF_IsBoxingMap())
		return;
	if (IsRoundInWarmup() || IsClientInGhostMode(iClient))
	{
		SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
	}
	else
	{
		if (!g_bPlayerEliminated[iClient])
		{
			if (!DidClientEscape(iClient))
			{
				// Player is in the game; disable normal HUD.
				SetEntProp(iClient, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR | HIDEHUD_HEALTH);
			}
			else
			{
				// Player isn't in the game; enable normal HUD behavior.
				SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
			}
		}
		else
		{
			if (g_bPlayerProxy[iClient])
			{
				// Player is in the game; disable normal HUD.
				SetEntProp(iClient, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR | HIDEHUD_HEALTH);
			}
			else
			{
				// Player isn't in the game; enable normal HUD behavior.
				SetEntProp(iClient, Prop_Send, "m_iHideHUD", 0);
			}
		}
	}
}

public Action Event_PlayerSpawn(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient <= 0) return;
	#if defined DEBUG
	
	Handle hProf = CreateProfiler();
	StartProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Started profiling...");

	//PrintToChatAll("(SPAWN) Spawn event called.");
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerSpawn(%d)", iClient);
	#endif
	
	if (GetClientTeam(iClient) > 1)
	{
		g_flLastVisibilityProcess[iClient] = GetGameTime();
		ClientResetStatic(iClient);
		if (!g_bSeeUpdateMenu[iClient])
		{
			g_bSeeUpdateMenu[iClient] = true;
			DisplayMenu(g_hMenuUpdate, iClient, 30);
		}
	}
	if (!IsClientParticipating(iClient))
	{
		TF2Attrib_SetByName(iClient, "increased jump height", 1.0);
		TF2Attrib_RemoveByDefIndex(iClient, 10);
		
		ClientSetGhostModeState(iClient, false);
		SetEntityGravity(iClient, 1.0);
		g_iPlayerPageCount[iClient] = 0;
		
		ClientResetStatic(iClient);
		ClientResetSlenderStats(iClient);
		ClientResetCampingStats(iClient);
		ClientResetOverlay(iClient);
		ClientResetJumpScare(iClient);
		ClientUpdateListeningFlags(iClient);
		ClientUpdateMusicSystem(iClient);
		ClientChaseMusicReset(iClient);
		ClientChaseMusicSeeReset(iClient);
		ClientAlertMusicReset(iClient);
		Client20DollarsMusicReset(iClient);
		Client90sMusicReset(iClient);
		ClientMusicReset(iClient);
		ClientResetProxy(iClient);
		ClientResetHints(iClient);
		ClientResetScare(iClient);
		
		ClientResetDeathCam(iClient);
		ClientResetFlashlight(iClient);
		ClientDeactivateUltravision(iClient);
		ClientResetSprint(iClient);
		ClientResetBreathing(iClient);
		ClientResetBlink(iClient);
		ClientResetInteractiveGlow(iClient);
		ClientDisableConstantGlow(iClient);
		
		ClientHandleGhostMode(iClient);
	}
	
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	g_hPlayerPostWeaponsTimer[iClient] = null;
	g_hPlayerIgniteTimer[iClient] = null;
	g_hPlayerResetIgnite[iClient] = null;
	g_hPlayerPageRewardTimer[iClient] = null;
	g_hPlayerPageRewardCycleTimer[iClient] = null;
	g_hPlayerFireworkTimer[iClient] = null;
	
	g_iPlayerBossKillSubject[iClient] = INVALID_ENT_REFERENCE;
	
	g_bPlayerGettingPageReward[iClient] = false;
	g_iPlayerHitsToCrits[iClient] = 0;
	g_iPlayerHitsToHeads[iClient] = 0;
	
	g_bPlayerTrapped[iClient] = false;
	g_iPlayerTrapCount[iClient] = 0;
	
	g_iPlayerRandomClassNumber[iClient] = 1;
	
	if (IsPlayerAlive(iClient) && IsClientParticipating(iClient))
	{
		if (MusicActive() || SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES)) //A boss is overriding the music.
		{
			char sPath[PLATFORM_MAX_PATH];
			GetBossMusic(sPath, sizeof(sPath));
			if (sPath[0] != '\0') StopSound(iClient, MUSIC_CHAN, sPath);
			if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				StopSound(iClient, MUSIC_CHAN, TRIPLEBOSSESMUSIC);
			}
		}
		g_bBackStabbed[iClient] = false;
		TF2_RemoveCondition(iClient, TFCond_HalloweenKart);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartDash);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartNoTurn);
		TF2_RemoveCondition(iClient, TFCond_HalloweenKartCage);
		TF2_RemoveCondition(iClient, TFCond_SpawnOutline);
		
		if (HandlePlayerTeam(iClient))
		{
			#if defined DEBUG
			if (g_cvDebugDetail.IntValue > 0) DebugMessage("iClient->HandlePlayerTeam()");
			#endif
		}
		else
		{
			g_iPlayerPageCount[iClient] = 0;
			
			ClientResetStatic(iClient);
			ClientResetSlenderStats(iClient);
			ClientResetCampingStats(iClient);
			ClientResetOverlay(iClient);
			ClientResetJumpScare(iClient);
			ClientUpdateListeningFlags(iClient);
			ClientUpdateMusicSystem(iClient);
			ClientChaseMusicReset(iClient);
			ClientChaseMusicSeeReset(iClient);
			ClientAlertMusicReset(iClient);
			Client20DollarsMusicReset(iClient);
			Client90sMusicReset(iClient);
			ClientMusicReset(iClient);
			ClientResetProxy(iClient);
			ClientResetHints(iClient);
			ClientResetScare(iClient);
			
			ClientResetDeathCam(iClient);
			ClientResetFlashlight(iClient);
			ClientDeactivateUltravision(iClient);
			ClientResetSprint(iClient);
			ClientResetBreathing(iClient);
			ClientResetBlink(iClient);
			ClientResetInteractiveGlow(iClient);
			ClientDisableConstantGlow(iClient);
			
			ClientHandleGhostMode(iClient);
			
			TF2Attrib_SetByName(iClient, "increased jump height", 1.0);
			
			if (!g_bPlayerEliminated[iClient])
			{
				if ((SF_IsRaidMap() || SF_IsBoxingMap()) && !IsRoundPlaying())
					TF2Attrib_SetByDefIndex(iClient, 10, 7.0);
				else
					TF2Attrib_RemoveByDefIndex(iClient, 10);
				
				TF2Attrib_SetByDefIndex(iClient, 49, 1.0);
				
				ClientStartDrainingBlinkMeter(iClient);
				ClientSetScareBoostEndTime(iClient, -1.0);
				
				ClientStartCampingTimer(iClient);
				
				HandlePlayerIntroState(iClient);
				
				if (IsFakeClient(iClient))
				{
					CreateTimer(0.1, Timer_SwitchBot, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				
				// screen overlay timer
				if (!SF_IsRaidMap() && !SF_IsBoxingMap())
				{
					g_hPlayerOverlayCheck[iClient] = CreateTimer(0.0, Timer_PlayerOverlayCheck, GetClientUserId(iClient), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
					TriggerTimer(g_hPlayerOverlayCheck[iClient], true);
				}
				if (DidClientEscape(iClient))
				{
					CreateTimer(0.1, Timer_TeleportPlayerToEscapePoint, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				else
				{
					int iRed[4] = { 184, 56, 59, 255 };
					ClientEnableConstantGlow(iClient, "head", iRed);
					ClientActivateUltravision(iClient);
				}

				if (SF_IsRenevantMap() && g_bRenevantMarkForDeath && !DidClientEscape(iClient))
				{
					TF2_AddCondition(iClient, TFCond_MarkedForDeathSilent, -1.0);
				}
				
				if (SF_SpecialRound(SPECIALROUND_1UP) && !g_bPlayerIn1UpCondition[iClient] && !g_bPlayerDied1Up[iClient])
				{
					g_bPlayerDied1Up[iClient] = false;
					g_bPlayerIn1UpCondition[iClient] = true;
					g_bPlayerFullyDied1Up[iClient] = false;
				}
				
				if (SF_SpecialRound(SPECIALROUND_PAGEDETECTOR))
					ClientSetSpecialRoundTimer(iClient, 0.0, Timer_ClientPageDetector, GetClientUserId(iClient));
				
				if (SF_SpecialRound(SPECIALROUND_REALISM))
					EmitSoundToClient(iClient, MARBLEHORNETS_STATIC, _, SNDCHAN_STATIC, 100, _, 0.8);
				
				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
				{
					ShowVGUIPanel(iClient, "class_red");
					EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
					TFClassType newClass;
					int iRandom = GetRandomInt(1, 8);
					switch (iRandom)
					{
						case 1:newClass = TFClass_Scout;
						case 2:newClass = TFClass_Soldier;
						case 3:newClass = TFClass_Pyro;
						case 4:newClass = TFClass_DemoMan;
						case 5:newClass = TFClass_Heavy;
						case 6:newClass = TFClass_Engineer;
						case 7:newClass = TFClass_Sniper;
						case 8:newClass = TFClass_Spy;
					}
					TF2_SetPlayerClass(iClient, newClass);
					TF2_RegeneratePlayer(iClient);
				}
			}
			else
			{
				g_hPlayerOverlayCheck[iClient] = null;
				TF2Attrib_RemoveByDefIndex(iClient, 10);
				TF2Attrib_RemoveByDefIndex(iClient, 49);
			}
			ClientSwitchToWeaponSlot(iClient, TFWeaponSlot_Melee);
			g_hPlayerPostWeaponsTimer[iClient] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			
			HandlePlayerHUD(iClient);
		}
	}
	
	PvP_OnPlayerSpawn(iClient);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0)DebugMessage("EVENT END: Event_PlayerSpawn(%d)", iClient);
	
	StopProfiling(hProf);
	SendDebugMessageToPlayers(DEBUG_EVENT, 0, "(Event_PlayerSpawn) Stopped profiling, function executed in %f", GetProfilerTime(hProf));
	delete hProf;
	#endif
	
	delete event;
}

public void Event_PlayerClass(Event event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if (iClient <= 0) return;
	
	int iTeam = GetClientTeam(iClient);
	
	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && !g_bPlayerEliminated[iClient] && 
		iTeam == TFTeam_Red && TF2_GetPlayerClass(iClient) == TFClass_Medic && !DidClientEscape(iClient))
	{
		ShowVGUIPanel(iClient, "class_red");
		EmitSoundToClient(iClient, THANATOPHOBIA_MEDICNO);
		TFClassType newClass;
		int iRandom = GetRandomInt(1, 8);
		switch (iRandom)
		{
			case 1:newClass = TFClass_Scout;
			case 2:newClass = TFClass_Soldier;
			case 3:newClass = TFClass_Pyro;
			case 4:newClass = TFClass_DemoMan;
			case 5:newClass = TFClass_Heavy;
			case 6:newClass = TFClass_Engineer;
			case 7:newClass = TFClass_Sniper;
			case 8:newClass = TFClass_Spy;
		}
		TF2_SetPlayerClass(iClient, newClass);
		TF2_RegeneratePlayer(iClient);
	}
}

public Action Timer_SwitchBot(Handle timer, any userid)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	if (GetClientTeam(iClient) != TFTeam_Red || DidClientEscape(iClient)) return Plugin_Stop;
	
	if (!IsPlayerAlive(iClient)) return Plugin_Stop;
	
	int iRandom = GetRandomInt(1, 9);
	TFClassType tfNewClass;
	switch (iRandom)
	{
		case 1:tfNewClass = TFClass_Scout;
		case 2:tfNewClass = TFClass_Soldier;
		case 3:tfNewClass = TFClass_Pyro;
		case 4:tfNewClass = TFClass_DemoMan;
		case 5:tfNewClass = TFClass_Heavy;
		case 6:tfNewClass = TFClass_Engineer;
		case 7:tfNewClass = TFClass_Medic;
		case 8:tfNewClass = TFClass_Sniper;
		case 9:tfNewClass = TFClass_Spy;
	}
	TF2_SetPlayerClass(iClient, tfNewClass);
	TF2_RegeneratePlayer(iClient);
	
	return Plugin_Stop;
}

public Action Timer_IntroBlackOut(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	if (!IsRoundInIntro()) return Plugin_Stop;
	
	if (!IsPlayerAlive(iClient) || g_bPlayerEliminated[iClient]) return Plugin_Stop;
	
	// Black out the player's screen.
	int iFadeFlags = FFADE_OUT | FFADE_STAYOUT | FFADE_PURGE;
	UTIL_ScreenFade(iClient, 0, FixedUnsigned16(90.0, 1 << 12), iFadeFlags, g_iRoundIntroFadeColor[0], g_iRoundIntroFadeColor[1], g_iRoundIntroFadeColor[2], g_iRoundIntroFadeColor[3]);
	
	return Plugin_Stop;
}

public Action Event_PostInventoryApplication(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PostInventoryApplication");
	#endif
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient > 0)
	{
		ClientSwitchToWeaponSlot(iClient, TFWeaponSlot_Melee);
		g_hPlayerPostWeaponsTimer[iClient] = CreateTimer(0.1, Timer_ClientPostWeapons, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PostInventoryApplication");
	#endif
	delete event;
}
public Action Event_DontBroadcastToClients(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (IsRoundInWarmup()) return Plugin_Continue;
	
	SetEventBroadcast(event, true);
	delete event;
	return Plugin_Continue;
}

public Action Event_PlayerDeathPre(Event event, const char[] name, bool dB)
{
	if (!g_bEnabled) return Plugin_Continue;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT START: Event_PlayerDeathPre");
	#endif
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	
	int inflictor = event.GetInt("inflictor_entindex");
	
	// If this player was killed by a boss, play a sound.
	int npcIndex = NPCGetFromEntIndex(inflictor);
	if (npcIndex != -1 && !IsEntityAProjectile(inflictor))
	{
		int iSourceTV = GetClientOfUserId(g_iSourceTVUserID);
		int iAttackIndex = NPCGetCurrentAttackIndex(npcIndex);
		if (MaxClients >= iSourceTV > 0 && IsClientInGame(iSourceTV) && IsClientSourceTV(iSourceTV)) //If the server has a source TV bot uses to print boss' name in kill feed.
		{
			if (g_hTimerChangeSourceTVBotName != null)
				delete g_hTimerChangeSourceTVBotName;
			else //No timer running that means the SourceTV bot's current name is the correct one, we can safely update our last known SourceTV bot's name.
				GetEntPropString(iSourceTV, Prop_Data, "m_szNetname", g_sOldSourceTVClientName, sizeof(g_sOldSourceTVClientName));
			
			char sBossName[SF2_MAX_NAME_LENGTH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(npcIndex, sProfile, sizeof(sProfile));
			NPCGetBossName(npcIndex, sBossName, sizeof(sBossName));
			
			//TF2_ChangePlayerName(iSourceTV, sBossName, true);
			SetClientName(iSourceTV, sBossName);
			SetEntPropString(iSourceTV, Prop_Data, "m_szNetname", sBossName);
			
			event.SetString("assister_fallback", "");
			if ((NPCGetFlags(npcIndex) & SFF_WEAPONKILLS) || (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS))
			{
				if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLS)
				{
					char sWeaponType[PLATFORM_MAX_PATH];
					int iWeaponNum = NPCChaserGetAttackWeaponTypeInt(npcIndex, iAttackIndex);
					GetProfileAttackString(sProfile, "attack_weapontype", sWeaponType, sizeof(sWeaponType), "", iAttackIndex + 1);
					event.SetString("weapon_logclassname", sWeaponType);
					event.SetString("weapon", sWeaponType);
					event.SetInt("customkill", iWeaponNum);
				}
				else if (NPCGetFlags(npcIndex) & SFF_WEAPONKILLSONRADIUS)
				{
					char sWeaponType[PLATFORM_MAX_PATH];
					int iWeaponNum = GetProfileNum(sProfile, "kill_weapontypeint", 0);
					GetProfileString(sProfile, "kill_weapontype", sWeaponType, sizeof(sWeaponType));
					event.SetString("weapon_logclassname", sWeaponType);
					event.SetString("weapon", sWeaponType);
					event.SetInt("customkill", iWeaponNum);
				}
			}
			else
			{
				event.SetString("weapon", "");
				event.SetString("weapon_logclassname", "");
			}
			
			event.SetInt("attacker", g_iSourceTVUserID);
			g_hTimerChangeSourceTVBotName = CreateTimer(0.6, Timer_RevertSourceTVBotName);
		}
	}
	char sStringName[128];
	
	event.GetString("weapon", sStringName, sizeof(sStringName));
	
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_KILLICONS, 0, "String kill icon is %s, integer kill icon is %i.", sStringName, event.GetInt("customkill"));
	#endif
	
	if (IsEntityAProjectile(inflictor))
	{
		int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
		if (npcIndex2 != -1)
		{
			int iSourceTV = GetClientOfUserId(g_iSourceTVUserID);
			if (MaxClients >= iSourceTV > 0 && IsClientInGame(iSourceTV) && IsClientSourceTV(iSourceTV)) //If the server has a source TV bot uses to print boss' name in kill feed.
			{
				if (g_hTimerChangeSourceTVBotName != null)
					delete g_hTimerChangeSourceTVBotName;
				else //No timer running that means the SourceTV bot's current name is the correct one, we can safely update our last known SourceTV bot's name.
					GetEntPropString(iSourceTV, Prop_Data, "m_szNetname", g_sOldSourceTVClientName, sizeof(g_sOldSourceTVClientName));
				
				char sBossName[SF2_MAX_NAME_LENGTH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(npcIndex2, sProfile, sizeof(sProfile));
				NPCGetBossName(npcIndex2, sBossName, sizeof(sBossName));
				
				//TF2_ChangePlayerName(iSourceTV, sBossName, true);
				SetClientName(iSourceTV, sBossName);
				SetEntPropString(iSourceTV, Prop_Data, "m_szNetname", sBossName);
				
				event.SetString("assister_fallback", "");
				
				switch (ProjectileGetFlags(inflictor))
				{
					case PROJ_ROCKET:
					{
						event.SetString("weapon_logclassname", "tf_projectile_rocket");
						event.SetString("weapon", "tf_projectile_rocket");
					}
					case PROJ_MANGLER:
					{
						event.SetString("weapon_logclassname", "cow_mangler");
						event.SetString("weapon", "cow_mangler");
					}
					case PROJ_GRENADE:
					{
						event.SetString("weapon_logclassname", "tf_projectile_pipe");
						event.SetString("weapon", "tf_projectile_pipe");
					}
					case PROJ_FIREBALL, PROJ_ICEBALL, PROJ_FIREBALL_ATTACK, PROJ_ICEBALL_ATTACK:
					{
						event.SetString("weapon_logclassname", "spellbook_fireball");
						event.SetString("weapon", "spellbook_fireball");
					}
					case PROJ_SENTRYROCKET:
					{
						event.SetString("weapon_logclassname", "obj_sentrygun3");
						event.SetString("weapon", "obj_sentrygun3");
					}
				}
				
				event.SetInt("attacker", g_iSourceTVUserID);
				g_hTimerChangeSourceTVBotName = CreateTimer(0.6, Timer_RevertSourceTVBotName);
			}
		}
	}
	
	if (!IsRoundInWarmup())
	{
		if (iClient > 0)
		{
			if (g_bBackStabbed[iClient])
			{
				event.SetInt("customkill", TF_CUSTOM_BACKSTAB);
				g_bBackStabbed[iClient] = false;
			}
		}
	}
	if (MAX_BOSSES > npcIndex >= 0 && (g_bSlenderHasAshKillEffect[npcIndex] || g_bSlenderHasCloakKillEffect[npcIndex]
			 || g_bSlenderHasDecapKillEffect[npcIndex] || g_bSlenderHasDeleteKillEffect[npcIndex]
			 || g_bSlenderHasDissolveRagdollOnKill[npcIndex]
			 || g_bSlenderHasElectrocuteKillEffect[npcIndex] || g_bSlenderHasGoldKillEffect[npcIndex]
			 || g_bSlenderHasIceKillEffect[npcIndex] || g_bSlenderHasPlasmaRagdollOnKill[npcIndex]
			 || g_bSlenderHasPushRagdollOnKill[npcIndex] || g_bSlenderHasResizeRagdollOnKill[npcIndex]
			 || g_bSlenderHasBurnKillEffect[npcIndex] || g_bSlenderHasGibKillEffect[npcIndex]))
	{
		CreateTimer(0.01, Timer_ModifyRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderPlayerCustomDeathFlag[npcIndex])
	{
		event.SetInt("death_flags", g_iSlenderPlayerSetDeathFlag[npcIndex]);
	}
	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderHasDecapOrGibKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_DeGibRagdoll, GetClientUserId(iClient));
	}

	if (MAX_BOSSES > npcIndex >= 0 && g_bSlenderHasMultiKillEffect[npcIndex])
	{
		CreateTimer(0.01, Timer_MultiRagdoll, GetClientUserId(iClient));
	}
	if (IsEntityAProjectile(inflictor))
	{
		switch (ProjectileGetFlags(inflictor))
		{
			case PROJ_MANGLER: CreateTimer(0.01, Timer_ManglerRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			case PROJ_ICEBALL: CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
			case PROJ_ICEBALL_ATTACK: CreateTimer(0.01, Timer_IceRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (MAX_BOSSES > npcIndex >= 0 && NPCHasAttribute(npcIndex, "ignite player on death"))
	{
		float flValue = NPCGetAttributeValue(npcIndex, "ignite player on death");
		if (flValue > 0.0) TF2_IgnitePlayer(iClient, iClient);
	}

	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 1) DebugMessage("EVENT END: Event_PlayerDeathPre");
	#endif
	//CreateTimer(0.2, Timer_CheckEvent, event);
	//CreateTimer(0.4, Timer_CheckEvent, event);
	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

public Action Timer_CheckEvent(Handle timer, Event event)
{
	if (event || event != null || event != null) PrintToChatAll("PlayerDeathPre is valid");
	else PrintToChatAll("PlayerDeathPre is invalid");
	return Plugin_Stop;
}

public Action Event_PlayerHurt(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iClient <= 0) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerHurt");
	#endif
	
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker > 0)
	{
		if (g_bPlayerProxy[attacker])
		{
			g_iPlayerProxyControl[attacker] = 100;
		}
	}
	
	// Play any sounds, if any.
	if (g_bPlayerProxy[iClient])
	{
		int iProxyMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]);
		if (iProxyMaster != -1)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iProxyMaster, sProfile, sizeof(sProfile));
			
			char sBuffer[PLATFORM_MAX_PATH];
			if (GetRandomStringFromProfile(sProfile, "sound_proxy_hurt", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0')
			{
				int iChannel = g_iSlenderProxyHurtChannel[iProxyMaster];
				int iLevel = g_iSlenderProxyHurtLevel[iProxyMaster];
				int iFlags = g_iSlenderProxyHurtFlags[iProxyMaster];
				float flVolume = g_flSlenderProxyHurtVolume[iProxyMaster];
				int iPitch = g_iSlenderProxyHurtPitch[iProxyMaster];
				
				EmitSoundToAll(sBuffer, iClient, iChannel, iLevel, iFlags, flVolume, iPitch);
			}
		}
	}
	delete event;
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerHurt");
	#endif
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;

	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if (iClient <= 0) return;
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT START: Event_PlayerDeath(%d)", iClient);
	#endif
	
	bool bFake = view_as<bool>(event.GetInt("death_flags") & TF_DEATHFLAG_DEADRINGER);
	int inflictor = event.GetInt("inflictor_entindex");
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("inflictor = %d", inflictor);
	#endif
	
	if (!bFake)
	{
		ClientResetStatic(iClient);
		ClientResetSlenderStats(iClient);
		ClientResetCampingStats(iClient);
		ClientResetOverlay(iClient);
		ClientResetJumpScare(iClient);
		ClientResetInteractiveGlow(iClient);
		ClientDisableConstantGlow(iClient);
		ClientChaseMusicReset(iClient);
		ClientChaseMusicSeeReset(iClient);
		ClientAlertMusicReset(iClient);
		Client20DollarsMusicReset(iClient);
		Client90sMusicReset(iClient);
		ClientMusicReset(iClient);
		
		ClientResetFlashlight(iClient);
		ClientDeactivateUltravision(iClient);
		ClientResetSprint(iClient);
		ClientResetBreathing(iClient);
		ClientResetBlink(iClient);
		ClientResetDeathCam(iClient);
		
		ClientUpdateMusicSystem(iClient);
		
		PvP_SetPlayerPvPState(iClient, false, false, false);
		
		if (IsRoundInWarmup())
		{
			CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			if (!g_bPlayerEliminated[iClient])
			{
				if (IsFakeClient(iClient))
				{
					TF2_SetPlayerClass(iClient, TFClass_Sniper);
				}
				if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT) || g_bRenevantMultiEffect)
					CreateTimer(0.1, Timer_ReplacePlayerRagdoll, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				if (IsRoundInIntro() || !IsRoundPlaying() || DidClientEscape(iClient) || (SF_SpecialRound(SPECIALROUND_1UP) && g_bPlayerIn1UpCondition[iClient] && !g_bPlayerDied1Up[iClient]))
				{
					CreateTimer(0.3, Timer_RespawnPlayer, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				else
				{
					g_bPlayerEliminated[iClient] = true;
					g_bPlayerEscaped[iClient] = false;
					g_bPlayerFullyDied1Up[iClient] = true;
					g_hPlayerSwitchBlueTimer[iClient] = CreateTimer(0.5, Timer_PlayerSwitchToBlue, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				}
				if (g_iPlayerPreferences[iClient].PlayerPreference_GhostModeToggleState == 2)
					CreateTimer(0.25, Timer_ToggleGhostModeCommand, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
				if (SF_SpecialRound(SPECIALROUND_REALISM))
					StopSound(iClient, SNDCHAN_STATIC, MARBLEHORNETS_STATIC);
				if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && IsRoundPlaying() && !DidClientEscape(iClient))
				{
					for (int iReds = 1; iReds <= MaxClients; iReds++)
					{
						if (!IsValidClient(iReds) || 
							g_bPlayerEliminated[iReds] || 
							DidClientEscape(iReds) || 
							GetClientTeam(iReds) != TFTeam_Red || 
							!IsPlayerAlive(iReds)) continue;
						int iRandomNegative = GetRandomInt(1, 5);
						switch (iRandomNegative)
						{
							case 1:
							{
								TF2_MakeBleed(iReds, iReds, 4.0);
								EmitSoundToClient(iReds, BLEED_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 2:
							{
								TF2_AddCondition(iReds, TFCond_Jarated, 5.0);
								EmitSoundToClient(iReds, JARATE_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 3:
							{
								TF2_AddCondition(iReds, TFCond_Gas, 5.0);
								EmitSoundToClient(iReds, GAS_ROLL, iReds, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
							}
							case 4:
							{
								int iMaxHealth = SDKCall(g_hSDKGetMaxHealth, iReds);
								float flDamageToTake = float(iMaxHealth) / 10.0;
								SDKHooks_TakeDamage(iReds, iReds, iReds, flDamageToTake, 128, _, view_as<float>( { 0.0, 0.0, 0.0 } ));
							}
							case 5:
							{
								TF2_AddCondition(iReds, TFCond_MarkedForDeath, 5.0);
							}
						}
					}
				}
			}
			else
			{
			}
			
			
			// If this player was killed by a boss, play a sound, or print a message.
			int npcIndex = NPCGetFromEntIndex(inflictor);
			if (npcIndex != -1)
			{
				int iSlender = NPCGetEntIndex(npcIndex);
				if (iSlender && iSlender != INVALID_ENT_REFERENCE) g_iPlayerBossKillSubject[iClient] = EntIndexToEntRef(iSlender);
				
				char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], sBossName[SF2_MAX_NAME_LENGTH];
				NPCGetProfile(npcIndex, npcProfile, sizeof(npcProfile));
				NPCGetBossName(npcIndex, sBossName, sizeof(sBossName));

				#if defined _store_included
				int iDifficulty = GetLocalGlobalDifficulty(npcIndex);
				if (NPCGetDrainCreditState(npcIndex))
				{
					Store_SetClientCredits(iClient, Store_GetClientCredits(iClient) - NPCGetDrainCreditAmount(npcIndex, iDifficulty));
					CPrintToChat(iClient, "{valve}%s{default} has stolen {green}%i credits{default} from you.", sBossName, NPCGetDrainCreditAmount(npcIndex, iDifficulty));
				}
				#endif
				
				if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_client", buffer, sizeof(buffer)) && buffer[0] != '\0')
				{
					if (g_bPlayerEliminated[iClient])
					{
						EmitSoundToClient(iClient, buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}
				
				if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_all", buffer, sizeof(buffer)) && buffer[0] != '\0')
				{
					if (g_bPlayerEliminated[iClient])
					{
						EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
					}
				}
				
				SlenderPrintChatMessage(npcIndex, iClient);
				
				SlenderPerformVoice(npcIndex, "sound_attack_killed");
			}
			
			if (IsEntityAProjectile(inflictor))
			{
				int npcIndex2 = NPCGetFromEntIndex(GetEntPropEnt(inflictor, Prop_Send, "m_hOwnerEntity"));
				if (npcIndex2 != -1)
				{
					int iSlender = NPCGetEntIndex(npcIndex2);
					if (iSlender && iSlender != INVALID_ENT_REFERENCE)g_iPlayerBossKillSubject[iClient] = EntIndexToEntRef(iSlender);
					
					char npcProfile[SF2_MAX_PROFILE_NAME_LENGTH], buffer[PLATFORM_MAX_PATH], sBossName[SF2_MAX_NAME_LENGTH];
					NPCGetProfile(npcIndex2, npcProfile, sizeof(npcProfile));
					NPCGetBossName(npcIndex2, sBossName, sizeof(sBossName));

					#if defined _store_included
					int iDifficulty = GetLocalGlobalDifficulty(npcIndex2);
					if (NPCGetDrainCreditState(npcIndex2))
					{
						Store_SetClientCredits(iClient, Store_GetClientCredits(iClient) - NPCGetDrainCreditAmount(npcIndex2, iDifficulty));
						CPrintToChat(iClient, "{valve}%s{default} has stolen {green}%i credits{default} from you.", sBossName, NPCGetDrainCreditAmount(npcIndex2, iDifficulty));
					}
					#endif
					
					
					if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_client", buffer, sizeof(buffer)) && buffer[0] != '\0')
					{
						if (g_bPlayerEliminated[iClient])
						{
							EmitSoundToClient(iClient, buffer, _, SNDCHAN_STATIC);
						}
					}
					
					if (GetRandomStringFromProfile(npcProfile, "sound_attack_killed_all", buffer, sizeof(buffer)) && buffer[0] != '\0')
					{
						if (g_bPlayerEliminated[iClient])
						{
							EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
						}
					}
					
					SlenderPrintChatMessage(npcIndex2, iClient);
					
					SlenderPerformVoice(npcIndex2, "sound_attack_killed");
				}
			}
			
			CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
			
			// Notify to other bosses that this player has died.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				if (NPCGetUniqueID(i) == -1) continue;
				
				if (EntRefToEntIndex(g_iSlenderTarget[i]) == iClient)
				{
					g_iSlenderInterruptConditions[i] |= COND_CHASETARGETINVALIDATED;
					GetClientAbsOrigin(iClient, g_flSlenderChaseDeathPosition[i]);
				}
			}
			
			if (g_cvIgnoreRedPlayerDeathSwap.BoolValue)
			{
				g_bPlayerEliminated[iClient] = false;
				g_bPlayerEscaped[iClient] = false;
			}
		}
		
		if (g_bPlayerProxy[iClient])
		{
			// We're a proxy, so play some sounds.
			
			int iProxyMaster = NPCGetFromUniqueID(g_iPlayerProxyMaster[iClient]);
			if (iProxyMaster != -1)
			{
				char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
				NPCGetProfile(iProxyMaster, sProfile, sizeof(sProfile));
				
				char sBuffer[PLATFORM_MAX_PATH];
				if (GetRandomStringFromProfile(sProfile, "sound_proxy_death", sBuffer, sizeof(sBuffer)) && sBuffer[0] != '\0')
				{
					int iChannel = g_iSlenderProxyDeathChannel[iProxyMaster];
					int iLevel = g_iSlenderProxyDeathLevel[iProxyMaster];
					int iFlags = g_iSlenderProxyDeathFlags[iProxyMaster];
					float flVolume = g_flSlenderProxyDeathVolume[iProxyMaster];
					int iPitch = g_iSlenderProxyDeathPitch[iProxyMaster];
					
					EmitSoundToAll(sBuffer, iClient, iChannel, iLevel, iFlags, flVolume, iPitch);
				}
			}
		}
		
		ClientResetProxy(iClient, false);
		ClientUpdateListeningFlags(iClient);
		
		// Half-Zatoichi nerf code.
		int iKatanaHealthGain = 10;
		if (iKatanaHealthGain >= 0)
		{
			int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
			if (iAttacker > 0)
			{
				if (!IsClientInPvP(iAttacker) && (!g_bPlayerEliminated[iAttacker] || g_bPlayerProxy[iAttacker]))
				{
					char sWeapon[64];
					event.GetString("weapon", sWeapon, sizeof(sWeapon));
					
					if (strcmp(sWeapon, "demokatana") == 0)
					{
						int iAttackerPreHealth = GetEntProp(iAttacker, Prop_Send, "m_iHealth");
						Handle hPack = CreateDataPack();
						WritePackCell(hPack, GetClientUserId(iAttacker));
						WritePackCell(hPack, iAttackerPreHealth + iKatanaHealthGain);
						
						CreateTimer(0.0, Timer_SetPlayerHealth, hPack, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
		
		g_hPlayerPostWeaponsTimer[iClient] = null;
		g_hPlayerIgniteTimer[iClient] = null;
		g_hPlayerResetIgnite[iClient] = null;
		g_hPlayerPageRewardTimer[iClient] = null;
		g_hPlayerPageRewardCycleTimer[iClient] = null;
		g_hPlayerFireworkTimer[iClient] = null;
		
		g_bPlayerGettingPageReward[iClient] = false;
		g_iPlayerHitsToCrits[iClient] = 0;
		g_iPlayerHitsToHeads[iClient] = 0;
		
		g_bPlayerTrapped[iClient] = false;
		g_iPlayerTrapCount[iClient] = 0;
		
		g_iPlayerRandomClassNumber[iClient] = 1;
	}
	if (!IsRoundEnding() && !g_bRoundWaitingForPlayers)
	{
		int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
		if (IsRoundPlaying() && iClient != iAttacker)
		{
			//Copy the data
			char sString[64];
			Event event2 = CreateEvent("player_death", true);
			event2.SetInt("userid", event.GetInt("userid"));
			event2.SetInt("victim_entindex", event.GetInt("victim_entindex"));
			event2.SetInt("inflictor_entindex", event.GetInt("inflictor_entindex"));
			event2.SetInt("attacker", event.GetInt("attacker"));
			event2.SetInt("weaponid", event.GetInt("weaponid"));
			event2.SetInt("damagebits", event.GetInt("damagebits"));
			event2.SetInt("customkill", event.GetInt("customkill"));
			event2.SetInt("assister", event.GetInt("assister"));
			event2.SetInt("stun_flags", event.GetInt("stun_flags"));
			event2.SetInt("death_flags", event.GetInt("death_flags"));
			event2.SetBool("silent_kill", event.GetBool("silent_kill"));
			event2.SetInt("playerpenetratecount", event.GetInt("playerpenetratecount"));
			event2.SetInt("kill_streak_total", event.GetInt("kill_streak_total"));
			event2.SetInt("kill_streak_wep", event.GetInt("kill_streak_wep"));
			event2.SetInt("kill_streak_assist", event.GetInt("kill_streak_assist"));
			event2.SetInt("kill_streak_victim", event.GetInt("kill_streak_victim"));
			event2.SetInt("ducks_streaked", event.GetInt("ducks_streaked"));
			event2.SetInt("duck_streak_total", event.GetInt("duck_streak_total"));
			event2.SetInt("duck_streak_assist", event.GetInt("duck_streak_assist"));
			event2.SetInt("duck_streak_victim", event.GetInt("duck_streak_victim"));
			event2.SetBool("rocket_jump", event.GetBool("rocket_jump"));
			event2.SetInt("weapon_def_index", event.GetInt("weapon_def_index"));
			event.GetString("weapon_logclassname", sString, sizeof(sString));
			event2.SetString("weapon_logclassname", sString);
			event.GetString("assister_fallback", sString, sizeof(sString));
			event2.SetString("assister_fallback", sString);
			event.GetString("weapon", sString, sizeof(sString));
			event2.SetString("weapon", sString);

			CreateTimer(0.2, Timer_SendDeath, event2);
		}
	}
	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	PvP_OnPlayerDeath(iClient, bFake);
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("EVENT END: Event_PlayerDeath(%d)", iClient);
	#endif
	delete event;
}

public Action Timer_ToggleGhostModeCommand(Handle timer, any userid)
{
	if (!g_bEnabled) return Plugin_Stop;
	
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	if (IsRoundEnding() || IsRoundInWarmup() || !g_bPlayerEliminated[iClient] || !IsClientParticipating(iClient) || g_bPlayerProxy[iClient] || IsClientInPvP(iClient) || IsClientInKart(iClient) || TF2_IsPlayerInCondition(iClient, TFCond_Taunting) || TF2_IsPlayerInCondition(iClient, TFCond_Charging))
	{
		CPrintToChat(iClient, "{red}%T", "SF2 Ghost Mode Not Allowed", iClient);
		return Plugin_Stop;
	}
	if (!IsClientInGhostMode(iClient))
	{
		TF2_RespawnPlayer(iClient);
		ClientSetGhostModeState(iClient, true);
		HandlePlayerHUD(iClient);
		TF2_AddCondition(iClient, TFCond_StealthedUserBuffFade, -1.0);
		
		CPrintToChat(iClient, "{dodgerblue}%T", "SF2 Ghost Mode Enabled", iClient);
	}
	
	return Plugin_Stop;
}

public Action Timer_SendDeath(Handle timer, Event event)
{
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	if (iClient > 0)
	{
		//Send it to the clients
		for (int i = 1; i<=MaxClients; i++)
		{
			if(IsValidClient(i))
			{
				if (!g_bPlayerEliminated[iClient] || g_bPlayerEliminated[i] || GetClientTeam(iClient) == GetClientTeam(i)) event.FireToClient(i);
			}
		}
	}
	event.Cancel();
	return Plugin_Stop;
}

public Action Timer_RevertSourceTVBotName(Handle timer)
{
	g_hTimerChangeSourceTVBotName = null;
	int iSourceTV = GetClientOfUserId(g_iSourceTVUserID);
	if (MaxClients >= iSourceTV > 0 && IsClientInGame(iSourceTV) && IsClientSourceTV(iSourceTV))
	{
		//TF2_ChangePlayerName(iSourceTV, g_sOldSourceTVClientName, true);
		SetClientName(iSourceTV, g_sOldSourceTVClientName);
		SetEntPropString(iSourceTV, Prop_Data, "m_szNetname", g_sOldSourceTVClientName);
	}
	return Plugin_Continue;
}

public Action Timer_CheckAlivePlayers(Handle timer)
{
	if (!g_bEnabled || !SF_IsBoxingMap()) return Plugin_Stop;
	
	int iClients[MAXPLAYERS + 1];
	int iClientsNum;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || !IsClientInGame(i) || g_bPlayerEliminated[i]) continue;
		
		iClients[iClientsNum] = i;
		iClientsNum++;
	}
	
	switch (iClientsNum)
	{
		case 1:
		{
			for (int i = 0; i < iClientsNum; i++)
			{
				int iClient = iClients[i];
				TF2_AddCondition(iClient, TFCond_HalloweenCritCandy, -1.0);
			}
			if (!g_bPlayersAreCritted)
			{
				if (g_iRoundTime > 120)
				{
					SetRoundTime(120);
					CPrintToChatAll("Only 1 {red}RED{default} player is alive, 2 minutes left on the timer...");
					for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
					{
						if (NPCGetUniqueID(iNPCIndex) == -1) continue;
						NPCSetAddSpeed(iNPCIndex, 50.0);
						NPCSetAddMaxSpeed(iNPCIndex, 75.0);
						NPCSetAddAcceleration(iNPCIndex, 250.0);
					}
					g_bPlayersAreCritted = true;
				}
				else
				{
					CPrintToChatAll("Only 1 {red}RED{default} player is alive...");
					for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
					{
						if (NPCGetUniqueID(iNPCIndex) == -1) continue;
						NPCSetAddSpeed(iNPCIndex, 50.0);
						NPCSetAddMaxSpeed(iNPCIndex, 75.0);
						NPCSetAddAcceleration(iNPCIndex, 250.0);
					}
					g_bPlayersAreCritted = true;
				}
			}
		}
		case 2, 3:
		{
			if (!g_bPlayersAreMiniCritted)
			{
				if (g_iRoundTime > 200)
				{
					SetRoundTime(200);
					CPrintToChatAll("3 {red}RED{default} players are alive, 3 minutes and 20 seconds left on the timer...");
					for (int i = 0; i < iClientsNum; i++)
					{
						int iClient = iClients[i];
						TF2_AddCondition(iClient, TFCond_Buffed, -1.0);
					}
					g_bPlayersAreMiniCritted = true;
				}
				else
				{
					CPrintToChatAll("3 {red}RED{default} players are alive...");
					for (int i = 0; i < iClientsNum; i++)
					{
						int iClient = iClients[i];
						TF2_AddCondition(iClient, TFCond_Buffed, -1.0);
					}
					g_bPlayersAreMiniCritted = true;
				}
			}
		}
		default:
		{
			for (int i = 0; i < iClientsNum; i++)
			{
				int iClient = iClients[i];
				TF2_RemoveCondition(iClient, TFCond_Buffed);
				TF2_RemoveCondition(iClient, TFCond_HalloweenCritCandy);
			}
			g_bPlayersAreCritted = false;
			g_bPlayersAreMiniCritted = false;
		}
	}
	return Plugin_Stop;
}

public Action Timer_ReplacePlayerRagdoll(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		int iDeathType = GetRandomInt(1, 8);
		switch (iDeathType)
		{
			case 1:
			{
				velocity[0] = 40.0;
				velocity[1] = 40.0;
				velocity[2] = 40.0;
				force[0] = 40.0;
				force[1] = 40.0;
				force[2] = 40.0;
				ScaleVector(velocity, 10000.0);
				ScaleVector(force, 10000.0);
				velocity[0] = 0.0;
				velocity[1] = 0.0;
				force[0] = 0.0;
				force[1] = 0.0;
				SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
			}
			case 2:
			{
				SetEntProp(ent, Prop_Send, "m_bGib", true);
			}
			case 3:
			{
				SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", true);
			}
			case 4:
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			}
			case 5:
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			}
			case 6:
			{
				SetEntProp(ent, Prop_Send, "m_bBurning", true);
			}
			case 7:
			{
				SetEntProp(ent, Prop_Send, "m_bElectrocuted", true);
			}
			case 8:
			{
				velocity[0] = 40.0;
				velocity[1] = 40.0;
				velocity[2] = 40.0;
				force[0] = 40.0;
				force[1] = 40.0;
				force[2] = 40.0;
				MakeVectorFromPoints(pos, view_as<float>( { 0.0, 0.0, 0.0 } ), velocity);
				ScaleVector(velocity, 20000.0);
				ScaleVector(force, 20000.0);
				SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
			}
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	RemoveEntity(ragdoll);
	return Plugin_Stop;
}

public Action Timer_IceRagdoll(Handle timer, any userid)
{
	
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		int iIce = GetRandomInt(1, 2);
		switch (iIce)
		{
			case 1:
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			}
			case 2:
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			}
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Stop;
}

public Action Timer_ManglerRagdoll(Handle timer, any userid)
{
	
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_PLASMA);
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Stop;
}

public Action Timer_AshRagdoll(Handle timer, any userid)
{
	
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		int iAsh = GetRandomInt(1, 2);
		switch (iAsh)
		{
			case 1:
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			}
			case 2:
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			}
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Stop;
}

public Action Timer_DeGibRagdoll(Handle timer, any userid)
{

	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Continue;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Continue;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		int iDeGib = GetRandomInt(1, 2);
		switch (iDeGib)
		{
			case 1:
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_DECAPITATION);
			}
			case 2:
			{
				SetEntProp(ent, Prop_Send, "m_bGib", true);
			}
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Continue;
}

public Action Timer_MultiRagdoll(Handle timer, any userid)
{

	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Continue;
	}
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Continue;
	}
	int ent = CreateEntityByName("tf_ragdoll", -1);
	if (ent != -1)
	{
		float pos[3], ang[3], velocity[3], force[3];
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
		GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
		GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
		TeleportEntity(ent, pos, ang, NULL_VECTOR);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
		SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
		SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
		SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
		SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
		SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
		SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
		SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
		SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
		SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
		SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
		SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
		SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
		SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
		SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
		SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
		SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
		SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
		SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
		int iMulti = GetRandomInt(1, 9);
		switch (iMulti)
		{
			case 1:
			{
				SetEntProp(ent, Prop_Send, "m_bGib", true);
			}
			case 2:
			{
				SetEntProp(ent, Prop_Send, "m_bBurning", true);
			}
			case 3:
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			}
			case 4:
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_DECAPITATION);
			}
			case 5:
			{
				SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", true);
			}			
			case 6:
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			}
			case 7:
			{
				SetEntProp(ent, Prop_Send, "m_bElectrocuted", true);
			}
			case 8:
			{
				SetEntProp(ent, Prop_Send, "m_bCloaked", true);
			}
			case 9:
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_PLASMA);
			}
		}
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Continue;
}

public Action Timer_ModifyRagdoll(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int iSlender = EntRefToEntIndex(g_iPlayerBossKillSubject[client]);
	if (!iSlender || iSlender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	int iBossIndex = NPCGetFromEntIndex(iSlender);
	if (iBossIndex == -1) return Plugin_Stop;
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	if (!g_bSlenderHasDeleteKillEffect[iBossIndex])
	{
		int ent = CreateEntityByName("tf_ragdoll", -1);
		if (ent != -1)
		{
			float pos[3], ang[3], velocity[3], force[3];
			GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollOrigin", pos);
			GetEntPropVector(ragdoll, Prop_Send, "m_vecRagdollVelocity", velocity);
			GetEntPropVector(ragdoll, Prop_Send, "m_vecForce", force);
			GetEntPropVector(ragdoll, Prop_Data, "m_angAbsRotation", ang);
			TeleportEntity(ent, pos, ang, NULL_VECTOR);
			SetEntPropVector(ent, Prop_Send, "m_vecRagdollOrigin", pos);
			if (g_bSlenderHasPushRagdollOnKill[iBossIndex])
			{
				float flForce[3];
				GetProfileVector(sProfile, "push_ragdoll_force", flForce);
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", flForce);
				SetEntPropVector(ent, Prop_Send, "m_vecForce", flForce);
			}
			else
			{
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
				SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
			}
			if (g_bSlenderHasResizeRagdollOnKill[iBossIndex])
			{
				SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", g_flSlenderResizeRagdollHead[iBossIndex]);
				SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", g_flSlenderResizeRagdollTorso[iBossIndex]);
				SetEntPropFloat(ent, Prop_Send, "m_flHandScale", g_flSlenderResizeRagdollHands[iBossIndex]);
			}
			else
			{
				SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
				SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
				SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
			}
			SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
			SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));
			
			if (g_bSlenderHasCloakKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bCloaked", true);
			else SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
			
			SetEntProp(ent, Prop_Send, "m_iPlayerIndex", GetEntProp(ragdoll, Prop_Send, "m_iPlayerIndex"));
			SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
			SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
			SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
			SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));
			
			if (g_bSlenderHasGibKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bGib", true);
			else SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
			
			if (g_bSlenderHasDecapKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_DECAPITATION);
			else if (g_bSlenderHasPlasmaRagdollOnKill[iBossIndex])SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_PLASMA);
			else SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
			
			if (g_bSlenderHasBurnKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bBurning", true);
			else SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
			
			if (g_bSlenderHasAshKillEffect[iBossIndex])
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			else SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
			
			if (g_bSlenderHasGoldKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", true);
			else SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
			
			if (g_bSlenderHasIceKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			else SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
			
			if (g_bSlenderHasElectrocuteKillEffect[iBossIndex])SetEntProp(ent, Prop_Send, "m_bElectrocuted", true);
			else SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
			
			DispatchSpawn(ent);
			ActivateEntity(ent);
			SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
		}
		if (g_bSlenderHasDissolveRagdollOnKill[iBossIndex])
		{
			int dissolver = CreateEntityByName("env_entity_dissolver");
			if (!IsValidEntity(dissolver))
			{
				return Plugin_Stop;
			}
			char sType[2];
			int iType = g_iSlenderDissolveRagdollType[iBossIndex];
			FormatEx(sType, sizeof(sType), "%d", iType);
			DispatchKeyValue(dissolver, "dissolvetype", sType);
			DispatchKeyValue(dissolver, "magnitude", "1");
			DispatchKeyValue(dissolver, "target", "!activator");
			
			AcceptEntityInput(dissolver, "Dissolve", ent);
			RemoveEntity(dissolver);
		}
	}
	RemoveEntity(ragdoll);
	return Plugin_Stop;
}

public Action Timer_SetPlayerHealth(Handle timer, any data)
{
	Handle hPack = view_as<Handle>(data);
	ResetPack(hPack);
	int iAttacker = GetClientOfUserId(ReadPackCell(hPack));
	int iHealth = ReadPackCell(hPack);
	delete hPack;
	
	if (iAttacker <= 0) return Plugin_Stop;
	
	SetEntProp(iAttacker, Prop_Data, "m_iHealth", iHealth);
	SetEntProp(iAttacker, Prop_Send, "m_iHealth", iHealth);
	
	return Plugin_Stop;
}

public Action Timer_PlayerSwitchToBlue(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	
	if (timer != g_hPlayerSwitchBlueTimer[iClient]) return Plugin_Stop;
	if (g_cvIgnoreRedPlayerDeathSwap.BoolValue) return Plugin_Stop;

	ChangeClientTeam(iClient, TFTeam_Blue);
	
	if (TF2_GetPlayerClass(iClient) == view_as<TFClassType>(0))
	{
		// Player hasn't chosen a class for some reason. Choose one for him.
		TF2_SetPlayerClass(iClient, view_as<TFClassType>(GetRandomInt(1, 9)), true, true);
	}
	
	return Plugin_Stop;
}

stock int ProjectileGetFlags(int iProjectile)
{
	return g_iProjectileFlags[iProjectile];
}

stock void ProjectileSetFlags(int iProjectile, int iFlags)
{
	g_iProjectileFlags[iProjectile] = iFlags;
}

stock int AttachParticle(int entity, char[] particleType, float posOffset[3] = { 0.0, 0.0, 0.0 } )
{
	int particle = CreateEntityByName("info_particle_system");
	
	if (IsValidEntity(particle))
	{
		SetEntPropEnt(particle, Prop_Data, "m_hOwnerEntity", entity);
		DispatchKeyValue(particle, "effect_name", particleType);
		SetVariantString("!activator");
		AcceptEntityInput(particle, "SetParent", entity, particle, 0);
		float vec_start[3];
		TeleportEntity(particle, vec_start, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(particle);
		
		AcceptEntityInput(particle, "start");
		ActivateEntity(particle);
		
		return EntIndexToEntRef(particle);
	}
	return -1;
}

void CreateGeneralParticle(int entity, const char[] sSectionName, float time, float flParticleZPos = 0.0)
{
	if (entity == -1) return;
	
	float flSlenderPosition[3];
	GetEntPropVector(entity, Prop_Data, "m_vecOrigin", flSlenderPosition);
	flSlenderPosition[2] += flParticleZPos;
	
	int iParticle = CreateEntityByName("info_particle_system");
	
	char sName[64];
	
	if (iParticle != -1 && entity != -1)
	{
		TeleportEntity(iParticle, flSlenderPosition, NULL_VECTOR, NULL_VECTOR);
		
		GetEntPropString(entity, Prop_Data, "m_iName", sName, sizeof(sName));
		
		DispatchKeyValue(iParticle, "targetname", "tf2particle");
		DispatchKeyValue(iParticle, "parentname", sName);
		DispatchKeyValue(iParticle, "effect_name", sSectionName);
		
		DispatchSpawn(iParticle);
		SetVariantString(sName);
		
		AcceptEntityInput(iParticle, "SetParent", iParticle, iParticle, 0);
		ActivateEntity(iParticle);
		AcceptEntityInput(iParticle, "start");
		
		CreateTimer(time, Timer_KillEdict, iParticle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_RoundStart(Handle timer)
{
	if (g_iPageMax > 0)
	{
		ArrayList hArrayClients = new ArrayList();
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArrayClients in Timer_RoundStart.", hArrayClients);
		#endif
		int iClients[MAXPLAYERS + 1];
		int iClientsNum = 0;
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || IsFakeClient(i) || g_bPlayerEliminated[i]) continue;
			
			hArrayClients.Push(GetClientUserId(i));
			iClients[iClientsNum] = i;
			iClientsNum++;
		}
		
		// Show difficulty menu.
		if (!SF_IsBoxingMap() && !SF_IsRenevantMap() && !SF_SpecialRound(SPECIALROUND_MODBOSSES))
		{
			if (iClientsNum)
			{
				// Automatically set it to Normal.
				g_cvDifficulty.SetInt(Difficulty_Normal);
				
				g_hVoteTimer = CreateTimer(1.0, Timer_VoteDifficulty, hArrayClients, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
				TriggerTimer(g_hVoteTimer, true);
				
				int iGameText = -1;
				char sMessage[512];
				
				if (g_GamerulesEntity.IsValid() && g_GamerulesEntity.IntroTextEntity.IsValid())
				{
					// Do nothing; already being handled.
				}
				else if ((iGameText = GetTextEntity("sf2_intro_message", false)) != -1)
				{
					GetEntPropString(iGameText, Prop_Data, "m_iszMessage", sMessage, sizeof(sMessage));
					ShowHudTextUsingTextEntity(iClients, iClientsNum, iGameText, g_hHudSync, sMessage);
				}
				else
				{
					for (int i = 0; i < iClientsNum; i++)
					{
						int iClient = iClients[i];
						FormatEx(sMessage, sizeof(sMessage), "%T", g_iPageMax > 1 ? "SF2 Default Intro Message Plural" : "SF2 Default Intro Message Singular", iClient, g_iPageMax);
						ClientShowMainMessage(iClient, sMessage);
					}
				}
			}
			else
			{
				delete hArrayClients;
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArrayClients in Timer_RoundStart due to 0 clients.", hArrayClients);
				#endif
			}
		}
		else
		{
			delete hArrayClients;
			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArrayClients in Timer_RoundStart.", hArrayClients);
			#endif
		}
	}
	
	return Plugin_Stop;
}

public Action Timer_CheckRoundWinConditions(Handle timer)
{
	CheckRoundWinConditions();
	return Plugin_Stop;
}

public Action Timer_RoundGrace(Handle timer)
{
	if (timer != g_hRoundGraceTimer) return Plugin_Stop;
	
	SetRoundState(SF2RoundState_Active);
	return Plugin_Stop;
}

public Action Timer_RoundTime(Handle timer)
{
	if (timer != g_hRoundTimer) return Plugin_Stop;
	
	if (g_iRoundTime <= 0)
	{
		//The round ended trigger a security timer.
		SF_FailEnd();
		SF_FailRoundEnd(2.0);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_bPlayerEliminated[i] || IsClientInGhostMode(i)) continue;
			
			float flBuffer[3];
			GetClientAbsOrigin(i, flBuffer);
			ClientStartDeathCam(i, 0, flBuffer, true);
			g_bPlayerDied1Up[i] = false;
			g_bPlayerIn1UpCondition[i] = false;
			KillClient(i);
		}
		
		return Plugin_Stop;
	}
	if (SF_SpecialRound(SPECIALROUND_REVOLUTION))
	{
		if (g_iSpecialRoundTime % 60 == 0)
		{
			SpecialRoundCycleStart();
		}
	}
	
	if (g_bSpecialRound)
		g_iSpecialRoundTime++;
	
	SetRoundTime(g_iRoundTime - 1);
	
	if (SF_SpecialRound(SPECIALROUND_REALISM))
	{
		return Plugin_Continue;
	}
	
	int hours, minutes, seconds;
	FloatToTimeHMS(float(g_iRoundTime), hours, minutes, seconds);
	
	SetHudTextParams(-1.0, 0.1, 
		1.0, 
		SF2_HUD_TEXT_COLOR_R, SF2_HUD_TEXT_COLOR_G, SF2_HUD_TEXT_COLOR_B, SF2_HUD_TEXT_COLOR_A, 
		_, 
		_, 
		1.5, 1.5);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i) || (g_bPlayerEliminated[i] && !IsClientInGhostMode(i))) continue;
		if (SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
			ShowSyncHudText(i, g_hRoundTimerSync, "%d/%d\n??:??", g_iPageCount, g_iPageMax);
		else
			ShowSyncHudText(i, g_hRoundTimerSync, "%d/%d\n%d:%02d", g_iPageCount, g_iPageMax, minutes, seconds);
	}
	
	return Plugin_Continue;
}

public Action Timer_RoundTimeEscape(Handle timer)
{
	if (timer != g_hRoundTimer) return Plugin_Stop;
	
	if (g_iRoundTime <= 0)
	{
		//The round ended trigger a security timer.
		SF_FailEnd();
		SF_FailRoundEnd(2.0);
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_bPlayerEliminated[i] || IsClientInGhostMode(i) || DidClientEscape(i)) continue;
			
			float flBuffer[3];
			GetClientAbsOrigin(i, flBuffer);
			ClientStartDeathCam(i, 0, flBuffer, true);
			g_bPlayerDied1Up[i] = false;
			g_bPlayerIn1UpCondition[i] = false;
			KillClient(i);
		}
		return Plugin_Stop;
	}
	
	if (SF_SpecialRound(SPECIALROUND_REVOLUTION))
	{
		if (g_iSpecialRoundTime % 60 == 0)
		{
			SpecialRoundCycleStart();
		}
	}
	
	if ((1.0 - ((float(g_iRoundTime)) / (float(g_iRoundEscapeTimeLimit + g_iTimeEscape)))) >= 0.65)
	{
		if (!g_bProxySurvivalRageMode && !SF_IsRenevantMap())
		{
			bool bProxyBoss = false;
			for (int iBossIndex = 0; iBossIndex < MAX_BOSSES; iBossIndex++)
			{
				if (NPCGetUniqueID(iBossIndex) == -1) continue;
				
				if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) continue;
				
				bProxyBoss = true;
				break;
			}
			
			if (bProxyBoss)
			{
				int iAlivePlayer = 0;
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (IsClientInGame(iClient) && IsPlayerAlive(iClient) && !g_bPlayerEliminated[iClient])
					{
						iAlivePlayer++;
					}
				}
				
				if (iAlivePlayer >= (GetMaxPlayersForRound() / 2)) //Too many players are still alive... enter rage mode!
				{
					g_bProxySurvivalRageMode = true;
					EmitSoundToAll(PROXY_RAGE_MODE_SOUND);
					EmitSoundToAll(PROXY_RAGE_MODE_SOUND);
				}
			}
		}
	}
	
	int hours, minutes, seconds;
	FloatToTimeHMS(float(g_iRoundTime), hours, minutes, seconds);
	
	SetHudTextParams(-1.0, 0.1, 
		1.0, 
		SF2_HUD_TEXT_COLOR_R, 
		SF2_HUD_TEXT_COLOR_G, 
		SF2_HUD_TEXT_COLOR_B, 
		SF2_HUD_TEXT_COLOR_A, 
		_, 
		_, 
		1.5, 1.5);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i) || (g_bPlayerEliminated[i] && !IsClientInGhostMode(i))) continue;
		
		if (!SF_SpecialRound(SPECIALROUND_REALISM))
		{
			char sText[512];
			if (SF_IsBoxingMap())
				FormatEx(sText, sizeof(sText), "%T", "SF2 Default Boxing Message", i);
			else
			{
				if (SF_IsSurvivalMap() && g_iRoundTime > g_iTimeEscape)
					FormatEx(sText, sizeof(sText), "%T", "SF2 Default Survive Message", i);
				else
					FormatEx(sText, sizeof(sText), "%T", "SF2 Default Escape Message", i);
			}
			
			char sTimerText[128];
			if (SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
				strcopy(sTimerText, sizeof(sTimerText), "\n??:??");
			else
				FormatEx(sTimerText, sizeof(sTimerText), "\n%d:%02d", minutes, seconds);
			
			StrCat(sText, sizeof(sText), sTimerText);
			
			ShowSyncHudText(i, g_hRoundTimerSync, sText);
		}
	}
	if (g_bSpecialRound)
		g_iSpecialRoundTime++;
	
	SetRoundTime(g_iRoundTime - 1);
	
	return Plugin_Continue;
}

public Action Timer_VoteDifficulty(Handle timer, any data)
{
	ArrayList hArrayClients = view_as<ArrayList>(data);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArrayClients in Timer_VoteDifficulty.", hArrayClients);
	#endif
	
	if (timer != g_hVoteTimer || IsRoundEnding())
	{
		delete hArrayClients;
		return Plugin_Stop;
	}
	
	if (IsVoteInProgress()) return Plugin_Continue; // There's another vote in progess. Wait.
	
	int iClients[MAXPLAYERS + 1] = { -1, ... };
	int iClientsNum;
	for (int i = 0, iSize = hArrayClients.Length; i < iSize; i++)
	{
		int iClient = GetClientOfUserId(hArrayClients.Get(i));
		if (iClient <= 0) continue;
		
		iClients[iClientsNum] = iClient;
		iClientsNum++;
	}
	
	delete hArrayClients;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hArrayClients in Timer_VoteDifficulty.", hArrayClients);
	#endif
	
	RandomizeVoteMenu();
	VoteMenu(g_hMenuVoteDifficulty, iClients, iClientsNum, 15);
	
	return Plugin_Stop;
}

void SF_FailRoundEnd(float time = 2.0)
{
	//Check round win conditions again.
	CreateTimer((time - 0.8), Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
	
	if (!g_cvIgnoreRoundWinConditions.BoolValue)
	{
		g_hTimerFail = CreateTimer(time, Timer_Fail, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

void SF_FailEnd()
{
	if (g_hTimerFail != null)
		KillTimer(g_hTimerFail);
	g_hTimerFail = null;
}

public Action Timer_Fail(Handle hTimer)
{
	LogSF2Message("Wow you hit a rare bug, where the round doesn't end after the timer ran out. Collecting info on your game...\nContact Mentrillum or The Gaben and give them the following log:");
	int iEscapedPlayers = 0;
	int iClientInGame = 0;
	int iRedPlayers = 0;
	int iBluPlayers = 0;
	int iEliminatedPlayers = 0;
	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (IsValidClient(iClient))
		{
			iClientInGame++;
			LogSF2Message("Player %N (%i), Team: %d, Eliminated: %d, Escaped: %d.", iClient, iClient, GetClientTeam(iClient), g_bPlayerEliminated[iClient], DidClientEscape(iClient));
			if (GetClientTeam(iClient) == TFTeam_Blue)
				iBluPlayers++;
			else if (GetClientTeam(iClient) == TFTeam_Red)
				iRedPlayers++;
		}
		if (g_bPlayerEliminated[iClient])
		{
			iEliminatedPlayers++;
		}
		if (DidClientEscape(iClient))
		{
			iEscapedPlayers++;
		}
	}
	LogSF2Message("Total clients: %d, Blu players: %d, Red players: %d, Escaped players: %d, Eliminated players: %d", MaxClients, iBluPlayers, iRedPlayers, iEscapedPlayers, iEliminatedPlayers);
	//Force blus to win.
	ForceTeamWin(TFTeam_Blue);
	
	g_hTimerFail = null;
	
	return Plugin_Stop;
}

/**
 *	Initialize pages and entities.
 */
static void InitializeMapEntities()
{
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START InitializeMapEntities()");
	#endif
	
	g_bIsSurvivalMap = false;
	g_bIsBoxingMap = false;
	g_bIsRenevantMap = false;
	g_bIsSlaughterRunMap = false;
	g_bIsRaidMap = false;
	g_bIsProxyMap = false;
	
	SF2GamerulesEntity gamerules = FindSF2GamerulesEntity();
	g_GamerulesEntity = gamerules;
	
	if (gamerules.IsValid())
	{
		if (g_iRoundActiveCount == 1)
			g_cvMaxPlayers.SetInt(gamerules.MaxPlayers);
		
		char sBossName[SF2_MAX_PROFILE_NAME_LENGTH];
		gamerules.GetBossName(sBossName, sizeof(sBossName));
		if (sBossName[0] != '\0')g_cvBossMain.SetString(sBossName);
		
		g_iPageMax = gamerules.MaxPages;
		
		g_iRoundTimeLimit = gamerules.InitialTimeLimit;
		g_iRoundTimeGainFromPage = gamerules.PageCollectAddTime;
		
		gamerules.GetPageCollectSoundPath(g_strPageCollectSound, sizeof(g_strPageCollectSound));
		if (g_strPageCollectSound[0] == '\0')
			strcopy(g_strPageCollectSound, sizeof(g_strPageCollectSound), PAGE_GRABSOUND); // Roll with default instead.
		
		g_iPageSoundPitch = gamerules.PageCollectSoundPitch;
		
		g_bRoundHasEscapeObjective = gamerules.HasEscapeObjective;
		g_iRoundEscapeTimeLimit = gamerules.EscapeTimeLimit;
		g_bRoundStopPageMusicOnEscape = gamerules.StopPageMusicOnEscape;
		g_bIsSurvivalMap = gamerules.Survive;
		g_iTimeEscape = gamerules.SurviveUntilTime;
		
		g_bRoundInfiniteFlashlight = gamerules.InfiniteFlashlight;
		g_bRoundInfiniteSprint = gamerules.InfiniteSprint;
		g_bRoundInfiniteBlink = gamerules.InfiniteBlink;
		
		g_bBossesChaseEndlessly = gamerules.BossesChaseEndlessly;
		
		gamerules.GetIntroMusicPath(g_strRoundIntroMusic, sizeof(g_strRoundIntroMusic));
		if (g_strRoundIntroMusic[0] == '\0')
			strcopy(g_strRoundIntroMusic, sizeof(g_strRoundIntroMusic), SF2_INTRO_DEFAULT_MUSIC); // Roll with default instead.
		
		gamerules.GetIntroFadeColor(g_iRoundIntroFadeColor);
		g_flRoundIntroFadeHoldTime = gamerules.IntroFadeHoldTime;
		g_flRoundIntroFadeDuration = gamerules.IntroFadeTime;
	}
	else
	{
		g_iRoundTimeLimit = g_cvTimeLimit.IntValue;
		g_iRoundTimeGainFromPage = g_cvTimeGainFromPageGrab.IntValue;
		strcopy(g_strPageCollectSound, sizeof(g_strPageCollectSound), PAGE_GRABSOUND);
		g_iPageSoundPitch = 100;
		
		g_bRoundHasEscapeObjective = false;
		g_iRoundEscapeTimeLimit = g_cvTimeLimitEscape.IntValue;
		g_bRoundStopPageMusicOnEscape = false;
		g_iTimeEscape = g_cvTimeEscapeSurvival.IntValue;
		
		g_bRoundInfiniteFlashlight = false;
		g_bRoundInfiniteSprint = false;
		g_bRoundInfiniteBlink = false;
		
		g_bBossesChaseEndlessly = false;
		
		strcopy(g_strRoundIntroMusic, sizeof(g_strRoundIntroMusic), SF2_INTRO_DEFAULT_MUSIC);
		
		g_iRoundIntroFadeColor[0] = 0;
		g_iRoundIntroFadeColor[1] = 0;
		g_iRoundIntroFadeColor[2] = 0;
		g_iRoundIntroFadeColor[3] = 255;
		g_flRoundIntroFadeHoldTime = g_cvIntroDefaultHoldTime.FloatValue;
		g_flRoundIntroFadeDuration = g_cvIntroDefaultFadeTime.FloatValue;
	}
	
	// Check the game type.
	if (FindLogicProxyEntity().IsValid())
	{
		g_bIsProxyMap = true;
		g_bIsSurvivalMap = true;
	}
	else if (FindLogicRaidEntity().IsValid())
	{
		g_bIsRaidMap = true;
	}
	else if (FindLogicBoxingEntity().IsValid())
	{
		g_bIsBoxingMap = true;
	}
	else if (FindLogicSlaughterEntity().IsValid())
	{
		g_bIsSlaughterRunMap = true;
	}
	else if ((g_RenevantLogicEntity = FindLogicRenevantEntity()).IsValid())
	{
		g_bIsRenevantMap = true;
	}
	
	if (SF_IsRenevantMap())
	{
		if (g_RenevantLogicEntity.IsValid())
		{
			g_iRenevantFinaleTime = g_RenevantLogicEntity.FinaleTime;
		}
		else
		{
			g_iRenevantFinaleTime = 60;
		}
	}
	
	char targetName[64];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0])
		{
			if (!StrContains(targetName, "sf2_maxpages_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_maxpages_", "", false);
				g_iPageMax = StringToInt(targetName);
			}
			else if (!StrContains(targetName, "sf2_logic_escape", false))
			{
				g_bRoundHasEscapeObjective = true;
			}
			else if (strcmp(targetName, "sf2_escape_custommusic", false) == 0)
			{
				g_bRoundStopPageMusicOnEscape = true;
			}
			else if (!StrContains(targetName, "sf2_infiniteflashlight", false))
			{
				g_bRoundInfiniteFlashlight = true;
			}
			else if (!StrContains(targetName, "sf2_infiniteblink", false))
			{
				g_bRoundInfiniteBlink = true;
			}
			else if (!StrContains(targetName, "sf2_infinitesprint", false))
			{
				g_bRoundInfiniteSprint = true;
			}
			else if (!StrContains(targetName, "sf2_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_time_limit_", "", false);
				g_iRoundTimeLimit = StringToInt(targetName);
				
				LogSF2Message("Found sf2_time_limit entity, set time limit to %d", g_iRoundTimeLimit);
			}
			else if (!StrContains(targetName, "sf2_escape_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_escape_time_limit_", "", false);
				g_iRoundEscapeTimeLimit = StringToInt(targetName);
				
				LogSF2Message("Found sf2_escape_time_limit entity, set escape time limit to %d", g_iRoundEscapeTimeLimit);
			}
			else if (!StrContains(targetName, "sf2_time_gain_from_page_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_time_gain_from_page_", "", false);
				g_iRoundTimeGainFromPage = StringToInt(targetName);
				
				LogSF2Message("Found sf2_time_gain_from_page entity, set time gain to %d", g_iRoundTimeGainFromPage);
			}
			else if (g_iRoundActiveCount == 1 && (!StrContains(targetName, "sf2_maxplayers_", false)))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_maxplayers_", "", false);
				g_cvMaxPlayers.SetInt(StringToInt(targetName));
				
				LogSF2Message("Found sf2_maxplayers entity, set maxplayers to %d", StringToInt(targetName));
			}
			else if (!StrContains(targetName, "sf2_boss_override_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_boss_override_", "", false);
				g_cvBossMain.SetString(targetName);
				
				LogSF2Message("Found sf2_boss_override entity, set boss profile override to %s", targetName);
			}
			else if (!StrContains(targetName, "sf2_survival_map", false))
			{
				g_bIsSurvivalMap = true;
			}
			else if (!StrContains(targetName, "sf2_raid_map", false))
			{
				g_bIsRaidMap = true;
			}
			else if (!StrContains(targetName, "sf2_bosses_chase_endlessly", false))
			{
				g_bBossesChaseEndlessly = true;
			}
			else if (!StrContains(targetName, "sf2_proxy_map", false))
			{
				g_bIsProxyMap = true;
				g_bIsSurvivalMap = true;
			}
			else if (!StrContains(targetName, "sf2_boxing_map", false))
			{
				g_bIsBoxingMap = true;
			}
			else if (!StrContains(targetName, "sf2_survival_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_survival_time_limit_", "", false);
				g_iTimeEscape = StringToInt(targetName);
				
				LogSF2Message("Found sf2_survival_time_limit_ entity, set survival time limit to %d", g_iTimeEscape);
			}
			else if (!StrContains(targetName, "sf2_renevant_map", false))
			{
				g_bIsRenevantMap = true;
			}
			else if (!StrContains(targetName, "sf2_slaughterrun_map", false))
			{
				g_bIsSlaughterRunMap = true;
			}
		}
	}
	
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] == '\0')
			continue;
		
		if (strcmp(targetName, "sf2_page_sound", false) == 0)
		{
			char sPagePath[PLATFORM_MAX_PATH];
			GetEntPropString(ent, Prop_Data, "m_iszSound", sPagePath, sizeof(sPagePath));
			
			if (sPagePath[0] == '\0')
			{
				LogError("Found sf2_page_sound entity, but it has no sound path specified! Default page sound will be used instead.");
			}
			else
			{
				strcopy(g_strPageCollectSound, sizeof(g_strPageCollectSound), sPagePath);
			}
		}
	}
	
	// For old page spawn points, get the reference entity if it exists.
	g_bPageRef = false;
	strcopy(g_strPageRefModel, sizeof(g_strPageRefModel), PAGE_MODEL);
	g_flPageRefModelScale = 1.0;
	
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "prop_dynamic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] == '\0')
			continue;
		
		if (strcmp(targetName, "sf2_page_model", false) == 0)
		{
			g_bPageRef = true;
			GetEntPropString(ent, Prop_Data, "m_ModelName", g_strPageRefModel, sizeof(g_strPageRefModel));
			g_flPageRefModelScale = GetEntPropFloat(ent, Prop_Send, "m_flModelScale");
			break;
		}
	}
	
	#if defined DEBUG
	LogSF2Message("ROUND SETTINGS:\n - Time limit: %i\n - Time gain from page: %i\n - Page collect sound: %s\n - Escape?: %i\n - Escape time limit: %i\n - Stop page music on escape: %i\n - Survive before escape?: %i\n - Survive until time: %i\n - Infinite flashlight: %i\n - Infinite sprint: %i\n - Infinite blink: %i\n - Bosses chase endlessly: %i\n - Intro music: %s\n - Intro fade hold time: %f\n - Intro fade time: %f", 
		g_iRoundTimeLimit, g_iRoundTimeGainFromPage, g_strPageCollectSound, g_bRoundHasEscapeObjective, g_iRoundEscapeTimeLimit, g_bRoundStopPageMusicOnEscape, g_bIsSurvivalMap, g_iTimeEscape, g_bRoundInfiniteFlashlight, g_bRoundInfiniteSprint, g_bRoundInfiniteBlink, g_bBossesChaseEndlessly, g_strRoundIntroMusic, g_flRoundIntroFadeHoldTime, g_flRoundIntroFadeDuration);
	#endif
	
	GetRoundIntroParameters();
	GetRoundEscapeParameters();
	GetPageMusicRanges();
	SpawnPages();
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END InitializeMapEntities()");
	#endif
}

void SpawnPages()
{
	g_hPages.Clear();
	
	ArrayList hArray = new ArrayList(2);
	StringMap hPageGroupsByName = new StringMap();
	
	ArrayList hPageSpawnPoints = new ArrayList();
	
	int ent = -1;
	char targetName[64];
	
	// Collect all possible page spawn points.
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0])
		{
			if (!StrContains(targetName, "sf2_page_spawnpoint", false))
			{
				hPageSpawnPoints.Push(EnsureEntRef(ent));
			}
		}
	}
	
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_page_spawn")) != -1)
	{
		SF2PageSpawnEntity pageSpawn = SF2PageSpawnEntity(ent);
		if (pageSpawn.IsValid())
		{
			hPageSpawnPoints.Push(EnsureEntRef(ent));
		}
	}
	
	if (hPageSpawnPoints.Length > 0)
	{
		// Try to sort spawn points into their respective groups.
		
		char sPageGroup[64];
		
		for (int i = 0; i < hPageSpawnPoints.Length; i++)
		{
			int iSpawnPoint = hPageSpawnPoints.Get(i);
			if (!IsValidEntity(iSpawnPoint))
				continue;
			
			// Get page group if possible.
			SF2PageSpawnEntity pageSpawn = SF2PageSpawnEntity(iSpawnPoint);
			if (pageSpawn.IsValid())
			{
				pageSpawn.GetPageGroup(sPageGroup, sizeof(sPageGroup));
			}
			else
			{
				GetEntPropString(iSpawnPoint, Prop_Data, "m_iName", sPageGroup, sizeof(sPageGroup));
				
				if (!StrContains(sPageGroup, "sf2_page_spawnpoint_", false))
					ReplaceString(sPageGroup, sizeof(sPageGroup), "sf2_page_spawnpoint_", "", false);
				else
					sPageGroup[0] = '\0';
			}
			
			if (sPageGroup[0] != '\0')
			{
				// Spawn point belongs to a group.
				
				ArrayList hButtStallion;
				if (!hPageGroupsByName.GetValue(sPageGroup, hButtStallion))
				{
					// Initialize new page group since it didn't exist.
					hButtStallion = new ArrayList();
					hPageGroupsByName.SetValue(sPageGroup, hButtStallion);
					
					int iIndex = hArray.Push(hButtStallion);
					hArray.Set(iIndex, true, 1);
				}
				
				hButtStallion.Push(EnsureEntRef(iSpawnPoint));
			}
			else
			{
				int iIndex = hArray.Push(EnsureEntRef(iSpawnPoint));
				hArray.Set(iIndex, false, 1);
			}
		}
	}
	
	delete hPageSpawnPoints;
	
	int iPageCount = hArray.Length;
	if (iPageCount)
	{
		// Spawn all pages.
		hArray.Sort(Sort_Random, Sort_Integer);
		
		float vecPos[3], vecAng[3];
		int page;
		
		char sPageModel[PLATFORM_MAX_PATH];
		char sPageParentName[64];
		float flPageModelScale;
		int iPageSkin;
		RenderFx iPageRenderFx;
		RenderMode iPageRenderMode;
		int iPageBodygroup;
		int iPageRenderColor[4];
		char sPageAnimation[64];
		
		for (int i = 0; i < iPageCount && (i + 1) <= g_iPageMax; i++)
		{
			int iSpawnPoint = -1;
			if (view_as<bool>(hArray.Get(i, 1)))
			{
				ArrayList hButtStallion = view_as<ArrayList>(hArray.Get(i));
				iSpawnPoint = hButtStallion.Get(GetRandomInt(0, hButtStallion.Length - 1));
			}
			else
			{
				iSpawnPoint = hArray.Get(i);
			}
			
			SF2PageSpawnEntity spawnPoint = SF2PageSpawnEntity(iSpawnPoint);
			
			GetEntPropVector(iSpawnPoint, Prop_Data, "m_vecAbsOrigin", vecPos);
			GetEntPropVector(iSpawnPoint, Prop_Data, "m_angAbsRotation", vecAng);
			GetEntPropString(iSpawnPoint, Prop_Data, "m_iParent", sPageParentName, sizeof(sPageParentName));
			
			// Get model, scale, skin, and animation.
			if (spawnPoint.IsValid())
			{
				spawnPoint.GetPageModel(sPageModel, sizeof(sPageModel));
				flPageModelScale = spawnPoint.PageModelScale;
				iPageSkin = spawnPoint.PageSkin == -1 ? i : spawnPoint.PageSkin;
				iPageBodygroup = spawnPoint.PageBodygroup;
				iPageRenderFx = spawnPoint.GetRenderFx();
				iPageRenderMode = spawnPoint.GetRenderMode();
				spawnPoint.GetRenderColor(iPageRenderColor[0], iPageRenderColor[1], iPageRenderColor[2], iPageRenderColor[3]);
				spawnPoint.GetPageAnimation(sPageAnimation, sizeof(sPageAnimation));
			}
			else if (g_bPageRef)
			{
				strcopy(sPageModel, sizeof(sPageModel), g_strPageRefModel);
				flPageModelScale = g_flPageRefModelScale;
				iPageSkin = i;
				iPageBodygroup = 0;
				iPageRenderFx = RENDERFX_NONE;
				iPageRenderMode = RENDER_NORMAL;
				iPageRenderColor[0] = 255; iPageRenderColor[1] = 255; iPageRenderColor[2] = 255; iPageRenderColor[3] = 255;
				sPageAnimation[0] = '\0';
			}
			else
			{
				strcopy(sPageModel, sizeof(sPageModel), PAGE_MODEL);
				flPageModelScale = PAGE_MODELSCALE;
				iPageSkin = i;
				iPageBodygroup = 0;
				iPageRenderFx = RENDERFX_NONE;
				iPageRenderMode = RENDER_NORMAL;
				iPageRenderColor[0] = 255; iPageRenderColor[1] = 255; iPageRenderColor[2] = 255; iPageRenderColor[3] = 255;
				sPageAnimation[0] = '\0';
			}
			
			// Create fake page model
			char pageName[50];
			int page2 = CreateEntityByName("prop_dynamic_override");
			if (page2 != -1)
			{
				DispatchKeyValue(page2, "targetname", "sf2_page_ex");
				DispatchKeyValue(page2, "parentname", sPageParentName);
				DispatchKeyValue(page2, "solid", "0");
				SetEntityModel(page2, sPageModel);
				TeleportEntity(page2, vecPos, vecAng, NULL_VECTOR);
				DispatchSpawn(page2);
				ActivateEntity(page2);
				SetVariantInt(iPageSkin);
				AcceptEntityInput(page2, "Skin");
				SetVariantInt(iPageBodygroup);
				AcceptEntityInput(page2, "SetBodyGroup");
				AcceptEntityInput(page2, "DisableCollision");
				SetEntPropFloat(page2, Prop_Send, "m_flModelScale", flPageModelScale);
				SetEntityFlags(page2, GetEntityFlags(page2) | FL_EDICT_ALWAYS);
				SetEntityRenderMode(page2, iPageRenderMode);
				SetEntityRenderFx(page2, iPageRenderFx);
				SetEntityRenderColor(page2, iPageRenderColor[0], iPageRenderColor[1], iPageRenderColor[2], iPageRenderColor[3]);
				
				CreateTimer(1.0, Page_RemoveAlwaysTransmit, EntIndexToEntRef(page2), TIMER_FLAG_NO_MAPCHANGE);
				SDKHook(page2, SDKHook_SetTransmit, Hook_SlenderObjectSetTransmitEx);
				
				if (sPageAnimation[0] != '\0')
				{
					SetVariantString(sPageAnimation);
					AcceptEntityInput(page2, "SetDefaultAnimation");
					SetVariantString(sPageAnimation);
					AcceptEntityInput(page2, "SetAnimation");
				}
			}
			
			// Create actual page entity
			page = CreateEntityByName("prop_dynamic_override");
			if (page != -1)
			{
				FormatEx(pageName, sizeof(pageName), "sf2_page_ex_%d", i);
				DispatchKeyValue(page, "targetname", pageName);
				DispatchKeyValue(page, "parentname", sPageParentName);
				DispatchKeyValue(page, "solid", "2");
				SetEntityModel(page, sPageModel);
				TeleportEntity(page, vecPos, vecAng, NULL_VECTOR);
				DispatchSpawn(page);
				ActivateEntity(page);
				SetVariantInt(iPageSkin);
				AcceptEntityInput(page, "Skin");
				SetVariantInt(iPageBodygroup);
				AcceptEntityInput(page, "SetBodyGroup");
				AcceptEntityInput(page, "EnableCollision");
				SetEntPropFloat(page, Prop_Send, "m_flModelScale", flPageModelScale);
				SetEntPropEnt(page, Prop_Send, "m_hOwnerEntity", page2);
				SetEntPropEnt(page, Prop_Send, "m_hEffectEntity", page2);
				SetEntProp(page, Prop_Send, "m_fEffects", EF_ITEM_BLINK);
				SetEntityFlags(page, GetEntityFlags(page) | FL_EDICT_ALWAYS);
				SetEntityRenderMode(page, iPageRenderMode);
				SetEntityRenderFx(page, iPageRenderFx);
				SetEntityRenderColor(page, iPageRenderColor[0], iPageRenderColor[1], iPageRenderColor[2], iPageRenderColor[3]);
				
				CreateTimer(1.0, Page_RemoveAlwaysTransmit, EntIndexToEntRef(page), TIMER_FLAG_NO_MAPCHANGE);
				SDKHook(page, SDKHook_OnTakeDamage, Hook_PageOnTakeDamage);
				SDKHook(page, SDKHook_SetTransmit, Hook_SlenderObjectSetTransmit);
				
				if (sPageAnimation[0] != '\0')
				{
					SetVariantString(sPageAnimation);
					AcceptEntityInput(page, "SetDefaultAnimation");
					SetVariantString(sPageAnimation);
					AcceptEntityInput(page, "SetAnimation");
				}
				
				SF2PageEntityData pageData;
				pageData.EntRef = EnsureEntRef(page);
				
				if (spawnPoint.IsValid())
				{
					spawnPoint.GetPageCollectSound(pageData.CollectSound, PLATFORM_MAX_PATH);
					pageData.CollectSoundPitch = spawnPoint.PageCollectSoundPitch;
				}
				else
				{
					pageData.CollectSound[0] = '\0';
					pageData.CollectSoundPitch = 0;
				}
				
				g_hPages.PushArray(pageData, sizeof(pageData));
			}
		}
		
		// Safely remove all handles.
		for (int i = 0, iSize = hArray.Length; i < iSize; i++)
		{
			if (view_as<bool>(hArray.Get(i, 1)))
			{
				delete view_as<ArrayList>(hArray.Get(i));
			}
		}
		
		Call_StartForward(fOnPagesSpawned);
		Call_Finish();
	}
	
	delete hPageGroupsByName;
	delete hArray;
}

public Action Page_RemoveAlwaysTransmit(Handle timer, int iRef)
{
	int iPage = EntRefToEntIndex(iRef);
	if (iPage > MaxClients && IsValidEdict(iPage))
	{
		//All the pages are now "registred" by the client, nuke the always transmit flag.
		SetEntityFlags(iPage, GetEntityFlags(iPage) ^ FL_EDICT_ALWAYS);
	}
	return Plugin_Stop;
}
static bool HandleSpecialRoundState()
{
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START HandleSpecialRoundState()");
	#endif
	
	bool bOld = g_bSpecialRound;
	bool bContinuousOld = g_bSpecialRoundContinuous;
	g_bSpecialRound = false;
	g_bSpecialRoundNew = false;
	g_bSpecialRoundContinuous = false;
	
	bool bForceNew = false;
	
	if (bOld)
	{
		if (bContinuousOld)
		{
			// Check if there are players who haven't played the special round yet.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsClientParticipating(i))
				{
					g_bPlayerPlayedSpecialRound[i] = true;
					continue;
				}
				
				if (!g_bPlayerPlayedSpecialRound[i])
				{
					// Someone didn't get to play this yet. Continue the special round.
					g_bSpecialRound = true;
					g_bSpecialRoundContinuous = true;
					break;
				}
			}
		}
	}
	
	int iRoundInterval = g_cvSpecialRoundInterval.IntValue;
	
	if (iRoundInterval > 0 && g_iSpecialRoundCount >= iRoundInterval)
	{
		g_bSpecialRound = true;
		bForceNew = true;
	}
	
	// Do special round force override and reset it.
	if (g_cvSpecialRoundForce.IntValue >= 0)
	{
		g_bSpecialRound = g_cvSpecialRoundForce.BoolValue;
		g_cvSpecialRoundForce.SetInt(-1);
	}
	
	if (g_bSpecialRound)
	{
		if (bForceNew || !bOld || !bContinuousOld)
		{
			g_bSpecialRoundNew = true;
		}
		
		if (g_bSpecialRoundNew)
		{
			if (g_cvSpecialRoundBehavior.IntValue == 1)
			{
				g_bSpecialRoundContinuous = true;
			}
			else
			{
				// new special round, but it's not continuous.
				g_bSpecialRoundContinuous = false;
			}
		}
	}
	else
	{
		g_bSpecialRoundContinuous = false;
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0)DebugMessage("END HandleSpecialRoundState() -> g_bSpecialRound = %d (count = %d, new = %d, continuous = %d)", g_bSpecialRound, g_iSpecialRoundCount, g_bSpecialRoundNew, g_bSpecialRoundContinuous);
	#endif
}
/*
bool IsNewBossRoundRunning()
{
	return g_bNewBossRound;
}
*/
/**
 *	Returns an array which contains all the profile names valid to be chosen for a new boss round.
 */
static ArrayList GetNewBossRoundProfileList()
{
	ArrayList hBossList = GetSelectableBossProfileQueueList().Clone();

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone array list %b has been created for hBossList in GetNewBossRoundProfileList.", hBossList);
	#endif
	
	if (hBossList.Length > 0)
	{
		char sMainBoss[SF2_MAX_PROFILE_NAME_LENGTH];
		g_cvBossMain.GetString(sMainBoss, sizeof(sMainBoss));
		
		int index = hBossList.FindString(sMainBoss);
		if (index != -1)
		{
			// Main boss exists; remove him from the list.
			hBossList.Erase(index);
		}
		/*else
		{
			// Main boss doesn't exist; remove the first boss from the list.
			hBossList.Erase(0);
		}*/
	}
	
	return hBossList;
}

static void HandleNewBossRoundState()
{
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START HandleNewBossRoundState()");
	#endif
	
	bool bOld = g_bNewBossRound;
	bool bContinuousOld = g_bNewBossRoundContinuous;
	g_bNewBossRound = false;
	g_bNewBossRoundNew = false;
	g_bNewBossRoundContinuous = false;
	
	bool bForceNew = false;
	
	if (bOld)
	{
		if (bContinuousOld)
		{
			// Check if there are players who haven't played the boss round yet.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsClientParticipating(i))
				{
					g_bPlayerPlayedNewBossRound[i] = true;
					continue;
				}
				
				if (!g_bPlayerPlayedNewBossRound[i])
				{
					// Someone didn't get to play this yet. Continue the boss round.
					g_bNewBossRound = true;
					g_bNewBossRoundContinuous = true;
					break;
				}
			}
		}
	}
	
	// Don't force a new special round while a continuous round is going on.
	if (!g_bNewBossRoundContinuous)
	{
		int iRoundInterval = g_cvNewBossRoundInterval.IntValue;
		
		if (/*iRoundInterval > 0 &&*/iRoundInterval <= 0 || g_iNewBossRoundCount >= iRoundInterval)
		{
			g_bNewBossRound = true;
			bForceNew = true;
		}
	}
	
	// Do boss round force override and reset it.
	if (g_cvNewBossRoundForce.IntValue >= 0)
	{
		g_bNewBossRound = g_cvNewBossRoundForce.BoolValue;
		g_cvNewBossRoundForce.SetInt(-1);
	}
	
	// Check if we have enough bosses.
	if (g_bNewBossRound)
	{
		ArrayList hBossList = GetNewBossRoundProfileList().Clone();
		
		if (hBossList.Length < 1)
		{
			g_bNewBossRound = false; // Not enough bosses.
		}
		
		delete hBossList;

		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone array list %b has been deleted for hBossList in HandleNewBossRoundState which comes from GetNewBossRoundProfileList.", hBossList);
		#endif
	}
	
	if (g_bNewBossRound)
	{
		if (bForceNew || !bOld || !bContinuousOld)
		{
			g_bNewBossRoundNew = true;
		}
		
		if (g_bNewBossRoundNew)
		{
			if (g_cvNewBossRoundBehavior.IntValue == 1)
			{
				g_bNewBossRoundContinuous = true;
			}
			else
			{
				// new "new boss round", but it's not continuous.
				g_bNewBossRoundContinuous = false;
			}
		}
	}
	else
	{
		g_bNewBossRoundContinuous = false;
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END HandleintBossRoundState() -> g_bNewBossRound = %d (count = %d, int = %d, continuous = %d)", g_bNewBossRound, g_iNewBossRoundCount, g_bNewBossRoundNew, g_bNewBossRoundContinuous);
	#endif
}

/**
 *	Returns the amount of players that are in game and currently not eliminated.
 */
int GetActivePlayerCount()
{
	int count = 0;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || !IsClientParticipating(i)) continue;
		
		if (!g_bPlayerEliminated[i])
		{
			count++;
		}
	}
	
	return count;
}

static void SelectStartingBossesForRound()
{
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START SelectStartingBossesForRound()");
	#endif
	
	ArrayList hSelectableBossList = GetSelectableBossProfileQueueList().Clone();

	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone array list %b has been created for hSelectableBossList in SelectStartingBossesForRound.", hSelectableBossList);
	#endif
	
	// Select which boss profile to use.
	char sProfileOverride[SF2_MAX_PROFILE_NAME_LENGTH];
	g_cvBossProfileOverride.GetString(sProfileOverride, sizeof(sProfileOverride));
	
	if (!SF_IsBoxingMap())
	{
		if (sProfileOverride[0] != '\0' && IsProfileValid(sProfileOverride))
		{
			// Pick the overridden boss.
			strcopy(g_strRoundBossProfile, sizeof(g_strRoundBossProfile), sProfileOverride);
			g_cvBossProfileOverride.SetString("");
		}
		else if (g_bNewBossRound)
		{
			if (g_bNewBossRoundNew)
			{
				ArrayList hBossList = GetNewBossRoundProfileList();
				
				hBossList.GetString(GetRandomInt(0, hBossList.Length - 1), g_strNewBossRoundProfile, sizeof(g_strNewBossRoundProfile));
				
				delete hBossList;

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone array list %b has been deleted for hBossList in SelectStartingBossesForRound which comes from GetNewBossRoundProfileList.", hBossList);
				#endif
			}
			
			strcopy(g_strRoundBossProfile, sizeof(g_strRoundBossProfile), g_strNewBossRoundProfile);
		}
		else
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			g_cvBossMain.GetString(sProfile, sizeof(sProfile));
			
			if (sProfile[0] != '\0' && IsProfileValid(sProfile))
			{
				strcopy(g_strRoundBossProfile, sizeof(g_strRoundBossProfile), sProfile);
			}
			else
			{
				if (hSelectableBossList.Length > 0)
				{
					// Pick the first boss in our array if the main boss doesn't exist.
					hSelectableBossList.GetString(0, g_strRoundBossProfile, sizeof(g_strRoundBossProfile));
				}
				else
				{
					// No bosses to pick. What?
					g_strRoundBossProfile[0] = '\0';
				}
			}
		}
		
		#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 0) DebugMessage("END SelectStartingBossesForRound() -> boss: %s", g_strRoundBossProfile);
		#endif
	}
	else if (SF_IsBoxingMap())
	{
		if (sProfileOverride[0] != '\0' && IsProfileValid(sProfileOverride))
		{
			// Pick the overridden boss.
			strcopy(g_strRoundBoxingBossProfile, sizeof(g_strRoundBoxingBossProfile), sProfileOverride);
			g_cvBossProfileOverride.SetString("");
		}
		else if (g_bNewBossRound)
		{
			if (g_bNewBossRoundNew)
			{
				ArrayList hBossList = GetNewBossRoundProfileList();
				
				hBossList.GetString(GetRandomInt(0, hBossList.Length - 1), g_strNewBossRoundProfile, sizeof(g_strNewBossRoundProfile));
				
				delete hBossList;

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone array list %b has been deleted for hBossList in SelectStartingBossesForRound which comes from GetNewBossRoundProfileList.", hBossList);
				#endif
			}
			
			strcopy(g_strRoundBoxingBossProfile, sizeof(g_strRoundBoxingBossProfile), g_strNewBossRoundProfile);
		}
		else
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			g_cvBossMain.GetString(sProfile, sizeof(sProfile));
			
			if (sProfile[0] != '\0' && IsProfileValid(sProfile))
			{
				strcopy(g_strRoundBoxingBossProfile, sizeof(g_strRoundBoxingBossProfile), sProfile);
			}
			else
			{
				if (hSelectableBossList.Length > 0)
				{
					// Pick the first boss in our array if the main boss doesn't exist.
					hSelectableBossList.GetString(0, g_strRoundBoxingBossProfile, sizeof(g_strRoundBoxingBossProfile));
				}
				else
				{
					// No bosses to pick. What?
					g_strRoundBoxingBossProfile[0] = '\0';
				}
			}
		}
		
		#if defined DEBUG
		if (g_cvDebugDetail.IntValue > 0) DebugMessage("END SelectStartingBossesForRound() -> boss: %s", g_strRoundBoxingBossProfile);
		#endif
	}
	delete hSelectableBossList;
}

static void GetRoundIntroParameters()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "env_fade")) != -1)
	{
		char sName[32];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, "sf2_intro_fade", false) == 0)
		{
			int iColorOffset = FindSendPropInfo("CBaseEntity", "m_clrRender");
			if (iColorOffset != -1)
			{
				g_iRoundIntroFadeColor[0] = GetEntData(ent, iColorOffset, 1);
				g_iRoundIntroFadeColor[1] = GetEntData(ent, iColorOffset + 1, 1);
				g_iRoundIntroFadeColor[2] = GetEntData(ent, iColorOffset + 2, 1);
				g_iRoundIntroFadeColor[3] = GetEntData(ent, iColorOffset + 3, 1);
			}
			
			g_flRoundIntroFadeHoldTime = GetEntPropFloat(ent, Prop_Data, "m_HoldTime");
			g_flRoundIntroFadeDuration = GetEntPropFloat(ent, Prop_Data, "m_Duration");
			
			break;
		}
	}
	
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		
		if (strcmp(sName, "sf2_intro_music", false) == 0)
		{
			char sSongPath[PLATFORM_MAX_PATH];
			GetEntPropString(ent, Prop_Data, "m_iszSound", sSongPath, sizeof(sSongPath));
			
			if (sSongPath[0] == '\0')
			{
				LogError("Found sf2_intro_music entity, but it has no sound path specified! Default intro music will be used instead.");
			}
			else
			{
				strcopy(g_strRoundIntroMusic, sizeof(g_strRoundIntroMusic), sSongPath);
			}
			
			break;
		}
	}
}

static void GetRoundEscapeParameters()
{
	g_iRoundEscapePointEntity = INVALID_ENT_REFERENCE;
	
	char sName[64];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (!StrContains(sName, "sf2_escape_spawnpoint", false))
		{
			g_iRoundEscapePointEntity = EntIndexToEntRef(ent);
			break;
		}
	}
}

void InitializeNewGame()
{
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("START InitializeNewGame()");
	#endif
	
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_regenerate")) != -1)
	{
		AcceptEntityInput(ent, "Enable");
	}
	
	InitializeMapEntities();
	
	//Tutorial_EnableHooks();
	
	if (SF_IsBoxingMap())
	{
		g_iSlenderBoxingBossCount = 0;
		g_iSlenderBoxingBossKilled = 0;
	}
	else if (SF_IsRenevantMap())
	{
		g_hRenevantWaveTimer = null;
		g_bRenevantMultiEffect = false;
		g_bRenevantBeaconEffect = false;
		g_bRenevant90sEffect = false;
		g_bRenevantMarkForDeath = false;

		Renevant_SetWave(0);
	}

	if (g_aRenevantWaveList != null)
	{
		delete g_aRenevantWaveList;
	}
	
	// Choose round state.
	if (g_cvIntroEnabled.BoolValue)
	{
		// Set the round state to the intro stage.
		SetRoundState(SF2RoundState_Intro);
	}
	else
	{
		SetRoundState(SF2RoundState_Grace);
		SF2_RefreshRestrictions();
	}
	
	if (g_iRoundActiveCount == 1)
	{
		g_cvBossProfileOverride.SetString("");
	}
	
	HandleSpecialRoundState();
	
	// Was a new special round initialized?
	if (g_bSpecialRound && !SF_IsRenevantMap())
	{
		if (g_bSpecialRoundNew)
		{
			// Reset round count.
			g_iSpecialRoundCount = 1;
			
			if (g_bSpecialRoundContinuous)
			{
				// It's the start of a continuous special round.
				
				// Initialize all players' values.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || !IsClientParticipating(i))
					{
						g_bPlayerPlayedSpecialRound[i] = true;
						continue;
					}
					
					g_bPlayerPlayedSpecialRound[i] = false;
				}
			}
			
			SpecialRoundCycleStart();
		}
		else
		{
			SpecialRoundStart();
			
			if (g_bSpecialRoundContinuous)
			{
				// Display the current special round going on to late players.
				CreateTimer(3.0, Timer_DisplaySpecialRound);
			}
		}
	}
	else
	{
		g_iSpecialRoundCount++;
		
		SpecialRoundReset();
	}
	
	// Determine boss round state.
	HandleNewBossRoundState();
	
	if (g_bNewBossRound)
	{
		if (g_bNewBossRoundNew)
		{
			// Reset round count;
			g_iNewBossRoundCount = 1;
			
			if (g_bNewBossRoundContinuous)
			{
				// It's the start of a continuous "new boss round".
				
				// Initialize all players' values.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || !IsClientParticipating(i))
					{
						g_bPlayerPlayedNewBossRound[i] = true;
						continue;
					}
					
					g_bPlayerPlayedNewBossRound[i] = false;
				}
			}
		}
	}
	else
	{
		g_iNewBossRoundCount++;
	}
	
	SelectStartingBossesForRound();
	
	ForceInNextPlayersInQueue(GetMaxPlayersForRound());
	
	// Respawn all players, if needed.
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientParticipating(i))
		{
			if (!HandlePlayerTeam(i))
			{
				if (!g_bPlayerEliminated[i])
				{
					// Players currently in the "game" still have to be respawned.
					TF2_RespawnPlayer(i);
				}
			}
		}
	}
	
	if (GetRoundState() == SF2RoundState_Intro)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i)) continue;
			
			if (!g_bPlayerEliminated[i])
			{
				if (!IsFakeClient(i))
				{
					// Currently in intro state, play intro music.
					g_hPlayerIntroMusicTimer[i] = CreateTimer(0.5, Timer_PlayIntroMusicToPlayer, GetClientUserId(i));
				}
				else
				{
					g_hPlayerIntroMusicTimer[i] = null;
				}
			}
			else
			{
				g_hPlayerIntroMusicTimer[i] = null;
			}
		}
	}
	else
	{
		// Spawn the boss!
		if (!SF_SpecialRound(SPECIALROUND_MODBOSSES))
		{
			if (!SF_IsBoxingMap() && !SF_IsRenevantMap())
			{
				if (SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) || SF_SpecialRound(SPECIALROUND_DOOMBOX) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_2DOOM))
				{
					AddProfile(g_strRoundBossProfile);
					RemoveBossProfileFromQueueList(g_strRoundBossProfile);
				}
				else if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
				{
					AddProfile(g_strRoundBossProfile);
					AddProfile(g_strRoundBossProfile, _, _, _, false);
					AddProfile(g_strRoundBossProfile, _, _, _, false);
					RemoveBossProfileFromQueueList(g_strRoundBossProfile);
				}
				else if (!SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_DOOMBOX) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_2DOOM) && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
				{
					SelectProfile(view_as<SF2NPC_BaseNPC>(0), g_strRoundBossProfile);
					RemoveBossProfileFromQueueList(g_strRoundBossProfile);
				}
			}
			else if (SF_IsBoxingMap())
			{
				char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
				ArrayList hSelectableBosses = GetSelectableBoxingBossProfileList().Clone();
				if (hSelectableBosses.Length > 0)
				{
					hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
					AddProfile(sBuffer);
				}
				delete hSelectableBosses;
			}
		}
	}
	
	#if defined DEBUG
	if (g_cvDebugDetail.IntValue > 0) DebugMessage("END InitializeNewGame()");
	#endif
}

public Action Timer_PlayIntroMusicToPlayer(Handle timer, any userid)
{
	int iClient = GetClientOfUserId(userid);
	if (iClient <= 0) return Plugin_Stop;
	if (!IsClientInGame(iClient)) return Plugin_Stop;
	
	if (timer != g_hPlayerIntroMusicTimer[iClient]) return Plugin_Stop;
	
	g_hPlayerIntroMusicTimer[iClient] = null;
	
	EmitSoundToClient(iClient, g_strRoundIntroMusic, _, MUSIC_CHAN, SNDLEVEL_NONE);
	
	return Plugin_Stop;
}

static void StartIntroTextSequence()
{
	g_iRoundIntroText = 1;
	g_bRoundIntroTextDefault = false;
	g_hRoundIntroTextTimer = null;
	
	if (g_GamerulesEntity.IsValid())
	{
		SF2GameTextEntity textEntity = g_GamerulesEntity.IntroTextEntity;
		if (textEntity.IsValid())
		{
			g_hRoundIntroTextTimer = CreateTimer(g_GamerulesEntity.IntroTextDelay, Timer_NewIntroTextSequence, EntIndexToEntRef(textEntity.index), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	if (g_hRoundIntroTextTimer == null)
	{
		// Use old intro text sequence.
		g_hRoundIntroTextTimer = CreateTimer(0.0, Timer_IntroTextSequence, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static Action Timer_NewIntroTextSequence(Handle timer, any data)
{
	if (!g_bEnabled) return Plugin_Stop;
	if (g_hRoundIntroTextTimer != timer) return Plugin_Stop;
	
	SF2GameTextEntity textEntity = SF2GameTextEntity(EntRefToEntIndex(data));
	if (!textEntity.IsValid()) return Plugin_Stop;
	
	int iClients[MAXPLAYERS + 1];
	int iClientsNum;
	
	for (int iClient = 1; iClient <= MaxClients; iClient++)
	{
		if (!IsClientInGame(iClient) || g_bPlayerEliminated[iClient]) continue;
		
		iClients[iClientsNum] = iClient;
		iClientsNum++;
	}
	
	char sMessage[512];
	textEntity.GetIntroMessage(sMessage, sizeof(sMessage));
	ShowHudTextUsingTextEntity(iClients, iClientsNum, textEntity.index, g_hHudSync, sMessage);
	
	SF2GameTextEntity nextTextEntity = textEntity.NextIntroTextEntity;
	if (nextTextEntity.IsValid())
	{
		float flDuration = textEntity.GetPropFloat(Prop_Data, "m_textParms.fadeinTime")
		 + textEntity.GetPropFloat(Prop_Data, "m_textParms.fadeoutTime")
		 + textEntity.GetPropFloat(Prop_Data, "m_textParms.holdTime")
		 + textEntity.NextIntroTextDelay;
		
		g_hRoundIntroTextTimer = CreateTimer(flDuration, Timer_NewIntroTextSequence, EntIndexToEntRef(nextTextEntity.index), TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Continue;
}

public Action Timer_IntroTextSequence(Handle timer)
{
	if (!g_bEnabled) return Plugin_Stop;
	if (g_hRoundIntroTextTimer != timer) return Plugin_Stop;
	
	float flDuration = 0.0;
	
	if (g_iRoundIntroText != 0)
	{
		bool bFoundGameText = false;
		
		int iClients[MAXPLAYERS + 1];
		int iClientsNum;
		
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i) || g_bPlayerEliminated[i]) continue;
			
			iClients[iClientsNum] = i;
			iClientsNum++;
		}
		
		if (!g_bRoundIntroTextDefault)
		{
			char sTargetname[64];
			FormatEx(sTargetname, sizeof(sTargetname), "sf2_intro_text_%d", g_iRoundIntroText);
			
			int iGameText = FindEntityByTargetname(sTargetname, "game_text");
			if (iGameText && iGameText != INVALID_ENT_REFERENCE)
			{
				bFoundGameText = true;
				flDuration = GetEntPropFloat(iGameText, Prop_Data, "m_textParms.fadeinTime") + GetEntPropFloat(iGameText, Prop_Data, "m_textParms.fadeoutTime") + GetEntPropFloat(iGameText, Prop_Data, "m_textParms.holdTime");
				
				char sMessage[512];
				GetEntPropString(iGameText, Prop_Data, "m_iszMessage", sMessage, sizeof(sMessage));
				ShowHudTextUsingTextEntity(iClients, iClientsNum, iGameText, g_hHudSync, sMessage);
			}
		}
		else
		{
			if (g_iRoundIntroText == 2)
			{
				bFoundGameText = false;
				
				char sMessage[64];
				GetCurrentMap(sMessage, sizeof(sMessage));
				
				for (int i = 0; i < iClientsNum; i++)
				{
					ClientShowMainMessage(iClients[i], sMessage, 1);
				}
			}
		}
		
		if (g_iRoundIntroText == 1 && !bFoundGameText)
		{
			// Use default intro sequence. Eugh.
			g_bRoundIntroTextDefault = true;
			flDuration = g_cvIntroDefaultHoldTime.FloatValue / 2.0;
			
			for (int i = 0; i < iClientsNum; i++)
			{
				EmitSoundToClient(iClients[i], SF2_INTRO_DEFAULT_MUSIC, _, MUSIC_CHAN, SNDLEVEL_NONE);
			}
		}
		else
		{
			if (!bFoundGameText) return Plugin_Stop; // done with sequence; don't check anymore.
		}
	}
	
	g_iRoundIntroText++;
	g_hRoundIntroTextTimer = CreateTimer(flDuration, Timer_IntroTextSequence, _, TIMER_FLAG_NO_MAPCHANGE);
	
	return Plugin_Stop;
}

public Action Timer_ActivateRoundFromIntro(Handle timer)
{
	if (!g_bEnabled) return Plugin_Stop;
	if (g_hRoundIntroTimer != timer) return Plugin_Stop;
	
	// Obviously we don't want to spawn the boss when g_strRoundBossProfile isn't set yet.
	SetRoundState(SF2RoundState_Grace);
	SF2_RefreshRestrictions();
	
	// Spawn the boss!
	if (!SF_SpecialRound(SPECIALROUND_MODBOSSES))
	{
		if (!SF_IsBoxingMap() && !SF_IsRenevantMap())
		{
			if (SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) || SF_SpecialRound(SPECIALROUND_DOOMBOX) || SF_SpecialRound(SPECIALROUND_2DOUBLE) || SF_SpecialRound(SPECIALROUND_2DOOM))
			{
				AddProfile(g_strRoundBossProfile);
				RemoveBossProfileFromQueueList(g_strRoundBossProfile);
			}
			else if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				AddProfile(g_strRoundBossProfile);
				AddProfile(g_strRoundBossProfile, _, _, _, false);
				AddProfile(g_strRoundBossProfile, _, _, _, false);
				RemoveBossProfileFromQueueList(g_strRoundBossProfile);
			}
			else if (!SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_DOOMBOX) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_2DOOM) && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				SelectProfile(view_as<SF2NPC_BaseNPC>(0), g_strRoundBossProfile);
				RemoveBossProfileFromQueueList(g_strRoundBossProfile);
			}
		}
		else if (SF_IsBoxingMap())
		{
			char sBuffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList hSelectableBosses = GetSelectableBoxingBossProfileList().Clone();
			if (hSelectableBosses.Length > 0)
			{
				hSelectableBosses.GetString(GetRandomInt(0, hSelectableBosses.Length - 1), sBuffer, sizeof(sBuffer));
				AddProfile(sBuffer);
			}
			delete hSelectableBosses;
		}
	}
	return Plugin_Stop;
}

void CheckRoundWinConditions()
{
	if (IsRoundInWarmup() || IsRoundEnding() || g_cvIgnoreRoundWinConditions.BoolValue) return;
	
	int iTotalCount = 0;
	int iAliveCount = 0;
	int iEscapedCount = 0;
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		iTotalCount++;
		if (!SF_SpecialRound(SPECIALROUND_1UP))
		{
			if (!g_bPlayerEliminated[i] && !IsClientInDeathCam(i))
			{
				iAliveCount++;
				if (DidClientEscape(i)) iEscapedCount++;
			}
		}
		else
		{
			if (!g_bPlayerEliminated[i] && !IsClientInDeathCam(i) && !g_bPlayerFullyDied1Up[i])
			{
				iAliveCount++;
				if (DidClientEscape(i)) iEscapedCount++;
			}
		}
	}
	
	if (iAliveCount == 0)
	{
		ForceTeamWin(TFTeam_Blue);
	}
	else
	{
		if (g_bRoundHasEscapeObjective)
		{
			if (iEscapedCount == iAliveCount)
			{
				ForceTeamWin(TFTeam_Red);
			}
		}
		else
		{
			if (g_iPageMax > 0 && g_iPageCount == g_iPageMax)
			{
				ForceTeamWin(TFTeam_Red);
			}
		}
	}
}
