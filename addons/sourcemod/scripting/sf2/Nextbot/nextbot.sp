//Special thanks to Arthurdead for helping me on some functions about Nextbot and for providing the base ILocomotion methodmap!
//This method is build on ILocomotion & NextBotGroundLocomotion & CTFBaseBossLocomotion only! In other words it supports "base_boss" and "tank_boss" only!!!!

/* INextBot */
//Handle g_hClimbUpToLedge;
//Handle g_hJumpAcrossGap;
Handle g_hGetGravity;
Handle g_hGetMaxDeceleration;
Handle g_hGetAcceleration;
Handle g_hGetFrictionForward;
Handle g_hGetFrictionSideways;
Handle g_hIsAbleToClimb;
Handle g_hIsAbleToJumpAcrossGaps;
Handle g_hGetStepHeight;
Handle g_hGetMaxJumpHeight;
Handle g_hGetRunSpeed;
Handle g_hGetWalkSpeed;
Handle g_hGetSpeedLimit;
Handle g_hShouldCollide;

static Handle g_hSDKGetEntity;
static Handle g_hSDKUpdate;
static Handle g_hSDKGetBodyInterface;
static Handle g_hSDKGetLocomotionInterface;

/* IBody */
Handle g_hStartActivity;
Handle g_hGetHullWidth;
Handle g_hGetHullHeight;
Handle g_hGetStandHullHeight;
Handle g_hGetCrouchHullHeight;
Handle g_hGetHullMins;
Handle g_hGetHullMaxs;
Handle g_hGetSolidMask;

static Handle g_hSDKGetHullWidth;

/* INextBotComponent */
static Handle g_hSDKGetBot;

/* NextBotGroundLocomotion */
static Handle g_hSDKSetVel;
static Handle g_hSDKGetGravity;

/* ILocomotion */
static Handle g_hSDKStop;
static Handle g_hSDKRun;
static Handle g_hSDKJump;
static Handle g_hSDKWalk;
static Handle g_hSDKGetStepHeight;
static Handle g_hSDKIsClimbingOrJumping;
static Handle g_hSDKIsOnGround;
static Handle g_hSDKIsStuck;
static Handle g_hSDKGetGroundSpeed;
static Handle g_hSDKGetGroundNormal;
static Handle g_hSDKGetGroundMotionVector;
static Handle g_hSDKGetFeet;
static Handle g_hSDKFaceTowards;
static Handle g_hSDKApproach;

/* CBaseEntity */
static Handle g_hSDKGetNextBot;

enum ILocomotion: {};

methodmap INextBotComponent __nullable__
{
	public Address GetBot()
	{
		if (g_hSDKGetBot != INVALID_HANDLE)
			return SDKCall(g_hSDKGetBot, this);
		return Address_Null;
	}
	public bool Verify()
	{
		if (this == view_as<INextBotComponent>(Address_Null))
			return false;
		return true;
	}
}

methodmap IBody < INextBotComponent
{
	public float GetHullWidth()
	{
		if (this.Verify() && g_hSDKGetHullWidth != INVALID_HANDLE)
			return SDKCall(g_hSDKGetHullWidth, this);
		return 0.0;
	}
}

methodmap INextBot __nullable__
{
	public int GetEntity()
	{
		if (g_hSDKGetEntity != INVALID_HANDLE)
			return SDKCall(g_hSDKGetEntity, this);
		return -1;
	}
	public void Update()
	{
		if (g_hSDKUpdate != INVALID_HANDLE)
			SDKCall(g_hSDKUpdate, this);
	}
	public IBody GetBodyInterface()
	{
		if (g_hSDKGetBodyInterface != INVALID_HANDLE)
			return SDKCall(g_hSDKGetBodyInterface, this);
		return view_as<IBody>(Address_Null);
	}
	public ILocomotion GetLocomotionInterface()
	{
		return SDKCall(g_hSDKGetLocomotionInterface, this);
	}
}

