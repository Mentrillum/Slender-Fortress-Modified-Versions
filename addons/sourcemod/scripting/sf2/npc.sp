#if defined _sf2_npc_included
 #endinput
#endif
#define _sf2_npc_included

#define SF2_BOSS_PAGE_CALCULATION 0.3
#define SF2_BOSS_COPY_SPAWN_MIN_DISTANCE 1850.0 // The default minimum distance boss copies can spawn from each other.

#define SF2_BOSS_ATTACK_MELEE 0

static int g_iNPCGlobalUniqueID = 0;

static int g_iNPCUniqueID[MAX_BOSSES] = { -1, ... };
static char g_strSlenderProfile[MAX_BOSSES][SF2_MAX_PROFILE_NAME_LENGTH];
static int g_iNPCProfileIndex[MAX_BOSSES] = { -1, ... };
static int g_iNPCUniqueProfileIndex[MAX_BOSSES] = { -1, ... };
static int g_iNPCType[MAX_BOSSES] = { SF2BossType_Unknown, ... };
static int g_iNPCFlags[MAX_BOSSES] = { 0, ... };
static float g_flNPCModelScale[MAX_BOSSES] = { 1.0, ... };
static int g_iNPCHealth[MAX_BOSSES] = { 0, ... };
static int g_iNPCModelSkin[MAX_BOSSES] = { 0, ... };
static int g_iNPCModelSkinMax[MAX_BOSSES] = { 0, ... };
int g_iNPCRaidHitbox[MAX_BOSSES] = { 0, ... };

static float g_flNPCFieldOfView[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCTurnRate[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCBackstabFOV[MAX_BOSSES] = { 0.0, ... };

static float g_flNPCTeleportTimeMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportTimeMax[MAX_BOSSES][Difficulty_Max];

static float g_flNPCJumpscareDistance[MAX_BOSSES][Difficulty_Max];
static float g_flNPCJumpscareDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCJumpscareCooldown[MAX_BOSSES][Difficulty_Max];

g_iSlender[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_flNPCSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCMaxSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAddSpeed[MAX_BOSSES];
static float g_flNPCAddMaxSpeed[MAX_BOSSES];
static float g_flNPCIdleLifetime[MAX_BOSSES][Difficulty_Max];

static float g_flNPCScareRadius[MAX_BOSSES];
static float g_flNPCScareCooldown[MAX_BOSSES];

static int g_iNPCTeleportType[MAX_BOSSES] = { -1, ... };

static float g_flNPCAnger[MAX_BOSSES] = { 1.0, ... };
static float g_flNPCAngerAddOnPageGrab[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCAngerAddOnPageGrabTimeDiff[MAX_BOSSES] = { 0.0, ... };

static float g_flNPCSearchRadius[MAX_BOSSES][Difficulty_Max];
static float g_flNPCHearingRadius[MAX_BOSSES][Difficulty_Max];
static float g_flNPCInstantKillRadius[MAX_BOSSES] = { 0.0, ... };

static bool g_bNPCDeathCamEnabled[MAX_BOSSES] = { false, ... };

static bool g_bNPCProxyWeaponsEnabled[MAX_BOSSES] = { false, ... };

static int g_iNPCEnemy[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

Handle hTimerMusic = INVALID_HANDLE;//Planning to add a bosses array on.

INextBot g_INextBot[MAX_BOSSES];
NextBotGroundLocomotion g_ILocomotion[MAX_BOSSES];
IBody g_IBody[MAX_BOSSES];
ChaserPathLogic g_hBossChaserPathLogic[MAX_BOSSES];

float g_flLastStuckTime[MAX_BOSSES] = {-1.0, ...};
bool g_bNPCHasCloaked[MAX_BOSSES] = { false, ... };
bool g_bNPCUsedRage1[MAX_BOSSES] = { false, ... };
bool g_bNPCUsedRage2[MAX_BOSSES] = { false, ... };
bool g_bNPCUsedRage3[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesRageAnimation1[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesRageAnimation2[MAX_BOSSES] = { false, ... };
bool g_bNPCUsesRageAnimation3[MAX_BOSSES] = { false, ... };

const SF2NPC_BaseNPC SF2_INVALID_NPC = view_as<SF2NPC_BaseNPC>(-1);

methodmap SF2NPC_BaseNPC
{
	property int Index
	{
		public get() { return view_as<int>(this); }
	}
	
	property int Type
	{
		public get() { return NPCGetType(this.Index); }
	}
	
	property int ProfileIndex
	{
		public get() { return NPCGetProfileIndex(this.Index); }
	}
	
	property int UniqueProfileIndex
	{
		public get() { return NPCGetUniqueProfileIndex(this.Index); }
	}
	
	property int EntRef
	{
		public get() { return NPCGetEntRef(this.Index); }
	}
	
	property int EntIndex
	{
		public get() { return NPCGetEntIndex(this.Index); }
	}
	
	property int Flags
	{
		public get() { return NPCGetFlags(this.Index); }
		public set(int flags)
		{
			NPCSetFlags(this.Index, flags);
		}
	}
	
	property float ModelScale
	{
		public get() { return NPCGetModelScale(this.Index); }
	}
	
	property int Health
	{
		public get() { return NPCGetHealth(this.Index); }
	}

	property int Skin
	{
		public get() { return NPCGetModelSkin(this.Index); }
	}
	
	property int RaidHitbox
	{
		public get() { return NPCGetRaidHitbox(this.Index); }
	}
	
	property float TurnRate
	{
		public get() { return NPCGetTurnRate(this.Index); }
	}
	
	property float FOV
	{
		public get() { return NPCGetFOV(this.Index); }
	}
	
	property float Anger
	{
		public get() { return NPCGetAnger(this.Index); }
		public set(float amount) { NPCSetAnger(this.Index, amount); }
	}
	
	property float AngerAddOnPageGrab
	{
		public get() { return NPCGetAngerAddOnPageGrab(this.Index); }
	}
	
	property float AngerAddOnPageGrabTimeDiff
	{
		public get() { return NPCGetAngerAddOnPageGrabTimeDiff(this.Index); }
	}

	property float ScareRadius
	{
		public get() { return NPCGetScareRadius(this.Index); }
	}
	
	property float ScareCooldown
	{
		public get() { return NPCGetScareCooldown(this.Index); }
	}
	
	property float InstantKillRadius
	{
		public get() { return NPCGetInstantKillRadius(this.Index); }
	}
	
	property int TeleportType
	{
		public get() { return NPCGetTeleportType(this.Index); }
	}

	property bool DeathCamEnabled
	{
		public get() { return NPCHasDeathCamEnabled(this.Index); }
		public set(bool state) { NPCSetDeathCamEnabled(this.Index, state); }
	}
	
	public SF2NPC_BaseNPC(int index)
	{
		return view_as<SF2NPC_BaseNPC>(index);
	}

	public void Spawn(float pos[3])
	{
		SpawnSlender(this, pos);
	}
	
	public void UnSpawn()
	{
		RemoveSlender(this.Index);
	}
	
	public void Remove()
	{
		NPCRemove(this.Index);
	}
	
	public bool IsValid()
	{
		return NPCIsValid(this.Index);
	}
	
	public void GetProfile(char[] buffer, int bufferlen) 
	{
		NPCGetProfile(this.Index, buffer, bufferlen);
	}
	
	public void SetProfile(const char[] profileName)
	{
		NPCSetProfile(this.Index, profileName);
	}
	
	public float GetSpeed(int difficulty)
	{
		return NPCGetSpeed(this.Index, difficulty);
	}
	
	public float GetMaxSpeed(int difficulty)
	{
		return NPCGetMaxSpeed(this.Index, difficulty);
	}
	
	public void GetEyePosition(float buffer[3], const float defaultValue[3] = { 0.0, 0.0, 0.0 })
	{
		NPCGetEyePosition(this.Index, buffer, defaultValue);
	}
	
	public void GetEyePositionOffset(float buffer[3])
	{
		NPCGetEyePositionOffset(this.Index, buffer);
	}
	
	public void AddAnger(float amount)
	{
		NPCAddAnger(this.Index, amount);
	}
	
	public bool HasAttribute(const char[] attributeName)
	{
		return NPCHasAttribute(this.Index, attributeName);
	}
	
	public float GetAttributeValue(const char[] attributeName, float defaultValue = 0.0)
	{
		return NPCGetAttributeValue(this.Index, attributeName, defaultValue);
	}
}

bool NPCHasProxyWeapons(int iNPCIndex)
{
	return g_bNPCProxyWeaponsEnabled[iNPCIndex];
}

bool NPCHasDeathCamEnabled(int iNPCIndex)
{
	return g_bNPCDeathCamEnabled[iNPCIndex];
}

void NPCSetDeathCamEnabled(int iNPCIndex, bool state)
{
	g_bNPCDeathCamEnabled[iNPCIndex] = state;
}

public void NPCInitialize()
{
	NPCChaserInitialize();
}

public void NPCOnConfigsExecuted()
{
	g_iNPCGlobalUniqueID = 0;
}

bool NPCIsValid(int iNPCIndex)
{
	return view_as<bool>(iNPCIndex >= 0 && iNPCIndex < MAX_BOSSES && NPCGetUniqueID(iNPCIndex) != -1);
}

int NPCGetUniqueID(int iNPCIndex)
{
	return g_iNPCUniqueID[iNPCIndex];
}

int NPCGetFromUniqueID(int iNPCUniqueID)
{
	if (iNPCUniqueID == -1) return -1;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == iNPCUniqueID)
		{
			return i;
		}
	}
	
	return -1;
}

int NPCGetEntRef(int iNPCIndex)
{
	return g_iSlender[iNPCIndex];
}

int NPCGetEntIndex(int iNPCIndex)
{
	return EntRefToEntIndex(NPCGetEntRef(iNPCIndex));
}

int NPCGetFromEntIndex(int entity)
{
	if (!entity || !IsValidEntity(entity)) return -1;
	
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetEntIndex(i) == entity)
		{
			return i;
		}
	}
	
	return -1;
}

int NPCGetFromINextBot(INextBot BossNextBot)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		if (view_as<int>(g_INextBot[i]) == view_as<int>(BossNextBot))
		{
			return i;
		}
	}
	
	return -1;
}

int NPCGetCount()
{
	int iCount;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		if (NPCGetFlags(i) & SFF_FAKE) continue;
		
		iCount++;
	}
	
	return iCount;
}

int NPCGetProfileIndex(int iNPCIndex)
{
	return g_iNPCProfileIndex[iNPCIndex];
}

int NPCGetUniqueProfileIndex(int iNPCIndex)
{
	return g_iNPCUniqueProfileIndex[iNPCIndex];
}

bool NPCGetProfile(int iNPCIndex, char[] buffer,int bufferlen)
{
	strcopy(buffer, bufferlen, g_strSlenderProfile[iNPCIndex]);
	return true;
}

int NPCSetProfile(int iNPCIndex, const char[] sProfile)
{
	strcopy(g_strSlenderProfile[iNPCIndex], sizeof(g_strSlenderProfile[]), sProfile);
}

int NPCRemove(int iNPCIndex)
{
	if (!NPCIsValid(iNPCIndex)) return;
	
	RemoveProfile(iNPCIndex);
}
void NPCStopMusic()
{
	//Stop the music timer
	if(hTimerMusic != INVALID_HANDLE)
	{
		delete hTimerMusic;
		hTimerMusic = INVALID_HANDLE;
	}
	//Stop the music for all players.
	for(int i = 1;i<=MaxClients;i++)
	{
		if(IsValidClient(i))
		{
			StopSound(i, MUSIC_CHAN, sCurrentMusicTrack);
		}
	}
}
stock bool MusicActive()
{
	if(hTimerMusic!=INVALID_HANDLE)
		return true;
	return false;
}
stock bool BossHasMusic(char[] sProfile)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	char sTemp[512];
	switch (iDifficulty)
	{
		case Difficulty_Normal:
		{
			if (GetRandomStringFromProfile(sProfile,"sound_music",sTemp,sizeof(sTemp))) return true;
			else return false;
		}
		case Difficulty_Hard:
		{
			if (GetRandomStringFromProfile(sProfile,"sound_music_hard",sTemp,sizeof(sTemp))) return true;
			else 
				if (GetRandomStringFromProfile(sProfile,"sound_music",sTemp,sizeof(sTemp))) return true;
				else return false;
		}
		case Difficulty_Insane:
		{
			if (GetRandomStringFromProfile(sProfile,"sound_music_insane",sTemp,sizeof(sTemp))) return true;
			else
				if (GetRandomStringFromProfile(sProfile,"sound_music_hard",sTemp,sizeof(sTemp))) return true;
				else
					if (GetRandomStringFromProfile(sProfile,"sound_music",sTemp,sizeof(sTemp))) return true;
					else return false;
		}
		case Difficulty_Nightmare:
		{
			if (GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sTemp,sizeof(sTemp))) return true;
			else
				if (GetRandomStringFromProfile(sProfile,"sound_music_insane",sTemp,sizeof(sTemp))) return true;
				else
					if (GetRandomStringFromProfile(sProfile,"sound_music_hard",sTemp,sizeof(sTemp))) return true;
					else
						if (GetRandomStringFromProfile(sProfile,"sound_music",sTemp,sizeof(sTemp))) return true;
						else return false;
		}
		case Difficulty_Apollyon:
		{
			if (GetRandomStringFromProfile(sProfile,"sound_music_apollyon",sTemp,sizeof(sTemp))) return true;
			else
				if (GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sTemp,sizeof(sTemp))) return true;
				else
					if (GetRandomStringFromProfile(sProfile,"sound_music_insane",sTemp,sizeof(sTemp))) return true;
					else
						if (GetRandomStringFromProfile(sProfile,"sound_music_hard",sTemp,sizeof(sTemp))) return true;
						else
							if (GetRandomStringFromProfile(sProfile,"sound_music",sTemp,sizeof(sTemp))) return true;
							else return false;
		}
	}
	return false;
}
stock void GetBossMusic(char[] buffer,int bufferlen)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))	
	{
		switch (iDifficulty)
		{
			case Difficulty_Normal: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNormal);
				strcopy(buffer,bufferlen,sCurrentMusicTrack);
			}
			case Difficulty_Hard: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackHard);
				strcopy(buffer,bufferlen,sCurrentMusicTrack);
			}
			case Difficulty_Insane: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackInsane);
				strcopy(buffer,bufferlen,sCurrentMusicTrack);
			}
			case Difficulty_Nightmare: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNightmare);
				strcopy(buffer,bufferlen,sCurrentMusicTrack);
			}
			case Difficulty_Apollyon: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackApollyon);
				strcopy(buffer,bufferlen,sCurrentMusicTrack);
			}
		}
	}
	else
		strcopy(buffer,bufferlen,TRIPLEBOSSESMUSIC);
}
public Action BossMusic(Handle timer,any iBossIndex)
{
	if(iBossIndex > -1)
	{
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
		float time = GetProfileFloat(sProfile,"sound_music_loop",0.0);
		if(time > 0.0)
		{
			for(int i = 1;i<=MaxClients;i++)
			{
				if(IsValidClient(i))
				{
					StopSound(i, MUSIC_CHAN, sCurrentMusicTrack);
				}
			}
			hTimerMusic = CreateTimer(time,BossMusic,iBossIndex);
			return Plugin_Continue;
		}
	}
	hTimerMusic = INVALID_HANDLE;
	NPCStopMusic();
	return Plugin_Continue;
}
void NPCRemoveAll()
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		NPCRemove(i);
	}
}
/*void NPCChaseAlerts(int iNPCIndex, int iNPCCopyIndex)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if ((g_iSlenderState[iNPCIndex] == STATE_CHASE || g_iSlenderState[iNPCIndex] == STATE_ATTACK || g_iSlenderState[iNPCIndex] == STATE_STUN) && !g_bNPCAlertedCopy[i] && !g_bNPCStopAlertingCopies[iNPCIndex] && g_iSlenderState[i] != STATE_CHASE && g_iSlenderState[i] != STATE_ATTACK && g_iSlenderState[i] != STATE_STUN)
		{
			int iBossEnt = NPCGetFromEntIndex(i);
			g_iSlenderTarget[i] = g_iSlenderTarget[iNPCIndex];
			g_iSlenderState[i] = STATE_CHASE;
			g_flSlenderTimeUntilNoPersistence[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
			g_flSlenderTimeUntilAlert[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
			g_bNPCAlertedCopy[i] = true;
			NPCChaserUpdateBossAnimation(i, iBossEnt, g_iSlenderState[i]);
			g_hNPCRegisterAlertingCopiesTimer[i] = CreateTimer(0.1, Timer_SlenderStopAlerts, EntIndexToEntRef(i));
			g_hNPCRegisterAlertingCopiesTimer[iNPCIndex] = CreateTimer(0.3, Timer_SlenderStopAlerts, EntIndexToEntRef(iBossEnt));
		}
		if ((g_iSlenderState[iNPCCopyIndex] == STATE_CHASE || g_iSlenderState[iNPCCopyIndex] == STATE_ATTACK || g_iSlenderState[iNPCCopyIndex] == STATE_STUN) && !g_bNPCAlertedCopy[i] && !g_bNPCStopAlertingCopies[iNPCCopyIndex] && g_iSlenderState[i] != STATE_CHASE && g_iSlenderState[i] != STATE_ATTACK && g_iSlenderState[i] != STATE_STUN)
		{
			int iBossEnt = NPCGetFromEntIndex(i);
			g_iSlenderTarget[i] = g_iSlenderTarget[iNPCCopyIndex];
			g_iSlenderState[i] = STATE_CHASE;
			g_flSlenderTimeUntilNoPersistence[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
			g_flSlenderTimeUntilAlert[i] = GetGameTime() + NPCChaserGetChaseDuration(i, iDifficulty);
			g_bNPCAlertedCopy[i] = true;
			NPCChaserUpdateBossAnimation(i, iBossEnt, g_iSlenderState[i]);
			g_hNPCRegisterAlertingCopiesTimer[i] = CreateTimer(0.1, Timer_SlenderStopAlerts, EntIndexToEntRef(i));
			g_hNPCRegisterAlertingCopiesTimer[iNPCCopyIndex] = CreateTimer(0.3, Timer_SlenderStopAlerts, EntIndexToEntRef(iBossEnt));
		}
	}
}*/

int NPCGetType(int iNPCIndex)
{
	return g_iNPCType[iNPCIndex];
}

int NPCGetFlags(int iNPCIndex)
{
	return g_iNPCFlags[iNPCIndex];
}

void NPCSetFlags(int iNPCIndex,int iFlags)
{
	g_iNPCFlags[iNPCIndex] = iFlags;
}

float NPCGetModelScale(int iNPCIndex)
{
	return g_flNPCModelScale[iNPCIndex];
}

int NPCGetHealth(int iNPCIndex)
{
	return g_iNPCHealth[iNPCIndex];
}

int NPCGetModelSkin(int iNPCIndex)
{
	return g_iNPCModelSkin[iNPCIndex];
}

int NPCGetModelSkinMax(int iNPCIndex)
{
	return g_iNPCModelSkinMax[iNPCIndex];
}

int NPCGetRaidHitbox(int iNPCIndex)
{
	return g_iNPCRaidHitbox[iNPCIndex];
}

bool NPCGetCustomOutlinesState(int iNPCIndex)
{
	return g_bSlenderUseCustomOutlines[iNPCIndex];
}

int NPCGetOutlineColorR(int iNPCIndex)
{
	return g_iSlenderOutlineColorR[iNPCIndex];
}

int NPCGetOutlineColorG(int iNPCIndex)
{
	return g_iSlenderOutlineColorG[iNPCIndex];
}

int NPCGetOutlineColorB(int iNPCIndex)
{
	return g_iSlenderOutlineColorB[iNPCIndex];
}

int NPCGetOutlineTransparency(int iNPCIndex)
{
	return g_iSlenderOutlineTransparency[iNPCIndex];
}

float NPCGetSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCSpeed[iNPCIndex][iDifficulty];
}

float NPCGetMaxSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxSpeed[iNPCIndex][iDifficulty];
}

float NPCSetAddSpeed(int iNPCIndex, float flAmount)
{
	g_flNPCAddSpeed[iNPCIndex] += flAmount;
}

float NPCSetAddMaxSpeed(int iNPCIndex, float flAmount)
{
	g_flNPCAddMaxSpeed[iNPCIndex] += flAmount;
}

