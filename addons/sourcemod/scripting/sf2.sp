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
#include <cbasenpc/matrix>
#include <cbasenpc/tf/nav>
#include <profiler>

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

#pragma dynamic 131072

#define TFTeam_Spectator 1
#define TFTeam_Red 2
#define TFTeam_Blue 3
#define TFTeam_Boss 5

#define MAXTF2PLAYERS 101

public Plugin myinfo =
{
	name = "Slender Fortress Modified",
	author = "KitRifty, Kenzzer, Mentrillum, The Gaben",
	description = "Based on the game Slender: The Eight Pages.",
	version = PLUGIN_VERSION,
	url = "https://discord.gg/7Zz7RYTCC4"
}

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

char g_SoundNightmareMode[][] =
{
	"#ambient/halloween/thunder_04.wav",
	"#ambient/halloween/thunder_05.wav",
	"#ambient/halloween/thunder_08.wav",
	"#ambient/halloween/mysterious_perc_09.wav",
	"#ambient/halloween/mysterious_perc_09.wav",
	"#ambient/halloween/windgust_08.wav"
};

static const char g_PageCollectDuckSounds[][] =
{
	")ambient/bumper_car_quack1.wav",
	")ambient/bumper_car_quack2.wav",
	")ambient/bumper_car_quack3.wav",
	")ambient/bumper_car_quack4.wav",
	")ambient/bumper_car_quack5.wav",
	")ambient/bumper_car_quack9.wav",
	")ambient/bumper_car_quack11.wav"
};

bool g_ClientInGame[MAXTF2PLAYERS] = { false, ... };
bool g_ClientInCondition[MAXTF2PLAYERS][TFCond_PowerupModeDominant + view_as<TFCond>(2)];

//Command
bool g_PlayerNoPoints[MAXTF2PLAYERS] = { false, ... };
bool g_AdminNoPoints[MAXTF2PLAYERS] = { false, ... };
bool g_AdminAllTalk[MAXTF2PLAYERS] = { false, ... };

// Offsets.
int g_PlayerFOVOffset = -1;
int g_PlayerDefaultFOVOffset = -1;
int g_PlayerFogCtrlOffset = -1;
int g_PlayerPunchAngleOffset = -1;
int g_PlayerPunchAngleOffsetVel = -1;
int g_FogCtrlEnableOffset = -1;
int g_FogCtrlEndOffset = -1;
int g_CollisionGroupOffset = -1;
int g_FullDamageData = -1;

//Commands
float g_LastCommandTime[MAXTF2PLAYERS];

bool g_Enabled;

KeyValues g_Config;
KeyValues g_RestrictedWeaponsConfig;
KeyValues g_SpecialRoundsConfig;
KeyValues g_ClassStatsConfig;

ArrayList g_PageMusicRanges;
int g_PageMusicActiveIndex[MAXTF2PLAYERS] = { -1, ... };

int g_SlenderModel[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_SlenderCopyMaster[MAX_BOSSES] = { -1, ... };
int g_SlenderMaxCopies[MAX_BOSSES][Difficulty_Max];
int g_SlenderCompanionMaster[MAX_BOSSES] = { -1, ... };
float g_SlenderEyePosOffset[MAX_BOSSES][3];
float g_SlenderEyeAngOffset[MAX_BOSSES][3];
float g_SlenderDetectMins[MAX_BOSSES][3];
float g_SlenderDetectMaxs[MAX_BOSSES][3];
int g_SlenderRenderColor[MAX_BOSSES][4];
int g_SlenderRenderFX[MAX_BOSSES];
int g_SlenderRenderMode[MAX_BOSSES];
Handle g_SlenderThink[MAX_BOSSES];
Handle g_SlenderEntityThink[MAX_BOSSES];
Handle g_SlenderFakeTimer[MAX_BOSSES];
Handle g_SlenderDeathCamTimer[MAX_BOSSES];
int g_SlenderDeathCamTarget[MAX_BOSSES];
float g_SlenderStaticRadius[MAX_BOSSES][Difficulty_Max];
float g_SlenderStaticRate[MAX_BOSSES][Difficulty_Max];
float g_SlenderStaticRateDecay[MAX_BOSSES][Difficulty_Max];
float g_SlenderStaticGraceTime[MAX_BOSSES][Difficulty_Max];
bool g_SlenderAddCompanionsOnDifficulty[MAX_BOSSES] = { false, ... };
float g_SlenderStatueIdleLifeTime[MAX_BOSSES];

bool g_SlenderDeathCamScareSound[MAX_BOSSES];
bool g_SlenderPublicDeathCam[MAX_BOSSES];
float g_SlenderPublicDeathCamSpeed[MAX_BOSSES];
float g_SlenderPublicDeathCamAcceleration[MAX_BOSSES];
float g_SlenderPublicDeathCamDeceleration[MAX_BOSSES];
float g_SlenderPublicDeathCamBackwardOffset[MAX_BOSSES];
float g_SlenderPublicDeathCamDownwardOffset[MAX_BOSSES];
bool g_SlenderDeathCamOverlay[MAX_BOSSES];
float g_SlenderDeathCamOverlayTimeStart[MAX_BOSSES];
float g_SlenderDeathCamTime[MAX_BOSSES];

//The Gaben's stuff
bool g_SlenderCustomOutroSong[MAX_BOSSES];

bool g_SlenderUseCustomOutlines[MAX_BOSSES];
bool g_SlenderUseRainbowOutline[MAX_BOSSES];

int g_TrapEntityCount;
float g_RoundTimeMessage = 0.0;

int g_SlenderTeleportTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
int g_SlenderProxyTarget[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
bool g_SlenderTeleportTargetIsCamping[MAX_BOSSES] = { false, ... };

float g_SlenderNextTeleportTime[MAX_BOSSES] = { -1.0, ... };
float g_SlenderTeleportTargetTime[MAX_BOSSES] = { -1.0, ... };
float g_SlenderTeleportMinRange[MAX_BOSSES][Difficulty_Max];
float g_SlenderTeleportMaxRange[MAX_BOSSES][Difficulty_Max];
float g_SlenderTeleportMaxTargetTime[MAX_BOSSES] = { -1.0, ... };
float g_SlenderTeleportMaxTargetStress[MAX_BOSSES] = { 0.0, ... };
float g_SlenderTeleportPlayersRestTime[MAX_BOSSES][MAXTF2PLAYERS];
bool g_SlenderTeleportIgnoreChases[MAX_BOSSES];
bool g_SlenderTeleportIgnoreVis[MAX_BOSSES];

bool g_SlenderProxiesAllowNormalVoices[MAX_BOSSES];

int g_SlenderBoxingBossCount = 0;
int g_SlenderBoxingBossKilled = 0;
bool g_SlenderBoxingBossIsKilled[MAX_BOSSES] = { false, ... };

//The global timer replacing OnGameFrame()
Handle g_OnGameFrameTimer = null;

// For boss type 2
// General variables
PathFollower g_BossPathFollower[MAX_BOSSES];

float g_SlenderProxyTeleportMinRange[MAX_BOSSES][Difficulty_Max];
float g_SlenderProxyTeleportMaxRange[MAX_BOSSES][Difficulty_Max];

float g_SlenderNextJumpScare[MAX_BOSSES] = { -1.0, ... };

float g_SlenderTimeUntilKill[MAX_BOSSES] = { -1.0, ... };
float g_SlenderTimeUntilNextProxy[MAX_BOSSES] = { -1.0, ... };

float g_SlenderProxyDamageVsEnemy[MAX_BOSSES][Difficulty_Max];
float g_SlenderProxyDamageVsBackstab[MAX_BOSSES][Difficulty_Max];
float g_SlenderProxyDamageVsSelf[MAX_BOSSES][Difficulty_Max];
int g_SlenderProxyControlGainHitEnemy[MAX_BOSSES][Difficulty_Max];
int g_SlenderProxyControlGainHitByEnemy[MAX_BOSSES][Difficulty_Max];
float g_SlenderProxyControlDrainRate[MAX_BOSSES][Difficulty_Max];
int g_SlenderMaxProxies[MAX_BOSSES][Difficulty_Max];

int g_NightVisionType = 0;

//Healthbar
int g_HealthBar;

// Page data.
enum struct SF2PageEntityData
{
	int EntRef;
	char CollectSound[PLATFORM_MAX_PATH];
	int CollectSoundPitch;
}

ArrayList g_Pages;
ArrayList g_EmptySpawnPagePoints;
int g_PageCount;
int g_PageMax;
bool g_PageRef;
char g_PageRefModelName[PLATFORM_MAX_PATH];
float g_PageRefModelScale;

static Handle g_PlayerIntroMusicTimer[MAXTF2PLAYERS] = { null, ... };

float g_LastVisibilityProcess[MAXTF2PLAYERS];
bool g_PlayerSeesSlender[MAXTF2PLAYERS][MAX_BOSSES];
float g_PlayerSeesSlenderLastTime[MAXTF2PLAYERS][MAX_BOSSES];

float g_PlayerSightSoundNextTime[MAXTF2PLAYERS][MAX_BOSSES];

float g_PlayerScareLastTime[MAXTF2PLAYERS][MAX_BOSSES];
float g_PlayerScareNextTime[MAXTF2PLAYERS][MAX_BOSSES];
float g_PlayerStaticAmount[MAXTF2PLAYERS];

//Boxing data
int g_PlayerHitsToCrits[MAXTF2PLAYERS];
int g_PlayerHitsToHeads[MAXTF2PLAYERS];

static bool g_PlayersAreCritted = false;
static bool g_PlayersAreMiniCritted = false;

bool g_PlayerIn1UpCondition[MAXTF2PLAYERS];
bool g_PlayerDied1Up[MAXTF2PLAYERS];
bool g_PlayerFullyDied1Up[MAXTF2PLAYERS];

float g_PlayerProxyNextVoiceSound[MAXTF2PLAYERS];

bool g_PlayerTrapped[MAXTF2PLAYERS];
int g_PlayerTrapCount[MAXTF2PLAYERS];

bool g_PlayerLatchedByTongue[MAXTF2PLAYERS];
int g_PlayerLatchCount[MAXTF2PLAYERS];
int g_PlayerLatcher[MAXTF2PLAYERS];

int g_PlayerBossKillSubject[MAXTF2PLAYERS];

// Difficulty
bool g_PlayerCalledForNightmare[MAXTF2PLAYERS];
bool g_InProxySurvivalRageMode = false;

int g_PlayerRandomClassNumber[MAXTF2PLAYERS];

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
	bool PlayerPreference_LegacyHud;

	int PlayerPreference_MuteMode; //0 = Normal, 1 = Opposing Team, 2 = Opposing Team Proxy Ignore
	int PlayerPreference_FlashlightTemperature; //1 = 1000, 2 = 2000, 3 = 3000, 4 = 4000, 5 = 5000, 6 = 6000, 7 = 7000, 8 = 8000, 9 = 9000, 10 = 10000
	int PlayerPreference_GhostModeToggleState; //0 = Nothing, 1 = Ghost on grace end, 2 = Ghost on death
	int PlayerPreference_GhostModeTeleportState; //0 = Players, 1 = Bosses

	float PlayerPreference_MusicVolume;
}

PlayerPreferences g_PlayerPreferences[MAXTF2PLAYERS];

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

int g_Particles[MaxParticle] = { -1, ... };

// Player data.
bool g_PlayerIsExitCamping[MAXTF2PLAYERS];
int g_PlayerLastButtons[MAXTF2PLAYERS];
bool g_PlayerChoseTeam[MAXTF2PLAYERS];
bool g_PlayerEliminated[MAXTF2PLAYERS];
bool g_PlayerHasRegenerationItem[MAXTF2PLAYERS];
bool g_PlayerEscaped[MAXTF2PLAYERS];
int g_PlayerPageCount[MAXTF2PLAYERS];
int g_PlayerQueuePoints[MAXTF2PLAYERS];
bool g_PlayerPlaying[MAXTF2PLAYERS];
bool g_PlayerBackStabbed[MAXTF2PLAYERS];
Handle g_PlayerOverlayCheck[MAXTF2PLAYERS];

Handle g_PlayerSwitchBlueTimer[MAXTF2PLAYERS];

// Player stress data.
float g_PlayerStressAmount[MAXTF2PLAYERS];
float g_PlayerStressNextUpdateTime[MAXTF2PLAYERS];

// Proxy data.
bool g_PlayerProxy[MAXTF2PLAYERS];
bool g_PlayerProxyAvailable[MAXTF2PLAYERS];
Handle g_PlayerProxyAvailableTimer[MAXTF2PLAYERS];
bool g_PlayerProxyAvailableInForce[MAXTF2PLAYERS];
int g_PlayerProxyAvailableCount[MAXTF2PLAYERS];
int g_PlayerProxyMaster[MAXTF2PLAYERS];
int g_PlayerProxyControl[MAXTF2PLAYERS];
Handle g_PlayerProxyControlTimer[MAXTF2PLAYERS];
float g_PlayerProxyControlRate[MAXTF2PLAYERS];
Handle g_PlayerProxyVoiceTimer[MAXTF2PLAYERS];
int g_PlayerProxyAskMaster[MAXTF2PLAYERS] = { -1, ... };
float g_PlayerProxyAskPosition[MAXTF2PLAYERS][3];
int g_PlayerProxyAskSpawnPoint[MAXTF2PLAYERS] = { -1, ... };

int g_PlayerDesiredFOV[MAXTF2PLAYERS];

Handle g_PlayerPostWeaponsTimer[MAXTF2PLAYERS] = { null, ... };
Handle g_PlayerPageRewardCycleTimer[MAXTF2PLAYERS] = { null, ... };
static float g_PlayerPageRewardCycleCooldown[MAXTF2PLAYERS] = { 0.0, ... };
static int g_PlayerPageRewardCycleCount[MAXTF2PLAYERS] = { 0, ... };
Handle g_PlayerFireworkTimer[MAXTF2PLAYERS] = { null, ... };

bool g_PlayerGettingPageReward[MAXTF2PLAYERS] = { false, ... };

// Music system.
int g_PlayerMusicFlags[MAXTF2PLAYERS];
char g_PlayerMusicString[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
float g_PlayerMusicVolume[MAXTF2PLAYERS];
float g_PlayerMusicTargetVolume[MAXTF2PLAYERS];
Handle g_PlayerMusicTimer[MAXTF2PLAYERS];
int g_PlayerPageMusicMaster[MAXTF2PLAYERS];

// Chase music system, which apparently also uses the alert song system. And the idle sound system.
char g_PlayerChaseMusicString[MAXTF2PLAYERS][MAX_BOSSES][PLATFORM_MAX_PATH];
char g_PlayerChaseMusicSeeString[MAXTF2PLAYERS][MAX_BOSSES][PLATFORM_MAX_PATH];
float g_PlayerChaseMusicVolumes[MAXTF2PLAYERS][MAX_BOSSES];
float g_PlayerChaseMusicSeeVolumes[MAXTF2PLAYERS][MAX_BOSSES];
Handle g_PlayerChaseMusicTimer[MAXTF2PLAYERS][MAX_BOSSES];
Handle g_PlayerChaseMusicSeeTimer[MAXTF2PLAYERS][MAX_BOSSES];
int g_PlayerChaseMusicMaster[MAXTF2PLAYERS] = { -1, ... };
int g_PlayerChaseMusicSeeMaster[MAXTF2PLAYERS] = { -1, ... };
int g_PlayerChaseMusicOldMaster[MAXTF2PLAYERS] = { -1, ... };
int g_PlayerChaseMusicSeeOldMaster[MAXTF2PLAYERS] = { -1, ... };

char g_PlayerAlertMusicString[MAXTF2PLAYERS][MAX_BOSSES][PLATFORM_MAX_PATH];
float g_PlayerAlertMusicVolumes[MAXTF2PLAYERS][MAX_BOSSES];
Handle g_PlayerAlertMusicTimer[MAXTF2PLAYERS][MAX_BOSSES];
int g_PlayerAlertMusicMaster[MAXTF2PLAYERS] = { -1, ... };
int g_PlayerAlertMusicOldMaster[MAXTF2PLAYERS] = { -1, ... };

char g_PlayerIdleMusicString[MAXTF2PLAYERS][MAX_BOSSES][PLATFORM_MAX_PATH];
float g_PlayerIdleMusicVolumes[MAXTF2PLAYERS][MAX_BOSSES];
Handle g_PlayerIdleMusicTimer[MAXTF2PLAYERS][MAX_BOSSES];
int g_PlayerIdleMusicMaster[MAXTF2PLAYERS] = { -1, ... };
int g_PlayerIdleMusicOldMaster[MAXTF2PLAYERS] = { -1, ... };

char g_Player90sMusicString[MAXTF2PLAYERS][PLATFORM_MAX_PATH];
float g_Player90sMusicVolumes[MAXTF2PLAYERS];
Handle g_Player90sMusicTimer[MAXTF2PLAYERS];

SF2RoundState g_RoundState = SF2RoundState_Invalid;
float g_RoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
bool g_RoundInfiniteFlashlight = false;
bool g_IsSurvivalMap = false;
bool g_IsRaidMap = false;
bool g_IsProxyMap = false;
bool g_BossesChaseEndlessly = false;
bool g_IsBoxingMap = false;
bool g_IsSlaughterRunMap = false;
bool g_RoundInfiniteBlink = false;
bool g_IsRoundInfiniteSprint = false;

bool g_RoundTimerPaused = false;
Handle g_RoundGraceTimer = null;
Handle g_RoundTimer = null;
Handle g_VoteTimer = null;
static char g_RoundBossProfile[SF2_MAX_PROFILE_NAME_LENGTH];
static char g_RoundBoxingBossProfile[SF2_MAX_PROFILE_NAME_LENGTH];

int g_RoundCount = 0;
int g_RoundEndCount = 0;
int g_RoundActiveCount = 0;
int g_RoundTime = 0;
int g_SpecialRoundTime = 0;
int g_TimeEscape = 0;
int g_RoundTimeLimit = 0;
int g_RoundEscapeTimeLimit = 0;
int g_RoundTimeGainFromPage = 0;
bool g_RoundHasEscapeObjective = false;
bool g_RoundStopPageMusicOnEscape = false;

static int g_RoundEscapePointEntity = INVALID_ENT_REFERENCE;

static int g_RoundIntroFadeColor[4] = { 255, ... };
static float g_RoundIntroFadeHoldTime;
static float g_RoundIntroFadeDuration;
static Handle g_RoundIntroTimer = null;
static bool g_RoundIntroTextDefault = true;
static Handle g_RoundIntroTextTimer = null;
static int g_RoundIntroText;
char g_RoundIntroMusic[PLATFORM_MAX_PATH] = "";
static char g_PageCollectSound[PLATFORM_MAX_PATH] = "";
static int g_PageSoundPitch = 100;
char currentMusicTrack[PLATFORM_MAX_PATH], currentMusicTrackNormal[PLATFORM_MAX_PATH], currentMusicTrackHard[PLATFORM_MAX_PATH], currentMusicTrackInsane[PLATFORM_MAX_PATH], currentMusicTrackNightmare[PLATFORM_MAX_PATH], currentMusicTrackApollyon[PLATFORM_MAX_PATH];

int g_RoundWarmupRoundCount = 0;

bool g_RoundWaitingForPlayers = false;

// Special round variables.
bool g_IsSpecialRound = false;

bool g_IsSpecialRoundNew = false;
bool g_IsSpecialRoundContinuous = false;
int g_SpecialRoundCount = 1;
bool g_PlayerPlayedSpecialRound[MAXTF2PLAYERS] = { true, ... };

// int boss round variables.
bool g_NewBossRound = false;
static bool g_NewBossRoundNew = false;
static bool g_NewBossRoundContinuous = false;
static int g_NewBossRoundCount = 1;

bool g_PlayerPlayedNewBossRound[MAXTF2PLAYERS] = { true, ... };
static char g_NewBossRoundProfileRoundProfile[64] = "";

static Handle g_RoundMessagesTimer = null;
static int g_RoundMessagesNum = 0;

static Handle g_BossCountUpdateTimer = null;
Handle g_ClientAverageUpdateTimer = null;

// Server variables.
ConVar g_VersionConVar;
ConVar g_EnabledConVar;
ConVar g_SlenderMapsOnlyConVar;
ConVar g_PlayerViewbobEnabledConVar;
ConVar g_PlayerShakeEnabledConVar;
ConVar g_PlayerShakeFrequencyMaxConVar;
ConVar g_PlayerShakeAmplitudeMaxConVar;
ConVar g_GraceTimeConVar;
ConVar g_AllChatConVar;
ConVar g_MaxPlayersConVar;
ConVar g_MaxPlayersOverrideConVar;
ConVar g_DifficultyConVar;
ConVar g_CameraOverlayConVar;
ConVar g_OverlayNoGrainConVar;
ConVar g_GhostOverlayConVar;
ConVar g_BossMainConVar;
ConVar g_BossProfileOverrideConVar;
ConVar g_PlayerBlinkRateConVar;
ConVar g_PlayerBlinkHoldTimeConVar;
ConVar g_SpecialRoundBehaviorConVar;
ConVar g_SpecialRoundForceConVar;
ConVar g_SpecialRoundOverrideConVar;
ConVar g_SpecialRoundIntervalConVar;
ConVar g_NewBossRoundBehaviorConVar;
ConVar g_NewBossRoundIntervalConVar;
ConVar g_NewBossRoundForceConVar;
ConVar g_IgnoreRoundWinConditionsConVar;
ConVar g_EnableWallHaxConVar;
ConVar g_IgnoreRedPlayerDeathSwapConVar;
ConVar g_PlayerVoiceDistanceConVar;
ConVar g_PlayerVoiceWallScaleConVar;
ConVar g_UltravisionEnabledConVar;
ConVar g_UltravisionRadiusRedConVar;
ConVar g_UltravisionRadiusBlueConVar;
ConVar g_UltravisionBrightnessConVar;
ConVar g_NightvisionRadiusConVar;
ConVar g_NightvisionEnabledConVar;
ConVar g_GhostModeConnectionConVar;
ConVar g_GhostModeConnectionCheckConVar;
ConVar g_GhostModeConnectionToleranceConVar;
ConVar g_IntroEnabledConVar;
ConVar g_IntroDefaultHoldTimeConVar;
ConVar g_IntroDefaultFadeTimeConVar;
ConVar g_TimeLimitConVar;
ConVar g_TimeLimitEscapeConVar;
ConVar g_TimeGainFromPageGrabConVar;
ConVar g_WarmupRoundConVar;
ConVar g_WarmupRoundNumConVar;
ConVar g_PlayerViewbobHurtEnabledConVar;
ConVar g_PlayerViewbobSprintEnabledConVar;
ConVar g_PlayerProxyWaitTimeConVar;
ConVar g_PlayerProxyAskConVar;
ConVar g_PlayerAFKTimeConVar;
ConVar g_BlockSuicideDuringRoundConVar;
ConVar g_RaidMapConVar;
ConVar g_ProxyMapConVar;
ConVar g_BossChaseEndlesslyConVar;
ConVar g_SurvivalMapConVar;
ConVar g_BoxingMapConVar;
ConVar g_RenevantMapConVar;
ConVar g_DefaultRenevantBossConVar;
ConVar g_DefaultRenevantBossMessageConVar;
ConVar g_RenevantMaxWaves;
ConVar g_SlaughterRunMapConVar;
ConVar g_TimeEscapeSurvivalConVar;
ConVar g_SlaughterRunDivisibleTimeConVar;
ConVar g_SlaughterRunDefaultClassRunSpeedConVar;
ConVar g_SlaughterRunMinimumBossRunSpeedConVar;
ConVar g_UseAlternateConfigDirectoryConVar;
ConVar g_PlayerKeepWeaponsConVar;
ConVar g_FullyEnableSpectatorConVar;
ConVar g_AllowPlayerPeekingConVar;
ConVar g_UsePlayersForKillFeedConVar;
ConVar g_DefaultLegacyHudConVar;
ConVar g_DifficultyVoteOptionsConVar;
ConVar g_DifficultyVoteRandomConVar;
ConVar g_DifficultyVoteRevoteConVar;
ConVar g_DifficultyNoGracePageConVar;
ConVar g_HighDifficultyPercentConVar;
ConVar g_FileCheckConVar;
ConVar g_LoadOutsideMapsConVar;
ConVar g_DefaultBossTeamConVar;
ConVar g_EngineerBuildInBLUConVar;

ConVar g_RestartSessionConVar;
bool g_RestartSessionEnabled;

ConVar g_PlayerInfiniteSprintOverrideConVar;
ConVar g_PlayerInfiniteFlashlightOverrideConVar;
ConVar g_PlayerInfiniteBlinkOverrideConVar;

ConVar g_MaxRoundsConVar;
ConVar g_ForcedHolidayConVar;
ConVar g_WeaponCriticalsConVar;
ConVar g_PhysicsPushScaleConVar;
ConVar g_DragonsFuryBurningBonusConVar;
ConVar g_DragonsFuryBurnDurationConVar;

bool g_IsPlayerShakeEnabled;
bool g_PlayerViewbobHurtEnabled;
bool g_PlayerViewbobSprintEnabled;

Handle g_HudSync;
Handle g_HudSync2;
Handle g_HudSync3;
Handle g_HudSync4;
Handle g_RoundTimerSync;

Handle g_Cookie;

int g_ShockwaveBeam;
int g_ShockwaveHalo;
char g_DebugBeamSound[PLATFORM_MAX_PATH];

ArrayList g_Buildings;
ArrayList g_WhitelistedEntities;
ArrayList g_BreakableProps;

// Global forwards.
GlobalForward g_OnBossAddedFwd;
GlobalForward g_OnBossSpawnFwd;
GlobalForward g_OnBossDespawnFwd;
GlobalForward g_OnBossChangeStateFwd;
GlobalForward g_OnBossGetSpeedFwd;
GlobalForward g_OnBossGetWalkSpeedFwd;
GlobalForward g_OnBossSeeEntityFwd;
GlobalForward g_OnBossHearEntityFwd;
GlobalForward g_OnBossRemovedFwd;
GlobalForward g_OnBossStunnedFwd;
GlobalForward g_OnBossKilledFwd;
GlobalForward g_OnBossCloakedFwd;
GlobalForward g_OnBossDecloakedFwd;
GlobalForward g_OnBossFinishSpawningFwd;
GlobalForward g_OnBossPreAttackFwd;
GlobalForward g_OnBossAttackedFwd;
GlobalForward g_OnBossPreTakeDamageFwd;
GlobalForward g_OnBossPreFlashlightDamageFwd;
GlobalForward g_OnBossAnimationUpdateFwd;
GlobalForward g_OnChaserBossGetSuspendActionFwd;
GlobalForward g_OnPagesSpawnedFwd;
GlobalForward g_OnRoundStateChangeFwd;
GlobalForward g_OnClientCollectPageFwd;
GlobalForward g_OnClientBlinkFwd;
GlobalForward g_OnClientScareFwd;
GlobalForward g_OnClientCaughtByBossFwd;
GlobalForward g_OnClientGiveQueuePointsFwd;
GlobalForward g_OnClientActivateFlashlightFwd;
GlobalForward g_OnClientDeactivateFlashlightFwd;
GlobalForward g_OnClientBreakFlashlightFwd;
GlobalForward g_OnClientStartSprintingFwd;
GlobalForward g_OnClientStopSprintingFwd;
GlobalForward g_OnClientEscapeFwd;
GlobalForward g_OnClientLooksAtBossFwd;
GlobalForward g_OnClientLooksAwayFromBossFwd;
GlobalForward g_OnClientStartDeathCamFwd;
GlobalForward g_OnClientPreKillDeathCamFwd;
GlobalForward g_OnClientEndDeathCamFwd;
GlobalForward g_OnClientGetDefaultWalkSpeedFwd;
GlobalForward g_OnClientGetDefaultSprintSpeedFwd;
GlobalForward g_OnClientTakeDamageFwd;
GlobalForward g_OnClientSpawnedAsProxyFwd;
GlobalForward g_OnClientDamagedByBossFwd;
GlobalForward g_OnGroupGiveQueuePointsFwd;
GlobalForward g_OnBossPackVoteStartFwd;
GlobalForward g_OnDifficultyChangeFwd;
GlobalForward g_OnClientEnterGameFwd;
GlobalForward g_OnGroupEnterGameFwd;
GlobalForward g_OnEverythingLoadedFwd;
GlobalForward g_OnDifficultyVoteFinishedFwd;
GlobalForward g_OnIsBossCustomAttackPossibleFwd;
GlobalForward g_OnBossGetCustomAttackActionFwd;
GlobalForward g_OnProjectileTouchFwd;

// Private forwards
PrivateForward g_OnGamemodeStartPFwd;
PrivateForward g_OnGamemodeEndPFwd;
PrivateForward g_OnMapStartPFwd;
PrivateForward g_OnMapEndPFwd;
PrivateForward g_OnGameFramePFwd;
PrivateForward g_OnRoundStartPFwd;
PrivateForward g_OnRoundEndPFwd;
PrivateForward g_OnEntityCreatedPFwd;
PrivateForward g_OnEntityDestroyedPFwd;
PrivateForward g_OnEntityTeleportedPFwd;
PrivateForward g_OnAdminMenuCreateOptionsPFwd;
PrivateForward g_OnPlayerJumpPFwd;
PrivateForward g_OnPlayerSpawnPFwd;
PrivateForward g_OnPlayerTakeDamagePFwd;
PrivateForward g_OnPlayerDeathPrePFwd;
PrivateForward g_OnPlayerDeathPFwd;
PrivateForward g_OnPlayerPutInServerPFwd;
PrivateForward g_OnPlayerDisconnectedPFwd;
PrivateForward g_OnPlayerEscapePFwd;
PrivateForward g_OnPlayerTeamPFwd;
PrivateForward g_OnPlayerClassPFwd;
PrivateForward g_OnPlayerLookAtBossPFwd;
PrivateForward g_OnPlayerChangePlayStatePFwd;
PrivateForward g_OnPlayerChangeGhostStatePFwd;
PrivateForward g_OnPlayerChangeProxyStatePFwd;
PrivateForward g_OnPlayerConditionAddedPFwd;
PrivateForward g_OnPlayerConditionRemovedPFwd;
PrivateForward g_OnPlayerTurnOnFlashlightPFwd;
PrivateForward g_OnPlayerTurnOffFlashlightPFwd;
PrivateForward g_OnPlayerFlashlightBreakPFwd;
PrivateForward g_OnPlayerAverageUpdatePFwd;
PrivateForward g_OnSpecialRoundStartPFwd;
PrivateForward g_OnBossSpawnPFwd;
PrivateForward g_OnBossRemovedPFwd;
PrivateForward g_OnChaserGetAttackActionPFwd;
PrivateForward g_OnChaserGetCustomAttackPossibleStatePFwd;
PrivateForward g_OnChaserUpdatePosturePFwd;
PrivateForward g_OnDifficultyChangePFwd;
PrivateForward g_OnDifficultyVoteFinishedPFwd;
PrivateForward g_OnRenevantTriggerWavePFwd;
PrivateForward g_OnWallHaxDebugPFwd;

Handle g_SDKGetMaxHealth;
Handle g_SDKEquipWearable;
Handle g_SDKPlaySpecificSequence;
Handle g_SDKPointIsWithin;
Handle g_SDKPassesTriggerFilters;
Handle g_SDKLookupBone;
Handle g_SDKGetBonePosition;
Handle g_SDKSequenceVelocity;
Handle g_SDKStartTouch;
Handle g_SDKEndTouch;
Handle g_SDKWeaponSwitch;
Handle g_SDKGetWeaponID;
Handle g_SDKIsWeapon;

DynamicHook g_DHookWantsLagCompensationOnEntity;
DynamicHook g_DHookShouldTransmit;
DynamicHook g_DHookUpdateTransmitState;
DynamicHook g_DHookWeaponGetCustomDamageType;
DynamicHook g_DHookProjectileCanCollideWithTeammates;

// SourceTV userid used for boss name
int g_SourceTVUserID = -1;
char g_OldClientName[MAXTF2PLAYERS][64];
Handle g_TimerChangeClientName[MAXTF2PLAYERS] = { null, ... };

//Fail Timer
Handle g_TimerFail = null;

//Renevant
int g_RenevantWaveNumber = 0;
int g_RenevantFinaleTime = 0;
bool g_RenevantMultiEffect = false;
bool g_RenevantBeaconEffect = false;
bool g_Renevant90sEffect = false;
bool g_RenevantMarkForDeath = false;
bool g_RenevantWallHax = false;
bool g_RenevantBossesChaseEndlessly = false;
bool g_IsRenevantMap = false;
Handle g_RenevantWaveTimer = null;
ArrayList g_RenevantWaveList;

stock ArrayList g_FuncNavPrefer;

#define SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND "ui/item_acquired.wav"

#define SF2_FLASHLIGHT_BEAM_MATERIAL "sprites/glow_test02.vmt"
#define SF2_FLASHLIGHT_HALO_MATERIAL "sprites/glow1.vmt"

int g_FlashlightHaloModel = -1;

#if defined DEBUG
#include "sf2/debug.sp"
#endif
#include "sf2/stocks.sp"
#include "sf2/logging.sp"
#include "sf2/glow.sp"
#include "sf2/methodmaps.sp"
#include "sf2/classconfigs.sp"
#include "sf2/profiles.sp"
#include "sf2/effects.sp"
#include "sf2/playergroups.sp"
#include "sf2/mapentities.sp"
#include "sf2/entities/initialize.sp"
#include "sf2/menus.sp"
#include "sf2/npc.sp"
#include "sf2/pvp.sp"
#include "sf2/pve.sp"
#include "sf2/client.sp"
#include "sf2/specialround.sp"
#include "sf2/anticamping.sp"
#include "sf2/adminmenu.sp"
#include "sf2/traps.sp"
#include "sf2/gamemodes/renevant.sp"
#include "sf2/extras/natives.sp"
#include "sf2/extras/commands.sp"
#include "sf2/extras/game_events.sp"
#include "sf2/extras/afk_mode.sp"

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
	g_TimerFail = null;
	FindHealthBar();
	PrecacheSound(SOUND_THUNDER, true);
	PrecacheSound("weapons/teleporter_send.wav");
	g_ShockwaveBeam = PrecacheModel("sprites/laser.vmt");
	g_ShockwaveHalo = PrecacheModel("sprites/halo01.vmt");
	PrecacheModel(LASER_MODEL, true);
	char overlay[PLATFORM_MAX_PATH];
	g_CameraOverlayConVar.GetString(overlay, sizeof(overlay));
	PrecacheMaterial2(overlay, true);
	g_OverlayNoGrainConVar.GetString(overlay, sizeof(overlay));
	PrecacheMaterial2(overlay, true);
	g_GhostOverlayConVar.GetString(overlay, sizeof(overlay));
	PrecacheMaterial2(overlay, true);
	g_DebugBeamSound = "buttons/blip1.wav";
	PrecacheSound(g_DebugBeamSound);

	PrecacheModel(SF2_FLASHLIGHT_BEAM_MATERIAL);
	g_FlashlightHaloModel = PrecacheModel(SF2_FLASHLIGHT_HALO_MATERIAL, true);

	Call_StartForward(g_OnMapStartPFwd);
	Call_Finish();
}

public void OnConfigsExecuted()
{
	if (!g_EnabledConVar.BoolValue)
	{
		StopPlugin();
	}
	else
	{
		if (g_SlenderMapsOnlyConVar.BoolValue)
		{
			char map[256];
			GetCurrentMap(map, sizeof(map));

			if (!StrContains(map, "slender_", false) || !StrContains(map, "sf2_", false))
			{
				StartPlugin();
			}
			else
			{
				LogMessage("%s is not a Slender Fortress map. Plugin disabled!", map);
				StopPlugin();
				if (g_LoadOutsideMapsConVar.BoolValue)
				{
					InitializeLogging();
					PrecacheStuff();
					ReloadBossProfiles();
					NPCOnConfigsExecuted();

					int ent = -1;
					while ((ent = FindEntityByClassname(ent, "obj_sentrygun")) != -1)
					{
						g_Buildings.Push(EntIndexToEntRef(ent));
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "obj_teleporter")) != -1)
					{
						g_Buildings.Push(EntIndexToEntRef(ent));
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "obj_dispenser")) != -1)
					{
						g_Buildings.Push(EntIndexToEntRef(ent));
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "tank_boss")) != -1)
					{
						g_WhitelistedEntities.Push(EntIndexToEntRef(ent));
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "prop_physics")) != -1)
					{
						if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
						{
							g_BreakableProps.Push(EntIndexToEntRef(ent));
						}
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "prop_dynamic")) != -1)
					{
						if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
						{
							g_BreakableProps.Push(EntIndexToEntRef(ent));
						}
					}

					ent = -1;
					while ((ent = FindEntityByClassname(ent, "func_breakable")) != -1)
					{
						if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
						{
							g_BreakableProps.Push(EntIndexToEntRef(ent));
						}
					}

					for (int i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i))
						{
							continue;
						}
						g_ClientInGame[i] = true;
						SDKHook(i, SDKHook_OnTakeDamage, Hook_ClientOnTakeDamage);
						Call_StartForward(g_OnPlayerPutInServerPFwd);
						Call_PushCell(SF2_BasePlayer(i));
						Call_Finish();
					}
				}
			}
		}
		else
		{
			StartPlugin();
		}
	}

	for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
	{
		if (g_BossPathFollower[bossIndex])
		{
			continue;
		}
		g_BossPathFollower[bossIndex] = PathFollower(_, TraceRayDontHitAnyEntity_Pathing, Path_FilterOnlyActors);
	}
}

