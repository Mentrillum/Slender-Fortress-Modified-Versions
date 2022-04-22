#if defined _sf2_npc_included
 #endinput
#endif
#define _sf2_npc_included

#define SF2_BOSS_PAGE_CALCULATION 0.3
#define SF2_BOSS_COPY_SPAWN_MIN_DISTANCE 800.0 // The default minimum distance boss copies can spawn from each other.

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
static int g_iNPCModelSkinDifficulty[MAX_BOSSES][Difficulty_Max];
static int g_iNPCModelSkinMax[MAX_BOSSES] = { 0, ... };
static int g_iNPCModelBodyGroups[MAX_BOSSES] = { 0, ... };
static int g_iNPCModelBodyGroupsDifficulty[MAX_BOSSES][Difficulty_Max];
static int g_iNPCModelBodyGroupsMax[MAX_BOSSES] = { 0, ... };
int g_iNPCRaidHitbox[MAX_BOSSES] = { 0, ... };
int g_iNPCGlowEntity[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
static int g_iNPCTauntGlowEntity[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
static float g_flNPCSoundMusicLoop[MAX_BOSSES][Difficulty_Max];
static int g_iNPCAllowMusicOnDifficulty[MAX_BOSSES];
static char g_sNPCName[MAX_BOSSES][Difficulty_Max][SF2_MAX_PROFILE_NAME_LENGTH];
static bool g_bNPCFakeCopiesEnabled[MAX_BOSSES];
static float g_flNPCBlinkLookRate[MAX_BOSSES];
static float g_flNPCBlinkStaticRate[MAX_BOSSES];
static float g_flNPCStepSize[MAX_BOSSES];

static bool g_bNPCDiscoMode[MAX_BOSSES];
static float g_flNPCDiscoRadiusMin[MAX_BOSSES];
static float g_flNPCDiscoRadiusMax[MAX_BOSSES];
static float g_flNPCDiscoModePos[MAX_BOSSES][3];
static bool g_bNPCFestiveLights[MAX_BOSSES];
static int g_iNPCFestiveLightBrightness[MAX_BOSSES];
static float g_flNPCFestiveLightDistance[MAX_BOSSES];
static float g_flNPCFestiveLightRadius[MAX_BOSSES];
static float g_flNPCFestiveLightPos[MAX_BOSSES][3];
static float g_flNPCFestiveLightAng[MAX_BOSSES][3];

static float g_flNPCFieldOfView[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCTurnRate[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCBackstabFOV[MAX_BOSSES] = { 0.0, ... };

static bool g_bNPCTeleportAllowed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportTimeMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportTimeMax[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportRestPeriod[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportStressMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportStressMax[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTeleportPersistencyPeriod[MAX_BOSSES][Difficulty_Max];

static float g_flNPCJumpscareDistance[MAX_BOSSES][Difficulty_Max];
static float g_flNPCJumpscareDuration[MAX_BOSSES][Difficulty_Max];
static float g_flNPCJumpscareCooldown[MAX_BOSSES][Difficulty_Max];
static bool g_bNPCJumpscareOnScare[MAX_BOSSES];
bool g_bNPCIgnoreNonMarkedForChase[MAX_BOSSES];

g_iSlender[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_flNPCSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCMaxSpeed[MAX_BOSSES][Difficulty_Max];
static float g_flNPCAddSpeed[MAX_BOSSES];
static float g_flNPCAddMaxSpeed[MAX_BOSSES];
static float g_flNPCAddAcceleration[MAX_BOSSES];
static float g_flNPCIdleLifetime[MAX_BOSSES][Difficulty_Max];

static float g_flNPCScareRadius[MAX_BOSSES];
static float g_flNPCScareCooldown[MAX_BOSSES];

static bool g_bNPCPlayerScareSpeedBoost[MAX_BOSSES];
static float g_flNPCPlayerSpeedBoostDuration[MAX_BOSSES];

static bool g_bNPCPlayerScareReaction[MAX_BOSSES];
static int g_iNPCPlayerScareReactionType[MAX_BOSSES];

static bool g_bNPCPlayerScareReplenishSprint[MAX_BOSSES];
static int g_iNPCPlayerScareReplenishSprintAmount[MAX_BOSSES];

static int g_iNPCTeleportType[MAX_BOSSES] = { -1, ... };

static float g_flNPCAnger[MAX_BOSSES] = { 1.0, ... };
static float g_flNPCAngerAddOnPageGrab[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCAngerAddOnPageGrabTimeDiff[MAX_BOSSES] = { 0.0, ... };

static float g_flNPCSearchRadius[MAX_BOSSES][Difficulty_Max];
static float g_flNPCHearingRadius[MAX_BOSSES][Difficulty_Max];
static float g_flNPCTauntAlertRange[MAX_BOSSES][Difficulty_Max];
static float g_flNPCInstantKillRadius[MAX_BOSSES] = { 0.0, ... };
static float g_flNPCInstantKillCooldown[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCDeathCamEnabled[MAX_BOSSES] = { false, ... };

static bool g_bNPCProxyWeaponsEnabled[MAX_BOSSES] = { false, ... };

static bool g_bNPCHealthbarEnabled[MAX_BOSSES] = { false, ... };

static int g_iNPCEnemy[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_flNPCProxySpawnChanceMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProxySpawnChanceMax[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProxySpawnChanceThreshold[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProxySpawnNumMin[MAX_BOSSES][Difficulty_Max];
static int g_iNPCProxySpawnNumMax[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProxySpawnCooldownMin[MAX_BOSSES][Difficulty_Max];
static float g_flNPCProxySpawnCooldownMax[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCIgnoreNavPrefer[MAX_BOSSES];

static int g_iNPCDeathMessageDifficultyIndexes[MAX_BOSSES];

static bool g_bNPCDrainCreditsState[MAX_BOSSES];
static int g_iNPCDrainCreditAmount[MAX_BOSSES][Difficulty_Max];

static bool g_bNPCProxySpawnEffectEnabled[MAX_BOSSES];
static float g_flNPCProxySpawnEffectZOffset[MAX_BOSSES];

NextBotActionFactory g_bNBActionFactory;

Handle hTimerMusic = null;//Planning to add a bosses array on.

int g_iBossPathingColor[MAX_BOSSES][4];

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

stock bool NPCGetBossName(int iNPCIndex = -1, char[] buffer,int bufferlen, char sProfile[SF2_MAX_PROFILE_NAME_LENGTH] = "")
{
	if (iNPCIndex == -1 && sProfile[0] == '\0') return false;
	int iDifficulty = g_cvDifficulty.IntValue;
	if (iNPCIndex != -1)
	{
		switch (iDifficulty)
		{
			case Difficulty_Normal: strcopy(buffer, bufferlen, g_sNPCName[iNPCIndex][1]);
			case Difficulty_Hard: strcopy(buffer, bufferlen, g_sNPCName[iNPCIndex][2]);
			case Difficulty_Insane: strcopy(buffer, bufferlen, g_sNPCName[iNPCIndex][3]);
			case Difficulty_Nightmare: strcopy(buffer, bufferlen, g_sNPCName[iNPCIndex][4]);
			case Difficulty_Apollyon: strcopy(buffer, bufferlen, g_sNPCName[iNPCIndex][5]);
		}
	}
	else
	{
		switch (iDifficulty)
		{
			case Difficulty_Normal: GetProfileString(sProfile, "name", buffer, bufferlen);
			case Difficulty_Hard:
			{
				GetProfileString(sProfile, "name_hard", buffer, bufferlen);
				if (buffer[0] == '\0') GetProfileString(sProfile, "name", buffer, bufferlen);
			}
			case Difficulty_Insane:
			{
				GetProfileString(sProfile, "name_insane", buffer, bufferlen);
				if (buffer[0] == '\0')
				{
					GetProfileString(sProfile, "name_hard", buffer, bufferlen);
					if (buffer[0] == '\0') GetProfileString(sProfile, "name", buffer, bufferlen);
				}
			}
			case Difficulty_Nightmare:
			{
				GetProfileString(sProfile, "name_nightmare", buffer, bufferlen);
				if (buffer[0] == '\0')
				{
					GetProfileString(sProfile, "name_insane", buffer, bufferlen);
					if (buffer[0] == '\0')
					{
						GetProfileString(sProfile, "name_hard", buffer, bufferlen);
						if (buffer[0] == '\0') GetProfileString(sProfile, "name", buffer, bufferlen);
					}
				}
			}
			case Difficulty_Apollyon:
			{
				GetProfileString(sProfile, "name_apollyon", buffer, bufferlen);
				if (buffer[0] == '\0')
				{
					GetProfileString(sProfile, "name_nightmare", buffer, bufferlen);
					if (buffer[0] == '\0')
					{
						GetProfileString(sProfile, "name_insane", buffer, bufferlen);
						if (buffer[0] == '\0')
						{
							GetProfileString(sProfile, "name_hard", buffer, bufferlen);
							if (buffer[0] == '\0') GetProfileString(sProfile, "name", buffer, bufferlen);
						}
					}
				}
			}
		}
	}
	return true;
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
	if(hTimerMusic != null)
	{
		delete hTimerMusic;
	}
	//Stop the music for all players.
	for(int i = 1;i<=MaxClients;i++)
	{
		if(IsValidClient(i))
		{
			if (sCurrentMusicTrack[0] != '\0') StopSound(i, MUSIC_CHAN, sCurrentMusicTrack);
			ClientUpdateMusicSystem(i);
		}
	}
}
void CheckIfMusicValid()
{
	int iDifficulty = g_cvDifficulty.IntValue;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1) continue;
		if (g_iNPCAllowMusicOnDifficulty[i] & iDifficulty)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(i, sProfile, sizeof(sProfile));
			for(int client = 1;client <=MaxClients;client ++)
			{
				if(IsValidClient(client) && (!g_bPlayerEliminated[client] || IsClientInGhostMode(client)))
				{
					GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNormal,sizeof(sCurrentMusicTrackNormal));
				
					GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
					if (sCurrentMusicTrackHard[0] == '\0') GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
					
					GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
					if (sCurrentMusicTrackInsane[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
						if (sCurrentMusicTrackInsane[0] == '\0')
						{
							GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
						}
					}
					
					GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
					if (sCurrentMusicTrackNightmare[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
						if (sCurrentMusicTrackNightmare[0] == '\0')
						{
							GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
							if (sCurrentMusicTrackNightmare[0] == '\0')
							{
								GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
							}
						}
					}
					
					GetRandomStringFromProfile(sProfile,"sound_music_apollyon",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
					if (sCurrentMusicTrackApollyon[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
						if (sCurrentMusicTrackApollyon[0] == '\0')
						{
							GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
							if (sCurrentMusicTrackApollyon[0] == '\0')
							{
								GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
								if (sCurrentMusicTrackApollyon[0] == '\0')
								{
									GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
								}
							}
						}
					}
					switch (g_cvDifficulty.IntValue)
					{
						case Difficulty_Normal, Difficulty_Easy: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNormal);
						case Difficulty_Hard: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackHard);
						case Difficulty_Insane: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackInsane);
						case Difficulty_Nightmare: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNightmare);
						case Difficulty_Apollyon: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackApollyon);
					}
					if (sCurrentMusicTrack[0] != '\0')
					{
						hTimerMusic = CreateTimer(NPCGetSoundMusicLoop(i, iDifficulty),BossMusic,i,TIMER_FLAG_NO_MAPCHANGE);
						StopSound(client, MUSIC_CHAN, sCurrentMusicTrack);
						ClientChaseMusicReset(client);
						ClientChaseMusicSeeReset(client);
						ClientAlertMusicReset(client);
						ClientIdleMusicReset(client);
						ClientStopAllSlenderSounds(client, sProfile, "sound_chase_music", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(client, sProfile, "sound_alert_music", SNDCHAN_AUTO);
						ClientStopAllSlenderSounds(client, sProfile, "sound_chase_visible", SNDCHAN_AUTO);
						if (g_strPlayerMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.0001);
						ClientMusicStart(client, sCurrentMusicTrack, _, MUSIC_PAGE_VOLUME,true);
						ClientUpdateMusicSystem(client);
						break;
					}
				}
			}
			break;
		}
	}
}
stock bool MusicActive()
{
	if(hTimerMusic!=null)
		return true;
	return false;
}
stock bool BossHasMusic(char[] sProfile)
{
	int iDifficulty = g_cvDifficulty.IntValue;
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
stock bool BossMatchesCurrentMusic(char[] sProfile)
{
	if (!IsProfileValid(sProfile)) return false;
	
	char buffer[PLATFORM_MAX_PATH], sCurrentMusic[PLATFORM_MAX_PATH];
	int iDifficulty = g_cvDifficulty.IntValue;

	GetBossMusic(sCurrentMusic, sizeof(sCurrentMusic));
	
	g_hConfig.Rewind();
	if (g_hConfig.JumpToKey(sProfile))
	{
		char s[32];
		
		switch (iDifficulty)
		{
			case Difficulty_Normal:
			{
				if (g_hConfig.JumpToKey("sound_music"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
			}
			case Difficulty_Hard:
			{
				if (g_hConfig.JumpToKey("sound_music"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_hard"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
			}
			case Difficulty_Insane:
			{
				if (g_hConfig.JumpToKey("sound_music"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_hard"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_insane"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
			}
			case Difficulty_Nightmare:
			{
				if (g_hConfig.JumpToKey("sound_music"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_hard"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_insane"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_nightmare"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
			}
			case Difficulty_Apollyon:
			{
				if (g_hConfig.JumpToKey("sound_music"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_hard"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_insane"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_nightmare"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
				g_hConfig.Rewind();
				g_hConfig.JumpToKey(sProfile);
				if (g_hConfig.JumpToKey("sound_music_apollyon"))
				{
					for (int i2 = 1;; i2++)
					{
						FormatEx(s, sizeof(s), "%d", i2);
						g_hConfig.GetString(s, buffer, sizeof(buffer));
						if (buffer[0] == '\0') break;
						
						if (strcmp(buffer, sCurrentMusic, false) == 0) return true;
					}
				}
			}
		}
	}

	return false;
}
stock void GetBossMusic(char[] buffer,int bufferlen)
{
	int iDifficulty = g_cvDifficulty.IntValue;
	if (!SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))	
	{
		switch (iDifficulty)
		{
			case Difficulty_Normal: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNormal);
				strcopy(buffer,bufferlen,sCurrentMusicTrackNormal);
			}
			case Difficulty_Hard: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackHard);
				strcopy(buffer,bufferlen,sCurrentMusicTrackHard);
			}
			case Difficulty_Insane: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackInsane);
				strcopy(buffer,bufferlen,sCurrentMusicTrackInsane);
			}
			case Difficulty_Nightmare: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNightmare);
				strcopy(buffer,bufferlen,sCurrentMusicTrackNightmare);
			}
			case Difficulty_Apollyon: 
			{
				strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackApollyon);
				strcopy(buffer,bufferlen,sCurrentMusicTrackApollyon);
			}
		}
	}
	else
		strcopy(buffer,bufferlen,TRIPLEBOSSESMUSIC);
}
public Action BossMusic(Handle timer,any iBossIndex)
{
	int iDifficulty = g_cvDifficulty.IntValue;
	float time = NPCGetSoundMusicLoop(iBossIndex, iDifficulty);
	if (time > 0.0 && (g_iNPCAllowMusicOnDifficulty[iBossIndex] & iDifficulty))
	{
		if(iBossIndex > -1)
		{
			char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
			for(int i = 1;i<=MaxClients;i++)
			{
				if(IsValidClient(i) && sCurrentMusicTrack[0] != '\0')
				{
					StopSound(i, MUSIC_CHAN, sCurrentMusicTrack);
				}
			}
			hTimerMusic = CreateTimer(time,BossMusic,iBossIndex,TIMER_FLAG_NO_MAPCHANGE);
			return Plugin_Continue;
		}
		NPCStopMusic();
	}
	hTimerMusic = null;
	return Plugin_Continue;
}
void NPCRemoveAll()
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		NPCRemove(i);
	}
}

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

float NPCGetSoundMusicLoop(int iNPCIndex, int iDifficulty)
{
	return g_flNPCSoundMusicLoop[iNPCIndex][iDifficulty];
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

int NPCGetModelSkinDifficulty(int iNPCIndex, int iDifficulty)
{
	return g_iNPCModelSkinDifficulty[iNPCIndex][iDifficulty];
}

int NPCGetModelSkinMax(int iNPCIndex)
{
	return g_iNPCModelSkinMax[iNPCIndex];
}

int NPCGetModelBodyGroups(int iNPCIndex)
{
	return g_iNPCModelBodyGroups[iNPCIndex];
}

int NPCGetModelBodyGroupsDifficulty(int iNPCIndex, int iDifficulty)
{
	return g_iNPCModelBodyGroupsDifficulty[iNPCIndex][iDifficulty];
}

int NPCGetModelBodyGroupsMax(int iNPCIndex)
{
	return g_iNPCModelBodyGroupsMax[iNPCIndex];
}

int NPCGetRaidHitbox(int iNPCIndex)
{
	return g_iNPCRaidHitbox[iNPCIndex];
}

float NPCGetBlinkLookRate(int iNPCIndex)
{
	return g_flNPCBlinkLookRate[iNPCIndex];
}

float NPCGetBlinkStaticRate(int iNPCIndex)
{
	return g_flNPCBlinkStaticRate[iNPCIndex];
}

bool NPCGetDiscoModeState(int iNPCIndex)
{
	return g_bNPCDiscoMode[iNPCIndex];
}

float NPCGetDiscoModeRadiusMin(int iNPCIndex)
{
	return g_flNPCDiscoRadiusMin[iNPCIndex];
}

float NPCGetDiscoModeRadiusMax(int iNPCIndex)
{
	return g_flNPCDiscoRadiusMax[iNPCIndex];
}

float[] NPCGetDiscoModePos(int iNPCIndex)
{
	return g_flNPCDiscoModePos[iNPCIndex];
}

bool NPCGetFestiveLightState(int iNPCIndex)
{
	return g_bNPCFestiveLights[iNPCIndex];
}

int NPCGetFestiveLightBrightness(int iNPCIndex)
{
	return g_iNPCFestiveLightBrightness[iNPCIndex];
}

float NPCGetFestiveLightDistance(int iNPCIndex)
{
	return g_flNPCFestiveLightDistance[iNPCIndex];
}

float NPCGetFestiveLightRadius(int iNPCIndex)
{
	return g_flNPCFestiveLightRadius[iNPCIndex];
}

float[] NPCGetFestiveLightPosition(int iNPCIndex)
{
	return g_flNPCFestiveLightPos[iNPCIndex];
}

float[] NPCGetFestiveLightAngle(int iNPCIndex)
{
	return g_flNPCFestiveLightAng[iNPCIndex];
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

bool NPCGetRainbowOutlineState(int iNPCIndex)
{
	return g_bSlenderUseRainbowOutline[iNPCIndex];
}

float NPCGetRainbowOutlineCycleRate(int iNPCIndex)
{
	return g_flSlenderRainbowCycleRate[iNPCIndex];
}

float NPCGetSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCSpeed[iNPCIndex][iDifficulty];
}

float NPCGetMaxSpeed(int iNPCIndex,int iDifficulty)
{
	return g_flNPCMaxSpeed[iNPCIndex][iDifficulty];
}

float NPCGetAcceleration(int iNPCIndex,int iDifficulty)
{
	return g_flSlenderAcceleration[iNPCIndex][iDifficulty];
}

float NPCSetAddSpeed(int iNPCIndex, float flAmount)
{
	g_flNPCAddSpeed[iNPCIndex] += flAmount;
}

float NPCSetAddMaxSpeed(int iNPCIndex, float flAmount)
{
	g_flNPCAddMaxSpeed[iNPCIndex] += flAmount;
}

float NPCSetAddAcceleration(int iNPCIndex, float flAmount)
{
	g_flNPCAddAcceleration[iNPCIndex] += flAmount;
}

float NPCGetAddSpeed(int iNPCIndex)
{
	return g_flNPCAddSpeed[iNPCIndex];
}

float NPCGetAddMaxSpeed(int iNPCIndex)
{
	return g_flNPCAddMaxSpeed[iNPCIndex];
}

float NPCGetAddAcceleration(int iNPCIndex)
{
	return g_flNPCAddAcceleration[iNPCIndex];
}

bool NPCIsTeleportAllowed(int iNPCIndex, int iDifficulty)
{
	return g_bNPCTeleportAllowed[iNPCIndex][iDifficulty];
}

float NPCGetTeleportTimeMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportTimeMin[iNPCIndex][iDifficulty];
}

float NPCGetTeleportTimeMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportTimeMax[iNPCIndex][iDifficulty];
}

float NPCGetTeleportRestPeriod(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportRestPeriod[iNPCIndex][iDifficulty];
}

float NPCGetTeleportStressMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportStressMin[iNPCIndex][iDifficulty];
}

float NPCGetTeleportStressMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportStressMax[iNPCIndex][iDifficulty];
}

float NPCGetTeleportPersistencyPeriod(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTeleportPersistencyPeriod[iNPCIndex][iDifficulty];
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

bool NPCGetJumpscareOnScare(int iNPCIndex)
{
	return g_bNPCJumpscareOnScare[iNPCIndex];
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

float NPCGetTauntAlertRange(int iNPCIndex, int iDifficulty)
{
	return g_flNPCTauntAlertRange[iNPCIndex][iDifficulty];
}

float NPCGetScareRadius(int iNPCIndex)
{
	return g_flNPCScareRadius[iNPCIndex];
}

float NPCGetScareCooldown(int iNPCIndex)
{
	return g_flNPCScareCooldown[iNPCIndex];
}

bool NPCGetSpeedBoostOnScare(int iNPCIndex)
{
	return g_bNPCPlayerScareSpeedBoost[iNPCIndex];
}

float NPCGetScareSpeedBoostDuration(int iNPCIndex)
{
	return g_flNPCPlayerSpeedBoostDuration[iNPCIndex];
}

bool NPCGetScareReactionState(int iNPCIndex)
{
	return g_bNPCPlayerScareReaction[iNPCIndex];
}

int NPCGetScareReactionType(int iNPCIndex)
{
	return g_iNPCPlayerScareReactionType[iNPCIndex];
}

bool NPCGetScareReplenishSprintState(int iNPCIndex)
{
	return g_bNPCPlayerScareReplenishSprint[iNPCIndex];
}

int NPCGetScareReplenishSprintAmount(int iNPCIndex)
{
	return g_iNPCPlayerScareReplenishSprintAmount[iNPCIndex];
}

float NPCGetInstantKillRadius(int iNPCIndex)
{
	return g_flNPCInstantKillRadius[iNPCIndex];
}

float NPCGetInstantKillCooldown(int iNPCIndex, int iDifficulty)
{
	return g_flNPCInstantKillCooldown[iNPCIndex][iDifficulty];
}

int NPCGetTeleportType(int iNPCIndex)
{
	return g_iNPCTeleportType[iNPCIndex];
}

bool NPCGetHealthbarState(int iNPCIndex)
{
	return g_bNPCHealthbarEnabled[iNPCIndex];
}

bool NPCGetFakeCopyState(int iNPCIndex)
{
	return g_bNPCFakeCopiesEnabled[iNPCIndex];
}

#if defined _store_included
bool NPCGetDrainCreditState(int iNPCIndex)
{
	return g_bNPCDrainCreditsState[iNPCIndex];
}

int NPCGetDrainCreditAmount(int iNPCIndex, int iDifficulty)
{
	return g_iNPCDrainCreditAmount[iNPCIndex][iDifficulty];
}
#endif

bool NPCGetProxySpawnEffectState(int iNPCIndex)
{
	return g_bNPCProxySpawnEffectEnabled[iNPCIndex];
}

float NPCGetProxySpawnEffectZOffset(int iNPCIndex)
{
	return g_flNPCProxySpawnEffectZOffset[iNPCIndex];
}

float NPCGetProxySpawnChanceMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProxySpawnChanceMin[iNPCIndex][iDifficulty];
}

float NPCGetProxySpawnChanceMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProxySpawnChanceMax[iNPCIndex][iDifficulty];
}

float NPCGetProxySpawnChanceThreshold(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProxySpawnChanceThreshold[iNPCIndex][iDifficulty];
}

int NPCGetProxySpawnNumMin(int iNPCIndex, int iDifficulty)
{
	return g_iNPCProxySpawnNumMin[iNPCIndex][iDifficulty];
}

int NPCGetProxySpawnNumMax(int iNPCIndex, int iDifficulty)
{
	return g_iNPCProxySpawnNumMax[iNPCIndex][iDifficulty];
}

float NPCGetProxySpawnCooldownMin(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProxySpawnCooldownMin[iNPCIndex][iDifficulty];
}

float NPCGetProxySpawnCooldownMax(int iNPCIndex, int iDifficulty)
{
	return g_flNPCProxySpawnCooldownMax[iNPCIndex][iDifficulty];
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

bool NPCShouldHearEntity(int iNPCIndex, int entity, SoundType soundType)
{
	if (!IsValidEntity(entity))
		return false;

	Action result = Plugin_Continue;
	Call_StartForward(fOnBossHearEntity);
	Call_PushCell(iNPCIndex);
	Call_PushCell(entity);
	Call_PushCell(soundType);
	Call_Finish(result);

	if (result != Plugin_Continue)
		return false;

	return true;
}

bool NPCAreAvailablePlayersAlive()
{
	int number = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == TFTeam_Red && !g_bPlayerEliminated[i] && !DidClientEscape(i)) 
			number++;
	}
	return number >= 1;
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
	
	g_hConfig.Rewind();
	g_hConfig.JumpToKey(sProfile);
	
	if (!g_hConfig.JumpToKey("attributes")) return false;
	
	return g_hConfig.JumpToKey(sAttribute);
}

float NPCGetAttributeValue(int iNPCIndex, const char[] sAttribute, float flDefaultValue=0.0)
{
	if (!NPCHasAttribute(iNPCIndex, sAttribute)) return flDefaultValue;
	return g_hConfig.GetFloat("value", flDefaultValue);
}

bool SlenderCanRemove(int iBossIndex)
{
	if (NPCGetUniqueID(iBossIndex) == -1) return false;
	
	if (PeopleCanSeeSlender(iBossIndex, _, false)) return false;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iTeleportType = NPCGetTeleportType(iBossIndex);

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	switch (iTeleportType)
	{
		case 0:
		{
			if (NPCGetFlags(iBossIndex) & SFF_STATICONRADIUS)
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

bool SelectProfile(SF2NPC_BaseNPC Npc, const char[] sProfile,int iAdditionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool bSpawnCompanions=true, bool bPlaySpawnSound=true, bool bInvincible = false)
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
	
	g_iNPCModelBodyGroups[Npc.Index] = GetBossProfileBodyGroups(iProfileIndex);
	
	g_iNPCModelBodyGroupsMax[Npc.Index] = GetBossProfileBodyGroupsMax(iProfileIndex);

	g_iNPCRaidHitbox[Npc.Index] = GetBossProfileRaidHitbox(iProfileIndex);

	g_bNPCIgnoreNavPrefer[Npc.Index] = GetBossProfileIgnoreNavPrefer(iProfileIndex);

	g_bNPCFakeCopiesEnabled[Npc.Index] = GetBossProfileFakeCopies(iProfileIndex);

	g_flNPCBlinkLookRate[Npc.Index] = GetBossProfileBlinkLookRate(iProfileIndex);
	g_flNPCBlinkStaticRate[Npc.Index] = GetBossProfileBlinkStaticRate(iProfileIndex);

	g_flNPCStepSize[Npc.Index] = GetBossProfileStepSize(iProfileIndex);

	g_bNPCDiscoMode[Npc.Index] = GetBossProfileDiscoModeState(iProfileIndex);
	g_flNPCDiscoRadiusMin[Npc.Index] = GetBossProfileDiscoRadiusMin(iProfileIndex);
	g_flNPCDiscoRadiusMax[Npc.Index] = GetBossProfileDiscoRadiusMax(iProfileIndex);

	g_bNPCFestiveLights[Npc.Index] = GetBossProfileFestiveLightState(iProfileIndex);
	g_iNPCFestiveLightBrightness[Npc.Index] = GetBossProfileFestiveLightBrightness(iProfileIndex);
	g_flNPCFestiveLightDistance[Npc.Index] = GetBossProfileFestiveLightDistance(iProfileIndex);
	g_flNPCFestiveLightRadius[Npc.Index] = GetBossProfileFestiveLightRadius(iProfileIndex);
	GetProfileVector(sProfile, "disco_mode_pos", g_flNPCDiscoModePos[Npc.Index]);
	GetProfileVector(sProfile, "festive_lights_pos", g_flNPCFestiveLightPos[Npc.Index]);
	GetProfileVector(sProfile, "festive_lights_ang", g_flNPCFestiveLightAng[Npc.Index]);
	
	g_bSlenderUseCustomOutlines[Npc.Index] = GetBossProfileCustomOutlinesState(iProfileIndex);
	g_iSlenderOutlineColorR[Npc.Index] = GetBossProfileOutlineColorR(iProfileIndex);
	g_iSlenderOutlineColorG[Npc.Index] = GetBossProfileOutlineColorG(iProfileIndex);
	g_iSlenderOutlineColorB[Npc.Index] = GetBossProfileOutlineColorB(iProfileIndex);
	g_iSlenderOutlineTransparency[Npc.Index] = GetBossProfileOutlineTransparency(iProfileIndex);
	g_bSlenderUseRainbowOutline[Npc.Index] = GetBossProfileRainbowOutlineState(iProfileIndex);
	g_flSlenderRainbowCycleRate[Npc.Index] = GetBossProfileRainbowCycleRate(iProfileIndex);

	g_bNPCProxyWeaponsEnabled[Npc.Index] = GetBossProfileProxyWeapons(iProfileIndex);

	g_bNPCDrainCreditsState[Npc.Index] = GetBossProfileDrainCreditState(iProfileIndex);
	g_bNPCProxySpawnEffectEnabled[Npc.Index] = GetBossProfileProxySpawnEffectState(iProfileIndex);
	g_flNPCProxySpawnEffectZOffset[Npc.Index] = GetBossProfileProxySpawnEffectZOffset(iProfileIndex);
	
	if (SF_IsSlaughterRunMap()) NPCSetFlags(Npc.Index, GetBossProfileFlags(iProfileIndex) | iAdditionalBossFlags | SFF_NOTELEPORT);
	else NPCSetFlags(Npc.Index, GetBossProfileFlags(iProfileIndex) | iAdditionalBossFlags);
	
	GetBossProfileEyePositionOffset(iProfileIndex, g_flSlenderEyePosOffset[Npc.Index]);
	GetBossProfileEyeAngleOffset(iProfileIndex, g_flSlenderEyeAngOffset[Npc.Index]);
	
	GetProfileVector(sProfile, "mins", g_flSlenderDetectMins[Npc.Index]);
	GetProfileVector(sProfile, "maxs", g_flSlenderDetectMaxs[Npc.Index]);

	GetProfileColor(sProfile, "effect_rendercolor", g_iSlenderRenderColor[Npc.Index][0], g_iSlenderRenderColor[Npc.Index][1], g_iSlenderRenderColor[Npc.Index][2], g_iSlenderRenderColor[Npc.Index][3], 
					255, 255, 255, 255);

	g_iSlenderRenderFX[Npc.Index] = GetProfileNum(sProfile, "effect_renderfx", view_as<int>(RENDERFX_NONE));
	g_iSlenderRenderMode[Npc.Index] = GetProfileNum(sProfile, "effect_rendermode", view_as<int>(RENDER_NORMAL));
	
	//	NPCSetAnger(Npc.Index, GetBossProfileAngerStart(iProfileIndex));
	Npc.Anger = GetBossProfileAngerStart(iProfileIndex);
	
	g_flNPCAngerAddOnPageGrab[Npc.Index] = GetBossProfileAngerAddOnPageGrab(iProfileIndex);
	g_flNPCAngerAddOnPageGrabTimeDiff[Npc.Index] = GetBossProfileAngerPageGrabTimeDiff(iProfileIndex);

	g_iSlenderCopyMaster[Npc.Index] = -1;
	g_iSlenderCompanionMaster[Npc.Index] = -1;

	for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
	{
		g_flNPCSoundMusicLoop[Npc.Index][iDifficulty] = GetBossProfileSoundMusicLoop(iProfileIndex, iDifficulty);
		g_flNPCSpeed[Npc.Index][iDifficulty] = GetBossProfileSpeed(iProfileIndex, iDifficulty);
		g_flNPCMaxSpeed[Npc.Index][iDifficulty] = GetBossProfileMaxSpeed(iProfileIndex, iDifficulty);
		g_flSlenderAcceleration[Npc.Index][iDifficulty] = GetBossProfileAcceleration(iProfileIndex, iDifficulty);
		g_flNPCIdleLifetime[Npc.Index][iDifficulty] = GetBossProfileIdleLifetime(iProfileIndex, iDifficulty);
		g_flSlenderStaticRadius[Npc.Index][iDifficulty] = GetBossProfileStaticRadius(iProfileIndex, iDifficulty);
		g_flSlenderStaticRate[Npc.Index][iDifficulty] = GetBossProfileStaticRate(iProfileIndex, iDifficulty);
		g_flSlenderStaticRateDecay[Npc.Index][iDifficulty] = GetBossProfileStaticRateDecay(iProfileIndex, iDifficulty);
		g_flSlenderStaticGraceTime[Npc.Index][iDifficulty] = GetBossProfileStaticGraceTime(iProfileIndex, iDifficulty);
		g_flNPCSearchRadius[Npc.Index][iDifficulty] = GetBossProfileSearchRadius(iProfileIndex, iDifficulty);
		g_flNPCHearingRadius[Npc.Index][iDifficulty] = GetBossProfileHearRadius(iProfileIndex, iDifficulty);
		g_flNPCTauntAlertRange[Npc.Index][iDifficulty] = GetBossProfileTauntAlertRange(iProfileIndex, iDifficulty);
		g_flSlenderTeleportMinRange[Npc.Index][iDifficulty] = GetBossProfileTeleportRangeMin(iProfileIndex, iDifficulty);
		g_flSlenderTeleportMaxRange[Npc.Index][iDifficulty] = GetBossProfileTeleportRangeMax(iProfileIndex, iDifficulty);
		g_bNPCTeleportAllowed[Npc.Index][iDifficulty] = GetBossProfileTeleportAllowed(iProfileIndex, iDifficulty);
		g_flNPCTeleportTimeMin[Npc.Index][iDifficulty] = GetBossProfileTeleportTimeMin(iProfileIndex, iDifficulty);
		g_flNPCTeleportTimeMax[Npc.Index][iDifficulty] = GetBossProfileTeleportTimeMax(iProfileIndex, iDifficulty);
		g_flNPCTeleportRestPeriod[Npc.Index][iDifficulty] = GetBossProfileTeleportTargetRestPeriod(iProfileIndex, iDifficulty);
		g_flNPCTeleportStressMin[Npc.Index][iDifficulty] = GetBossProfileTeleportTargetStressMin(iProfileIndex, iDifficulty);
		g_flNPCTeleportStressMax[Npc.Index][iDifficulty] = GetBossProfileTeleportTargetStressMax(iProfileIndex, iDifficulty);
		g_flNPCTeleportPersistencyPeriod[Npc.Index][iDifficulty] = GetBossProfileTeleportTargetPersistencyPeriod(iProfileIndex, iDifficulty);
		g_flNPCJumpscareDistance[Npc.Index][iDifficulty] = GetBossProfileJumpscareDistance(iProfileIndex, iDifficulty);
		g_flNPCJumpscareDuration[Npc.Index][iDifficulty] = GetBossProfileJumpscareDuration(iProfileIndex, iDifficulty);
		g_flNPCJumpscareCooldown[Npc.Index][iDifficulty] = GetBossProfileJumpscareCooldown(iProfileIndex, iDifficulty);
		g_iNPCModelSkinDifficulty[Npc.Index][iDifficulty] = GetBossProfileSkinDifficulty(iProfileIndex, iDifficulty);
		g_iNPCModelBodyGroupsDifficulty[Npc.Index][iDifficulty] = GetBossProfileBodyGroupsDifficulty(iProfileIndex, iDifficulty);
		g_iSlenderMaxCopies[Npc.Index][iDifficulty] = GetBossProfileMaxCopies(iProfileIndex, iDifficulty);
		g_flNPCInstantKillCooldown[Npc.Index][iDifficulty] = GetBossProfileInstantKillCooldown(iProfileIndex, iDifficulty);

		g_flSlenderProxyDamageVsEnemy[Npc.Index][iDifficulty] = GetBossProfileProxyDamageVsEnemy(iProfileIndex, iDifficulty);
		g_flSlenderProxyDamageVsBackstab[Npc.Index][iDifficulty] = GetBossProfileProxyDamageVsBackstab(iProfileIndex, iDifficulty);
		g_flSlenderProxyDamageVsSelf[Npc.Index][iDifficulty] = GetBossProfileProxyDamageVsSelf(iProfileIndex, iDifficulty);
		g_iSlenderProxyControlGainHitEnemy[Npc.Index][iDifficulty] = GetBossProfileProxyControlGainHitEnemy(iProfileIndex, iDifficulty);
		g_iSlenderProxyControlGainHitByEnemy[Npc.Index][iDifficulty] = GetBossProfileProxyControlGainHitByEnemy(iProfileIndex, iDifficulty);
		g_flSlenderProxyControlDrainRate[Npc.Index][iDifficulty] = GetBossProfileProxyControlDrainRate(iProfileIndex, iDifficulty);
		g_iSlenderMaxProxies[Npc.Index][iDifficulty] = GetBossProfileMaxProxies(iProfileIndex, iDifficulty);
		g_flNPCProxySpawnChanceMin[Npc.Index][iDifficulty] = GetBossProfileProxySpawnChanceMin(iProfileIndex, iDifficulty);
		g_flNPCProxySpawnChanceMax[Npc.Index][iDifficulty] = GetBossProfileProxySpawnChanceMax(iProfileIndex, iDifficulty);
		g_flNPCProxySpawnChanceThreshold[Npc.Index][iDifficulty] = GetBossProfileProxySpawnChanceThreshold(iProfileIndex, iDifficulty);
		g_iNPCProxySpawnNumMin[Npc.Index][iDifficulty] = GetBossProfileProxySpawnNumberMin(iProfileIndex, iDifficulty);
		g_iNPCProxySpawnNumMax[Npc.Index][iDifficulty] = GetBossProfileProxySpawnNumberMax(iProfileIndex, iDifficulty);
		g_flNPCProxySpawnCooldownMin[Npc.Index][iDifficulty] = GetBossProfileProxySpawnCooldownMin(iProfileIndex, iDifficulty);
		g_flNPCProxySpawnCooldownMax[Npc.Index][iDifficulty] = GetBossProfileProxySpawnCooldownMax(iProfileIndex, iDifficulty);
		g_flSlenderProxyTeleportMinRange[Npc.Index][iDifficulty] = GetBossProfileProxyTeleportRangeMin(iProfileIndex, iDifficulty);
		g_flSlenderProxyTeleportMaxRange[Npc.Index][iDifficulty] = GetBossProfileProxyTeleportRangeMax(iProfileIndex, iDifficulty);
		g_iNPCDrainCreditAmount[Npc.Index][iDifficulty] = GetBossProfileDrainCreditAmount(iProfileIndex, iDifficulty);
	}

	GetProfileString(sProfile, "name", g_sNPCName[Npc.Index][1], sizeof(g_sNPCName[][]));

	strcopy(g_sNPCName[Npc.Index][0], sizeof(g_sNPCName[][]), g_sNPCName[Npc.Index][1]);

	GetProfileString(sProfile, "name_hard",  g_sNPCName[Npc.Index][2], sizeof(g_sNPCName[][]));
	if (g_sNPCName[Npc.Index][2][0] == '\0') GetProfileString(sProfile, "name", g_sNPCName[Npc.Index][2], sizeof(g_sNPCName[][]));

	GetProfileString(sProfile, "name_insane", g_sNPCName[Npc.Index][3], sizeof(g_sNPCName[][]));
	if (g_sNPCName[Npc.Index][3][0] == '\0')
	{
		GetProfileString(sProfile, "name_hard", g_sNPCName[Npc.Index][3], sizeof(g_sNPCName[][]));
		if (g_sNPCName[Npc.Index][3][0] == '\0') GetProfileString(sProfile, "name", g_sNPCName[Npc.Index][3], sizeof(g_sNPCName[][]));
	}

	GetProfileString(sProfile, "name_nightmare", g_sNPCName[Npc.Index][4], sizeof(g_sNPCName[][]));
	if (g_sNPCName[Npc.Index][4][0] == '\0')
	{
		GetProfileString(sProfile, "name_insane", g_sNPCName[Npc.Index][4], sizeof(g_sNPCName[][]));
		if (g_sNPCName[Npc.Index][4][0] == '\0')
		{
			GetProfileString(sProfile, "name_hard", g_sNPCName[Npc.Index][4], sizeof(g_sNPCName[][]));
			if (g_sNPCName[Npc.Index][4][0] == '\0') GetProfileString(sProfile, "name", g_sNPCName[Npc.Index][4], sizeof(g_sNPCName[][]));
		}
	}

	GetProfileString(sProfile, "name_apollyon", g_sNPCName[Npc.Index][5], sizeof(g_sNPCName[][]));
	if (g_sNPCName[Npc.Index][5][0] == '\0')
	{
		GetProfileString(sProfile, "name_nightmare", g_sNPCName[Npc.Index][5], sizeof(g_sNPCName[][]));
		if (g_sNPCName[Npc.Index][5][0] == '\0')
		{
			GetProfileString(sProfile, "name_insane", g_sNPCName[Npc.Index][5], sizeof(g_sNPCName[][]));	
			if (g_sNPCName[Npc.Index][5][0] == '\0')
			{
				GetProfileString(sProfile, "name_hard", g_sNPCName[Npc.Index][5], sizeof(g_sNPCName[][]));
				if (g_sNPCName[Npc.Index][5][0] == '\0') GetProfileString(sProfile, "name", g_sNPCName[Npc.Index][5], sizeof(g_sNPCName[][]));
			}
		}
	}
	
	g_bNPCJumpscareOnScare[Npc.Index] = GetBossProfileJumpscareOnScare(iProfileIndex);
	
	g_flNPCTurnRate[Npc.Index] = GetBossProfileTurnRate(iProfileIndex);
	if (!SF_IsSlaughterRunMap()) g_flNPCFieldOfView[Npc.Index] = GetBossProfileFOV(iProfileIndex);
	else g_flNPCFieldOfView[Npc.Index] = 360.0;
	g_flNPCBackstabFOV[Npc.Index] = 180.0;
	
	g_flNPCScareRadius[Npc.Index] = GetBossProfileScareRadius(iProfileIndex);
	g_flNPCScareCooldown[Npc.Index] = GetBossProfileScareCooldown(iProfileIndex);

	g_bNPCPlayerScareSpeedBoost[Npc.Index] = GetBossProfileSpeedBoostOnScare(iProfileIndex);
	g_flNPCPlayerSpeedBoostDuration[Npc.Index] = GetBossProfileScareSpeedBoostDuration(iProfileIndex);

	g_bNPCPlayerScareReaction[Npc.Index] = GetBossProfileScareReactionState(iProfileIndex);
	g_iNPCPlayerScareReactionType[Npc.Index] = GetBossProfileScareReactionType(iProfileIndex);

	g_bNPCPlayerScareReplenishSprint[Npc.Index] = GetBossProfileScareReplenishState(iProfileIndex);
	g_iNPCPlayerScareReplenishSprintAmount[Npc.Index] = GetBossProfileScareReplenishAmount(iProfileIndex);
	
	g_flNPCInstantKillRadius[Npc.Index] = GetBossProfileInstantKillRadius(iProfileIndex);
	
	g_iNPCTeleportType[Npc.Index] = GetBossProfileTeleportType(iProfileIndex);

	g_bSlenderTeleportIgnoreChases[Npc.Index] = GetBossProfileTeleportIgnoreChases(iProfileIndex);

	g_bSlenderTeleportIgnoreVis[Npc.Index] = GetBossProfileTeleportIgnoreVis(iProfileIndex);

	g_bNPCHealthbarEnabled[Npc.Index] = GetBossProfileHealthbarState(iProfileIndex);

	g_bSlenderProxiesAllowNormalVoices[Npc.Index] = GetBossProfileProxyAllowNormalVoices(iProfileIndex);

	g_iNPCDeathMessageDifficultyIndexes[Npc.Index] = GetBossProfileChatDeathMessageDifficultyIndexes(iProfileIndex);
	
	g_flNPCAddSpeed[Npc.Index] = 0.0;
	g_flNPCAddMaxSpeed[Npc.Index] = 0.0;
	g_flNPCAddAcceleration[Npc.Index] = 0.0;
	
	g_iNPCEnemy[Npc.Index] = INVALID_ENT_REFERENCE;
	
	g_iNPCPlayerScareVictin[Npc.Index] = INVALID_ENT_REFERENCE;
	g_bNPCChasingScareVictin[Npc.Index] = false;
	g_bNPCLostChasingScareVictim[Npc.Index] = false;

	g_iSlenderProxyHurtChannel[Npc.Index] = GetBossProfileSoundProxyHurtChannel(iProfileIndex);
	g_iSlenderProxyHurtLevel[Npc.Index] = GetBossProfileSoundProxyHurtLevel(iProfileIndex);
	g_iSlenderProxyHurtFlags[Npc.Index] = GetBossProfileSoundProxyHurtFlags(iProfileIndex);
	g_flSlenderProxyHurtVolume[Npc.Index] = GetBossProfileSoundProxyHurtVolume(iProfileIndex);
	g_iSlenderProxyHurtPitch[Npc.Index] = GetBossProfileSoundProxyHurtPitch(iProfileIndex);
	g_iSlenderProxyDeathChannel[Npc.Index] = GetBossProfileSoundProxyDeathChannel(iProfileIndex);
	g_iSlenderProxyDeathLevel[Npc.Index] = GetBossProfileSoundProxyDeathLevel(iProfileIndex);
	g_iSlenderProxyDeathFlags[Npc.Index] = GetBossProfileSoundProxyDeathFlags(iProfileIndex);
	g_flSlenderProxyDeathVolume[Npc.Index] = GetBossProfileSoundProxyDeathVolume(iProfileIndex);
	g_iSlenderProxyDeathPitch[Npc.Index] = GetBossProfileSoundProxyDeathPitch(iProfileIndex);
	g_iSlenderProxyIdleChannel[Npc.Index] = GetBossProfileSoundProxyIdleChannel(iProfileIndex);
	g_iSlenderProxyIdleLevel[Npc.Index] = GetBossProfileSoundProxyIdleLevel(iProfileIndex);
	g_iSlenderProxyIdleFlags[Npc.Index] = GetBossProfileSoundProxyIdleFlags(iProfileIndex);
	g_flSlenderProxyIdleVolume[Npc.Index] = GetBossProfileSoundProxyIdleVolume(iProfileIndex);
	g_iSlenderProxyIdlePitch[Npc.Index] = GetBossProfileSoundProxyIdlePitch(iProfileIndex);
	g_flSlenderProxyIdleCooldownMin[Npc.Index] = GetBossProfileSoundProxyIdleCooldownMin(iProfileIndex);
	g_flSlenderProxyIdleCooldownMax[Npc.Index] = GetBossProfileSoundProxyIdleCooldownMax(iProfileIndex);
	g_iSlenderProxySpawnChannel[Npc.Index] = GetBossProfileSoundProxySpawnChannel(iProfileIndex);
	g_iSlenderProxySpawnLevel[Npc.Index] = GetBossProfileSoundProxySpawnLevel(iProfileIndex);
	g_iSlenderProxySpawnFlags[Npc.Index] = GetBossProfileSoundProxySpawnFlags(iProfileIndex);
	g_flSlenderProxySpawnVolume[Npc.Index] = GetBossProfileSoundProxySpawnVolume(iProfileIndex);
	g_iSlenderProxySpawnPitch[Npc.Index] = GetBossProfileSoundProxySpawnPitch(iProfileIndex);
	
	// Deathcam values.
	Npc.DeathCamEnabled = GetBossProfileDeathCamState(iProfileIndex);
	g_bSlenderDeathCamScareSound[Npc.Index] = GetBossProfileDeathCamScareSound(iProfileIndex);
	g_bSlenderPublicDeathCam[Npc.Index] = GetBossProfilePublicDeathCamState(iProfileIndex);
	g_flSlenderPublicDeathCamSpeed[Npc.Index] = GetBossProfilePublicDeathCamSpeed(iProfileIndex);
	g_flSlenderPublicDeathCamAcceleration[Npc.Index] = GetBossProfilePublicDeathCamAcceleration(iProfileIndex);
	g_flSlenderPublicDeathCamDeceleration[Npc.Index] = GetBossProfilePublicDeathCamDeceleration(iProfileIndex);
	g_flSlenderPublicDeathCamBackwardOffset[Npc.Index] = GetBossProfilePublicDeathCamBackwardOffset(iProfileIndex);
	g_flSlenderPublicDeathCamDownwardOffset[Npc.Index] = GetBossProfilePublicDeathCamDownwardOffset(iProfileIndex);
	g_bSlenderDeathCamOverlay[Npc.Index] = GetBossProfileDeathCamOverlayState(iProfileIndex);
	g_flSlenderDeathCamOverlayTimeStart[Npc.Index] = GetBossProfileDeathCamOverlayStartTime(iProfileIndex);
	g_flSlenderDeathCamTime[Npc.Index] = GetBossProfileDeathCamTime(iProfileIndex);

	g_hSlenderFakeTimer[Npc.Index] = null;
	g_hSlenderEntityThink[Npc.Index] = null;
	g_hSlenderAttackTimer[Npc.Index] = null;
	g_hSlenderLaserTimer[Npc.Index] = null;
	g_hSlenderBackupAtkTimer[Npc.Index] = null;
	g_hSlenderChaseInitialTimer[Npc.Index] = null;
	g_hSlenderRage1Timer[Npc.Index] = null;
	g_hSlenderRage2Timer[Npc.Index] = null;
	g_hSlenderRage3Timer[Npc.Index] = null;
	g_hSlenderHealTimer[Npc.Index] = null;
	g_hSlenderHealDelayTimer[Npc.Index] = null;
	g_hSlenderHealEventTimer[Npc.Index] = null;
	g_hSlenderStartFleeTimer[Npc.Index] = null;
	g_hSlenderSpawnTimer[Npc.Index] = null;
	g_hSlenderDeathCamTimer[Npc.Index] = null;
	g_iSlenderDeathCamTarget[Npc.Index] = INVALID_ENT_REFERENCE;
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
	for (int iColor = 0; iColor < 4; iColor++)
	{
		if (iColor == 3) g_iBossPathingColor[Npc.Index][iColor] = 255;
		else g_iBossPathingColor[Npc.Index][iColor] = GetRandomInt(0, 255);
	}
	g_bNPCVelocityCancel[Npc.Index] = false;
	g_hSlenderBurnTimer[Npc.Index] = null;
	g_hSlenderBleedTimer[Npc.Index] = null;
	g_hSlenderMarkedTimer[Npc.Index] = null;
	g_flSlenderStopBurning[Npc.Index] = 0.0;
	g_flSlenderStopBleeding[Npc.Index] = 0.0;
	g_bSlenderIsBurning[Npc.Index] = false;
	g_bSlenderIsMarked[Npc.Index] = false;
	g_iSlenderSoundTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_iSlenderSeeTarget[Npc.Index] = INVALID_ENT_REFERENCE;

	g_bSlenderHasBurnKillEffect[Npc.Index] = GetBossProfileBurnRagdoll(iProfileIndex);
	g_bSlenderHasCloakKillEffect[Npc.Index] = GetBossProfileCloakRagdoll(iProfileIndex);
	g_bSlenderHasDecapKillEffect[Npc.Index] = GetBossProfileDecapRagdoll(iProfileIndex);
	g_bSlenderHasGibKillEffect[Npc.Index] = GetBossProfileGibRagdoll(iProfileIndex);
	g_bSlenderHasGoldKillEffect[Npc.Index] = GetBossProfileGoldRagdoll(iProfileIndex);
	g_bSlenderHasIceKillEffect[Npc.Index] = GetBossProfileIceRagdoll(iProfileIndex);
	g_bSlenderHasElectrocuteKillEffect[Npc.Index] = GetBossProfileElectrocuteRagdoll(iProfileIndex);
	g_bSlenderHasAshKillEffect[Npc.Index] = GetBossProfileAshRagdoll(iProfileIndex);
	g_bSlenderHasDeleteKillEffect[Npc.Index] = GetBossProfileDeleteRagdoll(iProfileIndex);
	g_bSlenderHasPushRagdollOnKill[Npc.Index] = GetBossProfilePushRagdoll(iProfileIndex);
	g_bSlenderCustomOutroSong[Npc.Index] = GetBossProfileOutroMusicState(iProfileIndex);

	g_bSlenderHasDissolveRagdollOnKill[Npc.Index] = GetBossProfileDissolveRagdoll(iProfileIndex);
	g_iSlenderDissolveRagdollType[Npc.Index] = GetBossProfileDissolveRagdollType(iProfileIndex);

	g_bSlenderHasPlasmaRagdollOnKill[Npc.Index] = GetBossProfilePlasmaRagdoll(iProfileIndex);

	g_bSlenderHasResizeRagdollOnKill[Npc.Index] = GetBossProfileResizeRagdoll(iProfileIndex);
	g_flSlenderResizeRagdollHands[Npc.Index] = GetBossProfileResizeRagdollHead(iProfileIndex);
	g_flSlenderResizeRagdollHead[Npc.Index] = GetBossProfileResizeRagdollHands(iProfileIndex);
	g_flSlenderResizeRagdollTorso[Npc.Index] = GetBossProfileResizeRagdollTorso(iProfileIndex);

	g_bSlenderHasDecapOrGibKillEffect[Npc.Index] = GetBossProfileDecapOrGibRagdoll(iProfileIndex);
	g_bSlenderHasSilentKill[Npc.Index] = GetBossProfileSilentKill(iProfileIndex);
	g_bSlenderHasMultiKillEffect[Npc.Index] = GetBossProfileMultieffectRagdoll(iProfileIndex);

	g_bSlenderPlayerCustomDeathFlag[Npc.Index] = GetBossProfileCustomDeathFlag(iProfileIndex);
	g_iSlenderPlayerSetDeathFlag[Npc.Index] = GetBossProfileCustomDeathFlagType(iProfileIndex);

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

	GetProfileString(sProfile, "cloak_on_sound", g_sSlenderCloakOnSound[Npc.Index], sizeof(g_sSlenderCloakOnSound[]), DEFAULT_CLOAKONSOUND);
	GetProfileString(sProfile, "cloak_off_sound", g_sSlenderCloakOffSound[Npc.Index], sizeof(g_sSlenderCloakOffSound[]), DEFAULT_CLOAKOFFSOUND);
	GetProfileString(sProfile, "rocket_shoot_sound", g_sSlenderRocketShootSound[Npc.Index], sizeof(g_sSlenderRocketShootSound[]), ROCKET_SHOOT);
	GetProfileString(sProfile, "rocket_model", g_sSlenderRocketModel[Npc.Index], sizeof(g_sSlenderRocketModel[]), ROCKET_MODEL);
	GetProfileString(sProfile, "sentryrocket_shoot_sound", g_sSlenderSentryRocketShootSound[Npc.Index], sizeof(g_sSlenderSentryRocketShootSound[]), SENTRYROCKET_SHOOT);
	GetProfileString(sProfile, "fire_shoot_sound", g_sSlenderFireballShootSound[Npc.Index], sizeof(g_sSlenderFireballShootSound[]), FIREBALL_SHOOT);
	GetProfileString(sProfile, "rocket_explode_sound", g_sSlenderRocketExplodeSound[Npc.Index], sizeof(g_sSlenderRocketExplodeSound[]), FIREBALL_IMPACT);
	GetProfileString(sProfile, "fire_trail", g_sSlenderFireballTrail[Npc.Index], sizeof(g_sSlenderFireballTrail[]), FIREBALL_TRAIL);
	GetProfileString(sProfile, "rocket_trail_particle", g_sSlenderRocketTrailParticle[Npc.Index], sizeof(g_sSlenderRocketTrailParticle[]), ROCKET_TRAIL);
	GetProfileString(sProfile, "rocket_explode_particle", g_sSlenderRocketExplodeParticle[Npc.Index], sizeof(g_sSlenderRocketExplodeParticle[]), ROCKET_EXPLODE_PARTICLE);
	GetProfileString(sProfile, "fire_explode_sound", g_sSlenderFireballExplodeSound[Npc.Index], sizeof(g_sSlenderFireballExplodeSound[]), FIREBALL_IMPACT);
	GetProfileString(sProfile, "fire_iceball_slow_sound", g_sSlenderIceballImpactSound[Npc.Index], sizeof(g_sSlenderIceballImpactSound[]), ICEBALL_IMPACT);
	GetProfileString(sProfile, "fire_iceball_trail", g_sSlenderIceballTrail[Npc.Index], sizeof(g_sSlenderIceballTrail[]), ICEBALL_TRAIL);
	GetProfileString(sProfile, "grenade_shoot_sound", g_sSlenderGrenadeShootSound[Npc.Index], sizeof(g_sSlenderGrenadeShootSound[]), GRENADE_SHOOT);
	GetProfileString(sProfile, "arrow_shoot_sound", g_sSlenderArrowShootSound[Npc.Index], sizeof(g_sSlenderArrowShootSound[]), ARROW_SHOOT);
	GetProfileString(sProfile, "mangler_shoot_sound", g_sSlenderManglerShootSound[Npc.Index], sizeof(g_sSlenderManglerShootSound[]), MANGLER_SHOOT);
	GetProfileString(sProfile, "baseball_shoot_sound", g_sSlenderBaseballShootSound[Npc.Index], sizeof(g_sSlenderBaseballShootSound[]), BASEBALL_SHOOT);
	GetProfileString(sProfile, "player_jarate_sound", g_sSlenderJarateHitSound[Npc.Index], sizeof(g_sSlenderJarateHitSound[]), JARATE_HITPLAYER);
	GetProfileString(sProfile, "player_milk_sound", g_sSlenderMilkHitSound[Npc.Index], sizeof(g_sSlenderMilkHitSound[]), JARATE_HITPLAYER);
	GetProfileString(sProfile, "player_gas_sound", g_sSlenderGasHitSound[Npc.Index], sizeof(g_sSlenderGasHitSound[]), JARATE_HITPLAYER);
	GetProfileString(sProfile, "player_stun_sound", g_sSlenderStunHitSound[Npc.Index], sizeof(g_sSlenderStunHitSound[]), STUN_HITPLAYER);
	GetProfileString(sProfile, "engine_sound", g_sSlenderEngineSound[Npc.Index], sizeof(g_sSlenderEngineSound[]));
	GetProfileString(sProfile, "shockwave_beam_sprite", g_sSlenderShockwaveBeamSprite[Npc.Index], sizeof(g_sSlenderShockwaveBeamSprite[]), "sprites/laser.vmt");
	GetProfileString(sProfile, "shockwave_halo_sprite", g_sSlenderShockwaveHaloSprite[Npc.Index], sizeof(g_sSlenderShockwaveHaloSprite[]), "sprites/halo01.vmt");
	GetProfileString(sProfile, "player_smite_sound", g_sSlenderSmiteSound[Npc.Index], sizeof(g_sSlenderSmiteSound[]), SOUND_THUNDER);
	GetProfileString(sProfile, "trap_model", g_sSlenderTrapModel[Npc.Index], sizeof(g_sSlenderTrapModel[]), TRAP_MODEL);
	GetProfileString(sProfile, "trap_deploy_sound", g_sSlenderTrapDeploySound[Npc.Index], sizeof(g_sSlenderTrapDeploySound[]), TRAP_DEPLOY);
	GetProfileString(sProfile, "trap_miss_sound", g_sSlenderTrapMissSound[Npc.Index], sizeof(g_sSlenderTrapMissSound[]), TRAP_CLOSE);
	GetProfileString(sProfile, "trap_catch_sound", g_sSlenderTrapHitSound[Npc.Index], sizeof(g_sSlenderTrapHitSound[]), TRAP_CLOSE);
	GetProfileString(sProfile, "trap_animation_idle", g_sSlenderTrapAnimIdle[Npc.Index], sizeof(g_sSlenderTrapAnimIdle[]), "trapopened");
	GetProfileString(sProfile, "trap_animation_closed", g_sSlenderTrapAnimClose[Npc.Index], sizeof(g_sSlenderTrapAnimClose[]), "trapclosed");
	GetProfileString(sProfile, "trap_animation_open", g_sSlenderTrapAnimOpen[Npc.Index], sizeof(g_sSlenderTrapAnimOpen[]));

	g_hSlenderThink[Npc.Index] = CreateTimer(0.3, Timer_SlenderTeleportThink, Npc, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	
	SlenderRemoveTargetMemory(Npc.Index);
	
	switch (iBossType)
	{
		case SF2BossType_Chaser:
		{
			NPCChaserOnSelectProfile(Npc.Index, bInvincible);
			
			SlenderCreateTargetMemory(Npc.Index);
		}
		case SF2BossType_Statue:
		{
			NPCStatueOnSelectProfile(Npc.Index);
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
			if (sBuffer[0] != '\0') EmitSoundToAll(sBuffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
		}
		if(hTimerMusic==null)
		{
			bool bAllowMusic = false;
			float flTime;
			for (int iDifficulty = 0; iDifficulty < Difficulty_Max; iDifficulty++)
			{
				if (g_flNPCSoundMusicLoop[Npc.Index][iDifficulty] > 0.0)
				{
					bAllowMusic = true;
					g_iNPCAllowMusicOnDifficulty[Npc.Index] |= iDifficulty;
				}
			}
			if(bAllowMusic && !SF_SpecialRound(SPECIALROUND_TRIPLEBOSSES))
			{
				flTime = g_flNPCSoundMusicLoop[Npc.Index][g_cvDifficulty.IntValue];

				GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNormal,sizeof(sCurrentMusicTrackNormal));
				
				GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
				if (sCurrentMusicTrackHard[0] == '\0') GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackHard,sizeof(sCurrentMusicTrackHard));
				
				GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
				if (sCurrentMusicTrackInsane[0] == '\0')
				{
					GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
					if (sCurrentMusicTrackInsane[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackInsane,sizeof(sCurrentMusicTrackInsane));
					}
				}
				
				GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
				if (sCurrentMusicTrackNightmare[0] == '\0')
				{
					GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
					if (sCurrentMusicTrackNightmare[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
						if (sCurrentMusicTrackNightmare[0] == '\0')
						{
							GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackNightmare,sizeof(sCurrentMusicTrackNightmare));
						}
					}
				}
				
				GetRandomStringFromProfile(sProfile,"sound_music_apollyon",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
				if (sCurrentMusicTrackApollyon[0] == '\0')
				{
					GetRandomStringFromProfile(sProfile,"sound_music_nightmare",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
					if (sCurrentMusicTrackApollyon[0] == '\0')
					{
						GetRandomStringFromProfile(sProfile,"sound_music_insane",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
						if (sCurrentMusicTrackApollyon[0] == '\0')
						{
							GetRandomStringFromProfile(sProfile,"sound_music_hard",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
							if (sCurrentMusicTrackApollyon[0] == '\0')
							{
								GetRandomStringFromProfile(sProfile,"sound_music",sCurrentMusicTrackApollyon,sizeof(sCurrentMusicTrackApollyon));
							}
						}
					}
				}
				if ((g_iNPCAllowMusicOnDifficulty[Npc.Index] & g_cvDifficulty.IntValue) && flTime > 0.0)
				{
					hTimerMusic = CreateTimer(flTime,BossMusic,Npc.Index,TIMER_FLAG_NO_MAPCHANGE);
					for(int client = 1;client <=MaxClients;client ++)
					{
						if(IsValidClient(client) && (!g_bPlayerEliminated[client] || IsClientInGhostMode(client)))
						{
							ClientChaseMusicReset(client);
							ClientChaseMusicSeeReset(client);
							ClientAlertMusicReset(client);
							ClientIdleMusicReset(client);
							ClientStopAllSlenderSounds(client, sProfile, "sound_chase_music", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(client, sProfile, "sound_alert_music", SNDCHAN_AUTO);
							ClientStopAllSlenderSounds(client, sProfile, "sound_chase_visible", SNDCHAN_AUTO);
							if (g_strPlayerMusic[client][0] != '\0') EmitSoundToClient(client, g_strPlayerMusic[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.0001);
							switch (g_cvDifficulty.IntValue)
							{
								case Difficulty_Normal, Difficulty_Easy: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNormal);
								case Difficulty_Hard: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackHard);
								case Difficulty_Insane: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackInsane);
								case Difficulty_Nightmare: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackNightmare);
								case Difficulty_Apollyon: strcopy(sCurrentMusicTrack,sizeof(sCurrentMusicTrack),sCurrentMusicTrackApollyon);
							}
							if (sCurrentMusicTrack[0] != '\0') StopSound(client, MUSIC_CHAN, sCurrentMusicTrack);
							ClientMusicStart(client, sCurrentMusicTrack, _, MUSIC_PAGE_VOLUME,true);
							ClientUpdateMusicSystem(client);
						}
					}
				}
			}
		}
		if (bSpawnCompanions)
		{
			g_hConfig.Rewind();
			g_hConfig.JumpToKey(sProfile);
			
			char sCompProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList hCompanions = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);

			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hCompanions.", hCompanions);
			#endif
			
			if (g_hConfig.JumpToKey("companions"))
			{
				char sNum[32];
				
				for (int i = 1;;i++)
				{
					FormatEx(sNum, sizeof(sNum), "%d", i);
					g_hConfig.GetString(sNum, sCompProfile, sizeof(sCompProfile));
					if (sCompProfile[0] == '\0') break;
					
					hCompanions.PushString(sCompProfile);
				}
			}
			
			for (int i = 0, iSize = hCompanions.Length; i < iSize; i++)
			{
				hCompanions.GetString(i, sCompProfile, sizeof(sCompProfile));
				if (IsProfileValid(sCompProfile))
				{
					SF2NPC_BaseNPC NpcCompanion = AddProfile(sCompProfile, _, _, false, false);
					if (NpcCompanion.IsValid()) g_iSlenderCompanionMaster[NpcCompanion.Index] = Npc.Index;
				}
				else
				{
					LogSF2Message("Companion boss profile %s is invalid, skipping boss...", sCompProfile);
				}
			}
			
			delete hCompanions;

			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for hCompanions..", hCompanions);
			#endif
		}
	}
	
	Call_StartForward(fOnBossAdded);
	Call_PushCell(Npc.Index);
	Call_Finish();

	if (g_iSlenderCopyMaster[Npc.Index] == -1) LogSF2Message("Boss profile %s has been added to the game.", sProfile);
	
	return true;
}
//SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC) <= Bug?
SF2NPC_BaseNPC AddProfile(const char[] strName,int iAdditionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool bSpawnCompanions=true, bool bPlaySpawnSound=true, bool bInvincible = false)
{
	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape) return SF2_INVALID_NPC; // Stop spawning bosses before all pages are picked up in Renevant.
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = view_as<SF2NPC_BaseNPC>(i);
		if (!Npc.IsValid())
		{
			if (SelectProfile(Npc, strName, iAdditionalBossFlags, NpcCopyMaster, bSpawnCompanions, bPlaySpawnSound, bInvincible))
			{
				return Npc;
			}
			
			break;
		}
	}
	
	return SF2_INVALID_NPC;
}

stock bool GetSlenderModel(int iBossIndex, int iModelState = 0, char[] sBuffer, int bufferlen)
{
	if (NPCGetUniqueID(iBossIndex) == -1) return false;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	sBuffer[0] = '\0';

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	switch (iModelState)
	{
		case 0:
		{
			switch (iDifficulty)
			{
				case Difficulty_Normal: GetProfileString(sProfile, "model", sBuffer, bufferlen);
				case Difficulty_Hard:
				{
					GetProfileString(sProfile, "model_hard", sBuffer, bufferlen);
					if (sBuffer[0] == '\0') GetProfileString(sProfile, "model", sBuffer, bufferlen);
				}
				case Difficulty_Insane:
				{
					GetProfileString(sProfile, "model_insane", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_hard", sBuffer, bufferlen);
						if (sBuffer[0] == '\0') GetProfileString(sProfile, "model", sBuffer, bufferlen);
					}
				}
				case Difficulty_Nightmare:
				{
					GetProfileString(sProfile, "model_nightmare", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_insane", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_hard", sBuffer, bufferlen);
							if (sBuffer[0] == '\0') GetProfileString(sProfile, "model", sBuffer, bufferlen);
						}
					}
				}
				case Difficulty_Apollyon:
				{
					GetProfileString(sProfile, "model_apollyon", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_nightmare", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_insane", sBuffer, bufferlen);
							if (sBuffer[0] == '\0')
							{
								GetProfileString(sProfile, "model_hard", sBuffer, bufferlen);
								if (sBuffer[0] == '\0') GetProfileString(sProfile, "model", sBuffer, bufferlen);
							}
						}
					}
				}
			}
		}
		case 1:
		{
			switch (iDifficulty)
			{
				case Difficulty_Normal: GetProfileString(sProfile, "model_averagedist", sBuffer, bufferlen);
				case Difficulty_Hard:
				{
					GetProfileString(sProfile, "model_averagedist_hard", sBuffer, bufferlen);
					if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_averagedist", sBuffer, bufferlen);
				}
				case Difficulty_Insane:
				{
					GetProfileString(sProfile, "model_averagedist_insane", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_averagedist_hard", sBuffer, bufferlen);
						if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_averagedist", sBuffer, bufferlen);
					}
				}
				case Difficulty_Nightmare:
				{
					GetProfileString(sProfile, "model_averagedist_nightmare", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_averagedist_insane", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_averagedist_hard", sBuffer, bufferlen);
							if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_averagedist", sBuffer, bufferlen);
						}
					}
				}
				case Difficulty_Apollyon:
				{
					GetProfileString(sProfile, "model_averagedist_apollyon", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_averagedist_nightmare", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_averagedist_insane", sBuffer, bufferlen);
							if (sBuffer[0] == '\0')
							{
								GetProfileString(sProfile, "model_averagedist_hard", sBuffer, bufferlen);
								if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_averagedist", sBuffer, bufferlen);
							}
						}
					}
				}
			}
		}
		case 2:
		{
			switch (iDifficulty)
			{
				case Difficulty_Normal: GetProfileString(sProfile, "model_closedist", sBuffer, bufferlen);
				case Difficulty_Hard:
				{
					GetProfileString(sProfile, "model_closedist_hard", sBuffer, bufferlen);
					if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_closedist", sBuffer, bufferlen);
				}
				case Difficulty_Insane:
				{
					GetProfileString(sProfile, "model_closedist_insane", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_closedist_hard", sBuffer, bufferlen);
						if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_closedist", sBuffer, bufferlen);
					}
				}
				case Difficulty_Nightmare:
				{
					GetProfileString(sProfile, "model_closedist_nightmare", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_closedist_insane", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_closedist_hard", sBuffer, bufferlen);
							if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_closedist", sBuffer, bufferlen);
						}
					}
				}
				case Difficulty_Apollyon:
				{
					GetProfileString(sProfile, "model_closedist_apollyon", sBuffer, bufferlen);
					if (sBuffer[0] == '\0')
					{
						GetProfileString(sProfile, "model_closedist_nightmare", sBuffer, bufferlen);
						if (sBuffer[0] == '\0')
						{
							GetProfileString(sProfile, "model_closedist_insane", sBuffer, bufferlen);
							if (sBuffer[0] == '\0')
							{
								GetProfileString(sProfile, "model_closedist_hard", sBuffer, bufferlen);
								if (sBuffer[0] == '\0') GetProfileString(sProfile, "model_closedist", sBuffer, bufferlen);
							}
						}
					}
				}
			}
		}
	}
	return true;
}