float NPCGetAddSpeed(int iNPCIndex)
{
	return g_flNPCAddSpeed[iNPCIndex];
}

float NPCGetAddMaxSpeed(int iNPCIndex)
{
	return g_flNPCAddMaxSpeed[iNPCIndex];
}

float NPCGetTeleportTimeMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportTimeMin[iNPCIndex][iDifficulty];
}

float NPCGetTeleportTimeMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportTimeMax[iNPCIndex][iDifficulty];
}

float NPCGetJumpscareDistance(int iNPCIndex, int iDifficulty)
{
	return g_flNPCJumpscareDistance[iNPCIndex][iDifficulty];
}

float NPCGetJumpscareDuration(int iNPCIndex, int iDifficulty)
{
	return g_flNPCJumpscareDuration[iNPCIndex][iDifficulty];
}

float NPCGetJumpscareCooldown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCJumpscareCooldown[iNPCIndex][iDifficulty];
}

float NPCGetTurnRate(int iNPCIndex)
{
	return g_flNPCTurnRate[iNPCIndex];
}

float NPCGetFOV(int iNPCIndex)
{
	return g_flNPCFieldOfView[iNPCIndex];
}

float NPCGetBackstabFOV(int iNPCIndex)
{
	return g_flNPCBackstabFOV[iNPCIndex];
}

float NPCGetIdleLifetime(int iNPCIndex,int iDifficulty)
{
	return g_flNPCIdleLifetime[iNPCIndex][iDifficulty];
}

float NPCGetAnger(int iNPCIndex)
{
	return g_flNPCAnger[iNPCIndex];
}

void NPCSetAnger(int iNPCIndex, float flAnger)
{
	g_flNPCAnger[iNPCIndex] = flAnger;
}

void NPCAddAnger(int iNPCIndex, float flAmount)
{
	g_flNPCAnger[iNPCIndex] += flAmount;
}

float NPCGetAngerAddOnPageGrab(int iNPCIndex)
{
	return g_flNPCAngerAddOnPageGrab[iNPCIndex];
}

float NPCGetAngerAddOnPageGrabTimeDiff(int iNPCIndex)
{
	return g_flNPCAngerAddOnPageGrabTimeDiff[iNPCIndex];
}

float NPCGetEyePositionOffset(int iNPCIndex, float buffer[3])
{
	buffer[0] = g_flSlenderEyePosOffset[iNPCIndex][0];
	buffer[1] = g_flSlenderEyePosOffset[iNPCIndex][1];
	buffer[2] = g_flSlenderEyePosOffset[iNPCIndex][2];
}

float NPCGetSearchRadius(int iNPCIndex, int iDifficulty)
{
	return g_flNPCSearchRadius[iNPCIndex][iDifficulty];
}

float NPCGetHearingRadius(int iNPCIndex, int iDifficulty)
{
	return g_flNPCHearingRadius[iNPCIndex][iDifficulty];
}

float NPCGetScareRadius(int iNPCIndex)
{
	return g_flNPCScareRadius[iNPCIndex];
}

float NPCGetScareCooldown(int iNPCIndex)
{
	return g_flNPCScareCooldown[iNPCIndex];
}

float NPCGetInstantKillRadius(int iNPCIndex)
{
	return g_flNPCInstantKillRadius[iNPCIndex];
}

int NPCGetTeleportType(int iNPCIndex)
{
	return g_iNPCTeleportType[iNPCIndex];
}

bool NPCShouldSeeEntity(int iNPCIndex, int entity)
{
	if (!IsValidEntity(entity))
		return false;

	Action result = Plugin_Continue;
	Call_StartForward(fOnBossSeeEntity);
	Call_PushCell(iNPCIndex);
	Call_PushCell(entity);
	Call_Finish(result);

	if (result != Plugin_Continue)
		return false;

	return true;
}

bool NPCShouldHearEntity(int iNPCIndex, int entity)
{
	if (!IsValidEntity(entity))
		return false;

	Action result = Plugin_Continue;
	Call_StartForward(fOnBossHearEntity);
	Call_PushCell(iNPCIndex);
	Call_PushCell(entity);
	Call_Finish(result);

	if (result != Plugin_Continue)
		return false;

	return true;
}

/**
 *	Returns the boss's eye position (eye pos offset + absorigin).
 */
bool NPCGetEyePosition(int iNPCIndex, float buffer[3], const float flDefaultValue[3]={ 0.0, 0.0, 0.0 })
{
	buffer[0] = flDefaultValue[0];
	buffer[1] = flDefaultValue[1];
	buffer[2] = flDefaultValue[2];
	
	if (!NPCIsValid(iNPCIndex)) return false;
	
	int iNPC = NPCGetEntIndex(iNPCIndex);
	if (!iNPC || iNPC == INVALID_ENT_REFERENCE) return false;
	
	// @TODO: Replace SlenderGetAbsOrigin with GetEntPropVector
	float flPos[3], flEyePosOffset[3];
	SlenderGetAbsOrigin(iNPCIndex, flPos);
	NPCGetEyePositionOffset(iNPCIndex, flEyePosOffset);
	
	AddVectors(flPos, flEyePosOffset, buffer);
	return true;
}

bool NPCHasAttribute(int iNPCIndex, const char[] sAttribute)
{
	if (NPCGetUniqueID(iNPCIndex) == -1) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
	
	KvRewind(g_hConfig);
	KvJumpToKey(g_hConfig, sProfile);
	
	if (!KvJumpToKey(g_hConfig, "attributes")) return false;
	
	return KvJumpToKey(g_hConfig, sAttribute);
}

float NPCGetAttributeValue(int iNPCIndex, const char[] sAttribute, float flDefaultValue=0.0)
{
	if (!NPCHasAttribute(iNPCIndex, sAttribute)) return flDefaultValue;
	return KvGetFloat(g_hConfig, "value", flDefaultValue);
}

bool SlenderCanRemove(int iBossIndex)
{
	if (NPCGetUniqueID(iBossIndex) == -1) return false;
	
	if (PeopleCanSeeSlender(iBossIndex, _, false)) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iTeleportType = GetProfileNum(sProfile, "teleport_type");

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	switch (iTeleportType)
	{
		case 0:
		{
			if (GetProfileNum(sProfile, "static_on_radius"))
			{
				float flSlenderPos[3], flBuffer[3];
				SlenderGetAbsOrigin(iBossIndex, flSlenderPos);
			
				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || 
						!IsPlayerAlive(i) || 
						g_bPlayerEliminated[i] || 
						IsClientInGhostMode(i) || 
						IsClientInDeathCam(i)) continue;
					
					if (!IsPointVisibleToPlayer(i, flSlenderPos, false, false)) continue;
					
					GetClientAbsOrigin(i, flBuffer);
					if (GetVectorSquareMagnitude(flBuffer, flSlenderPos) <= SquareFloat(g_flSlenderStaticRadius[iBossIndex][iDifficulty]))
					{
						return false;
					}
				}
			}
		}
		case 1:
		{
			if (PeopleCanSeeSlender(iBossIndex, _, SlenderUsesBlink(iBossIndex)) || PeopleCanSeeSlender(iBossIndex, false, false))
			{
				return false;
			}
		}
		case 2:
		{
			int iState = g_iSlenderState[iBossIndex];
			if (iState != STATE_ALERT && iState != STATE_CHASE && iState != STATE_ATTACK && iState != STATE_STUN)
			{
				if (GetGameTime() < g_flSlenderTimeUntilKill[iBossIndex])
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
	}
	
	return true;
}

bool SlenderGetAbsOrigin(int iBossIndex, float buffer[3], const float flDefaultValue[3]={ 0.0, 0.0, 0.0 })
{
	for (int i = 0; i < 3; i++) buffer[i] = flDefaultValue[i];
	
	if (iBossIndex < 0 || NPCGetUniqueID(iBossIndex) == -1) return false;
	
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flPos[3], flOffset[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flPos);
	GetProfileVector(sProfile, "pos_offset", flOffset, flDefaultValue);
	SubtractVectors(flPos, flOffset, buffer);
	
	return true;
}

bool SlenderGetEyePosition(int iBossIndex, float buffer[3], const float flDefaultValue[3]={ 0.0, 0.0, 0.0 })
{
	return NPCGetEyePosition(iBossIndex, buffer, flDefaultValue);
}

bool SelectProfile(SF2NPC_BaseNPC Npc, const char[] sProfile,int iAdditionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool bSpawnCompanions=true, bool bPlaySpawnSound=true)
{
	if (!IsProfileValid(sProfile))
	{
		if(!NpcCopyMaster.IsValid())
		{
			LogSF2Message("Could not select profile for boss %d: profile %s is invalid!", Npc.Index, sProfile);
			return false;
		}
		/*else//Wait my copy master is valid but not my profil wut????
		{
			char sNewProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NpcCopyMaster.GetProfile(sNewProfile,sizeof(sNewProfile));
			//Add me again
			SelectProfile(Npc, sNewProfile, iAdditionalBossFlags, NpcCopyMaster, bSpawnCompanions, bPlaySpawnSound);
		}*/
	}
	Npc.Remove();
	
	int iProfileIndex = GetBossProfileIndexFromName(sProfile);
	int iUniqueProfileIndex = GetBossProfileUniqueProfileIndex(iProfileIndex);
	
	Npc.SetProfile(sProfile);
	
	int iBossType = GetBossProfileType(iProfileIndex);

	g_iNPCProfileIndex[Npc.Index] = iProfileIndex;
	g_iNPCUniqueProfileIndex[Npc.Index] = iUniqueProfileIndex;
	g_iNPCUniqueID[Npc.Index] = g_iNPCGlobalUniqueID++;
	g_iNPCType[Npc.Index] = iBossType;
	
	g_flNPCModelScale[Npc.Index] = GetBossProfileModelScale(iProfileIndex);
	
	g_iNPCHealth[Npc.Index] = GetBossProfileHealth(iProfileIndex);
	
	g_iNPCModelSkin[Npc.Index] = GetBossProfileSkin(iProfileIndex);
	
	g_iNPCModelSkinMax[Npc.Index] = GetBossProfileSkinMax(iProfileIndex);
	
	g_iNPCRaidHitbox[Npc.Index] = GetBossProfileRaidHitbox(iProfileIndex);
	
	g_bSlenderUseCustomOutlines[Npc.Index] = GetBossProfileCustomOutlinesState(iProfileIndex);
	g_iSlenderOutlineColorR[Npc.Index] = GetBossProfileOutlineColorR(iProfileIndex);
	g_iSlenderOutlineColorG[Npc.Index] = GetBossProfileOutlineColorG(iProfileIndex);
	g_iSlenderOutlineColorB[Npc.Index] = GetBossProfileOutlineColorB(iProfileIndex);
	g_iSlenderOutlineTransparency[Npc.Index] = GetBossProfileOutlineTransparency(iProfileIndex);

	g_bNPCProxyWeaponsEnabled[Npc.Index] = GetBossProfileProxyWeapons(iProfileIndex);
	
	if (SF_IsSlaughterRunMap()) NPCSetFlags(Npc.Index, GetBossProfileFlags(iProfileIndex) | iAdditionalBossFlags | SFF_NOTELEPORT);
	else NPCSetFlags(Npc.Index, GetBossProfileFlags(iProfileIndex) | iAdditionalBossFlags);
	
	GetBossProfileEyePositionOffset(iProfileIndex, g_flSlenderEyePosOffset[Npc.Index]);
	GetBossProfileEyeAngleOffset(iProfileIndex, g_flSlenderEyeAngOffset[Npc.Index]);
	
	GetProfileVector(sProfile, "mins", g_flSlenderDetectMins[Npc.Index]);
	GetProfileVector(sProfile, "maxs", g_flSlenderDetectMaxs[Npc.Index]);
	
	//	NPCSetAnger(Npc.Index, GetBossProfileAngerStart(iProfileIndex));
	Npc.Anger = GetBossProfileAngerStart(iProfileIndex);
	
	g_flNPCAngerAddOnPageGrab[Npc.Index] = GetBossProfileAngerAddOnPageGrab(iProfileIndex);
	g_flNPCAngerAddOnPageGrabTimeDiff[Npc.Index] = GetBossProfileAngerPageGrabTimeDiff(iProfileIndex);

	g_iSlenderCopyMaster[Npc.Index] = -1;
	g_iSlenderHealth[Npc.Index] = GetProfileNum(sProfile, "health", 900);
	
	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCSpeed[Npc.Index][iDifficulty] = GetBossProfileSpeed(iProfileIndex, iDifficulty);
		g_flNPCMaxSpeed[Npc.Index][iDifficulty] = GetBossProfileMaxSpeed(iProfileIndex, iDifficulty);
		g_flNPCIdleLifetime[Npc.Index][iDifficulty] = GetBossProfileIdleLifetime(iProfileIndex, iDifficulty);
		g_flSlenderStaticRadius[Npc.Index][iDifficulty] = GetBossProfileStaticRadius(iProfileIndex, iDifficulty);
		g_flNPCSearchRadius[Npc.Index][iDifficulty] = GetBossProfileSearchRadius(iProfileIndex, iDifficulty);
		g_flNPCHearingRadius[Npc.Index][iDifficulty] = GetBossProfileHearRadius(iProfileIndex, iDifficulty);
		g_flSlenderTeleportMinRange[Npc.Index][iDifficulty] = GetBossProfileTeleportRangeMin(iProfileIndex, iDifficulty);
		g_flSlenderTeleportMaxRange[Npc.Index][iDifficulty] = GetBossProfileTeleportRangeMax(iProfileIndex, iDifficulty);
		g_flNPCTeleportTimeMin[Npc.Index][iDifficulty] = GetBossProfileTeleportTimeMin(iProfileIndex, iDifficulty);
		g_flNPCTeleportTimeMax[Npc.Index][iDifficulty] = GetBossProfileTeleportTimeMax(iProfileIndex, iDifficulty);
		g_flNPCJumpscareDistance[Npc.Index][iDifficulty] = GetBossProfileJumpscareDistance(iProfileIndex, iDifficulty);
		g_flNPCJumpscareDuration[Npc.Index][iDifficulty] = GetBossProfileJumpscareDuration(iProfileIndex, iDifficulty);
		g_flNPCJumpscareCooldown[Npc.Index][iDifficulty] = GetBossProfileJumpscareCooldown(iProfileIndex, iDifficulty);
	}
	
	g_flNPCTurnRate[Npc.Index] = GetBossProfileTurnRate(iProfileIndex);
	if (!SF_IsSlaughterRunMap()) g_flNPCFieldOfView[Npc.Index] = GetBossProfileFOV(iProfileIndex);
	else g_flNPCFieldOfView[Npc.Index] = 360.0;
	g_flNPCBackstabFOV[Npc.Index] = 180.0;
	
	g_flNPCScareRadius[Npc.Index] = GetBossProfileScareRadius(iProfileIndex);
	g_flNPCScareCooldown[Npc.Index] = GetBossProfileScareCooldown(iProfileIndex);
	
	g_flNPCInstantKillRadius[Npc.Index] = GetBossProfileInstantKillRadius(iProfileIndex);
	
	g_iNPCTeleportType[Npc.Index] = GetBossProfileTeleportType(iProfileIndex);
	
	g_flNPCAddSpeed[Npc.Index] = 0.0;
	g_flNPCAddMaxSpeed[Npc.Index] = 0.0;
	
	g_iNPCEnemy[Npc.Index] = INVALID_ENT_REFERENCE;
	
	g_iNPCPlayerScareVictin[Npc.Index] = INVALID_ENT_REFERENCE;
	g_bNPCChasingScareVictin[Npc.Index] = false;
	g_bNPCLostChasingScareVictim[Npc.Index] = false;
	
	// Deathcam values.
	Npc.DeathCamEnabled = view_as<bool>(GetProfileNum(sProfile, "death_cam"));
	
	g_flSlenderAcceleration[Npc.Index] = GetProfileFloat(sProfile, "acceleration", 150.0);
	g_hSlenderFakeTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderEntityThink[Npc.Index] = INVALID_HANDLE;
	g_hSlenderAttackTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderLaserTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderBackupAtkTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderChaseInitialTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderRage1Timer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderRage2Timer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderRage3Timer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderHealTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderHealDelayTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderHealEventTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderStartFleeTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderSpawnTimer[Npc.Index] = INVALID_HANDLE;
	g_hNPCResetAlertCopyTimer[Npc.Index] = INVALID_HANDLE;
	g_hNPCRegisterAlertingCopiesTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderDeathCamTimer[Npc.Index] = INVALID_HANDLE;
	g_flSlenderNextTeleportTime[Npc.Index] = 0.0;
	g_flSlenderLastKill[Npc.Index] = 0.0;
	g_flSlenderTimeUntilKill[Npc.Index] = -1.0;
	g_flSlenderNextJumpScare[Npc.Index] = -1.0;
	g_flSlenderNextStunTime[Npc.Index] = -1.0;
	g_flSlenderNextCloakTime[Npc.Index] = -1.0;
	g_bNPCHasCloaked[Npc.Index] = false;
	g_bNPCUsedRage1[Npc.Index] = false;
	g_bNPCUsedRage2[Npc.Index] = false;
	g_bNPCUsedRage3[Npc.Index] = false;
	g_flSlenderTimeUntilNextProxy[Npc.Index] = -1.0;
	g_flSlenderIdleAnimationPlaybackRate[Npc.Index] = GetProfileFloat(sProfile, "animation_idle_playbackrate", 1.0);
	g_flSlenderWalkAnimationPlaybackRate[Npc.Index] = GetProfileFloat(sProfile, "animation_walk_playbackrate", 1.0);
	g_flSlenderRunAnimationPlaybackRate[Npc.Index] = GetProfileFloat(sProfile, "animation_run_playbackrate", 1.0);
	g_flSlenderJumpSpeed[Npc.Index] = GetProfileFloat(sProfile, "jump_speed", 512.0);
	g_hBossChaserPathLogic[Npc.Index] = ChaserPathLogic(Npc.Index);
	g_hBossChaserPathLogic[Npc.Index].flNodeDistTolerance = GetProfileFloat(sProfile, "search_node_dist_tolerance", 32.0);
	g_hBossChaserPathLogic[Npc.Index].flLookAheadDistance = GetProfileFloat(sProfile, "search_node_dist_lookahead", 512.0);
	g_flSlenderProxyTeleportMinRange[Npc.Index] = GetProfileFloat(sProfile, "proxies_teleport_range_min");
	g_flSlenderProxyTeleportMaxRange[Npc.Index] = GetProfileFloat(sProfile, "proxies_teleport_range_max");
	g_bNPCVelocityCancel[Npc.Index] = false;
	g_hSlenderBurnTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderBleedTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderMarkedTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderMilkedTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderGasTimer[Npc.Index] = INVALID_HANDLE;
	g_hSlenderJarateTimer[Npc.Index] = INVALID_HANDLE;
	g_flSlenderStopBurning[Npc.Index] = 0.0;
	g_flSlenderStopBleeding[Npc.Index] = 0.0;
	g_bSlenderIsBurning[Npc.Index] = false;
	g_bSlenderIsMarked[Npc.Index] = false;
	g_bSlenderIsMilked[Npc.Index] = false;
	g_bSlenderIsGassed[Npc.Index] = false;
	g_bSlenderIsJarate[Npc.Index] = false;
	g_iSlenderSoundTarget[Npc.Index] = INVALID_ENT_REFERENCE;

	for (int i = 1; i <= MaxClients; i++)
	{
		g_flPlayerLastChaseBossEncounterTime[i][Npc.Index] = -1.0;
		g_flSlenderTeleportPlayersRestTime[Npc.Index][i] = -1.0;
	}
	
	g_iSlenderTeleportTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_iSlenderProxyTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_flSlenderTeleportMaxTargetStress[Npc.Index] = 9999.0;
	g_flSlenderTeleportMaxTargetTime[Npc.Index] = -1.0;
	g_flSlenderNextTeleportTime[Npc.Index] = -1.0;
	g_flSlenderTeleportTargetTime[Npc.Index] = -1.0;
	
	char sCloakOnSound[PLATFORM_MAX_PATH];
	char sCloakOffSound[PLATFORM_MAX_PATH];
	char sShootRocketSound[PLATFORM_MAX_PATH];
	char sShootSentryRocketSound[PLATFORM_MAX_PATH];
	char sShootFireballSound[PLATFORM_MAX_PATH];
	char sRocketImpactSound[PLATFORM_MAX_PATH];
	char sFireballImpactSound[PLATFORM_MAX_PATH];
	char sIceballImpactSound[PLATFORM_MAX_PATH];
	char sShootGrenadeSound[PLATFORM_MAX_PATH];
	char sShootArrowSound[PLATFORM_MAX_PATH];
	char sShootManglerSound[PLATFORM_MAX_PATH];
	char sShootBaseballSound[PLATFORM_MAX_PATH];	
	char sJaratePlayerHitSound[PLATFORM_MAX_PATH];
	char sMilkPlayerHitSound[PLATFORM_MAX_PATH];
	char sGasPlayerHitSound[PLATFORM_MAX_PATH];
	char sStunPlayerHitSound[PLATFORM_MAX_PATH];
	char sEngineSound[PLATFORM_MAX_PATH];
	char sShockwaveBeam[PLATFORM_MAX_PATH];
	char sShockwaveHalo[PLATFORM_MAX_PATH];

	GetProfileString(sProfile, "cloak_on_sound", sCloakOnSound, sizeof(sCloakOnSound));
	GetProfileString(sProfile, "cloak_off_sound", sCloakOffSound, sizeof(sCloakOffSound));
	GetProfileString(sProfile, "rocket_shoot_sound", sShootRocketSound, sizeof(sShootRocketSound));
	GetProfileString(sProfile, "sentryrocket_shoot_sound", sShootSentryRocketSound, sizeof(sShootSentryRocketSound));
	GetProfileString(sProfile, "fire_shoot_sound", sShootFireballSound, sizeof(sShootFireballSound));
	GetProfileString(sProfile, "rocket_explode_sound", sRocketImpactSound, sizeof(sRocketImpactSound));
	GetProfileString(sProfile, "fire_explode_sound", sFireballImpactSound, sizeof(sFireballImpactSound));
	GetProfileString(sProfile, "fire_iceball_slow_sound", sIceballImpactSound, sizeof(sIceballImpactSound));
	GetProfileString(sProfile, "grenade_shoot_sound", sShootGrenadeSound, sizeof(sShootGrenadeSound));
	GetProfileString(sProfile, "arrow_shoot_sound", sShootArrowSound, sizeof(sShootArrowSound));
	GetProfileString(sProfile, "mangler_shoot_sound", sShootManglerSound, sizeof(sShootManglerSound));
	GetProfileString(sProfile, "baseball_shoot_sound", sShootBaseballSound, sizeof(sShootBaseballSound));
	GetProfileString(sProfile, "player_jarate_sound", sJaratePlayerHitSound, sizeof(sJaratePlayerHitSound));
	GetProfileString(sProfile, "player_milk_sound", sMilkPlayerHitSound, sizeof(sMilkPlayerHitSound));
	GetProfileString(sProfile, "player_gas_sound", sGasPlayerHitSound, sizeof(sGasPlayerHitSound));
	GetProfileString(sProfile, "player_stun_sound", sStunPlayerHitSound, sizeof(sStunPlayerHitSound));
	GetProfileString(sProfile, "engine_sound", sEngineSound, sizeof(sEngineSound));
	GetProfileString(sProfile, "shockwave_beam_sprite", sShockwaveBeam, sizeof(sShockwaveBeam));
	GetProfileString(sProfile, "shockwave_halo_sprite", sShockwaveHalo, sizeof(sShockwaveHalo));

	strcopy(g_sSlenderCloakOnSound[Npc.Index], sizeof(g_sSlenderCloakOnSound[]), sCloakOnSound);
	strcopy(g_sSlenderCloakOffSound[Npc.Index], sizeof(g_sSlenderCloakOffSound[]), sCloakOffSound);
	strcopy(g_sSlenderJarateHitSound[Npc.Index], sizeof(g_sSlenderJarateHitSound[]), sJaratePlayerHitSound);
	strcopy(g_sSlenderMilkHitSound[Npc.Index], sizeof(g_sSlenderMilkHitSound[]), sMilkPlayerHitSound);
	strcopy(g_sSlenderGasHitSound[Npc.Index], sizeof(g_sSlenderGasHitSound[]), sGasPlayerHitSound);
	strcopy(g_sSlenderStunHitSound[Npc.Index], sizeof(g_sSlenderStunHitSound[]), sStunPlayerHitSound);
	strcopy(g_sSlenderFireballExplodeSound[Npc.Index], sizeof(g_sSlenderFireballExplodeSound[]), sFireballImpactSound);
	strcopy(g_sSlenderFireballShootSound[Npc.Index], sizeof(g_sSlenderFireballShootSound[]), sShootFireballSound);
	strcopy(g_sSlenderIceballImpactSound[Npc.Index], sizeof(g_sSlenderIceballImpactSound[]), sIceballImpactSound);
	strcopy(g_sSlenderRocketExplodeSound[Npc.Index], sizeof(g_sSlenderRocketExplodeSound[]), sRocketImpactSound);
	strcopy(g_sSlenderRocketShootSound[Npc.Index], sizeof(g_sSlenderRocketShootSound[]), sShootRocketSound);
	strcopy(g_sSlenderGrenadeShootSound[Npc.Index], sizeof(g_sSlenderGrenadeShootSound[]), sShootGrenadeSound);
	strcopy(g_sSlenderSentryRocketShootSound[Npc.Index], sizeof(g_sSlenderSentryRocketShootSound[]), sShootSentryRocketSound);
	strcopy(g_sSlenderArrowShootSound[Npc.Index], sizeof(g_sSlenderArrowShootSound[]), sShootArrowSound);
	strcopy(g_sSlenderManglerShootSound[Npc.Index], sizeof(g_sSlenderManglerShootSound[]), sShootManglerSound);
	strcopy(g_sSlenderBaseballShootSound[Npc.Index], sizeof(g_sSlenderBaseballShootSound[]), sShootBaseballSound);
	strcopy(g_sSlenderEngineSound[Npc.Index], sizeof(g_sSlenderEngineSound[]), sEngineSound);
	strcopy(g_sSlenderShockwaveBeamSprite[Npc.Index], sizeof(g_sSlenderShockwaveBeamSprite[]), sShockwaveBeam);
	strcopy(g_sSlenderShockwaveHaloSprite[Npc.Index], sizeof(g_sSlenderShockwaveHaloSprite[]), sShockwaveHalo);

	g_hSlenderThink[Npc.Index] = CreateTimer(0.3, Timer_SlenderTeleportThink, Npc, TIMER_REPEAT);
	
	SlenderRemoveTargetMemory(Npc.Index);
	
	switch (iBossType)
	{
		case SF2BossType_Chaser:
		{
			NPCChaserOnSelectProfile(Npc.Index);
			
			SlenderCreateTargetMemory(Npc.Index);
		}
	}
	
	if (NpcCopyMaster.IsValid())
	{
		g_iSlenderCopyMaster[Npc.Index] = NpcCopyMaster.Index;
		g_flSlenderNextJumpScare[Npc.Index] = g_flSlenderNextJumpScare[NpcCopyMaster.Index];
		
		Npc.Anger = NpcCopyMaster.Anger;
	}
	else
	{
		if (bPlaySpawnSound)
		{
			char sBuffer[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_spawn_all", sBuffer, sizeof(sBuffer));
			if (sBuffer[0]) EmitSoundToAll(sBuffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
		}
		if(hTimerMusic==INVALID_HANDLE)
		{
			float time = GetProfileFloat(sProfile,"sound_music_loop",0.0);
			if(time > 0.0 && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNormal,sizeof(sCurrentMusicTrackNormal));
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNormal);
				
				GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
				if (!sCurrentMusicTrackHard[0]) GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
				
				GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
				if (!sCurrentMusicTrackInsane[0])
				{
					GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
					if (!sCurrentMusicTrackInsane[0])
					{
						GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
					}
				}
				
				GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
				if (!sCurrentMusicTrackNightmare[0])
				{
					GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
					if (!sCurrentMusicTrackNightmare[0])
					{
						GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
						if (!sCurrentMusicTrackNightmare[0])
						{
							GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
						}
					}
				}
				
				GetRandomStringFromProfile(sProfile,"sound_music_apollyon",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
				if (!sCurrentMusicTrackApollyon[0])
				{
					GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
					if (!sCurrentMusicTrackApollyon[0])
					{
						GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
						if (!sCurrentMusicTrackApollyon[0])
						{
							GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
							if (!sCurrentMusicTrackApollyon[0])
							{
								GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
							}
						}
					}
				}

				hTimerMusic = CreateTimer(time,BossMusic,Npc.Index);
				for(int client = 1;client <=MaxClients;client ++)
				{
					if(IsValidClient(client) && !g_bPlayerEliminated[client])
					{
						ClientChaseMusicReset(client);
						ClientChaseMusicSeeReset(client);
						ClientAlertMusicReset(client);
						ClientStopAllSlenderSounds(client, sProfile, "sound_chase_music", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(client, sProfile, "sound_alert_music", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(client, sProfile, "sound_chase_visible", SNDCHAN_AUTO);
						if (g_strPlayerMusic[client][0]) EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.0001);
						StopSound(client, MUSIC_CHAN, sCurrentMusicTrack);
						ClientMusicStart(client, sCurrentMusicTrack, _, MUSIC_PAGE_VOLUME,true);
						ClientUpdateMusicSystem(client);
					}
				}
			}
		}
		if (bSpawnCompanions)
		{
			KvRewind(g_hConfig);
			KvJumpToKey(g_hConfig, sProfile);
			
			char sCompProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			Handle hCompanions = CreateArray(SF2_MAX_PROFILE_NAME_LENGTH);
			
			if (KvJumpToKey(g_hConfig, "companions"))
			{
				char sNum[32];
				
				for (int i = 1;;i++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", i);
					KvGetString(g_hConfig, sNum, sCompProfile, sizeof(sCompProfile));
					if (!sCompProfile[0]) break;
					
					PushArrayString(hCompanions, sCompProfile);
				}
			}
			
			for (int i = 0, iSize = GetArraySize(hCompanions); i < iSize; i++)
			{
				GetArrayString(hCompanions, i, sCompProfile, sizeof(sCompProfile));
				AddProfile(sCompProfile, _, _, false, false);
			}
			
			delete hCompanions;
		}
	}
	
	Call_StartForward(fOnBossAdded);
	Call_PushCell(Npc.Index);
	Call_Finish();
	
	return true;
}
//SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC) <= Bug?
SF2NPC_BaseNPC AddProfile(const char[] strName,int iAdditionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool bSpawnCompanions=true, bool bPlaySpawnSound=true)
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
		if (!Npc.IsValid())
		{
			if (SelectProfile(Npc, strName, iAdditionalBossFlags, NpcCopyMaster, bSpawnCompanions, bPlaySpawnSound))
			{
				return Npc;
			}
			
			break;
		}
	}
	
	return SF2_INVALID_NPC;
}