static void StartPlugin()
{
	if (g_Enabled)
	{
		return;
	}

	g_Enabled = true;

	InitializeLogging();

	#if defined DEBUG
	InitializeDebugLogging();
	#endif

	int i2 = 0;

	// Handle ConVars.
	ConVar cvar = FindConVar("mp_friendlyfire");
	if (cvar != null)
	{
		cvar.SetBool(true);
	}

	cvar = FindConVar("mp_flashlight");
	if (cvar != null)
	{
		cvar.SetBool(true);
	}

	cvar = FindConVar("mat_supportflashlight");
	if (cvar != null)
	{
		cvar.SetBool(true);
	}

	cvar = FindConVar("mp_autoteambalance");
	if (cvar != null)
	{
		cvar.SetBool(false);
	}

	cvar = FindConVar("mp_scrambleteams_auto");
	if (cvar != null)
	{
		cvar.SetBool(false);
	}

	if (!g_FullyEnableSpectatorConVar.BoolValue)
	{
		cvar = FindConVar("mp_allowspectators");
		if (cvar != null)
		{
			cvar.SetBool(false);
		}
	}

	g_IsPlayerShakeEnabled = g_PlayerShakeEnabledConVar.BoolValue;
	g_PlayerViewbobHurtEnabled = g_PlayerViewbobHurtEnabledConVar.BoolValue;
	g_PlayerViewbobSprintEnabled = g_PlayerViewbobSprintEnabledConVar.BoolValue;

	#if defined _SteamWorks_Included
	if (steamworks)
	{
		SteamWorks_SetGameDescription("SF2M Rewrite ("...PLUGIN_VERSION_DISPLAY...")");
		steamtools = false;
	}
	#endif
	#if defined _steamtools_included
	if (steamtools)
	{
		Steam_SetGameDescription("SF2M Rewrite ("...PLUGIN_VERSION_DISPLAY...")");
		steamworks = false;
	}
	#endif

	if (steamworks)
	{
		i2 = 1;
	}
	else if (steamtools)
	{
		i2 = 2;
	}

	PrecacheStuff();

	if (i2 == 1 || i2 == 2 || i2 == 0)
	{
		// Sourcemod loves to call steamworks and steamtools unused symbols, do this to prevent this
	}

	// Reset special round.
	g_IsSpecialRound = false;
	g_IsSpecialRoundNew = false;
	g_IsSpecialRoundContinuous = false;
	g_SpecialRoundCount = 1;
	SF_RemoveAllSpecialRound();

	SpecialRoundReset();

	// Reset boss rounds.
	g_NewBossRound = false;
	g_NewBossRoundNew = false;
	g_NewBossRoundContinuous = false;
	g_NewBossRoundCount = 1;
	g_NewBossRoundProfileRoundProfile[0] = '\0';

	// Reset global round vars.
	g_RoundCount = 0;
	g_RoundEndCount = 0;
	g_RoundActiveCount = 0;
	g_RoundState = SF2RoundState_Invalid;
	g_RoundMessagesTimer = CreateTimer(200.0, Timer_RoundMessages, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_RoundMessagesNum = 0;

	g_RoundWarmupRoundCount = 0;

	g_ClientAverageUpdateTimer = CreateTimer(0.1, Timer_ClientAverageUpdate, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	g_BossCountUpdateTimer = CreateTimer(2.0, Timer_BossCountUpdate, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

	g_OnGameFrameTimer = CreateTimer(0.1, Timer_GlobalGameFrame, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);

	SetRoundState(SF2RoundState_Waiting);

	ReloadBossProfiles();
	ReloadRestrictedWeapons();
	ReloadSpecialRounds();
	ReloadClassConfigs();

	NPCOnConfigsExecuted();

	InitializeBossPackVotes();
	SetupTimeLimitTimerForBossPackVote();

	// Late load compensation.
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i))
		{
			continue;
		}
		OnClientPutInServer(i);
	}

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "obj_sentrygun")) != -1)
	{
		g_Buildings.Push(EntIndexToEntRef(ent));
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "obj_teleporter")) != -1)
	{
		g_Buildings.Push(EntIndexToEntRef(ent));
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "obj_dispenser")) != -1)
	{
		g_Buildings.Push(EntIndexToEntRef(ent));
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "tank_boss")) != -1)
	{
		g_WhitelistedEntities.Push(EntIndexToEntRef(ent));
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "prop_physics")) != -1)
	{
		if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
		{
			g_BreakableProps.Push(EntIndexToEntRef(ent));
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "prop_dynamic")) != -1)
	{
		if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
		{
			g_BreakableProps.Push(EntIndexToEntRef(ent));
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_breakable")) != -1)
	{
		if (GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
		{
			g_BreakableProps.Push(EntIndexToEntRef(ent));
		}
	}

	Call_StartForward(g_OnGamemodeStartPFwd);
	Call_Finish();
}

static void PrecacheStuff()
{
	// Initialize particles.
	g_Particles[CriticalHit] = PrecacheParticleSystem(CRIT_PARTICLENAME);
	g_Particles[MiniCritHit] = PrecacheParticleSystem(MINICRIT_PARTICLENAME);
	g_Particles[ZapParticle] = PrecacheParticleSystem(ZAP_PARTICLENAME);
	g_Particles[FireworksRED] = PrecacheParticleSystem(FIREWORKSRED_PARTICLENAME);
	g_Particles[FireworksBLU] = PrecacheParticleSystem(FIREWORKSBLU_PARTICLENAME);
	g_Particles[TeleportedInBlu] = PrecacheParticleSystem(TELEPORTEDINBLU_PARTICLENAME);

	for (int i = 0; i < sizeof(g_SoundNightmareMode); i++)
	{
		PrecacheSound(g_SoundNightmareMode[i], true);
	}

	PrecacheSound("ui/itemcrate_smash_ultrarare_short.wav");
	PrecacheSound(")weapons/crusaders_crossbow_shoot.wav");
	PrecacheSound(MINICRIT_SOUND);
	PrecacheSound(CRIT_SOUND);
	PrecacheSound(ZAP_SOUND);
	PrecacheSound(PAGE_DETECTOR_BEEP);
	PrecacheSound(SPECIAL1UPSOUND);
	PrecacheSound("player/spy_shield_break.wav");

	PrecacheSound(CRIT_ROLL);
	PrecacheSound(EXPLODE_PLAYER);
	PrecacheSound(UBER_ROLL);
	PrecacheSound(NO_EFFECT_ROLL);
	PrecacheSound(BLEED_ROLL);
	PrecacheSound(GENERIC_ROLL_TICK);
	PrecacheSound(LOSE_SPRINT_ROLL);
	PrecacheSound(MINICRIT_BUFF);
	PrecacheSound(NULLSOUND);
	PrecacheSound(JARATE_ROLL);
	PrecacheSound(GAS_ROLL);

	// simple_bot;
	PrecacheModel("models/humans/group01/female_01.mdl", true);

	PrecacheModel(PAGE_MODEL, true);
	PrecacheModel(SF_KEYMODEL, true);
	PrecacheModel(TRAP_MODEL, true);

	PrecacheSound2(FLASHLIGHT_CLICKSOUND, true);
	PrecacheSound2(FLASHLIGHT_CLICKSOUND_NIGHTVISION, true);
	PrecacheSound2(FLASHLIGHT_BREAKSOUND, true);
	PrecacheSound2(FLASHLIGHT_NOSOUND, true);
	PrecacheSound2(PAGE_GRABSOUND, true);

	PrecacheSound(DEFAULT_CLOAKONSOUND);
	PrecacheSound(DEFAULT_CLOAKOFFSOUND);

	PrecacheSound(FIREBALL_IMPACT);
	PrecacheSound(FIREBALL_SHOOT);
	PrecacheSound(ICEBALL_IMPACT);
	PrecacheSound(ROCKET_SHOOT);
	PrecacheSound(ROCKET_IMPACT);
	PrecacheSound(ROCKET_IMPACT2);
	PrecacheSound(ROCKET_IMPACT3);
	PrecacheSound(GRENADE_SHOOT);
	PrecacheSound(SENTRYROCKET_SHOOT);
	PrecacheSound(ARROW_SHOOT);
	PrecacheSound(MANGLER_EXPLODE1);
	PrecacheSound(MANGLER_EXPLODE2);
	PrecacheSound(MANGLER_EXPLODE3);
	PrecacheSound(MANGLER_SHOOT);
	PrecacheSound(BASEBALL_SHOOT);

	PrecacheSound(THANATOPHOBIA_SCOUTNO);
	PrecacheSound(THANATOPHOBIA_SOLDIERNO);
	PrecacheSound(THANATOPHOBIA_PYRONO);
	PrecacheSound(THANATOPHOBIA_DEMOMANNO);
	PrecacheSound(THANATOPHOBIA_HEAVYNO);
	PrecacheSound(THANATOPHOBIA_ENGINEERNO);
	PrecacheSound(THANATOPHOBIA_MEDICNO);
	PrecacheSound(THANATOPHOBIA_SNIPERNO);
	PrecacheSound(THANATOPHOBIA_SPYNO);

	PrecacheModel(ROCKET_MODEL, true);
	PrecacheModel(GRENADE_MODEL, true);
	PrecacheModel(BASEBALL_MODEL, true);

	PrecacheSound(JARATE_HITPLAYER);
	PrecacheSound(STUN_HITPLAYER);

	PrecacheSound2(MUSIC_GOTPAGES1_SOUND, true);
	PrecacheSound2(MUSIC_GOTPAGES2_SOUND, true);
	PrecacheSound2(MUSIC_GOTPAGES3_SOUND, true);
	PrecacheSound2(MUSIC_GOTPAGES4_SOUND, true);

	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_1, true);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_2, true);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_3, true);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_4, true);
	PrecacheSound2(HYPERSNATCHER_NIGHTAMRE_5, true);
	PrecacheSound2(SNATCHER_APOLLYON_1, true);
	PrecacheSound2(SNATCHER_APOLLYON_2, true);
	PrecacheSound2(SNATCHER_APOLLYON_3, true);

	PrecacheSound2(NINETYSMUSIC, true);

	PrecacheSound2(TRAP_CLOSE, true);
	PrecacheSound2(TRAP_DEPLOY, true);

	for (int i = 0; i < sizeof(g_PageCollectDuckSounds); i++)
	{
		PrecacheSound(g_PageCollectDuckSounds[i]);
	}

	PrecacheSound2(PROXY_RAGE_MODE_SOUND, true);

	PrecacheSound2(SF2_PROJECTED_FLASHLIGHT_CONFIRM_SOUND, true);

	for (int i = 0; i < sizeof(g_PlayerBreathSounds); i++)
	{
		PrecacheSound2(g_PlayerBreathSounds[i], true);
	}

	// Special round.
	PrecacheSound2(SR_MUSIC, true);
	PrecacheSound2(SR_SOUND_SELECT, true);
	PrecacheSound(SR_SOUND_SELECT_BR);
	PrecacheSound2(SF2_INTRO_DEFAULT_MUSIC, true);

	AddFileToDownloadsTable("models/slender/pickups/sheet.mdl");
	AddFileToDownloadsTable("models/slender/pickups/sheet.dx80.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.dx90.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.phy");
	AddFileToDownloadsTable("models/slender/pickups/sheet.sw.vtx");
	AddFileToDownloadsTable("models/slender/pickups/sheet.vvd");

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
	if (!g_Enabled)
	{
		return;
	}

	g_Enabled = false;

	// Reset CVars.
	ConVar cvar = FindConVar("mp_friendlyfire");
	if (cvar != null)
	{
		cvar.SetBool(false);
	}

	cvar = FindConVar("mp_flashlight");
	if (cvar != null)
	{
		cvar.SetBool(false);
	}

	cvar = FindConVar("mat_supportflashlight");
	if (cvar != null)
	{
		cvar.SetBool(false);
	}

	if (MusicActive())
	{
		NPCStopMusic();
	}

	// Cleanup clients.
	for (int i = 1; i <= MaxClients; i++)
	{
		ClientResetFlashlight(i);
		ClientDeactivateUltravision(i);
		g_TimerChangeClientName[i] = null;
	}

	for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
	{
		if (g_BossPathFollower[bossIndex])
		{
			g_BossPathFollower[bossIndex].Destroy();
			g_BossPathFollower[bossIndex] = view_as<PathFollower>(0);
		}
	}

	Call_StartForward(g_OnGamemodeEndPFwd);
	Call_Finish();

	if (g_FuncNavPrefer != null)
	{
		delete g_FuncNavPrefer;
	}

	delete g_Config;
}

public void OnMapEnd()
{
	if (!g_Enabled && !g_LoadOutsideMapsConVar.BoolValue)
	{
		return;
	}

	StopPlugin();

	g_RestartSessionEnabled = false;
	g_RestartSessionConVar.SetBool(false);

	g_RenevantMultiEffect = false;
	g_RenevantBeaconEffect = false;
	g_Renevant90sEffect = false;
	g_RenevantMarkForDeath = false;
	g_RenevantBossesChaseEndlessly = false;
	g_RenevantWallHax = false;

	BossProfilesOnMapEnd();
	NPCRemoveAll();

	Call_StartForward(g_OnMapEndPFwd);
	Call_Finish();
}

public void OnMapTimeLeftChanged()
{
	if (g_Enabled)
	{
		SetupTimeLimitTimerForBossPackVote();
	}
}

public void TF2_OnConditionAdded(int client, TFCond cond)
{
	g_ClientInCondition[client][cond] = true;

	if (!g_Enabled)
	{
		return;
	}
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (cond == TFCond_Taunting)
	{
		if (player.IsInGhostMode)
		{
			// Stop ghosties from taunting.
			player.ChangeCondition(TFCond_Taunting, true);
		}

		if (player.IsProxy)
		{
			player.ProxyControl -= 20;
		}

		if (player.UsingFlashlight)
		{
			player.HandleFlashlight();
		}
	}

	if (cond == TFCond_HalloweenKart)
	{
		if (player.IsProxy)
		{
			//Stop proxies from using kart commands
			player.ChangeCondition(TFCond_HalloweenKart, true);
			player.ChangeCondition(TFCond_HalloweenKartDash, true);
			player.ChangeCondition(TFCond_HalloweenKartNoTurn, true);
			player.ChangeCondition(TFCond_HalloweenKartCage, true);
			player.ChangeCondition(TFCond_SpawnOutline, true);
		}
	}

	Call_StartForward(g_OnPlayerConditionAddedPFwd);
	Call_PushCell(player);
	Call_PushCell(cond);
	Call_Finish();
}

public void TF2_OnConditionRemoved(int client, TFCond condition)
{
	g_ClientInCondition[client][condition] = false;

	if (!g_Enabled)
	{
		return;
	}

	Call_StartForward(g_OnPlayerConditionRemovedPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_PushCell(condition);
	Call_Finish();
}

static Action Timer_GlobalGameFrame(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	if (timer != g_OnGameFrameTimer)
	{
		return Plugin_Stop;
	}

	if (IsRoundPlaying())
	{
		g_RoundTimeMessage += 0.1;
	}
	else
	{
		g_RoundTimeMessage = 0.0;
	}

	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		char boxingBossName[SF2_MAX_NAME_LENGTH], message[1024];
		for (int i = 0; i < MAX_BOSSES; i++)
		{
			if (NPCGetUniqueID(i) == -1)
			{
				continue;
			}
			SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(i));
			if (!chaser.IsValid())
			{
				continue;
			}

			SF2NPC_Chaser controller = chaser.Controller;
			if (!controller.GetProfileData().BoxingBoss)
			{
				continue;
			}

			SF2NPC_BaseNPC baseNPC = view_as<SF2NPC_BaseNPC>(controller);
			if (baseNPC.GetProfileData().IsPvEBoss)
			{
				continue;
			}
			NPCGetBossName(i, boxingBossName, sizeof(boxingBossName));
			float health = float(chaser.GetProp(Prop_Data, "m_iHealth"));
			float maxHealth = chaser.MaxHealth;
			if (chaser.GetProp(Prop_Data, "m_takedamage") == DAMAGE_EVENTS_ONLY)
			{
				health = chaser.StunHealth;
				maxHealth = chaser.MaxStunHealth;
			}
			int displayHealth = RoundToFloor(health);
			if (displayHealth < 0)
			{
				displayHealth = 0;
			}
			int displayMaxHealth = RoundToFloor(maxHealth);
			Format(message, sizeof(message), "%s\n%s's current health is %i of %i", message, boxingBossName, displayHealth, displayMaxHealth);
		}
		for (int client = 1; client <= MaxClients; client++)
		{
			if (!IsValidClient(client) || IsFakeClient(client) || !IsPlayerAlive(client) || (g_PlayerEliminated[client] && !IsClientInGhostMode(client)) || DidClientEscape(client))
			{
				continue;
			}

			PrintCenterText(client, message);
		}
	}

	// Check if we can add some proxies.
	if (IsRoundPlaying() && !SF_IsRenevantMap() && !SF_IsSlaughterRunMap() && !SF_IsBoxingMap())
	{
		ArrayList proxyCandidates = new ArrayList();

		for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
		{
			if (NPCGetUniqueID(bossIndex) == -1)
			{
				continue;
			}

			if (!(NPCGetFlags(bossIndex) & SFF_PROXIES))
			{
				continue;
			}

			if (g_SlenderCopyMaster[bossIndex] != -1)
			{
				continue; // Copies cannot generate proxies.
			}

			if (GetGameTime() < g_SlenderTimeUntilNextProxy[bossIndex])
			{
				continue; // Proxy spawning hasn't cooled down yet.
			}

			int teleportTarget = EntRefToEntIndex(g_SlenderProxyTarget[bossIndex]);
			if (!teleportTarget || teleportTarget == INVALID_ENT_REFERENCE)
			{
				continue; // No teleport target.
			}

			int difficulty = GetLocalGlobalDifficulty(bossIndex);

			int maxProxies = g_SlenderMaxProxies[bossIndex][difficulty];
			if (g_InProxySurvivalRageMode)
			{
				maxProxies += 5;
			}

			int numActiveProxies = 0;

			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsValidClient(client) || !g_PlayerEliminated[client])
				{
					continue;
				}
				if (!g_PlayerProxy[client])
				{
					continue;
				}

				if (NPCGetFromUniqueID(g_PlayerProxyMaster[client]) == bossIndex)
				{
					numActiveProxies++;
				}
			}
			if (numActiveProxies >= maxProxies)
			{
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d has too many active proxies!", bossIndex);
				#endif
				continue;
			}

			float spawnChanceMin = NPCGetProxySpawnChanceMin(bossIndex, difficulty);
			float spawnChanceMax = NPCGetProxySpawnChanceMax(bossIndex, difficulty);
			float spawnChanceThreshold = NPCGetProxySpawnChanceThreshold(bossIndex, difficulty);

			float chance = GetRandomFloat(spawnChanceMin, spawnChanceMax);
			if (chance > spawnChanceThreshold && !g_InProxySurvivalRageMode)
			{
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d's chances weren't in his favor!", bossIndex);
				#endif
				continue;
			}

			int availableProxies = maxProxies - numActiveProxies;

			int spawnNumMin = NPCGetProxySpawnNumMin(bossIndex, difficulty);
			int spawnNumMax = NPCGetProxySpawnNumMax(bossIndex, difficulty);

			int spawnNum = 0;

			// Get a list of people we can transform into a good Proxy.
			proxyCandidates.Clear();

			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsValidClient(client) || !g_PlayerEliminated[client] || GetClientTeam(client) == TFTeam_Red)
				{
					continue;
				}
				if (g_PlayerProxy[client])
				{
					continue;
				}

				if (!g_PlayerPreferences[client].PlayerPreference_EnableProxySelection && !IsFakeClient(client))
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(client, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because of your preferences.", bossIndex);
					#endif
					continue;
				}

				if (!g_PlayerProxyAvailable[client])
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(client, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because of your cooldown.", bossIndex);
					#endif
					continue;
				}

				if (g_PlayerProxyAvailableInForce[client])
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(client, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because you're already being forced into a Proxy.", bossIndex);
					#endif
					continue;
				}

				if (!IsClientParticipating(client))
				{
					#if defined DEBUG
					SendDebugMessageToPlayer(client, DEBUG_BOSS_PROXIES, 0, "[PROXIES] You were rejected for being a proxy for boss %d because you're not participating.", bossIndex);
					#endif
					continue;
				}

				proxyCandidates.Push(client);
				spawnNum++;
			}

			if (spawnNum >= spawnNumMax)
			{
				spawnNum = GetRandomInt(spawnNumMin, spawnNumMax);
			}
			else if (spawnNum >= spawnNumMin)
			{
				spawnNum = GetRandomInt(spawnNumMin, spawnNum);
			}

			if (spawnNum <= 0)
			{
				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d had a set spawn number of 0!", bossIndex);
				#endif
				continue;
			}
			bool cooldown = false;
			// Randomize the array.
			SortADTArray(proxyCandidates, Sort_Random, Sort_Integer);

			float destinationPos[3];

			for (int num = 0; num < spawnNum && num < availableProxies; num++)
			{
				int client = proxyCandidates.Get(num);
				int spawnPointEnt = -1;

				if (!SpawnProxy(client, bossIndex, destinationPos, spawnPointEnt))
				{
					break;
				}
				cooldown = true;
				if (!g_PlayerPreferences[client].PlayerPreference_ProxyShowMessage)
				{
					ClientStartProxyForce(client, NPCGetUniqueID(bossIndex), destinationPos, spawnPointEnt);
				}
				else
				{
					if (!IsRoundEnding() && !IsRoundInWarmup() && !IsRoundInIntro())
					{
						DisplayProxyAskMenu(client, NPCGetUniqueID(bossIndex), destinationPos, spawnPointEnt);
					}
				}
			}
			// Set the cooldown time!
			if (cooldown)
			{
				float spawnCooldownMin = NPCGetProxySpawnCooldownMin(bossIndex, difficulty);
				float spawnCooldownMax = NPCGetProxySpawnCooldownMax(bossIndex, difficulty);

				g_SlenderTimeUntilNextProxy[bossIndex] = GetGameTime() + GetRandomFloat(spawnCooldownMin, spawnCooldownMax);
			}
			else
			{
				g_SlenderTimeUntilNextProxy[bossIndex] = GetGameTime() + GetRandomFloat(3.0, 4.0);
			}

			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0,"[PROXIES] Boss %d finished proxy process!", bossIndex);
			#endif
		}

		delete proxyCandidates;
	}

	Call_StartForward(g_OnGameFramePFwd);
	Call_Finish();

	return Plugin_Continue;
}

