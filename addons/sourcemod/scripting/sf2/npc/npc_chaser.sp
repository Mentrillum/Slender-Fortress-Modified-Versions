#if defined _sf2_npc_chaser_included
 #endinput
#endif
#define _sf2_npc_chaser_included

static float g_flSlenderUnStuckPos[MAX_BOSSES];
static float g_flNPCStepSize[MAX_BOSSES];

static float g_flNPCWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAirSpeed[MAX_BOSSES][Difficulty_Max];

static float g_flNPCMaxWalkSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCMaxAirSpeed[MAX_BOSSES][Difficulty_Max];

static float g_flNPCWakeRadius[MAX_BOSSES];

static bool g_bNPCStunEnabled[MAX_BOSSES];
static float g_flNPCStunDuration[MAX_BOSSES];
static float g_flNPCStunCooldown[MAX_BOSSES];
static bool g_bNPCStunFlashlightEnabled[MAX_BOSSES];
static bool g_bNPCHasKeyDrop[MAX_BOSSES];
static float g_flNPCStunFlashlightDamage[MAX_BOSSES];
static float g_flNPCStunInitialHealth[MAX_BOSSES];
static float g_flNPCStunHealth[MAX_BOSSES];

static int g_iNPCState[MAX_BOSSES] = { -1, ... };
static int g_iNPCTeleporter[MAX_BOSSES][MAX_NPCTELEPORTER];
static int g_iNPCMovementActivity[MAX_BOSSES] = { -1, ... };
static int g_iNPCCurrentAnimationSequence[MAX_BOSSES] = { -1, ... };
static bool g_bNPCCurrentAnimationSequenceIsLooped[MAX_BOSSES] = { false, ... };
static float g_flNPCCurrentAnimationSequencePlaybackRate[MAX_BOSSES] = { 1.0, ... };
static Handle g_hBossFailSafeTimer[MAX_BOSSES];

enum SF2NPCChaser_BaseAttackStructure
{
	SF2NPCChaser_BaseAttackType,
	Float:SF2NPCChaser_BaseAttackDamage,
	Float:SF2NPCChaser_BaseAttackDamageVsProps,
	Float:SF2NPCChaser_BaseAttackDamageForce,
	SF2NPCChaser_BaseAttackDamageType,
	Float:SF2NPCChaser_BaseAttackDamageDelay,
	Float:SF2NPCChaser_BaseAttackRange,
	Float:SF2NPCChaser_BaseAttackDuration,
	Float:SF2NPCChaser_BaseAttackSpread,
	Float:SF2NPCChaser_BaseAttackBeginRange,
	Float:SF2NPCChaser_BaseAttackBeginFOV,
	Float:SF2NPCChaser_BaseAttackCooldown,
	Float:SF2NPCChaser_BaseAttackNextAttackTime
};

static int g_NPCBaseAttacksCount[MAX_BOSSES];
static g_NPCBaseAttacks[MAX_BOSSES][SF2_CHASER_BOSS_MAX_ATTACKS][SF2NPCChaser_BaseAttackStructure];
static int g_iNPCCurrentAttackIndex[MAX_BOSSES];


const SF2NPC_Chaser SF2_INVALID_NPC_CHASER = view_as<SF2NPC_Chaser>(-1);


methodmap SF2NPC_Chaser < SF2NPC_BaseNPC
{
	property float WakeRadius
	{
		public get() { return NPCChaserGetWakeRadius(this.Index); }
	}
	
	property float StepSize
	{
		public get() { return NPCChaserGetStepSize(this.Index); }
	}
	
	property bool StunEnabled
	{
		public get() { return NPCChaserIsStunEnabled(this.Index); }
	}
	
	property bool StunByFlashlightEnabled
	{
		public get() { return NPCChaserIsStunByFlashlightEnabled(this.Index); }
	}
	
	property float StunFlashlightDamage
	{
		public get() { return NPCChaserGetStunFlashlightDamage(this.Index); }
	}
	
	property float StunDuration
	{
		public get() { return NPCChaserGetStunDuration(this.Index); }
	}
	
	property float StunHealth
	{
		public get() { return NPCChaserGetStunHealth(this.Index); }
		public set(float amount) { NPCChaserSetStunHealth(this.Index, amount); }
	}
	
	property float StunInitialHealth
	{
		public get() { return NPCChaserGetStunInitialHealth(this.Index); }
		public set(float amount) { NPCChaserSetStunInitialHealth(this.Index, amount); }
	}
	
	property int State
	{
		public get() { return NPCChaserGetState(this.Index); }
		public set(int state) { NPCChaserSetState(this.Index, state); }
	}
	
	property int MovementActivity
	{
		public get() { return NPCChaserGetMovementActivity(this.Index); }
		public set(int movementActivity) { NPCChaserSetMovementActivity(this.Index, movementActivity); }
	}
	
	public SF2NPC_Chaser(int index)
	{
		return SF2NPC_Chaser:SF2NPC_BaseNPC(index);
	}
	
	public int GetTeleporter(int iTeleporterNumber)
	{
		return NPCChaserGetTeleporter(this.Index,iTeleporterNumber);
	}
	
	public void SetTeleporter(int iTeleporterNumber,int iEntity)
	{
		NPCChaserSetTeleporter(this.Index,iTeleporterNumber,iEntity);
	}
	
	public float GetWalkSpeed(int difficulty)
	{
		return NPCChaserGetWalkSpeed(this.Index, difficulty);
	}
	
	public void SetWalkSpeed(int difficulty, float amount)
	{
		NPCChaserSetWalkSpeed(this.Index, difficulty, amount);
	}
	
	public float GetAirSpeed(int difficulty)
	{
		return NPCChaserGetAirSpeed(this.Index, difficulty);
	}
	
	public void SetAirSpeed(int difficulty, float amount)
	{
		NPCChaserSetAirSpeed(this.Index, difficulty, amount);
	}
	
	public float GetMaxWalkSpeed(int difficulty)
	{
		return NPCChaserGetMaxWalkSpeed(this.Index, difficulty);
	}
	
	public void SetMaxWalkSpeed(int difficulty, float amount)
	{
		NPCChaserSetMaxWalkSpeed(this.Index, difficulty, amount);
	}
	
	public float GetMaxAirSpeed(int difficulty)
	{
		return NPCChaserGetMaxAirSpeed(this.Index, difficulty);
	}
	
	public void SetMaxAirSpeed(int difficulty, float amount)
	{
		NPCChaserSetMaxAirSpeed(this.Index, difficulty, amount);
	}
	
	public void AddStunHealth(float amount)
	{
		NPCChaserAddStunHealth(this.Index, amount);
	}
}

public void NPCChaserSetTeleporter(int iBossIndex, int iTeleporterNumber, int iEntity)
{
	g_iNPCTeleporter[iBossIndex][iTeleporterNumber] = iEntity;
}

public int NPCChaserGetTeleporter(int iBossIndex, int iTeleporterNumber)
{
	return g_iNPCTeleporter[iBossIndex][iTeleporterNumber];
}

public void NPCChaserInitialize()
{
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		NPCChaserResetValues(iNPCIndex);
	}
}

void NPCChaserResetAnimationInfo(int iNPCIndex, int iSequence = 0)
{
	g_iNPCCurrentAnimationSequence[iNPCIndex] = iSequence;
	g_bNPCCurrentAnimationSequenceIsLooped[iNPCIndex] = false;
	g_flNPCCurrentAnimationSequencePlaybackRate[iNPCIndex] = 1.0;
}

float NPCChaserGetWalkSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCWalkSpeed[iNPCIndex][iDifficulty];
}

void NPCChaserSetWalkSpeed(int iNPCIndex, int iDifficulty, float flAmount)
{
	g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = flAmount;
}

float NPCChaserGetAirSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCAirSpeed[iNPCIndex][iDifficulty];
}

void NPCChaserSetAirSpeed(int iNPCIndex, int iDifficulty, float flAmount)
{
	g_flNPCAirSpeed[iNPCIndex][iDifficulty] = flAmount;
}

float NPCChaserGetMaxWalkSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty];
}

void NPCChaserSetMaxWalkSpeed(int iNPCIndex, int iDifficulty, float flAmount)
{
	g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = flAmount;
}

float NPCChaserGetMaxAirSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty];
}

void NPCChaserSetMaxAirSpeed(int iNPCIndex, int iDifficulty, float flAmount)
{
	g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty] = flAmount;
}

float NPCChaserGetWakeRadius(int iNPCIndex)
{
	return g_flNPCWakeRadius[iNPCIndex];
}

float NPCChaserGetStepSize(int iNPCIndex)
{
	return g_flNPCStepSize[iNPCIndex];
}

int NPCChaserGetAttackCount(int iNPCIndex)
{
	return g_NPCBaseAttacksCount[iNPCIndex];
}

int NPCChaserGetAttackType(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackType];
}

float NPCChaserGetAttackDamage(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDamage];
}

float NPCChaserGetAttackDamageVsProps(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDamageVsProps];
}

float NPCChaserGetAttackDamageForce(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDamageForce];
}

int NPCChaserGetAttackDamageType(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDamageType];
}

float NPCChaserGetAttackDamageDelay(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDamageDelay];
}

float NPCChaserGetAttackRange(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackRange];
}

float NPCChaserGetAttackDuration(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackDuration];
}

float NPCChaserGetAttackSpread(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackSpread];
}

float NPCChaserGetAttackBeginRange(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackBeginRange];
}

float NPCChaserGetAttackBeginFOV(int iNPCIndex,int iAttackIndex)
{
	return g_NPCBaseAttacks[iNPCIndex][iAttackIndex][SF2NPCChaser_BaseAttackBeginFOV];
}

int NPCSetCurrentAttackIndex(int iNPCIndex, int iAttackIndex)
{
	g_iNPCCurrentAttackIndex[iNPCIndex] = iAttackIndex;
}


int NPCGetCurrentAttackIndex(int iNPCIndex)
{
	return g_iNPCCurrentAttackIndex[iNPCIndex];
}

bool NPCChaserIsStunEnabled(int iNPCIndex)
{
	return g_bNPCStunEnabled[iNPCIndex];
}

bool NPCChaserIsStunByFlashlightEnabled(int iNPCIndex)
{
	return g_bNPCStunFlashlightEnabled[iNPCIndex];
}

bool NPCChaseHasKeyDrop(int iNPCIndex)
{
	return g_bNPCHasKeyDrop[iNPCIndex];
}

float NPCChaserGetStunFlashlightDamage(int iNPCIndex)
{
	return g_flNPCStunFlashlightDamage[iNPCIndex];
}

float NPCChaserGetStunDuration(int iNPCIndex)
{
	return g_flNPCStunDuration[iNPCIndex];
}

float NPCChaserGetStunCooldown(int iNPCIndex)
{
	return g_flNPCStunDuration[iNPCIndex];
}

float NPCChaserGetStunHealth(int iNPCIndex)
{
	return g_flNPCStunHealth[iNPCIndex];
}

void NPCChaserSetStunHealth(int iNPCIndex, float flAmount)
{
	g_flNPCStunHealth[iNPCIndex] = flAmount;
}

void NPCChaserSetStunInitialHealth(int iNPCIndex, float flAmount)
{
	g_flNPCStunInitialHealth[iNPCIndex] = flAmount;
}

void NPCChaserAddStunHealth(int iNPCIndex, float flAmount)
{
	if (GetGameTime() >= g_flSlenderNextStunTime[iNPCIndex])
	{
		NPCChaserSetStunHealth(iNPCIndex, NPCChaserGetStunHealth(iNPCIndex) + flAmount);
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_STUN,0,"Boss %i, new amount: %0.0f",iNPCIndex,NPCChaserGetStunHealth(iNPCIndex));
#endif
	}
}

float NPCChaserGetStunInitialHealth(int iNPCIndex)
{
	return g_flNPCStunInitialHealth[iNPCIndex];
}

int NPCChaserGetState(int iNPCIndex)
{
	return g_iNPCState[iNPCIndex];
}

void NPCChaserSetState(int iNPCIndex,int iState)
{
	g_iNPCState[iNPCIndex] = iState;
}

int NPCChaserGetMovementActivity(int iNPCIndex)
{
	return g_iNPCMovementActivity[iNPCIndex];
}

int NPCChaserSetMovementActivity(int iNPCIndex,int iMovementActivity)
{
	g_iNPCMovementActivity[iNPCIndex] = iMovementActivity;
}

int NPCChaserOnSelectProfile(int iNPCIndex)
{
	int iUniqueProfileIndex = NPCGetUniqueProfileIndex(iNPCIndex);

	g_flNPCWakeRadius[iNPCIndex] = GetChaserProfileWakeRadius(iUniqueProfileIndex);
	g_flNPCStepSize[iNPCIndex] = GetChaserProfileStepSize(iUniqueProfileIndex);
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = GetChaserProfileWalkSpeed(iUniqueProfileIndex, iDifficulty);
		g_flNPCAirSpeed[iNPCIndex][iDifficulty] = GetChaserProfileAirSpeed(iUniqueProfileIndex, iDifficulty);
		
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = GetChaserProfileMaxWalkSpeed(iUniqueProfileIndex, iDifficulty);
		g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty] = GetChaserProfileMaxAirSpeed(iUniqueProfileIndex, iDifficulty);
	}
	
	g_NPCBaseAttacksCount[iNPCIndex] = GetChaserProfileAttackCount(iUniqueProfileIndex);
	// Get attack data.
	for (int i = 0; i < g_NPCBaseAttacksCount[iNPCIndex]; i++)
	{
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackType] = GetChaserProfileAttackType(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamage] = GetChaserProfileAttackDamage(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageVsProps] = GetChaserProfileAttackDamageVsProps(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageForce] = GetChaserProfileAttackDamageForce(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageType] = GetChaserProfileAttackDamageType(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageDelay] = GetChaserProfileAttackDamageDelay(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackRange] = GetChaserProfileAttackRange(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDuration] = GetChaserProfileAttackDuration(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackSpread] = GetChaserProfileAttackSpread(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackBeginRange] = GetChaserProfileAttackBeginRange(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackBeginFOV] = GetChaserProfileAttackBeginFOV(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackCooldown] = GetChaserProfileAttackCooldown(iUniqueProfileIndex, i);
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackNextAttackTime] = -1.0;
	}
	// Get stun data.
	g_bNPCStunEnabled[iNPCIndex] = GetChaserProfileStunState(iUniqueProfileIndex);
	g_flNPCStunDuration[iNPCIndex] = GetChaserProfileStunDuration(iUniqueProfileIndex);
	g_flNPCStunCooldown[iNPCIndex] = GetChaserProfileStunCooldown(iUniqueProfileIndex);
	g_bNPCStunFlashlightEnabled[iNPCIndex] = GetChaserProfileStunFlashlightState(iUniqueProfileIndex);
	g_flNPCStunFlashlightDamage[iNPCIndex] = GetChaserProfileStunFlashlightDamage(iUniqueProfileIndex);
	g_flNPCStunInitialHealth[iNPCIndex] = GetChaserProfileStunHealth(iUniqueProfileIndex);
	
	//Get Key Data
	g_bNPCHasKeyDrop[iNPCIndex] = GetChaserProfileKeyDrop(iUniqueProfileIndex);
	
	float fStunHealthPerPlayer = GetChaserProfileStunHealthPerPlayer(iUniqueProfileIndex);
	int count;
	for(int iClient;iClient<=MaxClients;iClient++)
		if(IsValidClient(iClient) && g_bPlayerEliminated[iClient])
			count++;
	fStunHealthPerPlayer *= float(count);
	g_flNPCStunInitialHealth[iNPCIndex] += fStunHealthPerPlayer;
	
	NPCChaserSetStunHealth(iNPCIndex, NPCChaserGetStunInitialHealth(iNPCIndex));
}