void ChangeAllSlenderModels()
{
	char sBuffer[PLATFORM_MAX_PATH];
	for (int iNPCIndex = 0; iNPCIndex < MAX_BOSSES; iNPCIndex++)
	{	
		if (NPCGetUniqueID(iNPCIndex) == -1) continue;
		int iDifficulty = GetLocalGlobalDifficulty(iNPCIndex);
		int slender = NPCGetEntIndex(iNPCIndex);
		if (!IsValidEntity(slender)) continue;
		char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(iNPCIndex, sProfile, sizeof(sProfile));
		GetSlenderModel(iNPCIndex, _, sBuffer, sizeof(sBuffer));
		SetEntityModel(slender, sBuffer);
		SetEntityModel(EntRefToEntIndex(g_iNPCTauntGlowEntity[iNPCIndex]), sBuffer);
		if (NPCGetModelSkinMax(iNPCIndex) > 0)
		{
			int iRandomSkin = GetRandomInt(0, NPCGetModelSkinMax(iNPCIndex));
			SetEntProp(slender, Prop_Send, "m_nSkin", iRandomSkin);
		}
		else
		{
			if (view_as<bool>(GetProfileNum(sProfile,"skin_difficulty",0))) SetEntProp(slender, Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(iNPCIndex, iDifficulty));
			else SetEntProp(slender, Prop_Send, "m_nSkin", NPCGetModelSkin(iNPCIndex));
		}
		if (NPCGetModelBodyGroupsMax(iNPCIndex) > 0)
		{
			int iRandomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(iNPCIndex));
			SetEntProp(slender, Prop_Send, "m_nBody", iRandomBody);
		}
		else
		{
			if (view_as<bool>(GetProfileNum(sProfile,"body_difficulty",0))) SetEntProp(slender, Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(iNPCIndex, iDifficulty));
			else SetEntProp(slender, Prop_Send, "m_nBody", NPCGetModelBodyGroups(iNPCIndex));
		}
		if (NPCGetType(iNPCIndex) == SF2BossType_Chaser) 
		{
			float flTempHitboxMins[3];
			NPCChaserUpdateBossAnimation(iNPCIndex, slender, g_iSlenderState[iNPCIndex]);
			if (NPCGetRaidHitbox(iNPCIndex) == 1)
			{
				CopyVector(g_flSlenderDetectMins[iNPCIndex], flTempHitboxMins);
				flTempHitboxMins[2] = 10.0;
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMins", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMaxs", g_flSlenderDetectMaxs[iNPCIndex]);
				
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMinsPreScaled", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMaxsPreScaled", g_flSlenderDetectMaxs[iNPCIndex]);
			}
			else if (NPCGetRaidHitbox(iNPCIndex) == 0)
			{
				CopyVector(HULL_HUMAN_MINS, flTempHitboxMins);
				flTempHitboxMins[2] = 10.0;
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMins", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);
				
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMinsPreScaled", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iNPCIndex], Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
			}
		}
	}
}

