#if defined _sf2_npc_included
 #endinput
#endif
#define _sf2_npc_included

#pragma semicolon 1

#define SF2_BOSS_PAGE_CALCULATION 0.3
#define SF2_BOSS_COPY_SPAWN_MIN_DISTANCE 800.0 // The default minimum distance boss copies can spawn from each other.

#define SF2_BOSS_ATTACK_MELEE 0

static int g_NpcGlobalUniqueID = 0;

static int g_NpcUniqueID[MAX_BOSSES] = { -1, ... };
static char g_SlenderProfile[MAX_BOSSES][SF2_MAX_PROFILE_NAME_LENGTH];
static int g_NpcProfileIndex[MAX_BOSSES] = { -1, ... };
static int g_NpcUniqueProfileIndex[MAX_BOSSES] = { -1, ... };
static int g_NpcType[MAX_BOSSES] = { SF2BossType_Unknown, ... };
static int g_NpcFlags[MAX_BOSSES] = { 0, ... };
static float g_NpcModelScale[MAX_BOSSES] = { 1.0, ... };
static int g_NpcModelSkin[MAX_BOSSES] = { 0, ... };
static int g_NpcModelSkinDifficulty[MAX_BOSSES][Difficulty_Max];
static int g_NpcModelSkinMax[MAX_BOSSES] = { 0, ... };
static int g_NpcModelBodyGroups[MAX_BOSSES] = { 0, ... };
static int g_NpcModelBodyGroupsDifficulty[MAX_BOSSES][Difficulty_Max];
static int g_NpcModelBodyGroupsMax[MAX_BOSSES] = { 0, ... };
int g_NpcRaidHitbox[MAX_BOSSES] = { 0, ... };
int g_NpcGlowEntity[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };
static float g_NpcSoundMusicLoop[MAX_BOSSES][Difficulty_Max];
static int g_NpcAllowMusicOnDifficulty[MAX_BOSSES];
static char g_NpcName[MAX_BOSSES][Difficulty_Max][SF2_MAX_PROFILE_NAME_LENGTH];
static bool g_NpcHasFakeCopiesEnabled[MAX_BOSSES];
static float g_NpcBlinkLookRate[MAX_BOSSES];
static float g_NpcBlinkStaticRate[MAX_BOSSES];
static float g_NpcStepSize[MAX_BOSSES];
static int g_NpcTeleporters[MAX_BOSSES][MAX_NPCTELEPORTER];

static bool g_NpcHasDiscoMode[MAX_BOSSES];
static float g_NpcDiscoRadiusMin[MAX_BOSSES];
static float g_NpcDiscoRadiusMax[MAX_BOSSES];
static float g_NpcDiscoModePos[MAX_BOSSES][3];
static bool g_NpcHasFestiveLights[MAX_BOSSES];
static int g_NpcFestiveLightBrightness[MAX_BOSSES];
static float g_NpcFestiveLightDistance[MAX_BOSSES];
static float g_NpcFestiveLightRadius[MAX_BOSSES];
static float g_NpcFestiveLightPos[MAX_BOSSES][3];
static float g_NpcFestiveLightAng[MAX_BOSSES][3];

static float g_NpcFieldOfView[MAX_BOSSES] = { 0.0, ... };
static float g_NpcTurnRate[MAX_BOSSES] = { 0.0, ... };
static float g_NpcBackstabFOV[MAX_BOSSES] = { 0.0, ... };

static bool g_NpcHasTeleportAllowed[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportTimeMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportTimeMax[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportRestPeriod[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportStressMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportStressMax[MAX_BOSSES][Difficulty_Max];
static float g_NpcTeleportPersistencyPeriod[MAX_BOSSES][Difficulty_Max];

static float g_NpcJumpscareDistance[MAX_BOSSES][Difficulty_Max];
static float g_NpcJumpscareDuration[MAX_BOSSES][Difficulty_Max];
static float g_NpcJumpscareCooldown[MAX_BOSSES][Difficulty_Max];
static bool g_NpcHasJumpscareOnScare[MAX_BOSSES];
bool g_NpcIgnoreNonMarkedForChase[MAX_BOSSES];

g_SlenderEnt[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_NpcSpeed[MAX_BOSSES][Difficulty_Max];
static float g_NpcMaxSpeed[MAX_BOSSES][Difficulty_Max];
static float g_NpcAddSpeed[MAX_BOSSES];
static float g_NpcAddMaxSpeed[MAX_BOSSES];
static float g_NpcAddAcceleration[MAX_BOSSES];
static float g_NpcIdleLifetime[MAX_BOSSES][Difficulty_Max];

static float g_NpcScareRadius[MAX_BOSSES];
static float g_NpcScareCooldown[MAX_BOSSES];

static bool g_NpcHasPlayerScareSpeedBoost[MAX_BOSSES];
static float g_NpcPlayerSpeedBoostDuration[MAX_BOSSES];

static bool g_NpcHasPlayerScareReaction[MAX_BOSSES];
static int g_NpcPlayerScareReactionType[MAX_BOSSES];

static bool g_NpcHasPlayerScareReplenishSprint[MAX_BOSSES];
static int g_NpcPlayerScareReplenishSprintAmount[MAX_BOSSES];

static int g_NpcTeleportType[MAX_BOSSES] = { -1, ... };

static float g_NpcSearchRadius[MAX_BOSSES][Difficulty_Max];
static float g_NpcHearingRadius[MAX_BOSSES][Difficulty_Max];
static float g_NpcTauntAlertRange[MAX_BOSSES][Difficulty_Max];
static float g_NpcInstantKillRadius[MAX_BOSSES] = { 0.0, ... };
static float g_NpcInstantKillCooldown[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasDeathCamEnabled[MAX_BOSSES] = { false, ... };

static bool g_NpcHasProxyWeaponsEnabled[MAX_BOSSES] = { false, ... };

static bool g_NpcHasHealthbarEnabled[MAX_BOSSES] = { false, ... };

static int g_NpcEnemy[MAX_BOSSES] = { INVALID_ENT_REFERENCE, ... };

static float g_NpcProxySpawnChanceMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcProxySpawnChanceMax[MAX_BOSSES][Difficulty_Max];
static float g_NpcProxySpawnChanceThreshold[MAX_BOSSES][Difficulty_Max];
static int g_NpcProxySpawnNumMin[MAX_BOSSES][Difficulty_Max];
static int g_NpcProxySpawnNumMax[MAX_BOSSES][Difficulty_Max];
static float g_NpcProxySpawnCooldownMin[MAX_BOSSES][Difficulty_Max];
static float g_NpcProxySpawnCooldownMax[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasIgnoreNavPrefer[MAX_BOSSES];

static int g_NpcDeathMessageDifficultyIndexes[MAX_BOSSES];

static bool g_NpcHasDrainCreditsState[MAX_BOSSES];
static int g_NpcDrainCreditAmount[MAX_BOSSES][Difficulty_Max];

static bool g_NpcHasProxySpawnEffectEnabled[MAX_BOSSES];
static float g_NpcProxySpawnEffectZOffset[MAX_BOSSES];

Handle timerMusic = null;//Planning to add a bosses array on.

float g_LastStuckTime[MAX_BOSSES] = {-1.0, ...};
bool g_NpcHasCloaked[MAX_BOSSES] = { false, ... };
bool g_NpcUsedRage1[MAX_BOSSES] = { false, ... };
bool g_NpcUsedRage2[MAX_BOSSES] = { false, ... };
bool g_NpcHasUsedRage3[MAX_BOSSES] = { false, ... };
bool g_NpcUsesRageAnimation1[MAX_BOSSES] = { false, ... };
bool g_NpcUsesRageAnimation2[MAX_BOSSES] = { false, ... };
bool g_NpcUsesRageAnimation3[MAX_BOSSES] = { false, ... };

stock bool NPCGetBossName(int npcIndex = -1, char[] buffer,int bufferLen, char profile[SF2_MAX_PROFILE_NAME_LENGTH] = "")
{
	if (npcIndex == -1 && profile[0] == '\0')
	{
		return false;
	}
	int difficulty = g_DifficultyConVar.IntValue;
	if (npcIndex != -1)
	{
		switch (difficulty)
		{
			case Difficulty_Normal:
			{
				strcopy(buffer, bufferLen, g_NpcName[npcIndex][1]);
			}
			case Difficulty_Hard:
			{
				strcopy(buffer, bufferLen, g_NpcName[npcIndex][2]);
			}
			case Difficulty_Insane:
			{
				strcopy(buffer, bufferLen, g_NpcName[npcIndex][3]);
			}
			case Difficulty_Nightmare:
			{
				strcopy(buffer, bufferLen, g_NpcName[npcIndex][4]);
			}
			case Difficulty_Apollyon:
			{
				strcopy(buffer, bufferLen, g_NpcName[npcIndex][5]);
			}
		}
	}
	else
	{
		ArrayList arrayNames;
		arrayNames = GetBossProfileNames(profile);
		switch (difficulty)
		{
			case Difficulty_Normal:
			{
				arrayNames.GetString(Difficulty_Normal, buffer, bufferLen);
			}
			case Difficulty_Hard:
			{
				arrayNames.GetString(Difficulty_Hard, buffer, bufferLen);
			}
			case Difficulty_Insane:
			{
				arrayNames.GetString(Difficulty_Insane, buffer, bufferLen);
			}
			case Difficulty_Nightmare:
			{
				arrayNames.GetString(Difficulty_Nightmare, buffer, bufferLen);
			}
			case Difficulty_Apollyon:
			{
				arrayNames.GetString(Difficulty_Apollyon, buffer, bufferLen);
			}
		}
		arrayNames = null;
	}
	return true;
}

bool NPCHasProxyWeapons(int npcIndex)
{
	return g_NpcHasProxyWeaponsEnabled[npcIndex];
}

bool NPCHasDeathCamEnabled(int npcIndex)
{
	return g_NpcHasDeathCamEnabled[npcIndex];
}

void NPCSetDeathCamEnabled(int npcIndex, bool state)
{
	g_NpcHasDeathCamEnabled[npcIndex] = state;
}

void NPCInitialize()
{
	NPCChaserInitialize();
}

void NPCOnConfigsExecuted()
{
	g_NpcGlobalUniqueID = 0;
}

bool NPCIsValid(int npcIndex)
{
	return view_as<bool>(npcIndex >= 0 && npcIndex < MAX_BOSSES && NPCGetUniqueID(npcIndex) != -1);
}

int NPCGetUniqueID(int npcIndex)
{
	return g_NpcUniqueID[npcIndex];
}

int NPCGetFromUniqueID(int iNPCUniqueID)
{
	if (iNPCUniqueID == -1)
	{
		return -1;
	}

	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == iNPCUniqueID)
		{
			return i;
		}
	}

	return -1;
}

int NPCGetEntRef(int npcIndex)
{
	return g_SlenderEnt[npcIndex];
}

int NPCGetEntIndex(int npcIndex)
{
	return EntRefToEntIndex(NPCGetEntRef(npcIndex));
}

int NPCGetFromEntIndex(int entity)
{
	if (!entity || !IsValidEntity(entity))
	{
		return -1;
	}

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
	int count;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		if (NPCGetFlags(i) & SFF_FAKE)
		{
			continue;
		}

		count++;
	}

	return count;
}

int NPCGetProfileIndex(int npcIndex)
{
	return g_NpcProfileIndex[npcIndex];
}

int NPCGetUniqueProfileIndex(int npcIndex)
{
	return g_NpcUniqueProfileIndex[npcIndex];
}

bool NPCGetProfile(int npcIndex, char[] buffer,int bufferLen)
{
	strcopy(buffer, bufferLen, g_SlenderProfile[npcIndex]);
	return true;
}

void NPCSetProfile(int npcIndex, const char[] profile)
{
	strcopy(g_SlenderProfile[npcIndex], sizeof(g_SlenderProfile[]), profile);
}

void NPCRemove(int npcIndex)
{
	if (!NPCIsValid(npcIndex))
	{
		return;
	}

	RemoveProfile(npcIndex);
}
void NPCStopMusic()
{
	//Stop the music timer
	if (timerMusic != null)
	{
		delete timerMusic;
	}
	//Stop the music for all players.
	for(int i = 1;i<=MaxClients;i++)
	{
		if (IsValidClient(i))
		{
			if (currentMusicTrack[0] != '\0')
			{
				StopSound(i, MUSIC_CHAN, currentMusicTrack);
			}
			ClientUpdateMusicSystem(i);
		}
	}
}
void CheckIfMusicValid()
{
	int difficulty = g_DifficultyConVar.IntValue;
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (NPCGetUniqueID(i) == -1)
		{
			continue;
		}
		if (g_NpcAllowMusicOnDifficulty[i] & difficulty)
		{
			currentMusicTrackNormal[0] = '\0';
			currentMusicTrackHard[0] = '\0';
			currentMusicTrackInsane[0] = '\0';
			currentMusicTrackNightmare[0] = '\0';
			currentMusicTrackApollyon[0] = '\0';
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(i, profile, sizeof(profile));
			for(int client = 1;client <=MaxClients;client ++)
			{
				if (IsValidClient(client) && (!g_PlayerEliminated[client] || IsClientInGhostMode(client)))
				{
					SF2BossProfileSoundInfo soundInfo;
					GetBossProfileMusicSounds(profile, soundInfo, 1);
					ArrayList soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNormal, sizeof(currentMusicTrackNormal));
					}
					soundList = null;

					GetBossProfileMusicSounds(profile, soundInfo, 2);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackHard, sizeof(currentMusicTrackHard));
					}
					if (currentMusicTrackHard[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 1);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackHard, sizeof(currentMusicTrackHard));
						}
					}
					soundList = null;

					GetBossProfileMusicSounds(profile, soundInfo, 3);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
					}
					if (currentMusicTrackInsane[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 2);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
						}
						if (currentMusicTrackInsane[0] == '\0')
						{
							GetBossProfileMusicSounds(profile, soundInfo, 1);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
							}
						}
					}
					soundList = null;

					GetBossProfileMusicSounds(profile, soundInfo, 4);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
					}
					if (currentMusicTrackNightmare[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 3);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
						}
						if (currentMusicTrackNightmare[0] == '\0')
						{
							GetBossProfileMusicSounds(profile, soundInfo, 2);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
							}
							if (currentMusicTrackNightmare[0] == '\0')
							{
								GetBossProfileMusicSounds(profile, soundInfo, 1);
								soundList = soundInfo.Paths;
								if (soundList != null && soundList.Length > 0)
								{
									soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
								}
							}
						}
					}
					soundList = null;

					GetBossProfileMusicSounds(profile, soundInfo, 5);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
					}
					if (currentMusicTrackApollyon[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 4);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
						}
						if (currentMusicTrackApollyon[0] == '\0')
						{
							GetBossProfileMusicSounds(profile, soundInfo, 3);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
							}
							if (currentMusicTrackApollyon[0] == '\0')
							{
								GetBossProfileMusicSounds(profile, soundInfo, 2);
								soundList = soundInfo.Paths;
								if (soundList != null && soundList.Length > 0)
								{
									soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
								}
								if (currentMusicTrackApollyon[0] == '\0')
								{
									GetBossProfileMusicSounds(profile, soundInfo, 1);
									soundList = soundInfo.Paths;
									if (soundList != null && soundList.Length > 0)
									{
										soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
									}
								}
							}
						}
					}
					soundList = null;

					switch (g_DifficultyConVar.IntValue)
					{
						case Difficulty_Normal, Difficulty_Easy:
						{
							strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNormal);
						}
						case Difficulty_Hard:
						{
							strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackHard);
						}
						case Difficulty_Insane:
						{
							strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackInsane);
						}
						case Difficulty_Nightmare:
						{
							strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNightmare);
						}
						case Difficulty_Apollyon:
						{
							strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackApollyon);
						}
					}
					if (currentMusicTrack[0] != '\0')
					{
						timerMusic = CreateTimer(NPCGetSoundMusicLoop(i, difficulty),BossMusic,i,TIMER_FLAG_NO_MAPCHANGE);
						StopSound(client, MUSIC_CHAN, currentMusicTrack);
						ClientChaseMusicReset(client);
						ClientChaseMusicSeeReset(client);
						ClientAlertMusicReset(client);
						ClientIdleMusicReset(client);
						GetChaserProfileChaseMusics(profile, soundInfo);
						soundInfo.StopAllSounds(client);
						GetChaserProfileChaseVisibleMusics(profile, soundInfo);
						soundInfo.StopAllSounds(client);
						GetChaserProfileAlertMusics(profile, soundInfo);
						soundInfo.StopAllSounds(client);
						GetChaserProfileIdleMusics(profile, soundInfo);
						soundInfo.StopAllSounds(client);
						if (g_PlayerMusicString[client][0] != '\0')
						{
							EmitSoundToClient(client, g_PlayerMusicString[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.0001);
						}
						ClientMusicStart(client, currentMusicTrack, _, MUSIC_PAGE_VOLUME,true);
						ClientUpdateMusicSystem(client);
						break;
					}
					else
					{

					}
				}
			}
			break;
		}
		else
		{

		}
	}
}
stock bool MusicActive()
{
	if (timerMusic!=null)
	{
		return true;
	}
	return false;
}
stock bool BossHasMusic(char[] profile)
{
	int difficulty = g_DifficultyConVar.IntValue;
	char temp[512];
	ArrayList soundList;
	SF2BossProfileSoundInfo soundInfo;
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 1);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
			}
			if (temp[0] != '\0')
			{
				return true;
			}
		}
		case Difficulty_Hard:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 2);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
			}
			if (temp[0] != '\0')
			{
				return true;
			}
			else
			{
				GetBossProfileMusicSounds(profile, soundInfo, 1);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
				}
				if (temp[0] != '\0')
				{
					return true;
				}
			}
		}
		case Difficulty_Insane:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 3);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
			}
			if (temp[0] != '\0')
			{
				return true;
			}
			else
			{
				GetBossProfileMusicSounds(profile, soundInfo, 2);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
				}
				if (temp[0] != '\0')
				{
					return true;
				}
				else
				{
					GetBossProfileMusicSounds(profile, soundInfo, 1);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
					}
					if (temp[0] != '\0')
					{
						return true;
					}
				}
			}
		}
		case Difficulty_Nightmare:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 4);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
			}
			if (temp[0] != '\0')
			{
				return true;
			}
			else
			{
				GetBossProfileMusicSounds(profile, soundInfo, 3);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
				}
				if (temp[0] != '\0')
				{
					return true;
				}
				else
				{
					GetBossProfileMusicSounds(profile, soundInfo, 2);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
					}
					if (temp[0] != '\0')
					{
						return true;
					}
					else
					{
						GetBossProfileMusicSounds(profile, soundInfo, 1);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
						}
						if (temp[0] != '\0')
						{
							return true;
						}
					}
				}
			}
		}
		case Difficulty_Apollyon:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 5);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
			}
			if (temp[0] != '\0')
			{
				return true;
			}
			else
			{
				GetBossProfileMusicSounds(profile, soundInfo, 4);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
				}
				if (temp[0] != '\0')
				{
					return true;
				}
				else
				{
					GetBossProfileMusicSounds(profile, soundInfo, 3);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
					}
					if (temp[0] != '\0')
					{
						return true;
					}
					else
					{
						GetBossProfileMusicSounds(profile, soundInfo, 2);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
						}
						if (temp[0] != '\0')
						{
							return true;
						}
						else
						{
							GetBossProfileMusicSounds(profile, soundInfo, 1);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), temp, sizeof(temp));
							}
							if (temp[0] != '\0')
							{
								return true;
							}
						}
					}
				}
			}
		}
	}
	return false;
}
stock bool BossMatchesCurrentMusic(char[] profile)
{
	if (!IsProfileValid(profile))
	{
		return false;
	}

	char buffer[PLATFORM_MAX_PATH], currentMusic[PLATFORM_MAX_PATH];
	int difficulty = g_DifficultyConVar.IntValue;

	GetBossMusic(currentMusic, sizeof(currentMusic));

	ArrayList soundList;
	SF2BossProfileSoundInfo soundInfo;
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			GetBossProfileMusicSounds(profile, soundInfo, 1);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				for (int i = 0; i < soundList.Length; i++)
				{
					soundList.GetString(i, buffer, sizeof(buffer));
					if (strcmp(buffer, currentMusic, false) == 0)
					{
						return true;
					}
				}
			}
		}
		case Difficulty_Hard:
		{
			for (int section = 1; section <= Difficulty_Hard; section++)
			{
				GetBossProfileMusicSounds(profile, soundInfo, section);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					for (int i = 0; i < soundList.Length; i++)
					{
						soundList.GetString(i, buffer, sizeof(buffer));
						if (strcmp(buffer, currentMusic, false) == 0)
						{
							return true;
						}
					}
				}
			}
		}
		case Difficulty_Insane:
		{
			for (int section = 1; section <= Difficulty_Insane; section++)
			{
				GetBossProfileMusicSounds(profile, soundInfo, section);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					for (int i = 0; i < soundList.Length; i++)
					{
						soundList.GetString(i, buffer, sizeof(buffer));
						if (strcmp(buffer, currentMusic, false) == 0)
						{
							return true;
						}
					}
				}
			}
		}
		case Difficulty_Nightmare:
		{
			for (int section = 1; section <= Difficulty_Nightmare; section++)
			{
				GetBossProfileMusicSounds(profile, soundInfo, section);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					for (int i = 0; i < soundList.Length; i++)
					{
						soundList.GetString(i, buffer, sizeof(buffer));
						if (strcmp(buffer, currentMusic, false) == 0)
						{
							return true;
						}
					}
				}
			}
		}
		case Difficulty_Apollyon:
		{
			for (int section = 1; section <= Difficulty_Apollyon; section++)
			{
				GetBossProfileMusicSounds(profile, soundInfo, section);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					for (int i = 0; i < soundList.Length; i++)
					{
						soundList.GetString(i, buffer, sizeof(buffer));
						if (strcmp(buffer, currentMusic, false) == 0)
						{
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}
stock void GetBossMusic(char[] buffer,int bufferLen)
{
	int difficulty = g_DifficultyConVar.IntValue;
	switch (difficulty)
	{
		case Difficulty_Normal:
		{
			strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNormal);
			strcopy(buffer,bufferLen,currentMusicTrackNormal);
		}
		case Difficulty_Hard:
		{
			strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackHard);
			strcopy(buffer,bufferLen,currentMusicTrackHard);
		}
		case Difficulty_Insane:
		{
			strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackInsane);
			strcopy(buffer,bufferLen,currentMusicTrackInsane);
		}
		case Difficulty_Nightmare:
		{
			strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNightmare);
			strcopy(buffer,bufferLen,currentMusicTrackNightmare);
		}
		case Difficulty_Apollyon:
		{
			strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackApollyon);
			strcopy(buffer,bufferLen,currentMusicTrackApollyon);
		}
	}
}
static Action BossMusic(Handle timer,any bossIndex)
{
	int difficulty = g_DifficultyConVar.IntValue;
	float time = NPCGetSoundMusicLoop(bossIndex, difficulty);
	if (time > 0.0 && (g_NpcAllowMusicOnDifficulty[bossIndex] & difficulty))
	{
		if (bossIndex > -1)
		{
			char profile[SF2_MAX_PROFILE_NAME_LENGTH];
			NPCGetProfile(bossIndex, profile, sizeof(profile));
			for(int i = 1;i<=MaxClients;i++)
			{
				if (IsValidClient(i) && currentMusicTrack[0] != '\0')
				{
					StopSound(i, MUSIC_CHAN, currentMusicTrack);
				}
			}
			timerMusic = CreateTimer(time,BossMusic,bossIndex,TIMER_FLAG_NO_MAPCHANGE);
			return Plugin_Continue;
		}
		NPCStopMusic();
	}
	timerMusic = null;
	return Plugin_Continue;
}
void NPCRemoveAll()
{
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		NPCRemove(i);
	}
}

