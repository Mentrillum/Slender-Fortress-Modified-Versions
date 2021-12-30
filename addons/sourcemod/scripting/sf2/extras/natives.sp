#if defined _sf2_natives_included
 #endinput
#endif
#define _sf2_natives_included

//	==========================================================
//	GENERAL PLUGIN HOOK FUNCTIONS
//	==========================================================

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error,int err_max)
{
	RegPluginLibrary("sf2");
	
	fOnBossAdded = CreateGlobalForward("SF2_OnBossAdded", ET_Ignore, Param_Cell);
	fOnBossSpawn = CreateGlobalForward("SF2_OnBossSpawn", ET_Ignore, Param_Cell);
	fOnBossDespawn = CreateGlobalForward("SF2_OnBossDespawn", ET_Ignore, Param_Cell);
	fOnBossChangeState = CreateGlobalForward("SF2_OnBossChangeState", ET_Ignore, Param_Cell, Param_Cell, Param_Cell);
	fOnBossAnimationUpdate = CreateGlobalForward("SF2_OnBossAnimationUpdate", ET_Hook, Param_Cell);
	fOnBossGetSpeed = CreateGlobalForward("SF2_OnBossGetSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	fOnBossGetWalkSpeed = CreateGlobalForward("SF2_OnBossGetWalkSpeed", ET_Hook, Param_Cell, Param_FloatByRef);
	fOnBossHearEntity = CreateGlobalForward("SF2_OnBossHearEntity", ET_Hook, Param_Cell, Param_Cell);
	fOnBossSeeEntity = CreateGlobalForward("SF2_OnBossSeeEntity", ET_Hook, Param_Cell, Param_Cell);
	fOnBossRemoved = CreateGlobalForward("SF2_OnBossRemoved", ET_Ignore, Param_Cell);
	fOnBossStunned = CreateGlobalForward("SF2_OnBossStunned", ET_Ignore, Param_Cell, Param_Cell);
	fOnBossCloaked = CreateGlobalForward("SF2_OnBossCloaked", ET_Ignore, Param_Cell);
	fOnBossDecloaked = CreateGlobalForward("SF2_OnBossDecloaked", ET_Ignore, Param_Cell);
	fOnPagesSpawned = CreateGlobalForward("SF2_OnPagesSpawned", ET_Ignore);
	fOnRoundStateChange = CreateGlobalForward("SF2_OnRoundStateChange", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientCollectPage = CreateGlobalForward("SF2_OnClientCollectPage", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientBlink = CreateGlobalForward("SF2_OnClientBlink", ET_Ignore, Param_Cell);
	fOnClientScare = CreateGlobalForward("SF2_OnClientScare", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientCaughtByBoss = CreateGlobalForward("SF2_OnClientCaughtByBoss", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientGiveQueuePoints = CreateGlobalForward("SF2_OnClientGiveQueuePoints", ET_Hook, Param_Cell, Param_CellByRef);
	fOnClientActivateFlashlight = CreateGlobalForward("SF2_OnClientActivateFlashlight", ET_Ignore, Param_Cell);
	fOnClientDeactivateFlashlight = CreateGlobalForward("SF2_OnClientDeactivateFlashlight", ET_Ignore, Param_Cell);
	fOnClientBreakFlashlight = CreateGlobalForward("SF2_OnClientBreakFlashlight", ET_Ignore, Param_Cell);
	fOnClientStartSprinting = CreateGlobalForward("SF2_OnClientStartSprinting", ET_Ignore, Param_Cell);
	fOnClientStopSprinting = CreateGlobalForward("SF2_OnClientStopSprinting", ET_Ignore, Param_Cell);
	fOnClientEscape = CreateGlobalForward("SF2_OnClientEscape", ET_Ignore, Param_Cell);
	fOnClientLooksAtBoss = CreateGlobalForward("SF2_OnClientLooksAtBoss", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientLooksAwayFromBoss = CreateGlobalForward("SF2_OnClientLooksAwayFromBoss", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientStartDeathCam = CreateGlobalForward("SF2_OnClientStartDeathCam", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientEndDeathCam = CreateGlobalForward("SF2_OnClientEndDeathCam", ET_Ignore, Param_Cell, Param_Cell);
	fOnClientGetDefaultWalkSpeed = CreateGlobalForward("SF2_OnClientGetDefaultWalkSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	fOnClientGetDefaultSprintSpeed = CreateGlobalForward("SF2_OnClientGetDefaultSprintSpeed", ET_Hook, Param_Cell, Param_CellByRef);
	fOnClientTakeDamage = CreateGlobalForward("SF2_OnClientTakeDamage", ET_Hook, Param_Cell, Param_Cell, Param_FloatByRef);
	fOnClientSpawnedAsProxy = CreateGlobalForward("SF2_OnClientSpawnedAsProxy", ET_Ignore, Param_Cell);
	fOnClientDamagedByBoss = CreateGlobalForward("SF2_OnClientDamagedByBoss", ET_Ignore, Param_Cell, Param_Cell, Param_Cell, Param_Float, Param_Cell);
	fOnGroupGiveQueuePoints = CreateGlobalForward("SF2_OnGroupGiveQueuePoints", ET_Hook, Param_Cell, Param_CellByRef);
	fOnRenevantTriggerWave = CreateGlobalForward("SF2_OnRenevantWaveTrigger", ET_Ignore, Param_Cell);
	fOnBossPackVoteStart = CreateGlobalForward("SF2_OnBossPackVoteStart", ET_Ignore);
	fOnDifficultyChange = CreateGlobalForward("SF2_OnDifficultyChange", ET_Ignore, Param_Cell);
	
	CreateNative("SF2_IsRunning", Native_IsRunning);
	CreateNative("SF2_GetRoundState", Native_GetRoundState);
	CreateNative("SF2_IsRoundInGracePeriod", Native_IsRoundInGracePeriod);
	CreateNative("SF2_GetCurrentDifficulty", Native_GetCurrentDifficulty);
	CreateNative("SF2_GetDifficultyModifier", Native_GetDifficultyModifier);
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
	CreateNative("SF2_IsClientTrapped", Native_IsClientTrapped);
	CreateNative("SF2_ClientSpawnProxy", Native_ClientSpawnProxy);
	CreateNative("SF2_ClientForceProxy", Native_ClientForceProxy);
	CreateNative("SF2_CollectAsPage", Native_CollectAsPage);
	CreateNative("SF2_GetMaxBossCount", Native_GetMaxBosses);
	CreateNative("SF2_EntIndexToBossIndex", Native_EntIndexToBossIndex);
	CreateNative("SF2_BossIndexToEntIndex", Native_BossIndexToEntIndex);
	CreateNative("SF2_BossIndexToEntIndexEx", Native_BossIndexToEntIndexEx);
	CreateNative("SF2_BossIDToBossIndex", Native_BossIDToBossIndex);
	CreateNative("SF2_BossIndexToBossID", Native_BossIndexToBossID);
	CreateNative("SF2_AddBoss", Native_AddBoss);
	CreateNative("SF2_RemoveBoss", Native_RemoveBoss);
	CreateNative("SF2_GetBossName", Native_GetBossName);
	CreateNative("SF2_GetBossType", Native_GetBossType);
	CreateNative("SF2_GetBossFlags", Native_GetBossFlags);
	CreateNative("SF2_SetBossFlags", Native_SetBossFlags);
	CreateNative("SF2_SpawnBoss", Native_SpawnBoss);
	CreateNative("SF2_DespawnBoss", Native_DespawnBoss);
	CreateNative("SF2_GetBossModelEntity", Native_GetBossModelEntity);
	CreateNative("SF2_GetBossTarget", Native_GetBossTarget);
	CreateNative("SF2_SetBossTarget", Native_SetBossTarget);
	CreateNative("SF2_GetBossMaster", Native_GetBossMaster);
	CreateNative("SF2_GetBossState", Native_GetBossState);
	CreateNative("SF2_GetBossEyePosition", Native_GetBossEyePosition);
	CreateNative("SF2_GetBossEyePositionOffset", Native_GetBossEyePositionOffset);
	CreateNative("SF2_GetBossFOV", Native_GetBossFOV);
	CreateNative("SF2_GetBossTimeUntilNoPersistence", Native_GetBossTimeUntilNoPersistence);
	CreateNative("SF2_SetBossTimeUntilNoPersistence", Native_SetBossTimeUntilNoPersistence);
	CreateNative("SF2_GetBossTimeUntilIdle", Native_GetBossTimeUntilIdle);
	CreateNative("SF2_SetBossTimeUntilIdle", Native_SetBossTimeUntilIdle);
	CreateNative("SF2_GetBossTimeUntilAlert", Native_GetBossTimeUntilAlert);
	CreateNative("SF2_SetBossTimeUntilAlert", Native_SetBossTimeUntilAlert);
	CreateNative("SF2_IsBossStunnable", Native_IsBossStunnable);
	CreateNative("SF2_IsBossStunnableByFlashlight", Native_IsBossStunnableByFlashlight);
	CreateNative("SF2_IsBossCloaked", Native_IsBossCloaked);
	CreateNative("SF2_GetBossStunHealth", Native_GetBossStunHealth);
	CreateNative("SF2_SetBossStunHealth", Native_SetBossStunHealth);
	CreateNative("SF2_GetBossNextStunTime", Native_GetBossNextStunTime);
	CreateNative("SF2_SetBossNextStunTime", Native_SetBossNextStunTime);
	CreateNative("SF2_ForceBossGiveUp", Native_ForceBossGiveUp);
	CreateNative("SF2_GetBossGoalPosition", Native_GetBossGoalPosition);
	CreateNative("SF2_CanBossHearClient", Native_CanBossHearClient);
	CreateNative("SF2_CreateBossSoundHint", Native_CreateBossSoundHint);
	CreateNative("SF2_IsBossProfileValid", Native_IsBossProfileValid);
	CreateNative("SF2_GetBossProfileNum", Native_GetBossProfileNum);
	CreateNative("SF2_GetBossProfileFloat", Native_GetBossProfileFloat);
	CreateNative("SF2_GetBossProfileString", Native_GetBossProfileString);
	CreateNative("SF2_GetBossProfileVector", Native_GetBossProfileVector);
	CreateNative("SF2_GetBossAttackProfileNum", Native_GetBossAttackProfileNum);
	CreateNative("SF2_GetBossAttackProfileFloat", Native_GetBossAttackProfileFloat);
	CreateNative("SF2_GetBossAttackProfileString", Native_GetBossAttackProfileString);
	CreateNative("SF2_GetBossAttackProfileVector", Native_GetBossAttackProfileVector);
	CreateNative("SF2_GetRandomStringFromBossProfile", Native_GetRandomStringFromBossProfile);
	CreateNative("SF2_GetBossAttributeName", Native_GetBossAttributeName);
	CreateNative("SF2_GetBossAttributeValue", Native_GetBossAttributeValue);
	CreateNative("SF2_GetBossProjectileType", Native_GetBossProjectileType);
	CreateNative("SF2_GetBossCurrentAttackIndex", Native_GetBossCurrentAttackIndex);
	CreateNative("SF2_GetBossAttackIndexDamageType", Native_GetBossAttackIndexDamageType);
	CreateNative("SF2_GetBossAttackIndexDamage", Native_GetBossAttackIndexDamage);
	CreateNative("SF2_GetBossAttackIndexType", Native_GetBossAttackIndexType);
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
	GameData hConfig = LoadGameConfigFile("sdkhooks.games");
	if (hConfig == null) SetFailState("Couldn't find SDKHooks gamedata!");
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "GetMaxHealth");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_hSDKGetMaxHealth = EndPrepSDKCall()) == null)
	{
		SetFailState("Failed to retrieve GetMaxHealth offset from SDKHooks gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "StartTouch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKStartTouch = EndPrepSDKCall();
	if (g_hSDKStartTouch == null)
	{
		SetFailState("Failed to retrieve StartTouch offset from SDKHooks gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "EndTouch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKEndTouch = EndPrepSDKCall();
	if (g_hSDKEndTouch == null)
	{
		SetFailState("Failed to retrieve EndTouch offset from SDKHooks gamedata!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "Weapon_Switch");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_hSDKWeaponSwitch = EndPrepSDKCall();
	if (g_hSDKWeaponSwitch == null)
	{
		SetFailState("Failed to retrieve Weapon_Switch offset from SDKHooks gamedata!");
	}

	
	delete hConfig;
	
	// Check our own gamedata.
	hConfig = LoadGameConfigFile("sf2");
	if (hConfig == null) SetFailState("Could not find SF2 gamedata!");
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf( hConfig, SDKConf_Virtual, "CTFPlayer::EquipWearable" );
	PrepSDKCall_AddParameter( SDKType_CBaseEntity, SDKPass_Pointer );
	g_hSDKEquipWearable = EndPrepSDKCall();
	if( g_hSDKEquipWearable == null )//In case the offset is missing, look if the server has the tf2 randomizer's gamedata.
	{
		char strFilePath[PLATFORM_MAX_PATH];
		BuildPath( Path_SM, strFilePath, sizeof(strFilePath), "gamedata/tf2items.randomizer.txt" );
		if( FileExists( strFilePath ) )
		{
			Handle hGameConf = LoadGameConfigFile( "tf2items.randomizer" );
			if( hGameConf != null )
			{
				StartPrepSDKCall(SDKCall_Player);
				PrepSDKCall_SetFromConf( hGameConf, SDKConf_Virtual, "CTFPlayer::EquipWearable" );
				PrepSDKCall_AddParameter( SDKType_CBaseEntity, SDKPass_Pointer );
				g_hSDKEquipWearable = EndPrepSDKCall();
				if( g_hSDKEquipWearable == null )
				{
					// Old gamedata
					StartPrepSDKCall(SDKCall_Player);
					PrepSDKCall_SetFromConf( hGameConf, SDKConf_Virtual, "EquipWearable" );
					PrepSDKCall_AddParameter( SDKType_CBaseEntity, SDKPass_Pointer );
					g_hSDKEquipWearable = EndPrepSDKCall();
				}
			}
			delete hGameConf;
		}
	}
	if( g_hSDKEquipWearable == null )
	{
		SetFailState("Failed to retrieve CTFPlayer::EquipWearable offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseCombatCharacter::GetLastKnownArea");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetLastKnownArea = EndPrepSDKCall();
	if(g_hSDKGetLastKnownArea == null)
	{
		PrintToServer("Failed to retrieve CBaseCombatCharacter::GetLastKnownArea offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseCombatCharacter::UpdateLastKnownArea");
	g_hSDKUpdateLastKnownArea = EndPrepSDKCall();
	if(g_hSDKUpdateLastKnownArea == null)
	{
		PrintToServer("Failed to retrieve CBaseCombatCharacter::UpdateLastKnownArea offset from SF2 gamedata!");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Signature, "CTFPlayer::PlaySpecificSequence");
	PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
	g_hSDKPlaySpecificSequence = EndPrepSDKCall();
	if(g_hSDKPlaySpecificSequence == null)
	{
		PrintToServer("Failed to retrieve CTFPlayer::PlaySpecificSequence signature from SF2 gamedata!");
		//Don't have to call SetFailState, since this function is used in a minor part of the code.
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Signature, "CBaseTrigger::PointIsWithin");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_Plain);
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
	g_hSDKPointIsWithin = EndPrepSDKCall();
	if(g_hSDKPointIsWithin == null)
	{
		PrintToServer("Failed to retrieve CBaseTrigger::PointIsWithin signature from SF2 gamedata!");
		//Don't have to call SetFailState, since this function is used in a minor part of the code.
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseTrigger::PassesTriggerFilters");
	PrepSDKCall_AddParameter(SDKType_CBaseEntity, SDKPass_Pointer);
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
	if ((g_hSDKPassesTriggerFilters = EndPrepSDKCall()) == INVALID_HANDLE)
		SetFailState("Failed to setup CBaseTrigger::PassesTriggerFilters call from gamedata!");
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseEntity::GetSmoothedVelocity");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_ByValue);
	if ((g_hSDKGetSmoothedVelocity = EndPrepSDKCall()) == null)
	{
		SetFailState("Couldn't find CBaseEntity::GetSmoothedVelocity offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseEntity::GetVectors");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, _, VENCODE_FLAG_COPYBACK);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, _, VENCODE_FLAG_COPYBACK);
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, _, VENCODE_FLAG_COPYBACK);
	g_hSDKGetVectors = EndPrepSDKCall();
	if (g_hSDKGetVectors == null)
	{
		PrintToServer("Failed to retrieve CBaseEntity::GetVectors signature from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Signature, "CBaseAnimating::ResetSequence");
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKResetSequence = EndPrepSDKCall();
	if(g_hSDKResetSequence == null)
	{
		SetFailState("Failed to retrieve CBaseAnimating::ResetSequence signature from SF2 gamedata!");
	}

	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "CBaseEntity::MyNextBotPointer");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetNextBot = EndPrepSDKCall();
	if (g_hSDKGetNextBot == null)
	{
		PrintToServer("Failed to retrieve CBaseEntity::MyNextBotPointer offset from SF2 gamedata!");
	}

	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hConfig, SDKConf_Virtual, "INextBot::GetLocomotionInterface");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetLocomotionInterface = EndPrepSDKCall();
	if (g_hSDKGetLocomotionInterface == null)
	{
		PrintToServer("Failed to retrieve INextBot::GetLocomotionInterface offset from SF2 gamedata!");
	}

	int iOffset = GameConfGetOffset(hConfig, "CTFPlayer::WantsLagCompensationOnEntity"); 
	switch (iOffset)
	{
		case 328: g_iServerOS = 0; //Windows
		case 329: g_iServerOS = 1; //Linux
	}
	g_hSDKWantsLagCompensationOnEntity = DHookCreate(iOffset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity, Hook_ClientWantsLagCompensationOnEntity); 
	if (g_hSDKWantsLagCompensationOnEntity == null)
	{
		SetFailState("Failed to create hook CTFPlayer::WantsLagCompensationOnEntity offset from SF2 gamedata!");
	}

	DHookAddParam(g_hSDKWantsLagCompensationOnEntity, HookParamType_CBaseEntity);
	DHookAddParam(g_hSDKWantsLagCompensationOnEntity, HookParamType_ObjectPtr);
	DHookAddParam(g_hSDKWantsLagCompensationOnEntity, HookParamType_Unknown);

	iOffset = GameConfGetOffset(hConfig, "CBaseEntity::ShouldTransmit");
	g_hSDKShouldTransmit = DHookCreate(iOffset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity, Hook_EntityShouldTransmit);
	if (g_hSDKShouldTransmit == null)
	{
		SetFailState("Failed to create hook CBaseEntity::ShouldTransmit offset from SF2 gamedata!");
	}
	DHookAddParam(g_hSDKShouldTransmit, HookParamType_ObjectPtr);

	iOffset = GameConfGetOffset(hConfig, "CBaseEntity::UpdateTransmitState");
	g_hSDKUpdateTransmitState = new DynamicHook(iOffset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity);
	if (!g_hSDKUpdateTransmitState)
	{
		SetFailState("Failed to create hook CBaseEntity::UpdateTransmitState offset from SF2 gamedata!");
	}
	
	iOffset = GameConfGetOffset(hConfig, "CTFWeaponBase::GetCustomDamageType");
	g_hSDKWeaponGetCustomDamageType = DHookCreate(iOffset, HookType_Entity, ReturnType_Int, ThisPointer_CBaseEntity, Hook_WeaponGetCustomDamageType);
	if (g_hSDKWeaponGetCustomDamageType == null)
	{
		SetFailState("Failed to create hook CTFWeaponBase::GetCustomDamageType offset from SF2 gamedata!");
	}

	iOffset = GameConfGetOffset(hConfig, "CBaseProjectile::CanCollideWithTeammates");
	g_hSDKProjectileCanCollideWithTeammates = DHookCreate(iOffset, HookType_Entity, ReturnType_Bool, ThisPointer_CBaseEntity);
	if (g_hSDKProjectileCanCollideWithTeammates == null)
	{
		SetFailState("Failed to create hook CBaseProjectile::CanCollideWithTeammates offset from SF2 gamedata!");
	}

	iOffset = GameConfGetOffset(hConfig, "ILocomotion::ShouldCollideWith");
	g_hShouldCollide = DHookCreate(iOffset, HookType_Raw, ReturnType_Bool, ThisPointer_Address, ShouldCollideWith);
	if (g_hShouldCollide == null) SetFailState("Failed to create hook for ILocomotion::ShouldCollideWith!");
	DHookAddParam(g_hShouldCollide, HookParamType_CBaseEntity);

	//Initialize tutorial detours & calls
	//Tutorial_SetupSDK(hConfig);

	delete hConfig;
}

//	==========================================================
//	API
//	==========================================================

public int Native_IsRunning(Handle plugin,int numParams)
{
	return view_as<bool>(g_bEnabled);
}

public int Native_GetRoundState(Handle plugin,int numParams)
{
	return view_as<int>(g_iRoundState);
}

public int Native_IsRoundInGracePeriod(Handle plugin, int numParams)
{
	return g_bRoundGrace;
}

public int Native_GetCurrentDifficulty(Handle plugin,int numParams)
{
	return g_cvDifficulty.IntValue;
}

public int Native_GetDifficultyModifier(Handle plugin,int numParams)
{
	int iDifficulty = GetNativeCell(1);
	if (iDifficulty < Difficulty_Easy || iDifficulty >= Difficulty_Max)
	{
		LogError("Difficulty parameter can only be from %d to %d!", Difficulty_Easy, Difficulty_Max - 1);
		return 1;
	}
	
	switch (iDifficulty)
	{
		case Difficulty_Easy: return view_as<int>(DIFFICULTYMODIFIER_NORMAL);
		case Difficulty_Hard: return view_as<int>(DIFFICULTYMODIFIER_HARD);
		case Difficulty_Insane: return view_as<int>(DIFFICULTYMODIFIER_INSANE);
		case Difficulty_Nightmare: return view_as<int>(DIFFICULTYMODIFIER_NIGHTMARE);
		case Difficulty_Apollyon: return view_as<int>(DIFFICULTYMODIFIER_APOLLYON);
	}
	
	return view_as<int>(DIFFICULTYMODIFIER_NORMAL);
}

public int Native_IsClientEliminated(Handle plugin,int numParams)
{
	return view_as<bool>(g_bPlayerEliminated[GetNativeCell(1)]);
}

public int Native_IsClientInGhostMode(Handle plugin,int numParams)
{
	return IsClientInGhostMode(GetNativeCell(1));
}

public int Native_IsClientProxy(Handle plugin,int numParams)
{
	return view_as<bool>(g_bPlayerProxy[GetNativeCell(1)]);
}

public int Native_GetClientBlinkCount(Handle plugin,int numParams)
{
	return ClientGetBlinkCount(GetNativeCell(1));
}

public int Native_IsClientBlinking(Handle plugin,int numParams)
{
	return IsClientBlinking(GetNativeCell(1));
}

public int Native_GetClientBlinkMeter(Handle plugin,int numParams)
{
	return view_as<int>(ClientGetBlinkMeter(GetNativeCell(1)));
}

public int Native_SetClientBlinkMeter(Handle plugin,int numParams)
{
	ClientSetBlinkMeter(GetNativeCell(1), view_as<float>(GetNativeCell(2)));
}

public int Native_GetClientProxyMaster(Handle plugin,int numParams)
{
	return NPCGetFromUniqueID(g_iPlayerProxyMaster[GetNativeCell(1)]);
}

public int Native_GetClientProxyControlAmount(Handle plugin,int numParams)
{
	return g_iPlayerProxyControl[GetNativeCell(1)];
}

public int Native_GetClientProxyControlRate(Handle plugin,int numParams)
{
	return view_as<int>(g_flPlayerProxyControlRate[GetNativeCell(1)]);
}

public int Native_SetClientProxyMaster(Handle plugin,int numParams)
{
	g_iPlayerProxyMaster[GetNativeCell(1)] = NPCGetUniqueID(GetNativeCell(2));
}

public int Native_SetClientProxyControlAmount(Handle plugin,int numParams)
{
	g_iPlayerProxyControl[GetNativeCell(1)] = GetNativeCell(2);
}

public int Native_SetClientProxyControlRate(Handle plugin,int numParams)
{
	g_flPlayerProxyControlRate[GetNativeCell(1)] = view_as<float>(GetNativeCell(2));
}

public int Native_IsClientLookingAtBoss(Handle plugin,int numParams)
{
	return view_as<bool>(g_bPlayerSeesSlender[GetNativeCell(1)][GetNativeCell(2)]);
}

public int Native_DidClientEscape(Handle plugin,int numParams)
{
	return view_as<bool>(DidClientEscape(GetNativeCell(1)));
}

public int Native_ForceClientEscape(Handle plugin,int numParams)
{
	int client = GetNativeCell(1);

	ClientEscape(client);
	TeleportClientToEscapePoint(client);
}

public int Native_GetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	return view_as<int>(ClientGetFlashlightBatteryLife(GetNativeCell(1)));
}

public int Native_SetClientFlashlightBatteryLife(Handle plugin, int numParams)
{
	ClientSetFlashlightBatteryLife(GetNativeCell(1), view_as<float>(GetNativeCell(2)));
}

public int Native_IsClientUsingFlashlight(Handle plugin, int numParams)
{
	return IsClientUsingFlashlight(GetNativeCell(1));
}

public int Native_GetClientSprintPoints(Handle plugin, int numParams)
{
	return ClientGetSprintPoints(GetNativeCell(1));
}

public int Native_SetClientSprintPoints(Handle plugin, int numParams)
{
	g_iPlayerSprintPoints[GetNativeCell(1)] = GetNativeCell(2);
}

public int Native_IsClientSprinting(Handle plugin, int numParams)
{
	return IsClientSprinting(GetNativeCell(1));
}

public int Native_IsClientReallySprinting(Handle plugin, int numParams)
{
	return IsClientReallySprinting(GetNativeCell(1));
}

public int Native_IsClientTrapped(Handle plugin, int numParams)
{
	return g_bPlayerTrapped[GetNativeCell(1)];
}

public int Native_ClientSpawnProxy(Handle plugin, int numParams)
{
	float flTeleportPos[3];
	GetNativeArray(3, flTeleportPos, 3);
	int iSpawnPoint = GetNativeCell(4);
	return SpawnProxy(GetNativeCell(1), GetNativeCell(2), flTeleportPos, iSpawnPoint);
}

public int Native_ClientForceProxy(Handle plugin, int numParams)
{
	float flTeleportPos[3];
	GetNativeArray(3, flTeleportPos, 3);
	ClientStartProxyForce(GetNativeCell(1), GetNativeCell(2), flTeleportPos, GetNativeCell(4));
}

public int Native_CollectAsPage(Handle plugin,int numParams)
{
	CollectPage(GetNativeCell(1), GetNativeCell(2));
}

public int Native_GetMaxBosses(Handle plugin,int numParams)
{
	return MAX_BOSSES;
}

public int Native_EntIndexToBossIndex(Handle plugin,int numParams)
{
	return NPCGetFromEntIndex(GetNativeCell(1));
}

public int Native_BossIndexToEntIndex(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_iSlender[GetNativeCell(1)]);
}

public int Native_BossIndexToEntIndexEx(Handle plugin,int numParams)
{
	return NPCGetEntIndex(GetNativeCell(1));
}

public int Native_BossIDToBossIndex(Handle plugin,int numParams)
{
	return NPCGetFromUniqueID(GetNativeCell(1));
}

public int Native_BossIndexToBossID(Handle plugin,int numParams)
{
	return NPCGetUniqueID(GetNativeCell(1));
}

public int Native_AddBoss(Handle plugin, int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, sizeof(sProfile));

	int flags = GetNativeCell(2);
	bool spawnCompanions = view_as<bool>(GetNativeCell(3));
	bool playSpawnSound = view_as<bool>(GetNativeCell(4));

	return view_as<int>(AddProfile(sProfile, flags, _, spawnCompanions, playSpawnSound));
}

public int Native_RemoveBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
		return;
	
	RemoveProfile(boss.Index);
}

public int Native_GetBossName(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(GetNativeCell(1), sProfile, sizeof(sProfile));
	
	SetNativeString(2, sProfile, GetNativeCell(3));
}

public int Native_GetBossType(Handle plugin, int numParams)
{
	return NPCGetType(GetNativeCell(1));
}

public int Native_GetBossFlags(Handle plugin, int numParams)
{
	return NPCGetFlags(GetNativeCell(1));
}

public int Native_SetBossFlags(Handle plugin, int numParams)
{
	NPCSetFlags(GetNativeCell(1), GetNativeCell(2));
}

public int Native_SpawnBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
		return;

	float position[3];
	GetNativeArray(2, position, 3);

	SpawnSlender(boss, position);
}

public int Native_DespawnBoss(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
		return;

	RemoveSlender(boss.Index);
}

public int Native_GetBossModelEntity(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_iSlender[GetNativeCell(1)]);
}

public int Native_GetBossTarget(Handle plugin,int numParams)
{
	return EntRefToEntIndex(g_iSlenderTarget[GetNativeCell(1)]);
}

public int Native_SetBossTarget(Handle plugin, int numParams)
{
	g_iSlenderTarget[GetNativeCell(1)] = EntIndexToEntRef(GetNativeCell(2));
}

public int Native_GetBossMaster(Handle plugin,int numParams)
{
	return g_iSlenderCopyMaster[GetNativeCell(1)];
}

public int Native_GetBossState(Handle plugin,int numParams)
{
	return g_iSlenderState[GetNativeCell(1)];
}

public int Native_GetBossEyePosition(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid() || !IsValidEntity(boss.EntIndex))
		return;
	
	float eyePos[3];
	boss.GetEyePosition(eyePos);

	SetNativeArray(2, eyePos, 3);
}

public int Native_GetBossEyePositionOffset(Handle plugin, int numParams)
{
	SF2NPC_BaseNPC boss = SF2NPC_BaseNPC(GetNativeCell(1));
	if (!boss.IsValid())
		return;
	
	float eyePos[3];
	boss.GetEyePositionOffset(eyePos);

	SetNativeArray(2, eyePos, 3);
}

public int Native_GetBossFOV(Handle plugin, int numParams)
{
	return view_as<int>(NPCGetFOV(GetNativeCell(1)));
}

public int Native_GetBossTimeUntilNoPersistence(Handle plugin, int numParams)
{
	return view_as<int>(g_flSlenderTimeUntilNoPersistence[GetNativeCell(1)]);
}

public int Native_SetBossTimeUntilNoPersistence(Handle plugin, int numParams)
{
	g_flSlenderTimeUntilNoPersistence[GetNativeCell(1)] = view_as<float>(GetNativeCell(2));
}

public int Native_GetBossTimeUntilIdle(Handle plugin, int numParams)
{
	return view_as<int>(g_flSlenderTimeUntilIdle[GetNativeCell(1)]);
}

public int Native_SetBossTimeUntilIdle(Handle plugin, int numParams)
{
	g_flSlenderTimeUntilIdle[GetNativeCell(1)] = view_as<float>(GetNativeCell(2));
}

public int Native_GetBossTimeUntilAlert(Handle plugin, int numParams)
{
	return view_as<int>(g_flSlenderTimeUntilAlert[GetNativeCell(1)]);
}

public int Native_SetBossTimeUntilAlert(Handle plugin, int numParams)
{
	g_flSlenderTimeUntilAlert[GetNativeCell(1)] = view_as<float>(GetNativeCell(2));
}

public int Native_IsBossStunnable(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).StunEnabled;
}

public int Native_IsBossStunnableByFlashlight(Handle plugin, int numParams)
{
	return SF2NPC_Chaser(GetNativeCell(1)).StunByFlashlightEnabled;
}

public int Native_IsBossCloaked(Handle plugin, int numParams)
{
	return g_bNPCHasCloaked[GetNativeCell(1)];
}

public int Native_GetBossStunHealth(Handle plugin, int numParams)
{
	return view_as<int>(SF2NPC_Chaser(GetNativeCell(1)).StunHealth);
}

public int Native_SetBossStunHealth(Handle plugin, int numParams)
{
	SF2NPC_Chaser(GetNativeCell(1)).StunHealth = view_as<float>(GetNativeCell(2));
}

public int Native_GetBossNextStunTime(Handle plugin, int numParams)
{
	return view_as<int>(g_flSlenderNextStunTime[GetNativeCell(1)]);
}

public int Native_SetBossNextStunTime(Handle plugin, int numParams)
{
	g_flSlenderNextStunTime[GetNativeCell(1)] = view_as<float>(GetNativeCell(2));
}

public int Native_ForceBossGiveUp(Handle plugin, int numParams)
{
	g_bSlenderGiveUp[GetNativeCell(1)] = false;
}

public int Native_GetBossGoalPosition(Handle plugin, int numParams)
{
	SetNativeArray(2, g_flSlenderGoalPos[GetNativeCell(1)], 3);
}

public int Native_CanBossHearClient(Handle plugin, int numParams)
{
	return SlenderCanHearPlayer(GetNativeCell(1), GetNativeCell(2), view_as<SoundType>(GetNativeCell(3)));
}

public int Native_CreateBossSoundHint(Handle plugin, int numParams)
{
	SF2NPC_Chaser boss = SF2NPC_Chaser(GetNativeCell(1));
	if (!boss.IsValid() || boss.Type != SF2BossType_Chaser || !IsValidEntity(boss.EntIndex))
		return;

	SoundType soundType = view_as<SoundType>(GetNativeCell(2));

	float position[3];
	GetNativeArray(3, position, 3);

	int difficulty = GetNativeCell(4);

	switch (soundType)
	{
		case SoundType_Footstep:
		{
			CopyVector(position, g_flSlenderTargetSoundTempPos[boss.Index]);
			g_iSlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDFOOTSTEP);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_flSlenderAutoChaseCooldown[boss.Index] <= GetGameTime()) 
			{
				g_iSlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddFootstep(boss.Index, difficulty);
				g_flSlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Voice:
		{
			CopyVector(position, g_flSlenderTargetSoundTempPos[boss.Index]);
			g_iSlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDVOICE);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_flSlenderAutoChaseCooldown[boss.Index] <= GetGameTime()) 
			{
				g_iSlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddVoice(boss.Index, difficulty);
				g_flSlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Weapon:
		{
			CopyVector(position, g_flSlenderTargetSoundTempPos[boss.Index]);
			g_iSlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDWEAPON);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_flSlenderAutoChaseCooldown[boss.Index] <= GetGameTime()) 
			{
				g_iSlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddWeapon(boss.Index, difficulty);	
				g_flSlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
		case SoundType_Flashlight:
		{
			CopyVector(position, g_flSlenderTargetSoundTempPos[boss.Index]);
			g_iSlenderInterruptConditions[boss.Index] |= (COND_HEARDSUSPICIOUSSOUND | COND_HEARDFLASHLIGHT);
			if (boss.State == STATE_ALERT && NPCChaserIsAutoChaseEnabled(boss.Index) && g_flSlenderAutoChaseCooldown[boss.Index] <= GetGameTime()) 
			{
				g_iSlenderAutoChaseCount[boss.Index] += NPCChaserAutoChaseAddWeapon(boss.Index, difficulty);	
				g_flSlenderAutoChaseCooldown[boss.Index] = GetGameTime() + 0.3;
			}
		}
	}
}

public int Native_IsBossProfileValid(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);
	
	return IsProfileValid(sProfile);
}

public int Native_GetBossProfileNum(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);
	
	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	return GetProfileNum(sProfile, sKeyValue, GetNativeCell(3));
}

public int Native_GetBossProfileFloat(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	return view_as<int>(GetProfileFloat(sProfile, sKeyValue, view_as<float>(GetNativeCell(3))));
}

public int Native_GetBossProfileString(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	int iResultLen = GetNativeCell(4);
	char[] sResult = new char[iResultLen];
	
	char sDefaultValue[512];
	GetNativeString(5, sDefaultValue, sizeof(sDefaultValue));
	
	bool bSuccess = GetProfileString(sProfile, sKeyValue, sResult, iResultLen, sDefaultValue);
	
	SetNativeString(3, sResult, iResultLen);
	return bSuccess;
}

public int Native_GetBossProfileVector(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	float flResult[3];
	float flDefaultValue[3];
	GetNativeArray(4, flDefaultValue, 3);
	
	bool bSuccess = GetProfileVector(sProfile, sKeyValue, flResult, flDefaultValue);
	
	SetNativeArray(3, flResult, 3);
	return bSuccess;
}

public int Native_GetBossAttackProfileNum(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);
	
	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	return GetProfileAttackNum(sProfile, sKeyValue, GetNativeCell(3), GetNativeCell(4));
}

public int Native_GetBossAttackProfileFloat(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	return view_as<int>(GetProfileAttackFloat(sProfile, sKeyValue, view_as<float>(GetNativeCell(3)), GetNativeCell(4)));
}

public int Native_GetBossAttackProfileString(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	int iResultLen = GetNativeCell(4);
	char[] sResult = new char[iResultLen];
	
	char sDefaultValue[512];
	GetNativeString(5, sDefaultValue, sizeof(sDefaultValue));
	
	bool bSuccess = GetProfileAttackString(sProfile, sKeyValue, sResult, iResultLen, sDefaultValue, GetNativeCell(6));
	
	SetNativeString(3, sResult, iResultLen);
	return bSuccess;
}

public int Native_GetBossAttackProfileVector(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	float flResult[3];
	float flDefaultValue[3];
	GetNativeArray(4, flDefaultValue, 3);
	
	bool bSuccess = GetProfileAttackVector(sProfile, sKeyValue, flResult, flDefaultValue, GetNativeCell(5));
	
	SetNativeArray(3, flResult, 3);
	return bSuccess;
}

public int Native_GetRandomStringFromBossProfile(Handle plugin,int numParams)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	GetNativeString(1, sProfile, SF2_MAX_PROFILE_NAME_LENGTH);

	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));
	
	int iBufferLen = GetNativeCell(4);
	char[] sBuffer = new char[iBufferLen];
	
	int iIndex = GetNativeCell(5);

	bool bSuccess = GetRandomStringFromProfile(sProfile, sKeyValue, sBuffer, iBufferLen, iIndex);
	SetNativeString(3, sBuffer, iBufferLen);
	return bSuccess;
}