public Address SF2_GetLocomotionInterface(int index) 
{ 
	return SDKCall(g_hSDKGetLocomotionInterface, SDKCall(g_hSDKGetNextBot, index)); 
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
				ClientIdleMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}
			
			// Don't forget search theme
			if(g_iPlayerAlertMusicMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientIdleMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}
			
			if(g_iPlayerChaseMusicSeeMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientIdleMusicReset(i);
				ClientChaseMusicSeeReset(i);
			}

			if(g_iPlayerIdleMusicMaster[i] == iBossIndex)
			{
				ClientChaseMusicReset(i);
				ClientAlertMusicReset(i);
				ClientIdleMusicReset(i);
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
					TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
					
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
	g_bNPCHealthbarEnabled[iBossIndex] = false;

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
		g_flNPCTauntAlertRange[iBossIndex][iDifficulty] = 0.0;
		g_flNPCInstantKillCooldown[iBossIndex][iDifficulty] = 0.0;
		g_flSlenderProxyTeleportMinRange[iBossIndex][iDifficulty] = 0.0;
		g_flSlenderProxyTeleportMaxRange[iBossIndex][iDifficulty] = 0.0;
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
	g_flNPCAddAcceleration[iBossIndex] = 0.0;
	g_flNPCStepSize[iBossIndex] = 0.0;

	g_bNPCDiscoMode[iBossIndex] = false;
	g_flNPCDiscoRadiusMin[iBossIndex] = 0.0;
	g_flNPCDiscoRadiusMax[iBossIndex] = 0.0;

	g_bNPCFestiveLights[iBossIndex] = false;
	g_iNPCFestiveLightBrightness[iBossIndex] = 0;
	g_flNPCFestiveLightDistance[iBossIndex] = 0.0;
	g_flNPCFestiveLightRadius[iBossIndex] = 0.0;
	
	g_iNPCEnemy[iBossIndex] = INVALID_ENT_REFERENCE;
	
	NPCSetDeathCamEnabled(iBossIndex, false);
	
	g_iSlenderCopyMaster[iBossIndex] = -1;
	g_iSlenderCompanionMaster[iBossIndex] = -1;
	g_iNPCUniqueID[iBossIndex] = -1;
	g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
	g_hSlenderAttackTimer[iBossIndex] = null;
	g_hSlenderLaserTimer[iBossIndex] = null;
	g_hSlenderBackupAtkTimer[iBossIndex] = null;
	g_hSlenderChaseInitialTimer[iBossIndex] = null;
	g_hSlenderRage1Timer[iBossIndex] = null;
	g_hSlenderRage2Timer[iBossIndex] = null;
	g_hSlenderRage3Timer[iBossIndex] = null;
	g_hSlenderHealTimer[iBossIndex] = null;
	g_hSlenderHealDelayTimer[iBossIndex] = null;
	g_hSlenderHealEventTimer[iBossIndex] = null;
	g_hSlenderStartFleeTimer[iBossIndex] = null;
	g_hSlenderSpawnTimer[iBossIndex] = null;
	g_hSlenderDeathCamTimer[iBossIndex] = null;
	g_iSlenderDeathCamTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_hSlenderThink[iBossIndex] = null;
	g_hSlenderEntityThink[iBossIndex] = null;
	g_hSlenderBurnTimer[iBossIndex] = null;
	g_hSlenderBleedTimer[iBossIndex] = null;
	g_hSlenderMarkedTimer[iBossIndex] = null;
	g_flSlenderStopBurning[iBossIndex] = 0.0;
	g_flSlenderStopBleeding[iBossIndex] = 0.0;
	g_bSlenderIsBurning[iBossIndex] = false;
	g_bSlenderIsMarked[iBossIndex] = false;
	g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_iSlenderSeeTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_bSlenderCustomOutroSong[iBossIndex] = false;

	g_hSlenderFakeTimer[iBossIndex] = null;
	g_flSlenderLastKill[iBossIndex] = -1.0;
	g_iSlenderState[iBossIndex] = STATE_IDLE;
	g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
	g_bSlenderTargetIsVisible[iBossIndex] = false;
	g_iSlenderModel[iBossIndex] = INVALID_ENT_REFERENCE;
	g_flNPCAnger[iBossIndex] = 0.0;
	g_flNPCAngerAddOnPageGrab[iBossIndex] = 0.0;
	g_flNPCAngerAddOnPageGrabTimeDiff[iBossIndex] = 0.0;
	g_bSlenderBoxingBossIsKilled[iBossIndex] = false;
	g_flSlenderTimeUntilNextProxy[iBossIndex] = -1.0;
	g_flNPCInstantKillRadius[iBossIndex] = 0.0;
	g_flNPCScareRadius[iBossIndex] = 0.0;
	g_bNPCPlayerScareSpeedBoost[iBossIndex] = false;
	g_flNPCPlayerSpeedBoostDuration[iBossIndex] = 0.0;
	g_bNPCPlayerScareReaction[iBossIndex] = false;
	g_iNPCPlayerScareReactionType[iBossIndex] = 0;
	g_bNPCPlayerScareReplenishSprint[iBossIndex] = false;
	g_iNPCPlayerScareReplenishSprintAmount[iBossIndex] = 0;
	g_iNPCPlayerScareVictin[iBossIndex] = INVALID_ENT_REFERENCE;
	g_bNPCChasingScareVictin[iBossIndex] = false;
	g_bNPCLostChasingScareVictim[iBossIndex] = false;
	g_bNPCVelocityCancel[iBossIndex] = false;
	g_iSlenderRenderFX[iBossIndex] = 0;
	g_iSlenderRenderMode[iBossIndex] = 0;

	for (int i = 0; i < 3; i++)
	{
		g_flSlenderDetectMins[iBossIndex][i] = 0.0;
		g_flSlenderDetectMaxs[iBossIndex][i] = 0.0;
		g_flSlenderEyePosOffset[iBossIndex][i] = 0.0;
		g_flNPCDiscoModePos[iBossIndex][i] = 0.0;
		g_flNPCFestiveLightPos[iBossIndex][i] = 0.0;
		g_flNPCFestiveLightAng[iBossIndex][i] = 0.0;
	}

	for (int i = 0; i < 4; i++)
	{
		g_iSlenderRenderColor[iBossIndex][i] = 0;
	}
	
	SlenderRemoveTargetMemory(iBossIndex);
}

