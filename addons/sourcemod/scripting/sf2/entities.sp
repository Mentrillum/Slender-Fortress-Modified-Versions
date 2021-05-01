#if defined _sf2_mapentities_included
 #endinput
#endif
#define _sf2_mapentities_included

//#define DEBUG_MAPENTITIES

static bool g_bCustomEntity = false;
static char g_sCustomEntityOriginalClass[PLATFORM_MAX_PATH];

static ArrayList g_hCustomEntities;

static DynamicHook g_hSDKAcceptInput;
static DynamicHook g_hSDKKeyValue;
static DynamicDetour g_hSDKCreateEntityByName;

static PrivateForward g_CustomEntityTranslateClassname;
static PrivateForward g_CustomEntityInitialize;
static PrivateForward g_CustomEntityOnLevelInit;
static PrivateForward g_CustomEntityOnMapStart;
static PrivateForward g_CustomEntityOnAcceptEntityInput;
static PrivateForward g_CustomEntityOnEntityKeyValue;
static PrivateForward g_CustomEntityOnRoundStateChanged;
static PrivateForward g_CustomEntityOnGracePeriodEnd;
static PrivateForward g_CustomEntityOnDestroyed;
static PrivateForward g_CustomEntityOnDifficultyChanged;
static PrivateForward g_CustomEntityOnPageCountChanged;

static PrivateForward g_CustomEntityOnRenevantWaveTriggered;

static Handle g_hSDKPassesTriggerFilters;

/**
 *	A struct to be used with SF2MapEntity.FireOutput
 */
enum struct SF2MapEntityVariant
{
	int FieldType;
	int IntValue;
	float FloatValue;
	char StringValue[PLATFORM_MAX_PATH];

	void Init() 
	{
		this.FieldType = 0;
		this.IntValue = 0;
		this.FloatValue = 0.0;
		this.StringValue[0] = '\0';
	}

	void SetInt(int value) 
	{
		this.FieldType = 5;
		this.IntValue = value;
	}

	void SetFloat(float value) {
		this.FieldType = 1;
		this.FloatValue = value;
	}

	void SetString(const char[] value) {
		this.FieldType = 2;
		strcopy(this.StringValue, PLATFORM_MAX_PATH, value);
	}
}

static void SF2MapEntityVariant_Copy(SF2MapEntityVariant dest, SF2MapEntityVariant src)
{
	dest.FieldType = src.FieldType;
	dest.IntValue = src.IntValue;
	dest.FloatValue = src.FloatValue;
	strcopy(dest.StringValue, PLATFORM_MAX_PATH, src.StringValue);
}

/**
 * A custom map entity for SF2.
 */
methodmap SF2MapEntity
{
	public SF2MapEntity(int entIndex) 
	{
		return view_as<SF2MapEntity>(EnsureEntRef(entIndex));
	}

	property int EntRef 
	{
		public get()
		{ 
			return view_as<int>(this);
		}
	}

	property int EntIndex
	{
		public get()
		{
			int entIndex = view_as<int>(this);
			return (entIndex & (1 << 31)) ? EntRefToEntIndex(entIndex) : entIndex;
		}
	}

	public bool IsValid()
	{
		return IsValidEntity(this.EntRef);
	}

	public void AddOutput(const char[] szKeyName, const char[] szValue)
	{
		SF2MapEntity_AddOutput(this.EntRef, szKeyName, szValue);
	}

	public void FireOutput(const char[] szKeyName, int activator, int caller, SF2MapEntityVariant inputVariant)
	{
		SF2MapEntity_FireOutput(this.EntRef, szKeyName, activator, caller, inputVariant);
	}

	public void FireOutputNoVariant(const char[] szKeyName, int activator, int caller)
	{
		SF2MapEntityVariant inputVariant;
		inputVariant.Init();

		SF2MapEntity_FireOutput(this.EntRef, szKeyName, activator, caller, inputVariant);
	}
}

methodmap SF2TriggerMapEntity < SF2MapEntity
{
	public SF2TriggerMapEntity(int entIndex)
	{
		return view_as<SF2TriggerMapEntity>(SF2MapEntity(entIndex));
	}

	public bool PassesTriggerFilters(int entity)
	{
		return view_as<bool>(SDKCall(g_hSDKPassesTriggerFilters, this.EntIndex, entity));
	}

	property bool IsDisabled
	{
		public get()
		{
			return view_as<bool>(GetEntProp(this.EntRef, Prop_Data, "m_bDisabled")); 
		}
	}
}