void ChangeAllSlenderModels()
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	char sBuffer[PLATFORM_MAX_PATH];
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{	
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		if (NPCGetType(iNPCIndex) != SF2BossType_Chaser) continue;
		int slender = NPCGetEntIndex(iNPCIndex);
		if (!slender || slender == INVALID_ENT_REFERENCE) continue;
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
		switch (iDifficulty)
		{
			case Difficulty_Normal: GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
			case Difficulty_Hard:
			{
				GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
				if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
			}
			case Difficulty_Insane:
			{
				GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
				if (!sBuffer[0])
				{
					GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
				}
			}
			case Difficulty_Nightmare:
			{
				GetProfileString(sProfile, "model_nightmare", sBuffer, sizeof(sBuffer));
				if (!sBuffer[0])
				{
					GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0])
					{
						GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
						if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
					}
				}
			}
			case Difficulty_Apollyon:
			{
				GetProfileString(sProfile, "model_apollyon", sBuffer, sizeof(sBuffer));
				if (!sBuffer[0])
				{
					GetProfileString(sProfile, "model_nightmare", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0])
					{
						GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
						if (!sBuffer[0])
						{
							GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
							if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
						}
					}
				}
			}
		}
		DispatchKeyValue(slender,       "model",      sBuffer);
	}
}

void RemoveProfile(int iBossIndex)
{
	RemoveSlender(iBossIndex);
	
	// Call our forward.
	Call_StartForward(fOnBossRemoved);
	Call_PushCell(iBossIndex);
	Call_Finish();
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	NPCChaserOnRemoveProfile(iBossIndex);

	// Remove all possible sounds, for emergencies.
	if (!MusicActive())
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i)) continue;
			
			// Remove chase music.
			if (g_iPlayerChaseMusicMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}
			
			// Don't forget search theme
			if(g_iPlayerAlertMusicMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}
			
			if(g_iPlayerChaseMusicSeeMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}
			ClientUpdateMusicSystem(i);
		}
	}

	// Clean up on the clients.
	for (int i = 1; i <= MaxClients; i++)
	{
		g_flSlenderLastFoundPlayer[iBossIndex][i] = -1.0;
		g_flPlayerLastChaseBossEncounterTime[i][iBossIndex] = -1.0;
		g_flSlenderTeleportPlayersRestTime[iBossIndex][i] = -1.0;
		
		for (int i2 = 0; i2 < 3; i2++)
		{
			g_flSlenderLastFoundPlayerPos[iBossIndex][i][i2] = 0.0;
		}
		
		if (IsClientInGame(i))
		{
			if (NPCGetUniqueID(iBossIndex) == g_iPlayerStaticMaster[i])
			{
				g_iPlayerStaticMaster[i] = -1;
				
				// No one is the static master.
				g_hPlayerStaticTimer[i] = CreateTimer(g_flPlayerStaticDecreaseRate[i], 
					Timer_ClientDecreaseStatic, 
					GetClientUserId(i), 
					TIMER_REPEAT);
					
				TriggerTimer(g_hPlayerStaticTimer[i], true);
			}
		}
	}
	
	g_iNPCTeleportType[iBossIndex] = -1;
	g_iSlenderTeleportTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_iSlenderProxyTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_flSlenderTeleportMaxTargetStress[iBossIndex] = 9999.0;
	g_flSlenderTeleportMaxTargetTime[iBossIndex] = -1.0;
	g_flSlenderNextTeleportTime[iBossIndex] = -1.0;
	g_flSlenderTeleportTargetTime[iBossIndex] = -1.0;
	g_flSlenderTimeUntilKill[iBossIndex] = -1.0;

	// Remove all copies associated with me.
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (i == iBossIndex || NPCGetUniqueID(i) == -1) continue;
		
		if (g_iSlenderCopyMaster[i] == iBossIndex)
		{
			LogMessage("Removed boss index %d because it is a copy of boss index %d", i, iBossIndex);
			NPCRemove(i);
		}
	}

	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCSearchRadius[iBossIndex][iDifficulty] = 0.0;
		g_flNPCHearingRadius[iBossIndex][iDifficulty] = 0.0;
	}
	
	NPCSetProfile(iBossIndex, "");
	g_iNPCType[iBossIndex] = -1;
	g_iNPCProfileIndex[iBossIndex] = -1;
	g_iNPCUniqueProfileIndex[iBossIndex] = -1;
	
	NPCSetFlags(iBossIndex, 0);
	
	NPCSetAnger(iBossIndex, 1.0);
	
	g_flNPCFieldOfView[iBossIndex] = 0.0;
	g_flNPCBackstabFOV[iBossIndex] = 0.0;
	
	g_flNPCAddSpeed[iBossIndex] = 0.0;
	g_flNPCAddMaxSpeed[iBossIndex] = 0.0;
	
	g_iNPCEnemy[iBossIndex] = INVALID_ENT_REFERENCE;
	
	NPCSetDeathCamEnabled(iBossIndex, false);
	
	g_iSlenderCopyMaster[iBossIndex] = -1;
	g_iNPCUniqueID[iBossIndex] = -1;
	g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
	g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderLaserTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderChaseInitialTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderRage1Timer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderRage2Timer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderRage3Timer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderHealTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderHealDelayTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderHealEventTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderStartFleeTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderSpawnTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderDeathCamTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderThink[iBossIndex] = INVALID_HANDLE;
	g_hSlenderEntityThink[iBossIndex] = INVALID_HANDLE;
	g_hNPCResetAlertCopyTimer[iBossIndex] = INVALID_HANDLE;
	g_hNPCRegisterAlertingCopiesTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderBurnTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderBleedTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderMarkedTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderMilkedTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderJarateTimer[iBossIndex] = INVALID_HANDLE;
	g_hSlenderGasTimer[iBossIndex] = INVALID_HANDLE;
	g_flSlenderStopBurning[iBossIndex] = 0.0;
	g_flSlenderStopBleeding[iBossIndex] = 0.0;
	g_bSlenderIsBurning[iBossIndex] = false;
	g_bSlenderIsMarked[iBossIndex] = false;
	g_bSlenderIsMilked[iBossIndex] = false;
	g_bSlenderIsGassed[iBossIndex] = false;
	g_bSlenderIsJarate[iBossIndex] = false;
	g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	
	g_hSlenderFakeTimer[iBossIndex] = INVALID_HANDLE;
	g_flSlenderLastKill[iBossIndex] = -1.0;
	g_iSlenderState[iBossIndex] = STATE_IDLE;
	g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_iSlenderModel[iBossIndex] = INVALID_ENT_REFERENCE;
	g_flSlenderAcceleration[iBossIndex] = 0.0;
	g_flNPCAnger[iBossIndex] = 0.0;
	g_flNPCAngerAddOnPageGrab[iBossIndex] = 0.0;
	g_flNPCAngerAddOnPageGrabTimeDiff[iBossIndex] = 0.0;
	g_bSlenderBoxingBossIsKilled[iBossIndex] = false;
	g_flSlenderTimeUntilNextProxy[iBossIndex] = -1.0;
	g_flNPCInstantKillRadius[iBossIndex] = 0.0;
	g_flNPCScareRadius[iBossIndex] = 0.0;
	g_flSlenderProxyTeleportMinRange[iBossIndex] = 0.0;
	g_flSlenderProxyTeleportMaxRange[iBossIndex] = 0.0;
	g_iNPCPlayerScareVictin[iBossIndex] = INVALID_ENT_REFERENCE;
	g_bNPCChasingScareVictin[iBossIndex] = false;
	g_bNPCLostChasingScareVictim[iBossIndex] = false;
	g_bNPCVelocityCancel[iBossIndex] = false;

	g_hBossChaserPathLogic[iBossIndex].ResetPathing();

	for (int i = 0; i < 3; i++)
	{
		g_flSlenderDetectMins[iBossIndex][i] = 0.0;
		g_flSlenderDetectMaxs[iBossIndex][i] = 0.0;
		g_flSlenderEyePosOffset[iBossIndex][i] = 0.0;
	}
	
	SlenderRemoveTargetMemory(iBossIndex);
}