void SpawnSlender(SF2NPC_BaseNPC Npc, const float pos[3])
{
	if (!IsRoundPlaying()) return;

	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape) return; // Stop spawning bosses before all pages are picked up in Renevant.

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.UnSpawn();
	Npc.GetProfile(sProfile,sizeof(sProfile));
	
	float flTruePos[3], flVecAng[3];
	flVecAng[1] = GetRandomFloat(0.0, 360.0);
	AddVectors(flTruePos, pos, flTruePos);
	
	int iBossIndex = Npc.Index;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	char sBuffer[PLATFORM_MAX_PATH];
	switch (NPCGetType(iBossIndex))
	{
		case SF2BossType_Statue:
		{
			GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));

			CBaseNPC npcBoss = new CBaseNPC();
			CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npcBoss.GetEntity());
			CBaseNPC_Locomotion locomotion = npcBoss.GetLocomotion();

			npcEntity.Teleport(flTruePos, flVecAng);
			npcEntity.SetModel(sBuffer);
			npcEntity.SetRenderMode(view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
			npcEntity.SetRenderFx(view_as<RenderFx>(g_iSlenderRenderFX[iBossIndex]));
			npcEntity.SetRenderColor(g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
			if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
			{
				float flScaleModel = NPCGetModelScale(iBossIndex) * 0.5;
				npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", flScaleModel);
			}
			else
			{
				npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", NPCGetModelScale(iBossIndex));
			}
			npcEntity.Spawn();
			npcEntity.Activate();

			npcBoss.flStepSize = 18.0;
			npcBoss.flGravity = g_flGravity;
			npcBoss.flAcceleration = g_flSlenderCalculatedAcceleration[iBossIndex];
			npcBoss.flDeathDropHeight = 99999.0;
			npcBoss.flJumpHeight = 512.0;
			npcBoss.flWalkSpeed = g_flSlenderCalculatedWalkSpeed[iBossIndex];
			npcBoss.flRunSpeed = g_flSlenderCalculatedSpeed[iBossIndex];
			npcBoss.flMaxYawRate = 0.0;
			g_pPath[iBossIndex].SetMinLookAheadDistance(GetProfileFloat(sProfile, "search_node_dist_lookahead", 512.0));
			locomotion.SetCallback(LocomotionCallback_ShouldCollideWith, LocoCollideWith);
			locomotion.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
			locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);

			float flSlenderBoxMins[3], flSlenderBoxMaxs[3];
			flSlenderBoxMins[0] = -11.0;
			flSlenderBoxMins[1] = -11.0;
			flSlenderBoxMaxs[0] = 11.0;
			flSlenderBoxMaxs[1] = 11.0;
			flSlenderBoxMaxs[2] = 55.0;

			npcEntity.SetPropVector(Prop_Send, "m_vecMins", flSlenderBoxMins);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", flSlenderBoxMaxs);

			npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", flSlenderBoxMins);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", flSlenderBoxMaxs);

			if (NPCGetModelSkinMax(iBossIndex) > 0)
			{
				int iRandomSkin = GetRandomInt(0, NPCGetModelSkinMax(iBossIndex));
				npcEntity.SetProp(Prop_Send, "m_nSkin", iRandomSkin);
			}
			else
			{
				if (view_as<bool>(GetProfileNum(sProfile,"skin_difficulty",0))) npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(iBossIndex, iDifficulty));
				else npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkin(iBossIndex));
			}
			if (NPCGetModelBodyGroupsMax(iBossIndex) > 0)
			{
				int iRandomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(iBossIndex));
				npcEntity.SetProp(Prop_Send, "m_nBody", iRandomBody);
			}
			else
			{
				if (view_as<bool>(GetProfileNum(sProfile,"body_difficulty",0))) npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(iBossIndex, iDifficulty));
				else npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroups(iBossIndex));
			}

			g_hSDKUpdateTransmitState.HookEntity(Hook_Pre, npcEntity.iEnt, Hook_BossUpdateTransmitState);
			SetEntityFlags(npcEntity.iEnt, FL_NPC);
			SetEntityTransmitState(npcEntity.iEnt, FL_EDICT_ALWAYS);

			npcEntity.SetProp(Prop_Send, "m_usSolidFlags", FSOLID_TRIGGER|FSOLID_NOT_SOLID);
			npcEntity.SetProp(Prop_Data, "m_nSolidType", SOLID_BBOX);
			npcEntity.SetProp(Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);

			SDKHook(npcEntity.iEnt, SDKHook_ThinkPost, SlenderStatueSetNextThink);
			SDKHook(npcEntity.iEnt, SDKHook_Think, SlenderStatueBossProcessMovement);

			g_iSlender[iBossIndex] = EntIndexToEntRef(npcEntity.iEnt);

			g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderBlinkBossThink, g_iSlender[iBossIndex], TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			Spawn_Statue(iBossIndex);

			if (view_as<bool>(GetProfileNum(sProfile,"tp_effect_spawn",0))) SlenderCreateParticleSpawnEffect(iBossIndex, "tp_effect_spawn_particle", "tp_effect_spawn_sound", "tp_effect_origin");
		}
		case SF2BossType_Chaser:
		{
			GetSlenderModel(iBossIndex, _, sBuffer, sizeof(sBuffer));

			CBaseNPC npcBoss = new CBaseNPC();
			CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npcBoss.GetEntity());
			CBaseNPC_Locomotion locomotion = npcBoss.GetLocomotion();
			npcEntity.DispatchAnimEvents(npcEntity);
			npcEntity.Hook_HandleAnimEvent(CBaseAnimating_HandleAnimEvent);
			CBaseNPC_RemoveAllLayers(npcBoss.GetEntity());

			npcEntity.Teleport(flTruePos, flVecAng);
			npcEntity.SetModel(sBuffer);
			npcEntity.SetRenderMode(view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
			npcEntity.SetRenderFx(view_as<RenderFx>(g_iSlenderRenderFX[iBossIndex]));
			npcEntity.SetRenderColor(g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
			if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
			{
				float flScaleModel = NPCGetModelScale(iBossIndex) * 0.5;
				npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", flScaleModel);
			}
			else
			{
				npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", NPCGetModelScale(iBossIndex));
			}
			npcEntity.Spawn();
			npcEntity.Activate();

			npcBoss.flStepSize = 18.0;
			npcBoss.flGravity = g_flGravity;
			npcBoss.flAcceleration = g_flSlenderCalculatedAcceleration[iBossIndex];
			npcBoss.flDeathDropHeight = 99999.0;
			npcBoss.flJumpHeight = 512.0;
			npcBoss.flWalkSpeed = g_flSlenderCalculatedWalkSpeed[iBossIndex];
			npcBoss.flRunSpeed = g_flSlenderCalculatedSpeed[iBossIndex];
			npcBoss.flMaxYawRate = NPCGetTurnRate(iBossIndex);
			g_pPath[iBossIndex].SetMinLookAheadDistance(GetProfileFloat(sProfile, "search_node_dist_lookahead", 512.0));
			locomotion.SetCallback(LocomotionCallback_ShouldCollideWith, LocoCollideWith);
			locomotion.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
			locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);

			float flSlenderBoxMins[3], flSlenderBoxMaxs[3];
			flSlenderBoxMins[0] = -11.0;
			flSlenderBoxMins[1] = -11.0;
			flSlenderBoxMaxs[0] = 11.0;
			flSlenderBoxMaxs[1] = 11.0;
			flSlenderBoxMaxs[2] = 55.0;
			if (NPCGetRaidHitbox(iBossIndex) == 1)
			{
				npcBoss.SetBodyMins(g_flSlenderDetectMins[iBossIndex]);
				npcBoss.SetBodyMaxs(g_flSlenderDetectMaxs[iBossIndex]);
			}
			else if (NPCGetRaidHitbox(iBossIndex) == 0)
			{
				npcBoss.SetBodyMins(HULL_HUMAN_MINS);
				npcBoss.SetBodyMaxs(HULL_HUMAN_MAXS);	
			}
			
			npcEntity.SetPropVector(Prop_Send, "m_vecMins", flSlenderBoxMins);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", flSlenderBoxMaxs);

			npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", flSlenderBoxMins);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", flSlenderBoxMaxs);

			if (NPCGetModelSkinMax(iBossIndex) > 0)
			{
				int iRandomSkin = GetRandomInt(0, NPCGetModelSkinMax(iBossIndex));
				npcEntity.SetProp(Prop_Send, "m_nSkin", iRandomSkin);
			}
			else
			{
				if (view_as<bool>(GetProfileNum(sProfile,"skin_difficulty",0))) npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(iBossIndex, iDifficulty));
				else npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkin(iBossIndex));
			}
			if (NPCGetModelBodyGroupsMax(iBossIndex) > 0)
			{
				int iRandomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(iBossIndex));
				npcEntity.SetProp(Prop_Send, "m_nBody", iRandomBody);
			}
			else
			{
				if (view_as<bool>(GetProfileNum(sProfile,"body_difficulty",0))) npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(iBossIndex, iDifficulty));
				else npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroups(iBossIndex));
			}

			g_hSDKUpdateTransmitState.HookEntity(Hook_Pre, npcEntity.iEnt, Hook_BossUpdateTransmitState);
			SetEntityFlags(npcEntity.iEnt, FL_NPC);
			SetEntityTransmitState(npcEntity.iEnt, FL_EDICT_ALWAYS);

			//if (!g_cvDisableBossCrushFix.BoolValue) SetEntData(iBoss, FindSendPropInfo("CTFBaseBoss", "m_lastHealthPercentage") + 28, false, 4, true);

			SDKHook(npcEntity.iEnt, SDKHook_OnTakeDamageAlive, Hook_SlenderOnTakeDamageOriginal);

			// Reset stats.
			g_bSlenderInBacon[iBossIndex] = false;
			g_iSlender[iBossIndex] = EntIndexToEntRef(npcEntity.iEnt);
			g_iSlenderTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_bSlenderTargetIsVisible[iBossIndex] = false;
			g_iSlenderState[iBossIndex] = STATE_IDLE;
			g_bSlenderAttacking[iBossIndex] = false;
			g_bSlenderGiveUp[iBossIndex] = false;
			g_hSlenderAttackTimer[iBossIndex] = null;
			g_hSlenderLaserTimer[iBossIndex] = null;
			g_hSlenderBackupAtkTimer[iBossIndex] = null;
			g_hSlenderChaseInitialTimer[iBossIndex] = null;
			g_hSlenderRage1Timer[iBossIndex] = null;
			g_hSlenderRage2Timer[iBossIndex] = null;
			g_hSlenderRage3Timer[iBossIndex] = null;
			g_hSlenderHealTimer[iBossIndex] = null;
			g_hSlenderHealDelayTimer[iBossIndex] = null;
			g_hSlenderHealEventTimer[iBossIndex] = null;
			g_hSlenderStartFleeTimer[iBossIndex] = null;
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
			g_iSlenderTauntAlertCount[iBossIndex] = 0;

			//Yes we have to do this, cause collisions are funny and damage numbers don't display properly
			float flTempHitboxMins[3];
			g_iSlenderHitbox[iBossIndex] = CreateEntityByName("base_boss");
			Address aLocomotion = SF2_GetLocomotionInterface(g_iSlenderHitbox[iBossIndex]);

			SetEntityModel(g_iSlenderHitbox[iBossIndex], sBuffer);
			TeleportEntity(g_iSlenderHitbox[iBossIndex], flTruePos, flVecAng, NULL_VECTOR);
			DispatchKeyValue(g_iSlenderHitbox[iBossIndex],"TeamNum","1");
			DispatchSpawn(g_iSlenderHitbox[iBossIndex]);
			ActivateEntity(g_iSlenderHitbox[iBossIndex]);
			SetEntityMoveType(g_iSlenderHitbox[iBossIndex],MOVETYPE_NONE);
			SetEntityRenderMode(g_iSlenderHitbox[iBossIndex], RENDER_TRANSCOLOR);
			SetEntityRenderColor(g_iSlenderHitbox[iBossIndex], 0, 0, 0, 0);
			SetVariantString("!activator");
			AcceptEntityInput(g_iSlenderHitbox[iBossIndex], "SetParent", npcEntity.iEnt);
			AcceptEntityInput(g_iSlenderHitbox[iBossIndex], "EnableShadow");
			AcceptEntityInput(g_iSlenderHitbox[iBossIndex], "DisableShadow");
			if (SF_IsBoxingMap()) SetEntProp(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);
			//Block base_boss's ai.
			SetEntProp(g_iSlenderHitbox[iBossIndex], Prop_Data,"m_nNextThinkTick",-1);
			g_iSlenderHitboxOwner[g_iSlenderHitbox[iBossIndex]] = npcEntity.iEnt;
			SDKHook(g_iSlenderHitbox[iBossIndex], SDKHook_OnTakeDamageAlive, Hook_HitboxOnTakeDamage);
			//SDKHook(g_iSlenderHitbox[iBossIndex], SDKHook_ShouldCollide, Hook_HitBoxShouldCollide);
			DHookRaw(g_hShouldCollide, true, aLocomotion);
			if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
			{
				float flScaleModel = NPCGetModelScale(iBossIndex) * 0.5;
				SetEntPropFloat(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_flModelScale", flScaleModel);
			}
			else
			{
				SetEntPropFloat(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_flModelScale", NPCGetModelScale(iBossIndex));
			}
			if (NPCGetRaidHitbox(iBossIndex) == 1)
			{
				CopyVector(g_flSlenderDetectMins[iBossIndex], flTempHitboxMins);
				flTempHitboxMins[2] = 10.0;
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMins", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxs", g_flSlenderDetectMaxs[iBossIndex]);
				
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMinsPreScaled", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxsPreScaled", g_flSlenderDetectMaxs[iBossIndex]);
			}
			else if (NPCGetRaidHitbox(iBossIndex) == 0)
			{
				CopyVector(HULL_HUMAN_MINS, flTempHitboxMins);
				flTempHitboxMins[2] = 10.0;
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMins", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);
				
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMinsPreScaled", flTempHitboxMins);
				SetEntPropVector(g_iSlenderHitbox[iBossIndex], Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
			}
			if (!g_cvDisableBossCrushFix.BoolValue) SetEntData(g_iSlenderHitbox[iBossIndex], FindSendPropInfo("CTFBaseBoss", "m_lastHealthPercentage") + 28, false, 4, true);

			SetEntProp(g_iSlenderHitbox[iBossIndex], Prop_Data, "m_iHealth", 2147483646);
			SetEntProp(g_iSlenderHitbox[iBossIndex], Prop_Data, "m_iMaxHealth", 2147483646);
			SetEntProp(g_iSlenderHitbox[iBossIndex], Prop_Data, "m_initialHealth", 2147483646);

			for (int iDifficulty2 = 0; iDifficulty2 < Difficulty_Max; iDifficulty2++)
			{
				g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + NPCGetIdleLifetime(iBossIndex, iDifficulty2);
				g_flSlenderNextWanderPos[iBossIndex][iDifficulty2] = GetGameTime() + GetRandomFloat(2.0, 4.0);
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
			g_bNPCVelocityCancel[iBossIndex] = false;
			g_hSlenderBurnTimer[iBossIndex] = null;
			g_hSlenderBleedTimer[iBossIndex] = null;
			g_hSlenderMarkedTimer[iBossIndex] = null;
			g_hSlenderDeathCamTimer[iBossIndex] = null;
			g_iSlenderDeathCamTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_flSlenderStopBurning[iBossIndex] = 0.0;
			g_flSlenderStopBleeding[iBossIndex] = 0.0;
			g_bSlenderIsBurning[iBossIndex] = false;
			g_bSlenderIsMarked[iBossIndex] = false;
			g_flNPCAddSpeed[iBossIndex] = 0.0;
			g_flNPCAddMaxSpeed[iBossIndex] = 0.0;
			g_flNPCAddAcceleration[iBossIndex] = 0.0;
			g_iSlenderAutoChaseCount[iBossIndex] = 0;
			g_flSlenderAutoChaseCooldown[iBossIndex] = 0.0;
			g_iSlenderSoundTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_iSlenderSeeTarget[iBossIndex] = INVALID_ENT_REFERENCE;
			g_bAutoChasingLoudPlayer[iBossIndex] = false;
			g_bSlenderInDeathcam[iBossIndex] = false;

			Spawn_Chaser(iBossIndex);
			
			NPCChaserResetAnimationInfo(iBossIndex, 0);

			SDKHook(npcEntity.iEnt, SDKHook_ThinkPost, SlenderSetNextThink);
			SDKHook(npcEntity.iEnt, SDKHook_Think, SlenderChaseBossProcessMovement);

			SlenderPerformVoice(iBossIndex, "sound_spawn_local");
			if (view_as<bool>(GetProfileNum(sProfile,"spawn_animation",0)) && !SF_IsSlaughterRunMap())
			{
				g_bSlenderSpawning[iBossIndex] = true;
				g_hSlenderSpawnTimer[iBossIndex] = CreateTimer(GetProfileFloat(sProfile, "spawn_timer", 0.0), Timer_SlenderSpawnTimer, EntIndexToEntRef(npcEntity.iEnt), TIMER_FLAG_NO_MAPCHANGE);
				NPCChaserUpdateBossAnimation(iBossIndex, npcEntity.iEnt, STATE_IDLE, true);
			}
			else
			{
				g_bSlenderSpawning[iBossIndex] = false;
				g_hSlenderEntityThink[iBossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(npcEntity.iEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				NPCChaserUpdateBossAnimation(iBossIndex, npcEntity.iEnt, STATE_IDLE);
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

			//(Experimental)
			if (NPCGetHealthbarState(iBossIndex))
			{
				//The boss spawned for the 1st time, block now its teleportation ability to prevent healthbar conflict.
				NPCSetFlags(iBossIndex,NPCGetFlags(iBossIndex)|SFF_NOTELEPORT);
				UpdateHealthBar(iBossIndex);
			}
			if(g_sSlenderEngineSound[iBossIndex][0] != '\0' && view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)))
			{
				EmitSoundToAll(g_sSlenderEngineSound[iBossIndex], npcEntity.iEnt, SNDCHAN_STATIC, GetProfileNum(sProfile, "engine_sound_level", 83), 
				_, GetProfileFloat(sProfile, "engine_sound_volume", 0.8));
			}
			/*if (SF_BossesChaseEndlessly() || SF_IsRaidMap())
			{
				NPCSetFlags(iBossIndex,NPCGetFlags(iBossIndex)|SFF_NOTELEPORT);
			}*/

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
					else
					{
						iHealth = GetProfileNum(sProfile, "stun_health_per_player", 0);
						flMaxHealth += float(iHealth);
					}
					if (SF_IsBoxingMap() && strcmp(sClassName, "scout", false) == 0)
					{
						NPCSetAddSpeed(iBossIndex, 10.0);
						NPCSetAddMaxSpeed(iBossIndex, 15.0);
					}
				}
			}
			NPCChaserSetStunInitialHealth(iBossIndex, flMaxHealth);
			NPCChaserSetStunHealth(iBossIndex, NPCChaserGetStunInitialHealth(iBossIndex));
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
		if (!NPCGetRainbowOutlineState(iBossIndex))
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
		else SlenderAddGlow(iBossIndex,_,view_as<int>({0, 0, 0, 0}));
	}
	else
	{
		int iPurple[4] = {150, 0, 255, 255};
		SlenderAddGlow(iBossIndex,_,iPurple);
	}
	
	int iMaster = g_iSlenderCopyMaster[iBossIndex];
	int flags = NPCGetFlags(iBossIndex);
	
	if (MAX_BOSSES > iMaster >= 0 && NPCGetFakeCopyState(iBossIndex))
	{
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES))
		{
			NPCSetFlags(iBossIndex, flags | SFF_FAKE);
		}
	}

	SlenderSpawnEffects(iBossIndex);
	
	if (EntRefToEntIndex(g_iSlender[iBossIndex]) > MaxClients)
	{
		// Call our forward.
		Call_StartForward(fOnBossSpawn);
		Call_PushCell(iBossIndex);
		Call_Finish();
	}
}