enum SF2MapEntityHook
{
	SF2MapEntityHook_OnLevelInit = 0,
	SF2MapEntityHook_TranslateClassname,
	SF2MapEntityHook_OnEntityCreated,
	SF2MapEntityHook_OnEntityDestroyed,
	SF2MapEntityHook_OnMapStart,
	SF2MapEntityHook_OnEntityKeyValue,
	SF2MapEntityHook_OnAcceptEntityInput,
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
		case SF2MapEntityHook_OnLevelInit:
			g_CustomEntityOnLevelInit.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_TranslateClassname:
			g_CustomEntityTranslateClassname.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnEntityCreated:
			g_CustomEntityInitialize.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnEntityDestroyed:
			g_CustomEntityOnDestroyed.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnMapStart:
			g_CustomEntityOnMapStart.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnEntityKeyValue:
			g_CustomEntityOnEntityKeyValue.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnAcceptEntityInput:
			g_CustomEntityOnAcceptEntityInput.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnRoundStateChanged:
			g_CustomEntityOnRoundStateChanged.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnGracePeriodEnd:
			g_CustomEntityOnGracePeriodEnd.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnDifficultyChanged:
			g_CustomEntityOnDifficultyChanged.AddFunction(INVALID_HANDLE, hookFunc);
		case SF2MapEntityHook_OnPageCountChanged:
			g_CustomEntityOnPageCountChanged.AddFunction(INVALID_HANDLE, hookFunc);
		
		case SF2MapEntityHook_OnRenevantWaveTriggered:
			g_CustomEntityOnRenevantWaveTriggered.AddFunction(INVALID_HANDLE, hookFunc);
		
		default:
			ThrowError("Unhandled hooktype %i", hookType);
	}
}

#include "sf2/entities/sf2_game_text.sp"
#include "sf2/entities/sf2_gamerules.sp"
#include "sf2/entities/sf2_trigger_escape.sp"
#include "sf2/entities/sf2_info_player_escapespawn.sp"
#include "sf2/entities/sf2_trigger_pvp.sp"
#include "sf2/entities/sf2_info_player_pvpspawn.sp"
#include "sf2/entities/sf2_info_player_proxyspawn.sp"
#include "sf2/entities/sf2_info_boss_spawn.sp"
#include "sf2/entities/sf2_info_page_spawn.sp"
#include "sf2/entities/sf2_info_page_music.sp"
#include "sf2/entities/sf2_logic_proxy.sp"
#include "sf2/entities/sf2_logic_raid.sp"

// Modified only
#include "sf2/entities/sf2_logic_arena.sp"
#include "sf2/entities/sf2_logic_boxing.sp"
#include "sf2/entities/sf2_logic_slaughter.sp"

/**
 * A single output that is registered to the entity using AddOutput.
 */
enum struct SF2MapEntityOutputData
{
	int ID;
	char Output[256];
	char TargetName[256];
	char Input[256];
	char InputParameter[256];
	float Delay;
	int TimesToFire;

	void Init() 
	{
		this.Output[0] = '\0';
		this.TargetName[0] = '\0';
		this.Input[0] = '\0';
		this.InputParameter[0] = '\0';
		this.Delay = 0.0;
		this.TimesToFire = -1; // EVENT_FIRE_ALWAYS
	}
}

/**
 * A structure that contains an event to fire a specific output on the entity when the associated timer elapses.
 */
enum struct SF2MapEntityFireOutputData
{
	Handle TimerHandle;
	int ActivatorEntRef;
	int CallerEntRef;
	int OutputID;
	SF2MapEntityVariant Variant;
}

/**
 * Internal data stored for a custom map entity.
 */
enum struct SF2MapEntityData
{
	int EntRef; 
	char Classname[PLATFORM_MAX_PATH];
	ArrayList Outputs;
	ArrayList FiredOutputs;
	int OutputIDStamp;

	void Init(int entIndex)
	{
		this.EntRef = EnsureEntRef(entIndex);
		this.Classname[0] = '\0';
		this.Outputs = new ArrayList(sizeof(SF2MapEntityOutputData));
		this.FiredOutputs = new ArrayList(sizeof(SF2MapEntityFireOutputData));
		this.OutputIDStamp = 0;
	}

	void Destroy() 
	{
		if (this.Outputs != null) 
		{
			delete this.Outputs;
			this.Outputs = null;
		}

		if (this.FiredOutputs != null) 
		{
			delete this.FiredOutputs;
			this.FiredOutputs = null;
		}
	}
}