void SpawnSlender(SF2NPC_BaseNPC Npc, const float pos[3])
{
	if (g_bRoundGrace) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.UnSpawn();
	Npc.GetProfile(sProfile,sizeof(sProfile));
	
	float flTruePos[3], flVecAng[3];
	flVecAng[1] = GetRandomFloat(0.0, 360.0);
	GetProfileVector(sProfile, "pos_offset", flTruePos);
	AddVectors(flTruePos, pos, flTruePos);
	
	int iBossIndex = Npc.Index;
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	char sBuffer[PLATFORM_MAX_PATH];
	
	switch (NPCGetType(iBossIndex))
	{
		case SF2BossType_Creeper:
		{
			int iSlenderModel = SpawnSlenderModel(iBossIndex, flTruePos);
			if (iSlenderModel == -1) 
			{
				LogError("Could not spawn boss: model failed to spawn!");
				return;
			}
			g_iSlenderModel[iBossIndex] = EntIndexToEntRef(iSlenderModel);
			g_iSlender[iBossIndex] = g_iSlenderModel[iBossIndex];
			g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderBlinkBossThink, g_iSlender[iBossIndex], TIMER_REPEAT);
	
			// Initialize our pose parameters, if needed.
			int iPose = EntRefToEntIndex(g_iSlenderPoseEnt[iBossIndex]);
			g_iSlenderPoseEnt[iBossIndex] = INVALID_ENT_REFERENCE;
			if (iPose && iPose != INVALID_ENT_REFERENCE)
			{
				RemoveEntity(iPose);
			}
			
			char sPoseParameter[64];
			GetProfileString(sProfile, "pose_parameter", sPoseParameter, sizeof(sPoseParameter));
			if (sPoseParameter[0])
			{
				iPose = CreateEntityByName("point_posecontroller");
				if (iPose != -1)
				{
					// We got a pose parameter! We need a name!
					FormatEx(sBuffer, sizeof(sBuffer), "s%dposepls", g_iSlenderModel[iBossIndex]);
					DispatchKeyValue(iSlenderModel, "targetname", sBuffer);
					
					DispatchKeyValue(iPose, "PropName", sBuffer);
					DispatchKeyValue(iPose, "PoseParameterName", sPoseParameter);
					DispatchKeyValueFloat(iPose, "PoseValue", GetProfileFloat(sProfile, "pose_parameter_max"));
					DispatchSpawn(iPose);
					SetVariantString(sPoseParameter);
					AcceptEntityInput(iPose, "SetPoseParameterName");
					SetVariantString("!activator");
					AcceptEntityInput(iPose, "SetParent", iSlenderModel);
					
					g_iSlenderPoseEnt[iBossIndex] = EntIndexToEntRef(iPose);
				}
			}
			if (view_as<bool>(GetProfileNum(sProfile,"tp_effect_spawn",0))) SlenderCreateParticleSpawnEffect(iBossIndex, "tp_effect_spawn_particle", "tp_effect_spawn_sound", "tp_effect_origin");
		}
		case SF2BossType_Chaser:
		{
			switch (iDifficulty)
			{
				case Difficulty_Normal: GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
				case Difficulty_Hard:
				{
					GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
				}
				case Difficulty_Insane:
				{
					GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0])
					{
						GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
						if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
					}
				}
				case Difficulty_Nightmare:
				{
					GetProfileString(sProfile, "model_nightmare", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0])
					{
						GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
						if (!sBuffer[0])
						{
							GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
							if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
						}
					}
				}
				case Difficulty_Apollyon:
				{
					GetProfileString(sProfile, "model_apollyon", sBuffer, sizeof(sBuffer));
					if (!sBuffer[0])
					{
						GetProfileString(sProfile, "model_nightmare", sBuffer, sizeof(sBuffer));
						if (!sBuffer[0])
						{
							GetProfileString(sProfile, "model_insane", sBuffer, sizeof(sBuffer));
							if (!sBuffer[0])
							{
								GetProfileString(sProfile, "model_hard", sBuffer, sizeof(sBuffer));
								if (!sBuffer[0]) GetProfileString(sProfile, "model", sBuffer, sizeof(sBuffer));
							}
						}
					}
				}
			}
			
			int iBoss = CreateEntityByName("base_boss");
			DispatchKeyValueVector(iBoss, "origin",     flTruePos);
			DispatchKeyValueVector(iBoss, "angles",     flVecAng);
			DispatchKeyValue(iBoss,       "model",      sBuffer);
			if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
			{
				float flScaleModel = NPCGetModelScale(iBossIndex) * 0.5;
				FloatToString(flScaleModel, sBuffer, sizeof(sBuffer));
				DispatchKeyValue(iBoss,       "modelscale", sBuffer);
			}
			else
			{
				FloatToString(NPCGetModelScale(iBossIndex), sBuffer, sizeof(sBuffer));
				DispatchKeyValue(iBoss,       "modelscale", sBuffer);
			}
			FormatEx(sBuffer, sizeof(sBuffer), "%d", NPCGetHealth(iBossIndex));
			DispatchKeyValue(iBoss,       "health",     sBuffer);
			DispatchSpawn(iBoss);
			
			g_INextBot[iBossIndex] = SF2_GetEntityNextBotInterface(iBoss);
			g_ILocomotion[iBossIndex] = view_as<NextBotGroundLocomotion>(g_INextBot[iBossIndex].GetLocomotionInterface());
			g_IBody[iBossIndex] = g_INextBot[iBossIndex].GetBodyInterface();
			
			// Nextbot logic override
			DHookRaw(g_hGetAcceleration, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			DHookRaw(g_hGetMaxDeceleration, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			DHookRaw(g_hIsAbleToJumpAcrossGaps, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			DHookRaw(g_hGetStepHeight, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			DHookRaw(g_hGetMaxJumpHeight, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			DHookRaw(g_hGetGravity, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			if (!view_as<bool>(GetProfileNum(sProfile,"enable_boss_tilting",0)))
			{
				DHookRaw(g_hGetGroundNormal, false, view_as<Address>(g_ILocomotion[iBossIndex]));
			}
			DHookRaw(g_hShouldCollide, true, view_as<Address>(g_ILocomotion[iBossIndex]));
			// IBody detour
			DHookRaw(g_hStartActivity, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetHullWidth, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetHullHeight, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetStandHullHeight, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetCrouchHullHeight, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetHullMins, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetHullMaxs, false, view_as<Address>(g_IBody[iBossIndex]));
			DHookRaw(g_hGetSolidMask, false, view_as<Address>(g_IBody[iBossIndex]));
			if (NPCGetHealth(iBossIndex) < 30000)
			{
				DHookEntity(g_hGetCurrencyValue, true, iBoss);
			}

			SetEntityFlags(iBoss, FL_NPC);
		
			ActivateEntity(iBoss);
			if (NPCGetRaidHitbox(iBossIndex) == 1)
			{
				SetEntPropVector(iBoss, Prop_Send, "m_vecMins", g_flSlenderDetectMins[iBossIndex]);
				SetEntPropVector(iBoss, Prop_Send, "m_vecMaxs", g_flSlenderDetectMaxs[iBossIndex]);
				
				SetEntPropVector(iBoss, Prop_Send, "m_vecMinsPreScaled", g_flSlenderDetectMins[iBossIndex]);
				SetEntPropVector(iBoss, Prop_Send, "m_vecMaxsPreScaled", g_flSlenderDetectMaxs[iBossIndex]);
			}
			else if (NPCGetRaidHitbox(iBossIndex) == 0)
			{
				SetEntPropVector(iBoss, Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
				SetEntPropVector(iBoss, Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);
				
				SetEntPropVector(iBoss, Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
				SetEntPropVector(iBoss, Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
			}
			
			if (NPCGetModelSkinMax(iBossIndex) > 0)
			{
				int iRandomSkin = GetRandomInt(0, NPCGetModelSkinMax(iBossIndex));
				SetEntProp(iBoss, Prop_Send, "m_nSkin", iRandomSkin);
			}
			else
			{
				SetEntProp(iBoss, Prop_Send, "m_nSkin", NPCGetModelSkin(iBossIndex));
			}

			if (!g_cvDisableBossCrushFix.BoolValue) SetEntData(iBoss, FindSendPropInfo("CTFBaseBoss", "m_lastHealthPercentage") + 28, false, 4, true);

			SDKHook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);

			// Reset stats.
			g_bSlenderInBacon[iBossIndex] = false;
			g_iSlender[iBossIndex] = EntIndexToEntRef(iBoss);
			g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_iSlenderState[iBossIndex] = STATE_IDLE;
			g_bSlenderAttacking[iBossIndex] = false;
			g_bSlenderGiveUp[iBossIndex] = false;
			g_hSlenderAttackTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderLaserTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderBackupAtkTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderChaseInitialTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderRage1Timer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderRage2Timer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderRage3Timer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderHealTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderHealDelayTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderHealEventTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderStartFleeTimer[iBossIndex] = INVALID_HANDLE;
			g_flSlenderTargetSoundLastTime[iBossIndex] = -1.0;
			g_flSlenderTargetSoundDiscardMasterPosTime[iBossIndex] = -1.0;
			g_iSlenderTargetSoundType[iBossIndex] = SoundType_None;
			g_bSlenderInvestigatingSound[iBossIndex] = false;
			g_flSlenderNextStunTime[iBossIndex] = -1.0;
			g_flSlenderNextCloakTime[iBossIndex] = -1.0;
			g_bNPCHasCloaked[iBossIndex] = false;
			g_flSlenderLastHeardFootstep[iBossIndex] = 0.0;
			g_flSlenderLastHeardVoice[iBossIndex] = 0.0;
			g_flSlenderLastHeardWeapon[iBossIndex] = 0.0;
			g_flSlenderNextVoiceSound[iBossIndex] = 0.0;
			g_flSlenderNextFootstepAttackSound[iBossIndex] = 0.0;
			g_flSlenderNextFootstepIdleSound[iBossIndex] = 0.0;
			g_flSlenderNextFootstepRunSound[iBossIndex] = 0.0;
			g_flSlenderNextFootstepStunSound[iBossIndex] = 0.0;
			g_flSlenderNextFootstepWalkSound[iBossIndex] = 0.0;
			g_flSlenderNextMoanSound[iBossIndex] = 0.0;
			
			for (int iDifficulty2 = 0; iDifficulty2 < Difficulty_Max; iDifficulty2++)
			{
				g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + NPCGetIdleLifetime(iBossIndex, iDifficulty2);
				float flMin = GetChaserProfileWanderTimeMin(NPCGetUniqueProfileIndex(iBossIndex), iDifficulty2);
				float flMax = GetChaserProfileWanderTimeMax(NPCGetUniqueProfileIndex(iBossIndex), iDifficulty2);
				g_flSlenderNextWanderPos[iBossIndex][iDifficulty2] = GetGameTime() + GetRandomFloat(flMin, flMax);
			}
			
			g_flSlenderTimeUntilRecover[iBossIndex] = -1.0;
			g_flSlenderTimeUntilAlert[iBossIndex] = -1.0;
			g_flSlenderTimeUntilIdle[iBossIndex] = -1.0;
			g_flSlenderTimeUntilChase[iBossIndex] = -1.0;
			g_flSlenderTimeUntilNoPersistence[iBossIndex] = -1.0;
			g_flSlenderTimeUntilAttackEnd[iBossIndex] = -1.0;
			g_flSlenderNextPathTime[iBossIndex] = 0.0;
			g_flSlenderLastCalculPathTime[iBossIndex] = -1.0;
			g_flLastStuckTime[iBossIndex] = -1.0;
			g_iSlenderInterruptConditions[iBossIndex] = 0;
			g_bSlenderChaseDeathPosition[iBossIndex] = false;
			g_iNPCPlayerScareVictin[iBossIndex] = INVALID_ENT_REFERENCE;
			g_bNPCChasingScareVictin[iBossIndex] = false;
			g_bNPCLostChasingScareVictim[iBossIndex] = false;
			g_bNPCAlertedCopy[iBossIndex] = false;
			g_bNPCStopAlertingCopies[iBossIndex] = false;
			g_hNPCResetAlertCopyTimer[iBossIndex] = INVALID_HANDLE;
			g_hNPCRegisterAlertingCopiesTimer[iBossIndex] = INVALID_HANDLE;
			g_bNPCVelocityCancel[iBossIndex] = false;
			g_hSlenderBurnTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderBleedTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderMarkedTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderMilkedTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderGasTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderJarateTimer[iBossIndex] = INVALID_HANDLE;
			g_hSlenderDeathCamTimer[iBossIndex] = INVALID_HANDLE;
			g_flSlenderStopBurning[iBossIndex] = 0.0;
			g_flSlenderStopBleeding[iBossIndex] = 0.0;
			g_bSlenderIsBurning[iBossIndex] = false;
			g_bSlenderIsMarked[iBossIndex] = false;
			g_bSlenderIsMilked[iBossIndex] = false;
			g_bSlenderIsGassed[iBossIndex] = false;
			g_bSlenderIsJarate[iBossIndex] = false;
			g_flNPCAddSpeed[iBossIndex] = 0.0;
			g_iSlenderAutoChaseCount[iBossIndex] = 0;
			g_flSlenderAutoChaseCooldown[iBossIndex] = 0.0;
			g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_bAutoChasingLoudPlayer[iBossIndex] = false;
			g_bSlenderInDeathcam[iBossIndex] = false;

			Spawn_Chaser(iBossIndex);
			
			NPCChaserResetAnimationInfo(iBossIndex, 0);
			
			if (view_as<bool>(GetProfileNum(sProfile,"spawn_animation",0)))
			{
				SlenderPerformVoice(iBossIndex, "sound_spawn_local");
				g_bSlenderSpawning[iBossIndex] = true;
				g_hSlenderSpawnTimer[iBossIndex] = CreateTimer(GetProfileFloat(sProfile, "spawn_timer", 0.0), Timer_SlenderSpawnTimer, EntIndexToEntRef(iBoss));
				NPCChaserUpdateBossAnimation(iBossIndex, iBoss, STATE_IDLE, true);
			}
			else
			{
				g_bSlenderSpawning[iBossIndex] = false;
				g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(iBoss), TIMER_REPEAT);
				NPCChaserUpdateBossAnimation(iBossIndex, iBoss, STATE_IDLE);
			}
			
			for (int i = 0; i < 3; i++)
			{
				g_flSlenderGoalPos[iBossIndex][i] = 0.0;
				g_flSlenderTargetSoundTempPos[iBossIndex][i] = 0.0;
				g_flSlenderTargetSoundMasterPos[iBossIndex][i] = 0.0;
				g_flSlenderChaseDeathPosition[iBossIndex][i] = 0.0;
			}
			
			for (int i = 1; i <= MaxClients; i++)
			{
				g_flSlenderLastFoundPlayer[iBossIndex][i] = -1.0;
				
				for (int i2 = 0; i2 < 3; i2++)
				{
					g_flSlenderLastFoundPlayerPos[iBossIndex][i][i2] = 0.0;
				}
			}
			
			SlenderClearTargetMemory(iBossIndex);
			
			/*if (GetProfileNum(sProfile, "stun_enabled"))
			{
				SetEntProp(iBoss, Prop_Data, "m_takedamage", 1);
			}
			
			SDKHook(iBoss, SDKHook_OnTakeDamage, Hook_SlenderOnTakeDamage);*/

			//(Experimental)
			if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
			{
				//The boss spawned for the 1st time, block now its teleportation ability to prevent healthbar conflict.
				NPCSetFlags(iBossIndex,NPCGetFlags(iBossIndex)|SFF_NOTELEPORT);
				UpdateHealthBar(iBossIndex);
			}
			if(view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)) && g_sSlenderEngineSound[iBossIndex][0])
			{
				EmitSoundToAll(g_sSlenderEngineSound[iBossIndex], iBoss, SNDCHAN_STATIC, 83, _, 0.8);
			}
			if (SF_BossesChaseEndlessly() || SF_IsRaidMap())
			{
				NPCSetFlags(iBossIndex,NPCGetFlags(iBossIndex)|SFF_NOTELEPORT);
			}
			
			//Stun Health
			float flMaxHealth = NPCChaserGetStunInitialHealth(iBossIndex);
			int iHealth = 0;
			for(int iClient=1; iClient<=MaxClients; iClient++)
			{
				if(IsValidClient(iClient) && !g_bPlayerEliminated[iClient] && IsPlayerAlive(iClient))
				{
					char sClassName[64], sSectionName[64];
					TF2_GetClassName(TF2_GetPlayerClass(iClient), sClassName, sizeof(sClassName));
					FormatEx(sSectionName, sizeof(sSectionName), "stun_health_per_%s", sClassName);
					iHealth = GetProfileNum(sProfile, sSectionName, 0);
					if(iHealth>0)
					{
						flMaxHealth += float(iHealth);
					}
					if (SF_IsBoxingMap() && strcmp(sClassName, "scout", false) == 0)
					{
						NPCSetAddSpeed(iBossIndex, 10.0);
						NPCSetAddMaxSpeed(iBossIndex, 15.0);
					}
					else
					{
						iHealth = GetProfileNum(sProfile, "stun_health_per_player", 0);
						flMaxHealth += float(iHealth);
					}
				}
			}
			NPCChaserSetStunInitialHealth(iBossIndex, flMaxHealth);
			NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
			SetEntProp(iBoss, Prop_Data, "m_iHealth", RoundToCeil(flMaxHealth+30000.0));
			SetEntProp(iBoss, Prop_Data, "m_iMaxHealth", RoundToCeil(flMaxHealth+30000.0));
			SetEntProp(iBoss, Prop_Data, "m_initialHealth", RoundToCeil(flMaxHealth+30000.0));
			if (view_as<bool>(GetProfileNum(sProfile,"tp_effect_spawn",0))) SlenderCreateParticleSpawnEffect(iBossIndex, "tp_effect_spawn_particle", "tp_effect_spawn_sound", "tp_effect_origin");
		}
		/*
		default:
		{
			g_iSlender[iBossIndex] = g_iSlenderModel[iBossIndex];
			SDKHook(iSlenderModel, SDKHook_SetTransmit, Hook_SlenderSetTransmit);
		}
		*/
	}
	if (NPCGetCustomOutlinesState(iBossIndex))
	{
		int color[4];
		color[0] = NPCGetOutlineColorR(iBossIndex);
		color[1] = NPCGetOutlineColorG(iBossIndex);
		color[2] = NPCGetOutlineColorB(iBossIndex);
		color[3] = NPCGetOutlineTransparency(iBossIndex);
		if (color[0] < 0) color[0] = 0;
		if (color[1] < 0) color[1] = 0;
		if (color[2] < 0) color[2] = 0;
		if (color[3] < 0) color[3] = 0;
		if (color[0] > 255) color[0] = 255;
		if (color[1] > 255) color[1] = 255;
		if (color[2] > 255) color[2] = 255;
		if (color[3] > 255) color[3] = 255;
		SlenderAddGlow(iBossIndex,_,color);
	}
	else
	{
		int iPurple[4] = {150, 0, 255, 255};
		SlenderAddGlow(iBossIndex,_,iPurple);
	}
	
	SlenderSpawnEffects(iBossIndex, EffectEvent_Constant);
	
	if (EntRefToEntIndex(g_iSlender[iBossIndex]) > MaxClients)
	{
		// Call our forward.
		Call_StartForward(fOnBossSpawn);
		Call_PushCell(iBossIndex);
		Call_Finish();
	}
}

void RemoveSlender(int iBossIndex)
{
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iBoss = NPCGetEntIndex(iBossIndex);

	if (iBoss && iBoss != INVALID_ENT_REFERENCE)
	{
		Call_StartForward(fOnBossDespawn);
		Call_PushCell(iBossIndex);
		Call_Finish();
	
		//Turn off all slender's effects in order to prevent some bugs.
		SlenderRemoveEffects(iBoss, true);
		// Stop all possible looping sounds.
		ClientStopAllSlenderSounds(iBoss, sProfile, "sound_move", SNDCHAN_AUTO);

		if (view_as<bool>(GetProfileNum(sProfile,"tp_effect_despawn",0))) SlenderCreateParticleSpawnEffect(iBossIndex, "tp_effect_despawn_particle", "tp_effect_despawn_sound", "tp_effect_origin");
		
		if(view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)) && g_sSlenderEngineSound[iBossIndex][0])
		{
			StopSound(iBoss, SNDCHAN_STATIC, g_sSlenderEngineSound[iBossIndex]);
		}
		
		if (NPCGetFlags(iBossIndex) & SFF_HASSTATICLOOPLOCALSOUND)
		{
			char sLoopSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
			
			if (sLoopSound[0])
			{
				StopSound(iBoss, SNDCHAN_STATIC, sLoopSound);
			}
		}
		int iBossFlags = NPCGetFlags(iBossIndex);
		if (SF_IsRaidMap() || SF_BossesChaseEndlessly() && !view_as<bool>(GetProfileNum(sProfile,"healthbar",0)))
		{
			NPCSetFlags(iBossIndex, iBossFlags & ~SFF_NOTELEPORT);
		}
		
		g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
		RemoveEntity(iBoss);
	}
	else 
	{
		g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
	}

	if (IsValidEntity(iBoss))
		RemoveEntity(iBoss);
}

