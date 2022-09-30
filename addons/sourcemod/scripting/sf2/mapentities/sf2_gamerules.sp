// sf2_gamerules

#pragma semicolon 1

static const char g_EntityClassname[] = "sf2_gamerules";

static CEntityFactory g_EntityFactory;

methodmap SF2GamerulesEntity < CBaseEntity
{
	public SF2GamerulesEntity(int entIndex)
	{
		return view_as<SF2GamerulesEntity>(CBaseEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public static void Initialize()
	{
		Initialize();
	}

	property int MaxPlayers
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iMaxPlayers"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iMaxPlayers", value); }
	}

	property int MaxPages
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iMaxPages"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iMaxPages", value); }
	}

	public void GetPageTextEntityName(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szPageTextName", sBuffer, iBufferLen);
	}

	public void SetPageTextEntityName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szPageTextName", sBuffer);
	}

	property SF2GameTextEntity PageTextEntity
	{
		public get()
		{
			char pageTextEntityName[64];
			this.GetPageTextEntityName(pageTextEntityName, sizeof(pageTextEntityName));

			if (pageTextEntityName[0] == '\0')
			{
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);
			}

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, pageTextEntityName, -1, -1, -1));
		}
	}

	property int InitialTimeLimit
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iInitialTimeLimit"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iInitialTimeLimit", value); }
	}

	property int PageCollectAddTime
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iPageCollectAddTime"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iPageCollectAddTime", value); }
	}

	public void GetPageCollectSoundPath(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szPageCollectSound", sBuffer, iBufferLen);
	}

	public void SetPageCollectSoundPath(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szPageCollectSound", sBuffer);
	}

	property int PageCollectSoundPitch
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iPageCollectSoundPitch"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iPageCollectSoundPitch", value); }
	}

	property bool InfiniteFlashlight
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bInfiniteFlashlight"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bInfiniteFlashlight", value); }
	}

	property bool InfiniteSprint
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bInfiniteSprint"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bInfiniteSprint", value); }
	}

	property bool InfiniteBlink
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bInfiniteBlink"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bInfiniteBlink", value); }
	}

	property bool BossesChaseEndlessly
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bBossesChaseEndlessly"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bBossesChaseEndlessly", value); }
	}

	property bool HasEscapeObjective
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bEscapeToWin"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bEscapeToWin", value); }
	}

	property int EscapeTimeLimit
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iEscapeTimeLimit"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iEscapeTimeLimit", value); }
	}

	public void GetEscapeTextEntityName(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szEscapeTextName", sBuffer, iBufferLen);
	}

	public void SetEscapeTextEntityName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szEscapeTextName", sBuffer);
	}

	property SF2GameTextEntity EscapeTextEntity
	{
		public get()
		{
			char textName[64];
			this.GetEscapeTextEntityName(textName, sizeof(textName));

			if (textName[0] == '\0')
			{
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);
			}

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, textName, -1, -1, -1));
		}
	}

	property bool StopPageMusicOnEscape
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bStopPageMusicOnEscape"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bStopPageMusicOnEscape", value); }
	}

	property bool Survive
	{
		public get() { return !!this.GetProp(Prop_Data, "sf2_bSurvive"); }
		public set(bool value) { this.SetProp(Prop_Data, "sf2_bSurvive", value); }
	}

	property int SurviveUntilTime
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iSurviveUntilTime"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iSurviveUntilTime", value); }
	}

	public void GetBossName(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szBossName", sBuffer, iBufferLen);
	}

	public void SetBossName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szBossName", sBuffer);
	}

	public void GetIntroMusicPath(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szIntroMusicPath", sBuffer, iBufferLen);
	}

	public void SetIntroMusicPath(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szIntroMusicPath", sBuffer);
	}

	public void GetIntroFadeColor(int iBuffer[4])
	{
		this.GetPropColor(Prop_Data, "sf2_clrIntroFade", iBuffer[0], iBuffer[1], iBuffer[2], iBuffer[3]);
	}

	public void SetIntroFadeColor(const int iBuffer[4])
	{
		this.SetPropColor(Prop_Data, "sf2_clrIntroFade", iBuffer[0], iBuffer[1], iBuffer[2], iBuffer[3]);
	}

	property float IntroFadeHoldTime
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flIntroFadeHoldTime"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flIntroFadeHoldTime", value); }
	}

	property float IntroFadeTime
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flIntroFadeTime"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flIntroFadeTime", value); }
	}

	public void GetIntroTextEntityName(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_szIntroTextName", sBuffer, iBufferLen);
	}

	public void SetIntroTextEntityName(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_szIntroTextName", sBuffer);
	}

	property SF2GameTextEntity IntroTextEntity
	{
		public get()
		{
			char textName[64];
			this.GetIntroTextEntityName(textName, sizeof(textName));

			if (textName[0] == '\0')
			{
				return SF2GameTextEntity(INVALID_ENT_REFERENCE);
			}

			return SF2GameTextEntity(SF2MapEntity_FindEntityByTargetname(-1, textName, -1, -1, -1));
		}
	}

	property float IntroTextDelay
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flIntroTextDelay"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flIntroTextDelay", value); }
	}
}