methodmap ILocomotion < INextBotComponent
{
	public void Stop()
	{
		if (this.Verify() && g_hSDKStop != INVALID_HANDLE)
			SDKCall(g_hSDKStop, this);
	}
	public void Walk()
	{
		if (this.Verify() && g_hSDKWalk != INVALID_HANDLE)
			SDKCall(g_hSDKWalk, this);
	}
	public void Run()
	{
		if (this.Verify() && g_hSDKRun != INVALID_HANDLE)
			SDKCall(g_hSDKRun, this);
	}
	public void Jump()
	{
		if (this.Verify() && g_hSDKJump != INVALID_HANDLE)
			SDKCall(g_hSDKJump, this);
	}
	public void Approach(float vecApproach[3], float flPriority)
	{
		if (this.Verify() && g_hSDKApproach != INVALID_HANDLE)
			SDKCall(g_hSDKApproach, this, vecApproach, flPriority);
	}
	public void FaceTowards(float vecFacePos[3])
	{
		if (this.Verify() && g_hSDKFaceTowards != INVALID_HANDLE)
			SDKCall(g_hSDKFaceTowards, this, vecFacePos);
	}
	public void GetGroundNormal(float vecNormal[3])
	{
		if (this.Verify() && g_hSDKGetGroundNormal != INVALID_HANDLE)
			SDKCall(g_hSDKGetGroundNormal, this, vecNormal);
	}
	public void GetGroundMotionVector(float vecMotion[3])
	{
		if (this.Verify() && g_hSDKGetGroundMotionVector != INVALID_HANDLE)
			SDKCall(g_hSDKGetGroundMotionVector, this, vecMotion);
	}
	public void GetFeet(float vecFeet[3])
	{
		if (this.Verify() && g_hSDKGetFeet != INVALID_HANDLE)
			SDKCall(g_hSDKGetFeet, this, vecFeet);
	}
	public float GetStepHeight()
	{
		if (this.Verify() && g_hSDKGetStepHeight != INVALID_HANDLE)
			return SDKCall(g_hSDKGetStepHeight, this);
		return 18.0;
	}
	public bool IsClimbingOrJumping()
	{
		if (this.Verify() && g_hSDKIsClimbingOrJumping != INVALID_HANDLE)
			return SDKCall(g_hSDKIsClimbingOrJumping, this);
		return false;
	}
	public bool IsOnGround()
	{
		if (this.Verify() && g_hSDKIsOnGround != INVALID_HANDLE)
			return SDKCall(g_hSDKIsOnGround, this);
		return true;
	}
	public bool IsStuck()
	{
		if (this.Verify() && g_hSDKIsStuck != INVALID_HANDLE)
			return SDKCall(g_hSDKIsStuck, this);
		return false;
	}
	public float GetGroundSpeed()
	{
		if (this.Verify() && g_hSDKGetGroundSpeed != INVALID_HANDLE)
			return SDKCall(g_hSDKGetGroundSpeed, this);
		return 0.0;
	}
}

methodmap NextBotGroundLocomotion < ILocomotion
{
	public void SetVelocity(float vecVel[3])
	{
		if (g_hSDKSetVel != INVALID_HANDLE)
			SDKCall(g_hSDKSetVel, this, vecVel);
	}
	public float GetGravity()
	{
		if (g_hSDKGetGravity != INVALID_HANDLE)
			return SDKCall(g_hSDKGetGravity, this);
		return 0.0;
	}
}

INextBot SF2_GetEntityNextBotInterface(int iEntity)
{
	return SDKCall(g_hSDKGetNextBot, iEntity);
}