void NPCChaserOnRemoveProfile(int iNPCIndex)
{
	NPCChaserResetValues(iNPCIndex);
}

/**
 *	Resets all global variables on a specified NPC. Usually this should be done last upon removing a boss from the game.
 */
static void NPCChaserResetValues(int iNPCIndex)
{
	g_flNPCWakeRadius[iNPCIndex] = 0.0;
	g_flNPCStepSize[iNPCIndex] = 0.0;
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCWalkSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCAirSpeed[iNPCIndex][iDifficulty] = 0.0;
		
		g_flNPCMaxWalkSpeed[iNPCIndex][iDifficulty] = 0.0;
		g_flNPCMaxAirSpeed[iNPCIndex][iDifficulty] = 0.0;
	}
	
	// Clear attack data.
	for (int i = 0; i < SF2_CHASER_BOSS_MAX_ATTACKS; i++)
	{
		// Base attack data.
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackType] = SF2BossAttackType_Invalid;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamage] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageVsProps] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageForce] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageType] = 0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDamageDelay] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackRange] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackDuration] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackSpread] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackBeginRange] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackBeginFOV] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackCooldown] = 0.0;
		g_NPCBaseAttacks[iNPCIndex][i][SF2NPCChaser_BaseAttackNextAttackTime] = -1.0;
	}
	
	g_bNPCStunEnabled[iNPCIndex] = false;
	g_flNPCStunDuration[iNPCIndex] = 0.0;
	g_flNPCStunCooldown[iNPCIndex] = 0.0;
	g_bNPCStunFlashlightEnabled[iNPCIndex] = false;
	g_flNPCStunInitialHealth[iNPCIndex] = 0.0;
	
	NPCChaserSetStunHealth(iNPCIndex, 0.0);
	
	g_iNPCState[iNPCIndex] = -1;
	g_iNPCMovementActivity[iNPCIndex] = -1;
}

static int g_iSlenderOldState[MAX_BOSSES];
static float g_flLastPos[MAX_BOSSES][3];
static float g_flLastStuckTime[MAX_BOSSES];

void Spawn_Chaser(int iBossIndex)
{
	g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
	g_flLastStuckTime[iBossIndex] = 0.0;
	g_iSlenderOldState[iBossIndex] = STATE_IDLE;
}

//	So this is how the thought process of the bosses should go.
//	1. Search for enemy; either by sight or by sound.
//		- Any noticeable sounds should be investigated.
//		- Too many sounds will put me in alert mode.
//	2. Alert of an enemy; I saw something or I heard something unusual
//		- Go to the position where I last heard the sound.
//		- Keep on searching until I give up. Then drop back to idle mode.
//	3. Found an enemy! Give chase!
//		- Keep on chasing until enemy is killed or I give up.
//			- Keep a path in memory as long as I still have him in my sights.
//			- If I lose sight or I'm unable to traverse safely, find paths around obstacles and follow memorized path.
//			- If I reach the end of my path and I still don't see him and I still want to pursue him, keep on going in the direction I'm going.

stock bool IsTargetValidForSlender(int iTarget, bool bIncludeEliminated=false)
{
	if (!iTarget || !IsValidEntity(iTarget)) return false;
	
	if (IsValidClient(iTarget))
	{
		if (!IsClientInGame(iTarget) || 
			!IsPlayerAlive(iTarget) || 
			IsClientInDeathCam(iTarget) || 
			(!bIncludeEliminated && g_bPlayerEliminated[iTarget]) ||
			IsClientInGhostMode(iTarget) || 
			DidClientEscape(iTarget)) return false;
	}
	
	return true;
}

