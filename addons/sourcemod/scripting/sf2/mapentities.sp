#if defined _sf2_mapentities_included
 #endinput
#endif
#define _sf2_mapentities_included

//#define DEBUG_MAPENTITIES

static PrivateForward g_CustomEntityOnMapStart;
static PrivateForward g_CustomEntityOnRoundStateChanged;
static PrivateForward g_CustomEntityOnGracePeriodEnd;
static PrivateForward g_CustomEntityOnDifficultyChanged;
static PrivateForward g_CustomEntityOnPageCountChanged;

static PrivateForward g_CustomEntityOnRenevantWaveTriggered;

/**
 * A custom map entity for SF2.
 */
methodmap SF2MapEntity < CBaseEntity
{
	public SF2MapEntity(int entIndex) 
	{
		return view_as<SF2MapEntity>(EnsureEntRef(entIndex));
	}
}

methodmap SF2TriggerMapEntity < CBaseEntity
{
	public SF2TriggerMapEntity(int entIndex)
	{
		return view_as<SF2TriggerMapEntity>(CBaseEntity(entIndex));
	}

	public bool PassesTriggerFilters(int entity)
	{
		return !!SDKCall(g_hSDKPassesTriggerFilters, this.index, entity);
	}

	property bool IsDisabled
	{
		public get() { return !!this.GetProp(Prop_Data, "m_bDisabled"); }
		public set(bool value) { this.SetProp(Prop_Data, "m_bDisabled", value); }
	}
}

enum SF2MapEntityHook
{
	SF2MapEntityHook_OnMapStart,
	SF2MapEntityHook_OnRoundStateChanged,
	SF2MapEntityHook_OnGracePeriodEnd,
	SF2MapEntityHook_OnDifficultyChanged,
	SF2MapEntityHook_OnPageCountChanged,
	SF2MapEntityHook_OnRenevantWaveTriggered,
	SF2MapEntityHook_Max
}

void SF2MapEntity_AddHook(SF2MapEntityHook hookType, Function hookFunc)
{
	switch (hookType)
	{
		case SF2MapEntityHook_OnMapStart:
			g_CustomEntityOnMapStart.AddFunction(null, hookFunc);
		case SF2MapEntityHook_OnRoundStateChanged:
			g_CustomEntityOnRoundStateChanged.AddFunction(null, hookFunc);
		case SF2MapEntityHook_OnGracePeriodEnd:
			g_CustomEntityOnGracePeriodEnd.AddFunction(null, hookFunc);
		case SF2MapEntityHook_OnDifficultyChanged:
			g_CustomEntityOnDifficultyChanged.AddFunction(null, hookFunc);
		case SF2MapEntityHook_OnPageCountChanged:
			g_CustomEntityOnPageCountChanged.AddFunction(null, hookFunc);
		
		case SF2MapEntityHook_OnRenevantWaveTriggered:
			g_CustomEntityOnRenevantWaveTriggered.AddFunction(null, hookFunc);
		
		default:
			ThrowError("Unhandled hooktype %i", hookType);
	}
}

#include "sf2/mapentities/base_spawnpoint.sp"
#include "sf2/mapentities/sf2_game_text.sp"
#include "sf2/mapentities/sf2_gamerules.sp"
#include "sf2/mapentities/sf2_trigger_escape.sp"
#include "sf2/mapentities/sf2_info_player_escapespawn.sp"
#include "sf2/mapentities/sf2_trigger_pvp.sp"
#include "sf2/mapentities/sf2_info_player_pvpspawn.sp"
#include "sf2/mapentities/sf2_info_player_proxyspawn.sp"
#include "sf2/mapentities/sf2_info_boss_spawn.sp"
#include "sf2/mapentities/sf2_info_page_spawn.sp"
#include "sf2/mapentities/sf2_info_page_music.sp"
#include "sf2/mapentities/sf2_logic_proxy.sp"
#include "sf2/mapentities/sf2_logic_raid.sp"
#include "sf2/mapentities/sf2_boss_maker.sp"
#include "sf2/mapentities/sf2_trigger_boss_despawn.sp"

// Modified only
#include "sf2/mapentities/sf2_logic_arena.sp"
#include "sf2/mapentities/sf2_logic_boxing.sp"
#include "sf2/mapentities/sf2_logic_slaughter.sp"

