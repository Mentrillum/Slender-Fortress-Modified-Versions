#if defined _sf2_mapentities_included
 #endinput
#endif
#define _sf2_mapentities_included

#pragma semicolon 1

//#define DEBUG_MAPENTITIES

static PrivateForward g_CustomEntityOnMapStartPFwd;
static PrivateForward g_CustomEntityOnRoundStateChangedPFwd;
static PrivateForward g_CustomEntityOnDifficultyChangedPFwd;
static PrivateForward g_CustomEntityOnPageCountChangedPFwd;

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
		return SDKCall(g_SDKPassesTriggerFilters, this.index, entity) != 0;
	}

	property bool IsDisabled
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_bDisabled") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_bDisabled", value);
		}
	}
}

enum SF2MapEntityHook
{
	SF2MapEntityHook_OnMapStart,
	SF2MapEntityHook_OnRoundStateChanged,
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
		{
			g_CustomEntityOnMapStartPFwd.AddFunction(null, hookFunc);
		}
		case SF2MapEntityHook_OnRoundStateChanged:
		{
			g_CustomEntityOnRoundStateChangedPFwd.AddFunction(null, hookFunc);
		}
		case SF2MapEntityHook_OnDifficultyChanged:
		{
			g_CustomEntityOnDifficultyChangedPFwd.AddFunction(null, hookFunc);
		}
		case SF2MapEntityHook_OnPageCountChanged:
		{
			g_CustomEntityOnPageCountChangedPFwd.AddFunction(null, hookFunc);
		}
		case SF2MapEntityHook_OnRenevantWaveTriggered:
		{
			g_CustomEntityOnRenevantWaveTriggered.AddFunction(null, hookFunc);
		}
		default:
		{
			ThrowError("Unhandled hooktype %i", hookType);
		}
	}
}

#include "mapentities/base_spawnpoint.sp"
#include "mapentities/sf2_game_text.sp"
#include "mapentities/sf2_gamerules.sp"
#include "mapentities/sf2_trigger_escape.sp"
#include "mapentities/sf2_info_player_escapespawn.sp"
#include "mapentities/sf2_trigger_pvp.sp"
#include "mapentities/sf2_trigger_pve.sp"
#include "mapentities/sf2_info_player_pvpspawn.sp"
#include "mapentities/sf2_info_player_proxyspawn.sp"
#include "mapentities/sf2_info_boss_spawn.sp"
#include "mapentities/sf2_info_page_spawn.sp"
#include "mapentities/sf2_info_page_music.sp"
#include "mapentities/sf2_logic_proxy.sp"
#include "mapentities/sf2_logic_raid.sp"
#include "mapentities/sf2_boss_maker.sp"
#include "mapentities/sf2_trigger_boss_despawn.sp"

// Modified only
#include "mapentities/sf2_logic_arena.sp"
#include "mapentities/sf2_logic_boxing.sp"
#include "mapentities/sf2_logic_slaughter.sp"
#include "mapentities/sf2_point_spotlight.sp"

void SetupCustomMapEntities()
{
	g_CustomEntityOnMapStartPFwd = new PrivateForward(ET_Ignore);
	g_CustomEntityOnRoundStateChangedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnDifficultyChangedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnPageCountChangedPFwd = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);

	g_CustomEntityOnRenevantWaveTriggered = new PrivateForward(ET_Ignore, Param_Cell);

	g_OnMapStartPFwd.AddFunction(null, MapStart);

	g_DifficultyConVar.AddChangeHook(SF2MapEntity_OnDifficultyChanged);

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

	// sf2_trigger_pve
	SF2TriggerPvEEntity.Initialize();

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

	// sf2_point_spotlight
	SF2PointSpotlightEntity.Initialize();
}

static void MapStart()
{
	Call_StartForward(g_CustomEntityOnMapStartPFwd);
	Call_Finish();
}

static int FindProceduralTarget(const char[] name, int searchingEntity, int activator, int caller)
{
	if (name[0] != '!')
	{
		return -1;
	}

	if ( strcmp( name, "!activator" ) == 0 )
	{
		return activator;
	}
	else if ( strcmp( name, "!caller" ) == 0)
	{
		return caller;
	}
	else if ( strcmp( name, "!self" ) == 0)
	{
		return searchingEntity;
	}
	else
	{
		char class[PLATFORM_MAX_PATH];
		if (IsValidEntity(searchingEntity))
		{
			GetEntPropString(searchingEntity, Prop_Data, "m_iClassname", class, sizeof(class));
		}
		else
		{
			strcopy(class, sizeof(class), "NULL Entity");
		}

		// Normally if you enter an invalid procedural name the game would just crash.
		// For custom entities we'll just spit out a message in console instead.
		// So much nicer, don't you think?

		LogSF2Message("%i (%s): Invalid entity search name %s", searchingEntity, class, name);
	}

	return -1;
}

int SF2MapEntity_FindEntityByTargetname(int startEnt, const char[] name, int searchingEntity, int activator, int caller)
{
	if (name[0] == '!')
	{
		if (startEnt == -1)
		{
			int target = FindProceduralTarget(name, searchingEntity, activator, caller);
			if (IsValidEntity(target))
			{
				return target;
			}
		}

		return -1;
	}

	// dear god

	char targetName[PLATFORM_MAX_PATH];
	int ent = startEnt;
	while ((ent = FindEntityByClassname(ent, "*")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", targetName, sizeof(targetName));
		if (strcmp(targetName, name) == 0)
		{
			return ent;
		}
	}

	return -1;
}

void SF2MapEntity_OnRoundStateChanged(SF2RoundState roundState, SF2RoundState oldRoundState)
{
	Call_StartForward(g_CustomEntityOnRoundStateChangedPFwd);
	Call_PushCell(roundState);
	Call_PushCell(oldRoundState);
	Call_Finish();
}

static void SF2MapEntity_OnDifficultyChanged(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	int oldDifficulty = StringToInt(oldValue);
	int difficulty = StringToInt(newValue);

	Call_StartForward(g_CustomEntityOnDifficultyChangedPFwd);
	Call_PushCell(difficulty);
	Call_PushCell(oldDifficulty);
	Call_Finish();
}

void SF2MapEntity_OnPageCountChanged(int pageCount, int oldPageCount)
{
	Call_StartForward(g_CustomEntityOnPageCountChangedPFwd);
	Call_PushCell(pageCount);
	Call_PushCell(oldPageCount);
	Call_Finish();
}

void SF2MapEntity_OnRenevantWaveTriggered(int wave)
{
	Call_StartForward(g_CustomEntityOnRenevantWaveTriggered);
	Call_PushCell(wave);
	Call_Finish();
}

/*
void SF2MapEntity_InitGameData(GameData hConfig)
{
}
*/

#undef DEBUG_MAPENTITIES