static bool LocoCollideWith(CBaseNPC_Locomotion loco, int other)
{
	if (IsValidEntity(other))
	{
		char strClass[32];
		GetEdictClassname(other, strClass, sizeof(strClass));
		if (strcmp(strClass, "player") == 0)
		{
			if (!g_bPlayerProxy[other] && !IsClientInGhostMode(other) && GetClientTeam(other) != TFTeam_Blue && !IsClientInDeathCam(other))
			{
				return true;
			}
		}
	}
	return false;
}

static bool CanJumpAcrossGaps(CBaseNPC_Locomotion loco)
{
	return false;
}

static void JumpAcrossGapsCBase(CBaseNPC_Locomotion loco, const float landingGoal[3], const float landingForward[3])
{
	return;
}

static bool ClimbUpCBase(CBaseNPC_Locomotion loco, const float vecGoal[3], const float vecForward[3], int entity)
{
	return false;
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

		if (NPCGetType(iBossIndex) == SF2BossType_Statue)
		{
			SDKUnhook(iBoss, SDKHook_Think, SlenderStatueBossProcessMovement);
			// Stop all possible looping sounds.
			ClientStopAllSlenderSounds(iBoss, sProfile, "sound_move", SNDCHAN_AUTO);
		}
		else
		{
			SDKUnhook(iBoss, SDKHook_Think, SlenderChaseBossProcessMovement);
			SDKUnhook(iBoss, SDKHook_OnTakeDamageAlive, Hook_SlenderOnTakeDamageOriginal);
		}

		if (g_pPath[iBossIndex].IsValid())
		{
			g_pPath[iBossIndex].Invalidate();
		}

		int iGlow = EntRefToEntIndex(g_iNPCGlowEntity[iBossIndex]);
		if(iGlow != INVALID_ENT_REFERENCE)
		{
			RemoveEntity(iGlow);
			g_iNPCGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
		}
		iGlow = EntRefToEntIndex(g_iNPCTauntGlowEntity[iBossIndex]);
		if (iGlow != INVALID_ENT_REFERENCE)
		{
			RemoveEntity(iGlow);
			g_iNPCTauntGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
		}

		if (view_as<bool>(GetProfileNum(sProfile,"tp_effect_despawn",0))) SlenderCreateParticleSpawnEffect(iBossIndex, "tp_effect_despawn_particle", "tp_effect_despawn_sound", "tp_effect_origin");
		
		if(view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)) && g_sSlenderEngineSound[iBossIndex][0] != '\0')
		{
			StopSound(iBoss, SNDCHAN_STATIC, g_sSlenderEngineSound[iBossIndex]);
		}
		
		if (NPCGetFlags(iBossIndex) & SFF_HASSTATICLOOPLOCALSOUND)
		{
			char sLoopSound[PLATFORM_MAX_PATH];
			GetRandomStringFromProfile(sProfile, "sound_static_loop_local", sLoopSound, sizeof(sLoopSound), 1);
			
			if (sLoopSound[0] != '\0')
			{
				StopSound(iBoss, SNDCHAN_STATIC, sLoopSound);
			}
		}
		int iBossFlags = NPCGetFlags(iBossIndex);
		if (SF_IsRaidMap() || SF_BossesChaseEndlessly() && !NPCGetHealthbarState(iBossIndex))
		{
			NPCSetFlags(iBossIndex, iBossFlags & ~SFF_NOTELEPORT);
		}
		
		g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
		RemoveEntity(iBoss);
	}
	else 
	{
		g_iSlender[iBossIndex] = INVALID_ENT_REFERENCE;
		g_iNPCGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
		g_iNPCTauntGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
	}
	iBoss = g_iSlenderHitbox[iBossIndex];
	if (iBoss && iBoss != INVALID_ENT_REFERENCE && IsValidEntity(iBoss))
	{
		SDKUnhook(iBoss, SDKHook_OnTakeDamageAlive, Hook_HitboxOnTakeDamage);
		RemoveEntity(iBoss);
	}
	g_iSlenderHitbox[iBossIndex] = INVALID_ENT_REFERENCE;
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
		g_hSlenderBurnTimer[iBossIndex] = null;
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
			if (NPCChaserGetStunHealth(iBossIndex) <= 0.0 && iState != STATE_STUN)
			{
				float flMyPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
				NPCBossTriggerStun(iBossIndex, slender, sProfile, flMyPos);
				Call_StartForward(fOnBossStunned);
				Call_PushCell(iBossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(iBossIndex) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
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
		g_hSlenderBleedTimer[iBossIndex] = null;
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
			if (NPCChaserGetStunHealth(iBossIndex) <= 0.0 && iState != STATE_STUN)
			{
				float flMyPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
				NPCBossTriggerStun(iBossIndex, slender, sProfile, flMyPos);
				Call_StartForward(fOnBossStunned);
				Call_PushCell(iBossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(iBossIndex) && iState != STATE_STUN && !g_bNPCUsesRageAnimation1[iBossIndex] && !g_bNPCUsesRageAnimation2[iBossIndex] && !g_bNPCUsesRageAnimation3[iBossIndex])
		{
			UpdateHealthBar(iBossIndex);
		}
	}
	return Plugin_Continue;
}

public Action Timer_BossMarked(Handle timer, any entref)
{
	if (!g_bEnabled) return Plugin_Stop;

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE) return Plugin_Stop;
	
	if (!SF_IsBoxingMap()) return Plugin_Stop;

	int iBossIndex = NPCGetFromEntIndex(slender);
	if (iBossIndex == -1) return Plugin_Stop;
	
	if (timer != g_hSlenderMarkedTimer[iBossIndex]) return Plugin_Stop;
	
	g_hSlenderMarkedTimer[iBossIndex] = null;
	g_bSlenderIsMarked[iBossIndex] = false;

	return Plugin_Stop;
}