public Action Event_HitBoxHurt(Handle event, const char[] name, bool dB)
{
	if (!g_bEnabled) return;
	
	int hitbox = GetEventInt(event, "entindex");
	if(IsValidEntity(hitbox))
	{
		char sClass[64];
		GetEntityNetClass(hitbox, sClass, sizeof(sClass));
		if (strcmp(sClass, "CTFBaseBoss", false) == 0)
		{
			float flMyPos[3], flMyEyeAng[3], flClientPos[3], flBuffer[3], flTraceStartPos[3], flTraceEndPos[3];
			GetEntPropVector(hitbox, Prop_Data, "m_vecAbsOrigin", flMyPos);
			
			int iBossIndex = NPCGetFromEntIndex(hitbox);
			if (iBossIndex == -1) return;
			int slender = NPCGetEntIndex(iBossIndex);
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
			
			NPCGetEyePosition(iBossIndex, flTraceStartPos);

			int damagetype = DMG_BULLET;
			bool bMiniCrit = false;
			int damage = GetEventInt(event, "damageamount");
			int attacker = GetClientOfUserId(GetEventInt(event, "attacker_player"));
			if (IsValidClient(attacker))
			{
				GetClientAbsOrigin(attacker, flClientPos);
				GetClientEyePosition(attacker, flTraceEndPos);
			}
			float flShootDist = GetVectorSquareMagnitude(flClientPos, flMyPos);
			GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flMyEyeAng);
			
			AddVectors(flMyEyeAng, g_flSlenderEyeAngOffset[iBossIndex], flMyEyeAng);
			for (int i = 0; i < 3; i++) flMyEyeAng[i] = AngleNormalize(flMyEyeAng[i]);

			if(!IsValidClient(attacker)) return;

			if ((g_bSlenderIsMilked[iBossIndex] || TF2_IsPlayerInCondition(attacker, TFCond_RegenBuffed)) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
			{
				int iHealth = GetClientHealth(attacker);
				float flDamage = float(damage);
				flDamage *= 0.475;
				int iNewHealth = iHealth + RoundToCeil(flDamage);
				if(iNewHealth<=GetEntProp(attacker, Prop_Data, "m_iMaxHealth"))
				{
					SetEntityHealth(attacker, iNewHealth);
				}
				else
				{
					int iMaxHealth = GetEntProp(attacker, Prop_Data, "m_iMaxHealth");
					SetEntityHealth(attacker, iMaxHealth);
				}
			}
			if (g_bSlenderIsGassed[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
			{
				g_hSlenderBurnTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBurn, EntIndexToEntRef(slender), TIMER_REPEAT);
				g_flSlenderStopBurning[iBossIndex] = GetGameTime() + 15.0;
				g_bSlenderIsBurning[iBossIndex] = true;
				g_bSlenderIsGassed[iBossIndex] = false;
				g_hSlenderGasTimer[iBossIndex] = INVALID_HANDLE;
			}
			
			if(TF2_GetPlayerClass(attacker) == TFClass_Scout)
			{
				int iStick = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 349 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsBurning[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					SetEventBool(event, "crit", true);
					damagetype |= DMG_CRIT;
					damage *= 3;
				}
				if(IsValidEntity(iStick) && (GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 325 || GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 452) && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT);
					g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
				}
				if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 355 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderMarkedTimer[iBossIndex] = CreateTimer(15.0, Timer_BossMarked, EntIndexToEntRef(slender));
					g_bSlenderIsMarked[iBossIndex] = true;
				}
				if(IsValidEntity(iStick) && GetEntProp(iStick, Prop_Send, "m_iItemDefinitionIndex") == 648 && iStick == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && flShootDist > SquareFloat(72.0) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT);
					g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Pyro)
			{
				//Probably the only time where buffing the phlog is a good thing.
				int iPhlog = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Primary);
				int iFragment = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iPhlog) && GetEntProp(iPhlog, Prop_Send, "m_iItemDefinitionIndex") == TF_WEAPON_PHLOGISTINATOR && GetEntPropFloat(attacker, Prop_Send, "m_flNextRageEarnTime") <= GetGameTime() && !view_as<bool>(GetEntProp(attacker, Prop_Send, "m_bRageDraining")))
				{
					float fRage = GetEntPropFloat(attacker, Prop_Send, "m_flRageMeter");
					fRage += (float(damage) / 30.00);
					if (fRage > 100.0) fRage = 100.0;
					SetEntPropFloat(attacker, Prop_Send, "m_flRageMeter", fRage);
				}
				if(IsValidEntity(iFragment) && GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 348 && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBurnTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBurn, EntIndexToEntRef(slender), TIMER_REPEAT);
					g_flSlenderStopBurning[iBossIndex] = GetGameTime() + 15.0;
					g_bSlenderIsBurning[iBossIndex] = true;
				}
				if(IsValidEntity(iFragment) && (GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 38 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 457 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 1000) && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsBurning[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBurnTimer[iBossIndex] = INVALID_HANDLE;
					g_flSlenderStopBurning[iBossIndex] = GetGameTime();
					g_bSlenderIsBurning[iBossIndex] = false;
					bMiniCrit = true;
					float flDamageReturn = damage * 1.35;
					damage = RoundToFloor(flDamageReturn);
				}
				if(IsValidEntity(iFragment) && GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 1181 && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
				{
					TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				}
				if(IsValidEntity(iFragment) && (GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 813 || GetEntProp(iFragment, Prop_Send, "m_iItemDefinitionIndex") == 834) && iFragment == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && (g_bSlenderIsJarate[iBossIndex] || g_bSlenderIsMilked[iBossIndex] || g_bSlenderIsGassed[iBossIndex]))
				{
					SetEventBool(event, "crit", true);
					damagetype |= DMG_CRIT;
					damage *= 3;
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Soldier)
			{
				int iWhip = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iWhip) && GetEntProp(iWhip, Prop_Send, "m_iItemDefinitionIndex") == 447 && iWhip == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
				{
					TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Heavy)
			{
				int iGloves = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iGloves) && GetEntProp(iGloves, Prop_Send, "m_iItemDefinitionIndex") == 426 && iGloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon"))
				{
					TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
				}
				if(IsValidEntity(iGloves) && GetEntProp(iGloves, Prop_Send, "m_iItemDefinitionIndex") == 43 && iGloves == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && !IsClientCritBoosted(attacker) && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_iPlayerHitsToCrits[attacker]++;
					if (g_iPlayerHitsToCrits[attacker] == 5)
					{
						TF2_AddCondition(attacker, TFCond_CritOnFlagCapture, 5.0);
						g_iPlayerHitsToCrits[attacker] = 0;
					}
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Engineer)
			{
				int iWrench = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iWrench) && GetEntProp(iWrench, Prop_Send, "m_iItemDefinitionIndex") == 155 && iWrench == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT);
					g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 5.0;
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Sniper)
			{
				int iSharpy = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iSharpy) && GetEntProp(iSharpy, Prop_Send, "m_iItemDefinitionIndex") == 171 && iSharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_hSlenderBleedTimer[iBossIndex] = CreateTimer(0.5, Timer_BossBleed, EntIndexToEntRef(slender), TIMER_REPEAT);
					g_flSlenderStopBleeding[iBossIndex] = GetGameTime() + 6.0;
				}
				if(IsValidEntity(iSharpy) && GetEntProp(iSharpy, Prop_Send, "m_iItemDefinitionIndex") == 232 && iSharpy == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && g_bSlenderIsMarked[iBossIndex] && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					SetEventBool(event, "crit", true);
					damagetype |= DMG_CRIT;
					damage *= 3;
					bMiniCrit = false;
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_DemoMan)
			{
				int iSword = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				if(IsValidEntity(iSword) && (GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 132 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 266 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 482 || GetEntProp(iSword, Prop_Send, "m_iItemDefinitionIndex") == 1082) && iSword == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && SF_IsBoxingMap() && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					g_iPlayerHitsToHeads[attacker]++;
					if (g_iPlayerHitsToHeads[attacker] == 5)
					{
						if(!TF2_IsPlayerInCondition(attacker, TFCond_DemoBuff))
						{
							TF2_AddCondition(attacker, TFCond_DemoBuff, -1.0);
						}
						int iDecapitations = GetEntProp(attacker, Prop_Send, "m_iDecapitations");
						int iHealth = GetClientHealth(attacker);
						SetEntProp(attacker, Prop_Send, "m_iDecapitations", iDecapitations+1);
						SetEntityHealth(attacker, iHealth+15);
						TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 0.01);
						g_iPlayerHitsToHeads[attacker] = 0;
					}
				}
			}
			if(TF2_GetPlayerClass(attacker) == TFClass_Spy)
			{
				int iStabbingTime = GetPlayerWeaponSlot(attacker, TFWeaponSlot_Melee);
				char sWeaponClass[64];
				GetEdictClassname(iStabbingTime, sWeaponClass, sizeof(sWeaponClass));
				if (IsValidEntity(iStabbingTime) && iStabbingTime == GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon") && (strcmp(sWeaponClass, "tf_weapon_knife", false) == 0 || (TF2_GetPlayerClass(attacker) == TFClass_Spy && strcmp(sWeaponClass, "saxxy", false) == 0)) && SF_IsBoxingMap())
				{
					SubtractVectors(flTraceEndPos, flTraceStartPos, flBuffer);
					GetVectorAngles(flBuffer, flBuffer);

					if (FloatAbs(AngleDiff(flMyEyeAng[1], flBuffer[1])) >= (NPCGetBackstabFOV(iBossIndex) * 0.5) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && GetProfileFloat(sProfile, "backstab_damage_scale", 0.05) > 0.0)
					{
						SetEventBool(event, "crit", true);
						damagetype |= DMG_CRIT;
						EmitSoundToClient(attacker, "player/spy_shield_break.wav", _, _, SNDLEVEL_TRAFFIC, SND_NOFLAGS, 0.7, 100);
						SetEntPropFloat(iStabbingTime, Prop_Send, "m_flNextPrimaryAttack", GetGameTime() + 2.0);
						SetEntPropFloat(attacker, Prop_Send, "m_flNextAttack", GetGameTime() + 2.0);
						SetEntPropFloat(attacker, Prop_Send, "m_flStealthNextChangeTime", GetGameTime() + 2.0);
						int vm = GetEntPropEnt(attacker, Prop_Send, "m_hViewModel");
						if (vm > MaxClients)
						{
							int iMeleeIndex = GetEntProp(iStabbingTime, Prop_Send, "m_iItemDefinitionIndex");
							int anim = 41;
							switch (iMeleeIndex)
							{
								case 4, 194, 225, 356, 461, 574, 649, 665, 794, 803, 883, 892, 901, 910, 959, 968: anim = 15;
								case 638: anim = 31;
							}
							SetEntProp(vm, Prop_Send, "m_nSequence", anim);
							float flBackstabDamage = NPCChaserGetStunInitialHealth(iBossIndex) * GetProfileFloat(sProfile, "backstab_damage_scale", 0.05);
							int iDamageReturn = RoundToFloor(flBackstabDamage);
							damage = iDamageReturn;

							if (iMeleeIndex == 356) //Kunai
							{
								int iHealth = GetClientHealth(attacker) + 200;
								if(iHealth > 500)
								{
									iHealth = 500;
								}
								SetEntityHealth(attacker, iHealth);
							}
							switch (iMeleeIndex)
							{
								case 356: //Kunai
								{
									int iHealth = GetClientHealth(attacker) + 200;
									if(iHealth > 500)
									{
										iHealth = 500;
									}
									SetEntityHealth(attacker, iHealth);
								}
								case 461: //Big Earner
								{
									TF2_AddCondition(attacker, TFCond_SpeedBuffAlly, 4.0);
								}
							}
						}
					}
				}
			}

			//The crit boolean if for both mini crit and critical hit.
			if(GetEventBool(event, "crit", false))
			{
				if(IsClientCritBoosted(attacker))//Crit boosted
					damagetype |= DMG_CRIT;
				else if(TF2_IsMiniCritBuffed(attacker))//Mini crit boosted
					bMiniCrit = true;
				else //Random crit
					damagetype |= DMG_CRIT;
			}
			if ((g_bSlenderIsMarked[iBossIndex] || g_bSlenderIsJarate[iBossIndex]) && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
			{
				bMiniCrit = true;
				float flDamageReturn = damage * 1.35;
				damage = RoundToFloor(flDamageReturn);
			}
			if (IsValidClient(attacker) && ((SF_IsBoxingMap() && GetClientTeam(attacker) == TFTeam_Blue) || (g_bPlayerProxy[attacker])))
			{
				damage = 0;
			}
			Boss_HitBox_Damage(hitbox, attacker, float(damage), damagetype, bMiniCrit);
		}
	}
	delete event;
}

public Action Timer_BossBurn(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	if (!SF_IsBoxingMap()) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (GetGameTime() >= g_flSlenderStopBurning[iBossIndex])
	{
		g_hSlenderBurnTimer[iBossIndex] = INVALID_HANDLE;
		g_bSlenderIsBurning[iBossIndex] = false;
		return Plugin_Stop;
	}	
	int iState = g_iSlenderState[iBossIndex];

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (timer != g_hSlenderBurnTimer[iBossIndex]) return Plugin_Stop;
	if (NPCChaserIsStunEnabled(iBossIndex))
	{
		if (!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			float flBurnDamage = -4.0 * GetProfileFloat(sProfile,"fire_damage_multiplier", 1.0);
			NPCChaserAddStunHealth(iBossIndex, flBurnDamage);
		}
		if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			UpdateHealthBar(iBossIndex);
		}
	}
	return Plugin_Continue;
}

public Action Timer_BossBleed(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	if (!SF_IsBoxingMap()) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (GetGameTime() >= g_flSlenderStopBleeding[iBossIndex])
	{
		g_hSlenderBleedTimer[iBossIndex] = INVALID_HANDLE;
		return Plugin_Stop;
	}	
	int iState = g_iSlenderState[iBossIndex];

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (timer != g_hSlenderBleedTimer[iBossIndex]) return Plugin_Stop;
	if (NPCChaserIsStunEnabled(iBossIndex))
	{
		if (!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			NPCChaserAddStunHealth(iBossIndex, -4.0);
		}
		if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			UpdateHealthBar(iBossIndex);
		}
	}
	return Plugin_Continue;
}

public Action Timer_BossMarked(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	if (!SF_IsBoxingMap()) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	g_hSlenderMarkedTimer[iBossIndex] = INVALID_HANDLE;
	g_bSlenderIsMarked[iBossIndex] = false;

	if (timer != g_hSlenderMarkedTimer[iBossIndex]) return;
}

public Action Timer_BossJarate(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	if (!SF_IsBoxingMap()) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	g_hSlenderJarateTimer[iBossIndex] = INVALID_HANDLE;
	g_bSlenderIsJarate[iBossIndex] = false;
	if (!g_bNPCHasCloaked[iBossIndex])
	{
		SetEntityRenderMode(slender, RENDER_NORMAL);
		SetEntityRenderColor(slender, 255, 255, 255, 255);
	}
	else
	{
		SetEntityRenderMode(slender, RENDER_TRANSCOLOR);
		SetEntityRenderColor(slender, 255, 255, 255, 0);
	}

	if (timer != g_hSlenderJarateTimer[iBossIndex]) return;
}

public Action Timer_BossMilked(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	if (!SF_IsBoxingMap()) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	g_hSlenderMilkedTimer[iBossIndex] = INVALID_HANDLE;
	g_bSlenderIsMilked[iBossIndex] = false;

	if (timer != g_hSlenderMilkedTimer[iBossIndex]) return;
}

public Action Timer_BossGassed(Handle timer, any entref)
{
	if (!g_bEnabled) return;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	if (!SF_IsBoxingMap()) return;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return;
	
	g_hSlenderGasTimer[iBossIndex] = INVALID_HANDLE;
	g_bSlenderIsGassed[iBossIndex] = false;

	if (timer != g_hSlenderGasTimer[iBossIndex]) return;
}

public Action Hook_MilkTouch(int iJar, int client)
{
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		
		float flBossPosition[3], flJarPosition[3];
		int slender = NPCGetEntIndex(iNPCIndex);
		GetEntPropVector(iJar, Prop_Data, "m_vecOrigin", flJarPosition);
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBossPosition);
		
		float flDistance = GetVectorSquareMagnitude(flJarPosition, flBossPosition);
		if (flDistance <= SquareFloat(512.0))
		{
			g_bSlenderIsMilked[iNPCIndex] = true;
			g_hSlenderMilkedTimer[iNPCIndex] = CreateTimer(10.0, Timer_BossMilked, EntIndexToEntRef(slender));
		}
	}
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (SF_IsBoxingMap())
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

public Action Hook_JarateTouch(int iJar, int client)
{
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		
		float flBossPosition[3], flJarPosition[3];
		int slender = NPCGetEntIndex(iNPCIndex);
		GetEntPropVector(iJar, Prop_Data, "m_vecOrigin", flJarPosition);
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBossPosition);
		
		float flDistance = GetVectorSquareMagnitude(flJarPosition, flBossPosition);
		if (flDistance <= SquareFloat(512.0))
		{
			if (!g_bNPCHasCloaked[iNPCIndex])
			{
				SetEntityRenderMode(slender, RENDER_NORMAL);
				SetEntityRenderColor(slender, 255, 255, 128, 255);
			}
			else
			{
				SetEntityRenderMode(slender, RENDER_TRANSCOLOR);
				SetEntityRenderColor(slender, 255, 255, 128, 75);
			}
			g_bSlenderIsJarate[iNPCIndex] = true;
			g_hSlenderJarateTimer[iNPCIndex] = CreateTimer(10.0, Timer_BossJarate, EntIndexToEntRef(slender));
		}
	}
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (SF_IsBoxingMap())
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

