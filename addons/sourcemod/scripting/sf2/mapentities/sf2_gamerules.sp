// sf2_gamerules

static const char g_sEntityClassname[] = "sf2_gamerules";
static const char g_sEntityTranslatedClassname[] = "info_target";

static ArrayList g_EntityData;

enum struct SF2GamerulesEntityData
{
	int EntRef;

	/*
		Round Start Keyvalues

		These are keyvalues that are read only once at round start.
		If you want to dynamically change these values mid-round, use the inputs instead.
	*/
	char BossName[SF2_MAX_PROFILE_NAME_LENGTH];
	int MaxPlayers;
	int MaxPages;
	int InitialTimeLimit;
	int PageCollectAddTime;
	char PageCollectSoundPath[PLATFORM_MAX_PATH];
	bool HasEscapeObjective;
	int EscapeTimeLimit;
	bool StopPageMusicOnEscape;
	bool Survive;
	int SurviveUntilTime;
	bool InfiniteFlashlight;
	bool InfiniteSprint;
	bool InfiniteBlink;
	bool BossesChaseEndlessly;

	char IntroMusicPath[PLATFORM_MAX_PATH];
	int IntroFadeColor[4];
	float IntroFadeHoldTime;
	float IntroFadeTime;

	void Init(int entIndex) 
	{
		this.EntRef = EnsureEntRef(entIndex);

		// Default values should be the same as specified in InitializeMapEntities()
		// at the fallback of having no gamerules entity present.

		g_cvBossMain.GetString(this.BossName, SF2_MAX_PROFILE_NAME_LENGTH);

		this.MaxPlayers = 8;
		this.MaxPages = 1;

		this.InitialTimeLimit = g_cvTimeLimit.IntValue;
		this.PageCollectAddTime = g_cvTimeGainFromPageGrab.IntValue;
		strcopy(this.PageCollectSoundPath, PLATFORM_MAX_PATH, PAGE_GRABSOUND);

		this.HasEscapeObjective = false;
		this.EscapeTimeLimit = g_cvTimeLimitEscape.IntValue;
		this.StopPageMusicOnEscape = false;
		this.Survive = false;
		this.SurviveUntilTime = g_cvTimeEscapeSurvival.IntValue;

		this.InfiniteFlashlight = false;
		this.InfiniteSprint = false;
		this.InfiniteBlink = false;

		this.BossesChaseEndlessly = false;

		strcopy(this.IntroMusicPath, PLATFORM_MAX_PATH, SF2_INTRO_DEFAULT_MUSIC);
		this.IntroFadeColor[0] = 0; this.IntroFadeColor[1] = 0; this.IntroFadeColor[2] = 0; this.IntroFadeColor[3] = 255;
		this.IntroFadeHoldTime = g_cvIntroDefaultHoldTime.FloatValue;
		this.IntroFadeTime = g_cvIntroDefaultFadeTime.FloatValue;
	}

	void SetBossName(const char[] sBossName)
	{
		strcopy(this.BossName, SF2_MAX_PROFILE_NAME_LENGTH, sBossName);
	}

	void SetPageCollectSoundPath(const char[] sPath)
	{
		strcopy(this.PageCollectSoundPath, PLATFORM_MAX_PATH, sPath);
	}

	void SetIntroMusicPath(const char[] sPath)
	{
		strcopy(this.IntroMusicPath, PLATFORM_MAX_PATH, sPath);
	}

	void SetIntroMusicColor(const iColor[4])
	{
		for (int i = 0; i < 4; i++) this.IntroFadeColor[i] = iColor[i];
	}
}