Action Hook_CommandBuild(int client, const char[] command, int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsEliminated)
	{
		if (player.HasEscaped && !player.IsInPvE && !player.IsInPvE)
		{
			return Plugin_Handled;
		}
	}
	else
	{
		if (g_EngineerBuildInBLUConVar.BoolValue)
		{
			if (!player.IsEliminated || player.IsInGhostMode)
			{
				return Plugin_Handled;
			}
		}
		else
		{
			if (!player.IsInPvP && !player.IsInPvE)
			{
				return Plugin_Handled;
			}
		}
	}

	return Plugin_Continue;
}

Action Hook_CommandTaunt(int client, const char[] command, int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	SF2_BasePlayer player = SF2_BasePlayer(client);
	if (!player.IsEliminated && GetRoundState() == SF2RoundState_Intro)
	{
		return Plugin_Handled;
	}
	if (!player.IsEliminated && player.StartPeeking())
	{
		return Plugin_Handled;
	}
	if (player.IsInGhostMode)
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

Action Hook_CommandDisguise(int client, const char[] command, int argc)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

static Action Timer_BossCountUpdate(Handle timer)
{
	if (timer != g_BossCountUpdateTimer)
	{
		return Plugin_Stop;
	}

	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int bossCount = NPCGetCount();
	int bossPreferredCount;

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
		if (Npc.UniqueID == -1 ||
			Npc.IsCopy ||
			(Npc.Flags & SFF_FAKE) || Npc.GetProfileData().IsPvEBoss)
		{
			continue;
		}

		bossPreferredCount++;

		int difficulty = GetLocalGlobalDifficulty(Npc.Index);
		SF2BossProfileData data;
		data = Npc.GetProfileData();
		if (!data.CopiesInfo.Enabled[GetLocalGlobalDifficulty(i)] || (Npc.Flags & SFF_NOCOPIES) != 0)
		{
			continue;
		}

		int minCount = data.CopiesInfo.MinCopies[difficulty];
		if (minCount > 0)
		{
			for (int i2 = 0; i2 < MAX_BOSSES; i2++)
			{
				if (i2 == Npc.Index)
				{
					continue;
				}
				if (minCount <= 0)
				{
					break;
				}
				SF2NPC_BaseNPC tempNPC = SF2NPC_BaseNPC(i2);
				if (tempNPC.UniqueID != -1)
				{
					if ((tempNPC.Flags & SFF_FAKE) != 0)
					{
						continue;
					}

					if (tempNPC.IsCopy && tempNPC.CopyMaster == Npc)
					{
						minCount--;
						continue;
					}
				}

				minCount--;
				bossPreferredCount++;
			}
		}
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) ||
			!IsPlayerAlive(i) ||
			g_PlayerEliminated[i] ||
			IsClientInGhostMode(i) ||
			IsClientInDeathCam(i) ||
			DidClientEscape(i))
		{
			continue;
		}

		// Check if we're near any bosses.
		int closest = -1;
		bool bossIsClose = false;
		float bestDist = SquareFloat(SF2_BOSS_PAGE_CALCULATION);

		for (int bossEnt = 0; bossEnt < MAX_BOSSES; bossEnt++)
		{
			SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossEnt);
			if (Npc.UniqueID == -1)
			{
				continue;
			}
			if (Npc.EntIndex == INVALID_ENT_REFERENCE)
			{
				continue;
			}
			if (Npc.Flags & SFF_FAKE)
			{
				continue;
			}
			SF2_BaseBoss boss = SF2_BaseBoss(Npc.EntIndex);
			if (boss.Target == CBaseEntity(i))
			{
				continue;
			}
			SF2_ChaserEntity chaser = SF2_ChaserEntity(Npc.EntIndex);
			if (chaser.IsValid() && chaser.AlertTriggerTarget == SF2_BasePlayer(i))
			{
				continue;
			}

			float myPos[3], bossPos[3];
			boss.GetAbsOrigin(bossPos);
			GetClientAbsOrigin(i, myPos);
			float dist = GetVectorDistance(bossPos, myPos, true);
			if (dist < bestDist)
			{
				closest = bossEnt;
				bestDist = dist;
				break;
			}
		}

		if (closest != -1)
		{
			bossIsClose = true;
		}

		for (int client = 1; client <= MaxClients; client++)
		{
			if (!IsValidClient(client) ||
				!IsPlayerAlive(client) ||
				g_PlayerEliminated[client] ||
				IsClientInGhostMode(client) ||
				IsClientInDeathCam(client) ||
				DidClientEscape(client) ||
				client == i)
			{
				continue;
			}

			bool busy = false;
			for (int bossEnt = 0; bossEnt < MAX_BOSSES; bossEnt++)
			{
				SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossEnt);
				if (Npc.UniqueID == -1)
				{
					continue;
				}
				if (Npc.Flags & SFF_FAKE)
				{
					continue;
				}
				if (Npc.GetProfileData().IsPvEBoss)
				{
					continue;
				}

				SF2_BaseBoss boss = SF2_BaseBoss(Npc.EntIndex);
				if (boss.IsValid() && boss.Target == CBaseEntity(client))
				{
					busy = true;
					break;
				}
			}

			if (!busy)
			{
				continue;
			}

			float dist = EntityDistanceFromEntity(i, client);
			if (dist < bestDist)
			{
				closest = client;
				bestDist = dist;
			}
		}

		if (!IsValidClient(closest) && !bossIsClose)
		{
			// No one's close to this dude? DUDE! WE NEED ANOTHER BOSS!
			bossPreferredCount++;
		}
	}

	int diff = bossCount - bossPreferredCount;
	if (diff != 0)
	{
		if (diff > 0)
		{
			int count = diff;
			// We need less bosses. Try and see if we can remove some.
			for (int i = 0; i < MAX_BOSSES; i++)
			{
				SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
				if (Npc.UniqueID == -1)
				{
					continue;
				}

				if (!Npc.IsCopy)
				{
					continue;
				}

				if (Npc.CanBeSeen(_, false))
				{
					continue;
				}

				if (Npc.Flags & SFF_FAKE)
				{
					continue;
				}

				if (Npc.GetProfileData().IsPvEBoss)
				{
					continue;
				}

				if (Npc.CanRemove)
				{
					SF2NPC_BaseNPC master = Npc.CopyMaster;
					SF2BossProfileData data;
					data = master.GetProfileData();
					int difficulty = GetLocalGlobalDifficulty(master.Index);
					if (data.CopiesInfo.MinCopies[difficulty] > 0)
					{
						int copyCount = 0;
						for (int i2 = 0; i2 < MAX_BOSSES; i2++)
						{
							if (i2 == master.Index)
							{
								continue;
							}
							SF2NPC_BaseNPC tempNPC = SF2NPC_BaseNPC(i2);
							if (tempNPC.UniqueID == -1)
							{
								continue;
							}

							if (Npc.Flags & SFF_FAKE)
							{
								continue;
							}

							if (tempNPC.CopyMaster != master)
							{
								continue;
							}
							copyCount++;
						}
						if (copyCount > data.CopiesInfo.MinCopies[difficulty])
						{
							Npc.Remove();
							count--;
						}
					}
					else
					{
						Npc.Remove();
						count--;
					}
				}

				if (count <= 0)
				{
					break;
				}
			}
		}
		else
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];

			int count = RoundToFloor(FloatAbs(float(diff)));
			// Add int bosses (copy of the first boss).
			for (int i = 0; i < MAX_BOSSES && count > 0; i++)
			{
				SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
				if (!Npc.IsValid())
				{
					continue;
				}

				if (Npc.IsCopy)
				{
					continue;
				}

				SF2BossProfileData data;
				data = Npc.GetProfileData();
				if (!data.CopiesInfo.Enabled[GetLocalGlobalDifficulty(i)] || (Npc.Flags & SFF_NOCOPIES) != 0)
				{
					continue;
				}

				if (data.IsPvEBoss)
				{
					continue;
				}

				if (Npc.Flags & SFF_FAKE)
				{
					continue;
				}

				// Get the number of copies I already have and see if I can have more copies.
				int copyCount;
				for (int i2 = 0; i2 < MAX_BOSSES; i2++)
				{
					SF2NPC_BaseNPC tempNpc = SF2NPC_BaseNPC(i2);
					if (tempNpc.UniqueID == -1)
					{
						continue;
					}
					if (tempNpc.CopyMaster != Npc)
					{
						continue;
					}

					copyCount++;
				}

				int difficulty = GetLocalGlobalDifficulty(Npc.Index);

				int copyDifficulty = Npc.GetMaxCopies(difficulty);
				if (copyCount >= copyDifficulty)
				{
					continue;
				}
				Npc.GetProfile(profile, sizeof(profile));
				AddProfile(profile, _, Npc);

				count--;
			}
		}
	}
	return Plugin_Continue;
}

void ReloadRestrictedWeapons()
{
	if (g_RestrictedWeaponsConfig != null)
	{
		delete g_RestrictedWeaponsConfig;
		g_RestrictedWeaponsConfig = null;
	}

	char buffer[PLATFORM_MAX_PATH];
	if (!g_UseAlternateConfigDirectoryConVar.BoolValue)
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS);
	}
	else
	{
		BuildPath(Path_SM, buffer, sizeof(buffer), FILE_RESTRICTEDWEAPONS_DATA);
	}
	KeyValues kv = new KeyValues("root");
	if (!FileToKeyValues(kv, buffer))
	{
		delete kv;
		LogError("Failed to load restricted weapons list! File not found!");
	}
	else
	{
		g_RestrictedWeaponsConfig = kv;
		LogSF2Message("Reloaded restricted weapons configuration file successfully");
	}
}

static Action Timer_RoundMessages(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	if (timer != g_RoundMessagesTimer)
	{
		return Plugin_Stop;
	}

	switch (g_RoundMessagesNum)
	{
		case 0:
		{
			CPrintToChatAll("{royalblue}== {violet}Slender Fortress{royalblue} coded by {hotpink}KitRifty & Kenzzer{royalblue}==\n== Modified by {deeppink}Mentrillum & The Gaben{royalblue}, current version {violet}%s{royalblue}==", PLUGIN_VERSION_DISPLAY);
		}
		case 1:
		{
			CPrintToChatAll("%t", "SF2 Ad Message 1");
		}
		case 2:
		{
			CPrintToChatAll("%t", "SF2 Ad Message 2");
		}
	}

	g_RoundMessagesNum++;
	if (g_RoundMessagesNum > 2)
	{
		g_RoundMessagesNum = 0;
	}

	return Plugin_Continue;
}

Action Timer_WelcomeMessage(Handle timer, any userid)
{
	SF2_BasePlayer client = SF2_BasePlayer(GetClientOfUserId(userid));
	if (!client.IsValid)
	{
		return Plugin_Stop;
	}

	CPrintToChat(client.index, "%T", "SF2 Welcome Message", client.index);

	return Plugin_Stop;
}

int GetMaxPlayersForRound()
{
	int override = g_MaxPlayersOverrideConVar.IntValue;
	if (override != -1)
	{
		return override;
	}
	return g_MaxPlayersConVar.IntValue;
}

void OnConVarChanged(Handle cvar, const char[] oldValue, const char[] intValue)
{
	if (cvar == g_DifficultyConVar)
	{
		switch (StringToInt(intValue))
		{
			case Difficulty_Hard:
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_HARD;
			}
			case Difficulty_Insane:
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_INSANE;
			}
			case Difficulty_Nightmare:
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_NIGHTMARE;
			}
			case Difficulty_Apollyon:
			{
				if (g_RestartSessionEnabled)
				{
					g_RoundDifficultyModifier = DIFFICULTYMODIFIER_RESTARTSESSION;
				}
				else
				{
					g_RoundDifficultyModifier = DIFFICULTYMODIFIER_APOLLYON;
				}
			}
			default:
			{
				g_RoundDifficultyModifier = DIFFICULTYMODIFIER_NORMAL;
			}
		}
		ChangeAllSlenderModels();
		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(npcIndex);
			if (!Npc.IsValid())
			{
				continue;
			}
			SF2NPC_BaseNPC masterNpc = Npc.CompanionMaster;
			if (masterNpc.IsValid() && g_SlenderAddCompanionsOnDifficulty[masterNpc.Index])
			{
				Npc.RemoveFromGame();
			}
		}
		for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(npcIndex);
			if (!Npc.IsValid())
			{
				continue;
			}
			if (g_SlenderAddCompanionsOnDifficulty[Npc.Index])
			{
				Npc.AddCompanions();
			}
		}
	}
	else if (cvar == g_MaxPlayersConVar || cvar == g_MaxPlayersOverrideConVar)
	{
		for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
		{
			CheckPlayerGroup(i);
		}
	}
	else if (cvar == g_PlayerShakeEnabledConVar)
	{
		g_IsPlayerShakeEnabled = StringToInt(intValue) != 0;
	}
	else if (cvar == g_PlayerViewbobHurtEnabledConVar)
	{
		g_PlayerViewbobHurtEnabled = StringToInt(intValue) != 0;
	}
	else if (cvar == g_PlayerViewbobSprintEnabledConVar)
	{
		g_PlayerViewbobSprintEnabled = StringToInt(intValue) != 0;
	}
	else if (cvar == g_AllChatConVar || SF_IsBoxingMap())
	{
		if (g_Enabled)
		{
			for (int i = 1; i <= MaxClients; i++)
			{
				SF2_BasePlayer client = SF2_BasePlayer(i);
				client.UpdateListeningFlags();
			}
		}
	}
	else if (cvar == g_IgnoreRoundWinConditionsConVar)
	{
		if (!StringToInt(intValue) && !IsRoundInWarmup() && !IsRoundEnding())
		{
			CheckRoundWinConditions();
		}
	}
	else if (cvar == g_RestartSessionConVar)
	{
		if (g_RestartSessionConVar.BoolValue)
		{
			ArrayList selectableBossesAdmin = GetSelectableAdminBossProfileList().Clone();
			ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
			PlayNightmareSound();
			SpecialRoundGameText("Its Restart Session time!", "leaderboard_streak");
			CPrintToChatAll("{royalblue}%t {default}Your thirst for blood continues? Very well, let the blood spill. Let the demons feed off your unfortunate soul... Difficulty set to {mediumslateblue}%t!", "SF2 Prefix", "SF2 Calamity Difficulty");
			g_RestartSessionEnabled = true;
			g_DifficultyConVar.SetInt(Difficulty_Apollyon);
			g_IgnoreRoundWinConditionsConVar.SetBool(true);
			g_IgnoreRedPlayerDeathSwapConVar.SetBool(true);
			g_BossChaseEndlesslyConVar.SetBool(true);
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_RESTARTSESSION;
			if (g_RoundGraceTimer != null)
			{
				TriggerTimer(g_RoundGraceTimer);
			}
			for (int bossCount = 0; bossCount < 10; bossCount++)
			{
				char buffer[SF2_MAX_PROFILE_NAME_LENGTH], bufferAdmin[SF2_MAX_PROFILE_NAME_LENGTH];
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
				if (selectableBossesAdmin.Length > 0)
				{
					selectableBossesAdmin.GetString(GetRandomInt(0, selectableBossesAdmin.Length - 1), bufferAdmin, sizeof(bufferAdmin));
					AddProfile(bufferAdmin);
				}
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				SF2_BasePlayer client = SF2_BasePlayer(i);
				if (!client.IsValid)
				{
					continue;
				}
				if (client.IsSourceTV)
				{
					continue;
				}
				if (!CheckCommandAccess(client.index, "sm_sf2_setplaystate", ADMFLAG_SLAY))
				{
					if (client.IsInGhostMode)
					{
						client.SetGhostState(false);
						client.Respawn();
						client.ChangeCondition(TFCond_StealthedUserBuffFade, true);
						g_LastCommandTime[client.index] = GetEngineTime()+0.5;
						CreateTimer(0.25, Timer_ForcePlayer, client.UserID, TIMER_FLAG_NO_MAPCHANGE);
					}
					else
					{
						client.SetPlayState(true);
					}
				}
				else
				{
					client.SetPlayState(false);
				}
			}
			if (IsRoundPlaying())
			{
				ArrayList spawnPoint = new ArrayList();
				float teleportPos[3];
				int ent = -1, spawnTeam = 0;
				while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
				{
					spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
					if (spawnTeam == TFTeam_Red)
					{
						spawnPoint.Push(ent);
					}

				}
				ent = -1;
				if (spawnPoint.Length > 0)
				{
					for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
					{
						ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));

						if (IsValidEntity(ent))
						{
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
							SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(npcIndex);
							if (!Npc.IsValid())
							{
								continue;
							}
							SpawnSlender(Npc, teleportPos);
						}
					}
				}
				delete spawnPoint;
			}
			delete selectableBosses;
			delete selectableBossesAdmin;
		}
		else
		{
			CPrintToChatAll("{royalblue}%t {default}You're done? Ok. Difficulty set to {darkgray}Apollyon.", "SF2 Prefix");
			g_RestartSessionEnabled = false;
			g_DifficultyConVar.SetInt(Difficulty_Apollyon);
			g_IgnoreRoundWinConditionsConVar.SetBool(false);
			g_IgnoreRedPlayerDeathSwapConVar.SetBool(false);
			g_BossChaseEndlesslyConVar.SetBool(false);
			g_RoundDifficultyModifier = DIFFICULTYMODIFIER_APOLLYON;
		}
	}
	else if (cvar == g_RaidMapConVar)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer client = SF2_BasePlayer(i);
			if (!client.IsValid)
			{
				continue;
			}
			if (client.IsEliminated && !client.IsInPvP)
			{
				ToggleWeaponCooldowns(client, true);
			}
			else
			{
				ToggleWeaponCooldowns(client, false);
			}
		}
	}
	else if (cvar == g_NightvisionEnabledConVar)
	{
		if (!IsInfiniteFlashlightEnabled())
		{
			g_NightVisionType = GetRandomInt(0, 2);
		}
		else
		{
			g_NightVisionType = 1;
		}
	}
	else if (cvar == g_EnableWallHaxConVar)
	{
		Call_StartForward(g_OnWallHaxDebugPFwd);
		Call_Finish();
	}
}

static void ToggleWeaponCooldowns(SF2_BasePlayer client, bool invert)
{
	for (int i = 0; i <= 5; i++)
	{
		int weapon = client.GetWeaponSlot(i);
		if (!IsValidEntity(weapon))
		{
			continue;
		}

		CBaseEntity weaponEnt = CBaseEntity(weapon);
		weaponEnt.SetPropFloat(Prop_Send, "m_flNextPrimaryAttack", invert ? 0.0 : 99999999.9);
		weaponEnt.SetPropFloat(Prop_Send, "m_flNextSecondaryAttack", invert ? 0.0 : 99999999.9);
	}
}

//	==========================================================
//	IN-GAME AND ENTITY HOOK FUNCTIONS
//	==========================================================

public void OnEntityCreated(int ent, const char[] classname)
{
	if (strcmp(classname, "obj_sentrygun", false) == 0 || strcmp(classname, "obj_dispenser", false) == 0 ||
		strcmp(classname, "obj_teleporter", false) == 0)
	{
		g_Buildings.Push(EntIndexToEntRef(ent));
	}

	if (strcmp(classname, "tank_boss", false) == 0)
	{
		g_WhitelistedEntities.Push(EntIndexToEntRef(ent));
	}

	if (strcmp(classname, "prop_physics", false) == 0 && GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
	{
		g_BreakableProps.Push(EntIndexToEntRef(ent));
	}

	if (strcmp(classname, "prop_dynamic", false) == 0 && GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
	{
		g_BreakableProps.Push(EntIndexToEntRef(ent));
	}

	if (strcmp(classname, "func_breakable", false) == 0 && GetEntProp(ent, Prop_Data, "m_iHealth") > 0)
	{
		g_BreakableProps.Push(EntIndexToEntRef(ent));
	}

	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidEntity(ent) || ent <= 0)
	{
		return;
	}

	if (strncmp(classname, "item_healthkit_", 15) == 0 && !SF_IsBoxingMap())
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
		RemoveEntity(ent);
	}

	Call_StartForward(g_OnEntityCreatedPFwd);
	Call_PushCell(CBaseEntity(ent));
	Call_PushString(classname);
	Call_Finish();
}

public void OnEntityDestroyed(int ent)
{
	if (!IsValidEntity(ent) || ent <= 0)
	{
		return;
	}

	int index = g_Buildings.FindValue(EntIndexToEntRef(ent));
	if (index != -1)
	{
		g_Buildings.Erase(index);
	}

	index = g_WhitelistedEntities.FindValue(EntIndexToEntRef(ent));
	if (index != -1)
	{
		g_WhitelistedEntities.Erase(index);
	}

	char classname[64];
	GetEntityClassname(ent, classname, sizeof(classname));

	Call_StartForward(g_OnEntityDestroyedPFwd);
	Call_PushCell(CBaseEntity(ent));
	Call_PushString(classname);
	Call_Finish();

	if (!g_Enabled)
	{
		return;
	}

	if (strcmp(classname, "light_dynamic", false) == 0)
	{
		AcceptEntityInput(ent, "TurnOff");

		int end = INVALID_ENT_REFERENCE;
		while ((end = FindEntityByClassname(end, "spotlight_end")) != -1)
		{
			if (GetEntPropEnt(end, Prop_Data, "m_hOwnerEntity") == ent)
			{
				RemoveEntity(end);
				break;
			}
		}
	}

	// For whatever reason something is refusing to remove a glow entity, this fixes that. I'd rather have this than having crashes.
	int glow = INVALID_ENT_REFERENCE;
	while ((glow = FindEntityByClassname(glow, "tf_glow")) != -1)
	{
		if (GetEntPropEnt(glow, Prop_Data, "m_hOwnerEntity") == ent ||
			GetEntPropEnt(glow, Prop_Send, "moveparent") == ent || GetEntPropEnt(glow, Prop_Send, "m_hTarget") == ent)
		{
			RemoveEntity(glow);
		}
	}
}