// BUG: Can't use sizeof(enum struct) operator inside a function in the same enum struct for some god awful reason, 
// so we have to put this function out here instead.
static int SF2MapEntityData_Get(int entIndex, SF2MapEntityData entData)
{
	entData.EntRef = EnsureEntRef(entIndex);
	if (entData.EntRef == INVALID_ENT_REFERENCE)
		return -1;

	int iIndex = g_hCustomEntities.FindValue(entData.EntRef);
	if (iIndex == -1)
		return -1;
	
	g_hCustomEntities.GetArray(iIndex, entData, sizeof(entData));
	return iIndex;
}

static void SF2MapEntityData_Update(SF2MapEntityData entData)
{
	int iIndex = g_hCustomEntities.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_hCustomEntities.SetArray(iIndex, entData, sizeof(entData));
}

void SF2MapEntity_Initialize()
{
	g_CustomEntityTranslateClassname = new PrivateForward(ET_Event, Param_String, Param_String, Param_Cell);
	g_CustomEntityInitialize = new PrivateForward(ET_Ignore, Param_Cell, Param_String);
	g_CustomEntityOnAcceptEntityInput = new PrivateForward(ET_Event, Param_Cell, Param_String, Param_String, Param_Cell, Param_Cell);
	g_CustomEntityOnEntityKeyValue = new PrivateForward(ET_Event, Param_Cell, Param_String, Param_String, Param_String);
	g_CustomEntityOnLevelInit = new PrivateForward(ET_Ignore, Param_String);
	g_CustomEntityOnMapStart = new PrivateForward(ET_Ignore);
	g_CustomEntityOnDestroyed = new PrivateForward(ET_Ignore, Param_Cell, Param_String);
	g_CustomEntityOnRoundStateChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnGracePeriodEnd = new PrivateForward(ET_Ignore);
	g_CustomEntityOnDifficultyChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);
	g_CustomEntityOnPageCountChanged = new PrivateForward(ET_Ignore, Param_Cell, Param_Cell);

	g_CustomEntityOnRenevantWaveTriggered = new PrivateForward(ET_Ignore, Param_Cell);

	g_hCustomEntities = new ArrayList(sizeof(SF2MapEntityData));

	g_cvDifficulty.AddChangeHook(SF2MapEntity_OnDifficultyChanged);

	// Initialize static entity data.
	// Unfortunately, there's no better way to do it other than sticking the initialization functions here.

	// sf2_game_text
	SF2GameTextEntity_Initialize();

	// sf2_gamerules
	SF2GamerulesEntity_Initialize();

	// sf2_trigger_escape
	SF2TriggerEscapeEntity_Initialize();

	// sf2_info_player_escapespawn
	SF2PlayerEscapeSpawnEntity_Initialize();

	// sf2_trigger_pvp
	SF2TriggerPvPEntity_Initialize();

	// sf2_info_player_pvpspawn
	SF2PlayerPvPSpawnEntity_Initialize();

	// sf2_info_player_proxyspawn
	SF2PlayerProxySpawnEntity_Initialize();

	// sf2_info_boss_spawn
	SF2BossSpawnEntity_Initialize();

	// sf2_info_page_spawn
	SF2PageSpawnEntity_Initialize();

	// sf2_info_page_music
	SF2PageMusicEntity_Initialize();

	// sf2_logic_proxy
	SF2LogicProxyEntity_Initialize();

	// sf2_logic_raid
	SF2LogicRaidEntity_Initialize();

	// Modified
	
	// sf2_logic_renevant
	SF2LogicRenevantEntity_Initialize();

	// sf2_logic_boxing
	SF2LogicBoxingEntity_Initialize();

	// sf2_logic_slaughter
	SF2LogicSlaughterEntity_Initialize();
}

void SF2MapEntity_OnLevelInit(const char[] sMapName) 
{
	if (g_hCustomEntities.Length > 0) 
	{
		LogSF2Message("WARNING: Some custom entities did not destroy correctly. Cleaning up...");

		for (int i = 0; i < g_hCustomEntities.Length; i++) {
			SF2MapEntityData entData;
			g_hCustomEntities.GetArray(i, entData, sizeof(entData));
			entData.Destroy();
		}

		g_hCustomEntities.Clear();
	}

	Call_StartForward(g_CustomEntityOnLevelInit);
	Call_PushString(sMapName);
	Call_Finish();
}

void SF2MapEntity_OnMapStart()
{
	Call_StartForward(g_CustomEntityOnMapStart);
	Call_Finish();
}