public Action Timer_DeathPosChaseStop(Handle timer, int iBossIndex)
{
	if (!g_bEnabled)
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	if (timer != g_hBossFailSafeTimer[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}
	
	if (!g_bSlenderChaseDeathPosition[iBossIndex])
	{
		g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
		g_bSlenderGiveUp[iBossIndex] = true;
		return Plugin_Stop;
	}
	
	g_bSlenderChaseDeathPosition[iBossIndex] = false;
	g_bSlenderGiveUp[iBossIndex] = true;
	g_hBossFailSafeTimer[iBossIndex] = INVALID_HANDLE;
	return Plugin_Continue;
}

public Action Timer_SlenderChaseBossThink(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderEntityThink[iBossIndex]) return Plugin_Stop;
	
	if (NPCGetFlags(iBossIndex) & SFF_MARKEDASFAKE) return Plugin_Stop;
	
	//CTFBaseBoss doesn't call CBaseCombatCharacter::UpdateLastKnownArea automaticly, manually call it so we can use SDK_GetLastKnownArea on the boss.
	SDK_UpdateLastKnownArea(slender);
	
	/*int iCurrentSequence = GetEntProp(slender, Prop_Send, "m_nSequence");
	if (iCurrentSequence != g_iNPCCurrentAnimationSequence[iBossIndex])
	{
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "Boss %i, changed automaticly animation sequence old:%i new:%i (Fixing...)",iBossIndex, g_iNPCCurrentAnimationSequence[iBossIndex], iCurrentSequence);
#endif
		g_iNPCCurrentAnimationSequence[iBossIndex] = EntitySetAnimation(slender, "", g_bNPCCurrentAnimationSequenceIsLooped[iBossIndex], g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex], g_iNPCCurrentAnimationSequence[iBossIndex]);
	}*/
	
	/*float flPlaybackRate = GetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate");
	if (flPlaybackRate != g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex])
	{
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "Boss %i, changed automaticly playback rate old:%f new:%f (Fixing...)",iBossIndex, g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex], flPlaybackRate);
#endif
		SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", g_flNPCCurrentAnimationSequencePlaybackRate[iBossIndex]);
	}*/
	
	float flSlenderVelocity[3], flMyPos[3], flMyEyeAng[3];
	float flBuffer[3];
	
	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));
	
	GetEntPropVector(slender, Prop_Data, "m_vecAbsVelocity", flSlenderVelocity);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng);
	for (int i = 0; i < 3; i++) flMyEyeAng[i] = AngleNormalize(flMyEyeAng[i]);
	
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	float flOriginalSpeed = NPCGetSpeed(iBossIndex, iDifficulty);
	float flOriginalWalkSpeed = NPCChaserGetWalkSpeed(iBossIndex, iDifficulty);
	float flOriginalAirSpeed = NPCChaserGetAirSpeed(iBossIndex, iDifficulty);
	float flMaxSpeed = NPCGetMaxSpeed(iBossIndex, iDifficulty);
	float flMaxWalkSpeed = NPCChaserGetMaxWalkSpeed(iBossIndex, iDifficulty);
	float flMaxAirSpeed = NPCChaserGetMaxAirSpeed(iBossIndex, iDifficulty);
	
	if (g_bProxySurvivalRageMode)
	{
		flOriginalSpeed *= 1.25;
		flOriginalWalkSpeed *= 1.25;
		flOriginalAirSpeed *= 1.25;
		flMaxSpeed *= 1.25;
		flMaxWalkSpeed *= 1.25;
		flMaxAirSpeed *= 1.25;
	}
	
	float flSpeed = flOriginalSpeed * NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier;
	if (flSpeed < flOriginalSpeed) flSpeed = flOriginalSpeed;
	if (flSpeed > flMaxSpeed) flSpeed = flMaxSpeed;
	
	float flWalkSpeed = flOriginalWalkSpeed * NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier;
	if (flWalkSpeed < flOriginalWalkSpeed) flWalkSpeed = flOriginalWalkSpeed;
	if (flWalkSpeed > flMaxWalkSpeed) flWalkSpeed = flMaxWalkSpeed;
	
	float flAirSpeed = flOriginalAirSpeed * NPCGetAnger(iBossIndex) * g_flRoundDifficultyModifier;
	if (flAirSpeed < flOriginalAirSpeed) flAirSpeed = flOriginalAirSpeed;
	if (flAirSpeed > flMaxAirSpeed) flAirSpeed = flMaxAirSpeed;
	
	//It seems change air speed on difficulty level is a bad idea
	flAirSpeed = NPCChaserGetAirSpeed(iBossIndex, iDifficulty);
	
	if (PeopleCanSeeSlender(iBossIndex, _, false))
	{
		if (NPCHasAttribute(iBossIndex, "reduced speed on look"))
		{
			flSpeed *= NPCGetAttributeValue(iBossIndex, "reduced speed on look");
		}
		
		if (NPCHasAttribute(iBossIndex, "reduced walk speed on look"))
		{
			flWalkSpeed *= NPCGetAttributeValue(iBossIndex, "reduced walk speed on look");
		}
		
		if (NPCHasAttribute(iBossIndex, "reduced air speed on look"))
		{
			flAirSpeed *= NPCGetAttributeValue(iBossIndex, "reduced air speed on look");
		}
	}
	Action fAction = Plugin_Continue;
	float flForwardSpeed = flWalkSpeed;
	Call_StartForward(fOnBossGetWalkSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flWalkSpeed = flForwardSpeed;
	
	fAction = Plugin_Continue;
	flForwardSpeed = flSpeed;
	Call_StartForward(fOnBossGetSpeed);
	Call_PushCell(iBossIndex);
	Call_PushFloatRef(flForwardSpeed);
	Call_Finish(fAction);
	if (fAction == Plugin_Changed)
		flSpeed = flForwardSpeed;
	
	g_flSlenderCalculatedWalkSpeed[iBossIndex] = flWalkSpeed;
	g_flSlenderCalculatedSpeed[iBossIndex] = flSpeed;
	g_flSlenderCalculatedAirSpeed[iBossIndex] = flAirSpeed;
	
	int iOldState = g_iSlenderState[iBossIndex];
	int iOldTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	
	int iBestNewTarget = INVALID_ENT_REFERENCE;
	float flSearchRange = NPCGetSearchRadius(iBossIndex);
	float flBestNewTargetDist = flSearchRange;
	int iState = iOldState;
	
	bool bPlayerInFOV[MAXPLAYERS + 1];
	bool bPlayerNear[MAXPLAYERS + 1];
	float flPlayerDists[MAXPLAYERS + 1];
	bool bPlayerVisible[MAXPLAYERS + 1];
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	bool bStunEnabled = NPCChaserIsStunEnabled(iBossIndex);
	
	float flSlenderMins[3], flSlenderMaxs[3];
	GetEntPropVector(slender, Prop_Send, "m_vecMins", flSlenderMins);
	GetEntPropVector(slender, Prop_Send, "m_vecMaxs", flSlenderMaxs);
	
	float flTraceMins[3], flTraceMaxs[3];
	flTraceMins[0] = flSlenderMins[0];
	flTraceMins[1] = flSlenderMins[1];
	flTraceMins[2] = 0.0;
	flTraceMaxs[0] = flSlenderMaxs[0];
	flTraceMaxs[1] = flSlenderMaxs[1];
	flTraceMaxs[2] = 0.0;
	
	char strClass[32];
	
	bool bBuilding = false;
	if(iOldTarget > MaxClients)
	{
		GetEdictClassname(iOldTarget, strClass, sizeof(strClass));
		if(strcmp(strClass, "obj_sentrygun") == 0 && !GetEntProp(iOldTarget, Prop_Send, "m_bCarried"))
		{
			bBuilding = true;
		}
	}
	// Gather data about the players around me and get the best new target, in case my old target is invalidated.
	for (int i = 1, iMaxEntities = GetMaxEntities(); i <= iMaxEntities; i++)
	{
		float flDist;
		float flTraceStartPos[3], flTraceEndPos[3];
		NPCGetEyePosition(iBossIndex, flTraceStartPos);
		
		if (i > MaxClients)
		{
			if(IsValidEntity(i))
			{
				GetEdictClassname(i, strClass, sizeof(strClass));
				if(strcmp(strClass, "obj_sentrygun") == 0 && !GetEntProp(i, Prop_Send, "m_bCarried"))
				{
					GetEntPropVector(i, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
					Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
					flTraceEndPos,
					flTraceMins,
					flTraceMaxs,
					MASK_NPCSOLID,
					TraceRayBossVisibility,
					slender);
					
					bool bIsVisible = !TR_DidHit(hTrace);
					int iTraceHitEntity = TR_GetEntityIndex(hTrace);
					CloseHandle(hTrace);
					
					if (!bIsVisible && iTraceHitEntity == i) bIsVisible = true;
					
					if (bIsVisible)
					{
						// FOV check.
						SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
						GetVectorAngles(flBuffer, flBuffer);
						
						if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) > (NPCGetFOV(iBossIndex) * 0.5))
						{
							bIsVisible = false;
						}
					}
					if (bIsVisible)
					{
						flDist = GetVectorDistance(flTraceStartPos, flTraceEndPos);
						if (flDist < flBestNewTargetDist)
						{
							iBestNewTarget = i;
							flBestNewTargetDist = flDist;
							bBuilding = true;
							g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
						}
					}
				}
			}
			continue;
		}
		
		if (!IsTargetValidForSlender(i, bAttackEliminated)) continue;
		
		GetClientEyePosition(i, flTraceEndPos);
		
		Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
			flTraceEndPos,
			flTraceMins,
			flTraceMaxs,
			MASK_NPCSOLID,
			TraceRayBossVisibility,
			slender);
		
		bool bIsVisible = !TR_DidHit(hTrace);
		int iTraceHitEntity = TR_GetEntityIndex(hTrace);
		CloseHandle(hTrace);
		
		if (!bIsVisible && iTraceHitEntity == i) bIsVisible = true;
		
		bPlayerVisible[i] = bIsVisible;
		
		// Near radius check.
		if (bIsVisible &&
			GetVectorDistance(flTraceStartPos, flTraceEndPos) <= NPCChaserGetWakeRadius(iBossIndex))
		{
			bPlayerNear[i] = true;
		}
		if (bIsVisible && SF_SpecialRound(SPECIALROUND_BOO) && GetVectorDistance(flTraceEndPos, flTraceStartPos) < SPECIALROUND_BOO_DISTANCE)
			TF2_StunPlayer(i, SPECIALROUND_BOO_DURATION, _, TF_STUNFLAGS_GHOSTSCARE);
		// FOV check.
		SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
		GetVectorAngles(flBuffer, flBuffer);
		
		if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) <= (NPCGetFOV(iBossIndex) * 0.5))
		{
			bPlayerInFOV[i] = true;
		}
		
		float flPriorityValue = g_iPageMax > 0 ? (float(g_iPlayerPageCount[i]) / float(g_iPageMax)) : 0.0;
		
		if (TF2_GetPlayerClass(i) == TFClass_Medic)
			flPriorityValue += 0.72;
		else if (g_bPlayerHasRegenerationItem[i])
			flPriorityValue += 0.2;
		
		flDist = GetVectorDistance(flTraceStartPos, flTraceEndPos);
		flPlayerDists[i] = flDist;
		
		if ((bPlayerNear[i] && iState != STATE_CHASE && iState != STATE_ALERT) || (bIsVisible && bPlayerInFOV[i]))
		{
			float flTargetPos[3];
			GetClientAbsOrigin(i, flTargetPos);
			
			if (flDist <= flSearchRange)
			{
				// Subtract distance to increase priority.
				flDist -= (flDist * flPriorityValue);
				
				if (flDist < flBestNewTargetDist)
				{
					iBestNewTarget = i;
					flBestNewTargetDist = flDist;
					g_iSlenderInterruptConditions[iBossIndex] |= COND_SAWENEMY;
				}
				
				g_flSlenderLastFoundPlayer[iBossIndex][i] = GetGameTime();
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][0] = flTargetPos[0];
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][1] = flTargetPos[1];
				g_flSlenderLastFoundPlayerPos[iBossIndex][i][2] = flTargetPos[2];
			}
		}
	}
	
	bool bInFlashlight = false;
	
	// Check to see if someone is facing at us with flashlight on. Only if I'm facing them too. BLINDNESS!
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsTargetValidForSlender(i, bAttackEliminated)) continue;
	
		if (!IsClientUsingFlashlight(i) || !bPlayerInFOV[i]) continue;
		
		float flTraceStartPos[3], flTraceEndPos[3];
		GetClientEyePosition(i, flTraceStartPos);
		NPCGetEyePosition(iBossIndex, flTraceEndPos);
		
		if (GetVectorDistance(flTraceStartPos, flTraceEndPos) <= SF2_FLASHLIGHT_LENGTH)
		{
			float flEyeAng[3], flRequiredAng[3];
			GetClientEyeAngles(i, flEyeAng);
			SubtractVectors(flTraceEndPos, flTraceStartPos, flRequiredAng);
			GetVectorAngles(flRequiredAng, flRequiredAng);
			
			if ((FloatAbs(AngleDiff(flEyeAng[0], flRequiredAng[0])) + FloatAbs(AngleDiff(flEyeAng[1], flRequiredAng[1]))) <= 45.0)
			{
				Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos,
					flTraceEndPos,
					MASK_PLAYERSOLID,
					RayType_EndPoint,
					TraceRayBossVisibility,
					slender);
					
				bool bDidHit = TR_DidHit(hTrace);
				CloseHandle(hTrace);
				
				if (!bDidHit)
				{
					bInFlashlight = true;
					break;
				}
			}
		}
	}
	
	// Damage us if we're in a flashlight.
	if (bInFlashlight)
	{
		if (bStunEnabled)
		{
			if (NPCChaserIsStunByFlashlightEnabled(iBossIndex))
			{
				if (NPCChaserGetStunHealth(iBossIndex) > 0)
				{
					NPCChaserAddStunHealth(iBossIndex, -NPCChaserGetStunFlashlightDamage(iBossIndex));
				}
			}
		}
	}
	
	// Process the target that we should have.
	int iTarget = iOldTarget;
	
	/*
	if (IsValidEdict(iBestNewTarget))
	{
		iTarget = iBestNewTarget;
		g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
	}
	*/
	
	if (iTarget && iTarget != INVALID_ENT_REFERENCE)
	{
		if (!IsTargetValidForSlender(iTarget, bAttackEliminated))
		{
			// Clear our target; he's not valid anymore.
			iOldTarget = iTarget;
			iTarget = INVALID_ENT_REFERENCE;
			g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
		}
	}
	else
	{
		// Clear our target; he's not valid anymore.
		iOldTarget = iTarget;
		iTarget = INVALID_ENT_REFERENCE;
		g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	}
	
	//We should never give up, but sometimes it happens.
	if(g_bSlenderGiveUp[iBossIndex])
	{
		//Damit our target is unreachable for some unexplained reasons, haaaaaaaaaaaa!
		iState = STATE_IDLE;
		g_bSlenderGiveUp[iBossIndex] = false;
		
		if(SF_IsRaidMap() && !(NPCGetFlags(iBossIndex) & SFF_NOTELEPORT))
			RemoveSlender(iBossIndex);
	}
	
	int iInterruptConditions = g_iSlenderInterruptConditions[iBossIndex];
	bool bDoChasePersistencyInit = false;
	
	if(SF_IsRaidMap() && !g_bSlenderGiveUp[iBossIndex] && !bBuilding)
	{
		if(!IsValidClient(iTarget) || (IsValidClient(iTarget) && g_bPlayerEliminated[iTarget]))
		{
			if(iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				Handle hArrayRaidTargets = CreateArray();
					
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) ||
						!IsPlayerAlive(i) ||
						g_bPlayerEliminated[i] ||
						IsClientInGhostMode(i) ||
						DidClientEscape(i))
					{
						continue;
					}
					PushArrayCell(hArrayRaidTargets, i);
				}
				if(GetArraySize(hArrayRaidTargets)>0)
				{
					int iRaidTarget = GetArrayCell(hArrayRaidTargets,GetRandomInt(0, GetArraySize(hArrayRaidTargets) - 1));
					if(IsValidClient(iRaidTarget) && !g_bPlayerEliminated[iRaidTarget])
					{
						iBestNewTarget = iRaidTarget;
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration");
						iState = STATE_CHASE;
						iTarget = iBestNewTarget;
					}
				}
				
				CloseHandle(hArrayRaidTargets);
			}
		}
		
	}
	// Process which state we should be in.
	switch (iState)
	{
		case STATE_IDLE, STATE_WANDER:
		{
			for (int i = 0;i < MAX_NPCTELEPORTER;i++)
			{
				if (NPCChaserGetTeleporter(iBossIndex,i) != INVALID_ENT_REFERENCE)
					NPCChaserSetTeleporter(iBossIndex,i,INVALID_ENT_REFERENCE);
			}
			if (iState == STATE_WANDER)
			{
				if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid())
				{
					iState = STATE_IDLE;
				}
			}
			else
			{
				if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex] && GetRandomFloat(0.0, 1.0) <= 0.25)
				{
					iState = STATE_WANDER;
				}
			}
			if (SF_SpecialRound(SPECIALROUND_BEACON))
			{
				if(!g_bSlenderInBacon[iBossIndex])
				{
					iState = STATE_ALERT;
					g_bSlenderInBacon[iBossIndex] = true;
				}
			}
			if (iInterruptConditions & COND_SAWENEMY)
			{
				// I saw someone over here. Automatically put me into alert mode.
				iState = STATE_ALERT;
			}
			else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
			{
				// Sound counts:
				// +1 will be added if it hears a footstep.
				// +2 will be added if the footstep is someone sprinting.
				// +5 will be added if the sound is from a player's weapon hitting an object.
				// +10 will be added if a voice command is heard.
				//
				// Sound counts will be reset after the boss hears a sound after a certain amount of time.
				// The purpose of sound counts is to induce boss focusing on sounds suspicious entities are making.
				
				int iCount = 0;
				if (iInterruptConditions & COND_HEARDFOOTSTEP) iCount += 1;
				if (iInterruptConditions & COND_HEARDFOOTSTEPLOUD) iCount += 2;
				if (iInterruptConditions & COND_HEARDWEAPON) iCount += 5;
				if (iInterruptConditions & COND_HEARDVOICE) iCount += 10;
				
				bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
				
				if (GetVectorDistance(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0) ||
					bDiscardMasterPos)
				{
					if (bDiscardMasterPos) g_iSlenderTargetSoundCount[iBossIndex] = 0;
					
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
					g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
					g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
					g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
					g_iSlenderTargetSoundCount[iBossIndex] += iCount;
				}
				
				if (g_iSlenderTargetSoundCount[iBossIndex] >= GetProfileNum(sSlenderProfile, "search_sound_count_until_alert", 4))
				{
					// Someone's making some noise over there! Time to investigate.
					g_bSlenderInvestigatingSound[iBossIndex] = true; // This is just so that our sound position would be the goal position.
					iState = STATE_ALERT;
				}
			}
		}
		case STATE_ALERT:
		{
			if (iState == STATE_ALERT)
			{
				if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid() && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				{
					iState = STATE_IDLE;
				}
			}
			if (GetGameTime() >= g_flSlenderTimeUntilIdle[iBossIndex])
			{
				iState = STATE_IDLE;
			}
			else if (IsValidClient(iBestNewTarget))
			{
				if (GetGameTime() >= g_flSlenderTimeUntilChase[iBossIndex] || bPlayerNear[iBestNewTarget])
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					
					if (IsValidClient(iBestNewTarget)) GetClientEyePosition(iBestNewTarget, flTraceEndPos);
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iBestNewTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++) flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
						flTraceEndPos,
						flTraceMins,
						flTraceMaxs,
						MASK_NPCSOLID,
						TraceRayBossVisibility,
						slender);
						
					bool bIsVisible = !TR_DidHit(hTrace);
					int iTraceHitEntity = TR_GetEntityIndex(hTrace);
					CloseHandle(hTrace);
					
					if (!bIsVisible && iTraceHitEntity == iBestNewTarget) bIsVisible = true;
					
					if ((bPlayerNear[iBestNewTarget] || bPlayerInFOV[iBestNewTarget]) && bPlayerVisible[iBestNewTarget])
					{
						// AHAHAHAH! I GOT YOU NOW!
						iTarget = iBestNewTarget;
						g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
						iState = STATE_CHASE;
					}
				}
			}
			if ((iTarget > MaxClients && bBuilding))
			{
				iState = STATE_CHASE;
			}
			else
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidClient(iBestNewTarget))
					{
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderLastFoundPlayerPos[iBossIndex][iBestNewTarget][2];
					}
				}
				else if (iInterruptConditions & COND_HEARDSUSPICIOUSSOUND)
				{
					bool bDiscardMasterPos = view_as<bool>(GetGameTime() >= g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex]);
					
					if (GetVectorDistance(g_flSlenderTargetSoundTempPos[iBossIndex], g_flSlenderTargetSoundMasterPos[iBossIndex]) <= GetProfileFloat(sSlenderProfile, "search_sound_pos_dist_tolerance", 512.0) ||
						bDiscardMasterPos)
					{
						g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_sound_pos_discard_time", 2.0);
						g_flSlenderTargetSoundMasterPos[iBossIndex][0] = g_flSlenderTargetSoundTempPos[iBossIndex][0];
						g_flSlenderTargetSoundMasterPos[iBossIndex][1] = g_flSlenderTargetSoundTempPos[iBossIndex][1];
						g_flSlenderTargetSoundMasterPos[iBossIndex][2] = g_flSlenderTargetSoundTempPos[iBossIndex][2];
						
						// We have to manually set the goal position here because the goal position will not be changed due to no change in state.
						g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
						g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
						g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
						
						g_bSlenderInvestigatingSound[iBossIndex] = true;
					}
				}
				
				for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
				{
					if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged) continue;
					
					bool bBlockingProp = false;
					
					if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
					{
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
					}
					
					if (bBlockingProp)
					{
						iState = STATE_ATTACK;
						NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
						break;
					}
				}
			}
		}
		case STATE_CHASE, STATE_ATTACK, STATE_STUN:
		{
			if (iState == STATE_CHASE)
			{
				if (IsValidEdict(iTarget))
				{
					float flTraceStartPos[3], flTraceEndPos[3];
					NPCGetEyePosition(iBossIndex, flTraceStartPos);
					
					if (IsValidClient(iTarget))
					{
						GetClientEyePosition(iTarget, flTraceEndPos);
					}
					else
					{
						float flTargetMins[3], flTargetMaxs[3];
						GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
						GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTraceEndPos);
						for (int i = 0; i < 3; i++) flTraceEndPos[i] += ((flTargetMins[i] + flTargetMaxs[i]) / 2.0);
					}
					
					bool bIsDeathPosVisible = false;
					
					if (g_bSlenderChaseDeathPosition[iBossIndex])
					{
						Handle hTrace = TR_TraceRayFilterEx(flTraceStartPos,
							g_flSlenderChaseDeathPosition[iBossIndex],
							MASK_NPCSOLID,
							RayType_EndPoint,
							TraceRayBossVisibility,
							slender);
						bIsDeathPosVisible = !TR_DidHit(hTrace);
						CloseHandle(hTrace);
					}
					
					if (iTarget <= MaxClients && !bPlayerVisible[iTarget])
					{
						if (GetGameTime() >= g_flSlenderTimeUntilAlert[iBossIndex])
						{
							iState = STATE_ALERT;
						}
						else if (bIsDeathPosVisible)
						{
							iState = STATE_IDLE;
						}
						GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
					}
					else
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false;	// We're not chasing a dead player after all! Reset.
					
						float flAttackDirection[3];
						if (0 < iTarget <= MaxClients)
							GetClientAbsOrigin(iTarget, g_flSlenderGoalPos[iBossIndex]);
						else if (iTarget > MaxClients)
							GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
						SubtractVectors(g_flSlenderGoalPos[iBossIndex], flMyPos, flAttackDirection);
						GetVectorAngles(flAttackDirection, flAttackDirection);
						
						float flAttackBeginRangeEx, flAttackBeginFOVEx;
						float flDist = GetVectorDistance(g_flSlenderGoalPos[iBossIndex], flMyPos);
						float flFov = (FloatAbs(AngleDiff(flAttackDirection[0], flMyEyeAng[0])) + FloatAbs(AngleDiff(flAttackDirection[1], flMyEyeAng[1])));
						for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
						{
							flAttackBeginRangeEx = NPCChaserGetAttackBeginRange(iBossIndex, iAttackIndex);
							flAttackBeginFOVEx = NPCChaserGetAttackBeginFOV(iBossIndex, iAttackIndex);
							if (flDist <= flAttackBeginRangeEx && flFov <= (flAttackBeginFOVEx / 2.0))
							{
								// ENOUGH TALK! HAVE AT YOU!
								iState = STATE_ATTACK;
								NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
								break;
							}
						}
					}
					if (iState == STATE_CHASE)
					{
						for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
						{
							if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged) continue;
							
							bool bBlockingProp = false;
							
							if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
							{
								bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
							}
							
							if (bBlockingProp)
							{
								iState = STATE_ATTACK;
								NPCSetCurrentAttackIndex(iBossIndex, iAttackIndex);
								break;
							}
						}
					}
				}
				if (!IsValidEdict(iTarget) || (0 < iTarget <= MaxClients && DidClientEscape(iTarget)))
				{
					if (g_hBossFailSafeTimer[iBossIndex] == INVALID_HANDLE)
						g_hBossFailSafeTimer[iBossIndex] = CreateTimer(5.0, Timer_DeathPosChaseStop, iBossIndex); //Setup a fail safe timer in case we can't finish our path.
					// Even if the target isn't valid anymore, see if I still have some ways to go on my current path,
					// because I shouldn't actually know that the target has died until I see it.
					if (!g_hBossChaserPathLogic[iBossIndex].IsPathValid())
					{
						iState = STATE_IDLE;
					}
				}
			}
			else if (iState == STATE_ATTACK)
			{
				if (!g_bSlenderAttacking[iBossIndex] || (g_flSlenderTimeUntilAttackEnd[iBossIndex] != -1.0 && g_flSlenderTimeUntilAttackEnd[iBossIndex] <= GetGameTime()))
				{
					if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					g_flSlenderTimeUntilAttackEnd[iBossIndex] = -1.0;
					if (IsValidClient(iTarget))
					{
						g_bSlenderChaseDeathPosition[iBossIndex] = false;
						
						// Chase him again!
						g_bSlenderGiveUp[iBossIndex] = false;
						iState = STATE_CHASE;
					}
					else
					{
						// Target isn't valid anymore. We killed him, Mac!
						iState = STATE_ALERT;
					}
				}
			}
			else if (iState == STATE_STUN)
			{
				if (GetGameTime() >= g_flSlenderTimeUntilRecover[iBossIndex])
				{
					NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
					g_flSlenderNextStunTime[iBossIndex] = GetGameTime()+NPCChaserGetStunCooldown(iBossIndex);
					if (IsValidClient(iTarget))
					{
						// Chase him again!
						iState = STATE_CHASE;
					}
					else
					{
						// WHAT DA FUUUUUUUUUUUQ. TARGET ISN'T VALID. AUSDHASUIHD
						iState = STATE_ALERT;
					}
				}
			}
		}
	}
	
	if (iState != STATE_STUN)
	{
		if (bStunEnabled)
		{
			if (NPCChaserGetStunHealth(iBossIndex) <= 0 && g_flSlenderNextStunTime[iBossIndex] <= GetGameTime())
			{
				if (iState != STATE_CHASE && iState != STATE_ATTACK)
				{
					// Sometimes players can stun the boss while it's not in chase mode. If that happens, we
					// need to set the persistency value to the chase initial value.
					bDoChasePersistencyInit = true;
				}
				iState = STATE_STUN;
				if (NPCChaseHasKeyDrop(iBossIndex))
				{
					NPC_DropKey(iBossIndex);
				}
			}
		}
	}
	
	if (!IsValidClient(iTarget) && g_bSlenderTeleportTargetIsCamping[iBossIndex] && g_iSlenderTeleportTarget[iBossIndex] != INVALID_ENT_REFERENCE) //We spawned, and our target is a camper kill him!
	{
		int iCampingTarget = EntRefToEntIndex(g_iSlenderTeleportTarget[iBossIndex]);
		if (MaxClients >= iCampingTarget > 0 && IsTargetValidForSlender(iCampingTarget))
		{
			g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iCampingTarget);
			iState = STATE_CHASE;
		}
		g_bSlenderTeleportTargetIsCamping[iBossIndex] = false;
	}
	
	//In Raid maps the boss should always attack the target. 
	if (SF_IsRaidMap() && iState != STATE_ATTACK && iState != STATE_STUN && IsValidClient(iTarget) && !g_bSlenderGiveUp[iBossIndex])
	{
		g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration");
		iState = STATE_CHASE;
	}
	// Finally, set our new state.
	g_iSlenderState[iBossIndex] = iState;
	
	if (iOldState != iState)
	{
		g_hBossChaserPathLogic[iBossIndex].ClearPath();
		
		switch (iState)
		{
			case STATE_IDLE, STATE_WANDER:
			{
				g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
				g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
				g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
				g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				
				if (iOldState != STATE_IDLE && iOldState != STATE_WANDER)
				{
					g_iSlenderTargetSoundCount[iBossIndex] = 0;
					g_bSlenderInvestigatingSound[iBossIndex] = false;
					g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = -1.0;
					
					g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "idle_lifetime", 10.0);
				}
				
				if (iState == STATE_WANDER)
				{
					// Force new wander position.
					g_flSlenderNextWanderPos[iBossIndex] = -1.0;
				}
			}
			
			case STATE_ALERT:
			{
				g_bSlenderGiveUp[iBossIndex] = false;
				
				g_bSlenderChaseDeathPosition[iBossIndex] = false;
				
				// Set our goal position.
				if (g_bSlenderInvestigatingSound[iBossIndex])
				{
					g_flSlenderGoalPos[iBossIndex][0] = g_flSlenderTargetSoundMasterPos[iBossIndex][0];
					g_flSlenderGoalPos[iBossIndex][1] = g_flSlenderTargetSoundMasterPos[iBossIndex][1];
					g_flSlenderGoalPos[iBossIndex][2] = g_flSlenderTargetSoundMasterPos[iBossIndex][2];
				}
				
				g_flSlenderTimeUntilIdle[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_alert_duration", 5.0);
				g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
				g_flSlenderTimeUntilChase[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_alert_gracetime", 0.5);
			}
			case STATE_CHASE, STATE_ATTACK, STATE_STUN:
			{
				g_bSlenderInvestigatingSound[iBossIndex] = false;
				g_iSlenderTargetSoundCount[iBossIndex] = 0;
				
				if (iOldState != STATE_ATTACK && iOldState != STATE_CHASE && iOldState != STATE_STUN)
				{
					g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
					g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration", 10.0);
					g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
					
					float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init", 5.0);
					if (flPersistencyTime >= 0.0)
					{
						g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
					}
				}
				
				if (iState == STATE_ATTACK)
				{
					if (!g_ILocomotion[iBossIndex].IsOnGround())
					{
						iState = iOldState;
					}
					else
					{
						g_bSlenderAttacking[iBossIndex] = true;
						int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
						g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttack, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
						
						g_flSlenderTimeUntilAttackEnd[iBossIndex] = GetGameTime()+NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)+0.01;
						
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_attack", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_attack", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
						
						SlenderPerformVoice(iBossIndex, "sound_attackenemy", iAttackIndex+1);
						
						if (g_flLastStuckTime[iBossIndex] != 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					}
				}
				else if (iState == STATE_STUN)
				{
					if (g_bSlenderAttacking[iBossIndex])
					{
						// Cancel attacking.
						g_bSlenderAttacking[iBossIndex] = false;
						g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
					}
					
					if (!bDoChasePersistencyInit)
					{
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_stun", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_stun", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
					}
					else
					{
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init", 5.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
					}
					
					g_flSlenderTimeUntilRecover[iBossIndex] = GetGameTime() + NPCChaserGetStunDuration(iBossIndex);
					
					// Sound handling. Ignore time check.
					SlenderPerformVoice(iBossIndex, "sound_stun");
				}
				else
				{
					if (iOldState != STATE_ATTACK)
					{
						// Sound handling.
						SlenderPerformVoice(iBossIndex, "sound_chaseenemyinitial");
					}
				}
			}
		}
		NPCChaserSetState(iBossIndex, iState);
		// Call our forward.
		Call_StartForward(fOnBossChangeState);
		Call_PushCell(iBossIndex);
		Call_PushCell(iOldState);
		Call_PushCell(iState);
		Call_Finish();
	}
	
	if (iOldState != iState)
		NPCChaserUpdateBossAnimation(iBossIndex, slender, iState);
	
	switch (iState)
	{
		case STATE_WANDER, STATE_ALERT, STATE_CHASE, STATE_ATTACK:
		{
			// These deal with movement, therefore we need to set our 
			// destination first. That is, if we don't have one. (nav mesh only)
			
			if (iState == STATE_WANDER)
			{
				if (GetGameTime() >= g_flSlenderNextWanderPos[iBossIndex])
				{
					float flMin = GetProfileFloat(sSlenderProfile, "search_wander_time_min", 4.0);
					float flMax = GetProfileFloat(sSlenderProfile, "search_wander_time_max", 6.5);
					g_flSlenderNextWanderPos[iBossIndex] = GetGameTime() + GetRandomFloat(flMin, flMax);
					
					if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
					{
						// We're allowed to move in wander mode. Get a new wandering position and create a path to follow.
						// If the position can't be reached, then just get to the closest area that we can get.
						float flWanderRangeMin = GetProfileFloat(sSlenderProfile, "search_wander_range_min", 400.0);
						float flWanderRangeMax = GetProfileFloat(sSlenderProfile, "search_wander_range_max", 1024.0);
						float flWanderRange = GetRandomFloat(flWanderRangeMin, flWanderRangeMax);
						
						float flWanderPos[3];
						flWanderPos[0] = 0.0;
						flWanderPos[1] = GetRandomFloat(0.0, 360.0);
						flWanderPos[2] = 0.0;
						
						GetAngleVectors(flWanderPos, flWanderPos, NULL_VECTOR, NULL_VECTOR);
						NormalizeVector(flWanderPos, flWanderPos);
						ScaleVector(flWanderPos, flWanderRange);
						AddVectors(flWanderPos, flMyPos, flWanderPos);
						
						g_flSlenderGoalPos[iBossIndex][0] = flWanderPos[0];
						g_flSlenderGoalPos[iBossIndex][1] = flWanderPos[1];
						g_flSlenderGoalPos[iBossIndex][2] = flWanderPos[2];
						
						g_flSlenderNextPathTime[iBossIndex] = -1.0; // We're not going to wander around too much, so no need for a time constraint.
					}
				}
			}
			else if (iState == STATE_ALERT)
			{
				if (iInterruptConditions & COND_SAWENEMY)
				{
					if (IsValidEntity(iBestNewTarget))
					{
						if ((iTarget > MaxClients && bBuilding) || ((bPlayerInFOV[iBestNewTarget] || bPlayerNear[iBestNewTarget]) && bPlayerVisible[iBestNewTarget]))
						{
							// Constantly update my path if I see him.
							if (GetGameTime() >= g_flSlenderNextPathTime[iBossIndex])
							{
								GetEntPropVector(iBestNewTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
								g_flSlenderNextPathTime[iBossIndex] = GetGameTime()+0.4;
							}
						}
					}
				}
			}
			else if (iState == STATE_CHASE || iState == STATE_ATTACK)
			{
				if (IsValidEntity(iBestNewTarget))
				{
					iOldTarget = iTarget;
					iTarget = iBestNewTarget;
					g_iSlenderTarget[iBossIndex] = EntIndexToEntRef(iBestNewTarget);
				}
				
				if (iTarget != INVALID_ENT_REFERENCE)
				{
					if (iOldTarget != iTarget)
					{
						// Brand new target! We need a path, and we need to reset our persistency, if needed.
						float flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_init_newtarget", -1.0);
						if (flPersistencyTime >= 0.0)
						{
							g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + flPersistencyTime;
						}
						
						flPersistencyTime = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_newtarget", 2.0);
						if (flPersistencyTime >= 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTime;
						}
					
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
					else if ((iTarget > MaxClients && bBuilding) || ((bPlayerInFOV[iTarget] && bPlayerVisible[iTarget]) || GetGameTime() < g_flSlenderTimeUntilNoPersistence[iBossIndex]))
					{
						// Constantly update my path if I see him or if I'm still being persistent.
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
					}
				}
				if (NPCChaserGetTeleporter(iBossIndex,0) != INVALID_ENT_REFERENCE)
				{
					int iTeleporter = EntRefToEntIndex(NPCChaserGetTeleporter(iBossIndex,0));
					if (IsValidEntity(iTeleporter) && iTeleporter > MaxClients)
						GetEntPropVector(iTeleporter, Prop_Data, "m_vecAbsOrigin", g_flSlenderGoalPos[iBossIndex]);
				}
			}
			if ((iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0)
				|| (iState == STATE_ATTACK))
			{
				if (NavMesh_Exists() && g_flSlenderLastCalculPathTime[iBossIndex] <= GetGameTime())
				{
					g_hBossChaserPathLogic[iBossIndex].ComputePathFromPosToPos(flMyPos, g_flSlenderGoalPos[iBossIndex], SlenderChaseBossShortestPathCost, g_ILocomotion[iBossIndex], _, _);
					g_flSlenderLastCalculPathTime[iBossIndex] = GetGameTime()+0.3;
				}
			}
			if (iState == STATE_CHASE || iState == STATE_ATTACK)
			{
				if (IsValidClient(iTarget))
				{
#if defined DEBUG
					SendDebugMessageToPlayer(iTarget, DEBUG_BOSS_CHASE, 1, "g_flSlenderTimeUntilAlert[%d]: %f\ng_flSlenderTimeUntilNoPersistence[%d]: %f", iBossIndex, g_flSlenderTimeUntilAlert[iBossIndex] - GetGameTime(), iBossIndex, g_flSlenderTimeUntilNoPersistence[iBossIndex] - GetGameTime());
#endif
				
					if (bPlayerInFOV[iTarget] && bPlayerVisible[iTarget])
					{
						float flDistRatio = flPlayerDists[iTarget] / NPCGetSearchRadius(iBossIndex);
						
						float flChaseDurationTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_min", 0.025);
						float flChaseDurationTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_duration_add_visible_max", 0.2);
						
						float flChaseDurationAdd = flChaseDurationTimeAddMax - ((flChaseDurationTimeAddMax - flChaseDurationTimeAddMin) * flDistRatio);
						
						if (flChaseDurationAdd > 0.0)
						{
							g_flSlenderTimeUntilAlert[iBossIndex] += flChaseDurationAdd;
							if (g_flSlenderTimeUntilAlert[iBossIndex] > (GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration")))
							{
								g_flSlenderTimeUntilAlert[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration");
							}
						}
						
						float flPersistencyTimeAddMin = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_min", 0.05);
						float flPersistencyTimeAddMax = GetProfileFloat(sSlenderProfile, "search_chase_persistency_time_add_visible_max", 0.15);
						
						float flPersistencyTimeAdd = flPersistencyTimeAddMax - ((flPersistencyTimeAddMax - flPersistencyTimeAddMin) * flDistRatio);
						
						if (flPersistencyTimeAdd > 0.0)
						{
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] < GetGameTime()) g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime();
						
							g_flSlenderTimeUntilNoPersistence[iBossIndex] += flPersistencyTimeAdd;
							if (g_flSlenderTimeUntilNoPersistence[iBossIndex] > (GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration")))
							{
								g_flSlenderTimeUntilNoPersistence[iBossIndex] = GetGameTime() + GetProfileFloat(sSlenderProfile, "search_chase_duration");
							}
						}
					}
				}
			}
		}
	}
	
	// Sound handling.
	if (GetGameTime() >= g_flSlenderNextVoiceSound[iBossIndex])
	{
		if (iState == STATE_IDLE || iState == STATE_WANDER)
		{
			SlenderPerformVoice(iBossIndex, "sound_idle");
		}
		else if (iState == STATE_ALERT)
		{
			SlenderPerformVoice(iBossIndex, "sound_alertofenemy");
		}
		else if (iState == STATE_CHASE || iState == STATE_ATTACK)
		{
			SlenderPerformVoice(iBossIndex, "sound_chasingenemy");
		}
	}
	
	// Reset our interrupt conditions.
	g_iSlenderInterruptConditions[iBossIndex] = 0;
	
	if (SF_SpecialRound(SPECIALROUND_EARTHQUAKE)) UTIL_ScreenShake(flMyPos, 25.0, 5.0, 1.0, 1000.0, 0, false);
	
	return Plugin_Continue;
}

void NPCChaserUpdateBossAnimation(int iBossIndex, int iEnt, int iState)
{
	char sAnimation[64];
	float flPlaybackRate;
	bool bAnimationFound = false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (iState == STATE_IDLE)
		bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate);
	else if (iState == STATE_ALERT || (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)))
		bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_WalkAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate);
	else if (iState == STATE_CHASE)
		bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_RunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate);
	else if (iState == STATE_ATTACK)
		bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_AttackAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate, NPCGetCurrentAttackIndex(iBossIndex)+1);
	else if (iState == STATE_STUN)
		bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_StunAnimations, sAnimation, sizeof(sAnimation), flPlaybackRate);
	
	if (flPlaybackRate<-12.0) flPlaybackRate = -12.0;
	if (flPlaybackRate>12.0) flPlaybackRate = 12.0;
	
	if (bAnimationFound && strcmp(sAnimation,"") != 0)
	{
		Action action = Plugin_Continue;
		Call_StartForward(fOnBossAnimationUpdate);
		Call_PushCell(iBossIndex);
		Call_Finish(action);
		if (action != Plugin_Handled)
		{
			g_iNPCCurrentAnimationSequence[iBossIndex] = EntitySetAnimation(iEnt, sAnimation, flPlaybackRate);
			EntitySetAnimation(iEnt, sAnimation, flPlaybackRate);//Fix an issue where an anim could start on the wrong frame.
			if (g_iNPCCurrentAnimationSequence[iBossIndex] <= -1)
			{
				g_iNPCCurrentAnimationSequence[iBossIndex] = 0;
				SendDebugMessageToPlayers(DEBUG_BOSS_ANIMATION, 0, "INVALID ANIMATION %s", sAnimation);
			}
			bool bAnimationLoop = (iState == STATE_IDLE || iState == STATE_ALERT || iState == STATE_CHASE || iState == STATE_WANDER);
			SetEntProp(iEnt, Prop_Data, "m_bSequenceLoops", bAnimationLoop);
		}
	}
}