Action Hook_BlockUserMessage(UserMsg msg_id, Handle bf, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

Action Hook_TauntUserMessage(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer client = SF2_BasePlayer(msg.ReadByte());
	if (!client.IsEliminated)
	{
		return Plugin_Handled; //Don't allow a red player to play a taunt sound
	}
	if (client.IsProxy)
	{
		return Plugin_Handled; //Don't allow proxies to play a taunt sound
	}

	char tauntSound[PLATFORM_MAX_PATH];
	msg.ReadString(tauntSound, PLATFORM_MAX_PATH);

	DataPack dataTaunt = new DataPack();
	dataTaunt.WriteCell(client.index);
	dataTaunt.WriteString(tauntSound);

	RequestFrame(Frame_SendNewTauntMessage, dataTaunt); //Resend taunt sound to eliminated players only

	return Plugin_Handled; //Never ever allow a red player/proxy to hear taunt sound, we keep the playing area "tauntmusicless"
}

static void Frame_SendNewTauntMessage(DataPack dataMessage)
{
	int players[MAXTF2PLAYERS];
	int playersNum;
	for (int client = 1; client <= MaxClients; client++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(client);
		if (!player.IsValid)
		{
			continue;
		}
		if (player.IsProxy)
		{
			continue;
		}
		if (!player.IsEliminated && !player.HasEscaped)
		{
			continue;
		}
		players[playersNum++] = player.index;
	}

	dataMessage.Reset();

	BfWrite message = UserMessageToBfWrite(StartMessage("PlayerTauntSoundLoopStart", players, playersNum, USERMSG_RELIABLE | USERMSG_BLOCKHOOKS));
	message.WriteByte(dataMessage.ReadCell());
	char tauntSound[PLATFORM_MAX_PATH];
	dataMessage.ReadString(tauntSound, sizeof(tauntSound));
	message.WriteString(tauntSound);
	delete message;
	EndMessage();
	delete dataMessage;
}

Action Hook_BlockUserMessageEx(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

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

Action Hook_NormalSound(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer client = SF2_BasePlayer(entity);
	if (client.IsValid)
	{
		if (client.IsInGhostMode)
		{
			switch (channel)
			{
				case SNDCHAN_VOICE, SNDCHAN_WEAPON, SNDCHAN_ITEM, SNDCHAN_BODY:
				{
					return Plugin_Handled;
				}
			}
		}
		else if (!client.IsEliminated && !client.HasEscaped)
		{
			switch (channel)
			{
				case SNDCHAN_VOICE:
				{
					if (IsRoundInIntro())
					{
						return Plugin_Handled;
					}
				}
				case SNDCHAN_BODY:
				{
					if (!StrContains(sample, "player/footsteps", false) || StrContains(sample, "step", false) != -1)
					{
						if (g_PlayerViewbobSprintEnabledConVar.BoolValue && client.IsReallySprinting)
						{
							// Viewpunch.
							float punchVelStep[3];

							float velocity[3];
							GetEntPropVector(entity, Prop_Data, "m_vecAbsVelocity", velocity);
							float speed = GetVectorLength(velocity, true);

							punchVelStep[0] = (speed / SquareFloat(300.0));
							punchVelStep[1] = 0.0;
							punchVelStep[2] = 0.0;

							client.ViewPunch(punchVelStep);
						}
					}
				}
			}
		}
	}

	for (int i = 0; i < numClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(clients[i]);
		if (player.IsValid && player.IsAlive && !player.IsInGhostMode)
		{
			bool canHearSound = true;

			if (client.IsValid && client != player)
			{
				if (!player.IsEliminated)
				{
					if (g_IsSpecialRound && SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
					{
						if (!client.IsEliminated && !client.HasEscaped)
						{
							canHearSound = false;
						}
					}
				}
			}

			if (!canHearSound)
			{
				return Plugin_Stop;
			}
		}
	}

	return Plugin_Continue;
}

MRESReturn Hook_EntityShouldTransmit(int entity, DHookReturn returnHandle, DHookParam params)
{
	if (!g_Enabled)
	{
		return MRES_Ignored;
	}

	SF2_BasePlayer client = SF2_BasePlayer(entity);
	if (client.IsValid)
	{
		if (DoesEntityHaveGlow(client.index))
		{
			returnHandle.Value = FL_EDICT_ALWAYS; // Should always transmit, but our SetTransmit hook gets the final say.
			return MRES_Supercede;
		}
		else if (client.IsInGhostMode)
		{
			returnHandle.Value = FL_EDICT_DONTSEND;
			return MRES_Supercede;
		}
	}
	else
	{
		returnHandle.Value = FL_EDICT_ALWAYS; // Should always transmit, but our SetTransmit hook gets the final say.
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
static Action Hook_TriggerOnStartTouchEx(int trigger, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	Hook_TriggerOnStartTouch("OnStartTouch", trigger, other, 0.0);
	return Plugin_Continue;
}

static Action Hook_TriggerOnTouchEx(int trigger, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

static Action Hook_TriggerOnEndTouchEx(int trigger, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	Hook_TriggerOnEndTouch("OnEndTouch", trigger, other, 0.0);
	return Plugin_Continue;
}

static Action Hook_FuncOnStartTouchEx(int iFunc, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

static Action Hook_FuncOnTouchEx(int iFunc, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

static Action Hook_FuncOnEndTouchEx(int iFunc, int other)
{
	if (MaxClients >= other >= 1 && IsClientInGhostMode(other))
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

void Hook_TriggerOnStartTouch(const char[] output, int caller, int activator, float delay)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidEntity(caller))
	{
		return;
	}

	char name[64];
	GetEntPropString(caller, Prop_Data, "m_iName", name, sizeof(name));

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		LogSF2Message("[SF2 TRIGGERS LOG] Trigger %i (trigger_multiple) %s start touch by %i (%s)!", caller, name, activator, IsValidClient(activator) ? "Player" : "Entity");
	}
	#endif
	if (StrContains(name, "sf2_escape_trigger", false) == 0)
	{
		if (IsRoundInEscapeObjective() && !g_RestartSessionEnabled)
		{
			SF2_BasePlayer client = SF2_BasePlayer(activator);
			if (client.IsValid && client.IsAlive && !client.IsInDeathCam && !client.IsEliminated && !client.HasEscaped)
			{
				client.Escape();
				client.TeleportToEscapePoint();
			}
		}
	}

	PvP_OnTriggerStartTouch(caller, activator);
	PvE_OnTriggerStartTouch(caller, activator);
}

void Hook_TriggerOnEndTouch(const char[] output, int caller, int activator, float delay)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidEntity(caller))
	{
		return;
	}

	char name[64];
	GetEntPropString(caller, Prop_Data, "m_iName", name, sizeof(name));
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		LogSF2Message("[SF2 TRIGGERS LOG] Trigger %i (trigger_multiple) %s end touch by %i (%s)!", caller, name, activator, IsValidClient(activator) ? "Player" : "Entity");
	}
	#endif
}

void Hook_TriggerTeleportOnStartTouch(const char[] output, int teleporter, int activator, float delay)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidEntity(teleporter))
	{
		return;
	}

	if (SDKCall(g_SDKPassesTriggerFilters, teleporter, activator) == 0)
	{
		return;
	}

	Call_StartForward(g_OnEntityTeleportedPFwd);
	Call_PushCell(CBaseEntity(teleporter));
	Call_PushCell(CBaseEntity(activator));
	Call_Finish();
}

static Action Hook_PageOnTakeDamage(int page, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (g_RestartSessionEnabled)
	{
		return Plugin_Continue;
	}

	if (IsValidClient(attacker))
	{
		if (!g_PlayerEliminated[attacker])
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
	if (g_RoundState == SF2RoundState_Grace)
	{
		char noGracePage[PLATFORM_MAX_PATH];
		g_DifficultyNoGracePageConVar.GetString(noGracePage, sizeof(noGracePage));
		if (noGracePage[0])
		{
			char match[4];
			IntToString(g_DifficultyConVar.IntValue, match, sizeof(match));
			if (StrContains(noGracePage, match) != -1)
			{
				CPrintToChat(activator, "{royalblue}%t {default}%t", "SF2 Prefix", "SF2 Grace Period Page");
				return;
			}
		}
	}

	if (SF_SpecialRound(SPECIALROUND_ESCAPETICKETS))
	{
		ClientEscape(activator);
		TeleportClientToEscapePoint(activator);
	}

	if (SF_SpecialRound(SPECIALROUND_PAGEREWARDS) && !g_PlayerGettingPageReward[activator])
	{
		g_PlayerGettingPageReward[activator] = true;
		EmitRollSound(activator);
	}

	if (SF_SpecialRound(SPECIALROUND_BOSSROULETTE))
	{
		char buffer[SF2_MAX_PROFILE_NAME_LENGTH], bossName[SF2_MAX_NAME_LENGTH];
		if (NPCGetCount() < 63)
		{
			if (g_DifficultyConVar.IntValue < 4 || GetSelectableAdminBossProfileList().Length <= 0)
			{
				ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
					NPCGetBossName(_, bossName, sizeof(bossName), buffer);
					EmitSoundToAll(SR_SOUND_SELECT_BR, _, SNDCHAN_AUTO, _, _, 0.75);
					SpecialRoundGameText(bossName, "d_purgatory");
					CPrintToChatAll("{royalblue}%t {default}Next on the roulette: {valve}%s", "SF2 Prefix", bossName); //Minimized HUD
				}
				delete selectableBosses;
			}
			else
			{
				ArrayList selectableBosses = GetSelectableAdminBossProfileList().Clone();
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
					NPCGetBossName(_, bossName, sizeof(bossName), buffer);
					EmitSoundToAll(SR_SOUND_SELECT_BR, _, SNDCHAN_AUTO, _, _, 0.75);
					SpecialRoundGameText(bossName, "d_purgatory");
					CPrintToChatAll("{royalblue}%t {default}Next on the roulette: {valve}%s", "SF2 Prefix", bossName);
				}
				delete selectableBosses;
			}
		}
		else
		{
			SpecialRoundGameText("You got lucky, no boss can be added.", "cappoint_progressbar_blocked");
			CPrintToChatAll("{royalblue}%t {default}You got lucky, no boss can be added.", "SF2 Prefix");
		}
	}

	if (SF_SpecialRound(SPECIALROUND_THANATOPHOBIA) && g_PageMax <= 8)
	{
		for (int reds = 1; reds <= MaxClients; reds++)
		{
			if (!IsValidClient(reds) ||
				g_PlayerEliminated[reds] ||
				DidClientEscape(reds) ||
				GetClientTeam(reds) != TFTeam_Red ||
				!IsPlayerAlive(reds))
			{
				continue;
			}
			int maxHealth = SDKCall(g_SDKGetMaxHealth, reds);
			float healthToRecover = float(maxHealth) / 10.0;
			int healthToRecoverInt = RoundToNearest(healthToRecover) + GetEntProp(reds, Prop_Send, "m_iHealth");
			SetEntityHealth(reds, healthToRecoverInt);
		}
	}

	SetPageCount(g_PageCount + 1);
	g_PlayerPageCount[activator] += 1;
	// Play page collect sound
	char pageCollectSound[PLATFORM_MAX_PATH];
	int pageCollectionSoundPitch = g_PageSoundPitch;
	if (SF_SpecialRound(SPECIALROUND_DUCKS))
	{
		// Ducks!
		int randomSound = GetRandomInt(0, sizeof(g_PageCollectDuckSounds) - 1);
		strcopy(pageCollectSound, sizeof(pageCollectSound), g_PageCollectDuckSounds[randomSound]);
	}
	else
	{
		strcopy(pageCollectSound, sizeof(pageCollectSound), g_PageCollectSound);

		if (IsValidEntity(page))
		{
			int pageIndex = g_Pages.FindValue(EnsureEntRef(page));
			if (pageIndex != -1)
			{
				SF2PageEntityData pageData;
				g_Pages.GetArray(pageIndex, pageData, sizeof(pageData));

				if (pageData.CollectSound[0] != '\0')
				{
					strcopy(pageCollectSound, sizeof(pageCollectSound), pageData.CollectSound);
				}

				if (pageData.CollectSoundPitch > 0)
				{
					pageCollectionSoundPitch = pageData.CollectSoundPitch;
				}
			}
		}
	}

	if (!SF_SpecialRound(SPECIALROUND_SINGLEPLAYER))
	{
		EmitSoundToAll(pageCollectSound, activator, SNDCHAN_ITEM, SNDLEVEL_SCREAMING, _, _, pageCollectionSoundPitch);
	}
	else
	{
		EmitSoundToClient(activator, pageCollectSound, activator, SNDCHAN_ITEM, SNDLEVEL_SCREAMING, _, _, pageCollectionSoundPitch);
	}

	Call_StartForward(g_OnClientCollectPageFwd);
	Call_PushCell(page);
	Call_PushCell(activator);
	Call_Finish();

	// Gives points. Credit to the makers of VSH/FF2.
	Event event = CreateEvent("player_escort_score", true);
	event.SetInt("player", activator);
	event.SetInt("points", 1);
	event.Fire();

	int page2 = GetEntPropEnt(page, Prop_Send, "m_hOwnerEntity");
	if (page2 > MaxClients)
	{
		RemoveEntity(page2);
	}
	else
	{
		page2 = GetEntPropEnt(page, Prop_Send, "m_hEffectEntity");
		if (page2 > MaxClients)
		{
			RemoveEntity(page2);
		}
	}

	AcceptEntityInput(page, "FireUser1");
	AcceptEntityInput(page, "KillHierarchy");
}

static void EmitRollSound(int client)
{
	EmitSoundToClient(client, GENERIC_ROLL_TICK, client);
	g_PlayerPageRewardCycleCount[client] = 0;
	g_PlayerPageRewardCycleCooldown[client] = 0.0;
	g_PlayerPageRewardCycleTimer[client] = CreateTimer(0.1, Timer_RollTick, GetClientUserId(client), TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

static Action Timer_RollTick(Handle timer, any id)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(id);
	if (!IsValidClient(client) || timer != g_PlayerPageRewardCycleTimer[client] || g_PlayerEliminated[client])
	{
		return Plugin_Stop;
	}

	if (g_PlayerPageRewardCycleCooldown[client] >= GetGameTime())
	{
		return Plugin_Continue;
	}

	if (g_PlayerPageRewardCycleCount[client] <= 10)
	{
		g_PlayerPageRewardCycleCooldown[client] = 0.0;
	}
	else if (g_PlayerPageRewardCycleCount[client] > 10 && g_PlayerPageRewardCycleCount[client] < 14)
	{
		g_PlayerPageRewardCycleCooldown[client] = 0.2 + GetGameTime();
	}
	else if (g_PlayerPageRewardCycleCount[client] >= 14 && g_PlayerPageRewardCycleCount[client] < 15)
	{
		g_PlayerPageRewardCycleCooldown[client] = 0.4 + GetGameTime();
	}
	else if (g_PlayerPageRewardCycleCount[client] >= 16)
	{
		g_PlayerPageRewardCycleCount[client] = 0;
		g_PlayerPageRewardCycleCooldown[client] = 0.0;
		GiveRandomPageReward(client);
		return Plugin_Stop;
	}

	EmitSoundToClient(client, GENERIC_ROLL_TICK);
	EmitSoundToClient(client, GENERIC_ROLL_TICK);
	g_PlayerPageRewardCycleCount[client]++;
	return Plugin_Continue;
}

static void GiveRandomPageReward(int player)
{
	if (!g_Enabled)
	{
		return;
	}

	if (!IsValidClient(player) || g_PlayerEliminated[player])
	{
		return;
	}

	g_PlayerGettingPageReward[player] = false;

	int effect = GetRandomInt(0, 11);
	switch (effect)
	{
		case 1:
		{
			TF2_IgnitePlayer(player, player, 5.0);
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
			TF2_MakeBleed(player, player, 5.0);
			EmitSoundToClient(player, BLEED_ROLL, player, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
		}
		case 6:
		{
			int rareEffect = GetRandomInt(0, 30);
			switch (rareEffect)
			{
				case 6:
				{
					TF2_IgnitePlayer(player, player, 5.0);
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
					TF2_MakeBleed(player, player, 5.0);
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
					SF2_Player(player).Stamina = 0.0;
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
}

//	==========================================================
//	GENERIC client HOOKS AND FUNCTIONS
//	==========================================================

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsValidClient(client))
	{
		return Plugin_Continue;
	}

	SF2_BasePlayer player = SF2_BasePlayer(client);

	bool changed = false;

	// Check impulse (block spraying and built-in flashlight)
	switch (impulse)
	{
		case 100:
		{
			impulse = 0;
		}
		case 201, 202:
		{
			if (player.IsInGhostMode)
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
			if (!(player.LastButtons & button))
			{
				player.SetAFKTime();
				ClientOnButtonPress(player, button);
				if (button == IN_ATTACK2)
				{
					if (player.IsInPvP && !(buttons & IN_ATTACK))
					{
						if (player.Class == TFClass_Medic)
						{
							CBaseEntity weaponEnt = CBaseEntity(player.GetWeaponSlot(0));
							if (weaponEnt.IsValid())
							{
								char weaponClass[64];
								weaponEnt.GetClassname(weaponClass, sizeof(weaponClass));
								if (strcmp(weaponClass, "tf_weapon_crossbow") == 0)
								{
									int clip = weaponEnt.GetProp(Prop_Send, "m_iClip1");
									if (clip > 0)
									{
										buttons |= IN_ATTACK;
										player.LastButtons = buttons;
										buttons &= ~IN_ATTACK2;
										changed = true;

										RequestFrame(Frame_ClientHealArrow, player.index);

										EmitSoundToAll(")weapons/crusaders_crossbow_shoot.wav", player.index, SNDCHAN_WEAPON, SNDLEVEL_MINIBIKE); //Fix client's predictions.
									}
								}
							}
						}
					}
				}
			}
			if (button == IN_ATTACK2)
			{
				if (!player.IsEliminated)
				{
					player.LastButtons = buttons;
					CBaseEntity weaponActive = CBaseEntity(player.GetPropEnt(Prop_Send, "m_hActiveWeapon"));
					if (weaponActive.IsValid() && IsTauntWep(weaponActive.index))
					{
						buttons &= ~IN_ATTACK2; //Tough break update made players able to taunt with secondary attack. Block this feature.
						changed = true;
					}
				}
			}
		}
		else if ((player.LastButtons & button))
		{
			ClientOnButtonRelease(player, button);
		}
	}

	player.CheckAFKTime();

	if (!changed)
	{
		player.LastButtons = buttons;
	}
	return (changed) ? Plugin_Changed : Plugin_Continue;
}

public void OnClientCookiesCached(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	// Load our saved settings.
	char cookie[64];
	GetClientCookie(client, g_Cookie, cookie, sizeof(cookie));

	g_PlayerQueuePoints[client] = 0;

	g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn = false;
	g_PlayerPreferences[client].PlayerPreference_ShowHints = true;
	g_PlayerPreferences[client].PlayerPreference_MuteMode = 0;
	g_PlayerPreferences[client].PlayerPreference_FilmGrain = false;
	g_PlayerPreferences[client].PlayerPreference_EnableProxySelection = true;
	g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature = 6;
	g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState = 0;
	g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState = 0;
	g_PlayerPreferences[client].PlayerPreference_GroupOutline = true;
	g_PlayerPreferences[client].PlayerPreference_ProxyShowMessage = g_PlayerProxyAskConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection = true;
	g_PlayerPreferences[client].PlayerPreference_ViewBobbing = g_PlayerViewbobEnabledConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_LegacyHud = g_DefaultLegacyHudConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_MusicVolume = 1.0;

	if (cookie[0] != '\0')
	{
		char s2[16][64];
		int count = ExplodeString(cookie, " ; ", s2, 16, 64);

		if (count > 0)
		{
			g_PlayerQueuePoints[client] = StringToInt(s2[0]);
		}
		if (count > 1)
		{
			g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn = StringToInt(s2[1]) != 0;
		}
		if (count > 2)
		{
			g_PlayerPreferences[client].PlayerPreference_ShowHints = StringToInt(s2[2]) != 0;
		}
		if (count > 3)
		{
			g_PlayerPreferences[client].PlayerPreference_MuteMode = StringToInt(s2[3]);
		}
		if (count > 4)
		{
			g_PlayerPreferences[client].PlayerPreference_FilmGrain = StringToInt(s2[4]) != 0;
		}
		if (count > 5)
		{
			g_PlayerPreferences[client].PlayerPreference_EnableProxySelection = StringToInt(s2[5]) != 0;
		}
		if (count > 6)
		{
			g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature = StringToInt(s2[6]);
		}
		if (count > 7)
		{
			g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection = StringToInt(s2[7]) != 0;
		}
		if (count > 8)
		{
			g_PlayerPreferences[client].PlayerPreference_ProxyShowMessage = StringToInt(s2[8]) != 0;
		}
		if (count > 9)
		{
			g_PlayerPreferences[client].PlayerPreference_ViewBobbing = StringToInt(s2[9]) != 0;
		}
		if (count > 10)
		{
			g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState = StringToInt(s2[10]);
		}
		if (count > 11)
		{
			g_PlayerPreferences[client].PlayerPreference_GroupOutline = StringToInt(s2[11]) != 0;
		}
		if (count > 12)
		{
			g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState = StringToInt(s2[12]);
		}
		if (count > 13)
		{
			g_PlayerPreferences[client].PlayerPreference_LegacyHud = StringToInt(s2[13]) != 0;
		}
		if (count > 14)
		{
			g_PlayerPreferences[client].PlayerPreference_MusicVolume = StringToFloat(s2[14]) / 100.0;
		}
	}
}

public void OnClientPutInServer(int client)
{
	g_ClientInGame[client] = true;
	if (!g_Enabled)
	{
		if (g_LoadOutsideMapsConVar.BoolValue)
		{
			SDKHook(client, SDKHook_OnTakeDamage, Hook_ClientOnTakeDamage);
			Call_StartForward(g_OnPlayerPutInServerPFwd);
			Call_PushCell(SF2_BasePlayer(client));
			Call_Finish();
		}
		return;
	}

	if (IsClientSourceTV(client))
	{
		g_SourceTVUserID = GetClientUserId(client);
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START OnClientPutInServer(%d)", client);
	}
	#endif

	if (AreClientCookiesCached(client))
	{
		OnClientCookiesCached(client);
	}

	ClientSetPlayerGroup(client, -1);

	g_LastCommandTime[client] = GetEngineTime();

	g_PlayerEscaped[client] = false;
	g_PlayerEliminated[client] = true;
	g_PlayerChoseTeam[client] = false;
	g_PlayerPlayedSpecialRound[client] = true;
	g_PlayerPlayedNewBossRound[client] = true;

	g_PlayerPreferences[client].PlayerPreference_PvPAutoSpawn = false;
	g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight = false;

	g_PlayerPageCount[client] = 0;
	g_PlayerDesiredFOV[client] = 90;

	SDKHook(client, SDKHook_PreThink, Hook_ClientPreThink);
	SDKHook(client, SDKHook_PreThinkPost, Hook_OnFlashlightThink);
	SDKHook(client, SDKHook_SetTransmit, Hook_ClientSetTransmit);
	SDKHook(client, SDKHook_TraceAttack, Hook_PvPPlayerTraceAttack);
	SDKHook(client, SDKHook_OnTakeDamage, Hook_ClientOnTakeDamage);

	g_DHookWantsLagCompensationOnEntity.HookEntity(Hook_Pre, client, Hook_ClientWantsLagCompensationOnEntity);

	g_DHookShouldTransmit.HookEntity(Hook_Pre, client, Hook_EntityShouldTransmit);

	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			continue;
		}

		SetPlayerGroupInvitedPlayer(i, client, false);
		SetPlayerGroupInvitedPlayerCount(i, client, 0);
		SetPlayerGroupInvitedPlayerTime(i, client, 0.0);
	}

	ClientResetSlenderStats(client);
	ClientResetOverlay(client);
	ClientResetJumpScare(client);
	ClientUpdateListeningFlags(client);
	ClientResetScare(client);

	ClientSetScareBoostEndTime(client, -1.0);

	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		if (g_NpcChaseOnLookTarget[npcIndex] == null)
		{
			continue;
		}
		int foundClient = g_NpcChaseOnLookTarget[npcIndex].FindValue(client);
		if (foundClient != -1)
		{
			g_NpcChaseOnLookTarget[npcIndex].Erase(foundClient);
		}
	}

	if (!IsFakeClient(client))
	{
		// See if the player is using the projected flashlight.
		QueryClientConVar(client, "mat_supportflashlight", OnClientGetProjectedFlashlightSetting);

		// Get desired FOV.
		QueryClientConVar(client, "fov_desired", OnClientGetDesiredFOV);
	}

	AFK_SetTime(client);

	Call_StartForward(g_OnPlayerPutInServerPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_Finish();

	#if defined DEBUG
	g_PlayerDebugFlags[client] = 0;

	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END OnClientPutInServer(%d)", client);
	}
	#endif
}

static void OnClientGetProjectedFlashlightSetting(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (!IsValidClient(client))
	{
		return;
	}

	if (result != ConVarQuery_Okay)
	{
		LogError("Warning: Player %N failed to query for ConVar mat_supportflashlight", client);
		return;
	}

	if (StringToInt(cvarValue))
	{
		char auth[64];
		GetClientAuthId(client, AuthId_Engine, auth, sizeof(auth));

		g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight = true;
		LogSF2Message("Player %N (%s) has mat_supportflashlight enabled, projected flashlight will be used", client, auth);
	}
}

static void OnClientGetDesiredFOV(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (!IsValidClient(client))
	{
		return;
	}

	g_PlayerDesiredFOV[client] = StringToInt(cvarValue);
}

public void OnClientDisconnect(int client)
{
	if (!g_Enabled)
	{
		return;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START OnClientDisconnect(%d)", client);
	}
	#endif

	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, client);
	delete message;
	EndMessage();

	g_PlayerEscaped[client] = false;
	g_PlayerNoPoints[client] = false;
	g_AdminNoPoints[client] = false;
	g_AdminAllTalk[client] = false;
	g_PlayerIn1UpCondition[client] = false;
	g_PlayerDied1Up[client] = false;
	g_PlayerFullyDied1Up[client] = false;

	// Save and reset settings for the next client.
	ClientSaveCookies(client);
	ClientSetPlayerGroup(client, -1);

	// Reset variables.
	g_PlayerPreferences[client].PlayerPreference_ShowHints = true;
	g_PlayerPreferences[client].PlayerPreference_MuteMode = 0;
	g_PlayerPreferences[client].PlayerPreference_FilmGrain = false;
	g_PlayerPreferences[client].PlayerPreference_EnableProxySelection = true;
	g_PlayerPreferences[client].PlayerPreference_ProjectedFlashlight = false;
	g_PlayerPreferences[client].PlayerPreference_FlashlightTemperature = 6;
	g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState = 0;
	g_PlayerPreferences[client].PlayerPreference_GhostModeTeleportState = 0;
	g_PlayerPreferences[client].PlayerPreference_GroupOutline = true;
	g_PlayerPreferences[client].PlayerPreference_ProxyShowMessage = g_PlayerProxyAskConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_PvPSpawnProtection = true;
	g_PlayerPreferences[client].PlayerPreference_ViewBobbing = g_PlayerViewbobEnabledConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_LegacyHud = g_DefaultLegacyHudConVar.BoolValue;
	g_PlayerPreferences[client].PlayerPreference_MusicVolume = 1.0;

	// Reset any client functions that may be still active.
	ClientResetOverlay(client);

	if (SF_IsBoxingMap() && IsRoundInEscapeObjective())
	{
		CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);
	}

	if (!IsRoundInWarmup())
	{
		if (g_PlayerPlaying[client] && !g_PlayerEliminated[client])
		{
			if (!IsRoundPlaying())
			{
				// Force the next player in queue to take my place, if any.
				g_PlayerEliminated[client] = true;
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

	g_PlayerEliminated[client] = true;
	// Reset queue points global variable.
	g_PlayerQueuePoints[client] = 0;

	AFK_SetTime(client, false);

	Call_StartForward(g_OnPlayerDisconnectedPFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_Finish();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END OnClientDisconnect(%d)", client);
	}
	#endif
}

public void OnClientDisconnect_Post(int client)
{
	g_PlayerLastButtons[client] = 0;
	g_ClientInGame[client] = false;
}

public void TF2_OnWaitingForPlayersStart()
{
	g_RoundWaitingForPlayers = true;
}

public void TF2_OnWaitingForPlayersEnd()
{
	g_RoundWaitingForPlayers = false;
}

SF2RoundState GetRoundState()
{
	return g_RoundState;
}

void SetRoundTimerPaused(bool paused)
{
	g_RoundTimerPaused = paused;
}

void SetRoundTime(int currentTime)
{
	int oldRoundTime = g_RoundTime;
	if (currentTime == oldRoundTime)
	{
		return;
	}

	g_RoundTime = currentTime;

	switch (GetRoundState())
	{
		case SF2RoundState_Escape:
		{
			if (SF_IsSurvivalMap() && currentTime <= g_TimeEscape && oldRoundTime > g_TimeEscape && g_GamerulesEntity.IsValid())
			{
				g_GamerulesEntity.FireOutput("OnSurvivalComplete");
			}
		}
	}
}

void SetRoundState(SF2RoundState roundState)
{
	if (g_RoundState == roundState)
	{
		return;
	}

	PrintToServer("SetRoundState(%d)", roundState);

	SF2RoundState oldRoundState = GetRoundState();
	g_RoundState = roundState;

	//Tutorial_OnRoundStateChange(oldRoundState, g_RoundState);

	// Cleanup from old roundstate if needed.
	switch (oldRoundState)
	{
		case SF2RoundState_Waiting:
		{
		}
		case SF2RoundState_Intro:
		{
			g_RoundIntroTimer = null;

			// Enable movement on players.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || g_PlayerEliminated[i])
				{
					continue;
				}
				SetEntityFlags(i, GetEntityFlags(i) & ~FL_FROZEN);
			}

			// Fade in.
			float fadeTime = g_RoundIntroFadeDuration;
			int fadeFlags = SF_FADE_IN | FFADE_PURGE;

			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || g_PlayerEliminated[i])
				{
					continue;
				}
				UTIL_ScreenFade(i, FixedUnsigned16(fadeTime, 1 << 12), 0, fadeFlags, g_RoundIntroFadeColor[0], g_RoundIntroFadeColor[1], g_RoundIntroFadeColor[2], g_RoundIntroFadeColor[3]);
			}
		}
		case SF2RoundState_Grace:
		{
			g_RoundGraceTimer = null;

			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsClientParticipating(client))
				{
					g_PlayerEliminated[client] = true;
				}

				if (IsValidClient(client))
				{
					TF2Attrib_RemoveByDefIndex(client, 10);

					if (IsClientParticipating(client) && GetClientTeam(client) == TFTeam_Blue && g_PlayerPreferences[client].PlayerPreference_GhostModeToggleState == 1)
					{
						CreateTimer(0.25, Timer_ToggleGhostModeCommand, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}

			if (g_RestartSessionEnabled)
			{
				ArrayList spawnPoint = new ArrayList();
				float teleportPos[3];
				int ent = -1, spawnTeam = 0;
				while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
				{
					spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
					if (spawnTeam == TFTeam_Red)
					{
						spawnPoint.Push(ent);
					}

				}
				ent = -1;
				if (spawnPoint.Length > 0)
				{
					for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
					{
						ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));

						if (IsValidEntity(ent))
						{
							GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
							SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(npcIndex);
							if (!Npc.IsValid())
							{
								continue;
							}
							Npc.Spawn(teleportPos);
						}
					}
				}
				delete spawnPoint;
			}

			CPrintToChatAll("{dodgerblue}%t", "SF2 Grace Period End");
		}
		case SF2RoundState_Active:
		{
			g_RoundGraceTimer = null;
			g_RoundTimer = null;
			g_PlayersAreCritted = false;
			g_PlayersAreMiniCritted = false;
			g_RoundTimeMessage = 0.0;
		}
		case SF2RoundState_Escape:
		{
			g_RoundTimer = null;
		}
		case SF2RoundState_Outro:
		{
		}
	}

	switch (g_RoundState)
	{
		case SF2RoundState_Waiting:
		{
		}
		case SF2RoundState_Intro:
		{
			g_RoundIntroTimer = null;
			g_RoundTimeMessage = 0.0;
			g_InProxySurvivalRageMode = false;
			g_RenevantWaveTimer = null;
			g_RenevantMultiEffect = false;
			g_RenevantWallHax = false;
			g_RenevantBeaconEffect = false;
			g_Renevant90sEffect = false;
			g_RenevantMarkForDeath = false;
			g_RenevantBossesChaseEndlessly = false;
			g_DifficultyConVar.SetInt(Difficulty_Normal);
			if (g_RestartSessionConVar.BoolValue)
			{
				g_RestartSessionEnabled = false;
				g_RestartSessionConVar.SetBool(false);
			}
			StartIntroTextSequence();

			// Gather data on the intro parameters set by the map.
			float holdTime = g_RoundIntroFadeHoldTime;
			g_RoundIntroTimer = CreateTimer(holdTime, Timer_ActivateRoundFromIntro, _, TIMER_FLAG_NO_MAPCHANGE);

			// Trigger any intro logic entities, if any.
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
			{
				char name[64];
				GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
				if (strcmp(name, "sf2_intro_relay", false) == 0)
				{
					AcceptEntityInput(ent, "Trigger");
					break;
				}
			}
		}
		case SF2RoundState_Grace:
		{
			if (!IsInfiniteFlashlightEnabled())
			{
				g_NightVisionType = GetRandomInt(0, 2);
			}
			else
			{
				g_NightVisionType = 1;
			}

			// Start the grace period timer.
			g_RoundGraceTimer = CreateTimer(g_GraceTimeConVar.FloatValue, Timer_RoundGrace, _, TIMER_FLAG_NO_MAPCHANGE);

			CreateTimer(2.0, Timer_RoundStart, _, TIMER_FLAG_NO_MAPCHANGE);

			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || g_PlayerEliminated[i])
				{
					continue;
				}

				TF2Attrib_SetByDefIndex(i, 10, 7.0);
			}
		}
		case SF2RoundState_Active:
		{
			if (SF_IsRenevantMap())
			{
				NPCRemoveAll();
			}
			// Initialize the main round timer.
			if (g_RoundTimeLimit > 0)
			{
				// Set round time.
				SetRoundTime(g_RoundTimeLimit);
				g_RoundTimer = CreateTimer(1.0, Timer_RoundTime, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				// Infinite round time.
				g_RoundTimer = null;
			}
		}
		case SF2RoundState_Escape:
		{
			// Initialize the escape timer, if needed.
			if (g_RoundEscapeTimeLimit > 0)
			{
				SetRoundTime(g_RoundEscapeTimeLimit);
				g_RoundTimer = CreateTimer(1.0, Timer_RoundTimeEscape, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				g_RoundTimer = null;
			}

			char name[32];
			int ent = -1;
			while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
			{
				GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
				if (!SF_IsBoxingMap())
				{
					if (strcmp(name, "sf2_logic_escape", false) == 0)
					{
						AcceptEntityInput(ent, "FireUser1");
						break;
					}
				}
				else
				{
					if (strcmp(name, "sf2_logic_escape", false) == 0)
					{
						AcceptEntityInput(ent, "FireUser1");
						break;
					}
				}
			}
			if (SF_IsBoxingMap())
			{
				CPrintToChatAll("%t", "SF2 Boxing Initiate");
				CreateTimer(0.2, Timer_CheckAlivePlayers, _, TIMER_FLAG_NO_MAPCHANGE);

				for (int bossEnt = 0; bossEnt < MAX_BOSSES; bossEnt++)
				{
					SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossEnt);
					if (!Npc.IsValid())
					{
						continue;
					}
					if (NPCChaserIsBoxingBoss(Npc.Index) && !Npc.GetProfileData().IsPvEBoss)
					{
						g_SlenderBoxingBossCount++;
					}
				}
			}
			else if (SF_IsRenevantMap())
			{
				Renevant_SetWave(1, true);
			}
		}
		case SF2RoundState_Outro:
		{
			if (!g_RoundHasEscapeObjective)
			{
				// Teleport winning players to the escape point.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i))
					{
						continue;
					}

					if (!g_PlayerEliminated[i])
					{
						TeleportClientToEscapePoint(i);
					}
				}
			}

			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i))
				{
					continue;
				}

				if (IsClientInGhostMode(i))
				{
					// Take the player out of ghost mode.
					ClientSetGhostModeState(i, false);
					TF2_RespawnPlayer(i);
				}
				else if (g_PlayerProxy[i])
				{
					TF2_RespawnPlayer(i);
				}

				if (!g_PlayerEliminated[i])
				{
					// Give them back all their weapons so they can beat the crap out of the other team.
					TF2_RegeneratePlayer(i);
				}

				ClientUpdateListeningFlags(i);
			}
		}
	}

	SF2MapEntity_OnRoundStateChanged(roundState, oldRoundState);

	Call_StartForward(g_OnRoundStateChangeFwd);
	Call_PushCell(oldRoundState);
	Call_PushCell(g_RoundState);
	Call_Finish();
}