void SetupCustomMapEntities()
{
	g_CustomEntityOnMapStart = new PrivateForward(ET_Ignore);
	g_CustomEntityOnRoundStateChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnGracePeriodEnd = new PrivateForward(ET_Ignore);
	g_CustomEntityOnDifficultyChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnPageCountChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);

	g_CustomEntityOnRenevantWaveTriggered = new PrivateForward(ET_Ignore, Param_Cell);

	g_cvDifficulty.AddChangeHook(SF2MapEntity_OnDifficultyChanged);

	// Initialize static entity data.
	// Unfortunately, there's no better way to do it other than sticking the initialization functions here.

	SF2SpawnPointBaseEntity.Initialize();

	// sf2_game_text
	SF2GameTextEntity.Initialize();

	// sf2_gamerules
	SF2GamerulesEntity.Initialize();

	// sf2_trigger_escape
	SF2TriggerEscapeEntity.Initialize();

	// sf2_info_player_escapespawn
	SF2PlayerEscapeSpawnEntity.Initialize();

	// sf2_trigger_pvp
	SF2TriggerPvPEntity.Initialize();

	// sf2_info_player_pvpspawn
	SF2PlayerPvPSpawnEntity.Initialize();

	// sf2_info_player_proxyspawn
	SF2PlayerProxySpawnEntity.Initialize();

	// sf2_info_boss_spawn
	SF2BossSpawnEntity.Initialize();

	// sf2_info_page_spawn
	SF2PageSpawnEntity.Initialize();

	// sf2_info_page_music
	SF2PageMusicEntity.Initialize();

	// sf2_logic_proxy
	SF2LogicProxyEntity.Initialize();

	// sf2_logic_raid
	SF2LogicRaidEntity.Initialize();

	// sf2_boss_maker
	SF2BossMakerEntity.Initialize();

	// sf2_trigger_boss_despawn
	SF2TriggerBossDespawnEntity.Initialize();

	// Modified
	
	// sf2_logic_renevant
	SF2LogicRenevantEntity.Initialize();

	// sf2_logic_boxing
	SF2LogicBoxingEntity.Initialize();

	// sf2_logic_slaughter
	SF2LogicSlaughterEntity.Initialize();
}

void SF2MapEntity_OnMapStart()
{
	Call_StartForward(g_CustomEntityOnMapStart);
	Call_Finish();
}

static int FindProceduralTarget(const char[] sName, int searchingEntity, int activator, int caller)
{
	if (sName[0] != '!')
		return -1;
	
	if ( strcmp( sName, "!activator" ) == 0 )
	{
		return activator;
	}
	else if ( strcmp( sName, "!caller" ) == 0)
	{
		return caller;
	}
	else if ( strcmp( sName, "!self" ) == 0)
	{
		return searchingEntity;
	}
	else 
	{
		char sClass[PLATFORM_MAX_PATH];
		if (IsValidEntity(searchingEntity))
			GetEntPropString(searchingEntity, Prop_Data, "m_iClassname", sClass, sizeof(sClass));
		else
		{
			strcopy(sClass, sizeof(sClass), "NULL Entity");
		}

		// Normally if you enter an invalid procedural name the game would just crash.
		// For custom entities we'll just spit out a message in console instead.
		// So much nicer, don't you think?

		LogSF2Message("%i (%s): Invalid entity search name %s", searchingEntity, sClass, sName);
	}
	
	return -1;
}

int SF2MapEntity_FindEntityByTargetname(int startEnt, const char[] sName, int searchingEntity, int activator, int caller)
{
	if (sName[0] == '!')
	{
		if (startEnt == -1)
		{
			int target = FindProceduralTarget(sName, searchingEntity, activator, caller);
			if (IsValidEntity(target)) 
			{
				return target;
			}
		}

		return -1;
	}

	// dear god

	char sTargetName[PLATFORM_MAX_PATH];
	int ent = startEnt;
	while ((ent = FindEntityByClassname(ent, "*")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
		if (strcmp(sTargetName, sName) == 0) 
		{
			return ent;
		}
	}

	return -1;
}

void SF2MapEntity_OnRoundStateChanged(SF2RoundState iRoundState, SF2RoundState iOldRoundState)
{
	Call_StartForward(g_CustomEntityOnRoundStateChanged);
	Call_PushCell(iRoundState);
	Call_PushCell(iOldRoundState);
	Call_Finish();
}

static void SF2MapEntity_OnDifficultyChanged(ConVar cvar, const char[] sOldValue, const char[] sNewValue)
{
	int iOldDifficulty = StringToInt(sOldValue);
	int iDifficulty = StringToInt(sNewValue);

	Call_StartForward(g_CustomEntityOnDifficultyChanged);
	Call_PushCell(iDifficulty);
	Call_PushCell(iOldDifficulty);
	Call_Finish();
}

void SF2MapEntity_OnPageCountChanged(int iPageCount, int iOldPageCount)
{
	Call_StartForward(g_CustomEntityOnPageCountChanged);
	Call_PushCell(iPageCount);
	Call_PushCell(iOldPageCount);
	Call_Finish();
}

void SF2MapEntity_OnGracePeriodEnd()
{
	Call_StartForward(g_CustomEntityOnGracePeriodEnd);
	Call_Finish();
}

void SF2MapEntity_OnRenevantWaveTriggered(int iWave)
{
	Call_StartForward(g_CustomEntityOnRenevantWaveTriggered);
	Call_PushCell(iWave);
	Call_Finish();
}

/*
void SF2MapEntity_InitGameData(GameData hConfig) 
{
}
*/

#undef DEBUG_MAPENTITIES