public bool Hook_HitBoxShouldCollide(int slender,int collisiongroup,int contentsmask, bool originalResult)
{
	if ((contentsmask & CONTENTS_MONSTERCLIP) || (contentsmask & CONTENTS_PLAYERCLIP))
	{
		//CONTENTS_MOVEABLE seems to make the hitbox bullet proof
		return false;
	}
	return originalResult;
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
	if ((SF_SpecialRound(SPECIALROUND_WALLHAX) || g_cvEnableWallHax.BoolValue) && GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other]) return Plugin_Continue;
	bool bNightVision = (g_cvNightvisionEnabled.BoolValue || SF_SpecialRound(SPECIALROUND_NIGHTVISION));
	if (bNightVision && g_iNightvisionType == 2 && GetClientTeam(other) == TFTeam_Red && !g_bPlayerEscaped[other] && !g_bPlayerEliminated[other] && IsClientUsingFlashlight(other)) return Plugin_Continue;
	if (g_bRestartSessionEnabled) return Plugin_Continue;
	return Plugin_Handled;
}

stock bool SlenderCanHearPlayer(int iBossIndex,int client, SoundType iSoundType)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client)) return false;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
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
	Handle hTrace = null;
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
			
			hTrace = TR_TraceRayFilterEx(flMyPos, flHisPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
			bTraceHit = TR_DidHit(hTrace);
			delete hTrace;
		}
		case SoundType_Voice, SoundType_Flashlight:
		{
			float flHisEyePos[3];
			GetClientEyePosition(client, flHisEyePos);
			
			hTrace = TR_TraceRayFilterEx(flMyEyePos, flHisEyePos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
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
			
			hTrace = TR_TraceRayFilterEx(flMyEyePos, flEndPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, iSlender);
			bTraceHit = TR_DidHit(hTrace);
			delete hTrace;
			
			flDistance *= 0.66;
		}
	}
	
	delete hTrace;
	
	if (bTraceHit) flDistance *= 1.66;
	
	if (TF2_GetPlayerClass(client) == TFClass_Spy) flDistance *= 1.3;

	if (TF2_GetPlayerClass(client) == TFClass_Scout) flDistance *= 0.75;
	
	if (flDistance > SquareFloat(flHearRadius)) return false;
	
	return true;
}

stock int SlenderArrayIndexToEntIndex(int iBossIndex)
{
	return NPCGetEntIndex(iBossIndex);
}

stock bool SlenderOnlyLooksIfNotSeen(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Statue) return true;
	return false;
}