static bool SF2MapEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen) 
{
	Action result = Plugin_Continue;

	Call_StartForward(g_CustomEntityTranslateClassname);
	Call_PushString(sClass);
	Call_PushStringEx(sBuffer, iBufferLen, SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(iBufferLen);
	Call_Finish(result);

	return (result != Plugin_Continue);
}

static MRESReturn SF2MapEntity_OnCreateEntityByNamePre(DHookReturn hReturn, DHookParam hParams)
{
	char sClass[PLATFORM_MAX_PATH];
	hParams.GetString(1, sClass, sizeof(sClass));

	char sTranslatedClass[PLATFORM_MAX_PATH];
	if (SF2MapEntity_TranslateClassname(sClass, sTranslatedClass, sizeof(sTranslatedClass)))
	{
		g_bCustomEntity = true;
		strcopy(g_sCustomEntityOriginalClass, sizeof(g_sCustomEntityOriginalClass), sClass);

		hParams.SetString(1, sTranslatedClass);

#if defined DEBUG_MAPENTITIES
		PrintToServer("Translated custom entity classname from %s -> %s", sClass, sTranslatedClass);
#endif

		return MRES_ChangedHandled;
	}

	return MRES_Ignored;
}

static MRESReturn SF2MapEntity_OnCreateEntityByNamePost(DHookReturn hReturn, DHookParam hParams)
{
	int entity = hReturn.Value;

	if (g_bCustomEntity) 
	{
		g_bCustomEntity = false;

		if (IsValidEntity(entity))
		{
			SF2MapEntityData entData;
			entData.Init(entity);

			strcopy(entData.Classname, sizeof(entData.Classname), g_sCustomEntityOriginalClass);

			g_hCustomEntities.PushArray(entData, sizeof(entData));

			Call_StartForward(g_CustomEntityInitialize);
			Call_PushCell(entity);
			Call_PushString(g_sCustomEntityOriginalClass);
			Call_Finish();

			SetEntPropString(entity, Prop_Data, "m_iClassname", g_sCustomEntityOriginalClass);

			g_hSDKAcceptInput.HookEntity(Hook_Pre, entity, SF2MapEntity_OnAcceptEntityInputPre);
			g_hSDKKeyValue.HookEntity(Hook_Pre, entity, SF2MapEntity_OnEntityKeyValuePre);

#if defined DEBUG_MAPENTITIES
			PrintToServer("Created custom entity %d (%s)", 
				EntRefToEntIndex(entData.EntRef), entData.Classname);
#endif
		}
	}

	return MRES_Ignored;
}

static DHookParam g_CustomEntityAcceptInputParams;

/**
 *	Returns the type stored in the variant_t structure.
 *	Enum values can be found in source-sdk-2013/sp/src/public/datamap.h
 */
static int SF2MapEntity_GetVariantType() {
	return g_CustomEntityAcceptInputParams.GetObjectVar(4, 16, ObjectValueType_Int);
}

stock float SF2MapEntity_GetVariantFloat() 
{
	if (!g_CustomEntityAcceptInputParams)
		return 0.0;

	int fieldType = SF2MapEntity_GetVariantType();
	if (fieldType != 1) // FIELD_FLOAT
		return 0.0;
	
	return g_CustomEntityAcceptInputParams.GetObjectVar(4, 0, ObjectValueType_Float);
}

stock int SF2MapEntity_GetVariantInt() 
{
	if (!g_CustomEntityAcceptInputParams)
		return 0;

	int fieldType = SF2MapEntity_GetVariantType();
	if (fieldType != 5) // FIELD_INTEGER
		return 0;
	
	return g_CustomEntityAcceptInputParams.GetObjectVar(4, 0, ObjectValueType_Int);
}

stock void SF2MapEntity_GetVariantString(char[] sBuffer, int iBufferLen)
{
	if (!g_CustomEntityAcceptInputParams)
		return;

	int fieldType = SF2MapEntity_GetVariantType();
	if (fieldType != 2) // FIELD_STRING
	{
		strcopy(sBuffer, iBufferLen, "");
		return;
	}

	g_CustomEntityAcceptInputParams.GetObjectVarString(4, 0, ObjectValueType_CharPtr, sBuffer, iBufferLen);
}

/**
 *	Converts the variant value into a float.
 */
stock float SF2MapEntity_GetFloatFromVariant()
{
	if (!g_CustomEntityAcceptInputParams)
		return 0.0;
	
	switch (SF2MapEntity_GetVariantType()) 
	{
		case 1:
		{
			return SF2MapEntity_GetVariantFloat();	
		}
		case 2:
		{
			char sVariant[SF2_MAX_PROFILE_NAME_LENGTH];
			SF2MapEntity_GetVariantString(sVariant, sizeof(sVariant));

			return StringToFloat(sVariant);
		}
		case 5:
		{
			return float(SF2MapEntity_GetVariantInt());	
		}
	}

	return 0.0;
}

/**
 *	Converts the variant value into an integer.
 */
stock int SF2MapEntity_GetIntFromVariant()
{
	if (!g_CustomEntityAcceptInputParams)
		return 0;
	
	switch (SF2MapEntity_GetVariantType()) 
	{
		case 1:
		{
			return RoundToZero(SF2MapEntity_GetVariantFloat());
		}
		case 2:
		{
			char sVariant[SF2_MAX_PROFILE_NAME_LENGTH];
			SF2MapEntity_GetVariantString(sVariant, sizeof(sVariant));

			return StringToInt(sVariant);
		}
		case 5:
		{
			return SF2MapEntity_GetVariantInt();	
		}
	}

	return 0;
}

/**
 *	Converts the variant value into a string.
 */
stock void SF2MapEntity_GetStringFromVariant(char[] sBuffer, int iBufferSize)
{
	sBuffer[0] = '\0';

	if (!g_CustomEntityAcceptInputParams)
		return;
	
	switch (SF2MapEntity_GetVariantType()) 
	{
		case 1:
		{
			FloatToString(SF2MapEntity_GetVariantFloat(), sBuffer, iBufferSize);
		}
		case 2:
		{
			SF2MapEntity_GetVariantString(sBuffer, iBufferSize);
		}
		case 5:
		{
			IntToString(SF2MapEntity_GetVariantInt(), sBuffer, iBufferSize);
		}
	}
}

static MRESReturn SF2MapEntity_OnAcceptEntityInputPre(int entity, DHookReturn hReturn, DHookParam hParams)
{
	if (!IsValidEntity(entity))
		return MRES_Ignored;

	g_CustomEntityAcceptInputParams = hParams;

	Action result = Plugin_Continue;

	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
		return MRES_Ignored; // random bug again...

	char szInputName[64];
	hParams.GetString(1, szInputName, sizeof(szInputName));

	int activator = hParams.IsNull(2) ? -1 : hParams.Get(2);
	int caller = hParams.IsNull(3) ? -1 : hParams.Get(3);

#if defined DEBUG_MAPENTITIES

	PrintToServer("Custom entity %i receieved input %s (activator: %i, caller: %i)",
		EntRefToEntIndex(entData.EntRef), szInputName, activator, caller);

#endif

	Call_StartForward(g_CustomEntityOnAcceptEntityInput);
	Call_PushCell(entity);
	Call_PushString(entData.Classname);
	Call_PushString(szInputName);
	Call_PushCell(activator);
	Call_PushCell(caller);
	Call_Finish(result);

	g_CustomEntityAcceptInputParams = null;

	if (result != Plugin_Continue) 
	{
		hReturn.Value = true;
		return MRES_Supercede;
	}

	return MRES_Ignored;
}

static MRESReturn SF2MapEntity_OnEntityKeyValuePre(int entity, DHookReturn hReturn, DHookParam hParams)
{
	if (!IsValidEntity(entity))
		return MRES_Ignored;

	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
	{
		// BUGFIX: Sometimes, the hook gets called on a completely unrelated entity on level init randomly. What the hell.
		// DHooks probably forgot to auto unhook. If it happens just ignore.
		return MRES_Ignored;
	}

	char szKeyName[PLATFORM_MAX_PATH];
	hParams.GetString(1, szKeyName, sizeof(szKeyName));

	char szValue[PLATFORM_MAX_PATH];
	hParams.GetString(2, szValue, sizeof(szValue));

	Action result = Plugin_Continue;

	Call_StartForward(g_CustomEntityOnEntityKeyValue);
	Call_PushCell(entity);
	Call_PushString(entData.Classname);
	Call_PushString(szKeyName);
	Call_PushString(szValue);
	Call_Finish(result);

	if (result != Plugin_Continue) 
	{
		hReturn.Value = true;
		return MRES_Supercede;
	}

	return MRES_Ignored;
}

static void SF2MapEntity_FireOutput(int entity, const char[] szKeyName, int activator, int caller, SF2MapEntityVariant inputVariant)
{
	if (!IsValidEntity(entity))
		return;
	
	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
		ThrowError("invalid entdata");

	// Ensure activator and caller are entity indices.
	activator = IsValidEntity(activator) ? ( (activator & (1 << 31)) ? EntRefToEntIndex(activator) : activator ) : -1;
	caller = IsValidEntity(caller) ? ( (caller & (1 << 31)) ? EntRefToEntIndex(caller) : caller ) : -1;

#if defined DEBUG_MAPENTITIES

	PrintToServer("Custom entity %i (%s) fired output %s (activator: %d, caller: %i)", 
		EntRefToEntIndex(entData.EntRef), entData.Classname, szKeyName, activator, caller);

#endif

	// need to clone because DoOutputEvent with no delay could affect array size mid-loop
	ArrayList outputs = entData.Outputs.Clone();

	for (int i = 0; i < outputs.Length; i++) 
	{
		SF2MapEntityOutputData outputData;
		outputs.GetArray(i, outputData, sizeof(outputData));

		if (strcmp(szKeyName, outputData.Output, false) != 0)
			continue;
		
#if defined DEBUG_MAPENTITIES
		
		PrintToServer(" - ID: %i\n - Output: %s\n - TargetName: %s\n - Input: %s\n - Input param: %s\n - Delay: %f\n - TimesToFire: %i",
			outputData.ID, outputData.Output, outputData.TargetName, outputData.Input, outputData.InputParameter, outputData.Delay, outputData.TimesToFire);
		
#endif

		SF2MapEntityVariant outputVariant;
		outputVariant.Init();

		if (outputData.InputParameter[0] == '\0')
			SF2MapEntityVariant_Copy(outputVariant, inputVariant);
		else 
			outputVariant.SetString(outputData.InputParameter);

		if (outputData.Delay <= 0.0) 
		{
			SF2MapEntity_DoOutputEvent(entity, outputData.ID, activator, caller, outputVariant);
		}
		else 
		{
			SF2MapEntityFireOutputData fireOutputData;
			fireOutputData.TimerHandle = CreateTimer(outputData.Delay, SF2MapEntity_TimerDoOutputEvent, entData.EntRef, TIMER_FLAG_NO_MAPCHANGE);
			fireOutputData.ActivatorEntRef = IsValidEntity(activator) ? EntIndexToEntRef(activator) : INVALID_ENT_REFERENCE;
			fireOutputData.CallerEntRef = IsValidEntity(caller) ? EntIndexToEntRef(caller) : INVALID_ENT_REFERENCE;
			fireOutputData.OutputID = outputData.ID;
			SF2MapEntityVariant_Copy(fireOutputData.Variant, outputVariant);

			entData.FiredOutputs.PushArray(fireOutputData);
		}
	}

	delete outputs;
}

static Action SF2MapEntity_TimerDoOutputEvent(Handle timer, any data)
{
	int entity = EntRefToEntIndex(data);
	if (entity == INVALID_ENT_REFERENCE)
		return Plugin_Handled;
	
	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
		ThrowError("invalid entdata");

	int iFiredOutputIndex = entData.FiredOutputs.FindValue(timer);
	if (iFiredOutputIndex == -1)
		return Plugin_Handled;
	
	SF2MapEntityFireOutputData fireOutputData;
	entData.FiredOutputs.GetArray(iFiredOutputIndex, fireOutputData, sizeof(fireOutputData));
	entData.FiredOutputs.Erase(iFiredOutputIndex);

	int activator = fireOutputData.ActivatorEntRef != INVALID_ENT_REFERENCE ?
		EntRefToEntIndex(fireOutputData.ActivatorEntRef) : -1;
	int caller = fireOutputData.CallerEntRef != INVALID_ENT_REFERENCE ?
		EntRefToEntIndex(fireOutputData.CallerEntRef) : -1;
	
	SF2MapEntity_DoOutputEvent(entity, fireOutputData.OutputID, activator, caller, fireOutputData.Variant);

	return Plugin_Handled;
}

static int SF2MapEntity_FindProceduralTarget(const char[] szName, int searchingEntity, int activator, int caller)
{
	if (szName[0] != '!')
		return -1;
	
	if ( strcmp( szName, "!activator" ) == 0 )
	{
		return activator;
	}
	else if ( strcmp( szName, "!caller" ) == 0)
	{
		return caller;
	}
	else if ( strcmp( szName, "!self" ) == 0)
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

		LogSF2Message("%i (%s): Invalid entity search name %s", searchingEntity, sClass, szName);
	}
	
	return -1;
}