SF2GamerulesEntity g_GamerulesEntity = view_as<SF2GamerulesEntity>(-1);

SF2GamerulesEntity FindSF2GamerulesEntity()
{
	return SF2GamerulesEntity(FindEntityByClassname(-1, g_EntityClassname));
}

static void Initialize()
{
	g_EntityFactory = new CEntityFactory(g_EntityClassname, OnCreated, OnRemoved);
	g_EntityFactory.DeriveFromBaseEntity();
	g_EntityFactory.BeginDataMapDesc()
		.DefineIntField("sf2_iMaxPlayers", _, "maxplayers")
		.DefineIntField("sf2_iMaxPages", _, "maxpages")
		.DefineStringField("sf2_szPageTextName", _, "pagetextname")
		.DefineIntField("sf2_iInitialTimeLimit", _, "initialtimelimit")
		.DefineIntField("sf2_iPageCollectAddTime", _, "pagecollectaddtime")
		.DefineStringField("sf2_szPageCollectSound", _, "pagecollectsound")
		.DefineIntField("sf2_iPageCollectSoundPitch", _, "pagecollectsoundpitch")
		.DefineFloatField("sf2_flPageMusicLoopDuration", _, "pagemusicupdateloop")
		.DefineBoolField("sf2_bInfiniteFlashlight", _, "infiniteflashlight")
		.DefineBoolField("sf2_bInfiniteSprint", _, "infinitesprint")
		.DefineBoolField("sf2_bInfiniteBlink", _, "infiniteblink")
		.DefineBoolField("sf2_bBossesChaseEndlessly", _, "bosseschaseendlessly")
		.DefineBoolField("sf2_bEscapeToWin", _, "escape")
		.DefineIntField("sf2_iEscapeTimeLimit", _, "escapetime")
		.DefineStringField("sf2_szEscapeTextName", _, "escapetextname")
		.DefineBoolField("sf2_bUnreachableEscape", _, "unreachableescape")
		.DefineBoolField("sf2_bStopPageMusicOnEscape", _, "stoppagemusiconescape")
		.DefineBoolField("sf2_bSurvive", _, "survive")
		.DefineIntField("sf2_iSurviveUntilTime", _, "surviveuntiltime")
		.DefineStringField("sf2_szBossName", _, "boss")
		.DefineStringField("sf2_szIntroMusicPath", _, "intromusicpath")
		.DefineColorField("sf2_clrIntroFade", _, "introfadecolor")
		.DefineFloatField("sf2_flIntroFadeHoldTime", _, "introfadeholdtime")
		.DefineFloatField("sf2_flIntroFadeTime", _, "introfadetime")
		.DefineStringField("sf2_szIntroTextName", _, "introtextname")
		.DefineFloatField("sf2_flIntroTextDelay", _, "introtextdelay")
		.DefineInputFunc("SetTimeLimit", InputFuncValueType_Integer, InputSetTimeLimit)
		.DefineInputFunc("SetSurviveUntilTime", InputFuncValueType_Integer, InputSetSurviveUntilTime)
		.DefineInputFunc("SetEscapeTimeLimit", InputFuncValueType_Integer, InputSetEscapeTimeLimit)
		.DefineInputFunc("SetTime", InputFuncValueType_Integer, InputSetTime)
		.DefineInputFunc("AddTime", InputFuncValueType_Integer, InputAddTime)
		.DefineInputFunc("SetTimeToAddOnCollectPage", InputFuncValueType_Integer, InputSetTimeToAddOnCollectPage)
		.DefineInputFunc("SetCollectedPages", InputFuncValueType_Integer, InputSetCollectedPages)
		.DefineInputFunc("AddCollectedPages", InputFuncValueType_Integer, InputAddCollectedPages)
		.DefineInputFunc("SubtractCollectedPages", InputFuncValueType_Integer, InputSubtractCollectedPages)
		.DefineInputFunc("SetPageTextEntity", InputFuncValueType_String, InputSetPageTextEntity)
		.DefineInputFunc("SetEscapeTextEntity", InputFuncValueType_String, InputSetEscapeTextEntity)
		.DefineInputFunc("EnableInfiniteFlashlight", InputFuncValueType_Void, InputEnableInfiniteFlashlight)
		.DefineInputFunc("DisableInfiniteFlashlight", InputFuncValueType_Void, InputDisableInfiniteFlashlight)
		.DefineInputFunc("EnableInfiniteSprint", InputFuncValueType_Void, InputEnableInfiniteSprint)
		.DefineInputFunc("DisableInfiniteSprint", InputFuncValueType_Void, InputDisableInfiniteSprint)
		.DefineInputFunc("EnableInfiniteBlink", InputFuncValueType_Void, InputEnableInfiniteBlink)
		.DefineInputFunc("DisableInfiniteBlink", InputFuncValueType_Void, InputDisableInfiniteBlink)
		.DefineInputFunc("EnableBossesChaseEndlessly", InputFuncValueType_Void, InputEnableBossesChaseEndlessly)
		.DefineInputFunc("DisableBossesChaseEndlessly", InputFuncValueType_Void, InputDisableBossesChaseEndlessly)
		.DefineInputFunc("SetBoss", InputFuncValueType_String, InputSetBoss)
		.DefineInputFunc("SetBossOverride", InputFuncValueType_String, InputSetBossOverride)
		.DefineInputFunc("ClearBossOverride", InputFuncValueType_Void, InputClearBossOverride)
		.DefineInputFunc("SetDifficulty", InputFuncValueType_Integer, InputSetDifficulty)
		.DefineInputFunc("EndGracePeriod", InputFuncValueType_Void, InputEndGracePeriod)
		.DefineInputFunc("PauseTimer", InputFuncValueType_Void, InputPauseTimer)
		.DefineInputFunc("ResumeTimer", InputFuncValueType_Void, InputResumeTimer)
		.DefineOutput("OnGracePeriodEnded")
		.DefineOutput("OnDifficultyChanged")
		.DefineOutput("OnStateEnterWaiting")
		.DefineOutput("OnStateExitWaiting")
		.DefineOutput("OnStateEnterIntro")
		.DefineOutput("OnStateExitIntro")
		.DefineOutput("OnStateEnterGrace")
		.DefineOutput("OnStateExitGrace")
		.DefineOutput("OnStateEnterActive")
		.DefineOutput("OnStateExitActive")
		.DefineOutput("OnStateEnterEscape")
		.DefineOutput("OnStateExitEscape")
		.DefineOutput("OnStateEnterOutro")
		.DefineOutput("OnStateExitOutro")
		.DefineOutput("OnCollectedPagesChanged")
		.DefineOutput("OnSurvivalComplete");

	char sOutputName[64];

	// OnCollectedXPages output
	for (int iPageCount = 1; iPageCount <= 32; iPageCount++)
	{
		FormatEx(sOutputName, sizeof(sOutputName), iPageCount == 1 ? "OnCollected%dPage" : "OnCollected%dPages", iPageCount);
		g_EntityFactory.DefineOutput(sOutputName);
	}

	// OnDifficultyX output
	for (int difficulty = 0; difficulty <= Difficulty_Max; difficulty++)
	{
		FormatEx(sOutputName, sizeof(sOutputName), "OnDifficulty%d", difficulty);
		g_EntityFactory.DefineOutput(sOutputName);
	}

	g_EntityFactory.EndDataMapDesc();

	g_EntityFactory.Install();

	SF2MapEntity_AddHook(SF2MapEntityHook_OnRoundStateChanged, OnRoundStateChanged);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnPageCountChanged, OnPageCountChanged);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnDifficultyChanged, OnDifficultyChanged);
}