stock bool SlenderUsesBlink(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Statue) return true;
	return false;
}

stock bool SlenderKillsOnNear(int iBossIndex)
{
	if (NPCGetType(iBossIndex) == SF2BossType_Statue) return false;
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
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iDifficultyIndex = g_iNPCDeathMessageDifficultyIndexes[iBossIndex];
	
	char sIndexes[8], sCurrentIndex[2];
	FormatEx(sIndexes, sizeof(sIndexes), "%d", iDifficultyIndex);
	FormatEx(sCurrentIndex, sizeof(sCurrentIndex), "%d", g_cvDifficulty.IntValue);
	char sNumber = sCurrentIndex[0];
	int iDifficultyNumber = 0;
	if (FindCharInString(sIndexes, sNumber) != -1)
	{
		iDifficultyNumber += g_cvDifficulty.IntValue;
	}
	if (sIndexes[0] != '\0' && sCurrentIndex[0] != '\0' && iDifficultyNumber != -1)
	{
		int iCurrentAtkIndex = StringToInt(sCurrentIndex);
		if (iDifficultyNumber == iCurrentAtkIndex) //WHOA, legacy system actually won't be legacy.
		{
			char sBuffer[PLATFORM_MAX_PATH], sPrefix[PLATFORM_MAX_PATH], sName[SF2_MAX_NAME_LENGTH], sTime[PLATFORM_MAX_PATH];
			int iRoundTime = RoundToNearest(g_flRoundTimeMessage);
			int iRandomMessage;
			GetRandomStringFromProfile(sProfile, "chat_message_upon_death", sBuffer, sizeof(sBuffer), _, _, iRandomMessage);
			GetProfileString(sProfile, "chat_message_upon_death_prefix", sPrefix, sizeof(sPrefix));
			NPCGetBossName(iBossIndex, sName, sizeof(sName));
			FormatEx(sTime, sizeof(sTime), "%d", iRoundTime);
			char sPlayer[32], sReplacePlayer[64];
			FormatEx(sPlayer, sizeof(sPlayer), "%N", iPlayer);
			if (sPrefix[0] == '\0')
			{
				sPrefix = "[SF2]";
			}
			if (sBuffer[0] != '\0' && GetClientTeam(iPlayer) == 2)
			{
				Format(sPlayer, sizeof(sPlayer), "{red}%s", sPlayer);
				if (StrContains(sBuffer, "[PLAYER]", true) != -1) 
				{
					FormatEx(sReplacePlayer, sizeof(sReplacePlayer), "%s{default}", sPlayer);
					ReplaceString(sBuffer, sizeof(sBuffer), "[PLAYER]", sReplacePlayer, true);
				}
				else Format(sBuffer, sizeof(sBuffer), "%s{default} %s", sPlayer, sBuffer);
				if (StrContains(sBuffer, "[BOSS]", true) != -1) ReplaceString(sBuffer, sizeof(sBuffer), "[BOSS]", sName, true);
				if (StrContains(sBuffer, "[ROUNDTIME]", true) != -1) ReplaceString(sBuffer, sizeof(sBuffer), "[ROUNDTIME]", sTime, true);
				int iChatLength = strlen(sPrefix) + strlen(sBuffer);
				if (iChatLength > 255)
				{
					LogSF2Message("WARNING! Death message %i has greater than 255 characters on boss index %i, shorten the length of this message.", iRandomMessage, iBossIndex);
				}
				else CPrintToChatAll("{royalblue}%s{default} %s", sPrefix, sBuffer);
			}
		}
	}
}

void SlenderPerformVoice(int iBossIndex, const char[] sSectionName,const int iAttackIndex=-1, int iDefaultChannel = SNDCHAN_AUTO)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath),_,iAttackIndex);
	
	if (sPath[0] != '\0')
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
		int iChannel = GetProfileNum(sProfile, sBuffer, iDefaultChannel);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_level");
		int iLevel = GetProfileNum(sProfile, sBuffer, SNDLEVEL_SCREAMING);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch_random_min");
		int iRandomPitchMin = GetProfileNum(sProfile, sBuffer, iPitch);
		strcopy(sBuffer, sizeof(sBuffer), sSectionName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch_random_max");
		int iRandomPitchMax = GetProfileNum(sProfile, sBuffer, iPitch);
		if (iRandomPitchMin != iPitch && iRandomPitchMax != iPitch) iPitch = GetRandomInt(iRandomPitchMin, iRandomPitchMax);
		
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
	//halloween_boss_foot_impact
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	int iState = g_iSlenderState[iBossIndex];
	
	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath));

	float flMyPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
	
	if (sPath[0] != '\0')
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
					if (StrContains(sPath, "/", false) != -1 && StrContains(sPath, "\\", false) != -1) 
					{
						EmitGameSoundToAll(sPath, slender);
					}
					else
					{
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
					if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
					{
						UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
					}
				}
			}
			case STATE_WANDER, STATE_ALERT:
			{
				if (flCooldownWalk != 0.0)
				{
					float flCooldownWalk2 = flCooldownWalk;
					g_flSlenderNextFootstepWalkSound[iBossIndex] = GetGameTime() + flCooldownWalk2;
					if (StrContains(sPath, "/", false) != -1 && StrContains(sPath, "\\", false) != -1) 
					{
						EmitGameSoundToAll(sPath, slender);
					}
					else
					{
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
					if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
					{
						UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
					}
				}
			}
			case STATE_CHASE:
			{
				if (flCooldownRun != 0.0)
				{
					float flCooldownRun2 = flCooldownRun;
					g_flSlenderNextFootstepRunSound[iBossIndex] = GetGameTime() + flCooldownRun2;
					if (StrContains(sPath, "/", false) != -1 && StrContains(sPath, "\\", false) != -1) 
					{
						EmitGameSoundToAll(sPath, slender);
					}
					else
					{
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
					if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
					{
						UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
					}
				}
			}
			case STATE_STUN:
			{
				if (flCooldownStun != 0.0)
				{
					float flCooldownStun2 = flCooldownStun;
					g_flSlenderNextFootstepStunSound[iBossIndex] = GetGameTime() + flCooldownStun2;
					if (StrContains(sPath, "/", false) != -1 && StrContains(sPath, "\\", false) != -1) 
					{
						EmitGameSoundToAll(sPath, slender);
					}
					else
					{
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
					if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
					{
						UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
					}
				}
			}
			case STATE_ATTACK:
			{
				if (flCooldownAttack != 0.0)
				{
					float flCooldownAttack2 = flCooldownAttack;
					g_flSlenderNextFootstepAttackSound[iBossIndex] = GetGameTime() + flCooldownAttack2;
					if (StrContains(sPath, "/", false) != -1 && StrContains(sPath, "\\", false) != -1) 
					{
						EmitGameSoundToAll(sPath, slender);
					}
					else
					{
						EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
					}
					if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
					{
						UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
						NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
					}
				}
			}
		}
	}
}

void SlenderCastFootstepAnimEvent(int iBossIndex, const char[] sSectionName)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath));

	float flMyPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flMyPos);
	
	if (sPath[0] != '\0')
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
		if (StrContains(sPath, "/", false) == -1 && StrContains(sPath, "\\", false) == -1) 
		{
			EmitGameSoundToAll(sPath, slender);
		}
		else
		{
			EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
		}
	}
	if (NPCChaserGetEarthquakeFootstepsState(iBossIndex))
	{
		UTIL_ScreenShake(flMyPos, NPCChaserGetEarthquakeFootstepsAmplitude(iBossIndex), 
		NPCChaserGetEarthquakeFootstepsFrequency(iBossIndex), NPCChaserGetEarthquakeFootstepsDuration(iBossIndex), 
		NPCChaserGetEarthquakeFootstepsRadius(iBossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(iBossIndex));
	}
}

void SlenderCastAnimEvent(int iBossIndex, const char[] sSectionName)
{
	if (iBossIndex == -1) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	char sPath[PLATFORM_MAX_PATH];
	GetRandomStringFromProfile(sProfile, sSectionName, sPath, sizeof(sPath));

	if (sPath[0] != '\0')
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
		if (StrContains(sPath, "/", false) == -1 && StrContains(sPath, "\\", false) == -1) 
		{
			EmitGameSoundToAll(sPath, slender);
		}
		else
		{
			EmitSoundToAll(sPath, slender, iChannel, iLevel, _, flVolume, iPitch);
		}
	}
}

void SlenderCreateParticle(int iBossIndex, const char[] sSectionName, float flParticleZPos)
{
	if (iBossIndex == -1) return;

	if (g_bRestartSessionEnabled) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	float flSlenderPosition[3], flSlenderAngles[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flSlenderAngles);
	flSlenderPosition[2] += flParticleZPos;

	DispatchParticleEffect(slender, sSectionName, flSlenderPosition, flSlenderAngles, flSlenderPosition);
}

void SlenderCreateParticleAttach(int iBossIndex, const char[] sSectionName, float flParticleZPos, int iClient)
{
	if (iBossIndex == -1) return;

	if (g_bRestartSessionEnabled) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	float flPlayerPosition[3], flPlayerAngles[3];
	if (IsValidClient(iClient))
	{
		GetClientAbsOrigin(iClient, flPlayerPosition);
		GetClientEyeAngles(iClient, flPlayerAngles);
	}
	else
	{
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flPlayerPosition);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flPlayerAngles);
	}
	flPlayerPosition[2] += flParticleZPos;

	DispatchParticleEffect(slender, sSectionName, flPlayerPosition, flPlayerAngles, flPlayerPosition);
}

void SlenderCreateParticleBeamClient(int iBossIndex, const char[] sSectionName, float flParticleZPos, int iClient)
{
	if (iBossIndex == -1) return;

	if (g_bRestartSessionEnabled) return;

	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return;

	float flSlenderPosition[3], flSlenderAngles[3], flPlayerPosition[3];
	if (IsValidClient(iClient))
	{
		GetClientAbsOrigin(iClient, flPlayerPosition);
	}
	else
	{
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flPlayerPosition);
	}
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flSlenderAngles);
	flSlenderPosition[2] += flParticleZPos;
	flPlayerPosition[2] += flParticleZPos;

	DispatchParticleEffectBeam(slender, sSectionName, flSlenderPosition, flSlenderAngles, flPlayerPosition);
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
	
	float flSlenderPosition[3], flSlenderAngles[3], flOffsetPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", flSlenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", flSlenderAngles);
	GetProfileVector(sProfile, sVectorOffset, flOffsetPos, view_as<float>( { 0.0, 0.0, 0.0 } ));
	AddVectors(flOffsetPos, flSlenderPosition, flSlenderPosition);

	DispatchParticleEffect(slender, sParticle, flSlenderPosition, flSlenderAngles, flSlenderPosition);

	GetProfileString(sProfile, sSoundName, sSoundEffect, sizeof(sSoundEffect));
	if (sSoundName[0] != '\0')
	{
		char sBuffer[PLATFORM_MAX_PATH];
		strcopy(sBuffer, sizeof(sBuffer), sSoundName);
		StrCat(sBuffer, sizeof(sBuffer), "_volume");
		float flVolume = GetProfileFloat(sProfile, sBuffer, 1.0);
		strcopy(sBuffer, sizeof(sBuffer), sSoundName);
		StrCat(sBuffer, sizeof(sBuffer), "_pitch");
		int iPitch = GetProfileNum(sProfile, sBuffer, 100);
		EmitSoundToAll(sSoundEffect, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, flVolume, iPitch);
	}
}

/*bool SlenderCalculateApproachToPlayer(int iBossIndex,int iBestPlayer, float buffer[3])
{
	if (!IsValidClient(iBestPlayer)) return false;
	
	int slender = NPCGetEntIndex(iBossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE) return false;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
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
	float flDist = NPCGetSpeed(iBossIndex, iDifficulty) * g_flRoundDifficultyModifier;
	if (flDist < NPCGetInstantKillRadius(iBossIndex)) flDist = NPCGetInstantKillRadius(iBossIndex) / 2.0;
	float flWithinFOV = 45.0;
	float flWithinFOVSide = 90.0;
	
	Handle hTrace = null;
	int index;
	float flHitNormal[3], tempPos2[3], flBuffer[3], flBuffer2[3];
	ArrayList hArray = new ArrayList(6);
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been created for hArray in SlenderCalculateApproachToPlayer.", hArray);
	#endif
	
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
		index = hArray.Push(iID);
		hArray.Set(index, tempPos[0], 1);
		hArray.Set(index, tempPos[1], 2);
		hArray.Set(index, tempPos[2], 3);
		hArray.Set(index, iRange, 4);
		hArray.Set(index, bBackup, 5);
		
		iID++;
	}
	
	int size;
	if ((size = hArray.Length) > 0)
	{
		float diff = AngleDiff(hisEyeAng[1], flReferenceAng[1]);
		if (diff >= 0.0) iRange = 1;
		else iRange = 2;
		
		bool bBackup = false;
		
		// Clean up any vectors that we don't need.
		ArrayList hArray2 = hArray.Clone();
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone Array list %b has been created for hArray2 in SlenderCalculateApproachToPlayer.", hArray2);
		#endif
		for (int i = 0; i < size; i++)
		{
			if (hArray2.Get(i, 4) != iRange || view_as<bool>(hArray2.Get(i, 5) != bBackup))
			{
				int iIndex = hArray.FindValue(hArray2.Get(i));
				if (iIndex != -1) hArray.Erase(iIndex);
			}
		}
		
		delete hArray2;

		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Clone Array list %b has been deleted for hArray2 in SlenderCalculateApproachToPlayer.", hArray2);
		#endif
		
		size = hArray.Length;
		if (size)
		{
			index = GetRandomInt(0, size - 1);
			buffer[0] = view_as<float>(hArray.Get(index, 1));
			buffer[1] = view_as<float>(hArray.Get(index, 2));
			buffer[2] = view_as<float>(hArray.Get(index, 3));
		}
		else
		{
			delete hArray;
			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Deleted Array list %b due to no size for hArray.Length in SlenderCalculateApproachToPlayer.", hArray);
			#endif
			return false;
		}
	}
	else
	{
		delete hArray;
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Deleted Array list %b due to no size for hArray.Length in SlenderCalculateApproachToPlayer but further out.", hArray);
		#endif
		return false;
	}
	
	delete hArray;
	#if defined DEBUG
	SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Deleted Array list %b anyways in SlenderCalculateApproachToPlayer.", hArray);
	#endif
	delete hTrace;
	return true;
}*/

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
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	float flTeleportTargetTimeLeft = g_flSlenderTeleportMaxTargetTime[iBossIndex] - GetGameTime();
	float flTeleportTargetTimeInitial = g_flSlenderTeleportMaxTargetTime[iBossIndex] - g_flSlenderTeleportTargetTime[iBossIndex];
	float flTeleportMinRange = flTeleportMaxRange - (1.0 - (flTeleportTargetTimeLeft / flTeleportTargetTimeInitial)) * (flTeleportMaxRange - flInitialMinRange);
	
	if (NPCGetAnger(iBossIndex) <= 1.0)
	{
		flTeleportMinRange += (g_flSlenderTeleportMinRange[iBossIndex][iDifficulty] - flTeleportMaxRange) * Pow(0.0, 2.0 / g_flRoundDifficultyModifier);
	}
	
	if (flTeleportMinRange < flInitialMinRange) flTeleportMinRange = flInitialMinRange;
	if (flTeleportMinRange > flTeleportMaxRange) flTeleportMinRange = flTeleportMaxRange;
	
	return flTeleportMinRange;
}