public void InitNextBotGameData(Handle hGameData)
{
	//Hook
	int iOffset = GameConfGetOffset(hGameData, "NextBotGroundLocomotion::GetGravity"); 
	g_hGetGravity = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetGravity);
	
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "CBaseEntity::MyNextBotPointer");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetNextBot = EndPrepSDKCall();
	if (g_hSDKGetNextBot == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve CBaseEntity::MyNextBotPointer offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "INextBotComponent::GetBot");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetBot = EndPrepSDKCall();
	if (g_hSDKGetBot == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve INextBotComponent::GetBot offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "INextBot::GetEntity");
	PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
	g_hSDKGetEntity = EndPrepSDKCall();
	if (g_hSDKGetEntity == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve INextBot::GetEntity offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "INextBot::GetLocomotionInterface");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetLocomotionInterface = EndPrepSDKCall();
	if (g_hSDKGetLocomotionInterface == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve INextBot::GetLocomotionInterface offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "INextBot::GetBodyInterface");
	PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_ByValue);
	g_hSDKGetBodyInterface = EndPrepSDKCall();
	if (g_hSDKGetBodyInterface == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve INextBot::GetBodyInterface offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "INextBot::Update");
	g_hSDKUpdate = EndPrepSDKCall();
	if (g_hSDKUpdate == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve INextBot::Update offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "IBody::GetHullWidth");
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	g_hSDKGetHullWidth = EndPrepSDKCall();
	if (g_hSDKGetHullWidth == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve IBody::GetHullWidth offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::Stop");
	g_hSDKStop = EndPrepSDKCall();
	if (g_hSDKStop == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::Stop offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::Walk");
	g_hSDKWalk = EndPrepSDKCall();
	if (g_hSDKWalk == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::Walk offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::Run");
	g_hSDKRun = EndPrepSDKCall();
	if (g_hSDKRun == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::Run offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::Jump");
	g_hSDKJump = EndPrepSDKCall();
	if (g_hSDKJump == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::Jump offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::GetStepHeight");
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	g_hSDKGetStepHeight = EndPrepSDKCall();
	if (g_hSDKGetStepHeight == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::GetStepHeight offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::IsClimbingOrJumping");
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_ByValue);
	g_hSDKIsClimbingOrJumping = EndPrepSDKCall();
	if (g_hSDKIsClimbingOrJumping == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::IsClimbingOrJumping offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::IsOnGround");
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_ByValue);
	g_hSDKIsOnGround = EndPrepSDKCall();
	if (g_hSDKIsOnGround == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::IsOnGround offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::IsStuck");
	PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_ByValue);
	g_hSDKIsStuck = EndPrepSDKCall();
	if (g_hSDKIsStuck == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::IsStuck offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::GetGroundSpeed");
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	g_hSDKGetGroundSpeed = EndPrepSDKCall();
	if (g_hSDKGetGroundSpeed == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::GetGroundSpeed offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::GetFeet");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_Pointer, _, VENCODE_FLAG_COPYBACK);
	g_hSDKGetFeet = EndPrepSDKCall();
	if (g_hSDKGetFeet == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::GetFeet offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::GetGroundMotionVector");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_Pointer, _, VENCODE_FLAG_COPYBACK);
	g_hSDKGetGroundMotionVector = EndPrepSDKCall();
	if (g_hSDKGetGroundMotionVector == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::GetGroundMotionVector offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::GetGroundNormal");
	PrepSDKCall_SetReturnInfo(SDKType_Vector, SDKPass_Pointer, _, VENCODE_FLAG_COPYBACK);
	g_hSDKGetGroundNormal = EndPrepSDKCall();
	if (g_hSDKGetGroundNormal == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::GetGroundNormal offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::Approach");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
	PrepSDKCall_AddParameter(SDKType_Float, SDKPass_ByValue);
	g_hSDKApproach = EndPrepSDKCall();
	if (g_hSDKApproach == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::Approach offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "ILocomotion::FaceTowards");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
	g_hSDKFaceTowards = EndPrepSDKCall();
	if (g_hSDKFaceTowards == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve ILocomotion::FaceTowards offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "NextBotGroundLocomotion::SetVelocity");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef, VDECODE_FLAG_ALLOWNULL);
	g_hSDKSetVel = EndPrepSDKCall();
	if (g_hSDKSetVel == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve NextBotGroundLocomotion::SetVelocity offset from SF2 gamedata!");
	}
	
	StartPrepSDKCall(SDKCall_Raw);
	PrepSDKCall_SetFromConf(hGameData, SDKConf_Virtual, "NextBotGroundLocomotion::GetGravity");
	PrepSDKCall_SetReturnInfo(SDKType_Float, SDKPass_ByValue);
	g_hSDKGetGravity = EndPrepSDKCall();
	if (g_hSDKGetGravity == INVALID_HANDLE)
	{
		PrintToServer("Failed to retrieve NextBotGroundLocomotion::GetGravity offset from SF2 gamedata!");
	}
	
	/*iOffset = GameConfGetOffset(hGameData, "ILocomotion::ClimbUpToLedge"); 
	g_hClimbUpToLedge = DHookCreate(iOffset, HookType_Raw, ReturnType_Void, ThisPointer_Address, ClimbUpToLedge);
	if (g_hClimbUpToLedge == null) SetFailState("Failed to create hook for ILocomotion::ClimbUpToLedge!");
	DHookAddParam(g_hClimbUpToLedge, HookParamType_VectorPtr);
	DHookAddParam(g_hClimbUpToLedge, HookParamType_VectorPtr);
	DHookAddParam(g_hClimbUpToLedge, HookParamType_CBaseEntity);*/
	
	/*iOffset = GameConfGetOffset(hGameData, "ILocomotion::JumpAcrossGap"); 
	g_hJumpAcrossGap = DHookCreate(iOffset, HookType_Raw, ReturnType_Void, ThisPointer_Address, ClimbUpToLedge);
	if (g_hJumpAcrossGap == null) SetFailState("Failed to create hook for ILocomotion::JumpAcrossGap!");
	DHookAddParam(g_hJumpAcrossGap, HookParamType_VectorPtr);
	DHookAddParam(g_hJumpAcrossGap, HookParamType_VectorPtr);*/

	iOffset = GameConfGetOffset(hGameData, "NextBotGroundLocomotion::GetMaxDeceleration"); 
	g_hGetMaxDeceleration = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetMaxDeceleration);

	iOffset = GameConfGetOffset(hGameData, "NextBotGroundLocomotion::GetFrictionForward"); 
	g_hGetFrictionForward = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetFrictionForward);
	
	iOffset = GameConfGetOffset(hGameData, "NextBotGroundLocomotion::GetFrictionSideways"); 
	g_hGetFrictionSideways = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetFrictionSideways);
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::IsAbleToClimb"); 
	g_hIsAbleToClimb = DHookCreate(iOffset, HookType_Raw, ReturnType_Bool, ThisPointer_Address, IsAbleToClimb);
	if (g_hIsAbleToClimb == null) SetFailState("Failed to create hook for ILocomotion::IsAbleToClimb!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::IsAbleToJumpAcrossGaps"); 
	g_hIsAbleToJumpAcrossGaps = DHookCreate(iOffset, HookType_Raw, ReturnType_Bool, ThisPointer_Address, IsAbleToClimb);
	if (g_hIsAbleToJumpAcrossGaps == null) SetFailState("Failed to create hook for ILocomotion::IsAbleToJumpAcrossGaps!");

	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetStepHeight"); 
	g_hGetStepHeight = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetStepHeight);
	if (g_hGetStepHeight == null) SetFailState("Failed to create hook for ILocomotion::GetStepHeight!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetMaxJumpHeight"); 
	g_hGetMaxJumpHeight = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetMaxJumpHeight);
	if (g_hGetMaxJumpHeight == null) SetFailState("Failed to create hook for ILocomotion::GetMaxJumpHeight!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetMaxAcceleration"); 
	g_hGetAcceleration = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetAcceleration);
	if (g_hGetAcceleration == null) SetFailState("Failed to create hook for ILocomotion::GetMaxAcceleration!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetRunSpeed"); 
	g_hGetRunSpeed = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetRunSpeed);
	if (g_hGetRunSpeed == null) SetFailState("Failed to create hook for ILocomotion::GetRunSpeed!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetWalkSpeed"); 
	g_hGetWalkSpeed = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetWalkSpeed);
	if (g_hGetWalkSpeed == null) SetFailState("Failed to create hook for ILocomotion::GetWalkSpeed!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::GetSpeedLimit");
	g_hGetSpeedLimit = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetSpeedLimit);
	if (g_hGetSpeedLimit == null) SetFailState("Failed to create hook for ILocomotion::GetSpeedLimit!");
	
	iOffset = GameConfGetOffset(hGameData, "ILocomotion::ShouldCollideWith");
	g_hShouldCollide = DHookCreate(iOffset, HookType_Raw, ReturnType_Bool, ThisPointer_Address, ShouldCollideWith);
	if (g_hShouldCollide == null) SetFailState("Failed to create hook for ILocomotion::ShouldCollideWith!");
	DHookAddParam(g_hShouldCollide, HookParamType_CBaseEntity);

	iOffset = GameConfGetOffset(hGameData, "IBody::StartActivity");
	g_hStartActivity = DHookCreate(iOffset, HookType_Raw, ReturnType_Bool, ThisPointer_Address, StartActivity);
	if (g_hStartActivity == null) SetFailState("Failed to create hook for IBody::StartActivity!");

	iOffset = GameConfGetOffset(hGameData, "IBody::GetHullWidth");
	if(iOffset == -1) SetFailState("Failed to get offset of IBody::GetHullWidth");
	g_hGetHullWidth = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetHullWidth);
	
	iOffset = GameConfGetOffset(hGameData, "IBody::GetHullHeight");
	if(iOffset == -1) SetFailState("Failed to get offset of IBody::GetHullHeight");
	g_hGetHullHeight = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetHullHeight);

	iOffset = GameConfGetOffset(hGameData, "IBody::GetStandHullHeight");
	if(iOffset == -1) SetFailState("Failed to get offset of IBody::GetStandHullHeight");
	g_hGetStandHullHeight = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetStandHullHeight);

	iOffset = GameConfGetOffset(hGameData, "IBody::GetCrouchHullHeight");
	g_hGetCrouchHullHeight = DHookCreate(iOffset, HookType_Raw, ReturnType_Float, ThisPointer_Address, GetCrouchHullHeight);
	if (g_hGetCrouchHullHeight == null) SetFailState("Failed to create hook for IBody::GetCrouchHullHeight!");
	
	iOffset = GameConfGetOffset(hGameData, "IBody::GetHullMins");
	g_hGetHullMins = DHookCreate(iOffset, HookType_Raw, ReturnType_VectorPtr, ThisPointer_Address, GetHullMins);
	if (g_hGetHullMins == null) SetFailState("Failed to create hook for IBody::GetHullMins!");
	
	iOffset = GameConfGetOffset(hGameData, "IBody::GetHullMaxs");
	g_hGetHullMaxs = DHookCreate(iOffset, HookType_Raw, ReturnType_VectorPtr, ThisPointer_Address, GetHullMaxs);
	if (g_hGetHullMaxs == null) SetFailState("Failed to create hook for IBody::GetHullMaxs!");
	
	iOffset = GameConfGetOffset(hGameData, "IBody::GetSolidMask");
	g_hGetSolidMask = DHookCreate(iOffset, HookType_Raw, ReturnType_Int, ThisPointer_Address, GetSolidMask);
	if (g_hGetSolidMask == null) SetFailState("Failed to create hook for IBody::GetSolidMask!");
}