int SF2MapEntity_FindEntityByTargetname(int startEnt, const char[] szName, int searchingEntity, int activator, int caller)
{
	if (szName[0] == '!')
	{
		if (startEnt == -1)
		{
			int target = SF2MapEntity_FindProceduralTarget(szName, searchingEntity, activator, caller);
			if (IsValidEntity(target)) 
			{
				return target;
			}
		}

		return -1;
	}

	char sTargetName[PLATFORM_MAX_PATH];

	// dear god

	int iMaxEntities = GetMaxEntities() * 2; // multiply by 2 to get non-networked entities too
	for (int i = startEnt + 1; i < iMaxEntities; i++)
	{
		if (!IsValidEntity(i))
			continue;

		GetEntPropString(i, Prop_Data, "m_iName", sTargetName, sizeof(sTargetName));
		if (strcmp(sTargetName, szName) == 0) 
		{
			return i;
		}
	}

	return -1;
}

static void SF2MapEntity_SetupVariantForInput(const char[] szParam, SF2MapEntityVariant inputVariant)
{
	if (szParam[0] != '\0')
	{
		SetVariantString(szParam);
	}
	else 
	{
		switch (inputVariant.FieldType)
		{
			case 1: // FIELD_FLOAT
			{
				SetVariantFloat(inputVariant.FloatValue);
			}
			case 2: // FIELD_STRING
			{
				SetVariantString(inputVariant.StringValue);
			}
			case 5: // FIELD_INTEGER
			{
				SetVariantInt(inputVariant.IntValue);
			}
		}
	}
}