public Action Timer_SlenderTeleportThink(Handle timer, any iBossIndex)
{
	if (iBossIndex == -1) return Plugin_Stop;
	if (timer != g_hSlenderThink[iBossIndex]) return Plugin_Stop;

	if (SF_IsBoxingMap()) return Plugin_Stop;

	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape) return Plugin_Continue;

	if (NPCGetFlags(iBossIndex) & SFF_NOTELEPORT) return Plugin_Continue;

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	if (!NPCIsTeleportAllowed(iBossIndex, iDifficulty)) return Plugin_Continue;
	
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
				else
				{
					if (GetGameTime() >= g_flSlenderTimeUntilKill[iBossIndex])
					{
						g_flSlenderTimeUntilKill[iBossIndex] = GetGameTime() + NPCGetIdleLifetime(iBossIndex, iDifficulty);
					}
					return Plugin_Continue;
				}
			}
		}
	}
	
	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));
	
	if (IsRoundPlaying())
	{
		if (GetGameTime() >= g_flSlenderNextTeleportTime[iBossIndex])
		{
			float flTeleportTime = GetRandomFloat(NPCGetTeleportTimeMin(iBossIndex, iDifficulty), NPCGetTeleportTimeMax(iBossIndex, iDifficulty));
			g_flSlenderNextTeleportTime[iBossIndex] = GetGameTime() + flTeleportTime;
			bool bIgnoreFuncNavPrefer = g_bNPCIgnoreNavPrefer[iBossIndex];
			
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
				CBaseCombatCharacter tempCharacter = CBaseCombatCharacter(iTeleportTarget);
				CNavArea TargetArea = tempCharacter.GetLastKnownArea();
				if (TargetArea != NULL_AREA)
				{
					bool bShouldBeBehindObstruction = false;
					if (NPCGetTeleportType(iBossIndex) == 2)
					{
						bShouldBeBehindObstruction = true;
					}
						
					// Search outwards until travel distance is at maximum range.
					ArrayList hAreaArray = new ArrayList(2);

					SurroundingAreasCollector sCollector = TheNavMesh.CollectSurroundingAreas(TargetArea, g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty], _, _);
					{
						int iPoppedAreas;
					
						for (int iAreaIndex = 0, iMaxCount = sCollector.Count(); iAreaIndex < iMaxCount; iAreaIndex++)
						{
							CNavArea Area = sCollector.Get(iAreaIndex);
								
							// Check flags.
							if (Area.GetAttributes() & NAV_MESH_NO_HOSTAGES)
							{
								// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
								continue;
							}
							// Check if the nav area has a func prefer on it.
							if (bIgnoreFuncNavPrefer && NavHasFuncPrefer(Area))
								continue;

							int iIndex = hAreaArray.Push(Area);
							hAreaArray.Set(iIndex, Area.GetCostSoFar(), 1);
							iPoppedAreas++;
						}
							
						#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: collected %d areas", iBossIndex, iPoppedAreas);
						#endif
						delete sCollector;
					}
					
					ArrayList hAreaArrayClose = new ArrayList(4);
					ArrayList hAreaArrayAverage = new ArrayList(4);
					ArrayList hAreaArrayFar = new ArrayList(4);
					
					for (int i = 1; i <= 3; i++)
					{
						float flRangeSectionMin = flTeleportMinRange + (g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i - 1) / 3.0);
						float flRangeSectionMax = flTeleportMinRange + (g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i) / 3.0);
						
						for (int i2 = 0, iSize = hAreaArray.Length; i2 < iSize; i2++)
						{
							CNavArea area = hAreaArray.Get(i2);
							
							float flAreaSpawnPoint[3];
							area.GetCenter(flAreaSpawnPoint);
								
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
								delete hTrace;
								
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
							if (!g_bSlenderTeleportIgnoreVis[iBossIndex] && IsPointVisibleToAPlayer(flAreaSpawnPoint, !bShouldBeBehindObstruction, false)) continue;
								
							AddVectors(flAreaSpawnPoint, g_flSlenderEyePosOffset[iBossIndex], flAreaSpawnPoint);
								
							if (!g_bSlenderTeleportIgnoreVis[iBossIndex] && IsPointVisibleToAPlayer(flAreaSpawnPoint, !bShouldBeBehindObstruction, false)) continue;
								
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
								float flMinDistBetweenBossesTemp = GetProfileFloat(sProfile, "copy_teleport_dist_from_others", SF2_BOSS_COPY_SPAWN_MIN_DISTANCE);
								float flMinDistBetweenBosses = GetProfileFloat(sProfile, "teleport_distance_between_copies", flMinDistBetweenBossesTemp);
								
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
							float flDist = view_as<float>(hAreaArray.Get(i2, 1));
							if (flDist > flRangeSectionMin && flDist < flRangeSectionMax)
							{
								int iIndex = -1;
								ArrayList hTargetAreaArray = null;
								
								switch (i)
								{
									case 1: 
									{
										iIndex = hAreaArrayClose.Push(area);
										hTargetAreaArray = hAreaArrayClose;
									}
									case 2: 
									{
										iIndex = hAreaArrayAverage.Push(area);
										hTargetAreaArray = hAreaArrayAverage;
									}
									case 3: 
									{
										iIndex = hAreaArrayFar.Push(area);
										hTargetAreaArray = hAreaArrayFar;
									}
								}
									
								if (hTargetAreaArray != null && iIndex != -1)
								{
									hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[0], 1);
									hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[1], 2);
									hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[2], 3);
								}
							}
						}
					}
					
					delete hAreaArray;
					
					#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: collected %d close areas, %d average areas, %d far areas", iBossIndex, hAreaArrayClose.Length,
						hAreaArrayAverage.Length,
						hAreaArrayFar.Length);
					#endif
						
					int iArrayIndex = -1;
						
					if (hAreaArrayClose.Length)
					{
						iArrayIndex = GetRandomInt(0, hAreaArrayClose.Length - 1);
						iTeleportAreaIndex = hAreaArrayClose.Get(iArrayIndex);
						flTeleportPos[0] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 1));
						flTeleportPos[1] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 2));
						flTeleportPos[2] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 3));
					}
					else if (hAreaArrayAverage.Length)
					{
						iArrayIndex = GetRandomInt(0, hAreaArrayAverage.Length - 1);
						iTeleportAreaIndex = hAreaArrayAverage.Get(iArrayIndex);
						flTeleportPos[0] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 1));
						flTeleportPos[1] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 2));
						flTeleportPos[2] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 3));
					}
					else if (hAreaArrayFar.Length)
					{
						iArrayIndex = GetRandomInt(0, hAreaArrayFar.Length - 1);
						iTeleportAreaIndex = hAreaArrayFar.Get(iArrayIndex);
						flTeleportPos[0] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 1));
						flTeleportPos[1] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 2));
						flTeleportPos[2] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 3));
					}
						
					delete hAreaArrayClose;
					delete hAreaArrayAverage;
					delete hAreaArrayFar;
				}
				else
				{
					#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: failed because target is not on nav mesh!", iBossIndex);
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
	
	g_hSlenderFakeTimer[iBossIndex] = CreateTimer(3.0, Timer_SlenderMarkedAsFake, iBossIndex, TIMER_FLAG_NO_MAPCHANGE);

	CreateTimer(2.0, Timer_KillEntity, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);
	
	if (slender && slender != INVALID_ENT_REFERENCE)
	{
		int hitbox = g_iSlenderHitbox[iBossIndex];
		if (hitbox && hitbox != INVALID_ENT_REFERENCE && IsValidEntity(hitbox))
		{
			int iFlags = GetEntProp(hitbox, Prop_Send, "m_usSolidFlags");
			if (!(iFlags & 0x0004)) iFlags |= 0x0004; // 	FSOLID_NOT_SOLID
			if (!(iFlags & 0x0008)) iFlags |= 0x0008; // 	FSOLID_TRIGGER
			SetEntProp(hitbox, Prop_Send, "m_usSolidFlags", iFlags);
		}

		int iFlags = GetEntProp(slender, Prop_Send, "m_usSolidFlags");
		if (!(iFlags & 0x0004)) iFlags |= 0x0004; // 	FSOLID_NOT_SOLID
		if (!(iFlags & 0x0008)) iFlags |= 0x0008; // 	FSOLID_TRIGGER
		SetEntProp(slender, Prop_Send, "m_usSolidFlags", iFlags);
	
		if(view_as<bool>(GetProfileNum(sProfile,"use_engine_sounds",0)) && g_sSlenderEngineSound[iBossIndex][0] != '\0')
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
	if (timer != g_hSlenderFakeTimer[data]) return Plugin_Stop;
	
	NPCRemove(data);

	return Plugin_Stop;
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
	
	float flPlaybackRate, flTempFootsteps, flCycle;
	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);

	GetSlenderModel(iBossIndex, _, buffer, sizeof(buffer));
	if (buffer[0] == '\0')
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
			GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, buffer, sizeof(buffer), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
		}
		else 
		{
			bool bAnimationFound = GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_DeathcamAnimations, buffer, sizeof(buffer), flPlaybackRate, 1, _, flTempFootsteps, flCycle);
			if (!bAnimationFound || strcmp(buffer,"") <= 0)
			{
				GetProfileAnimation(iBossIndex, sProfile, ChaserAnimation_IdleAnimations, buffer, sizeof(buffer), flPlaybackRate, iDifficulty, _, g_flSlenderIdleFootstepTime[iBossIndex], flCycle);
			}
		}
		if (buffer[0] != '\0')
		{
			SetVariantString(buffer);
			AcceptEntityInput(iSlenderModel, "SetDefaultAnimation");
			SetVariantString(buffer);
			AcceptEntityInput(iSlenderModel, "SetAnimation");
			AcceptEntityInput(iSlenderModel, "DisableCollision");
		}
		
		SetVariantFloat(flPlaybackRate);
		AcceptEntityInput(iSlenderModel, "SetPlaybackRate");
		SetEntPropFloat(iSlenderModel, Prop_Data, "m_flCycle", flCycle);
		
		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES)) 
		{
			float flScaleModel = flModelScale * 0.5;
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
			if (view_as<bool>(GetProfileNum(sProfile,"skin_difficulty",0))) SetEntProp(iSlenderModel, Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(iBossIndex, iDifficulty));
			else SetEntProp(iSlenderModel, Prop_Send, "m_nSkin", iModelSkin);
		}
		if (NPCGetModelBodyGroupsMax(iBossIndex) > 0)
		{
			int iRandomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(iBossIndex));
			SetEntProp(iSlenderModel, Prop_Send, "m_nBody", iRandomBody);
		}
		else
		{
			if (view_as<bool>(GetProfileNum(sProfile,"body_difficulty",0))) SetEntProp(iSlenderModel, Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(iBossIndex, iDifficulty));
			else SetEntProp(iSlenderModel, Prop_Send, "m_nBody", NPCGetModelBodyGroups(iBossIndex));
		}

		SetEntProp(iSlenderModel, Prop_Send, "m_nBody", GetBossProfileBodyGroups(iProfileIndex));

		// Create special effects.
		SetEntityRenderMode(iSlenderModel, view_as<RenderMode>(g_iSlenderRenderMode[iBossIndex]));
		SetEntityRenderFx(iSlenderModel, view_as<RenderFx>(g_iSlenderRenderFX[iBossIndex]));
		SetEntityRenderColor(iSlenderModel, g_iSlenderRenderColor[iBossIndex][0], g_iSlenderRenderColor[iBossIndex][1], g_iSlenderRenderColor[iBossIndex][2], g_iSlenderRenderColor[iBossIndex][3]);
		
		g_hConfig.Rewind();
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
		SetEdictFlags(ent, FL_EDICT_FULLCHECK | FL_EDICT_ALWAYS);
		
		int iFlags = GetEntProp(ent, Prop_Send, "m_fEffects");
		SetEntProp(ent, Prop_Send, "m_fEffects", iFlags | (1 << 0));
		
		SetVariantString("!activator");
		AcceptEntityInput(ent, "SetParent", iEnt);
		
		if (sAttachment[0] != '\0')
		{
			SetVariantString(sAttachment);
			AcceptEntityInput(ent, "SetParentAttachment");
		}
		
		SDKHook(ent, SDKHook_SetTransmit, Hook_SlenderGlowSetTransmit);
		
		int iGlowManager = TF2_CreateGlow(ent);
		g_iNPCGlowEntity[iBossIndex] = EntIndexToEntRef(iGlowManager);
		//Set our desired glow color
		SetVariantColor(iColor);
		AcceptEntityInput(iGlowManager, "SetGlowColor");
		g_hSDKShouldTransmit.HookEntity(Hook_Pre, iGlowManager, Hook_EntityShouldTransmit);
		g_hSDKShouldTransmit.HookEntity(Hook_Pre, ent, Hook_EntityShouldTransmit);
		SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", iGlowManager);

		g_iNPCTauntGlowEntity[iBossIndex] = EntIndexToEntRef(ent);
		
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
			g_iNPCTauntGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
			iEnt = GetEntPropEnt(iEffect, Prop_Send, "m_hOwnerEntity");
			if (iEnt > MaxClients)
			{
				RemoveEntity(iEnt);
				g_iNPCGlowEntity[iBossIndex] = INVALID_ENT_REFERENCE;
			}
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

bool CanNPCSeePlayerNonTransparent(int iNPCIndex, int client)
{
	if (!NPCIsValid(iNPCIndex)) return false;

	if (!IsValidClient(client)) return false;

	bool bAttackEliminated = view_as<bool>(NPCGetFlags(iNPCIndex) & SFF_ATTACKWAITERS);

	if (!IsTargetValidForSlender(client, bAttackEliminated)) return false;

	int iNPC = NPCGetEntIndex(iNPCIndex);
	if (iNPC && iNPC != INVALID_ENT_REFERENCE)
	{
		float flEyePos[3], flClientPos[3];
		NPCGetEyePosition(iNPCIndex, flEyePos);
		GetClientEyePosition(client, flClientPos);
		Handle hTrace = TR_TraceRayFilterEx(flEyePos,
			flClientPos,
			MASK_NPCSOLID,
			RayType_EndPoint,
			TraceRayBossVisibility,
			iNPC);

		bool bIsVisible = !TR_DidHit(hTrace);
		delete hTrace;

		return bIsVisible;
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
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
	}
	return true;
}

public bool TraceRayDontHitCharacters(int entity,int mask, any data)
{
	if (entity > 0 && entity <= MaxClients) return false;
	
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_boss") == 0) return false;
	}
	
	return true;
}

public bool TraceRayDontHitEntityAndProxies(int entity,int mask,any data)
{
	if (entity == data) return false;
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_bPlayerProxy[entity] || IsClientInGhostMode(entity)) return false;
	}
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_boss") == 0) return false;
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
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
	}
	return true;
}

public bool TraceRayDontHitAnyEntity_Pathing(int entity, int contentsMask, int desiredcollisiongroup)
{
	if ((entity > 0 && entity <= MaxClients))
	{
		if (g_bPlayerProxy[entity] || IsClientInGhostMode(entity)) return false;
	}
	int iBossIndex = NPCGetFromEntIndex(entity);
	if (iBossIndex != -1) return false;
	if (IsValidEntity(entity))
	{
		char sClass[64];
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
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
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
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
		GetEntityClassname(entity, sClass, sizeof(sClass));
		if (strcmp(sClass, "base_npc") == 0 || strcmp(sClass, "base_boss") == 0) return false;
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

	if (!IsRoundPlaying())
		return false;
	
	if (!(NPCGetFlags(iBossIndex) & SFF_PROXIES)) return false;

	char sProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(iBossIndex, sProfile, sizeof(sProfile));

	int iDifficulty = GetLocalGlobalDifficulty(iBossIndex);
	
	if (iBossIndex == -1) //Please don't ask why I did this; EDIT: Yes, I will! Why? DOUBLE EDIT: Stupid warnings that I couldn't fix IIRC...
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

	int iTeleportTarget = EntRefToEntIndex(g_iSlenderProxyTarget[iBossIndex]);
	if (!iTeleportTarget || iTeleportTarget == INVALID_ENT_REFERENCE)
		return false;

	float flTeleportMinRange = CalculateTeleportMinRange(iBossIndex, g_flSlenderProxyTeleportMinRange[iBossIndex][iDifficulty], g_flSlenderProxyTeleportMaxRange[iBossIndex][iDifficulty]);
	CBaseCombatCharacter tempCharacter = CBaseCombatCharacter(iTeleportTarget);
	CNavArea TargetArea = tempCharacter.GetLastKnownArea();
	int iTeleportAreaIndex = -1;

	if (TargetArea != NULL_AREA)
	{
		// Search outwards until travel distance is at maximum range.
		ArrayList hAreaArray = new ArrayList(2);
		SurroundingAreasCollector sCollector = TheNavMesh.CollectSurroundingAreas(TargetArea, g_flSlenderTeleportMaxRange[iBossIndex][iDifficulty], _, _);
		{
			int iPoppedAreas;
						
			for (int iAreaIndex = 0, iMaxCount = sCollector.Count(); iAreaIndex < iMaxCount; iAreaIndex++)
			{
				CNavArea Area = sCollector.Get(iAreaIndex);
									
				// Check flags.
				if (Area.GetAttributes() & NAV_MESH_NO_HOSTAGES)
				{
					// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
					continue;
				}

				int iIndex = hAreaArray.Push(Area);
				hAreaArray.Set(iIndex, Area.GetCostSoFar(), 1);
				iPoppedAreas++;
			}
							
			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "Teleport for boss %d: collected %d areas", iBossIndex, iPoppedAreas);
			#endif
			delete sCollector;
		}
		
		ArrayList hAreaArrayClose = new ArrayList(4);
		ArrayList hAreaArrayAverage = new ArrayList(4);
		ArrayList hAreaArrayFar = new ArrayList(4);
		
		for (int i = 1; i <= 3; i++)
		{
			float flRangeSectionMin = flTeleportMinRange + (g_flSlenderProxyTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i - 1) / 3.0);
			float flRangeSectionMax = flTeleportMinRange + (g_flSlenderProxyTeleportMaxRange[iBossIndex][iDifficulty] - flTeleportMinRange) * (float(i) / 3.0);
			
			for (int i2 = 0, iSize = hAreaArray.Length; i2 < iSize; i2++)
			{
				CNavArea area = hAreaArray.Get(i2);
		
				float flAreaSpawnPoint[3];
				area.GetCenter(flAreaSpawnPoint);
				
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
				delete hTrace;
				
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
					
					if (GetVectorSquareMagnitude(flAreaSpawnPoint, flTempPos) <= SquareFloat(g_flSlenderProxyTeleportMinRange[iBossIndex][iDifficulty]))
					{
						bTooNear = true;
						break;
					}
				}
				
				if (bTooNear) continue;	// This area is not compatible.
				
				// Check travel distance and put in the appropriate arrays.
				float flDist = view_as<float>(hAreaArray.Get(i2, 1));
				if (flDist > flRangeSectionMin && flDist < flRangeSectionMax)
				{
					int iIndex = -1;
					ArrayList hTargetAreaArray = null;
					
					switch (i)
					{
						case 1: 
						{
							iIndex = hAreaArrayClose.Push(area);
							hTargetAreaArray = hAreaArrayClose;
						}
						case 2: 
						{
							iIndex = hAreaArrayAverage.Push(area);
							hTargetAreaArray = hAreaArrayAverage;
						}
						case 3: 
						{
							iIndex = hAreaArrayFar.Push(area);
							hTargetAreaArray = hAreaArrayFar;
						}
					}
					
					if (hTargetAreaArray != null && iIndex != -1)
					{
						hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[0], 1);
						hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[1], 2);
						hTargetAreaArray.Set(iIndex, flAreaSpawnPoint[2], 3);
					}
				}
			}
		}

		delete hAreaArray;
	
		int iArrayIndex = -1;
	
		if (hAreaArrayClose.Length)
		{
			iArrayIndex = GetRandomInt(0, hAreaArrayClose.Length - 1);
			iTeleportAreaIndex = hAreaArrayClose.Get(iArrayIndex);
			flTeleportPos[0] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(hAreaArrayClose.Get(iArrayIndex, 3));
		}
		else if (hAreaArrayAverage.Length)
		{
			iArrayIndex = GetRandomInt(0, hAreaArrayAverage.Length - 1);
			iTeleportAreaIndex = hAreaArrayAverage.Get(iArrayIndex);
			flTeleportPos[0] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(hAreaArrayAverage.Get(iArrayIndex, 3));
		}
		else if (hAreaArrayFar.Length)
		{
			iArrayIndex = GetRandomInt(0, hAreaArrayFar.Length - 1);
			iTeleportAreaIndex = hAreaArrayFar.Get(iArrayIndex);
			flTeleportPos[0] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 1));
			flTeleportPos[1] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 2));
			flTeleportPos[2] = view_as<float>(hAreaArrayFar.Get(iArrayIndex, 3));
		}
		delete hAreaArrayClose;
		delete hAreaArrayAverage;
		delete hAreaArrayFar;
	}

	if (iTeleportAreaIndex == -1)
		return false;
	
	return true;
}

#include "sf2/npc/npc_chaser.sp"
#include "sf2/npc/npc_chaser_takedamage.sp"