bool IsRoundPlaying()
{
	return (GetRoundState() == SF2RoundState_Active || GetRoundState() == SF2RoundState_Escape);
}

bool IsRoundInEscapeObjective()
{
	return GetRoundState() == SF2RoundState_Escape;
}

bool IsRoundInWarmup()
{
	return GetRoundState() == SF2RoundState_Waiting;
}

bool IsRoundInIntro()
{
	return GetRoundState() == SF2RoundState_Intro;
}

bool IsRoundEnding()
{
	return GetRoundState() == SF2RoundState_Outro;
}

bool IsClientParticipating(int client)
{
	if (!IsValidClient(client))
	{
		return false;
	}

	if (GetEntProp(client, Prop_Send, "m_bIsCoaching") != 0)
	{
		// Who would coach in this game?
		return false;
	}

	int team = GetClientTeam(client);

	switch (team)
	{
		case 0, 1:
		{
			return false;
		}
	}

	if (TF2_GetPlayerClass(client) == TFClass_Unknown)
	{
		// Player hasn't chosen a class? What.
		return false;
	}

	return true;
}

ArrayList GetQueueList()
{
	ArrayList array = new ArrayList(3);
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientParticipating(i))
		{
			continue;
		}
		if (IsPlayerGroupActive(ClientGetPlayerGroup(i)))
		{
			continue;
		}

		int index = array.Push(i);
		array.Set(index, g_PlayerQueuePoints[i], 1);
		array.Set(index, false, 2);
	}

	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			continue;
		}
		int index = array.Push(i);
		array.Set(index, GetPlayerGroupQueuePoints(i), 1);
		array.Set(index, true, 2);
	}

	if (array.Length > 0)
	{
		array.SortCustom(SortQueueList);
	}
	return array;
}

void SetClientPlayState(int client, bool state, bool enablePlay = true, bool queue = true)
{
	if (g_PlayerEliminated[client] == !state)
	{
		return;
	}

	if (g_PlayerProxy[client])
	{
		return;
	}

	Call_StartForward(g_OnPlayerChangePlayStatePFwd);
	Call_PushCell(SF2_BasePlayer(client));
	Call_PushCell(state);
	Call_PushCell(queue);
	Call_Finish();

	Handle message = StartMessageAll("PlayerTauntSoundLoopEnd", USERMSG_RELIABLE);
	BfWriteByte(message, client);
	delete message;
	EndMessage();

	if (state)
	{
		g_PlayerCalledForNightmare[client] = false;
		g_PlayerEliminated[client] = false;
		g_PlayerPlaying[client] = enablePlay;
		g_PlayerSwitchBlueTimer[client] = null;

		ClientSetGhostModeState(client, false);

		PvP_SetPlayerPvPState(client, false, false, false);
		PvE_SetPlayerPvEState(client, false, false);

		if (g_IsSpecialRound)
		{
			SetClientPlaySpecialRoundState(client, true);
		}

		if (g_NewBossRound)
		{
			SetClientPlayNewBossRoundState(client, true);
		}

		if (TF2_GetPlayerClass(client) == TFClass_Unknown)
		{
			// Player hasn't chosen a class for some reason. Choose one for him.
			TF2_SetPlayerClass(client, view_as<TFClassType>(GetRandomInt(1, 9)), true, true);
		}

		ChangeClientTeamNoSuicide(client, TFTeam_Red);
	}
	else
	{
		g_PlayerEliminated[client] = true;
		g_PlayerPlaying[client] = false;

		ChangeClientTeamNoSuicide(client, TFTeam_Blue);
	}
}
/*
bool DidClientPlayNewBossRound(int client)
{
	return g_PlayerPlayedNewBossRound[client];
}
*/
void SetClientPlayNewBossRoundState(int client, bool state)
{
	g_PlayerPlayedNewBossRound[client] = state;
}
/*
bool DidClientPlaySpecialRound(int client)
{
	return g_PlayerPlayedNewBossRound[client];
}
*/
void SetClientPlaySpecialRoundState(int client, bool state)
{
	g_PlayerPlayedSpecialRound[client] = state;
}

void TeleportClientToEscapePoint(int client)
{
	if (!IsValidClient(client))
	{
		return;
	}

	ArrayList spawnPoints = new ArrayList();

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_player_escapespawn")) != -1)
	{
		SF2PlayerEscapeSpawnEntity spawnPoint = SF2PlayerEscapeSpawnEntity(ent);
		if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
		{
			continue;
		}

		spawnPoints.Push(ent);
	}

	if (spawnPoints.Length > 0)
	{
		ent = spawnPoints.Get(GetRandomInt(0, spawnPoints.Length - 1));
	}
	else
	{
		ent = EntRefToEntIndex(g_RoundEscapePointEntity);
	}

	delete spawnPoints;

	if (ent && ent != INVALID_ENT_REFERENCE)
	{
		SF2PlayerEscapeSpawnEntity spawnPoint = SF2PlayerEscapeSpawnEntity(ent);

		float pos[3], ang[3];
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);
		GetEntPropVector(ent, Prop_Data, "m_angAbsRotation", ang);

		TeleportEntity(client, pos, ang, NULL_VECTOR);

		if (spawnPoint.IsValid())
		{
			spawnPoint.FireOutput("OnSpawn", client);
		}
		else
		{
			AcceptEntityInput(ent, "FireUser1", client);
		}
	}
}

void ForceInNextPlayersInQueue(int amount, bool showMessage = false)
{
	// Grab the next person in line, or the next group in line if space allows.
	int amountLeft = amount;
	ArrayList players = new ArrayList();
	ArrayList array = GetQueueList();

	for (int i = 0, size = array.Length; i < size && amountLeft > 0; i++)
	{
		if (!array.Get(i, 2))
		{
			int client = array.Get(i);
			if (g_PlayerPlaying[client] || !g_PlayerEliminated[client] || !IsClientParticipating(client) || g_AdminNoPoints[client])
			{
				continue;
			}

			Action action;
			Call_StartForward(g_OnClientEnterGameFwd);
			Call_PushCell(client);
			Call_Finish(action);
			if (action >= Plugin_Handled)
			{
				continue;
			}

			players.Push(client);
			amountLeft -= 1;
		}
		else
		{
			int groupIndex = array.Get(i);
			if (!IsPlayerGroupActive(groupIndex))
			{
				continue;
			}

			int memberCount = GetPlayerGroupMemberCount(groupIndex);
			if (memberCount <= amountLeft)
			{
				Action action;
				Call_StartForward(g_OnGroupEnterGameFwd);
				Call_PushCell(groupIndex);
				Call_Finish(action);
				if (action >= Plugin_Handled)
				{
					continue;
				}

				for (int client = 1; client <= MaxClients; client++)
				{
					if (!IsValidClient(client) || g_PlayerPlaying[client] || !g_PlayerEliminated[client] || !IsClientParticipating(client))
					{
						continue;
					}
					if (ClientGetPlayerGroup(client) == groupIndex)
					{
						players.Push(client);
					}
				}

				SetPlayerGroupPlaying(groupIndex, true);

				amountLeft -= memberCount;
			}
		}
	}

	delete array;

	for (int i = 0, size = players.Length; i < size; i++)
	{
		int client = players.Get(i);
		ClientSetQueuePoints(client, 0);
		if (IsClientInGhostMode(client))
		{
			ClientSetGhostModeState(client, false);
			TF2_RespawnPlayer(client);
			TF2_RemoveCondition(client, TFCond_StealthedUserBuffFade);
			g_LastCommandTime[client] = GetEngineTime()+0.5;
			CreateTimer(0.25, Timer_ForcePlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			SetClientPlayState(client, true);
		}

		if (showMessage)
		{
			CPrintToChat(client, "%T", "SF2 Force Play", client);
		}
	}

	delete players;
}

static int SortQueueList(int index1, int index2, Handle arrayHandle, Handle hndl)
{
	ArrayList array = view_as<ArrayList>(arrayHandle);

	bool disabled = g_PlayerNoPoints[array.Get(index1, 0)];
	if (disabled != g_PlayerNoPoints[array.Get(index2, 0)])
	{
		return disabled ? 1 : -1;
	}

	int queuePoints1 = array.Get(index1, 1);
	int queuePoints2 = array.Get(index2, 1);

	if (queuePoints1 > queuePoints2)
	{
		return -1;
	}
	else if (queuePoints1 == queuePoints2)
	{
		return 0;
	}
	return 1;
}

//	==========================================================
//	GENERIC PAGE/BOSS HOOKS AND FUNCTIONS
//	==========================================================

static Action Hook_SlenderObjectSetTransmit(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsPlayerAlive(other) || IsClientInDeathCam(other))
	{
		if (!IsValidEdict(GetEntPropEnt(other, Prop_Send, "m_hObserverTarget")))
		{
			return Plugin_Handled;
		}
	}
	if (IsClientInGhostMode(other) || g_PlayerProxy[other])
	{
		return Plugin_Handled;
	}
	if (IsValidClient(other))
	{
		if (ClientGetDistanceFromEntity(other, ent) >= SquareFloat(320.0) || GetClientTeam(other) == TFTeam_Spectator)
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

static Action Hook_SlenderObjectSetTransmitEx(int ent, int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}

	if (!IsPlayerAlive(other) || IsClientInDeathCam(other))
	{
		if (!IsValidEdict(GetEntPropEnt(other, Prop_Send, "m_hObserverTarget")))
		{
			return Plugin_Handled;
		}
	}
	if (IsClientInGhostMode(other) || g_PlayerProxy[other])
	{
		return Plugin_Handled;
	}
	if (IsValidClient(other))
	{
		if (ClientGetDistanceFromEntity(other, ent) <= SquareFloat(320.0) || GetClientTeam(other) == TFTeam_Spectator)
		{
			return Plugin_Handled;
		}
	}

	return Plugin_Continue;
}

void SlenderOnClientStressUpdate(int client)
{
	int difficulty = g_DifficultyConVar.IntValue;
	float gameTime = GetGameTime();

	float stress = g_PlayerStressAmount[client];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];

	for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossIndex);
		if (Npc.UniqueID == -1)
		{
			continue;
		}

		int bossFlags = Npc.Flags;
		if ((bossFlags & SFF_MARKEDASFAKE) != 0)
		{
			continue;
		}
		if ((bossFlags & SFF_NOTELEPORT) != 0 && (bossFlags & SFF_PROXIES) != 0 && !Npc.IsCopy)
		{
			// Go get a proxy target anyways
			ArrayList proxyArray = new ArrayList();
			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && !g_PlayerEliminated[i] && !IsClientInGhostMode(i) && !DidClientEscape(i))
				{
					proxyArray.Push(i);
				}
			}

			if (proxyArray.Length > 0)
			{
				int proxyClient = proxyArray.Get(GetRandomInt(0, proxyArray.Length - 1));
				if (IsValidClient(proxyClient) && !g_PlayerEliminated[proxyClient])
				{
					g_SlenderProxyTarget[Npc.Index] = EntIndexToEntRef(proxyClient);
				}
			}
			delete proxyArray;
			continue;
		}

		Npc.GetProfile(profile, sizeof(profile));

		int teleportTarget = EntRefToEntIndex(g_SlenderProxyTarget[Npc.Index]);
		if (teleportTarget && teleportTarget != INVALID_ENT_REFERENCE)
		{
			if (g_PlayerEliminated[teleportTarget] || DidClientEscape(teleportTarget))
			{
				g_SlenderProxyTarget[Npc.Index] = INVALID_ENT_REFERENCE;
			}
		}

		teleportTarget = EntRefToEntIndex(g_SlenderTeleportTarget[Npc.Index]);
		if (teleportTarget && teleportTarget != INVALID_ENT_REFERENCE && !g_PlayerIsExitCamping[teleportTarget])
		{
			if (g_PlayerEliminated[teleportTarget] || DidClientEscape(teleportTarget) ||
				(!SF_BossesChaseEndlessly() && !SF_IsRenevantMap() && !SF_IsSurvivalMap() && !g_SlenderTeleportIgnoreChases[Npc.Index] && stress >= g_SlenderTeleportMaxTargetStress[bossIndex]) ||
				(g_SlenderTeleportMaxTargetTime[Npc.Index] > 0.0 && gameTime >= g_SlenderTeleportMaxTargetTime[Npc.Index]))
			{
				// Queue for a new target and mark the old target in the rest period.
				float restPeriod = Npc.GetTeleportRestPeriod(difficulty);
				restPeriod = (restPeriod * GetRandomFloat(0.92, 1.08)) / (g_RoundDifficultyModifier);

				g_SlenderTeleportTarget[Npc.Index] = INVALID_ENT_REFERENCE;
				g_SlenderTeleportPlayersRestTime[Npc.Index][teleportTarget] = gameTime + restPeriod;
				g_SlenderTeleportMaxTargetStress[Npc.Index] = 9999.0;
				g_SlenderTeleportMaxTargetTime[Npc.Index] = -1.0;
				g_SlenderTeleportTargetTime[Npc.Index] = -1.0;

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: lost target, putting at rest period", Npc.Index);
				#endif
			}
		}
		else if (IsRoundPlaying())
		{
			int preferredTeleportTarget = INVALID_ENT_REFERENCE;

			float targetStressMin = Npc.GetTeleportStressMin(difficulty);
			float targetStressMax = Npc.GetTeleportStressMax(difficulty);

			float targetStress = targetStressMax - ((targetStressMax - targetStressMin) / (g_RoundDifficultyModifier));

			float preferredTeleportTargetStress = targetStress;

			ArrayList raidArrays = new ArrayList();

			for (int i = 1; i <= MaxClients; i++)
			{
				if (IsValidClient(i) && IsPlayerAlive(i) && !g_PlayerEliminated[i] && !IsClientInGhostMode(i) && !DidClientEscape(i))
				{
					if (g_PlayerIsExitCamping[i])
					{
						if (IsValidClient(teleportTarget) && !g_PlayerIsExitCamping[teleportTarget])
						{
							preferredTeleportTarget = i;
							delete raidArrays;
							break;
						}
					}
					if (g_PlayerStressAmount[i] < preferredTeleportTargetStress || g_RestartSessionEnabled || g_SlenderTeleportIgnoreChases[Npc.Index])
					{
						if (g_SlenderTeleportPlayersRestTime[Npc.Index][i] <= gameTime)
						{
							preferredTeleportTargetStress = g_PlayerStressAmount[i];
							raidArrays.Push(i);
						}
					}
				}
			}

			if (raidArrays != null && raidArrays.Length > 0)
			{
				int raidClient = raidArrays.Get(GetRandomInt(0, raidArrays.Length - 1));
				if (IsValidClient(raidClient) && !g_PlayerEliminated[raidClient] && !DidClientEscape(raidClient) && IsPlayerAlive(raidClient))
				{
					g_SlenderProxyTarget[Npc.Index] = EntIndexToEntRef(raidClient);
					preferredTeleportTarget = raidClient;
				}
			}

			if (raidArrays != null)
			{
				delete raidArrays;
			}

			if (IsValidClient(preferredTeleportTarget))
			{
				// Set our preferred target to the new guy.
				g_SlenderTeleportTarget[Npc.Index] = EntIndexToEntRef(preferredTeleportTarget);
				g_SlenderTeleportPlayersRestTime[Npc.Index][preferredTeleportTarget] = -1.0;
				g_SlenderTeleportTargetTime[Npc.Index] = gameTime;
				g_SlenderTeleportMaxTargetStress[Npc.Index] = targetStress;

				teleportTarget = preferredTeleportTarget;

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: got new target %N", Npc.Index, preferredTeleportTarget);
				#endif
			}
		}
	}
}

void GetPageEntities(ArrayList array)
{
	for (int i = g_Pages.Length - 1; i >= 0; i--)
	{
		int pageEntIndex = EntRefToEntIndex(g_Pages.Get(i, SF2PageEntityData::EntRef));
		if (pageEntIndex && pageEntIndex != INVALID_ENT_REFERENCE)
		{
			array.Push(pageEntIndex);
		}
	}
}

static int GetPageMusicRanges()
{
	g_PageMusicRanges.Clear();

	char name[64];

	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));

		if (name[0] != '\0' && !StrContains(name, "sf2_page_music_", false))
		{
			ReplaceString(name, sizeof(name), "sf2_page_music_", "", false);

			char pageRanges[2][32];
			ExplodeString(name, "-", pageRanges, 2, 32);

			int index = g_PageMusicRanges.Push(EntIndexToEntRef(ent));
			if (index != -1)
			{
				int min = StringToInt(pageRanges[0]);
				int max = StringToInt(pageRanges[1]);

				#if defined DEBUG
				DebugMessage("Page range found: entity %d, min = %d, max = %d", ent, min, max);
				#endif
				g_PageMusicRanges.Set(index, min, 1);
				g_PageMusicRanges.Set(index, max, 2);
			}
		}
	}

	while ((ent = FindEntityByClassname(ent, "sf2_info_page_music")) != -1)
	{
		SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
		if (!pageMusic.IsValid())
		{
			continue;
		}

		pageMusic.InsertRanges(g_PageMusicRanges);
	}

	// precache
	if (g_PageMusicRanges.Length > 0)
	{
		char path[PLATFORM_MAX_PATH];

		for (int i = 0; i < g_PageMusicRanges.Length; i++)
		{
			ent = EntRefToEntIndex(g_PageMusicRanges.Get(i));
			if (!ent || ent == INVALID_ENT_REFERENCE)
			{
				continue;
			}

			SF2PageMusicEntity pageMusic = SF2PageMusicEntity(ent);
			if (pageMusic.IsValid())
			{
				// Don't do anything; entity already precached its own music.
			}
			else
			{
				GetEntPropString(ent, Prop_Data, "m_iszSound", path, sizeof(path));
				if (path[0] != '\0')
				{
					PrecacheSound(path);
				}
			}
		}
	}

	LogSF2Message("Loaded page music ranges successfully!");
	return 0;
}