static void OnCreated(int entity)
{
	SF2GamerulesEntity thisEnt = SF2GamerulesEntity(entity);

	// Default values should be the same as specified in InitializeMapEntities()
	// at the fallback of having no gamerules entity present.

	char sBossName[SF2_MAX_PROFILE_NAME_LENGTH];
	thisEnt.GetBossName(sBossName, sizeof(sBossName));

	if (sBossName[0] != '\0')
	{
		g_BossMainConVar.GetString(sBossName, sizeof(sBossName));
		thisEnt.SetBossName(sBossName);
	}

	thisEnt.MaxPlayers = 8;
	thisEnt.MaxPages = 1;
	thisEnt.SetPageTextEntityName("");

	thisEnt.InitialTimeLimit = g_TimeLimitConVar.IntValue;
	thisEnt.PageCollectAddTime = g_TimeGainFromPageGrabConVar.IntValue;
	thisEnt.SetPageCollectSoundPath(PAGE_GRABSOUND);
	thisEnt.PageCollectSoundPitch = 100;

	thisEnt.HasEscapeObjective = false;
	thisEnt.EscapeTimeLimit = g_TimeLimitEscapeConVar.IntValue;
	thisEnt.SetEscapeTextEntityName("");
	thisEnt.StopPageMusicOnEscape = false;
	thisEnt.Survive = g_SurvivalMapConVar.BoolValue;
	thisEnt.SurviveUntilTime = g_TimeEscapeSurvivalConVar.IntValue;

	thisEnt.InfiniteFlashlight = false;
	thisEnt.InfiniteSprint = false;
	thisEnt.InfiniteBlink = false;

	thisEnt.BossesChaseEndlessly = false;

	thisEnt.SetIntroMusicPath(SF2_INTRO_DEFAULT_MUSIC);
	thisEnt.SetIntroFadeColor({0, 0, 0, 255});
	thisEnt.IntroFadeHoldTime = g_IntroDefaultHoldTimeConVar.FloatValue;
	thisEnt.IntroFadeTime = g_IntroDefaultFadeTimeConVar.FloatValue;
	thisEnt.SetIntroTextEntityName("");
	thisEnt.IntroTextDelay = 0.0;

	SDKHook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnRemoved(int entity)
{
	SDKUnhook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int entity)
{
	SF2GamerulesEntity thisEnt = SF2GamerulesEntity(entity);

	char sPath[PLATFORM_MAX_PATH];

	thisEnt.GetPageCollectSoundPath(sPath, sizeof(sPath));
	if (sPath[0] != '\0')
		PrecacheSound(sPath);

	thisEnt.GetIntroMusicPath(sPath, sizeof(sPath));
	if (sPath[0] != '\0')
		PrecacheSound(sPath);
}

static void OnRoundStateChanged(SF2RoundState iRoundState, SF2RoundState iOldRoundState)
{
	SF2GamerulesEntity gameRules = FindSF2GamerulesEntity();
	if (!gameRules.IsValid())
		return;

	switch (iOldRoundState)
	{
		case SF2RoundState_Waiting:
			gameRules.FireOutput("OnStateExitWaiting");
		case SF2RoundState_Intro:
			gameRules.FireOutput("OnStateExitIntro");
		case SF2RoundState_Grace:
		{
			gameRules.FireOutput("OnGracePeriodEnded");
			gameRules.FireOutput("OnStateExitGrace");
		}
		case SF2RoundState_Active:
			gameRules.FireOutput("OnStateExitActive");
		case SF2RoundState_Escape:
			gameRules.FireOutput("OnStateExitEscape");
		case SF2RoundState_Outro:
			gameRules.FireOutput("OnStateExitOutro");
	}

	switch (iRoundState)
	{
		case SF2RoundState_Waiting:
			gameRules.FireOutput("OnStateEnterWaiting");
		case SF2RoundState_Intro:
			gameRules.FireOutput("OnStateEnterIntro");
		case SF2RoundState_Grace:
			gameRules.FireOutput("OnStateEnterGrace");
		case SF2RoundState_Active:
			gameRules.FireOutput("OnStateEnterActive");
		case SF2RoundState_Escape:
			gameRules.FireOutput("OnStateEnterEscape");
		case SF2RoundState_Outro:
			gameRules.FireOutput("OnStateEnterOutro");
	}
}

static void OnPageCountChanged(int iPageCount, int iOldPageCount)
{
	SF2GamerulesEntity gameRules = FindSF2GamerulesEntity();
	if (!gameRules.IsValid())
		return;

	char sOutputName[64];

	if (iPageCount > 0 && iPageCount <= 32)
		FormatEx(sOutputName, sizeof(sOutputName), iPageCount == 1 ? "OnCollected%dPage" : "OnCollected%dPages", iPageCount);
	else
		sOutputName[0] = '\0';

	SetVariantInt(iPageCount);
	gameRules.FireOutput("OnCollectedPagesChanged");

	if (sOutputName[0] != '\0')
		gameRules.FireOutput(sOutputName);
}

static void OnDifficultyChanged(int difficulty, int iOldDifficulty)
{
	SF2GamerulesEntity gameRules = FindSF2GamerulesEntity();
	if (!gameRules.IsValid())
		return;

	char sOutputName[64];
	FormatEx(sOutputName, sizeof(sOutputName), "OnDifficulty%d", difficulty);

	SetVariantInt(difficulty);
	gameRules.FireOutput("OnDifficultyChanged");
	gameRules.FireOutput(sOutputName);
}

static void InputSetTimeLimit(int entity, int activator, int caller, int value)
{
	if (value < 0)
		value = 0;

	g_RoundTimeLimit = value;
}

static void InputSetSurviveUntilTime(int entity, int activator, int caller, int value)
{
	if (value < 0)
		value = 0;

	g_TimeEscape = value;
}

static void InputSetEscapeTimeLimit(int entity, int activator, int caller, int value)
{
	if (value < 0)
		value = 0;

	g_RoundEscapeTimeLimit = value;
}

static void InputSetTime(int entity, int activator, int caller, int value)
{
	if (value < 0)
		value = 0;

	SetRoundTime(value);
}

static void InputAddTime(int entity, int activator, int caller, int value)
{
	value = g_RoundTime + value;
	if (value < 0)
		value = 0;

	SetRoundTime(value);
}

static void InputSetTimeToAddOnCollectPage(int entity, int activator, int caller, int value)
{
	g_RoundTimeGainFromPage = value;
}

static void InputSetCollectedPages(int entity, int activator, int caller, int value)
{
	if (value < 0)
		value = 0;

	SetPageCount(value);
}

static void InputAddCollectedPages(int entity, int activator, int caller, int value)
{
	value = g_PageCount + value;
	if (value < 0)
		value = 0;

	SetPageCount(value);
}

static void InputSubtractCollectedPages(int entity, int activator, int caller, int value)
{
	value = g_PageCount - value;
	if (value < 0)
		value = 0;

	SetPageCount(value);
}

static void InputSetPageTextEntity(int entity, int activator, int caller, const char[] value)
{
	SF2GamerulesEntity(entity).SetPageTextEntityName(value);
}

static void InputSetEscapeTextEntity(int entity, int activator, int caller, const char[] value)
{
	SF2GamerulesEntity(entity).SetEscapeTextEntityName(value);
}

static void InputEnableInfiniteFlashlight(int entity, int activator, int caller)
{
	g_RoundInfiniteFlashlight = true;
}

static void InputDisableInfiniteFlashlight(int entity, int activator, int caller)
{
	g_RoundInfiniteFlashlight = false;
}

static void InputEnableInfiniteSprint(int entity, int activator, int caller)
{
	g_IsRoundInfiniteSprint = true;
}

static void InputDisableInfiniteSprint(int entity, int activator, int caller)
{
	g_IsRoundInfiniteSprint = false;
}

static void InputEnableInfiniteBlink(int entity, int activator, int caller)
{
	g_RoundInfiniteBlink = true;
}

static void InputDisableInfiniteBlink(int entity, int activator, int caller)
{
	g_RoundInfiniteBlink = false;
}

static void InputEnableBossesChaseEndlessly(int entity, int activator, int caller)
{
	g_BossesChaseEndlessly = true;
}

static void InputDisableBossesChaseEndlessly(int entity, int activator, int caller)
{
	g_BossesChaseEndlessly = false;
}

static void InputSetBoss(int entity, int activator, int caller, const char[] value)
{
	g_BossMainConVar.SetString(value);
}

static void InputSetBossOverride(int entity, int activator, int caller, const char[] value)
{
	g_BossProfileOverrideConVar.SetString(value);
}

static void InputClearBossOverride(int entity, int activator, int caller)
{
	g_BossProfileOverrideConVar.SetString("");
}

static void InputSetDifficulty(int entity, int activator, int caller, int value)
{
	if (value < 0)
	{
		value = 0;
	}
	else if (value >= Difficulty_Max)
	{
		value = Difficulty_Max - 1;
	}

	g_DifficultyConVar.SetInt(value);
}

static void InputEndGracePeriod(int entity, int activator, int caller)
{
	if (GetRoundState() == SF2RoundState_Grace && g_RoundGraceTimer != null)
	{
		TriggerTimer(g_RoundGraceTimer);
	}
}

static void InputPauseTimer(int entity, int activator, int caller)
{
	SetRoundTimerPaused(true);
}

static void InputResumeTimer(int entity, int activator, int caller)
{
	SetRoundTimerPaused(false);
}