public Action Hook_GasTouch(int iJar, int client)
{
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		
		float flBossPosition[3], flJarPosition[3];
		int slender = NPCGetEntIndex(iNPCIndex);
		GetEntPropVector(iJar, Prop_Data, "m_vecOrigin", flJarPosition);
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flBossPosition);
		
		float flDistance = GetVectorSquareMagnitude(flJarPosition, flBossPosition);
		if (flDistance <= SquareFloat(512.0))
		{
			g_bSlenderIsGassed[iNPCIndex] = true;
			g_hSlenderGasTimer[iNPCIndex] = CreateTimer(10.0, Timer_BossGassed, EntIndexToEntRef(slender));
		}
	}
	if (MaxClients >= client > 0 && IsClientInGame(client))
	{
		if (SF_IsBoxingMap())
		{
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

float Boss_HitBox_Damage(int hitbox,int attacker,float damage,int damagetype,bool bMiniCrit=false)
{
	if(damage > 0.0)
	{
		int iBossIndex = NPCGetFromEntIndex(hitbox);
		if (iBossIndex == -1) return damage;
		if(IsValidClient(attacker) && g_bPlayerProxy[attacker])
			damage = 0.0;

		bool bAttackEliminated = view_as<bool>(NPCGetFlags(iBossIndex) & SFF_ATTACKWAITERS);

		if (SF_IsBoxingMap() && !bAttackEliminated && (GetClientTeam(attacker) == TFTeam_Blue) && IsValidClient(attacker))
		{
			damage = 0.0;
		}

		if (NPCGetType(iBossIndex) == SF2BossType_Chaser && damage > 0.0)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
			int iState = g_iSlenderState[iBossIndex];
			
			if (NPCChaserIsStunEnabled(iBossIndex))
			{
				if (!g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex] && !g_bSlenderInDeathcam[iBossIndex])
				{
					NPCChaserAddStunHealth(iBossIndex, -damage);
				}
				
				//(Experimental)
				if (view_as<bool>(GetProfileNum(sProfile,"healthbar",0)) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
				{
					UpdateHealthBar(iBossIndex);
				}
			}
			if ((damagetype & DMG_CRIT))
			{
				float flMyEyePos[3];
				SlenderGetAbsOrigin(iBossIndex, flMyEyePos);
				float flMyEyePosEx[3];
				GetEntPropVector(hitbox, Prop_Send, "m_vecMaxs", flMyEyePosEx);
				flMyEyePos[2]+=flMyEyePosEx[2];
				
				TE_Particle(g_iParticle[CriticalHit], flMyEyePos, flMyEyePos);
				TE_SendToAll();
				
				EmitSoundToAll(CRIT_SOUND, hitbox, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			}
			else if(bMiniCrit)
			{
				float flMyEyePos[3];
				SlenderGetAbsOrigin(iBossIndex, flMyEyePos);
				float flMyEyePosEx[3];
				GetEntPropVector(hitbox, Prop_Send, "m_vecMaxs", flMyEyePosEx);
				flMyEyePos[2]+=flMyEyePosEx[2];
				
				TE_Particle(g_iParticle[MiniCritHit], flMyEyePos, flMyEyePos);
				TE_SendToAll();
				
				EmitSoundToAll(MINICRIT_SOUND, hitbox, SNDCHAN_AUTO, SNDLEVEL_SCREAMING);
			}
		}
	}
	//Under Alpha stage can cause server crash.
	/*if(damage > 0.0)
		SF2_ANTILMAOBOX_HitBoxDoDamage(iBossIndex, attacker, damage, damagetype);
	*/
	return damage;
}

void UpdateHealthBar(int iBossIndex)
{
	float fMaxHealth = NPCChaserGetStunInitialHealth(iBossIndex);
	float fHealth = NPCChaserGetStunHealth(iBossIndex);
	if (g_ihealthBar == -1)
	{
		return;
	}
	int healthPercent;
	SetEntProp(g_ihealthBar, Prop_Send, "m_iBossState", 0);
	healthPercent=RoundToCeil((fHealth/fMaxHealth)*float(255));
	if(healthPercent>255)
	{
		healthPercent=255;
	}
	else if(healthPercent<=0)
	{
		healthPercent=0;
	}
	SetEntProp(g_ihealthBar, Prop_Send, "m_iBossHealthPercentageByte", healthPercent);
}

public bool Hook_HitBoxShouldCollide(int slender,int collisiongroup,int contentsmask, bool originalResult)
{
	if ((contentsmask & CONTENTS_PLAYERCLIP))
	{
		PrintToChatAll("collide");
		return true;
	}
	return false;
}

public bool Hook_BossShouldCollide(int slender,int collisiongroup,int contentsmask, bool originalResult)
{
	if ((contentsmask & CONTENTS_MONSTERCLIP))
		return false;
	return originalResult;
}

public Action Hook_SlenderGlowSetTransmit(int entity,int other)
{
	if (!g_bEnabled) return Plugin_Continue;
	if (g_bPlayerProxy[other]) return Plugin_Continue;
	if (IsClientInGhostMode(other)) return Plugin_Continue;
	if (SF_SpecialRound(SPECIALROUND_WALLHAX) && GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other]) return Plugin_Continue;
	bool bNightVision = (GetConVarBool(g_cvNightvisionEnabled) || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	if (bNightVision && g_iNightvisionType == 2 && GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other] && IsClientUsingFlashlight(other)) return Plugin_Continue;
	return Plugin_Handled;
}

stock bool SlenderCanHearPlayer(int iBossIndex,int client, SoundType iSoundType)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client)) return false;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	int iSlender = NPCGetEntIndex(iBossIndex);
	if (!iSlender || iSlender == INVALID_ENT_REFERENCE) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flHisPos[3], flMyPos[3];
	GetClientAbsOrigin(client, flHisPos);
	SlenderGetAbsOrigin(iBossIndex, flMyPos);
	
	float flHearRadius = NPCGetHearingRadius(iBossIndex, iDifficulty);
	if (flHearRadius <= 0.0) return false;
	
	float flDistance = GetVectorSquareMagnitude(flHisPos, flMyPos);
	
	// Trace check.
	Handle hTrace = INVALID_HANDLE;
	bool bTraceHit = false;
	
	float flMyEyePos[3];
	SlenderGetEyePosition(iBossIndex, flMyEyePos);
	
	switch (iSoundType)
	{
		case SoundType_Footstep:
		{
			if (!(GetEntityFlags(client) & FL_ONGROUND)) return false;
		
			if (GetEntProp(client, Prop_Send, "m_bDucking") || GetEntProp(client, Prop_Send, "m_bDucked")) flDistance *= 1.85;
			if (IsClientReallySprinting(client)) flDistance *= 0.66;
			
			hTrace = TR_TraceRayFilterEx(flMyPos, flHisPos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
			bTraceHit = TR_DidHit(hTrace);
			delete hTrace;
		}
		case SoundType_Voice, SoundType_Flashlight:
		{
			float flHisEyePos[3];
			GetClientEyePosition(client, flHisEyePos);
			
			hTrace = TR_TraceRayFilterEx(flMyEyePos, flHisEyePos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
			bTraceHit = TR_DidHit(hTrace);
			delete hTrace;
			
			flDistance *= 0.5;
		}
		case SoundType_Weapon:
		{
			float flHisMins[3], flHisMaxs[3];
			GetEntPropVector(client, Prop_Send, "m_vecMins", flHisMins);
			GetEntPropVector(client, Prop_Send, "m_vecMaxs", flHisMaxs);
			
			float flMiddle[3];
			for (int i = 0; i < 2; i++) flMiddle[i] = (flHisMins[i] + flHisMaxs[i]) / 2.0;
			
			float flEndPos[3];
			GetClientAbsOrigin(client, flEndPos);
			AddVectors(flHisPos, flMiddle, flEndPos);
			
			hTrace = TR_TraceRayFilterEx(flMyEyePos, flEndPos, MASK_NPCSOLID, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
			bTraceHit = TR_DidHit(hTrace);
			delete hTrace;
			
			flDistance *= 0.66;
		}
	}
	
	delete hTrace;
	
	if (bTraceHit) flDistance *= 1.66;
	
	if (TF2_GetPlayerClass(client) == TFClass_Spy) flDistance *= 1.3;
	
	if (flDistance > SquareFloat(flHearRadius)) return false;
	
	return true;
}

stock int SlenderArrayIndexToEntIndex(int iBossIndex)
{
	return NPCGetEntIndex(iBossIndex);
}

stock bool SlenderOnlyLooksIfNotSeen(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Creeper) return true;
	return false;
}

stock bool SlenderUsesBlink(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Creeper) return true;
	return false;
}

stock bool SlenderKillsOnNear(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Creeper) return false;
	return true;
}

stock void SlenderClearTargetMemory(int iBossIndex)
{
	if (iBossIndex == -1) return;
}

stock bool SlenderCreateTargetMemory(int iBossIndex)
{
	if (iBossIndex == -1) return false;
	return true;
}

stock void SlenderRemoveTargetMemory(int iBossIndex)
{
	if (iBossIndex == -1) return;
}

void SlenderPrintChatMessage(int iBossIndex, int iPlayer)
{
	if (iBossIndex == -1) return;
	
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile [SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sBuffer[PLATFORM_MAX_PATH];
	char sPrefix[PLATFORM_MAX_PATH];
	char sName[SF2_MAX_NAME_LENGTH];

	GetRandomStringFromProfile(sProfile, "chat_message_upon_death", sBuffer, sizeof(sBuffer));
	GetProfileString(sProfile, "chat_message_upon_death_prefix", sPrefix, sizeof(sPrefix));
	GetProfileString(sProfile, "name", sName, sizeof(sName));
	char sPlayer[32], sReplacePlayer[64];
	FormatEx(sPlayer, sizeof(sPlayer), "%N", iPlayer);
	if (!sPrefix[0])
	{
		sPrefix = "[SF2]";
	}
	if (sBuffer[0] && GetClientTeam(iPlayer) == 2)
	{
		Format(sPlayer, sizeof(sPlayer), "{red}%s", sPlayer);
		if (StrContains(sBuffer, "[PLAYER]", true) != -1) 
		{
			FormatEx(sReplacePlayer, sizeof(sReplacePlayer), "%s{default}", sPlayer);
			ReplaceString(sBuffer, sizeof(sBuffer), "[PLAYER]", sReplacePlayer, true);
		}
		else Format(sBuffer, sizeof(sBuffer), "%s{default} %s", sPlayer, sBuffer);
		if (StrContains(sBuffer, "[BOSS]", true) != -1) ReplaceString(sBuffer, sizeof(sBuffer), "[BOSS]", sName, true);
		CPrintToChatAll("{royalblue}%s{default} %s", sPrefix, sBuffer);
	}
}

void SlenderPerformVoice(int iBossIndex, const char[] sSectionName,const int iAttackIndex=-1)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath),_,iAttackIndex);
	
	if (sPath[0])
	{
		char sBuffer[512];
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_cooldown_min");
		float flCooldownMin = GetProfileFloat(sProfile, sBuffer, 1.5);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_cooldown_max");
		float flCooldownMax = GetProfileFloat(sProfile, sBuffer, 1.5);
		float flCooldown = GetRandomFloat(flCooldownMin, flCooldownMax);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_volume");
		float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_channel");
		int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_level");
		int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		
		g_flSlenderNextVoiceSound[iBossIndex] = GetGameTime() + flCooldown;
		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			int iPitchSmall = iPitch + 25;
			EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitchSmall);
		}
		else
		{
			EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
		}
	}
}