void SetPageCount(int num)
{
	if (num > g_PageMax)
	{
		num = g_PageMax;
	}

	int oldPageCount = g_PageCount;
	g_PageCount = num;
	int difficulty = g_DifficultyConVar.IntValue;
	if (g_PageCount != oldPageCount)
	{
		if (g_PageCount > oldPageCount)
		{
			if (g_RoundGraceTimer != null)
			{
				TriggerTimer(g_RoundGraceTimer);
			}

			if (g_RoundTime < g_RoundTimeLimit)
			{
				// Add round time.
				int roundTime = g_RoundTime;

				if (!SF_SpecialRound(SPECIALROUND_NOPAGEBONUS))
				{
					roundTime += g_RoundTimeGainFromPage;
				}

				if (roundTime > g_RoundTimeLimit)
				{
					roundTime = g_RoundTimeLimit;
				}

				SetRoundTime(roundTime);
			}

			if (SF_SpecialRound(SPECIALROUND_DISTORTION))
			{
				ArrayList clientSwap = new ArrayList();
				for (int client = 1; client <= MaxClients; client++)
				{
					SF2_BasePlayer player = SF2_BasePlayer(client);
					if (!player.IsValid)
					{
						continue;
					}
					if (!player.IsAlive)
					{
						continue;
					}
					if (player.IsEliminated)
					{
						continue;
					}
					if (player.HasEscaped)
					{
						continue;
					}
					if (player.IsInDeathCam)
					{
						continue;
					}
					bool isBossNear = false;
					float clientPos[3];
					player.GetAbsOrigin(clientPos);
					for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
					{
						SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(bossIndex);
						if (!npc.IsValid())
						{
							continue;
						}
						if (!npc.EntIndex || npc.EntIndex == INVALID_ENT_REFERENCE)
						{
							continue;
						}
						float bossPos[3];
						SF2_BaseBoss baseBoss = SF2_BaseBoss(npc.EntIndex);
						baseBoss.GetAbsOrigin(bossPos);
						if (GetVectorSquareMagnitude(bossPos, clientPos) <= Pow(750.0, 2.0))
						{
							isBossNear = true;
							break;
						}
						if (baseBoss.Target == player)
						{
							isBossNear = true;
							break;
						}
					}
					if (isBossNear)
					{
						continue;
					}
					clientSwap.Push(client);
				}

				int size = clientSwap.Length;
				if (size > 1)
				{
					int client, client2;
					float pos[3], pos2[3], ang[3], ang2[3], vel[3], vel2[3];
					clientSwap.Sort(Sort_Random, Sort_Integer);
					for (int array = 0; array < (size / 2); array++)
					{
						client = clientSwap.Get(array);
						GetClientAbsOrigin(client, pos);
						GetClientEyeAngles(client, ang);
						GetEntPropVector(client, Prop_Data, "m_vecAbsVelocity", vel);

						client2 = clientSwap.Get((size - 1) - array);
						GetClientAbsOrigin(client2, pos2);
						GetClientEyeAngles(client2, ang2);
						GetEntPropVector(client2, Prop_Data, "m_vecAbsVelocity", vel2);

						TeleportEntity(client, pos2, ang2, vel2);
						if (IsSpaceOccupiedIgnorePlayers(pos2, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client))
						{
							Player_FindFreePosition2(client, pos2, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS);
						}

						TeleportEntity(client2, pos, ang, vel);
						if (IsSpaceOccupiedIgnorePlayers(pos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client2))
						{
							Player_FindFreePosition2(client2, pos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS);
						}
					}
				}
				delete clientSwap;
			}

			if (SF_SpecialRound(SPECIALROUND_CLASSSCRAMBLE))
			{
				for (int client = 1; client <= MaxClients; client++)
				{
					if (!IsValidClient(client))
					{
						continue;
					}
					if (!IsPlayerAlive(client))
					{
						continue;
					}
					if (g_PlayerEliminated[client])
					{
						continue;
					}
					if (DidClientEscape(client))
					{
						continue;
					}

					TFClassType newClass;
					switch (g_PlayerRandomClassNumber[client])
					{
						case 1:
						{
							newClass = TFClass_Scout;
						}
						case 2:
						{
							newClass = TFClass_Soldier;
						}
						case 3:
						{
							newClass = TFClass_Pyro;
						}
						case 4:
						{
							newClass = TFClass_DemoMan;
						}
						case 5:
						{
							newClass = TFClass_Heavy;
						}
						case 6:
						{
							newClass = TFClass_Engineer;
						}
						case 7:
						{
							newClass = TFClass_Medic;
						}
						case 8:
						{
							newClass = TFClass_Sniper;
						}
						case 9:
						{
							newClass = TFClass_Spy;
						}
					}

					TF2_SetPlayerClass(client, newClass);

					CreateTimer(0.1, Timer_ClassScramblePlayer, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(0.25, Timer_ClassScramblePlayer2, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

					// Regenerate player but keep health the same.
					int health = GetEntProp(client, Prop_Send, "m_iHealth");
					TF2_RegeneratePlayer(client);
					SetEntProp(client, Prop_Data, "m_iHealth", health);
					SetEntProp(client, Prop_Send, "m_iHealth", health);
				}
			}

			if (SF_IsSlaughterRunMap())
			{
				if (g_PageCount == 1) //The first collectible for maps like Enclosed
				{
					int bosses = 0;
					float[] times = new float[MAX_BOSSES];
					float averageTime = 0.0;
					for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
					{
						if (NPCGetUniqueID(npcIndex) == -1)
						{
							continue;
						}
						SF2BossProfileData data;
						data = NPCGetProfileData(npcIndex);

						if (data.SlaughterRunData.SpawnTime[difficulty] > 0.0)
						{
							times[bosses] = data.SlaughterRunData.SpawnTime[difficulty];
							bosses++;
							continue;
						}

						float originalSpeed, speed, timerCheck;
						originalSpeed = data.RunSpeed[difficulty] + NPCGetAddSpeed(npcIndex);
						float slaughterSpeed = g_SlaughterRunMinimumBossRunSpeedConVar.FloatValue;
						if (originalSpeed < slaughterSpeed)
						{
							originalSpeed = slaughterSpeed;
						}
						if (g_RoundDifficultyModifier > 1.0)
						{
							speed = originalSpeed + ((originalSpeed * g_RoundDifficultyModifier) / 15);
						}
						else
						{
							speed = originalSpeed;
						}
						timerCheck = speed / g_SlaughterRunDivisibleTimeConVar.FloatValue;
						times[bosses] = timerCheck;
						bosses++;
					}
					int arrayLength = bosses;
					if (arrayLength > 0)
					{
						for (int i2 = 0; i2 < arrayLength; i2++)
						{
							averageTime += times[i2];
						}
						averageTime = averageTime / arrayLength;
						averageTime += (float(bosses) / 2.0);
						for (int i3 = 0; i3 < arrayLength; i3++)
						{
							averageTime += (times[i3] / GetRandomFloat(12.0, 22.0));
						}
						PrintToChatAll("Time before bosses spawn: %f seconds", averageTime);
						CreateTimer(averageTime, Timer_SlaughterRunSpawnBosses, _, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}

		SF2MapEntity_OnPageCountChanged(g_PageCount, oldPageCount);

		// Notify logic entities.
		char targetName[64];
		char findTargetName[64];
		FormatEx(findTargetName, sizeof(findTargetName), "sf2_onpagecount_%d", g_PageCount);

		int ent = -1;
		while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
		{
			GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
			if (targetName[0] != '\0' && strcmp(targetName, findTargetName, false) == 0)
			{
				AcceptEntityInput(ent, "Trigger");
				break;
			}
		}

		int clients[MAXTF2PLAYERS] = { -1, ... };
		int clientsNum = 0;

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid)
			{
				continue;
			}
			if (player.IsInDeathCam)
			{
				continue;
			}
			if (!player.IsEliminated || player.IsInGhostMode)
			{
				if (g_PageCount)
				{
					clients[clientsNum] = i;
					clientsNum++;
				}
			}
		}

		if (g_PageCount > 0 && g_RoundHasEscapeObjective && g_PageCount == g_PageMax)
		{
			// Escape initialized!
			SetRoundState(SF2RoundState_Escape);

			if (clientsNum)
			{
				int gameTextEscape = -1;
				SF2GameTextEntity gameText = SF2GameTextEntity(-1);

				if (g_GamerulesEntity.IsValid() && (gameText = g_GamerulesEntity.EscapeTextEntity).IsValid())
				{
					char message[512];
					gameText.GetEscapeMessage(message, sizeof(message));
					if (gameText.ValidateMessageString(message, sizeof(message)))
					{
						ShowHudTextUsingTextEntity(clients, clientsNum, gameText.index, g_HudSync, message);
					}
				}
				else if (IsValidEntity((gameTextEscape = GetTextEntity("sf2_escape_message", false))))
				{
					// Custom escape message.
					char message[512];
					GetEntPropString(gameTextEscape, Prop_Data, "m_iszMessage", message, sizeof(message));
					ShowHudTextUsingTextEntity(clients, clientsNum, gameTextEscape, g_HudSync, message);
				}
				else
				{
					// Default escape message.
					for (int i = 0; i < clientsNum; i++)
					{
						int client = clients[i];
						ClientShowMainMessage(client, "%d/%d\n%T", g_PageCount, g_PageMax, "SF2 Default Escape Message", i);
					}
				}
			}

			if (SF_SpecialRound(SPECIALROUND_LASTRESORT))
			{
				char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
				ArrayList selectableBosses = GetSelectableBossProfileList().Clone();
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
				delete selectableBosses;
			}
		}
		else
		{
			if (clientsNum)
			{
				int gameTextPage = -1;
				SF2GameTextEntity gameText = SF2GameTextEntity(-1);

				if (g_GamerulesEntity.IsValid() && (gameText = g_GamerulesEntity.PageTextEntity).IsValid())
				{
					char message[512];
					gameText.GetPageMessage(message, sizeof(message));
					if (gameText.ValidateMessageString(message, sizeof(message)))
					{
						ShowHudTextUsingTextEntity(clients, clientsNum, gameText.index, g_HudSync, message);
					}
				}
				else if (IsValidEntity((gameTextPage = GetTextEntity("sf2_page_message", false))))
				{
					// Custom page message.
					char message[512];
					GetEntPropString(gameTextPage, Prop_Data, "m_iszMessage", message, sizeof(message));
					ShowHudTextUsingTextEntity(clients, clientsNum, gameTextPage, g_HudSync, message, g_PageCount, g_PageMax);
				}
				else
				{
					// Default page message.
					for (int i = 0; i < clientsNum; i++)
					{
						int client = clients[i];
						ClientShowMainMessage(client, "%d/%d", g_PageCount, g_PageMax);
					}
				}
			}
		}

		CreateTimer(0.2, Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static Action Timer_SlaughterRunSpawnBosses(Handle timer)
{
	ArrayList spawnPoint = new ArrayList();
	float teleportPos[3];
	int ent = -1, spawnTeam = 0;
	while ((ent = FindEntityByClassname(ent, "info_player_teamspawn")) != -1)
	{
		spawnTeam = GetEntProp(ent, Prop_Data, "m_iInitialTeamNum");
		if (spawnTeam == TFTeam_Red)
		{
			spawnPoint.Push(ent);
		}

	}
	ent = -1;

	for (int bossIndex = 0; bossIndex <= MAX_BOSSES; bossIndex++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossIndex);
		if (!Npc.IsValid())
		{
			continue;
		}
		Npc.UnSpawn(true);
		if (spawnPoint.Length > 0)
		{
			ent = spawnPoint.Get(GetRandomInt(0, spawnPoint.Length - 1));
		}
		if (IsValidEntity(ent))
		{
			GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
			Npc.Spawn(teleportPos);
		}
	}
	delete spawnPoint;

	return Plugin_Stop;
}

static bool Player_FindFreePosition2(int client, float position[3], float mins[3], float maxs[3])
{
	int team = GetClientTeam(client);
	int mask = MASK_RED;
	if (team != TFTeam_Red)
	{
		mask = MASK_BLUE;
	}

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

static bool TraceFilter_NotTeam(int entity, int contentsMask, int team)
{
	if (entity >= 1 && entity <= MaxClients && GetClientTeam(entity) == team)
	{
		return false;
	}

	if (IsValidEdict(entity) && NPCGetFromEntIndex(entity) != -1)
	{
		return false;
	}
	return true;
}

static int GetTextEntity(const char[] tempTargetName, bool caseSensitive = true)
{
	// Try to see if we can use a custom message instead of the default.
	char targetName[64];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "game_text")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] != '\0')
		{
			if (strcmp(targetName, tempTargetName, caseSensitive) == 0)
			{
				return ent;
			}
		}
	}

	return -1;
}

void ShowHudTextUsingTextEntity(const int[] clients, int clientsNum, int gameText, Handle hudSync, const char[] message, any ...)
{
	if (message[0] == '\0')
	{
		return;
	}
	if (!IsValidEntity(gameText))
	{
		return;
	}

	char trueMessage[512];
	VFormat(trueMessage, sizeof(trueMessage), message, 6);

	float x = GetEntPropFloat(gameText, Prop_Data, "m_textParms.x");
	float y = GetEntPropFloat(gameText, Prop_Data, "m_textParms.y");
	int effect = GetEntProp(gameText, Prop_Data, "m_textParms.effect");
	float fadeInTime = GetEntPropFloat(gameText, Prop_Data, "m_textParms.fadeinTime");
	float fadeOutTime = GetEntPropFloat(gameText, Prop_Data, "m_textParms.fadeoutTime");
	float holdTime = GetEntPropFloat(gameText, Prop_Data, "m_textParms.holdTime");
	float fxTime = GetEntPropFloat(gameText, Prop_Data, "m_textParms.fxTime");

	int color1[4] = { 255, 255, 255, 255 };
	int color2[4] = { 255, 255, 255, 255 };

	int parmsOffset = FindDataMapInfo(gameText, "m_textParms");
	if (parmsOffset != -1)
	{
		// hudtextparms_s m_textParms

		color1[0] = GetEntData(gameText, parmsOffset + 12, 1);
		color1[1] = GetEntData(gameText, parmsOffset + 13, 1);
		color1[2] = GetEntData(gameText, parmsOffset + 14, 1);
		color1[3] = GetEntData(gameText, parmsOffset + 15, 1);

		color2[0] = GetEntData(gameText, parmsOffset + 16, 1);
		color2[1] = GetEntData(gameText, parmsOffset + 17, 1);
		color2[2] = GetEntData(gameText, parmsOffset + 18, 1);
		color2[3] = GetEntData(gameText, parmsOffset + 19, 1);
	}

	SetHudTextParamsEx(x, y, holdTime, color1, color2, effect, fxTime, fadeInTime, fadeOutTime);

	for (int i = 0; i < clientsNum; i++)
	{
		int client = clients[i];
		if (!IsValidClient(client) || IsFakeClient(client))
		{
			continue;
		}

		ShowSyncHudText(client, hudSync, trueMessage);
	}
}

void DistributeQueuePointsToPlayers()
{
	// Give away queue points.
	int defaultAmount = 5;
	int amount = defaultAmount;
	int amount2 = amount;
	Action action = Plugin_Continue;

	for (int i = 0; i < SF2_MAX_PLAYER_GROUPS; i++)
	{
		if (!IsPlayerGroupActive(i))
		{
			continue;
		}

		if (IsPlayerGroupPlaying(i))
		{
			SetPlayerGroupQueuePoints(i, 0);
		}
		else
		{
			amount = defaultAmount;
			amount2 = amount;
			action = Plugin_Continue;

			Call_StartForward(g_OnGroupGiveQueuePointsFwd);
			Call_PushCell(i);
			Call_PushCellRef(amount2);
			Call_Finish(action);

			if (action == Plugin_Changed)
			{
				amount = amount2;
			}

			SetPlayerGroupQueuePoints(i, GetPlayerGroupQueuePoints(i) + amount);

			for (int client = 1; client <= MaxClients; client++)
			{
				if (!IsValidClient(client))
				{
					continue;
				}
				if (ClientGetPlayerGroup(client) == i)
				{
					CPrintToChat(client, "%T", "SF2 Give Group Queue Points", client, amount);
				}
			}
		}
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		if (g_AdminNoPoints[i])
		{
			continue;
		}
		if (g_PlayerPlaying[i])
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
				amount = defaultAmount;
				amount2 = amount;
				action = Plugin_Continue;

				Call_StartForward(g_OnClientGiveQueuePointsFwd);
				Call_PushCell(i);
				Call_PushCellRef(amount2);
				Call_Finish(action);

				if (action == Plugin_Changed)
				{
					amount = amount2;
				}

				ClientSetQueuePoints(i, g_PlayerQueuePoints[i] + amount);
				CPrintToChat(i, "%T", "SF2 Give Queue Points", i, amount);
			}
		}
	}
}

/**
 *	Sets the player to the correct team if needed. Returns true if a change was necessary, false if no change occurred.
 */
bool HandlePlayerTeam(int client, bool respawn = true)
{
	if (!IsValidClient(client) || !IsClientParticipating(client))
	{
		return false;
	}

	if (!g_PlayerEliminated[client])
	{
		if (GetClientTeam(client) != TFTeam_Red)
		{
			if (respawn)
			{
				TF2_RemoveCondition(client, TFCond_HalloweenKart);
				TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
				TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
				TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
				TF2_RemoveCondition(client, TFCond_SpawnOutline);
				ChangeClientTeamNoSuicide(client, TFTeam_Red);
			}
			else
			{
				ChangeClientTeam(client, TFTeam_Red);
			}

			return true;
		}
	}
	else
	{
		if (GetClientTeam(client) != TFTeam_Blue)
		{
			if (respawn)
			{
				TF2_RemoveCondition(client, TFCond_HalloweenKart);
				TF2_RemoveCondition(client, TFCond_HalloweenKartDash);
				TF2_RemoveCondition(client, TFCond_HalloweenKartNoTurn);
				TF2_RemoveCondition(client, TFCond_HalloweenKartCage);
				TF2_RemoveCondition(client, TFCond_SpawnOutline);
				ChangeClientTeamNoSuicide(client, TFTeam_Blue);
			}
			else
			{
				ChangeClientTeam(client, TFTeam_Blue);
			}

			return true;
		}
	}

	return false;
}

void HandlePlayerIntroState(int client)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client) || !IsClientParticipating(client))
	{
		return;
	}

	if (!IsRoundInIntro())
	{
		return;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("START HandlePlayerIntroState(%d)", client);
	}
	#endif

	// Disable movement on player.
	SetEntityFlags(client, GetEntityFlags(client) | FL_FROZEN);

	float delay = 0.0;
	if (!IsFakeClient(client))
	{
		delay = GetClientLatency(client, NetFlow_Outgoing);
	}

	CreateTimer(delay * 4.0, Timer_IntroBlackOut, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 2)
	{
		DebugMessage("END HandlePlayerIntroState(%d)", client);
	}
	#endif
}

void HandlePlayerHUD(int client)
{
	if (SF_IsRaidMap() || SF_IsBoxingMap())
	{
		return;
	}
	if (IsRoundInWarmup() || IsClientInGhostMode(client))
	{
		SetEntProp(client, Prop_Send, "m_iHideHUD", 0);
	}
	else
	{
		if (!g_PlayerEliminated[client])
		{
			if (!DidClientEscape(client))
			{
				// Player is in the game; disable normal HUD.
				SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR | HIDEHUD_HEALTH);
			}
			else
			{
				// Player isn't in the game; enable normal HUD behavior.
				SetEntProp(client, Prop_Send, "m_iHideHUD", 0);
			}
		}
		else
		{
			if (g_PlayerProxy[client])
			{
				// Player is in the game; disable normal HUD.
				SetEntProp(client, Prop_Send, "m_iHideHUD", HIDEHUD_CROSSHAIR | HIDEHUD_HEALTH);
			}
			else
			{
				// Player isn't in the game; enable normal HUD behavior.
				SetEntProp(client, Prop_Send, "m_iHideHUD", 0);
			}
		}
	}
}

Action Timer_StopAirDash(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (DidClientEscape(client) || g_PlayerEliminated[client] || GetClientTeam(client) != TFTeam_Red || !IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}

	SetEntProp(client, Prop_Send, "m_iAirDash", 99999);

	return Plugin_Stop;
}

Action Timer_SwitchBot(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (GetClientTeam(client) != TFTeam_Red || DidClientEscape(client))
	{
		return Plugin_Stop;
	}

	if (!IsPlayerAlive(client))
	{
		return Plugin_Stop;
	}

	int random = GetRandomInt(1, 9);
	TFClassType newClass;
	switch (random)
	{
		case 1:
		{
			newClass = TFClass_Scout;
		}
		case 2:
		{
			newClass = TFClass_Soldier;
		}
		case 3:
		{
			newClass = TFClass_Pyro;
		}
		case 4:
		{
			newClass = TFClass_DemoMan;
		}
		case 5:
		{
			newClass = TFClass_Heavy;
		}
		case 6:
		{
			newClass = TFClass_Engineer;
		}
		case 7:
		{
			newClass = TFClass_Medic;
		}
		case 8:
		{
			newClass = TFClass_Sniper;
		}
		case 9:
		{
			newClass = TFClass_Spy;
		}
	}
	TF2_SetPlayerClass(client, newClass);
	TF2_RegeneratePlayer(client);

	return Plugin_Stop;
}

static Action Timer_IntroBlackOut(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (!IsRoundInIntro())
	{
		return Plugin_Stop;
	}

	if (!IsPlayerAlive(client) || g_PlayerEliminated[client])
	{
		return Plugin_Stop;
	}

	// Black out the player's screen.
	int fadeFlags = FFADE_OUT | FFADE_STAYOUT | FFADE_PURGE;
	UTIL_ScreenFade(client, 0, FixedUnsigned16(90.0, 1 << 12), fadeFlags, g_RoundIntroFadeColor[0], g_RoundIntroFadeColor[1], g_RoundIntroFadeColor[2], g_RoundIntroFadeColor[3]);

	return Plugin_Stop;
}

int GetClientForDeath(int exclude1, int exclude2 = 0)
{
	if (g_UsePlayersForKillFeedConVar.BoolValue)
	{
		// Use AFKs first
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i != exclude1 && i != exclude2 && IsValidClient(i) && GetClientTeam(i) > TFTeam_Spectator && g_PlayerNoPoints[i])
			{
				return i;
			}
		}

		// Use BLU second
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i != exclude1 && i != exclude2 && IsValidClient(i) && GetClientTeam(i) == TFTeam_Blue)
			{
				return i;
			}
		}

		// Anyone else last
		for (int i = 1; i <= MaxClients; i++)
		{
			if (i != exclude1 && i != exclude2 && IsValidClient(i))
			{
				return i;
			}
		}
	}
	return -1;
}

Action Timer_ToggleGhostModeCommand(Handle timer, any userid)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (IsRoundEnding() || IsRoundInWarmup() || !g_PlayerEliminated[client] || !IsClientParticipating(client) || g_PlayerProxy[client] || IsClientInPvP(client) || IsClientInKart(client) || TF2_IsPlayerInCondition(client, TFCond_Taunting) || TF2_IsPlayerInCondition(client, TFCond_Charging))
	{
		CPrintToChat(client, "{red}%T", "SF2 Ghost Mode Not Allowed", client);
		return Plugin_Stop;
	}

	if (!IsClientInGhostMode(client))
	{
		TF2_RespawnPlayer(client);
		ClientSetGhostModeState(client, true);
		HandlePlayerHUD(client);
		TF2_AddCondition(client, TFCond_StealthedUserBuffFade, -1.0);

		CPrintToChat(client, "{dodgerblue}%T", "SF2 Ghost Mode Enabled", client);
	}

	return Plugin_Stop;
}

Action Timer_SendDeath(Handle timer, Event event)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if (client > 0)
	{
		//Send it to the clients
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i))
			{
				if (!g_PlayerEliminated[client] || g_PlayerEliminated[i] || GetClientTeam(client) == GetClientTeam(i))
				{
					event.FireToClient(i);
				}
			}
		}
	}
	event.Cancel();
	return Plugin_Stop;
}

Action Timer_RevertClientName(Handle timer, int index)
{
	g_TimerChangeClientName[index] = null;
	if (IsValidClient(index))
	{
		SetClientName(index, g_OldClientName[index]);
		SetEntPropString(index, Prop_Data, "m_szNetname", g_OldClientName[index]);
	}
	return Plugin_Continue;
}

Action Timer_CheckAlivePlayers(Handle timer)
{
	if (!g_Enabled || !SF_IsBoxingMap())
	{
		return Plugin_Stop;
	}

	int clients[MAXTF2PLAYERS];
	int clientsNum;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || g_PlayerEliminated[i])
		{
			continue;
		}

		clients[clientsNum] = i;
		clientsNum++;
	}

	switch (clientsNum)
	{
		case 1:
		{
			for (int i = 0; i < clientsNum; i++)
			{
				int client = clients[i];
				TF2_AddCondition(client, TFCond_HalloweenCritCandy, -1.0);
			}
			if (!g_PlayersAreCritted)
			{
				if (g_RoundTime > 120)
				{
					SetRoundTime(120);
					CPrintToChatAll("Only 1 {red}RED{default} player is alive, 2 minutes left on the timer...");

				}
				else
				{
					CPrintToChatAll("Only 1 {red}RED{default} player is alive...");
				}

				for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
				{
					SF2NPC_BaseNPC npc = SF2NPC_BaseNPC(npcIndex);
					if (npc.UniqueID == -1)
					{
						continue;
					}
					npc.SetAddSpeed(50.0);
					npc.SetAddAcceleration(250.0);
				}
				g_PlayersAreCritted = true;
			}
		}
		case 2, 3:
		{
			if (!g_PlayersAreMiniCritted)
			{
				if (g_RoundTime > 200)
				{
					SetRoundTime(200);
					CPrintToChatAll("3 {red}RED{default} players are alive, 3 minutes and 20 seconds left on the timer...");
					for (int i = 0; i < clientsNum; i++)
					{
						int client = clients[i];
						TF2_AddCondition(client, TFCond_Buffed, -1.0);
					}
					g_PlayersAreMiniCritted = true;
				}
				else
				{
					CPrintToChatAll("3 {red}RED{default} players are alive...");
					for (int i = 0; i < clientsNum; i++)
					{
						int client = clients[i];
						TF2_AddCondition(client, TFCond_Buffed, -1.0);
					}
					g_PlayersAreMiniCritted = true;
				}
			}
		}
		default:
		{
			for (int i = 0; i < clientsNum; i++)
			{
				int client = clients[i];
				TF2_RemoveCondition(client, TFCond_Buffed);
				TF2_RemoveCondition(client, TFCond_HalloweenCritCandy);
			}
			g_PlayersAreCritted = false;
			g_PlayersAreMiniCritted = false;
		}
	}
	return Plugin_Stop;
}

Action Timer_ReplacePlayerRagdoll(Handle timer, any userid)
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
		SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
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
		int deathType = GetRandomInt(1, 8);
		switch (deathType)
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
				MakeVectorFromPoints(pos, { 0.0, 0.0, 0.0 }, velocity);
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

Action Timer_IceRagdoll(Handle timer, any userid)
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
		SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
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
		SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
	}
	AcceptEntityInput(ragdoll, "Kill", -1, -1, 0);
	return Plugin_Stop;
}

Action Timer_ManglerRagdoll(Handle timer, any userid)
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
		SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
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

Action Timer_DeGibRagdoll(Handle timer, any userid)
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
		SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
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
		int deGib = GetRandomInt(1, 2);
		switch (deGib)
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

Action Timer_MultiRagdoll(Handle timer, any userid)
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
		SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
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
		int multi = GetRandomInt(1, 9);
		switch (multi)
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

Action Timer_ModifyRagdoll(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (0 >= client)
	{
		return Plugin_Stop;
	}
	int bossIndex = g_PlayerBossKillSubject[client];
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}
	SF2BossProfileData data;
	data = NPCGetProfileData(bossIndex);
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");
	if (!IsValidEntity(ragdoll))
	{
		return Plugin_Stop;
	}
	if (!data.DeleteRagdoll)
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
			if (data.PushRagdoll)
			{
				force = data.PushRagdollForce;
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", force);
				SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
			}
			else
			{
				SetEntPropVector(ent, Prop_Send, "m_vecRagdollVelocity", velocity);
				SetEntPropVector(ent, Prop_Send, "m_vecForce", force);
			}
			if (data.ResizeRagdoll)
			{
				SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", data.ResizeRagdollHead);
				SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", data.ResizeRagdollTorso);
				SetEntPropFloat(ent, Prop_Send, "m_flHandScale", data.ResizeRagdollHands);
			}
			else
			{
				SetEntPropFloat(ent, Prop_Send, "m_flHeadScale", 1.0);
				SetEntPropFloat(ent, Prop_Send, "m_flTorsoScale", 1.0);
				SetEntPropFloat(ent, Prop_Send, "m_flHandScale", 1.0);
			}
			SetEntProp(ent, Prop_Send, "m_nForceBone", GetEntProp(ragdoll, Prop_Send, "m_nForceBone"));
			SetEntProp(ent, Prop_Send, "m_bOnGround", GetEntProp(ragdoll, Prop_Send, "m_bOnGround"));

			if (data.CloakRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bCloaked", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bCloaked", GetEntProp(ragdoll, Prop_Send, "m_bCloaked"));
			}

			SetEntPropEnt(ent, Prop_Send, "m_hPlayer", GetEntPropEnt(ragdoll, Prop_Send, "m_hPlayer"));
			SetEntProp(ent, Prop_Send, "m_iTeam", GetEntProp(ragdoll, Prop_Send, "m_iTeam"));
			SetEntProp(ent, Prop_Send, "m_iClass", GetEntProp(ragdoll, Prop_Send, "m_iClass"));
			SetEntProp(ent, Prop_Send, "m_bWasDisguised", GetEntProp(ragdoll, Prop_Send, "m_bWasDisguised"));
			SetEntProp(ent, Prop_Send, "m_bFeignDeath", GetEntProp(ragdoll, Prop_Send, "m_bFeignDeath"));

			if (data.GibRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bGib", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bGib", GetEntProp(ragdoll, Prop_Send, "m_bGib"));
			}

			if (data.DecapRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_DECAPITATION);
			}
			else if (data.PlasmaRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", TF_CUSTOM_PLASMA);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_iDamageCustom", GetEntProp(ragdoll, Prop_Send, "m_iDamageCustom"));
			}

			if (data.BurnRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bBurning", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bBurning", GetEntProp(ragdoll, Prop_Send, "m_bBurning"));
			}

			if (data.AshRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bBecomeAsh", GetEntProp(ragdoll, Prop_Send, "m_bBecomeAsh"));
			}

			if (data.GoldRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bGoldRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bGoldRagdoll"));
			}

			if (data.IceRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bIceRagdoll", GetEntProp(ragdoll, Prop_Send, "m_bIceRagdoll"));
			}

			if (data.ElectrocuteRagdoll)
			{
				SetEntProp(ent, Prop_Send, "m_bElectrocuted", true);
			}
			else
			{
				SetEntProp(ent, Prop_Send, "m_bElectrocuted", GetEntProp(ragdoll, Prop_Send, "m_bElectrocuted"));
			}

			DispatchSpawn(ent);
			ActivateEntity(ent);
			SetEntPropEnt(client, Prop_Send, "m_hRagdoll", ent, 0);
		}
		if (data.DissolveRagdoll)
		{
			int dissolver = CreateEntityByName("env_entity_dissolver");
			if (!IsValidEntity(dissolver))
			{
				return Plugin_Stop;
			}
			char type[2];
			int typeInt = data.DissolveKillType;
			FormatEx(type, sizeof(type), "%d", typeInt);
			DispatchKeyValue(dissolver, "dissolvetype", type);
			DispatchKeyValue(dissolver, "magnitude", "1");
			DispatchKeyValue(dissolver, "target", "!activator");

			AcceptEntityInput(dissolver, "Dissolve", ent);
			RemoveEntity(dissolver);
		}
	}
	RemoveEntity(ragdoll);
	return Plugin_Stop;
}

Action Timer_SetPlayerHealth(Handle timer, any data)
{
	Handle pack = view_as<Handle>(data);
	ResetPack(pack);
	int attacker = GetClientOfUserId(ReadPackCell(pack));
	int health = ReadPackCell(pack);
	delete pack;

	if (attacker <= 0)
	{
		return Plugin_Stop;
	}

	SetEntProp(attacker, Prop_Data, "m_iHealth", health);
	SetEntProp(attacker, Prop_Send, "m_iHealth", health);

	return Plugin_Stop;
}

Action Timer_PlayerSwitchToBlue(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerSwitchBlueTimer[client])
	{
		return Plugin_Stop;
	}
	if (g_IgnoreRedPlayerDeathSwapConVar.BoolValue)
	{
		return Plugin_Stop;
	}

	ChangeClientTeam(client, TFTeam_Blue);

	if (TF2_GetPlayerClass(client) == TFClass_Unknown)
	{
		// Player hasn't chosen a class for some reason. Choose one for him.
		TF2_SetPlayerClass(client, view_as<TFClassType>(GetRandomInt(1, 9)), true, true);
	}

	return Plugin_Stop;
}