public void SlenderChaseBossProcessMovement(int iBoss)
{
	int iBossIndex = NPCGetFromEntIndex(iBoss);
	if (iBossIndex == -1)
	{
		//Boss is invalid somehow, and the hook wasn't killed.
		SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);
		return;
	}
	
	float flMyPos[3], flMyEyeAng[3];
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	
	SDKCall(g_hSDKStudioFrameAdvance, iBoss);
	
	int iState = g_iSlenderState[iBossIndex];
	int iOldState = g_iSlenderOldState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;
	
	// Process angles.
	bool bChangeAngle = false;
	float vecPosToAt[3];
	if (iState != STATE_STUN)
	{
		int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
		
		if (NPCHasAttribute(iBossIndex, "always look at target"))
		{
			if (iTarget && iTarget != INVALID_ENT_REFERENCE)
			{
				bChangeAngle = true;
				GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
			}
		}
		else
		{
			if (iState == STATE_CHASE)
			{
				bool bCanSeeTarget = false;
				if (iTarget && iTarget != INVALID_ENT_REFERENCE)
				{
					float vecTargetPos[3], vecMyEyePos[3];
					NPCGetEyePosition(iBossIndex, vecMyEyePos);
					GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecTargetPos);
					vecTargetPos[2] += 18.0;
					if (GetVectorDistance(vecTargetPos, vecMyEyePos, false) <= 100.0)
					{
						TR_TraceRayFilter(vecMyEyePos, vecTargetPos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharacters, iBoss);
						bCanSeeTarget = !TR_DidHit();
					}
				}
				
				if (NPCHasAttribute(iBossIndex, "always look at target while chasing") || bCanSeeTarget)
				{
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						bChangeAngle = true;
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);

					}
				}
			}
			else if (iState == STATE_ATTACK)
			{
				if (NPCHasAttribute(iBossIndex, "always look at target while attacking"))
				{
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						bChangeAngle = true;
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecPosToAt);
					}
				}
			}
		}
	}
	
	if (bChangeAngle) g_ILocomotion[iBossIndex].FaceTowards(vecPosToAt);
	
	// Process our desired speed.
	bool bPFUpdate = false;
	switch (iState)
	{
		case STATE_WANDER:
		{
			if ((NPCGetFlags(iBossIndex) & SFF_WANDERMOVE))
			{
				bPFUpdate = true;
				g_ILocomotion[iBossIndex].Walk();
			}
		}
		case STATE_ALERT:
		{
			bPFUpdate = true;
			g_ILocomotion[iBossIndex].Walk();
		}
		case STATE_CHASE:
		{
			bPFUpdate = true;
			g_ILocomotion[iBossIndex].Run();
		}
	}
	if (bPFUpdate)
	{
		g_hBossChaserPathLogic[iBossIndex].Update(g_INextBot[iBossIndex], !bChangeAngle, TraceRayDontHitEntityAndProxies);
	}
	else
		g_ILocomotion[iBossIndex].Stop();
	if (iState != iOldState)
	{
		g_INextBot[iBossIndex].Update();
	}
	
	static bool bVelocityCancel[MAX_BOSSES];
	if (!g_ILocomotion[iBossIndex].IsOnGround() && !g_ILocomotion[iBossIndex].IsClimbingOrJumping())
	{
		float hullcheckmins[3], hullcheckmaxs[3];
		hullcheckmins = HULL_HUMAN_MINS;
		hullcheckmaxs = HULL_HUMAN_MAXS;
		hullcheckmins[0] -= 50.0;
		hullcheckmins[1] -= 50.0;
		
		hullcheckmaxs[0] += 50.0;
		hullcheckmaxs[1] += 50.0;
		
		hullcheckmins[2] += g_ILocomotion[iBossIndex].GetStepHeight();
		hullcheckmaxs[2] -= g_ILocomotion[iBossIndex].GetStepHeight();
		
		if (!bVelocityCancel[iBossIndex] && IsSpaceOccupiedIgnorePlayers(flMyPos, hullcheckmins, hullcheckmaxs, iBoss))//The boss will start to merge with shits, cancel out velocity.
		{
			float vec3Origin[3];
			g_ILocomotion[iBossIndex].SetVelocity(vec3Origin);
			bVelocityCancel[iBossIndex] = true;
		}
	}
	else
		bVelocityCancel[iBossIndex] = false;
	
	if (iState != STATE_IDLE && iState != STATE_STUN && iState != STATE_ATTACK)
	{
		bool bRunUnstuck = (iState == STATE_CHASE && g_flSlenderCalculatedSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_ALERT && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (!bRunUnstuck) bRunUnstuck = (iState == STATE_WANDER && (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE) && g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0);
		if (bRunUnstuck)
		{
			if (GetVectorDistance(flMyPos, g_flLastPos[iBossIndex], false) < 0.01 || g_ILocomotion[iBossIndex].IsStuck())
			{
				bool bBlockingProp = false;
				
				if (NPCGetFlags(iBossIndex) & SFF_ATTACKPROPS)
				{
					for (int iAttackIndex = 0; iAttackIndex < NPCChaserGetAttackCount(iBossIndex); iAttackIndex++)
					{
						if (NPCChaserGetAttackType(iBossIndex, iAttackIndex) == SF2BossAttackType_Ranged) continue;
						bBlockingProp = NPC_CanAttackProps(iBossIndex,NPCChaserGetAttackRange(iBossIndex, iAttackIndex), NPCChaserGetAttackSpread(iBossIndex, iAttackIndex));
						if (bBlockingProp) break;
					}
				}
				
				if (!bBlockingProp)
				{
					if (g_flLastStuckTime[iBossIndex] == 0.0) g_flLastStuckTime[iBossIndex] = GetGameTime();
					
					if (g_flLastStuckTime[iBossIndex] <= GetGameTime()-1.0)
					{
						bool bPathResolved = false;
						float vecMovePos[3];
						g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
						
						if (SlenderChaseBoss_OnStuckResolvePath(iBoss, flMyPos, flMyEyeAng, vecMovePos, vecMovePos))
						{
							if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
							{
								bPathResolved = true;
								TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
							}
						}
						if (!bPathResolved)
						{
							g_hBossChaserPathLogic[iBossIndex].GetMovePosition(vecMovePos);
							if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
							{
								bPathResolved = false;
								TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
							}
							else
							{
								vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
								if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
								{
									bPathResolved = true;
									TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
								}
								else
								{
									CNavArea area = NavMesh_GetNearestArea(flMyPos, _, 200.0);
									if (area == INVALID_NAV_AREA)
									{
										area = g_hBossChaserPathLogic[iBossIndex].GetMovePositionNavArea();
									}
									if (area != INVALID_NAV_AREA)
									{
										area.GetCenter(vecMovePos);
										if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
										{
											bPathResolved = false;
											TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
										}
										else
										{
											vecMovePos[2] += g_ILocomotion[iBossIndex].GetStepHeight();
											if (!IsSpaceOccupiedIgnorePlayers(vecMovePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss))
											{
												bPathResolved = true;
												TeleportEntity(iBoss, vecMovePos, NULL_VECTOR, NULL_VECTOR);
											}
										}
									}
									if (!bPathResolved) RemoveSlender(iBossIndex);//We are stuck there's no way out for us, unspawn, players are just going to abuse that we are stuck.
								}
							}
						}
						if (bPathResolved)
						{
							g_flLastStuckTime[iBossIndex] = 0.0;
						}
					}
				}
			}
			else
			{
				g_flLastStuckTime[iBossIndex] = 0.0;
				g_flLastPos[iBossIndex] = flMyPos;
			}
		}
	}
	
	Address pStudioHdr = CBaseAnimating_GetModelPtr(iBoss);
	if (pStudioHdr != Address_Null)
	{
		int m_iMoveX = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_x");
		int m_iMoveY = CBaseAnimating_LookupPoseParameter(iBoss, pStudioHdr, "move_y");
		
		float flGroundSpeed = g_ILocomotion[iBossIndex].GetGroundSpeed();
		if ( flGroundSpeed != 0.0 )
		{
			float vecForward[3], vecRight[3], vecUp[3], vecMotion[3];
			SDK_GetVectors(iBoss, vecForward, vecRight, vecUp);
			g_ILocomotion[iBossIndex].GetGroundMotionVector(vecMotion);
			
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, GetVectorDotProduct(vecMotion,vecForward));
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, GetVectorDotProduct(vecMotion,vecRight));
		}
		else
		{
			if (m_iMoveX >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveX, 0.0);
			if (m_iMoveY >= 0) CBaseAnimating_SetPoseParameter(iBoss, pStudioHdr, m_iMoveY, 0.0);
		}
		
		if (m_iMoveX < 0 && m_iMoveY < 0) return;
		
		if (iState == STATE_CHASE || iState == STATE_ALERT || iState == STATE_WANDER)
		{
			float m_flGroundSpeed = GetEntPropFloat(iBoss, Prop_Data, "m_flGroundSpeed");
			if(m_flGroundSpeed != 0.0 && g_ILocomotion[iBossIndex].IsOnGround())
			{
				float flReturnValue = flGroundSpeed / m_flGroundSpeed;
				if (flReturnValue < -4.0) flReturnValue = -4.0;
				if (flReturnValue > 12.0) flReturnValue = 12.0;
				
				SetEntPropFloat(iBoss, Prop_Send, "m_flPlaybackRate", flReturnValue);
			}
		}
	}
	
	
	return;
	
	/*//Keep my collision data forced to a specific value:
	SetEntProp(iBoss, Prop_Send, "m_nSolidType", SOLID_BBOX);
	SetEntProp(iBoss, Prop_Send, "m_usSolidFlags", FSOLID_NOT_STANDABLE);
	
	int iState = g_iSlenderState[iBossIndex];
	int iOldState = g_iSlenderOldState[iBossIndex];
	g_iSlenderOldState[iBossIndex] = iState;
	
	int iArraySize = GetArraySize(g_hSlenderPath[iBossIndex]);
	if (iArraySize <= 0)
	{
		g_ILocomotion[iBossIndex].Stop();
		return;
	}
	
	float flMyPos[3], flMyEyeAng[3], flMyVelocity[3];
	
	GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	flMyEyeAng[0] = 0.0;
	flMyEyeAng[1] = AngleNormalize(flMyEyeAng[1]);
	flMyEyeAng[2] = 0.0;
	SDK_GetSmoothedVelocity(iBoss, flMyVelocity);
	TeleportEntity(iBoss, NULL_VECTOR, flMyEyeAng, NULL_VECTOR);
	
	bool bSlenderOnGround = view_as<bool>(GetEntityFlags(iBoss) & FL_ONGROUND);
	
	
	//SetEntityMoveType(iBoss, MOVETYPE_STEP);
	//float flAirSpeed = g_flSlenderCalculatedAirSpeed[iBossIndex];
	
	char sSlenderProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sSlenderProfile, sizeof(sSlenderProfile));

	float flBossMins[3], flBossMaxs[3];
	GetEntPropVector(iBoss, Prop_Send, "m_vecMins", flBossMins);
	GetEntPropVector(iBoss, Prop_Send, "m_vecMaxs", flBossMaxs);
	
	float flTraceMins[3], flTraceMaxs[3];
	flTraceMins[0] = flBossMins[0];
	flTraceMins[1] = flBossMins[1];
	flTraceMins[2] = 0.0;
	flTraceMaxs[0] = flBossMaxs[0];
	flTraceMaxs[1] = flBossMaxs[1];
	flTraceMaxs[2] = 0.0;
	
	// By now we should have our preferable goal position. Initiate
	// reflex adjustments.
	g_bSlenderFeelerReflexAdjustment[iBossIndex] = false;
	
	{
		float flMoveDir[3];
		NormalizeVector(flMyVelocity, flMoveDir);
		flMoveDir[2] = 0.0;
		
		float flLat[3];
		flLat[0] = -flMoveDir[1];
		flLat[1] = flMoveDir[0];
		flLat[2] = 0.0;
	
		float flFeelerOffset = 25.0;
		float flFeelerLengthRun = 50.0;
		float flFeelerLengthWalk = 30.0;
		float flFeelerHeight = StepHeight + 0.1;
		
		float flFeelerLength = iState == STATE_CHASE ? flFeelerLengthRun : flFeelerLengthWalk;
		
		// Get the ground height and normal.
		Handle hTrace = TR_TraceRayFilterEx(flMyPos, view_as<float>({ 0.0, 0.0, 90.0 }), MASK_NPCSOLID, RayType_Infinite, TraceFilterWalkableEntities);
		float flTraceEndPos[3];
		float flTraceNormal[3];
		TR_GetEndPosition(flTraceEndPos, hTrace);
		TR_GetPlaneNormal(hTrace, flTraceNormal);
		bool bTraceHit = TR_DidHit(hTrace);
		CloseHandle(hTrace);
		
		if (bTraceHit)
		{
			//float flGroundHeight = GetVectorDistance(flMyPos, flTraceEndPos);
			NormalizeVector(flTraceNormal, flTraceNormal);
			GetVectorCrossProduct(flLat, flTraceNormal, flMoveDir);
			GetVectorCrossProduct(flMoveDir, flTraceNormal, flLat);
			
			float flFeet[3];
			flFeet[0] = flMyPos[0];
			flFeet[1] = flMyPos[1];
			flFeet[2] = flMyPos[2] + flFeelerHeight;
			
			float flTo[3];
			float flFrom[3];
			for (int i = 0; i < 3; i++)
			{
				flFrom[i] = flFeet[i] + (flFeelerOffset * flLat[i]);
				flTo[i] = flFrom[i] + (flFeelerLength * flMoveDir[i]);
			}
			
			bool bLeftClear = IsWalkableTraceLineClear(flFrom, flTo, WALK_THRU_DOORS | WALK_THRU_BREAKABLES);
			
			for (int i = 0; i < 3; i++)
			{
				flFrom[i] = flFeet[i] - (flFeelerOffset * flLat[i]);
				flTo[i] = flFrom[i] + (flFeelerLength * flMoveDir[i]);
			}
			
			bool bRightClear = IsWalkableTraceLineClear(flFrom, flTo, WALK_THRU_DOORS | WALK_THRU_BREAKABLES);
			
			float flAvoidRange = 300.0;
			
			if (!bRightClear)
			{
				if (bLeftClear)
				{
					g_bSlenderFeelerReflexAdjustment[iBossIndex] = true;
					
					for (int i = 0; i < 3; i++)
					{
						g_flSlenderFeelerReflexAdjustmentPos[iBossIndex][i] = g_flSlenderGoalPos[iBossIndex][i] + (flAvoidRange * flLat[i]);
					}
				}
			}
			else if (!bLeftClear)
			{
				g_bSlenderFeelerReflexAdjustment[iBossIndex] = true;
				
				for (int i = 0; i < 3; i++)
				{
					g_flSlenderFeelerReflexAdjustmentPos[iBossIndex][i] = g_flSlenderGoalPos[iBossIndex][i] - (flAvoidRange * flLat[i]);
				}
			}
		}
	}
	
	float flGoalPosition[3];
	if (g_bSlenderFeelerReflexAdjustment[iBossIndex])
	{
		for (int i = 0; i < 3; i++)
		{
			flGoalPosition[i] = g_flSlenderFeelerReflexAdjustmentPos[iBossIndex][i];
		}
	}
	else
	{
		for (int i = 0; i < 3; i++)
		{
			flGoalPosition[i] = g_flSlenderGoalPos[iBossIndex][i];
		}
	}
	
	if ((GetVectorDistance(flMyPos, g_flLastPos[iBossIndex], false) < 0.01 && iState == STATE_CHASE && (g_flSlenderCalculatedSpeed[iBossIndex] > 0.0 || g_flSlenderCalculatedWalkSpeed[iBossIndex] > 0.0)) || (g_ILocomotion[iBossIndex].IsClimbingOrJumping() && IsSpaceOccupiedNPC(flMyPos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, iBoss)))
	{
		if (g_flLastStuckTime[iBossIndex] < GetGameTime()-2.0)
		{
			if (g_flLastStuckTime[iBossIndex] < GetGameTime()-3.0 && ((!g_ILocomotion[iBossIndex].IsClimbingOrJumping && SlenderChaseBoss_OnStuckResolvePath(iBoss, flMyPos, flMyEyeAng, flGoalPosition, flGoalPosition)) || g_ILocomotion[iBossIndex].IsClimbingOrJumping()))
			{
				g_flLastStuckTime[iBossIndex] = GetGameTime();
				
				if (!g_ILocomotion[iBossIndex].IsClimbingOrJumping())
					g_flSlenderLastCalculPathTime[iBossIndex] = GetGameTime()+0.30;
				else
					TeleportEntity(iBoss, g_flLastJumpPos[iBossIndex], NULL_VECTOR, NULL_VECTOR);
			}
			else if (!g_ILocomotion[iBossIndex].IsClimbingOrJumping())
			{
				if (iState == STATE_CHASE)
				{
					if (g_bSlenderChaseDeathPosition[iBossIndex])//We are stuck and we are looking for a dead player, give up.
					{
						g_bSlenderGiveUp[iBossIndex] = true;
						g_bSlenderChaseDeathPosition[iBossIndex] = false;
					}
					int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
					if (iTarget <= 0 || (iTarget > MaxClients && !IsValidEntity(iTarget)))
						g_bSlenderGiveUp[iBossIndex] = true;
					//Impossible to solve the path, teleport us to the next goal pos.
					TeleportEntity(iBoss, flGoalPosition, NULL_VECTOR, NULL_VECTOR);
					if (iArraySize > 2 && g_flLastStuckTime[iBossIndex] > GetGameTime()-3.0)
					{
						float flNextGoalPos[3];
						GetArrayArray(g_hSlenderPath[iBossIndex], iArraySize-2, flNextGoalPos);
						TeleportEntity(iBoss, flNextGoalPos, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
		}
		if (g_flLastStuckTime[iBossIndex] != -1.0 && g_flLastStuckTime[iBossIndex] < GetGameTime()-0.30)
		{
			bool bNearUnStuckPos = false;
			float flDist = GetVectorDistance(g_flLastUnStuckPos[iBossIndex], flMyPos);
			if (flDist < g_flSlenderPathNodeTolerance[iBossIndex]) bNearUnStuckPos = true;
			if (-4.0 <= g_flLastUnStuckPos[iBossIndex][0] - flMyPos[0] <= 4.0 && -4.0 <= g_flLastUnStuckPos[iBossIndex][1] - flMyPos[1] <= 4.0) bNearUnStuckPos = true;
			if (!bNearUnStuckPos)
				flGoalPosition = g_flLastUnStuckPos[iBossIndex];
			else
				g_flLastStuckTime[iBossIndex] = -1.0;
		}
	}
	g_flLastPos[iBossIndex][0] = flMyPos[0];
	g_flLastPos[iBossIndex][1] = flMyPos[1];
	g_flLastPos[iBossIndex][2] = flMyPos[2];
	
	float flSlenderJumpSpeed = g_flSlenderJumpSpeed[iBossIndex];
	
	if ((GetGameTime()-g_flNextBotLastUpdate[iBossIndex]) >= 0.3)
	{
		UpdateNextbot(iBossIndex, flMyPos, flMyEyeAng);
	}
	
	//PrintToChatAll("%0.0f, %0.0f %0.0f",flGoalPosition[0],flGoalPosition[1],flGoalPosition[2]);
	// Process our desired speed.
	switch (iState)
	{
		case STATE_WANDER:
		{
			if (NPCGetFlags(iBossIndex) & SFF_WANDERMOVE)
			{
				g_ILocomotion[iBossIndex].Walk();
			}
		}
		case STATE_ALERT:
		{
			g_ILocomotion[iBossIndex].Walk();
		}
		case STATE_CHASE:
		{
			g_ILocomotion[iBossIndex].Run();
		}
	}
	
	if (iState == STATE_ALERT || iState == STATE_CHASE || iState == STATE_WANDER)
		g_ILocomotion[iBossIndex].Approach(flGoalPosition);
	
	bool bCanJump = true;
	CNavArea TargetArea = SDK_GetLastKnownArea(iBoss);
	if (TargetArea != INVALID_NAV_AREA)
	{
		if (TargetArea.Attributes & NAV_MESH_NO_JUMP)
		{
			bCanJump = false;
		}
	}
	int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
	if (MaxClients >= iTarget >= 1 && IsClientInGame(iTarget))
	{
		if (iArraySize <= 1)
			bCanJump = false;
	}
	
	if (iState == STATE_ATTACK || iState == STATE_STUN)
		bCanJump = false;
	
	
	bool bSlenderShouldJump = false; 
	
	// Check if we need to jump over a wall or something.
	if (!bSlenderShouldJump && !g_ILocomotion[iBossIndex].IsClimbingOrJumping && flSlenderJumpSpeed > 0.0)
	{
		float flZDiff = (flGoalPosition[2] - flMyPos[2]);
		
		if (flZDiff > NPCChaserGetStepSize(iBossIndex))
		{
			float vecMyPos2D[3], vecGoalPos2D[3];
			vecMyPos2D = flMyPos;
			vecMyPos2D[2] = 0.0;
			vecGoalPos2D = flGoalPosition;
			vecGoalPos2D[2] = 0.0;
			
			float fl2DDist = GetVectorDistance(vecMyPos2D, vecGoalPos2D);
			if (fl2DDist <= 120.0)
				bSlenderShouldJump = true;
		}
	}
	
	if (bSlenderOnGround && bSlenderShouldJump && bCanJump && g_ILocomotion[iBossIndex].IsAbleToJumpAcrossGaps)
	{
		g_flLastJumpPos[iBossIndex] = flGoalPosition;
		float vecJumpVel[3];
		float flActualHeight = flGoalPosition[2] - flMyPos[2];
		float height = flActualHeight;
		if ( height < 16.0 )
		{
			height = 16.0;
		}
		
		float additionalHeight = 0.0;
		if ( height < 32 )
		{
			additionalHeight = 8.0;
		}

		height += additionalHeight;
		
		float speed = SquareRoot( 2.0 * g_flGravity * height );
		float time = speed / g_flGravity;
		
		time += SquareRoot( (2.0 * additionalHeight) / g_flGravity );
		
		SubtractVectors( flGoalPosition, flMyPos, vecJumpVel );
		vecJumpVel[0] /= time;
		vecJumpVel[1] /= time;
		vecJumpVel[2] /= time;

		vecJumpVel[2] = speed;

		float flJumpSpeed = GetVectorLength(vecJumpVel);
		float flMaxSpeed = 650.0;
		if ( flJumpSpeed > flMaxSpeed )
		{
			vecJumpVel[0] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[1] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[2] *= flMaxSpeed / flJumpSpeed;
		}

		g_ILocomotion[iBossIndex].Jump();
		g_ILocomotion[iBossIndex].SetVelocity(vecJumpVel);
		
		NPCChaseUpdateBossAnimation(iBossIndex, iBoss, iState);
	}
	
	bool bCanSeeTarget = false;
	if (iTarget && iTarget != INVALID_ENT_REFERENCE)
	{
		float flTargetPos[3], flMyEyePos[3];
		NPCGetEyePosition(iBossIndex, flMyEyePos);
		GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
		flTargetPos[2] += 18.0;
		if (GetVectorDistance(flTargetPos, flMyEyePos, false) <= 400.0)//Max look ahead distance
		{
			TR_TraceRayFilter(flMyEyePos,flTargetPos,MASK_NPCSOLID,RayType_EndPoint,TraceRayDontHitCharacters,iBoss);
			bCanSeeTarget = !TR_DidHit();
		}
	}
	// Process angles.
	if (iState != STATE_STUN)
	{
		if (NPCHasAttribute(iBossIndex, "always look at target"))
		{
			if (iTarget && iTarget != INVALID_ENT_REFERENCE)
			{
				float flTargetPos[3];
				GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
				g_ILocomotion[iBossIndex].FaceTowards(flTargetPos);
			}
			else
			{
				g_ILocomotion[iBossIndex].FaceTowards(flGoalPosition);
			}
		}
		else
		{
			if (iState == STATE_CHASE)
			{
				if (NPCHasAttribute(iBossIndex, "always look at target while chasing") || bCanSeeTarget)
				{
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						float flTargetPos[3];
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
						g_ILocomotion[iBossIndex].FaceTowards(flTargetPos);
					}
					else
						g_ILocomotion[iBossIndex].FaceTowards(flGoalPosition);
				}
				else
					g_ILocomotion[iBossIndex].FaceTowards(flGoalPosition);
			}
			else if (iState == STATE_ATTACK)
			{
				if (NPCHasAttribute(iBossIndex, "always look at target while attacking"))
				{
					if (iTarget && iTarget != INVALID_ENT_REFERENCE)
					{
						float flTargetPos[3];
						GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
						g_ILocomotion[iBossIndex].FaceTowards(flTargetPos);
					}
					else
						g_ILocomotion[iBossIndex].FaceTowards(flGoalPosition);
				}
			}
			else
				g_ILocomotion[iBossIndex].FaceTowards(flGoalPosition);
		}
	}
	int iModel = EntRefToEntIndex(g_iSlenderModel[iBossIndex]);
	if (iModel > MaxClients)
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
		//BlendAnimation
		float flBlendAnimationSpeed;
		if ( (iState == STATE_WANDER && GetProfileBlendAnimationSpeed(sProfile, ChaserAnimation_WalkAnimations, flBlendAnimationSpeed, 1))
			|| (iState == STATE_ALERT && GetProfileBlendAnimationSpeed(sProfile, ChaserAnimation_WalkAnimations, flBlendAnimationSpeed, 1))
			|| (iState == STATE_CHASE && GetProfileBlendAnimationSpeed(sProfile, ChaserAnimation_RunAnimations, flBlendAnimationSpeed, 1)))
		{
			float flMove[3] = {0.0, 0.0, 0.0};
			GetPositionForward(flMove, flFakeAng, flMove, flBlendAnimationSpeed);
			//PrintToChatAll("move_x %f", flMove);
			EntitySetBlendAnimation(iModel, "move_x", 5.0);
			EntitySetBlendAnimation(iModel, "move_y", 5.0);
		}
		else
		{
			//PrintToChatAll("called2");
			EntitySetBlendAnimation(iModel, "move_x", 0.0);
			EntitySetBlendAnimation(iModel, "move_y", 0.0);
		}
	}*/
}