void SlenderCastFootstep(int iBossIndex, const char[] sSectionName)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iState = g_iSlenderState[iBossIndex];
	
	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath));
	
	if (sPath[0])
	{
		char sBuffer[512];
		float flCooldownIdle = g_flSlenderIdleFootstepTime[iBossIndex];
		float flCooldownWalk = g_flSlenderWalkFootstepTime[iBossIndex];
		float flCooldownRun = g_flSlenderRunFootstepTime[iBossIndex];
		float flCooldownStun = g_flSlenderStunFootstepTime[iBossIndex];
		float flCooldownAttack = g_flSlenderAttackFootstepTime[iBossIndex];
		
		if (g_flSlenderIdleFootstepTime[iBossIndex] <= 0.0) flCooldownIdle = GetProfileFloat(sProfile, "animation_idle_footstepinterval", 0.0);
		if (g_flSlenderWalkFootstepTime[iBossIndex] <= 0.0) flCooldownWalk = GetProfileFloat(sProfile, "animation_walk_footstepinterval", 0.0);
		if (g_flSlenderRunFootstepTime[iBossIndex] <= 0.0) flCooldownRun = GetProfileFloat(sProfile, "animation_run_footstepinterval", 0.0);
		if (g_flSlenderStunFootstepTime[iBossIndex] <= 0.0) flCooldownStun = GetProfileFloat(sProfile, "animation_stun_footstepinterval", 0.0);
		if (g_flSlenderAttackFootstepTime[iBossIndex] <= 0.0) flCooldownAttack = GetProfileFloat(sProfile, "animation_attack_footstepinterval", 0.0);
		//All of this is an emergency safety for bosses with the old system.
		
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_volume");
		float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_channel");
		int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_level");
		int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		
		switch (iState)
		{
			case STATE_IDLE:
			{
				if (flCooldownIdle != 0.0)
				{
					float flCooldownIdle2 = flCooldownIdle;
					g_flSlenderNextFootstepIdleSound[iBossIndex] = GetGameTime() + flCooldownIdle2;
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
			case STATE_WANDER, STATE_ALERT:
			{
				if (flCooldownWalk != 0.0)
				{
					float flCooldownWalk2 = flCooldownWalk;
					g_flSlenderNextFootstepWalkSound[iBossIndex] = GetGameTime() + flCooldownWalk2;
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
			case STATE_CHASE:
			{
				if (flCooldownRun != 0.0)
				{
					float flCooldownRun2 = flCooldownRun;
					g_flSlenderNextFootstepRunSound[iBossIndex] = GetGameTime() + flCooldownRun2;
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
			case STATE_STUN:
			{
				if (flCooldownStun != 0.0)
				{
					float flCooldownStun2 = flCooldownStun;
					g_flSlenderNextFootstepStunSound[iBossIndex] = GetGameTime() + flCooldownStun2;
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
			case STATE_ATTACK:
			{
				if (flCooldownAttack != 0.0)
				{
					float flCooldownAttack2 = flCooldownAttack;
					g_flSlenderNextFootstepAttackSound[iBossIndex] = GetGameTime() + flCooldownAttack2;
					EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
				}
			}
		}
	}
}
//I'm gonna save this for later -Mentrillum
/*
void SlenderCastFootstepAnimEvent(int iBossIndex, const char[] sSectionName)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath));
	
	if (sPath[0])
	{
		char sBuffer[512];
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_volume");
		float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_channel");
		int iChannel = GetProfileNum(sProfile, sBuffer, SNDCHAN_AUTO);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_level");
		int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
	}
}
*/
void SlenderCreateParticle(int iBossIndex, const char[] sSectionName, float flParticleZPos)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sPath[PLATFORM_MAX_PATH];
	GetProfileString(sProfile, sSectionName, sPath, sizeof(sPath));
	
	float flSlenderPosition[3];
	GetEntPropVector(slender, Prop_Data, "m_vecOrigin", flSlenderPosition);
	flSlenderPosition[2] += flParticleZPos;

	int iParticle = CreateEntityByName("info_particle_system");

	char sName[64];

	if (IsValidEdict(iParticle))
	{
		TeleportEntity(iParticle, flSlenderPosition, NULL_VECTOR, NULL_VECTOR);

		DispatchKeyValue(iParticle, "targetname", "tf2particle");
		GetEntPropString(iParticle, Prop_Data, "m_iName", sName, sizeof(sName));
		DispatchKeyValue(iParticle, "effect_name", sSectionName);
		DispatchSpawn(iParticle);
		ActivateEntity(iParticle);
		AcceptEntityInput(iParticle, "start");
		CreateTimer(0.1, Timer_SlenderDeleteParticle, iParticle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

void SlenderCreateParticleAttach(int iBossIndex, const char[] sSectionName, float flParticleZPos, int iClient)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sPath[PLATFORM_MAX_PATH];
	GetProfileString(sProfile, sSectionName, sPath, sizeof(sPath));
	
	float flPlayerPosition[3];
	GetClientAbsOrigin(iClient, flPlayerPosition);
	flPlayerPosition[2] += flParticleZPos;

	int iParticle = CreateEntityByName("info_particle_system");

	char sName[64];

	if (IsValidEdict(iParticle))
	{
		TeleportEntity(iParticle, flPlayerPosition, NULL_VECTOR, NULL_VECTOR);

		DispatchKeyValue(iParticle, "targetname", "tf2particle");
		GetEntPropString(iParticle, Prop_Data, "m_iName", sName, sizeof(sName));
		DispatchKeyValue(iParticle, "effect_name", sSectionName);
		DispatchSpawn(iParticle);
		ActivateEntity(iParticle);
		AcceptEntityInput(iParticle, "start");
		CreateTimer(0.1, Timer_SlenderDeleteParticle, iParticle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

void SlenderCreateParticleSpawnEffect(int iBossIndex, const char[] sSectionName, const char[] sSoundName, const char[] sVectorOffset)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sParticle[PLATFORM_MAX_PATH], sSoundEffect[PLATFORM_MAX_PATH];
	GetProfileString(sProfile, sSectionName, sParticle, sizeof(sParticle));
	
	float flSlenderPosition[3], flOffsetPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecOrigin", flSlenderPosition);
	GetProfileVector(sProfile, sVectorOffset, flOffsetPos, view_as<float>( { 0.0, 0.0, 0.0 } ));
	AddVectors(flOffsetPos, flSlenderPosition, flSlenderPosition);

	int iParticle = CreateEntityByName("info_particle_system");

	if (IsValidEdict(iParticle))
	{
		TeleportEntity(iParticle, flSlenderPosition, NULL_VECTOR, NULL_VECTOR);

		DispatchKeyValue(iParticle, "targetname", "tf2particle");
		DispatchKeyValue(iParticle, "effect_name", sParticle);
		DispatchSpawn(iParticle);
		ActivateEntity(iParticle);
		AcceptEntityInput(iParticle, "start");
		
		GetProfileString(sProfile, sSoundName, sSoundEffect, sizeof(sSoundEffect));
		char sBuffer[PLATFORM_MAX_PATH];
		strcopy(sBuffer, sizeof(sBuffer), sSoundName);
		StrCat(sBuffer, sizeof(sBuffer), "_volume");
		float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
		strcopy(sBuffer, sizeof(sBuffer), sSoundName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		EmitSoundToAll(sSoundEffect, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, flVolume, iPitch);
		
		CreateTimer(0.1, Timer_SlenderDeleteParticle, iParticle, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_SlenderDeleteParticle(Handle timer, any iParticle)
{
	if (IsValidEntity(iParticle))
	{
		char classN[64];
		GetEdictClassname(iParticle, classN, sizeof(classN));
		if (strcmp(classN, "info_particle_system", false) == 0)
		{
			RemoveEdict(iParticle);
		}
	}
}

bool SlenderCalculateApproachToPlayer(int iBossIndex,int iBestPlayer, float buffer[3])
{
	if (!IsValidClient(iBestPlayer)) return false;
	
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flSlenderPos[3], flPos[3], flReferenceAng[3], hisEyeAng[3], tempDir[3], tempPos[3];
	GetClientEyePosition(iBestPlayer, flPos);
	
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", hisEyeAng);
	AddVectors(hisEyeAng, g_flSlenderEyeAngOffset[iBossIndex], hisEyeAng);
	for (int i = 0; i < 3; i++) hisEyeAng[i] = AngleNormalize(hisEyeAng[i]);
	
	SlenderGetAbsOrigin(iBossIndex, flSlenderPos);
	
	SubtractVectors(flPos, flSlenderPos, flReferenceAng);
	GetVectorAngles(flReferenceAng, flReferenceAng);
	for (int i = 0; i < 3; i++) flReferenceAng[i] = AngleNormalize(flReferenceAng[i]);
	float flDist = GetProfileFloat(sProfile, "speed") * g_flRoundDifficultyModifier;
	if (flDist < GetProfileFloat(sProfile, "kill_radius")) flDist = GetProfileFloat(sProfile, "kill_radius") / 2.0;
	float flWithinFOV = 45.0;
	float flWithinFOVSide = 90.0;
	
	Handle hTrace;
	int index;
	float flHitNormal[3], tempPos2[3], flBuffer[3], flBuffer2[3];
	Handle hArray = CreateArray(6);
	
	float flCheckAng[3];
	
	int iRange = 0;
	int iID = 1;
	
	for (float addAng = 0.0; addAng < 360.0; addAng += 7.5)
	{
		tempDir[0] = 0.0;
		tempDir[1] = AngleNormalize(hisEyeAng[1] + addAng);
		tempDir[2] = 0.0;
		
		GetAngleVectors(tempDir, tempDir, NULL_VECTOR, NULL_VECTOR);
		NormalizeVector(tempDir, tempDir);
		ScaleVector(tempDir, flDist);
		AddVectors(tempDir, flSlenderPos, tempPos);
		AddVectors(tempPos, g_flSlenderEyePosOffset[iBossIndex], tempPos);
		AddVectors(flSlenderPos, g_flSlenderEyePosOffset[iBossIndex], tempPos2);
		
		flBuffer[0] = g_flSlenderDetectMins[iBossIndex][0];
		flBuffer[1] = g_flSlenderDetectMins[iBossIndex][1];
		flBuffer[2] = 0.0;
		flBuffer2[0] = g_flSlenderDetectMaxs[iBossIndex][0];
		flBuffer2[1] = g_flSlenderDetectMaxs[iBossIndex][1];
		flBuffer2[2] = 0.0;
		
		// Get a good move position.
		hTrace = TR_TraceHullFilterEx(tempPos2, tempPos, flBuffer, flBuffer2, MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitCharactersOrEntity, slender);
		TR_GetEndPosition(tempPos, hTrace);
		delete hTrace;
		
		// Drop to the ground if we're above ground.
		hTrace = TR_TraceRayFilterEx(tempPos, view_as<float>({ 90.0, 0.0, 0.0 }), MASK_PLAYERSOLID_BRUSHONLY, RayType_Infinite, TraceRayDontHitCharactersOrEntity, slender);
		bool bHit = TR_DidHit(hTrace);
		TR_GetEndPosition(tempPos2, hTrace);
		delete hTrace;
		
		// Then calculate from there.
		hTrace = TR_TraceHullFilterEx(tempPos, tempPos2, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], MASK_PLAYERSOLID_BRUSHONLY, TraceRayDontHitCharactersOrEntity, slender);
		TR_GetEndPosition(tempPos, hTrace);
		TR_GetPlaneNormal(hTrace, flHitNormal);
		delete hTrace;
		SubtractVectors(tempPos, flSlenderPos, flCheckAng);
		GetVectorAngles(flCheckAng, flCheckAng);
		GetVectorAngles(flHitNormal, flHitNormal);
		for (int i = 0; i < 3; i++) 
		{
			flHitNormal[i] = AngleNormalize(flHitNormal[i]);
			flCheckAng[i] = AngleNormalize(flCheckAng[i]);
		}
		
		float diff = AngleDiff(flCheckAng[1], flReferenceAng[1]);
		
		bool bBackup = false;
		
		if (FloatAbs(diff) > flWithinFOV) bBackup = true;
		
		if (diff >= 0.0 && diff <= flWithinFOVSide) iRange = 1;
		else if (diff < 0.0 && diff >= -flWithinFOVSide) iRange = 2;
		else continue;
		
		if ((flHitNormal[0] >= 0.0 && flHitNormal[0] < 45.0)
			|| (flHitNormal[0] < 0.0 && flHitNormal[0] > -45.0)
			|| !bHit
			|| TR_PointOutsideWorld(tempPos)
			|| IsSpaceOccupiedNPC(tempPos, g_flSlenderDetectMins[iBossIndex], g_flSlenderDetectMaxs[iBossIndex], iBestPlayer))
		{
			continue;
		}
		
		// Check from top to bottom of me.
		
		if (!IsPointVisibleToPlayer(iBestPlayer, tempPos, false, false)) continue;
		
		AddVectors(tempPos, g_flSlenderEyePosOffset[iBossIndex], tempPos);
		
		if (!IsPointVisibleToPlayer(iBestPlayer, tempPos, false, false)) continue;
		
		SubtractVectors(tempPos, g_flSlenderEyePosOffset[iBossIndex], tempPos);
		
		//	Insert the vector into our array.
		index = PushArrayCell(hArray, iID);
		SetArrayCell(hArray, index, tempPos[0], 1);
		SetArrayCell(hArray, index, tempPos[1], 2);
		SetArrayCell(hArray, index, tempPos[2], 3);
		SetArrayCell(hArray, index, iRange, 4);
		SetArrayCell(hArray, index, bBackup, 5);
		
		iID++;
	}
	
	int size;
	if ((size = GetArraySize(hArray)) > 0)
	{
		float diff = AngleDiff(hisEyeAng[1], flReferenceAng[1]);
		if (diff >= 0.0) iRange = 1;
		else iRange = 2;
		
		bool bBackup = false;
		
		// Clean up any vectors that we don't need.
		Handle hArray2 = CloneArray(hArray);
		for (int i = 0; i < size; i++)
		{
			if (GetArrayCell(hArray2, i, 4) != iRange || view_as<bool>(GetArrayCell(hArray2, i, 5) != bBackup))
			{
				int iIndex = FindValueInArray(hArray, GetArrayCell(hArray2, i));
				if (iIndex != -1) RemoveFromArray(hArray, iIndex);
			}
		}
		
		delete hArray2;
		
		size = GetArraySize(hArray);
		if (size)
		{
			index = GetRandomInt(0, size - 1);
			buffer[0] = view_as<float>(GetArrayCell(hArray, index, 1));
			buffer[1] = view_as<float>(GetArrayCell(hArray, index, 2));
			buffer[2] = view_as<float>(GetArrayCell(hArray, index, 3));
		}
		else
		{
			delete hArray;
			return false;
		}
	}
	else
	{
		delete hArray;
		return false;
	}
	
	delete hArray;
	delete hTrace;
	return true;
}

// This functor ensures that the proposed boss position is not too
// close to other players that are within the distance defined by
// flMinSearchDist.

// Returning false on the functor will immediately discard the proposed position.

public bool SlenderChaseBossPlaceFunctor(int iBossIndex, const float flActiveAreaCenterPos[3], const float flAreaPos[3], float flMinSearchDist, float flMaxSearchDist, bool bOriginalResult)
{
	if (FloatAbs(flActiveAreaCenterPos[2] - flAreaPos[2]) > 320.0)
	{
		return false;
	}
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) ||
			!IsPlayerAlive(i) ||
			g_bPlayerEliminated[i] ||
			g_bPlayerEscaped[i]) continue;
		
		float flClientPos[3];
		GetClientAbsOrigin(i, flClientPos);
		
		if (GetVectorSquareMagnitude(flClientPos, flAreaPos) < SquareFloat(flMinSearchDist))
		{
			return false;
		}
	}
	
	return bOriginalResult;
}

// As time passes on, we have to get more aggressive in order to successfully peak the target's
// stress level in the allotted duration we're given. Otherwise we'll be forced to place him
// in a rest period.

// Teleport progressively closer as time passes in attempt to increase the target's stress level.
// Maximum minimum range is capped by the boss's anger level.

stock float CalculateTeleportMinRange(int iBossIndex, float flInitialMinRange, float flTeleportMaxRange)
{
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	float flTeleportTargetTimeLeft = g_flSlenderTeleportMaxTargetTime[iBossIndex] - GetGameTime();
	float flTeleportTargetTimeInitial = g_flSlenderTeleportMaxTargetTime[iBossIndex] - g_flSlenderTeleportTargetTime[iBossIndex];
	float flTeleportMinRange = flTeleportMaxRange - (1.0 - (flTeleportTargetTimeLeft / flTeleportTargetTimeInitial)) * (flTeleportMaxRange - flInitialMinRange);
	
	if (NPCGetAnger(iBossIndex) <= 1.0)
	{
		flTeleportMinRange += (g_flSlenderTeleportMinRange[iBossIndex][iDifficulty] - flTeleportMaxRange) * Pow(NPCGetAnger(iBossIndex) - 1.0, 2.0 / g_flRoundDifficultyModifier);
	}
	
	if (flTeleportMinRange < flInitialMinRange) flTeleportMinRange = flInitialMinRange;
	if (flTeleportMinRange > flTeleportMaxRange) flTeleportMinRange = flTeleportMaxRange;
	
	return flTeleportMinRange;
}

public Action Timer_SlenderTeleportThink(Handle timer, any iBossIndex)
{
	if (iBossIndex == -1) return Plugin_Stop;
	if (timer != g_hSlenderThink[iBossIndex]) return Plugin_Stop;

	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	if (NPCGetFlags(iBossIndex) & SFF_NOTELEPORT) return Plugin_Continue;
	
	// Check to see if anyone's looking at me before doing anything.
	if (PeopleCanSeeSlender(iBossIndex, _, false))
	{
		return Plugin_Continue;
	}
	
	if (NPCGetTeleportType(iBossIndex) == 2)
	{
		int iBoss = NPCGetEntIndex(iBossIndex);
		if (iBoss && iBoss != INVALID_ENT_REFERENCE)
		{
			if (NPCGetType(iBossIndex) == SF2BossType_Chaser)
			{
				// Check to see if it's a good time to teleport away.
				int iState = g_iSlenderState[iBossIndex];
				if (iState == STATE_IDLE || iState == STATE_WANDER)
				{
					if (GetGameTime() < g_flSlenderTimeUntilKill[iBossIndex])
					{
						return Plugin_Continue;
					}
				}
			}
		}
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (!g_bRoundGrace)
	{
		if (GetGameTime() >= g_flSlenderNextTeleportTime[iBossIndex])
		{
			float flTeleportTime = GetRandomFloat(NPCGetTeleportTimeMin(iBossIndex, iDifficulty), NPCGetTeleportTimeMax(iBossIndex, iDifficulty));
			bool bIgnoreFuncNavPrefer = view_as<bool>(GetProfileNum(sProfile, "ignore_nav_prefer", 1));
			g_flSlenderNextTeleportTime[iBossIndex] = GetGameTime() + flTeleportTime;
			
			int iTeleportTarget = EntRefToEntIndex(g_iSlenderTeleportTarget[iBossIndex]);
			
			if (!iTeleportTarget || iTeleportTarget == INVALID_ENT_REFERENCE)
			{
				// We don't have any good targets. Remove myself for now.
				if (SlenderCanRemove(iBossIndex)) RemoveSlender(iBossIndex);
				
#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: no good target, removing...", iBossIndex);
#endif
			}
			else
			{
				float flTeleportMinRange = CalculateTeleportMinRange(iBossIndex, g_flSlenderTeleportMinRange[iBossIndex][iDifficulty], g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty]);
				int iTeleportAreaIndex = -1;
				float flTeleportPos[3];
				
				// Search surrounding nav areas around target.
				if (NavMesh_Exists())
				{
					CNavArea TargetArea = SDK_GetLastKnownArea(iTeleportTarget);
					if (TargetArea != INVALID_NAV_AREA)
					{
						bool bShouldBeBehindObstruction = false;
						if (NPCGetTeleportType(iBossIndex) == 2)
						{
							bShouldBeBehindObstruction = true;
						}
						
						// Search outwards until travel distance is at maximum range.
						Handle hAreaArray = CreateArray(2);
						ArrayStack hAreas = CreateStack();
						NavMesh_CollectSurroundingAreas(hAreas, TargetArea, g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty]);
						
						{
							int iPoppedAreas;
						
							while (!IsStackEmpty(hAreas))
							{
								CNavArea Area = INVALID_NAV_AREA;
								int iAreaIndex = -1;
								PopStackCell(hAreas, iAreaIndex);
								Area = CNavArea(iAreaIndex);
								
								// Check flags.
								if (Area.Attributes & NAV_MESH_NO_HOSTAGES)
								{
									// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
									continue;
								}
								// Check if the nav area has a func prefer on it.
								if (bIgnoreFuncNavPrefer && NavHasFuncPrefer(Area.Index))
									continue;
								
								int iIndex = PushArrayCell(hAreaArray, Area.Index);
								SetArrayCell(hAreaArray, iIndex, float(Area.CostSoFar), 1);
								iPoppedAreas++;
							}
							
#if defined DEBUG
							SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: collected %d areas", iBossIndex, iPoppedAreas);
#endif
							
							CloseHandle(hAreas);
						}
						
						Handle hAreaArrayClose = CreateArray(4);
						Handle hAreaArrayAverage = CreateArray(4);
						Handle hAreaArrayFar = CreateArray(4);
						
						for (int i = 1; i <= 3; i++)
						{
							float flRangeSectionMin = flTeleportMinRange + (g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i - 1) / 3.0);
							float flRangeSectionMax = flTeleportMinRange + (g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i) / 3.0);
							
							for (int i2 = 0, iSize = GetArraySize(hAreaArray); i2 < iSize; i2++)
							{
								int iAreaIndex = GetArrayCell(hAreaArray, i2);
								
								float flAreaSpawnPoint[3];
								NavMeshArea_GetCenter(iAreaIndex, flAreaSpawnPoint);
								
								int iBoss = NPCGetEntIndex(iBossIndex);
								
								// Check space. First raise to HalfHumanHeight * 2, then trace downwards to get ground level.
								{
									float flTraceStartPos[3];
									flTraceStartPos[0] = flAreaSpawnPoint[0];
									flTraceStartPos[1] = flAreaSpawnPoint[1];
									flTraceStartPos[2] = flAreaSpawnPoint[2] + (HalfHumanHeight * 2.0);
									
									float flTraceMins[3];
									flTraceMins[0] = g_flSlenderDetectMins[iBossIndex][0];
									flTraceMins[1] = g_flSlenderDetectMins[iBossIndex][1];
									flTraceMins[2] = 0.0;
									
									
									float flTraceMaxs[3];
									flTraceMaxs[0] = g_flSlenderDetectMaxs[iBossIndex][0];
									flTraceMaxs[1] = g_flSlenderDetectMaxs[iBossIndex][1];
									flTraceMaxs[2] = 0.0;
									
									Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
										flAreaSpawnPoint,
										flTraceMins,
										flTraceMaxs,
										MASK_NPCSOLID,
										TraceRayDontHitEntity,
										iBoss);
									
									float flTraceHitPos[3];
									TR_GetEndPosition(flTraceHitPos, hTrace);
									flTraceHitPos[2] += 1.0;
									CloseHandle(hTrace);
									
									if (IsSpaceOccupiedNPC(flTraceHitPos,
										g_flSlenderDetectMins[iBossIndex],
										g_flSlenderDetectMaxs[iBossIndex],
										iBoss))
									{
										continue;
									}
									float flChangedMins[3] = {-20.0, -20.0, 0.0};
									float flChangedMaxs[3] = {20.0, 20.0, 83.0};
									if (IsSpaceOccupiedNPC(flTraceHitPos,
										flChangedMins,
										flChangedMaxs,
										iBoss))
									{
										// Can't let an NPC spawn here; too little space. If we let it spawn here it will be non solid!
										continue;
									}
									
									flAreaSpawnPoint[0] = flTraceHitPos[0];
									flAreaSpawnPoint[1] = flTraceHitPos[1];
									flAreaSpawnPoint[2] = flTraceHitPos[2];
								}
								
								// Check visibility.
								if (IsPointVisibleToAPlayer(flAreaSpawnPoint, !bShouldBeBehindObstruction, false)) continue;
								
								AddVectors(flAreaSpawnPoint, g_flSlenderEyePosOffset[iBossIndex], flAreaSpawnPoint);
								
								if (IsPointVisibleToAPlayer(flAreaSpawnPoint, !bShouldBeBehindObstruction, false)) continue;
								
								SubtractVectors(flAreaSpawnPoint, g_flSlenderEyePosOffset[iBossIndex], flAreaSpawnPoint);
								
								bool bTooNear = false;
								
								// Check minimum range with players.
								for (int iClient = 1; iClient <= MaxClients; iClient++)
								{
									if (!IsClientInGame(iClient) ||
										!IsPlayerAlive(iClient) ||
										g_bPlayerEliminated[iClient] ||
										IsClientInGhostMode(iClient) || 
										DidClientEscape(iClient))
									{
										continue;
									}
									
									float flTempPos[3];
									GetClientAbsOrigin(iClient, flTempPos);
									
									if (GetVectorSquareMagnitude(flAreaSpawnPoint, flTempPos) <= SquareFloat(g_flSlenderTeleportMinRange[iBossIndex][iDifficulty]))
									{
										bTooNear = true;
										break;
									}
								}
								
								if (bTooNear) continue;	// This area is not compatible.
								
								// Check minimum range with boss copies (if supported).
								if (NPCGetFlags(iBossIndex) & SFF_COPIES)
								{
									float flMinDistBetweenBosses = GetProfileFloat(sProfile, "copy_teleport_dist_from_others", 800.0);
									
									for (int iBossCheck = 0; iBossCheck < MAX_BOSSES; iBossCheck++)
									{
										if (iBossCheck == iBossIndex ||
											NPCGetUniqueID(iBossCheck) == -1 ||
											(g_iSlenderCopyMaster[iBossIndex] != iBossCheck && g_iSlenderCopyMaster[iBossIndex] != g_iSlenderCopyMaster[iBossCheck]))
										{
											continue;
										}
										
										int iBossEnt = NPCGetEntIndex(iBossCheck);
										if (!iBossEnt || iBossEnt == INVALID_ENT_REFERENCE) continue;
										
										float flTempPos[3];
										SlenderGetAbsOrigin(iBossCheck, flTempPos);
										
										if (GetVectorSquareMagnitude(flAreaSpawnPoint, flTempPos) <= SquareFloat(flMinDistBetweenBosses))
										{
											bTooNear = true;
											break;
										}
									}
								}
								
								if (bTooNear) continue;	// This area is not compatible.
								
								// Check travel distance and put in the appropriate arrays.
								float flDist = view_as<float>(GetArrayCell(hAreaArray, i2, 1));
								if (flDist > flRangeSectionMin && flDist < flRangeSectionMax)
								{
									int iIndex = -1;
									Handle hTargetAreaArray = INVALID_HANDLE;
									
									switch (i)
									{
										case 1: 
										{
											iIndex = PushArrayCell(hAreaArrayClose, iAreaIndex);
											hTargetAreaArray = hAreaArrayClose;
										}
										case 2: 
										{
											iIndex = PushArrayCell(hAreaArrayAverage, iAreaIndex);
											hTargetAreaArray = hAreaArrayAverage;
										}
										case 3: 
										{
											iIndex = PushArrayCell(hAreaArrayFar, iAreaIndex);
											hTargetAreaArray = hAreaArrayFar;
										}
									}
									
									if (hTargetAreaArray != INVALID_HANDLE && iIndex != -1)
									{
										SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[0], 1);
										SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[1], 2);
										SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[2], 3);
									}
								}
							}
						}
						
						CloseHandle(hAreaArray);
						
#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: collected %d close areas, %d average areas, %d far areas", iBossIndex, GetArraySize(hAreaArrayClose),
							GetArraySize(hAreaArrayAverage),
							GetArraySize(hAreaArrayFar));
#endif
						
						int iArrayIndex = -1;
						
						if (GetArraySize(hAreaArrayClose))
						{
							iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayClose) - 1);
							iTeleportAreaIndex = GetArrayCell(hAreaArrayClose, iArrayIndex);
							flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 1));
							flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 2));
							flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 3));
						}
						else if (GetArraySize(hAreaArrayAverage))
						{
							iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayAverage) - 1);
							iTeleportAreaIndex = GetArrayCell(hAreaArrayAverage, iArrayIndex);
							flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 1));
							flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 2));
							flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 3));
						}
						else if (GetArraySize(hAreaArrayFar))
						{
							iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayFar) - 1);
							iTeleportAreaIndex = GetArrayCell(hAreaArrayFar, iArrayIndex);
							flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 1));
							flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 2));
							flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 3));
						}
						
						CloseHandle(hAreaArrayClose);
						CloseHandle(hAreaArrayAverage);
						CloseHandle(hAreaArrayFar);
					}
					else
					{
#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: failed because target is not on nav mesh!", iBossIndex);
#endif
					}
				}
				else
				{
#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: failed because of lack of nav mesh!", iBossIndex);
#endif
				}
				
				if (iTeleportAreaIndex == -1)
				{
					// We don't have any good areas. Remove myself for now.
					if (SlenderCanRemove(iBossIndex)) RemoveSlender(iBossIndex);
				}
				else
				{
					SpawnSlender(iBossIndex, flTeleportPos);
					
					if(g_bPlayerIsExitCamping[iTeleportTarget])
						g_bSlenderTeleportTargetIsCamping[iBossIndex]=true;
					else
						g_bSlenderTeleportTargetIsCamping[iBossIndex]=false;
					
					if (NPCGetFlags(iBossIndex) & SFF_HASJUMPSCARE)
					{
						bool bDidJumpScare = false;
						
						for (int i = 1; i <= MaxClients; i++)
						{
							if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_bPlayerEliminated[i] || IsClientInGhostMode(i)) continue;
							
							if (PlayerCanSeeSlender(i, iBossIndex, false))
							{
								if ((NPCGetDistanceFromEntity(iBossIndex, i) <= SquareFloat(NPCGetJumpscareDistance(iBossIndex, iDifficulty)) && GetGameTime() >= g_flSlenderNextJumpScare[iBossIndex]) || (PlayerCanSeeSlender(i, iBossIndex) && !view_as<bool>(GetProfileNum(sProfile,"jumpscare_no_sight",0))))
								{
									bDidJumpScare = true;
								
									float flJumpScareDuration = NPCGetJumpscareDuration(iBossIndex, iDifficulty);
									ClientDoJumpScare(i, iBossIndex, flJumpScareDuration);
								}
							}
						}
						
						if (bDidJumpScare)
						{
							g_flSlenderNextJumpScare[iBossIndex] = GetGameTime() + NPCGetJumpscareCooldown(iBossIndex, iDifficulty);
						}
					}
				}
			}
		}
		else
		{
#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: failed because of teleport time (curtime: %f, teletime: %f)", iBossIndex, GetGameTime(), g_flSlenderNextTeleportTime[iBossIndex]);
#endif
		}
	}
	
	return Plugin_Continue;
}

bool SlenderMarkAsFake(int iBossIndex)
{
	int iBossFlags = NPCGetFlags(iBossIndex);
	if (iBossFlags & SFF_MARKEDASFAKE) return false;
	
	int slender = NPCGetEntIndex(iBossIndex);
	g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
	g_iSlenderModel[iBossIndex] = INVALID_ENT_REFERENCE;
	
	NPCSetFlags(iBossIndex, iBossFlags | SFF_MARKEDASFAKE);
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	g_hSlenderFakeTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderMarkedAsFake, iBossIndex);
	
	if (slender && slender != INVALID_ENT_REFERENCE)
	{
		CreateTimer(2.0, Timer_KillEntity, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
	
		int iFlags = GetEntProp(slender, Prop_Send, "m_usSolidFlags");
		if (!(iFlags & 0x0004)) iFlags |= 0x0004; // 	FSOLID_NOT_SOLID
		if (!(iFlags & 0x0008)) iFlags |= 0x0008; // 	FSOLID_TRIGGER
		SetEntProp(slender, Prop_Send, "m_usSolidFlags", iFlags);
	
		if(view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)) && g_sSlenderEngineSound[iBossIndex][0])
		{
			StopSound(slender, SNDCHAN_STATIC, g_sSlenderEngineSound[iBossIndex]);
		}
	

		SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", 0.0);
		SetEntityRenderFx(slender, RENDERFX_FADE_FAST);
	}
	
	return true;
}