void CreateGeneralParticle(int entity, const char[] sectionName, float particleZPos = 0.0)
{
	if (entity == -1)
	{
		return;
	}

	float slenderPosition[3], slenderAngles[3];
	GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", slenderPosition);
	GetEntPropVector(entity, Prop_Data, "m_angAbsRotation", slenderAngles);
	slenderPosition[2] += particleZPos;

	if (!DispatchParticleEffect(entity, sectionName, slenderPosition, slenderAngles, slenderPosition))
	{
		int particleEnt = CreateEntityByName("info_particle_system");

		if (particleEnt != -1 && entity != -1)
		{
			TeleportEntity(particleEnt, slenderPosition, slenderAngles, NULL_VECTOR);

			DispatchKeyValue(particleEnt, "targetname", "tf2particle");
			DispatchKeyValue(particleEnt, "effect_name", sectionName);

			DispatchSpawn(particleEnt);

			ActivateEntity(particleEnt);
			AcceptEntityInput(particleEnt, "start");

			CreateTimer(0.1, Timer_KillEdict, particleEnt, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

static Action Timer_RoundStart(Handle timer)
{
	if (g_PageMax > 0)
	{
		int clients[MAXTF2PLAYERS];
		int clientsNum = 0;

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid || player.IsBot || player.IsEliminated)
			{
				continue;
			}

			clients[clientsNum] = i;
			clientsNum++;
		}

		// Show difficulty menu.
		if (!SF_IsBoxingMap() && !SF_IsRenevantMap() && !SF_SpecialRound(SPECIALROUND_MODBOSSES))
		{
			if (clientsNum > 0)
			{
				g_VoteTimer = CreateTimer(1.0, Timer_VoteDifficulty, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
				TriggerTimer(g_VoteTimer, true);

				int gameText = -1;
				char message[512];

				if (g_GamerulesEntity.IsValid() && g_GamerulesEntity.IntroTextEntity.IsValid())
				{
					// Do nothing; already being handled.
				}
				else if ((gameText = GetTextEntity("sf2_intro_message", false)) != -1)
				{
					GetEntPropString(gameText, Prop_Data, "m_iszMessage", message, sizeof(message));
					ShowHudTextUsingTextEntity(clients, clientsNum, gameText, g_HudSync, message);
				}
				else
				{
					for (int i = 0; i < clientsNum; i++)
					{
						int client = clients[i];
						FormatEx(message, sizeof(message), "%T", g_PageMax > 1 ? "SF2 Default Intro Message Plural" : "SF2 Default Intro Message Singular", client, g_PageMax);
						ClientShowMainMessage(client, message);
					}
				}
			}
		}
	}

	return Plugin_Stop;
}

Action Timer_CheckRoundWinConditions(Handle timer)
{
	CheckRoundWinConditions();
	return Plugin_Stop;
}

static Action Timer_RoundGrace(Handle timer)
{
	if (timer != g_RoundGraceTimer)
	{
		return Plugin_Stop;
	}

	SetRoundState(SF2RoundState_Active);
	return Plugin_Stop;
}

static Action Timer_RoundTime(Handle timer)
{
	if (timer != g_RoundTimer)
	{
		return Plugin_Stop;
	}

	if (g_RoundTime <= 0)
	{
		//The round ended trigger a security timer.
		SF_FailEnd();
		SF_FailRoundEnd(2.0);

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i) || !IsPlayerAlive(i) || g_PlayerEliminated[i] || IsClientInGhostMode(i))
			{
				continue;
			}

			float buffer[3];
			GetClientAbsOrigin(i, buffer);
			if (SF_SpecialRound(SPECIALROUND_1UP))
			{
				g_PlayerDied1Up[i] = false;
				g_PlayerIn1UpCondition[i] = false;
				g_PlayerFullyDied1Up[i] = true;
			}
			KillClient(i);
		}

		return Plugin_Stop;
	}
	if (SF_SpecialRound(SPECIALROUND_REVOLUTION))
	{
		if (g_SpecialRoundTime % 60 == 0)
		{
			SpecialRoundCycleStart();
		}
	}

	if (g_IsSpecialRound)
	{
		g_SpecialRoundTime++;
	}

	if (!g_RoundTimerPaused && !IsBeatBoxBeating(2))
	{
		SetRoundTime(g_RoundTime - 1);
	}

	int hours, minutes, seconds;
	FloatToTimeHMS(float(g_RoundTime), hours, minutes, seconds);

	SetHudTextParams(-1.0, 0.1,
		1.0,
		SF2_HUD_TEXT_COLOR_R, SF2_HUD_TEXT_COLOR_G, SF2_HUD_TEXT_COLOR_B, SF2_HUD_TEXT_COLOR_A,
		_,
		_,
		1.5, 1.5);

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i) || IsFakeClient(i) || (g_PlayerEliminated[i] && !IsClientInGhostMode(i)))
		{
			continue;
		}
		if (SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
		{
			ShowSyncHudText(i, g_RoundTimerSync, "%d/%d\n??:??", g_PageCount, g_PageMax);
		}
		else
		{
			ShowSyncHudText(i, g_RoundTimerSync, "%d/%d\n%d:%02d", g_PageCount, g_PageMax, minutes, seconds);
		}
	}

	return Plugin_Continue;
}

static Action Timer_RoundTimeEscape(Handle timer)
{
	if (timer != g_RoundTimer)
	{
		return Plugin_Stop;
	}

	if (g_RoundTime <= 0)
	{
		//The round ended trigger a security timer.
		SF_FailEnd();
		SF_FailRoundEnd(2.0);

		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsValidClient(i) || !IsPlayerAlive(i) || g_PlayerEliminated[i] || IsClientInGhostMode(i) || DidClientEscape(i))
			{
				continue;
			}

			float buffer[3];
			GetClientAbsOrigin(i, buffer);
			if (SF_SpecialRound(SPECIALROUND_1UP))
			{
				g_PlayerDied1Up[i] = false;
				g_PlayerIn1UpCondition[i] = false;
				g_PlayerFullyDied1Up[i] = true;
			}
			KillClient(i);
		}
		return Plugin_Stop;
	}

	if (SF_SpecialRound(SPECIALROUND_REVOLUTION))
	{
		if (g_SpecialRoundTime % 60 == 0)
		{
			SpecialRoundCycleStart();
		}
	}

	if ((1.0 - ((float(g_RoundTime)) / (float(g_RoundEscapeTimeLimit + g_TimeEscape)))) >= 0.65)
	{
		if (!g_InProxySurvivalRageMode && !SF_IsRenevantMap())
		{
			bool proxyBoss = false;
			for (int bossIndex = 0; bossIndex < MAX_BOSSES; bossIndex++)
			{
				SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(bossIndex);
				if (Npc.UniqueID == -1)
				{
					continue;
				}

				if (!(Npc.Flags & SFF_PROXIES))
				{
					continue;
				}

				proxyBoss = true;
				break;
			}

			if (proxyBoss)
			{
				int alivePlayer = 0;
				for (int client = 1; client <= MaxClients; client++)
				{
					if (IsValidClient(client) && IsPlayerAlive(client) && !g_PlayerEliminated[client])
					{
						alivePlayer++;
					}
				}

				if (alivePlayer >= (GetMaxPlayersForRound() / 2)) //Too many players are still alive... enter rage mode!
				{
					g_InProxySurvivalRageMode = true;
					EmitSoundToAll(PROXY_RAGE_MODE_SOUND);
					EmitSoundToAll(PROXY_RAGE_MODE_SOUND);
				}
			}
		}
	}

	int hours, minutes, seconds;
	FloatToTimeHMS(float(g_RoundTime), hours, minutes, seconds);

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
		if (!IsValidClient(i) || IsFakeClient(i) || (g_PlayerEliminated[i] && !IsClientInGhostMode(i)))
		{
			continue;
		}

		char text[512];
		if (SF_IsBoxingMap())
		{
			FormatEx(text, sizeof(text), "%T", "SF2 Default Boxing Message", i);
		}
		else
		{
			if (SF_IsSurvivalMap() && g_RoundTime > g_TimeEscape)
			{
				FormatEx(text, sizeof(text), "%T", "SF2 Default Survive Message", i);
			}
			else
			{
				FormatEx(text, sizeof(text), "%T", "SF2 Default Escape Message", i);
			}
		}

		char timerText[128];
		if (SF_SpecialRound(SPECIALROUND_EYESONTHECLOACK))
		{
			strcopy(timerText, sizeof(timerText), "\n??:??");
		}
		else
		{
			FormatEx(timerText, sizeof(timerText), "\n%d:%02d", minutes, seconds);
		}

		StrCat(text, sizeof(text), timerText);

		ShowSyncHudText(i, g_RoundTimerSync, text);
	}
	if (g_IsSpecialRound)
	{
		g_SpecialRoundTime++;
	}

	if (!g_RoundTimerPaused)
	{
		SetRoundTime(g_RoundTime - 1);
	}

	return Plugin_Continue;
}

static Action Timer_VoteDifficulty(Handle timer)
{
	if (timer != g_VoteTimer || IsRoundEnding())
	{
		return Plugin_Stop;
	}

	if (IsVoteInProgress() || NativeVotes_IsVoteInProgress())
	{
		return Plugin_Continue; // There's another vote in progess. Wait.
	}

	int clients[MAXTF2PLAYERS] = { -1, ... };
	int clientsNum;
	for (int i = 1; i <= MaxClients; i++)
	{
		SF2_BasePlayer player = SF2_BasePlayer(i);
		if (!player.IsValid || player.IsBot || player.IsEliminated)
		{
			continue;
		}

		clients[clientsNum] = player.index;
		clientsNum++;
	}

	if (clientsNum == 0)
	{
		return Plugin_Stop;
	}

	RandomizeVoteMenu();
	g_MenuVoteDifficulty.DisplayVote(clients, clientsNum, 15);
	if (g_MenuVoteDifficulty.ItemCount == 1)
	{
		for (int i = 0; i < clientsNum; i++)
		{
			FakeClientCommand(clients[i], "menuselect 1");
		}
	}

	return Plugin_Stop;
}

static void SF_FailRoundEnd(float time = 2.0)
{
	//Check round win conditions again.
	CreateTimer((time - 0.8), Timer_CheckRoundWinConditions, _, TIMER_FLAG_NO_MAPCHANGE);

	if (!g_IgnoreRoundWinConditionsConVar.BoolValue)
	{
		g_TimerFail = CreateTimer(time, Timer_Fail, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

void SF_FailEnd()
{
	if (g_TimerFail != null)
	{
		KillTimer(g_TimerFail);
	}
	g_TimerFail = null;
}

static Action Timer_Fail(Handle timer)
{
	LogSF2Message("Wow you hit a rare bug, where the round doesn't end after the timer ran out. Collecting info on your game...\nContact Mentrillum and give them the following log:");
	int escapedPlayers = 0;
	int clientInGame = 0;
	int redPlayers = 0;
	int bluPlayers = 0;
	int eliminatedPlayers = 0;
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsValidClient(client))
		{
			clientInGame++;
			LogSF2Message("Player %N (%i), Team: %d, Eliminated: %d, Escaped: %d.", client, client, GetClientTeam(client), g_PlayerEliminated[client], DidClientEscape(client));
			if (GetClientTeam(client) == TFTeam_Blue)
			{
				bluPlayers++;
			}
			else if (GetClientTeam(client) == TFTeam_Red)
			{
				redPlayers++;
			}
		}
		if (g_PlayerEliminated[client])
		{
			eliminatedPlayers++;
		}
		if (DidClientEscape(client))
		{
			escapedPlayers++;
		}
	}
	LogSF2Message("Total clients: %d, Blu players: %d, Red players: %d, Escaped players: %d, Eliminated players: %d", MaxClients, bluPlayers, redPlayers, escapedPlayers, eliminatedPlayers);
	//Force blus to win.
	ForceTeamWin(TFTeam_Blue);

	g_TimerFail = null;

	return Plugin_Stop;
}

/**
 *	Initialize pages and entities.
 */
static void InitializeMapEntities()
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START InitializeMapEntities()");
	}
	#endif

	g_IsSurvivalMap = false;
	g_IsBoxingMap = false;
	g_IsRenevantMap = false;
	g_IsSlaughterRunMap = false;
	g_IsRaidMap = false;
	g_IsProxyMap = false;

	SF2GamerulesEntity gamerules = FindSF2GamerulesEntity();
	g_GamerulesEntity = gamerules;

	if (gamerules.IsValid())
	{
		if (g_RoundActiveCount == 1)
		{
			g_MaxPlayersConVar.SetInt(gamerules.MaxPlayers);
		}

		char bossName[SF2_MAX_PROFILE_NAME_LENGTH];
		gamerules.GetBossName(bossName, sizeof(bossName));
		if (bossName[0] != '\0')
		{
			g_BossMainConVar.SetString(bossName);
		}

		g_PageMax = gamerules.MaxPages;

		g_RoundTimeLimit = gamerules.InitialTimeLimit;
		g_RoundTimeGainFromPage = gamerules.PageCollectAddTime;

		gamerules.GetPageCollectSoundPath(g_PageCollectSound, sizeof(g_PageCollectSound));
		if (g_PageCollectSound[0] == '\0')
		{
			strcopy(g_PageCollectSound, sizeof(g_PageCollectSound), PAGE_GRABSOUND); // Roll with default instead.
		}

		g_PageSoundPitch = gamerules.PageCollectSoundPitch;

		g_RoundHasEscapeObjective = gamerules.HasEscapeObjective;
		g_RoundEscapeTimeLimit = gamerules.EscapeTimeLimit;
		g_RoundStopPageMusicOnEscape = gamerules.StopPageMusicOnEscape;
		g_IsSurvivalMap = gamerules.Survive;
		g_TimeEscape = gamerules.SurviveUntilTime;

		g_RoundInfiniteFlashlight = gamerules.InfiniteFlashlight;
		g_IsRoundInfiniteSprint = gamerules.InfiniteSprint;
		g_RoundInfiniteBlink = gamerules.InfiniteBlink;

		g_BossesChaseEndlessly = gamerules.BossesChaseEndlessly;

		gamerules.GetIntroMusicPath(g_RoundIntroMusic, sizeof(g_RoundIntroMusic));
		if (g_RoundIntroMusic[0] == '\0')
		{
			strcopy(g_RoundIntroMusic, sizeof(g_RoundIntroMusic), SF2_INTRO_DEFAULT_MUSIC); // Roll with default instead.
		}

		gamerules.GetIntroFadeColor(g_RoundIntroFadeColor);
		g_RoundIntroFadeHoldTime = gamerules.IntroFadeHoldTime;
		g_RoundIntroFadeDuration = gamerules.IntroFadeTime;
	}
	else
	{
		g_RoundTimeLimit = g_TimeLimitConVar.IntValue;
		g_RoundTimeGainFromPage = g_TimeGainFromPageGrabConVar.IntValue;
		strcopy(g_PageCollectSound, sizeof(g_PageCollectSound), PAGE_GRABSOUND);
		g_PageSoundPitch = 100;

		g_RoundHasEscapeObjective = false;
		g_RoundEscapeTimeLimit = g_TimeLimitEscapeConVar.IntValue;
		g_RoundStopPageMusicOnEscape = false;
		g_TimeEscape = g_TimeEscapeSurvivalConVar.IntValue;

		g_RoundInfiniteFlashlight = false;
		g_IsRoundInfiniteSprint = false;
		g_RoundInfiniteBlink = false;

		g_BossesChaseEndlessly = false;

		strcopy(g_RoundIntroMusic, sizeof(g_RoundIntroMusic), SF2_INTRO_DEFAULT_MUSIC);

		g_RoundIntroFadeColor[0] = 0;
		g_RoundIntroFadeColor[1] = 0;
		g_RoundIntroFadeColor[2] = 0;
		g_RoundIntroFadeColor[3] = 255;
		g_RoundIntroFadeHoldTime = g_IntroDefaultHoldTimeConVar.FloatValue;
		g_RoundIntroFadeDuration = g_IntroDefaultFadeTimeConVar.FloatValue;
	}

	// Check the game type.
	if (FindLogicProxyEntity().IsValid())
	{
		g_IsProxyMap = true;
		g_IsSurvivalMap = true;
	}
	else if (FindLogicRaidEntity().IsValid())
	{
		g_IsRaidMap = true;
	}
	else if (FindLogicBoxingEntity().IsValid())
	{
		g_IsBoxingMap = true;
	}
	else if (FindLogicSlaughterEntity().IsValid())
	{
		g_IsSlaughterRunMap = true;
	}
	else if ((g_RenevantLogicEntity = FindLogicRenevantEntity()).IsValid())
	{
		g_IsRenevantMap = true;
	}

	if (SF_IsRenevantMap())
	{
		if (g_RenevantLogicEntity.IsValid())
		{
			g_RenevantFinaleTime = g_RenevantLogicEntity.FinaleTime;
		}
		else
		{
			g_RenevantFinaleTime = 60;
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
				g_PageMax = StringToInt(targetName);
			}
			else if (!StrContains(targetName, "sf2_logic_escape", false))
			{
				g_RoundHasEscapeObjective = true;
			}
			else if (strcmp(targetName, "sf2_escape_custommusic", false) == 0)
			{
				g_RoundStopPageMusicOnEscape = true;
			}
			else if (!StrContains(targetName, "sf2_infiniteflashlight", false))
			{
				g_RoundInfiniteFlashlight = true;
			}
			else if (!StrContains(targetName, "sf2_infiniteblink", false))
			{
				g_RoundInfiniteBlink = true;
			}
			else if (!StrContains(targetName, "sf2_infinitesprint", false))
			{
				g_IsRoundInfiniteSprint = true;
			}
			else if (!StrContains(targetName, "sf2_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_time_limit_", "", false);
				g_RoundTimeLimit = StringToInt(targetName);

				LogSF2Message("Found sf2_time_limit entity, set time limit to %d", g_RoundTimeLimit);
			}
			else if (!StrContains(targetName, "sf2_escape_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_escape_time_limit_", "", false);
				g_RoundEscapeTimeLimit = StringToInt(targetName);

				LogSF2Message("Found sf2_escape_time_limit entity, set escape time limit to %d", g_RoundEscapeTimeLimit);
			}
			else if (!StrContains(targetName, "sf2_time_gain_from_page_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_time_gain_from_page_", "", false);
				g_RoundTimeGainFromPage = StringToInt(targetName);

				LogSF2Message("Found sf2_time_gain_from_page entity, set time gain to %d", g_RoundTimeGainFromPage);
			}
			else if (g_RoundActiveCount == 1 && (!StrContains(targetName, "sf2_maxplayers_", false)))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_maxplayers_", "", false);
				g_MaxPlayersConVar.SetInt(StringToInt(targetName));

				LogSF2Message("Found sf2_maxplayers entity, set maxplayers to %d", StringToInt(targetName));
			}
			else if (!StrContains(targetName, "sf2_boss_override_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_boss_override_", "", false);
				g_BossMainConVar.SetString(targetName);

				LogSF2Message("Found sf2_boss_override entity, set boss profile override to %s", targetName);
			}
			else if (!StrContains(targetName, "sf2_survival_map", false))
			{
				g_IsSurvivalMap = true;
			}
			else if (!StrContains(targetName, "sf2_raid_map", false))
			{
				g_IsRaidMap = true;
			}
			else if (!StrContains(targetName, "sf2_bosses_chase_endlessly", false))
			{
				g_BossesChaseEndlessly = true;
			}
			else if (!StrContains(targetName, "sf2_proxy_map", false))
			{
				g_IsProxyMap = true;
				g_IsSurvivalMap = true;
			}
			else if (!StrContains(targetName, "sf2_boxing_map", false))
			{
				g_IsBoxingMap = true;
			}
			else if (!StrContains(targetName, "sf2_survival_time_limit_", false))
			{
				ReplaceString(targetName, sizeof(targetName), "sf2_survival_time_limit_", "", false);
				g_TimeEscape = StringToInt(targetName);

				LogSF2Message("Found sf2_survival_time_limit_ entity, set survival time limit to %d", g_TimeEscape);
			}
			else if (!StrContains(targetName, "sf2_renevant_map", false))
			{
				g_IsRenevantMap = true;
			}
			else if (!StrContains(targetName, "sf2_slaughterrun_map", false))
			{
				g_IsSlaughterRunMap = true;
			}
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] == '\0')
		{
			continue;
		}

		if (strcmp(targetName, "sf2_page_sound", false) == 0)
		{
			char pagePath[PLATFORM_MAX_PATH];
			GetEntPropString(ent, Prop_Data, "m_iszSound", pagePath, sizeof(pagePath));

			if (pagePath[0] == '\0')
			{
				LogError("Found sf2_page_sound entity, but it has no sound path specified! Default page sound will be used instead.");
			}
			else
			{
				strcopy(g_PageCollectSound, sizeof(g_PageCollectSound), pagePath);
			}
		}
	}

	// For old page spawn points, get the reference entity if it exists.
	g_PageRef = false;
	strcopy(g_PageRefModelName, sizeof(g_PageRefModelName), PAGE_MODEL);
	g_PageRefModelScale = 1.0;

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "prop_dynamic")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0] == '\0')
		{
			continue;
		}

		if (strcmp(targetName, "sf2_page_model", false) == 0)
		{
			g_PageRef = true;
			GetEntPropString(ent, Prop_Data, "m_ModelName", g_PageRefModelName, sizeof(g_PageRefModelName));
			g_PageRefModelScale = GetEntPropFloat(ent, Prop_Send, "m_flModelScale");
			break;
		}
	}

	#if defined DEBUG
	LogSF2Message("ROUND SETTINGS:\n - Time limit: %i\n - Time gain from page: %i\n - Page collect sound: %s\n - Escape?: %i\n - Escape time limit: %i\n - Stop page music on escape: %i\n - Survive before escape?: %i\n - Survive until time: %i\n - Infinite flashlight: %i\n - Infinite sprint: %i\n - Infinite blink: %i\n - Bosses chase endlessly: %i\n - Intro music: %s\n - Intro fade hold time: %f\n - Intro fade time: %f",
		g_RoundTimeLimit, g_RoundTimeGainFromPage, g_PageCollectSound, g_RoundHasEscapeObjective, g_RoundEscapeTimeLimit, g_RoundStopPageMusicOnEscape, g_IsSurvivalMap, g_TimeEscape, g_RoundInfiniteFlashlight, g_IsRoundInfiniteSprint, g_RoundInfiniteBlink, g_BossesChaseEndlessly, g_RoundIntroMusic, g_RoundIntroFadeHoldTime, g_RoundIntroFadeDuration);
	#endif

	GetRoundIntroParameters();
	GetRoundEscapeParameters();
	GetPageMusicRanges();
	SpawnPages();

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END InitializeMapEntities()");
	}
	#endif
}