static void SF2MapEntity_DoOutputEvent(int entity, int iOutputID, int activator, int caller, SF2MapEntityVariant inputVariant)
{
	if (!IsValidEntity(entity))
		return;
	
	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
		ThrowError("invalid entdata");

	int iOutputIndex = entData.Outputs.FindValue(iOutputID);
	if (iOutputIndex == -1)
		return;
	
	SF2MapEntityOutputData outputData;
	entData.Outputs.GetArray(iOutputIndex, outputData, sizeof(outputData));

	// Search by targetname, and if not found, then classname, then invoke AcceptEntityInput with activator + caller arguments.
	if (outputData.TargetName[0] != '\0')
	{
		bool targetFound = false;

		if (!targetFound)
		{
			// In I/O land, the searching entity is also the caller, so searchingEntity = caller

			int target = -1;
			while ((target = SF2MapEntity_FindEntityByTargetname(target, outputData.TargetName, caller, activator, caller)) != -1)
			{
				targetFound = true;
				SF2MapEntity_SetupVariantForInput(outputData.InputParameter, inputVariant);
				AcceptEntityInput(target, outputData.Input, activator, caller);
			}
		}

		if (!targetFound)
		{
			int target = INVALID_ENT_REFERENCE;
			while ((target = FindEntityByClassname(target, outputData.TargetName)) != -1)
			{
				targetFound = true;

				SF2MapEntity_SetupVariantForInput(outputData.InputParameter, inputVariant);
				AcceptEntityInput(target, outputData.Input, activator, caller);
			}
		}
	}
	
	int iTimesToFire = outputData.TimesToFire;
	if (iTimesToFire != -1) 
	{
		outputData.TimesToFire--;

		if (iTimesToFire == 0) 
		{
			entData.Outputs.Erase(iOutputIndex);
		}
		else 
		{
			entData.Outputs.SetArray(iOutputIndex, outputData, sizeof(outputData));
		}
	}
}