public int Native_GetBossAttributeName(Handle plugin,int numParams)
{
	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));

	bool bSuccess = NPCHasAttribute(GetNativeCell(1), sKeyValue);
	return bSuccess;
}

public int Native_GetBossAttributeValue(Handle plugin,int numParams)
{
	char sKeyValue[256];
	GetNativeString(2, sKeyValue, sizeof(sKeyValue));

	if (!NPCHasAttribute(GetNativeCell(1), sKeyValue)) return view_as<int>(GetNativeCell(3));
	return view_as<int>(NPCGetAttributeValue(GetNativeCell(1), sKeyValue, view_as<float>(GetNativeCell(3))));
}

public int Native_GetBossProjectileType(Handle plugin,int numParams)
{
	return NPCChaserGetProjectileType(GetNativeCell(1));
}

public int Native_GetBossCurrentAttackIndex(Handle plugin,int numParams)
{
	return NPCGetCurrentAttackIndex(GetNativeCell(1));
}

public int Native_GetBossAttackIndexDamageType(Handle plugin,int numParams)
{
	return NPCChaserGetAttackDamageType(GetNativeCell(1), GetNativeCell(2));
}

public int Native_GetBossAttackIndexDamage(Handle plugin,int numParams)
{
	return view_as<int>(NPCChaserGetAttackDamage(GetNativeCell(1), GetNativeCell(2), GetNativeCell(3)));
}