int NPCGetType(int npcIndex)
{
	return g_NpcType[npcIndex];
}

int NPCGetFlags(int npcIndex)
{
	return g_NpcFlags[npcIndex];
}

void NPCSetFlags(int npcIndex,int flags)
{
	g_NpcFlags[npcIndex] = flags;
}

float NPCGetSoundMusicLoop(int npcIndex, int difficulty)
{
	return g_NpcSoundMusicLoop[npcIndex][difficulty];
}

float NPCGetModelScale(int npcIndex)
{
	return g_NpcModelScale[npcIndex];
}

int NPCGetModelSkin(int npcIndex)
{
	return g_NpcModelSkin[npcIndex];
}

int NPCGetModelSkinDifficulty(int npcIndex, int difficulty)
{
	return g_NpcModelSkinDifficulty[npcIndex][difficulty];
}

int NPCGetModelSkinMax(int npcIndex)
{
	return g_NpcModelSkinMax[npcIndex];
}

int NPCGetModelBodyGroups(int npcIndex)
{
	return g_NpcModelBodyGroups[npcIndex];
}

int NPCGetModelBodyGroupsDifficulty(int npcIndex, int difficulty)
{
	return g_NpcModelBodyGroupsDifficulty[npcIndex][difficulty];
}

int NPCGetModelBodyGroupsMax(int npcIndex)
{
	return g_NpcModelBodyGroupsMax[npcIndex];
}

int NPCGetRaidHitbox(int npcIndex)
{
	return g_NpcRaidHitbox[npcIndex];
}

float NPCGetBlinkLookRate(int npcIndex)
{
	return g_NpcBlinkLookRate[npcIndex];
}

float NPCGetBlinkStaticRate(int npcIndex)
{
	return g_NpcBlinkStaticRate[npcIndex];
}

bool NPCGetDiscoModeState(int npcIndex)
{
	return g_NpcHasDiscoMode[npcIndex];
}

float NPCGetDiscoModeRadiusMin(int npcIndex)
{
	return g_NpcDiscoRadiusMin[npcIndex];
}

float NPCGetDiscoModeRadiusMax(int npcIndex)
{
	return g_NpcDiscoRadiusMax[npcIndex];
}

float[] NPCGetDiscoModePos(int npcIndex)
{
	return g_NpcDiscoModePos[npcIndex];
}

bool NPCGetFestiveLightState(int npcIndex)
{
	return g_NpcHasFestiveLights[npcIndex];
}

int NPCGetFestiveLightBrightness(int npcIndex)
{
	return g_NpcFestiveLightBrightness[npcIndex];
}

float NPCGetFestiveLightDistance(int npcIndex)
{
	return g_NpcFestiveLightDistance[npcIndex];
}

float NPCGetFestiveLightRadius(int npcIndex)
{
	return g_NpcFestiveLightRadius[npcIndex];
}

float[] NPCGetFestiveLightPosition(int npcIndex)
{
	return g_NpcFestiveLightPos[npcIndex];
}

float[] NPCGetFestiveLightAngle(int npcIndex)
{
	return g_NpcFestiveLightAng[npcIndex];
}

bool NPCGetCustomOutlinesState(int npcIndex)
{
	return g_SlenderUseCustomOutlines[npcIndex];
}

int NPCGetOutlineColorR(int npcIndex)
{
	return g_SlenderOutlineColorR[npcIndex];
}

int NPCGetOutlineColorG(int npcIndex)
{
	return g_SlenderOutlineColorG[npcIndex];
}

int NPCGetOutlineColorB(int npcIndex)
{
	return g_SlenderOutlineColorB[npcIndex];
}

int NPCGetOutlineTransparency(int npcIndex)
{
	return g_SlenderOutlineTransparency[npcIndex];
}

bool NPCGetRainbowOutlineState(int npcIndex)
{
	return g_SlenderUseRainbowOutline[npcIndex];
}

float NPCGetRainbowOutlineCycleRate(int npcIndex)
{
	return g_SlenderRainbowCycleRate[npcIndex];
}

float NPCGetSpeed(int npcIndex,int difficulty)
{
	return g_NpcSpeed[npcIndex][difficulty];
}

float NPCGetMaxSpeed(int npcIndex,int difficulty)
{
	return g_NpcMaxSpeed[npcIndex][difficulty];
}

float NPCGetAcceleration(int npcIndex,int difficulty)
{
	return g_SlenderAcceleration[npcIndex][difficulty];
}

void NPCSetAddSpeed(int npcIndex, float amount)
{
	g_NpcAddSpeed[npcIndex] += amount;
}

void NPCSetAddMaxSpeed(int npcIndex, float amount)
{
	g_NpcAddMaxSpeed[npcIndex] += amount;
}

void NPCSetAddAcceleration(int npcIndex, float amount)
{
	g_NpcAddAcceleration[npcIndex] += amount;
}

float NPCGetAddSpeed(int npcIndex)
{
	return g_NpcAddSpeed[npcIndex];
}

float NPCGetAddMaxSpeed(int npcIndex)
{
	return g_NpcAddMaxSpeed[npcIndex];
}

float NPCGetAddAcceleration(int npcIndex)
{
	return g_NpcAddAcceleration[npcIndex];
}

bool NPCIsTeleportAllowed(int npcIndex, int difficulty)
{
	return g_NpcHasTeleportAllowed[npcIndex][difficulty];
}

float NPCGetTeleportTimeMin(int npcIndex, int difficulty)
{
	return g_NpcTeleportTimeMin[npcIndex][difficulty];
}

float NPCGetTeleportTimeMax(int npcIndex, int difficulty)
{
	return g_NpcTeleportTimeMax[npcIndex][difficulty];
}

float NPCGetTeleportRestPeriod(int npcIndex, int difficulty)
{
	return g_NpcTeleportRestPeriod[npcIndex][difficulty];
}

float NPCGetTeleportStressMin(int npcIndex, int difficulty)
{
	return g_NpcTeleportStressMin[npcIndex][difficulty];
}

float NPCGetTeleportStressMax(int npcIndex, int difficulty)
{
	return g_NpcTeleportStressMax[npcIndex][difficulty];
}

float NPCGetTeleportPersistencyPeriod(int npcIndex, int difficulty)
{
	return g_NpcTeleportPersistencyPeriod[npcIndex][difficulty];
}

void NPCSetTeleporter(int bossIndex, int teleporterNumber, int entity)
{
	g_NpcTeleporters[bossIndex][teleporterNumber] = entity;
}

int NPCGetTeleporter(int bossIndex, int teleporterNumber)
{
	return g_NpcTeleporters[bossIndex][teleporterNumber];
}

float NPCGetJumpscareDistance(int npcIndex, int difficulty)
{
	return g_NpcJumpscareDistance[npcIndex][difficulty];
}

float NPCGetJumpscareDuration(int npcIndex, int difficulty)
{
	return g_NpcJumpscareDuration[npcIndex][difficulty];
}

float NPCGetJumpscareCooldown(int npcIndex, int difficulty)
{
	return g_NpcJumpscareCooldown[npcIndex][difficulty];
}

bool NPCGetJumpscareOnScare(int npcIndex)
{
	return g_NpcHasJumpscareOnScare[npcIndex];
}

float NPCGetTurnRate(int npcIndex)
{
	return g_NpcTurnRate[npcIndex];
}

float NPCGetFOV(int npcIndex)
{
	return g_NpcFieldOfView[npcIndex];
}

float NPCGetBackstabFOV(int npcIndex)
{
	return g_NpcBackstabFOV[npcIndex];
}

float NPCGetIdleLifetime(int npcIndex,int difficulty)
{
	return g_NpcIdleLifetime[npcIndex][difficulty];
}

void NPCGetEyePositionOffset(int npcIndex, float buffer[3])
{
	buffer[0] = g_SlenderEyePosOffset[npcIndex][0];
	buffer[1] = g_SlenderEyePosOffset[npcIndex][1];
	buffer[2] = g_SlenderEyePosOffset[npcIndex][2];
}

float NPCGetSearchRadius(int npcIndex, int difficulty)
{
	return g_NpcSearchRadius[npcIndex][difficulty];
}

float NPCGetHearingRadius(int npcIndex, int difficulty)
{
	return g_NpcHearingRadius[npcIndex][difficulty];
}

float NPCGetTauntAlertRange(int npcIndex, int difficulty)
{
	return g_NpcTauntAlertRange[npcIndex][difficulty];
}

float NPCGetScareRadius(int npcIndex)
{
	return g_NpcScareRadius[npcIndex];
}

float NPCGetScareCooldown(int npcIndex)
{
	return g_NpcScareCooldown[npcIndex];
}

bool NPCGetSpeedBoostOnScare(int npcIndex)
{
	return g_NpcHasPlayerScareSpeedBoost[npcIndex];
}

float NPCGetScareSpeedBoostDuration(int npcIndex)
{
	return g_NpcPlayerSpeedBoostDuration[npcIndex];
}

bool NPCGetScareReactionState(int npcIndex)
{
	return g_NpcHasPlayerScareReaction[npcIndex];
}

int NPCGetScareReactionType(int npcIndex)
{
	return g_NpcPlayerScareReactionType[npcIndex];
}

bool NPCGetScareReplenishSprintState(int npcIndex)
{
	return g_NpcHasPlayerScareReplenishSprint[npcIndex];
}

int NPCGetScareReplenishSprintAmount(int npcIndex)
{
	return g_NpcPlayerScareReplenishSprintAmount[npcIndex];
}

float NPCGetInstantKillRadius(int npcIndex)
{
	return g_NpcInstantKillRadius[npcIndex];
}

float NPCGetInstantKillCooldown(int npcIndex, int difficulty)
{
	return g_NpcInstantKillCooldown[npcIndex][difficulty];
}

int NPCGetTeleportType(int npcIndex)
{
	return g_NpcTeleportType[npcIndex];
}

bool NPCGetHealthbarState(int npcIndex)
{
	return g_NpcHasHealthbarEnabled[npcIndex];
}

bool NPCGetFakeCopyState(int npcIndex)
{
	return g_NpcHasFakeCopiesEnabled[npcIndex];
}

#if defined _store_included
bool NPCGetDrainCreditState(int npcIndex)
{
	return g_NpcHasDrainCreditsState[npcIndex];
}

int NPCGetDrainCreditAmount(int npcIndex, int difficulty)
{
	return g_NpcDrainCreditAmount[npcIndex][difficulty];
}
#endif

bool NPCGetProxySpawnEffectState(int npcIndex)
{
	return g_NpcHasProxySpawnEffectEnabled[npcIndex];
}

float NPCGetProxySpawnEffectZOffset(int npcIndex)
{
	return g_NpcProxySpawnEffectZOffset[npcIndex];
}

float NPCGetProxySpawnChanceMin(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnChanceMin[npcIndex][difficulty];
}

float NPCGetProxySpawnChanceMax(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnChanceMax[npcIndex][difficulty];
}

float NPCGetProxySpawnChanceThreshold(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnChanceThreshold[npcIndex][difficulty];
}

int NPCGetProxySpawnNumMin(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnNumMin[npcIndex][difficulty];
}

int NPCGetProxySpawnNumMax(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnNumMax[npcIndex][difficulty];
}

float NPCGetProxySpawnCooldownMin(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnCooldownMin[npcIndex][difficulty];
}

float NPCGetProxySpawnCooldownMax(int npcIndex, int difficulty)
{
	return g_NpcProxySpawnCooldownMax[npcIndex][difficulty];
}

bool NPCShouldSeeEntity(int npcIndex, int entity)
{
	if (!IsValidEntity(entity))
	{
		return false;
	}

	Action result = Plugin_Continue;
	Call_StartForward(g_OnBossSeeEntityFwd);
	Call_PushCell(npcIndex);
	Call_PushCell(entity);
	Call_Finish(result);

	if (result != Plugin_Continue)
	{
		return false;
	}

	return true;
}

bool NPCShouldHearEntity(int npcIndex, int entity, SoundType soundType)
{
	if (!IsValidEntity(entity))
	{
		return false;
	}

	Action result = Plugin_Continue;
	Call_StartForward(g_OnBossHearEntityFwd);
	Call_PushCell(npcIndex);
	Call_PushCell(entity);
	Call_PushCell(soundType);
	Call_Finish(result);

	if (result != Plugin_Continue)
	{
		return false;
	}

	return true;
}

bool NPCAreAvailablePlayersAlive()
{
	int number = 0;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == TFTeam_Red && !g_PlayerEliminated[i] && !DidClientEscape(i))
		{
			number++;
		}
	}
	return number >= 1;
}

/**
 *	Returns the boss's eye position (eye pos offset + absorigin).
 */
bool NPCGetEyePosition(int npcIndex, float buffer[3], const float defaultValue[3]={ 0.0, 0.0, 0.0 })
{
	buffer[0] = defaultValue[0];
	buffer[1] = defaultValue[1];
	buffer[2] = defaultValue[2];

	if (!NPCIsValid(npcIndex))
	{
		return false;
	}

	int npcEnt = NPCGetEntIndex(npcIndex);
	if (!npcEnt || npcEnt == INVALID_ENT_REFERENCE)
	{
		return false;
	}

	// @TODO: Replace SlenderGetAbsOrigin with GetEntPropVector
	float pos[3], eyePosOffset[3];
	SlenderGetAbsOrigin(npcIndex, pos);
	NPCGetEyePositionOffset(npcIndex, eyePosOffset);

	AddVectors(pos, eyePosOffset, buffer);
	return true;
}

bool NPCHasAttribute(int npcIndex, int attribute)
{
	if (NPCGetUniqueID(npcIndex) == -1)
	{
		return false;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, profile, sizeof(profile));

	SF2BossProfileAttributesInfo attributesInfo;
	GetBossProfileAttributesInfo(profile, attributesInfo);

	bool returnValue = false;
	if (attributesInfo.Value[attribute] >= 0.0)
	{
		returnValue = true;
	}

	return returnValue;
}

