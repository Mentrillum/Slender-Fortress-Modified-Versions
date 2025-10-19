#if defined _sf2_natives_included
 #endinput
#endif
#define _sf2_natives_included

#pragma semicolon 1

//	==========================================================
//	GENERAL PLUGIN HOOK FUNCTIONS
//	==========================================================

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	RegPluginLibrary("sf2");

	g_OnBossChangeStateFwd = new GlobalForward("SF2_OnBossChangeState", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_OnBossGetSpeedFwd = new GlobalForward("SF2_OnBossGetSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	g_OnBossGetWalkSpeedFwd = new GlobalForward("SF2_OnBossGetWalkSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	g_OnBossHearEntityFwd = new GlobalForward("SF2_OnBossHearEntity", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	g_OnBossSeeEntityFwd = new GlobalForward("SF2_OnBossSeeEntity", ET_Hook, Param_Cell, Param_Cell);
	g_OnBossStunnedFwd = new GlobalForward("SF2_OnBossStunned", ET_Ignore, Param_Cell, Param_Cell);
	g_OnBossKilledFwd = new GlobalForward("SF2_OnBossKilled", ET_Ignore, Param_Cell, Param_Cell);
	g_OnBossCloakedFwd = new GlobalForward("SF2_OnBossCloaked", ET_Ignore, Param_Cell);
	g_OnBossDecloakedFwd = new GlobalForward("SF2_OnBossDecloaked", ET_Ignore, Param_Cell);
	g_OnBossPreAttackFwd = new GlobalForward("SF2_OnBossPreAttack", ET_Ignore, Param_Cell, Param_Cell);
	g_OnBossAttackedFwd = new GlobalForward("SF2_OnBossAttacked", ET_Ignore, Param_Cell, Param_Cell);
	g_OnBossPreTakeDamageFwd = new GlobalForward("SF2_OnBossPreTakeDamage", ET_Hook, Param_Cell, Param_Cell, Param_Cell, Param_Cell);
	g_OnBossPreFlashlightDamageFwd = new GlobalForward("SF2_OnBossPreFlashlightDamage", ET_Hook, Param_Cell, Param_Cell);
	g_OnBossAnimationUpdateFwd = new GlobalForward("SF2_OnBossAnimationUpdate", ET_Hook, Param_Cell, Param_String);
	g_OnChaserBossGetSuspendActionFwd = new GlobalForward("SF2_OnChaserBossGetSuspendAction", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnPagesSpawnedFwd = new GlobalForward("SF2_OnPagesSpawned", ET_Ignore);
	g_OnRoundStateChangeFwd = new GlobalForward("SF2_OnRoundStateChange", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientCollectPageFwd = new GlobalForward("SF2_OnClientCollectPage", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientBlinkFwd = new GlobalForward("SF2_OnClientBlink", ET_Ignore, Param_Cell);
	g_OnClientScareFwd = new GlobalForward("SF2_OnClientScare", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientGiveQueuePointsFwd = new GlobalForward("SF2_OnClientGiveQueuePoints", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnClientActivateFlashlightFwd = new GlobalForward("SF2_OnClientActivateFlashlight", ET_Ignore, Param_Cell);
	g_OnClientDeactivateFlashlightFwd = new GlobalForward("SF2_OnClientDeactivateFlashlight", ET_Ignore, Param_Cell);
	g_OnClientBreakFlashlightFwd = new GlobalForward("SF2_OnClientBreakFlashlight", ET_Ignore, Param_Cell);
	g_OnClientStartSprintingFwd = new GlobalForward("SF2_OnClientStartSprinting", ET_Ignore, Param_Cell);
	g_OnClientStopSprintingFwd = new GlobalForward("SF2_OnClientStopSprinting", ET_Ignore, Param_Cell);
	g_OnClientEscapeFwd = new GlobalForward("SF2_OnClientEscape", ET_Ignore, Param_Cell);
	g_OnClientLooksAtBossFwd = new GlobalForward("SF2_OnClientLooksAtBoss", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientLooksAwayFromBossFwd = new GlobalForward("SF2_OnClientLooksAwayFromBoss", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientStartDeathCamFwd = new GlobalForward("SF2_OnClientStartDeathCam", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientPreKillDeathCamFwd = new GlobalForward("SF2_OnClientPreKillDeathCam", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientEndDeathCamFwd = new GlobalForward("SF2_OnClientEndDeathCam", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_OnClientGetDefaultWalkSpeedFwd = new GlobalForward("SF2_OnClientGetDefaultWalkSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnClientGetDefaultSprintSpeedFwd = new GlobalForward("SF2_OnClientGetDefaultSprintSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnClientTakeDamageFwd = new GlobalForward("SF2_OnClientTakeDamage", ET_Hook, Param_Cell, Param_CellByRef, Param_CellByRef, Param_FloatByRef);
	g_OnClientSpawnedAsProxyFwd = new GlobalForward("SF2_OnClientSpawnedAsProxy", ET_Ignore, Param_Cell);
	g_OnClientDamagedByBossFwd = new GlobalForward("SF2_OnClientDamagedByBoss", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Float, Param_Cell);
	g_OnGroupGiveQueuePointsFwd = new GlobalForward("SF2_OnGroupGiveQueuePoints", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnBossPackVoteStartFwd = new GlobalForward("SF2_OnBossPackVoteStart", ET_Ignore);
	g_OnDifficultyChangeFwd = new GlobalForward("SF2_OnDifficultyChanged", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientEnterGameFwd = new GlobalForward("SF2_OnClientEnterGame", ET_Hook, Param_Cell);
	g_OnGroupEnterGameFwd = new GlobalForward("SF2_OnGroupEnterGame", ET_Hook, Param_Cell);
	g_OnEverythingLoadedFwd = new GlobalForward("SF2_OnEverythingLoaded", ET_Ignore);
	g_OnDifficultyVoteFinishedFwd = new GlobalForward("SF2_OnDifficultyVoteFinished", ET_Ignore, Param_Cell, Param_Cell);
	g_OnIsBossCustomAttackPossibleFwd = new GlobalForward("SF2_OnIsBossCustomAttackPossible", ET_Hook, Param_Cell, Param_String, Param_Array, Param_Cell);
	g_OnBossGetCustomAttackActionFwd = new GlobalForward("SF2_OnBossGetCustomAttackAction", ET_Hook, Param_Cell, Param_String, Param_Array, Param_Cell, Param_CellByRef);
	g_OnProjectileTouchFwd = new GlobalForward("SF2_OnProjectileTouch", ET_Ignore, Param_Cell, Param_Cell);

	CreateNative("SF2_GetConfig", Native_GetConfig);
	CreateNative("SF2_IsRunning", Native_IsRunning);
	CreateNative("SF2_GetRoundState", Native_GetRoundState);
	CreateNative("SF2_IsRoundInGracePeriod", Native_IsRoundInGracePeriod);
	CreateNative("SF2_GetCurrentDifficulty", Native_GetCurrentDifficulty);
	CreateNative("SF2_GetBossDifficulty", Native_GetBossDifficulty);
	CreateNative("SF2_GetDifficultyModifier", Native_GetDifficultyModifier);
	CreateNative("SF2_IsInSpecialRound", Native_IsInSpecialRound);
	CreateNative("SF2_GetCurrentBossPack", Native_GetCurrentBossPack);

	CreateNative("SF2_GetClientGroup", Native_GetClientGroup);
	CreateNative("SF2_GetClientQueuePoints", Native_GetClientQueuePoints);
	CreateNative("SF2_SetClientQueuePoints", Native_SetClientQueuePoints);

	CreateNative("SF2_IsValidClient", Native_IsValidClient);
	CreateNative("SF2_IsClientCritBoosted", Native_IsClientCritBoosted);
	CreateNative("SF2_IsClientMiniCritBoosted", Native_IsClientMiniCritBoosted);
	CreateNative("SF2_IsClientUbercharged", Native_IsClientUbercharged);
	CreateNative("SF2_IsClientInKart", Native_IsClientInKart);
	CreateNative("SF2_IsClientInCondition", Native_IsClientInCondition);
	CreateNative("SF2_IsClientEliminated", Native_IsClientEliminated);
	CreateNative("SF2_IsClientInGhostMode", Native_IsClientInGhostMode);
	CreateNative("SF2_IsClientProxy", Native_IsClientProxy);

	CreateNative("SF2_GetClientBlinkCount", Native_GetClientBlinkCount);
	CreateNative("SF2_IsClientBlinking", Native_IsClientBlinking);
	CreateNative("SF2_GetClientBlinkMeter", Native_GetClientBlinkMeter);
	CreateNative("SF2_SetClientBlinkMeter", Native_SetClientBlinkMeter);

	CreateNative("SF2_GetClientProxyMaster", Native_GetClientProxyMaster);
	CreateNative("SF2_GetClientProxyControlAmount", Native_GetClientProxyControlAmount);
	CreateNative("SF2_GetClientProxyControlRate", Native_GetClientProxyControlRate);
	CreateNative("SF2_SetClientProxyMaster", Native_SetClientProxyMaster);
	CreateNative("SF2_SetClientProxyControlAmount", Native_SetClientProxyControlAmount);
	CreateNative("SF2_SetClientProxyControlRate", Native_SetClientProxyControlRate);

	CreateNative("SF2_IsClientLookingAtBoss", Native_IsClientLookingAtBoss);
	CreateNative("SF2_DidClientEscape", Native_DidClientEscape);
	CreateNative("SF2_ForceClientEscape", Native_ForceClientEscape);

	CreateNative("SF2_GetClientFlashlightBatteryLife", Native_GetClientFlashlightBatteryLife);
	CreateNative("SF2_SetClientFlashlightBatteryLife", Native_SetClientFlashlightBatteryLife);
	CreateNative("SF2_IsClientUsingFlashlight", Native_IsClientUsingFlashlight);

	CreateNative("SF2_IsClientTrapped", Native_IsClientTrapped);
	CreateNative("SF2_IsClientInDeathCam", Native_IsClientInDeathCam);
	CreateNative("SF2_ClientStartDeathCam", Native_ClientStartDeathCam);

	CreateNative("SF2_ClientSpawnProxy", Native_ClientSpawnProxy);
	CreateNative("SF2_ClientForceProxy", Native_ClientForceProxy);

	CreateNative("SF2_CollectAsPage", Native_CollectAsPage);
	CreateNative("SF2_GetEmptyPageSpawnPoints", Native_GetEmptyPageSpawnPoints);

	CreateNative("SF2_ForceBossJump", Native_ForceBossJump);

	CreateNative("SF2_GetBossModelEntity", Native_GetBossModelEntity);

	CreateNative("SF2_GetBossTarget", Native_GetBossTarget);
	CreateNative("SF2_SetBossTarget", Native_SetBossTarget);

	CreateNative("SF2_IsBossStunnable", Native_IsBossStunnable);
	CreateNative("SF2_IsBossStunnableByFlashlight", Native_IsBossStunnableByFlashlight);
	CreateNative("SF2_IsBossCloaked", Native_IsBossCloaked);
	CreateNative("SF2_GetBossStunHealth", Native_GetBossStunHealth);
	CreateNative("SF2_SetBossStunHealth", Native_SetBossStunHealth);

	CreateNative("SF2_GetVectorSquareMagnitude", Native_GetVectorSquareMagnitude);
	CreateNative("SF2_InitiateBossPackVote", Native_InitiateBossPackVote);
	CreateNative("SF2_IsSurvivalMap", Native_IsSurvivalMap);
	CreateNative("SF2_IsBoxingMap", Native_IsBoxingMap);
	CreateNative("SF2_IsRaidMap", Native_IsRaidMap);
	CreateNative("SF2_IsProxyMap", Native_IsProxyMap);
	CreateNative("SF2_IsSlaughterRunMap", Native_IsSlaughterRunMap);

	SF2_BaseBoss.SetupAPI();
	SF2_PlaySequenceAndWait.SetupAPI();
	NPC_InitializeAPI();
	NPCChaser_InitializeAPI();
	NPCStatue_InitializeAPI();

	Client_SetupAPI();

	PvP_InitializeAPI();
	PvE_InitializeAPI();

	Renevant_InitializeAPI();

	SpecialRoundInitializeAPI();

	SetupMethodmapAPI();

	SetupCustomEntitiesAPI();

	SetupBossProfileNatives();

	#if defined _steamtools_included
	MarkNativeAsOptional("Steam_SetGameDescription");
	#endif
	#if defined _SteamWorks_Included
	MarkNativeAsOptional("SteamWorks_SetGameDescription");
	#endif

	return APLRes_Success;
}

void SDK_Init()
{
	// Check SDKHooks gamedata.
	GameData gameData = new GameData("sdkhooks.games");
	if (gameData == null)
	{
		SetFailState("Couldn't find SDKHooks gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "GetMaxHealth");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_SDKGetMaxHealth = EndPrepSDKCall()) == null)
	{
		SetFailState("Failed to retrieve GetMaxHealth offset from SDKHooks gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "StartTouch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_SDKStartTouch = EndPrepSDKCall();
	if (g_SDKStartTouch == null)
	{
		SetFailState("Failed to retrieve StartTouch offset from SDKHooks gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "EndTouch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_SDKEndTouch = EndPrepSDKCall();
	if (g_SDKEndTouch == null)
	{
		SetFailState("Failed to retrieve EndTouch offset from SDKHooks gamedata!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "Weapon_Switch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_SDKWeaponSwitch = EndPrepSDKCall();
	if (g_SDKWeaponSwitch == null)
	{
		SetFailState("Failed to retrieve Weapon_Switch offset from SDKHooks gamedata!");
	}

	delete gameData;

	// Check our own gamedata.
	gameData = new GameData("sf2");
	if (gameData == null)
	{
		SetFailState("Could not find SF2 gamedata!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CTFPlayer::EquipWearable");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_SDKEquipWearable = EndPrepSDKCall();
	if (g_SDKEquipWearable == null)//In case the offset is missing, look if the server has the tf2 randomizer's gamedata.
	{
		char strFilePath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, strFilePath, sizeof(strFilePath), "gamedata/tf2items.randomizer.txt");
		if (FileExists(strFilePath))
		{
			GameData gameConf = LoadGameConfigFile("tf2items.randomizer");
			if (gameConf != null)
			{
				StartPrepSDKCall(SDKCall_Player);
				PrepSDKCall_SetFromConf(gameConf, SDKConf_Virtual, "CTFPlayer::EquipWearable");
				PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer );
				g_SDKEquipWearable = EndPrepSDKCall();
				if (g_SDKEquipWearable == null)
				{
					// Old gamedata
					StartPrepSDKCall(SDKCall_Player);
					PrepSDKCall_SetFromConf(gameConf, SDKConf_Virtual, "EquipWearable");
					PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
					g_SDKEquipWearable = EndPrepSDKCall();
				}
			}
			delete gameConf;
		}
	}
	if (g_SDKEquipWearable == null)
	{
		SetFailState("Failed to retrieve CTFPlayer::EquipWearable offset from SF2 gamedata!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CTFPlayer::PlaySpecificSequence");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	g_SDKPlaySpecificSequence = EndPrepSDKCall();
	if (g_SDKPlaySpecificSequence == null)
	{
		PrintToServer("Failed to retrieve CTFPlayer::PlaySpecificSequence signature from SF2 gamedata!");
		//Don't have to call SetFailState, since this function is used in a minor part of the code.
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CBaseTrigger::PointIsWithin");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
	g_SDKPointIsWithin = EndPrepSDKCall();
	if (g_SDKPointIsWithin == null)
	{
		PrintToServer("Failed to retrieve CBaseTrigger::PointIsWithin signature from SF2 gamedata!");
		//Don't have to call SetFailState, since this function is used in a minor part of the code.
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CBaseTrigger::PassesTriggerFilters");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_SDKPassesTriggerFilters = EndPrepSDKCall()) == null)
	{
		SetFailState("Failed to setup CBaseTrigger::PassesTriggerFilters call from gamedata!");
	}

	/*StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CBaseEntity::GetSmoothedVelocity");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_ByValue);
	if ((g_SDKGetSmoothedVelocity = EndPrepSDKCall()) == null)
	{
		SetFailState("Couldn't find CBaseEntity::GetSmoothedVelocity offset from SF2 gamedata!");
	}*/

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CBaseAnimating::LookupBone");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_SDKLookupBone = EndPrepSDKCall()) == null)
	{
		LogError("Failed to setup CBaseAnimating::LookupBone call from gamedata!");
	}

	// void CBaseAnimating::GetBonePosition ( int iBone, Vector &origin, QAngle &angles )
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "CBaseAnimating::GetBonePosition");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, .encflags = VENCODE_FLAG_COPYBACK);
	PrepSDKCall_AddParameter(SDKType_QAngle, SDKPass_ByRef, .encflags = VENCODE_FLAG_COPYBACK);
	if ((g_SDKGetBonePosition = EndPrepSDKCall()) == null)
	{
		LogError("Failed to setup CBaseAnimating::GetBonePosition call from gamedata");
	}

	StartPrepSDKCall(SDKCall_Static);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Signature, "Studio_SeqVelocity");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, .encflags = VENCODE_FLAG_COPYBACK);
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
	if ((g_SDKSequenceVelocity = EndPrepSDKCall()) == null)
	{
		LogError("Failed to setup Studio_SeqVelocity call from gamedata");
	}

	//Hook_ClientWantsLagCompensationOnEntity
	int offset = gameData.GetOffset("CTFPlayer::WantsLagCompensationOnEntity");
	g_DHookWantsLagCompensationOnEntity = new DynamicHook(offset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity);
	if (g_DHookWantsLagCompensationOnEntity == null)
	{
		SetFailState("Failed to create hook CTFPlayer::WantsLagCompensationOnEntity offset from SF2 gamedata!");
	}

	DHookAddParam(g_DHookWantsLagCompensationOnEntity, HookParamType_CBaseEntity);
	DHookAddParam(g_DHookWantsLagCompensationOnEntity, HookParamType_ObjectPtr);
	DHookAddParam(g_DHookWantsLagCompensationOnEntity, HookParamType_Unknown);
	//Hook_EntityShouldTransmit
	offset = gameData.GetOffset("CBaseEntity::ShouldTransmit");
	g_DHookShouldTransmit = new DynamicHook(offset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (g_DHookShouldTransmit == null)
	{
		SetFailState("Failed to create hook CBaseEntity::ShouldTransmit offset from SF2 gamedata!");
	}
	DHookAddParam(g_DHookShouldTransmit, HookParamType_ObjectPtr);

	offset = gameData.GetOffset("CBaseEntity::UpdateTransmitState");
	g_DHookUpdateTransmitState = new DynamicHook(offset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (!g_DHookUpdateTransmitState)
	{
		SetFailState("Failed to create hook CBaseEntity::UpdateTransmitState offset from SF2 gamedata!");
	}
	//Hook_WeaponGetCustomDamageType
	offset = gameData.GetOffset("CTFWeaponBase::GetCustomDamageType");
	g_DHookWeaponGetCustomDamageType = new DynamicHook(offset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (g_DHookWeaponGetCustomDamageType == null)
	{
		SetFailState("Failed to create hook CTFWeaponBase::GetCustomDamageType offset from SF2 gamedata!");
	}

	offset = gameData.GetOffset("CBaseProjectile::CanCollideWithTeammates");
	g_DHookProjectileCanCollideWithTeammates = new DynamicHook(offset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity);
	if (g_DHookProjectileCanCollideWithTeammates == null)
	{
		SetFailState("Failed to create hook CBaseProjectile::CanCollideWithTeammates offset from SF2 gamedata!");
	}

	//Initialize tutorial detours & calls
	//Tutorial_SetupSDK(gameData);

	delete gameData;
}

//	==========================================================
//	API
//	==========================================================

static any Native_GetConfig(Handle plugin, int numParams)
{
	return g_Config;
}

static any Native_IsRunning(Handle plugin, int numParams)
{
	return g_Enabled;
}

static any Native_GetRoundState(Handle plugin, int numParams)
{
	return g_RoundState;
}

static any Native_IsRoundInGracePeriod(Handle plugin, int numParams)
{
	return GetRoundState() == SF2RoundState_Grace;
}

static any Native_GetCurrentDifficulty(Handle plugin, int numParams)
{
	return g_DifficultyConVar.IntValue;
}

static any Native_GetBossDifficulty(Handle plugin, int numParams)
{
	return GetLocalGlobalDifficulty(GetNativeCell(1));
}

static any Native_GetDifficultyModifier(Handle plugin, int numParams)
{
	int difficulty = GetNativeCell(1);
	if (difficulty < Difficulty_Normal || difficulty >= Difficulty_Max)
	{
		LogError("Difficulty parameter can only be from %d to %d!", Difficulty_Normal, Difficulty_Max - 1);
		return 1;
	}

	switch (difficulty)
	{
		case Difficulty_Hard:
		{
			return DIFFICULTYMODIFIER_HARD;
		}
		case Difficulty_Insane:
		{
			return DIFFICULTYMODIFIER_INSANE;
		}
		case Difficulty_Nightmare:
		{
			return DIFFICULTYMODIFIER_NIGHTMARE;
		}
		case Difficulty_Apollyon:
		{
			return DIFFICULTYMODIFIER_APOLLYON;
		}
	}

	return DIFFICULTYMODIFIER_NORMAL;
}

static any Native_IsInSpecialRound(Handle plugin, int numParams)
{
	return SF_SpecialRound(GetNativeCell(1));
}

static any Native_GetCurrentBossPack(Handle plugin, int numParams)
{
	int length = GetNativeCell(2);
	char[] bossPackName = new char[++length];
	GetCurrentBossPack(bossPackName, length);
	SetNativeString(1, bossPackName, length, _, length);
	return length;
}

static any Native_GetClientGroup(Handle plugin, int numParams)
{
	return ClientGetPlayerGroup(GetNativeCell(1));
}

static any Native_GetClientQueuePoints(Handle plugin, int numParams)
{
	return g_PlayerQueuePoints[GetNativeCell(1)];
}

static any Native_SetClientQueuePoints(Handle plugin, int numParams)
{
	g_PlayerQueuePoints[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

static any Native_IsValidClient(Handle plugin, int numParams)
{
	return IsValidClient(GetNativeCell(1));
}

static any Native_IsClientCritBoosted(Handle plugin, int numParams)
{
	return IsClientCritBoosted(GetNativeCell(1));
}

static any Native_IsClientMiniCritBoosted(Handle plugin, int numParams)
{
	return TF2_IsMiniCritBuffed(GetNativeCell(1));
}

static any Native_IsClientUbercharged(Handle plugin, int numParams)
{
	return IsClientCritUbercharged(GetNativeCell(1));
}

static any Native_IsClientInKart(Handle plugin, int numParams)
{
	return IsClientInKart(GetNativeCell(1));
}

static any Native_IsClientInCondition(Handle plugin, int numParams)
{
	return TF2_IsPlayerInCondition(GetNativeCell(1), GetNativeCell(2));
}

static any Native_IsClientEliminated(Handle plugin, int numParams)
{
	return g_PlayerEliminated[GetNativeCell(1)];
}

static any Native_IsClientInGhostMode(Handle plugin, int numParams)
{
	return IsClientInGhostMode(GetNativeCell(1));
}

static any Native_IsClientProxy(Handle plugin, int numParams)
{
	return g_PlayerProxy[GetNativeCell(1)];
}

static any Native_GetClientBlinkCount(Handle plugin, int numParams)
{
	return ClientGetBlinkCount(GetNativeCell(1));
}

static any Native_IsClientBlinking(Handle plugin, int numParams)
{
	return IsClientBlinking(GetNativeCell(1));
}

static any Native_GetClientBlinkMeter(Handle plugin, int numParams)
{
	return ClientGetBlinkMeter(GetNativeCell(1));
}

static any Native_SetClientBlinkMeter(Handle plugin, int numParams)
{
	ClientSetBlinkMeter(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

static any Native_GetClientProxyMaster(Handle plugin, int numParams)
{
	return NPCGetFromUniqueID(g_PlayerProxyMaster[GetNativeCell(1)]);
}

static any Native_GetClientProxyControlAmount(Handle plugin, int numParams)
{
	return g_PlayerProxyControl[GetNativeCell(1)];
}

static any Native_GetClientProxyControlRate(Handle plugin, int numParams)
{
	return g_PlayerProxyControlRate[GetNativeCell(1)];
}

static any Native_SetClientProxyMaster(Handle plugin, int numParams)
{
	g_PlayerProxyMaster[GetNativeCell(1)] = NPCGetUniqueID(GetNativeCell(2));
	return 0;
}

static any Native_SetClientProxyControlAmount(Handle plugin, int numParams)
{
	g_PlayerProxyControl[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

static any Native_SetClientProxyControlRate(Handle plugin, int numParams)
{
	g_PlayerProxyControlRate[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

static any Native_IsClientLookingAtBoss(Handle plugin, int numParams)
{
	return g_PlayerSeesSlender[GetNativeCell(1)][GetNativeCell(2)];
}

static any Native_DidClientEscape(Handle plugin, int numParams)
{
	return DidClientEscape(GetNativeCell(1));
}

static any Native_ForceClientEscape(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);

	ClientEscape(client);
	TeleportClientToEscapePoint(client);
	return 0;
}

static any Native_GetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	return ClientGetFlashlightBatteryLife(GetNativeCell(1));
}

static any Native_SetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	ClientSetFlashlightBatteryLife(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

static any Native_IsClientUsingFlashlight(Handle plugin, int numParams)
{
	return IsClientUsingFlashlight(GetNativeCell(1));
}

static any Native_IsClientTrapped(Handle plugin, int numParams)
{
	return g_PlayerTrapped[GetNativeCell(1)];
}

static any Native_IsClientInDeathCam(Handle plugin, int numParams)
{
	return IsClientInDeathCam(GetNativeCell(1));
}

static any Native_ClientStartDeathCam(Handle plugin, int numParams)
{
	float pos[3];
	GetNativeArray(3, pos, sizeof(pos));
	ClientStartDeathCam(GetNativeCell(1), GetNativeCell(2), pos, GetNativeCell(4), GetNativeCell(5));
	return 0;
}

static any Native_ClientSpawnProxy(Handle plugin, int numParams)
{
	float teleportPos[3];
	GetNativeArray(3, teleportPos, 3);
	int spawnPoint = GetNativeCell(4);
	return SpawnProxy(GetNativeCell(1), GetNativeCell(2), teleportPos, spawnPoint);
}

static any Native_ClientForceProxy(Handle plugin, int numParams)
{
	float teleportPos[3];
	GetNativeArray(3, teleportPos, 3);
	ClientStartProxyForce(GetNativeCell(1), GetNativeCell(2), teleportPos, GetNativeCell(4));
	return 0;
}

static any Native_CollectAsPage(Handle plugin, int numParams)
{
	CollectPage(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

static any Native_GetEmptyPageSpawnPoints(Handle plugin, int numParams)
{
	return g_EmptySpawnPagePoints;
}

static any Native_ForceBossJump(Handle plugin, int numParams)
{
	float startPos[3], endPos[3];
	GetNativeArray(2, startPos, 3);
	GetNativeArray(3, endPos, 3);
	//CBaseNPC_Jump(GetNativeCell(1), startPos, endPos);
	return 0;
}

static any Native_GetBossModelEntity(Handle plugin, int numParams)
{
	return EntRefToEntIndex(g_SlenderEnt[GetNativeCell(1)]);
}

static any Native_GetBossTarget(Handle plugin, int numParams)
{
	SF2_BaseBoss boss = SF2_BaseBoss(NPCGetEntIndex(GetNativeCell(1)));
	return boss.Target.index;
}

static any Native_SetBossTarget(Handle plugin, int numParams)
{
	SF2_BaseBoss boss = SF2_BaseBoss(NPCGetEntIndex(GetNativeCell(1)));
	boss.Target = CBaseEntity(GetNativeCell(2));
	return 0;
}

static any Native_IsBossStunnable(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).GetProfileData().StunData.Enabled[1];
}

static any Native_IsBossStunnableByFlashlight(Handle plugin, int numParams)
{
	SF2ChaserBossProfileData data;
	data = NPCChaserGetProfileData(GetNativeCell(1));
	return data.StunData.FlashlightStun[1];
}

static any Native_IsBossCloaked(Handle plugin, int numParams)
{
	return SF2_ChaserEntity(NPCGetEntIndex(GetNativeCell(1))).HasCloaked;
}

static any Native_GetBossStunHealth(Handle plugin, int numParams)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(GetNativeCell(1)));
	if (!chaser.IsValid())
	{
		return 0;
	}
	return chaser.StunHealth;
}

static any Native_SetBossStunHealth(Handle plugin, int numParams)
{
	SF2_ChaserEntity chaser = SF2_ChaserEntity(NPCGetEntIndex(GetNativeCell(1)));
	if (!chaser.IsValid())
	{
		return 0;
	}
	chaser.StunHealth = GetNativeCell(2);
	return 0;
}

static any Native_GetVectorSquareMagnitude(Handle plugin, int numParams)
{
	float vec1[3], vec2[3];
	GetNativeArray(1, vec1, 3);
	GetNativeArray(2, vec2, 3);
	return GetVectorSquareMagnitude(vec1, vec2);
}

static any Native_InitiateBossPackVote(Handle plugin, int numParams)
{
	InitiateBossPackVote(GetNativeCell(1));
	return 0;
}

static any Native_IsSurvivalMap(Handle plugin, int numParams)
{
	return SF_IsSurvivalMap();
}

static any Native_IsBoxingMap(Handle plugin, int numParams)
{
	return SF_IsBoxingMap();
}

static any Native_IsRaidMap(Handle plugin, int numParams)
{
	return SF_IsRaidMap();
}

static any Native_IsProxyMap(Handle plugin, int numParams)
{
	return SF_IsProxyMap();
}

static any Native_IsSlaughterRunMap(Handle plugin, int numParams)
{
	return SF_IsSlaughterRunMap();
}