methodmap SF2GamerulesEntity < SF2MapEntity
{
	public SF2GamerulesEntity(int entIndex)
	{
		return view_as<SF2GamerulesEntity>(SF2MapEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!SF2MapEntity(this.EntRef).IsValid())
			return false;

		SF2GamerulesEntityData entData;
		return (SF2GamerulesEntityData_Get(this.EntRef, entData) != -1);
	}

	property int MaxPlayers
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.MaxPlayers;
		}
	}

	property int MaxPages
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.MaxPages;
		}
	}

	property int InitialTimeLimit
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.InitialTimeLimit;
		}
	}

	property int PageCollectAddTime
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.PageCollectAddTime;
		}
	}

	public void GetPageCollectSoundPath(char[] sBuffer, int iBufferLen)
	{
		SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.PageCollectSoundPath);
	}

	property bool InfiniteFlashlight
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.InfiniteFlashlight;
		}
	}

	property bool InfiniteSprint
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.InfiniteSprint;
		}
	}

	property bool InfiniteBlink
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.InfiniteBlink;
		}
	}

	property bool BossesChaseEndlessly
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.BossesChaseEndlessly;
		}
	}

	property bool HasEscapeObjective
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.HasEscapeObjective;
		}
	}

	property int EscapeTimeLimit
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.EscapeTimeLimit;
		}
	}

	property bool StopPageMusicOnEscape
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.StopPageMusicOnEscape;
		}
	}

	property bool Survive
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.Survive;
		}
	}

	property int SurviveUntilTime
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.SurviveUntilTime;
		}
	}

	public void GetBossName(char[] sBuffer, int iBufferLen)
	{
		SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.BossName);
	}

	public void GetIntroMusicPath(char[] sBuffer, int iBufferLen)
	{
		SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData);
		strcopy(sBuffer, iBufferLen, entData.IntroMusicPath);
	}

	public void GetIntroFadeColor(int iBuffer[4])
	{
		SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData);
		for (int i = 0; i < 4; i++) iBuffer[i] = entData.IntroFadeColor[i]; 
	}

	property float IntroFadeHoldTime
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.IntroFadeHoldTime;
		}
	}

	property float IntroFadeTime
	{
		public get() 
		{
			SF2GamerulesEntityData entData; SF2GamerulesEntityData_Get(this.EntRef, entData); return entData.IntroFadeTime;
		}
	}
}

SF2GamerulesEntity FindSF2GamerulesEntity()
{
	return SF2GamerulesEntity(FindEntityByClassname(-1, g_sEntityClassname));
}

void SF2GamerulesEntity_Initialize()
{
	g_EntityData = new ArrayList(sizeof(SF2GamerulesEntityData));

	SF2MapEntity_AddHook(SF2MapEntityHook_TranslateClassname, SF2GamerulesEntity_TranslateClassname);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityCreated, SF2GamerulesEntity_InitializeEntity);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnLevelInit, SF2GamerulesEntity_OnLevelInit);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnMapStart, SF2GamerulesEntity_OnMapStart);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityDestroyed, SF2GamerulesEntity_OnEntityDestroyed);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnEntityKeyValue, SF2GamerulesEntity_OnEntityKeyValue);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnAcceptEntityInput, SF2GamerulesEntity_OnAcceptEntityInput);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnRoundStateChanged, SF2GamerulesEntity_OnRoundStateChanged);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnGracePeriodEnd, SF2GameRulesEntity_OnGracePeriodEnd);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnDifficultyChanged, SF2GameRulesEntity_OnDifficultyChanged);
	SF2MapEntity_AddHook(SF2MapEntityHook_OnPageCountChanged, SF2GameRulesEntity_OnPageCountChanged);
}

static void SF2GamerulesEntity_OnLevelInit(const char[] sMapName) 
{
	g_EntityData.Clear();
}

static void SF2GamerulesEntity_OnMapStart() 
{
	if (g_EntityData.Length > 1) 
	{
		LogSF2Message("WARNING! There are multiple %s entities in the map!!", g_sEntityClassname);
	}
}

static void SF2GamerulesEntity_InitializeEntity(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;
	
	SF2GamerulesEntityData entData;
	entData.Init(entity);

	g_EntityData.PushArray(entData, sizeof(entData));

	SDKHook(entity, SDKHook_SpawnPost, SF2GamerulesEntity_SpawnPost);
}