float NPCGetAttributeValue(int npcIndex, int attribute)
{
	if (!NPCHasAttribute(npcIndex, attribute))
	{
		return 0.0;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(npcIndex, profile, sizeof(profile));

	SF2BossProfileAttributesInfo attributesInfo;
	GetBossProfileAttributesInfo(profile, attributesInfo);

	return attributesInfo.Value[attribute];
}

bool SlenderCanRemove(int bossIndex)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return false;
	}

	if (PeopleCanSeeSlender(bossIndex, _, false))
	{
		return false;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	int teleportType = NPCGetTeleportType(bossIndex);

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	switch (teleportType)
	{
		case 0:
		{
			if (NPCGetFlags(bossIndex) & SFF_STATICONRADIUS)
			{
				float slenderPos[3], buffer[3];
				SlenderGetAbsOrigin(bossIndex, slenderPos);

				for (int i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) ||
						!IsPlayerAlive(i) ||
						g_PlayerEliminated[i] ||
						IsClientInGhostMode(i) ||
						IsClientInDeathCam(i))
					{
						continue;
					}

					if (!IsPointVisibleToPlayer(i, slenderPos, false, false))
					{
						continue;
					}

					GetClientAbsOrigin(i, buffer);
					if (GetVectorSquareMagnitude(buffer, slenderPos) <= SquareFloat(g_SlenderStaticRadius[bossIndex][difficulty]))
					{
						return false;
					}
				}
			}
		}
		case 1:
		{
			if (PeopleCanSeeSlender(bossIndex, _, SlenderUsesBlink(bossIndex)) || PeopleCanSeeSlender(bossIndex, false, false))
			{
				return false;
			}
		}
		case 2:
		{
			int state = g_SlenderState[bossIndex];
			if (state != STATE_ALERT && state != STATE_CHASE && state != STATE_ATTACK && state != STATE_STUN)
			{
				if (GetGameTime() < g_SlenderTimeUntilKill[bossIndex])
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

bool SlenderGetAbsOrigin(int bossIndex, float buffer[3], const float defaultValue[3]={ 0.0, 0.0, 0.0 })
{
	for (int i = 0; i < 3; i++)
	{
		buffer[i] = defaultValue[i];
	}

	if (bossIndex < 0 || NPCGetUniqueID(bossIndex) == -1)
	{
		return false;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return false;
	}

	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", buffer);

	return true;
}

bool SlenderGetEyePosition(int bossIndex, float buffer[3], const float defaultValue[3]={ 0.0, 0.0, 0.0 })
{
	return NPCGetEyePosition(bossIndex, buffer, defaultValue);
}

bool SelectProfile(SF2NPC_BaseNPC Npc, const char[] profile,int additionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool spawnCompanions=true, bool playSpawnSound=true, bool invincible = false)
{
	if (!IsProfileValid(profile))
	{
		if (!NpcCopyMaster.IsValid())
		{
			LogSF2Message("Could not select profile for boss %d: profile %s is invalid!", Npc.Index, profile);
			return false;
		}
		/*else//Wait my copy master is valid but not my profil wut????
		{
			char sNewProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			NpcCopyMaster.GetProfile(sNewProfile,sizeof(sNewProfile));
			//Add me again
			SelectProfile(Npc, sNewProfile, additionalBossFlags, NpcCopyMaster, spawnCompanions, playSpawnSound);
		}*/
	}
	Npc.Remove();

	Npc.SetProfile(profile);

	int bossType = GetBossProfileType(profile);

	g_NpcUniqueID[Npc.Index] = g_NpcGlobalUniqueID++;
	g_NpcType[Npc.Index] = bossType;

	g_NpcModelScale[Npc.Index] = GetBossProfileModelScale(profile);

	g_NpcModelSkin[Npc.Index] = GetBossProfileSkin(profile);

	g_NpcModelSkinMax[Npc.Index] = GetBossProfileSkinMax(profile);

	g_NpcModelBodyGroups[Npc.Index] = GetBossProfileBodyGroups(profile);

	g_NpcModelBodyGroupsMax[Npc.Index] = GetBossProfileBodyGroupsMax(profile);

	g_NpcRaidHitbox[Npc.Index] = GetBossProfileRaidHitbox(profile);

	g_NpcHasIgnoreNavPrefer[Npc.Index] = GetBossProfileIgnoreNavPrefer(profile);

	g_NpcHasFakeCopiesEnabled[Npc.Index] = GetBossProfileFakeCopies(profile);

	g_NpcBlinkLookRate[Npc.Index] = GetBossProfileBlinkLookRate(profile);
	g_NpcBlinkStaticRate[Npc.Index] = GetBossProfileBlinkStaticRate(profile);

	g_NpcStepSize[Npc.Index] = GetBossProfileStepSize(profile);

	g_NpcHasDiscoMode[Npc.Index] = GetBossProfileDiscoModeState(profile);
	g_NpcDiscoRadiusMin[Npc.Index] = GetBossProfileDiscoRadiusMin(profile);
	g_NpcDiscoRadiusMax[Npc.Index] = GetBossProfileDiscoRadiusMax(profile);

	g_NpcHasFestiveLights[Npc.Index] = GetBossProfileFestiveLightState(profile);
	g_NpcFestiveLightBrightness[Npc.Index] = GetBossProfileFestiveLightBrightness(profile);
	g_NpcFestiveLightDistance[Npc.Index] = GetBossProfileFestiveLightDistance(profile);
	g_NpcFestiveLightRadius[Npc.Index] = GetBossProfileFestiveLightRadius(profile);
	GetBossProfileDiscoPosition(profile, g_NpcDiscoModePos[Npc.Index]);
	GetBossProfileFestiveLightPosition(profile, g_NpcFestiveLightPos[Npc.Index]);
	GetBossProfileFestiveLightAngles(profile, g_NpcFestiveLightAng[Npc.Index]);

	g_SlenderUseCustomOutlines[Npc.Index] = GetBossProfileCustomOutlinesState(profile);
	g_SlenderOutlineColorR[Npc.Index] = GetBossProfileOutlineColorR(profile);
	g_SlenderOutlineColorG[Npc.Index] = GetBossProfileOutlineColorG(profile);
	g_SlenderOutlineColorB[Npc.Index] = GetBossProfileOutlineColorB(profile);
	g_SlenderOutlineTransparency[Npc.Index] = GetBossProfileOutlineTransparency(profile);
	g_SlenderUseRainbowOutline[Npc.Index] = GetBossProfileRainbowOutlineState(profile);
	g_SlenderRainbowCycleRate[Npc.Index] = GetBossProfileRainbowCycleRate(profile);

	g_NpcHasProxyWeaponsEnabled[Npc.Index] = GetBossProfileProxyWeapons(profile);

	g_NpcHasDrainCreditsState[Npc.Index] = GetBossProfileDrainCreditState(profile);
	g_NpcHasProxySpawnEffectEnabled[Npc.Index] = GetBossProfileProxySpawnEffectState(profile);
	g_NpcProxySpawnEffectZOffset[Npc.Index] = GetBossProfileProxySpawnEffectZOffset(profile);

	if (SF_IsSlaughterRunMap())
	{
		NPCSetFlags(Npc.Index, GetBossProfileFlags(profile) | additionalBossFlags | SFF_NOTELEPORT);
	}
	else
	{
		NPCSetFlags(Npc.Index, GetBossProfileFlags(profile) | additionalBossFlags);
	}

	GetBossProfileEyePositionOffset(profile, g_SlenderEyePosOffset[Npc.Index]);
	GetBossProfileEyeAngleOffset(profile, g_SlenderEyeAngOffset[Npc.Index]);

	GetBossProfileHullMins(profile, g_SlenderDetectMins[Npc.Index]);
	GetBossProfileHullMaxs(profile, g_SlenderDetectMaxs[Npc.Index]);

	GetBossProfileRenderColor(profile, g_SlenderRenderColor[Npc.Index]);

	g_SlenderRenderFX[Npc.Index] = GetBossProfileRenderFX(profile);
	g_SlenderRenderMode[Npc.Index] = GetBossProfileRenderMode(profile);

	g_SlenderCopyMaster[Npc.Index] = -1;
	g_SlenderCompanionMaster[Npc.Index] = -1;

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcSoundMusicLoop[Npc.Index][difficulty] = GetBossProfileSoundMusicLoop(profile, difficulty);
		g_NpcSpeed[Npc.Index][difficulty] = GetBossProfileSpeed(profile, difficulty);
		g_NpcMaxSpeed[Npc.Index][difficulty] = GetBossProfileMaxSpeed(profile, difficulty);
		g_SlenderAcceleration[Npc.Index][difficulty] = GetBossProfileAcceleration(profile, difficulty);
		g_NpcIdleLifetime[Npc.Index][difficulty] = GetBossProfileIdleLifetime(profile, difficulty);
		g_SlenderStaticRadius[Npc.Index][difficulty] = GetBossProfileStaticRadius(profile, difficulty);
		g_SlenderStaticRate[Npc.Index][difficulty] = GetBossProfileStaticRate(profile, difficulty);
		g_SlenderStaticRateDecay[Npc.Index][difficulty] = GetBossProfileStaticRateDecay(profile, difficulty);
		g_SlenderStaticGraceTime[Npc.Index][difficulty] = GetBossProfileStaticGraceTime(profile, difficulty);
		g_NpcSearchRadius[Npc.Index][difficulty] = GetBossProfileSearchRadius(profile, difficulty);
		g_NpcHearingRadius[Npc.Index][difficulty] = GetBossProfileHearRadius(profile, difficulty);
		g_NpcTauntAlertRange[Npc.Index][difficulty] = GetBossProfileTauntAlertRange(profile, difficulty);
		g_SlenderTeleportMinRange[Npc.Index][difficulty] = GetBossProfileTeleportRangeMin(profile, difficulty);
		g_SlenderTeleportMaxRange[Npc.Index][difficulty] = GetBossProfileTeleportRangeMax(profile, difficulty);
		g_NpcHasTeleportAllowed[Npc.Index][difficulty] = GetBossProfileTeleportAllowed(profile, difficulty);
		g_NpcTeleportTimeMin[Npc.Index][difficulty] = GetBossProfileTeleportTimeMin(profile, difficulty);
		g_NpcTeleportTimeMax[Npc.Index][difficulty] = GetBossProfileTeleportTimeMax(profile, difficulty);
		g_NpcTeleportRestPeriod[Npc.Index][difficulty] = GetBossProfileTeleportTargetRestPeriod(profile, difficulty);
		g_NpcTeleportStressMin[Npc.Index][difficulty] = GetBossProfileTeleportTargetStressMin(profile, difficulty);
		g_NpcTeleportStressMax[Npc.Index][difficulty] = GetBossProfileTeleportTargetStressMax(profile, difficulty);
		g_NpcTeleportPersistencyPeriod[Npc.Index][difficulty] = GetBossProfileTeleportTargetPersistencyPeriod(profile, difficulty);
		g_NpcJumpscareDistance[Npc.Index][difficulty] = GetBossProfileJumpscareDistance(profile, difficulty);
		g_NpcJumpscareDuration[Npc.Index][difficulty] = GetBossProfileJumpscareDuration(profile, difficulty);
		g_NpcJumpscareCooldown[Npc.Index][difficulty] = GetBossProfileJumpscareCooldown(profile, difficulty);
		g_NpcModelSkinDifficulty[Npc.Index][difficulty] = GetBossProfileSkinDifficulty(profile, difficulty);
		g_NpcModelBodyGroupsDifficulty[Npc.Index][difficulty] = GetBossProfileBodyGroupsDifficulty(profile, difficulty);
		g_SlenderMaxCopies[Npc.Index][difficulty] = GetBossProfileMaxCopies(profile, difficulty);
		g_NpcInstantKillCooldown[Npc.Index][difficulty] = GetBossProfileInstantKillCooldown(profile, difficulty);

		g_SlenderProxyDamageVsEnemy[Npc.Index][difficulty] = GetBossProfileProxyDamageVsEnemy(profile, difficulty);
		g_SlenderProxyDamageVsBackstab[Npc.Index][difficulty] = GetBossProfileProxyDamageVsBackstab(profile, difficulty);
		g_SlenderProxyDamageVsSelf[Npc.Index][difficulty] = GetBossProfileProxyDamageVsSelf(profile, difficulty);
		g_SlenderProxyControlGainHitEnemy[Npc.Index][difficulty] = GetBossProfileProxyControlGainHitEnemy(profile, difficulty);
		g_SlenderProxyControlGainHitByEnemy[Npc.Index][difficulty] = GetBossProfileProxyControlGainHitByEnemy(profile, difficulty);
		g_SlenderProxyControlDrainRate[Npc.Index][difficulty] = GetBossProfileProxyControlDrainRate(profile, difficulty);
		g_SlenderMaxProxies[Npc.Index][difficulty] = GetBossProfileMaxProxies(profile, difficulty);
		g_NpcProxySpawnChanceMin[Npc.Index][difficulty] = GetBossProfileProxySpawnChanceMin(profile, difficulty);
		g_NpcProxySpawnChanceMax[Npc.Index][difficulty] = GetBossProfileProxySpawnChanceMax(profile, difficulty);
		g_NpcProxySpawnChanceThreshold[Npc.Index][difficulty] = GetBossProfileProxySpawnChanceThreshold(profile, difficulty);
		g_NpcProxySpawnNumMin[Npc.Index][difficulty] = GetBossProfileProxySpawnNumberMin(profile, difficulty);
		g_NpcProxySpawnNumMax[Npc.Index][difficulty] = GetBossProfileProxySpawnNumberMax(profile, difficulty);
		g_NpcProxySpawnCooldownMin[Npc.Index][difficulty] = GetBossProfileProxySpawnCooldownMin(profile, difficulty);
		g_NpcProxySpawnCooldownMax[Npc.Index][difficulty] = GetBossProfileProxySpawnCooldownMax(profile, difficulty);
		g_SlenderProxyTeleportMinRange[Npc.Index][difficulty] = GetBossProfileProxyTeleportRangeMin(profile, difficulty);
		g_SlenderProxyTeleportMaxRange[Npc.Index][difficulty] = GetBossProfileProxyTeleportRangeMax(profile, difficulty);
		g_NpcDrainCreditAmount[Npc.Index][difficulty] = GetBossProfileDrainCreditAmount(profile, difficulty);
	}

	ArrayList arrayNames;

	arrayNames = GetBossProfileNames(profile);
	arrayNames.GetString(Difficulty_Normal, g_NpcName[Npc.Index][1], sizeof(g_NpcName[][]));

	strcopy(g_NpcName[Npc.Index][0], sizeof(g_NpcName[][]), g_NpcName[Npc.Index][1]);

	arrayNames.GetString(Difficulty_Hard, g_NpcName[Npc.Index][2], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Insane, g_NpcName[Npc.Index][3], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Nightmare, g_NpcName[Npc.Index][4], sizeof(g_NpcName[][]));

	arrayNames.GetString(Difficulty_Apollyon, g_NpcName[Npc.Index][5], sizeof(g_NpcName[][]));

	arrayNames = null;

	g_NpcHasJumpscareOnScare[Npc.Index] = GetBossProfileJumpscareOnScare(profile);

	g_NpcTurnRate[Npc.Index] = GetBossProfileTurnRate(profile);
	if (!SF_IsSlaughterRunMap())
	{
		g_NpcFieldOfView[Npc.Index] = GetBossProfileFOV(profile);
	}
	else
	{
		g_NpcFieldOfView[Npc.Index] = 360.0;
	}
	g_NpcBackstabFOV[Npc.Index] = 180.0;

	g_NpcScareRadius[Npc.Index] = GetBossProfileScareRadius(profile);
	g_NpcScareCooldown[Npc.Index] = GetBossProfileScareCooldown(profile);

	g_NpcHasPlayerScareSpeedBoost[Npc.Index] = GetBossProfileSpeedBoostOnScare(profile);
	g_NpcPlayerSpeedBoostDuration[Npc.Index] = GetBossProfileScareSpeedBoostDuration(profile);

	g_NpcHasPlayerScareReaction[Npc.Index] = GetBossProfileScareReactionState(profile);
	g_NpcPlayerScareReactionType[Npc.Index] = GetBossProfileScareReactionType(profile);

	g_NpcHasPlayerScareReplenishSprint[Npc.Index] = GetBossProfileScareReplenishState(profile);
	g_NpcPlayerScareReplenishSprintAmount[Npc.Index] = GetBossProfileScareReplenishAmount(profile);

	g_NpcInstantKillRadius[Npc.Index] = GetBossProfileInstantKillRadius(profile);

	g_NpcTeleportType[Npc.Index] = GetBossProfileTeleportType(profile);

	g_SlenderTeleportIgnoreChases[Npc.Index] = GetBossProfileTeleportIgnoreChases(profile);

	g_SlenderTeleportIgnoreVis[Npc.Index] = GetBossProfileTeleportIgnoreVis(profile);

	g_NpcHasHealthbarEnabled[Npc.Index] = GetBossProfileHealthbarState(profile);

	g_SlenderProxiesAllowNormalVoices[Npc.Index] = GetBossProfileProxyAllowNormalVoices(profile);

	g_NpcDeathMessageDifficultyIndexes[Npc.Index] = GetBossProfileChatDeathMessageDifficultyIndexes(profile);

	g_NpcAddSpeed[Npc.Index] = 0.0;
	g_NpcAddMaxSpeed[Npc.Index] = 0.0;
	g_NpcAddAcceleration[Npc.Index] = 0.0;

	g_NpcEnemy[Npc.Index] = INVALID_ENT_REFERENCE;

	g_NpcPlayerScareVictin[Npc.Index] = INVALID_ENT_REFERENCE;
	g_NpcChasingScareVictin[Npc.Index] = false;
	g_NpcLostChasingScareVictim[Npc.Index] = false;

	// Deathcam values.
	Npc.DeathCamEnabled = GetBossProfileDeathCamState(profile);
	g_SlenderDeathCamScareSound[Npc.Index] = GetBossProfileDeathCamScareSound(profile);
	g_SlenderPublicDeathCam[Npc.Index] = GetBossProfilePublicDeathCamState(profile);
	g_SlenderPublicDeathCamSpeed[Npc.Index] = GetBossProfilePublicDeathCamSpeed(profile);
	g_SlenderPublicDeathCamAcceleration[Npc.Index] = GetBossProfilePublicDeathCamAcceleration(profile);
	g_SlenderPublicDeathCamDeceleration[Npc.Index] = GetBossProfilePublicDeathCamDeceleration(profile);
	g_SlenderPublicDeathCamBackwardOffset[Npc.Index] = GetBossProfilePublicDeathCamBackwardOffset(profile);
	g_SlenderPublicDeathCamDownwardOffset[Npc.Index] = GetBossProfilePublicDeathCamDownwardOffset(profile);
	g_SlenderDeathCamOverlay[Npc.Index] = GetBossProfileDeathCamOverlayState(profile);
	g_SlenderDeathCamOverlayTimeStart[Npc.Index] = GetBossProfileDeathCamOverlayStartTime(profile);
	g_SlenderDeathCamTime[Npc.Index] = GetBossProfileDeathCamTime(profile);

	g_SlenderFakeTimer[Npc.Index] = null;
	g_SlenderEntityThink[Npc.Index] = null;
	g_SlenderAttackTimer[Npc.Index] = null;
	g_SlenderLaserTimer[Npc.Index] = null;
	g_SlenderBackupAtkTimer[Npc.Index] = null;
	g_SlenderChaseInitialTimer[Npc.Index] = null;
	g_SlenderRage1Timer[Npc.Index] = null;
	g_SlenderRage2Timer[Npc.Index] = null;
	g_SlenderRage3Timer[Npc.Index] = null;
	g_SlenderHealTimer[Npc.Index] = null;
	g_SlenderHealDelayTimer[Npc.Index] = null;
	g_SlenderHealEventTimer[Npc.Index] = null;
	g_SlenderStartFleeTimer[Npc.Index] = null;
	g_SlenderSpawnTimer[Npc.Index] = null;
	g_SlenderDeathCamTimer[Npc.Index] = null;
	g_SlenderDeathCamTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderNextTeleportTime[Npc.Index] = 0.0;
	g_SlenderLastKill[Npc.Index] = 0.0;
	g_SlenderTimeUntilKill[Npc.Index] = -1.0;
	g_SlenderNextJumpScare[Npc.Index] = -1.0;
	g_SlenderNextStunTime[Npc.Index] = -1.0;
	g_SlenderNextCloakTime[Npc.Index] = -1.0;
	g_NpcHasCloaked[Npc.Index] = false;
	g_NpcUsedRage1[Npc.Index] = false;
	g_NpcUsedRage2[Npc.Index] = false;
	g_NpcHasUsedRage3[Npc.Index] = false;
	g_SlenderTimeUntilNextProxy[Npc.Index] = -1.0;
	g_NpcVelocityCancel[Npc.Index] = false;
	g_SlenderBurnTimer[Npc.Index] = null;
	g_SlenderBleedTimer[Npc.Index] = null;
	g_SlenderMarkedTimer[Npc.Index] = null;
	g_SlenderStopBurningTimer[Npc.Index] = 0.0;
	g_SlenderStopBleedingTimer[Npc.Index] = 0.0;
	g_SlenderIsBurning[Npc.Index] = false;
	g_SlenderIsMarked[Npc.Index] = false;
	g_SlenderSoundTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderSeeTarget[Npc.Index] = INVALID_ENT_REFERENCE;

	g_SlenderHasBurnKillEffect[Npc.Index] = GetBossProfileBurnRagdoll(profile);
	g_SlenderHasCloakKillEffect[Npc.Index] = GetBossProfileCloakRagdoll(profile);
	g_SlenderHasDecapKillEffect[Npc.Index] = GetBossProfileDecapRagdoll(profile);
	g_SlenderHasGibKillEffect[Npc.Index] = GetBossProfileGibRagdoll(profile);
	g_SlenderHasGoldKillEffect[Npc.Index] = GetBossProfileGoldRagdoll(profile);
	g_SlenderHasIceKillEffect[Npc.Index] = GetBossProfileIceRagdoll(profile);
	g_SlenderHasElectrocuteKillEffect[Npc.Index] = GetBossProfileElectrocuteRagdoll(profile);
	g_SlenderHasAshKillEffect[Npc.Index] = GetBossProfileAshRagdoll(profile);
	g_SlenderHasDeleteKillEffect[Npc.Index] = GetBossProfileDeleteRagdoll(profile);
	g_SlenderHasPushRagdollOnKill[Npc.Index] = GetBossProfilePushRagdoll(profile);

	g_SlenderHasDissolveRagdollOnKill[Npc.Index] = GetBossProfileDissolveRagdoll(profile);
	g_SlenderDissolveRagdollType[Npc.Index] = GetBossProfileDissolveRagdollType(profile);

	g_SlenderHasPlasmaRagdollOnKill[Npc.Index] = GetBossProfilePlasmaRagdoll(profile);

	g_SlenderHasResizeRagdollOnKill[Npc.Index] = GetBossProfileResizeRagdoll(profile);
	g_SlenderResizeRagdollHands[Npc.Index] = GetBossProfileResizeRagdollHands(profile);
	g_SlenderResizeRagdollHead[Npc.Index] = GetBossProfileResizeRagdollHead(profile);
	g_SlenderResizeRagdollTorso[Npc.Index] = GetBossProfileResizeRagdollTorso(profile);

	g_SlenderHasDecapOrGibKillEffect[Npc.Index] = GetBossProfileDecapOrGibRagdoll(profile);
	g_SlenderHasMultiKillEffect[Npc.Index] = GetBossProfileMultieffectRagdoll(profile);

	g_SlenderHasSilentKill[Npc.Index] = GetBossProfileSilentKill(profile);

	g_SlenderPlayerCustomDeathFlag[Npc.Index] = GetBossProfileCustomDeathFlag(profile);
	g_SlenderPlayerSetDeathFlag[Npc.Index] = GetBossProfileCustomDeathFlagType(profile);

	g_SlenderCustomOutroSong[Npc.Index] = GetBossProfileOutroMusicState(profile);

	for (int i = 1; i <= MaxClients; i++)
	{
		g_PlayerLastChaseBossEncounterTime[i][Npc.Index] = -1.0;
		g_SlenderTeleportPlayersRestTime[Npc.Index][i] = -1.0;
	}

	g_SlenderTeleportTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderProxyTarget[Npc.Index] = INVALID_ENT_REFERENCE;
	g_SlenderTeleportMaxTargetStress[Npc.Index] = 9999.0;
	g_SlenderTeleportMaxTargetTime[Npc.Index] = -1.0;
	g_SlenderNextTeleportTime[Npc.Index] = -1.0;
	g_SlenderTeleportTargetTime[Npc.Index] = -1.0;

	g_SlenderAddCompanionsOnDifficulty[Npc.Index] = false;

	GetBossProfileCloakOnSound(profile, g_SlenderCloakOnSound[Npc.Index], sizeof(g_SlenderCloakOnSound[]));
	GetBossProfileCloakOffSound(profile, g_SlenderCloakOffSound[Npc.Index], sizeof(g_SlenderCloakOffSound[]));
	GetBossProfileRocketShootSound(profile, g_SlenderRocketShootSound[Npc.Index], sizeof(g_SlenderRocketShootSound[]));
	GetBossProfileRocketModel(profile, g_SlenderRocketModel[Npc.Index], sizeof(g_SlenderRocketModel[]));
	GetBossProfileSentryRocketShootSound(profile, g_SlenderSentryRocketShootSound[Npc.Index], sizeof(g_SlenderSentryRocketShootSound[]));
	GetBossProfileFireballShootSound(profile, g_SlenderFireballShootSound[Npc.Index], sizeof(g_SlenderFireballShootSound[]));
	GetBossProfileRocketExplodeSound(profile, g_SlenderRocketExplodeSound[Npc.Index], sizeof(g_SlenderRocketExplodeSound[]));
	GetBossProfileFireballTrail(profile, g_SlenderFireballTrail[Npc.Index], sizeof(g_SlenderFireballTrail[]));
	GetBossProfileRocketTrail(profile, g_SlenderRocketTrailParticle[Npc.Index], sizeof(g_SlenderRocketTrailParticle[]));
	GetBossProfileRocketExplodeParticle(profile, g_SlenderRocketExplodeParticle[Npc.Index], sizeof(g_SlenderRocketExplodeParticle[]));
	GetBossProfileFireballExplodeSound(profile, g_SlenderFireballExplodeSound[Npc.Index], sizeof(g_SlenderFireballExplodeSound[]));
	GetBossProfileIceballSlowSound(profile, g_SlenderIceballImpactSound[Npc.Index], sizeof(g_SlenderIceballImpactSound[]));
	GetBossProfileIceballTrail(profile, g_SlenderIceballTrail[Npc.Index], sizeof(g_SlenderIceballTrail));
	GetBossProfileGrenadeShootSound(profile, g_SlenderGrenadeShootSound[Npc.Index], sizeof(g_SlenderGrenadeShootSound[]));
	GetBossProfileArrowShootSound(profile, g_SlenderArrowShootSound[Npc.Index], sizeof(g_SlenderArrowShootSound[]));
	GetBossProfileManglerShootSound(profile, g_SlenderManglerShootSound[Npc.Index], sizeof(g_SlenderManglerShootSound[]));
	GetBossProfileBaseballShootSound(profile, g_SlenderBaseballShootSound[Npc.Index], sizeof(g_SlenderBaseballShootSound[]));
	GetBossProfileJarateHitSound(profile, g_SlenderJarateHitSound[Npc.Index], sizeof(g_SlenderJarateHitSound[]));
	GetBossProfileMilkHitSound(profile, g_SlenderMilkHitSound[Npc.Index], sizeof(g_SlenderMilkHitSound[]));
	GetBossProfileGasHitSound(profile, g_SlenderGasHitSound[Npc.Index], sizeof(g_SlenderGasHitSound[]));
	GetBossProfileStunHitSound(profile, g_SlenderStunHitSound[Npc.Index], sizeof(g_SlenderStunHitSound[]));
	GetBossProfileEngineSound(profile, g_SlenderEngineSound[Npc.Index], sizeof(g_SlenderEngineSound[]));
	GetBossProfileShockwaveBeamSprite(profile, g_SlenderShockwaveBeamSprite[Npc.Index], sizeof(g_SlenderShockwaveBeamSprite[]));
	GetBossProfileShockwaveHaloSprite(profile, g_SlenderShockwaveHaloSprite[Npc.Index], sizeof(g_SlenderShockwaveHaloSprite[]));
	GetBossProfileSmiteHitSound(profile, g_SlenderSmiteSound[Npc.Index], sizeof(g_SlenderSmiteSound[]));
	GetBossProfileTrapModel(profile, g_SlenderTrapModel[Npc.Index], sizeof(g_SlenderTrapModel[]));
	GetBossProfileTrapDeploySound(profile, g_SlenderTrapDeploySound[Npc.Index], sizeof(g_SlenderTrapDeploySound[]));
	GetBossProfileTrapMissSound(profile, g_SlenderTrapMissSound[Npc.Index], sizeof(g_SlenderTrapMissSound[]));
	GetBossProfileTrapCatchSound(profile, g_SlenderTrapHitSound[Npc.Index], sizeof(g_SlenderTrapHitSound[]));
	GetBossProfileTrapAnimIdle(profile, g_SlenderTrapAnimIdle[Npc.Index], sizeof(g_SlenderTrapAnimIdle[]));
	GetBossProfileTrapAnimClose(profile, g_SlenderTrapAnimClose[Npc.Index], sizeof(g_SlenderTrapAnimClose[]));
	GetBossProfileTrapAnimOpen(profile, g_SlenderTrapAnimOpen[Npc.Index], sizeof(g_SlenderTrapAnimOpen[]));

	g_SlenderThink[Npc.Index] = CreateTimer(0.3, Timer_SlenderTeleportThink, Npc, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	SlenderRemoveTargetMemory(Npc.Index);

	switch (bossType)
	{
		case SF2BossType_Chaser:
		{
			NPCChaserOnSelectProfile(Npc.Index, invincible);

			SlenderCreateTargetMemory(Npc.Index);
		}
		case SF2BossType_Statue:
		{
			NPCStatueOnSelectProfile(profile, Npc.Index);
		}
	}

	if (NpcCopyMaster.IsValid())
	{
		g_SlenderCopyMaster[Npc.Index] = NpcCopyMaster.Index;
		g_SlenderNextJumpScare[Npc.Index] = g_SlenderNextJumpScare[NpcCopyMaster.Index];
	}
	else
	{
		if (playSpawnSound)
		{
			char buffer[PLATFORM_MAX_PATH];
			ArrayList soundList;
			SF2BossProfileSoundInfo soundInfo;
			GetBossProfileIntroSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
			if (soundList != null && soundList.Length > 0)
			{
				soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
			}
			soundList = null;
			if (buffer[0] != '\0')
			{
				EmitSoundToAll(buffer, _, SNDCHAN_STATIC, SNDLEVEL_HELICOPTER);
			}
		}
		if (timerMusic==null)
		{
			bool allowMusic = false;
			float time;
			for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
			{
				if (g_NpcSoundMusicLoop[Npc.Index][difficulty] > 0.0)
				{
					allowMusic = true;
					g_NpcAllowMusicOnDifficulty[Npc.Index] |= difficulty;
				}
			}
			if (allowMusic)
			{
				time = g_NpcSoundMusicLoop[Npc.Index][g_DifficultyConVar.IntValue];
				currentMusicTrackNormal[0] = '\0';
				currentMusicTrackHard[0] = '\0';
				currentMusicTrackInsane[0] = '\0';
				currentMusicTrackNightmare[0] = '\0';
				currentMusicTrackApollyon[0] = '\0';
				ArrayList soundList;
				SF2BossProfileSoundInfo soundInfo;
				GetBossProfileMusicSounds(profile, soundInfo, 1);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNormal, sizeof(currentMusicTrackNormal));
				}
				soundList = null;

				GetBossProfileMusicSounds(profile, soundInfo, 2);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackHard, sizeof(currentMusicTrackHard));
				}
				if (currentMusicTrackHard[0] == '\0')
				{
					GetBossProfileMusicSounds(profile, soundInfo, 1);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackHard, sizeof(currentMusicTrackHard));
					}
				}
				soundList = null;

				GetBossProfileMusicSounds(profile, soundInfo, 3);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
				}
				if (currentMusicTrackInsane[0] == '\0')
				{
					GetBossProfileMusicSounds(profile, soundInfo, 2);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
					}
					if (currentMusicTrackInsane[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 1);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackInsane, sizeof(currentMusicTrackInsane));
						}
					}
				}
				soundList = null;

				GetBossProfileMusicSounds(profile, soundInfo, 4);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
				}
				if (currentMusicTrackNightmare[0] == '\0')
				{
					GetBossProfileMusicSounds(profile, soundInfo, 3);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
					}
					if (currentMusicTrackNightmare[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 2);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
						}
						if (currentMusicTrackNightmare[0] == '\0')
						{
							GetBossProfileMusicSounds(profile, soundInfo, 1);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackNightmare, sizeof(currentMusicTrackNightmare));
							}
						}
					}
				}
				soundList = null;

				GetBossProfileMusicSounds(profile, soundInfo, 5);
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
				}
				if (currentMusicTrackApollyon[0] == '\0')
				{
					GetBossProfileMusicSounds(profile, soundInfo, 4);
					soundList = soundInfo.Paths;
					if (soundList != null && soundList.Length > 0)
					{
						soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
					}
					if (currentMusicTrackApollyon[0] == '\0')
					{
						GetBossProfileMusicSounds(profile, soundInfo, 3);
						soundList = soundInfo.Paths;
						if (soundList != null && soundList.Length > 0)
						{
							soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
						}
						if (currentMusicTrackApollyon[0] == '\0')
						{
							GetBossProfileMusicSounds(profile, soundInfo, 2);
							soundList = soundInfo.Paths;
							if (soundList != null && soundList.Length > 0)
							{
								soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
							}
							if (currentMusicTrackApollyon[0] == '\0')
							{
								GetBossProfileMusicSounds(profile, soundInfo, 1);
								soundList = soundInfo.Paths;
								if (soundList != null && soundList.Length > 0)
								{
									soundList.GetString(GetRandomInt(0, soundList.Length - 1), currentMusicTrackApollyon, sizeof(currentMusicTrackApollyon));
								}
							}
						}
					}
				}
				soundList = null;

				if ((g_NpcAllowMusicOnDifficulty[Npc.Index] & g_DifficultyConVar.IntValue) && time > 0.0)
				{
					timerMusic = CreateTimer(time,BossMusic,Npc.Index,TIMER_FLAG_NO_MAPCHANGE);
					for(int client = 1; client <=MaxClients; client++)
					{
						if (IsValidClient(client) && (!g_PlayerEliminated[client] || IsClientInGhostMode(client)))
						{
							ClientChaseMusicReset(client);
							ClientChaseMusicSeeReset(client);
							ClientAlertMusicReset(client);
							ClientIdleMusicReset(client);
							GetChaserProfileChaseMusics(profile, soundInfo);
							soundInfo.StopAllSounds(client);
							GetChaserProfileChaseVisibleMusics(profile, soundInfo);
							soundInfo.StopAllSounds(client);
							GetChaserProfileAlertMusics(profile, soundInfo);
							soundInfo.StopAllSounds(client);
							GetChaserProfileIdleMusics(profile, soundInfo);
							soundInfo.StopAllSounds(client);
							if (g_PlayerMusicString[client][0] != '\0')
							{
								EmitSoundToClient(client, g_PlayerMusicString[client], _, MUSIC_CHAN, SNDLEVEL_NONE, SND_CHANGEVOL, 0.0001);
							}
							switch (g_DifficultyConVar.IntValue)
							{
								case Difficulty_Normal, Difficulty_Easy:
								{
									strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNormal);
								}
								case Difficulty_Hard:
								{
									strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackHard);
								}
								case Difficulty_Insane:
								{
									strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackInsane);
								}
								case Difficulty_Nightmare:
								{
									strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackNightmare);
								}
								case Difficulty_Apollyon:
								{
									strcopy(currentMusicTrack,sizeof(currentMusicTrack),currentMusicTrackApollyon);
								}
							}
							if (currentMusicTrack[0] != '\0')
							{
								StopSound(client, MUSIC_CHAN, currentMusicTrack);
							}
							ClientMusicStart(client, currentMusicTrack, _, MUSIC_PAGE_VOLUME,true);
							ClientUpdateMusicSystem(client);
						}
					}
				}
			}
		}
		if (spawnCompanions)
		{
			char compProfile[SF2_MAX_PROFILE_NAME_LENGTH];
			ArrayList companions = GetBossProfileCompanions(profile);
			if (companions != null)
			{
				char spawnType[64];
				GetBossProfileCompanionsSpawnType(profile, spawnType, sizeof(spawnType));
				if (spawnType[0] == '\0') // No random companions
				{
					SF2BossProfileCompanionsInfo companionInfo;
					companions.GetArray(0, companionInfo);
					if (companionInfo.Bosses != null && companionInfo.Bosses.Length > 0)
					{
						for (int i = 0, size = companionInfo.Bosses.Length; i < size; i++)
						{
							companionInfo.Bosses.GetString(i, compProfile, sizeof(compProfile));
							if (IsProfileValid(compProfile))
							{
								SF2NPC_BaseNPC NpcCompanion = AddProfile(compProfile, _, _, false, false);
								if (NpcCompanion.IsValid())
								{
									g_SlenderCompanionMaster[NpcCompanion.Index] = Npc.Index;
								}
							}
							else
							{
								LogSF2Message("Companion boss profile %s is invalid, skipping boss...", compProfile);
							}
						}
					}
				}
				else
				{
					if (StrContains(spawnType, "on_difficulty_change", false) != -1)
					{
						g_SlenderAddCompanionsOnDifficulty[Npc.Index] = true;
					}
					if (StrContains(spawnType, "on_spawn", false) != -1)
					{
						Npc.AddCompanions();
					}
				}
			}

			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_ARRAYLIST, 0, "Array list %b has been deleted for companions..", companions);
			#endif
		}
	}

	Call_StartForward(g_OnBossAddedFwd);
	Call_PushCell(Npc.Index);
	Call_Finish();

	if (g_SlenderCopyMaster[Npc.Index] == -1)
	{
		LogSF2Message("Boss profile %s has been added to the game.", profile);
	}

	return true;
}
//SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC) <= Bug?
SF2NPC_BaseNPC AddProfile(const char[] strName,int additionalBossFlags=0,SF2NPC_BaseNPC NpcCopyMaster=view_as<SF2NPC_BaseNPC>(SF2_INVALID_NPC), bool spawnCompanions=true, bool playSpawnSound=true, bool invincible = false)
{
	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape)
	{
		return SF2_INVALID_NPC; // Stop spawning bosses before all pages are picked up in Renevant.
	}
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		SF2NPC_BaseNPC Npc = SF2NPC_BaseNPC(i);
		if (!Npc.IsValid())
		{
			if (SelectProfile(Npc, strName, additionalBossFlags, NpcCopyMaster, spawnCompanions, playSpawnSound, invincible))
			{
				return Npc;
			}

			break;
		}
	}

	return SF2_INVALID_NPC;
}