public Action CBaseEntity_SetLocalAngles(int iEntity, float vecNewAngles[3])
{
	int iBossIndex = NPCGetFromEntIndex(iEntity);
	if (iBossIndex != -1)
	{
		vecNewAngles[0] = 0.0;
		vecNewAngles[2] = 0.0;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

//Note: This functions is really expensive you better call this function only if you really need it!
bool SlenderChaseBoss_OnStuckResolvePath(int slender, float flMyPos[3], float flMyAng[3], float flGoalPosition[3], float flReturn[3])
{
	//We are stuck, try to find a free pos to path on the right or left.
	int attemp = 1;
	while (attemp <= 2)
	{
		float yawMin, yawMax, yawInc;
		if (attemp == 1) //We will first try on the right
		{
			yawMin = 10.0;
			yawMax = 90.0;
			yawInc = 5.0;
		}
		else if (attemp == 2) //Then on the left
		{
			yawMin = -90.0;
			yawMax = -10.0;
			yawInc = 5.0;
		}
		//Note: Actually there's no right and left, it's just to give you an idea on how this will be done. 
		for(float y=yawMin; y<=yawMax; y+=yawInc)
		{
			flMyAng[1] += y;
			for(float r=30.0; r<=300.0; r+=10.0)
			{
				float flFreePos[3];
				GetPositionForward(flMyPos, flMyAng, flFreePos, r);

				// Perform a line of sight check to avoid spawning players in unreachable map locations.
				TR_TraceRayFilter(flMyPos, flFreePos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitPlayersOrEntity, slender);

				if(!TR_DidHit())
				{
					// Perform an other line of sight check to avoid moving in a area that can't reach the original goal!
					TR_TraceRayFilter(flFreePos, flGoalPosition, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitPlayersOrEntity, slender);
					if(!TR_DidHit())
					{
					
						TR_TraceHullFilter(flMyPos, flFreePos, HULL_HUMAN_MINS, HULL_HUMAN_MAXS, MASK_NPCSOLID, TraceRayDontHitPlayersOrEntity, slender);

						if(!TR_DidHit())
						{
							flReturn = flFreePos;
							flMyAng[1] -= y;
							return true;
						}
					}
					else
					{
						//This free position can't bring us to the goal position. Give up on this angle.
						break;
					}
				}
				else
				{
					// We hit something that breaks the line of sight. Give up on this angle.
					break;
				}
			}
			flMyAng[1] -= y;
		}
		attemp++;
	}
	return false;
}

public MRESReturn ClimbUpToLedge(Address pThis, Handle hParams)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
	{
		int iBoss = NPCGetEntIndex(iBossIndex);
		
		float vecMyPos[3], vecJumpPos[3];
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", vecMyPos);
		DHookGetParamVector(hParams, 1, vecJumpPos);
		
		float vecJumpVel[3];
		float flActualHeight = vecJumpPos[2] - vecMyPos[2];
		float height = flActualHeight;
		if ( height < 16.0 )
		{
			height = 16.0;
		}
		
		float additionalHeight = 20.0;
		if ( height < 32 )
		{
			additionalHeight += 8.0;
		}

		height += additionalHeight;
		
		float speed = SquareRoot( 2.0 * g_flGravity * height );
		float time = speed / g_flGravity;
		
		time += SquareRoot( (2.0 * additionalHeight) / g_flGravity );
		
		SubtractVectors( vecJumpPos, vecMyPos, vecJumpVel );
		vecJumpVel[0] /= time;
		vecJumpVel[1] /= time;
		vecJumpVel[2] /= time;

		vecJumpVel[2] = speed;

		float flJumpSpeed = GetVectorLength(vecJumpVel);
		float flMaxSpeed = 650.0;
		if ( flJumpSpeed > flMaxSpeed )
		{
			vecJumpVel[0] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[1] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[2] *= flMaxSpeed / flJumpSpeed;
		}

		g_ILocomotion[iBossIndex].Jump();
		g_ILocomotion[iBossIndex].SetVelocity(vecJumpVel);
		
		NPCChaserUpdateBossAnimation(iBossIndex, iBoss, g_iSlenderState[iBossIndex]);
	}
	return MRES_Ignored;
}

public MRESReturn IsAbleToClimb(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
}

public MRESReturn GetGravity(Address pThis, Handle hReturn)
{
	//Force the gravity. 
	DHookSetReturn(hReturn, g_flGravity);
#if defined DEBUG
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetGravity:%0.0f", iBossIndex, g_flGravity);
#endif
	return MRES_Supercede;
}
public MRESReturn GetAcceleration(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, g_flSlenderAcceleration[iBossIndex]);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetAcceleration:%0.0f", iBossIndex, g_flSlenderAcceleration[iBossIndex]);
#endif
	return MRES_Supercede;
}
public MRESReturn GetMaxDeceleration(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	int iState = g_iSlenderState[iBossIndex];
	if (iState != STATE_CHASE)
		return MRES_Ignored;
	else
	{
		DHookSetReturn(hReturn, 0.0);
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetDeceleration:0.0", iBossIndex);
#endif
	}
	return MRES_Supercede;
}
public MRESReturn GetGroundNormal(Address pThis, Handle hReturn)
{
	float flVec[3] = { 0.0, 0.0, 1.0 };
	DHookSetReturnVector(hReturn, flVec);
#if defined DEBUG
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
	{
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetGroundNormal:0.0 0.0 1.0", iBossIndex);
	}
#endif
	return MRES_Supercede;
}
public MRESReturn GetStepHeight(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, NPCChaserGetStepSize(iBossIndex));
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetStepSize:%0.0f", iBossIndex, NPCChaserGetStepSize(iBossIndex));
#endif
	return MRES_Supercede;
}
public MRESReturn GetMaxJumpHeight(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	DHookSetReturn(hReturn, 160.0);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "(Deprecated)Nextbot (%i) GetMaxJumpHeight:160", iBossIndex);
#endif
	return MRES_Supercede;
}
public MRESReturn GetWalkSpeed(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		DHookSetReturn(hReturn, 0.0);
		return MRES_Supercede;
	}
	int iState = g_iSlenderState[iBossIndex];
	if (iState == STATE_ATTACK || iState == STATE_IDLE || iState == STATE_STUN)
	{
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetWalkSpeed:[IGNORED]", iBossIndex);
#endif
		return MRES_Ignored;
	}
	else
	{
		DHookSetReturn(hReturn, g_flSlenderCalculatedWalkSpeed[iBossIndex]);
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetWalkSpeed:%0.0f", iBossIndex, g_flSlenderCalculatedWalkSpeed[iBossIndex]);
#endif
	}
	return MRES_Supercede;
}
public MRESReturn GetRunSpeed(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		DHookSetReturn(hReturn, 0.0);
		return MRES_Supercede;
	}
	
	int iState = g_iSlenderState[iBossIndex];
	if (iState == STATE_ATTACK || iState == STATE_IDLE || iState == STATE_STUN)
	{
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetRunSpeed:[IGNORED]", iBossIndex);
#endif
		return MRES_Ignored;
	}
	else
	{
		DHookSetReturn(hReturn, g_flSlenderCalculatedSpeed[iBossIndex]*1.25);
#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetRunSpeed:%0.0f", iBossIndex, g_flSlenderCalculatedSpeed[iBossIndex]*1.25);
#endif
	}
	return MRES_Supercede;
}
public MRESReturn GetFrictionForward(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, 100.0);
#if defined DEBUG
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetFrictionF:100.0", iBossIndex);
#endif
	return MRES_Supercede;
}
public MRESReturn GetFrictionSideways(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, 100.0);
#if defined DEBUG
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex != -1)
		SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetFrictionS:100.0", iBossIndex);