static Action SF2GamerulesEntity_OnEntityKeyValue(int entity, const char[] sClass, const char[] szKeyName, const char[] szValue)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	SF2GamerulesEntityData entData;
	SF2GamerulesEntityData_Get(entity, entData);

	SF2GamerulesEntity gameRules = SF2GamerulesEntity(entity);

	if (strcmp(szKeyName, "boss", false) == 0)
	{
		entData.SetBossName(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "maxplayers", false) == 0)
	{
		int iMaxPlayers = StringToInt(szValue);
		if (iMaxPlayers < 1) iMaxPlayers = 1;
		else if (iMaxPlayers > MaxClients) iMaxPlayers = MaxClients;
		
		entData.MaxPlayers = iMaxPlayers;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "maxpages", false) == 0)
	{
		int iPageCount = StringToInt(szValue);
		if (iPageCount < 0) iPageCount = 0;

		entData.MaxPages = iPageCount;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "initialtimelimit", false) == 0) 
	{
		int iRoundTimeLimit = StringToInt(szValue);
		if (iRoundTimeLimit < 0) iRoundTimeLimit = 0;

		entData.InitialTimeLimit = iRoundTimeLimit;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "pagecollectaddtime", false) == 0) 
	{
		int iPageCollectAddTime = StringToInt(szValue);

		entData.PageCollectAddTime = iPageCollectAddTime;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "pagecollectsound", false) == 0)
	{
		entData.SetPageCollectSoundPath(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "escape", false) == 0) 
	{
		entData.HasEscapeObjective = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "escapetime", false) == 0) 
	{
		entData.EscapeTimeLimit = StringToInt(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "stoppagemusiconescape", false) == 0) 
	{
		entData.StopPageMusicOnEscape = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "survive", false) == 0) 
	{
		entData.Survive = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "surviveuntiltime", false) == 0) 
	{
		entData.SurviveUntilTime = StringToInt(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "bosseschaseendlessly", false) == 0) 
	{
		entData.BossesChaseEndlessly = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "infiniteflashlight", false) == 0) 
	{
		entData.InfiniteFlashlight = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "infinitesprint", false) == 0)
	{
		entData.InfiniteSprint = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "infiniteblink", false) == 0)
	{
		entData.InfiniteBlink = StringToInt(szValue) != 0;
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "intromusicpath", false) == 0)
	{
		entData.SetIntroMusicPath(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "introfadecolor", false) == 0)
	{
		char sTokens[4][16];
		int iNumTokens = ExplodeString(szValue, " ", sTokens, 4, 16);

		int iColor[4] = { 0, 0, 0, 255 };
		for (int i = 0; i < iNumTokens && i < 4; i++) {
			int colorVal = StringToInt(sTokens[i]);
			if (colorVal < 0) colorVal = 0;
			else if (colorVal > 255) colorVal = 255;
			
			iColor[i] = colorVal;
		}

		entData.SetIntroMusicColor(iColor);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "introfadeholdtime", false) == 0)
	{
		entData.IntroFadeHoldTime = StringToFloat(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "introfadetime", false) == 0)
	{
		entData.IntroFadeTime = StringToFloat(szValue);
		SF2GamerulesEntityData_Update(entData);

		return Plugin_Handled;
	}
	else if (strcmp(szKeyName, "OnGracePeriodEnded", false) == 0 ||
				strcmp(szKeyName, "OnDifficultyChanged", false) == 0 ||
				strcmp(szKeyName, "OnStateEnterWaiting", false) == 0 ||
				strcmp(szKeyName, "OnStateExitWaiting", false) == 0 ||
				strcmp(szKeyName, "OnStateEnterIntro", false) == 0 ||
				strcmp(szKeyName, "OnStateExitIntro", false) == 0 ||
				strcmp(szKeyName, "OnStateEnterActive", false) == 0 ||
				strcmp(szKeyName, "OnStateExitActive", false) == 0 ||
				strcmp(szKeyName, "OnStateEnterEscape", false) == 0 ||
				strcmp(szKeyName, "OnStateExitEscape", false) == 0 ||
				strcmp(szKeyName, "OnStateEnterOutro", false) == 0 ||
				strcmp(szKeyName, "OnStateExitOutro", false) == 0 ||
				strcmp(szKeyName, "OnCollectedPagesChanged", false) == 0 ||
				strcmp(szKeyName, "OnSurvivalComplete", false) == 0) 
	{
		gameRules.AddOutput(szKeyName, szValue);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static Action SF2GamerulesEntity_OnAcceptEntityInput(int entity, const char[] sClass, const char[] szInputName, int activator, int caller)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;

	if (strcmp(szInputName, "SetTimeLimit", false) == 0) 
	{
		int iRoundTimeLimit = SF2MapEntity_GetIntFromVariant();
		if (iRoundTimeLimit < 0)
			iRoundTimeLimit = 0;

		g_iRoundTimeLimit = iRoundTimeLimit;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetEscapeTimeLimit", false) == 0)
	{
		int iEscapeTimeLimit = SF2MapEntity_GetIntFromVariant();
		if (iEscapeTimeLimit < 0)
			iEscapeTimeLimit = 0;

		g_iRoundEscapeTimeLimit = iEscapeTimeLimit;

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetTime", false) == 0) 
	{
		int iRoundTime = SF2MapEntity_GetIntFromVariant();
		if (iRoundTime < 0) iRoundTime = 0;

		SetRoundTime(iRoundTime);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetTimeToAddOnCollectPage", false) == 0) 
	{
		g_iRoundTimeGainFromPage = SF2MapEntity_GetIntFromVariant();
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetCollectedPages", false) == 0)
	{
		int iPagesCollected = SF2MapEntity_GetIntFromVariant();
		if (iPagesCollected < 0) iPagesCollected = 0;

		SetPageCount(iPagesCollected);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "AddCollectedPages", false) == 0)
	{
		int iPagesCollected = g_iPageCount + SF2MapEntity_GetIntFromVariant();
		if (iPagesCollected < 0) iPagesCollected = 0;
		
		SetPageCount(iPagesCollected);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SubtractCollectedPages", false) == 0)
	{
		int iPagesCollected = g_iPageCount - SF2MapEntity_GetIntFromVariant();
		if (iPagesCollected < 0) iPagesCollected = 0;
		
		SetPageCount(iPagesCollected);
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EnableInfiniteFlashlight", false) == 0) 
	{
		g_bRoundInfiniteFlashlight = true;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DisableInfiniteFlashlight", false) == 0) 
	{
		g_bRoundInfiniteFlashlight = false;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EnableInfiniteSprint", false) == 0) 
	{
		g_bRoundInfiniteSprint = true;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DisableInfiniteSprint", false) == 0) 
	{
		g_bRoundInfiniteSprint = false;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EnableInfiniteBlink", false) == 0) 
	{
		g_bRoundInfiniteBlink = true;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DisableInfiniteBlink", false) == 0) 
	{
		g_bRoundInfiniteBlink = false;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetBoss", false) == 0) 
	{
		char sVariant[SF2_MAX_PROFILE_NAME_LENGTH];
		SF2MapEntity_GetVariantString(sVariant, sizeof(sVariant));

		g_cvBossMain.SetString(sVariant);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetBossOverride", false) == 0) 
	{
		char sVariant[SF2_MAX_PROFILE_NAME_LENGTH];
		SF2MapEntity_GetVariantString(sVariant, sizeof(sVariant));

		g_cvBossProfileOverride.SetString(sVariant);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "ClearBossOverride", false) == 0) 
	{
		g_cvBossProfileOverride.SetString("");
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "SetDifficulty", false) == 0) 
	{
		int iDifficulty = SF2MapEntity_GetIntFromVariant();
		if (iDifficulty < 0) iDifficulty = 0;
		else if (iDifficulty >= Difficulty_Max) iDifficulty = Difficulty_Max - 1;

		g_cvDifficulty.SetInt(iDifficulty);

		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EnableBossesChaseEndlessly", false) == 0)
	{
		g_bBossesChaseEndlessly = true;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "DisableBossesChaseEndlessly", false) == 0)
	{
		g_bBossesChaseEndlessly = false;
		return Plugin_Handled;
	}
	else if (strcmp(szInputName, "EndGracePeriod", false) == 0)
	{
		if (g_bRoundGrace && g_hRoundGraceTimer != INVALID_HANDLE) 
			TriggerTimer(g_hRoundGraceTimer);
		
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

static void SF2GamerulesEntity_SpawnPost(int entity) 
{
}

static void SF2GamerulesEntity_OnRoundStateChanged(SF2RoundState iRoundState, SF2RoundState iOldRoundState)
{
	for (int i = 0; i < g_EntityData.Length; i++) 
	{
		SF2GamerulesEntityData entData;
		g_EntityData.GetArray(i, entData, sizeof(entData));

		if (!IsValidEntity(entData.EntRef))
			continue;

		SF2GamerulesEntity gameRules = SF2GamerulesEntity(entData.EntRef);
		SF2MapEntityVariant inputVariant;
		inputVariant.Init();

		switch (iOldRoundState)
		{
			case SF2RoundState_Waiting:
				gameRules.FireOutput("OnStateExitWaiting", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Intro:
				gameRules.FireOutput("OnStateExitIntro", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Active:
				gameRules.FireOutput("OnStateExitActive", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Escape:
				gameRules.FireOutput("OnStateExitEscape", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Outro:
				gameRules.FireOutput("OnStateExitOutro", -1, entData.EntRef, inputVariant);
		}

		switch (iRoundState)
		{
			case SF2RoundState_Waiting:
				gameRules.FireOutput("OnStateEnterWaiting", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Intro:
				gameRules.FireOutput("OnStateEnterIntro", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Active:
				gameRules.FireOutput("OnStateEnterActive", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Escape:
				gameRules.FireOutput("OnStateEnterEscape", -1, entData.EntRef, inputVariant);
			case SF2RoundState_Outro:
				gameRules.FireOutput("OnStateEnterOutro", -1, entData.EntRef, inputVariant);
		}
	}
}

static void SF2GameRulesEntity_OnPageCountChanged(int iPageCount, int iOldPageCount)
{
	for (int i = 0; i < g_EntityData.Length; i++) 
	{
		SF2GamerulesEntityData entData;
		g_EntityData.GetArray(i, entData, sizeof(entData));

		if (!IsValidEntity(entData.EntRef))
			continue;
		
		SF2MapEntityVariant inputVariant;
		inputVariant.Init();
		inputVariant.SetInt(iPageCount);
		SF2GamerulesEntity(entData.EntRef).FireOutput("OnCollectedPagesChanged", -1, entData.EntRef, inputVariant);
	}
}

static void SF2GameRulesEntity_OnGracePeriodEnd()
{
	for (int i = 0; i < g_EntityData.Length; i++) 
	{
		SF2GamerulesEntityData entData;
		g_EntityData.GetArray(i, entData, sizeof(entData));

		if (!IsValidEntity(entData.EntRef))
			continue;
		
		SF2GamerulesEntity(entData.EntRef).FireOutputNoVariant("OnGracePeriodEnded", -1, entData.EntRef);
	}
}

static void SF2GameRulesEntity_OnDifficultyChanged(int iDifficulty, int iOldDifficulty)
{
	for (int i = 0; i < g_EntityData.Length; i++) 
	{
		SF2GamerulesEntityData entData;
		g_EntityData.GetArray(i, entData, sizeof(entData));

		if (!IsValidEntity(entData.EntRef))
			continue;
		
		SF2MapEntityVariant inputVariant;
		inputVariant.Init();
		inputVariant.SetInt(iDifficulty);
		SF2GamerulesEntity(entData.EntRef).FireOutput("OnDifficultyChanged", -1, entData.EntRef, inputVariant);
	}
}

static void SF2GamerulesEntity_OnEntityDestroyed(int entity, const char[] sClass)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return;

	SF2GamerulesEntityData entData;
	int iIndex = SF2GamerulesEntityData_Get(entity, entData);
	if (iIndex != -1)
	{
		g_EntityData.Erase(iIndex);
	}
}

static Action SF2GamerulesEntity_TranslateClassname(const char[] sClass, char[] sBuffer, int iBufferLen)
{
	if (strcmp(sClass, g_sEntityClassname, false) != 0) 
		return Plugin_Continue;
	
	strcopy(sBuffer, iBufferLen, g_sEntityTranslatedClassname);
	return Plugin_Handled;
}

static int SF2GamerulesEntityData_Get(int entIndex, SF2GamerulesEntityData entData)
{
	entData.EntRef = EnsureEntRef(entIndex);
	if (entData.EntRef == INVALID_ENT_REFERENCE)
		return -1;

	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return -1;
	
	g_EntityData.GetArray(iIndex, entData, sizeof(entData));
	return iIndex;
}

static int SF2GamerulesEntityData_Update(SF2GamerulesEntityData entData)
{
	int iIndex = g_EntityData.FindValue(entData.EntRef);
	if (iIndex == -1)
		return;
	
	g_EntityData.SetArray(iIndex, entData, sizeof(entData));
}