static void SF2MapEntity_AddOutput(int entity, const char[] szKeyName, const char[] szValue) 
{
	if (!IsValidEntity(entity))
		return;
	
	SF2MapEntityData entData;
	if (SF2MapEntityData_Get(entity, entData) == -1)
		ThrowError("invalid entdata");

	char sOutputParameters[5][256];
	int iOutputParamCount = ExplodeString(szValue, ",", sOutputParameters, sizeof(sOutputParameters), sizeof(sOutputParameters[]));

	SF2MapEntityOutputData outputData;
	outputData.ID = ++entData.OutputIDStamp;
	outputData.Init();

	SF2MapEntityData_Update(entData);

	strcopy(outputData.Output, sizeof(outputData.Output), szKeyName);

	if (iOutputParamCount >= 1 && sOutputParameters[0][0] != '\0') {
		strcopy(outputData.TargetName, sizeof(outputData.TargetName), sOutputParameters[0]);
	}

	if (iOutputParamCount >= 2 && sOutputParameters[1][0] != '\0') {
		strcopy(outputData.Input, sizeof(outputData.Input), sOutputParameters[1]);
	}

	if (iOutputParamCount >= 3 && sOutputParameters[2][0] != '\0') {
		strcopy(outputData.InputParameter, sizeof(outputData.InputParameter), sOutputParameters[2]);
	}

	if (iOutputParamCount >= 4 && sOutputParameters[3][0] != '\0') {
		outputData.Delay = StringToFloat(sOutputParameters[3]);
	}

	if (iOutputParamCount >= 5 && sOutputParameters[4][0] != '\0') {
		outputData.TimesToFire = StringToInt(sOutputParameters[4]);
	}

	if (outputData.TimesToFire <= 0 && outputData.TimesToFire != -1)
	{
		// Don't add it; it wouldn't fire anyways.
		return;
	}

#if defined DEBUG_MAPENTITIES

	PrintToServer("Custom entity %i (%s) registered output:\n - ID: %i\n - Output: %s\n - TargetName: %s\n - Input: %s\n - Input param: %s\n - Delay: %f\n - TimesToFire: %i",
		EntRefToEntIndex(entData.EntRef), entData.Classname, outputData.ID, outputData.Output, outputData.TargetName, outputData.Input, outputData.InputParameter, outputData.Delay, outputData.TimesToFire);

#endif

	entData.Outputs.PushArray(outputData, sizeof(outputData));
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

void SF2MapEntity_OnEntityDestroyed(int entity) 
{
	if (!IsValidEntity(entity))
		return;

	SF2MapEntityData entData;
	int iIndex = SF2MapEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		entData.Destroy();
		g_hCustomEntities.Erase(iIndex);

		Call_StartForward(g_CustomEntityOnDestroyed);
		Call_PushCell(entity);
		Call_PushString(entData.Classname);
		Call_Finish();

#if defined DEBUG_MAPENTITIES
		PrintToServer("Destroyed custom entity %i %s", 
			EntRefToEntIndex(entData.EntRef), entData.Classname);
#endif
	}
}