#endif
	return MRES_Supercede;
}
public MRESReturn GetSpeedLimit(Address pThis, Handle hReturn)
{
	ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
	INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
	int iBossIndex = NPCGetFromINextBot(BossNextBot);
	if (iBossIndex == -1)
	{
		return MRES_Ignored;
	}
	float flSpeedLimit;
	int iState = g_iSlenderState[iBossIndex];
	switch(iState)
	{
		case STATE_CHASE, STATE_ATTACK:
		{
			flSpeedLimit = NPCGetMaxSpeed(iBossIndex, GetConVarInt(g_cvDifficulty));
		}
		default:
		{
			flSpeedLimit = NPCChaserGetMaxWalkSpeed(iBossIndex, GetConVarInt(g_cvDifficulty));
		}
	}
	DHookSetReturn(hReturn, flSpeedLimit);
#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) GetSpeedLimit:%0.0f", iBossIndex, flSpeedLimit);
#endif
	//PrintToChatAll("Speed limit:%0.0f",flSpeedLimit);
	return MRES_Supercede;
}
public MRESReturn ShouldCollideWith(Address pThis, Handle hReturn, Handle hParams)
{
	int iEntity = DHookGetParam(hParams, 1);
	if (IsValidEntity(iEntity))
	{
		char strClass[32];
		GetEdictClassname(iEntity, strClass, sizeof(strClass));
#if defined DEBUG
		ILocomotion BossLocomotion = view_as<ILocomotion>(pThis);
		INextBot BossNextBot = view_as<INextBot>(BossLocomotion.GetBot());
		int iBossIndex = NPCGetFromINextBot(BossNextBot);
		if (iBossIndex != -1)
		{
			SendDebugMessageToPlayers(DEBUG_NEXTBOT, 0, "Nextbot (%i) ShouldCollideWith:%s", iBossIndex, strClass);
		}
#endif
		if(strcmp(strClass, "tf_zombie") == 0)
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if(strcmp(strClass, "base_boss") == 0)
		{
			DHookSetReturn(hReturn, false);
			return MRES_Supercede;
		}
		else if (strcmp(strClass, "player") == 0)
		{
			if (g_bPlayerProxy[iEntity] || IsClientInGhostMode(iEntity))
			{
				DHookSetReturn(hReturn, false);
				return MRES_Supercede;
			}
		}
	}
	return MRES_Ignored;
}
//IBody
public MRESReturn StartActivity(Address pThis, Handle hReturn, Handle hParams)
{
	DHookSetReturn(hReturn, true);
	return MRES_Supercede;
}