void NPCAddCompanions(SF2NPC_BaseNPC Npc)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.GetProfile(profile, sizeof(profile));
	ArrayList companions = GetBossProfileCompanions(profile);
	if (companions == null)
	{
		return;
	}

	ArrayList companionsToAdd = new ArrayList(SF2_MAX_PROFILE_NAME_LENGTH);
	char compProfile[SF2_MAX_PROFILE_NAME_LENGTH];
	float maxWeight = 0.0;
	for (int i = 0; i < companions.Length; i++)
	{
		SF2BossProfileCompanionsInfo companionInfo;
		companions.GetArray(i, companionInfo, sizeof(companionInfo));
		maxWeight += companionInfo.Weight[GetLocalGlobalDifficulty(Npc.Index)];
	}
	float randomWeight = GetRandomFloat(0.0, maxWeight);

	for (int i = 0; i < companions.Length; i++)
	{
		SF2BossProfileCompanionsInfo companionInfo;
		companions.GetArray(i, companionInfo, sizeof(companionInfo));
		if (companionInfo.Bosses == null)
		{
			continue;
		}

		float weight = companionInfo.Weight[GetLocalGlobalDifficulty(Npc.Index)];
		if (weight <= 0.0)
		{
			continue;
		}

		randomWeight -= weight;
		if (randomWeight >= 0.0)
		{
			continue;
		}

		for (int i2 = 0; i2 < companionInfo.Bosses.Length; i2++)
		{
			companionInfo.Bosses.GetString(i2, compProfile, sizeof(compProfile));
			companionsToAdd.PushString(compProfile);
		}
		break;
	}

	for (int i = 0, size = companionsToAdd.Length; i < size; i++)
	{
		companionsToAdd.GetString(i, compProfile, sizeof(compProfile));
		if (IsProfileValid(compProfile))
		{
			SF2NPC_BaseNPC NpcCompanion = AddProfile(compProfile, _, _, false, false);
			if (NpcCompanion.IsValid())
			{
				g_SlenderCompanionMaster[NpcCompanion.Index] = Npc.Index;
			}
		}
		else
		{
			LogSF2Message("Companion boss profile %s is invalid, skipping boss...", compProfile);
		}
	}
	delete companionsToAdd;
}

stock bool GetSlenderModel(int bossIndex, int modelState = 0, char[] buffer, int bufferLen)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		return false;
	}
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	buffer[0] = '\0';

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));
	ArrayList modelsArray;
	switch (modelState)
	{
		case 0:
		{
			modelsArray = GetBossProfileModels(profile);
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					modelsArray.GetString(Difficulty_Normal, buffer, bufferLen);
				}
				case Difficulty_Hard:
				{
					modelsArray.GetString(Difficulty_Hard, buffer, bufferLen);
				}
				case Difficulty_Insane:
				{
					modelsArray.GetString(Difficulty_Insane, buffer, bufferLen);
				}
				case Difficulty_Nightmare:
				{
					modelsArray.GetString(Difficulty_Nightmare, buffer, bufferLen);
				}
				case Difficulty_Apollyon:
				{
					modelsArray.GetString(Difficulty_Apollyon, buffer, bufferLen);
				}
			}
		}
		case 1:
		{
			modelsArray = GetStatueProfileModelsAverageDist(profile);
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					modelsArray.GetString(Difficulty_Normal, buffer, bufferLen);
				}
				case Difficulty_Hard:
				{
					modelsArray.GetString(Difficulty_Hard, buffer, bufferLen);
				}
				case Difficulty_Insane:
				{
					modelsArray.GetString(Difficulty_Insane, buffer, bufferLen);
				}
				case Difficulty_Nightmare:
				{
					modelsArray.GetString(Difficulty_Nightmare, buffer, bufferLen);
				}
				case Difficulty_Apollyon:
				{
					modelsArray.GetString(Difficulty_Apollyon, buffer, bufferLen);
				}
			}
		}
		case 2:
		{
			modelsArray = GetStatueProfileModelsCloseDist(profile);
			switch (difficulty)
			{
				case Difficulty_Normal:
				{
					modelsArray.GetString(Difficulty_Normal, buffer, bufferLen);
				}
				case Difficulty_Hard:
				{
					modelsArray.GetString(Difficulty_Hard, buffer, bufferLen);
				}
				case Difficulty_Insane:
				{
					modelsArray.GetString(Difficulty_Insane, buffer, bufferLen);
				}
				case Difficulty_Nightmare:
				{
					modelsArray.GetString(Difficulty_Nightmare, buffer, bufferLen);
				}
				case Difficulty_Apollyon:
				{
					modelsArray.GetString(Difficulty_Apollyon, buffer, bufferLen);
				}
			}
		}
	}
	return true;
}