static void SpawnPages()
{
	g_Pages.Clear();
	g_EmptySpawnPagePoints.Clear();

	ArrayList array = new ArrayList(2);
	StringMap pageGroupsByName = new StringMap();

	ArrayList pageSpawnPoints = new ArrayList();

	int ent = -1;
	char targetName[64];

	// Collect all possible page spawn points.
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (targetName[0])
		{
			if (!StrContains(targetName, "sf2_page_spawnpoint", false))
			{
				pageSpawnPoints.Push(EnsureEntRef(ent));
			}
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_page_spawn")) != -1)
	{
		SF2PageSpawnEntity pageSpawn = SF2PageSpawnEntity(ent);
		if (pageSpawn.IsValid())
		{
			pageSpawnPoints.Push(EnsureEntRef(ent));
		}
	}

	if (pageSpawnPoints.Length > 0)
	{
		// Try to sort spawn points into their respective groups.

		char pageGroup[64];

		for (int i = 0; i < pageSpawnPoints.Length; i++)
		{
			int spawnPointEnt = pageSpawnPoints.Get(i);
			if (!IsValidEntity(spawnPointEnt))
			{
				continue;
			}

			// Get page group if possible.
			SF2PageSpawnEntity pageSpawn = SF2PageSpawnEntity(spawnPointEnt);
			if (pageSpawn.IsValid())
			{
				pageSpawn.GetPageGroup(pageGroup, sizeof(pageGroup));
			}
			else
			{
				GetEntPropString(spawnPointEnt, Prop_Data, "m_iName", pageGroup, sizeof(pageGroup));

				if (!StrContains(pageGroup, "sf2_page_spawnpoint_", false))
				{
					ReplaceString(pageGroup, sizeof(pageGroup), "sf2_page_spawnpoint_", "", false);
				}
				else
				{
					pageGroup[0] = '\0';
				}
			}

			if (pageGroup[0] != '\0')
			{
				// Spawn point belongs to a group.

				ArrayList buttStallion;
				if (!pageGroupsByName.GetValue(pageGroup, buttStallion))
				{
					// Initialize new page group since it didn't exist.
					buttStallion = new ArrayList();
					pageGroupsByName.SetValue(pageGroup, buttStallion);

					int index = array.Push(buttStallion);
					array.Set(index, true, 1);
				}

				buttStallion.Push(EnsureEntRef(spawnPointEnt));
			}
			else
			{
				int index = array.Push(EnsureEntRef(spawnPointEnt));
				array.Set(index, false, 1);
			}
		}
	}

	delete pageSpawnPoints;

	int pageCount = array.Length;
	if (pageCount)
	{
		// Spawn all pages.
		array.Sort(Sort_Random, Sort_Integer);

		float pos[3], angle[3];
		int page;

		char pageModel[PLATFORM_MAX_PATH];
		char pageParentName[64];
		float pageModelScale;
		int pageSkin;
		RenderFx pageRenderFx;
		RenderMode pageRenderMode;
		int pageBodygroup;
		int pageRenderColor[4];
		char pageAnimation[64];

		for (int i = 0, size = array.Length; i < size; i++)
		{
			if (array.Get(i, 1) != 0)
			{
				ArrayList grouped = array.Get(i);
				for (int i2 = 0; i2 < grouped.Length; i2++)
				{
					g_EmptySpawnPagePoints.Push(EntRefToEntIndex(grouped.Get(i2)));
				}
			}
			else
			{
				g_EmptySpawnPagePoints.Push(EntRefToEntIndex(array.Get(i)));
			}
		}

		for (int i = 0; i < pageCount && (i + 1) <= g_PageMax; i++)
		{
			int spawnPointEnt = -1;
			if (array.Get(i, 1) != 0)
			{
				ArrayList buttStallion = array.Get(i);
				spawnPointEnt = buttStallion.Get(GetRandomInt(0, buttStallion.Length - 1));
			}
			else
			{
				spawnPointEnt = array.Get(i);
			}

			SF2PageSpawnEntity spawnPoint = SF2PageSpawnEntity(spawnPointEnt);

			GetEntPropVector(spawnPointEnt, Prop_Data, "m_vecAbsOrigin", pos);
			GetEntPropVector(spawnPointEnt, Prop_Data, "m_angAbsRotation", angle);
			GetEntPropString(spawnPointEnt, Prop_Data, "m_iParent", pageParentName, sizeof(pageParentName));

			// Get model, scale, skin, and animation.
			if (spawnPoint.IsValid())
			{
				spawnPoint.GetPageModel(pageModel, sizeof(pageModel));
				pageModelScale = spawnPoint.PageModelScale;
				pageSkin = spawnPoint.PageSkin == -1 ? i : spawnPoint.PageSkin;
				pageBodygroup = spawnPoint.PageBodygroup;
				pageRenderFx = spawnPoint.GetRenderFx();
				pageRenderMode = spawnPoint.GetRenderMode();
				spawnPoint.GetRenderColor(pageRenderColor[0], pageRenderColor[1], pageRenderColor[2], pageRenderColor[3]);
				spawnPoint.GetPageAnimation(pageAnimation, sizeof(pageAnimation));
			}
			else if (g_PageRef)
			{
				strcopy(pageModel, sizeof(pageModel), g_PageRefModelName);
				pageModelScale = g_PageRefModelScale;
				pageSkin = i;
				pageBodygroup = 0;
				pageRenderFx = RENDERFX_NONE;
				pageRenderMode = RENDER_NORMAL;
				pageRenderColor[0] = 255; pageRenderColor[1] = 255; pageRenderColor[2] = 255; pageRenderColor[3] = 255;
				pageAnimation[0] = '\0';
			}
			else
			{
				strcopy(pageModel, sizeof(pageModel), PAGE_MODEL);
				pageModelScale = PAGE_MODELSCALE;
				pageSkin = i;
				pageBodygroup = 0;
				pageRenderFx = RENDERFX_NONE;
				pageRenderMode = RENDER_NORMAL;
				pageRenderColor[0] = 255; pageRenderColor[1] = 255; pageRenderColor[2] = 255; pageRenderColor[3] = 255;
				pageAnimation[0] = '\0';
			}

			// Create fake page model
			char pageName[50];
			int page2 = CreateEntityByName("prop_dynamic_override");
			if (page2 != -1)
			{
				DispatchKeyValue(page2, "targetname", "sf2_page_ex");
				DispatchKeyValue(page2, "parentname", pageParentName);
				DispatchKeyValue(page2, "solid", "0");
				SetEntityModel(page2, pageModel);
				TeleportEntity(page2, pos, angle, NULL_VECTOR);
				DispatchSpawn(page2);
				ActivateEntity(page2);
				SetVariantInt(pageSkin);
				AcceptEntityInput(page2, "Skin");
				SetVariantInt(pageBodygroup);
				AcceptEntityInput(page2, "SetBodyGroup");
				AcceptEntityInput(page2, "DisableCollision");
				SetEntPropFloat(page2, Prop_Send, "m_flModelScale", pageModelScale);
				SetEntityRenderMode(page2, pageRenderMode);
				SetEntityRenderFx(page2, pageRenderFx);
				SetEntityRenderColor(page2, pageRenderColor[0], pageRenderColor[1], pageRenderColor[2], pageRenderColor[3]);

				SetEntityTransmitState(page2, FL_EDICT_ALWAYS);
				CreateTimer(1.0, Page_RemoveAlwaysTransmit, EntIndexToEntRef(page2), TIMER_FLAG_NO_MAPCHANGE);
				SDKHook(page2, SDKHook_SetTransmit, Hook_SlenderObjectSetTransmitEx);

				if (pageAnimation[0] != '\0')
				{
					SetVariantString(pageAnimation);
					AcceptEntityInput(page2, "SetDefaultAnimation");
					SetVariantString(pageAnimation);
					AcceptEntityInput(page2, "SetAnimation");
				}
			}

			// Create actual page entity
			page = CreateEntityByName("prop_dynamic_override");
			if (page != -1)
			{
				FormatEx(pageName, sizeof(pageName), "sf2_page_%d", i);
				DispatchKeyValue(page, "targetname", pageName);
				DispatchKeyValue(page, "parentname", pageParentName);
				DispatchKeyValue(page, "solid", "2");
				SetEntityModel(page, pageModel);
				TeleportEntity(page, pos, angle, NULL_VECTOR);
				DispatchSpawn(page);
				ActivateEntity(page);
				SetVariantInt(pageSkin);
				AcceptEntityInput(page, "Skin");
				SetVariantInt(pageBodygroup);
				AcceptEntityInput(page, "SetBodyGroup");
				AcceptEntityInput(page, "EnableCollision");
				SetEntPropFloat(page, Prop_Send, "m_flModelScale", pageModelScale);
				SetEntPropEnt(page, Prop_Send, "m_hOwnerEntity", page2);
				SetEntPropEnt(page, Prop_Send, "m_hEffectEntity", page2);
				SetEntProp(page, Prop_Send, "m_fEffects", EF_ITEM_BLINK);
				SetEntityRenderMode(page, pageRenderMode);
				SetEntityRenderFx(page, pageRenderFx);
				SetEntityRenderColor(page, pageRenderColor[0], pageRenderColor[1], pageRenderColor[2], pageRenderColor[3]);

				SDKHook(page, SDKHook_OnTakeDamage, Hook_PageOnTakeDamage);
				SDKHook(page, SDKHook_SetTransmit, Hook_SlenderObjectSetTransmit);

				if (pageAnimation[0] != '\0')
				{
					SetVariantString(pageAnimation);
					AcceptEntityInput(page, "SetDefaultAnimation");
					SetVariantString(pageAnimation);
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

				g_Pages.PushArray(pageData, sizeof(pageData));
			}

			int index = g_EmptySpawnPagePoints.FindValue(EntRefToEntIndex(spawnPointEnt));
			if (index != -1)
			{
				g_EmptySpawnPagePoints.Erase(index);
			}
		}

		// Safely remove all handles.
		for (int i = 0, size = array.Length; i < size; i++)
		{
			if (array.Get(i, 1) != 0)
			{
				delete view_as<ArrayList>(array.Get(i));
			}
		}

		Call_StartForward(g_OnPagesSpawnedFwd);
		Call_Finish();
	}

	delete pageGroupsByName;
	delete array;
}

static Action Page_RemoveAlwaysTransmit(Handle timer, int ref)
{
	int page = EntRefToEntIndex(ref);
	if (page && page != INVALID_ENT_REFERENCE)
	{
		//All the pages are now "registred" by the client, nuke the always transmit flag.
		CBaseEntity(page).DispatchUpdateTransmitState();
	}
	return Plugin_Stop;
}

static bool HandleSpecialRoundState()
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START HandleSpecialRoundState()");
	}
	#endif

	bool old = g_IsSpecialRound;
	bool continuousOld = g_IsSpecialRoundContinuous;
	g_IsSpecialRound = false;
	g_IsSpecialRoundNew = false;
	g_IsSpecialRoundContinuous = false;

	bool forceNew = false;

	if (old)
	{
		if (continuousOld)
		{
			// Check if there are players who haven't played the special round yet.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || !IsClientParticipating(i))
				{
					g_PlayerPlayedSpecialRound[i] = true;
					continue;
				}

				if (!g_PlayerPlayedSpecialRound[i])
				{
					// Someone didn't get to play this yet. Continue the special round.
					g_IsSpecialRound = true;
					g_IsSpecialRoundContinuous = true;
					break;
				}
			}
		}
	}

	int roundInterval = g_SpecialRoundIntervalConVar.IntValue;

	if (roundInterval > 0 && g_SpecialRoundCount >= roundInterval)
	{
		g_IsSpecialRound = true;
		forceNew = true;
	}

	// Do special round force override and reset it.
	if (g_SpecialRoundForceConVar.IntValue >= 0)
	{
		g_IsSpecialRound = g_SpecialRoundForceConVar.BoolValue;
		g_SpecialRoundForceConVar.SetInt(-1);
	}

	if (g_IsSpecialRound)
	{
		if (forceNew || !old || !continuousOld)
		{
			g_IsSpecialRoundNew = true;
		}

		if (g_IsSpecialRoundNew)
		{
			if (g_SpecialRoundBehaviorConVar.IntValue == 1)
			{
				g_IsSpecialRoundContinuous = true;
			}
			else
			{
				// new special round, but it's not continuous.
				g_IsSpecialRoundContinuous = false;
			}
		}
	}
	else
	{
		g_IsSpecialRoundContinuous = false;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END HandleSpecialRoundState() -> g_IsSpecialRound = %d (count = %d, new = %d, continuous = %d)", g_IsSpecialRound, g_SpecialRoundCount, g_IsSpecialRoundNew, g_IsSpecialRoundContinuous);
	}
	#endif
	return true;
}
/*
bool IsNewBossRoundRunning()
{
	return g_NewBossRound;
}
*/
/**
 *	Returns an array which contains all the profile names valid to be chosen for a new boss round.
 */
static ArrayList GetNewBossRoundProfileList()
{
	ArrayList bossList = GetSelectableBossProfileQueueList().Clone();

	if (bossList.Length > 0)
	{
		char mainBoss[SF2_MAX_PROFILE_NAME_LENGTH];
		g_BossMainConVar.GetString(mainBoss, sizeof(mainBoss));

		int index = bossList.FindString(mainBoss);
		if (index != -1)
		{
			// Main boss exists; remove him from the list.
			bossList.Erase(index);
		}
		/*else
		{
			// Main boss doesn't exist; remove the first boss from the list.
			bossList.Erase(0);
		}*/
	}

	return bossList;
}

static void HandleNewBossRoundState()
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START HandleNewBossRoundState()");
	}
	#endif

	bool old = g_NewBossRound;
	bool continuousOld = g_NewBossRoundContinuous;
	g_NewBossRound = false;
	g_NewBossRoundNew = false;
	g_NewBossRoundContinuous = false;

	bool forceNew = false;

	if (old)
	{
		if (continuousOld)
		{
			// Check if there are players who haven't played the boss round yet.
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsValidClient(i) || !IsClientParticipating(i))
				{
					g_PlayerPlayedNewBossRound[i] = true;
					continue;
				}

				if (!g_PlayerPlayedNewBossRound[i])
				{
					// Someone didn't get to play this yet. Continue the boss round.
					g_NewBossRound = true;
					g_NewBossRoundContinuous = true;
					break;
				}
			}
		}
	}

	// Don't force a new special round while a continuous round is going on.
	if (!g_NewBossRoundContinuous)
	{
		int roundInterval = g_NewBossRoundIntervalConVar.IntValue;

		if (/*roundInterval > 0 &&*/roundInterval <= 0 || g_NewBossRoundCount >= roundInterval)
		{
			g_NewBossRound = true;
			forceNew = true;
		}
	}

	// Do boss round force override and reset it.
	if (g_NewBossRoundForceConVar.IntValue >= 0)
	{
		g_NewBossRound = g_NewBossRoundForceConVar.BoolValue;
		g_NewBossRoundForceConVar.SetInt(-1);
	}

	// Check if we have enough bosses.
	if (g_NewBossRound)
	{
		ArrayList bossList = GetNewBossRoundProfileList().Clone();

		if (bossList.Length < 1)
		{
			g_NewBossRound = false; // Not enough bosses.
		}

		delete bossList;
	}

	if (g_NewBossRound)
	{
		if (forceNew || !old || !continuousOld)
		{
			g_NewBossRoundNew = true;
		}

		if (g_NewBossRoundNew)
		{
			if (g_NewBossRoundBehaviorConVar.IntValue == 1)
			{
				g_NewBossRoundContinuous = true;
			}
			else
			{
				// new "new boss round", but it's not continuous.
				g_NewBossRoundContinuous = false;
			}
		}
	}
	else
	{
		g_NewBossRoundContinuous = false;
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END HandleintBossRoundState() -> g_NewBossRound = %d (count = %d, int = %d, continuous = %d)", g_NewBossRound, g_NewBossRoundCount, g_NewBossRoundNew, g_NewBossRoundContinuous);
	}
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
		if (!IsValidClient(i) || !IsClientParticipating(i))
		{
			continue;
		}

		if (!g_PlayerEliminated[i])
		{
			count++;
		}
	}

	return count;
}

static void SelectStartingBossesForRound()
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START SelectStartingBossesForRound()");
	}
	#endif

	ArrayList selectableBossList = GetSelectableBossProfileQueueList().Clone();

	// Select which boss profile to use.
	char profileOverride[SF2_MAX_PROFILE_NAME_LENGTH];
	g_BossProfileOverrideConVar.GetString(profileOverride, sizeof(profileOverride));

	if (!SF_IsBoxingMap())
	{
		if (profileOverride[0] != '\0' && IsProfileValid(profileOverride))
		{
			// Pick the overridden boss.
			strcopy(g_RoundBossProfile, sizeof(g_RoundBossProfile), profileOverride);
			g_BossProfileOverrideConVar.SetString("");
		}
		else if (g_NewBossRound)
		{
			if (g_NewBossRoundNew)
			{
				ArrayList bossList = GetNewBossRoundProfileList();

				bossList.GetString(GetRandomInt(0, bossList.Length - 1), g_NewBossRoundProfileRoundProfile, sizeof(g_NewBossRoundProfileRoundProfile));

				delete bossList;
			}

			strcopy(g_RoundBossProfile, sizeof(g_RoundBossProfile), g_NewBossRoundProfileRoundProfile);
		}
		else
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			g_BossMainConVar.GetString(profile, sizeof(profile));

			if (profile[0] != '\0' && IsProfileValid(profile))
			{
				strcopy(g_RoundBossProfile, sizeof(g_RoundBossProfile), profile);
			}
			else
			{
				if (selectableBossList.Length > 0)
				{
					// Pick the first boss in our array if the main boss doesn't exist.
					selectableBossList.GetString(0, g_RoundBossProfile, sizeof(g_RoundBossProfile));
				}
				else
				{
					// No bosses to pick. What?
					g_RoundBossProfile[0] = '\0';
				}
			}
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 0)
		{
			DebugMessage("END SelectStartingBossesForRound() -> boss: %s", g_RoundBossProfile);
		}
		#endif
	}
	else if (SF_IsBoxingMap())
	{
		if (profileOverride[0] != '\0' && IsProfileValid(profileOverride))
		{
			// Pick the overridden boss.
			strcopy(g_RoundBoxingBossProfile, sizeof(g_RoundBoxingBossProfile), profileOverride);
			g_BossProfileOverrideConVar.SetString("");
		}
		else if (g_NewBossRound)
		{
			if (g_NewBossRoundNew)
			{
				ArrayList bossList = GetNewBossRoundProfileList();

				bossList.GetString(GetRandomInt(0, bossList.Length - 1), g_NewBossRoundProfileRoundProfile, sizeof(g_NewBossRoundProfileRoundProfile));

				delete bossList;
			}

			strcopy(g_RoundBoxingBossProfile, sizeof(g_RoundBoxingBossProfile), g_NewBossRoundProfileRoundProfile);
		}
		else
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			g_BossMainConVar.GetString(profile, sizeof(profile));

			if (profile[0] != '\0' && IsProfileValid(profile))
			{
				strcopy(g_RoundBoxingBossProfile, sizeof(g_RoundBoxingBossProfile), profile);
			}
			else
			{
				if (selectableBossList.Length > 0)
				{
					// Pick the first boss in our array if the main boss doesn't exist.
					selectableBossList.GetString(0, g_RoundBoxingBossProfile, sizeof(g_RoundBoxingBossProfile));
				}
				else
				{
					// No bosses to pick. What?
					g_RoundBoxingBossProfile[0] = '\0';
				}
			}
		}

		#if defined DEBUG
		if (g_DebugDetailConVar.IntValue > 0)
		{
			DebugMessage("END SelectStartingBossesForRound() -> boss: %s", g_RoundBoxingBossProfile);
		}
		#endif
	}
	delete selectableBossList;
}

static void GetRoundIntroParameters()
{
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "env_fade")) != -1)
	{
		char name[32];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, "sf2_intro_fade", false) == 0)
		{
			int colorOffset = FindSendPropInfo("CBaseEntity", "m_clrRender");
			if (colorOffset != -1)
			{
				g_RoundIntroFadeColor[0] = GetEntData(ent, colorOffset, 1);
				g_RoundIntroFadeColor[1] = GetEntData(ent, colorOffset + 1, 1);
				g_RoundIntroFadeColor[2] = GetEntData(ent, colorOffset + 2, 1);
				g_RoundIntroFadeColor[3] = GetEntData(ent, colorOffset + 3, 1);
			}

			g_RoundIntroFadeHoldTime = GetEntPropFloat(ent, Prop_Data, "m_HoldTime");
			g_RoundIntroFadeDuration = GetEntPropFloat(ent, Prop_Data, "m_Duration");

			break;
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "ambient_generic")) != -1)
	{
		char name[64];
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));

		if (strcmp(name, "sf2_intro_music", false) == 0)
		{
			char songPath[PLATFORM_MAX_PATH];
			GetEntPropString(ent, Prop_Data, "m_iszSound", songPath, sizeof(songPath));

			if (songPath[0] == '\0')
			{
				LogError("Found sf2_intro_music entity, but it has no sound path specified! Default intro music will be used instead.");
			}
			else
			{
				strcopy(g_RoundIntroMusic, sizeof(g_RoundIntroMusic), songPath);
			}

			break;
		}
	}
}

static void GetRoundEscapeParameters()
{
	g_RoundEscapePointEntity = INVALID_ENT_REFERENCE;

	char name[64];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (!StrContains(name, "sf2_escape_spawnpoint", false))
		{
			g_RoundEscapePointEntity = EntIndexToEntRef(ent);
			break;
		}
	}
}

void InitializeNewGame()
{
	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("START InitializeNewGame()");
	}
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
		g_SlenderBoxingBossCount = 0;
		g_SlenderBoxingBossKilled = 0;
	}
	else if (SF_IsRenevantMap())
	{
		g_RenevantWaveTimer = null;
		g_RenevantMultiEffect = false;
		g_RenevantWallHax = false;
		g_RenevantBeaconEffect = false;
		g_Renevant90sEffect = false;
		g_RenevantMarkForDeath = false;
		g_RenevantBossesChaseEndlessly = false;

		Renevant_SetWave(0);
	}

	if (g_RenevantWaveList != null)
	{
		delete g_RenevantWaveList;
	}

	// Choose round state.
	if (g_IntroEnabledConVar.BoolValue)
	{
		// Set the round state to the intro stage.
		SetRoundState(SF2RoundState_Intro);
	}
	else
	{
		SetRoundState(SF2RoundState_Grace);
		SF2_RefreshRestrictions();
	}

	if (g_RoundActiveCount == 1)
	{
		g_BossProfileOverrideConVar.SetString("");
	}

	HandleSpecialRoundState();

	// Was a new special round initialized?
	if (g_IsSpecialRound && !SF_IsRenevantMap() && !SF_IsBoxingMap() && !SF_IsRaidMap())
	{
		if (g_IsSpecialRoundNew)
		{
			// Reset round count.
			g_SpecialRoundCount = 1;

			if (g_IsSpecialRoundContinuous)
			{
				// It's the start of a continuous special round.

				// Initialize all players' values.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i) || !IsClientParticipating(i))
					{
						g_PlayerPlayedSpecialRound[i] = true;
						continue;
					}

					g_PlayerPlayedSpecialRound[i] = false;
				}
			}

			SpecialRoundCycleStart();
		}
		else
		{
			SpecialRoundStart();

			if (g_IsSpecialRoundContinuous)
			{
				// Display the current special round going on to late players.
				CreateTimer(3.0, Timer_DisplaySpecialRound);
			}
		}
	}
	else
	{
		g_SpecialRoundCount++;

		SpecialRoundReset();
	}

	// Determine boss round state.
	HandleNewBossRoundState();

	if (g_NewBossRound)
	{
		if (g_NewBossRoundNew)
		{
			// Reset round count;
			g_NewBossRoundCount = 1;

			if (g_NewBossRoundContinuous)
			{
				// It's the start of a continuous "new boss round".

				// Initialize all players' values.
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsValidClient(i) || !IsClientParticipating(i))
					{
						g_PlayerPlayedNewBossRound[i] = true;
						continue;
					}

					g_PlayerPlayedNewBossRound[i] = false;
				}
			}
		}
	}
	else
	{
		g_NewBossRoundCount++;
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
				if (!g_PlayerEliminated[i])
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
			if (!IsValidClient(i))
			{
				continue;
			}

			if (!g_PlayerEliminated[i])
			{
				if (!IsFakeClient(i))
				{
					// Currently in intro state, play intro music.
					g_PlayerIntroMusicTimer[i] = CreateTimer(0.5, Timer_PlayIntroMusicToPlayer, GetClientUserId(i));
				}
				else
				{
					g_PlayerIntroMusicTimer[i] = null;
				}
			}
			else
			{
				g_PlayerIntroMusicTimer[i] = null;
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
				if (SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) || SF_SpecialRound(SPECIALROUND_SILENTSLENDER) || SF_SpecialRound(SPECIALROUND_2DOUBLE))
				{
					AddProfile(g_RoundBossProfile);
					RemoveBossProfileFromQueueList(g_RoundBossProfile);
				}
				else if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
				{
					AddProfile(g_RoundBossProfile);
					AddProfile(g_RoundBossProfile, _, _, _, false);
					AddProfile(g_RoundBossProfile, _, _, _, false);
					RemoveBossProfileFromQueueList(g_RoundBossProfile);
				}
				else if (!SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_SILENTSLENDER) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
				{
					AddProfile(g_RoundBossProfile);
					RemoveBossProfileFromQueueList(g_RoundBossProfile);
				}
			}
			else if (SF_IsBoxingMap())
			{
				char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
				ArrayList selectableBosses = GetSelectableBoxingBossProfileList().Clone();
				if (selectableBosses.Length > 0)
				{
					selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
					AddProfile(buffer);
				}
				delete selectableBosses;
			}
		}
	}

	#if defined DEBUG
	if (g_DebugDetailConVar.IntValue > 0)
	{
		DebugMessage("END InitializeNewGame()");
	}
	#endif
}

static Action Timer_PlayIntroMusicToPlayer(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);
	if (client <= 0)
	{
		return Plugin_Stop;
	}

	if (timer != g_PlayerIntroMusicTimer[client])
	{
		return Plugin_Stop;
	}

	g_PlayerIntroMusicTimer[client] = null;

	EmitSoundToClient(client, g_RoundIntroMusic, _, MUSIC_CHAN, SNDLEVEL_NONE);

	return Plugin_Stop;
}

static void StartIntroTextSequence()
{
	g_RoundIntroText = 1;
	g_RoundIntroTextDefault = false;
	g_RoundIntroTextTimer = null;

	if (g_GamerulesEntity.IsValid())
	{
		SF2GameTextEntity textEntity = g_GamerulesEntity.IntroTextEntity;
		if (textEntity.IsValid())
		{
			g_RoundIntroTextTimer = CreateTimer(g_GamerulesEntity.IntroTextDelay, Timer_NewIntroTextSequence, EntIndexToEntRef(textEntity.index), TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	if (g_RoundIntroTextTimer == null)
	{
		// Use old intro text sequence.
		g_RoundIntroTextTimer = CreateTimer(0.0, Timer_IntroTextSequence, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

static Action Timer_NewIntroTextSequence(Handle timer, any data)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}
	if (g_RoundIntroTextTimer != timer)
	{
		return Plugin_Stop;
	}

	SF2GameTextEntity textEntity = SF2GameTextEntity(EntRefToEntIndex(data));
	if (!textEntity.IsValid())
	{
		return Plugin_Stop;
	}

	int clients[MAXTF2PLAYERS];
	int clientsNum;

	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsValidClient(client) || g_PlayerEliminated[client])
		{
			continue;
		}

		clients[clientsNum] = client;
		clientsNum++;
	}

	char message[512];
	textEntity.GetIntroMessage(message, sizeof(message));
	ShowHudTextUsingTextEntity(clients, clientsNum, textEntity.index, g_HudSync, message);

	SF2GameTextEntity nextTextEntity = textEntity.NextIntroTextEntity;
	if (nextTextEntity.IsValid())
	{
		float duration = textEntity.GetPropFloat(Prop_Data, "m_textParms.fadeinTime")
		 + textEntity.GetPropFloat(Prop_Data, "m_textParms.fadeoutTime")
		 + textEntity.GetPropFloat(Prop_Data, "m_textParms.holdTime")
		 + textEntity.NextIntroTextDelay;

		g_RoundIntroTextTimer = CreateTimer(duration, Timer_NewIntroTextSequence, EntIndexToEntRef(nextTextEntity.index), TIMER_FLAG_NO_MAPCHANGE);
	}

	return Plugin_Continue;
}

static Action Timer_IntroTextSequence(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}
	if (g_RoundIntroTextTimer != timer)
	{
		return Plugin_Stop;
	}

	float duration = 0.0;

	if (g_RoundIntroText != 0)
	{
		bool foundGameText = false;

		int clients[MAXTF2PLAYERS];
		int clientsNum;

		for (int i = 1; i <= MaxClients; i++)
		{
			SF2_BasePlayer player = SF2_BasePlayer(i);
			if (!player.IsValid || player.IsEliminated)
			{
				continue;
			}

			clients[clientsNum] = i;
			clientsNum++;
		}

		if (!g_RoundIntroTextDefault)
		{
			char targetname[64];
			FormatEx(targetname, sizeof(targetname), "sf2_intro_text_%d", g_RoundIntroText);

			int gameText = FindEntityByTargetname(targetname, "game_text");
			if (gameText && gameText != INVALID_ENT_REFERENCE)
			{
				foundGameText = true;
				duration = GetEntPropFloat(gameText, Prop_Data, "m_textParms.fadeinTime") + GetEntPropFloat(gameText, Prop_Data, "m_textParms.fadeoutTime") + GetEntPropFloat(gameText, Prop_Data, "m_textParms.holdTime");

				char message[512];
				GetEntPropString(gameText, Prop_Data, "m_iszMessage", message, sizeof(message));
				ShowHudTextUsingTextEntity(clients, clientsNum, gameText, g_HudSync, message);
			}
		}
		else
		{
			if (g_RoundIntroText == 2)
			{
				foundGameText = false;

				char message[64];
				GetCurrentMap(message, sizeof(message));

				for (int i = 0; i < clientsNum; i++)
				{
					ClientShowMainMessage(clients[i], message, 1);
				}
			}
		}

		if (g_RoundIntroText == 1 && !foundGameText)
		{
			// Use default intro sequence. Eugh.
			g_RoundIntroTextDefault = true;
			duration = g_IntroDefaultHoldTimeConVar.FloatValue / 2.0;

			for (int i = 0; i < clientsNum; i++)
			{
				EmitSoundToClient(clients[i], SF2_INTRO_DEFAULT_MUSIC, _, MUSIC_CHAN, SNDLEVEL_NONE);
			}
		}
		else
		{
			if (!foundGameText)
			{
				return Plugin_Stop; // done with sequence; don't check anymore.
			}
		}
	}

	g_RoundIntroText++;
	g_RoundIntroTextTimer = CreateTimer(duration, Timer_IntroTextSequence, _, TIMER_FLAG_NO_MAPCHANGE);

	return Plugin_Stop;
}

static Action Timer_ActivateRoundFromIntro(Handle timer)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}
	if (g_RoundIntroTimer != timer)
	{
		return Plugin_Stop;
	}

	// Obviously we don't want to spawn the boss when g_RoundBossProfile isn't set yet.
	SetRoundState(SF2RoundState_Grace);
	SF2_RefreshRestrictions();

	// Spawn the boss!
	if (!SF_SpecialRound(SPECIALROUND_MODBOSSES))
	{
		if (!SF_IsBoxingMap() && !SF_IsRenevantMap())
		{
			if (SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) || SF_SpecialRound(SPECIALROUND_SILENTSLENDER) || SF_SpecialRound(SPECIALROUND_2DOUBLE))
			{
				AddProfile(g_RoundBossProfile);
				RemoveBossProfileFromQueueList(g_RoundBossProfile);
			}
			else if (SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				AddProfile(g_RoundBossProfile);
				AddProfile(g_RoundBossProfile, _, _, _, false);
				AddProfile(g_RoundBossProfile, _, _, _, false);
				RemoveBossProfileFromQueueList(g_RoundBossProfile);
			}
			else if (!SF_SpecialRound(SPECIALROUND_DOUBLETROUBLE) && !SF_SpecialRound(SPECIALROUND_SILENTSLENDER) && !SF_SpecialRound(SPECIALROUND_2DOUBLE) && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				AddProfile(g_RoundBossProfile);
				RemoveBossProfileFromQueueList(g_RoundBossProfile);
			}
		}
		else if (SF_IsBoxingMap())
		{
			char buffer[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList selectableBosses = GetSelectableBoxingBossProfileList().Clone();
			if (selectableBosses.Length > 0)
			{
				selectableBosses.GetString(GetRandomInt(0, selectableBosses.Length - 1), buffer, sizeof(buffer));
				AddProfile(buffer);
			}
			delete selectableBosses;
		}
	}
	return Plugin_Stop;
}

void CheckRoundWinConditions()
{
	if (IsRoundInWarmup() || IsRoundEnding() || g_IgnoreRoundWinConditionsConVar.BoolValue)
	{
		return;
	}

	int totalCount = 0;
	int aliveCount = 0;
	int escapedCount = 0;

	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsValidClient(i))
		{
			continue;
		}
		totalCount++;
		if (!SF_SpecialRound(SPECIALROUND_1UP))
		{
			if (!g_PlayerEliminated[i] && !IsClientInDeathCam(i))
			{
				aliveCount++;
				if (DidClientEscape(i))
				{
					escapedCount++;
				}
			}
		}
		else
		{
			if (!g_PlayerEliminated[i] && !IsClientInDeathCam(i) && !g_PlayerFullyDied1Up[i])
			{
				aliveCount++;
				if (DidClientEscape(i))
				{
					escapedCount++;
				}
			}
		}
	}

	if (aliveCount == 0)
	{
		ForceTeamWin(TFTeam_Blue);
	}
	else
	{
		if (g_RoundHasEscapeObjective)
		{
			if (escapedCount == aliveCount)
			{
				ForceTeamWin(TFTeam_Red);
			}
		}
		else
		{
			if (g_PageMax > 0 && g_PageCount == g_PageMax)
			{
				ForceTeamWin(TFTeam_Red);
			}
		}
	}
}