public MRESReturn GetSolidMask(Address pThis, Handle hReturn)
{
	DHookSetReturn(hReturn, 0x203400B);
	return MRES_Supercede;
}

public MRESReturn GetHullWidth(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	if(vecMaxs[1] > vecMaxs[0])
		DHookSetReturn(hReturn, vecMaxs[1] * 2);
	else
		DHookSetReturn(hReturn, vecMaxs[0] * 2);

	return MRES_Supercede;
}

public MRESReturn GetHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2]);

	return MRES_Supercede;
}

public MRESReturn GetStandHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2]);

	return MRES_Supercede;
}

public MRESReturn GetCrouchHullHeight(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturn(hReturn, vecMaxs[2] / 2);

	return MRES_Supercede;
}

public MRESReturn GetHullMins(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMins[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMins", vecMins);
	
	DHookSetReturnVector(hReturn, vecMins);

	return MRES_Supercede;
}

public MRESReturn GetHullMaxs(Address pThis, Handle hReturn, Handle hParams)
{
	IBody pBody = view_as<IBody>(pThis);
	INextBot pNextBot = view_as<INextBot>(pBody.GetBot());
	int iEntity = pNextBot.GetEntity();

	float vecMaxs[3];
	GetEntPropVector(iEntity, Prop_Send, "m_vecMaxs", vecMaxs);
	
	DHookSetReturnVector(hReturn, vecMaxs);

	return MRES_Supercede;
}


// Shortest-path cost function for NavMesh_BuildPath.
public int SlenderChaseBossShortestPathCost(CNavArea area, CNavArea fromArea, CNavLadder ladder, any pBotLocomotion)
{
	if (fromArea == INVALID_NAV_AREA)
	{
		return 0;
	}
	else
	{
		NextBotGroundLocomotion botLocomotion = view_as<NextBotGroundLocomotion>(pBotLocomotion);
		int iDist;
		float flAreaCenter[3], flFromAreaCenter[3];
		area.GetCenter(flAreaCenter);
		fromArea.GetCenter(flFromAreaCenter);
		
		if (ladder != INVALID_NAV_LADDER)
		{
			iDist = RoundFloat(ladder.Length);
		}
		else
		{
			iDist = RoundFloat(GetVectorDistance(flAreaCenter, flFromAreaCenter));
		}
		
		/*float flDeltaZ = fromArea.ComputeAdjacentConnectionHeightChange(area);
		float flStepSize = botLocomotion.GetStepHeight();
		if (flDeltaZ < flStepSize)
		{
			iDist *= 2;
		}
		else
		{
			if (flDeltaZ > botLocomotion.GetMaxJumpHeight())
			{
				return -1;
			}
			iDist *= 6;
		}*/
		
		int iCost = iDist + fromArea.CostSoFar;
		
		if (area.Attributes & NAV_MESH_CROUCH) iCost += 20;
		if (area.Attributes & NAV_MESH_JUMP) iCost += (5 * iDist);
		
		if ((flAreaCenter[2] - flFromAreaCenter[2]) > botLocomotion.GetStepHeight()) iCost += RoundToFloor(botLocomotion.GetStepHeight());
		
		float multiplier = 1.0;

		int seed = RoundToFloor(GetGameTime() * 0.1) + 1;
		
		INextBot bot = view_as<INextBot>(botLocomotion.GetBot());
		seed *= area.ID;
		seed *= bot.GetEntity();
		multiplier += (Cosine(float(seed)) + 1.0) * 50.0;

		iCost += iDist * RoundFloat(multiplier);

		return iCost + fromArea.CostSoFar;
	}
}

public Action Timer_SlenderChaseBossAttack(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return;
	
	if (NPCGetFlags(iBossIndex) & SFF_FAKE)
	{
		SlenderMarkAsFake(iBossIndex);
		return;
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iAttackIndex = NPCGetCurrentAttackIndex(iBossIndex);
	
	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);
	
	float flDamage = NPCChaserGetAttackDamage(iBossIndex, iAttackIndex);
	float flDamageVsProps = NPCChaserGetAttackDamageVsProps(iBossIndex, iAttackIndex);
	int iDamageType = NPCChaserGetAttackDamageType(iBossIndex, iAttackIndex);
	
	// Damage all players within range.
	float vecMyPos[3], flMyEyePos[3], vecMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", vecMyEyeAng);
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", vecMyPos);
	
	AddVectors(g_flSlenderEyePosOffset[iBossIndex], vecMyEyeAng, vecMyEyeAng);
	for (int i = 0; i < 3; i++) vecMyEyeAng[i] = AngleNormalize(vecMyEyeAng[i]);
	
	float flViewPunch[3];
	GetProfileVector(sProfile, "attack_punchvel", flViewPunch);
	
	float flTargetDist;
	Handle hTrace;
	
	float flAttackRange = NPCChaserGetAttackRange(iBossIndex, iAttackIndex);
	float flAttackFOV = NPCChaserGetAttackSpread(iBossIndex, iAttackIndex);
	float flAttackDamageForce = NPCChaserGetAttackDamageForce(iBossIndex, iAttackIndex);
	
	bool bHit = false;
	switch (NPCChaserGetAttackType(iBossIndex, iAttackIndex))
	{
		case SF2BossAttackType_Melee:
		{
			int prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
			{
				if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
				{
					bHit = true;
					SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					float SpreadVel = 1800.0;
					float VertVel = 1300.0;
					float vel[3];
					GetAngleVectors(vecMyEyeAng, vel, NULL_VECTOR, NULL_VECTOR);
					ScaleVector(vel,SpreadVel);
					vel[2] = ((GetURandomFloat() + 0.1) * VertVel) * ((GetURandomFloat() + 0.1) * 2);
					TeleportEntity(prop, NULL_VECTOR, NULL_VECTOR, vel);
				}
			}
			
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "prop_dynamic")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			prop = -1;
			while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
			{
				if (GetEntProp(prop, Prop_Data, "m_iHealth") > 0)
				{
					if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV))
					{
						bHit = true;
						SDKHooks_TakeDamage(prop, slender, slender, flDamageVsProps, iDamageType, _, _, flMyEyePos);
					}
				}
			}
			for (int i = 1; i <= MaxClients; i++)
			{
				if (!IsClientInGame(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i)) continue;
				
				if (!bAttackEliminated && g_bPlayerEliminated[i]) continue;
				
				float flTargetPos[3];
				GetClientEyePosition(i, flTargetPos);
				
				hTrace = TR_TraceRayFilterEx(flMyEyePos,
					flTargetPos,
					MASK_NPCSOLID,
					RayType_EndPoint,
					TraceRayDontHitEntityAndProxies,
					slender);
				
				bool bTraceDidHit = TR_DidHit(hTrace);
				int iTraceHitEntity = TR_GetEntityIndex(hTrace);
				CloseHandle(hTrace);
				
				if (bTraceDidHit && iTraceHitEntity != i)
				{
					float flTargetMins[3], flTargetMaxs[3];
					GetEntPropVector(i, Prop_Send, "m_vecMins", flTargetMins);
					GetEntPropVector(i, Prop_Send, "m_vecMaxs", flTargetMaxs);
					GetClientAbsOrigin(i, flTargetPos);
					for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
					
					hTrace = TR_TraceRayFilterEx(flMyEyePos,
						flTargetPos,
						MASK_NPCSOLID,
						RayType_EndPoint,
						TraceRayDontHitEntityAndProxies,
						slender);
						
					bTraceDidHit = TR_DidHit(hTrace);
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					CloseHandle(hTrace);
				}
				
				if (!bTraceDidHit || iTraceHitEntity == i)
				{
					flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);
					
					if (flTargetDist <= flAttackRange)
					{
						float flDirection[3];
						SubtractVectors(flTargetPos, flMyEyePos, flDirection);
						GetVectorAngles(flDirection, flDirection);
						
						if (FloatAbs(AngleDiff(flDirection[1], vecMyEyeAng[1])) <= flAttackFOV)
						{
							bHit = true;
							GetAngleVectors(flDirection, flDirection, NULL_VECTOR, NULL_VECTOR);
							NormalizeVector(flDirection, flDirection);
							ScaleVector(flDirection, flAttackDamageForce);
							
							if (SF_SpecialRound(SPECIALROUND_MULTIEFFECT))
							{
								int iEffect = GetRandomInt(0, 5);
								switch (iEffect)
								{
									case 1:
									{
										TF2_MakeBleed(i, i, 3.0);
									}
									case 2:
									{
										TF2_IgnitePlayer(i, i);
									}
									case 3:
									{
										TF2_AddCondition(i, TFCond_Jarated, 3.0);
									}
									case 4:
									{
										TF2_AddCondition(i, TFCond_CritMmmph, 2.0);
									}
									case 5:
									{
										int iEffectRare = GetRandomInt(1, 30);
										switch (iEffectRare)
										{
											case 1,14,25,30:
											{
												int iNewHealth = GetEntProp(i, Prop_Send, "m_iHealth")+view_as<int>(flDamage);
												if (iNewHealth > 450) iNewHealth = 450;
												TF2_AddCondition(i, TFCond_MegaHeal, 2.0);
												SetEntProp(i, Prop_Send, "m_iHealth", iNewHealth);
												flDamage = 0.0;
											}
											case 7,27:
											{
												//It's over 9000!
												flDamage = 9001.0;
											}
											case 5,16,18,22,23,26:
											{
												ScaleVector(flDirection, 1200.0);
											}
										}
									}
								}
							}
							
							Call_StartForward(fOnClientDamagedByBoss);
							Call_PushCell(i);
							Call_PushCell(iBossIndex);
							Call_PushCell(slender);
							Call_PushFloat(flDamage);
							Call_PushCell(iDamageType);
							Call_Finish();
							
							SDKHooks_TakeDamage(i, slender, slender, flDamage, iDamageType, _, flDirection, flMyEyePos);
							ClientViewPunch(i, flViewPunch);
							
							if (NPCHasAttribute(iBossIndex, "bleed player on hit"))
							{
								float flDuration = NPCGetAttributeValue(iBossIndex, "bleed player on hit");
								if (flDuration > 0.0)
								{
									TF2_MakeBleed(i, i, flDuration);
								}
							}
							if (NPCHasAttribute(iBossIndex, "ignite player on hit"))
							{
								TF2_IgnitePlayer(i, i);
							}
							
							// Add stress
							float flStressScalar = flDamage / 125.0;
							if (flStressScalar > 1.0) flStressScalar = 1.0;
							ClientAddStress(i, 0.33 * flStressScalar);
						}
					}
				}
			}
			char sSoundPath[PLATFORM_MAX_PATH];
			
			if (bHit)
			{
				// Fling it.
				int phys = CreateEntityByName("env_physexplosion");
				if (phys != -1)
				{
					TeleportEntity(phys, flMyEyePos, NULL_VECTOR, NULL_VECTOR);
					DispatchKeyValue(phys, "spawnflags", "1");
					DispatchKeyValueFloat(phys, "radius", flAttackRange);
					DispatchKeyValueFloat(phys, "magnitude", flAttackDamageForce);
					DispatchSpawn(phys);
					ActivateEntity(phys);
					AcceptEntityInput(phys, "Explode");
					AcceptEntityInput(phys, "Kill");
				}
				
				GetRandomStringFromProfile(sProfile, "sound_hitenemy", sSoundPath, sizeof(sSoundPath),_,iAttackIndex+1);
				if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			}
			else
			{
				GetRandomStringFromProfile(sProfile, "sound_missenemy", sSoundPath, sizeof(sSoundPath),_,iAttackIndex+1);
				if (sSoundPath[0]) EmitSoundToAll(sSoundPath, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			}
		}
		case SF2BossAttackType_Ranged:
		{
			/*int iTarget = EntRefToEntIndex(g_iSlenderTarget[iBossIndex]);
			int iBestShootTarget = -1;
			if (MaxClients > iTarget > 0)
			{
				if (IsClientInGame(iTarget) && IsPlayerAlive(iTarget) && !IsClientInGhostMode(iTarget))
				{
					bool bContinue = true;
					if (!bAttackEliminated && g_bPlayerEliminated[iTarget])
						bContinue = false;
					if (bContinue)
					{
						float flTargetPos[3];
						GetClientEyePosition(iTarget, flTargetPos);
						
						hTrace = TR_TraceRayFilterEx(flMyEyePos,
							flTargetPos,
							MASK_NPCSOLID,
							RayType_EndPoint,
							TraceRayDontHitEntity,
							slender);
						
						bool bTraceDidHit = TR_DidHit(hTrace);
						int iTraceHitEntity = TR_GetEntityIndex(hTrace);
						CloseHandle(hTrace);
						
						if (bTraceDidHit && iTraceHitEntity != iTarget)
						{
							float flTargetMins[3], flTargetMaxs[3];
							GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
							GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
							GetClientAbsOrigin(iTarget, flTargetPos);
							for (int i2 = 0; i2 < 3; i2++) flTargetPos[i2] += ((flTargetMins[i2] + flTargetMaxs[i2]) / 2.0);
							
							hTrace = TR_TraceRayFilterEx(flMyEyePos,
								flTargetPos,
								MASK_NPCSOLID,
								RayType_EndPoint,
								TraceRayDontHitEntity,
								slender);
								
							bTraceDidHit = TR_DidHit(hTrace);
							iTraceHitEntity = TR_GetEntityIndex(hTrace);
							CloseHandle(hTrace);
						}
						
						if (!bTraceDidHit || iTraceHitEntity == iTarget)
						{
							flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);
							
							if (flTargetDist <= flAttackRange)
							{
								iBestShootTarget = iTarget;
								flAttackRange = flTargetDist;
							}
						}
					}
				}
			}
			if (iBestShootTarget > 0 && IsClientInGame(iBestShootTarget))
			{
				float flTargetPos[3];
				GetClientAbsOrigin(iBestShootTarget, flTargetPos);
				int iShots = GetProfileAttackNum(sProfile, "attack_bullet_shots", 1, iAttackIndex+1);
				float vecShootPos[3], vecShootSpread[3], vecDir[3];
				char sAmmoName[200];
				GetProfileAttackString(sProfile, "attack_bullet_ammo_name", sAmmoName, sizeof(sAmmoName), _, iAttackIndex+1);
				GetProfileAttackVector(sProfile, "attack_bullet_offset", vecShootPos, _, iAttackIndex+1);
				GetProfileAttackVector(sProfile, "attack_bullet_spread", vecShootSpread, _, iAttackIndex+1);
				PrintToChatAll("[1]%f %f %f", vecShootPos[0], vecShootPos[1], vecShootPos[2]);
				PrintToChatAll("[1-1]%f %f %f", vecMyPos[0], vecMyPos[1], vecMyPos[2]);
				AddVectors(vecMyPos, vecShootPos, vecShootPos);
				PrintToChatAll("[2]%f %f %f", vecShootPos[0], vecShootPos[1], vecShootPos[2]);
				float v[3], ang[3];
				flTargetPos[2] += 50.0;
				SubtractVectors(flTargetPos, vecShootPos, v); 
				NormalizeVector(v, v);
				GetVectorAngles(v, ang);
				
				if (ang[0] > 180.0) 
				ang[0] -= 360.0;
				
				if(ang[0] > 90.0)
					ang[0] = 90.0;
				else if(ang[0] < -90.0)
					ang[0] = -90.0;
				
				GetAngleVectors(ang, vecDir, NULL_VECTOR, NULL_VECTOR);
				
				FireBulletsInfo_t info = new FireBulletsInfo_t();
				info.iShots = iShots;
				info.SetVecSrc(vecShootPos);
				info.SetVecDirShooting(vecDir);
				info.SetVecSpread(vecShootSpread);
				info.flDistance = 8192.0;
				if (strcmp(sAmmoName,"") != 0)
				{
					int iAmmoIndex = GetAmmoIndex(sAmmoName);
					if (iAmmoIndex <= -1)
						iAmmoIndex = 1;
					info.iAmmoType = iAmmoIndex;
				}
				else
					info.iAmmoType = 1;
				info.iTracerFreq = 1;
				info.iDamage = RoundToCeil(flDamageVsProps);
				info.iPlayerDamage = RoundToCeil(flDamage);
				info.nFlags = FIRE_BULLETS_TEMPORARY_DANGER_SOUND;
				//info.flDamageForceScale = flAttackDamageForce;
				info.bPrimaryAttack = true;
				info.pAttacker = slender;
				utils_EntityFireBullets(slender, info);
				delete info;
			}*/
		}
	}
	if (!GetProfileAttackNum(sProfile, "attack_disappear_upon_damaging", 0, iAttackIndex+1))
		g_hSlenderAttackTimer[iBossIndex] = CreateTimer(NPCChaserGetAttackDuration(iBossIndex, iAttackIndex)-NPCChaserGetAttackDamageDelay(iBossIndex, iAttackIndex), Timer_SlenderChaseBossAttackEnd, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
	else
	{
		RemoveSlender(iBossIndex);
		g_bSlenderAttacking[iBossIndex] = false;
		g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
	}
}