public Action Timer_SlenderMarkedAsFake(Handle timer, any data)
{
	if (timer != g_hSlenderFakeTimer[data]) return;
	
	NPCRemove(data);
}

stock int SpawnSlenderModel(int iBossIndex, const float pos[3], bool bDeathCam = false)
{
	if (NPCGetUniqueID(iBossIndex) == -1)
	{
		LogError("Could not spawn boss model: boss does not exist!");
		return -1;
	}
	
	int iProfileIndex = NPCGetProfileIndex(iBossIndex);
	
	char buffer[PLATFORM_MAX_PATH], sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	float flPlaybackRate, flTempFootsteps;
	int iDifficulty = GetConVarInt(g_cvDifficulty);
	
	GetProfileString(sProfile, "model", buffer, sizeof(buffer));
	if (!buffer[0])
	{
		LogError("Could not spawn boss model: model is invalid!");
		return -1;
	}
	float flModelScale = NPCGetModelScale(iBossIndex);
	if (flModelScale <= 0.0)
	{
		LogError("Could not spawn boss model: model scale is less than or equal to 0.0!");
		return -1;
	}
	int iModelSkin = NPCGetModelSkin(iBossIndex);
	if (iModelSkin < 0)
	{
		LogError("Could not spawn boss model: model skin is less than 0!");
		return -1;
	}
	
	int iSlenderModel = CreateEntityByName("prop_dynamic_override");
	if (iSlenderModel != -1)
	{
		SetEntityModel(iSlenderModel, buffer);
		
		TeleportEntity(iSlenderModel, pos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(iSlenderModel);
		ActivateEntity(iSlenderModel);
		if (!bDeathCam) 
		{
			GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, buffer, sizeof(buffer), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
		}
		else 
		{
			bool bAnimationFound = GetProfileAnimation(sProfile, ChaserAnimation_DeathcamAnimations, buffer, sizeof(buffer), flPlaybackRate, 1, _, flTempFootsteps);
			if (!bAnimationFound || strcmp(buffer,"") <= 0)
			{
				GetProfileAnimation(sProfile, ChaserAnimation_IdleAnimations, buffer, sizeof(buffer), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex]);
			}
		}
		if (buffer[0])
		{
			SetVariantString(buffer);
			AcceptEntityInput(iSlenderModel, "SetDefaultAnimation");
			SetVariantString(buffer);
			AcceptEntityInput(iSlenderModel, "SetAnimation");
			AcceptEntityInput(iSlenderModel, "DisableCollision");
		}
		
		SetVariantFloat(flPlaybackRate);
		AcceptEntityInput(iSlenderModel, "SetPlaybackRate");
		
		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
		{
			float flScaleModel = flModelScale * 0.25;
			SetEntPropFloat(iSlenderModel, Prop_Send, "m_flModelScale", flScaleModel);
		}
		else
		{
			SetEntPropFloat(iSlenderModel, Prop_Send, "m_flModelScale", flModelScale);
		}
		if (NPCGetModelSkinMax(iBossIndex) > 0)
		{
			int iRandomSkin = GetRandomInt(0, NPCGetModelSkinMax(iBossIndex));
			SetEntProp(iSlenderModel, Prop_Send, "m_nSkin", iRandomSkin);
		}
		else
		{
			SetEntProp(iSlenderModel, Prop_Send, "m_nSkin", iModelSkin);
		}
		SetEntProp(iSlenderModel, Prop_Send, "m_nBody", GetBossProfileBodyGroups(iProfileIndex));

		// Create special effects.
		SetEntityRenderMode(iSlenderModel, view_as<RenderMode>(GetProfileNum(sProfile, "effect_rendermode", view_as<int>(RENDER_NORMAL))));
		SetEntityRenderFx(iSlenderModel, view_as<RenderFx>(GetProfileNum(sProfile, "effect_renderfx", view_as<int>(RENDERFX_NONE))));
		
		int iColor[4];
		GetProfileColor(sProfile, "effect_rendercolor", iColor[0], iColor[1], iColor[2], iColor[3]);
		SetEntityRenderColor(iSlenderModel, iColor[0], iColor[1], iColor[2], iColor[3]);
		
		KvRewind(g_hConfig);
	}
	
	return iSlenderModel;
}

stock bool PlayerCanSeeSlender(int client,int iBossIndex, bool bCheckFOV=true, bool bCheckBlink=false, bool bCheckEliminated=true)
{
	return IsNPCVisibleToPlayer(iBossIndex, client, bCheckFOV, bCheckBlink, bCheckEliminated);
}

stock bool PeopleCanSeeSlender(int iBossIndex, bool bCheckFOV=true, bool bCheckBlink=false)
{
	return IsNPCVisibleToAPlayer(iBossIndex, bCheckFOV, bCheckBlink);
}

stock bool SlenderAddGlow(int iBossIndex, const char[] sAttachment="", int iColor[4] = {255, 255, 255, 255})
{
	int iEnt = NPCGetEntIndex(iBossIndex);
	if (!iEnt || iEnt == INVALID_ENT_REFERENCE) return false;
	
	char sBuffer[PLATFORM_MAX_PATH];
	GetEntPropString(iEnt, Prop_Data, "m_ModelName", sBuffer, sizeof(sBuffer));
	
	if (sBuffer[0] == '\0') 
	{
		return false;
	}
	
	int ent = CreateEntityByName("tf_taunt_prop");
	if (ent != -1)
	{
		float flModelScale = GetEntPropFloat(iEnt, Prop_Send, "m_flModelScale");
		
		SetEntityModel(ent, sBuffer);
		DispatchSpawn(ent);
		ActivateEntity(ent);
		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		SetEntityRenderColor(ent, 0, 0, 0, 0);
		SetEntPropFloat(ent, Prop_Send, "m_flModelScale", flModelScale);
		
		int iFlags = GetEntProp(ent, Prop_Send, "m_fEffects");
		SetEntProp(ent, Prop_Send, "m_fEffects", iFlags | (1 << 0));
		
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", iEnt);
		
		if (sAttachment[0])
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(ent, "SetParentAttachment");
		}
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_SlenderGlowSetTransmit);
		
		int iGlowManager = TF2_CreateGlow(ent);
		//Set our desired glow color
		SetVariantColor(iColor);
		AcceptEntityInput(iGlowManager, "SetGlowColor");
		DHookEntity(g_hSDKShouldTransmit, true, iGlowManager);
		DHookEntity(g_hSDKShouldTransmit, true, ent);
		SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", iGlowManager);
		
		return true;
	}
	
	return false;
}

stock void SlenderRemoveGlow(int iBossIndex)
{
	int iEnt = NPCGetEntIndex(iBossIndex);
	if (!iEnt || iEnt == INVALID_ENT_REFERENCE) return;
	
	int iEffect = -1;
	while((iEffect = FindEntityByClassname(iEffect, "tf_taunt_prop")) > MaxClients)
	{
		if(GetEntProp(iEffect,Prop_Send,"moveparent") == iEnt)
		{
			RemoveEntity(iEffect);
			iEnt = GetEntPropEnt(iEffect, Prop_Send, "m_hOwnerEntity");
			if (iEnt > MaxClients)
				RemoveEntity(iEnt);
			break;
		}
	}
}

// TODO: bCheckBlink and bCheckEliminated should NOT be function arguments!
bool IsNPCVisibleToPlayer(int iNPCIndex,int client, bool bCheckFOV=true, bool bCheckBlink=false, bool bCheckEliminated=true)
{
	if (!NPCIsValid(iNPCIndex)) return false;
	
	int iNPC = NPCGetEntIndex(iNPCIndex);
	if (iNPC && iNPC != INVALID_ENT_REFERENCE)
	{
		float flEyePos[3];
		NPCGetEyePosition(iNPCIndex, flEyePos);
		return IsPointVisibleToPlayer(client, flEyePos, bCheckFOV, bCheckBlink, bCheckEliminated);
	}
	
	return false;
}

// TODO: bCheckBlink and bCheckEliminated should NOT be function arguments!
bool IsNPCVisibleToAPlayer(int iNPCIndex, bool bCheckFOV=true, bool bCheckBlink=false, bool bCheckEliminated=true)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsNPCVisibleToPlayer(iNPCIndex, client, bCheckFOV, bCheckBlink, bCheckEliminated))
		{
			return true;
		}
	}
	
	return false;
}

float NPCGetDistanceFromPoint(int iNPCIndex, const float flPoint[3])
{
	int iNPC = NPCGetEntIndex(iNPCIndex);
	if (iNPC && iNPC != INVALID_ENT_REFERENCE)
	{
		float flPos[3];
		SlenderGetAbsOrigin(iNPCIndex, flPos);
		
		return GetVectorSquareMagnitude(flPos, flPoint);
	}
	
	return -1.0;
}

float NPCGetDistanceFromEntity(int iNPCIndex,int ent)
{
	if (!IsValidEntity(ent)) return -1.0;
	
	float flPos[3];
	GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flPos);
	
	return NPCGetDistanceFromPoint(iNPCIndex, flPos);
}

public bool TraceRayBossVisibility(int entity,int mask, any data)
{
	if (entity == data || IsValidClient(entity)) return false;
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_bPlayerProxy[entity] || IsClientInGhostMode(entity)) return false;
	}
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (entity <= MAX_BOSSES) return false;
	if (iBossIndex != -1) return false;
	return true;
}

public bool TraceRayDontHitCharacters(int entity,int mask, any data)
{
	if (entity > 0 && entity <= MaxClients) return false;
	
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	
	return true;
}

public bool TraceRayDontHitEntityAndProxies(int entity,int mask,any data)
{
	if (entity == data) return false;
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_bPlayerProxy[entity] || IsClientInGhostMode(entity)) return false;
	}
	return true;
}

public bool TraceRayDontHitAnyEntity(int entity,int mask,any data)
{
	if (entity == data) return false;
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_bPlayerProxy[entity] || IsClientInGhostMode(entity)) return false;
	}
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityNetClass(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "CTFBaseBoss") == 0) return false;
	}
	return true;
}

public bool TraceRayDontHitCharactersOrEntity(int entity,int mask, any data)
{
	if (entity == data) return false;

	if (entity > 0 && entity <= MaxClients) return false;
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityNetClass(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "CTFBaseBoss") == 0) return false;
	}
	
	return true;
}

public bool TraceRayDontHitBosses(int entity,int mask, any data)
{
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityNetClass(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "CTFBaseBoss") == 0) return false;
	}
	
	return true;
}

/**
 *	Calculates the position and spawn point for a proxy.
 */
bool SpawnProxy(int client, int iBossIndex, float flTeleportPos[3], int &iSpawnPoint=-1)
{
	iSpawnPoint = -1;

	if (iBossIndex == -1 || client <= 0) 
		return false;

	if (g_bRoundGrace)
		return false;
	
	if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) return false;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iDifficulty = g_cvDifficulty.IntValue;
	
	if (iBossIndex == -1) //Please don't ask why I did this; EDIT: Yes, I will! Why?
		return false;
	
	ArrayList hSpawnPoints = new ArrayList();
	char sName[32];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", sName, sizeof(sName));
		if (strcmp(sName, "sf2_proxy_spawnpoint") == 0)
		{
			hSpawnPoints.Push(ent);
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_player_proxyspawn")) != -1)
	{
		SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(ent);
		if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
			continue;

		hSpawnPoints.Push(ent);
	}

	ent = -1;
	if (hSpawnPoints.Length > 0) 
	{
		ent = hSpawnPoints.Get(GetRandomInt(0, hSpawnPoints.Length - 1));
	}
	
	delete hSpawnPoints;
	
	if (ent && ent != -1)
	{
		//SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "Teleport spawn point for boss(%i) proxy: %i", iBossIndex, ent);
		iSpawnPoint = ent;
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", flTeleportPos);
		return true;
	}

	// If the map has no pre defined spawn points, search surrounding CNavAreas around target.

	if (!NavMesh_Exists())
		return false;

	int iTeleportTarget = EntRefToEntIndex(g_iSlenderProxyTarget[iBossIndex]);
	if (!iTeleportTarget || iTeleportTarget == INVALID_ENT_REFERENCE)
		return false;

	float flTeleportMinRange = CalculateTeleportMinRange(iBossIndex, GetProfileFloat(sProfile, "proxies_teleport_range_min", 500.0), GetProfileFloat(sProfile, "proxies_teleport_range_max", 3200.0));
	CNavArea TargetArea = SDK_GetLastKnownArea(iTeleportTarget);
	int iTeleportAreaIndex = -1;

	if (TargetArea != INVALID_NAV_AREA)
	{
		// Search outwards until travel distance is at maximum range.
		Handle hAreaArray = CreateArray(2);
		ArrayStack hAreas = CreateStack();
		NavMesh_CollectSurroundingAreas(hAreas, TargetArea, g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty]);
		{
			int iPoppedAreas;
			
			while (!IsStackEmpty(hAreas))
			{
				int iAreaIndex = -1;
				PopStackCell(hAreas, iAreaIndex);
				
				// Check flags.
				if (TargetArea.Attributes & NAV_MESH_NO_HOSTAGES)
				{
					// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
					continue;
				}
				
				int iIndex = PushArrayCell(hAreaArray, iAreaIndex);
				SetArrayCell(hAreaArray, iIndex, float(NavMeshArea_GetCostSoFar(iAreaIndex)), 1);
				iPoppedAreas++;
			}
#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "Teleport for boss proxy %d: collected %d areas", iBossIndex, iPoppedAreas);
#endif
			
			delete hAreas;
		}
		
		Handle hAreaArrayClose = CreateArray(4);
		Handle hAreaArrayAverage = CreateArray(4);
		Handle hAreaArrayFar = CreateArray(4);
		
		for (int i = 1; i <= 3; i++)
		{
			float flRangeSectionMin = flTeleportMinRange + (GetProfileFloat(sProfile,"proxies_teleport_range_max",3200.0) - flTeleportMinRange) * (float(i - 1) / 3.0);
			float flRangeSectionMax = flTeleportMinRange + (GetProfileFloat(sProfile,"proxies_teleport_range_max",3200.0) - flTeleportMinRange) * (float(i) / 3.0);
			
			for (int i2 = 0, iSize = GetArraySize(hAreaArray); i2 < iSize; i2++)
			{
				int iAreaIndex = GetArrayCell(hAreaArray, i2);
				
				float flAreaSpawnPoint[3];
				NavMeshArea_GetCenter(iAreaIndex, flAreaSpawnPoint);
				
				int iBoss = NPCGetEntIndex(iBossIndex);
			
				// Check space. First raise to HalfHumanHeight * 2, then trace downwards to get ground level.
				float flTraceStartPos[3];
				flTraceStartPos[0] = flAreaSpawnPoint[0];
				flTraceStartPos[1] = flAreaSpawnPoint[1];
				flTraceStartPos[2] = flAreaSpawnPoint[2] + (HalfHumanHeight * 2.0);
			
				float flTraceMins[3];
				flTraceMins[0] = HULL_TF2PLAYER_MINS[0];
				flTraceMins[1] = HULL_TF2PLAYER_MINS[1];
				flTraceMins[2] = 0.0;
			
				
				float flTraceMaxs[3];
				flTraceMaxs[0] = HULL_TF2PLAYER_MAXS[0];
				flTraceMaxs[1] = HULL_TF2PLAYER_MAXS[1];
				flTraceMaxs[2] = 0.0;
				
				Handle hTrace = TR_TraceHullFilterEx(flTraceStartPos,
					flAreaSpawnPoint,
					flTraceMins,
					flTraceMaxs,
					MASK_NPCSOLID,
					TraceRayDontHitEntity,
					iBoss);
				
				float flTraceHitPos[3];
				TR_GetEndPosition(flTraceHitPos, hTrace);
				flTraceHitPos[2] += 1.0;
				CloseHandle(hTrace);
				
				if (TR_PointOutsideWorld(flTraceHitPos))
				{
					continue;
				}
				if(IsSpaceOccupiedPlayer(flTraceHitPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client))
				{
					flTraceHitPos[2] +=5.0;
					if(IsSpaceOccupiedPlayer(flTraceHitPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client))
						continue;
				}
				if (IsSpaceOccupiedNPC(flTraceHitPos,
					HULL_TF2PLAYER_MINS,
					HULL_TF2PLAYER_MAXS,
					iBoss))
				{
					continue;
				}
			
				flAreaSpawnPoint[0] = flTraceHitPos[0];
				flAreaSpawnPoint[1] = flTraceHitPos[1];
				flAreaSpawnPoint[2] = flTraceHitPos[2];

				// Check visibility.
				if (IsPointVisibleToAPlayer(flAreaSpawnPoint, false, false) && !SF_IsBoxingMap() && !SF_IsRaidMap() && !SF_IsProxyMap() && !SF_BossesChaseEndlessly()) continue;

				bool bTooNear = false;
				
				// Check minimum range with players.
				for (int iClient = 1; iClient <= MaxClients; iClient++)
				{
					if (!IsClientInGame(iClient) ||
						!IsPlayerAlive(iClient) ||
						g_bPlayerEliminated[iClient] ||
						IsClientInGhostMode(iClient) || 
						DidClientEscape(iClient))
					{
						continue;
					}
					
					float flTempPos[3];
					GetClientAbsOrigin(iClient, flTempPos);
					
					if (GetVectorSquareMagnitude(flAreaSpawnPoint, flTempPos) <= SquareFloat(GetProfileFloat(sProfile,"proxies_teleport_range_min",500.0)))
					{
						bTooNear = true;
						break;
					}
				}
				
				if (bTooNear) continue;	// This area is not compatible.
				
				// Check travel distance and put in the appropriate arrays.
				float flDist = view_as<float>(GetArrayCell(hAreaArray, i2, 1));
				if (flDist > flRangeSectionMin && flDist < flRangeSectionMax)
				{
					int iIndex = -1;
					Handle hTargetAreaArray = INVALID_HANDLE;
					
					switch (i)
					{
						case 1: 
						{
							iIndex = PushArrayCell(hAreaArrayClose, iAreaIndex);
							hTargetAreaArray = hAreaArrayClose;
						}
						case 2: 
						{
							iIndex = PushArrayCell(hAreaArrayAverage, iAreaIndex);
							hTargetAreaArray = hAreaArrayAverage;
						}
						case 3: 
						{
							iIndex = PushArrayCell(hAreaArrayFar, iAreaIndex);
							hTargetAreaArray = hAreaArrayFar;
						}
					}
					
					if (hTargetAreaArray != INVALID_HANDLE && iIndex != -1)
					{
						SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[0], 1);
						SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[1], 2);
						SetArrayCell(hTargetAreaArray, iIndex, flAreaSpawnPoint[2], 3);
					}
				}
			}
		}

		CloseHandle(hAreaArray);
	
		int iArrayIndex = -1;
	
		if (GetArraySize(hAreaArrayClose))
		{
			iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayClose) - 1);
			iTeleportAreaIndex = GetArrayCell(hAreaArrayClose, iArrayIndex);
			flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayClose, iArrayIndex, 3));
		}
		else if (GetArraySize(hAreaArrayAverage))
		{
			iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayAverage) - 1);
			iTeleportAreaIndex = GetArrayCell(hAreaArrayAverage, iArrayIndex);
			flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayAverage, iArrayIndex, 3));
		}
		else if (GetArraySize(hAreaArrayFar))
		{
			iArrayIndex = GetRandomInt(0, GetArraySize(hAreaArrayFar) - 1);
			iTeleportAreaIndex = GetArrayCell(hAreaArrayFar, iArrayIndex);
			flTeleportPos[0] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(GetArrayCell(hAreaArrayFar, iArrayIndex, 3));
		}
		CloseHandle(hAreaArrayClose);
		CloseHandle(hAreaArrayAverage);
		CloseHandle(hAreaArrayFar);
	}

	if (iTeleportAreaIndex == -1)
		return false;
	
	return true;
}

#include "sf2/npc/npc_chaser.sp"