void ChangeAllSlenderModels()
{
	char buffer[PLATFORM_MAX_PATH];
	for (int npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
	{
		if (NPCGetUniqueID(npcIndex) == -1)
		{
			continue;
		}
		int difficulty = GetLocalGlobalDifficulty(npcIndex);
		int slender = NPCGetEntIndex(npcIndex);
		if (!IsValidEntity(slender))
		{
			continue;
		}
		char profile[SF2_MAX_PROFILE_NAME_LENGTH];
		NPCGetProfile(npcIndex, profile, sizeof(profile));
		GetSlenderModel(npcIndex, _, buffer, sizeof(buffer));
		SetEntityModel(slender, buffer);
		SetEntityModel(EntRefToEntIndex(g_NpcGlowEntity[npcIndex]), buffer);
		if (NPCGetModelSkinMax(npcIndex) > 0)
		{
			int randomSkin = GetRandomInt(0, NPCGetModelSkinMax(npcIndex));
			SetEntProp(slender, Prop_Send, "m_nSkin", randomSkin);
		}
		else
		{
			if (GetBossProfileSkinDifficultyState(profile))
			{
				SetEntProp(slender, Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(npcIndex, difficulty));
			}
			else
			{
				SetEntProp(slender, Prop_Send, "m_nSkin", NPCGetModelSkin(npcIndex));
			}
		}
		if (NPCGetModelBodyGroupsMax(npcIndex) > 0)
		{
			int randomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(npcIndex));
			SetEntProp(slender, Prop_Send, "m_nBody", randomBody);
		}
		else
		{
			if (GetBossProfileBodyGroupsDifficultyState(profile))
			{
				SetEntProp(slender, Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(npcIndex, difficulty));
			}
			else
			{
				SetEntProp(slender, Prop_Send, "m_nBody", NPCGetModelBodyGroups(npcIndex));
			}
		}
		if (NPCGetType(npcIndex) == SF2BossType_Chaser)
		{
			float tempHitboxMins[3];
			NPCChaserUpdateBossAnimation(npcIndex, slender, g_SlenderState[npcIndex]);
			if (NPCGetRaidHitbox(npcIndex) == 1)
			{
				CopyVector(g_SlenderDetectMins[npcIndex], tempHitboxMins);
				tempHitboxMins[2] = 10.0;
				SetEntPropVector(slender, Prop_Send, "m_vecMins", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxs", g_SlenderDetectMaxs[npcIndex]);

				SetEntPropVector(slender, Prop_Send, "m_vecMinsPreScaled", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxsPreScaled", g_SlenderDetectMaxs[npcIndex]);
			}
			else if (NPCGetRaidHitbox(npcIndex) == 0)
			{
				CopyVector(HULL_HUMAN_MINS, tempHitboxMins);
				tempHitboxMins[2] = 10.0;
				SetEntPropVector(slender, Prop_Send, "m_vecMins", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

				SetEntPropVector(slender, Prop_Send, "m_vecMinsPreScaled", tempHitboxMins);
				SetEntPropVector(slender, Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
			}
		}
	}
}

void RemoveProfile(int bossIndex)
{
	RemoveSlender(bossIndex);

	// Call our forward.
	Call_StartForward(g_OnBossRemovedFwd);
	Call_PushCell(bossIndex);
	Call_Finish();

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	NPCChaserOnRemoveProfile(bossIndex);

	// Remove all possible sounds, for emergencies.
	if (!MusicActive())
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsClientInGame(i))
			{
				continue;
			}

			// Remove chase music.
			if (g_PlayerChaseMusicMaster[i] == bossIndex)
			{
				ClientChaseMusicReset(i);
			}

			// Don't forget search theme
			if (g_PlayerAlertMusicMaster[i] == bossIndex)
			{
				ClientAlertMusicReset(i);
			}

			if (g_PlayerChaseMusicSeeMaster[i] == bossIndex)
			{
				ClientChaseMusicSeeReset(i);
			}

			if (g_PlayerIdleMusicMaster[i] == bossIndex)
			{
				ClientIdleMusicReset(i);
			}

			ClientUpdateMusicSystem(i);
		}
	}

	// Clean up on the clients.
	for (int i = 1; i <= MaxClients; i++)
	{
		g_SlenderLastFoundPlayer[bossIndex][i] = -1.0;
		g_PlayerLastChaseBossEncounterTime[i][bossIndex] = -1.0;
		g_SlenderTeleportPlayersRestTime[bossIndex][i] = -1.0;

		for (int i2 = 0; i2 < 3; i2++)
		{
			g_SlenderLastFoundPlayerPos[bossIndex][i][i2] = 0.0;
		}

		if (IsClientInGame(i))
		{
			if (NPCGetUniqueID(bossIndex) == g_PlayerStaticMaster[i])
			{
				g_PlayerStaticMaster[i] = -1;

				// No one is the static master.
				g_PlayerStaticTimer[i] = CreateTimer(g_PlayerStaticDecreaseRate[i],
					Timer_ClientDecreaseStatic,
					GetClientUserId(i),
					TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

				TriggerTimer(g_PlayerStaticTimer[i], true);
			}
		}
	}

	g_NpcTeleportType[bossIndex] = -1;
	g_SlenderTeleportTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderProxyTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderTeleportMaxTargetStress[bossIndex] = 9999.0;
	g_SlenderTeleportMaxTargetTime[bossIndex] = -1.0;
	g_SlenderNextTeleportTime[bossIndex] = -1.0;
	g_SlenderTeleportTargetTime[bossIndex] = -1.0;
	g_SlenderTimeUntilKill[bossIndex] = -1.0;
	g_NpcHasHealthbarEnabled[bossIndex] = false;

	// Remove all copies associated with me.
	for (int i = 0; i < MAX_BOSSES; i++)
	{
		if (i == bossIndex || NPCGetUniqueID(i) == -1)
		{
			continue;
		}

		if (g_SlenderCopyMaster[i] == bossIndex)
		{
			LogMessage("Removed boss index %d because it is a copy of boss index %d", i, bossIndex);
			NPCRemove(i);
		}
	}

	for (int difficulty = 0; difficulty < Difficulty_Max; difficulty++)
	{
		g_NpcSearchRadius[bossIndex][difficulty] = 0.0;
		g_NpcHearingRadius[bossIndex][difficulty] = 0.0;
		g_NpcTauntAlertRange[bossIndex][difficulty] = 0.0;
		g_NpcInstantKillCooldown[bossIndex][difficulty] = 0.0;
		g_SlenderProxyTeleportMinRange[bossIndex][difficulty] = 0.0;
		g_SlenderProxyTeleportMaxRange[bossIndex][difficulty] = 0.0;
	}

	NPCSetProfile(bossIndex, "");
	g_NpcType[bossIndex] = -1;
	g_NpcProfileIndex[bossIndex] = -1;
	g_NpcUniqueProfileIndex[bossIndex] = -1;

	NPCSetFlags(bossIndex, 0);

	g_NpcFieldOfView[bossIndex] = 0.0;
	g_NpcBackstabFOV[bossIndex] = 0.0;

	g_NpcAddSpeed[bossIndex] = 0.0;
	g_NpcAddMaxSpeed[bossIndex] = 0.0;
	g_NpcAddAcceleration[bossIndex] = 0.0;
	g_NpcStepSize[bossIndex] = 0.0;

	g_NpcHasDiscoMode[bossIndex] = false;
	g_NpcDiscoRadiusMin[bossIndex] = 0.0;
	g_NpcDiscoRadiusMax[bossIndex] = 0.0;

	g_NpcHasFestiveLights[bossIndex] = false;
	g_NpcFestiveLightBrightness[bossIndex] = 0;
	g_NpcFestiveLightDistance[bossIndex] = 0.0;
	g_NpcFestiveLightRadius[bossIndex] = 0.0;

	g_NpcEnemy[bossIndex] = INVALID_ENT_REFERENCE;

	NPCSetDeathCamEnabled(bossIndex, false);

	g_SlenderCopyMaster[bossIndex] = -1;
	g_SlenderCompanionMaster[bossIndex] = -1;
	g_NpcUniqueID[bossIndex] = -1;
	g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderAttackTimer[bossIndex] = null;
	g_SlenderLaserTimer[bossIndex] = null;
	g_SlenderBackupAtkTimer[bossIndex] = null;
	g_SlenderChaseInitialTimer[bossIndex] = null;
	g_SlenderRage1Timer[bossIndex] = null;
	g_SlenderRage2Timer[bossIndex] = null;
	g_SlenderRage3Timer[bossIndex] = null;
	g_SlenderHealTimer[bossIndex] = null;
	g_SlenderHealDelayTimer[bossIndex] = null;
	g_SlenderHealEventTimer[bossIndex] = null;
	g_SlenderStartFleeTimer[bossIndex] = null;
	g_SlenderSpawnTimer[bossIndex] = null;
	g_SlenderDeathCamTimer[bossIndex] = null;
	g_SlenderDeathCamTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderThink[bossIndex] = null;
	g_SlenderEntityThink[bossIndex] = null;
	g_SlenderBurnTimer[bossIndex] = null;
	g_SlenderBleedTimer[bossIndex] = null;
	g_SlenderMarkedTimer[bossIndex] = null;
	g_SlenderStopBurningTimer[bossIndex] = 0.0;
	g_SlenderStopBleedingTimer[bossIndex] = 0.0;
	g_SlenderIsBurning[bossIndex] = false;
	g_SlenderIsMarked[bossIndex] = false;
	g_SlenderSoundTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderSeeTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderCustomOutroSong[bossIndex] = false;

	g_SlenderFakeTimer[bossIndex] = null;
	g_SlenderLastKill[bossIndex] = -1.0;
	g_SlenderState[bossIndex] = STATE_IDLE;
	g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderTargetIsVisible[bossIndex] = false;
	g_SlenderModel[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderBoxingBossIsKilled[bossIndex] = false;
	g_SlenderTimeUntilNextProxy[bossIndex] = -1.0;
	g_NpcInstantKillRadius[bossIndex] = 0.0;
	g_NpcScareRadius[bossIndex] = 0.0;
	g_NpcHasPlayerScareSpeedBoost[bossIndex] = false;
	g_NpcPlayerSpeedBoostDuration[bossIndex] = 0.0;
	g_NpcHasPlayerScareReaction[bossIndex] = false;
	g_NpcPlayerScareReactionType[bossIndex] = 0;
	g_NpcHasPlayerScareReplenishSprint[bossIndex] = false;
	g_NpcPlayerScareReplenishSprintAmount[bossIndex] = 0;
	g_NpcPlayerScareVictin[bossIndex] = INVALID_ENT_REFERENCE;
	g_NpcChasingScareVictin[bossIndex] = false;
	g_NpcLostChasingScareVictim[bossIndex] = false;
	g_NpcVelocityCancel[bossIndex] = false;
	g_SlenderRenderFX[bossIndex] = 0;
	g_SlenderRenderMode[bossIndex] = 0;

	for (int i = 0; i < 3; i++)
	{
		g_SlenderDetectMins[bossIndex][i] = 0.0;
		g_SlenderDetectMaxs[bossIndex][i] = 0.0;
		g_SlenderEyePosOffset[bossIndex][i] = 0.0;
		g_NpcDiscoModePos[bossIndex][i] = 0.0;
		g_NpcFestiveLightPos[bossIndex][i] = 0.0;
		g_NpcFestiveLightAng[bossIndex][i] = 0.0;
	}

	for (int i = 0; i < 4; i++)
	{
		g_SlenderRenderColor[bossIndex][i] = 0;
	}

	SlenderRemoveTargetMemory(bossIndex);
}

void SpawnSlender(SF2NPC_BaseNPC Npc, const float pos[3])
{
	if (!IsRoundPlaying())
	{
		return;
	}

	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape)
	{
		return; // Stop spawning bosses before all pages are picked up in Renevant.
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	Npc.UnSpawn();
	Npc.GetProfile(profile,sizeof(profile));

	float truePos[3], trueAng[3];
	trueAng[1] = GetRandomFloat(0.0, 360.0);
	AddVectors(truePos, pos, truePos);

	int bossIndex = Npc.Index;
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	char buffer[PLATFORM_MAX_PATH];

	GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));

	CBaseNPC npcBoss = CBaseNPC();
	CBaseCombatCharacter npcEntity = CBaseCombatCharacter(npcBoss.GetEntity());
	CBaseNPC_Locomotion locomotion = npcBoss.GetLocomotion();
	npcEntity.Hook_HandleAnimEvent(CBaseAnimating_HandleAnimEvent);

	npcEntity.Teleport(truePos, trueAng);
	npcEntity.SetModel(buffer);
	npcEntity.SetRenderMode(view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
	npcEntity.SetRenderFx(view_as<RenderFx>(g_SlenderRenderFX[bossIndex]));
	npcEntity.SetRenderColor(g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
	if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
	{
		float scaleModel = NPCGetModelScale(bossIndex) * 0.5;
		npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", scaleModel);
	}
	else
	{
		npcEntity.SetPropFloat(Prop_Send, "m_flModelScale", NPCGetModelScale(bossIndex));
	}
	npcEntity.Spawn();
	npcEntity.Activate();

	npcBoss.flStepSize = 18.0;
	npcBoss.flGravity = g_Gravity;
	npcBoss.flAcceleration = g_SlenderCalculatedAcceleration[bossIndex];
	npcBoss.flDeathDropHeight = 99999.0;
	npcBoss.flJumpHeight = 512.0;
	npcBoss.flWalkSpeed = g_SlenderCalculatedWalkSpeed[bossIndex];
	npcBoss.flRunSpeed = g_SlenderCalculatedSpeed[bossIndex];

	g_BossPathFollower[bossIndex].SetMinLookAheadDistance(GetBossProfileNodeDistanceLookAhead(profile));

	if (NPCGetModelSkinMax(bossIndex) > 0)
	{
		int randomSkin = GetRandomInt(0, NPCGetModelSkinMax(bossIndex));
		npcEntity.SetProp(Prop_Send, "m_nSkin", randomSkin);
	}
	else
	{
		if (GetBossProfileSkinDifficultyState(profile))
		{
			npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(bossIndex, difficulty));
		}
		else
		{
			npcEntity.SetProp(Prop_Send, "m_nSkin", NPCGetModelSkin(bossIndex));
		}
	}
	if (NPCGetModelBodyGroupsMax(bossIndex) > 0)
	{
		int randomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(bossIndex));
		npcEntity.SetProp(Prop_Send, "m_nBody", randomBody);
	}
	else
	{
		if (GetBossProfileBodyGroupsDifficultyState(profile))
		{
			npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(bossIndex, difficulty));
		}
		else
		{
			npcEntity.SetProp(Prop_Send, "m_nBody", NPCGetModelBodyGroups(bossIndex));
		}
	}

	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, npcEntity.iEnt, Hook_BossUpdateTransmitState);
	SetEntityFlags(npcEntity.iEnt, FL_NPC);
	SetEntityTransmitState(npcEntity.iEnt, FL_EDICT_ALWAYS);

	g_SlenderEnt[bossIndex] = EntIndexToEntRef(npcEntity.iEnt);

	if (g_SlenderEngineSound[bossIndex][0] != '\0')
	{
		EmitSoundToAll(g_SlenderEngineSound[bossIndex], npcEntity.iEnt, SNDCHAN_STATIC, GetBossProfileEngineSoundLevel(profile),
		_, GetBossProfileEngineSoundVolume(profile));
	}

	if (GetBossProfileSpawnParticleState(profile))
	{
		SlenderCreateParticleSpawnEffect(bossIndex);
	}

	switch (NPCGetType(bossIndex))
	{
		case SF2BossType_Statue:
		{
			npcBoss.flMaxYawRate = 0.0;

			locomotion.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
			locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
			locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);

			npcEntity.SetPropVector(Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

			npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
			npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);

			npcEntity.SetProp(Prop_Data, "m_nSolidType", SOLID_BBOX);
			npcEntity.SetProp(Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);

			SDKHook(npcEntity.iEnt, SDKHook_ThinkPost, SlenderStatueSetNextThink);
			SDKHook(npcEntity.iEnt, SDKHook_Think, SlenderStatueBossProcessMovement);

			g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderBlinkBossThink, g_SlenderEnt[bossIndex], TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

			Spawn_Statue(bossIndex);
		}
		case SF2BossType_Chaser:
		{
			npcBoss.flMaxYawRate = NPCGetTurnRate(bossIndex);

			locomotion.SetCallback(LocomotionCallback_ShouldCollideWith, LocoCollideWith);
			if (!SF_IsBoxingMap())
			{
				locomotion.SetCallback(LocomotionCallback_IsAbleToJumpAcrossGaps, CanJumpAcrossGaps);
				locomotion.SetCallback(LocomotionCallback_IsAbleToClimb, CanJumpAcrossGaps);
				locomotion.SetCallback(LocomotionCallback_JumpAcrossGap, JumpAcrossGapsCBase);
				locomotion.SetCallback(LocomotionCallback_ClimbUpToLedge, ClimbUpCBase);
			}

			if (NPCGetRaidHitbox(bossIndex) == 1)
			{
				npcBoss.SetBodyMins(g_SlenderDetectMins[bossIndex]);
				npcBoss.SetBodyMaxs(g_SlenderDetectMaxs[bossIndex]);

				npcEntity.SetPropVector(Prop_Send, "m_vecMins", g_SlenderDetectMins[bossIndex]);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", g_SlenderDetectMaxs[bossIndex]);

				npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", g_SlenderDetectMins[bossIndex]);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", g_SlenderDetectMaxs[bossIndex]);
			}
			else if (NPCGetRaidHitbox(bossIndex) == 0)
			{
				npcBoss.SetBodyMins(HULL_HUMAN_MINS);
				npcBoss.SetBodyMaxs(HULL_HUMAN_MAXS);

				npcEntity.SetPropVector(Prop_Send, "m_vecMins", HULL_HUMAN_MINS);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxs", HULL_HUMAN_MAXS);

				npcEntity.SetPropVector(Prop_Send, "m_vecMinsPreScaled", HULL_HUMAN_MINS);
				npcEntity.SetPropVector(Prop_Send, "m_vecMaxsPreScaled", HULL_HUMAN_MAXS);
			}

			if (SF_IsBoxingMap())
			{
				npcEntity.SetProp(Prop_Send, "m_CollisionGroup", COLLISION_GROUP_DEBRIS_TRIGGER);
			}

			SDKHook(npcEntity.iEnt, SDKHook_OnTakeDamageAlive, Hook_SlenderOnTakeDamage);

			// Reset stats.
			g_SlenderInBacon[bossIndex] = false;
			g_SlenderTarget[bossIndex] = INVALID_ENT_REFERENCE;
			g_SlenderTargetIsVisible[bossIndex] = false;
			g_SlenderState[bossIndex] = STATE_IDLE;
			g_IsSlenderAttacking[bossIndex] = false;
			g_SlenderGiveUp[bossIndex] = false;
			g_SlenderAttackTimer[bossIndex] = null;
			g_SlenderLaserTimer[bossIndex] = null;
			g_SlenderBackupAtkTimer[bossIndex] = null;
			g_SlenderChaseInitialTimer[bossIndex] = null;
			g_SlenderRage1Timer[bossIndex] = null;
			g_SlenderRage2Timer[bossIndex] = null;
			g_SlenderRage3Timer[bossIndex] = null;
			g_SlenderHealTimer[bossIndex] = null;
			g_SlenderHealDelayTimer[bossIndex] = null;
			g_SlenderHealEventTimer[bossIndex] = null;
			g_SlenderStartFleeTimer[bossIndex] = null;
			g_SlenderTargetSoundLastTime[bossIndex] = -1.0;
			g_SlenderTargetSoundDiscardMasterPosTime[bossIndex] = -1.0;
			g_SlenderTargetSoundType[bossIndex] = SoundType_None;
			g_SlenderInvestigatingSound[bossIndex] = false;
			g_SlenderNextStunTime[bossIndex] = -1.0;
			g_SlenderNextCloakTime[bossIndex] = -1.0;
			g_NpcHasCloaked[bossIndex] = false;
			g_SlenderLastHeardFootstep[bossIndex] = 0.0;
			g_SlenderLastHeardVoice[bossIndex] = 0.0;
			g_SlenderLastHeardWeapon[bossIndex] = 0.0;
			g_SlenderNextVoiceSound[bossIndex] = 0.0;
			g_SlenderNextFootstepSound[bossIndex] = 0.0;
			g_SlenderNextMoanSound[bossIndex] = 0.0;
			g_SlenderTauntAlertCount[bossIndex] = 0;

			for (int difficulty2 = 0; difficulty2 < Difficulty_Max; difficulty2++)
			{
				g_SlenderTimeUntilKill[bossIndex] = GetGameTime() + NPCGetIdleLifetime(bossIndex, difficulty2);
				g_SlenderNextWanderPos[bossIndex][difficulty2] = GetGameTime() + GetRandomFloat(2.0, 4.0);
			}

			g_SlenderTimeUntilRecover[bossIndex] = -1.0;
			g_SlenderTimeUntilAlert[bossIndex] = -1.0;
			g_SlenderTimeUntilIdle[bossIndex] = -1.0;
			g_SlenderTimeUntilChase[bossIndex] = -1.0;
			g_SlenderTimeUntilNoPersistence[bossIndex] = -1.0;
			g_SlenderTimeUntilAttackEnd[bossIndex] = -1.0;
			g_SlenderNextPathTime[bossIndex] = 0.0;
			g_SlenderLastCalculPathTime[bossIndex] = -1.0;
			g_LastStuckTime[bossIndex] = -1.0;
			g_SlenderInterruptConditions[bossIndex] = 0;
			g_SlenderChaseDeathPositionBool[bossIndex] = false;
			g_NpcPlayerScareVictin[bossIndex] = INVALID_ENT_REFERENCE;
			g_NpcChasingScareVictin[bossIndex] = false;
			g_NpcLostChasingScareVictim[bossIndex] = false;
			g_NpcVelocityCancel[bossIndex] = false;
			g_SlenderBurnTimer[bossIndex] = null;
			g_SlenderBleedTimer[bossIndex] = null;
			g_SlenderMarkedTimer[bossIndex] = null;
			g_SlenderDeathCamTimer[bossIndex] = null;
			g_SlenderDeathCamTarget[bossIndex] = INVALID_ENT_REFERENCE;
			g_SlenderStopBurningTimer[bossIndex] = 0.0;
			g_SlenderStopBleedingTimer[bossIndex] = 0.0;
			g_SlenderIsBurning[bossIndex] = false;
			g_SlenderIsMarked[bossIndex] = false;
			g_NpcAddSpeed[bossIndex] = 0.0;
			g_NpcAddMaxSpeed[bossIndex] = 0.0;
			g_NpcAddAcceleration[bossIndex] = 0.0;
			g_SlenderAutoChaseCount[bossIndex] = 0;
			g_SlenderAutoChaseCooldown[bossIndex] = 0.0;
			g_SlenderSoundTarget[bossIndex] = INVALID_ENT_REFERENCE;
			g_SlenderSeeTarget[bossIndex] = INVALID_ENT_REFERENCE;
			g_SlenderIsAutoChasingLoudPlayer[bossIndex] = false;
			g_SlenderInDeathcam[bossIndex] = false;

			Spawn_Chaser(bossIndex);

			NPCChaserResetAnimationInfo(bossIndex, 0);

			SDKHook(npcEntity.iEnt, SDKHook_ThinkPost, SlenderSetNextThink);

			if (GetChaserProfileSpawnAnimationState(profile) && !SF_IsSlaughterRunMap())
			{
				g_SlenderSpawning[bossIndex] = true;
				NPCChaserUpdateBossAnimation(bossIndex, npcEntity.iEnt, STATE_IDLE, true);
				g_SlenderEntityThink[bossIndex] = null;
				g_SlenderSpawnTimer[bossIndex] = CreateTimer(g_SlenderAnimationDuration[bossIndex], Timer_SlenderSpawnTimer, EntIndexToEntRef(npcEntity.iEnt), TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				SDKHook(npcEntity.iEnt, SDKHook_Think, SlenderChaseBossProcessMovement);
				g_SlenderSpawning[bossIndex] = false;
				NPCChaserUpdateBossAnimation(bossIndex, npcEntity.iEnt, STATE_IDLE);
				g_SlenderEntityThink[bossIndex] = CreateTimer(BOSS_THINKRATE, Timer_SlenderChaseBossThink, EntIndexToEntRef(npcEntity.iEnt), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}

			for (int i = 0; i < 3; i++)
			{
				g_SlenderGoalPos[bossIndex][i] = 0.0;
				g_SlenderTargetSoundTempPos[bossIndex][i] = 0.0;
				g_SlenderTargetSoundMasterPos[bossIndex][i] = 0.0;
				g_SlenderChaseDeathPosition[bossIndex][i] = 0.0;
			}

			for (int i = 1; i <= MaxClients; i++)
			{
				g_SlenderLastFoundPlayer[bossIndex][i] = -1.0;

				for (int i2 = 0; i2 < 3; i2++)
				{
					g_SlenderLastFoundPlayerPos[bossIndex][i][i2] = 0.0;
				}
			}

			SlenderClearTargetMemory(bossIndex);

			//(Experimental)
			if (NPCGetHealthbarState(bossIndex))
			{
				//The boss spawned for the 1st time, block now its teleportation ability to prevent healthbar conflict.
				NPCSetFlags(bossIndex,NPCGetFlags(bossIndex)|SFF_NOTELEPORT);
				UpdateHealthBar(bossIndex);
			}
			/*if (SF_BossesChaseEndlessly() || SF_IsRaidMap())
			{
				NPCSetFlags(bossIndex,NPCGetFlags(bossIndex)|SFF_NOTELEPORT);
			}*/

			//Stun Health
			float maxHealth = NPCChaserGetStunInitialHealth(bossIndex);
			float health = 0.0;
			for(int client=1; client<=MaxClients; client++)
			{
				if (IsValidClient(client) && !g_PlayerEliminated[client] && IsPlayerAlive(client) && !DidClientEscape(client))
				{
					int classToInt = view_as<int>(TF2_GetPlayerClass(client));
					health = GetChaserProfileStunHealthPerClass(profile, classToInt);
					if (health > 0.0)
					{
						maxHealth += health;
					}
					else
					{
						health = GetChaserProfileStunHealthPerPlayer(profile);
						maxHealth += health;
					}
					if (SF_IsBoxingMap() && TF2_GetPlayerClass(client) == TFClass_Scout)
					{
						NPCSetAddSpeed(bossIndex, 10.0);
						NPCSetAddMaxSpeed(bossIndex, 15.0);
					}
				}
			}
			NPCChaserSetStunInitialHealth(bossIndex, maxHealth);
			NPCChaserSetStunHealth(bossIndex, NPCChaserGetStunInitialHealth(bossIndex));
			int entHealth = RoundToCeil(maxHealth + 1500000000.0);
			npcEntity.SetProp(Prop_Data, "m_iHealth", entHealth);
			npcEntity.SetProp(Prop_Data, "m_iMaxHealth", entHealth);
		}
	}

	if (NPCGetCustomOutlinesState(bossIndex))
	{
		if (!NPCGetRainbowOutlineState(bossIndex))
		{
			int color[4];
			color[0] = NPCGetOutlineColorR(bossIndex);
			color[1] = NPCGetOutlineColorG(bossIndex);
			color[2] = NPCGetOutlineColorB(bossIndex);
			color[3] = NPCGetOutlineTransparency(bossIndex);
			if (color[0] < 0)
			{
				color[0] = 0;
			}
			if (color[1] < 0)
			{
				color[1] = 0;
			}
			if (color[2] < 0)
			{
				color[2] = 0;
			}
			if (color[3] < 0)
			{
				color[3] = 0;
			}
			if (color[0] > 255)
			{
				color[0] = 255;
			}
			if (color[1] > 255)
			{
				color[1] = 255;
			}
			if (color[2] > 255)
			{
				color[2] = 255;
			}
			if (color[3] > 255)
			{
				color[3] = 255;
			}
			SlenderAddGlow(bossIndex,_,color);
		}
		else
		{
			SlenderAddGlow(bossIndex,_,view_as<int>({0, 0, 0, 0}));
		}
	}
	else
	{
		int purple[4] = {150, 0, 255, 255};
		SlenderAddGlow(bossIndex,_,purple);
	}

	int master = g_SlenderCopyMaster[bossIndex];
	int flags = NPCGetFlags(bossIndex);

	if (MAX_BOSSES > master >= 0 && NPCGetFakeCopyState(bossIndex))
	{
		if (!SF_SpecialRound(SPECIALROUND_DREAMFAKEBOSSES))
		{
			NPCSetFlags(bossIndex, flags | SFF_FAKE);
		}
	}

	SlenderSpawnEffects(bossIndex);

	if (IsValidEntity(g_SlenderEnt[bossIndex]))
	{
		char soundSpawn[PLATFORM_MAX_PATH];
		ArrayList soundList;
		SF2BossProfileSoundInfo soundInfo;
		GetBossProfileSpawnLocalSounds(profile, soundInfo);
		soundList = soundInfo.Paths;
		if (soundList != null && soundList.Length > 0)
		{
			soundList.GetString(GetRandomInt(0, soundList.Length - 1), soundSpawn, sizeof(soundSpawn));
		}
		soundList = null;
		if (soundSpawn[0] != '\0')
		{
			EmitSoundToAll(soundSpawn, EntRefToEntIndex(g_SlenderEnt[bossIndex]), soundInfo.Channel, soundInfo.Level, soundInfo.Flags, soundInfo.Volume, soundInfo.Pitch);
			g_SlenderNextVoiceSound[bossIndex] = GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);
		}
	}

	// Call our forward.
	Call_StartForward(g_OnBossSpawnFwd);
	Call_PushCell(bossIndex);
	Call_Finish();
}