static bool NPCAttackValidateTarget(int iBossIndex,int iTarget, float flAttackRange, float flAttackFOV, bool bCheckBlock = false)
{
	int iBoss = NPCGetEntIndex(iBossIndex);
	
	float flMyEyePos[3], flMyEyeAng[3];
	NPCGetEyePosition(iBossIndex, flMyEyePos);
	if(iTarget>MaxClients)
	{
		//float flVecMaxs[3];
		flMyEyePos[2]+=30.0;
		//GetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Data, "m_vecMaxs", flVecMaxs);
	}
	GetEntPropVector(iBoss, Prop_Data, "m_angAbsRotation", flMyEyeAng);
	AddVectors(g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng, flMyEyeAng);
	for (int i = 0; i < 3; i++) flMyEyeAng[i] = AngleNormalize(flMyEyeAng[i]);
	
	float flTargetPos[3], flTargetMins[3], flTargetMaxs[3];
	GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", flTargetPos);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMins", flTargetMins);
	GetEntPropVector(iTarget, Prop_Send, "m_vecMaxs", flTargetMaxs);
	
	for (int i = 0; i < 3; i++)
	{
		flTargetPos[i] += (flTargetMins[i] + flTargetMaxs[i]) / 2.0;
	}
	
	float flTargetDist = GetVectorDistance(flTargetPos, flMyEyePos);
	if (flTargetDist <= flAttackRange)
	{
		float flDirection[3];
		SubtractVectors(g_flSlenderGoalPos[iBossIndex], flMyEyePos, flDirection);
		GetVectorAngles(flDirection, flDirection);
		
		if (FloatAbs(AngleDiff(flDirection[1], flMyEyeAng[1])) <= flAttackFOV / 2.0)
		{
			Handle hTrace = TR_TraceRayFilterEx(flMyEyePos,
				flTargetPos,
				MASK_NPCSOLID,
				RayType_EndPoint,
				TraceRayDontHitEntityAndProxies,
				iBoss);
				
			bool bTraceDidHit = TR_DidHit(hTrace);
			int iTraceHitEntity = TR_GetEntityIndex(hTrace);
			delete hTrace;
			
			if (!bTraceDidHit || iTraceHitEntity == iTarget)
			{
				if (bCheckBlock)
				{
					float flPos[3], flPosForward[3];
					GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flPos);
					GetPositionForward(flPos, flMyEyeAng, flPosForward, flTargetDist+50.0);
					hTrace = TR_TraceHullFilterEx(flPos,
					flPosForward, 
					HULL_HUMAN_MINS, 
					HULL_HUMAN_MAXS, 
					MASK_NPCSOLID, 
					TraceRayBossVisibility, 
					iBoss);
					iTraceHitEntity = TR_GetEntityIndex(hTrace);
					delete hTrace;
					
					if (iTraceHitEntity == iTarget)
					{
						return true;
					}
				}
				else
					return true;
			}
		}
	}
	
	return false;
}
static bool NPCPropPhysicsAttack(int iBossIndex,int prop)
{
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH], model[SF2_MAX_PROFILE_NAME_LENGTH], key[64];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	if(!IsValidEntity(prop))return false;
	GetEntPropString(prop, Prop_Data, "m_ModelName", model, sizeof(model));
	if (!KvJumpToKey(g_hConfig, "attack_props_physics_models")) return true;
	bool bFound=false;
	for(int i=1; ; i++)
	{
		IntToString(i, key, sizeof(key));
		KvGetString(g_hConfig, key, buffer, PLATFORM_MAX_PATH);
		if(!buffer[0])
		{
			break;
		}
		if(StrEqual(buffer,model))
		{
			bFound = true;
			break;
		}
	}
	return bFound;
}
stock void NPC_DropKey(int iBossIndex)
{
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	KvGetString(g_hConfig, "key_trigger", buffer, PLATFORM_MAX_PATH);
	if(!StrEqual(buffer,""))
	{
		float flMyPos[3], flVel[3];
		int iBoss = NPCGetEntIndex(iBossIndex);
		GetEntPropVector(iBoss, Prop_Data, "m_vecAbsOrigin", flMyPos);
		Format(buffer,PLATFORM_MAX_PATH,"sf2_key_%s",buffer);
		
		int TouchBox = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(TouchBox,"targetname", buffer);
		DispatchKeyValue(TouchBox,"powerup_model", SF_KEYMODEL);
		DispatchKeyValue(TouchBox,"modelscale", "2.0");
		DispatchKeyValue(TouchBox,"pickup_sound","ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(TouchBox,"pickup_particle","utaunt_firework_teamcolor_red");
		DispatchKeyValue(TouchBox,"TeamNum","0");
		TeleportEntity(TouchBox, flMyPos, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(TouchBox,SF_KEYMODEL);
		SetEntProp(TouchBox, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(TouchBox);
		ActivateEntity(TouchBox);
		SetEntityModel(TouchBox,SF_KEYMODEL);
		
		int Key = CreateEntityByName("tf_halloween_pickup");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(Key,"targetname", buffer);
		DispatchKeyValue(Key,"powerup_model", PAGE_MODEL);
		DispatchKeyValue(Key,"modelscale", "2.0");
		DispatchKeyValue(Key,"pickup_sound","ui/itemcrate_smash_ultrarare_short.wav");
		DispatchKeyValue(Key,"pickup_particle","utaunt_firework_teamcolor_red");
		DispatchKeyValue(Key,"TeamNum","0");
		TeleportEntity(Key, flMyPos, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(Key,PAGE_MODEL);
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		DispatchSpawn(Key);
		ActivateEntity(Key);
		
		SetEntityRenderMode(Key, RENDER_TRANSCOLOR);
		SetEntityRenderColor(Key, 0, 0, 0, 1);
		
		int glow = CreateEntityByName("tf_taunt_prop");
		//To do: allow the cfg maker to change the model.
		DispatchKeyValue(glow,"targetname", buffer);
		DispatchKeyValue(glow,"model", SF_KEYMODEL);
		TeleportEntity(glow, flMyPos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(glow);
		ActivateEntity(glow);
		SetEntityModel(glow,SF_KEYMODEL);
		
		SetEntProp(glow, Prop_Send, "m_bGlowEnabled", 1);
		SetEntPropFloat(glow, Prop_Send, "m_flModelScale", 2.0);
		SetEntityRenderMode(glow, RENDER_TRANSCOLOR);
		SetEntityRenderColor(glow, 0, 0, 0, 1);
		
		SetVariantString("!activator");
		AcceptEntityInput(TouchBox, "SetParent", Key);
		
		SetVariantString("!activator");
		AcceptEntityInput(glow, "SetParent", Key);
		
		SetEntityModel(Key,PAGE_MODEL);
		SetEntityMoveType(Key, MOVETYPE_FLYGRAVITY);
		
		HookSingleEntityOutput(TouchBox,"OnRedPickup",KeyTrigger);
		
		flVel[0] = GetRandomFloat(-300.0, 300.0);
		flVel[1] = GetRandomFloat(-300.0, 300.0);
		flVel[2] = GetRandomFloat(700.0, 900.0);
		
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		
		TeleportEntity(Key, flMyPos, NULL_VECTOR, flVel);
		SetEntPropFloat(Key, Prop_Send, "m_flModelScale", 2.0);
		SetEntProp(Key, Prop_Data, "m_iEFlags", 12845056);
		SetEntProp(Key, Prop_Data, "m_MoveCollide", 1);
		
		SDKHook(Key, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(glow, SDKHook_SetTransmit, Hook_KeySetTransmit);
		SDKHook(TouchBox, SDKHook_SetTransmit, Hook_KeySetTransmit);
		
		//The key can be stuck somewhere to prevent that, make an auto collect.
		float flTimeLeft = float(g_iRoundTime);
		if(flTimeLeft>60.0)
			flTimeLeft=30.0;
		else
			flTimeLeft=flTimeLeft-20.0;
		CreateTimer(flTimeLeft, CollectKey, EntIndexToEntRef(TouchBox));
	}
}
public void KeyTrigger(const char[] output, int caller, int activator, float delay)
{
	TriggerKey(caller);
}

public Action Hook_KeySetTransmit(int entity,int iOther)
{
	if(!IsValidClient(iOther)) return Plugin_Continue;
	
	if(g_bPlayerEliminated[iOther] && IsClientInGhostMode(iOther)) return Plugin_Continue;
	
	if(!g_bPlayerEliminated[iOther]) return Plugin_Continue;
	
	return Plugin_Handled;
}

public Action CollectKey(Handle timer, any entref)
{
	int ent = EntRefToEntIndex(entref);
	if (ent == INVALID_ENT_REFERENCE) return;
	char sClass[64];
	GetEntityNetClass(ent, sClass, sizeof(sClass));
	if (!StrEqual(sClass, "CHalloweenPickup")) return;
	
	TriggerKey(ent);
	return;
}
	
	
stock void TriggerKey(int caller)
{
	char targetName[PLATFORM_MAX_PATH];
	GetEntPropString(caller, Prop_Data, "m_iName", targetName, sizeof(targetName));
	
	int	ent = -1;
	while ((ent = FindEntityByClassname(ent, "tf_halloween_pickup")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"KillHierarchy");
		}
	}
	
	ReplaceString(targetName, sizeof(targetName), "sf2_key_", "", false);
	float flMyPos[3];
	GetEntPropVector(caller, Prop_Data, "m_vecAbsOrigin", flMyPos);
	TE_Particle(g_iParticle[FireworksRED], flMyPos, flMyPos);
	TE_SendToAll();
	TE_Particle(g_iParticle[FireworksBLU], flMyPos, flMyPos);
	TE_SendToAll();
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"Trigger");
		}
	}
	ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door")) != -1)
	{
		char sName[64];
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (StrEqual(sName, targetName, false))
		{
			AcceptEntityInput(ent,"Open");
		}
	}
	AcceptEntityInput(caller,"Kill");
	EmitSoundToAll("ui/itemcrate_smash_ultrarare_short.wav", caller, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
}
stock bool NPC_CanAttackProps(int iBossIndex,float flAttackRange,float flAttackFOV)
{
	int prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_physics")) > MaxClients)
	{
		if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			if(NPCPropPhysicsAttack(iBossIndex, prop))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "prop_*")) > MaxClients)
	{
		if(GetEntProp(prop,Prop_Data,"m_iHealth") > 0)
		{
			if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
			{
				return true;
			}
		}
	}
	prop = -1;
	while ((prop = FindEntityByClassname(prop, "obj_*")) > MaxClients)
	{
		if (NPCAttackValidateTarget(iBossIndex, prop, flAttackRange, flAttackFOV, true))
		{
			return true;
		}
	}
	return false;
}

public Action Timer_SlenderChaseBossAttackEnd(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	if (timer != g_hSlenderAttackTimer[iBossIndex]) return;
	
	g_bSlenderAttacking[iBossIndex] = false;
	g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
}