void SF2MapEntity_InitGameData(GameData hConfig) 
{
	g_hSDKCreateEntityByName = new DynamicDetour(Address_Null, CallConv_CDECL, ReturnType_CBaseEntity, ThisPointer_Ignore);
	if (!g_hSDKCreateEntityByName)
		SetFailState("Failed to setup detour for CreateEntityByName");
	
	if (!DHookSetFromConf(g_hSDKCreateEntityByName, hConfig, SDKConf_Signature, "CreateEntityByName"))
		SetFailState("Failed to load CreateEntityByName signature from gamedata");
	
	g_hSDKCreateEntityByName.AddParam(HookParamType_CharPtr);
	g_hSDKCreateEntityByName.AddParam(HookParamType_Int);
	
	if (!g_hSDKCreateEntityByName.Enable(Hook_Pre, SF2MapEntity_OnCreateEntityByNamePre))
		SetFailState("Failed to detour pre-CreateEntityByName.");
	
	if (!g_hSDKCreateEntityByName.Enable(Hook_Post, SF2MapEntity_OnCreateEntityByNamePost))
		SetFailState("Failed to detour post-CreateEntityByName.");

	GameData hSdkToolsConfig = new GameData("sdktools.games");
	g_hSDKAcceptInput = new DynamicHook(hSdkToolsConfig.GetOffset("AcceptInput"), HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity);
	if (!g_hSDKAcceptInput)
		SetFailState("Failed to setup hook for CBaseEntity::AcceptInput");

	g_hSDKAcceptInput.AddParam(HookParamType_CharPtr);
	g_hSDKAcceptInput.AddParam(HookParamType_CBaseEntity);
	g_hSDKAcceptInput.AddParam(HookParamType_CBaseEntity);
	g_hSDKAcceptInput.AddParam(HookParamType_Object, 20); // SIZEOF_VARIANT_T
	g_hSDKAcceptInput.AddParam(HookParamType_Int);

	delete hSdkToolsConfig;

	g_hSDKKeyValue = new DynamicHook(hConfig.GetOffset("CBaseEntity::KeyValue"), HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity);
	if (!g_hSDKKeyValue)
		SetFailState("Failed to setup hook for CBaseEntity::KeyValue");

	g_hSDKKeyValue.AddParam(HookParamType_CharPtr);
	g_hSDKKeyValue.AddParam(HookParamType_CharPtr);

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseTrigger::PassesTriggerFilters");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_hSDKPassesTriggerFilters = EndPrepSDKCall()) == INVALID_HANDLE)
		SetFailState("Failed to setup CBaseTrigger::PassesTriggerFilters call from gamedata!");
}

#undef DEBUG_MAPENTITIES