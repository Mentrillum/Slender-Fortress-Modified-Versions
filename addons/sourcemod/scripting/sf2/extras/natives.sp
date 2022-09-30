#if defined _sf2_natives_included
 #endinput
#endif
#define _sf2_natives_included

#pragma semicolon 1

//	==========================================================
//	GENERAL PLUGIN HOOK FUNCTIONS
//	==========================================================

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error,int err_max)
{
	RegPluginLibrary("sf2");

	g_OnBossAddedFwd = new GlobalForward("SF2_OnBossAdded", ET_Ignore, Param_Cell);
	g_OnBossSpawnFwd = new GlobalForward("SF2_OnBossSpawn", ET_Ignore, Param_Cell);
	g_OnBossDespawnFwd = new GlobalForward("SF2_OnBossDespawn", ET_Ignore, Param_Cell);
	g_OnBossChangeStateFwd = new GlobalForward("SF2_OnBossChangeState", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	g_OnBossAnimationUpdateFwd = new GlobalForward("SF2_OnBossAnimationUpdate", ET_Hook, Param_Cell);
	g_OnBossGetSpeedFwd = new GlobalForward("SF2_OnBossGetSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	g_OnBossGetWalkSpeedFwd = new GlobalForward("SF2_OnBossGetWalkSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	g_OnBossHearEntityFwd = new GlobalForward("SF2_OnBossHearEntity", ET_Hook, Param_Cell, Param_Cell, Param_Cell);
	g_OnBossSeeEntityFwd = new GlobalForward("SF2_OnBossSeeEntity", ET_Hook, Param_Cell, Param_Cell);
	g_OnBossRemovedFwd = new GlobalForward("SF2_OnBossRemoved", ET_Ignore, Param_Cell);
	g_OnBossStunnedFwd = new GlobalForward("SF2_OnBossStunned", ET_Ignore, Param_Cell, Param_Cell);
	g_OnBossCloakedFwd = new GlobalForward("SF2_OnBossCloaked", ET_Ignore, Param_Cell);
	g_OnBossDecloakedFwd = new GlobalForward("SF2_OnBossDecloaked", ET_Ignore, Param_Cell);
	g_OnBossFinishSpawningFwd = new GlobalForward("SF2_OnBossFinishSpawning", ET_Ignore, Param_Cell);
	g_OnBossPreAttackFwd = new GlobalForward("SF2_OnBossPreAttack", ET_Ignore, Param_Cell, Param_Cell);
	g_OnPagesSpawnedFwd = new GlobalForward("SF2_OnPagesSpawned", ET_Ignore);
	g_OnRoundStateChangeFwd = new GlobalForward("SF2_OnRoundStateChange", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientCollectPageFwd = new GlobalForward("SF2_OnClientCollectPage", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientBlinkFwd = new GlobalForward("SF2_OnClientBlink", ET_Ignore, Param_Cell);
	g_OnClientScareFwd = new GlobalForward("SF2_OnClientScare", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientCaughtByBossFwd = new GlobalForward("SF2_OnClientCaughtByBoss", ET_Ignore, Param_Cell, Param_Cell);
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
	g_OnClientEndDeathCamFwd = new GlobalForward("SF2_OnClientEndDeathCam", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientGetDefaultWalkSpeedFwd = new GlobalForward("SF2_OnClientGetDefaultWalkSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnClientGetDefaultSprintSpeedFwd = new GlobalForward("SF2_OnClientGetDefaultSprintSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnClientTakeDamageFwd = new GlobalForward("SF2_OnClientTakeDamage", ET_Hook, Param_Cell, Param_CellByRef, Param_CellByRef, Param_FloatByRef);
	g_OnClientSpawnedAsProxyFwd = new GlobalForward("SF2_OnClientSpawnedAsProxy", ET_Ignore, Param_Cell);
	g_OnClientDamagedByBossFwd = new GlobalForward("SF2_OnClientDamagedByBoss", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Float, Param_Cell);
	g_OnGroupGiveQueuePointsFwd = new GlobalForward("SF2_OnGroupGiveQueuePoints", ET_Hook, Param_Cell, Param_CellByRef);
	g_OnRenevantTriggerWaveFwd = new GlobalForward("SF2_OnRenevantWaveTrigger", ET_Ignore, Param_Cell);
	g_OnBossPackVoteStartFwd = new GlobalForward("SF2_OnBossPackVoteStart", ET_Ignore);
	g_OnDifficultyChangeFwd = new GlobalForward("SF2_OnDifficultyChanged", ET_Ignore, Param_Cell, Param_Cell);
	g_OnClientEnterGameFwd = new GlobalForward("SF2_OnClientEnterGame", ET_Hook, Param_Cell);
	g_OnGroupEnterGameFwd = new GlobalForward("SF2_OnGroupEnterGame", ET_Hook, Param_Cell);
	g_OnEverythingLoadedFwd = new GlobalForward("SF2_OnEverythingLoaded", ET_Ignore);

	CreateNative("SF2_GetConfig", Native_GetConfig);
	CreateNative("SF2_IsRunning", Native_IsRunning);
	CreateNative("SF2_GetRoundState", Native_GetRoundState);
	CreateNative("SF2_IsRoundInGracePeriod", Native_IsRoundInGracePeriod);
	CreateNative("SF2_GetCurrentDifficulty", Native_GetCurrentDifficulty);
	CreateNative("SF2_GetDifficultyModifier", Native_GetDifficultyModifier);
	CreateNative("SF2_IsInSpecialRound", Native_IsInSpecialRound);

	CreateNative("SF2_GetClientGroup", Native_GetClientGroup);
	CreateNative("SF2_GetClientQueuePoints", Native_GetClientQueuePoints);
	CreateNative("SF2_SetClientQueuePoints", Native_SetClientQueuePoints);

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

	CreateNative("SF2_GetClientSprintPoints", Native_GetClientSprintPoints);
	CreateNative("SF2_SetClientSprintPoints", Native_SetClientSprintPoints);
	CreateNative("SF2_IsClientSprinting", Native_IsClientSprinting);
	CreateNative("SF2_IsClientReallySprinting", Native_IsClientReallySprinting);
	CreateNative("SF2_SetClientSprintState", Native_SetClientSprintState);

	CreateNative("SF2_IsClientTrapped", Native_IsClientTrapped);
	CreateNative("SF2_IsClientInDeathCam", Native_IsClientInDeathCam);

	CreateNative("SF2_ClientSpawnProxy", Native_ClientSpawnProxy);
	CreateNative("SF2_ClientForceProxy", Native_ClientForceProxy);

	CreateNative("SF2_CollectAsPage", Native_CollectAsPage);

	CreateNative("SF2_GetMaxBossCount", Native_GetMaxBosses);
	CreateNative("SF2_EntIndexToBossIndex", Native_EntIndexToBossIndex);
	CreateNative("SF2_BossIndexToEntIndex", Native_BossIndexToEntIndex);
	CreateNative("SF2_BossIndexToEntIndexEx", Native_BossIndexToEntIndexEx);
	CreateNative("SF2_BossIDToBossIndex", Native_BossIDToBossIndex);
	CreateNative("SF2_BossIndexToBossID", Native_BossIndexToBossID);

	CreateNative("SF2_UpdateBossAnimation", Native_UpdateBossAnimation);

	CreateNative("SF2_ForceBossJump", Native_ForceBossJump);

	CreateNative("SF2_AddBoss", Native_AddBoss);
	CreateNative("SF2_RemoveBoss", Native_RemoveBoss);

	CreateNative("SF2_GetBossName", Native_GetBossName);
	CreateNative("SF2_GetBossType", Native_GetBossType);

	CreateNative("SF2_GetBossFlags", Native_GetBossFlags);
	CreateNative("SF2_SetBossFlags", Native_SetBossFlags);

	CreateNative("SF2_SpawnBoss", Native_SpawnBoss);
	CreateNative("SF2_IsBossSpawning", Native_IsBossSpawning);
	CreateNative("SF2_DespawnBoss", Native_DespawnBoss);

	CreateNative("SF2_PerformBossVoice", Native_PerformBossVoice);

	CreateNative("SF2_GetBossModelEntity", Native_GetBossModelEntity);

	CreateNative("SF2_GetBossTarget", Native_GetBossTarget);
	CreateNative("SF2_SetBossTarget", Native_SetBossTarget);

	CreateNative("SF2_GetBossPathFollower", Native_GetBossPathFollower);
	CreateNative("SF2_GetBossMaster", Native_GetBossMaster);
	CreateNative("SF2_GetBossIdleLifetime", Native_GetBossIdleLifetime);
	CreateNative("SF2_GetBossState", Native_GetBossState);
	CreateNative("SF2_SetBossState", Native_SetBossState);

	CreateNative("SF2_GetBossEyePosition", Native_GetBossEyePosition);
	CreateNative("SF2_GetBossEyePositionOffset", Native_GetBossEyePositionOffset);
	CreateNative("SF2_GetBossFOV", Native_GetBossFOV);

	CreateNative("SF2_GetBossTimeUntilAlert", Native_GetBossTimeUntilAlert);
	CreateNative("SF2_GetBossTimeUntilNoPersistence", Native_GetBossTimeUntilNoPersistence);
	CreateNative("SF2_GetBossTimeUntilIdle", Native_GetBossTimeUntilIdle);
	CreateNative("SF2_SetBossTimeUntilAlert", Native_SetBossTimeUntilAlert);
	CreateNative("SF2_SetBossTimeUntilNoPersistence", Native_SetBossTimeUntilNoPersistence);
	CreateNative("SF2_SetBossTimeUntilIdle", Native_SetBossTimeUntilIdle);

	CreateNative("SF2_IsBossStunnable", Native_IsBossStunnable);
	CreateNative("SF2_IsBossStunnableByFlashlight", Native_IsBossStunnableByFlashlight);
	CreateNative("SF2_IsBossCloaked", Native_IsBossCloaked);
	CreateNative("SF2_SetBossStunHealth", Native_SetBossStunHealth);
	CreateNative("SF2_GetBossNextStunTime", Native_GetBossNextStunTime);
	CreateNative("SF2_ForceBossGiveUp", Native_ForceBossGiveUp);
	CreateNative("SF2_GetBossGoalPosition", Native_GetBossGoalPosition);
	CreateNative("SF2_CanBossHearClient", Native_CanBossHearClient);
	CreateNative("SF2_CreateBossSoundHint", Native_CreateBossSoundHint);

	CreateNative("SF2_GetBossProjectileType", Native_GetBossProjectileType);

	CreateNative("SF2_GetBossCurrentAttackIndex", Native_GetBossCurrentAttackIndex);
	CreateNative("SF2_SetBossCurrentAttackIndex", Native_SetBossCurrentAttackIndex);
	CreateNative("SF2_GetBossMaxAttackIndexes", Native_GetBossMaxAttackIndexes);
	CreateNative("SF2_GetBossAttackRunDurationTime", Native_GetBossAttackRunDurationTime);
	CreateNative("SF2_SetBossAttackRunDurationTime", Native_SetBossAttackRunDurationTime);
	CreateNative("SF2_GetBossAttackRunDelayTime", Native_GetBossAttackRunDelayTime);
	CreateNative("SF2_SetBossAttackRunDelayTime", Native_SetBossAttackRunDelayTime);
	CreateNative("SF2_GetBossAttackIndexDamageType", Native_GetBossAttackIndexDamageType);
	CreateNative("SF2_GetBossAttackIndexDamage", Native_GetBossAttackIndexDamage);
	CreateNative("SF2_GetBossAttackIndexSpread", Native_GetBossAttackIndexSpread);
	CreateNative("SF2_GetBossAttackIndexRange", Native_GetBossAttackIndexRange);
	CreateNative("SF2_GetBossAttackIndexType", Native_GetBossAttackIndexType);

	CreateNative("SF2_GetBossTeleportThinkTimer", Native_GetBossTeleportThinkTimer);
	CreateNative("SF2_SetBossTeleportThinkTimer", Native_SetBossTeleportThinkTimer);
	CreateNative("SF2_GetBossTeleportTarget", Native_GetBossTeleportTarget);

	CreateNative("SF2_GetBossThinkTimer", Native_GetBossThinkTimer);
	CreateNative("SF2_SetBossThinkTimer", Native_SetBossThinkTimer);
	CreateNative("SF2_UnhookBossThinkHook", Native_UnhookBossThinkHook);

	CreateNative("SF2_GetVectorSquareMagnitude", Native_GetVectorSquareMagnitude);
	CreateNative("SF2_InitiateBossPackVote", Native_InitiateBossPackVote);
	CreateNative("SF2_GetProjectileFlags", Native_GetProjectileFlags);
	CreateNative("SF2_SetProjectileFlags", Native_SetProjectileFlags);
	CreateNative("SF2_IsSurvivalMap", Native_IsSurvivalMap);
	CreateNative("SF2_IsBoxingMap", Native_IsBoxingMap);
	CreateNative("SF2_IsRaidMap", Native_IsRaidMap);
	CreateNative("SF2_IsProxyMap", Native_IsProxyMap);
	CreateNative("SF2_IsRenevantMap", Native_IsRenevantMap);
	CreateNative("SF2_IsSlaughterRunMap", Native_IsSlaughterRunMap);

	PvP_InitializeAPI();

	SpecialRoundInitializeAPI();

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
			Handle hGameConf = LoadGameConfigFile("tf2items.randomizer");
			if (hGameConf != null)
			{
				StartPrepSDKCall(SDKCall_Player);
				PrepSDKCall_SetFromConf(hGameConf, SDKConf_Virtual, "CTFPlayer::EquipWearable");
				PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer );
				g_SDKEquipWearable = EndPrepSDKCall();
				if (g_SDKEquipWearable == null)
				{
					// Old gamedata
					StartPrepSDKCall(SDKCall_Player);
					PrepSDKCall_SetFromConf(hGameConf, SDKConf_Virtual, "EquipWearable");
					PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
					g_SDKEquipWearable = EndPrepSDKCall();
				}
			}
			delete hGameConf;
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
	if ((g_SDKPassesTriggerFilters = EndPrepSDKCall()) == INVALID_HANDLE)
		SetFailState("Failed to setup CBaseTrigger::PassesTriggerFilters call from gamedata!");

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(gameData, SDKConf_Virtual, "CBaseEntity::GetSmoothedVelocity");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_ByValue);
	if ((g_SDKGetSmoothedVelocity = EndPrepSDKCall()) == null)
	{
		SetFailState("Couldn't find CBaseEntity::GetSmoothedVelocity offset from SF2 gamedata!");
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

public any Native_GetConfig(Handle plugin,int numParams)
{
	return g_Config;
}

public any Native_IsRunning(Handle plugin,int numParams)
{
	return g_Enabled;
}

public any Native_GetRoundState(Handle plugin,int numParams)
{
	return g_RoundState;
}

public any Native_IsRoundInGracePeriod(Handle plugin, int numParams)
{
	return GetRoundState() == SF2RoundState_Grace;
}

public any Native_GetCurrentDifficulty(Handle plugin,int numParams)
{
	return g_DifficultyConVar.IntValue;
}

public any Native_GetDifficultyModifier(Handle plugin,int numParams)
{
	int difficulty = GetNativeCell(1);
	if (difficulty < Difficulty_Easy || difficulty >= Difficulty_Max)
	{
		LogError("Difficulty parameter can only be from %d to %d!", Difficulty_Easy, Difficulty_Max - 1);
		return 1;
	}

	switch (difficulty)
	{
		case Difficulty_Easy:
		{
			return DIFFICULTYMODIFIER_NORMAL;
		}
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

public any Native_IsInSpecialRound(Handle plugin,int numParams)
{
	return SF_SpecialRound(GetNativeCell(1));
}

public any Native_GetClientGroup(Handle plugin,int numParams)
{
	return ClientGetPlayerGroup(GetNativeCell(1));
}

public any Native_GetClientQueuePoints(Handle plugin,int numParams)
{
	return g_PlayerQueuePoints[GetNativeCell(1)];
}

public any Native_SetClientQueuePoints(Handle plugin,int numParams)
{
	g_PlayerQueuePoints[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_IsClientEliminated(Handle plugin,int numParams)
{
	return g_PlayerEliminated[GetNativeCell(1)];
}

public any Native_IsClientInGhostMode(Handle plugin,int numParams)
{
	return IsClientInGhostMode(GetNativeCell(1));
}

public any Native_IsClientProxy(Handle plugin,int numParams)
{
	return g_PlayerProxy[GetNativeCell(1)];
}

public any Native_GetClientBlinkCount(Handle plugin,int numParams)
{
	return ClientGetBlinkCount(GetNativeCell(1));
}

public any Native_IsClientBlinking(Handle plugin,int numParams)
{
	return IsClientBlinking(GetNativeCell(1));
}

public any Native_GetClientBlinkMeter(Handle plugin,int numParams)
{
	return ClientGetBlinkMeter(GetNativeCell(1));
}

public any Native_SetClientBlinkMeter(Handle plugin,int numParams)
{
	ClientSetBlinkMeter(GetNativeCell(1), view_as<float>(GetNativeCell(2)));
	return 0;
}

public any Native_GetClientProxyMaster(Handle plugin,int numParams)
{
	return NPCGetFromUniqueID(g_PlayerProxyMaster[GetNativeCell(1)]);
}

public any Native_GetClientProxyControlAmount(Handle plugin,int numParams)
{
	return g_PlayerProxyControl[GetNativeCell(1)];
}

public any Native_GetClientProxyControlRate(Handle plugin,int numParams)
{
	return g_PlayerProxyControlRate[GetNativeCell(1)];
}

public any Native_SetClientProxyMaster(Handle plugin,int numParams)
{
	g_PlayerProxyMaster[GetNativeCell(1)] = NPCGetUniqueID(GetNativeCell(2));
	return 0;
}

public any Native_SetClientProxyControlAmount(Handle plugin,int numParams)
{
	g_PlayerProxyControl[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_SetClientProxyControlRate(Handle plugin,int numParams)
{
	g_PlayerProxyControlRate[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_IsClientLookingAtBoss(Handle plugin,int numParams)
{
	return g_PlayerSeesSlender[GetNativeCell(1)][GetNativeCell(2)];
}

public any Native_DidClientEscape(Handle plugin,int numParams)
{
	return DidClientEscape(GetNativeCell(1));
}

public any Native_ForceClientEscape(Handle plugin,int numParams)
{
	int client = GetNativeCell(1);

	ClientEscape(client);
	TeleportClientToEscapePoint(client);
	return 0;
}

public any Native_GetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	return ClientGetFlashlightBatteryLife(GetNativeCell(1));
}

public any Native_SetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	ClientSetFlashlightBatteryLife(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_IsClientUsingFlashlight(Handle plugin, int numParams)
{
	return IsClientUsingFlashlight(GetNativeCell(1));
}

public any Native_GetClientSprintPoints(Handle plugin, int numParams)
{
	return ClientGetSprintPoints(GetNativeCell(1));
}

public any Native_SetClientSprintPoints(Handle plugin, int numParams)
{
	g_PlayerSprintPoints[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_IsClientSprinting(Handle plugin, int numParams)
{
	return IsClientSprinting(GetNativeCell(1));
}

public any Native_IsClientReallySprinting(Handle plugin, int numParams)
{
	return IsClientReallySprinting(GetNativeCell(1));
}

public any Native_SetClientSprintState(Handle plugin, int numParams)
{
	ClientHandleSprint(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_IsClientTrapped(Handle plugin, int numParams)
{
	return g_PlayerTrapped[GetNativeCell(1)];
}

public any Native_IsClientInDeathCam(Handle plugin, int numParams)
{
	return IsClientInDeathCam(GetNativeCell(1));
}

public any Native_ClientSpawnProxy(Handle plugin, int numParams)
{
	float teleportPos[3];
	GetNativeArray(3, teleportPos, 3);
	int spawnPoint = GetNativeCell(4);
	return SpawnProxy(GetNativeCell(1), GetNativeCell(2), teleportPos, spawnPoint);
}

public any Native_ClientForceProxy(Handle plugin, int numParams)
{
	float teleportPos[3];
	GetNativeArray(3, teleportPos, 3);
	ClientStartProxyForce(GetNativeCell(1), GetNativeCell(2), teleportPos, GetNativeCell(4));
	return 0;
}

public any Native_CollectAsPage(Handle plugin,int numParams)
{
	CollectPage(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_GetMaxBosses(Handle plugin,int numParams)
{
	return MAX_BOSSES;
}

public any Native_EntIndexToBossIndex(Handle plugin,int numParams)
{
	return NPCGetFromEntIndex(GetNativeCell(1));
}

public any Native_BossIndexToEntIndex(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_SlenderEnt[GetNativeCell(1)]);
}

public any Native_BossIndexToEntIndexEx(Handle plugin,int numParams)
{
	return NPCGetEntIndex(GetNativeCell(1));
}

public any Native_BossIDToBossIndex(Handle plugin,int numParams)
{
	return NPCGetFromUniqueID(GetNativeCell(1));
}

public any Native_BossIndexToBossID(Handle plugin,int numParams)
{
	return NPCGetUniqueID(GetNativeCell(1));
}

public any Native_UpdateBossAnimation(Handle plugin,int numParams)
{
	NPCChaserUpdateBossAnimation(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3), GetNativeCell(4));
	return 0;
}

public any Native_ForceBossJump(Handle plugin,int numParams)
{
	float startPos[3], endPos[3];
	GetNativeArray(2, startPos, 3);
	GetNativeArray(3, endPos, 3);
	CBaseNPC_Jump(GetNativeCell(1), startPos, endPos);
	return 0;
}

public any Native_AddBoss(Handle plugin, int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, sizeof(profile));

	int flags = GetNativeCell(2);
	bool spawnCompanions = view_as<bool>(GetNativeCell(3));
	bool playSpawnSound = view_as<bool>(GetNativeCell(4));

	return AddProfile(profile, flags, _, spawnCompanions, playSpawnSound);
}

public any Native_RemoveBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	RemoveProfile(boss.Index);
	return 0;
}

public any Native_DespawnBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	RemoveSlender(boss.Index);
	return 0;
}

public any Native_PerformBossVoice(Handle plugin, int numParams)
{
	SlenderPerformVoice(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3));
	return 0;
}

public any Native_GetBossName(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(GetNativeCell(1), profile, sizeof(profile));

	SetNativeString(2, profile, GetNativeCell(3));
	return 0;
}

public any Native_GetBossType(Handle plugin, int numParams)
{
	return NPCGetType(GetNativeCell(1));
}

public any Native_GetBossFlags(Handle plugin, int numParams)
{
	return NPCGetFlags(GetNativeCell(1));
}

public any Native_SetBossFlags(Handle plugin, int numParams)
{
	NPCSetFlags(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_SpawnBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	float position[3];
	GetNativeArray(2, position, 3);

	SpawnSlender(boss, position);
	return 0;
}

public any Native_IsBossSpawning(Handle plugin, int numParams)
{
	return g_SlenderSpawning[GetNativeCell(1)];
}

public any Native_GetBossModelEntity(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_SlenderEnt[GetNativeCell(1)]);
}

public any Native_GetBossTarget(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_SlenderTarget[GetNativeCell(1)]);
}

public any Native_SetBossTarget(Handle plugin, int numParams)
{
	g_SlenderTarget[GetNativeCell(1)] = EntIndexToEntRef(GetNativeCell(2));
	return 0;
}

public any Native_GetBossPathFollower(Handle plugin, int numParams)
{
	return g_BossPathFollower[GetNativeCell(1)];
}

public any Native_GetBossMaster(Handle plugin,int numParams)
{
	return g_SlenderCopyMaster[GetNativeCell(1)];
}

public any Native_GetBossIdleLifetime(Handle plugin,int numParams)
{
	return NPCGetIdleLifetime(GetNativeCell(1), GetNativeCell(2));
}

public any Native_GetBossState(Handle plugin,int numParams)
{
	return g_SlenderState[GetNativeCell(1)];
}

public any Native_SetBossState(Handle plugin,int numParams)
{
	g_SlenderState[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_GetBossEyePosition(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid() || !IsValidEntity(boss.EntIndex))
	{
		return 0;
	}

	float eyePos[3];
	boss.GetEyePosition(eyePos);

	SetNativeArray(2, eyePos, 3);
	return 0;
}

public any Native_GetBossEyePositionOffset(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
	{
		return 0;
	}

	float eyePos[3];
	boss.GetEyePositionOffset(eyePos);

	SetNativeArray(2, eyePos, 3);
	return 0;
}

public any Native_GetBossFOV(Handle plugin, int numParams)
{
	return NPCGetFOV(GetNativeCell(1));
}

public any Native_GetBossTimeUntilNoPersistence(Handle plugin, int numParams)
{
	return g_SlenderTimeUntilNoPersistence[GetNativeCell(1)];
}

public any Native_SetBossTimeUntilNoPersistence(Handle plugin, int numParams)
{
	g_SlenderTimeUntilNoPersistence[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_GetBossTimeUntilIdle(Handle plugin, int numParams)
{
	return g_SlenderTimeUntilIdle[GetNativeCell(1)];
}

public any Native_SetBossTimeUntilIdle(Handle plugin, int numParams)
{
	g_SlenderTimeUntilIdle[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_GetBossTimeUntilAlert(Handle plugin, int numParams)
{
	return g_SlenderTimeUntilAlert[GetNativeCell(1)];
}

public any Native_SetBossTimeUntilAlert(Handle plugin, int numParams)
{
	g_SlenderTimeUntilAlert[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_IsBossStunnable(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).StunEnabled;
}

public any Native_IsBossStunnableByFlashlight(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).StunByFlashlightEnabled;
}

public any Native_IsBossCloaked(Handle plugin, int numParams)
{
	return g_NpcHasCloaked[GetNativeCell(1)];
}

public any Native_GetBossStunHealth(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).StunHealth;
}

public any Native_SetBossStunHealth(Handle plugin, int numParams)
{
	SF2NPC_Chaser(GetNativeCell(1)).StunHealth = GetNativeCell(2);
	return 0;
}

public any Native_GetBossNextStunTime(Handle plugin, int numParams)
{
	return g_SlenderNextStunTime[GetNativeCell(1)];
}

public any Native_SetBossNextStunTime(Handle plugin, int numParams)
{
	g_SlenderNextStunTime[GetNativeCell(1)] = GetNativeCell(2);
	return 0;
}

public any Native_ForceBossGiveUp(Handle plugin, int numParams)
{
	g_SlenderGiveUp[GetNativeCell(1)] = false;
	return 0;
}

public any Native_GetBossGoalPosition(Handle plugin, int numParams)
{
	SetNativeArray(2, g_SlenderGoalPos[GetNativeCell(1)], 3);
	return 0;
}

public any Native_CanBossHearClient(Handle plugin, int numParams)
{
	return SlenderCanHearPlayer(GetNativeCell(1), GetNativeCell(2), view_as<SoundType>(GetNativeCell(3)));
}

public any Native_CreateBossSoundHint(Handle plugin, int numParams)
{
	SF2NPC_Chaser boss = SF2NPC_Chaser(GetNativeCell(1));
	if (!boss.IsValid() || boss.Type != SF2BossType_Chaser || !IsValidEntity(boss.EntIndex))
	{
		return 0;
	}

	SoundType soundType = view_as<SoundType>(GetNativeCell(2));

	float position[3];
	GetNativeArray(3, position, 3);

	int difficulty = GetNativeCell(4);

	switch (soundType)
	{
		case SoundType_Footstep:
		{
			CopyVector(position, g_SlenderTargetSoundTempPos[boss.Index]);
			g_SlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDFOOTSTEP);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_SlenderAutoChaseCooldown[boss.Index] <= GetGameTime())
			{
				g_SlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddFootstep(boss.Index, difficulty);
				g_SlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Voice:
		{
			CopyVector(position, g_SlenderTargetSoundTempPos[boss.Index]);
			g_SlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDVOICE);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_SlenderAutoChaseCooldown[boss.Index] <= GetGameTime())
			{
				g_SlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddVoice(boss.Index, difficulty);
				g_SlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Weapon:
		{
			CopyVector(position, g_SlenderTargetSoundTempPos[boss.Index]);
			g_SlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDWEAPON);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_SlenderAutoChaseCooldown[boss.Index] <= GetGameTime())
			{
				g_SlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddWeapon(boss.Index, difficulty);
				g_SlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Flashlight:
		{
			CopyVector(position, g_SlenderTargetSoundTempPos[boss.Index]);
			g_SlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDFLASHLIGHT);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_SlenderAutoChaseCooldown[boss.Index] <= GetGameTime())
			{
				g_SlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddWeapon(boss.Index, difficulty);
				g_SlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
	}
	return 0;
}

public any Native_IsBossProfileValid(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	return IsProfileValid(profile);
}

public any Native_GetBossProfileNum(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileNum(profile, keyValue, GetNativeCell(3));
}

public any Native_GetBossProfileFloat(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileFloat(profile, keyValue, GetNativeCell(3));
}

public any Native_GetBossProfileString(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int resultLen = GetNativeCell(4);
	char[] result = new char[resultLen];

	char defaultValue[512];
	GetNativeString(5, defaultValue, sizeof(defaultValue));

	bool success = GetProfileString(profile, keyValue, result, resultLen, defaultValue);

	SetNativeString(3, result, resultLen);
	return success;
}

public any Native_GetBossProfileVector(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	float result[3];
	float defaultValue[3];
	GetNativeArray(4, defaultValue, 3);

	bool success = GetProfileVector(profile, keyValue, result, defaultValue);

	SetNativeArray(3, result, 3);
	return success;
}

public any Native_GetBossProfileDifficultyNumValues(Handle plugin,int numParams)
{
	char keyValue[PLATFORM_MAX_PATH];
	GetNativeString(2, keyValue, sizeof(keyValue));
	int result[Difficulty_Max];
	int defaultValue[Difficulty_Max];
	GetNativeArray(3, result, Difficulty_Max);
	GetNativeArray(4, defaultValue, Difficulty_Max);
	GetProfileDifficultyNumValues(GetNativeCell(1), keyValue, result, defaultValue);
	return 0;
}

public any Native_GetBossProfileDifficultyBoolValues(Handle plugin,int numParams)
{
	char keyValue[PLATFORM_MAX_PATH];
	GetNativeString(2, keyValue, sizeof(keyValue));
	bool result[Difficulty_Max];
	bool defaultValue[Difficulty_Max];
	GetNativeArray(3, result, Difficulty_Max);
	GetNativeArray(4, defaultValue, Difficulty_Max);
	GetProfileDifficultyBoolValues(GetNativeCell(1), keyValue, result, defaultValue);
	return 0;
}

public any Native_GetBossProfileDifficultyFloatValues(Handle plugin,int numParams)
{
	char keyValue[PLATFORM_MAX_PATH];
	GetNativeString(2, keyValue, sizeof(keyValue));
	float result[Difficulty_Max];
	float defaultValue[Difficulty_Max];
	GetNativeArray(3, result, Difficulty_Max);
	GetNativeArray(4, defaultValue, Difficulty_Max);
	GetProfileDifficultyFloatValues(GetNativeCell(1), keyValue, result, defaultValue);
	return 0;
}

public any Native_GetBossAttackProfileNum(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileAttackNum(profile, keyValue, GetNativeCell(3), GetNativeCell(4));
}

public any Native_GetBossAttackProfileFloat(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	return GetProfileAttackFloat(profile, keyValue, GetNativeCell(3), GetNativeCell(4));
}

public any Native_GetBossAttackProfileString(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int resultLen = GetNativeCell(4);
	char[] result = new char[resultLen];

	char defaultValue[512];
	GetNativeString(5, defaultValue, sizeof(defaultValue));

	bool success = GetProfileAttackString(profile, keyValue, result, resultLen, defaultValue, GetNativeCell(6));

	SetNativeString(3, result, resultLen);
	return success;
}

public any Native_GetBossAttackProfileVector(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	float result[3];
	float defaultValue[3];
	GetNativeArray(4, defaultValue, 3);

	bool success = GetProfileAttackVector(profile, keyValue, result, defaultValue, GetNativeCell(5));

	SetNativeArray(3, result, 3);
	return success;
}

public any Native_GetRandomStringFromBossProfile(Handle plugin,int numParams)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, profile, SF2_MAX_PROFILE_NAME_LENGTH);

	char keyValue[256];
	GetNativeString(2, keyValue, sizeof(keyValue));

	int bufferLen = GetNativeCell(4);
	char[] buffer = new char[bufferLen];

	int iIndex = GetNativeCell(5);

	bool success = GetRandomStringFromProfile(profile, keyValue, buffer, bufferLen, iIndex);
	SetNativeString(3, buffer, bufferLen);
	return success;
}

public any Native_GetBossAttributeName(Handle plugin,int numParams)
{
	int attributeIndex = GetNativeCell(2);

	bool success = NPCHasAttribute(GetNativeCell(1), attributeIndex);
	return success;
}

public any Native_GetBossAttributeValue(Handle plugin,int numParams)
{
	int attributeIndex = GetNativeCell(2);

	if (!NPCHasAttribute(GetNativeCell(1), attributeIndex))
	{
		return 0.0;
	}
	return NPCGetAttributeValue(GetNativeCell(1), attributeIndex);
}

public any Native_GetBossProjectileType(Handle plugin,int numParams)
{
	return NPCChaserGetProjectileType(GetNativeCell(1));
}

public any Native_SetBossCurrentAttackIndex(Handle plugin,int numParams)
{
	NPCSetCurrentAttackIndex(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_GetBossCurrentAttackIndex(Handle plugin,int numParams)
{
	return NPCGetCurrentAttackIndex(GetNativeCell(1));
}

public any Native_GetBossMaxAttackIndexes(Handle plugin,int numParams)
{
	return NPCChaserGetAttackCount(GetNativeCell(1));
}

public any Native_GetBossAttackRunDurationTime(Handle plugin,int numParams)
{
	return g_NpcBaseAttackRunDurationTime[GetNativeCell(1)][GetNativeCell(2)];
}

public any Native_SetBossAttackRunDurationTime(Handle plugin,int numParams)
{
	g_NpcBaseAttackRunDurationTime[GetNativeCell(1)][GetNativeCell(2)] = GetNativeCell(3);
	return 0;
}

public any Native_GetBossAttackRunDelayTime(Handle plugin,int numParams)
{
	return g_NpcBaseAttackRunDelayTime[GetNativeCell(1)][GetNativeCell(2)];
}

public any Native_SetBossAttackRunDelayTime(Handle plugin,int numParams)
{
	g_NpcBaseAttackRunDelayTime[GetNativeCell(1)][GetNativeCell(2)] = GetNativeCell(3);
	return 0;
}

public any Native_GetBossAttackIndexDamageType(Handle plugin,int numParams)
{
	return NPCChaserGetAttackDamageType(GetNativeCell(1), GetNativeCell(2));
}

public any Native_GetBossAttackIndexDamage(Handle plugin,int numParams)
{
	return NPCChaserGetAttackDamage(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3));
}

public any Native_GetBossAttackIndexSpread(Handle plugin,int numParams)
{
	return NPCChaserGetAttackSpread(GetNativeCell(1), GetNativeCell(2));
}

public any Native_GetBossAttackIndexRange(Handle plugin,int numParams)
{
	return NPCChaserGetAttackRange(GetNativeCell(1), GetNativeCell(2));
}

public any Native_GetBossAttackIndexType(Handle plugin,int numParams)
{
	return NPCChaserGetAttackType(GetNativeCell(1), GetNativeCell(2));
}

public any Native_GetBossTeleportThinkTimer(Handle plugin,int numParams)
{
	return g_SlenderThink[GetNativeCell(1)];
}

public any Native_SetBossTeleportThinkTimer(Handle plugin,int numParams)
{
	int bossIndex = GetNativeCell(1);
	g_SlenderThink[bossIndex] = GetNativeCell(2);
	return 0;
}

public any Native_GetBossTeleportTarget(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_SlenderTeleportTarget[GetNativeCell(1)]);
}

public any Native_GetBossThinkTimer(Handle plugin,int numParams)
{
	return g_SlenderEntityThink[GetNativeCell(1)];
}

public any Native_SetBossThinkTimer(Handle plugin,int numParams)
{
	int bossIndex = GetNativeCell(1);
	g_SlenderEntityThink[bossIndex] = GetNativeCell(2);
	return 0;
}

public any Native_UnhookBossThinkHook(Handle plugin,int numParams)
{
	int bossIndex = GetNativeCell(1);
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return 0;
	}
	switch (NPCGetType(bossIndex))
	{
		case SF2BossType_Statue:
		{
			SDKUnhook(slender, SDKHook_Think, SlenderStatueBossProcessMovement);
		}
		case SF2BossType_Chaser:
		{
			SDKUnhook(slender, SDKHook_Think, SlenderChaseBossProcessMovement);
		}
	}
	return 0;
}

public any Native_GetVectorSquareMagnitude(Handle plugin, int numParams)
{
	float vec1[3], vec2[3];
	GetNativeArray(1, vec1, 3);
	GetNativeArray(2, vec2, 3);
	return GetVectorSquareMagnitude(vec1, vec2);
}

public any Native_InitiateBossPackVote(Handle plugin, int numParams)
{
	InitiateBossPackVote(GetNativeCell(1));
	return 0;
}

public any Native_GetProjectileFlags(Handle plugin, int numParams)
{
	return ProjectileGetFlags(GetNativeCell(1));
}

public any Native_SetProjectileFlags(Handle plugin, int numParams)
{
	ProjectileSetFlags(GetNativeCell(1), GetNativeCell(2));
	return 0;
}

public any Native_IsSurvivalMap(Handle plugin, int numParams)
{
	return SF_IsSurvivalMap();
}

public any Native_IsBoxingMap(Handle plugin, int numParams)
{
	return SF_IsBoxingMap();
}

public any Native_IsRaidMap(Handle plugin, int numParams)
{
	return SF_IsRaidMap();
}

public any Native_IsProxyMap(Handle plugin, int numParams)
{
	return SF_IsProxyMap();
}

public any Native_IsSlaughterRunMap(Handle plugin, int numParams)
{
	return SF_IsSlaughterRunMap();
}