static MRESReturn Hook_BossUpdateTransmitState(int bossEntity, DHookReturn hookReturn)
{
    if (!g_Enabled || !IsValidEntity(bossEntity) || NPCGetFromEntIndex(bossEntity) == -1)
    {
        return MRES_Ignored;
    }

    hookReturn.Value = SetEntityTransmitState(bossEntity, FL_EDICT_ALWAYS);
    return MRES_Supercede;
}

static bool LocoCollideWith(CBaseNPC_Locomotion loco, int other)
{
	if (IsValidEntity(other))
	{
		char class[32];
		GetEdictClassname(other, class, sizeof(class));
		if (strcmp(class, "player") == 0)
		{
			if (!SF_IsBoxingMap() && !g_PlayerProxy[other] && !IsClientInGhostMode(other) && GetClientTeam(other) != TFTeam_Blue && !IsClientInDeathCam(other))
			{
				return true;
			}
		}
		if (IsEntityAProjectile(other))
		{
			return false;
		}
	}
	return loco.CallBaseFunction(other);
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

static MRESReturn CBaseAnimating_HandleAnimEvent(int thisInt, DHookParam params)
{
	int bossIndex = NPCGetFromEntIndex(thisInt);
	int event = params.GetObjectVar(1, 0, ObjectValueType_Int);
	if (event > 0 && thisInt && thisInt != INVALID_ENT_REFERENCE &&
		bossIndex != -1 && NPCGetUniqueID(bossIndex) != -1)
	{
		SlenderCastFootstepAnimEvent(bossIndex, event);
		SlenderCastAnimEvent(bossIndex, event);
	}
	return MRES_Ignored;
}

void RemoveSlender(int bossIndex)
{
	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	int bossEnt = NPCGetEntIndex(bossIndex);

	if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
	{
		Call_StartForward(g_OnBossDespawnFwd);
		Call_PushCell(bossIndex);
		Call_Finish();

		//Turn off all slender's effects in order to prevent some bugs.
		SlenderRemoveEffects(bossEnt, true);

		if (NPCGetType(bossIndex) == SF2BossType_Statue)
		{
			SDKUnhook(bossEnt, SDKHook_Think, SlenderStatueBossProcessMovement);
			// Stop all possible looping sounds.
			SF2BossProfileSoundInfo soundInfo;
			GetStatueProfileMoveSounds(profile, soundInfo);
			soundInfo.StopAllSounds(bossEnt);
		}
		else
		{
			SDKUnhook(bossEnt, SDKHook_Think, SlenderChaseBossProcessMovement);
			SDKUnhook(bossEnt, SDKHook_OnTakeDamageAlive, Hook_SlenderOnTakeDamage);
			Despawn_Chaser(bossIndex);
		}

		if (g_BossPathFollower[bossIndex].IsValid())
		{
			g_BossPathFollower[bossIndex].Invalidate();
		}

		int glowEnt = EntRefToEntIndex(g_NpcGlowEntity[bossIndex]);
		if (glowEnt != INVALID_ENT_REFERENCE)
		{
			RemoveEntity(glowEnt);
			g_NpcGlowEntity[bossIndex] = INVALID_ENT_REFERENCE;
		}

		if (GetBossProfileDespawnParticleState(profile))
		{
			SlenderCreateParticleSpawnEffect(bossIndex, true);
		}

		if (g_SlenderEngineSound[bossIndex][0] != '\0')
		{
			StopSound(bossEnt, SNDCHAN_STATIC, g_SlenderEngineSound[bossIndex]);
		}

		if (NPCGetFlags(bossIndex) & SFF_HASSTATICLOOPLOCALSOUND)
		{
			char loopSound[PLATFORM_MAX_PATH];
			GetBossProfileStaticLocalSound(profile, loopSound, sizeof(loopSound));

			if (loopSound[0] != '\0')
			{
				StopSound(bossEnt, SNDCHAN_STATIC, loopSound);
			}
		}
		int bossFlags = NPCGetFlags(bossIndex);
		if (SF_IsRaidMap() || SF_BossesChaseEndlessly() || !NPCGetHealthbarState(bossIndex))
		{
			NPCSetFlags(bossIndex, bossFlags & ~SFF_NOTELEPORT);
		}

		g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
		RemoveEntity(bossEnt);
	}
	else
	{
		g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
		g_NpcGlowEntity[bossIndex] = INVALID_ENT_REFERENCE;
	}
	if (NPCGetHealthbarState(bossIndex) && g_HealthBar != -1)
	{
		int npcIndex = 0;
		for (npcIndex = 0; npcIndex < MAX_BOSSES; npcIndex++)
		{
			if (NPCGetUniqueID(npcIndex) == -1)
			{
				continue;
			}
			if (NPCGetHealthbarState(npcIndex))
			{
				int tempSlender = NPCGetEntIndex(npcIndex);

				if (tempSlender && tempSlender != INVALID_ENT_REFERENCE)
				{
					UpdateHealthBar(npcIndex);
					break;
				}
			}
		}
		if (npcIndex == MAX_BOSSES)
		{
			UpdateHealthBar(bossIndex, 0);
		}
	}
}

Action Timer_BossBurn(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	if (!SF_IsBoxingMap())
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (GetGameTime() >= g_SlenderStopBurningTimer[bossIndex])
	{
		g_SlenderBurnTimer[bossIndex] = null;
		g_SlenderIsBurning[bossIndex] = false;
		return Plugin_Stop;
	}
	int state = g_SlenderState[bossIndex];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (timer != g_SlenderBurnTimer[bossIndex])
	{
		return Plugin_Stop;
	}
	if (NPCChaserIsStunEnabled(bossIndex))
	{
		if (!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			float burnDamage = -4.0 * GetChaserProfileAfterburnMultiplier(profile);
			NPCChaserAddStunHealth(bossIndex, burnDamage);
			if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
			{
				float myPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
				NPCBossTriggerStun(bossIndex, slender, profile, myPos);
				Call_StartForward(g_OnBossStunnedFwd);
				Call_PushCell(bossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(bossIndex) && state != STATE_STUN && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			UpdateHealthBar(bossIndex);
		}
	}
	return Plugin_Continue;
}

Action Timer_BossBleed(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	if (!SF_IsBoxingMap())
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (GetGameTime() >= g_SlenderStopBleedingTimer[bossIndex])
	{
		g_SlenderBleedTimer[bossIndex] = null;
		return Plugin_Stop;
	}
	int state = g_SlenderState[bossIndex];

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (timer != g_SlenderBleedTimer[bossIndex])
	{
		return Plugin_Stop;
	}
	if (NPCChaserIsStunEnabled(bossIndex))
	{
		if (!g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			NPCChaserAddStunHealth(bossIndex, -4.0);
			if (NPCChaserGetStunHealth(bossIndex) <= 0.0 && state != STATE_STUN)
			{
				float myPos[3];
				GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);
				NPCBossTriggerStun(bossIndex, slender, profile, myPos);
				Call_StartForward(g_OnBossStunnedFwd);
				Call_PushCell(bossIndex);
				Call_PushCell(-1);
				Call_Finish();
			}
		}
		if (NPCGetHealthbarState(bossIndex) && state != STATE_STUN && !g_NpcUsesRageAnimation1[bossIndex] && !g_NpcUsesRageAnimation2[bossIndex] && !g_NpcUsesRageAnimation3[bossIndex])
		{
			UpdateHealthBar(bossIndex);
		}
	}
	return Plugin_Continue;
}

Action Timer_BossMarked(Handle timer, any entref)
{
	if (!g_Enabled)
	{
		return Plugin_Stop;
	}

	int slender = EntRefToEntIndex(entref);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	if (!SF_IsBoxingMap())
	{
		return Plugin_Stop;
	}

	int bossIndex = NPCGetFromEntIndex(slender);
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}

	if (timer != g_SlenderMarkedTimer[bossIndex])
	{
		return Plugin_Stop;
	}

	g_SlenderMarkedTimer[bossIndex] = null;
	g_SlenderIsMarked[bossIndex] = false;

	return Plugin_Stop;
}

static Action Hook_SlenderGlowSetTransmit(int entity,int other)
{
	if (!g_Enabled)
	{
		return Plugin_Continue;
	}
	if (g_PlayerProxy[other])
	{
		return Plugin_Continue;
	}
	if (IsClientInGhostMode(other))
	{
		return Plugin_Continue;
	}
	if ((SF_SpecialRound(SPECIALROUND_WALLHAX) || g_EnableWallHaxConVar.BoolValue) && GetClientTeam(other) == TFTeam_Red && !g_PlayerEscaped[other] && !g_PlayerEliminated[other])
	{
		return Plugin_Continue;
	}
	if (g_RestartSessionEnabled)
	{
		return Plugin_Continue;
	}
	return Plugin_Handled;
}

bool SlenderCanHearPlayer(int bossIndex,int client, SoundType soundType)
{
	if (!IsValidClient(client) || !IsPlayerAlive(client))
	{
		return false;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return false;
	}

	TFClassType class = TF2_GetPlayerClass(client);
	int classToInt = view_as<int>(class);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	float hisPos[3], myPos[3];
	GetClientAbsOrigin(client, hisPos);
	SlenderGetAbsOrigin(bossIndex, myPos);

	float hearRadius = NPCGetHearingRadius(bossIndex, difficulty);
	if (hearRadius <= 0.0)
	{
		return false;
	}

	float distance = GetVectorSquareMagnitude(hisPos, myPos);

	// Trace check.
	Handle trace = null;
	bool traceHit = false;

	float myEyePos[3];
	SlenderGetEyePosition(bossIndex, myEyePos);

	float cooldown = 0.0;

	switch (soundType)
	{
		case SoundType_Footstep, SoundType_LoudFootstep, SoundType_QuietFootstep:
		{
			if (!(GetEntityFlags(client) & FL_ONGROUND))
			{
				return false;
			}

			if (soundType == SoundType_QuietFootstep)
			{
				cooldown = GetChaserProfileHearQuietFootstepCooldown(profile, difficulty);
				distance *= 1.85;
			}
			else if (soundType == SoundType_LoudFootstep)
			{
				cooldown = GetChaserProfileHearLoudFootstepCooldown(profile, difficulty);
				distance *= 0.66;
			}
			else
			{
				cooldown = GetChaserProfileHearFootstepCooldown(profile, difficulty);
			}

			trace = TR_TraceRayFilterEx(myPos, hisPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
			traceHit = TR_DidHit(trace);
			delete trace;
		}
		case SoundType_Voice, SoundType_Flashlight:
		{
			float hisEyePos[3];
			GetClientEyePosition(client, hisEyePos);

			trace = TR_TraceRayFilterEx(myEyePos, hisEyePos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
			traceHit = TR_DidHit(trace);
			delete trace;

			if (!IsClassConfigsValid() || soundType == SoundType_Voice)
			{
				distance *= 0.5;
			}
			else if (IsClassConfigsValid() && soundType == SoundType_Flashlight)
			{
				distance *= g_ClassFlashlightSoundRadius[classToInt];
			}

			if (soundType == SoundType_Voice)
			{
				cooldown = GetChaserProfileHearVoiceCooldown(profile, difficulty);
			}
			else if (soundType == SoundType_Flashlight)
			{
				cooldown = GetChaserProfileHearFlashlightCooldown(profile, difficulty);
			}
		}
		case SoundType_Weapon:
		{
			float hisMins[3], hisMaxs[3];
			GetEntPropVector(client, Prop_Send, "m_vecMins", hisMins);
			GetEntPropVector(client, Prop_Send, "m_vecMaxs", hisMaxs);

			float middle[3];
			for (int i = 0; i < 2; i++) middle[i] = (hisMins[i] + hisMaxs[i]) / 2.0;

			float endPos[3];
			GetClientAbsOrigin(client, endPos);
			AddVectors(hisPos, middle, endPos);

			trace = TR_TraceRayFilterEx(myEyePos, endPos, CONTENTS_SOLID | CONTENTS_MOVEABLE | CONTENTS_MIST | CONTENTS_GRATE, RayType_EndPoint, TraceRayDontHitCharactersOrEntity, slender);
			traceHit = TR_DidHit(trace);
			delete trace;

			distance *= 0.66;

			cooldown = GetChaserProfileHearWeaponCooldown(profile, difficulty);
		}
	}

	delete trace;

	if (traceHit)
	{
		distance *= 1.66;
	}

	if (!IsClassConfigsValid())
	{
		if (TF2_GetPlayerClass(client) == TFClass_Spy)
		{
			distance *= 1.3;
		}

		if (TF2_GetPlayerClass(client) == TFClass_Scout)
		{
			distance *= 0.8;
		}
	}
	else
	{
		distance *= g_ClassBossHearingSensitivity[classToInt];
	}

	if (distance > SquareFloat(hearRadius))
	{
		return false;
	}

	if (g_SlenderSoundPositionSetCooldown[bossIndex] > GetGameTime() && cooldown > 0.0)
	{
		return false;
	}

	g_SlenderSoundPositionSetCooldown[bossIndex] = GetGameTime() + cooldown;

	return true;
}

stock int SlenderArrayIndexToEntIndex(int bossIndex)
{
	return NPCGetEntIndex(bossIndex);
}

stock bool SlenderOnlyLooksIfNotSeen(int bossIndex)
{
	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		return true;
	}
	return false;
}

stock bool SlenderUsesBlink(int bossIndex)
{
	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		return true;
	}
	return false;
}

stock bool SlenderKillsOnNear(int bossIndex)
{
	if (NPCGetType(bossIndex) == SF2BossType_Statue)
	{
		return false;
	}
	return true;
}

stock void SlenderClearTargetMemory(int bossIndex)
{
	if (bossIndex == -1)
	{
		return;
	}
}

stock bool SlenderCreateTargetMemory(int bossIndex)
{
	if (bossIndex == -1)
	{
		return false;
	}

	return true;
}

stock void SlenderRemoveTargetMemory(int bossIndex)
{
	if (bossIndex == -1)
	{
		return;
	}
}

void SlenderPrintChatMessage(int bossIndex, int player)
{
	if (bossIndex == -1)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	ArrayList deathMessages = GetBossProfileChatDeathMessages(profile);
	if (deathMessages == null)
	{
		return;
	}

	int difficultyIndex = g_NpcDeathMessageDifficultyIndexes[bossIndex];

	char indexes[8], currentIndex[2];
	FormatEx(indexes, sizeof(indexes), "%d", difficultyIndex);
	FormatEx(currentIndex, sizeof(currentIndex), "%d", g_DifficultyConVar.IntValue);
	char number = currentIndex[0];
	int difficultyNumber = 0;
	if (FindCharInString(indexes, number) != -1)
	{
		difficultyNumber += g_DifficultyConVar.IntValue;
	}
	if (indexes[0] != '\0' && currentIndex[0] != '\0' && difficultyNumber != -1)
	{
		int currentAtkIndex = StringToInt(currentIndex);
		if (difficultyNumber == currentAtkIndex) //WHOA, legacy system actually won't be legacy.
		{
			char buffer[PLATFORM_MAX_PATH], prefix[PLATFORM_MAX_PATH], name[SF2_MAX_NAME_LENGTH], time[PLATFORM_MAX_PATH];
			int roundTime = RoundToNearest(g_RoundTimeMessage);
			int randomMessage = GetRandomInt(0, deathMessages.Length - 1);
			GetBossProfileChatDeathMessagePrefix(profile, prefix, sizeof(prefix));
			deathMessages.GetString(randomMessage, buffer, sizeof(buffer));
			NPCGetBossName(bossIndex, name, sizeof(name));
			FormatEx(time, sizeof(time), "%d", roundTime);
			char playerName[32], replacePlayer[64];
			FormatEx(playerName, sizeof(playerName), "%N", player);
			if (prefix[0] == '\0')
			{
				prefix = "[SF2]";
			}
			if (buffer[0] != '\0' && GetClientTeam(player) == 2)
			{
				if (StrContains(buffer, "[PLAYER]", true) != -1)
				{
					FormatEx(replacePlayer, sizeof(replacePlayer), "{red}%s{default}", playerName);
					ReplaceString(buffer, sizeof(buffer), "[PLAYER]", replacePlayer, true);
				}
				if (StrContains(buffer, "[BOSS]", true) != -1)
				{
					ReplaceString(buffer, sizeof(buffer), "[BOSS]", name, true);
				}
				if (StrContains(buffer, "[ROUNDTIME]", true) != -1)
				{
					ReplaceString(buffer, sizeof(buffer), "[ROUNDTIME]", time, true);
				}
				int chatLength = strlen(prefix) + strlen(buffer);
				if (chatLength > 255)
				{
					LogSF2Message("WARNING! Death message %i has greater than 255 characters on boss index %i, shorten the length of this message.", randomMessage + 1, bossIndex);
				}
				else
				{
					CPrintToChatAll("{royalblue}%s{default} %s", prefix, buffer);
				}
			}
		}
	}
}

void SlenderPerformVoice(int bossIndex, const int attackIndex=-1, int soundType = -1)
{
	if (bossIndex == -1 || soundType == -1)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	SF2BossProfileSoundInfo soundInfo;
	ArrayList soundList;
	switch (soundType)
	{
		case SF2BossSound_Idle:
		{
			GetChaserProfileIdleSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_Alert:
		{
			GetChaserProfileAlertSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_Chasing:
		{
			GetChaserProfileChasingSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_ChaseInitial:
		{
			GetChaserProfileChaseInitialSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_Stun:
		{
			GetChaserProfileStunSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_Attack:
		{
			ArrayList attackSounds = GetChaserProfileAttackSounds(profile);
			if (attackSounds != null && attackSounds.Length > 0)
			{
				int length = attackSounds.Length;
				attackSounds.GetArray(length == 1 ? 0 : attackIndex, soundInfo, sizeof(soundInfo));
				soundList = soundInfo.Paths;
				if (soundList != null && soundList.Length > 0)
				{
					SlenderPerformVoiceCooldown(bossIndex, slender, soundInfo, soundList);
				}
			}
			return;
		}
		case SF2BossSound_AttackKilled:
		{
			GetChaserProfileAttackKilledSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_RageAll:
		{
			GetChaserProfileRageAllSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_RageTwo:
		{
			GetChaserProfileRageTwoSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_RageThree:
		{
			GetChaserProfileRageThreeSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
		case SF2BossSound_SelfHeal:
		{
			GetChaserProfileSelfHealSounds(profile, soundInfo);
			soundList = soundInfo.Paths;
		}
	}
	if (soundList != null && soundList.Length > 0)
	{
		SlenderPerformVoiceCooldown(bossIndex, slender, soundInfo, soundList);
	}
}

void SlenderPerformVoiceCooldown(int bossIndex, int slender, SF2BossProfileSoundInfo soundInfo, ArrayList soundList)
{
	char buffer[512];
	soundList.GetString(GetRandomInt(0, soundList.Length - 1), buffer, sizeof(buffer));
	if (buffer[0] != '\0')
	{
		float cooldown = GetRandomFloat(soundInfo.CooldownMin, soundInfo.CooldownMax);
		if (soundInfo.PitchRandomMin != soundInfo.Pitch && soundInfo.PitchRandomMax != soundInfo.Pitch)
		{
			EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, soundInfo.Flags,
			soundInfo.Volume, GetRandomInt(soundInfo.PitchRandomMin, soundInfo.PitchRandomMax));
		}
		else if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, soundInfo.Flags,
			soundInfo.Volume, soundInfo.Pitch + 25);
		}
		else
		{
			EmitSoundToAll(buffer, slender, soundInfo.Channel, soundInfo.Level, soundInfo.Flags,
			soundInfo.Volume, soundInfo.Pitch);
		}
		g_SlenderNextVoiceSound[bossIndex] = GetGameTime() + cooldown;
	}
}

void SlenderCastFootstep(int bossIndex)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (g_SlenderFootstepTime[bossIndex] <= 0.0)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char path[PLATFORM_MAX_PATH];
	SF2BossProfileSoundInfo soundInfo;
	GetChaserProfileFootstepSounds(profile, soundInfo);
	if (soundInfo.Paths == null || soundInfo.Paths.Length <= 0)
	{
		return;
	}
	soundInfo.Paths.GetString(GetRandomInt(0, soundInfo.Paths.Length - 1), path, sizeof(path));

	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	if (path[0] != '\0')
	{
		float volume = soundInfo.Volume;
		int channel = soundInfo.Channel;
		int level = soundInfo.Level;
		int pitch = soundInfo.Pitch;

		g_SlenderNextFootstepSound[bossIndex] = GetGameTime() + g_SlenderFootstepTime[bossIndex];
		if (StrContains(path, ".mp3", true) == -1 && StrContains(path, ".wav", true) == -1)
		{
			EmitGameSoundToAll(path, slender);
		}
		else
		{
			EmitSoundToAll(path, slender, channel, level, _, volume, pitch);
		}
		if (NPCChaserGetEarthquakeFootstepsState(bossIndex))
		{
			UTIL_ScreenShake(myPos, NPCChaserGetEarthquakeFootstepsAmplitude(bossIndex),
			NPCChaserGetEarthquakeFootstepsFrequency(bossIndex), NPCChaserGetEarthquakeFootstepsDuration(bossIndex),
			NPCChaserGetEarthquakeFootstepsRadius(bossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(bossIndex));
		}
	}
}

void SlenderCastFootstepAnimEvent(int bossIndex, int event)
{
	if (bossIndex == -1)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	ArrayList arraySounds = GetBossProfileFootstepEventSounds(profile);
	ArrayList arrayIndexes = GetBossProfileFootstepEventIndexes(profile);

	if (arraySounds == null || arrayIndexes == null)
	{
		return;
	}

	int foundIndex = arrayIndexes.FindValue(event);
	if (foundIndex == -1)
	{
		return;
	}

	SF2BossProfileSoundInfo soundInfo;
	arraySounds.GetArray(foundIndex, soundInfo, sizeof(soundInfo));

	ArrayList soundPaths = soundInfo.Paths;
	if (soundPaths == null)
	{
		return;
	}
	char path[PLATFORM_MAX_PATH];
	soundPaths.GetString(GetRandomInt(0, soundPaths.Length - 1), path, sizeof(path));

	float myPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", myPos);

	if (path[0] != '\0')
	{
		if (StrContains(path, ".mp3", true) == -1 && StrContains(path, ".wav", true) == -1)
		{
			EmitGameSoundToAll(path, slender);
		}
		else
		{
			EmitSoundToAll(path, slender, soundInfo.Channel, soundInfo.Level, _, soundInfo.Volume, soundInfo.Pitch);
		}
	}
	if (NPCChaserGetEarthquakeFootstepsState(bossIndex))
	{
		UTIL_ScreenShake(myPos, NPCChaserGetEarthquakeFootstepsAmplitude(bossIndex),
		NPCChaserGetEarthquakeFootstepsFrequency(bossIndex), NPCChaserGetEarthquakeFootstepsDuration(bossIndex),
		NPCChaserGetEarthquakeFootstepsRadius(bossIndex), 0, NPCChaserGetEarthquakeFootstepsAirShakeState(bossIndex));
	}
}

void SlenderCastAnimEvent(int bossIndex, int event)
{
	if (bossIndex == -1)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	ArrayList arraySounds = GetBossProfileEventSounds(profile);
	ArrayList arrayIndexes = GetBossProfileEventIndexes(profile);

	if (!arraySounds || arrayIndexes == null)
	{
		return;
	}

	int foundIndex = arrayIndexes.FindValue(event);
	if (foundIndex == -1)
	{
		return;
	}

	SF2BossProfileSoundInfo soundInfo;
	arraySounds.GetArray(foundIndex, soundInfo, sizeof(soundInfo));

	ArrayList soundPaths = soundInfo.Paths;
	if (soundPaths == null)
	{
		return;
	}
	char path[PLATFORM_MAX_PATH];
	soundPaths.GetString(GetRandomInt(0, soundPaths.Length - 1), path, sizeof(path));

	if (path[0] != '\0')
	{
		if (StrContains(path, ".mp3", true) == -1 && StrContains(path, ".wav", true) == -1)
		{
			EmitGameSoundToAll(path, slender);
		}
		else
		{
			EmitSoundToAll(path, slender, soundInfo.Channel, soundInfo.Level, _, soundInfo.Volume, soundInfo.Pitch);
		}
	}
}

void SlenderCreateParticle(int bossIndex, const char[] sectionName, float particleZPos)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (g_RestartSessionEnabled)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	float slenderPosition[3], slenderAngles[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", slenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", slenderAngles);
	slenderPosition[2] += particleZPos;

	if (!DispatchParticleEffect(slender, sectionName, slenderPosition, slenderAngles, slenderPosition))
	{
		int particleEnt = CreateEntityByName("info_particle_system");

		if (IsValidEntity(particleEnt))
		{
			TeleportEntity(particleEnt, slenderPosition, slenderAngles, NULL_VECTOR);

			DispatchKeyValue(particleEnt, "targetname", "tf2particle");
			DispatchKeyValue(particleEnt, "effect_name", sectionName);
			DispatchSpawn(particleEnt);
			ActivateEntity(particleEnt);
			AcceptEntityInput(particleEnt, "start");
			CreateTimer(0.1, Timer_KillEntity, particleEnt, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void SlenderCreateParticleAttach(int bossIndex, const char[] sectionName, float particleZPos, int client)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (g_RestartSessionEnabled)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	float playerPosition[3], playerAngles[3];
	if (IsValidClient(client))
	{
		GetClientAbsOrigin(client, playerPosition);
		GetClientEyeAngles(client, playerAngles);
	}
	else
	{
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", playerPosition);
		GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", playerAngles);
	}
	playerPosition[2] += particleZPos;

	if (!DispatchParticleEffect(slender, sectionName, playerPosition, playerAngles, playerPosition))
	{
		int particleEnt = CreateEntityByName("info_particle_system");

		if (IsValidEntity(particleEnt))
		{
			TeleportEntity(particleEnt, playerPosition, playerAngles, NULL_VECTOR);

			DispatchKeyValue(particleEnt, "targetname", "tf2particle");
			DispatchKeyValue(particleEnt, "effect_name", sectionName);
			DispatchSpawn(particleEnt);
			ActivateEntity(particleEnt);
			AcceptEntityInput(particleEnt, "start");
			CreateTimer(0.1, Timer_KillEntity, particleEnt, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

void SlenderCreateParticleBeamClient(int bossIndex, const char[] sectionName, float particleZPos, int client)
{
	if (bossIndex == -1)
	{
		return;
	}

	if (g_RestartSessionEnabled)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	float slenderPosition[3], slenderAngles[3], playerPosition[3];
	if (IsValidClient(client))
	{
		GetClientAbsOrigin(client, playerPosition);
	}
	else
	{
		GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", playerPosition);
	}
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", slenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", slenderAngles);
	slenderPosition[2] += particleZPos;
	playerPosition[2] += particleZPos;

	DispatchParticleEffectBeam(slender, sectionName, slenderPosition, slenderAngles, playerPosition);
}

void SlenderCreateParticleSpawnEffect(int bossIndex, bool despawn = false)
{
	if (bossIndex == -1)
	{
		return;
	}

	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	char particle[PLATFORM_MAX_PATH], soundEffect[PLATFORM_MAX_PATH];
	float volume;
	int pitch;
	if (!despawn)
	{
		GetBossProfileSpawnParticleName(profile, particle, sizeof(particle));
		GetBossProfileSpawnParticleSound(profile, soundEffect, sizeof(soundEffect));
		volume = GetBossProfileSpawnParticleSoundVolume(profile);
		pitch = GetBossProfileSpawnParticleSoundPitch(profile);
	}
	else
	{
		GetBossProfileDespawnParticleName(profile, particle, sizeof(particle));
		GetBossProfileDespawnParticleSound(profile, soundEffect, sizeof(soundEffect));
		volume = GetBossProfileDespawnParticleSoundVolume(profile);
		pitch = GetBossProfileDespawnParticleSoundPitch(profile);
	}

	float slenderPosition[3], slenderAngles[3], offsetPos[3];
	GetEntPropVector(slender, Prop_Data, "m_vecAbsOrigin", slenderPosition);
	GetEntPropVector(slender, Prop_Data, "m_angAbsRotation", slenderAngles);
	GetBossProfileSpawnParticleOrigin(profile, offsetPos);
	AddVectors(offsetPos, slenderPosition, slenderPosition);

	if (!DispatchParticleEffect(slender, particle, slenderPosition, slenderAngles, slenderPosition))
	{
		int particleEnt = CreateEntityByName("info_particle_system");

		if (IsValidEntity(particleEnt))
		{
			TeleportEntity(particleEnt, slenderPosition, slenderAngles, NULL_VECTOR);

			DispatchKeyValue(particleEnt, "targetname", "tf2particle");
			DispatchKeyValue(particleEnt, "effect_name", particle);
			DispatchSpawn(particleEnt);
			ActivateEntity(particleEnt);
			AcceptEntityInput(particleEnt, "start");

			CreateTimer(0.1, Timer_KillEntity, particleEnt, TIMER_FLAG_NO_MAPCHANGE);
		}
	}

	if (soundEffect[0] != '\0')
	{
		EmitSoundToAll(soundEffect, slender, SNDCHAN_AUTO, SNDLEVEL_SCREAMING, _, volume, pitch);
	}
}

// As time passes on, we have to get more aggressive in order to successfully peak the target's
// stress level in the allotted duration we're given. Otherwise we'll be forced to place him
// in a rest period.

// Teleport progressively closer as time passes in attempt to increase the target's stress level.
// Maximum minimum range is capped by the boss's anger level.

static Action Timer_SlenderTeleportThink(Handle timer, any bossIndex)
{
	if (bossIndex == -1)
	{
		return Plugin_Stop;
	}
	if (timer != g_SlenderThink[bossIndex])
	{
		return Plugin_Stop;
	}

	if (SF_IsBoxingMap())
	{
		return Plugin_Stop;
	}

	if (SF_IsRenevantMap() && GetRoundState() != SF2RoundState_Escape)
	{
		return Plugin_Continue;
	}

	if (NPCGetFlags(bossIndex) & SFF_NOTELEPORT)
	{
		return Plugin_Continue;
	}

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	if (!NPCIsTeleportAllowed(bossIndex, difficulty))
	{
		return Plugin_Continue;
	}

	// Check to see if anyone's looking at me before doing anything.
	if (PeopleCanSeeSlender(bossIndex, _, false))
	{
		return Plugin_Continue;
	}
	if (NPCGetTeleportType(bossIndex) == 2)
	{
		int bossEnt = NPCGetEntIndex(bossIndex);
		if (bossEnt && bossEnt != INVALID_ENT_REFERENCE)
		{
			if (NPCGetType(bossIndex) == SF2BossType_Chaser)
			{
				// Check to see if it's a good time to teleport away.
				int state = g_SlenderState[bossIndex];
				if (state == STATE_IDLE || state == STATE_WANDER)
				{
					if (GetGameTime() < g_SlenderTimeUntilKill[bossIndex])
					{
						return Plugin_Continue;
					}
				}
				else
				{
					if (GetGameTime() >= g_SlenderTimeUntilKill[bossIndex])
					{
						g_SlenderTimeUntilKill[bossIndex] = GetGameTime() + NPCGetIdleLifetime(bossIndex, difficulty);
					}
					return Plugin_Continue;
				}
			}
			else if (NPCGetType(bossIndex) == SF2BossType_Statue)
			{
				if (g_SlenderStatueIdleLifeTime[bossIndex] > GetGameTime())
				{
					return Plugin_Continue;
				}
			}
		}
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	if (IsRoundPlaying())
	{
		if (GetGameTime() >= g_SlenderNextTeleportTime[bossIndex])
		{
			float teleportTime = GetRandomFloat(NPCGetTeleportTimeMin(bossIndex, difficulty), NPCGetTeleportTimeMax(bossIndex, difficulty));
			g_SlenderNextTeleportTime[bossIndex] = GetGameTime() + teleportTime;
			bool ignoreFuncNavPrefer = g_NpcHasIgnoreNavPrefer[bossIndex];

			int teleportTarget = EntRefToEntIndex(g_SlenderTeleportTarget[bossIndex]);

			if (!teleportTarget || teleportTarget == INVALID_ENT_REFERENCE)
			{
				// We don't have any good targets. Remove myself for now.
				if (SlenderCanRemove(bossIndex))
				{
					RemoveSlender(bossIndex);
				}

				#if defined DEBUG
				SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: no good target, removing...", bossIndex);
				#endif
			}
			else
			{
				float teleportMinRange = g_SlenderTeleportMinRange[bossIndex][difficulty];
				bool shouldBeBehindObstruction = false;
				if (NPCGetTeleportType(bossIndex) == 2)
				{
					shouldBeBehindObstruction = true;
				}
				float navPos[3];
				CBaseCombatCharacter tempCharacter = CBaseCombatCharacter(teleportTarget);
				CNavArea targetArea = tempCharacter.GetLastKnownArea();
				if (targetArea != NULL_AREA)
				{
					targetArea.GetCenter(navPos);
				}

				CNavArea area = TheNavMesh.GetNearestNavArea(navPos, false, _, false, false);
				if (area != NULL_AREA)
				{
					SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(area, g_SlenderTeleportMaxRange[bossIndex][difficulty]);
					int areaCount = collector.Count();
					ArrayList areaArray = new ArrayList(1, areaCount);
					int validAreaCount = 0;
					for (int i = 0; i < areaCount; i++)
					{
						if (collector.Get(i).GetCostSoFar() >= teleportMinRange)
						{
							areaArray.Set(validAreaCount, i);
							validAreaCount++;
						}
						if (ignoreFuncNavPrefer && NavHasFuncPrefer(collector.Get(i)))
						{
							continue;
						}
					}

					areaArray.Resize(validAreaCount);
					area = NULL_AREA;
					int randomArea = 0, randomCell = 0;
					float spawnPos[3], playerPos[3];
					bool canSpawn = true;

					while (validAreaCount > 1)
					{
						randomCell = GetRandomInt(0, validAreaCount - 1);
						randomArea = areaArray.Get(randomCell);
						area = collector.Get(randomArea);
						area.GetCenter(spawnPos);
						spawnPos[2] += 15.0;

						float traceMins[3];
						traceMins[0] = g_SlenderDetectMins[bossIndex][0];
						traceMins[1] = g_SlenderDetectMins[bossIndex][1];
						traceMins[2] = 0.0;

						float traceMaxs[3];
						traceMaxs[0] = g_SlenderDetectMaxs[bossIndex][0];
						traceMaxs[1] = g_SlenderDetectMaxs[bossIndex][1];
						traceMaxs[2] = 0.0;

						TR_TraceHullFilter(spawnPos, spawnPos, traceMins, traceMaxs, MASK_NPCSOLID, TraceRayDontHitEntity);
						if (TR_DidHit())
						{
							area = NULL_AREA;
							validAreaCount--;
							int findValue = areaArray.FindValue(randomCell);
							if (findValue != -1)
							{
								areaArray.Erase(findValue);
							}
						}
						else
						{
							canSpawn = true;
							for (int i = 1; i <= MaxClients; i++)
							{
								if (!IsValidClient(i) || !IsPlayerAlive(i) || IsClientInGhostMode(i) || g_PlayerEliminated[i]
									|| g_PlayerProxy[i] || DidClientEscape(i))
								{
									continue;
								}
								if (!canSpawn)
								{
									continue;
								}

								GetClientAbsOrigin(i, playerPos);
								if (GetVectorSquareMagnitude(spawnPos, playerPos) <= SquareFloat(teleportMinRange))
								{
									area = NULL_AREA;
									validAreaCount--;
									int findValue = areaArray.FindValue(randomCell);
									if (findValue != -1 && findValue < validAreaCount)
									{
										areaArray.Erase(findValue);
									}
									canSpawn = false;
								}
							}

							// Check visibility.
							if (!g_SlenderTeleportIgnoreVis[bossIndex] && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false))
							{
								area = NULL_AREA;
								validAreaCount--;
								int findValue = areaArray.FindValue(randomCell);
								if (findValue != -1)
								{
									areaArray.Erase(findValue);
								}
								canSpawn = false;
							}

							AddVectors(spawnPos, g_SlenderEyePosOffset[bossIndex], spawnPos);

							if (!g_SlenderTeleportIgnoreVis[bossIndex] && IsPointVisibleToAPlayer(spawnPos, !shouldBeBehindObstruction, false))
							{
								area = NULL_AREA;
								validAreaCount--;
								int findValue = areaArray.FindValue(randomCell);
								if (findValue != -1)
								{
									areaArray.Erase(findValue);
								}
								canSpawn = false;
							}

							SubtractVectors(spawnPos, g_SlenderEyePosOffset[bossIndex], spawnPos);

							// Look for copies
							if (NPCGetFlags(bossIndex) & SFF_COPIES && canSpawn)
							{
								float minDistBetweenBosses = GetBossProfileTeleportCopyDistance(profile);

								for (int bossCheck = 0; bossCheck < MAX_BOSSES; bossCheck++)
								{
									if (bossCheck == bossIndex ||
										NPCGetUniqueID(bossCheck) == -1 ||
										(g_SlenderCopyMaster[bossIndex] != bossCheck && g_SlenderCopyMaster[bossIndex] != g_SlenderCopyMaster[bossCheck]))
									{
										continue;
									}

									int bossEntCheck = NPCGetEntIndex(bossCheck);
									if (!bossEntCheck || bossEntCheck == INVALID_ENT_REFERENCE)
									{
										continue;
									}

									float tempPos[3];
									SlenderGetAbsOrigin(bossCheck, tempPos);

									if (GetVectorSquareMagnitude(spawnPos, tempPos) <= SquareFloat(minDistBetweenBosses))
									{
										area = NULL_AREA;
										validAreaCount--;
										int findValue = areaArray.FindValue(randomCell);
										if (findValue != -1)
										{
											areaArray.Erase(findValue);
										}
										canSpawn = false;
										break;
									}
								}
							}

							if (canSpawn)
							{
								SpawnSlender(bossIndex, spawnPos);

								if (g_PlayerIsExitCamping[teleportTarget])
								{
									g_SlenderTeleportTargetIsCamping[bossIndex] = true;
								}
								else
								{
									g_SlenderTeleportTargetIsCamping[bossIndex] = false;
								}

								if (NPCGetFlags(bossIndex) & SFF_HASJUMPSCARE)
								{
									bool didJumpScare = false;

									for (int i = 1; i <= MaxClients; i++)
									{
										if (!IsClientInGame(i) || !IsPlayerAlive(i) || g_PlayerEliminated[i] || IsClientInGhostMode(i))
										{
											continue;
										}

										if (PlayerCanSeeSlender(i, bossIndex, false))
										{
											if ((NPCGetDistanceFromEntity(bossIndex, i) <= SquareFloat(NPCGetJumpscareDistance(bossIndex, difficulty)) && GetGameTime() >= g_SlenderNextJumpScare[bossIndex]) ||
											(PlayerCanSeeSlender(i, bossIndex) && !GetBossProfileJumpscareNoSight(profile)))
											{
												didJumpScare = true;

												float jumpScareDuration = NPCGetJumpscareDuration(bossIndex, difficulty);
												ClientDoJumpScare(i, bossIndex, jumpScareDuration);
											}
										}
									}

									if (didJumpScare)
									{
										g_SlenderNextJumpScare[bossIndex] = GetGameTime() + NPCGetJumpscareCooldown(bossIndex, difficulty);
									}
								}
								break;
							}
						}
					}

					if (validAreaCount <= 0)
					{
						RemoveSlender(bossIndex);
					}

					delete collector;
					delete areaArray;
				}
			}
		}
		else
		{
			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_TELEPORTATION, 0, "Teleport for boss %d: failed because of teleport time (curtime: %f, teletime: %f)", bossIndex, GetGameTime(), g_SlenderNextTeleportTime[bossIndex]);
			#endif
		}
	}

	return Plugin_Continue;
}

bool SlenderMarkAsFake(int bossIndex)
{
	int bossFlags = NPCGetFlags(bossIndex);
	if (bossFlags & SFF_MARKEDASFAKE)
	{
		return false;
	}

	int slender = NPCGetEntIndex(bossIndex);
	g_SlenderEnt[bossIndex] = INVALID_ENT_REFERENCE;
	g_SlenderModel[bossIndex] = INVALID_ENT_REFERENCE;

	NPCSetFlags(bossIndex, bossFlags | SFF_MARKEDASFAKE);

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	g_SlenderFakeTimer[bossIndex] = CreateTimer(3.0, Timer_SlenderMarkedAsFake, bossIndex, TIMER_FLAG_NO_MAPCHANGE);

	CreateTimer(2.0, Timer_KillEntity, EntIndexToEntRef(slender), TIMER_FLAG_NO_MAPCHANGE);

	if (slender && slender != INVALID_ENT_REFERENCE)
	{
		int flags = GetEntProp(slender, Prop_Send, "m_usSolidFlags");
		if (!(flags & 0x0004))
		{
			flags |= 0x0004; // 	FSOLID_NOT_SOLID
		}
		if (!(flags & 0x0008))
		{
			flags |= 0x0008; // 	FSOLID_TRIGGER
		}
		SetEntProp(slender, Prop_Send, "m_usSolidFlags", flags);

		if (g_SlenderEngineSound[bossIndex][0] != '\0')
		{
			StopSound(slender, SNDCHAN_STATIC, g_SlenderEngineSound[bossIndex]);
		}

		SetEntPropFloat(slender, Prop_Send, "m_flPlaybackRate", 0.0);
		SetEntityRenderFx(slender, RENDERFX_FADE_FAST);
	}

	return true;
}

static Action Timer_SlenderMarkedAsFake(Handle timer, any data)
{
	if (timer != g_SlenderFakeTimer[data])
	{
		return Plugin_Stop;
	}

	NPCRemove(data);

	return Plugin_Stop;
}

stock int SpawnSlenderModel(int bossIndex, const float pos[3], bool deathCam = false)
{
	if (NPCGetUniqueID(bossIndex) == -1)
	{
		LogError("Could not spawn boss model: boss does not exist!");
		return -1;
	}

	char buffer[PLATFORM_MAX_PATH], profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	float playbackRate, tempFootsteps, cycle;
	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	GetSlenderModel(bossIndex, _, buffer, sizeof(buffer));
	if (buffer[0] == '\0')
	{
		LogError("Could not spawn boss model: model is invalid!");
		return -1;
	}
	float modelScale = NPCGetModelScale(bossIndex);
	if (modelScale <= 0.0)
	{
		LogError("Could not spawn boss model: model scale is less than or equal to 0.0!");
		return -1;
	}
	int modelSkin = NPCGetModelSkin(bossIndex);
	if (modelSkin < 0)
	{
		LogError("Could not spawn boss model: model skin is less than 0!");
		return -1;
	}

	int slenderModel = CreateEntityByName("prop_dynamic_override");
	if (slenderModel != -1)
	{
		SetEntityModel(slenderModel, buffer);

		TeleportEntity(slenderModel, pos, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(slenderModel);
		ActivateEntity(slenderModel);
		SF2BossProfileMasterAnimationsData animData;
		GetBossProfileAnimationsData(profile, animData);
		float tempDuration;
		int tempIndex;
		if (!deathCam)
		{
			animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle], difficulty, buffer, sizeof(buffer), playbackRate, tempDuration, cycle, g_SlenderFootstepTime[bossIndex], tempIndex);
		}
		else
		{
			bool animationFound = animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_DeathCam], difficulty, buffer, sizeof(buffer), playbackRate, tempDuration, cycle, tempFootsteps, tempIndex);
			if (!animationFound || strcmp(buffer,"") <= 0)
			{
				animData.GetAnimation(g_SlenderAnimationsList[SF2BossAnimation_Idle], difficulty, buffer, sizeof(buffer), playbackRate, tempDuration, cycle, g_SlenderFootstepTime[bossIndex], tempIndex);
			}
		}
		if (buffer[0] != '\0')
		{
			SetVariantString(buffer);
			AcceptEntityInput(slenderModel, "SetDefaultAnimation");
			SetVariantString(buffer);
			AcceptEntityInput(slenderModel, "SetAnimation");
			AcceptEntityInput(slenderModel, "DisableCollision");
		}

		SetVariantFloat(playbackRate);
		AcceptEntityInput(slenderModel, "SetPlaybackRate");
		SetEntPropFloat(slenderModel, Prop_Data, "m_flCycle", cycle);

		if (SF_SpecialRound(SPECIALROUND_TINYBOSSES))
		{
			float scaleModel = modelScale * 0.5;
			SetEntPropFloat(slenderModel, Prop_Send, "m_flModelScale", scaleModel);
		}
		else
		{
			SetEntPropFloat(slenderModel, Prop_Send, "m_flModelScale", modelScale);
		}
		if (NPCGetModelSkinMax(bossIndex) > 0)
		{
			int randomSkin = GetRandomInt(0, NPCGetModelSkinMax(bossIndex));
			SetEntProp(slenderModel, Prop_Send, "m_nSkin", randomSkin);
		}
		else
		{
			if (GetBossProfileSkinDifficultyState(profile))
			{
				SetEntProp(slenderModel, Prop_Send, "m_nSkin", NPCGetModelSkinDifficulty(bossIndex, difficulty));
			}
			else
			{
				SetEntProp(slenderModel, Prop_Send, "m_nSkin", modelSkin);
			}
		}
		if (NPCGetModelBodyGroupsMax(bossIndex) > 0)
		{
			int randomBody = GetRandomInt(0, NPCGetModelBodyGroupsMax(bossIndex));
			SetEntProp(slenderModel, Prop_Send, "m_nBody", randomBody);
		}
		else
		{
			if (GetBossProfileBodyGroupsDifficultyState(profile))
			{
				SetEntProp(slenderModel, Prop_Send, "m_nBody", NPCGetModelBodyGroupsDifficulty(bossIndex, difficulty));
			}
			else
			{
				SetEntProp(slenderModel, Prop_Send, "m_nBody", NPCGetModelBodyGroups(bossIndex));
			}
		}

		SetEntProp(slenderModel, Prop_Send, "m_nBody", GetBossProfileBodyGroups(profile));

		// Create special effects.
		SetEntityRenderMode(slenderModel, view_as<RenderMode>(g_SlenderRenderMode[bossIndex]));
		SetEntityRenderFx(slenderModel, view_as<RenderFx>(g_SlenderRenderFX[bossIndex]));
		SetEntityRenderColor(slenderModel, g_SlenderRenderColor[bossIndex][0], g_SlenderRenderColor[bossIndex][1], g_SlenderRenderColor[bossIndex][2], g_SlenderRenderColor[bossIndex][3]);
	}

	return slenderModel;
}

stock bool PlayerCanSeeSlender(int client,int bossIndex, bool checkFOV=true, bool checkBlink=false, bool checkEliminated=true)
{
	return IsNPCVisibleToPlayer(bossIndex, client, checkFOV, checkBlink, checkEliminated);
}

stock bool PeopleCanSeeSlender(int bossIndex, bool checkFOV=true, bool checkBlink=false, bool checkEliminated = true)
{
	return IsNPCVisibleToAPlayer(bossIndex, checkFOV, checkBlink, checkEliminated);
}

stock bool SlenderAddGlow(int bossIndex, const char[] attachment="", int color[4] = {255, 255, 255, 255})
{
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return false;
	}

	char buffer[PLATFORM_MAX_PATH];
	GetEntPropString(slender, Prop_Data, "m_ModelName", buffer, sizeof(buffer));

	if (buffer[0] == '\0')
	{
		return false;
	}

	// This is so much simpler, I don't know why I didn't make this earlier.
	int glow = TF2_CreateGlow(slender);
	if (IsValidEntity(glow))
	{
		SDKHook(glow, SDKHook_SetTransmit, Hook_SlenderGlowSetTransmit);

		g_NpcGlowEntity[bossIndex] = EntIndexToEntRef(glow);
		//Set our desired glow color
		SetVariantColor(color);
		AcceptEntityInput(glow, "SetGlowColor");
		g_DHookShouldTransmit.HookEntity(Hook_Pre, glow, Hook_EntityShouldTransmit);
		g_DHookUpdateTransmitState.HookEntity(Hook_Pre, glow, Hook_GlowUpdateTransmitState);
		SetEntityTransmitState(glow, FL_EDICT_FULLCHECK);

		return true;
	}

	return false;
}

void SlenderRemoveGlow(int bossIndex)
{
	int slender = NPCGetEntIndex(bossIndex);
	if (!slender || slender == INVALID_ENT_REFERENCE)
	{
		return;
	}

	int glow = EntRefToEntIndex(g_NpcGlowEntity[bossIndex]);
	if (glow != INVALID_ENT_REFERENCE)
	{
		RemoveEntity(glow);
		g_NpcGlowEntity[bossIndex] = INVALID_ENT_REFERENCE;
	}
}

bool IsNPCVisibleToPlayer(int npcIndex,int client, bool checkFOV=true, bool checkBlink=false, bool checkEliminated=true)
{
	if (!NPCIsValid(npcIndex))
	{
		return false;
	}

	int npcEnt = NPCGetEntIndex(npcIndex);
	if (npcEnt && npcEnt != INVALID_ENT_REFERENCE)
	{
		float eyePos[3];
		NPCGetEyePosition(npcIndex, eyePos);
		return IsPointVisibleToPlayer(client, eyePos, checkFOV, checkBlink, checkEliminated);
	}

	return false;
}

bool IsNPCVisibleToAPlayer(int npcIndex, bool checkFOV=true, bool checkBlink=false, bool checkEliminated=true)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsNPCVisibleToPlayer(npcIndex, client, checkFOV, checkBlink, checkEliminated))
		{
			return true;
		}
	}

	return false;
}

bool CanNPCSeePlayerNonTransparent(int npcIndex, int client)
{
	if (!NPCIsValid(npcIndex))
	{
		return false;
	}

	if (!IsValidClient(client))
	{
		return false;
	}

	bool attackEliminated = view_as<bool>(NPCGetFlags(npcIndex) & SFF_ATTACKWAITERS);

	if (!IsTargetValidForSlender(client, attackEliminated))
	{
		return false;
	}

	int npcEnt = NPCGetEntIndex(npcIndex);
	if (npcEnt && npcEnt != INVALID_ENT_REFERENCE)
	{
		float eyePos[3], clientPos[3];
		NPCGetEyePosition(npcIndex, eyePos);
		GetClientEyePosition(client, clientPos);
		Handle trace = TR_TraceRayFilterEx(eyePos,
			clientPos,
			MASK_NPCSOLID,
			RayType_EndPoint,
			TraceRayBossVisibility,
			npcEnt);

		bool isVisible = !TR_DidHit(trace);
		delete trace;

		return isVisible;
	}
	return false;
}

float NPCGetDistanceFromPoint(int npcIndex, const float point[3])
{
	int npcEnt = NPCGetEntIndex(npcIndex);
	if (npcEnt && npcEnt != INVALID_ENT_REFERENCE)
	{
		float pos[3];
		SlenderGetAbsOrigin(npcIndex, pos);

		return GetVectorSquareMagnitude(pos, point);
	}

	return -1.0;
}

float NPCGetDistanceFromEntity(int npcIndex,int ent)
{
	if (!IsValidEntity(ent))
	{
		return -1.0;
	}

	float pos[3];
	GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", pos);

	return NPCGetDistanceFromPoint(npcIndex, pos);
}

bool TraceRayBossVisibility(int entity,int mask, any data)
{
	if (entity == data || IsValidClient(entity))
	{
		return false;
	}
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	int bossIndex = NPCGetFromEntIndex(entity);
	if (entity <= MAX_BOSSES)
	{
		return false;
	}
	if (bossIndex != -1)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc") == 0 || strcmp(class, "base_boss") == 0)
		{
			return false;
		}
	}
	return true;
}

bool TraceRayDontHitCharacters(int entity,int mask, any data)
{
	if (entity > 0 && entity <= MaxClients)
	{
		return false;
	}

	int bossIndex = NPCGetFromEntIndex(entity);
	if (bossIndex != -1)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_boss") == 0)
		{
			return false;
		}
	}

	return true;
}

bool TraceRayDontHitAnyEntity(int entity,int mask,any data)
{
	if (entity == data)
	{
		return false;
	}
	if (entity > 0 && entity <= MaxClients)
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	int bossIndex = NPCGetFromEntIndex(entity);
	if (bossIndex != -1)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc") == 0 || strcmp(class, "base_boss") == 0)
		{
			return false;
		}
	}
	return true;
}

bool TraceRayDontHitAnyEntity_Pathing(int entity, int contentsMask, int desiredcollisiongroup)
{
	if ((entity > 0 && entity <= MaxClients))
	{
		if (g_PlayerProxy[entity] || IsClientInGhostMode(entity))
		{
			return false;
		}
	}
	int bossIndex = NPCGetFromEntIndex(entity);
	if (bossIndex != -1)
	{
		return false;
	}
	if (IsValidEntity(entity))
	{
		char class[64];
		GetEntityClassname(entity, class, sizeof(class));
		if (strcmp(class, "base_npc") == 0 || strcmp(class, "base_boss") == 0)
		{
			return false;
		}
	}
	return true;
}

bool TraceRayDontHitCharactersOrEntity(int entity,int mask, any data)
{
	if (entity == data)
	{
		return false;
	}

	if (entity > 0 && entity <= MaxClients)
	{
		return false;
	}
	int bossIndex = NPCGetFromEntIndex(entity);
	if (bossIndex != -1)
	{
		return false;
	}
	if (IsValidEntity(entity) && CBaseEntity(entity).IsCombatCharacter())
	{
		return false;
	}

	return true;
}

bool TraceRayDontHitAnything(int entity,int mask, any data)
{
	return false;
}

/**
 *	Calculates the position and spawn point for a proxy.
 */
bool SpawnProxy(int client, int bossIndex, float teleportPos[3], int &spawnPointEnt=-1)
{
	spawnPointEnt = -1;

	if (bossIndex == -1 || client <= 0)
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss index and or client are not valid!");
		#endif
		return false;
	}

	if (!IsRoundPlaying())
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not spawn proxies because the round is not playing!", bossIndex);
		#endif
		return false;
	}

	if (!(NPCGetFlags(bossIndex) & SFF_PROXIES))
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d cannot spawn proxies!");
		#endif
		return false;
	}

	char profile[SF2_MAX_PROFILE_NAME_LENGTH];
	NPCGetProfile(bossIndex, profile, sizeof(profile));

	int difficulty = GetLocalGlobalDifficulty(bossIndex);

	ArrayList spawnPoints = new ArrayList();
	char name[32];
	int ent = -1;
	while ((ent = FindEntityByClassname(ent, "info_target")) != -1)
	{
		GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
		if (strcmp(name, "sf2_proxy_spawnpoint") == 0)
		{
			spawnPoints.Push(ent);
		}
	}

	ent = -1;
	while ((ent = FindEntityByClassname(ent, "sf2_info_player_proxyspawn")) != -1)
	{
		SF2PlayerProxySpawnEntity spawnPoint = SF2PlayerProxySpawnEntity(ent);
		if (!spawnPoint.IsValid() || !spawnPoint.Enabled)
		{
			continue;
		}

		spawnPoints.Push(ent);
	}

	ent = -1;
	if (spawnPoints.Length > 0)
	{
		ent = spawnPoints.Get(GetRandomInt(0, spawnPoints.Length - 1));
	}

	delete spawnPoints;

	if (ent && ent != -1)
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d found a spawnpoint entity %d.", bossIndex, ent);
		#endif
		spawnPointEnt = ent;
		GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", teleportPos);
		return true;
	}

	// If the map has no pre defined spawn points, search surrounding CNavAreas around target.

	int teleportTarget = EntRefToEntIndex(g_SlenderProxyTarget[bossIndex]);
	if (!teleportTarget || teleportTarget == INVALID_ENT_REFERENCE)
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d has no proxy target, aborting!", bossIndex);
		#endif
		return false;
	}

	if (!IsPlayerAlive(teleportTarget))
	{
		return false;
	}

	float teleportMinRange = g_SlenderProxyTeleportMinRange[bossIndex][difficulty];
	CBaseCombatCharacter tempCharacter = CBaseCombatCharacter(teleportTarget);
	CNavArea targetArea = tempCharacter.GetLastKnownArea();
	int teleportAreaIndex = -1;

	if (targetArea != NULL_AREA)
	{
		// Search outwards until travel distance is at maximum range.
		ArrayList areaArray = new ArrayList(2);
		SurroundingAreasCollector collector = TheNavMesh.CollectSurroundingAreas(targetArea, g_SlenderProxyTeleportMaxRange[bossIndex][difficulty], _, _);
		{
			int poppedAreas;

			for (int areaIndex = 0, maxCount = collector.Count(); areaIndex < maxCount; areaIndex++)
			{
				CNavArea Area = collector.Get(areaIndex);

				// Check flags.
				if (Area.GetAttributes() & NAV_MESH_NO_HOSTAGES)
				{
					// Don't spawn/teleport at areas marked with the "NO HOSTAGES" flag.
					continue;
				}

				int index = areaArray.Push(Area);
				areaArray.Set(index, Area.GetCostSoFar(), 1);
				poppedAreas++;
			}

			#if defined DEBUG
			SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "Teleport for boss %d: collected %d areas", bossIndex, poppedAreas);
			#endif
			delete collector;
		}

		ArrayList areaArrayClose = new ArrayList(4);
		ArrayList areaArrayAverage = new ArrayList(4);
		ArrayList areaArrayFar = new ArrayList(4);

		for (int i = 1; i <= 3; i++)
		{
			float rangeSectionMin = teleportMinRange + (g_SlenderProxyTeleportMaxRange[bossIndex][difficulty] - teleportMinRange) * (float(i - 1) / 3.0);
			float rangeSectionMax = teleportMinRange + (g_SlenderProxyTeleportMaxRange[bossIndex][difficulty] - teleportMinRange) * (float(i) / 3.0);

			for (int i2 = 0, size = areaArray.Length; i2 < size; i2++)
			{
				CNavArea area = areaArray.Get(i2);

				float areaSpawnPoint[3];
				area.GetCenter(areaSpawnPoint);

				// Check space. First raise to HalfHumanHeight * 2, then trace downwards to get ground level.
				float traceStartPos[3];
				traceStartPos[0] = areaSpawnPoint[0];
				traceStartPos[1] = areaSpawnPoint[1];
				traceStartPos[2] = areaSpawnPoint[2] + (HalfHumanHeight * 2.0);

				float traceMins[3];
				traceMins[0] = HULL_TF2PLAYER_MINS[0];
				traceMins[1] = HULL_TF2PLAYER_MINS[1];
				traceMins[2] = 0.0;

				float traceMaxs[3];
				traceMaxs[0] = HULL_TF2PLAYER_MAXS[0];
				traceMaxs[1] = HULL_TF2PLAYER_MAXS[1];
				traceMaxs[2] = 0.0;

				Handle trace = TR_TraceHullFilterEx(traceStartPos,
					areaSpawnPoint,
					traceMins,
					traceMaxs,
					MASK_NPCSOLID,
					TraceRayDontHitEntity,
					teleportTarget);

				float traceHitPos[3];
				TR_GetEndPosition(traceHitPos, trace);
				traceHitPos[2] += 1.0;
				delete trace;

				if (TR_PointOutsideWorld(traceHitPos))
				{
					#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d spawn proxy %d because the position is outside the world!", bossIndex, client);
					#endif
					continue;
				}
				if (IsSpaceOccupiedPlayer(traceHitPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client))
				{
					traceHitPos[2] +=5.0;
					if (IsSpaceOccupiedPlayer(traceHitPos, HULL_TF2PLAYER_MINS, HULL_TF2PLAYER_MAXS, client))
					{
						#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not spawn proxy %d because the space is occupied!", bossIndex, client);
						#endif
						continue;
					}
				}
				if (IsSpaceOccupiedNPC(traceHitPos,
					HULL_TF2PLAYER_MINS,
					HULL_TF2PLAYER_MAXS,
					client))
				{
					#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not spawn proxy %d because the space is occupied by another boss!", bossIndex, client);
					#endif
					continue;
				}

				areaSpawnPoint[0] = traceHitPos[0];
				areaSpawnPoint[1] = traceHitPos[1];
				areaSpawnPoint[2] = traceHitPos[2];

				// Check visibility.
				if (IsPointVisibleToAPlayer(areaSpawnPoint, false, false) && !SF_IsBoxingMap() && !SF_IsRaidMap() && !SF_IsProxyMap() && !SF_BossesChaseEndlessly())
				{
					#if defined DEBUG
					SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not spawn proxy %d because a player sees the spawn position!", bossIndex, client);
					#endif
					continue;
				}

				bool tooNear = false;

				// Check minimum range with players.
				for (int teleportClient = 1; teleportClient <= MaxClients; teleportClient++)
				{
					if (!IsClientInGame(teleportClient) ||
						!IsPlayerAlive(teleportClient) ||
						g_PlayerEliminated[teleportClient] ||
						IsClientInGhostMode(teleportClient) ||
						DidClientEscape(teleportClient))
					{
						continue;
					}

					float tempPos[3];
					GetClientAbsOrigin(teleportClient, tempPos);

					if (GetVectorSquareMagnitude(areaSpawnPoint, tempPos) <= SquareFloat(g_SlenderProxyTeleportMinRange[bossIndex][difficulty]))
					{
						#if defined DEBUG
						SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not spawn proxy %d because player %d is too close!", bossIndex, client, teleportClient);
						#endif
						tooNear = true;
						break;
					}
				}

				if (tooNear)
				{
					continue;	// This area is not compatible.
				}

				// Check travel distance and put in the appropriate arrays.
				float dist = view_as<float>(areaArray.Get(i2, 1));
				if (dist > rangeSectionMin && dist < rangeSectionMax)
				{
					int index = -1;
					ArrayList targetAreaArray = null;

					switch (i)
					{
						case 1:
						{
							index = areaArrayClose.Push(area);
							targetAreaArray = areaArrayClose;
						}
						case 2:
						{
							index = areaArrayAverage.Push(area);
							targetAreaArray = areaArrayAverage;
						}
						case 3:
						{
							index = areaArrayFar.Push(area);
							targetAreaArray = areaArrayFar;
						}
					}

					if (targetAreaArray != null && index != -1)
					{
						targetAreaArray.Set(index, areaSpawnPoint[0], 1);
						targetAreaArray.Set(index, areaSpawnPoint[1], 2);
						targetAreaArray.Set(index, areaSpawnPoint[2], 3);
					}
				}
			}
		}

		delete areaArray;

		int arrayIndex = -1;

		if (areaArrayClose.Length)
		{
			arrayIndex = GetRandomInt(0, areaArrayClose.Length - 1);
			teleportAreaIndex = areaArrayClose.Get(arrayIndex);
			teleportPos[0] = view_as<float>(areaArrayClose.Get(arrayIndex, 1));
			teleportPos[1] = view_as<float>(areaArrayClose.Get(arrayIndex, 2));
			teleportPos[2] = view_as<float>(areaArrayClose.Get(arrayIndex, 3));
		}
		else if (areaArrayAverage.Length)
		{
			arrayIndex = GetRandomInt(0, areaArrayAverage.Length - 1);
			teleportAreaIndex = areaArrayAverage.Get(arrayIndex);
			teleportPos[0] = view_as<float>(areaArrayAverage.Get(arrayIndex, 1));
			teleportPos[1] = view_as<float>(areaArrayAverage.Get(arrayIndex, 2));
			teleportPos[2] = view_as<float>(areaArrayAverage.Get(arrayIndex, 3));
		}
		else if (areaArrayFar.Length)
		{
			arrayIndex = GetRandomInt(0, areaArrayFar.Length - 1);
			teleportAreaIndex = areaArrayFar.Get(arrayIndex);
			teleportPos[0] = view_as<float>(areaArrayFar.Get(arrayIndex, 1));
			teleportPos[1] = view_as<float>(areaArrayFar.Get(arrayIndex, 2));
			teleportPos[2] = view_as<float>(areaArrayFar.Get(arrayIndex, 3));
		}
		delete areaArrayClose;
		delete areaArrayAverage;
		delete areaArrayFar;
	}

	if (teleportAreaIndex == -1)
	{
		#if defined DEBUG
		SendDebugMessageToPlayers(DEBUG_BOSS_PROXIES, 0, "[PROXIES] Boss %d could not find any areas to place proxy %d!", bossIndex, client);
		#endif
		return false;
	}

	return true;
}

#include "sf2/npc/npc_chaser.sp"
#include "sf2/npc/npc_chaser_takedamage.sp"