public int Native_GetBossAttackIndexType(Handle plugin,int numParams)
{
	return NPCChaserGetAttackType(GetNativeCell(1), GetNativeCell(2));
}

public int Native_GetVectorSquareMagnitude(Handle plugin, int numParams)
{
	float vec1[3], vec2[3];
	GetNativeArray(1, vec1, 3);
	GetNativeArray(2, vec2, 3);
	return view_as<int>(GetVectorSquareMagnitude(vec1, vec2));
}

public int Native_InitiateBossPackVote(Handle plugin, int numParams)
{
	InitiateBossPackVote(GetNativeCell(1));
}

public int Native_GetProjectileFlags(Handle plugin, int numParams)
{
	return ProjectileGetFlags(GetNativeCell(1));
}

public int Native_SetProjectileFlags(Handle plugin, int numParams)
{
	ProjectileSetFlags(GetNativeCell(1), GetNativeCell(2));
}

public int Native_IsSurvivalMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsSurvivalMap());
}

public int Native_IsBoxingMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsBoxingMap());
}

public int Native_IsRaidMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsRaidMap());
}

public int Native_IsProxyMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsProxyMap());
}

public int Native_IsSlaughterRunMap(Handle plugin, int numParams)
{
	return view_as<int>(SF_IsSlaughterRunMap());
}